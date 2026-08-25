Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com [209.85.222.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 526591E2614
	for <syzbot@lists.linux.dev>; Tue, 25 Aug 2026 08:01:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.222.171
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787644886; cv=pass; b=TCkOfPPSTl5m3gjORhNFVg3zmd5F8n3lJDtOheeHpe3ABclaUOrm+4Xfi0ONeqOaNaU/FX+vzjJMR4coA31o9NDDG5FvDywfSBO6JlhxXBfLTe7UN074R7c8lzowhgHSN2UCiBXFFlAsrPVkpsqx3Xwb6gEcXHcyHpiFPG7rREU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787644886; c=relaxed/simple;
	bh=RLrLrVTRC2gJEvuzuEAJC/kh6srHy1I/2IVIUq9b7a4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=L08mKYsif897TO5ZEawXQOvpulXI0Tncas1UzFWXsQCK1dsX4pTolIKsq5iQAJPw/ma25cWFxR9sIUuQJ4w3DeoLIaoXuKW+eescDFW4+D3fHFDlSU4Wtve/wkGQoNDcxBAvn3qOwlx0nbK/Q4JMcAaGjS2Zfy4uwKbwcuBkZdA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=s5U/gwr7; arc=pass smtp.client-ip=209.85.222.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="s5U/gwr7"
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-92e55b62640so208680385a.0
        for <syzbot@lists.linux.dev>; Tue, 25 Aug 2026 01:01:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787644883; cv=none;
        d=google.com; s=arc-20260327;
        b=mBgzmmj775iacGKZKal2Uu34MxXRkz+/nbhqxXJfcOpy8VnR5oK/ymbG5ncc3oNZsn
         F22KLqBf4nmwF0v1BnZVtpdvE63YSaWYwk/hx+C7z3tMdVT+B+XvKadWm26F2dTLH+Tz
         PdEqCHOSnvJYnR+on22FECPkpXsrqthZ+8H4XN596bFg7ayURGNX6aLVD+9X0aIiFJcw
         yTX3cYT2arw0by6Ex1F/tgCcSZ/xE3Xk8k3Pjn9u+lCh9XtIaha9GtyzIBnsF8+z8QC1
         A5J8Vr77utuCyrpnI3jRdlY+Ymf/N9PGG6UHH3a5CTafREKwUiJTHgDlVLy9sqmZHGnX
         p2jg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=G56B/cnog417cNQFA+R7g8jcPwVFScJesl5w87Xbozo=;
        fh=GNeSzerevO9OFnvz/QLBR85cUPO56f78+dPhXYIrla0=;
        b=ZPPHE7X1vEbqQpIbXJqJEoOmySw8OvATpcYwstdUU+Y+fKAZP8hJxXKU2H6iEPzceA
         rcARKotyL/hh7RrcTi0vJ/492xDyDN07GoVttPbXzjYsVybfL0ZBIKQtNavNcz+PNlRV
         4YWPz8j4USHkFfJSxM9O/RmXZwCNyoP+nFNDfEyxuSer5OYVOM72nMJS3qWy6uwmNwIh
         2/WK+hruUk15El+OX0n9Et684NdSEFR2xwJIcLIPrk0cRCjTTfFGN9yQvgklyqz3XphZ
         ljaPHFPgy66mXnEfZv9j+sVYyNOspQG3hJq6cqtGFzHo7pY34/BvUs2OYaN8xEbdPVzU
         7CiA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787644883; x=1788249683; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=G56B/cnog417cNQFA+R7g8jcPwVFScJesl5w87Xbozo=;
        b=s5U/gwr7ttMtS7LrV6PnSQ1smwOCYtk3DmXbtGty/bddyk6vUge22760S8jEihc/JI
         P0BvZStcuZhdiLExh7xxgAwBen7Yq637FBNr38f1H7zTND2CjxJayvXpXAHwgrC2K1tb
         gr94ygIfZW8xXiOjor6TfUnCW4nCAPdrL4wXlro1qttR++YKd9mrQPz71RDV8VtVnjXI
         WANsoK+2/oJUnYDAp3Rzfd3Jsc7B7MTZx7z+RkM5AHhQZ8bszyDfhX8llgbklWJIhttO
         nZs49PRtnj22ehG/AjEDMPBE8uDT3wgIkNDWM4r0j2271W3hP0+fIj4chndWiGH1+vd6
         ba8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787644883; x=1788249683;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=G56B/cnog417cNQFA+R7g8jcPwVFScJesl5w87Xbozo=;
        b=HVlyMxbgOoFm5hNeeDQvynszrAk3NLGz5fTNKJhraginPv9M1uOah2+UK0d/udxXfA
         E+JeNZ0oYoPJj0kmHzYRbxA51D3F0Oi7jN4HfkMu9FTggDN534MJf8shXuWk4qHKAcec
         1wkMiNZfU80sahd7f7ZbyxUhq2Lf8ESP3XrBev17R/YXpICNzq6xq04d3K/TBkx2MoFb
         69cv3vjMnsEo/GGif+TXMqCZ7clF3blWiLHCY+zyGQKfxqNhOxjxsni/hfFmp4JsYKWx
         FoNVdnJF2m34mY4OFUY/SfDG0Fqium4HGwzoF2+0s8kurfd7HeiYNM2E7Xcn6Rj5qRps
         iA0g==
X-Forwarded-Encrypted: i=1; AHgh+Ro1IUKpzqQcRhvTIMQspXqFGBcEAijAo2eB7XhXDxPUyI4NngX3Nib/RxMK3NE9+4aGViV8YIE=@lists.linux.dev
X-Gm-Message-State: AFuF++n625ManBb6IXfNoMyebAwi+WW5Bk+pg+utpezn/d8KeXMZJhZ3
	bp7U2n5Z+gNoU2/6p9kwm3aZSgL9kc426LYn7X2i1haSqGUnjheu8qjPUO/Kf3UrwNanWi/VnE9
	6pmXRmoqG/l9VWrJFbLLjI9YX7KBHuYFHQhlYyTvwlDrllzuLHkcXSLBk
X-Gm-Gg: AR+sD13gn0vyZa6iZdjQUejBWZvZ2/VsUsgHMdiGZeMr+NN/Xh/EP73gGtP93waYuvv
	F2NK8spUIYDWbC2ggEh8/z1/6xS63VyFQH2iwj2/OTy0jYQjuoMPNIdZSjaPsWuQ0JHdTgMlRz6
	D8L54KmfwhZr333z5EjbIkSYJ2Obi6v0ko3HL8R+DIigkme+FpEHBf2I2IFw1v3WOiGmQ9Pqayf
	nrHbQ7vCD9vzJBZlhsuCCDXIcNXTUIoTKz4+ur+DO19zk3ffU/ZZn/gfMcyWsVCIvYME/MKXKlg
	HrNVtP+CKgmgDevZcaK3KiModdjEpflBsZBWVZI6l/Mx78YIDh2/ylrBucMXc4gut3GaDoteQhB
	fuhiTbQrOtQg0eEypvLUcYM5ksHvuSuTkz2M=
X-Received: by 2002:a05:620a:4609:b0:936:afa0:3661 with SMTP id
 af79cd13be357-9374698a5e7mr2074781385a.36.1787644882200; Tue, 25 Aug 2026
 01:01:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <6a8cca2f.dbb3a75c.7844.0010.GAE@google.com>
In-Reply-To: <6a8cca2f.dbb3a75c.7844.0010.GAE@google.com>
From: Pimyn Girgis <pimyn@google.com>
Date: Tue, 25 Aug 2026 10:01:10 +0200
X-Gm-Features: AcwNN1Wdkx8JyINBDt_m18M2Ql0nRsRTANgY2ffdCrAdk1KtvIVsM1gTrGSE3rU
Message-ID: <CAJWNTGwtJUK2C_e_Nmw-FCb48-WK02wruxz-LFr-v9v4OBJ=sA@mail.gmail.com>
Subject: Re: [moderation/CI] Re: swiotlb: avoid swiotlb copy on network sockets
To: syzbot ci <syzbot+ci9b0d526829958f23@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream


On Tue, Aug 25, 2026 at 12:48=E2=80=AFAM syzbot ci
<syzbot+ci9b0d526829958f23@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v2] swiotlb: avoid swiotlb copy on network sockets
> https://lore.kernel.org/all/20260824152932.1583506-1-lrizzo@google.com
> * [PATCH v2 1/5] swiotlb: enforce pool nareas and nslabs invariants
> * [PATCH v2 2/5] swiotlb/mm: Implement SWIOTLB nocopy page allocator
> * [PATCH v2 3/5] net/swiotlb: Track bounce device per socket
> * [PATCH v2 4/5] net: Divert socket allocations to SWIOTLB for nocopy TX
> * [PATCH v2 5/5] swiotlb: Implement RX nocopy with fast recycling evictio=
n
>
> and found the following issue:
> general protection fault in page_pool_put_unrefed_netmem
>
> Full report is available here:
> https://ci.syzbot.org/series/b17756c4-983f-4d7a-8415-3da06c0dda99
>
> ***
>
> general protection fault in page_pool_put_unrefed_netmem
>
> tree:      torvalds
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torva=
lds/linux
> base:      0a0d1d55dad570724bf8c7ea83409639cfb4be9b
> arch:      amd64
> compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~e=
xp1~20260613092250.77), Debian LLD 22.1.8
> config:    https://ci.syzbot.org/builds/20e51ca2-88da-4674-9797-a62c64743=
095/config
> syz repro: https://ci.syzbot.org/findings/4385dd7f-d1fc-4627-ad19-6862c78=
0a90c/syz_repro
>
> Oops: general protection fault, probably for non-canonical address 0xdfff=
fc0000000082: 0000 [#1] SMP KASAN PTI
> KASAN: null-ptr-deref in range [0x0000000000000410-0x0000000000000417]
> CPU: 0 UID: 0 PID: 5836 Comm: syz.2.19 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:swiotlb_addr_in_default_pool include/linux/swiotlb.h:177 [inlin=
e]
> RIP: 0010:swiotlb_is_nocopy_addr include/linux/swiotlb.h:184 [inline]
> RIP: 0010:__page_pool_put_page net/core/page_pool.c:851 [inline]
> RIP: 0010:page_pool_put_unrefed_netmem+0x22a/0xd20 net/core/page_pool.c:9=
30
> Code: 5c 63 00 00 89 c5 31 ff 89 c6 e8 61 17 04 f8 85 ed 0f 84 07 08 00 0=
0 e8 54 12 04 f8 49 81 c4 10 04 00 00 4c 89 e0 48 c1 e8 03 <42> 80 3c 28 00=
 74 08 4c 89 e7 e8 37 c7 73 f8 4d 8b 24 24 4d 85 e4
> RSP: 0018:ffffc900039df230 EFLAGS: 00010206
> RAX: 0000000000000082 RBX: 0000000000000000 RCX: ffff888160efda00
> RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000000
> RBP: 0000000000000001 R08: ffffffff89c3aca5 R09: 0000000000000000
> R10: 0000000000000000 R11: ffffffff8ed5a4e0 R12: 0000000000000410
> R13: dffffc0000000000 R14: ffffea0004450300 R15: 0000000004450300
> FS:  00007f08f83e86c0(0000) GS:ffff88818d6fc000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007ffd455a8fe8 CR3: 00000001134ac000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  page_pool_put_netmem include/net/page_pool/helpers.h:343 [inline]
>  page_pool_put_full_netmem include/net/page_pool/helpers.h:373 [inline]
>  napi_pp_put_page+0x133/0x1e0 net/core/skbuff.c:1036
>  skb_pp_recycle net/core/skbuff.c:1047 [inline]
>  skb_free_head net/core/skbuff.c:1091 [inline]
>  skb_release_data+0x8c3/0xab0 net/core/skbuff.c:1122
>  skb_release_all net/core/skbuff.c:1197 [inline]
>  __kfree_skb+0x5d/0x210 net/core/skbuff.c:1211
>  llc_rcv+0x77a/0xcb0 net/llc/llc_input.c:-1
>  __netif_receive_skb_list_ptype net/core/dev.c:6312 [inline]
>  __netif_receive_skb_list_core+0x784/0x830 net/core/dev.c:6354
>  __netif_receive_skb_list net/core/dev.c:6406 [inline]
>  netif_receive_skb_list_internal+0x995/0xcf0 net/core/dev.c:6497
>  netif_receive_skb_list+0x67/0x480 net/core/dev.c:6549
>  xdp_recv_frames net/bpf/test_run.c:268 [inline]
>  xdp_test_run_batch net/bpf/test_run.c:349 [inline]
>  bpf_test_run_xdp_live+0x1875/0x1c20 net/bpf/test_run.c:378
>  bpf_prog_test_run_xdp+0x7d8/0x11d0 net/bpf/test_run.c:1463
>  bpf_prog_test_run+0x2c5/0x340 kernel/bpf/syscall.c:4804
>  __sys_bpf+0xa22/0xd90 kernel/bpf/syscall.c:6385
>  __do_sys_bpf kernel/bpf/syscall.c:6486 [inline]
>  __se_sys_bpf kernel/bpf/syscall.c:6483 [inline]
>  __x64_sys_bpf+0xba/0xd0 kernel/bpf/syscall.c:6483
>  do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
>  do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f08f759e0d9
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007f08f83e8028 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
> RAX: ffffffffffffffda RBX: 00007f08f7825fa0 RCX: 00007f08f759e0d9
> RDX: 0000000000000048 RSI: 0000200000000600 RDI: 000000000000000a
> RBP: 00007f08f7635024 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f08f7826038 R14: 00007f08f7825fa0 R15: 00007fffc4c69778
>  </TASK>
> Modules linked in:
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:swiotlb_addr_in_default_pool include/linux/swiotlb.h:177 [inlin=
e]
> RIP: 0010:swiotlb_is_nocopy_addr include/linux/swiotlb.h:184 [inline]
> RIP: 0010:__page_pool_put_page net/core/page_pool.c:851 [inline]
> RIP: 0010:page_pool_put_unrefed_netmem+0x22a/0xd20 net/core/page_pool.c:9=
30
> Code: 5c 63 00 00 89 c5 31 ff 89 c6 e8 61 17 04 f8 85 ed 0f 84 07 08 00 0=
0 e8 54 12 04 f8 49 81 c4 10 04 00 00 4c 89 e0 48 c1 e8 03 <42> 80 3c 28 00=
 74 08 4c 89 e7 e8 37 c7 73 f8 4d 8b 24 24 4d 85 e4
> RSP: 0018:ffffc900039df230 EFLAGS: 00010206
> RAX: 0000000000000082 RBX: 0000000000000000 RCX: ffff888160efda00
> RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000000
> RBP: 0000000000000001 R08: ffffffff89c3aca5 R09: 0000000000000000
> R10: 0000000000000000 R11: ffffffff8ed5a4e0 R12: 0000000000000410
> R13: dffffc0000000000 R14: ffffea0004450300 R15: 0000000004450300
> FS:  00007f08f83e86c0(0000) GS:ffff88818d6fc000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007ffd455a8fe8 CR3: 00000001134ac000 CR4: 00000000000006f0
> ----------------
> Code disassembly (best guess), 2 bytes skipped:
>    0:   00 00                   add    %al,(%rax)
>    2:   89 c5                   mov    %eax,%ebp
>    4:   31 ff                   xor    %edi,%edi
>    6:   89 c6                   mov    %eax,%esi
>    8:   e8 61 17 04 f8          call   0xf804176e
>    d:   85 ed                   test   %ebp,%ebp
>    f:   0f 84 07 08 00 00       je     0x81c
>   15:   e8 54 12 04 f8          call   0xf804126e
>   1a:   49 81 c4 10 04 00 00    add    $0x410,%r12
>   21:   4c 89 e0                mov    %r12,%rax
>   24:   48 c1 e8 03             shr    $0x3,%rax
> * 28:   42 80 3c 28 00          cmpb   $0x0,(%rax,%r13,1) <-- trapping in=
struction
>   2d:   74 08                   je     0x37
>   2f:   4c 89 e7                mov    %r12,%rdi
>   32:   e8 37 c7 73 f8          call   0xf873c76e
>   37:   4d 8b 24 24             mov    (%r12),%r12
>   3b:   4d 85 e4                test   %r12,%r12
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
> [akpm@linux-foundation.org davem@davemloft.net david@kernel.org driver-co=
re@lists.linux.dev dtatulea@nvidia.com edumazet@google.com gregkh@linuxfoun=
dation.org iommu@lists.linux.dev kuba@kernel.org kuniyu@google.com linux-ke=
rnel@vger.kernel.org linux-mm@kvack.org lrizzo@google.com m.szyprowski@sams=
ung.com netdev@vger.kernel.org pabeni@redhat.com rafael@kernel.org rizzo.un=
ipi@gmail.com robin.murphy@arm.com willemb@google.com]
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
-upstream-moderation/6a8cca2f.dbb3a75c.7844.0010.GAE%40google.com.



--=20
=E2=B2=A0=E2=B2=9F=E2=B2=93=E2=B2=99=E2=B2=8F=E2=B2=9B =E2=B2=84=E2=B2=89=
=E2=B2=B1=E2=B2=A3=E2=B2=85=E2=B2=93=E2=B2=9F=E2=B2=A5 - Pimyn Girgis
Software Engineer
Kernel Dynamic Analysis
pimyn@google.com
