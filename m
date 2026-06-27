Received: from mail-oa1-f72.google.com (mail-oa1-f72.google.com [209.85.160.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C5E034DCF3
	for <syzbot@lists.linux.dev>; Sat, 27 Jun 2026 08:38:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782549538; cv=none; b=Jku1wmjoibIj8/+nUmJVdjdeBbmakG6JnVaPvfQNWmT2Wy+fPb+TLEwsDVfFtuliZvWEwzkNJ4O0GQd0bt9GrMzt+GVcwpBWFt10OG9yzmcauS5vOc/A8ocD9z60ArcMSKsyRRwF+le5XF6K3iFw8swuoFLaqEQBMcK7ikL8yao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782549538; c=relaxed/simple;
	bh=BwL38CRmuN17UwgKwrM1mz2s15ghg5y29gN6uXFzIzE=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=AiM2TIVKiCtcAGB4UgyPqFkYb2lMr/2OFws8wSV0cL4YhzKErUnvrK+i+fPmclbiVkoyV4Bl813Xd7gujLExbpb02vc1OOZ8EdbqI1jyaooknd4QfKPweipDW87bflRkYXjUwhTLBsdQrkpBSkP8VvXrQlIZ/nYPKcHT4lF9hoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.160.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oa1-f72.google.com with SMTP id 586e51a60fabf-44801afec53so2085552fac.2
        for <syzbot@lists.linux.dev>; Sat, 27 Jun 2026 01:38:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782549536; x=1783154336;
        h=content-transfer-encoding:cc:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=91pkKN/nbe2SFFFCQjW4Nz5krBxJ8dOLp8pUyWyBLP0=;
        b=n8CtrXGkbuZ7XwQ3rBVoKs2BtS77t+SB68EIyMEjIbeCGi/kQj4JR4F8RF/7ifGcgn
         4oYtSdCeQ+ONWJZNGedebBqak5FupLoMcuzHawMBnVPhJSjHQN/w2Tt3iwwxxh78lFuS
         tk+iTECJHIyEG7MMplfBbgG9I2kF61nJ9u33r9oEHTVAQCR9rhEU0FKdVvvapR3uDTSv
         V3hrUioL4XVKFferFjxihHcpUfX49z2G7gyVxirIlfOfgJ4g060gIsGO1CQNTV2K80pT
         PqiK1I5CuRT+WMA1Fmqby2rlx9Taenvs5KuLzvKUtXWgUx+kiYDPt86WF0Tk8pkh+auK
         d62Q==
X-Gm-Message-State: AOJu0YxAuTc9ta2QwLN5iyGq+jk9fRQh6nv6aYvSfofIkf8qBJfS7yJW
	G1qdq+pWwe03MhDPs5Op0OJ3zKxpKV7P/nYRL9bLl/XimUfJgPEEnGvbo3HQdKsviQkMB3IEqb4
	6oUTd8FBddBMXgLCRXcRW9yP8dj6yPnyUkH8uVedlu4tD3o663Tj+yKU9qps=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:2444:b0:48a:856b:6690 with SMTP id
 5614622812f47-492123724dbmr7672279b6e.0.1782549536105; Sat, 27 Jun 2026
 01:38:56 -0700 (PDT)
Date: Sat, 27 Jun 2026 01:38:56 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a3f8c20.6124255a.8960b.0009.GAE@google.com>
Subject: [moderation/CI] Re: Introducte Reserved THP
From: syzbot ci <syzbot+ci4b514fc68c02333b@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v1] Introducte Reserved THP
https://lore.kernel.org/all/cover.1782538002.git.zhengqi.arch@bytedance.com
* [RFC PATCH 1/8] mm: page_alloc: add reserved THP pageblock type
* [RFC PATCH 2/8] mm: add boot-time reserved THP pageblock capacity
* [RFC PATCH 3/8] mm: page_alloc: add a reserved THP allocation primitive
* [RFC PATCH 4/8] mm: add reserved THP quota helpers
* [RFC PATCH 5/8] mm: add reserved THP vma flag
* [RFC PATCH 6/8] mm: maintain reserved THP quota across VMA changes
* [RFC PATCH 7/8] mm: support reserved THP VMAs in anonymous faults
* [RFC PATCH 8/8] mm: add MADV_RESERVED_THP range policy

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/48c38717-31b4-40a6-88aa-1b581e1fd93b

***

kernel build error

tree:      linux-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/next/li=
nux-next
base:      3d5670d672ae08b8c534b7beed6f57c8b44e7b43
arch:      amd64
compiler:  Debian clang version 22.1.6 (++20260514074242+fc4aad7b5db3-1~exp=
1~20260514074407.73), Debian LLD 22.1.6
config:    https://ci.syzbot.org/builds/d4df29e3-76c2-4d82-b0b4-097beb267ff=
b/config

ld.lld: error: undefined symbol: reserved_thp_uncharge

***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

To test a patch for this bug, please reply with `#syz test`
(should be on a separate line).

The patch should be attached to the email.
Note: arguments like custom git repos and branches are not supported.

The email will later be sent to:
[akpm@linux-foundation.org baohua@kernel.org baolin.wang@linux.alibaba.com =
baoquan.he@linux.dev chrisl@kernel.org david@kernel.org dev.jain@arm.com ha=
nnes@cmpxchg.org jackmanb@google.com kasong@tencent.com lance.yang@linux.de=
v liam@infradead.org linux-kernel@vger.kernel.org linux-mm@kvack.org ljs@ke=
rnel.org mhocko@suse.com muchun.song@linux.dev npache@redhat.com nphamcs@gm=
ail.com osalvador@suse.de peterx@redhat.com qi.zheng@linux.dev ryan.roberts=
@arm.com shikemeng@huaweicloud.com surenb@google.com usama.arif@linux.dev v=
babka@kernel.org willy@infradead.org youngjun.park@lge.com zhengqi.arch@byt=
edance.com ziy@nvidia.com]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

