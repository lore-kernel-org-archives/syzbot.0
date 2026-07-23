Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08173470E8F
	for <syzbot@lists.linux.dev>; Thu, 23 Jul 2026 10:11:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784801501; cv=none; b=t1qETmiyEZhJltCz8F3Peo1SEw3o9DD4wDntPS5sgeVKZY/E+7oa8RlkaVqgN0zOQ/Wqc3pzITTFVtuXKkLxlFWH/v0lZm8JyywimtEM7kDlstK0tya4awDCi16m3zQDUO6syXGW2hEtd56Ebqcs7x6wmIZrF5k+3KRJeh5Igrs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784801501; c=relaxed/simple;
	bh=1AJYv00b0FHjJE5GdJC8LhuaLt3gd+G5F5R55USAcXg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=J3EfUo0o4wYZZFU38OCIK3zriPHJn53st8NJebneDwDsLaVeFcIvIZ9NQlQtSqg91vccxLVQxd1OExfQ++ADnc9kxqNzi7YMTDLtbo2iFrtlcVL1zxtKl691ig4gcaq+pHgKyyXHpgGNlFd65URsIb3ONBMP07VSrem0DKmq+L0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iGZ/5rtV; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iGZ/5rtV"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4954dff6536so3829785e9.0
        for <syzbot@lists.linux.dev>; Thu, 23 Jul 2026 03:11:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784801497; x=1785406297; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=zEK8CeXuLvVb03FYsfxb6wttTn0ZY24AnJzimxO1TgM=;
        b=iGZ/5rtVXSeNFZAsmKvZFKWkLM2oWUTb/vJoZYsZu9YInipPIzhB6GL/Ky0y5u7Cl3
         7CJAy8lbNRXHdOkRw9B15BGdNdP8Z+8ve6pYTlMAImM0M6eHbwoiWPWFvvtKE+GOtsXn
         gz2dFI4PNvYbBPFWLxtQFcQ8WlzG9MjGEUrIhALhjwVRET15r9EZVyUt0y5FYTG04euB
         SpFJxtoKoez016rv9yHzwtTPoFulJ8Tr/lU60SVIZmXh7Zy/RnnH4soKAfIKksmpuuSZ
         PhPxeBkM9gdwxkeoLXDuedPozeykVmzT9P/59H00QS38pudiImQgS2QUNxrpu3x6ZprR
         VP5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784801497; x=1785406297;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=zEK8CeXuLvVb03FYsfxb6wttTn0ZY24AnJzimxO1TgM=;
        b=gpfCTVHL5iBsg8haO0KYu/DQXLPY50Pb/hqjQ10bqLhTsTFsObb7HXARamu3zSjXjW
         rmOKIdBBzPw22KxqCzh2xuKkisA1UJ68TCJBgdK0QAYYBe0vCltgDLOqdu8izjRr0HJK
         KR6HAAug1tbXQH3SStMkDVw3drHyxRRU7TTnEwMS+aBltZ1GjPHQT6bqUJQfUfB2gotB
         YMYY9s9RSMnxJ02/VvPFskmrVbGN7xFoA+44ZKqjlyVPnllXKbNSl8cyQQ7GZvPh8WPP
         ld98Gyrgh2wMHVnyfVH43reDiQU+PCHKWPh/VTS3bZSu33tZsu3xx9Z6RMvbPfvVH4A5
         pljg==
X-Gm-Message-State: AOJu0YzFXu2XjrmE37m047Ot7kPyX8/EPjkil0YEcVAf7LewrRfw31TH
	c8AXwiwIoXmoLXiltHezDbdj3yDXac8865iyyVd4qSfxLNK4UoFjGtEafU0C1yH9g2E=
X-Gm-Gg: AR+sD11w92SghGRvPMlo+ijxjb1FDJARC7kQmDXeSmAHhOnrlHdTpdqFY7R4KRhmU2N
	EYIYJyhG4i3YyPAvt/Rc96IyXV9Nyrf5i0kLlVpJgt847AXvbRO/QwIBxRJ8reqOeCne1WuCPBW
	pZEeNMfLPZmqlDIyTUlgB62zXqavZN3/StGoU0vEt7aKqtk7532lByT7w+RaZqBqAsCYC5Du4AD
	JOZ2JVuaTT91E0M9+b7sUVcNb9EiM0RXPlEnrApkyydQDYlHM54Djc/cjQSf3KXNsgyDeolFlFQ
	iJ5+Binrw0ReCLJe5p+IN6hkiRtzL8OLp1lIIJdnkRkCpkI1ds7ZORHpnF62WPyJirUkknkLMDw
	pOsuND7MwgDAkDnKSGewP/nMnyamt3BzuM7FMX5HCYtzI4l4bekTPUbUpUio5b0XVbZlQUeMlR6
	oVh8ZDCjAARJ0tcavpewUJbIte++zUNYQFQUHtZiW9dv3pKf8y4Z9I
X-Received: by 2002:a05:600c:154a:b0:493:b877:fbc with SMTP id 5b1f17b1804b1-49573d02244mr24177745e9.21.1784801496667;
        Thu, 23 Jul 2026 03:11:36 -0700 (PDT)
Received: from [192.168.0.50] (93-159-28-46.cgnat.inetia.pl. [93.159.28.46])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4956b0266ccsm89793665e9.3.2026.07.23.03.11.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Jul 2026 03:11:35 -0700 (PDT)
Message-ID: <f935cb2f-ce43-439b-823d-2a5b1aac75d5@gmail.com>
Date: Thu, 23 Jul 2026 12:11:34 +0200
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC] nbd: fix hung task and integer overflow in timeout
 configuration
To: syzbot <syzbot@kernel.org>, syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
References: <b6347da3-3c11-46cb-b467-3416e4104deb@mail.kernel.org>
Content-Language: en-US
From: Uladzislau Zhauniarovich <uladzislau.zhauniarovich@gmail.com>
In-Reply-To: <b6347da3-3c11-46cb-b467-3416e4104deb@mail.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

The v1 patch correctly identifies that wait_for_reconnect() blocks in 
TASK_UNINTERRUPTIBLE for a user-controlled NBD_ATTR_DEAD_CONN_TIMEOUT, 
and it is right to split the netlink parsing into a local u64 timeout 
and to guard the jiffies conversion against overflow. Keep the local 
variable, the overflow-safe conversion at both nbd_genl_connect() and 
nbd_genl_reconfigure(), and the Reported-by/Closes tags.

However, the fix is incomplete: changing the sleep state of 
wait_for_reconnect() (to TASK_IDLE via wait_event_idle_timeout()) does 
not stop the hung-task panic, and the MAX_SCHEDULE_TIMEOUT clamp does 
not bound the actual hang.

nbd allocates its tag set with BLK_MQ_F_BLOCKING (nbd_dev_add()), so 
nbd_queue_rq() is not guaranteed to run in the submitter's context. In 
the common case the block layer dispatches it from a kworker 
(blk_mq_run_work_fn), while the submitting task blocks in 
folio_wait_bit_common() (io_schedule, plain TASK_UNINTERRUPTIBLE) 
waiting for the bio to complete during the partition scan (bdev_open -> 
bdev_disk_changed -> do_read_cache_folio). That submitter wait is caught 
by the base hung-task detector regardless of what state 
wait_for_reconnect() sleeps in — the "blocked in I/O wait" message is 
printed unconditionally in check_hung_task() (t->in_iowait ? " in I/O 
wait" : "") and is not gated on CONFIG_DETECT_HUNG_TASK_BLOCKER. 
wait_event_idle_timeout() only hides the wait_for_reconnect() frame (the 
"inline dispatch" manifestation from the sample report); it cannot hide 
the submitter's I/O-completion wait, so the panic still fires.

The clamp is also not a bound. min_t(u64, timeout, U32_MAX) then 
min_t(u64, timeout * HZ, MAX_SCHEDULE_TIMEOUT) only prevents the u64 * 
HZ overflow; the resulting wait is still ~136 years, i.e. effectively 
unbounded. Because the submitter's I/O-completion wait cannot be made 
interruptible, the only way to guarantee the request fails before the 
detector threshold is to bound the reconnect wait itself.

This was confirmed on a KASAN build (hung-task timeout lowered to 20s) 
with a reproducer that configures a single-connection nbd device with a 
huge dead_conn_timeout, kills the socket, and reads /dev/nbd0:

unpatched, huge timeout: PANIC.
v1 (idle + MAX_SCHEDULE_TIMEOUT clamp), huge timeout: STILL PANIC 
(nbd_synth blocked in I/O wait, folio_wait_bit_common, Kernel panic - 
hung_task).
wait_event_killable_timeout + MAX_SCHEDULE_TIMEOUT clamp, huge timeout: 
STILL PANIC (identical).
unpatched, dead_conn_timeout = 8s: CLEAN — the read returns -EIO after 
8s, no hung task.
Required corrections:

Bound dead_conn_timeout to a real maximum that keeps the effective 
reconnect wait below the hung-task detection threshold, not merely below 
MAX_SCHEDULE_TIMEOUT. The clamp must cap the wait to a finite, small 
value (on the order of the default hung_task_timeout_secs, e.g. a few 
tens of seconds) so that a request against a dead connection fails with 
-EIO in bounded time. Keep the overflow-safe u64 timeout conversion, but 
the ceiling must bound the hang, not just the arithmetic. The exact 
ceiling is a semantics decision for the nbd maintainers; state it 
explicitly in the commit message.

Replace wait_event_idle_timeout() with wait_event_killable_timeout() 
rather than TASK_IDLE. Both are skipped by the hung-task detector, but 
TASK_KILLABLE additionally lets SIGKILL/the OOM killer reap a submitter 
that does run wait_for_reconnect() inline. Capture the return value in a 
long and treat ret <= 0 (timeout, or -ERESTARTSYS from a fatal signal) 
as "no reconnect" and fail the request. Non-fatal signals must still not 
end the wait, preserving the intent of commit ff57dc94faec ("nbd: wait 
uninterruptible for the dead timeout").

Wake the reconnect waitqueue when the connection is torn down. 
sock_shutdown() sets NBD_RT_DISCONNECTED but does not wake 
config->conn_wait, so a concurrent waiter only observes the flag after 
its own timeout. Add wake_up(&config->conn_wait) in sock_shutdown() 
after the sockets are marked dead.

Do not rely on the sleep-state change alone to close the report. Note in 
the commit message that the BLK_MQ_F_BLOCKING async-dispatch path leaves 
the submitter in an uninterruptible I/O-completion wait, and that 
bounding the timeout (correction 1) is what actually prevents the panic; 
the killable wait (correction 2) is reapability hardening, not the 
primary fix.

Use Fixes: 560bc4b39952 ("nbd: handle dead connections"), which 
introduced both wait_for_reconnect() and the unbounded 
dead_conn_timeout. Reference ff57dc94faec in the body when explaining 
why the wait must stay signal-safe against non-fatal signals, but it is 
not the root of the unbounded-wait DoS.


On 15/07/2026 17:32, syzbot wrote:
> An unprivileged user can configure an NBD device with an arbitrarily large
> dead connection timeout via the NBD_ATTR_DEAD_CONN_TIMEOUT netlink
> attribute. When a request is queued and the connection is dead,
> nbd_handle_cmd() calls wait_for_reconnect(), which blocks the current
> thread using wait_event_timeout(). Because this wait is in the
> TASK_UNINTERRUPTIBLE state, a timeout larger than 120 seconds triggers the
> hung task detector, leading to a kernel panic:
>
> INFO: task kworker/1:1H:667 blocked for more than 143 seconds.
> Workqueue: kblockd blk_mq_run_work_fn
> Call Trace:
>   <TASK>
>   __schedule+0x17e7/0x5630
>   schedule+0x164/0x2b0
>   schedule_timeout+0x152/0x2c0
>   wait_for_reconnect drivers/block/nbd.c:1107 [inline]
>   nbd_handle_cmd drivers/block/nbd.c:1149 [inline]
>   nbd_queue_rq+0x797/0xfb0 drivers/block/nbd.c:1207
>   blk_mq_dispatch_rq_list+0x499/0x1990
>   __blk_mq_sched_dispatch_requests+0xd36/0x1580
>   blk_mq_sched_dispatch_requests+0xd7/0x190
>   blk_mq_run_work_fn+0x16c/0x300
>   process_one_work kernel/workqueue.c:3322 [inline]
>   process_scheduled_works+0xa8e/0x14e0
>   worker_thread+0x92d/0xe10
>   kthread+0x388/0x470
>   ret_from_fork+0x514/0xb70
>   ret_from_fork_asm+0x1a/0x30
>   </TASK>
>
> Historically, wait_for_reconnect() used wait_event_interruptible_timeout(),
> but commit ff57dc94faec ("nbd: wait uninterruptible for the dead timeout")
> changed it to wait_event_timeout() to prevent signals from prematurely
> interrupting the wait. However, using TASK_UNINTERRUPTIBLE for arbitrarily
> long waits is an anti-pattern that trips the hung task detector.
>
> Fix this by replacing wait_event_timeout() with wait_event_idle_timeout().
> This puts the task into the TASK_IDLE state (TASK_UNINTERRUPTIBLE |
> TASK_NOLOAD), which ignores signals as intended but is explicitly ignored
> by the hung task detector.
>
> Additionally, add defense-in-depth by capping the parsed timeout to U32_MAX
> and the resulting jiffies to MAX_SCHEDULE_TIMEOUT. This prevents integer
> overflow when the u64 timeout is implicitly cast to a signed long by
> schedule_timeout(), which could otherwise result in a negative timeout and
> cause the wait to return immediately.
>
> Fixes: ff57dc94faec ("nbd: wait uninterruptible for the dead timeout")
> Assisted-by: Gemini:gemini-3.1-pro-preview syzbot
> Reported-by: syzbot+30c16035531e3248dcbc@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=30c16035531e3248dcbc
> Link: https://syzkaller.appspot.com/ai_job?id=f07c3611-0a61-4d67-9f4d-033b1cb82e1e
> To: "Jens Axboe" <axboe@kernel.dk>
> To: "Josef Bacik" <josef@toxicpanda.com>
> To: <linux-block@vger.kernel.org>
> To: <nbd@other.debian.org>
> To: "Josef Bacik" <jbacik@fb.com>
> Cc: <linux-kernel@vger.kernel.org>
>
> ---
> diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
> index 8f10762e9..874a916f8 100644
> --- a/drivers/block/nbd.c
> +++ b/drivers/block/nbd.c
> @@ -1104,11 +1104,11 @@ static int wait_for_reconnect(struct nbd_device *nbd)
>   	if (!config->dead_conn_timeout)
>   		return 0;
>   
> -	if (!wait_event_timeout(config->conn_wait,
> -				test_bit(NBD_RT_DISCONNECTED,
> -					 &config->runtime_flags) ||
> -				atomic_read(&config->live_connections) > 0,
> -				config->dead_conn_timeout))
> +	if (!wait_event_idle_timeout(
> +		    config->conn_wait,
> +		    test_bit(NBD_RT_DISCONNECTED, &config->runtime_flags) ||
> +			    atomic_read(&config->live_connections) > 0,
> +		    config->dead_conn_timeout))
>   		return 0;
>   
>   	return !test_bit(NBD_RT_DISCONNECTED, &config->runtime_flags);
> @@ -2194,9 +2194,11 @@ static int nbd_genl_connect(struct sk_buff *skb, struct genl_info *info)
>   		nbd_set_cmd_timeout(nbd,
>   				    nla_get_u64(info->attrs[NBD_ATTR_TIMEOUT]));
>   	if (info->attrs[NBD_ATTR_DEAD_CONN_TIMEOUT]) {
> -		config->dead_conn_timeout =
> +		u64 timeout =
>   			nla_get_u64(info->attrs[NBD_ATTR_DEAD_CONN_TIMEOUT]);
> -		config->dead_conn_timeout *= HZ;
> +		timeout = min_t(u64, timeout, U32_MAX);
> +		config->dead_conn_timeout =
> +			min_t(u64, timeout * HZ, MAX_SCHEDULE_TIMEOUT);
>   	}
>   	if (info->attrs[NBD_ATTR_SERVER_FLAGS])
>   		config->flags =
> @@ -2415,9 +2417,11 @@ static int nbd_genl_reconfigure(struct sk_buff *skb, struct genl_info *info)
>   		nbd_set_cmd_timeout(nbd,
>   				    nla_get_u64(info->attrs[NBD_ATTR_TIMEOUT]));
>   	if (info->attrs[NBD_ATTR_DEAD_CONN_TIMEOUT]) {
> -		config->dead_conn_timeout =
> +		u64 timeout =
>   			nla_get_u64(info->attrs[NBD_ATTR_DEAD_CONN_TIMEOUT]);
> -		config->dead_conn_timeout *= HZ;
> +		timeout = min_t(u64, timeout, U32_MAX);
> +		config->dead_conn_timeout =
> +			min_t(u64, timeout * HZ, MAX_SCHEDULE_TIMEOUT);
>   	}
>   	if (info->attrs[NBD_ATTR_CLIENT_FLAGS]) {
>   		u64 flags = nla_get_u64(info->attrs[NBD_ATTR_CLIENT_FLAGS]);
>
>
> base-commit: a13c140cc289c0b7b3770bce5b3ad42ab35074aa
