Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E17D23D7E3
	for <syzbot@lists.linux.dev>; Thu, 21 May 2026 01:22:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779326535; cv=none; b=UbP2wkFRGbulbkZHjRv/BYuaYP5nRWNEl9F2NtUiXORZqR9xHlVgoWF7csJfqsMOvd8dYO9DkH1iGzwNrOMhSVGeIpystFpMLCT6/DLYdqU5dVPnkd82ArEZwVySZ5IbgthA0ijh9WVlwqm3YQOSBHIDW1TDNMvoQpU8eiN6vDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779326535; c=relaxed/simple;
	bh=QtGVJLShr7TDeCTNkLlBvYGk6FacmymZPyLoo/M/pGo=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=FGG5lUKHTfy4skbsFXQeKHCkgU7K2HQ35HfD0MCxmaty6MxBw1czEj5PEXkc4CGgUJEDNRJ8aJjdJuSnKxEnORL392808QkMnHNbyirLTxuUljNibFbdvQT4Am3D/Ylyk0lWm5HdgirEQRFN8QOLmCSmjRrN1C+gktQggbz495s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VQ67L9vI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VQ67L9vI"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 0ACFF1F00A3B;
	Thu, 21 May 2026 01:22:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779326534;
	bh=V6fjwF+seaqOTIUSkqqBLT5O09L8cQVIvPsn7runaMc=;
	h=From:To:Cc:Subject:Date;
	b=VQ67L9vIYsDBYo8hbUlbzDOQ9BX6EVg1Cc7aLl5jiE91weo2DxV2yuFF4u+INTSZl
	 79QdUo5QaF9qGNaQBrArhhIjlSlRCXO9QFApOlOSUaCf/+UHpoELnVo3+fNkhFWTrV
	 QYBbhZhggbnQGXRGyTNoXAXixV44ODW3ubS/vi6AHGSXi+dJV+qcGFretwCBdGafcv
	 GV9FPWIawOn1Zm/aCGjDHvZ3pgbtDaTpuuRwWXMZcWginO/fT2q9I18IMCUDulu2bb
	 EmfCcgwonQqnhHH7FBevWHiVR18gwx7FaOgLJTzMCW74ry80/0cD7Ls6AZbgTX8TCi
	 s2Yj7Gtht5JeA==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] signal: explicitly unpoison sigqueue in sigqueue_alloc()
Message-ID: <b552544a-89cd-407a-845c-fbd83d6ba021@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Thu, 21 May 2026 01:22:14 +0000 (UTC)

A false positive KMSAN kernel-infoleak-after-free report can occur when
a BPF program executes while KMSAN is in its internal runtime state
(kmsan_in_runtime() == true).

When bpf_send_signal() is called from a BPF program, it allocates a new
sigqueue via sigqueue_alloc(). If this happens while KMSAN is in its
runtime state (for example, when a BPF program is attached to a
tracepoint triggered during KMSAN's internal operations), KMSAN ignores
all instrumentation to prevent deadlocks and infinite recursion. As a
result, the newly allocated sigqueue is not unpoisoned by
kmem_cache_alloc(), nor is it unpoisoned by subsequent initialization
like clear_siginfo().

Later, when the signal is dequeued, the siginfo is copied to the local
stack, propagating the stale poison. This eventually leads to a false
positive kernel-infoleak-after-free report when the siginfo is copied to
user space.

Fix this by explicitly unpoisoning the allocated sigqueue in
sigqueue_alloc() using kmsan_unpoison_memory(). Unlike standard KMSAN
instrumentation, kmsan_unpoison_memory() bypasses the kmsan_in_runtime()
check and safely unpoisons the memory. This is safe because q->info is
always fully initialized immediately after sigqueue_alloc() in
__send_signal_locked(). If copy_siginfo() is used and kmsan_in_runtime()
is false, memcpy() will still copy any uninitialized bytes from the
source info to q->info, ensuring that real bugs and infoleaks are still
caught.

Fixes: f80be4571b19 ("kmsan: add KMSAN runtime core")
Assisted-by: Gemini:gemini-3.1-pro-preview
Reported-by: syzbot+cfc08744435c4cf94a40@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=cfc08744435c4cf94a40
Link: https://syzkaller.appspot.com/ai_job?id=2e44af35-fdc2-4fc3-90b2-1d6176362a03
To: <linux-kernel@vger.kernel.org>
Cc: "Adrian Huang (Lenovo)" <adrianhuang0701@gmail.com>
Cc: "Andrew Morton" <akpm@linux-foundation.org>
Cc: "Christian Brauner" <brauner@kernel.org>
Cc: "Kexin Sun" <kexinsun@smail.nju.edu.cn>
Cc: "Oleg Nesterov" <oleg@redhat.com>
Cc: "Peter Zijlstra (Intel)" <peterz@infradead.org>
Cc: "Thomas Gleixner" <tglx@kernel.org>

---
diff --git a/kernel/signal.c b/kernel/signal.c
index 2d102e025..0ead5d607 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -48,6 +48,7 @@
 #include <linux/audit.h>
 #include <linux/sysctl.h>
 #include <uapi/linux/pidfd.h>
+#include <linux/kmsan-checks.h>
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/signal.h>
@@ -459,6 +460,7 @@ static struct sigqueue *sigqueue_alloc(int sig, struct task_struct *t, gfp_t gfp
 	}
 
 	__sigqueue_init(q, ucounts, 0);
+	kmsan_unpoison_memory(q, sizeof(*q));
 	return q;
 }
 


base-commit: 5200f5f493f79f14bbdc349e402a40dfb32f23c8
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to send it to the mailing list.
Reply with '#syz reject' to reject it.

See https://github.com/google/syzkaller/blob/master/docs/syzbot_ai_patches.md for more information.
