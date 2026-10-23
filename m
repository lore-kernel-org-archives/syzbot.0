Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792750321;
	b=WDV14Xoy5Ib596gq2N1tBvWPBeTfnxzfLMOKsMERWlSOh/Htc/TvoPO7Bc0xl3aIvH6U
	 tO8Luh6yqlPl8RjoSinzfyzyVQz3RGurdHfoLJr4GhiZpBmTdbZawQGFC9BfahBlsIB/c
	 mIVpxiZ7rv3pndp0WU97HGt6L8J91iq/VzD8MZ5F1+2jxHRlskU4TyqF2A641yvg86GMp
	 unu6D+phnk4hTOrXFPVnkt3a7sg474z5MfFA2a6KFqnwo+IO3Cv5mj6Hv4RR9yQWcf3XR
	 jgshoHYfyVBEZLXMYU7SCu4KPcuYNdfdFB+s1lrizEhtOIAt5ViaSWcg2HIUO6tyEiA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792750321;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:Content-Transfer-Encoding:
	 In-Reply-To;
	bh=FgsuC+U3U+MdU9082AI3Qwoc35+SWQh75F44+YGeH8o=;
	b=xuoeuQ7IkuNd+Ezt1shiwmGJRSRqbEK35wUU/ue3BPieGZuxX8CEinmFWqtiF9XSFpzp
	 kkYTGu2FoxEMwmwZvvXF58aXkIQBxZLaLoXUJd4tjdiqrhP5QPtwPdNa4HawgYd+00AsI
	 dmgFGYg+9ZpuPEG+Vt9oWn+5fa7s8/vB/0TB2eMl4jLB/JrQEbTaoN8GVXC7HP8lP7mHB
	 kJoaBmSOjPr1hGPQwW8PP6jAANrL0Vwip0+YSi31LljPEm/MsU2W3CFWLRbHZ4+xDjXNb
	 xZ9CU2WD+ic1vOrImVCnbH0N/DKMk16zQUvMmvFheILRfBZXQN9e6DnF1A98ptnB54Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=ji63++Da;
	arc=none smtp.remote-ip=209.85.218.50
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0BF5606A31B
	for <syzbot@lists.linux.dev>; Fri, 23 Oct 2026 10:12:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A0BF5606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=ji63++Da
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-c413dea9ca6so112257266b.2
        for <syzbot@lists.linux.dev>; Fri, 23 Oct 2026 03:12:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792750319; x=1793355119; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=FgsuC+U3U+MdU9082AI3Qwoc35+SWQh75F44+YGeH8o=;
        b=ji63++Da9pB16hzyWMPqMYsv9S50hjYYmiKAw7057AkZ/c4gdi8U6IVt5I+yCNWbRV
         4qTZFlrraF1Mi4DT4yr6c5PJzf6u5hOWgUGX8LqLfOc7QOaZk214vRSiTNLZAFg3zYP0
         0VAb0syOzL4/VilEZqXrX9nETgpb57DxvWxZK/98R4y9vnBJWIq5Qne9I0lw2vawW8lZ
         CVQjIwqWUXZUOmL/rp2tYbsMfv/wG6/2D71B+4OJf4Dvm5SlcMpM/FXBa3S+9/ICIUdl
         W2RZnxXn9JRex3VDJMTyMohemGVG4we0AXsG95n6r2bp4KlzogGq30uEQdCZ8zDzVqxR
         +oAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792750319; x=1793355119;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=FgsuC+U3U+MdU9082AI3Qwoc35+SWQh75F44+YGeH8o=;
        b=R+5PnEii2yqZHaNCycHVNQkussNyzRRYkC+WM5miVsH5HZ3Aha0FJCS/YEi78e4C0+
         v1u5EJNhKi1KOkwhiLaeiIk0+vK592p/JmALrYG+hpj58i7XLhD95k9XgycbxV20pg1f
         N/AxBQ8/6safJPnp8HcTZaRQon2ONd0VdTlCx8ra3reQb+gvWtbPMVvmdGhoydpl6sq6
         6p3u7ZJNYK5/ONNLP4r3yUZVcGqYpaFR14w8AKqUDgnh1BXgQrA+m6Hksa5ufSUh25Rx
         I4oVW5dnNqG6skmoHbG7peOc62bBKoXxIPoksEkM9cAf/0uOeXE78OvuAsyj2US3osMS
         m1jg==
X-Forwarded-Encrypted: i=1; AKwUvBxeOHgXphYMpFcifyPiKaS/NuTc0d95+vF9/l6Tz3hUz3INyGJ9QBSvAtOFt774suyDxWNYzSs=@lists.linux.dev
X-Gm-Message-State: AFq9FYLip2FRbZpDE21CbBZGUR6TJK6mKQ/L7eZlvJSHialRgoD7q+Nx
	D3mcehSVk5cQxp7egxCjalpSd3U+t+HfX6AmELbKjF8RuU+8UIt5U/jIZQRYkw==
X-Gm-Gg: AYBFou2rbqPPVmdVKpuK8Wq3lnXdQFkivOF+WJddSCQex/u2MWd2wdYLfb2IeBUcWnK
	Mufaa3S0ZPDTUR9rznMbJHu2YXuu5b2nhas3kYMrxp+WtQzan7rMwZwahvf3P50FKQ5RzE9U/tW
	X5n8RmyPpohPOacA7n9nQdJTiOBQJXe5zbamFpTDhTLeAT1Kfyia/FzEUB9WqrwQZ/eFsTKcgV+
	fMGjSaw6hyRmCj0C43PCkshS26C/hyjxJdiFeiXRa1ZmpowsXNSSCnpcob8xug/3m62Mt87g2g1
	fmCfLRcqgInSxQJkQ2pRcxAhw2agY6/FJIO8Fl1KvFAcPOcKSg6M+vGqFhyWlEF52bIOVzF0gjR
	Oj9lMI9zpq5NraffezsmvX9LKUJVtWK7fn1Pcps0eZ0PU11pSiPAhlOvZNWu4ONyyisFGG98ORk
	J4xvmzyUaSPHUH5rhfLL15A0/X5ymKTnIm27VIlqZ7KRX2quTQ/36bNZ2HplhvW21dzgDoUECH4
	NZeGDyTNJjVPV9SlHdL2xfZukJJ5lW+IHr556521APXzjQ5MRWBgx8bxzQp76rAQafaEg8n4Gxy
	V02V
X-Received: by 2002:a17:906:4fc7:b0:c41:30be:4f82 with SMTP id a640c23a62f3a-c46a94629a2mr256862966b.39.1792750318847;
        Fri, 23 Oct 2026 03:11:58 -0700 (PDT)
Received: from localhost ([37.30.48.34])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c46a5ceaf18sm86279266b.68.2026.10.23.03.11.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Oct 2026 03:11:58 -0700 (PDT)
Date: Fri, 23 Oct 2026 12:11:57 +0200
From: Bartosz Chronowski <immersa.bartosz.chronowski@gmail.com>
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Subject: Re: [PATCH RFC v6] net/sched: taprio: catch up overdue cycles in
 advance_sched()
Message-ID: <qmezih7uyc35e7mvs45jkaf5rpi3pvco6pt5rc3uizx2pv34eu@p2hm4rjhf74y>
References: <0423fb98-9248-4f3a-88d2-6e8fe89c26ea@mail.kernel.org>
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Post: <mailto:syzbot@lists.linux.dev>
List-Help: <mailto:syzbot+help@lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
List-Owner: <mailto:syzbot+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <0423fb98-9248-4f3a-88d2-6e8fe89c26ea@mail.kernel.org>

V6 retains bounded catch-up and improves selection after a delayed admin
switch, but its gate, budget and timer-rearm logic is still incorrect. It
builds and applies cleanly; deterministic schedule checks pass 15 of 19
cases and fail four blocking boundaries. A separate source review also
found a timer requeue interleaving. In the matched runtime run, the
unpatched kernel produced four alternative reports with no selected stall
signature; the patched kernel produced no crash. That comparison is
inconclusive for this report. The patch is not ready for upstream review.

On the v6 base, 8cdeaa50eae8, the relevant code is in
net/sched/sch_taprio.c. taprio_calculate_gate_durations() records the
continuous-open window of each traffic-class gate in gate_duration[tc].
Keep that window separate from an entry's effective end when
advance_sched() and setup_first_end_time() set gate_close_time[tc] and
call taprio_set_budgets(). With [open d, open d, closed d] in a 3d cycle,
the first entry ends at d but its gate remains open until 2d. V6 uses d
for its close time and budget, so taprio_entry_allows_tx() can reject a
packet that would finish during the second still-open entry. Preserve
the continuous-open close and budget semantics across entry and cycle
boundaries while retaining bounded catch-up.

Make finite budgets representable in taprio_set_budgets() and the
taprio_update_budgets() consumer. With one TC open for 50 ms and closed
for the next 50 ms, a 100 ms cycle at 20 ps per byte needs a finite
2,500,000,000-byte budget; v6 narrows it to signed int. Widen the
storage and debit operations, for example to atomic64_t, and keep the
never-close state distinct from any finite budget. Clamping to INT_MAX
is not a fix: taprio_update_budgets() treats it as infinite. Preserve
this accepted schedule rather than rejecting it to fit an int.

In advance_sched(), avoid the unchecked admin base-time minus
cycle_time_extension calculation: the parser accepts S64_MIN, for which
that subtraction overflows. Check the cycle/deadline calculations too.
The now + 1 fallback has no representable future expiry at S64_MAX;
handle that boundary explicitly instead of relying on signed wraparound.
Keep the same-callback convergence after a due admin switch.

Fix the timer requeue interleaving in advance_sched() and
taprio_start_sched(). Configuration can requeue a running timer while its
callback waits for current_entry_lock. The callback then changes the
expiry of an already queued timer with hrtimer_set_expires(), which does
not update its queue key; __run_hrtimer() also skips auto-enqueue when the
timer is queued. Reprogram through hrtimer_start() under the shared lock
and return HRTIMER_NORESTART, or use an equivalent queue-safe sequence.
Moving hrtimer_set_expires() under current_entry_lock alone is not enough.

The commit message already explains overdue deadlines and bounded
catch-up; narrow its unconditional future-expiry claim to what the code
can guarantee. The recipient list and Fixes: tag need no change on the
current evidence.

Rerun the cross-entry gate case, the finite 50 ms open-gate budget case,
signed admin and timer limits, short/equal/long cycles, due-admin
transitions, and the callback/configuration requeue ordering. Then
repeat the exact-configuration build and matched
unpatched/patched reproduction. The baseline must show the selected
signature before that comparison can support a claim about this stall.

Impact assessment: Overdue software TAPRIO timer work can starve CPU
and RCU progress. V6 can also reject transmissions on an accepted
continuous-open gate or through a negative packet budget. These are
availability failures; the current evidence does not establish another
protection-property impact.

Kind Regards / Mit freundlichen Gr=C3=BC=C3=9Fen
BART CHRONOWSKI

On Fri, Oct 16, 2026 at 12:54:39PM +0000, syzbot wrote:
> The taprio qdisc allows configuring small intervals which can overwhelm t=
he
> CPU when using software timers. When the interval is shorter than the time
> it takes to process the timer interrupt, or when the system experiences
> scheduling delays, the timer expiration falls into the past. This
> overdue-absolute-deadline condition causes the hrtimer subsystem to
> repeatedly re-enqueue and fire the timer, resulting in an interrupt storm
> that starves CPU tasks and triggers RCU stalls:
>=20
> rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:
> 	1-...!: (1 GPs behind) idle=3D5b64/0/0x1 softirq=3D135954/135971 fqs=3D1
> Call Trace:
>  <IRQ>
>  advance_sched+0xc2/0xc80 net/sched/sch_taprio.c:930
>  __run_hrtimer kernel/time/hrtimer.c:2032 [inline]
>  __hrtimer_run_queues+0x3bc/0xa10 kernel/time/hrtimer.c:2096
>  hrtimer_interrupt+0x448/0x910 kernel/time/hrtimer.c:2215
>  local_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1051 [inline]
>  __sysvec_apic_timer_interrupt+0x102/0x430 arch/x86/kernel/apic/apic.c:10=
68
>  sysvec_apic_timer_interrupt+0xa1/0xc0 arch/x86/kernel/apic/apic.c:1062
>  </IRQ>
>=20
> Fix this by implementing bounded catch-up in advance_sched() instead of
> rejecting small intervals at admission time. When advance_sched() detects
> that the timer expiration is overdue, complete schedule periods are skipp=
ed
> arithmetically by advancing oper->cycle_end_time by the elapsed number of
> full cycles without exceeding any pending admin schedule base time. Overd=
ue
> entries within the cycle are then traversed in a loop bounded by
> oper->num_entries to catch up to the active entry, and the next timer
> expiration is guaranteed to be in the future.
>=20
> Fixes: 5a781ccbd19e ("tc: Add support for configuring the taprio schedule=
r")
> Assisted-by: Gemini:gemini-4-argon Gemini:gemini-3.8-flash syzbot
> Reported-by: syzbot+f8850bc3986562f79619@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3Df8850bc3986562f79619
> Link: https://syzkaller.appspot.com/ai_job?id=3D02840ed1-7db5-4b0e-9a7f-c=
ec69d4d31e5
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
>=20
> ---
> v6:
> - Account for cycle_time_extension when calculating cycle catch-up before=
 an admin schedule switch.
> - Restart catch-up loop after switching to an admin schedule in advance_s=
ched().
> - Update taprio_set_budgets() and gate close times to use actual entry du=
ration and gate mask.
> - Avoid resetting current_entry in setup_first_end_time() when configurin=
g an admin schedule.
>=20
> v5:
> - Drop cycle_interval_sum and do not modify parse_taprio_schedule().
> - Avoid skipping past pending admin schedule base time during cycle catch=
-up.
> - Advance overdue entries within the cycle using a loop bounded by oper->=
num_entries.
> - Clamp timer expiration to at least now + 1 ns if still overdue.
> - Fix should_restart_cycle() to check for end_time >=3D cycle_end_time.
> - Handle cycle_end_time capping for the first entry in setup_first_end_ti=
me().
> https://lore.kernel.org/all/2fcb3fdb-42b4-4a7a-bf17-3b5a422bfa75@mail.ker=
nel.org/T/
>=20
> v4:
> - Replace admission-time interval rejection with bounded catch-up in adva=
nce_sched().
> - Arithmetically advance overdue full periods instead of walking individu=
al entries.
> - Record cycle_interval_sum in parse_taprio_schedule() to determine the c=
ycle period.
> - Set timer expiration before releasing current_entry_lock.
> https://lore.kernel.org/all/a75dd710-09c2-4dce-bc7b-65fd6c4be4d8@mail.ker=
nel.org/T/
>=20
> v3:
> - Reject intervals smaller than 100 us at admission time for software TAP=
RIO schedules instead of modifying advance_sched().
> - Drop catch-up cycle arithmetic, loop iteration limits, and physical exp=
iration fallbacks from advance_sched().
> https://lore.kernel.org/all/ecbfe945-f1ab-45de-aaa0-b9b57ae730c2@mail.ker=
nel.org/T/
>=20
> v2:
> - Removed the 1 microsecond admission policy for software taprio.
> - Reduced the loop iteration limit from 2048 to 32 to avoid softirq stall=
s.
> - Added handling for administrative schedules during fast-forwarding to a=
void overshooting `admin->base_time`.
> - Split logical schedule deadline (`end_time`) and physical timer expirat=
ion (`expires`).
> - Updated the fallback mechanism to request a physical expiration 1 micro=
second in the future relative to the current time rather than yielding the =
CPU.
> - Optimized gate close time calculation to only run once after the loop i=
f not already calculated.
> https://lore.kernel.org/all/03dbde3b-8c45-46b6-8291-dd12bcc3120c@mail.ker=
nel.org/T/
>=20
> v1:
> https://lore.kernel.org/all/bc6a8890-9230-489a-bbce-5c255c1ef01a@mail.ker=
nel.org/T/
> ---
> diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
> index 299234a5f..349bd2cdc 100644
> --- a/net/sched/sch_taprio.c
> +++ b/net/sched/sch_taprio.c
> @@ -661,7 +661,7 @@ static struct sk_buff *taprio_peek(struct Qdisc *sch)
> =20
>  static void taprio_set_budgets(struct taprio_sched *q,
>  			       struct sched_gate_list *sched,
> -			       struct sched_entry *entry)
> +			       struct sched_entry *entry, s64 duration)
>  {
>  	struct net_device *dev =3D qdisc_dev(q->root);
>  	int num_tc =3D netdev_get_num_tc(dev);
> @@ -669,11 +669,14 @@ static void taprio_set_budgets(struct taprio_sched =
*q,
> =20
>  	for (tc =3D 0; tc < num_tc; tc++) {
>  		/* Traffic classes which never close have infinite budget */
> -		if (entry->gate_duration[tc] =3D=3D sched->cycle_time)
> +		if (entry->gate_duration[tc] =3D=3D sched->cycle_time &&
> +		    duration =3D=3D entry->interval)
>  			budget =3D INT_MAX;
> -		else
> -			budget =3D div64_u64((u64)entry->gate_duration[tc] * PSEC_PER_NSEC,
> +		else if (entry->gate_mask & BIT(tc))
> +			budget =3D div64_u64((u64)duration * PSEC_PER_NSEC,
>  					   atomic64_read(&q->picos_per_byte));
> +		else
> +			budget =3D 0;
> =20
>  		atomic_set(&entry->budget[tc], budget);
>  	}
> @@ -875,7 +878,7 @@ static bool should_restart_cycle(const struct sched_g=
ate_list *oper,
>  	if (list_is_last(&entry->list, &oper->entries))
>  		return true;
> =20
> -	if (ktime_compare(entry->end_time, oper->cycle_end_time) =3D=3D 0)
> +	if (ktime_compare(entry->end_time, oper->cycle_end_time) >=3D 0)
>  		return true;
> =20
>  	return false;
> @@ -924,8 +927,9 @@ static enum hrtimer_restart advance_sched(struct hrti=
mer *timer)
>  	int num_tc =3D netdev_get_num_tc(dev);
>  	struct sched_entry *entry, *next;
>  	struct Qdisc *sch =3D q->root;
> -	ktime_t end_time;
> -	int tc;
> +	ktime_t start_time, end_time, expires, now;
> +	s64 duration;
> +	int tc, i;
> =20
>  	spin_lock(&q->current_entry_lock);
>  	entry =3D rcu_dereference_protected(q->current_entry,
> @@ -938,57 +942,100 @@ static enum hrtimer_restart advance_sched(struct h=
rtimer *timer)
>  	if (!oper)
>  		switch_schedules(q, &admin, &oper);
> =20
> -	/* This can happen in two cases: 1. this is the very first run
> -	 * of this function (i.e. we weren't running any schedule
> -	 * previously); 2. The previous schedule just ended. The first
> -	 * entry of all schedules are pre-calculated during the
> -	 * schedule initialization.
> -	 */
> -	if (unlikely(!entry || entry->end_time =3D=3D oper->base_time)) {
> -		next =3D list_first_entry(&oper->entries, struct sched_entry,
> -					list);
> -		end_time =3D next->end_time;
> -		goto first_run;
> -	}
> -
> -	if (should_restart_cycle(oper, entry)) {
> -		next =3D list_first_entry(&oper->entries, struct sched_entry,
> -					list);
> -		oper->cycle_end_time =3D ktime_add_ns(oper->cycle_end_time,
> -						    oper->cycle_time);
> -	} else {
> -		next =3D list_next_entry(entry, list);
> +	now =3D hrtimer_cb_get_time(timer);
> +
> +	if (entry && entry->end_time =3D=3D oper->base_time)
> +		entry =3D NULL;
> +
> +catch_up:
> +	if (oper->cycle_time > 0 &&
> +	    ktime_compare(now, oper->cycle_end_time) >=3D 0) {
> +		s64 diff =3D ktime_to_ns(ktime_sub(now, oper->cycle_end_time));
> +		s64 cycles =3D div64_s64(diff, oper->cycle_time) + 1;
> +
> +		if (admin) {
> +			ktime_t admin_target =3D ktime_sub_ns(sched_base_time(admin),
> +							    oper->cycle_time_extension);
> +
> +			if (ktime_compare(admin_target, oper->cycle_end_time) <=3D 0) {
> +				cycles =3D 0;
> +			} else {
> +				s64 admin_diff =3D ktime_to_ns(ktime_sub(admin_target,
> +								       oper->cycle_end_time));
> +				s64 admin_cycles =3D div64_s64(admin_diff - 1,
> +							     oper->cycle_time) + 1;
> +
> +				cycles =3D min(cycles, admin_cycles);
> +			}
> +		}
> +
> +		if (cycles > 0) {
> +			oper->cycle_end_time =3D ktime_add_ns(oper->cycle_end_time,
> +							    cycles * oper->cycle_time);
> +			entry =3D NULL;
> +		}
>  	}
> =20
> -	end_time =3D ktime_add_ns(entry->end_time, next->interval);
> -	end_time =3D min_t(ktime_t, end_time, oper->cycle_end_time);
> +	for (i =3D 0; i < oper->num_entries; i++) {
> +		if (!entry) {
> +			next =3D list_first_entry(&oper->entries, struct sched_entry,
> +						list);
> +			start_time =3D ktime_sub_ns(oper->cycle_end_time,
> +						  oper->cycle_time);
> +		} else {
> +			start_time =3D entry->end_time;
> +
> +			if (should_restart_cycle(oper, entry)) {
> +				next =3D list_first_entry(&oper->entries,
> +							struct sched_entry, list);
> +				oper->cycle_end_time =3D ktime_add_ns(oper->cycle_end_time,
> +								    oper->cycle_time);
> +			} else {
> +				next =3D list_next_entry(entry, list);
> +			}
> +		}
> =20
> -	for (tc =3D 0; tc < num_tc; tc++) {
> -		if (next->gate_duration[tc] =3D=3D oper->cycle_time)
> -			next->gate_close_time[tc] =3D KTIME_MAX;
> +		if (list_is_last(&next->list, &oper->entries))
> +			duration =3D ktime_sub_ns(oper->cycle_end_time, start_time);
>  		else
> -			next->gate_close_time[tc] =3D ktime_add_ns(entry->end_time,
> -								 next->gate_duration[tc]);
> +			duration =3D min_t(s64, next->interval,
> +					 ktime_sub_ns(oper->cycle_end_time, start_time));
> +
> +		end_time =3D ktime_add_ns(start_time, duration);
> +
> +		if (should_change_schedules(admin, oper, end_time)) {
> +			switch_schedules(q, &admin, &oper);
> +			entry =3D NULL;
> +			goto catch_up;
> +		}
> +
> +		if (ktime_after(end_time, now))
> +			break;
> +
> +		entry =3D next;
> +		entry->end_time =3D end_time;
>  	}
> =20
> -	if (should_change_schedules(admin, oper, end_time)) {
> -		switch_schedules(q, &admin, &oper);
> -		/* After changing schedules, the next entry is the first one
> -		 * in the new schedule, with a pre-calculated end_time.
> -		 */
> -		next =3D list_first_entry(&oper->entries, struct sched_entry, list);
> -		end_time =3D next->end_time;
> +	for (tc =3D 0; tc < num_tc; tc++) {
> +		if (next->gate_duration[tc] =3D=3D oper->cycle_time &&
> +		    duration =3D=3D next->interval)
> +			next->gate_close_time[tc] =3D KTIME_MAX;
> +		else if (next->gate_mask & BIT(tc))
> +			next->gate_close_time[tc] =3D end_time;
> +		else
> +			next->gate_close_time[tc] =3D start_time;
>  	}
> =20
>  	next->end_time =3D end_time;
> -	taprio_set_budgets(q, oper, next);
> +	taprio_set_budgets(q, oper, next, duration);
> =20
> -first_run:
>  	rcu_assign_pointer(q->current_entry, next);
> +	expires =3D end_time;
> +	if (unlikely(ktime_compare(expires, now) <=3D 0))
> +		expires =3D ktime_add_ns(now, 1);
> +	hrtimer_set_expires(&q->advance_timer, expires);
>  	spin_unlock(&q->current_entry_lock);
> =20
> -	hrtimer_set_expires(&q->advance_timer, end_time);
> -
>  	rcu_read_lock();
>  	__netif_schedule(sch);
>  	rcu_read_unlock();
> @@ -1244,6 +1291,7 @@ static void setup_first_end_time(struct taprio_sche=
d *q,
>  	struct net_device *dev =3D qdisc_dev(q->root);
>  	int num_tc =3D netdev_get_num_tc(dev);
>  	struct sched_entry *first;
> +	s64 duration;
>  	ktime_t cycle;
>  	int tc;
> =20
> @@ -1255,17 +1303,27 @@ static void setup_first_end_time(struct taprio_sc=
hed *q,
>  	/* FIXME: find a better place to do this */
>  	sched->cycle_end_time =3D ktime_add_ns(base, cycle);
> =20
> -	first->end_time =3D ktime_add_ns(base, first->interval);
> -	taprio_set_budgets(q, sched, first);
> +	if (list_is_last(&first->list, &sched->entries))
> +		duration =3D cycle;
> +	else
> +		duration =3D min_t(s64, first->interval, cycle);
> +
> +	first->end_time =3D ktime_add_ns(base, duration);
> +	taprio_set_budgets(q, sched, first, duration);
> =20
>  	for (tc =3D 0; tc < num_tc; tc++) {
> -		if (first->gate_duration[tc] =3D=3D sched->cycle_time)
> +		if (first->gate_duration[tc] =3D=3D sched->cycle_time &&
> +		    duration =3D=3D first->interval)
>  			first->gate_close_time[tc] =3D KTIME_MAX;
> +		else if (first->gate_mask & BIT(tc))
> +			first->gate_close_time[tc] =3D first->end_time;
>  		else
> -			first->gate_close_time[tc] =3D ktime_add_ns(base, first->gate_duratio=
n[tc]);
> +			first->gate_close_time[tc] =3D base;
>  	}
> =20
> -	rcu_assign_pointer(q->current_entry, NULL);
> +	if (!rcu_access_pointer(q->oper_sched) ||
> +	    rcu_access_pointer(q->oper_sched) =3D=3D sched)
> +		rcu_assign_pointer(q->current_entry, NULL);
>  }
> =20
>  static void taprio_start_sched(struct Qdisc *sch,
>=20
>=20
> base-commit: 8cdeaa50eae8dad34885515f62559ee83e7e8dda
> --=20
> This is an AI-generated patch subject to moderation.
> Reply with '#syz upstream' to Sign-off the patch as a human author
> and send it to the upstream kernel mailing lists.
> Reply with '#syz reject' to reject it ('#syz unreject' to undo).
>=20
> See https://goo.gle/syzbot-ai-patches for information about AI-generated =
patches.
> You can comment on the patch as usual, syzbot will try to address
> the comments and send a new version of the patch if necessary.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
