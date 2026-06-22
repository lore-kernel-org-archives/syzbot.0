Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE88329D27D
	for <syzbot@lists.linux.dev>; Mon, 22 Jun 2026 16:19:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782145181; cv=none; b=P+EE0g57sW7u93Usbp59cuwRnzGxe+9MRlv0sGhP1cLxcSYB2KS6W/33NtYdRgI73R4MBKwAHXRkl3UfoMUyMiKING4MPEysN5Me5oKklT6j61mLQCPrFWwmNDQjGYTtZ6jn6ZNjPuQLcVO3ko57O+eXKfmJe8Q8AhDXST0O/y8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782145181; c=relaxed/simple;
	bh=WuhDFOOWoFsRgpGvGBbWLZ96O1h/SockY8K0R4HMyXg=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=jafrgKYzUSfxG2YJM58uV0SkUq5/t+V0qJWGbrLHTewHhnjLGXcuuBmrrMzVceqMTG7WKqibQw/S24l3XW/qd3dJBX+nTZVWRDqoRht7yuulXU/YcWh2RjRoAN43mAGHvBRE7aW/drCc5FWCzitNIlCNVf118NLb3groUQFAhb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bHhAJ8D7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bHhAJ8D7"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 5214E1F000E9;
	Mon, 22 Jun 2026 16:19:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782145179;
	bh=uhWLU57Q4FGZsIh/NhUBiMQ6lTdqdgK9Zr4ymKYqXT8=;
	h=From:To:Cc:Subject:Date;
	b=bHhAJ8D7Me71Uv82Rn5wMsCLzhHFBnxl/Vnjz8bPnNQS2MMYmdeahfXWvGXByyBYQ
	 4jgyiGvLdh5vE3oLI1Np0ASsqV2ZT82XtH8wMVRXEjCrXlqGkkN1ddpkdyG13jyHq2
	 JWMtfkFZysPaRvkwMWR2+gpwoRNDFh5NLugs6a97aRE0l5jVNNaCCAfrozMlSM4h0U
	 o1mDDt8Jyihf5I31T4pCVXXSYZam0rAuApgMO3TKYhK96H9eu7igGmK/fTzr3Dn7D2
	 GIPjN7A4fnaTx3WOwfVmC/W+zYoWX6FIoDnij0FQP1MGCwU6zD5UPVcWdykNQXzbaf
	 9vRqWUOgdfJVA==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] KVM: x86: Drop WARN_ON_ONCE() for concurrent PIC interrupt deassertion
Message-ID: <077c14b4-6f79-45a9-9b11-bd625c8ecff3@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Mon, 22 Jun 2026 16:19:39 +0000 (UTC)

A false positive warning can be triggered in kvm_check_and_inject_events()
and vmx_check_nested_events() due to a natural race condition when a
level-triggered PIC interrupt is deasserted concurrently with vCPU entry.

The WARN_ON_ONCE(irq == -1) in kvm_check_and_inject_events() was added to
catch cases where kvm_cpu_has_injectable_intr() returns true, but
kvm_cpu_get_interrupt() returns -1 (meaning no interrupt is pending). The
assumption was that this could only happen due to a KVM bug. However, for
level-triggered PIC interrupts, a concurrent deassertion by the device
makes this a perfectly valid and expected scenario.

For example, if a device asserts a level-triggered interrupt, the IRR bit
is set and kvm_cpu_has_injectable_intr() returns true. If the device then
deasserts the interrupt before kvm_cpu_get_interrupt() is called, the IRR
bit is cleared, and kvm_cpu_get_interrupt() correctly returns -1.

A similar issue exists in vmx_check_nested_events(), where
kvm_cpu_has_interrupt() is checked first. If it returns true because a PIC
interrupt is pending, but the interrupt is concurrently deasserted, both
kvm_cpu_get_extint() and kvm_apic_has_interrupt() will return -1,
triggering a WARN_ON_ONCE(irq < 0).

Remove the WARN_ON_ONCE() macros in both functions, as WARN_ON must not be
used for conditions that can legitimately happen, and pr_err() should be
used instead if necessary. In this case, no error logging is needed because
the code already handles irq == -1 gracefully by skipping the injection,
which is the correct behavior when a level-triggered interrupt is
deasserted before it can be injected.

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

Fixes: bf672720e83c ("KVM: x86: check the kvm_cpu_get_interrupt result before using it")
Assisted-by: Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+dd769db18693736eee89@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=dd769db18693736eee89
Link: https://syzkaller.appspot.com/ai_job?id=8568ceee-8527-4f42-b840-1fd49498df2e
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
index 3fe88f29b..72d434f3f 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -4446,7 +4446,12 @@ static int vmx_check_nested_events(struct kvm_vcpu *vcpu)
 		}
 
 		irq = kvm_apic_has_interrupt(vcpu);
-		if (WARN_ON_ONCE(irq < 0))
+		/*
+		 * A level-triggered PIC interrupt can be deasserted concurrently,
+		 * making it possible for irq to be -1 even if kvm_cpu_has_interrupt()
+		 * returned true.
+		 */
+		if (irq < 0)
 			goto no_vmexit;
 
 		/*
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 0550359ed..af36643b9 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10857,7 +10857,13 @@ static int kvm_check_and_inject_events(struct kvm_vcpu *vcpu,
 		if (r) {
 			int irq = kvm_cpu_get_interrupt(vcpu);
 
-			if (!WARN_ON_ONCE(irq == -1)) {
+			/*
+			 * A level-triggered PIC interrupt can be deasserted
+			 * concurrently with vCPU entry, making it possible
+			 * for irq to be -1 even if kvm_cpu_has_injectable_intr()
+			 * returned true.
+			 */
+			if (irq != -1) {
 				kvm_queue_interrupt(vcpu, irq, false);
 				kvm_x86_call(inject_irq)(vcpu, false);
 				WARN_ON(kvm_x86_call(interrupt_allowed)(vcpu, true) < 0);


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
