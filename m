Received: from mail-oa1-f46.google.com (mail-oa1-f46.google.com [209.85.160.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF50F28C869
	for <syzbot@lists.linux.dev>; Sun, 10 May 2026 11:44:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778413453; cv=pass; b=t196w8/bM4YVBJLPY0zMnAgGUVljczxuvbB9nmchtFZ92KOOXmi3M1zjTecaZETffi6mDdDu9aacu/QEBONhGPVFvaqSRVNkIOYL3qzcrkoWADF7JZAxyA7Y9J8JWluOqndvWaOEWz2pzjrl+OKszSPWkSqNGbfOuh3cZFFNk20=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778413453; c=relaxed/simple;
	bh=lgyqcOBZgKT6zkbv68KggxkQ9bKi5KlqkkLNJ12uv9U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QxVFQ6VFofink7hyM5V56K1d3DRKo5rJj+AKJcqT3m6qtaaCm5XI4fqFOqa8l5Yr1fVsLvwYj00DCHX16j0wE5Y0nlYtYmr9obRMBzzOk6XX07n3LQ1lFFyOLhkrhkOEdi4kh8vNLNIQNLTiRRsjqySwQZBvAlJEIFDd2VVasQg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=JSajHwQo; arc=pass smtp.client-ip=209.85.160.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JSajHwQo"
Received: by mail-oa1-f46.google.com with SMTP id 586e51a60fabf-42fc6923f38so2874341fac.1
        for <syzbot@lists.linux.dev>; Sun, 10 May 2026 04:44:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778413451; cv=none;
        d=google.com; s=arc-20240605;
        b=hT81EJ20PU1vjEKfw2mEwnyXPoIhAKEaRUUoUePIpRUqWUsiJt1x/r6A6LN4dHUEBn
         mbWo3/Eoddop+PYD78f0740qy/fuvuuw7n94Ck+GLxWmo5p7WdNoEOgzGx0pdrYqSQq7
         fDNZpdXQeDcSf6ahp3hTGXXZvYCBAfa5faUSvrcACNk3uoYqdkTNWHWNyw3Mj6Ea/jfk
         KuvRDnNQpI/Av8Zw7xluuIBWBS4DYuYgJGmdV8UfhZsKbkSf7zKls6VXi78nUUuHSIK1
         uADGbgB7o24BV7PCGcXtXXYD1gc0MjVCumTJCKAc3hJkukA7TsGVuSXepAQLmnNeuO18
         bhMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=v2RNBHAkjJZriKCyjYZlGdO+KbuPU515F2yyPuC2ETI=;
        fh=Aq1BP2e4PL49edpk1tAU7ymOZaCyJe/UaZyvdpVfgo0=;
        b=ZQfpbBmvGGP7nlOn7ofFs6YwK7Pjhysh+vBNCYvuutEv0z4r3MzjpeaSzRJFC9bqxf
         iry1F8q7Wjw2Nnez46V2J0k6cZ3CGqxFsJYLYTODitSNJxMiXjoGfKaoOqBnKMSCla6w
         0yWWgUvZimMDQ9ZBAsuQXUi47psZBl1YiXivZ7Pl8mrT3lhgTezBpCYfMH3S3iXZmhK7
         3BSnXtNQvPtk9AmW37vnqXmSwmjZupPT5bpUVrHq8S+qt9Bu/0jsQO1OIrGYtrYyIOXN
         eQvrZrMFgNghqP+pjdaGrTL7wxWM5Ik1tN9OmrLnzWjsadTzhqM4QWLEtiPEE60rQ47X
         oASw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778413451; x=1779018251; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=v2RNBHAkjJZriKCyjYZlGdO+KbuPU515F2yyPuC2ETI=;
        b=JSajHwQo5mcqF6A0Oqymie3aG/upd7IfnE+LOlzBCPkVdL13zIDCbEXI0IGPbojnh0
         ApJUNAf7mU+3q70ZIrpVCFwNeupMDms/owWrqdaPxE5P+q/V4yQtVJ8my3taZkBDwprx
         W9o0jjovDDxN8O5Pq+k+x3nDtZWq2IpTl3ufZdrlve5LokYcZC2XFxUgPDd4DlvrG57d
         d3ehOXInsD8/SQerr0s9t/C/PRczljJkeJzeAyuNqOuOgK/FemTR4XI3VeA3011lkIuI
         6dtR/cfTHXMzB3l6GBAmGVVJ287tUCm0uBAeJJuACA+DHMTm4usFEtdtGo8RPVJOldAc
         KQ9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778413451; x=1779018251;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=v2RNBHAkjJZriKCyjYZlGdO+KbuPU515F2yyPuC2ETI=;
        b=CQQcEHyWvSSEJ/ISK8wI9gX0HBqT3XjuFJGwoaz+m/T+6OxFD2B7zGko73Ckhtp2Xz
         m6hJsvxDYI+c44Sp5m5m/Ug5GZ8yHF0k88W+0HKTcwSODJoV/AdBkPsfdhUrwPFUt+kg
         Jdm0kq5UOGlNNAim1JRNzpKrRgeS9SisP9c1i47t01xqEDaJobMTKIHAEc8sz5VlO3oh
         eRBqWpr1YuJ+bRlDpYjk4/VM3PnfDidbNxPII2VA01Eqj0ZIYLUMFUOPMy21lKhGg6Yu
         UNLllbQzRxWX5uyPP9lMJ0abjv+A1LkZb4UwKPXclQKJfj4R+OjfW+OTBRndv89G5qiB
         flWQ==
X-Forwarded-Encrypted: i=1; AFNElJ+q/YqtRRxqPpyQ2TG36fkWvSnxRjwTgk4LujaVSC9X5eISwXW2UIqtuYWUHqGYweHN2q/Q2LY=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy8wCXvoG6pfhhPMFxT9AwMqqPIrsvOu+823Ie4b9+/WLXKb5xD
	wGmXLTF6YDBLYkYAhguZpg7dUBW5SsP2IzPRbp5LkqrjiItDO0FScmamS0uWw0Uq5Cu6AI56HiS
	BEnU+VoUM+67WBNl3OAGriADjXMWQWSZZbZP6FH2B
X-Gm-Gg: Acq92OGs76QhhcR9gEMMxXkH94ap7k7dykPwHjir+0p3AqAQHdYhDT3g7y0e18uwAMK
	0WlTSSjQpWr0uDpbuW84u3OwyDiucJHmzAdJTag7710mV7de3I1FZEJrpeOglN2bPRIK0VwE1/L
	5vf5g1RfvIQR8cQQeF5/Z0oGyl/Tbcus3fQfLkuj3bNPU9lOJyiZXzTqKTT1B93zsRj/L6NLAC0
	4uOAhQ8LuygvgpkT1kW4kAzG5xZSbGuBNmrIWf2NIK6sKbzmCf4pJIlJllirucahygRhiAbDpZI
	vF5C2rBout85Kz8SOBwp9+AqrRYk+kPYqR0ualyTKvc4fduSzRqdRu0RNI0tXv2CEiEGqqSBVhC
	lV4mBKQk=
X-Received: by 2002:a05:6870:948a:b0:42c:1153:6917 with SMTP id
 586e51a60fabf-435266d972fmr7502560fac.7.1778413450417; Sun, 10 May 2026
 04:44:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <6a006900.a00a0220.1c3806.000e.GAE@google.com>
In-Reply-To: <6a006900.a00a0220.1c3806.000e.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Sun, 10 May 2026 13:43:59 +0200
X-Gm-Features: AVHnY4IKRRBa7_vYPsnQMoKs_0fvp0PNZkqgHfF49QFkW6G57G_t8fAyKuSJThM
Message-ID: <CANp29Y5CmOeQoGQpkA+zvEx5AqFk2xHNUiTqwDzN-PCneVxCTA@mail.gmail.com>
Subject: Re: [moderation/CI] Re: net: nsh: limit recursive GSO redispatch
To: syzbot ci <syzbot+ci94e59e751f750531@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Sun, May 10, 2026 at 1:16=E2=80=AFPM syzbot ci
<syzbot+ci94e59e751f750531@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v2] net: nsh: limit recursive GSO redispatch
> https://lore.kernel.org/all/67e8340baa2c2772def267a801c8d5b201444d49.1778=
382236.git.caoruide123@gmail.com
> * [PATCH net v2 1/1] net: nsh: limit recursive GSO redispatch
>
> and found the following issue:
> BUG: using __this_cpu_read() in preemptible code in nsh_gso_segment
>
> Full report is available here:
> https://ci.syzbot.org/series/cb23e640-2f7a-42e1-8bad-7249684b1cd5
>
> ***
>
> BUG: using __this_cpu_read() in preemptible code in nsh_gso_segment
>
> tree:      net
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netde=
v/net.git
> base:      496c0c4c53bbe1bad97e82cd12103df61a6e459d
> arch:      amd64
> compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~e=
xp1~20251221153213.50), Debian LLD 21.1.8
> config:    https://ci.syzbot.org/builds/a7e3d1e1-97c4-4876-99c8-658c4cef4=
9c5/config
> syz repro: https://ci.syzbot.org/findings/62ca20c2-7c78-4820-b695-f63b15e=
af738/syz_repro
>
> BUG: using __this_cpu_read() in preemptible [00000000] code: syz.1.18/586=
0
> caller is dev_xmit_recursion include/linux/netdevice.h:3625 [inline]
> caller is nsh_gso_segment+0x535/0xed0 net/nsh/nsh.c:110
> CPU: 0 UID: 0 PID: 5860 Comm: syz.1.18 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
>  check_preemption_disabled+0xd3/0xe0 lib/smp_processor_id.c:47
>  dev_xmit_recursion include/linux/netdevice.h:3625 [inline]
>  nsh_gso_segment+0x535/0xed0 net/nsh/nsh.c:110
>  skb_mac_gso_segment+0x31c/0x690 net/core/gso.c:53
>  __skb_gso_segment+0x376/0x540 net/core/gso.c:124
>  skb_gso_segment include/net/gso.h:83 [inline]
>  validate_xmit_skb+0xa21/0x14a0 net/core/dev.c:4039
>  validate_xmit_skb_list net/core/dev.c:4089 [inline]
>  __dev_direct_xmit+0x1b4/0x750 net/core/dev.c:4922
>  dev_direct_xmit include/linux/netdevice.h:3431 [inline]
>  packet_xmit+0x1b4/0x320 net/packet/af_packet.c:285
>  packet_snd net/packet/af_packet.c:3082 [inline]
>  packet_sendmsg+0x3c81/0x4fb0 net/packet/af_packet.c:3114
>  sock_sendmsg_nosec net/socket.c:787 [inline]
>  __sock_sendmsg net/socket.c:802 [inline]
>  __sys_sendto+0x672/0x710 net/socket.c:2265
>  __do_sys_sendto net/socket.c:2272 [inline]
>  __se_sys_sendto net/socket.c:2268 [inline]
>  __x64_sys_sendto+0xde/0x100 net/socket.c:2268
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x15f/0xf80 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7fcd6a99cdd9
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007fcd6b903028 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
> RAX: ffffffffffffffda RBX: 00007fcd6ac15fa0 RCX: 00007fcd6a99cdd9
> RDX: 00000000000100a6 RSI: 0000200000000180 RDI: 0000000000000005
> RBP: 00007fcd6aa32d69 R08: 0000200000000140 R09: 0000000000000014
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007fcd6ac16038 R14: 00007fcd6ac15fa0 R15: 00007fff57a83608
>  </TASK>
> BUG: using __this_cpu_add() in preemptible [00000000] code: syz.1.18/5860
> caller is dev_xmit_recursion_inc include/linux/netdevice.h:3631 [inline]
> caller is nsh_gso_segment+0x57d/0xed0 net/nsh/nsh.c:113
> CPU: 0 UID: 0 PID: 5860 Comm: syz.1.18 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
>  check_preemption_disabled+0xd3/0xe0 lib/smp_processor_id.c:47
>  dev_xmit_recursion_inc include/linux/netdevice.h:3631 [inline]
>  nsh_gso_segment+0x57d/0xed0 net/nsh/nsh.c:113
>  skb_mac_gso_segment+0x31c/0x690 net/core/gso.c:53
>  __skb_gso_segment+0x376/0x540 net/core/gso.c:124
>  skb_gso_segment include/net/gso.h:83 [inline]
>  validate_xmit_skb+0xa21/0x14a0 net/core/dev.c:4039
>  validate_xmit_skb_list net/core/dev.c:4089 [inline]
>  __dev_direct_xmit+0x1b4/0x750 net/core/dev.c:4922
>  dev_direct_xmit include/linux/netdevice.h:3431 [inline]
>  packet_xmit+0x1b4/0x320 net/packet/af_packet.c:285
>  packet_snd net/packet/af_packet.c:3082 [inline]
>  packet_sendmsg+0x3c81/0x4fb0 net/packet/af_packet.c:3114
>  sock_sendmsg_nosec net/socket.c:787 [inline]
>  __sock_sendmsg net/socket.c:802 [inline]
>  __sys_sendto+0x672/0x710 net/socket.c:2265
>  __do_sys_sendto net/socket.c:2272 [inline]
>  __se_sys_sendto net/socket.c:2268 [inline]
>  __x64_sys_sendto+0xde/0x100 net/socket.c:2268
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x15f/0xf80 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7fcd6a99cdd9
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007fcd6b903028 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
> RAX: ffffffffffffffda RBX: 00007fcd6ac15fa0 RCX: 00007fcd6a99cdd9
> RDX: 00000000000100a6 RSI: 0000200000000180 RDI: 0000000000000005
> RBP: 00007fcd6aa32d69 R08: 0000200000000140 R09: 0000000000000014
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007fcd6ac16038 R14: 00007fcd6ac15fa0 R15: 00007fff57a83608
>  </TASK>
> BUG: using __this_cpu_add() in preemptible [00000000] code: syz.1.18/5860
> caller is dev_xmit_recursion_dec include/linux/netdevice.h:3636 [inline]
> caller is nsh_gso_segment+0x59f/0xed0 net/nsh/nsh.c:115
> CPU: 0 UID: 0 PID: 5860 Comm: syz.1.18 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
>  check_preemption_disabled+0xd3/0xe0 lib/smp_processor_id.c:47
>  dev_xmit_recursion_dec include/linux/netdevice.h:3636 [inline]
>  nsh_gso_segment+0x59f/0xed0 net/nsh/nsh.c:115
>  skb_mac_gso_segment+0x31c/0x690 net/core/gso.c:53
>  __skb_gso_segment+0x376/0x540 net/core/gso.c:124
>  skb_gso_segment include/net/gso.h:83 [inline]
>  validate_xmit_skb+0xa21/0x14a0 net/core/dev.c:4039
>  validate_xmit_skb_list net/core/dev.c:4089 [inline]
>  __dev_direct_xmit+0x1b4/0x750 net/core/dev.c:4922
>  dev_direct_xmit include/linux/netdevice.h:3431 [inline]
>  packet_xmit+0x1b4/0x320 net/packet/af_packet.c:285
>  packet_snd net/packet/af_packet.c:3082 [inline]
>  packet_sendmsg+0x3c81/0x4fb0 net/packet/af_packet.c:3114
>  sock_sendmsg_nosec net/socket.c:787 [inline]
>  __sock_sendmsg net/socket.c:802 [inline]
>  __sys_sendto+0x672/0x710 net/socket.c:2265
>  __do_sys_sendto net/socket.c:2272 [inline]
>  __se_sys_sendto net/socket.c:2268 [inline]
>  __x64_sys_sendto+0xde/0x100 net/socket.c:2268
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x15f/0xf80 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7fcd6a99cdd9
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007fcd6b903028 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
> RAX: ffffffffffffffda RBX: 00007fcd6ac15fa0 RCX: 00007fcd6a99cdd9
> RDX: 00000000000100a6 RSI: 0000200000000180 RDI: 0000000000000005
> RBP: 00007fcd6aa32d69 R08: 0000200000000140 R09: 0000000000000014
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007fcd6ac16038 R14: 00007fcd6ac15fa0 R15: 00007fff57a83608
>  </TASK>
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
> [bird@lzu.edu.cn caoruide123@gmail.com davem@davemloft.net jbenc@redhat.c=
om lkp@intel.com lx24@stu.ynu.edu.cn matttbe@kernel.org n05ec@lzu.edu.cn ne=
tdev@vger.kernel.org tomapufckgml@gmail.com yifanwucs@gmail.com yuantan098@=
gmail.com]
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
-upstream-moderation/6a006900.a00a0220.1c3806.000e.GAE%40google.com.
