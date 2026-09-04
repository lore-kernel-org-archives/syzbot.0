Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2504D46D57E
	for <syzbot@lists.linux.dev>; Fri,  4 Sep 2026 11:22:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788520955; cv=none; b=i2Ol8YDmKB8WVmRF+CJPe8XOgoALUa+wI4qrhH1wIecI0VcvXJSsI86UWqv//Lw25aLcInqHC46Eg5Mb4jCt7QRdUDkvGX5Zx04+B5/WdhFUHIe6u1h40HXKPy5TCzHzpjtMVNGd5pP9ntibKBgtkmQg2x9lDewOYEXsc/02hrg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788520955; c=relaxed/simple;
	bh=sGoedHlqpIzywKEz8FSVvZvqVi265lsI03Jq3yCVdYU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UKp767+W90BfoM3Zj44hWWlgb6hZnef7t67v0LAcZ1zFdPvyVwrlFETVbFxTAExbMBbm03z2DJpI2V4CNkwoogpBvHUeOyv05k7lAGAZCBC0f4QzSY61PypeUtap5HP7tf/rz6PiXCf7pq0276MAfoEdeIf/3IEISuTT9asodIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZV9pYcYb; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZV9pYcYb"
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-c2531f453eeso114007166b.3
        for <syzbot@lists.linux.dev>; Fri, 04 Sep 2026 04:22:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788520951; x=1789125751; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=t8s4aLtL2Tx0ScboJ7+/Ks0jJ3azlsEaH88Y64vgjx0=;
        b=ZV9pYcYbkFO3PPzJjs7V2Y1o84qFV06rqmi8Lj5YOfMy7tPVzGvBgysE/SSj7RbeCM
         DFGRCPbjPZie1eDokXEPNuIkK5RzMvQYHbydKAOHfOrpqzEtZ1RC4EWlMgLxDwuS/RbK
         izBiEwZ7RRl+mH147+AZS3jtbYe8+3ghuoptatwRsIoUR+WS5XZJPHwOPFYhgj0bEGQT
         XZ9E1JqcRoJdDFr7ZtwbyOiZ6IN5K9e9sTnDABSJrnrL+kSQgGDECgGw3TzX2sVdI2G5
         iFbxaazbs8Qf6fPCi/IXNIiMMrvK4FgUUZhLIbjVVSnzB9MQTgKKuEvV5Mybxwe7nPlB
         QOLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788520951; x=1789125751;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=t8s4aLtL2Tx0ScboJ7+/Ks0jJ3azlsEaH88Y64vgjx0=;
        b=Z8TcBmx3PJK7xqKQNEMwaUXX/I9VFHK8IpVr99a73rLoMSAVmxtj6JrkUEt5B0GnfL
         28tqSBPN5hBPDzS0d/7zxvej9pYkh6aFsA2wWt3KIeKurG0BNDSYmkIukzMXntiscgbN
         P8w0ujN9Z4cI9j05it20BV+xR0KkkJ0/qkw6HSlzLXIU47W3VkpXyOoYql28HeWFq6KT
         V5eto9N4XfMcBdW5kclLQ8cBu7YBlCoZTFd0j3z8cW3WrSyKSygzs3dATKscyLn7PCiT
         kiTVlxHfWsaGHkK46xbwtL6obhAFnOQh7a++sH4mmQyTZjziSsfdYGNigkldq0AAV9aS
         wkjQ==
X-Forwarded-Encrypted: i=1; AKwUvByuk7FEcE63v5OYJSpkz5kzjkh47EDHWF60oddBRItu+2M7uTc3q5aetMRBcHODI3PV5T7UWt8=@lists.linux.dev
X-Gm-Message-State: AFuF++ldtER5cL0mvhc95Li/E1FvcgjOe0U9HR366zKezvCMZKoqMVVW
	de8GYnWA05qN+xgAdfs2Nbgt47bolnYI70olN3QTkTrkuA/VQZgIxhuzb9wICA==
X-Gm-Gg: AYBFou3L9BC8s+eOhOKd+/UgEuzu1x0t2gT9Itn4mBkyg9xxxAO+dMyQvZ3KC/kXHpU
	9B1KQzP5k3XX120V/2/WktJ1hxRlEc4srxobA5ijSTmu8Tq2FfMY+lyccTxdBbwfgE+qVCsejJo
	mL87d33pEw19xENbC1ugSqwuM4fijpccQibM8d3JEPZmhEX+s9gzqPTjgiuHXFgWU7S72XV0Dgi
	LfY4N5HtPqZg4l046SnQ3LV4ulESkZShfNc5LElmrCGKuhmkupdKIjNXKWb/lq0qSU1Z694/jPH
	6efXm3Z1rGfHrj7Ey+Wtvc8eX9Zet/CQpx/eueFDzgIuB4E2mPIwVzZ8PXhJJnVuaR9xQSYmvRl
	nohY1Ahashp5md+Yj5JLlRYDqpMlBmQamXnF9AvyztFBpPiRQ7SlxOW9ow+fsa/U3M3BDb99gD+
	gnX4YnfL6zTZ1jZ2IzSkFKD+G57PKSCv1OGXay3xBuMKFx2TnlJAJk2x8xa+rymR62zUX3W3byu
	iYYzv1z7ERK
X-Received: by 2002:a17:907:c16:b0:c25:2d27:5652 with SMTP id a640c23a62f3a-c260c9d1affmr344636766b.11.1788520951101;
        Fri, 04 Sep 2026 04:22:31 -0700 (PDT)
Received: from localhost ([37.30.42.42])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c260d582304sm94046566b.43.2026.09.04.04.22.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2026 04:22:30 -0700 (PDT)
Date: Fri, 4 Sep 2026 13:22:29 +0200
From: Bartosz Chronowski <immersa.bartosz.chronowski@gmail.com>
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Subject: Re: [PATCH RFC] net/sched: taprio: reject cycle_time smaller than
 sum of intervals
Message-ID: <tcffxlm6kp4w3yiuecikflg4hlt75tiyxo4hv7swtmausvmlqi@xryepktxtrbd>
References: <3527dbf1-ab94-4184-8405-8552799efb71@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <3527dbf1-ab94-4184-8405-8552799efb71@mail.kernel.org>

The v1 code change is not correct for this report. It recognizes the overdue
hrtimer symptom, but the new comparison still accepts the selected unsafe
schedule and also rejects supported configurations. The runtime runs do not
prove a fix: the historical, unpatched-base, and patched-base kernels each
produced 0 target reports in 4 runs. Deterministic schedule checks still sh=
ow
that the selected input is accepted and that supported behavior regresses, =
so
the patch needs to be rewritten.

The selected input has 205 ns and 129 ns entries and no explicit cycle time.
TAPRIO therefore derives a 334 ns cycle, equal to the sum of the entries, a=
nd
the cycle_time < sum(intervals) test is false. In software mode this schedu=
le
requires about 5.99 million hrtimer callbacks per second. advance_sched()
restarts one absolute deadline per entry; once those deadlines remain in the
past, hardirq processing can monopolize the CPU and starve RCU. The kjourna=
ld2
stall is a consequence, not the source of the bug.

Replace the entry-sum comparison with a fix that enforce a defensible=20
boundary only for hrtimer-driven software mode.

Security impact: the syzbot AI patch leaves a configuration-driven local
denial-of-service path reachable and adds compatibility failures outside th=
at
path.

Kind Regards / Mit freundlichen Gr=C3=BC=C3=9Fen
BART CHRONOWSKI

On Mon, Aug 31, 2026 at 10:13:41PM +0000, 'syzbot' via syzkaller-upstream-m=
oderation wrote:
> When configuring a taprio schedule, if TCA_TAPRIO_ATTR_SCHED_CYCLE_TIME is
> explicitly provided, parse_taprio_schedule() does not validate that
> cycle_time is at least the sum of the schedule entries' intervals. If an
> explicitly configured cycle_time is smaller than an entry's interval,
> advance_sched() clamps the entry's end_time to oper->cycle_end_time via
> min_t(ktime_t, end_time, oper->cycle_end_time).
>=20
> When the timer fires at cycle_end_time, should_restart_cycle() returns
> true, which restarts the cycle and advances oper->cycle_end_time by
> cycle_time. If cycle_time is configured to an extremely small value (e.g.
> 64 ns), which is less than the CPU time required to execute the timer
> callback itself, the newly calculated expiration time is always in the
> past. Consequently, the hrtimer subsystem repeatedly and immediately
> re-invokes advance_sched() in hardirq context, resulting in an interrupt
> storm that starves the CPU and triggers RCU stalls:
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
> Fix this by calculating the sum of intervals in parse_taprio_schedule()
> unconditionally and rejecting configurations where an explicitly provided
> cycle_time is less than the calculated sum with -EINVAL.
>=20
> Fixes: 6ca6a6654225 ("taprio: Add support for setting the cycle-time manu=
ally")
> Assisted-by: Gemini:gemini-3.7-flash Gemini:gemini-3.1-pro-preview syzbot
> Reported-by: syzbot+14c6ac6811273526cfa5@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3D14c6ac6811273526cfa5
> Link: https://syzkaller.appspot.com/ai_job?id=3Df188bb15-dc33-47d1-92bf-7=
a65fde0fcd7
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
> diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
> index 39ac5b97a..137ce6f7a 100644
> --- a/net/sched/sch_taprio.c
> +++ b/net/sched/sch_taprio.c
> @@ -1130,6 +1130,8 @@ static int parse_taprio_schedule(struct taprio_sche=
d *q, struct nlattr **tb,
>  				 struct sched_gate_list *new,
>  				 struct netlink_ext_ack *extack)
>  {
> +	struct sched_entry *entry;
> +	ktime_t cycle =3D 0;
>  	int err =3D 0;
> =20
>  	if (tb[TCA_TAPRIO_ATTR_SCHED_SINGLE_ENTRY]) {
> @@ -1152,19 +1154,20 @@ static int parse_taprio_schedule(struct taprio_sc=
hed *q, struct nlattr **tb,
>  	if (err < 0)
>  		return err;
> =20
> -	if (!new->cycle_time) {
> -		struct sched_entry *entry;
> -		ktime_t cycle =3D 0;
> -
> -		list_for_each_entry(entry, &new->entries, list)
> -			cycle =3D ktime_add_ns(cycle, entry->interval);
> +	list_for_each_entry(entry, &new->entries, list)
> +		cycle =3D ktime_add_ns(cycle, entry->interval);
> =20
> -		if (cycle < 0 || cycle > INT_MAX) {
> -			NL_SET_ERR_MSG(extack, "'cycle_time' is too big");
> -			return -EINVAL;
> -		}
> +	if (cycle < 0 || cycle > INT_MAX) {
> +		NL_SET_ERR_MSG(extack, "'cycle_time' is too big");
> +		return -EINVAL;
> +	}
> =20
> +	if (!new->cycle_time)
>  		new->cycle_time =3D cycle;
> +
> +	if (new->cycle_time < cycle) {
> +		NL_SET_ERR_MSG(extack, "'cycle_time' is less than the sum of entry int=
ervals");
> +		return -EINVAL;
>  	}
> =20
>  	if (new->cycle_time < new->num_entries * length_to_duration(q, ETH_ZLEN=
)) {
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
>=20
> --=20
> You received this message because you are subscribed to the Google Groups=
 "syzkaller-upstream-moderation" group.
> To unsubscribe from this group and stop receiving emails from it, send an=
 email to syzkaller-upstream-moderation+unsubscribe@googlegroups.com.
> To view this discussion visit https://groups.google.com/d/msgid/syzkaller=
-upstream-moderation/3527dbf1-ab94-4184-8405-8552799efb71%40mail.kernel.org.
