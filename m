Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.47
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793103412;
	b=SHDSaNSDbii29BYdn9wwCWMKDOGmzBF00O241ACbXg6KrReGN2blO+EwWuX4K7frbJrG
	 aVWYkucVT09SCKqvS9Ok6m1MwXBCHEFKF/i6jECROvAvFS87kl7FSArRmhBub6lINCfo/
	 P+f8U/rAkPHS8qF5DwwMYdVLJ6wkj4ivWBEyTDn1d2NEKE+VBIPb858Iv4PvsdiOrxYGM
	 1DPxARFG8P+STT2KStS/oZu/3sfpuRDtMKwHVTD48+tPy7CK4aLi8eGIXKjcsvzj8MNMq
	 cag2TXJDfG9PAlQoWieB5zW2UZG3apdFBVR9S1jcaiV4lPP1U1P/0vyg5EnW3z3Mqow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793103412;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=qQ58TKr8MXey12izNEnvpb2aLK2HSWoN0TjptAHNG60=;
	b=3u68ojnKLEtm0sg7nNPItsF7MZrYQm9xKw2N8IxjQ2aY8AT1ZU7XdN9DQ9QK9Jfc216x
	 GnFc5Tx1NqQMOt4uDwC/hYsmpvga5LhsocxSoh7dSRjmbYDO4NdfYwBqoDIMdIRhcLX4y
	 oxg/5WWN6dHZDL2VgGh/qMae+Nkk9HmMA16p7YZO5bj/r8GJinJCTDWwqxeRB0dfc8Ohp
	 60G7mzPAM1uG/L8gWQBfVvXdOCHAGD0w0nN0sildsiTfL1s/CboDGvadPhdcx2fcs1OMi
	 S0kGGwggPigIw7I8PnmQ3boDBZfMlNQlH4Bu5H4HCiAUWQg7YMeYM1ghi2QBsI1vYUQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=hackers.camp;
	spf=pass smtp.mailfrom=gmail.com;
	arc=none smtp.remote-ip=209.85.221.47
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75055606A323
	for <syzbot@lists.linux.dev>; Tue, 27 Oct 2026 12:16:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 75055606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hackers.camp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-48df3912dd2so400140f8f.1
        for <syzbot@lists.linux.dev>; Tue, 27 Oct 2026 05:16:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793103411; x=1793708211;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=qQ58TKr8MXey12izNEnvpb2aLK2HSWoN0TjptAHNG60=;
        b=MMGCxAH01AoErVlFEF9OUSQWrM9SK3sgVA3wA1WA4TObeFnXdmFfNmfNQntaTODOge
         R37vetTv0k5dz1PNvQOUt1eJ/vrdrfgoY4M0J+wQmGA8I0v+OEFpWEXohA5hOE6Krt2G
         ZME6XjWDV+7CyX3eA8qNRnrxP9FmnWO57muqe95NnfWkhUi7muxpWRg+sgpPch/qh4r/
         cwi9NN6IUP5mnWShD9GjDnUOdLGuREP2CJBEqsqgSb28kqOh+qlrKyo7XxcZxs2IhVv6
         g+sQ7w2ougtbmSG+nNwX2PzBDGb8iLKU8zp4EMctsK9MrWRgaABBsW9X+/lvO2zaGEv/
         YI0Q==
X-Forwarded-Encrypted: i=1; AKwUvBzuMK1u13ks9jKPOtgWx37ctqtRYSaPAziPJKz4Md9WEqUoEw3hqJrc5Gi2ZF6V6dLH5XspXsA=@lists.linux.dev
X-Gm-Message-State: AFq9FYKrV8XA1M7jN6uvNC4CH+iBtO4fXX2hrZ9NRK9a6r5DEaLAFGYb
	n0v9F8FB/VemH8b+qWbmimaqnYeUdNdXa1utgpPyvI0GW6Raw9AbRTlu
X-Gm-Gg: AYBFou09PqDiqJt5hc6GVhYdsvnjgGuK8qrjDPmKLzTPmknqwdPo1OspFoDVDrfV1Dw
	M/mb6CRZ60ye5/xzXpB/TevYe564vlkb7xz+P9H31vU8EIjWRJDUwbbM9BnnOtMtzTmhB41xKck
	irtpZvLQFafXahaAfzSI1zTVpDbWtq/JW3/JsCC0Bys7LEB5Oci8JPhMConcN4suj1A1H44Z2jp
	nFmcEvZD1L42Xzc/D6Z3HBUHR1Vzzp0MHHTygPWSP7EZJcKZk7Rg9rJ73NXylF9se7O4eSupzI3
	u7rC8Swm2DpvUsphwxmgA+aM1oj7cHNYOjWjNqo+oBteDBmz+cy+40QRUmJ6AHeyqgprapQn9pX
	5Wlo4u5E0E+7KcdTo0opBYCnRd9tqmbYmyyTP6mOkdBBndnMNKEwM6vJoLCV/dyD25zkP0Np2vf
	2VZjj/gqSfU/62svpvlJPKZjn02jcCtvAKheHT9JATkZJmajhDOO/q3rjlfCmg9wMDMZUGdM40l
	Ni0VuCF+SItK3Fyf6M3kP8aZ6wb+XT8sF5Xv4pccg7/R+1UKTxrOgQ1jXgD5WWJR87vMViDR0/H
	TWiQiHdOVJCneb/QUg==
X-Received: by 2002:a05:6000:2905:b0:48d:f14a:9186 with SMTP id ffacd0b85a97d-48e3eb97829mr22056835f8f.6.1793103410734;
        Tue, 27 Oct 2026 05:16:50 -0700 (PDT)
Received: from spartian.home ([2a01:cb1c:76:ed00:602f:c5f4:d108:b925])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e412cc164sm21108892f8f.7.2026.10.27.05.16.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2026 05:16:50 -0700 (PDT)
From: Aurelien DESBRIERES <aurelien@hackers.camp>
To: jack@suse.cz
Cc: brauner@kernel.org,
	willy@infradead.org,
	viro@zeniv.linux.org.uk,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	syzbot@lists.linux.dev,
	syzkaller-bugs@googlegroups.com,
	aurelien.desbrieres@gmail.com
Subject: Re: [syzbot ci] Re: buffer: warn when a buffer is attached to a second mmb
Date: Tue, 27 Oct 2026 13:16:49 +0100
Message-ID: <20261027121649.69819-1-aurelien@hackers.camp>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <a7h6k7ecnmnj426ss45fqdk2kjodrjurjpwhcwao2bjkw7tqtl@qghx3vrx5ber>
References: <a7h6k7ecnmnj426ss45fqdk2kjodrjurjpwhcwao2bjkw7tqtl@qghx3vrx5ber>
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Post: <mailto:syzbot@lists.linux.dev>
List-Help: <mailto:syzbot+help@lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
List-Owner: <mailto:syzbot+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Tue 27-10-26 13:10:55, Jan Kara wrote:
> Woohoo, great that we have added this. So now we have some filesystem bugs
> to analyze ;). At least in ext4 case this is a real bug as xattr blocks can
> be indeed shared among inodes.
[...]
> I'm not sure about the FAT cases because directory blocks where this
> triggers should better belong to a single directory. So it could be some
> race with freeing & reallocating blocks. Needs more digging.

Our mails crossed; forget the pr_warn alternative then, the WARN stays
as sent. If digging into the FAT cases from the syzbot repros helps, I
can take that on; say so and I will report what I find. Your free and
reallocate theory also describes something beamfs could do with its
indirect blocks, so I am running xfstests against the warning on our
side first.

Aurelien
