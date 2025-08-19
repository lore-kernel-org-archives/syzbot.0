Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E89E2737E8
	for <syzbot@lists.linux.dev>; Tue, 19 Aug 2025 14:42:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755614568; cv=none; b=jAEseGLl6C9OEkK/J3zSvINckhFY8LZXeQUrju2qf9oMsLMuKJJ6akKSTtfY+4Yf/1oLtOAdFeQd15+cqWKulsyV2J1kb+TdMFur84bStnJzo6wvuwgnvc9cGb3eW4hYJqebtuon57iVxmpegf1j7ftbPzDv5+zkBeiS7r4wr9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755614568; c=relaxed/simple;
	bh=COoe0/gW45A+WWZJBTDCLFRK6d29q3gnb1jctl7HCmE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HwHZ8QLe91o7OSZbFzTEEftKykherCZD8LX/bxZPT6Q/H5lBsB0/yZQ2bjWM4Xf34eJvr2er4QGKFX1GpeKt97X302ZjtcIiQ4KqAgvZbWYIQFeLG4yib1zuC2R866PfcfIoi8wBg7h6GVGcqYGvayoV/wcDUYue8pto1iirIiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KUg8bYXZ; arc=none smtp.client-ip=209.85.215.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KUg8bYXZ"
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-b474e8d6d01so1198037a12.0
        for <syzbot@lists.linux.dev>; Tue, 19 Aug 2025 07:42:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755614564; x=1756219364; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lsgeVrg6rRmC42wJEauVZH2y2toW5yaX17oO478gm48=;
        b=KUg8bYXZmD4jlIE7eb7uy+RTpQtAc9u2jn+9F+0RJym+uhGPFVUPyzrr2SbYT/6uGx
         LPYHrHMgqrZvWvi1ouJ5anqoeXN5HxlWwGXI0LQQqWCa4FJTRCRlNTwHiIWrc5LBSryL
         PE91x2Op1z9MfjWOYpjubzm1sA/5XNEWi39F53UA+Wwu0qYkgIPcNTXe6BJy+bf6ATpt
         aGcH61NSbSG2aFhqecwxtLCYP7x2qFXlAusqXi0iFRaOraDPM8RjRVuXChxwD6C/EBs0
         kTD+Ig7kQdCwDM6rczXEuQ2qUlHgHnMC3r9qeCFiG4uSN1lLSDTxpWKi+73M++U2ZBgJ
         akTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755614564; x=1756219364;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lsgeVrg6rRmC42wJEauVZH2y2toW5yaX17oO478gm48=;
        b=Mnu0F2+wiI8EvzFG9TGWtRL3BH3gdLTxwiR2bY6iKJUzhzluqyQSSSEtRsrHtAvto5
         WwQgw5o3bVQshKAlrKHJGB3PxTEGbQ7fPNHVi1jWiTSTQELF06Dh1ysmgFJa3Ti3GvPt
         AWlkmHYKL5WtIlO+OfyybDk54d6WUNCgaWe09FtpH4I/h4o1JPV51hqhIVYNUk810glU
         is8kPmBHkF6bvUSOVYlh25/kLIitwtGCafNc8GFZ4skW+M8BPVhuSQ9TLwlmgFyvMcmR
         OOUlLM5qnvDaJF1WNJm++6gUVpfjY5VXxu6p5G6Odm/JLhmQa8fxPmK5Xn8N9x+GZRT7
         TvTw==
X-Forwarded-Encrypted: i=1; AJvYcCU3GAN6G9b2idukrG/L4k+m80ifeR/mTG6O3VDuTaEcsfBP8ewRzLKl+6kSi1gYt5LbUotYtxg=@lists.linux.dev
X-Gm-Message-State: AOJu0YxI1KQQfDtpiHRLJwtl5UfJrBOc9aJ7pFWq5gpNMsLyay+OYoU9
	AeANe8IPElg/RzFhGrbheEHoyhrO2SVMkP5tU246CagcE3be1q7Mh44X02tIgcobv64j1LKasYn
	4Ck0I5wXKH6sDOBekJFEL7l077h7KYDPW5J++sDih
X-Gm-Gg: ASbGncttyN96Gl73eNboeFFYzLAI1116fD0sgZUumKy7UH1lTIjZNmyrID+pCpvg2zj
	8fuEgMjy4zb2bP9ETYkiI7DpKoRDBnmThzHENGpmTebCWaS4o3gWHsSjUUooXRUC30lOCqxO82k
	KpoyXfaQV9zpbN+x4xTIo8STtYPLHecFHc9mOgAwpBGPjVweVGw8sn5HRUciPoj1Qb50shadkh1
	r4iAUvDx2Q/vmgA27GAk4Idos/5R5To2qDfugXfwD4k
X-Google-Smtp-Source: AGHT+IFGIyXJMnUxsQD6KpA9i7cLKpvLSg0+OqYPJLg8ogW9Ls1OrssM8pkCu8m3nawyXivxA48oEEmyhlIWSErXXd0=
X-Received: by 2002:a17:902:dacd:b0:240:4407:4015 with SMTP id
 d9443c01a7336-245e04b78aamr34910825ad.45.1755614564196; Tue, 19 Aug 2025
 07:42:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <68a489b6.050a0220.1b2f6c.0008.GAE@google.com>
In-Reply-To: <68a489b6.050a0220.1b2f6c.0008.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Tue, 19 Aug 2025 16:42:32 +0200
X-Gm-Features: Ac12FXxIM7rPs04atzbRhXH7jTaYYfK6lljkB6DVTEdc5HmvXxcTbPsZkCnebvM
Message-ID: <CANp29Y4yYgLXtX9uS7WU44w2h5WykBsimtNtqJ=RX5QCkOyc-w@mail.gmail.com>
Subject: Re: [moderation/CI] Re: KVM: Speed up MMIO registrations
To: syzbot ci <syzbot+cid1f70a8279f5df6f@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Tue, Aug 19, 2025 at 4:27=E2=80=AFPM syzbot ci
<syzbot+cid1f70a8279f5df6f@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v3] KVM: Speed up MMIO registrations
> https://lore.kernel.org/all/20250819090853.3988626-1-keirf@google.com
> * [PATCH v3 1/4] KVM: arm64: vgic-init: Remove vgic_ready() macro
> * [PATCH v3 2/4] KVM: arm64: vgic: Explicitly implement vgic_dist::ready =
ordering
> * [PATCH v3 3/4] KVM: Implement barriers before accessing kvm->buses[] on=
 SRCU read paths
> * [PATCH v3 4/4] KVM: Avoid synchronize_srcu() in kvm_io_bus_register_dev=
()
>
> and found the following issue:
> WARNING in kvm_put_kvm
>
> Full report is available here:
> https://ci.syzbot.org/series/3dc60813-f155-4817-8552-1f86bd35f4e4
>
> ***
>
> WARNING in kvm_put_kvm
>
> tree:      torvalds
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torva=
lds/linux
> base:      dfc0f6373094dd88e1eaf76c44f2ff01b65db851
> arch:      amd64
> compiler:  Debian clang version 20.1.7 (++20250616065708+6146a88f6049-1~e=
xp1~20250616065826.132), Debian LLD 20.1.7
> config:    https://ci.syzbot.org/builds/a80ce1fb-9721-4229-8c84-f01975da1=
8a2/config
> C repro:   https://ci.syzbot.org/findings/c7213edd-3666-4fca-886f-07477eb=
19900/c_repro
> syz repro: https://ci.syzbot.org/findings/c7213edd-3666-4fca-886f-07477eb=
19900/syz_repro
>
> ------------[ cut here ]------------
> WARNING: CPU: 0 PID: 6003 at kernel/rcu/srcutree.c:697 cleanup_srcu_struc=
t+0x4ea/0x5f0 kernel/rcu/srcutree.c:697
> Modules linked in:
> CPU: 0 UID: 0 PID: 6003 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:cleanup_srcu_struct+0x4ea/0x5f0 kernel/rcu/srcutree.c:697
> Code: 8b 5c 24 08 74 08 48 89 df e8 e2 30 7d 00 48 c7 03 00 00 00 00 48 8=
3 c4 20 5b 41 5c 41 5d 41 5e 41 5f 5d c3 cc cc cc cc cc 90 <0f> 0b 90 eb e6=
 90 0f 0b 90 eb e0 90 0f 0b 90 eb 14 90 0f 0b 90 eb
> RSP: 0018:ffffc90003b0fc78 EFLAGS: 00010202
> RAX: 1ffffd1fe28c5059 RBX: 1ffff1102341db2b RCX: b3fdaa5e0844b500
> RDX: 0000000000000000 RSI: ffffffff8dba5bb5 RDI: ffff888022170000
> RBP: ffffe8ff146282c8 R08: ffffe8ff14628367 R09: 1ffffd1fe28c506c
> R10: dffffc0000000000 R11: fffff91fe28c506d R12: ffff88811a0ed958
> R13: 0000000000000000 R14: dffffc0000000000 R15: 1ffffffff1b7be74
> FS:  000055557858e500(0000) GS:ffff8880b861c000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 000000c002fcff88 CR3: 000000003a46e000 CR4: 0000000000352ef0
> Call Trace:
>  <TASK>
>  kvm_destroy_vm virt/kvm/kvm_main.c:1324 [inline]
>  kvm_put_kvm+0x8ca/0xa70 virt/kvm/kvm_main.c:1353
>  kvm_vm_release+0x43/0x50 virt/kvm/kvm_main.c:1376
>  __fput+0x44c/0xa70 fs/file_table.c:468
>  task_work_run+0x1d1/0x260 kernel/task_work.c:227
>  resume_user_mode_work include/linux/resume_user_mode.h:50 [inline]
>  exit_to_user_mode_loop+0xec/0x110 kernel/entry/common.c:43
>  exit_to_user_mode_prepare include/linux/irq-entry-common.h:225 [inline]
>  syscall_exit_to_user_mode_work include/linux/entry-common.h:175 [inline]
>  syscall_exit_to_user_mode include/linux/entry-common.h:210 [inline]
>  do_syscall_64+0x2bd/0x3b0 arch/x86/entry/syscall_64.c:100
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f975198ebe9
> Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007fffbfd6bfd8 EFLAGS: 00000246 ORIG_RAX: 00000000000001b4
> RAX: 0000000000000000 RBX: 000000000000ed88 RCX: 00007f975198ebe9
> RDX: 0000000000000000 RSI: 000000000000001e RDI: 0000000000000003
> RBP: 0000000000000000 R08: 0000000000000001 R09: 00000003bfd6c2cf
> R10: 0000001b2fa20000 R11: 0000000000000246 R12: 00007f9751bb5fac
> R13: 00007f9751bb5fa0 R14: ffffffffffffffff R15: 0000000000000003
>  </TASK>
>
>
> ***
>
> If these findings have caused you to resend the series or submit a
> separate fix, please add the following tag to your commit message:
> Tested-by: syzbot@syzkaller.appspotmail.com
>
> ---
> This report is generated by a bot. It may contain errors.
> syzbot ci engineers can be reached at syzkaller@googlegroups.com.
>
> The email will later be sent to:
> [eric.auger@redhat.com keirf@google.com kvm@vger.kernel.org linux-arm-ker=
nel@lists.infradead.org linux-kernel@vger.kernel.org maz@kernel.org oliver.=
upton@linux.dev pbonzini@redhat.com seanjc@google.com will@kernel.org]
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
-upstream-moderation/68a489b6.050a0220.1b2f6c.0008.GAE%40google.com.
