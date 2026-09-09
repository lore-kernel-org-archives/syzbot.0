Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F048053B5FA
	for <syzbot@lists.linux.dev>; Wed,  9 Sep 2026 13:02:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788958937; cv=none; b=W9IkRm19/EovIgJC5Q/PMfsWHQj4b9pEUa/9ElrlInQywxcTOBdHE7m0s4nD5w0qjEJx009zUiCruzTSBEPOhCgKkuj6FQGvBLY0695x954q6p6I4ntXwWezbkTrrlbmV4386v0L4Q78EtDtjRjsb8Kh6TpEi0NkNgkocfCOFGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788958937; c=relaxed/simple;
	bh=PF0jVbUg7b288KYCT/aSyvlnR0fIi71VDbSob5pifyw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mK0V8j2ac3W+ugdX5Lqpv7qRVZ2tKwU/jNssv1QZzl9C5/efnuXJsom5NLBPGxq39Ils5kixiKffukfO8YXCUTSUuntC+ZSzDvvVADvOR/lXny4CCE2S5HfjnsGgOZ5cT51Y7HjU/4t2nSeSPcu0hIlriaABjhWQy1TBhh0hxjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Opy8bz1C; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Opy8bz1C"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-499ac87c92bso61807105e9.1
        for <syzbot@lists.linux.dev>; Wed, 09 Sep 2026 06:02:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788958934; x=1789563734; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=HFNcT3Ha1mAsWlFZVKVSSUkMG6wVx0xdkt68fH8TJxs=;
        b=Opy8bz1CJYmGWeTIavndtiXZBZJIxITvhaUEoyL9ZoNc6Y8t5E+wGCJ4LN4K6l1FD8
         RDlLwaIZbN6vO2krPpyqEp96bBT90RQy3stlWsGtoE7iiyI12luxhc3DGAeebf8c9Qsf
         47t4H6ed7EF2YmTe1Xbf2zC3fjZMXnVGZQAnrYwT7PaAvv42TNAj3uWWCevic0MfYq2W
         dwRw6rxTSrqxs/ZicLQsOd3321XU+sByuWM7QNP/H3/P/7j7VrZ+A7eVI5xcOKGA27mS
         98vlhfma/EkOs2Y30UEJIAicivF7fuUV57oHUfYistxAjjDO4XiA6mCg0ta7Me367Q2+
         0G8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788958934; x=1789563734;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=HFNcT3Ha1mAsWlFZVKVSSUkMG6wVx0xdkt68fH8TJxs=;
        b=dSjG+vUz8NyKzXqe20opgEnVcpJO8gw2+xMsj9Xg9fULebNQsIaTnGLIlk4RNIsqOO
         SQ5+2qRv8bbLfQ0+zJgpYuRg9RojngqUAPFu1YNPkB2kOs3e7tSBjLOOpqBcrnMn+m6b
         SE0Vh12p0zSr1t2jl1lz7bp1eqm6d19hHeS0mL9vmVuWVaYVcCChY5oighY/Wp8yKtvD
         A16v+ceV7pLlUpHePJnbWRULI6V9HvmbbZyJW9TE+WYAH5/T1TOoOLlLATuCVWPAxsRT
         CRDObYwdeiDKUmhg4WOJ8/TK4nSdCy30Eiu2US7vIxeu2dsyzj3NGNvMFIULe0my4uAL
         QLFw==
X-Gm-Message-State: AFuF++mvM5EiDpOUIuGXieZX6pqsJ4KmrXH7XOCCJT5WIBMWgqXDHwNM
	jYAEvFLdTZIijvgUgQK/FY215Q2KlePIqD8JXXmNLcGfK10m3V0U6k9saTeb+5bq
X-Gm-Gg: AYBFou1IIQc3rYfmlC9jrf5YYJNG+bSaMXqOCjzHTHBjbDoa3TjvUBEGpWYI2/8sN3G
	ZaBs6JPMCLSyNqLhKvxT2c0Vabfpg6xLTbsyKsIfGnjeM8iJwMDOnW0BkQ3ZQfxFife6IipC82J
	nGKyOj91yyYHm49dzJNJDxI8K5cF8vn+gurK1jjRKrV/CmUOjGur6NGyHSTqK32pWeO/4EjvmRM
	P6JVIhbWzwh7NjGthKT1IrYN+E8Law3RWqUoh4edXE+Oz7XuarnRWKPpSN19rf4F5i8PsaSh6Hs
	P9nq1QpzDDMDJ4mEbMmJ73vsS5hRQ8xUMrioJAdaULWKteJES8pJzitERB+Vdab7gg1M8zjzRDx
	Y8iqQMlRGhR8QKYJ2Qv8ERgqTonWKPub1yNqMOOFq1FB3b9AwG0HRziGeOWJ0S0nfnusavwt4iw
	aRvz9LbJJNdn3rW52yTviUhSV9R2IELgEdlEFipQy+IQh2Hg6fR3MYyHtOe3Sy+mT1ByvKdHMxY
	htfOjXn3KEv7Jw0yMKjBtzvvOvGgSHbPJwC8cqqRjXeH5e5b89K8akcw9USeFw/87XflBcQS9Gv
	LOpFwlwvvDy+LL8AFQgUrrEwxPQ2lgISKJak4wJGVb4qvf6fl9XykgiFOB9EPiplYA5JjtoI2i9
	yVpIJZOLfsHDrzofZdEZ/jwcFvvI80PXouxdZx8dSVLGVD0ZIW7W+BV0=
X-Received: by 2002:a05:600d:848e:20b0:495:4d88:e630 with SMTP id 5b1f17b1804b1-49cf824f697mr255387755e9.10.1788958933257;
        Wed, 09 Sep 2026 06:02:13 -0700 (PDT)
Received: from [192.168.100.51] (87-205-15-91.static.ip.netia.com.pl. [87.205.15.91])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49cee7fec25sm654067095e9.13.2026.09.09.06.02.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Sep 2026 06:02:10 -0700 (PDT)
Message-ID: <90ab5ac4-f303-41c1-8fb4-d35598194669@gmail.com>
Date: Wed, 9 Sep 2026 15:02:08 +0200
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC] ring-buffer: Fix false warning in
 ring_buffer_map_get_reader()
To: syzbot <syzbot@kernel.org>, syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
References: <97fb4855-693b-429f-9e75-b4c2a0348ef0@mail.kernel.org>
Content-Language: en-US
From: Krystian Kaniewski <krystianmkaniewski@gmail.com>
In-Reply-To: <97fb4855-693b-429f-9e75-b4c2a0348ef0@mail.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Remove the replacement WARN_ON(cpu_buffer->reader_page != 
cpu_buffer->commit_page) from the NULL-result branch in 
ring_buffer_map_get_reader(). Handle a NULL rb_get_reader_page() result 
through the existing out label without another assertion.

The helper can legitimately return NULL after the reader catches the 
commit page, but the writer can advance commit_page before the caller 
evaluates the new condition. reader_lock serializes readers and does not 
stop the writer on another CPU. The post-return equality is therefore 
not a valid invariant. The helper also supports ordinary no-data 
returns, as reflected by the existing peek and read-page callers. Keep 
structural diagnostics in the helper.

Preserve the existing early exits, metadata update, cache flush, lock 
release, return values and missed-event handling. Keep the valid 
explanation of the empty-commit-page case, and update the final fix 
description to explain the optional reader result and why rechecking 
mutable writer state is insufficient. Preserve the current Fixes and 
reporting tags and existing provenance.

On 9/8/2026 1:48 PM, syzbot wrote:
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
> Because WARN_ON must not be used for conditions that can legitimately
> happen, ring_buffer_map_get_reader() should not unconditionally warn when
> rb_get_reader_page() returns NULL. Fix this by only warning if
> rb_get_reader_page() returns NULL while cpu_buffer->reader_page !=
> cpu_buffer->commit_page.
>
> Fixes: 117c39200d9d ("ring-buffer: Introducing ring-buffer mapping functions")
> Assisted-by: Gemini:gemini-3.7-flash Gemini:gemini-3.1-pro-preview syzbot
> Reported-by: syzbot+de3d7f9bcc9212f3fae1@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=de3d7f9bcc9212f3fae1
> Link: https://syzkaller.appspot.com/ai_job?id=f119d7de-b21d-4d27-b61e-5503e31edccd
> To: <linux-trace-kernel@vger.kernel.org>
> To: "Masami Hiramatsu" <mhiramat@kernel.org>
> To: "Steven Rostedt" <rostedt@goodmis.org>
> To: "Vincent Donnefort" <vdonnefort@google.com>
> Cc: <linux-kernel@vger.kernel.org>
> Cc: "Mathieu Desnoyers" <mathieu.desnoyers@efficios.com>
>
> ---
> diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
> index 9c03a555a..98130182e 100644
> --- a/kernel/trace/ring_buffer.c
> +++ b/kernel/trace/ring_buffer.c
> @@ -7995,8 +7995,10 @@ int ring_buffer_map_get_reader(struct trace_buffer *buffer, int cpu)
>   		goto out;
>   
>   	reader = rb_get_reader_page(cpu_buffer);
> -	if (WARN_ON(!reader))
> +	if (!reader) {
> +		WARN_ON(cpu_buffer->reader_page != cpu_buffer->commit_page);
>   		goto out;
> +	}
>   
>   	/* Check if any events were dropped */
>   	missed_events = cpu_buffer->lost_events;
>
>
> base-commit: df2908090cda368b01ff43709f51890076c56157
