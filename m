Received: from mail-ot1-f51.google.com (mail-ot1-f51.google.com [209.85.210.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED06C4AD7CE
	for <syzbot@lists.linux.dev>; Wed,  2 Sep 2026 22:02:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788386576; cv=pass; b=S5xVcDK5GvN4qxSZ4BrO9ODlu+6rUUvEGLk0uLtx66yZ6adcHbjgLpTaOpaxkO8mtACWuqcQmOnf5GM+zirLiynjhdKhs8K/Y2smVs6mTLIFUvUonxzD6lkzdqwMzljlPW2nlvPNf4mHuVcm0E7aQ9zty0vAhAPoc17aHNqE5Uw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788386576; c=relaxed/simple;
	bh=bPlnSRbMY64Xsb1kSXVm3ZZkzUmPQDal4QLQbUigsk4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rZV+MM8UZ7730hpp3+6eUJ/Z6Ko5vZYgxB6h5tziYEbbpRHAq/VYThEXWo3VumOM9oqcNpAK2SkWwfPZdhnQ5oN0xZeEYZtPoAwAV/vSqqaYTie+XfUe0qQTAO39m9GHv2T4m1jIjU0Jvqx4ZV5p3iLOUPPHVZK32jFqKYuyStA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ly28lr9s; arc=pass smtp.client-ip=209.85.210.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ly28lr9s"
Received: by mail-ot1-f51.google.com with SMTP id 46e09a7af769-7eb6573bd52so1394302a34.3
        for <syzbot@lists.linux.dev>; Wed, 02 Sep 2026 15:02:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788386568; cv=none;
        d=google.com; s=arc-20260327;
        b=bTx93lO+cXboeZQlUyU746yfgnadtG3VKUTnNf/TbVSyrOmafSWJ5dJaRQQTSJAYtH
         zLWVUbnGZxKwl1+U/XeLx5w68hGYG1XQQsM9gR/IJfONMmaJT/QlGV0N9Jhk+PddocSr
         JOcwr+ouTUA6r3krnU78OMV0ERDjkvScMVjvOlIbsLLqsaSkIj0hrrxb0TaS7jdnZeR9
         qtqRAR+lRRKEYV6sVPtl5OS4hNQydt144o2NYhlYxkQx4Ku1v1ZrnC0dBGHr3tkQ4KuQ
         EZG25d+6DB7a72g7sp6eKsDzCOne6fIVM8GxHsc33oawwAsgktUGLQALihGzai0lWTQV
         WU2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=bOIYdEKG3qooyyRojazf5alAVQRIUD27j19IF5Xwp78=;
        fh=7aACjLV0uZukHjs/Z2p6yyy9KIOnopUb1ZAJFVOiJyk=;
        b=n3AIfnOjFYYMzZiKijWDrDLQba1HTTxe2clt1y/jjt+at3nanWLHQiKV2mCDuruAAf
         KzqL23KCn45lBRpOkIFwA2ZXX8LrTjp8ixxDfqiaZhxpQBIj1ffv6TV9bg0QDUze+hUi
         88T1/8BJiBs8MFvauINBbQ7/67Sne26IQQ06CUrSh4QdNNMMHESJskWKcZ2CvGbI7grf
         23BJ1KavJ1VxyuhXvas7CiWnyC2CJq+Q0+4cMOx7b5ep576ayktsj/cxDbkRyPgCPfJz
         vMZZX9RwIfCGf2Pyn8MO0/a75F8cIHOM74sN01OKJmTXuxs9bBK90ovaTFR2u6fk4m6h
         LNJg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788386568; x=1788991368; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=bOIYdEKG3qooyyRojazf5alAVQRIUD27j19IF5Xwp78=;
        b=ly28lr9sxkMhZt4Na3XBqaz/2KjzPzT8o9V+8MC+bTfYnQbo4Ncq/GXTGuIxMVbSts
         J+3WouhEkaFGWWAF4G2IzwzvPCN0l9JbkrO41b/9yafrcvO/u8wpys/tvRAInT8eC/XE
         ScWQpO0k89vuT3WBkZJ1zJri1fM2odkSxViai0aM2yMEU7VIXxAYfB4G2x7kGCTAQQSP
         1ujsORmX4zsy6Lo6VdWgjy2z2uoUlx0UP5Ulxzgiwe6icAbCX1kCX+LkI/sgCFtbZIaS
         b0wn8PPzZ2WA8AQiiF1pIYydc2kZfk/v5jR27yQs4wrfkL77ZwD87NQBsiw88tgiOQWm
         6zMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788386568; x=1788991368;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=bOIYdEKG3qooyyRojazf5alAVQRIUD27j19IF5Xwp78=;
        b=Od2pmmhXxRjuZpMJHYcoMtwphjw9pyRIM+gv5SO9aMAlZK4l8x10WWGOnnmh4Co5MM
         bQ0KuXYKt/UM+SfxEEbSWVJRbQTtXnQ/ip4OWSijVurc5oD2pMF9Ow49OCl/JHHg6h1r
         yrezZfqy3st+w4Qtjfj1NxF9pWNCIMyOhG7yIN5efc69qW061KF3RAEa3lq03HkyWBXr
         Bp+wwnVNPoRQMUTUDL1nwdPycpU1d2fr4WIn/Rhh29hktavM6lVHxyaLhoa8ZSNyrj8s
         ciYpVwXfb2F+1NtqiH6GNdVe040C3D4XhNmSuSueEq5TrOAmfZZSaBYrkIZ3zyJQeBQw
         beNw==
X-Forwarded-Encrypted: i=1; AHgh+Rq3oQwEqu/tKIZdgxFuhJ+Om8mqSVXU/8DBd1UYAamUXyGOxiN7aFn8xKpA4JBNz238sTpP2Tg=@lists.linux.dev
X-Gm-Message-State: AFuF++lQO98GroQZigoTpeEW9WPBIvoNTXMW3tTi4bDdwOJ1Z34/nZSX
	J5ABhSpIXpWLtohkK3WFqyluoYSAjeDc8Cn1Ut3ZgtrgfnxZyVkteYnwXHJ1cGNjOsMFqMieqdM
	YR2bxQmDpuAgaOJP6ZVTCa+6Z134j4ymsNq3zpgLlDYpU/oV2TLfqp9Q2
X-Gm-Gg: AR+sD11GSZFOQD6bsRp+ohhlceD1yqwlxa03FqR/ZF1dJ+v/o9JNFGRPija2ZMXQm6L
	sW/WZu3eQwdh6Y8QiCSjoS4sUTkBsW3oD0ABEDDh5ieDWcaGAlMiJP54w9jcgpF94YnjJFztk5M
	45rIq6ihaPx3xgcabr0L3Q3IqwO8fENroRCC1pcpSHR46ShXeJo4qk5dpJ6ZNxSAkFl/ITW+WOM
	5JgvaAZjHuZrMNt0JwBz0zWtlq+vqdEMHLXp6PlkHCP6AbLVdjGYuVPxUy4tEYI4B9Ap1vM2i0Z
	RyCg/VZFrYcWJlt17Zh79eRZLCWdYn5ybJJCHiXtDZ5+NyYlBJLm3iVffcorSFOgK8AmLa/JEFx
	gvfdSczBZaXzSkrBXIGceEIyybp/LTNBx5AJPJwUN9ghDQvq02Qgn9s6eCqoVPpSicEokogutZR
	8IzmEkRNAwGa0SZA==
X-Received: by 2002:a05:6830:8d0:b0:7d7:d524:bc88 with SMTP id
 46e09a7af769-7f781178968mr7562126a34.10.1788386567765; Wed, 02 Sep 2026
 15:02:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <6a98961f.9266084e.bf0d7.0010.GAE@google.com>
In-Reply-To: <6a98961f.9266084e.bf0d7.0010.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Thu, 3 Sep 2026 00:02:36 +0200
X-Gm-Features: AcwNN1UAaimmPYqOUXo6U2-dKlcMwhRNoXCtu_6OTwC0DZN8WZMXTsOI8Gr3XCw
Message-ID: <CANp29Y7oOnaKcNQWbvtOnBE3mPOx=h4Jn6-Mvm_bZBoONFyi7A@mail.gmail.com>
Subject: Re: [moderation/CI] Re: ip: validate options before echoing them
To: syzbot ci <syzbot+ci580e1d9fe98861cc@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Wed, Sep 2, 2026 at 11:33=E2=80=AFPM syzbot ci
<syzbot+ci580e1d9fe98861cc@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v3] ip: validate options before echoing them
> https://lore.kernel.org/all/20260902055802.3724915-1-4ncienth@gmail.com
> * [PATCH net v3] ip: validate options before echoing them
>
> and found the following issue:
> WARNING in __ip_options_echo
>
> Full report is available here:
> https://ci.syzbot.org/series/58d17295-c695-49b2-826d-b0fe305808e9
>
> ***
>
> WARNING in __ip_options_echo
>
> tree:      linux-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/next/=
linux-next
> base:      70f3995830d3f1e79faa14eb0605914f778feca9
> arch:      amd64
> compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~e=
xp1~20260613092250.77), Debian LLD 22.1.8
> config:    https://ci.syzbot.org/builds/9a250d6c-0a45-4565-bbc0-cac6bc3e4=
2ee/config
> syz repro: https://ci.syzbot.org/findings/5fa937c9-0c72-4a82-8221-cd01d8d=
c83d5/syz_repro
>
> ------------[ cut here ]------------
> len > ((int)(~0U >> 1))
> WARNING: ./include/linux/skbuff.h:2864 at pskb_may_pull_reason include/li=
nux/skbuff.h:2864 [inline], CPU#1: syz.0.17/5791
> WARNING: ./include/linux/skbuff.h:2864 at pskb_network_may_pull_reason in=
clude/linux/skbuff.h:3294 [inline], CPU#1: syz.0.17/5791
> WARNING: ./include/linux/skbuff.h:2864 at pskb_network_may_pull include/l=
inux/skbuff.h:3299 [inline], CPU#1: syz.0.17/5791
> WARNING: ./include/linux/skbuff.h:2864 at __ip_options_echo+0x10e4/0x1870=
 net/ipv4/ip_options.c:115, CPU#1: syz.0.17/5791
> Modules linked in:
> CPU: 1 UID: 0 PID: 5791 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:pskb_may_pull_reason include/linux/skbuff.h:2864 [inline]
> RIP: 0010:pskb_network_may_pull_reason include/linux/skbuff.h:3294 [inlin=
e]
> RIP: 0010:pskb_network_may_pull include/linux/skbuff.h:3299 [inline]
> RIP: 0010:__ip_options_echo+0x10e4/0x1870 net/ipv4/ip_options.c:115
> Code: 00 00 00 fc ff df 43 0f b6 04 3c 84 c0 0f 85 64 07 00 00 41 88 1e 4=
c 8b 64 24 10 41 83 c4 04 e9 a7 fe ff ff e8 7d 13 84 f7 90 <0f> 0b 90 e9 35=
 f1 ff ff 44 89 e7 44 89 f6 e8 79 15 84 f7 45 39 f4
> RSP: 0018:ffffc90004efef40 EFLAGS: 00010293
> RAX: ffffffff8a43a023 RBX: ffff8881b89a6b58 RCX: ffff888111125a00
> RDX: 0000000000000000 RSI: 00000000fffffff8 RDI: 0000000000000000
> RBP: ffffc90004eff070 R08: ffffc90004eff2c7 R09: 0000000000000000
> R10: ffffc90004eff2b8 R11: fffff520009dfe59 R12: 00000000fffffff8
> R13: ffff8881b89a6a80 R14: ffff8881b89a6b00 R15: 000000000000001c
> FS:  00007f39f8af86c0(0000) GS:ffff8882a8cdf000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f39f8af7ff8 CR3: 0000000112830000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  ip_options_echo include/net/ip.h:798 [inline]
>  icmp_reply+0x2da/0xc90 net/ipv4/icmp.c:429
>  icmp_timestamp+0x246/0x370 net/ipv4/icmp.c:1430
>  icmp_rcv+0xd33/0x1290 net/ipv4/icmp.c:1543
>  ip_protocol_deliver_rcu+0x2dc/0x440 net/ipv4/ip_input.c:207
>  ip_local_deliver_finish+0x3bb/0x6f0 net/ipv4/ip_input.c:241
>  NF_HOOK+0x336/0x3c0 include/linux/netfilter.h:325
>  NF_HOOK+0x336/0x3c0 include/linux/netfilter.h:325
>  __netif_receive_skb_one_core net/core/dev.c:6264 [inline]
>  __netif_receive_skb net/core/dev.c:6377 [inline]
>  netif_receive_skb_internal net/core/dev.c:6463 [inline]
>  netif_receive_skb+0x45b/0xbf0 net/core/dev.c:6522
>  tun_rx_batched+0x1de/0x790 drivers/net/tun.c:1571
>  tun_get_user+0x2be0/0x44d0 drivers/net/tun.c:2045
>  tun_chr_write_iter+0x113/0x200 drivers/net/tun.c:2091
>  new_sync_write fs/read_write.c:595 [inline]
>  vfs_write+0x612/0xba0 fs/read_write.c:687
>  ksys_write+0x150/0x270 fs/read_write.c:739
>  do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
>  do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f39f7b5e98e
> Code: 08 0f 85 a5 a8 ff ff 49 89 fb 48 89 f0 48 89 d7 48 89 ce 4c 89 c2 4=
d 89 ca 4c 8b 44 24 08 4c 8b 4c 24 10 4c 89 5c 24 08 0f 05 <c3> 66 2e 0f 1f=
 84 00 00 00 00 00 0f 1f 80 00 00 00 00 48 83 ec 08
> RSP: 002b:00007f39f8af7fb8 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
> RAX: ffffffffffffffda RBX: 00007f39f8af86c0 RCX: 00007f39f7b5e98e
> RDX: 000000000000003e RSI: 0000200000000780 RDI: 00000000000000c8
> RBP: 00007f39f7c35024 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f39f7e26038 R14: 00007f39f7e25fa0 R15: 00007fff66b2b028
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
> [4ncienth@gmail.com davem@davemloft.net dsahern@kernel.org edumazet@googl=
e.com horms@kernel.org idosch@nvidia.com kuba@kernel.org linux-kernel@vger.=
kernel.org netdev@vger.kernel.org pabeni@redhat.com]
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
-upstream-moderation/6a98961f.9266084e.bf0d7.0010.GAE%40google.com.
