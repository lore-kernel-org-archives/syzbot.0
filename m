Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23958278E7B
	for <syzbot@lists.linux.dev>; Fri, 22 Aug 2025 18:41:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755888084; cv=none; b=rEdRAqgcbXfRwll/j945ty73sFzpDZBpihOS8lqQJVgZ6erFs1qHb41oiBVrcb3d4Luipo+uQ3ULIefyMlLxLFiIGhjMl6d//MOBCR6J9OSSSkgxMdwEWu3ArclgKri3bIpopRTaiP8gE+SVirj+oYx8sgLPcn/DsQ/ziJzdAKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755888084; c=relaxed/simple;
	bh=R3s76jZVO7PsSVnQlPX9+TKKaOBb34sUrcSyY7w16UQ=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=guEdXJC4SiNQF76iGnkQWY/U8qbStP0afgZN2BoebJP7nbAn+5pJf8KpGPy0jfJZer1exVW5UogqgoV3jWJxSkY6cQyMz+fszN1urxLrd2mVLG1jO8bmVtNdfBK4MF7Hth6mNP/49/QIXhtPIoLHIfHOn6IEIIHavdgH/MvYAjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-3e6e61caf71so53185285ab.3
        for <syzbot@lists.linux.dev>; Fri, 22 Aug 2025 11:41:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755888082; x=1756492882;
        h=content-transfer-encoding:cc:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mQe5zvcky72Pput88oEQX/4MrS0g4ssq3aCq/7G+RbA=;
        b=pNxV1LMDm3GpGyjbKXZkJGnMyLXhFLtOOjYtopk/83Bpx7nFcsiKxPovutgb2q/40Z
         cF9rSZWzWEHh7GkVin4em9f/sPh2J4eb3Qovy+ANBkk4UAv8VKhiyvXRjN5RnTY5+aNr
         LWLnV5vhjQhi5AQ6FJrh0Rbj2zu+cr3urgBQ7y0KvvDey5BvEVcAin/WBDxabBTji0dF
         JbRgD0S/DZ9jmLxnKxjqelEHwHLUPNHQv9XIxeIAeVmTm3OZUfLpw3/Olg6+5n0aLpkd
         FYthbf9fPZATRMy75/PrqfXyozvY2yva6bdp0FOPv7n/r2QiXMvnnXy93wVvn40BwRsQ
         atWQ==
X-Gm-Message-State: AOJu0YwuM5UiRSWEPOeBMJxIYuPY5bH323WqMwMevP1HX74tJpQO5YR1
	qbumRG7gJUgPAFmTl0jbRW4F0opNAZHt5m/xhR8bNCcor3ZiiTJnW/FDVLXFpIgiRf0wK57PTuH
	RkeyU+VA4pwpRKIzmxH7IXP+eQ7DSBSaw2l4gQFknnra3t/GYStN73XDRIkk=
X-Google-Smtp-Source: AGHT+IHmZ/mDfEyrhMW6sdxxJgwViQQzhozMjOYiRhaCV/cyyr9X0kZ1x7n5rwH5/j5sDv01qcV83hncj0NAz8ASZgegYyB85MoF
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:12e3:b0:3e5:83c2:f77a with SMTP id
 e9e14a558f8ab-3e91cdbead8mr72448095ab.0.1755888082096; Fri, 22 Aug 2025
 11:41:22 -0700 (PDT)
Date: Fri, 22 Aug 2025 11:41:22 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68a8b9d2.050a0220.37038e.0059.GAE@google.com>
Subject: [moderation/CI] Re: ovl: Enable support for casefold layers
From: syzbot ci <syzbot+ci16957c631d6b7071@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v6] ovl: Enable support for casefold layers
https://lore.kernel.org/all/20250822-tonyk-overlayfs-v6-0-8b6e9e604fa2@igal=
ia.com
* [PATCH v6 1/9] fs: Create sb_encoding() helper
* [PATCH v6 2/9] fs: Create sb_same_encoding() helper
* [PATCH v6 3/9] ovl: Prepare for mounting case-insensitive enabled layers
* [PATCH v6 4/9] ovl: Create ovl_casefold() to support casefolded strncmp()
* [PATCH v6 5/9] ovl: Ensure that all layers have the same encoding
* [PATCH v6 6/9] ovl: Set case-insensitive dentry operations for ovl sb
* [PATCH v6 7/9] ovl: Add S_CASEFOLD as part of the inode flag to be copied
* [PATCH v6 8/9] ovl: Check for casefold consistency when creating new dent=
ries
* [PATCH v6 9/9] ovl: Support mounting case-insensitive enabled layers

and found the following issue:
WARNING in ovl_dentry_weird

Full report is available here:
https://ci.syzbot.org/series/efd002b5-e585-4cf8-86e7-4f24ba2247c7

***

WARNING in ovl_dentry_weird

tree:      torvalds
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvald=
s/linux
base:      068a56e56fa81e42fc5f08dff34fab149bb60a09
arch:      amd64
compiler:  Debian clang version 20.1.7 (++20250616065708+6146a88f6049-1~exp=
1~20250616065826.132), Debian LLD 20.1.7
config:    https://ci.syzbot.org/builds/039eb31b-2b45-4207-b63e-71a25ed89f0=
0/config
C repro:   https://ci.syzbot.org/findings/726ae90b-83b6-49e2-a496-9bfe444dc=
24f/c_repro
syz repro: https://ci.syzbot.org/findings/726ae90b-83b6-49e2-a496-9bfe444dc=
24f/syz_repro

EXT4-fs (loop0): 1 orphan inode deleted
EXT4-fs (loop0): mounted filesystem 00000000-0000-0000-0000-000000000000 r/=
w without journal. Quota mode: none.
------------[ cut here ]------------
WARNING: CPU: 0 PID: 6001 at fs/overlayfs/ovl_entry.h:118 OVL_FS fs/overlay=
fs/ovl_entry.h:118 [inline]
WARNING: CPU: 0 PID: 6001 at fs/overlayfs/ovl_entry.h:118 ovl_dentry_weird+=
0x15a/0x1a0 fs/overlayfs/util.c:206
Modules linked in:
CPU: 0 UID: 0 PID: 6001 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(ful=
l)=20
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16=
.2-1 04/01/2014
RIP: 0010:OVL_FS fs/overlayfs/ovl_entry.h:118 [inline]
RIP: 0010:ovl_dentry_weird+0x15a/0x1a0 fs/overlayfs/util.c:206
Code: e8 6b f9 8f fe 83 e5 03 0f 95 c3 31 ff 89 ee e8 9c fd 8f fe 89 d8 5b =
41 5c 41 5e 41 5f 5d e9 3d b9 4c 08 cc e8 47 f9 8f fe 90 <0f> 0b 90 e9 08 f=
f ff ff 44 89 f1 80 e1 07 80 c1 03 38 c1 0f 8c 0b
RSP: 0018:ffffc90002caf9c8 EFLAGS: 00010293
RAX: ffffffff832fb1e9 RBX: ffff888109730000 RCX: ffff888023295640
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff88802b624a48
RBP: dffffc0000000000 R08: 0000000030656c69 R09: 1ffff110048d0ce0
R10: dffffc0000000000 R11: ffffed10048d0ce1 R12: dffffc0000000000
R13: 0000000000000003 R14: ffff88802b624a48 R15: ffff888109730028
FS:  0000555581e17500(0000) GS:ffff8880b861b000(0000) knlGS:000000000000000=
0
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000200000001000 CR3: 00000000242f4000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 ovl_mount_dir_check fs/overlayfs/params.c:300 [inline]
 ovl_do_parse_layer+0x307/0xbb0 fs/overlayfs/params.c:422
 ovl_parse_layer fs/overlayfs/params.c:448 [inline]
 ovl_parse_param+0xb62/0xee0 fs/overlayfs/params.c:633
 vfs_parse_fs_param+0x1a9/0x420 fs/fs_context.c:146
 vfs_parse_fs_string fs/fs_context.c:188 [inline]
 vfs_parse_monolithic_sep+0x24d/0x310 fs/fs_context.c:230
 do_new_mount+0x273/0x9e0 fs/namespace.c:3804
 do_mount fs/namespace.c:4136 [inline]
 __do_sys_mount fs/namespace.c:4347 [inline]
 __se_sys_mount+0x317/0x410 fs/namespace.c:4324
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f0c2558ebe9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 =
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff f=
f 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffd67150878 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007f0c257b5fa0 RCX: 00007f0c2558ebe9
RDX: 0000200000000b80 RSI: 0000200000000100 RDI: 0000000000000000
RBP: 00007f0c25611e19 R08: 0000200000000180 R09: 0000000000000000
R10: 0000000000000008 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f0c257b5fa0 R14: 00007f0c257b5fa0 R15: 0000000000000005
 </TASK>


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[amir73il@gmail.com andrealmeid@igalia.com brauner@kernel.org jack@suse.cz =
kernel-dev@igalia.com krisman@kernel.org linux-fsdevel@vger.kernel.org linu=
x-kernel@vger.kernel.org linux-unionfs@vger.kernel.org miklos@szeredi.hu ty=
tso@mit.edu viro@zeniv.linux.org.uk]

If the report looks fine to you, reply with:
#syz upstream

