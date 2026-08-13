Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71062322DB7
	for <syzbot@lists.linux.dev>; Thu, 13 Aug 2026 19:56:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786651000; cv=none; b=Kbd4kan9bnvGsSZqjAFAdJaVhvrdtKFqv0+A/ykd/+aT7DIe/EV1rPcKIWn/Z8mg8eJlMYuwSfRGnzceIfOMhJEsj6XLP1a/Qt5mTvXlKEOFznTexYR8EQQGMVKdwH1xy+NeY9aphAIGAFkoA/9k9tw5EUCbe6BrvIx1MQlwSno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786651000; c=relaxed/simple;
	bh=Pcco9C+JEcDQLIQ6P3yNwMvEJwMbxLs/9cmmZSwXpDI=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=BeT5F5/tlH2EhYfUcRpTXL5i9ZRuh4nt7wdrJUziVcEe4iOeNvnpklA8BhrNwlzUtixv4Bc4WpQfwITEq22yP0QKtUbaf66DM28mq9Vfak2JTKuGC8C9vPu3WUC83nAF9vVE9MXgVcfJ0ShdjORkLJ4IFdmawAFQvfTcFoEAD8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YyAX82Dg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YyAX82Dg"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 25ECD1F000E9;
	Thu, 13 Aug 2026 19:56:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786650999;
	bh=WQKSmIjYMLyCHxt8klv/KZp2Icp+T4vdkV1FS21tc2U=;
	h=From:To:Cc:Subject:Date;
	b=YyAX82Dgq2+lfMfQk0+SuyVmx3tCxadtlaSxHD8mwGZtXuVfiLbt8/CBeBBiZj5oH
	 GzlgA0A4YGRPuGOs5RLhlN3yZmmD41LbNxXxPoRTGYpvlSwf+2WAb5qeMdvtcMxevt
	 cWqSxHsdr4i+pPch022KsNi2blCceNl7LTWZGxD1+gmWUUz4txcT5ZnSNBsJezejEp
	 GNlTgimUZgKwaG+HHNZljYo6WTNG1lgs4jlcgs/cOMRgqPxj2XlYH6HERbNCV1MsUW
	 16rYS1FGx/si1hPy6Um8/d9NZng5aKaBE4CBSd1sP6eaKkr1TdLcHO+VyKSJ9Cq5EP
	 7DI3225K4K6Iw==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] ALSA: core: Fix use-after-free in snd_card_do_free()
Message-ID: <b4cf9eb9-0e37-41db-ae44-125880a6740e@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Thu, 13 Aug 2026 19:56:39 +0000 (UTC)

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
To: <linux-sound@vger.kernel.org>
To: "Jaroslav Kysela" <perex@perex.cz>
To: "Takashi Iwai" <tiwai@suse.com>
To: "Takashi Iwai" <tiwai@suse.de>
Cc: "Mark Brown" <broonie@kernel.org>
Cc: =?utf-8?q?C=C3=A1ssio_Gabriel?= <cassiogabrielcontato@gmail.com>
Cc: "Cezary Rojewski" <cezary.rojewski@intel.com>
Cc: "Kees Cook" <kees@kernel.org>
Cc: <linux-kernel@vger.kernel.org>

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
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to Sign-off the patch as a human author
and send it to the upstream kernel mailing lists.
Reply with '#syz reject' to reject it ('#syz unreject' to undo).

See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
You can comment on the patch as usual, syzbot will try to address
the comments and send a new version of the patch if necessary.
syzbot engineers can be reached at syzkaller@googlegroups.com.
