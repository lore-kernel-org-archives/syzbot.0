Received: from mail-ot1-f45.google.com (mail-ot1-f45.google.com [209.85.210.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92FBB2D8796
	for <syzbot@lists.linux.dev>; Tue, 18 Aug 2026 08:23:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787041415; cv=pass; b=VZDwjINkdYOTmHrWJ9bU36Sf+GnlQFm9IrF5vktviB4Ebxb+/ZrtiCkTHeXO8JHFUF6NrKjoICaOlxIe3p202Y460Eo1ioNZ+DtGlOXX5uUGlJA0jSYmJm39pYxE9gR5h96ZEPqp0LmyzuzdV2zbjWrEUB9zxeTRuFCn4g/wkmo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787041415; c=relaxed/simple;
	bh=/eQJeUkR7SJoQcJe82W3YSoNFnN7rNjTBXll0MYgiqM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gZE3Tp4N2LAHkwM5vPHZFWSIAPLcnJ3rtz12+h0gc/MtvxOM/kNapsAHHfBNTUAph+bHkNCYIsdLfBaQRZjZLrlGY7XirLSAhSh+WUPjSKcEg1Kwm4AuUid8XUg78/ETkJt1IQs2/HruvKJKusoo2HOgOp1Id4hVYiiiDB6cYcA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vXBbL7XE; arc=pass smtp.client-ip=209.85.210.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vXBbL7XE"
Received: by mail-ot1-f45.google.com with SMTP id 46e09a7af769-7f42ef0b693so127461a34.2
        for <syzbot@lists.linux.dev>; Tue, 18 Aug 2026 01:23:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787041411; cv=none;
        d=google.com; s=arc-20260327;
        b=lwHJnKQgsTjn3gJsxkuhK9D/65b0ZZfAn4fkLQ5KG5cn1z+XdE0nHZF9rxGnavrjMy
         jLETWek0zUvZRGOplOuqt3rEbu51jJkV7f3dp9iIQjc/+zrBoS3oV7Idf/Eb5lU6sErA
         rC8rRQdzb7WuqxFPdWZZznr9q1pqaXihoBubPxKFzK4x1nOS/8Ye5rSuQxNsyqi3ZCyT
         yp3bSLG8akOLvvtzYAHeY3R2KCBMX3Guj9BqJOOPs/9haOkWSOZRnJaetjtXa/uHmoyr
         OLRGRu01LBLliohDkI2eLF0MLBMmDdpddKCGZjQoiKKG8FruSdqJmLCHEg0YF2BUvSpb
         sZgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=TVCshVNQ0mOkVI/yXMGupp24HkM3XyBiMFRLnVPSxVA=;
        fh=Kyi/K97OIN/FZdCxgGCyzeDckY5EcOrXeOoFITIqL+0=;
        b=BGy8QlBTb7oSsMrncneJp9OhLoFFK9Uds25QKg34cYzNnrpEuXlAavWWbC+/0geN2r
         GUvvPqfc4JP6u/STHwLA3lv3ZOHiNqHP0IB+w5QoQhEe8Q/a5wMZXiq/Bwpztx+bsOLD
         i2RtU9xExyUQfNVNdhV+LwTKc4QVMMVug+8hVnp5NO4wsspGHouUXphogxOhFjiwuMrL
         eap/wUv/5PsAfr0eXnQJR+qxaZwpq1ZxCni25PzwhVoBIIB4GSYbNDx+ac5Kxp6VpoU+
         RDdA5HPBXx1muOimXSZzD7FVMquYsn/aJhqzDVp0dQcq+pMIRwMwP1R48uMGw0S3tpOB
         Uu8Q==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787041411; x=1787646211; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=TVCshVNQ0mOkVI/yXMGupp24HkM3XyBiMFRLnVPSxVA=;
        b=vXBbL7XEAkY5OqzoRcP+5Q3Wj6uD/MjQ31rkpgIQzftalw02+ejPahxZtve9ihJ+lB
         N/CrMtJAC7kuYazv7fxmpd2kKDo58XkO6uU0k0BHfTwPfWzmYhsrYFRj0Tb5eLM57pHm
         mAIhV2gggfIkQ0Ue2T42ulySb0sSTkfFYTBp8ct5hn++/l8uUCZq31nrYb/G9HX7EbyY
         j/WeG0l4/5g4BhhQrGFKzgDmJOh3YH0lDx0eLE54+FHXv1uyld5x/R05LaTN2yB4N3M6
         2Z9JJpZ9LRofTK7qXBpxYRLY1HU/kZuVkzs5JzXHvUgcn2rdy+4uKgcT5UA7El+j90ov
         O26A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787041411; x=1787646211;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=TVCshVNQ0mOkVI/yXMGupp24HkM3XyBiMFRLnVPSxVA=;
        b=XPzRFtmLTYnVmb2ggLs8LBOEmGvoBGZv5tm3ts8k28klyIiTz7pmRKYMRJEQr8xmPM
         njMv71TKfCFcqMySadPMOizXZwWGdJ9k0wmyldqCiZgKPvwZImn4VvssLruYpADtqqM8
         ei4vJisgdwdJnDaKyLNAg8+gP32s9EVGtoheMle0RTiFa6zKovL06U/a/qGFtYyi3pK+
         x5TxnaCOTqSrabQuwG3zNgT+bW3FRCSJQhrwz5C2TBt+kjO1NB1desTZh7XeCRs/csAs
         rR/kh4sc1gxwQLO1b18we8zXoy7G1aISua6YNU7RpjcaVwxa+IfY5yFP+p9QtzgVfrTZ
         WV8g==
X-Forwarded-Encrypted: i=1; AHgh+Ro5hH3xtjRSis1M5tRaTLFxfQY69iHbOB28NGvbBOy5mOGuIDsVi4dYe2kE9ZID2IcIG8YdLSA=@lists.linux.dev
X-Gm-Message-State: AOJu0YxPfdOtwSQ19QLbcaCXbAPJ0z145YRH37SfrpQ5UYoVFUJPbVu8
	aCPDCSysNT71uzvCgK0BOdU7uVyoWoHOQO2++Q58T4NOzJuegj567GAjwkwkJ3fiQr0kgNHOSVe
	+eVrrJWfKIzkESsLlRpveqpwlIb8gbVhgyIZFJNbMJ95QZN6z6/FRiLiG
X-Gm-Gg: AR+sD11PkBXWZdgFKW5tUMIFDfdw05t5cXDdx8FTtUgqYlHPVW5xGPdybJrWYfy+ldY
	P7QkLhuvVyLs7y+qTsNCMtBjyv2TzEnXKqsM0lxsi6t7T8XzwjCuIWEdu0uKiSqmPQ05dD4aapo
	u65escfdt/jyXCT+Jb7RGFjZTokYG/Kb1hsWlkNeVYoDpElZzLsjWtN4aXM1k/QnFvjuyNG8izP
	evUkBZdcC/JTZ/rJ75TzLKhxdfGIUIpwy+qxDHBRAUASbrIiPnDewDf3jB8juswNxEmYEtnRQVV
	6gTXW70oI0ak4EZ5+KGJ/lBfmNx1yiYKi8dJYOlgOe9NW5SHZJxrR1SRge4TLGLB0K4z6HpHoJC
	pDSK05RtTFnO7DSrFx0a8/eOmhyXljdNnhicUzicF+bp31dsHRqCuCFXAjHJwohBqfiylVAwBW9
	l5kUkA7/YJy1DMZA==
X-Received: by 2002:a05:6820:1992:b0:6a1:8c8c:abd7 with SMTP id
 006d021491bc7-6b0d617ab6dmr27111965eaf.16.1787041410721; Tue, 18 Aug 2026
 01:23:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <6a83d5a2.4d75e56a.c9a88.0009.GAE@google.com>
In-Reply-To: <6a83d5a2.4d75e56a.c9a88.0009.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Tue, 18 Aug 2026 10:23:19 +0200
X-Gm-Features: AcwNN1WxstbWgjK1r5yAvn71voPv_wO81ci80pb7zVHEY0oMfbpbiNDfq76kFqQ
Message-ID: <CANp29Y7iS1nfkGSfbMMmR1mDHf=0hMY_70Ez0HcgyO9q1jhPsg@mail.gmail.com>
Subject: Re: [moderation/CI] Re: mm/memcontrol: introduce per-tier memory
 accounting and control
To: syzbot ci <syzbot+ci533f84960377f713@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Tue, Aug 18, 2026 at 5:46=E2=80=AFAM syzbot ci
<syzbot+ci533f84960377f713@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v1] mm/memcontrol: introduce per-tier memory accounting and control
> https://lore.kernel.org/all/20260818023121.100613-1-liuqiqi@kylinos.cn
> * [RFC PATCH 1/8] mm/memory-tiers: add node_to_tier_id and tier_id_to_nod=
emask
> * [RFC PATCH 2/8] mm/vmscan: add try_to_free_mem_cgroup_pages_nodemask
> * [RFC PATCH 3/8] mm/memcontrol: add per-tier page counter infrastructure=
 and lifecycle
> * [RFC PATCH 4/8] mm/memcontrol: add per-tier charge and uncharge
> * [RFC PATCH 5/8] mm/memcontrol: add per-cpu stock for tier charge/unchar=
ge
> * [RFC PATCH 6/8] mm/memcontrol: add memory.tier control file
> * [RFC PATCH 7/8] mm/memcontrol: auto-derive tier high/max from memory.hi=
gh/max
> * [RFC PATCH 8/8] cgroup: add memory_tiered_limits cgroup mount option
>
> and found the following issue:
> WARNING in uncharge_folio
>
> Full report is available here:
> https://ci.syzbot.org/series/9db711d8-d389-45d1-b245-7e8b316a8432
>
> ***
>
> WARNING in uncharge_folio
>
> tree:      torvalds
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torva=
lds/linux
> base:      dcacab904fe78d60840ba947a104993ee9ded887
> arch:      amd64
> compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~e=
xp1~20260613092250.77), Debian LLD 22.1.8
> config:    https://ci.syzbot.org/builds/bf213e6f-1b40-41fa-a938-385807688=
eec/config
>
> ------------[ cut here ]------------
> debug_locks && !(rcu_read_lock_held() || lock_is_held(&(&cgroup_mutex)->d=
ep_map))
> WARNING: ./include/linux/memcontrol.h:391 at uncharge_folio+0x459/0x5b0, =
CPU#1: udevd/5681
> Modules linked in:
> CPU: 1 UID: 0 PID: 5681 Comm: udevd Not tainted syzkaller #0 PREEMPT(full=
)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:uncharge_folio+0x459/0x5b0
> Code: c4 18 5b 41 5c 41 5d 41 5e 41 5f 5d c3 cc cc cc cc cc 48 8b 3c 24 4=
8 83 c4 18 5b 41 5c 41 5d 41 5e 41 5f 5d e9 88 79 00 00 90 <0f> 0b 90 e9 c9=
 fe ff ff 89 e9 80 e1 07 80 c1 03 38 c1 0f 8c 49 fc
> RSP: 0018:ffffc90004ff7210 EFLAGS: 00010246
> RAX: 0000000000000000 RBX: ffffc90004ff72a0 RCX: 0000000080000001
> RDX: 0000000000000000 RSI: ffffffff8e4a6d0d RDI: ffffffff8c4bb280
> RBP: ffffc90004ff72a8 R08: ffffea0006e7a7c7 R09: 1ffffd4000dcf4f8
> R10: dffffc0000000000 R11: fffff94000dcf4f9 R12: ffffea0006e7a7f8
> R13: 1ffffd4000dcf4f8 R14: 0000000000000001 R15: ffffea0006e7a7c0
> FS:  00007f1ec7ce0c80(0000) GS:ffff8882a8f6a000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f0cdf670000 CR3: 000000017358a000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  __mem_cgroup_uncharge_folios+0xfd/0x1d0
>  folio_batch_move_lru+0x86f/0xa60
>  lru_add_drain_cpu+0xbc/0x750
>  lru_add_drain+0x121/0x3e0
>  __folio_batch_release+0x48/0x90
>  shmem_undo_range+0x4e6/0x15d0
>  shmem_evict_inode+0x280/0xa80
>  evict+0x624/0xb50
>  dentry_kill+0x1b9/0x880
>  finish_dput+0x1a/0x260
>  filename_renameat2+0x61b/0x9a0
>  __se_sys_rename+0x55/0x2c0
>  do_syscall_64+0x174/0x580
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f1ec789a93b
> Code: 48 8b 15 f0 64 15 00 83 c8 ff 64 83 3a 15 75 0e 48 8b 7c 24 08 e8 d=
5 d4 07 00 f7 d8 19 c0 48 83 c4 18 c3 b8 52 00 00 00 0f 05 <48> 3d 00 f0 ff=
 ff 76 10 48 8b 15 be 64 15 00 f7 d8 64 89 02 48 83
> RSP: 002b:00007ffcb336cd08 EFLAGS: 00000202 ORIG_RAX: 0000000000000052
> RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f1ec789a93b
> RDX: 0000558c622ea032 RSI: 00007ffcb336cd28 RDI: 00007ffcb336d128
> RBP: 000055893abc0910 R08: 0000000000000006 R09: f80f8ce6f311cb22
> R10: 00000000000001b6 R11: 0000000000000202 R12: 000055893aba2730
> R13: 00007ffcb336cd28 R14: 00007ffcb336d128 R15: 0000558926efb160
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
> [akpm@linux-foundation.org cgroups@vger.kernel.org hannes@cmpxchg.org lin=
ux-kernel@vger.kernel.org linux-mm@kvack.org liuqiqi@kylinos.cn mhocko@kern=
el.org mkoutny@suse.com muchun.song@linux.dev roman.gushchin@linux.dev shak=
eel.butt@linux.dev tj@kernel.org]
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
-upstream-moderation/6a83d5a2.4d75e56a.c9a88.0009.GAE%40google.com.
