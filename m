Received: from mail-oi2-f42.google.com (mail-oi2-f42.google.com [74.125.231.234])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B27239C637
	for <syzbot@lists.linux.dev>; Sat, 26 Sep 2026 20:52:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.231.234
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790455922; cv=pass; b=ACi5VzeUyJ4GHGx0EqesU5vli5UwA2Udn+wResj75pRYUthSu97q+L2gTULo7118lpKUUcnxQ/YbbT+PPw56KDaAjkRF7geIAkAgvTcMz9+qWkwPLhOdzg0Lo/qQ8ZcI9X0cQHxEtuDt4YmWd7Q5PU85wETGPNqEDxPMrLIkqaI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790455922; c=relaxed/simple;
	bh=Ga0iJRKZgcq7skODBm6ubAhRvMfoIzcGpzBcTjewOzc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cpe2ttL9whfrU7wI7SzHK4MixSQZpLMtpjEv6E7cCrdbow7A2FPV278iLH8k+khmkiJxA3rmmBwEtM3y0W6MV1P9PUXInCFf5SdsGCTKVhY2/pnI5M4IueA4gD9ETu6H2uzqJViihKpXZ8LjHc5eYy1To3sqS2k0ZP18SuAI2EM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=gLmYofAX; arc=pass smtp.client-ip=74.125.231.234
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gLmYofAX"
Received: by mail-oi2-f42.google.com with SMTP id 5614622812f47-4e7d0e42662so123859b6e.3
        for <syzbot@lists.linux.dev>; Sat, 26 Sep 2026 13:52:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790455920; cv=none;
        d=google.com; s=arc-20260327;
        b=U78ayvzq+PEVjUw+6Cfdj0wIaY5aQ6PEmBYdgi2aFLfaZcvaFBYrJz/XIVZLUaur62
         bA7OfrbqcuF6NJ3J7zILxmrliZX28w4xv6ZDtfNb01JvzSlXjpV547zSTg6gBkONDJsF
         FeOll5s7AGdaNtgVqLP04yPOdfPo0ElmDHrYz6zb2snu67qxhxhDpc4q0bV6DCcMUTUy
         BpF5kfKkjsXASlrATonMoQsmLN7fvLmKcQg2uMVuXH9A/Kaz3qfAGV7ZiBatB2SrKip5
         X6ci/jxCVDxvf6gwqtLsvL4LQiqbM9n7AaSzCeZ+FihoC5IhVBEWyNs/g9ZkHugByUfB
         zI8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=uitB0NQJA7fUAGSRYxETzrGO7DAw7IDH/WryHwcEBO8=;
        fh=Svj9wo//i4i4E5LQv7EXc4no65gRSAHxXzX+TIlXZfo=;
        b=p0YQc0rckqL5mybwvwkRf7Gf4iq12wjS+3kQVHQYeIjp9DLhKi8Mb2QbUU7dTLgfAZ
         6pm+9Mscf5yb0NAO9ZLHvzqMu1Ow74ZKSkD2wkZKhsm0cVRdUtOOd3RFl4vC3b5mENaK
         x1R3sy9q7i68vMSTAGgy1sHNwzIfP5JKAZq2ZryRvVcfDpw+mXi7wxXZP/J8gGT+2Btl
         GZjJOIk6t9nd8HOe5xlekJq2y6FbPDsEOQ894sqNkWgRZuZlDrIMM+APz6xeHcpBdBjG
         S3IALPxbuS94B4rueo6DHEKJ1KV7ITjkSXO1CR1zvAIdKxMOB7Y4GVGvjQtawkJzTnz3
         7AKQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790455920; x=1791060720; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=uitB0NQJA7fUAGSRYxETzrGO7DAw7IDH/WryHwcEBO8=;
        b=gLmYofAXt/bi50eo4EfnF+5DxCvaO+7tze8djO/M7Urzdo/0VjZAYkPJiCJGkxTSzM
         dGUmSiHpuxAtgjeHTHMf/Lr1ItoL4XwZQbczujJS2yqN0rrPwDlUFfL1wH/bExsFhuKv
         meESxoMruJQyE1eRDZ7UU916v+WMBEgVEdWbo8xzZn7HrkyGYnGCoLgUmy0SCglSRmL6
         n2Yc42F0PBAETObp86CV7LfrZBVKzrvoNHD35hNUH/cVVNqXhoHLhcdSjARgXR32hhG1
         oAt3YJ3H8ctaWxIbl1XzMay0fYBIOQ1R342/Fy4Z72MdXyJCA2GWJFv9AxSOXUr+A5Ni
         7p5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790455920; x=1791060720;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=uitB0NQJA7fUAGSRYxETzrGO7DAw7IDH/WryHwcEBO8=;
        b=cgeO+YD9JJuSfqt9YfHOBJHW5+kFiIP+7KHcOJG+IwR8dX++wUfuPQcyvdK0wFtr4u
         +Omhr6i2JBodnsksqWs906ewrvZqWiBoEZFN2489YyU7S8cAfqkKp0zdxk9CrjxJFVhz
         P1lxmUnq9D3ZoGTUq5xImXJFUX+TsKKcEwjhS0/hfcW2Ru5QQIF/SvEeSnLhCYaEJSSE
         rPojXuZ8w7D2Ama5Z+Q7LvzySDA4qRXCvAsgDSzzsYNzb4pCWS6eRbrWadJTYTSVm86s
         cANiaguYBX3ZVX58RgH3jAI86mK2hLj14f6NU7/z8AUmhxrROrzaoyCr7z6S3q2pjeA1
         cTiw==
X-Forwarded-Encrypted: i=1; AKwUvBxonA/MQNPKapBGZbkfrhyAW2/L34+C+oMFrGDkVwQ5y8G4Hg6elhlpmXBVQHDRjxTFpuJMpvc=@lists.linux.dev
X-Gm-Message-State: AFuF++n+tJ32YR60MZSqdvaYCvPENDMstELDlBdp7/PXgSMTBNQOqfDw
	W1NvRYYpBNmL6MBBex4IBo15zHYKe7n9smXJ8NZ73vsUt1n0y+bRKtMFXrYhnlyLy/5cviuRW7r
	kG/rAVZyLzUF6lNWh3gm2PFjJadBvVNxsoILFfoO/
X-Gm-Gg: AYBFou2E0Sg7Zdg60/0FjMiUxCGCt2kjYn6AqGfxbdahXLr545SuurNqoqRoZCw3msY
	Cji4u8nBCXPYRHs2n3nI+ZK3ImKAMIfH4IeBkNqjthir0R7o2WttLK8CHVZVTAT+KjTG2XlXYes
	PYoftASet387t8D7HY30lWI2aslGzEJks/o8+e/ySKdgqkSz/Uvy1hKkfDMKNshULmFCrNBAM7k
	tInDe3d8FMq2LMMJvzUl2ymErMpR5ni2qAMqFT3TiuUtEQHbphYJ2mVn1NB4kbI7MeLFZ2ilJaR
	X6qC5tVW9j0hyn8ctlK1dg1xIy27TXWem7MXdRMQarppoCpybDL4/gMnv/2VO1a9rtS2XLIbM9K
	fK3Bwe0/Jxe6O9z/fNguR5S5bdaDKbFsBDyYB884ABXxzWD35NragFQcFDNvHwJd9aJC3pZI=
X-Received: by 2002:a05:6808:10d6:b0:4d6:9232:b3c0 with SMTP id
 5614622812f47-4d72cd363ccmr11061905b6e.55.1790455919404; Sat, 26 Sep 2026
 13:51:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <6ab7de1a.e548f532.1ca396.002e.GAE@google.com>
In-Reply-To: <6ab7de1a.e548f532.1ca396.002e.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Sat, 26 Sep 2026 16:51:46 -0400
X-Gm-Features: AclHuK9xYNYyqqMVD64Y8yZbTih9JBdRrG8oAGS4r0LbGWKI9tUhrmD1GJjeebk
Message-ID: <CANp29Y7MDQCsV9=PApBaiHkvppQ7dDWF0qX6Ph6XqOb_M2a_Tg@mail.gmail.com>
Subject: Re: [moderation/CI] Re: migrate on fault for device pages
To: syzbot ci <syzbot+ci8e1d2d3902f1476b@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz invalid

On Sat, Sep 26, 2026 at 11:00=E2=80=AFAM syzbot ci
<syzbot+ci8e1d2d3902f1476b@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v15] migrate on fault for device pages
> https://lore.kernel.org/all/20260924065313.899730-1-mpenttil@redhat.com
> * [PATCH v15 01/11] mm/Kconfig: changes for migrate on fault for device p=
ages
> * [PATCH v15 02/11] mm: add helper to convert HMM pfn to migrate pfn
> * [PATCH v15 03/11] mm/hmm: preparations for HMM to participate in migrat=
ion
> * [PATCH v15 04/11] mm/hmm: do the plumbing for HMM to participate in mig=
ration
> * [PATCH v15 05/11] mm/hmm: migrate collection in HMM pagewalk - pte leve=
l
> * [PATCH v15 06/11] mm/hmm: migrate collection in HMM pagewalk - pmd leve=
l
> * [PATCH v15 07/11] mm/hmm: add lazy MMU mode support for migration in HM=
M pagewalk
> * [PATCH v15 08/11] mm/hmm: implement rollback for device page migration =
in HMM pagewalk
> * [PATCH v15 09/11] mm: enable device page migration from HMM pagewalk
> * [PATCH v15 10/11] lib/test_hmm: add a new testcase for the migrate on f=
ault
> * [PATCH v15 11/11] Documentation/mm/hmm: document migration through hmm_=
range_fault()
>
> and found the following issue:
> kernel panic: Fatal exception
>
> Full report is available here:
> https://ci.syzbot.org/series/e83269ed-df96-404f-95bb-3815267ab7b6
>
> ***
>
> kernel panic: Fatal exception
>
> tree:      drm-next
> URL:       https://gitlab.freedesktop.org/drm/kernel.git
> base:      2abe8e7e33973dda5dd24b89aa3ee52470a78265
> arch:      amd64
> compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~e=
xp1~20260613092250.77), Debian LLD 22.1.8
> config:    https://ci.syzbot.org/builds/8d10dc50-efeb-4533-8f7a-d7fcf6b5a=
3b3/config
> AI triage: https://ci.syzbot.org/findings/cf11d87e-9315-4738-a194-f8ccc16=
c2736/triage_trajectory
>
> FS:  0000555594951500(0000) GS:ffff88818d6c2000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f384eb3aff8 CR3: 0000000171b40000 CR4: 00000000000006f0
> Kernel panic - not syncing: Fatal exception
> Kernel Offset: disabled
> Rebooting in 86400 seconds..
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
> [akpm@linux-foundation.org apopple@nvidia.com balbirs@nvidia.com david@ke=
rnel.org dri-devel@lists.freedesktop.org intel-xe@lists.freedesktop.org jgg=
@nvidia.com leonro@nvidia.com liam.howlett@oracle.com linux-kernel@vger.ker=
nel.org linux-mm@kvack.org ljs@kernel.org marpagan@redhat.com matthew.brost=
@intel.com mhocko@suse.com mpenttil@redhat.com rppt@kernel.org surenb@googl=
e.com vbabka@suse.cz ziy@nvidia.com]
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
-upstream-moderation/6ab7de1a.e548f532.1ca396.002e.GAE%40google.com.
