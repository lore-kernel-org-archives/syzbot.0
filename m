Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7A78304996
	for <syzbot@lists.linux.dev>; Fri, 15 Aug 2025 15:38:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755272305; cv=none; b=VZG2ktE3Qx4ztnAv9g54Wo8LPqUdhmoRgjlA0f6vkgQMfo7yiblA2NvrT5LRQ5GeoNydAqXvB4uw6+SxwsjEP1cUTQkVf97eAWSgG6DT0MwFlpObci+9Wom84b2eAkWrcgHmOiif6t8oRA2EW+4N7flb1l6rK6ineJsLdne2gE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755272305; c=relaxed/simple;
	bh=DjcBVY8mJqbGJnCRObWENCx0c6xRt7QNzm9li1dg71c=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=RxVKBkQo9k2BZFnv+HnU30i+TeGXm6JajvO+aF2/ozrFertzlyx67EGnaXe8eVgseuvYSH98kx3+retgiEIwtUltotLiZGiBBgPsYPZVfZ5ZFhRSAhwuH7efp0a8HF4V207wzKBo+j0yMqn5KhmPyoBOre9uAtjKeikOjeOmVqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-3e56ff1b629so56440255ab.0
        for <syzbot@lists.linux.dev>; Fri, 15 Aug 2025 08:38:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755272303; x=1755877103;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DjcBVY8mJqbGJnCRObWENCx0c6xRt7QNzm9li1dg71c=;
        b=or0PMZJ+vdrSunYtwik+FEgraI8yDPXNZROK0mHqJh1+Y1hKZVw/hGJRufLCL9H+xl
         n0Pu49BqdokhhmLoNrtAnYH/B1S+/AhBfFa8Ef9xgJga2AOXGb4wXIGzNsxGqDZaK5zM
         wOje73ujUbRnW1kiHWt2HL0+Co1v7cCWCf0Ys63A64Jt5NQQ3vppTwUW7WKmEoI4T5ll
         EMSAOjtRxHDjwpNBNXzWI28921bmdSuGi1tCiwAaq3swJfQOiRCxYUimMhGMDNY+zGj5
         NW7Gd8DpY3S68+E4lf40g3gGchITh0S76pb+5nzHN/77llOasUiT0y9gXvcOz1sTylVd
         pdjQ==
X-Forwarded-Encrypted: i=1; AJvYcCVV4iZhAyNQU5+XOrC4Le1u0qIFdhG8F8R78TZCl4l8DHhRvDBKKqzLY0XdSI/zIA+7oQBvdvk=@lists.linux.dev
X-Gm-Message-State: AOJu0YzYfHSbvmLe412L4lwFWapbtwlAs63e1wYvDP6NazH5+txBmX7T
	JntpcHGTlTeCL0jqSADOoDr66U3jVCTZ5EfHf5P1SfLyPsGZABBEgyKv9MV7UKwF3T/idDhFzG/
	FDFVURJDNSoi1i+0pZP4HcWj5c+51E3S9BpmIHVz/O7N3JJoZw1tbTj+nNlM=
X-Google-Smtp-Source: AGHT+IEZCErYDJfK+PsAhXz8az/SOFKcABcXNXr0Q2bzIAiRaGBhp8DoowWmbEM2Eo7/QNOXWUZsT99JggtdxpHJX/wQX6tCGYLj
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:2707:b0:3e5:58ba:d9ca with SMTP id
 e9e14a558f8ab-3e57e8252f9mr48746805ab.3.1755272302920; Fri, 15 Aug 2025
 08:38:22 -0700 (PDT)
Date: Fri, 15 Aug 2025 08:38:22 -0700
In-Reply-To: <b2667c4ebbe5e0da59542d2d9026322bd70c6c6a.camel@infradead.org>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <689f546e.050a0220.e29e5.001c.GAE@google.com>
Subject: Re: Re: [syzbot ci] Re: Support "generic" CPUID timing leaf as KVM
 guest and host.
From: syzbot ci <syzbot@syzkaller.appspotmail.com>
To: dwmw2@infradead.org
Cc: ajay.kaher@broadcom.com, alexey.makhalov@broadcom.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, dwmw2@infradead.org, graf@amazon.de, 
	hpa@zytor.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	mingo@redhat.com, pbonzini@redhat.com, seanjc@google.com, 
	syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com, tglx@linutronix.de, 
	vkuznets@redhat.com, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"


Unknown command

