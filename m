Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com [209.85.210.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 171A52C181
	for <syzbot@lists.linux.dev>; Wed,  7 Jan 2026 20:47:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767818857; cv=none; b=EmCjIn+W7H7g0zIEZPRS/rtin1VvEfznsdT+qbRimRiff50R+pKsyekRfrMRFlKz7rNB5pxZddEQWQE3vy0iKnqRowcVwVV2DWUB8A1BUd/K1hcEbDufDqO3HchDCImWn+eoaipwATg3qg2/47wWPOEA2x3JlA/rGm3PZ4UB0MU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767818857; c=relaxed/simple;
	bh=L2k414TJbn7VBxFXdIsfjIRl3A07y/Dh1T9rGgyTISo=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=qBkF6ABDRsWhz71z/jtGS9dYCfvtO8IQGUe0/B1ypLpFgn8e0Bv7zjFSwW86EjfNRHigYisoxaJ2lrpLKcwWjzb2T7azIYJbUWJXpXz3Aa3vNpfECtSguqhrkY11ZurBdMFq2zxcSs5o2dopfQzi13/uQw/vBMjMy/NyfAp8JT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.210.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f70.google.com with SMTP id 46e09a7af769-7c7599be25cso7309386a34.2
        for <syzbot@lists.linux.dev>; Wed, 07 Jan 2026 12:47:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767818854; x=1768423654;
        h=content-transfer-encoding:cc:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MTJ3qvpLMAPPYofYWXgEnIYy2TdEfrlNQ3kgDsKNZuw=;
        b=VkwaTKA+YLx+Vjl17DdAsDVIYLagHb3AKIUgb9UNp4hv3aroeNGz2tkmAI1w22lkv4
         vDyIuwdHJPH5rWAV+QYjpZCP9y3YVF6Gy/7sh16DGxMGJDku5dZpteLsZfzV7kDXV4yy
         RzLLOjMKX1RGjjtMVPpDYIA0RFm/mGk72vFinRQ4cm4//EvkULOsG0l31pUYaeBZJSdK
         NjR+7/qbP8mEgRg1e4yaNTjKAMtQkCBQW34bB3rUIOqU9y7uNm302lHJSvKAeiojIOAG
         5PLDnnG+IhxboECEC8UpCFN4peRHBz0U4ap46gHagpkIe9NsVEEs020g2U6K+WUP4zPR
         kjJQ==
X-Gm-Message-State: AOJu0YyOWdxFB4PMYwyku4h3IQym1DO+m0jRDzVBpOulDbLs15mFZ+wT
	NwT953TYc3bTBdvYcDT99C+BtXomrCIhG1ePONhCTRBT814eHvvxSThTmzAnZM4N25fQL9EnBC0
	I6dHrE3YHMGkFPB8+Zj25dsiEnYlhlSvj9kfq7V2WKQ927BzDdl0BeZ561OU=
X-Google-Smtp-Source: AGHT+IHLqvsVjnugwXphNY/Ph+Et46u36GgCoQgZeUr+FJ3tYqNcr+yMBpvKuZehwgL8pUrBgg82Y2NJ37r/JVuZ1+Q+e/NO23NT
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:151b:b0:659:9a49:8f3a with SMTP id
 006d021491bc7-65f550bd62bmr1392804eaf.75.1767818854654; Wed, 07 Jan 2026
 12:47:34 -0800 (PST)
Date: Wed, 07 Jan 2026 12:47:34 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <695ec666.050a0220.1c677c.037b.GAE@google.com>
Subject: [moderation/CI] Re: bpf: Fix memory access flags in helper prototypes
From: syzbot ci <syzbot+ci5515ece1cdfe6f85@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v1] bpf: Fix memory access flags in helper prototypes
https://lore.kernel.org/all/20260107-helper_proto-v1-0-e387e08271cc@gmail.c=
om
* [PATCH bpf 1/2] bpf: Fix memory access flags in helper prototypes
* [PATCH bpf 2/2] bpf: Require ARG_PTR_TO_MEM with memory flag

and found the following issue:
WARNING in check_helper_call

Full report is available here:
https://ci.syzbot.org/series/020c2fa8-b95d-4273-9bc0-2f82fa714a8e

***

WARNING in check_helper_call

tree:      bpf
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/bpf/bpf=
.git
base:      ab86d0bf01f6d0e37fd67761bb62918321b64efc
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251202083448+f68f64eb8130-1~exp=
1~20251202083504.46), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/9a24b0e7-35e4-4718-b939-3b210b6b512=
6/config
C repro:   https://ci.syzbot.org/findings/8fcbdcf8-4480-46d8-b7a8-f1de9401a=
8ac/c_repro
syz repro: https://ci.syzbot.org/findings/8fcbdcf8-4480-46d8-b7a8-f1de9401a=
8ac/syz_repro

------------[ cut here ]------------
verifier bug: incorrect func proto bpf_tcp_raw_check_syncookie_ipv6#207
WARNING: kernel/bpf/verifier.c:11546 at check_helper_call+0xc00/0x6e10 kern=
el/bpf/verifier.c:11546, CPU#0: syz.0.17/5981
Modules linked in:
CPU: 0 UID: 0 PID: 5981 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(ful=
l)=20
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16=
.2-1 04/01/2014
RIP: 0010:check_helper_call+0xc16/0x6e10 kernel/bpf/verifier.c:11546
Code: ef e6 ff 49 bf 00 00 00 00 00 fc ff df 48 8d 1d a0 c2 ea 0d 44 8b 64 =
24 24 44 89 e7 e8 d3 32 0c 00 48 89 df 48 89 c6 44 89 e2 <67> 48 0f b9 3a 4=
9 81 c6 80 08 00 00 44 89 e7 e8 b6 32 0c 00 4c 89
RSP: 0018:ffffc90007116fa0 EFLAGS: 00010246
RAX: ffffffff8b934740 RBX: ffffffff8fc645d0 RCX: dffffc0000000000
RDX: 00000000000000cf RSI: ffffffff8b934740 RDI: ffffffff8fc645d0
RBP: ffffc900071171b0 R08: ffff88816b42ba80 R09: 0000000000000002
R10: 0000000000000004 R11: 0000000000000000 R12: 00000000000000cf
R13: f8f8f8f8f8f8f8f8 R14: ffff888112440000 R15: dffffc0000000000
FS:  000055557af7b500(0000) GS:ffff88818e40e000(0000) knlGS:000000000000000=
0
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fd892207dac CR3: 0000000161682000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 do_check_insn kernel/bpf/verifier.c:20417 [inline]
 do_check+0x99eb/0xec30 kernel/bpf/verifier.c:20598
 do_check_common+0x19cc/0x25b0 kernel/bpf/verifier.c:23882
 do_check_main kernel/bpf/verifier.c:23965 [inline]
 bpf_check+0x5f0d/0x1c4a0 kernel/bpf/verifier.c:25272
 bpf_prog_load+0x1484/0x1ae0 kernel/bpf/syscall.c:3088
 __sys_bpf+0x570/0x920 kernel/bpf/syscall.c:6164
 __do_sys_bpf kernel/bpf/syscall.c:6274 [inline]
 __se_sys_bpf kernel/bpf/syscall.c:6272 [inline]
 __x64_sys_bpf+0x7c/0x90 kernel/bpf/syscall.c:6272
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xe2/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fd891f9acb9
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 =
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff f=
f 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffee24b6bb8 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
RAX: ffffffffffffffda RBX: 00007fd892205fa0 RCX: 00007fd891f9acb9
RDX: 0000000000000094 RSI: 0000200000000300 RDI: 0000000000000005
RBP: 00007fd892008bf7 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fd892205fac R14: 00007fd892205fa0 R15: 00007fd892205fa0
 </TASK>
----------------
Code disassembly (best guess):
   0:	ef                   	out    %eax,(%dx)
   1:	e6 ff                	out    %al,$0xff
   3:	49 bf 00 00 00 00 00 	movabs $0xdffffc0000000000,%r15
   a:	fc ff df
   d:	48 8d 1d a0 c2 ea 0d 	lea    0xdeac2a0(%rip),%rbx        # 0xdeac2b4
  14:	44 8b 64 24 24       	mov    0x24(%rsp),%r12d
  19:	44 89 e7             	mov    %r12d,%edi
  1c:	e8 d3 32 0c 00       	call   0xc32f4
  21:	48 89 df             	mov    %rbx,%rdi
  24:	48 89 c6             	mov    %rax,%rsi
  27:	44 89 e2             	mov    %r12d,%edx
* 2a:	67 48 0f b9 3a       	ud1    (%edx),%rdi <-- trapping instruction
  2f:	49 81 c6 80 08 00 00 	add    $0x880,%r14
  36:	44 89 e7             	mov    %r12d,%edi
  39:	e8 b6 32 0c 00       	call   0xc32f4
  3e:	4c                   	rex.WR
  3f:	89                   	.byte 0x89


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[andrii@kernel.org ast@kernel.org bpf@vger.kernel.org daniel@iogearbox.net =
davem@davemloft.net dxu@dxuuu.xyz eddyz87@gmail.com edumazet@google.com ele=
ctronlsr@gmail.com ftyghome@gmail.com gplhust955@gmail.com haoluo@google.co=
m haoran.ni.cs@gmail.com horms@kernel.org john.fastabend@gmail.com jolsa@ke=
rnel.org kpsingh@kernel.org kuba@kernel.org linux-kernel@vger.kernel.org li=
nux-trace-kernel@vger.kernel.org martin.lau@linux.dev mathieu.desnoyers@eff=
icios.com mattbobrowski@google.com mhiramat@kernel.org netdev@vger.kernel.o=
rg pabeni@redhat.com rostedt@goodmis.org sdf@fomichev.me song@kernel.org yo=
nghong.song@linux.dev]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

