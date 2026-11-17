Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.160.44
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794945888;
	b=M+YcM5PeKz20QeKFwBJZSnnyiKWSKdOIr9jrMGGO0XEmkwVfMWOBDhRayVKN7yk2N1T5
	 ByOd+8MUbo+WSXakDYNh4EJqQw6QOgNNAaVM+EgpEmYWaTiPWtn5+BLvdJ7gHG5rzgbWG
	 m42vsV1MtwqfmF2WZ+v8oiyXVeuvYq9hu6mMT+G3yGFFV+a6EHFbEssmbVU3b03q75MRF
	 Ch1kHsYHGH9+ZaIawp9Q3jzQQdBH+iSgYNZYLDR2eiCJ8Qburl/rn3DyK5CY0u6l+RT+N
	 fwM6ECn2hGHnO5kJwwJawpdHZ+Y+qHFb1mhRo/cfwx9YJs5vCp2sPEkrdxOVx36hdcg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794945888;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=XN5qPFUEezQ9W3KED/faAm6tfrx1yjLMk9dzmujGXuM=;
	b=d4C8wCNmduPuoRLkCuHWkvwxpPDm3n69DxCoeu6GQU6TsneGrEhFKCeih+kKTEndfFAc
	 5U13xM5etpCSfPMcEaKRw/B5ytASdfLmieVQHUciz8xkVsP9DE/VT87BB1n2sYK5C3apJ
	 WVpRocN4SFUXI+HAx6GRXy/pWUU1qbvEw1zwVaFQh3FroaCTFLQ5GG/OidIm/zeAt60lE
	 KJY9OtIGwcowypq08MSdgnY4sud+g2tZK2cfYz0YAj3Wk/f+Az4NoioZk9ud6vpMwOZDk
	 C6m+l6QsDaZBk/0kN+TSadr5QEQn5zr4pkk/A+Y8SJLlUKC4wNIxYQh8Rlpv9LSMckw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=K3MZLhGx;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.160.44
Received: from mail-oa1-f44.google.com (mail-oa1-f44.google.com [209.85.160.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7397B606A896
	for <syzbot@lists.linux.dev>; Tue, 17 Nov 2026 20:04:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7397B606A896
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=K3MZLhGx
Received: by mail-oa1-f44.google.com with SMTP id 586e51a60fabf-4adae3eb4d3so87910fac.1
        for <syzbot@lists.linux.dev>; Tue, 17 Nov 2026 12:04:48 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794945887; cv=none;
        d=google.com; s=arc-20260327;
        b=GQr4p5fSLheh/CYCcfAn5ZW1rVVRPNQutntOcAmiQQkMS8qN9FOPmgNY1RV5JXZoK0
         2ll/xtBRPGCS6GUGJ3SwwGF9xl4tc5pWJyhVSssu+Be9Zu+0ZE7C+SdhrSgL8WWzY2nS
         8OwikHDlTmKoA5kwUU5K6SrcnUpU0kZkoreB/45dJ0aDAYzI/MvOpdS5VRw9ZiFWNI+g
         Da8HuU/Xxi98l4CqV1XVk24skNVj/W1NCji77vr3JbQRhfj7SMYmmIXO2s+9zoOdk7jL
         MNzRoIO7lW8zloS1jQGUfg1te02PQlyw6ltrJwyJgArCyRs0nic+wFJ0xY+bsIJc2d1L
         Grug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=XN5qPFUEezQ9W3KED/faAm6tfrx1yjLMk9dzmujGXuM=;
        fh=zPg/kv/1vzuNPT9cewic4b3Iu8Ng9U/zZ6QP1qO+Z+w=;
        b=DMoM+7Gmp7xr8JcumJYHIvw/52eREyPJcLoQ28jDtkmEnHjvBkE+hP5f5Ewv6JB7ns
         4gio0WxM4va39HzPlrL79X++YHlc/lZPOykgVUQmN/wGv1pqtfW9UVOmffjLL3Q4yA/z
         zz4tyy3PcsHC+6LpVvXq2lLr+bWcVW494u5juqlOIuJNHT/fXdrcYH1erWZIVxHxF9uD
         yAaF7IU/7IEo4Ln0XRKjiW4iFGdRpgaehUHHFduRG886amn92pAT0O3UBE6wLT2Va61z
         ivbjyIDx8HhKPSsJffDzQZWFKj/v1asxkpSF9WBWRaATwN2eESz3waBA/qw2SHUH0UM3
         oY1A==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794945887; x=1795550687; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=XN5qPFUEezQ9W3KED/faAm6tfrx1yjLMk9dzmujGXuM=;
        b=K3MZLhGxHjoa+D2e2wEoXZS8AWm+45Kay9mlcRyapDD7Z0gMKRMd2NMD17M0DwJSIf
         iAf4E2dHg/8WDM/IRb8kYXF1QJ3zfW0MHF8jdOA5udIWU7VM0tgj5EJWa+vUHCrRzWvq
         uadVUeQ2FyPAnL+u6tOTPS8c11nNKFvnrzZOUkRvSzQtGVAPMs8VjMpZl6qePMtvFzhQ
         ANfgWXGgBcfoup4jYl9te5dgTu/2V7TR2mG5QTBSHniiaylyV7QsTC5RfQ5pKTw476rf
         XTGcyA8pqGvbk1naoR0L/1heAZx3ggdUY+vsb8dyWWuFbPVoJ6sA+WwYmsEjM84bP+lp
         24kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794945887; x=1795550687;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XN5qPFUEezQ9W3KED/faAm6tfrx1yjLMk9dzmujGXuM=;
        b=W9t4ibG0FXhrrTXLGQETI+DuPQ9rWHh6wTNWYtF2tEiH/hq3zv8q49ZHXGPk6LurRi
         ypYcoBixYRe9cCKWKuA2+6QKQQebV4DvJKZzoVoIoHPRHl1BPifYHHxSLZ3ReJVybRAY
         k6vWfaV3ZUkJsQjiIoA+puz729fDk8Vz4knW74j2SAoEv187Q/LDqsIKJzxlx/0Dd7YC
         r8fc0VY4I2lgNvW8OmhmvdHlv/zW3Gc9LjFyNzqiiTttfvrnY66LaxLlHx3XNkV9gUnZ
         myfGtPidPmWwXPK5XRYh9em7TlNJ49pefzigs8V4VB+zXzlq08qDmPzujSOYQ8gC9KcC
         fRZg==
X-Forwarded-Encrypted: i=1; AL+hErEPvX9BbXIiUcTQqFm4wJv1lKI5XFQxbStv/CXrXKi5zuM+Q8oSLC1z8Ip39vRWTDiOkYVcJk4=@lists.linux.dev
X-Gm-Message-State: APuU4Z+pQiedscsZ7AIz8romYrNC7ANeg2rMGu97la8U9wpBvWJ1tUGb
	p9EuchoQeHbyh9sqY/8MoYe8XfpXOpZhXPjWxtnaNqgRIHKoTgqqOwW08br0Kk1AGVbP9SdgrbB
	MJr4d1ULfanIaAhbs09XLmhLt9iRKvS/qL6yDR0x3E4LiJKtEwIbbKxPw
X-Gm-Gg: AYBFou23KP0HCAvsh/ps9GuX7RCeAxQ2k5QHG2QOBFmVwOscngAX9KKhkA7R31ss8yt
	PtZBKbcpl+dkd+ue5lWeGWen8PmtatwcTaO6WZizVgucP+WRburPtjjQYapvx+FAMJt/1shOcS/
	pDo+kl4ZpnGh1sv2fr96oLLCyZG4xqhuOgHmY16NgPl1XPUHEA6fPbnZMpa/4boSy6QixEGSaJj
	rrH2wUPzZSiQCNW+bgTDT+8QU/yoArpESdtQgDw0Ou+17JwtljsfH+0tSyc/p8+OvMjdQk9J2ss
	VgRCSdLjifstD1Rmab4nwYGrIDjHztBjDzK7iQ1m5cxH8KyORsiafHgZwdD2PasOYWBsumKoYJL
	qKzGx/CvXJy2+VZoK+lkn3Lrsdwo6gCGuYbwvFSXun2zoxbrs5ZFQ44mEATCGfJMuhmSR0M/0kF
	e4jcLy8PcjBytrB1fMnxILhDWV+QjAo2V7hDB8OyHm5fauXH7GCzSzQxI3QkUEO/dU+g7SI1JU+
	xGDorr+lIzOMLbF4z3hAM7Z7Yefyq4=
X-Received: by 2002:a05:6808:198d:b0:53a:ff9f:4d84 with SMTP id
 5614622812f47-5773c52fcb4mr1204437b6e.2.1794945886477; Tue, 17 Nov 2026
 12:04:46 -0800 (PST)
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Post: <mailto:syzbot@lists.linux.dev>
List-Help: <mailto:syzbot+help@lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
List-Owner: <mailto:syzbot+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <6afc918d.6a9a30c8.1f5211.000a.GAE@google.com>
In-Reply-To: <6afc918d.6a9a30c8.1f5211.000a.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Tue, 17 Nov 2026 21:04:34 +0100
X-Gm-Features: AclHuK_hikyPm08J53b093d1dLOIrGNCEAlJcjE7tlrGZNieUkOYQ49RHcKJNT0
Message-ID: <CANp29Y5tNYyTJ0brrUvzi9m6WcgBjJPhFVPM8gb00ceQ+QXn7Q@mail.gmail.com>
Subject: Re: [moderation/CI] Re: wifi: cfg80211/nl80211: add NAN offload support
To: syzbot ci <syzbot+ci7a408cd9ea0543d2@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Tue, Nov 17, 2026 at 6:40=E2=80=AFPM syzbot ci
<syzbot+ci7a408cd9ea0543d2@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v3] wifi: cfg80211/nl80211: add NAN offload support
> https://lore.kernel.org/all/20261113102228.1917973-1-shivani.baranwal@oss=
.qualcomm.com
> * [PATCH wireless-next v3 01/19] wifi: nl80211: reject NAN function add/d=
elete when Discovery Engine is in userspace
> * [PATCH wireless-next v3 02/19] wifi: nl80211/cfg80211: extend NAN funct=
ion and configuration for discovery offload
> * [PATCH wireless-next v3 03/19] wifi: nl80211/cfg80211: extend NAN match=
 indication for discovery offload
> * [PATCH wireless-next v3 04/19] wifi: nl80211/cfg80211: add NAN ranging =
FTM capability
> * [PATCH wireless-next v3 05/19] wifi: nl80211/cfg80211: advertise NAN ra=
nging support
> * [PATCH wireless-next v3 06/19] wifi: nl80211/cfg80211: add support for =
request-based NAN ranging
> * [PATCH wireless-next v3 07/19] wifi: nl80211/cfg80211: add support for =
discovery-based NAN ranging
> * [PATCH wireless-next v3 08/19] wifi: nl80211/cfg80211: add ranging resu=
lts to NAN match event
> * [PATCH wireless-next v3 09/19] wifi: nl80211: add NDP offload capabilit=
y advertisement
> * [PATCH wireless-next v3 10/19] wifi: nl80211/cfg80211: add support for =
NDP initiation in offload mode
> * [PATCH wireless-next v3 11/19] wifi: nl80211/cfg80211: add support for =
NDP response in offload mode
> * [PATCH wireless-next v3 12/19] wifi: nl80211/cfg80211: add support for =
NDP termination in offload mode
> * [PATCH wireless-next v3 13/19] wifi: nl80211/cfg80211: add support for =
NDP request indication
> * [PATCH wireless-next v3 14/19] wifi: nl80211/cfg80211: add support for =
NDP status indication
> * [PATCH wireless-next v3 15/19] wifi: nl80211/cfg80211: add support for =
NDP terminated indication
> * [PATCH wireless-next v3 16/19] wifi: nl80211/cfg80211: support updating=
 an offloaded NAN publish function
> * [PATCH wireless-next v3 17/19] wifi: nl80211/cfg80211: allow extra NAN =
attributes in offloaded functions
> * [PATCH wireless-next v3 18/19] wifi: nl80211/cfg80211: add NAN group ke=
y capabilities to NAN functions
> * [PATCH wireless-next v3 19/19] wifi: nl80211/cfg80211: select the 5 GHz=
 NAN channel for IC
>
> and found the following issue:
> WARNING in genl_register_family
>
> Full report is available here:
> https://ci.syzbot.org/series/51fe1835-2116-4216-afb5-89006d12c38e
>
> ***
>
> WARNING in genl_register_family
>
> tree:      linux-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/next/=
linux-next
> base:      5dbf2415ca9821a611d09308e3b29d2c37e7cd77
> arch:      amd64
> compiler:  Debian clang version 22.1.8 (1~deb13u4), Debian LLD 22.1.8
> config:    https://ci.syzbot.org/builds/88ad3d6b-ffda-4626-be13-f0ecdc12a=
bcf/config
>
> Bluetooth: L2CAP socket layer initialized
> Bluetooth: SCO socket layer initialized
> NET: Registered PF_ATMPVC protocol family
> NetLabel: Initializing
> NetLabel:  domain hash size =3D 128
> NetLabel:  protocols =3D UNLABELED CIPSOv4 CALIPSO
> NetLabel:  unlabeled traffic allowed by default
> nfc: nfc_init: NFC Core ver 0.1
> NET: Registered PF_NFC protocol family
> mctp: management component transport protocol core
> NET: Registered PF_MCTP protocol family
> PCI: Using ACPI for IRQ routing
> e820: register RAM buffer resource [mem 0x0009fc00-0x0009ffff]
> e820: register RAM buffer resource [mem 0x7ffdf000-0x7fffffff]
> pci 0000:00:01.0: vgaarb: setting as boot VGA device
> pci 0000:00:01.0: vgaarb: bridge control possible
> pci 0000:00:01.0: vgaarb: VGA device added: decodes=3Dio+mem,owns=3Dio+me=
m,locks=3Dnone
> vgaarb: loaded
> hpet: 3 channels of 0 reserved for per-cpu timers
> hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
> hpet0: 3 comparators, 64-bit 100.000000 MHz counter
> clocksource: Switched to clocksource kvm-clock
> VFS: Disk quotas dquot_6.6.0
> VFS: Dquot-cache hash table entries: 512 (4096 bytes)
> netfs: FS-Cache loaded
> CacheFiles: Loaded
> TOMOYO: 2.6.0
> Mandatory Access Control activated.
> AppArmor: AppArmor Filesystem Enabled
> acpi PNP0C01:00: Reserved [mem 0xb0000000-0xbfffffff]
> pnp: PnP ACPI init
> pnp: PnP ACPI: found 4 devices
> clocksource: acpi_pm: mask: 0xffffff max_cycles: 0xffffff, max_idle_ns: 2=
085701024 ns
> NET: Registered PF_INET protocol family
> IP idents hash table entries: 131072 (order: 8, 1048576 bytes, vmalloc)
> tcp_listen_portaddr_hash hash table entries: 4096 (order: 7, 294912 bytes=
, vmalloc)
> Table-perturb hash table entries: 65536 (order: 6, 262144 bytes, vmalloc)
> TCP established hash table entries: 65536 (order: 7, 524288 bytes, vmallo=
c)
> TCP bind hash table entries: 65536 (order: 12, 9437184 bytes, vmalloc hug=
epage)
> TCP: Hash tables configured (established 65536 bind 65536)
> MPTCP token hash table entries: 8192 (order: 8, 720896 bytes, vmalloc)
> UDP hash table entries: 4096 (order: 8, 1048576 bytes, vmalloc)
> NET: Registered PF_UNIX/PF_LOCAL protocol family
> RPC: Registered named UNIX socket transport module.
> RPC: Registered udp transport module.
> RPC: Registered tcp transport module.
> RPC: Registered tcp-with-tls transport module.
> RPC: Registered tcp NFSv4.1 backchannel transport module.
> ------------[ cut here ]------------
> i.cmd >=3D family->resv_start_op && (i.doit.validate || i.dumpit.validate=
)
> WARNING: net/netlink/genetlink.c:581 at genl_register_family+0xc9e/0x17d0=
, CPU#1: swapper/0/1
> Modules linked in:
> CPU: 1 UID: 0 PID: 1 Comm: swapper/0 Not tainted syzkaller #0 PREEMPT(ful=
l)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:genl_register_family+0xc9e/0x17d0
> Code: de e8 a6 98 c8 f7 83 fb 01 0f 85 26 0b 00 00 e8 18 95 c8 f7 b0 01 8=
9 44 24 08 4c 8b 7c 24 18 e9 f3 02 00 00 e8 03 95 c8 f7 90 <0f> 0b 90 e9 82=
 fa ff ff e8 f5 94 c8 f7 4c 8b 7c 24 20 e9 b9 f6 ff
> RSP: 0000:ffffc90000067740 EFLAGS: 00010293
> RAX: ffffffff89ffd11d RBX: 0000000000000003 RCX: ffff888102aa5a00
> RDX: 0000000000000000 RSI: 0000000000000003 RDI: 0000000000000000
> RBP: ffffc90000067948 R08: ffffc90000067827 R09: 0000000000000000
> R10: ffffc90000067800 R11: fffff5200000cf05 R12: ffffc90000067860
> R13: ffffc900000677d0 R14: 00000000000000b2 R15: 1ffffffff1cf0d83
> FS:  0000000000000000(0000) GS:ffff8882a7c57000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000000000000 CR3: 000000000fb48000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  nl80211_init+0x11/0x50
>  cfg80211_init+0x3c/0xe0
>  do_one_initcall+0x250/0x870
>  do_initcall_level+0x10a/0x1a0
>  do_initcalls+0x59/0xa0
>  kernel_init_freeable+0x29d/0x3e0
>  kernel_init+0x22/0x1d0
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
> The email will later be sent to:
> [johannes@sipsolutions.net kavita.kavita@oss.qualcomm.com linux-wireless@=
vger.kernel.org shivani.baranwal@oss.qualcomm.com vamsin@qti.qualcomm.com v=
ganneva@qti.qualcomm.com]
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
-upstream-moderation/6afc918d.6a9a30c8.1f5211.000a.GAE%40google.com.
