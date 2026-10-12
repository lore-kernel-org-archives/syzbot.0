Received: from mail-oa1-f70.google.com (mail-oa1-f70.google.com [209.85.160.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B7D72AD03
	for <syzbot@lists.linux.dev>; Mon, 12 Oct 2026 09:14:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791796477; cv=none; b=RMC83UKreKqdWrlEBdQe/2S6PMxIPU8rpFCFQjt+klGe93ybw/KUhfY68H0y6QaEPM65ifSHrktVuQ0xfOKDplh4zlccUeglD0v4LDmfuFSJYQTkHq+Sl/wHEzACo45JHJLJpT8MtSopVZPW+BHrFkoT/OObKG0nHwaJGt2mOJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791796477; c=relaxed/simple;
	bh=TTlBHqBtOjM1yQllKhhF6BhyNKfFtgcJYGTBTJ2XIMU=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=LfGDE7Ak1J95lkMP59K/0CyjYQbJio5fpiyP4MTIc7ZwsOe1tc3K9vCORplXdBnn73e+RS+1W6tvIC3Dvs2khEizrPK29qNMsX6Qc6xKLbxXPDCY8iXD0hjd/AF1TbBooOId1qa4vHXVh4CEiPg7QFsgsJdX/QuoTfDQ6L8vWQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.160.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oa1-f70.google.com with SMTP id 586e51a60fabf-482966c4f4fso4804724fac.1
        for <syzbot@lists.linux.dev>; Mon, 12 Oct 2026 02:14:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791796475; x=1792401275;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:date:mime-version:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=SABAMvyVJiuHlTY2Rl3ChI9t7r0SZUuA6N8uoPsKLI0=;
        b=n3aNCvfB+os8wRsVh9cop//oXeIjXL3MBGk815m3dI0mAXN10v/3RpOXRV9oay66Xo
         vl5KfeB98f+kGXH8BFKvf/bxcXIWCU/PInfe97cranwIBUAavvvo+IAnkBzLJ9wy85LZ
         akf3z9K3+lNw4rrY24eGGiaNs6TCIeTaP4xuf87a85VNPUVUbWGs32f4rs4In6I9zKts
         SXJ/C7JIvszri314Cr8PRhdvvsPt4iSIXWzGQmzIhScQFmEfS12mt5a3CPKFR8A8N3/p
         cVkmafOk5BauemWHnOZJWIVjs0g64niKkjMGd9Sgd0wR3PdOZ3wZ6idBTSnJn9OcsAXd
         m4Zw==
X-Gm-Message-State: AFq9FYJsqXy+hyh1D+HNiDhfDZ1KOlHmWTZTZ7czWDZpI7/t3kMxCXJx
	7nNnE9NJUjPLAq93i25Baz4v9lUu6vKudOTa1wFgoWZ2X8kG8ndt6mW2RtlNLhItAaVobxqJIfV
	IsWl8V/e8K7inU2lRck7q5dh2/CXbopveeYAr2esz0OomkqvJXlZQGYalqjM=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:f94:b0:4ea:935e:43d6 with SMTP id
 5614622812f47-50b6836a688mr6882267b6e.45.1791796474989; Mon, 12 Oct 2026
 02:14:34 -0700 (PDT)
Date: Mon, 12 Oct 2026 02:14:34 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6acca4fa.8cdf6287.1eb53.0121.GAE@google.com>
Subject: [moderation/CI] Re: net/sched: sch_netem: prevent packet length
 underflow with negative overhead
From: syzbot ci <syzbot+ci0bf0ce1b639f8936@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v2] net/sched: sch_netem: prevent packet length underflow with negative ov=
erhead
https://lore.kernel.org/all/20261012044322.503949-1-dungvn2345@gmail.com
* [PATCH net v2] net/sched: sch_netem: prevent packet length underflow with=
 negative overhead

and found the following issue:
divide error in netem_enqueue

Full report is available here:
https://ci.syzbot.org/series/eff5cc04-13f7-4a28-9b83-b6e0de530bc2

***

divide error in netem_enqueue

tree:      net
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netdev/=
net.git
base:      af32da41b0327b9c6a37856ba82b6760d6c8d10e
arch:      amd64
compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp=
1~20260613092250.77), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/bf12d8a1-2cda-46fc-9150-cadd809b1c7=
1/config
AI triage: https://ci.syzbot.org/findings/421fe233-e7de-4584-b674-8e64cbd21=
195/triage_trajectory

Oops: divide error: 0000 [#1] SMP KASAN PTI
CPU: 0 UID: 0 PID: 17390 Comm: syz.0.2912 Not tainted syzkaller #0 PREEMPT(=
full)=20
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16=
.2-1 04/01/2014
RIP: 0010:netem_enqueue+0x20f6/0x3300
Code: 8b 74 24 38 48 8b 44 24 50 42 80 3c 28 00 74 08 4c 89 f7 e8 cc f4 51 =
f8 49 8b 0e 4c 89 f8 48 f7 25 b7 9c 8b 04 48 89 4c 24 78 <48> f7 74 24 78 4=
8 b9 ff ff ff ff ff ff ff 7f 48 39 c8 48 0f 42 c8
RSP: 0018:ffffc900082cf4b0 EFLAGS: 00010a07
RAX: 3599740d73380000 RBX: 0000005c44b22572 RCX: 000000000000002c
RDX: 0000000000000077 RSI: 00000000000001ed RDI: 00000000000001ee
RBP: ffff88810e973000 R08: ffffffff917a717f R09: 1ffffffff22f4e2f
R10: dffffc0000000000 R11: ffffffff81776d40 R12: ffff888026e62330
R13: dffffc0000000000 R14: ffff88810e9732b0 R15: 0000020000176c00
FS:  00007f87167196c0(0000) GS:ffff88818c4bf000(0000) knlGS:000000000000000=
0
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f8716718ff8 CR3: 000000002756e000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 netem_enqueue+0x16f1/0x3300
 dev_qdisc_enqueue+0x4e/0x260
 __dev_queue_xmit+0x1b6c/0x3920
 packet_sendmsg+0x3f11/0x51a0
 sock_sendmsg_nosec+0x13a/0x180
 __sys_sendto+0x408/0x5a0
 __x64_sys_sendto+0xde/0x100
 do_syscall_64+0x166/0x520
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f871579e1d9
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 =
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff f=
f 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f8716719028 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
RAX: ffffffffffffffda RBX: 00007f8715a25fa0 RCX: 00007f871579e1d9
RDX: 00000000000005dc RSI: 0000200000000280 RDI: 0000000000000009
RBP: 00007f8715835888 R08: 0000200000000140 R09: 0000000000000014
R10: 0000000000004009 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f8715a26038 R14: 00007f8715a25fa0 R15: 00007ffc85273198
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:netem_enqueue+0x20f6/0x3300
Code: 8b 74 24 38 48 8b 44 24 50 42 80 3c 28 00 74 08 4c 89 f7 e8 cc f4 51 =
f8 49 8b 0e 4c 89 f8 48 f7 25 b7 9c 8b 04 48 89 4c 24 78 <48> f7 74 24 78 4=
8 b9 ff ff ff ff ff ff ff 7f 48 39 c8 48 0f 42 c8
RSP: 0018:ffffc900082cf4b0 EFLAGS: 00010a07
RAX: 3599740d73380000 RBX: 0000005c44b22572 RCX: 000000000000002c
RDX: 0000000000000077 RSI: 00000000000001ed RDI: 00000000000001ee
RBP: ffff88810e973000 R08: ffffffff917a717f R09: 1ffffffff22f4e2f
R10: dffffc0000000000 R11: ffffffff81776d40 R12: ffff888026e62330
R13: dffffc0000000000 R14: ffff88810e9732b0 R15: 0000020000176c00
FS:  00007f87167196c0(0000) GS:ffff88818c4bf000(0000) knlGS:000000000000000=
0
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f8716718ff8 CR3: 000000002756e000 CR4: 00000000000006f0


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

To test a fix for this bug, please reply with `#syz test`
(on a separate line) and attach the patch to the email.

Notes:
- The patch will be applied on top of the tested series (as an
  incremental fix).
- To test a new version of the whole series, please send it directly
  to syzbot@lists.linux.dev.
- Arguments like custom git repos and branches are not supported.

The email will later be sent to:
[davem@davemloft.net dungvn2345@gmail.com edumazet@kernel.org hagen@jauu.ne=
t horms@kernel.org jhs@mojatatu.com jiri@resnulli.us kuba@kernel.org linux-=
kernel@vger.kernel.org netdev@vger.kernel.org pabeni@redhat.com stable@vger=
.kernel.org stephen@networkplumber.org]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

