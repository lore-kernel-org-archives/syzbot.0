Received: from mail-oo1-f70.google.com (mail-oo1-f70.google.com [209.85.161.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73A421E7C23
	for <syzbot@lists.linux.dev>; Sun,  4 Jan 2026 20:29:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767558601; cv=none; b=mFEMzvJ7f+S+I5vpJr6PYaJdLEnX4zsXBiL0FChC7PaimnIZxc2aotcV/pOWtt2dmVfZP/+CA2GIoM9FZFN/OpT0QsQpXr+BgF1R3D+TkDV73lSHFg8g1W7s32MFOqPMkvzXqXHXXolNTC+gNtJSy0lEJZeG/l4TXhvDX2MqLUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767558601; c=relaxed/simple;
	bh=Fj80e7VL+Nl8r4zlLqqndO1ZS+YcFUJOMy2xLIGS9ws=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=CPR8T2SJqkjNJN+r2zE8bIaSlT+9k2efnVXSOgxQv5CwD3xi/VoLUT67Me8JLxAhgXhpavGwNRNAqhkULxIT5WCPJSX1K3yEtBYKNYZHdo5/BTSGjn72/udtvnhAHYKRwoSfzv1vbsmnVuqCY2D32jg9fiZTXUTZWYWfKS6atxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f70.google.com with SMTP id 006d021491bc7-656b7cf5c66so24949175eaf.2
        for <syzbot@lists.linux.dev>; Sun, 04 Jan 2026 12:29:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767558598; x=1768163398;
        h=content-transfer-encoding:cc:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QhWBkw041u/A1qW9wQs+98ya3z4lzPyzzoQ9tK1fXiU=;
        b=Tq0xZtIFY04xdLbCxHr6uS6JmlgXtEihOG3x4lNPoG4WSeK8ScCQrJpYwWmsjbhK4I
         cCLJxhYqlUPSa/UVud/d6X8gihWGciWltmzWdj1MqPJkG0exBp5cyTLDUefpJ0/iedn5
         lnaZuHdaiZATHRuv6tnXkDUD38oq6l7c565pqSmbwf+QZCSSuQCuUmLbeJeINq6SDe+m
         Y5E5O2uEkgBlrILu8hH41C6e7KOLfKbQ5KVmaPEH8lA/CCkuEQ1LkzCkEWkG7mC38RM0
         MP+r+sVO00tqS1e/VvLSFtt4WHxLlAbNY3a8s+z6yzCx2T5zZrdqkfAHjtcAqKVyszQh
         XEAg==
X-Gm-Message-State: AOJu0YxZPb84YvrjDpyyB2W2be2UeVULHFcXWmADZHN5Rxe9tCQHmw02
	+c7hvePru7r+TkrsYvIezMQmtrx3RLEvhm4ruhl32JSHp8/mM+9fvqpWXUryeUnkXbSaN2oVBh0
	BFaUQJ42qbBZh2LlTlvyV8dlhwa6LfqTruwtUEs+5GgwqrW+7fVVwcxpbXwQ=
X-Google-Smtp-Source: AGHT+IE0tQuLpC1uaGLspFVqnr4GjQiLcTWWZB3L+5+2sHgB8Y8DvlpQl9Cs7DvuewPKLH9ivqGWKHu1eMktwm/yEOEer9YnEfeJ
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:1517:b0:65f:1038:130c with SMTP id
 006d021491bc7-65f10381479mr6307123eaf.53.1767558598424; Sun, 04 Jan 2026
 12:29:58 -0800 (PST)
Date: Sun, 04 Jan 2026 12:29:58 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <695acdc6.050a0220.a5285.000b.GAE@google.com>
Subject: [moderation/CI] Re: bpf, test_run: Fix user-memory-access
 vulnerability for LIVE_FRAMES
From: syzbot ci <syzbot+ci86521d821d6029aa@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v1] bpf, test_run: Fix user-memory-access vulnerability for LIVE_FRAMES
https://lore.kernel.org/all/20260104162350.347403-1-kafai.wan@linux.dev
* [PATCH bpf-next 1/2] bpf, test_run: Fix user-memory-access vulnerability =
for LIVE_FRAMES
* [PATCH bpf-next 2/2] selftests/bpf: Add test for xdp_md context with LIVE=
_FRAMES in BPF_PROG_TEST_RUN

and found the following issue:
BUG: missing reserved tailroom

Full report is available here:
https://ci.syzbot.org/series/688d9198-9fed-495e-9113-3d4187428ee3

***

BUG: missing reserved tailroom

tree:      bpf-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/bpf/bpf=
-next.git
base:      a069190b590e108223cd841a1c2d0bfb92230ecc
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251202083448+f68f64eb8130-1~exp=
1~20251202083504.46), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/3375fbfc-d3f8-45a8-8db2-62ac76ebb7b=
4/config
C repro:   https://ci.syzbot.org/findings/37614d32-0f44-4a1c-9822-586c95cfe=
b11/c_repro
syz repro: https://ci.syzbot.org/findings/37614d32-0f44-4a1c-9822-586c95cfe=
b11/syz_repro

------------[ cut here ]------------
XDP_WARN: xdp_update_frame_from_buff(line:414): Driver BUG: missing reserve=
d tailroom
WARNING: net/core/xdp.c:618 at xdp_warn+0x1d/0x40 net/core/xdp.c:618, CPU#1=
: syz.0.17/5990
Modules linked in:
CPU: 1 UID: 0 PID: 5990 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(ful=
l)=20
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16=
.2-1 04/01/2014
RIP: 0010:xdp_warn+0x25/0x40 net/core/xdp.c:618
Code: 90 90 90 90 90 f3 0f 1e fa 41 57 41 56 53 89 d3 49 89 f6 49 89 ff e8 =
da 83 63 f8 48 8d 3d e3 de 70 06 4c 89 f6 89 da 4c 89 f9 <67> 48 0f b9 3a 5=
b 41 5e 41 5f c3 cc cc cc cc cc 66 66 2e 0f 1f 84
RSP: 0018:ffffc90004427580 EFLAGS: 00010293
RAX: ffffffff895fc996 RBX: 000000000000019e RCX: ffffffff8c94c7e0
RDX: 000000000000019e RSI: ffffffff8da38c06 RDI: ffffffff8fd0a880
RBP: 0000000000000f68 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffff8881b4ae3ec0
R13: ffff8881b4ae3198 R14: ffffffff8da38c06 R15: ffffffff8c94c7e0
FS:  000055555699b500(0000) GS:ffff8882a9a1f000(0000) knlGS:000000000000000=
0
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000001b30463fff CR3: 0000000175022000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 xdp_update_frame_from_buff include/net/xdp.h:414 [inline]
 xdp_test_run_init_page+0x482/0x590 net/bpf/test_run.c:143
 page_pool_set_pp_info net/core/page_pool.c:716 [inline]
 __page_pool_alloc_netmems_slow+0x33c/0x710 net/core/page_pool.c:631
 page_pool_alloc_netmems net/core/page_pool.c:667 [inline]
 page_pool_alloc_pages+0xe6/0x1f0 net/core/page_pool.c:675
 page_pool_dev_alloc_pages include/net/page_pool/helpers.h:96 [inline]
 xdp_test_run_batch net/bpf/test_run.c:294 [inline]
 bpf_test_run_xdp_live+0x714/0x1cf0 net/bpf/test_run.c:378
 bpf_prog_test_run_xdp+0x7d2/0x1120 net/bpf/test_run.c:1387
 bpf_prog_test_run+0x2c7/0x340 kernel/bpf/syscall.c:4698
 __sys_bpf+0x643/0x950 kernel/bpf/syscall.c:6220
 __do_sys_bpf kernel/bpf/syscall.c:6315 [inline]
 __se_sys_bpf kernel/bpf/syscall.c:6313 [inline]
 __x64_sys_bpf+0x7c/0x90 kernel/bpf/syscall.c:6313
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xf0/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f389319acb9
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 =
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff f=
f 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffc43c08dd8 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
RAX: ffffffffffffffda RBX: 00007f3893405fa0 RCX: 00007f389319acb9
RDX: 0000000000000048 RSI: 0000200000000600 RDI: 000000000000000a
RBP: 00007f3893208bf7 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f3893405fac R14: 00007f3893405fa0 R15: 00007f3893405fa0
 </TASK>
----------------
Code disassembly (best guess):
   0:	90                   	nop
   1:	90                   	nop
   2:	90                   	nop
   3:	90                   	nop
   4:	90                   	nop
   5:	f3 0f 1e fa          	endbr64
   9:	41 57                	push   %r15
   b:	41 56                	push   %r14
   d:	53                   	push   %rbx
   e:	89 d3                	mov    %edx,%ebx
  10:	49 89 f6             	mov    %rsi,%r14
  13:	49 89 ff             	mov    %rdi,%r15
  16:	e8 da 83 63 f8       	call   0xf86383f5
  1b:	48 8d 3d e3 de 70 06 	lea    0x670dee3(%rip),%rdi        # 0x670df05
  22:	4c 89 f6             	mov    %r14,%rsi
  25:	89 da                	mov    %ebx,%edx
  27:	4c 89 f9             	mov    %r15,%rcx
* 2a:	67 48 0f b9 3a       	ud1    (%edx),%rdi <-- trapping instruction
  2f:	5b                   	pop    %rbx
  30:	41 5e                	pop    %r14
  32:	41 5f                	pop    %r15
  34:	c3                   	ret
  35:	cc                   	int3
  36:	cc                   	int3
  37:	cc                   	int3
  38:	cc                   	int3
  39:	cc                   	int3
  3a:	66                   	data16
  3b:	66                   	data16
  3c:	2e                   	cs
  3d:	0f                   	.byte 0xf
  3e:	1f                   	(bad)
  3f:	84                   	.byte 0x84


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[aleksander.lobakin@intel.com andrii@kernel.org ast@kernel.org bpf@vger.ker=
nel.org daniel@iogearbox.net davem@davemloft.net dddddd@hust.edu.cn dzm91@h=
ust.edu.cn eddyz87@gmail.com edumazet@google.com haoluo@google.com hawk@ker=
nel.org horms@kernel.org john.fastabend@gmail.com jolsa@kernel.org kafai.wa=
n@linux.dev kpsingh@kernel.org kuba@kernel.org linux-kernel@vger.kernel.org=
 linux-kselftest@vger.kernel.org m202472210@hust.edu.cn martin.lau@linux.de=
v netdev@vger.kernel.org pabeni@redhat.com sdf@fomichev.me shuah@kernel.org=
 song@kernel.org toke@redhat.com yonghong.song@linux.dev]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

