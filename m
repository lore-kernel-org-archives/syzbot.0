Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCADE3CF68E
	for <syzbot@lists.linux.dev>; Fri, 16 Oct 2026 09:45:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792143937; cv=none; b=VNX8orPtF4CYZL59SfIpmJK7CEguxfqoJ3wNw7FKoq8Bxg75XVnqll4qLzAmZfa3ioWiTgDipVT74/4KukkpKLyVaco8lBgNPCc204DazJDWwfmW2q67BZcIf/2zX9DZsXxwKo01WzQsN5jCbeLrJmHX8QSRoqJ5N16ujhNF94c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792143937; c=relaxed/simple;
	bh=y0M11rlQ2d7hVrsYUx2nFWPdO0R51wgNRU+RdfvlHX4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OyJ0fFUo2VuUqJ0o/7y2r4FVF+PsAanB9BG76zX0zReRLU0bl7NtKve4Sy6+O3kiJijpoiDHY8eDsXcPbKwytzaLEDrGgQuVyMPry1mdBIbo57rRPaAuvPMil/XQxXJzyLDRX8usm8RxYG0puBnU+18yF5A/4ML5hz+14aZ+K2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aAfXoIbk; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aAfXoIbk"
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-c40f29667e6so42186766b.0
        for <syzbot@lists.linux.dev>; Fri, 16 Oct 2026 02:45:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792143933; x=1792748733; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=vWOAfW6r/qvw3hYYaHeqrgTU2KZzD2Axlk9KXlfVOgA=;
        b=aAfXoIbkHG1BYiv7MvvdXIBNvwqGTcWTV8fHnSA7dKgBs3/ieiLtgWdUzRVM5ctaVa
         B4CMrx+T4PwFLmIiXhKumRDikBvQJ/92ZqH2BAbuF/MDb3v8AgOh/+WqcbCgf1/pBx1V
         v2L+Okr524+s9MT4H6mDV+Ulw1SaAn+dCDrmz8b31wt2BHyPIsznRB/spP63Drg7aSHz
         Mznb9UFWHMs/BtgBdTuHcOh+EyLxEaGG7sPcmiYUIvbZoWyfBnqIOyEQVn4djGCubz7h
         NEnwowo/b/x/clN6PrcpJzuaiCux2MMphnTNYhQbjKPtwWbJXu9Tnkt+uVJ3fVqiJeWV
         4IMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792143933; x=1792748733;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=vWOAfW6r/qvw3hYYaHeqrgTU2KZzD2Axlk9KXlfVOgA=;
        b=bgov/bcUKYjqltOOxwNaZUzBhvOwpBM3msxemUVELrk8ViXqEIBdWUjexAr4uRoV+P
         7LdaxU04T8KS4ht2+rrYFRwjAXKzL6bJreI1t5bFv9dZ2MG3bhqDRik/v8efBymn62og
         zG8AF5Ly4zvf3yhzItlpljBZQors+7lzXXSYEcHeOfkH54TjX3QLL+F6Njhe1rEqrgY5
         tIcVFsZL6DOkTdEd29wGK5LpsQNafxT5RF5a3jb5fOX1oOyiC2Sb9sadcCv1rh1ZmXcv
         Cy9UmKVPj/1YUiyp8hMJbjAJ7rHJ8fxDKtHs0oO2Ofyuf14Wx1cLGFQ2Q9u5e1drp3xe
         7V3Q==
X-Forwarded-Encrypted: i=1; AKwUvBxteiaNSXuOz5+kp8/hmCv5G1gReLXJ7azlBedJ+Yq2T0PRDG9CmI8bd1qYN0/+wvIXof8lB4I=@lists.linux.dev
X-Gm-Message-State: AFq9FYKpzcUJ+dJJm3CrnzZbM2smCf2PyURDI2CepfsgjX6PHzJlVwao
	GsCjNWcDiqWerE2VceA/e8x3abV5Vpfz14rlzhj0NMP+kYhaDVryNPmT
X-Gm-Gg: AYBFou0UjOvXngb4XZ8CfY72bKbT5vYQ4UlhYcAh1MHBFi7Ugq1fnKnzphsC+KLksKG
	Eusg5ZTVju8URFAEJmKSXYLBNNY4jDK/SXlc/dv/cLeMN3Hk//6VOgEJjozsHf+m2K7sRvKjjU1
	V88VbYobvu2INd1YS8/URvjGnabUi9EQ1RwQA6J40o4f5RDJtrCEkqWOP7bEXEvTrQyvnOBAoby
	JT4TaLelxipA17gOUQqP6v2eypmrSWBrJexuE9sjDfC733C/lZB2gwPEisFsrouC/y2Yk0TT0Fr
	xXOpbKJYwEBqaCDHYRsOwNuwcmJumWYbyaMGtr0ONAPB30PEekjgUqw2NDeSzlx6GpaUzFloewQ
	BOrc09HzRClbtI2Uu9OC6FhjhYLtJVXqI1ov+8kK6zteLpT1qiVdLhSeAGX2qWiu8/WMsBWBLBU
	qudo7TCom3WqDPdA1zGvmim+saNMJMrPLo8ueA2OcQF0A9SmikmwRZ9IXxjsP8D8scG9k7SDcqO
	uduWQX8pfC6gO3hvCyKMw==
X-Received: by 2002:a17:906:c116:b0:c31:8441:35ff with SMTP id a640c23a62f3a-c31aa0e9367mr1992627366b.48.1792143932787;
        Fri, 16 Oct 2026 02:45:32 -0700 (PDT)
Received: from localhost ([37.30.48.8])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c408e32bc33sm56879366b.5.2026.10.16.02.45.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2026 02:45:32 -0700 (PDT)
Date: Fri, 16 Oct 2026 11:45:31 +0200
From: Bartosz Chronowski <immersa.bartosz.chronowski@gmail.com>
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Subject: Re: [PATCH RFC v5] net/sched: taprio: enforce minimum interval in
 software mode
Message-ID: <esjqdr75isg7inufs6447whbm4577c7xlrf4tugvgyjgg2ispq@hjktefnkwpg3>
References: <9e73068d-a591-4830-a002-b08d999679fb@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <9e73068d-a591-4830-a002-b08d999679fb@mail.kernel.org>

v5 fixes the exact-start comparisons and stages max_sdu and fp, so the
current TAPRIO direction remains close enough to iterate. The code is still
incorrect: new pre-allocation errors reach free_sched with an uninitialized
new_admin, and a failed first setup can discard an existing device
traffic-class layout. Clang and the targeted semantic checks confirm those
two defects. Historical, unpatched-base, and patched-base runs all returned
no-repro, so the runtime comparison remains inconclusive. The patch is not
ready.

Keep the next revision small and preserve the working parts of this version:

- Initialize new_admin to NULL before any path can jump to free_sched, and
  exercise every pre-allocation failure path. Preserve the device's prior
  traffic-class layout after a later first-setup failure; netdev_reset_tc()
  does not restore that state.

- Establish the deadline guarantee at the actual rearm point. Derive the
  selected phase, administrative transition, entry deadline, gate-close
  times, and finite budgets coherently, then test delayed callbacks around
  the equality boundaries. The current stale time sample does not prove the
  strictly-future claim.

- Replace the Fixes: tag with:

  Fixes: 5a781ccbd19e4 ("tc: Add support for configuring the taprio schedul=
er")

  The selected reproducer does not supply cycle_time, so 6ca6a6654225 is not
  the causal introduction for this report.

Keep the patch narrowly scoped to these corrections and avoid unrelated
refactoring.

Impact assessment: the original defect affects CPU progress and scheduling
correctness. The uninitialized cleanup pointer adds a kernel crash and
memory-safety risk for rejected configurations. The available evidence does
not establish information disclosure, privilege escalation, or practical
exploitability.

Kind Regards / Mit freundlichen Gr=C3=BC=C3=9Fen
BART CHRONOWSKI

On Fri, Oct 09, 2026 at 03:14:57PM +0000, syzbot wrote:
> In taprio software mode (when full offload and txtime-assist are not
> enabled), schedule advancement is driven in software by an hrtimer running
> advance_sched(). The minimum allowed duration for schedule entries was
> previously bounded only by length_to_duration(q, ETH_ZLEN). For high link
> speeds or small picos_per_byte, this allows entry intervals to be
> configured to extremely small values (e.g., tens of nanoseconds).
>=20
> When entry intervals or cycle_time are configured to values shorter than
> the time required to execute the timer callback, the newly calculated
> expiration time is in the past. Consequently, the hrtimer subsystem
> repeatedly and immediately re-invokes advance_sched() in hardirq context,
> resulting in an interrupt storm that starves the CPU and triggers RCU
> stalls:
>=20
> rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:
> rcu: 	0-...!: (1 GPs behind) idle=3Dfc14/1/0x4000000000000000
> softirq=3D20212/20212 fqs=3D5
> rcu: 	(detected by 1, t=3D10502 jiffies, g=3D16909, q=3D1720 ncpus=3D2)
> Sending NMI from CPU 1 to CPUs 0:
> NMI backtrace for cpu 0
> CPU: 0 UID: 0 PID: 200 Comm: kworker/u9:4 Not tainted
> RIP: 0010:advance_sched+0x10f/0xc80 net/sched/sch_taprio.c:932
> Call Trace:
>  <IRQ>
>  __run_hrtimer kernel/time/hrtimer.c:2067 [inline]
>  __hrtimer_run_queues+0x3bc/0xa10 kernel/time/hrtimer.c:2124
>  hrtimer_interrupt+0x4cd/0xaa0 kernel/time/hrtimer.c:2243
>  local_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1051 [inline]
>  __sysvec_apic_timer_interrupt+0x102/0x430 arch/x86/kernel/apic/apic.c:10=
68
>  sysvec_apic_timer_interrupt+0xa1/0xc0 arch/x86/kernel/apic/apic.c:1062
>  </IRQ>
>=20
> To prevent CPU starvation, define TAPRIO_MIN_SW_INTERVAL_NS (10 us) and
> introduce taprio_min_interval(). In software mode, each entry's duration
> and cycle_time are bounded to at least taprio_min_interval() (max(ETH_ZLEN
> duration, 10 us)). In steady-state operation, this ensures that entry
> durations are significantly larger than the execution latency of
> advance_sched(), allowing the CPU to service softirqs and advance RCU gra=
ce
> periods between normal timer interrupts. For TXTIME-assist and full-offlo=
ad
> modes, advance_sched() does not drive schedule switching in software, so
> taprio_min_interval() continues to compute length_to_duration(q, ETH_ZLEN)
> without the 10 us clamp, preserving hardware offload capabilities.
>=20
> Unify the derivation of the effective schedule directly in
> parse_taprio_schedule(). When an explicit cycle_time is configured, entri=
es
> exceeding cycle_time are dropped, any entry straddling the cycle boundary
> is truncated to fit the remaining cycle duration, and if the total durati=
on
> is less than cycle_time, the final entry is extended to fill the cycle. T=
he
> entries are reindexed and validated so that every effective interval
> satisfies taprio_min_interval(). Materializing this effective schedule
> in-place ensures that all consumers=E2=80=94including gate duration calcu=
lations
> (taprio_calculate_gate_durations), packet transmission lookup
> (find_entry_to_transmit), transmission budgets, queueMaxSDU validation, a=
nd
> hardware offload drivers=E2=80=94operate on an identical, consistent sche=
dule
> definition without sub-minimum trailing intervals.
>=20
> To mitigate timer delays (e.g. from interrupt latency or preemption),
> advance_sched() now enforces bounded catch-up work and guarantees strictly
> future timer expiration. If the timer fires late such that the scheduled
> expiration time has already passed, advance_sched() advances step-by-step
> for at most 32 entries before falling back to taprio_fast_forward_sched().
> This fallback advances full cycles via division and scans the effective
> entries list once to locate the active entry. While the remaining time to
> that entry's boundary may be less than 10 us if the timer fired late into
> its window, subsequent intervals return to the configured minimum.
> Furthermore, if the resulting target expiration is still not in the futur=
e,
> it is clamped to at least taprio_min_interval(q) ahead of current time.
> Bounding catch-up work to at most 32 steps plus a single pass over the
> schedule entries list, and ensuring timer expiry is always strictly in the
> future, prevents advance_sched() from getting trapped in an hrtimer
> interrupt loop.
>=20
> Finally, parse and validate the schedule in taprio_change() before invoki=
ng
> netdev_set_num_tc(), stage max_sdu and fp configurations locally until
> commit time, ensure netdev traffic classes and driver state are cleanly
> rolled back on subsequent errors during initial setup, move
> taprio_calculate_gate_durations() after traffic classes are established,
> and reject empty schedules.
>=20
> Fixes: 6ca6a6654225 ("taprio: Add support for setting the cycle-time manu=
ally")
> Assisted-by: Gemini:gemini-3.8-flash syzbot
> Reported-by: syzbot+14c6ac6811273526cfa5@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3D14c6ac6811273526cfa5
> Link: https://syzkaller.appspot.com/ai_job?id=3Df8888df0-4ae5-4e93-8956-6=
5f2938114b2
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
> - Factored out schedule fast-forward logic into taprio_fast_forward_sched=
().
> - Clarified commit description regarding fast-forward scanning of the eff=
ective list and narrowed 10 us interval claims to steady-state operation.
> - Staged max_sdu and fp configurations in taprio_change() to avoid premat=
ure state mutation before commit.
> - Restored flags, clockid, and tk_offset on rollback if setup fails durin=
g initial configuration in taprio_change().
> - Adjusted boundary time comparisons in find_entry_to_transmit(), is_vali=
d_interval(), and get_packet_txtime().
>=20
> v4:
> - Unified effective schedule derivation in parse_taprio_schedule() by dro=
pping out-of-bounds entries, truncating boundary-straddling entries, and pa=
dding trailing entries, ensuring all consumers operate on the identical sch=
edule.
> - Moved entry interval validation to parse_taprio_schedule() to validate =
effective post-truncation intervals against taprio_min_interval().
> - Added bounded catch-up advancement (up to 32 entries) and fast-forward =
cycle calculation in advance_sched() to bound interrupt latency.
> - Enforced strictly future hrtimer expiration in advance_sched() by clamp=
ing end_time to at least taprio_min_interval() ahead of the current time.
> - Added cleanup logic to reset netdev traffic classes in taprio_change() =
if an error occurs after netdev_set_num_tc().
> - Added safety checks for NULL oper in should_change_schedules() and adva=
nce_sched().
> - Updated curr_intv_start boundary check in find_entry_to_transmit().
> https://lore.kernel.org/all/e048bbcd-a352-43e2-bef2-a08c12b27099@mail.ker=
nel.org/T/
>=20
> v3:
> - Ensure schedule entries truncated by an explicit cycle_time meet min_du=
ration in parse_taprio_schedule()
> - Clamp first entry end_time to cycle_time in setup_first_end_time()
> - Parse and validate schedule before applying netdev traffic class config=
uration in taprio_change()
> - Reject schedules with no entries in parse_taprio_schedule()
> - Update commit message to detail the serviceability guarantee, cycle tru=
ncation handling, and offload mode arithmetic
> https://lore.kernel.org/all/5a7fa927-7ed9-4c7b-82b8-97cb8fdadfc9@mail.ker=
nel.org/T/
>=20
> v2:
> - Enforce a minimum interval of 10 us (TAPRIO_MIN_SW_INTERVAL_NS) in soft=
ware mode instead of comparing cycle_time against the sum of intervals.
> - Add taprio_min_interval() helper to determine the minimum interval base=
d on offload and txtime-assist flags.
> - Use taprio_min_interval() in fill_sched_entry() and parse_taprio_schedu=
le().
> https://lore.kernel.org/all/edd30c9e-6673-42a0-ab07-b7fb2bb67795@mail.ker=
nel.org/T/
>=20
> v1:
> https://lore.kernel.org/all/3527dbf1-ab94-4184-8405-8552799efb71@mail.ker=
nel.org/T/
> ---
> diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
> index 39ac5b97a..54a84ac58 100644
> --- a/net/sched/sch_taprio.c
> +++ b/net/sched/sch_taprio.c
> @@ -48,6 +48,10 @@ static struct static_key_false taprio_have_working_mqp=
rio;
>   * 60 * 17 > PSEC_PER_NSEC (1000)
>   */
>  #define TAPRIO_PICOS_PER_BYTE_MIN 17
> +/* Minimum interval for software mode (hrtimer-driven advance_sched) to
> + * avoid hrtimer interrupt storms and CPU starvation.
> + */
> +#define TAPRIO_MIN_SW_INTERVAL_NS (10 * NSEC_PER_USEC)
> =20
>  struct sched_entry {
>  	/* Durations between this GCL entry and the GCL entry where the
> @@ -259,6 +263,17 @@ static int length_to_duration(struct taprio_sched *q=
, int len)
>  	return div_u64(len * atomic64_read(&q->picos_per_byte), PSEC_PER_NSEC);
>  }
> =20
> +static int taprio_min_interval(struct taprio_sched *q)
> +{
> +	int min_duration =3D length_to_duration(q, ETH_ZLEN);
> +
> +	if (!FULL_OFFLOAD_IS_ENABLED(q->flags) &&
> +	    !TXTIME_ASSIST_IS_ENABLED(q->flags))
> +		min_duration =3D max_t(int, min_duration, TAPRIO_MIN_SW_INTERVAL_NS);
> +
> +	return min_duration;
> +}
> +
>  static int duration_to_length(struct taprio_sched *q, u64 duration)
>  {
>  	return div_u64(duration * PSEC_PER_NSEC, atomic64_read(&q->picos_per_by=
te));
> @@ -270,7 +285,8 @@ static int duration_to_length(struct taprio_sched *q,=
 u64 duration)
>   */
>  static void taprio_update_queue_max_sdu(struct taprio_sched *q,
>  					struct sched_gate_list *sched,
> -					struct qdisc_size_table *stab)
> +					struct qdisc_size_table *stab,
> +					const u32 max_sdu_user[TC_MAX_QUEUE])
>  {
>  	struct net_device *dev =3D qdisc_dev(q->root);
>  	int num_tc =3D netdev_get_num_tc(dev);
> @@ -280,7 +296,7 @@ static void taprio_update_queue_max_sdu(struct taprio=
_sched *q,
>  	int tc;
> =20
>  	for (tc =3D 0; tc < num_tc; tc++) {
> -		max_sdu_from_user =3D q->max_sdu[tc] ?: U32_MAX;
> +		max_sdu_from_user =3D max_sdu_user[tc] ?: U32_MAX;
> =20
>  		/* TC gate never closes =3D> keep the queueMaxSDU
>  		 * selected by the user
> @@ -357,7 +373,7 @@ static struct sched_entry *find_entry_to_transmit(str=
uct sk_buff *skb,
>  		curr_intv_end =3D get_interval_end_time(sched, admin, entry,
>  						      curr_intv_start);
> =20
> -		if (ktime_after(curr_intv_start, cycle_end))
> +		if (ktime_compare(curr_intv_start, cycle_end) >=3D 0)
>  			break;
> =20
>  		if (!(entry->gate_mask & BIT(tc)) ||
> @@ -366,10 +382,10 @@ static struct sched_entry *find_entry_to_transmit(s=
truct sk_buff *skb,
> =20
>  		txtime =3D entry->next_txtime;
> =20
> -		if (ktime_before(txtime, time) || validate_interval) {
> +		if (!ktime_after(txtime, time) || validate_interval) {
>  			transmit_end_time =3D ktime_add_ns(time, packet_transmit_time);
> -			if ((ktime_before(curr_intv_start, time) &&
> -			     ktime_before(transmit_end_time, curr_intv_end)) ||
> +			if ((!ktime_after(curr_intv_start, time) &&
> +			     !ktime_after(transmit_end_time, curr_intv_end)) ||
>  			    (ktime_after(curr_intv_start, time) && !validate_interval)) {
>  				entry_found =3D entry;
>  				*interval_start =3D curr_intv_start;
> @@ -405,8 +421,19 @@ static bool is_valid_interval(struct sk_buff *skb, s=
truct Qdisc *sch)
>  	struct sched_entry *entry;
> =20
>  	rcu_read_lock();
> -	sched =3D rcu_dereference(q->oper_sched);
>  	admin =3D rcu_dereference(q->admin_sched);
> +	sched =3D rcu_dereference(q->oper_sched);
> +
> +	if (admin && !ktime_before(skb->tstamp, admin->base_time)) {
> +		sched =3D admin;
> +		admin =3D NULL;
> +	}
> +
> +	/* Until the schedule starts, all the queues are open */
> +	if (!sched || ktime_before(skb->tstamp, sched->base_time)) {
> +		rcu_read_unlock();
> +		return true;
> +	}
> =20
>  	entry =3D find_entry_to_transmit(skb, sch, sched, admin, skb->tstamp,
>  				       &interval_start, &interval_end, true);
> @@ -484,7 +511,7 @@ static long get_packet_txtime(struct sk_buff *skb, st=
ruct Qdisc *sch)
>  	rcu_read_lock();
>  	admin =3D rcu_dereference(q->admin_sched);
>  	sched =3D rcu_dereference(q->oper_sched);
> -	if (admin && ktime_after(minimum_time, admin->base_time))
> +	if (admin && !ktime_before(minimum_time, admin->base_time))
>  		switch_schedules(q, &admin, &sched);
> =20
>  	/* Until the schedule starts, all the queues are open */
> @@ -513,8 +540,9 @@ static long get_packet_txtime(struct sk_buff *skb, st=
ruct Qdisc *sch)
>  		txtime =3D max_t(ktime_t, txtime, interval_start);
> =20
>  		if (admin && admin !=3D sched &&
> -		    ktime_after(txtime, admin->base_time)) {
> +		    !ktime_before(txtime, admin->base_time)) {
>  			sched =3D admin;
> +			admin =3D NULL;
>  			sched_changed =3D true;
>  			continue;
>  		}
> @@ -888,7 +916,7 @@ static bool should_change_schedules(const struct sche=
d_gate_list *admin,
>  {
>  	ktime_t next_base_time, extension_time;
> =20
> -	if (!admin)
> +	if (!admin || !oper)
>  		return false;
> =20
>  	next_base_time =3D sched_base_time(admin);
> @@ -916,6 +944,126 @@ static bool should_change_schedules(const struct sc=
hed_gate_list *admin,
>  	return false;
>  }
> =20
> +static void taprio_advance_one_entry(struct taprio_sched *q,
> +				     struct sched_gate_list **p_oper,
> +				     struct sched_gate_list **p_admin,
> +				     struct sched_entry **p_entry,
> +				     struct sched_entry **p_next,
> +				     ktime_t *p_end_time,
> +				     int num_tc)
> +{
> +	struct sched_gate_list *oper =3D *p_oper;
> +	struct sched_gate_list *admin =3D *p_admin;
> +	struct sched_entry *entry =3D *p_entry;
> +	struct sched_entry *next;
> +	ktime_t end_time;
> +	int tc;
> +
> +	if (should_restart_cycle(oper, entry)) {
> +		next =3D list_first_entry(&oper->entries, struct sched_entry,
> +					list);
> +		oper->cycle_end_time =3D ktime_add_ns(oper->cycle_end_time,
> +						    oper->cycle_time);
> +	} else {
> +		next =3D list_next_entry(entry, list);
> +	}
> +
> +	end_time =3D ktime_add_ns(entry->end_time, next->interval);
> +	end_time =3D min_t(ktime_t, end_time, oper->cycle_end_time);
> +
> +	for (tc =3D 0; tc < num_tc; tc++) {
> +		if (next->gate_duration[tc] =3D=3D oper->cycle_time)
> +			next->gate_close_time[tc] =3D KTIME_MAX;
> +		else
> +			next->gate_close_time[tc] =3D ktime_add_ns(entry->end_time,
> +								 next->gate_duration[tc]);
> +	}
> +
> +	if (should_change_schedules(admin, oper, end_time)) {
> +		switch_schedules(q, &admin, &oper);
> +		*p_admin =3D admin;
> +		*p_oper =3D oper;
> +		next =3D list_first_entry(&oper->entries, struct sched_entry, list);
> +		end_time =3D next->end_time;
> +	}
> +
> +	next->end_time =3D end_time;
> +	taprio_set_budgets(q, oper, next);
> +
> +	*p_entry =3D next;
> +	*p_next =3D next;
> +	*p_end_time =3D end_time;
> +}
> +
> +static void taprio_fast_forward_sched(struct taprio_sched *q,
> +				      struct sched_gate_list **p_oper,
> +				      struct sched_gate_list **p_admin,
> +				      struct sched_entry **p_next,
> +				      ktime_t *p_end_time,
> +				      ktime_t now,
> +				      int num_tc)
> +{
> +	struct sched_gate_list *oper =3D *p_oper;
> +	struct sched_gate_list *admin =3D *p_admin;
> +	struct sched_entry *entry, *next;
> +	ktime_t end_time, cur_start;
> +	s64 diff;
> +	int tc;
> +
> +	if (admin && ktime_compare(sched_base_time(admin), now) <=3D 0)
> +		switch_schedules(q, &admin, &oper);
> +
> +	diff =3D ktime_sub(now, oper->cycle_end_time);
> +	if (diff >=3D 0) {
> +		u64 cycles =3D div64_u64(diff, oper->cycle_time) + 1;
> +
> +		oper->cycle_end_time =3D ktime_add_ns(oper->cycle_end_time,
> +						    cycles * oper->cycle_time);
> +	}
> +
> +	cur_start =3D ktime_sub_ns(oper->cycle_end_time, oper->cycle_time);
> +	next =3D list_last_entry(&oper->entries, struct sched_entry, list);
> +	end_time =3D oper->cycle_end_time;
> +
> +	list_for_each_entry(entry, &oper->entries, list) {
> +		ktime_t cur_end =3D ktime_add_ns(cur_start, entry->interval);
> +
> +		if (ktime_compare(cur_end, now) > 0) {
> +			next =3D entry;
> +			end_time =3D min_t(ktime_t, cur_end, oper->cycle_end_time);
> +			next->end_time =3D end_time;
> +			for (tc =3D 0; tc < num_tc; tc++) {
> +				u64 dur =3D next->gate_duration[tc];
> +
> +				if (dur =3D=3D oper->cycle_time)
> +					next->gate_close_time[tc] =3D KTIME_MAX;
> +				else
> +					next->gate_close_time[tc] =3D
> +						ktime_add_ns(cur_start, dur);
> +			}
> +			taprio_set_budgets(q, oper, next);
> +			break;
> +		}
> +		cur_start =3D cur_end;
> +	}
> +
> +	if (should_change_schedules(admin, oper, end_time)) {
> +		switch_schedules(q, &admin, &oper);
> +		next =3D list_first_entry(&oper->entries, struct sched_entry, list);
> +		end_time =3D next->end_time;
> +	}
> +
> +	if (unlikely(ktime_compare(end_time, now) <=3D 0)) {
> +		end_time =3D ktime_add_ns(now, taprio_min_interval(q));
> +		next->end_time =3D end_time;
> +	}
> +
> +	*p_oper =3D oper;
> +	*p_admin =3D admin;
> +	*p_next =3D next;
> +	*p_end_time =3D end_time;
> +}
> +
>  static enum hrtimer_restart advance_sched(struct hrtimer *timer)
>  {
>  	struct taprio_sched *q =3D container_of(timer, struct taprio_sched,
> @@ -925,8 +1073,7 @@ static enum hrtimer_restart advance_sched(struct hrt=
imer *timer)
>  	int num_tc =3D netdev_get_num_tc(dev);
>  	struct sched_entry *entry, *next;
>  	struct Qdisc *sch =3D q->root;
> -	ktime_t end_time;
> -	int tc;
> +	ktime_t end_time, now;
> =20
>  	spin_lock(&q->current_entry_lock);
>  	entry =3D rcu_dereference_protected(q->current_entry,
> @@ -939,6 +1086,13 @@ static enum hrtimer_restart advance_sched(struct hr=
timer *timer)
>  	if (!oper)
>  		switch_schedules(q, &admin, &oper);
> =20
> +	if (unlikely(!oper)) {
> +		spin_unlock(&q->current_entry_lock);
> +		return HRTIMER_NORESTART;
> +	}
> +
> +	now =3D taprio_get_time(q);
> +
>  	/* This can happen in two cases: 1. this is the very first run
>  	 * of this function (i.e. we weren't running any schedule
>  	 * previously); 2. The previous schedule just ended. The first
> @@ -949,42 +1103,26 @@ static enum hrtimer_restart advance_sched(struct h=
rtimer *timer)
>  		next =3D list_first_entry(&oper->entries, struct sched_entry,
>  					list);
>  		end_time =3D next->end_time;
> -		goto first_run;
> -	}
> -
> -	if (should_restart_cycle(oper, entry)) {
> -		next =3D list_first_entry(&oper->entries, struct sched_entry,
> -					list);
> -		oper->cycle_end_time =3D ktime_add_ns(oper->cycle_end_time,
> -						    oper->cycle_time);
>  	} else {
> -		next =3D list_next_entry(entry, list);
> +		taprio_advance_one_entry(q, &oper, &admin, &entry, &next,
> +					 &end_time, num_tc);
>  	}
> =20
> -	end_time =3D ktime_add_ns(entry->end_time, next->interval);
> -	end_time =3D min_t(ktime_t, end_time, oper->cycle_end_time);
> +	if (unlikely(ktime_compare(end_time, now) <=3D 0)) {
> +		size_t max_steps =3D min_t(size_t, oper->num_entries, 32);
> +		size_t i;
> =20
> -	for (tc =3D 0; tc < num_tc; tc++) {
> -		if (next->gate_duration[tc] =3D=3D oper->cycle_time)
> -			next->gate_close_time[tc] =3D KTIME_MAX;
> -		else
> -			next->gate_close_time[tc] =3D ktime_add_ns(entry->end_time,
> -								 next->gate_duration[tc]);
> -	}
> +		for (i =3D 0; i < max_steps && ktime_compare(end_time, now) <=3D 0; i+=
+) {
> +			entry =3D next;
> +			taprio_advance_one_entry(q, &oper, &admin, &entry, &next,
> +						 &end_time, num_tc);
> +		}
> =20
> -	if (should_change_schedules(admin, oper, end_time)) {
> -		switch_schedules(q, &admin, &oper);
> -		/* After changing schedules, the next entry is the first one
> -		 * in the new schedule, with a pre-calculated end_time.
> -		 */
> -		next =3D list_first_entry(&oper->entries, struct sched_entry, list);
> -		end_time =3D next->end_time;
> +		if (ktime_compare(end_time, now) <=3D 0)
> +			taprio_fast_forward_sched(q, &oper, &admin, &next,
> +						  &end_time, now, num_tc);
>  	}
> =20
> -	next->end_time =3D end_time;
> -	taprio_set_budgets(q, oper, next);
> -
> -first_run:
>  	rcu_assign_pointer(q->current_entry, next);
>  	spin_unlock(&q->current_entry_lock);
> =20
> @@ -1130,7 +1268,11 @@ static int parse_taprio_schedule(struct taprio_sch=
ed *q, struct nlattr **tb,
>  				 struct sched_gate_list *new,
>  				 struct netlink_ext_ack *extack)
>  {
> +	int min_duration =3D taprio_min_interval(q);
> +	struct sched_entry *entry, *n;
> +	s64 elapsed =3D 0;
>  	int err =3D 0;
> +	int i =3D 0;
> =20
>  	if (tb[TCA_TAPRIO_ATTR_SCHED_SINGLE_ENTRY]) {
>  		NL_SET_ERR_MSG(extack, "Adding a single entry is not supported");
> @@ -1152,8 +1294,12 @@ static int parse_taprio_schedule(struct taprio_sch=
ed *q, struct nlattr **tb,
>  	if (err < 0)
>  		return err;
> =20
> +	if (list_empty(&new->entries)) {
> +		NL_SET_ERR_MSG(extack, "There should be at least one entry in the sche=
dule");
> +		return -EINVAL;
> +	}
> +
>  	if (!new->cycle_time) {
> -		struct sched_entry *entry;
>  		ktime_t cycle =3D 0;
> =20
>  		list_for_each_entry(entry, &new->entries, list)
> @@ -1167,12 +1313,45 @@ static int parse_taprio_schedule(struct taprio_sc=
hed *q, struct nlattr **tb,
>  		new->cycle_time =3D cycle;
>  	}
> =20
> -	if (new->cycle_time < new->num_entries * length_to_duration(q, ETH_ZLEN=
)) {
> +	if (new->cycle_time < min_duration) {
>  		NL_SET_ERR_MSG(extack, "'cycle_time' is too small");
>  		return -EINVAL;
>  	}
> =20
> -	taprio_calculate_gate_durations(q, new);
> +	list_for_each_entry_safe(entry, n, &new->entries, list) {
> +		if (elapsed >=3D new->cycle_time) {
> +			list_del(&entry->list);
> +			kfree(entry);
> +			new->num_entries--;
> +			continue;
> +		}
> +
> +		if (elapsed + entry->interval > new->cycle_time) {
> +			entry->interval =3D new->cycle_time - elapsed;
> +			elapsed =3D new->cycle_time;
> +		} else {
> +			elapsed +=3D entry->interval;
> +		}
> +	}
> +
> +	if (list_empty(&new->entries)) {
> +		NL_SET_ERR_MSG(extack, "There should be at least one entry in the sche=
dule");
> +		return -EINVAL;
> +	}
> +
> +	if (elapsed < new->cycle_time) {
> +		entry =3D list_last_entry(&new->entries, struct sched_entry, list);
> +		entry->interval +=3D new->cycle_time - elapsed;
> +	}
> +
> +	list_for_each_entry(entry, &new->entries, list) {
> +		if (entry->interval < min_duration) {
> +			NL_SET_ERR_MSG(extack, "Invalid interval for schedule entry");
> +			return -EINVAL;
> +		}
> +		entry->index =3D i++;
> +	}
> +	new->num_entries =3D i;
> =20
>  	return 0;
>  }
> @@ -1256,7 +1435,7 @@ static void setup_first_end_time(struct taprio_sche=
d *q,
>  	/* FIXME: find a better place to do this */
>  	sched->cycle_end_time =3D ktime_add_ns(base, cycle);
> =20
> -	first->end_time =3D ktime_add_ns(base, first->interval);
> +	first->end_time =3D ktime_add_ns(base, min_t(s64, first->interval, cycl=
e));
>  	taprio_set_budgets(q, sched, first);
> =20
>  	for (tc =3D 0; tc < num_tc; tc++) {
> @@ -1349,11 +1528,11 @@ static int taprio_dev_notifier(struct notifier_bl=
ock *nb, unsigned long event,
>  		rcu_read_lock();
>  		oper =3D rcu_dereference(q->oper_sched);
>  		if (oper)
> -			taprio_update_queue_max_sdu(q, oper, stab);
> +			taprio_update_queue_max_sdu(q, oper, stab, q->max_sdu);
> =20
>  		admin =3D rcu_dereference(q->admin_sched);
>  		if (admin)
> -			taprio_update_queue_max_sdu(q, admin, stab);
> +			taprio_update_queue_max_sdu(q, admin, stab, q->max_sdu);
>  		rcu_read_unlock();
> =20
>  		break;
> @@ -1516,6 +1695,8 @@ static void taprio_cleanup_broken_mqprio(struct tap=
rio_sched *q)
>  static int taprio_enable_offload(struct net_device *dev,
>  				 struct taprio_sched *q,
>  				 struct sched_gate_list *sched,
> +				 const u32 max_sdu[TC_MAX_QUEUE],
> +				 u32 fp[TC_QOPT_MAX_QUEUE],
>  				 struct netlink_ext_ack *extack)
>  {
>  	const struct net_device_ops *ops =3D dev->netdev_ops;
> @@ -1534,7 +1715,7 @@ static int taprio_enable_offload(struct net_device =
*dev,
> =20
>  	if (!caps.supports_queue_max_sdu) {
>  		for (tc =3D 0; tc < TC_MAX_QUEUE; tc++) {
> -			if (q->max_sdu[tc]) {
> +			if (max_sdu[tc]) {
>  				NL_SET_ERR_MSG_MOD(extack,
>  						   "Device does not handle queueMaxSDU");
>  				return -EOPNOTSUPP;
> @@ -1553,10 +1734,10 @@ static int taprio_enable_offload(struct net_devic=
e *dev,
>  	mqprio_qopt_reconstruct(dev, &offload->mqprio.qopt);
>  	offload->mqprio.extack =3D extack;
>  	taprio_sched_to_offload(dev, sched, offload, &caps);
> -	mqprio_fp_to_offload(q->fp, &offload->mqprio);
> +	mqprio_fp_to_offload(fp, &offload->mqprio);
> =20
>  	for (tc =3D 0; tc < TC_MAX_QUEUE; tc++)
> -		offload->max_sdu[tc] =3D q->max_sdu[tc];
> +		offload->max_sdu[tc] =3D max_sdu[tc];
> =20
>  	err =3D ops->ndo_setup_tc(dev, TC_SETUP_QDISC_TAPRIO, offload);
>  	if (err < 0) {
> @@ -1747,14 +1928,14 @@ static int taprio_parse_tc_entry(struct Qdisc *sc=
h,
> =20
>  static int taprio_parse_tc_entries(struct Qdisc *sch,
>  				   struct nlattr *opt,
> +				   u32 max_sdu[TC_MAX_QUEUE],
> +				   u32 fp[TC_QOPT_MAX_QUEUE],
>  				   struct netlink_ext_ack *extack)
>  {
>  	struct taprio_sched *q =3D qdisc_priv(sch);
>  	struct net_device *dev =3D qdisc_dev(sch);
> -	u32 max_sdu[TC_QOPT_MAX_QUEUE];
>  	bool have_preemption =3D false;
>  	unsigned long seen_tcs =3D 0;
> -	u32 fp[TC_QOPT_MAX_QUEUE];
>  	struct nlattr *n;
>  	int tc, rem;
>  	int err =3D 0;
> @@ -1772,8 +1953,6 @@ static int taprio_parse_tc_entries(struct Qdisc *sc=
h,
>  	}
> =20
>  	for (tc =3D 0; tc < TC_QOPT_MAX_QUEUE; tc++) {
> -		WRITE_ONCE(q->max_sdu[tc], max_sdu[tc]);
> -		WRITE_ONCE(q->fp[tc], fp[tc]);
>  		if (fp[tc] !=3D TC_FP_EXPRESS)
>  			have_preemption =3D true;
>  	}
> @@ -1792,7 +1971,7 @@ static int taprio_parse_tc_entries(struct Qdisc *sc=
h,
>  		}
>  	}
> =20
> -	return err;
> +	return 0;
>  }
> =20
>  static int taprio_mqprio_cmp(const struct net_device *dev,
> @@ -1825,13 +2004,27 @@ static int taprio_change(struct Qdisc *sch, struc=
t nlattr *opt,
>  	struct qdisc_size_table *stab =3D rtnl_dereference(sch->stab);
>  	struct nlattr *tb[TCA_TAPRIO_ATTR_MAX + 1] =3D { };
>  	struct sched_gate_list *oper, *admin, *new_admin;
> +	enum tk_offsets old_tk_offset;
>  	struct taprio_sched *q =3D qdisc_priv(sch);
>  	struct net_device *dev =3D qdisc_dev(sch);
>  	struct tc_mqprio_qopt *mqprio =3D NULL;
> +	u32 max_sdu[TC_MAX_QUEUE] =3D { };
> +	u32 fp[TC_QOPT_MAX_QUEUE] =3D { };
> +	bool tc_configured =3D false;
> +	int old_clockid, i, err;
>  	unsigned long flags;
> +	bool initial_setup;
>  	u32 taprio_flags;
> +	u32 old_flags;
>  	ktime_t start;
> -	int i, err;
> +
> +	oper =3D rtnl_dereference(q->oper_sched);
> +	admin =3D rtnl_dereference(q->admin_sched);
> +	initial_setup =3D (!oper && !admin);
> +
> +	old_flags =3D q->flags;
> +	old_clockid =3D q->clockid;
> +	old_tk_offset =3D q->tk_offset;
> =20
>  	err =3D nla_parse_nested_deprecated(tb, TCA_TAPRIO_ATTR_MAX, opt,
>  					  taprio_policy, extack);
> @@ -1866,41 +2059,62 @@ static int taprio_change(struct Qdisc *sch, struc=
t nlattr *opt,
>  		WRITE_ONCE(q->flags, taprio_flags);
>  	}
> =20
> +	if (tb[TCA_TAPRIO_ATTR_TXTIME_DELAY]) {
> +		if (!TXTIME_ASSIST_IS_ENABLED(q->flags)) {
> +			NL_SET_ERR_MSG_MOD(extack, "txtime-delay can only be set when txtime-=
assist mode is enabled");
> +			err =3D -EINVAL;
> +			goto free_sched;
> +		}
> +	}
> +
>  	/* Needed for length_to_duration() during netlink attribute parsing */
>  	taprio_set_picos_per_byte(dev, q, extack);
> =20
>  	err =3D taprio_parse_mqprio_opt(dev, mqprio, extack, q->flags);
>  	if (err < 0)
> -		return err;
> +		goto free_sched;
> =20
> -	err =3D taprio_parse_tc_entries(sch, opt, extack);
> +	err =3D taprio_parse_tc_entries(sch, opt, max_sdu, fp, extack);
>  	if (err)
> -		return err;
> +		goto free_sched;
> =20
>  	new_admin =3D kzalloc_obj(*new_admin);
>  	if (!new_admin) {
>  		NL_SET_ERR_MSG(extack, "Not enough memory for a new schedule");
> -		return -ENOMEM;
> +		err =3D -ENOMEM;
> +		goto free_sched;
>  	}
>  	INIT_LIST_HEAD(&new_admin->entries);
> =20
> -	oper =3D rtnl_dereference(q->oper_sched);
> -	admin =3D rtnl_dereference(q->admin_sched);
> -
>  	/* no changes - no new mqprio settings */
>  	if (!taprio_mqprio_cmp(dev, mqprio))
>  		mqprio =3D NULL;
> =20
> -	if (mqprio && (oper || admin)) {
> +	if (mqprio && !initial_setup) {
>  		NL_SET_ERR_MSG(extack, "Changing the traffic mapping of a running sche=
dule is not supported");
>  		err =3D -ENOTSUPP;
>  		goto free_sched;
>  	}
> =20
> +	err =3D parse_taprio_schedule(q, tb, new_admin, extack);
> +	if (err < 0)
> +		goto free_sched;
> +
> +	if (new_admin->num_entries =3D=3D 0) {
> +		NL_SET_ERR_MSG(extack, "There should be at least one entry in the sche=
dule");
> +		err =3D -EINVAL;
> +		goto free_sched;
> +	}
> +
> +	err =3D taprio_parse_clockid(sch, tb, extack);
> +	if (err < 0)
> +		goto free_sched;
> +
>  	if (mqprio) {
>  		err =3D netdev_set_num_tc(dev, mqprio->num_tc);
>  		if (err)
>  			goto free_sched;
> +		tc_configured =3D true;
>  		for (i =3D 0; i < mqprio->num_tc; i++) {
>  			netdev_set_tc_queue(dev, i,
>  					    mqprio->count[i],
> @@ -1914,24 +2128,12 @@ static int taprio_change(struct Qdisc *sch, struc=
t nlattr *opt,
>  					       mqprio->prio_tc_map[i]);
>  	}
> =20
> -	err =3D parse_taprio_schedule(q, tb, new_admin, extack);
> -	if (err < 0)
> -		goto free_sched;
> +	taprio_calculate_gate_durations(q, new_admin);
> =20
> -	if (new_admin->num_entries =3D=3D 0) {
> -		NL_SET_ERR_MSG(extack, "There should be at least one entry in the sche=
dule");
> -		err =3D -EINVAL;
> -		goto free_sched;
> -	}
> -
> -	err =3D taprio_parse_clockid(sch, tb, extack);
> -	if (err < 0)
> -		goto free_sched;
> -
> -	taprio_update_queue_max_sdu(q, new_admin, stab);
> +	taprio_update_queue_max_sdu(q, new_admin, stab, max_sdu);
> =20
>  	if (FULL_OFFLOAD_IS_ENABLED(q->flags))
> -		err =3D taprio_enable_offload(dev, q, new_admin, extack);
> +		err =3D taprio_enable_offload(dev, q, new_admin, max_sdu, fp, extack);
>  	else
>  		err =3D taprio_disable_offload(dev, q, extack);
>  	if (err)
> @@ -1940,15 +2142,10 @@ static int taprio_change(struct Qdisc *sch, struc=
t nlattr *opt,
>  	/* Protects against enqueue()/dequeue() */
>  	spin_lock_bh(qdisc_lock(sch));
> =20
> -	if (tb[TCA_TAPRIO_ATTR_TXTIME_DELAY]) {
> -		if (!TXTIME_ASSIST_IS_ENABLED(q->flags)) {
> -			NL_SET_ERR_MSG_MOD(extack, "txtime-delay can only be set when txtime-=
assist mode is enabled");
> -			err =3D -EINVAL;
> -			goto unlock;
> -		}
> -
> -		WRITE_ONCE(q->txtime_delay,
> -			   nla_get_u32(tb[TCA_TAPRIO_ATTR_TXTIME_DELAY]));
> +	err =3D taprio_get_start_time(sch, new_admin, &start);
> +	if (err < 0) {
> +		NL_SET_ERR_MSG(extack, "Internal error: failed get start time");
> +		goto unlock;
>  	}
> =20
>  	if (!TXTIME_ASSIST_IS_ENABLED(q->flags) &&
> @@ -1957,11 +2154,14 @@ static int taprio_change(struct Qdisc *sch, struc=
t nlattr *opt,
>  		hrtimer_setup(&q->advance_timer, advance_sched, q->clockid, HRTIMER_MO=
DE_ABS);
>  	}
> =20
> -	err =3D taprio_get_start_time(sch, new_admin, &start);
> -	if (err < 0) {
> -		NL_SET_ERR_MSG(extack, "Internal error: failed get start time");
> -		goto unlock;
> -	}
> +	if (tb[TCA_TAPRIO_ATTR_TXTIME_DELAY])
> +		WRITE_ONCE(q->txtime_delay,
> +			   nla_get_u32(tb[TCA_TAPRIO_ATTR_TXTIME_DELAY]));
> +
> +	for (i =3D 0; i < TC_MAX_QUEUE; i++)
> +		WRITE_ONCE(q->max_sdu[i], max_sdu[i]);
> +	for (i =3D 0; i < TC_QOPT_MAX_QUEUE; i++)
> +		WRITE_ONCE(q->fp[i], fp[i]);
> =20
>  	setup_txtime(q, new_admin, start);
> =20
> @@ -2008,6 +2208,16 @@ static int taprio_change(struct Qdisc *sch, struct=
 nlattr *opt,
>  	spin_unlock_bh(qdisc_lock(sch));
> =20
>  free_sched:
> +	if (err && initial_setup) {
> +		if (tc_configured) {
> +			netdev_reset_tc(dev);
> +			memset(q->cur_txq, 0, sizeof(q->cur_txq));
> +		}
> +		WRITE_ONCE(q->flags, old_flags);
> +		q->clockid =3D old_clockid;
> +		WRITE_ONCE(q->tk_offset, old_tk_offset);
> +	}
> +
>  	if (new_admin)
>  		call_rcu(&new_admin->rcu, taprio_free_sched_cb);
> =20
>=20
>=20
> base-commit: cee9395acd8043be0644b25c34bfa86623f2b935
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
