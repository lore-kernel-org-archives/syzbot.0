Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8F82519904
	for <syzbot@lists.linux.dev>; Tue,  8 Sep 2026 11:53:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788868389; cv=none; b=UWnOnzdeVjiGGFT+x6RAVlrAYqgXuS2zSEqxE05U5t4Ww5qnHJxBBMA4XMxH1d0qtXsokGcfhiJLldtBnhACoFO0aJgSj8khwaSOl49QDobNI1D4ZtENQ+ur9zbdlBnb15m8G3mbOMPBVdKOiUkOOLS8gFvP9ZPRv8jDPf/09gk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788868389; c=relaxed/simple;
	bh=QIH8eJgZV9WUg5fTctZBBVYVygEvpVUTCBOgsm97Lew=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=tiFVqxFQLqjx8kZxdw3bQyMdfylJu2G8Yv0ZmBIZJOgob8lczpK71Ew+kGQlO1yhSX2Md+Ptlqf9FUEilXFXUgBg6RuTNXwv7ZU//Ms+Rb3/rQsyHUAS2rBT60/eanOPKfNVFANaMvZJHHa90+OQ1AkfPMQqtMjvdr6/ixRTWvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oZFzY2KY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oZFzY2KY"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id ABA801F00A3A;
	Tue,  8 Sep 2026 11:53:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788868382;
	bh=1bCTnTBjWSuoyRPv30ST6VynuxqA6cMhAY61p6RidyY=;
	h=From:To:Cc:Subject:Date;
	b=oZFzY2KY60ysKAMKakZ9CZDvtuCXbKVQYZFNgJ2NoZvbZDMw1sLi4zalAyVvOsAWc
	 VNWntfDS2XYqGDZXJxMX0r34T50BdQyCb4xZU2ANsdliAmlBqMLLdFyg+CqyF67HgI
	 Z0fJqt113WW8ORpknjixlisVPYsT6eVzVdG2MZBMznHrdkczSlfN0/u7vJt1MTkpH0
	 DqdgM3tymA2NQeM8b3zPhQ5XZArYZNyuXMTGYKj4an2NbweiFvYrbTHcIWdTxvhdOK
	 wsPSwVtoTJe7C6cL9Kt0h0tdQOZ/YlTtHhk+0INVep3L29w9r2BqAwbHOKarrHY8eD
	 hlCGVDNE5XR5A==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] fuse: use TASK_FREEZABLE_UNSAFE in fuse_get_req()
Message-ID: <53fcf56a-db74-43f3-81be-bd5bac1c0d4f@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Tue,  8 Sep 2026 11:53:02 +0000 (UTC)

Commit 14cbb72d7595 ("fuse: use freezable wait in fuse_get_req()") switched
fuse_get_req() to wait using TASK_KILLABLE | TASK_FREEZABLE so that tasks
waiting for connection initialization or available request slots would not
block system suspend or hibernation.

However, fuse_get_req() is frequently invoked from VFS and filesystem
operations (such as lookup_open() or atomic_open()) while holding locks
like the VFS directory inode lock or FUSE-specific inode mutex. When the
system freezer freezes processes, __set_task_frozen() uses lockdep to
verify that the task being frozen does not hold locks (via
WARN_ON_ONCE(debug_locks && p->lockdep_depth)), unless the sleep state
explicitly marks that freezing with locks held is expected via
__TASK_FREEZABLE_UNSAFE. Because TASK_FREEZABLE was used instead of
TASK_FREEZABLE_UNSAFE, freezing a task waiting in fuse_get_req() with locks
held triggers a warning:

WARNING: kernel/freezer.c:139 at __set_task_frozen+0x260/0x340
Call Trace:
 <TASK>
 task_call_func+0x1aa/0x260 kernel/sched/core.c:4511
 __freeze_task kernel/freezer.c:150 [inline]
 freeze_task+0x229/0x3b0 kernel/freezer.c:169
 try_to_freeze_tasks+0x190/0x620 kernel/power/process.c:54
 freeze_processes+0xd0/0x1f0 kernel/power/process.c:137
 hibernate+0x247/0x680 kernel/power/hibernate.c:801
 state_store+0x234/0x290 kernel/power/main.c:821
 kernfs_fop_write_iter+0x3a4/0x540 fs/kernfs/file.c:345
 vfs_write+0x612/0xba0 fs/read_write.c:687
 ksys_write+0x150/0x270 fs/read_write.c:739
 do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
 </TASK>

Fix this by switching the wait state in fuse_get_req() to TASK_KILLABLE |
TASK_FREEZABLE_UNSAFE, informing lockdep and the freezer that freezing
while holding locks is expected at this wait site.

Fixes: 14cbb72d7595 ("fuse: use freezable wait in fuse_get_req()")
Assisted-by: Gemini:gemini-3.7-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+622acb507894a48b2ce9@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=622acb507894a48b2ce9
Link: https://syzkaller.appspot.com/ai_job?id=cc254232-e52e-4755-a734-0b8fc80a4302
To: <fuse-devel@lists.linux.dev>
To: "Miklos Szeredi" <miklos@szeredi.hu>
To: "Sergey Senozhatsky" <senozhatsky@chromium.org>
Cc: <linux-kernel@vger.kernel.org>

---
diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index 4fec31fc0..e0e0ad0ee 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -122,7 +122,7 @@ static struct fuse_req *fuse_get_req(struct fuse_chan *fch, bool for_background)
 		err = -EINTR;
 		if (wait_event_state_exclusive(fch->blocked_waitq,
 				!fuse_block_alloc(fch, for_background),
-				(TASK_KILLABLE | TASK_FREEZABLE)))
+				(TASK_KILLABLE | TASK_FREEZABLE_UNSAFE)))
 			goto out;
 	}
 


base-commit: df2908090cda368b01ff43709f51890076c56157
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to Sign-off the patch as a human author
and send it to the upstream kernel mailing lists.
Reply with '#syz reject' to reject it ('#syz unreject' to undo).

See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
You can comment on the patch as usual, syzbot will try to address
the comments and send a new version of the patch if necessary.
syzbot engineers can be reached at syzkaller@googlegroups.com.
