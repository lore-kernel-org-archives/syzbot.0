Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1A473F7A8C
	for <syzbot@lists.linux.dev>; Tue, 19 May 2026 09:31:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779183098; cv=none; b=amlk6mxZmT9wS20aXuqA2QurW5+TDWbwyFlq2RbpK3y9E8fgFJcpwrIGhhdNoIwaUUlPniTOtRDw+2RbSzqk2xbEwSieTK+bNthfBXuPWIi8rIBBfCXllA7veKTpeVeFS4XSXYqgGfc2o9RvFuWik6yd8nYVTGX3NyAjcXUaWKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779183098; c=relaxed/simple;
	bh=ogpJqiibNOmBx6XMLmHSNB1Wkr1CZEgtbfRuDbJziiw=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=V6dMTDaAoBGFcQ4oRTaDyTddTgBItRrfo0Y6Q7nyoal88ShXhDrbsov7CE/dz/2+eIJktaZQHgxzgfEzYIBkFIG6YbSwoGtdZdS4Vo5yDvS+pPJdH4pS7zzvT6iE8MUwNvHr79Gxl5MdMCrjKho3UUeCtNL3GMXj4dJW6nt1qyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bKzlGTgx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bKzlGTgx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E850C2BCB3;
	Tue, 19 May 2026 09:31:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779183098;
	bh=ogpJqiibNOmBx6XMLmHSNB1Wkr1CZEgtbfRuDbJziiw=;
	h=From:To:Cc:Subject:Date:From;
	b=bKzlGTgxWZ2MGWQzxMXvpDlkRDedMsB2u8kBmIyS9ANRJnrJsX5spSGAo6F76dLXI
	 NxUZh3WLCiw8XeZ1IYUqR9X3Xqd0uDskbkTcY1fGYD7SyZhJqtK4zZn8Eedsb9mtex
	 eUJA/OXG//piuD9zfNuNwu5IzlQlPAT1J3ZY2bpfspCrxUHHkHuR1b07gea15oGSg3
	 mBrhw3E0LMPV19dcCNgp4stzXEQJeYtGQvwkWPmNz57UZ7+KrPCD5h6xz4jmbh2D9E
	 k4trGhb6K+t9m1Ev9FPQvGaamxXXU8Vqq/HoWwmxsZ7mvn5MbK/VjQsooc47UWHE1/
	 W6rkKFLX8kWvA==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] signal: clear JOBCTL_PENDING_MASK for caller in zap_other_threads()
Message-ID: <b3adb77f-185b-434f-a19d-0a29728733ba@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Tue, 19 May 2026 09:31:38 +0000 (UTC)

When a multi-threaded process receives a stop signal (e.g., SIGSTOP),
do_signal_stop() sets JOBCTL_STOP_PENDING and JOBCTL_STOP_CONSUME on all
threads and sets signal->group_stop_count to the number of threads. If
one of the threads concurrently calls execve(), de_thread() invokes
zap_other_threads() to kill all other threads. zap_other_threads()
aborts the pending group stop by resetting signal->group_stop_count to 0
and clears the JOBCTL_PENDING_MASK for all other threads. However, it
fails to clear the job control flags for the calling thread.

When execve() completes, the calling thread returns to user mode and
checks for pending signals. Seeing the stale JOBCTL_STOP_PENDING flag,
it calls do_signal_stop(), which invokes task_participate_group_stop().
Since JOBCTL_STOP_CONSUME is still set, it attempts to decrement the
already-zero signal->group_stop_count, triggering a
WARN_ON_ONCE(sig->group_stop_count == 0) in
task_participate_group_stop().

Fix this race condition by clearing the JOBCTL_PENDING_MASK for the
calling thread in zap_other_threads(), ensuring it does not retain any
stale job control state after the thread group is destroyed. This aligns
with other functions that tear down a thread group and abort group
stops, such as zap_process() and complete_signal(), which correctly
clear these flags for all threads including the current one.

Fixes: 39efa3ef3a376a4e53de2f82fc91182459d34200 ("signal: Use GROUP_STOP_PENDING to stop once for a single group stop")
Assisted-by: Gemini:gemini-3.1-pro-preview Gemini:gemini-3-flash-preview
Reported-by: syzbot+b109633ea805cac54a61@syzkaller.appspotmail.com
Link: https://syzkaller.appspot.com/bug?extid=b109633ea805cac54a61
Link: https://syzkaller.appspot.com/ai_job?id=5e1c6b88-c61a-462e-baa0-d014c2b72c8d
To: <linux-kernel@vger.kernel.org>

---
diff --git a/kernel/signal.c b/kernel/signal.c
index 2d102e025..9c2b32c4d 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -1338,6 +1338,7 @@ int zap_other_threads(struct task_struct *p)
 	int count = 0;
 
 	p->signal->group_stop_count = 0;
+	task_clear_jobctl_pending(p, JOBCTL_PENDING_MASK);
 
 	for_other_threads(p, t) {
 		task_clear_jobctl_pending(t, JOBCTL_PENDING_MASK);


base-commit: 5200f5f493f79f14bbdc349e402a40dfb32f23c8
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to send it to the mailing list.
Reply with '#syz reject' to reject it.

See  for more information.
