Received: from mail-ed2-f41.google.com (mail-ed2-f41.google.com [74.125.228.105])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4277438488
	for <syzbot@lists.linux.dev>; Thu, 24 Sep 2026 09:06:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.105
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790240774; cv=none; b=pJoJIpcsq7CEZkQCp7IVxGhH0Z3ZGJt52Yp2yCx1l7wXEz99vk8uiDpkswFWepn66GqNes1CsREEW8Ie9ofYAH5+c05XTsQ8YWHRqstPDzvViQiMtPVkCPEZmayadOlmpq51T9rxDP0JmdCdlpcEEqkVx0GECyxaZODO7xqg1ww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790240774; c=relaxed/simple;
	bh=ok/KGrVby5oCPw7YHj3CExTD4NS8xQvn2lFiwSDUAFQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mwolmudfoFsOqnZS7JIQHfPWBJbgGsmWxsuDokF5jlw0EA7UqWe6jtOuMc+U65OlZWIp6GBdgX4FOmCRoX2bRNEbD3gqsHqIqMLqhoPnFOAGeHs5NinFNt8YxT9zFBNKgyeZeCtHd7xRP5lFlA3cT6UIyF5x2NPzd4PuSQHQis0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MBztdEB/; arc=none smtp.client-ip=74.125.228.105
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MBztdEB/"
Received: by mail-ed2-f41.google.com with SMTP id 4fb4d7f45d1cf-6a99391ffb2so3320228a12.0
        for <syzbot@lists.linux.dev>; Thu, 24 Sep 2026 02:06:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790240771; x=1790845571; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=FlRZg5cSdQ8+ctfQt6JigMOEPk3Cpgi5VtUV8uoBfp0=;
        b=MBztdEB/CSaM9OeBDfmrvXHsUFecpNF/V5T8mhxIL0+vi4ShQT3hwpjz7RZercd5VF
         oy1jYZCk0dDRzCRirEtHHbB0gfXD2u4CycbhwzQHM5k7DuE5MoWngTuaE7KfDXlXvb72
         fEE0+hx3eQz0V7QUzBt8L6NM5X0lfvB0ww2nqGj1hD5ZLhlJUdNlKOXG/ZuUjLMeA9Qd
         EBI4QkN24JGm2I1CXG4oeD0mqeCppBDybkMg9Oy7EJSBZgSAAqzOOVwEHfMAGRSpr+M3
         do1z64G4oPCWWJkhAptzhgDpbpqqAhP9aMzV2bikYqYkt/20aHikNtHon4URdwSf733I
         u0ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790240771; x=1790845571;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FlRZg5cSdQ8+ctfQt6JigMOEPk3Cpgi5VtUV8uoBfp0=;
        b=QU8JMsicIutMgJowvGcSY0tLiqsyPqHBr7zgZ5qqNQKaS2AMqaHjNStgVYPpdy1XD8
         SprbdZEX6hNdxbwkxq4XnK42La1kQUMm5iBuChYoZQd/s+1Swgq5mRQN1BnvTA1tu6Wm
         JwyBgHHXHB823xoJOq2HBaRLk2FwB4HpxPGzqd7BSKPV4C2rYLHzW3IpnvQ6Xt4zWD8w
         3E726tT8wchwHJvHZ0aYeze3mYr7lCuwUwwBTeCj/pbVd0PTqAUr85IanbLm4I0X9Osy
         RfIHYwQ03I1bTE1GpU4+0p9UYU/AlRpythOlIJSfpklG2z8twVZbbwDzZLgjJ+oNkRxJ
         89+w==
X-Forwarded-Encrypted: i=1; AKwUvBzWYAoCW6785l3YJu4jKGLTz/uH3PHQiz36g4ewsHDXwSSTLl+uIar5fcC4i2XsZO4cmBOb01A=@lists.linux.dev
X-Gm-Message-State: AFuF++lB+0G89awb84IykNCibSAPPIWLjoN6unUuDN+7blbobvB6yZly
	qc0Bxa5UK+D+iAjGJpyFGgBmkjAyy51qnvO/Ejni3sTzCmVwqZNWapfWRmLI1PTC1PrmsG0z7t4
	BJ9DKiQ==
X-Gm-Gg: AYBFou1VMzBQkxA3VFf/IfdHfFi8vtgRsAMGdpMtT0/QJIgcl9YLXuNISMgvmDlQXvK
	8pqXxRS5FU4NKymGmEppjTaQ3KvjYN5yj8NVYlgOsNpQ3E8/pydC7fNxS7N6ntsfog9wvwdRWYP
	i/dXJI16R+07iblVOme0EvHSqn5GI5tNzlvO3EFtuZJlO6AbBAuLTLsn/MDqVgPSDQZMxKmxEk4
	/w0PB+m+5gvZo4i9jjmgVkoSK8ntwNQPDUL+mcwC12+2umaslRU+p4vX/wjEPz1h4ndXDKAmuKO
	M15madYxPzntR2wEP5yrwq0CvzHeyASF6UwrqUaHGfCzeZTdS6czqA2RnWgbHVyiSsvU9hkf9hf
	msXvYBKAOLd3RW26PkAswMQwD0MFOwd0zNc4mo7juznmk7nuuD8j67BAUSOk2GBmVKqgJLVusXQ
	TLjw+HBH7p00plEphuSWlSzY+h3dmw1taJfD+LOG4ER0FS54DB5sW6nHIwPwH4y3eVIgMvPV0Dc
	xZO7zBVaPaT/80H9WmdX/5wrdDeiWtlV9VfKbnKWdI=
X-Received: by 2002:a17:907:9445:b0:c29:386c:58f2 with SMTP id a640c23a62f3a-c2ac232a3cfmr154324966b.38.1790240768840;
        Thu, 24 Sep 2026 02:06:08 -0700 (PDT)
Received: from google.com (135.91.155.104.bc.googleusercontent.com. [104.155.91.135])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4886876c417sm12388713f8f.18.2026.09.24.02.06.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Sep 2026 02:06:08 -0700 (PDT)
Date: Thu, 24 Sep 2026 10:06:04 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: Krystian Kaniewski <krystianmkaniewski@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	linux-trace-kernel@vger.kernel.org,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
	syzbot@lists.linux.dev,
	syzbot+de3d7f9bcc9212f3fae1@syzkaller.appspotmail.com
Subject: Re: [PATCH v2] ring-buffer: Fix false warning in
 ring_buffer_map_get_reader()
Message-ID: <arTnSXtsVHSomoAm@google.com>
References: <15bc282f-669e-4a94-911d-bb435513461f@mail.kernel.org>
 <20260924084946.20104-1-krystianmkaniewski@gmail.com>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260924084946.20104-1-krystianmkaniewski@gmail.com>

On Thu, Sep 24, 2026 at 10:49:42AM +0200, Krystian Kaniewski wrote:
> The mmap reader can warn when it catches up with a writer that is still
> committing events. rb_get_reader_page() returns NULL in this case, but
> ring_buffer_map_get_reader() treats that result as an error.
> 
> The initial rb_per_cpu_empty() check filters out an empty buffer, but it
> does not guarantee that the next reader page has committed data. Writers
> do not take reader_lock and can advance commit_page before publishing the
> committed length on the new page. rb_get_reader_page() can swap to that
> page, catch up with the writer and return NULL.
> 
> Handle NULL through the existing no-data exit without warning. Remove the
> caller's reader_page == commit_page check as well, since the reader-page
> helper already handles that case. The existing metadata update and return
> path remain in place.
> 
> Fixes: 117c39200d9d ("ring-buffer: Introducing ring-buffer mapping functions")
> Assisted-by: Gemini:gemini-3.8-flash syzbot
> Reported-by: syzbot+de3d7f9bcc9212f3fae1@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=de3d7f9bcc9212f3fae1
> Link: https://syzkaller.appspot.com/ai_job?id=488adc18-a10e-42d2-a205-25327c38837f
> Signed-off-by: Krystian Kaniewski <krystianmkaniewski@gmail.com>
> ---
> Changes since v1:
> - Rewrite the commit message to explain the race more concisely.
> - Clarify why the earlier empty-buffer check does not exclude this case.
> - Remove the redundant reader_page == commit_page check, as discussed
>   with Vincent. Let rb_get_reader_page() handle the caught-up reader.
> 
> v1: https://lore.kernel.org/all/15bc282f-669e-4a94-911d-bb435513461f@mail.kernel.org/
> 
>  kernel/trace/ring_buffer.c | 6 +-----
>  1 file changed, 1 insertion(+), 5 deletions(-)
> 
> diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
> index 9c03a555a6ba..9222fc881bc2 100644
> --- a/kernel/trace/ring_buffer.c
> +++ b/kernel/trace/ring_buffer.c
> @@ -7990,12 +7990,8 @@ consume:
>  		goto out;
>  	}
>  
> -	/* Did the reader catch up with the writer? */
> -	if (cpu_buffer->reader_page == cpu_buffer->commit_page)
> -		goto out;
> -
>  	reader = rb_get_reader_page(cpu_buffer);
> -	if (WARN_ON(!reader))
> +	if (!reader)
>  		goto out;
>  
>  	/* Check if any events were dropped */
> 
> base-commit: df2908090cda368b01ff43709f51890076c56157
> -- 
> 2.53.0

Reviewed-by: Vincent Donnefort <vdonnefort@google.com>

