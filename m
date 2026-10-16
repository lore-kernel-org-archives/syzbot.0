Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com [209.85.167.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FA94539772
	for <syzbot@lists.linux.dev>; Fri, 16 Oct 2026 16:25:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792167926; cv=none; b=LgrekfWDc0dz3VFjzXT/i3ukXuKl2oKU1jUG1HgqRmxXTR9Q4s3QmUMaaKhEhDvz1iFQ4ZiJdZUNbh+sBo1IG7+tLOHiMqjjJq+8YAIwFlbL/D/9+oykmc39nZVT1gpX79QhdjSDjIlU6Sh1ENcs0TjpeXGcbsCzghokrCnggbo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792167926; c=relaxed/simple;
	bh=XBR5TECp9HkUAA61CllU1nc35JEUMgRoh2lQMVDcRPo=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=i3/2397d/HS3+AXdcQEbR0W0mSoBIF5BCBsn9oMh5xY/DASqIhTj7lZf4ME+yimhzBzUcHOEIv7A20Xn6yd0MDOZGo2pgg7FtfuiqV6CIv9gf51x6AmM/TxofVxeChaAQec+FiuoLZ2Bgw8lXTA+NXGiy0Cy502w6tVlyawwSyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f197.google.com with SMTP id 5614622812f47-4ab8b4887d4so155875b6e.1
        for <syzbot@lists.linux.dev>; Fri, 16 Oct 2026 09:25:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792167923; x=1792772723;
        h=content-type:cc:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XvtZ+oyBQx4zDSBtqyTrknnZcMbj2d1LdXFi9CpVly0=;
        b=ud1z17KZKZY01N6LkvT9KzeZ3+GNyGfSgozvpGzrmujMPCaUzIqAlbrY6Vq8JcsxoS
         zSZTWq/gqL/fW9StQ59pW4aQ1v4cG2zKevPEUAkTA6YtY3IR1YP1qZHcugdwWF90NtYQ
         RRHSU3nW9SORcoHhmih1UtHC0gpiCSBRCZg0EzdoDZoMl/MwdfygmoODPyXGnRQ01IeZ
         g0eQkXpKWedHoGaORCW8AHhB2oykLE+M5Dl7YynpVNyTwqCPS35W2EyGgi26Fh4V+eJR
         +1MjNVRDhcZ8SdK1CUAtp5HC3YI0clBtPcb62d98IcDvSt0wwfjD2XGAPRUI6LMdAw6M
         pjyQ==
X-Gm-Message-State: AFq9FYJO8wK8lqyTyteuL3ZeJLY8hxAP7jmq+Bgp9WDJNsY2QVixZ3iX
	zAdf70fnZDJo0FNWQcfBHYwvcCFhpeS9/VAvHOougZaM+9jsB+/JTWq9Vzcxv6xZyn4hJbxpiuW
	MKq36ctDEWnJeun0++wGIs0WSJy4wVOQcRe4isLDIne/CvKomu8wKcCJitOQ=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:1914:b0:4b3:98f4:f057 with SMTP id
 5614622812f47-53cc3e3c6e2mr148159b6e.3.1792167922893; Fri, 16 Oct 2026
 09:25:22 -0700 (PDT)
Date: Fri, 16 Oct 2026 09:25:22 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6ad24ff2.7514cce4.1ece07.0154.GAE@google.com>
Subject: [moderation/CI] Re: netfilter: flowtable: do not hw offload flows in
 teardown state
From: syzbot ci <syzbot+cic50625cf0ba10512@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v1] netfilter: flowtable: do not hw offload flows in teardown state
https://lore.kernel.org/all/20261016085202.1670076-1-pablo@netfilter.org
* [PATCH nf-next] netfilter: flowtable: do not hw offload flows in teardown state

and found the following issue:
WARNING in nf_conntrack_cleanup_net_list

Full report is available here:
https://ci.syzbot.org/series/ea5f346a-b1ba-462a-a812-0b29a292b49e

***

WARNING in nf_conntrack_cleanup_net_list

tree:      nf-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netfilter/nf-next.git
base:      a5e7d8e446af9803e37a3b6a4d416fb41178348f
arch:      amd64
compiler:  Debian clang version 22.1.8 (1~deb13u4), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/90f3437c-11cd-439b-8d1a-bb938b62b48e/config
AI triage: https://ci.syzbot.org/findings/e5d88a6f-a29f-44fb-8f86-ce0834d5aa76/triage_trajectory

------------[ cut here ]------------
conntrack cleanup blocked for 60s
WARNING: net/netfilter/nf_conntrack_core.c:2504 at nf_conntrack_cleanup_net_list+0x21f/0x360, CPU#0: kworker/u8:0/12
Modules linked in:
CPU: 0 UID: 0 PID: 12 Comm: kworker/u8:0 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Workqueue: netns cleanup_net
RIP: 0010:nf_conntrack_cleanup_net_list+0x21f/0x360
Code: 4c 89 ef e8 63 bd 37 f8 4d 8b 7d 00 4d 39 ef 74 69 e8 f5 eb c6 f7 45 31 e4 e9 a5 fe ff ff e8 e8 eb c6 f7 48 8d 3d 41 56 88 07 <67> 48 0f b9 3a eb c0 89 e9 80 e1 07 80 c1 03 38 c1 0f 8c da fe ff
RSP: 0018:ffffc900001178b0 EFLAGS: 00010293
RAX: ffffffff8a011228 RBX: dffffc0000000000 RCX: ffff888102eb8000
RDX: 0000000000000000 RSI: ffffffffffffffc9 RDI: ffffffff91896870
RBP: 0000000000000021 R08: ffff888116ce7c03 R09: 1ffff11022d9cf80
R10: dffffc0000000000 R11: ffffed1022d9cf81 R12: 000000010002f152
R13: ffffc90000117a50 R14: ffffc90000117a50 R15: 000000010002f189
FS:  0000000000000000(0000) GS:ffff88818c4d4000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f6e7bd28ae0 CR3: 00000000132ca000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 ops_undo_list+0x4b4/0x8d0
 cleanup_net+0x572/0x810
 process_scheduled_works+0xc3d/0x1630
 worker_thread+0xa47/0xfb0
 kthread+0x38b/0x480
 ret_from_fork+0x514/0xb70
 ret_from_fork_asm+0x1a/0x30
 </TASK>


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
[netfilter-devel@vger.kernel.org pablo@netfilter.org]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

