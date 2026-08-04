Received: from mail-oa1-f47.google.com (mail-oa1-f47.google.com [209.85.160.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1342E2E0B71
	for <syzbot@lists.linux.dev>; Tue,  4 Aug 2026 05:24:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785821102; cv=pass; b=tcYozyRJ5mLGqc9NpYl4O/3w9QHDcGnhNDQGyKo1BhoQoKKNqMfNKZ8NDV56KsxuAqTgxSoD7xho/e/gGLLv7+XXyHPMHLRgbqTDvmwpwSGk5wfpTxEtvOPHTAiWF6zaV5CHoJ7Jvbq6Au72lFn7WWhQJL2C0Lu0guG8sKyN/Bg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785821102; c=relaxed/simple;
	bh=IWqQL5fpyjvTNIYkJeM02FWH+lys8VAFiOdsZz0wIJI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=P/t9q8HY/tjHt+gbFt4VfJ7SMiOaiQ/9z7jCjkjvjduTnEBWx+Gh0DkI/pyA9/KagbTks2vmAESsDjhTnpZSZkZg1s1RQ2Mt9E5bZTvsLbV2w87GakVukd6MjMOCsRJTaihDbRNTok0JCyZE6KdiwzeiBbxlwmZNl7xd6OAjISQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=m5rROQs5; arc=pass smtp.client-ip=209.85.160.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="m5rROQs5"
Received: by mail-oa1-f47.google.com with SMTP id 586e51a60fabf-448b89f700fso4072475fac.2
        for <syzbot@lists.linux.dev>; Mon, 03 Aug 2026 22:24:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785821099; cv=none;
        d=google.com; s=arc-20260327;
        b=F7FrgtaMUsTB30z5LyXw14M7j3bnriAOVOkSptaVj8pssubyYR/h0WwURURWzp/jrf
         jGSVh5QeWh7Hk3DHOLDNl8U2Fm8VrxSjJp+mxXn/EpKLM2+ijBqnGjPHQ+Ucx0YWOic/
         mwVIF042aCm4YFSNzZlF1e1rmqhG+QQPXwnHqbUfOqJlOAAgXHMOuK4oO6KMFAM6jLRj
         UKFDcnPz2rmYtzNl656xu7lmtRAzfFxX6jKtwqG8x9wnTEC3Llyu6q/i2o6K6e9/lRHy
         aliwpNLsK3d9PB4eKjL59qNBuGn47DJRRLpU85teiNOlsD12dVdJuxUhrvW6r1AFXrVU
         tRLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=OKcV7UGAmPE3b37vFlyHyOPcLTVn66GnHe4Buxb4qHI=;
        fh=Nc0rF69QJom1ZPKMEEsab9zJCPfCQ0Z3h0rbPOdKNZA=;
        b=NQdlthxpNOHBHGo/n/L82FwJNu0+zFjxINlY3FWVnjlD71VME5aCnUisALdZKaV7Ng
         rXu1J5yL01JjqZYJJtohZX6s43UmOuKcGpUYWYD/f7GGa3I9NkzD3uftIGg+5pCTrbqv
         5kD0N8bwow2JjPU+bjmBalWL3tO2P6dutxH0oYE9uu9lUabPSLwCNNhpsepzpLD422P7
         K1C3v7D5srfRneUZe14FyljrbG7GhWEdT0CKqi/2pi425WkB3KEoUU/u+fOI83e2nc4w
         19VBQXtsonsWPzv+/glx9S9cfn01nNgmeNw9GGgfykmycicf5lr8h55epYaYH3xroJqj
         elkg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785821099; x=1786425899; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=OKcV7UGAmPE3b37vFlyHyOPcLTVn66GnHe4Buxb4qHI=;
        b=m5rROQs5ahX1WFJVmlrLbHQ4AneYOHBTbHCKLIiApTqtgMjDDqttCYWpTA8+88rbVA
         HbtfNf1o2lwW8nGXhDqptpALxxs7ZDmHFp4hDII82Ilbg+3v68NUjb7nLGoNChxEkToY
         1EVruBrFXCKsYXv1gTJxmRZLwpIFADNtGjo3sDdOIrpd5oG4FKQvVNwJuzk0Dl3N6/9H
         GsdYy2yTB9iPzhnd0kqjM1CvpOgLufa4htoayvAn9+uDdJBYBj5VedoZlaU8yS3QEvbH
         w/hZxGUkv5qXxIgKyy+QOeoFi2xWXcFeNTNJMN2FIA4U7m+S24x2fcD2JtnTIP1L65Fj
         7ZHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785821099; x=1786425899;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=OKcV7UGAmPE3b37vFlyHyOPcLTVn66GnHe4Buxb4qHI=;
        b=RbDkwIZRCiKm2VEZJ0BKDoZi77smlrG4xrZV7UxxvWwx8+84d6L0K6GW7Hs6KRTqSp
         aZmFHmrZPoqkT5mvZdSrcOTh2KzNJgMPQ3PTAFo40X8IVhKKetjODSM9/1+0TtlZifwz
         By5dUj4cbrLiCMHFw9Uij7IO5wbVw0mxpMVcWM2GyY0pz/r7uOheiaNRfmJFIzuJLo2V
         oXTkGuuZcQ5XBBOMpgyMwCtADt+irMcpEhVRRtwU7v0B+d5ylbaaFh/MA4lWfvLWPK4S
         u/mNe1rZuS0IxK0X2SJBnWQIRWEdMf/WS/Bghsg2ciXq827qCvrxWfzv0Xj9fqE7Md60
         6iIg==
X-Forwarded-Encrypted: i=1; AHgh+RoBRP8vV40gs63J78tjRl1xnDwmlbnhTZB4F+VCWMjFrMutmfeMvyvSrV6081ZJkHoZMEIYCUY=@lists.linux.dev
X-Gm-Message-State: AOJu0YzhzmfHs8UoKX+vZmOYQjF4QTZ3bBwE+p2idghbwFSasDYpDwC7
	7QJTJiYoEFzhqu2yfwk4c0DkcWAOGESMpenhIcIX8j5lGC0ByR9uMiQlXZTUsENQNvUNi1p8Uw3
	+VJlQhmwzmhyMyl1EL/tZTV5VEPcVYi1Y1FO7VNK8
X-Gm-Gg: AR+sD13Ezb4b6VhCy1diZ4fa6MRTKzkv/Fw/2iQEMJ2+RJGK6OebqweianNp+jS3V2Z
	4GjrtKGL7/1Zt0+rsNrFA2TzELzzo1qgAO6pGFWA56Jg8Vhdv3vyH9/8sR7IEY+X50/Omcoo2JB
	Z1OPO3KFzWFQbLUvPhwKBt6Y7AZQnfJNGsVjxn5e9k9Eph4u25xlDpLSmKSy0SNwTo7CIo0oQ3f
	5f6yRPBp6uEYAj4N1bddHNE4X/xuxel9Y2NFJZ5/+98vunkTxLVGW933y3wdC6uBgYeBe22NN5g
	yvw8sLrgkJwlBYg75bYSrJULbjobqHkpCz9UOInwFaoYuIlaTXNJWcoea3oaMGXGEvMloUTqmcP
	Zb0ksaBaggPIWq81GuayEzKZ6D9KQJyhW2lOGB0+3KtXwk3LyWOaUfu8lmT39UDFP4y5UayXmvw
	cjjyiFMPtH4Mpag7A=
X-Received: by 2002:a05:6871:654:b0:456:5d8b:5681 with SMTP id
 586e51a60fabf-45905730fc2mr19806322fac.1.1785821098290; Mon, 03 Aug 2026
 22:24:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <6a7117ea.d35e88fd.de8b.0002.GAE@google.com>
In-Reply-To: <6a7117ea.d35e88fd.de8b.0002.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Tue, 4 Aug 2026 07:24:47 +0200
X-Gm-Features: AUfX_mw9hD0pYjJN2cbLfVD-3t5H0XJzv9EEUSxc3uc91yOPgaaxVcFnNF9HUI8
Message-ID: <CANp29Y7jfqQNEup+6DehLDvV6KExkWbPu-Po06kC3BORGuSD8w@mail.gmail.com>
Subject: Re: [moderation/CI] Re: mm/mglru: frequency guided promotion
 (MGLRU-FG) and flag cleanup
To: syzbot ci <syzbot+ci1d3cd18901bb71c1@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Tue, Aug 4, 2026 at 12:36=E2=80=AFAM syzbot ci
<syzbot+ci1d3cd18901bb71c1@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v1] mm/mglru: frequency guided promotion (MGLRU-FG) and flag cleanup
> https://lore.kernel.org/all/20260804-mglru-fg-v1-0-4d8dad39dad6@tencent.c=
om
> * [PATCH RFC 01/15] mm/memcontrol: make lru_zone_size atomic and simplify=
 sanity check
> * [PATCH RFC 02/15] mm/memcontrol: allow update of LRU statistic without =
holding LRU lock
> * [PATCH RFC 03/15] mm/mglru: introduce and always use helpers for manipu=
lating page flags
> * [PATCH RFC 04/15] mm/mglru: make generation page counters atomic
> * [PATCH RFC 05/15] mm/mglru: move max_seq read into walk_update_folio
> * [PATCH RFC 06/15] mm/mglru: use explicit tier range in read_ctrl_pos()
> * [PATCH RFC 07/15] mm/mglru: move refault workingset activation into lru=
_gen_refault
> * [PATCH RFC 08/15] mm/memcg: add folio-based lruvec live helper
> * [PATCH RFC 09/15] mm/mglru: frequency guided workingset promotion (MGLR=
U-FG)
> * [PATCH RFC 10/15] mm/mglru: make folio lru referenced times count a gen=
eric API
> * [PATCH RFC 11/15] mm/mglru: replace folio workinset check and update wi=
th new helper
> * [PATCH RFC 12/15] mm/smap: report workingset folios as referenced
> * [PATCH RFC 13/15] mm/huge_memory: mark file folio as accessed more accu=
rately on split
> * [PATCH RFC 14/15] mm/khugepaged: consider workingset folios as referenc=
ed
> * [PATCH RFC 15/15] mm/madvise: convert to new lru refs API and better su=
pport for MGLRU
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
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/=
mm.git
> base:      94f9b3980dd446b56acf1dfed649e9b32a9f3813
> arch:      amd64
> compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~e=
xp1~20260613092250.77), Debian LLD 22.1.8
> config:    https://ci.syzbot.org/builds/9f324367-2b95-4fd0-9025-fef1ff1f6=
05a/config
>
> page: refcount:3 mapcount:2 mapping:0000000000000000 index:0x0 pfn:0xe4ee
> flags: 0xfff00000002000(reserved|node=3D0|zone=3D1|lastcpupid=3D0x7ff)
> raw: 00fff00000002000 ffffea0000393b88 ffffea0000393b88 0000000000000000
> raw: 0000000000000000 0000000000000000 0000000300000001 0000000000000000
> page dumped because: VM_WARN_ON_ONCE_FOLIO(!memcg && !mem_cgroup_disabled=
())
> page_owner info is not present (never set?)
> ------------[ cut here ]------------
> 1
> WARNING: ./include/linux/memcontrol.h:745 at folio_inc_lru_refs+0xb4f/0xc=
10, CPU#0: mount/5025
> Modules linked in:
> CPU: 0 UID: 0 PID: 5025 Comm: mount Not tainted syzkaller #0 PREEMPT(full=
)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:folio_inc_lru_refs+0xb4f/0xc10
> Code: ff 4c 89 e7 e8 c2 ae fd ff e9 e9 fc ff ff e8 18 91 ba ff 4c 89 e7 4=
8 c7 c6 20 90 f8 8b e8 99 b0 1b ff c6 05 a6 a9 34 0e 01 90 <0f> 0b 90 e9 85=
 f6 ff ff e8 f4 90 ba ff e9 29 f8 ff ff 44 89 f1 80
> RSP: 0018:ffffc9000324f4c0 EFLAGS: 00010246
> RAX: 8e914a919570c700 RBX: 0000000000000000 RCX: 0000000000000001
> RDX: 0000000000000000 RSI: ffffffff8e4b4187 RDI: ffff888174f53c00
> RBP: ffffc9000324f5d0 R08: 0000000000000003 R09: 0000000000000004
> R10: dffffc0000000000 R11: fffffbfff1d3ca24 R12: ffffea0000393b80
> R13: 1ffffd4000072770 R14: 1ffff92000649ea8 R15: dffffc0000000000
> FS:  0000000000000000(0000) GS:ffff88818d949000(0000) knlGS:0000000000000=
000
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
> [akpm@linux-foundation.org axelrasmussen@google.com baohua@kernel.org bao=
lin.wang@linux.alibaba.com baoquan.he@linux.dev cgroups@vger.kernel.org che=
nridong@xiaomi.com chrisl@kernel.org david@kernel.org dev.jain@arm.com devn=
ull@kernel.org gourry@gourry.net hannes@cmpxchg.org hughd@google.com kasong=
@tencent.com lance.yang@linux.dev linux-kernel@vger.kernel.org linux-mm@kva=
ck.org ljs@kernel.org mhocko@kernel.org muchun.song@linux.dev nico.pache@li=
nux.dev nphamcs@gmail.com qi.zheng@linux.dev rientjes@google.com roman.gush=
chin@linux.dev ryan.roberts@arm.com ryncsn@gmail.com shakeel.butt@linux.dev=
 shikemeng@huaweicloud.com sj@kernel.org surenb@google.com tz2294@columbia.=
edu usama.arif@linux.dev vbabka@kernel.org vernon2gm@gmail.com wangzicheng@=
honor.com weixugc@google.com willy@infradead.org ying.huang@linux.alibaba.c=
om youngjun.park@lge.com yuanchu@google.com yuzhao@google.com ziy@nvidia.co=
m]
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
-upstream-moderation/6a7117ea.d35e88fd.de8b.0002.GAE%40google.com.
