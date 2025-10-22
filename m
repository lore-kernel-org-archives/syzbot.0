Received: from mail-oi1-f169.google.com (mail-oi1-f169.google.com [209.85.167.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11FA235B14D
	for <syzbot@lists.linux.dev>; Wed, 22 Oct 2025 19:14:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761160446; cv=none; b=togqiAGrCImjdt2uHNJ7nA/frejVXfk2QaUpaiVH3COLH7f9viRepUflUs3uRDHvcz85afFQk/BOJC9PBL5DsVuRThrbRXFopID9O9ihJbMsTfuyAOaaeHFkGMKs62k5NltMgIDuFQACO+k/SGK2ycwT/2BzVUProRW4LKlFrZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761160446; c=relaxed/simple;
	bh=u972X9ClTLEKoUFCoim8XCBm/3TWet2P3gtLd9P31GM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PJU8TCplFX1brNSR77R7ZzqW1wpM/dSc7IOOfBIuQWIrkqNXSkYE1v7ytAoqVoy7lcO5HPQMSAaYftK4QYpkyHiSHygSsZ9EN5OxSNgsRDdmWsvflquv9jWY6ENSxwtCWlBLEgQdTFTp2cz/ePGmHWblP84x/vBIod+sbwIyxC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=F6b9uOrC; arc=none smtp.client-ip=209.85.167.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="F6b9uOrC"
Received: by mail-oi1-f169.google.com with SMTP id 5614622812f47-44575bc8d88so2096254b6e.2
        for <syzbot@lists.linux.dev>; Wed, 22 Oct 2025 12:14:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761160442; x=1761765242; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YFn9t3czZIavtNSYrE72F2eItu4fn4SSUvgHvdWA1AA=;
        b=F6b9uOrCdiEQ0Z/RGao442ijPuOrOCkYjTDePkChjKh2K1adTJJGqLfFkiQE8JB6zJ
         SkNSa9PAJkmqCkR0VgVC871ZohOaIRWeTREVCoFtGGxpYnsrUxI72aO2ak3BQFEzcgzy
         FxI1m9YZIzFubNM7RMgIjLDWNP2Ng7r1/CqukqTQvxMLtC+2Tx/AmC1Fn7SH+hZyUY2y
         vLT5yMchv4gJGrEQ0Xwao1zMLsIk8yA3uIBepPSZ7DATiQPxWYyZnaXVYHbPMezBOxUl
         tNXRlyr6dnhkq141Mz39IhP7om4AC4wPG9CiGHjkSvrKQ7XtiBZBspTNAIB1pj7rQBf9
         +z2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761160442; x=1761765242;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YFn9t3czZIavtNSYrE72F2eItu4fn4SSUvgHvdWA1AA=;
        b=fhLY9I6U+6n3DN7A2NWrH3dz79/y1pG/PaLiWGuTtx8dasRrPwlMKfGsZuEOFt92ey
         JYxkB7aSRZn9cgPZaj4trNQbb2bUOOagCFxiotK26jzZfvixfv5V+FkfDef8vC/W3a9m
         UXEOhFGQ7ejPp76zNkw8tAM7FPULnfz5czpt7OVEme0BuQGfolCHkkTo6g5dS261EHVe
         TFVPusyXlPVoF2iypnM7sOINey+74uoyO+WgMEpAV67oD16Td9O4nTaiG0ORZTanPJvD
         RcAK4o3SgSb60dRAcqf4yszTsjeQaA4fP1jNUNgWdg4AOeJ9kTH4Nl6zE+6pw6x8XAi5
         Wt/w==
X-Forwarded-Encrypted: i=1; AJvYcCU9YYDAnYQuBI3sdgpXOnTP9K8ytLIxT6dnj8nPt2Jwr992031BeUcFAtKwBu+qztz08Q4/O+g=@lists.linux.dev
X-Gm-Message-State: AOJu0YxFizaszxyElULTX7ooVPBJT4PQXRUwzms3GJMwYZQsgpV6MHXL
	RdNfkZwmgytw8qflfaqHuublFRRbvZtqL6Tkn2ZzpX70mAFZ+y0kX9EBs65EAgPSp2UwGzZnUOE
	QXphLgYCRL6U+kgGU0QWzxrpZgUFp30eLbjWh+CNX
X-Gm-Gg: ASbGncu1vUIz0lfbaa8p1GQ6YsPRGbPUhIadDZMvoySNvA5Mkw/CML4hK++nAb2RoZB
	qJToHeBScYykEdzmsuMBeh/v5eFKy+RrjNJYD/dta1AFx4KS4hPLzrJlQUMUTjru64UycyynF/6
	PE1+a1cujdnGk4OxZ8N6kK6lOgqVKviA+Tk/V3HUzlTuitkWAdEQgK8HrvjzCn8Zl2K7hkeB6pW
	1+d4gxDhHaaIlZwO7EQVc7WbgqzV/S3N8Y5tt7HOrkoiIAAuNeleyWoccFWkgkMH1qFBL3VRVG5
	fqivNUiwVsbRQ1QBpF5yE9WDUa33+cnmcXuOqtLF5AZyfP59
X-Google-Smtp-Source: AGHT+IGbHayF/FXhyxQMR8XNhrH14rX/hPi4cJMo3TGjSpR0hz4sKkxy9skcc8yBxj6buXYbeeN37HBZFVntEIF8sOA=
X-Received: by 2002:a05:6808:1a20:b0:43f:4798:9af1 with SMTP id
 5614622812f47-443a2e900a8mr9568756b6e.27.1761160441850; Wed, 22 Oct 2025
 12:14:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <68f910a1.050a0220.346f24.005e.GAE@google.com>
In-Reply-To: <68f910a1.050a0220.346f24.005e.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Wed, 22 Oct 2025 21:13:49 +0200
X-Gm-Features: AS18NWCFGOULIipJ9mrZ0-YRHRYztDqiu3J5Ltg0S3pqj-ilqciu3FwRWGZ4Qp0
Message-ID: <CANp29Y58vWx0N860E9Ni8oO1Eg9dSM+KMFTcbmtDQh9nhMo=wg@mail.gmail.com>
Subject: Re: [moderation/CI] Re: nstree: listns()
To: syzbot ci <syzbot+ci6c013befe1ee518f@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Wed, Oct 22, 2025 at 7:13=E2=80=AFPM syzbot ci
<syzbot+ci6c013befe1ee518f@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v2] nstree: listns()
> https://lore.kernel.org/all/20251022-work-namespace-nstree-listns-v2-0-71=
a588572371@kernel.org
> * [PATCH v2 01/63] libfs: allow to specify s_d_flags
> * [PATCH v2 02/63] nsfs: use inode_just_drop()
> * [PATCH v2 03/63] nsfs: raise DCACHE_DONTCACHE explicitly
> * [PATCH v2 04/63] pidfs: raise DCACHE_DONTCACHE explicitly
> * [PATCH v2 05/63] nsfs: raise SB_I_NODEV and SB_I_NOEXEC
> * [PATCH v2 06/63] cgroup: add cgroup namespace to tree after owner is se=
t
> * [PATCH v2 07/63] nstree: simplify return
> * [PATCH v2 08/63] ns: initialize ns_list_node for initial namespaces
> * [PATCH v2 09/63] ns: add __ns_ref_read()
> * [PATCH v2 10/63] ns: add active reference count
> * [PATCH v2 11/63] ns: use anonymous struct to group list member
> * [PATCH v2 12/63] nstree: introduce a unified tree
> * [PATCH v2 13/63] nstree: allow lookup solely based on inode
> * [PATCH v2 14/63] nstree: assign fixed ids to the initial namespaces
> * [PATCH v2 15/63] ns: maintain list of owned namespaces
> * [PATCH v2 16/63] nstree: add listns()
> * [PATCH v2 17/63] arch: hookup listns() system call
> * [PATCH v2 18/63] nsfs: update tools header
> * [PATCH v2 19/63] selftests/filesystems: remove CLONE_NEWPIDNS from setu=
p_userns() helper
> * [PATCH v2 20/63] selftests/namespaces: first active reference count tes=
ts
> * [PATCH v2 21/63] selftests/namespaces: second active reference count te=
sts
> * [PATCH v2 22/63] selftests/namespaces: third active reference count tes=
ts
> * [PATCH v2 23/63] selftests/namespaces: fourth active reference count te=
sts
> * [PATCH v2 24/63] selftests/namespaces: fifth active reference count tes=
ts
> * [PATCH v2 25/63] selftests/namespaces: sixth active reference count tes=
ts
> * [PATCH v2 26/63] selftests/namespaces: seventh active reference count t=
ests
> * [PATCH v2 27/63] selftests/namespaces: eigth active reference count tes=
ts
> * [PATCH v2 28/63] selftests/namespaces: ninth active reference count tes=
ts
> * [PATCH v2 29/63] selftests/namespaces: tenth active reference count tes=
ts
> * [PATCH v2 30/63] selftests/namespaces: eleventh active reference count =
tests
> * [PATCH v2 31/63] selftests/namespaces: twelth active reference count te=
sts
> * [PATCH v2 32/63] selftests/namespaces: thirteenth active reference coun=
t tests
> * [PATCH v2 33/63] selftests/namespaces: fourteenth active reference coun=
t tests
> * [PATCH v2 34/63] selftests/namespaces: fifteenth active reference count=
 tests
> * [PATCH v2 35/63] selftests/namespaces: add listns() wrapper
> * [PATCH v2 36/63] selftests/namespaces: first listns() test
> * [PATCH v2 37/63] selftests/namespaces: second listns() test
> * [PATCH v2 38/63] selftests/namespaces: third listns() test
> * [PATCH v2 39/63] selftests/namespaces: fourth listns() test
> * [PATCH v2 40/63] selftests/namespaces: fifth listns() test
> * [PATCH v2 41/63] selftests/namespaces: sixth listns() test
> * [PATCH v2 42/63] selftests/namespaces: seventh listns() test
> * [PATCH v2 43/63] selftests/namespaces: ninth listns() test
> * [PATCH v2 44/63] selftests/namespaces: ninth listns() test
> * [PATCH v2 45/63] selftests/namespaces: first listns() permission test
> * [PATCH v2 46/63] selftests/namespaces: second listns() permission test
> * [PATCH v2 47/63] selftests/namespaces: third listns() permission test
> * [PATCH v2 48/63] selftests/namespaces: fourth listns() permission test
> * [PATCH v2 49/63] selftests/namespaces: fifth listns() permission test
> * [PATCH v2 50/63] selftests/namespaces: sixth listns() permission test
> * [PATCH v2 51/63] selftests/namespaces: seventh listns() permission test
> * [PATCH v2 52/63] selftests/namespaces: first inactive namespace resurre=
ction test
> * [PATCH v2 53/63] selftests/namespaces: second inactive namespace resurr=
ection test
> * [PATCH v2 54/63] selftests/namespaces: third inactive namespace resurre=
ction test
> * [PATCH v2 55/63] selftests/namespaces: fourth inactive namespace resurr=
ection test
> * [PATCH v2 56/63] selftests/namespaces: fifth inactive namespace resurre=
ction test
> * [PATCH v2 57/63] selftests/namespaces: sixth inactive namespace resurre=
ction test
> * [PATCH v2 58/63] selftests/namespaces: seventh inactive namespace resur=
rection test
> * [PATCH v2 59/63] selftests/namespaces: eigth inactive namespace resurre=
ction test
> * [PATCH v2 60/63] selftests/namespaces: ninth inactive namespace resurre=
ction test
> * [PATCH v2 61/63] selftests/namespaces: tenth inactive namespace resurre=
ction test
> * [PATCH v2 62/63] selftests/namespaces: eleventh inactive namespace resu=
rrection test
> * [PATCH v2 63/63] selftests/namespaces: twelth inactive namespace resurr=
ection test
>
> and found the following issue:
> general protection fault in copy_creds
>
> Full report is available here:
> https://ci.syzbot.org/series/edb88bd4-fe2f-4399-a44b-69d30faa57fb
>
> ***
>
> general protection fault in copy_creds
>
> tree:      bpf
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/bpf/b=
pf.git
> base:      5fb750e8a9ae123b2034771b864b8a21dbef65cd
> arch:      amd64
> compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~e=
xp1~20250708183702.136), Debian LLD 20.1.8
> config:    https://ci.syzbot.org/builds/b6fa4981-93e1-4b9c-a4b4-a1be1c33d=
835/config
>
> Oops: general protection fault, probably for non-canonical address 0xdfff=
fc0000000012: 0000 [#1] SMP KASAN PTI
> KASAN: null-ptr-deref in range [0x0000000000000090-0x0000000000000097]
> CPU: 1 UID: 0 PID: 5952 Comm: syz-executor Not tainted syzkaller #0 PREEM=
PT(full)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:copy_creds+0x473/0xd10
> Code: 6a 8b e8 a0 76 0f 00 48 c7 c7 e0 cd 13 8e 48 89 de e8 81 5c 0f 00 e=
8 6c 01 19 00 ba 01 00 00 00 4c 89 f7 31 f6 e8 6d 99 00 00 <41> 80 7c 24 12=
 00 74 0a bf 90 00 00 00 e8 eb bc 97 00 4c 8b 34 25
> RSP: 0018:ffffc900045d7938 EFLAGS: 00010286
> RAX: 0000000000000131 RBX: ffffffff818e8499 RCX: ffff88810d1ad700
> RDX: 0000000000000000 RSI: 7fffffffffffffff RDI: 0000000000000131
> RBP: 0000000000000001 R08: ffffffff8dfef75f R09: 1ffffffff1bfdeeb
> R10: dffffc0000000000 R11: fffffbfff1bfdeec R12: dffffc0000000000
> R13: 0000000000010000 R14: ffffffff8dfef6c0 R15: 1ffff110216064bd
> FS:  000055558d65c500(0000) GS:ffff8882a9d02000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007fd1e15c36f0 CR3: 000000011b786000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  copy_process+0x964/0x3c00
>  kernel_clone+0x21e/0x840
>  __se_sys_clone3+0x256/0x2d0
>  do_syscall_64+0xfa/0xfa0
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7fd1e15c3709
> Code: d6 08 00 48 8d 3d bc d6 08 00 e8 02 29 f6 ff 66 90 b8 ea ff ff ff 4=
8 85 ff 74 2c 48 85 d2 74 27 49 89 c8 b8 b3 01 00 00 0f 05 <48> 85 c0 7c 18=
 74 01 c3 31 ed 48 83 e4 f0 4c 89 c7 ff d2 48 89 c7
> RSP: 002b:00007fff0ae99118 EFLAGS: 00000202 ORIG_RAX: 00000000000001b3
> RAX: ffffffffffffffda RBX: 00007fd1e1545b10 RCX: 00007fd1e15c3709
> RDX: 00007fd1e1545b10 RSI: 0000000000000058 RDI: 00007fff0ae99160
> RBP: 00007fd1e13ff6c0 R08: 00007fd1e13ff6c0 R09: 00007fff0ae99247
> R10: 0000000000000008 R11: 0000000000000202 R12: ffffffffffffffa8
> R13: 0000000000000009 R14: 00007fff0ae99160 R15: 00007fff0ae99248
>  </TASK>
> Modules linked in:
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:copy_creds+0x473/0xd10
> Code: 6a 8b e8 a0 76 0f 00 48 c7 c7 e0 cd 13 8e 48 89 de e8 81 5c 0f 00 e=
8 6c 01 19 00 ba 01 00 00 00 4c 89 f7 31 f6 e8 6d 99 00 00 <41> 80 7c 24 12=
 00 74 0a bf 90 00 00 00 e8 eb bc 97 00 4c 8b 34 25
> RSP: 0018:ffffc900045d7938 EFLAGS: 00010286
> RAX: 0000000000000131 RBX: ffffffff818e8499 RCX: ffff88810d1ad700
> RDX: 0000000000000000 RSI: 7fffffffffffffff RDI: 0000000000000131
> RBP: 0000000000000001 R08: ffffffff8dfef75f R09: 1ffffffff1bfdeeb
> R10: dffffc0000000000 R11: fffffbfff1bfdeec R12: dffffc0000000000
> R13: 0000000000010000 R14: ffffffff8dfef6c0 R15: 1ffff110216064bd
> FS:  000055558d65c500(0000) GS:ffff8882a9d02000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007fed5f717d60 CR3: 000000011b786000 CR4: 00000000000006f0
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
> [amir73il@gmail.com arnd@arndb.de bpf@vger.kernel.org brauner@kernel.org =
cgroups@vger.kernel.org cyphar@cyphar.com daan.j.demeyer@gmail.com edumazet=
@google.com hannes@cmpxchg.org jack@suse.cz jannh@google.com jlayton@kernel=
.org josef@toxicpanda.com kuba@kernel.org linux-fsdevel@vger.kernel.org lin=
ux-kernel@vger.kernel.org me@yhndnzj.com mzxreary@0pointer.de netdev@vger.k=
ernel.org tglx@linutronix.de tj@kernel.org viro@zeniv.linux.org.uk zbyszek@=
in.waw.pl]
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
-upstream-moderation/68f910a1.050a0220.346f24.005e.GAE%40google.com.
