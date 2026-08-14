Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 329D723BD05
	for <syzbot@lists.linux.dev>; Fri, 14 Aug 2026 03:26:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=100.103.45.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786678011; cv=pass; b=OzIouxVVQ+WZpjuQb1tiiDb1O4MjzIaWVkvvWgEo/9BoK2cTwTvigrkRYKVE7Ny8H5WV5mP+VzwSALfaOP1eF0HlhPYh6NVeFUAYOCWNWpxQg4y8ryWrVmhCNHu5VODFy7Zy0oj9ygcPiLFMXCg9fnRkx4TwXQIG5DAkmZG27iQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786678011; c=relaxed/simple;
	bh=GdbuusNsMQFdAEysKf53MIhq4ecB836kQpCfIOzTts0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=leAjhMvdMYbHQ3XVUwhNQivis9YPdb62iuhhyNZoq8/kwhzgsWCuyuM2wphdtsgMXOI45q9nvuhgUCBeIdr7WBH6QPdy1x4WsKuS4j/U1k1e9TjpPCeiJvOBRSrvMJSg0sdZl+Kc6oB2DyYaupQPLBsVXO+W+PZxBFjcTaO2gQQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=sina.com header.i=@sina.com header.b=lOyUYVOA; arc=pass smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=sina.com header.i=@sina.com header.b="lOyUYVOA"
Received: by smtp.kernel.org (Postfix)
	id 9B7481F00A3A; Fri, 14 Aug 2026 03:26:48 +0000 (UTC)
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=202.108.3.163
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1786678008;
	b=GJpvbbzIx1lR13cW9S6qtyxCOCYsILD0ffurUPaK0yOG1BH7vpQiV6nk1KrStuZIQnNB
	 ojLDZ11lZXNVI98MZjkuP+TuPp8sDhK3tYZCN+TAVqDTtLuWo7n45Yx80OYOYdCSwLbMw
	 zwsM3n31RtKCwAr8BaZ/L0FpnfZ+ymlLGEKKTO4FjLwvo1GRIfquoxGZDfqcrjT7UfXIW
	 KvGFpeH3F5olDAetjDCnlVqjUveww4jzRwHQcv8Zesv3iJUniZc1NNprujoc9HBhfjKWE
	 9AKkPuVQXr8OLHcs5IhbzXCMbDTPxXdfLTSmWeTDM+44FQ8eYg6vzRZoTyuvJR2TXow==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1786678008;
	h=DMARC-Filter:DKIM-Signature:X-SMAIL-HELO:Received:X-Sender:X-Auth-ID:
	 X-SMAIL-MID:X-SMAIL-UIID:From:To:Cc:Subject:Date:Message-ID:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=/xvS0Kxl7d4riGZXFWBaS3WJvljdRf0SdKdoBQoRvhY=;
	b=q2ACVkMNaQ4GYhfz8Tj23YvRQ0SvrWdMpLHbgqF4d8AYBPrFRkLrsENJv2ZcT78se5wr
	 ui1GNfyI65IyLftiQf4VTT7epOEzVqOSwHULBktmDdbetPxuT5Qbhq6iWkMaYeJ+SCyOt
	 FzeD0K7Yy1B/wNHGF+n45LGYkF83jZH2SQyFVqpz1WhLILON+VW/yqHqOCz/ibKY+5Ovj
	 Zu1Tdw1bOrnyHTrfcBFj7mYLRXoKJbaZiliGAkFoHbjX51ssu2d53EXDAb5HyNCIyTQKN
	 0LQR9zyP/aVIroXMAwSPd313niucFK7A2Ub8c2gZoFeV7SveYWj6Y1M13+0YEM7snqA==
ARC-Authentication-Results: i=1; smtp.kernel.org; dkim=pass header.d=sina.com header.i=@sina.com header.a=rsa-sha256 header.s=201208 header.b=lOyUYVOA;
	dmarc=pass header.from=sina.com;
	spf=pass smtp.mailfrom=sina.com;
	arc=none smtp.remote-ip=202.108.3.163
Received: from mail3-163.sinamail.sina.com.cn (mail3-163.sinamail.sina.com.cn [202.108.3.163])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id CAAA31F000E9
	for <syzbot@kernel.org>; Fri, 14 Aug 2026 03:26:44 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=sina.com header.i=@sina.com header.a=rsa-sha256 header.s=201208 header.b=lOyUYVOA
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.kernel.org CAAA31F000E9
Authentication-Results: smtp.kernel.org; dmarc=pass (p=none dis=none) header.from=sina.com
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=sina.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sina.com; s=201208; t=1786678006;
	bh=/xvS0Kxl7d4riGZXFWBaS3WJvljdRf0SdKdoBQoRvhY=;
	h=From:Subject:Date:Message-ID;
	b=lOyUYVOAziPypAS8QIH/wYI4sWYU53KN2gqKffdvLSNSV2WC1BVfKRu56gBlPD1/Z
	 ATj0CjSGQocTrH8i4qY8uVR7QjG1iYP6Oe8LciOYH47LqHiMbATpeC1NAW5MYULTdZ
	 rfgETBVmrxgpuMkLaQEGWn8xgEOnqqNk2zdLGJb0=
X-SMAIL-HELO: localhost.localdomain
Received: from unknown (HELO localhost.localdomain)([221.216.154.155])
	by sina.com (10.54.253.34) with ESMTP
	id 6A7E8AE70000170A; Fri, 14 Aug 2026 11:26:34 +0800 (CST)
X-Sender: hdanton@sina.com
X-Auth-ID: hdanton@sina.com
Authentication-Results: sina.com;
	 spf=none smtp.mailfrom=hdanton@sina.com;
	 dkim=none header.i=none;
	 dmarc=none action=none header.from=hdanton@sina.com
X-SMAIL-MID: 7258436291635
X-SMAIL-UIID: 86C19A9B27264A67818EBF7291DA371A-20260814-112634-1
From: Hillf Danton <hdanton@sina.com>
To: Uladzislau Zhauniarovich <uladzislau.zhauniarovich@gmail.com>
Cc: "syzbot" <syzbot@kernel.org>,
	syzkaller-bugs@googlegroups.com,
	Eric Dumazet <edumazet@google.com>,
	Vinicius Costa Gomes <vinicius.gomes@intel.com>,
	linux-kernel@vger.kernel.org,
	syzbot@lists.linux.dev
Subject: Re: [PATCH] net/sched: taprio: enforce minimum software scheduling interval
Date: Fri, 14 Aug 2026 11:26:23 +0800
Message-ID: <20260814032624.1082-1-hdanton@sina.com>
In-Reply-To: <afe041f6-ef7d-4434-b2d0-096be49b5bcb@mail.kernel.org>
References: 
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Thu, 13 Aug 2026 02:15:49 +0000 (UTC) Uladzislau Zhauniarovich wrote:
> When configuring taprio with a very small schedule interval (e.g., 129 ns),
> the kernel validates the interval against the time it takes to transmit a
> minimum-sized Ethernet frame (60 bytes). On high-speed links, this minimum
> duration is extremely small (e.g., 48 ns at 10 Gbps). Since the requested
> interval is larger than this, the validation passes. Virtual devices like
> veth or bonding can defeat this link-speed minimum check because they
> report inflated link speeds (e.g., veth reports 10 Gbps, and bonding sums
> member speeds).
> 
> However, when hardware offload is not used, taprio falls back to software
> scheduling and arms an hrtimer. The hrtimer is programmed to fire at the
> configured interval. If this interval is too small, it cannot sustain the
> timer service cost of one advance_sched() invocation, which includes lock
> acquisition, budget recomputation, and TX softirq processing. As a result,
> the timer constantly falls behind, and the CPU is livelocked in hardirq
> context endlessly servicing the advance_sched() hrtimer. This starves the
> RCU grace-period kthreads, leading to an RCU stall panic:
> 
> rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:
> rcu: 	1-...!: (1 GPs behind) idle=4854/0/0x1 softirq=136062/136068 fqs=0
> rcu: 	(detected by 0, t=10506 jiffies, g=161469, q=1866 ncpus=2)
> Sending NMI from CPU 0 to CPUs 1:
> NMI backtrace for cpu 1
> CPU: 1 UID: 0 PID: 0 Comm: swapper/1 Not tainted
> Call Trace:
>  <IRQ>
>  lock_is_held include/linux/lockdep.h:249 [inline]
>  enqueue_hrtimer+0x79/0x2c0 kernel/time/hrtimer.c:1107
>  __run_hrtimer kernel/time/hrtimer.c:1946 [inline]
>  __hrtimer_run_queues+0x4ce/0xa10 kernel/time/hrtimer.c:1994
>  hrtimer_interrupt+0x448/0x910 kernel/time/hrtimer.c:2113
>  local_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1050 [inline]
>  __sysvec_apic_timer_interrupt+0x102/0x430 arch/x86/kernel/apic/apic.c:1067
>  instr_sysvec_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1061
>  [inline]
>  sysvec_apic_timer_interrupt+0xa1/0xc0 arch/x86/kernel/apic/apic.c:1061
>  </IRQ>
> 
> To fix this, enforce a hard absolute minimum interval of 100 microseconds

Better if you specify why interval like 2us is ruled out.

> (TAPRIO_MIN_SW_INTERVAL_NS) for software-based scheduling, which provides
> enough margin over the timer service cost. Fully offloaded schedules are
> unaffected since they do not rely on the CPU's hrtimer. Introduce a helper
> taprio_min_interval() to consolidate the minimum interval logic for both
> individual schedule entries and the overall cycle_time validation.
