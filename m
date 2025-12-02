Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com [209.85.167.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AA5F2E0407
	for <syzbot@lists.linux.dev>; Tue,  2 Dec 2025 19:40:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764704452; cv=none; b=jYH/44VHMmb188EaOPDKgv1uS34Q+oCEuAZIRwunywL7A4rcF8bOeaCvfM9TZYHjrAsvvZL2pg1S4WcbxTzwgeLUpU0KLvVk2w0EYgJ5Hp0cKIRK3CxFsnb2tQYa6tRyoffu4Og4gvX22pgzm2vUbruYKKwCQd8pohtYfI62/iU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764704452; c=relaxed/simple;
	bh=yEP0uajNhsmwfLZ+l5LYHBsoefXCT9T5M+G0BdhNZHw=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=dLrOygltWdtbsYmWOyX+iEXwgvOWOwNaxiIBybkrk858LSoSKK1C0A0Yn4fCJ31RXcqGFRK1IovUlBo2xV/YDQT/+jQogouuMavDrMRdxWsJTlmb/khkSWK6IOTrHvSyTQKvVfRZVjQX2T+LcBU6x6uolLxyU3qSFhatyS6D5c4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f199.google.com with SMTP id 5614622812f47-44fe73611fdso4922299b6e.0
        for <syzbot@lists.linux.dev>; Tue, 02 Dec 2025 11:40:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764704449; x=1765309249;
        h=content-transfer-encoding:cc:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PtvF2+18v3YeqyB8kw9LLjhMlnXQ5Itg0+yPMmWxWpI=;
        b=YlREPKnW11yZWMO/nmEpUOoiEb+6BtShTY34ePkJPAssBCLoEOGWeIaE8/qVFm6QXc
         5dSUsPWOkBQCK9Z/L29HnKhQlaioYfPhREGvILqRTqoetoJ0ke7lZWK9nbBmw9dmelH9
         0hwNz9R+GGBCd8uzgsakqEHcTvLfrBm2WnWDj27/vqxJuyvKLMWInOpB9yxPHustUVJp
         x6jLsEd+LG2gPBVrd9E+A58YxaR0DBCgRpYzHB//8LNywGh0AO6/SiF+Xng46Csyywb5
         yfBKC+ZM+gZ6fnMIE174HIOsgPQaN+Gycx93cpmVARZi4ZJ6+/sN6ty0xDgnnmKXx1jK
         KbXw==
X-Gm-Message-State: AOJu0YwCPRm6gWlS5ALu6HJUvj1VFthfUjLUVKcsBa5kVOb0tP8cGzTR
	ZIZLzc2PXXjxMS+vcXaaUc6aBqfoug6TFw6d555vHvmjYCifxSB0ROPjf7hbkIDaFbPufV9GKSC
	gEylztfl+riKP/DPZUH7hK5dVNbbG/6GDMVBmMOHXV4dU6dF+tWpIimO2mis=
X-Google-Smtp-Source: AGHT+IEzNwgkFNMoVkxv9hYurEQsju9kPAJfilcZuo75YxWmsJXS0h+3sNHIK8m1KeRG0WQpw4nZZ46MThsdwa+/nQT4+X109Rjg
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:1b0b:b0:44f:8f02:c75a with SMTP id
 5614622812f47-45112876793mr21425117b6e.1.1764704449570; Tue, 02 Dec 2025
 11:40:49 -0800 (PST)
Date: Tue, 02 Dec 2025 11:40:49 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <692f40c1.a70a0220.d98e3.01a2.GAE@google.com>
Subject: [moderation/CI] Re: bpf: Fix unintended eviction when updating lru
 hash maps
From: syzbot ci <syzbot+ci0f9355f4155e7a2e@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v1] bpf: Fix unintended eviction when updating lru hash maps
https://lore.kernel.org/all/20251202153032.10118-1-leon.hwang@linux.dev
* [PATCH bpf-next 1/3] bpf: Avoid unintended eviction when updating lru_has=
h maps
* [PATCH bpf-next 2/3] bpf: Avoid unintended eviction when updating lru_per=
cpu_hash maps
* [PATCH bpf-next 3/3] selftests/bpf: Add tests to verify no unintended evi=
ction when updating lru hash maps

and found the following issue:
general protection fault in bpf_lru_push_free

Full report is available here:
https://ci.syzbot.org/series/64db9547-852d-4c56-a3a1-3d18f254330c

***

general protection fault in bpf_lru_push_free

tree:      bpf-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/bpf/bpf=
-next.git
base:      5262cb23393f7e86a64d1a45eeaa8a6f99f03d10
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp=
1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/702a7a8c-4385-4089-a777-8b47155f879=
4/config
C repro:   https://ci.syzbot.org/findings/0cffd810-925f-42f4-88d2-8d21195f3=
41e/c_repro
syz repro: https://ci.syzbot.org/findings/0cffd810-925f-42f4-88d2-8d21195f3=
41e/syz_repro

Oops: general protection fault, probably for non-canonical address 0xdffffc=
0000000004: 0000 [#1] SMP KASAN PTI
KASAN: null-ptr-deref in range [0x0000000000000020-0x0000000000000027]
CPU: 0 UID: 0 PID: 5953 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(ful=
l)=20
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16=
.2-1 04/01/2014
RIP: 0010:bpf_percpu_lru_push_free kernel/bpf/bpf_lru_list.c:539 [inline]
RIP: 0010:bpf_lru_push_free+0x6e/0xbb0 kernel/bpf/bpf_lru_list.c:551
Code: 01 0f 85 e4 00 00 00 4c 89 f0 48 c1 e8 03 80 3c 28 00 74 08 4c 89 f7 =
e8 c0 82 42 00 4d 8b 3e 4c 8d 73 10 4c 89 f0 48 c1 e8 03 <0f> b6 04 28 84 c=
0 0f 85 5b 09 00 00 45 0f b7 36 bf 08 00 00 00 44
RSP: 0018:ffffc900046d7b48 EFLAGS: 00010202
RAX: 0000000000000004 RBX: 0000000000000010 RCX: ffff888112941d00
RDX: 0000000000000000 RSI: 0000000000000010 RDI: ffff888117c02300
RBP: dffffc0000000000 R08: ffffffff8f7cee77 R09: 1ffffffff1ef9dce
R10: dffffc0000000000 R11: fffffbfff1ef9dcf R12: 0000000000000002
R13: 00000000fffffffe R14: 0000000000000020 R15: 0000607d55cf6a80
FS:  000055555edc7500(0000) GS:ffff88818eb38000(0000) knlGS:000000000000000=
0
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000001b2ed63fff CR3: 000000010bca0000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 htab_lru_push_free kernel/bpf/hashtab.c:1183 [inline]
 htab_lru_map_update_elem+0x33e/0xa90 kernel/bpf/hashtab.c:1266
 bpf_map_update_value+0x751/0x920 kernel/bpf/syscall.c:294
 map_update_elem+0x355/0x4b0 kernel/bpf/syscall.c:1817
 __sys_bpf+0x619/0x860 kernel/bpf/syscall.c:6150
 __do_sys_bpf kernel/bpf/syscall.c:6272 [inline]
 __se_sys_bpf kernel/bpf/syscall.c:6270 [inline]
 __x64_sys_bpf+0x7c/0x90 kernel/bpf/syscall.c:6270
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fe41118f7c9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 =
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff f=
f 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffcd4179988 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
RAX: ffffffffffffffda RBX: 00007fe4113e5fa0 RCX: 00007fe41118f7c9
RDX: 0000000000000020 RSI: 0000200000000800 RDI: 0000000000000002
RBP: 00007fe4111f297f R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fe4113e5fa0 R14: 00007fe4113e5fa0 R15: 0000000000000003
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:bpf_percpu_lru_push_free kernel/bpf/bpf_lru_list.c:539 [inline]
RIP: 0010:bpf_lru_push_free+0x6e/0xbb0 kernel/bpf/bpf_lru_list.c:551
Code: 01 0f 85 e4 00 00 00 4c 89 f0 48 c1 e8 03 80 3c 28 00 74 08 4c 89 f7 =
e8 c0 82 42 00 4d 8b 3e 4c 8d 73 10 4c 89 f0 48 c1 e8 03 <0f> b6 04 28 84 c=
0 0f 85 5b 09 00 00 45 0f b7 36 bf 08 00 00 00 44
RSP: 0018:ffffc900046d7b48 EFLAGS: 00010202
RAX: 0000000000000004 RBX: 0000000000000010 RCX: ffff888112941d00
RDX: 0000000000000000 RSI: 0000000000000010 RDI: ffff888117c02300
RBP: dffffc0000000000 R08: ffffffff8f7cee77 R09: 1ffffffff1ef9dce
R10: dffffc0000000000 R11: fffffbfff1ef9dcf R12: 0000000000000002
R13: 00000000fffffffe R14: 0000000000000020 R15: 0000607d55cf6a80
FS:  000055555edc7500(0000) GS:ffff88818eb38000(0000) knlGS:000000000000000=
0
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000001b2ed63fff CR3: 000000010bca0000 CR4: 00000000000006f0
----------------
Code disassembly (best guess):
   0:	01 0f                	add    %ecx,(%rdi)
   2:	85 e4                	test   %esp,%esp
   4:	00 00                	add    %al,(%rax)
   6:	00 4c 89 f0          	add    %cl,-0x10(%rcx,%rcx,4)
   a:	48 c1 e8 03          	shr    $0x3,%rax
   e:	80 3c 28 00          	cmpb   $0x0,(%rax,%rbp,1)
  12:	74 08                	je     0x1c
  14:	4c 89 f7             	mov    %r14,%rdi
  17:	e8 c0 82 42 00       	call   0x4282dc
  1c:	4d 8b 3e             	mov    (%r14),%r15
  1f:	4c 8d 73 10          	lea    0x10(%rbx),%r14
  23:	4c 89 f0             	mov    %r14,%rax
  26:	48 c1 e8 03          	shr    $0x3,%rax
* 2a:	0f b6 04 28          	movzbl (%rax,%rbp,1),%eax <-- trapping instruct=
ion
  2e:	84 c0                	test   %al,%al
  30:	0f 85 5b 09 00 00    	jne    0x991
  36:	45 0f b7 36          	movzwl (%r14),%r14d
  3a:	bf 08 00 00 00       	mov    $0x8,%edi
  3f:	44                   	rex.R


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[andrii@kernel.org ast@kernel.org bpf@vger.kernel.org daniel@iogearbox.net =
davem@davemloft.net eddyz87@gmail.com haoluo@google.com john.fastabend@gmai=
l.com jolsa@kernel.org kernel-patches-bot@fb.com kpsingh@kernel.org leon.hw=
ang@linux.dev linux-kernel@vger.kernel.org linux-kselftest@vger.kernel.org =
martin.lau@linux.dev sdf@fomichev.me shuah@kernel.org skb99@linux.ibm.com s=
ong@kernel.org yonghong.song@linux.dev]

If the report looks fine to you, reply with:
#syz upstream

