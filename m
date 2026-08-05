Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0468837A83B
	for <syzbot@lists.linux.dev>; Wed,  5 Aug 2026 13:24:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785936260; cv=none; b=O3ldH+Akzc/iKhYzkF5eDZh8UQo6zQnsEFXCmBHDw1iT8J18wNlIIkdqmKW8++VfOlwjNu7zH6O0zEedTBJ3jzHiGtAVu6/njMFNvGq1zVGF9dPc3bB+sYMWHA8XXG7VC1kTX5IoksCvnO6Su8AyBrK2hnuBKnuhWfsV3lMRnxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785936260; c=relaxed/simple;
	bh=FtdXF2sgcoufcFLZP663dd02jlaDcYEcpm1eJmmHoD0=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=C4PykEf1HyALZbvJhSSjm2+EpVAI3NvRAd06gxhyfCHASUTfhRmXYHJW1m7Ru5RmNa34z/s1MrJDn+7clhNvQWJMZY18jqVvpNdiLuLdqQxJWA8PQlmZ6NiOoJiRFElQf3XKJ4ax+jZ86P3ytY541Q6LQL9jsEpPz9VccOVuAs4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iqSn3YDy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iqSn3YDy"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 6FC751F000E9;
	Wed,  5 Aug 2026 13:24:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785936258;
	bh=9i0AGObQBqNzkutz0GqBurd19/Pl2KBXelwrnwTOkUA=;
	h=From:To:Cc:Subject:Date;
	b=iqSn3YDy2Z6bWm3rc1GQeEfAo8b3gd/kDllAdSuiXT992jKzMveUEiQznvAgDunFc
	 yJvaaEyYgp5paI+OS85kxDbHuW+5j4+SZ76GOhH5xaBAqmWf+kQbq3IbrwFg/CDWI3
	 9UztJbod03OYQ8KRjTKSSgSNhmY0mDWDt9EcRvefdz/pKbaTLp7R61xSITXuqoJEUz
	 6E/KnKDIZCXQoe+HzB7IX9BPKHEw9SKl9N2gG1yNmOmOixg+iEpI1sX4JBCwHpawBq
	 W4pl/A3xXIaQnGyAHrFCIuA9pOxr3YIP1iY3vEXa8rJ7OnfEX+JY+WE0M75PNDf3T5
	 wNF1RPOacCKug==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] usb: gadget: f_tcm: Drop tpg_instances_lock in tcm_alloc()
Message-ID: <80f554dc-dcc3-4909-94c6-4cde763895dd@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Wed,  5 Aug 2026 13:24:18 +0000 (UTC)

A circular locking dependency was reported by lockdep involving
tpg_instances_lock, opts->dep_lock, inode_lock, and gi->lock:

WARNING: possible circular locking dependency detected
task is trying to acquire lock:
ffffffff8faaae80 (tpg_instances_lock){+.+.}-{4:4}, at: tcm_alloc+0x21/0x2e0

but task is already holding lock:
ffff8881940a6390 (&gi->lock){+.+.}-{4:4}, at:
config_usb_cfg_link+0x59/0x260

which lock already depends on the new lock.

the existing dependency chain (in reverse order) is:

-> #3 (&gi->lock){+.+.}-{4:4}:
       config_usb_cfg_link+0x59/0x260
       configfs_symlink+0x59a/0x1030

-> #2 (&sb->s_type->i_mutex_key#24){+.+.}-{4:4}:
       inode_lock include/linux/fs.h:1024 [inline]
       configfs_depend_item_unlocked+0x153/0x420
       usbg_make_tpg+0x1f6/0x590

-> #1 (&opts->dep_lock){+.+.}-{4:4}:
       usbg_make_tpg+0x147/0x590

-> #0 (tpg_instances_lock){+.+.}-{4:4}:
       tcm_alloc+0x21/0x2e0
       usb_get_function+0x63/0xb0
       config_usb_cfg_link+0x148/0x260
       configfs_symlink+0x59a/0x1030

The dependency chain is formed by two separate code paths. First, when
creating a new Target Portal Group (TPG) via configfs, usbg_make_tpg()
acquires tpg_instances_lock, then opts->dep_lock, and then calls
configfs_depend_item_unlocked() which acquires the VFS inode_lock. Second,
when linking the TCM function to a USB gadget configuration via configfs,
configfs_symlink() acquires the VFS inode_lock, then config_usb_cfg_link()
acquires gi->lock, and finally tcm_alloc() acquires tpg_instances_lock.
This creates a cycle: tpg_instances_lock -> opts->dep_lock -> inode_lock ->
gi->lock -> tpg_instances_lock.

To break this cycle, remove tpg_instances_lock from tcm_alloc(). The lock
is unnecessary here because tcm_alloc() only iterates over the static
tpg_instances array to read the tpg pointer. The func_inst pointer is
stable since the caller (usb_get_function()) holds a reference to it,
ensuring the array entry won't be cleared concurrently. Furthermore,
reading the tpg pointer is atomic, and the lock was previously dropped
immediately after reading, providing no protection against concurrent
modifications after tcm_alloc() returns. The actual protection relies on
configfs lifecycle guarantees and the opts->can_attach flag checked later
during tcm_bind().

Fixes: dc8c46a5ae77 ("usb: gadget: f_tcm: convert to new function interface with backward compatibility")
Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+2799146a53c356f8017d@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=2799146a53c356f8017d
Link: https://syzkaller.appspot.com/ai_job?id=49909002-0104-485f-85b2-50f21a062149
To: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
To: <linux-usb@vger.kernel.org>
To: "Andrzej Pietrasiewicz" <andrzej.p@samsung.com>
Cc: "Jiasheng Jiang" <jiashengjiangcool@gmail.com>
Cc: <linux-kernel@vger.kernel.org>
Cc: "Cen Zhang" <zzzccc427@gmail.com>

---
diff --git a/drivers/usb/gadget/function/f_tcm.c b/drivers/usb/gadget/function/f_tcm.c
index b3fa5a17f..368fbffcb 100644
--- a/drivers/usb/gadget/function/f_tcm.c
+++ b/drivers/usb/gadget/function/f_tcm.c
@@ -2730,20 +2730,15 @@ static struct usb_function *tcm_alloc(struct usb_function_instance *fi)
 	struct f_uas *fu;
 	unsigned i;
 
-	mutex_lock(&tpg_instances_lock);
 	for (i = 0; i < TPG_INSTANCES; ++i)
 		if (tpg_instances[i].func_inst == fi)
 			break;
-	if (i == TPG_INSTANCES) {
-		mutex_unlock(&tpg_instances_lock);
+	if (i == TPG_INSTANCES)
 		return ERR_PTR(-ENODEV);
-	}
 
 	fu = kzalloc_obj(*fu);
-	if (!fu) {
-		mutex_unlock(&tpg_instances_lock);
+	if (!fu)
 		return ERR_PTR(-ENOMEM);
-	}
 
 	fu->function.name = "Target Function";
 	fu->function.bind = tcm_bind;
@@ -2758,7 +2753,6 @@ static struct usb_function *tcm_alloc(struct usb_function_instance *fi)
 	spin_lock_init(&fu->delayed_set_alt_lock);
 
 	hash_init(fu->stream_hash);
-	mutex_unlock(&tpg_instances_lock);
 
 	return &fu->function;
 }


base-commit: 075b74841bd0065a3bda3440873c747938e69b68
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to Sign-off the patch as a human author
and send it to the upstream kernel mailing lists.
Reply with '#syz reject' to reject it ('#syz unreject' to undo).

See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
You can comment on the patch as usual, syzbot will try to address
the comments and send a new version of the patch if necessary.
syzbot engineers can be reached at syzkaller@googlegroups.com.
