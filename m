Received: from mail-ot1-f49.google.com (mail-ot1-f49.google.com [209.85.210.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20C7834D398
	for <syzbot@lists.linux.dev>; Mon, 23 Feb 2026 08:39:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771835954; cv=pass; b=JbTi4PPSJ3563QwMuk9kiUkhzp6mIqjgPPc/SlHOBkmGRbqXd50H0AcZHtJE7qukcJB0CWEu3MJ5IAPJURJX6/QDh3Yd9Y6rCAcdJIHPFlVvEMyGYK+MeoycCauRJWDXXsPLwYTohXBkAbN3bmABIDBS8PNFqWJLY6acC1h3MNA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771835954; c=relaxed/simple;
	bh=fZoK9tmQ7kprabGrzIYASmQFOylWKT03lVJ2HwXUe60=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YkPWO0DPf6jFfCBfUuqpO5CNQVdaNTyvlCoKa1MAWbTNdhZK2krRHmtgicPhaAcz/PcqRtx+wPseiPKJ4IhCkFNYsqqRm5jtC5ZeY57HPpbwqKE7P8R2V+ixlU1TpxU+I9HNmRExg/8/rCQC0TUfje8FCQQ2SUz69C+CmR/waAc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qjzwX7lU; arc=pass smtp.client-ip=209.85.210.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qjzwX7lU"
Received: by mail-ot1-f49.google.com with SMTP id 46e09a7af769-7d18f80b5c2so3521229a34.3
        for <syzbot@lists.linux.dev>; Mon, 23 Feb 2026 00:39:12 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771835952; cv=none;
        d=google.com; s=arc-20240605;
        b=UWIURFky+Y/MDW3+L0lRi4WYCb6d8xYW7kQ4+A2HlHLkh02okU+b3DzB7hh/yLA0zq
         LzyV4fJJrW4VNZG+9QR0FeBXXFAbgagV7UDLfcpDQSvqnysSBcbQk5enUI+b+LsCFJor
         c4LwmqE+4d84RUnmrryJ4NCVfrBjEhvxPqO1cJAYbzRbGduQRp0/G+4xXBmHfme01myu
         38g/rrUzEOo8qlaMtQAvmqZvaDHPlantVBvPXBqe86HAY2jY7DuaxCdDE9RwYkfQw4Bm
         YUw03IztMQqd+hh3xQqKoz9R2s3IHQe2ES00xItcH47Km0nTdSx0PaOr7WGxxIcGlnX0
         h3pA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=vrTaUfp4K/0kPmD/pHVwDU7gt8naLEalUWSAk+vuSFo=;
        fh=6Fi2Fq2TTgZXhBm2JfYjnBClvMaIIoWZBzAfZnTmk2M=;
        b=MlLENQYNn2wTnkQrHxSshUuEYI5VNdWOkcF4yvFXh4dNghwbdvkdvFGnAoDbkp0Msv
         YN+/EfpL5DfqxgNqWmtQOC9npVOXdg4hVO8zV86IiiSgdTyWWgp2S1CBsA7eMkLgUTIs
         aNsOT7N1gk4MI+xuSbbFmX1urcDI3Xo4C9uwHKnk6TxpfsoaFKLBHOucp3PSq7KHZz48
         13jV38MB+Ikx39uVV+KSUZECrQRNI9arXPa3m3qS0rPXtyDaqWOws2GD93G4OpFkCaPP
         qfOQZDb6XT9MafLTv04UvtgQ7LFdWFQtMyfqzQQ8hxIOqeiKzrl9ymsyepyb0xyokwkt
         SkYw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771835952; x=1772440752; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vrTaUfp4K/0kPmD/pHVwDU7gt8naLEalUWSAk+vuSFo=;
        b=qjzwX7lU7OizVgBGajcAa6pm7nFWJA8NkLlpaOcYXdXIiw57UF9usvOLuX6Cs6Setu
         BqqtAW8VpN1PFJqHGGuesZhzdf/iFNlKtRhNStnpEePxNfNxAgdCk7Pb89OtLDymx+Sa
         n1+hHbEUqBAWmRT/UAwX+TGkSlw+hoaI9fZbL4mMfRo2cdcwMY0+5ooJKds3YF7bURpc
         NG/UH08SLmBvzJj8oBdxQ6an1bXjynitNGDc61LYH1jt5TltsIGndAJI1cv0I5iNk4Wg
         cQjyxP1Xy4+vuamesvWAeY2ylOJz7GgZnlg7nZtiINx2iT8tNgm1DayPYZOTAMKFkL9q
         2H6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771835952; x=1772440752;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=vrTaUfp4K/0kPmD/pHVwDU7gt8naLEalUWSAk+vuSFo=;
        b=QKFxO26dSvHedjyBRuVCWl1YwelHW4COzAb9VRc1vstpmObmsA7+ogPi4ZSw8LUArY
         x253D7Qj6cr0gJaUJkuuQbYJr+lG0qafa1dTcCu2cGVJ256j7keQIE4mWbBZghV6Wmpb
         aKlutk7QLlsQoRWizjrdbmCKOnarNp9YruB9+4Wlzhb55o4oCZ2QgOoRm/UajHgKfUa2
         DfCk6ap7XG5wCvQe3I8vb/+cK2egZzW/Xa/IQqpqYUi3rGv4iKzdERTVl24y02sqg4Xk
         TIuvpofGkz9WjfYlMkR8IXNn8Y+HKj466TF2SzevQdbPb9K0g3f00cobJxR6RdNAy1HK
         QSKw==
X-Forwarded-Encrypted: i=1; AJvYcCUmQaQdxRhOqK16b6oas3kikA3vH/rZsmLCtULZKIGGfNCWeLE2AXLF6ENw2sS11OsW9ABHE/U=@lists.linux.dev
X-Gm-Message-State: AOJu0Yypl8YsK9hkoKp2BgX/SxPca3gXAI5B+7JMUs974+HCQ+vKk3zK
	TuXgZQob6nEGlRLmcNVlpvwnFJuGyB4gC1UBc66b9riXJf/kjAtAyATS1LjZjjWfkZ+f8qPTc/k
	k3r6rDzzGL0Ls5YcE0IkiBec3fhpbcXx9kPhz89rL
X-Gm-Gg: AZuq6aLibsGmn0zEbBGbgF69NN/JNmlr89CWbXbp48Hz3+4aKAEnpwp2s7YcBkUkkH1
	RUdaKJztF8LEAT29tuToPm7e5/nqC8wyYSGO8zLOTzJPH7xz+/W2W3KUqn8U/jATi8oKgElbn0Z
	JI2NqAs+/dlFwCzJ4H/7RtB42/Mje+RJDQP2hJGOoue6smtkWIcHTBiShIqZHCFk1NwWbIsgVAy
	S7Vozf4cdt461KG/s95IJaEAZ42say6GLpIj4AIJGwFdM8mZrA0dmYPCsO89UvicKLiYjLGCCAw
	ycGIUx4THkUx6dq+4uc/GorT9OU9EJjiaFhXcVuwe/9OvamjbwVxSKpPZgyuWGykIvzpKw==
X-Received: by 2002:a05:6808:50aa:b0:43d:365f:be86 with SMTP id
 5614622812f47-46446302130mr4167322b6e.33.1771835951406; Mon, 23 Feb 2026
 00:39:11 -0800 (PST)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <699be3db.050a0220.340abe.0d37.GAE@google.com>
In-Reply-To: <699be3db.050a0220.340abe.0d37.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Mon, 23 Feb 2026 09:38:59 +0100
X-Gm-Features: AaiRm50EbYNLPKsTKA7Zl0VL9jjUayWh91Pfi_gJW1AHAVUGdIm0vUAIRVDeoKM
Message-ID: <CANp29Y7u-Ggxwt3hm_kPngo_89JyYWPKkhxtZ955f-9avMttDg@mail.gmail.com>
Subject: Re: [moderation/CI] Re: Zero page->private when freeing pages
To: syzbot ci <syzbot+ci20e76ddb05181950@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Mon, Feb 23, 2026 at 6:21=E2=80=AFAM syzbot ci
<syzbot+ci20e76ddb05181950@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v1] Zero page->private when freeing pages
> https://lore.kernel.org/all/20260223032641.1859381-1-ziy@nvidia.com
> * [PATCH v1 01/11] relay: zero page->private when freeing pages
> * [PATCH v1 02/11] mm/slub: zero page->private when freeing pages
> * [PATCH v1 03/11] drm/ttm: zero page->private when freeing pages
> * [PATCH v1 04/11] blk-mq: zero page->private when freeing pages
> * [PATCH v1 05/11] watch_queue: zero page->private when freeing pages
> * [PATCH v1 06/11] binder: zero page->private when freeing pages
> * [PATCH v1 07/11] null_blk: zero page->private when freeing pages
> * [PATCH v1 08/11] percpu: zero page->private when freeing pages
> * [PATCH v1 09/11] erofs: zero page->private when freeing pages
> * [PATCH v1 10/11] mm/huge_memory: add page->private check back in __spli=
t_folio_to_order()
> * [PATCH v1 11/11] mm/page_alloc: check page->private upon page free
>
> and found the following issue:
> WARNING in __free_frozen_pages
>
> Full report is available here:
> https://ci.syzbot.org/series/10f470ac-46ac-4e38-902d-dc86ae743494
>
> ***
>
> WARNING in __free_frozen_pages
>
> tree:      mm-new
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/=
mm.git
> base:      a6fdc327de4678e54b5122441c970371014117b0
> arch:      amd64
> compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~e=
xp1~20251221153213.50), Debian LLD 21.1.8
> config:    https://ci.syzbot.org/builds/0586347c-8ef1-427f-8a9c-7f6c08b61=
6a9/config
>
> Bluetooth: RFCOMM ver 1.11
> Bluetooth: BNEP (Ethernet Emulation) ver 1.3
> Bluetooth: BNEP filters: protocol multicast
> Bluetooth: BNEP socket layer initialized
> Bluetooth: HIDP (Human Interface Emulation) ver 1.2
> Bluetooth: HIDP socket layer initialized
> NET: Registered PF_RXRPC protocol family
> Key type rxrpc registered
> Key type rxrpc_s registered
> NET: Registered PF_KCM protocol family
> lec:lane_module_init: lec.c: initialized
> mpoa:atm_mpoa_init: mpc.c: initialized
> l2tp_core: L2TP core driver, V2.0
> l2tp_ppp: PPPoL2TP kernel driver, V2.0
> l2tp_ip: L2TP IP encapsulation support (L2TPv3)
> l2tp_netlink: L2TP netlink interface
> l2tp_eth: L2TP ethernet pseudowire support (L2TPv3)
> l2tp_ip6: L2TP IP encapsulation support for IPv6 (L2TPv3)
> NET: Registered PF_PHONET protocol family
> 8021q: 802.1Q VLAN Support v1.8
> sctp: Hash tables configured (bind 32/56)
> NET: Registered PF_RDS protocol family
> Registered RDS/infiniband transport
> Registered RDS/tcp transport
> tipc: Activated (version 2.0.0)
> NET: Registered PF_TIPC protocol family
> tipc: Started in single node mode
> smc: adding smcd device lo without pnetid
> NET: Registered PF_SMC protocol family
> 9pnet: Installing 9P2000 support
> NET: Registered PF_CAIF protocol family
> NET: Registered PF_IEEE802154 protocol family
> Key type dns_resolver registered
> Key type ceph registered
> libceph: loaded (mon/osd proto 15/24)
> batman_adv: B.A.T.M.A.N. advanced 2025.5 (compatibility version 15) loade=
d
> openvswitch: Open vSwitch switching datapath
> NET: Registered PF_VSOCK protocol family
> mpls_gso: MPLS GSO support
> IPI shorthand broadcast: enabled
> sched_clock: Marking stable (19970046340, 93374727)->(20073238384, -98173=
17)
> registered taskstats version 1
> Loading compiled-in X.509 certificates
> Loaded X.509 cert 'Build time autogenerated kernel key: 98092a222e11368da=
223b039d625e21c3e2e069c'
> zswap: loaded using pool 842
> Demotion targets for Node 0: null
> Demotion targets for Node 1: null
> debug_vm_pgtable: [debug_vm_pgtable         ]: Validating architecture pa=
ge table helpers
> ------------[ cut here ]------------
> page->private
> WARNING: mm/page_alloc.c:1433 at __free_frozen_pages+0x78e/0xe10, CPU#0: =
swapper/0/1
> Modules linked in:
> CPU: 0 UID: 0 PID: 1 Comm: swapper/0 Not tainted syzkaller #0 PREEMPT(ful=
l)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:__free_frozen_pages+0x78e/0xe10
> Code: 5f 5d e9 05 1e 00 00 48 b8 00 00 00 00 00 fc ff df 0f b6 44 05 00 8=
4 c0 0f 85 d7 02 00 00 c7 03 ff ff ff ff e9 22 fc ff ff 90 <0f> 0b 90 e9 8d=
 fc ff ff bd 01 00 00 00 83 f8 05 0f 85 bb fe ff ff
> RSP: 0000:ffffc900000676e0 EFLAGS: 00010282
> RAX: 1ffffd4000bad935 RBX: ffffea0005d6c9a8 RCX: dffffc0000000000
> RDX: 0000000000000000 RSI: 0000000000000004 RDI: ffffea0005d6c9b4
> RBP: ffffea0005d6c9b8 R08: ffffea0005d6c9b7 R09: 1ffffd4000bad936
> R10: dffffc0000000000 R11: fffff94000bad937 R12: ffffea0005d6c980
> R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
> FS:  0000000000000000(0000) GS:ffff88818de64000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: ffff88823ffff000 CR3: 000000000e54c000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  destroy_args+0x15d/0x570
>  debug_vm_pgtable+0x3f8/0x410
>  do_one_initcall+0x250/0x8d0
>  do_initcall_level+0x104/0x190
>  do_initcalls+0x59/0xa0
>  kernel_init_freeable+0x2a6/0x3e0
>  kernel_init+0x1d/0x1d0
>  ret_from_fork+0x51e/0xb90
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
> The email will later be sent to:
> [airlied@gmail.com akpm@linux-foundation.org aliceryhl@google.com arve@an=
droid.com axboe@kernel.dk baohua@kernel.org baolin.wang@linux.alibaba.com b=
rauner@kernel.org christian.koenig@amd.com cl@gentwo.org cmllamas@google.co=
m dave@stgolabs.net david@kernel.org dennis@kernel.org dev.jain@arm.com dha=
vale@google.com dlemoal@kernel.org dri-devel@lists.freedesktop.org gregkh@l=
inuxfoundation.org guochunhai@vivo.com hannes@cmpxchg.org harry.yoo@oracle.=
com jackmanb@google.com jefflexu@linux.alibaba.com johannes.thumshirn@wdc.c=
om katrinzhou@tencent.com kernelxing@tencent.com kprateek.nayak@amd.com lan=
ce.yang@linux.dev liam.howlett@oracle.com lihongbo22@huawei.com linux-block=
@vger.kernel.org linux-erofs@lists.ozlabs.org linux-kernel@vger.kernel.org =
linux-mm@kvack.org lorenzo.stoakes@oracle.com maarten.lankhorst@linux.intel=
.com matthew.auld@intel.com matthew.brost@intel.com mhiramat@kernel.org mho=
cko@suse.com mripard@kernel.org npache@redhat.com ray.huang@amd.com rientje=
s@google.com roman.gushchin@linux.dev ryan.roberts@arm.com sandeen@redhat.c=
om simona@ffwll.ch surenb@google.com tj@kernel.org tkjos@android.com tzimme=
rmann@suse.de vbabka@kernel.org xiang@kernel.org zbestahu@gmail.com ziy@nvi=
dia.com]
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
-upstream-moderation/699be3db.050a0220.340abe.0d37.GAE%40google.com.
