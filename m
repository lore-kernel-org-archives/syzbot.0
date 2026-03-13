Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD89328A72F
	for <syzbot@lists.linux.dev>; Fri, 13 Mar 2026 09:48:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773395339; cv=none; b=LBOitVPwfkrasc9Yf8HnbYbYBOnO1oEJ7XWdoB6Yju8GyoNa8eW7STdC30rktk/rKaRhVDujeNghGUEvFyIZrkdJBRYLKsGXbfUWLBsYrRHHuz6USTVfBGPCOomKM0LUG9p8dfLPVEKklMWnNP7hnAnfzOi/ZOFOv+CiUp6yZQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773395339; c=relaxed/simple;
	bh=V4nNPy2aFr59x/RR+ByzLxeYdHhrbgCFyiySQ9Cg+/8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bMjBLR547/YMRWEocv6MVl1GAJz16nLUVOMDJszzwsv3aY+tLFclyl6n+idLdoQqJG70iCC7EIvY5Vj/IlixyXoe5RERq4MEcNAUOgdssEjNwH+NHG7qVWEMKBrkNBqQwj3AElYnTRBMx6Y9AL/EErYtmOlWAMGH6CTlTaG1wsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=morsemicro.com; spf=pass smtp.mailfrom=morsemicro.com; dkim=pass (2048-bit key) header.d=morsemicro-com.20230601.gappssmtp.com header.i=@morsemicro-com.20230601.gappssmtp.com header.b=PSnfNOgB; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=morsemicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=morsemicro.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=morsemicro-com.20230601.gappssmtp.com header.i=@morsemicro-com.20230601.gappssmtp.com header.b="PSnfNOgB"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2ae3a2f6007so14311065ad.2
        for <syzbot@lists.linux.dev>; Fri, 13 Mar 2026 02:48:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=morsemicro-com.20230601.gappssmtp.com; s=20230601; t=1773395337; x=1774000137; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=gU9H7Bo9roQ+prgGEiA4EB14853/ekv7Z79E0nFUk7o=;
        b=PSnfNOgB27Z+rAV0gWcuUTaCxhz/XAJ4uZPmx3YdHj0lStmackI8174sWGlBHzVVgc
         5qzSpbJjgqdrzkXaDcPyv4q2/PlDMndrOwTyRCpAIT6uHYFJtP9eCl2aQfmrQlfZAs2T
         jdz94ePW2eqafLdsKkMC6jshw5VZDIr+may+0vIXNy+93n5CwGGAP2gt2X5L7Ky74Prr
         Z4RnU+88WXxNzzDHhxhZ6N6bKaJ90MQ0aOfTJypSyCQQNf4DrFEsdgJomH36KVVv7YGh
         pfEK+jD9S4PLarPJ4H9IXQQppmaiFb4+dVHFxAgs3w4ewTnE3VHEc5wu8oRWAAjLvLk9
         I79g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773395337; x=1774000137;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gU9H7Bo9roQ+prgGEiA4EB14853/ekv7Z79E0nFUk7o=;
        b=apNbAQL9v7WovM4liAwLVRkS9p7QCty4/dL0SUyNIIj1pMnS2bvu7JyxGykXzaeaE9
         k4D4UdIXAgeL4mB/x6Bcvcjlv1zYEYP36bsAoEdKmTgf428GCBM6lOmhJbF8xFc3BGi7
         FyUtubT2hAKZa6dhaROPKHUNfbYpUXaQtYiaEhFhBcBtl3huKL5FjfalQyQvBs09gI+l
         S6R/tnMqxtj8XOWhVYMo0z1VXkiZdpcbXw5HbBSgaKeow2s51T2r37kfa8VkCnMRIaWY
         LZg6/6bSzMfFZiq0Zrz7why3KU2XpbrkgPPG886sx4jToWBshVU42K+W2HWpXxTl/IhK
         q0yA==
X-Forwarded-Encrypted: i=1; AJvYcCUHhvHjK8pdu+DvzR//vDi+tiJaQQAa4WK63WZESVwh0uXfLW/+fhEQnzI8za+irB1kYTPD2xk=@lists.linux.dev
X-Gm-Message-State: AOJu0YyV9mjcxjihD9DKO752c68bQD+jLXAVM/PrmVfFUU+nhHFDW2CL
	+h3MQ2Es2+Y2CW0u+yz8Hxhjv/XI6U0C3prsHVoI2Bbjb4N7F/ezeFqdrRBEJBClWmm3Qdegt7z
	z5qfi
X-Gm-Gg: ATEYQzwpinxuArytnJStQynMmoW/szYOert4wCtmTq6s46Nsf2+B/Nq6WdRzS8lUyRy
	v7LwHjTIgJlFzrQM/d8IuJQVF4ZFqhtDNxAUpi5Cfl5NaSx5/qapMXndw/hHO6zHErheVTKMHRg
	d/dNpla6q+CN6H1enTkNeOqTg98qMQCuq71itY0MfEsa4WapyJ+s0QswVs1v/1vFao8NNiSzOWZ
	47PhXQbbBmPKIEN9vBLv4yX3/2tNXFtQMRXadTpkftDt2FmdYOG0yVpG2pS5zppXQsXHAPxwMxO
	+MSVN5RckQatZPSQwFs972aq2OmgAMf3pLMb1nb/ysSx65xubLIFAEoPYfVg/5bCRmdTft3/KgU
	lGGagFIO1xVCZPQS7tsQEf0wYrkengAKOgH6nzUR0k+zdNNe8v+K9lrIK8OHpVdzj0NNJ6aVL44
	sfPTwOjild48fwG0B38IQ07P8npOy47ZC4fG8qqANm48uUqewqRwtoI8lm+TpwAWjl
X-Received: by 2002:a17:903:ac7:b0:2ae:47f9:de12 with SMTP id d9443c01a7336-2aecac84e7fmr24772455ad.46.1773395337034;
        Fri, 13 Mar 2026 02:48:57 -0700 (PDT)
Received: from localhost ([60.227.233.145])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2aece845022sm17450755ad.83.2026.03.13.02.48.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Mar 2026 02:48:56 -0700 (PDT)
Date: Fri, 13 Mar 2026 20:48:52 +1100
From: Lachlan Hodges <lachlan.hodges@morsemicro.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: syzbot ci <syzbot+ci0f91523e1d0ef709@syzkaller.appspotmail.com>, 
	arien.judge@morsemicro.com, linux-wireless@vger.kernel.org, syzbot@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot ci] Re: misc chandef cleanups
Message-ID: <sezz36jv4edclmbtrcbdwzyb5goxp2tcfneoi56ounzuled42v@o6bajqutzp33>
References: <69b3ce9d.050a0220.12d28.010d.GAE@google.com>
 <855780e1bece0de480b7fd3e1cf67c9f70129818.camel@sipsolutions.net>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <855780e1bece0de480b7fd3e1cf67c9f70129818.camel@sipsolutions.net>

On Fri, Mar 13, 2026 at 10:05:15AM +0100, Johannes Berg wrote:
> On Fri, 2026-03-13 at 01:45 -0700, syzbot ci wrote:
> > syzbot ci has tested the following series
> > 
> > [v3] misc chandef cleanups
> > https://lore.kernel.org/all/20260312045804.362974-1-lachlan.hodges@morsemicro.com
> > * [PATCH wireless-next v3 1/3] wifi: mac80211: don't use cfg80211_chandef_create() for default chandef
> > * [PATCH wireless-next v3 2/3] wifi: cfg80211: restrict cfg80211_chandef_create() to only HT-based bands
> > * [PATCH wireless-next v3 3/3] wifi: cfg80211: check non-S1G width with S1G chandef
> > 
> > and found the following issue:
> > WARNING in cfg80211_chandef_create
> > 
> > Full report is available here:
> > https://ci.syzbot.org/series/ce6fc7d6-d8d4-4d00-a746-db78cba13e47
> > 
> > ***
> > 
> > WARNING in cfg80211_chandef_create
> 
> D'oh, just after I apply it.

That didn't take long ^.^

> diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
> index 3e867930e253..7314312ec567 100644
> --- a/net/wireless/nl80211.c
> +++ b/net/wireless/nl80211.c
> @@ -3634,8 +3634,6 @@ static int _nl80211_parse_chandef(struct cfg80211_registered_device *rdev,
>  		case NL80211_CHAN_HT20:
>  		case NL80211_CHAN_HT40PLUS:
>  		case NL80211_CHAN_HT40MINUS:
> -			cfg80211_chandef_create(chandef, chandef->chan,
> -						chantype);
>  			/* user input for center_freq is incorrect */
>  			if (attrs[NL80211_ATTR_CENTER_FREQ1] &&
>  			    chandef->center_freq1 != nla_get_u32(attrs[NL80211_ATTR_CENTER_FREQ1])) {
> @@ -3652,6 +3650,11 @@ static int _nl80211_parse_chandef(struct cfg80211_registered_device *rdev,
>  						    "center frequency 2 can't be used");
>  				return -EINVAL;
>  			}
> +			if (chandef->chan->band == NL80211_BAND_60GHZ ||
> +			    chandef->chan->band == NL80211_BAND_S1GHZ)
> +				return -EINVAL;
> +			cfg80211_chandef_create(chandef, chandef->chan,
> +						chantype);
>  			break;
>  		default:
>  			NL_SET_ERR_MSG_ATTR(extack,
> 
> 
> I think?

I'm probably misunderstanding - but cfg80211_chandef_create() modifies
chandef->center_freq1 if you have a HT40+/- chantype wouldn't you
wanna do that before you validate against the CENTER_FREQ1 attribute?
Since in the generic init code above it sets cf1 to the control freq?

[...]
chandef->center_freq1 = KHZ_TO_MHZ(control_freq);
[...]

where it wouldn't match for HT40-/+ since im guessing the CF1 sent
down should be what it would be _after_ being set by
cfg80211_create_chandef() based on the chantype? Or am i missing
something?

lachlan
