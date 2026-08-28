Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C2B138DC4C
	for <syzbot@lists.linux.dev>; Fri, 28 Aug 2026 10:09:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787911746; cv=none; b=RWrtny2Njku/wcqIKa4Q2NnZA9sXoDgW5akeDtUkP4n4l6vSJ+YOHVIIwrg2bYEUQfWlKCuKMbqpVNRgmXW+ChJWFKxlpVv88g9qNduVdu5N++Nnf5e0OJUexNblUe2YFtwVs8kG4nklW40rYFGW2PdGJES+jGIoj6gBqFkq7OE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787911746; c=relaxed/simple;
	bh=xL7YYuu9RvXrsvs2W7eczOfOns2d3Q8IUD0YfLXGbuM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ct0bGzkfmGeGgMA28HSqvSOk2cPQsqmJxDDYUWFsiKI7qRATEjDDY0McM2Li2FniryHW+b5me62+hN83saGgrE5+VTi3X3F73tR8wQVaZB+SSmzZ4Hrk3jhWgnWEug/mmGl7Lsq5bfw1cbQPmMGEiKax0kGO8LJjYWUQHMocVTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FD5HhfZ0; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FD5HhfZ0"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-49b392ccaacso9196135e9.2
        for <syzbot@lists.linux.dev>; Fri, 28 Aug 2026 03:09:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787911742; x=1788516542; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=5X9za0VGlVlksHwtcUzPmaCWN1skzqk/M16EtFf3ee4=;
        b=FD5HhfZ0mno1qAdz/ukq2bfWdoFGa4r+Svv2KW8GYzh2t8jIgSm3hRLhyDsQSyiLOo
         Fk/uFYoa7vEg0hrBwWGic+m1JfoGHzhGmCzulu+l0dWPhkumrXzLwqXN5w1Li4rQhxQb
         +k2+Bj4MmrIKLSwxzLpY7sg+/2X20Fi/Uwm+U41/82GUKophMLotA/2jQii2XWHGZK0W
         PZYGcsj9hroJhghwo3BFwWLjlWvpCXPMm1C+s5L1dZ3XYxH8XXXGSzW0chYKgCXsBTUt
         pvnBaRGRKTH4pwhwUKZFXF4Fqp8Rt/m2i2GfB20w/VCUjeBnFS3rNVjgcpXv7TkIjYg1
         A6Gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787911742; x=1788516542;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5X9za0VGlVlksHwtcUzPmaCWN1skzqk/M16EtFf3ee4=;
        b=Tlskw3sjViW5/hcwwfqaLQW6dQupDsqnbAaBzX9qxvgUOBnRlMXbhFBbAVqBe5Ox1+
         IzVcFrfknK8Ibr0nOZyUcOhcKuw0OMLWkrl86DGjRT9pcHHuHiZYpxWXq3GRWRJnmi99
         pLVSvQh6YvTmbWfaWh2FwUIa/XEoSh8fQPHtcRu/bRKjY25oihelgwzgGXdAGeIYn1so
         edRHMXlMUmX1Vyd3xCyyS/KfqfHY35F6mKhFPkU087YMUeKMODNy5IJwpNfNUE2UM/aL
         PiFCpltelZVCERnq48tBYITWwgbx2zsB/+HNwTbY/9WEbgZfzUQAVTvcEybzICWbUCi7
         ZBQw==
X-Forwarded-Encrypted: i=1; AHgh+RoZebaq25PN0sG2eP9tPwdfw7kzwSP5i7j1BBGqv/4GO91B4iF5LxuOT0+5LTwyEva0Y8zamYU=@lists.linux.dev
X-Gm-Message-State: AFuF++kgXbbd7SkwdMZfEenJr8p1BXL0R78MBXZYgeEyR6FLK3XlubD0
	Jja3mnV3jZAfc3u6HB365O86fLjEAnj0jub0MIlAqwnssy14iHzP/b2X
X-Gm-Gg: AR+sD13fN41KetZcIARmOxb2kQMsxAN7PiFigQrsTDFsjzmaUWsyoVhZXddDWi4hzqk
	Om9nzJbL4a42Xa2jx9vHMLlxfkUoIDj64soIPQZjKrmhY9de9F9Cv/aQYSNGPCOepQprcH9j+vI
	kRus7p3j9pKAriNnd4k/lrA8YfUbm9DAAMlLUnPQPrMxgeAkZv08i06i74NKftYk5rfoQ2b4vKE
	2vZk6aF0o6YRRnEXFdsFDVXXV8tpecykSa1s1wWAyZg7Nh/mZcrwX3FmyKMJ87//7zq9GRgewzj
	M27wBBu2hQxWRNgOdGhPHBnhQLcaDt5M6C0UDvtvsBiCHFiR4eM6+r4rITbKpyRcAIgjcYg06ST
	jtjzi+5N+zPgGhP1l/lQTuc+1wmpL1nbuvYQPjDhHDz4Ih1BMC1rYUTFq12svbM+VCswlxpLL7b
	kprAbjzJowTEkoNbuqSqpFdr0seCQ1R8uwCh37q8gedGLAaauW8xMG6YrL6uNCm3KTZ2DeRMA37
	9WhBy531wm+uQ==
X-Received: by 2002:a05:600c:a48:b0:499:9eb8:a1d7 with SMTP id 5b1f17b1804b1-49b91c3b7b6mr65542375e9.9.1787911742009;
        Fri, 28 Aug 2026 03:09:02 -0700 (PDT)
Received: from localhost ([37.30.36.217])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49b926874fdsm48287885e9.4.2026.08.28.03.09.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Aug 2026 03:09:01 -0700 (PDT)
Date: Fri, 28 Aug 2026 12:09:00 +0200
From: Bartosz Chronowski <immersa.bartosz.chronowski@gmail.com>
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Subject: Re: [PATCH RFC v2] net/sched: taprio: fix hrtimer interrupt storm on
 small intervals
Message-ID: <2dl74h4x7efhcxc3okpxaac6md3i6lwoocbtzgad6o7dyfzbsi@w7xkcno6jybx>
References: <03dbde3b-8c45-46b6-8291-dd12bcc3120c@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <03dbde3b-8c45-46b6-8291-dd12bcc3120c@mail.kernel.org>

V2 addresses the v1 requests to bound catch-up work and account for a pending
administrative schedule, and its exact-base runtime pair suppresses the
selected stall. It is still not the right fix. The deterministic schedule
cases show that its catch-up arithmetic double-advances cycle wrap, skips the
residual entry, promotes an administrative schedule early, delays a finite
one-entry gate close, and can publish an overdue phase. The patch is not ready
with those blocking regressions.

The fix should be at schedule admission instead. A pure-software TAPRIO
schedule advances its gate list from the self-rearming advance_timer. The
current link-speed-derived minimum can admit the reproducer's 255 ns entry on
stacked virtual devices, although advance_sched() cannot service that rate.
The absolute deadline then remains overdue and the hardirq callback
immediately replays, starving RCU.

Replace the v2 advance_sched() changes with the following minimal validation
change in net/sched/sch_taprio.c:

1. Add a helper that returns the existing length_to_duration(q, ETH_ZLEN)
minimum for TXTIME_ASSIST and full-offload schedules.

2. For schedules driven by advance_timer, return the greater of that existing
minimum and 100 * NSEC_PER_USEC.

3. Use the helper in fill_sched_entry() and in the complete-cycle check in
parse_taprio_schedule(). Cast num_entries to s64 before the multiplication.

4. Leave advance_sched() unchanged.

5. Keep the description's explanation that the too-small interval leaves the
absolute deadline overdue and starves the CPU. Rewrite the fix description
around admission-time rejection, and remove the v2 claims about catch-up,
deadline splitting, the 32-iteration bound, and late physical expiration.

That scope matters. TXTIME_ASSIST and full offload do not advance the GCL with
this timer, so their accepted timing range should not be reduced. The 255 ns
pure-software input should be rejected with -EINVAL; it should not remain
accepted merely to exercise a new late-schedule recovery path.

An admission-boundary candidate completed a full Clang/LLVM build, changed the
exact reproducer from 4/4 crashes to 0/4, rejected the 255 ns software
schedule with -EINVAL, and accepted a 100 us software schedule.
Keep the existing Fixes tag and recipient set, and include equivalent
admission-boundary and exact-reproducer checks with the next revision.

On Fri, Jul 24, 2026 at 08:21:30PM +0000, syzbot wrote:
> The taprio qdisc allows configuring extremely small intervals (e.g., 255
> ns) which can completely overwhelm the CPU when using software timers. When
> the interval is smaller than the time it takes to process the timer
> interrupt, the timer's expiration time is always in the past. This causes
> the hrtimer subsystem to continuously re-enqueue and fire the timer,
> leading to an interrupt storm that starves the CPU and triggers an RCU
> stall. While a 255 ns interval triggers this, the underlying issue is the
> overdue-absolute-deadline invariant where the timer is repeatedly scheduled
> in the past.
> 
> To fix this, we split the logical schedule deadline (`end_time`) from the
> physical timer expiration (`expires`). In `advance_sched()`, we
> fast-forward the schedule to the current time by skipping full cycles using
> division, taking care not to overshoot the administrative schedule's base
> time (`admin->base_time`). To prevent softirq stalls, we bound the state
> work by capping the schedule advancement loop to 32 iterations. If we reach
> this limit and the logical deadline is still in the past, we fall back to
> requesting a later physical expiration relative to the timer queue's saved
> comparison time, rather than yielding the CPU. This ensures the physical
> timer queue can make progress.
> 
> Fixes: 5a781ccbd19e ("tc: Add support for configuring the taprio scheduler")
> Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot
> Reported-by: syzbot+f8850bc3986562f79619@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=f8850bc3986562f79619
> Link: https://syzkaller.appspot.com/ai_job?id=9ef6c8de-8e92-44a9-b075-955697b790a6
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
> - Removed the 1 microsecond admission policy for software taprio.
> - Reduced the loop iteration limit from 2048 to 32 to avoid softirq stalls.
> - Added handling for administrative schedules during fast-forwarding to avoid overshooting `admin->base_time`.
> - Split logical schedule deadline (`end_time`) and physical timer expiration (`expires`).
> - Updated the fallback mechanism to request a physical expiration 1 microsecond in the future relative to the current time rather than yielding the CPU.
> - Optimized gate close time calculation to only run once after the loop if not already calculated.
> 
> v1:
> https://lore.kernel.org/all/bc6a8890-9230-489a-bbce-5c255c1ef01a@mail.kernel.org/T/
> ---
> diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
> index 299234a5f..8e8be568d 100644
> --- a/net/sched/sch_taprio.c
> +++ b/net/sched/sch_taprio.c
> @@ -920,11 +920,16 @@ static enum hrtimer_restart advance_sched(struct hrtimer *timer)
>  	struct taprio_sched *q = container_of(timer, struct taprio_sched,
>  					      advance_timer);
>  	struct net_device *dev = qdisc_dev(q->root);
> +	bool gate_close_time_calculated = false;
>  	struct sched_gate_list *oper, *admin;
>  	int num_tc = netdev_get_num_tc(dev);
> +	ktime_t now = taprio_get_time(q);
>  	struct sched_entry *entry, *next;
>  	struct Qdisc *sch = q->root;
> +	/* Small retry bound to avoid softirq stall */
> +	int max_iter = 32;
>  	ktime_t end_time;
> +	ktime_t expires;
>  	int tc;
>  
>  	spin_lock(&q->current_entry_lock);
> @@ -948,46 +953,86 @@ static enum hrtimer_restart advance_sched(struct hrtimer *timer)
>  		next = list_first_entry(&oper->entries, struct sched_entry,
>  					list);
>  		end_time = next->end_time;
> -		goto first_run;
> +		gate_close_time_calculated = true;
> +		if (ktime_after(end_time, now))
> +			goto first_run;
> +		entry = next;
>  	}
>  
> -	if (should_restart_cycle(oper, entry)) {
> -		next = list_first_entry(&oper->entries, struct sched_entry,
> -					list);
> -		oper->cycle_end_time = ktime_add_ns(oper->cycle_end_time,
> -						    oper->cycle_time);
> -	} else {
> -		next = list_next_entry(entry, list);
> -	}
> +	do {
> +		ktime_t limit = now;
>  
> -	end_time = ktime_add_ns(entry->end_time, next->interval);
> -	end_time = min_t(ktime_t, end_time, oper->cycle_end_time);
> +		if (admin && ktime_before(admin->base_time, limit))
> +			limit = admin->base_time;
>  
> -	for (tc = 0; tc < num_tc; tc++) {
> -		if (next->gate_duration[tc] == oper->cycle_time)
> -			next->gate_close_time[tc] = KTIME_MAX;
> -		else
> -			next->gate_close_time[tc] = ktime_add_ns(entry->end_time,
> -								 next->gate_duration[tc]);
> -	}
> +		if (oper->cycle_time && ktime_after(limit, oper->cycle_end_time)) {
> +			s64 diff = ktime_sub(limit, oper->cycle_end_time);
> +			s64 cycles = div64_s64(diff, oper->cycle_time) + 1;
>  
> -	if (should_change_schedules(admin, oper, end_time)) {
> -		switch_schedules(q, &admin, &oper);
> -		/* After changing schedules, the next entry is the first one
> -		 * in the new schedule, with a pre-calculated end_time.
> -		 */
> -		next = list_first_entry(&oper->entries, struct sched_entry, list);
> -		end_time = next->end_time;
> +			oper->cycle_end_time =
> +				ktime_add_ns(oper->cycle_end_time,
> +					     cycles * oper->cycle_time);
> +			entry->end_time = ktime_add_ns(entry->end_time,
> +						       cycles * oper->cycle_time);
> +		}
> +
> +		if (should_restart_cycle(oper, entry)) {
> +			next = list_first_entry(&oper->entries,
> +						struct sched_entry, list);
> +			oper->cycle_end_time =
> +				ktime_add_ns(oper->cycle_end_time,
> +					     oper->cycle_time);
> +		} else {
> +			next = list_next_entry(entry, list);
> +		}
> +
> +		end_time = ktime_add_ns(entry->end_time, next->interval);
> +		end_time = min_t(ktime_t, end_time, oper->cycle_end_time);
> +
> +		if (should_change_schedules(admin, oper, end_time)) {
> +			switch_schedules(q, &admin, &oper);
> +			/* After changing schedules, the next entry is the first one
> +			 * in the new schedule, with a pre-calculated end_time.
> +			 */
> +			next = list_first_entry(&oper->entries,
> +						struct sched_entry, list);
> +			end_time = next->end_time;
> +			gate_close_time_calculated = true;
> +		} else {
> +			gate_close_time_calculated = false;
> +		}
> +
> +		next->end_time = end_time;
> +
> +		if (ktime_after(end_time, now))
> +			break;
> +
> +		entry = next;
> +	} while (--max_iter > 0);
> +
> +	if (!gate_close_time_calculated) {
> +		for (tc = 0; tc < num_tc; tc++) {
> +			if (next->gate_duration[tc] == oper->cycle_time) {
> +				next->gate_close_time[tc] = KTIME_MAX;
> +			} else {
> +				next->gate_close_time[tc] =
> +					ktime_add_ns(entry->end_time,
> +						     next->gate_duration[tc]);
> +			}
> +		}
>  	}
>  
> -	next->end_time = end_time;
>  	taprio_set_budgets(q, oper, next);
>  
>  first_run:
>  	rcu_assign_pointer(q->current_entry, next);
>  	spin_unlock(&q->current_entry_lock);
>  
> -	hrtimer_set_expires(&q->advance_timer, end_time);
> +	expires = end_time;
> +	if (unlikely(max_iter == 0 && ktime_before(expires, now)))
> +		expires = ktime_add_ns(now, NSEC_PER_USEC);
> +
> +	hrtimer_set_expires(&q->advance_timer, expires);
>  
>  	rcu_read_lock();
>  	__netif_schedule(sch);
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
