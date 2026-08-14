Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1465247253A;
	Fri, 14 Aug 2026 16:13:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786724029; cv=none; b=K8fzQDRpmlZWzopnNA1vYE3e49dufkKfsSlg2bm//9ep6wff9aD/TCIyWdn6Xxg9JYcB33uQqPG1NSJYcQ5O8HJOn/wKndbgTWRfMwJqoTvvtDSC2AuW/SskgcGz5iudSfjYXtV6sLK+L8PioWAq7FqlZ69gIQjw3muEMDvN5qw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786724029; c=relaxed/simple;
	bh=d2ZPHDF4CCdlLavqUC4topkd7UbczcJgZ+Epbzwsd8Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JnjaAq5Qz8kALOwQ1BZTCQkoZSn6+9PplykUuIN87w0EecgW/r82oYEhJaF8xWiRuYiC/hg4e8ofx0kv0Wxjbf1GYhwaEk1PIlx2kYsqLDIRzk0fhVdPsy4+xvinh+yVH2+qsklXfGVB2SH+8Jzj4hTLNlMWeEnQmfQIhoS38t4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MFRkW9lr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MFRkW9lr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 892AC1F000E9;
	Fri, 14 Aug 2026 16:13:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786724024;
	bh=BRqukDhn6eBkNjfhUGraJ7Ie6vboLLwk71IvURgPqZs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MFRkW9lrWZ3yE+gp2EvqFsjGzixLlPcAeb9eMYEXR5CBhX8qkawTMMMHmNebgEwUe
	 qQuE6FEPK9CMPzet7SyT6njveVp6JagagEFbf/tpJ6b/oF18jZk7jujvREPv6qfgN+
	 335vArRsG/3rMNfG6qxDb8DbOzn11LBzLIFucZs4eMX4KZ7lY5IPrLENSXXrwUgHzy
	 U/6Hsq29zgBjw06g/4RDay0jyFCB8/OZARCzIA6XOOAmmjvn9mj/mAvhLzNieAqUHE
	 CmeqKtUU2ujxCzYXVfmuxrR217cYk2vnvNSD6MskI7ctXn/ugaI2xsAsntIX5Fv+H3
	 nQkcNUMmRewJg==
From: Simon Horman <horms@kernel.org>
To: syzbot@kernel.org
Cc: Simon Horman <horms@kernel.org>,
	syzkaller-bugs@googlegroups.com,
	uladzislau.zhauniarovich@gmail.com,
	davem@davemloft.net,
	edumazet@google.com,
	jhs@mojatatu.com,
	jiri@resnulli.us,
	kuba@kernel.org,
	netdev@vger.kernel.org,
	pabeni@redhat.com,
	vinicius.gomes@intel.com,
	linux-kernel@vger.kernel.org,
	syzbot@lists.linux.dev
Subject: Re: [PATCH] net/sched: taprio: enforce minimum software scheduling interval
Date: Fri, 14 Aug 2026 17:13:27 +0100
Message-ID: <20260814161327.382965-1-horms@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <afe041f6-ef7d-4434-b2d0-096be49b5bcb@mail.kernel.org>
References: <afe041f6-ef7d-4434-b2d0-096be49b5bcb@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is an AI-generated review of your patch. The human sending this
email has considered the AI review valid, or at least plausible.
Full review at: https://sashiko.dev/#/patchset/afe041f6-ef7d-4434-b2d0-096be49b5bcb@mail.kernel.org?part=1
---
--- Patch [1]: [PATCH] net/sched: taprio: enforce minimum software scheduling interval ---
commit 984087f4873d7bad874b78ae4728e68b305dd5dc
Author: Uladzislau Zhauniarovich <uladzislau.zhauniarovich@gmail.com>
net/sched: taprio: enforce minimum software scheduling interval

This commit introduces a minimum interval of 100 microseconds for the
software scheduler in taprio to prevent CPU livelocking from excessive
hrtimer interrupts. It skips this check for fully offloaded schedules.

Link: https://syzkaller.appspot.com/bug?extid=19d01f6082ec61dd45b2
Link: https://syzkaller.appspot.com/ai_job?id=37f064ee-e021-43aa-8cfc-9f2a5a7c35d7

> diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
> index 45245157e00a6..2bf4cae164bc2 100644
> --- a/net/sched/sch_taprio.c
> +++ b/net/sched/sch_taprio.c

[ ... ]

> @@ -259,6 +266,16 @@ static int length_to_duration(struct taprio_sched *q, int len)
>  	return div_u64(len * atomic64_read(&q->picos_per_byte), PSEC_PER_NSEC);
>  }
>  
> +static int taprio_min_interval(struct taprio_sched *q)
> +{
> +	int min_duration = length_to_duration(q, ETH_ZLEN);
> +
> +	if (!FULL_OFFLOAD_IS_ENABLED(q->flags))
> +		min_duration = max_t(int, min_duration, TAPRIO_MIN_SW_INTERVAL_NS);

[Severity: High]
Does this limit erroneously catch TXTIME_ASSIST offload configurations?

The code applies the software interval limit when FULL_OFFLOAD_IS_ENABLED
is false, which subjects TXTIME_ASSIST setups to the 100 microseconds limit.
However, TXTIME_ASSIST mode does not use the software advance_sched
hrtimer; it relies on Earliest Departure Time and NIC pacing instead.

Could this break valid hardware-assisted TSN schedules that require smaller
intervals by rejecting them during netlink configuration?

> +
> +	return min_duration;
> +}

[ ... ]


[Severity: High]
This isn't a bug introduced by this patch, but does the budget calculation
suffer from truncation on high-speed links?

When converting long gate durations to byte lengths, truncation from a 64-bit
unsigned integer to a 32-bit signed integer can occur:

net/sched/sch_taprio.c:taprio_set_budgets() {
    ...
    budget = div64_u64((u64)entry->gate_duration[tc] * PSEC_PER_NSEC,
                       atomic64_read(&q->picos_per_byte));
    atomic_set(&entry->budget[tc], budget);
    ...
}

A valid schedule with a gate duration long enough to exceed INT_MAX bytes at
high link speeds (e.g., 400 Gbps where picos_per_byte = 20) yields a budget
exceeding 2,147,483,647 bytes.

Because the budget is a signed 32-bit int, it overflows to a negative value.
Can this cause taprio_update_budgets() to return a negative value and
taprio_dequeue_from_txq() to perpetually stall and drop packets?


[Severity: High]
This is a pre-existing issue, but do failed configuration changes leave the
taprio qdisc in a partially modified state?

If a taprio_change() request passes early validation but fails later, it
appears to leave hardware and software out of sync:

net/sched/sch_taprio.c:taprio_change() {
    ...
    if (FULL_OFFLOAD_IS_ENABLED(q->flags))
        err = taprio_enable_offload(dev, q, new_admin, extack);
    ...
    if (tb[TCA_TAPRIO_ATTR_TXTIME_DELAY]) {
        if (!TXTIME_ASSIST_IS_ENABLED(q->flags)) {
            NL_SET_ERR_MSG_MOD(extack, "txtime-delay can only be set when txtime-assist mode is enabled");
            err = -EINVAL;
            goto unlock;
        }
    ...
}

Hardware offload is enabled with the new schedule, but a subsequent failure
(like the TXTIME_DELAY check) jumps to the unlock and free_sched labels.
Does this discard the software schedule without reverting the hardware
offload, causing the two to become permanently desynchronized?

Additionally, in taprio_parse_tc_entries():

net/sched/sch_taprio.c:taprio_parse_tc_entries() {
    for (tc = 0; tc < TC_QOPT_MAX_QUEUE; tc++) {
        q->max_sdu[tc] = max_sdu[tc];
        q->fp[tc] = fp[tc];
    ...
    if (have_preemption) {
        if (!FULL_OFFLOAD_IS_ENABLED(q->flags)) {
            ...
            return -EOPNOTSUPP;
        }
    ...
}

Internal state like q->max_sdu and q->fp are updated directly in the
software state before checking if preemption is actually supported. Does this
return an error without reverting them on failure?
