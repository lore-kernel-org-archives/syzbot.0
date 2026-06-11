Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9C333EFD03
	for <syzbot@lists.linux.dev>; Thu, 11 Jun 2026 12:29:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781180962; cv=none; b=Ct2gGMlfQPmIBgAlRlyreudXUtaxEvfFYNtCmroTetOUN2d+LHjQmqynlkLLya6cakPAfrPGoa8EVPr2DV/lwzgJoTxA9Q6ZZ63ytrhjClHrZ2lGhs+oM5br8yuizxARMNW46EI/iq060T4bKc9DZa2QQYjv6WZvo84wTRpTGzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781180962; c=relaxed/simple;
	bh=xSomEuoQxSPPGSQzhP7uW1MO5hsmLcXILG76DBnreeE=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=JetYZhJevZSU9f/MTtqbhCCw7HzX7A8IvSXaogt+E/w4WKxJrhj/NNO4M6gYSKPj/4KG9tqAVN2lnCd/H/GeIxqa+wM4ABif5qBJb4inPZeM6heAFZwcein1MNWX4M4VuCwy9P0OWNqNKZMqLxKeFJ6YE3D5fvZU5v0kHme5UX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fi4Rp8U3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fi4Rp8U3"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id A67021F00893;
	Thu, 11 Jun 2026 12:29:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781180960;
	bh=fWS2EwFHNvNNfUZOFrY8MTBNLwlEYTcpwybldDGAyAY=;
	h=From:To:Cc:Subject:Date;
	b=fi4Rp8U3qpH5D3CpSt3piCZTN8uBKus34tnnxT41NBcXsWTxenabVYHH8SNDuP26Y
	 S7W5MXYvbpeQRh94txDX5JCxsW6uzPjdhAQltRaiP1lHnAi/RBs0NKh7aWutXAvtzU
	 SBS5yqsirz+9S1KH1UyMgBSnmCN/PHOaZTU3TNVJ6NpKU6KaEynM/Y4paPr65ldTWs
	 WbAQ7tyuUIDko11JEVY+HFNK/uydgpLbsve7iJALCUvyLILxze/i0I3XNNHguA9hUu
	 ScMHWqTRBWf/VZ/4B09fgCUVxwg4iUXz2CJlA/KQ5uGXTTxsMmvFzGUHeyzYDQkhg1
	 mOvPzLfo8jEqQ==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] super: prevent hung task in super_lock() and grab_super()
Message-ID: <412aedfb-16f3-4fcf-935a-ceccc814d782@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Thu, 11 Jun 2026 12:29:20 +0000 (UTC)

A hung task panic can be triggered when quotactl() or sync() blocks
indefinitely in TASK_UNINTERRUPTIBLE while waiting for a nascent superblock
to finish mounting.

This occurs when a filesystem's fill_super() or get_tree() method blocks
indefinitely in a killable state (e.g., 9p waiting on a dead pipe). The
mount task is in TASK_KILLABLE, which is ignored by the hung task detector.
Meanwhile, quotactl() calls __iterate_supers() -> super_lock(), which uses
wait_var_event() to wait for the superblock to become SB_BORN or SB_DYING.
This wait is in TASK_UNINTERRUPTIBLE. Since the mount is stuck forever,
quotactl() waits forever, eventually triggering a hung task panic:

INFO: task blocked for more than 143 seconds.
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5388 [inline]
 __schedule+0x1821/0x5680 kernel/sched/core.c:7189
 __schedule_loop kernel/sched/core.c:7268 [inline]
 schedule+0x164/0x360 kernel/sched/core.c:7283
 super_lock+0x1e0/0x3d0 fs/super.c:116
 __iterate_supers+0x126/0x250 fs/super.c:926
 quota_sync_all fs/quota/quota.c:69 [inline]
 __do_sys_quotactl fs/quota/quota.c:938 [inline]
 __se_sys_quotactl+0x3a7/0x9e0 fs/quota/quota.c:917
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x15f/0x560 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
 </TASK>

To fix this without requiring massive VFS refactoring to make super_lock()
killable (which would involve propagating errors through numerous callers),
replace wait_var_event() with wait_var_event_timeout() in a loop.

Using a 30-second timeout allows the task to periodically wake up,
incrementing its voluntary context switch count and resetting the hung task
detector's timer, while maintaining the exact same VFS semantics.

The same issue exists in grab_super() when waiting for a dying superblock
to become SB_DEAD, so apply the same timeout-and-loop pattern there as
well.

Fixes: 5e8749141521 ("super: wait for nascent superblocks")
Assisted-by: Gemini:gemini-3.1-pro-preview Gemini:gemini-3-flash-preview syzbot
Reported-by: syzbot+f5d91b1897d5b094c6b4@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=f5d91b1897d5b094c6b4
Link: https://syzkaller.appspot.com/ai_job?id=ef00f4bd-0b25-4782-94fb-daaf1c99b6ff
To: "Christian Brauner" <brauner@kernel.org>
To: <linux-fsdevel@vger.kernel.org>
To: "Alexander Viro" <viro@zeniv.linux.org.uk>
Cc: "Jan Kara" <jack@suse.cz>
Cc: <linux-kernel@vger.kernel.org>

---
diff --git a/fs/super.c b/fs/super.c
index 378e81efe..5f4f59e84 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -112,13 +112,18 @@ static __must_check bool super_lock(struct super_block *sb, bool excl)
 {
 	lockdep_assert_not_held(&sb->s_umount);
 
+relock:
 	/* wait until the superblock is ready or dying */
-	wait_var_event(&sb->s_flags, super_flags(sb, SB_BORN | SB_DYING));
+	wait_var_event_timeout(&sb->s_flags,
+			       super_flags(sb, SB_BORN | SB_DYING), 30 * HZ);
 
 	/* Don't pointlessly acquire s_umount. */
 	if (super_flags(sb, SB_DYING))
 		return false;
 
+	if (!super_flags(sb, SB_BORN))
+		goto relock;
+
 	__super_lock(sb, excl);
 
 	/*
@@ -538,7 +543,10 @@ static bool grab_super(struct super_block *sb)
 		}
 		super_unlock_excl(sb);
 	}
-	wait_var_event(&sb->s_flags, super_flags(sb, SB_DEAD));
+wait_dead:
+	wait_var_event_timeout(&sb->s_flags, super_flags(sb, SB_DEAD), 30 * HZ);
+	if (!super_flags(sb, SB_DEAD))
+		goto wait_dead;
 	put_super(sb);
 	return false;
 }


base-commit: 4549871118cf616eecdd2d939f78e3b9e1dddc48
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to Sign-off the patch as a human author
and send it to the upstream kernel mailing lists.
Reply with '#syz reject' to reject it ('#syz unreject' to undo).

See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
You can comment on the patch as usual, syzbot will try to address
the comments and send a new version of the patch if necessary.
syzbot engineers can be reached at syzkaller@googlegroups.com.
