Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0EC641B8ED
	for <syzbot@lists.linux.dev>; Thu, 30 Jul 2026 11:45:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=100.103.45.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785411954; cv=pass; b=XuFMpYKRuIvd02jaV4jdzZ70m7m9Bg+2r1Mm5P9Rsh1rBb6L0VwzHk+pQppyfcF3y+hltDBguzGY6loJsiKZCOGmskQLwWIRn29pacQybvAKWfq9W7BUUfxtWiQbnZrpQQy2cnHgoSEwG5kGXF3mhFeQtu0QPqfnFv1L1l8uC24=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785411954; c=relaxed/simple;
	bh=LgbO9OXkX+oAoVk3TxbCypdSrbho2I1sLwhUemOj4wE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=baieSMofftdxt8wdr/qtn0dBxY6jm4txa89/HuMo5LJDr+IrEe2eMzzlPWoGUsdbi0XbyAgXHW0QqBPMI3mTmGtR8R4woXzd7oQQRvcnMbnIaJcm8nyqW/d2wNbsMpNENMefTPpe924ym87PxbVcgS9pFUrgBXka3v9TjbsqsxM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=poczta.fm header.i=@poczta.fm header.b=sKtswT6E; arc=pass smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=poczta.fm header.i=@poczta.fm header.b="sKtswT6E"
Received: by smtp.kernel.org (Postfix)
	id 8271F1F00A3A; Thu, 30 Jul 2026 11:45:51 +0000 (UTC)
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=217.74.67.75
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1785411951;
	b=MIM6HqIXV4nirM3LaVmSkcK23VNE7gMN9HniU+x5ceD5s86IJV17BmlXTe1PlTsaidF1
	 pY4lzaVmfDPrQ6UJ1bwW4SENB6AdjAOn0rosHPnavBfIShRVgmNaYzSqSj7LxuVMLJrWw
	 LBOhzDKWOt8hjX4YhZhPSiOtb8FxBRYMkx3FXn5cNOBwNFeQyC6RZJAvdLQGID4sQ88OK
	 eugxbyuWuy8FyljWl2ZgxfFe7YQw3HXrPJajbntM3xRTLmS1hvVA2t+xhQMfYo9NhAAmk
	 XYnYtG9giGTT8KnDmBfnREUyQ+iaBs9uux5Nj6c5XSGU3S31x3MerONIjZAo07ivRfw==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1785411951;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To:
	 DKIM-Signature;
	bh=uUZdKorYaV2prqOMcpeiMrN9iM2TCErtY1waeVEDxu0=;
	b=CwOqdd77DpQ1vr2jMkl7VNOixDWPyrcwGEO9Xfe16zLIT05tE0AxO4eQBM7sp1FgWP69
	 m2mkNfg9+6EiVCNYoBZ0GxF/v91Hx/jGGG/kbzJimo7meKayjcIFdondMS8Q151o9+MM/
	 JGOn2RqK8jf3jpKR6svFW9x/H/Perik6Wu7Pg3pJdLIxcXjJvO+PZdveHbNdnz+/69swJ
	 w9eb0YwnFiWY8y/7oQr6EGHPfFKt+D7P3UXFKVt6+UzelXmObgi9vOaCAjsbwSMJOKDO9
	 DzFNjieGbWm9HyvJY+4SVuxNYH0Ae2GzIZwNuQNkmD7k07qG7dolWFI5+8c6mGZ1S0g==
ARC-Authentication-Results: i=1; smtp.kernel.org; dkim=pass header.d=poczta.fm header.i=@poczta.fm header.a=rsa-sha256 header.s=dk header.b=sKtswT6E;
	dmarc=pass header.from=poczta.fm;
	spf=pass smtp.mailfrom=poczta.fm;
	arc=none smtp.remote-ip=217.74.67.75
Received: from smtpo75.interia.pl (smtpo75.interia.pl [217.74.67.75])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 0F0211F000E9
	for <syzbot@kernel.org>; Thu, 30 Jul 2026 11:45:48 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=poczta.fm header.i=@poczta.fm header.a=rsa-sha256 header.s=dk header.b=sKtswT6E
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.kernel.org 0F0211F000E9
Authentication-Results: smtp.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=poczta.fm
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=poczta.fm
Received: from nr200 (unknown [80.68.231.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by poczta.interia.pl (INTERIA.PL) with ESMTPSA;
	Thu, 30 Jul 2026 13:45:44 +0200 (CEST)
Date: Thu, 30 Jul 2026 13:45:42 +0200
From: Slawomir Stepien <sst@poczta.fm>
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Subject: Re: [PATCH RFC] 9p/trans_fd: enforce non-blocking I/O with
 IOCB_NOWAIT
Message-ID: <ams5Zg_d25P06k0J@nr200>
References: <7b6e50bb-fee0-4489-a753-00087e6944ae@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7b6e50bb-fee0-4489-a753-00087e6944ae@mail.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=poczta.fm; s=dk;
	t=1785411946; bh=uUZdKorYaV2prqOMcpeiMrN9iM2TCErtY1waeVEDxu0=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	b=sKtswT6EZYleMY3BophpAHAaLbsNmtYdPdjC9cpyi+BmlqpMi1Q3pGaaUFgp9rArP
	 new3KE4wN27PMMigo4xNoZtQcOs7mFCqRCSsibSaOpqQjU9IOKmyZyGNVp3A0RK3Wn
	 xRiG95066cwKewmu/Opjxxyc8T4e2YypHvDWYCw8=

On cze 29, 2026 18:08, syzbot wrote:
> The 9p filesystem's file descriptor transport uses workqueues to handle
> asynchronous reading and writing. When a connection is established, it sets
> the O_NONBLOCK flag on the provided file descriptors to prevent workers
> from hanging on I/O. However, because the file descriptors are shared with
> userspace, a malicious or buggy userspace program can clear the O_NONBLOCK
> flag concurrently using fcntl(fd, F_SETFL, ...).
> 
> If userspace clears the O_NONBLOCK flag, the read worker (p9_read_work) can
> block indefinitely in kernel_read() when reading from an empty pipe. When
> the connection is subsequently destroyed, p9_conn_destroy() calls
> cancel_work_sync(&m->rq), which hangs forever waiting for the blocked read
> worker, eventually triggering the khungtaskd watchdog:
> 
> INFO: task blocked for more than 143 seconds.
> Call Trace:
>  <TASK>
>  __schedule+0x17e7/0x5630 kernel/sched/core.c:7234
>  schedule+0x164/0x2b0 kernel/sched/core.c:7326
>  schedule_timeout+0xc0/0x2c0 kernel/time/sleep_timeout.c:75
>  wait_for_completion+0x2ca/0x5e0 kernel/sched/completion.c:153
>  __flush_work+0xa63/0xca0 kernel/workqueue.c:4374
>  __cancel_work_sync+0xbe/0x110 kernel/workqueue.c:4494
>  p9_conn_destroy net/9p/trans_fd.c:805 [inline]
>  p9_fd_close+0x23c/0x3f0 net/9p/trans_fd.c:840
>  p9_client_create+0x8a6/0xc60 net/9p/client.c:939
>  v9fs_session_init+0x46/0xd40 fs/9p/v9fs.c:471
>  v9fs_get_tree+0xbd/0xac0 fs/9p/vfs_super.c:97
>  vfs_get_tree+0x92/0x2a0 fs/super.c:1694
>  do_new_mount+0x319/0xdc0 fs/namespace.c:3841
>  __se_sys_mount+0x31d/0x420 fs/namespace.c:4367
>  do_syscall_64+0x15f/0x560 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>  </TASK>
> 
> To fix this, do not rely on file->f_flags & O_NONBLOCK to ensure
> non-blocking I/O. Instead, replace kernel_read() and kernel_write() with
> vfs_iocb_iter_read() and vfs_iocb_iter_write(), passing a kiocb with the
> IOCB_NOWAIT flag set. This guarantees non-blocking behavior regardless of
> the f_flags state, completely eliminating the race condition with
> userspace.
> 
> Fixes: ef575281b21e ("9p/trans_fd: always use O_NONBLOCK read/write")
> Assisted-by: Gemini:gemini-3.1-pro-preview best-expensive syzbot
> Reported-by: syzbot+ed53e35a1e9dde289579@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=ed53e35a1e9dde289579
> Link: https://syzkaller.appspot.com/ai_job?id=372eb0ab-345a-4053-96b2-027ab6aa8d21
> To: "Dominique Martinet" <asmadeus@codewreck.org>
> To: "Eric Van Hensbergen" <ericvh@kernel.org>
> To: "Latchesar Ionkov" <lucho@ionkov.net>
> To: <v9fs@lists.linux.dev>
> Cc: <linux-kernel@vger.kernel.org>
> Cc: "Christian Schoenebeck" <linux_oss@crudebyte.com>
> 
> ---
> diff --git a/net/9p/trans_fd.c b/net/9p/trans_fd.c
> index eb685b52a..2b3a07b98 100644
> --- a/net/9p/trans_fd.c
> +++ b/net/9p/trans_fd.c
> @@ -22,6 +22,7 @@
>  #include <linux/uaccess.h>
>  #include <linux/inet.h>
>  #include <linux/file.h>
> +#include <linux/fs.h>
>  #include <linux/fs_context.h>
>  #include <linux/slab.h>
>  #include <linux/seq_file.h>
> @@ -217,7 +218,9 @@ static int p9_fd_read(struct p9_client *client, void *v, int len)
>  {
>  	int ret;
>  	struct p9_trans_fd *ts = NULL;
> -	loff_t pos;
> +	struct kiocb kiocb;
> +	struct iov_iter iter;
> +	struct kvec iov = { .iov_base = v, .iov_len = len };

I see that __kernel_read() (called from kernel_read()) clamps the iov_len:

	.iov_len	= min_t(size_t, count, MAX_RW_COUNT)

Maybe it is worth doing the same in this patch?

>  	if (client && client->status != Disconnected)
>  		ts = client->trans;
> @@ -225,11 +228,16 @@ static int p9_fd_read(struct p9_client *client, void *v, int len)
>  	if (!ts)
>  		return -EREMOTEIO;
>  
> -	if (!(ts->rd->f_flags & O_NONBLOCK))
> -		p9_debug(P9_DEBUG_ERROR, "blocking read ...\n");
> +	init_sync_kiocb(&kiocb, ts->rd);
> +	kiocb.ki_pos = ts->rd->f_pos;
> +	kiocb.ki_flags |= IOCB_NOWAIT;
> +
> +	iov_iter_kvec(&iter, ITER_DEST, &iov, 1, len);
> +
> +	ret = vfs_iocb_iter_read(ts->rd, &kiocb, &iter);

If the kernel_read() is replaced with vfs_iocb_iter_read() then accounting functions will not be
called like it is with __kernel_read():

	ret = file->f_op->read_iter(&kiocb, &iter);
	if (ret > 0) {
		...
		add_rchar(current, ret);
	}
	inc_syscr(current);

Maybe it would be better to duplicated what kernel_read()/__kernel_read() does but with IOCB_NOWAIT
set, even if that brings a bit of code duplication?

I've done some tests (num of IOPS, mean latency for READ and WRITE) with fio to benchmark this fix
and I see 5% to 10% degradation in performance with this patch.

> +	if (ret > 0)
> +		ts->rd->f_pos = kiocb.ki_pos;
>  
> -	pos = ts->rd->f_pos;
> -	ret = kernel_read(ts->rd, v, len, &pos);
>  	if (ret <= 0 && ret != -ERESTARTSYS && ret != -EAGAIN)
>  		client->status = Disconnected;
>  	return ret;
> @@ -385,6 +393,9 @@ static int p9_fd_write(struct p9_client *client, void *v, int len)
>  {
>  	ssize_t ret;
>  	struct p9_trans_fd *ts = NULL;
> +	struct kiocb kiocb;
> +	struct iov_iter iter;
> +	struct kvec iov = { .iov_base = v, .iov_len = len };

ditto

>  	if (client && client->status != Disconnected)
>  		ts = client->trans;
> @@ -392,10 +403,16 @@ static int p9_fd_write(struct p9_client *client, void *v, int len)
>  	if (!ts)
>  		return -EREMOTEIO;
>  
> -	if (!(ts->wr->f_flags & O_NONBLOCK))
> -		p9_debug(P9_DEBUG_ERROR, "blocking write ...\n");
> +	init_sync_kiocb(&kiocb, ts->wr);
> +	kiocb.ki_pos = ts->wr->f_pos;
> +	kiocb.ki_flags |= IOCB_NOWAIT;
> +
> +	iov_iter_kvec(&iter, ITER_SOURCE, &iov, 1, len);
> +
> +	ret = vfs_iocb_iter_write(ts->wr, &kiocb, &iter);
> +	if (ret > 0)
> +		ts->wr->f_pos = kiocb.ki_pos;

ditto

>  
> -	ret = kernel_write(ts->wr, v, len, &ts->wr->f_pos);
>  	if (ret <= 0 && ret != -ERESTARTSYS && ret != -EAGAIN)
>  		client->status = Disconnected;
>  	return ret;
> @@ -728,21 +745,11 @@ static int p9_fd_open(struct p9_client *client, int rfd, int wfd)
>  		goto out_free_ts;
>  	if (!(ts->rd->f_mode & FMODE_READ))
>  		goto out_put_rd;
> -	/* Prevent workers from hanging on IO when fd is a pipe.
> -	 * It's technically possible for userspace or concurrent mounts to
> -	 * modify this flag concurrently, which will likely result in a
> -	 * broken filesystem. However, just having bad flags here should
> -	 * not crash the kernel or cause any other sort of bug, so mark this
> -	 * particular data race as intentional so that tooling (like KCSAN)
> -	 * can allow it and detect further problems.
> -	 */
> -	data_race(ts->rd->f_flags |= O_NONBLOCK);
>  	ts->wr = fget(wfd);
>  	if (!ts->wr)
>  		goto out_put_rd;
>  	if (!(ts->wr->f_mode & FMODE_WRITE))
>  		goto out_put_wr;
> -	data_race(ts->wr->f_flags |= O_NONBLOCK);
>  
>  	client->trans = ts;
>  	client->status = Connected;
> @@ -784,8 +791,6 @@ static int p9_socket_open(struct p9_client *client, struct socket *csocket)
>  	client->trans = p;
>  	client->status = Connected;
>  
> -	p->rd->f_flags |= O_NONBLOCK;
> -
>  	p9_conn_create(client);
>  	return 0;
>  }
> 
> 
> base-commit: dc59e4fea9d83f03bad6bddf3fa2e52491777482

-- 
Slawomir Stepien
