Received: from mail-ot1-f72.google.com (mail-ot1-f72.google.com [209.85.210.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B92227FD4B
	for <syzbot@lists.linux.dev>; Fri,  1 May 2026 00:59:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777597179; cv=none; b=gk/lBUAf9k/pzdvoc0NiMqpE+K7hgR9JRESJSC/3P/WikaryO1yTOQBS2bBJFDVVCIjfBQv3L5MMcCHQDzf2eUEB0M+uP58cMI9KREUlh0n4YqG8kP1U6lPmpGeWPNh2AM8YTvaYu87VcZrXLJur4aKJxHYp+zC4jnXXokE91o8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777597179; c=relaxed/simple;
	bh=6fPOZCS4sggtoBlt2up/qsa40k4FpAm0gVeYmmEvUNQ=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=ESbmtzZwOMBtuo6Iv4lGJMlMkM+axRFPjPJlg+89wGQSPI/LP+NO9JcXMHJA19PrnnvhS3GIj6WyYoj/nLLKdFDhNkFn1M7X5I2kmrzNwgH7S2kYkyAgpUfiNgpcvZVcyvyA1gXMsWxzm/vvUCEa5bKO8KkzoF3zpRjSTd/pPa8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.210.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f72.google.com with SMTP id 46e09a7af769-7d4c7afa9e0so2923455a34.0
        for <syzbot@lists.linux.dev>; Thu, 30 Apr 2026 17:59:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777597177; x=1778201977;
        h=cc:to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=JXXn7baofuUtcPM9qSWUecXDxPElDyxNfHv4NEkfHI4=;
        b=H5p5ae8zTrPngsKEubfHhqsICDZrMX960seZjqse4PsBEiEwtiS8ZpR4slka3rRc+v
         SYWr4S0wsKKLVzApzYvxXeSV0V9oDip1gnIyJEsTg3KS+isUf9BCvYsVkedpJ0NZQHP3
         sJtOMASqB+fi4/47vD1GkbO28IhLEagGGkEypwVM5MpeMGPi5sz8m62PeM1XSkbS6jqu
         dseyb5jmvpaIDvDTGznYnsgCUF/vsVgpUxsrZPohSsMzcWFViEJ/dViUDS6qLFOi7jCr
         iIRk12/eCsB0f7jJBsG4hnseJIoQr0nyQLiZtWDfU7D/FUWe8BWChBJzu51hHYQa596X
         pDRQ==
X-Gm-Message-State: AOJu0YyPzAZjk2sbhRYGi5EyfLv/ULkR/SYj7YKUpGgZKtg8+1cekHAy
	O2Vu+h++65u0iXn+C3spTwGpfG+ThgRYI2cC+omWiJzZhl0SfxhykZPpv07YRz+6IwacyaNlIDj
	jGcvvaDwyw1jwT2JH+++h6H6Zn5iuVy6ZXWEdDUiylLHtRD6fOth57IIVOhI=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:4dcb:b0:696:1862:b107 with SMTP id
 006d021491bc7-6967aa5bb79mr2634032eaf.53.1777597177349; Thu, 30 Apr 2026
 17:59:37 -0700 (PDT)
Date: Thu, 30 Apr 2026 17:59:37 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69f3faf9.050a0220.312cd3.000c.GAE@google.com>
Subject: [moderation/CI] Re: KVM: combined patchset for MBEC/GMET support
From: syzbot ci <syzbot+ci3380af913ace7d85@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v5] KVM: combined patchset for MBEC/GMET support
https://lore.kernel.org/all/20260430150747.76749-1-pbonzini@redhat.com
* [PATCH 01/28] KVM: TDX/VMX: rework EPT_VIOLATION_EXEC_FOR_RING3_LIN into PROT_MASK
* [PATCH 02/28] KVM: x86/mmu: remove SPTE_PERM_MASK
* [PATCH 03/28] KVM: x86/mmu: free up bit 10 of PTEs in preparation for MBEC
* [PATCH 04/28] KVM: x86/mmu: shuffle high bits of SPTEs in preparation for MBEC
* [PATCH 05/28] KVM: x86/mmu: remove SPTE_EPT_*
* [PATCH 06/28] KVM: x86/mmu: merge make_spte_{non,}executable
* [PATCH 07/28] KVM: x86/mmu: rename and clarify BYTE_MASK
* [PATCH 08/28] KVM: x86/mmu: separate more EPT/non-EPT permission_fault()
* [PATCH 09/28] KVM: x86/mmu: introduce ACC_READ_MASK
* [PATCH 10/28] KVM: x86/mmu: pass PFERR_GUEST_PAGE/FINAL_MASK to kvm_translate_gpa
* [PATCH 11/28] KVM: x86/mmu: pass pte_access for final nGPA->GPA walk
* [PATCH 12/28] KVM: x86: make translate_nested_gpa vendor-specific
* [PATCH 13/28] KVM: x86/mmu: split XS/XU bits for EPT
* [PATCH 14/28] KVM: x86/mmu: move cr4_smep to base role
* [PATCH 15/28] KVM: VMX: enable use of MBEC
* [PATCH 16/28] KVM: nVMX: pass advanced EPT violation vmexit info to guest
* [PATCH 17/28] KVM: nVMX: pass PFERR_USER_MASK to MMU on EPT violations
* [PATCH 18/28] KVM: x86/mmu: add support for MBEC to EPT page table walks
* [PATCH 19/28] KVM: nVMX: advertise MBEC to nested guests
* [PATCH 20/28] KVM: nVMX: allow MBEC with EVMCS
* [PATCH 21/28] KVM: x86/mmu: propagate access mask from root pages down
* [PATCH 22/28] KVM: x86/mmu: introduce cpu_role bit for availability of PFEC.I/D
* [PATCH 23/28] KVM: SVM: add GMET bit definitions
* [PATCH 24/28] KVM: x86/mmu: hard code more bits in kvm_init_shadow_npt_mmu
* [PATCH 25/28] KVM: x86/mmu: add support for GMET to NPT page table walks
* [PATCH 26/28] KVM: SVM: enable GMET and set it in MMU role
* [PATCH 27/28] KVM: SVM: work around errata 1218
* [PATCH 28/28] KVM: nSVM: enable GMET for guests

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/a12399e0-93c0-4716-b18b-4a99f833e7ed

***

kernel build error

tree:      torvalds
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvalds/linux
base:      dfd2a8b07c6cc94145e11d87d2f11137d6444854
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/64088e2d-9a95-464c-ac09-06cbf4f27fea/config

arch/x86/kvm/vmx/vmx.c:8710:45: error: too many arguments to function call, expected single argument 'has_ad_bits', have 2 arguments

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
[bp@alien8.de d.riley@proxmox.com jon@nutanix.com kai.huang@intel.com kvm@vger.kernel.org linux-kernel@vger.kernel.org pbonzini@redhat.com seanjc@google.com]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

