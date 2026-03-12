Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 854133B7778
	for <syzbot@lists.linux.dev>; Thu, 12 Mar 2026 09:40:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773308453; cv=none; b=DpAHqnYCpQjXuk1u/e4cBRyWwrxtiHEdPxyR1QoMCBvXWx5qvJ72b/Sg6KtWlDIBEO1QDJ1X2Pyw6mjp2+GrS7sU4DRZTZsfOQmw3l2uh6Jgah4lVtUP/fdo9qkLlWsLlQB8klkaKNuiYYcvn6Wpar+ilEN1l6SD71r7cyVpU+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773308453; c=relaxed/simple;
	bh=ddEVo4L1jDTJ75CDuotLTBCt2IwHCurzLzGzvhrGLB0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NCbIcOdUGBsNi1EqE6FPERBXhUERfpYe7hsSizpG5t77YXWOB7KDhYbkPCI/rqZg1QCNAZrLp9TXNxgtTU2yTKC0vWlT1G8sWooRiY+PSBlvPJ2+55rx7cL2ffqeSPBITcR2gOK/XtzhRWEwbJXZ++0WXPd3xbiWDsd8dXUqeuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DvwOqjjj; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DvwOqjjj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773308451;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=e6EdyD35EC+SpPH1TY5bENOyft6Ge/0pFEQiQDyadAk=;
	b=DvwOqjjj9V+PmRMcx+3ygUpWokbt1wlj+0U9o2I8AauGRyNjyUTpdvN9kyevALf5dlZq2m
	Wwxo0cfWJJG/5GoND5SmrUzGcgNDJrkoVGArHwphHlINYfJ1HoI2aYwmCoWnbvrM5Qosvl
	psW/p15nV8Kia6QI8YmtiOMhrcLcnrI=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-186-H72fJTGIN4WZAOujxy_UTQ-1; Thu, 12 Mar 2026 05:40:48 -0400
X-MC-Unique: H72fJTGIN4WZAOujxy_UTQ-1
X-Mimecast-MFC-AGG-ID: H72fJTGIN4WZAOujxy_UTQ_1773308447
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-439b20722e3so379023f8f.0
        for <syzbot@lists.linux.dev>; Thu, 12 Mar 2026 02:40:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773308447; x=1773913247;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=e6EdyD35EC+SpPH1TY5bENOyft6Ge/0pFEQiQDyadAk=;
        b=uDczxAVBFm/psIdj/eg2gHGmWac3dX1BxDt7+iHRSqBIvZgLgWajsSfV8Vx8ZXBwNx
         Rq+vzJOSzzWYZSHtDAri+VXPUjzyelH7zyfC8bcHqGe879XrGiZUzsLch2VPfGtPcmPr
         2yJE/Z5RUymS/ph+v+U703FMFIqgv5T9ocraE9xsM6urhfs7OZ3Wp/EphKwPnde0scLM
         GPR20hkzYW1KlkX78h8MgMj76IaGVpHwVbc06kBvHR9VjA3GajG5QJ8fnwls5XC0r1Ut
         BQXvYAFLl1zS6zkFkqDJv62NVR4NPobJY0Vm8/QhP0Ei1wVW/a54UV4DhoJOnGrkoMgl
         d9yg==
X-Forwarded-Encrypted: i=1; AJvYcCVegBA6x43IjTnBqG7ZxVpGS7p5t0HPK0EjwBCkYuT9aeTmwV1EvV4NR08QfACOGb5Wbe0Watg=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw6f7l0n5/TG6ZAJocjPjXX7/MLfXVUFNX80aG1VBT9aweEpRIZ
	XALwxmqUPMTYcVi90yNW8mT1gDydOGXYwW9pdBE0pCKE/djFvF7L/g0Wg9omJqI8Pod0JawFcuL
	5EYuRDkMaq23tF3kUEKsqP6b5wilH7AmW3tTfo5DCS8iikoN8mynzcd9yPQ==
X-Gm-Gg: ATEYQzxqpGStUZzPt5oK3Jw8Ux2vfPtxd9413NAF3fVxD2aSh/A5X6lLHiSlinKSlYT
	YoZx5RxxlJap4B7XPX5XKYxjOsKOu7xJAB0zrXfsGe3ekI3F9QZdv0x/xkGE8pJoUgMvZCgQES5
	9Yq6kS4AWrb9npw0qp2Zx/aVK8BiyiSukYW6aU/Muuyos+TxB/6BQJ6G3N8o8mVwAV7qhROL5+z
	YPxJc9V8GRwp3Mz4Za0Fq9GI25+mCOEB7D56ie8RBqfX9VEYWII9As0MX1K4cvMfNxCO0pQCWzL
	CC4AOgW+omLowxZGhhJwpvN3Tk15N/gNToYwNVMhPX0yTKRRvCpInNSj6qmLANVkscCCeR9rrXT
	7ZhgSrb1hKj8Uuk08nV2yx+FycVgjn2Dg6+Dc8hbtGy7Sbbdyxex4iZo=
X-Received: by 2002:a05:6000:228a:b0:439:ca64:967c with SMTP id ffacd0b85a97d-439f822b9d9mr9932345f8f.44.1773308446720;
        Thu, 12 Mar 2026 02:40:46 -0700 (PDT)
X-Received: by 2002:a05:6000:228a:b0:439:ca64:967c with SMTP id ffacd0b85a97d-439f822b9d9mr9932296f8f.44.1773308446263;
        Thu, 12 Mar 2026 02:40:46 -0700 (PDT)
Received: from [192.168.88.32] ([216.128.11.95])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-439fe22f3a4sm7155566f8f.38.2026.03.12.02.40.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Mar 2026 02:40:45 -0700 (PDT)
Message-ID: <bcc536ac-dde1-4b63-8fed-70850818472b@redhat.com>
Date: Thu, 12 Mar 2026 10:40:43 +0100
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot ci] Re: net: move netdev_compute_master_upper_features to
 ndo_set_features
To: Sabrina Dubroca <sd@queasysnail.net>, Hangbin Liu <liuhangbin@gmail.com>
Cc: syzbot ci <syzbot+ci098fa7c1795eceac@syzkaller.appspotmail.com>,
 andrew@lunn.ch, bridge@lists.linux.dev, davem@davemloft.net,
 edumazet@google.com, horms@kernel.org, idosch@nvidia.com, jiri@resnulli.us,
 jv@jvosburgh.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
 netdev@vger.kernel.org, razor@blackwall.org, sridhar.samudrala@intel.com,
 syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
References: <20260310-offload_compute-v1-0-3df79c09ea65@gmail.com>
 <69b04e91.a70a0220.51e36.0000.GAE@google.com> <abBuLV3P6aTzUg3W@krikkit>
 <abC7rdjxv9ENw-tA@fedora> <abHcP3GTO29rfKML@krikkit>
From: Paolo Abeni <pabeni@redhat.com>
In-Reply-To: <abHcP3GTO29rfKML@krikkit>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: i0pn92gAJi6YhOxncpYyKwoYtMVlpehOAiwBpvxIcoY_1773308447
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/11/26 10:18 PM, Sabrina Dubroca wrote:
> 2026-03-11, 00:47:41 +0000, Hangbin Liu wrote:
>> On Tue, Mar 10, 2026 at 08:17:01PM +0100, Sabrina Dubroca wrote:
>>> 2026-03-10, 10:02:09 -0700, syzbot ci wrote:
>>>> batman_adv: batadv0: Not using interface batadv_slave_1 (retrying later): interface not active
>>>> hsr_slave_0: entered promiscuous mode
>>>> hsr_slave_1: entered promiscuous mode
>>>> ------------[ cut here ]------------
>>>> err == -EMSGSIZE
>>>> WARNING: net/core/rtnetlink.c:4421 at rtmsg_ifinfo_build_skb+0x218/0x260, CPU#0: syz-executor/6496
>>>
>>> I'm not sure this one is caused by this series, but either way,
>>
>>
>>  rtnetlink_event+0x1b7/0x270
>>  notifier_call_chain+0x1be/0x400
>>  netdev_change_features+0x95/0xe0
>>  __netdev_upper_dev_link+0xb20/0xc80
>>  netdev_upper_dev_link+0xb0/0x100
>>
>>
>> This patch calls netdev_change_features() after __netdev_upper_dev_link(),
>> Which trigger a NETDEV_FEAT_CHANGE notify and calls rtmsg_ifinfo_event()
>> to fill the new link info. Maybe the event is a bit early and macsec has
>> data not ready?
> 
> But this would still mean that there's a mismatch between
> if_nlmsg_size() and rtnl_fill_ifinfo(), and your patch is only
> revealing it.
> 
> I'll send fixes for the stuff I mentioned, no idea if that's what
> syzbot saw since we don't have a repro.

It looks like even the nipa CI is reproducing the issue, i.e.:

https://netdev-ctrl.bots.linux.dev/logs/vmksft/net-dbg/results/554921/17-rtnetlink-sh/

more failures here:

https://netdev.bots.linux.dev/contest.html?pw-n=0&branch=net-next-2026-03-12--06-00&pw-n=0&pass=0

the fail in mascsec-offload looks quite deterministic, could you please
have a look?

/P

