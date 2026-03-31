Received: from mail-oo1-f70.google.com (mail-oo1-f70.google.com [209.85.161.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAA0D4035DC
	for <syzbot@lists.linux.dev>; Tue, 31 Mar 2026 15:27:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774970877; cv=none; b=bBIKQRT14qwuGT4VSMarlfbqS0TK6scGYTvK2hHv8QJd7MPh02P0CwbJuLxMLLz3QRvOK8AarLdRN7onbotXmsHiZPzEQcRnRWJyq5fQzt1hA8lsEqQTcKXxD/RdEkcVrEiYfsQ2xA/41KhmEs7vex1n6KagnHQ8O5U71FR+jno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774970877; c=relaxed/simple;
	bh=ZeV/HTpCnlpuMTI6n7oNBTLP3emgGYWZl2w3UzH6p0Q=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=KwiyvKK27NXvbWhk9vahZxP7CJ4Chl81cYkoYZ1nSk2T74NR+JEOaWq2jedhkg62HnritcJv2bKnnMTssWLb16kG1I7MLgmXIhDFW7/VI8SwKutk7Gg+4Si7Z1fePdhOtBKa6s/xFwJz+RnW2+sBUdeZkGRjHO18EXnbp0gOmLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f70.google.com with SMTP id 006d021491bc7-67de56b5bd4so21031587eaf.0
        for <syzbot@lists.linux.dev>; Tue, 31 Mar 2026 08:27:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774970875; x=1775575675;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Qug8kI7bJnvWGV6+b5kYjq7l7uNaiQDPNBvw893TZUE=;
        b=WQa6Zjzu4NgfN4OeefTF1EzHJHq2ApYGwGJAej5d24rlblCneLoa/QzmKzDz8OLerh
         +qBHo5e02Ya+9GcSossR1iMPBPbnqaDqKAe0bd6HIbEe4JYcpPBfSZVUk4aGlrj5+Dm9
         urA2AZdl9TZ01j8b28mgunAsJ7zIiuB7ezo3AgEw4BCBQt0xjbkBP00yAfU0IMP5xOUv
         lmpyfx0M2eZe0HjV/o8SWL6G5o1mgGWzyPQbkl+pmTPS+tquZvf9HD3b3ZZysNxcV8sh
         62ALhsyvhphgUXTm+re2qfLUGlPa2R/F/FvUmVC7pBj9QOwOKJ6tvqAdEr9vOPzGAu9/
         CA3Q==
X-Gm-Message-State: AOJu0YyE9EVliSf0Zt8J+v9WQpJTr3YcUw6OQgHGxmx7/p4neDCIwPRe
	fJLed7A3W7o6jpowwKLPfdhg0HolT1QV2c/QTw8CfxFNga29V5bT1lltwZ5NxizLNKLJe8guU0+
	NrKmymSquRu2fb5FyhzbKqcFnK+Z9UAl77P4fck5wt0DfcIOQwh558i0h5TA=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:821:b0:67e:2c7f:9f13 with SMTP id
 006d021491bc7-67e2c7fa105mr6151264eaf.49.1774970874862; Tue, 31 Mar 2026
 08:27:54 -0700 (PDT)
Date: Tue, 31 Mar 2026 08:27:54 -0700
In-Reply-To: <20260331091113.20882-1-chizhiling@163.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69cbe7fa.a70a0220.97f31.02a0.GAE@google.com>
Subject: [syzbot ci] Re: exfat: unify FAT chain walking helpers
From: syzbot ci <syzbot+cibb1b309487cd428b@syzkaller.appspotmail.com>
To: chizhiling@163.com, chizhiling@kylinos.cn, linkinjeon@kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	sj1557.seo@samsung.com, yuezhang.mo@sony.com
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v1] exfat: unify FAT chain walking helpers
https://lore.kernel.org/all/20260331091113.20882-1-chizhiling@163.com
* [PATCH v1 1/6] exfat: fix incorrect directory checksum after rename to shorter name
* [PATCH v1 2/6] exfat: introduce exfat_fat_walk helper
* [PATCH v1 3/6] exfat: use exfat_fat_walk helper to simplify fat entry walking
* [PATCH v1 4/6] exfat: remove NULL cache pointer case in exfat_ent_get
* [PATCH v1 5/6] exfat: introduce exfat_chain_advance helper
* [PATCH v1 6/6] exfat: use exfat_chain_advance helper

and found the following issue:
WARNING in exfat_find_empty_entry

Full report is available here:
https://ci.syzbot.org/series/d9d5a999-e11a-43e1-ac76-9c718e136f25

***

WARNING in exfat_find_empty_entry

tree:      linux-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/next/linux-next
base:      d1d75eaf01abceb3d5cb50253375b5f254b6be54
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/177ab8e9-7eef-44cc-8b1d-6e8e2b44adaf/config
C repro:   https://ci.syzbot.org/findings/9b0e35b9-b5be-440e-9461-2f19c03cb16a/c_repro
syz repro: https://ci.syzbot.org/findings/9b0e35b9-b5be-440e-9461-2f19c03cb16a/syz_repro

exFAT-fs (loop0): start_clu is invalid cluster(0xffffffff)
exFAT-fs (loop0): valid_size(150994954) is greater than size(10)
------------[ cut here ]------------
chain->dir != EXFAT_EOF_CLUSTER
WARNING: fs/exfat/exfat_fs.h:575 at exfat_chain_advance fs/exfat/exfat_fs.h:575 [inline], CPU#0: syz.0.17/5981
WARNING: fs/exfat/exfat_fs.h:575 at exfat_search_empty_slot fs/exfat/namei.c:249 [inline], CPU#0: syz.0.17/5981
WARNING: fs/exfat/exfat_fs.h:575 at exfat_find_empty_entry+0x754/0x13b0 fs/exfat/namei.c:318, CPU#0: syz.0.17/5981
Modules linked in:
CPU: 0 UID: 0 PID: 5981 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:exfat_chain_advance fs/exfat/exfat_fs.h:575 [inline]
RIP: 0010:exfat_search_empty_slot fs/exfat/namei.c:249 [inline]
RIP: 0010:exfat_find_empty_entry+0x754/0x13b0 fs/exfat/namei.c:318
Code: 00 bf ff ff ff ff 44 89 e6 e8 18 56 1f ff 41 83 fc ff 75 10 e8 cd 51 1f ff 45 29 ee 0f 8d ad fe ff ff eb 12 e8 bd 51 1f ff 90 <0f> 0b 90 45 29 ee 0f 8d 99 fe ff ff e8 ab 51 1f ff 41 01 df 48 8b
RSP: 0018:ffffc9000499f340 EFLAGS: 00010293
RAX: ffffffff82a639c3 RBX: 0000000000000020 RCX: ffff88816d588000
RDX: 0000000000000000 RSI: 000000000000000b RDI: 00000000ffffffff
RBP: ffffc9000499f570 R08: ffff888119e14a5b R09: 1ffff110233c294b
R10: dffffc0000000000 R11: ffffed10233c294c R12: 000000000000000b
R13: 0000000000000080 R14: 0000000000000000 R15: 0000000000000060
FS:  000055557e214500(0000) GS:ffff88818de66000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000200000006200 CR3: 00000001bcf7c000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 exfat_rename_file fs/exfat/namei.c:1025 [inline]
 __exfat_rename fs/exfat/namei.c:1177 [inline]
 exfat_rename+0xb49/0x1f90 fs/exfat/namei.c:1251
 vfs_rename+0xa96/0xeb0 fs/namei.c:6026
 filename_renameat2+0x539/0x9c0 fs/namei.c:6144
 __do_sys_rename fs/namei.c:6188 [inline]
 __se_sys_rename+0x55/0x2c0 fs/namei.c:6184
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f66f1b9c819
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffcad04e2e8 EFLAGS: 00000246 ORIG_RAX: 0000000000000052
RAX: ffffffffffffffda RBX: 00007f66f1e15fa0 RCX: 00007f66f1b9c819
RDX: 0000000000000000 RSI: 0000200000000400 RDI: 0000200000006200
RBP: 00007f66f1c32c91 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f66f1e15fac R14: 00007f66f1e15fa0 R15: 00007f66f1e15fa0
 </TASK>


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

To test a patch for this bug, please reply with `#syz test`
(should be on a separate line).

The patch should be attached to the email.
Note: arguments like custom git repos and branches are not supported.
