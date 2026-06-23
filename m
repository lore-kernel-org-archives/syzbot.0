Received: from mail-oo1-f51.google.com (mail-oo1-f51.google.com [209.85.161.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CD5B242D89
	for <syzbot@lists.linux.dev>; Tue, 23 Jun 2026 13:10:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.161.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782220259; cv=pass; b=E+dmDaNIiGSXO3U0iDj03Sd8nyZlOjXtn+g4M9yWl3Cuk6RsumgD15/ynhrY9zSNxs+D3xCHZN3SP2JZbxFqvZ1yMDv8UyBX2e8r3t5yQ6XCyQuqMidDeo/+om4g2UsB0klS+37WzMydb4EeRWnbljX3DQ7l8TD7HEKdLdDENYA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782220259; c=relaxed/simple;
	bh=yPucC4IuVWgPFQF208TjgOlm4GO9ePUKEMO1I/NGxt8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GMOEIMSsvsyCHw/P/SA/a/cSE1yvUVm44daluRf17SuFtpMCr4xXBiBTriX1qCurOrRSKjJK69zM3zLjmI5QYyYTPqgFoHKM80LMT8kt467pdtg0qWdIwSR0hxMhsAhhC+eMeoCjLP6CBpzejoXeFMFRyuqVby1a0e8/TdPlcmI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=SOPAtL8d; arc=pass smtp.client-ip=209.85.161.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="SOPAtL8d"
Received: by mail-oo1-f51.google.com with SMTP id 006d021491bc7-69d8f70cb0cso4161409eaf.0
        for <syzbot@lists.linux.dev>; Tue, 23 Jun 2026 06:10:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782220256; cv=none;
        d=google.com; s=arc-20240605;
        b=Nhvnl7dahpVtAAdXcq2pGHwk5HL2yaGmYn87NJfFsrp59RViNhA8m6iiZ9UfovkJQB
         TI60BcqXEqdZcyXMNw7voEffoShBZ/M1Qz8TeJ5AmYK9lp9lKCuR1657k5v1wD2id/OR
         SfTa9TM949DQHBNhIyhJW3gQ6w8b0/Ii46iTy1RDqt2ekd783Jt3rg/LFuHOVDN/QMNR
         1FDjR0ienzwZh/I69SZ7uZzhW94jrFfdai0bx/5M4D6heFWBw7u9MeKrQtQlBLsDHxG5
         wdrPd2tXwif8cfG7+7SctG17YtUUbbRXHhf0VRbjrvSdmBrIlkJ3f/q202T/gaLkzBJ8
         VGrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=+rhErh8hEGmxsMe5nN+TjPb7C1cacCNuvgGUQhX/PUU=;
        fh=UU7hlR4/fvW+MNf8diRKQJ2GMqZDdlqWbS1ln+IRdAM=;
        b=VkKirKmEOnzRpm+mFqDUPUhly3sM6MIDNVbgOjrfX+2UxOEDujbHp1uN4Nwkioz5al
         E74Aeak3dxA4RmdAmp4IpUPa3cHu6zgD+kIybr8n8B+bV/WUKQ1q+AusnewMKvA8EOI/
         hp3rUxBg+x66zzCVdlAD3sbDP63ZJp/N4ESAvTpbmkj3s8Apnk0CvaPJQL1kzqxM9FIA
         LAlTqXh0U0DMtcFVjgzBHHBhxk3K8DAh7Wx5k+zeIqUgHbuw94k4yq14XsawCjqH/WPY
         11nCN1+n593OGFPPiVsNizoctklohAeX51P1nIrttVMeB1BQvQZBXgUAuF+28kyfGoAL
         5juQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782220256; x=1782825056; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+rhErh8hEGmxsMe5nN+TjPb7C1cacCNuvgGUQhX/PUU=;
        b=SOPAtL8d+0AZeaDbr+rNey6/Lq8TceRDTZHXzn2HxwfaDdI0t9yFh2iJ90SpZUoQO0
         F2G7ZKI67loq0YN+s8T/jzHjUzTNMaWa4Pyc/9htzwL8K7vI70xd957obZq4kDctTcLv
         10br+UxY+E/moMk2UARt7iIlZudCAPHAS6DtPENXKbh2qG8Qy9GFpQ23h4+UnAO1oyNb
         BOCwy8H785AaPZMKnjTuffRJNZQ1mB69KIzZzv0cOjP0hVrmJpTFfWC474hozXZp1+6x
         q0be5CMjmlq0fSK6PS2mQrn2Y/C2b7Jz0zXPZ10bbqO48cjQ5pz2Q4nmS+BZEcEi54Q+
         rFxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782220256; x=1782825056;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=+rhErh8hEGmxsMe5nN+TjPb7C1cacCNuvgGUQhX/PUU=;
        b=KyqilZo7QuumfUcjLC/Oe/aA+rS+09mQ/tWBMzxZ7kAJFNvZOHEO226V9gMM8cWf0z
         GUHwiMRwvhBzrAv9i0QoCO23aPsfkbr6Kdv/KKQS5gO4X8thgYWWilelzivAcUMp72R7
         SQc8LZiIvQz+wdZQ15JqYWgJ5EyCIcRk7U8XYlrjkLITFM5HRlnTFKJbgNU+gMgQQvNy
         jDQOcQpUwD6iKDdABfzPisMzeG3bEwWeM2OqIA19eol38HlN0CwDX7Pjl1WGtz5iqMwi
         qlIhmdR7UAVNbxSjLe22cy9QFq6C3d0BMLMiN4si/U0v+8CYDvfArTnOeRtfrF/1dSEE
         7WqQ==
X-Forwarded-Encrypted: i=1; AFNElJ/4ReCyOOSl/GIkyijQuoH6U9W4FJhGZTk6qKAu0wNJmwS5C/21PPud0yiSYgJa2vXZM4rRVCk=@lists.linux.dev
X-Gm-Message-State: AOJu0Yyq2pxbbmR6sloo8A1/2o2Gy6YW3uDn2qTGN/Yj5SN8k4Z3cdJc
	r3vUfVI815ChEOPsEUsRe2ZJuu253eeaUi/4gWXBK0HNU3VTdEnA7fEUPmvlaGtOFkUJncMAUrF
	45j3OCNriNGsOFhrrP1sRaJ6uuZLSNsarWlYYF0Jr
X-Gm-Gg: AfdE7cmmZ4TlHVtavgwFFxQYAoAeeYyBTmjynZ0DF0mp6zlbU6P1OZnUJQrL7FuSn58
	clMu6XZJ2ADynwY+v7wiKYZDMa50NUopNKxqf3rza8ddiiiHmE04YDZFtfjGjh4sC2W41spEb0H
	IH59Fvyu21HD47MRn9E6qckVwBq/YNf15t24OSo794cR8OH6vtYNLz2X05x9zOugm6+O6Sq2bTY
	A5RKQHYWaWrRbRFCW/w1y8xAjYN423LWoTO7nokZ8SyejA2apy422oaXNw7kfxRJ1fMEQ9hTJGI
	VhCeNUghN04/mMHuaqURQlnN/LA3a43q90EpdKp29iMaIV1TH41KxKgAOmOND5wqvTORcluudmT
	NwMP3S85TKVSgHLT5L3hSOnm/6byaGtrZ0YB+O5l0
X-Received: by 2002:a05:6820:188d:b0:69e:6a90:ba4c with SMTP id
 006d021491bc7-6a0d8d505femr14315284eaf.53.1782220255842; Tue, 23 Jun 2026
 06:10:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <6a3a8505.52ae72c2.136ac7.0007.GAE@google.com>
In-Reply-To: <6a3a8505.52ae72c2.136ac7.0007.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Tue, 23 Jun 2026 15:10:43 +0200
X-Gm-Features: AVVi8CfLTULMo7demkqH9YG8WOE8OMWcgVWPnfA9jU85-ZTosJG1_xou_LFBxy4
Message-ID: <CANp29Y66dQ5n5sCEtAsECnqXG5sN3JANNVcx3PA202ZS+xEHBw@mail.gmail.com>
Subject: Re: [moderation/CI] Re: ext4: deferred iput framework for EA inodes
To: syzbot ci <syzbot+ci292489c3bc18db75@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Tue, Jun 23, 2026 at 3:07=E2=80=AFPM syzbot ci
<syzbot+ci292489c3bc18db75@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v9] ext4: deferred iput framework for EA inodes
> https://lore.kernel.org/all/20260623083540.2744885-1-yun.zhou@windriver.c=
om
> * [PATCH v9 1/4] fs: add iput_if_not_last() helper
> * [PATCH v9 2/4] ext4: introduce ext4_put_ea_inode() for safe deferred ip=
ut
> * [PATCH v9 3/4] ext4: convert all EA inode iput() calls to ext4_put_ea_i=
node()
> * [PATCH v9 4/4] ext4: remove ea_inode_array mechanism in favor of ext4_p=
ut_ea_inode()
>
> and found the following issue:
> WARNING: ODEBUG bug in flush_delayed_work
>
> Full report is available here:
> https://ci.syzbot.org/series/acc1a7bd-816f-451e-86ee-a62f88ad8fcc
>
> ***
>
> WARNING: ODEBUG bug in flush_delayed_work
>
> tree:      torvalds
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torva=
lds/linux
> base:      502d801f0ab03e4f32f9a33d203154ce84887921
> arch:      amd64
> compiler:  Debian clang version 22.1.6 (++20260514074242+fc4aad7b5db3-1~e=
xp1~20260514074407.73), Debian LLD 22.1.6
> config:    https://ci.syzbot.org/builds/79d2cdf0-fde6-4e70-a88c-04d44c9d3=
e44/config
> syz repro: https://ci.syzbot.org/findings/9b2e3f5d-279a-469f-9f2a-05f96ea=
11587/syz_repro
>
> EXT4-fs warning (device loop2): ext4_multi_mount_protect:287: Invalid MMP=
 block in superblock
> ------------[ cut here ]------------
> ODEBUG: assert_init not available (active state 0) object: ffff8881bf08c9=
e0 object type: timer_list hint: 0x0
> WARNING: lib/debugobjects.c:632 at debug_print_object+0xec/0x230 lib/debu=
gobjects.c:629, CPU#1: syz.2.19/5833
> Modules linked in:
> CPU: 1 UID: 0 PID: 5833 Comm: syz.2.19 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:debug_print_object+0x18a/0x230 lib/debugobjects.c:629
> Code: f8 48 c1 e8 03 80 3c 18 00 74 08 4c 89 ff e8 5d 04 71 fd 4d 8b 0f 4=
c 89 ef 48 8b 74 24 08 48 89 ea 44 89 e1 4d 89 f0 ff 34 24 <67> 48 0f b9 3a=
 48 83 c4 08 ff 05 a3 23 70 0b 48 83 c4 10 5b 41 5c
> RSP: 0018:ffffc9000179f848 EFLAGS: 00010046
>
> RAX: 1ffffffff179eacc RBX: dffffc0000000000 RCX: 0000000000000000
> RDX: ffffffff8c2a9980 RSI: ffffffff8c2a93e0 RDI: ffffffff903ddbf0
> RBP: ffffffff8c2a9980 R08: ffff8881bf08c9e0 R09: ffffffff8bcf69c0
> R10: dffffc0000000000 R11: ffffffff81b25990 R12: 0000000000000000
> R13: ffffffff903ddbf0 R14: ffff8881bf08c9e0 R15: ffffffff8bcf5660
> FS:  00007fd11e12e6c0(0000) GS:ffff8882a922d000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007ffe46d80f88 CR3: 00000001bf40e000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  debug_object_assert_init+0x237/0x370 lib/debugobjects.c:1075
>  debug_timer_assert_init kernel/time/timer.c:803 [inline]
>  debug_assert_init kernel/time/timer.c:848 [inline]
>  __try_to_del_timer_sync kernel/time/timer.c:1457 [inline]
>  __timer_delete_sync+0x181/0x520 kernel/time/timer.c:1621
>  flush_delayed_work+0x48/0x100 kernel/workqueue.c:4414
>  ext4_drain_ea_inode_work fs/ext4/xattr.h:196 [inline]
>  __ext4_fill_super fs/ext4/super.c:5795 [inline]
>  ext4_fill_super+0x54c7/0x66d0 fs/ext4/super.c:5844
>  get_tree_bdev_flags+0x430/0x4f0 fs/super.c:1634
>  vfs_get_tree+0x92/0x2a0 fs/super.c:1694
>  fc_mount fs/namespace.c:1198 [inline]
>  do_new_mount_fc fs/namespace.c:3765 [inline]
>  do_new_mount+0x319/0xdc0 fs/namespace.c:3841
>  do_mount fs/namespace.c:4174 [inline]
>  __do_sys_mount fs/namespace.c:4390 [inline]
>  __se_sys_mount+0x31d/0x420 fs/namespace.c:4367
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7fd11d19e0ca
> Code: 48 c7 c2 e8 ff ff ff f7 d8 64 89 02 b8 ff ff ff ff c3 66 2e 0f 1f 8=
4 00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007fd11e12de58 EFLAGS: 00000246
>  ORIG_RAX: 00000000000000a5
> RAX: ffffffffffffffda RBX: 00007fd11e12dee0 RCX: 00007fd11d19e0ca
> RDX: 0000200000000400 RSI: 0000200000000340 RDI: 00007fd11e12dea0
> RBP: 0000200000000400 R08: 00007fd11e12dee0 R09: 000000000021c91c
> R10: 000000000021c91c R11: 0000000000000246 R12: 0000200000000340
> R13: 00007fd11e12dea0 R14: 000000000000051a R15: 0000200000000240
>  </TASK>
> ----------------
> Code disassembly (best guess):
>    0:   f8                      clc
>    1:   48 c1 e8 03             shr    $0x3,%rax
>    5:   80 3c 18 00             cmpb   $0x0,(%rax,%rbx,1)
>    9:   74 08                   je     0x13
>    b:   4c 89 ff                mov    %r15,%rdi
>    e:   e8 5d 04 71 fd          call   0xfd710470
>   13:   4d 8b 0f                mov    (%r15),%r9
>   16:   4c 89 ef                mov    %r13,%rdi
>   19:   48 8b 74 24 08          mov    0x8(%rsp),%rsi
>   1e:   48 89 ea                mov    %rbp,%rdx
>   21:   44 89 e1                mov    %r12d,%ecx
>   24:   4d 89 f0                mov    %r14,%r8
>   27:   ff 34 24                push   (%rsp)
> * 2a:   67 48 0f b9 3a          ud1    (%edx),%rdi <-- trapping instructi=
on
>   2f:   48 83 c4 08             add    $0x8,%rsp
>   33:   ff 05 a3 23 70 0b       incl   0xb7023a3(%rip)        # 0xb7023dc
>   39:   48 83 c4 10             add    $0x10,%rsp
>   3d:   5b                      pop    %rbx
>   3e:   41 5c                   pop    %r12
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
> [adilger.kernel@dilger.ca jack@suse.cz libaokun@linux.alibaba.com linux-e=
xt4@vger.kernel.org linux-kernel@vger.kernel.org ojaswin@linux.ibm.com rite=
sh.list@gmail.com tytso@mit.edu yi.zhang@huawei.com yun.zhou@windriver.com]
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
-upstream-moderation/6a3a8505.52ae72c2.136ac7.0007.GAE%40google.com.
