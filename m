Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792750189;
	b=0TsO+DJUzCxzEVfcwroJhol3U7FDspCWRR0WmbQlBNgWAbY7+CC3yPC5u0z0JRKjPmmV
	 JbXIE83/Z3Cu14r8/oIXSBnuGp2CbNmapay8jif11Yh7nVBUFPp77JfMdIefFug//sJZ5
	 mrzqHFg0O3Qe4uX+X/LcexfgV+CAyKVvJP19WaBktFLC5kdMYcoeExjhwNVJzWMv7fb2k
	 wu3KhPeby3o2KrmhD+onRsOQQRCH5FwdPdcR4yayyiByljZ262aHwiJWFQLNPu6djrCCv
	 ZNEtoRp0cZzdBi40diOUsvggrE8TG/ZuMEOvDApqLPbYi4a9rL7QiJafG2svwMC5rEg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792750189;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:Content-Transfer-Encoding:
	 In-Reply-To;
	bh=h6OAkeYKqkcUi8aoAoxzqSh4JukRlZ0doRGPe4YyHk0=;
	b=1mTeGtmpvU+g3i2qliDKNTyMehjR0Xekd+xjgXkgSNJWR/ZhMfO+jPZOS/yobzuFNwBP
	 EGsGpToUbhuY6Qa7A12m+nxPSnQM6FRvzE72jhlLPBwm2FvqsTC/TWtN//Gs6PN4xCLhb
	 w5Z2m6P6F43xCSntgzWRtGTQg289uJFr4KXNGtMjI/Z6+5t7rpjyDhpeMbrIV0g8hx7nw
	 /w8xM90nqIOPm7UQXDgp/YOuADSXApnZ63pXmO9kUi1RcDt7wl+uh6hJIZVf1wppwxZGp
	 +gUg9OkRICxTOxcfl89jVSB47ClfmAoQp9M3DlpvVD2lFN0M+BkGGEPtwfB8pTwrGkA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=Fw4suypc;
	arc=none smtp.remote-ip=209.85.208.50
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B855E606A31A
	for <syzbot@lists.linux.dev>; Fri, 23 Oct 2026 10:09:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B855E606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=Fw4suypc
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-6b1aa27963eso2655421a12.1
        for <syzbot@lists.linux.dev>; Fri, 23 Oct 2026 03:09:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792750187; x=1793354987; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=h6OAkeYKqkcUi8aoAoxzqSh4JukRlZ0doRGPe4YyHk0=;
        b=Fw4suypcZ32OsBHHkbSaO58zvoRpw/E3FUixiugOBvDL0II4E/vq/WfhaM6Z6fWCc5
         rwmXWcR6CZdoitIM39+qKhbATwVb99d823T21XCkcCwu+4lJbfA/MyqHdmij8iBSn8NU
         Q+MYW9ZIM7dFJZfoYcY7kUIjZSZTJZzSsUAAP4hU2awW3JsMJobjh5votDLpuwmDFZO2
         Jjrt6i1TmgOHppIp+K7wByEcovRwVeqvbTp9xtxJkYOk87EAu6CRTaTOq2IoiwiEaVr4
         guDMoWMbRTqGddHoSVCgICawbi8dtF9H6Mz6z0Y62FITTsbTUSrZnwR9UzeXhtGlRCg9
         RmuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792750187; x=1793354987;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=h6OAkeYKqkcUi8aoAoxzqSh4JukRlZ0doRGPe4YyHk0=;
        b=bnwKusW/DfSO8lar5ou9ygZptHv4uhp3rD2YqlEXlhugTAV3Mtoig17W4+HCx7cMfa
         PMT8fTYnSDKQlDjvy5+ZF8F/sGl+4JhfEK1o3PRKwoGJTGdbeLsA4W1CXE9CTGy68AkG
         tWkdLqX8YIsRu7Zwn6jt4yhZwSipzmBFvmkVq/RDS1wxRA5wLg2oOzF/k/QLvpq353CF
         DpzpI48yFxqwT6RKK2/e3vliZTYPioTLRwAr2aNBqmsaKNMYxNH4KbiBXG7GxDnEKl+i
         /ZT7Y8AnaNdLRIp+uVFDSjoHm/64M7luVS8pE39E1RPIN2QaIOxVrV+6aXK89yEdOyql
         xHbw==
X-Forwarded-Encrypted: i=1; AKwUvBynYGd42+Ss8vJS4E+YJHBgsfqZWWZmK3+N7g7a3eIR1UAGa8RWCoRGs/Ybk+XCC0JZ0srYH80=@lists.linux.dev
X-Gm-Message-State: AFq9FYKsVZmTdBHQWTgB7OTgLMrV4kBmzMxOzkc3tHu7AkFIbMbx9lu3
	k46H8p4nUb4oTqvOO+fQE15hQmllWitB7DKuuf9MO/apT3Q72Sx2mBnu0aUlGA==
X-Gm-Gg: AYBFou0vZJ5Vi03nz601q9COwn9W6q83QfnKfDOcJxEDmdJUHq7V/ws+ZJL3osg8009
	3GKBEC9nk2qwGaRFhl3FfLyZX8hAbzuKGLGsi8aFKeqyZgYFITnnkQydN0um0Pran2+cJ9r8kQf
	terAnagoHSDdd0KeZk0K+fFG2MpNfDOfZgIMS0ZDJJyEdr1b2T4FtlYNTAxaP8vgv+3NXNChGly
	XrYRYFc2M2E1YN7cowMSMVo+QcEJhUxlTODwICjgo7mp73cyFC5hFhSWiIVx29VQPBW7JaLset/
	7kFVQOOHg1HEngZIeXRJ5QMdRsG9x9yCvgDz4x2JU4aXP3Nb2+w+lPACnHmB8zN4WPlSTj1DXcC
	xYmhZGp5mZuBllwjtT7qh4pGQWHkXlIMdUqoZKokIfpweJhKlwDKPGh79rLRjDcDQx6BuHm56n6
	r6A8vBJdinFFZ0Bh1pTj0sZHRNSqWaElHJA0kvzQzU0lpbs5+8QXgM1vy998oM/bx17aYKEf/sz
	37j9wqoCjrJj758stkQYJzyxklEpE4jhmNn8sijINTDplOTe1uo+CWT/Td5XCDhH9gc9e+HkAHi
	EaID
X-Received: by 2002:a17:906:1d52:b0:c42:6632:a369 with SMTP id a640c23a62f3a-c46a92b89c8mr214954166b.21.1792750185391;
        Fri, 23 Oct 2026 03:09:45 -0700 (PDT)
Received: from localhost ([37.30.48.34])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c46a5cfb941sm85834066b.82.2026.10.23.03.09.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Oct 2026 03:09:44 -0700 (PDT)
Date: Fri, 23 Oct 2026 12:09:43 +0200
From: Bartosz Chronowski <immersa.bartosz.chronowski@gmail.com>
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Subject: Re: [PATCH RFC v6] net/sched: taprio: enforce minimum interval in
 software mode
Message-ID: <qd3sv26hlyweyb4fkd5kcdzujtsnsfqsnsot4wxzkbmnjgzqro@2vqsteofx3ae>
References: <bead33e5-6249-40fb-aaaf-58117e6ee7b8@mail.kernel.org>
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
In-Reply-To: <bead33e5-6249-40fb-aaaf-58117e6ee7b8@mail.kernel.org>

v6 initializes new_admin before early cleanup and corrects the Fixes: tag to
5a781ccbd19e4. Its software-only 10 us floor rejects the reported 334 ns
schedule. The code still lacks finite total timer-callback work and complete
rollback after failed first setup. Source-bound semantic checks fail both
guarantees. Three 4-VM, 240-second reproducer runs found no target crash,
including the unpatched controls, so runtime comparison is inconclusive.
The patch needs changes. Its stated base-commit is
cee9395acd8043be0644b25c34bfa86623f2b935; v6 changes only
net/sched/sch_taprio.c.

- Bound total advance_sched() work, not just its 32-step loop: the new
  taprio_fast_forward_sched() can rescan the full list repeatedly after each
  fresh clock read under current_entry_lock. Derive the administrative swit=
ch,
  phase, active entry, gate-close state, budget, and deadline coherently, a=
nd
  state a rearm guarantee the code and tests can support. The claimed one-s=
can
  bound and final future-expiry clamp are not in this code.

- Make a failed first taprio_change() preserve prior device TC side effects.
  On this base, net/core/dev.c's netdev_set_num_tc() can clear XPS mappings
  and unbind subordinate channels, and netdev_set_tc_queue() can clear XPS;
  restoring raw TC fields does not undo either. Cover net/sched/sch_api.c's
  qdisc_create() calling taprio_destroy() after failed initialization, which
  resets TC again. Avoid visible mutation before commit or demonstrate
  complete restoration across these paths.

Update the description to match those actual guarantees and fix the remaini=
ng
line-length warning. Test accepted minimum intervals, large entry lists,
delayed and equal-time schedule switches, and TXTIME-assist and full-offload
boundaries. Inject a failure after TC setup with pre-existing XPS and
subordinate-channel state, then compare the full state before and after,
including the failed qdisc_create() cleanup path. The current mode models
pass, but live offload behavior has not been tested.

Impact assessment: The supported effect is stalled CPU progress, including
the reported RCU stall, and altered device scheduling state after a rejected
setup. No disclosure, privilege escalation, or direct memory corruption is
established by this evidence.

Kind Regards / Mit freundlichen Gr=C3=BC=C3=9Fen
BART CHRONOWSKI

On Fri, Oct 16, 2026 at 02:00:11PM +0000, syzbot wrote:
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
> Fixes: 5a781ccbd19e ("tc: Add support for configuring the taprio schedule=
r")
> Assisted-by: Gemini:gemini-4-argon Gemini:gemini-3.8-flash syzbot
> Reported-by: syzbot+14c6ac6811273526cfa5@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3D14c6ac6811273526cfa5
> Link: https://syzkaller.appspot.com/ai_job?id=3De84d30ce-fe47-4791-8ff0-0=
e2f49ebdc75
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
> index 39ac5b97a..9128f8179 100644
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
> @@ -916,6 +944,142 @@ static bool should_change_schedules(const struct sc=
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
> +again:
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
> +		goto again;
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
> @@ -925,8 +1089,7 @@ static enum hrtimer_restart advance_sched(struct hrt=
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
> @@ -939,6 +1102,11 @@ static enum hrtimer_restart advance_sched(struct hr=
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
> @@ -946,49 +1114,61 @@ static enum hrtimer_restart advance_sched(struct h=
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
> +		while (ktime_compare(end_time, now) <=3D 0) {
> +			taprio_fast_forward_sched(q, &oper, &admin, &next,
> +						  &end_time, now, num_tc);
> +			now =3D taprio_get_time(q);
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
> @@ -1130,7 +1310,11 @@ static int parse_taprio_schedule(struct taprio_sch=
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
> @@ -1152,8 +1336,12 @@ static int parse_taprio_schedule(struct taprio_sch=
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
> @@ -1167,12 +1355,45 @@ static int parse_taprio_schedule(struct taprio_sc=
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
> @@ -1256,7 +1477,7 @@ static void setup_first_end_time(struct taprio_sche=
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
> @@ -1349,11 +1570,11 @@ static int taprio_dev_notifier(struct notifier_bl=
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
> @@ -1516,6 +1737,8 @@ static void taprio_cleanup_broken_mqprio(struct tap=
rio_sched *q)
>  static int taprio_enable_offload(struct net_device *dev,
>  				 struct taprio_sched *q,
>  				 struct sched_gate_list *sched,
> +				 const u32 max_sdu[TC_MAX_QUEUE],
> +				 u32 fp[TC_QOPT_MAX_QUEUE],
>  				 struct netlink_ext_ack *extack)
>  {
>  	const struct net_device_ops *ops =3D dev->netdev_ops;
> @@ -1534,7 +1757,7 @@ static int taprio_enable_offload(struct net_device =
*dev,
> =20
>  	if (!caps.supports_queue_max_sdu) {
>  		for (tc =3D 0; tc < TC_MAX_QUEUE; tc++) {
> -			if (q->max_sdu[tc]) {
> +			if (max_sdu[tc]) {
>  				NL_SET_ERR_MSG_MOD(extack,
>  						   "Device does not handle queueMaxSDU");
>  				return -EOPNOTSUPP;
> @@ -1553,10 +1776,10 @@ static int taprio_enable_offload(struct net_devic=
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
> @@ -1747,14 +1970,14 @@ static int taprio_parse_tc_entry(struct Qdisc *sc=
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
> @@ -1772,8 +1995,6 @@ static int taprio_parse_tc_entries(struct Qdisc *sc=
h,
>  	}
> =20
>  	for (tc =3D 0; tc < TC_QOPT_MAX_QUEUE; tc++) {
> -		WRITE_ONCE(q->max_sdu[tc], max_sdu[tc]);
> -		WRITE_ONCE(q->fp[tc], fp[tc]);
>  		if (fp[tc] !=3D TC_FP_EXPRESS)
>  			have_preemption =3D true;
>  	}
> @@ -1792,7 +2013,7 @@ static int taprio_parse_tc_entries(struct Qdisc *sc=
h,
>  		}
>  	}
> =20
> -	return err;
> +	return 0;
>  }
> =20
>  static int taprio_mqprio_cmp(const struct net_device *dev,
> @@ -1823,15 +2044,33 @@ static int taprio_change(struct Qdisc *sch, struc=
t nlattr *opt,
>  			 struct netlink_ext_ack *extack)
>  {
>  	struct qdisc_size_table *stab =3D rtnl_dereference(sch->stab);
> +	struct sched_gate_list *oper, *admin, *new_admin =3D NULL;
> +	struct netdev_tc_txq old_tc_to_txq[TC_MAX_QUEUE];
>  	struct nlattr *tb[TCA_TAPRIO_ATTR_MAX + 1] =3D { };
> -	struct sched_gate_list *oper, *admin, *new_admin;
> +	u8 old_prio_tc_map[TC_BITMASK + 1];
> +	int old_cur_txq[TC_MAX_QUEUE];
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
> +	s16 old_num_tc;
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
> @@ -1866,41 +2105,68 @@ static int taprio_change(struct Qdisc *sch, struc=
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
> +		old_num_tc =3D dev->num_tc;
> +		memcpy(old_tc_to_txq, dev->tc_to_txq, sizeof(old_tc_to_txq));
> +		memcpy(old_prio_tc_map, dev->prio_tc_map,
> +		       sizeof(old_prio_tc_map));
> +		memcpy(old_cur_txq, q->cur_txq, sizeof(old_cur_txq));
> +
>  		err =3D netdev_set_num_tc(dev, mqprio->num_tc);
>  		if (err)
>  			goto free_sched;
> +		tc_configured =3D true;
>  		for (i =3D 0; i < mqprio->num_tc; i++) {
>  			netdev_set_tc_queue(dev, i,
>  					    mqprio->count[i],
> @@ -1914,24 +2180,12 @@ static int taprio_change(struct Qdisc *sch, struc=
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
> @@ -1940,15 +2194,10 @@ static int taprio_change(struct Qdisc *sch, struc=
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
> @@ -1957,11 +2206,14 @@ static int taprio_change(struct Qdisc *sch, struc=
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
> @@ -2008,6 +2260,22 @@ static int taprio_change(struct Qdisc *sch, struct=
 nlattr *opt,
>  	spin_unlock_bh(qdisc_lock(sch));
> =20
>  free_sched:
> +	if (err && initial_setup) {
> +		if (tc_configured) {
> +			WRITE_ONCE(dev->num_tc, old_num_tc);
> +			for (i =3D 0; i < TC_MAX_QUEUE; i++)
> +				WRITE_ONCE(dev->tc_to_txq[i].combined,
> +					   old_tc_to_txq[i].combined);
> +			for (i =3D 0; i <=3D TC_BITMASK; i++)
> +				WRITE_ONCE(dev->prio_tc_map[i],
> +					   old_prio_tc_map[i]);
> +			memcpy(q->cur_txq, old_cur_txq, sizeof(q->cur_txq));
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
