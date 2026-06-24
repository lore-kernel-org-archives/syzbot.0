Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6050C2D6E5A
	for <syzbot@lists.linux.dev>; Wed, 24 Jun 2026 13:02:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782306166; cv=none; b=qnBMoXpzKrphQyZrVIKkAe0MDwBBlPNPnEtMhaMV+UzCIDQbvBPR/M3i/DtnQNP343Til3j6n/fiPJlMYrpIofAiU2cEtUAGz8O0XJ761aDuBZ2xbU96EwvppsRyB/4rF3vnQjmFu6lTTQzIfJQoqU9/IYfZSvbmYhxFsM7c6Oo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782306166; c=relaxed/simple;
	bh=Mylw0cl8fcrYN3VpuLrZEtgjtHNLJLM/r0y8ExaM2zc=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=Ek9yiMpec4p4hA8ssN1jStziaTAvVPOm3crM+sbS9I/bnhN0YEojBgE1ps2mFRUJZSchxsuZdu4l6m5E9LCmNnFDEJPdK6y7QPjF7CvACUeQPPkvhs/6Bg+hGHZ+IMqhAIAa6b7Ah5O/VfB0744wzCFriauu36UdPt6+b/ph2aw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CH5I2yRQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CH5I2yRQ"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id E16391F000E9;
	Wed, 24 Jun 2026 13:02:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782306165;
	bh=jF9crg51FbbLxQY2JlCUF8r60XXbeaO+22jyrWQO+vA=;
	h=From:To:Cc:Subject:Date;
	b=CH5I2yRQh7z6IjBoa7wrejYIbNNL1O81zmn004OyPuPtFxBQ9u6KrgEsvv5AlrTa8
	 ehQWIr+01MaOU6NPioTiZRAy8JbaBCrQsD8i6Pr5YUiiiL8tssEzsXOAR3BVoJfE0B
	 N67Ci+CkkdFKHICx/rMtiU5IpWRBE4XcidrP5T+MhfLNN+hqIpSF4SFnLRhuPC6JDo
	 T9+epAC8hT/Oh7MoPbOLC9giqKJYbEJZtkqZ+kWIjnHJ6keFPnz/wq+QT7sWEw4bj+
	 VTCX1lLxAhMiIxtBjIo1WSXtleuGwVIYmvKAtgHX1l94qKRqPWBES/yAkp7BwMTNiq
	 HkSAs3RH80c+A==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC v2] KVM: x86: Drop WARN_ON_ONCE() for concurrently disappearing interrupts
Message-ID: <28ac723d-47df-426b-939e-752b6df7f1a8@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Wed, 24 Jun 2026 13:02:44 +0000 (UTC)

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
pr_err_ratelimited() to log the event instead.

Fixes: bf672720e83c ("KVM: x86: check the kvm_cpu_get_interrupt result before using it")
Assisted-by: Gemini:gemini-3.1-pro-preview Gemini:gemini-3-flash-preview syzbot
Reported-by: syzbot+dd769db18693736eee89@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=dd769db18693736eee89
Link: https://syzkaller.appspot.com/ai_job?id=35cad3cd-95fd-4c0d-8ca8-812f58d56e59
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
v2:
- Removed changes to arch/x86/kvm/vmx/nested.c.

v1:
https://lore.kernel.org/all/e61a6de2-8e9d-4768-b555-27f8954e48ec@mail.kernel.org/T/
---
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
