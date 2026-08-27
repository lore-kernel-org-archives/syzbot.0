Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 750E93CDBAA
	for <syzbot@lists.linux.dev>; Thu, 27 Aug 2026 23:05:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787871912; cv=none; b=AMNqCMC+Y1UYRZUoOxMcX2lyZ2OJUpjvv0zxA+/Lm9mpRLPsEt/cVuIKaiECEl3cYG43xdim6QvqDScghk3r6uHb/74aFFF84EVdP/RQGahwm66OKfzDJmIk8BeaOb69Fek0gLItj8FY6GLQUeH0b+qqBTqu0dNV9jPZiSbVec0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787871912; c=relaxed/simple;
	bh=kO2hEpF7NmkdAJ6t1NAyfFXmc4FmuPc32vZLgqagBEA=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=sbauofT20VUrXAfMrmZwBuKD5mf8+a8i2RDJpG43nybYMQtTG8Oqn8aaUPCTU5tFwkRqVnDAr2JbV0SbFfQS1J5DXKU6BVgDgt8+3wPY7i6VHWRsKNbnxtoKgiikUGl5/kLDVMwouln8zaVTedWfYCHGgD2zTpTs2OwtwecKVaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WwFWsJqd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WwFWsJqd"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id E26691F000E9;
	Thu, 27 Aug 2026 23:05:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787871910;
	bh=AYbqENoy8qJAy10KUilaXnPPFe666SsYfG7b2ivCvOI=;
	h=From:To:Cc:Subject:Date;
	b=WwFWsJqd5qYZj0aTMD2GVxurx2Oe4dPSwY/5yy4YGM+0qrfvOSxIAdsLILtSXGF/V
	 OGqSOkMtye+avXRH8dtG0rqTY11lu7BrAd6zo3wCpSsPME8RbJ9JcifLJAfY4gC6m2
	 ZWd88QnKb8Q0Ok1bL/B2e7bVUkNq0kry+PNj3SUM9Tm19LwBMI30fHFoAtjKlepcVN
	 3pC8iFPRs9ZeZDrAIjzg/AdPLIvMOmhloWxgUdsPcPmvaw0XrVXrLwXOwb6PTu+WzG
	 efaVqlRVrIDe1/FbfgcBFhe80NGss/Md4xBWwEmLtzoY9wJIAyZ71uI4GXZg1fG4Sh
	 t0ISG+LWJn5HQ==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] arm64: mm: Attempt exception fixup in do_sea()
Message-ID: <5a2b9a05-0dbb-4e9d-be3f-a6fa2981a6dc@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Thu, 27 Aug 2026 23:05:09 +0000 (UTC)

When a user-space process maps Device or Non-cacheable memory (such as a
PCI BAR) into its address space and passes that address to a system call
performing atomic user access (such as futex with FUTEX_WAKE_OP), the
kernel executes an exclusive load instruction (ldxr) at EL1. Under the ARM
architecture, exclusive accesses to Device memory are unsupported and can
trigger a Synchronous External Abort (SEA) instead of an Alignment Fault,
routing the exception to do_sea().

Unlike other fault handlers, do_sea() did not check the kernel exception
tables for aborts occurring in kernel mode (!user_mode(regs)). Instead, it
unconditionally treated all kernel-mode SEAs as fatal hardware errors,
marked the kernel tainted with TAINT_MACHINE_CHECK, and called
arm64_notify_die() which panicked the system. As a result, accessing mapped
device memory via such syscalls causes a kernel panic and a local denial of
service.

Fix this by calling fixup_exception() for kernel-mode aborts in do_sea().
If an exception table entry exists for the faulting instruction (such as
uaccess or futex routines), the fault is fixed up and do_sea() returns
gracefully so that the calling system call returns -EFAULT to user space.
If no fixup entry exists, execution continues down the fatal panic path.

Fixes: 32015c235603 ("arm64: exception: handle Synchronous External Abort")
Assisted-by: Gemini:gemini-3.7-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+417a6b7c02d5d03f9aa6@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=417a6b7c02d5d03f9aa6
Link: https://syzkaller.appspot.com/ai_job?id=e80ac460-6a7b-4d71-8092-1edf4242c342
To: "Catalin Marinas" <catalin.marinas@arm.com>
To: <linux-arm-kernel@lists.infradead.org>
To: "Will Deacon" <will@kernel.org>
To: "Tyler Baicar" <tbaicar@codeaurora.org>
Cc: "Andrew Morton" <akpm@linux-foundation.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: <linux-kernel@vger.kernel.org>
Cc: "Quentin Perret" <qperret@google.com>
Cc: "Ryan Roberts" <ryan.roberts@arm.com>

---
diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
index 0b5255765..ca396b4bd 100644
--- a/arch/arm64/mm/fault.c
+++ b/arch/arm64/mm/fault.c
@@ -878,6 +878,9 @@ static int do_sea(unsigned long far, unsigned long esr, struct pt_regs *regs)
 		return 0;
 	}
 
+	if (!user_mode(regs) && fixup_exception(regs, esr))
+		return 0;
+
 	if (esr & ESR_ELx_FnV) {
 		siaddr = 0;
 	} else {


base-commit: 8d3ae59288f1e7d58d76558a6ee96d533bc5019f
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to Sign-off the patch as a human author
and send it to the upstream kernel mailing lists.
Reply with '#syz reject' to reject it ('#syz unreject' to undo).

See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
You can comment on the patch as usual, syzbot will try to address
the comments and send a new version of the patch if necessary.
syzbot engineers can be reached at syzkaller@googlegroups.com.
