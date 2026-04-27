Received: from mail-ot1-f72.google.com (mail-ot1-f72.google.com [209.85.210.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33B12372EE3
	for <syzbot@lists.linux.dev>; Mon, 27 Apr 2026 21:44:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777326285; cv=none; b=jW8gvcQjgCf9nLJM5WjWV7qkcJKbF2ONqogOXSUm+I9o1iV+UoNAGPen15QKaVUZQcMGJ009PJlmU6Qe40RoBAeOEb3MxkHETNYUifg0XkAxxM3ir7G8wLzQke710DGY5Zl4C0lOA6dBpyyD9vWCKs30oxOmwlZBBUgArj8ByFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777326285; c=relaxed/simple;
	bh=TORFkzcmqibz8iwzQ1hCP7EmV48Iz6qRbbqBOsvvSPo=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=F6mPFxTl/846f4pdk+ZDf+tyhrn8WaK5jbGx8AgcKqOpp3vYGvgPzHVgrbTw+8byPzVCOTGmCqXCpxh9xCAuYiYMzLg1Td8ips71g0uEN2hlOD90eBpjh7cqhgafgajgSawmJNXrk0BsgNDUcv2Z/ZA1B9/PYGEVW5iMLPkOtGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.210.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f72.google.com with SMTP id 46e09a7af769-7dcda136050so10471139a34.2
        for <syzbot@lists.linux.dev>; Mon, 27 Apr 2026 14:44:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777326282; x=1777931082;
        h=content-transfer-encoding:cc:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=G4CXgyCiVlB4O8NrV/3qncK31gztZgGNJht59aokC/4=;
        b=FnUkvRmktfjFfIPAkMK5H3LRH3DmReHyLtvIUrz6AZonjBQtHgRY1PM+4EFI4p9xUD
         BQ2934Yi7Eq5IvJH5ayRa+E0eM1pRWYmfd/UxiBl6FfVd38jK+6lk2wn7Msw1aX0LIT1
         wyaz/GnX1+Z3D/pNIju5YiK7n324EklrI9OPggplHl9brTCHh5nWNRsVeWPB1quf62N+
         cyj3mfmVDscaxMh3Cxto60kSPny2D3YQl56Pl8jAwEWgXYGG88d9Hzo200ThxeGADS7n
         wQ1CLXirNoNwOC5YQqiIC6Dir44DWoznG2HdhkRzEactsP+PttWc2DzGWQrt3z4CWUh7
         p5gQ==
X-Gm-Message-State: AOJu0YyliasFnNQVs9xvv1p4/A1vbnc8nPsKdGOJWXLAzOsoDOc2Y3I/
	Ao0k2wxLpW0+UEz3D/gthtv2eEU8v/m5NQWfAsnJfnVPnJF4WYSLwciNJ9k5WrvOFKfH2zSFQ7M
	YkegTSNuxsHkBRPoQ6GpyqVPiqrjAgpcvl6vocFHndGAoABENJ0tVlGSFKjk=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:16a7:b0:694:8646:9933 with SMTP id
 006d021491bc7-6965ca3ed94mr202052eaf.9.1777326282113; Mon, 27 Apr 2026
 14:44:42 -0700 (PDT)
Date: Mon, 27 Apr 2026 14:44:42 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69efd8ca.050a0220.18b4f.0007.GAE@google.com>
Subject: [moderation/CI] Re: uaccess: Convert small fixed size
 copy_{to/from}_user() to scoped user access
From: syzbot ci <syzbot+ci59ae1c0b8d5ca61e@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v1] uaccess: Convert small fixed size copy_{to/from}_user() to scoped user=
 access
https://lore.kernel.org/all/cover.1777306795.git.chleroy@kernel.org
* [RFC PATCH v1 1/9] uaccess: Split check_zeroed_user() out of usercopy.c
* [RFC PATCH v1 2/9] uaccess: Convert INLINE_COPY_{TO/FROM}_USER to kconfig=
 and reduce ifdefery
* [RFC PATCH v1 3/9] x86/umip: Be stricter in fixup_umip_exception()
* [RFC PATCH v1 4/9] uaccess: Introduce copy_{to/from}_user_partial()
* [RFC PATCH v1 5/9] uaccess: Switch to copy_{to/from}_user_partial() when =
relevant
* [RFC PATCH v1 6/9] uaccess: Change copy_{to/from}_user to return -EFAULT
* [RFC PATCH v1 7/9] x86: Add unsafe_copy_from_user()
* [RFC PATCH v1 8/9] arm64: Add unsafe_copy_from_user()
* [RFC PATCH v1 9/9] uaccess: Convert small fixed size copy_{to/from}_user(=
) to scoped user access

and found the following issue:
general protection fault in rt_sigprocmask

Full report is available here:
https://ci.syzbot.org/series/aa7fc2a4-0ff8-418d-a7f8-d564d6337c56

***

general protection fault in rt_sigprocmask

tree:      bpf-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/bpf/bpf=
-next.git
base:      7c8d208d816d0504aa916138ae097d9cb4ed4e56
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp=
1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/e539adaf-05e5-409c-80f8-973dab3db2a=
7/config

Key type big_key registered
Key type encrypted registered
AppArmor: AppArmor sha256 policy hashing enabled
ima: No TPM chip found, activating TPM-bypass!
Loading compiled-in module X.509 certificates
Loaded X.509 cert 'Build time autogenerated kernel key: 63d9792cbf98a5c58c0=
509974cba8c406c7870ed'
ima: Allocated hash algorithm: sha256
ima: No architecture policies found
evm: Initialising EVM extended attributes:
evm: security.selinux (disabled)
evm: security.SMACK64 (disabled)
evm: security.SMACK64EXEC (disabled)
evm: security.SMACK64TRANSMUTE (disabled)
evm: security.SMACK64MMAP (disabled)
evm: security.apparmor
evm: security.ima
evm: security.capability
evm: HMAC attrs: 0x1
PM:   Magic number: 6:723:551
block sda: hash matches
acpi PNP0C0F:02: hash matches
netconsole: network logging started
gtp: GTP module loaded (pdp ctx size 128 bytes)
rdma_rxe: loaded
cfg80211: Loading compiled-in X.509 certificates for regulatory database
Loaded X.509 cert 'sforshee: 00b28ddf47aef9cea7'
Loaded X.509 cert 'wens: 61c038651aabdcf94bd0ac7ff06c7248db18c600'
clk: Disabling unused clocks
ALSA device list:
  #0: Dummy 1
  #1: Loopback 1
  #2: Virtual MIDI Card 1
md: Waiting for all devices to be available before autodetect
md: If you don't use raid, use raid=3Dnoautodetect
md: Autodetecting RAID arrays.
md: autorun ...
md: ... autorun DONE.
EXT4-fs (sda1): mounted filesystem b4773fba-1738-4da0-8a90-0fe043d0a496 ro =
with ordered data mode. Quota mode: none.
VFS: Mounted root (ext4 filesystem) readonly on device 8:1.
devtmpfs: mounted
VFS: Pivoted into new rootfs
Freeing unused kernel image (initmem) memory: 26948K
Write protecting the kernel read-only data: 221184k
Freeing unused kernel image (text/rodata gap) memory: 2032K
Freeing unused kernel image (rodata/data gap) memory: 1428K
x86/mm: Checked W+X mappings: passed, no W+X pages found.
x86/mm: Checking user space page tables
x86/mm: Checked W+X mappings: passed, no W+X pages found.
Failed to set sysctl parameter 'max_rcu_stall_to_panic=3D1': parameter not =
found
Run /sbin/init as init process
Oops: general protection fault, probably for non-canonical address 0xe0000b=
e81c51ea95: 0000 [#1] SMP KASAN PTI
KASAN: probably user-memory-access in range [0x00007f40e28f54a8-0x00007f40e=
28f54af]
CPU: 1 UID: 0 PID: 1 Comm: init Not tainted syzkaller #0 PREEMPT(full)=20
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16=
.2-1 04/01/2014
RIP: 0010:__se_sys_rt_sigprocmask+0x139/0x310
Code: 00 00 e8 3a f1 a5 00 48 b8 00 f0 ff ff ff 7f 00 00 49 39 c4 4c 0f 47 =
e0 0f 1f 00 48 8d 44 24 60 48 8b 08 4c 89 e0 48 c1 e8 03 <80> 3c 18 00 74 0=
e 4c 89 e7 48 89 cb e8 56 ef a5 00 48 89 d9 49 89
RSP: 0018:ffffc90000067de0 EFLAGS: 00010206
RAX: 00000fe81c51ea95 RBX: dffffc0000000000 RCX: 0000000000000000
RDX: 0000000000000001 RSI: 0000000000000008 RDI: ffffc90000067e40
RBP: ffffc90000067ee0 R08: ffffc90000067e47 R09: 1ffff9200000cfc8
R10: dffffc0000000000 R11: fffff5200000cfc9 R12: 00007f40e28f54a8
R13: 1ffff9200000cfc0 R14: ffff8881026f6210 R15: 1ffff110204dec42
FS:  00007f40e25f5380(0000) GS:ffff8882a8fd4000(0000) knlGS:000000000000000=
0
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f40e28baf3f CR3: 0000000171dca000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 do_syscall_64+0x15f/0xf80
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f40e26f5773
Code: 00 f3 a5 48 8d 74 24 88 48 b9 ff ff ff 7f fe ff ff ff 48 21 c8 48 89 =
44 24 88 41 ba 08 00 00 00 44 89 c7 b8 0e 00 00 00 0f 05 <45> 31 c0 3d 00 f=
0 ff ff 76 06 41 89 c0 41 f7 d8 44 89 c0 5a c3 41
RSP: 002b:00007fffc2ca58c0 EFLAGS: 00000246 ORIG_RAX: 000000000000000e
RAX: ffffffffffffffda RBX: 00007fffc2ca5ac8 RCX: 00007f40e26f5773
RDX: 0000000000000000 RSI: 00007f40e28f54a8 RDI: 0000000000000000
RBP: 00007f40e28f54a8 R08: 0000000000000000 R09: 00007f40e2904b5d
R10: 0000000000000008 R11: 0000000000000246 R12: 00007f40e28f54a0
R13: 00007fffc2ca5ad8 R14: 0000562515803169 R15: 00007f40e292ea80
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:__se_sys_rt_sigprocmask+0x139/0x310
Code: 00 00 e8 3a f1 a5 00 48 b8 00 f0 ff ff ff 7f 00 00 49 39 c4 4c 0f 47 =
e0 0f 1f 00 48 8d 44 24 60 48 8b 08 4c 89 e0 48 c1 e8 03 <80> 3c 18 00 74 0=
e 4c 89 e7 48 89 cb e8 56 ef a5 00 48 89 d9 49 89
RSP: 0018:ffffc90000067de0 EFLAGS: 00010206
RAX: 00000fe81c51ea95 RBX: dffffc0000000000 RCX: 0000000000000000
RDX: 0000000000000001 RSI: 0000000000000008 RDI: ffffc90000067e40
RBP: ffffc90000067ee0 R08: ffffc90000067e47 R09: 1ffff9200000cfc8
R10: dffffc0000000000 R11: fffff5200000cfc9 R12: 00007f40e28f54a8
R13: 1ffff9200000cfc0 R14: ffff8881026f6210 R15: 1ffff110204dec42
FS:  00007f40e25f5380(0000) GS:ffff8882a8fd4000(0000) knlGS:000000000000000=
0
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f40e28baf3f CR3: 0000000171dca000 CR4: 00000000000006f0


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
[akpm@linux-foundation.org amd-gfx@lists.freedesktop.org bpf@vger.kernel.or=
g chleroy@kernel.org david.laight.linux@gmail.com dmaengine@vger.kernel.org=
 dri-devel@lists.freedesktop.org intel-gfx@lists.freedesktop.org kasan-dev@=
googlegroups.com kvm@vger.kernel.org linux-alpha@vger.kernel.org linux-arch=
@vger.kernel.org linux-arm-kernel@lists.infradead.org linux-csky@vger.kerne=
l.org linux-efi@vger.kernel.org linux-fsdevel@vger.kernel.org linux-fsi@lis=
ts.ozlabs.org linux-hexagon@vger.kernel.org linux-kernel@vger.kernel.org li=
nux-m68k@lists.linux-m68k.org linux-media@vger.kernel.org linux-mips@vger.k=
ernel.org linux-mm@kvack.org linux-openrisc@vger.kernel.org linux-parisc@vg=
er.kernel.org linux-riscv@lists.infradead.org linux-s390@vger.kernel.org li=
nux-serial@vger.kernel.org linux-sh@vger.kernel.org linux-snps-arc@lists.in=
fradead.org linux-sound@vger.kernel.org linux-spi@vger.kernel.org linux-sta=
ging@lists.linux.dev linux-um@lists.infradead.org linux-usb@vger.kernel.org=
 linux-wireless@vger.kernel.org linux-wpan@vger.kernel.org linux-x25@vger.k=
ernel.org linuxppc-dev@lists.ozlabs.org loongarch@lists.linux.dev netdev@vg=
er.kernel.org ocfs2-devel@lists.linux.dev rust-for-linux@vger.kernel.org so=
und-open-firmware@alsa-project.org sparclinux@vger.kernel.org tglx@linutron=
ix.de torvalds@linux-foundation.org xen-devel@lists.xenproject.org ynorov@n=
vidia.com]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

