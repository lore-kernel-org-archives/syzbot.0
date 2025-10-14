Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7186C3101A5
	for <syzbot@lists.linux.dev>; Tue, 14 Oct 2025 11:46:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760442391; cv=none; b=JfcD/rZEsdmSFNyVEgHJpWEvTtQhbCLM0XfyGwnXeDIwozjLVUxDXC5tjp+j9SJ7CIFpncXfdlvNkRN2H8/YclVTNgW5bLcb7ZVoI8zxQeWuMA8F3+ebj2pQOF7oW6xhGhnGBkEDw3TAHNrcJo6BeHVUSSLOfRQeijXEsD76zvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760442391; c=relaxed/simple;
	bh=V97HSBuyCddwPX2eWiNiWvy6SrgdwsdzX5FKBWhIi1E=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=N2G0NCu+olxzE+dXuKcxXoUAJ/gdxAyw/623QtZ/cvzephSt1jtMsKMMrPUGWWSgpalvBV+V0Cq/gXCIBTWW6I0HlYXnwLXkpmQtvhgBsIJg5NKZYlYfTT+E5zwNw3ZRbvPGwElscAt35HuPdqrCeKhBr4h+lAY/alccDVFVcgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jackmanb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=3jqpoexT; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jackmanb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3jqpoexT"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-46e35baddc1so57758045e9.2
        for <syzbot@lists.linux.dev>; Tue, 14 Oct 2025 04:46:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760442388; x=1761047188; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=V97HSBuyCddwPX2eWiNiWvy6SrgdwsdzX5FKBWhIi1E=;
        b=3jqpoexTKjvl2UmL2JSK0Qquq+YX2ccqccdQHeZR0/qd8znxq7YryEptz9y+wcjXma
         uTw5XA3zA4syapi2ewjPnl5AUWqr/4azx+b7WGzbxf67iiEwR4pLw7Kdiw/Ykrm6QuKL
         OBrvYvR7CPT9WDVGxwmUtveX6DM+xVb8E9l+aQVF7mus30NH5opgbtf+0cbpWL2XjgVg
         laFOuwDKo3H6DQoarQQZLaqMt8bMeTxjZnzggkPMwzqwymKXhQB5Qmjhp0h3OqJdbUco
         z/xi6Pbq8gxBqGpIAIlIZ8jGdM9v5YLrEZk2KU6k6ln9wZPlYzMQ1ovxrO9YzAnC74eF
         BrRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760442388; x=1761047188;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=V97HSBuyCddwPX2eWiNiWvy6SrgdwsdzX5FKBWhIi1E=;
        b=RGDDlyc00xDjp3yY6uweWoWxUEYgmUqorvDRdUBxziEDt1VK1yGvdtT9n3FpJ22SSY
         8VjQj7KeE4uPPyQtU2FcJBY0i3e9JtZUI7EiNOspneXzobPbKqFatoHnc/5fZryJ34uo
         1q8ISMDQss9K4zNUJKUmUUz2n/GRiHKwbTNz5bTyEPr6qdyyg/e1djknbAYQxpxvkCnr
         6e0co1dFIe8w2yf44hPC+rNhsGXvqRGQ1TKg0tZU/Pw4lt/fM97HbzxlFAgw+hD6Qd0/
         L5ZCZfI5UhExg8RYZyEE4j9Qdhf3cjuo6g9vpky2wF5klUBaM9lvky3XV1/jp3K5Nlpx
         YqcQ==
X-Gm-Message-State: AOJu0YyTtx97wibrm3CAsZYqSZ36fcjh4hedb1+8C1UXwG1y7BsA0/se
	nRrwbpAYbClQnMXDvegsTWH5+ryfe9B6v2Tr3Q3DzeUexrq3OZRCOX0Qyu+X0/3KKLR3XdHlJR1
	Fm0oLftjG26ITXg==
X-Google-Smtp-Source: AGHT+IGOyIRofYjYdpZa5szgrk6yrVf55DI0nc+jrKz4dMBV/l2/6mxV2A4AekmoWWzzSKpimbmwyKo7J/9+QQ==
X-Received: from wmnp21.prod.google.com ([2002:a05:600c:2e95:b0:46e:5bd7:fc8])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:1987:b0:46e:4a2b:d351 with SMTP id 5b1f17b1804b1-46fa9b0792cmr172082275e9.28.1760442387950;
 Tue, 14 Oct 2025 04:46:27 -0700 (PDT)
Date: Tue, 14 Oct 2025 11:46:27 +0000
In-Reply-To: <DDHX5G54GS7D.1YC8514SPRGQF@google.com>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251013-b4-l1tf-percpu-v1-1-d65c5366ea1a@google.com>
 <68edea17.050a0220.91a22.01fd.GAE@google.com> <DDHX5G54GS7D.1YC8514SPRGQF@google.com>
X-Mailer: aerc 0.21.0
Message-ID: <DDI0QRWVTMQT.3BA2T46YJLIII@google.com>
Subject: Re: [syzbot ci] Re: KVM: x86: Unify L1TF flushing under per-CPU variable
From: Brendan Jackman <jackmanb@google.com>
To: Brendan Jackman <jackmanb@google.com>, 
	syzbot ci <syzbot+ci693402a94575bcb2@syzkaller.appspotmail.com>, <bp@alien8.de>, 
	<dave.hansen@linux.intel.com>, <hpa@zytor.com>, <kvm@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <mingo@redhat.com>, <pbonzini@redhat.com>, 
	<seanjc@google.com>, <tglx@linutronix.de>, <x86@kernel.org>
Cc: <syzbot@lists.linux.dev>, <syzkaller-bugs@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"

On Tue Oct 14, 2025 at 8:57 AM UTC, Brendan Jackman wrote:
> On Tue Oct 14, 2025 at 6:13 AM UTC, syzbot ci wrote:
>> BUG: using __this_cpu_write() in preemptible code in x86_emulate_instruction
>
> Ah. And now I realise I never booted my debug config on an actual
> Skylake host, I'd better do that, presumably running the KVM selftests
> with DEBUG_PREEMPT etc would have been enough to catch this earlier.
>
> Anyway, I guest we just want to use vcpu->arch.last_vmentry_cpu instead
> of smp_processor_id()?

Just went to code it up and changed my mind about this. If the vCPU is
being migrated, it doesn't really matter which CPU stuff like
x86_emulate_instruction() sets the bit on since it's vcpu_load()'s job to
make sure it's set on the CPU that actually needs it. So I think instead
we just want raw_cpu_write() here, then there's no pointless remote
updates. The bit might get set on a CPU that doesn't end up needing it
for the current vCPU, but it was gonna get the bit set before it ran the
next vCPU anyway.
