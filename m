Received: from mail-wr2-f35.google.com (mail-wr2-f35.google.com [74.125.225.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E243F49F113
	for <syzbot@lists.linux.dev>; Mon, 21 Sep 2026 13:41:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789998064; cv=none; b=bNKR5+N8SM1i+x9HDwHnjZmPMHF+PnqUxEc1XMrSgTjz/dIXJ67RDduooD41kzFf6TXuuc4CB7ZAMct4MPmxICu1ITWooHFmmL3NKmNiYFgl51QUpycjz71J/ty+DqgNB+lskfgOQjog2568RrRDMlDq9I2IfwHCthXDZmsFG8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789998064; c=relaxed/simple;
	bh=n2qK42wJ47oOMqJ10vypSWxEaAHb4zCzuP9MkDReENU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Lt0iIdtpqVsJXmm1N+YP0svCBjTrsEo/KN3Le6y+Cl3O9mkBFDzmNO2s/z8g3QPHT9ebH3CVo+CS3bInONXFrELHj3C60VSZyVYDyW9KUFjCcBS/FnhWW3vmyaUeRifTCRvu/UGO+Cq9SlVWZcHFT6ZIJlvC89evo9awDvZEh68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dTuUXDyy; arc=none smtp.client-ip=74.125.225.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dTuUXDyy"
Received: by mail-wr2-f35.google.com with SMTP id ffacd0b85a97d-482f63546c5so2353136f8f.2
        for <syzbot@lists.linux.dev>; Mon, 21 Sep 2026 06:41:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789998060; x=1790602860; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3bSNzHPbB9PY06JMNzilhka6A5FsAKJmLlyAyVgzgWA=;
        b=dTuUXDyyxk3jz7rs4S4H8iVgPyXJoCbox+ebpVpQ5I87iBxn0KcjfKPtORCfm8xOGh
         MGyxAZ6xUUwSaWGEw6AsXCjSKmUst8if8OUPE3jHxsMRQ6EkoUQLoMqV0amghjcXEeZw
         12f68V4lkmvAW/SgrNu4A1+sdot5X6sNdM74n9GGKOPZkgyIT+QCLUwT7g0EL3o3zBZM
         T/L3uY4dkvowmfMlGg0YCUeJTQT39cUsWyGvEJcpMtPHI910q97mrkdk95BN9B5WJr+6
         w+iz/UdCsSCmDpCj1EeoN3JcbdBLD7bzKw5CACYvGZnONJ3zRVy0Pw5lXTYi+69w7Lgc
         Qn1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789998060; x=1790602860;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3bSNzHPbB9PY06JMNzilhka6A5FsAKJmLlyAyVgzgWA=;
        b=wbGWJzeYatwzW9T8tZe28DbPVl04LZLtxde82PHT27S1h0YAO+fjsjwQESr+3TIYaH
         Njoy9P88Z36tzND9BpaJUYb9Dc44wcpawffBrTXVVcATckOMstJkiyjMqALZyaPTXUuR
         66sQsMyyUonMR95mEhMyHhSFi82HRrak/1D6NgUWw0RYpv6QXdmYfQtcLblj2dc/d0NT
         HVzShtBF/SWue+W1Mr/bHrL8nH9TPYi2W43kAyHZStWndflc58E9T654j6/jr84Xd8R9
         jZWtgoPl91qrtZzcAP6Xd7z8bmBHOllGMBozLAozYOnss/ZDTdmhBkQWQ+kD11boyoCC
         hSPA==
X-Gm-Message-State: AFuF++kwY+rPuSKdUJM1v7P8DrblU+Lxmme72YvFGoEQM45SkGmSsygZ
	02qvMxiD1bYzzYc08Om4rnhPtu7x+Dkj7L5Xeaf/PvPd4maZqDSJUBz/VVumNJsJ
X-Gm-Gg: AYBFou17sU83pGXWBZSIggiLx8kqlptPEZoGloNpVHOX861iMo/1I9j3HSPriQzMZ84
	HIyyHTGZuF0JlG6Hn4qg7bDEKeSzLt9jZKUx/m4+m/N5xQCjY0kwfrAsbGWyqQhcxa6bC2LvNd1
	mSoRsuxtAuKP4oQQE+nEfw+WwX35pciXHE2o14oFBWKcqH846om6PxWAXC8VUUQw6XdL/whiiLo
	ZPrwLfuI4Eq8YRuJCwW8O5CH6ox02mIQnwF/dAD2yGBOdK3Ls2Goq8+4dveP4EX1VtCLYVfrtRB
	9ePdc540ZthXe1lo0hgmZlCBa4sdTU2Q6Ao5gWWg4Kf+eSDOxnMynjx6QUZzkw3mE9vqOrlXxGW
	mKKcs419252dpPOW+ijDjunqYQ8vux7F0Kt232IiZdAC69ZdTnHQo2kYyvYHu8ebvKRLRPsv4wB
	HvdH1f2gOSSKxZ2ZfHAEKzZec7jwM1GK0/BtcltNO6IbBbRCX+/lvOHqjkshIvwQ4GZ1KFE0nfH
	pGPfgmwq650YalUTOKfhlk/Vnas5gxoypDlquVNKXGgZiDYKbmvSy9HKsH6S3G2sx5FO5mfWQM5
	3c3T2AE+XVLUw+grVllyRXBMAH3kCX22vzf4xung4cXz5B6vMRUBZ30y+h4KJXmEsorTXRBiv4o
	LVGxwa4zACRDbFb4KSaczpJykq1BQVdnQOr6VP/XnfTNrbg==
X-Received: by 2002:a05:6000:3111:b0:485:8c16:5ef3 with SMTP id ffacd0b85a97d-4871e36e41dmr14722421f8f.45.1789998059692;
        Mon, 21 Sep 2026 06:40:59 -0700 (PDT)
Received: from [192.168.100.51] (87-205-15-91.static.ip.netia.com.pl. [87.205.15.91])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4872456301dsm23216769f8f.18.2026.09.21.06.40.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Sep 2026 06:40:59 -0700 (PDT)
Message-ID: <065f8479-2fcd-4689-8dc6-03d707d2e9ce@gmail.com>
Date: Mon, 21 Sep 2026 15:40:58 +0200
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v3] net/sched: taprio: enforce minimum interval to
 prevent hrtimer storms
To: syzbot <syzbot@kernel.org>, syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
References: <6f795e5c-0c42-4ff3-b8f3-de5cffb73045@mail.kernel.org>
Content-Language: en-US
From: Krystian Kaniewski <krystianmkaniewski@gmail.com>
In-Reply-To: <6f795e5c-0c42-4ff3-b8f3-de5cffb73045@mail.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Preserve manual cycle truncation while enforcing the software timer 
floor. Taprio deliberately permits a cycle time shorter than the sum of 
its schedule entries, so the new sum comparison rejects valid schedules. 
Two 1 ms entries with a 1.5 ms cycle have effective timer intervals of 1 
ms and 0.5 ms, but the patch rejects that input. Check the interval left 
at the cycle boundary instead, and align the first software timer 
deadline with that boundary so a long first entry cannot cause overdue 
catch-up. Preserve the software-only 100 us per-entry floor, the 
consistent soft hrtimer mode, the existing txtime-assist and 
full-offload range, and the cleanup paths. Do not change the supported 
manual cycle-time override merely to reject the reported 127 ns schedule.

On 9/18/2026 8:12 PM, syzbot wrote:
> An issue with the taprio packet scheduler allows a user to configure an
> extremely small schedule interval (e.g., 127 ns). While taprio validates
> that the interval is at least the time required to transmit a minimum-sized
> Ethernet frame (ETH_ZLEN), on high-speed virtual interfaces like 10 Gbps
> veth, this minimum duration evaluates to just 48 ns.
>
> Because the execution time of the hrtimer callback (plus hardware interrupt
> overhead) is significantly larger than 127 ns, the newly calculated
> end_time in advance_sched() is already in the past by the time the
> interrupt handler finishes. The hrtimer subsystem immediately fires the
> timer again, trapping the CPU in a continuous stream of timer interrupts
> (an hrtimer interrupt storm). This starves other threads, including the RCU
> grace-period kthread, leading to an RCU stall:
>
> rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:
> rcu: 	(detected by 0, t=10502 jiffies, g=15113, q=737 ncpus=2)
> rcu: All QSes seen, last rcu_preempt kthread activity 10502
> (4294956675-4294946173), jiffies_till_next_fqs=1, root ->qsmask 0x0
> rcu: rcu_preempt kthread timer wakeup didn't happen for 10501 jiffies!
> g15113 f0x2 RCU_GP_WAIT_FQS(5) ->state=0x200
> rcu: 	Possible timer handling issue on cpu=1 timer-softirq=3485
> rcu: rcu_preempt kthread starved for 10502 jiffies! g15113 f0x2
> RCU_GP_WAIT_FQS(5) ->state=0x200 ->cpu=1
> rcu: 	Unless rcu_preempt kthread gets sufficient CPU time, OOM is now
> expected behavior.
> ...
> Call Trace:
>   <IRQ>
>   lock_acquire+0x106/0x350 kernel/locking/lockdep.c:5868
>   rcu_lock_acquire include/linux/rcupdate.h:300 [inline]
>   rcu_read_lock include/linux/rcupdate.h:840 [inline]
>   advance_sched+0xa04/0xc80 net/sched/sch_taprio.c:992
>   __run_hrtimer kernel/time/hrtimer.c:2032 [inline]
>   __hrtimer_run_queues+0x3bc/0xa10 kernel/time/hrtimer.c:2096
>   hrtimer_interrupt+0x448/0x910 kernel/time/hrtimer.c:2215
>   local_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1051 [inline]
>   __sysvec_apic_timer_interrupt+0x102/0x430 arch/x86/kernel/apic/apic.c:1068
>
> To prevent this, enforce a minimum interval threshold during configuration
> when operating in software timer-driven mode (i.e. neither txtime-assist
> nor full offload is enabled). Introduce TAPRIO_MIN_INTERVAL set to 100
> microseconds (100 * NSEC_PER_USEC). Rather than serving as an absolute
> CPU-safety guarantee across all possible hardware and workloads, this 100
> us floor acts as a nominal callback-rate policy that limits the timer
> interrupt rate to at most 10,000 events per second. Hardware-assisted and
> offloaded modes do not rely on this software timer and remain unaffected.
>
> Apply this clamped minimum duration in fill_sched_entry() and
> parse_taprio_schedule() for timer-driven mode to ensure that both
> individual entry intervals and the overall cycle time respect this floor.
> Also add and use taprio_is_timer_driven() to simplify timer-mode checks
> across taprio.
>
> Fixes: b5b73b26b3ca ("taprio: Fix allowing too small intervals")
> Assisted-by: Gemini:gemini-3.8-flash syzbot
> Reported-by: syzbot+e044a9b6370ed8ca9737@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=e044a9b6370ed8ca9737
> Link: https://syzkaller.appspot.com/ai_job?id=27da4e09-1a14-4b2d-b724-c2398c57d3b3
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
> v3:
> - Switch advance_timer to HRTIMER_MODE_ABS_SOFT in taprio_init(), taprio_change(), and taprio_start_sched()
> - In parse_taprio_schedule(), validate that cycle_time is not less than the sum of entry intervals in timer-driven mode
>
> v2:
> - Increased the minimum interval floor (TAPRIO_MIN_INTERVAL) from 1 us to 100 us.
> - Restricted the minimum interval constraint to software timer-driven mode via a new taprio_is_timer_driven() helper.
> - Used taprio_is_timer_driven() helper in taprio_start_sched() and taprio_change().
> - Clarified in the commit message that the threshold represents a nominal callback-rate policy rather than an absolute safety guarantee.
> https://lore.kernel.org/all/4de7b2e3-3f72-41a4-8735-67d91fc74009@mail.kernel.org/T/
>
> v1:
> https://lore.kernel.org/all/7d5b3fcb-ab75-4a18-909f-5ff072e562e1@mail.kernel.org/T/
> ---
> diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
> index 299234a5f..47110f506 100644
> --- a/net/sched/sch_taprio.c
> +++ b/net/sched/sch_taprio.c
> @@ -43,12 +43,26 @@ static struct static_key_false taprio_have_working_mqprio;
>   #define TAPRIO_SUPPORTED_FLAGS \
>   	(TCA_TAPRIO_ATTR_FLAG_TXTIME_ASSIST | TCA_TAPRIO_ATTR_FLAG_FULL_OFFLOAD)
>   #define TAPRIO_FLAGS_INVALID U32_MAX
> +
> +static inline bool taprio_is_timer_driven(u32 flags)
> +{
> +	return !TXTIME_ASSIST_IS_ENABLED(flags) &&
> +	       !FULL_OFFLOAD_IS_ENABLED(flags);
> +}
> +
>   /* Minimum value for picos_per_byte to ensure non-zero duration
>    * for minimum-sized Ethernet frames (ETH_ZLEN = 60).
>    * 60 * 17 > PSEC_PER_NSEC (1000)
>    */
>   #define TAPRIO_PICOS_PER_BYTE_MIN 17
>   
> +/* Nominal callback-rate policy for timer-driven mode to prevent
> + * hrtimer interrupt storms (100 us floor corresponds to at most
> + * 10,000 timer interrupts per second). This is a nominal callback-rate
> + * policy rather than an absolute CPU-safety guarantee.
> + */
> +#define TAPRIO_MIN_INTERVAL (100 * NSEC_PER_USEC)
> +
>   struct sched_entry {
>   	/* Durations between this GCL entry and the GCL entry where the
>   	 * respective traffic class gate closes
> @@ -1041,6 +1055,9 @@ static int fill_sched_entry(struct taprio_sched *q, struct nlattr **tb,
>   	int min_duration = length_to_duration(q, ETH_ZLEN);
>   	u32 interval = 0;
>   
> +	if (taprio_is_timer_driven(q->flags))
> +		min_duration = max_t(int, min_duration, TAPRIO_MIN_INTERVAL);
> +
>   	if (tb[TCA_TAPRIO_SCHED_ENTRY_CMD])
>   		entry->command = nla_get_u8(
>   			tb[TCA_TAPRIO_SCHED_ENTRY_CMD]);
> @@ -1129,6 +1146,8 @@ static int parse_taprio_schedule(struct taprio_sched *q, struct nlattr **tb,
>   				 struct sched_gate_list *new,
>   				 struct netlink_ext_ack *extack)
>   {
> +	struct sched_entry *entry;
> +	ktime_t cycle = 0;
>   	int err = 0;
>   
>   	if (tb[TCA_TAPRIO_ATTR_SCHED_SINGLE_ENTRY]) {
> @@ -1151,13 +1170,10 @@ static int parse_taprio_schedule(struct taprio_sched *q, struct nlattr **tb,
>   	if (err < 0)
>   		return err;
>   
> -	if (!new->cycle_time) {
> -		struct sched_entry *entry;
> -		ktime_t cycle = 0;
> -
> -		list_for_each_entry(entry, &new->entries, list)
> -			cycle = ktime_add_ns(cycle, entry->interval);
> +	list_for_each_entry(entry, &new->entries, list)
> +		cycle = ktime_add_ns(cycle, entry->interval);
>   
> +	if (!new->cycle_time) {
>   		if (cycle < 0 || cycle > INT_MAX) {
>   			NL_SET_ERR_MSG(extack, "'cycle_time' is too big");
>   			return -EINVAL;
> @@ -1166,9 +1182,16 @@ static int parse_taprio_schedule(struct taprio_sched *q, struct nlattr **tb,
>   		new->cycle_time = cycle;
>   	}
>   
> -	if (new->cycle_time < new->num_entries * length_to_duration(q, ETH_ZLEN)) {
> -		NL_SET_ERR_MSG(extack, "'cycle_time' is too small");
> -		return -EINVAL;
> +	if (taprio_is_timer_driven(q->flags)) {
> +		if (new->cycle_time < cycle) {
> +			NL_SET_ERR_MSG(extack, "'cycle_time' is too small");
> +			return -EINVAL;
> +		}
> +	} else {
> +		if (new->cycle_time < new->num_entries * length_to_duration(q, ETH_ZLEN)) {
> +			NL_SET_ERR_MSG(extack, "'cycle_time' is too small");
> +			return -EINVAL;
> +		}
>   	}
>   
>   	taprio_calculate_gate_durations(q, new);
> @@ -1274,7 +1297,7 @@ static void taprio_start_sched(struct Qdisc *sch,
>   	struct taprio_sched *q = qdisc_priv(sch);
>   	ktime_t expires;
>   
> -	if (FULL_OFFLOAD_IS_ENABLED(q->flags))
> +	if (!taprio_is_timer_driven(q->flags))
>   		return;
>   
>   	expires = hrtimer_get_expires(&q->advance_timer);
> @@ -1287,7 +1310,7 @@ static void taprio_start_sched(struct Qdisc *sch,
>   	 */
>   	start = min_t(ktime_t, start, expires);
>   
> -	hrtimer_start(&q->advance_timer, start, HRTIMER_MODE_ABS);
> +	hrtimer_start(&q->advance_timer, start, HRTIMER_MODE_ABS_SOFT);
>   }
>   
>   static void taprio_set_picos_per_byte(struct net_device *dev,
> @@ -1946,10 +1969,9 @@ static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
>   			   nla_get_u32(tb[TCA_TAPRIO_ATTR_TXTIME_DELAY]));
>   	}
>   
> -	if (!TXTIME_ASSIST_IS_ENABLED(q->flags) &&
> -	    !FULL_OFFLOAD_IS_ENABLED(q->flags) &&
> +	if (taprio_is_timer_driven(q->flags) &&
>   	    !hrtimer_active(&q->advance_timer)) {
> -		hrtimer_setup(&q->advance_timer, advance_sched, q->clockid, HRTIMER_MODE_ABS);
> +		hrtimer_setup(&q->advance_timer, advance_sched, q->clockid, HRTIMER_MODE_ABS_SOFT);
>   	}
>   
>   	err = taprio_get_start_time(sch, new_admin, &start);
> @@ -2072,7 +2094,7 @@ static int taprio_init(struct Qdisc *sch, struct nlattr *opt,
>   
>   	spin_lock_init(&q->current_entry_lock);
>   
> -	hrtimer_setup(&q->advance_timer, advance_sched, CLOCK_TAI, HRTIMER_MODE_ABS);
> +	hrtimer_setup(&q->advance_timer, advance_sched, CLOCK_TAI, HRTIMER_MODE_ABS_SOFT);
>   
>   	q->root = sch;
>   
>
>
> base-commit: a13c140cc289c0b7b3770bce5b3ad42ab35074aa
