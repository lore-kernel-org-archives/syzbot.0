Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB0833FB7E4
	for <syzbot@lists.linux.dev>; Thu, 12 Mar 2026 16:47:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773334081; cv=none; b=Alru3m+3g3YLn2zU0d4u0Iu3otDZy+e7wXi0ukso+bz0OAJyQHnpjzct6q0sdY7C5iZtigE1SFJ06VkhxPU0hd2CPBra/HyCmiJGA43trCRVcs+THWYXXSkQV9Q5qkRgugn5P5CQ0cRy3rUI0SyWgzQOj3x19V4c53CdTPx7VgY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773334081; c=relaxed/simple;
	bh=IIb3lnFy9ZZgffcMQ1sb/OxpBNFDfrikKLoctgY2LdE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Gm2tBJK4J7C+Fah4b0gZAAeKxuhmfY6LeDw7XHB9AN8ACHwF7lnr3hdJytxwVHaPhbwMG078vMe1VXKdAl6kxLychoU3WXJC15aFkJcrwAIdKcrPGg1cISrHuti+gPaq8gH6kdQEKIunW90E1r/Zb2PEhpJMV7dqcKT2wn2we50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VokwVflU; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VokwVflU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773334073;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QopztaDQaDXdF0WurIHvj6v5UeE/ENNGQg9kHKBDRS8=;
	b=VokwVflUg0tbr7t/+tXumVBDbLtqhAS6vUo9J4TWYSscqC7we77dwfqOmy4OPPdKVkUx8l
	PDT3jPnJqlnBzdDzMXD+2H9CD2N3upMY4jYUlQslWnuVcz5TtdPowHu0VY1NlM16TKw4f7
	CXvzIh778HeFAitwExBz4SAQmzJKkYI=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-74-bvYCC4kpOIG3OTfvD9F70A-1; Thu, 12 Mar 2026 12:47:52 -0400
X-MC-Unique: bvYCC4kpOIG3OTfvD9F70A-1
X-Mimecast-MFC-AGG-ID: bvYCC4kpOIG3OTfvD9F70A_1773334071
Received: by mail-lf1-f72.google.com with SMTP id 2adb3069b0e04-5a1324aeb32so885610e87.3
        for <syzbot@lists.linux.dev>; Thu, 12 Mar 2026 09:47:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773334070; x=1773938870;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QopztaDQaDXdF0WurIHvj6v5UeE/ENNGQg9kHKBDRS8=;
        b=jaqiLlJys3aKgroTOR4LKA0PJ41i5ij+6s5ywei/TqlB6/Qoizm5ibpmvoW7YR6d0m
         snLZPdEuCFNfblBlol4SeOgWpIX3vpDZ+ryZM3Q4/AZO3m4ylCuxyNNb4zlvHy+QeTqE
         tLU6pNUqS4ZHr6ccVMGAJKE0TVXmWPV9nhVAxpxjoaIB6WgqN2XqQPwSU/mI8OWm5hXS
         SMVS9PihUH2K3NuaScOejWoQP5YKRMMGYxWjLSSvTeZjE1+StLFH5pv4CauUqYtK0e9Z
         2ouwhUXqLsF/eO7mmotYI6gS8aYEnV572wbkI6ZmPyNdE2Ty8hi5AijoSQROGvkY3DXR
         Eftw==
X-Forwarded-Encrypted: i=1; AJvYcCUZolI7ToFXA2/Ug/Pl9kXlw71bRNfh/f4qwypriQDbIrH5NogjrmdbavAXODny+ox6XuRL3Bs=@lists.linux.dev
X-Gm-Message-State: AOJu0YzZgu88+EXjzhMX0BIv23EzaKQexDNEPaO3Sr4stty4DERleZ79
	7l0sOz3nsv4fMSGuhxr3gJSbIbcs8L7hyyqOkjT1ieSZo+t9Mtmt7pkYBPVb+Yw+tpvpe7RYwFs
	ZvI3xjpGjhnYnL9Mtu0PBB8+G04JD+mPZ/JExLBbRbcFHk7IjvaA/uleZYg==
X-Gm-Gg: ATEYQzzEGWcz7xj3nf+NkJ8EMpGapdsCRJR1QYLNR06PxB3nmDNoq1non0OEE+zu7Iz
	DNZP/byrIajfjfy7/lb9ZJay2LLbvP/4W9Wk6RB6mIIamL4G18CAMZ3wUi2gjBnEMSQnbIeboJV
	U5cOJ7D3lRA4l60zFlAjFjzeFEW2/XXdrrFLl1zj/B3QPb5bSUhWwyXo8hUUb4VnarnOnulmU4b
	892ppXA/BnHSEH6PLVbC/7e5jBJk0iMtwJSII78pQELHC0N+DeTQWJkwb2tbzyweEr9ql6n5Yq8
	iqpMRv9DjkaabX8qcF8eGlpVvge9Pt7OL80/OAP8oVSdsIGlMlZR05PRLuMSlvp2ZUPOX/+S5/6
	kIMl1HqA065jl7q2N4au/dCBR12ebkibd+qjYIW7q/Ex3aOl3tpUQLHQ=
X-Received: by 2002:ac2:4ed9:0:b0:5a0:ff97:4374 with SMTP id 2adb3069b0e04-5a162703bebmr82072e87.7.1773334070515;
        Thu, 12 Mar 2026 09:47:50 -0700 (PDT)
X-Received: by 2002:ac2:4ed9:0:b0:5a0:ff97:4374 with SMTP id 2adb3069b0e04-5a162703bebmr82051e87.7.1773334070004;
        Thu, 12 Mar 2026 09:47:50 -0700 (PDT)
Received: from [192.168.88.32] ([216.128.11.95])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5a156366b22sm1021366e87.77.2026.03.12.09.47.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Mar 2026 09:47:49 -0700 (PDT)
Message-ID: <2d1e0acc-efad-4166-b738-721d88d533ca@redhat.com>
Date: Thu, 12 Mar 2026 17:47:45 +0100
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
 <bcc536ac-dde1-4b63-8fed-70850818472b@redhat.com> <abKf8Fg865Fhipwk@krikkit>
 <abLPBEg_-j5rp4IM@fedora> <abLivB2KPK0JcTFR@krikkit>
From: Paolo Abeni <pabeni@redhat.com>
In-Reply-To: <abLivB2KPK0JcTFR@krikkit>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: rJRC5-9SUGDAR6t63eAZlbDdzeN4SNHQF6_NoONHswA_1773334071
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 3/12/26 4:58 PM, Sabrina Dubroca wrote:
> 2026-03-12, 14:34:44 +0000, Hangbin Liu wrote:
>> On Thu, Mar 12, 2026 at 12:13:52PM +0100, Sabrina Dubroca wrote:
>>> Proper fix (so that the notification we're sending during
>>> upper_dev_link has full linkinfo) would be to move
>>> netdev_upper_dev_link() to after macsec_changelink_common() and fix up
>>> the error handling. I don't see anything in macsec_add_dev or
>>> macsec_changelink_common that needs the device to be linked. But
>>
>> If we move the netdev_upper_dev_link() after macsec_changelink_common(),
>> we will not goto nla_put_failure via default, right?
> 
> Yes.
> 
>>> anyway it doesn't make sense for macsec_fill_info to return -EMSGSIZE
>>> on invalid data, so the "bandaid" should be included as well.
>>>
>>> Should this be part of this series (either just the "bandaid" or the
>>> "proper fix"+bandaid), since we never saw a problem before?
>>
>> Since macsec need the "bandaid" fix either way. How about you post the
>> "bandaid" fix to net. And I include the "proper fix" in this series for
>> net-next?
> 
> But I don't think it's needed in net. Am I missing a codepath (before
> your series) where macsec_fill_info could be called for the new device
> before macsec_newlink returns? If not, it doesn't really qualify as a
> fix, that's why I was asking Paolo.

FWIW, I don't see a codepath calling into rtmsg_ifinfo_build_skb()
before device initialization, so I would be fine targeting net-next with
the EMSGSIZE-related change.

Side note, it looks like that the WARN() in the rnnetlink code here
helped identifying a real problem and correctly returning 0 when the
key_len is not yet initialized will silence it forever, what about
preserving a warning for this kind of race? something alike:

---
diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index f6cad0746a02..82974d4fa3f6 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -4337,7 +4337,8 @@ static int macsec_fill_info(struct sk_buff *skb,
 		csid = secy->xpn ? MACSEC_CIPHER_ID_GCM_AES_XPN_256 :
MACSEC_CIPHER_ID_GCM_AES_256;
 		break;
 	default:
-		goto nla_put_failure;
+		WARN_ON_ONCE(1);
+		return 0;
 	}

