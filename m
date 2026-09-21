Received: from mail-oo2-f38.google.com (mail-oo2-f38.google.com [74.125.231.166])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AB2544F54B
	for <syzbot@lists.linux.dev>; Mon, 21 Sep 2026 12:01:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.231.166
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789992116; cv=pass; b=VFwD1Te7aFj2k9YFqI9Btm+qWh1/laQ9JGc8oMFIarkF5WqdSbDPXCan1hFO8aulhVaClmK4Z1tHrDKzhryenaAAZQWGz56M39cE7Pxov9oiHkhxnwoKyNVT5UGZE3WeAk/+PST6YjjMt/g+cO5tpR6DpPfmVgQSM936Ita+4a4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789992116; c=relaxed/simple;
	bh=IVX/2rVs876PTDlOC+d4E+BL7OQxny5AyN7XfJRpRdw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=P4tKWHMTHhg3QdUgoxjV5vzH2WQ9MhbXOi1jaDP9lxwm1Ote2dlWIpJ5UWsakL1QBX8KkgaC2ab7x8oEWEb3oP9b55ewLvSQLXfd8CMfF615YZOk4ehJ/+iELulfkOGqIciq9dWLmOopxj+h3KTziygh0OBhs1CvdSUxvI6kgfg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=JFYQ7hUO; arc=pass smtp.client-ip=74.125.231.166
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JFYQ7hUO"
Received: by mail-oo2-f38.google.com with SMTP id 006d021491bc7-6b1ae736c63so1539893eaf.1
        for <syzbot@lists.linux.dev>; Mon, 21 Sep 2026 05:01:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789992112; cv=none;
        d=google.com; s=arc-20260327;
        b=LIAcb/dwyLcnBKrpVdHODCuj0Tjke43KIqadvVjN6LUP7IFsV4mICysUAQuzG9L1RA
         f4Sx1AXHrQJC1pm+FQyEMKq/qWB/zqMaa2VAvCYLlLUb9Jst24AIFNb6qsm1Aib9tqiI
         aZmVfFhgu0i9hhZ4ABh69FQVjbaW+SdKeimKkuUfNxzZxjU/TMjBndcyjgNpmX/IdaFV
         EoSKRJj2sJ63RG0taq2x/O8PRiswjm5X2VzNkhRKDVZH0iFay3eXNU/L08Y3Z6IN/B2T
         TUarT+rgRYWKAO74IeAx6rR0VoLFKV3M/vwvpMccOD0y3azQZo8fE0wklXHk6yQWOxjx
         yy3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=M3PyVO49XXVkETREo5V1FBfIadMHzGd8w/QvxkimwvI=;
        fh=8G5R9X48NCQ1c6LMvt77b/g3ddkqSSHqEh0tdkP1ChE=;
        b=o1uxCWsAN4DqSIqcwoOUmA86UDrLU0hSv9JsVViiI6RkTrV9pvtZYHB+EiHft44Qyo
         IHJCO31Ce4pWMQVobsTXarB9pp3i0rnWMq+EiJS7DtK+HPYFd0q8DQPTE6UVAdIh4EMV
         03UwRA1yxtkT8S/wp1ybINpEE7VbiQ35OPGE2Rw8YJ2do6Cl+/7ISql5FB4AGjVveh92
         TNkIoj1w+6bjDWNoEA6uPdbolelWn+M79rYfaPHqdiOvsuTra49U+G3jWAu1/4hzkfdr
         rW02uHTl20D6g7N2bM+QnhAdsuzy1W44xHOsbutd2IfFI6kLzEAEeV9wp8uJ7J0hkDxa
         ui5w==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789992112; x=1790596912; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=M3PyVO49XXVkETREo5V1FBfIadMHzGd8w/QvxkimwvI=;
        b=JFYQ7hUOVw5eNg+FIouaWhTIC8JHwoOy/yWlIABHCp70FY570IuXjLU7gcM3pEKGJT
         fb/q1+q0WYxa12Yt+5zx1MH36jMaQ1qwbuPl7YwKdeUg+6QK+Xy1kw1590eQZC9Bm//N
         Xw4GStlCRsEPjv7o7wzGUJbfh+KeBoHyc+/xNtKoKL7apEVS3fMw6gU05pz4Pz8bC5B3
         FhTQBsBEicsJ/y8NRfLlWb/r61sgSA3jQOxcEr+EQa7RuiP9yp+3FEJgyxLQMOR8LdcB
         H6W6e5lThcxMEnXn49NcNDjfKTxLUxLXsiYj6thrUqWQRSQbnf60o2dGcMkff0DZ+qVY
         6/Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789992112; x=1790596912;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=M3PyVO49XXVkETREo5V1FBfIadMHzGd8w/QvxkimwvI=;
        b=rqGtlnidrCQvI6CURXz53V30yEP7LSzJp4OhrPSPu8r2SxfVeThCJ957osxbCg+pE1
         OYeKFpzclBKi6GfL88kTCK7xJjdxh6PSdbCnW8IdvGNs1OU4eMQgN5sUMBNedmwtLQXe
         CZ4jBbJQJnac4Da31pHSK9KzXDN2mjV0cdDMwaYQvsIFtaw44P8pCGmQlvGgQtJXzjEj
         smsMmKSyPhoaNfPytN7neq9/pjTAgaPRNdDLyODGiWfXShdGjbg+vRvKnP90XKhMVn2J
         WLvArxwqbjf4117D5p5hLw9pAeItYM1S38ndf+mbp2vPycQbih4Wm7ULeCgi+puYyF92
         w7sQ==
X-Forwarded-Encrypted: i=1; AKwUvBymtnVVodaN1BMeAFCKD1KLZhK+h5FSa5vT0SON2qDWIvEEUJDwoZlPrLUWu3ISZU6dSXXODfE=@lists.linux.dev
X-Gm-Message-State: AFuF++mKsvhzaPEsjKTkKahf3tVrnU3KK1JufiQdfdnvVyd+IjGe0CBd
	CRm0j97e1tqtX941L7CW2xmDXZ87E1AOAdegPt3HnXqRUgH7fLNcKN1OLGtlrGLBGR46wKRX2g3
	PRQTnuDxOikxBu4I6/HH1gtvYXsnK+JZt8p1ZUZLoWbUEztdBOaVczV25
X-Gm-Gg: AYBFou3Banr5MT9hQnAuZXQKDB48GM4G1dC+zL75g9FPL6OSurUEAiKT8s4AjKO9eC4
	k5QGUwDplCptzcPyMBPQ0QXKzuLgneq8jAtkPO9x74lzsadifLhV7UrF2DH4+QnMNu+O6fhDT6u
	t1MnyNxiFCcHN5OJJf6j92z6Wi0qtEJbSD3McVy3HHiCYi5DUyhA0PBT70ChTysihz0xPGEoFhS
	4OEv0S/vErcp4sbRZHqlPF8k78zz9YQ3HKtl2RDxLh2Xazhc2JkrWtUEZjgbI0Ou6//g4VbJDjc
	jGvO54iqohS7UlEXFBVdX9zdocpoM076s97wGcsPmq2B6OO5EnkF1uPTfej2SYyYPX1F2TRjZq6
	eyydcsNrleNtXdROEnpCPh3cU6vZp8tYyrN0N1Xyq2sR0pfQucL07gl7TvqAssj7z1z2bzycVKa
	oQJFCP2AgSdWs+0047KnKVPA==
X-Received: by 2002:a05:6820:1846:b0:6cd:3fec:de78 with SMTP id
 006d021491bc7-6cd3fecf349mr5876873eaf.78.1789992111651; Mon, 21 Sep 2026
 05:01:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <6ab0a8e2.3179f8cd.1e36b2.001c.GAE@google.com>
In-Reply-To: <6ab0a8e2.3179f8cd.1e36b2.001c.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Mon, 21 Sep 2026 08:01:40 -0400
X-Gm-Features: AcwNN1Vh-qFTLJhPOcMGVAHmh3XAJWeW4lRTCg6QUgcLm4jKp76qewIzvr9Oqqo
Message-ID: <CANp29Y6zMTJqBt9mLH9qLk2f8PoYpS2w-pxWJLLr-XjBR8F=ig@mail.gmail.com>
Subject: Re: [moderation/CI] Re: net: cfg80211: Validate monitor channel set
 against radio usage
To: syzbot ci <syzbot+ci95b1659da90f9918@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Sun, Sep 20, 2026 at 11:47=E2=80=AFPM syzbot ci
<syzbot+ci95b1659da90f9918@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v1] net: cfg80211: Validate monitor channel set against radio usage
> https://lore.kernel.org/all/20260918170746.3824-1-roryl@candelatech.com
> * [PATCH wireless-next] net: cfg80211: Validate monitor channel set again=
st radio usage
>
> and found the following issues:
> * UBSAN: shift-out-of-bounds in cfg80211_set_monitor_channel
> * UBSAN: shift-out-of-bounds in corrupted
>
> Full report is available here:
> https://ci.syzbot.org/series/8cc9e8b7-7ee7-4960-86f8-d3d32e74b751
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
> config:    https://ci.syzbot.org/builds/007f6283-0b6e-4ff9-84e0-69128d745=
e0c/config
> syz repro: https://ci.syzbot.org/findings/ba5a8e20-28a0-4771-b097-95a9703=
e3244/syz_repro
>
> UBSAN: shift-out-of-bounds in net/wireless/chan.c:1831:49
> shift exponent -22 is negative
> CPU: 0 UID: 0 PID: 5850 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(f=
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
> RIP: 0033:0x7fc73059e159
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007fc731480028 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
> RAX: ffffffffffffffda RBX: 00007fc730825fa0 RCX: 00007fc73059e159
> RDX: 0000000004040000 RSI: 0000200000000040 RDI: 0000000000000003
> RBP: 00007fc73063506b R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007fc730826038 R14: 00007fc730825fa0 R15: 00007ffd4fd500b8
>  </TASK>
> ---[ end trace ]---
>
>
> ***
>
> UBSAN: shift-out-of-bounds in corrupted
>
> tree:      wireless-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/wirel=
ess/wireless-next.git
> base:      3b35f726c20d138fafa154182ee926a419306269
> arch:      amd64
> compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~e=
xp1~20260613092250.77), Debian LLD 22.1.8
> config:    https://ci.syzbot.org/builds/007f6283-0b6e-4ff9-84e0-69128d745=
e0c/config
> AI triage: https://ci.syzbot.org/findings/412a77e9-4657-490d-8b72-2bca17c=
93acf/triage_trajectory
>
> ------------[ cut here ]------------
> UBSAN: shift-out-of-bounds in net/wireless/chan.c:1831:49
> shift exponent -22 is negative
> CPU: 0 UID: 0 PID: 6635 Comm: syz.3.380 Not tainted syzkaller #0 PREEMPT(=
full)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Call Trace:
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0xe8/0x150
>  ubsan_epilogue+0xa/0x30
>  __ubsan_handle_shift_out_of_bounds+0x36d/0x400
>  cfg80211_set_monitor_channel+0x38a/0x8d0
>  __nl80211_set_channel+0x340/0x990
>  nl80211_set_wiphy+0x127c/0x3050
>  genl_family_rcv_msg_doit+0x233/0x340
>  genl_rcv_msg+0x614/0x7a0
>  netlink_rcv_skb+0x226/0x4a0
>  genl_rcv+0x28/0x40
>  netlink_unicast+0x7bd/0x940
>  netlink_sendmsg+0x813/0xb40
>  sock_sendmsg_nosec+0x13a/0x180
>  ____sys_sendmsg+0x54e/0x850
>  ___sys_sendmsg+0x2a5/0x360
>  __x64_sys_sendmsg+0x1b1/0x290
>  do_syscall_64+0x166/0x520
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7fbeb4b9e159
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007fbeb5aef028 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
> RAX: ffffffffffffffda RBX: 00007fbeb4e25fa0 RCX: 00007fbeb4b9e159
> RDX: 0000000004040000 RSI: 0000200000000040 RDI: 0000000000000003
> RBP: 00007fbeb4c3506b R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007fbeb4e26038 R14: 00007fbeb4e25fa0 R15: 00007ffe46366df8
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
-upstream-moderation/6ab0a8e2.3179f8cd.1e36b2.001c.GAE%40google.com.
