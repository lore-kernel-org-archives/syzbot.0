Received: from mail-ed2-f12.google.com (mail-ed2-f12.google.com [74.125.228.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0515C47209A
	for <syzbot@lists.linux.dev>; Tue, 15 Sep 2026 09:50:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789465816; cv=none; b=DrWenyPyp13HTK+TyIdb51WavfLSrWtAe3aqSuhAZv1xz7ORvLQCUUNPwISptOmq0RDaX0YX3aWRqM9AVaZ/Bje4etkuGmFPqAIYqfpmBmOIIEiI+KVYm/rVHVVxljESV8LlQAtM+9tZLo0r3WR1aOFoUzSKeKFcgG7GmrtHRco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789465816; c=relaxed/simple;
	bh=S6JpfFIDxbQP9aou7xeNEw/KCDv4KhiRsKBIV6wml5U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Thsz3EPgONi1owERLi7KVTyLJxz1YCslUtL6Q32M/yer9yiqMwwniu5WMeFo4uuO+AoNednELpKjMXbvKwhuXuwztreLJ1iMMMVRN0cNQDK0pG5veRYk4CKkFoUsi/N6axGA+6zBS2RaS1N29gvlAjz8am7zMhYC9Al0vQCAB1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=qOiiT3u+; arc=none smtp.client-ip=74.125.228.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qOiiT3u+"
Received: by mail-ed2-f12.google.com with SMTP id 4fb4d7f45d1cf-6a643817eb2so151204a12.1
        for <syzbot@lists.linux.dev>; Tue, 15 Sep 2026 02:50:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789465812; x=1790070612; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=COxE4SjqkZ21nmcnp2U0uMTUPU4zP1CNLKRlKf34qfM=;
        b=qOiiT3u+KE7LQM0r9Cc0GIm1wtSzJSLGRXKctByvxa+0oQl7PMJmgHGrqp5FAIHStJ
         z6g7QfJM2yQy70hoASJLkC4aNra4q9T7jzUG8F1Gi0G58IPdFZah9T821QEx9YYCighg
         P8s++RBwZsBQBpTbkY94VfTXNqz9jSaghVxj2XJNxGBhcJ1N/SxirYiZxpQfJ/Q6q7e0
         4MCwasulNRZcC8ZPj8YpN1nmyOJebYaMSXkj9qSBT5XatANdP5f1QrwNMdVg9TI9XVAm
         OSchv50Yu9BunHBNo9lQ/ewomxdPazUH/kkqchmz9JEWCfOVl8hdzB6rmI2ie5laqhGG
         TebQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789465812; x=1790070612;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=COxE4SjqkZ21nmcnp2U0uMTUPU4zP1CNLKRlKf34qfM=;
        b=xpmYjbGIbt+58WXK3OHOGnQH1lwlPI+McK4Bwu9rv45qsfSdXP2/D+an9KX9I/E9M1
         EF1FWKZZ6bgBS0fNZ1vUattsXbSbSQ2vrkoAnrDSKHdKv7zrUUxwPZ+Om1NETXClcntA
         85JG8JMTM/gowYhLFKF6+9WpjqDojOnZjgtVmosBEhCAxN3cRIu/404m1TP2WYKrD9BT
         +sYim7ivSeaRz2czPPSqa8yfUiXJ6N99JEAi+bFTROc18aQ2aJdR1i8Sxa6RtkxfJqC9
         j4ZltwRuRXiaESiWizRzL7+WuIbuDVsYHtJU7a3vBHxRL0SNTO0PygdTi7lsEMd8vH/v
         NuCg==
X-Forwarded-Encrypted: i=1; AKwUvBy9B62Hf6fUbi4S/tPAxn910Ed3ro3cakFeLtBBnx2CnB3+qwjkIxp/TVgbmZ2FWVDJ1CKhs5o=@lists.linux.dev
X-Gm-Message-State: AFuF++l/Ps9eMkMb8mJH6GW9vjE3Sbq8qQx0NCf1085NMJ4a1SvhHB0d
	mXp9fL9B/sryJShxZXzCAN0JlBtwIvK60k2LZIqD8eemYCbzqPr1CyMJ
X-Gm-Gg: AYBFou21bSPo5OCv04av2eGDaKMtwYoSw5MkuZLK9jSTd0y0cf3ecNK86lK9H/aJ9rf
	uKbPdGOpre7yyBPjJETGbJRPqsju8FqsG9QnioxHNN68Ea8yKqrborHXGTsMHqS/srecIJp/3RY
	F9kwOeBDGlKAPiGwEgWZ5VTp7kPSxmYr4AFO9NJJ1+5/wcCi+BOIxeylhv6xYpoYyOsB7Syw08w
	5NzAoKXQES7bpx3FQNkDylPln8QOj5XK3jHmvKZgaGm+tLCpT4dwKbsAXjG6g6c9WyC103A4A8a
	iy+b1Y4JSnvQhGzdmH9ekT3TLFnj3sslRBk2PB+k0XGFCczbfcrd936FArYxDhPLylI9ZABZHC9
	7D0eKt1U+UVdXZ3xGZjWSjVepmWYXyuJbCklANi55DKhw1D2wtLnzlQKMXeKUKNNVewjiQSGX5h
	SLIAl/KzARj03T+rYfEkgjSlYQ+T4ADsvxMsm84g0VNpem9ZvTEoBd4Q2xvBA5CVJnZR5lEywox
	eu0ArrvFMDSd6c=
X-Received: by 2002:a05:6402:1d4d:b0:6aa:82f:8088 with SMTP id 4fb4d7f45d1cf-6aa12f0efcamr254806a12.43.1789465811820;
        Tue, 15 Sep 2026 02:50:11 -0700 (PDT)
Received: from localhost ([37.31.154.24])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6a9ba8f3ab9sm5154897a12.15.2026.09.15.02.50.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Sep 2026 02:50:11 -0700 (PDT)
Date: Tue, 15 Sep 2026 11:50:08 +0200
From: Bartosz Chronowski <immersa.bartosz.chronowski@gmail.com>
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Subject: Re: [PATCH RFC v3] net/sched: taprio: enforce minimum interval in
 software mode
Message-ID: <cj4cfxpgw7dvnydtdw7iqbuzs37jtwdoqx4c5oablibc3lwswb@soq6uhw5degl>
References: <5a7fa927-7ed9-4c7b-82b8-97cb8fdadfc9@mail.kernel.org>
 <474pgoyjkcanjuvsyd7dkjscx7mw25fxz4by4sjotmi2ds6qkp@hf5ak7i3ehik>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <474pgoyjkcanjuvsyd7dkjscx7mw25fxz4by4sjotmi2ds6qkp@hf5ak7i3ehik>

Syzbot:
Please generate a new v4 patch with the feedback below:
"
v3 addresses several parts of the previous feedback. It removes the
entry-count multiplication, checks the duration left at an explicit cycle
boundary, clamps the first expiry to that boundary, and blocks the selected
205 ns/129 ns implicit software schedule. Moving schedule validation before
netdev traffic-class configuration is also progress.

The code is still not correct. The CPU-progress guarantee is not establishe=
d,
the configured and effective schedules are still interpreted differently, a=
nd
schedule rejection can still leave configuration changed. The available
runtime testing did not reproduce the report on the unpatched base, so it
cannot establish a v3 runtime fix. The patch needs another revision.

Establish the software timer's progress guarantee.

The description explains the intended 10 us floor, but saying that
advance_sched() runs faster than that does not establish a worst-case
serviceability bound. The callback still advances from the previous
absolute expiry and returns HRTIMER_RESTART. After delayed execution, that
expiry can remain in the past and the hrtimer queue can invoke the callback
again immediately. Missed-transition work therefore remains proportional
to accumulated lateness.

Handle overdue transitions with bounded catch-up work and select a
phase-correct, strictly future expiry. Keep the entry position, explicit
cycle boundary, cycle-time extension, gate and budget state, and
administrative schedule switches coherent. Explain and justify the
worst-case serviceability bound, and add deterministic delayed-callback
coverage. Increasing the admission minimum alone does not close this path.
"

Also apply to below for the v4 patch.
Use one effective schedule across all consumers.

   The elapsed/remaining walk fixes the entry-count check and detects an
   undersized clipped interval. However, fill_sched_entry() still applies t=
he
   software minimum to every configured entry before truncation is consider=
ed.
   For example, a 20 us first entry with a 10 us explicit cycle and an unus=
ed
   1 us tail is rejected because of the tail, although that tail is never
   executed.

   Separate basic entry validity from the software serviceability check on
   executed intervals. Derive one effective-cycle view and use it consisten=
tly
   for timer transitions, TXTIME lookup, gate durations, budgets, queueMaxS=
DU,
   administrative state, and offload payloads. At an exact cycle-end bounda=
ry,
   restart TXTIME lookup from the first effective entry instead of selectin=
g an
   unreachable tail. taprio_calculate_gate_durations() must not keep summin=
g the
   full declared list after the timer schedule has been clipped.

   Keep the 10 us policy software-only. Verify the common cycle and truncat=
ion
   changes separately for TXTIME-assist and full offload; excluding those m=
odes
   from the 10 us floor does not prove that their gate, timing, and payload
   behavior is preserved.

Kind Regards / Mit freundlichen Gr=C3=BC=C3=9Fen
BART CHRONOWSKI

On Fri, Sep 11, 2026 at 09:20:20PM +0200, Bartosz Chronowski wrote:
> v3 addresses several parts of the previous feedback. It removes the
> entry-count multiplication, checks the duration left at an explicit cycle
> boundary, clamps the first expiry to that boundary, and blocks the select=
ed
> 205 ns/129 ns implicit software schedule. Moving schedule validation befo=
re
> netdev traffic-class configuration is also progress.
>=20
> The code is still not correct. The CPU-progress guarantee is not establis=
hed,
> the configured and effective schedules are still interpreted differently,=
 and
> schedule rejection can still leave configuration changed. The available
> runtime testing did not reproduce the report on the unpatched base, so it
> cannot establish a v3 runtime fix. The patch needs another revision.
>=20
> Establish the software timer's progress guarantee.
>=20
> The description explains the intended 10 us floor, but saying that
> advance_sched() runs faster than that does not establish a worst-case
> serviceability bound. The callback still advances from the previous
> absolute expiry and returns HRTIMER_RESTART. After delayed execution, that
> expiry can remain in the past and the hrtimer queue can invoke the callba=
ck
> again immediately. Missed-transition work therefore remains proportional
> to accumulated lateness.
>=20
> Handle overdue transitions with bounded catch-up work and select a
> phase-correct, strictly future expiry. Keep the entry position, explicit
> cycle boundary, cycle-time extension, gate and budget state, and
> administrative schedule switches coherent. Explain and justify the
> worst-case serviceability bound, and add deterministic delayed-callback
> coverage. Increasing the admission minimum alone does not close this path.
>=20
> Kind Regards / Mit freundlichen Gr=C3=BC=C3=9Fen
> BART CHRONOWSKI  =20
>=20
> On Wed, Sep 09, 2026 at 03:57:41PM +0000, syzbot wrote:
> > In taprio software mode (when full offload and txtime-assist are not
> > enabled), schedule advancement is driven in software by an hrtimer runn=
ing
> > advance_sched(). The minimum allowed duration for schedule entries was
> > previously bounded only by length_to_duration(q, ETH_ZLEN). For high li=
nk
> > speeds or small picos_per_byte, this allows entry intervals to be
> > configured to extremely small values (e.g., tens of nanoseconds).
> >=20
> > When entry intervals or cycle_time are configured to values shorter than
> > the time required to execute the timer callback, the newly calculated
> > expiration time is in the past. Consequently, the hrtimer subsystem
> > repeatedly and immediately re-invokes advance_sched() in hardirq contex=
t,
> > resulting in an interrupt storm that starves the CPU and triggers RCU
> > stalls:
> >=20
> > rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:
> > rcu: 	0-...!: (1 GPs behind) idle=3Dfc14/1/0x4000000000000000
> > softirq=3D20212/20212 fqs=3D5
> > rcu: 	(detected by 1, t=3D10502 jiffies, g=3D16909, q=3D1720 ncpus=3D2)
> > Sending NMI from CPU 1 to CPUs 0:
> > NMI backtrace for cpu 0
> > CPU: 0 UID: 0 PID: 200 Comm: kworker/u9:4 Not tainted
> > RIP: 0010:advance_sched+0x10f/0xc80 net/sched/sch_taprio.c:932
> > Call Trace:
> >  <IRQ>
> >  __run_hrtimer kernel/time/hrtimer.c:2067 [inline]
> >  __hrtimer_run_queues+0x3bc/0xa10 kernel/time/hrtimer.c:2124
> >  hrtimer_interrupt+0x4cd/0xaa0 kernel/time/hrtimer.c:2243
> >  local_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1051 [inline]
> >  __sysvec_apic_timer_interrupt+0x102/0x430 arch/x86/kernel/apic/apic.c:=
1068
> >  sysvec_apic_timer_interrupt+0xa1/0xc0 arch/x86/kernel/apic/apic.c:1062
> >  </IRQ>
> >=20
> > To prevent CPU starvation, define TAPRIO_MIN_SW_INTERVAL_NS (10 us) and
> > introduce taprio_min_interval(). For software mode, enforcing a minimum
> > interval of 10 us establishes a serviceability guarantee: because 10 us=
 is
> > significantly larger than the execution latency of advance_sched(), the=
 CPU
> > is guaranteed sufficient processing time between timer interrupts to ma=
ke
> > forward progress, service softirqs, and advance RCU grace periods.
> >=20
> > Enforce this lower bound across all effective intervals that
> > advance_sched() can schedule:
> > - Individual schedule entries validated via fill_sched_entry() must be =
at
> > least taprio_min_interval().
> > - The overall cycle_time must be at least taprio_min_interval().
> > - When an explicit cycle_time is configured that truncates a schedule
> > entry, the effective remaining duration (cycle_time - elapsed) must als=
o be
> > at least taprio_min_interval() in parse_taprio_schedule(), preventing a
> > sub-10us trailing interval before cycle wrap-around.
> > - In setup_first_end_time(), clamp the initial entry's expiration using
> > min_t(s64, first->interval, cycle) to ensure the initial timer interval
> > respects explicit-cycle truncation.
> >=20
> > For TXTIME-assist and full-offload modes, advance_sched() does not drive
> > schedule switching in software. In these modes, taprio_min_interval()
> > continues to compute length_to_duration(q, ETH_ZLEN) without the 10 us
> > clamp. This preserves existing offload arithmetic, ensuring that schedu=
le
> > intervals and cycle times remain bounded by the transmission time of a
> > minimum Ethernet frame (60 bytes) without restricting hardware-assisted
> > schedules.
> >=20
> > Finally, validate the schedule in taprio_change() before calling
> > netdev_set_num_tc() so that invalid configurations are rejected before
> > altering netdev traffic classes, move taprio_calculate_gate_durations()
> > after traffic classes are set, and reject empty schedules.
> >=20
> > Fixes: 6ca6a6654225 ("taprio: Add support for setting the cycle-time ma=
nually")
> > Assisted-by: Gemini:gemini-3.8-flash syzbot
> > Reported-by: syzbot+14c6ac6811273526cfa5@syzkaller.appspotmail.com
> > Closes: https://syzkaller.appspot.com/bug?extid=3D14c6ac6811273526cfa5
> > Link: https://syzkaller.appspot.com/ai_job?id=3Df336f3a5-99f4-4c2c-a2cc=
-49ef9348bf54
> > To: "David S. Miller" <davem@davemloft.net>
> > To: "Eric Dumazet" <edumazet@google.com>
> > To: "Jamal Hadi Salim" <jhs@mojatatu.com>
> > To: "Jiri Pirko" <jiri@resnulli.us>
> > To: "Jakub Kicinski" <kuba@kernel.org>
> > To: <netdev@vger.kernel.org>
> > To: "Paolo Abeni" <pabeni@redhat.com>
> > To: "Vinicius Costa Gomes" <vinicius.gomes@intel.com>
> > Cc: "Simon Horman" <horms@kernel.org>
> > Cc: <linux-kernel@vger.kernel.org>
> >=20
> > ---
> > v3:
> > - Ensure schedule entries truncated by an explicit cycle_time meet min_=
duration in parse_taprio_schedule()
> > - Clamp first entry end_time to cycle_time in setup_first_end_time()
> > - Parse and validate schedule before applying netdev traffic class conf=
iguration in taprio_change()
> > - Reject schedules with no entries in parse_taprio_schedule()
> > - Update commit message to detail the serviceability guarantee, cycle t=
runcation handling, and offload mode arithmetic
> >=20
> > v2:
> > - Enforce a minimum interval of 10 us (TAPRIO_MIN_SW_INTERVAL_NS) in so=
ftware mode instead of comparing cycle_time against the sum of intervals.
> > - Add taprio_min_interval() helper to determine the minimum interval ba=
sed on offload and txtime-assist flags.
> > - Use taprio_min_interval() in fill_sched_entry() and parse_taprio_sche=
dule().
> > https://lore.kernel.org/all/edd30c9e-6673-42a0-ab07-b7fb2bb67795@mail.k=
ernel.org/T/
> >=20
> > v1:
> > https://lore.kernel.org/all/3527dbf1-ab94-4184-8405-8552799efb71@mail.k=
ernel.org/T/
> > ---
> > diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
> > index 39ac5b97a..28ce7cb40 100644
> > --- a/net/sched/sch_taprio.c
> > +++ b/net/sched/sch_taprio.c
> > @@ -48,6 +48,10 @@ static struct static_key_false taprio_have_working_m=
qprio;
> >   * 60 * 17 > PSEC_PER_NSEC (1000)
> >   */
> >  #define TAPRIO_PICOS_PER_BYTE_MIN 17
> > +/* Minimum interval for software mode (hrtimer-driven advance_sched) to
> > + * avoid hrtimer interrupt storms and CPU starvation.
> > + */
> > +#define TAPRIO_MIN_SW_INTERVAL_NS (10 * NSEC_PER_USEC)
> > =20
> >  struct sched_entry {
> >  	/* Durations between this GCL entry and the GCL entry where the
> > @@ -259,6 +263,17 @@ static int length_to_duration(struct taprio_sched =
*q, int len)
> >  	return div_u64(len * atomic64_read(&q->picos_per_byte), PSEC_PER_NSEC=
);
> >  }
> > =20
> > +static int taprio_min_interval(struct taprio_sched *q)
> > +{
> > +	int min_duration =3D length_to_duration(q, ETH_ZLEN);
> > +
> > +	if (!FULL_OFFLOAD_IS_ENABLED(q->flags) &&
> > +	    !TXTIME_ASSIST_IS_ENABLED(q->flags))
> > +		min_duration =3D max_t(int, min_duration, TAPRIO_MIN_SW_INTERVAL_NS);
> > +
> > +	return min_duration;
> > +}
> > +
> >  static int duration_to_length(struct taprio_sched *q, u64 duration)
> >  {
> >  	return div_u64(duration * PSEC_PER_NSEC, atomic64_read(&q->picos_per_=
byte));
> > @@ -1039,7 +1054,7 @@ static int fill_sched_entry(struct taprio_sched *=
q, struct nlattr **tb,
> >  			    struct sched_entry *entry,
> >  			    struct netlink_ext_ack *extack)
> >  {
> > -	int min_duration =3D length_to_duration(q, ETH_ZLEN);
> > +	int min_duration =3D taprio_min_interval(q);
> >  	u32 interval =3D 0;
> > =20
> >  	if (tb[TCA_TAPRIO_SCHED_ENTRY_CMD])
> > @@ -1130,6 +1145,9 @@ static int parse_taprio_schedule(struct taprio_sc=
hed *q, struct nlattr **tb,
> >  				 struct sched_gate_list *new,
> >  				 struct netlink_ext_ack *extack)
> >  {
> > +	int min_duration =3D taprio_min_interval(q);
> > +	struct sched_entry *entry;
> > +	s64 elapsed =3D 0;
> >  	int err =3D 0;
> > =20
> >  	if (tb[TCA_TAPRIO_ATTR_SCHED_SINGLE_ENTRY]) {
> > @@ -1152,8 +1170,12 @@ static int parse_taprio_schedule(struct taprio_s=
ched *q, struct nlattr **tb,
> >  	if (err < 0)
> >  		return err;
> > =20
> > +	if (list_empty(&new->entries)) {
> > +		NL_SET_ERR_MSG(extack, "There should be at least one entry in the sc=
hedule");
> > +		return -EINVAL;
> > +	}
> > +
> >  	if (!new->cycle_time) {
> > -		struct sched_entry *entry;
> >  		ktime_t cycle =3D 0;
> > =20
> >  		list_for_each_entry(entry, &new->entries, list)
> > @@ -1167,12 +1189,28 @@ static int parse_taprio_schedule(struct taprio_=
sched *q, struct nlattr **tb,
> >  		new->cycle_time =3D cycle;
> >  	}
> > =20
> > -	if (new->cycle_time < new->num_entries * length_to_duration(q, ETH_ZL=
EN)) {
> > +	if (new->cycle_time < min_duration) {
> >  		NL_SET_ERR_MSG(extack, "'cycle_time' is too small");
> >  		return -EINVAL;
> >  	}
> > =20
> > -	taprio_calculate_gate_durations(q, new);
> > +	list_for_each_entry(entry, &new->entries, list) {
> > +		s64 remaining;
> > +
> > +		if (elapsed >=3D new->cycle_time)
> > +			break;
> > +
> > +		remaining =3D new->cycle_time - elapsed;
> > +		if (entry->interval > remaining) {
> > +			if (remaining < min_duration) {
> > +				NL_SET_ERR_MSG(extack, "'cycle_time' is too small");
> > +				return -EINVAL;
> > +			}
> > +			break;
> > +		}
> > +
> > +		elapsed +=3D entry->interval;
> > +	}
> > =20
> >  	return 0;
> >  }
> > @@ -1256,7 +1294,7 @@ static void setup_first_end_time(struct taprio_sc=
hed *q,
> >  	/* FIXME: find a better place to do this */
> >  	sched->cycle_end_time =3D ktime_add_ns(base, cycle);
> > =20
> > -	first->end_time =3D ktime_add_ns(base, first->interval);
> > +	first->end_time =3D ktime_add_ns(base, min_t(s64, first->interval, cy=
cle));
> >  	taprio_set_budgets(q, sched, first);
> > =20
> >  	for (tc =3D 0; tc < num_tc; tc++) {
> > @@ -1897,6 +1935,20 @@ static int taprio_change(struct Qdisc *sch, stru=
ct nlattr *opt,
> >  		goto free_sched;
> >  	}
> > =20
> > +	err =3D parse_taprio_schedule(q, tb, new_admin, extack);
> > +	if (err < 0)
> > +		goto free_sched;
> > +
> > +	if (new_admin->num_entries =3D=3D 0) {
> > +		NL_SET_ERR_MSG(extack, "There should be at least one entry in the sc=
hedule");
> > +		err =3D -EINVAL;
> > +		goto free_sched;
> > +	}
> > +
> > +	err =3D taprio_parse_clockid(sch, tb, extack);
> > +	if (err < 0)
> > +		goto free_sched;
> > +
> >  	if (mqprio) {
> >  		err =3D netdev_set_num_tc(dev, mqprio->num_tc);
> >  		if (err)
> > @@ -1914,19 +1966,7 @@ static int taprio_change(struct Qdisc *sch, stru=
ct nlattr *opt,
> >  					       mqprio->prio_tc_map[i]);
> >  	}
> > =20
> > -	err =3D parse_taprio_schedule(q, tb, new_admin, extack);
> > -	if (err < 0)
> > -		goto free_sched;
> > -
> > -	if (new_admin->num_entries =3D=3D 0) {
> > -		NL_SET_ERR_MSG(extack, "There should be at least one entry in the sc=
hedule");
> > -		err =3D -EINVAL;
> > -		goto free_sched;
> > -	}
> > -
> > -	err =3D taprio_parse_clockid(sch, tb, extack);
> > -	if (err < 0)
> > -		goto free_sched;
> > +	taprio_calculate_gate_durations(q, new_admin);
> > =20
> >  	taprio_update_queue_max_sdu(q, new_admin, stab);
> > =20
> >=20
> >=20
> > base-commit: cee9395acd8043be0644b25c34bfa86623f2b935
> > --=20
> > This is an AI-generated patch subject to moderation.
> > Reply with '#syz upstream' to Sign-off the patch as a human author
> > and send it to the upstream kernel mailing lists.
> > Reply with '#syz reject' to reject it ('#syz unreject' to undo).
> >=20
> > See https://goo.gle/syzbot-ai-patches for information about AI-generate=
d patches.
> > You can comment on the patch as usual, syzbot will try to address
> > the comments and send a new version of the patch if necessary.
> > syzbot engineers can be reached at syzkaller@googlegroups.com.
