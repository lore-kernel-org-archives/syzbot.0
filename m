Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8E8249DB99
	for <syzbot@lists.linux.dev>; Fri,  9 Oct 2026 09:33:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=100.103.45.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791538438; cv=pass; b=XxUEYtC8G6Sji0OEJ6BLy+ocxIMJ1UaQJGzWuCPRx9HWtJAGZYoDwwCDEqVKEf1JTQbvjRmE5DgziKA+y+Q/FjBGaL/Afg8FYGGZc8FAdOgEZH2nYcpZfS3Uz+xFntX6n+40GEok79whpmRHlaJ5ien9YWYzMPa2wWPfP1Pfj6I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791538438; c=relaxed/simple;
	bh=d/yYvLNOpzfkzMPStIQlbsHvrJwr785yIpJEaNhuLPA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Z88RlcthMPukpd+H9NxNT5LAztXSn4t7b6bevPneUSuaSt5DJ8GdlMvgXfzb+5HOCJ6g7NowDnvqkxNboT7kwhLFOrL45deKMV8aR3myYlDWGQNEcagKS9+FtnsceJgOWid80D98QoA+hA1HKXYtC+Q9gDN4EILdnjA2PQt6yjE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gI4OzmAz; arc=pass smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gI4OzmAz"
Received: by smtp.kernel.org (Postfix)
	id 7DE431F00893; Fri,  9 Oct 2026 09:33:51 +0000 (UTC)
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=209.85.218.52
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1791538431;
	b=e4b+mG4AtuISiOJDo4P06LGYWCImrjdHhTRtYPDfhIMIlHHSbtSHT14SQc90xatViwfx
	 KSFO9NNzTowOzz7e2cbuvQIHuyt8I+58OgxkoQKIDsMpaGiQRjxarEIruO3ikQQ1uwHAm
	 /F1bsxZoMc0j3Z0Z/pKAovoa8BpzlJ5vlVoCZXS6vnB6H9JmP9MHluXbje+zAz+I+hC55
	 zFn5Au/tUmzCnEv+QSXSTTTB71Ixlc7mdJt6VqExKvVK4KTEBOVSxd9ggNnNOOYWExNUE
	 v4gWkFsXb2Kxw58jOQsrEJDthVv8z5TLxqEzcZLM10hGHwRxqi3mNWGm7kcQVztvEnw==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1791538431;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:Content-Transfer-Encoding:In-Reply-To;
	bh=OqAdb0fWmdR5Oir2EFpnA62w+jYOxx8Al4t5MMAe3e4=;
	b=Vbt4UtPxHy5o3MLZBEB3trtq4cMbwBuwezCb9Xn3+N3YKqVWYjQGXB75eDP41t/65vxB
	 8WIv1G0vQT2gTv4RxmVzQDISOssCicPjX+u1VWrfJiHrAN3eQpbob4YHJMm2tlKDQiKP6
	 M6NtUhit12UsqDciibSUhSy4d2xfVnEujrJU1jhfS13r/igqV+3JmF+FWOX98neYG/Och
	 kvO+pZ5/ZiJlVvXc8Wu9tKfjRZROqNAmXs+CauTRoTZ2OiRCbQIt9bjs57BCi3aY7QSqv
	 yafY7OcXobpouOv+apBkqJ1NDRjdyb44EAYs1wGb2QqQ19gk5NHjubggpIathH6CWEA==
ARC-Authentication-Results: i=1; smtp.kernel.org; dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=gI4OzmAz;
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	arc=none smtp.remote-ip=209.85.218.52
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 28FBA1F000FF
	for <syzbot@kernel.org>; Fri,  9 Oct 2026 09:33:50 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=gI4OzmAz
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.kernel.org 28FBA1F000FF
Authentication-Results: smtp.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-c263415982eso545635166b.0
        for <syzbot@kernel.org>; Fri, 09 Oct 2026 02:33:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791538428; x=1792143228; darn=kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=OqAdb0fWmdR5Oir2EFpnA62w+jYOxx8Al4t5MMAe3e4=;
        b=gI4OzmAzR70jKJxyKfo/ve/vqbOtwr3BOwKXBnJnJguxKfx64Ns1vT0wkCrjfuceUx
         gs8aTUoLEciJGlZT1qg56/TKbd6mRz7IdzB8ZfHWWMUgFbEpHhYUF1YqVRu6ESXQGFpx
         BzXVRG5D4YsggTgkBDmNhKCLQ75zDF+q7QjpbBbkQ7xvS8HeiuRZvdqA5LdgxM0Z/ROg
         nGiOkvVx+0aCsiMZghK2gC3m5jBOz4axqOWTAd91U0MWWqILPo+sbCG7S56jgeONuxo+
         1MeP1Q5ozouKle777HYumkjAxsk18dkcVFCnuLDgief+mxsxgwoPgXQBczv3fo/rwxhl
         ilRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791538428; x=1792143228;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=OqAdb0fWmdR5Oir2EFpnA62w+jYOxx8Al4t5MMAe3e4=;
        b=qCjhBgGSbPMuTRQ0TmA0AsLpWHqkqL3Uh4V9fvVwGL3JwTLFsi1dO1K0Y96qtLuEJh
         ygJRMLs7SCOmyVF2Xwm6VSe9KJPMAI318xVlBj6yomSetMsQh8rMPa/Nabxb/Ts26zl/
         8hFlcwEueon9CuL53RiGimoLl7OZlUaHzK6o//oQb+jPVyX17RuNhr5chb0LcgJjboSa
         oEspUp29Gtafa3HjB3Zi2ZRBMU+HWvjzqyWedMX5WwzwXPcGK0sczCzbUwD8dY0LAstF
         XSn/3DA6k2gzAvwtHSjulN0PsWhi+v+Z+iNS/RcgXO6jECpATsKA+qZfCk1sab5CGTJg
         qXyw==
X-Gm-Message-State: AFq9FYLtO7QdRU2JrjeCreB+VNQnAOpu1ZlJx+OUY5MPlvE7tb/P7OGC
	yQQZiLEnZJv1klYVQdjDqWmaNWCd2VcEQJplZz6xs+IQdwrC/36M/PRJZpNtZQ==
X-Gm-Gg: AYBFou0RGpm13xKF7daYUmMcJnkPY7yDTI/e0Naxyw+KL34XEgHo1YDFpgx0L7PaMcf
	D8OBT108ADtSXwlKl/QAwypCYE3zS9/YGURBIWRk2WpssF5HuiRJVPlyqvSqwuMwBhIu1wzIVf5
	tWrJbGiv8dXtXwCpGuovTCvomq2zFZeBF+m3m/CDLRlhuuGm0thIYuOe/IC5Enn52EnicXyeiIh
	kmABSHGSrUJgfcPxUoMCyXUs7Y2ZJKjEQuZSttJWV/Q2TseF3AwSqsL74lP98DPZSaMv8sk7ahX
	9S+pa9eypEj1l2a/cBJQqkTsEuwbcaxkclmeBYzP8hkDNnkuyqjOFja39GAfBB9Aec3J9pc7+yC
	9XeUD/pNzbqMzTfsaHWtQ6M19YpEpfzr39rC7VKeb6Y3JpBf4YkKcJXYA2noM0vw/jB/cTu0qiS
	5Uh9Im0gNnIYTe9hKMVq8ke1YOMFiBKIS5XvjTK6yKsqeQ7WyDcCQMq1QledKTdhUaFMIBzESBC
	sGDc4FNFogHCF38QxoRQg==
X-Received: by 2002:a17:907:3da1:b0:c2a:ad55:b3fa with SMTP id a640c23a62f3a-c31a9a052a0mr128247766b.7.1791538428162;
        Fri, 09 Oct 2026 02:33:48 -0700 (PDT)
Received: from localhost ([37.30.48.8])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c31a9ac712asm68173566b.72.2026.10.09.02.33.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Oct 2026 02:33:47 -0700 (PDT)
Date: Fri, 9 Oct 2026 11:33:46 +0200
From: Bartosz Chronowski <immersa.bartosz.chronowski@gmail.com>
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Subject: Re: [PATCH RFC v4] net/sched: taprio: enforce minimum interval in
 software mode
Message-ID: <g6ush3xvqkz6yish7y5qqodiz3yr5u567bwycnnfhcbcbrmsjv@7v44aayzfl6s>
References: <e048bbcd-a352-43e2-bef2-a08c12b27099@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <e048bbcd-a352-43e2-bef2-a08c12b27099@mail.kernel.org>

v4 makes substantial progress. It materializes one effective schedule for
the consumers and coalesces missed cycles instead of walking every elapsed
transition. The direction is correct, but the code still mishandles an exact
interval boundary and can retain configuration changes after a rejected
replacement. The runtime comparison did not reproduce the report on the
historical or unpatched base, so the patched negative result does not
establish a runtime fix. The patch is not ready yet.

Keep the shared effective schedule and missed-cycle coalescing. Keep the pa=
tch
as small as possible while preserving the required behavior; avoid unrelated
refactoring. Address the following issues:

- Make an exact interval start valid in is_valid_interval() and
  get_packet_txtime(). Check every TXTIME lookup caller and test below, at,
  and above the boundary without selecting an unreachable tail.

- Make a rejected replacement preserve every changed configuration field,
  including max_sdu and fp; traffic-class-map cleanup alone is insufficient.
  Stage changes until acceptance or restore them, and test rejection against
  an installed schedule.

- Establish deadline-at-rearm and administrative-switch behavior with
  delayed-callback, gate, and budget tests; these remain proof gaps.
  The fallback still scans the effective list, so narrow the O(1) and
  universal 10 us claims to the bounds actually established.

Also fix the two excessive indentation warnings reported by checkpatch.

Impact assessment: the supported concerns are CPU progress, schedule
semantics, and preservation of installed configuration. The current evidence
does not establish privilege escalation, confidentiality loss, memory
corruption, or a reproduced runtime repair.

Kind Regards / Mit freundlichen Gr=C3=BC=C3=9Fen
BART CHRONOWSKI

On Fri, Oct 02, 2026 at 02:31:08AM +0000, syzbot wrote:
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
> introduce taprio_min_interval(). For software mode, enforcing a minimum
> interval of 10 us establishes a serviceability guarantee: because 10 us is
> significantly larger than the execution latency of advance_sched(), the C=
PU
> is guaranteed sufficient processing time between timer interrupts to make
> forward progress, service softirqs, and advance RCU grace periods. For
> TXTIME-assist and full-offload modes, advance_sched() does not drive
> schedule switching in software, so taprio_min_interval() continues to
> compute length_to_duration(q, ETH_ZLEN) without the 10 us clamp, preservi=
ng
> hardware offload capabilities.
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
> To further guarantee serviceability under worst-case timer delays (e.g.
> from high interrupt latency or preemption), advance_sched() now enforces
> bounded catch-up work and strictly future timer expiration. If the timer
> fires late such that the scheduled expiration time has already passed,
> advance_sched() advances at most a bounded number of entries (up to 32)
> before switching to an O(1) cycle-advancement fast-forward path. If the
> resulting target expiration remains in the past, it clamps the next
> expiration time to at least taprio_min_interval(q) into the future.
> Bounding catch-up iterations to constant time and guaranteeing that timer
> expiry is always strictly in the future ensures that the CPU cannot be
> trapped in an hrtimer interrupt loop and will always make forward progres=
s.
>=20
> Finally, parse and validate the schedule in taprio_change() before invoki=
ng
> netdev_set_num_tc(), ensure netdev traffic class configuration is cleanly
> rolled back on subsequent errors, move taprio_calculate_gate_durations()
> after traffic classes are established, and reject empty schedules.
>=20
> Fixes: 6ca6a6654225 ("taprio: Add support for setting the cycle-time manu=
ally")
> Assisted-by: Gemini:gemini-3.8-flash syzbot
> Reported-by: syzbot+14c6ac6811273526cfa5@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3D14c6ac6811273526cfa5
> Link: https://syzkaller.appspot.com/ai_job?id=3D706e3d4e-5003-47b1-b0b1-1=
eb29cf65731
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
> index 39ac5b97a..c02a03cf2 100644
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
> @@ -888,7 +903,7 @@ static bool should_change_schedules(const struct sche=
d_gate_list *admin,
>  {
>  	ktime_t next_base_time, extension_time;
> =20
> -	if (!admin)
> +	if (!admin || !oper)
>  		return false;
> =20
>  	next_base_time =3D sched_base_time(admin);
> @@ -916,6 +931,57 @@ static bool should_change_schedules(const struct sch=
ed_gate_list *admin,
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
>  static enum hrtimer_restart advance_sched(struct hrtimer *timer)
>  {
>  	struct taprio_sched *q =3D container_of(timer, struct taprio_sched,
> @@ -925,8 +991,7 @@ static enum hrtimer_restart advance_sched(struct hrti=
mer *timer)
>  	int num_tc =3D netdev_get_num_tc(dev);
>  	struct sched_entry *entry, *next;
>  	struct Qdisc *sch =3D q->root;
> -	ktime_t end_time;
> -	int tc;
> +	ktime_t end_time, now;
> =20
>  	spin_lock(&q->current_entry_lock);
>  	entry =3D rcu_dereference_protected(q->current_entry,
> @@ -939,6 +1004,13 @@ static enum hrtimer_restart advance_sched(struct hr=
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
> @@ -949,42 +1021,74 @@ static enum hrtimer_restart advance_sched(struct h=
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
> -	}
> +		if (ktime_compare(end_time, now) <=3D 0) {
> +			ktime_t cur_start;
> +			s64 diff;
> +			int tc;
> =20
> -	next->end_time =3D end_time;
> -	taprio_set_budgets(q, oper, next);
> +			if (admin && ktime_compare(sched_base_time(admin), now) <=3D 0)
> +				switch_schedules(q, &admin, &oper);
> +
> +			diff =3D ktime_sub(now, oper->cycle_end_time);
> +			if (diff >=3D 0) {
> +				u64 cycles =3D div64_u64(diff, oper->cycle_time) + 1;
> +
> +				oper->cycle_end_time =3D ktime_add_ns(oper->cycle_end_time,
> +								    cycles * oper->cycle_time);
> +			}
> +
> +			cur_start =3D ktime_sub_ns(oper->cycle_end_time, oper->cycle_time);
> +			next =3D list_last_entry(&oper->entries, struct sched_entry, list);
> +			list_for_each_entry(entry, &oper->entries, list) {
> +				ktime_t cur_end =3D ktime_add_ns(cur_start, entry->interval);
> +
> +				if (ktime_compare(cur_end, now) > 0) {
> +					next =3D entry;
> +					end_time =3D min_t(ktime_t, cur_end, oper->cycle_end_time);
> +					next->end_time =3D end_time;
> +					for (tc =3D 0; tc < num_tc; tc++) {
> +						u64 dur =3D next->gate_duration[tc];
> +
> +						if (dur =3D=3D oper->cycle_time)
> +							next->gate_close_time[tc] =3D KTIME_MAX;
> +						else
> +							next->gate_close_time[tc] =3D
> +								ktime_add_ns(cur_start, dur);
> +					}
> +					taprio_set_budgets(q, oper, next);
> +					break;
> +				}
> +				cur_start =3D cur_end;
> +			}
> +
> +			if (should_change_schedules(admin, oper, end_time)) {
> +				switch_schedules(q, &admin, &oper);
> +				next =3D list_first_entry(&oper->entries, struct sched_entry, list);
> +				end_time =3D next->end_time;
> +			}
> +
> +			if (unlikely(ktime_compare(end_time, now) <=3D 0)) {
> +				end_time =3D ktime_add_ns(now, taprio_min_interval(q));
> +				next->end_time =3D end_time;
> +			}
> +		}
> +	}
> =20
> -first_run:
>  	rcu_assign_pointer(q->current_entry, next);
>  	spin_unlock(&q->current_entry_lock);
> =20
> @@ -1130,7 +1234,11 @@ static int parse_taprio_schedule(struct taprio_sch=
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
> @@ -1152,8 +1260,12 @@ static int parse_taprio_schedule(struct taprio_sch=
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
> @@ -1167,12 +1279,45 @@ static int parse_taprio_schedule(struct taprio_sc=
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
> @@ -1256,7 +1401,7 @@ static void setup_first_end_time(struct taprio_sche=
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
> @@ -1828,6 +1973,7 @@ static int taprio_change(struct Qdisc *sch, struct =
nlattr *opt,
>  	struct taprio_sched *q =3D qdisc_priv(sch);
>  	struct net_device *dev =3D qdisc_dev(sch);
>  	struct tc_mqprio_qopt *mqprio =3D NULL;
> +	bool tc_configured =3D false;
>  	unsigned long flags;
>  	u32 taprio_flags;
>  	ktime_t start;
> @@ -1897,10 +2043,25 @@ static int taprio_change(struct Qdisc *sch, struc=
t nlattr *opt,
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
> @@ -1914,19 +2075,7 @@ static int taprio_change(struct Qdisc *sch, struct=
 nlattr *opt,
>  					       mqprio->prio_tc_map[i]);
>  	}
> =20
> -	err =3D parse_taprio_schedule(q, tb, new_admin, extack);
> -	if (err < 0)
> -		goto free_sched;
> -
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
> +	taprio_calculate_gate_durations(q, new_admin);
> =20
>  	taprio_update_queue_max_sdu(q, new_admin, stab);
> =20
> @@ -2008,6 +2157,11 @@ static int taprio_change(struct Qdisc *sch, struct=
 nlattr *opt,
>  	spin_unlock_bh(qdisc_lock(sch));
> =20
>  free_sched:
> +	if (err && tc_configured) {
> +		netdev_reset_tc(dev);
> +		memset(q->cur_txq, 0, sizeof(q->cur_txq));
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
