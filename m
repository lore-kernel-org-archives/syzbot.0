Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D702F53A3B0
	for <syzbot@lists.linux.dev>; Wed, 30 Sep 2026 18:40:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=100.103.45.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793631; cv=pass; b=VcOxq02FVqcDaeGUv/Wc13I9FnJl3I/4fwuiAzdRlO4BWhy6DyjRdLr8D4FDn2V/qHoG8tR2Hry9DbeVl5SMlJKUeWuCDiBVZapxO5UZnEmhUyVN8fSpIlK0R6opj0VbxpTmzcv0CWuy8dTeRZO3+ivA/cctnGcvyyUNazd4808=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793631; c=relaxed/simple;
	bh=PO3zSLemsYb6V3STG9ay9ZOBFRWq0ETmvr3jTsAf7xY=;
	h=Date:From:To:CC:Subject:In-Reply-To:Message-ID:MIME-Version:
	 Content-Type; b=e+OZOMStAhlMzxM6pkvT2b8W69YPgBLPkBCejFj9S/E8d8H3y0vTVdIwO0xJbbMxRNJaP3K+CKpStJv0B9Y8/R9Tat+csYooPTEm6lYMsrXYQfOu1Srs3HuYC5xxbFGl842fdJ0eomc3g1ouBzF9kHidgpsy7G5ZIBGN2eYU368=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=mainlining.org header.i=@mainlining.org header.b=JjjWv872; dkim=permerror (0-bit key) header.d=mainlining.org header.i=@mainlining.org header.b=A1/O6Wio; arc=pass smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mainlining.org header.i=@mainlining.org header.b="JjjWv872";
	dkim=permerror (0-bit key) header.d=mainlining.org header.i=@mainlining.org header.b="A1/O6Wio"
Received: by smtp.kernel.org (Postfix)
	id BD3011F00899; Wed, 30 Sep 2026 18:40:29 +0000 (UTC)
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=5.75.144.95
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1790793629;
	b=DI4O5HVGn2bxBg2Y47yVwmKt9uxoSzKNoAFw7DaQjVfa6AwCM/z3hjD92q65Bu7W6Qxg
	 6rpV7y08a1HsFF0SUQKJK/2v3nxu6ewod6JYpqUpEftRJKETYdT1rF7cINdNUQG16rJ5T
	 bYKnwEUXTH3Y0IK/yxeFlzm7bCbYpJkwbDy76EhYGCakkEX+8NlqnEOexZlWrvZRSHqPt
	 VEyBqC2lPUCobCY9MPGpHxIsNtdBI2JfFfD2jUZcoW6tNW044S/kubATWlpt2tsmXVlvb
	 S0NLPeigUgB6mfQPv9+PcaMeBQ8EzUZZ9jp4bfifDVN7BjvmD89olaQDeX1objONjxA==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1790793629;
	h=DMARC-Filter:DKIM-Signature:DKIM-Signature:Date:From:To:CC:Subject:
	 In-Reply-To:Message-ID:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=Nz85yE/lYTM7Ej79uUhTuxqAGd35qkfr+48hvRe8URc=;
	b=ZYnSG/Ep8HrD99apcbZ3TGk/dH7wGo/456JDQJnFEQ6tG/aYDnItiPgnK9biGvHbPA6v
	 Dg7ZRuzOZ/3G4z1RD3gpRzKnKjCI3U6d/c4J9uTCtUzQ8mBKullT6BqdfaoLvF+wZn0kE
	 BtgP1aQEDaHGM2FrbQZ3M/GLp5PdRZjpy4wGPV5AXMj5/0RThk+PJFG0doNnmTOEOML4L
	 N3Ciw6kNsrnFT5Hl1TyPrke5fDOjyB6WCTcGyFPP6mpU3aD2VkQr66F2nsbX1SzOvCMb8
	 qYoc9ZkO9u0/ew/Cb9pJZYqLcGiOcndYHIHIjX3+FltkP7wgH3hQ1QGh4vMM4a8V9dQ==
ARC-Authentication-Results: i=1; smtp.kernel.org; dkim=pass header.d=mainlining.org header.i=@mainlining.org header.a=rsa-sha256 header.s=202507r header.b=JjjWv872;
	dkim=pass header.d=mainlining.org header.i=@mainlining.org header.a=ed25519-sha256 header.s=202507e header.b="A1/O6Wio";
	dmarc=pass header.from=mainlining.org;
	spf=pass smtp.mailfrom=mainlining.org;
	arc=none smtp.remote-ip=5.75.144.95
Received: from mail.mainlining.org (mail.mainlining.org [5.75.144.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id B9ACA1F000FF
	for <syzbot@kernel.org>; Wed, 30 Sep 2026 18:40:28 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=mainlining.org header.i=@mainlining.org header.a=rsa-sha256 header.s=202507r header.b=JjjWv872;
	dkim=pass header.d=mainlining.org header.i=@mainlining.org header.a=ed25519-sha256 header.s=202507e header.b=A1/O6Wio
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.kernel.org B9ACA1F000FF
Authentication-Results: smtp.kernel.org; dmarc=pass (p=reject dis=none) header.from=mainlining.org
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=mainlining.org
DKIM-Signature: v=1; a=rsa-sha256; s=202507r; d=mainlining.org; c=relaxed/relaxed;
	h=Message-ID:Subject:To:From:Date; t=1790793626; bh=Nz85yE/lYTM7Ej79uUhTuxq
	AGd35qkfr+48hvRe8URc=; b=JjjWv8729DwToQQmmEu8Ri1S9D6HYrtWi+Fn+SumOt3dF+LeU3
	565ywbpOatwprkRN0FPPEDaBj6lM+hTElt/OGBVcUqonW/WmtRuYZ31yxmSYoI0EyHWY12sQvHx
	cp6dKyIgCShYmRLUfGTLhu3JFU8pvljhwKmaQ28yHpPD+8chwtQH0P4t2SEBV6AToMeN+wgR6Fq
	Nn38jsWos9JuPjL5tHDQAeOb+9e8Jk0IiSfSauNOhFuCcRzAvkNXtZZD9Hkyx6/6VZQpLJpsQfu
	KKkoUuFEVX8gOqqgLYLst2u8GF4W/CJkFIpyDrSTKkHqxQjvxP4mQNoRIHeG3VOmbdw==;
DKIM-Signature: v=1; a=ed25519-sha256; s=202507e; d=mainlining.org; c=relaxed/relaxed;
	h=Message-ID:Subject:To:From:Date; t=1790793626; bh=Nz85yE/lYTM7Ej79uUhTuxq
	AGd35qkfr+48hvRe8URc=; b=A1/O6WioisVaQxvE3GPWRsK/YhXY/3Qjh2FKNJnS/GdR9qCds8
	DkEsYk6Mceb5qh7Xqlq6SA4s062uzuHaGsAg==;
Date: Wed, 30 Sep 2026 19:40:25 +0100
From: Bradley Morgan <brads@mainlining.org>
To: syzbot@kernel.org
CC: syzbot@lists.linux.dev, syzkaller-upstream-moderation@googlegroups.com
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH_RFC=5D_srcu=3A_Drop_spurious?=
 =?US-ASCII?Q?_WARN=5FON=28=29_in_cleanup=5Fsrcu=5Fstruct=28=29?=
In-Reply-To: <8cc243d4-47e2-4792-a564-9776a7810609@mail.kernel.org>
Message-ID: <D2A6F414-F6F7-4A63-8854-D774055AC5D3@mainlining.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 8bit

On 30 September 2026 03:11:19 BST, syzbot <syzbot@kernel.org> wrote:
>In cleanup_srcu_struct(), commit 78a38cbf6f20 ("srcu: Queue sdp->work when
>the delay timer is successfully deleted") added logic to queue sdp->work
>if
>timer_delete_sync(&sdp->delay_work) successfully canceled a pending timer
>while callbacks remained pending on sdp->srcu_cblist. However, it wrapped
>this check in a WARN_ON() under the assumption that callers invoking
>srcu_barrier() prior to cleanup_srcu_struct() would prevent the warning
>from triggering.
>
>This warning can be spuriously triggered during valid teardown paths where
>srcu_barrier() is properly invoked before cleanup_srcu_struct(), such as
>when releasing blk-mq tag sets:
>
>WARNING: kernel/rcu/srcutree.c:707 at cleanup_srcu_struct+0x3d6/0x8b0
>kernel/rcu/srcutree.c:706
>Call Trace:
> <TASK>
> blk_mq_free_tag_set+0x617/0x790 block/blk-mq.c:4976
> scsi_mq_free_tags+0x16/0x30 drivers/scsi/scsi_lib.c:2167
> scsi_remove_host+0x243/0x730 drivers/scsi/hosts.c:193
> uas_disconnect+0x135/0x3e0 drivers/usb/storage/uas.c:1236
> usb_unbind_interface+0x295/0x9f0 drivers/usb/core/driver.c:461
> device_release_driver_internal+0x4f5/0x880 drivers/base/dd.c:1372
> bus_remove_device+0x444/0x560 drivers/base/bus.c:664
> device_del+0x524/0x8f0 drivers/base/core.c:3965
> usb_disconnect+0x346/0x9a0 drivers/usb/core/hub.c:2350
> hub_event+0x1bbb/0x4d30 drivers/usb/core/hub.c:5966
> process_scheduled_works+0xc3d/0x1630 kernel/workqueue.c:3479
> worker_thread+0xa47/0xfb0 kernel/workqueue.c:3560
> kthread+0x38b/0x480 kernel/kthread.c:436
> ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
> ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
> </TASK>
>
>This false positive occurs due to a race between callback invocation and
>the teardown thread. First, sdp->delay_work can legitimately remain armed:
>when an SRCU grace period completes, srcu_gp_end() arms sdp->delay_work
>with a delay, and if callbacks are later scheduled with zero delay via
>srcu_schedule_cbs_sdp(sdp, 0), queue_work_on() queues sdp->work directly
>without deleting sdp->delay_work. Second, in srcu_invoke_callbacks(),
>callbacks (including the one queued by srcu_barrier()) are extracted into
>a
>local list and executed, but sdp->srcu_cblist length is only decremented
>via rcu_segcblist_add_len(&sdp->srcu_cblist, -len) after all callbacks
>finish executing. When srcu_barrier_cb() executes, it wakes the waiting
>srcu_barrier() thread, which proceeds immediately to
>cleanup_srcu_struct().
>At that point, the worker thread is still executing callbacks and has not
>yet decremented the callback count, so timer_delete_sync(&sdp->delay_work)
>returns 1 and rcu_segcblist_n_cbs(&sdp->srcu_cblist) is non-zero, firing
>the WARN_ON(). Immediately thereafter, flush_work(&sdp->work) waits for
>the
>worker to finish, and the subsequent check on rcu_segcblist_n_cbs()
>correctly sees no remaining callbacks.
>
>Because WARN_ON() must not be used for conditions that can legitimately
>happen, and pr_err() should be used instead if an actual error needs to be
>reported (which is not applicable here as this is normal recovery
>behavior), remove the WARN_ON() check and its accompanying comment. Keep
>the queue_work_on() recovery logic so that flush_work() properly waits for
>remaining callbacks to complete. Genuine callback leaks remain caught by
>the subsequent authoritative
>WARN_ON(rcu_segcblist_n_cbs(&sdp->srcu_cblist)) check performed after work
>has been flushed.
>
>Fixes: 78a38cbf6f20 ("srcu: Queue sdp->work when the delay timer is successfully deleted")
>Assisted-by: Gemini:gemini-3.8-flash Gemini:gemini-3.1-pro-preview syzbot
>Reported-by: syzbot+02b37e31e64ea5cb6d29@syzkaller.appspotmail.com
>Closes: https://syzkaller.appspot.com/bug?extid=02b37e31e64ea5cb6d29
>Link: https://syzkaller.appspot.com/ai_job?id=5a402d0b-b407-49a6-b0f3-b06197c1398f
>To: "Lai Jiangshan" <jiangshanlai@gmail.com>
>To: "Josh Triplett" <josh@joshtriplett.org>
>To: "Paul E. McKenney" <paulmck@kernel.org>
>To: <rcu@vger.kernel.org>
>To: =?utf-8?q?Onur_=C3=96zkan?= <work@onurozkan.dev>
>To: "Zqiang" <qiang.zhang@linux.dev>
>Cc: <linux-kernel@vger.kernel.org>
>Cc: "Mathieu Desnoyers" <mathieu.desnoyers@efficios.com>
>Cc: "Steven Rostedt" <rostedt@goodmis.org>
>
>---
>diff --git a/kernel/rcu/srcutree.c b/kernel/rcu/srcutree.c
>index ed204b3f4..7f30a5587 100644
>--- a/kernel/rcu/srcutree.c
>+++ b/kernel/rcu/srcutree.c
>@@ -701,10 +701,8 @@ void cleanup_srcu_struct(struct srcu_struct *ssp)
> 	for_each_possible_cpu(cpu) {
> 		struct srcu_data *sdp = per_cpu_ptr(ssp->sda, cpu);
> 
>-		// Call srcu_barrier() before this cleanup_srcu_struct()
>-		// to avoid triggering this WARN_ON().
>-		if (WARN_ON(timer_delete_sync(&sdp->delay_work) &&
>-			    rcu_segcblist_n_cbs(&sdp->srcu_cblist)) &&
>+		if (timer_delete_sync(&sdp->delay_work) &&
>+		    rcu_segcblist_n_cbs(&sdp->srcu_cblist) &&
> 		    rcu_cpu_beenfullyonline(sdp->cpu))
> 			queue_work_on(sdp->cpu, rcu_gp_wq, &sdp->work);
> 		flush_work(&sdp->work);
>
>
>base-commit: 72d3fcf802c45d00b300f25b848a93c3a2bd7c7e
>
LGTM,


#syz upstream
--- Thanks!
"I'm not a very positive person" - Linus torvalds
