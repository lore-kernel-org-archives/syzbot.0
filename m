Received: from mail-ej2-f12.google.com (mail-ej2-f12.google.com [74.125.228.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06F6637E2E9
	for <syzbot@lists.linux.dev>; Fri, 18 Sep 2026 08:21:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789719710; cv=none; b=my6nsm5GgvQxHgNW2V9M6tqxZJRB+s6Ch7e5v7ljuqQDvfjXkSU/Z5G9rOrKt2eQq1a787QUveTs2Rk0kW8ydQUXuXYpdsgbabA5xQgZAVpolFqmcw/E8hsZXDfVPyFd7NoPWP365L4S8/c5U/GlP8DpwENl+pgx2+C7VQWev2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789719710; c=relaxed/simple;
	bh=ubJkMFQKwfqDLBpq4Nrbnku22f6sf4BmJpka8qBrXUM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=r5vZia3mTbBlT1ctwS2uPe9NMX4PHxxPpOWqgd6s8oV8RDnD36NVcXnZJDjv+jh/vD8NHNRifVMlCNcyBI6aNYMAc1qHr1ZZcVu/82KuXhuakq1FsKULnUlL9Aj5xkEW6yILk7UmC2N+keMunJtpxLhA2xJWPqYumkDF1flB5oI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bEjFg6az; arc=none smtp.client-ip=74.125.228.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bEjFg6az"
Received: by mail-ej2-f12.google.com with SMTP id a640c23a62f3a-c254f55efe5so66499766b.2
        for <syzbot@lists.linux.dev>; Fri, 18 Sep 2026 01:21:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789719707; x=1790324507; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5t/TUf1NvqEzMurWR/TCmOPQE8ytpgLFl008SM5jJTM=;
        b=bEjFg6azyVuvYu0ARFGMwoZ6teUmDcWPQ+cBRINDP9brMA7lkyJO+HWfx/kmvJoA40
         Qv8V0ELtHdx/cnq3A4ehJRGlCaZNSRVEPlbPoZ0pdANF/WerOLKFuBdb732XrvOilLtf
         yfI+fcoxJKvXysRaAoBlMvOk8GuBdj+sRJt9hUQLhksZq3JwL4jnwmn8RVBLXtc4f4/j
         VkpeXsv8gUGgbuJV72xYZvYkoyxM0O96vBRJgw7vtbfsSl2tVfG0mKASdDQsbjgh2bZj
         SqADk7eo18t+IBnAjePXZ+0Kdn6hR96otu08yy2wu8XluKdPpNDb3ADAuCP3iYNmfveP
         k6Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789719707; x=1790324507;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=5t/TUf1NvqEzMurWR/TCmOPQE8ytpgLFl008SM5jJTM=;
        b=gjQP0A+GgRl5h22Mh0slud1+/xdXCFyYZLLDcuG+cljvtgu5kdycIicUGA34KfM4lI
         DTr8PTOhDjt+pdB3ZO1NlszbU8WPZ99/Vruq6+5d/RFKTmTTK1u9bMX1urMxnGyZcrwV
         yZ1cSl5YbQQmd+8ak3EPFhJ1AaaobMofevwA/FuxLdTKdpkiOwFLQ1SVB80shmPZqfSz
         my9n8W/LBN+XjxuQPL5HmWJ5UyD8vkqp6jeSBTM8mjED7mfj3QlJJSurr5w77uejTqx+
         9Y+XRX78Nh7GlBF5J1MBRKlFlmlhejz6+x3mkCov3ehkpLCIpR25scYi8cUKXaCUtHin
         uoBg==
X-Gm-Message-State: AFuF++mzazWB7FCHtfdWueOVWfBRTwfYbplWjYeI+nRoFtTabUYQbwdl
	WGOuJhgwi/RXk4nWkSHqAaQll2tb/9HldVTUlyOVU3vak0hVXQWmurW6
X-Gm-Gg: AYBFou0r1IOmhjM2Db6ZsfkFSTgLZPloOUND6c6a5Yj9WvnqryqoAGk2s+1Ef76guZz
	4IesqbHJ29uculpKLL/Jo7tCTI7nNRRYsE0viAVe4XB03DPrivjaAbb+vHILRjkkBbyKE8mh3+A
	k6FdL0+7nJuv2kqN/TopwjakC0mNYCCXwiiNmY10nMENc5ia7DWB8ev1FSgoUXpC0L9P8XOnjMP
	6e/OfEu3Ma67l7QHVtDqjEel+lY9SqSfT4JSH/33VOJWYm+IIWdFfsbnX3g42nsJdMAJObqK0B7
	ewrO+5JIrvZeYso+D4iwkRAt1oJOhr097Ygs/4jWNim3T7cNxy8lXYVutpH/lmg0PH2dqygDrb7
	9mVskBaoRkHqKL+25lE48kt0ZycxQCfj0nGWAd1uJucc1JRSNKmgRyfwKckLSD1AO+2mI8GJbJD
	pCQN5jBl2nE6DxJ+QZeBSBIUwFe+o5+NXfxEJufhINCsdKq8lcZZuO+WYP3f1mJ+tgiJ31fpDle
	YJgYPUF/VgVE7QbDEde2wzLoYn6P6MbCZBfW3zoZVXEsdY1f98E9nCMWHPNm229Jfsc+lhiZYH4
	Z4UAq9xIATtkDxRj9vLagBlVHmJSEao0tOSxxDo1kvdFo6TfZo49wPFKUy7YdKLaZgbl0aSSsY7
	JO5S1ReckN/tkZm+x19Tr7svhdsjn9jT8bOiV93ZNtBXM6w==
X-Received: by 2002:a17:907:807:b0:c26:2eee:ffc7 with SMTP id a640c23a62f3a-c2a157fc258mr187069366b.35.1789719706534;
        Fri, 18 Sep 2026 01:21:46 -0700 (PDT)
Received: from [192.168.100.51] (87-205-15-91.static.ip.netia.com.pl. [87.205.15.91])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c2a1bbc6a06sm31540266b.53.2026.09.18.01.21.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Sep 2026 01:21:46 -0700 (PDT)
Message-ID: <5defc84a-e4c4-4964-a9a5-797a38ed4975@gmail.com>
Date: Fri, 18 Sep 2026 10:21:45 +0200
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC] net/sched: taprio: enforce minimum interval to
 prevent hrtimer storms
To: syzbot <syzbot@kernel.org>, syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
References: <7d5b3fcb-ab75-4a18-909f-5ff072e562e1@mail.kernel.org>
Content-Language: en-US
From: Krystian Kaniewski <krystianmkaniewski@gmail.com>
In-Reply-To: <7d5b3fcb-ab75-4a18-909f-5ff072e562e1@mail.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Restrict the new minimum interval to pure software taprio schedules that 
advance through `advance_timer`. The reported request enters that mode 
with an effective 127 ns interval and can starve RCU through repeated 
hrtimer callbacks. A 1 us floor still allows one million callbacks per 
second and has no demonstrated safety basis, while applying it to 
txtime-assist and hardware offload changes modes that do not use this 
timer path. Use a 100 us floor for the timer-driven mode, retain the 
existing physical frame-duration minimum for txtime-assist and full 
offload, and share one mode predicate across entry validation, aggregate 
cycle validation, timer setup, and timer start. Keep the existing parser 
errors, cleanup, accepted schedule representation, and non-timer mode 
behavior unchanged. Describe the threshold as a nominal callback-rate 
policy rather than an absolute CPU-safety guarantee.

On 7/15/2026 7:01 PM, syzbot wrote:
> An issue with the taprio packet scheduler allows a user to configure an
> extremely small schedule interval (e.g., 127 ns). While taprio validates
> that the interval is at least the time required to transmit a minimum-sized
> Ethernet frame (ETH_ZLEN), on high-speed virtual interfaces like 10 Gbps
> veth, this minimum duration evaluates to just 48 ns.
>
> Because the execution time of the hrtimer callback (plus hardware interrupt
> overhead) is significantly larger than 127 ns, the newly calculated
> end_time in advance_sched() is already in the past by the time the
> interrupt handler finishes. The hrtimer subsystem immediately fires the
> timer again, trapping the CPU in a continuous stream of timer interrupts
> (an hrtimer interrupt storm). This starves other threads, including the RCU
> grace-period kthread, leading to an RCU stall:
>
> rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:
> rcu: 	(detected by 0, t=10502 jiffies, g=15113, q=737 ncpus=2)
> rcu: All QSes seen, last rcu_preempt kthread activity 10502
> (4294956675-4294946173), jiffies_till_next_fqs=1, root ->qsmask 0x0
> rcu: rcu_preempt kthread timer wakeup didn't happen for 10501 jiffies!
> g15113 f0x2 RCU_GP_WAIT_FQS(5) ->state=0x200
> rcu: 	Possible timer handling issue on cpu=1 timer-softirq=3485
> rcu: rcu_preempt kthread starved for 10502 jiffies! g15113 f0x2
> RCU_GP_WAIT_FQS(5) ->state=0x200 ->cpu=1
> rcu: 	Unless rcu_preempt kthread gets sufficient CPU time, OOM is now
> expected behavior.
> ...
> Call Trace:
>   <IRQ>
>   lock_acquire+0x106/0x350 kernel/locking/lockdep.c:5868
>   rcu_lock_acquire include/linux/rcupdate.h:300 [inline]
>   rcu_read_lock include/linux/rcupdate.h:840 [inline]
>   advance_sched+0xa04/0xc80 net/sched/sch_taprio.c:992
>   __run_hrtimer kernel/time/hrtimer.c:2032 [inline]
>   __hrtimer_run_queues+0x3bc/0xa10 kernel/time/hrtimer.c:2096
>   hrtimer_interrupt+0x448/0x910 kernel/time/hrtimer.c:2215
>   local_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1051 [inline]
>   __sysvec_apic_timer_interrupt+0x102/0x430 arch/x86/kernel/apic/apic.c:1068
>
> To fix this issue, clamp the minimum allowed interval to a higher, safer
> threshold during the configuration phase. Introduce TAPRIO_MIN_INTERVAL
> (set to NSEC_PER_USEC, i.e., 1 microsecond) to account for software
> interrupt overhead. This threshold is large enough to prevent hrtimer
> interrupt storms while still allowing legitimate high-speed configurations
> (e.g., 10 Gbps with 1500-byte packets, which take 1.2 us to transmit).
>
> Apply this clamped minimum duration in both fill_sched_entry() and
> parse_taprio_schedule() to ensure that both individual intervals and the
> overall cycle time are safely bounded.
>
> Fixes: b5b73b26b3ca ("taprio: Fix allowing too small intervals")
> Assisted-by: Gemini:gemini-3.1-pro-preview Gemini:gemini-3-flash-preview syzbot
> Reported-by: syzbot+e044a9b6370ed8ca9737@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=e044a9b6370ed8ca9737
> Link: https://syzkaller.appspot.com/ai_job?id=894fc82e-5f23-4209-a5b3-4d0c8178756d
> To: "David S. Miller" <davem@davemloft.net>
> To: "Eric Dumazet" <edumazet@google.com>
> To: "Jamal Hadi Salim" <jhs@mojatatu.com>
> To: "Jiri Pirko" <jiri@resnulli.us>
> To: "Jakub Kicinski" <kuba@kernel.org>
> To: <netdev@vger.kernel.org>
> To: "Paolo Abeni" <pabeni@redhat.com>
> To: "Vinicius Costa Gomes" <vinicius.gomes@intel.com>
> Cc: "Simon Horman" <horms@kernel.org>
> Cc: <linux-kernel@vger.kernel.org>
>
> ---
> diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
> index 299234a5f..d759a99e5 100644
> --- a/net/sched/sch_taprio.c
> +++ b/net/sched/sch_taprio.c
> @@ -49,6 +49,9 @@ static struct static_key_false taprio_have_working_mqprio;
>    */
>   #define TAPRIO_PICOS_PER_BYTE_MIN 17
>   
> +/* Safe minimum interval to prevent hrtimer interrupt storms */
> +#define TAPRIO_MIN_INTERVAL NSEC_PER_USEC
> +
>   struct sched_entry {
>   	/* Durations between this GCL entry and the GCL entry where the
>   	 * respective traffic class gate closes
> @@ -1038,7 +1041,8 @@ static int fill_sched_entry(struct taprio_sched *q, struct nlattr **tb,
>   			    struct sched_entry *entry,
>   			    struct netlink_ext_ack *extack)
>   {
> -	int min_duration = length_to_duration(q, ETH_ZLEN);
> +	int min_duration = max_t(int, length_to_duration(q, ETH_ZLEN),
> +				 TAPRIO_MIN_INTERVAL);
>   	u32 interval = 0;
>   
>   	if (tb[TCA_TAPRIO_SCHED_ENTRY_CMD])
> @@ -1054,7 +1058,8 @@ static int fill_sched_entry(struct taprio_sched *q, struct nlattr **tb,
>   			tb[TCA_TAPRIO_SCHED_ENTRY_INTERVAL]);
>   
>   	/* The interval should allow at least the minimum ethernet
> -	 * frame to go out.
> +	 * frame to go out, and should be large enough to prevent
> +	 * hrtimer interrupt storms.
>   	 */
>   	if (interval < min_duration) {
>   		NL_SET_ERR_MSG(extack, "Invalid interval for schedule entry");
> @@ -1166,7 +1171,9 @@ static int parse_taprio_schedule(struct taprio_sched *q, struct nlattr **tb,
>   		new->cycle_time = cycle;
>   	}
>   
> -	if (new->cycle_time < new->num_entries * length_to_duration(q, ETH_ZLEN)) {
> +	if (new->cycle_time <
> +	    new->num_entries * max_t(int, length_to_duration(q, ETH_ZLEN),
> +				     TAPRIO_MIN_INTERVAL)) {
>   		NL_SET_ERR_MSG(extack, "'cycle_time' is too small");
>   		return -EINVAL;
>   	}
>
>
> base-commit: a13c140cc289c0b7b3770bce5b3ad42ab35074aa
