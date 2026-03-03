Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CADF33B6D4
	for <syzbot@lists.linux.dev>; Tue,  3 Mar 2026 07:54:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772524471; cv=pass; b=aK0iVvKvR2+2H8FJkA6CEsnH3QevEHvxxiXuRph3vHwK5m6T9xtzd34u821ejzLoi954ObyERdMpl2tjTkhkfwcOfieEf5nbfNl4T6rcsTvqVid+fc6cO40W6faD0ag3L2rCKjvIaX97VFoWOp2ngbXYYpAr0nZsKlnnwCaJHQw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772524471; c=relaxed/simple;
	bh=rNvYuYyYZ4TOGfRFc1Ih7BRe4KwAdF0YYvxkP4mAKvE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LqGPZnzbmba52E2EnsMzadQJ3EBTJEQ6gKZv4QtSbOqx/Q4W24djKhAfX8PI6iJ0rZwQ2G6WaKxbGelZCwKwywawrbNl2OhAxp7r7Hkd/v9oKyrp2RC35NcWjJu6YC6NQ+t0gbvVqkoq7c3UAy/r2+Cjypj4hW5m5aJLJXo4SaM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=YMN99p60; arc=pass smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YMN99p60"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4806ce0f97bso45074435e9.0
        for <syzbot@lists.linux.dev>; Mon, 02 Mar 2026 23:54:29 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772524468; cv=none;
        d=google.com; s=arc-20240605;
        b=g80/+sDPrAhoMf53sWgsz07euxhGyIkKrMfcd82YAzMGQghyu/1AywkLJUqtcVMcv4
         t0UvimQnSIrlZhA5j2w7ETu/fW1jumBy9NbNgETSjfjUHWypGuc/cb9QpKj7vFWOZQ/O
         SnEh6Id0NcqiQuEskJ++EVa44rRck4qKB7O2/YbesyQ36aiF5J1Gm9KYwpF0feo5MZXE
         e+yMRUUWbs8vuxOK1vL52V2hsMfhUZkEHUNBtKPpJHs69C4saVT2xC4wnNjdT2oYW7ll
         re7qNtMbyqhnoMj+wEVmNLhUQvbjVgfiQewBln2Tpgtfo3Ch4KAq7d7/Qt22iJyd6mOd
         GMzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=LBhkkEbSlazMR2z0mdOSEjF6NSK54fC1IIByYHEE1/Y=;
        fh=NvJ+2+JwsDkO9ixABzLv88kh+4BxBWpll0CYZf6kJeY=;
        b=ilfZTfvd16woWPJU3TLdzWJ8DOXSgZxalmKFj3jGoc0SiubULvrBXz0bt0YjC12O2V
         NJ+wswuBRsApEGvvrDS6xd6RMYxVxtDc1Vbr+rSK3i+J7X+ewbEt51Qv2MjskdMYwd+W
         1C7xNaNyhK+uY0xcEgSBcqfrTMPSbaCKy+qWJYwb4+McU6WS+uw5oVGukfWDeRoSq2Yh
         Qk/2h61UZJDZpz1VbqzKqqYmbrKbNQxDaNQvsSJpRTsGfgqnhR3mmmsSeG7H5S8e/Ssj
         evjn405IpxBqmTyKFwLvSj58L7S0t8s9AODLkUMCm/PGehkf7A8T6o0T8GmAnK79+p4W
         9/JA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772524468; x=1773129268; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LBhkkEbSlazMR2z0mdOSEjF6NSK54fC1IIByYHEE1/Y=;
        b=YMN99p606tstTBfmrlHDQKHphIfJpfOj3mD29Iprlf/iQn4i7jwMbv8hA+LOBlhfF6
         A+qqRpF7Q3oIIoQsqRgcHKD84a7KvGzxlGxVzCF4wrwUdhEDz+RdEpjLWmdr48BVzhNZ
         qJklwKO4wIhkOJJApBdqWisxGRul+amvg6GKPX8YT5KkLH0Kmb72SaqEwwGKFyvWjbHW
         78vFZ+GHnrmEm1IZ0Ws2JxNRprtXLnbEtod9zRlFG7QNJv+6CYUyaHH3b5wKm83p+Mmx
         KI7BmezgOY7KO8AlfHB/gbCPeQ5SiF/JvhM19JhfBlslW4h6EBdi1fpZxlZdT6HJIUSQ
         9dPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772524468; x=1773129268;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=LBhkkEbSlazMR2z0mdOSEjF6NSK54fC1IIByYHEE1/Y=;
        b=O/ATkuHCSifQEkB1YsuO9RBM8ITqEXvs979c8FUIXLPaD4nDw8ng2MAuITL9TJD0JH
         YF7SFOjz5jYVVeQxjBlr6LRoEqGs7NBi3fdPCUgkSMQOPA28lsSMZR8iggVKKVOA2gRU
         hOL6F8nhBoRqvm9rCLKkmJWruHiBhhpFiaEVsRxBf2VgjsBye0gnsIPATW6G9l79bd2n
         73fxORLS6nOa7VSx4f0RIXVvVuWP4J6VF2mxjwBYHRIAtWoGbBuawBfdxfNSpjBq0qn1
         gftsZ+lSKbCzr+UtBeK0Ys3KiGIST0LFuEdgYNPCGz/Er9iZ/yXybl1P4QfQZdat72fc
         fXXA==
X-Forwarded-Encrypted: i=1; AJvYcCVPQU/DEWxwhpHh82QWf+o/if1YPHNPUe8O2VG83JOw0GuUvyhEoERf2u6OakdSv+KNAfd86S4=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz1ubGHnEl6UmGJmXT2Biqyx33udP2Lodx0tKz6/kj3UOhFY3MK
	KEnsFuTd4/anxMlJm51z41HUVxzm0Pl79t+spI/CM9xRLQNGsr/bmmRkHAIlmM7fh2SLnRomTed
	D4xdgjqtzgtLYJD4BHNZBhFy/Gi1JsJIl/dEXOQVg
X-Gm-Gg: ATEYQzygKuyGR08uc0g9m3UlHkfheQEDHuDd2/lOqMrs9cXl5u9PPIGw/7v6h6Q4ReD
	KT1fjISe095r+CY35UmjGZZGhNa6v0AZm2XxMe1MYYGo3WHcJNIChJyybwnOsHB0sLTb4/siTaR
	nW60AFGtYw/WiwOPKx/x6qrqyg1HRqmuN8oN3haFXAnwdN3vFODSOQvZQ+dzscfJKp9swNjYIKh
	X6uxORQFTGYuinsNNJ8dQCfJVSQUACnJt+J9PgYaqShTUMga4Vb3gA+AJxbso+kHKi4I/mmAcCI
	rSFR2vLppmnysdmgQvuRvSdsjio8o90BHuqGzPgFgZOF5AoAibhi
X-Received: by 2002:a05:600c:4fc8:b0:47b:e2a9:2bd7 with SMTP id
 5b1f17b1804b1-483c9beaca0mr313299705e9.19.1772524467372; Mon, 02 Mar 2026
 23:54:27 -0800 (PST)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <69a6556c.a70a0220.b118c.0009.GAE@google.com>
In-Reply-To: <69a6556c.a70a0220.b118c.0009.GAE@google.com>
From: Pimyn Girgis <pimyn@google.com>
Date: Tue, 3 Mar 2026 08:54:16 +0100
X-Gm-Features: AaiRm51pDrnObHw977rjOV6_FVgBGt_D6jALHBrs_IWmLRiXgLB22l3fpADhPBw
Message-ID: <CAJWNTGx762MvHXQgQTgGV8i8=TferDoesNCB+cbxnD3FerXVcw@mail.gmail.com>
Subject: Re: [moderation/CI] Re: vsock: add G2H fallback for CIDs not owned by
 H2G transport
To: syzbot ci <syzbot+ci1aac2b63ecfb9c67@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Tue, Mar 3, 2026 at 4:28=E2=80=AFAM syzbot ci
<syzbot+ci1aac2b63ecfb9c67@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v2] vsock: add G2H fallback for CIDs not owned by H2G transport
> https://lore.kernel.org/all/20260302194926.90378-1-graf@amazon.com
> * [PATCH v2] vsock: add G2H fallback for CIDs not owned by H2G transport
>
> and found the following issue:
> WARNING in register_net_sysctl_sz
>
> Full report is available here:
> https://ci.syzbot.org/series/8be7b007-32ae-447a-bb92-b169bb844054
>
> ***
>
> WARNING in register_net_sysctl_sz
>
> tree:      net-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netde=
v/net-next.git
> base:      01857fc712f6469cab9cc578120cdc80f1c2a634
> arch:      amd64
> compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~e=
xp1~20251221153213.50), Debian LLD 21.1.8
> config:    https://ci.syzbot.org/builds/5374f01b-dc57-486a-a2a6-2fb66c003=
b70/config
>
> ------------[ cut here ]------------
> sysctl net/vsock/g2h_fallback: data points to kernel global data: vsock_g=
2h_fallback
> WARNING: net/sysctl_net.c:156 at register_net_sysctl_sz+0x163/0x440, CPU#=
0: syz-executor/5808
> Modules linked in:
> CPU: 0 UID: 0 PID: 5808 Comm: syz-executor Not tainted syzkaller #0 PREEM=
PT(full)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:register_net_sysctl_sz+0x1ad/0x440
> Code: 00 00 00 fc ff df 41 80 3c 06 00 74 08 4c 89 ef e8 88 36 c8 f6 4d 8=
b 44 24 f0 48 89 df 48 8b 74 24 10 4c 89 fa 48 8b 4c 24 18 <67> 48 0f b9 3a=
 49 bf 00 00 00 00 00 fc ff df 42 0f b6 44 3d 00 84
> RSP: 0018:ffffc90005357ab0 EFLAGS: 00010246
> RAX: dffffc0000000000 RBX: ffffffff90234820 RCX: ffffffff8d01a100
> RDX: ffffffff8d05e680 RSI: ffffffff8d05e620 RDI: ffffffff90234820
> RBP: 1ffff110212d6810 R08: ffffffff8ff4f0c0 R09: ffffffff8e7602e0
> R10: 0000012400000008 R11: ffffffff9a79ce5c R12: ffff8881096b4088
> R13: ffff8881096b4078 R14: 1ffff110212d680f R15: ffffffff8d05e680
> FS:  000055556a136500(0000) GS:ffff88818de66000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f0c19e52af8 CR3: 0000000112a0e000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  vsock_sysctl_init_net+0x13f/0x2f0
>  ops_init+0x35c/0x5c0
>  setup_net+0x118/0x340
>  copy_net_ns+0x50e/0x730
>  create_new_namespaces+0x3e7/0x6a0
>  unshare_nsproxy_namespaces+0x11a/0x160
>  ksys_unshare+0x51d/0x930
>  __x64_sys_unshare+0x38/0x50
>  do_syscall_64+0x14d/0xf80
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7fd97459da67
> Code: 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0=
f 1f 84 00 00 00 00 00 0f 1f 44 00 00 b8 10 01 00 00 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007fffee0fc138 EFLAGS: 00000246 ORIG_RAX: 0000000000000110
> RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007fd97459da67
> RDX: 00007fd97459c799 RSI: 00007fffee0fc100 RDI: 0000000040000000
> RBP: 00007fffee0fc190 R08: 00007fd9747d9610 R09: 00007fd9747d9610
> R10: 0000000000000000 R11: 0000000000000246 R12: 00007fffee0fc198
> R13: 0000000000000002 R14: 00007fffee0fc378 R15: 0000000000000000
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
> [arnd@arndb.de bcm-kernel-feedback-list@broadcom.com bryan-bt.tan@broadco=
m.com corbet@lwn.net eperezma@redhat.com graf@amazon.com gregkh@linuxfounda=
tion.org jasowang@redhat.com kvm@vger.kernel.org linux-kernel@vger.kernel.o=
rg mst@redhat.com netdev@vger.kernel.org nh-open-source@amazon.com sgarzare=
@redhat.com stefanha@redhat.com virtualization@lists.linux.dev vishnu.dasa@=
broadcom.com]
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
-upstream-moderation/69a6556c.a70a0220.b118c.0009.GAE%40google.com.
