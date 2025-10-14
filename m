Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1802526E706
	for <syzbot@lists.linux.dev>; Tue, 14 Oct 2025 08:57:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760432256; cv=none; b=mI8g8xiHvtuug+hHMzaLTldPMxdIOcrw2pg9ddw3zbaF07yCPyNZzik1T2uw/gEBLoJsXMBF7nRndhmJOJzmv1ikZqm6Zz45o04zuEqMbWXkEv82/KdWeFmSWDQr5BIR1kPThWxRAuMgyHQ6/wU9y++3XK8hSsljlk6LcpKcYdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760432256; c=relaxed/simple;
	bh=E4F6zCQxofT/ijQ1Lk9Sq4gLTN9jp0PKg+b/gO7SpP8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ZakzJjhRcdcOiduDv+i+KhMDhrlBf501uWyDE7rWIkFJyKFaNOYozMwgIMeHccpCFJluvH/pI4xLSyyuu3tz2Lu3DlZUVoI9KGwVy7JX4cMK7Jwz7cw4Z4zxM0gTwmGc2FZjJaMrwSQrTKQwkPxpNea8AZvaxedunRjr7Ah7X0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jackmanb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=i93E5jw8; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jackmanb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="i93E5jw8"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-46e4d34ff05so27771615e9.2
        for <syzbot@lists.linux.dev>; Tue, 14 Oct 2025 01:57:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760432253; x=1761037053; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=E4F6zCQxofT/ijQ1Lk9Sq4gLTN9jp0PKg+b/gO7SpP8=;
        b=i93E5jw85tXMWgCEttvnE7IcKYBJ4EnUArlvoW7fXLHBsou2eQsGJ9CAxWCnTbttjS
         akYUwQ3O/cUn23QdqedhFdxxKeXT3OWR3Wo9d8YcEf8fPWTa7iYg2OB4147HLZyrinoC
         6HMBblCSTjcrt6IftF6eK34cVoSNGoIHKcgAwgjlnMyV3poJrgH1Gt0001K6v24Vb49C
         wRYYQ1u1ZCJ8j8rCXmOLDLwcaJ5TF9rf8LgYPxYgfQAOjQhl5Hc3+6zu1+67tytZZcPO
         +WQES4oBEU8SAmqnJBoQZ71B+wpcdBARYxLccm/7NYkG+5RroIXeeGehG0mFQD2S2o2v
         3zYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760432253; x=1761037053;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=E4F6zCQxofT/ijQ1Lk9Sq4gLTN9jp0PKg+b/gO7SpP8=;
        b=GO2gHXpAyk5vj19SMB3maXekCDTC48YlW1p1gKR/JSln0TmeaL3FcPYlrmOcV7T6mE
         uhM+GuY//HXSRm8q+nNFUfj/xwpWKvsOSS0uKK0BGWb70VP4lc2k0QqXa2JeyASxPlSJ
         UJ1/JIxy/PLxU18z+C16vtGue5jfp0+hVXuCscoppNoVo11AHSva3/sdIPEGVzvf4c5q
         1Smcqr/zmH0h+nko8TNRf0gMQn1mMU9tRzpbJpbTFTJbY3xdglXswOEccY43H9V1F1IZ
         aYWeVQpse620iDafaWosj5HE+sgVzEGWj0Hn5r+W7Q5MMgxxWqhiUdgD05Mo4RYwZ2E7
         68fw==
X-Gm-Message-State: AOJu0YwBjjUeEjUZslRmPyhXuBGvxX6NwJhQKBerZWMmSEgs+OE4Zplg
	Djrtnv8UaXcAQj8lG3EbUZOTwb+GUcQbpNSCLW0Mwhz+fPHGksGsq9SZXOLVrKGRD/IiOiZeOoC
	knhU+hYcH15vySQ==
X-Google-Smtp-Source: AGHT+IG3ne3PsSqSbyFbnpOiDKEA5Cl7N+bezBY3keJ7BevMSp8mdAb5PmKQd21efPgwnEf76x9mBJX1JTeeNg==
X-Received: from wmpj26.prod.google.com ([2002:a05:600c:489a:b0:46e:3921:1b1])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:6287:b0:46f:b42e:e365 with SMTP id 5b1f17b1804b1-46fb42ee3f5mr101990975e9.39.1760432253068;
 Tue, 14 Oct 2025 01:57:33 -0700 (PDT)
Date: Tue, 14 Oct 2025 08:57:32 +0000
In-Reply-To: <68edea17.050a0220.91a22.01fd.GAE@google.com>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251013-b4-l1tf-percpu-v1-1-d65c5366ea1a@google.com> <68edea17.050a0220.91a22.01fd.GAE@google.com>
X-Mailer: aerc 0.21.0
Message-ID: <DDHX5G54GS7D.1YC8514SPRGQF@google.com>
Subject: Re: [syzbot ci] Re: KVM: x86: Unify L1TF flushing under per-CPU variable
From: Brendan Jackman <jackmanb@google.com>
To: syzbot ci <syzbot+ci693402a94575bcb2@syzkaller.appspotmail.com>, <bp@alien8.de>, 
	<dave.hansen@linux.intel.com>, <hpa@zytor.com>, <jackmanb@google.com>, 
	<kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, <mingo@redhat.com>, 
	<pbonzini@redhat.com>, <seanjc@google.com>, <tglx@linutronix.de>, 
	<x86@kernel.org>
Cc: <syzbot@lists.linux.dev>, <syzkaller-bugs@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"

On Tue Oct 14, 2025 at 6:13 AM UTC, syzbot ci wrote:
> BUG: using __this_cpu_write() in preemptible code in x86_emulate_instruction

Ah. And now I realise I never booted my debug config on an actual
Skylake host, I'd better do that, presumably running the KVM selftests
with DEBUG_PREEMPT etc would have been enough to catch this earlier.

Anyway, I guest we just want to use vcpu->arch.last_vmentry_cpu instead
of smp_processor_id()?
