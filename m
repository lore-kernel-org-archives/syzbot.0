Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD0D62D63E5
	for <syzbot@lists.linux.dev>; Tue, 23 Jun 2026 11:47:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782215244; cv=none; b=tdKnwBSEW+TVw4e4DhOpvVDW4705YeS/9LK8HnndcHZP82e+y9uBkSAF3Hhpm4j8xI8stGaT13gt7MkbRDq0e2ZpON21r2z4sW16ecySDqatnQZ7ooq/aNAod3SRs1x8IPoSaok2vJRL5+UxjLd2pJqV+VhlE64w2tU9mmN4o44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782215244; c=relaxed/simple;
	bh=WeQpS+38UXromDaU8daPf5h8TxlVJUxuVbhTg/kx5iA=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=I5DQWDvrXmj/sLezTKP10mOtIuHS1eULDo7GRjd/s78MaGKoCYxnLNuSO4pf+3skaJH/ETpHu1p8GoFoWYH5M7T18P9lR/+w6azP+AA6fZ8jiphuBji3yfbkMOCS/VWKjku4o0Qspb4qTRTQGnWAdV69lbZAU/waziPif1K31a4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mDXqNGMY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mDXqNGMY"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 73C501F000E9;
	Tue, 23 Jun 2026 11:47:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782215242;
	bh=htnZSTiO0rOWl4XF9UYoq7hB4pU50xOBiohkWfgtEow=;
	h=From:To:Cc:Subject:Date;
	b=mDXqNGMYvFIS0YPi207E529ktkwbKmj+y89B3FBTnme+SLxrcTehj1+GSnNqoWjIz
	 BKoHau3cy+np3ZcY+wK3Am1yqWGcB+kCZE9efPx2ihFvWgQnooCDq6Jfv7RsWL0O+B
	 05+lssnaTJQA2EZGrkU/wMgtH9BVW9161VsDRtF2jfjN0jvWy+Nrj6Lx/26+BwfiYL
	 2RcFLKQS8ZcXctWuz3nnSTeAf1BGk2l2kskcmKdh/rh+/1yWfyej/2nwNpzhN4+t0f
	 8d2CBPwEriS+55awJDjajDb1ucf5xFHcY5l3+31oTqwadBd3TSIrBKMr155cEEAr7v
	 Rb/EBAyBmPeUw==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] KVM: x86: Drop WARN_ON_ONCE() for concurrently disappearing interrupts
Message-ID: <e61a6de2-8e9d-4768-b555-27f8954e48ec@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Tue, 23 Jun 2026 11:47:22 +0000 (UTC)

A warning can be triggered in kvm_check_and_inject_events() when an
interrupt disappears between the time it is checked via
kvm_cpu_has_injectable_intr() and the time it is fetched via
kvm_cpu_get_interrupt(). This occurs because the warning incorrectly
assumes that if an interrupt is injectable, fetching it must always return
a valid interrupt vector (i.e., not -1).

However, this assumption is broken by level-triggered interrupts that are
deasserted concurrently by another thread. For example, if a misconfigured
PIT or a PCI device asserts and then immediately deasserts a
level-triggered interrupt, the VCPU thread might see the pending interrupt
during the check but find it gone during the fetch, resulting in
kvm_cpu_get_interrupt() returning -1.

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
condition that can occur during normal operation, WARN_ON_ONCE() must not
be used for conditions that can legitimately happen. The patch removes the
WARN_ON_ONCE() in kvm_check_and_inject_events() and replaces it with a
pr_err_ratelimited() to log the event instead. The same flawed assumption
exists in vmx_check_nested_events(), where kvm_apic_has_interrupt() can
return -1 after kvm_cpu_has_interrupt() returns true. The patch applies the
same fix there by removing the WARN_ON_ONCE() and gracefully handling the
missing interrupt with a rate-limited error message.

Fixes: bf672720e83c ("KVM: x86: check the kvm_cpu_get_interrupt result before using it")
Assisted-by: Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+dd769db18693736eee89@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=dd769db18693736eee89
Link: https://syzkaller.appspot.com/ai_job?id=b37654f7-62ad-4e4a-a244-0949c0ca4246
To: "Borislav Petkov" <bp@alien8.de>
To: "Dave Hansen" <dave.hansen@linux.intel.com>
To: <kvm@vger.kernel.org>
To: "Ingo Molnar" <mingo@redhat.com>
To: "Paolo Bonzini" <pbonzini@redhat.com>
To: "Sean Christopherson" <seanjc@google.com>
To: "Thomas Gleixner" <tglx@kernel.org>
To: <x86@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>

---
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 3fe88f29b..c3e9c9d9b 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -4446,8 +4446,11 @@ static int vmx_check_nested_events(struct kvm_vcpu *vcpu)
 		}
 
 		irq = kvm_apic_has_interrupt(vcpu);
-		if (WARN_ON_ONCE(irq < 0))
+		if (irq < 0) {
+			pr_err_ratelimited(
+				"KVM: APIC interrupt disappeared between checking and fetching\n");
 			goto no_vmexit;
+		}
 
 		/*
 		 * If the IRQ is L2's PI notification vector, process posted
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 0550359ed..c5b4cddd9 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10857,10 +10857,13 @@ static int kvm_check_and_inject_events(struct kvm_vcpu *vcpu,
 		if (r) {
 			int irq = kvm_cpu_get_interrupt(vcpu);
 
-			if (!WARN_ON_ONCE(irq == -1)) {
+			if (irq != -1) {
 				kvm_queue_interrupt(vcpu, irq, false);
 				kvm_x86_call(inject_irq)(vcpu, false);
 				WARN_ON(kvm_x86_call(interrupt_allowed)(vcpu, true) < 0);
+			} else {
+				pr_err_ratelimited(
+					"KVM: interrupt disappeared between checking and fetching\n");
 			}
 		}
 		if (kvm_cpu_has_injectable_intr(vcpu))


base-commit: 8cd9520d35a6c38db6567e97dd93b1f11f185dc6
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to Sign-off the patch as a human author
and send it to the upstream kernel mailing lists.
Reply with '#syz reject' to reject it ('#syz unreject' to undo).

See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
You can comment on the patch as usual, syzbot will try to address
the comments and send a new version of the patch if necessary.
syzbot engineers can be reached at syzkaller@googlegroups.com.
