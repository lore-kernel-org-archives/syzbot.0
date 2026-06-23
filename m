Received: from mail-oo1-f53.google.com (mail-oo1-f53.google.com [209.85.161.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDDC01F3B85
	for <syzbot@lists.linux.dev>; Tue, 23 Jun 2026 14:36:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.161.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782225372; cv=pass; b=T09Tc80RS+i07TqGuaiDA1gcaNUg7MadoRKDnokOS75srm4ae6debFBx7iW3YfyzwWSwyKCeMPPwXEitGah0HPbGVaIIN6dEhnCLDblPq5IAphOTzJGNngeZjpLqyg9/qKDW+5kz6J1J4q4ULrCmqBgm/RbHy93yID7kLqwSkwM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782225372; c=relaxed/simple;
	bh=8x1H1ycu0DDE/UsujvvLuCePIGyc1ahX35/8qbQwv6U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NUz2fHNjt/YK/vpUXLHk/ZJ6LCyQfS27uze+vHCdFjdXo0egZJrd8KV2kfuakxX3pypr/SjwdVb0AetjZqKCt4d863IXJ9ZAIZolekb974X+Jmc3HqX67jvDde31KOhey0CBlxVgHlLaMZndRedH+n4CHNXuhYHjGdKQd8P7efE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=u3zGL3ZR; arc=pass smtp.client-ip=209.85.161.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="u3zGL3ZR"
Received: by mail-oo1-f53.google.com with SMTP id 006d021491bc7-6a0e3a9c3a1so1485599eaf.1
        for <syzbot@lists.linux.dev>; Tue, 23 Jun 2026 07:36:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782225370; cv=none;
        d=google.com; s=arc-20240605;
        b=C6hTp9PCRgHRgYUmX5iTD+eVZJHNIqvm5PNifpWcWAXJMzhbAadulXSSNOeKdyR3zP
         y2WOINVhbybCrzkrnGea90NfMa/BnYUSyei2I0WtfruS/+yoX7ZGFRr3PfbnK3m2l6xH
         t21dsvYyh6fmtqUubBy3CmY4hwYXYfHy097yh4uB9l5YNFTsE34vJb21wIqEud0A7oRu
         BzQPDxzIBxvFjptCvYhMGu/VmDysybs1n4NO68TYl3tsrtM8YRLfQ5spM9jTfQWFDuLT
         oyS4iWu5JJOQROZOd+YwARgXJHZ9wvK+EQtNyWMDynh7C06146SyficTPcFnTCnKGb34
         TLQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=EsvcEDKoMSGkHZsPWnRB0I1aId/wK6AYI/6oD8g1Zkw=;
        fh=rVEidvPqKv7eKLO6cgb6Obs1T6+qYhZAVxbUPEfd+14=;
        b=hItWTtigjdxfXLBqsHJ4oQGJEfYcGFGJVXRo/RRR/enSIP0QO64ak+KFJGjbHj6IU9
         zZZ9z7ayk1bz6yBPJjDhBsiTSQasiLDG9HH1ThXZANScvUaG1eT6PCBsdytYL1FOI7A/
         e28VoccT7FXvCV8AOurxu6ytPEh5IP9OsOUq0vNS7+wj0hsThzSye38kRHB8x844hVd2
         Hov+gzUGo6qSqY/SPy2QWy+kKb/y2OraqAy9TWy33EFI0OMwAeHujEGV7Z2d9ywlLwCH
         7bBYrUyHPxP9S7315MX3ecQ1mVSPRCPfU8ytKAL03dDfFkwbjBzRUiHEIxGhTS+URyJE
         V/vQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782225370; x=1782830170; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EsvcEDKoMSGkHZsPWnRB0I1aId/wK6AYI/6oD8g1Zkw=;
        b=u3zGL3ZRl+bT3z9TSE2OvrtVxZ8s1+MJXSRa6dmOXg6CAFYmvIwulDBgPY4oQr9Ywy
         c58bB6xtFcCwWZVLdMhznOM2sbltKNUJLEvudmOXNTkpgfLuHIvTeUlqbI51K2GETM2q
         9XWnGF3XA44Hix+zm7YWrjIAyGb6Wk+jGYaPPmuMGUkJyXcSu/QbfRAo1UnlR0YTjCj3
         2AbsmRKoB8ncFzR1iZiaBnyJApfRyB1pyLDokVD6WTYkmVpvIJjgYGgYMx9Y/T2AFPmq
         oG0GvcDsish4x4NuhTjadz91rC9w+eud4+ax5Oi37h5H4vb2RraIXnkG28+EzqE0kSJ5
         jcZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782225370; x=1782830170;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=EsvcEDKoMSGkHZsPWnRB0I1aId/wK6AYI/6oD8g1Zkw=;
        b=FsZKmGiIYUKksgNcVb6x1XZVZLMT/LickjwKZg8fMY/ZhlESo5nehtdFeRVw8oNzcK
         Xdu5935WYGlXpO1VCRgMx0y+VmEkkWcvtzoajQSU9QYxI8a8c1B344q1OigxH020vfNK
         xiEH03NFfqvclidk/eo0ZtSlw4+m7uvRm7bZfQ82R9PY8Q0+7E6nXPiKI6N60M0mAVoq
         QvKFhRzV9bt0PUfxPOEEzU1MZlyyxuAwWHmWB2RBR3ykQV6KazMcW2fiPoWSaJyx2HO3
         zc7Pz3CUHGVLgAwGS8KYrdOocv9yQhc5CcwjKxIC2CIRMS14Zmu6Tto+A4Wznxu958um
         VnwQ==
X-Forwarded-Encrypted: i=1; AFNElJ/VNmpbiojloS9XF0nsTiLVZLsAUVHhiQ8wfQdNeDrqXzt6SEQ76/gSpg3kVlHZO9CEGrKSMNc=@lists.linux.dev
X-Gm-Message-State: AOJu0Yxs/M8RkSKE97YPTi8vzHQ2mEq0wEIPLHC7V7WYU/mE02JNj2DG
	MWKejJAm6FQ5nzlFFyzIKKkNxLZaQ6IWSUEqdeEO2pKfhmzq+Q7D+9DELaR6ybF2NXfih4eEl23
	vl6vuedLEUbgiK906W0Q+ZLFLdc9QTlJIiejKUjgL
X-Gm-Gg: AfdE7ck7G37sPllVQoM0j9JOiSgPDuxrzvT8zgen/bw3tZZbFLT81dI8xuuZkMXAMPi
	3sTJ9NBHwSBaVsfh+6tx1/VEgX1QBgAz2CeoKHZIf5UdGMs0gXpHjRspMrZZf9NPYCBG36pzgce
	5DUIFcIgyRXiY2Xe/tMEF8NVyIFuki1dP4PruFW3mQh/2aTeDl5fdjbq/inJxzsf8rU8CMKz/W8
	CtvvVsbxiKjVWoyUGW7taHUetmoefRQ8gM1PazIUJi+N41IxJQyLXqpizOv3k2YJ8fipS05PQnN
	kyHP0+nISohR3ks/3fE+uAY6+f9uRE+FTpfJpqBwQeLU/omQB1lQAuEtfIWsPc3GLOO/BtuT2tV
	rSMw7pSkz9auLnG5JOF1Y2+7H8c4mmUOKqDyTBz4b9qaWH8v3TEc=
X-Received: by 2002:a05:6820:8105:b0:6a1:1075:2248 with SMTP id
 006d021491bc7-6a1163c177emr1697192eaf.21.1782225369220; Tue, 23 Jun 2026
 07:36:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <6a3a996f.52ae72c2.136ac7.0008.GAE@google.com>
In-Reply-To: <6a3a996f.52ae72c2.136ac7.0008.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Tue, 23 Jun 2026 16:35:57 +0200
X-Gm-Features: AVVi8CdNilgWXxgZ1T9z-J2SOcX7MVU1Zy9XFjOj4Uc77A7UDgSkYrcMRr_tpVs
Message-ID: <CANp29Y7xrWc5Um1ugR0nKrM9hgZEj4LNOqe=F3vwAcjmk8OV-Q@mail.gmail.com>
Subject: Re: [moderation/CI] Re: namespace-aware configfs
To: syzbot ci <syzbot+ci6bfcafa8d238824b@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Tue, Jun 23, 2026 at 4:34=E2=80=AFPM syzbot ci
<syzbot+ci6bfcafa8d238824b@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v3] namespace-aware configfs
> https://lore.kernel.org/all/20260623-configfs-ns-v3-0-841c100fd5dd@kernel=
.org
> * [PATCH RFC v3 01/12] fs/configfs: rework configfs_is_root()
> * [PATCH RFC v3 02/12] fs/configfs: dynamically allocate super_info
> * [PATCH RFC v3 03/12] fs/configfs: separate out configfs_{link,unlink}_r=
oot()
> * [PATCH RFC v3 04/12] fs/configfs: add superblock as attribute to config=
fs_pin_fs()
> * [PATCH RFC v3 05/12] fs/configfs: add 'fill_subsystem' and 'clear_subsy=
stem' callbacks
> * [PATCH RFC v3 06/12] fs/namespace: implement mnt_clone_direct()
> * [PATCH RFC v3 07/12] fs/configfs: switch to get_tree_keyed()
> * [PATCH RFC v3 08/12] fs/configfs: open-code simple_pin_fs()
> * [PATCH RFC v3 09/12] nvmet: make discovery subsystem dynamic
> * [PATCH RFC v3 10/12] nvmet: per net-namespace port list
> * [PATCH RFC v3 11/12] nvmet: make configfs setup namespace aware
> * [PATCH RFC v3 12/12] nvmet: enable transports for net namespaces
>
> and found the following issue:
> BUG: sleeping function called from invalid context in configfs_get_super_=
info
>
> Full report is available here:
> https://ci.syzbot.org/series/f460be5a-d520-4bc1-9cfb-6492f841629b
>
> ***
>
> BUG: sleeping function called from invalid context in configfs_get_super_=
info
>
> tree:      bpf-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/bpf/b=
pf-next.git
> base:      66affa37cfac0aec061cc4bcf4a065b0c52f7e19
> arch:      amd64
> compiler:  Debian clang version 22.1.6 (++20260514074242+fc4aad7b5db3-1~e=
xp1~20260514074407.73), Debian LLD 22.1.6
> config:    https://ci.syzbot.org/builds/73803fa0-5ba4-4d03-976f-f9962ee98=
2c8/config
> syz repro: https://ci.syzbot.org/findings/4102267c-e678-4ffc-9ac0-4fb2dcb=
e5c0d/syz_repro
>
> BUG: sleeping function called from invalid context at ./include/linux/sch=
ed/mm.h:323
> in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 5856, name: syz.0.=
17
> preempt_count: 1, expected: 0
> RCU nest depth: 0, expected: 0
> INFO: lockdep is turned off.
> Preemption disabled at:
> [<0000000000000000>] 0x0
> CPU: 0 UID: 0 PID: 5856 Comm: syz.0.17 Tainted: G        W           syzk=
aller #0 PREEMPT(full)
> Tainted: [W]=3DWARN
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
>  __might_resched+0x378/0x4d0 kernel/sched/core.c:9193
>  might_alloc include/linux/sched/mm.h:323 [inline]
>  slab_pre_alloc_hook mm/slub.c:4559 [inline]
>  slab_alloc_node mm/slub.c:4916 [inline]
>  __kmalloc_cache_noprof+0x74/0x660 mm/slub.c:5446
>  _kmalloc_noprof include/linux/slab.h:969 [inline]
>  _kzalloc_noprof include/linux/slab.h:1286 [inline]
>  configfs_get_super_info+0x218/0x5e0 fs/configfs/mount.c:91
>  configfs_get_tree+0x41/0xd0 fs/configfs/mount.c:170
>  vfs_get_tree+0x92/0x2a0 fs/super.c:1694
>  vfs_cmd_create+0xa2/0x200 fs/fsopen.c:231
>  __do_sys_fsconfig fs/fsopen.c:463 [inline]
>  __se_sys_fsconfig+0x6b9/0x810 fs/fsopen.c:350
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f5c9db9ce59
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007f5c9ea71028 EFLAGS: 00000246 ORIG_RAX: 00000000000001af
> RAX: ffffffffffffffda RBX: 00007f5c9de15fa0 RCX: 00007f5c9db9ce59
> RDX: 0000000000000000 RSI: 0000000000000006 RDI: 0000000000000003
> RBP: 00007f5c9dc32e6f R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f5c9de16038 R14: 00007f5c9de15fa0 R15: 00007ffe63465d98
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
> To test a patch for this bug, please reply with `#syz test`
> (should be on a separate line).
>
> The patch should be attached to the email.
> Note: arguments like custom git repos and branches are not supported.
>
> The email will later be sent to:
> [a.hindborg@kernel.org brauner@kernel.org hare@kernel.org hch@lst.de jack=
@suse.cz kch@nvidia.com leitao@debian.org linux-fsdevel@vger.kernel.org lin=
ux-kernel@vger.kernel.org linux-nvme@lists.infradead.org sagi@grimberg.me v=
iro@zeniv.linux.org.uk]
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
-upstream-moderation/6a3a996f.52ae72c2.136ac7.0008.GAE%40google.com.
