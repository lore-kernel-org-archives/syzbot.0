Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.47
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793980626;
	b=wcBN67X08ZB37+JEtQIwUKwxwpV9Ss4sBdG1j8tY7Tm2F1gPH841BfBHPKgQDBKsu6YI
	 4ORSSQzG92u2qKt53MVHABkPFHKIFhy+P67w5FGdCIRTSMKOtLSqUnVNsGJDUma3TjETl
	 eYtF0+OJO5EcHezT4zWC5k61Yab6bZ1+djkmZdIPkbBzqW2rnzrxrtYJ8NwI6Gl82Dv9E
	 /TGgZXP/6WpCraAxszpyPKkLQlnPNz36MT0gWw/27NeFio2IUD/U5uplg3OJ/1CCFUP24
	 4lLzv6OS0kHRZeEW0k1ERW/CC7fvUq488zSQti8943Si41eNLVjCHh0js1Br4zYa85w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793980626;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:Content-Transfer-Encoding:
	 In-Reply-To;
	bh=naUvG6pVrhfQA7vgV9cYiMzfX9+rENLj0i6OpnRN6C4=;
	b=mLYK1JyBNoGKjC/bbYv5QSivPbgrQ3TrjdXk3ey6ij2BGWSRUafLjJTLnsi11Feg8fK6
	 Ew6+clZ9Zng3n2GMn+8dUpLD6nINb+ZV5y0Ylzw0kqF8T914e7Qhv9YNyYLM9y5kUolEU
	 i6AlK0EG3tPxs4aGDlBFBgtQSXsH2vSBdwkde51UEalSHSesilgqRekJwx1IQ6IAGYWZm
	 q49XCPHvDWW0VdiTu3MNmS0syl1uahkIIkTm3KiyvAs7DulN3Xx+g+W8FvBhPiAJHPc1M
	 fJ20H6U5GRXEOT2CXlgNdA3WzTCcotavD3nysNn2FJptuJM5VfXlBla+J77Eb9sQM0Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=fXpkhWt7;
	arc=none smtp.remote-ip=209.85.218.47
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7DCD606A326
	for <syzbot@lists.linux.dev>; Fri,  6 Nov 2026 15:57:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D7DCD606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=fXpkhWt7
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-c4cb6834eaaso115663966b.2
        for <syzbot@lists.linux.dev>; Fri, 06 Nov 2026 07:57:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793980623; x=1794585423; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=naUvG6pVrhfQA7vgV9cYiMzfX9+rENLj0i6OpnRN6C4=;
        b=fXpkhWt7GotpMwdEP0jTWHlxTUjeCEviWum7m7yRBurLnNubFdVVZ53+kPqBfUjpsK
         NTkGIr9vndyA4PTKnrL2XfKuQwdCcWDii9wp7xoQtoQF3zdnqwHSi8WEhFdKaM9+hMEu
         2/lGy6r7TBzSGJJQvL/vBghLOIQF62VIUqTY15xpSJv50MzO8pdJWeeST7MrrWqJ6Ld/
         iTPzmYiI0WvYIx4koSN3eeYU8DBPR/sJcW5UHOHtfyUN0RREtElpOHXGFyiaeyuvjKFM
         56Bo3g2DKvQ/bu4B/pB1XVJIWAjV70lw3sF8ASqXHPvCGg2lFiWywRoi/U5esVfcHkTM
         3rFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793980623; x=1794585423;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=naUvG6pVrhfQA7vgV9cYiMzfX9+rENLj0i6OpnRN6C4=;
        b=oVP/8/42cZGgOGhEQLcnObJcZs72GAQjzR14H5Kpf1KfRn+NwGA3vTJanvAF9LyXh2
         TfonZRnNPQNR4ZuhbMF8nfIwFh+B58ooVx7QHwtI4sYc2ZzN/cI0enl20Mh+iT9FHCUj
         OeE20CDKJJCanpJE0uPQZ+hJByNQZj8E/Q+DRh62DzqBdd6fIZeoufU2r4VUxLUlcX24
         2c1DvpLsLJbnVY6rSDxwdm2Tvd3jmOuc/lZ/9BvMDAesMpNOAIWZh5E6LrOC4Yp7a731
         YFFQrror+5HqRHSvgLOg7HYuA91NSydZH8x72hBxm/DjgED0fqnP6A4qhtzGMBRuS+gM
         gUOg==
X-Forwarded-Encrypted: i=1; AKwUvBwCgMmNRQuyoiJldHasoaCpz7+svsuwognCPD78YtxH1ndObgATQlBDOoA0asOo5xZbjirrP+s=@lists.linux.dev
X-Gm-Message-State: APuU4Z/YH1FN7ourJEXrB0HM4FqHoEaFtZUc+qE24IEFUq7NDGm7WUfL
	G0NHm+A5xNHXpcqqpdCaVSwALetfW82f7XHWguL5HoRFOMV8BwZjde8r
X-Gm-Gg: AYBFou1IYMmLPRVqWh+X+FotsSTQEMc5j/kKlIO7tfPDdaa/v1D1yrctEUFcTmKYm7D
	oM33asv4G4L1GTWGF0l0UPNAHJmBFjX9lwSSMTwsg9Rm1xrlBMubIuPFArsR+Q8KSDD0MwLLuQt
	Knsx2k59mOGeyD96at7ta5+rIYMApR+9/fvI+I5qhHW+yGbG7cx6bPH94e4zRmjyOKvUY4t/YDm
	CvzsFYNAf2ZBi2+GQV3l6HC3bOuND2boUkPYo6ZxOExXZsQJdGs3Iwa7AI+lsR5nXKBpATM0oww
	mY0y0pamJG9aF2of+e6f2h8jf2iYpjbct624PDzsg/UnXGCgqIaOnDLpZjC2AVVYMUi8PDqnquJ
	oF+BigBek0higxZWQ1Jr3vaBV1TIvv/U8AyPP/B5ZLjTjDcWPOcu+Tq1DdniIZqY2kzf7GIXYrd
	vUtD7+iSjdQtRxArv1Vm/PS2rGExoGCDWoWo9SX0C1hEDUUjh1ZH5XIM30AEw4/N3MUSlZeiLJs
	VoYAN5VMGsZYgkfjmSmFAV5fRis+QgMJJ2USgwDnGrybtW3eEypx6aBGFJEgclL52HgucBq23sf
	NXrTCZn7VddGqJzerC4zw9OM9nTXF5T95qtUGZKc5nUg9mA=
X-Received: by 2002:a17:906:f5a4:b0:c33:923b:ad66 with SMTP id a640c23a62f3a-c4d3560f024mr259210766b.43.1793980622660;
        Fri, 06 Nov 2026 07:57:02 -0800 (PST)
Received: from localhost ([188.146.174.10])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c4d35631eb2sm90378866b.27.2026.11.06.07.57.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Nov 2026 07:57:02 -0800 (PST)
Date: Fri, 6 Nov 2026 16:57:01 +0100
From: Bartosz Chronowski <immersa.bartosz.chronowski@gmail.com>
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Subject: Re: [PATCH RFC v7] net/sched: taprio: enforce minimum interval in
 software mode
Message-ID: <g6sqbkukas4a6a2en2fe3juclh4qke5gl6kw5ptgeom2d2lode@tom6skhrrbdz>
References: <dab7733a-1093-4eca-a7a7-3b62f5bd05a7@mail.kernel.org>
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
In-Reply-To: <dab7733a-1093-4eca-a7a7-3b62f5bd05a7@mail.kernel.org>

Version 7 makes material progress, but the fallback administrative switch c=
an
still select the wrong schedule phase, and the code does not establish a
strictly future expiry at the actual timer arm. The patch builds on its sta=
ted
base, but deterministic timing checks fail and the runtime comparison is
inconclusive, so the patch still needs changes.

Required changes:

- Keep the software-only admission floor, normalized entries, finite
  32-step/one-scan catch-up, deferred traffic-class mutation, and guarded
  failed-initialization cleanup.

- When the fallback promotes an administrative schedule, derive the cycle
  start, active entry, gate-close time, packet budget, and deadline together
  from that schedule's base and cycle phase. Do not initialize the promoted
  entry from the earlier sampled now value.

- Take a fresh time sample at the actual timer-arm boundary, or use a
  timer-core-relative mechanism whose future-expiry property is guaranteed =
at
  the arm point. Narrow the patch description until the implementation prov=
es
  that guarantee.

- Add deterministic coverage for administrative bases just before, equal to,
  inside, and after the fallback deadline. Also cover accepted-minimum and
  large-list timing, explicit-cycle clipping and padding, TXTIME assist, fu=
ll
  offload, and failed setup after offload. Fix the remaining 118-column ext=
ack
  line and refresh the patch so it applies to current mainline.

Testing:
The historical, stated-base unpatched, and stated-base patched kernels all
built. Each runtime lane used four virtual machines for 240 seconds, and the
reproducer started in every lane without a target crash. Both unpatched
controls also produced no crash, so those runs do not show that the patch f=
ixes
the reported bug. Source-bound checks fail the late administrative-switch
phase/deadline case and the strict-future-at-actual-arm case. The patch also
conflicts when forward-applied to the current mainline snapshot. Default and
strict checkpatch each report 0 errors and 1 warning.

Context:
The 10 microsecond software floor blocks the reported 334 nanosecond schedu=
le,
and the callback no longer contains the earlier repeated unbounded scan. Th=
is
version also moves live traffic-class mutation after parsing and offload se=
tup
and avoids resetting that state when failed initialization published no
schedule. Those changes should remain. The remaining blockers are confined =
to
the late fallback's phase derivation and the final rearm boundary, so the
current TAPRIO direction is still suitable for another focused revision.

Impact assessment:
The demonstrated impact is CPU availability and scheduler liveness, includi=
ng
the reported RCU stall. The fallback phase error can also select incorrect
gate timing or packet budget. The current evidence does not establish
information disclosure, privilege escalation, direct memory corruption, or
practical exploitability.

Kind Regards / Mit freundlichen Gr=C3=BC=C3=9Fen
BART CHRONOWSKI


On Fri, Oct 23, 2026 at 02:57:15PM +0000, syzbot wrote:
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
> for at most 32 entries before calling taprio_fast_forward_sched(). The
> fast-forward path advances full cycles via 64-bit division and performs a
> single non-looping scan over the effective entries list to locate the
> active entry. If the target expiration is still not in the future, it
> performs at most one additional entry advance step, and if still
> non-future, clamps the expiration time to at least taprio_min_interval(q)
> ahead of current time. This bounds total timer-callback work to at most 33
> single-step transitions plus a single pass over the schedule entries list,
> and guarantees that the timer is always rearmed strictly in the future,
> preventing advance_sched() from getting trapped in an hrtimer interrupt
> loop.
>=20
> Finally, parse and validate the schedule and offload parameters in
> taprio_change() before modifying device traffic classes, deferring
> netdev_set_num_tc() until after validation and offload configuration
> succeed so error paths require no netdev rollback. In taprio_destroy(),
> only reset device traffic classes if a schedule was previously active. In
> addition, stage max_sdu and fp configurations locally until commit time,
> pass num_tc explicitly to gate duration and max SDU calculations, and
> reject empty schedules.
>=20
> Fixes: 5a781ccbd19e ("tc: Add support for configuring the taprio schedule=
r")
> Assisted-by: Gemini:gemini-4-argon Gemini:gemini-3.8-flash syzbot
> Reported-by: syzbot+14c6ac6811273526cfa5@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3D14c6ac6811273526cfa5
> Link: https://syzkaller.appspot.com/ai_job?id=3D15dc3d09-e7a6-4edf-8143-a=
eb75a243164
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
> v7:
> - In advance_sched(), removed loops around and inside taprio_fast_forward=
_sched() to bound entry list scanning to a single pass.
> - In advance_sched(), guaranteed strictly future timer rearming by clampi=
ng expiration to taprio_min_interval() ahead of current time if fast-forwar=
ding still produces a past timestamp.
> - In taprio_change(), deferred modifying netdev traffic classes until aft=
er offload setup succeeds, avoiding netdev state rollback on error.
> - Passed num_tc explicitly to taprio_calculate_gate_durations() and tapri=
o_update_queue_max_sdu(), and passed mqprio to taprio_enable_offload().
> - In taprio_destroy(), only reset netdev traffic classes if a schedule wa=
s active.
> - Fixed should_restart_cycle() to check if end_time is greater than or eq=
ual to cycle_end_time.
>=20
> v6:
> - Factor out entry gate close time and budget calculation into taprio_set=
_entry_state().
> - Correctly compute entry start and end times on initial run and schedule=
 switch in advance_sched().
> - Loop taprio_fast_forward_sched() when expiry is in the past and remove =
the artificial interval clamp.
> - Set advance_timer expiration under current_entry_lock in advance_sched(=
).
> - Save and restore previous netdev traffic class configuration on error i=
n taprio_change() instead of calling netdev_reset_tc().
> https://lore.kernel.org/all/bead33e5-6249-40fb-aaaf-58117e6ee7b8@mail.ker=
nel.org/T/
>=20
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
> https://lore.kernel.org/all/9e73068d-a591-4830-a002-b08d999679fb@mail.ker=
nel.org/T/
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
> index 39ac5b97a..ff45b866b 100644
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
> @@ -117,10 +121,9 @@ struct __tc_taprio_qopt_offload {
>  };
> =20
>  static void taprio_calculate_gate_durations(struct taprio_sched *q,
> -					    struct sched_gate_list *sched)
> +					    struct sched_gate_list *sched,
> +					    int num_tc)
>  {
> -	struct net_device *dev =3D qdisc_dev(q->root);
> -	int num_tc =3D netdev_get_num_tc(dev);
>  	struct sched_entry *entry, *cur;
>  	int tc;
> =20
> @@ -259,6 +262,17 @@ static int length_to_duration(struct taprio_sched *q=
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
> @@ -270,17 +284,18 @@ static int duration_to_length(struct taprio_sched *=
q, u64 duration)
>   */
>  static void taprio_update_queue_max_sdu(struct taprio_sched *q,
>  					struct sched_gate_list *sched,
> -					struct qdisc_size_table *stab)
> +					struct qdisc_size_table *stab,
> +					const u32 max_sdu_user[TC_MAX_QUEUE],
> +					int num_tc)
>  {
>  	struct net_device *dev =3D qdisc_dev(q->root);
> -	int num_tc =3D netdev_get_num_tc(dev);
>  	u32 max_sdu_from_user;
>  	u32 max_sdu_dynamic;
>  	u32 max_sdu;
>  	int tc;
> =20
>  	for (tc =3D 0; tc < num_tc; tc++) {
> -		max_sdu_from_user =3D q->max_sdu[tc] ?: U32_MAX;
> +		max_sdu_from_user =3D max_sdu_user[tc] ?: U32_MAX;
> =20
>  		/* TC gate never closes =3D> keep the queueMaxSDU
>  		 * selected by the user
> @@ -357,7 +372,7 @@ static struct sched_entry *find_entry_to_transmit(str=
uct sk_buff *skb,
>  		curr_intv_end =3D get_interval_end_time(sched, admin, entry,
>  						      curr_intv_start);
> =20
> -		if (ktime_after(curr_intv_start, cycle_end))
> +		if (ktime_compare(curr_intv_start, cycle_end) >=3D 0)
>  			break;
> =20
>  		if (!(entry->gate_mask & BIT(tc)) ||
> @@ -366,10 +381,10 @@ static struct sched_entry *find_entry_to_transmit(s=
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
> @@ -405,8 +420,19 @@ static bool is_valid_interval(struct sk_buff *skb, s=
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
> @@ -484,7 +510,7 @@ static long get_packet_txtime(struct sk_buff *skb, st=
ruct Qdisc *sch)
>  	rcu_read_lock();
>  	admin =3D rcu_dereference(q->admin_sched);
>  	sched =3D rcu_dereference(q->oper_sched);
> -	if (admin && ktime_after(minimum_time, admin->base_time))
> +	if (admin && !ktime_before(minimum_time, admin->base_time))
>  		switch_schedules(q, &admin, &sched);
> =20
>  	/* Until the schedule starts, all the queues are open */
> @@ -513,8 +539,9 @@ static long get_packet_txtime(struct sk_buff *skb, st=
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
> @@ -876,7 +903,7 @@ static bool should_restart_cycle(const struct sched_g=
ate_list *oper,
>  	if (list_is_last(&entry->list, &oper->entries))
>  		return true;
> =20
> -	if (ktime_compare(entry->end_time, oper->cycle_end_time) =3D=3D 0)
> +	if (ktime_compare(entry->end_time, oper->cycle_end_time) >=3D 0)
>  		return true;
> =20
>  	return false;
> @@ -888,7 +915,7 @@ static bool should_change_schedules(const struct sche=
d_gate_list *admin,
>  {
>  	ktime_t next_base_time, extension_time;
> =20
> -	if (!admin)
> +	if (!admin || !oper)
>  		return false;
> =20
>  	next_base_time =3D sched_base_time(admin);
> @@ -916,6 +943,149 @@ static bool should_change_schedules(const struct sc=
hed_gate_list *admin,
>  	return false;
>  }
> =20
> +static void taprio_set_entry_state(struct taprio_sched *q,
> +				   struct sched_gate_list *oper,
> +				   struct sched_entry *next,
> +				   ktime_t cur_start,
> +				   ktime_t end_time,
> +				   int num_tc)
> +{
> +	int tc;
> +
> +	for (tc =3D 0; tc < num_tc; tc++) {
> +		if (next->gate_duration[tc] =3D=3D oper->cycle_time)
> +			next->gate_close_time[tc] =3D KTIME_MAX;
> +		else
> +			next->gate_close_time[tc] =3D ktime_add_ns(cur_start,
> +								 next->gate_duration[tc]);
> +	}
> +
> +	next->end_time =3D end_time;
> +	taprio_set_budgets(q, oper, next);
> +}
> +
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
> +	ktime_t cur_start, end_time;
> +	struct sched_entry *next;
> +
> +	if (!oper->cycle_end_time)
> +		oper->cycle_end_time =3D ktime_add_ns(sched_base_time(oper),
> +						    oper->cycle_time);
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
> +	cur_start =3D entry->end_time;
> +	end_time =3D ktime_add_ns(cur_start, next->interval);
> +	end_time =3D min_t(ktime_t, end_time, oper->cycle_end_time);
> +
> +	if (should_change_schedules(admin, oper, end_time)) {
> +		switch_schedules(q, &admin, &oper);
> +		if (!oper->cycle_end_time)
> +			oper->cycle_end_time =3D ktime_add_ns(sched_base_time(oper),
> +							    oper->cycle_time);
> +		cur_start =3D ktime_sub_ns(oper->cycle_end_time,
> +					 oper->cycle_time);
> +		next =3D list_first_entry(&oper->entries, struct sched_entry, list);
> +		end_time =3D ktime_add_ns(cur_start, next->interval);
> +		end_time =3D min_t(ktime_t, end_time, oper->cycle_end_time);
> +		*p_admin =3D admin;
> +		*p_oper =3D oper;
> +	}
> +
> +	taprio_set_entry_state(q, oper, next, cur_start, end_time, num_tc);
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
> +
> +	if (admin && ktime_compare(sched_base_time(admin), now) <=3D 0)
> +		switch_schedules(q, &admin, &oper);
> +
> +	if (!oper->cycle_end_time)
> +		oper->cycle_end_time =3D ktime_add_ns(sched_base_time(oper),
> +						    oper->cycle_time);
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
> +		if (list_is_last(&entry->list, &oper->entries))
> +			cur_end =3D oper->cycle_end_time;
> +		else
> +			cur_end =3D min_t(ktime_t, cur_end, oper->cycle_end_time);
> +
> +		if (ktime_compare(cur_end, now) > 0) {
> +			next =3D entry;
> +			end_time =3D cur_end;
> +			break;
> +		}
> +		cur_start =3D cur_end;
> +	}
> +
> +	if (should_change_schedules(admin, oper, end_time)) {
> +		switch_schedules(q, &admin, &oper);
> +		if (!oper->cycle_end_time)
> +			oper->cycle_end_time =3D ktime_add_ns(sched_base_time(oper),
> +							    oper->cycle_time);
> +		cur_start =3D ktime_sub_ns(oper->cycle_end_time,
> +					 oper->cycle_time);
> +		next =3D list_first_entry(&oper->entries, struct sched_entry,
> +					list);
> +		end_time =3D ktime_add_ns(cur_start, next->interval);
> +		end_time =3D min_t(ktime_t, end_time, oper->cycle_end_time);
> +	}
> +
> +	taprio_set_entry_state(q, oper, next, cur_start, end_time, num_tc);
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
> @@ -925,8 +1095,7 @@ static enum hrtimer_restart advance_sched(struct hrt=
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
> @@ -939,6 +1108,11 @@ static enum hrtimer_restart advance_sched(struct hr=
timer *timer)
>  	if (!oper)
>  		switch_schedules(q, &admin, &oper);
> =20
> +	if (unlikely(!oper)) {
> +		spin_unlock(&q->current_entry_lock);
> +		return HRTIMER_NORESTART;
> +	}
> +
>  	/* This can happen in two cases: 1. this is the very first run
>  	 * of this function (i.e. we weren't running any schedule
>  	 * previously); 2. The previous schedule just ended. The first
> @@ -946,49 +1120,98 @@ static enum hrtimer_restart advance_sched(struct h=
rtimer *timer)
>  	 * schedule initialization.
>  	 */
>  	if (unlikely(!entry || entry->end_time =3D=3D oper->base_time)) {
> -		next =3D list_first_entry(&oper->entries, struct sched_entry,
> -					list);
> -		end_time =3D next->end_time;
> -		goto first_run;
> -	}
> +		ktime_t cur_start;
> =20
> -	if (should_restart_cycle(oper, entry)) {
> +		if (!oper->cycle_end_time)
> +			oper->cycle_end_time =3D ktime_add_ns(sched_base_time(oper),
> +							    oper->cycle_time);
> +		cur_start =3D ktime_sub_ns(oper->cycle_end_time,
> +					 oper->cycle_time);
>  		next =3D list_first_entry(&oper->entries, struct sched_entry,
>  					list);
> -		oper->cycle_end_time =3D ktime_add_ns(oper->cycle_end_time,
> -						    oper->cycle_time);
> +		end_time =3D ktime_add_ns(cur_start, next->interval);
> +		end_time =3D min_t(ktime_t, end_time, oper->cycle_end_time);
> +
> +		if (should_change_schedules(admin, oper, end_time)) {
> +			switch_schedules(q, &admin, &oper);
> +			if (!oper->cycle_end_time)
> +				oper->cycle_end_time =3D ktime_add_ns(sched_base_time(oper),
> +								    oper->cycle_time);
> +			cur_start =3D ktime_sub_ns(oper->cycle_end_time,
> +						 oper->cycle_time);
> +			next =3D list_first_entry(&oper->entries,
> +						struct sched_entry, list);
> +			end_time =3D ktime_add_ns(cur_start, next->interval);
> +			end_time =3D min_t(ktime_t, end_time,
> +					 oper->cycle_end_time);
> +		}
> +
> +		taprio_set_entry_state(q, oper, next, cur_start, end_time,
> +				       num_tc);
>  	} else {
> -		next =3D list_next_entry(entry, list);
> +		taprio_advance_one_entry(q, &oper, &admin, &entry, &next,
> +					 &end_time, num_tc);
>  	}
> =20
> -	end_time =3D ktime_add_ns(entry->end_time, next->interval);
> -	end_time =3D min_t(ktime_t, end_time, oper->cycle_end_time);
> -
> -	for (tc =3D 0; tc < num_tc; tc++) {
> -		if (next->gate_duration[tc] =3D=3D oper->cycle_time)
> -			next->gate_close_time[tc] =3D KTIME_MAX;
> -		else
> -			next->gate_close_time[tc] =3D ktime_add_ns(entry->end_time,
> -								 next->gate_duration[tc]);
> -	}
> +	now =3D taprio_get_time(q);
> +	if (unlikely(ktime_compare(end_time, now) <=3D 0)) {
> +		size_t max_steps =3D min_t(size_t, oper->num_entries, 32);
> +		size_t i;
> +
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
> +		now =3D taprio_get_time(q);
> +		if (ktime_compare(end_time, now) <=3D 0) {
> +			taprio_fast_forward_sched(q, &oper, &admin, &next,
> +						  &end_time, now, num_tc);
> +			now =3D taprio_get_time(q);
> +			if (unlikely(ktime_compare(end_time, now) <=3D 0)) {
> +				entry =3D next;
> +				taprio_advance_one_entry(q, &oper, &admin,
> +							 &entry, &next,
> +							 &end_time, num_tc);
> +			}
> +			if (unlikely(ktime_compare(end_time, now) <=3D 0)) {
> +				s64 diff;
> +
> +				end_time =3D ktime_add_ns(now,
> +							taprio_min_interval(q));
> +				if (should_change_schedules(admin, oper,
> +							    end_time)) {
> +					switch_schedules(q, &admin, &oper);
> +					next =3D list_first_entry(&oper->entries,
> +								struct sched_entry,
> +								list);
> +				}
> +				if (!oper->cycle_end_time)
> +					oper->cycle_end_time =3D
> +						ktime_add_ns(sched_base_time(oper),
> +							     oper->cycle_time);
> +				diff =3D ktime_sub(end_time,
> +						 oper->cycle_end_time);
> +				if (diff > 0) {
> +					u64 cycles =3D div64_u64(diff +
> +							       oper->cycle_time - 1,
> +							       oper->cycle_time);
> +
> +					oper->cycle_end_time =3D
> +						ktime_add_ns(oper->cycle_end_time,
> +							     cycles *
> +							     oper->cycle_time);
> +				}
> +				taprio_set_entry_state(q, oper, next, now,
> +						       end_time, num_tc);
> +			}
> +		}
>  	}
> =20
> -	next->end_time =3D end_time;
> -	taprio_set_budgets(q, oper, next);
> -
> -first_run:
>  	rcu_assign_pointer(q->current_entry, next);
> -	spin_unlock(&q->current_entry_lock);
> -
>  	hrtimer_set_expires(&q->advance_timer, end_time);
> +	spin_unlock(&q->current_entry_lock);
> =20
>  	rcu_read_lock();
>  	__netif_schedule(sch);
> @@ -1130,7 +1353,11 @@ static int parse_taprio_schedule(struct taprio_sch=
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
> @@ -1152,8 +1379,12 @@ static int parse_taprio_schedule(struct taprio_sch=
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
> @@ -1167,12 +1398,45 @@ static int parse_taprio_schedule(struct taprio_sc=
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
> @@ -1256,7 +1520,7 @@ static void setup_first_end_time(struct taprio_sche=
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
> @@ -1349,11 +1613,13 @@ static int taprio_dev_notifier(struct notifier_bl=
ock *nb, unsigned long event,
>  		rcu_read_lock();
>  		oper =3D rcu_dereference(q->oper_sched);
>  		if (oper)
> -			taprio_update_queue_max_sdu(q, oper, stab);
> +			taprio_update_queue_max_sdu(q, oper, stab, q->max_sdu,
> +						    netdev_get_num_tc(dev));
> =20
>  		admin =3D rcu_dereference(q->admin_sched);
>  		if (admin)
> -			taprio_update_queue_max_sdu(q, admin, stab);
> +			taprio_update_queue_max_sdu(q, admin, stab, q->max_sdu,
> +						    netdev_get_num_tc(dev));
>  		rcu_read_unlock();
> =20
>  		break;
> @@ -1437,20 +1703,18 @@ static void taprio_offload_config_changed(struct =
taprio_sched *q)
>  	switch_schedules(q, &admin, &oper);
>  }
> =20
> -static u32 tc_map_to_queue_mask(struct net_device *dev, u32 tc_mask)
> +static u32 tc_map_to_queue_mask(const struct tc_mqprio_qopt *qopt, u32 t=
c_mask)
>  {
> -	int num_tc =3D netdev_get_num_tc(dev);
>  	u32 i, queue_mask =3D 0;
> =20
> -	for (i =3D 0; i < num_tc; i++) {
> -		struct netdev_tc_txq res;
> +	for (i =3D 0; i < qopt->num_tc; i++) {
> +		u16 offset =3D qopt->offset[i];
> +		u16 count =3D qopt->count[i];
> =20
>  		if (!(tc_mask & BIT(i)))
>  			continue;
> =20
> -		res.combined =3D READ_ONCE(dev->tc_to_txq[i].combined);
> -
> -		queue_mask |=3D GENMASK(res.offset + res.count - 1, res.offset);
> +		queue_mask |=3D GENMASK(offset + count - 1, offset);
>  	}
> =20
>  	return queue_mask;
> @@ -1474,7 +1738,7 @@ static void taprio_sched_to_offload(struct net_devi=
ce *dev,
>  		e->command =3D entry->command;
>  		e->interval =3D entry->interval;
>  		if (caps->gate_mask_per_txq)
> -			e->gate_mask =3D tc_map_to_queue_mask(dev,
> +			e->gate_mask =3D tc_map_to_queue_mask(&offload->mqprio.qopt,
>  							    entry->gate_mask);
>  		else
>  			e->gate_mask =3D entry->gate_mask;
> @@ -1516,6 +1780,9 @@ static void taprio_cleanup_broken_mqprio(struct tap=
rio_sched *q)
>  static int taprio_enable_offload(struct net_device *dev,
>  				 struct taprio_sched *q,
>  				 struct sched_gate_list *sched,
> +				 const struct tc_mqprio_qopt *mqprio,
> +				 const u32 max_sdu[TC_MAX_QUEUE],
> +				 u32 fp[TC_QOPT_MAX_QUEUE],
>  				 struct netlink_ext_ack *extack)
>  {
>  	const struct net_device_ops *ops =3D dev->netdev_ops;
> @@ -1534,7 +1801,7 @@ static int taprio_enable_offload(struct net_device =
*dev,
> =20
>  	if (!caps.supports_queue_max_sdu) {
>  		for (tc =3D 0; tc < TC_MAX_QUEUE; tc++) {
> -			if (q->max_sdu[tc]) {
> +			if (max_sdu[tc]) {
>  				NL_SET_ERR_MSG_MOD(extack,
>  						   "Device does not handle queueMaxSDU");
>  				return -EOPNOTSUPP;
> @@ -1550,13 +1817,16 @@ static int taprio_enable_offload(struct net_devic=
e *dev,
>  	}
>  	offload->cmd =3D TAPRIO_CMD_REPLACE;
>  	offload->extack =3D extack;
> -	mqprio_qopt_reconstruct(dev, &offload->mqprio.qopt);
> +	if (mqprio)
> +		offload->mqprio.qopt =3D *mqprio;
> +	else
> +		mqprio_qopt_reconstruct(dev, &offload->mqprio.qopt);
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
> @@ -1747,14 +2017,14 @@ static int taprio_parse_tc_entry(struct Qdisc *sc=
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
> @@ -1772,8 +2042,6 @@ static int taprio_parse_tc_entries(struct Qdisc *sc=
h,
>  	}
> =20
>  	for (tc =3D 0; tc < TC_QOPT_MAX_QUEUE; tc++) {
> -		WRITE_ONCE(q->max_sdu[tc], max_sdu[tc]);
> -		WRITE_ONCE(q->fp[tc], fp[tc]);
>  		if (fp[tc] !=3D TC_FP_EXPRESS)
>  			have_preemption =3D true;
>  	}
> @@ -1792,7 +2060,7 @@ static int taprio_parse_tc_entries(struct Qdisc *sc=
h,
>  		}
>  	}
> =20
> -	return err;
> +	return 0;
>  }
> =20
>  static int taprio_mqprio_cmp(const struct net_device *dev,
> @@ -1823,15 +2091,28 @@ static int taprio_change(struct Qdisc *sch, struc=
t nlattr *opt,
>  			 struct netlink_ext_ack *extack)
>  {
>  	struct qdisc_size_table *stab =3D rtnl_dereference(sch->stab);
> +	struct sched_gate_list *oper, *admin, *new_admin =3D NULL;
>  	struct nlattr *tb[TCA_TAPRIO_ATTR_MAX + 1] =3D { };
> -	struct sched_gate_list *oper, *admin, *new_admin;
>  	struct taprio_sched *q =3D qdisc_priv(sch);
>  	struct net_device *dev =3D qdisc_dev(sch);
>  	struct tc_mqprio_qopt *mqprio =3D NULL;
> +	u32 max_sdu[TC_MAX_QUEUE] =3D { };
> +	u32 fp[TC_QOPT_MAX_QUEUE] =3D { };
> +	enum tk_offsets old_tk_offset;
> +	int old_clockid, num_tc, i, err;
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
> @@ -1866,54 +2147,43 @@ static int taprio_change(struct Qdisc *sch, struc=
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
> -	if (mqprio) {
> -		err =3D netdev_set_num_tc(dev, mqprio->num_tc);
> -		if (err)
> -			goto free_sched;
> -		for (i =3D 0; i < mqprio->num_tc; i++) {
> -			netdev_set_tc_queue(dev, i,
> -					    mqprio->count[i],
> -					    mqprio->offset[i]);
> -			q->cur_txq[i] =3D mqprio->offset[i];
> -		}
> -
> -		/* Always use supplied priority mappings */
> -		for (i =3D 0; i <=3D TC_BITMASK; i++)
> -			netdev_set_prio_tc_map(dev, i,
> -					       mqprio->prio_tc_map[i]);
> -	}
> -
>  	err =3D parse_taprio_schedule(q, tb, new_admin, extack);
>  	if (err < 0)
>  		goto free_sched;
> @@ -1928,27 +2198,42 @@ static int taprio_change(struct Qdisc *sch, struc=
t nlattr *opt,
>  	if (err < 0)
>  		goto free_sched;
> =20
> -	taprio_update_queue_max_sdu(q, new_admin, stab);
> +	num_tc =3D mqprio ? mqprio->num_tc : netdev_get_num_tc(dev);
> +
> +	taprio_calculate_gate_durations(q, new_admin, num_tc);
> +
> +	taprio_update_queue_max_sdu(q, new_admin, stab, max_sdu, num_tc);
> =20
>  	if (FULL_OFFLOAD_IS_ENABLED(q->flags))
> -		err =3D taprio_enable_offload(dev, q, new_admin, extack);
> +		err =3D taprio_enable_offload(dev, q, new_admin, mqprio, max_sdu,
> +					    fp, extack);
>  	else
>  		err =3D taprio_disable_offload(dev, q, extack);
>  	if (err)
>  		goto free_sched;
> =20
> +	if (mqprio) {
> +		netdev_set_num_tc(dev, mqprio->num_tc);
> +		for (i =3D 0; i < mqprio->num_tc; i++) {
> +			netdev_set_tc_queue(dev, i,
> +					    mqprio->count[i],
> +					    mqprio->offset[i]);
> +			q->cur_txq[i] =3D mqprio->offset[i];
> +		}
> +
> +		/* Always use supplied priority mappings */
> +		for (i =3D 0; i <=3D TC_BITMASK; i++)
> +			netdev_set_prio_tc_map(dev, i,
> +					       mqprio->prio_tc_map[i]);
> +	}
> +
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
> @@ -1957,11 +2242,14 @@ static int taprio_change(struct Qdisc *sch, struc=
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
> @@ -2008,6 +2296,12 @@ static int taprio_change(struct Qdisc *sch, struct=
 nlattr *opt,
>  	spin_unlock_bh(qdisc_lock(sch));
> =20
>  free_sched:
> +	if (err && initial_setup) {
> +		WRITE_ONCE(q->flags, old_flags);
> +		q->clockid =3D old_clockid;
> +		WRITE_ONCE(q->tk_offset, old_tk_offset);
> +	}
> +
>  	if (new_admin)
>  		call_rcu(&new_admin->rcu, taprio_free_sched_cb);
> =20
> @@ -2054,11 +2348,12 @@ static void taprio_destroy(struct Qdisc *sch)
>  	}
>  	q->qdiscs =3D NULL;
> =20
> -	netdev_reset_tc(dev);
> -
>  	oper =3D rtnl_dereference(q->oper_sched);
>  	admin =3D rtnl_dereference(q->admin_sched);
> =20
> +	if (oper || admin)
> +		netdev_reset_tc(dev);
> +
>  	if (oper)
>  		call_rcu(&oper->rcu, taprio_free_sched_cb);
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
