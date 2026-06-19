Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 412BB24B28
	for <syzbot@lists.linux.dev>; Fri, 19 Jun 2026 13:23:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781875386; cv=pass; b=XhvR4rZQDfwJrlip173te7c+k8PNnmlkOwPx2lii/BLrG826P7iQqNB3TnOCN8j+s6TL+XrhDYp3om+JqI17pVoQQm9pktJaxNq+sC9aTghhcp3grDuRj1sm3sEcMgAbGYg6Q/txbPq8VueNWyc5nJC4mjbSlzEAuggFtBlyoCY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781875386; c=relaxed/simple;
	bh=OzRcCsAt0hsJ40Ax9uV20E6/s8MAYUQsHo8m7gIbwhk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uHAbRpT7Yy7pqysPUvwvkI4FagHAMV/J/gCspRZF6gGeeIE++Ra/NV58I29ZHSrqvPNUvyiq0/zwXmt6HVFxBIJNjw0Kwbzo7PD18X/8LJIelORxxGQ7M4/Q2wZ3B/4dBij7HjWCb00m2W09i+Fn9x0V8NoBoQ9WpcGRHkiVYjI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=X+20pARn; arc=pass smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="X+20pARn"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-490b211ee6aso14274455e9.3
        for <syzbot@lists.linux.dev>; Fri, 19 Jun 2026 06:23:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781875382; cv=none;
        d=google.com; s=arc-20240605;
        b=TdYxR1W3M88x4r0Rwi1BmxZA8/I+n4PBLmeSK7xKbTsWo3KVttVekliZ1L7mn0V1iI
         LfSNuEc+04SjswSmpjOZSn97x1DwNIW5/eikpN+6D7i3ePaBi0bpmvLRhkl6lCXJxdNN
         FKShoBbyoaXNwKJrA+Vx6N0QvlMuI/BFUguMvFPGpOKfPBVysyrsTtIlYe6FfadKDk4x
         IvJn9c8PCT1ARUK3ctCNW3/ZThk3MqlF8rxit+Cc0lIOeFelwVbTHrsbvUKQ/yaoXn0M
         L/dW3LXeLOKyLv7jmkepmgPJBkzIkZtli2viu5/TyZmiwBEAQLpOw5+BFlsWErKxvoyy
         9PvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=DABUP4lxJzj/Xzfsi4rtTBDb/hG2nz4ItS4koMQE0b4=;
        fh=32wEyOzSSeCPUvPGPiJMPJvj8xBg+SkUXB7RVVTl85A=;
        b=lYk/TM6BHoJxS/uP2WrqbzmO/GwrJMMK+2xW2Ludrn3VF+odPFYgwJPgRxbudloFxq
         arI0beGj7ElgOChTUMolPMVTIipj44rNvJayqpUPmyHCr6Hdl+dKX/bjBp2Om9gt0xqU
         VKwz7rezqEZ7oaq8pb2Gap4/K5DjGUWNTjGUreXe0qTikQYV+72W8p33SiYM2/7CMUzG
         nDycq8qGRqghO4Jg8dZ1lSkNunVDJoJN8A+k93XyIhnetkm2zCE4uBrcHKr2J5MUdTdx
         FduO37klqBCDXLx3HzSWEy6sAORx1vGWUvppdLmoyen6UbJopx27Fv+7bYdGHWFCSsRC
         apIA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781875382; x=1782480182; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DABUP4lxJzj/Xzfsi4rtTBDb/hG2nz4ItS4koMQE0b4=;
        b=X+20pARnG1xaZ3poBDBwW9hS8uHA5vBBXHL69MWKb3hu8IPrz+OLbtzjxa+m+Q/GKU
         xPAVGB+ijPxYNMsTqOX6POJwdiRulD275M0mTkgJPUhAc/Lyjh4qs9+EKtZQbejTDapU
         7wle3pHRZbd7aFVk7fB2JPmVudhh3oykLDS2ZKAL1az6KkiR80X4iJHhQIGFuwjoRCmW
         p8PbrdLUGrXtROSiU75wdvQWQ8qQgioYgXWVEFa6/6eW/Mml4ooEq9BrN4dBG95/KyyA
         qbpsgZ/zQVyQrjv3LwcBegH6qdQ2zcuCRl6IXspUisOA0ubzM325AL6zLed7IVSH2lnE
         yJHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781875382; x=1782480182;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=DABUP4lxJzj/Xzfsi4rtTBDb/hG2nz4ItS4koMQE0b4=;
        b=bSY57O/a6bRK/ra+oKbO3QuEcmvTjM+cdjZc+JLseu7nVY/JCDtBkqXHBMAaGakX4k
         sMxsEYOBj8wjFsEMyee9bo5DZo/oaaxdD+HFouD8Ixsu0cQ9LZYUu5Kb5IjWLXeGCWdK
         E6OCy/XnfFzoEIo3e9pgdMSToVkdQAHF4SYdYg18fH+Bm6MVC1A8cJFsQeP++P+QiKkn
         cBBrS3SsYtgIjxAqpftVsvvXDuY4Pr0+VAvFc+qxphxIWAMzepshe48Grovkx60d12mY
         mXm7WGnHYbFL2sxl9kY/LEp7e/mT0eqDB1cC+H+KJ7pxPuzeOnNiW4+WdWJp1H2yJ/Lk
         OEbg==
X-Forwarded-Encrypted: i=1; AFNElJ+sUGqggKld8ytE3V5PLXxCbn+HU9sOg0WZdWOiHxv85s2x0R/DSJPNjjY1jbioTiwMJ/JwIrc=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx6A6vrTNVtj2EQbLLbu/YKhwF/54ZhrUYpZee3q90BLwxEBfHq
	OSeI9kwOEMKfVSaNiLTJcyG0S/Fal9MxwN51DhQfAt1aEwUvVviLPT4aMqJUxXOCooyjYAw0Gkk
	HUAmctD3Q7gsiMrW9ycLkzFZ7muyb8ZALRwgkJ8whz+TEMAt/5Z9VZiXB
X-Gm-Gg: AfdE7ckiPuvkxKC0g5Jc5zDZEqLzJrjgP8DxT42C9h3FIkmejQTCxWMIeraJ3jIc2v0
	DKJz5RFy97htqggqN1yBB4PVwPpyqsBcqqs8wYFXLFZeZG2MBDfQTZ9895ft7CpncnaBrsIp/08
	gAKcDqLMQikn6OoJe9212yqc3+IQuA5188vOT72K+0WlFqF48NA/D/VAoHqAtNuh9KofJc4/svA
	Ryu0Nk2Pgk3ffEvSJN3kf1jE38sI5gKobm+ryJu4PD4oiz2hF5Is1Bz4Aq70YvaP7onQd2//nrZ
	cN/WENpi54UBxD+LXA70trp3N6WETMZd4yikwttW3WQnLBirROF7cEmpgJoaKVJvZVU=
X-Received: by 2002:a05:600c:2195:b0:490:e974:e006 with SMTP id
 5b1f17b1804b1-49240e9cc80mr40931455e9.29.1781875381840; Fri, 19 Jun 2026
 06:23:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <6a354228.6d5abbec.a50f.002f.GAE@google.com>
In-Reply-To: <6a354228.6d5abbec.a50f.002f.GAE@google.com>
From: Pimyn Girgis <pimyn@google.com>
Date: Fri, 19 Jun 2026 15:22:50 +0200
X-Gm-Features: AVVi8CccI2FWEkiysecphyhm_J3lgV6AQOevIDaIcG7FYvjXQYbvLiKlFxyGfzw
Message-ID: <CAJWNTGwG9UZPWLyygjCmZaJ-S1H4QF+-n=ZrDrN4E6nE-vwtoQ@mail.gmail.com>
Subject: Re: [moderation/CI] Re: namespace-aware configfs
To: syzbot ci <syzbot+ci7b32e0df290d155b@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream


On Fri, Jun 19, 2026 at 3:20=E2=80=AFPM syzbot ci
<syzbot+ci7b32e0df290d155b@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v2] namespace-aware configfs
> https://lore.kernel.org/all/20260619-configfs-ns-v2-0-82fd7094b8dc@kernel=
.org
> * [PATCH RFC v2 01/12] fs/configfs: rework configfs_is_root()
> * [PATCH RFC v2 02/12] fs/configfs: dynamically allocate super_info
> * [PATCH RFC v2 03/12] fs/configfs: separate out configfs_{link,unlink}_r=
oot()
> * [PATCH RFC v2 04/12] fs/configfs: add superblock as attribute to config=
fs_pin_fs()
> * [PATCH RFC v2 05/12] fs/configfs: add 'fill_subsystem' and 'clear_subsy=
stem' callbacks
> * [PATCH RFC v2 06/12] fs/configfs: add superblock as attribute to config=
fs_pin_fs()
> * [PATCH RFC v2 07/12] fs/namespace: implement mnt_clone_direct()
> * [PATCH RFC v2 08/12] fs/configfs: switch to get_tree_keyed()
> * [PATCH RFC v2 09/12] fs/configfs: open-code simple_pin_fs()
> * [PATCH RFC v2 10/12] nvmet: make discovery subsystem dynamic
> * [PATCH RFC v2 11/12] nvmet: per net-namespace port list
> * [PATCH RFC v2 12/12] nvmet: make configfs setup namespace aware
>
> and found the following issue:
> general protection fault in put_net
>
> Full report is available here:
> https://ci.syzbot.org/series/dd681b97-ec65-4bbf-9440-cbbf1c103062
>
> ***
>
> general protection fault in put_net
>
> tree:      bpf-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/bpf/b=
pf-next.git
> base:      66affa37cfac0aec061cc4bcf4a065b0c52f7e19
> arch:      amd64
> compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~e=
xp1~20251221153213.50), Debian LLD 21.1.8
> config:    https://ci.syzbot.org/builds/a4aeaf5c-a583-4650-97af-058d35909=
234/config
> syz repro: https://ci.syzbot.org/findings/773be3e5-366e-482f-8da3-9a5abb7=
1b7a8/syz_repro
>
> Oops: general protection fault, probably for non-canonical address 0xdfff=
fc000000003b: 0000 [#1] SMP KASAN PTI
> KASAN: null-ptr-deref in range [0x00000000000001d8-0x00000000000001df]
> CPU: 0 UID: 0 PID: 5865 Comm: syz.1.18 Tainted: G        W           syzk=
aller #0 PREEMPT(full)
> Tainted: [W]=3DWARN
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:is_ns_init_id include/linux/ns_common.h:25 [inline]
> RIP: 0010:__ns_ref_put include/linux/ns_common.h:72 [inline]
> RIP: 0010:put_net+0x33/0x260 include/net/net_namespace.h:297
> Code: 53 48 89 fb e8 4e ea 50 ff 48 85 db 0f 84 e8 00 00 00 49 bc 00 00 0=
0 00 00 fc ff df 4c 8d b3 e0 01 00 00 4d 89 f5 49 c1 ed 03 <43> 80 7c 25 00=
 00 74 08 4c 89 f7 e8 6d 1d be ff 4d 8b 3e 31 ff 4c
> RSP: 0018:ffffc9000349fcb8 EFLAGS: 00010203
> RAX: ffffffff8275a0b2 RBX: fffffffffffffffd RCX: ffff88810d921dc0
> RDX: 0000000000000000 RSI: 0000000000010000 RDI: fffffffffffffffd
> RBP: 0000000000010000 R08: ffffffff903203f7 R09: 1ffffffff206407e
> R10: dffffc0000000000 R11: ffffffff8275aa40 R12: dffffc0000000000
> R13: 000000000000003b R14: 00000000000001dd R15: 0000000000000000
> FS:  000055558a1a8500(0000) GS:ffff88818dc4e000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000001b33263fff CR3: 0000000116edc000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  put_fs_context+0x123/0xb00 fs/fs_context.c:498
>  fscontext_release+0x62/0x80 fs/fsopen.c:79
>  __fput+0x44f/0xa60 fs/file_table.c:512
>  task_work_run+0x1d9/0x270 kernel/task_work.c:233
>  resume_user_mode_work include/linux/resume_user_mode.h:50 [inline]
>  __exit_to_user_mode_loop kernel/entry/common.c:70 [inline]
>  exit_to_user_mode_loop+0x1fa/0x710 kernel/entry/common.c:101
>  __exit_to_user_mode_prepare include/linux/irq-entry-common.h:207 [inline=
]
>  syscall_exit_to_user_mode_prepare include/linux/irq-entry-common.h:230 [=
inline]
>  syscall_exit_to_user_mode include/linux/entry-common.h:318 [inline]
>  do_syscall_64+0x353/0x580 arch/x86/entry/syscall_64.c:100
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7fb902f9ce59
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007fff92660ec8 EFLAGS: 00000246 ORIG_RAX: 00000000000001b4
> RAX: 0000000000000000 RBX: 00007fff92660fb0 RCX: 00007fb902f9ce59
> RDX: 0000000000000000 RSI: 000000000000001e RDI: 0000000000000003
> RBP: 00000000000107a6 R08: 0000000000000001 R09: 0000000000000000
> R10: 0000001b32620000 R11: 0000000000000246 R12: 00007fff92660ff0
> R13: 00007fb903215fac R14: 00000000000107da R15: 00007fb903215fa0
>  </TASK>
> Modules linked in:
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:is_ns_init_id include/linux/ns_common.h:25 [inline]
> RIP: 0010:__ns_ref_put include/linux/ns_common.h:72 [inline]
> RIP: 0010:put_net+0x33/0x260 include/net/net_namespace.h:297
> Code: 53 48 89 fb e8 4e ea 50 ff 48 85 db 0f 84 e8 00 00 00 49 bc 00 00 0=
0 00 00 fc ff df 4c 8d b3 e0 01 00 00 4d 89 f5 49 c1 ed 03 <43> 80 7c 25 00=
 00 74 08 4c 89 f7 e8 6d 1d be ff 4d 8b 3e 31 ff 4c
> RSP: 0018:ffffc9000349fcb8 EFLAGS: 00010203
> RAX: ffffffff8275a0b2 RBX: fffffffffffffffd RCX: ffff88810d921dc0
> RDX: 0000000000000000 RSI: 0000000000010000 RDI: fffffffffffffffd
> RBP: 0000000000010000 R08: ffffffff903203f7 R09: 1ffffffff206407e
> R10: dffffc0000000000 R11: ffffffff8275aa40 R12: dffffc0000000000
> R13: 000000000000003b R14: 00000000000001dd R15: 0000000000000000
> FS:  000055558a1a8500(0000) GS:ffff88818dc4e000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000001b33263fff CR3: 0000000116edc000 CR4: 00000000000006f0
> ----------------
> Code disassembly (best guess):
>    0:   53                      push   %rbx
>    1:   48 89 fb                mov    %rdi,%rbx
>    4:   e8 4e ea 50 ff          call   0xff50ea57
>    9:   48 85 db                test   %rbx,%rbx
>    c:   0f 84 e8 00 00 00       je     0xfa
>   12:   49 bc 00 00 00 00 00    movabs $0xdffffc0000000000,%r12
>   19:   fc ff df
>   1c:   4c 8d b3 e0 01 00 00    lea    0x1e0(%rbx),%r14
>   23:   4d 89 f5                mov    %r14,%r13
>   26:   49 c1 ed 03             shr    $0x3,%r13
> * 2a:   43 80 7c 25 00 00       cmpb   $0x0,0x0(%r13,%r12,1) <-- trapping=
 instruction
>   30:   74 08                   je     0x3a
>   32:   4c 89 f7                mov    %r14,%rdi
>   35:   e8 6d 1d be ff          call   0xffbe1da7
>   3a:   4d 8b 3e                mov    (%r14),%r15
>   3d:   31 ff                   xor    %edi,%edi
>   3f:   4c                      rex.WR
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
> [a.hindborg@kernel.org brauner@kernel.org hare@kernel.org hare@suse.de hc=
h@lst.de jack@suse.cz kch@nvidia.com leitao@debian.org linux-fsdevel@vger.k=
ernel.org linux-kernel@vger.kernel.org linux-nvme@lists.infradead.org sagi@=
grimberg.me viro@zeniv.linux.org.uk]
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
-upstream-moderation/6a354228.6d5abbec.a50f.002f.GAE%40google.com.



--=20
=E2=B2=A0=E2=B2=9F=E2=B2=93=E2=B2=99=E2=B2=8F=E2=B2=9B =E2=B2=84=E2=B2=89=
=E2=B2=B1=E2=B2=A3=E2=B2=85=E2=B2=93=E2=B2=9F=E2=B2=A5 - Pimyn Girgis
Software Engineer
Kernel Dynamic Analysis
pimyn@google.com
