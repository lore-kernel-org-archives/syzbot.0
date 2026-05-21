Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 661B439EF12
	for <syzbot@lists.linux.dev>; Thu, 21 May 2026 12:22:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779366170; cv=none; b=eQTR1dc9MV7vsc8Cko+E26ktaSo2b6bAU+W0tpqJyfWr1QpGzJaai2LH+JKrg8ylG6mPceQGxRatrlWc6OH8tj38Cqq1PN0gvZg4iZxdwtEP1GCQTp7vup1ai7SGUTAW9GWK2vXWg3SHozi6nHxGsu/wyOoEgmPFavsWOdtn5is=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779366170; c=relaxed/simple;
	bh=qtE6dn7DB3SkDZG8WfGYhQIM8a9pJGLfjA2I2J0yrnY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=hlqeWaDHrpiK51PcKUpg/bOWw3vFagwcvXS0ZOqoSsgsW0fuHvYzTRdf67bOaEdLMvQaJo2fEmt9inOQZriqiUVfy1qbqYvsI6O2bRpJKN2UwwkPdWzzvVnUwqOl67df6WNZbRa1aa23a1saPqIu5kstjxZyoYDNU1n/JmY2q3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=H/pUqyfn; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="H/pUqyfn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779366168;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pJBK5b8rPtk32hxx1WF3NYiRezqPxfYWou6O69RlNSM=;
	b=H/pUqyfnfbGLfTKc0+lI/Qu1QrWBmSUf8nbualDpA1nYpuBAYWjlUcx+XWHUCkOFOuySPo
	hAOqqlr4fTwbP2SkcI5s3oBD8fKV+Q9TbXHt3cPr6v4kB6zxrTuDnq9KzUvfmQxKQdKRaL
	VGrQYW2Xcgabq2weyrEsFLnvBq3eXXE=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-662-xGFznZ_bPIqNGs1V7D5Oew-1; Thu,
 21 May 2026 08:22:41 -0400
X-MC-Unique: xGFznZ_bPIqNGs1V7D5Oew-1
X-Mimecast-MFC-AGG-ID: xGFznZ_bPIqNGs1V7D5Oew_1779366158
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5DF18180060D;
	Thu, 21 May 2026 12:22:37 +0000 (UTC)
Received: from fedora (unknown [10.44.48.45])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id 88F1B1800576;
	Thu, 21 May 2026 12:22:33 +0000 (UTC)
Received: by fedora (nbSMTP-1.00) for uid 1000
	oleg@redhat.com; Thu, 21 May 2026 14:22:37 +0200 (CEST)
Date: Thu, 21 May 2026 14:22:32 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-bugs@googlegroups.com, linux-kernel@vger.kernel.org,
	adrianhuang0701@gmail.com, akpm@linux-foundation.org,
	brauner@kernel.org, kexinsun@smail.nju.edu.cn, peterz@infradead.org,
	syzbot@lists.linux.dev, tglx@kernel.org
Subject: Re: [PATCH] signal: clear JOBCTL_PENDING_MASK for caller in
 zap_other_threads()
Message-ID: <ag75CP90p87ssRsI@redhat.com>
References: <36638f2b-6f91-4e33-b630-fd7045eebc84@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <36638f2b-6f91-4e33-b630-fd7045eebc84@mail.kernel.org>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-MFC-PROC-ID: JeQ0mzDgiz7ZDQ1pD22wr6TJFKugQuAqTB3NDja2LPs_1779366158
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 05/21, syzbot wrote:
>
> When a multi-threaded process receives a stop signal (e.g., SIGSTOP),
> do_signal_stop() sets JOBCTL_STOP_PENDING and JOBCTL_STOP_CONSUME on all
> threads and sets signal->group_stop_count to the number of threads. If
> one of the threads concurrently calls execve(), de_thread() invokes
> zap_other_threads() to kill all other threads. zap_other_threads()
> aborts the pending group stop by resetting signal->group_stop_count to 0
> and clears the JOBCTL_PENDING_MASK for all other threads. However, it
> fails to clear the job control flags for the calling thread.

Yes...

> --- a/kernel/signal.c
> +++ b/kernel/signal.c
> @@ -1338,6 +1338,7 @@ int zap_other_threads(struct task_struct *p)
>  	int count = 0;
>
>  	p->signal->group_stop_count = 0;
> +	task_clear_jobctl_pending(p, JOBCTL_PENDING_MASK);

OK, fair enough...

If we reset ->group_stop_count, we need to clear JOBCTL_PENDING_MASK for
every thread.

Acked-by: Oleg Nesterov <oleg@redhat.com>



-----------------------------------------------------------------------
But. It seems that we need more fixes (and more discussions) about the
SIGSTOP with exec race...

Oleg.

