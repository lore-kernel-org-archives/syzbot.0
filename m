Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFCB153D0C2
	for <syzbot@lists.linux.dev>; Wed,  9 Sep 2026 11:29:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=100.103.45.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788953391; cv=pass; b=W/DBe6Go8BXNQF8/i1XlYve/WysNrXfcl/q0i1aOlAd+8JKTgXJ7/cjNLuSXVvUUZYvUEJ1NFShImSXSWJ2TvXaEtRyiC1PL25lWia2DUeu3u/50WXfzQXw0BISTgrytK6t9Rm8ZNfCh0QjBZ5BrFktaQazaSQk2QTWo3apCEts=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788953391; c=relaxed/simple;
	bh=B1hE7enSCW77TAE1TOuwg31qv1on6AbSG6J6VnmEcY8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pwqfOJyVRoODvjAW4JqmQ4cDCrCDh/Ulr1nmyF8gXikn8iD/c1uDiCMz0QqXWACK9B3yPDVGkPYeEpVYcV5bBNBqfzfNHvJ1eyP1xGTc0nXbJ8IJY+T9Nk2u9qbxSlHOkgFZOhkiDz+LLb4iJHRUN4A4Tcsk5KR9io9uV35erEg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JyugsNHJ; arc=pass smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JyugsNHJ"
Received: by smtp.kernel.org (Postfix)
	id A11D41F00A3E; Wed,  9 Sep 2026 11:29:49 +0000 (UTC)
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=74.125.228.140
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1788953389;
	b=pJb9g2enYwe7hJ7o2/dBvlfviPNrS2NMr7eNfU/l90SFEP8ELLMs122+7pTSZbc9SJKe
	 x+bIFMiVsa/psE212SxhXs+XZ/WT4hl9E3sNDf23honsKS0PGxTn+08ltyY6VWgj9MYw2
	 t7B/yiB62YtHaBQQ3gC3v9Atca/vVoDreKrSSZAY01lMx7aS0Q90/suWhcfKbZmz0L5c5
	 6vuufXpuhGdZYxLAghoE9ZhB/1RFMTtcJoe0o2oLobGLCrYS9Wz9jy+xbW8vk6vvWu5Ms
	 LpdHXmI9dSH7XRAfXVT4kmhOPR8C4yGeqDRIs8arD62b8LhIUoGU10gqWYBnrAiICJQ==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1788953389;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=/8p0etPt3lBBCxoaHa3ZUI2g+ZSv7/moetzIFIabMAo=;
	b=vjbIPsjL671CMulT0N7tbaNkglqp8s2tlJ9jbz3xVJlioMHSlJ5p5okaRCILwLVChFom
	 nTDx4BpHs15BYRvWtKT0UkaLy4aR3kf62zW0Ql7lOs869nWvreytGIbvqIniX11fYYM2E
	 q27VILymo3Kq9ZLlHNVErdPfwsAryAXJKhvy1sHOEdQK2NUeySYfbSSOxspsS7RRl0p6c
	 8YwLfUssTV9fiZ544zRarQzjJJzBFHwWzsBtmRchJbvh1+vsA4aYWQCh9LYXmF20SULlB
	 G69+fou49sFf22yBbjRGs2T1v0FHsLR72MbySbUMsPuB/O8P8bi3sNgtkmPtUttW70g==
ARC-Authentication-Results: i=1; smtp.kernel.org; dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=JyugsNHJ;
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	arc=none smtp.remote-ip=74.125.228.140
Received: from mail-ej2-f12.google.com (mail-ej2-f12.google.com [74.125.228.140])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id E25141F00A3A
	for <syzbot@kernel.org>; Wed,  9 Sep 2026 11:29:48 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=JyugsNHJ
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.kernel.org E25141F00A3A
Authentication-Results: smtp.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej2-f12.google.com with SMTP id a640c23a62f3a-c254f9f0b23so168886166b.0
        for <syzbot@kernel.org>; Wed, 09 Sep 2026 04:29:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788953387; x=1789558187; darn=kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=/8p0etPt3lBBCxoaHa3ZUI2g+ZSv7/moetzIFIabMAo=;
        b=JyugsNHJvVo3HUWbIE/JmJiJh/9arXhGzKUm7BfWlXei9P02wSBScGStRaitsuWNCb
         nnUyCpM3B/y3PuczF7jyyx/MhVvM9jNhAqg3WI0l+jo4xj4wub9V5ymvlV7ZesMEXTfn
         RskqryilrvcjhpUFurgTMCMY8v7qyT8lKj7chcGHSRlEVhHLO0lIn66czA4xwbz2sMZb
         hLiicutrBAmM07kqAWwjn2UtNLD9rrvbNQ6pbpAPIWi+bDMaCMVvi7Gh9Ldig+s85unA
         rjiwevwjcbWrDN1uL7ldT4/IjJbduQCAQLYFWlNXfNe9Yx/tRbguCm4SYG/8z5wi+9Sy
         2+DA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788953387; x=1789558187;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/8p0etPt3lBBCxoaHa3ZUI2g+ZSv7/moetzIFIabMAo=;
        b=Jk7qooekbhiJfeQ4ZaOWZIzeH/zzCxPtgm3HLdUP4q09QmCN7dhJyUNwsjn40gGT4S
         E8wOq0qdL5NqCSL24R3di2GOU/87Fq2Kme40jeTgYs93XTzlwO6gdMMuDH79yX9KuY4E
         GDUqswmAQgUFpFGPN0LnSEbQvD+yze8TWVDzr9LAeGnWkPfcNtyTpGRJa8h4KqEmUrB3
         sB90R6vRTTGjAkIsfhJSLTlbmSrvPhdVRmabreWOElS91kzZR2Ai3Ux+3YiQXnZrEBBu
         jlDDSf8DDxGsTo1O+831bKwT0iJYThTu41H01Kt5JeGEoV9AxKU6/PfNDe7rIVoQ876W
         u1tQ==
X-Gm-Message-State: AFuF++kdFg+s+SUJryDwe6ojL8BiHzGJLO4o6Yeu6boA1c1A1LN1yrpD
	Q2WhwwbqdfOo0bTuf9nZrk8hRYV6rlptM3tGvuJK89CgAMkVCwNAS3JlDheGHg==
X-Gm-Gg: AYBFou12Uf+psics4DAamtvvcZ2XcujyXoFv3iWaIwPckfiiCMuOoDBillT1nj8kgas
	7CbELcz2Coq0dJeeU/Dy4NGMzG8u523xB4i1khnp2lfz8H6T73GuqOgkyDncuTAxYhvIbK+EOhy
	ZPVbwdlli3fXbJCT2PLtMGcqwdX8fsRtRMCZKfodEsHufb7YoH7H4Fv/uyqrSWcWNccYH3x7GMb
	uYplYWZWcjjJ2BFwflJqudhrP5NfRme7zjI0TUFP/qIrS48hqQysgk6WecMZvmzOooxJyyjR3rA
	6V772lFs5udsHOXGaqGFaiuH7m4mQ74xp4zKBOFXsMDkyYbomPP8/8/ek4Y0nf1N2IuwJC3135B
	epMZDct7azQB2myMJo43zlybazau6i57xBkPO8wZzcKMXVQUD/MHYgBkV2uZgeVazj+QZUTTVh/
	Wobk9/hVeLsglpDwAr4gfiWeXMmVvPiiIas0HvacFeT4Jh/WMvVxKYZF2SPZSq2yx/x1uUCLpNz
	0k+IU/6TRZeC64=
X-Received: by 2002:a17:907:9623:b0:c12:b2db:873d with SMTP id a640c23a62f3a-c292adecac8mr424156166b.5.1788953386950;
        Wed, 09 Sep 2026 04:29:46 -0700 (PDT)
Received: from localhost ([37.31.154.38])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c260d4a98efsm765934166b.14.2026.09.09.04.29.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2026 04:29:46 -0700 (PDT)
Date: Wed, 9 Sep 2026 13:29:45 +0200
From: Bartosz Chronowski <immersa.bartosz.chronowski@gmail.com>
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Subject: Re: [PATCH RFC v2] net/sched: taprio: enforce minimum interval in
 software mode
Message-ID: <4cxcc2k5elnupfinr3s34h5itggygrflbzdfmsseomnyemsqnm@klxk77vjmljt>
References: <edd30c9e-6673-42a0-ab07-b7fb2bb67795@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <edd30c9e-6673-42a0-ab07-b7fb2bb67795@mail.kernel.org>

The software-only minimum addresses the direction requested for v1, and
removing the entry-sum comparison is progress. The selected implicit-cycle
case is now rejected by the new guard. The new admission policy still
needs justification for the effective schedule, and its rejection path
runs after configuration changes. The patch needs another revision.
This review has no comparable runtime result establishing the v2 fix.

The remaining requests concern the current code:

1. Define and justify the serviceability guarantee for the effective
   schedule in parse_taprio_schedule() and advance_sched(). The cycle-time
   check counts every configured entry, including unused tails, while an
   entry clipped at the cycle boundary can be shorter than its declared
   interval. An average bound is not a per-transition bound; demonstrate
   that the chosen policy provides the required CPU progress. Preserve
   supported explicit-cycle truncation and v2's software-only admission
   scope. Verify the changed arithmetic in TXTIME-assist and full-offload
   mode as well.
   
On Fri, Sep 04, 2026 at 12:20:22PM +0000, syzbot wrote:
> In taprio software mode (when full offload and txtime-assist are not
> enabled), schedule advancement is driven in software by an hrtimer running
> advance_sched(). The minimum allowed duration for schedule entries was
> previously bounded only by length_to_duration(q, ETH_ZLEN). For high link
> speeds or small picos_per_byte, this allows entry intervals to be
> configured to extremely small values (e.g., tens of nanoseconds).
> 
> When entry intervals or cycle_time are configured to values shorter than
> the time required to execute the timer callback, the newly calculated
> expiration time is in the past. Consequently, the hrtimer subsystem
> repeatedly and immediately re-invokes advance_sched() in hardirq context,
> resulting in an interrupt storm that starves the CPU and triggers RCU
> stalls:
> 
> rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:
> rcu: 	0-...!: (1 GPs behind) idle=fc14/1/0x4000000000000000
> softirq=20212/20212 fqs=5
> rcu: 	(detected by 1, t=10502 jiffies, g=16909, q=1720 ncpus=2)
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
>  __sysvec_apic_timer_interrupt+0x102/0x430 arch/x86/kernel/apic/apic.c:1068
>  sysvec_apic_timer_interrupt+0xa1/0xc0 arch/x86/kernel/apic/apic.c:1062
>  </IRQ>
> 
> Fix this by defining TAPRIO_MIN_SW_INTERVAL_NS (10 us) and introducing
> taprio_min_interval() to enforce a minimum interval in software mode for
> both individual schedule entries in fill_sched_entry() and the overall
> cycle_time in parse_taprio_schedule().
> 
> Fixes: 6ca6a6654225 ("taprio: Add support for setting the cycle-time manually")
> Assisted-by: Gemini:gemini-3.7-flash syzbot
> Reported-by: syzbot+14c6ac6811273526cfa5@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=14c6ac6811273526cfa5
> Link: https://syzkaller.appspot.com/ai_job?id=2540dd3a-bcf0-4dd0-be22-164f6203df0b
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
> 
> ---
> v2:
> - Enforce a minimum interval of 10 us (TAPRIO_MIN_SW_INTERVAL_NS) in software mode instead of comparing cycle_time against the sum of intervals.
> - Add taprio_min_interval() helper to determine the minimum interval based on offload and txtime-assist flags.
> - Use taprio_min_interval() in fill_sched_entry() and parse_taprio_schedule().
> 
> v1:
> https://lore.kernel.org/all/3527dbf1-ab94-4184-8405-8552799efb71@mail.kernel.org/T/
> ---
> diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
> index 39ac5b97a..3890cdbfc 100644
> --- a/net/sched/sch_taprio.c
> +++ b/net/sched/sch_taprio.c
> @@ -48,6 +48,10 @@ static struct static_key_false taprio_have_working_mqprio;
>   * 60 * 17 > PSEC_PER_NSEC (1000)
>   */
>  #define TAPRIO_PICOS_PER_BYTE_MIN 17
> +/* Minimum interval for software mode (hrtimer-driven advance_sched) to
> + * avoid hrtimer interrupt storms and CPU starvation.
> + */
> +#define TAPRIO_MIN_SW_INTERVAL_NS (10 * NSEC_PER_USEC)
>  
>  struct sched_entry {
>  	/* Durations between this GCL entry and the GCL entry where the
> @@ -259,6 +263,17 @@ static int length_to_duration(struct taprio_sched *q, int len)
>  	return div_u64(len * atomic64_read(&q->picos_per_byte), PSEC_PER_NSEC);
>  }
>  
> +static int taprio_min_interval(struct taprio_sched *q)
> +{
> +	int min_duration = length_to_duration(q, ETH_ZLEN);
> +
> +	if (!FULL_OFFLOAD_IS_ENABLED(q->flags) &&
> +	    !TXTIME_ASSIST_IS_ENABLED(q->flags))
> +		min_duration = max_t(int, min_duration, TAPRIO_MIN_SW_INTERVAL_NS);
> +
> +	return min_duration;
> +}
> +
>  static int duration_to_length(struct taprio_sched *q, u64 duration)
>  {
>  	return div_u64(duration * PSEC_PER_NSEC, atomic64_read(&q->picos_per_byte));
> @@ -1039,7 +1054,7 @@ static int fill_sched_entry(struct taprio_sched *q, struct nlattr **tb,
>  			    struct sched_entry *entry,
>  			    struct netlink_ext_ack *extack)
>  {
> -	int min_duration = length_to_duration(q, ETH_ZLEN);
> +	int min_duration = taprio_min_interval(q);
>  	u32 interval = 0;
>  
>  	if (tb[TCA_TAPRIO_SCHED_ENTRY_CMD])
> @@ -1130,6 +1145,7 @@ static int parse_taprio_schedule(struct taprio_sched *q, struct nlattr **tb,
>  				 struct sched_gate_list *new,
>  				 struct netlink_ext_ack *extack)
>  {
> +	int min_duration = taprio_min_interval(q);
>  	int err = 0;
>  
>  	if (tb[TCA_TAPRIO_ATTR_SCHED_SINGLE_ENTRY]) {
> @@ -1167,7 +1183,7 @@ static int parse_taprio_schedule(struct taprio_sched *q, struct nlattr **tb,
>  		new->cycle_time = cycle;
>  	}
>  
> -	if (new->cycle_time < new->num_entries * length_to_duration(q, ETH_ZLEN)) {
> +	if (new->cycle_time < (s64)new->num_entries * min_duration) {
>  		NL_SET_ERR_MSG(extack, "'cycle_time' is too small");
>  		return -EINVAL;
>  	}
> 
> 
> base-commit: cee9395acd8043be0644b25c34bfa86623f2b935
> -- 
> This is an AI-generated patch subject to moderation.
> Reply with '#syz upstream' to Sign-off the patch as a human author
> and send it to the upstream kernel mailing lists.
> Reply with '#syz reject' to reject it ('#syz unreject' to undo).
> 
> See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
> You can comment on the patch as usual, syzbot will try to address
> the comments and send a new version of the patch if necessary.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
