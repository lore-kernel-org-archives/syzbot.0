Received: from mail-oi2-f12.google.com (mail-oi2-f12.google.com [74.125.231.204])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A730D33557D
	for <syzbot@lists.linux.dev>; Sun, 20 Sep 2026 10:47:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.231.204
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789901263; cv=pass; b=JTFKO9CxLITW37XIup2a0i+afZvNk/HfblsWrbPBi2rJUtanjCOZjnCTZkaMPKekjdvEqtN5Ttaop0X2TGNeZe0oiJZQC/gbLZ2FyS75ccUJ2CKvvjXtKTpQ7UgD8FA1OvJwpOYZfwaKmvpJ13NgR+cAxjCu9s5rJ/vIfM7gyys=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789901263; c=relaxed/simple;
	bh=SpikctmbFxG5HqEEi1zaenhP4aA17A6fURe/sZOzrSs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FdmQs9rkZwCvq+9HyiwvuycOT4ECEGipXguEwJuIX7bzvtBgIbii7rtDbZ1KXaMkED21gSA/s7hHWpEGsO3+7hSzCncVX59TcaKsqL6WxYSPDcX5S5Cd6kZq06gAjkQdy5AAMv9r6Tpf3UG9EmIQxzSfn98Tu/eOpupjugKJ6cc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tTooFC+Y; arc=pass smtp.client-ip=74.125.231.204
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tTooFC+Y"
Received: by mail-oi2-f12.google.com with SMTP id 46e09a7af769-805c194bc92so2286721a34.1
        for <syzbot@lists.linux.dev>; Sun, 20 Sep 2026 03:47:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789901260; cv=none;
        d=google.com; s=arc-20260327;
        b=bD/a4j6Jqr3aCw7WZRE11enfGBsezgUd/xHKAv13hL5ZvHJKQDuHBhIawSj8khGD1d
         FFTk3SZrDIdnJxm4Z/KsFkZvONlaJmgT86uOYYITVI+6u1g9sxPCnCWZDcFE8VTuUspu
         82zr60sQaqVkdk8P6X/22yU9Df/xpqt5dQ4OuClGjPxQQrFkYwF7h380kFSPil6De0TY
         Rx3EdD5oIw4UZmO0WNI54yqU3d6vgT2aeAi6pakzaQ04hgUJviMgOksaTEzwJMaptelv
         JuGjfrOmKPMvet1cM+e+d45d7aGjJzIozjx4ESJDp8X21qdh8NWlEAOiO3SF1CsENJnf
         9wwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=mwKs6uoPyI88bdLtVhQb6fsO2VDeXiCleyZmboIiZas=;
        fh=BYYEoDXv+PYTKETTFKOQbUcbbBYS/xMPt1nwgX2ezyk=;
        b=n4BcQYFIuCywKEvWmqAIDkDdRNuMFds8QXuf7MCQefOXA/Rk0hGOi8cAI8n2AIoh2i
         b+Id0ZzcEmtFfk9oZUkkZgNGmwGwVSNGzBX9Aht0qu0Df1PIVToGVYvTd0HqubINAnWv
         0nMs3BXpni33WDAN4OrKdf2fbiMXMy3YGQr7x+b2mRPlde75nSx/hY9hSRt8CQ+o8FiU
         20lm8MooFvybUuHMBxVMCuVp+Qs65YKjo1Oh/JsmkOHI8fi9c4xtYxiLZpAGWkleCNdC
         WdthtZqTi1ZU4edeA52Ak9TeKwKWfah7UPGZn/rwKLKWebGXD4sAoFAw1seCGstt4d7i
         icgA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789901260; x=1790506060; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=mwKs6uoPyI88bdLtVhQb6fsO2VDeXiCleyZmboIiZas=;
        b=tTooFC+YYOUDgIjC2f0LAe6eMpXM2rcwb6IwK8U97FL6Ql//edD+ut+5wZPKY0DJtt
         T3BNV55/IjNyRFzHUHEVJPpiTwB5TtXrRmhv5Yl6mJqYdcvGzhWY3weBndF0XABtPEMX
         I6r5CQbSc2wO5ELxUDVUhSQS2bMdkjp6XrSbaSjaQR7uLYVjFo+gECyPe6CJFDMRn5wb
         uQgQIh49zTzJiRkZcQHJrMLG4iGOAgiInTj4Yo047/kA2+b8n/ntU7vVJ+Iy9Tft2uc+
         X4VmVhtQeiDQQoeB5KCdhwK7sJztSGXOa90kN4X2vhprJx77VbEG++g4mC5OrFQTYYZl
         w6Nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789901260; x=1790506060;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mwKs6uoPyI88bdLtVhQb6fsO2VDeXiCleyZmboIiZas=;
        b=QO9Q8sFNMQ72V8R8TaH9oDMbzm51R5JUtnQD+OSJYtC7TCRbggMH0A0RoMO7v67Xr4
         99zNzibLsHvCl2+fW5TjkrpJwU4QRb7o6tvzxHgCLBdK/QnF9D6/GCX93yzD26vh+KuJ
         suMeBkb3jk2KSjU0FUl1ppZh46dB465xIDDSRzOgOwDleW1gkLA1XOOVhTxudeId2mFc
         cixjKbUe7zu6/9bFyPrduXYUQBVXww/RQasEimiYJqN+RApJZ8Vt/k0wVP42W/02WL1v
         QA/qSbric9JTGcveMPdpM14LyoA59JTN4137xhQrAPJsBuu8tfqa6uH7+ri5Q5+B16ty
         oIkg==
X-Forwarded-Encrypted: i=1; AKwUvBxguygXmq4Phjs4eHhNN2mWxoFjjnOHOMEYHJdikohX+UXpxgpAexVXCUXMaZKmDWH9prSDfyw=@lists.linux.dev
X-Gm-Message-State: AFuF++mqfwitL+P7RqWxe2aZX3NkDOUdBxUXi8hMjSRGsWoP3D549wiQ
	qo4CBwgwOD3XlWuLV7pWhKNxz6fsNashueCIvIlRcm3fMzmPENhU0ajdh/D5D9aGjiykxS3uIwX
	xpRBruscOu3oT9cnLTsqn3kWOrMC8MyEbFzKwGiuciNyCDN1SQRkMvNybHO4=
X-Gm-Gg: AYBFou1S/A4XnMiFAvN9WHa8jwWYQm2Ajx6bKDjetCU8+FjNFXD2JVoVnpAmIHXt/fX
	RY05lwP8zMtC+VHrrjVtBddSZ8FsT4bNacEuTh2Dc3CFRU/wn6DtsqqDAjSUT+d7oyKm7ajyUuT
	xWYTq8V0yCj2RucjgESyyER2bxeErNl1OdsQsvVofcS3WxgBktltoagnH+/cO2iJl5THR++ylOa
	l4HCpGt64lZpLObIHODyY5aNu9C9M9qq2l696ZTqUvLbUEHPlAhGhZg4Gkkk44EqgTRd1SLAnj3
	FLUwSZyOos0fZc0Qv2j0NuG1z+9JQ7IwJa4J0SIHGOAyb7hruWZfKK6r0jfaviQlvMKKBDDz7dG
	0MT263aE7TfLQf4vAqnk3VLkXxL3UGavsyVtN3sJXQuXxeyC95XLB4dYOhk80SXNflvuO
X-Received: by 2002:a05:6820:f029:b0:6c9:80d8:a1f4 with SMTP id
 006d021491bc7-6ca9cb5b1ffmr7197408eaf.49.1789901259817; Sun, 20 Sep 2026
 03:47:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <6aaf6b44.3179f8cd.1e36b2.0009.GAE@google.com>
In-Reply-To: <6aaf6b44.3179f8cd.1e36b2.0009.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Sun, 20 Sep 2026 06:47:28 -0400
X-Gm-Features: AcwNN1XBHmO05aNI8Z-VVDpQ4AbeWl8Y8klM-e0ML6dBTOn5yx4W-YwvrCIT-K0
Message-ID: <CANp29Y6YxkATE4YEZre2J41A5xCECisMvJdvPYdukjUiiy5MVA@mail.gmail.com>
Subject: Re: [moderation/CI] Re: net: cfg80211: Validate monitor channel set
 against radio usage
To: syzbot ci <syzbot+cifdd8742fac68be6d@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Sun, Sep 20, 2026 at 1:12=E2=80=AFAM syzbot ci
<syzbot+cifdd8742fac68be6d@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v1] net: cfg80211: Validate monitor channel set against radio usage
> https://lore.kernel.org/all/20260917221205.3214125-1-roryl@candelatech.co=
m
> * [PATCH wireless-next] net: cfg80211: Validate monitor channel set again=
st radio usage
>
> and found the following issue:
> UBSAN: shift-out-of-bounds in cfg80211_set_monitor_channel
>
> Full report is available here:
> https://ci.syzbot.org/series/096ed229-0401-4402-9865-92c5b6d81b57
>
> ***
>
> UBSAN: shift-out-of-bounds in cfg80211_set_monitor_channel
>
> tree:      wireless-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/wirel=
ess/wireless-next.git
> base:      3b35f726c20d138fafa154182ee926a419306269
> arch:      amd64
> compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~e=
xp1~20260613092250.77), Debian LLD 22.1.8
> config:    https://ci.syzbot.org/builds/7147a923-683e-41dc-b623-05cfe4ac2=
a30/config
> syz repro: https://ci.syzbot.org/findings/525583ec-5ed7-4adc-aeab-6eb3b29=
3f9ee/syz_repro
>
> ------------[ cut here ]------------
> UBSAN: shift-out-of-bounds in net/wireless/chan.c:1831:49
> shift exponent -22 is negative
> CPU: 1 UID: 0 PID: 5855 Comm: syz.1.18 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
>  ubsan_epilogue+0xa/0x30 lib/ubsan.c:233
>  __ubsan_handle_shift_out_of_bounds+0x36d/0x400 lib/ubsan.c:494
>  cfg80211_can_set_monitor_channel net/wireless/chan.c:1831 [inline]
>  cfg80211_set_monitor_channel+0x38a/0x8d0 net/wireless/chan.c:1844
>  __nl80211_set_channel+0x340/0x990 net/wireless/nl80211.c:4203
>  nl80211_set_wiphy+0x127c/0x3050 net/wireless/nl80211.c:-1
>  genl_family_rcv_msg_doit+0x233/0x340 net/netlink/genetlink.c:1114
>  genl_family_rcv_msg net/netlink/genetlink.c:1194 [inline]
>  genl_rcv_msg+0x614/0x7a0 net/netlink/genetlink.c:1209
>  netlink_rcv_skb+0x226/0x4a0 net/netlink/af_netlink.c:2556
>  genl_rcv+0x28/0x40 net/netlink/genetlink.c:1218
>  netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
>  netlink_unicast+0x7bd/0x940 net/netlink/af_netlink.c:1345
>  netlink_sendmsg+0x813/0xb40 net/netlink/af_netlink.c:1900
>  sock_sendmsg_nosec+0x13a/0x180 net/socket.c:800
>  __sock_sendmsg net/socket.c:815 [inline]
>  ____sys_sendmsg+0x54e/0x850 net/socket.c:2713
>  ___sys_sendmsg+0x2a5/0x360 net/socket.c:2767
>  __sys_sendmsg net/socket.c:2799 [inline]
>  __do_sys_sendmsg net/socket.c:2804 [inline]
>  __se_sys_sendmsg net/socket.c:2802 [inline]
>  __x64_sys_sendmsg+0x1b1/0x290 net/socket.c:2802
>  do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
>  do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f7e3a59e159
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007f7e3b3d5028 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
> RAX: ffffffffffffffda RBX: 00007f7e3a825fa0 RCX: 00007f7e3a59e159
> RDX: 0000000004040000 RSI: 0000200000000040 RDI: 0000000000000003
> RBP: 00007f7e3a63506b R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f7e3a826038 R14: 00007f7e3a825fa0 R15: 00007ffd12ef16a8
>  </TASK>
> ---[ end trace ]---
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
> [dylan.eskew@candelatech.com johannes@sipsolutions.net linux-wireless@vge=
r.kernel.org roryl@candelatech.com]
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
-upstream-moderation/6aaf6b44.3179f8cd.1e36b2.0009.GAE%40google.com.
