Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3CCA3A1C9
	for <syzbot@lists.linux.dev>; Wed, 19 Nov 2025 14:19:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763561955; cv=none; b=M7iW0OHrrCnO6SE5hnllCDyry2m4271CnGNjgb1nfgZhTtpjRHkksGoevv+o2aUUANVpoou7dscRWsO7+eZNqZqzNHSx2/agipY0HrsjbWHVqGnI0z45CXXR51M585z/Smw0Rox2epyB6uBVs6i72ZpJFlit+PrFDuqkfcUQ+cA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763561955; c=relaxed/simple;
	bh=rYUUj6tpRaHRd7nY++qi1xoSvtrr8wyYThVVpiwBWBw=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=EPCqo/WXd3vmmKvZIWSP7Q8oEZYAgbl34Vf8aBtdO9ZyL2Y7Wo7qlvLIjh2pi9m31bPrlang9z/4Dn5Vvmg50BywYMYJgF4ihQiYE3x0lTKupr5oDP3cy3OrLG3ulc968SJBZi7zIQHLVMVPYcdGvzhNECDmoMmQozGjfNhBSxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-433770ba913so76766545ab.1
        for <syzbot@lists.linux.dev>; Wed, 19 Nov 2025 06:19:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763561950; x=1764166750;
        h=content-transfer-encoding:cc:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=A6srlt47zHZcZHJen2dBe+Q9OISw8j7jH/5uuwrh+B8=;
        b=jiMmgX4vwpGYQ8HTL87f+7CoU2xmr2I3aYGQVVKZ4Af63IRckDTNGEc8pCvFzc6zxa
         vjDO9yuRyu3hHPkv0U8BMHzaxNlWep4mZzsI0/EgU45W3maYMlYhgaS0IRQWPJ3iCe8u
         o3R2QZYh3L0g4oLxhNSwR8+wRdXjNiHZWyyDk15sJSJ19HnJ4B85WMel46ROO9yJBeTE
         0vHN2jIS5GvMHnyEKqqAWnnzEWQM/Hp2eo2jmnus1cBgFPAPplNI2kXNbUDxgS8EOX62
         MteS4qf0ZmXwy/Och3cNEuaEk8aIPi2gxrZN5e7yDdM7ibQdsbUg2rJKqY6TuD6AYAWF
         wDKw==
X-Gm-Message-State: AOJu0YwX5F0ftZPzUvQNb7iWs5wztUjCaKBQQc3P63BFdgKS38vsCSeE
	ZqW1nUAEvNcn4EFZasVjdQNzmXfDbT7JO11nXdfu5E44gDHK7fMwazi7Ts1sBKVLcy06kWjGEF6
	vWHCRTjP8hwTloY17sT15P1Pk/4xDvyziL4CYSdUL8kEI9VpPaiSiVxTMgBU=
X-Google-Smtp-Source: AGHT+IGfEzQAXeG+FGPA8sHoMQDeL4uH8IzUui9vBF7fnJePiA623kC1fBXcV+DxKIEzVsCAeMkLIsyTdYKl4DfAe9+F/LMxHAIZ
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:12cb:b0:433:306e:2c83 with SMTP id
 e9e14a558f8ab-4348c94e2e2mr305989635ab.28.1763561950072; Wed, 19 Nov 2025
 06:19:10 -0800 (PST)
Date: Wed, 19 Nov 2025 06:19:10 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <691dd1de.a70a0220.d98e3.0015.GAE@google.com>
Subject: [moderation/CI] Re: mm/memory hotplug/unplug: Optimize
 zone->contiguous update when move pfn range
From: syzbot ci <syzbot+ci47dc73e1c66cd1af@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v3] mm/memory hotplug/unplug: Optimize zone->contiguous update when move p=
fn range
https://lore.kernel.org/all/20251119140657.3845818-1-tianyou.li@intel.com
* [PATCH v3] mm/memory hotplug/unplug: Optimize zone->contiguous update whe=
n move pfn range

and found the following issue:
WARNING: kmalloc bug in bpf_prog_alloc_no_stats

Full report is available here:
https://ci.syzbot.org/series/b583f96e-0205-4464-9ac8-2910b2baa1f3

***

WARNING: kmalloc bug in bpf_prog_alloc_no_stats

tree:      mm-new
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/mm=
.git
base:      41218ede767f6b218185af65ce919d0cade75f6b
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp=
1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/1fc125dc-5216-42b4-8ac5-c5883868f1d=
7/config

------------[ cut here ]------------
Unexpected gfp: 0x400000 (__GFP_ACCOUNT). Fixing up to gfp: 0xdc0 (GFP_KERN=
EL|__GFP_ZERO). Fix your code!
WARNING: CPU: 0 PID: 6188 at mm/vmalloc.c:3938 vmalloc_fix_flags+0x9c/0xe0
Modules linked in:
CPU: 0 UID: 0 PID: 6188 Comm: syz-executor Not tainted syzkaller #0 PREEMPT=
(full)=20
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16=
.2-1 04/01/2014
RIP: 0010:vmalloc_fix_flags+0x9c/0xe0
Code: 81 e6 1f 52 ee ff 89 74 24 30 81 e3 e0 ad 11 00 89 5c 24 20 90 48 c7 =
c7 c0 b9 76 8b 4c 89 fa 89 d9 4d 89 f0 e8 75 2b 6e ff 90 <0f> 0b 90 90 8b 4=
4 24 20 48 c7 04 24 0e 36 e0 45 4b c7 04 2c 00 00
RSP: 0018:ffffc90005167b00 EFLAGS: 00010246
RAX: 0bf5a8ae2c29ee00 RBX: 0000000000000dc0 RCX: ffff88810a7dba00
RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000002
RBP: ffffc90005167b98 R08: 0000000000000003 R09: 0000000000000004
R10: dffffc0000000000 R11: fffffbfff1bba684 R12: 1ffff92000a2cf60
R13: dffffc0000000000 R14: ffffc90005167b20 R15: ffffc90005167b30
FS:  0000555569560500(0000) GS:ffff88818eb36000(0000) knlGS:000000000000000=
0
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f38c7dc1f20 CR3: 0000000169fe8000 CR4: 00000000000006f0
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
RIP: 0033:0x7f227b190b0d
Code: 00 48 89 44 24 18 31 c0 48 8d 44 24 60 c7 04 24 18 00 00 00 48 89 44 =
24 08 48 8d 44 24 20 48 89 44 24 10 b8 9d 00 00 00 0f 05 <48> 3d 00 f0 ff f=
f 77 1b 48 8b 54 24 18 64 48 2b 14 25 28 00 00 00
RSP: 002b:00007ffe2e2f4140 EFLAGS: 00000246 ORIG_RAX: 000000000000009d
RAX: ffffffffffffffda RBX: 00007f227b22cf80 RCX: 00007f227b190b0d
RDX: 00007ffe2e2f41a0 RSI: 0000000000000002 RDI: 0000000000000016
RBP: 00007ffe2e2f41b0 R08: 0000000000000006 R09: 0000000000000071
R10: 0000000000000071 R11: 0000000000000246 R12: 000000000000006d
R13: 00007ffe2e2f45d8 R14: 00007ffe2e2f4858 R15: 0000000000000000
 </TASK>


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[david@redhat.com linux-kernel@vger.kernel.org linux-mm@kvack.org nanhai.zo=
u@intel.com osalvador@suse.de pan.deng@intel.com qiuxu.zhuo@intel.com richa=
rd.weiyang@gmail.com rppt@kernel.org tianyou.li@intel.com tim.c.chen@linux.=
intel.com yong.hu@intel.com yu.c.chen@intel.com yuan1.liu@intel.com zhangch=
en.kidd@jd.com]

If the report looks fine to you, reply with:
#syz upstream

