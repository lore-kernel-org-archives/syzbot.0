Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7401C4A68B0
	for <syzbot@lists.linux.dev>; Mon, 21 Sep 2026 15:12:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=100.103.45.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790003562; cv=pass; b=fKXxfoTzgja8DIdMxNh/ungKbf213vkNhCfGmh9q3piWdd432ugB/hGi9e4veyOXQJ2l/FHlbu8h5O4UNB2BfTPaMWpTOJFIdHxTDllunM4mICAheRSYw+6VWP3WIoHY3EyG1fMfi97HFwtkrzo2zAF7NK3AbWV4okoBEi0hOAI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790003562; c=relaxed/simple;
	bh=L1k9f7vkeT52DG7Y+OjdDgIYQ2gAK8//N6IDgUdTzzc=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kRkyWpvgY7bE0N1pKQvnAWlMTQ6onv5hFA1BlIcC71AoXU0VDusO0bYdBXVvh8VfuZBxbi/6JHTozfPG027800NHoDk/fQxp60G27xiROrLFzmZKiPHRuZ4IStPSxuGFU15zBdoTe4XKhC00xMEzyMvcLmi/yszmTQzNhcePrJA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=goodmis.org header.i=@goodmis.org header.b=5Px6qTLE; arc=pass smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=goodmis.org header.i=@goodmis.org header.b="5Px6qTLE"
Received: by smtp.kernel.org (Postfix)
	id 470DD1F00893; Mon, 21 Sep 2026 15:12:41 +0000 (UTC)
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=216.40.44.10
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1790003561;
	b=0C+HPCU/+G7t4xkBrnzed3gyYjj1amhmTxOURuRhxwjPRxA96THkGhsl/xRhiNI9vcpf
	 UQvRsOYDuc1AkgSd6PQn5DUVakB/8eww3aCeNPcWfPUPgCgtEFVFaxzHaK4NdBlyxwmvF
	 9OblqQxIwK0uBi4EZ7nT9V/CshMWfAemCnShZPsAm0CZo+fdcmHYFyLG2N4wRCmCAICOK
	 vd1BOagAH8grHnkKpw8EqLqkUrSXLwtoXeDlrH/o56167f6XxqURp4mTrJZuhzLojOBAU
	 t2dltvtZ7RIr+OjD666sCdHYDpF4XewyX99ltXtCZv7mMWP6Wjc6K42DGisl7J1f67A==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1790003561;
	h=DMARC-Filter:Received:Received:Date:From:To:Cc:Subject:Message-ID:
	 In-Reply-To:References:X-Mailer:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:X-Rspamd-Queue-Id:X-Stat-Signature:
	 X-Spam-Status:X-Rspamd-Server:X-Session-Marker:X-Session-ID:
	 DKIM-Signature:X-HE-Tag:X-HE-Meta;
	bh=8f4T7+Damq2l2zK/FtKO3n2t+I4EG3XWjXxLgMJAFZA=;
	b=UyPaE8Mp4yvvFQz82yfH7YicT2LFNRGVJET+PjlvrqsrqNHJKcNE/qwlGPPytZAjIIzH
	 eIAteDefGS9LGidMpN/voJohUj8EEQnm6dEmI/lLcnR6HVSG/h/1GibRTm+RpXWY5Ue3Z
	 uVSrkM1PkSX/hRe8YMXqxoTTgTtBksmrUUIaw60xxEJfZUOxkwTaBKIkixaFuMhi4WuqU
	 GXmWrftevHlUt1PB0RMmtTIR44G2ls3F4QR/kJcwNwGgSQOUYVboB5oFtxSsAN+ls1vGA
	 EWm7KKT/XTfBjKL0PGxRoxdXXa1YWERnOBS65sHFD0pazcxbOurKS8nyScdf+eVuimA==
ARC-Authentication-Results: i=1; smtp.kernel.org; dkim=pass header.d=goodmis.org header.i=@goodmis.org header.a=rsa-sha256 header.s=dkim1 header.b=5Px6qTLE;
	dmarc=pass header.from=goodmis.org;
	spf=pass smtp.mailfrom=goodmis.org;
	arc=none smtp.remote-ip=216.40.44.10
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id ED8BA1F000FF;
	Mon, 21 Sep 2026 15:12:39 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=goodmis.org header.i=@goodmis.org header.a=rsa-sha256 header.s=dkim1 header.b=5Px6qTLE
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.kernel.org ED8BA1F000FF
Authentication-Results: smtp.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id EF92CA01A8;
	Mon, 21 Sep 2026 15:12:37 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf12.hostedemail.com (Postfix) with ESMTPA id 00D2C19;
	Mon, 21 Sep 2026 15:12:34 +0000 (UTC)
Date: Mon, 21 Sep 2026 11:12:30 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "syzbot" <syzbot@kernel.org>
Cc: syzkaller-bugs@googlegroups.com, Krystian Kaniewski
 <krystianmkaniewski@gmail.com>, <linux-trace-kernel@vger.kernel.org>,
 "Masami Hiramatsu" <mhiramat@kernel.org>, "Vincent Donnefort"
 <vdonnefort@google.com>, linux-kernel@vger.kernel.org,
 mathieu.desnoyers@efficios.com, syzbot@lists.linux.dev
Subject: Re: [PATCH] ring-buffer: Fix false warning in
 ring_buffer_map_get_reader()
Message-ID: <20260921111230.14e63f21@fedora>
In-Reply-To: <15bc282f-669e-4a94-911d-bb435513461f@mail.kernel.org>
References: <15bc282f-669e-4a94-911d-bb435513461f@mail.kernel.org>
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.52; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 00D2C19
X-Stat-Signature: 93nwfsx97nnh3u3cugw3kp5f6tumi7xa
X-Rspamd-Server: rspamout07
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1/bdBg0U17YeAEOXfPAURYXfcHu+dLRz08=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=goodmis.org; h=date:from:to:cc:subject:message-id:in-reply-to:references:mime-version:content-type:content-transfer-encoding; s=dkim1; bh=8f4T7+Damq2l2zK/FtKO3n2t+I4EG3XWjXxLgMJAFZA=; b=5Px6qTLEZfQPt5FWsc5kAkIs6IcUSnqmGmBkvdVbZJQfF3m/FeFdsike29nhK13yuDqczn0brUZSqqVX48sDmZ7H8xXWSxSvOeGKdZP3nIt4cmAxwUxf2+t6hVIqMaFkB++Ld9oxCXSd77B9aJpHpCA0MGf7RvCLxq6f21m4BPw=
X-HE-Tag: 1790003554-467562
X-HE-Meta: U2FsdGVkX19dVyJzjnbIFVA7COY5xjnLgZIqCNfpbKyS+GXJ5H8+V/E75bmr5sw3YoExrsltt8qRuOFRwkfLoCXP6j1bCwoZRj2D7DQ92hbn5JWaGk+FDFt5cnLdvLlJ062q+STKVfYhe3yOCytgl0CvBKfHMP1T01DQ1jin/ks+10iVhYSaso8b4g2j47F9ian/Gqj03nc4DmZsY9T4RCH2Owl0NEdqJ+lb767A2/EmvpDDXgwWGon1ZB5Nvj91sK0LZdUQFJ7D5iHchEnRoV8OCIdo51akmJirA5l5XCj0n+P93t3TIj7yLD3YhG4C0+dj6gnN6K35WUYG/n1/IEXx01TSQ3FxSxh9qndTDq75ew1WLxwoY8svS+XysOkGdx5l04PYRFJyoHNxKQ0m87FDbMHN+KuyTlSRJ29besMNP0goT/IHCYtU8GY3p56PYWf0h3VLHVBjytqTj1B7CkaCnAmooNpl5t4/0lKlYSc=

On Fri, 18 Sep 2026 14:34:25 +0000 (UTC)
"syzbot" <syzbot@kernel.org> wrote:

> From: Krystian Kaniewski <krystianmkaniewski@gmail.com>
> 
> In ring_buffer_map_get_reader(), an unconditional WARN_ON(!reader) is
> triggered when rb_get_reader_page() returns NULL:
> 
> WARNING: CPU: 1 PID: 5906 at kernel/trace/ring_buffer.c:7998
> ring_buffer_map_get_reader+0x940/0x9d0
> CPU: 1 UID: 0 PID: 5906 Comm: task Not tainted
> RIP: 0010:ring_buffer_map_get_reader+0x940/0x9d0
> kernel/trace/ring_buffer.c:7998
> Call Trace:
>  <TASK>
>  tracing_buffers_ioctl+0x258/0x300 kernel/trace/trace.c:7381
>  __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
>  do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>  </TASK>
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

The above looks like AI output. Please summarize the issue in a human
readable format. The above is not acceptable as a change log.

> 
> Furthermore, rb_get_reader_page() can legitimately return NULL when there
> is no data to read. Re-checking mutable writer state such as
> cpu_buffer->reader_page != cpu_buffer->commit_page is insufficient because
> a writer on another CPU can advance commit_page before the check is
> evaluated without being stopped by reader_lock.

The above can use some loving too.

-- Steve

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
> Signed-off-by: Krystian Kaniewski <krystianmkaniewski@gmail.com>
> 
