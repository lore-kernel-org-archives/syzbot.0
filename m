Received: from mail-il1-f179.google.com (mail-il1-f179.google.com [209.85.166.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 172F82EA479
	for <syzbot@lists.linux.dev>; Wed,  3 Sep 2025 23:30:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756942203; cv=none; b=PCcePtWSZC/qDZAitCKQdzP9FGxk9eAOv5G6y2dep1BbttWr4xdHJDsqd1VTP6E6ytO1qfPOQZ+UJRuoV/IsybbNvRSmNEn09/jfF6W7A00P4Ppw3+0IK2z+unvJ1s2uphA8pCNMfp+wmfeqlOQh4sf+uohZFc1FWEPFcCs+yR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756942203; c=relaxed/simple;
	bh=GNr7VFuJevqVS2hBqVOZK3r8mR73l9bbWq/xzZ2iqUk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=E37nxbGYFxZanjAXavpXAlNi9n3Fa7/VRab8Ml7NtvwgYPFwK5TdkYmwyPuHYfna3wxuip16Kj/iHO/S6AITJxexH96vGqEzoJZ6pXTlgVPFci0Ip3hpc1/sfz92Dm4YPD8RFaQ1Q6A5NujdgM61xFMFMz0hUd/FxFEJVXNgafw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=YcttJ9d9; arc=none smtp.client-ip=209.85.166.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="YcttJ9d9"
Received: by mail-il1-f179.google.com with SMTP id e9e14a558f8ab-3f4d7feef27so3196915ab.3
        for <syzbot@lists.linux.dev>; Wed, 03 Sep 2025 16:30:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1756942200; x=1757547000; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YvqGMPyp0FchAqYhsEWYsUXhRgyEZLtEOdipJAz6MGY=;
        b=YcttJ9d9verG7oOkD+M3uHwNsLoRgfn8OZGS9wXPg2aswZBGH4sH8kCz/l02kjOoid
         aI3/P8c7LXcnrFmHlKZ+zxgkawfufV36QN6hsXtBQ61jY3Pr8kSv3/1n/Yr3o2bSnOIs
         anjcNs19zdmfumALwV2MiufeydLBbAoyP2QklkQ9YiYfRYK+MRoAZx8yCor/mXPGPWUz
         aB/nlPvQ/f9BEOj8joR1uKhlA5jaZ2lbM0xpfn0I881BJ0/wF0gHX70uXCl6E/KxEaN/
         0B0oVH36FIZg4Z+d4N1ONFYVPmYHJgAyDes42pGVBJqo49SI1vf3ix2qU5qndzpnwuTz
         JoFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756942200; x=1757547000;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YvqGMPyp0FchAqYhsEWYsUXhRgyEZLtEOdipJAz6MGY=;
        b=wfxblm0B1Mt6htd5nHVYsMG7RDUog9aeigIb6nRl0QFXf4Za7FgI5xfcNRGbwjbwzq
         uhC43f6T7DM7F3J+aBcsmnrIA+b76GgZywXEupBNgQVnR7PKG28Dc5U2a15one1ObMEh
         n4d7clIE+pIffmqvPtZ6UvD7Yu8f4+1Jxy+aYYWH8u4vkS8HRtFFV59WPx+QFEM8q/e7
         rTymf06qrP+W0wPu9OlFy9MbhQsVGTNMzEILdIotYcKMByW/suHjzYtyykwJRjl5ZUVe
         tpeIAAPGS0TteoD2t4ORojZgAholc/nD8dIQWnGfOf33+5TNT/nG2savyEuuJyiSA+Q0
         Ujjw==
X-Gm-Message-State: AOJu0YyyzndRMFFb4/cmKDmgoeMTtRLYByDP5dnSQIVajLBGjRfm0rEp
	aq2/Xb3L9ftAe5ysVW+OMfV61BCM21NMXVsysn07R/EjK/UEkB47SokUWdlDPaYj3AE=
X-Gm-Gg: ASbGnctLHN9eYydgf/79gExznGePHKm+y2F8idqEtvZyMh+PoZqTZpiv2sh46wttMDp
	gBdnDsYkig7E6NNs3YSa5jpG6+lqHj5vJ/qTkKPtQ2/dphi1d5W/iInCj6DxFIhquxGM5Kxwjon
	tISl5WmWiAcsruFPw4LknK+FPNA0ydxGXyV4EZ+KdHliRW371dZKSp2GtAkAtzELEtNH2CksVUV
	wQ3l8zjZEddl9IJEaq0+T5nnFRNVhUvmxikwo1zzV45Y7qCLDltYNFECBX2Ujh1NkptI7a72GGy
	AveMq0ClNzA2qNUMi8U15MZq28Y0jaWQKDwmPF+QvtHNZxh3ff2U0lejqGQbH3Ynwqyak8icUyp
	zaCNhucv0S51/cPXz4JYaM6yqOfWG
X-Google-Smtp-Source: AGHT+IHu4lmtN61kR+SUYR1vSljYZPLL/bhjVNR3pwIPbHq7Flpijoa8vuWAQObGbrdcYyjDn0HhKA==
X-Received: by 2002:a92:c24b:0:b0:3e5:53da:3d7 with SMTP id e9e14a558f8ab-3f400097e47mr319540815ab.6.1756942200159;
        Wed, 03 Sep 2025 16:30:00 -0700 (PDT)
Received: from [172.20.0.68] ([70.88.81.106])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3f3e07ea071sm56727295ab.31.2025.09.03.16.29.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Sep 2025 16:29:59 -0700 (PDT)
Message-ID: <26aa509e-3070-4f6b-8150-7c730e05951d@kernel.dk>
Date: Wed, 3 Sep 2025 17:29:57 -0600
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot ci] Re: io_uring: avoid uring_lock for
 IORING_SETUP_SINGLE_ISSUER
To: syzbot ci <syzbot+cibd93ea08a14d0e1c@syzkaller.appspotmail.com>,
 csander@purestorage.com, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
References: <68b8b95f.050a0220.3db4df.0206.GAE@google.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <68b8b95f.050a0220.3db4df.0206.GAE@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/3/25 3:55 PM, syzbot ci wrote:
> syzbot ci has tested the following series
> 
> [v1] io_uring: avoid uring_lock for IORING_SETUP_SINGLE_ISSUER
> https://lore.kernel.org/all/20250903032656.2012337-1-csander@purestorage.com
> * [PATCH 1/4] io_uring: don't include filetable.h in io_uring.h
> * [PATCH 2/4] io_uring/rsrc: respect submitter_task in io_register_clone_buffers()
> * [PATCH 3/4] io_uring: factor out uring_lock helpers
> * [PATCH 4/4] io_uring: avoid uring_lock for IORING_SETUP_SINGLE_ISSUER
> 
> and found the following issue:
> WARNING in io_handle_tw_list
> 
> Full report is available here:
> https://ci.syzbot.org/series/54ae0eae-5e47-4cfe-9ae7-9eaaf959b5ae
> 
> ***
> 
> WARNING in io_handle_tw_list
> 
> tree:      linux-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/next/linux-next
> base:      5d50cf9f7cf20a17ac469c20a2e07c29c1f6aab7
> arch:      amd64
> compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
> config:    https://ci.syzbot.org/builds/1de646dd-4ee2-418d-9c62-617d88ed4fd2/config
> syz repro: https://ci.syzbot.org/findings/e229a878-375f-4286-89fe-b6724c23addd/syz_repro
> 
> ------------[ cut here ]------------
> WARNING: io_uring/io_uring.h:127 at io_ring_ctx_lock io_uring/io_uring.h:127 [inline], CPU#1: iou-sqp-6294/6297
> WARNING: io_uring/io_uring.h:127 at io_handle_tw_list+0x234/0x2e0 io_uring/io_uring.c:1155, CPU#1: iou-sqp-6294/6297
> Modules linked in:
> CPU: 1 UID: 0 PID: 6297 Comm: iou-sqp-6294 Not tainted syzkaller #0 PREEMPT(full) 
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
> RIP: 0010:io_ring_ctx_lock io_uring/io_uring.h:127 [inline]
> RIP: 0010:io_handle_tw_list+0x234/0x2e0 io_uring/io_uring.c:1155
> Code: 00 00 48 c7 c7 e0 90 02 8c be 8e 04 00 00 31 d2 e8 01 e5 d2 fc 2e 2e 2e 31 c0 45 31 e4 4d 85 ff 75 89 eb 7c e8 ad fb 00 fd 90 <0f> 0b 90 e9 cf fe ff ff 89 e9 80 e1 07 80 c1 03 38 c1 0f 8c 22 ff
> RSP: 0018:ffffc900032cf938 EFLAGS: 00010293
> RAX: ffffffff84bfcba3 RBX: dffffc0000000000 RCX: ffff888107f61cc0
> RDX: 0000000000000000 RSI: 0000000000001000 RDI: 0000000000000000
> RBP: ffff8881119a8008 R08: ffff888110bb69c7 R09: 1ffff11022176d38
> R10: dffffc0000000000 R11: ffffed1022176d39 R12: ffff8881119a8000
> R13: ffff888108441e90 R14: ffff888107f61cc0 R15: 0000000000000000
> FS:  00007f81f25716c0(0000) GS:ffff8881a39f5000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000001b31b63fff CR3: 000000010f24c000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  tctx_task_work_run+0x99/0x370 io_uring/io_uring.c:1223
>  io_sq_tw io_uring/sqpoll.c:244 [inline]
>  io_sq_thread+0xed1/0x1e50 io_uring/sqpoll.c:327
>  ret_from_fork+0x47f/0x820 arch/x86/kernel/process.c:148
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
>  </TASK>

Probably the sanest thing to do here is to clear
IORING_SETUP_SINGLE_ISSUER if it's set with IORING_SETUP_SQPOLL. If we
allow it, it'll be impossible to uphold the locking criteria on both the
issue and register side.

-- 
Jens Axboe
