Received: from mail-oo1-f44.google.com (mail-oo1-f44.google.com [209.85.161.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06E212F0661
	for <syzbot@lists.linux.dev>; Wed, 10 Sep 2025 20:51:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757537487; cv=none; b=LXfKdJsp6YostVObGXsKX4r9tH375gcRAfLlFFyvmsCu+15iXuF5G5P8a1DhWM0QbfZ0NlxDd0eyvU8jNpiILHbGzgKFJmgST4o5vOGVy+F45Iu6P4129QuHPPp9u53kc6VW3uyYqrmx9kGRZ7n+6KOmq3FSIq5Hqe5/F1yY2T4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757537487; c=relaxed/simple;
	bh=2ZSjXmtKgB4D5ZZ5Hi+0bxQ/yNtN8/HOYmNNcHSoMlE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GvU757HGoYfnctaFILxUli/uBALluHqDQQw+KddZIwIAh0nfZHPMwbJrFQ1hS95gb62hfLFMebX6/NBv8J3VzO8dJf7+6ClqXDtS6T4T0Yb9L56Xj6y0GzMsWudX12X+UyBpRD8szQ5UYeMs4lmAtfjuBW5i4jpDJRH2AfQ69pk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4rwJ9s7g; arc=none smtp.client-ip=209.85.161.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4rwJ9s7g"
Received: by mail-oo1-f44.google.com with SMTP id 006d021491bc7-62182f350ddso17064eaf.3
        for <syzbot@lists.linux.dev>; Wed, 10 Sep 2025 13:51:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757537484; x=1758142284; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AFhNFtG/FKjLYIYX4YXwQ/v77CapZVtGoXalqI+TRoQ=;
        b=4rwJ9s7g2wnqSfWGe53ZW3Nr5Mpa3CdH1hode5NUj0pCZC1sR1p8BLTFXUj9gNXlNj
         IfYvVc/UihtdjPi7TyW9DBqVwBD++eeD5gtGaoOcza+FY+x542o9DeUFHo6hRqfSaa9i
         10RwY4Ymcj4lz8V4+zp9kpGh9NE6d+c4DIK1LvlsdlO3hfH8KeDxs5oKudTP484Sg1ve
         WJFAQzAVf1pLy44KHXdkMbkSMl7Kx/gHzHcAzKFJKnnYtzXMqARzLY+fclBzmhqBu7wH
         XPnRqVfPjJKb4jsjtqdDERjcNMbBSWmVMpdnFVZzvh79o6cZGJMAy2mMaGrIuv37r+L/
         Wweg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757537484; x=1758142284;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AFhNFtG/FKjLYIYX4YXwQ/v77CapZVtGoXalqI+TRoQ=;
        b=tlgi2cRQn24pfMII8j5N0bUcJVYL0ZNimiOCukAuIY/JHKwMdB9hb1pYdFmtd0IqQB
         Rg+qrm9kUseOMozWPrTNIcZFpmI2ayw4BbREBeSOFMGabhGskZRQgZFs1FQxuXJ4Dr3v
         htnNbLlYOI3jrk1dABdGAM9bnOKpxX62zQLGphexRlcw8odQeDTHKr2yNnPq1YciSNFD
         bCJHrDup09aUZDFLVtKf3Lk2YnLPvAbEa4Hr5m98gh7cShFuXeIFc0bZLK5Sn8gT7Jvy
         Znfvp8dEv3pDUbVOWv1+Ad/lHgdyWIfEL61p9hlLKHX7Jpz2VmBm4vRO143l4fWuXr9L
         vv8Q==
X-Forwarded-Encrypted: i=1; AJvYcCVI6+Ez3okckuT0HWjfZTxwo0AEMQbXeDwvzfp9/cWNqG0zWOr1pE3PlsOtrT8+/Rmdr0skCFU=@lists.linux.dev
X-Gm-Message-State: AOJu0YwDbAp5lzcVmlaLFEeuzkbNLW67lF9F/7Z81nhF9qza0FjgK2+R
	J5IwI5LNpjk0HP4DhIV0TV6BCUGo4x140VJHndlT83IRerB5Kjn2QPAQ7+H2zqw5G7xze6VD2e2
	IFjLxnT0YXUm/4H2Hdr7eDpJvsE2Sf7sxqAXLL4AA
X-Gm-Gg: ASbGncs5i5LvxNq5eZo0n2xxtb/J1k2QV2hZ/5Z1eAhWg9DhtTf3ogIRmlgZ6yN9h4c
	lPYkWBvsOr0+joULCvL03wfdCWg/hoC21D5erbRH4nH2vBYmkcgtbPVDyPqGMVn6NK6zxJFM4mS
	XJNg4l9Dg/GoK1lYgcuBubmh9if0XKlde4DUCorCZf86Tdya4ME/MlbK3NrWR7L/cYFrtCwoHFB
	pOuKEAcrpKNj+e/gkN6SmmqGlSwzFqsLkmHQrxqVe7FlC5Pbbmu0BCV1A==
X-Google-Smtp-Source: AGHT+IFigbmjPKR/oXJqsL2g5ADzu7T+RrTLH92TMAAEGATlEcD4BDWSbh841fVNxWflyufyEv6zb4113SLXx8vv334=
X-Received: by 2002:a05:6820:509:b0:621:7820:a28 with SMTP id
 006d021491bc7-62178aa41fdmr7100757eaf.8.1757537483743; Wed, 10 Sep 2025
 13:51:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <68c1c97a.050a0220.3c6139.0028.GAE@google.com> <CANp29Y7RVhTvvBcYBnBk=0z148EiTUco=s8cea3GjBf63RLSbA@mail.gmail.com>
In-Reply-To: <CANp29Y7RVhTvvBcYBnBk=0z148EiTUco=s8cea3GjBf63RLSbA@mail.gmail.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Wed, 10 Sep 2025 22:51:12 +0200
X-Gm-Features: Ac12FXwXPlTehF8DUTK93LzhrzC80iheHZiiLHnISN9WApbiNYblNjNEgqYOoqU
Message-ID: <CANp29Y4KyZoy-uRvnGgUhV6YwFLzZ=-2ezc1gGeEU32ByO1Qtg@mail.gmail.com>
Subject: Re: [moderation/CI] Re: ns: support file handles
To: syzbot ci <syzbot+cif2f740615df66e76@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream


On Wed, Sep 10, 2025 at 10:49=E2=80=AFPM Aleksandr Nogikh <nogikh@google.co=
m> wrote:
>
> #syz upstream
>
> On Wed, Sep 10, 2025 at 8:54=E2=80=AFPM syzbot ci <syzbot+cif2f740615df66=
e76@syzkaller.appspotmail.com> wrote:
>>
>> syzbot ci has tested the following series
>>
>> [v1] ns: support file handles
>> https://lore.kernel.org/all/20250910-work-namespace-v1-0-4dd56e7359d8@ke=
rnel.org
>> * [PATCH 01/32] pidfs: validate extensible ioctls
>> * [PATCH 02/32] nsfs: validate extensible ioctls
>> * [PATCH 03/32] block: use extensible_ioctl_valid()
>> * [PATCH 04/32] ns: move to_ns_common() to ns_common.h
>> * [PATCH 05/32] nsfs: add nsfs.h header
>> * [PATCH 06/32] ns: uniformly initialize ns_common
>> * [PATCH 07/32] mnt: use ns_common_init()
>> * [PATCH 08/32] ipc: use ns_common_init()
>> * [PATCH 09/32] cgroup: use ns_common_init()
>> * [PATCH 10/32] pid: use ns_common_init()
>> * [PATCH 11/32] time: use ns_common_init()
>> * [PATCH 12/32] uts: use ns_common_init()
>> * [PATCH 13/32] user: use ns_common_init()
>> * [PATCH 14/32] net: use ns_common_init()
>> * [PATCH 15/32] ns: remove ns_alloc_inum()
>> * [PATCH 16/32] nstree: make iterator generic
>> * [PATCH 17/32] mnt: support iterator
>> * [PATCH 18/32] cgroup: support iterator
>> * [PATCH 19/32] ipc: support iterator
>> * [PATCH 20/32] net: support iterator
>> * [PATCH 21/32] pid: support iterator
>> * [PATCH 22/32] time: support iterator
>> * [PATCH 23/32] userns: support iterator
>> * [PATCH 24/32] uts: support iterator
>> * [PATCH 25/32] ns: add to_<type>_ns() to respective headers
>> * [PATCH 26/32] nsfs: add current_in_namespace()
>> * [PATCH 27/32] nsfs: support file handles
>> * [PATCH 28/32] nsfs: support exhaustive file handles
>> * [PATCH 29/32] nsfs: add missing id retrieval support
>> * [PATCH 30/32] tools: update nsfs.h uapi header
>> * [PATCH 31/32] selftests/namespaces: add identifier selftests
>> * [PATCH 32/32] selftests/namespaces: add file handle selftests
>>
>> and found the following issue:
>> WARNING in copy_net_ns
>>
>> Full report is available here:
>> https://ci.syzbot.org/series/bc3dfd83-98cc-488c-b046-f849c79a6a41
>>
>> ***
>>
>> WARNING in copy_net_ns
>>
>> tree:      net-next
>> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netd=
ev/net-next.git
>> base:      deb105f49879dd50d595f7f55207d6e74dec34e6
>> arch:      amd64
>> compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~=
exp1~20250708183702.136), Debian LLD 20.1.8
>> config:    https://ci.syzbot.org/builds/a560fd28-b788-4442-a7c8-10c6240b=
4dbf/config
>> syz repro: https://ci.syzbot.org/findings/18e91b10-567e-4cae-a279-8a5f2f=
2cde80/syz_repro
>>
>> ------------[ cut here ]------------
>> ida_free called for id=3D1326 which is not allocated.
>> WARNING: CPU: 0 PID: 6146 at lib/idr.c:592 ida_free+0x280/0x310 lib/idr.=
c:592
>> Modules linked in:
>> CPU: 0 UID: 0 PID: 6146 Comm: syz.1.60 Not tainted syzkaller #0 PREEMPT(=
full)
>> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1=
.16.2-1 04/01/2014
>> RIP: 0010:ida_free+0x280/0x310 lib/idr.c:592
>> Code: 00 00 00 00 fc ff df 48 8b 5c 24 10 48 8b 7c 24 40 48 89 de e8 d1 =
8a 0c 00 90 48 c7 c7 80 ee ba 8c 44 89 fe e8 11 87 12 f6 90 <0f> 0b 90 90 e=
b 34 e8 95 02 4f f6 49 bd 00 00 00 00 00 fc ff df eb
>> RSP: 0018:ffffc9000302fba0 EFLAGS: 00010246
>> RAX: c838d58ce4bb0000 RBX: 0000000000000a06 RCX: ffff88801eac0000
>> RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000002
>> RBP: ffffc9000302fca0 R08: ffff88804b024293 R09: 1ffff11009604852
>> R10: dffffc0000000000 R11: ffffed1009604853 R12: 1ffff92000605f78
>> R13: dffffc0000000000 R14: ffff888026c1fd00 R15: 000000000000052e
>> FS:  00007f6d7aab16c0(0000) GS:ffff8880b8613000(0000) knlGS:000000000000=
0000
>> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> CR2: 0000200000004000 CR3: 000000002726e000 CR4: 00000000000006f0
>> Call Trace:
>>  <TASK>
>>  copy_net_ns+0x37a/0x510 net/core/net_namespace.c:593
>>  create_new_namespaces+0x3f3/0x720 kernel/nsproxy.c:110
>>  unshare_nsproxy_namespaces+0x11c/0x170 kernel/nsproxy.c:218
>>  ksys_unshare+0x4c8/0x8c0 kernel/fork.c:3127
>>  __do_sys_unshare kernel/fork.c:3198 [inline]
>>  __se_sys_unshare kernel/fork.c:3196 [inline]
>>  __x64_sys_unshare+0x38/0x50 kernel/fork.c:3196
>>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>>  do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
>>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>> RIP: 0033:0x7f6d79b8eba9
>> Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 =
f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 f=
f ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
>> RSP: 002b:00007f6d7aab1038 EFLAGS: 00000246 ORIG_RAX: 0000000000000110
>> RAX: ffffffffffffffda RBX: 00007f6d79dd5fa0 RCX: 00007f6d79b8eba9
>> RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000062040200
>> RBP: 00007f6d79c11e19 R08: 0000000000000000 R09: 0000000000000000
>> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
>> R13: 00007f6d79dd6038 R14: 00007f6d79dd5fa0 R15: 00007ffd5ab830f8
>>  </TASK>
>>
>>
>> ***
>>
>> If these findings have caused you to resend the series or submit a
>> separate fix, please add the following tag to your commit message:
>>   Tested-by: syzbot@syzkaller.appspotmail.com
>>
>> ---
>> This report is generated by a bot. It may contain errors.
>> syzbot ci engineers can be reached at syzkaller@googlegroups.com.
>>
>> The email will later be sent to:
>> [amir73il@gmail.com axboe@kernel.dk brauner@kernel.org cgroups@vger.kern=
el.org chuck.lever@oracle.com cyphar@cyphar.com daan.j.demeyer@gmail.com ed=
umazet@google.com hannes@cmpxchg.org horms@kernel.org jack@suse.cz jlayton@=
kernel.org josef@toxicpanda.com kuba@kernel.org linux-block@vger.kernel.org=
 linux-fsdevel@vger.kernel.org linux-kernel@vger.kernel.org linux-kselftest=
@vger.kernel.org linux-nfs@vger.kernel.org me@yhndnzj.com mkoutny@suse.com =
mzxreary@0pointer.de netdev@vger.kernel.org pabeni@redhat.com tj@kernel.org=
 viro@zeniv.linux.org.uk zbyszek@in.waw.pl]
>>
>> If the report looks fine to you, reply with:
>> #syz upstream
>>
>> --
>> You received this message because you are subscribed to the Google Group=
s "syzkaller-upstream-moderation" group.
>> To unsubscribe from this group and stop receiving emails from it, send a=
n email to syzkaller-upstream-moderation+unsubscribe@googlegroups.com.
>> To view this discussion visit https://groups.google.com/d/msgid/syzkalle=
r-upstream-moderation/68c1c97a.050a0220.3c6139.0028.GAE%40google.com.
