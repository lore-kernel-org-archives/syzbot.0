Received: from mail-ot1-f69.google.com (mail-ot1-f69.google.com [209.85.210.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCC4635898
	for <syzbot@lists.linux.dev>; Sun, 26 Apr 2026 15:57:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777219056; cv=none; b=BVt2JYFgUQVR3udiIQL1xIofY19GbADcHsMNC/ZQyefeMaWkKapE0RAURClq2MGN4oBSZ9gpOkEFAOUpbdxUSTni7eYn9G89alBaIqM5MBTKnS3Ilpod2QbVNJZdrygjqEyhZepWZQMh473zIcJaMrNSWbArCICuUAfoJYJPR5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777219056; c=relaxed/simple;
	bh=G/BpRPKw6ttmZlSQx2ujKqI434VjJqga2VGbhCSQjBs=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=fPB/Zu5BnC0sKhQMLuiBQC+V166aU5xjwm2qBqzwcT2LrGFNoU00lSNs2kizDpywwLPYSRTOjqDGU2i2Nc4oqFKnKcCM+S4P4ABqt7HgUxoJHb0ROjNThCHyy7fs+CYZbBbJt00qUZIyzBkKza5rJsHgdmoPMRBGVD9Cur5Yarg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.210.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f69.google.com with SMTP id 46e09a7af769-7dbd4fe0e15so20458280a34.3
        for <syzbot@lists.linux.dev>; Sun, 26 Apr 2026 08:57:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777219054; x=1777823854;
        h=content-transfer-encoding:cc:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UaZo7PGNtv7bKyp4nUakulQbqu43OX/sogX+IUqeCT8=;
        b=VUEIm3qYbeqEh7lsRWmGyKfK7LfSeKXejkWoTSR6x+W+VN+firbfZwpBMwsmmHahmP
         sP8FR+m2gCXMKeC5K51dOxkPfMd1yeV6gJdpnMxdi5dvgqQym+M5aa8LmXB5a2Jze66+
         xX+cd9vmb1iCq9JukcddMeflTFjyYzBotsxKJyRMuIQL+nF/8DTv4TYJ16RXxf/4Bk8c
         XgfuoVLPYMn+XkhPu1CmywAWmPEHHIC5OHDtVUtg9jIPhrFNHYK1e/R2zNLpbmF2vz1l
         mQTVYcMmYgNSsGs0ZzPb89egiiutFwTn1hezv61vYUMUJOmx+26SJaUYPq7MxIDtnEYw
         X4jQ==
X-Gm-Message-State: AOJu0Yy87Gh/92fwaU1X+vi3MuVdny/JFV69ObyjJY4PrSlwItfeNRsV
	408wIcwb+eCxv4+LgXdtCfNFdau0zYCBbH/29BJozveyAztC3mkxiZvAuZQcmFA7Sd7mxRG8BSr
	9kouTnMMyyQEJ00wOVACYRDRlFEMvrMIMQjN5ZIH5Wxvn1JAlCKeX3faDJ0o=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:7088:10b0:67e:eb4:238f with SMTP id
 006d021491bc7-69462e318a5mr16157612eaf.18.1777219053778; Sun, 26 Apr 2026
 08:57:33 -0700 (PDT)
Date: Sun, 26 Apr 2026 08:57:33 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69ee35ed.a00a0220.316485.0004.GAE@google.com>
Subject: [moderation/CI] Re: mm: improve write performance with RWF_DONTCACHE
From: syzbot ci <syzbot+ci5ae010b5f41f7212@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v3] mm: improve write performance with RWF_DONTCACHE
https://lore.kernel.org/all/20260426-dontcache-v3-0-79eb37da9547@kernel.org
* [PATCH v3 1/4] mm: add NR_DONTCACHE_DIRTY node page counter
* [PATCH v3 2/4] mm: kick writeback flusher for IOCB_DONTCACHE with targete=
d dirty tracking
* [PATCH v3 3/4] testing: add nfsd-io-bench NFS server benchmark suite
* [PATCH v3 4/4] testing: add dontcache-bench local filesystem benchmark su=
ite

and found the following issue:
WARNING in __mod_memcg_lruvec_state

Full report is available here:
https://ci.syzbot.org/series/e53aef43-ac7a-4cb7-8714-bb927aaee659

***

WARNING in __mod_memcg_lruvec_state

tree:      torvalds
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvald=
s/linux
base:      27d128c1cff64c3b8012cc56dd5a1391bb4f1821
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp=
1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/c10ddd10-bb16-48c2-90fb-3625d3b258a=
a/config
syz repro: https://ci.syzbot.org/findings/1e8993c1-818b-4ddf-b90b-30f051b3a=
9d6/syz_repro

------------[ cut here ]------------
__mod_memcg_lruvec_state: missing stat item 21
WARNING: mm/memcontrol.c:911 at __mod_memcg_lruvec_state+0x1f3/0x360 mm/mem=
control.c:911, CPU#0: syz.0.17/5831
Modules linked in:
CPU: 0 UID: 0 PID: 5831 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(ful=
l)=20
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16=
.2-1 04/01/2014
RIP: 0010:__mod_memcg_lruvec_state+0x1fc/0x360 mm/memcontrol.c:911
Code: 00 11 85 c0 74 31 48 83 c4 08 5b 41 5c 41 5d 41 5e 41 5f 5d e9 95 2e =
72 09 cc 48 8d 3d 7d c4 fd 0d 48 c7 c6 5d b4 f5 8d 89 da <67> 48 0f b9 3a e=
b d5 90 0f 0b 90 eb 90 e8 02 22 fb fe eb c8 48 8d
RSP: 0018:ffffc900039e7520 EFLAGS: 00010046
RAX: 0000000000000000 RBX: 0000000000000015 RCX: dffffc0000000000
RDX: 0000000000000015 RSI: ffffffff8df5b45d RDI: ffffffff90363d90
RBP: 0000000000000001 R08: ffffffff82388833 R09: ffffffff8e95cd60
R10: dffffc0000000000 R11: fffff940008c3f49 R12: ffff8881026eee80
R13: 00000000000000ff R14: 0000000000000001 R15: ffff888173a80e00
FS:  00007f5f76bca6c0(0000) GS:ffff88818dc95000(0000) knlGS:000000000000000=
0
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055d77c624128 CR3: 0000000171fde000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 mod_memcg_lruvec_state+0xa7/0x220 mm/memcontrol.c:941
 mod_lruvec_state mm/memcontrol.c:964 [inline]
 lruvec_stat_mod_folio+0x239/0x3e0 mm/memcontrol.c:984
 folio_account_dirtied mm/page-writeback.c:2634 [inline]
 __folio_mark_dirty+0x633/0xec0 mm/page-writeback.c:2692
 mark_buffer_dirty+0x261/0x410 fs/buffer.c:1110
 block_commit_write+0x15d/0x270 fs/buffer.c:2115
 block_write_end+0x6e/0xb0 fs/buffer.c:2191
 ext4_write_end+0x27d/0xa30 fs/ext4/inode.c:1458
 ext4_da_write_end+0x86/0xcb0 fs/ext4/inode.c:3296
 generic_perform_write+0x620/0x8f0 mm/filemap.c:4350
 ext4_buffered_write_iter+0xcb/0x370 fs/ext4/file.c:316
 ext4_file_write_iter+0x298/0x1bd0 fs/ext4/file.c:-1
 do_iter_readv_writev+0x619/0x8c0 fs/read_write.c:-1
 vfs_writev+0x33c/0x990 fs/read_write.c:1059
 do_pwritev fs/read_write.c:1155 [inline]
 __do_sys_pwritev2 fs/read_write.c:1213 [inline]
 __se_sys_pwritev2+0x184/0x2a0 fs/read_write.c:1204
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x15f/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f5f75d9cdd9
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 =
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff f=
f 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f5f76bca028 EFLAGS: 00000246 ORIG_RAX: 0000000000000148
RAX: ffffffffffffffda RBX: 00007f5f76015fa0 RCX: 00007f5f75d9cdd9
RDX: 0000000000000001 RSI: 00002000000001c0 RDI: 0000000000000004
RBP: 00007f5f75e32d69 R08: 0000000000000001 R09: 0000000000000081
R10: 0000000000000003 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f5f76016038 R14: 00007f5f76015fa0 R15: 00007fffe7503ad8
 </TASK>
----------------
Code disassembly (best guess):
   0:	00 11                	add    %dl,(%rcx)
   2:	85 c0                	test   %eax,%eax
   4:	74 31                	je     0x37
   6:	48 83 c4 08          	add    $0x8,%rsp
   a:	5b                   	pop    %rbx
   b:	41 5c                	pop    %r12
   d:	41 5d                	pop    %r13
   f:	41 5e                	pop    %r14
  11:	41 5f                	pop    %r15
  13:	5d                   	pop    %rbp
  14:	e9 95 2e 72 09       	jmp    0x9722eae
  19:	cc                   	int3
  1a:	48 8d 3d 7d c4 fd 0d 	lea    0xdfdc47d(%rip),%rdi        # 0xdfdc49e
  21:	48 c7 c6 5d b4 f5 8d 	mov    $0xffffffff8df5b45d,%rsi
  28:	89 da                	mov    %ebx,%edx
* 2a:	67 48 0f b9 3a       	ud1    (%edx),%rdi <-- trapping instruction
  2f:	eb d5                	jmp    0x6
  31:	90                   	nop
  32:	0f 0b                	ud2
  34:	90                   	nop
  35:	eb 90                	jmp    0xffffffc7
  37:	e8 02 22 fb fe       	call   0xfefb223e
  3c:	eb c8                	jmp    0x6
  3e:	48                   	rex.W
  3f:	8d                   	.byte 0x8d


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

The email will later be sent to:
[akpm@linux-foundation.org axboe@kernel.dk axelrasmussen@google.com baohua@=
kernel.org brauner@kernel.org chuck.lever@oracle.com david@kernel.org hch@i=
nfradead.org jack@suse.cz jlayton@kernel.org kasong@tencent.com liam.howlet=
t@oracle.com linux-fsdevel@vger.kernel.org linux-kernel@vger.kernel.org lin=
ux-mm@kvack.org linux-nfs@vger.kernel.org linux-trace-kernel@vger.kernel.or=
g ljs@kernel.org mathieu.desnoyers@efficios.com mhiramat@kernel.org mhocko@=
suse.com qi.zheng@linux.dev ritesh.list@gmail.com rostedt@goodmis.org rppt@=
kernel.org shakeel.butt@linux.dev snitzer@kernel.org surenb@google.com vbab=
ka@kernel.org viro@zeniv.linux.org.uk weixugc@google.com willy@infradead.or=
g yuanchu@google.com]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

