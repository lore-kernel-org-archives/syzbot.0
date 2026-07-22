Received: from mail-oo1-f72.google.com (mail-oo1-f72.google.com [209.85.161.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B463B2F290A
	for <syzbot@lists.linux.dev>; Wed, 22 Jul 2026 13:15:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784726142; cv=none; b=QWikOOc54mp5sffeeQg2jm64ofRJKk0pcXQlI5sl43UaasvXzWSbakCnDxdEOnyiLX0QszyP1Zil055nqWVrGXCvFdl4gtz0hw/lcEsOhKWV7ZIYL8+ng0XIOus3zWHR3xEEBtcfoHDVXmkWyVQVrVzhoU4SlSQKIavvzUyu/Yo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784726142; c=relaxed/simple;
	bh=fkgdAqB/uc1L1zR9WesaWVWV5DHkVv+Pd0UO8mCvaiw=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=MVBXIZ0kOWBBCetGB3BYD6itPKvhRDOyc3/5Sx5/Zyvv+YcCyKxWSuUiSd9chtarANku5JVGHOU5loNbPdEKnUAyVYk23iCE1AlC3a1pJ3FYpSK6UGyApD9unHcuc2Po3LbvD0PA4j0tOXa50QfoSSwQBoTSGJS1TcARHWkSFCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f72.google.com with SMTP id 006d021491bc7-6a313ec13ceso8704353eaf.2
        for <syzbot@lists.linux.dev>; Wed, 22 Jul 2026 06:15:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784726139; x=1785330939;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:date:mime-version:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=YoMqayvL5pgNzLZDf6eOd/JahSWMruFJDnZtia6e8/g=;
        b=UcO4sJAu8DjkyuG2Xy30sUSlW4qCZE3wwobZOPb0BNsYOa0HTLhondAhY44YDaZBLS
         RvN6uwb+hPlEyUZrRsV67U1onhlnZhHRbWUBVcxNoHvY99fMJoGemoZVMzmDig0b2BXj
         fPEp/JBNZPUm+o4h7CNClPOj8Y6C0ym/TPSwDBEn3XNqC9mBxOtjGSFsTC6aixj6/CKT
         5MUdd+Ey5tdWQDGmt0fNYXqN6CSpTexsnGsLe5nFJ4lN0EFBPKTRjQosqDAKxL2oXcLp
         FX0MWJGD83jYU4ZGodrVMYMfgJ8NQ8QRaiCLGIF0UvT7sHSjE3gkU0qmto8iQSpYfsSo
         4uiw==
X-Gm-Message-State: AOJu0YxVfoaSF1WuGyIKoPv5BnyrX4dSNyLj8XZAPRw1zLm8cOE/0qZt
	fEZzULsOD30lxcz7szoJyOIECXOJlC8+8WWGu+jzQCXZLvuNuDBQjPaueQdHNMZwRwqU0BSZIRZ
	yn6c+CDVoPNCtkZAz9J2NRy3Tzcu1W5+xN2ZvRPThbrymaFajpuozIKe7bec=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:1c92:b0:6aa:c76b:6c42 with SMTP id
 006d021491bc7-6aac76b7023mr684069eaf.51.1784726139534; Wed, 22 Jul 2026
 06:15:39 -0700 (PDT)
Date: Wed, 22 Jul 2026 06:15:39 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a60c27b.33ea6125.251e5.0009.GAE@google.com>
Subject: [moderation/CI] Re: arch, mm: create a generic set_memory/change_page_attr
 core
From: syzbot ci <syzbot+ci505703d15679e65e@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v1] arch, mm: create a generic set_memory/change_page_attr core
https://lore.kernel.org/all/20260721-generic-set-memory-v0-1-v1-0-2c1fc6230=
6b3@kernel.org
* [PATCH RFC 01/18] x86/mm/pat: Don't gate cpa_lock on debug_pagealloc_enab=
led()
* [PATCH RFC 02/18] x86/mm/pat: fix effective RW computation in lookup_addr=
ess_in_pgd_attr()
* [PATCH RFC 03/18] x86/mm/pat: replace x86-speficic pg_level with generic =
pgtable_level
* [PATCH RFC 04/18] x86/mm/pat: use page table accessors for effective RW/N=
X bits
* [PATCH RFC 05/18] x86/mm/pat: use a generic helper for the large page siz=
e
* [PATCH RFC 06/18] x86/mm/pat: introduce an inline helper to check if alia=
s needs update
* [PATCH RFC 07/18] x86/mm/pat: introduce cpa_handle_large_page()
* [PATCH RFC 08/18] x86/mm/pat: use cpa_split_data structure to pass split =
parameters
* [PATCH RFC 09/18] x86/mm/pat: use a single locked lookup for PTE verifica=
tion
* [PATCH RFC 10/18] x86/mm/pat: move the large page size calculation to sho=
uld_split_large_page
* [PATCH RFC 11/18] x86/mm/pat, mm: set_memory: pull change_page_attr() cor=
e to mm/
* [PATCH RFC 12/18] x86/pat/mm, mm/set_memory: abstract the CPA page table =
lock
* [PATCH RFC 13/18] mm/set_memory: read page table entries with pXdp_get()
* [PATCH RFC 14/18] x86/mm/pat, mm: move cpa-test to mm
* [PATCH RFC 15/18] riscv: convert set_memory to the generic CPA implementa=
tion
* [PATCH RFC 16/18] riscv: make set_direct_map_*_noflush actually noflush
* [PATCH RFC 17/18] loongarch: convert set_memory to the generic CPA implem=
entation
* [PATCH RFC 18/18] loongarch: make set_direct_map_*_noflush actually noflu=
sh

and found the following issue:
WARNING in arch_should_split_large_page

Full report is available here:
https://ci.syzbot.org/series/08799ddb-4fca-4e5c-a2a7-a16eb2845851

***

WARNING in arch_should_split_large_page

tree:      bpf-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/bpf/bpf=
-next.git
base:      dc59e4fea9d83f03bad6bddf3fa2e52491777482
arch:      amd64
compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp=
1~20260613092250.77), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/9a435490-f68f-4ca0-96ae-457a5caa17e=
6/config

Demotion targets for Node 1: null
debug_vm_pgtable: [debug_vm_pgtable         ]: Validating architecture page=
 table helpers
Key type .fscrypt registered
Key type fscrypt-provisioning registered
kAFS: Red Hat AFS client v0.1 registering.
Btrfs loaded, assert=3Don, zoned=3Dyes, fsverity=3Dyes
Key type big_key registered
Key type encrypted registered
AppArmor: AppArmor sha256 policy hashing enabled
ima: No TPM chip found, activating TPM-bypass!
Loading compiled-in module X.509 certificates
Loaded X.509 cert 'Build time autogenerated kernel key: dc5bfa299b381f3c121=
e230b24acaec0874c302b'
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
PM:   Magic number: 2:551:79
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
Freeing unused kernel image (initmem) memory: 26964K
Write protecting the kernel read-only data: 221184k
Testing CPA: undo ffffffff81000000-ffffffff8e800000
------------[ cut here ]------------
CPA detected W^X violation: 00000000000001a1 -> 00000000000001a3 range: 0xf=
fffffff81000000 - 0xffffffff811fffff PFN 1000
WARNING: arch/x86/mm/pat/set_memory.c:601 at arch_should_split_large_page+0=
x493/0x710, CPU#0: swapper/0/1
Modules linked in:
CPU: 0 UID: 0 PID: 1 Comm: swapper/0 Not tainted syzkaller #0 PREEMPT(full)=
=20
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16=
.2-1 04/01/2014
RIP: 0010:arch_should_split_large_page+0x49e/0x710
Code: 00 48 8b 44 24 20 48 25 00 f0 ff ff 48 8b 4c 24 08 4c 8d 04 08 49 ff =
c8 48 8d 3d 4d 66 e1 0e 4c 89 ee 48 89 ea 4c 8b 4c 24 18 <67> 48 0f b9 3a e=
b 05 e8 46 37 4d 00 4c 89 f7 48 89 ee e8 9b 39 4d
RSP: 0000:ffffc900000679f0 EFLAGS: 00010296
RAX: 0000000000200000 RBX: 0000000000000123 RCX: ffffffff81000000
RDX: 00000000000001a3 RSI: 00000000000001a1 RDI: ffffffff905a8280
RBP: 00000000000001a3 R08: ffffffff811fffff R09: 0000000000001000
R10: 0000000000000003 R11: 0000000000000000 R12: 0000000000000002
R13: 00000000000001a1 R14: 00000000000001a3 R15: 0000000000000002
FS:  0000000000000000(0000) GS:ffff88818d95a000(0000) knlGS:000000000000000=
0
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffff88823ffff000 CR3: 000000000e946000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 __change_page_attr_set_clr+0x936/0x12d0
 change_page_attr_set_clr+0x3ac/0x450
 set_memory_rw+0x8c/0xd0
 mark_rodata_ro+0xf0/0x140
 kernel_init+0x4e/0x1d0
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

To test a patch for this bug, please reply with `#syz test`
(should be on a separate line).

The patch should be attached to the email.
Note: arguments like custom git repos and branches are not supported.

The email will later be sent to:
[akpm@linux-foundation.org aou@eecs.berkeley.edu bp@alien8.de catalin.marin=
as@arm.com chenhuacai@kernel.org dave.hansen@intel.com dave.hansen@linux.in=
tel.com david@kernel.org hpa@zytor.com jackmanb@google.com jgross@suse.com =
kevin.brodsky@arm.com liam@infradead.org linux-arm-kernel@lists.infradead.o=
rg linux-kernel@vger.kernel.org linux-mm@kvack.org linux-riscv@lists.infrad=
ead.org ljs@kernel.org loongarch@lists.linux.dev luto@kernel.org mhocko@sus=
e.com mingo@kernel.org mingo@redhat.com palmer@dabbelt.com peterz@infradead=
.org pjw@kernel.org rppt@kernel.org surenb@google.com tglx@kernel.org vbabk=
a@kernel.org will@kernel.org x86@kernel.org]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

