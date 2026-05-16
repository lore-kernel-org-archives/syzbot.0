Received: from mail-oa1-f45.google.com (mail-oa1-f45.google.com [209.85.160.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAD0C2556E
	for <syzbot@lists.linux.dev>; Sat, 16 May 2026 06:57:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778914652; cv=pass; b=ZV+MqvTKlS7O/gdvqmIm56PNCLs+2CAiYOZW4djauJDF/zTWCKzCbQr7iLQCgeekrGGLm2irPwwddsKVzFXy0220H35r5xHnvX3h2LbFJKf6W6aj1TXMsz6pk55WlHX9UDfhNfiSu7BZq5yOd93aipTjYGVZBXGdnBH0UkbWAuk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778914652; c=relaxed/simple;
	bh=Fz3DN3QYGeZIsSyKzSCpPzGF0z8u0PwZ96g4M21Zrcc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=sHy5/AjwOui0oPKjjk1CAopL4JipLdC96wDaHsX6lQDV24oJXmyftTJr+/fVesf0tZgdQKqaiZEPOY3LXH6+cWeOymxYFqPJQiOllx24HvBmKGygfRuQ6OtMDV/cfhhjYh80VDBq8lAsFAAmeutWKqgW011WMBSK9149pvrSxgs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=q0vckYC/; arc=pass smtp.client-ip=209.85.160.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="q0vckYC/"
Received: by mail-oa1-f45.google.com with SMTP id 586e51a60fabf-408778a8ec4so448579fac.0
        for <syzbot@lists.linux.dev>; Fri, 15 May 2026 23:57:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778914650; cv=none;
        d=google.com; s=arc-20240605;
        b=Bc29KpJd/jPIwLRG6+TxpYuq3ggnFkwDAFDh61Lgit13mz4S+boi5TyhlkbsaOZac/
         zSRAxv50/ik0dgd49PK/Y7xw//GVZ/AFDkOwhrQ4Cs3b1LMcxItRuvkawTGqoO5pbnIK
         ENf/XG8Ldloq6YzChFAfiodotkYsosIvQ4qWPVBuMQLKzu4s30zWy4kYaaVAffs6icOg
         Pn9NppQZhUp3s0GB4+JBBzi2NHlqrUQo1vZkko8HvkurbfqauWGQiJj4GIx6dBK/DBdL
         QDIX1h6m7LAOSLCh0gMr/5edgHwxxgUkz/S2Dpzi6+7yTyWeh+KI7ALpnuZxEOliNw+q
         xcpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=rRtuAC6bhn9rFECS8GIfhAfyf8NSGxiOeElkaL/ryGg=;
        fh=hG6Ax72c8JI+8a980PPYluZV8nY0nQKx15sZIYHYTAQ=;
        b=h9fIsB35KsGwU1lQcKarYM5ykPq+x155twMUUM8qlP1QYO6vH0e/TKH+uDmLrVnyXA
         GLg1MSQK1FlCBkEMumauy2BEmB6zU70o7KfSOFwgFO0+ApDcdPk2Dqn80/1+v/3X2BG4
         XoEcp6bKB9wlKkyf+pyHOQ/3yOEzF74X0Tz+ZKw2CGZR5iWr1RkwcESq6ldC22ED+XzZ
         SU3RXr5RfMwRWZvzgHrtj+/xVNLWEQZJCKr6sZIvbYawQahfswDO0xZeAa01UJow3Rto
         3k2NKAcgeMNXX94yEe2Zs0KzZ61YUzNcaTZBfakUOIPtntDxePZpGOn/rLXLdr940Wst
         hBhQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778914650; x=1779519450; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rRtuAC6bhn9rFECS8GIfhAfyf8NSGxiOeElkaL/ryGg=;
        b=q0vckYC/9QV5v0w1pv3jpOmuS3zL0BWZ0BlSYrWKB/MOXuwByXV/7sxTW8AAMiMJTR
         iwKEApQmhAXJnF8eAgi/OP/FiBCsBhM+vUDTF8yMU+a8vW0E7xCmvnNmAnkzOjZBJYCB
         UrlhdHb62n58bMkJ0W1URPiHhdXSh7PBe5PRpTQvR50+zYq310+fBvfimGdctLod9kUo
         Jw9uFugr1tII058JDIp5Ja4bQrQgoom0M53B/DoMh39/ccGPxabQfk7wnJAftF/bWnIh
         xjrVAw+3vyS1mZtOKWMx4Z05Bm8VPw8qPIcD7qw5GR5IBJesVfh42vBfc9bwDybqjT3q
         RQcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778914650; x=1779519450;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=rRtuAC6bhn9rFECS8GIfhAfyf8NSGxiOeElkaL/ryGg=;
        b=JFs8hX5oLjb7X9vvDv8Mh9caYEubF28apcnDdbMzWqSeM5b7xjLRou2Z2oJ7FrFYJB
         UsleZF3jcWewTHmCHdRJboYq55zvoXW/yEMM3yFQAR0kKhvx6rMMqlh06bwc2awyQ2Ue
         365IpFwQ1KuLQjR+32fmlEv5jjvLaLw5YcOQwGSftwocohZHpV1tZqkxTwvGoUDQ0g0x
         n/eeFeRUMbgE07r7Q5nJoeE5zbLscKQjN3U31HE0ElfDm+c72+6UuCDVLOFnmUdHj2UZ
         2SkXRDEjnciwPxqv0qm+7BnoSa0n3OLtXy3QSAH2CctrSyhxAVedGTFVHZ+JhNHUHEFJ
         Zeqg==
X-Forwarded-Encrypted: i=1; AFNElJ/xjKZXVeolcXEOOQ83XV8pwxBFsp5vw3c9qG1N38T/hxxIBigVQin3Gvk7aao3Ntyrpr+l57s=@lists.linux.dev
X-Gm-Message-State: AOJu0Ywlpdg9xITn4XW6QnFWWHIKioRx/L2ASSRCbRSxFMT8yYgbK8Pv
	RIpdzDeNEX6zEq8CbPPOO3skxFcEAwJ7fpl7yVNbgDkEV6v5puyvkcq0RjWJpkkGb00FbomezG6
	tIVf/H7Si6d1uny8mysM2tHg5Lo5aWq+z37MfijzJ
X-Gm-Gg: Acq92OHaInm29pxhUZJwwhX0bksVzyuEQ0gphDlctg47kYboym5YMdPGHia7x4IpMFz
	1AR9sQKxnhlhBafpDBaC1a8XARcVHsK+3abNkeJDXwzx7wiLElMjU46WLMCViq+/c5+WKpDCrbn
	uN8fZgOn/coExk4jxrQUbU+tyl3XncbwKNuoOdFYEw5yTHebr6wp7qXwYpD6fYntZE08GpZWOD2
	uJGCW3NyqubL5rcFqqtwVhdbNWL/TXECzibZaUvbjEcTaA7iDQO82tFxHihZGp+OcWrUeg9it0u
	gDqtXhOPAMQBQk/4zIi752NKZ6Q4jAwJPXjqtYh0LVB38D/NkrnBQbiWqsy21sqG3tPwhh4VVkA
	FEhSp5WQ=
X-Received: by 2002:a05:6870:15ce:b0:42f:f1e8:76eb with SMTP id
 586e51a60fabf-43a2de0ba42mr4802848fac.32.1778914649407; Fri, 15 May 2026
 23:57:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <6a079b08.a00a0220.300e5b.0000.GAE@google.com>
In-Reply-To: <6a079b08.a00a0220.300e5b.0000.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Sat, 16 May 2026 08:57:16 +0200
X-Gm-Features: AVHnY4LOMU3IQAdfDYyt3CrUBlOSkebjhb1ZlV_H7N2dXVIGODoyYTDz_s_ERRQ
Message-ID: <CANp29Y77jjVQRaObba4z-hiQi-5k=cMmXC8-_Uab2nqYNPQ9=A@mail.gmail.com>
Subject: Re: [moderation/CI] Re: memcg: cache obj_stock by memcg, not by objcg pointer
To: syzbot ci <syzbot+ci0963b9a1e1f05606@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Sat, May 16, 2026 at 12:15=E2=80=AFAM syzbot ci
<syzbot+ci0963b9a1e1f05606@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v1] memcg: cache obj_stock by memcg, not by objcg pointer
> https://lore.kernel.org/all/20260515171953.2224503-1-shakeel.butt@linux.d=
ev
> * [PATCH] memcg: cache obj_stock by memcg, not by objcg pointer
>
> and found the following issue:
> WARNING in __refill_obj_stock
>
> Full report is available here:
> https://ci.syzbot.org/series/8efc6e46-4b2e-43ab-90a0-62552bdc14a6
>
> ***
>
> WARNING in __refill_obj_stock
>
> tree:      mm-new
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/=
mm.git
> base:      0cec77cfd5314c0b3b03530abe1a4b32e991f639
> arch:      amd64
> compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~e=
xp1~20251221153213.50), Debian LLD 21.1.8
> config:    https://ci.syzbot.org/builds/fda0a69d-af56-4b9f-8b30-b63ea4756=
923/config
>
> ------------[ cut here ]------------
> debug_locks && !(rcu_read_lock_held() || lock_is_held(&(&cgroup_mutex)->d=
ep_map))
> WARNING: ./include/linux/memcontrol.h:380 at __refill_obj_stock+0x4fd/0x6=
10, CPU#0: syz.1.48/5712
> Modules linked in:
>
> CPU: 0 UID: 0 PID: 5712 Comm: syz.1.48 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:__refill_obj_stock+0x4fd/0x610
> Code: 89 e7 48 83 c4 18 5b 41 5c 41 5d 41 5e 41 5f 5d e9 d8 ba 00 00 48 8=
3 c4 18 5b 41 5c 41 5d 41 5e 41 5f 5d c3 cc cc cc cc cc 90 <0f> 0b 90 e9 a8=
 fb ff ff 44 89 f9 80 e1 07 80 c1 03 38 c1 0f 8c 60
> RSP: 0018:ffffc9000483f4b0 EFLAGS: 00010246
> RAX: 0000000000000000 RBX: ffff88810beb0f80 RCX: 0000000080000001
> RDX: 0000000000000110 RSI: ffffffff8e21e93e RDI: ffffffff8c28b8e0
> RBP: 0000000000000001 R08: ffffffff8239a83c R09: ffff88812103c600
> R10: dffffc0000000000 R11: ffffed102d89bae9 R12: 1ffff110242078c8
> R13: ffff88810beb0d80 R14: dffffc0000000000 R15: ffff88812103c600
> FS:  0000000000000000(0000) GS:ffff88818dc89000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f80ad948060 CR3: 000000000e74a000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  __memcg_slab_free_hook+0x2ed/0x4b0
>  kmem_cache_free+0x381/0x650
>  __put_anon_vma+0x12b/0x2d0
>  unlink_anon_vmas+0x58b/0x730
>  free_pgtables+0x802/0xb40
>  exit_mmap+0x490/0x9e0
>  __mmput+0x118/0x430
>  exit_mm+0x18e/0x250
>  do_exit+0x6a2/0x22c0
>  do_group_exit+0x21b/0x2d0
>  get_signal+0x1284/0x1330
>  arch_do_signal_or_restart+0xbc/0x840
>  exit_to_user_mode_loop+0x8c/0x4d0
>  do_syscall_64+0x33e/0xf80
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f6eea99ce59
> Code: Unable to access opcode bytes at 0x7f6eea99ce2f.
> RSP: 002b:00007f6eeb8240e8 EFLAGS: 00000246
>  ORIG_RAX: 00000000000000ca
> RAX: 0000000000000001 RBX: 00007f6eeac15fa8 RCX: 00007f6eea99ce59
> RDX: 00000000000f4240 RSI: 0000000000000081 RDI: 00007f6eeac15fac
> RBP: 00007f6eeac15fa0 R08: 3fffffffffffffff R09: 0000000000000000
> R10: 0000200001000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f6eeac16038 R14: 00007fffdc60cea0 R15: 00007fffdc60cf88
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
> [akpm@linux-foundation.org cgroups@vger.kernel.org hannes@cmpxchg.org ker=
nel-team@meta.com linux-kernel@vger.kernel.org linux-mm@kvack.org mhocko@ke=
rnel.org muchun.song@linux.dev oliver.sang@intel.com qi.zheng@linux.dev rom=
an.gushchin@linux.dev shakeel.butt@linux.dev]
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
-upstream-moderation/6a079b08.a00a0220.300e5b.0000.GAE%40google.com.
