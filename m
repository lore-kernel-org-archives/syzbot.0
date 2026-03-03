Received: from mail-oo1-f69.google.com (mail-oo1-f69.google.com [209.85.161.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 059FF379EC4
	for <syzbot@lists.linux.dev>; Tue,  3 Mar 2026 07:55:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772524558; cv=none; b=NzUArAtSlnLmG5CturvZrcQ7nFyMnvJsIgn0VoDJWuvUqr9vVfzrzsGGDOEBXhU4uQKjNJsB/qGOrzH0XhGB6WOHB91xAi6H0o6NhT8OKnATxY6ER5mcTxCO07ndVDGu5z8UBCRbCZvykprxcFOzW4o/TS/ipBu7eN9fs8OGKnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772524558; c=relaxed/simple;
	bh=Gji/OjmRu0DwoNZkvvQ+kxjDH0bpk0ZgWsanNwBiuF4=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=QPxcdI/Ckkcse4gkUIxatTeddVG7HDyprmu5lbWZ5V0N9/7RhDBacpXM/n/c3XgfO/HcYFxPRoHZDV+L19MfTmJLGQ47i+fgb4aPCg9qw4nuRKS6x9nImE1JM7fHCCG6JysGetlXAE7oi9Qv0htxdcKkGGqG8vAdShfNAdvsxfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f69.google.com with SMTP id 006d021491bc7-6799654a158so45254349eaf.0
        for <syzbot@lists.linux.dev>; Mon, 02 Mar 2026 23:55:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772524556; x=1773129356;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FgQSOpB+ewXh4n0VbeXUwNcBjIkpybIpFZepNJXEjKc=;
        b=q7wKXXTfOnHygNCiWwGSnoLl/GZPKz1F1TYdiCSk9i8PMxrV3OpGYwC77tBlGduEZ0
         frXDTwJjbVrdQ6r3yOhh6JtcUYjweLbd/TUReRMea4w5M9p70KnNM54Zi2AYpMi45AgO
         QaeLKg1hrkxfhTyzkBjTJrCBP4jXUXkJuanxKJETkYLRf08kRiyty3aIigiwFRkG5t92
         3DsMQULq7bpE40jHpHxi5lrFzZHWKNUdVJwoNylBEaK5ZnR1Q7Q1FC70cyT/kvsjGMfk
         ZSQZRpgWzck3P3SjLnMeQoHOnoZYq3pSJnPiC+5vZ5/tGeLM97vschTfO0R2O2khkt4I
         o/EQ==
X-Gm-Message-State: AOJu0YyIDCbN50tveQsZS0Aggasx0Eq1lzqZTeOlUQ+6C1JPPETZeyDH
	ZHJxsGLWwi0qcReZAq1gTXoaakFPIn+7/FM9ZWRj+ahutsSPNUt+Ul0+Oxm5FDyGVkDACnQqHUA
	imlENb8i+1lrZ36iFwOwjwe4M9HxXSJKgpR8aMrbafgN/U7qVJcBMGEBdPSw=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:1895:b0:663:1b8:9c74 with SMTP id
 006d021491bc7-679faf8da8emr7462390eaf.68.1772524555798; Mon, 02 Mar 2026
 23:55:55 -0800 (PST)
Date: Mon, 02 Mar 2026 23:55:55 -0800
In-Reply-To: <20260302194926.90378-1-graf@amazon.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69a6940b.a70a0220.135158.0007.GAE@google.com>
Subject: [syzbot ci] Re: vsock: add G2H fallback for CIDs not owned by H2G transport
From: syzbot ci <syzbot+cid397fd2b137e247c@syzkaller.appspotmail.com>
To: arnd@arndb.de, bcm-kernel-feedback-list@broadcom.com, 
	bryan-bt.tan@broadcom.com, corbet@lwn.net, eperezma@redhat.com, 
	graf@amazon.com, gregkh@linuxfoundation.org, jasowang@redhat.com, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, mst@redhat.com, 
	netdev@vger.kernel.org, nh-open-source@amazon.com, sgarzare@redhat.com, 
	stefanha@redhat.com, virtualization@lists.linux.dev, vishnu.dasa@broadcom.com
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v2] vsock: add G2H fallback for CIDs not owned by H2G transport
https://lore.kernel.org/all/20260302194926.90378-1-graf@amazon.com
* [PATCH v2] vsock: add G2H fallback for CIDs not owned by H2G transport

and found the following issue:
WARNING in register_net_sysctl_sz

Full report is available here:
https://ci.syzbot.org/series/8be7b007-32ae-447a-bb92-b169bb844054

***

WARNING in register_net_sysctl_sz

tree:      net-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netdev/net-next.git
base:      01857fc712f6469cab9cc578120cdc80f1c2a634
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/5374f01b-dc57-486a-a2a6-2fb66c003b70/config

------------[ cut here ]------------
sysctl net/vsock/g2h_fallback: data points to kernel global data: vsock_g2h_fallback
WARNING: net/sysctl_net.c:156 at register_net_sysctl_sz+0x163/0x440, CPU#0: syz-executor/5808
Modules linked in:
CPU: 0 UID: 0 PID: 5808 Comm: syz-executor Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:register_net_sysctl_sz+0x1ad/0x440
Code: 00 00 00 fc ff df 41 80 3c 06 00 74 08 4c 89 ef e8 88 36 c8 f6 4d 8b 44 24 f0 48 89 df 48 8b 74 24 10 4c 89 fa 48 8b 4c 24 18 <67> 48 0f b9 3a 49 bf 00 00 00 00 00 fc ff df 42 0f b6 44 3d 00 84
RSP: 0018:ffffc90005357ab0 EFLAGS: 00010246
RAX: dffffc0000000000 RBX: ffffffff90234820 RCX: ffffffff8d01a100
RDX: ffffffff8d05e680 RSI: ffffffff8d05e620 RDI: ffffffff90234820
RBP: 1ffff110212d6810 R08: ffffffff8ff4f0c0 R09: ffffffff8e7602e0
R10: 0000012400000008 R11: ffffffff9a79ce5c R12: ffff8881096b4088
R13: ffff8881096b4078 R14: 1ffff110212d680f R15: ffffffff8d05e680
FS:  000055556a136500(0000) GS:ffff88818de66000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f0c19e52af8 CR3: 0000000112a0e000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 vsock_sysctl_init_net+0x13f/0x2f0
 ops_init+0x35c/0x5c0
 setup_net+0x118/0x340
 copy_net_ns+0x50e/0x730
 create_new_namespaces+0x3e7/0x6a0
 unshare_nsproxy_namespaces+0x11a/0x160
 ksys_unshare+0x51d/0x930
 __x64_sys_unshare+0x38/0x50
 do_syscall_64+0x14d/0xf80
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fd97459da67
Code: 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 b8 10 01 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fffee0fc138 EFLAGS: 00000246 ORIG_RAX: 0000000000000110
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007fd97459da67
RDX: 00007fd97459c799 RSI: 00007fffee0fc100 RDI: 0000000040000000
RBP: 00007fffee0fc190 R08: 00007fd9747d9610 R09: 00007fd9747d9610
R10: 0000000000000000 R11: 0000000000000246 R12: 00007fffee0fc198
R13: 0000000000000002 R14: 00007fffee0fc378 R15: 0000000000000000
 </TASK>


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.
