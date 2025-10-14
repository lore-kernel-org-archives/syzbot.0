Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83DEC1D618E
	for <syzbot@lists.linux.dev>; Tue, 14 Oct 2025 05:52:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760421136; cv=none; b=HwlRuUz5BzMOW5YCc73/qvAZUZPHNkSiLhB2vwVhyFsNhNI9bPSPT612X8nLT3z3QLBCHon3xO8wGk3JgVn4NAiChl55ny0+d1nzhlAXsoJSOu8P9+TcWyBgBrqAWysrQO2mxXxGatgODu+n5MnzA7rWNVuHnKdGg2IdSEEJjeo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760421136; c=relaxed/simple;
	bh=bckm0DXe8SPPaBDtY4dmPeSPB80O7sPXtnu/f2+Nrgw=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=pxOeOIg/js/39VoMaOyZiautjtf6yx7C4EPorl+7vw6MzskIpqtQTy0nfzGVv0IalvrIYTc6sc8Xdpauqa3L4VNaC/MV93NQzn2JsPmLdP0S3Lby5D1MokttAA17Z24iREVekyMe0y37dyylaSuCGL52jsudMmDgS5dlU6CF2ak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-42f8a89bb47so154066825ab.2
        for <syzbot@lists.linux.dev>; Mon, 13 Oct 2025 22:52:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760421132; x=1761025932;
        h=content-transfer-encoding:cc:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rgp3ohpCEbxhLBfAT0tHFiZOYDr3TZ0e3A5zEdkgR68=;
        b=DeYbqLatAKSEeCnj032SBBs5rWumrAwtQj4Z9sLEO4+2mQb+Qa7B6kOOkLbWSjIzpb
         FTD5T7E/EY0GpuCms/Hj5JcstnqlUNX68aAjLL8tHYVwv4upc89/MEj1cx6JXmCqCB5E
         8GrVAfQekhEA8sBracEpwkco2wM24UML7UZMNFCXJUaD4i3Hesopv4EUZINkQTvW2s95
         Lsp0HEF9XxDZsbtYrtmV95htidQxynJrL1qpJhRFGI6Rmi1aa+ujMrsXWSMi5Qo3+dwC
         ErvNvVIzWkvJ+AJNprY2f9jvGUeHiZkOsnv5n58MW6lm3yY2j+kPByXLiwivYsEjkLeI
         kbPw==
X-Gm-Message-State: AOJu0YwSxCNYeuFjh7mtWMDmp7jPRceEaib0AV8Oz6CrG33/Ho38gER5
	u+fjWfrQyGbwmAcgKBzv7Gmzs6/K7YT7KSzmNfu0oVUxy+dmA+5TU2XOURlBmPMcu/iXTbmLb1L
	hmsRw5b2T5Yx37yEYirV4whxjYHPTUHkMCoj2pqxO1zyYnGzekuAUP+jAj5M=
X-Google-Smtp-Source: AGHT+IGHvGq8p/XIFz/IHC4tkCCRuY9u/sz79k62/tB40AQL9d3fdhRRPl6LLRtaTq+K6OzYp2D7sVqVCPjUQBsqOS10guymb8Qc
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1fcb:b0:42d:8695:12f with SMTP id
 e9e14a558f8ab-42f873fd81cmr242167925ab.23.1760421132206; Mon, 13 Oct 2025
 22:52:12 -0700 (PDT)
Date: Mon, 13 Oct 2025 22:52:12 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68ede50c.050a0220.91a22.01fc.GAE@google.com>
Subject: [moderation/CI] Re: Enable FRED with KVM VMX
From: syzbot ci <syzbot+ci4017c6e2ffab0228@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v8] Enable FRED with KVM VMX
https://lore.kernel.org/all/20251014010950.1568389-1-xin@zytor.com
* [PATCH v8 01/21] KVM: VMX: Add support for the secondary VM exit controls
* [PATCH v8 02/21] KVM: VMX: Initialize VM entry/exit FRED controls in vmcs=
_config
* [PATCH v8 03/21] KVM: VMX: Disable FRED if FRED consistency checks fail
* [PATCH v8 04/21] x86/cea: Prefix event stack names with ESTACK_
* [PATCH v8 05/21] x86/cea: Export API for per-CPU exception stacks for KVM
* [PATCH v8 06/21] KVM: VMX: Initialize VMCS FRED fields
* [PATCH v8 07/21] KVM: VMX: Set FRED MSR intercepts
* [PATCH v8 08/21] KVM: VMX: Save/restore guest FRED RSP0
* [PATCH v8 09/21] KVM: VMX: Add support for saving and restoring FRED MSRs
* [PATCH v8 10/21] KVM: x86: Add a helper to detect if FRED is enabled for =
a vCPU
* [PATCH v8 11/21] KVM: VMX: Virtualize FRED event_data
* [PATCH v8 12/21] KVM: VMX: Virtualize FRED nested exception tracking
* [PATCH v8 13/21] KVM: x86: Save/restore the nested flag of an exception
* [PATCH v8 14/21] KVM: x86: Mark CR4.FRED as not reserved
* [PATCH v8 15/21] KVM: VMX: Dump FRED context in dump_vmcs()
* [PATCH v8 16/21] KVM: x86: Advertise support for FRED
* [PATCH v8 17/21] KVM: nVMX: Add support for the secondary VM exit control=
s
* [PATCH v8 18/21] KVM: nVMX: Add FRED VMCS fields to nested VMX context ha=
ndling
* [PATCH v8 19/21] KVM: nVMX: Add FRED-related VMCS field checks
* [PATCH v8 20/21] KVM: nVMX: Add prerequisites to SHADOW_FIELD_R[OW] macro=
s
* [PATCH v8 21/21] KVM: nVMX: Allow VMX FRED controls

and found the following issue:
WARNING in vmread_error

Full report is available here:
https://ci.syzbot.org/series/706e7cbc-a7af-4357-af68-194e1c883968

***

WARNING in vmread_error

tree:      torvalds
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvald=
s/linux
base:      0d97f2067c166eb495771fede9f7b73999c67f66
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp=
1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/0033ed68-ef22-4ef4-a630-0d101fb2cb8=
e/config
C repro:   https://ci.syzbot.org/findings/a19ef524-0065-4a83-abb5-c42a195ec=
916/c_repro
syz repro: https://ci.syzbot.org/findings/a19ef524-0065-4a83-abb5-c42a195ec=
916/syz_repro

------------[ cut here ]------------
vmread failed: field=3D281a
WARNING: CPU: 0 PID: 5954 at arch/x86/kvm/vmx/vmx.c:425 vmread_error+0x7e/0=
x90 arch/x86/kvm/vmx/vmx.c:425
Modules linked in:
CPU: 0 UID: 0 PID: 5954 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(ful=
l)=20
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16=
.2-1 04/01/2014
RIP: 0010:vmread_error+0x7e/0x90 arch/x86/kvm/vmx/vmx.c:425
Code: dc 63 8b 48 89 de 5b 5d e9 cf de cf ff e8 0a 62 68 00 c6 05 4c 67 30 =
0e 01 90 48 c7 c7 80 db 63 8b 48 89 de e8 03 7f 2b 00 90 <0f> 0b 90 90 eb 9=
8 66 66 66 2e 0f 1f 84 00 00 00 00 00 90 90 90 90
RSP: 0018:ffffc90004d66f28 EFLAGS: 00010246
RAX: c305e84bb7041f00 RBX: 000000000000281a RCX: ffff888109e48000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000002
RBP: ffffc90004d674a8 R08: ffff888121024293 R09: 1ffff11024204852
R10: dffffc0000000000 R11: ffffed1024204853 R12: dffffc0000000000
R13: ffff8881152e0000 R14: ffff88811292a30f R15: ffff88811292a000
FS:  0000555576a3b500(0000) GS:ffff88818e70e000(0000) knlGS:000000000000000=
0
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 00000001bda0c000 CR4: 0000000000352ef0
Call Trace:
 <TASK>
 __vmcs_readl arch/x86/kvm/vmx/vmx_ops.h:111 [inline]
 vmcs_read64 arch/x86/kvm/vmx/vmx_ops.h:177 [inline]
 nested_vmx_enter_non_root_mode+0xa0ef/0xbb20 arch/x86/kvm/vmx/nested.c:383=
4
 nested_vmx_run+0x5f7/0xc40 arch/x86/kvm/vmx/nested.c:4053
 __vmx_handle_exit arch/x86/kvm/vmx/vmx.c:6821 [inline]
 vmx_handle_exit+0x10a4/0x18c0 arch/x86/kvm/vmx/vmx.c:6838
 vcpu_enter_guest arch/x86/kvm/x86.c:11575 [inline]
 vcpu_run+0x446f/0x6fb0 arch/x86/kvm/x86.c:11733
 kvm_arch_vcpu_ioctl_run+0xfc9/0x1940 arch/x86/kvm/x86.c:12072
 kvm_vcpu_ioctl+0x95c/0xe90 virt/kvm/kvm_main.c:4476
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:597 [inline]
 __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f22ca18eec9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 =
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff f=
f 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fff1aacefa8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007f22ca3e5fa0 RCX: 00007f22ca18eec9
RDX: 0000000000000000 RSI: 000000000000ae80 RDI: 0000000000000005
RBP: 00007f22ca211f91 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f22ca3e5fa0 R14: 00007f22ca3e5fa0 R15: 0000000000000003
 </TASK>


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[andrew.cooper3@citrix.com bp@alien8.de chao.gao@intel.com corbet@lwn.net d=
ave.hansen@linux.intel.com hch@infradead.org hpa@zytor.com kvm@vger.kernel.=
org linux-doc@vger.kernel.org linux-kernel@vger.kernel.org luto@kernel.org =
mingo@redhat.com pbonzini@redhat.com peterz@infradead.org seanjc@google.com=
 tglx@linutronix.de x86@kernel.org xin@zytor.com]

If the report looks fine to you, reply with:
#syz upstream

