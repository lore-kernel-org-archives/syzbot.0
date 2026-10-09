Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ECFD34CCE
	for <syzbot@lists.linux.dev>; Fri,  9 Oct 2026 09:54:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791539679; cv=none; b=PlPgxX2EO6mkMwrf7GfOeoto8/4p4P6tCHWQj/U5Uek1+VFnP2e/TB+7p+19ps3kRQNRq9FeQ4ry062SNdX1bkpyb0jLdllaLucw1aUVrn4zTzuIHkQjMJnaxbjzrKr6yI8+ubyXTDAldjXPFrhKX7N7xoR3OD+Caw1ksRlZEmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791539679; c=relaxed/simple;
	bh=aeu1hpY4KclAgmQxX3l2cL1Q+yPSl56I63MZuBlr90k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kjv8SleihNtgmdgNVrhlNzeTGcZZhbyNmZt9nDhoYYp9/yePSKBBqt5x7nO3fBVhrMhGqgvCLz1qiQ7LM/MeI3faJMb6hy3hTvjR4il5VVpbd1OUJkZP4nR+GnR6vCOmtZCpEQSPbf66WZC5O/U1RV8K5BPEti6kegqbtvRqoRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aEkqpLTw; arc=none smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aEkqpLTw"
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-6ae185cc40fso2914696a12.1
        for <syzbot@lists.linux.dev>; Fri, 09 Oct 2026 02:54:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791539675; x=1792144475; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=3U/weMNjE0RNv9GxK0mpfZnY51CIXTmL1yTgvRjCJRk=;
        b=aEkqpLTwTFOwC2TiFMqibG0CjvNGQ08/Lashi/PM6Of9guYQIa41+AcUWIm3f1AJhk
         RcocrsWa7zQ0yNgLHdokgSySfdb/Y0yj8EAOyqYGsPyP0X24pNk9rPShi3ddx3TLhdjD
         uJcOCoUJVCFp1BCwPdpohZXA7FEk2sxIhilchoAViM/4373lyU7tbpkD2Per873K9HIq
         tUEZeAgO7IXkbBRVksnpWmpwZs6z5SoBmyywgEc9mU2qvOXButFyEwZJx+DE4o4CoHFM
         yl61TMwvh0aH2dwxRKrbDJoZmYjqGdG2cOUWoPnKW2Im0Digp7tieQohPaMzFr9dGwFB
         sKcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791539675; x=1792144475;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=3U/weMNjE0RNv9GxK0mpfZnY51CIXTmL1yTgvRjCJRk=;
        b=fW0wJ6MFndvWimHaWlysw+aEblTVeu6rqf7LRbM4OluIUv4X6LgxnxgfHyLPJZAlcO
         BZFQaRP5UPNEg784pH1H7Kgau5LHGU/vIiEF+BTiML+7s/mVRI4oNCzVvHg3FXN5dLMe
         9eO1vWxYEYlC7AXWrj8mheUiMroFzyK5E4E73XGJHzQxbjwOsHPbd6sSOY1bG9ZsmyFC
         wRMmIvTemWaJfinB7jqftjsrZAqteuzSOg2B2hdKEhCZZQkBPCTe3j30LBBJYCFUUDhN
         BOUJq615id10nHToLDu+b4BvAojCPrkOMr/eqlKNCeguy6j8SFTnTMgC6+CSxrnbEZZL
         kWRQ==
X-Forwarded-Encrypted: i=1; AKwUvBzKdeTjEHPvF5T0+Ljf+43WRTL0UQkWJdCjy356GGTbn5sfB+8JWPyCxdlB2SZVpX5AoN6Fshg=@lists.linux.dev
X-Gm-Message-State: AFq9FYIGkm0HXefUHBiZICBwKhJP0uAJs35tT8AU/GHfdZ1FeQcbongd
	BDP9k9T/HQcb826ju2sUZOYlfZn/qWcSOG4J6sZodO2smHwgcBruW9+t
X-Gm-Gg: AYBFou0W407ilN+VrYG8E0S7mX6IFB7/ZK7bEqpTykvVKXyqHxtVGkckaTJDiHL15Rk
	1M2QxzFpO2O1km47H38QCj6cUEydMd+jPwSxUHDi8MJES6MTQdd3bBAswAzJy7hzDXVetSUsV42
	JQtBgBAuJxakoYUMtFCcYPnEag2b6RyFK3r02Eu7Qx9946drcl5+SjipT2bk1tLXueyiBeoAANN
	64LD9C1wQCJO+uTg17MhmSP1fWTufgTvYqvuWWreFvfrM67nM/hCxfzpi535BRMcIAsXv1ZUQFf
	eLKQ/xto2sZs6L1HdUB7yX5IrOpD5Dz9of+SblopOyLtbZ8MwmJhP0Bm1XzzybYlO9sQR7jqFIL
	Q0kvhfSWAd0AyND8BqY/RXf9udIHs37n2sGmbAIVcrFPteyNLmQC4DM9yoH+ndmZ0A/ZyKO4x4o
	D1+YpcaGs+O7CRVF6jb0GyQJ7GXB1vX4BwQQaz3Ta3AXJGz628dhxdWV2DCAGN3SHjXs+7czMjY
	HEmKtJPqvg6Hz2dTHBAAg==
X-Received: by 2002:a17:907:1c81:b0:c25:f7db:4bec with SMTP id a640c23a62f3a-c31a9f94581mr148321366b.18.1791539675373;
        Fri, 09 Oct 2026 02:54:35 -0700 (PDT)
Received: from localhost ([37.30.48.8])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c31a9a3bbeesm70028366b.18.2026.10.09.02.54.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Oct 2026 02:54:35 -0700 (PDT)
Date: Fri, 9 Oct 2026 11:54:34 +0200
From: Bartosz Chronowski <immersa.bartosz.chronowski@gmail.com>
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Subject: Re: [PATCH RFC v4] net/sched: taprio: catch up overdue cycles in
 advance_sched()
Message-ID: <gjvyztem7smxfqj7zovzr7gga5lzofyffoprnecwv4wkrh7bqx@567y5bpr64q6>
References: <a75dd710-09c2-4dce-bc7b-65fd6c4be4d8@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <a75dd710-09c2-4dce-bc7b-65fd6c4be4d8@mail.kernel.org>

The v4 patch is not ready for upstream. Skipping complete overdue periods is
the right direction. The exact target appeared in 2/4 baseline VMs and 0/4
patched VMs in the comparable run, but the arithmetic still produces an
invalid gate interval for an accepted schedule.

Consider entry durations [5u, u] and an explicit cycle of 2u, where u is a
duration unit and B is the cycle origin. The first entry is truncated at
B + 2u. With the sampled time at B + 5u, v4 can publish a start at B + 7u
while both the end and cycle end are B + 4u. The start is after the end, and
the next timer expiry is already in the past.

1. In advance_sched(), derive catch-up from the effective, truncated
   schedule. Select a coherent current entry, keep its start, end and cycle
   end ordered, and arm a strictly future expiry. Bound the work by the
   schedule size. Preserve the operational entry until the administrative
   schedule activates, derive masks and budgets from the selected entry,
   and serialize entry and timer updates with schedule replacement.
2. Check implicit cycles and explicit cycles shorter than, equal to and
   longer than the entry sum, including first- and later-entry truncation,
   exact expiry and delays spanning whole periods plus a remainder.
   Compare the exact reproducer on a target-reproducing baseline and the
   patched kernel with matching configuration and exposure.

Keep the patch as small as possible while preserving the required behavior;=
 avoid unrelated refactoring.

Impact assessment: Overdue software TAPRIO timer work can starve a CPU long
enough to trigger an RCU stall. The invalid schedule state remains a
correctness blocker despite suppression of the selected runtime trigger.

Kind Regards / Mit freundlichen Gr=C3=BC=C3=9Fen
BART CHRONOWSKI

On Tue, Sep 29, 2026 at 01:06:19PM +0000, syzbot wrote:
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
> arithmetically by advancing start_time, end_time, and oper->cycle_end_time
> by the elapsed number of full cycles. Residual entry transitions are left
> to subsequent callbacks to prevent unbounded replay while avoiding
> multi-entry walks in a single callback that could circle back to an entry
> visible to lockless dequeue readers.
>=20
> Fixes: 5a781ccbd19e ("tc: Add support for configuring the taprio schedule=
r")
> Assisted-by: Gemini:gemini-3.8-flash syzbot
> Reported-by: syzbot+f8850bc3986562f79619@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3Df8850bc3986562f79619
> Link: https://syzkaller.appspot.com/ai_job?id=3D337aa421-80c1-40fd-a577-e=
b7fe10007fe
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
> v4:
> - Replace admission-time interval rejection with bounded catch-up in adva=
nce_sched().
> - Arithmetically advance overdue full periods instead of walking individu=
al entries.
> - Record cycle_interval_sum in parse_taprio_schedule() to determine the c=
ycle period.
> - Set timer expiration before releasing current_entry_lock.
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
> index 299234a5f..2f73c7a84 100644
> --- a/net/sched/sch_taprio.c
> +++ b/net/sched/sch_taprio.c
> @@ -83,6 +83,7 @@ struct sched_gate_list {
>  	s64 cycle_time;
>  	s64 cycle_time_extension;
>  	s64 base_time;
> +	s64 cycle_interval_sum;
>  };
> =20
>  struct taprio_sched {
> @@ -924,7 +925,8 @@ static enum hrtimer_restart advance_sched(struct hrti=
mer *timer)
>  	int num_tc =3D netdev_get_num_tc(dev);
>  	struct sched_entry *entry, *next;
>  	struct Qdisc *sch =3D q->root;
> -	ktime_t end_time;
> +	ktime_t start_time, end_time, now;
> +	s64 period;
>  	int tc;
> =20
>  	spin_lock(&q->current_entry_lock);
> @@ -951,6 +953,8 @@ static enum hrtimer_restart advance_sched(struct hrti=
mer *timer)
>  		goto first_run;
>  	}
> =20
> +	start_time =3D entry->end_time;
> +
>  	if (should_restart_cycle(oper, entry)) {
>  		next =3D list_first_entry(&oper->entries, struct sched_entry,
>  					list);
> @@ -960,15 +964,22 @@ static enum hrtimer_restart advance_sched(struct hr=
timer *timer)
>  		next =3D list_next_entry(entry, list);
>  	}
> =20
> -	end_time =3D ktime_add_ns(entry->end_time, next->interval);
> -	end_time =3D min_t(ktime_t, end_time, oper->cycle_end_time);
> +	if (next->interval > ktime_sub(oper->cycle_end_time, start_time))
> +		end_time =3D oper->cycle_end_time;
> +	else
> +		end_time =3D ktime_add_ns(start_time, next->interval);
> =20
> -	for (tc =3D 0; tc < num_tc; tc++) {
> -		if (next->gate_duration[tc] =3D=3D oper->cycle_time)
> -			next->gate_close_time[tc] =3D KTIME_MAX;
> -		else
> -			next->gate_close_time[tc] =3D ktime_add_ns(entry->end_time,
> -								 next->gate_duration[tc]);
> +	period =3D min_t(s64, oper->cycle_time, oper->cycle_interval_sum);
> +
> +	now =3D hrtimer_cb_get_time(timer);
> +	if (period > 0 && ktime_after(now, end_time)) {
> +		s64 diff =3D ktime_to_ns(ktime_sub(now, end_time));
> +		s64 periods =3D div64_s64(diff, period);
> +		s64 delta =3D periods * period;
> +
> +		start_time =3D ktime_add_ns(start_time, delta);
> +		end_time =3D ktime_add_ns(end_time, delta);
> +		oper->cycle_end_time =3D ktime_add_ns(oper->cycle_end_time, delta);
>  	}
> =20
>  	if (should_change_schedules(admin, oper, end_time)) {
> @@ -978,16 +989,23 @@ static enum hrtimer_restart advance_sched(struct hr=
timer *timer)
>  		 */
>  		next =3D list_first_entry(&oper->entries, struct sched_entry, list);
>  		end_time =3D next->end_time;
> -	}
> +	} else {
> +		for (tc =3D 0; tc < num_tc; tc++) {
> +			if (next->gate_duration[tc] =3D=3D oper->cycle_time)
> +				next->gate_close_time[tc] =3D KTIME_MAX;
> +			else
> +				next->gate_close_time[tc] =3D ktime_add_ns(start_time,
> +									 next->gate_duration[tc]);
> +		}
> =20
> -	next->end_time =3D end_time;
> -	taprio_set_budgets(q, oper, next);
> +		next->end_time =3D end_time;
> +		taprio_set_budgets(q, oper, next);
> +	}
> =20
>  first_run:
>  	rcu_assign_pointer(q->current_entry, next);
> -	spin_unlock(&q->current_entry_lock);
> -
>  	hrtimer_set_expires(&q->advance_timer, end_time);
> +	spin_unlock(&q->current_entry_lock);
> =20
>  	rcu_read_lock();
>  	__netif_schedule(sch);
> @@ -1151,19 +1169,23 @@ static int parse_taprio_schedule(struct taprio_sc=
hed *q, struct nlattr **tb,
>  	if (err < 0)
>  		return err;
> =20
> -	if (!new->cycle_time) {
> +	{
>  		struct sched_entry *entry;
>  		ktime_t cycle =3D 0;
> =20
>  		list_for_each_entry(entry, &new->entries, list)
>  			cycle =3D ktime_add_ns(cycle, entry->interval);
> =20
> -		if (cycle < 0 || cycle > INT_MAX) {
> -			NL_SET_ERR_MSG(extack, "'cycle_time' is too big");
> -			return -EINVAL;
> -		}
> +		new->cycle_interval_sum =3D cycle;
> +
> +		if (!new->cycle_time) {
> +			if (cycle < 0 || cycle > INT_MAX) {
> +				NL_SET_ERR_MSG(extack, "'cycle_time' is too big");
> +				return -EINVAL;
> +			}
> =20
> -		new->cycle_time =3D cycle;
> +			new->cycle_time =3D cycle;
> +		}
>  	}
> =20
>  	if (new->cycle_time < new->num_entries * length_to_duration(q, ETH_ZLEN=
)) {
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
