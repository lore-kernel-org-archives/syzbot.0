Received: from mail-ot1-f42.google.com (mail-ot1-f42.google.com [209.85.210.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55314258EDE
	for <syzbot@lists.linux.dev>; Tue, 23 Dec 2025 13:48:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766497706; cv=none; b=nmqYwajpwA3Ybz73aDtlQZwQsBo6AiV/8mk1VelkUgh9nbcnAgIGHss/VFpc5IRfaJ8JKZY3RGdg+Ncv9jVvqn4Zgk+ZV+4vL2mVux+4mHJXINjj8DvnC+wq0/kH0XnEVa1CexhTyDumJ1TUSGDE0mzsJTYMlqq50yb0hxHLh2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766497706; c=relaxed/simple;
	bh=WV8Xa7mpmHsgcXhWQPW1Z6ztJkWDMjBP/k44oQnyNfk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DgDeNfe4FZvvQuOAMgtj/tyjjZBsbe16wq/qxiPbd87bQqpudhfciVSCALjURUD5HW9eQ1bDJg8ArdIbtSMn1Bb570nSFkuyzAGtj4WhsY20h5Pp8NRpofeQM6BTPkbyY/svShOVQTFQ7Qr2nNVt60T9lLX33X8rzJojX9g8BA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PgBWKCdc; arc=none smtp.client-ip=209.85.210.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PgBWKCdc"
Received: by mail-ot1-f42.google.com with SMTP id 46e09a7af769-7c6e815310aso4007981a34.0
        for <syzbot@lists.linux.dev>; Tue, 23 Dec 2025 05:48:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1766497703; x=1767102503; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=W0TmGr81RwoWH5WT1nlWt258VVIQcoyIufuhxdsLm6o=;
        b=PgBWKCdc6TQ5a6IuaH0qw77nolmeQ6IzOhE08Tw3oYq71KktLJ9o4mn3I0EPoOvc/M
         fWCUw/BY2n6YvURWgROmt4u1STkjltTVSukWCdTA5yL8Azv2+kfzWMHLhqMyc28gGb0K
         9zPRCDvfnzs01Jl+zZzaPupog9+Uezr7tOF9csQwg5fFO5nbf8SIyj3K9AO3Q7e84bev
         YFlJpNqyz3UaxFKag/hydSsIyrs/JNB3Au5Plzl1eQkriRpaNC1sXgtb30Xwhb8KaJza
         Rzw33+3lrqU2RW43yHA9RFLJnuOVumGLWx9c89iQ+SZur/+0oo8s8jTdX784CAHFWqO6
         h8aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766497703; x=1767102503;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=W0TmGr81RwoWH5WT1nlWt258VVIQcoyIufuhxdsLm6o=;
        b=Gogcq5+6YI/CJv/wfdXzcMg57ig3gQUWhPwGMadjJ37sinepqVQHvk+4K9PFJ19DUn
         fv+ucZyy/zpLIsq9xqNwGxzP1lgq9ojVrEv2AboXMcCxSNHSbuPx6rpoZj8zJ8ORr+PD
         lhjmkAk9AM23AWuiIxdoFegR5+J6SYDyD35IcFPGRlJUAOatuRa7iSKIQdVkgPZnneiO
         HHo73nbidUAmFo2cCotikx5RBK0WWa1JPqkl7SybHKO/nfTetszC4nAuezCuviFzKJ8A
         FWHq4DJvZeQA+IiAjfRnncGcznQE9CUQiZFSxj4oihwJMGxrvWLdxbcwhdyuIAr8c6bG
         D8Jw==
X-Forwarded-Encrypted: i=1; AJvYcCXEZwN6r4Y1JjcBHDnpEt7AB/WfxErCoMsHwo4k0aMkXvAXlhgzYxh+dIbcBmZvxgm4TF7UbRU=@lists.linux.dev
X-Gm-Message-State: AOJu0YwRFA5HT4kxkyFjljtLtH4n5uRSnKTia86PVaFR01172Qbq/bf1
	4XimD3QdueLmyMtFwIrjH7Mnb0GCKO23TEHza7oOtw5pqf+LD496VC/KvxwSFzA9ht4OgcbyjKw
	kElPXrAeFNmpTw07kovqk7ftOGRz7HNMg7Bg+CyPE
X-Gm-Gg: AY/fxX4OIxJaMPbZpGfoTQyHKVqHgGSD0r5m2eQwqDeY4cWPNIs3YePBNd+Ra4BKRCb
	HvXTtG1gns/d19vLktIeUhp/OUCeNT8NqEYU6HrACn4amMtarxM9AkqSv9DgcE7naO+5JmiAWjt
	gojLcnDrk1M4t6oo/5GIv29r17YF57RNe+jAY1skUZmj3OBpFVi64o1bd2pTfCbXEp7EGpu0Gp5
	EIrVT1qX6N+QuazQsk97Y3pJm8btGF0FJrhot3r7jcASa+mPswHozi4Ys0MRqPY7Eo2YJGJn40A
	mDICwlwsgborcnN7gM30RNpwJ99Qj3XwGb1FXq9UFDSOE0GMxoTKRD9VLQ==
X-Google-Smtp-Source: AGHT+IGuxvQILYXDm64iYPh6RqcRo3Wo/PH81TXXs/d8+sFKOuJJ461IAgox3K/0hoMCosvmNs2LNwsj4cxo6A7Kwtc=
X-Received: by 2002:a05:6820:430b:b0:65c:f821:9dd3 with SMTP id
 006d021491bc7-65d0eaccda4mr4610035eaf.70.1766497702989; Tue, 23 Dec 2025
 05:48:22 -0800 (PST)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <694a94da.050a0220.19928e.0027.GAE@google.com>
In-Reply-To: <694a94da.050a0220.19928e.0027.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Tue, 23 Dec 2025 22:48:11 +0900
X-Gm-Features: AQt7F2qdi8pzcZuRLziX_DDn4ThO0jbXO0DxQQVHlVCmcPf9hkM4mrU8hh4-XgA
Message-ID: <CANp29Y7xYm7iOx0+Yx0OvNrPStsYb_3hkiLPvR7hESjv+OU=fQ@mail.gmail.com>
Subject: Re: [moderation/CI] Re: bpf: Add value tracking for BPF_DIV
To: syzbot ci <syzbot+cia1924fbce9f593a7@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Tue, Dec 23, 2025 at 2:10=E2=80=AFPM syzbot ci
<syzbot+cia1924fbce9f593a7@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v2] bpf: Add value tracking for BPF_DIV
> https://lore.kernel.org/all/20251223091120.2413435-1-tangyazhou@zju.edu.c=
n
> * [PATCH bpf-next v2 1/2] bpf: Add interval and tnum analysis for signed =
and unsigned BPF_DIV
> * [PATCH bpf-next v2 2/2] selftests/bpf: Add tests for BPF_DIV analysis
>
> and found the following issue:
> WARNING in reg_bounds_sanity_check
>
> Full report is available here:
> https://ci.syzbot.org/series/9bfb8ed3-0d6e-4ae4-93a1-e5d466326f9e
>
> ***
>
> WARNING in reg_bounds_sanity_check
>
> tree:      bpf-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/bpf/b=
pf-next.git
> base:      ec439c38013550420aecc15988ae6acb670838c1
> arch:      amd64
> compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~e=
xp1~20250708183702.136), Debian LLD 20.1.8
> config:    https://ci.syzbot.org/builds/67e90945-0cc5-47d7-a492-406b63cd4=
281/config
> C repro:   https://ci.syzbot.org/findings/5808370d-6cee-4ff9-9a6f-ba40075=
33b78/c_repro
> syz repro: https://ci.syzbot.org/findings/5808370d-6cee-4ff9-9a6f-ba40075=
33b78/syz_repro
>
> ------------[ cut here ]------------
> verifier bug: REG INVARIANTS VIOLATION (alu): range bounds violation u64=
=3D[0x1, 0x0] s64=3D[0x1, 0x0] u32=3D[0x1, 0x0] s32=3D[0x1, 0x0] var_off=3D=
(0x1, 0x0)
> WARNING: kernel/bpf/verifier.c:2748 at reg_bounds_sanity_check+0x201/0xc3=
0 kernel/bpf/verifier.c:2742, CPU#0: syz.0.17/5999
> Modules linked in:
> CPU: 0 UID: 0 PID: 5999 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:reg_bounds_sanity_check+0x3e6/0xc30 kernel/bpf/verifier.c:2742
> Code: 98 00 00 00 4c 8b 8c 24 88 00 00 00 41 ff 34 24 41 57 55 41 55 ff b=
4 24 f0 00 00 00 ff b4 24 a8 00 00 00 ff b4 24 c0 00 00 00 <67> 48 0f b9 3a=
 48 83 c4 38 49 bf 00 00 00 00 00 fc ff df 48 8b 84
> RSP: 0018:ffffc90004277098 EFLAGS: 00010246
> RAX: dffffc0000000000 RBX: 1ffff11022c96804 RCX: 0000000000000001
> RDX: ffffffff8b71cd00 RSI: ffffffff8b71bae0 RDI: ffffffff8f861280
> RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000001
> R10: 000000000000000c R11: 0000000000000000 R12: ffff8881164b4020
> R13: 0000000000000001 R14: 1ffff11022c96803 R15: 0000000000000001
> FS:  000055555eb0e500(0000) GS:ffff88818e835000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007fad443e7dac CR3: 00000001bc680000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  check_alu_op kernel/bpf/verifier.c:16205 [inline]
>  do_check_insn kernel/bpf/verifier.c:20533 [inline]
>  do_check+0xa72c/0xeba0 kernel/bpf/verifier.c:20802
>  do_check_common+0x19cc/0x25b0 kernel/bpf/verifier.c:24080
>  do_check_main kernel/bpf/verifier.c:24163 [inline]
>  bpf_check+0x5e7a/0x1c300 kernel/bpf/verifier.c:25470
>  bpf_prog_load+0x13ba/0x1a10 kernel/bpf/syscall.c:3088
>  __sys_bpf+0x5c3/0x8a0 kernel/bpf/syscall.c:6207
>  __do_sys_bpf kernel/bpf/syscall.c:6320 [inline]
>  __se_sys_bpf kernel/bpf/syscall.c:6318 [inline]
>  __x64_sys_bpf+0x7c/0x90 kernel/bpf/syscall.c:6318
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xfa/0xf80 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7fad4418f7c9
> Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffe64db1fd8 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
> RAX: ffffffffffffffda RBX: 00007fad443e5fa0 RCX: 00007fad4418f7c9
> RDX: 0000000000000094 RSI: 0000200000000340 RDI: 0000000000000005
> RBP: 00007fad441f297f R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007fad443e5fa0 R14: 00007fad443e5fa0 R15: 0000000000000003
>  </TASK>
> ----------------
> Code disassembly (best guess):
>    0:   98                      cwtl
>    1:   00 00                   add    %al,(%rax)
>    3:   00 4c 8b 8c             add    %cl,-0x74(%rbx,%rcx,4)
>    7:   24 88                   and    $0x88,%al
>    9:   00 00                   add    %al,(%rax)
>    b:   00 41 ff                add    %al,-0x1(%rcx)
>    e:   34 24                   xor    $0x24,%al
>   10:   41 57                   push   %r15
>   12:   55                      push   %rbp
>   13:   41 55                   push   %r13
>   15:   ff b4 24 f0 00 00 00    push   0xf0(%rsp)
>   1c:   ff b4 24 a8 00 00 00    push   0xa8(%rsp)
>   23:   ff b4 24 c0 00 00 00    push   0xc0(%rsp)
> * 2a:   67 48 0f b9 3a          ud1    (%edx),%rdi <-- trapping instructi=
on
>   2f:   48 83 c4 38             add    $0x38,%rsp
>   33:   49 bf 00 00 00 00 00    movabs $0xdffffc0000000000,%r15
>   3a:   fc ff df
>   3d:   48                      rex.W
>   3e:   8b                      .byte 0x8b
>   3f:   84                      .byte 0x84
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
t eddyz87@gmail.com haoluo@google.com john.fastabend@gmail.com jolsa@kernel=
.org kpsingh@kernel.org martin.lau@linux.dev sdf@fomichev.me shenghaoyuan09=
28@163.com song@kernel.org tangyazhou518@outlook.com tangyazhou@zju.edu.cn =
yonghong.song@linux.dev ziye@zju.edu.cn]
>
> If the report looks fine to you, reply with:
> #syz upstream
>
> --
> You received this message because you are subscribed to the Google Groups=
 "syzkaller-upstream-moderation" group.
> To unsubscribe from this group and stop receiving emails from it, send an=
 email to syzkaller-upstream-moderation+unsubscribe@googlegroups.com.
> To view this discussion visit https://groups.google.com/d/msgid/syzkaller=
-upstream-moderation/694a94da.050a0220.19928e.0027.GAE%40google.com.
