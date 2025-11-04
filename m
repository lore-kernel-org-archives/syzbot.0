Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5602E2FB63A
	for <syzbot@lists.linux.dev>; Tue,  4 Nov 2025 14:21:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762266080; cv=none; b=AzPiWVJg9fhyJbNKNqsioh4iRQjh8otsgLXJv9GNajerrUSTxVj2IyqmkV/bGSHz0rsY5BUpxuAMy+WDHtuXQ6mMf2qPhsUKHLj/9CVmCA7r6X1OaR99aAaS/Ky5vvSNwu/gGD50/Y1m6RoaCu1880inOsiyGACQL8Rr3NEevGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762266080; c=relaxed/simple;
	bh=pXNL1ra/v4P5QFRKGWykfnZ6RCfXHT+lYO6aPNye+RU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=sai4WV5exe6Zjlx2A7AdcYudR46ApfS8lqpTR9Zjo6WGnwcksu/2KZ8Z5dJBbjKAUy3WEe1uUBtPOaY70++RjdKHPFEN8Im7tXbV2wkNloRQzFBKrWpNcRvdCpF2f+zYwz4cVjPobzQU+axyHYNO+RdyJoJYlZyWSaExIe26GDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=khlnc/2j; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="khlnc/2j"
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-426f1574a14so3414552f8f.3
        for <syzbot@lists.linux.dev>; Tue, 04 Nov 2025 06:21:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762266076; x=1762870876; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EjFwCBW3R7ueNncqEL8HhGVA4uSuS118CPrgy1gPaKU=;
        b=khlnc/2jvygAyM+wW0X9PavRumZ0yC/XK8IwG0zkCC8qd5Ffm15/9XBsanSZIT3342
         minA5w9nF64tCp3aqcHM1UUI7bi51Ifumf9zbkUIm+GQMsGL+w1wjxFUKW3DiY2RH8rm
         emK14rO/vtrRM+gSA/1Hv/vLBseaiW6TJx67hUMzAF/Qq0i4kMbRVfuro6/AerdcMInN
         mGNpp3yAk6bHPUeNQyzxZr75/QUSRC43elPSHGAXHB5OfyYomrBnbv6vKz2XVrX1Uyxf
         CuA0tuuVVCop9GcRk2LdjDhHHYQZIXtujHI+m/M13hKEaUlCKXFrRTqCpc01+KMT53uh
         c1ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762266076; x=1762870876;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EjFwCBW3R7ueNncqEL8HhGVA4uSuS118CPrgy1gPaKU=;
        b=uBoPonhR7oF6tC1roPw5OvVOEt8Ru6DvQLuhzyz8JGe6x9i28DKQIuQ3PIbNSH11RN
         VKVWeUuFwRlCGu6fPy+t4g+f/EPn5cqYacT9xfBtr9UIpLltW146shdix05a1RFGPVKa
         /5ghANF7hTRYPzRN7p0hgaRPQHyI829CFc3qNhDrVbzZN+ll7jGTyG877dyx2a4ayGqz
         rgEnKTZ1Zxt/Dg8odUL+4yWIjzto8v9dVYBnWAS/6qdf2e6FmT+odd1LZzxcFLNYnIKB
         HSx6/SZFaxsWMTFSP523vZ1Tfp9X3L7vdExLCESZWqAi/vndob9n1NrBpIA5rQXzDsaC
         GNNA==
X-Forwarded-Encrypted: i=1; AJvYcCUNI+4WhFV8RoX7KyyTsFnDBjOt637f2NPGwQczq50cbNF0V7O3O3g+ynNkCFJonqC5vZr4AJc=@lists.linux.dev
X-Gm-Message-State: AOJu0YxijWZF46QwVAqbL0cTwcnCwUEPC83X6y3eIFY2r49EF2R0YbkA
	z2Z6wSKGIaHKsk0GZlW94HWiNF4AVcBegfyhPsxIFgIJJPMqtNvHyWfjeFB2o1ShDt4IUSsZfTE
	3k+c55d/F7+KwK3DF5EjAs2MCambgi43IkvbtQ/dPPGg3blAeWsvf2v6M
X-Gm-Gg: ASbGncvZnmn7CtkC+i9lyYvNo3ojvNtaoJw6DlzzDSwubuRncxmeooKQAaa5dMRltkz
	5ChEk8t35XqBGPWJzJvdP6Xq7Hk//z3Qnn3JcfwXegqwVeJoDeJJXVXp1DfH1PFzTU865KWCcK0
	WlVq0COfsGm7sYiWk3FmSd0+jCmo6S8z9V2TydVf7Q87OBvMFmlVErYhvXMhKtzvSfV2oig8jSh
	4Zw4jVoHK0DPS5fF/JlwGX6dWXNc/NNfZl7y/ZHqc4lfWOpkUF1lEQrKVIZ1PWL+aW96ZG42Qe6
	fUj4KqfhPGH9WEyDnLGXSdErlidN5SzGwYRfSLAqdKvK0bhjb9fBVGm9Yw==
X-Google-Smtp-Source: AGHT+IGIQRuRw8SsECh8F0h2i5ksOC48olX3JCUvLBSw65mKfxr9cN4H1+PWZpnKE9lEgRn6VwmXiJu1pDZHh1Dfs+Y=
X-Received: by 2002:a05:6000:2306:b0:427:652:b7ff with SMTP id
 ffacd0b85a97d-429bd6ade1fmr14682110f8f.60.1762266076381; Tue, 04 Nov 2025
 06:21:16 -0800 (PST)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <690a0b55.050a0220.98a6.00ae.GAE@google.com>
In-Reply-To: <690a0b55.050a0220.98a6.00ae.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Tue, 4 Nov 2025 15:21:02 +0100
X-Gm-Features: AWmQ_bkJReekDeAIpvrIbCFu_ZsgT8GFHtgezdXDsnKaugwBiwGBO4lyIs5x8qM
Message-ID: <CANp29Y6mNZ1xBq-XWDVx59+P5T-BmaMLJDHBPxNZW9JF72dRpw@mail.gmail.com>
Subject: Re: [moderation/CI] Re: net: gro_cells: Provide lockdep class for
 gro_cell's bh_lock
To: syzbot ci <syzbot+cidb71cd333b549541@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Tue, Nov 4, 2025 at 3:19=E2=80=AFPM syzbot ci
<syzbot+cidb71cd333b549541@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v1] net: gro_cells: Provide lockdep class for gro_cell's bh_lock
> https://lore.kernel.org/all/20251104111201.5eBxkOKb@linutronix.de
> * [PATCH net] net: gro_cells: Provide lockdep class for gro_cell's bh_loc=
k
>
> and found the following issue:
> BUG: key ADDR has not been registered!
>
> Full report is available here:
> https://ci.syzbot.org/series/487d8c1b-77a3-45c6-af6d-8195d5c60ad7
>
> ***
>
> BUG: key ADDR has not been registered!
>
> tree:      net
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netde=
v/net.git
> base:      3d18a84eddde169d6dbf3c72cc5358b988c347d0
> arch:      amd64
> compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~e=
xp1~20250708183702.136), Debian LLD 20.1.8
> config:    https://ci.syzbot.org/builds/45da8225-040a-4fda-9352-295e63030=
683/config
>
> gb_gbphy: registered new driver usb
> asus_wmi: ASUS WMI generic driver loaded
> gnss: GNSS driver registered with major 494
> usbcore: registered new interface driver gnss-usb
> usbcore: registered new interface driver hdm_usb
> usbcore: registered new interface driver snd-usb-audio
> usbcore: registered new interface driver snd-ua101
> usbcore: registered new interface driver snd-usb-usx2y
> usbcore: registered new interface driver snd-usb-us122l
> usbcore: registered new interface driver snd-usb-caiaq
> usbcore: registered new interface driver snd-usb-6fire
> usbcore: registered new interface driver snd-usb-hiface
> usbcore: registered new interface driver snd-bcd2000
> usbcore: registered new interface driver snd_usb_pod
> usbcore: registered new interface driver snd_usb_podhd
> usbcore: registered new interface driver snd_usb_toneport
> usbcore: registered new interface driver snd_usb_variax
> drop_monitor: Initializing network drop monitor service
> NET: Registered PF_LLC protocol family
> GACT probability on
> Mirror/redirect action on
> Simple TC action Loaded
> netem: version 1.3
> u32 classifier
>     Performance counters on
>     input device check on
>     Actions configured
> nf_conntrack_irc: failed to register helpers
> nf_conntrack_sane: failed to register helpers
> nf_conntrack_sip: failed to register helpers
> xt_time: kernel timezone is -0000
> IPVS: Registered protocols (TCP, UDP, SCTP, AH, ESP)
> IPVS: Connection hash table configured (size=3D4096, memory=3D32Kbytes)
> IPVS: ipvs loaded.
> IPVS: [rr] scheduler registered.
> IPVS: [wrr] scheduler registered.
> IPVS: [lc] scheduler registered.
> IPVS: [wlc] scheduler registered.
> IPVS: [fo] scheduler registered.
> IPVS: [ovf] scheduler registered.
> IPVS: [lblc] scheduler registered.
> IPVS: [lblcr] scheduler registered.
> IPVS: [dh] scheduler registered.
> IPVS: [sh] scheduler registered.
> IPVS: [mh] scheduler registered.
> IPVS: [sed] scheduler registered.
> IPVS: [nq] scheduler registered.
> IPVS: [twos] scheduler registered.
> IPVS: [sip] pe registered.
> ipip: IPv4 and MPLS over IPv4 tunneling driver
> BUG: key ffff88816c216e68 has not been registered!
> ------------[ cut here ]------------
> DEBUG_LOCKS_WARN_ON(1)
> WARNING: CPU: 0 PID: 1 at kernel/locking/lockdep.c:4976 lockdep_init_map_=
type+0x241/0x380
> Modules linked in:
> CPU: 0 UID: 0 PID: 1 Comm: swapper/0 Not tainted syzkaller #0 PREEMPT(ful=
l)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:lockdep_init_map_type+0x241/0x380
> Code: 75 cd 90 e8 21 dc e8 02 85 c0 74 22 83 3d 2a c9 df 0d 00 75 19 90 4=
8 c7 c7 36 2e 8f 8d 48 c7 c6 93 c8 7e 8d e8 00 dd e5 ff 90 <0f> 0b 90 90 65=
 48 8b 05 93 fc d0 10 48 3b 44 24 08 0f 85 14 01 00
> RSP: 0000:ffffc900000672a8 EFLAGS: 00010246
> RAX: 40a598123e634300 RBX: ffffe8fee481dde8 RCX: ffff888102688000
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000002
> RBP: 0000000000000000 R08: 0000000000000003 R09: 0000000000000004
> R10: dffffc0000000000 R11: fffffbfff1bba650 R12: 0000000000000000
> R13: 0000000000000000 R14: ffff88816c216e68 R15: ffffe8fee481dde8
> FS:  0000000000000000(0000) GS:ffff88818eb3c000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: ffff88823ffff000 CR3: 000000000dd38000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  gro_cells_init+0x26c/0x380
>  ip_tunnel_init+0xc9/0x650
>  register_netdevice+0x6bf/0x1ae0
>  __ip_tunnel_create+0x3e7/0x560
>  ip_tunnel_init_net+0x2ba/0x800
>  ops_init+0x35c/0x5c0
>  register_pernet_operations+0x336/0x800
>  register_pernet_device+0x2a/0x80
>  ipip_init+0x1d/0xd0
>  do_one_initcall+0x236/0x820
>  do_initcall_level+0x104/0x190
>  do_initcalls+0x59/0xa0
>  kernel_init_freeable+0x334/0x4b0
>  kernel_init+0x1d/0x1d0
>  ret_from_fork+0x4bc/0x870
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
> [bigeasy@linutronix.de clrkwllms@kernel.org davem@davemloft.net edumazet@=
google.com gal@nvidia.com horms@kernel.org kuba@kernel.org linux-rt-devel@l=
ists.linux.dev netdev@vger.kernel.org pabeni@redhat.com rostedt@goodmis.org=
]
>
> If the report looks fine to you, reply with:
> #syz upstream
>
> --
> You received this message because you are subscribed to the Google Groups=
 "syzkaller-upstream-moderation" group.
> To unsubscribe from this group and stop receiving emails from it, send an=
 email to syzkaller-upstream-moderation+unsubscribe@googlegroups.com.
> To view this discussion visit https://groups.google.com/d/msgid/syzkaller=
-upstream-moderation/690a0b55.050a0220.98a6.00ae.GAE%40google.com.
