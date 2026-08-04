Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EF273DAAB8
	for <syzbot@lists.linux.dev>; Tue,  4 Aug 2026 05:56:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785823012; cv=none; b=jpDtXa4bxiOplsssX1z8mcbLc7vlwdi2vqSUqNUqC5zSBP66IWkjiieSHbglrBIyKwFOVs2WHqFmXla4p2/6oYt4nINZZ8H3u1z/ykRYRwSNIn4n77QzFDSCaDy4izTJjbrFMBMgXhG/pzQ5uRwnsWVuHLSvQ0yG7/pD019xwUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785823012; c=relaxed/simple;
	bh=XIpcj3r3YcWKiqcpXlC6N+Gs3AESCVhWad1VgzeDsQE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Yhu0moMb03P7GN/psHVOc05lUrTARCPjCQj2PPFKpXA2nw5l26gx5zL+IpjcQx16wquBhOI8Igu0Lgwg6SIXzC5uWmSBliX4RyHuOKLzj5TBOA2R7olair8FlYSlmrjQMpttwN6lBC27fWSuY6RkKJmqJkf7H5ReedvGIBgLXew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=L5blt4ar; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="L5blt4ar"
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-38e08baf860so3650344a91.2
        for <syzbot@lists.linux.dev>; Mon, 03 Aug 2026 22:56:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785823011; x=1786427811; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=WkkhbIXoG8axKsH27helYvVd967WpJzV0kiVofr/iko=;
        b=L5blt4arnMw9cus9fEGV/DbPN5bOazZ8Mpd0M4jtUrL+YMhDLh4nTjmm6b/KHEXKP4
         Dddv/0bEtgojTHKs5XllXuwJ92wfCGDM6jnHHpVCEtALcDfT5Gay8moufFirleOs9i4g
         E4p41RYslt7Nfe8CEOVeGHjLVVoe2fGqEs5ec99rLK60ZTvhLE86q9UxtIHMFEjPAY3u
         CNJ+0yOydA07DcXEL3JngCV44R/FJW3Fnx/NoshmwLRJAJxWG1Od9IEjRZDHo2lFM08q
         B5cR1nDxGC8H+Yw03e5gX9Arl33XpKlYXWXUrUhVTe9b8hRRDSV1OX474eJfxB9ObAZA
         8Atw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785823011; x=1786427811;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=WkkhbIXoG8axKsH27helYvVd967WpJzV0kiVofr/iko=;
        b=SdAPu5IpDOJXSvoE8pvgnY8TWkHfIF8NamTsyZ4dgACpxi8IcnuNz4+NB3lZi+XggD
         SOucqxaYPcJ4/im0FTrnJd165NmYupSDnsv2fhSrBp4K8RGfAUDsQ8QEgnYhW5uH7to7
         hfn7LB73kzOMK/1GLXJzcwdqYmpMSNi2UYWXDu+I5oYSdv8xt0tC9pEMtqEw4ztTz0H/
         L1YQ/yZLsMVnRXSkk6Im46nO/6KvD/sPvKQB0aCGjNTa6qRu3YbkvcPzybLVO17ral3a
         tsXjGkhavtmpqYsXjs/d+bDVjG0gkS3K/BhGqVbOiUz0NLP8KrPQNCKWcndgjFEoOm6h
         m03g==
X-Forwarded-Encrypted: i=1; AHgh+RqxWwEvpTxXmdnmv2H+L53KvbmtevwBCZRwiewHGAExiZ3tXVMvojBU1z00vn/+gVjuC0I/9V8=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx51f8R36OdeeEx2wSmcaSjroGDYLV7euCCX7gMg5wWs4aUJYHV
	zMHriPhSNuNdoFfiS1aPNGWW7IIxBdif58LapSaD0T9xo3FMADzMZBek
X-Gm-Gg: AR+sD10DO7FOEAT6jMdKFt2ORVF8j8xjEdarm9TLSKCMDGfo0H3EVDiKMPIdv0AvyrO
	rotj8IfksbKR3wukZPrMzYv/jqMzaYB7nFmAMGcrfT/9wj7hSknabE5NQE4hZK9CFfwVrWAvGP+
	q/TilU3/7LAE+aOmmUGMXXyu4Ktw8Nql9KzRq33xIrUp59tneE9wSyH3NhFAgMSx+AmgUStoLoa
	zYSTUdIMJj2boO4+bSfa+2RoY3k8cr3o92NyudyLC7OrUs6PxipfkisBwzyPxQLcZjrJ3nP/7ta
	HfC3liwevXhZwUqkOnii5gOKBfUaNA32/EM4lx0aFzgfBWwuywt+D8NBZsxT4ES6H2CpalAY8Xa
	Q9zxMvcgjMC/BRXeIYGWZ5g7yyFELTaCywfIG/4AVUcXGcV12FTp/YBMJRVzEOp66PP7vevNMC7
	J1Jxoid7wol9SM4napXrjTaKWc7dFGuIFahRr14abPraekW/l/U4jNbSijpmF+cT9b8VwYjAqQX
	tVuSjanvnFa9OzgvB2XXB0pXxjeUg/a7WM=
X-Received: by 2002:a17:90b:2dc7:b0:37f:9ce2:348c with SMTP id 98e67ed59e1d1-38fbc4eead6mr12029409a91.29.1785823010828;
        Mon, 03 Aug 2026 22:56:50 -0700 (PDT)
Received: from KASONG-MC4 ([43.132.141.25])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-38febfd8fecsm759984a91.2.2026.08.03.22.56.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Aug 2026 22:56:50 -0700 (PDT)
Date: Tue, 4 Aug 2026 13:56:39 +0800
From: Kairui Song <ryncsn@gmail.com>
To: syzbot ci <syzbot+ci218ae24e07bfb1fa@syzkaller.appspotmail.com>
Cc: akpm@linux-foundation.org, axelrasmussen@google.com, baohua@kernel.org, 
	baolin.wang@linux.alibaba.com, baoquan.he@linux.dev, cgroups@vger.kernel.org, 
	chenridong@xiaomi.com, chrisl@kernel.org, david@kernel.org, dev.jain@arm.com, 
	devnull@kernel.org, gourry@gourry.net, hannes@cmpxchg.org, hughd@google.com, 
	kasong@tencent.com, lance.yang@linux.dev, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, ljs@kernel.org, mhocko@kernel.org, muchun.song@linux.dev, 
	nico.pache@linux.dev, nphamcs@gmail.com, qi.zheng@linux.dev, rientjes@google.com, 
	roman.gushchin@linux.dev, ryan.roberts@arm.com, shakeel.butt@linux.dev, 
	shikemeng@huaweicloud.com, sj@kernel.org, surenb@google.com, tz2294@columbia.edu, 
	usama.arif@linux.dev, vbabka@kernel.org, vernon2gm@gmail.com, wangzicheng@honor.com, 
	weixugc@google.com, willy@infradead.org, ying.huang@linux.alibaba.com, 
	youngjun.park@lge.com, yuanchu@google.com, yuzhao@google.com, ziy@nvidia.com, 
	syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot ci] Re: mm/mglru: frequency guided promotion (MGLRU-FG)
 and flag cleanup
Message-ID: <anF9cewVHJ-MYdP6@KASONG-MC4>
References: <20260804-mglru-fg-v1-0-4d8dad39dad6@tencent.com>
 <6a7177f9.d35e88fd.de8b.000b.GAE@google.com>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6a7177f9.d35e88fd.de8b.000b.GAE@google.com>

On Mon, Aug 03, 2026 at 10:26:17PM +0800, syzbot ci wrote:
> syzbot ci has tested the following series
> 
> [v1] mm/mglru: frequency guided promotion (MGLRU-FG) and flag cleanup
> https://lore.kernel.org/all/20260804-mglru-fg-v1-0-4d8dad39dad6@tencent.com
> * [PATCH RFC 01/15] mm/memcontrol: make lru_zone_size atomic and simplify sanity check
> * [PATCH RFC 02/15] mm/memcontrol: allow update of LRU statistic without holding LRU lock
> * [PATCH RFC 03/15] mm/mglru: introduce and always use helpers for manipulating page flags
> * [PATCH RFC 04/15] mm/mglru: make generation page counters atomic
> * [PATCH RFC 05/15] mm/mglru: move max_seq read into walk_update_folio
> * [PATCH RFC 06/15] mm/mglru: use explicit tier range in read_ctrl_pos()
> * [PATCH RFC 07/15] mm/mglru: move refault workingset activation into lru_gen_refault
> * [PATCH RFC 08/15] mm/memcg: add folio-based lruvec live helper
> * [PATCH RFC 09/15] mm/mglru: frequency guided workingset promotion (MGLRU-FG)
> * [PATCH RFC 10/15] mm/mglru: make folio lru referenced times count a generic API
> * [PATCH RFC 11/15] mm/mglru: replace folio workinset check and update with new helper
> * [PATCH RFC 12/15] mm/smap: report workingset folios as referenced
> * [PATCH RFC 13/15] mm/huge_memory: mark file folio as accessed more accurately on split
> * [PATCH RFC 14/15] mm/khugepaged: consider workingset folios as referenced
> * [PATCH RFC 15/15] mm/madvise: convert to new lru refs API and better support for MGLRU
> 
> and found the following issue:
> WARNING in folio_inc_lru_refs
> 
> Full report is available here:
> https://ci.syzbot.org/series/5db36d1d-9faa-4882-9f0d-1a8f52132274
> 
> ***
> 
> WARNING in folio_inc_lru_refs
> 
> tree:      mm-new
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/mm.git
> base:      94f9b3980dd446b56acf1dfed649e9b32a9f3813
> arch:      amd64
> compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
> config:    https://ci.syzbot.org/builds/9f324367-2b95-4fd0-9025-fef1ff1f605a/config
> 
> page: refcount:3 mapcount:2 mapping:0000000000000000 index:0x0 pfn:0xe4ee
> flags: 0xfff00000002000(reserved|node=0|zone=1|lastcpupid=0x7ff)
> raw: 00fff00000002000 ffffea0000393b88 ffffea0000393b88 0000000000000000
> raw: 0000000000000000 0000000000000000 0000000300000001 0000000000000000
> page dumped because: VM_WARN_ON_ONCE_FOLIO(!memcg && !mem_cgroup_disabled())
> page_owner info is not present (never set?)
> ------------[ cut here ]------------
> 1
> WARNING: ./include/linux/memcontrol.h:745 at folio_inc_lru_refs+0xb4f/0xc10, CPU#0: mount/5025
> Modules linked in:
> CPU: 0 UID: 0 PID: 5025 Comm: mount Not tainted syzkaller #0 PREEMPT(full) 
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
> RIP: 0010:folio_inc_lru_refs+0xb4f/0xc10
> Code: ff 4c 89 e7 e8 c2 ae fd ff e9 e9 fc ff ff e8 18 91 ba ff 4c 89 e7 48 c7 c6 20 90 f8 8b e8 99 b0 1b ff c6 05 a6 a9 34 0e 01 90 <0f> 0b 90 e9 85 f6 ff ff e8 f4 90 ba ff e9 29 f8 ff ff 44 89 f1 80
> RSP: 0018:ffffc9000324f4c0 EFLAGS: 00010246
> RAX: 8e914a919570c700 RBX: 0000000000000000 RCX: 0000000000000001
> RDX: 0000000000000000 RSI: ffffffff8e4b4187 RDI: ffff888174f53c00
> RBP: ffffc9000324f5d0 R08: 0000000000000003 R09: 0000000000000004
> R10: dffffc0000000000 R11: fffffbfff1d3ca24 R12: ffffea0000393b80
> R13: 1ffffd4000072770 R14: 1ffff92000649ea8 R15: dffffc0000000000
> FS:  0000000000000000(0000) GS:ffff88818d949000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007fb77b215440 CR3: 000000000e946000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  __zap_vma_range+0x20f5/0x4f70
>  unmap_vmas+0x390/0x550
>  exit_mmap+0x293/0x9f0
>  __mmput+0x118/0x420
>  exit_mm+0x221/0x2d0
>  do_exit+0x6cd/0x2360
>  do_group_exit+0x22d/0x2f0
>  __x64_sys_exit_group+0x3f/0x40
>  x64_sys_call+0x221a/0x2240
>  do_syscall_64+0x174/0x580
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7fb77b2d3a90
> Code: Unable to access opcode bytes at 0x7fb77b2d3a66.
> RSP: 002b:00007ffe32d58618 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
> RAX: ffffffffffffffda RBX: 00007fb77b3c4860 RCX: 00007fb77b2d3a90
> RDX: 00000000000000e7 RSI: 000000000000003c RDI: 0000000000000000
> RBP: 00007fb77b3c4860 R08: 00007ffe32d58490 R09: 00007ffe32d58570
> R10: 00007ffe32d584d0 R11: 0000000000000246 R12: 0000000000000000
> R13: 0000000000000000 R14: 00007fb77b3c8658 R15: 0000000000000001
>  </TASK>

OK, so we might hit a uncharged folio in folio_mark_access, which isn't
strange, right now it will just skip the gen bump and work as expected,
problem is it's triggering this warning, and doing redundant work for
lruvec lookup. To fix that, checking flags first then the lruvec should
be good.

Will do in V2.
