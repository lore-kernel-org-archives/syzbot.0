Received: from mail-io1-f72.google.com (mail-io1-f72.google.com [209.85.166.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 117F943AA6
	for <syzbot@lists.linux.dev>; Sun, 19 Oct 2025 07:02:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760857361; cv=none; b=gZ3pBBXtCB7K6YA9SL/GTnhxwrrtPUtUwqBuKOzeHnASg2Ry19HVcJwyRNKcJE4o4eEEXsPNE4d2fzG5fwuY0HjlBmuOzyuDEY4mpNth/E6kxA+yrZ7JGiMbxYADWBx8TmHUroRv/rsLccue8InDrzUW8U/FgI42ZFDuDSv+8UM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760857361; c=relaxed/simple;
	bh=pIUgxD7HvVeQMBjJbMVKiBaZrXheBRu9SHQQC7tkxmA=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=deErAmPchq0pKoAjdKe70nWV8rgMrmpDtEj7lTjM5X+6OerD5uXnPSuBK02VqTPgVloMydt03RwlRgpPftvlfBKnvHVFt/RisT/Mt4VoXgF0TJOIz6GDsRrycG7dCHJfkrovqCqVYhUgjh574Olik+4wr/ozGhztCRCXIaMF6BA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-93e8092427aso180183039f.0
        for <syzbot@lists.linux.dev>; Sun, 19 Oct 2025 00:02:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760857356; x=1761462156;
        h=content-transfer-encoding:cc:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EGqAUkLtb3SHkZqjuqk5Fz+7Mv7j+E1kl2EiWH8KlbU=;
        b=JyHL5nPfMSGIQxUxUNmSv23tn97YKXKvtRlELZO8MIdbmXXR+r9cC3fBOELLimcDRf
         vnBH94cyJ+c9JMGYcq/3Oan4dSLGUZUjuWaCqY6lDGSJ3lwJ6t1ZMlCzmenk1X7YXEkS
         1xMtNd0CHKmkGoeHmNNwVEe7KUtx5/wTFoNl5Y/NeENti2JEJPdA9JpR7/et34yZxNmE
         XNTnW4pdiCU/FNF7zfzTgiE/ceOpXmVjdaVzygEc98VuLILqW4kBo3MRNwWfzqjbbRv8
         dFaHw2paJkTXp60o7gAtBZImL6gw34kJwtGNbm7k85SVPixoSW0c+5RDIuDZkwr3SSh4
         I3RA==
X-Gm-Message-State: AOJu0YzFu3Cq2lJuTLDMbaalwV13NSQNX20CatbpcV6lKaIZDIEWYnLW
	IKSnsPD3lNXt5s6OEd9ad1+w2CxN6EsVMrCqOLXwsBO5nZp26KunE9cw5iSr55IF9Z+BBCUeyzI
	xHdSoH5aovD3XxBPn1a4aGqc2JRXatYS1jToVx2if+W2sTWMk8+b/9mJ9aak=
X-Google-Smtp-Source: AGHT+IGh00mHThuxWJ7h/D3NJWpXh7oaI7bQHdFqA6bCNBR7YD8qfsK9rg/w+q7+lpcU5lxVP69QbvasFUhHIUN/Zlrxmjxmrb3q
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a92:c265:0:b0:430:aca2:53d5 with SMTP id
 e9e14a558f8ab-430c51eae06mr133802135ab.1.1760857356066; Sun, 19 Oct 2025
 00:02:36 -0700 (PDT)
Date: Sun, 19 Oct 2025 00:02:36 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68f48d0c.050a0220.91a22.0436.GAE@google.com>
Subject: [moderation/CI] Re: kernel: Introduce multikernel architecture support
From: syzbot ci <syzbot+ci6ff3a1195ed07954@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v2] kernel: Introduce multikernel architecture support
https://lore.kernel.org/all/20251019061631.2235405-1-xiyou.wangcong@gmail.c=
om
* [RFC Patch v2 01/16] kexec: Introduce multikernel support via kexec
* [RFC Patch v2 02/16] x86: Introduce SMP INIT trampoline for multikernel C=
PU bootstrap
* [RFC Patch v2 03/16] multikernel: Introduce basic multikernel subsystem i=
nfrastructure
* [RFC Patch v2 04/16] x86: Introduce MULTIKERNEL_VECTOR for inter-kernel c=
ommunication
* [RFC Patch v2 05/16] x86: Introduce arch_cpu_physical_id() to obtain phys=
ical CPU ID
* [RFC Patch v2 06/16] multikernel: Introduce physical memory reservation a=
nd allocation
* [RFC Patch v2 07/16] kexec: Implement dynamic kimage tracking
* [RFC Patch v2 08/16] multikernel: Introduce device-tree based kernfs inte=
rface
* [RFC Patch v2 09/16] kexec: Integrate multikernel instance management wit=
h kexec subsystem
* [RFC Patch v2 10/16] Documentation: Add multikernel usage
* [RFC Patch v2 11/16] kexec: Add /proc/kimage interface for kimage trackin=
g
* [RFC Patch v2 12/16] multikernel: Introduce per-instance memory allocatio=
n interface
* [RFC Patch v2 13/16] kernel: Introduce generic multikernel IPI communicat=
ion framework
* [RFC Patch v2 14/16] multikernel: Add messaging layer for inter-kernel co=
mmunication
* [RFC Patch v2 15/16] kexec: Integrate multikernel support with kexec_file=
_load()
* [RFC Patch v2 16/16] multikernel: Integrate Kexec HandOver framework for =
DTB preservation

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/5e5f2222-c421-445c-80a8-329e052eb00d

***

kernel build error

tree:      torvalds
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvald=
s/linux
base:      3a8660878839faadb4f1a6dd72c3179c1df56787
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp=
1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/b83eab88-f300-46c6-99d0-d9ce6edaf4e=
b/config

ld.lld: error: undefined symbol: mk_kimage_alloc
ld.lld: error: undefined symbol: mk_kimage_free
ld.lld: error: undefined symbol: mk_instance_set_state
ld.lld: error: undefined symbol: mk_instance_put
ld.lld: error: undefined symbol: mk_instance_find

***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[akpm@linux-foundation.org bhe@redhat.com changyuanl@google.com cwang@multi=
ernel.io cwang@multikernel.io graf@amazon.com jiri@resnulli.us kexec@lists.=
infradead.org linux-kernel@vger.kernel.org linux-mm@kvack.org multikernel@l=
ists.linux.dev pasha.tatashin@soleen.com rppt@kernel.org stefanha@redhat.co=
m xiyou.wangcong@gmail.com]

If the report looks fine to you, reply with:
#syz upstream

