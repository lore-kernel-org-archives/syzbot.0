Received: from mail-oo1-f44.google.com (mail-oo1-f44.google.com [209.85.161.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A73E30674C
	for <syzbot@lists.linux.dev>; Wed, 15 Jul 2026 05:53:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.161.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784094841; cv=pass; b=MiNrMX+VknSt3g0VeadLmjknQc55LGNoRZDuV9tgwtEZ0sz6KcVetxnxoEzWo60Y0eVNw2l4JFRVxrq7d417S9zudMM6yYdtnl6eDdzF+QWDqhKFzkfPzissg9Fu72cU7d/XBQM2J7Msqph6zCpfJDVrhW1ay1Q/dhVFuOqcS4o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784094841; c=relaxed/simple;
	bh=IqpkePNogAWATHcH0nB63BsztA7oE9+CEfLTXi0Bxls=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ui9h0mOxGBkXzaLVscWVM12nEKB6qK4hEqq9m3ceV7Ni+qeqlt3mmagFUoMDr5N9AbMIIskaRJ1QeZcAyBDB+WkRze9z4uJLRB8lFu2H/lzbboAf5SmvlC3fhhYRHfEHN1LS/srP6/8rBjPOmD+r3gnEeNcY/e6DQ3dTJZIHzRs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fgVuGvTc; arc=pass smtp.client-ip=209.85.161.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fgVuGvTc"
Received: by mail-oo1-f44.google.com with SMTP id 006d021491bc7-6a3d77e72ffso220482eaf.2
        for <syzbot@lists.linux.dev>; Tue, 14 Jul 2026 22:53:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784094838; cv=none;
        d=google.com; s=arc-20260327;
        b=qsVTAadT8mUzwtjDaRascfYxOc58Zswic6O3VK7pEwUCFHrz7SDoRBSoPMxrwjAPPV
         cDDpgHA+q9S4N6ytZwmn06UG/6ehXDAPctPY2cKlqfSbQpB1BaOzAlzX3lOtUbYRANnF
         960z9xFy+2e22wic4WcXTRHAHnpW6ZZ1YEyMFbtq1PwBQD0y3Al3WNy3L9roVOGgt0XW
         oP8QhxuZTJMqfuQjY0M078q4FT15zWZHvvIzyiKmysVjGIWC3WkOLsoS/xBnlcv0RQEB
         2pPI8TzW/dOS6TJbq5gUfJSWZoIFL1zEThI1ImuPlQJSLWKsQ1ogtHhm6DfWRoaA1fqy
         bOCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ShhbWQqkszpzowiiiKDajubR54CdE9kjC16j1XWwQhs=;
        fh=zAyUCIYdKx1Eq1zneIuVvkmTkyYVy9hHOu04tQjmBTc=;
        b=CpblrthmdT93IQO53ma4/PrGTetyyt/HfubPopWBnqAPqyt/2Xt3tSHK41tJTppiDl
         ejl6Sqr4K8pj6qREHCrHXoVgIs8kZ8id+UaItlktXhVOTnTk2+eOU9Jrl7B4CiH8Um+l
         P8ylpCSwZPoigC9EICO1VS4pE6L9QUIHyNjFXA7xWC3Wr02NZ1pO/gN1DfLNnaDOThK2
         CupGEaPXwW68rCUyoXhXlqKmjL1S1dLIto5TnGQkY/7aeorDUV6XSKR/mbJ0HMSZLv0p
         UEJRUQAfFiZBi/Kwbx8dnxV5NoFp2A9mEjwVtf2i5yZ1AnnoyQuyAqnCfZ0CkUmTIEVl
         vqxg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784094838; x=1784699638; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ShhbWQqkszpzowiiiKDajubR54CdE9kjC16j1XWwQhs=;
        b=fgVuGvTcvqwiDe7K1hCMDpxXF6ICzucjr9m1RfSq9pWhdlTPEFixNsOa706DLyBSp7
         uhIwWCb6u/CXFCCUnWU5LnWDLkLogNMkeYv67m5yFbK9RHOVYyLOuAQW87LwhdzOQWCX
         BT88jp2PldH+8vh7OT/CM/i/ogLQy00Wkj2cpoppLjRN2f0JVZm+pd6B7og9u3QrZ//g
         Ow2UKmesUnzNUfownMAnd5lawek6cyhJdWU+46h86P4WbpnK+Kj4K3GqI8r5cAqnf92d
         W2NS8e87QOYAapz80JThLxuQy23aEA5M2/xByu3//k3+XiJFHqzQakmXabwWUGm0P5pH
         PfoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784094838; x=1784699638;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ShhbWQqkszpzowiiiKDajubR54CdE9kjC16j1XWwQhs=;
        b=EGhR8s1U8Jhuovs6si/MFfMlxSCMa58vg0HZa1q4ePqM+3feTcSN0NApEj/gNbzGSI
         rJTkRsjwKuD2R9bnbCiz5EMsvvcDE7JtKBGdGMRHQ2QAmC5PM5bWaj7WO3ekRFP4RxZy
         cqU3Uj6ecTlNrn/NH3NOiqthb4KlFWQ6c707OLw9esY0Rj/+uOP6MaUogDrdtBrYvUm7
         2N/6TOwMi5Hz0yrDPZs0SVnrLTVbf7Xpebbr/agOoVyx6iluhqv+vflZHt32tjIs0Isg
         h3x/7lRVFilxytpsLceuMJM6I3xYWSBn0f2ADr5oP/im2IkkLqJeSekE1E2heDIk1pNF
         GAxA==
X-Forwarded-Encrypted: i=1; AHgh+RrAsaxL/pR+DZ6oK+HXhvHJG470oJk7oaOTkX1EG8bWeCG7d/8M+fx8XcUu5Er5Z9ux5gY6yCk=@lists.linux.dev
X-Gm-Message-State: AOJu0YwWuq8GDumG+te/l0wXvG6b36XxMF2svpJE+6zv0jQ42Ebivx9H
	KGp8gsCq8ILy2IEidDMh7HtjD7BoSWI4oSmot4I8DFmyoidHpkQC4rLhcHbDd/mstFKgAoAA5QW
	tMbfimdhmO+u8X5Ozt56P+wzuZS+96AZOzvDVqASK
X-Gm-Gg: AfdE7cmaqcEqPm+hSy8nAQeOb1Ip3ZSLfGywM98GKeg+idqkh0mczXk2AEvXrS3qtgS
	PLEd+AIgKdmPzHAEh1CgiAa0tA/Pdn0Fuer+bEPx0L6sFO5V2gD0wiAWSyDgMrxvAWo0f46GQI7
	49HMKNLz6xdb4zNN1kL1R38EetlqY6wJaH5JaDJGpDnQyv82cwA7ld3TZ4+lieOhU0iO/gxuArS
	6J2CA2e0mT6orQtm1tevZ9FrEgfQ8KYQd6Nj2JgOP4Rob01BwCsx4/5VPhAB1+HDH77ySrjlBAO
	WPhfYO4ESwiHZeFBTVE4N8MenWBxypv13vLcaj4JIyeKZT4KQHpPh82lCxCh7djTc7DOSAu9sR8
	mygjR2KwczTkqAXpLRRkMuUE0oxHc4dJ31VPLoS8ABu0=
X-Received: by 2002:a05:6820:3089:b0:6a3:7fe3:a566 with SMTP id
 006d021491bc7-6a39a6cc381mr9290317eaf.38.1784094837308; Tue, 14 Jul 2026
 22:53:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <6a56e791.c90005c7.37d349.003b.GAE@google.com>
In-Reply-To: <6a56e791.c90005c7.37d349.003b.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Wed, 15 Jul 2026 07:53:45 +0200
X-Gm-Features: AUfX_mzTHRM2JmQOVuRbN5B8FGlj95wZvDMsJT7NQcA9YExDVwpQy-TgRXN8Fag
Message-ID: <CANp29Y5CCN7oyvi-cPO_g_sO450fk1WCketu1Px0o3m87uOMuA@mail.gmail.com>
Subject: Re: [moderation/CI] Re: netfilter: ipset: convert to rhashtable
To: syzbot ci <syzbot+cif74df51cd53269fc@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Wed, Jul 15, 2026 at 3:51=E2=80=AFAM syzbot ci
<syzbot+cif74df51cd53269fc@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v1] netfilter: ipset: convert to rhashtable
> https://lore.kernel.org/all/20260714131828.10685-1-fw@strlen.de
> * [PATCH RFC nf-next 01/12] netfilter: ipset: rework cidr bookkeeping
> * [PATCH RFC nf-next 02/12] netfilter: ipset: rework cidr bookkeeping fix=
ups
> * [PATCH RFC nf-next 03/12] netfilter: ipset: add small wrappers for hash=
 and bucket sizes
> * [PATCH RFC nf-next 04/12] netfilter: ipset: add and use mtype_del_cidr_=
all helper
> * [PATCH RFC nf-next 05/12] netfilter: ipset: add and use ip_set_init_com=
ment_slow
> * [PATCH RFC nf-next 06/12] netfilter: ipset: add and use ip_set_ext_dest=
roy_slow
> * [PATCH RFC nf-next 07/12] netfilter: ipset: add rhashtable boilerplate =
stubs
> * [PATCH RFC nf-next 08/12] netfilter: ipset: replace internal hash table=
 with rhashtable
> * [PATCH RFC nf-next 09/12] netfilter: ipset: use plain rcu_read_lock
> * [PATCH RFC nf-next 10/12] netfilter: ipset: use correct lockdep annotat=
ion in ipset_dereference
> * [PATCH RFC nf-next 11/12] netfilter: ipset: remove last region lock usa=
ge
> * [PATCH RFC nf-next 12/12] netfilter: ipset: re-add forceadd support for=
 rhashtable
>
> and found the following issue:
> BUG: sleeping function called from invalid context in irq_work_sync
>
> Full report is available here:
> https://ci.syzbot.org/series/47a605ae-2607-4da3-aa08-70c5d3d1d824
>
> ***
>
> BUG: sleeping function called from invalid context in irq_work_sync
>
> tree:      nf-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netfi=
lter/nf-next.git
> base:      f6f3b36c15ed44de1fbb44e645e4fae8c4a4453e
> arch:      amd64
> compiler:  Debian clang version 22.1.6 (++20260514074242+fc4aad7b5db3-1~e=
xp1~20260514074407.73), Debian LLD 22.1.6
> config:    https://ci.syzbot.org/builds/5beb9029-2b0f-4419-ae52-16749b7b6=
034/config
> syz repro: https://ci.syzbot.org/findings/a6144f65-837e-4528-aaf8-77585ab=
7e425/syz_repro
>
> BUG: sleeping function called from invalid context at kernel/irq_work.c:2=
89
> in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 5727, name: syz-ex=
ecutor
> preempt_count: 101, expected: 0
> RCU nest depth: 0, expected: 0
> 8 locks held by syz-executor/5727:
>  #0: ffff88816aad0450 (sb_writers#7){.+.+}-{0:0}, at: file_start_write in=
clude/linux/fs.h:2733 [inline]
>  #0: ffff88816aad0450 (sb_writers#7){.+.+}-{0:0}, at: vfs_write+0x22b/0xb=
a0 fs/read_write.c:683
>  #1: ffff888115bedc80 (&of->mutex){+.+.}-{4:4}, at: kernfs_fop_write_iter=
+0x1d8/0x540 fs/kernfs/file.c:336
>  #2: ffff88810c8b85a8 (kn->active#55){.+.+}-{0:0}, at: kernfs_get_active_=
of fs/kernfs/file.c:73 [inline]
>  #2: ffff88810c8b85a8 (kn->active#55){.+.+}-{0:0}, at: kernfs_fop_write_i=
ter+0x22b/0x540 fs/kernfs/file.c:337
>  #3: ffffffff8f66a000 (nsim_bus_dev_list_lock){+.+.}-{4:4}, at: new_devic=
e_store+0x13c/0x710 drivers/net/netdevsim/bus.c:184
>  #4: ffff88811df84128 (&dev->mutex){....}-{4:4}, at: device_lock include/=
linux/device.h:1102 [inline]
>  #4: ffff88811df84128 (&dev->mutex){....}-{4:4}, at: __device_attach+0x88=
/0x450 drivers/base/dd.c:1073
>  #5: ffff88811df94258 (&devlink->lock_key#4){+.+.}-{4:4}, at: nsim_drv_pr=
obe+0xfc/0xbf0 drivers/net/netdevsim/dev.c:1658
>  #6: ffff88811e194ae0 (&sb->s_type->i_mutex_key#4/1){+.+.}-{4:4}, at: ino=
de_lock_nested include/linux/fs.h:1069 [inline]
>  #6: ffff88811e194ae0 (&sb->s_type->i_mutex_key#4/1){+.+.}-{4:4}, at: __s=
tart_dirop fs/namei.c:2918 [inline]
>  #6: ffff88811e194ae0 (&sb->s_type->i_mutex_key#4/1){+.+.}-{4:4}, at: sta=
rt_dirop+0x4f/0x90 fs/namei.c:2942
>  #7: ffffffff8e959d80 (rcu_callback){....}-{0:0}, at: rcu_lock_acquire in=
clude/linux/rcupdate.h:300 [inline]
>  #7: ffffffff8e959d80 (rcu_callback){....}-{0:0}, at: rcu_do_batch kernel=
/rcu/tree.c:2639 [inline]
>  #7: ffffffff8e959d80 (rcu_callback){....}-{0:0}, at: rcu_core+0x70d/0x10=
a0 kernel/rcu/tree.c:2897
> Preemption disabled at:
> [<ffffffff8228d9e3>] __pcs_replace_empty_main+0x383/0x6b0 mm/slub.c:4717
> CPU: 0 UID: 0 PID: 5727 Comm: syz-executor Not tainted syzkaller #0 PREEM=
PT(full)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Call Trace:
>  <IRQ>
>  dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
>  __might_resched+0x378/0x4d0 kernel/sched/core.c:9197
>  irq_work_sync+0x9b/0x300 kernel/irq_work.c:289
>  rhashtable_free_and_destroy+0x39/0x540 lib/rhashtable.c:1295
>  hash_netport4_destroy+0x56/0xb0 net/netfilter/ipset/ip_set_hash_gen.h:42=
0
>  ip_set_destroy_set_rcu+0x63/0xc0 net/netfilter/ipset/ip_set_core.c:1169
>  rcu_do_batch kernel/rcu/tree.c:2645 [inline]
>  rcu_core+0x78b/0x10a0 kernel/rcu/tree.c:2897
>  handle_softirqs+0x225/0x840 kernel/softirq.c:622
>  __do_softirq kernel/softirq.c:656 [inline]
>  invoke_softirq kernel/softirq.c:496 [inline]
>  __irq_exit_rcu+0xca/0x220 kernel/softirq.c:735
>  irq_exit_rcu+0x9/0x30 kernel/softirq.c:752
>  instr_sysvec_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1062 [inli=
ne]
>  sysvec_apic_timer_interrupt+0xa6/0xc0 arch/x86/kernel/apic/apic.c:1062
>  </IRQ>
>  <TASK>
>  asm_sysvec_apic_timer_interrupt+0x1a/0x20 arch/x86/include/asm/idtentry.=
h:674
> RIP: 0010:stackdepot_memcmp lib/stackdepot.c:585 [inline]
> RIP: 0010:find_stack lib/stackdepot.c:618 [inline]
> RIP: 0010:stack_depot_save_flags+0x1aa/0x800 lib/stackdepot.c:676
> Code: 98 c3 ff 4c 8b 54 24 10 8b 74 24 04 85 db 75 5d 4d 8b 3f 4d 39 e7 7=
4 52 41 39 6f 10 75 f2 45 39 57 14 75 ec 31 c0 49 8b 0c c6 <49> 3b 4c c7 20=
 75 df 48 ff c0 41 39 c5 75 ed 83 fe 02 72 2f 49 8d
> RSP: 0018:ffffc9000603ed48 EFLAGS: 00000202
> RAX: 000000000000001a RBX: 0000000000000c01 RCX: ffffffff82463f22
> RDX: 0000000046192dc0 RSI: 0000000000000001 RDI: 00000000b3bfa5ab
> RBP: 000000008cb0243d R08: 00000000786bc44c R09: 0000000093aed82f
> R10: 000000000000001e R11: ffffffff8e959c60 R12: ffff88823b4243d0
> R13: 000000000000001e R14: ffffc9000603eda0 R15: ffff8881b8318e00
>  kasan_save_stack mm/kasan/common.c:58 [inline]
>  kasan_save_track+0x4f/0x80 mm/kasan/common.c:78
>  unpoison_slab_object mm/kasan/common.c:340 [inline]
>  __kasan_slab_alloc+0x6c/0x80 mm/kasan/common.c:366
>  kasan_slab_alloc include/linux/kasan.h:253 [inline]
>  slab_post_alloc_hook mm/slub.c:4612 [inline]
>  slab_alloc_node mm/slub.c:4945 [inline]
>  kmem_cache_alloc_lru_noprof+0x2aa/0x5f0 mm/slub.c:4978
>  __d_alloc+0x37/0x6f0 fs/dcache.c:1902
>  d_alloc+0x4b/0x190 fs/dcache.c:1981
>  lookup_one_qstr_excl+0xd8/0x360 fs/namei.c:1806
>  __start_dirop fs/namei.c:2920 [inline]
>  start_dirop+0x5c/0x90 fs/namei.c:2942
>  simple_start_creating+0xcc/0x110 fs/libfs.c:2305
>  debugfs_start_creating+0xdb/0x1a0 fs/debugfs/inode.c:394
>  debugfs_create_dir+0x24/0x350 fs/debugfs/inode.c:572
>  nsim_ethtool_init+0x28c/0x500 drivers/net/netdevsim/ethtool.c:254
>  nsim_create+0x26c/0x1150 drivers/net/netdevsim/netdev.c:1150
>  __nsim_dev_port_add+0x7f8/0xcd0 drivers/net/netdevsim/dev.c:1509
>  nsim_dev_port_add_all+0x37/0xf0 drivers/net/netdevsim/dev.c:1570
>  nsim_drv_probe+0x8ce/0xbf0 drivers/net/netdevsim/dev.c:1731
>  call_driver_probe drivers/base/dd.c:-1 [inline]
>  really_probe+0x254/0xae0 drivers/base/dd.c:706
>  __driver_probe_device+0x1e8/0x360 drivers/base/dd.c:868
>  driver_probe_device+0x4f/0x240 drivers/base/dd.c:898
>  __device_attach_driver+0x270/0x410 drivers/base/dd.c:1026
>  bus_for_each_drv+0x258/0x2f0 drivers/base/bus.c:500
>  __device_attach+0x2c4/0x450 drivers/base/dd.c:1098
>  device_initial_probe+0xa1/0xd0 drivers/base/dd.c:1153
>  bus_probe_device+0x12a/0x220 drivers/base/bus.c:620
>  device_add+0x7d7/0xb80 drivers/base/core.c:3772
>  nsim_bus_dev_new drivers/net/netdevsim/bus.c:471 [inline]
>  new_device_store+0x37b/0x710 drivers/net/netdevsim/bus.c:191
>  kernfs_fop_write_iter+0x3a4/0x540 fs/kernfs/file.c:345
>  new_sync_write fs/read_write.c:595 [inline]
>  vfs_write+0x612/0xba0 fs/read_write.c:687
>  ksys_write+0x150/0x270 fs/read_write.c:739
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7fac41b5d68e
> Code: 08 0f 85 a5 a8 ff ff 49 89 fb 48 89 f0 48 89 d7 48 89 ce 4c 89 c2 4=
d 89 ca 4c 8b 44 24 08 4c 8b 4c 24 10 4c 89 5c 24 08 0f 05 <c3> 66 2e 0f 1f=
 84 00 00 00 00 00 0f 1f 80 00 00 00 00 48 83 ec 08
> RSP: 002b:00007fff6b0eac58 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
> RAX: ffffffffffffffda RBX: 000055556430f500 RCX: 00007fac41b5d68e
> RDX: 0000000000000003 RSI: 00007fff6b0eace0 RDI: 0000000000000005
> RBP: 00007fac41c33716 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000003
> R13: 00007fff6b0eace0 R14: 00007fac42944620 R15: 0000000000000003
>  </TASK>
> BUG: sleeping function called from invalid context at kernel/irq_work.c:2=
89
> in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 5780, name: kworke=
r/u8:4
> preempt_count: 101, expected: 0
> RCU nest depth: 0, expected: 0
> 4 locks held by kworker/u8:4/5780:
>  #0: ffff88811326b140 ((wq_completion)ipv6_addrconf){+.+.}-{0:0}, at: pro=
cess_one_work kernel/workqueue.c:3297 [inline]
>  #0: ffff88811326b140 ((wq_completion)ipv6_addrconf){+.+.}-{0:0}, at: pro=
cess_scheduled_works+0xa20/0x14e0 kernel/workqueue.c:3405
>  #1: ffffc90003edfc40 ((work_completion)(&(&ifa->dad_work)->work)){+.+.}-=
{0:0}, at: process_one_work kernel/workqueue.c:3297 [inline]
>  #1: ffffc90003edfc40 ((work_completion)(&(&ifa->dad_work)->work)){+.+.}-=
{0:0}, at: process_scheduled_works+0xa20/0x14e0 kernel/workqueue.c:3405
>  #2: ffffffff8fded5c0 (rtnl_mutex){+.+.}-{4:4}, at: rtnl_net_lock include=
/linux/rtnetlink.h:134 [inline]
>  #2: ffffffff8fded5c0 (rtnl_mutex){+.+.}-{4:4}, at: addrconf_dad_work+0x1=
16/0x15c0 net/ipv6/addrconf.c:4229
>  #3: ffffffff8e959d80 (rcu_callback){....}-{0:0}, at: rcu_lock_acquire in=
clude/linux/rcupdate.h:300 [inline]
>  #3: ffffffff8e959d80 (rcu_callback){....}-{0:0}, at: rcu_do_batch kernel=
/rcu/tree.c:2639 [inline]
>  #3: ffffffff8e959d80 (rcu_callback){....}-{0:0}, at: rcu_core+0x70d/0x10=
a0 kernel/rcu/tree.c:2897
> Preemption disabled at:
> [<0000000000000000>] 0x0
> CPU: 0 UID: 0 PID: 5780 Comm: kworker/u8:4 Tainted: G        W           =
syzkaller #0 PREEMPT(full)
> Tainted: [W]=3DWARN
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Workqueue: ipv6_addrconf addrconf_dad_work
> Call Trace:
>  <IRQ>
>  dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
>  __might_resched+0x378/0x4d0 kernel/sched/core.c:9197
>  irq_work_sync+0x9b/0x300 kernel/irq_work.c:289
>  rhashtable_free_and_destroy+0x39/0x540 lib/rhashtable.c:1295
>  hash_netport4_destroy+0x56/0xb0 net/netfilter/ipset/ip_set_hash_gen.h:42=
0
>  ip_set_destroy_set_rcu+0x63/0xc0 net/netfilter/ipset/ip_set_core.c:1169
>  rcu_do_batch kernel/rcu/tree.c:2645 [inline]
>  rcu_core+0x78b/0x10a0 kernel/rcu/tree.c:2897
>  handle_softirqs+0x225/0x840 kernel/softirq.c:622
>  do_softirq+0x76/0xd0 kernel/softirq.c:523
>  </IRQ>
>  <TASK>
>  __local_bh_enable_ip+0xf8/0x130 kernel/softirq.c:450
>  spin_unlock_bh include/linux/spinlock.h:396 [inline]
>  addrconf_dad_work+0x2d1/0x15c0 net/ipv6/addrconf.c:4259
>  process_one_work kernel/workqueue.c:3322 [inline]
>  process_scheduled_works+0xa8e/0x14e0 kernel/workqueue.c:3405
>  worker_thread+0xa47/0xfb0 kernel/workqueue.c:3486
>  kthread+0x388/0x470 kernel/kthread.c:436
>  ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
>  </TASK>
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
> WARNING: suspicious RCU usage
> syzkaller #0 Tainted: G        W
> -----------------------------
> kernel/sched/core.c:9159 Illegal context switch in RCU-sched read-side cr=
itical section!
>
> other info that might help us debug this:
>
>
> rcu_scheduler_active =3D 2, debug_locks =3D 1
> 5 locks held by syz.1.174/6158:
>  #0: ffff888111ca7e88 (vm_lock){++++}-{0:0}, at: lock_vma_under_rcu+0x1d1=
/0x500 mm/mmap_lock.c:310
>  #1: ffffffff8e959c60 (rcu_read_lock){....}-{1:3}, at: rcu_lock_acquire i=
nclude/linux/rcupdate.h:300 [inline]
>  #1: ffffffff8e959c60 (rcu_read_lock){....}-{1:3}, at: rcu_read_lock incl=
ude/linux/rcupdate.h:840 [inline]
>  #1: ffffffff8e959c60 (rcu_read_lock){....}-{1:3}, at: __pte_offset_map+0=
x29/0x240 mm/pgtable-generic.c:290
>  #2: ffff88811429feb8 (ptlock_ptr(ptdesc)#2){+.+.}-{3:3}, at: spin_lock i=
nclude/linux/spinlock.h:342 [inline]
>  #2: ffff88811429feb8 (ptlock_ptr(ptdesc)#2){+.+.}-{3:3}, at: pte_offset_=
map_lock+0x13d/0x210 mm/pgtable-generic.c:404
>  #3: ffffffff8e959d20 (rcu_read_lock_sched){....}-{1:2}, at: rcu_lock_acq=
uire include/linux/rcupdate.h:300 [inline]
>  #3: ffffffff8e959d20 (rcu_read_lock_sched){....}-{1:2}, at: rcu_read_loc=
k_sched include/linux/rcupdate.h:938 [inline]
>  #3: ffffffff8e959d20 (rcu_read_lock_sched){....}-{1:2}, at: pfn_valid+0x=
ba/0x480 include/linux/mmzone.h:2270
>  #4: ffffffff8e959d80 (rcu_callback){....}-{0:0}, at: rcu_lock_acquire in=
clude/linux/rcupdate.h:300 [inline]
>  #4: ffffffff8e959d80 (rcu_callback){....}-{0:0}, at: rcu_do_batch kernel=
/rcu/tree.c:2639 [inline]
>  #4: ffffffff8e959d80 (rcu_callback){....}-{0:0}, at: rcu_core+0x70d/0x10=
a0 kernel/rcu/tree.c:2897
>
> stack backtrace:
> CPU: 0 UID: 0 PID: 6158 Comm: syz.1.174 Tainted: G        W           syz=
kaller #0 PREEMPT(full)
> Tainted: [W]=3DWARN
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Call Trace:
>  <IRQ>
>  dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
>  lockdep_rcu_suspicious+0x13f/0x1d0 kernel/locking/lockdep.c:6876
>  __might_resched+0xbb/0x4d0 kernel/sched/core.c:9159
>  irq_work_sync+0x9b/0x300 kernel/irq_work.c:289
>  rhashtable_free_and_destroy+0x39/0x540 lib/rhashtable.c:1295
>  hash_netport4_destroy+0x56/0xb0 net/netfilter/ipset/ip_set_hash_gen.h:42=
0
>  ip_set_destroy_set_rcu+0x63/0xc0 net/netfilter/ipset/ip_set_core.c:1169
>  rcu_do_batch kernel/rcu/tree.c:2645 [inline]
>  rcu_core+0x78b/0x10a0 kernel/rcu/tree.c:2897
>  handle_softirqs+0x225/0x840 kernel/softirq.c:622
>  __do_softirq kernel/softirq.c:656 [inline]
>  invoke_softirq kernel/softirq.c:496 [inline]
>  __irq_exit_rcu+0xca/0x220 kernel/softirq.c:735
>  irq_exit_rcu+0x9/0x30 kernel/softirq.c:752
>  instr_sysvec_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1062 [inli=
ne]
>  sysvec_apic_timer_interrupt+0xa6/0xc0 arch/x86/kernel/apic/apic.c:1062
>  </IRQ>
>  <TASK>
>  asm_sysvec_apic_timer_interrupt+0x1a/0x20 arch/x86/include/asm/idtentry.=
h:674
> RIP: 0010:valid_section include/linux/mmzone.h:2119 [inline]
> RIP: 0010:pfn_valid+0x11f/0x480 include/linux/mmzone.h:2271
> Code: 74 7d e8 84 ae 86 ff 4d 85 ff 75 11 e8 7a ae 86 ff eb 3d e8 73 ae 8=
6 ff 4d 85 ff 74 ef 4d 89 fd 49 c1 ed 03 43 80 7c 25 00 00 <74> 08 4c 89 ff=
 e8 07 3b f4 ff 49 8b 2f 48 89 ee 48 83 e6 02 31 ff
> RSP: 0000:ffffc9000283f8f0 EFLAGS: 00000246
> RAX: ffffffff823fb3bc RBX: ffffffff823fb37a RCX: ffff88811b629dc0
> RDX: 0000000000000000 RSI: ffffffff8c2ab860 RDI: ffffffff8c2ab820
> RBP: 0000000000000001 R08: ffffffff823fb37a R09: 0000000000000000
> R10: 0000000000000000 R11: ffffffff8e959d20 R12: dffffc0000000000
> R13: 1ffff11029fd668c R14: 000000000011c655 R15: ffff88814feb3460
>  page_table_check_set+0x25/0x530 mm/page_table_check.c:105
>  page_table_check_ptes_set include/linux/page_table_check.h:83 [inline]
>  set_ptes include/linux/pgtable.h:447 [inline]
>  set_pte_range+0x7ef/0x840 mm/memory.c:5588
>  finish_fault+0xe65/0x1220 mm/memory.c:5724
>  do_shared_fault mm/memory.c:5944 [inline]
>  do_fault mm/memory.c:5998 [inline]
>  do_pte_missing+0xf13/0x34b0 mm/memory.c:4566
>  handle_pte_fault mm/memory.c:6379 [inline]
>  __handle_mm_fault mm/memory.c:6517 [inline]
>  handle_mm_fault+0x1b36/0x3080 mm/memory.c:6686
>  do_user_addr_fault+0xa4d/0x1340 arch/x86/mm/fault.c:1343
>  handle_page_fault arch/x86/mm/fault.c:1483 [inline]
>  exc_page_fault+0x6a/0xc0 arch/x86/mm/fault.c:1536
>  asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:595
> RIP: 0033:0x7f04b9c65711
> Code: 00 48 89 ef e8 60 52 ff ff 48 8b 05 69 00 ee 00 83 05 52 00 ee 00 0=
1 be 08 00 00 00 48 89 ef 48 8d 50 ff 48 89 15 4f 00 ee 00 <44> 88 78 ff 44=
 8b 3d 34 00 ee 00 e8 2f 52 ff ff 48 8b 05 40 00 ee
> RSP: 002b:00007fffc2849160 EFLAGS: 00010202
> RAX: 0000001b32964000 RBX: 0000000000000000 RCX: 000000000003fde8
> RDX: 0000001b32963fff RSI: 0000000000000008 RDI: 00007f04bab45720
> RBP: 00007f04bab45720 R08: 0000000000000000 R09: 00007f04ba016038
> R10: 00007f04bab45700 R11: 0000000000000000 R12: 0000000000000000
> R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000003
>  </TASK>
> ------------[ cut here ]------------
> do not call blocking ops when !TASK_RUNNING; state=3D402 set at [<fffffff=
f819f28bd>] prepare_to_wait_event+0x3dd/0x480 kernel/sched/wait.c:317
> WARNING: kernel/sched/core.c:9124 at __might_sleep+0x92/0xf0 kernel/sched=
/core.c:9120, CPU#0: kworker/u9:0/26
> Modules linked in:
> CPU: 0 UID: 0 PID: 26 Comm: kworker/u9:0 Tainted: G        W           sy=
zkaller #0 PREEMPT(full)
> Tainted: [W]=3DWARN
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Workqueue: events_unbound toggle_allocation_gate
> RIP: 0010:__might_sleep+0xac/0xf0 kernel/sched/core.c:9120
> Code: 00 00 48 89 3c 24 41 89 f5 4c 8d 35 1e c1 9f 0e 43 80 3c 3c 00 74 0=
8 48 89 df e8 6f 7f 9e 00 48 8b 0b 4c 89 f7 89 ee 48 89 ca <67> 48 0f b9 3a=
 44 89 ee 48 8b 3c 24 eb b5 44 89 f1 80 e1 07 80 c1
> RSP: 0000:ffffc90000007c50 EFLAGS: 00010246
> RAX: 0000000000000000 RBX: ffff88810329f1b0 RCX: ffffffff819f28bd
> RDX: ffffffff819f28bd RSI: 0000000000000402 RDI: ffffffff90353090
> RBP: 0000000000000402 R08: ffffffff81acc8cd R09: 0000000000000000
> R10: 0000000000000000 R11: ffffffff8a074b10 R12: 1ffff11020653e36
> R13: 0000000000000121 R14: ffffffff90353090 R15: dffffc0000000000
> FS:  0000000000000000(0000) GS:ffff88818dc26000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f04ba016018 CR3: 000000000e746000 CR4: 00000000000006f0
> Call Trace:
>  <IRQ>
>  irq_work_sync+0x9b/0x300 kernel/irq_work.c:289
>  rhashtable_free_and_destroy+0x39/0x540 lib/rhashtable.c:1295
>  hash_netport4_destroy+0x56/0xb0 net/netfilter/ipset/ip_set_hash_gen.h:42=
0
>  ip_set_destroy_set_rcu+0x63/0xc0 net/netfilter/ipset/ip_set_core.c:1169
>  rcu_do_batch kernel/rcu/tree.c:2645 [inline]
>  rcu_core+0x78b/0x10a0 kernel/rcu/tree.c:2897
>  handle_softirqs+0x225/0x840 kernel/softirq.c:622
>  __do_softirq kernel/softirq.c:656 [inline]
>  invoke_softirq kernel/softirq.c:496 [inline]
>  __irq_exit_rcu+0xca/0x220 kernel/softirq.c:735
>  irq_exit_rcu+0x9/0x30 kernel/softirq.c:752
>  instr_sysvec_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1062 [inli=
ne]
>  sysvec_apic_timer_interrupt+0xa6/0xc0 arch/x86/kernel/apic/apic.c:1062
>  </IRQ>
>  <TASK>
>  asm_sysvec_apic_timer_interrupt+0x1a/0x20 arch/x86/include/asm/idtentry.=
h:674
> RIP: 0010:__raw_spin_unlock_irqrestore include/linux/spinlock_api_smp.h:1=
79 [inline]
> RIP: 0010:_raw_spin_unlock_irqrestore+0x47/0x80 kernel/locking/spinlock.c=
:198
> Code: f7 e8 ad 6c ea f5 f7 c3 00 02 00 00 74 05 e8 10 51 16 f6 9c 58 a9 0=
0 02 00 00 75 27 f7 c3 00 02 00 00 74 01 fb bf 01 00 00 00 <e8> b4 82 db f5=
 65 8b 05 ad 52 87 07 85 c0 74 18 5b 41 5e e9 91 48
> RSP: 0000:ffffc90000a179a8 EFLAGS: 00000206
> RAX: 0000000000000002 RBX: 0000000000000286 RCX: 0000000080000001
> RDX: 0000000000000006 RSI: ffffffff8dfdcfea RDI: 0000000000000001
> RBP: 0000000000000000 R08: ffffffff903237f7 R09: 1ffffffff20646fe
> R10: dffffc0000000000 R11: fffffbfff20646ff R12: ffff88810329d940
> R13: 0000000000000286 R14: ffffffff8eaa07c0 R15: ffffffff8eaa0800
>  spin_unlock_irqrestore include/linux/spinlock.h:408 [inline]
>  prepare_to_wait_event+0x436/0x480 kernel/sched/wait.c:319
>  toggle_allocation_gate+0x147/0x290 mm/kfence/core.c:913
>  process_one_work kernel/workqueue.c:3322 [inline]
>  process_scheduled_works+0xa8e/0x14e0 kernel/workqueue.c:3405
>  worker_thread+0xa47/0xfb0 kernel/workqueue.c:3486
>  kthread+0x388/0x470 kernel/kthread.c:436
>  ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
>  </TASK>
> ----------------
> Code disassembly (best guess):
>    0:   98                      cwtl
>    1:   c3                      ret
>    2:   ff 4c 8b 54             decl   0x54(%rbx,%rcx,4)
>    6:   24 10                   and    $0x10,%al
>    8:   8b 74 24 04             mov    0x4(%rsp),%esi
>    c:   85 db                   test   %ebx,%ebx
>    e:   75 5d                   jne    0x6d
>   10:   4d 8b 3f                mov    (%r15),%r15
>   13:   4d 39 e7                cmp    %r12,%r15
>   16:   74 52                   je     0x6a
>   18:   41 39 6f 10             cmp    %ebp,0x10(%r15)
>   1c:   75 f2                   jne    0x10
>   1e:   45 39 57 14             cmp    %r10d,0x14(%r15)
>   22:   75 ec                   jne    0x10
>   24:   31 c0                   xor    %eax,%eax
>   26:   49 8b 0c c6             mov    (%r14,%rax,8),%rcx
> * 2a:   49 3b 4c c7 20          cmp    0x20(%r15,%rax,8),%rcx <-- trappin=
g instruction
>   2f:   75 df                   jne    0x10
>   31:   48 ff c0                inc    %rax
>   34:   41 39 c5                cmp    %eax,%r13d
>   37:   75 ed                   jne    0x26
>   39:   83 fe 02                cmp    $0x2,%esi
>   3c:   72 2f                   jb     0x6d
>   3e:   49                      rex.WB
>   3f:   8d                      .byte 0x8d
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
> [fw@strlen.de kadlec@netfilter.org netfilter-devel@vger.kernel.org]
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
-upstream-moderation/6a56e791.c90005c7.37d349.003b.GAE%40google.com.
