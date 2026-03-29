Received: from mail-ot1-f72.google.com (mail-ot1-f72.google.com [209.85.210.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B83E155C97
	for <syzbot@lists.linux.dev>; Sun, 29 Mar 2026 19:57:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774814267; cv=none; b=oHPze0Gn7IwaDVpsLOCZvP8iwO/6nFbfsJs9DHf7N8QZyZJ//GaWkdLlMDavdCRTUAg65jRzItFTiAvlK396lPI/GdER8HncGfMVGtGiuMQuzNQxcfeceSYpbS794wyFm4wV8nWp0a+JnygdLv0IguYDpazsSkTeSG4oi1C/7po=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774814267; c=relaxed/simple;
	bh=OFcf0ewjvs17mBPK0hxzIJnQZOeV50A//nSqOzULNfU=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=lVD5G4bWcL44MzaY0YD/Wzj3zBq/+5bpcqKeK8G0gToprT91Bh5EvvvyY/623rzQeH+l9gzFjaLhu7D1MGaS6yMzZXLmO8LLsK8wpn0sdas1P4hBAsTOkFjvXaW3CzmUEJSd3KCyNh8L/fzEiNvriorNwjDXsKXMh733wMVqIfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.210.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f72.google.com with SMTP id 46e09a7af769-7d7efc5a904so14198414a34.3
        for <syzbot@lists.linux.dev>; Sun, 29 Mar 2026 12:57:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774814264; x=1775419064;
        h=cc:to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=AK+78UNb67PQgkuTqu6jqs7GMSiOe2fD0RerX1uNaO8=;
        b=M/wPUsKlI+boAysDA6RV054ztRI4oG9EExCaB9sBK7vngEyceRCEcooNmUxO6/CJNz
         y+rBoqBsVz+vJIKKZvBAadjWABEe8UihIA6eSFjfU9AoR4eIvjZy+igI7ESW8JgKZJHN
         Uv1MUxWc+3dtp0vtXFYh2v/b4mmDF6Oo9cgplw6PKyKlrpkNK4PvTPY31mZQl2KdyDwO
         Yfe/MCR2+HY1cNYVjrAfovlkc0ZSTxQwqi+ePAMPrQYroIRUDKGsRkz8JqOwlZOgTnAX
         0MfaZ2CWKSDh7ixLiN7HzGlfFYfGnbpbzynR/FXR4nxB6oXHrNUHs538K5PT/ucLYpUH
         0uVw==
X-Gm-Message-State: AOJu0YwZYuJtPxgu8eqPzqzvnQAAs8xVvIDApXZNxtqJk76USwdmZwGP
	seixD2cTgtpB63TSy95qfexRtNrhTDWYZyLlIa2ncbB7u4ezCVhqbvH8Kgm3bqqHrPis7xFB/lE
	IO2/b+YGCdI8k4buFbZt9ztT2MjLnSNtv6Sqcimq1j/QYANRozs3/mM8BAaA=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:f02d:b0:67e:dab:7d13 with SMTP id
 006d021491bc7-67e18639c45mr5690787eaf.21.1774814264616; Sun, 29 Mar 2026
 12:57:44 -0700 (PDT)
Date: Sun, 29 Mar 2026 12:57:44 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69c98438.a70a0220.128fd0.0037.GAE@google.com>
Subject: [moderation/CI] Re: assorted ->i_count changes + extension of
 lockless handling
From: syzbot ci <syzbot+ci84768f4d20490e70@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v3] assorted ->i_count changes + extension of lockless handling
https://lore.kernel.org/all/20260329172002.3557801-1-mjguzik@gmail.com
* [PATCH v3 1/7] fs: add icount_read_once()
* [PATCH v3 2/7] Use icount_read() and icount_read_once() as appropriate.
* [PATCH v3 3/7] fs: enforce locking in icount_read(), add some commentary
* [PATCH v3 4/7] fs: relocate and tidy up ihold()
* [PATCH v3 5/7] fs: handle hypothetical filesystems which use I_DONTCACHE and drop the lock in ->drop_inode
* [PATCH v3 6/7] fs: locklessly bump refs in igrab as long as it does not transition 0->1
* [PATCH v3 7/7] fs: locklessly bump refs in the inode hash when possible

and found the following issue:
WARNING in bdev_file_open_by_dev

Full report is available here:
https://ci.syzbot.org/series/ed1deb86-adfc-43a1-bec0-01d8189f1e9f

***

WARNING in bdev_file_open_by_dev

tree:      linux-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/next/linux-next
base:      3b058d1aeeeff27a7289529c4944291613b364e9
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/84ba2ea1-23ea-425b-8339-8acab8f7ad4b/config

9p: Installing v9fs 9p2000 file system support
NILFS version 2 loaded
befs: version: 0.9.3
ocfs2: Registered cluster interface o2cb
ocfs2: Registered cluster interface user
OCFS2 User DLM kernel interface loaded
gfs2: GFS2 installed
ceph: loaded (mds proto 32)
cryptd: max_cpu_qlen set to 1000
NET: Registered PF_ALG protocol family
async_tx: api initialized (async)
Key type asymmetric registered
Asymmetric key parser 'x509' registered
Asymmetric key parser 'pkcs8' registered
Key type pkcs7_test registered
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 239)
io scheduler mq-deadline registered
io scheduler kyber registered
io scheduler bfq registered
xor: measuring software checksum speed
   prefetch64-sse  :  6910 MB/sec
   sse             :  6480 MB/sec
xor: using function: prefetch64-sse (6910 MB/sec)
input: Power Button as /devices/platform/LNXPWRBN:00/input/input0
ACPI: button: Power Button [PWRF]
ioatdma: Intel(R) QuickData Technology Driver 5.00
ACPI: \_SB_.GSIG: Enabled at IRQ 22
N_HDLC line discipline registered with maxframe=4096
Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
00:03: ttyS0 at I/O 0x3f8 (irq = 4, base_baud = 115200) is a 16550A
Non-volatile memory driver v1.3
Linux agpgart interface v0.103
usbcore: registered new interface driver xillyusb
ACPI: bus type drm_connector registered
[drm] Initialized vgem 1.0.0 for vgem on minor 0
[drm] Initialized vkms 1.0.0 for vkms on minor 1
Console: switching to colour frame buffer device 128x48
faux_driver vkms: [drm] fb0: vkmsdrmfb frame buffer device
usbcore: registered new interface driver udl
bochs-drm 0000:00:01.0: vgaarb: deactivate vga console
[drm] Found bochs VGA, ID 0xb0c5.
[drm] Framebuffer size 16384 kB @ 0xfd000000, mmio @ 0xfebf0000.
[drm] Initialized bochs-drm 1.0.0 for 0000:00:01.0 on minor 2
fbcon: bochs-drmdrmfb (fb1) is primary device
fbcon: Remapping primary device, fb1, to tty 1-63
bochs-drm 0000:00:01.0: [drm] fb1: bochs-drmdrmfb frame buffer device
usbcore: registered new interface driver gm12u320
usbcore: registered new interface driver gud
------------[ cut here ]------------
debug_locks && !(lock_is_held(&(&inode->i_lock)->dep_map) != 0)
WARNING: ./include/linux/fs.h:2242 at ihold+0x102/0x170, CPU#1: swapper/0/1
Modules linked in:
CPU: 1 UID: 0 PID: 1 Comm: swapper/0 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:ihold+0x102/0x170
Code: b7 7c ff 83 fb 02 7c 11 e8 2b b3 7c ff 5b 41 5e 41 5f 5d e9 c0 e0 6b 09 cc e8 1a b3 7c ff 90 0f 0b 90 eb e9 e8 0f b3 7c ff 90 <0f> 0b 90 e9 6d ff ff ff 48 c7 c1 e0 bd 12 90 80 e1 07 80 c1 03 38
RSP: 0000:ffffc90000067680 EFLAGS: 00010293
RAX: ffffffff82496f71 RBX: ffff888167cb06a0 RCX: ffff888102a957c0
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: 0000000000000000 R08: ffff888167cb08a7 R09: 1ffff1102cf96114
R10: dffffc0000000000 R11: ffffed102cf96115 R12: ffff888167cb0000
R13: ffff888169632e00 R14: 0000000000000000 R15: dffffc0000000000
FS:  0000000000000000(0000) GS:ffff8882a943f000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 000000000e54a000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 bdev_file_open_by_dev+0x1aa/0x240
 disk_scan_partitions+0x1c1/0x2c0
 add_disk_fwnode+0x321/0x480
 brd_alloc+0x5b9/0x7c0
 brd_init+0xc1/0x120
 do_one_initcall+0x250/0x870
 do_initcall_level+0x104/0x190
 do_initcalls+0x59/0xa0
 kernel_init_freeable+0x2a6/0x3e0
 kernel_init+0x1d/0x1d0
 ret_from_fork+0x514/0xb70
 ret_from_fork_asm+0x1a/0x30
 </TASK>


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[brauner@kernel.org jack@suse.cz linux-fsdevel@vger.kernel.org linux-kernel@vger.kernel.org mjguzik@gmail.com viro@zeniv.linux.org.uk]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

