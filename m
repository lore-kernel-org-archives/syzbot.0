Received: from mail-oo1-f70.google.com (mail-oo1-f70.google.com [209.85.161.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38AE93ED11D
	for <syzbot@lists.linux.dev>; Thu,  7 May 2026 20:26:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778185592; cv=none; b=OvLpQtRcGG44LyH3XDMeAWyL2se6Ou6YM5Ri/JsJBKO+/x69oP567hUEkrGR72jQ0xQQ0RHCRevtvocr43PKPXj1jPhkFJ7XoNTND13WoVcgXFId46dMlHypdOgyasDDi9tq+E/TW0JQ7g016FTJVHJCaZs2Ki/bWCcnzs8sRlo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778185592; c=relaxed/simple;
	bh=+mRaUm9RK1u5rSWnNTOXyhsp6LOZtD1FkYfq248GL4k=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=ZEwwzsVYqdcsyrb0wQHiQcwYVSsj0a5to9eI6x+HaI4s2Xv20Av73OXHxheyxlAW54c3Y1vJRrf12mDgWBziMRH0cNRn53lpXvYvWrweSHklYjsVidW0Wha460BGHhYtOtyPurIabGACPGLGvjLMrX7kME3XKK1YB8/bYLeKzfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f70.google.com with SMTP id 006d021491bc7-695aebf3cc7so1863864eaf.0
        for <syzbot@lists.linux.dev>; Thu, 07 May 2026 13:26:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778185590; x=1778790390;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=L2WONWyz3vyIeJgP+mk5Nk2Yi6BT4HkHvHdaFwZ2tg8=;
        b=qUFbRRA4rjScNP57IQkWO5ZbbJpcjBpAKXTwQjeqw+bUpmug7cWppnJ4Mg2T5MhJ4j
         MnsDy2sVUJ1RGiIYBHCfjH8QIfTIJemf5h2Q9VXccxbUWkJss63R5O3RA+3NbdQl7sDw
         uS5qqu66WU8SegxGeVUH3siO+qeyP1/WtCnsOeVx11t4n6YgcUHdMHarZKTG0GXMlUph
         RM5jWWDUFnCpw6zWzm64FBOxSzxMBrA4YVCikQnf+NLQ0O5URzkEkpdqGPxdqPclcKXW
         omQHVmUhw4u0fzlUVOVYjzZGg5CWhUULU9BSNdxA0CFMKYM0BQm6p7bwSIbsfah5zSJp
         3iZw==
X-Gm-Message-State: AOJu0Yyl/Qiqr/31z5IkCei643RmFMhHziBHN1wzMM56IcYR5kwIcgcv
	MF/3pwuvYW9yNFXbXctipGJJB1Qc3gl+mkDYs9z1jaVcIjmTeS/3wwj/wsCsXJP9KFH1yg4JDfG
	x8XGgH2Xcn+kMBDwb+FQPbcjwPHLLGc7VwZGrtMXbWoV1C30IvFjq65q3LVI=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:906:b0:696:154b:24e with SMTP id
 006d021491bc7-69998d0da8dmr5259737eaf.32.1778185590172; Thu, 07 May 2026
 13:26:30 -0700 (PDT)
Date: Thu, 07 May 2026 13:26:30 -0700
In-Reply-To: <20260507114854.41117-1-jillravaliya@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69fcf576.050a0220.3cf765.035d.GAE@google.com>
Subject: [syzbot ci] Re: mm/vmalloc: free unused pages when shrinking
 vrealloc() allocation
From: syzbot ci <syzbot+ciac423580ac76ff6f@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, jillravaliya@gmail.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, urezki@gmail.com
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v1] mm/vmalloc: free unused pages when shrinking vrealloc() allocation
https://lore.kernel.org/all/20260507114854.41117-1-jillravaliya@gmail.com
* [PATCH 1/2] mm/vmalloc: free unused pages when shrinking vrealloc() allocation
* [PATCH 2/2] selftests/mm: add test for vrealloc() shrink page freeing

and found the following issue:
kernel BUG in __vunmap_range_noflush

Full report is available here:
https://ci.syzbot.org/series/13b0874e-a9f8-4992-be93-e93cc88e5e44

***

kernel BUG in __vunmap_range_noflush

tree:      torvalds
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvalds/linux
base:      2c340aab5485ebe9e33c01437dd4815ef33c8df5
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/625f7138-9b20-4205-b0e7-02ed1219bd31/config
syz repro: https://ci.syzbot.org/findings/13e8dc07-d697-4345-a27f-319e9c1fe3d6/syz_repro

------------[ cut here ]------------
kernel BUG at mm/vmalloc.c:488!
Oops: invalid opcode: 0000 [#1] SMP KASAN PTI
CPU: 1 UID: 0 PID: 5824 Comm: syz.2.19 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:__vunmap_range_noflush+0xb4d/0xb70 mm/vmalloc.c:488
Code: 00 e9 64 f5 ff ff e8 12 8d a6 ff 48 c7 c7 a0 0e a8 8e 48 8b 74 24 48 48 89 da e8 0e c5 cf 02 e9 67 f5 ff ff e8 f4 8c a6 ff 90 <0f> 0b e8 ec 8c a6 ff e9 53 ff ff ff e8 e2 8c a6 ff bb 02 00 00 00
RSP: 0018:ffffc90003b575e0 EFLAGS: 00010293
RAX: ffffffff821f16bc RBX: ffffc900036fa000 RCX: ffff8881072a1d80
RDX: 0000000000000000 RSI: ffffc900036fa000 RDI: ffffc900036fa000
RBP: ffff88816ebb3980 R08: ffff88810007f1bb R09: 0000000000000000
R10: ffffc900036f9bb0 R11: ffffed102000fe38 R12: 0000000000000001
R13: ffffc900036fa000 R14: ffffc900036fa000 R15: dffffc0000000000
FS:  00007f4d6b8c46c0(0000) GS:ffff8882a9293000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055924f0dd8c0 CR3: 00000001057f2000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 vunmap_range_noflush mm/vmalloc.c:506 [inline]
 vunmap_range mm/vmalloc.c:521 [inline]
 vrealloc_node_align_noprof+0x4fc/0x880 mm/vmalloc.c:4346
 bpf_patch_insn_data+0xeb/0x10a0 kernel/bpf/fixups.c:254
 bpf_convert_ctx_accesses+0x213f/0x2d70 kernel/bpf/fixups.c:974
 bpf_check+0x2b8e/0x49f0 kernel/bpf/verifier.c:20094
 bpf_prog_load+0x1406/0x1a10 kernel/bpf/syscall.c:3082
 __sys_bpf+0x618/0x950 kernel/bpf/syscall.c:6248
 __do_sys_bpf kernel/bpf/syscall.c:6361 [inline]
 __se_sys_bpf kernel/bpf/syscall.c:6359 [inline]
 __x64_sys_bpf+0x7c/0x90 kernel/bpf/syscall.c:6359
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x15f/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f4d6a99cdd9
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f4d6b8c4028 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
RAX: ffffffffffffffda RBX: 00007f4d6ac15fa0 RCX: 00007f4d6a99cdd9
RDX: 0000000000000048 RSI: 00002000000054c0 RDI: 0000000000000005
RBP: 00007f4d6aa32d69 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f4d6ac16038 R14: 00007f4d6ac15fa0 R15: 00007ffff714fc08
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:__vunmap_range_noflush+0xb4d/0xb70 mm/vmalloc.c:488
Code: 00 e9 64 f5 ff ff e8 12 8d a6 ff 48 c7 c7 a0 0e a8 8e 48 8b 74 24 48 48 89 da e8 0e c5 cf 02 e9 67 f5 ff ff e8 f4 8c a6 ff 90 <0f> 0b e8 ec 8c a6 ff e9 53 ff ff ff e8 e2 8c a6 ff bb 02 00 00 00
RSP: 0018:ffffc90003b575e0 EFLAGS: 00010293
RAX: ffffffff821f16bc RBX: ffffc900036fa000 RCX: ffff8881072a1d80
RDX: 0000000000000000 RSI: ffffc900036fa000 RDI: ffffc900036fa000
RBP: ffff88816ebb3980 R08: ffff88810007f1bb R09: 0000000000000000
R10: ffffc900036f9bb0 R11: ffffed102000fe38 R12: 0000000000000001
R13: ffffc900036fa000 R14: ffffc900036fa000 R15: dffffc0000000000
FS:  00007f4d6b8c46c0(0000) GS:ffff8882a9293000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ffdaf55afd8 CR3: 00000001057f2000 CR4: 00000000000006f0


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
