Received: from mail-oo1-f50.google.com (mail-oo1-f50.google.com [209.85.161.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CB402D3A7B
	for <syzbot@lists.linux.dev>; Tue, 19 May 2026 06:56:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.161.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779173818; cv=pass; b=MlDHXtoKZJlgUv4xO6M+IMcFJge1YJ/5dGKV1dZWgwGlPgo9q/QhOfHXPzUgorF7TNnGlpNpT8ffkHeHjrglGOFRnKIoWvvo06f4u8SZL7QBjq6Q3s8bo4wLhGhL3DAaQCdKeTA7pfdzsdxCgtqInh9uMI4EcIpFvMZXOY6czGE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779173818; c=relaxed/simple;
	bh=tCETP25Sx8Z3xZ5uV9ViH1JrE5lS4qlHkZVjD0JkpAY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VnnintS8hdYHh5XDbPe4aHE0oGtrnYZCOcb4GelZrkD3bJgTDKYbb+frvq/kngaRz0isKM4Px5juwXGxdyjQ/C13Fp7IEN7BqU2cntiiBzMTkaAFx5tAoLwa9OHuip0iLgw6Yh2gFcud6L1uXe0R5PrOHqV8EAcHn7SnhpfSIA4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=nLTNwG84; arc=pass smtp.client-ip=209.85.161.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="nLTNwG84"
Received: by mail-oo1-f50.google.com with SMTP id 006d021491bc7-6948da50eb5so1653462eaf.1
        for <syzbot@lists.linux.dev>; Mon, 18 May 2026 23:56:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779173815; cv=none;
        d=google.com; s=arc-20240605;
        b=XriHeHC6uwm3n3ydDmqXp4n1ZEhZVJr0KOgUJ/E6k1AlHSbQ72PD+sjO+tUgIhlNKK
         zf2wLJ8YN53JxsqyZ5Iis18aifQphR/gofqlmaBqBffoIpudquQ2pJi03kdByxJvxij5
         8bOugXwg1GhmdQiju5pDimbTsfQ+Jiw15ZvsMFxa27GCS+Ae/SufcH/qL/4pSFS9Nrg7
         17Om/kf1xn+IVLG6eUUOM5E/cF1Od5jcfHZVaz8VMlfnlrG3xpZrfD1I5BNMaguY0Whv
         n8yG8eA3/BBcqqdwxvincrbAIjzq6NoXUityuuy20ltKKVvvpF73A3Q6zPYVOUI9oiUp
         xJIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ReLAzlKo5Osi1O6o76VPjwlhbGVT2f87GJf5s8jOZo0=;
        fh=Sqv2DxefctaEI6TVLhvPEtkNqHxLKZrEvxdomEMm6T4=;
        b=fbUX7gvq8aKZqV5DVjdgdPLrFGt3wCbZGN+V/wWvA2JStdTvn553i2zS+DlSjzolTC
         utJWO3s16OjyZIeDNHZiTp9OEZIgM2LGoOs3CD7j3NMLGS6zPsDzN1ydaHRWyfmbfBd6
         cwtQ18tDYqRI1EXJ3ldWiiR+fyysdTM4jVdTUlxIOkQ9956M2drSV1KyIVppF6a/scuA
         GF8qcKKn62ro/WWXgYN3s+G5c/3BgCQTFWXD3dCUcULzaK5TG4Pil1XaBMTDdXEjGIMS
         EwTCosacTc41cshWhDO8KV/0k9k0/XvU13Y+iRbDJCNWB6mFGBum4hGkjbz8xseJ4A9j
         lVmg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779173815; x=1779778615; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ReLAzlKo5Osi1O6o76VPjwlhbGVT2f87GJf5s8jOZo0=;
        b=nLTNwG84GD9PP21DAHGnQrI8hZg2gvu2Yp0AqeTWRfWNONBYtN+tykKzagKJjKYDdv
         yIhczeev+8qorHq6TjEImejkbq5cwsNC/EiRbw2qukV0QMgKYyKF/+Oo2ZARuyKJfYsK
         OKWI9BvObBZWWjH9mSnKAsCn1sNpJF4YCmHeenXiaCiMKTCdLrMQ5LcM0E03roEsfIJN
         9YFi6m6+Ye6QuIs2aay47rksecE+BxiM4ePEWPGt/lIkeCwf3QBkinZKREq+HKZogJts
         VesOjoRrm1/xqELRWjNB7sQy/f5AzBElLG/ndjdwLOFAWAEnNjGG0uYXqlNMIXn6WgBN
         O56A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779173815; x=1779778615;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ReLAzlKo5Osi1O6o76VPjwlhbGVT2f87GJf5s8jOZo0=;
        b=KMsjPRD2U5a75V6fbhp7L8A7okbgA+HiKv9NLDdtNauA1x+SJxWWHvnPV7ltGgMsHO
         8eG4K2uMmYHTNHWwUkYmPD5PTajA355+1MTCC0vM+IcSGI3d14vEevFwm+wlRP0EY52I
         PjUXA6x6dD32UIcRxjZ7wzDgY+KWwHIsKv5dfzMfJcWpduAGBFW4PdU5FXR9aEuwPid9
         95n4IM+FhkHIlg7YMisNRUEh8jtTp2bS3XRFPoF9zAz14qn3qS2AK5IfUTTlVDTBUv5M
         YoYqCc845qusqVL38kmalJviilm2IWbt7AZIhp9PDIPv7XHoVdupfKVGC4gdO/Uawu/g
         nAGg==
X-Forwarded-Encrypted: i=1; AFNElJ9nIsnqyDknb8eR36txLO+Z691C2CWm6eBk5v0NsbrS2fPXJ0moIAKpT2XP5snAgv5LmbGd05Y=@lists.linux.dev
X-Gm-Message-State: AOJu0Ywh/4sZIIscQzYPSni3h8WhcehLcAWCpnR6KuQGPQFzCfFVXET9
	k4THvhb5+Q2l6VASSYfHsw4UwhGqBH/v3xDwKSCN4K/bNzuTbPo8fzQMgDsPIJWk7dd+fTZt0dR
	F65fg9PF0oSA2JtfWWIhQ69zESuQGw9+xxzTvkpWt
X-Gm-Gg: Acq92OGZKr2madNnC8be5qprv302+ntPBql3RS9TAWGxkBkTlzXpTlRzIolP8EQK/s6
	ZM964P4wl1/HBrRqn1wL27OPnosk7unFSC0X82/j3Wy4Xu9MZ6IBvMWllWLPN38cKB8aL/W0bSX
	nxZ8OJHyyrBu70M45sQR85BjIXj839K2MhPN0Olmxf094XO3bK5vMaNOy2Pg0XFisqxl5f99/Op
	zZDsk67K0yESYjpizn85YMvEAOsoBzIWXaJ6+AQ1OZGLqUy5pKjsEV76Rfjrg12gTJSUWUkrync
	6fJjVTD7Hgpq3JM6MlQWZZ+av5Z+nV8StK8QAU2tvt8kgb/H6YSOcaTlsmH3B8Uo5qdDTuh0usI
	X1C8/
X-Received: by 2002:a4a:d348:0:b0:69b:8e24:8523 with SMTP id
 006d021491bc7-69b8e2487a8mr8598392eaf.30.1779173815043; Mon, 18 May 2026
 23:56:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <6a0bd843.170a0220.39a587.0002.GAE@google.com>
In-Reply-To: <6a0bd843.170a0220.39a587.0002.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Tue, 19 May 2026 08:56:43 +0200
X-Gm-Features: AVHnY4JWTsKhgYWirTqUxv-vVRCYBb2W95xPmhNuC7O138ZIz0a4AJoREtXJLaU
Message-ID: <CANp29Y4tw-jSQGBE4Xp0RetCq41yiw3SPn8B=3yvGz=+g6okfQ@mail.gmail.com>
Subject: Re: [moderation/CI] Re: Introduce Per-CPU Work helpers (was QPW)
To: syzbot ci <syzbot+ci19dafd1fc4b94b9e@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Tue, May 19, 2026 at 5:25=E2=80=AFAM syzbot ci
<syzbot+ci19dafd1fc4b94b9e@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v4] Introduce Per-CPU Work helpers (was QPW)
> https://lore.kernel.org/all/20260519012754.240804-1-leobras.c@gmail.com
> * [PATCH v4 1/4] Introducing pw_lock() and per-cpu queue & flush work
> * [PATCH v4 2/4] mm/swap: move bh draining into a separate workqueue
> * [PATCH v4 3/4] swap: apply new pw_queue_on() interface
> * [PATCH v4 4/4] slub: apply new pw_queue_on() interface
>
> and found the following issue:
> WARNING in __pcs_replace_empty_main
>
> Full report is available here:
> https://ci.syzbot.org/series/804f81bd-77b4-490e-bd57-6345ad2aa923
>
> ***
>
> WARNING in __pcs_replace_empty_main
>
> tree:      drm-next
> URL:       https://gitlab.freedesktop.org/drm/kernel.git
> base:      5200f5f493f79f14bbdc349e402a40dfb32f23c8
> arch:      amd64
> compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~e=
xp1~20251221153213.50), Debian LLD 21.1.8
> config:    https://ci.syzbot.org/builds/3ea80958-13bd-49da-9c64-6deb78811=
3f8/config
>
> clocksource: refined-jiffies: mask: 0xffffffff max_cycles: 0xffffffff, ma=
x_idle_ns: 19112604462750000 ns
> Zone ranges:
>   DMA      [mem 0x0000000000001000-0x0000000000ffffff]
>   DMA32    [mem 0x0000000001000000-0x00000000ffffffff]
>   Normal   [mem 0x0000000100000000-0x000000023fffffff]
>   Device   empty
> Movable zone start for each node
> Early memory node ranges
>   node   0: [mem 0x0000000000001000-0x000000000009efff]
>   node   0: [mem 0x0000000000100000-0x000000007ffdefff]
>   node   0: [mem 0x0000000100000000-0x0000000160000fff]
>   node   1: [mem 0x0000000160001000-0x000000023fffffff]
> Initmem setup node 0 [mem 0x0000000000001000-0x0000000160000fff]
> Initmem setup node 1 [mem 0x0000000160001000-0x000000023fffffff]
> On node 0, zone DMA: 1 pages in unavailable ranges
> On node 0, zone DMA: 97 pages in unavailable ranges
> On node 0, zone Normal: 33 pages in unavailable ranges
> setup_percpu: NR_CPUS:8 nr_cpumask_bits:2 nr_cpu_ids:2 nr_node_ids:2
> percpu: Embedded 71 pages/cpu s250632 r8192 d31992 u2097152
> kvm-guest: PV spinlocks disabled, no host support
> Kernel command line: earlyprintk=3Dserial net.ifnames=3D0 sysctl.kernel.h=
ung_task_all_cpu_backtrace=3D1 ima_policy=3Dtcb nf-conntrack-ftp.ports=3D20=
000 nf-conntrack-tftp.ports=3D20000 nf-conntrack-sip.ports=3D20000 nf-connt=
rack-irc.ports=3D20000 nf-conntrack-sane.ports=3D20000 binder.debug_mask=3D=
0 rcupdate.rcu_expedited=3D1 rcupdate.rcu_cpu_stall_cputime=3D1 no_hash_poi=
nters page_owner=3Don sysctl.vm.nr_hugepages=3D4 sysctl.vm.nr_overcommit_hu=
gepages=3D4 secretmem.enable=3D1 sysctl.max_rcu_stall_to_panic=3D1 msr.allo=
w_writes=3Doff coredump_filter=3D0xffff root=3D/dev/sda console=3DttyS0 vsy=
scall=3Dnative numa=3Dfake=3D2 kvm-intel.nested=3D1 spec_store_bypass_disab=
le=3Dprctl nopcid vivid.n_devs=3D64 vivid.multiplanar=3D1,2,1,2,1,2,1,2,1,2=
,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,=
2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2 netrom.nr_ndevs=3D32 rose.rose_ndevs=3D32=
 smp.csd_lock_timeout=3D100000 watchdog_thresh=3D55 workqueue.watchdog_thre=
sh=3D140 sysctl.net.core.netdev_unregister_timeout_secs=3D140 dummy_hcd.num=
=3D32 max_loop=3D32 nbds_max=3D32 \
> Kernel command line: comedi.comedi_num_legacy_minors=3D4 panic_on_warn=3D=
1 root=3D/dev/sda console=3DttyS0 root=3D/dev/sda1
> Unknown kernel command line parameters "nbds_max=3D32", will be passed to=
 user space.
> printk: log buffer data + meta data: 262144 + 917504 =3D 1179648 bytes
> software IO TLB: area num 2.
> Fallback order for Node 0: 0 1
> Fallback order for Node 1: 1 0
> Built 2 zonelists, mobility grouping on.  Total pages: 1834877
> Policy zone: Normal
> mem auto-init: stack:all(zero), heap alloc:on, heap free:off
> stackdepot: allocating hash table via alloc_large_system_hash
> stackdepot hash table entries: 1048576 (order: 12, 16777216 bytes, linear=
)
> stackdepot: allocating space for 8192 stack pools via memblock
> **********************************************************
> **   NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE   **
> **                                                      **
> ** This system shows unhashed kernel memory addresses   **
> ** via the console, logs, and other interfaces. This    **
> ** might reduce the security of your system.            **
> **                                                      **
> ** If you see this message and you are not debugging    **
> ** the kernel, report this immediately to your system   **
> ** administrator!                                       **
> **                                                      **
> ** Use hash_pointers=3Dalways to force this mode off      **
> **                                                      **
> **   NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE   **
> **********************************************************
> ------------[ cut here ]------------
> debug_locks && !(lock_is_held(&(&s->cpu_sheaves->lock)->dep_map) !=3D 0)
> WARNING: mm/slub.c:4601 at __pcs_replace_empty_main+0x51b/0x6e0, CPU#0: s=
wapper/0
> Modules linked in:
> CPU: 0 UID: 0 PID: 0 Comm: swapper Not tainted syzkaller #0 PREEMPT(undef=
)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:__pcs_replace_empty_main+0x51b/0x6e0
> Code: 48 85 f6 74 15 4c 89 ff 48 89 c6 e8 af 5e ff ff 4d 89 74 24 38 e9 3=
6 fc ff ff 49 89 44 24 40 4d 89 74 24 38 e9 27 fc ff ff 90 <0f> 0b 90 83 7b=
 2c 00 0f 85 23 fb ff ff 48 8b 1b e8 20 cd 82 09 41
> RSP: 0000:ffffffff8e607d58 EFLAGS: 00010046
> RAX: 0000000000000000 RBX: ffffffff91bb8398 RCX: 0000000000000002
> RDX: 0000000000000cc0 RSI: ffffffff8e21ec94 RDI: ffffffff8c28b160
> RBP: 0000000000000cc0 R08: 0000000000005e00 R09: 00000000477ac845
> R10: 0000000047d13f7f R11: 000000002fa01ecd R12: ffff88812103f308
> R13: 0000000000000000 R14: ffffffff91bb8398 R15: 0000000000000000
> FS:  0000000000000000(0000) GS:ffff88818dc8a000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: ffff88823ffff000 CR3: 000000000e74a000 CR4: 00000000000000b0
> Call Trace:
>  <TASK>
>  kmem_cache_alloc_node_noprof+0x441/0x690
>  do_kmem_cache_create+0x172/0x620
>  create_boot_cache+0xbf/0x120
>  kmem_cache_init+0x11a/0x1e0
>  mm_core_init+0x7e/0xb0
>  start_kernel+0x15a/0x3e0
>  x86_64_start_reservations+0x24/0x30
>  x86_64_start_kernel+0x143/0x1c0
>  common_startup_64+0x13e/0x147
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
> [akpm@linux-foundation.org axelrasmussen@google.com baohua@kernel.org bhe=
@redhat.com boqun@kernel.org bp@alien8.de brauner@kernel.org chrisl@kernel.=
org cl@gentwo.org corbet@lwn.net coxu@redhat.com dapeng1.mi@linux.intel.com=
 david@kernel.org dianders@chromium.org ebiggers@kernel.org elver@google.co=
m feng.tang@linux.alibaba.com frederic@kernel.org gary@garyguo.net hannes@c=
mpxchg.org hao.li@linux.dev harry@kernel.org jackmanb@google.com jannh@goog=
le.com kasong@tencent.com kees@kernel.org kuba@kernel.org leobras.c@gmail.c=
om liam@infradead.org linux-doc@vger.kernel.org linux-kernel@vger.kernel.or=
g linux-mm@kvack.org linux-rt-devel@lists.linux.dev lirongqing@baidu.com lj=
s@kernel.org longman@redhat.com masahiroy@kernel.org mhocko@suse.com mingo@=
redhat.com mtosatti@redhat.com nathan@kernel.org nphamcs@gmail.com nsc@kern=
el.org ojeda@kernel.org pasha.tatashin@soleen.com paulmck@kernel.org peterz=
@infradead.org pfalcato@suse.de qi.zheng@linux.dev rdunlap@infradead.org]
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
-upstream-moderation/6a0bd843.170a0220.39a587.0002.GAE%40google.com.
