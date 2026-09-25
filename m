Received: from mail-ej2-f22.google.com (mail-ej2-f22.google.com [74.125.228.150])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B4143B14B7
	for <syzbot@lists.linux.dev>; Fri, 25 Sep 2026 18:42:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.150
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790361723; cv=none; b=kZ8KemG/JLYgiLkzzMMt9d2jvfP6jEY0oG5fw3ps42hor2dqC0IB4grQWnURh5SzAZGA/KK5IbXtIfydFOcX3QMfrVC9UxILDNe07AyCcP4CbAz9tzFGiZPZYQYt/hkQ38O8aVygLouaSVc3x7NCNC/Iw9Tr5TURmOaEpYHcWSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790361723; c=relaxed/simple;
	bh=JPFi4U8tXUD3XUZjkGDNBGqXtOWvnvriuNMOkD73aNc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aDt6roVBozEgxMXeXGCXvsT/fJNo3BVnebAdalmHFa6V+6hE8FFm82KojLjH6ZhEULLOW49KNGoL8zs69D+0Ba4SC8lYHiiZLKrjpNrpBEL8pFUGWEPQBSR5B4iGKIVSBY20AN66yzxZiIeQdX73bL0gS0M0Bcvw6MW05hHOcfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iPRA+JHm; arc=none smtp.client-ip=74.125.228.150
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iPRA+JHm"
Received: by mail-ej2-f22.google.com with SMTP id a640c23a62f3a-c2afd63c3e0so59001966b.0
        for <syzbot@lists.linux.dev>; Fri, 25 Sep 2026 11:42:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790361719; x=1790966519; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Egt9MpqwPVRCFhCCLMK8o3FODMspYzJET0Y+ncLgc/c=;
        b=iPRA+JHm2cw4rvim7QKecQXDNoStPZB3aO2+V7PMxQLLfZuYDToGdvPk95jbpfXXat
         KJC0liSyEmPrQO4VIT/TEUtTqVcQHCCBtF1/YSzgCEYirUYU5r9bBpobnaDM0uTig6PM
         1itqMRjR7Eo5FsBDvVRwJNC9Qebg/K6m0i5a/W+Q4Ogtmvv05Lr5gfdlGG3buSfVsV+C
         vy7u5UsBeUzW7zehHQTkOtRT8FkR1/PiH8D1PvBId6S9MUV+ypEymbSaws9bPCMUuFiU
         eXck3OvbQHSkNeYc037iJz9wzDB49WGCRgmqrJXanPgaHvpYUVjBuUPTOngFPANFZJGZ
         rqzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790361719; x=1790966519;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=Egt9MpqwPVRCFhCCLMK8o3FODMspYzJET0Y+ncLgc/c=;
        b=0+HDq9Ue8+PD7E5osTOCgvy3SE4akSot0v9EPqgvv/hNq5C8EcKTzvXt89r8adETLP
         CIpoHxbJXLVGkEoWA6eA1kbJChUGe7hGM0RA5CPkNMqc1QP9WDoY117aYA84XiWGt9mg
         Tx6Vi45l0nczvOZtrLxtpjeOQcSmvBLUmUYszTAvgZ8JUeYS/tBbBMA3KjgcBor06tp0
         CfQwBkNRULcAEA8m3wlWYbvhVuEqTnaDX5XMyVQ8N3Ai+OmPSK/OWnMNXiHNvCdtRBSE
         +PVFUibj7WdcfpeB38rh9i7sui3zrkH41NXfzkSBbLMrJeeussbrK2veDTuYCpWyjlVR
         pfDw==
X-Forwarded-Encrypted: i=1; AKwUvBwO+C542Crv9oxZn17GfmmobQjxagKSEMpOuhlalHZy7Qf+v9V0HaJVcLG+0IJSbKCsQH+l3rI=@lists.linux.dev
X-Gm-Message-State: AFuF++kAdjVjfhsHqecCnfSvyy6mnt2BgRhPm7qd/DDOPOhhOjboWmx4
	GBMGmYFaG4pkrgPXS2rPMsJaCWRv4+/shiJqeljoGBoJ4Thrhi7467lw
X-Gm-Gg: AYBFou0g5urhMZtMoPXwzqsWeJcsU/pjS5N4IODedjtpICvDG9xGrNi+/2wuzvzLTAc
	arcMfMFIXuxYsPpQPKkYkKBOn8EoZO/KlXOlUWzBZfjZ9zynq7sx4ZNOTZ0tLKgiYkevQ6KH/C4
	ICqCAZHMjg25vjfD7Cbi03uIZL3IaA9DRAWCkJVMfSD5nXrw9oe0c6KW8ciwcLivXsddFeTVb84
	K1AuqIcM0LehPXHG0793Pj0drPGVdVYlSBlKHyjvVgFwP7u6RBloMzxyNDrLVDhFA8RA40bdTVS
	fLJCgDpMvfwQDzEb/Uk/LjfvCHcmHAHmWfhsS8lqgiMgbnkBvobgj+5bHduIR3Gxgjyb+wKorLn
	pcG934TWCRifKrowQqnjOb7qBmjTbfK4TNw12ayb+IfC2LdFtGOatyIEBNtEpfVEuASx7bAuZud
	Xcj0Envjv4BF1jGQnGaJLepvuOIhs+oSM6HN/0ao+nSCOcJSWyAJteBEjR1pfYDt8FJqD/PDixK
	XtjAGZW9eDWvABDzm3PUB7U
X-Received: by 2002:a17:907:e8f:b0:c29:63f2:99bb with SMTP id a640c23a62f3a-c2ac26820b5mr691190366b.47.1790361719177;
        Fri, 25 Sep 2026 11:41:59 -0700 (PDT)
Received: from localhost ([37.30.46.119])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c2b0f2f4f53sm41888566b.47.2026.09.25.11.41.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Sep 2026 11:41:58 -0700 (PDT)
Date: Fri, 25 Sep 2026 20:41:58 +0200
From: Bartosz Chronowski <immersa.bartosz.chronowski@gmail.com>
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Subject: Re: [PATCH RFC v3] net/sched: taprio: reject excessively small
 intervals in software mode
Message-ID: <hnr2mk4i73sm7lsf7222imbrty7ig4cv7rb35nmxfxc6s67znr@wb4rvul64ayh>
References: <ecbfe945-f1ab-45de-aaa0-b9b57ae730c2@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <ecbfe945-f1ab-45de-aaa0-b9b57ae730c2@mail.kernel.org>

The v3 code is not ready for upstream submission. It rejects the reported
255 ns schedule, but the fixed 100 us floor changes which software TAPRIO
configurations are accepted, does not cover intervals truncated by a shorter
cycle_time, and does not bound the callback backlog of an otherwise valid
schedule. Replace the admission-only fix with bounded catch-up in
advance_sched().

The 100 us expression is an input threshold, not a timer delay. A schedule
containing two 200 us entries with a 250 us cycle illustrates the incomplete
check: both entries and the aggregate cycle pass v3, but the effective seco=
nd
interval is only 50 us. Conversely, configurations whose intended intervals
are below 100 us are rejected even when they do not reproduce the reported
stall.

A fixed 100 us floor was already questioned during public review and removed
=66rom the related series:
https://lists.openwall.net/netdev/2026/08/24/361
https://lists.openwall.net/netdev/2026/08/31/102

Please implement the replacement as follows:
1. Retain the existing hardware-derived minimum-duration validation. Remove
   the fixed 100 us software-mode floor.
2. Calculate the repeating schedule period as
   min(cycle_time, sum_of_entry_intervals).
3. After one ordinary entry transition, use hrtimer_cb_get_time() to determ=
ine
   lateness. Skip all complete elapsed periods arithmetically by advancing
   start_time, end_time and cycle_end_time by an identical whole-period del=
ta.
4. Distribute the remaining transitions across callbacks, one ordinary entry
   transition per callback. The number of remaining callbacks must be bound=
ed
   by the entries in one period and must not depend on the number of comple=
te
   periods that elapsed.
5. Evaluate a pending admin-schedule transition after the arithmetic skip a=
nd
   before changing gate-close times or entry budgets. Keep the operational
   current_entry published until the replacement schedule actually becomes
   active.
6. Preserve explicit cycle truncation, cycle times longer than the interval
   sum, TXTIME mode and full offload. Use overflow-safe arithmetic when
   checking whether an entry extends beyond the cycle boundary.
7. Set the callback's next hrtimer expiry before releasing current_entry_lo=
ck.
   taprio_change() and taprio_start_sched() use the same lock. Releasing it
   before hrtimer_set_expires() allows a concurrent hrtimer_start() to queue
   the running timer, after which the callback can overwrite the queued
   expiry without removing and reinserting the timer. The entry publication
   and next-expiry assignment must therefore remain serialized with schedule
   replacement.

Do not replace catch-up with HRTIMER_MODE_ABS_SOFT or another execution-con=
text
change. That can move the backlog but does not bound it.

Compare the result with the existing bounded catch-up series:
https://lists.openwall.net/linux-kernel/2026/09/01/1247

The new patch should explain why it skips complete periods arithmetically a=
nd
leaves residual entry transitions to subsequent callbacks. This avoids an
unbounded replay while also avoiding a multi-entry walk inside one callback
that can circle back to an entry visible to lockless dequeue readers.

Validate the new version with the exact reproducer, a callback delayed by m=
any
periods, cycle_time values below, equal to and above the interval sum, a fi=
rst
entry longer than one period, concurrent admin replacement, and the TXTIME =
and
full-offload modes.

Impact assessment: the demonstrated impact is an availability failure in
which a privileged software TAPRIO configuration can keep a CPU in timer
processing long enough to trigger an RCU stall.

Kind Regards / Mit freundlichen Gr=C3=BC=C3=9Fen
BART CHRONOWSKI

On Fri, Aug 28, 2026 at 11:31:37AM +0000, 'syzbot' via syzkaller-upstream-m=
oderation wrote:
> The taprio qdisc allows configuring excessively small intervals (e.g., 255
> ns) which can completely overwhelm the CPU when using software timers. Wh=
en
> the interval is shorter than the time it takes to process the timer
> interrupt, the timer expiration falls continuously into the past. This
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
> Fix this by rejecting intervals smaller than 100 us (-EINVAL) at admission
> time for software TAPRIO schedules driven by advance_timer. When neither
> txtime-assist nor full-offload mode is enabled, enforce a minimum interval
> duration of 100 us in fill_sched_entry() and parse_taprio_schedule(), whi=
le
> retaining length_to_duration(q, ETH_ZLEN) for hardware-offloaded schedule=
s.
>=20
> Fixes: 5a781ccbd19e ("tc: Add support for configuring the taprio schedule=
r")
> Assisted-by: Gemini:gemini-3.7-flash syzbot
> Reported-by: syzbot+f8850bc3986562f79619@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3Df8850bc3986562f79619
> Link: https://syzkaller.appspot.com/ai_job?id=3D896b8415-1acd-41a7-bb99-3=
1c5f93cb5d3
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
> v3:
> - Reject intervals smaller than 100 us at admission time for software TAP=
RIO schedules instead of modifying advance_sched().
> - Drop catch-up cycle arithmetic, loop iteration limits, and physical exp=
iration fallbacks from advance_sched().
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
> index 299234a5f..e5a560a3e 100644
> --- a/net/sched/sch_taprio.c
> +++ b/net/sched/sch_taprio.c
> @@ -1034,11 +1034,22 @@ static const struct nla_policy taprio_policy[TCA_=
TAPRIO_ATTR_MAX + 1] =3D {
>  	[TCA_TAPRIO_ATTR_TC_ENTRY]		     =3D { .type =3D NLA_NESTED },
>  };
> =20
> +static int taprio_min_interval_duration(struct taprio_sched *q)
> +{
> +	int min_duration =3D length_to_duration(q, ETH_ZLEN);
> +
> +	if (TXTIME_ASSIST_IS_ENABLED(q->flags) ||
> +	    FULL_OFFLOAD_IS_ENABLED(q->flags))
> +		return min_duration;
> +
> +	return max_t(int, min_duration, 100 * NSEC_PER_USEC);
> +}
> +
>  static int fill_sched_entry(struct taprio_sched *q, struct nlattr **tb,
>  			    struct sched_entry *entry,
>  			    struct netlink_ext_ack *extack)
>  {
> -	int min_duration =3D length_to_duration(q, ETH_ZLEN);
> +	int min_duration =3D taprio_min_interval_duration(q);
>  	u32 interval =3D 0;
> =20
>  	if (tb[TCA_TAPRIO_SCHED_ENTRY_CMD])
> @@ -1166,7 +1177,7 @@ static int parse_taprio_schedule(struct taprio_sche=
d *q, struct nlattr **tb,
>  		new->cycle_time =3D cycle;
>  	}
> =20
> -	if (new->cycle_time < new->num_entries * length_to_duration(q, ETH_ZLEN=
)) {
> +	if (new->cycle_time < (s64)new->num_entries * taprio_min_interval_durat=
ion(q)) {
>  		NL_SET_ERR_MSG(extack, "'cycle_time' is too small");
>  		return -EINVAL;
>  	}
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
>=20
> --=20
> You received this message because you are subscribed to the Google Groups=
 "syzkaller-upstream-moderation" group.
> To unsubscribe from this group and stop receiving emails from it, send an=
 email to syzkaller-upstream-moderation+unsubscribe@googlegroups.com.
> To view this discussion visit https://groups.google.com/d/msgid/syzkaller=
-upstream-moderation/ecbfe945-f1ab-45de-aaa0-b9b57ae730c2%40mail.kernel.org.
