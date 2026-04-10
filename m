Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6EBF387378
	for <syzbot@lists.linux.dev>; Fri, 10 Apr 2026 06:43:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775803394; cv=pass; b=r5lvuzlM/7NHm1T7v4iTY16UB9+2Pa2of5PwKvXyoq7soSMJDHQ5KOBPt7kOfdHGmI5o9+baR3UwY0+uUdtuDaO3fMeEpvY7HXeD4Pp8zCAQfBeAff+H9JXIxHpbR3dIuA09NbRTFNYFLTgvEemcz6KfxEED378LY5n0IF8pAJk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775803394; c=relaxed/simple;
	bh=sLO0I00hqU9fNiJCznt3hNxJotykOvLIUDTCOSsCRZ8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=efexD0hSYSBJdmK94yve28tiPlppwDtc34jF1qP1K+EP0CZzpbT6MezlaYMalz9EpjzEjz21v/98loFMQFIdrSsC0kszh4wv5monTffDuAZ7FoYrTBmevbBmXy142rzQU4YUofNFvXo6B7crrlBws9x0U2GkiRqrtZyLk/UOY/U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=nmLha7lv; arc=pass smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="nmLha7lv"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4838c15e3cbso13947155e9.3
        for <syzbot@lists.linux.dev>; Thu, 09 Apr 2026 23:43:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775803391; cv=none;
        d=google.com; s=arc-20240605;
        b=kHBrkXTMaOIYXiHZoQ2o5gGX3DPjVvQtzTVxzgHYIBCG2UahCV455R8UdyYtphRJLu
         IQ1yQI9MBAJkb0GC2bdhNzejqrf+Nn+9NZvyIAR+zGlldbPC0RQYSn20O36IIyVuSsAj
         eAUO+vDUoI3l9MrnAB9X40AGDsCSNCJ9nN9WYs0elOgIRmI8H0Mpwi1QzYfv4LLdvUw0
         TKwaeR8AmViE/rE/KLtD+o1R+5xCYht958uQNzT0YKl0cKBpQLy8gpbZCG0aN3s1qywp
         omrNu0DPpSvdEzVFESDb+VtaRFgIdQ4FVA1IYhmqK4468+kNG6x9MesY/lgxTfVsU1xJ
         oB6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=aBAXNisuf6JrL4OPCTnACMPpZ24jZAK1TQAW0da7T/U=;
        fh=8oLOVPAFo7OVP4wGTEHnSoh2kvvq0+c0M/x6LOHe3Ws=;
        b=I2EwsciNT4qJtIO2mDbrsITeumgDgRRqe2FZp1uYT4aNrAYOf77Ug8BRgyG11ohxW7
         X4iyIXBWn0bE+AsmPZo3Q4SeN1GcAfT11XRjrY3ff5foXdycbAf51cNRrO0Jpho7Vh82
         w7zfOCnZmdrVJLq/56M7EvMzsG597r/GqTwvNm+NfGK8/l8Sag5Ui5lXzJkjHYyUOKH9
         7qyjY+fNHEJaNXLqW6kjNiIWxXThJielwaXuCIZgKiNJAT4phXtZHTC3BF1Zw4chmG1y
         BG8Ggpek+F74BYoqATUFejkQ2vxvg+h9YFbByduWF2+nvL7gxxVtKVkEaDvhp3BNUFty
         QAMg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1775803391; x=1776408191; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aBAXNisuf6JrL4OPCTnACMPpZ24jZAK1TQAW0da7T/U=;
        b=nmLha7lvpGmxfrK1/GhCLaztA2USejrpjSXeJbY00k9rladbCzqKtlJDYhFbRYGVPZ
         XnXs6syLtfliPNs4yWS0k/PX8tY/1djBeY287pMSUsYa/b3rFWcrY1SYYZs/F9KVbEOc
         kCYKl3ISgTnnqVJeyWyaWBKbJIr+q/QcZmMAO5nIWapAjnvoKuA5OhC+/iMJg5NQF8ew
         6JRp7XgflIbMy5B9Hkb9s/qLeogM/7TX9zEGN3ZK5su7Fx+qM8knD+3D+T4/grAyxzYB
         UeONp/8WtanRy0jV4Q2clZhNryHNKlM3tmxsZW5lpCIgATdlIILLjs97joueRyNgp3Ku
         ZxDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775803391; x=1776408191;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=aBAXNisuf6JrL4OPCTnACMPpZ24jZAK1TQAW0da7T/U=;
        b=P6PB5/10FRLw2yxuaHQzfTT663eR4N/Q1woKZJ1pTWj4VnlP4HXx1gEY15VZ0zJFBx
         ZH2DoZloX1l+ew7X/OeEyGUA5B4wG0LbdL98K4TWbfoMyc8T1S/y2JtBdxbeBpW6BmsD
         RvEKGswGPl2aCPaTXvYn+XcizShnqf/IM9QIkS4BKds3wgk5VZeyZUDJcYwYWM8OF+QW
         lG36UFIVFVNaQrn7vrICqnFZXeNqgzirWRq3S8nl0nhNLEWxyDujNdkE336gzY3ufWwA
         y/GRWeOgFkJ9j7Vhubj1i3wFsg0OD5faoir7lnLxP8B17Kj/XpnAdkNd3yVealWAkhwo
         MA4g==
X-Forwarded-Encrypted: i=1; AJvYcCUwC5A6KvjBGWhzeHAwT9COhZ8iS5Ce1FhZxq6B12jkBzLZfhRrka7wSdmmwSPHgdqjqqsrPaY=@lists.linux.dev
X-Gm-Message-State: AOJu0YzjFlGJhTsAUjWBvcfFtsM99O5RTUajKDgBeVX7dkf1QTXTgGmP
	YOpKqXphuA8Y1YFhGWL2qVx04CpLOOfy4GbFTsv1q3LCKSl0XwjL0NRaih050VlQp//kQGdC0XH
	Yo+br3IfjBuO58W3FOPNW2Cct8vMkFegtWKWh+sh1fPGkV4ggkU3YrcGSRd8KnA==
X-Gm-Gg: AeBDiev/q3lT1QARwX2RiaGcioSyaWkBjoAkFrflmmbq3QNd3iMS5ib/RZ5lQTmP7Op
	ECsbJOixifCTcTTayAoE5ZbsmDwyjdzXY53fwuh5pgqBf0+BnRkF1VLUWl+bFWauFEz1ySJVkOl
	gqB7b2eRLNjf0vLByXNYMAEfPb6nBCIEnUDv8odI5V2mWiYYVIEh7FyrciefyVNuv5G/TAfs4B3
	yAeabrukhe1RGG9A6GobyQdcgK0n5c69XAPGt/LZCfMLhy3vHD8WmsVlhfwPTLTgaIJF/w37wLt
	MS/yHgEiWJhyvPlzCIjm6WqDXLIf0rpk10vp5B8yjBNl7UlABDutB4oEGw==
X-Received: by 2002:a05:600c:3b24:b0:480:2521:4d92 with SMTP id
 5b1f17b1804b1-488d687adb3mr21892035e9.24.1775803390759; Thu, 09 Apr 2026
 23:43:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <69d87a58.050a0220.3030df.0023.GAE@google.com>
In-Reply-To: <69d87a58.050a0220.3030df.0023.GAE@google.com>
From: Pimyn Girgis <pimyn@google.com>
Date: Fri, 10 Apr 2026 08:42:59 +0200
X-Gm-Features: AQROBzDwoHOFgxG68WxLvAnesXGavDOg4F57jwlPQc_Yn9lkNeWeFEIdhSZwQHs
Message-ID: <CAJWNTGyfQ4wOqTkSwPt+EiwZh+gdjVYn1mi08QKi=ap6-uzCcA@mail.gmail.com>
Subject: Re: [moderation/CI] Re: hugetlb: normalize exported interfaces to use
 base-page indices
To: syzbot ci <syzbot+cie62ba228172539e7@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Fri, Apr 10, 2026 at 6:19=E2=80=AFAM syzbot ci
<syzbot+cie62ba228172539e7@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v1] hugetlb: normalize exported interfaces to use base-page indices
> https://lore.kernel.org/all/20260409234158.837786-1-jane.chu@oracle.com
> * [PATCH 1/6] hugetlb: open-code hugetlb folio lookup index conversion
> * [PATCH 2/6] hugetlb: remove the hugetlb_linear_page_index() helper
> * [PATCH 3/6] hugetlb: make hugetlb_fault_mutex_hash() take PAGE_SIZE ind=
ex
> * [PATCH 4/6] hugetlb: drop vma_hugecache_offset() in favor of linear_pag=
e_index()
> * [PATCH 5/6] hugetlb: make hugetlb_add_to_page_cache() use PAGE_SIZE-bas=
ed index
> * [PATCH 6/6] hugetlb: pass hugetlb reservation ranges in base-page indic=
es
>
> and found the following issue:
> WARNING: bad unlock balance in hugetlb_no_page
>
> Full report is available here:
> https://ci.syzbot.org/series/95c5ba82-0135-4026-b7c7-b0819e1ca4d6
>
> ***
>
> WARNING: bad unlock balance in hugetlb_no_page
>
> tree:      mm-new
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/=
mm.git
> base:      06a6cfb92448a97ef429a7fbd395a20a9d388acc
> arch:      amd64
> compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~e=
xp1~20251221153213.50), Debian LLD 21.1.8
> config:    https://ci.syzbot.org/builds/cefe8576-3c99-42d3-9b51-1e70d62a6=
4a7/config
> syz repro: https://ci.syzbot.org/findings/3a14cc12-14a8-4fac-9614-ae7ae25=
55e58/syz_repro
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> WARNING: bad unlock balance detected!
> syzkaller #0 Not tainted
> -------------------------------------
> syz.0.17/5971 is trying to release lock (&hugetlb_fault_mutex_table[i]) a=
t:
> [<ffffffff8229b876>] hugetlb_handle_userfault mm/hugetlb.c:5686 [inline]
> [<ffffffff8229b876>] hugetlb_no_page+0x1986/0x1da0 mm/hugetlb.c:5770
> but there are no more locks to release!
>
> other info that might help us debug this:
> 2 locks held by syz.0.17/5971:
>  #0: ffff88816b85fb88 (vm_lock){++++}-{0:0}, at: lock_vma_under_rcu+0x1d1=
/0x500 mm/mmap_lock.c:310
>  #1: ffff88816079e338 (&hugetlb_fault_mutex_table[i]){+.+.}-{4:4}, at: hu=
getlb_fault+0x317/0x1440 mm/hugetlb.c:5991
>
> stack backtrace:
> CPU: 0 UID: 0 PID: 5971 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
>  print_unlock_imbalance_bug+0xdc/0xf0 kernel/locking/lockdep.c:5298
>  __lock_release kernel/locking/lockdep.c:5537 [inline]
>  lock_release+0x248/0x3d0 kernel/locking/lockdep.c:5889
>  __mutex_unlock_slowpath+0xd3/0x7d0 kernel/locking/mutex.c:938
>  hugetlb_handle_userfault mm/hugetlb.c:5686 [inline]
>  hugetlb_no_page+0x1986/0x1da0 mm/hugetlb.c:5770
>  hugetlb_fault+0x67f/0x1440 mm/hugetlb.c:-1
>  handle_mm_fault+0x2007/0x3170 mm/memory.c:6716
>  do_user_addr_fault+0xa73/0x1340 arch/x86/mm/fault.c:1334
>  handle_page_fault arch/x86/mm/fault.c:1474 [inline]
>  exc_page_fault+0x6a/0xc0 arch/x86/mm/fault.c:1527
>  asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:618
> RIP: 0033:0x7fa742251964
> Code: 41 89 00 31 c0 c3 b9 40 00 00 00 bf 40 00 00 00 eb bc 0f 1f 40 00 4=
8 89 7c 24 f8 48 89 74 24 f0 48 8b 7c 24 f8 4c 8b 44 24 f0 <8b> 4f 50 8b 47=
 58 4c 01 c1 41 8b 34 00 8b 11 21 d6 89 f0 8d 72 01
> RSP: 002b:00007fa7431fd018 EFLAGS: 00010212
> RAX: 00007fa742251950 RBX: 00007fa742615fa0 RCX: 0000000000000000
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000200000400000
> RBP: 00007fa742432c91 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000200000400000 R11: 0000000000000000 R12: 0000000000000000
> R13: 00007fa742616038 R14: 00007fa742615fa0 R15: 00007ffe952c6908
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
> [akpm@linux-foundation.org baolin.wang@linux.alibaba.com corbet@lwn.net d=
avid@kernel.org hughd@google.com jane.chu@oracle.com liam.howlett@oracle.co=
m linux-doc@vger.kernel.org linux-kernel@vger.kernel.org linux-mm@kvack.org=
 lorenzo.stoakes@oracle.com mhocko@suse.com muchun.song@linux.dev osalvador=
@suse.de peterx@redhat.com rppt@kernel.org skhan@linuxfoundation.org surenb=
@google.com vbabka@kernel.org]
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
-upstream-moderation/69d87a58.050a0220.3030df.0023.GAE%40google.com.
