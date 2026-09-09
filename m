Received: from mail-ot1-f42.google.com (mail-ot1-f42.google.com [209.85.210.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDA443D3D00
	for <syzbot@lists.linux.dev>; Wed,  9 Sep 2026 07:07:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788937674; cv=pass; b=KxAAPSsVbQdZqw94+k9nACvB9Uj2qyo7zdKaZ4CB7oQrViV7Rbod1Y1xvhz+WX4IQIJ5L+xo0+2NJYFZ+FczTgmaER7jid/C72TjLqUrMcQ4PH/Pl3mthBZcE8tfHXQPwtN829ZHYe26lidKLNDsqAPbb01XR4TnXSFdtXK5HSE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788937674; c=relaxed/simple;
	bh=0+SXt9+Mr1E+6PDYlROkAlLp1jy6uYiRpA/8GArGaRY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gyr/DA+KPOG3w57RiRvb47z0wCg7wssak4gViDdD1EyzebTD+99PdRv0A0qP3Y++i/NNSpaNxDa6P/kBnfSv3flcExlzLpFf0hmv8d5cBwTSlCrTIC8zDa/hLJseAHcULCdPKX92OmJQwQIBUQIh83F5BR6+2H3m5FW9HfT8MUc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=uD2LGgVp; arc=pass smtp.client-ip=209.85.210.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="uD2LGgVp"
Received: by mail-ot1-f42.google.com with SMTP id 46e09a7af769-7f4e729368fso4713251a34.0
        for <syzbot@lists.linux.dev>; Wed, 09 Sep 2026 00:07:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788937670; cv=none;
        d=google.com; s=arc-20260327;
        b=WSlnZ6raRCEB8WAMOcvTU8xMFPlWn667WD+4oIKsYeFYDVpMtL+G2xfiDwGThgXYQa
         zT9K5mjQahgtSrHVm4RbnwT1TdEre+QxZFT00liLxLVQq/GMpvFWLnTbyHK37jBwNVdE
         4QBO8obKRdLV4a0C78DZ9RmQUWlwmHNlQPEpqZTzeaaNDvkBc7qhFpC8R7QTPHYlA7bc
         oJbZjpaPD1lk3150Kg0ijNr01GTHuGFyMNf28XFqf7Vy/9vNxqlt5tQvWEI082f7wH8I
         10YdzBSrLOb4WFcPOEuStDC6DMPp7QNuR02/+FAEZbDjRKzM4zcCmDXoUcIPYnlWEx/Z
         ZoXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=I/pLSZyXU6PCA3dKzgHr3wxK4vwdapheAXzR8O5CzBw=;
        fh=+gkkTEeV6X0kyRF91OCeag04v9bbVIQvZV9nn7DHj1Y=;
        b=da+KeNoXlLxLw5/mhqg5dkRBbWzmMmGmg6tbrLYtQApXO7yrLoW0PNjefm4Jh7S07E
         +2pEZivpicbms/nTje138aCST0aMurNi3tKmX2DXg6x3IkwC9N5BQMUHHxJ0aSbmpKfM
         n86oiH2wggyV5IAuwU9dj/WYmH0RjioCcLuwU2YOdLl6MtKcdLaQe/dHL5+MAYyOxu7I
         LGxJKqHR98A/w6aM1eNzRbNzmp4nS+2Hzw8FHK0qx1ZNfDa5epE6fdM0Kyel2cX3MhD/
         SbKySJE+8iwMGwJpeAhRrV4joz/ggFuwa1zS2qFFao+uK+fSrFM0MCNFJZG6dA1lZEf7
         JYAw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788937670; x=1789542470; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=I/pLSZyXU6PCA3dKzgHr3wxK4vwdapheAXzR8O5CzBw=;
        b=uD2LGgVpgSv5r1UAAw2RO9sVKPjVwBqMJbHYt2kzn95cztfqtSRl/v7Bc3FlFSgwhF
         w8cumb4jFAIsg4BWcZcen948DY/jazeOVMhxTX+c98hFxwkt4NjvkUBppuZUjNaqR+dE
         q47+mScVKw94KOiXefZxUXG59Ce9enh4J5o70RdX3l+0XxBT2nBxwgzt2xMSCY1j1nrM
         MNzQmodDHITAe+Nsotns4pmHTmlOp/3tVFmmX04v/1H0n5C14/PPcVUESA3vvUPe60Ux
         nvT1NMlS0BBTXAi+/mA6GU9DCTXr8IzWo7THlRLuHC3Ijl8jMNR51biaZ6rfbxQSBy86
         c1Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788937670; x=1789542470;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=I/pLSZyXU6PCA3dKzgHr3wxK4vwdapheAXzR8O5CzBw=;
        b=DTvfXpeM0+KZQ4BDNIg8bKDiJqns7tGlRYHLU3Ng3f66wN26ulTt3Mk+Q80FlC2XyP
         lngp7lOz2cwizv4Q0wxEuHIKEDe/fTuwrY6wcRok6jlVU46VI7khGExoKm2dmasGutep
         5mAla/nx12PRY4fEJafnH/pXay+KL7wQYwZ+u1T7D0N1bBPnTxhLMR7M7L+l7YIh1YTw
         Ch3orilJB+7grGeO6iqWp3AKMA8PmGG1BwLLP9TfqYJ8S8LlJ0k6Y5RGiPghxEmRljJO
         PtRsEDCF6LK6lZ+DS1J1bVvTZSj1djCkiYLy5xjU8HCSwBbDH9/F4X7yvL64XvrCtXIA
         5ZPw==
X-Forwarded-Encrypted: i=1; AKwUvBzyYInCjozolcYe2l9T7GHi0AYWPc4T4KICkFSZ6xPGpcvQN9iSlHXS0M5OOltFlqQv8ESjSys=@lists.linux.dev
X-Gm-Message-State: AFuF++nJbVLr1xgvIOqy0u7l6xGs8ryTYICRZ1OEBNQZ0GHTUKuxYRHg
	p+AVYpZwZRlnp4p1wS2u3xmGDd163riMWj07JYIn81y86Ecm3LJQkhENET4K6fV8Ke4bYT/dq8N
	EVCtCNvem3lNGJ6M515nO4a7xMiP3k6bq/Dkv6vln
X-Gm-Gg: AYBFou0TnKKZY2F2uUvXmgFRS0Hz/V5kLgSsQIQAYhKVIFJxSlYMVrM1USUEMfQ7ndv
	i307w5YPpFUHzR3NLvx4YUce67JJS7Em1Nj/O12rfxJ6PvQK0PS5QsgcQuQWQYe1A9WRU8stp2X
	/Fnb+N2U2hniv7xbcTxDCIpXeFF1Rty8ybk/Hf93vMWqZdzMPSNEaYVxXPlxEoFBiYiN3MFr3IX
	ul1+zkzC6FVu9e212zIUH9RC7jV5vfbaVG0vgWnUpUDPfjkf+NPkKJVcNfOrscZsg6uKaPuk79c
	R22pWq+6EjnuETNUIofmlR3h31WoJJ3HOAZ1Obil7zCQFuU1I0e+oDUD8Qdt9jycORJek1HMJBX
	jiNSF9Jm/zzBnRIOKVOicYt5CDCSe65wsDKIcdBNnj3mthOtQkHv6KLMZXx+WSnMkPJUw3DpBfI
	9irj2nszOkvmNSzX6Q73Y7PLA=
X-Received: by 2002:a05:6830:4987:b0:7fa:ac4f:785 with SMTP id
 46e09a7af769-7faac4f0f32mr18626741a34.17.1788937669869; Wed, 09 Sep 2026
 00:07:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <6aa0ce0f.f81106d8.285f0a.0008.GAE@google.com>
In-Reply-To: <6aa0ce0f.f81106d8.285f0a.0008.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Wed, 9 Sep 2026 09:07:37 +0200
X-Gm-Features: AcwNN1W3qxoCbXN6izX3WUKw5PoKwz-iSEPupkinz59cy9zJ7k30uOMaH6iwZWU
Message-ID: <CANp29Y7Y8Z0VfL_qXv_8hrQD_qPPZRqv1N0eufG8ztqCsocx8A@mail.gmail.com>
Subject: Re: [moderation/CI] Re: hfsplus: convert regular file I/O to
 iomap-based operations
To: syzbot ci <syzbot+ci823a0e2cb68b1a0a@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

The crash is unrelated to hfs.

#syz invalid

On Wed, Sep 9, 2026 at 5:10=E2=80=AFAM syzbot ci
<syzbot+ci823a0e2cb68b1a0a@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v3] hfsplus: convert regular file I/O to iomap-based operations
> https://lore.kernel.org/all/20260908210448.296772-1-slava@dubeyko.com
> * [PATCH v3 1/7] hfs/hfsplus: exchange hardcoded number of extents on nam=
ed constants
> * [PATCH v3 2/7] hfsplus: rework hfsplus_get_block() logic
> * [PATCH v3 3/7] hfsplus: take the bitmap page lock for allocate/free
> * [PATCH v3 4/7] hfsplus: add iomap operations for regular file data
> * [PATCH v3 5/7] hfsplus: move file related operations to file.c
> * [PATCH v3 6/7] hfsplus: introduce iomap-based file_operations
> * [PATCH v3 7/7] hfsplus: switch address_space_operations on iomap-based =
support
>
> and found the following issue:
> general protection fault in __bh_submit
>
> Full report is available here:
> https://ci.syzbot.org/series/38a0586d-f4cb-4955-aebf-8908d87645ed
>
> ***
>
> general protection fault in __bh_submit
>
> tree:      vfs
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/vfs/v=
fs.git
> base:      21860bb220225edeb87e9c831e6bf25c620e2126
> arch:      amd64
> compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~e=
xp1~20260613092250.77), Debian LLD 22.1.8
> config:    https://ci.syzbot.org/builds/fca9c940-9a44-4e03-8515-7d438025f=
0e2/config
> syz repro: https://ci.syzbot.org/findings/e6b3388b-2033-41f8-b2d7-55ceca2=
562f6/syz_repro
>
> Oops: general protection fault, probably for non-canonical address 0xdfff=
fc0000000001: 0000 [#1] SMP KASAN PTI
> KASAN: null-ptr-deref in range [0x0000000000000008-0x000000000000000f]
> CPU: 1 UID: 0 PID: 5002 Comm: jbd2/sda1-8 Not tainted syzkaller #0 PREEMP=
T(full)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:const_folio_flags include/linux/page-flags.h:345 [inline]
> RIP: 0010:folio_test_dropbehind include/linux/page-flags.h:601 [inline]
> RIP: 0010:__bh_submit+0x22d/0x8d0 fs/buffer.c:1108
> Code: c1 e8 03 48 89 44 24 18 42 80 3c 20 00 74 08 48 89 df e8 86 e1 d7 f=
f 48 89 5c 24 28 48 8b 1b 4c 8d 7b 08 4c 89 f8 48 c1 e8 03 <42> 80 3c 20 00=
 74 08 4c 89 ff e8 64 e1 d7 ff 4d 8b 3f 4c 89 fe 48
> RSP: 0018:ffffc9000fe07868 EFLAGS: 00010202
> RAX: 0000000000000001 RBX: 0000000000000000 RCX: ffffffff84b8b669
> RDX: 0000000000000001 RSI: 0000000000000004 RDI: ffff888169ab56a0
> RBP: 0000000000009801 R08: ffff888169ab56ff R09: 1ffff1102d356adf
> R10: dffffc0000000000 R11: ffffed102d356ae0 R12: dffffc0000000000
> R13: ffff888169ab5680 R14: ffff88811d795700 R15: 0000000000000008
> FS:  0000000000000000(0000) GS:ffff8882a8cd5000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007fb21ba27dac CR3: 000000000eb48000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  jbd2_journal_commit_transaction+0x22a9/0x5cd0 fs/jbd2/commit.c:751
>  kjournald2+0x3bc/0x750 fs/jbd2/journal.c:200
>  kthread+0x38b/0x480 kernel/kthread.c:436
>  ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
>  </TASK>
> Modules linked in:
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:const_folio_flags include/linux/page-flags.h:345 [inline]
> RIP: 0010:folio_test_dropbehind include/linux/page-flags.h:601 [inline]
> RIP: 0010:__bh_submit+0x22d/0x8d0 fs/buffer.c:1108
> Code: c1 e8 03 48 89 44 24 18 42 80 3c 20 00 74 08 48 89 df e8 86 e1 d7 f=
f 48 89 5c 24 28 48 8b 1b 4c 8d 7b 08 4c 89 f8 48 c1 e8 03 <42> 80 3c 20 00=
 74 08 4c 89 ff e8 64 e1 d7 ff 4d 8b 3f 4c 89 fe 48
> RSP: 0018:ffffc9000fe07868 EFLAGS: 00010202
> RAX: 0000000000000001 RBX: 0000000000000000 RCX: ffffffff84b8b669
> RDX: 0000000000000001 RSI: 0000000000000004 RDI: ffff888169ab56a0
> RBP: 0000000000009801 R08: ffff888169ab56ff R09: 1ffff1102d356adf
> R10: dffffc0000000000 R11: ffffed102d356ae0 R12: dffffc0000000000
> R13: ffff888169ab5680 R14: ffff88811d795700 R15: 0000000000000008
> FS:  0000000000000000(0000) GS:ffff8882a8cd5000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 000035dc4b324000 CR3: 00000001bb4be000 CR4: 00000000000006f0
> ----------------
> Code disassembly (best guess):
>    0:   c1 e8 03                shr    $0x3,%eax
>    3:   48 89 44 24 18          mov    %rax,0x18(%rsp)
>    8:   42 80 3c 20 00          cmpb   $0x0,(%rax,%r12,1)
>    d:   74 08                   je     0x17
>    f:   48 89 df                mov    %rbx,%rdi
>   12:   e8 86 e1 d7 ff          call   0xffd7e19d
>   17:   48 89 5c 24 28          mov    %rbx,0x28(%rsp)
>   1c:   48 8b 1b                mov    (%rbx),%rbx
>   1f:   4c 8d 7b 08             lea    0x8(%rbx),%r15
>   23:   4c 89 f8                mov    %r15,%rax
>   26:   48 c1 e8 03             shr    $0x3,%rax
> * 2a:   42 80 3c 20 00          cmpb   $0x0,(%rax,%r12,1) <-- trapping in=
struction
>   2f:   74 08                   je     0x39
>   31:   4c 89 ff                mov    %r15,%rdi
>   34:   e8 64 e1 d7 ff          call   0xffd7e19d
>   39:   4d 8b 3f                mov    (%r15),%r15
>   3c:   4c 89 fe                mov    %r15,%rsi
>   3f:   48                      rex.W
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
> To test a fix for this bug, please reply with `#syz test`
> (on a separate line) and attach the patch to the email.
>
> Notes:
> - The patch will be applied on top of the tested series (as an
>   incremental fix).
> - To test a new version of the whole series, please send it directly
>   to syzbot@lists.linux.dev.
> - Arguments like custom git repos and branches are not supported.
>
> The email will later be sent to:
> [brauner@kernel.org djwong@kernel.org frank.li@vivo.com glaubitz@physik.f=
u-berlin.de hch@lst.de linux-fsdevel@vger.kernel.org linux-kernel@vger.kern=
el.org slava@dubeyko.com vdubeyko@coreweave.com willy@infradead.org]
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
-upstream-moderation/6aa0ce0f.f81106d8.285f0a.0008.GAE%40google.com.
