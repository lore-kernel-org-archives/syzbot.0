Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.167.200
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795171622;
	b=GioLtqK0cQifOtlR6qtiNA/thhdHLKbt2wBunhAuFXSF3yqOOIfsC99z9+SOXlGW0oHo
	 nzJtgK/0xov7AJi/IdJjihDylUkrrIlUvj50vwsE8CN+E7+DHladaPN+uyfKP+PdhFxqU
	 hYCmIZcjB0tKm5PU0jNHECRLbKDLfDpo/Aao0yuZjth0aR7RcbAVS+XADfg+ieTBWbDyi
	 WNhJEdpzKTmmRtQ9xfU5AyvrLG5CWurbuhnv57J4xlNRFI0V5Fsq00dYs5KFPGPSFauf9
	 vWWiMOOEAHt7ZW3X6fspemR/DhFHoucoKL68xQwdPHpsX1/0f/r6OJT3ZlNduZ6S9wg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795171622;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 MIME-Version:X-Received:Date:X-Google-Appengine-App-Id:
	 X-Google-Appengine-App-Id-Alias:Message-ID:Subject:From:To:Cc:
	 Content-Type:Content-Transfer-Encoding;
	bh=H6ZHNO9FZfgFCM0yRA10imr4q8nbNEv0LjAlMb7hcJM=;
	b=xOpMJs8+DUo1/VEPwYYLA7BYIvk5qCKqX8qeRp1P5vrWyBhGkMKo1m7Ra4bJxAwLfBJl
	 9y4XW3hmpVzcYY5FHtKqzajWu9ntslTiXYeP/lYvCq7q+nzmz/hJe6l0bsj+Hsf0i08LE
	 HiNa5dtuEL9cFi9OXQo8+APPh8Dv+tzem7hfjhmEXaquXBCreToGFmqeGMGqcTFJVQWyF
	 D4M5RZjz/SYgsKw6OY1Qr7wb17M3go7iy0xHwodFLyLxuX60NtOilSXVp08ToRyRMT3pO
	 1HTAd/sdueRBfPLVNm76JgL10FZt+MTW/eiAYqLYwopF01y+k7sHFecZ0nTdU6YuZtA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=syzkaller.appspotmail.com;
	spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	arc=none smtp.remote-ip=209.85.167.200
Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com [209.85.167.200])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35ED9606A33C
	for <syzbot@lists.linux.dev>; Fri, 20 Nov 2026 10:47:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 35ED9606A33C
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f200.google.com with SMTP id 5614622812f47-4b597558c4cso1064326b6e.1
        for <syzbot@lists.linux.dev>; Fri, 20 Nov 2026 02:47:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795171621; x=1795776421;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:date:mime-version:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=H6ZHNO9FZfgFCM0yRA10imr4q8nbNEv0LjAlMb7hcJM=;
        b=CBa42OrNTPMjlrDu1flUnOlQeKvk9cgY9wT6JTLm0hrsmxdKZTsOTFSPoVrofi0Nos
         rasT2dYwr4Uwdlwds2qr5tJk1FIHDoPS8jWqDgtlNghwbCfKFyFWCDTSsGNyUx5PG2Ei
         ozh9u7jegTDjnXLhn32hlnqc+zHAEXj43pGwVAHSSdr1qWJJXTK5zQddhThuidUlEnep
         fMjMk739MTOsbDtVr3osx38GAAlx4Aufu8WUVFQ5vb9BYkeGWzQKgT11n+pSwJ0a1yvJ
         OOjBIIQ2gX3tbaKiXSRCiquKfoWvVcVioVQ0L8sX9MppTAISnuOc1ai17fbFTwrUPErw
         HAYg==
X-Gm-Message-State: APuU4Z9fM95CcTKdGnXIwCcy/JAjzze89HXQtd70PjtGo5g5dMAyvQD1
	rFeRcdOmY0YB3G/DQgByC2Kl/KT/div8wctx2ziBghWA7gLgOJwMKEywFT4Bs70y69qfe4xmbws
	FkyTUoWuW6/PvGpC/SIFCk5Culj1uzhnHUPl0wynM69sn1PGP+HxESvcCgJw=
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Post: <mailto:syzbot@lists.linux.dev>
List-Help: <mailto:syzbot+help@lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
List-Owner: <mailto:syzbot+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-Received: by 2002:a05:6808:c133:b0:571:e1c7:e906 with SMTP id
 5614622812f47-57a0cfde1a1mr3218200b6e.64.1795171621231; Fri, 20 Nov 2026
 02:47:01 -0800 (PST)
Date: Fri, 20 Nov 2026 02:47:01 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6b002525.a159c4fa.1dac72.000e.GAE@google.com>
Subject: [moderation/CI] Re: userfaultfd: assorted fixes (part 1)
From: syzbot ci <syzbot+ci32ea311716440601@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v2] userfaultfd: assorted fixes (part 1)
https://lore.kernel.org/all/20261116-uffd-state-fixes-v2-0-4397a0196479@col=
umbia.edu
* [PATCH v2 1/9] userfaultfd: use anonymous memory for UFFDIO_ZEROPAGE on p=
rivate file mappings
* [PATCH v2 2/9] userfaultfd: refuse UFFDIO_MOVE into a non-present huge de=
stination PMD
* [PATCH v2 3/9] fs/proc/task_mmu: downgrade writable migration entries in =
PAGEMAP_SCAN write-protect
* [PATCH v2 4/9] mm/migrate: keep the uffd bit when restoring a writable mi=
gration entry
* [PATCH v2 5/9] fs/proc/task_mmu: write-protect device-private THPs in PAG=
EMAP_SCAN
* [PATCH v2 6/9] mm/huge_memory: build the moved huge zero PMD from the des=
tination VMA
* [PATCH v2 7/9] mm/mremap: resolve uffd state when the context is dropped,=
 not during the move
* [PATCH v2 8/9] mm/migrate_device: do not migrate a uffd-protected zero pa=
ge
* [PATCH v2 9/9] mm/userfaultfd: check hugetlb end alignment in UFFDIO_UNRE=
GISTER pre-scan

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/df454fee-723d-460c-b690-eed0efd62886

***

kernel build error

tree:      drm-next
URL:       https://gitlab.freedesktop.org/drm/kernel.git
base:      601c30449c80926947d4820d50cec974687d1d11
arch:      amd64
compiler:  Debian clang version 22.1.8 (1~deb13u4), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/660c1e39-c2f3-4ef1-8213-53c924b66a8=
c/config

mm/userfaultfd.c:3145:3: error: call to undeclared function 'userfaultfd_cl=
ear_ptes'; ISO C99 and later do not support implicit function declarations =
[-Wimplicit-function-declaration]

***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[aarcange@redhat.com akpm@linux-foundation.org amd-gfx@lists.freedesktop.or=
g apopple@nvidia.com arnd@arndb.de avagin@gmail.com balbirs@nvidia.com baoh=
ua@kernel.org baolin.wang@linux.alibaba.com byungchul@sk.com dakr@kernel.or=
g david@kernel.org dev.jain@arm.com dri-devel@lists.freedesktop.org felix.k=
uehling@amd.com gourry@gourry.net intel-xe@lists.freedesktop.org jannh@goog=
le.com jgg@ziepe.ca joshua.hahnjy@gmail.com jthoughton@google.com kas@kerne=
l.org lance.yang@linux.dev leitao@debian.org leon@kernel.org liam@infradead=
.org linux-fsdevel@vger.kernel.org linux-kernel@vger.kernel.org linux-mm@kv=
ack.org ljs@kernel.org lyude@redhat.com matthew.brost@intel.com mhocko@suse=
.com miko.lenczewski@arm.com mirq-linux@rere.qmqm.pl muchun.song@linux.dev =
nico.pache@linux.dev nouveau@lists.freedesktop.org osalvador@suse.de peterx=
@redhat.com pfalcato@suse.de rppt@kernel.org ryan.roberts@arm.com sfr@canb.=
auug.org.au stable@vger.kernel.org surenb@google.com thomas.hellstrom@linux=
.intel.com tz2294@columbia.edu usama.anjum@arm.com usama.arif@linux.dev vba=
bka@kernel.org ying.huang@linux.alibaba.com ziy@nvidia.com]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

