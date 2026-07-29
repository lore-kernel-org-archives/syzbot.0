Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85E58483BD1
	for <syzbot@lists.linux.dev>; Wed, 29 Jul 2026 18:27:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785349658; cv=none; b=iEzzx4WAbsXPB959coQqab3dC0zRSl/wFEx1Eo9qI7tnC3hWpDVBoHGritTrWV34MIsiz+/uPeUJMTfOVf0dIuTadR5PtpndbIweNeQd4Psx8qYorFrHGmpWFSbvehbg5LzMs8lDGyWd5aAsGw5FBtm+o8YKxvPhGj7eSTmMftA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785349658; c=relaxed/simple;
	bh=v/YhUcBMZHX2GQU0m9OyMtPzO/kbHtbG4xFV1TXmKqQ=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=ctO+wNMvFCK9UQHN8I48OYwd5jkfhgUVwP25ETOzJJDAtM7QolCJKymYiTNZQaqFtE6xy0+aNhnagAu7fqByaMFKxWpjXv4M8M6+12OOzYbDpA1vsPCy2NkM9OKq4r6i0ODtaNHFHFEhLRBgMh33YNGKwAisayaUeLWvhE2O6SQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oAuvwwsV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oAuvwwsV"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 703F11F000E9;
	Wed, 29 Jul 2026 18:27:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785349647;
	bh=fhYO3+xSaUfqX06/IR46wuVobmb/K+B8p8D7d0UCgx0=;
	h=From:To:Cc:Subject:Date;
	b=oAuvwwsVtltVcLuUu8LN9F60ZqFNmIa5wEJU+xIemQN4OlaMclatRXvaEqzOlOglb
	 eA913jZgNA578TJRd2ojdVTzrLjuro97OwANQpHNDu1PqG83U4dIPBsnZdl77PmsGt
	 1ur3J2Ub9tKN1i7TmsdrOQMU/NMb8zUxKlN8aCp3vxfac9HnIBE6wLEzKzE8b2LukD
	 r9C+/4L1KS4M1xGwGbQvcxsefoxY5aqAx4WGg+3MPAOFsEyYmgpDxHhKM3A9ReDcSj
	 oUzw1XI6jIe9wzz4vz1oc0RyOd10oGkdMON5kA2uW0YmCWYSzd+OM2cflhpbvoBvpD
	 km66NHl2lwmUg==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] arm64: suspend: Fix context tracking during system suspend
Message-ID: <33408a6a-74eb-45e3-90c5-b39977e3f986@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Wed, 29 Jul 2026 18:27:27 +0000 (UTC)

Commit 19235e472798 ("cpuidle, arm64: Fix the ARM64 cpuidle logic") added
unconditional calls to ct_cpuidle_enter() and ct_cpuidle_exit() in
cpu_suspend() to keep RCU active longer before entering CPUIDLE. However,
cpu_suspend() is a dual-purpose function used both for CPUIDLE (called from
the idle task) and for system suspend (called synchronously by the task
initiating the suspend).

When cpu_suspend() is invoked during system suspend by a non-idle task,
ct_cpuidle_enter() triggers a warning in ct_kernel_exit() because it
expects to be called only from the idle task:

WARNING: kernel/context_tracking.c:120 at ct_kernel_exit+0x1b4/0x1f4
Call trace:
 ct_kernel_exit+0x1b4/0x1f4
 ct_idle_enter+0x24/0x38
 ct_cpuidle_enter include/linux/cpuidle.h:134 [inline]
 cpu_suspend+0x264/0x474
 psci_system_suspend_enter+0x4c/0x80
 suspend_enter kernel/power/suspend.c:468 [inline]
 suspend_devices_and_enter+0x88c/0xd0c

Furthermore, ct_cpuidle_enter() incorrectly tells lockdep that interrupts
are enabled, which is true for CPUIDLE but wrong for system suspend where
interrupts are strictly disabled.

Fix this by conditionally calling ct_cpuidle_enter() and ct_cpuidle_exit()
only if the current task is the idle task. This preserves the required RCU
context tracking behavior for CPUIDLE without violating context tracking
assumptions during system suspend.

Fixes: 19235e472798 ("cpuidle, arm64: Fix the ARM64 cpuidle logic")
Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+79883955da3a62652a80@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=79883955da3a62652a80
Link: https://syzkaller.appspot.com/ai_job?id=a12b1304-974c-4342-8eb2-8cae11276afb
To: "Catalin Marinas" <catalin.marinas@arm.com>
To: <linux-arm-kernel@lists.infradead.org>
To: "Will Deacon" <will@kernel.org>
To: "Peter Zijlstra" <peterz@infradead.org>
Cc: <linux-kernel@vger.kernel.org>

---
diff --git a/arch/arm64/kernel/suspend.c b/arch/arm64/kernel/suspend.c
index eaaff9432..c6b6b1cac 100644
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
 	struct arm_cpuidle_irq_context context;
 
 	/*
@@ -137,7 +139,8 @@ int cpu_suspend(unsigned long arg, int (*fn)(unsigned long))
 	 */
 	arm_cpuidle_save_irq_context(&context);
 
-	ct_cpuidle_enter();
+	if (idle)
+		ct_cpuidle_enter();
 
 	if (__cpu_suspend_enter(&state)) {
 		/* Call the suspend finisher */
@@ -153,9 +156,11 @@ int cpu_suspend(unsigned long arg, int (*fn)(unsigned long))
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
 


base-commit: f5098b6bae761e346ebcd9da7f95622c04733cff
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to Sign-off the patch as a human author
and send it to the upstream kernel mailing lists.
Reply with '#syz reject' to reject it ('#syz unreject' to undo).

See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
You can comment on the patch as usual, syzbot will try to address
the comments and send a new version of the patch if necessary.
syzbot engineers can be reached at syzkaller@googlegroups.com.
