Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.167.181
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795547594;
	b=oYCOuPmGpt0nzZsEoqpOkWPNW/Nwe9QnXacjqNhFjFsAAufhiEGLdKXIMlJI/AKNtaxO
	 ZaFMB6CDhFmvEUVTlvfAoR721jtWoS5ZL50vfWR36lOeOdep3r8wJONekyfwAwxf8BNAi
	 NfWEQQQj2VxHyopJLK4oU3XikREaDDT3TFvuHATVWgt1tBH+4zjgSq+jjSqzxL6bOwxOP
	 ojsvM39Dxk/HNySZSrIqPysyMVGWwW017CD3cN1EQk6dtGo9qGiZvJl4nEbf1vbclLHSO
	 XFBF6OGJuFq/LVdaGViYAOZkTtLALXZuPY47xmBO5ByFOEPa+26qZAzr+T62nqRkPSg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795547594;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=9QYfd8rwlqTx/Ld8bGnPIzshUEUTRQCnvjaLWkWLxhg=;
	b=fhM7tV/eH7+Kd2b+h+DaJP7ZaeLMu7XQgyIYD6gFwcR14pzH7fRZh/WHq/QNcTzRsFJG
	 loxVEcF3iKAooqKoh2km4uL4qH2AI04EGXAUftQIpfMI48RjkD3LY0DR62X/VkYyBvlsh
	 FPcQyKUCy/nHMNaXAp5psi6REpP10OF6tpoWUUuNIRF7FfS4lHMUnF208PuntY+N8OMhZ
	 VRMTn5m7UuhLKoARXvehnU3DQtlNqod9bdO/EowT4LCKZk9Am1/rVwOv00ng4qj42GNge
	 VOGodlhKSoNs82JutIJfsdoKLbOYVKO7iEHmijTXpjeHgMUC+zdG4MYpzi/FqgGNrvg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=Y2+rf4f4;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.167.181
Received: from mail-oi1-f181.google.com (mail-oi1-f181.google.com [209.85.167.181])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5A92606A321
	for <syzbot@lists.linux.dev>; Tue, 24 Nov 2026 19:13:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A5A92606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=Y2+rf4f4
Received: by mail-oi1-f181.google.com with SMTP id 5614622812f47-53c156ba662so2730999b6e.1
        for <syzbot@lists.linux.dev>; Tue, 24 Nov 2026 11:13:13 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795547592; cv=none;
        d=google.com; s=arc-20260327;
        b=n/TEjAA73oxKWOUfvvSrlMQmG95uNVz1xk0VwMMnX47wZ5wplnM4DyPKoVRwzly0rg
         XRXE700EwPbGysodJQTKntVKJ3xTRZzh8+SzFE+plBSLjQeU0A6dHmjI0yRgkt2zmrj7
         0Ph1fhwF5+z0dhVy4xu4gSSnn2cPDkS9pFQ1CXHFtCdc8XKTjZSkj1WsfnjtnlnUTshf
         t7Es9J0L7swOa8O4ZqgDlBEO7LrkK0OPHq6d0S0jFy+t315t3GO+BWFaYk8HCQxy7VwF
         AUGxsp4bDLtNE0n4DYXup2zfez5PX0WfYcUnAkOu9pgS9AMhZL8V4JxdbqjD4W/fmmGj
         px8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=9QYfd8rwlqTx/Ld8bGnPIzshUEUTRQCnvjaLWkWLxhg=;
        fh=TU/wgMzsPA28eI2ZlvAzRedUMONM+tkwlRCGvyi9fn4=;
        b=IzVQke/a5FT3arNsfGdNfuTne+mOffNFbGnzvEnMSC+Kge42/maXWEKO8GkPyS6LHg
         3BOF8af2fyBkXP4RWwfXRhheyz7GO9awzUsjYmJ/QHIvd7UafEad1z/ZThZ+nklY5e+w
         U3QkTZI0HdcVK1U6bO+wWfL6v//Qgz2uvY5gPcmjTaWOyN9tcd2ZxIdDOaIA17AQiN8w
         rmSINF3ZmaUZLSH+pqFsVIHS462H1K47HRfhwuqwZJBCWoXJr+nl0yQCZgEiBBxV+jXK
         weHAPeg6tIAFbHAFXETT8R1j/rVomcgbHtdz9IycCw0+GUkd8md7AoOQyY9PrK8Zu8+q
         Oe7A==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795547592; x=1796152392; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=9QYfd8rwlqTx/Ld8bGnPIzshUEUTRQCnvjaLWkWLxhg=;
        b=Y2+rf4f4VyjaTUxFb5Nhdyqv9OZsiBwPj7clgcultXWRGt7gvTw90mUwgbCklLDrPC
         D6rAM4CIfHzz1GdkEslN2r3Znp9yxiWqNnz4N+jc0/+sCaoMXRZ+w1tQVYP1j9RA3U3O
         YCh9XBoq1lRhEZAejE8+1XEiNI/jHnt/mQhSxzHvIJfgCivC1M88HPNxpGyHVRv/ErtJ
         TWaBFAdIoF7LndC6vjlaZOAhsXTs51OhjA4+wT9rmJlaSAyc1fmIbVe0fGkefFPmwDDH
         ebugRUuCtje8Sa6ojz0N6eCnfCSNabsuxSYWVKMJ24fW552RubBAB2Ditnp7b36uy/Um
         ZuDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795547592; x=1796152392;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9QYfd8rwlqTx/Ld8bGnPIzshUEUTRQCnvjaLWkWLxhg=;
        b=ZfVaKDPIxfTS6nBWqvhGlsx/TXNl9HzGeWjd6bKBWHViBO9jOM6jaF/jfVMN1ApCqr
         0oQIMGGhkta/eIUaAp9dSjU6C1J5AL9v/ecjbFLwWjh82+c5eZiTihaesR4w96hm+dPV
         Bytg6ufleDaSutTa0rn2+pjDvjQcV4ckjFIJpbrbG2r419ESNcZ+IDMLU2p29O5aPitF
         ZYwknUeS3wHLGkPYeQTYQ79klZINqzmCC9vYUlNyuvFmR8dDPJMzC2C/W0EwTVOBiRUa
         Zt2TQ6ejIrIhVsGiPPtcq35DODECEiq67QTXPJyLyqUmwYXW/WEq2LHjPVrZ/ffbJK/V
         Bouw==
X-Forwarded-Encrypted: i=1; AL+hErF8ifnbdxe4J+k6aiaIahJbdlrOHPr27j8zoYuVVsF/zeI2bfbgePSQgsmkJ/2hjQpK2+HWwtw=@lists.linux.dev
X-Gm-Message-State: APuU4Z/a68MJ0UufRdZKlFJcCvZ85nnwD7fMoOhkE5aP7KBXIbZDJCNf
	clLt18d7uC30sZBX0h7Qs0IxkbCadNEsQitSeSEhy+p003lZOAydhyGU0U9eUVmFTclXi5OfqRw
	Of9wVq176/8bxKHWxjFuRzs3x/Egdta2Q+SS9Czs/
X-Gm-Gg: AZFdTZdepYQ/Gi451fCaX9CuJdnFy1fiNrxzplkmrGRWsdKLf86gW7nre/um+EKXDC+
	GVyc/HtbW7WjVcf9snWEZ3iZJflWeBPXJ/SL9sugETr2fe7CuWw026l1Bma+QFygNnVG/Dm/A0b
	xSglUhd0q6SCvW6h005MNUDmrOCJQB6io8tC9DhOdJoJw2LIc0CeOF2zdu9+eMNikywkjThgM5g
	cmRJx8sQ6MINJIAQl/1lF5pU3Ikdl0QKL/tKN1vVC5OTEW4LPGpid2l+q0JP4A1gRmNhQhJxxgp
	LB9CLASLIXKOapXy+2LINsTDC0d654l/kvu5Cj1vceBfRJ9y0VM1wXSlNtiHKC97gVSutvmvSsr
	jT9SkEW0ySTOEM7+jiO8dEpgVq4xNlgD8ihD0MROfR5nseWHVc3fFd3HdtebVLhbgYUKxfdeKY7
	U4XRUIU0G1NuuGM+YtElI8ioux7sMWO8y21d5Zou0bTVZ3Zk3X5eNy/lgYJS96yLRK+4NdYf5A+
	/v9SQUTMg==
X-Received: by 2002:a05:6808:14ca:b0:574:54c:4e08 with SMTP id
 5614622812f47-57a0d0ee87cmr16174958b6e.64.1795547591821; Tue, 24 Nov 2026
 11:13:11 -0800 (PST)
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Post: <mailto:syzbot@lists.linux.dev>
List-Help: <mailto:syzbot+help@lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
List-Owner: <mailto:syzbot+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <6b05e07f.2b4a0a19.394f81.0000.GAE@google.com>
In-Reply-To: <6b05e07f.2b4a0a19.394f81.0000.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Tue, 24 Nov 2026 20:12:59 +0100
X-Gm-Features: Aa3M54orxdc_9vnWtAHry9ALKwOfDRI5VRloHk9RqmOAMl9W7piEAzPjTkGWR68
Message-ID: <CANp29Y6qj9k=eXmJLELS1mAfAAPJiM9pUTjQ_cQ100yRiSZ+cA@mail.gmail.com>
Subject: Re: [moderation/CI] Re: mm: GUP dirty + ->release_folio() fixes
To: syzbot ci <syzbot+cib37193b575c18a2c@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Tue, Nov 24, 2026 at 8:07=E2=80=AFPM syzbot ci
<syzbot+cib37193b575c18a2c@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v1] mm: GUP dirty + ->release_folio() fixes
> https://lore.kernel.org/all/20261119-gup-dirty-what-v1-0-236d69f25c24@sus=
e.de
> * [PATCH RFC 1/5] mm/khugepaged: fix filemap_release_folio() interaction =
with GUP dirty
> * [PATCH RFC 2/5] mm/huge_memory: fix filemap_release_folio() interaction=
 with GUP dirty
> * [PATCH RFC 3/5] mm/vmscan: avoid releasing FS metadata for !FOLL_PIN gu=
p folios
> * [PATCH RFC 4/5] mm/vmscan: be more careful when releasing FS metadata i=
f buffer_heads_over_limit
> * [PATCH RFC 5/5] mm/filemap: refuse releasing maybe_dma_pinned folios
>
> and found the following issue:
> WARNING in filemap_release_folio
>
> Full report is available here:
> https://ci.syzbot.org/series/852fc6fd-04c3-494d-a18d-4072753d5c47
>
> ***
>
> WARNING in filemap_release_folio
>
> tree:      linux-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/next/=
linux-next
> base:      bb7a206a3ffb0992b3600205b7cf2bcbd228d339
> arch:      amd64
> compiler:  Debian clang version 22.1.8 (1~deb13u4), Debian LLD 22.1.8
> config:    https://ci.syzbot.org/builds/789b8ec7-0fce-48b1-bd3f-130fad443=
c68/config
> syz repro: https://ci.syzbot.org/findings/b27d3479-eda0-470a-a735-8bde8b4=
89eea/syz_repro
>
>  __do_sys_exit_group kernel/exit.c:1134 [inline]
>  __se_sys_exit_group kernel/exit.c:1132 [inline]
>  __x64_sys_exit_group+0x3f/0x40 kernel/exit.c:1132
>  x64_sys_call+0x18c6/0x18d0 arch/x86/include/generated/asm/syscalls_64.h:=
232
>  do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
>  do_syscall_64+0x171/0x540 arch/x86/entry/syscall_64.c:89
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> ------------[ cut here ]------------
> 1
> WARNING: mm/filemap.c:4574 at filemap_release_folio+0x579/0x6a0 mm/filema=
p.c:4574, CPU#1: syz.0.32/5940
> Modules linked in:
> CPU: 1 UID: 0 PID: 5940 Comm: syz.0.32 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:filemap_release_folio+0x579/0x6a0 mm/filemap.c:4574
> Code: 89 df 48 83 c4 10 5b 41 5c 41 5d 41 5e 41 5f 5d e9 2c 88 58 00 e8 4=
7 76 b7 ff 48 89 df 48 c7 c6 a0 82 39 8c e8 e8 74 16 ff 90 <0f> 0b 90 e9 00=
 fc ff ff e8 2a 76 b7 ff 48 89 df e8 a2 26 00 00 41
> RSP: 0000:ffffc90003486d78 EFLAGS: 00010246
> RAX: d29da7cf2dd17300 RBX: ffffea0006c30400 RCX: 0000000000000046
> RDX: 0000000000000000 RSI: ffffffff8e935905 RDI: ffff8881720f1e00
> RBP: dffffc0000000000 R08: ffffffff9014c6eb R09: 1ffffffff20298dd
> R10: dffffc0000000000 R11: fffffbfff20298de R12: 0000000000000001
> R13: ffffea0006c30408 R14: 1ffffd4000d86080 R15: 1ffffd4000d86081
> FS:  00007f9243ca06c0(0000) GS:ffff8882a7801000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007fb8ff871a20 CR3: 000000016d7f6000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  collapse_file mm/khugepaged.c:2426 [inline]
>  collapse_pmd+0x389d/0x6bd0 mm/khugepaged.c:2869
>  collapse_single_pmd+0x1c74/0x36b0 mm/khugepaged.c:2921
>  madvise_collapse+0x3e7/0x920 mm/khugepaged.c:3313
>  madvise_vma_behavior+0xffe/0x4cb0 mm/madvise.c:1390
>  madvise_walk_vmas+0x57d/0xb70 mm/madvise.c:1742
>  madvise_do_behavior+0x385/0x540 mm/madvise.c:1937
>  do_madvise+0x327/0x3a0 mm/madvise.c:2035
>  __do_sys_madvise mm/madvise.c:2044 [inline]
>  __se_sys_madvise mm/madvise.c:2042 [inline]
>  __x64_sys_madvise+0xa6/0xc0 mm/madvise.c:2042
>  do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
>  do_syscall_64+0x171/0x540 arch/x86/entry/syscall_64.c:89
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f9242da8fd9
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007f9243ca0028 EFLAGS: 00000246 ORIG_RAX: 000000000000001c
> RAX: ffffffffffffffda RBX: 00007f9243026180 RCX: 00007f9242da8fd9
> RDX: 0000000000000019 RSI: 000000000060005f RDI: 0000200000000000
> RBP: 00007f9242e37fed R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f9243026218 R14: 00007f9243026180 R15: 00007fff1d17f228
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
> The email will later be sent to:
> [akpm@linux-foundation.org axelrasmussen@google.com baohua@kernel.org bao=
lin.wang@linux.alibaba.com baoquan.he@linux.dev david@kernel.org dev.jain@a=
rm.com hannes@cmpxchg.org jack@suse.cz jhubbard@nvidia.com kas@kernel.org k=
asong@tencent.com lance.yang@linux.dev liam@infradead.org linux-ext4@vger.k=
ernel.org linux-fsdevel@vger.kernel.org linux-kernel@vger.kernel.org linux-=
mm@kvack.org linux-nfs@vger.kernel.org ljs@kernel.org mhocko@kernel.org mho=
cko@suse.com nico.pache@linux.dev peterx@redhat.com pfalcato@suse.de qi.zhe=
ng@linux.dev rppt@kernel.org ryan.roberts@arm.com shakeel.butt@linux.dev st=
able@vger.kernel.org surenb@google.com usama.arif@linux.dev vbabka@kernel.o=
rg weixugc@google.com willy@infradead.org yuanchu@google.com ziy@nvidia.com=
]
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
-upstream-moderation/6b05e07f.2b4a0a19.394f81.0000.GAE%40google.com.
