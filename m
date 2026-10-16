Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70C8E3E49E2
	for <syzbot@lists.linux.dev>; Fri, 16 Oct 2026 09:46:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792143976; cv=none; b=PsF3UJPBOSbyA+OF6o6iwCGcpE4xR7l+6+IQZGidE8v/bkXzDvJPKUNe9OTBtvfz9txbMzogSM7kDNwX2X9CjPd8ke0rCGSD2cMqbC+Cya4vStcE7gUzGtJO1p5xxqga1L+qmZv3PxlFRCmVIlNsFMdjD6XPhZ26mdde65NML2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792143976; c=relaxed/simple;
	bh=3EJIoKg8+j42ssz4uwIVSTJ0wXQDoEGsXCx3fcyhplE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sBE97ACIyh6DaW68RoTQD0rTQ9u6nmcsoP0vltInApWwDi8F/sb+Xl4zHvqQfGSvK4Qflu3CsObTmsxQLG4Nt9JiMBMdc7RSj8DamsfzdyFcHd6xI9LBjFIwKjLB1e/5AdlOd2APY0zd9301O+756ntAhV2xlFkij1yZ5l74u1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PadJnZxU; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PadJnZxU"
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-c413dea9ca6so12360466b.2
        for <syzbot@lists.linux.dev>; Fri, 16 Oct 2026 02:46:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792143973; x=1792748773; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=RXEFS17ItPtUMJSLm0umZ8/sBzHHwP/XRLAN7BX1u0I=;
        b=PadJnZxUf48ZqUSslNBS/wobjXT8X/kXEJlIkS2dwpw6MlUGvsWxjXQF+oMPqIPb2r
         uNjfgfsKoMhqeosU6a6e7hLl3eDA/iz3W1FD1M6TvUfG1UsRhZHNo4aZQieGsFZruqZI
         OZc3+XAkWG5suIetqVy/h6N14K5OBJo8aEBCyGpTqMZwbulBgFQpmNC7UTrMEs3xLw1Q
         fVnvtrzy58/WaQBsK51UyDqWkXVIztoB18Swx3aAskKHSOOZTfyMEROTgWXeELNAHOI0
         uw6kCSk2EFbm3v2D9GuwKPOZAIzngd2FbvIgpcn95cdKy3K0uXwY751jBmI0i2+0VVwP
         T7lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792143973; x=1792748773;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=RXEFS17ItPtUMJSLm0umZ8/sBzHHwP/XRLAN7BX1u0I=;
        b=dtrOEuINakSsz5YVclJ6V6ZOkUHE3RgPRqsbYxz6Gt3bVMM+QnBrrO9HW2uEh8Ytm6
         uz4AsoPWEs8PiaIcOi/kkWcrtdfq63ni9bpnjNLgGj7KVfc97Rr7eL+YbibZOOW0O5ii
         avPuiklFP89PaWagWP3dk1ey1SfydIHVSTOEdJA37xNa5xALXsQbDXqPTDzR2MdvCA52
         R+D5tph40Vmf5FWIMyG1uAB+OgbX60pSIq4jsiWe9KjDETHi1ZVtydfNCyY/1P3CMGQj
         9NoaNdcAzs4lRTbbV1rQKRBrHwB0KHkvjUxbSsFEQG6S4YPDe6OQsvoGixKXaj9cQoYA
         Jdbw==
X-Forwarded-Encrypted: i=1; AKwUvBxKPRZgbnDisd4Mp+Gv09Ly8O1ZfHl7WAel4xA7jFIvvhkNk1B2sDvpDkqe8cW9JLJ6lifOxPY=@lists.linux.dev
X-Gm-Message-State: AFq9FYI9FnouoAjV72wv9FvB343sKc35RIff9ICbHH82SGI03C5bPRgo
	XuF6o1G3GCnb8VpCmLHTm04QzNEq51ciOyuhWg270CC6DadLXjg4+tDT
X-Gm-Gg: AYBFou3H0avAYPxMTbaweb3h41LtlVgg4GdlkrUnz0A4YGNFfxevYH7AF70BG+dKe2+
	5RG/hq3gfmmdfR5ZOnqOQPwdtBoBCgStJnqBtGgNi0d8LFKyYIzDk81EnVkFObo92US679k6uWl
	wxMA1wTZZ1RRJHIMxKShaxrGDNBNj7YMNIW4idPzb7CRrcCMJqfCw5neT0CBslNY8MfBoCPSESw
	w9vDQIt4WVXrdoEfmeZJNtnvJOWzaIQ1/HPjacAI3ow5RzPHx1fhMQb2suogiVFl8JXN22rR/RA
	VCXYfb9ZNlvIAHYt2GmZibjsMmDrscQSIZ5tU3rxHcGotjYtUAw8WbKFzXtKtSw5MBlujZVggIJ
	cVtO0pRsdKLrFKvVUou0T9Wr3OBIpv309uckmWm/2slT3EGwjGBzUSGds8vfPTDzvMCsK6p18RX
	yk541BsEvmr58UEe4oh/7czFeDm0w2wMf4/s0rrgPNWW2Qrq3VbV5SLKrg0IASrfK9W/VyiK90G
	sQFtywBcTkwZq/C9TOADA==
X-Received: by 2002:a17:907:84e:b0:c40:83f:4621 with SMTP id a640c23a62f3a-c40084e9f2amr244606966b.4.1792143972299;
        Fri, 16 Oct 2026 02:46:12 -0700 (PDT)
Received: from localhost ([37.30.48.8])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c4090dcf335sm56928866b.29.2026.10.16.02.46.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2026 02:46:12 -0700 (PDT)
Date: Fri, 16 Oct 2026 11:46:11 +0200
From: Bartosz Chronowski <immersa.bartosz.chronowski@gmail.com>
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Subject: Re: [PATCH RFC v5] net/sched: taprio: catch up overdue cycles in
 advance_sched()
Message-ID: <dgzc4thdxzf4dqachv4tfunh5ldbltslt4ugtlhar3skmjgk4d@biq3bk7jttr7>
References: <2fcb3fdb-42b4-4a7a-bf17-3b5a422bfa75@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <2fcb3fdb-42b4-4a7a-bf17-3b5a422bfa75@mail.kernel.org>

The v5 direction is materially better, but the patch is not ready for
upstream. It fixes the exact [5d,d] with cycle_time=3D2d reversed-interval
defect, bounds the entry walk by the schedule size, and moves timer
programming under current_entry_lock. The comparable run hit the exact targ=
et
on the unpatched kernel in 2 of 4 VMs (the other 2 had alternate crashes) a=
nd
observed no crash on the patched kernel in 4/4 VMs, but deterministic sched=
ule
checks still fail nine blocking cases.

Keep one effective duration for each selected entry and use it consistently
for the entry end, gate-close time, and budget. V5 can extend the last entry
of [d,d] with cycle_time=3D4d to 3d while retaining a d-sized gate duration=
 and
budget; first- and later-entry truncation produce the inverse mismatch.

When a pending administrative schedule becomes due during delayed catch-up,
converge to the entry that is actually current before publishing state. Do
not publish a stale operational entry or an already-expired first
administrative entry. Refresh the gate-close times and budgets for the entry
selected from the new schedule.

Keep the patch as small as possible while preserving the required behavior;=
 avoid unrelated refactoring.

Impact assessment: Overdue software TAPRIO timer work can starve CPU and RCU
progress. The remaining defects can publish gate timing and budgets that do
not match an accepted schedule and can retain immediate timer activity after
delayed administrative activation. No memory corruption, confidentiality
loss, or privilege escalation is proven.

Kind Regards / Mit freundlichen Gr=C3=BC=C3=9Fen
BART CHRONOWSKI

On Fri, Oct 09, 2026 at 07:10:01PM +0000, syzbot wrote:
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
> Assisted-by: Gemini:gemini-3.8-flash syzbot
> Reported-by: syzbot+f8850bc3986562f79619@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3Df8850bc3986562f79619
> Link: https://syzkaller.appspot.com/ai_job?id=3D069b71fb-28b3-4676-9783-f=
9c3f6bf377d
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
> index 299234a5f..31e123d97 100644
> --- a/net/sched/sch_taprio.c
> +++ b/net/sched/sch_taprio.c
> @@ -875,7 +875,7 @@ static bool should_restart_cycle(const struct sched_g=
ate_list *oper,
>  	if (list_is_last(&entry->list, &oper->entries))
>  		return true;
> =20
> -	if (ktime_compare(entry->end_time, oper->cycle_end_time) =3D=3D 0)
> +	if (ktime_compare(entry->end_time, oper->cycle_end_time) >=3D 0)
>  		return true;
> =20
>  	return false;
> @@ -924,8 +924,9 @@ static enum hrtimer_restart advance_sched(struct hrti=
mer *timer)
>  	int num_tc =3D netdev_get_num_tc(dev);
>  	struct sched_entry *entry, *next;
>  	struct Qdisc *sch =3D q->root;
> -	ktime_t end_time;
> -	int tc;
> +	ktime_t start_time, end_time, expires, now;
> +	bool admin_switched =3D false;
> +	int tc, i;
> =20
>  	spin_lock(&q->current_entry_lock);
>  	entry =3D rcu_dereference_protected(q->current_entry,
> @@ -938,6 +939,8 @@ static enum hrtimer_restart advance_sched(struct hrti=
mer *timer)
>  	if (!oper)
>  		switch_schedules(q, &admin, &oper);
> =20
> +	now =3D hrtimer_cb_get_time(timer);
> +
>  	/* This can happen in two cases: 1. this is the very first run
>  	 * of this function (i.e. we weren't running any schedule
>  	 * previously); 2. The previous schedule just ended. The first
> @@ -948,47 +951,98 @@ static enum hrtimer_restart advance_sched(struct hr=
timer *timer)
>  		next =3D list_first_entry(&oper->entries, struct sched_entry,
>  					list);
>  		end_time =3D next->end_time;
> -		goto first_run;
> +		if (ktime_after(end_time, now))
> +			goto first_run;
> +		entry =3D next;
>  	}
> =20
> -	if (should_restart_cycle(oper, entry)) {
> -		next =3D list_first_entry(&oper->entries, struct sched_entry,
> -					list);
> -		oper->cycle_end_time =3D ktime_add_ns(oper->cycle_end_time,
> -						    oper->cycle_time);
> -	} else {
> -		next =3D list_next_entry(entry, list);
> +	if (oper->cycle_time > 0 && ktime_after(now, oper->cycle_end_time)) {
> +		s64 diff =3D ktime_to_ns(ktime_sub(now, oper->cycle_end_time));
> +		s64 cycles =3D div64_s64(diff, oper->cycle_time) + 1;
> +
> +		if (admin) {
> +			ktime_t admin_base =3D sched_base_time(admin);
> +
> +			if (ktime_after(ktime_add_ns(oper->cycle_end_time,
> +						     cycles * oper->cycle_time),
> +					admin_base)) {
> +				diff =3D ktime_to_ns(ktime_sub(admin_base,
> +							     oper->cycle_end_time));
> +				cycles =3D diff > 0 ? div64_s64(diff, oper->cycle_time) : 0;
> +			}
> +		}
> +
> +		if (cycles > 0) {
> +			s64 delta =3D cycles * oper->cycle_time;
> +
> +			oper->cycle_end_time =3D ktime_add_ns(oper->cycle_end_time, delta);
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
> +			end_time =3D oper->cycle_end_time;
>  		else
> -			next->gate_close_time[tc] =3D ktime_add_ns(entry->end_time,
> -								 next->gate_duration[tc]);
> -	}
> +			end_time =3D min_t(ktime_t,
> +					 ktime_add_ns(start_time, next->interval),
> +					 oper->cycle_end_time);
> +
> +		if (should_change_schedules(admin, oper, end_time)) {
> +			switch_schedules(q, &admin, &oper);
> +			next =3D list_first_entry(&oper->entries, struct sched_entry,
> +						list);
> +			end_time =3D next->end_time;
> +			admin_switched =3D true;
> +			break;
> +		}
> =20
> -	if (should_change_schedules(admin, oper, end_time)) {
> -		switch_schedules(q, &admin, &oper);
> -		/* After changing schedules, the next entry is the first one
> -		 * in the new schedule, with a pre-calculated end_time.
> -		 */
> -		next =3D list_first_entry(&oper->entries, struct sched_entry, list);
> -		end_time =3D next->end_time;
> +		if (ktime_after(end_time, now))
> +			break;
> +
> +		entry =3D next;
> +		entry->end_time =3D end_time;
>  	}
> =20
> -	next->end_time =3D end_time;
> -	taprio_set_budgets(q, oper, next);
> +	if (!admin_switched) {
> +		for (tc =3D 0; tc < num_tc; tc++) {
> +			if (next->gate_duration[tc] =3D=3D oper->cycle_time)
> +				next->gate_close_time[tc] =3D KTIME_MAX;
> +			else
> +				next->gate_close_time[tc] =3D ktime_add_ns(start_time,
> +									 next->gate_duration[tc]);
> +		}
> +
> +		next->end_time =3D end_time;
> +		taprio_set_budgets(q, oper, next);
> +	}
> =20
>  first_run:
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
> @@ -1255,7 +1309,13 @@ static void setup_first_end_time(struct taprio_sch=
ed *q,
>  	/* FIXME: find a better place to do this */
>  	sched->cycle_end_time =3D ktime_add_ns(base, cycle);
> =20
> -	first->end_time =3D ktime_add_ns(base, first->interval);
> +	if (list_is_last(&first->list, &sched->entries))
> +		first->end_time =3D sched->cycle_end_time;
> +	else
> +		first->end_time =3D min_t(ktime_t,
> +					ktime_add_ns(base, first->interval),
> +					sched->cycle_end_time);
> +
>  	taprio_set_budgets(q, sched, first);
> =20
>  	for (tc =3D 0; tc < num_tc; tc++) {
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
