Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793909987;
	b=1PJeuOkVSIPEmzKnnLh39Cu+4GUL5Ky0yIHTaN4U1blnRi43pgvfoQ/aBXGjuqCpFyeT
	 Oscm787s9eyBkk1H0feGw6zb80a24qo+LF2jcS8zY8rZqrr6/k7d0JAUzP0B5K0IfMpmD
	 Ln4JUl4xVCokUGwDcUDKFGsCssQJZ7p30/GLa74JC2fHIijdi5YDE2/nK/0auDaxnRfVo
	 26RIzhZUK9g1D3N1rQL3f7Hj1fUF5kzhIFA8IduzOFHSvwehM6++SA2E5uQnyK5ruQmBo
	 c+s1i2K3Y76dx1cgAui4BaGhN/36S6yQu0jLq8yxdMoTtQeTxuPVZ4pZM7tjaEMd85A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793909987;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Message-ID:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Date;
	bh=ijWY+Z2NJRFFaxPZ787h43DbKEzbnR08iWE8GXg21g8=;
	b=4iaqVO2ji4VZIasPIsXb/7/zwT/ZySHlcTALj8dWu8vDFHFFapAHkdzSL8CsSLE3NUN3
	 N3MGpEp5SfZVG7PzgJhNYuOTEOcyDTifVplvcp9PeKqOyi89s5c3EqWLdYEis+6ljvJ4e
	 T/M7Gsb3E+s1alICC997ko1bzQJIuam8Z1M6yA175FQOAg7wKtLD6c4i7pkY8n9XeFWrq
	 8gZ64MHZfFvPEHG+nbk22EZs41lOEfUOW/gVhrAPWhlzxpNK/LmFjVBVK//9OJgHSqWme
	 fzYPl9rYhgkH+epC7hn7fSvB/gwCPkiq/R7eDu4P0Q18lExTGG1zV4LOB8h+S5fyvOA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OHx6Tdho;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id AAD6B606A31B;
	Thu,  5 Nov 2026 20:19:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OHx6Tdho
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 08E651F0089F;
	Thu,  5 Nov 2026 20:19:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793909986;
	bh=ijWY+Z2NJRFFaxPZ787h43DbKEzbnR08iWE8GXg21g8=;
	h=From:To:Cc:Subject:Date;
	b=OHx6TdhotcaC6TMSXEfvA2ru0DsBB+t/DOejKXSp2mkAmUYBKLHRVWJCtBlfEbmMs
	 UO5WgoIsMcp1pw/OP7RjzZEoPBLC4xPS2DHY+Y9KYDiMHPValbhEoSOFxDyz030Kuz
	 a2dsVVjIV5/FHVGQGAfCu/ePxoUtz1OOGXx7oHb0egzINwi7wLQMM9tt4Oi4q7HQVi
	 1IlPKM0PXkbVcHeEiudoYKUlfgJylyMqyrkrIO7Ao28UWsq53/WeN/OhE8Iwv4zyrO
	 OhqMbP0NmhRVSiT2klGIBeJxM0SxiejpXbjmdiCOBndevLwvib6FjySd0xvs+SSI3u
	 j0Mn74sQCjKHA==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-bugs@googlegroups.com, Uladzislau Zhauniarovich <uladzislau.zhauniarovich@gmail.com>, "Catalin Marinas" <catalin.marinas@arm.com>, <linux-arm-kernel@lists.infradead.org>, "Will Deacon" <will@kernel.org>, "Peter Zijlstra" <peterz@infradead.org>
Cc: ada.coupriediaz@arm.com, linux-kernel@vger.kernel.org, mark.rutland@arm.com, ruanjinjie@huawei.com, syzbot@lists.linux.dev, vladimir.murzin@arm.com
Subject: [PATCH] arm64: suspend: Only track cpuidle context for idle tasks
Message-ID: <c49d0138-9e6d-40d4-b46c-518240685bf1@mail.kernel.org>
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Post: <mailto:syzbot@lists.linux.dev>
List-Help: <mailto:syzbot+help@lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
List-Owner: <mailto:syzbot+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Thu,  5 Nov 2026 20:19:45 +0000 (UTC)

From: Uladzislau Zhauniarovich <uladzislau.zhauniarovich@gmail.com>

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
Signed-off-by: Uladzislau Zhauniarovich <uladzislau.zhauniarovich@gmail.com>

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
See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
The person who has signed off on the patch is responsible for
addressing comments.
syzbot engineers can be reached at syzkaller@googlegroups.com.
