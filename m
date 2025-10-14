Received: from mail-oo1-f48.google.com (mail-oo1-f48.google.com [209.85.161.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE5EA2BDC05
	for <syzbot@lists.linux.dev>; Tue, 14 Oct 2025 06:11:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760422306; cv=none; b=mKf/iBCUgg5P8+sv+L2IDC3jIzaN3BfaKrdOUXar49Dknv5sakZ3XcNBg3Nw1Pgs1KDwtKaGR6ey3MH0RB6xEQp848oO2e8qtMJmnXZlZdOj17q9j3tcY9qS3wOEsvnqFoZuDwI7N4vxEVr6hitxXWXjhH90rj21WtSAPYknz+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760422306; c=relaxed/simple;
	bh=JWQf7msQxJQNX5hAmti+WmyIgrFHupz4+hVIe6zoDEE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=e+jQ6qrlpxpBBWfMruO0ntpKeLvnA8LEST+w8yIr3rRjVC+bb502K6mHSooXXROc+s2xJ7XULvc9+W+6lPwDlWx+mVV27Y+I4VunQUizsHa9hX4SmkOnFgoazhpPDT1VNCWDCpGulddY1MKKj837MoZfcKJIf1J5gMYqsH3lOY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=w1l5Msyi; arc=none smtp.client-ip=209.85.161.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="w1l5Msyi"
Received: by mail-oo1-f48.google.com with SMTP id 006d021491bc7-64442ff55c2so1435108eaf.2
        for <syzbot@lists.linux.dev>; Mon, 13 Oct 2025 23:11:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760422298; x=1761027098; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=skAM7MI0Xu5NEQbCxbXLjXmrNFeMH/77IN8YYzT8hNA=;
        b=w1l5Msyi4R/lnH5Xholhlo2n7OA2ZxwfCEuIr8OtcBbeo14Uelby4UoJenkOfvhnRa
         F5jcjE31uEDc18q2efAxCMI1i96yz5osgobLicbSQVkSIFWgEI0Y4CegkFF8i1Dw6PLk
         87c1TUjrjPBCkUmCOfwaaUmQelVGyafo1o93vy3jweGrdldngjLj4j7za5zugmxdpeLk
         6Dx22d9/MaVbJoh7/7whcF3wQupH8qgwiQfXFXHBJE3/akpAJ7oWczT5v3lE+lIzxWJc
         uzx1ed1ABYdgILpOzahnPGJ/wu1SG66gfLeiJOvZ5N8ow2g9YftHIJoStyhzZbgZbfAl
         dKBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760422298; x=1761027098;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=skAM7MI0Xu5NEQbCxbXLjXmrNFeMH/77IN8YYzT8hNA=;
        b=SfzJ+Jy7/csghAMv95EhWgo1uDFSZKugBX/75wKTzdOGgVikb5QpiS8GAFfgx+iNMq
         j80HuKvGycq9m9buGEK/PW0X1KqUzxG/KaeVVdlHjHNNmVhxXo5/bKSA4fAUiH6fRMl2
         LZR1tn5RlVQAVh1U6brvo3N3BRIA66qbUr6mY12ISAxi/9MGUqTAHJnBAK6xTR5UW4ml
         tPpY46kI0iL2KPNAuoA/uxzQYJfjYVaf7CbciMumyrMrQiu85hp7Z75byqg4B9XbC/x0
         DCAZ/Ez79cm8T6q8pEUtlByPKOkBHfCwmuPBjurgndCONQVYnXPIfRMcvJAkOhsEUdDg
         +eEw==
X-Forwarded-Encrypted: i=1; AJvYcCWr6EkzObulHGqBvjQHhH8+F5gLgNtvb7xWoNaBYoV5mz8H4FEXVIUvSJ4KfpsFakb9Qo3AzbM=@lists.linux.dev
X-Gm-Message-State: AOJu0YxWvhPCDv5fYcLgOq9QVX/r3mEaV4UeiShSv3qfaJhK7ua8JwIn
	DCmI9s05B7dZUXuQ00zOhj6Eekg9tkt9/lJi5CwJ1eMFNlQpt9v2NzLLfu3TbsTF4745u0IeyNr
	57V/f4hqqFrS4aAeKmaCbQIQeipI4Y0qZ+gpuCQQ4
X-Gm-Gg: ASbGncuS/BDKfEHMGgkC69mpkq1vx1G3JgLHkjF3LQcMebZ4j0+PdwlU1l51U3tpcEi
	ztLZsi0mjtwHZW2AaSxrR2ZZkbdbyURye1IfkG2UIZLdmPz4bLbsOE7oiK4G7GuW/KEj6tKGha5
	60xQYM7ntqPnVRrcH3QhTKgPvG++98GAgFYA+FW9yhz07dh+Dh8ZZEjXowk6wUKrHPFhjr7PP2/
	GIpYHeFu8ph8h1IQF0tLHXixJXzWwIy4pPiEWlWOn4K+a6KYhk0XhgNa1CFor8pRA==
X-Google-Smtp-Source: AGHT+IFcYOvk5lK73uwApC1XT9XE6r4L50QNMwV5h0ul9oMOgSPFVX5DrZ0zzD6YUhXPmWHlsIBwFfHS80k7laBaxK0=
X-Received: by 2002:a05:6808:2e47:b0:43f:7287:a5b1 with SMTP id
 5614622812f47-4417b442149mr11526283b6e.39.1760422297751; Mon, 13 Oct 2025
 23:11:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <68ede50c.050a0220.91a22.01fc.GAE@google.com>
In-Reply-To: <68ede50c.050a0220.91a22.01fc.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Tue, 14 Oct 2025 08:11:26 +0200
X-Gm-Features: AS18NWAwbcxtpaYC_2KmC0SB4jcAyGDklACH1ZDJGJI3GPGPHQiV0UZ-2ejEFr8
Message-ID: <CANp29Y5TOBQgKAr=2G0+fVi=Jjy-hEe=hXgPfe7aW=-EKQ7qbQ@mail.gmail.com>
Subject: Re: [moderation/CI] Re: Enable FRED with KVM VMX
To: syzbot ci <syzbot+ci4017c6e2ffab0228@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Tue, Oct 14, 2025 at 7:52=E2=80=AFAM syzbot ci
<syzbot+ci4017c6e2ffab0228@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v8] Enable FRED with KVM VMX
> https://lore.kernel.org/all/20251014010950.1568389-1-xin@zytor.com
> * [PATCH v8 01/21] KVM: VMX: Add support for the secondary VM exit contro=
ls
> * [PATCH v8 02/21] KVM: VMX: Initialize VM entry/exit FRED controls in vm=
cs_config
> * [PATCH v8 03/21] KVM: VMX: Disable FRED if FRED consistency checks fail
> * [PATCH v8 04/21] x86/cea: Prefix event stack names with ESTACK_
> * [PATCH v8 05/21] x86/cea: Export API for per-CPU exception stacks for K=
VM
> * [PATCH v8 06/21] KVM: VMX: Initialize VMCS FRED fields
> * [PATCH v8 07/21] KVM: VMX: Set FRED MSR intercepts
> * [PATCH v8 08/21] KVM: VMX: Save/restore guest FRED RSP0
> * [PATCH v8 09/21] KVM: VMX: Add support for saving and restoring FRED MS=
Rs
> * [PATCH v8 10/21] KVM: x86: Add a helper to detect if FRED is enabled fo=
r a vCPU
> * [PATCH v8 11/21] KVM: VMX: Virtualize FRED event_data
> * [PATCH v8 12/21] KVM: VMX: Virtualize FRED nested exception tracking
> * [PATCH v8 13/21] KVM: x86: Save/restore the nested flag of an exception
> * [PATCH v8 14/21] KVM: x86: Mark CR4.FRED as not reserved
> * [PATCH v8 15/21] KVM: VMX: Dump FRED context in dump_vmcs()
> * [PATCH v8 16/21] KVM: x86: Advertise support for FRED
> * [PATCH v8 17/21] KVM: nVMX: Add support for the secondary VM exit contr=
ols
> * [PATCH v8 18/21] KVM: nVMX: Add FRED VMCS fields to nested VMX context =
handling
> * [PATCH v8 19/21] KVM: nVMX: Add FRED-related VMCS field checks
> * [PATCH v8 20/21] KVM: nVMX: Add prerequisites to SHADOW_FIELD_R[OW] mac=
ros
> * [PATCH v8 21/21] KVM: nVMX: Allow VMX FRED controls
>
> and found the following issue:
> WARNING in vmread_error
>
> Full report is available here:
> https://ci.syzbot.org/series/706e7cbc-a7af-4357-af68-194e1c883968
>
> ***
>
> WARNING in vmread_error
>
> tree:      torvalds
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torva=
lds/linux
> base:      0d97f2067c166eb495771fede9f7b73999c67f66
> arch:      amd64
> compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~e=
xp1~20250708183702.136), Debian LLD 20.1.8
> config:    https://ci.syzbot.org/builds/0033ed68-ef22-4ef4-a630-0d101fb2c=
b8e/config
> C repro:   https://ci.syzbot.org/findings/a19ef524-0065-4a83-abb5-c42a195=
ec916/c_repro
> syz repro: https://ci.syzbot.org/findings/a19ef524-0065-4a83-abb5-c42a195=
ec916/syz_repro
>
> ------------[ cut here ]------------
> vmread failed: field=3D281a
> WARNING: CPU: 0 PID: 5954 at arch/x86/kvm/vmx/vmx.c:425 vmread_error+0x7e=
/0x90 arch/x86/kvm/vmx/vmx.c:425
> Modules linked in:
> CPU: 0 UID: 0 PID: 5954 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:vmread_error+0x7e/0x90 arch/x86/kvm/vmx/vmx.c:425
> Code: dc 63 8b 48 89 de 5b 5d e9 cf de cf ff e8 0a 62 68 00 c6 05 4c 67 3=
0 0e 01 90 48 c7 c7 80 db 63 8b 48 89 de e8 03 7f 2b 00 90 <0f> 0b 90 90 eb=
 98 66 66 66 2e 0f 1f 84 00 00 00 00 00 90 90 90 90
> RSP: 0018:ffffc90004d66f28 EFLAGS: 00010246
> RAX: c305e84bb7041f00 RBX: 000000000000281a RCX: ffff888109e48000
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000002
> RBP: ffffc90004d674a8 R08: ffff888121024293 R09: 1ffff11024204852
> R10: dffffc0000000000 R11: ffffed1024204853 R12: dffffc0000000000
> R13: ffff8881152e0000 R14: ffff88811292a30f R15: ffff88811292a000
> FS:  0000555576a3b500(0000) GS:ffff88818e70e000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000000000000 CR3: 00000001bda0c000 CR4: 0000000000352ef0
> Call Trace:
>  <TASK>
>  __vmcs_readl arch/x86/kvm/vmx/vmx_ops.h:111 [inline]
>  vmcs_read64 arch/x86/kvm/vmx/vmx_ops.h:177 [inline]
>  nested_vmx_enter_non_root_mode+0xa0ef/0xbb20 arch/x86/kvm/vmx/nested.c:3=
834
>  nested_vmx_run+0x5f7/0xc40 arch/x86/kvm/vmx/nested.c:4053
>  __vmx_handle_exit arch/x86/kvm/vmx/vmx.c:6821 [inline]
>  vmx_handle_exit+0x10a4/0x18c0 arch/x86/kvm/vmx/vmx.c:6838
>  vcpu_enter_guest arch/x86/kvm/x86.c:11575 [inline]
>  vcpu_run+0x446f/0x6fb0 arch/x86/kvm/x86.c:11733
>  kvm_arch_vcpu_ioctl_run+0xfc9/0x1940 arch/x86/kvm/x86.c:12072
>  kvm_vcpu_ioctl+0x95c/0xe90 virt/kvm/kvm_main.c:4476
>  vfs_ioctl fs/ioctl.c:51 [inline]
>  __do_sys_ioctl fs/ioctl.c:597 [inline]
>  __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f22ca18eec9
> Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007fff1aacefa8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
> RAX: ffffffffffffffda RBX: 00007f22ca3e5fa0 RCX: 00007f22ca18eec9
> RDX: 0000000000000000 RSI: 000000000000ae80 RDI: 0000000000000005
> RBP: 00007f22ca211f91 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f22ca3e5fa0 R14: 00007f22ca3e5fa0 R15: 0000000000000003
>  </TASK>
>
>
> ***
>
> If these findings have caused you to resend the series or submit a
> separate fix, please add the following tag to your commit message:
>   Tested-by: syzbot@syzkaller.appspotmail.com
>
> ---
> This report is generated by a bot. It may contain errors.
> syzbot ci engineers can be reached at syzkaller@googlegroups.com.
>
> The email will later be sent to:
> [andrew.cooper3@citrix.com bp@alien8.de chao.gao@intel.com corbet@lwn.net=
 dave.hansen@linux.intel.com hch@infradead.org hpa@zytor.com kvm@vger.kerne=
l.org linux-doc@vger.kernel.org linux-kernel@vger.kernel.org luto@kernel.or=
g mingo@redhat.com pbonzini@redhat.com peterz@infradead.org seanjc@google.c=
om tglx@linutronix.de x86@kernel.org xin@zytor.com]
>
> If the report looks fine to you, reply with:
> #syz upstream
>
> --
> You received this message because you are subscribed to the Google Groups=
 "syzkaller-upstream-moderation" group.
> To unsubscribe from this group and stop receiving emails from it, send an=
 email to syzkaller-upstream-moderation+unsubscribe@googlegroups.com.
> To view this discussion visit https://groups.google.com/d/msgid/syzkaller=
-upstream-moderation/68ede50c.050a0220.91a22.01fc.GAE%40google.com.
