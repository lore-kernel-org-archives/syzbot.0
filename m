Received: from mail-ej2-f18.google.com (mail-ej2-f18.google.com [74.125.228.146])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9765417D86
	for <syzbot@lists.linux.dev>; Tue, 22 Sep 2026 08:39:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.146
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790066356; cv=none; b=MKMhOqsVDKf4ZoOIxRB1+dNReiSgpIRh/SZ8PuiaPy9Pe3FZeoIfTei26RozXaw/iX4NU0K9r0x4x+kzHQChOwdcqF8OK/gYctDcH2KYk7T9raNHdo0hkmB9NsiFI+hx9UN03he+JKlh2iXlw8f7MFsrDKfbDA/qNrbMlPdHfpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790066356; c=relaxed/simple;
	bh=9OgvRsRMPfcbzdViUJ3okXVlua19xzO47srIFR3HUhA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QTH01rYalZPootnjKQNYMC0d5eLrqPbwVDdKXpFu6dPVvccr9/dmm0yBkOR4XkbTT3nq3fLFZHdA75oyIgjX67mx0c66hwj+dXtD+2CZGj3TPFrBYkqh9+A/455cUgIeGeOu+jIRyKyrPrhm6WGqOgLGp540r2bYzFKiMVdY0+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BHPHmrRY; arc=none smtp.client-ip=74.125.228.146
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BHPHmrRY"
Received: by mail-ej2-f18.google.com with SMTP id a640c23a62f3a-c254fa65080so445583366b.3
        for <syzbot@lists.linux.dev>; Tue, 22 Sep 2026 01:39:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790066353; x=1790671153; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=u5Z9MrnFtWppOVarhFStUsl8SOpasc+2qQxdPQjV/wU=;
        b=BHPHmrRYPA14/5UZDB5sGBjxw1xsnpaCsFkzlqCswe/yrX0cCDBLQt/v3lpSuZ8OWr
         2dBhU6afjsZL43hw29ytVDf8ustIuFPa4etRtTOST+fj8l2wHajawraHcwKxsU7AT8mW
         wHvN6OdTlQyCLH3fV0dW4Ilay6sYZzYg6JNnG3sr1qZQSjumM6MoIWOj+BYZwcrkqj+P
         HJfp8bP+OvtQRZbDJvIt8VxFTFWjXBoWWdFGOe+yxch3eGNRHdHhNYq7TTP9KBSjauF6
         7dtDQLGU3bZI8CgLC/v9zllC+qFY3VL5d29p/SxyNA2fqEsVNFVexp7pzzeusPxJoEK8
         UA/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790066353; x=1790671153;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=u5Z9MrnFtWppOVarhFStUsl8SOpasc+2qQxdPQjV/wU=;
        b=YVylC/Yvk6lF7CTKN/mrjFWwCMveNuxpFu5JfubYNk7mntRn13dldpkmV1iHG2CKOO
         KvJ3Et8ePMxkOl5EqIah3J+acInnuqGLr9bLb646SCkV0Cqpe4XxqgYk/QATfu3g612W
         /m4R14KFb7vOckaQIwRIblFbWHfV9SIngfChKjRqfs087ISfagx44nBmlVob5QgS3Msr
         q6OeW+c3F76kkHD4lKXUbaU5JjfPkvp9K/bKNxNF3UzqdbzL7jFDOQVX/oY3MzmZ/st6
         rr5mXWOJjyVNi/RyBp14iucivc/84NmpFnwFAEMIDRkUMv2d5PBefR/fv1380iMwEjhK
         7+pQ==
X-Gm-Message-State: AFuF++lvj6v+wIBXzwyFEoAF1DZFzCbhzzV7wLEkIYtRoccrxh9gK6jL
	RvAf/wBpfS6oh8+F4Wz3O/PwJ3T9naguvEgX99JT6c7Bzyiwg+lk6sT32BbigZA1BF8=
X-Gm-Gg: AYBFou0pjcABp6eKko9rQuXvO+W6jQqYRxDPBc1HXSyjaGMU/R13NilQ5cMUUOHyOvc
	ohGLPOLUuUcrII/w1nE6Xdn7zw2KyJKPveT0h2Y8yMfOx5hyUeWT1teM51FWeolyRKwjAX9EA+W
	p1BJORcRJMtyjGFgSPjKeia8U8en+uB/MCDOwG7eCnBOC6X/tTVeLweBpa2ZYSSDuH7P267SnoI
	IPu/ltXoOeobehXbsy8eXuy/PlcktjVwiVB1Y/XMWgs8UjNT8f8uLdV8ubNMuWQUK9s4NY7hXye
	V9b15vD1kzqKDCouv9Xsti2FWtz0s82L98uHgK2W3MIZiE+ZaLVapkpyI+yEn1JDwO98+w0um66
	h875e132ruGBjPmD85Nmj9c99IiUpKfnHhVT3Pus6bnbUEZRxxddJHp7Hg4AoNJD0IUec9k24NK
	VlnM4qBqS94jjSCrQyw1WspZwn46UyruEXEDYakoPKv5mJqSa1ZDOUjndMKMTgMkom3u/0Qm1Rb
	CqgGRGTasVSmweWB8a/YQf1aYzpK9C4aOMeGag1zoL3/d2MZltDzqCpir0b9U5kCVRnK0B7ujpH
	7rA+9SUJ9BiDhvCTTV1aNVrmsFfkTTgBxOq/00kXOBY7c1/fw5ipNnVMUyz1qJg/BAYCxsm9MY5
	MPFLlAP2B+ipuASQ1YWsfAeHw6gMQA4RanfXqNx0rC6XPaA==
X-Received: by 2002:a17:907:3cd4:b0:c29:d33e:9ba3 with SMTP id a640c23a62f3a-c2a156492fbmr1067481866b.6.1790066352883;
        Tue, 22 Sep 2026 01:39:12 -0700 (PDT)
Received: from [192.168.100.51] (87-205-15-91.static.ip.netia.com.pl. [87.205.15.91])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c2a9c5ec614sm47475666b.45.2026.09.22.01.39.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Sep 2026 01:39:12 -0700 (PDT)
Message-ID: <84bfb90c-e32a-4649-99e5-a7a5ab1f93e9@gmail.com>
Date: Tue, 22 Sep 2026 10:39:10 +0200
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v4] net/sched: taprio: enforce minimum interval to
 prevent hrtimer storms
To: syzbot <syzbot@kernel.org>, syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
References: <955ce7e5-3e6d-4d4a-bbce-8033da4ffb3f@mail.kernel.org>
Content-Language: en-US
From: Krystian Kaniewski <krystianmkaniewski@gmail.com>
In-Reply-To: <955ce7e5-3e6d-4d4a-bbce-8033da4ffb3f@mail.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/22/2026 12:44 AM, syzbot wrote:
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
> Link: https://syzkaller.appspot.com/ai_job?id=d1e28442-a465-49a7-bd30-dbc3a9c3f631
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
> v4:
> - Clamp first->end_time to sched->cycle_end_time in setup_first_end_time().
> - In parse_taprio_schedule(), allow cycle_time shorter than the total schedule duration while ensuring the truncated interval is at least TAPRIO_MIN_INTERVAL.
> 
> v3:
> - Switch advance_timer to HRTIMER_MODE_ABS_SOFT in taprio_init(), taprio_change(), and taprio_start_sched()
> - In parse_taprio_schedule(), validate that cycle_time is not less than the sum of entry intervals in timer-driven mode
> https://lore.kernel.org/all/6f795e5c-0c42-4ff3-b8f3-de5cffb73045@mail.kernel.org/T/
> 
> v2:
> - Increased the minimum interval floor (TAPRIO_MIN_INTERVAL) from 1 us to 100 us.
> - Restricted the minimum interval constraint to software timer-driven mode via a new taprio_is_timer_driven() helper.
> - Used taprio_is_timer_driven() helper in taprio_start_sched() and taprio_change().
> - Clarified in the commit message that the threshold represents a nominal callback-rate policy rather than an absolute safety guarantee.
> https://lore.kernel.org/all/4de7b2e3-3f72-41a4-8735-67d91fc74009@mail.kernel.org/T/
> 
> v1:
> https://lore.kernel.org/all/7d5b3fcb-ab75-4a18-909f-5ff072e562e1@mail.kernel.org/T/
> ---
> diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
> index 299234a5f..912a66267 100644
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
> @@ -1166,9 +1183,29 @@ static int parse_taprio_schedule(struct taprio_sched *q, struct nlattr **tb,
>   		new->cycle_time = cycle;
>   	}
>   
> -	if (new->cycle_time < new->num_entries * length_to_duration(q, ETH_ZLEN)) {
> -		NL_SET_ERR_MSG(extack, "'cycle_time' is too small");
> -		return -EINVAL;
> +	if (taprio_is_timer_driven(q->flags)) {
> +		struct sched_entry *entry;
> +		ktime_t accum = 0;
> +
> +		list_for_each_entry(entry, &new->entries, list) {
> +			ktime_t next_accum = ktime_add_ns(accum, entry->interval);
> +
> +			if (ktime_compare(new->cycle_time, next_accum) <= 0) {
> +				ktime_t rem = ktime_sub(new->cycle_time, accum);
> +
> +				if (rem < TAPRIO_MIN_INTERVAL) {
> +					NL_SET_ERR_MSG(extack, "'cycle_time' is too small");
> +					return -EINVAL;
> +				}
> +				break;
> +			}
> +			accum = next_accum;
> +		}
> +	} else {
> +		if (new->cycle_time < new->num_entries * length_to_duration(q, ETH_ZLEN)) {
> +			NL_SET_ERR_MSG(extack, "'cycle_time' is too small");
> +			return -EINVAL;
> +		}
>   	}
>   
>   	taprio_calculate_gate_durations(q, new);
> @@ -1256,6 +1293,7 @@ static void setup_first_end_time(struct taprio_sched *q,
>   	sched->cycle_end_time = ktime_add_ns(base, cycle);
>   
>   	first->end_time = ktime_add_ns(base, first->interval);
> +	first->end_time = min_t(ktime_t, first->end_time, sched->cycle_end_time);
>   	taprio_set_budgets(q, sched, first);
>   
>   	for (tc = 0; tc < num_tc; tc++) {
> @@ -1274,7 +1312,7 @@ static void taprio_start_sched(struct Qdisc *sch,
>   	struct taprio_sched *q = qdisc_priv(sch);
>   	ktime_t expires;
>   
> -	if (FULL_OFFLOAD_IS_ENABLED(q->flags))
> +	if (!taprio_is_timer_driven(q->flags))
>   		return;
>   
>   	expires = hrtimer_get_expires(&q->advance_timer);
> @@ -1287,7 +1325,7 @@ static void taprio_start_sched(struct Qdisc *sch,
>   	 */
>   	start = min_t(ktime_t, start, expires);
>   
> -	hrtimer_start(&q->advance_timer, start, HRTIMER_MODE_ABS);
> +	hrtimer_start(&q->advance_timer, start, HRTIMER_MODE_ABS_SOFT);
>   }
>   
>   static void taprio_set_picos_per_byte(struct net_device *dev,
> @@ -1946,10 +1984,9 @@ static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
>   			   nla_get_u32(tb[TCA_TAPRIO_ATTR_TXTIME_DELAY]));
>   	}
>   
> -	if (!TXTIME_ASSIST_IS_ENABLED(q->flags) &&
> -	    !FULL_OFFLOAD_IS_ENABLED(q->flags) &&
> +	if (taprio_is_timer_driven(q->flags) &&
>   	    !hrtimer_active(&q->advance_timer)) {
> -		hrtimer_setup(&q->advance_timer, advance_sched, q->clockid, HRTIMER_MODE_ABS);
> +		hrtimer_setup(&q->advance_timer, advance_sched, q->clockid, HRTIMER_MODE_ABS_SOFT);
>   	}
>   
>   	err = taprio_get_start_time(sch, new_admin, &start);
> @@ -2072,7 +2109,7 @@ static int taprio_init(struct Qdisc *sch, struct nlattr *opt,
>   
>   	spin_lock_init(&q->current_entry_lock);
>   
> -	hrtimer_setup(&q->advance_timer, advance_sched, CLOCK_TAI, HRTIMER_MODE_ABS);
> +	hrtimer_setup(&q->advance_timer, advance_sched, CLOCK_TAI, HRTIMER_MODE_ABS_SOFT);
>   
>   	q->root = sch;
>   
> 
> 
> base-commit: a13c140cc289c0b7b3770bce5b3ad42ab35074aa

Please make the software taprio timer advance to a current schedule 
phase when its callback runs after one or more deadlines. The 100 us 
admission floor rejects the reported 127 ns configuration, but a delayed 
callback can still add one interval to an old absolute end time and 
return an already expired hrtimer deadline. A soft hrtimer can replay 
those overdue events, so changing timer context alone does not establish 
progress. Bound missed-deadline processing without replaying each 
elapsed entry. Preserve correct gate state, cycle-phase origin when 
cycle time differs from the sum of entries, trailing-gap behavior, and 
pending administrative schedule boundaries. In particular, do not 
overwrite the expiry of a timer that another path may have rearmed after 
the callback releases its schedule lock, and do not let a retry margin 
postpone an earlier administrative boundary.

Keep the useful mode scoping and effective-interval handling if the 100 
us nominal admission policy remains. Preserve txtime-assist and 
full-offload acceptance, existing cleanup and cancellation behavior, and 
the intended error order. Avoid broad timer-context changes unless they 
are needed by the corrected design and justified in the message.

Please also shorten the commit message to the confirmed problem, cause, 
and actual fix in two or three concise paragraphs. Remove the full stack 
trace whose provenance is not established by the supplied crash report, 
repeated timing arguments, and any claim that the admission floor alone 
guarantees safety. Keep valid tags and the existing provenance 
disclosure. Do not claim tests that have not been performed. Place any 
revision history below the email separator rather than in the commit 
message.

