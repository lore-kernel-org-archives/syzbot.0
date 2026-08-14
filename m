Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2DF33C3C0E;
	Fri, 14 Aug 2026 12:05:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786709146; cv=none; b=WP4WCcBwlahHHnXIpOKfKZw18fraU67goibQ9HObGMNU0t+z2rxq7yJliR3F6+UHn4tjTP2yTS6xYnzfyQdsmlYLdRnWT6xGhE/cjNXM2CUtKQtdtFPneHypUj+27J+m8+7j33S5kTdJibCafL/OqSOIesCgEZzKTOklYU7q4Ro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786709146; c=relaxed/simple;
	bh=wHgkcx+gLEg3MCbif162eKeGremYqy9/bYgIB4PdpVg=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=g3z+IpQwgj0tzHEFq4XkwTul9qtMYvEMnpLZVKNt88U8IGq77JBfrwUAWNTjYgsRDyNsWz+rT8Kh2LPl6CSuUXxEy4dE9OdQk88Cx9OnKEngrSqCslVa4Xfeme2ToPXY1wUyYLQXYNWkLSXCP+paZIuib9KDVRzTQ1JChlyuLlg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AV5jqtWG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AV5jqtWG"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 06B061F000E9;
	Fri, 14 Aug 2026 12:05:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786709144;
	bh=yVqM3JsbIUZ9c+CjFtWZcNaDTtrVHKUsp3Gn6ZTIIBQ=;
	h=From:To:Cc:Subject:Date;
	b=AV5jqtWG6o/gKPQ87L4/5OE6IwTDFdHFZ2+Epb2p/1P91L1zxav1pqNsKRT6gPLDT
	 nd0y1CpApx//nyfg4fyOHkLPzNIbcQkGyvAPobhYOk1UmjQai9eDFyV/e387AconyI
	 pPDhmOWhwP+W67zYLNpu5O+SYjRVxFi+L3HsqgTwtDBFV4QQH78ab4yDBfU8qLgfdm
	 n9kdx4pMiinJPFbfZHGL9z0NyzRPUhubCDakCDpnLylLsMChnLmyDKldHOhNvIYAfr
	 dcgQ19rq+TS0isIvSSmK824+4mYR773JJwIyth4zInYxKD+2MPMd6c0i5dxDQBJZF3
	 swChn1e1g5VuA==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-bugs@googlegroups.com, Aleksandr Nogikh <nogikh@google.com>, <linux-sound@vger.kernel.org>, "Jaroslav Kysela" <perex@perex.cz>, "Takashi Iwai" <tiwai@suse.com>, "Takashi Iwai" <tiwai@suse.de>
Cc: broonie@kernel.org, cassiogabrielcontato@gmail.com, cezary.rojewski@intel.com, kees@kernel.org, linux-kernel@vger.kernel.org, syzbot@lists.linux.dev
Subject: [PATCH] ALSA: core: Fix use-after-free in snd_card_do_free()
Message-ID: <02042186-27b7-42a9-b64e-f93ce8fbe05a@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Fri, 14 Aug 2026 12:05:43 +0000 (UTC)

From: Aleksandr Nogikh <nogikh@google.com>

A use-after-free was detected in snd_card_do_free() when a sound card
managed by devres is unbound while a user-space application still holds an
open file descriptor.

For managed cards, the memory is allocated using devres_alloc(), and its
release function is set to __snd_card_release(), which calls
snd_card_free(). When the device is unbound, the unbind thread calls
snd_card_free(), which drops a reference to the card's device. If the user
thread still has an open file descriptor, the reference count does not
reach zero, and the unbind thread blocks on wait_for_completion(&released).

When the user thread closes the file descriptor, it drops the final
reference, invoking the device release callback release_card_device(),
which calls snd_card_do_free(). snd_card_do_free() performs cleanup and
calls complete(card->release_completion). This wakes up the unbind thread,
which returns from snd_card_free() and __snd_card_release(). The devres
core then immediately frees the memory block containing the snd_card
structure.

Meanwhile, the user thread continues execution in snd_card_do_free() and
evaluates `if (!card->managed)`. It reads the `managed` boolean from the
snd_card structure that was just freed by the unbind thread, triggering a
KASAN use-after-free.

Fix this by caching the value of card->managed in a local variable before
calling complete(). This ensures that the card pointer is not dereferenced
after the unbind thread has been woken up and potentially freed the card.

BUG: KASAN: use-after-free in snd_card_do_free sound/core/init.c:604
[inline]
BUG: KASAN: use-after-free in release_card_device+0x1ab/0x1b0
sound/core/init.c:153
Read of size 1 at addr ffff8881912ec909 by task syz-executor130/5857

Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 print_address_description+0x55/0x1e0 mm/kasan/report.c:378
 print_report+0x58/0x70 mm/kasan/report.c:482
 kasan_report+0x117/0x150 mm/kasan/report.c:595
 snd_card_do_free sound/core/init.c:604 [inline]
 release_card_device+0x1ab/0x1b0 sound/core/init.c:153
 device_release+0xc4/0x1f0 drivers/base/core.c:-1
 kobject_cleanup lib/kobject.c:689 [inline]
 kobject_release lib/kobject.c:720 [inline]
 kref_put include/linux/kref.h:65 [inline]
 kobject_put+0x222/0x550 lib/kobject.c:737
 snd_card_file_remove+0x331/0x390 sound/core/init.c:1125
 snd_pcm_release+0x12c/0x160 sound/core/pcm_native.c:2986
 __fput+0x418/0xa50 fs/file_table.c:512
 fput_close_sync+0x11f/0x240 fs/file_table.c:617
 __do_sys_close fs/open.c:1511 [inline]
 __se_sys_close fs/open.c:1496 [inline]
 __x64_sys_close+0x7e/0x110 fs/open.c:1496
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
 </TASK>

Fixes: e8ad415b7a55 ("ALSA: core: Add managed card creation")
Assisted-by: Gemini:gemini-3.6-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+7061d72c26b7daebe2b4@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=7061d72c26b7daebe2b4
Link: https://syzkaller.appspot.com/ai_job?id=24752a23-f0b6-49c1-bf20-4fa89c2e7eb2
Signed-off-by: Aleksandr Nogikh <nogikh@google.com>

---
diff --git a/sound/core/init.c b/sound/core/init.c
index 56dde5bd7..577338526 100644
--- a/sound/core/init.c
+++ b/sound/core/init.c
@@ -584,6 +584,8 @@ EXPORT_SYMBOL_GPL(snd_card_disconnect_sync);
 
 static int snd_card_do_free(struct snd_card *card)
 {
+	bool managed = card->managed;
+
 	card->releasing = true;
 #if IS_ENABLED(CONFIG_SND_MIXER_OSS)
 	if (snd_mixer_oss_notify_callback)
@@ -601,7 +603,7 @@ static int snd_card_do_free(struct snd_card *card)
 	}
 	if (card->release_completion)
 		complete(card->release_completion);
-	if (!card->managed)
+	if (!managed)
 		kfree(card);
 	return 0;
 }


base-commit: db2ddb87143519e20a95aa36c60b36107b736a58
-- 
See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
The person who has signed off on the patch is responsible for
addressing comments.
syzbot engineers can be reached at syzkaller@googlegroups.com.
