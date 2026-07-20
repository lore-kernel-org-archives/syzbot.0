Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E276A409281
	for <syzbot@lists.linux.dev>; Mon, 20 Jul 2026 16:09:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784563794; cv=none; b=SbshneXgpWwhLDdlEdHmmYLFZeHJ7CzYqoVPACWwiMRCy5QRf3y3GGciPJgOmuNfStOGZpGcpraQlfMk9k/oR37ErBbNtD2jtiHsdvdUBAOSJOhnQ214RLnfDg/lfNNav5E2+kkgmEk2Q89kMUM65fTaGvf/vPr37eh3Ya5urOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784563794; c=relaxed/simple;
	bh=t7j2gQ2LkJu1uNSVcPH4a3NOcuKmCuMMLibePozWC3Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HiZe0KcYbNeA28UIByOH5LjKdVRg2PRcUa+KjIviJs5BeHnegZBUE48eGe2AgOPteo7Q7NGDUihBiyDE7J98+xyoTMCVHVkIjMt0lAbYhytvAzFd2Xu0V+o2nWbJTuOfFvO1/jJDajZBsvLXAng8IQug58uPPIP3VRahOHw4m8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=riqVoO7h; arc=none smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="riqVoO7h"
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-698aa7ba320so9103599a12.1
        for <syzbot@lists.linux.dev>; Mon, 20 Jul 2026 09:09:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784563787; x=1785168587; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=UuI/7odz/C5y3twHlQ/lBBbnoAsr9YSzA5CoBia5l9I=;
        b=riqVoO7hTPf/jL0RFQ8bCkyQBia6tHGeCgFPp54npe4otAaBklqz466qn+ycmXVsun
         VaztyvL8AxVyDeBgPofufJtxIAOic5B1Ue/Ua1f4a8tRVSPX2zESUUOTkhyBdFiujTv0
         k8xym28IZdaMb9YtYurREmWNCa5Ux68BJWLMST1mRD5H8a8IWCLcE5+PZnOo9g/Tb9/R
         6LHt1o+9xGOQEQ9OD35vH01brE3M9RNqSCirxtjQJPpa5HhT1hsIH5v6aqtdbFh4+vL1
         Z3+5g+epTckqeo2/Q6FOg69sBcVotXyWaQAaOfcT9pZyVFfkFvlhvYCa/OQur2D9yv0S
         rRAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784563787; x=1785168587;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=UuI/7odz/C5y3twHlQ/lBBbnoAsr9YSzA5CoBia5l9I=;
        b=ky6AXDFHgoTsJm/mNZJNjDOwa1Kw0/8lbolWGxAB3ICjnEVN0Nu5LGN6HXyO1kvZt4
         h2uEs8kZFf4tbOtER67UKuuLNUPoYgBMQcJzPx/3fQIu4lb3c3+fQ/o23r0sTCMyCHHU
         d+ODRYrJgJqsHyRz6CgB/cnES8f7YYOi/Yv96bffZuGSNe01kK/v9j7dbasAHr8tvwlV
         u0e5yZZHRSHtTqWTCBgmXqq5lpB+XgPL3dGrino8sHY+TWtTXL/ydZ1303G/per+jdae
         /VohirTGIx1PVhGCTFSblEI02I4O7mtXWtgW5jX9LRvLFhpUoz49Q8XL4yew9muOJFpi
         Lshw==
X-Gm-Message-State: AOJu0Yy/qf5NZthpFg3t1w7m+wB4EKzfHYiqv28PzShWRc66L1TGE3Je
	PttKJoA2WUB8J4DE74ZWfdrJCteVg65xbcdgtDLVrZnQoPiwEyEniU7o
X-Gm-Gg: AfdE7clPKYEwHMEWh8M+ldKOSPf5hY9I1bHq+4TUh79PZ2X0UIF/qjU7W/kWw3Lxfw8
	VPNyjsHoWTUhVSKpB9pqDZK1ikXF5hTU2pSWmB+JYOW1zKf05XZ8iRmuL5n9tjR/lZ98ZPaTXBN
	eu13UO5eim98CYbF6ZAWw/5lUWDXySZeUw+h4x4oxkR2zeH/i4d2vueZ/Y3YQJ9NpDLd29ufwyN
	celhClFJZijpv35GURTP189mL7EAafks1VsyyFIAlNZAspK6nJ5nIMmHtGUdbkyDLI6g8OkHirE
	FiO4ec/Ljz0LOEIAMZb5NCpLzsWJJ+5Om1xUfpDXlD1Fudd4b0MZFfhI/zcGjphfH4IoKl2z8zR
	31ywXETRc1Q/xkjpNwZ0czPmUfeVmFFtaz0NYUrz8ZXSBmQ5z0qve+rn9dPtDXBkfPp4+qHPEgE
	EPwv9yGzvqssCpVu1vhtn67USl9wXPRvoP0Nba+B6TvTNyhMpzXsDTHvh2UxKGrGRWrMPacKr9Y
	5/sVmy71rMCY7BGcYk1cmv6QchJQxSpYkf6QLzSZA9BE79UO5kVRPcq5GsvSdSX5xO3j+Kw
X-Received: by 2002:a05:6402:40c7:b0:697:eb97:a4ed with SMTP id 4fb4d7f45d1cf-69e64dd54d5mr5519341a12.7.1784563786783;
        Mon, 20 Jul 2026 09:09:46 -0700 (PDT)
Received: from [192.168.100.51] (87-205-15-91.static.ip.netia.com.pl. [87.205.15.91])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-69e9876a6e0sm3362738a12.12.2026.07.20.09.09.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Jul 2026 09:09:45 -0700 (PDT)
Message-ID: <b0a320d4-1219-4850-979f-e930f0a3833e@gmail.com>
Date: Mon, 20 Jul 2026 18:09:45 +0200
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC] nbd: fix generic netlink deadlock and lockdep
 exhaustion
To: syzbot <syzbot@kernel.org>, syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
References: <69ff9a21-60be-4e97-bc8f-a59e739fd982@mail.kernel.org>
Content-Language: en-US
From: Krystian Kaniewski <krystianmkaniewski@gmail.com>
In-Reply-To: <69ff9a21-60be-4e97-bc8f-a59e739fd982@mail.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Please generate a replacement v2 for the current AI patch for this NBD 
hung-task report. Start from the original kernel base commit 
`8cd9520d35a6c38db6567e97dd93b1f11f185dc6`. Do not make an incremental 
patch on top of the current AI-generated diff.

The supplied reproducer connects an NBD device to a server which does 
not complete an I/O request. It then sends `NBD_CMD_RECONFIGURE` with a 
new `NBD_ATTR_SIZE_BYTES` value and no effective block-size change. 
`nbd_genl_reconfigure()` calls `nbd_set_size()`, which unconditionally 
calls `queue_limits_commit_update_frozen()`. The queue cannot drain 
because the request never completes. The operation therefore waits 
indefinitely while holding `genl_mutex`, and unrelated generic netlink 
users block behind it.

The important detail is that this request changes only disk capacity. It 
does not change logical block size, physical block size, discard limits, 
write-cache or FUA features, rotational state, or write-zeroes limits. A 
capacity-only generic netlink reconfigure does not need to recommit 
queue limits or freeze the request queue.

Replace the current AI patch with a narrow fix for that condition.

Required implementation:

1. Keep the existing `nbd_set_size()` queue-limits update for device 
startup, `NBD_SET_BLKSIZE`, the legacy size ioctls, and generic netlink 
requests which change the effective block size.
2. Add a small helper for the existing capacity update sequence: set 
`GD_NEED_PART_SCAN` when required, call `set_capacity_and_notify()`, and 
send the fallback `KOBJ_CHANGE` event when that helper does not send one.
3. Add a capacity-only path used by `nbd_genl_size_set()`. It must 
validate `bytesize`, store `config->bytesize`, and update live disk 
capacity without calling `queue_limits_start_update()` or 
`queue_limits_commit_update_frozen()`.
4. Preserve initial connect behavior. If `nbd->pid` is zero, the 
capacity-only path must store the requested byte size without notifying 
a live disk. `nbd_start_device()` must still run the full existing 
limits update after the device starts.
5. Normalize a zero `NBD_ATTR_BLOCK_SIZE_BYTES` value to the default 
block size before comparing it with the current effective block size. 
Preserve validation of nonzero invalid block sizes.
6. In `nbd_genl_size_set()`, use the capacity-only path only when the 
normalized block size equals the current block size. If the effective 
block size changes, call the existing full `nbd_set_size()` path.
7. Leave `NBD_SET_SIZE`, `NBD_SET_SIZE_BLOCKS`, and `NBD_SET_BLKSIZE` on 
their existing full `nbd_set_size()` path. Do not add an `update_limits 
= false` argument to the two legacy size ioctls.

The legacy ioctl requirement is important. `NBD_SET_FLAGS` can change 
`config->flags` on an ioctl-controlled device without immediately 
updating queue limits. A later `NBD_SET_SIZE` currently republishes 
limits derived from those flags, including discard, write cache, FUA, 
rotational, and write-zeroes settings. Making the legacy size ioctls 
unconditionally capacity-only would leave `config->flags` and queue 
limits inconsistent. The fast path is safe in generic netlink 
reconfigure because `NBD_ATTR_SERVER_FLAGS` is set during connect and is 
not changed by `NBD_CMD_RECONFIGURE`.

Remove every unrelated change from the current AI patch:

- Do not set `.parallel_ops = true`. NBD callbacks are not serialized 
for their complete state transitions because `nbd_start_device()` 
temporarily drops `config_lock`. A concurrent disconnect could otherwise 
shut down sockets and clear `NBD_RT_BOUND` before connect resumes and 
reports success.
- Do not replace the queue-limits helper with a hard-coded timed freeze. 
The current AI timeout path publishes `config->bytesize` and 
`config->blksize_bits` before success, so timeout can leave 
configuration, queue limits, and disk capacity inconsistent. The 
size-only fix does not need a queue freeze at all.
- Do not remove the queue freeze from `nbd_add_socket()`. Commit 
`b98e762e3d71` added it to protect `config->socks` reallocation from 
request-path access.
- Do not add an `nbd->pid` guard to `nbd_handle_cmd()` as a replacement 
for the socket-array freeze.
- Do not convert `nbd_total_devices` to an atomic counter and do not add 
a hard device limit. That change is unrelated to this report and the 
proposed check is racy under concurrent creation.
- Do not reformat the generic netlink family initializer or make other 
unrelated cleanup changes.

Keep the patch limited to `drivers/block/nbd.c`.

Use this subject:

nbd: skip queue limits update for size-only reconfigure

The commit message should explain the following points in direct kernel 
terminology:

- Commit `242a49e5c878` correctly added queue freezing for live updates 
of real queue limits.
- `nbd_set_size()` is also used for capacity-only generic netlink 
updates, so the freeze is unnecessarily broad for the reported request.
- The unresponsive NBD server leaves I/O in flight, and the unnecessary 
freeze waits forever while `genl_mutex` is held.
- A size-only reconfigure can update `config->bytesize` and disk 
capacity directly because the effective block size and all other queue 
limits stay unchanged.
- Startup and actual block-size changes continue to use the existing 
frozen limits update.
- Do not claim that all NBD generic netlink operations can no longer 
wait indefinitely. A real block-size change still requires queue 
serialization and is outside this focused fix.

Include these tags:

Fixes: 242a49e5c878 ("nbd: freeze the queue for queue limits updates")
Reported-by: syzbot+f272bbfbf8498ddadea5@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=f272bbfbf8498ddadea5

Validate the revised patch with the supplied reproducer and confirm that 
a size-only `NBD_CMD_RECONFIGURE` no longer enters 
`queue_limits_commit_update_frozen()`. Also build `drivers/block/nbd.o` 
and cover these cases:

- Generic netlink size-only reconfigure with an unchanged block size.
- Generic netlink size-only reconfigure with block-size attribute zero 
when the current size is the default.
- Generic netlink reconfigure with a real valid block-size change, which 
must retain the full limits update.
- Generic netlink reconfigure with an invalid block size, which must 
still fail validation.
- Initial generic netlink connect, where size may be stored before 
`nbd->pid` is set and all limits must still be applied by 
`nbd_start_device()`.
- Running legacy ioctl device with `NBD_SET_FLAGS` followed by 
`NBD_SET_SIZE`, which must retain the previous flag-derived queue-limit 
update behavior.

On 6/27/2026 2:48 AM, syzbot wrote:
> A system-wide deadlock in the generic netlink subsystem can occur when the
> NBD driver holds the global genl_mutex while waiting indefinitely for an
> I/O request to complete.
>
> When a device is connected with timeout=0 and does not reply to I/O
> requests, any I/O sent to the device will hang forever. When nbd_set_size()
> updates the device capacity, it triggers a uevent. This wakes up udevd,
> which opens the device and issues I/O to read the partition table. This I/O
> hangs.
>
> A subsequent NBD_CMD_RECONFIGURE command calls nbd_set_size(), which calls
> queue_limits_commit_update_frozen(). This freezes the queue, waiting
> uninterruptibly for all inflight I/Os to complete. However, the process
> supposed to service those inflight I/Os is blocked in the kernel waiting
> for the queue to freeze, resulting in an unbreakable deadlock:
>
> INFO: task syz.2.23:6285 blocked for more than 143 seconds.
> Call Trace:
>   <TASK>
>   __schedule+0x1840/0x57a0 kernel/sched/core.c:7189
>   schedule+0x164/0x360 kernel/sched/core.c:7283
>   blk_mq_freeze_queue_wait+0x101/0x180 block/blk-mq.c:191
>   blk_mq_freeze_queue include/linux/blk-mq.h:956 [inline]
>   queue_limits_commit_update_frozen+0x55/0xd0 block/blk-settings.c:590
>   nbd_set_size+0x454/0x680 drivers/block/nbd.c:374
>   nbd_genl_size_set drivers/block/nbd.c:2069 [inline]
>   nbd_genl_reconfigure+0x7e9/0x1e80 drivers/block/nbd.c:2373
>   genl_family_rcv_msg_doit+0x233/0x340 net/netlink/genetlink.c:1114
>   genl_family_rcv_msg net/netlink/genetlink.c:1194 [inline]
>   genl_rcv_msg+0x614/0x7a0 net/netlink/genetlink.c:1209
>
> Because nbd_genl_reconfigure() is called with genl_mutex held, this
> localized hang escalates into a system-wide denial of service, blocking any
> other task attempting to use generic netlink:
>
> INFO: task syz-executor:6030 blocked for more than 143 seconds.
> Call Trace:
>   <TASK>
>   __schedule+0x1840/0x57a0 kernel/sched/core.c:7189
>   schedule+0x164/0x360 kernel/sched/core.c:7283
>   schedule_preempt_disabled+0x13/0x30 kernel/sched/core.c:7340
>   __mutex_lock_common kernel/locking/mutex.c:726 [inline]
>   __mutex_lock+0x7c5/0x1590 kernel/locking/mutex.c:820
>   genl_lock net/netlink/genetlink.c:35 [inline]
>   genl_op_lock net/netlink/genetlink.c:60 [inline]
>   genl_rcv_msg+0x10b/0x7a0 net/netlink/genetlink.c:1208
>
> Fix this by implementing the following changes:
>
> First, set .parallel_ops = true in nbd_genl_family to opt out of the global
> genl_mutex. The NBD netlink callbacks are already thread-safe.
>
> Second, replace queue_limits_commit_update_frozen() in nbd_set_size() with
> a custom interruptible freeze using blk_mq_freeze_queue_wait_timeout(). If
> the queue does not drain within 3 seconds, abort the limit update and
> return -EBUSY.
>
> Third, enforce a hard limit on the total number of active NBD devices to
> prevent MAX_LOCKDEP_KEYS exhaustion. With .parallel_ops = true, rapid
> creation of thousands of NBD devices could exhaust lockdep keys. Convert
> nbd_total_devices to an atomic_t and reject new device creation if the
> limit is exceeded.
>
> Finally, remove blk_mq_freeze_queue() from nbd_add_socket() since it is
> only called before the device is started (no inflight I/Os). Add a check
> for !nbd->pid in nbd_handle_cmd() to return BLK_STS_IOERR if the device is
> not fully started.
>
> Fixes: 242a49e5c878 ("nbd: freeze the queue for queue limits updates")
> Assisted-by: Gemini:gemini-3.1-pro-preview Gemini:gemini-3-flash-preview syzbot
> Reported-by: syzbot+f272bbfbf8498ddadea5@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=f272bbfbf8498ddadea5
> Link: https://syzkaller.appspot.com/ai_job?id=6d32b7be-789c-4af6-ac95-c1ea3097953b
> To: "Jens Axboe" <axboe@kernel.dk>
> To: "Josef Bacik" <josef@toxicpanda.com>
> To: <linux-block@vger.kernel.org>
> To: <nbd@other.debian.org>
> Cc: <linux-kernel@vger.kernel.org>
>
> ---
> diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
> index fe63f3c55..c94cb15a0 100644
> --- a/drivers/block/nbd.c
> +++ b/drivers/block/nbd.c
> @@ -52,7 +52,7 @@
>   static DEFINE_IDR(nbd_index_idr);
>   static DEFINE_MUTEX(nbd_index_mutex);
>   static struct workqueue_struct *nbd_del_wq;
> -static int nbd_total_devices = 0;
> +static atomic_t nbd_total_devices = ATOMIC_INIT(0);
>   
>   struct nbd_sock {
>   	struct socket *sock;
> @@ -277,6 +277,7 @@ static void nbd_dev_remove(struct nbd_device *nbd)
>   	mutex_unlock(&nbd_index_mutex);
>   	destroy_workqueue(nbd->recv_workq);
>   	put_disk(disk);
> +	atomic_dec(&nbd_total_devices);
>   }
>   
>   static void nbd_dev_remove_work(struct work_struct *work)
> @@ -335,6 +336,7 @@ static int nbd_set_size(struct nbd_device *nbd, loff_t bytesize, loff_t blksize)
>   {
>   	struct queue_limits lim;
>   	int error;
> +	unsigned int memflags;
>   
>   	if (!blksize)
>   		blksize = 1u << NBD_DEF_BLKSIZE_BITS;
> @@ -371,7 +373,19 @@ static int nbd_set_size(struct nbd_device *nbd, loff_t bytesize, loff_t blksize)
>   
>   	lim.logical_block_size = blksize;
>   	lim.physical_block_size = blksize;
> -	error = queue_limits_commit_update_frozen(nbd->disk->queue, &lim);
> +
> +	memflags = memalloc_noio_save();
> +	blk_freeze_queue_start(nbd->disk->queue);
> +
> +	if (!blk_mq_freeze_queue_wait_timeout(nbd->disk->queue, 3 * HZ)) {
> +		blk_mq_unfreeze_queue(nbd->disk->queue, memflags);
> +		queue_limits_cancel_update(nbd->disk->queue);
> +		return -EBUSY;
> +	}
> +
> +	error = queue_limits_commit_update(nbd->disk->queue, &lim);
> +	blk_mq_unfreeze_queue(nbd->disk->queue, memflags);
> +
>   	if (error)
>   		return error;
>   
> @@ -1131,6 +1145,11 @@ static blk_status_t nbd_handle_cmd(struct nbd_cmd *cmd, int index)
>   		return BLK_STS_IOERR;
>   	}
>   
> +	if (!nbd->pid) {
> +		nbd_config_put(nbd);
> +		return BLK_STS_IOERR;
> +	}
> +
>   	if (index >= config->num_connections) {
>   		dev_err_ratelimited(disk_to_dev(nbd->disk),
>   				    "Attempted send on invalid socket\n");
> @@ -1245,7 +1264,6 @@ static int nbd_add_socket(struct nbd_device *nbd, unsigned long arg,
>   	struct socket *sock;
>   	struct nbd_sock **socks;
>   	struct nbd_sock *nsock;
> -	unsigned int memflags;
>   	int err;
>   
>   	/* Arg will be cast to int, check it to avoid overflow */
> @@ -1255,12 +1273,6 @@ static int nbd_add_socket(struct nbd_device *nbd, unsigned long arg,
>   	if (!sock)
>   		return err;
>   
> -	/*
> -	 * We need to make sure we don't get any errant requests while we're
> -	 * reallocating the ->socks array.
> -	 */
> -	memflags = blk_mq_freeze_queue(nbd->disk->queue);
> -
>   	if (!netlink && !nbd->task_setup &&
>   	    !test_bit(NBD_RT_BOUND, &config->runtime_flags))
>   		nbd->task_setup = current;
> @@ -1300,12 +1312,10 @@ static int nbd_add_socket(struct nbd_device *nbd, unsigned long arg,
>   	INIT_WORK(&nsock->work, nbd_pending_cmd_work);
>   	socks[config->num_connections++] = nsock;
>   	atomic_inc(&config->live_connections);
> -	blk_mq_unfreeze_queue(nbd->disk->queue, memflags);
>   
>   	return 0;
>   
>   put_socket:
> -	blk_mq_unfreeze_queue(nbd->disk->queue, memflags);
>   	sockfd_put(sock);
>   	return err;
>   }
> @@ -1989,7 +1999,7 @@ static struct nbd_device *nbd_dev_add(int index, unsigned int refs)
>   	 * Now publish the device.
>   	 */
>   	refcount_set(&nbd->refs, refs);
> -	nbd_total_devices++;
> +	atomic_inc(&nbd_total_devices);
>   	return nbd;
>   
>   out_free_work:
> @@ -2122,6 +2132,11 @@ static int nbd_genl_connect(struct sk_buff *skb, struct genl_info *info)
>   	mutex_unlock(&nbd_index_mutex);
>   
>   	if (!nbd) {
> +		if (atomic_read(&nbd_total_devices) >=
> +		    max_t(int, 256, nbds_max)) {
> +			pr_err("nbd: max number of devices reached\n");
> +			return -ENOMEM;
> +		}
>   		nbd = nbd_dev_add(index, 2);
>   		if (IS_ERR(nbd)) {
>   			pr_err("failed to add new device\n");
> @@ -2474,18 +2489,19 @@ static const struct genl_multicast_group nbd_mcast_grps[] = {
>   };
>   
>   static struct genl_family nbd_genl_family __ro_after_init = {
> -	.hdrsize	= 0,
> -	.name		= NBD_GENL_FAMILY_NAME,
> -	.version	= NBD_GENL_VERSION,
> -	.module		= THIS_MODULE,
> -	.small_ops	= nbd_connect_genl_ops,
> -	.n_small_ops	= ARRAY_SIZE(nbd_connect_genl_ops),
> -	.resv_start_op	= NBD_CMD_STATUS + 1,
> -	.maxattr	= NBD_ATTR_MAX,
> -	.netnsok	= 1,
> +	.hdrsize = 0,
> +	.name = NBD_GENL_FAMILY_NAME,
> +	.version = NBD_GENL_VERSION,
> +	.module = THIS_MODULE,
> +	.small_ops = nbd_connect_genl_ops,
> +	.n_small_ops = ARRAY_SIZE(nbd_connect_genl_ops),
> +	.resv_start_op = NBD_CMD_STATUS + 1,
> +	.maxattr = NBD_ATTR_MAX,
> +	.netnsok = 1,
> +	.parallel_ops = true,
>   	.policy = nbd_attr_policy,
> -	.mcgrps		= nbd_mcast_grps,
> -	.n_mcgrps	= ARRAY_SIZE(nbd_mcast_grps),
> +	.mcgrps = nbd_mcast_grps,
> +	.n_mcgrps = ARRAY_SIZE(nbd_mcast_grps),
>   };
>   MODULE_ALIAS_GENL_FAMILY(NBD_GENL_FAMILY_NAME);
>   
> @@ -2540,7 +2556,7 @@ static int nbd_genl_status(struct sk_buff *skb, struct genl_info *info)
>   
>   	msg_size = nla_total_size(nla_attr_size(sizeof(u32)) +
>   				  nla_attr_size(sizeof(u8)));
> -	msg_size *= (index == -1) ? nbd_total_devices : 1;
> +	msg_size *= (index == -1) ? atomic_read(&nbd_total_devices) : 1;
>   
>   	reply = genlmsg_new(msg_size, GFP_KERNEL);
>   	if (!reply)
>
>
> base-commit: 8cd9520d35a6c38db6567e97dd93b1f11f185dc6
