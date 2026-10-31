Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.167.200
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793429979;
	b=SFFHUbKGSdVcf9f8KY8xJIdsMEIuBZObkTMwr2bm5iIyhOyaK+8umHsZBezrqSdxs1yR
	 hpKzUmFDW8FDDysoEeFmZIy2s8KiqrLcE0ZeDP1l6QG/OZZWCTo60uLz664llHvy8GlnP
	 HidANEvfnCDg+5EcNx+m0PCS+4ZeE9xY75T/pZAiM5gsNxlupvPo2kb7x4rS8JCbxmHCg
	 y8dGpS/TI3OZwvFvFApwl+OF0oyCowlO2WYuIaengfMyxm0q584c+9XWtOCkB/C9WkSA+
	 trFMRckM4ZcBoMDtAls5xTgYOxxMkU520ikamczNikuHWJLY5E27mmJC1P4pTDN7+Qg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793429979;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 MIME-Version:X-Received:Date:X-Google-Appengine-App-Id:
	 X-Google-Appengine-App-Id-Alias:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=81stFW4VRV1AbWlctql2FsItTKcWGiUadRJdFHsv3ys=;
	b=MGzPaTeyj0m8pEtZ4l0bn2pKVfMRNghN3r1YCpMcny9+OM1YWcI2V53XKwLJ0jfV37ai
	 YUt427QM9/oDNr1Kixi8JOr0qnej7avCd6C5TnvzcPHpSr4zlVsV4qvQQ1rd3dveCVaAP
	 5NjVVqeNLOLGzia8k/lKIcaq8d7CwUXtPBIr0f1uIHV0LwerPoBYzlxzjuT+ZpxSyJGUQ
	 y9O8L3VhGhzzBmbJHToDRqJN7+dZYLrkUQu49mZMwF0g9y0n9PDq8XhvAiCqIoDmcXyzI
	 OXOCOgwyzabaBamEZyHMVsh2Yavh2TcUMipB5qou/SvcPxTKLEkR0pPcJkqGT7F2ckA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=syzkaller.appspotmail.com;
	spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	arc=none smtp.remote-ip=209.85.167.200
Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com [209.85.167.200])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2746E606A31A
	for <syzbot@lists.linux.dev>; Sat, 31 Oct 2026 06:59:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2746E606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f200.google.com with SMTP id 5614622812f47-4e937c5bd4fso1180985b6e.2
        for <syzbot@lists.linux.dev>; Fri, 30 Oct 2026 23:59:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793429978; x=1794034778;
        h=content-type:cc:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=81stFW4VRV1AbWlctql2FsItTKcWGiUadRJdFHsv3ys=;
        b=dLBz900RJPR7akslU9Z89GeIirN7WMnyjZP6g6ETzCU8Oq/q5vkJhrifHjGlXMkYTD
         CexRLGqpdTlTyMF07zRbn/ZhKtCyzK1tZdQmJcIino67FS4272KUIKN7DnPki7831/Kt
         PCh+vdRa7PoVAw1bnq4GIAkE7inBIwW7cAC1uSfbgn4Alu4SwpUckqYj0l40SYdf6xFU
         +GaUUJolcRJg9RLviy+vv76AmKCKo0/JHyIjDA9Xe3nzGV1+Ad89T6/2d6Zp/edzd0nZ
         nBqqQHnr34mZX+2pi/H9ao29iA5CGsK1nUo8kxIWuQgOnY0g3lGPBKb4E5rk1HX3LDnq
         y2jQ==
X-Gm-Message-State: AFq9FYKfNZ56DW/A1xqYWIoPfAigJR3bzZ7YKhRhwJR6GC7FqhPH2TVm
	0oiApJWDIo8DU9kvtOGYvcbhcZJWSHXuy/AbCmL5CHUvmLuy33Tm7/QP1sT74X9otKLlcxIyKXs
	CMhjhTKRBz2n0uzwr7Xv/Toil/U9fA6boavZf/WKT/BTHEPUZdzLg8f27mf0=
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Post: <mailto:syzbot@lists.linux.dev>
List-Help: <mailto:syzbot+help@lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
List-Owner: <mailto:syzbot+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-Received: by 2002:a05:6808:2218:b0:4f5:41f:fdba with SMTP id
 5614622812f47-5640dce88e6mr3268527b6e.20.1793429978135; Fri, 30 Oct 2026
 23:59:38 -0700 (PDT)
Date: Fri, 30 Oct 2026 23:59:38 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6ae591da.041e992e.a2316.0003.GAE@google.com>
Subject: [moderation/CI] Re: hfs: fall back to buffered I/O for direct writes
 past phys_size
From: syzbot ci <syzbot+ci1b6ddb72e99ba3b6@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v1] hfs: fall back to buffered I/O for direct writes past phys_size
https://lore.kernel.org/all/20261030042903.4160506-1-hengyul@cs.unc.edu
* [PATCH 1/2] hfs: fall back to buffered I/O for direct writes past phys_size
* [PATCH 2/2] hfs: remove the dead grow path from hfs_file_truncate()

and found the following issue:
WARNING in hfs_file_truncate

Full report is available here:
https://ci.syzbot.org/series/f8323fc4-a62a-40ea-9106-bff8391323a3

***

WARNING in hfs_file_truncate

tree:      axboe
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/axboe/linux.git
base:      a804c5742bff224d4cb4d25dd383554d598be32b
arch:      amd64
compiler:  Debian clang version 22.1.8 (1~deb13u4), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/734131df-1170-4dc7-a0ec-85ffb659aeec/config
syz repro: https://ci.syzbot.org/findings/95638e3e-6c06-4f46-a68b-e468dc287d1e/syz_repro

------------[ cut here ]------------
inode->i_size > HFS_I(inode)->phys_size
WARNING: fs/hfs/extent.c:494 at hfs_file_truncate+0x7cf/0xa50 fs/hfs/extent.c:494, CPU#1: syz.2.19/5839
Modules linked in:
CPU: 1 UID: 0 PID: 5839 Comm: syz.2.19 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:hfs_file_truncate+0x7cf/0xa50 fs/hfs/extent.c:494
Code: 8b 05 ed eb db 11 48 3b 84 24 20 01 00 00 75 1f 48 8d 65 d8 5b 41 5c 41 5d 41 5e 41 5f 5d e9 88 09 33 09 cc e8 02 10 0b ff 90 <0f> 0b 90 eb 9b e8 67 00 30 09 44 89 e9 80 e1 07 80 c1 03 38 c1 0f
RSP: 0018:ffffc900034afaa0 EFLAGS: 00010293
RAX: ffffffff82bca45e RBX: 1ffff92000695f68 RCX: ffff88810ca50000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000852
RBP: ffffc900034afc08 R08: ffffc900034afb97 R09: 0000000000000000
R10: ffffc900034afb60 R11: fffff52000695f73 R12: 0000000000000000
R13: ffff88816b59b100 R14: dffffc0000000000 R15: 0000000000000852
FS:  00007f4cc5ac36c0(0000) GS:ffff8882a7c97000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000560c8ef2a008 CR3: 00000001bd922000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 hfs_inode_setattr+0x4d0/0x730 fs/hfs/inode.c:698
 notify_change+0xbba/0xea0 fs/attr.c:556
 do_truncate+0x1c2/0x250 fs/open.c:68
 do_ftruncate+0x4d4/0x580 fs/open.c:194
 ksys_ftruncate fs/open.c:206 [inline]
 __do_sys_ftruncate fs/open.c:211 [inline]
 __se_sys_ftruncate fs/open.c:209 [inline]
 __x64_sys_ftruncate+0x8f/0xe0 fs/open.c:209
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f4cc4b9f559
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f4cc5ac3028 EFLAGS: 00000246 ORIG_RAX: 000000000000004d
RAX: ffffffffffffffda RBX: 00007f4cc4e25fa0 RCX: 00007f4cc4b9f559
RDX: 0000000000000000 RSI: 0000000000000852 RDI: 0000000000000004
RBP: 00007f4cc4c36b20 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f4cc4e26038 R14: 00007f4cc4e25fa0 R15: 00007ffcf07cc2c8
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
[frank.li@vivo.com glaubitz@physik.fu-berlin.de hengyul@cs.unc.edu linux-fsdevel@vger.kernel.org linux-kernel@vger.kernel.org slava@dubeyko.com]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

