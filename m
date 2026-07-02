Received: from mail-oo1-f43.google.com (mail-oo1-f43.google.com [209.85.161.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 606023BFAEE
	for <syzbot@lists.linux.dev>; Thu,  2 Jul 2026 22:56:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.161.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783032974; cv=pass; b=ZdXadLCzUhvOTaJCgJEFvq8L8Mf0/NjvzhwoTPpPU4ATcnqF/GD4Qkpy5dlml99/9YdNxd2pnLqYy25xpvDxwUNL46YXITpYVZ8Qgs+kGUY7AeDNW9fzDLpE7OSSvYCSS76TFfTmvzd4hnc7CBiX3/Zdjuv9VWbWqOqbWdUQCgo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783032974; c=relaxed/simple;
	bh=ap+0UJPTgDmoFi8RGGMsaJE2/ScDsSaipzoWB5JHoZM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qeoUqjZ3sNPw6smUU3KOnJvBEMwTQZoI18lqCPu5p/clDuq9EJak+Xadzsc0R5HTXsMvGP+g0bcBwRsaDzcN+6WbNKfKFyojKorYXG0IjMvdJHZvhKPFeo5CbYZyTZ9b0ZtP9fcLnGxXAQOwz+EPYQMjJSMZ5cYYwTSEVn0+RgM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lDz+GEqp; arc=pass smtp.client-ip=209.85.161.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lDz+GEqp"
Received: by mail-oo1-f43.google.com with SMTP id 006d021491bc7-69d8f70cb0cso1601060eaf.0
        for <syzbot@lists.linux.dev>; Thu, 02 Jul 2026 15:56:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783032971; cv=none;
        d=google.com; s=arc-20260327;
        b=T18AcQdyPPPKX3BYKwi3N1ALc5Ucayy85FMl1UOXaEx9vhvQKteQzXpnDIWwseBca0
         HsGNQ74LviGXdLbnSCZAmhV2wIFzb2ajDaifqaFB3R15xMg0XHJGRHzKKNFtdfxJqF5U
         CzdxhGT+vPARhfuH9bPAWb0xXFG6skFB+Zx0QktKOm9jcKrbd4djdxZb8bzaIGiQLB3H
         11RSwi8+10AwPLtCQaWSX+OC6BX0yyXxLxXvtc/gHUG9m+tcq3rOAGTbrYtRHs8OIOfk
         KgvHX8Dyxdfiju38C42P28mGxKw4b+SG5u2UBAKzavNrRXQ2zpxmxr2erSG4UmIYqRH/
         zShg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ggyJHGjdEzblhfGveg2gNb+mT++HN4l7hknV6diXe1g=;
        fh=DVLyTR3sFWYsEkxmf7qzzSaMFL0lciq7qf3mYIKyjU8=;
        b=NdDvpYnsD+cluYy6CfbH1OpJoaYH+q2aCvYqJI4YR06LojK/21BdsX7wOjcFlN5uuR
         TcY2jmeQ+IJ/cdtNL825KSm6b1YXq1g5/Et7Ey7qx0NMNNuoUYZLweXDHkoUZlw8qQ4F
         AoJZEtsRs9+6HfJu5k2VEhxuvoe2Q1pjmf/CG+c7iJOCP08oFqpEqPS3X9wEz1Azm+9g
         Xf2VADGEvUQiQpalSOW2Ark3wljk1XhSlr9h7g3VlReoyVVDA+bGFFBqUenNVIBBFb8P
         Ul86oyNUTaXRhmHJPDapmPvC7S2lvmA9HGTa3uOJCYTNixME4VyxuENKcm8+0mVv2btF
         ufgQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783032971; x=1783637771; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ggyJHGjdEzblhfGveg2gNb+mT++HN4l7hknV6diXe1g=;
        b=lDz+GEqpfCK0yMNmQTVm6e6wNIWVEx+rptI7dHh/jzRZKCcPoBt1v8trX61lGLVN1k
         1pUs51qLOtpmnLMs38XG9xVxD9WsPO4mQdtYvJNidVT6ouDjsPNqD8nhzum9AB0zM+lh
         qxesCAroKcZTKTP4486VzO8WsCtRi7HGWgFQuPPTZM/aC7YxNCp7e09lall6lUDPcC0j
         HD6jmqfbzyHMt3c4Iirc6F+l6JQYYb13MIJmfEFmpqwEiwMJRLNjFFkEKkZoHKemsM0N
         J1WuT+iXOt9rOuDVRq17vs0fEiucKLqJYjBTb1ldZVNpN3ZiIEarFoOh2UlhksvjEl1Y
         MmHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783032971; x=1783637771;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ggyJHGjdEzblhfGveg2gNb+mT++HN4l7hknV6diXe1g=;
        b=ictrya42a/GUK1CEsBzTwtEZMh3JDnHT1UbqpYBMBoPfvYxyXm8wwjjzky0qrRCHMS
         pYvOZmZ1BHPeeMtpZVCRzWP6Qbp5hFaKeJnQdUZ4rxrT/w3t1eJUDanYPUbYYn701IG9
         UD2r6mi5svyOz1tnnzbdlou3CJRiqMnJstxvwa7rTbnO1mxlWnueJXeNRHkXDGU5YLUE
         fMQpzRezNg2J4kErjh9xS7m4OhgT+hM9lvT9fwYYdEEbedifGJWl/TE673VjPaq9na+f
         FGaT0mfaxy4cTgJsfh7jAwpgR3E6VFegA3T/lKUOTWZPCxL4T0OX01nw7++jnCVWhxgT
         aNgw==
X-Forwarded-Encrypted: i=1; AFNElJ/Jmi2Vlip3pWmXOtZYP12z3lVHNx2ykzj0DMUBx/OkGTJqlGVSbY3jXaRkIictF9v5K8ZOfdc=@lists.linux.dev
X-Gm-Message-State: AOJu0Yyy+/5HM3FfaE2UQ7LxzI3gRex7kqyknR79RvZXfYsvwP7TV9gw
	60wzoG4zWW9tAYdv3Spcvjd0jWp9we+eVO2xmI+i7r/e0szbULGBWLHeYCpXBPcHCBV9WTY0HdD
	l29fNgqHX1qsR189amx8HN4eAj9LNDEWi0FEoKTJJk71XsyfZFT7FVKPR
X-Gm-Gg: AfdE7clRfN46k1HsOPYyoiv2dyC3Vr/ZQhjGYPSWGIQ8wSu1vRg+JWN1fQZbl/p9Mxu
	apLj57YCXk0K3ex93b9/r1VnfHvGXjt90dSZlwaMDe+XPeSaO/RgLwDpCN2oZN++E9dwu7A1U0C
	gvclTzr2jVFmP+YQ5B/L5xgceZbUfK2KEYgkOroDzBYIhMqrQoURND6lbI7jiXwVj+RXnNxb6HN
	mDDVowhHy/TS+krErsQ3/2WamvxAz0ohWrCwOWsBrQM3IKRwI8TeU3qUrHBLtWTD9haI/+7jNvc
	+OWbcpHwJ8XN0dEOmfN8YsVCnFOvLpfESlTBrJ9oin8ZfMkGfQ/yQxDQVXidrQ7XBmjbPQ+n1oE
	Wnk7Nc3N9Z4jiibydoKyWQVBLrihqicJFWamdrmiW0/TY98EJmzN2/Q==
X-Received: by 2002:a05:6820:1612:b0:6a1:208c:ebb4 with SMTP id
 006d021491bc7-6a30d7a2722mr3939931eaf.19.1783032970779; Thu, 02 Jul 2026
 15:56:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <6a46e42d.52c20a74.1f8b39.000a.GAE@google.com>
In-Reply-To: <6a46e42d.52c20a74.1f8b39.000a.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Fri, 3 Jul 2026 00:55:59 +0200
X-Gm-Features: AVVi8CfDlO3lHUSCbcHiDM-xscG1ax-sT2UQO0NYwcIHbzdgARq2itzt0aGFcHk
Message-ID: <CANp29Y5JRmSe9yjw=z1318tgHqvhThTCNKN0JPF7ZEowsXdsOg@mail.gmail.com>
Subject: Re: [moderation/CI] Re: ext4: deferred iput framework for EA inodes
To: syzbot ci <syzbot+ci39094543e0c4127c@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Fri, Jul 3, 2026 at 12:20=E2=80=AFAM syzbot ci
<syzbot+ci39094543e0c4127c@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v13] ext4: deferred iput framework for EA inodes
> https://lore.kernel.org/all/20260702152225.4071746-1-yun.zhou@windriver.c=
om
> * [PATCH v13 1/4] fs: add iput_if_not_last() helper
> * [PATCH v13 2/4] ext4: introduce ext4_put_ea_inode() for safe deferred i=
put
> * [PATCH v13 3/4] ext4: convert all EA inode iput() calls to ext4_put_ea_=
inode()
> * [PATCH v13 4/4] ext4: remove ea_inode_array mechanism in favor of ext4_=
put_ea_inode()
>
> and found the following issue:
> WARNING in ext4_journal_check_start
>
> Full report is available here:
> https://ci.syzbot.org/series/ce304d7b-7f32-44b5-bf6f-e579abb42a5c
>
> ***
>
> WARNING in ext4_journal_check_start
>
> tree:      torvalds
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torva=
lds/linux
> base:      4a50a141f05a8d1737661b19ee22ff8455b94409
> arch:      amd64
> compiler:  Debian clang version 22.1.6 (++20260514074242+fc4aad7b5db3-1~e=
xp1~20260514074407.73), Debian LLD 22.1.6
> config:    https://ci.syzbot.org/builds/e5413370-cf09-4540-b9d3-7d280f314=
ae0/config
> syz repro: https://ci.syzbot.org/findings/e7cd69b7-8bb9-4554-bd84-b5ebcd7=
a8089/syz_repro
>
> ------------[ cut here ]------------
> sb_rdonly(sb)
> WARNING: fs/ext4/ext4_jbd2.c:75 at ext4_journal_check_start+0x24f/0x2b0 f=
s/ext4/ext4_jbd2.c:75, CPU#0: kworker/0:5/5860
> Modules linked in:
> CPU: 0 UID: 0 PID: 5860 Comm: kworker/0:5 Not tainted syzkaller #0 PREEMP=
T(full)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Workqueue: events ext4_ea_inode_work
> RIP: 0010:ext4_journal_check_start+0x24f/0x2b0 fs/ext4/ext4_jbd2.c:75
> Code: 5b 41 5c 41 5d 41 5e 41 5f 5d c3 cc cc cc cc cc e8 06 75 42 ff 41 b=
f fb ff ff ff eb e0 e8 f9 74 42 ff eb d3 e8 f2 74 42 ff 90 <0f> 0b 90 eb c8=
 e8 e7 74 42 ff 90 0f 0b 90 43 80 7c 25 00 00 0f 85
> RSP: 0018:ffffc900036bf888 EFLAGS: 00010293
> RAX: ffffffff8283ecce RBX: ffff888170078000 RCX: ffff888107390000
> RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000000
> RBP: 00000000000000ef R08: ffff8881bb53440f R09: 1ffff110376a6881
> R10: dffffc0000000000 R11: ffffed10376a6882 R12: dffffc0000000000
> R13: 1ffff1102e00f0cd R14: ffff888170078668 R15: 0000000000000001
> FS:  0000000000000000(0000) GS:ffff88818dc20000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 000055557b325a28 CR3: 0000000114bfe000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  __ext4_journal_start_sb+0x147/0x5d0 fs/ext4/ext4_jbd2.c:107
>  __ext4_journal_start fs/ext4/ext4_jbd2.h:242 [inline]
>  ext4_evict_inode+0x7cb/0xf70 fs/ext4/inode.c:238
>  evict+0x624/0xb50 fs/inode.c:825
>  ext4_ea_inode_work+0x5c/0x90 fs/ext4/xattr.c:2974
>  process_one_work kernel/workqueue.c:3322 [inline]
>  process_scheduled_works+0xa8e/0x14e0 kernel/workqueue.c:3405
>  worker_thread+0xa47/0xfb0 kernel/workqueue.c:3486
>  kthread+0x388/0x470 kernel/kthread.c:436
>  ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
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
> [adilger.kernel@dilger.ca brauner@kernel.org jack@suse.cz libaokun@linux.=
alibaba.com linux-ext4@vger.kernel.org linux-fsdevel@vger.kernel.org linux-=
kernel@vger.kernel.org ojaswin@linux.ibm.com ritesh.list@gmail.com tytso@mi=
t.edu viro@zeniv.linux.org.uk yi.zhang@huawei.com yun.zhou@windriver.com]
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
-upstream-moderation/6a46e42d.52c20a74.1f8b39.000a.GAE%40google.com.
