Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E78D370AE7;
	Thu, 25 Jun 2026 21:10:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782421817; cv=none; b=KyN/eYLe/5wzsm/NNQUQ3wtpOc1cFnz/e+yeqYSayTN158M4CtT7rtPc4frBtbITXqSSt7v6CUSPzhgXBDr2BycriqjNLSHNzkdhLzqdO52EUgAQYl7Z6ZGLSHosp3OTfjRV9oHf9jBsfxK8tNK1BvrBsUCloNujfxKVrkrWqf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782421817; c=relaxed/simple;
	bh=jV6MNmDjeYwGG6sXcsQC0kQQQt83PN/vfs1KOMAnOaM=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=gVhGvFEJVvnHHmpr1NYZOeExPQatWvYSD4i14aTFg3ipQkOK/fMm0J/IxCbxW/MjjyBPDr1CU+zSXd+4IvcMW6/5xhHfUjPQ+fN7l/opi/aL9ohyp7hrs0mStKXUR2HM/Pb6xlYeaxS58kcZDLpW4dFnk3mTUJtlX5vBgZI5SXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CTIq6Lry; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CTIq6Lry"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id E40AE1F000E9;
	Thu, 25 Jun 2026 21:10:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782421815;
	bh=o6u4jedd8oLlKEgxBVtodzmxOIvcpzFDk07OlJZnm8w=;
	h=From:To:Cc:Subject:Date;
	b=CTIq6Lryvhx0WXV9ivgiHXhCN/4coEOmo9oq8ythNWk2VclaDQyj+OkMlenOwVLCM
	 ud76Q2An1JyOJWIJFnsh8kKs7Pmux4Esc+xGS8/u5doZyrmWJE3mNLuczPpUDX3/bL
	 9FPNbnkmZROeoaLuoNlQtc0MbFmqbStLcVrEU7NSU5afu50WIcut+U7vgKatTPP/a2
	 BVAqwp2X7amLf2PsDIi0X4kVyXBWox/0uysCKWXej0G3JFqhiPhWIAEGVlcnFbZZAK
	 y4lafqDa6SPv07+QXB5a6OAOIE3KRzkiQFvR7HX/q3oSZwnchEQVoUYaVCr48ZXs5j
	 TaT/kUyAglhUg==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-bugs@googlegroups.com, "Borislav Petkov" <bp@alien8.de>, "Dave Hansen" <dave.hansen@linux.intel.com>, <kvm@vger.kernel.org>, "Ingo Molnar" <mingo@redhat.com>, "Paolo Bonzini" <pbonzini@redhat.com>, "Sean Christopherson" <seanjc@google.com>, "Thomas Gleixner" <tglx@kernel.org>, <x86@kernel.org>
Cc: hpa@zytor.com, linux-kernel@vger.kernel.org, syzbot@lists.linux.dev
Subject: [PATCH v2] KVM: x86: Exempt in-kernel PIC from "disappearing" interrupt warning
Message-ID: <86078441-92eb-4461-b823-7d3539ac5859@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Thu, 25 Jun 2026 21:10:14 +0000 (UTC)

From: Alexander Potapenko <glider@google.com>

A warning can be triggered in kvm_check_and_inject_events() when an
interrupt disappears between the time it is checked via
kvm_cpu_has_injectable_intr() and the time it is fetched via
kvm_cpu_get_interrupt(). This occurs because the warning incorrectly
assumes that if an interrupt is injectable, fetching it must always return
a valid interrupt vector (i.e., not -1).

However, this assumption is broken by level-triggered interrupts in the
in-kernel PIC that are deasserted concurrently by another thread. For
example, if a misconfigured PIT or a PCI device asserts and then
immediately deasserts a level-triggered interrupt, the vCPU thread might
see the pending interrupt during the check but find it gone during the
fetch, resulting in kvm_cpu_get_interrupt() returning -1.

The warning manifests as follows:

------------[ cut here ]------------
irq == -1
WARNING: arch/x86/kvm/x86.c:10860 at kvm_check_and_inject_events
arch/x86/kvm/x86.c:10860 [inline]
WARNING: arch/x86/kvm/x86.c:10860 at vcpu_enter_guest
arch/x86/kvm/x86.c:11356 [inline]
WARNING: arch/x86/kvm/x86.c:10860 at vcpu_run+0x57ec/0x7950
arch/x86/kvm/x86.c:11770
RIP: 0010:kvm_check_and_inject_events arch/x86/kvm/x86.c:10860 [inline]
RIP: 0010:vcpu_enter_guest arch/x86/kvm/x86.c:11356 [inline]
RIP: 0010:vcpu_run+0x57ec/0x7950 arch/x86/kvm/x86.c:11770
Call Trace:
 <TASK>
 kvm_arch_vcpu_ioctl_run+0x1193/0x2070 arch/x86/kvm/x86.c:12125
 kvm_vcpu_ioctl+0xa61/0xfd0 virt/kvm/kvm_main.c:4470
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:597 [inline]
 __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
 </TASK>

Since this is a legitimate Time-Of-Check to Time-Of-Use (TOCTOU) race
condition for the in-kernel PIC, WARN_ON_ONCE() must not be used for this
case. Update the warning to exempt the in-kernel PIC, while preserving it
for other interrupt sources (e.g. APIC) as they are not expected to exhibit
this behavior.

Fixes: bf672720e83c ("KVM: x86: check the kvm_cpu_get_interrupt result before using it")
Assisted-by: Gemini:gemini-3.1-pro-preview Gemini:gemini-3-flash-preview syzbot
Reported-by: syzbot+dd769db18693736eee89@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=dd769db18693736eee89
Link: https://syzkaller.appspot.com/ai_job?id=0b59ccd5-8820-460d-84d3-94df6307bd6a
Signed-off-by: Alexander Potapenko <glider@google.com>

---
v2:
- Restrict the warning exemption to the in-kernel PIC case.
- Remove the pr_err_ratelimited() logging.
- Preserve the WARN_ON_ONCE() for non-PIC interrupt sources.

v1:
https://lore.kernel.org/all/345e9d6c-d7d9-4bab-adb3-d6a7bd27599f@mail.kernel.org/T/
---
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 0550359ed..f1681aa9f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10857,7 +10857,9 @@ static int kvm_check_and_inject_events(struct kvm_vcpu *vcpu,
 		if (r) {
 			int irq = kvm_cpu_get_interrupt(vcpu);
 
-			if (!WARN_ON_ONCE(irq == -1)) {
+			WARN_ON_ONCE(irq == -1 && !pic_in_kernel(vcpu->kvm));
+
+			if (irq != -1) {
 				kvm_queue_interrupt(vcpu, irq, false);
 				kvm_x86_call(inject_irq)(vcpu, false);
 				WARN_ON(kvm_x86_call(interrupt_allowed)(vcpu, true) < 0);


base-commit: 8cd9520d35a6c38db6567e97dd93b1f11f185dc6
-- 
See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
You can comment on the patch as usual, syzbot will try to address
the comments and send a new version of the patch if necessary.
syzbot engineers can be reached at syzkaller@googlegroups.com.
