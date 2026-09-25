Received: from mail-dy2-f12.google.com (mail-dy2-f12.google.com [74.125.229.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97339303A37
	for <syzbot@lists.linux.dev>; Fri, 25 Sep 2026 09:25:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.229.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790328343; cv=pass; b=KL5+/mholcSR2qKSwIWtbiBAOI0MA9Ii1fs/3FxmWIGk1AgTZ6q8cUVSvkFizuggHUPaWWNLQLWKW8uiJ/adPq3BRlx9atgB5NeTvJ8HbT1DjRkEkT2lVjyvMZAOLjjt/UO5hSvUzSmgeUpuW5mkvFssRcT5gDcrvE/GFXwz7CM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790328343; c=relaxed/simple;
	bh=/iQRL/kO7F8tg4q1nSOmaw6U8D8aOQPxBhSYrk+Cenc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Qjl7DCjWn7LOmCWRAI4VYweeXmTAzGrXicaUMSOXWefdgNxHFNReRIQyJ5HRsjR7fxLMhZYj9gOHVAJ6OfoIaUM8Y89wkAvxWyxaQLlprpxt6f8v1XKFWVqXNqdq06jHlfJfQthqNDMq0YHBkUyBtfqkYBxoahir2ea0CcnBGJE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=rdzSCJSl; arc=pass smtp.client-ip=74.125.229.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rdzSCJSl"
Received: by mail-dy2-f12.google.com with SMTP id 5a478bee46e88-32dbbe82e13so540146eec.0
        for <syzbot@lists.linux.dev>; Fri, 25 Sep 2026 02:25:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790328339; cv=none;
        d=google.com; s=arc-20260327;
        b=ExbFtthq7nU478YSF6/Te4FGYs/DCyZ62//uLVUD0uRg4Oxt34rnxue64XKtIaLigf
         4OeSfFfNGmhnfFTZKV8/dgXpLCMHak0OHZqyDAzug6PNl03HsE8jZCA3paYLPrVZ0vk4
         xffiqRHNTk4IBnsxymIIGQYdNWnXOeIKf9cE4ZRtCTIo2Ab0QkzwW7txe8eqDHSEIBs0
         2dwWqdiESQBUTWxA+GmJ1H7WLXWVk2U1nXas0YqPUJ2+q0MHDbA4KDUQm/TZVklSl6ue
         GrIoo4tTWW7I7QFRzwbajoUW8ju5Ve24tVPCSSrgYp+6tFeHdoOYgVWNRB0uFxgbHhLp
         Drnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=TEFDqKFCuBcZVH+pYiLp3oOwpErSQJFP5Bj8gcJnWyo=;
        fh=AV6UsZiEEbWi+MAflVTmxJfHJEaIay6MVN6y+xvYdTI=;
        b=W0of+eiKqKzMZvalHNwFZesRGv7xLrh8KeL3HeafbqCo0D8T8XFTwSjppTrdnIFZUV
         +PsgYS00W7S21U9avfXOGRFQcQPAZaQNM4ue8ZummX0mRaG1cr+5W70ebQ1DoJYgLfwS
         rScL4Acxh446YTlLsy924VboD/3/Vh5vB64uuNF/g26rqVWAzfbp3uD88nqJANznWpeE
         7NxeL706T7zXe3AEKDS3WFKl7QfhQ/3nptWohz0Cgng6cvYqH5FW5nKS5hOYIW8bfJnI
         Ij1NmTqteJaSqQJ7Xb79MFPDjaM5gaKXetpBdsuwRv3drzqA/azMfrHx80AxN1P7lqp8
         0pWQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790328339; x=1790933139; darn=lists.linux.dev;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=TEFDqKFCuBcZVH+pYiLp3oOwpErSQJFP5Bj8gcJnWyo=;
        b=rdzSCJSlGzPuyYGgwtrf2LyK0sjQlgFENLqpet9nWHK+RwDa8QwKOQNH9M/URQSmnk
         nB89K9ftmAbnwrYlOV4ML65/qIAYCl55iRe9RTMENCT4h62k73g8eEeFW3c7mSpQNGDR
         abHu/p/wvh4cHrfkAxshmDJ0ZAsxRTcRGRpD9dj3cO+mXgqtnf5RjbPds+nCjJfQTZIY
         dpxSayQEAkt5BDdfp/KZQFhwJ8lrMU7MwYFkwgxeyun9dkSo2V90SQHd8KtpZ+V4FKq7
         rhn5yTTCGPKrmQZ2JnwK55bcjE9rpEdkmPZIdMGKDl5a5uNMWeC1UswIwcmzemWtXUAY
         l52g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790328339; x=1790933139;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=TEFDqKFCuBcZVH+pYiLp3oOwpErSQJFP5Bj8gcJnWyo=;
        b=vnZxnE33nvHK4upQ8AQmMSRhwfsYpt0mv90o3f8UG9ddlCQYcrhNZGtuwDuDXqimVl
         zWhmPwpZsA364R9FMmM7lR2g4x7j2IGUXMpqLyJeg/W9sh7k7xi6jsnpmPpGnobJmE3l
         cmxKOuMLGFLPh8knGZcl93RsDNB7/wqAVhNt6TbZtp5M8sMPvunFjZh1+/P1yZ0O57SP
         V0lm8Sr0Vtuqg21msQjAiwzLILeJ/4HPqby0BUOZ3zWvtS7Z5U1HjDK0BQsQwLxMxAt4
         M/uYwk5WGeZGLWAsb+xBt40GN4/bjYYj7mnSyJ0k+CYG24EVDr1czkGx+xMarvpzPTOe
         ZXtQ==
X-Forwarded-Encrypted: i=1; AKwUvBwsG2CAXetAGOsgzewTpc2pz6lSqk+WDbn7OdNIRJfxW7k4oIRxJAtVFywvxS+G6FxNO1nc0Is=@lists.linux.dev
X-Gm-Message-State: AFuF++k+/2dSioSJyPh+/xpDSoEX7b3Yg/1WKoda8K5PZ4mbi7fNKD1O
	uCzNOw97ZCraPzCWCxb29n2/l29HFYlWDp6o8O9HIPWZzxTWFqQX24KBUUYKSy2cC86bmSFqnCv
	NuROfoQIdmwbK+8DpwWcyfD++DGDuXru78RiNXKZxyxzuvsxvJZD7KUPhGa4=
X-Gm-Gg: AYBFou2K81Eh2kfkwfGXnUIbU5KmQ/Y467XkqkXuRF65kA8UAsqO3dypmSuqGnPMOK3
	hKGxpqNshKWuk741JMUHz71ZbKIpnQbJK6Xhm4Hb02B2uQNZwbcYvPqPef8HwHxGeAoS43dTNKh
	1cgoVRbJ0nV7WU+h+fBNgRRWNfYreWHGCxCF2gRUBrd2s6vKdltDdpcxnHG4GK+AJbSodJBgDDg
	3hmULSj4WgKV9nPYP65OJFBT4cCjfBhgDLYUyWomhxljqE8PyFixAY+W1BbeY4OEQc19NCsuvVU
	QFmL2GOcbNVlKYiBPw+SsrDsfHN0OzztZSg+vctoQoCc641KW18kl9rCUfVlPqfFFiT8QBHBQvW
	G4SOaN8XZD32QV3L05Jh7
X-Received: by 2002:a05:7022:3b0c:b0:143:761a:863e with SMTP id
 a92af1059eb24-145040d406amr5952725c88.44.1790328337617; Fri, 25 Sep 2026
 02:25:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <1a25e233-381b-4a90-9a62-da0a6968b575@mail.kernel.org>
In-Reply-To: <1a25e233-381b-4a90-9a62-da0a6968b575@mail.kernel.org>
From: Marco Elver <elver@google.com>
Date: Fri, 25 Sep 2026 11:25:01 +0200
X-Gm-Features: AclHuK8GnKJAOZrVZRHJzRmKBo8xvL3fi7hSVIVv-BGTLldQmC3ACHGTeCpiv7E
Message-ID: <CANpmjNOrDg9HWZcR3Ro_Jkr=43Ks9c9JjQyjG1Vk-tFABaaeng@mail.gmail.com>
Subject: Re: [PATCH RFC] SUNRPC: Use TASK_FREEZABLE_UNSAFE in __rpc_execute()
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

#syz upstream

On Thu, 24 Sept 2026 at 09:18, 'syzbot' via
syzkaller-upstream-moderation
<syzkaller-upstream-moderation@googlegroups.com> wrote:
>
> When a task executes a synchronous RPC call via __rpc_execute(), it waits
> for the queued RPC task to wake up using out_of_line_wait_on_bit(). Callers
> in subsystems such as NFS or NFSD (for example, write_ports() acquiring
> nfsd_mutex during NFS server initialization and issuing an rpc_ping())
> frequently hold locks across these synchronous RPC waits.
>
> Historically, rpc_wait_bit_killable() invoked freezable_schedule_unsafe(),
> which explicitly bypassed lockdep checks for held locks during freeze.
> However, during the core freezer refactoring in commit f5d39b020809
> ("freezer,sched: Rewrite core freezer logic"), freezable_schedule_unsafe()
> was removed, and callers were updated to pass freezer flags directly into
> out_of_line_wait_on_bit(). While rpc_wait_for_completion_task() was
> correctly updated to use TASK_KILLABLE | TASK_FREEZABLE_UNSAFE,
> __rpc_execute() was mistakenly updated to use TASK_KILLABLE |
> TASK_FREEZABLE without the unsafe flag.
>
> As a result, if a system suspend occurs concurrently while a task is
> waiting in __rpc_execute() with a lock held, __set_task_frozen() observes
> p->lockdep_depth > 0 without __TASK_FREEZABLE_UNSAFE and triggers a lockdep
> warning:
>
> WARNING: kernel/freezer.c:139 at __set_task_frozen+0x260/0x340
> Call Trace:
>  <TASK>
>  task_call_func+0x1aa/0x260 kernel/sched/core.c:4518
>  __freeze_task kernel/freezer.c:150 [inline]
>  freeze_task+0x216/0x390 kernel/freezer.c:169
>  try_to_freeze_tasks+0x190/0x620 kernel/power/process.c:54
>  freeze_processes+0xd0/0x1f0 kernel/power/process.c:137
>  suspend_prepare kernel/power/suspend.c:387 [inline]
>  enter_state kernel/power/suspend.c:609 [inline]
>  pm_suspend+0x2f1/0x760 kernel/power/suspend.c:644
>  state_store+0x206/0x290 kernel/power/main.c:819
>  kernfs_fop_write_iter+0x3a5/0x540 fs/kernfs/file.c:345
>  vfs_write+0x61e/0xbb0 fs/read_write.c:687
>  ksys_write+0x156/0x270 fs/read_write.c:739
>  do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>  </TASK>
>
> Update __rpc_execute() to pass TASK_KILLABLE | TASK_FREEZABLE_UNSAFE to
> out_of_line_wait_on_bit(). This restores the pre-regression behavior and
> aligns __rpc_execute() with rpc_wait_for_completion_task(), avoiding the
> false-positive lockdep warning when tasks holding locks are frozen during
> synchronous RPC execution.
>
> Fixes: f5d39b020809 ("freezer,sched: Rewrite core freezer logic")
> Assisted-by: Gemini:gemini-3.8-flash Gemini:gemini-3.1-pro-preview syzbot
> Reported-by: syzbot+209eccd8f507de9f7f1b@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=209eccd8f507de9f7f1b
> Link: https://syzkaller.appspot.com/ai_job?id=cb10c20b-f568-4900-8b09-dc937852ee3f
> To: "Anna Schumaker" <anna@kernel.org>
> To: "Chuck Lever" <cel@kernel.org>
> To: "David S. Miller" <davem@davemloft.net>
> To: "Eric Dumazet" <edumazet@google.com>
> To: "Jeff Layton" <jlayton@kernel.org>
> To: "Jakub Kicinski" <kuba@kernel.org>
> To: <linux-nfs@vger.kernel.org>
> To: <netdev@vger.kernel.org>
> To: "Paolo Abeni" <pabeni@redhat.com>
> To: "Trond Myklebust" <trondmy@kernel.org>
> To: "Peter Zijlstra" <peterz@infradead.org>
> Cc: "Dai Ngo" <Dai.Ngo@oracle.com>
> Cc: "Simon Horman" <horms@kernel.org>
> Cc: <linux-kernel@vger.kernel.org>
> Cc: "NeilBrown" <neil@brown.name>
> Cc: "Olga Kornievskaia" <okorniev@redhat.com>
> Cc: "Tom Talpey" <tom@talpey.com>
>
> ---
> diff --git a/net/sunrpc/sched.c b/net/sunrpc/sched.c
> index 016f16ca5..494947d50 100644
> --- a/net/sunrpc/sched.c
> +++ b/net/sunrpc/sched.c
> @@ -984,7 +984,7 @@ static void __rpc_execute(struct rpc_task *task)
>                 trace_rpc_task_sync_sleep(task, task->tk_action);
>                 status = out_of_line_wait_on_bit(&task->tk_runstate,
>                                 RPC_TASK_QUEUED, rpc_wait_bit_killable,
> -                               TASK_KILLABLE|TASK_FREEZABLE);
> +                               TASK_KILLABLE | TASK_FREEZABLE_UNSAFE);
>                 if (status < 0) {
>                         /*
>                          * When a sync task receives a signal, it exits with
>
>
> base-commit: 93f51579e7df248780214094418f205253383cc5
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
>
> --
> You received this message because you are subscribed to the Google Groups "syzkaller-upstream-moderation" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to syzkaller-upstream-moderation+unsubscribe@googlegroups.com.
> To view this discussion visit https://groups.google.com/d/msgid/syzkaller-upstream-moderation/1a25e233-381b-4a90-9a62-da0a6968b575%40mail.kernel.org.
