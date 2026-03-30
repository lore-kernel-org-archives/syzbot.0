Received: from mail-oa1-f46.google.com (mail-oa1-f46.google.com [209.85.160.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9102639EF24
	for <syzbot@lists.linux.dev>; Mon, 30 Mar 2026 07:37:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774856234; cv=pass; b=YaGLNuGSyZPp+eOYoMiSqqASIOmniwDH+eU5hNPj8oqrTlIUqboiD9MBlZi8JBB17VhT/BwtTrm2tGlC3gu5i2d9EHI/frnld+PiNX5Mui/XebzJAdo9A8gJsEU1fFVgcwVCP8+Kb5P4M7CC5OTgm/kRReUhmFMyqdHnupt5X0k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774856234; c=relaxed/simple;
	bh=UOOJvK9AGyh6JC08/k8VEy8RSI+CbiN62wQyr7lGLQI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PWcO2NYq92VxgKLB1j2GeS+cLZn92Of10lc89cvoV8CGc8RjRlrDUNd8zViCHTpMr/W90o7Wk6uSr8fCvLDtSO7Rp63m9WsXlHYfhz810nimzaj1sxwXn0zvbdbKQfPCmdixNauCcztTzyRNPzdUoGiX9X2dWCsUx2B2KCi4pPM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=W9E10VDs; arc=pass smtp.client-ip=209.85.160.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="W9E10VDs"
Received: by mail-oa1-f46.google.com with SMTP id 586e51a60fabf-41c4d660b19so1243537fac.1
        for <syzbot@lists.linux.dev>; Mon, 30 Mar 2026 00:37:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774856228; cv=none;
        d=google.com; s=arc-20240605;
        b=NWIqaZx+b4/7SXgfYtVdQWBolLteVdBURK2NGRDsULbIxLiyUuRkr40IZ7q7K44xIn
         VRHrJ304NrPW4l308g60Ac1T7s0mRuW0qWw0Cq6NwExRC25UF3Q7+PIlNDUbEPSJA/B2
         z2EP69Upuq6JGzko9tiCrzShgFqPfL6r1wgRn0Oq4odJwbSB8ige3y51fSE/9MB5EkOC
         VUIcRpHJ6ISzAtUoyPad+NUiu3E3jwPv5IMesby1kK0LMi2Gt4ypqvdtwGw5jCwy78jq
         gJozlXKgiKQBxseWfNTddvGkPVeDs0hkrmwKdSeX0RWlKr5mogx9ffS4dHqlNZ7TttMy
         bBBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=TzOq0mF8xjJtCBN7M6PmEu0lVO3b2PQgKn8/CALfxD0=;
        fh=TiHiRNcLkTEXPFptoKO31seN+hztt3aTWpdCIa2Gua0=;
        b=FXwTS3de7L3K73IQkN5TmqRZpv+57y1p5OrRBkvpaOXhzYWP7pV9zBQoYg/ZQgV89H
         o998e7Q2HCXzzJtIFb2P2njeOocGxPPJX252SnStQ4TzUf0lNx+rZnNc6m/IibiFCvmn
         Yb3Nzjjiqg8y4Qpue5kZjbSCyJ86MZg5zdGWYQfnMth5upaX7zOmBceVcmbjkRbuFCPC
         iVkKelkfYvdw71xgvF6dX7o/40Ck5+xfVb7Ii0M2+nN8NydC52VsqjUJ4SbO2xe9pp+9
         3cOYUjFx8NTETalpMtVsGsHmDzUoHXtwATxL4PTb3ZXQ7ZG23sB9lZjwH81lHtLz5n8Z
         S06Q==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774856228; x=1775461028; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TzOq0mF8xjJtCBN7M6PmEu0lVO3b2PQgKn8/CALfxD0=;
        b=W9E10VDsBK0kSjwws0Sr+zlRo7IGlypr1TVx6Zqj1SxqinYxA5aPaHUB4yq26ENiM/
         YoEzxZpzWp/sOJa8dciPToJlNi493J9KChtakmMmcWt3O0uKs7UaSOmQsDtHJnnq1rzN
         rvAK3qYe2OogTbJd+5q5ZlpbXqcGTvjZucj18Mk10Q6jDitXzy25zrvlT/brr+ob9Mkl
         F9cxbDG7SFt76HiLKn8DlaVHAGiiKqOrOxLJ84loSKgPiVUJi/2vMO/+aSrKoyXe3qgA
         nHBMVkiLEsZcXZAyFm42vuuvSKVUNvnaSBdO7i/3w4kSvJdmtv4EPVqgE2U4bcH/mMoI
         jVgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774856228; x=1775461028;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=TzOq0mF8xjJtCBN7M6PmEu0lVO3b2PQgKn8/CALfxD0=;
        b=U7kR7cOs726mDd0nB0L9FI6dHKqi5baff298ik+agaLqGcn+1aV2dJWghajl84UwpC
         o/ikzha82S+8b7zUEpMaqglXGkjMjgy4On2cHXsiK7O8HcHjr7izC44TXWHJo9e4pjrX
         cIDoYrI4xeIWlFUEUXPxDtvrRfKqLQiFARdhucSgtN6tKKxNFmanftvp5Da28uBZlzfr
         qlBAOzEX9el7dtdsIBbc6bKFHunx93HsLr5xqd0A9ggF8508aPaY9d8ARc2iIEql0UI1
         HaXeiTw87VIUXBEnSq2nJdzjVPexELMXrc/SEYB3QDOQrveaJ8Hrj7EG0oSagEcpudeT
         WlPQ==
X-Forwarded-Encrypted: i=1; AJvYcCVqsyQR8reuws8+EhmvxlzFHe/CFNS6KCydonBHehKpQQqBwYd6GXPzqnk528b57zXOMlBeiTc=@lists.linux.dev
X-Gm-Message-State: AOJu0YzXY36mFZ9HpshePpFuTJnSHLHHneAm7a46Ez8M675s9k6tWu2a
	JZeNuldecTIOFZVV8j6YpgS0Mdml0wPmt3VA+3bC6Tkb65NRvASK32fhgIL9ySz0DMMQFR9pdIK
	+R/U7m9ANeMoUK4VCDi3sjqNJCUQT/MEwNmIMVPvt
X-Gm-Gg: ATEYQzxIaDdQsEJkldVIIt3InarRp2zxpu9NE5S7HdBf2O7nXFob5cKggh3gbsqHPHK
	a1E7fMgyNL+upC+deAn8N4R+540/i89wHC8XwWZa3hr8O2nT6JMDHxyi/YeCNbXpQSAvkN8Iaki
	8FrJHdVx5DZ9d1wY5h1atY6AidvJWr5VIjkWrh/tO0+LdzZ0A42NCSahIw/L2niHHaDt1ZEWtpY
	U1rZRbE3ImOe4miXwXFFJDXEu174PChM5AzT1lmbBTNfKW62JeEEC8hBMkBRJLTbKQAkVD1WL9R
	S4SvTbQSrfoJjLorn5VZLlXo6PiKXBblXNpJ8J9KWTrjtjkRZq66M3+XPjWN+fJxtFDT+Q==
X-Received: by 2002:a05:6870:80d4:b0:41c:28d1:2c1d with SMTP id
 586e51a60fabf-41cec08df0amr6218787fac.9.1774856227145; Mon, 30 Mar 2026
 00:37:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <69c98438.a70a0220.128fd0.0037.GAE@google.com>
In-Reply-To: <69c98438.a70a0220.128fd0.0037.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Mon, 30 Mar 2026 09:36:55 +0200
X-Gm-Features: AQROBzDv9f6EKnTp1h5hJzRRWBu4EnPI-dgbPY-D-kYm9v0Um-oVJAejF7moBYg
Message-ID: <CANp29Y6F2-k0-4dFRjaX4sv+Lp0YySWo2Ftp67njQhxp5K+QmA@mail.gmail.com>
Subject: Re: [moderation/CI] Re: assorted ->i_count changes + extension of
 lockless handling
To: syzbot ci <syzbot+ci84768f4d20490e70@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Sun, Mar 29, 2026 at 9:57=E2=80=AFPM syzbot ci
<syzbot+ci84768f4d20490e70@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v3] assorted ->i_count changes + extension of lockless handling
> https://lore.kernel.org/all/20260329172002.3557801-1-mjguzik@gmail.com
> * [PATCH v3 1/7] fs: add icount_read_once()
> * [PATCH v3 2/7] Use icount_read() and icount_read_once() as appropriate.
> * [PATCH v3 3/7] fs: enforce locking in icount_read(), add some commentar=
y
> * [PATCH v3 4/7] fs: relocate and tidy up ihold()
> * [PATCH v3 5/7] fs: handle hypothetical filesystems which use I_DONTCACH=
E and drop the lock in ->drop_inode
> * [PATCH v3 6/7] fs: locklessly bump refs in igrab as long as it does not=
 transition 0->1
> * [PATCH v3 7/7] fs: locklessly bump refs in the inode hash when possible
>
> and found the following issue:
> WARNING in bdev_file_open_by_dev
>
> Full report is available here:
> https://ci.syzbot.org/series/ed1deb86-adfc-43a1-bec0-01d8189f1e9f
>
> ***
>
> WARNING in bdev_file_open_by_dev
>
> tree:      linux-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/next/=
linux-next
> base:      3b058d1aeeeff27a7289529c4944291613b364e9
> arch:      amd64
> compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~e=
xp1~20251221153213.50), Debian LLD 21.1.8
> config:    https://ci.syzbot.org/builds/84ba2ea1-23ea-425b-8339-8acab8f7a=
d4b/config
>
> 9p: Installing v9fs 9p2000 file system support
> NILFS version 2 loaded
> befs: version: 0.9.3
> ocfs2: Registered cluster interface o2cb
> ocfs2: Registered cluster interface user
> OCFS2 User DLM kernel interface loaded
> gfs2: GFS2 installed
> ceph: loaded (mds proto 32)
> cryptd: max_cpu_qlen set to 1000
> NET: Registered PF_ALG protocol family
> async_tx: api initialized (async)
> Key type asymmetric registered
> Asymmetric key parser 'x509' registered
> Asymmetric key parser 'pkcs8' registered
> Key type pkcs7_test registered
> Block layer SCSI generic (bsg) driver version 0.4 loaded (major 239)
> io scheduler mq-deadline registered
> io scheduler kyber registered
> io scheduler bfq registered
> xor: measuring software checksum speed
>    prefetch64-sse  :  6910 MB/sec
>    sse             :  6480 MB/sec
> xor: using function: prefetch64-sse (6910 MB/sec)
> input: Power Button as /devices/platform/LNXPWRBN:00/input/input0
> ACPI: button: Power Button [PWRF]
> ioatdma: Intel(R) QuickData Technology Driver 5.00
> ACPI: \_SB_.GSIG: Enabled at IRQ 22
> N_HDLC line discipline registered with maxframe=3D4096
> Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
> 00:03: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 115200) is a 16550A
> Non-volatile memory driver v1.3
> Linux agpgart interface v0.103
> usbcore: registered new interface driver xillyusb
> ACPI: bus type drm_connector registered
> [drm] Initialized vgem 1.0.0 for vgem on minor 0
> [drm] Initialized vkms 1.0.0 for vkms on minor 1
> Console: switching to colour frame buffer device 128x48
> faux_driver vkms: [drm] fb0: vkmsdrmfb frame buffer device
> usbcore: registered new interface driver udl
> bochs-drm 0000:00:01.0: vgaarb: deactivate vga console
> [drm] Found bochs VGA, ID 0xb0c5.
> [drm] Framebuffer size 16384 kB @ 0xfd000000, mmio @ 0xfebf0000.
> [drm] Initialized bochs-drm 1.0.0 for 0000:00:01.0 on minor 2
> fbcon: bochs-drmdrmfb (fb1) is primary device
> fbcon: Remapping primary device, fb1, to tty 1-63
> bochs-drm 0000:00:01.0: [drm] fb1: bochs-drmdrmfb frame buffer device
> usbcore: registered new interface driver gm12u320
> usbcore: registered new interface driver gud
> ------------[ cut here ]------------
> debug_locks && !(lock_is_held(&(&inode->i_lock)->dep_map) !=3D 0)
> WARNING: ./include/linux/fs.h:2242 at ihold+0x102/0x170, CPU#1: swapper/0=
/1
> Modules linked in:
> CPU: 1 UID: 0 PID: 1 Comm: swapper/0 Not tainted syzkaller #0 PREEMPT(ful=
l)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:ihold+0x102/0x170
> Code: b7 7c ff 83 fb 02 7c 11 e8 2b b3 7c ff 5b 41 5e 41 5f 5d e9 c0 e0 6=
b 09 cc e8 1a b3 7c ff 90 0f 0b 90 eb e9 e8 0f b3 7c ff 90 <0f> 0b 90 e9 6d=
 ff ff ff 48 c7 c1 e0 bd 12 90 80 e1 07 80 c1 03 38
> RSP: 0000:ffffc90000067680 EFLAGS: 00010293
> RAX: ffffffff82496f71 RBX: ffff888167cb06a0 RCX: ffff888102a957c0
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
> RBP: 0000000000000000 R08: ffff888167cb08a7 R09: 1ffff1102cf96114
> R10: dffffc0000000000 R11: ffffed102cf96115 R12: ffff888167cb0000
> R13: ffff888169632e00 R14: 0000000000000000 R15: dffffc0000000000
> FS:  0000000000000000(0000) GS:ffff8882a943f000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000000000000 CR3: 000000000e54a000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  bdev_file_open_by_dev+0x1aa/0x240
>  disk_scan_partitions+0x1c1/0x2c0
>  add_disk_fwnode+0x321/0x480
>  brd_alloc+0x5b9/0x7c0
>  brd_init+0xc1/0x120
>  do_one_initcall+0x250/0x870
>  do_initcall_level+0x104/0x190
>  do_initcalls+0x59/0xa0
>  kernel_init_freeable+0x2a6/0x3e0
>  kernel_init+0x1d/0x1d0
>  ret_from_fork+0x514/0xb70
>  ret_from_fork_asm+0x1a/0x30
>  </TASK>
>
>
> ***
>
> If these findings have caused you to resend the series or submit a
> separate fix, please add the following tag to your commit message:
>   Tested-by: syzbot@syzkaller.appspotmail.com
>
> ---
> This report is generated by a bot. It may contain errors.
> syzbot ci engineers can be reached at syzkaller@googlegroups.com.
>
> The email will later be sent to:
> [brauner@kernel.org jack@suse.cz linux-fsdevel@vger.kernel.org linux-kern=
el@vger.kernel.org mjguzik@gmail.com viro@zeniv.linux.org.uk]
>
> If the report looks fine to you, reply with:
> #syz upstream
>
> If the report is a false positive, reply with
> #syz invalid
>
> --
> You received this message because you are subscribed to the Google Groups=
 "syzkaller-upstream-moderation" group.
> To unsubscribe from this group and stop receiving emails from it, send an=
 email to syzkaller-upstream-moderation+unsubscribe@googlegroups.com.
> To view this discussion visit https://groups.google.com/d/msgid/syzkaller=
-upstream-moderation/69c98438.a70a0220.128fd0.0037.GAE%40google.com.
