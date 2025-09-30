Received: from mail-oa1-f42.google.com (mail-oa1-f42.google.com [209.85.160.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 034F7212557
	for <syzbot@lists.linux.dev>; Tue, 30 Sep 2025 11:15:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759230930; cv=none; b=MxCTeE5kkItmLIuF7sDRpjSids7t7WxplkaqYTE8mzPHYAgI6yzVBngf94tQCBV/M4kDLLWtGsqDOMtIplrlLHANTcVfLf/NI86+sApUdLHf6RNdjbTjsipD5PA+noq7VBo9ihWsMxPPBGgmc1aSm6qqONg4VlavxD9woGPgBdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759230930; c=relaxed/simple;
	bh=GZBg/dCtLwZ8ljoj07+8O4P9gcylY/l8Hiat8tFQJcQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qShS2NqfA9+jFqzK5G1rPZOqzwAoXh2ehhUaxXnRzoIPpgLtlMCwfKiqVnVJIz2whqI7OBt61Eg0uxeMFlARYXatAgWFQQQ28RHPU2oTBvwu4gQWmuw6z4ZpyhGEthOKkpD+RFB+B/f7ln4J8hFwE/XTT3zX5htHM5ZT4wZbT4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KOB3PBVt; arc=none smtp.client-ip=209.85.160.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KOB3PBVt"
Received: by mail-oa1-f42.google.com with SMTP id 586e51a60fabf-364bd7cce53so3904967fac.3
        for <syzbot@lists.linux.dev>; Tue, 30 Sep 2025 04:15:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759230928; x=1759835728; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kLGfv8iejndVi+xk1Vt3HWZ1kzJ3Dd6iFzMuqEKJ/8Y=;
        b=KOB3PBVtab+gWrpWue48EsjRwuJrjPGz1n+s8j/8zu+5UGwg+zJz/kyZeztuG/Kyds
         qRfobndM0FrCA87+VTNJfDBN+mw9KJq6+CFrPCC6c7vDb4mY8MSfMpln8LVmcEdTGTAU
         8Z0gjCouFCEuq2Iw3VtwAV2XfeKZsoy6VRwyIRbT8QTCt32Tpe3qR1IzEyD3i0w1Ko+4
         yVYWiHlPgAtnOR49wg9jjI2mPgiN4YFlPAYegI439SUBaNOQSZ+dal+YQN8qXFsHClpV
         WZsGp56pIN4RraiS/YdJ4kvfJjsHF93Rzwv7Eu5nm8sRlJ+dg+dmTWJKkYqzIRelOm50
         cwlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759230928; x=1759835728;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kLGfv8iejndVi+xk1Vt3HWZ1kzJ3Dd6iFzMuqEKJ/8Y=;
        b=U1Y33qFn92MTk6lyGLVDc3VU7v1f+xDPdJEYasbScFtXuCJatmXlLOMG0R4djkJDdd
         yO0XDdYE4dgDHVz6KH5nsqCIFk6h9DNcgi7nkesTtLOLBgdCYOQhrDqfKqxQmcm/eSTn
         YtzvQJYgKlHaPqtxiQBXWSNxq5BSl1jyXeN6fQoTnXVGmvAOQMlRzxA1ATj56BM+lgQ/
         FTEH8EaMbbf4sAwyOM+94tmn0N95as9uLjObClG7YnoAlhXIzdbsw1MiTYJ7Kytrt3P5
         7CF/ZNfF3Oq5udPiERiSnK5KN5DOvxQWubhMuE+BZrfDF0uRGwuDZSPUmVjyEGGBKYgb
         OpDw==
X-Forwarded-Encrypted: i=1; AJvYcCWwflsLQoGxK6tXRUnHuI1cWRHJ3UvtN/aH5jYWGmppZTaRXwj85w0waZc4DbSY3g4+3eJNITw=@lists.linux.dev
X-Gm-Message-State: AOJu0YwUsXa9pSoGWEfYjtXzixyVpqXOWmid4CE75L8aUUb6GVmGt69f
	SAUsSqxS6yGQj3iiB9mXIe4Tc1Il8PgZ97LdHp3GeM3BQjRB+03H8yZOQWJv1/yY5/YI6GjkE/l
	Hg1j/AF3407oEb//gsoo8NeJUtdLml6/pcUP9pGOH
X-Gm-Gg: ASbGnctqTwqdwis0X+AvUFPE1UD9ZnwjTyyxLM8BGekTFgFmwcuKsGpdMVxbll2te3a
	hWzbgupl8EvZ/xelWiY0Bpa0xvez9W4YD6oZ6D0JxKOM2sAoImet/qHq2D7/9avqeV5MvCMZG00
	0iSK4d1acXv1Tx1oHRosYTpO/2oq91ubbjJYqZHqBBBLbGetN9TCZSND9KY0bkrmcb+/ha8Zm6z
	M6A/xD1EFf9KOSGWHG6tbmTNy9kQ5Peo8D6/Tww1wYlLD0TwilJLh0hvE/s96y9atB4hxk=
X-Google-Smtp-Source: AGHT+IGgtb0rR/uYtItOg0MnuaibK2VvGKEukhJ5D41iP3HC11W/hPh9ciVg9D8/p9HEL7lgERyGw2dfaquTysgQOVw=
X-Received: by 2002:a05:6870:888d:b0:377:1334:fe8e with SMTP id
 586e51a60fabf-3771335253dmr6427094fac.35.1759230927745; Tue, 30 Sep 2025
 04:15:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <68dbbaa1.a70a0220.10c4b.0154.GAE@google.com>
In-Reply-To: <68dbbaa1.a70a0220.10c4b.0154.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Tue, 30 Sep 2025 13:15:16 +0200
X-Gm-Features: AS18NWBQe4e36q91AOz5hbK91pzpPAzGz8UsGjmveGyzXsNxzWXn58vlVRGSCIE
Message-ID: <CANp29Y5d_KkPJLN3Y5fxuYtW8f15MJFzm+vYkV+kPKY5HxmVhw@mail.gmail.com>
Subject: Re: [moderation/CI] Re: mm/rmap: fix soft-dirty and uffd-wp bit loss
 when remapping zero-filled mTHP subpage to shared zeropage
To: syzbot ci <syzbot+ci8409f4b8a5a5f1bf@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Tue, Sep 30, 2025 at 1:10=E2=80=AFPM syzbot ci
<syzbot+ci8409f4b8a5a5f1bf@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v4] mm/rmap: fix soft-dirty and uffd-wp bit loss when remapping zero-fil=
led mTHP subpage to shared zeropage
> https://lore.kernel.org/all/20250930071053.36158-1-lance.yang@linux.dev
> * [PATCH v4 1/1] mm/rmap: fix soft-dirty and uffd-wp bit loss when remapp=
ing zero-filled mTHP subpage to shared zeropage
>
> and found the following issue:
> general protection fault in remove_migration_pte
>
> Full report is available here:
> https://ci.syzbot.org/series/8cc7e52f-a859-4251-bd08-9787cdaf7928
>
> ***
>
> general protection fault in remove_migration_pte
>
> tree:      linux-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/next/=
linux-next
> base:      262858079afde6d367ce3db183c74d8a43a0e83f
> arch:      amd64
> compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~e=
xp1~20250708183702.136), Debian LLD 20.1.8
> config:    https://ci.syzbot.org/builds/97ee4826-5d29-472d-a85d-51543b0e4=
5de/config
> C repro:   https://ci.syzbot.org/findings/f4819db2-21f2-4280-8bc4-9424453=
98953/c_repro
> syz repro: https://ci.syzbot.org/findings/f4819db2-21f2-4280-8bc4-9424453=
98953/syz_repro
>
> Oops: general protection fault, probably for non-canonical address 0xdfff=
fc0000000000: 0000 [#1] SMP KASAN PTI
> KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
> CPU: 0 UID: 0 PID: 6025 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:ptep_get include/linux/pgtable.h:340 [inline]
> RIP: 0010:remove_migration_pte+0x369/0x2320 mm/migrate.c:352
> Code: 00 48 8d 43 20 48 89 44 24 68 49 8d 47 40 48 89 84 24 e8 00 00 00 4=
c 89 64 24 48 4c 8b b4 24 50 01 00 00 4c 89 f0 48 c1 e8 03 <42> 80 3c 28 00=
 74 08 4c 89 f7 e8 f8 3e ff ff 49 8b 06 48 89 44 24
> RSP: 0018:ffffc90002fb73e0 EFLAGS: 00010246
> RAX: 0000000000000000 RBX: ffff88802957e300 RCX: 1ffffd40008c9006
> RDX: 0000000000000000 RSI: 0000000000030dff RDI: 0000000000030c00
> RBP: ffffc90002fb75d0 R08: 0000000000000003 R09: 0000000000000004
> R10: dffffc0000000000 R11: fffff520005f6e34 R12: ffffea0004648008
> R13: dffffc0000000000 R14: 0000000000000000 R15: ffffea0004648000
> FS:  00005555624de500(0000) GS:ffff8880b83fc000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000200000000300 CR3: 000000010d8b8000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  rmap_walk_anon+0x553/0x730 mm/rmap.c:2855
>  remove_migration_ptes mm/migrate.c:469 [inline]
>  migrate_folio_move mm/migrate.c:1381 [inline]
>  migrate_folios_move mm/migrate.c:1711 [inline]
>  migrate_pages_batch+0x202e/0x35e0 mm/migrate.c:1967
>  migrate_pages_sync mm/migrate.c:1997 [inline]
>  migrate_pages+0x1bcc/0x2930 mm/migrate.c:2106
>  migrate_to_node mm/mempolicy.c:1244 [inline]
>  do_migrate_pages+0x5ee/0x800 mm/mempolicy.c:1343
>  kernel_migrate_pages mm/mempolicy.c:1858 [inline]
>  __do_sys_migrate_pages mm/mempolicy.c:1876 [inline]
>  __se_sys_migrate_pages+0x544/0x650 mm/mempolicy.c:1872
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7fb18e18ec29
> Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffdca5c9838 EFLAGS: 00000246 ORIG_RAX: 0000000000000100
> RAX: ffffffffffffffda RBX: 00007fb18e3d5fa0 RCX: 00007fb18e18ec29
> RDX: 0000200000000300 RSI: 0000000000000003 RDI: 0000000000000000
> RBP: 00007fb18e211e41 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000200000000040 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007fb18e3d5fa0 R14: 00007fb18e3d5fa0 R15: 0000000000000004
>  </TASK>
> Modules linked in:
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:ptep_get include/linux/pgtable.h:340 [inline]
> RIP: 0010:remove_migration_pte+0x369/0x2320 mm/migrate.c:352
> Code: 00 48 8d 43 20 48 89 44 24 68 49 8d 47 40 48 89 84 24 e8 00 00 00 4=
c 89 64 24 48 4c 8b b4 24 50 01 00 00 4c 89 f0 48 c1 e8 03 <42> 80 3c 28 00=
 74 08 4c 89 f7 e8 f8 3e ff ff 49 8b 06 48 89 44 24
> RSP: 0018:ffffc90002fb73e0 EFLAGS: 00010246
> RAX: 0000000000000000 RBX: ffff88802957e300 RCX: 1ffffd40008c9006
> RDX: 0000000000000000 RSI: 0000000000030dff RDI: 0000000000030c00
> RBP: ffffc90002fb75d0 R08: 0000000000000003 R09: 0000000000000004
> R10: dffffc0000000000 R11: fffff520005f6e34 R12: ffffea0004648008
> R13: dffffc0000000000 R14: 0000000000000000 R15: ffffea0004648000
> FS:  00005555624de500(0000) GS:ffff8880b83fc000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000200000000300 CR3: 000000010d8b8000 CR4: 00000000000006f0
> ----------------
> Code disassembly (best guess):
>    0:   00 48 8d                add    %cl,-0x73(%rax)
>    3:   43 20 48 89             rex.XB and %cl,-0x77(%r8)
>    7:   44 24 68                rex.R and $0x68,%al
>    a:   49 8d 47 40             lea    0x40(%r15),%rax
>    e:   48 89 84 24 e8 00 00    mov    %rax,0xe8(%rsp)
>   15:   00
>   16:   4c 89 64 24 48          mov    %r12,0x48(%rsp)
>   1b:   4c 8b b4 24 50 01 00    mov    0x150(%rsp),%r14
>   22:   00
>   23:   4c 89 f0                mov    %r14,%rax
>   26:   48 c1 e8 03             shr    $0x3,%rax
> * 2a:   42 80 3c 28 00          cmpb   $0x0,(%rax,%r13,1) <-- trapping in=
struction
>   2f:   74 08                   je     0x39
>   31:   4c 89 f7                mov    %r14,%rdi
>   34:   e8 f8 3e ff ff          call   0xffff3f31
>   39:   49 8b 06                mov    (%r14),%rax
>   3c:   48                      rex.W
>   3d:   89                      .byte 0x89
>   3e:   44                      rex.R
>   3f:   24                      .byte 0x24
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
> [akpm@linux-foundation.org apopple@nvidia.com baohua@kernel.org baolin.wa=
ng@linux.alibaba.com byungchul@sk.com david@redhat.com dev.jain@arm.com gou=
rry@gourry.net harry.yoo@oracle.com ioworker0@gmail.com jannh@google.com jo=
shua.hahnjy@gmail.com lance.yang@linux.dev liam.howlett@oracle.com linux-ke=
rnel@vger.kernel.org linux-mm@kvack.org lorenzo.stoakes@oracle.com matthew.=
brost@intel.com npache@redhat.com peterx@redhat.com rakie.kim@sk.com riel@s=
urriel.com ryan.roberts@arm.com stable@vger.kernel.org usamaarif642@gmail.c=
om vbabka@suse.cz ying.huang@linux.alibaba.com yuzhao@google.com ziy@nvidia=
.com]
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
-upstream-moderation/68dbbaa1.a70a0220.10c4b.0154.GAE%40google.com.
