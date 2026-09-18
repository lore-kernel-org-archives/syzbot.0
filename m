Received: from mail-ej2-f25.google.com (mail-ej2-f25.google.com [74.125.228.153])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 179954F5DF5
	for <syzbot@lists.linux.dev>; Fri, 18 Sep 2026 14:28:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.153
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789741724; cv=none; b=sZV7fW4ZQpyZ3zI8MBWHgBD76r8xSDP8I2mt0QfDnq3By4Wb6npPw6+8M1JPEefqt2HAoSkpsXepfwVSZFY9SDhAMwmGAQYwU1WHeMtMgQFEjysKTZ4BLUonf0BfbJBucD8hAPLEvFj0rcAIeGkPHmGnjTgnfkjTh/ulvRDEBHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789741724; c=relaxed/simple;
	bh=7rWEdmYHaPNSr71xG3g9xZppJ3hTV3i5WbcJrkP16xo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mbUmr+xoTIKsW6WCfy14n3Q9AOn+ovcITtMf5W1an2JBjavC8wMndBUGefTcjaW4lnFiAsuF8xexkNSCnSKCmtmqAeMPV8yuNlB3AbOtGOfrS7vWYUyLHvsQq5NyMxPnprSHi6Vz8pWyFA7J4v1dIYs92Ay+mkRAzVB1whklIeg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PsNxkqkn; arc=none smtp.client-ip=74.125.228.153
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PsNxkqkn"
Received: by mail-ej2-f25.google.com with SMTP id a640c23a62f3a-c254fa4c24cso124715966b.2
        for <syzbot@lists.linux.dev>; Fri, 18 Sep 2026 07:28:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789741719; x=1790346519; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=GRNKZiOW7z7G5cJppjIyTsTsewd3SoHkddzAG5svRdg=;
        b=PsNxkqkny9negGL4Uksy38LV/LiGp4PvaG8z1T+EX/3xkSdnqA306o+fhPEyYMkfVj
         1KnmidosFPU3+uWGhLM74X/LSPBt0nah3yXar7PLqfegPm2Q9A/AL9ZtqFxzeawb1e7W
         pQ88dg64Q3ShktUiX2UO1/Ny3gLH8SiZhuh4bPVC+NvUSTnQBRekbtjl1hOiJn/XfQ//
         IZ4FaUWhZ24WAwrZQi3dzsNZTvTHAZ9EvA1hancN37Xa5ZNh0b3ertKWyON3shR8tZUl
         JonlteHiI9FfGw47zExReIxMmHDGdPmvakRItwn6q40W4zHjPgIpPkvmERqwYdiIfEG0
         l8ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789741719; x=1790346519;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=GRNKZiOW7z7G5cJppjIyTsTsewd3SoHkddzAG5svRdg=;
        b=KsnEJoNd/OGoaOrF9yVjvsvfHPQMdeUwN7sXRhHiv3o4OpZcnCiyAPGq4Vu2bma6Do
         jPOt9mKbqRaXcwl/TiRPdI6hSs7r5BJ8bib6oyQptTq693ohBviSbDY+7NAG4Ae+0bcH
         NVtQtz+jdZRsx9Ft55sPMITJS8SMLwLtU1Id2COKAAMhxz6DW2vDzGoxF4dUpyV5V1fo
         FYjWrkfYYlkez6dEXp9YFAjyf5tPb6ZIzpPD8mAj0W9F5TjbP2jQFgzUs1KCc/LVXF9K
         PZ3CaQoyEf1jN4aohInznte/tXCPrNejfJC8nL6wpKAWl8Sr998Pa3jWpBgG9ci3EUtv
         cE4A==
X-Gm-Message-State: AFuF++nonoPpIJv8XkJ2/ri6ZPSv8n2a9FlNv/EtkFOufSigxXeuanjn
	IXDZgKLpBQ2JzRoLw8x1bxEYXR9q1yhGZz3sX+FHT/CnkUGtw3lvKfS/
X-Gm-Gg: AYBFou17J5H8xqUwqnW7gMJi2BxMAs3DXd/7u5NRoAnCsrrKF7v/Jf3oMKIoI7LUzU8
	C58tBaSg47g5ZZXsdzHJPoG4iOAbQ0sv1S9PqfisReUc+LlmFKUyNFcakhx68cl7HtcfY8Tz8Jy
	YoffMPDYUIHXF6WOCN403tUPDOfpLH8upCFOXrkiNKP2zjwK2BmzDfxJGKlG7hQVmwqaJBf4kgQ
	cR+eTqC57kT+9TkgBYakJ3isGDLauB640nKwu8SDsMjBoDZL6C9+BP+cGJ7rnQlfoW50FFetI+Q
	ADE4dBWx0ks0Mcw0/fHuh5fREqJupe7+F4Mb5umShDlVmA9jCrX4JHjmg1ZIDnkMaWIHf8oiDNr
	XU2iCmxsYccCM+4qY/hi8UfqinSaxiuYCKjuz019C5mtR5dlArCjrOkseoj7sbzDZspqoHV3jfe
	akKoR6X5xJ/9rAL3wy9dJ0x0nwmc8GB9JyeLBbLweD4t9SX7bc9bFRwes6tK8cto3SctXrDn5tl
	AXXnknwvriGYRM7UtTrbwpMGKNuCdVTjBp4j3/WYrDIKvUSWw/akQK6Vpzcc/IiYbes3OLjUYWu
	byLtXezDJzaZJ0KgvyHh+qzpcEskIZQRdwW6CEMfHFlrSwLvwvjedxwdfwPQsYf5JCdpaiTi0Zl
	1SohOQoWZfT0evTv5JQ/cWZebrnPcKLoRx3nG1dlJmFIscQ==
X-Received: by 2002:a17:907:1c10:b0:c26:19de:9acc with SMTP id a640c23a62f3a-c2a15e11474mr277879466b.36.1789741719187;
        Fri, 18 Sep 2026 07:28:39 -0700 (PDT)
Received: from [192.168.100.51] (87-205-15-91.static.ip.netia.com.pl. [87.205.15.91])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c2a1bc38676sm61707966b.62.2026.09.18.07.28.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Sep 2026 07:28:38 -0700 (PDT)
Message-ID: <39315b19-57eb-45a8-90e6-414ead122529@gmail.com>
Date: Fri, 18 Sep 2026 16:28:37 +0200
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v2] net/sched: taprio: enforce minimum interval to
 prevent hrtimer storms
To: syzbot <syzbot@kernel.org>, syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
References: <4de7b2e3-3f72-41a4-8735-67d91fc74009@mail.kernel.org>
Content-Language: en-US
From: Krystian Kaniewski <krystianmkaniewski@gmail.com>
In-Reply-To: <4de7b2e3-3f72-41a4-8735-67d91fc74009@mail.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

The v2 patch needs two linked corrections in `net/sched/sch_taprio.c`.

Keep the shared timer-driven predicate and the mode-scoped 100 us 
per-entry floor. Replace the timer-driven aggregate check based on 
`num_entries * minimum` with a check that requires an explicit cycle to 
be at least the sum of the accepted entry intervals. The current 
calculation permits one 1 ms entry with a 100 us explicit cycle. 
`advance_sched()` clamps to the cycle boundary, so that accepted 
schedule can restart on deadlines already in the past.

Also initialize and start the software `advance_timer` with 
`HRTIMER_MODE_ABS_SOFT` at every setup and start site. The current v2 
patch leaves the callback in hard hrtimer context, which allows an 
overdue timer to delay hard IPI and RCU progress.

Do not apply the 100 us policy or the entry-sum cycle rule to txtime 
assist or full offload. Preserve their existing link-rate-derived parser 
range. Keep the existing entry and cycle error codes, parse cleanup, 
timer cancellation, and schedule ownership behavior.

On 9/18/2026 12:40 PM, syzbot wrote:
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
> To prevent this, enforce a minimum interval threshold during configuration
> when operating in software timer-driven mode (i.e. neither txtime-assist
> nor full offload is enabled). Introduce TAPRIO_MIN_INTERVAL set to 100
> microseconds (100 * NSEC_PER_USEC). Rather than serving as an absolute
> CPU-safety guarantee across all possible hardware and workloads, this 100
> us floor acts as a nominal callback-rate policy that limits the timer
> interrupt rate to at most 10,000 events per second. Hardware-assisted and
> offloaded modes do not rely on this software timer and remain unaffected.
>
> Apply this clamped minimum duration in fill_sched_entry() and
> parse_taprio_schedule() for timer-driven mode to ensure that both
> individual entry intervals and the overall cycle time respect this floor.
> Also add and use taprio_is_timer_driven() to simplify timer-mode checks
> across taprio.
>
> Fixes: b5b73b26b3ca ("taprio: Fix allowing too small intervals")
> Assisted-by: Gemini:gemini-3.8-flash syzbot
> Reported-by: syzbot+e044a9b6370ed8ca9737@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=e044a9b6370ed8ca9737
> Link: https://syzkaller.appspot.com/ai_job?id=aebe94be-5985-4e0f-9e09-df765e4df5bb
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
> v2:
> - Increased the minimum interval floor (TAPRIO_MIN_INTERVAL) from 1 us to 100 us.
> - Restricted the minimum interval constraint to software timer-driven mode via a new taprio_is_timer_driven() helper.
> - Used taprio_is_timer_driven() helper in taprio_start_sched() and taprio_change().
> - Clarified in the commit message that the threshold represents a nominal callback-rate policy rather than an absolute safety guarantee.
>
> v1:
> https://lore.kernel.org/all/7d5b3fcb-ab75-4a18-909f-5ff072e562e1@mail.kernel.org/T/
> ---
> diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
> index 299234a5f..f399f6a4a 100644
> --- a/net/sched/sch_taprio.c
> +++ b/net/sched/sch_taprio.c
> @@ -43,12 +43,26 @@ static struct static_key_false taprio_have_working_mqprio;
>   #define TAPRIO_SUPPORTED_FLAGS \
>   	(TCA_TAPRIO_ATTR_FLAG_TXTIME_ASSIST | TCA_TAPRIO_ATTR_FLAG_FULL_OFFLOAD)
>   #define TAPRIO_FLAGS_INVALID U32_MAX
> +
> +static inline bool taprio_is_timer_driven(u32 flags)
> +{
> +	return !TXTIME_ASSIST_IS_ENABLED(flags) &&
> +	       !FULL_OFFLOAD_IS_ENABLED(flags);
> +}
> +
>   /* Minimum value for picos_per_byte to ensure non-zero duration
>    * for minimum-sized Ethernet frames (ETH_ZLEN = 60).
>    * 60 * 17 > PSEC_PER_NSEC (1000)
>    */
>   #define TAPRIO_PICOS_PER_BYTE_MIN 17
>   
> +/* Nominal callback-rate policy for timer-driven mode to prevent
> + * hrtimer interrupt storms (100 us floor corresponds to at most
> + * 10,000 timer interrupts per second). This is a nominal callback-rate
> + * policy rather than an absolute CPU-safety guarantee.
> + */
> +#define TAPRIO_MIN_INTERVAL (100 * NSEC_PER_USEC)
> +
>   struct sched_entry {
>   	/* Durations between this GCL entry and the GCL entry where the
>   	 * respective traffic class gate closes
> @@ -1041,6 +1055,9 @@ static int fill_sched_entry(struct taprio_sched *q, struct nlattr **tb,
>   	int min_duration = length_to_duration(q, ETH_ZLEN);
>   	u32 interval = 0;
>   
> +	if (taprio_is_timer_driven(q->flags))
> +		min_duration = max_t(int, min_duration, TAPRIO_MIN_INTERVAL);
> +
>   	if (tb[TCA_TAPRIO_SCHED_ENTRY_CMD])
>   		entry->command = nla_get_u8(
>   			tb[TCA_TAPRIO_SCHED_ENTRY_CMD]);
> @@ -1129,6 +1146,7 @@ static int parse_taprio_schedule(struct taprio_sched *q, struct nlattr **tb,
>   				 struct sched_gate_list *new,
>   				 struct netlink_ext_ack *extack)
>   {
> +	int min_duration;
>   	int err = 0;
>   
>   	if (tb[TCA_TAPRIO_ATTR_SCHED_SINGLE_ENTRY]) {
> @@ -1166,7 +1184,11 @@ static int parse_taprio_schedule(struct taprio_sched *q, struct nlattr **tb,
>   		new->cycle_time = cycle;
>   	}
>   
> -	if (new->cycle_time < new->num_entries * length_to_duration(q, ETH_ZLEN)) {
> +	min_duration = length_to_duration(q, ETH_ZLEN);
> +	if (taprio_is_timer_driven(q->flags))
> +		min_duration = max_t(int, min_duration, TAPRIO_MIN_INTERVAL);
> +
> +	if (new->cycle_time < new->num_entries * min_duration) {
>   		NL_SET_ERR_MSG(extack, "'cycle_time' is too small");
>   		return -EINVAL;
>   	}
> @@ -1274,7 +1296,7 @@ static void taprio_start_sched(struct Qdisc *sch,
>   	struct taprio_sched *q = qdisc_priv(sch);
>   	ktime_t expires;
>   
> -	if (FULL_OFFLOAD_IS_ENABLED(q->flags))
> +	if (!taprio_is_timer_driven(q->flags))
>   		return;
>   
>   	expires = hrtimer_get_expires(&q->advance_timer);
> @@ -1946,8 +1968,7 @@ static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
>   			   nla_get_u32(tb[TCA_TAPRIO_ATTR_TXTIME_DELAY]));
>   	}
>   
> -	if (!TXTIME_ASSIST_IS_ENABLED(q->flags) &&
> -	    !FULL_OFFLOAD_IS_ENABLED(q->flags) &&
> +	if (taprio_is_timer_driven(q->flags) &&
>   	    !hrtimer_active(&q->advance_timer)) {
>   		hrtimer_setup(&q->advance_timer, advance_sched, q->clockid, HRTIMER_MODE_ABS);
>   	}
>
>
> base-commit: a13c140cc289c0b7b3770bce5b3ad42ab35074aa
