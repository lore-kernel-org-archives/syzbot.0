Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FBFC26ACC
	for <syzbot@lists.linux.dev>; Fri, 10 Jul 2026 07:45:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783669555; cv=pass; b=jbdYKz4KEOEgXVjE5+9LN0ov9xWyxjdy/himi+DY2fWpqcO36/Ml9h2K5ceS+AZaeBrl+QFiwmUVZet2x89sk3EZCrGh02coDTCRqDppVySlM970hMDwqm2BZD6Bs5ja+m311HOc1NTVw9yG7XOUXPHVcGNcwCIQKxeksEQJnbk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783669555; c=relaxed/simple;
	bh=xhvOv9Hk6HqYEkbC2VS5AVcA58GQcj5oBOz/j/BTUC8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bZgtiNpykLO6Dvb3ekoNKgztTfWjw65IIh2HxrZK8JuT1vbqNb/uU8ZA9VpBaWRoj+Qxg0TlOV7QD73i9OlC5gusnO1zRjeO/R9a6TTLIk165l8Bn/I3+sNdL7mI/UZ0AD9xfjZ1R3S5NxVgfHmy9B+gSNZW3g7P0oYh7BbRduo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=v+fntsDn; arc=pass smtp.client-ip=209.85.219.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="v+fntsDn"
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-8f29ec73064so4983706d6.1
        for <syzbot@lists.linux.dev>; Fri, 10 Jul 2026 00:45:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783669553; cv=none;
        d=google.com; s=arc-20260327;
        b=cMiDPUTomzfgvidQLzrDG/Y3KO+iyCZmTYTMDKsTmC+FRFJhuCv2BfFzLLFAzkgsYb
         PJFUnftyKNg66JMVai3OqztFMluPayn4jJXe1wa5nwERira/U1ANO/4n3hjaxFruxxxu
         Vil8FtXj09Q1ajwgXS7tfdT1/RMFkB0+y2fB6GDPOgm19DZxMP9Wpw4Cywp8w+Lw2hRc
         yF1tctmRVagrydxNRP1HN1a8cQkOyhVvG0BfmgfH23sx0vzkgF4H4IxCvI7GUvoXZKWA
         eZB5PEYUwZVA5dspu2/xcH+KFt9Tg/pW9lxzFEX7zQYxylOYrsVq4kaCX15YmGqXzK8t
         9cQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=eRDP1snwOiNcn9tdZwxQSI1lqqQAnHn2s+yR8fII7ww=;
        fh=XMquNMLTtqpwx5Aaxr/yEDDYe2VSTCzrWs6VCVkT0Sk=;
        b=YBce4kYJi8LG2uWJ8+1RGda+GRjDzVasci1GlYkLDkxrEMCtNO/vR5xKaqZWrdx4hI
         ZYH7LFrH+vDNFKmm8SeBFJ2PrfQMnCO9Ioie5avUuCjgXx9DntSQp/mOqkC2BT7TbKfq
         WCuk8rtY9XvUFFUFAcMonPorVPH147yG2UCR/N1RKc35ZOwyfymXfx0McBwr0IJ0KLIv
         kYW0YNLl6D4r4OoQtMVD3Nfz28jRBBXAxc81NgtxiCH577ZcaPW8BoYl+veWyQ/87UpX
         2C0MPdqmR7lhcZYn4HecOUauGBIfJMlX0xgOaNpFC3aLpIoq3ue0Gw0a3c4fW2QB5pkP
         RifA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783669553; x=1784274353; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=eRDP1snwOiNcn9tdZwxQSI1lqqQAnHn2s+yR8fII7ww=;
        b=v+fntsDn3fM2XqlxP6NPoJ5nwqboEU4jLbZV1gXZGzst1SjCy3jKfWp8hyYxnO9maG
         leBc5pBEVtTcshJ/lAoFrweg52gFbzJQrsldBw70FbXToydAhZfqmuK6yWZEz3VyD9L1
         O5PzWQGKhukDminQlbC/aQ/eH4ArKP5XnB6l7PgOaWgeGWjNLSYpq3+QC0n+6YCRy/YN
         iYTNSVH4iUeBouRVP0rDf/xrF+yEMzLsfXh8o/jAZ4cSFymwBFzO6fU/AXojse3LY93z
         D1zYXyGxCsNFyUmHlmmo4q5L30V5NiGc+l/PG+cOSziRoCauaTvs11QhqIfsnJsVNvmr
         R7tA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783669553; x=1784274353;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=eRDP1snwOiNcn9tdZwxQSI1lqqQAnHn2s+yR8fII7ww=;
        b=m6+1okCgWBIAhnUSmz2YT+3uOwkX76FY0ixDO9eXVWkSFdPPM9amriFuhZVUGCrAty
         r++MZsT4VfIHc87CAw3ijApaWzux40WVAENQ9AGleX0MkYuMO2fSnHL3maSiw7egEu0C
         4CQdFI+t1sbZjo2hB8NPus3m5/kyF4JYJ+GRppFFouLaaRNCu7Q4giDyaItD2KuhkP9J
         kcn2lDB47GW6bF+MlpXX481eSViROHnSsDjMK5n6p/sfIHLvP4JNm1P7Sna/64LCmuda
         pkn5xVoqP1Sr9EoK++wsLWIaOAeaSENeHIA8r4LOk7xufjSyMUS+cqiRfxKCVqU4OtBq
         OoEA==
X-Forwarded-Encrypted: i=1; AHgh+Rro0P2T7/pDm48kNUQWzzt+Bmb9E+pSHH0xGiIHZZ6OY+H4imZhGE7BXPWF1CNsop1VpsPFzXk=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz9/1sJSL0fc3nsBB1AnWM/9st8lIu28oKR92wUCHR1RSwSyxNy
	TbDwdnqf1BJV4Ks8Z8HRPIME5vjG3+RiPe6rHkkHBh5PBToqcK7cbAI2UQ5PNFj75eFuVjv/xl8
	/gNw8ryHxbt7y+a9gyxzUgPx7zdu3Jh6EoQK7Pj7f
X-Gm-Gg: AfdE7clYgAGA3ScTJYyT4pI7M05qR6WyxwGD2az4rUwH4vU/Zf70MHbAQo4YOm5ejQ+
	aihlD9uM9xXVWTR8dHYZVQCgsKZ4DCu9hL5X9PVGmsIBXpYkoGHwF2AIgmu3yV9yL/TgdEGsbTh
	wSjD2ZWs2AETIt9k4ToydHS6DOoruN3KxPRF3qytr+qqp0pi3tXxuktmeIU5MivJiT0Vx9u30I0
	nmxnNJBBfE+ZE+KYHocpHtoRqKA1FTA4ThXeag3319kac6/+oZHPju0q4+nw408FxGpNOgyAbHw
	3RQVFxdJaFrHP9llNnwWs8QcxnGxq+mVz60siZ4fxSykOhmal69q7iDmr22yIQ==
X-Received: by 2002:a05:6214:1bc9:b0:8ec:eff:2485 with SMTP id
 6a1803df08f44-8fec0ebcc4dmr113588186d6.24.1783669552377; Fri, 10 Jul 2026
 00:45:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <6a505616.c76b52dc.2a15e.0004.GAE@google.com>
In-Reply-To: <6a505616.c76b52dc.2a15e.0004.GAE@google.com>
From: Pimyn Girgis <pimyn@google.com>
Date: Fri, 10 Jul 2026 09:45:41 +0200
X-Gm-Features: AUfX_mxuGtaLWdcnsW5kfjwDtssfa5hSToPF_x1QBsfivHjnB1BQYnd7ew0YgKM
Message-ID: <CAJWNTGwwC1ncvPzAPuFaQ2=F0oZi7Sn31idLJQD0ZTMNLNLsew@mail.gmail.com>
Subject: Re: [moderation/CI] Re: ext4: fix use-after-free in ext4 delayed I/O completion
To: syzbot ci <syzbot+ci6adb434ae4c369ad@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Fri, Jul 10, 2026 at 4:16=E2=80=AFAM syzbot ci
<syzbot+ci6adb434ae4c369ad@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v1] ext4: fix use-after-free in ext4 delayed I/O completion
> https://lore.kernel.org/all/20260709075613.854-1-coregee2000@gmail.com
> * [PATCH] ext4: fix use-after-free in ext4 delayed I/O completion
>
> and found the following issue:
> inconsistent lock state in igrab
>
> Full report is available here:
> https://ci.syzbot.org/series/91c98fac-dc4f-4090-8c56-abbc36b7cd36
>
> ***
>
> inconsistent lock state in igrab
>
> tree:      mm-new
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/=
mm.git
> base:      86f436567f2516a0083b210bedc933544826a2c3
> arch:      amd64
> compiler:  Debian clang version 22.1.6 (++20260514074242+fc4aad7b5db3-1~e=
xp1~20260514074407.73), Debian LLD 22.1.6
> config:    https://ci.syzbot.org/builds/7d4608a1-deef-4f49-aff7-ee231c101=
f0a/config
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D
> WARNING: inconsistent lock state
> syzkaller #0 Not tainted
> --------------------------------
> inconsistent {SOFTIRQ-ON-W} -> {IN-SOFTIRQ-W} usage.
> swapper/0/0 [HC0[0]:SC1[1]:HE0:SE0] takes:
> ffff888112ebb350 (&sb->s_type->i_lock_key#23){+.?.}-{3:3}, at: igrab+0x2d=
/0x1e0
> {SOFTIRQ-ON-W} state was registered at:
>   lock_acquire+0x116/0x340
>   _raw_spin_lock+0x2e/0x40
>   iget_locked+0x397/0x6a0
>   __ext4_iget+0x242/0x4290
>   ext4_get_journal_inode+0x30/0x1c0
>   ext4_load_and_init_journal+0x231/0x23f0
>   ext4_fill_super+0x3a64/0x6560
>   get_tree_bdev_flags+0x430/0x4f0
>   vfs_get_tree+0x92/0x2a0
>   do_new_mount+0x325/0xac0
>   init_mount+0xc3/0x110
>   do_mount_root+0xf4/0x260
>   mount_root_generic+0x1a7/0x370
>   prepare_namespace+0x71/0xa0
>   kernel_init_freeable+0x36e/0x4b0
>   kernel_init+0x1d/0x1d0
>   ret_from_fork+0x5b0/0xb20
>   ret_from_fork_asm+0x1a/0x30
> irq event stamp: 682389
> hardirqs last  enabled at (682388): [<ffffffff81862340>] handle_softirqs+=
0x1a0/0x850
> hardirqs last disabled at (682389): [<ffffffff8b73ff0e>] _raw_spin_lock_i=
rqsave+0x8e/0x100
> softirqs last  enabled at (682374): [<ffffffff81862c35>] __irq_exit_rcu+0=
xd5/0x1f0
> softirqs last disabled at (682387): [<ffffffff81862c35>] __irq_exit_rcu+0=
xd5/0x1f0
>
> other info that might help us debug this:
>  Possible unsafe locking scenario:
>
>        CPU0
>        ----
>   lock(&sb->s_type->i_lock_key#23);
>   <Interrupt>
>     lock(&sb->s_type->i_lock_key#23);
>
>  *** DEADLOCK ***
>
> 1 lock held by swapper/0/0:
>  #0: ffff888112ebb880 (&ei->i_completed_io_lock){..-.}-{3:3}, at: ext4_pu=
t_io_end_defer+0x442/0x700
>
> stack backtrace:
> CPU: 0 UID: 0 PID: 0 Comm: swapper/0 Not tainted syzkaller #0 PREEMPT(ful=
l)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Call Trace:
>  <IRQ>
>  dump_stack_lvl+0x1a9/0x280
>  print_usage_bug+0x28b/0x2e0
>  mark_lock_irq+0x410/0x420
>  mark_lock+0x115/0x190
>  __lock_acquire+0x65c/0x2cd0
>  lock_acquire+0x116/0x340
>  _raw_spin_lock+0x2e/0x40
>  igrab+0x2d/0x1e0
>  ext4_put_io_end_defer+0x4d0/0x700
>  blk_update_request+0x57b/0xe30
>  scsi_end_request+0x77/0x820
>  scsi_io_completion+0x133/0x360
>  blk_done_softirq+0x10a/0x160
>  handle_softirqs+0x275/0x850
>  __irq_exit_rcu+0xd5/0x1f0
>  irq_exit_rcu+0x9/0x30
>  common_interrupt+0xbb/0xe0
>  </IRQ>
>  <TASK>
>  asm_common_interrupt+0x26/0x40
> RIP: 0010:pv_native_safe_halt+0xf/0x20
> Code: 57 5e 02 c3 cc cc cc cc cc cc cc 90 90 90 90 90 90 90 90 90 90 90 9=
0 90 90 90 90 f3 0f 1e fa eb 07 0f 00 2d d3 07 18 00 fb f4 <e9> cc f3 02 00=
 cc cc cc cc cc cc cc cc cc cc cc cc 90 90 90 90 90
> RSP: 0018:ffffffff8e007d80 EFLAGS: 00000286
> RAX: ec158cdc8cc84600 RBX: ffffffff8198983a RCX: ec158cdc8cc84600
> RDX: 0000000000000001 RSI: ffffffff8da4eee4 RDI: ffffffff8be557c0
> RBP: ffffffff8e007eb0 R08: ffff8881210336db R09: 1ffff110242066db
> R10: dffffc0000000000 R11: ffffed10242066dc R12: 1ffffffff1c12a78
> R13: dffffc0000000000 R14: 0000000000000000 R15: 1ffffffff1c00fbc
>  default_idle+0x9/0x20
>  default_idle_call+0x72/0xb0
>  do_idle+0x1ea/0x4e0
>  cpu_startup_entry+0x43/0x60
>  rest_init+0x2de/0x300
>  start_kernel+0x3a6/0x400
>  x86_64_start_reservations+0x24/0x30
>  x86_64_start_kernel+0x137/0x1b0
>  common_startup_64+0x13e/0x147
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
> [adilger.kernel@dilger.ca akpm@linux-foundation.org coregee2000@gmail.com=
 linux-ext4@vger.kernel.org linux-fsdevel@vger.kernel.org linux-kernel@vger=
.kernel.org linux-mm@kvack.org willy@infradead.org]
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
-upstream-moderation/6a505616.c76b52dc.2a15e.0004.GAE%40google.com.



--=20
=E2=B2=A0=E2=B2=9F=E2=B2=93=E2=B2=99=E2=B2=8F=E2=B2=9B =E2=B2=84=E2=B2=89=
=E2=B2=B1=E2=B2=A3=E2=B2=85=E2=B2=93=E2=B2=9F=E2=B2=A5 - Pimyn Girgis
Software Engineer
Kernel Dynamic Analysis
pimyn@google.com
