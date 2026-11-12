Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.160.72
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794449649;
	b=eLOFYY1EI7l2/0wGp7TcL6q4R3pTW6UHk5UalP5qOLz628NEkA+MIQq7sQlnoKpH0orT
	 gBL+ZB5T1rhnfVz+p1h7ujjXuuuyR5uMSoWFS0cj9VuE5Hqm8pW8SxEImZ31HwaU0Xs2J
	 97nnTRDWykeuHo7ph26Op+qGOQBiV206cUw1yZI8tRh+PzT3arW1AKVFfKd5Rbx9ll7pS
	 F0TByXUBgvvSP1uLcvl9MLOIwRLOReAgO/fysKiYlN9/yjcHjIZxDp5uT2009PKZe2kJ+
	 b38w5CuqRwM+N7Ro+CxNciipyW6NG5FK6yYnoQzzHUfT3s9NqwQ27FMYzd7/nZKKTjQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794449649;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 MIME-Version:X-Received:Date:X-Google-Appengine-App-Id:
	 X-Google-Appengine-App-Id-Alias:Message-ID:Subject:From:To:Cc:
	 Content-Type:Content-Transfer-Encoding;
	bh=Y7KPOBeo6TOkRiQB+k+oFyTi3Epfx2jLdQbNXZy8KF4=;
	b=QfAt2AdLGDGzkJfGu8ed98nzNa9qzM1pk9XccTk1niMN2ozXCXviKqZmHGL8uWz6M+JW
	 SvnleJ0b1C6Xe49NAQ+LdqgIHe4ZhImdYdicdIpxdzYpeEkq8s3+3EORSZDntSmNao8hx
	 6VX+O9wQxBv/8eY9zm9DAyMTcylnczHoE3JAdeZiJRFaWNXzYveX6801eInsOLuxJfXNI
	 cjqlC2edyaLQApcFG9qlQ4zy4uKxCsVDcWP/Bc9jzGnIgseEr8ml+qz5C+Yx1QGn5X7Wv
	 /+gOoOSdk4+rV9qloOBFZtxFDmjOoEeDyf/eSVJ4Qswp8Aa99t3Ihl9YoH1q/IzWxmA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=syzkaller.appspotmail.com;
	spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	arc=none smtp.remote-ip=209.85.160.72
Received: from mail-oa1-f72.google.com (mail-oa1-f72.google.com [209.85.160.72])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B506B606A321
	for <syzbot@lists.linux.dev>; Thu, 12 Nov 2026 02:14:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B506B606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oa1-f72.google.com with SMTP id 586e51a60fabf-4ae40674bd0so1314672fac.2
        for <syzbot@lists.linux.dev>; Wed, 11 Nov 2026 18:14:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794449647; x=1795054447;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:date:mime-version:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Y7KPOBeo6TOkRiQB+k+oFyTi3Epfx2jLdQbNXZy8KF4=;
        b=EX05rp64OUQkjHDIk4rn6Ry4HPVUkPX6aZOLEXoVRaKasxBoAKy4rFPZzP+fHxtQUj
         RsWao7XaVYh9lxEdfXzRqck3QwSNm3Tf/Kye1MC1dwEAcjOsuzZjcANXYA+wTknr/55F
         GnPeK5BlP05QtmTObs+zARdar27Lia0q6vL3R4BBRmDmJhdc2K7lw04v3KnrlBRBKe0z
         diiDnrQDRaDsXWTLovId8gWqcAAFX8wy3llBbPS8CsmVYAlW0qdzLY1BQyRHB6Z1gsrM
         otwPEt1bZEcuSBdTC9jLk12OT8T3u51IKKVAzvcEul1R9LOY8pQ75EicMS8dRbGyG8Py
         0lJw==
X-Gm-Message-State: APuU4Z/axDX/k9tLFPdltvwEjn0w6Kw4tLp5YN4H9io3A0GjH47Wm97z
	ZeN/ua1/mvniFJQCi0XJViQN8XRH7dGj8itgHUGZoo1YROcROAIlSCGMn8HVCKXVhZaXxshJwmP
	mAalMljlAnkvyUxZm14qd5XEfRO7MTd+QorZvCwzemso/JMiZYMwumYZdgmI=
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Post: <mailto:syzbot@lists.linux.dev>
List-Help: <mailto:syzbot+help@lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
List-Owner: <mailto:syzbot+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-Received: by 2002:a05:6808:f13:b0:4fb:ac9b:b084 with SMTP id
 5614622812f47-56b96ce7f59mr3761108b6e.37.1794449647673; Wed, 11 Nov 2026
 18:14:07 -0800 (PST)
Date: Wed, 11 Nov 2026 18:14:07 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6af520ef.4fb38a5b.96541.0002.GAE@google.com>
Subject: [moderation/CI] Re: mm, swap: extendable swap devices (xswap phase I)
From: syzbot ci <syzbot+ci959f1a5b24994e7e@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v5] mm, swap: extendable swap devices (xswap phase I)
https://lore.kernel.org/all/20261109055455.536925-1-baoquan.he@linux.dev
* [PATCH v5 01/19] mm: xswap support for zswap
* [PATCH v5 02/19] mm, swap: refactor free_swap_cluster_info to take swap_i=
nfo_struct
* [PATCH v5 03/19] mm, swap: add VM_SPARSE cluster-array helpers for xswap
* [PATCH v5 04/19] mm, swap: use a VM_SPARSE cluster array for xswap device=
s
* [PATCH v5 05/19] mm, swap: widen swap_info_struct max/pages to unsigned l=
ong
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
* [PATCH v5 16/19] mm, swap: prepare xswap_unmap_clusters for range shrinki=
ng
* [PATCH v5 17/19] mm, swap: add xswap shrink trigger and defer it to a wor=
kqueue
* [PATCH v5 18/19] mm, swap: do not give an xswap slot to a cgroup that can=
not zswap
* [PATCH v5 19/19] mm, swap: skip the overcommit probe when removing xswap

and found the following issue:
BUG: unable to handle kernel paging request in swapoff

Full report is available here:
https://ci.syzbot.org/series/88bad2a7-a1dc-4686-80c1-647e34e90e37

***

BUG: unable to handle kernel paging request in swapoff

tree:      mm-new
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/mm=
.git
base:      2dc0136b1fdac153434ab02778fcdb32db5d0dae
arch:      amd64
compiler:  Debian clang version 22.1.8 (1~deb13u4), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/5c923c30-8b6d-49b4-8bbb-014cb85737f=
7/config
syz repro: https://ci.syzbot.org/findings/f14c26d8-d891-4444-9227-d55cbaf2a=
db7/syz_repro

BUG: unable to handle page fault for address: fffffffffffffffe
#PF: supervisor read access in kernel mode
#PF: error_code(0x0000) - not-present page
PGD ff4b067 P4D ff4b067 PUD ff4d067 PMD 0=20
Oops: Oops: 0000 [#1] SMP KASAN PTI
CPU: 1 UID: 0 PID: 5894 Comm: syz.2.19 Not tainted syzkaller #0 PREEMPT(ful=
l)=20
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16=
.2-1 04/01/2014
RIP: 0010:__do_sys_swapoff mm/swapfile.c:3743 [inline]
RIP: 0010:__se_sys_swapoff+0x233/0x610 mm/swapfile.c:3719
Code: 99 90 ff e9 42 ff ff ff e8 2a 99 90 ff eb 6f 4c 89 e0 48 c1 e8 03 42 =
80 3c 28 00 74 08 4c 89 e7 e8 72 c7 08 00 4c 89 64 24 10 <4d> 8b 24 24 66 4=
3 c7 44 2f 04 00 00 43 c6 44 2f 06 00 4c 89 3c 24
RSP: 0018:ffffc90003d1fde0 EFLAGS: 00010246
RAX: 1fffffffffffffff RBX: 0000200000000000 RCX: c8af1e162af39c00
RDX: 0000000000000000 RSI: fffffffffffffffe RDI: 00000000ffffff9c
RBP: ffffc90003d1fee0 R08: 0000000000000003 R09: 0000000000000000
R10: ffffc90003d1fd40 R11: fffff520007a3faa R12: fffffffffffffffe
R13: dffffc0000000000 R14: fffffffffffffffe R15: 1ffff920007a3fc0
FS:  00007f5ca62c96c0(0000) GS:ffff8882a7806000(0000) knlGS:000000000000000=
0
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: fffffffffffffffe CR3: 00000001023f4000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f5ca53a8f19
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 =
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff f=
f 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
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
Code: 99 90 ff e9 42 ff ff ff e8 2a 99 90 ff eb 6f 4c 89 e0 48 c1 e8 03 42 =
80 3c 28 00 74 08 4c 89 e7 e8 72 c7 08 00 4c 89 64 24 10 <4d> 8b 24 24 66 4=
3 c7 44 2f 04 00 00 43 c6 44 2f 06 00 4c 89 3c 24
RSP: 0018:ffffc90003d1fde0 EFLAGS: 00010246
RAX: 1fffffffffffffff RBX: 0000200000000000 RCX: c8af1e162af39c00
RDX: 0000000000000000 RSI: fffffffffffffffe RDI: 00000000ffffff9c
RBP: ffffc90003d1fee0 R08: 0000000000000003 R09: 0000000000000000
R10: ffffc90003d1fd40 R11: fffff520007a3faa R12: fffffffffffffffe
R13: dffffc0000000000 R14: fffffffffffffffe R15: 1ffff920007a3fc0
FS:  00007f5ca62c96c0(0000) GS:ffff8882a7806000(0000) knlGS:000000000000000=
0
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

The email will later be sent to:
[akpm@linux-foundation.org baohua@kernel.org baoquan.he@linux.dev chengming=
.zhou@linux.dev chentao@kylinos.cn chrisl@kernel.org corbet@lwn.net david@k=
ernel.org hannes@cmpxchg.org hebaoquan@kylinos.cn kasong@tencent.com klaras=
modin@gmail.com kunwu.chan@gmail.com linux-kernel@vger.kernel.org linux-mm@=
kvack.org nphamcs@gmail.com youngjun.park@lge.com]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

