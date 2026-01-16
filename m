Received: from mail-oo1-f48.google.com (mail-oo1-f48.google.com [209.85.161.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8CD6145348
	for <syzbot@lists.linux.dev>; Fri, 16 Jan 2026 13:48:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768571329; cv=none; b=QVq7k7YS4o8uybONrn7GVg9xqsBainQa+tGpViC2mlmk3vvLuqGNzMaoeXuaDpHLbObImaOuEZlc1DXbufU/F9eh8rxhGj70xm3joky/XQ9W6DzeeJPBSw4Qfd2s87bsOHoQk029VouzubHOUW4rnbfQCGNXipTRWHfL2U5X35Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768571329; c=relaxed/simple;
	bh=ZAjjjpwjmtY4WJ9qRLQjuiXpxBRGT/m0370PCXvHL68=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CxyTeputGLXtz3IuNAKMNciw/eRDzSLJ+mHksqYKyz9BlzMCU4Kko3GcW0h0PrpFqUOETTisytv6QN12GRPoTNfzFRFDI+LucJY5uVtLzrbFgrXee63oMEIe6Z6/Jxp+UMQDTk0o2r9vN76Kz82c/Qnr0zpoQZjesWpTG7DdDow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=WHFJh4fb; arc=none smtp.client-ip=209.85.161.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WHFJh4fb"
Received: by mail-oo1-f48.google.com with SMTP id 006d021491bc7-66105b0b931so970222eaf.1
        for <syzbot@lists.linux.dev>; Fri, 16 Jan 2026 05:48:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768571327; x=1769176127; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=faC9tmCn2MgnGokEZQzDa2pZSZ/drZJHh/d1TlFbgB8=;
        b=WHFJh4fbn13ii72zGeeUasHLUK5LyeOaW2H6+/W/lst2P4emwPC2thHu8EgHe4rT/g
         gMOL8XenSNanEr5uXC5Hnafwceeo8ex7TpzEOjb0NMppwWlXeXcDR64JWdeudb8mAxen
         ZaqDCnWqJBDYB8m2xnFgkvuJJDPKSF08PHZc/eXZoGS7YtVPdNX7TjOF6uRRK4Gwzm4Y
         jr3+qOcapu6RXCOTFMFYAa1cMPepat6Z1w8M/nddsr2U3IckSlvUaPhI95/wgaOKDmVD
         Q+E6Zm5Ppn1yvPVEnJk00hri7NX9cJOkveUO3r1OseUPEOixiBHG9QsaIVTbxAD44vM+
         TvjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768571327; x=1769176127;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=faC9tmCn2MgnGokEZQzDa2pZSZ/drZJHh/d1TlFbgB8=;
        b=dP2SzAHhGOfydrPuFnNhyV5t1CObS1Iae2Dt6t/DTnRu2AEXu1bx0cNjLRtP/w+Jid
         btQU4pqV7brFn7bq3NffzkuUiw72XC0pV5hOAtJwllOTIZK7ZWFsrDnMKMFj7YEEK2PG
         WwJGZdEa3AI6i3zTIpx0MZnPnLYg1YtLuiGSgxWpMgQkLB3LVTBLFKRVgcrrQDTq026f
         mLCHPI+SlXbDotPN6WlOWINSUCiES69dRcJLuVtVmWb+Uw/jIi7ed32RQB9WYlbjDmhb
         ynTntO+bOZGxM5hRUVcyX7B7L+xKqy6oLBX8lBxQ0G3qxtbXUaoC5GgDrvRCRU1HA9Hf
         8FSg==
X-Forwarded-Encrypted: i=1; AJvYcCW8lElJ8do4n2z8E0Rt3pBhisfMZKVPRdVmsZfbMnpWhDznh9pmVg4QJgYuA+hcYLiA1h60B1E=@lists.linux.dev
X-Gm-Message-State: AOJu0YwbJVZZ1EC7jCAGySaSdzg9LS54krhGZrivED9aFpOhWg8WbWOJ
	6l2A2lKQKhNvs+vCVNuZmUzEj7KrBeULD8FHBQ1BC6t8NgHwDPqspjSDQq+9RK+UKb0Lur8yg5V
	3s6aGRELQ+R+noic37Sz0Q5Y3+J6uc8bq57Sur6ru
X-Gm-Gg: AY/fxX5vWV2Wmdlew3OwPUTCnFQn2U0bIibf8gvMetlnbXqSBJ90Nbaj4bjkGc9nHSX
	BPZBu5PHL5y4NKJHUtmgNoUTzImHEO4EgsnRYvuwQbtViFKw20BcqFz3jrNjG0O1No8L15HiEQR
	k9J0BUMH/m/9Q6Rwi+FaH0OQVGI5z/SkfmVKl396bRXvK7VtbMb+xLAd+CfDdWsc/N3SdB9CzdG
	NXDsXZ/gGf/VaWSaDESzXkqPfP4wp1hXtqYzJvIFO7Fb21zBQrlsEFEMGR/SGwR4qjU9Ohww2cG
	tyoIlH+GC6mCa/EdArKclXROstVkfGxyPPIyQN7TwEGztwAJCyi0as+iTA==
X-Received: by 2002:a05:6820:f02d:b0:65d:1697:e6cc with SMTP id
 006d021491bc7-661179f4827mr1280857eaf.60.1768571326556; Fri, 16 Jan 2026
 05:48:46 -0800 (PST)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <696a3342.050a0220.58bed.0049.GAE@google.com>
In-Reply-To: <696a3342.050a0220.58bed.0049.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Fri, 16 Jan 2026 14:48:34 +0100
X-Gm-Features: AZwV_QhL6_Gvzw7HqsJVAhMVdlG64oCm33tIqpbbQ-S2iFT7_5hfLUBDxEHUH44
Message-ID: <CANp29Y771VxmCZu9qxvECpW9zRW--oGs=x4ogUrtG6N8v8=1SQ@mail.gmail.com>
Subject: Re: [moderation/CI] Re: add and use vma_assert_stabilised() helper
To: syzbot ci <syzbot+cia77fc226b0df9f10@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Fri, Jan 16, 2026 at 1:47=E2=80=AFPM syzbot ci
<syzbot+cia77fc226b0df9f10@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v1] add and use vma_assert_stabilised() helper
> https://lore.kernel.org/all/cover.1768558900.git.lorenzo.stoakes@oracle.c=
om
> * [PATCH 1/2] mm/vma: add vma_is_*_locked() helpers
> * [PATCH 2/2] mm: add + use vma_is_stabilised(), vma_assert_stabilised() =
helpers
>
> and found the following issue:
> kernel BUG in anon_vma_name
>
> Full report is available here:
> https://ci.syzbot.org/series/a3867085-bae4-4416-9704-3b23ef9c6006
>
> ***
>
> kernel BUG in anon_vma_name
>
> tree:      mm-new
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/=
mm.git
> base:      eeb33083cc4749bdb61582eaeb5c200702607703
> arch:      amd64
> compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~e=
xp1~20251221153213.50), Debian LLD 21.1.8
> config:    https://ci.syzbot.org/builds/2e5b4d7e-a1a9-48c8-ae3b-654d3ac32=
e5c/config
>
> Loaded X.509 cert 'Build time autogenerated kernel key: 65176d093d4baf94a=
b1e788ee9f46804766f83ba'
> ima: Allocated hash algorithm: sha256
> ima: No architecture policies found
> evm: Initialising EVM extended attributes:
> evm: security.selinux (disabled)
> evm: security.SMACK64 (disabled)
> evm: security.SMACK64EXEC (disabled)
> evm: security.SMACK64TRANSMUTE (disabled)
> evm: security.SMACK64MMAP (disabled)
> evm: security.apparmor
> evm: security.ima
> evm: security.capability
> evm: HMAC attrs: 0x1
> PM:   Magic number: 10:472:582
> tty ptyc0: hash matches
> netconsole: network logging started
> gtp: GTP module loaded (pdp ctx size 128 bytes)
> rdma_rxe: loaded
> cfg80211: Loading compiled-in X.509 certificates for regulatory database
> Loaded X.509 cert 'sforshee: 00b28ddf47aef9cea7'
> Loaded X.509 cert 'wens: 61c038651aabdcf94bd0ac7ff06c7248db18c600'
> clk: Disabling unused clocks
> ALSA device list:
>   #0: Dummy 1
>   #1: Loopback 1
>   #2: Virtual MIDI Card 1
> check access for rdinit=3D/init failed: -2, ignoring
> md: Waiting for all devices to be available before autodetect
> md: If you don't use raid, use raid=3Dnoautodetect
> md: Autodetecting RAID arrays.
> md: autorun ...
> md: ... autorun DONE.
> EXT4-fs (sda1): mounted filesystem b4773fba-1738-4da0-8a90-0fe043d0a496 r=
o with ordered data mode. Quota mode: none.
> VFS: Mounted root (ext4 filesystem) readonly on device 8:1.
> devtmpfs: mounted
> Freeing unused kernel image (initmem) memory: 26044K
> Write protecting the kernel read-only data: 212992k
> Freeing unused kernel image (text/rodata gap) memory: 388K
> Freeing unused kernel image (rodata/data gap) memory: 1776K
> x86/mm: Checked W+X mappings: passed, no W+X pages found.
> x86/mm: Checking user space page tables
> x86/mm: Checked W+X mappings: passed, no W+X pages found.
> Failed to set sysctl parameter 'max_rcu_stall_to_panic=3D1': parameter no=
t found
> Run /sbin/init as init process
> vma ffff888175272d80 start 00007fffffffe000 end 00007ffffffff000 mm ffff8=
88100079880
> prot 8000000000000025 anon_vma ffff888110bf8000 vm_ops 0000000000000000
> pgoff 7fffffffe file 0000000000000000 private_data 0000000000000000
> refcnt 1
> flags: 0x8118173(read|write|mayread|maywrite|mayexec|growsdown|seqread|ra=
ndread|account|softdirty)
> ------------[ cut here ]------------
> kernel BUG at ./include/linux/mmap_lock.h:476!
> Oops: invalid opcode: 0000 [#1] SMP KASAN PTI
> CPU: 0 UID: 0 PID: 1 Comm: init Not tainted syzkaller #0 PREEMPT(full)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:anon_vma_name+0x253/0x260
> Code: ff 4c 89 ff e8 8e 7d 0a 00 e9 e9 fe ff ff e8 34 db a2 ff eb 0c e8 2=
d db a2 ff eb 05 e8 26 db a2 ff 48 89 df e8 6e 77 08 ff 90 <0f> 0b 66 66 2e=
 0f 1f 84 00 00 00 00 00 90 90 90 90 90 90 90 90 90
> RSP: 0000:ffffc90000067550 EFLAGS: 00010286
> RAX: 000000000000014c RBX: ffff888175272d80 RCX: 37717524f4bb9000
> RDX: 0000000000000000 RSI: 0000000080000000 RDI: 0000000000000000
> RBP: 0000000000000003 R08: 0000000000000003 R09: 0000000000000004
> R10: dffffc0000000000 R11: fffffbfff1c3ae40 R12: dffffc0000000000
> R13: dffffc0000000000 R14: 0000000000000001 R15: 0000000000000001
> FS:  0000000000000000(0000) GS:ffff88818e405000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: ffff88823ffff000 CR3: 0000000110c5a000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  vma_modify_flags+0x203/0x330
>  mprotect_fixup+0x46a/0xa50
>  setup_arg_pages+0x565/0xae0
>  load_elf_binary+0xc5e/0x2980
>  bprm_execve+0x93d/0x1410
>  kernel_execve+0x8ef/0x9e0
>  try_to_run_init_process+0x13/0x60
>  kernel_init+0xad/0x1d0
>  ret_from_fork+0x51b/0xa40
>  ret_from_fork_asm+0x1a/0x30
>  </TASK>
> Modules linked in:
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:anon_vma_name+0x253/0x260
> Code: ff 4c 89 ff e8 8e 7d 0a 00 e9 e9 fe ff ff e8 34 db a2 ff eb 0c e8 2=
d db a2 ff eb 05 e8 26 db a2 ff 48 89 df e8 6e 77 08 ff 90 <0f> 0b 66 66 2e=
 0f 1f 84 00 00 00 00 00 90 90 90 90 90 90 90 90 90
> RSP: 0000:ffffc90000067550 EFLAGS: 00010286
> RAX: 000000000000014c RBX: ffff888175272d80 RCX: 37717524f4bb9000
> RDX: 0000000000000000 RSI: 0000000080000000 RDI: 0000000000000000
> RBP: 0000000000000003 R08: 0000000000000003 R09: 0000000000000004
> R10: dffffc0000000000 R11: fffffbfff1c3ae40 R12: dffffc0000000000
> R13: dffffc0000000000 R14: 0000000000000001 R15: 0000000000000001
> FS:  0000000000000000(0000) GS:ffff88818e405000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: ffff88823ffff000 CR3: 0000000110c5a000 CR4: 00000000000006f0
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
> [akpm@linux-foundation.org david@kernel.org jannh@google.com liam.howlett=
@oracle.com linux-kernel@vger.kernel.org linux-mm@kvack.org lorenzo.stoakes=
@oracle.com mhocko@suse.com rppt@kernel.org shakeel.butt@linux.dev surenb@g=
oogle.com vbabka@suse.cz]
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
-upstream-moderation/696a3342.050a0220.58bed.0049.GAE%40google.com.
