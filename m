Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D8883D7A05
	for <syzbot@lists.linux.dev>; Thu, 21 May 2026 14:23:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779373395; cv=none; b=SrQSKlMVEL8w/S5glVEI5y9UmM7iOV8U3gP12Zm/5nsQaKMBWiOYXYSwNfe/ns1JpanE+QNksN1/pnden43vRvYiqsNnFS6va1eyt6sTq/ASRRfkfPe/7MobSRuBmRW9Ce0OZ1r5XbM/8Tl013Nv+5QXZBlD2Mu0O50EQCNG8oc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779373395; c=relaxed/simple;
	bh=vkvxE28P0zrag41KylC50dr5R96zFtOXC1ohN2g7whA=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=QLPCXQ5pR0WUNfAa3AWhitE3uPyRgX2fj0TmW6nHyDzSQTd++Ftt3nD/1ZU0HzgWpZgNTTHW/6Tlrm0KPbdnFN/47cmmM6YGAkPDzlHMUzng40bA7qRSWlCdkhchJD7KP/MEVJ4xwb+XXFd1rBSGa36Xq2WwLggumZGya7HaAxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--nogikh.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=OjCyiYiD; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--nogikh.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OjCyiYiD"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-48fe44ce385so49783665e9.0
        for <syzbot@lists.linux.dev>; Thu, 21 May 2026 07:23:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779373393; x=1779978193; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Lr8BKpOLWQtrvU98WKSsigNpDA+PKrjW2zdUyhAFbTw=;
        b=OjCyiYiDyuC6+4tsCGLCMss9QSVb0+chJb1eO6sjnFcwRU/IQZb0AhOmn4reSksczb
         hddpYnxAcL1sAKMCbYkvoxLty5jcIWCcjvzWNeWtGF4DohVNWfmlJ9Ul9vhRBTMh4Hxl
         jvqSz0Ae+y2nGEKIfFAHwj79aHGdaALU6eiskETPeGT0DCuyobTj9tlPN1zfouuXTi1W
         cW1myF1Pb0hFR11OpaTCfoaKXl8t5U9JU13iS2vTzunnoJC5u+5BTIhRpAJMM3Vc4A5X
         PDDC1BnJiCEyCj2cqBeCJlHCoNvSod14RmylpQ3+De0wgt1M4Y6n+33M6BryYyE6rlj4
         6G5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779373393; x=1779978193;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Lr8BKpOLWQtrvU98WKSsigNpDA+PKrjW2zdUyhAFbTw=;
        b=SlJpXRDMOehaYWMxy3X+yw2MUohgFCdUjvZJCzAojjwnM4ALC2XpAe5TxMWZ/3Ix1u
         Mb9UtTOR+E43YD/b/VN/fH93n3MrNkVLhGN+q5FZVbeZvKUvKr2PREoXuopbD/P/xEBP
         QdaqK9YnsEaDuT0qnJEHEfSLvLBM0RzQSGSkmNqUwz2Wh7XlZabWgnRVqp0+SNirz7LE
         G9+nYIgYc8lE1K/QB1itRb079RTZdAmtuD93XCd477aSq6WLIb/Y+pq98bX1LkwT5RS4
         UDyHM0WiQue9V3c/aZd2SaOIDBfzuP6Utk3gQqAPb+wFzO/vLj/HjpKcT5OsYWZcI96K
         1OKA==
X-Forwarded-Encrypted: i=1; AFNElJ9Hl8jAG1nnPeVp1NCx+yo8o0bJXLnL5jhqhxBT1a8gmMUaMpop8tVlOFgAxXIpYo6L3SSNmd4=@lists.linux.dev
X-Gm-Message-State: AOJu0YxUTiOORZUB73/L+kFLqz9cNMIKUuRm4FzZhCpWu0qrNtF4kzqU
	K89f4pIQZDlbUCc5R4DsjIC+aacPI5ljeuvEWx+b9+d11nSz9roURpNIrxmajz1a2kX9PP38EKE
	9qzzxiw==
X-Received: from wmv6.prod.google.com ([2002:a05:600c:26c6:b0:485:3f38:3dd2])
 (user=nogikh job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:4f08:b0:48f:99a9:bbd6
 with SMTP id 5b1f17b1804b1-490360bae19mr45875755e9.24.1779373392385; Thu, 21
 May 2026 07:23:12 -0700 (PDT)
Date: Thu, 21 May 2026 16:22:40 +0200
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.54.0.669.g59709faab0-goog
Message-ID: <20260521142240.2973022-1-nogikh@google.com>
Subject: [PATCH v2] signal: clear JOBCTL_PENDING_MASK for caller in zap_other_threads()
From: Aleksandr Nogikh <nogikh@google.com>
To: syzkaller-bugs@googlegroups.com, linux-kernel@vger.kernel.org
Cc: adrianhuang0701@gmail.com, akpm@linux-foundation.org, brauner@kernel.org, 
	kexinsun@smail.nju.edu.cn, oleg@redhat.com, peterz@infradead.org, 
	syzbot@lists.linux.dev, tglx@kernel.org, dvyukov@google.com, 
	Aleksandr Nogikh <nogikh@google.com>, syzbot+b109633ea805cac54a61@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"

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
already-zero signal->group_stop_count, triggering a warning:

sig->group_stop_count == 0
WARNING: CPU: 1 PID: 6475 at kernel/signal.c:373
task_participate_group_stop+0x215/0x2d0
Call Trace:
 <TASK>
 do_signal_stop+0x3be/0x5c0 kernel/signal.c:2619
 get_signal+0xa8c/0x1330 kernel/signal.c:2884
 arch_do_signal_or_restart+0xbc/0x840 arch/x86/kernel/signal.c:337
 exit_to_user_mode_loop+0x8c/0x4d0 kernel/entry/common.c:98
 do_syscall_64+0x33e/0xf80 arch/x86/entry/syscall_64.c:100
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
 </TASK>

Fix this race condition by clearing the JOBCTL_PENDING_MASK for the
calling thread in zap_other_threads(), ensuring it does not retain any
stale job control state after the thread group is destroyed. This aligns
with other functions that tear down a thread group and abort group
stops, such as zap_process() and complete_signal(), which correctly
clear these flags for all threads including the current one.

Fixes: 39efa3ef3a37 ("signal: Use GROUP_STOP_PENDING to stop once for a single group stop")
Assisted-by: Gemini:gemini-3.1-pro-preview Gemini:gemini-3-flash-preview syzbot
Reported-by: syzbot+b109633ea805cac54a61@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=b109633ea805cac54a61
Link: https://syzkaller.appspot.com/ai_job?id=d70208cc-862b-4fe3-bf02-3031e10cd0b3
Signed-off-by: Aleksandr Nogikh <nogikh@google.com>
---

v2:
Resending my from own name to comply with the rules.

v1:
https://lore.kernel.org/all/36638f2b-6f91-4e33-b630-fd7045eebc84@mail.kernel.org/

---
 kernel/signal.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/signal.c b/kernel/signal.c
index 2d102e0258839..9c2b32c4d7553 100644
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
2.54.0.669.g59709faab0-goog

