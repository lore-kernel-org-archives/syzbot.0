Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E874A37A3CC
	for <syzbot@lists.linux.dev>; Wed, 29 Oct 2025 16:43:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761756189; cv=none; b=qI8TAKkEWpJ+DkO1NFmg0+zkl+PcnKw85bEhYB3jRsMDlQhf5vLeFNTOuopsQTpVEVu2MlF0Bv+92KRtYV7MJWoKn6Y1nxhibc8ghYRtcmoLCeLLPF4f3kJoaRdwPC5YkEOgW/K08o4WGVIxEk46yWVMc0jb7+t3X3CmJC/pfsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761756189; c=relaxed/simple;
	bh=dz4UHPy1Vxy5VvJOIeJ51vLlzplc1f2ed6NvorK4/xo=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=tVYj45NvcZXgwX65XkLP3fwkhwx7idP5UbjSZrXgnLQWNzGa8hsU0yqLqgFzjcxr4lZ4OanQyeKXSNeT0qWtUM1kiDHeZgSwJLZxNIjCiNjvkAFGFeQWG9D4GLWnIWJ5wpyTDWn+pH3+k+cYEDkG8f4Ssfp1TUaZuEoNqFpdRlo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-431d84fdb91so215928915ab.3
        for <syzbot@lists.linux.dev>; Wed, 29 Oct 2025 09:43:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761756187; x=1762360987;
        h=content-transfer-encoding:cc:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=woE0XQKxe4eeNubirOfdPpNmIiETt2fkjQU6OvBxbCU=;
        b=W59mNDxm8FiwZMfUd04n8DYMO56pZIloic3B0F1MoCA2VdXb47EAxe9x3PbqQ7F2Be
         JVMJrHL7eXcm73eCaNacJBUT6MqpJLWHxt2Ns4E54xQfp+q0FD0h23VdL+T/ukVkl2st
         imXjp58UjDilzrtDRKL8p7ob8sx/7/hboW2OjsjgOZntj3yGD2DaN6kcf53sAX8JdIgp
         1UihEQDQgzgz2lX5Rq6jznTLplTI45evlYZ/4s/KT5V5+HhFrtHoNuFpsF1sutv+6Zrz
         VJXverSKlJnBcKBsgflhSftuw5HW1F+7Xi2WV4GDtZ06VWkyONVMgJkbp5oDfX3Y9fgR
         1wXw==
X-Gm-Message-State: AOJu0YwxFe0ptX66zVx+2COXxQDpMo410fYWlRkVKpXmuH5K7zzGOtt3
	E7fpuElMpLEL2fvO4vYRF9MVbUKOPE+Tvm2T2FdowsI6Cl3SoUjZwGz4Myhzqfhcr+xhmqs5opE
	/GW/GMvlhzfidjYT8AZoDc+ZxSE/eqq12lXgxCDD/+3rE+lw6ZS+MPvcBF9I=
X-Google-Smtp-Source: AGHT+IEGKB7Ft+/JHKzGsrj8hrje3p98ZQhXVlF6GMUgqp4Oo5VN8H+0MLSKdaAhTvERNKqepvI+x4OwpSrt0KURE9VObXhCo4xC
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a92:ca0b:0:b0:430:ab98:7b1f with SMTP id
 e9e14a558f8ab-432f902b528mr48928175ab.18.1761756186996; Wed, 29 Oct 2025
 09:43:06 -0700 (PDT)
Date: Wed, 29 Oct 2025 09:43:06 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6902441a.050a0220.3344a1.042a.GAE@google.com>
Subject: [moderation/CI] Re: mm, swap: never bypass swap cache and cleanup
 flags (swap table phase II)
From: syzbot ci <syzbot+ci7353ed648947c91d@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v1] mm, swap: never bypass swap cache and cleanup flags (swap table phase =
II)
https://lore.kernel.org/all/20251029-swap-table-p2-v1-0-3d43f3b6ec32@tencen=
t.com
* [PATCH 01/19] mm/swap: rename __read_swap_cache_async to swap_cache_alloc=
_folio
* [PATCH 02/19] mm, swap: split swap cache preparation loop into a standalo=
ne helper
* [PATCH 03/19] mm, swap: never bypass the swap cache even for SWP_SYNCHRON=
OUS_IO
* [PATCH 04/19] mm, swap: always try to free swap cache for SWP_SYNCHRONOUS=
_IO devices
* [PATCH 05/19] mm, swap: simplify the code and reduce indention
* [PATCH 06/19] mm, swap: free the swap cache after folio is mapped
* [PATCH 07/19] mm/shmem: never bypass the swap cache for SWP_SYNCHRONOUS_I=
O
* [PATCH 08/19] mm/shmem, swap: remove SWAP_MAP_SHMEM
* [PATCH 09/19] mm, swap: swap entry of a bad slot should not be considered=
 as swapped out
* [PATCH 10/19] mm, swap: consolidate cluster reclaim and check logic
* [PATCH 11/19] mm, swap: split locked entry duplicating into a standalone =
helper
* [PATCH 12/19] mm, swap: use swap cache as the swap in synchronize layer
* [PATCH 13/19] mm, swap: remove workaround for unsynchronized swap map cac=
he state
* [PATCH 14/19] mm, swap: sanitize swap entry management workflow
* [PATCH 15/19] mm, swap: add folio to swap cache directly on allocation
* [PATCH 16/19] mm, swap: check swap table directly for checking cache
* [PATCH 17/19] mm, swap: clean up and improve swap entries freeing
* [PATCH 18/19] mm, swap: drop the SWAP_HAS_CACHE flag
* [PATCH 19/19] mm, swap: remove no longer needed _swap_info_get

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/01d6b19c-9614-4f8f-949e-c5adf3eab00f

***

kernel build error

tree:      mm-new
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/mm=
.git
base:      f30d294530d939fa4b77d61bc60f25c4284841fa
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp=
1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/345b9221-49ac-41ee-9a72-57ed683ef06=
7/config

mm/swapfile.c:1368:2: error: void function 'swap_alloc_slow' should not ret=
urn a value [-Wreturn-mismatch]

***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[akpm@linux-foundation.org baohua@kernel.org baolin.wang@linux.alibaba.com =
bhe@redhat.com chrisl@kernel.org david@redhat.com hannes@cmpxchg.org hughd@=
google.com kasong@tencent.com linux-kernel@vger.kernel.org linux-mm@kvack.o=
rg lorenzo.stoakes@oracle.com nphamcs@gmail.com ryncsn@gmail.com shikemeng@=
huaweicloud.com willy@infradead.org ying.huang@linux.alibaba.com yosry.ahme=
d@linux.dev youngjun.park@lge.com]

If the report looks fine to you, reply with:
#syz upstream

