Received: from mail-oi1-f171.google.com (mail-oi1-f171.google.com [209.85.167.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82D643ACF14
	for <syzbot@lists.linux.dev>; Thu, 12 Mar 2026 09:12:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.171
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773306725; cv=pass; b=nlYoRuW/pqEmOY0mAXiT+DVdEjde+hTAkHzfr9pZ6UffdyYTbeXa5NcsRa5Y9mCkWyLEPSIT0fe5v+5UPf87aKBC5Bbc6qRcw6lkAXHm2BgDzCrAYrlQSmUQnP+qIqiPYWHpXP30l2oDH490tkBDkZN7h2eCqiqwP1DbWDC8P/o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773306725; c=relaxed/simple;
	bh=FZ3x4wATo5vnC7WLHjqe0Qho4DB+NPgmSXgRLySwvl0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZIoGAy5Kp9gg+l76sCNu+PW5R3BlBN+RpH2Mq4KxvvYa+fk8JmQfieZ6/Oxaghysrwdy8g0H0TYehaCvJIBkSDbhD+TjBhDTCVajnSDoUD/lxonHAmKMdsQmKRfA1CIbeeiUd3TtMjtBqzRmN81IiupGdRLg+FQbfBs1NgOupug=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=g8RGcuaU; arc=pass smtp.client-ip=209.85.167.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="g8RGcuaU"
Received: by mail-oi1-f171.google.com with SMTP id 5614622812f47-463a0e14abfso523505b6e.2
        for <syzbot@lists.linux.dev>; Thu, 12 Mar 2026 02:12:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773306722; cv=none;
        d=google.com; s=arc-20240605;
        b=jwRaNWXOGvCDNrm4mA+6Bd1WvkgwFiqALzaZOvao3VG0nQbam1C6+s8HUKgg4A4RKX
         PyL1E0EpaJrx1dU76/W/scwxK3EJLl1pMfkWAgMDdmMNbyObaO7usZKpJqskqB3maY7Z
         69gwezneH6EwypsFeMQ9iiwnBD9ZCJfghJYJFYZ/bO0mQ5IyU3WKsCMU0gzkbdUqeW41
         MVwq0LD51pXzDYsUc2TZdQ+b7DMBJv08+2YTfkHFAcbxZd/+c1+NWytchfFIw8uOVNbO
         E4kciO1Q5VJVCMMk0SwcHuWvJZlwO91lHL3MIhOZ/AEjIaAvGiduJsH+sCSnBK0kyVRF
         fbNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=gMkxR4nrzpTZVtW0eZQXRORnWBJx7p+nKfbSA+TJ3Dg=;
        fh=V3WiFykr9gIxOSCpDACOZvY08hEM5i+prr2geJ15c9c=;
        b=CAfOzmlKCy1ZapBDMYlmQESC+pX3O10bGBTomeELQkbEkvFXiwaYvgC+GhuvrLFFkQ
         VGOOD7Jqb0Mib0dSBGWf2wrLeOYDfk8WKmzV43sb1bFeHXFwtHeCb94JIrk6c0Y0kd4H
         Emk4HyPBn9SGjnVmjysi3QVCxQEDMy3ZikKuH1ASpubCpevqnelGwHLngVMb+YILylpI
         H2X914KXMw7I65UtTPuXkvbzRpQ7ijcMbRfsi7FxJA6GIbSPQk4HUyqYF5/QJ6KKU3wU
         a3bszTa+Pr299mQePd9CzX1nw1myN5TJR7uGVIdyTfQ1SsALGEXWN0Z9f8kBL6sa7s7N
         BVRw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1773306722; x=1773911522; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gMkxR4nrzpTZVtW0eZQXRORnWBJx7p+nKfbSA+TJ3Dg=;
        b=g8RGcuaU85JvnS0gljmWQu6sVoO50nklYvJkkHRKxAQT50as/RCsZc6DzXekQ1nv7r
         fEhGlEhpCm8wDddhZk5BRwDim8sT8TXn7Y49LP6zilBPGOpBmt5VFU8klWkiZVD37d01
         j8LMrC5T1asXmb9yZ1IqRRBAdg0StNlNWrmt+mw0GrTqqMY5OQ7tQWHtPwZbgjy4MJbk
         eLjOiZSA6B4avfrsiGhG+rdrgpz9zh/DGWWEeU+f2csTEhi1lYI4tBBBiQ8C3spM9qU4
         oHtCCpAFtwzNwnqgvosqYZ2Y9mPMBI8/A7bYgqmKhpmVFO0qSnjz1pR9+CYwH6xHEXoj
         4B0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773306722; x=1773911522;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=gMkxR4nrzpTZVtW0eZQXRORnWBJx7p+nKfbSA+TJ3Dg=;
        b=CDd2ZxjWgIV5nkM8PlI12/NIgCBVP07rirgFUU7w+9SG1A4Oz+HXh7VTmmQe6etupw
         cRjv7eXLOyav596FCCN6hgpX7xUq8LGlm5rThOCAOG+bcflY4jvvKuBqZ+sRNxANYpBY
         732QTerG9pqsRD33NLCm/K/eMAII/FHuM4wy5r+j3oqYdSd/le9eyVowGEfEkI0Jh6Cr
         qJ0tATgKhQHmibhloDml89ZSqrM/ge0cavxD9gH9+ONoL1fZpG1c6sU4hZz511WE9jah
         1z5e/B0dgfhrpip/uPETdsl6yyQVmCRLUXQHJInWrkp4T66VsUiu5AO5UKCwK7jHNkEO
         Bnrg==
X-Forwarded-Encrypted: i=1; AJvYcCXw483rPcMGrLmKW2Hdfsd3eP7RuyYtqeHlZiKYRCsxUG+sFGp/8hhBuvu6FzSuoio4Jbw3yts=@lists.linux.dev
X-Gm-Message-State: AOJu0YxX33/M1GFQ7wJG6URuVrHyNEyLYN30XlN7yoF6gwUyvHtHMJNq
	V+7EoBnjRYUpExPbvw9c3SRc5RHCwhj3QlNj7Y4H1d8KPcYrefZLfq0q/YBTxSpund3CqTHWl09
	+wrJWyByU/1l+FjbsQhDeyecEck7mPSP/r29Cjb8q
X-Gm-Gg: ATEYQzwG8D3RPIeq8j34HwGyG40tBnghGJBqvVaFfj/7msFP8ZoUFfjrde3v65WSBH4
	kHfHaVIWrkwroUAVQLLFP/2XbDPofKrTQSy5E6P6J8xRvpCVNtS5yzFMFRmMf3wdKROEiDN+kLF
	KTBZoN5jvrre68qx4lHhPNyCPbh7DPAcXtsH81Ik5a80wm6iHEpw4iKhWi6n/2TUvahOLRALNQP
	byiZz9+d09kyvtb1GxQfMmq7WBgbwSNJ7rF+L/tE8f7qPkVadARxBFVwx9Mn+rptsu5W6cLGKq7
	z00STCxYJmBQ76JhMsTnWdfsFXu6KKOs1cSyE9e0eZDM/2C52HrcfgLQRULXMgU6V+hW
X-Received: by 2002:a05:6820:169f:b0:67b:bd04:96dd with SMTP id
 006d021491bc7-67bc8a54883mr3443969eaf.64.1773306721872; Thu, 12 Mar 2026
 02:12:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <69b263e5.a00a0220.94e15.0021.GAE@google.com>
In-Reply-To: <69b263e5.a00a0220.94e15.0021.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Thu, 12 Mar 2026 09:11:50 +0000
X-Gm-Features: AaiRm53Pd29A2V6GkA_BXTHojECu7gN_TCFH705cAVzsmznuZr-pezwGCou-UDw
Message-ID: <CANp29Y4TxdyP=5JxER=kAQScY3HYsqNQp6GJ9uEGhmaiPU=ytQ@mail.gmail.com>
Subject: Re: [moderation/CI] Re: mm: switch deferred split shrinker to list_lru
To: syzbot ci <syzbot+ci6d4f8c81af5ed43e@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Thu, Mar 12, 2026 at 7:57=E2=80=AFAM syzbot ci
<syzbot+ci6d4f8c81af5ed43e@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v1] mm: switch deferred split shrinker to list_lru
> https://lore.kernel.org/all/20260311154358.150977-1-hannes@cmpxchg.org
> * [PATCH] mm: switch deferred split shrinker to list_lru
>
> and found the following issue:
> WARNING in folio_memcg
>
> Full report is available here:
> https://ci.syzbot.org/series/3cf5ecdb-21ef-4894-a22d-6eb1eb437395
>
> ***
>
> WARNING in folio_memcg
>
> tree:      mm-new
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/=
mm.git
> base:      f543926f9d0c3f6dfb354adfe7fbaeedd1277c6b
> arch:      amd64
> compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~e=
xp1~20251221153213.50), Debian LLD 21.1.8
> config:    https://ci.syzbot.org/builds/6c96ae71-4f8b-4153-8306-440a79f2b=
2e8/config
> C repro:   https://ci.syzbot.org/findings/25285d24-81d9-42b6-b715-1749d43=
db688/c_repro
> syz repro: https://ci.syzbot.org/findings/25285d24-81d9-42b6-b715-1749d43=
db688/syz_repro
>
> ------------[ cut here ]------------
> debug_locks && !(rcu_read_lock_held() || lock_is_held(&(&cgroup_mutex)->d=
ep_map))
> WARNING: ./include/linux/memcontrol.h:376 at obj_cgroup_memcg include/lin=
ux/memcontrol.h:376 [inline], CPU#1: syz.0.17/5956
> WARNING: ./include/linux/memcontrol.h:376 at folio_memcg+0x148/0x1c0 incl=
ude/linux/memcontrol.h:430, CPU#1: syz.0.17/5956
> Modules linked in:
> CPU: 1 UID: 0 PID: 5956 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:obj_cgroup_memcg include/linux/memcontrol.h:376 [inline]
> RIP: 0010:folio_memcg+0x148/0x1c0 include/linux/memcontrol.h:430
> Code: 48 c1 e8 03 42 80 3c 20 00 74 08 48 89 df e8 8f 59 fb ff 48 8b 03 5=
b 41 5c 41 5e 41 5f 5d c3 cc cc cc cc cc e8 b9 39 92 ff 90 <0f> 0b 90 eb ca=
 44 89 f9 80 e1 07 80 c1 03 38 c1 0f 8c ef fe ff ff
> RSP: 0018:ffffc90005d86b98 EFLAGS: 00010093
> RAX: ffffffff823359c7 RBX: ffff8881749d1080 RCX: ffff88817250d7c0
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
> RBP: 0000000000000000 R08: ffffea00068f8007 R09: 1ffffd4000d1f000
> R10: dffffc0000000000 R11: fffff94000d1f001 R12: dffffc0000000000
> R13: dffffc0000000000 R14: ffffea00068f8000 R15: ffffea00068f8030
> FS:  0000555584c04500(0000) GS:ffff8882a9466000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000001b2e563fff CR3: 0000000175ed0000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  __folio_freeze_and_split_unmapped+0x1db/0x31f0 mm/huge_memory.c:3766
>  __folio_split+0xa99/0x1570 mm/huge_memory.c:4029
>  madvise_cold_or_pageout_pte_range+0xe3b/0x2220 mm/madvise.c:501
>  walk_pmd_range mm/pagewalk.c:129 [inline]
>  walk_pud_range mm/pagewalk.c:223 [inline]
>  walk_p4d_range mm/pagewalk.c:261 [inline]
>  walk_pgd_range+0x1032/0x1d30 mm/pagewalk.c:302
>  __walk_page_range+0x14c/0x710 mm/pagewalk.c:410
>  walk_page_range_vma_unsafe+0x309/0x410 mm/pagewalk.c:714
>  madvise_pageout_page_range mm/madvise.c:620 [inline]
>  madvise_pageout mm/madvise.c:645 [inline]
>  madvise_vma_behavior+0x2883/0x44d0 mm/madvise.c:1356
>  madvise_walk_vmas+0x573/0xae0 mm/madvise.c:1711
>  madvise_do_behavior+0x386/0x540 mm/madvise.c:1927
>  do_madvise+0x1fa/0x2e0 mm/madvise.c:2020
>  __do_sys_madvise mm/madvise.c:2029 [inline]
>  __se_sys_madvise mm/madvise.c:2027 [inline]
>  __x64_sys_madvise+0xa6/0xc0 mm/madvise.c:2027
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7fb99159c799
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffc93688748 EFLAGS: 00000246 ORIG_RAX: 000000000000001c
> RAX: ffffffffffffffda RBX: 00007fb991815fa0 RCX: 00007fb99159c799
> RDX: 0000000000000015 RSI: 0000000000002000 RDI: 0000200000f0f000
> RBP: 00007fb991632bd9 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007fb991815fac R14: 00007fb991815fa0 R15: 00007fb991815fa0
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
> The email will later be sent to:
> [akpm@linux-foundation.org david@fromorbit.com david@redhat.com hannes@cm=
pxchg.org kas@kernel.org liam.howlett@oracle.com linux-kernel@vger.kernel.o=
rg linux-mm@kvack.org roman.gushchin@linux.dev usama.arif@linux.dev ziy@nvi=
dia.com]
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
-upstream-moderation/69b263e5.a00a0220.94e15.0021.GAE%40google.com.
