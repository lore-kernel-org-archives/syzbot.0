Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com [209.85.167.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFC2F2E2665
	for <syzbot@lists.linux.dev>; Mon, 17 Aug 2026 18:46:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786992376; cv=none; b=CitrZ+AKDOuJ+/s3mAw1MrSzxeGHVb6g4+MPRaV1MxgerXziogD+FyAE05U1c3RszCY8J1aXomtygUt8LhytzLrwV0W5GV1Lt22JomIJp5o2HhBjxDnSstEUtNZBqhiVxJfSJmy6e/qTJa2hJAXw/DkRM1DM3TE3zdcE96yzjOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786992376; c=relaxed/simple;
	bh=UxUwHHAgcfvBgsnfR1PEpB1uiq6UqDshQiL5YAZWCZ4=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=Q1cCUGMz6gd5LLzpp8+FZuquT4CO3oru7e+ChSt6Q3mi9hUTME2OWzv7SBs2D7LyAyo8ySrkwAnkb8FXvgo8WX1I2llanxa4HEkZYB2TMwGpkRkv8TBY+IOdg85eVEDvYJOaRz3KrXxyoKb2X+1DptXEjfgZEkKJiSIhztYVszc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f200.google.com with SMTP id 5614622812f47-49ab6a82cd5so5677577b6e.2
        for <syzbot@lists.linux.dev>; Mon, 17 Aug 2026 11:46:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786992374; x=1787597174;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:date:mime-version:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=03bATdLPkH35hdLyeMO+k8SzFcRocSlt9wafx+PvZOc=;
        b=eM23EUeRIa9NKUz0Z3ryGUeBCoBJDOuWtlxUSXg6PHaeaZXHVGQrtWCbldnNfbCwr3
         lgQiMSy09TjwbPImJo/K14eGRSYNNRGS/I1rnusjPGc5NDm8o6yyUFMLpjR3RO/nRF3c
         Sv7akSr6i6e6VqcDR56Ev3IQOiiLzkLroi4P3eD/PTPDyAcuUrvaML+WWKl8he3iDtwR
         JnvkkRcIX36h0uNMPFVLOA4vvoXyPLGLj2aPeqWftOn+cz2XiGv+Gil1Cr9nWKBkbck+
         pZYUKOO0ZJ5NO73qtwGPMFGp6I3iObxUJGMbNO8sf2mOUTUeY1d4XcTsGdgM0+HtG2dt
         yuMQ==
X-Gm-Message-State: AOJu0YyUrN063+jQmt3UVI4L6eriy/CRyC70MLt+WV1UjEG2UqPlBusk
	kh3ei0UYSqjyjU9qdrygrleD5clxA/g0gqI+yiBeRHJQfNuYLyw/nnrilNeF/IFUyV9GEdFq3GW
	p50JqnWlIHnsjz4VqiBftKYcyJE9aYUTeGcLJBXXi6Zr+bAEJ+oiHmoZf1Ic=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:3306:b0:495:d7ec:b6ae with SMTP id
 5614622812f47-4b241e43eb0mr26844268b6e.16.1786992373859; Mon, 17 Aug 2026
 11:46:13 -0700 (PDT)
Date: Mon, 17 Aug 2026 11:46:13 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a8356f5.dbb3a75c.20434b.006d.GAE@google.com>
Subject: [moderation/CI] Re: lib/folio_pool: Direct-Map Large Folio Pool &
 Scratchpad bump allocators
From: syzbot ci <syzbot+ci6592343467b4698a@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v1] lib/folio_pool: Direct-Map Large Folio Pool & Scratchpad bump allocato=
rs
https://lore.kernel.org/all/20260817-folio-pool-v1-v1-0-0c1d230aa3af@gmail.=
com
* [PATCH 1/9] lib/folio_pool: Introduce Direct-Map Large Folio Pool & Scrat=
chpad bump allocators
* [PATCH 2/9] netfilter/nf_tables: Add folio_scratchpad collector to struct=
 nftables_pernet
* [PATCH 3/9] bpf/verifier: Route verifier stack state node allocations to =
folio_pool
* [PATCH 4/9] drm/gpuvm: Route gpuva_op allocations to folio_scratchpad
* [PATCH 5/9] bpf/syscall: Route generic_map_update_batch key/value allocat=
ions to folio_scratchpad
* [PATCH 6/9] locking/lockdep: Fallback to folio_pool in alloc_list_entry w=
hen static pool is full
* [PATCH 7/9] locking/lockdep: Traverse adjacency lists directly in zap_cla=
ss()
* [PATCH 8/9] locking/lockdep: Shrink static list_entries array to early bo=
otstrap buffer
* [PATCH 9/9] locking/lockdep: Migrate and compact boot-time dependency gra=
ph from __initdata

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/0cb00027-e611-48c2-b3cf-f1fa17fa3ba2

***

kernel build error

tree:      net-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netdev/=
net-next.git
base:      e6a5d573d24cd375e09d24f136523cb3cc85c9d3
arch:      amd64
compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp=
1~20260613092250.77), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/fee80397-36af-4dbf-9041-4ac6840fc40=
d/config

net/netfilter/nf_tables_api.c:12172:7: error: incompatible pointer types pa=
ssing 'struct static_key_true *' to parameter of type 'struct static_key *'=
 [-Wincompatible-pointer-types]
drivers/gpu/drm/drm_gpuvm.c:1113:8: error: use of undeclared identifier 'gp=
uvm_scratchpad_key'
kernel/bpf/syscall.c:2090:42: error: incompatible pointer types passing 'st=
ruct static_key_true *' to parameter of type 'struct static_key *' [-Wincom=
patible-pointer-types]
kernel/bpf/verifier.c:19799:27: error: incompatible pointer types passing '=
struct static_key_true *' to parameter of type 'struct static_key *' [-Winc=
ompatible-pointer-types]

***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

To test a fix for this bug, please reply with `#syz test`
(on a separate line) and attach the patch to the email.

Notes:
- The patch will be applied on top of the tested series (as an
  incremental fix).
- To test a new version of the whole series, please send it directly
  to syzbot@lists.linux.dev.
- Arguments like custom git repos and branches are not supported.

The email will later be sent to:
[airlied@gmail.com akpm@linux-foundation.org aliceryhl@google.com andrii@ke=
rnel.org ast@kernel.org boqun@kernel.org boris.brezillon@collabora.com bpf@=
vger.kernel.org coreteam@netfilter.org dakr@kernel.org daniel@iogearbox.net=
 davem@davemloft.net devnull@kernel.org dri-devel@lists.freedesktop.org edd=
yz87@gmail.com edumazet@google.com emil@etsalapatis.com fw@strlen.de horms@=
kernel.org jim.cromie@gmail.com john.fastabend@gmail.com jolsa@kernel.org k=
uba@kernel.org linux-kernel@vger.kernel.org linux-mm@kvack.org longman@redh=
at.com maarten.lankhorst@linux.intel.com martin.lau@linux.dev matthew.brost=
@intel.com memxor@gmail.com mingo@redhat.com mripard@kernel.org netdev@vger=
.kernel.org netfilter-devel@vger.kernel.org pabeni@redhat.com pablo@netfilt=
er.org peterz@infradead.org phil@nwl.cc simona@ffwll.ch song@kernel.org tho=
mas.hellstrom@linux.intel.com tzimmermann@suse.de will@kernel.org yonghong.=
song@linux.dev]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

