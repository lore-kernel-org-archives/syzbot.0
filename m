Received: from mail-oo1-f44.google.com (mail-oo1-f44.google.com [209.85.161.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E97F34F46A
	for <syzbot@lists.linux.dev>; Tue, 23 Dec 2025 17:48:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766512102; cv=none; b=i1YfiHN+jMXWXo3sXTTx1UFh1IhbSoh/VKrqKjduTlu4Oehtu+kDuvA9zFg7PKNdnj6AdEun0XPZfvoJ0rsy7SM+co38XddIo8TVTlVpyfpFDUvv8HmoQTaHQkYBU8ZWUeWEoQHVorzesvGS4aNq4TllEy5uussyzuhlCW1I+kg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766512102; c=relaxed/simple;
	bh=97sQB2h2COoJjhRrbPYfNCv0d8yFtg5xWhP40lrewKo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CQvbLZEL09Tvcu3H9JcnkIji775D/D/AV1s/ug4c72exaI/GGIBcEklQip+SGb6dS4+k19ZJ66DF6GVVA3LT9LoSNmJLoooM9gglJUuAECW6qi/Nr7rxf17jni/J291lzniQqXLaogjnAgoB/CpBxK1elVJaiqjf+SRJiZ7n1m0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=3YtvA0sN; arc=none smtp.client-ip=209.85.161.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3YtvA0sN"
Received: by mail-oo1-f44.google.com with SMTP id 006d021491bc7-657509d761dso2812378eaf.0
        for <syzbot@lists.linux.dev>; Tue, 23 Dec 2025 09:48:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1766512099; x=1767116899; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dYE4GacP+yXHxnvt8f0NA+8EQVMTnXXu1WfUAops08M=;
        b=3YtvA0sNpVcIfFR9H0rkGZuqKPtFWaeAABMvLSwe4fvQpSQE4a/vBGaAEuIey9EeOp
         /jz/VXnpaKjPNXuCWTVaJVluh7nqByWhh1weKjzXd3U2AJuZQvWfP1pwfh+DcEXDcxyg
         wqLuk1bskekF2Rwtm9DSV0UxRASr8lyBgBB+AZSAgCi4BR+cLntDFx60rrm7hnskTtjD
         y5q4HnUfauxZ4oULw9OUOYjYJX6Q1JQDeJaY+aI4rrVgNOwhfAiFays8g6o7Ozx3CkHr
         eo7Lb+H3ubQ2/fXNMf+cZhRnzPa44iAXCzwP616FYGFDG6mD+DxLAtw96/j4R1QqSRvg
         p/lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766512099; x=1767116899;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=dYE4GacP+yXHxnvt8f0NA+8EQVMTnXXu1WfUAops08M=;
        b=CVL8l4l44TZPfOwIUZnjP2A2NEX8sf4uwfK6Y1fZ7BFOGsk6qsVqah7U0TyZkHsw5b
         Zl8wTzwlCUGCyUHiv7eJOMWjRp6Dt9GRurGOkJSghgsfwvYBNfcWZgfcsutGH9SyLnS7
         CCsbVCCCIWcENXgzxjW3oTOdxtaSQYJpP/qjOagOPJErtEnr7U369AAb+qslX8w82TVt
         qxPEjV8NUVzr1Mefe0rKg5rSZ4slkofZJBCsLKVqbaoBDMwHriFhLRDhrKtOx+pQeWEs
         zT65fswn7/a3SmJidTLm4dMYRW/lZrkjm6iGCLCUuwo+EYU4UuwsNFcaI1Xq8dOct04j
         QQ6Q==
X-Forwarded-Encrypted: i=1; AJvYcCV6bHAb8hDzx9GnP/OdxAL3SFW84zbJUDuushkLgkDv6c7ezWt2yUtwN8Xln/r4qRjsbw+1/fs=@lists.linux.dev
X-Gm-Message-State: AOJu0YxO+by7Mpu4BHuCpE0lsc2qRP/oFz6utDr0w6bEMcd5kxhZ1zs2
	+m40xVKYKkW3CFz68a+sKj85S6dmhxKEJSbCHb+DGaYLA5IVmTQATTWhBMV9yqFVAjKuqTW9Hf3
	7R+Ph1ajJIHBEswdy04UmTX4mKbVknxLUkv+25G/f
X-Gm-Gg: AY/fxX4ldcsIOjnxMSBYsDdnrmVg+7TjRAlUwUfbUmj6RSUFG66mCCBhfRGdQalSVyY
	EzzoyMy841aV8SZE8unh77onaTkSQohJ1Vzmoct4ejgWChtASUldI7M2f4bmmKW94qzWH8wCaoP
	VkcNd2DnMaHwr47ns8CwtLQOnzRUiFyaUy1fM8U0+sux2ZgZ8XyrwD0F2iNpXSZT4moj5Tv2/1l
	BmbPukaKxOk0NOsvSWzKHYfiNa75EtMzyc/9TtrjGHcr+rrQKSKTuWv5oiqDYUTxofvQ+yXTvDX
	3Hc2c+dgguDoj24cC+mJS2NzUBN4C6g6geKzTUSL3JB1nBDLygo4/i3FcQ2ksgsWyQoVl04=
X-Google-Smtp-Source: AGHT+IECLS3UXUjDikFsrj8nLFAhM5AehrrS+QytyPgSPXj8VJSDorOqRNHMOihLq0WgxKp+j+EnlCP/3WzUqa5lMxI=
X-Received: by 2002:a05:6820:850d:b0:65d:5e1:ecfc with SMTP id
 006d021491bc7-65d0ea71be5mr3744532eaf.32.1766512094096; Tue, 23 Dec 2025
 09:48:14 -0800 (PST)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <694ac438.050a0220.35954c.0000.GAE@google.com>
In-Reply-To: <694ac438.050a0220.35954c.0000.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Tue, 23 Dec 2025 18:48:03 +0100
X-Gm-Features: AQt7F2rTMStgfiACpuYXjkUmKMEWO6SyVan28mRycZ6wRVOgVu_TF1QocSsm-T4
Message-ID: <CANp29Y6+MzpYq4ZMSCpe-DWDQD1sU_9bTsnvGBM-Pmm_C4PRsw@mail.gmail.com>
Subject: Re: [moderation/CI] Re: mm/huge_memory: consolidate order-related
 checks into folio_check_splittable()
To: syzbot ci <syzbot+cicb26c25da0c5aac9@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Tue, Dec 23, 2025 at 5:32=E2=80=AFPM syzbot ci
<syzbot+cicb26c25da0c5aac9@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v2] mm/huge_memory: consolidate order-related checks into folio_check_sp=
littable()
> https://lore.kernel.org/all/20251223122539.10726-1-richard.weiyang@gmail.=
com
> * [Patch v2] mm/huge_memory: consolidate order-related checks into folio_=
check_splittable()
>
> and found the following issue:
> WARNING in __folio_split
>
> Full report is available here:
> https://ci.syzbot.org/series/7e34013d-ed08-40e1-99b7-8fd118dce84f
>
> ***
>
> WARNING in __folio_split
>
> tree:      mm-new
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/=
mm.git
> base:      c642ecda5b136882e518d8303863473c0d21ab2f
> arch:      amd64
> compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~e=
xp1~20250708183702.136), Debian LLD 20.1.8
> config:    https://ci.syzbot.org/builds/2edb2dc5-42c6-4557-a194-921c57fd9=
eb1/config
> C repro:   https://ci.syzbot.org/findings/8349b674-5790-4507-97cd-03697ec=
93cb0/c_repro
> syz repro: https://ci.syzbot.org/findings/8349b674-5790-4507-97cd-03697ec=
93cb0/syz_repro
>
> ------------[ cut here ]------------
> Tried to split an unsplittable folio
> WARNING: mm/huge_memory.c:3970 at __folio_split+0xfe7/0x1370 mm/huge_memo=
ry.c:3970, CPU#1: syz.0.17/5997
> Modules linked in:
> CPU: 1 UID: 0 PID: 5997 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:__folio_split+0xfe7/0x1370 mm/huge_memory.c:3970
> Code: fe c6 05 a5 f8 3e 0d 01 90 0f 0b 90 e9 0d f4 ff ff e8 4d 78 94 ff 4=
9 ff cd e9 d1 f4 ff ff e8 40 78 94 ff 48 8d 3d 69 47 5a 0d <67> 48 0f b9 3a=
 41 bd ea ff ff ff e9 7c fe ff ff 44 89 7c 24 34 44
> RSP: 0018:ffffc900036d6d60 EFLAGS: 00010293
> RAX: ffffffff822d4360 RBX: ffffea0005a4b008 RCX: ffff8881047fd7c0
> RDX: 0000000000000000 RSI: ffffffff8e06e540 RDI: ffffffff8f878ad0
> RBP: ffffc900036d6ef0 R08: ffff8881047fd7c0 R09: 0000000000000002
> R10: 00000000ffffffea R11: 0000000000000000 R12: 0000000000000004
> R13: 00000000ffffffea R14: ffffea0005a4b000 R15: 1ffffd4000b49603
> FS:  0000555591a60500(0000) GS:ffff8882a9e32000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000001b30d63fff CR3: 0000000100f30000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  madvise_cold_or_pageout_pte_range+0xbf3/0x1ce0 mm/madvise.c:503
>  walk_pmd_range mm/pagewalk.c:130 [inline]
>  walk_pud_range mm/pagewalk.c:224 [inline]
>  walk_p4d_range mm/pagewalk.c:262 [inline]
>  walk_pgd_range+0x1037/0x1d30 mm/pagewalk.c:303
>  __walk_page_range+0x14c/0x710 mm/pagewalk.c:410
>  walk_page_range_vma_unsafe+0x34c/0x400 mm/pagewalk.c:714
>  madvise_pageout_page_range mm/madvise.c:622 [inline]
>  madvise_pageout mm/madvise.c:647 [inline]
>  madvise_vma_behavior+0x30c7/0x4420 mm/madvise.c:1366
>  madvise_walk_vmas+0x575/0xaf0 mm/madvise.c:1721
>  madvise_do_behavior+0x38e/0x550 mm/madvise.c:1937
>  do_madvise+0x1bc/0x270 mm/madvise.c:2030
>  __do_sys_madvise mm/madvise.c:2039 [inline]
>  __se_sys_madvise mm/madvise.c:2037 [inline]
>  __x64_sys_madvise+0xa7/0xc0 mm/madvise.c:2037
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xfa/0xf80 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7ff69838f7c9
> Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007fff82001dd8 EFLAGS: 00000246 ORIG_RAX: 000000000000001c
> RAX: ffffffffffffffda RBX: 00007ff6985e5fa0 RCX: 00007ff69838f7c9
> RDX: 0000000000000015 RSI: 0000000000600000 RDI: 0000200000000000
> RBP: 00007ff6983f297f R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007ff6985e5fa0 R14: 00007ff6985e5fa0 R15: 0000000000000003
>  </TASK>
> ----------------
> Code disassembly (best guess), 1 bytes skipped:
>    0:   c6 05 a5 f8 3e 0d 01    movb   $0x1,0xd3ef8a5(%rip)        # 0xd3=
ef8ac
>    7:   90                      nop
>    8:   0f 0b                   ud2
>    a:   90                      nop
>    b:   e9 0d f4 ff ff          jmp    0xfffff41d
>   10:   e8 4d 78 94 ff          call   0xff947862
>   15:   49 ff cd                dec    %r13
>   18:   e9 d1 f4 ff ff          jmp    0xfffff4ee
>   1d:   e8 40 78 94 ff          call   0xff947862
>   22:   48 8d 3d 69 47 5a 0d    lea    0xd5a4769(%rip),%rdi        # 0xd5=
a4792
> * 29:   67 48 0f b9 3a          ud1    (%edx),%rdi <-- trapping instructi=
on
>   2e:   41 bd ea ff ff ff       mov    $0xffffffea,%r13d
>   34:   e9 7c fe ff ff          jmp    0xfffffeb5
>   39:   44 89 7c 24 34          mov    %r15d,0x34(%rsp)
>   3e:   44                      rex.R
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
> [akpm@linux-foundation.org baohua@kernel.org baolin.wang@linux.alibaba.co=
m david@kernel.org dev.jain@arm.com lance.yang@linux.dev liam.howlett@oracl=
e.com linux-mm@kvack.org lorenzo.stoakes@oracle.com npache@redhat.com richa=
rd.weiyang@gmail.com ryan.roberts@arm.com ziy@nvidia.com]
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
-upstream-moderation/694ac438.050a0220.35954c.0000.GAE%40google.com.
