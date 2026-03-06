Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com [209.85.210.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4521C34DCF3
	for <syzbot@lists.linux.dev>; Fri,  6 Mar 2026 23:58:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772841483; cv=none; b=KrRUyopNcWVqI2nAbuS5VZM6cRWHOl9Yztkg8hWiMxD/6ZMtlQVTsaV3CbJCMxt7CQ86PVNgFRVo/qsogeW7XcTOCvNnho1rNk04XxWnJxyFgtOT1wLJiEyqrjjzqvuN2thzxFPOEzhPp+yCe+knlIlrPnifHoMogSmWLjXpxuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772841483; c=relaxed/simple;
	bh=RleezT14pFlbRollCDKo7HIZjP+mDk9jEjgVIHCK1PE=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=ujEJOKaPW/HDKxBNIa6iKiWyRCU9hj/z04hVKSLO4uyaf3m5nF1aimNbtQ4tLdJn4BrzaBpVxBSo5PMmPgLsPNfVbAxzw5c1SVB5i6tdQG//se79Q80zmNAiDZfHB9wbtRYO8i07e8TSd217b2Cd/XRjeyPm3t7cH0SdfNvGgB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.210.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f70.google.com with SMTP id 46e09a7af769-7d4beae6581so104812534a34.2
        for <syzbot@lists.linux.dev>; Fri, 06 Mar 2026 15:58:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772841481; x=1773446281;
        h=content-transfer-encoding:cc:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xZAoN/BXTjDLgyDYV9gqkOJxo8ev5AEFL0igzrD47Ns=;
        b=dcVj78CwRkeR5ciwLL9DPRIzihnFZGXbqYBZwM5NLEI0U9T746xEjEkiyPStfy9ImI
         /+TWJzxfw4wG7amb9fi249jdaG+Zu0kVzz9fVPD63DP5Ull3DfHm6CbUDhr8Pz/4PA6f
         SvRnNvwyWGmgM/qsRJfICNpwyu2Fywt81le/y13ofacaMHVwMGaCc4x+WKF7OxrEKX5/
         12cMqYuYrY8tpnM33Az1v+NUTW++UwviPEKg8DbVZs2oHi/03VYfb+hnJVwjNQ31xs7C
         elzDLBD55veBizdbXqdC83nX5ZrBO8xo4Cjby3wah2x8JPN7S2Lxn0Her6KCN06GDN96
         wADw==
X-Gm-Message-State: AOJu0Yydrz1qd9TDiqyh4v0tX0cK67r7W1m9RqJe4vYzivppYx4MLPqM
	WNdASKDlL7anEk6S91LL5awSGlkvUTxVrxuJ64LcdRO5Lg6I0Q6JUhHLLpRTVEw6P0YxlGILrBB
	7yYHdLsnZ7m4FMw7Gxabj36kItjzKT76KVbmoctYWFVJfQFTqpHYivmfDvhg=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:827:b0:677:ca4f:e979 with SMTP id
 006d021491bc7-67b9bd39401mr2546007eaf.63.1772841481166; Fri, 06 Mar 2026
 15:58:01 -0800 (PST)
Date: Fri, 06 Mar 2026 15:58:01 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69ab6a09.050a0220.13f275.002f.GAE@google.com>
Subject: [moderation/CI] Re: support batched checking of the young flag for MGLRU
From: syzbot ci <syzbot+cie3db188b2cb17c93@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v3] support batched checking of the young flag for MGLRU
https://lore.kernel.org/all/cover.1772778858.git.baolin.wang@linux.alibaba.=
com
* [PATCH v3 1/6] mm: use inline helper functions instead of ugly macros
* [PATCH v3 2/6] mm: rename ptep/pmdp_clear_young_notify() to ptep/pmdp_tes=
t_and_clear_young_notify()
* [PATCH v3 3/6] mm: rmap: add a ZONE_DEVICE folio warning in folio_referen=
ced()
* [PATCH v3 4/6] mm: add a batched helper to clear the young flag for large=
 folios
* [PATCH v3 5/6] mm: support batched checking of the young flag for MGLRU
* [PATCH v3 6/6] arm64: mm: implement the architecture-specific test_and_cl=
ear_young_ptes()

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/ec7a1ad8-d7a8-4ed6-b974-1498b7645030

***

kernel build error

tree:      torvalds
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvald=
s/linux
base:      5ee8dbf54602dc340d6235b1d6aa17c0f283f48c
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp=
1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/ca01dc5a-e9c9-424a-9902-c53133976f6=
4/config

mm/damon/ops-common.c:93:12: error: call to undeclared function 'pmdp_clear=
_young_notify'; ISO C99 and later do not support implicit function declarat=
ions [-Wimplicit-function-declaration]

***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[akpm@linux-foundation.org axelrasmussen@google.com baohua@kernel.org baoli=
n.wang@linux.alibaba.com catalin.marinas@arm.com david@kernel.org dev.jain@=
arm.com hannes@cmpxchg.org harry.yoo@oracle.com jannh@google.com liam.howle=
tt@oracle.com linux-arm-kernel@lists.infradead.org linux-kernel@vger.kernel=
.org linux-mm@kvack.org lorenzo.stoakes@oracle.com mhocko@suse.com riel@sur=
riel.com rppt@kernel.org ryan.roberts@arm.com shakeel.butt@linux.dev surenb=
@google.com vbabka@suse.cz weixugc@google.com will@kernel.org willy@infrade=
ad.org yuanchu@google.com zhengqi.arch@bytedance.com]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

