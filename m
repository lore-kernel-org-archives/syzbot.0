Received: from mail-ot1-f44.google.com (mail-ot1-f44.google.com [209.85.210.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 022722F1FDF
	for <syzbot@lists.linux.dev>; Fri,  7 Aug 2026 14:59:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786114781; cv=pass; b=QJfsYmmGpjwHhdSCB7KtZa/lu4EkRjAoPjNdaTpZL6cHsmsvq2m/mE4w/0B8i9OoWsUqAJpUXNTpDZbXdaUOiYufKeARGgf2CZGbfiYu2TMAxQQ8hMAs/2pQq7XZ4hUP+97HicQAZ4wtnJCVK1V1gD/f9qdwdi7hD5vVaU9NEUE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786114781; c=relaxed/simple;
	bh=wWIZSUQz8JmpxD2O/vS9C5aCOyO2/IM9JTh/y6rfe6o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZCHoc7n66e7CeZ9wZklHDBmsc8ldDi4KfUmZNVBkEGeg4VR4rNR/mARwId8xS9Re2gwDHlbkm+R/0wM6MMQpyfcM3VMZIO2v7jGWvRZbSyXsVQUxzZOlZxKw6/FlOKejOh41bAQkiG2t40DpT5tl+WYqUcJbPirvTmrCzFAUUT8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KR2o6QHj; arc=pass smtp.client-ip=209.85.210.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KR2o6QHj"
Received: by mail-ot1-f44.google.com with SMTP id 46e09a7af769-7e9eaf04bfaso1329263a34.1
        for <syzbot@lists.linux.dev>; Fri, 07 Aug 2026 07:59:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786114777; cv=none;
        d=google.com; s=arc-20260327;
        b=iWxoBTRIS3T6o24imCW/mz6LXQgtjzR2r3ciDJC+Oja6yrp/u+pe4JjtJz9FC3aLyi
         Z9noX2xQTOp9yopLcJOH+qY96p07Gru3sCKf5LoDJWoChkBKyZGuF2y9wMB3aL7pEAdi
         iP+7umJ47OuBSFDI13hwqwz6ihNof9UIlKcS7blTtM7YE2wOkUsCghK8pkeC6pASbSWs
         s/z6du9uMIXs6ElplbiSccL+DsfawXCI//TPlQvYeuR+ZMXgyePnusi+eRJXclxhdNNc
         jQAOS3RB1TrxdMAX1LRl5kag54DNHmYz6fdmru2GrE/l2MjagnTpIkNKArJkSZasdBeC
         mKoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=XfckcDo+EroqCAMDydO+QsAUhl3sxawZayMe9dVxl0k=;
        fh=htjUqRuqf9gaVnY4bzRc9WzuBEOlkYJr/z0TR5OEg94=;
        b=RweebY1mh/+KOs4sFtMD1kw3qgITm+K/kzLJooR6mCFChG3fkcu82xml3WuiyR07y6
         QeRR3FKaFV5jrPixsOwgQVgZ1tveHdFXtn9w5cbTnfWJbxEQ2x4NjTN4wQtPcIYNhYcq
         9kBGGcgNWTts/+JkmG3hJgI8Zmvno2JLYhcA+GykZ7oKP4URXj7moHG2Y6XlIfRpYG/D
         cOJc5RrvXIBF7klpDMKA13ht90E6UOkcNTK/CnZM94ximl6OHfZTXQgUbGO+1ksIF/vx
         EtJGIx2LUVB4ajBIf4Jx+pzddS9FRFogaSIZNpDNTU4EO3ud6iyIPDmQl4OOyBHUiwvp
         PIuw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786114777; x=1786719577; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=XfckcDo+EroqCAMDydO+QsAUhl3sxawZayMe9dVxl0k=;
        b=KR2o6QHjclMyK9/QwNHdpQ3S5DhIx/QjyuP0hn/VY+RSFY60U5YxqkVvYS+iZlvSvz
         Hs0DXvwRRqCgT4GeKXq+WmU3uuMhBnltT+V9ItpWuOxJpKs1aP4SIvEQN6hi534cfGGL
         y5L62mT1Z9rv9sc9SdxhQUX2StMOfoZujhBDS7UTx+2q+w3IkY87vagHLESf7ViYzkH7
         xepu2rkbkuPRdFTcFYJwSj+8JX2j2r9+SypC0btb79jZMUyOuTPna8fu2h7B5RpLTkbY
         zqUXQavggmSJgP8OlM1nNd4EwneaNXlPPG5lIIGNeTbwUwsaqL/ItWIZnOvdW4w9v8E0
         i03g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786114777; x=1786719577;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XfckcDo+EroqCAMDydO+QsAUhl3sxawZayMe9dVxl0k=;
        b=DyqUEvMThulJLWPFAp1XxbKr6Qo0vMYP2dNV+Lyxc1H8n/iUykZF4/BEZgaT/1iauE
         3FBpvhn2/4Ej4Oy6HpbPY85ltnGih+UpvjWTI5ij0pZqmApRqBb1j2zM0A67k9bbf5Vx
         cc/qpr9gHBz3WKQ8eTC9Vudd4oULaoyRJgL808OAXmVAxWzeLpdyPbQMZNtbnirfe359
         xyeXQVYaT2cGiPOgHGBUnd0NWJa0Ogg8i9DzF0n61JBtuqC2F5ksUkL/WGe35I8UaHeR
         ew+UG+bYAmFk8htaGAConDrjgeyrGSFn8bOw0F8s4oF6/IpY7w99Q1O/BdihtxdfUv2i
         SUwQ==
X-Forwarded-Encrypted: i=1; AHgh+Rr4+zAlKLbvqfbrvImkqgzqTG9pge4n8FoJbC7WhQpok74YePl67OXQ++9aauVqB3bVcMcLYZI=@lists.linux.dev
X-Gm-Message-State: AOJu0YymKZcnQtAQLO0t3RMge3lyq0oYMTMY3FjOH5xDU7LGhtyp9tUO
	XHp5M9UqhoTKT+kzfSbefUC3V/5vGmdSVUSq3noFZ+OoPhwifjNo14g+lqQx3ZmYfo3rFFFMX8A
	xcpnXhfnFo+vjlnL7EvODIemobVwe51n2t0N83xlY
X-Gm-Gg: AR+sD133jozz0Md0dz4zGxu8+ZqX4WZbKnpmdZOVf/geJVFx3hlKPjADb10SXQh0BxL
	6ucdVkczDYlMe++nmcXim5oCY7qnTa+d5VEXC47J3dHGta36RMJ785wJufAYExT+8cb3hb7Xg3K
	hr4JHJuWjqX5fWIJTf2yIqbXyFUVcMPxHQie/iFHzVZD3SvrVWrCn0qJjk6kxK3nOpACnS1eYkH
	em72nJ4XGYA4aptHNYbFNMj2qGIysdHb2pR2b53jzDySAhDkNer9GWFmwuXjUCoKYkPUingwCDl
	92oNz2EymozXipqjJasMHOxVbvVinR9uTSobUmViWe9p9Yz9kZyXYDWa6tMLtr5ZDEnujF0PUDX
	9MT3LTC1NNtPola9HKjeJTS48uTyfQ/H0bvxMneUDLINlu9hsJzZPLVYqD1zEo5i59ta8YecII5
	Q/xFHw2tFyjFWV
X-Received: by 2002:a05:6830:3691:b0:7e9:cad9:4bd0 with SMTP id
 46e09a7af769-7f1e5c2a034mr16419327a34.3.1786114776178; Fri, 07 Aug 2026
 07:59:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <6a75f19b.01d0871a.3a0d52.004c.GAE@google.com>
In-Reply-To: <6a75f19b.01d0871a.3a0d52.004c.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Fri, 7 Aug 2026 16:59:25 +0200
X-Gm-Features: AUfX_mzTo-OLTenVAmoM8oWVyuNue6reBA0OIQ6xqFNn9bH6k_-IdC6l87uhfeI
Message-ID: <CANp29Y4X40P0ov0i9rwEzECGgMz-NGn+eJ7aN893g3EH=WWVLA@mail.gmail.com>
Subject: Re: [moderation/CI] Re: net/smc: fix clcsock and lgr/lnk races in
 smc_diag dump path
To: syzbot ci <syzbot+ci963edbdba5a028aa@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Fri, Aug 7, 2026 at 4:54=E2=80=AFPM syzbot ci
<syzbot+ci963edbdba5a028aa@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v3] net/smc: fix clcsock and lgr/lnk races in smc_diag dump path
> https://lore.kernel.org/all/20260807081606.3200128-1-mjambigi@linux.ibm.c=
om
> * [PATCH net v3] net/smc: fix clcsock and lgr/lnk races in smc_diag dump =
path
>
> and found the following issue:
> WARNING in smc_diag_dump_proto
>
> Full report is available here:
> https://ci.syzbot.org/series/ab0d12fd-741a-4a0f-9f49-e52b84e94f4a
>
> ***
>
> WARNING in smc_diag_dump_proto
>
> tree:      net
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netde=
v/net.git
> base:      594d905195024b228c962627ae5ae7c17bd582a4
> arch:      amd64
> compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~e=
xp1~20260613092250.77), Debian LLD 22.1.8
> config:    https://ci.syzbot.org/builds/0c4d246f-d098-4afe-b6bc-0f0ad52f5=
5f8/config
> syz repro: https://ci.syzbot.org/findings/fa5564b8-8db6-4f76-9d75-dbd7964=
35d87/syz_repro
>
> ------------[ cut here ]------------
> DEBUG_LOCKS_WARN_ON(lock->magic !=3D lock)
> WARNING: kernel/locking/mutex.c:625 at __mutex_lock_common kernel/locking=
/mutex.c:625 [inline], CPU#0: syz.0.161/6326
> WARNING: kernel/locking/mutex.c:625 at __mutex_lock+0x12d8/0x1550 kernel/=
locking/mutex.c:821, CPU#0: syz.0.161/6326
> Modules linked in:
> CPU: 0 UID: 0 PID: 6326 Comm: syz.0.161 Not tainted syzkaller #0 PREEMPT(=
full)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:__mutex_lock_common kernel/locking/mutex.c:625 [inline]
> RIP: 0010:__mutex_lock+0x12df/0x1550 kernel/locking/mutex.c:821
> Code: de 57 90 48 c1 e8 03 0f b6 04 18 84 c0 0f 85 47 02 00 00 83 3d 45 c=
c 83 04 00 75 13 48 8d 3d a8 1b 87 04 48 c7 c6 40 f7 ec 8b <67> 48 0f b9 3a=
 90 e9 75 ee ff ff 90 0f 0b 90 e9 48 f2 ff ff 90 0f
> RSP: 0018:ffffc900068c6e40 EFLAGS: 00010246
> RAX: 0000000000000000 RBX: dffffc0000000000 RCX: ffff888170ffd940
> RDX: 0000000000000000 RSI: ffffffff8becf740 RDI: ffffffff905b2db0
> RBP: ffffc900068c6fd0 R08: ffffffff9057de43 R09: 1ffffffff20afbc8
> R10: dffffc0000000000 R11: fffffbfff20afbc9 R12: ffff8881b1006648
> R13: 0000000000000000 R14: 1ffff92000d18ddc R15: 0000000000000000
> FS:  00007f4dacd826c0(0000) GS:ffff88818d945000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 000020000000e000 CR3: 0000000171350000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  smc_diag_msg_common_fill net/smc/smc_diag.c:50 [inline]
>  __smc_diag_dump net/smc/smc_diag.c:101 [inline]
>  smc_diag_dump_proto+0x6d2/0x2620 net/smc/smc_diag.c:255
>  smc_diag_dump+0x59/0xa0 net/smc/smc_diag.c:278
>  netlink_dump+0x711/0xee0 net/netlink/af_netlink.c:2331
>  __netlink_dump_start+0x589/0x7b0 net/netlink/af_netlink.c:2446
>  netlink_dump_start include/linux/netlink.h:341 [inline]
>  smc_diag_handler_dump+0x199/0x240 net/smc/smc_diag.c:293
>  sock_diag_rcv_msg+0x4b0/0x5f0 net/core/sock_diag.c:-1
>  netlink_rcv_skb+0x226/0x4a0 net/netlink/af_netlink.c:2556
>  netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
>  netlink_unicast+0x7bb/0x940 net/netlink/af_netlink.c:1345
>  netlink_sendmsg+0x813/0xb40 net/netlink/af_netlink.c:1900
>  sock_sendmsg_nosec+0x13a/0x180 net/socket.c:775
>  __sock_sendmsg net/socket.c:790 [inline]
>  ____sys_sendmsg+0x54e/0x850 net/socket.c:2684
>  ___sys_sendmsg+0x2a5/0x360 net/socket.c:2738
>  __sys_sendmsg net/socket.c:2770 [inline]
>  __do_sys_sendmsg net/socket.c:2775 [inline]
>  __se_sys_sendmsg net/socket.c:2773 [inline]
>  __x64_sys_sendmsg+0x1b1/0x290 net/socket.c:2773
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f4dabf9e019
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007f4dacd82028 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
> RAX: ffffffffffffffda RBX: 00007f4dac226090 RCX: 00007f4dabf9e019
> RDX: 0000000000000600 RSI: 0000200000000540 RDI: 0000000000000003
> RBP: 00007f4dac03500c R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f4dac226128 R14: 00007f4dac226090 R15: 00007ffe0de8ec98
>  </TASK>
> ----------------
> Code disassembly (best guess):
>    0:   de 57 90                ficoms -0x70(%rdi)
>    3:   48 c1 e8 03             shr    $0x3,%rax
>    7:   0f b6 04 18             movzbl (%rax,%rbx,1),%eax
>    b:   84 c0                   test   %al,%al
>    d:   0f 85 47 02 00 00       jne    0x25a
>   13:   83 3d 45 cc 83 04 00    cmpl   $0x0,0x483cc45(%rip)        # 0x48=
3cc5f
>   1a:   75 13                   jne    0x2f
>   1c:   48 8d 3d a8 1b 87 04    lea    0x4871ba8(%rip),%rdi        # 0x48=
71bcb
>   23:   48 c7 c6 40 f7 ec 8b    mov    $0xffffffff8becf740,%rsi
> * 2a:   67 48 0f b9 3a          ud1    (%edx),%rdi <-- trapping instructi=
on
>   2f:   90                      nop
>   30:   e9 75 ee ff ff          jmp    0xffffeeaa
>   35:   90                      nop
>   36:   0f 0b                   ud2
>   38:   90                      nop
>   39:   e9 48 f2 ff ff          jmp    0xfffff286
>   3e:   90                      nop
>   3f:   0f                      .byte 0xf
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
> [alibuda@linux.alibaba.com andrew@lunn.ch davem@davemloft.net dust.li@lin=
ux.alibaba.com edumazet@google.com guwen@linux.alibaba.com horms@kernel.org=
 kuba@kernel.org linux-s390@vger.kernel.org mjambigi@linux.ibm.com netdev@v=
ger.kernel.org pabeni@redhat.com pasic@linux.ibm.com sidraya@linux.ibm.com =
tonylu@linux.alibaba.com]
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
-upstream-moderation/6a75f19b.01d0871a.3a0d52.004c.GAE%40google.com.
