Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D662D363C45;
	Wed, 24 Jun 2026 13:15:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782306946; cv=none; b=q1lu0uK1GFdMom84Xsv4nacdeXHnIdvb0PRLMYugf+2Uq3gpJlFyP9Iv8VSdjnhIkIoEpieTx525PdhOQB58pWV/EF5xHYeJmOrG7qVC4//6LJxdLVOkCkBojqwSoSlZ6jhru8L+YrtiNMLYunaLXNOXddJKhrKDmZZ7GdMHgFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782306946; c=relaxed/simple;
	bh=IDqPT/UxUH9FGfEYniuNUef+hEDrgFrZ3WBKNrRfzdY=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=Ok1rw47tx7bjqxCgGrej0huqU4iPEpR/hSHT0Fa7CDCGCscSU4snMzJeDvAK59YJszxAY6J7B0CJ+DvHV2b/ORfSeCWF3ptk7fAiNaSeo7NKQGg9Qn1To+Xg7l41wqxgVHv7uNrVcqD44UiKghoNElXm317VZgx4oPOkt1gA4sc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SpuZfIb/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SpuZfIb/"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 1376C1F000E9;
	Wed, 24 Jun 2026 13:15:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782306945;
	bh=FWobWMYxr9HtRCbm8Iueb4NAtV81V2tsUehSZZ4zNQM=;
	h=From:To:Cc:Subject:Date;
	b=SpuZfIb/jFYtb09PbjDmmIXdUu/A150vs+gM9+NPeVMjrAEys6wjOlD5nz8K+GYGu
	 cV7Tvd58uZWZsJXCy69cntQIbArSfmT8nsz4It/RbLyONBEtcm76AkpSEonpFvWnhF
	 urSfGnKiQzba4znB3jpXAmzMenfjHyYXss5JBcyUdeDJ5HXLSQhQdQAbKCK9zGyv2W
	 vEjazIEDyJCqAc/VjC6XuAGZJpFhmhcPO2ahzR4jE1+fBIXSRjoBhwP5i67h45ePfL
	 w90K4F0sIFw9ZRwdsR1voOSDiOgGLa1IYTs6zKU3FkY8zKVENqL8/6JvvD9brnpq++
	 +aN87mr7XNrBA==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-bugs@googlegroups.com, "Borislav Petkov" <bp@alien8.de>, "Dave Hansen" <dave.hansen@linux.intel.com>, <kvm@vger.kernel.org>, "Ingo Molnar" <mingo@redhat.com>, "Paolo Bonzini" <pbonzini@redhat.com>, "Sean Christopherson" <seanjc@google.com>, "Thomas Gleixner" <tglx@kernel.org>, <x86@kernel.org>
Cc: hpa@zytor.com, linux-kernel@vger.kernel.org, syzbot@lists.linux.dev
Subject: [PATCH] KVM: x86: Drop WARN_ON_ONCE() for concurrently disappearing interrupts
Message-ID: <345e9d6c-d7d9-4bab-adb3-d6a7bd27599f@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Wed, 24 Jun 2026 13:15:45 +0000 (UTC)

From: Alexander Potapenko <glider@google.com>

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
Signed-off-by: Alexander Potapenko <glider@google.com>

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
See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
You can comment on the patch as usual, syzbot will try to address
the comments and send a new version of the patch if necessary.
syzbot engineers can be reached at syzkaller@googlegroups.com.
