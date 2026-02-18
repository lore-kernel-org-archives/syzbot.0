Received: from mail-oa1-f48.google.com (mail-oa1-f48.google.com [209.85.160.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 278CD315D48
	for <syzbot@lists.linux.dev>; Wed, 18 Feb 2026 08:44:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771404260; cv=pass; b=SYdIhUXwqyRqDupQ6bvaARYAUteVZGASEi9urJIbwUd/HM+1hzbT2M8QXSA/obdC4uvwtiXBQauZIMjm/t+IzzYPJSl/Dz3YZdfpAHXqqgNKsogFf4+/+VY4E41lFBZVReyYiVhA3DrjGmjbYyeM/PQRWArmy08sOprTfuaHCow=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771404260; c=relaxed/simple;
	bh=icGb9rr0XUGWWGGIorgh0w2l6sFDSDRA989zEkNCCzU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=m74XnKr2Qj1Y166uFrknmRlm0tqvlyjPMjel2fSq/NS9RvtWubQJRK3trtqN4f19DmMJ189kh88sCQ4aUAgldxzuVs6EP5Z2fW8omXz29963Y/uGpfe+IiHDK6LHYTqmCs/mneMhW51blQNf8PsoXi/BmySm87VtFYL6Dwe69AE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KqhjsnOm; arc=pass smtp.client-ip=209.85.160.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KqhjsnOm"
Received: by mail-oa1-f48.google.com with SMTP id 586e51a60fabf-409470ad5bbso1870294fac.0
        for <syzbot@lists.linux.dev>; Wed, 18 Feb 2026 00:44:18 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771404258; cv=none;
        d=google.com; s=arc-20240605;
        b=ARHEGhbRZY0N2OuWRS0AGvYhD5Mf249MJWMFevHngfCZsZuLS+1L1WT8UjGvIWv+Pe
         WIU+v9CNse9csOAGHIuQr2nadNNdPxy4uCZkTdBM/80Js4NjyUWc6GPqV8/g34zPrlVL
         k+NiGuiEV+UpvpVmcZlLwGsPI9aSYYfEzEQPZFl+7xcKIatcLQ+Ncx9UF1WbJZ8tKJJ0
         qEWOdL6qWVuh8lFn09FVZAWxEgUauPi8H4RiawySuZIot2YdpBOqLstRDD/B0VFMvUTh
         j/AyaWREoRrTll5w1jDw1yOpu//IrL8W8PHm4FYqPSbje+6BI24bJwZe6BDZDqzvJbFr
         zmDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=aqSVAM6fOC5z63G48n0XBE2X/fJO0n27PuBhcTjhqYs=;
        fh=z4e2LfFgKiYYbrbp+4UJn6f70c+z2DbSX0ukrTBxEB4=;
        b=Yzpbzc/5v8GpDhcmIplVtkPCtYP2ZJ+m2oBAhA5G2jKtg3aZk3dRk0zsrA4wLt+bOU
         rjwkK8Rgxn+Thq6/18paAVwb491zJFBY/rc8JUejFsmrgMf/o5K3H2drJD2SYjcH24jw
         feXqiWhAMHwphwKFGbxLfsiMj2qEl89Roy/+0PLuqGLgGei7J/nUM/hSLrJQDpOXQDX1
         ovMqYMX+Z0qcNp0eiel9tF8o1dcZadgFUEwQSXgrtj1vDTwxd0IIHi8Q3lASYvsUtI3Q
         7QIv2n83PGFN7D27SotppakhEHvulSgfR0kHyuHUf4n5kV4QLy2nMGvotIvSmoxNO4AL
         g1Iw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771404258; x=1772009058; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aqSVAM6fOC5z63G48n0XBE2X/fJO0n27PuBhcTjhqYs=;
        b=KqhjsnOmG7xa9XJwTt9h7obrQM3dJaUdxorYpLxaoOAI4zMtm830rJamQ75qEPGEXJ
         I3t34/abOE3W0cENprmT7U/bD86efUljjklph7R2dhrX2Bzhk3S9uYxZBOXuHy7o8RGz
         7PHpBoTumpt9z/uFDBsmiKlmegRaV96GPiPq2oxJdTh+f0v7bxtBzrdRZAI/8e0VGWfV
         6MKpqtX8VBfrl9/Sfmt8rH1Grf9bNOlcu8Q8JEnzIBt/tV0Dp4/2IcHlAmOhJWFcAj0O
         xReiLltqw6oqA5stwZuxF3o3GXvBK5DO3xZZWluI9YOzniGxEOtxMCtYdF/Wo+bFkPcY
         ctpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771404258; x=1772009058;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=aqSVAM6fOC5z63G48n0XBE2X/fJO0n27PuBhcTjhqYs=;
        b=WJpzjXfSO6BR/WovX9XrPsKeZisJYnNsdiHmlD9uVDu6JIuj1+Eb6nYoKsc6Rg0JVh
         aJ2iq+UnkjNEcihaw786aOpKGyKWaIxvIV86VRpluwe/eK2TCJm8OqjRgoRPnq/rF09R
         xEY3dt1ol+3IYEu8WFU/WMjkJbS5B6j51Kjn+n69RNNuLul0jrvtNCY6Lt0qGOm+TxTf
         CJD2YIZ5HKbZnEA/VOzP6BJr0ckOIEm3uFziMGwUjRkCtAHfGyhCpveHMUOOyuZHKiVV
         WKNIq0Wsx6IrOl86F6bpOCcv/9dP9PzuYfzwtWYOapYBekrpxYDOQNCe5wK13CBCXtds
         mJgw==
X-Forwarded-Encrypted: i=1; AJvYcCXdgLvydJuit6o1bIIZ3e5dbwehcBctr3XHbAITp+LyqVhzdCvZxr9oLgY5VlA4ZGtQkpYxrY4=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz0z9EUmYXDxdtzfYuhzgYPUXAJ9ou5gzs56gFs4brB6WoLcGb9
	lY2MJIQf9zM7KA/nB/8A3JXpAJ7oD218k+N04gum0XV+tek2zyV09TQffjC1q4A8OxevNV8IFUY
	4uO0WLX+ogleV40+miRvOsMEtS3Y4UMA5ViyqWykS
X-Gm-Gg: AZuq6aIX+7Owk1h9pdev7VvoBUW3tYbZMh70aYRpLCw4oiKajh37FtC1Wtn5IjdQUdd
	6gwcSBVQTmUQLuv523p3r4Pnn6HiYw2nxUjfbKNs3NLQdAyx5LIPniAGsWYdQKqSG+Wrf7tRydK
	kYLkdvx4mkfFkSMCGov6Lx8Yiw1nGpZ1uRr8SMasEebKOBLC7nFUmJWEPp4Z0nYiv+u34U5clIK
	bqg+ZzaAv0jruLL25JHIWNM/o2nWpXruPBp3fNRyGBkhvJnARlYFc7W5fvA3jK35jtnLsUQZQRB
	eCQtNVTXD/1ezuRWAWta5qRc8B6BpijiGZjRjRHquSaxsiTAleppJE/etcmE6yJfapN34A==
X-Received: by 2002:a05:6870:a0a6:b0:40e:e9f4:90f5 with SMTP id
 586e51a60fabf-40f0d997a2bmr7945162fac.58.1771404257436; Wed, 18 Feb 2026
 00:44:17 -0800 (PST)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <69956660.a70a0220.2c38d7.0116.GAE@google.com>
In-Reply-To: <69956660.a70a0220.2c38d7.0116.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Wed, 18 Feb 2026 09:44:05 +0100
X-Gm-Features: AaiRm53EU5jSEHYr-hBOdU_oiYxGn_CB-I1jyRE-ynhm7Mhry-SzU0Zk-JAuXsU
Message-ID: <CANp29Y6S57-kFdQha0yE33Fr8it8rtNju=Lm00RSJUgsUoQgYA@mail.gmail.com>
Subject: Re: [moderation/CI] Re: io_uring: add kernel-managed buffer rings
To: syzbot ci <syzbot+ci1a95bed2e5ad3303@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Wed, Feb 18, 2026 at 8:12=E2=80=AFAM syzbot ci
<syzbot+ci1a95bed2e5ad3303@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v2] io_uring: add kernel-managed buffer rings
> https://lore.kernel.org/all/20260218025207.1425553-1-joannelkoong@gmail.c=
om
> * [PATCH v2 1/9] io_uring/memmap: chunk allocations in io_region_allocate=
_pages()
> * [PATCH v2 2/9] io_uring/kbuf: add support for kernel-managed buffer rin=
gs
> * [PATCH v2 3/9] io_uring/kbuf: support kernel-managed buffer rings in bu=
ffer selection
> * [PATCH v2 4/9] io_uring/kbuf: add buffer ring pinning/unpinning
> * [PATCH v2 5/9] io_uring/kbuf: return buffer id in buffer selection
> * [PATCH v2 6/9] io_uring/kbuf: add recycling for kernel managed buffer r=
ings
> * [PATCH v2 7/9] io_uring/kbuf: add io_uring_is_kmbuf_ring()
> * [PATCH v2 8/9] io_uring/kbuf: export io_ring_buffer_select()
> * [PATCH v2 9/9] io_uring/cmd: set selected buffer index in __io_uring_cm=
d_done()
>
> and found the following issue:
> general protection fault in io_remove_buffers_legacy
>
> Full report is available here:
> https://ci.syzbot.org/series/ddeaf464-c69b-4166-b0cf-53c9d51e4820
>
> ***
>
> general protection fault in io_remove_buffers_legacy
>
> tree:      torvalds
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torva=
lds/linux
> base:      2961f841b025fb234860bac26dfb7fa7cb0fb122
> arch:      amd64
> compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~e=
xp1~20251221153213.50), Debian LLD 21.1.8
> config:    https://ci.syzbot.org/builds/ab5ad5aa-2757-4d66-a2c5-391a84175=
35d/config
> C repro:   https://ci.syzbot.org/findings/061747e2-36f1-499b-ac34-38cefff=
bce63/c_repro
> syz repro: https://ci.syzbot.org/findings/061747e2-36f1-499b-ac34-38cefff=
bce63/syz_repro
>
> Oops: general protection fault, probably for non-canonical address 0xdfff=
fc0000000001: 0000 [#1] SMP KASAN PTI
> KASAN: null-ptr-deref in range [0x0000000000000008-0x000000000000000f]
> CPU: 1 UID: 0 PID: 5967 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:__list_del_entry_valid_or_report+0x25/0x190 lib/list_debug.c:49
> Code: 90 90 90 90 90 f3 0f 1e fa 41 57 41 56 41 55 41 54 53 48 89 fb 49 b=
d 00 00 00 00 00 fc ff df 48 83 c7 08 48 89 f8 48 c1 e8 03 <42> 80 3c 28 00=
 74 05 e8 df 8c 77 fd 4c 8b 7b 08 48 89 d8 48 c1 e8
> RSP: 0018:ffffc900040a7b68 EFLAGS: 00010202
> RAX: 0000000000000001 RBX: 0000000000000000 RCX: 1ffff11035ee2732
> RDX: 1ffff11035ee2730 RSI: 00000000ffffffff RDI: 0000000000000008
> RBP: dffffc0000000000 R08: ffff8881af7139b7 R09: 0000000000000000
> R10: ffff8881af7139a0 R11: ffffed1035ee2737 R12: ffff8881af713980
> R13: dffffc0000000000 R14: 00000000ffffffff R15: 0000000000000000
> FS:  0000555560587500(0000) GS:ffff8882a9466000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000200000001000 CR3: 0000000175cd2000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  __list_del_entry_valid include/linux/list.h:132 [inline]
>  __list_del_entry include/linux/list.h:223 [inline]
>  list_del include/linux/list.h:237 [inline]
>  io_remove_buffers_legacy+0x139/0x310 io_uring/kbuf.c:533
>  io_put_bl+0x62/0x120 io_uring/kbuf.c:548
>  io_register_pbuf_ring+0x6c0/0x7d0 io_uring/kbuf.c:855
>  __io_uring_register io_uring/register.c:838 [inline]
>  __do_sys_io_uring_register io_uring/register.c:1024 [inline]
>  __se_sys_io_uring_register+0xc3e/0x19a0 io_uring/register.c:1001
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f056859bf79
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007fffd8dcfaf8 EFLAGS: 00000246 ORIG_RAX: 00000000000001ab
> RAX: ffffffffffffffda RBX: 00007f0568815fa0 RCX: 00007f056859bf79
> RDX: 0000200000000040 RSI: 0000000000000016 RDI: 0000000000000004
> RBP: 00007f05686327e0 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000001 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f0568815fac R14: 00007f0568815fa0 R15: 00007f0568815fa0
>  </TASK>
> Modules linked in:
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:__list_del_entry_valid_or_report+0x25/0x190 lib/list_debug.c:49
> Code: 90 90 90 90 90 f3 0f 1e fa 41 57 41 56 41 55 41 54 53 48 89 fb 49 b=
d 00 00 00 00 00 fc ff df 48 83 c7 08 48 89 f8 48 c1 e8 03 <42> 80 3c 28 00=
 74 05 e8 df 8c 77 fd 4c 8b 7b 08 48 89 d8 48 c1 e8
> RSP: 0018:ffffc900040a7b68 EFLAGS: 00010202
> RAX: 0000000000000001 RBX: 0000000000000000 RCX: 1ffff11035ee2732
> RDX: 1ffff11035ee2730 RSI: 00000000ffffffff RDI: 0000000000000008
> RBP: dffffc0000000000 R08: ffff8881af7139b7 R09: 0000000000000000
> R10: ffff8881af7139a0 R11: ffffed1035ee2737 R12: ffff8881af713980
> R13: dffffc0000000000 R14: 00000000ffffffff R15: 0000000000000000
> FS:  0000555560587500(0000) GS:ffff8882a9466000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f25f1e17095 CR3: 0000000175cd2000 CR4: 00000000000006f0
> ----------------
> Code disassembly (best guess):
>    0:   90                      nop
>    1:   90                      nop
>    2:   90                      nop
>    3:   90                      nop
>    4:   90                      nop
>    5:   f3 0f 1e fa             endbr64
>    9:   41 57                   push   %r15
>    b:   41 56                   push   %r14
>    d:   41 55                   push   %r13
>    f:   41 54                   push   %r12
>   11:   53                      push   %rbx
>   12:   48 89 fb                mov    %rdi,%rbx
>   15:   49 bd 00 00 00 00 00    movabs $0xdffffc0000000000,%r13
>   1c:   fc ff df
>   1f:   48 83 c7 08             add    $0x8,%rdi
>   23:   48 89 f8                mov    %rdi,%rax
>   26:   48 c1 e8 03             shr    $0x3,%rax
> * 2a:   42 80 3c 28 00          cmpb   $0x0,(%rax,%r13,1) <-- trapping in=
struction
>   2f:   74 05                   je     0x36
>   31:   e8 df 8c 77 fd          call   0xfd778d15
>   36:   4c 8b 7b 08             mov    0x8(%rbx),%r15
>   3a:   48 89 d8                mov    %rbx,%rax
>   3d:   48                      rex.W
>   3e:   c1                      .byte 0xc1
>   3f:   e8                      .byte 0xe8
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
> [asml.silence@gmail.com axboe@kernel.dk bernd@bsbernd.com csander@puresto=
rage.com hch@infradead.org io-uring@vger.kernel.org joannelkoong@gmail.com]
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
-upstream-moderation/69956660.a70a0220.2c38d7.0116.GAE%40google.com.
