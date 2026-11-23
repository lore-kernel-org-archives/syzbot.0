Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795450786;
	b=b/UT339FvwxsBOlYw56TwUHuzyC/s4zEVSwoYIqyAaHylxMiQTCDqZIS/wkRHIaYkw9A
	 CpwOAjyeseAB8BTXi8XBXaL2/qAPUDkvWnIWl7CtxH6TeAZ+7SALSNeno8nimb1yLz1Iz
	 qGYuUEklvt//R0ZHckEKrDI72Ng7s/H/X2gOXe7uvS1K1Yy4a27t8MUTEy/wkWuwNbTGP
	 Mq/94o7Cc1BQ/NQ7z6pMcXSyiKSa7/bW1lZKXQXHb4UIWJ5YyUs1+WONDMWD7cCBY/y6Y
	 +HvyooSmR/OUbc7+wWUVD9P+EimrgPmu8rM8riVAMKv32Z/yNoVNu12Ezj7S8JCDuvg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795450786;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Message-ID:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Date;
	bh=n9qlRErtr0Ug0NfOhV87GVLC94NDncg/dzhH0g7xeyY=;
	b=2AoOPQSaSg2x51hvwZB755ivVReUMaupwuIoEUnqLvvXz39mSasQy0w4cUUac0zNHUc/
	 rIfuehXPysdhDSdOP/9FJhqFEBdrQI6jUUzLA4OiwAPDZHNycveVGenbaUy3nWCSxri66
	 8uMYOMSn21lZPRAoc2pJgW7/gnGUMfm02SCrKMm2JmULzi02J32fEof9IEKn35xkI00aO
	 l4O07kpwZvyMIDZ+0eYJMXXU0VvsN5l9HusjDnuWmodO1zcN3mcZAaudxGkPYkkc7BljS
	 FccQgmTNUJq4evDGDcM9HASiOASx74R8ne0vMfAuL2fGd4YC0fIehcMLZ/VEjDDIA2Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nlbmRpvs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 29293606A31E
	for <syzbot@lists.linux.dev>; Mon, 23 Nov 2026 16:19:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nlbmRpvs
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 6BFA61F000C4;
	Mon, 23 Nov 2026 16:19:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795450785;
	bh=n9qlRErtr0Ug0NfOhV87GVLC94NDncg/dzhH0g7xeyY=;
	h=From:To:Cc:Subject:Date;
	b=nlbmRpvs7Iwly0lR2qGl5RbnCjiSoIi+FMp+1AHHjJE1gdj+NQ8HTjBotmFtVh6gj
	 0yTp+deSSBDyQuLQcPjOz3lD7sAJY7B7/0Yh6QBOCgZ/03MSgmhYsBkOh1WFBbXPAw
	 8WxEMppESYkbUPhAmFvSi7f87R5Pkejp+Lr6gzG5dq3Sr8+F9mkGTeqkPsirb+BRau
	 lj7kwv0/ZBdhFv7ALMlKPpnTFr7VmX3bRmUyUrxYps74VWjZdKs+697fPNaZPUqozS
	 bD2RMppDUT7+A5oRxSMD7M1nrhgzEL7OJNNgOKUI/gwlVK62is+hARms/bZop4nx7w
	 4nMeh27qsaA7g==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev, uladzislau.zhauniarovich@gmail.com
Subject: [PATCH RFC v4] md: drop a never-started reshape request when stopping the array
Message-ID: <749832f1-1779-4aae-93a4-6be0fca10fe4@mail.kernel.org>
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
Date: Mon, 23 Nov 2026 16:19:45 +0000 (UTC)

Writing raid_disks, layout, or chunk_size on a running array records a
reshape request in struct mddev without starting the reshape until
sync_action is set to "reshape". Because super_90_sync() and super_1_sync()
only write reshape metadata to the superblock when reshape_position !=
MaxSector, a never-started reshape exists purely in memory. Dropping the
request when the array is stopped matches the state that would be loaded on
disk reassembly.

A minimal reproduction sequence is:

  # raid5 running on 3 devices
  echo 4 > /sys/block/md0/md/raid_disks
  echo inactive > /sys/block/md0/md/array_state
  echo active > /sys/block/md0/md/array_state

Modifying layout or chunk_size behaves similarly. When restarting the
array, raid5_run() previously assumed no reshape was taking place because
reshape_position was MaxSector and triggered a kernel BUG due to
delta_disks != 0:

kernel BUG at drivers/md/raid5.c:8117!
RIP: 0010:raid5_run+0x11a7/0x1670 drivers/md/raid5.c:8117
Call Trace:
 md_run+0xc2f/0x2510 drivers/md/md.c:6779
 do_md_run+0x36/0x660 drivers/md/md.c:6880
 array_state_store+0x9c5/0xcf0 drivers/md/md.c:4765

Commit 0669c7dbd1d3 ("md/raid5: don't BUG() on an inconsistent reshape
state from the superblock") replaced the BUG_ON in raid5_run() with an
-EINVAL check, but the underlying issue remained: raid5 fails to restart
with -EINVAL, and raid10 silently returns incorrect data due to unchecked
new_layout and new_chunk_sectors in setup_conf().

Drop the never-started reshape request in __md_stop() if no reshape is
currently running (mddev->reshape_position == MaxSector). Reset delta_disks
and reshape_backwards to 0, restore new_level, new_layout, and
new_chunk_sectors to level, layout, and chunk_sectors, and reset each
rdev's new_data_offset to data_offset. If a reshape is actively in progress
(mddev->reshape_position != MaxSector), the parameters are preserved so the
reshape can resume when the array is restarted.

Fixes: 9e653b6342c9 ("[PATCH] md: Set/get state of array via sysfs")
Assisted-by: Gemini:gemini-4-hydrogen Gemini:gemini-3.8-flash syzbot
Tested-by: Uladzislau Zhauniarovich <uladzislau.zhauniarovich@gmail.com>
Reported-by: syzbot+1f5a7de91d547763f4c8@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=1f5a7de91d547763f4c8
Link: https://syzkaller.appspot.com/ai_job?id=b860f0d5-7dab-4c40-98ef-61ceb8b4aa77
To: <linux-raid@vger.kernel.org>
To: "Song Liu" <song@kernel.org>
To: "Yu Kuai" <yukuai@fygo.io>
To: "NeilBrown" <neilb@suse.de>
Cc: <linux-kernel@vger.kernel.org>
Cc: "Li Nan" <magiclinan@didiglobal.com>
Cc: "Xiao Ni" <xiao@kernel.org>
Cc: <yogeshgaur.83@gmail.com>

---
v4:
- Updated the stack trace in the commit description as requested by the reviewer.

v3:
- Updated the commit reference for 0669c7dbd1d3 to standard format with title.
- Replaced the stack trace with the report's call trace including file and line information for array_state_store.
- Added '# raid5 running on 3 devices' to the reproduction sequence.
https://lore.kernel.org/all/fb44a7d5-0913-46d2-bc67-4958b18ad923@mail.kernel.org/T/

v2:
- Reset rdev->new_data_offset to rdev->data_offset for all member devices.
- Add an explanatory comment in __md_stop().
- Update commit subject and description per reviewer feedback.
https://lore.kernel.org/all/3ba40dcd-182e-4830-b254-c457032bef30@mail.kernel.org/T/

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
