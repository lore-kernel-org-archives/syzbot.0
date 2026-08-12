Received: from mail-oo1-f71.google.com (mail-oo1-f71.google.com [209.85.161.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 729C2432E9E
	for <syzbot@lists.linux.dev>; Wed, 12 Aug 2026 18:43:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786560232; cv=none; b=J7bgkZMAXmBEyi5J8dqq1Tvi0FvpfIp0lJu3+w9T73r5xJWS+d3OAB9npexVH0TR4it/iETDnq+19CdtrsYrGrMhdQCHrrSxI6zNtAg0X3iBXa0R4geFqkECC4LraAP4dshSaCKHZaMmN3FiYsK4rW/QOC7LNPvbNv+OXZfb9Gs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786560232; c=relaxed/simple;
	bh=W2CUyOOyJybBDm2eGKkfgobH1y2juKUQr/SSRHn5Fh4=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=FG4RrayEBnXCwB0KbatJdxiC9/k+sBsJkv4S3fE+zJm8qw4aY69Hlpb4PQCNGTbncw1cfbxVYA6IEUYxh2UXRWTWl/WvoNnEwbWoHT9K1QJdZjVR+bltS4nSdGqnUWj4Jtyzfj6A2ROTuf70ZLAVRUDQpeNO7VEbmdGfDxl8sss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f71.google.com with SMTP id 006d021491bc7-6ae8bc06f00so1121970eaf.3
        for <syzbot@lists.linux.dev>; Wed, 12 Aug 2026 11:43:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786560229; x=1787165029;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:date:mime-version:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=2nOnEP6s5ZFHBeRiC7l9C5aO+OftVEamtMaVLI+uigg=;
        b=S4g5rlMrsbigpffPil7x5T/NiDB9XfUaSCNLaNL5OIPqcuMiwKFU7c89vCVYpTMpkc
         awGfzt1ecsOp/DP9nw3jErPyNnAPfSkQ4fdRIFfab+R0/hfKfVC5unkdRzAutuCCZwg4
         pi+YAOzaVDjnlQXeZ2+SaWY6lW+Nav9bQKBWpijUF1/uhiTM3Kfq3WEQg/i5sa2z4Gyq
         PM2mzGwmrUFBKeafODVVuJTLtcuuwbLq476+C/6aNOx1w5wQ1Nqj6GQclatLJYK2f4gO
         jNYFCtC4ekXc5yQ3BHaCDGR+O9fG93fcu31GQwswN3SlI7dfPbDJ7OdGJcyqqRMsOZrR
         pFrA==
X-Gm-Message-State: AOJu0YxmWOhP9OrP3ZF5eLx7qK6YsFdpgOEcNbkiH0f4TJ3zrKw3IcCZ
	dgY7vU/F+hIlDGU0DE7hTq05w1fYmAEAcR8EK5fKUMCI0p6d+0mgaFBGQiwlRhPaAzvPnHMxUqL
	sUPgN6GI6MW/Z6p/zzRK1SKXPyIUdd226elCR/uMzwfOq9s4RcD01eyw8pAc=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:4b8b:b0:6b0:449e:5d15 with SMTP id
 006d021491bc7-6b0c41a23a2mr595744eaf.4.1786560229077; Wed, 12 Aug 2026
 11:43:49 -0700 (PDT)
Date: Wed, 12 Aug 2026 11:43:49 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a7cbee5.ed659fcc.23056a.0086.GAE@google.com>
Subject: [moderation/CI] Re: KVM: s390: Introduce arm64 KVM
From: syzbot ci <syzbot+ci970088ae3d7f589e@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v6] KVM: s390: Introduce arm64 KVM
https://lore.kernel.org/all/20260812153631.3376090-1-seiden@linux.ibm.com
* [PATCH v6 01/33] vfio: Use file-based reference counting for KVM
* [PATCH v6 02/33] KVM: Make device name configurable
* [PATCH v6 03/33] KVM: Allow KVM implementations to switch off MMIO indepe=
ndent of Kconfig
* [PATCH v6 04/33] arm64: Use proper include variant
* [PATCH v6 05/33] arm64: ptrace: Use constants for compat register numbers
* [PATCH v6 06/33] arm64: sysreg: Convert SPSR_ELx to automatic register ge=
neration
* [PATCH v6 07/33] KVM: arm64: Access elements of vcpu_gp_regs individually
* [PATCH v6 08/33] KVM: arm64: Use accessor functions for core regs
* [PATCH v6 09/33] arm64: Prepare sharing arm64 headers with s390
* [PATCH v6 10/33] arm64: Share arm64 headers with s390
* [PATCH v6 11/33] KVM: arm64: Share arm64 code with s390
* [PATCH v6 12/33] KVM: s390: Extract gmap tracing to a separate header
* [PATCH v6 13/33] KVM: s390: Prepare include guards for a new location
* [PATCH v6 14/33] KVM: s390: Rename kvm-s390.{c,h} to s390.{c,h}
* [PATCH v6 15/33] KVM: s390: Move kvm_host definitions to kvm_host_s390
* [PATCH v6 16/33] KVM: s390: Move s390 kvm code into a subdirectory
* [PATCH v6 17/33] KVM: s390: Move PGM code definitions to asm/kvm_host.h
* [PATCH v6 18/33] KVM: s390: Prepare gmap for a second KVM implementation
* [PATCH v6 19/33] KVM: s390: gmap: Make storage keys optional
* [PATCH v6 20/33] KVM: s390: gmap: Make CMMA optional
* [PATCH v6 21/33] KVM: s390: gmap: Make prefix handling optional
* [PATCH v6 22/33] KVM: s390: Prepare KVM/s390 for a second KVM module
* [PATCH v6 23/33] s390: Use arm64 headers
* [PATCH v6 24/33] KVM: s390: Use arm64 code
* [PATCH v6 25/33] s390: Introduce Start Arm Execution instruction
* [PATCH v6 26/33] KVM: s390: arm64: Introduce host definitions
* [PATCH v6 27/33] s390/hwcaps: Report SAE support as hwcap
* [PATCH v6 28/33] KVM: s390: Add basic arm64 kvm module
* [PATCH v6 29/33] KVM: s390: arm64: Implement required functions
* [PATCH v6 30/33] KVM: s390: arm64: Implement vm/vcpu create destroy.
* [PATCH v6 31/33] KVM: s390: arm64: Implement vCPU IOCTLs
* [PATCH v6 32/33] KVM: s390: arm64: Implement basic page fault handler
* [PATCH v6 33/33] KVM: s390: arm64: Enable KVM_ARM64 config and Kbuild

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/f8f86d18-d51e-46a4-9c78-a6c3b3725817

***

kernel build error

tree:      linux-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/next/li=
nux-next
base:      5e6de6a2b522f659defacb1551d0465ba6ce13cf
arch:      amd64
compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp=
1~20260613092250.77), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/2ede6171-aff4-442a-95cd-d85847a0fef=
1/config

drivers/vfio/vfio_main.c:1549:29: error: incompatible pointer types passing=
 'struct file *' to parameter of type 'struct kvm *' [-Wincompatible-pointe=
r-types]

***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

To test a fix for this bug, please reply with `#syz test`
(on a separate line) and attach the patch to the email.

Notes:
- The patch will be applied on top of the tested series (as an
  incremental fix).
- To test a new version of the whole series, please send it directly
  to syzbot@lists.linux.dev.
- Arguments like custom git repos and branches are not supported.

The email will later be sent to:
[agordeev@linux.ibm.com arnd@arndb.de borntraeger@linux.ibm.com brueckner@l=
inux.ibm.com catalin.marinas@arm.com david@kernel.org frankja@linux.ibm.com=
 fritz@linux.ibm.com ggala@linux.ibm.com gor@linux.ibm.com gra@linux.ibm.co=
m hari55@linux.ibm.com hca@linux.ibm.com iii@linux.ibm.com imbrenda@linux.i=
bm.com joey.gouly@arm.com kvm@vger.kernel.org kvmarm@lists.linux.dev linux-=
arm-kernel@lists.infradead.org linux-kernel@vger.kernel.org linux-s390@vger=
.kernel.org maz@kernel.org nrb@linux.ibm.com oss@nina.schoetterlglausch.eu =
oupton@kernel.org pbonzini@redhat.com seanjc@google.com seiden@linux.ibm.co=
m suzuki.poulose@arm.com svens@linux.ibm.com tabba@google.com ulrich.weigan=
d@de.ibm.com will@kernel.org yuzenghui@huawei.com]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

