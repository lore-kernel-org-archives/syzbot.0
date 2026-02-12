Received: from mail-ot1-f46.google.com (mail-ot1-f46.google.com [209.85.210.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18403213E89
	for <syzbot@lists.linux.dev>; Thu, 12 Feb 2026 18:05:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770919561; cv=pass; b=jQwCqBjLBVbyWD+VRsRqI507jE8jXokMgKj/uEEi9nCNbmZhAgptjiTpqUXGXdEFugU0p3CeDTp+U2+amBL4TXhS5zpfCwKk6ObESsgI4Rx43345aKplvDNcs58zeWBlg0WvDuyrxGGzZzK9+mjuTElFPNoHUlbtPIgHnWy89Z4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770919561; c=relaxed/simple;
	bh=My0z4pE/xfpEQhgmlANiSP9409yj96g52Y2fo9jj4Lo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Gk1qA7EgMbHr+hAGoiPNqskrhL5ErhX+3/RSNx5Q4KBvmqCiECwxh2JS9CKsJqN7a8ZHk7umvFcFKeu4XxwJLyz6pcvm/H2Q7A33k2WEp7TMHqXNw24coP+t04MQC8A7kL9H/8msBJWnEevKJNopnlfSR/XChkLx3SULm39xyUA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=oVNoDHTM; arc=pass smtp.client-ip=209.85.210.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="oVNoDHTM"
Received: by mail-ot1-f46.google.com with SMTP id 46e09a7af769-7d4be7c4ebeso38349a34.1
        for <syzbot@lists.linux.dev>; Thu, 12 Feb 2026 10:05:59 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770919559; cv=none;
        d=google.com; s=arc-20240605;
        b=JYMq9zZz0sMOrl2ZYDdjLavmTts+2nF7Se1J+dYQjCgnVJrnXizvVHb9W79HZfbqaC
         eCVpJBpEOnyweTlJwK/GPb7G6lQhh6JyZHiwBzqIK6E2XOh0ugWFlaLpsLwXa064RTkA
         8JvMNFt1LpnWfYNm6LCUr4LTz6dzV9jf6dtR37hyum3AXMU5RxT1J668wzhUgB39v228
         O0uDBkK552fSe+8zIUSlzrqypYB7qj+Ltcvqmc8kR7+jA7zQ+lKRfOIeLm1v+oqQt/29
         6Pmi0XMVhX2OF7AYNREksQqDYh82XTAKrLJGmC2iv+r6i85sFhlE/i/Sm8OnvvMgsc/1
         bUFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=BVjTcVu8PXML5DTRizYsTiN++wd4kKKzJNCqMhkXdjs=;
        fh=6eFSp5VG5+uoJKH/l85E5M7wA7x3KGIilP1nl9gMjdQ=;
        b=J8UL8JJLg8KCkosa4nR/JyK3gjfv+6MGkWBASk/ACYMzu+Mg1UGT/c1RHvXMZSpQf2
         BqLjQQRNVLsS29+zW+i8CTyn5UlkJ3VJ2E3XnV4FgFRfWRhTk/bwsLkgHl1uw+1LInu9
         jV3IGHTHB/99hRmQKo+1PdbMgqnOAJPJGFY4l2DWqj1xXjfBEYJsDHxA+50fL7WWh4Mi
         VsWW4h5WMtSLkJFlNuE7qR4AxvV75TLG/JnyWWT36MG62QQgU6I9VwENxX5V38UprL1p
         pezzHHAi2RhdOSYEPbVJ0arnHqkkeyJq02PJSka3JCzKUV43VZ/jtcNQK19s7YBAXeop
         rZBA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770919559; x=1771524359; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BVjTcVu8PXML5DTRizYsTiN++wd4kKKzJNCqMhkXdjs=;
        b=oVNoDHTMn0JA8PdpSuf8D7bR3KgOoX4cqhCYYjf29q4DT8nsE0q9RZeFj9LVm8vTuR
         tnFYORexFOSVDJvc5gx6XJIGjAIEgPujOHWO2cJeXVExFDJHHNSaXVDMeyKIxCXKi1e4
         DZylD+K04rimeNNgmnoQGKE7dW9zlcXBManIvt/c7ucMo/k86ibtdfs5S/dK1TQC2mSx
         6nDhUF+ubzITf9WWBlUwmhfimjO+3UX9XVOy8U+AlHgohr0R8fgZwOGNbCetxGHRTnCo
         VDnAqC22tEuZNKPw25w0BuP+qMZbohxKjLTUTBsjoExby8yesEg/VwoW3YIyqkq6tHfe
         nJDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770919559; x=1771524359;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=BVjTcVu8PXML5DTRizYsTiN++wd4kKKzJNCqMhkXdjs=;
        b=IaDrq5Itoq12Cl13DA7cr5cp6FmCrJw4572vZOLPAAPcEArKo/l6XfitjOAWwYDRtt
         fiBPT5aidS8szV+JtpKrruIMRVUXWJd2B2269RTvOomnmIkOj3RNG6vBUJb4zienZtbO
         MK5b8O/H03znP9SshFIcKYydkgSOuSiANrtdAi0qAqsUG5WzrpmEJKraNSJ3IlgFfXna
         t3cOsWPXv20sodXUzGhIU3BRKaKpwCARoOYxFbiTLXiTmT68YoIjSoMDTiyrRoZgdrFm
         D8RZNyHDmbhTWZJGYdPqt5YsX6Sx8PWkYC4D25BBEYrXqAHq/zqOW6SX6N5zpx76E11t
         As6Q==
X-Forwarded-Encrypted: i=1; AJvYcCVP4xaQDM69Cr43bDX0G6Y90C20hJ3lnhV/mpWAH9AZsincXx9NEXHhyWhMlocsrn1BoJpkjns=@lists.linux.dev
X-Gm-Message-State: AOJu0YxPn5ICUZ5kLXnP0RS616BYvyiIsn1UgpGoXBsAZwL1qCtNtcb3
	E4nJ5vkycDnnRqv0qCK8o6ViFlK8A31jrUQN/UBca4HGj3bCuizKjwgQYZuqOfxpE0KWlAkn4wu
	Lu++3IRfDApmyvefvjgiXAqMSKygwRwk8ywJgrjJQUPXoQQ7tOEWISvXN
X-Gm-Gg: AZuq6aLs6ssGJREYCzqR0/ZmJId4XNIjvOR+C0R68kXLuSyjPDr0AGMRgWrSEVXQe9+
	lBo+wgTckCiRyq4J/TZnR3ALSBAP+cm50kCbVqasNNfimdm6dXB8+hIo15yyYfh0vhhKCZk5Fuc
	NeeDwws4q7IcN50h89nliTKZGjPw1UmdDdYRJkSmldp1vbFJ/D6rNTG/cvTdsDyVaAH04/Nbj9H
	E5khsN+lQ58fCLJf8lIvSxYbcs/Th4kKMAJ8zAwzoiVspwef67LH+UqDhHLTvQNqyHkrHCxmxi7
	+juzd+KuKXDcRnGNRXjB6bs3Bcd0uPiPA7lmO6J+zTt7jV9ZQaDiNfbymKEmtozXhLglpA==
X-Received: by 2002:a05:6820:80c5:b0:663:a18:ee34 with SMTP id
 006d021491bc7-6759a749324mr1448602eaf.39.1770919558636; Thu, 12 Feb 2026
 10:05:58 -0800 (PST)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <698e1521.a70a0220.2c38d7.009b.GAE@google.com>
In-Reply-To: <698e1521.a70a0220.2c38d7.009b.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Thu, 12 Feb 2026 19:05:46 +0100
X-Gm-Features: AZwV_QhbZKAyumSdw-4MX3gav9if7wRPCXQ9qbuhDEU7ltZHsNDmgm_ggv2eR2A
Message-ID: <CANp29Y6dn0yd8c8mLJoEj-9-DLEx3+NtCwmoGzUaYExS5ivGog@mail.gmail.com>
Subject: Re: [moderation/CI] Re: improve per-node allocation and reclaim visibility
To: syzbot ci <syzbot+ci2ee21f12ad886ab7@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Thu, Feb 12, 2026 at 7:00=E2=80=AFPM syzbot ci
<syzbot+ci2ee21f12ad886ab7@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v1] improve per-node allocation and reclaim visibility
> https://lore.kernel.org/all/20260212045109.255391-1-inwardvessel@gmail.co=
m
> * [PATCH 1/2] mm/mempolicy: track page allocations per mempolicy
> * [PATCH 2/2] mm: move pgscan and pgsteal to node stats
>
> and found the following issue:
> WARNING in __mod_node_page_state
>
> Full report is available here:
> https://ci.syzbot.org/series/4ec12ede-3298-43a3-ab6b-79d47759672e
>
> ***
>
> WARNING in __mod_node_page_state
>
> tree:      mm-new
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/=
mm.git
> base:      72a46cdd4ef13690beb8c5a2f6a2023fd7ef2eb4
> arch:      amd64
> compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~e=
xp1~20251221153213.50), Debian LLD 21.1.8
> config:    https://ci.syzbot.org/builds/0f678e4c-a4ba-4f17-8ed7-8ae99e56a=
463/config
>
> ------------[ cut here ]------------
> IS_ENABLED(CONFIG_PREEMPT_COUNT) && __lockdep_enabled && (preempt_count()=
 =3D=3D 0 && this_cpu_read(hardirqs_enabled))
> WARNING: mm/vmstat.c:396 at __mod_node_page_state+0x126/0x170, CPU#0: kth=
readd/2
> Modules linked in:
> CPU: 0 UID: 0 PID: 2 Comm: kthreadd Not tainted syzkaller #0 PREEMPT(full=
)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:__mod_node_page_state+0x126/0x170
> Code: 5c 41 5d 41 5e 41 5f 5d c3 cc cc cc cc cc 48 89 df 4c 89 e6 44 89 f=
a e8 68 00 00 00 31 db eb cc 90 0f 0b 90 e9 3e ff ff ff 90 <0f> 0b 90 eb 80=
 48 c7 c7 e0 c6 64 8e 4c 89 f6 e8 66 3c d3 02 e9 28
> RSP: 0000:ffffc900000773d0 EFLAGS: 00010202
> RAX: 0000000000000001 RBX: 0000000000000001 RCX: 0000000000000000
> RDX: 0000000000000001 RSI: 000000000000003d RDI: ffff88815fffb380
> RBP: dffffc0000000000 R08: ffffffff8fef2977 R09: 1ffffffff1fde52e
> R10: dffffc0000000000 R11: fffffbfff1fde52f R12: ffff88815fffb380
> R13: ffffffff92f50f00 R14: 000000000000003d R15: 000000000000003d
> FS:  0000000000000000(0000) GS:ffff88818e0f0000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: ffff88823ffff000 CR3: 000000000e346000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  alloc_pages_mpol+0x407/0x740
>  alloc_pages_noprof+0xa8/0x190
>  get_free_pages_noprof+0xf/0x80
>  __kasan_populate_vmalloc+0x38/0x1d0
>  alloc_vmap_area+0xd21/0x1460
>  __get_vm_area_node+0x1f8/0x300
>  __vmalloc_node_range_noprof+0x372/0x1730
>  __vmalloc_node_noprof+0xc2/0x100
>  dup_task_struct+0x228/0x9a0
>  copy_process+0x508/0x3980
>  kernel_clone+0x248/0x870
>  kernel_thread+0x13f/0x1b0
>  kthreadd+0x4f9/0x6f0
>  ret_from_fork+0x51b/0xa40
>  ret_from_fork_asm+0x1a/0x30
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
> [akpm@linux-foundation.org apopple@nvidia.com axelrasmussen@google.com by=
ungchul@sk.com cgroups@vger.kernel.org david@kernel.org eperezma@redhat.com=
 gourry@gourry.net hannes@cmpxchg.org inwardvessel@gmail.com jasowang@redha=
t.com joshua.hahnjy@gmail.com kernel-team@meta.com liam.howlett@oracle.com =
linux-kernel@vger.kernel.org linux-mm@kvack.org lorenzo.stoakes@oracle.com =
matthew.brost@intel.com mhocko@suse.com mst@redhat.com muchun.song@linux.de=
v rakie.kim@sk.com roman.gushchin@linux.dev rppt@kernel.org shakeel.butt@li=
nux.dev surenb@google.com vbabka@suse.cz virtualization@lists.linux.dev wei=
xugc@google.com xuanzhuo@linux.alibaba.com ying.huang@linux.alibaba.com yua=
nchu@google.com zhengqi.arch@bytedance.com ziy@nvidia.com]
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
-upstream-moderation/698e1521.a70a0220.2c38d7.009b.GAE%40google.com.
