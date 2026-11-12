Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.72
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794468326;
	b=yjmgEpF4gFZ1J9hh2bMu7m+6VKPsGkFmShTyDc+KsDsZnuAEjs1qX9OP0pf8Z3VITokA
	 m3txQyXNcT05JbgoVtLAiBX7mxzNH7ThugbeYhAXo2dyRVCIimIgcASvwc/fPQ6OSuAXx
	 h3NMB7tOx9XJ3BtIphkbtNGKOPSGYWKw1paZ1oWJcdm01mDsVRW13NTusGCfSoAq3A3WK
	 7pU36Dh2g+QN+z/DhoP56ST4XHEaE6F32Hnwu2U1LbpvRWClr0x+WnyKgDaOoEfL98TZz
	 rw16el1Z4uqGKb2AoFT8jLg9ryv0y4VyLGf3BLmSaQaSXyYDu0Itg5hY0m971XV8Miw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794468326;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 MIME-Version:X-Received:Date:In-Reply-To:X-Google-Appengine-App-Id:
	 X-Google-Appengine-App-Id-Alias:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=wjEUB4xwOQ+z3iLncf90mEYp39goyjluFTd4fV3fH5g=;
	b=16ZilPqlPnqDrd7X1Ij5aFmXWPkgwdi2DYAZgKWtJ9FMzAUs+Ly6bESQdSI7MdJ9f/8c
	 PAXxAPez97+MxnMP9zoI6pMtNPaFl6+8aOU/GibTOIL64EV9Wbd6NHzA46iSURp6HYkqy
	 yxjc0nFtDPDUYRuLj0gkZNpfu1YOHW9zuyQ9/I6/IUqVLDNnB6vXEJ6DZ6oJ2oa7WXh5h
	 jCkuB7i/ob3eUqePNso1OwrpdKCmhZFvvIH+M8u4RBV1mGqZtZVln0Ny30vKKeHSNQ/tV
	 5c7edSoVdh0y8AmsRGz4mzk/xjG6tWflbzm1RoCp7QOhjPetP5kFv4RlkYl+zjhLwuA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=syzkaller.appspotmail.com;
	spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	arc=none smtp.remote-ip=209.85.210.72
Received: from mail-ot1-f72.google.com (mail-ot1-f72.google.com [209.85.210.72])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1904606A32D
	for <syzbot@lists.linux.dev>; Thu, 12 Nov 2026 07:25:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F1904606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f72.google.com with SMTP id 46e09a7af769-824cc5f7fcdso4930914a34.3
        for <syzbot@lists.linux.dev>; Wed, 11 Nov 2026 23:25:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794468325; x=1795073125;
        h=content-type:cc:to:from:subject:message-id:in-reply-to:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=wjEUB4xwOQ+z3iLncf90mEYp39goyjluFTd4fV3fH5g=;
        b=cD6ss6rVZs71AhUYQYCNxjeZfJeB4yl4CbrnRWCnhr6FZ67xaq6skpj5GaEzP4Gf1+
         5klbAkYiWJ8D9MAGxRKcDsOvzXpuTHhDS4on3X96pyxUoOfJVz26MjB/yABuJ/HD6Vt9
         YZR8xokFjlox4HHxFraeqoyzrOUfCkGWlBj+9tu8RH9No5uan12SnfM5832hd/xdk+v4
         Vdrp5Wg3NO6mgPt1vnFHw6d89v4lFgAq6ctJ1x5uzp5Q/UzZiWcIL9X4rgi7gEkj9SBP
         8wGixEpjmAAzzhg0pyJrEnm0wf94A8S1m/Pjc8/em+F7rSPyl8mN0SwV6CcbxtjobRyi
         X4iQ==
X-Gm-Message-State: APuU4Z84dsBVt4GDKmmAB53JOQM0Soxt3hNR/K62gZ4GiM04gSEQO0hc
	MJoQpPKVOw3L6SDbrXCulFRCA5ySY3ioiGWV7yfcBHEPU5L7V6Pqx+h8Tajwe58wEbgHlhI0Sa6
	x/Pg3TP6nTR9Zrd+FLRVRUUKAk4WxSZnRrracQBFnq/xV0Pdex95MJI/HULs=
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Post: <mailto:syzbot@lists.linux.dev>
List-Help: <mailto:syzbot+help@lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
List-Owner: <mailto:syzbot+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-Received: by 2002:a05:6808:15aa:b0:4e8:e73e:e945 with SMTP id
 5614622812f47-56b9872af1dmr5151136b6e.63.1794468325005; Wed, 11 Nov 2026
 23:25:25 -0800 (PST)
Date: Wed, 11 Nov 2026 23:25:24 -0800
In-Reply-To: <20261109055455.536925-1-baoquan.he@linux.dev>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6af569e4.ad703688.70d19.3c73.GAE@google.com>
Subject: [syzbot ci] Re: mm, swap: extendable swap devices (xswap phase I)
From: syzbot ci <syzbot+ci2f12bcc59adcd0ab@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, baohua@kernel.org, baoquan.he@linux.dev, 
	chengming.zhou@linux.dev, chentao@kylinos.cn, chrisl@kernel.org, 
	corbet@lwn.net, david@kernel.org, hannes@cmpxchg.org, hebaoquan@kylinos.cn, 
	kasong@tencent.com, klarasmodin@gmail.com, kunwu.chan@gmail.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, nphamcs@gmail.com, 
	youngjun.park@lge.com
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v5] mm, swap: extendable swap devices (xswap phase I)
https://lore.kernel.org/all/20261109055455.536925-1-baoquan.he@linux.dev
* [PATCH v5 01/19] mm: xswap support for zswap
* [PATCH v5 02/19] mm, swap: refactor free_swap_cluster_info to take swap_info_struct
* [PATCH v5 03/19] mm, swap: add VM_SPARSE cluster-array helpers for xswap
* [PATCH v5 04/19] mm, swap: use a VM_SPARSE cluster array for xswap devices
* [PATCH v5 05/19] mm, swap: widen swap_info_struct max/pages to unsigned long
* [PATCH v5 06/19] mm, swap: add a sysfs interface to create xswap devices
* [PATCH v5 07/19] mm, swap: refactor swapoff and add xswap_destroy
* [PATCH v5 08/19] mm, swap: require zswap for xswap devices
* [PATCH v5 09/19] mm, swap: use a stable id for xswap devices
* [PATCH v5 10/19] mm, swap: let the command line set the xswap device size
* [PATCH v5 11/19] mm, swap: add CONFIG_XSWAP_DEFAULT_MAX
* [PATCH v5 12/19] mm, swap: let swapoff destroy xswap devices by name
* [PATCH v5 13/19] mm, swap: add xswap grow trigger on cluster allocation
* [PATCH v5 14/19] mm, swap: add debugfs counters for xswap
* [PATCH v5 15/19] mm, swap: make xswap cluster_info accesses RCU-safe
* [PATCH v5 16/19] mm, swap: prepare xswap_unmap_clusters for range shrinking
* [PATCH v5 17/19] mm, swap: add xswap shrink trigger and defer it to a workqueue
* [PATCH v5 18/19] mm, swap: do not give an xswap slot to a cgroup that cannot zswap
* [PATCH v5 19/19] mm, swap: skip the overcommit probe when removing xswap

and found the following issue:
BUG: unable to handle kernel paging request in swapoff

Full report is available here:
https://ci.syzbot.org/series/88bad2a7-a1dc-4686-80c1-647e34e90e37

***

BUG: unable to handle kernel paging request in swapoff

tree:      mm-new
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/mm.git
base:      2dc0136b1fdac153434ab02778fcdb32db5d0dae
arch:      amd64
compiler:  Debian clang version 22.1.8 (1~deb13u4), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/5c923c30-8b6d-49b4-8bbb-014cb85737f7/config
syz repro: https://ci.syzbot.org/findings/f14c26d8-d891-4444-9227-d55cbaf2adb7/syz_repro

BUG: unable to handle page fault for address: fffffffffffffffe
#PF: supervisor read access in kernel mode
#PF: error_code(0x0000) - not-present page
PGD ff4b067 P4D ff4b067 PUD ff4d067 PMD 0 
Oops: Oops: 0000 [#1] SMP KASAN PTI
CPU: 1 UID: 0 PID: 5894 Comm: syz.2.19 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:__do_sys_swapoff mm/swapfile.c:3743 [inline]
RIP: 0010:__se_sys_swapoff+0x233/0x610 mm/swapfile.c:3719
Code: 99 90 ff e9 42 ff ff ff e8 2a 99 90 ff eb 6f 4c 89 e0 48 c1 e8 03 42 80 3c 28 00 74 08 4c 89 e7 e8 72 c7 08 00 4c 89 64 24 10 <4d> 8b 24 24 66 43 c7 44 2f 04 00 00 43 c6 44 2f 06 00 4c 89 3c 24
RSP: 0018:ffffc90003d1fde0 EFLAGS: 00010246
RAX: 1fffffffffffffff RBX: 0000200000000000 RCX: c8af1e162af39c00
RDX: 0000000000000000 RSI: fffffffffffffffe RDI: 00000000ffffff9c
RBP: ffffc90003d1fee0 R08: 0000000000000003 R09: 0000000000000000
R10: ffffc90003d1fd40 R11: fffff520007a3faa R12: fffffffffffffffe
R13: dffffc0000000000 R14: fffffffffffffffe R15: 1ffff920007a3fc0
FS:  00007f5ca62c96c0(0000) GS:ffff8882a7806000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: fffffffffffffffe CR3: 00000001023f4000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f5ca53a8f19
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f5ca62c9028 EFLAGS: 00000246 ORIG_RAX: 00000000000000a8
RAX: ffffffffffffffda RBX: 00007f5ca5625fa0 RCX: 00007f5ca53a8f19
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000200000000000
RBP: 00007f5ca5437f6d R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f5ca5626038 R14: 00007f5ca5625fa0 R15: 00007ffce4301208
 </TASK>
Modules linked in:
CR2: fffffffffffffffe
---[ end trace 0000000000000000 ]---
RIP: 0010:__do_sys_swapoff mm/swapfile.c:3743 [inline]
RIP: 0010:__se_sys_swapoff+0x233/0x610 mm/swapfile.c:3719
Code: 99 90 ff e9 42 ff ff ff e8 2a 99 90 ff eb 6f 4c 89 e0 48 c1 e8 03 42 80 3c 28 00 74 08 4c 89 e7 e8 72 c7 08 00 4c 89 64 24 10 <4d> 8b 24 24 66 43 c7 44 2f 04 00 00 43 c6 44 2f 06 00 4c 89 3c 24
RSP: 0018:ffffc90003d1fde0 EFLAGS: 00010246
RAX: 1fffffffffffffff RBX: 0000200000000000 RCX: c8af1e162af39c00
RDX: 0000000000000000 RSI: fffffffffffffffe RDI: 00000000ffffff9c
RBP: ffffc90003d1fee0 R08: 0000000000000003 R09: 0000000000000000
R10: ffffc90003d1fd40 R11: fffff520007a3faa R12: fffffffffffffffe
R13: dffffc0000000000 R14: fffffffffffffffe R15: 1ffff920007a3fc0
FS:  00007f5ca62c96c0(0000) GS:ffff8882a7806000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: fffffffffffffffe CR3: 00000001023f4000 CR4: 00000000000006f0
----------------
Code disassembly (best guess), 3 bytes skipped:
   0:	e9 42 ff ff ff       	jmp    0xffffff47
   5:	e8 2a 99 90 ff       	call   0xff909934
   a:	eb 6f                	jmp    0x7b
   c:	4c 89 e0             	mov    %r12,%rax
   f:	48 c1 e8 03          	shr    $0x3,%rax
  13:	42 80 3c 28 00       	cmpb   $0x0,(%rax,%r13,1)
  18:	74 08                	je     0x22
  1a:	4c 89 e7             	mov    %r12,%rdi
  1d:	e8 72 c7 08 00       	call   0x8c794
  22:	4c 89 64 24 10       	mov    %r12,0x10(%rsp)
* 27:	4d 8b 24 24          	mov    (%r12),%r12 <-- trapping instruction
  2b:	66 43 c7 44 2f 04 00 	movw   $0x0,0x4(%r15,%r13,1)
  32:	00
  33:	43 c6 44 2f 06 00    	movb   $0x0,0x6(%r15,%r13,1)
  39:	4c 89 3c 24          	mov    %r15,(%rsp)


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.
