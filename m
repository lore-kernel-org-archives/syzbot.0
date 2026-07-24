Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FEED361656
	for <syzbot@lists.linux.dev>; Fri, 24 Jul 2026 18:19:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784917154; cv=none; b=g//qvBbKFFNUqlgm7Vjl5sPEjzEPedWpEyc+ysq+vtwstHBW4nPSU3xnsMtyP7kWmVyEBVxhIMMSPcmgopQCpR4zRZCKBriCEivD2SP7zd4YjQ7K/JcdMye8WbJhuRznYLWCmxQ2fHyxvf8fkOQsE6aD1MO728+qwnJ1zipVXFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784917154; c=relaxed/simple;
	bh=VtGcqaBIlWKJrdEmcPy7YVveR8BZ1OvpqTa/JJnjhkI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=V2SHvt9/9V0LCP46EOyy8Q7EcbZxtvU4X+Bg2wiWCxKeWISy3Ui9ruXavZnk6qoxAq00Qy0lDdvkFP5k2CTBaqoHb+9xJr0vrG+8PlRMuUzhNIP9hHUYW/XXuc0YhiTF0sN7dD76/nY6q935MgnALuOsw/drvVzufjBD377Bmnw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Uajt8nM5; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Uajt8nM5"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4954dff6536so5511655e9.0
        for <syzbot@lists.linux.dev>; Fri, 24 Jul 2026 11:19:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784917151; x=1785521951; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=8KaD05WZyiD3P7ZaqeK2hKWmnWSxsGirg2dVnC5B0gY=;
        b=Uajt8nM5+zWpZHxxBCn8kbH2Lx9BL2XtHMZoDi1IYmUFN8RWp3If4+9WvkBfwfRUiI
         QcuqOHK3nq12NC9T38QnMi5dFaXyrnnidWJHBNOijegYIDuOTHEEuoO8DQ0UlDskgine
         ZlUUdRyoeGzpCfNXXOsPJrpuAyNcZ4PKU+GV/akddPG/R5dsItdBb4TImCGVFfFE/o3Z
         PI8ME2gckTMkOAQ/gGle2rLvHcRYFIiTWzyGv1nO7Mq6qw/N/0C8jQH5bnYoS4KANquM
         pGVGZn+xwtR6JrauSYq0KkD+2NcxoZmv+cwecnMW2yKZ2TlLVE4VUq8PlUVaZvaPgtNP
         Vsug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784917151; x=1785521951;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8KaD05WZyiD3P7ZaqeK2hKWmnWSxsGirg2dVnC5B0gY=;
        b=i4awXGYCJMsrb99YIBh8GRZx2Jsk3cfY5WaYm1C0NolM09jH0fSLcf9NiyV3e4XIYe
         a7H3CRz56ktlPI1w2ZxXgW5uGgFB+ImNTa5Oyvx4ekMCpBxOiTb5Pn04pf2bco/ETs1o
         dmMTrmlCGgKoOsPapqFszWGCImjBUxd2p2cwCas+K0O+AptevlthU1QSdia0OsxFP9qI
         CQEgtaXX75tPnkt0uG70bFwyo4w5911iLtuCvFD7KzgnXMCg4u+LL/KJNsCYgwbzg+SU
         bvtKPpt3j1zmnI44FNbw7b//7NMwXUx8y4wndmrINNdWbsBa/7MerhNloWRlsvpeB+qG
         krvg==
X-Forwarded-Encrypted: i=1; AHgh+RpA2z6wbLtPpcz7692CYHcR9KHKl2+NrnsUw7G1Fa3bFEVGRm2pLyGLIzgbFIaSqtju2t27bJo=@lists.linux.dev
X-Gm-Message-State: AOJu0YyPLR07f9lY59upo/RfcTJo/YTqGESWOODFJe4sD5znCVAn1UQL
	tPclLXqlhsqtMW7V5HmToMDVJ5UdT1aRn33+EypuG60ALPvq+/oXghCY
X-Gm-Gg: AR+sD10j+ZLLDSdFPTI2DmAi8nGAZeMZa3qlk/rvlRkIE8fM7CdEumvWTCWzlWMObvT
	6aKt5pBQ2BoCocSxw9gyzZbxF7KHLbqpoVAr6aYMAiXOEvXZulons29NJZhvgzeVBBEVZKlukKW
	jsgUWKKBg+2HA3DnOd5uGoQkQb2MTANh+5o25Wgy3aLlwMVxTSdcm87D/Z+MlnXv+lJYiwKwO1a
	qGX43p6b2VmZa0w+k+j0uKB1qaQJfUC8AkczzZIuoKfdU0A9nazZateixl899MMSDlftWz96YNM
	plocp8WRkfUt7dDfjmGYet/WKRzF9iS0xr/olPd7c+CFrGYP0MMj/s2WANHNMHz899YAuEC2uAC
	7YvM78nac4iMeC5rc8LizSDweEBvP/Oo66k5BZdU48JvT2NvkAfczz28nycnxdEFhjPnCnTMdAe
	0hyhzNsYORZ0z/enwcTOMfGMRrfhCa
X-Received: by 2002:a05:600c:6d83:b0:492:6447:7a7f with SMTP id 5b1f17b1804b1-49573cbf8ccmr60092745e9.6.1784917150445;
        Fri, 24 Jul 2026 11:19:10 -0700 (PDT)
Received: from localhost ([37.30.44.117])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4957bfc2ff2sm59436875e9.4.2026.07.24.11.19.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jul 2026 11:19:10 -0700 (PDT)
Date: Fri, 24 Jul 2026 20:19:09 +0200
From: Bartosz Chronowski <immersa.bartosz.chronowski@gmail.com>
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Subject: Re: [PATCH RFC] net/sched: taprio: fix hrtimer interrupt storm on
 small intervals
Message-ID: <bww2koc7edy644if3re575zlrfxfk545jxj5ghwhg6kzd6pa5l@2qdzo6zgu72y>
References: <bc6a8890-9230-489a-bbce-5c255c1ef01a@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bc6a8890-9230-489a-bbce-5c255c1ef01a@mail.kernel.org>

The v1 patch identifies the correct causal function, and arithmetic catch-up in
advance_sched() is the right direction. The exact-base accepted-1000-ns test
pair supports that mechanism: the unpatched kernel reproduced the timer/RCU
stall class on 4/4 machines, while the patched kernel produced no crash on
4/4 machines. However, the exact 255 ns no-repro is not evidence for catch-up,
because the new parser check rejects that input before the timer path runs.
The patch is not ready: the parser floor has the wrong scope, the capped path
performs too much repeated state work in hardirq context, an overdue
administrative transition is not caught up arithmetically, and the description
overstates what the physical retry deadline guarantees.

Please address these points in the next version:

1. Remove the NSEC_PER_USEC admission checks from fill_sched_entry() and
parse_taprio_schedule(). They are not required to fix an overdue timer, reject
the exact reproducer before it exercises the catch-up path, and also reject
TXTIME-assist configurations even though that mode does not use
advance_sched(). The existing link-speed-based frame-duration validation
should remain unchanged.

2. Preserve two distinct time contracts. The logical deadline in the selected
schedule entry records where catch-up must resume. The physical hrtimer expiry
controls when the callback may run again. On every HRTIMER_RESTART return, the
physical expiry must be later than the hrtimer queue's saved comparison time
for the current run, so __hrtimer_run_queues() cannot replay the callback
indefinitely against one fixed time snapshot. A TAPRIO-clock sample taken
inside the callback, after the queue snapshot, plus a positive retry interval
can establish that ordering. It is not necessary to claim that the expiry
will still be in the future when the callback finally returns; time can pass
during callback work.

3. Keep the logical schedule state coherent independently of that physical
retry. The published current_entry, its logical end_time, finite
gate_close_time values, cycle_end_time, budgets, and the oper/admin identity
must describe the same logical schedule phase. If a bounded callback stops
before reaching current time, retain that logical deadline so the next
callback resumes from it; do not overwrite it with the synthetic physical
retry deadline. Arm the hrtimer with the separate physical expiry described
above and document this split explicitly.

4. Avoid replaying up to 2048 gate and per-TC budget transitions under
current_entry_lock. First skip complete operational cycles arithmetically only
up to the earlier of current time and a pending administrative base time.
When the administrative boundary is due, promote it once, then position the
new operational schedule arithmetically. Within the remaining cycle, locate
the selected entry without repeatedly publishing or recalculating budgets for
intermediate entries; update gate timing, budgets, and current_entry only for
the final logical state. If list traversal still needs a retry bound, make it
small and documented, retain the resumable logical state, and use the separate
physical retry contract from points 2 and 3.

5. Update the description accordingly. The fallback does not "yield the CPU";
it requests a later physical expiration relative to the timer queue's saved
comparison time. Describe the logical/physical deadline split, the bounded
state work, and administrative-schedule handling. Do not present a
one-microsecond admission policy as the causal fix. Keep the distinction
between the 255 ns trigger and the underlying overdue-absolute-deadline
invariant.

The existing Fixes tag and proposed upstream recipient set are reasonable.

Please include focused coverage for the following state and mode boundaries in
the revised version: the exact 255 ns input must remain accepted so the
catch-up path is exercised; a long-lived small-interval schedule must be
checked for CPU and hardirq behavior rather than only repeated short runs; an
actually overdue administrative schedule must be promoted and caught up;
multi-entry wrap must be covered; supported clock IDs and forward clock
movement must be exercised; TXTIME-assist acceptance and normal on-time
behavior must remain unchanged; and default and strict checkpatch must be
clean.

On Thu, Jul 09, 2026 at 12:33:55PM +0000, syzbot wrote:
> The taprio qdisc allows configuring extremely small intervals (e.g., 255
> ns) which are valid for hardware offload but completely overwhelm the CPU
> when using software timers. When the interval is smaller than the time it
> takes to process the timer interrupt, the timer's expiration time is always
> in the past. This causes the hrtimer subsystem to continuously re-enqueue
> and fire the timer, leading to an interrupt storm that starves the CPU and
> triggers an RCU stall:
> 
> rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:
> rcu: 	1-...!: (1 GPs behind) idle=9714/0/0x1 softirq=132447/132447 fqs=1
> rcu: 	(detected by 0, t=10505 jiffies, g=152477, q=510 ncpus=2)
> rcu: rcu_preempt kthread starved for 10501 jiffies! g152477 f0x0
> RCU_GP_WAIT_FQS(5) ->state=0x0 ->cpu=0
> rcu: 	Unless rcu_preempt kthread gets sufficient CPU time, OOM is now
> expected behavior.
> 
> To fix this, implement two strategies. First, enforce sensible minimums in
> software mode by rejecting intervals and cycle times smaller than
> NSEC_PER_USEC (1 microsecond) when hardware offload is not enabled. Second,
> prevent timer stalls in advance_sched() by fast-forwarding the schedule to
> the current time instead of blindly restarting the timer in the past. This
> is done efficiently by skipping full cycles using division, and then
> looping through the remaining entries. To prevent the loop itself from
> causing a stall, cap the iterations at 2048 and yield the CPU if necessary
> by setting the timer to fire 1 microsecond in the future.
> 
> Fixes: 5a781ccbd19e ("tc: Add support for configuring the taprio scheduler")
> Assisted-by: Gemini:gemini-3.1-pro-preview syzbot
> Reported-by: syzbot+f8850bc3986562f79619@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=f8850bc3986562f79619
> Link: https://syzkaller.appspot.com/ai_job?id=4e81d0c1-77be-4527-8698-9eadc019d766
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
> index 299234a5f..910de14c4 100644
> --- a/net/sched/sch_taprio.c
> +++ b/net/sched/sch_taprio.c
> @@ -944,46 +944,83 @@ static enum hrtimer_restart advance_sched(struct hrtimer *timer)
>  	 * entry of all schedules are pre-calculated during the
>  	 * schedule initialization.
>  	 */
> -	if (unlikely(!entry || entry->end_time == oper->base_time)) {
> -		next = list_first_entry(&oper->entries, struct sched_entry,
> -					list);
> -		end_time = next->end_time;
> -		goto first_run;
> -	}
> -
> -	if (should_restart_cycle(oper, entry)) {
> -		next = list_first_entry(&oper->entries, struct sched_entry,
> -					list);
> -		oper->cycle_end_time = ktime_add_ns(oper->cycle_end_time,
> -						    oper->cycle_time);
> -	} else {
> -		next = list_next_entry(entry, list);
> -	}
> +	int max_iter = 2048;
> +	ktime_t now = taprio_get_time(q);
>  
> -	end_time = ktime_add_ns(entry->end_time, next->interval);
> -	end_time = min_t(ktime_t, end_time, oper->cycle_end_time);
> +	do {
> +		if (unlikely(!entry || entry->end_time == oper->base_time)) {
> +			next = list_first_entry(&oper->entries,
> +						struct sched_entry, list);
> +			end_time = next->end_time;
> +			goto first_run;
> +		}
>  
> -	for (tc = 0; tc < num_tc; tc++) {
> -		if (next->gate_duration[tc] == oper->cycle_time)
> -			next->gate_close_time[tc] = KTIME_MAX;
> -		else
> -			next->gate_close_time[tc] = ktime_add_ns(entry->end_time,
> -								 next->gate_duration[tc]);
> -	}
> +		if (should_restart_cycle(oper, entry)) {
> +			next = list_first_entry(&oper->entries,
> +						struct sched_entry, list);
> +			oper->cycle_end_time = ktime_add_ns(
> +				oper->cycle_end_time, oper->cycle_time);
> +		} else {
> +			next = list_next_entry(entry, list);
> +		}
>  
> -	if (should_change_schedules(admin, oper, end_time)) {
> -		switch_schedules(q, &admin, &oper);
> -		/* After changing schedules, the next entry is the first one
> -		 * in the new schedule, with a pre-calculated end_time.
> -		 */
> -		next = list_first_entry(&oper->entries, struct sched_entry, list);
> -		end_time = next->end_time;
> -	}
> +		end_time = ktime_add_ns(entry->end_time, next->interval);
> +		end_time = min_t(ktime_t, end_time, oper->cycle_end_time);
> +
> +		for (tc = 0; tc < num_tc; tc++) {
> +			if (next->gate_duration[tc] == oper->cycle_time)
> +				next->gate_close_time[tc] = KTIME_MAX;
> +			else
> +				next->gate_close_time[tc] =
> +					ktime_add_ns(entry->end_time,
> +						     next->gate_duration[tc]);
> +		}
> +
> +		if (should_change_schedules(admin, oper, end_time)) {
> +			switch_schedules(q, &admin, &oper);
> +			/* After changing schedules, the next entry is the first one
> +			 * in the new schedule, with a pre-calculated end_time.
> +			 */
> +			next = list_first_entry(&oper->entries,
> +						struct sched_entry, list);
> +			end_time = next->end_time;
> +		}
>  
> -	next->end_time = end_time;
> -	taprio_set_budgets(q, oper, next);
> +		next->end_time = end_time;
> +		taprio_set_budgets(q, oper, next);
>  
>  first_run:
> +		if (ktime_after(end_time, now))
> +			break;
> +
> +		if (!admin && ktime_before(end_time, now)) {
> +			s64 diff = ktime_sub(now, end_time);
> +			s64 cycles = div64_s64(diff, oper->cycle_time);
> +			if (cycles > 0) {
> +				oper->cycle_end_time =
> +					ktime_add_ns(oper->cycle_end_time,
> +						     cycles * oper->cycle_time);
> +				end_time = ktime_add_ns(
> +					end_time, cycles * oper->cycle_time);
> +				next->end_time = end_time;
> +				for (tc = 0; tc < num_tc; tc++) {
> +					if (next->gate_close_time[tc] !=
> +					    KTIME_MAX)
> +						next->gate_close_time
> +							[tc] = ktime_add_ns(
> +							next->gate_close_time[tc],
> +							cycles *
> +								oper->cycle_time);
> +				}
> +			}
> +		}
> +
> +		entry = next;
> +	} while (--max_iter > 0);
> +
> +	if (max_iter == 0)
> +		end_time = ktime_add_ns(now, NSEC_PER_USEC);
> +
>  	rcu_assign_pointer(q->current_entry, next);
>  	spin_unlock(&q->current_entry_lock);
>  
> @@ -1061,6 +1098,13 @@ static int fill_sched_entry(struct taprio_sched *q, struct nlattr **tb,
>  		return -EINVAL;
>  	}
>  
> +	if (!FULL_OFFLOAD_IS_ENABLED(q->flags) && interval < NSEC_PER_USEC) {
> +		NL_SET_ERR_MSG(
> +			extack,
> +			"Invalid interval for software taprio, must be at least 1 us");
> +		return -EINVAL;
> +	}
> +
>  	entry->interval = interval;
>  
>  	return 0;
> @@ -1171,6 +1215,13 @@ static int parse_taprio_schedule(struct taprio_sched *q, struct nlattr **tb,
>  		return -EINVAL;
>  	}
>  
> +	if (!FULL_OFFLOAD_IS_ENABLED(q->flags) &&
> +	    new->cycle_time < NSEC_PER_USEC) {
> +		NL_SET_ERR_MSG(extack,
> +			       "'cycle_time' is too small for software taprio");
> +		return -EINVAL;
> +	}
> +
>  	taprio_calculate_gate_durations(q, new);
>  
>  	return 0;
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
