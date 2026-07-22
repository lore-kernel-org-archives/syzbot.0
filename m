Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5A6F425CF5
	for <syzbot@lists.linux.dev>; Wed, 22 Jul 2026 09:55:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784714144; cv=none; b=DsOH9omC6D/va6aAfsW4bMbuMwmnybMiWh3lZYCcpyn2uthp2OsM5T8V9ew2wNXobwv1ZQ5BEJsY0aB9wmYb48Tbg/0SavBI0X6lxxds879JhAWOu35ywa3ba58/3Lt+EydiM0Gt/Vl6HbMxGbAG1XUVynL/UsrEzNHJH7NrqgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784714144; c=relaxed/simple;
	bh=FDddWpBvjJNfzXzZD1ZwplUngUuvAyfzs0JXk5dFnMQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SdKbjhBTpq1BTYnYW6UnyKYxgd2/n1yTa+K9wxnUynYjzMk8bu5ZNiYZF2esHmMWYLTSdi/ykU6ICK99UMe2GWCAevRyaVCQgXh3BGJSXhtdx2I18GSuSPYTo92NEZDUHvC5a+cfX03I6x1A6e/TfXVQ6BTOJcUgGMgcGyuLu2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Kjnkxet0; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Kjnkxet0"
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-c15e592da74so1514975366b.1
        for <syzbot@lists.linux.dev>; Wed, 22 Jul 2026 02:55:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784714135; x=1785318935; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=NdvmE+sIPTxiDlzQm56Yu82QvHOOXWSCwykPVXP11cg=;
        b=Kjnkxet0onuaFbQQoj1oxHBglttZGdEZrpyy/dqE15D0bgZgp82cZMNz6FkJlE2Yin
         EVsMWl43vb5mc5dfprUjLdoY60NpvifpqMKd0b7xhFHfTKZLOsWTGoHKHRvcfQS9Apws
         RUsGWnH0q4tQ/Q2Sm4AJT79xLx0XoIfUUammFQa4Yifz5ao3HW8t5IpKgxxEjxjAQi7p
         SDW08LsbyAoGYEUeLlKUoQQVghymZpq9m/Zep99gVb4WOrqsw3v18CEk4cZNDi3LSOoa
         cpgqCe4i4WUcAMIl2Ze2GfUF6vXtfNB2+mBwkMBhdiak6Wjwb5kDqsqlyd3csZw08Rr0
         cl3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784714135; x=1785318935;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=NdvmE+sIPTxiDlzQm56Yu82QvHOOXWSCwykPVXP11cg=;
        b=M++Q6v2JMUZ6AmHuT3lZxa30gj5+dQIpsyieZnhsBUgj2pQY16IZ28hjuA44k0d0ko
         9VTy50VmpBlgl4sDiIGWQ++lnBVL84+/djR5rvt9LpwYbZzc9RjtYc6Izob8z17wDleQ
         vK9NbTCjmdt2XCFLgrWfc8jouu/jJCeBqBUI4j2k85JpKvxpIaQwuchp8psf6sulmOGi
         q61LLLBv+1Ph3cInaHBtsN0gEO+7aXwMZ3JmnBhEVAOh7rVEc/a/H1FRdM+3z9OkNu6p
         hUGKJbBKQSWIa5usbOpv3LftfiYlRFYkSAmQ9LrfMTPQHLFEtOLeMhiujbHv+DFodmK7
         CYeQ==
X-Gm-Message-State: AOJu0Yxhpkb0Wlm1Y4GSiTyLrR2UjvAoVs36UL+KrkuqP0nJVkAPJKP3
	N68cYbKlJ1VIbBkO8GdCGn75CI1st1cdtZfXaXPAK7hL8fVi1z3gysiC
X-Gm-Gg: AR+sD10w7WEK8UhMu9VwXD17A7TOiZwbOEjkfchbNZtZb/j0uyZBDTFvZIDxtMYyGo5
	dxUMMwBfi5Xyfbxoaj5nKu2NpnP/Vyx887maSiT7ejFWGEU7J8drsD4kaUMWkACd9nLulxSHLhn
	j7AIzogMlz8H61RX9Mu3avt1+E0TIbJBdIM+H6bevqvjBnVGBldt/LMIi5kDgDkgFl13vzLp0o6
	MV4+3LxLNNERL6ZE2i3x/pYBWNTgmF9CUUPpoqdT5KwJkW4sPdGleP2uiQ7/LRmi97dlT9uzGlc
	MRz6LPBCk9gJnzvIRNb3Tq9p/6hk4obfMgNWdRE8nxBX6ioHGx9eN8lIdyDT56TWFNZepnsDBjf
	WgfTdNwwaY1blN2b3h7QNjlgK6rcCO/B6yFsr/MVpvBXjWEBA9mtX2k68WhmTSVxtFpzAyNXFON
	c8Ampzihz13lh56BpdA9SvYCkBl0bSunwDFP1kibM4KU0QS9mGSrMY
X-Received: by 2002:a17:907:847:b0:c12:3059:4071 with SMTP id a640c23a62f3a-c16b46de902mr936348466b.15.1784714134447;
        Wed, 22 Jul 2026 02:55:34 -0700 (PDT)
Received: from [192.168.0.50] (93-159-28-46.cgnat.inetia.pl. [93.159.28.46])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c1c32a76fcdsm80071066b.4.2026.07.22.02.55.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Jul 2026 02:55:33 -0700 (PDT)
Message-ID: <dc2b32bb-5f61-44c2-8722-d90034f97564@gmail.com>
Date: Wed, 22 Jul 2026 11:55:31 +0200
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC] net/sched: taprio: enforce minimum software
 scheduling interval
To: syzbot <syzbot@kernel.org>, syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
References: <be92b2ea-2bf9-4d7f-a833-de781ee804c8@mail.kernel.org>
Content-Language: en-US
From: Uladzislau Zhauniarovich <uladzislau.zhauniarovich@gmail.com>
In-Reply-To: <be92b2ea-2bf9-4d7f-a833-de781ee804c8@mail.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

The patch correctly identifies the failure mechanism: with software
scheduling, advance_sched() is a self-rearming hrtimer, and an interval
short enough re-arms it with an already-expired deadline so it fires
back to back in hardirq context, starving the RCU grace-period kthread.
Gating the new minimum on !FULL_OFFLOAD_IS_ENABLED(q->flags) is right —
fully offloaded schedules are advanced by the NIC and must keep the
link-speed-derived minimum. The (s64) cast in the cycle_time check and
the Fixes: b5b73b26b3ca tag are also correct. Keep all of that.

The chosen floor of 1 microsecond does not fix the bug class, only this
exact reproducer. The reproducer's 129 ns cycle is rejected, but the
cost of one advance_sched() invocation is on the order of 10
microseconds on the syzbot debug configuration (KASAN, lockdep): each
fire takes current_entry_lock, recomputes per-traffic-class budgets and
raises the TX softirq. Any cycle between 1 and ~10 microseconds still
passes the new validation and still re-arms the timer into the past,
reproducing the identical livelock. A trivially modified reproducer (or
the fuzzer itself) will reopen this bug as a new instance. The floor
must exceed the worst-case cost of servicing the timer with a safety
margin, not merely exceed hardware interrupt overhead as the commit
message currently argues.

Also note why validation passes at all: virtual devices report inflated
link speeds — veth advertises SPEED_10000 and bonding sums the speeds of
its members — so length_to_duration(q, ETH_ZLEN) drops to tens of
nanoseconds on the reproducer's bond0-over-veth topology. The commit
message should state this, since it explains why the existing
b5b73b26b3ca check is insufficient on virtual topologies.

Required corrections:

Raise the floor to 100 microseconds and rename the constant to
TAPRIO_MIN_SW_INTERVAL_NS, defined as (100 * NSEC_PER_USEC). Add a
comment above the definition explaining that the value must exceed the
cost of one advance_sched() invocation (lock acquisition, budget
recomputation, TX softirq) with margin, so the timer always leaves the
CPU idle time to make progress. A software schedule with sub-100us
entries has no legitimate use: the timer overhead alone exceeds the
gate interval.

Do not duplicate the max_t() clamping logic in fill_sched_entry()
and parse_taprio_schedule(). Introduce one small helper next to
length_to_duration(), e.g.:

static int taprio_min_interval(struct taprio_sched *q)
{
int min = length_to_duration(q, ETH_ZLEN);

  if (!FULL_OFFLOAD_IS_ENABLED(q->flags))
      min = max_t(int, min, TAPRIO_MIN_SW_INTERVAL_NS);

  return min;
}

and call it from both validation sites. Remove the bare { } block that
the current version inserts into parse_taprio_schedule(); with the
helper, the cycle_time check stays a single expression:


if (new->cycle_time < (s64)new->num_entries * taprio_min_interval(q)) {
3. Keep the (s64) cast on the num_entries multiplication, the
!FULL_OFFLOAD_IS_ENABLED() gating, the existing NL_SET_ERR_MSG texts,
and the Fixes: b5b73b26b3ca ("taprio: Fix allowing too small
intervals") tag.

Rework the commit message: (a) replace the 1us "interrupt overhead"
justification with the timer-service-cost argument above; (b) explain
that virtual devices defeat the link-speed minimum (veth reports 10
Gb/s, bonding sums member speeds, giving a ~24-48 ns minimum on the
reproducer topology); (c) state explicitly that fully offloaded
schedules are unaffected.

Verification data for the 100us value: an A/B run of the
tc-testing taprio suite (tools/testing/selftests/tc-testing,
tc-tests/qdiscs/taprio.json) against this floor shows all existing
cases still pass — every valid software schedule in the suite uses
300us or larger entries — while the reproducer's configuration is
rejected at qdisc creation with -EINVAL. So the stricter floor does not
regress any exercised configuration.

On 27/06/2026 00:22, syzbot wrote:
> When configuring taprio with a very small schedule interval (e.g., 129 ns),
> the kernel validates the interval against the time it takes to transmit a
> minimum-sized Ethernet frame (60 bytes). On high-speed links like 10 Gbps,
> this minimum duration is extremely small (e.g., 48 ns). Since the requested
> interval is larger than this, the validation passes.
>
> However, when hardware offload is not used, taprio falls back to software
> scheduling and arms an hrtimer. The hrtimer is programmed to fire every 129
> ns. This is significantly shorter than the overhead of handling a hardware
> interrupt and running the hrtimer subsystem. As a result, the timer
> constantly falls behind, and the CPU is livelocked in hardirq context
> endlessly servicing the advance_sched() hrtimer. This starves the RCU
> grace-period kthreads, leading to an RCU stall panic:
>
> rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:
> rcu: 	1-...!: (1 GPs behind) idle=858c/1/0x4000000000000000
> softirq=112663/112663 fqs=0
> rcu: 	(detected by 0, t=10502 jiffies, g=143345, q=674 ncpus=2)
> Sending NMI from CPU 0 to CPUs 1:
> NMI backtrace for cpu 1
> ...
> Call Trace:
>   <IRQ>
>   advance_sched+0x99a/0xc80 net/sched/sch_taprio.c:988
>   __run_hrtimer kernel/time/hrtimer.c:1930 [inline]
>   __hrtimer_run_queues+0x3bc/0xa10 kernel/time/hrtimer.c:1994
>   hrtimer_interrupt+0x448/0x910 kernel/time/hrtimer.c:2113
>   local_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1050 [inline]
>   __sysvec_apic_timer_interrupt+0x102/0x430 arch/x86/kernel/apic/apic.c:1067
>   instr_sysvec_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1061
>   [inline]
>   sysvec_apic_timer_interrupt+0xa1/0xc0 arch/x86/kernel/apic/apic.c:1061
>   </IRQ>
>
> To fix this, enforce a hard absolute minimum interval of 1 microsecond
> (NSEC_PER_USEC) for software-based scheduling, regardless of the link
> speed. Hardware-offloaded taprio can continue to support smaller intervals
> since it does not rely on the CPU's hrtimer. The same logic is applied to
> the overall cycle_time validation, casting num_entries to s64 to prevent
> potential integer overflow.
>
> Fixes: b5b73b26b3ca ("taprio: Fix allowing too small intervals")
> Assisted-by: Gemini:gemini-3.1-pro-preview syzbot
> Reported-by: syzbot+19d01f6082ec61dd45b2@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=19d01f6082ec61dd45b2
> Link: https://syzkaller.appspot.com/ai_job?id=e96ce5ef-50a8-4856-a518-279d5610b23c
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
> index 45245157e..b5743a556 100644
> --- a/net/sched/sch_taprio.c
> +++ b/net/sched/sch_taprio.c
> @@ -49,6 +49,11 @@ static struct static_key_false taprio_have_working_mqprio;
>    */
>   #define TAPRIO_PICOS_PER_BYTE_MIN 17
>   
> +/* The software scheduler cannot sustain hrtimer intervals smaller than
> + * this without livelocking the CPU.
> + */
> +#define TAPRIO_MIN_SW_INTERVAL NSEC_PER_USEC
> +
>   struct sched_entry {
>   	/* Durations between this GCL entry and the GCL entry where the
>   	 * respective traffic class gate closes
> @@ -1041,6 +1046,9 @@ static int fill_sched_entry(struct taprio_sched *q, struct nlattr **tb,
>   	int min_duration = length_to_duration(q, ETH_ZLEN);
>   	u32 interval = 0;
>   
> +	if (!FULL_OFFLOAD_IS_ENABLED(q->flags))
> +		min_duration = max_t(int, min_duration, TAPRIO_MIN_SW_INTERVAL);
> +
>   	if (tb[TCA_TAPRIO_SCHED_ENTRY_CMD])
>   		entry->command = nla_get_u8(
>   			tb[TCA_TAPRIO_SCHED_ENTRY_CMD]);
> @@ -1054,7 +1062,8 @@ static int fill_sched_entry(struct taprio_sched *q, struct nlattr **tb,
>   			tb[TCA_TAPRIO_SCHED_ENTRY_INTERVAL]);
>   
>   	/* The interval should allow at least the minimum ethernet
> -	 * frame to go out.
> +	 * frame to go out. When software scheduling is used, the
> +	 * interval must also be at least the minimum hrtimer interval.
>   	 */
>   	if (interval < min_duration) {
>   		NL_SET_ERR_MSG(extack, "Invalid interval for schedule entry");
> @@ -1166,9 +1175,17 @@ static int parse_taprio_schedule(struct taprio_sched *q, struct nlattr **tb,
>   		new->cycle_time = cycle;
>   	}
>   
> -	if (new->cycle_time < new->num_entries * length_to_duration(q, ETH_ZLEN)) {
> -		NL_SET_ERR_MSG(extack, "'cycle_time' is too small");
> -		return -EINVAL;
> +	{
> +		int min_duration = length_to_duration(q, ETH_ZLEN);
> +
> +		if (!FULL_OFFLOAD_IS_ENABLED(q->flags))
> +			min_duration = max_t(int, min_duration,
> +					     TAPRIO_MIN_SW_INTERVAL);
> +
> +		if (new->cycle_time < (s64)new->num_entries * min_duration) {
> +			NL_SET_ERR_MSG(extack, "'cycle_time' is too small");
> +			return -EINVAL;
> +		}
>   	}
>   
>   	taprio_calculate_gate_durations(q, new);
>
>
> base-commit: 8cd9520d35a6c38db6567e97dd93b1f11f185dc6
