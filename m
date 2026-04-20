Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CA8F3148C9
	for <syzbot@lists.linux.dev>; Mon, 20 Apr 2026 08:11:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776672713; cv=pass; b=b89z9En8mDYghfLafxekDNFGVq2xjsLi4c1zr3xKUGSQslnHKrRZjVIGfpLd8hu13RScQP2kZbSYdB2rgecqDycXfWM4HwiZMNVLv4E9T6Vd3snhQ9DqDcZv7z1NtAAZwEjKCPjaOxK8XhTuKkn2Y0gUS5secdhXAReF57+295Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776672713; c=relaxed/simple;
	bh=p8oiA2UL1cjDemCgJml/fNryH57ucBce+jR2fG2s3Yk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nFjZVi8Z9v14a7XMLN5y9QJkmLJQVmGL/cDQFFyDMj1KkO4/jB3IKhcgEJSvwGSOFV7Cm/ouZZfpl36cIBMaLQ6uOugOQPcnNMrfuH41A8gIaUTGmk5dxhNv14RFjzFDc8WundvPOqP/wwvKHJv6371dgoYtzu4u5zME6ziSV94=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=RsC/czKA; arc=pass smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="RsC/czKA"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4891f625344so4204155e9.0
        for <syzbot@lists.linux.dev>; Mon, 20 Apr 2026 01:11:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776672710; cv=none;
        d=google.com; s=arc-20240605;
        b=SzSjdK+FHDIfSM12a5xzPkjxPlICsOcaPGAM6n4i6KfQ8c4pVqA7OCbtYsOCMbbGM2
         +KLkhwc4c4Symp09ULZ8n0Q0P5IStucjJvB5IeIC3NFMTYWPdgM6YCfXG59nXdRhHhmm
         d+HstxMihhKHAskwNeB6DbJAk2rchHVontdGQ2kYqW4UizM83qSSX6iYAQiVIAYQ4XWe
         SQGkCm2ZE5k//eFOjYbIsUDuXDZv844PeFWVOO3IJ4DajtoWhpptZtcdQ0sWw6N52bu7
         HAJ6fjUQfcQQ6rIiqIfcJLfpBeq13CGbwZTiYB3Tb+w4C1yCUEKrEINsucJ9J4bu0W7y
         AyGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=fuNrGfJn8ZCQcnJ2e6FLRlIWfMZxZl1bfYDXSWhG2iY=;
        fh=slLNeNXT2bFgSO5rDCnEhiEIcHcgYDgTG59qR5EPnfM=;
        b=YR6WdTWj3/+3VRkvdmZ0Lxszpv3k/faI7gJRf1T7oKQ/WpZZ0DESgs6z3k1M7AKImU
         96iIc8Tr2BLZXnfamsJ8hBpk9RHxHO86hlPHujK2K7m6jfOwLqsWfbtpM+JPmFKNnqRJ
         3/72luW/Wl5ZpzoptfEp5DAxu65FpOznltkQ9JxTU6RWgVsh8V9BhIvWUtnDCo4KmdhF
         5Xv4RLcgQCysaop/DTOL62iHEPMcODPsC4NFdRA2P+ECWH+9I/Xx2ACRXhZDDGdyjPEP
         2bJPsip0N1d26VX5QGD27SRJYAdFpQnre3PbOCLhkL4U2xMfGwlXazyTLbFrmu8J+HEb
         ncFA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1776672710; x=1777277510; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fuNrGfJn8ZCQcnJ2e6FLRlIWfMZxZl1bfYDXSWhG2iY=;
        b=RsC/czKA38ryqYw5WigHO8Ss3rXPAhm9NIeQP3ia/matgUPgyhxFUWhEeLjazQDids
         xI4I3AfJijmhBqVr3Ux9YMKxAXUXbwCYs53mcVQqakPvYyTbpqWXRCeou+AcQYiVuk3+
         IkyiumIVmhVKkQQFJVxecR3946QDZWor4x7XS8uucMttDXFXorrHbBTrbVQ/8MYJFu0L
         R8aSLX3/1iUALZujU0VkTrInRUQbEq8RaJj0ZocnaSItxx/0cmjH9BvwOTNI8cG+KxGE
         SnWiTIBi2C5oQ7cAiCiIEHF3v/suiejLxzxoT5NjPXddp0F+Yxx2Yzk0GR8Uzyj7St5L
         5jhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776672710; x=1777277510;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=fuNrGfJn8ZCQcnJ2e6FLRlIWfMZxZl1bfYDXSWhG2iY=;
        b=HIhACyD8s7ekifPTwXxUDLR5b6XA6RaxWFTrA8B4TzJkPyh2SfU9HvfrODCFStURMw
         /c5lpa4pNPxvXtqfJ0I2hIebkrE70t+KbsCXWO9GRHQlp+tkRxAarmFMcLZAkLBj36s6
         NLqcqDF2aNoxO3QSXGZXvatUv/v/+FlSEZoNeMShuZxNAsHnG2/Dki36SsIZoA4oIQph
         v+3sRo0YiWdopRd1x5n7ycH/13rOyDX2u4I8AGBfkZDIywZhU+P1JaNp3SiJSZYeBf2a
         hller839Xba3Rly62sF7NGiArmLgENlSoGjLPrDrWkf1Uxd3uChhfZ+OsNROjOTDagg7
         5SeQ==
X-Forwarded-Encrypted: i=1; AFNElJ8uKbQ4Ew6inzvDZg7rZcZ62cRxf9QsmCbDGFP+VQpvLdkidN5o+n3lNhYe2UwtYW0m5RkHQqw=@lists.linux.dev
X-Gm-Message-State: AOJu0Yyr72I0tDTcBooGmtodGejuCKA8yVeogRgfwT257jqT+e8lHJqj
	vYpYhpjFV+RJNPPBVZYLYeFiea66UXyPiT8zriaNSYQiM16h1W/tAjJT8axv982CSJqgjq39Ird
	T8wdMhZESNFu/MjJLo/iHBdLk9TRX+HX+NBWBQy41
X-Gm-Gg: AeBDiessTf7PU5vNl8Y4Eq9ms8LO9LpDlaYN/vmubgGwytLNfPxoU8j8o/VGn4wcKjH
	7/3V6DlVqN4CXSoL6tBUuz0EJ1KdINLrlrfbW8pY/0COrZeq8pmhqaWODxfn6saefuibNY2Oiah
	ZNCCk71O1msJaW15sZFjySubml7R7JRMJOyvMnmfuoSB8WxmthHxffm3gn1xGrX2V//qZ6SINFO
	U3ZL+5HUxIhcW8o2A79K4u3+k3IL2mW5iDvAb5+9dVh62vKulFb1xzv39j5ZLw5YsKbn3+cZZry
	hjuxLj3FY3tUUSEt45/8SUjQEOmSQxmwcc7AFfhxJiyyL94uSg7l+NpQHznFwuVk0ZhIms3L7W4
	ttrJwLfGL0KyT8ylR6IGOJiym0h8YYQ==
X-Received: by 2002:a05:600c:34ca:b0:48a:761:5816 with SMTP id
 5b1f17b1804b1-48a07615b87mr8626455e9.8.1776672709397; Mon, 20 Apr 2026
 01:11:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <69e5df06.a00a0220.9259.0000.GAE@google.com>
In-Reply-To: <69e5df06.a00a0220.9259.0000.GAE@google.com>
From: Pimyn Girgis <pimyn@google.com>
Date: Mon, 20 Apr 2026 10:11:38 +0200
X-Gm-Features: AQROBzBnVxN_2TmL5ug148E10RUFACWInzSk9v3C5bbj9yAhuyrFnq8qyt2YHOs
Message-ID: <CAJWNTGwrrdbajar4dZDMf16xrYzTryCh5d40VbawAnAZ6-X9aQ@mail.gmail.com>
Subject: Re: [moderation/CI] Re: net: nsh: handle nested NSH headers during GSO
To: syzbot ci <syzbot+cicccda4cae0d53a4d@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Mon, Apr 20, 2026 at 10:08=E2=80=AFAM syzbot ci
<syzbot+cicccda4cae0d53a4d@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v1] net: nsh: handle nested NSH headers during GSO
> https://lore.kernel.org/all/6112cce99b4e3571444a616d0fb19e91e2fcca72.1776=
597598.git.caoruide123@gmail.com
> * [PATCH net 1/1] net: nsh: handle nested NSH headers during GSO
>
> and found the following issue:
> WARNING in nsh_gso_segment
>
> Full report is available here:
> https://ci.syzbot.org/series/13f77bac-014d-4059-9187-fbdbcb6a6540
>
> ***
>
> WARNING in nsh_gso_segment
>
> tree:      net
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netde=
v/net.git
> base:      0cf004ffb61cd32d140531c3a84afe975f9fc7ea
> arch:      amd64
> compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~e=
xp1~20251221153213.50), Debian LLD 21.1.8
> config:    https://ci.syzbot.org/builds/193058cd-cd88-4bb0-a6e6-b43b6179f=
cd9/config
> syz repro: https://ci.syzbot.org/findings/446db72d-a630-471c-b369-2ef1f7b=
3b6ed/syz_repro
>
> ------------[ cut here ]------------
> offset !=3D (typeof(skb->mac_header))offset
> WARNING: ./include/linux/skbuff.h:3173 at skb_reset_mac_header include/li=
nux/skbuff.h:3173 [inline], CPU#1: syz.1.20/5978
> WARNING: ./include/linux/skbuff.h:3173 at nsh_gso_segment+0x833/0x12d0 ne=
t/nsh/nsh.c:107, CPU#1: syz.1.20/5978
> Modules linked in:
> CPU: 1 UID: 0 PID: 5978 Comm: syz.1.20 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:skb_reset_mac_header include/linux/skbuff.h:3173 [inline]
> RIP: 0010:nsh_gso_segment+0x833/0x12d0 net/nsh/nsh.c:107
> Code: 2f 08 00 00 48 8b 7c 24 60 44 89 f6 e8 46 83 e4 fd 48 85 c0 0f 84 2=
0 08 00 00 e8 48 af 31 f6 e9 ab fb ff ff e8 3e af 31 f6 90 <0f> 0b 90 e9 43=
 fd ff ff e8 30 af 31 f6 90 0f 0b 90 e9 39 fe ff ff
> RSP: 0018:ffffc90004847220 EFLAGS: 00010293
> RAX: ffffffff8b93aeb2 RBX: ffff88817362a6d8 RCX: ffff88810f088000
> RDX: 0000000000000000 RSI: 0000000000010040 RDI: 0000000000010000
> RBP: ffffc90004847390 R08: ffff88810f088000 R09: 0000000000000005
> R10: 0000000000000005 R11: 0000000000000000 R12: 0000000000000000
> R13: 0000000000010040 R14: dffffc0000000000 R15: 0000000000000074
> FS:  00007f28e9ed36c0(0000) GS:ffff8882a9245000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000200000010000 CR3: 0000000170f06000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  skb_mac_gso_segment+0x31c/0x690 net/core/gso.c:53
>  __skb_gso_segment+0x376/0x540 net/core/gso.c:124
>  skb_gso_segment include/net/gso.h:83 [inline]
>  validate_xmit_skb+0xa21/0x14a0 net/core/dev.c:4039
>  validate_xmit_skb_list+0x84/0x120 net/core/dev.c:4089
>  sch_direct_xmit+0xdf/0x4c0 net/sched/sch_generic.c:357
>  __dev_xmit_skb net/core/dev.c:4209 [inline]
>  __dev_queue_xmit+0x180f/0x3950 net/core/dev.c:4831
>  packet_snd net/packet/af_packet.c:3077 [inline]
>  packet_sendmsg+0x3ebc/0x50f0 net/packet/af_packet.c:3109
>  sock_sendmsg_nosec net/socket.c:787 [inline]
>  __sock_sendmsg net/socket.c:802 [inline]
>  __sys_sendto+0x672/0x710 net/socket.c:2265
>  __do_sys_sendto net/socket.c:2272 [inline]
>  __se_sys_sendto net/socket.c:2268 [inline]
>  __x64_sys_sendto+0xde/0x100 net/socket.c:2268
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x15f/0xf80 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f28e8f9c819
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007f28e9ed3028 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
> RAX: ffffffffffffffda RBX: 00007f28e9216090 RCX: 00007f28e8f9c819
> RDX: 00000000000100a6 RSI: 0000200000000180 RDI: 0000000000000005
> RBP: 00007f28e9032c91 R08: 0000200000000140 R09: 0000000000000014
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f28e9216128 R14: 00007f28e9216090 R15: 00007ffd50249d78
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
> [bird@lzu.edu.cn caoruide123@gmail.com davem@davemloft.net edumazet@googl=
e.com horms@kernel.org jbenc@redhat.com kuba@kernel.org lx24@stu.ynu.edu.cn=
 n05ec@lzu.edu.cn netdev@vger.kernel.org pabeni@redhat.com tomapufckgml@gma=
il.com yifanwucs@gmail.com yuantan098@gmail.com]
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
-upstream-moderation/69e5df06.a00a0220.9259.0000.GAE%40google.com.
