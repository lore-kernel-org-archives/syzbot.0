Received: from mail-ej2-f37.google.com (mail-ej2-f37.google.com [74.125.228.165])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3639357739
	for <syzbot@lists.linux.dev>; Fri, 18 Sep 2026 14:30:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.165
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789741808; cv=none; b=NjkyyGG5mjlpzLQPJt/S17zngVn7CKDVEDLfG4YychkcNsnGt9HnT3xDEPhrTI3bvPztI2CZzk4bW2icYWDX5vCXgC+XO0HxfnrRyTCsIo4/MdaTTdCO4/AujZHdp4NBQPezj3oKhcxmGC00p1GsYUVB4oZQsVAR3jVHrwg668g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789741808; c=relaxed/simple;
	bh=FN1QvApCHDjEf4r10HwCrmpqo9+uCCP2lqr03p2CO/g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XQbBo8NbyqfN4PoMNaGTpf/b1URbutcI3+ZTGxDzoQJ4GbOHZsPgnHSbPQrIGrxmDicDHMXAXtCBqgBNqAMDOLpmEDbucjzuswlLXb3/cWI6JU7PVkKtDXxhHeU2x1101dkLRR4v/QTGxkRllZJvH6opVr3b5zQR94ZLmAKcLQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NoKuIBun; arc=none smtp.client-ip=74.125.228.165
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NoKuIBun"
Received: by mail-ej2-f37.google.com with SMTP id a640c23a62f3a-c294af0caa8so116266966b.1
        for <syzbot@lists.linux.dev>; Fri, 18 Sep 2026 07:30:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789741805; x=1790346605; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=4LINpU9xiNe/f5cDC3p+tq+n3huMFB+FIoM0QdGtcYI=;
        b=NoKuIBunazVg6ll4LBV7j2REC/lhAUIy2Yf2kxo39O7ggXnNRrI1erhwLh9Po3AhY8
         IAqREVIvUCo4nmuchvzX0jML85bFIyALs+4e1txhAF7tlwpGz0xSoFcFLWr7d5rkD4D9
         IJ7djmHklShSdR39l5HtrpiwwYg/lXN/JK/EJ7Q2y6SRl38ojyWAOQiGpvfGn8Tg4cRp
         xXNDqRXJZPxYzwXy75ek7p4iyUdM/qQ+5H8xfpfYZXAQIDUS28zQ6cRO7+TGdK31x4sw
         +Tcpe2Z/tAgUN4Zs3rSmvrJMEv+uIdqU7aUcXE8MRRLXe37rUK1pVnzUoLE3K19gm7u7
         OBDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789741805; x=1790346605;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=4LINpU9xiNe/f5cDC3p+tq+n3huMFB+FIoM0QdGtcYI=;
        b=UZcrNt2CSNyIPPSlXtY0DmUAVzrHVoreu/VjZzf60GnJCQTIAS6i16JP4HpMZSeri4
         8rcK+uDZLFb+P3ypTxSUy+rXWrK/H9SctsReDmGfEdvQnKjUijQqBU7sdfBRC+ELLWdw
         oNeMnWBv5StJKdVMnhFtVmF9qtlhoncal8TxxmQIiiVngCARpqMqySEhBN5LEvWGjSUN
         YR1V3HsX2tcqsRwaz8p7cLmZQ0y1Gb8CbW6YIGvdrW7Up4GV7NdODmwr71PHRn5/DfKV
         i7ff0/ubxedqf0ub1T4LQoTDjAgsjWh/9NyzkKbwZdSKPdym/kOjSerskefBGZgjYIRv
         HMMg==
X-Gm-Message-State: AFuF++n4DZqknx5Y2wRQENT4E16k8DmCDWnfIQ9DqpjMK2d7LJompBkI
	i76rwtOuE+5C4x7hq9Q5YIMAubmfqWJZP4KIshdpcpXeKnvx1S2yryLr
X-Gm-Gg: AYBFou22I8i9Elb8enlOPx0/jFl0CQ1X8qUopeMWlhK38RU3iSiaLYjeEYzefwINM1c
	Dgz4Kj79n9Z5Q+YtJPf+b56g5oCrxcLDxsERYJ9FtslgvKLKcvbhiBJBJfxvBGMIRTVeuKv3CZz
	G3OpLXwcG/ght9r3uPQRp64M+AKAU0YqDa0IAgaslSRPWSnye8DDlwRigldtvNLUmOkQVZjpWsK
	hoM1s8wlwKxKX8pWZmO2MKHMdSUJpaEDphMaxpSYg45VjtRkDfOYehZO3z0fv5X3NdME9rvsMcU
	kbFJVDTJkL74AQamrXdwUj4kw38io28yYes8cxkhmV4phvda+cOcnZ8XPumbblwJcIgNcA36qXL
	ySVGN26kq/9fAFNaS3bvl5prhCZanLb06vWSms0M8XLcctXlbJ4ljHH53H7dRb0hBbgYtIwz5LO
	FZ4zUuQ87ngDdM5Yu4tSWAtftWjqYZWaaOZRiBk7VatbkpUJ+V4WGd6UMPczPwMQihaizBOd0P5
	2cvGysAgtmtmiTuWXmC8bNI2WwunZzCvG2/Nrw2lljZ7stp5CBiiDYzuhI4ywMrwrl9qLNg6sTh
	FUiZBWUuSAchWE4Y+LLxVDT96QKyWdjdzDoFgZIXbiSCgNQZJzJOHFXrj52q/d9+Ul5e1/kHJgu
	lHeKyjZ+ReqxxXPaAu/IVrOu1bEC+YDWjM4ZZlpxZswb4Ag==
X-Received: by 2002:a17:907:9711:b0:c29:5172:6151 with SMTP id a640c23a62f3a-c2a15878d94mr246294666b.45.1789741804716;
        Fri, 18 Sep 2026 07:30:04 -0700 (PDT)
Received: from [192.168.100.51] (87-205-15-91.static.ip.netia.com.pl. [87.205.15.91])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c2a1bc34bdfsm62951866b.63.2026.09.18.07.30.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Sep 2026 07:30:04 -0700 (PDT)
Message-ID: <694d554b-3028-419e-bb95-74d7059e2ed8@gmail.com>
Date: Fri, 18 Sep 2026 16:30:03 +0200
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v2] ring-buffer: Fix false warning in
 ring_buffer_map_get_reader()
To: syzbot <syzbot@kernel.org>, syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
References: <a7bc965a-10e4-40c3-974d-189a69fbb56f@mail.kernel.org>
Content-Language: en-US
From: Krystian Kaniewski <krystianmkaniewski@gmail.com>
In-Reply-To: <a7bc965a-10e4-40c3-974d-189a69fbb56f@mail.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

#syz upstream

On 9/9/2026 4:07 PM, syzbot wrote:
> In ring_buffer_map_get_reader(), an unconditional WARN_ON(!reader) is
> triggered when rb_get_reader_page() returns NULL:
>
> WARNING: CPU: 1 PID: 5906 at kernel/trace/ring_buffer.c:7998
> ring_buffer_map_get_reader+0x940/0x9d0
> CPU: 1 UID: 0 PID: 5906 Comm: task Not tainted
> RIP: 0010:ring_buffer_map_get_reader+0x940/0x9d0
> kernel/trace/ring_buffer.c:7998
> Call Trace:
>   <TASK>
>   tracing_buffers_ioctl+0x258/0x300 kernel/trace/trace.c:7381
>   __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
>   do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
>   entry_SYSCALL_64_after_hwframe+0x77/0x7f
>   </TASK>
>
> This warning is triggered due to a race between a writer committing events
> and a reader mapping the ring buffer via TRACE_MMAP_IOCTL_GET_READER. When
> a writer commits an event in rb_set_commit_to_write(), it advances
> cpu_buffer->commit_page to cpu_buffer->tail_page in its first loop before
> updating the commit counter (commit_page->page->commit) in the second loop.
> If a reader invokes ring_buffer_map_get_reader() at this moment, the
> initial check cpu_buffer->reader_page == cpu_buffer->commit_page is false,
> and it calls rb_get_reader_page(). Inside __rb_get_reader_page(), the
> reader swaps reader_page with the head page (which is the new commit_page).
> Because the writer has not yet updated the commit count on the new page,
> rb_page_size() is zero and reader_page->read < rb_page_size() evaluates to
> false. __rb_get_reader_page() then checks if cpu_buffer->commit_page ==
> cpu_buffer->reader_page. Since both now point to the swapped page, the
> condition evaluates to true and rb_get_reader_page() legitimately returns
> NULL to indicate the reader caught up to the writer.
>
> Furthermore, rb_get_reader_page() can legitimately return NULL when there
> is no data to read. Re-checking mutable writer state such as
> cpu_buffer->reader_page != cpu_buffer->commit_page is insufficient because
> a writer on another CPU can advance commit_page before the check is
> evaluated without being stopped by reader_lock.
>
> Because WARN_ON must not be used for conditions that can legitimately
> happen, and pr_err should be used instead if necessary, remove the
> WARN_ON() entirely since returning NULL here is an expected condition.
>
> Fixes: 117c39200d9d ("ring-buffer: Introducing ring-buffer mapping functions")
> Assisted-by: Gemini:gemini-3.8-flash syzbot
> Reported-by: syzbot+de3d7f9bcc9212f3fae1@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=de3d7f9bcc9212f3fae1
> Link: https://syzkaller.appspot.com/ai_job?id=488adc18-a10e-42d2-a205-25327c38837f
> To: <linux-trace-kernel@vger.kernel.org>
> To: "Masami Hiramatsu" <mhiramat@kernel.org>
> To: "Steven Rostedt" <rostedt@goodmis.org>
> To: "Vincent Donnefort" <vdonnefort@google.com>
> Cc: <linux-kernel@vger.kernel.org>
> Cc: "Mathieu Desnoyers" <mathieu.desnoyers@efficios.com>
>
> ---
> v2:
> - Remove the WARN_ON() check entirely instead of conditionally checking writer state.
> - Update the commit description to explain why re-checking commit_page is insufficient.
>
> v1:
> https://lore.kernel.org/all/97fb4855-693b-429f-9e75-b4c2a0348ef0@mail.kernel.org/T/
> ---
> diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
> index 9c03a555a..1a4da3d47 100644
> --- a/kernel/trace/ring_buffer.c
> +++ b/kernel/trace/ring_buffer.c
> @@ -7995,7 +7995,7 @@ int ring_buffer_map_get_reader(struct trace_buffer *buffer, int cpu)
>   		goto out;
>   
>   	reader = rb_get_reader_page(cpu_buffer);
> -	if (WARN_ON(!reader))
> +	if (!reader)
>   		goto out;
>   
>   	/* Check if any events were dropped */
>
>
> base-commit: df2908090cda368b01ff43709f51890076c56157
