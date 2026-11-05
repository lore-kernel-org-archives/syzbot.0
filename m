Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.51
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793908602;
	b=WAzgh9OKOB2VJkNEboAJfK9dIxxiuBVOXeF551jPKclHb6COXKbOv9lqXkfevuWpDLe5
	 mKr5m4aArFznbQFDhrTx4DC/hfvEcySESRfbNxFIMVi6O43Vr/iogb6LOiviyOmUYZqcS
	 Wk/IaMuCvDtfl7N90P3SdBTP2NEu6+auY38Kne3V+OKGrVdMrmA/YerwGx9Ei6K5gFGqs
	 TCeFzYpqrx7+/vyJkqJBnpl4gecskHsiwnmCHs8pwahxA1lkRMb+kwxA6GIVAPKuOiLyG
	 gfhAl35HDgl7p3zXOCuExN4KEHNz1R2u1QI5+SfI7AxahHWcjzKrZ758f0W7q4Inm+w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793908602;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=+79bNgbupiQeNxrxjgpQjkbzWlu23rAY98ebtgDI/gg=;
	b=sr2qVJrDwAQefGu87yEyIVm70ve2zV0EYRbhpqYmCO/E58OeEkilBj3HsIvycDSbnNux
	 oY/MB3/IJ4Fkr+ZofDVdzwGd8Xa4Wk0/nMNNFjgscEeAj53wf9x84fmPJBUJIytzNJ+Bq
	 8LeQ/A63z+bcSmHHVG/1lvjVmdt1JwcKYYb00McYc7vrJehQasZ4/H9TliA8QBxjR/9uD
	 LtFTrxq1behBBzMIJvkHEIYaJGKEKkUoyNnoAy8TqQFt+ql0SqTueGdwhy2gF9BP/Jdfr
	 Xfj6OKgU6dMCBINzwCPWR3j0o7D2lJgtiWo8DHhEoJX5IYxdgG4fjM1l3XSSwmXddjQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=U04eYkpy;
	arc=none smtp.remote-ip=209.85.208.51
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40142606A32C
	for <syzbot@lists.linux.dev>; Thu,  5 Nov 2026 19:56:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 40142606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=U04eYkpy
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-6b587538a37so1022291a12.2
        for <syzbot@lists.linux.dev>; Thu, 05 Nov 2026 11:56:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793908601; x=1794513401; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+79bNgbupiQeNxrxjgpQjkbzWlu23rAY98ebtgDI/gg=;
        b=U04eYkpyx2AZqi225ZGLDd1w1qBrzNMNw92CFIkgzx0HqzDHGPPrjCp8uTDtNakl9T
         FxTJQDaAYmRwNm39g7Q8YMmtc6vEUy7UeiBzvMOOxJ9R5iTWUOQurjECw7mcA00s+N0C
         TFiUBKiPlPKnHsJ5/WFNM0xDl963sp9uasJ0jSLps22QMgbKJ9Y4gd9eOUZlhPX7fQNo
         NDuJjN1cD0QCWiyJNdkjdNM7FpJr15TD3uOURDxSr2HUxPIVpxh20TBPvR4UGvU2JAvP
         5yNKFoG/3N6g7E7QUokNd5DpqgZCUf9kwE6jLarL5VmO6IOKZ4SRo0KydSN9uzfJ7Df9
         UGSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793908601; x=1794513401;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+79bNgbupiQeNxrxjgpQjkbzWlu23rAY98ebtgDI/gg=;
        b=YcYlOoUt3SCmucgWEflzTboFDzGDxs4g+1urM7QmiKtQUm6UIfcz5VOYSZ7c4Dq97u
         ConKX64oOTvkgCECC/l+KMCrlvFqFmpYxmVpUrJ5SP0yvypz2yirI4PMZSXFXslSUSLI
         qKRf9NLy09tLqsfX+/G8ci2BKdJy4i8X9qxNL5lfxQCw1O6Ns5++sN2swRXrCBdhJJe7
         5RI/1Z4jBPp6JKkYbX9F3RVhlPfnqtk5HllazDYZ1JtPjFLJumjFOyrQcPAuPE61M9zn
         Aa/PCz71C6YgAbPBzHYNpPTJV6Wf5SP70RRcomnKERVAFx2vxSoZF304mXEORfazxFzQ
         sd3A==
X-Gm-Message-State: APuU4Z8YSWai/wqNb7AVUwTgNQ+x27xBZhVyUrb8a/9ch08+nULLqEfA
	HIhmHBqX6SS8FqUdcDxUujTRtO+GAw++EEwDvy+dRJRIJ1DMSG3RvV/p
X-Gm-Gg: AYBFou0T/6MgE8tN4t+Gh8S6bLGMAliMgMawZ6h/hWM0uOX7dPdeLNYmL0WTMyeShnj
	oracAeglls8Tg9XC5xP5HgDVQdtvsuiFDHznaYnk8v0jjUqWoeYA22Hi/jHyS0bc4XxNhOM6aZr
	/L+j3+rmnN+8v4AvSa2fmYHdrLQbiKG36RXRlegAe7sSjDBTDuN+7a/dpagLgMa09obDtw/3jjO
	uV73HcqBdjCs7u6hZJV+dVA4KqaziU0B9EyjzeM1+/5hCYiG9bQvgy2VdU5MNC4gdeL+YJ3/m/7
	qLUdK5GNrZenK53V6+6mJ0fBFFY8SsXSz0/VrastAiv6ub/9orNlY48DWgzsvDp8UblPg0GM+yI
	VSnTMl/XetxPLuxeKUp3CDpbABakDetXljdM9rvcms51gB5ZUJEXMk7Ew484Z6tXL7GgGr3jjQr
	PYcwXXMg4UKVZxrMrASJRTx/TKVM0bhULIQoNIbZifs0Z90TOgmgPXhYHKTUltWdc89vjv4lRBB
	SlKcImxh3ZNKD0q45YpJ/aluSbfny67QjE8XmlEmZXPVu9hL+ZecBo9PaYM/mJwbglP+4Z4x7Wi
	58b1jZ7yKWHVS9VgcqXNCTh0CZknNZhX9FumUrC7HPNcfp5iQlIyBl6sPfOLJPbDVYB36h4/LhE
	r4w==
X-Received: by 2002:a05:6402:43ca:b0:6b5:78c1:e22c with SMTP id 4fb4d7f45d1cf-6b59753cc2fmr239105a12.5.1793908600381;
        Thu, 05 Nov 2026 11:56:40 -0800 (PST)
Received: from [192.168.0.50] (93-159-22-87.cgnat.inetia.pl. [93.159.22.87])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6b5719cd68dsm1278500a12.37.2026.11.05.11.56.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Nov 2026 11:56:39 -0800 (PST)
Message-ID: <b7f6858b-5a8c-49f1-87a9-2763513300cf@gmail.com>
Date: Thu, 5 Nov 2026 20:56:37 +0100
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Post: <mailto:syzbot@lists.linux.dev>
List-Help: <mailto:syzbot+help@lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
List-Owner: <mailto:syzbot+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v2] md: drop a never-started reshape request when
 stopping the array
To: syzbot <syzbot@kernel.org>, syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
References: <3ba40dcd-182e-4830-b254-c457032bef30@mail.kernel.org>
Content-Language: en-US
From: Uladzislau Zhauniarovich <uladzislau.zhauniarovich@gmail.com>
In-Reply-To: <3ba40dcd-182e-4830-b254-c457032bef30@mail.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


The v2 code is correct. Please keep the diff exactly as it
is, including where struct md_rdev *rdev is declared and the shorter
comment.

I tested v2 in QEMU with KASAN on a v7.2-rc5 based tree with
0669c7dbd1d3 applied:
- The reproducer: 2/2 clean. The array starts again with its old
  geometry (3/3 devices).
- The variants are all clean, and the array comes back each time:
  raid_disks +1 without frozen, a pending layout change, a pending
  chunk_size change, shrink by 2 (data md5 unchanged), and a restart
  via readonly.
- raid10 near2 with a pending offset2 layout: after inactive -> active
  the data md5 is unchanged.
- new_level written while the array is inactive, and a crafted
  superblock with RESHAPE_ACTIVE and reshape_position ~0: both get
  -EINVAL from 0669c7dbd1d3, as expected.
- A grow from 3 to 4 disks completes with the data intact.
- A reshape parked at reshape_position 49152, then inactive -> active,
  resumes at 49152 and finishes with the data intact.

Please send a v3 that changes only the commit message and the
recipients:

1) Fix the commit reference. checkpatch reports an ERROR for
   "Commit 0669c7dbd1d3 replaced ...". Write it as:

     Commit 0669c7dbd1d3 ("md/raid5: don't BUG() on an inconsistent
     reshape state from the superblock") replaced the BUG_ON in
     raid5_run() with an -EINVAL check, ...

2) Replace the stack trace with the one from the syzbot report. The
   current one is the v1 trace, and array_state_store has no file:line
   in it:

     kernel BUG at drivers/md/raid5.c:8117!
     RIP: 0010:raid5_run+0x11a7/0x1670 drivers/md/raid5.c:8117
     Call Trace:
      md_run+0xc2f/0x2510 drivers/md/md.c:6779
      do_md_run+0x36/0x660 drivers/md/md.c:6880
      array_state_store+0x9c5/0xcf0 drivers/md/md.c:4765

3) Add the starting state as the first line of the reproduction
   sequence:

     # raid5 running on 3 devices
     echo 4 > /sys/block/md0/md/raid_disks
     echo inactive > /sys/block/md0/md/array_state
     echo active > /sys/block/md0/md/array_state

4) Add this tag after the Fixes: line:

     Cc: stable@vger.kernel.org

   0669c7dbd1d3 has a Fixes: tag and will be backported. Without this
   patch, stable arrays that hit this sequence will then fail to
   restart.

5) Add Yogesh Gaur <yogeshgaur.83@gmail.com>, the author of
   0669c7dbd1d3, to Cc.

Keep everything else as it is: the subject, Fixes:, Reported-by:,
Closes: and the rest of the text. v3 should have the same diff as v2.

Tested-by: Uladzislau Zhauniarovich <uladzislau.zhauniarovich@gmail.com>

On 02/11/2026 17:16, syzbot wrote:
> Writing raid_disks, layout, or chunk_size on a running array records a
> reshape request in struct mddev without starting the reshape until
> sync_action is set to "reshape". Because super_90_sync() and super_1_sync()
> only write reshape metadata to the superblock when reshape_position !=
> MaxSector, a never-started reshape exists purely in memory. Dropping the
> request when the array is stopped matches the state that would be loaded on
> disk reassembly.
> 
> A minimal reproduction sequence is:
> 
>   echo 4 > /sys/block/md0/md/raid_disks
>   echo inactive > /sys/block/md0/md/array_state
>   echo active > /sys/block/md0/md/array_state
> 
> Modifying layout or chunk_size behaves similarly. When restarting the
> array, raid5_run() previously assumed no reshape was taking place because
> reshape_position was MaxSector and triggered a kernel BUG due to
> delta_disks != 0:
> 
> kernel BUG at drivers/md/raid5.c:8117!
> Oops: invalid opcode: 0000 [#1] SMP
> RIP: 0010:raid5_run+0x2550/0x2560 drivers/md/raid5.c:8117
> Call Trace:
>  <TASK>
>  md_run+0xc3d/0x1cd0 drivers/md/md.c:6779
>  do_md_run+0x35/0x720 drivers/md/md.c:6880
>  array_state_store+0x958/0xe90
>  md_attr_store+0x3b7/0x640 drivers/md/md.c:6158
>  kernfs_fop_write_iter+0x3a4/0x540 fs/kernfs/file.c:345
>  vfs_write+0x612/0xba0 fs/read_write.c:687
>  ksys_write+0x150/0x270 fs/read_write.c:739
>  do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>  </TASK>
> 
> Commit 0669c7dbd1d3 replaced the BUG_ON in raid5_run() with an -EINVAL
> check, but the underlying issue remained: raid5 fails to restart with
> -EINVAL, and raid10 silently returns incorrect data due to unchecked
> new_layout and new_chunk_sectors in setup_conf().
> 
> Drop the never-started reshape request in __md_stop() if no reshape is
> currently running (mddev->reshape_position == MaxSector). Reset delta_disks
> and reshape_backwards to 0, restore new_level, new_layout, and
> new_chunk_sectors to level, layout, and chunk_sectors, and reset each
> rdev's new_data_offset to data_offset. If a reshape is actively in progress
> (mddev->reshape_position != MaxSector), the parameters are preserved so the
> reshape can resume when the array is restarted.
> 
> Fixes: 9e653b6342c9 ("[PATCH] md: Set/get state of array via sysfs")
> Assisted-by: Gemini:gemini-4-argon Gemini:gemini-3.8-flash syzbot
> Reported-by: syzbot+1f5a7de91d547763f4c8@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=1f5a7de91d547763f4c8
> Link: https://syzkaller.appspot.com/ai_job?id=aed1664c-30b2-4920-81b4-ed098ec14e92
> To: <linux-raid@vger.kernel.org>
> To: "Song Liu" <song@kernel.org>
> To: "Yu Kuai" <yukuai@fygo.io>
> To: "NeilBrown" <neilb@suse.de>
> Cc: <linux-kernel@vger.kernel.org>
> Cc: "Li Nan" <magiclinan@didiglobal.com>
> Cc: "Xiao Ni" <xiao@kernel.org>
> 
> ---
> v2:
> - Reset rdev->new_data_offset to rdev->data_offset for all member devices.
> - Add an explanatory comment in __md_stop().
> - Update commit subject and description per reviewer feedback.
> 
> v1:
> https://lore.kernel.org/all/0bbc5530-3021-49ec-a8cd-a006c2639d53@mail.kernel.org/T/
> ---
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 680b34a63..011a5ea54 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -7084,6 +7084,7 @@ static void mddev_detach(struct mddev *mddev)
>  static void __md_stop(struct mddev *mddev)
>  {
>  	struct md_personality *pers = mddev->pers;
> +	struct md_rdev *rdev;
>  
>  	mddev_detach(mddev);
>  	md_bitmap_destroy(mddev);
> @@ -7095,6 +7096,21 @@ static void __md_stop(struct mddev *mddev)
>  	mddev->private = NULL;
>  	put_pers(pers);
>  	clear_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
> +
> +	/*
> +	 * A reshape requested on a running array exists only in memory before
> +	 * sync_action=reshape and should be dropped with the personality, while
> +	 * a started reshape (reshape_position != MaxSector) is preserved.
> +	 */
> +	if (mddev->reshape_position == MaxSector) {
> +		mddev->delta_disks = 0;
> +		mddev->reshape_backwards = 0;
> +		mddev->new_level = mddev->level;
> +		mddev->new_layout = mddev->layout;
> +		mddev->new_chunk_sectors = mddev->chunk_sectors;
> +		rdev_for_each(rdev, mddev)
> +			rdev->new_data_offset = rdev->data_offset;
> +	}
>  }
>  
>  void md_stop(struct mddev *mddev)
> 
> 
> base-commit: df2908090cda368b01ff43709f51890076c56157

