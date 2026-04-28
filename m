Received: from mail-oo1-f50.google.com (mail-oo1-f50.google.com [209.85.161.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9291034252B
	for <syzbot@lists.linux.dev>; Tue, 28 Apr 2026 06:18:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.161.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777357123; cv=pass; b=dlrn6yWkOkwRTaHL2WL2BOLSvx/qH+BMvyumwwoJeFfute9BHAwi0Z5sUH4/Jtae+FnwO/Z3eDY45sK3Sk5AiJJA+jVNv7iQdTRMBJUyaiKp3AomxfN0JS1LK0vTeph1b6gQLU2KEcRgKOr+P/UH0ZrmxPpK7/0WfvSNW3IDfCs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777357123; c=relaxed/simple;
	bh=8QRd1no5hNzXQaHhqTdnunPjyG5tNLJIpl2wFfD1a8E=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OORbFEcSU5qdGtmoQlt/+MpxEriRu9h1YAOLReSPJb8EwLN4uCq9aS7waIgyHTow8v4qa4Rdpj6wC1MlIztpqP31RVZVQMtDcSd1ysaL0hK1rNAQtH+dUZ+VkJbYA6cVxeRetbA5CQvRUr2LvnQCMCZs4TewcIZUpkpDUwpp9Rs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=gPJ1hZE+; arc=pass smtp.client-ip=209.85.161.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gPJ1hZE+"
Received: by mail-oo1-f50.google.com with SMTP id 006d021491bc7-6948e6bc30cso2927283eaf.0
        for <syzbot@lists.linux.dev>; Mon, 27 Apr 2026 23:18:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777357120; cv=none;
        d=google.com; s=arc-20240605;
        b=luvGrTzOQmHYoWve8SkezXQeuiOHB/5uoSTcc5KSoPtiiqAJdFJVwjhltLvjZCriJL
         j0L4E2x6Et7CJFp0XxiPkK7+rvex5+tK/Cr/CnBpzEsoVDmew0vUyIE58pe1wOuolpGD
         p5noFay46WnaxfbAK3LcDEu1vvIiEGbZ+u2mciBcVtU1ot9aCSZQdoskFmqMENMFCWrl
         U1w+p8zd/rmB/XDfUY1cf66PgDXSvSrsvW2HG4tyhnD5N+RKRvrKyhmCZ7CHPgQhujo1
         +cPfHu9zQFN7Gg8NOQ7rwhS/i/FGInLj75yDMqmeXHKaec/eylwW6Cbd3Q8EVK8typkg
         qxtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=b6ekEolI6V8Don3ud9sC2mNuI+fCo3MxdJ5IA003V8I=;
        fh=OL2RzQXn2fbD/KrozRqac1oKeiTvSVMWS6bcKlmtsSw=;
        b=jmCK2MdgyDajygpGysoxt5pazWGETzvP2iJ3VVTqCwPfnKtreQ4fMRczwlhD7KMdfe
         gyW/a+cUnmVBI/8AJtn9RKBHaUWcMZ/waYBSSeQxkgMoCOgpiHpg1Sq9KrG9ihnT7g0y
         RUPL25NOw9mqfOVIDFGyo2Y4Ka4ALtEoYRPLJbP8BFs5sjNtzoVO2wgd2y3cHBosYLO+
         GjHuYANT+JyKj3a2fKk+QdphOC/BOeffnCdlPv9sZ7KiHWQTUG8qTFiBb25ZMrBB5ClZ
         nroX2DsX04Nh1JCcDBNq4fbfDYhiphbDSthWTwnX11aeUYt4kIXfuoHOvglTSfMSqZV7
         8w/g==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777357120; x=1777961920; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=b6ekEolI6V8Don3ud9sC2mNuI+fCo3MxdJ5IA003V8I=;
        b=gPJ1hZE+HibF4sRhP4Yms/oOg1xt72Irfkaq1zbeXNtOSjDG23fOEq18tEVxZgV4Az
         LLGhEMQD2/nE8zmS5MbvV1RGMivrTtPsbul0a2U6GQ/rE4VrDNvSsdhwYlQQ4nLZ+/K5
         TTI5AHypzligINLbqruJIdmBC0LJJqL0q9ZAtvnkgiyzJkmmD66MfFo6x0ESI5USGdjz
         HYQmL713BDQWL5+xmkA3jw8oeZcifUUFx5XQHYOexadwwen1nhrw5z7J4T8bSmooEsSF
         N3ZYj/V4hWgN1uxXUY8q1qh2ulqbxJgLVEPzg16Dy1fLHgGmN8X7V6X1EKucNqpgz88o
         O1Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777357120; x=1777961920;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=b6ekEolI6V8Don3ud9sC2mNuI+fCo3MxdJ5IA003V8I=;
        b=ZEhnp3HxfFCe0upWo1TKOXUtFm5QJ7g1aPmOSBFR7w+gg4/wQVkx2BOm300nrYqU8V
         y0FhR99IdHRWYxcnkBweyAiWlJEXUDwJ6Z2RerFez/RsHa8aFaL0tDvd7CLg9haf5471
         +4PykE/ehc2t2Fd1LfS3SOBCSfBOrSFekktcLOvwhxWmCRIacR26TeZ4Pb4nhwKb6SKc
         5yW2WBheBBO33oLrgHIF1tfwDeJ1eqpFFltwQ9C5vtA926Y2py2wQs6deZOZguZvv2/O
         888qwl1DDmLCnHYn/yp+M7btIEPiYFf1LuAGcb1urg1KeyxI+WVhPg7qnQKtctzobHmF
         dlcQ==
X-Forwarded-Encrypted: i=1; AFNElJ+SciQsmEOxq3eMkozVzCwgiWd5a8izrasTgbKkgZovLWJ3frCkGHtkxzfvnDFKvBTB2D0Nthk=@lists.linux.dev
X-Gm-Message-State: AOJu0YznR44Pi7h88XKVtjnxL5qSzmAbOv+lBLttbJ84SJj/EuPn3llK
	yl8vahHLfC7dMn5kwxEi/0MRrhSyc1Gzt4vtuh3XG5c232dO+aHELj0Mu8jecsTldqvbs2WmPwW
	sHY3RaRzfifSuJy8DN2e3Ky++cyiNYN2qsYkCvYPY
X-Gm-Gg: AeBDietLXeD1vrCYeKHaGlPPTkLZXHXAAnEb1Q/0HMQmP7N+ur9LCHq9m5kGrRJp6cL
	TFVsrWP7gZNdeml2mK3VOxdB2YEndqGbpprvSPW43/yVu9mR8KW+zSXRELEDJ6CVODq0C3xCZSz
	amvufc254TCLeY7+u1cRpeOKcpGdARGJcKoePEAFa8h63X9RT4ygqMYnjKzEv5Xq3v8zj89VtjG
	soD6IPVJrY5DpbtzNEd7/66LZtCRdgCGw2WBQYGC8YN8X+651Mqgqld043PlfXxNv8ZDrj0Q6I9
	IHnUO5Sa86yckK8e0tlG1lFKmJpMsk/akxPQMHAGjkYmsP0JU9vlzF+/qgpOKVbnAyLhYCww9og
	+dcJhpVlXqeJ6Iidml0EK/g1HxO8=
X-Received: by 2002:a05:6820:1894:b0:696:2674:8a1e with SMTP id
 006d021491bc7-6965cb46249mr889876eaf.35.1777357119993; Mon, 27 Apr 2026
 23:18:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <69efd8ca.050a0220.18b4f.0007.GAE@google.com>
In-Reply-To: <69efd8ca.050a0220.18b4f.0007.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Tue, 28 Apr 2026 08:18:27 +0200
X-Gm-Features: AVHnY4JPUDY_loT2uLWgc4nLnSXgDsvHg8X5D273so1fzTVhYsACm3ZdiAvGXAg
Message-ID: <CANp29Y7g1NP2O3X4Qe3wdyaeCicEaZXBL1b7wf7y-mQhz2dMZg@mail.gmail.com>
Subject: Re: [moderation/CI] Re: uaccess: Convert small fixed size
 copy_{to/from}_user() to scoped user access
To: syzbot ci <syzbot+ci59ae1c0b8d5ca61e@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Probably better not to report it.
Should be easily noticed by others (boot time KASAN) + the series like
won't pass anyway given Linus' comments.

On Mon, Apr 27, 2026 at 11:44=E2=80=AFPM syzbot ci
<syzbot+ci59ae1c0b8d5ca61e@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v1] uaccess: Convert small fixed size copy_{to/from}_user() to scoped us=
er access
> https://lore.kernel.org/all/cover.1777306795.git.chleroy@kernel.org
> * [RFC PATCH v1 1/9] uaccess: Split check_zeroed_user() out of usercopy.c
> * [RFC PATCH v1 2/9] uaccess: Convert INLINE_COPY_{TO/FROM}_USER to kconf=
ig and reduce ifdefery
> * [RFC PATCH v1 3/9] x86/umip: Be stricter in fixup_umip_exception()
> * [RFC PATCH v1 4/9] uaccess: Introduce copy_{to/from}_user_partial()
> * [RFC PATCH v1 5/9] uaccess: Switch to copy_{to/from}_user_partial() whe=
n relevant
> * [RFC PATCH v1 6/9] uaccess: Change copy_{to/from}_user to return -EFAUL=
T
> * [RFC PATCH v1 7/9] x86: Add unsafe_copy_from_user()
> * [RFC PATCH v1 8/9] arm64: Add unsafe_copy_from_user()
> * [RFC PATCH v1 9/9] uaccess: Convert small fixed size copy_{to/from}_use=
r() to scoped user access
>
> and found the following issue:
> general protection fault in rt_sigprocmask
>
> Full report is available here:
> https://ci.syzbot.org/series/aa7fc2a4-0ff8-418d-a7f8-d564d6337c56
>
> ***
>
> general protection fault in rt_sigprocmask
>
> tree:      bpf-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/bpf/b=
pf-next.git
> base:      7c8d208d816d0504aa916138ae097d9cb4ed4e56
> arch:      amd64
> compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~e=
xp1~20251221153213.50), Debian LLD 21.1.8
> config:    https://ci.syzbot.org/builds/e539adaf-05e5-409c-80f8-973dab3db=
2a7/config
>
> Key type big_key registered
> Key type encrypted registered
> AppArmor: AppArmor sha256 policy hashing enabled
> ima: No TPM chip found, activating TPM-bypass!
> Loading compiled-in module X.509 certificates
> Loaded X.509 cert 'Build time autogenerated kernel key: 63d9792cbf98a5c58=
c0509974cba8c406c7870ed'
> ima: Allocated hash algorithm: sha256
> ima: No architecture policies found
> evm: Initialising EVM extended attributes:
> evm: security.selinux (disabled)
> evm: security.SMACK64 (disabled)
> evm: security.SMACK64EXEC (disabled)
> evm: security.SMACK64TRANSMUTE (disabled)
> evm: security.SMACK64MMAP (disabled)
> evm: security.apparmor
> evm: security.ima
> evm: security.capability
> evm: HMAC attrs: 0x1
> PM:   Magic number: 6:723:551
> block sda: hash matches
> acpi PNP0C0F:02: hash matches
> netconsole: network logging started
> gtp: GTP module loaded (pdp ctx size 128 bytes)
> rdma_rxe: loaded
> cfg80211: Loading compiled-in X.509 certificates for regulatory database
> Loaded X.509 cert 'sforshee: 00b28ddf47aef9cea7'
> Loaded X.509 cert 'wens: 61c038651aabdcf94bd0ac7ff06c7248db18c600'
> clk: Disabling unused clocks
> ALSA device list:
>   #0: Dummy 1
>   #1: Loopback 1
>   #2: Virtual MIDI Card 1
> md: Waiting for all devices to be available before autodetect
> md: If you don't use raid, use raid=3Dnoautodetect
> md: Autodetecting RAID arrays.
> md: autorun ...
> md: ... autorun DONE.
> EXT4-fs (sda1): mounted filesystem b4773fba-1738-4da0-8a90-0fe043d0a496 r=
o with ordered data mode. Quota mode: none.
> VFS: Mounted root (ext4 filesystem) readonly on device 8:1.
> devtmpfs: mounted
> VFS: Pivoted into new rootfs
> Freeing unused kernel image (initmem) memory: 26948K
> Write protecting the kernel read-only data: 221184k
> Freeing unused kernel image (text/rodata gap) memory: 2032K
> Freeing unused kernel image (rodata/data gap) memory: 1428K
> x86/mm: Checked W+X mappings: passed, no W+X pages found.
> x86/mm: Checking user space page tables
> x86/mm: Checked W+X mappings: passed, no W+X pages found.
> Failed to set sysctl parameter 'max_rcu_stall_to_panic=3D1': parameter no=
t found
> Run /sbin/init as init process
> Oops: general protection fault, probably for non-canonical address 0xe000=
0be81c51ea95: 0000 [#1] SMP KASAN PTI
> KASAN: probably user-memory-access in range [0x00007f40e28f54a8-0x00007f4=
0e28f54af]
> CPU: 1 UID: 0 PID: 1 Comm: init Not tainted syzkaller #0 PREEMPT(full)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:__se_sys_rt_sigprocmask+0x139/0x310
> Code: 00 00 e8 3a f1 a5 00 48 b8 00 f0 ff ff ff 7f 00 00 49 39 c4 4c 0f 4=
7 e0 0f 1f 00 48 8d 44 24 60 48 8b 08 4c 89 e0 48 c1 e8 03 <80> 3c 18 00 74=
 0e 4c 89 e7 48 89 cb e8 56 ef a5 00 48 89 d9 49 89
> RSP: 0018:ffffc90000067de0 EFLAGS: 00010206
> RAX: 00000fe81c51ea95 RBX: dffffc0000000000 RCX: 0000000000000000
> RDX: 0000000000000001 RSI: 0000000000000008 RDI: ffffc90000067e40
> RBP: ffffc90000067ee0 R08: ffffc90000067e47 R09: 1ffff9200000cfc8
> R10: dffffc0000000000 R11: fffff5200000cfc9 R12: 00007f40e28f54a8
> R13: 1ffff9200000cfc0 R14: ffff8881026f6210 R15: 1ffff110204dec42
> FS:  00007f40e25f5380(0000) GS:ffff8882a8fd4000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f40e28baf3f CR3: 0000000171dca000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  do_syscall_64+0x15f/0xf80
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f

^^^^
curious why symbolization doesn't work for boot time errors..

> RIP: 0033:0x7f40e26f5773
> Code: 00 f3 a5 48 8d 74 24 88 48 b9 ff ff ff 7f fe ff ff ff 48 21 c8 48 8=
9 44 24 88 41 ba 08 00 00 00 44 89 c7 b8 0e 00 00 00 0f 05 <45> 31 c0 3d 00=
 f0 ff ff 76 06 41 89 c0 41 f7 d8 44 89 c0 5a c3 41
> RSP: 002b:00007fffc2ca58c0 EFLAGS: 00000246 ORIG_RAX: 000000000000000e
> RAX: ffffffffffffffda RBX: 00007fffc2ca5ac8 RCX: 00007f40e26f5773
> RDX: 0000000000000000 RSI: 00007f40e28f54a8 RDI: 0000000000000000
> RBP: 00007f40e28f54a8 R08: 0000000000000000 R09: 00007f40e2904b5d
> R10: 0000000000000008 R11: 0000000000000246 R12: 00007f40e28f54a0
> R13: 00007fffc2ca5ad8 R14: 0000562515803169 R15: 00007f40e292ea80
>  </TASK>
> Modules linked in:
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:__se_sys_rt_sigprocmask+0x139/0x310
> Code: 00 00 e8 3a f1 a5 00 48 b8 00 f0 ff ff ff 7f 00 00 49 39 c4 4c 0f 4=
7 e0 0f 1f 00 48 8d 44 24 60 48 8b 08 4c 89 e0 48 c1 e8 03 <80> 3c 18 00 74=
 0e 4c 89 e7 48 89 cb e8 56 ef a5 00 48 89 d9 49 89
> RSP: 0018:ffffc90000067de0 EFLAGS: 00010206
> RAX: 00000fe81c51ea95 RBX: dffffc0000000000 RCX: 0000000000000000
> RDX: 0000000000000001 RSI: 0000000000000008 RDI: ffffc90000067e40
> RBP: ffffc90000067ee0 R08: ffffc90000067e47 R09: 1ffff9200000cfc8
> R10: dffffc0000000000 R11: fffff5200000cfc9 R12: 00007f40e28f54a8
> R13: 1ffff9200000cfc0 R14: ffff8881026f6210 R15: 1ffff110204dec42
> FS:  00007f40e25f5380(0000) GS:ffff8882a8fd4000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f40e28baf3f CR3: 0000000171dca000 CR4: 00000000000006f0
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
> [akpm@linux-foundation.org amd-gfx@lists.freedesktop.org bpf@vger.kernel.=
org chleroy@kernel.org david.laight.linux@gmail.com dmaengine@vger.kernel.o=
rg dri-devel@lists.freedesktop.org intel-gfx@lists.freedesktop.org kasan-de=
v@googlegroups.com kvm@vger.kernel.org linux-alpha@vger.kernel.org linux-ar=
ch@vger.kernel.org linux-arm-kernel@lists.infradead.org linux-csky@vger.ker=
nel.org linux-efi@vger.kernel.org linux-fsdevel@vger.kernel.org linux-fsi@l=
ists.ozlabs.org linux-hexagon@vger.kernel.org linux-kernel@vger.kernel.org =
linux-m68k@lists.linux-m68k.org linux-media@vger.kernel.org linux-mips@vger=
.kernel.org linux-mm@kvack.org linux-openrisc@vger.kernel.org linux-parisc@=
vger.kernel.org linux-riscv@lists.infradead.org linux-s390@vger.kernel.org =
linux-serial@vger.kernel.org linux-sh@vger.kernel.org linux-snps-arc@lists.=
infradead.org linux-sound@vger.kernel.org linux-spi@vger.kernel.org linux-s=
taging@lists.linux.dev linux-um@lists.infradead.org linux-usb@vger.kernel.o=
rg linux-wireless@vger.kernel.org linux-wpan@vger.kernel.org linux-x25@vger=
.kernel.org linuxppc-dev@lists.ozlabs.org loongarch@lists.linux.dev netdev@=
vger.kernel.org ocfs2-devel@lists.linux.dev rust-for-linux@vger.kernel.org =
sound-open-firmware@alsa-project.org sparclinux@vger.kernel.org tglx@linutr=
onix.de torvalds@linux-foundation.org xen-devel@lists.xenproject.org ynorov=
@nvidia.com]
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
-upstream-moderation/69efd8ca.050a0220.18b4f.0007.GAE%40google.com.
