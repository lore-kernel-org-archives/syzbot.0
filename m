Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 375D7318EEE
	for <syzbot@lists.linux.dev>; Thu, 13 Aug 2026 02:11:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786587062; cv=none; b=TXegechAS2Q+iraSgdgpyqyO9dsNpBJ9klAmernoing5Ll32adVlVxfsDNlD2j1RBt65RmRPI8FrX9UsFg519I6u1SLp8DVlZkCT/IARN7fMrbvXVTQK58Bg23CRxTb8OtDXYHyXOkgr8bUDIhc1tzc0EUjjtcsnZkWcSKdk1Ws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786587062; c=relaxed/simple;
	bh=21L6LEwW0Kk2k09X1ddj6DxULwgI0Ky+04CJoZScCWQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KlYyXUoF8aaJTWB/pRNATdL62RcAl+GGk3QW33qwcOy1h6hhlDmx/F67pVldAJJPoWjqm7PD0CnsR6FBYV9PtZ0APJQVriImo2dQpN9RVttuc1APxlnud08po0Cc2jRdzD/APimCeG18nc+x9EKCSM+JnEF5MOLwWDxrDZjuRr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gCfSveT3; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gCfSveT3"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-495635a85d2so12879245e9.0
        for <syzbot@lists.linux.dev>; Wed, 12 Aug 2026 19:10:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786587058; x=1787191858; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=RsLryur3a4MeMdmFwWdBX2hb3BzsyFJfyD/vztUa1Nk=;
        b=gCfSveT31RDU3T4zNMKUu7lpFi1JIpfOjdJtTn1KCqF8je+sZFSP1QOAzl3xTf0xo+
         h4o+aS6tcxeYfoG9O1C1Nl9ck86yJn4hF5DahVx29ObYl9ktEixo/WM5xF1wYQ4VbAg5
         S1j7HrGBBkinWBr60DDk6aAN2XZqGiZR9OeKegsYOM3FLaTbZo7Cn7fq0TIZ23uZ6AgT
         r3KMaGXc98nfAOhxORs5YI8Y9QO1NDuyDT7w6TE57FqmciSSBwHk7msndRpMnc7TF1/M
         63BVvQzHdzzdBx6Ik9MA/cMSs0Cn/RxF/407zMKD+qzb4TNwOfmZbVQWsKigQ+FsW0cq
         a7Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786587058; x=1787191858;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=RsLryur3a4MeMdmFwWdBX2hb3BzsyFJfyD/vztUa1Nk=;
        b=RHqM1nMMuUQqvBFRWu3k7Ag60szFzbJmryZqW450ZwGZKYNXLzz1mCDEtpWkpQFBp7
         p9Rzj3G7NMeMcms1pU16v0Ogu6qpOpl9joUNjwI2wyrXMC/8+/77XMB+M4NIJ9jV9h3h
         6QhyULrGzQsP+fLdBUR0xkby5nwphUk9UJXIQEBjAtmzBPSrZQDrma41JHgrpjBOZA4h
         xxl5EdY0/c2f6pdoRzJAdZ4i86K6Q0tHgk6a+eJWEd5sHkrSu+ghxAi6aquDaYgrZOWU
         T2TRggfOSqk8W3H+cXdhvjHNTG62JMeWnZ10bH6WuxcsIHejsw6lBfHBctrMCFVm3T1L
         xmzg==
X-Gm-Message-State: AOJu0YwYJw946uSAdi/Pry22dyvFd0cJu7UX2/+CSardfK8kgHfDnsHD
	HEq3ydXnU8CoVB3wWGpOrBF9UAtb2aljV11YG77tROiXN+mnNKSGsXge
X-Gm-Gg: AR+sD13vc55IGPVv/0F2l1dzNlTyFCrEWGHxMnSVpkz8Q/oS0FQhuhPQnVjPVThS0eW
	SmgDdxXmLcezMuKg5xkZiq5uTghIwHOsXbJZlCSMaH0inmLAGVDJ4dbfrrMQAgHU17kPnNOKv9Z
	4Mlhe+i1+UilmQ10V+GIkh0yKpsNKjsjVmLBEmEMP47atcpSLcqrNZlr1dFs6HzFUNR1C7qj6Sm
	HfMrAOJuOGkr7HTgN3vZtzHdBOveocT6GJYAb2w85kyk6tGsLHjOCDgIxQIQ/BJgOdmTSycxccV
	wZqc1ZMk7IxvEbD4U6kWRcgJQ9alQ+kCpLljzTZdabModYxTXmAIvir8jJrUV02uEYYRTN5UJr+
	cTGTRXiSo3qV70yB4FbMdhlGOh6hfCF2kJnCYkI+gZAaFxiXEiBjGUsTy1yin8JC+NT6GYjP63o
	0QRAyRksc4rCXhDqpjHBh/t+PvD/FqIDY6BXmf5gePsTjEhB8BJBkXWF81ZrMWI3pa6H7uuUvI9
	WUJ0eTA8JitTouua71v28XACQG1FauRi5EkVLxRUg==
X-Received: by 2002:a05:600c:4f87:b0:493:f140:c3fb with SMTP id 5b1f17b1804b1-499821cf33bmr18826625e9.7.1786587058232;
        Wed, 12 Aug 2026 19:10:58 -0700 (PDT)
Received: from [192.168.0.50] (93-159-28-168.cgnat.inetia.pl. [93.159.28.168])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4815a5af4b2sm1968989f8f.17.2026.08.12.19.10.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Aug 2026 19:10:57 -0700 (PDT)
Message-ID: <50609ef0-6534-4e5f-8377-cc954e513c5a@gmail.com>
Date: Thu, 13 Aug 2026 04:10:56 +0200
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v2] net/sched: taprio: enforce minimum software
 scheduling interval
To: syzbot <syzbot@kernel.org>, syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
References: <d54f0bbd-ed4d-42bc-8a37-3268d9b3ebb8@mail.kernel.org>
Content-Language: en-US
From: Uladzislau Zhauniarovich <uladzislau.zhauniarovich@gmail.com>
In-Reply-To: <d54f0bbd-ed4d-42bc-8a37-3268d9b3ebb8@mail.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

#syz upstream

On 22/07/2026 20:32, syzbot wrote:
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
>   <IRQ>
>   lock_is_held include/linux/lockdep.h:249 [inline]
>   enqueue_hrtimer+0x79/0x2c0 kernel/time/hrtimer.c:1107
>   __run_hrtimer kernel/time/hrtimer.c:1946 [inline]
>   __hrtimer_run_queues+0x4ce/0xa10 kernel/time/hrtimer.c:1994
>   hrtimer_interrupt+0x448/0x910 kernel/time/hrtimer.c:2113
>   local_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1050 [inline]
>   __sysvec_apic_timer_interrupt+0x102/0x430 arch/x86/kernel/apic/apic.c:1067
>   instr_sysvec_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1061
>   [inline]
>   sysvec_apic_timer_interrupt+0xa1/0xc0 arch/x86/kernel/apic/apic.c:1061
>   </IRQ>
>
> To fix this, enforce a hard absolute minimum interval of 100 microseconds
> (TAPRIO_MIN_SW_INTERVAL_NS) for software-based scheduling, which provides
> enough margin over the timer service cost. Fully offloaded schedules are
> unaffected since they do not rely on the CPU's hrtimer. Introduce a helper
> taprio_min_interval() to consolidate the minimum interval logic for both
> individual schedule entries and the overall cycle_time validation.
>
> Fixes: b5b73b26b3ca ("taprio: Fix allowing too small intervals")
> Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot
> Reported-by: syzbot+19d01f6082ec61dd45b2@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=19d01f6082ec61dd45b2
> Link: https://syzkaller.appspot.com/ai_job?id=37f064ee-e021-43aa-8cfc-9f2a5a7c35d7
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
> - Increased the minimum software scheduling interval from 1us to 100us to cover the timer service cost.
> - Explained how virtual devices (veth, bonding) bypass the link-speed validation.
> - Clarified that fully offloaded schedules are unaffected.
> - Refactored the minimum interval check into a new taprio_min_interval() helper.
>
> v1:
> https://lore.kernel.org/all/be92b2ea-2bf9-4d7f-a833-de781ee804c8@mail.kernel.org/T/
> ---
> diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
> index 45245157e..2bf4cae16 100644
> --- a/net/sched/sch_taprio.c
> +++ b/net/sched/sch_taprio.c
> @@ -49,6 +49,13 @@ static struct static_key_false taprio_have_working_mqprio;
>    */
>   #define TAPRIO_PICOS_PER_BYTE_MIN 17
>   
> +/* The software scheduler cannot sustain hrtimer intervals smaller than
> + * this without livelocking the CPU. The value must exceed the cost of
> + * one advance_sched() invocation (lock acquisition, budget recomputation,
> + * TX softirq) with margin.
> + */
> +#define TAPRIO_MIN_SW_INTERVAL_NS (100 * NSEC_PER_USEC)
> +
>   struct sched_entry {
>   	/* Durations between this GCL entry and the GCL entry where the
>   	 * respective traffic class gate closes
> @@ -259,6 +266,16 @@ static int length_to_duration(struct taprio_sched *q, int len)
>   	return div_u64(len * atomic64_read(&q->picos_per_byte), PSEC_PER_NSEC);
>   }
>   
> +static int taprio_min_interval(struct taprio_sched *q)
> +{
> +	int min_duration = length_to_duration(q, ETH_ZLEN);
> +
> +	if (!FULL_OFFLOAD_IS_ENABLED(q->flags))
> +		min_duration = max_t(int, min_duration, TAPRIO_MIN_SW_INTERVAL_NS);
> +
> +	return min_duration;
> +}
> +
>   static int duration_to_length(struct taprio_sched *q, u64 duration)
>   {
>   	return div_u64(duration * PSEC_PER_NSEC, atomic64_read(&q->picos_per_byte));
> @@ -1038,7 +1055,7 @@ static int fill_sched_entry(struct taprio_sched *q, struct nlattr **tb,
>   			    struct sched_entry *entry,
>   			    struct netlink_ext_ack *extack)
>   {
> -	int min_duration = length_to_duration(q, ETH_ZLEN);
> +	int min_duration = taprio_min_interval(q);
>   	u32 interval = 0;
>   
>   	if (tb[TCA_TAPRIO_SCHED_ENTRY_CMD])
> @@ -1054,7 +1071,8 @@ static int fill_sched_entry(struct taprio_sched *q, struct nlattr **tb,
>   			tb[TCA_TAPRIO_SCHED_ENTRY_INTERVAL]);
>   
>   	/* The interval should allow at least the minimum ethernet
> -	 * frame to go out.
> +	 * frame to go out. When software scheduling is used, the
> +	 * interval must also be at least the minimum hrtimer interval.
>   	 */
>   	if (interval < min_duration) {
>   		NL_SET_ERR_MSG(extack, "Invalid interval for schedule entry");
> @@ -1166,7 +1184,7 @@ static int parse_taprio_schedule(struct taprio_sched *q, struct nlattr **tb,
>   		new->cycle_time = cycle;
>   	}
>   
> -	if (new->cycle_time < new->num_entries * length_to_duration(q, ETH_ZLEN)) {
> +	if (new->cycle_time < (s64)new->num_entries * taprio_min_interval(q)) {
>   		NL_SET_ERR_MSG(extack, "'cycle_time' is too small");
>   		return -EINVAL;
>   	}
>
>
> base-commit: 8cd9520d35a6c38db6567e97dd93b1f11f185dc6
