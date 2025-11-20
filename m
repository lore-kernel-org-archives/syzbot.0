Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D4B2D531
	for <syzbot@lists.linux.dev>; Thu, 20 Nov 2025 06:39:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763620750; cv=none; b=WiPK0M8Ai4Nt2LavJWsXonAREu0Pcga0t3ej85Oq/XDE2uO9naODt3/IapZ+rA5WsA/AIgoLPmNsBuBR6FoV5kkjQDoX15LS2zl+QWI3yOzYKVs8MliGnBdl4xuAudl+kj/Ws/+oFgGpmraUONelKP9PG3OiYLXJh5jfbI9q/bI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763620750; c=relaxed/simple;
	bh=Ee02ZqSeOuqpVNMFbi05aM2eB6Z6pC0Yw5hZ9UxiWto=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=gN3TcXq8NdXaqYgnGZe6Bnv7Sa/4IB/BwaJ5sL378vbHHAkmfhqVhhO0oPSK8Ff96JwtFwI+tYK3AwbH2BdhsO2esksbcnVSHzdE+REQRYaqpRrTqxFkpwMvyRUvBr6v2jjalgNszN959P94AlSXKPIRg+s0XUrdD6WWG51wuB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-43321627eabso6961935ab.3
        for <syzbot@lists.linux.dev>; Wed, 19 Nov 2025 22:39:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763620748; x=1764225548;
        h=cc:to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=X90ZnbjsI64RuMgZsjC0YUUsfrJ2BZrLOrGcH4pl+bc=;
        b=U2lrs770eD0uCDF7e5lBhuTBmJWOxkJIbd+1jb+i3dOm/mZx0c577ftEGYARB5F/ie
         9M/mwvVE0WyT0ETS51RGsfr87y5ybkBoGqGarOcpw7l2yjfEzLjetNO0ZDeZslI3v4tJ
         AmdVp3kq7Noy5mqkpek5rT2GxUFhiM6yj9mI2hnK3seO2KFhan9zKsn+1witJPgPFcUh
         c3wXQLYB3jMV7iHXdOzQVG9h0yvdUx5kH6pGUE84dNR7CQrpwb+XoqwMo6pTnGJRK5po
         5rovut0lOm6VMMZeZKArYpewLrpgQ1cu5yEapJOHFpE/QHBUhxhRPPBJFeRseiyIg8pv
         xmLg==
X-Gm-Message-State: AOJu0Yy4DgCMvs+RbdvhLv2hprqPD5DpROjnNSe6TwvpaTROuQWA96M8
	NvkRqZkH6ZXKfPi2f2/bImZhC5TidL0oM/DCEz4VRPYOM8EuYLD3EVC5Nqd2KBx2GGl7Ae8pKn0
	AbEwB1oTNADZfEULzhFqNZCSMvtzuZ0PoSLpb42ZsZTOC4Izz/zNJiW9SCkA=
X-Google-Smtp-Source: AGHT+IFdUNCOZAl+t0EUtToWtGRmJOPZz5YX6yfS5UK4PU9wnowVhFV5SxcAt279t92Qtqs24AYlVARCx+pD+9YyQJ2RXdymeHBg
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:216b:b0:434:8ec2:9a69 with SMTP id
 e9e14a558f8ab-435a9074d7emr17560805ab.19.1763620748060; Wed, 19 Nov 2025
 22:39:08 -0800 (PST)
Date: Wed, 19 Nov 2025 22:39:08 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <691eb78c.a70a0220.2ea503.0028.GAE@google.com>
Subject: [moderation/CI] Re: mm/mremap: allow VMAs with VM_DONTEXPAND|VM_PFNMAP
 when creating new mapping
From: syzbot ci <syzbot+cif4957c0a007b87ec@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v1] mm/mremap: allow VMAs with VM_DONTEXPAND|VM_PFNMAP when creating new mapping
https://lore.kernel.org/all/20251120053546.2885836-1-vivek.kasireddy@intel.com
* [PATCH] mm/mremap: allow VMAs with VM_DONTEXPAND|VM_PFNMAP when creating new mapping

and found the following issue:
WARNING: kmalloc bug in bpf_prog_alloc_no_stats

Full report is available here:
https://ci.syzbot.org/series/112439ca-442c-42b6-8d2c-2e4f0308a9cd

***

WARNING: kmalloc bug in bpf_prog_alloc_no_stats

tree:      mm-new
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/mm.git
base:      41218ede767f6b218185af65ce919d0cade75f6b
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/d36d98db-e0f8-4d8c-9bdb-a6e4f4539616/config

------------[ cut here ]------------
Unexpected gfp: 0x400000 (__GFP_ACCOUNT). Fixing up to gfp: 0xdc0 (GFP_KERNEL|__GFP_ZERO). Fix your code!
WARNING: CPU: 1 PID: 6448 at mm/vmalloc.c:3938 vmalloc_fix_flags+0x9c/0xe0
Modules linked in:
CPU: 1 UID: 0 PID: 6448 Comm: syz-executor Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:vmalloc_fix_flags+0x9c/0xe0
Code: 81 e6 1f 52 ee ff 89 74 24 30 81 e3 e0 ad 11 00 89 5c 24 20 90 48 c7 c7 c0 b9 76 8b 4c 89 fa 89 d9 4d 89 f0 e8 65 2b 6e ff 90 <0f> 0b 90 90 8b 44 24 20 48 c7 04 24 0e 36 e0 45 4b c7 04 2c 00 00
RSP: 0018:ffffc9000700fb00 EFLAGS: 00010246
RAX: 7a4c30e2b6d6e800 RBX: 0000000000000dc0 RCX: ffff88816a1c0000
RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000002
RBP: ffffc9000700fb98 R08: ffffc9000700f827 R09: 1ffff92000e01f04
R10: dffffc0000000000 R11: fffff52000e01f05 R12: 1ffff92000e01f60
R13: dffffc0000000000 R14: ffffc9000700fb20 R15: ffffc9000700fb30
FS:  0000555565789500(0000) GS:ffff8882a9f36000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fddd9e5c470 CR3: 000000010d04e000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 __vmalloc_noprof+0xf2/0x120
 bpf_prog_alloc_no_stats+0x4a/0x4d0
 bpf_prog_alloc+0x3c/0x1a0
 bpf_prog_create_from_user+0xa7/0x440
 do_seccomp+0x7b1/0xd90
 __se_sys_prctl+0xc3c/0x1830
 do_syscall_64+0xfa/0xfa0
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fddd9f90b0d
Code: 00 48 89 44 24 18 31 c0 48 8d 44 24 60 c7 04 24 18 00 00 00 48 89 44 24 08 48 8d 44 24 20 48 89 44 24 10 b8 9d 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 1b 48 8b 54 24 18 64 48 2b 14 25 28 00 00 00
RSP: 002b:00007ffe71382440 EFLAGS: 00000246 ORIG_RAX: 000000000000009d
RAX: ffffffffffffffda RBX: 00007fddda02cf80 RCX: 00007fddd9f90b0d
RDX: 00007ffe713824a0 RSI: 0000000000000002 RDI: 0000000000000016
RBP: 00007ffe713824b0 R08: 0000000000000006 R09: 0000000000000071
R10: 0000000000000071 R11: 0000000000000246 R12: 000000000000006d
R13: 00007ffe713828d8 R14: 00007ffe71382b58 R15: 0000000000000000
 </TASK>


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[akpm@linux-foundation.org david@kernel.org jannh@google.com liam.howlett@oracle.com linux-mm@kvack.org lorenzo.stoakes@oracle.com odaki@rsg.ci.i.u-tokyo.ac.jp pfalcato@suse.de vbabka@suse.cz vivek.kasireddy@intel.com]

If the report looks fine to you, reply with:
#syz upstream

