Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795171070;
	b=CDKdtkeWlEvORqZAOsHetbZat5RsdapKuN1wcULMDO5mKds6UcCz46LNoUMPid7vIBiR
	 Ktlatw9Nl0u0X6VJFKpAS5+mVZSrOTlWoBHDzyooE/lQzxD3IqwwwH5p6RufETdgk4fk+
	 8FG/QwFqC/Sjql+6T9vgAkYQdEKvG1GKVYTrBXoXJSqILxfawJd2IwpjrBHMsViJPO/ZQ
	 sOBhM/1mv4Wr2V4IhCTCqMLU6nMSzgVesnMpkTvMfbWVumzBqJTVBypAUn0TFYy8MtQ0I
	 zBa85eN5D/KA9Mdes81XCP9FmjzgR6yrTb3lyqv1UZFKszpZZRM2jLGI7rta84m2D7w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795171070;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=mYw2ogrGQhOXBwDSvnflv518LkSQFznW99A+WOjpuOY=;
	b=1dF9I0X6UK7SC6Y8XokzH5ApiZgIokz3zyl+rT6JQNxUApz54wU+1RRgV60ifelsOQic
	 Ezro2mzCAeb4OUnUW51Aj++GoZKdYjcw/juHw+uDD//5mrYhQ1/gpEjRvC3qGG7rpaBBC
	 vdejwPlGZ3Ei3sSnT/8ivMhyMQj5TKsd4pbZY/h9J66S8E7u3IGGpXl8nfV8tEvs8howa
	 UH6Te44m05W+L1jx/Z3ZtvY6ETjvADyoL6Mho0TkGrHgFQsLSLlr9lL+IePNyLK0pfc6x
	 3XjWJnh9VYRhbDwoYjxJS9EbGyxTi1hUEKV92KHImbi38YNru3ODkTTAyJd2PBzolbg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=foHPMekB;
	arc=none smtp.remote-ip=209.85.218.41
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE7C6606A320
	for <syzbot@lists.linux.dev>; Fri, 20 Nov 2026 10:37:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BE7C6606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=foHPMekB
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-c5133831027so109156266b.2
        for <syzbot@lists.linux.dev>; Fri, 20 Nov 2026 02:37:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795171068; x=1795775868; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=mYw2ogrGQhOXBwDSvnflv518LkSQFznW99A+WOjpuOY=;
        b=foHPMekBy4P5slwV+ndRZ0M/TO9st+uWBZD/oid5GoF2vICkYwwt5n/3B5+qh5oPHg
         MdDO/olvLGUtbfcrMqiwevLP5TM/JxmdbTsnGVqTekGWdpTV3YnB8Puui6kKT1YbSM76
         CyFd6hX1s7FtaHWUMOxMj9Xvf79CyFAy/aH5brpXtUtIYKBB2Ply0lTMU9U9B4IbND0X
         EB6CVs7nwOsKTTUHGfIrtztP44WAb1rNhqQXULIXskleTjr9VVMQd53QgHK0CwCCeuc5
         Dc+/cXNpmS0bMBTOeBP2a2+ABXHAj3bN1HAYeZW9EnJcbxgZz8nSK4veN+9m5sFeXNZn
         PGFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795171068; x=1795775868;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mYw2ogrGQhOXBwDSvnflv518LkSQFznW99A+WOjpuOY=;
        b=h4Qk6IcrJZgwd1Hrkn1qD+W19IAJUE6E/eg3uHwBW0BatQPCVDc0Lg6ojTq6aph9QP
         bcvrb+YTn0bLI8Eik+Mga2E/VvM6duv5sqWIzTauTByWSqhrRJQGGx0QkRtnbx8LJ7cV
         fHzKqeN0v1jjFuBLo2RgNFRxO9fM8YkjshVIPYXXIa8HwfFD0hkHAsfzx5RzlfUhyVcV
         bZErGULiXfiyTw7cE9Dahp3Gg5wgA2pFUjhnopl/XyIkxmvrZ/m1LyKpZhZ6NtM4CBje
         oHlFerhblLKxqT2Kh1Lr5VJyj7kXDSIIgDzjlbrNDQj8mzGYvYn4t6pc+C3bRoAPMrB4
         8bTw==
X-Forwarded-Encrypted: i=1; AL+hErGiW0nbfHAnkkfsb0xNgqgHh1z3AV1Y6Xz7mABu0tRS7x985dA9vBZ1t6kGnoY7j2NL1qfTVYQ=@lists.linux.dev
X-Gm-Message-State: APuU4Z8mMimuLMrdbusyu7LbLmveKjfjutDVnDxmZmX20xaF9gluEC93
	X4QJyUt64IjzbpbvyTfj1cekS6Lj3c4G4lRr9+3j7hC/b+7+vyFJ9sYtQlTU+CRZ
X-Gm-Gg: AYBFou17C3dvPnEHdHuFuwH5cFwl/Mxm+L1Erf4WnrOvZ8oU6ugFEWdhucPV3CfZTFD
	SjwyJg7kiKCQgixxNHatc/Gr+wwvtnRBttEA7yEAM5lYUpDEJxd6xNd6H0VjqCsTqFPNjmwYO0F
	UnlG1LWCABxJSaHc8O0wRtV5AyNweiW8aVEoJNzok+BjEQpIATv2t/O1ByewWoIX9I7KqrUuU+m
	Y+P/9z6E+P3EecoRSU/u09hTi+01cA3ome6KURGaRNKVkJF/4TqLgHNYQV1puTmufC3vuXOXfSD
	Ptrw87+YKI4fD/hRGtkruISzpX7eROSjWchCX0pE2VSQ141NCIH8xIdSD6ieo1mUYxAaQdRWaW/
	jODTyZ6Q4v2Q3rZdcS3NQ8AJIa4g1/xkiokHF9DBd7Wckrhf4Fb96ti7/s4Zqc6H/J58IlU13OP
	iJM9BsciVM7Un04750GYeUYyeUk45Ry03sBhTZrSRrDoLuENtXdR7Hee022lcU+3T7kvUq3DUE0
	/56HpA5f4xfpqIbLrzSH6Q3FO9ciXCwR58av+ccAhvQ6/xwsuil6IWlZCV7FQuE7Iwzx/kyMz7C
	ivle4WRsI3rZnKQOtUe/YVo7tKnYrie6lmj90YwBQ0/nty4nyKIj+LZ2xA==
X-Received: by 2002:a17:907:c08:b0:c46:88ef:2e46 with SMTP id a640c23a62f3a-c513a433bf6mr293850466b.1.1795171067838;
        Fri, 20 Nov 2026 02:37:47 -0800 (PST)
Received: from localhost ([188.146.52.102])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c513afed51asm81649266b.76.2026.11.20.02.37.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2026 02:37:47 -0800 (PST)
Date: Fri, 20 Nov 2026 11:37:46 +0100
From: Bartosz Chronowski <immersa.bartosz.chronowski@gmail.com>
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Subject: Re: [PATCH RFC v7] net/sched: taprio: catch up overdue cycles in
 advance_sched()
Message-ID: <2h5pnhhxgnzikicis7iwgd3kzo5cbvuhtyjydioth7dljp7sxt@yspbsmb4yha7>
References: <02b82ad9-cb50-40a5-aab9-75d8754ccf24@mail.kernel.org>
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Post: <mailto:syzbot@lists.linux.dev>
List-Help: <mailto:syzbot+help@lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
List-Owner: <mailto:syzbot+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <02b82ad9-cb50-40a5-aab9-75d8754ccf24@mail.kernel.org>

V7 fixes the finite-budget and timer-rearm defects reported in the sent v6
review, but its gate deadline is still wrong for an explicit cycle. The
matched run had no crashes in 4 patched test VMs over 270 seconds; a
deterministic gate check fails, so this patch still needs code changes.

Required changes:
- Commit message: Keep the conditional wording about the now + 1 ns clamp.
  After fixing the code, explain the effective gate deadline and budget
  under an explicit cycle, and state what happens at timer saturation.
- Code: In advance_sched() and setup_first_end_time(), set gate_close_time
  and finite packet budgets from each traffic class's actual continuous-open
  window after an explicit cycle extends or truncates an entry. Keep v7's
  adjacent-open accounting.
- Code: Check signed start-time, cycle, and deadline arithmetic for
  admitted base values. Give timer saturation an outcome that makes progress;
  KTIME_MAX is not a future expiry when now is already KTIME_MAX.

Kind Regards
BART CHRONOWSKI

On Fri, Oct 23, 2026 at 02:42:14PM +0000, syzbot wrote:
> The taprio qdisc allows configuring small intervals which can overwhelm the
> CPU when using software timers. When the interval is shorter than the time
> it takes to process the timer interrupt, or when the system experiences
> scheduling delays, the timer expiration falls into the past. This
> overdue-absolute-deadline condition causes the hrtimer subsystem to
> repeatedly re-enqueue and fire the timer, resulting in an interrupt storm
> that starves CPU tasks and triggers RCU stalls:
> 
> rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:
> 	1-...!: (1 GPs behind) idle=5b64/0/0x1 softirq=135954/135971 fqs=1
> Call Trace:
>  <IRQ>
>  advance_sched+0xc2/0xc80 net/sched/sch_taprio.c:930
>  __run_hrtimer kernel/time/hrtimer.c:2032 [inline]
>  __hrtimer_run_queues+0x3bc/0xa10 kernel/time/hrtimer.c:2096
>  hrtimer_interrupt+0x448/0x910 kernel/time/hrtimer.c:2215
>  local_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1051 [inline]
>  __sysvec_apic_timer_interrupt+0x102/0x430 arch/x86/kernel/apic/apic.c:1068
>  sysvec_apic_timer_interrupt+0xa1/0xc0 arch/x86/kernel/apic/apic.c:1062
>  </IRQ>
> 
> Fix this by implementing bounded catch-up in advance_sched() instead of
> rejecting small intervals at admission time. When advance_sched() detects
> that the timer expiration is overdue, complete schedule periods are skipped
> arithmetically by advancing oper->cycle_end_time by the elapsed number of
> full cycles without exceeding any pending admin schedule base time or
> overflowing KTIME_MAX. Overdue entries within the cycle are then traversed
> in a loop bounded by oper->num_entries to catch up to the active entry. If
> the resulting expiration is still not in the future, it is clamped to at
> least one nanosecond ahead of the current time (unless current time reaches
> KTIME_MAX) to avoid arming the timer in the past. Additionally, convert
> entry budgets to 64-bit to prevent overflow.
> 
> Fixes: 5a781ccbd19e ("tc: Add support for configuring the taprio scheduler")
> Assisted-by: Gemini:gemini-4-argon Gemini:gemini-3.8-flash syzbot
> Reported-by: syzbot+f8850bc3986562f79619@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=f8850bc3986562f79619
> Link: https://syzkaller.appspot.com/ai_job?id=5784960f-675f-4072-a65f-84b8c08cd573
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
> v7:
> - Narrow the commit description claim about timer expiration guarantees to reflect that overdue expirations are clamped to now + 1 ns unless now reaches KTIME_MAX.
> - Add overflow protection when calculating skipped cycles and cycle_end_time near KTIME_MAX.
> - Introduce taprio_admin_switch_time() helper to safely compute admin schedule switch boundaries with underflow checks.
> - Switch entry budgets to atomic64_t to prevent overflow with large intervals.
> - Re-arm the advance timer via hrtimer_start() returning HRTIMER_NORESTART.
> - Drop the duration parameter from taprio_set_budgets().
> 
> v6:
> - Account for cycle_time_extension when calculating cycle catch-up before an admin schedule switch.
> - Restart catch-up loop after switching to an admin schedule in advance_sched().
> - Update taprio_set_budgets() and gate close times to use actual entry duration and gate mask.
> - Avoid resetting current_entry in setup_first_end_time() when configuring an admin schedule.
> https://lore.kernel.org/all/0423fb98-9248-4f3a-88d2-6e8fe89c26ea@mail.kernel.org/T/
> 
> v5:
> - Drop cycle_interval_sum and do not modify parse_taprio_schedule().
> - Avoid skipping past pending admin schedule base time during cycle catch-up.
> - Advance overdue entries within the cycle using a loop bounded by oper->num_entries.
> - Clamp timer expiration to at least now + 1 ns if still overdue.
> - Fix should_restart_cycle() to check for end_time >= cycle_end_time.
> - Handle cycle_end_time capping for the first entry in setup_first_end_time().
> https://lore.kernel.org/all/2fcb3fdb-42b4-4a7a-bf17-3b5a422bfa75@mail.kernel.org/T/
> 
> v4:
> - Replace admission-time interval rejection with bounded catch-up in advance_sched().
> - Arithmetically advance overdue full periods instead of walking individual entries.
> - Record cycle_interval_sum in parse_taprio_schedule() to determine the cycle period.
> - Set timer expiration before releasing current_entry_lock.
> https://lore.kernel.org/all/a75dd710-09c2-4dce-bc7b-65fd6c4be4d8@mail.kernel.org/T/
> 
> v3:
> - Reject intervals smaller than 100 us at admission time for software TAPRIO schedules instead of modifying advance_sched().
> - Drop catch-up cycle arithmetic, loop iteration limits, and physical expiration fallbacks from advance_sched().
> https://lore.kernel.org/all/ecbfe945-f1ab-45de-aaa0-b9b57ae730c2@mail.kernel.org/T/
> 
> v2:
> - Removed the 1 microsecond admission policy for software taprio.
> - Reduced the loop iteration limit from 2048 to 32 to avoid softirq stalls.
> - Added handling for administrative schedules during fast-forwarding to avoid overshooting `admin->base_time`.
> - Split logical schedule deadline (`end_time`) and physical timer expiration (`expires`).
> - Updated the fallback mechanism to request a physical expiration 1 microsecond in the future relative to the current time rather than yielding the CPU.
> - Optimized gate close time calculation to only run once after the loop if not already calculated.
> https://lore.kernel.org/all/03dbde3b-8c45-46b6-8291-dd12bcc3120c@mail.kernel.org/T/
> 
> v1:
> https://lore.kernel.org/all/bc6a8890-9230-489a-bbce-5c255c1ef01a@mail.kernel.org/T/
> ---
> diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
> index 299234a5f..21b4ee705 100644
> --- a/net/sched/sch_taprio.c
> +++ b/net/sched/sch_taprio.c
> @@ -54,7 +54,7 @@ struct sched_entry {
>  	 * respective traffic class gate closes
>  	 */
>  	u64 gate_duration[TC_MAX_QUEUE];
> -	atomic_t budget[TC_MAX_QUEUE];
> +	atomic64_t budget[TC_MAX_QUEUE];
>  	/* The qdisc makes some effort so that no packet leaves
>  	 * after this time
>  	 */
> @@ -665,39 +665,43 @@ static void taprio_set_budgets(struct taprio_sched *q,
>  {
>  	struct net_device *dev = qdisc_dev(q->root);
>  	int num_tc = netdev_get_num_tc(dev);
> -	int tc, budget;
> +	s64 budget;
> +	int tc;
>  
>  	for (tc = 0; tc < num_tc; tc++) {
>  		/* Traffic classes which never close have infinite budget */
>  		if (entry->gate_duration[tc] == sched->cycle_time)
> -			budget = INT_MAX;
> +			budget = S64_MAX;
>  		else
> -			budget = div64_u64((u64)entry->gate_duration[tc] * PSEC_PER_NSEC,
> -					   atomic64_read(&q->picos_per_byte));
> +			budget = min_t(u64,
> +				       div64_u64((u64)entry->gate_duration[tc] * PSEC_PER_NSEC,
> +						 atomic64_read(&q->picos_per_byte)),
> +				       S64_MAX - 1);
>  
> -		atomic_set(&entry->budget[tc], budget);
> +		atomic64_set(&entry->budget[tc], budget);
>  	}
>  }
>  
>  /* When an skb is sent, it consumes from the budget of all traffic classes */
> -static int taprio_update_budgets(struct sched_entry *entry, size_t len,
> +static s64 taprio_update_budgets(struct sched_entry *entry, size_t len,
>  				 int tc_consumed, int num_tc)
>  {
> -	int tc, budget, new_budget = 0;
> +	s64 budget, new_budget = 0;
> +	int tc;
>  
>  	for (tc = 0; tc < num_tc; tc++) {
> -		budget = atomic_read(&entry->budget[tc]);
> +		budget = atomic64_read(&entry->budget[tc]);
>  		/* Don't consume from infinite budget */
> -		if (budget == INT_MAX) {
> +		if (budget == S64_MAX) {
>  			if (tc == tc_consumed)
>  				new_budget = budget;
>  			continue;
>  		}
>  
>  		if (tc == tc_consumed)
> -			new_budget = atomic_sub_return(len, &entry->budget[tc]);
> +			new_budget = atomic64_sub_return(len, &entry->budget[tc]);
>  		else
> -			atomic_sub(len, &entry->budget[tc]);
> +			atomic64_sub(len, &entry->budget[tc]);
>  	}
>  
>  	return new_budget;
> @@ -875,44 +879,35 @@ static bool should_restart_cycle(const struct sched_gate_list *oper,
>  	if (list_is_last(&entry->list, &oper->entries))
>  		return true;
>  
> -	if (ktime_compare(entry->end_time, oper->cycle_end_time) == 0)
> +	if (ktime_compare(entry->end_time, oper->cycle_end_time) >= 0)
>  		return true;
>  
>  	return false;
>  }
>  
> +static ktime_t taprio_admin_switch_time(const struct sched_gate_list *admin,
> +					const struct sched_gate_list *oper)
> +{
> +	ktime_t base = sched_base_time(admin);
> +
> +	if (oper->cycle_time_extension <= 0)
> +		return base;
> +
> +	if (base < S64_MIN + oper->cycle_time_extension)
> +		return S64_MIN;
> +
> +	return ktime_sub_ns(base, oper->cycle_time_extension);
> +}
> +
>  static bool should_change_schedules(const struct sched_gate_list *admin,
>  				    const struct sched_gate_list *oper,
>  				    ktime_t end_time)
>  {
> -	ktime_t next_base_time, extension_time;
> -
>  	if (!admin)
>  		return false;
>  
> -	next_base_time = sched_base_time(admin);
> -
> -	/* This is the simple case, the end_time would fall after
> -	 * the next schedule base_time.
> -	 */
> -	if (ktime_compare(next_base_time, end_time) <= 0)
> -		return true;
> -
> -	/* This is the cycle_time_extension case, if the end_time
> -	 * plus the amount that can be extended would fall after the
> -	 * next schedule base_time, we can extend the current schedule
> -	 * for that amount.
> -	 */
> -	extension_time = ktime_add_ns(end_time, oper->cycle_time_extension);
> -
> -	/* FIXME: the IEEE 802.1Q-2018 Specification isn't clear about
> -	 * how precisely the extension should be made. So after
> -	 * conformance testing, this logic may change.
> -	 */
> -	if (ktime_compare(next_base_time, extension_time) <= 0)
> -		return true;
> -
> -	return false;
> +	return ktime_compare(taprio_admin_switch_time(admin, oper),
> +			     end_time) <= 0;
>  }
>  
>  static enum hrtimer_restart advance_sched(struct hrtimer *timer)
> @@ -924,8 +919,9 @@ static enum hrtimer_restart advance_sched(struct hrtimer *timer)
>  	int num_tc = netdev_get_num_tc(dev);
>  	struct sched_entry *entry, *next;
>  	struct Qdisc *sch = q->root;
> -	ktime_t end_time;
> -	int tc;
> +	ktime_t start_time, end_time, expires, now;
> +	s64 duration;
> +	int tc, i;
>  
>  	spin_lock(&q->current_entry_lock);
>  	entry = rcu_dereference_protected(q->current_entry,
> @@ -938,62 +934,121 @@ static enum hrtimer_restart advance_sched(struct hrtimer *timer)
>  	if (!oper)
>  		switch_schedules(q, &admin, &oper);
>  
> -	/* This can happen in two cases: 1. this is the very first run
> -	 * of this function (i.e. we weren't running any schedule
> -	 * previously); 2. The previous schedule just ended. The first
> -	 * entry of all schedules are pre-calculated during the
> -	 * schedule initialization.
> -	 */
> -	if (unlikely(!entry || entry->end_time == oper->base_time)) {
> -		next = list_first_entry(&oper->entries, struct sched_entry,
> -					list);
> -		end_time = next->end_time;
> -		goto first_run;
> -	}
> +	now = hrtimer_cb_get_time(timer);
> +
> +	if (entry && entry->end_time == oper->base_time)
> +		entry = NULL;
>  
> -	if (should_restart_cycle(oper, entry)) {
> -		next = list_first_entry(&oper->entries, struct sched_entry,
> -					list);
> -		oper->cycle_end_time = ktime_add_ns(oper->cycle_end_time,
> +catch_up:
> +	if (!entry && !oper->cycle_end_time)
> +		oper->cycle_end_time = ktime_add_ns(oper->base_time,
>  						    oper->cycle_time);
> -	} else {
> -		next = list_next_entry(entry, list);
> +
> +	if (oper->cycle_time > 0 &&
> +	    ktime_compare(now, oper->cycle_end_time) >= 0) {
> +		u64 diff = (u64)now - (u64)oper->cycle_end_time;
> +		u64 cycles = div64_u64(diff, oper->cycle_time) + 1;
> +		u64 max_cycles = div64_u64((u64)KTIME_MAX -
> +					   (u64)oper->cycle_end_time,
> +					   oper->cycle_time);
> +
> +		if (admin) {
> +			ktime_t admin_target = taprio_admin_switch_time(admin,
> +									oper);
> +
> +			if (ktime_compare(admin_target,
> +					  oper->cycle_end_time) <= 0) {
> +				cycles = 0;
> +			} else {
> +				u64 admin_diff = (u64)admin_target -
> +						 (u64)oper->cycle_end_time;
> +				u64 admin_cycles = div64_u64(admin_diff - 1,
> +							     oper->cycle_time) + 1;
> +
> +				cycles = min(cycles, admin_cycles);
> +			}
> +		}
> +
> +		if (cycles > max_cycles) {
> +			cycles = max_cycles;
> +			entry = NULL;
> +		}
> +
> +		if (cycles > 0) {
> +			oper->cycle_end_time = (ktime_t)((u64)oper->cycle_end_time +
> +							 cycles * (u64)oper->cycle_time);
> +			entry = NULL;
> +		}
>  	}
>  
> -	end_time = ktime_add_ns(entry->end_time, next->interval);
> -	end_time = min_t(ktime_t, end_time, oper->cycle_end_time);
> +	if (entry && should_restart_cycle(oper, entry) &&
> +	    oper->cycle_end_time > KTIME_MAX - oper->cycle_time)
> +		entry = NULL;
> +
> +	for (i = 0; i < oper->num_entries; i++) {
> +		if (!entry) {
> +			next = list_first_entry(&oper->entries, struct sched_entry,
> +						list);
> +			start_time = ktime_sub_ns(oper->cycle_end_time,
> +						  oper->cycle_time);
> +		} else if (should_restart_cycle(oper, entry)) {
> +			if (oper->cycle_end_time >
> +			    KTIME_MAX - oper->cycle_time)
> +				break;
> +			start_time = entry->end_time;
> +			next = list_first_entry(&oper->entries,
> +						struct sched_entry, list);
> +			oper->cycle_end_time = ktime_add_ns(oper->cycle_end_time,
> +							    oper->cycle_time);
> +		} else {
> +			start_time = entry->end_time;
> +			next = list_next_entry(entry, list);
> +		}
> +
> +		if (list_is_last(&next->list, &oper->entries))
> +			duration = ktime_sub_ns(oper->cycle_end_time, start_time);
> +		else
> +			duration = min_t(s64, next->interval,
> +					 ktime_sub_ns(oper->cycle_end_time, start_time));
> +
> +		end_time = ktime_add_ns(start_time, duration);
> +
> +		if (should_change_schedules(admin, oper, end_time)) {
> +			switch_schedules(q, &admin, &oper);
> +			entry = NULL;
> +			goto catch_up;
> +		}
> +
> +		if (ktime_after(end_time, now))
> +			break;
> +
> +		entry = next;
> +		entry->end_time = end_time;
> +	}
>  
>  	for (tc = 0; tc < num_tc; tc++) {
>  		if (next->gate_duration[tc] == oper->cycle_time)
>  			next->gate_close_time[tc] = KTIME_MAX;
>  		else
> -			next->gate_close_time[tc] = ktime_add_ns(entry->end_time,
> +			next->gate_close_time[tc] = ktime_add_ns(start_time,
>  								 next->gate_duration[tc]);
>  	}
>  
> -	if (should_change_schedules(admin, oper, end_time)) {
> -		switch_schedules(q, &admin, &oper);
> -		/* After changing schedules, the next entry is the first one
> -		 * in the new schedule, with a pre-calculated end_time.
> -		 */
> -		next = list_first_entry(&oper->entries, struct sched_entry, list);
> -		end_time = next->end_time;
> -	}
> -
>  	next->end_time = end_time;
>  	taprio_set_budgets(q, oper, next);
>  
> -first_run:
>  	rcu_assign_pointer(q->current_entry, next);
> +	expires = end_time;
> +	if (unlikely(ktime_compare(expires, now) <= 0))
> +		expires = (now == KTIME_MAX) ? KTIME_MAX : ktime_add_ns(now, 1);
> +	hrtimer_start(&q->advance_timer, expires, HRTIMER_MODE_ABS);
>  	spin_unlock(&q->current_entry_lock);
>  
> -	hrtimer_set_expires(&q->advance_timer, end_time);
> -
>  	rcu_read_lock();
>  	__netif_schedule(sch);
>  	rcu_read_unlock();
>  
> -	return HRTIMER_RESTART;
> +	return HRTIMER_NORESTART;
>  }
>  
>  static const struct nla_policy entry_policy[TCA_TAPRIO_SCHED_ENTRY_MAX + 1] = {
> @@ -1244,6 +1299,7 @@ static void setup_first_end_time(struct taprio_sched *q,
>  	struct net_device *dev = qdisc_dev(q->root);
>  	int num_tc = netdev_get_num_tc(dev);
>  	struct sched_entry *first;
> +	s64 duration;
>  	ktime_t cycle;
>  	int tc;
>  
> @@ -1255,7 +1311,12 @@ static void setup_first_end_time(struct taprio_sched *q,
>  	/* FIXME: find a better place to do this */
>  	sched->cycle_end_time = ktime_add_ns(base, cycle);
>  
> -	first->end_time = ktime_add_ns(base, first->interval);
> +	if (list_is_last(&first->list, &sched->entries))
> +		duration = cycle;
> +	else
> +		duration = min_t(s64, first->interval, cycle);
> +
> +	first->end_time = ktime_add_ns(base, duration);
>  	taprio_set_budgets(q, sched, first);
>  
>  	for (tc = 0; tc < num_tc; tc++) {
> @@ -1265,7 +1326,9 @@ static void setup_first_end_time(struct taprio_sched *q,
>  			first->gate_close_time[tc] = ktime_add_ns(base, first->gate_duration[tc]);
>  	}
>  
> -	rcu_assign_pointer(q->current_entry, NULL);
> +	if (!rcu_access_pointer(q->oper_sched) ||
> +	    rcu_access_pointer(q->oper_sched) == sched)
> +		rcu_assign_pointer(q->current_entry, NULL);
>  }
>  
>  static void taprio_start_sched(struct Qdisc *sch,
> 
> 
> base-commit: 8cdeaa50eae8dad34885515f62559ee83e7e8dda
> -- 
> This is an AI-generated patch subject to moderation.
> Reply with '#syz upstream' to Sign-off the patch as a human author
> and send it to the upstream kernel mailing lists.
> Reply with '#syz reject' to reject it ('#syz unreject' to undo).
> 
> See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
> You can comment on the patch as usual, syzbot will try to address
> the comments and send a new version of the patch if necessary.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
