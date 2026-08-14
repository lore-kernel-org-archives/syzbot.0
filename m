Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24C0347DD7C
	for <syzbot@lists.linux.dev>; Fri, 14 Aug 2026 14:50:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786719058; cv=none; b=fE66QNIOZLFbUu2hJ1pUA1l0VQSOkem9ZeT002BGCyhszpKDZgsd7RRZ7Jw0VLn9IFFjVjB6e2LpMOeY2LjVaJqJVDr0Tcvt0nyRvq6Pqgfoo6q7q+UmQxYAAjaIeDxaVrM3BwAMyhguSJONLEqarVgO6YzLJpA8VL2aYiKbDG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786719058; c=relaxed/simple;
	bh=2tshIpfayR19C3STUrwN2i5wCGTqnOmWpS+qQZJlB/c=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=tMf0e5NC94VMqfiLIU8mB8eWcTyIGO7dVWjfeqI8IpL2130cuIxJPz/pBxFUF7vrQznf05mXNv1uGIkJR6leyWCsxRPGlWPodEUVhhdPndbBR6xMhv0zAB6h9652QgQS3j/hJh4EPRSDR+eDjm4AtbClBqwCQ+r5Jn/8uqndqls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mVVAt58E; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mVVAt58E"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 069321F00A3A;
	Fri, 14 Aug 2026 14:50:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786719044;
	bh=aK2dM6Co0AJ3JXlU/CnBk+dH3pS8PVqWjvKjgdWY5RQ=;
	h=From:To:Cc:Subject:Date;
	b=mVVAt58E5ULHQ8fntvwsUdWd21wlO1LYTewn3TyYsYkb1FoQ2pW0YUdggw5jNHetS
	 rCPaB/hpLGTqR5p6uovnN1BVJFtHjYJtPaEtL4M54zRmYeFUebiecb5hQG+FTX+5J8
	 ge1yjVNMwciJgLSbGnJvbUTuyphqPfElK6eGWtzaiKJALP1Uudl92Vsxseq6mxI2Oo
	 /y8acCuobWV12HRwiXRLvaobSHPKpM+YMWvbYq1Wrsvrr9MnzypifVpx0L3W3DqwXq
	 Qu0qm2edYV0ofgv3XE3LrldK9oYgMbQD+hVv4cQE4XbjOk5KJvKFOrMB0gFN4Ytbev
	 Rn6UCSPd3N7vg==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: nogikh@google.com, syzbot@lists.linux.dev
Subject: [PATCH RFC v2] Input: serio, gameport - clean up properly if device_add() fails
Message-ID: <218f6cb7-242d-4cef-a878-76ff3b927d83@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Fri, 14 Aug 2026 14:50:43 +0000 (UTC)

A general protection fault can occur in __device_attach() when device_add()
fails during port registration.

If device_add() fails (e.g. due to memory allocation failure), dev->p is
freed and set to NULL. However, events queued during device registration
may remain on the workqueue. When the workqueue processes these stale
events, it attempts to attach a driver, leading to a NULL pointer
dereference when accessing dev->p in __device_attach().

Oops: general protection fault, probably for non-canonical address
0xdffffc0000000021: 0000 [#1] SMP KASAN NOPTI
KASAN: null-ptr-deref in range [0x0000000000000108-0x000000000000010f]
CPU: 0 UID: 0 PID: 987 Comm: kworker/0:2 Not tainted PREEMPT(full)
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS
1.16.3-debian-1.16.3-2 04/01/2014
Workqueue: events_long serio_handle_event
RIP: 0010:__device_attach+0xb3/0x450 drivers/base/dd.c:1074
Call Trace:
 <TASK>
 serio_find_driver drivers/input/serio/serio.c:112 [inline]
 serio_handle_event+0x581/0x860 drivers/input/serio/serio.c:206
 process_one_work kernel/workqueue.c:3322 [inline]
 process_scheduled_works+0xa8e/0x14e0 kernel/workqueue.c:3405
 worker_thread+0x92d/0xe10 kernel/workqueue.c:3486
 kthread+0x388/0x470 kernel/kthread.c:436
 ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>

Fix this by properly cleaning up port state, unlinking parent references,
and removing pending events when device_add() fails in serio_add_port() and
gameport_add_port().

Fixes: ddf1ffbd40c9 ("Input: serio - let device core tell us if device was registered")
Assisted-by: Gemini:gemini-3.6-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+de42beb9ccc760a210ab@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=de42beb9ccc760a210ab
Link: https://syzkaller.appspot.com/ai_job?id=abe77c96-ec34-4c72-9a4e-12da9bb8ce68
To: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: <linux-input@vger.kernel.org>
Cc: "Kees Cook" <kees@kernel.org>
Cc: <linux-kernel@vger.kernel.org>

---
v2:
- Remove pending events and clean up port structures directly when device_add() fails in serio_add_port(), rather than checking device_is_registered() in serio_find_driver().
- Extend device_add() error handling and pending event cleanup to gameport_add_port().

v1:
https://lore.kernel.org/all/94a2df4a-c0d2-4a29-a692-e7250a623057@mail.kernel.org/T/
---
diff --git a/drivers/input/gameport/gameport.c b/drivers/input/gameport/gameport.c
index 9707b155b..7c90bbd74 100644
--- a/drivers/input/gameport/gameport.c
+++ b/drivers/input/gameport/gameport.c
@@ -598,10 +598,17 @@ static void gameport_add_port(struct gameport *gameport)
 			gameport->name, gameport->phys, gameport->speed);
 
 	error = device_add(&gameport->dev);
-	if (error)
+	if (error) {
 		dev_err(&gameport->dev,
 			"device_add() failed for %s (%s), error: %d\n",
 			gameport->phys, gameport->name, error);
+		if (gameport->parent) {
+			gameport->parent->child = NULL;
+			gameport->parent = NULL;
+		}
+		list_del_init(&gameport->node);
+		gameport_remove_pending_events(gameport);
+	}
 }
 
 /*
diff --git a/drivers/input/serio/serio.c b/drivers/input/serio/serio.c
index 54dd26249..1ce427069 100644
--- a/drivers/input/serio/serio.c
+++ b/drivers/input/serio/serio.c
@@ -510,10 +510,20 @@ static void serio_add_port(struct serio *serio)
 		serio->start(serio);
 
 	error = device_add(&serio->dev);
-	if (error)
+	if (error) {
 		dev_err(&serio->dev,
 			"device_add() failed for %s (%s), error: %d\n",
 			serio->phys, serio->name, error);
+		if (serio->stop)
+			serio->stop(serio);
+		if (parent) {
+			guard(serio_pause_rx)(parent);
+			list_del_init(&serio->child_node);
+			serio->parent = NULL;
+		}
+		list_del_init(&serio->node);
+		serio_remove_pending_events(serio);
+	}
 }
 
 /*


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
