Received: from mail-ot1-f72.google.com (mail-ot1-f72.google.com [209.85.210.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43DA2194C95
	for <syzbot@lists.linux.dev>; Wed, 18 Feb 2026 07:12:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771398754; cv=none; b=sNon9U7OMpkMLqkJ/iNkC0FDv2Y6RjpzhhDL+E8EIxq0RIzpuwKJAQOpqomXrxXxuhae+v2Z3Y4BP+yuJjLd+ltmyekbc5jbKNeucIhctjkkvdfA2PcDtoof3/LqXGc6c4BxX/vDSujIgwY0GqVMTAhlSJ+B2oHgozfqaOV52LU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771398754; c=relaxed/simple;
	bh=kW9MTIX2TovQhe5lev75i+lLc6qpcnORsNWqFjRZHz8=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=nACZI+1EowF9uvVcyBPXMUFT+2ax1FG8nlze+eC4aWue/DjC76UxIbVMweRt4Fl6MhvQIHOACzmJTZRucq0zQ1F9zficfbn11ZAbQT5VL+q39MKZuCqZWEnhOxPZP6LNjQMwcMk6aiQaV0svu8tsZ8mZd7PD9jCNV934MyypsFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.210.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f72.google.com with SMTP id 46e09a7af769-7d4c6bb79a5so17321541a34.0
        for <syzbot@lists.linux.dev>; Tue, 17 Feb 2026 23:12:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771398752; x=1772003552;
        h=cc:to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=eQQZgMciuXLCBtMstpmsTkro6c+WSOtMJZq4DVc+DO0=;
        b=PvNyWpEarixDEsUQMDkDpnfKzNBFpjy7TVVv7To7BWStfQ4phQVAu32PL3Bv83jXUS
         jGw16cCcpO2mRGxPtohtZHo144q9HRJvQXAXbYInabu2HsBaIwKcnDUmy8ZSgkFCQ2+u
         0TfMeSLg3+NFnDYmrHOIVWoDtLV8aArwusxb8RU4RDBvxoTXXQHfrWSuuc37KJu+r45z
         gxydG1i86Kyimcr0N+Apa/jEDf8BWiFHIEpEWtpn7K3LL2YHEWIlkYDzN+D9CiHtu4or
         OvDO++953ufu0JxPPzQ7pQVHZx5YoHkynZaTCfjX06DOY6fCtWciYCWL8Nht9g572ibH
         MTMQ==
X-Gm-Message-State: AOJu0YwSWwntc9LBSc421L6PDWdYRzBfa6KKgKtVNUmCRz9PKHkBENiU
	MBoIgXwzH7j5d7xMd/FO8oCU7ydJ8gQsIbqg92VrmnNNcoL0rS5oicejp9J8WmjRJ0XD0oSKs6P
	TdKrw/7tiN+b2EAqNxCxxuAuTq4ggIcf2BdnTOR7TzbrxURSDFIsFOe4xjdI=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:4687:b0:662:f42e:7cfe with SMTP id
 006d021491bc7-6785b1c28acmr5376184eaf.54.1771398752139; Tue, 17 Feb 2026
 23:12:32 -0800 (PST)
Date: Tue, 17 Feb 2026 23:12:32 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69956660.a70a0220.2c38d7.0116.GAE@google.com>
Subject: [moderation/CI] Re: io_uring: add kernel-managed buffer rings
From: syzbot ci <syzbot+ci1a95bed2e5ad3303@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v2] io_uring: add kernel-managed buffer rings
https://lore.kernel.org/all/20260218025207.1425553-1-joannelkoong@gmail.com
* [PATCH v2 1/9] io_uring/memmap: chunk allocations in io_region_allocate_pages()
* [PATCH v2 2/9] io_uring/kbuf: add support for kernel-managed buffer rings
* [PATCH v2 3/9] io_uring/kbuf: support kernel-managed buffer rings in buffer selection
* [PATCH v2 4/9] io_uring/kbuf: add buffer ring pinning/unpinning
* [PATCH v2 5/9] io_uring/kbuf: return buffer id in buffer selection
* [PATCH v2 6/9] io_uring/kbuf: add recycling for kernel managed buffer rings
* [PATCH v2 7/9] io_uring/kbuf: add io_uring_is_kmbuf_ring()
* [PATCH v2 8/9] io_uring/kbuf: export io_ring_buffer_select()
* [PATCH v2 9/9] io_uring/cmd: set selected buffer index in __io_uring_cmd_done()

and found the following issue:
general protection fault in io_remove_buffers_legacy

Full report is available here:
https://ci.syzbot.org/series/ddeaf464-c69b-4166-b0cf-53c9d51e4820

***

general protection fault in io_remove_buffers_legacy

tree:      torvalds
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvalds/linux
base:      2961f841b025fb234860bac26dfb7fa7cb0fb122
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/ab5ad5aa-2757-4d66-a2c5-391a8417535d/config
C repro:   https://ci.syzbot.org/findings/061747e2-36f1-499b-ac34-38cefffbce63/c_repro
syz repro: https://ci.syzbot.org/findings/061747e2-36f1-499b-ac34-38cefffbce63/syz_repro

Oops: general protection fault, probably for non-canonical address 0xdffffc0000000001: 0000 [#1] SMP KASAN PTI
KASAN: null-ptr-deref in range [0x0000000000000008-0x000000000000000f]
CPU: 1 UID: 0 PID: 5967 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:__list_del_entry_valid_or_report+0x25/0x190 lib/list_debug.c:49
Code: 90 90 90 90 90 f3 0f 1e fa 41 57 41 56 41 55 41 54 53 48 89 fb 49 bd 00 00 00 00 00 fc ff df 48 83 c7 08 48 89 f8 48 c1 e8 03 <42> 80 3c 28 00 74 05 e8 df 8c 77 fd 4c 8b 7b 08 48 89 d8 48 c1 e8
RSP: 0018:ffffc900040a7b68 EFLAGS: 00010202
RAX: 0000000000000001 RBX: 0000000000000000 RCX: 1ffff11035ee2732
RDX: 1ffff11035ee2730 RSI: 00000000ffffffff RDI: 0000000000000008
RBP: dffffc0000000000 R08: ffff8881af7139b7 R09: 0000000000000000
R10: ffff8881af7139a0 R11: ffffed1035ee2737 R12: ffff8881af713980
R13: dffffc0000000000 R14: 00000000ffffffff R15: 0000000000000000
FS:  0000555560587500(0000) GS:ffff8882a9466000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000200000001000 CR3: 0000000175cd2000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 __list_del_entry_valid include/linux/list.h:132 [inline]
 __list_del_entry include/linux/list.h:223 [inline]
 list_del include/linux/list.h:237 [inline]
 io_remove_buffers_legacy+0x139/0x310 io_uring/kbuf.c:533
 io_put_bl+0x62/0x120 io_uring/kbuf.c:548
 io_register_pbuf_ring+0x6c0/0x7d0 io_uring/kbuf.c:855
 __io_uring_register io_uring/register.c:838 [inline]
 __do_sys_io_uring_register io_uring/register.c:1024 [inline]
 __se_sys_io_uring_register+0xc3e/0x19a0 io_uring/register.c:1001
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f056859bf79
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fffd8dcfaf8 EFLAGS: 00000246 ORIG_RAX: 00000000000001ab
RAX: ffffffffffffffda RBX: 00007f0568815fa0 RCX: 00007f056859bf79
RDX: 0000200000000040 RSI: 0000000000000016 RDI: 0000000000000004
RBP: 00007f05686327e0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000001 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f0568815fac R14: 00007f0568815fa0 R15: 00007f0568815fa0
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:__list_del_entry_valid_or_report+0x25/0x190 lib/list_debug.c:49
Code: 90 90 90 90 90 f3 0f 1e fa 41 57 41 56 41 55 41 54 53 48 89 fb 49 bd 00 00 00 00 00 fc ff df 48 83 c7 08 48 89 f8 48 c1 e8 03 <42> 80 3c 28 00 74 05 e8 df 8c 77 fd 4c 8b 7b 08 48 89 d8 48 c1 e8
RSP: 0018:ffffc900040a7b68 EFLAGS: 00010202
RAX: 0000000000000001 RBX: 0000000000000000 RCX: 1ffff11035ee2732
RDX: 1ffff11035ee2730 RSI: 00000000ffffffff RDI: 0000000000000008
RBP: dffffc0000000000 R08: ffff8881af7139b7 R09: 0000000000000000
R10: ffff8881af7139a0 R11: ffffed1035ee2737 R12: ffff8881af713980
R13: dffffc0000000000 R14: 00000000ffffffff R15: 0000000000000000
FS:  0000555560587500(0000) GS:ffff8882a9466000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f25f1e17095 CR3: 0000000175cd2000 CR4: 00000000000006f0
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
   d:	41 55                	push   %r13
   f:	41 54                	push   %r12
  11:	53                   	push   %rbx
  12:	48 89 fb             	mov    %rdi,%rbx
  15:	49 bd 00 00 00 00 00 	movabs $0xdffffc0000000000,%r13
  1c:	fc ff df
  1f:	48 83 c7 08          	add    $0x8,%rdi
  23:	48 89 f8             	mov    %rdi,%rax
  26:	48 c1 e8 03          	shr    $0x3,%rax
* 2a:	42 80 3c 28 00       	cmpb   $0x0,(%rax,%r13,1) <-- trapping instruction
  2f:	74 05                	je     0x36
  31:	e8 df 8c 77 fd       	call   0xfd778d15
  36:	4c 8b 7b 08          	mov    0x8(%rbx),%r15
  3a:	48 89 d8             	mov    %rbx,%rax
  3d:	48                   	rex.W
  3e:	c1                   	.byte 0xc1
  3f:	e8                   	.byte 0xe8


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[asml.silence@gmail.com axboe@kernel.dk bernd@bsbernd.com csander@purestorage.com hch@infradead.org io-uring@vger.kernel.org joannelkoong@gmail.com]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

