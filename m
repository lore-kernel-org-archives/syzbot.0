Received: from mail-ot1-f50.google.com (mail-ot1-f50.google.com [209.85.210.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64DA434040A
	for <syzbot@lists.linux.dev>; Wed, 22 Jul 2026 13:18:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784726328; cv=pass; b=gy6G7Zr12M9UGGQ13L9goW4U3vlaVP/vqQrMbLWMMHrgdE2jNwmLBJOkUewRn9duVjG8jrGuUUD5xtatynZxoOxGwTVAXTTc4ui5L/hUU9b/cqUtBJ2z8TXUqFO/sdlxIz/f7mEXZgSmk26vrsSLkzYPWYd7iu8WHhrN/Zg4CdI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784726328; c=relaxed/simple;
	bh=tclga7B+nRulKHlWv4sBtSZAEdx7dY/bYBPaWvsgN4o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OxG1QTtvof6W7Pq55z3bLbY/Znx4tX5Vtp+ArTNloCkMDXckpQ1p50nSkx8yclhIrdpp4AKnEkYsV5rsTjhNye5LiAZ7kwmfiQc7BKqpTfz/EpHX5ufcdtLAevaL/qkGAzZAC3Mbdf/oPZEWvdaZGpAjOqQdRoi3vkh5OzOfdL4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TWKOyLKJ; arc=pass smtp.client-ip=209.85.210.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TWKOyLKJ"
Received: by mail-ot1-f50.google.com with SMTP id 46e09a7af769-7eb5bdb50fcso4604232a34.1
        for <syzbot@lists.linux.dev>; Wed, 22 Jul 2026 06:18:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784726316; cv=none;
        d=google.com; s=arc-20260327;
        b=ZGwC8Czzwmjr7LiOVazGmNWyGcVhdoPsNKO5Vf3WJZ0mQMAHZKJMp6ZaY+fH1XvE5t
         /6xTVYgOyEuIDClQUjVzoH91AGcL8EGlpPeqmtrfMLmWLQG1H8pL/dT2nkTLYKmMXT97
         FuAOajt0YopsrS5T8lKjeE+iIbK9LtWCMOnbYuovKiyrEVa02oGhNkgfz7Veyqzla+hl
         B9ON7fO4qYZKkN2CRslGdieUfwR1bsbaI5TA3huVE9kymB21S330dbFwpU+J/GWRRCLG
         wc0vMkeWt6o7k9RCn3oW4A6sIZMkLQnN13RWU9o8T7mBT58RrWgxYj/b3W+6FFmw1ZIk
         AuQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=phpOuH1asAjrZstojHbsI/aoouts/EAZ4K+fBuZ2iDc=;
        fh=Kso0x+WIoyCwkaB7yIXisTyyMJ4svyUg1dqrVIb/4kE=;
        b=PNr9xUe6r2t1kEBdfJA5lIIVMkqTjWE24h9px9my1za5OBbHIl4s7ffIEfNYeFPEYZ
         a+jNYgRXdpz2s6pB8ONnjQCWwnjBbE2fGhE09ZW860YayV6hvmL2xg0WRCiYCtAgiYdW
         QCPOT8H68/cnBzv7ZQLKM9YU2TxeT28cleIOmmr8FAOgpd5oZInGEThnCyUppWqc2tv5
         0onGyg2fID2b7LhZrCabkkWY2oCBqvS57cWEECJgVsfbO7JNBNYdrt201wCUcIz1cKXy
         KcXRUfg1gk/8ZnEvbBV2QWWezLJaA++Zs7Dc1BD+2Pz0BsRU3HY5hgz15/4tQhnEa26T
         mDPw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784726316; x=1785331116; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=phpOuH1asAjrZstojHbsI/aoouts/EAZ4K+fBuZ2iDc=;
        b=TWKOyLKJs1cmwPJUFiEmRL1g56Cw4WWIuLPz6YurPK39lrd7L0IITNiDPNqE3gO00P
         dFwl4FczNnBQDsH6494OG2Vq0SN2wfqcLKZv2go3qlUGbGNUHWrAEJPpmLwIt3t1vVBU
         SpJtWoVHO9RdX1tOR+ym1v7H9CCR7Eh6TCUdmG4sJ78wR8Ss110BtrSGe1EeMVS2zWac
         3WUvXAdmqEh/Nwt8WztC/CLfIArevp1PUWNovh4tFjgly6dv0HgK1Xh5TiaFPg1o/8lU
         hfPBH0eW04tq7+8633+KkM6K2eSBd8NGdkR0RBpBkMBaeTH1JynWdn7B1yxzKwM6bZ0V
         KEqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784726316; x=1785331116;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=phpOuH1asAjrZstojHbsI/aoouts/EAZ4K+fBuZ2iDc=;
        b=Xorr1DEpRFsrmzeyfkiUbRgXiC7UAYqVBq380bMM499CMADRW6PfWD6LHZER7ZJ7f2
         3regX+NhYNEoixGn2l9vdVmJ6lNMh+LeDOTfoviv3eOGrauFIIQV6eD/BnWx1pIWYljJ
         ScmDDALiWZIfQ7X9h5OL2gV3fb7LN42IP6OF/DnNBlWVRXicNMK8M0ILYkIFXgBr1Am9
         dpUkszWsHVwssHnt/qKKfmpg+8wGJOeqn2YDWhU6VqHC2B8GxDWUQqpK9ezt1afynNl5
         2S1/qbDvkUdwFZYnzVBKPyAnSDQqr3vhU+Q+j9Ek4DzJt6hEHo/hhTdfkx5eMNEDMDNB
         TCRw==
X-Forwarded-Encrypted: i=1; AHgh+Ro7j0Ezy59uQWyMldV65Wx/uVqqtMBVP5HenozuChLW2TpJzlvMt1xUbWyHI1vLxZcZkVbfrt4=@lists.linux.dev
X-Gm-Message-State: AOJu0YzfmzjowptsdGlemgJTYWInrp+NwXDnDj95X+P6nDkL45gEuV1D
	6ZmXW8bH58dxQhBf2LW6SVAnBJC24K8s5OPr0wk/zst6IkLcN2zia0E64KjlQqbWX01I+xEY8EY
	5B3IqNeK4e7B1AsSlEBajKR3nsz/DBGh++GT53rzU
X-Gm-Gg: AR+sD1063FCj4rozaip84w0fWsSGJjH9oj2+oVPJJ0vwv1LO74Ay/OWbEDvCPpVDvuv
	RGP2psIQyd6NNrmhZu780RGq+XjnUxH4qtnCExi0JAwEXQDq3G9qK3g6iAPbKa3gLX5vbwaghMZ
	Cs6n2L3hLJlSQvoknI9+HgjiO5BDNWldw3jTe2Fk94rV/Mf2sxaJqWBMm6L1M2BiBKLl8DfhCF0
	evqPDN6mdmu1m5AkNiTQ3bsskBbxafp59CCkc3QOUpnGIq+Ln28BvB98V43lJ8deCbDyA8j9ycL
	Cc2EqfiBQIxfT+VJG0QEBNzTjlZmVFn3t84kGKRVXo83xA44wo6da9A7lT1JCDFk+GUXriO3q3E
	DkkNI8r0ayv4zkHy5KBEjO++0SNstSg==
X-Received: by 2002:a05:6808:1816:b0:49b:e3c3:de6a with SMTP id
 5614622812f47-4a4d03a2eadmr13952227b6e.22.1784726315528; Wed, 22 Jul 2026
 06:18:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <6a60c27b.33ea6125.251e5.0009.GAE@google.com>
In-Reply-To: <6a60c27b.33ea6125.251e5.0009.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Wed, 22 Jul 2026 15:18:23 +0200
X-Gm-Features: AUfX_mxIso98EWRAvvYn0FOvK6a4EVazsbjNnHsnaEnuQgTJpFbGmraRG_yI8So
Message-ID: <CANp29Y5RE8TnQbwTyxLCsTXUvP93409vFEWfr8P8PR=P7mhWRw@mail.gmail.com>
Subject: Re: [moderation/CI] Re: arch, mm: create a generic
 set_memory/change_page_attr core
To: syzbot ci <syzbot+ci505703d15679e65e@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Wed, Jul 22, 2026 at 3:15=E2=80=AFPM syzbot ci
<syzbot+ci505703d15679e65e@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v1] arch, mm: create a generic set_memory/change_page_attr core
> https://lore.kernel.org/all/20260721-generic-set-memory-v0-1-v1-0-2c1fc62=
306b3@kernel.org
> * [PATCH RFC 01/18] x86/mm/pat: Don't gate cpa_lock on debug_pagealloc_en=
abled()
> * [PATCH RFC 02/18] x86/mm/pat: fix effective RW computation in lookup_ad=
dress_in_pgd_attr()
> * [PATCH RFC 03/18] x86/mm/pat: replace x86-speficic pg_level with generi=
c pgtable_level
> * [PATCH RFC 04/18] x86/mm/pat: use page table accessors for effective RW=
/NX bits
> * [PATCH RFC 05/18] x86/mm/pat: use a generic helper for the large page s=
ize
> * [PATCH RFC 06/18] x86/mm/pat: introduce an inline helper to check if al=
ias needs update
> * [PATCH RFC 07/18] x86/mm/pat: introduce cpa_handle_large_page()
> * [PATCH RFC 08/18] x86/mm/pat: use cpa_split_data structure to pass spli=
t parameters
> * [PATCH RFC 09/18] x86/mm/pat: use a single locked lookup for PTE verifi=
cation
> * [PATCH RFC 10/18] x86/mm/pat: move the large page size calculation to s=
hould_split_large_page
> * [PATCH RFC 11/18] x86/mm/pat, mm: set_memory: pull change_page_attr() c=
ore to mm/
> * [PATCH RFC 12/18] x86/pat/mm, mm/set_memory: abstract the CPA page tabl=
e lock
> * [PATCH RFC 13/18] mm/set_memory: read page table entries with pXdp_get(=
)
> * [PATCH RFC 14/18] x86/mm/pat, mm: move cpa-test to mm
> * [PATCH RFC 15/18] riscv: convert set_memory to the generic CPA implemen=
tation
> * [PATCH RFC 16/18] riscv: make set_direct_map_*_noflush actually noflush
> * [PATCH RFC 17/18] loongarch: convert set_memory to the generic CPA impl=
ementation
> * [PATCH RFC 18/18] loongarch: make set_direct_map_*_noflush actually nof=
lush
>
> and found the following issue:
> WARNING in arch_should_split_large_page
>
> Full report is available here:
> https://ci.syzbot.org/series/08799ddb-4fca-4e5c-a2a7-a16eb2845851
>
> ***
>
> WARNING in arch_should_split_large_page
>
> tree:      bpf-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/bpf/b=
pf-next.git
> base:      dc59e4fea9d83f03bad6bddf3fa2e52491777482
> arch:      amd64
> compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~e=
xp1~20260613092250.77), Debian LLD 22.1.8
> config:    https://ci.syzbot.org/builds/9a435490-f68f-4ca0-96ae-457a5caa1=
7e6/config
>
> Demotion targets for Node 1: null
> debug_vm_pgtable: [debug_vm_pgtable         ]: Validating architecture pa=
ge table helpers
> Key type .fscrypt registered
> Key type fscrypt-provisioning registered
> kAFS: Red Hat AFS client v0.1 registering.
> Btrfs loaded, assert=3Don, zoned=3Dyes, fsverity=3Dyes
> Key type big_key registered
> Key type encrypted registered
> AppArmor: AppArmor sha256 policy hashing enabled
> ima: No TPM chip found, activating TPM-bypass!
> Loading compiled-in module X.509 certificates
> Loaded X.509 cert 'Build time autogenerated kernel key: dc5bfa299b381f3c1=
21e230b24acaec0874c302b'
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
> PM:   Magic number: 2:551:79
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
> Freeing unused kernel image (initmem) memory: 26964K
> Write protecting the kernel read-only data: 221184k
> Testing CPA: undo ffffffff81000000-ffffffff8e800000
> ------------[ cut here ]------------
> CPA detected W^X violation: 00000000000001a1 -> 00000000000001a3 range: 0=
xffffffff81000000 - 0xffffffff811fffff PFN 1000
> WARNING: arch/x86/mm/pat/set_memory.c:601 at arch_should_split_large_page=
+0x493/0x710, CPU#0: swapper/0/1
> Modules linked in:
> CPU: 0 UID: 0 PID: 1 Comm: swapper/0 Not tainted syzkaller #0 PREEMPT(ful=
l)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:arch_should_split_large_page+0x49e/0x710
> Code: 00 48 8b 44 24 20 48 25 00 f0 ff ff 48 8b 4c 24 08 4c 8d 04 08 49 f=
f c8 48 8d 3d 4d 66 e1 0e 4c 89 ee 48 89 ea 4c 8b 4c 24 18 <67> 48 0f b9 3a=
 eb 05 e8 46 37 4d 00 4c 89 f7 48 89 ee e8 9b 39 4d
> RSP: 0000:ffffc900000679f0 EFLAGS: 00010296
> RAX: 0000000000200000 RBX: 0000000000000123 RCX: ffffffff81000000
> RDX: 00000000000001a3 RSI: 00000000000001a1 RDI: ffffffff905a8280
> RBP: 00000000000001a3 R08: ffffffff811fffff R09: 0000000000001000
> R10: 0000000000000003 R11: 0000000000000000 R12: 0000000000000002
> R13: 00000000000001a1 R14: 00000000000001a3 R15: 0000000000000002
> FS:  0000000000000000(0000) GS:ffff88818d95a000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: ffff88823ffff000 CR3: 000000000e946000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  __change_page_attr_set_clr+0x936/0x12d0
>  change_page_attr_set_clr+0x3ac/0x450
>  set_memory_rw+0x8c/0xd0
>  mark_rodata_ro+0xf0/0x140
>  kernel_init+0x4e/0x1d0
>  ret_from_fork+0x514/0xb70
>  ret_from_fork_asm+0x1a/0x30
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
> To test a patch for this bug, please reply with `#syz test`
> (should be on a separate line).
>
> The patch should be attached to the email.
> Note: arguments like custom git repos and branches are not supported.
>
> The email will later be sent to:
> [akpm@linux-foundation.org aou@eecs.berkeley.edu bp@alien8.de catalin.mar=
inas@arm.com chenhuacai@kernel.org dave.hansen@intel.com dave.hansen@linux.=
intel.com david@kernel.org hpa@zytor.com jackmanb@google.com jgross@suse.co=
m kevin.brodsky@arm.com liam@infradead.org linux-arm-kernel@lists.infradead=
.org linux-kernel@vger.kernel.org linux-mm@kvack.org linux-riscv@lists.infr=
adead.org ljs@kernel.org loongarch@lists.linux.dev luto@kernel.org mhocko@s=
use.com mingo@kernel.org mingo@redhat.com palmer@dabbelt.com peterz@infrade=
ad.org pjw@kernel.org rppt@kernel.org surenb@google.com tglx@kernel.org vba=
bka@kernel.org will@kernel.org x86@kernel.org]
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
-upstream-moderation/6a60c27b.33ea6125.251e5.0009.GAE%40google.com.
