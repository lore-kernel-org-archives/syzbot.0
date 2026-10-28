Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.69
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793196560;
	b=HBb+2R/GOby1a12h5GworrAEWEP1p57UC6nIKL6Zg+fLfVI6JkAJTcziOcvoYP5cGFgR
	 phlsj0M8OFntCu/c4cmX+Jn2VeifOC1MVKq+d36DZfrZLN7gNM7OMQiCVAOCF5PaKJlqe
	 puEw2tLdK7McPWkS4jZigfTgasVyf/HjLDYNU4bRr++qFDw5F3z1Cc1gdc1TQWC0/1TBI
	 jJgl42Xim6rgW5XjBw7oM2WkoJTiRqrU6mHGhR+AoInmAST/YFDROI0o4DY4uZPdhhQcr
	 cqLrVY/B/LE9WQkZgd6YYsCGig0kDgUzlWBNM2T/LcXxNkqKmTa7Q/Sg3aqPbcbkiNw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793196560;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 MIME-Version:X-Received:Date:X-Google-Appengine-App-Id:
	 X-Google-Appengine-App-Id-Alias:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=iWp5qhIdhg7FDP8aypq55zXijpZBkV0xmXh0MaK851k=;
	b=ZW8VDQpB+oRs+QVBO5baaTGDvBrG61OWIhhJj7Otf0je7VKEY8qDz7xn1bWWdWE4WuHC
	 WKFsC5daB3blf/OQ0zSn8hBK16dd4n3IB5+q1+mQwNr9eNSsmEtWGbn6aQTIV+M2gDwXU
	 GsN9G07WmBMZN4QF9e9R0kFxEegMdmp/KGDhauki9N++E9MRGfNhHv9oll1ILWwsS53xp
	 GSla3Ir+ohGGMlEB7u/+uC7kZstokMlror9DG2PekvzF4B1qCEldBgYWsQQohuuK4q+Zm
	 jnO/Vfx1e60E3X2ZSlwKy3kcLX67mZQ0IAaP5SX7ce1lcEea8EDRh+JRM0wPR9BAg3w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=syzkaller.appspotmail.com;
	spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	arc=none smtp.remote-ip=209.85.210.69
Received: from mail-ot1-f69.google.com (mail-ot1-f69.google.com [209.85.210.69])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 625C8606A31D
	for <syzbot@lists.linux.dev>; Wed, 28 Oct 2026 14:09:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 625C8606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f69.google.com with SMTP id 46e09a7af769-83c2311eb1dso1679294a34.1
        for <syzbot@lists.linux.dev>; Wed, 28 Oct 2026 07:09:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793196559; x=1793801359;
        h=content-type:cc:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=iWp5qhIdhg7FDP8aypq55zXijpZBkV0xmXh0MaK851k=;
        b=vmQWgmeZzkOlv1oLCWBppC9hV48uj0APN0qtAZbNLMRoa8Gehpf372ZceqbDTQbmPD
         ewJp8W+b4RW3d1hBm6j4fRZisHrchHFMZcavqRLYRxpkGTC4GvFBcC2LkOWPHjzpKoN8
         bKbKT9cbjcgFPbuWtm+36deQRozDqfwmMVY0Q+iZezQ4g3pJaasy/YOtJ00Ed7iVgRC5
         6uXRJI6FnWi12Pq09gJBFPpLiPvlBKwIByDnRW3eeIVjiVMSdhQ1HHnyN675iXvFBtX5
         jPX3o548FOs5CO8SL5zqpScm3bn/ibRzUJWgtBwWa/OoAe7EhFo93Tx+YphT6eSXKgbA
         DH/Q==
X-Gm-Message-State: AFq9FYLxADNu+AChqETZPD1MevFkMK8I1m9yLRwPhxBlOR3aqzCNtgi8
	v4f6edLovfdum7oZBgBC2rO/qafclOn/hdSj9uxK+CPBadI7F9pqNNBETc3ttb29ioZQroBa1yf
	vNxAIi/djD6PwqkryYgmWZA1aUvUbQMR3mJl0BWyjYCsHbsNzR1GdSKQfwGQ=
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Post: <mailto:syzbot@lists.linux.dev>
List-Help: <mailto:syzbot+help@lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
List-Owner: <mailto:syzbot+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-Received: by 2002:a05:6808:220e:b0:4e8:e73e:e945 with SMTP id
 5614622812f47-56384c7e60dmr1546420b6e.63.1793196559302; Wed, 28 Oct 2026
 07:09:19 -0700 (PDT)
Date: Wed, 28 Oct 2026 07:09:19 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6ae2020f.cbab20e0.42a9b.0005.GAE@google.com>
Subject: [moderation/CI] Re: hugetlb: supports unmapping private mappings
From: syzbot ci <syzbot+ci4afffd1cc25e4433@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v1] hugetlb: supports unmapping private mappings
https://lore.kernel.org/all/20261028041528.269829-1-eadavis@sina.com
* [PATCH] hugetlb: supports unmapping private mappings

and found the following issue:
WARNING: bad unlock balance in remove_inode_hugepages

Full report is available here:
https://ci.syzbot.org/series/bf349aec-df0c-48a8-ab82-9f71361a3830

***

WARNING: bad unlock balance in remove_inode_hugepages

tree:      mm-new
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/mm.git
base:      7d1f84f1b94e79cb95d974ab3ec54cb3a4d64f5b
arch:      amd64
compiler:  Debian clang version 22.1.8 (1~deb13u4), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/7d19c5c0-63db-4726-978e-d863eedfb488/config
AI triage: https://ci.syzbot.org/findings/dcd884e0-680c-4d8d-82e4-551dbfcdaeae/triage_trajectory

=====================================
WARNING: bad unlock balance detected!
syzkaller #0 Not tainted
-------------------------------------
syz.4.862/12304 is trying to release lock (&vma_lock->rw_sema) at:
[<ffffffff82b5a0e7>] remove_inode_hugepages+0xc57/0x1220
but there are no more locks to release!

other info that might help us debug this:
locks held by syz.4.862/12304: 4, last CPU#1:
 #0: ffff88810729e460 (sb_writers#12){.+.+}-{0:0}, at: vfs_fallocate+0x5e0/0x7e0
 #1: ffff8881aa537b00 (&sb->s_type->i_mutex_key#24){+.+.}-{4:4}, at: hugetlbfs_fallocate+0x3f7/0x11c0
 #2: ffff8881683dc638 (&hugetlb_fault_mutex_table[i]){+.+.}-{4:4}, at: remove_inode_hugepages+0x370/0x1220
 #3: ffff8881aa537da8 (&hugetlbfs_i_mmap_rwsem_key){+.+.}-{4:4}, at: remove_inode_hugepages+0xa44/0x1220

stack backtrace:
CPU: 1 UID: 0 PID: 12304 Comm: syz.4.862 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150
 print_unlock_imbalance_bug+0xdc/0xf0
 lock_release+0x252/0x3c0
 up_write+0x2d/0x4a0
 remove_inode_hugepages+0xc57/0x1220
 hugetlbfs_fallocate+0xc51/0x11c0
 vfs_fallocate+0x65a/0x7e0
 madvise_vma_behavior+0x2cf5/0x43b0
 madvise_walk_vmas+0x576/0xb00
 madvise_do_behavior+0x385/0x540
 do_madvise+0x327/0x3a0
 __x64_sys_madvise+0xa6/0xc0
 do_syscall_64+0x166/0x520
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f0c8dd9f559
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f0c8bff6028 EFLAGS: 00000246 ORIG_RAX: 000000000000001c
RAX: ffffffffffffffda RBX: 00007f0c8e026450 RCX: 00007f0c8dd9f559
RDX: 0000000000000009 RSI: 0000000000c00000 RDI: 0000200000400000
RBP: 00007f0c8de36b20 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f0c8e0264e8 R14: 00007f0c8e026450 R15: 00007ffc9fc94698
 </TASK>
------------[ cut here ]------------
DEBUG_RWSEMS_WARN_ON((rwsem_owner(sem) != current) && !rwsem_test_oflags(sem, RWSEM_NONSPINNABLE)): count = 0x0, magic = 0xffff88810b4c2608, owner = 0x0, curr 0xffff88816ff4bc00, list not empty
WARNING: kernel/locking/rwsem.c:1413 at up_write+0x35c/0x4a0, CPU#1: syz.4.862/12304
Modules linked in:
CPU: 1 UID: 0 PID: 12304 Comm: syz.4.862 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:up_write+0x40f/0x4a0
Code: 0d 8c 49 c7 c2 80 33 0d 8c 4c 0f 44 d0 48 8b 7c 24 10 48 c7 c6 20 36 0d 8c 48 8b 14 24 48 8b 4c 24 08 4d 89 e0 4d 89 f9 41 52 <67> 48 0f b9 3a 48 83 c4 08 e8 f3 6f 45 03 e9 d6 fc ff ff 48 c7 c1
RSP: 0018:ffffc900040cede0 EFLAGS: 00010246
RAX: ffffffff8c0d33a0 RBX: ffff88810b4c2608 RCX: ffff88810b4c2608
RDX: 0000000000000000 RSI: ffffffff8c0d3620 RDI: ffffffff917dda70
RBP: dffffc0000000000 R08: 0000000000000000 R09: ffff88816ff4bc00
R10: ffffffff8c0d33a0 R11: ffffed10216984c3 R12: 0000000000000000
R13: ffff88810b4c2610 R14: ffff88810b4c2660 R15: ffff88816ff4bc00
FS:  00007f0c8bff66c0(0000) GS:ffff8882a7c83000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f8981484378 CR3: 00000001ad2de000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 remove_inode_hugepages+0xc57/0x1220
 hugetlbfs_fallocate+0xc51/0x11c0
 vfs_fallocate+0x65a/0x7e0
 madvise_vma_behavior+0x2cf5/0x43b0
 madvise_walk_vmas+0x576/0xb00
 madvise_do_behavior+0x385/0x540
 do_madvise+0x327/0x3a0
 __x64_sys_madvise+0xa6/0xc0
 do_syscall_64+0x166/0x520
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f0c8dd9f559
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f0c8bff6028 EFLAGS: 00000246 ORIG_RAX: 000000000000001c
RAX: ffffffffffffffda RBX: 00007f0c8e026450 RCX: 00007f0c8dd9f559
RDX: 0000000000000009 RSI: 0000000000c00000 RDI: 0000200000400000
RBP: 00007f0c8de36b20 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f0c8e0264e8 R14: 00007f0c8e026450 R15: 00007ffc9fc94698
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
[eadavis@sina.com linux-kernel@vger.kernel.org linux-mm@kvack.org mike.kravetz@oracle.com muchun.song@linux.dev osalvador@suse.de syzbot@syzkaller.appspotmail.com syzkaller-bugs@googlegroups.com]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

