Received: from mail-ot1-f71.google.com (mail-ot1-f71.google.com [209.85.210.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF0E3397AD0
	for <syzbot@lists.linux.dev>; Wed, 14 Jan 2026 11:49:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768391394; cv=none; b=FxP56wJ4+votddnlyaKmMTR3CRtHTpDPWXc5ubF++P30+aLtrvGLpDIqL/tjPDwZ70IMNFdBFyJi+DKIbtEIBIZYxbqR18332kUmAeA6DQpKu4LAX/g+CAJRFJBUyssaudq6AHvZehvTRvtE+YSKbqTauWa5uj2nFEIKncO5u1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768391394; c=relaxed/simple;
	bh=iYdK/JCBLUcGyGomTRYmeXVT8G2RICVHSLZIGstAiDs=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=SLKhKAdg7pObJJgpi8LaAZAyLJCL/X8/ERdj/8HbZ1zxRiwU132O3ca5ag7NbajwdvcPECm9y4HcAk9o2Yp19KgOJ0cIJMFqdVY/sdW+iyiaXSG6uIQ/bxWEBJYA8NenBan1OEjLR1OPN3v3Ecz5h+huY83BnjssI+c1ii2tTpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.210.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f71.google.com with SMTP id 46e09a7af769-7c7028db074so25458575a34.1
        for <syzbot@lists.linux.dev>; Wed, 14 Jan 2026 03:49:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768391390; x=1768996190;
        h=cc:to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=yhyIjwA5avwcAS+Unz3H6CF7bSK4xESjJdn3zos794w=;
        b=cIcs2favtFRWtIzDSOSmdFU39w+5sxx8gMlk90urdpcNFswBw5wNtmJbH3RdNNtN7d
         HkBXoDTblLUL7jsYan2bYAZzrMe8sH1U1SjvX9RD2hW7PJl6YIM41UYN7U7cFs5XaWti
         GeMioDH8Da1ZWJkzQqLi7xqp6Q4XyIlYoRmi5OtkI/9M7HzMahKXiZZlNYEbslIJ+F9J
         SKV8v09Arj8YmFpbviC19XfPkGCaDRQVDJz7NgZTXL47XziI0O5ZnDhZbSK7YIhE6Q66
         Z981+SOCSdy4b4hY+9Lnp2FU69xAP3/7E4gMgXi3EkDZxrqG10kM+JaIVqcTka2vHMoX
         1pWg==
X-Gm-Message-State: AOJu0YxIcJhx1YRerYLJHnfsYd41M4twWhEnfm2zK6Yz81TcZ2HUQEtO
	Lil9Xl1jbAf/pzf4PfO7+aGjqfVpnHEf3z5rybRSQjLKCAi+9u1gtN4H5g9UC0sKsd06veQdrPj
	UcjMXm2qOQ1WGDwYZWU5wJr+RCLiZVbw835x+Q9CTC1flowo5/4hmfkEitug=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:2216:b0:65e:c673:777a with SMTP id
 006d021491bc7-66100704d0amr1793148eaf.58.1768391390287; Wed, 14 Jan 2026
 03:49:50 -0800 (PST)
Date: Wed, 14 Jan 2026 03:49:50 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <696782de.a70a0220.2c0c17.0000.GAE@google.com>
Subject: [moderation/CI] Re: iomap: add allocation cache for iomap_dio
From: syzbot ci <syzbot+ci7262165a567f7af3@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v2] iomap: add allocation cache for iomap_dio
https://lore.kernel.org/all/20260114074113.151089-1-guzebing1612@gmail.com
* [PATCH v2] iomap: add allocation cache for iomap_dio

and found the following issue:
BUG: sleeping function called from invalid context in __iomap_dio_rw

Full report is available here:
https://ci.syzbot.org/series/2217a3d5-b2ea-47d6-9bca-2776e95fd748

***

BUG: sleeping function called from invalid context in __iomap_dio_rw

tree:      torvalds
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvalds/linux
base:      b2c43efc3c8d9cda34eb8421249d15e6fed4d650
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/1397dec0-a77b-450c-9c93-79aa717e1cff/config
C repro:   https://ci.syzbot.org/findings/b20bf03e-8485-4437-9a20-8d11cc0561d4/c_repro
syz repro: https://ci.syzbot.org/findings/b20bf03e-8485-4437-9a20-8d11cc0561d4/syz_repro

EXT4-fs (loop0): mounted filesystem 00000000-0000-0000-0000-000000000000 r/w without journal. Quota mode: none.
BUG: sleeping function called from invalid context at ./include/linux/sched/mm.h:321
in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 5964, name: syz.0.17
preempt_count: 1, expected: 0
RCU nest depth: 0, expected: 0
1 lock held by syz.0.17/5964:
 #0: ffff88811839aa20 (&sb->s_type->i_mutex_key#9){++++}-{4:4}, at: inode_lock_shared include/linux/fs.h:995 [inline]
 #0: ffff88811839aa20 (&sb->s_type->i_mutex_key#9){++++}-{4:4}, at: ext4_dio_read_iter fs/ext4/file.c:78 [inline]
 #0: ffff88811839aa20 (&sb->s_type->i_mutex_key#9){++++}-{4:4}, at: ext4_file_read_iter+0x298/0x660 fs/ext4/file.c:145
Preemption disabled at:
[<ffffffff825b641d>] pcpu_cache_list_alloc fs/iomap/direct-io.c:129 [inline]
[<ffffffff825b641d>] __iomap_dio_rw+0x30d/0x2510 fs/iomap/direct-io.c:749
CPU: 0 UID: 0 PID: 5964 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0x1a9/0x280 lib/dump_stack.c:120
 __might_resched+0x4b0/0x630 kernel/sched/core.c:8925
 might_alloc include/linux/sched/mm.h:321 [inline]
 slab_pre_alloc_hook mm/slub.c:4906 [inline]
 slab_alloc_node mm/slub.c:5241 [inline]
 __do_kmalloc_node mm/slub.c:5626 [inline]
 __kmalloc_noprof+0xbc/0x7d0 mm/slub.c:5639
 kmalloc_noprof include/linux/slab.h:961 [inline]
 pcpu_cache_list_alloc fs/iomap/direct-io.c:134 [inline]
 __iomap_dio_rw+0xbdd/0x2510 fs/iomap/direct-io.c:749
 iomap_dio_rw+0x45/0xb0 fs/iomap/direct-io.c:947
 ext4_dio_read_iter fs/ext4/file.c:94 [inline]
 ext4_file_read_iter+0x4f8/0x660 fs/ext4/file.c:145
 copy_splice_read+0x5ff/0xaa0 fs/splice.c:363
 do_splice_read fs/splice.c:981 [inline]
 splice_direct_to_actor+0x4a0/0xc70 fs/splice.c:1086
 do_splice_direct_actor fs/splice.c:1204 [inline]
 do_splice_direct+0x195/0x290 fs/splice.c:1230
 do_sendfile+0x535/0x7c0 fs/read_write.c:1370
 __do_sys_sendfile64 fs/read_write.c:1431 [inline]
 __se_sys_sendfile64+0x144/0x1a0 fs/read_write.c:1417
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xf0/0xfa0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f8cd8b9acb9
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffeab7c8828 EFLAGS: 00000246 ORIG_RAX: 0000000000000028
RAX: ffffffffffffffda RBX: 00007f8cd8e15fa0 RCX: 00007f8cd8b9acb9
RDX: 0000000000000000 RSI: 0000000000000004 RDI: 0000000000000004
RBP: 00007f8cd8c08bf7 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000fffe82 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f8cd8e15fac R14: 00007f8cd8e15fa0 R15: 00007f8cd8e15fa0
 </TASK>


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[brauner@kernel.org changfengnan@bytedance.com djwong@kernel.org guzebing1612@gmail.com linux-fsdevel@vger.kernel.org linux-kernel@vger.kernel.org linux-xfs@vger.kernel.org]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

