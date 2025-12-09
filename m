Received: from mail-oo1-f72.google.com (mail-oo1-f72.google.com [209.85.161.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AABDB27A93C
	for <syzbot@lists.linux.dev>; Tue,  9 Dec 2025 14:29:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765290561; cv=none; b=SAcZ7rfJTQodrbGBwTeszUJggQI2yHjwy2LWdDlCHowIX4xAQQbxAvAp9/1m/wMqSIMR4QN05be+klpBGi+ralMltGy+QhDIdg+vauTvyPDaY7flOb4+CSP18n8YBx0YfSof6ONl03+PuJrdXuucF4xzse6vTFQVFY/zULywaPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765290561; c=relaxed/simple;
	bh=T0G52xhxUV+hYN4E35qF6scATXQaRtY2ha70EFkuzEw=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=IWGaHKaXjnUxdrHx+cMEKZ8HQVgn0DU6uMWm4Nri19GRxfwjcp+2qn+caw6UKvYevjAVMzSHYlcwicZsNKKBk34tEAo2DGTRs8wyeX6gLhhskV0gov7vLx+XpPMXYm2oWIkagKcW7pKh//9BcEBnpCnybRE0a/fceXGFCBvr42k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f72.google.com with SMTP id 006d021491bc7-6574d564a9eso7524321eaf.2
        for <syzbot@lists.linux.dev>; Tue, 09 Dec 2025 06:29:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765290559; x=1765895359;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cYysQufbw2nCVl6oggUjelGPf4Gr2nSJlqFfZmaYsc0=;
        b=NEuqEXubwmIJEED9XCXxiY+fzSc+b3RVLvRT2XyslPgZaBvwuuOjoH4P479j9m2nl2
         d2YOH59l92WyNIDoORpX0UERK/nJ2ngpYFlXyyNpNXPWYhYLJchmWfVBU2lqwQX+GxhJ
         dkFVVA+IM54GmknHIw0itq/Dg7VBkaS1DjOWZfEc3gxwHO3VI+oUXYJsuP5tpXJMRot9
         2z2rnOxeNREonM3saKlPQ2DTOFhyJWCZsOpn8hO56hwTyAr9YnYCPwQueuVzKcjubaQx
         aachepMv3vKJWUzMy+3kPJfOrD1Y8vDHxA6qAR/4c2kyiXLylcwPO2z79yhqE+w7czwk
         xCkA==
X-Gm-Message-State: AOJu0Yx5u/JiIqrLHuUJmyulCDIjV7irtRDa4tUOCUK9XAL+aAbFJ4Va
	XxPpJ3TzfDlxG6R95uV9ExuhsxLuFbWMAQeoO5ay5POx3CuWgXu/HSEV1pdsWQ/UVQIN5EhRK9C
	uymyDkx7sguiJ6IMnHjLGQow87MBbCOcT4mU00xSVFavUEmuWuVczL3t8PSo=
X-Google-Smtp-Source: AGHT+IEatLqMbS9wA0XrZ4QZ0mXraxrZAAaImbAlRgVX00IaRbeJeNur+JjISBk2uuFxuF1VO63cDpP6qJU9lRifpRhwsmQFZ6Bz
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:2911:b0:659:9a49:9077 with SMTP id
 006d021491bc7-6599a97d923mr4163676eaf.66.1765290558915; Tue, 09 Dec 2025
 06:29:18 -0800 (PST)
Date: Tue, 09 Dec 2025 06:29:18 -0800
In-Reply-To: <20251209085950.96231-1-kerneljasonxing@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6938323e.a70a0220.104cf0.0008.GAE@google.com>
Subject: [syzbot ci] Re: xsk: introduce pre-allocated memory per xsk CQ
From: syzbot ci <syzbot+cib018e69d32b0c0b5@syzkaller.appspotmail.com>
To: ast@kernel.org, bjorn@kernel.org, bpf@vger.kernel.org, 
	daniel@iogearbox.net, davem@davemloft.net, edumazet@google.com, 
	hawk@kernel.org, john.fastabend@gmail.com, jonathan.lemon@gmail.com, 
	kerneljasonxing@gmail.com, kernelxing@tencent.com, kuba@kernel.org, 
	maciej.fijalkowski@intel.com, magnus.karlsson@intel.com, 
	netdev@vger.kernel.org, pabeni@redhat.com, sdf@fomichev.me
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v1] xsk: introduce pre-allocated memory per xsk CQ
https://lore.kernel.org/all/20251209085950.96231-1-kerneljasonxing@gmail.com
* [PATCH bpf-next v1 1/2] xsk: introduce local_cq for each af_xdp socket
* [PATCH bpf-next v1 2/2] xsk: introduce a dedicated local completion queue for each xsk

and found the following issue:
WARNING in vfree

Full report is available here:
https://ci.syzbot.org/series/5df45d2b-41d6-4675-b3ad-4503516a9ae1

***

WARNING in vfree

tree:      bpf-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/bpf/bpf-next.git
base:      835a50753579aa8368a08fca307e638723207768
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/726617c2-a613-4879-9987-91e65545dba1/config
C repro:   https://ci.syzbot.org/findings/0c82a0b1-8cb3-49ae-9fbe-fa3bd02c2ba0/c_repro
syz repro: https://ci.syzbot.org/findings/0c82a0b1-8cb3-49ae-9fbe-fa3bd02c2ba0/syz_repro

------------[ cut here ]------------
Trying to vfree() nonexistent vm area (ffffc900034e6000)
WARNING: mm/vmalloc.c:3423 at 0x0, CPU#0: syz.0.19/5983
Modules linked in:
CPU: 0 UID: 0 PID: 5983 Comm: syz.0.19 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:vfree+0x393/0x400 mm/vmalloc.c:3422
Code: e8 72 1d ab ff 4c 89 f7 48 83 c4 18 5b 41 5c 41 5d 41 5e 41 5f 5d e9 0c fa ff ff e8 57 1d ab ff 48 8d 3d 10 fc 6e 0d 4c 89 f6 <67> 48 0f b9 3a e9 fd fd ff ff e8 3e 1d ab ff 4c 89 e7 e8 66 00 00
RSP: 0018:ffffc90004e37c40 EFLAGS: 00010293
RAX: ffffffff82162d09 RBX: 0000000000000000 RCX: ffff88816c66d7c0
RDX: 0000000000000000 RSI: ffffc900034e6000 RDI: ffffffff8f852920
RBP: 1ffff1102289d8bf R08: ffff88810005f1bb R09: 1ffff1102000be37
R10: dffffc0000000000 R11: ffffed102000be38 R12: ffff88801eed1818
R13: dffffc0000000000 R14: ffffc900034e6000 R15: ffff8881144ec608
FS:  0000555574db2500(0000) GS:ffff88818eab1000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00002000000000c0 CR3: 0000000112a48000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 xsk_clear_local_cq net/xdp/xsk.c:1188 [inline]
 xsk_release+0x6b3/0x880 net/xdp/xsk.c:1220
 __sock_release net/socket.c:653 [inline]
 sock_close+0xc3/0x240 net/socket.c:1446
 __fput+0x44c/0xa70 fs/file_table.c:468
 task_work_run+0x1d4/0x260 kernel/task_work.c:233
 resume_user_mode_work include/linux/resume_user_mode.h:50 [inline]
 __exit_to_user_mode_loop kernel/entry/common.c:44 [inline]
 exit_to_user_mode_loop+0xff/0x4f0 kernel/entry/common.c:75
 __exit_to_user_mode_prepare include/linux/irq-entry-common.h:226 [inline]
 syscall_exit_to_user_mode_prepare include/linux/irq-entry-common.h:256 [inline]
 syscall_exit_to_user_mode_work include/linux/entry-common.h:159 [inline]
 syscall_exit_to_user_mode include/linux/entry-common.h:194 [inline]
 do_syscall_64+0x2e3/0xf80 arch/x86/entry/syscall_64.c:100
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7eff8518f7c9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffd6ca61b78 EFLAGS: 00000246 ORIG_RAX: 00000000000001b4
RAX: 0000000000000000 RBX: 000000000001253b RCX: 00007eff8518f7c9
RDX: 0000000000000000 RSI: 000000000000001e RDI: 0000000000000003
RBP: 0000000000000000 R08: 0000000000000001 R09: 000000086ca61e6f
R10: 0000001b2f920000 R11: 0000000000000246 R12: 00007eff853e5fac
R13: 00007eff853e5fa0 R14: ffffffffffffffff R15: 0000000000000003
 </TASK>
----------------
Code disassembly (best guess):
   0:	e8 72 1d ab ff       	call   0xffab1d77
   5:	4c 89 f7             	mov    %r14,%rdi
   8:	48 83 c4 18          	add    $0x18,%rsp
   c:	5b                   	pop    %rbx
   d:	41 5c                	pop    %r12
   f:	41 5d                	pop    %r13
  11:	41 5e                	pop    %r14
  13:	41 5f                	pop    %r15
  15:	5d                   	pop    %rbp
  16:	e9 0c fa ff ff       	jmp    0xfffffa27
  1b:	e8 57 1d ab ff       	call   0xffab1d77
  20:	48 8d 3d 10 fc 6e 0d 	lea    0xd6efc10(%rip),%rdi        # 0xd6efc37
  27:	4c 89 f6             	mov    %r14,%rsi
* 2a:	67 48 0f b9 3a       	ud1    (%edx),%rdi <-- trapping instruction
  2f:	e9 fd fd ff ff       	jmp    0xfffffe31
  34:	e8 3e 1d ab ff       	call   0xffab1d77
  39:	4c 89 e7             	mov    %r12,%rdi
  3c:	e8                   	.byte 0xe8
  3d:	66 00 00             	data16 add %al,(%rax)


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.
