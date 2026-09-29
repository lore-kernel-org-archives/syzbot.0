Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B4AD38F934
	for <syzbot@lists.linux.dev>; Tue, 29 Sep 2026 21:44:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790718300; cv=none; b=sXzlZykwycKus8u+3Nsa8lEKGJzu1IgTLiDqnS4OE9dqGE9ci/S/sjZ4h85s38FnLh6lvNRZ65g3DtvTAQ2WJ0RSZRbmXclse17KJmunqgB6YIoZFxoXEp8LQ/Juwop1kr0P7kb8KAf+Od+c5aSxO0Q1x8rcUf5vmZI5NOcUYL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790718300; c=relaxed/simple;
	bh=1ukkmxDbo7jPfvWbC7jdeAy0+Yc20xD8Jlv417HhmrQ=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=HgViF5O3F9YfPZmX9XEJPxedY2AY4nVRwmrX7ris4wmbyxMPyb3h+6lHwcE8avIwBKFp8qeynyDkvpjoatjRDZYIZgkcbCOUP9NoGqTAGmodWJeSzeTrWm4b7u6ueQtAAOlfZQp0kd2ngZd+SYaeGJIX17j0X4nswqUPS+5lShk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kaJXQVVL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kaJXQVVL"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 275AF1F000FF;
	Tue, 29 Sep 2026 21:44:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790718289;
	bh=ORRlSNLHn1/xR4WZ+e4Nzz2xaUYazku3rgMrl2hQSgA=;
	h=From:To:Cc:Subject:Date;
	b=kaJXQVVL8g2oSF1Kc0Ig1y9tmcuP5AC8W3Ms5+mhl5nqu7EFEyIDCy3E4eiizEoxz
	 2RpH0soBj/hUtclmhTNoNo8Tg7nEVt18sjZIWlzm/12Jf0ottJIxPUT6Fd4o8gdklM
	 lqhTfFji2G8LUYcV136eUBZ+FNmRN1Hxbim/pA8UdEc5I9IfykM9t6CctLigO2pQDZ
	 hByU403GhmvtRPEiYQJku47MxG/NqBm5MqLOhKcP61WnBpma7mVSeaEyyELXlyUFOW
	 kdfdTqK0V16mb0LNnYZU6MUmhuJSFzH+/xfi4iudUMt6U63w1Aw1pcCCk1ZkivjgXE
	 x3w2dU1JC+syw==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] arm64: suspend: Only track cpuidle context for idle tasks
Message-ID: <c2fd8aff-c1ea-4bfc-a24d-79a58f58b6aa@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Tue, 29 Sep 2026 21:44:49 +0000 (UTC)

Commit 19235e472798 ("cpuidle, arm64: Fix the ARM64 cpuidle logic") moved
the calls to ct_cpuidle_enter() and ct_cpuidle_exit() into cpu_suspend() so
that arm64 cpuidle could keep RCU watching longer and manage context
tracking internally. However, cpu_suspend() is called not only by cpuidle
via psci_cpu_suspend_enter() (which runs in the context of the idle task),
but also during system suspend via psci_system_suspend_enter() (which runs
in the context of the task initiating suspend, such as a process writing to
/sys/power/state).

When entering system suspend, current is a non-idle task. Calling
ct_cpuidle_enter() invokes ct_kernel_exit() from kernel space (!user) on a
non-idle task. With CONFIG_RCU_EQS_DEBUG enabled, this violates context
tracking invariants and triggers a warning:

WARNING: kernel/context_tracking.c:120 at ct_kernel_exit+0x1b4/0x1f4
kernel/context_tracking.c:118
Call trace:
 ct_kernel_exit+0x1b4/0x1f4 kernel/context_tracking.c:118
 ct_idle_enter+0x20/0x34 kernel/context_tracking.c:299
 ct_cpuidle_enter include/linux/cpuidle.h:134 [inline]
 cpu_suspend+0x264/0x474 arch/arm64/kernel/suspend.c:136
 psci_system_suspend_enter+0x4c/0x80 drivers/firmware/psci/psci.c:544
 suspend_enter kernel/power/suspend.c:468 [inline]
 suspend_devices_and_enter+0x88c/0xd0c kernel/power/suspend.c:533
 enter_state kernel/power/suspend.c:618 [inline]
 pm_suspend+0x498/0x698 kernel/power/suspend.c:644
 state_store+0x14c/0x1fc kernel/power/main.c:819
 kobj_attr_store+0x6c/0x90 lib/kobject.c:842
 sysfs_kf_write+0xe0/0x108 fs/sysfs/file.c:145
 kernfs_fop_write_iter+0x260/0x3b8 fs/kernfs/file.c:345
 vfs_write+0x51c/0xa0c fs/read_write.c:687
 ksys_write+0x12c/0x228 fs/read_write.c:739

A corresponding warning is subsequently triggered in ct_kernel_enter() via
ct_cpuidle_exit() upon resume.

Fix this by checking is_idle_task(current) in cpu_suspend() and only
invoking ct_cpuidle_enter() and ct_cpuidle_exit() when executing in the
context of an idle task.

Fixes: 19235e472798 ("cpuidle, arm64: Fix the ARM64 cpuidle logic")
Assisted-by: Gemini:gemini-3.8-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+79883955da3a62652a80@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=79883955da3a62652a80
Link: https://syzkaller.appspot.com/ai_job?id=5359e16f-013b-4850-9cbc-ddfb3bac95e5
To: "Catalin Marinas" <catalin.marinas@arm.com>
To: <linux-arm-kernel@lists.infradead.org>
To: "Will Deacon" <will@kernel.org>
To: "Peter Zijlstra" <peterz@infradead.org>
Cc: "Ada Couprie Diaz" <ada.coupriediaz@arm.com>
Cc: <linux-kernel@vger.kernel.org>
Cc: "Mark Rutland" <mark.rutland@arm.com>
Cc: "Jinjie Ruan" <ruanjinjie@huawei.com>
Cc: "Vladimir Murzin" <vladimir.murzin@arm.com>

---
diff --git a/arch/arm64/kernel/suspend.c b/arch/arm64/kernel/suspend.c
index c41724a40..cde0b8c19 100644
--- a/arch/arm64/kernel/suspend.c
+++ b/arch/arm64/kernel/suspend.c
@@ -5,6 +5,7 @@
 #include <linux/uaccess.h>
 #include <linux/pgtable.h>
 #include <linux/cpuidle.h>
+#include <linux/sched.h>
 #include <asm/alternative.h>
 #include <asm/cacheflush.h>
 #include <asm/cpufeature.h>
@@ -99,6 +100,7 @@ int cpu_suspend(unsigned long arg, int (*fn)(unsigned long))
 	int ret = 0;
 	unsigned long flags;
 	struct sleep_stack_data state;
+	bool idle = is_idle_task(current);
 
 	/*
 	 * Some portions of CPU state (e.g. PSTATE.{PAN,DIT}) are initialized
@@ -133,7 +135,8 @@ int cpu_suspend(unsigned long arg, int (*fn)(unsigned long))
 	 */
 	pause_graph_tracing();
 
-	ct_cpuidle_enter();
+	if (idle)
+		ct_cpuidle_enter();
 
 	if (__cpu_suspend_enter(&state)) {
 		/* Call the suspend finisher */
@@ -149,9 +152,11 @@ int cpu_suspend(unsigned long arg, int (*fn)(unsigned long))
 		if (!ret)
 			ret = -EOPNOTSUPP;
 
-		ct_cpuidle_exit();
+		if (idle)
+			ct_cpuidle_exit();
 	} else {
-		ct_cpuidle_exit();
+		if (idle)
+			ct_cpuidle_exit();
 		__cpu_suspend_exit();
 	}
 


base-commit: 72d3fcf802c45d00b300f25b848a93c3a2bd7c7e
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to Sign-off the patch as a human author
and send it to the upstream kernel mailing lists.
Reply with '#syz reject' to reject it ('#syz unreject' to undo).

See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
You can comment on the patch as usual, syzbot will try to address
the comments and send a new version of the patch if necessary.
syzbot engineers can be reached at syzkaller@googlegroups.com.
