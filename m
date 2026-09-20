Received: from mail-oo1-f72.google.com (mail-oo1-f72.google.com [209.85.161.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD2143E0C4C
	for <syzbot@lists.linux.dev>; Sun, 20 Sep 2026 19:58:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789934304; cv=none; b=sNjkZIjckUKvyM2LtlzBVUdNqPmu1VUkleKRcr5RXR4rEpNn5ZvO9uZ6HXfs4hU7fZALqNTUcjmJyy+j8vRBQL4WdqF4c0jzWF/RYmH5GPjTTXtElUv9hp0La03fX2+f24FK3EV9NeasJY80UKefgPAiDwOwOBDJLk5LyW8Sg4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789934304; c=relaxed/simple;
	bh=Sv8+sbUC528xO7AiVjn4BuCgRpAOung0g6cCYnYKCZg=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=RcvX1TrfUCZB1hLJLoNtLY25zNsl9QiMmKmMhDhtDNB0dc+CdFxJLopu1oSrrbbUqrUKOc+0aMxYGaynC6K7zybgb2yaGXFrfusZ3bOcmRuiAFxk8M61JBxIdeD4KR2AgcyW5azmIZmvGGdXmnVMp85RzACIuAyaaS6s4XNY9jg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f72.google.com with SMTP id 006d021491bc7-6b1ac969b92so2899420eaf.2
        for <syzbot@lists.linux.dev>; Sun, 20 Sep 2026 12:58:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789934302; x=1790539102;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:date:mime-version:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=mK/jCzZ+ZFqtgb3+RohshWKDaINhp0dzTmFfaLeUPGw=;
        b=P6kG1+bmy4m7BTbjH7f+KDwkOi4zditu5DWu0RkrTAlwN+jPx9hfDdxMDogymfP27N
         MsgpxaG+WFeE4PZEu42DaM+iWnNQELGRJ06AlkyCDNpJYSmbQqoYIdLk+zhFfleK6+X/
         7rlcdimE4GCDduTmf8qa7CFj3EHW0vzihsgml8/eecqO1Yd5tXuZzsVUv24O0PJtsdxf
         lMlDBZM5uq3VUS1GA8EFwJMY6BoX2zCuzqSXPADGCxO3aDHOPIRcL0K95bIHQhI8K1Ip
         oSex4huO9zv4wDtQipFXsnGcXudpJsGU73mfIOy2VZbnEr7pAKPjW7GEpLOzTY2gW+wO
         3tdg==
X-Gm-Message-State: AFuF++ltC5+4VUpdjkxV4sdTEGMd3hQY0e1KPQ1Tvx9A5crExIIdrlAM
	pGzm2KPBrOC4wbWmfxIWwdZsgW8cPRzDOPSO0KQvixYjNfD7Kc689zSWaw7KyHbBIQMa0eJdwap
	KYb4bUGtG/baqlh6I+8NtE3u+45VIlq9kuByOt2cycFB+SKn73ZL5wTKnvBo=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a4a:ee06:0:b0:6b1:3cb7:f535 with SMTP id
 006d021491bc7-6ca96ff9b8dmr8051396eaf.0.1789934301808; Sun, 20 Sep 2026
 12:58:21 -0700 (PDT)
Date: Sun, 20 Sep 2026 12:58:21 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6ab03add.71f81b7d.15fa6d.001b.GAE@google.com>
Subject: [moderation/CI] Re: KVM: s390: Introduce arm64 KVM
From: syzbot ci <syzbot+ci36706bdf7fde0017@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v8] KVM: s390: Introduce arm64 KVM
https://lore.kernel.org/all/20260918133107.1042730-1-seiden@linux.ibm.com
* [PATCH v8 01/29] KVM: Introduce file_to_kvm_<arch>() infrastructure
* [PATCH v8 02/29] KVM: Add file back-pointer to struct kvm
* [PATCH v8 03/29] KVM: x86: Use file_to_kvm_x86() in SEV
* [PATCH v8 04/29] KVM/vfio: Use file-based reference counting for KVM
* [PATCH v8 05/29] KVM: Restrict kvm_get_kvm/kvm_put_kvm export to internal=
 KVM modules
* [PATCH v8 06/29] KVM: Move export symbol check macros to Makefile.kvm
* [PATCH v8 07/29] KVM: Make device name configurable
* [PATCH v8 08/29] KVM: Move architecture capability Kconfigs to header def=
ines
* [PATCH v8 09/29] KVM: Replace CONFIG_KVM_MMIO with KVM_NO_MMIO
* [PATCH v8 10/29] arm64: Use proper include variant
* [PATCH v8 11/29] arm64: ptrace: Use constants for compat register numbers
* [PATCH v8 12/29] arm64: sysreg: Convert SPSR_ELx to automatic register ge=
neration
* [PATCH v8 13/29] KVM: arm64: Access elements of vcpu_gp_regs individually
* [PATCH v8 14/29] KVM: arm64: Use accessor functions for core regs
* [PATCH v8 15/29] arm64: Prepare sharing arm64 headers with s390
* [PATCH v8 16/29] arm64: Share arm64 headers with s390
* [PATCH v8 17/29] KVM: arm64: Share arm64 code with s390
* [PATCH v8 18/29] s390/tools: Use arm64 headers
* [PATCH v8 19/29] KVM: s390: Use arm64 code
* [PATCH v8 20/29] s390: Introduce Start Arm Execution instruction
* [PATCH v8 21/29] KVM: s390: arm64: Introduce host definitions
* [PATCH v8 22/29] s390/hwcaps: Report SAE support as hwcap
* [PATCH v8 23/29] KVM: s390: Add basic arm64 kvm module
* [PATCH v8 24/29] KVM: s390: arm64: Implement required functions
* [PATCH v8 25/29] KVM: s390: arm64: Implement vm/vcpu create destroy.
* [PATCH v8 26/29] KVM: s390: arm64: Implement vCPU IOCTLs
* [PATCH v8 27/29] KVM: s390: arm64: Implement basic page fault handler
* [PATCH v8 28/29] KVM: s390: arm64: Integrate arm on s390
* [PATCH v8 29/29] KVM: s390: Enforce no unexpected external symbol exports=
 in s390 KVM

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/1d6e6091-1961-4fd3-83a7-409ef413ac44

***

kernel build error

tree:      linux-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/next/li=
nux-next
base:      5dd1818b15d98d4a20806cd00b1b40320b06004f
arch:      amd64
compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp=
1~20260613092250.77)
config:    https://ci.syzbot.org/builds/b0f4baa3-3483-494b-ae1b-e8272338898=
b/config

virt/kvm/Kconfig:12: syntax error

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
oupton@kernel.org pbonzini@redhat.com seiden@linux.ibm.com suzuki.poulose@a=
rm.com svens@linux.ibm.com tabba@google.com ulrich.weigand@de.ibm.com will@=
kernel.org yuzenghui@huawei.com]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

