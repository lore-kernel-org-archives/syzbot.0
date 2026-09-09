Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E75CC3FAE09
	for <syzbot@lists.linux.dev>; Wed,  9 Sep 2026 21:45:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788990319; cv=none; b=B9/N6OkjqdslLif7PkKR7iqtMbWNHo4xmgLT8kVkVYG+ZcLpPK7hw8L0/d8WTWfNKH2iLeg4ezpJtIXtVGp+fR70YVMcVPj9h4e9vOEopZMy27cCgaOWU7s0tNjFnBFkamdhWJj67n3qZhFXUeJAgnbtg5cE7Buo+XnSKCOGnnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788990319; c=relaxed/simple;
	bh=jhOnw9DxtXRQYleCY907p0/Aa52xq8+sDGdQwPBLGMM=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=bHBFkSVEo4D512XzVlVj199m13vVcdtTa7F/GIu7k1iiVX5/uZEdRCj8RroEuD69e0U8bDmle3rqw2/2fRDYDbvNNqqXVsyhQfV9eZySNsat1s1uyM6p0T5WRcy/7w3ExQFzUw9J6kkOHc+2UK7PiD2WB/nq93d/Vxg1CsCg8sk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bCGiR4If; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bCGiR4If"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 5EC4C1F000FF;
	Wed,  9 Sep 2026 21:45:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788990311;
	bh=mb7IdX5yZuVKlfuif13eWy7p2A9FMOZoZC3w8efoZF4=;
	h=From:To:Cc:Subject:Date;
	b=bCGiR4IfBM7Zm7CF27qXdsnwAF/UGbQzqd26Ps2HHSVuN5DvnUw+1Z24wMtf+EiKj
	 qLS1m5jhllYn8jvfhZSGG6KJHAiuyG6Afae9ZG4xpvDdLjg5h2b0Tf7naEtCYCKJDL
	 tYKf5524/EGAn6kURpqZk0aSEShP0VgcWmQt9GI2t96cYozVJmlK3NUnmIGpMd8LcH
	 Q21iKuSExqU9r5dKRG09YYc+gNsJUFZFEjoTCbMlPnH61eB2H9EjUuLncPIh1ZF+cV
	 lFiRLtd/r0gxjOMy0m3n5YVcz57Xdyfz60JDfVDlEeozkD1HcVeKPpvSd0xau2kzFJ
	 6/2EDX+kABbIQ==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] md: clear pending reshape parameters in __md_stop()
Message-ID: <0bbc5530-3021-49ec-a8cd-a006c2639d53@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Wed,  9 Sep 2026 21:45:11 +0000 (UTC)

When reconfiguring an active MD array (for instance, updating the number of
disks via the raid_disks sysfs attribute), pending reshape parameters such
as delta_disks, new_level, new_layout, and new_chunk_sectors are stored in
struct mddev. At this stage, the reshape has not yet started running and
mddev->reshape_position remains set to MaxSector.

If userspace deactivates or stops the array before the reshape begins (such
as by writing "inactive" to array_state), do_md_stop() invokes __md_stop().
Unlike a full stop which invokes md_clean() to clear all configuration
fields, __md_stop() detaches the personality and frees private data but
leaves the pending reshape parameters in struct mddev. When the array is
later restarted (e.g. by writing "active" to array_state), md_run() calls
the personality's run method, raid5_run(). Because mddev->reshape_position
is still MaxSector, raid5_run() assumes no reshape is taking place and
expects no pending reshape parameters, causing BUG_ON(mddev->delta_disks !=
0) to trigger:

kernel BUG at drivers/md/raid5.c:8117!
Oops: invalid opcode: 0000 [#1] SMP
RIP: 0010:raid5_run+0x2550/0x2560 drivers/md/raid5.c:8117
Call Trace:
 <TASK>
 md_run+0xc3d/0x1cd0 drivers/md/md.c:6779
 do_md_run+0x35/0x720 drivers/md/md.c:6880
 array_state_store+0x958/0xe90 drivers/md/md.c:-1
 md_attr_store+0x3b7/0x640 drivers/md/md.c:6158
 kernfs_fop_write_iter+0x3a4/0x540 fs/kernfs/file.c:345
 vfs_write+0x612/0xba0 fs/read_write.c:687
 ksys_write+0x150/0x270 fs/read_write.c:739
 do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
 </TASK>

Fix this by clearing pending reshape parameters in __md_stop() if no
reshape is currently running (mddev->reshape_position == MaxSector).
Specifically, reset delta_disks and reshape_backwards to 0, and reset
new_level, new_layout, and new_chunk_sectors to level, layout, and
chunk_sectors, respectively. If a reshape is actively in progress
(mddev->reshape_position != MaxSector), the parameters are preserved so the
reshape can resume when the array is restarted.

Fixes: 91adb56473fe ("md/raid5: refactor raid5 "run"")
Assisted-by: Gemini:gemini-3.8-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+1f5a7de91d547763f4c8@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=1f5a7de91d547763f4c8
Link: https://syzkaller.appspot.com/ai_job?id=ebe142c5-4399-48c5-aad4-4ee23cb2055d
To: <linux-raid@vger.kernel.org>
To: "Song Liu" <song@kernel.org>
To: "Yu Kuai" <yukuai@fygo.io>
To: "NeilBrown" <neilb@suse.de>
Cc: <linux-kernel@vger.kernel.org>
Cc: "Li Nan" <magiclinan@didiglobal.com>
Cc: "Xiao Ni" <xiao@kernel.org>

---
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 680b34a63..38ab41bbc 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -7095,6 +7095,14 @@ static void __md_stop(struct mddev *mddev)
 	mddev->private = NULL;
 	put_pers(pers);
 	clear_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
+
+	if (mddev->reshape_position == MaxSector) {
+		mddev->delta_disks = 0;
+		mddev->reshape_backwards = 0;
+		mddev->new_level = mddev->level;
+		mddev->new_layout = mddev->layout;
+		mddev->new_chunk_sectors = mddev->chunk_sectors;
+	}
 }
 
 void md_stop(struct mddev *mddev)


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
