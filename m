Received: from mail-oa1-f44.google.com (mail-oa1-f44.google.com [209.85.160.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEFB1287272
	for <syzbot@lists.linux.dev>; Wed,  7 Jan 2026 20:59:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767819593; cv=none; b=arqzSnobyQhYKCtICQ0CkN2taiDzpCgFgsihLBo5Oze5VjuNcAvgDrSL9yz0Zw41OskozpHJCVJd7WJmhom+emFSrNwT/7hy6qhS0IhwM1PnDhb3mUXomIQCN0afASN/zATm/XFDf7J8yGCNgAVUjplu5duB4REd283zwqAgyl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767819593; c=relaxed/simple;
	bh=zCxdDdaSVU4rT94RtqcXK7YxXEeicNqYQTHJCbuzIA4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=sq2m9v1voC0hOv15F2Ucj3CE9FBhezGCQQViudIWk9gkZ6CjS52RWD1SmJOhrfkF1NZguAJWVN/un02gpnrw8k269sDgpZzC2KdPJTcWT8zBF4neOwPIL/9t07Ho5SNBan/GhvJB7TMy99hyDhxEm7E+cKx6WfJKURZNVP6D+08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2dXSjR7r; arc=none smtp.client-ip=209.85.160.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2dXSjR7r"
Received: by mail-oa1-f44.google.com with SMTP id 586e51a60fabf-3e8f418e051so1744755fac.3
        for <syzbot@lists.linux.dev>; Wed, 07 Jan 2026 12:59:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767819590; x=1768424390; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QXGmKA7pF/7sb8vGbVfalyzswtOTKV117w7EfLXQQik=;
        b=2dXSjR7rkE4OY5iZTqVZwfNX04YdOK/T5Y8n5DrIpW99/CxY/cPDRPUxkXezZ/6l59
         gA6lv9o63uD9DEHtk6v9QzDpitJRGJBJpOQ7xW+flF3IfjydtQHjYZHkILKY6wkNl0fa
         k9mRa/PogYpizTNFIbHL8GavPnVKy2jzH8pyRPcIG0eL2knn1jLL6fSvm+9uYZiYC2WJ
         VXxoupEqa/H9OFe4tPmeBlP4rQzDdY+as7sJsPZJ1nwcByt1nHT3tGUGmZjw/4WQ9Oja
         tyBKLMUbYgIk9cIVSe1kHvktrtSUk3PnfBtcZFRo2Wep8enIZHQf8XCMBDgrObVfab5G
         uTcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767819590; x=1768424390;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=QXGmKA7pF/7sb8vGbVfalyzswtOTKV117w7EfLXQQik=;
        b=sUFWtmd05GP2msjgTsZupx3DRUvY4qoZ76F8IEB7rhLD3J9ya20JUwe3ryaUvN7Q0o
         l/A6W5MRi1hHBQt9X4kNuJDABKnXf5UZCB9H3kTTSPEWt/pMNFBWyfRz/WDfCoOb3lki
         rN1CHGdt/cY77wM2VfxfXslkgoCZ12RgFUxY5BxPcVMTMOiNBEciEyNCxVglPwkvX+MD
         k3wHChsbDARj6cR9eP88HlED/Agd6whb3OW/JU3lt4JLA4y9ZqeWrDDOggtrgcXJtwea
         onVthd05YohCNjvWSM8xVtaBo6Ek6wFKOtbIGOLHofjB7Dn5SvZ2PI7uTyIMRX6cP1Nw
         OR7g==
X-Forwarded-Encrypted: i=1; AJvYcCXVDvPFpJpdRhjv2oc9Pq1Czlxi8eHlQzqCoiEHnVkszJoiV/uFnF+V803uAcfRjH2drDgdlCI=@lists.linux.dev
X-Gm-Message-State: AOJu0YyQ+apmiBBjuWkOZbYY3DQqhsI0oUCijvMId+Z6AvtlfWhD6bwf
	UyDgpBQfCC9O3l0ZolgK3wdDiqqwUKVhTpKkartp+9Ei0I4Qlsm/6/5+SRxAE36d5oJBvJ9WrBX
	KgaRRaPaPtVI0tSzGU4PkydYNLcVzqgvpT07+jjtG
X-Gm-Gg: AY/fxX7vVs0CljVACY3jIzyhDmruhG38PIva9TdYHH1DEDl6xC3DEfmLNdIC8qvB/lO
	lKLdS0ped+SojPoKe+xK3eqHCWMHcgWt0FUJUY3QbffmihSfa1SPPubFAFiPUXkGkBdvyFPi8h3
	BF9AQCpTICZFVJZlBozC6ZamrDQsVUYggiu/nUqYODQgpR1TXmNHh7QG5gX8Ywxqf0U+aXI+5LI
	2bk5YjMcXiDGWW0yRA53ke8bdZoxKCVLfNymLJeNMUA5kAhvfkxrIuFHQQv3/FgnPf9WlaIgM0b
	77T1fWKA6xxgtqhDmy1PiUMvWS4us+IBghvv/aRZxUCJR8TMQ03YtaVOQfOn
X-Google-Smtp-Source: AGHT+IERFimgKwTSS7kn4Jzp1eeyfkaNxwJy5mDgZPcn8r/QZlGXbFcm5NcxSCdFMLYT9DWyDheKDNjhhP2oazZImWk=
X-Received: by 2002:a05:6820:2227:b0:659:9a49:901b with SMTP id
 006d021491bc7-65f550841e4mr1619152eaf.72.1767819590315; Wed, 07 Jan 2026
 12:59:50 -0800 (PST)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <695ec666.050a0220.1c677c.037b.GAE@google.com>
In-Reply-To: <695ec666.050a0220.1c677c.037b.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Wed, 7 Jan 2026 21:59:39 +0100
X-Gm-Features: AQt7F2oZw738sS0DPBlmzhZP-rQCD-uPAJKOQsKW3NjlXfSkUEuYYzd3NZXwvBQ
Message-ID: <CANp29Y4axxnT=KKxiQmSFLBpGNuKUa-hS+N2BM_bBD6hdsYZ_g@mail.gmail.com>
Subject: Re: [moderation/CI] Re: bpf: Fix memory access flags in helper prototypes
To: syzbot ci <syzbot+ci5515ece1cdfe6f85@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Wed, Jan 7, 2026 at 9:47=E2=80=AFPM syzbot ci
<syzbot+ci5515ece1cdfe6f85@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v1] bpf: Fix memory access flags in helper prototypes
> https://lore.kernel.org/all/20260107-helper_proto-v1-0-e387e08271cc@gmail=
.com
> * [PATCH bpf 1/2] bpf: Fix memory access flags in helper prototypes
> * [PATCH bpf 2/2] bpf: Require ARG_PTR_TO_MEM with memory flag
>
> and found the following issue:
> WARNING in check_helper_call
>
> Full report is available here:
> https://ci.syzbot.org/series/020c2fa8-b95d-4273-9bc0-2f82fa714a8e
>
> ***
>
> WARNING in check_helper_call
>
> tree:      bpf
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/bpf/b=
pf.git
> base:      ab86d0bf01f6d0e37fd67761bb62918321b64efc
> arch:      amd64
> compiler:  Debian clang version 21.1.8 (++20251202083448+f68f64eb8130-1~e=
xp1~20251202083504.46), Debian LLD 21.1.8
> config:    https://ci.syzbot.org/builds/9a24b0e7-35e4-4718-b939-3b210b6b5=
126/config
> C repro:   https://ci.syzbot.org/findings/8fcbdcf8-4480-46d8-b7a8-f1de940=
1a8ac/c_repro
> syz repro: https://ci.syzbot.org/findings/8fcbdcf8-4480-46d8-b7a8-f1de940=
1a8ac/syz_repro
>
> ------------[ cut here ]------------
> verifier bug: incorrect func proto bpf_tcp_raw_check_syncookie_ipv6#207
> WARNING: kernel/bpf/verifier.c:11546 at check_helper_call+0xc00/0x6e10 ke=
rnel/bpf/verifier.c:11546, CPU#0: syz.0.17/5981
> Modules linked in:
> CPU: 0 UID: 0 PID: 5981 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:check_helper_call+0xc16/0x6e10 kernel/bpf/verifier.c:11546
> Code: ef e6 ff 49 bf 00 00 00 00 00 fc ff df 48 8d 1d a0 c2 ea 0d 44 8b 6=
4 24 24 44 89 e7 e8 d3 32 0c 00 48 89 df 48 89 c6 44 89 e2 <67> 48 0f b9 3a=
 49 81 c6 80 08 00 00 44 89 e7 e8 b6 32 0c 00 4c 89
> RSP: 0018:ffffc90007116fa0 EFLAGS: 00010246
> RAX: ffffffff8b934740 RBX: ffffffff8fc645d0 RCX: dffffc0000000000
> RDX: 00000000000000cf RSI: ffffffff8b934740 RDI: ffffffff8fc645d0
> RBP: ffffc900071171b0 R08: ffff88816b42ba80 R09: 0000000000000002
> R10: 0000000000000004 R11: 0000000000000000 R12: 00000000000000cf
> R13: f8f8f8f8f8f8f8f8 R14: ffff888112440000 R15: dffffc0000000000
> FS:  000055557af7b500(0000) GS:ffff88818e40e000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007fd892207dac CR3: 0000000161682000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  do_check_insn kernel/bpf/verifier.c:20417 [inline]
>  do_check+0x99eb/0xec30 kernel/bpf/verifier.c:20598
>  do_check_common+0x19cc/0x25b0 kernel/bpf/verifier.c:23882
>  do_check_main kernel/bpf/verifier.c:23965 [inline]
>  bpf_check+0x5f0d/0x1c4a0 kernel/bpf/verifier.c:25272
>  bpf_prog_load+0x1484/0x1ae0 kernel/bpf/syscall.c:3088
>  __sys_bpf+0x570/0x920 kernel/bpf/syscall.c:6164
>  __do_sys_bpf kernel/bpf/syscall.c:6274 [inline]
>  __se_sys_bpf kernel/bpf/syscall.c:6272 [inline]
>  __x64_sys_bpf+0x7c/0x90 kernel/bpf/syscall.c:6272
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xe2/0xf80 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7fd891f9acb9
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffee24b6bb8 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
> RAX: ffffffffffffffda RBX: 00007fd892205fa0 RCX: 00007fd891f9acb9
> RDX: 0000000000000094 RSI: 0000200000000300 RDI: 0000000000000005
> RBP: 00007fd892008bf7 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007fd892205fac R14: 00007fd892205fa0 R15: 00007fd892205fa0
>  </TASK>
> ----------------
> Code disassembly (best guess):
>    0:   ef                      out    %eax,(%dx)
>    1:   e6 ff                   out    %al,$0xff
>    3:   49 bf 00 00 00 00 00    movabs $0xdffffc0000000000,%r15
>    a:   fc ff df
>    d:   48 8d 1d a0 c2 ea 0d    lea    0xdeac2a0(%rip),%rbx        # 0xde=
ac2b4
>   14:   44 8b 64 24 24          mov    0x24(%rsp),%r12d
>   19:   44 89 e7                mov    %r12d,%edi
>   1c:   e8 d3 32 0c 00          call   0xc32f4
>   21:   48 89 df                mov    %rbx,%rdi
>   24:   48 89 c6                mov    %rax,%rsi
>   27:   44 89 e2                mov    %r12d,%edx
> * 2a:   67 48 0f b9 3a          ud1    (%edx),%rdi <-- trapping instructi=
on
>   2f:   49 81 c6 80 08 00 00    add    $0x880,%r14
>   36:   44 89 e7                mov    %r12d,%edi
>   39:   e8 b6 32 0c 00          call   0xc32f4
>   3e:   4c                      rex.WR
>   3f:   89                      .byte 0x89
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
> The email will later be sent to:
> [andrii@kernel.org ast@kernel.org bpf@vger.kernel.org daniel@iogearbox.ne=
t davem@davemloft.net dxu@dxuuu.xyz eddyz87@gmail.com edumazet@google.com e=
lectronlsr@gmail.com ftyghome@gmail.com gplhust955@gmail.com haoluo@google.=
com haoran.ni.cs@gmail.com horms@kernel.org john.fastabend@gmail.com jolsa@=
kernel.org kpsingh@kernel.org kuba@kernel.org linux-kernel@vger.kernel.org =
linux-trace-kernel@vger.kernel.org martin.lau@linux.dev mathieu.desnoyers@e=
fficios.com mattbobrowski@google.com mhiramat@kernel.org netdev@vger.kernel=
.org pabeni@redhat.com rostedt@goodmis.org sdf@fomichev.me song@kernel.org =
yonghong.song@linux.dev]
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
-upstream-moderation/695ec666.050a0220.1c677c.037b.GAE%40google.com.
