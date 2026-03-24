Received: from mail-oo1-f72.google.com (mail-oo1-f72.google.com [209.85.161.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EE363FD121
	for <syzbot@lists.linux.dev>; Tue, 24 Mar 2026 14:36:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774362963; cv=none; b=U5UA/vrv/ZQcy8ISXHT/kqHZYI5sTUXCM0PpPNGvwH+Im5ZE0F5laiWwIAYqANRx/loiOKFOF8r4EJpVgZbDwFY1LRXBDT4D6LjwPCCgW0HkSP7nJPzxQ9srq39e8w5651x2dWvofWAeoKkHo9CBC6M3joYx/p5dch75D8w/kpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774362963; c=relaxed/simple;
	bh=+3ocNHuK4s2WatELL/Mhuf5TQSGUaUz638xQe09vs7o=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=hGvHDfCqD+lzeKExJ9GwSO5lZ3V+wCmRT93heSNpjzfJ+6zCZ+0euV2xybqIkZGYdtHPKCf9JdIWCuDpNhuuw4UXeEeZBwkDGELZ1PrCW+1q8HhZ3hZy2GXdKgDJO6Cu8/k8JQUYUoU4e6aeyaKCTM0WRHVhOYZOK+j0uVB4onQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f72.google.com with SMTP id 006d021491bc7-67decc183d6so19015725eaf.0
        for <syzbot@lists.linux.dev>; Tue, 24 Mar 2026 07:36:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774362960; x=1774967760;
        h=content-transfer-encoding:cc:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZUe3NPWMf+Tv7F08kvhKgv6xOPBcRQEtIxh8g6Ubxxg=;
        b=fsntF+F+J1bPCZfcSiklbyOXIVOIwCKrWuR9QYRwVVuckiKXGmVJMFd2u9jq68maj/
         WKo6e9ZczjMAUhiGNWM/QeLkkwp94fHdYi1AW4mfFi5Z33Ts1/wKYxm62Nzz9EZJvqSI
         52FZ8X8dgb4tyh/qLn/oZnE4gWP3kvgAeNCla+jBBdGxOhPUW9mnbdaiNvsjLK2BXDja
         qgtJ2IeOGwVB1+Iwk6IhoLvq5l+0ypBYDtjGoWKwCmh7kcuY7ebBf7UNCVEpavVByMNN
         Y9H7TmKAkP3tO5n1s9ioZRvgdckS34gdzknl38BW9o/OTWfycAz/wCFfrNNAqBfFMUEL
         CyzA==
X-Gm-Message-State: AOJu0YyObk+0UVVqFkNheuvBVKEUauhzyxC891BunLV0+arHWsLozhlr
	h09FJa4tXC6Whf0iQaYmm20PfeBXGLrr+VDp546YRBb061o5wibGnZbtKiUV9M77KpCS1Q9LZOQ
	QfPNRszdPuailG40pfoQ9TZkf3m1PEanhZwiiz7yIQqGSs2SGNyqTLPsLxhE=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:150a:b0:67b:db23:4f74 with SMTP id
 006d021491bc7-67c22ff0011mr12156420eaf.68.1774362960456; Tue, 24 Mar 2026
 07:36:00 -0700 (PDT)
Date: Tue, 24 Mar 2026 07:36:00 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69c2a150.a70a0220.3cae05.0010.GAE@google.com>
Subject: [moderation/CI] Re: context_tracking,x86: Defer some IPIs until a
 user->kernel transition
From: syzbot ci <syzbot+cia60580ab53df6395@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v8] context_tracking,x86: Defer some IPIs until a user->kernel transition
https://lore.kernel.org/all/20260324094801.3092968-1-vschneid@redhat.com
* [RFC PATCH v8 01/10] objtool: Make validate_call() recognize indirect cal=
ls to pv_ops[]
* [RFC PATCH v8 02/10] objtool: Flesh out warning related to pv_ops[] calls
* [RFC PATCH v8 03/10] objtool: Always pass a section to validate_unwind_hi=
nts()
* [RFC PATCH v8 04/10] x86/retpoline: Make warn_thunk_thunk .noinstr
* [RFC PATCH v8 05/10] sched/isolation: Mark housekeeping_overridden key as=
 __ro_after_init
* [RFC PATCH v8 06/10] objtool: Add .entry.text validation for static branc=
hes
* [RFC PATCH v8 07/10] x86/jump_label: Add ASM support for static_branch_li=
kely()
* [RFC PATCH v8 08/10] x86/mm/pti: Introduce a kernel/user CR3 software sig=
nal
* [RFC PATCH v8 09/10] context_tracking,x86: Defer kernel text patching IPI=
s when tracking CR3 switches
* [RFC PATCH v8 10/10] x86/mm, mm/vmalloc: Defer kernel TLB flush IPIs when=
 tracking CR3 switches

and found the following issues:
* KASAN: slab-out-of-bounds Read in __dynamic_pr_debug
* KASAN: slab-use-after-free Read in __dynamic_dev_dbg

Full report is available here:
https://ci.syzbot.org/series/e1f9c661-db83-4882-8439-ab6d1b3ffe07

***

KASAN: slab-out-of-bounds Read in __dynamic_pr_debug

tree:      linux-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/next/li=
nux-next
base:      f9d6fc9557e68b48253818870d002dc4784cb2f1
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp=
1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/c63282ed-913a-4673-b0e4-cd21246874b=
2/config
C repro:   https://ci.syzbot.org/findings/5b3af331-6a29-4205-911e-8924b9c54=
449/c_repro
syz repro: https://ci.syzbot.org/findings/5b3af331-6a29-4205-911e-8924b9c54=
449/syz_repro

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
BUG: KASAN: slab-out-of-bounds in string_nocheck lib/vsprintf.c:654 [inline=
]
BUG: KASAN: slab-out-of-bounds in string+0x231/0x2b0 lib/vsprintf.c:736
Read of size 1 at addr ffff8881663cbca1 by task syz.0.17/5964

CPU: 0 UID: 0 PID: 5964 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(ful=
l)=20
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16=
.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 print_address_description mm/kasan/report.c:378 [inline]
 print_report+0xba/0x230 mm/kasan/report.c:482
 kasan_report+0x117/0x150 mm/kasan/report.c:595
 string_nocheck lib/vsprintf.c:654 [inline]
 string+0x231/0x2b0 lib/vsprintf.c:736
 vsnprintf+0x739/0xee0 lib/vsprintf.c:2947
 va_format lib/vsprintf.c:1722 [inline]
 pointer+0x9b7/0x11f0 lib/vsprintf.c:2568
 vsnprintf+0x614/0xee0 lib/vsprintf.c:2951
 vprintk_store+0x371/0xd50 kernel/printk/printk.c:2255
 vprintk_emit+0x192/0x560 kernel/printk/printk.c:2402
 _printk+0xdd/0x130 kernel/printk/printk.c:2451
 __dynamic_pr_debug+0x1a2/0x260 lib/dynamic_debug.c:879
 nfc_llcp_wks_sap net/nfc/llcp_core.c:344 [inline]
 nfc_llcp_get_sdp_ssap+0x3a5/0x440 net/nfc/llcp_core.c:420
 llcp_sock_bind+0x3d6/0x780 net/nfc/llcp_sock.c:114
 __sys_bind_socket net/socket.c:1874 [inline]
 __sys_bind+0x2e3/0x410 net/socket.c:1905
 __do_sys_bind net/socket.c:1910 [inline]
 __se_sys_bind net/socket.c:1908 [inline]
 __x64_sys_bind+0x7a/0x90 net/socket.c:1908
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xe2/0xf40 arch/x86/entry/syscall_64.c:98
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f5158f9c799
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 =
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff f=
f 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffe7ca57bc8 EFLAGS: 00000246 ORIG_RAX: 0000000000000031
RAX: ffffffffffffffda RBX: 00007f5159215fa0 RCX: 00007f5158f9c799
RDX: 0000000000000060 RSI: 0000200000000080 RDI: 0000000000000004
RBP: 00007f5159032c99 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f5159215fac R14: 00007f5159215fa0 R15: 00007f5159215fa0
 </TASK>

Allocated by task 5964:
 kasan_save_stack mm/kasan/common.c:57 [inline]
 kasan_save_track+0x3e/0x80 mm/kasan/common.c:78
 poison_kmalloc_redzone mm/kasan/common.c:398 [inline]
 __kasan_kmalloc+0x93/0xb0 mm/kasan/common.c:415
 kasan_kmalloc include/linux/kasan.h:263 [inline]
 __do_kmalloc_node mm/slub.c:5657 [inline]
 __kmalloc_node_track_caller_noprof+0x558/0x7f0 mm/slub.c:5768
 kmemdup_noprof+0x2b/0x70 mm/util.c:138
 kmemdup_noprof include/linux/fortify-string.h:765 [inline]
 llcp_sock_bind+0x392/0x780 net/nfc/llcp_sock.c:107
 __sys_bind_socket net/socket.c:1874 [inline]
 __sys_bind+0x2e3/0x410 net/socket.c:1905
 __do_sys_bind net/socket.c:1910 [inline]
 __se_sys_bind net/socket.c:1908 [inline]
 __x64_sys_bind+0x7a/0x90 net/socket.c:1908
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xe2/0xf40 arch/x86/entry/syscall_64.c:98
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

The buggy address belongs to the object at ffff8881663cbca0
 which belongs to the cache kmalloc-8 of size 8
The buggy address is located 0 bytes to the right of
 allocated 1-byte region [ffff8881663cbca0, ffff8881663cbca1)

The buggy address belongs to the physical page:
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0xffff8881663cb7=
e0 pfn:0x1663cb
anon flags: 0x57ff00000000000(node=3D1|zone=3D2|lastcpupid=3D0x7ff)
page_type: f5(slab)
raw: 057ff00000000000 ffff888100041500 0000000000000000 dead000000000001
raw: ffff8881663cb7e0 0000000080800078 00000000f5000000 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 0, migratetype Unmovable, gfp_mask 0x52cc0(GF=
P_KERNEL|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP), pid 1, tgid 1 (swapper/0),=
 ts 3460727604, free_ts 3423843770
 set_page_owner include/linux/page_owner.h:32 [inline]
 post_alloc_hook+0x228/0x280 mm/page_alloc.c:1884
 prep_new_page mm/page_alloc.c:1892 [inline]
 get_page_from_freelist+0x24dc/0x2580 mm/page_alloc.c:3945
 __alloc_frozen_pages_noprof+0x18d/0x380 mm/page_alloc.c:5240
 alloc_pages_mpol+0x232/0x4a0 mm/mempolicy.c:2486
 alloc_slab_page mm/slub.c:3075 [inline]
 allocate_slab+0x86/0x3a0 mm/slub.c:3248
 new_slab mm/slub.c:3302 [inline]
 ___slab_alloc+0xd82/0x1760 mm/slub.c:4656
 __slab_alloc+0x65/0x100 mm/slub.c:4779
 __slab_alloc_node mm/slub.c:4855 [inline]
 slab_alloc_node mm/slub.c:5251 [inline]
 __do_kmalloc_node mm/slub.c:5656 [inline]
 __kmalloc_noprof+0x46c/0x7e0 mm/slub.c:5669
 kmalloc_noprof include/linux/slab.h:961 [inline]
 kzalloc_noprof include/linux/slab.h:1094 [inline]
 acpi_ns_internalize_name+0x2c9/0x3e0 drivers/acpi/acpica/nsutils.c:331
 acpi_ns_get_node_unlocked+0x186/0x480 drivers/acpi/acpica/nsutils.c:666
 acpi_ns_get_node+0x76/0xc0 drivers/acpi/acpica/nsutils.c:726
 acpi_ns_evaluate+0x283/0x1230 drivers/acpi/acpica/nseval.c:62
 acpi_evaluate_object+0x657/0xd50 drivers/acpi/acpica/nsxfeval.c:354
 acpi_get_physical_device_location+0xa0/0x2d0 drivers/acpi/utils.c:504
 acpi_store_pld_crc drivers/acpi/scan.c:728 [inline]
 acpi_device_add+0x6c4/0x940 drivers/acpi/scan.c:787
 acpi_add_single_object+0x1621/0x1b70 drivers/acpi/scan.c:1910
page last free pid 1 tgid 1 stack trace:
 reset_page_owner include/linux/page_owner.h:25 [inline]
 free_pages_prepare mm/page_alloc.c:1433 [inline]
 __free_frozen_pages+0xbf8/0xd70 mm/page_alloc.c:2973
 discard_slab mm/slub.c:3346 [inline]
 __put_partials+0x146/0x170 mm/slub.c:3886
 __slab_free+0x294/0x320 mm/slub.c:5956
 qlink_free mm/kasan/quarantine.c:163 [inline]
 qlist_free_all+0x97/0x100 mm/kasan/quarantine.c:179
 kasan_quarantine_remove_cache+0x1ca/0x360 mm/kasan/quarantine.c:364
 kmem_cache_shrink+0xd/0x20 mm/slab_common.c:564
 acpi_os_purge_cache+0x15/0x20 drivers/acpi/osl.c:1605
 acpi_purge_cached_objects+0xd5/0x100 drivers/acpi/acpica/utxface.c:240
 acpi_initialize_objects+0x2e/0xb0 drivers/acpi/acpica/utxfinit.c:250
 acpi_bus_init+0xaf/0x570 drivers/acpi/bus.c:1367
 acpi_init+0xa1/0x1f0 drivers/acpi/bus.c:1456
 do_one_initcall+0x250/0x840 init/main.c:1378
 do_initcall_level+0x104/0x190 init/main.c:1440
 do_initcalls+0x59/0xa0 init/main.c:1456
 kernel_init_freeable+0x2a6/0x3d0 init/main.c:1688
 kernel_init+0x1d/0x1d0 init/main.c:1578

Memory state around the buggy address:
 ffff8881663cbb80: fa fc fc fc fa fc fc fc fa fc fc fc fa fc fc fc
 ffff8881663cbc00: fa fc fc fc fa fc fc fc fa fc fc fc fa fc fc fc
>ffff8881663cbc80: fa fc fc fc 01 fc fc fc 00 fc fc fc fa fc fc fc
                               ^
 ffff8881663cbd00: fa fc fc fc fa fc fc fc fa fc fc fc fa fc fc fc
 ffff8881663cbd80: fa fc fc fc fa fc fc fc fa fc fc fc fa fc fc fc
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D


***

KASAN: slab-use-after-free Read in __dynamic_dev_dbg

tree:      linux-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/next/li=
nux-next
base:      f9d6fc9557e68b48253818870d002dc4784cb2f1
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp=
1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/c63282ed-913a-4673-b0e4-cd21246874b=
2/config
syz repro: https://ci.syzbot.org/findings/a49a383b-f0f8-498a-9415-6a927fc7d=
4b7/syz_repro

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
BUG: KASAN: slab-use-after-free in dev_driver_string+0x35/0xd0 drivers/base=
/core.c:2406
Read of size 8 at addr ffff8881137960e0 by task syz.0.17/6043

CPU: 1 UID: 0 PID: 6043 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(ful=
l)=20
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16=
.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 print_address_description mm/kasan/report.c:378 [inline]
 print_report+0xba/0x230 mm/kasan/report.c:482
 kasan_report+0x117/0x150 mm/kasan/report.c:595
 dev_driver_string+0x35/0xd0 drivers/base/core.c:2406
 __dynamic_dev_dbg+0x1ae/0x2e0 lib/dynamic_debug.c:906
 display_close+0x1f9/0x240 drivers/media/rc/imon.c:576
 __fput+0x44f/0xa70 fs/file_table.c:469
 task_work_run+0x1d9/0x270 kernel/task_work.c:233
 exit_task_work include/linux/task_work.h:40 [inline]
 do_exit+0x69b/0x2310 kernel/exit.c:971
 do_group_exit+0x21b/0x2d0 kernel/exit.c:1112
 get_signal+0x1284/0x1330 kernel/signal.c:3034
 arch_do_signal_or_restart+0xbc/0x830 arch/x86/kernel/signal.c:337
 __exit_to_user_mode_loop kernel/entry/common.c:41 [inline]
 exit_to_user_mode_loop+0x86/0x480 kernel/entry/common.c:75
 __exit_to_user_mode_prepare include/linux/irq-entry-common.h:226 [inline]
 syscall_exit_to_user_mode_prepare include/linux/irq-entry-common.h:256 [in=
line]
 syscall_exit_to_user_mode_work include/linux/entry-common.h:159 [inline]
 syscall_exit_to_user_mode include/linux/entry-common.h:194 [inline]
 do_syscall_64+0x2b7/0xf40 arch/x86/entry/syscall_64.c:104
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fb43639c799
Code: Unable to access opcode bytes at 0x7fb43639c76f.
RSP: 002b:00007fb4372890e8 EFLAGS: 00000246 ORIG_RAX: 00000000000000ca
RAX: fffffffffffffe00 RBX: 00007fb436616188 RCX: 00007fb43639c799
RDX: 0000000000000000 RSI: 0000000000000080 RDI: 00007fb436616188
RBP: 00007fb436616180 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fb436616218 R14: 00007ffeece49910 R15: 00007ffeece499f8
 </TASK>

Allocated by task 5990:
 kasan_save_stack mm/kasan/common.c:57 [inline]
 kasan_save_track+0x3e/0x80 mm/kasan/common.c:78
 poison_kmalloc_redzone mm/kasan/common.c:398 [inline]
 __kasan_kmalloc+0x93/0xb0 mm/kasan/common.c:415
 kasan_kmalloc include/linux/kasan.h:263 [inline]
 __kmalloc_cache_noprof+0x3d1/0x6e0 mm/slub.c:5780
 kmalloc_noprof include/linux/slab.h:957 [inline]
 kzalloc_noprof include/linux/slab.h:1094 [inline]
 usb_set_configuration+0x3c9/0x2110 drivers/usb/core/message.c:2037
 usb_generic_driver_probe+0x8d/0x150 drivers/usb/core/generic.c:250
 usb_probe_device+0x1c4/0x3b0 drivers/usb/core/driver.c:291
 call_driver_probe drivers/base/dd.c:-1 [inline]
 really_probe+0x267/0xaf0 drivers/base/dd.c:661
 __driver_probe_device+0x18c/0x320 drivers/base/dd.c:803
 driver_probe_device+0x4f/0x240 drivers/base/dd.c:833
 __device_attach_driver+0x279/0x430 drivers/base/dd.c:961
 bus_for_each_drv+0x258/0x2f0 drivers/base/bus.c:500
 __device_attach+0x2c5/0x450 drivers/base/dd.c:1033
 device_initial_probe+0xa1/0xd0 drivers/base/dd.c:1088
 bus_probe_device+0x12a/0x220 drivers/base/bus.c:574
 device_add+0x7b6/0xb70 drivers/base/core.c:3689
 usb_new_device+0xa08/0x16f0 drivers/usb/core/hub.c:2695
 hub_port_connect drivers/usb/core/hub.c:5567 [inline]
 hub_port_connect_change drivers/usb/core/hub.c:5707 [inline]
 port_event drivers/usb/core/hub.c:5871 [inline]
 hub_event+0x2a1c/0x4f30 drivers/usb/core/hub.c:5953
 process_one_work kernel/workqueue.c:3257 [inline]
 process_scheduled_works+0xaec/0x17a0 kernel/workqueue.c:3340
 worker_thread+0xda6/0x1360 kernel/workqueue.c:3421
 kthread+0x726/0x8b0 kernel/kthread.c:463
 ret_from_fork+0x51b/0xa40 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:246

Freed by task 9:
 kasan_save_stack mm/kasan/common.c:57 [inline]
 kasan_save_track+0x3e/0x80 mm/kasan/common.c:78
 kasan_save_free_info+0x46/0x50 mm/kasan/generic.c:584
 poison_slab_object mm/kasan/common.c:253 [inline]
 __kasan_slab_free+0x5c/0x80 mm/kasan/common.c:285
 kasan_slab_free include/linux/kasan.h:235 [inline]
 slab_free_hook mm/slub.c:2540 [inline]
 slab_free mm/slub.c:6674 [inline]
 kfree+0x1be/0x650 mm/slub.c:6886
 device_release+0x9e/0x1d0 drivers/base/core.c:-1
 kobject_cleanup lib/kobject.c:689 [inline]
 kobject_release lib/kobject.c:720 [inline]
 kref_put include/linux/kref.h:65 [inline]
 kobject_put+0x228/0x560 lib/kobject.c:737
 usb_disable_device+0x611/0x8d0 drivers/usb/core/message.c:1425
 usb_disconnect+0x32f/0x990 drivers/usb/core/hub.c:2345
 hub_port_connect drivers/usb/core/hub.c:5407 [inline]
 hub_port_connect_change drivers/usb/core/hub.c:5707 [inline]
 port_event drivers/usb/core/hub.c:5871 [inline]
 hub_event+0x1cc9/0x4f30 drivers/usb/core/hub.c:5953
 process_one_work kernel/workqueue.c:3257 [inline]
 process_scheduled_works+0xaec/0x17a0 kernel/workqueue.c:3340
 worker_thread+0xda6/0x1360 kernel/workqueue.c:3421
 kthread+0x726/0x8b0 kernel/kthread.c:463
 ret_from_fork+0x51b/0xa40 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:246

The buggy address belongs to the object at ffff888113796000
 which belongs to the cache kmalloc-2k of size 2048
The buggy address is located 224 bytes inside of
 freed 2048-byte region [ffff888113796000, ffff888113796800)

The buggy address belongs to the physical page:
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x113790
head: order:3 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0
flags: 0x17ff00000000040(head|node=3D0|zone=3D2|lastcpupid=3D0x7ff)
page_type: f5(slab)
raw: 017ff00000000040 ffff888100042000 dead000000000122 0000000000000000
raw: 0000000000000000 0000000000080008 00000000f5000000 0000000000000000
head: 017ff00000000040 ffff888100042000 dead000000000122 0000000000000000
head: 0000000000000000 0000000000080008 00000000f5000000 0000000000000000
head: 017ff00000000003 ffffea00044de401 00000000ffffffff 00000000ffffffff
head: ffffffffffffffff 0000000000000000 00000000ffffffff 0000000000000008
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 3, migratetype Unmovable, gfp_mask 0xd20c0(__=
GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pi=
d 6019, tgid 6019 (kworker/0:5), ts 128207296876, free_ts 125356693648
 set_page_owner include/linux/page_owner.h:32 [inline]
 post_alloc_hook+0x228/0x280 mm/page_alloc.c:1884
 prep_new_page mm/page_alloc.c:1892 [inline]
 get_page_from_freelist+0x24dc/0x2580 mm/page_alloc.c:3945
 __alloc_frozen_pages_noprof+0x18d/0x380 mm/page_alloc.c:5240
 alloc_pages_mpol+0x232/0x4a0 mm/mempolicy.c:2486
 alloc_slab_page mm/slub.c:3075 [inline]
 allocate_slab+0x86/0x3a0 mm/slub.c:3248
 new_slab mm/slub.c:3302 [inline]
 ___slab_alloc+0xd82/0x1760 mm/slub.c:4656
 __slab_alloc+0x65/0x100 mm/slub.c:4779
 __slab_alloc_node mm/slub.c:4855 [inline]
 slab_alloc_node mm/slub.c:5251 [inline]
 __do_kmalloc_node mm/slub.c:5656 [inline]
 __kmalloc_node_track_caller_noprof+0x5b7/0x7f0 mm/slub.c:5768
 kmalloc_reserve+0x136/0x290 net/core/skbuff.c:608
 __alloc_skb+0x204/0x390 net/core/skbuff.c:690
 alloc_skb include/linux/skbuff.h:1383 [inline]
 mld_newpack+0x14c/0xc90 net/ipv6/mcast.c:1775
 add_grhead+0x5a/0x2a0 net/ipv6/mcast.c:1886
 add_grec+0x1452/0x1740 net/ipv6/mcast.c:2025
 mld_send_cr net/ipv6/mcast.c:2148 [inline]
 mld_ifc_work+0x6e6/0xe70 net/ipv6/mcast.c:2693
 process_one_work kernel/workqueue.c:3257 [inline]
 process_scheduled_works+0xaec/0x17a0 kernel/workqueue.c:3340
 worker_thread+0xda6/0x1360 kernel/workqueue.c:3421
page last free pid 5243 tgid 5243 stack trace:
 reset_page_owner include/linux/page_owner.h:25 [inline]
 free_pages_prepare mm/page_alloc.c:1433 [inline]
 __free_frozen_pages+0xbf8/0xd70 mm/page_alloc.c:2973
 discard_slab mm/slub.c:3346 [inline]
 __put_partials+0x146/0x170 mm/slub.c:3886
 __slab_free+0x294/0x320 mm/slub.c:5956
 qlink_free mm/kasan/quarantine.c:163 [inline]
 qlist_free_all+0x97/0x100 mm/kasan/quarantine.c:179
 kasan_quarantine_reduce+0x148/0x160 mm/kasan/quarantine.c:286
 __kasan_slab_alloc+0x22/0x80 mm/kasan/common.c:350
 kasan_slab_alloc include/linux/kasan.h:253 [inline]
 slab_post_alloc_hook mm/slub.c:4953 [inline]
 slab_alloc_node mm/slub.c:5263 [inline]
 kmem_cache_alloc_node_noprof+0x427/0x6f0 mm/slub.c:5315
 __alloc_skb+0x1d7/0x390 net/core/skbuff.c:679
 alloc_skb include/linux/skbuff.h:1383 [inline]
 alloc_skb_with_frags+0xca/0x890 net/core/skbuff.c:6715
 sock_alloc_send_pskb+0x878/0x990 net/core/sock.c:2995
 unix_dgram_sendmsg+0x460/0x18e0 net/unix/af_unix.c:2130
 sock_sendmsg_nosec net/socket.c:727 [inline]
 __sock_sendmsg net/socket.c:742 [inline]
 __sys_sendto+0x709/0x7a0 net/socket.c:2206
 __do_sys_sendto net/socket.c:2213 [inline]
 __se_sys_sendto net/socket.c:2209 [inline]
 __x64_sys_sendto+0xde/0x100 net/socket.c:2209
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xe2/0xf40 arch/x86/entry/syscall_64.c:98
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Memory state around the buggy address:
 ffff888113795f80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff888113796000: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>ffff888113796080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                                       ^
 ffff888113796100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff888113796180: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[acme@kernel.org akpm@linux-foundation.org ardb@kernel.org arnd@arndb.de bo=
qun.feng@gmail.com bp@alien8.de dan.carpenter@linaro.org dave.hansen@linux.=
intel.com davem@davemloft.net dwagner@suse.de frederic@kernel.org hpa@zytor=
.com jannh@google.com jbaron@akamai.com joelagnelf@nvidia.com josh@joshtrip=
lett.org jpoimboe@kernel.org juri.lelli@redhat.com linux-kernel@vger.kernel=
.org linux-mm@kvack.org luto@kernel.org masahiroy@kernel.org mathieu.desnoy=
ers@efficios.com mgorman@suse.de mingo@redhat.com mtosatti@redhat.com neera=
j.upadhyay@kernel.org nsaenzju@redhat.com oleg@redhat.com paulmck@kernel.or=
g pbonzini@redhat.com peterz@infradead.org ptesarik@suse.com riel@surriel.c=
om rostedt@goodmis.org samitolvanen@google.com shenhan@google.com sshegde@l=
inux.ibm.com tglozar@redhat.com tglx@linutronix.de urezki@gmail.com vschnei=
d@redhat.com williams@redhat.com x86@kernel.org ypodemsk@redhat.com]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

