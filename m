Received: from mail-oo1-f72.google.com (mail-oo1-f72.google.com [209.85.161.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF75237CD3A
	for <syzbot@lists.linux.dev>; Fri,  7 Aug 2026 16:41:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786120906; cv=none; b=CFN3P5l5Qbf+568VzF0dGa58bvjQvDHZmBWlz0s8HBOJfFFQ7MhqPctDPNoqaSEC+q417CU4dwQn8y0REwKKiFEqvDRDbtzxCqizIypR4ZpO7C+2Fu3hDtP/Ngvjxwnx0C2b2sn+mNwtVpLMEznwSVuXEuAEgftwUqVNWU6Jobw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786120906; c=relaxed/simple;
	bh=8TmyZo365lLShlDBSSxnyiRrumZLufQ8qtsrtXDefXg=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=qtXrwpSSINFdRTPz7I4jggtdNGqjbh1gY7EuBBrBwipBkDK76gPvLUARcO4U9Jz4wEuCHMiQEStA/Q4Rp7m8ACLEW5G7bCHB6Ws6L5k0F/UGbOXGvluMJjtM1CP7LBiZ0He9DWsvGQXrup4Ip6iOfbwDGSQKATZl4ASXImrwEfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f72.google.com with SMTP id 006d021491bc7-6a196857c7aso3562748eaf.2
        for <syzbot@lists.linux.dev>; Fri, 07 Aug 2026 09:41:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786120903; x=1786725703;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:date:mime-version:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=OarURpj/btM5D+cNjTvbMamtMjYnAvte5XtVi9vAO/8=;
        b=UWNMhfPoqAQS3IslM8YoVVlsQyOtra1de9Q0aIzPiaP56PjY9a2P5GMRevcoP9uTij
         0pMbg4Z8GcYaG6OVz8RBqJwJfuyEfcLufgoQ79TtgnjtR8Fr+EyB8R659Eueh9JwbRoZ
         CISrD6rEGikQpMMvqlSBxKEJlSAM+FZixttfDjsVsjCI2DRRIdLFjXy9dr4qKLhnuPLq
         YpROEsgoZVGc3jvwUAnwD/NWw+0ezrgI4ZCjY4tcNmv6pNyUao5Y34Lb4UI3hMjM9LVn
         JmCMIVLLIqcqhQWX5w6ejfFAlMsTZzaKwldPwySYMlqul9+yXI7wudcg6U+oW9pgituZ
         oQqw==
X-Gm-Message-State: AOJu0Yxu1Dpa2wp9KWblesOpz402tZG+nGmfJTioOiSYILYdDggqraYP
	JQ/UbZ/gySuX6UtEniHI6+Hve3tT8YzOOsiLiWFHxmAsOIFm8e8Mx2nZ8a8aceNOY7toxdC4a4v
	UW28oXM2Lk1lgLMn4zJ0bi6+MLXpvKayGGokHCuPiod9NqohHp8XpebLfPWw=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:c90:b0:6ae:8421:4f61 with SMTP id
 006d021491bc7-6b041eb0faemr799360eaf.6.1786120902816; Fri, 07 Aug 2026
 09:41:42 -0700 (PDT)
Date: Fri, 07 Aug 2026 09:41:42 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a760ac6.01d0871a.3a0d52.004e.GAE@google.com>
Subject: [moderation/CI] Re: mm/mglru: fix lockless folio_putback_lru() race
 in evict_folios()
From: syzbot ci <syzbot+ci574de685c44b0d14@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v1] mm/mglru: fix lockless folio_putback_lru() race in evict_folios()
https://lore.kernel.org/all/20260807-evict_folios_race-v1-1-b167c6b4cfde@os=
s.qualcomm.com
* [PATCH] mm/mglru: fix lockless folio_putback_lru() race in evict_folios()

and found the following issue:
possible deadlock in __folio_batch_add_and_move

Full report is available here:
https://ci.syzbot.org/series/84ef3e36-11bb-4ace-93cf-a1d457206afc

***

possible deadlock in __folio_batch_add_and_move

tree:      linux-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/next/li=
nux-next
base:      ea2bff00da89d7767d677bb68470130ba96f4928
arch:      amd64
compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp=
1~20260613092250.77), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/fefee38b-873a-46f2-b7ad-f80279b083f=
8/config
syz repro: https://ci.syzbot.org/findings/9a05a8ec-c7b9-47ec-8888-0383f37b2=
35c/syz_repro

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
WARNING: possible circular locking dependency detected
syzkaller #0 Not tainted
------------------------------------------------------
syz.0.17/5796 is trying to acquire lock:
ffff888121033c10 (lock#3){+.+.}-{3:3}, at: local_lock_acquire include/linux=
/local_lock_internal.h:46 [inline]
ffff888121033c10 (lock#3){+.+.}-{3:3}, at: __folio_batch_add_and_move+0x11a=
/0xc50 mm/folio.c:220

but task is already holding lock:
ffff888102ab6cb0 (&lruvec->lru_lock){....}-{3:3}, at: spin_lock_irq include=
/linux/spinlock.h:372 [inline]
ffff888102ab6cb0 (&lruvec->lru_lock){....}-{3:3}, at: evict_folios+0x3cf5/0=
x4970 mm/vmscan.c:4926

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #1 (&lruvec->lru_lock){....}-{3:3}:
       __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:132 [inline=
]
       _raw_spin_lock_irqsave+0x40/0x60 kernel/locking/spinlock.c:166
       folio_lruvec_lock_irqsave+0x273/0x550 mm/memcontrol.c:1509
       folio_lruvec_relock_irqsave include/linux/memcontrol.h:1567 [inline]
       folio_batch_move_lru+0x6d3/0xa60 mm/folio.c:192
       __folio_batch_add_and_move+0x510/0xc50 mm/folio.c:224
       shmem_alloc_and_add_folio+0xcc2/0xf60 mm/shmem.c:2033
       shmem_get_folio_gfp+0x5da/0x16d0 mm/shmem.c:2527
       shmem_read_folio_gfp+0x8a/0xe0 mm/shmem.c:5964
       drm_gem_get_pages+0x253/0x9c0 drivers/gpu/drm/drm_gem.c:695
       drm_gem_shmem_get_pages_locked+0x22b/0x480 drivers/gpu/drm/drm_gem_s=
hmem_helper.c:242
       drm_gem_shmem_pin_locked+0x251/0x510 drivers/gpu/drm/drm_gem_shmem_h=
elper.c:305
       drm_gem_shmem_vmap_locked+0x487/0x7d0 drivers/gpu/drm/drm_gem_shmem_=
helper.c:409
       drm_gem_vmap_locked drivers/gpu/drm/drm_gem.c:1421 [inline]
       drm_gem_vmap+0x10a/0x1d0 drivers/gpu/drm/drm_gem.c:1463
       drm_client_buffer_vmap+0x6c/0xb0 drivers/gpu/drm/drm_client.c:356
       drm_fbdev_shmem_driver_fbdev_probe+0x280/0x930 drivers/gpu/drm/drm_f=
bdev_shmem.c:159
       drm_fb_helper_single_fb_probe drivers/gpu/drm/drm_fb_helper.c:1544 [=
inline]
       __drm_fb_helper_initial_config_and_unlock+0x148f/0x1b50 drivers/gpu/=
drm/drm_fb_helper.c:1725
       drm_fbdev_client_hotplug+0x16c/0x230 drivers/gpu/drm/clients/drm_fbd=
ev_client.c:66
       drm_client_register+0x16e/0x200 drivers/gpu/drm/drm_client.c:143
       drm_fbdev_client_setup+0x1a0/0x450 drivers/gpu/drm/clients/drm_fbdev=
_client.c:168
       drm_client_setup+0x107/0x220 drivers/gpu/drm/clients/drm_client_setu=
p.c:46
       bochs_pci_probe+0xa9a/0xbb0 drivers/gpu/drm/tiny/bochs.c:776
       local_pci_probe drivers/pci/pci-driver.c:354 [inline]
       pci_call_probe drivers/pci/pci-driver.c:416 [inline]
       __pci_device_probe drivers/pci/pci-driver.c:478 [inline]
       pci_device_probe+0x48e/0xd10 drivers/pci/pci-driver.c:512
       call_driver_probe drivers/base/dd.c:-1 [inline]
       really_probe+0x254/0xae0 drivers/base/dd.c:706
       __driver_probe_device+0x1e8/0x360 drivers/base/dd.c:868
       driver_probe_device+0x4f/0x240 drivers/base/dd.c:898
       __driver_attach+0x339/0x600 drivers/base/dd.c:1292
       bus_for_each_dev+0x23b/0x2c0 drivers/base/bus.c:383
       bus_add_driver+0x345/0x670 drivers/base/bus.c:763
       driver_register+0x23a/0x320 drivers/base/driver.c:174
       do_one_initcall+0x250/0x870 init/main.c:1359
       do_initcall_level+0x10a/0x1a0 init/main.c:1421
       do_initcalls+0x59/0xa0 init/main.c:1437
       kernel_init_freeable+0x29d/0x3e0 init/main.c:1672
       kernel_init+0x22/0x1d0 init/main.c:1562
       ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
       ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

-> #0 (lock#3){+.+.}-{3:3}:
       check_prev_add kernel/locking/lockdep.c:3181 [inline]
       check_prevs_add kernel/locking/lockdep.c:3300 [inline]
       validate_chain kernel/locking/lockdep.c:3924 [inline]
       __lock_acquire+0x15ff/0x2e50 kernel/locking/lockdep.c:5254
       lock_acquire+0x115/0x350 kernel/locking/lockdep.c:5908
       local_lock_acquire include/linux/local_lock_internal.h:46 [inline]
       __folio_batch_add_and_move+0x132/0xc50 mm/folio.c:220
       folio_putback_lru+0x18/0xe0 mm/vmscan.c:822
       evict_folios+0x3cfd/0x4970 mm/vmscan.c:4927
       try_to_shrink_lruvec+0xe3b/0x1340 mm/vmscan.c:5081
       lru_gen_shrink_lruvec mm/vmscan.c:5226 [inline]
       shrink_lruvec+0x54f/0x2c40 mm/vmscan.c:5986
       shrink_node_memcgs mm/vmscan.c:6225 [inline]
       shrink_node+0xa9b/0x3e30 mm/vmscan.c:6269
       shrink_zones mm/vmscan.c:6508 [inline]
       do_try_to_free_pages+0x6a3/0x1990 mm/vmscan.c:6570
       try_to_free_mem_cgroup_pages+0x30d/0x830 mm/vmscan.c:6892
       mem_cgroup_resize_max+0x23c/0x470 mm/memcontrol-v1.c:1817
       mem_cgroup_write+0x223/0x290 mm/memcontrol-v1.c:-1
       cgroup_file_write+0x331/0x8f0 kernel/cgroup/cgroup.c:4412
       kernfs_fop_write_iter+0x3a4/0x540 fs/kernfs/file.c:345
       new_sync_write fs/read_write.c:595 [inline]
       vfs_write+0x612/0xba0 fs/read_write.c:687
       ksys_write+0x150/0x270 fs/read_write.c:739
       do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
       do_syscall_64+0x166/0x510 arch/x86/entry/syscall_64.c:84
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

other info that might help us debug this:

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&lruvec->lru_lock);
                               lock(lock#3);
                               lock(&lruvec->lru_lock);
  lock(lock#3);

 *** DEADLOCK ***

locks held by syz.0.17/5796: 5, last CPU#0:
 #0: ffff88810338ecf0 (&f->f_pos_lock){+.+.}-{4:4}, at: fdget_pos+0x246/0x3=
20 fs/file.c:1259
 #1: ffff888110422460 (sb_writers#10){.+.+}-{0:0}, at: file_start_write inc=
lude/linux/fs.h:2754 [inline]
 #1: ffff888110422460 (sb_writers#10){.+.+}-{0:0}, at: vfs_write+0x22b/0xba=
0 fs/read_write.c:683
 #2: ffff88811ad85880 (&of->mutex){+.+.}-{4:4}, at: kernfs_fop_write_iter+0=
x1d8/0x540 fs/kernfs/file.c:336
 #3: ffff8881bd86d3c8 (kn->active#53){.+.+}-{0:0}, at: kernfs_get_active_of=
 fs/kernfs/file.c:73 [inline]
 #3: ffff8881bd86d3c8 (kn->active#53){.+.+}-{0:0}, at: kernfs_fop_write_ite=
r+0x22b/0x540 fs/kernfs/file.c:337
 #4: ffff888102ab6cb0 (&lruvec->lru_lock){....}-{3:3}, at: spin_lock_irq in=
clude/linux/spinlock.h:372 [inline]
 #4: ffff888102ab6cb0 (&lruvec->lru_lock){....}-{3:3}, at: evict_folios+0x3=
cf5/0x4970 mm/vmscan.c:4926

stack backtrace:
CPU: 0 UID: 0 PID: 5796 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(ful=
l)=20
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16=
.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 print_circular_bug+0x2e2/0x300 kernel/locking/lockdep.c:2059
 check_noncircular+0x12f/0x150 kernel/locking/lockdep.c:2191
 check_prev_add kernel/locking/lockdep.c:3181 [inline]
 check_prevs_add kernel/locking/lockdep.c:3300 [inline]
 validate_chain kernel/locking/lockdep.c:3924 [inline]
 __lock_acquire+0x15ff/0x2e50 kernel/locking/lockdep.c:5254
 lock_acquire+0x115/0x350 kernel/locking/lockdep.c:5908
 local_lock_acquire include/linux/local_lock_internal.h:46 [inline]
 __folio_batch_add_and_move+0x132/0xc50 mm/folio.c:220
 folio_putback_lru+0x18/0xe0 mm/vmscan.c:822
 evict_folios+0x3cfd/0x4970 mm/vmscan.c:4927
 try_to_shrink_lruvec+0xe3b/0x1340 mm/vmscan.c:5081
 lru_gen_shrink_lruvec mm/vmscan.c:5226 [inline]
 shrink_lruvec+0x54f/0x2c40 mm/vmscan.c:5986
 shrink_node_memcgs mm/vmscan.c:6225 [inline]
 shrink_node+0xa9b/0x3e30 mm/vmscan.c:6269
 shrink_zones mm/vmscan.c:6508 [inline]
 do_try_to_free_pages+0x6a3/0x1990 mm/vmscan.c:6570
 try_to_free_mem_cgroup_pages+0x30d/0x830 mm/vmscan.c:6892
 mem_cgroup_resize_max+0x23c/0x470 mm/memcontrol-v1.c:1817
 mem_cgroup_write+0x223/0x290 mm/memcontrol-v1.c:-1
 cgroup_file_write+0x331/0x8f0 kernel/cgroup/cgroup.c:4412
 kernfs_fop_write_iter+0x3a4/0x540 fs/kernfs/file.c:345
 new_sync_write fs/read_write.c:595 [inline]
 vfs_write+0x612/0xba0 fs/read_write.c:687
 ksys_write+0x150/0x270 fs/read_write.c:739
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x166/0x510 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f64a439e0d9
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 =
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff f=
f 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f64a5333028 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 00007f64a4625fa0 RCX: 00007f64a439e0d9
RDX: 0000000000000020 RSI: 00002000000002c0 RDI: 0000000000000003
RBP: 00007f64a4435024 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f64a4626038 R14: 00007f64a4625fa0 R15: 00007fff0f9eaaa8
 </TASK>


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

To test a patch for this bug, please reply with `#syz test`
(should be on a separate line).

The patch should be attached to the email.
Note: arguments like custom git repos and branches are not supported.

The email will later be sent to:
[akpm@linux-foundation.org axelrasmussen@google.com baohua@kernel.org david=
@kernel.org hannes@cmpxchg.org kasong@tencent.com kernel@oss.qualcomm.com k=
etan.kishore@oss.qualcomm.com linux-kernel@vger.kernel.org linux-mm@kvack.o=
rg ljs@kernel.org mhocko@kernel.org prakash.gupta@oss.qualcomm.com qi.zheng=
@linux.dev shakeel.butt@linux.dev weixugc@google.com yuanchu@google.com yuz=
hao@google.com]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

