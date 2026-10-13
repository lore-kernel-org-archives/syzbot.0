Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7815F44F57D
	for <syzbot@lists.linux.dev>; Tue, 13 Oct 2026 02:09:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791857381; cv=none; b=iFaNDwLuFmdfSPWmtK5dBDIvkNsTY0AWWHjsr0J2dA/vuzSfhr/bc427fQB5ZvfHIJJrAkGcYF8wtDpCYVzF645dizhAvfWG1nDANrDkbl8gsKl2c+PX1s4q8G5/mNL7SEnZ7aJxNsB7T2NerGW6aSkur55wo0Q57WNqMrVmvPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791857381; c=relaxed/simple;
	bh=bRoclrSGDhrrEnQIVFW3HW2IfTXClXmYB1vDOU7VJcE=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=ALVbPH5o4D8kPfVtr4xk4r4cLUaAt1HW3t0A/52pau9JoX64I1kzsQ9IlXHTxGlNQ+LujYlZnlpSqkcVZeISTUJ8P/fY8APdVJXtOvkIiXJfH4aCA/0u0tsf4V9SbRFYrB4+KrLGlddaEtmeixQorvhy9jInuIW3ig2JDSBBEQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JrteFejx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JrteFejx"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 49B8F1F0089A;
	Tue, 13 Oct 2026 02:09:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791857380;
	bh=HSgMZzhq57yZ14YSovqDLWKyNv8dh029UsWmOOag5gI=;
	h=From:To:Cc:Subject:Date;
	b=JrteFejx09VRm+nh+j491GXSQ8rBXAhNzDD17bGMhdnIKMN1f6zJktCNVZI59ZKFH
	 Pl8NUke9UX+lIIOMkZpba4F6talfwebQlkhV332ynuA6CvCDXZMqRfploCrj6RDPuF
	 iTwJ+E46M4vMk9Lltyu8wqMLRo18nPv0WGINfsri6I2akr9vU3NSI0HxvdOu7kZIbD
	 v/c8z5bPRNj5XtSo6c2sTIMIjhVMttH8CLtntEbdeMt9F/hB0alw6zkRLf28AaNp8S
	 LR56rBnqUudcTEJny7oNtCWxLB6TY0lW5B6HGVTbWr0nQiWoiJOFBzhHdazbTGPUJQ
	 J7fMiFn+aPWfA==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] KVM: x86/xen: Skip fast path for Xen timer delivery on PREEMPT_RT
Message-ID: <ef965aec-2c08-41e1-9f81-59bfb3e2892a@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Tue, 13 Oct 2026 02:09:40 +0000 (UTC)

The Xen vCPU timer hrtimer (vcpu->arch.xen.timer) is initialized with
HRTIMER_MODE_ABS_HARD so that timer expiration occurs with high precision
in hard interrupt context. When the timer expires, xen_timer_callback()
runs in hardirq context and attempts to deliver the event directly via
kvm_xen_set_evtchn_fast().

However, kvm_xen_set_evtchn_fast() acquires &gpc->lock using
read_lock_irqsave(). On CONFIG_PREEMPT_RT kernels, rwlock_t is implemented
as rt_rw_lock, which is a sleeping lock based on rtmutexes. Attempting to
acquire a sleeping lock in hardirq context triggers a sleeping function
called from invalid context BUG:

BUG: sleeping function called from invalid context at
kernel/locking/spinlock_rt.c:248
in_atomic(): 1, irqs_disabled(): 1, non_block: 0, pid: 6214, name: rm
preempt_count: 1000000, expected: 0
RCU nest depth: 1, expected: 1
Call Trace:
 <IRQ>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 __might_resched+0x31b/0x470 kernel/sched/core.c:9264
 rt_read_lock+0xa9/0x4b0 kernel/locking/spinlock_rt.c:248
 kvm_xen_set_evtchn_fast+0x1f4/0x990 arch/x86/kvm/xen.c:1843
 xen_timer_callback+0x109/0x220 arch/x86/kvm/xen.c:139
 __run_hrtimer kernel/time/hrtimer.c:2074 [inline]
 __hrtimer_run_queues+0x3a0/0xaf0 kernel/time/hrtimer.c:2131
 hrtimer_interrupt+0x4c2/0xa80 kernel/time/hrtimer.c:2250
 ...
 </IRQ>

Using read_trylock() instead would still be unsafe on PREEMPT_RT, because a
successful read trylock followed by read_unlock() can wake up a blocked
writer, which takes the rtmutex wait lock and releases it with
raw_spin_unlock_irq(), unconditionally enabling interrupts from within the
hardirq handler. Furthermore, gpc->lock cannot be converted to raw_rwlock_t
because no raw reader-writer spinlock exists in Linux, and converting it to
a raw_spinlock_t would serialize all concurrent readers across Xen memory
cache lookups.

Fix this by bypassing the kvm_xen_set_evtchn_fast() fast path in
xen_timer_callback() on CONFIG_PREEMPT_RT kernels. When PREEMPT_RT is
enabled, xen_timer_callback() falls back to the slow path: incrementing
vcpu->arch.xen.timer_pending, setting KVM_REQ_UNBLOCK, and kicking the
vCPU. When the vCPU thread is subsequently scheduled, it delivers the timer
event in task context via kvm_xen_inject_timer_irqs(), where acquiring
&gpc->lock is safe.

Fixes: 77c9b9dea4fb ("KVM: x86/xen: Use fast path for Xen timer delivery")
Assisted-by: Gemini:gemini-3.8-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+e42793f1299e53beb2ee@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=e42793f1299e53beb2ee
Link: https://syzkaller.appspot.com/ai_job?id=f51d6e61-bc74-4ce3-8f36-54e585622882
To: "Sebastian Andrzej Siewior" <bigeasy@linutronix.de>
To: "Borislav Petkov" <bp@alien8.de>
To: "Clark Williams" <clrkwllms@kernel.org>
To: "Dave Hansen" <dave.hansen@linux.intel.com>
To: "David Woodhouse" <dwmw2@infradead.org>
To: <kvm@vger.kernel.org>
To: <linux-rt-devel@lists.linux.dev>
To: "Ingo Molnar" <mingo@redhat.com>
To: "Paul Durrant" <paul@xen.org>
To: "Paolo Bonzini" <pbonzini@redhat.com>
To: "Steven Rostedt" <rostedt@goodmis.org>
To: "Sean Christopherson" <seanjc@google.com>
To: "Thomas Gleixner" <tglx@kernel.org>
To: <x86@kernel.org>
To: "David Woodhouse" <dwmw@amazon.co.uk>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>

---
diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index d113bd0f1..7aa387d8d 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -125,21 +125,24 @@ static enum hrtimer_restart xen_timer_callback(struct hrtimer *timer)
 {
 	struct kvm_vcpu *vcpu = container_of(timer, struct kvm_vcpu,
 					     arch.xen.timer);
-	struct kvm_xen_evtchn e;
-	int rc;
 
 	if (atomic_read(&vcpu->arch.xen.timer_pending))
 		return HRTIMER_NORESTART;
 
-	e.vcpu_id = vcpu->vcpu_id;
-	e.vcpu_idx = vcpu->vcpu_idx;
-	e.port = vcpu->arch.xen.timer_virq;
-	e.priority = KVM_IRQ_ROUTING_XEN_EVTCHN_PRIO_2LEVEL;
+	if (!IS_ENABLED(CONFIG_PREEMPT_RT)) {
+		struct kvm_xen_evtchn e;
+		int rc;
 
-	rc = kvm_xen_set_evtchn_fast(&e, vcpu->kvm);
-	if (rc != -EWOULDBLOCK) {
-		vcpu->arch.xen.timer_expires = 0;
-		return HRTIMER_NORESTART;
+		e.vcpu_id = vcpu->vcpu_id;
+		e.vcpu_idx = vcpu->vcpu_idx;
+		e.port = vcpu->arch.xen.timer_virq;
+		e.priority = KVM_IRQ_ROUTING_XEN_EVTCHN_PRIO_2LEVEL;
+
+		rc = kvm_xen_set_evtchn_fast(&e, vcpu->kvm);
+		if (rc != -EWOULDBLOCK) {
+			vcpu->arch.xen.timer_expires = 0;
+			return HRTIMER_NORESTART;
+		}
 	}
 
 	atomic_inc(&vcpu->arch.xen.timer_pending);


base-commit: 24a19b953e2a3d0ea5a8c4951a0ab8f32720c907
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to Sign-off the patch as a human author
and send it to the upstream kernel mailing lists.
Reply with '#syz reject' to reject it ('#syz unreject' to undo).

See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
You can comment on the patch as usual, syzbot will try to address
the comments and send a new version of the patch if necessary.
syzbot engineers can be reached at syzkaller@googlegroups.com.
