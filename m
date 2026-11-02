Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793636188;
	b=xp5q5/UJHcVgAUGJq/FzrAMUv30YXL1UJ4zcdKp0HmQHGQaWKpkKFatsdOxCnJ6yRus9
	 HeOQSgIMilSWMS68bmBwVZGzTpr2GjhWiyxGTDsm0MykoFP9FxWgfCXBF8tvIKHqng+5m
	 nusq096WArBDGbCauCSolsysKYZlJHB8cTZ2I9EkOWofrJMZ4Qa3EyYFZZlWprTeDcTwR
	 X92LzLvpNKNdyTtR4MpNES/1Khk3qZtuwFkes9sVsBdSwyQ4wg4ehaOUpA/xwMj9RkW8y
	 cbwXBbtq6pg4ZERwsvqzlD2IpFmKiL2OXOvRRyrPuQylWiakW7Ey5jqAuUkY8Uwn9+w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793636188;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Message-ID:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Date;
	bh=Byov/W/YqXYW6fcXjKUblcmkgvFGEGP22WGib65hPt8=;
	b=tzyBQJjbN8+DqHG1w5OH/zDa4aPmq3ITzF99L52PtZJ8bawyTfZhK5CXQPEf6OtX5oWu
	 wE+UtTfwjwAwe7qmTCGdg/mdtA4Wbr/idxxH0Iy4nIwrDGTdyDCw9jfrRadZbZ4a39omu
	 blaKibdUXBHMmWniwkYBz6QL/VrFYqp8jHkVHFzJvRo7HjaSZ7qDgalZsH3TKD9ZEgvED
	 1XSjNv0HTPUXKSWGpnFCESnXvm4s6YZQCB2qQgBC3odCa6Tn4StQGekq5nFMIYQKIzVhJ
	 ESCfAJKY7y3PatAL7l3wc27hmw14ps/bnTbfGDTppK1gQvAHHJGn0rUhJeGocc3My5Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Y0OUGttx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 01CCA6082C48
	for <syzbot@lists.linux.dev>; Mon,  2 Nov 2026 16:16:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Y0OUGttx
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id B6E761F00A16;
	Mon,  2 Nov 2026 16:16:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793636187;
	bh=Byov/W/YqXYW6fcXjKUblcmkgvFGEGP22WGib65hPt8=;
	h=From:To:Cc:Subject:Date;
	b=Y0OUGttx/HXFCUxDxpcfWT7izMVgqfQ3NFa+IFtF3/XX7g+reKsZNih7zAI1xXNkt
	 a7M1uN4tLKC2xQA7BbTeULRrWA8h6XYbdxFmc2JYW/dGT1V5F1UcrHfFmBmQTVVdo1
	 w+aMerU2yO/H13FjYpo0vb6k1Fm/SJukxROzM4eBGUMiAJDg1Kug0LGTFjTwl2KtSr
	 U5Y6BGRKlNae1UZa9Th+qdrSPacpZV4HY79q1o8Or+KV2QGJnsqBZh+/SmxKxo8cAj
	 UxihSWhlynf9svn4hQKqC1htSzAw0y+gij7gVguBDMleUZKor8QnFsX0KMUkZNVr/J
	 Sqsao/o8HWgzw==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev, uladzislau.zhauniarovich@gmail.com
Subject: [PATCH RFC v2] md: drop a never-started reshape request when stopping the array
Message-ID: <3ba40dcd-182e-4830-b254-c457032bef30@mail.kernel.org>
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Post: <mailto:syzbot@lists.linux.dev>
List-Help: <mailto:syzbot+help@lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
List-Owner: <mailto:syzbot+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Mon,  2 Nov 2026 16:16:27 +0000 (UTC)

Writing raid_disks, layout, or chunk_size on a running array records a
reshape request in struct mddev without starting the reshape until
sync_action is set to "reshape". Because super_90_sync() and super_1_sync()
only write reshape metadata to the superblock when reshape_position !=
MaxSector, a never-started reshape exists purely in memory. Dropping the
request when the array is stopped matches the state that would be loaded on
disk reassembly.

A minimal reproduction sequence is:

  echo 4 > /sys/block/md0/md/raid_disks
  echo inactive > /sys/block/md0/md/array_state
  echo active > /sys/block/md0/md/array_state

Modifying layout or chunk_size behaves similarly. When restarting the
array, raid5_run() previously assumed no reshape was taking place because
reshape_position was MaxSector and triggered a kernel BUG due to
delta_disks != 0:

kernel BUG at drivers/md/raid5.c:8117!
Oops: invalid opcode: 0000 [#1] SMP
RIP: 0010:raid5_run+0x2550/0x2560 drivers/md/raid5.c:8117
Call Trace:
 <TASK>
 md_run+0xc3d/0x1cd0 drivers/md/md.c:6779
 do_md_run+0x35/0x720 drivers/md/md.c:6880
 array_state_store+0x958/0xe90
 md_attr_store+0x3b7/0x640 drivers/md/md.c:6158
 kernfs_fop_write_iter+0x3a4/0x540 fs/kernfs/file.c:345
 vfs_write+0x612/0xba0 fs/read_write.c:687
 ksys_write+0x150/0x270 fs/read_write.c:739
 do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
 </TASK>

Commit 0669c7dbd1d3 replaced the BUG_ON in raid5_run() with an -EINVAL
check, but the underlying issue remained: raid5 fails to restart with
-EINVAL, and raid10 silently returns incorrect data due to unchecked
new_layout and new_chunk_sectors in setup_conf().

Drop the never-started reshape request in __md_stop() if no reshape is
currently running (mddev->reshape_position == MaxSector). Reset delta_disks
and reshape_backwards to 0, restore new_level, new_layout, and
new_chunk_sectors to level, layout, and chunk_sectors, and reset each
rdev's new_data_offset to data_offset. If a reshape is actively in progress
(mddev->reshape_position != MaxSector), the parameters are preserved so the
reshape can resume when the array is restarted.

Fixes: 9e653b6342c9 ("[PATCH] md: Set/get state of array via sysfs")
Assisted-by: Gemini:gemini-4-argon Gemini:gemini-3.8-flash syzbot
Reported-by: syzbot+1f5a7de91d547763f4c8@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=1f5a7de91d547763f4c8
Link: https://syzkaller.appspot.com/ai_job?id=aed1664c-30b2-4920-81b4-ed098ec14e92
To: <linux-raid@vger.kernel.org>
To: "Song Liu" <song@kernel.org>
To: "Yu Kuai" <yukuai@fygo.io>
To: "NeilBrown" <neilb@suse.de>
Cc: <linux-kernel@vger.kernel.org>
Cc: "Li Nan" <magiclinan@didiglobal.com>
Cc: "Xiao Ni" <xiao@kernel.org>

---
v2:
- Reset rdev->new_data_offset to rdev->data_offset for all member devices.
- Add an explanatory comment in __md_stop().
- Update commit subject and description per reviewer feedback.

v1:
https://lore.kernel.org/all/0bbc5530-3021-49ec-a8cd-a006c2639d53@mail.kernel.org/T/
---
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 680b34a63..011a5ea54 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -7084,6 +7084,7 @@ static void mddev_detach(struct mddev *mddev)
 static void __md_stop(struct mddev *mddev)
 {
 	struct md_personality *pers = mddev->pers;
+	struct md_rdev *rdev;
 
 	mddev_detach(mddev);
 	md_bitmap_destroy(mddev);
@@ -7095,6 +7096,21 @@ static void __md_stop(struct mddev *mddev)
 	mddev->private = NULL;
 	put_pers(pers);
 	clear_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
+
+	/*
+	 * A reshape requested on a running array exists only in memory before
+	 * sync_action=reshape and should be dropped with the personality, while
+	 * a started reshape (reshape_position != MaxSector) is preserved.
+	 */
+	if (mddev->reshape_position == MaxSector) {
+		mddev->delta_disks = 0;
+		mddev->reshape_backwards = 0;
+		mddev->new_level = mddev->level;
+		mddev->new_layout = mddev->layout;
+		mddev->new_chunk_sectors = mddev->chunk_sectors;
+		rdev_for_each(rdev, mddev)
+			rdev->new_data_offset = rdev->data_offset;
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
