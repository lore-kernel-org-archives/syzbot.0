Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E497733B6D6
	for <syzbot@lists.linux.dev>; Wed, 12 Aug 2026 12:53:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786539201; cv=none; b=pXpIdi4jq529Gqh7UfTVUAgPzg7ye1ZKl/Ybx8PxMdRXDcbMIcYCuzHkoaJOnH95ExBawjiO6UzbqyQ+vFCEr8+SkVqSldaw/VjMvObWapkzblgFZY0nuKQw4VooLn9iupuK9Q5A4i/DtzUmcABuN6lr6y2Vo5jKDv9SJRTpkEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786539201; c=relaxed/simple;
	bh=MYSMZ4Gjp6X1ZmWb5GNWw0tUp/Ouemnc28egVwZEwZ0=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=EwCNjMCIhycGv3RZd4uDVG3E7TCymOfCkLBpKu0B42xSiteaTu2PP6cJtoiBV3lMRBwFzQOjTGJkFbJk1MWgUN+/tYS9Ho7c0uvkTUW7mcYZDIiTJ0UWGvgvQzvYhELqtX8sdZqvqZnZ5Xsn9KVOAFXKVfv/0dC3uhxSYiOwE6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cXW5TTyF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cXW5TTyF"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 843B01F000E9;
	Wed, 12 Aug 2026 12:53:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786539199;
	bh=ZZh00hv512JcVQv9wrauG5ylPAK6oP7gorvEXaK8kl8=;
	h=From:To:Cc:Subject:Date;
	b=cXW5TTyFJzWnoWGetJ/1phjda2Ddvc50KAh1Vvfb7NB41cN63SQXGzBr/ISEndME+
	 I1fS7bWX0qkz2f6Zm+1Dh6twXgobX+Q7gYvlox3ZwTEI0XiRqOpswNNkpULdKCsgAY
	 dg2AKSa93YR9dfVd3b0HA6Avu6VOthkyJODbfTUY3PDAl8xpSxEQ1ZcKOCmt4v6V2J
	 957wR2iXyxb81ZqHDtgHsAiyNP4hYOtjvqOQep6ZFBmOxFTOWHq5QLzVUqr+3jrjL0
	 +g+S7JbXmNMwAV7nkrA3jY3YOmbJUeVHu2y45JFuh//fAwBIT1XEbG0Zl6H51auUc8
	 KkCGA0ZqZkCtQ==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] KVM: x86/xen: Avoid sleeping lock in kvm_xen_set_evtchn_fast()
Message-ID: <b87de19e-47b9-4266-8165-12a73f85031f@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Wed, 12 Aug 2026 12:53:19 +0000 (UTC)

When running a PREEMPT_RT kernel, an attempt to acquire `gpc->lock` via
`read_lock_irqsave()` in `kvm_xen_set_evtchn_fast()` can lead to a
"sleeping function called from invalid context" BUG.

This happens because `gpc->lock` is an `rwlock_t`, which is mapped to a
sleeping lock (`rt_rw_lock`) on PREEMPT_RT. However,
`kvm_xen_set_evtchn_fast()` can be called from hardirq or atomic contexts,
such as `xen_timer_callback()` (an hrtimer callback) or
`kvm_arch_set_irq_inatomic()` (during irqfd waitqueue wakeups).

BUG: sleeping function called from invalid context at
kernel/locking/spinlock_rt.c:248
in_atomic(): 1, irqs_disabled(): 1, non_block: 0, pid: 5685, name:
kworker/0:5
...
Call Trace:
 <IRQ>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 __might_resched+0x329/0x480 kernel/sched/core.c:9197
 rt_read_lock+0xa9/0x4b0 kernel/locking/spinlock_rt.c:248
 kvm_xen_set_evtchn_fast+0x1f4/0x990 arch/x86/kvm/xen.c:1822
 xen_timer_callback+0x109/0x220 arch/x86/kvm/xen.c:140
 __run_hrtimer kernel/time/hrtimer.c:2032 [inline]
 __hrtimer_run_queues+0x3a0/0xaf0 kernel/time/hrtimer.c:2096
 hrtimer_interrupt+0x44a/0x900 kernel/time/hrtimer.c:2215
 local_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1051 [inline]
 __sysvec_apic_timer_interrupt+0x102/0x430 arch/x86/kernel/apic/apic.c:1068
 sysvec_apic_timer_interrupt+0xa1/0xc0 arch/x86/kernel/apic/apic.c:1062
 </IRQ>

To fix this, modify `kvm_xen_set_evtchn_fast()` to accept a `bool
in_atomic` parameter. When called from an atomic context, use
`read_trylock()` instead of `read_lock_irqsave()`. If the trylock fails,
safely fall back to the slow path (returning `-EWOULDBLOCK` or kicking the
vCPU), which the callers already expect and handle. Update all callers to
pass the appropriate context flag.

Fixes: 14243b387137 ("KVM: x86/xen: Add KVM_IRQ_ROUTING_XEN_EVTCHN and event channel delivery")
Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+e42793f1299e53beb2ee@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=e42793f1299e53beb2ee
Link: https://syzkaller.appspot.com/ai_job?id=f4bc5243-4ceb-4399-a79c-4c7ff19fbe0f
To: "Borislav Petkov" <bp@alien8.de>
To: "Dave Hansen" <dave.hansen@linux.intel.com>
To: "David Woodhouse" <dwmw2@infradead.org>
To: <kvm@vger.kernel.org>
To: "Ingo Molnar" <mingo@redhat.com>
To: "Paul Durrant" <paul@xen.org>
To: "Paolo Bonzini" <pbonzini@redhat.com>
To: "Sean Christopherson" <seanjc@google.com>
To: "Thomas Gleixner" <tglx@kernel.org>
To: <x86@kernel.org>
To: "David Woodhouse" <dwmw@amazon.co.uk>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>

---
diff --git a/arch/x86/kvm/irq.c b/arch/x86/kvm/irq.c
index cb8ac4b9b..9aef11529 100644
--- a/arch/x86/kvm/irq.c
+++ b/arch/x86/kvm/irq.c
@@ -267,7 +267,7 @@ int kvm_arch_set_irq_inatomic(struct kvm_kernel_irq_routing_entry *e,
 		if (!level)
 			return -1;
 
-		return kvm_xen_set_evtchn_fast(&e->xen_evtchn, kvm);
+		return kvm_xen_set_evtchn_fast(&e->xen_evtchn, kvm, true);
 #endif
 	default:
 		break;
diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index 694b31c1f..14988ae71 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -137,7 +137,7 @@ static enum hrtimer_restart xen_timer_callback(struct hrtimer *timer)
 	e.port = vcpu->arch.xen.timer_virq;
 	e.priority = KVM_IRQ_ROUTING_XEN_EVTCHN_PRIO_2LEVEL;
 
-	rc = kvm_xen_set_evtchn_fast(&e, vcpu->kvm);
+	rc = kvm_xen_set_evtchn_fast(&e, vcpu->kvm, true);
 	if (rc != -EWOULDBLOCK) {
 		vcpu->arch.xen.timer_expires = 0;
 		return HRTIMER_NORESTART;
@@ -1792,7 +1792,7 @@ static void kvm_xen_check_poller(struct kvm_vcpu *vcpu, int port)
  * It is also called directly from kvm_arch_set_irq_inatomic(), where the
  * only check on its return value is a comparison with -EWOULDBLOCK'.
  */
-int kvm_xen_set_evtchn_fast(struct kvm_xen_evtchn *xe, struct kvm *kvm)
+int kvm_xen_set_evtchn_fast(struct kvm_xen_evtchn *xe, struct kvm *kvm, bool in_atomic)
 {
 	struct gfn_to_pfn_cache *gpc = &kvm->arch.xen.shinfo_cache;
 	struct kvm_vcpu *vcpu;
@@ -1819,7 +1819,15 @@ int kvm_xen_set_evtchn_fast(struct kvm_xen_evtchn *xe, struct kvm *kvm)
 
 	idx = srcu_read_lock(&kvm->srcu);
 
-	read_lock_irqsave(&gpc->lock, flags);
+	if (in_atomic) {
+		local_irq_save(flags);
+		if (!read_trylock(&gpc->lock)) {
+			local_irq_restore(flags);
+			goto out_rcu_no_lock;
+		}
+	} else {
+		read_lock_irqsave(&gpc->lock, flags);
+	}
 	if (!kvm_gpc_check(gpc, PAGE_SIZE))
 		goto out_rcu;
 
@@ -1853,7 +1861,18 @@ int kvm_xen_set_evtchn_fast(struct kvm_xen_evtchn *xe, struct kvm *kvm)
 		read_unlock_irqrestore(&gpc->lock, flags);
 		gpc = &vcpu->arch.xen.vcpu_info_cache;
 
-		read_lock_irqsave(&gpc->lock, flags);
+		if (in_atomic) {
+			local_irq_save(flags);
+			if (!read_trylock(&gpc->lock)) {
+				local_irq_restore(flags);
+				if (!test_and_set_bit(port_word_bit,
+						      &vcpu->arch.xen.evtchn_pending_sel))
+					kick_vcpu = true;
+				goto out_rcu_no_lock;
+			}
+		} else {
+			read_lock_irqsave(&gpc->lock, flags);
+		}
 		if (!kvm_gpc_check(gpc, sizeof(struct vcpu_info))) {
 			/*
 			 * Could not access the vcpu_info. Set the bit in-kernel
@@ -1888,6 +1907,7 @@ int kvm_xen_set_evtchn_fast(struct kvm_xen_evtchn *xe, struct kvm *kvm)
 
  out_rcu:
 	read_unlock_irqrestore(&gpc->lock, flags);
+ out_rcu_no_lock:
 	srcu_read_unlock(&kvm->srcu, idx);
 
 	if (kick_vcpu) {
@@ -1903,7 +1923,7 @@ static int kvm_xen_set_evtchn(struct kvm_xen_evtchn *xe, struct kvm *kvm)
 	bool mm_borrowed = false;
 	int rc;
 
-	rc = kvm_xen_set_evtchn_fast(xe, kvm);
+	rc = kvm_xen_set_evtchn_fast(xe, kvm, false);
 	if (rc != -EWOULDBLOCK)
 		return rc;
 
@@ -1937,7 +1957,7 @@ static int kvm_xen_set_evtchn(struct kvm_xen_evtchn *xe, struct kvm *kvm)
 		struct gfn_to_pfn_cache *gpc = &kvm->arch.xen.shinfo_cache;
 		int idx;
 
-		rc = kvm_xen_set_evtchn_fast(xe, kvm);
+		rc = kvm_xen_set_evtchn_fast(xe, kvm, false);
 		if (rc != -EWOULDBLOCK)
 			break;
 
diff --git a/arch/x86/kvm/xen.h b/arch/x86/kvm/xen.h
index 59e6128a7..13d34a06f 100644
--- a/arch/x86/kvm/xen.h
+++ b/arch/x86/kvm/xen.h
@@ -32,7 +32,7 @@ void kvm_xen_destroy_vm(struct kvm *kvm);
 void kvm_xen_init_vcpu(struct kvm_vcpu *vcpu);
 void kvm_xen_destroy_vcpu(struct kvm_vcpu *vcpu);
 int kvm_xen_set_evtchn_fast(struct kvm_xen_evtchn *xe,
-			    struct kvm *kvm);
+			    struct kvm *kvm, bool in_atomic);
 int kvm_xen_setup_evtchn(struct kvm *kvm,
 			 struct kvm_kernel_irq_routing_entry *e,
 			 const struct kvm_irq_routing_entry *ue);


base-commit: db2ddb87143519e20a95aa36c60b36107b736a58
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to Sign-off the patch as a human author
and send it to the upstream kernel mailing lists.
Reply with '#syz reject' to reject it ('#syz unreject' to undo).

See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
You can comment on the patch as usual, syzbot will try to address
the comments and send a new version of the patch if necessary.
syzbot engineers can be reached at syzkaller@googlegroups.com.
