Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D187309F08
	for <syzbot@lists.linux.dev>; Thu, 30 Jul 2026 09:06:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=100.103.45.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785402373; cv=pass; b=SjGHLNXGi2zPdm1rIal60c2SblbLMpMEZMCMPwFOOKaLhgXT6AqxGAk6U7ZWZpIv80dbD+j+N/TQUIrat15ht1yfNd4AInGFmvRKFjVlIB0RNWDti/pMH1nwN9GobB/OaLrWJLFUBMWEU3dBIPAkEVKlmgLdlhVxhc97TQMFsf0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785402373; c=relaxed/simple;
	bh=YpceacrPSqANJNZYYjc3kSN3rwfCxON8VJDwn8+iJms=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZnYwRZoesB1fhjJEMDHgZ5/sK1V5EovJdu2iw3h0lA3PKVl3kvBx9BOgeQ7CJJVPlM8z7CMyy72W5vGjT+ilKxRofVcu+hq9CzmWR1eqfAHRMQJZU0QTk4Eesg347Yrnz9tZ+lGfLg9DeG/eA/cwiN8abGxNZAiPFBrf+Lt6JA4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ngEahgAc; arc=pass smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ngEahgAc"
Received: by smtp.kernel.org (Postfix)
	id E59051F000E9; Thu, 30 Jul 2026 09:06:11 +0000 (UTC)
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=209.85.215.170
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1785402371;
	b=RC23TKgMJZslcaqP4MtSYKPuKEa2F4ZKpWuPUf061vcnaUSyRlQaRrMEbxrsB06fuxSQ
	 1tbYNRwzSkxiFBJcPekIVbRIt6nPBwhdDQz7WLfkhluFvCORXipnbNvs/smbjeFJUOWsB
	 79Ryud0FPVR4Osz77oCIHL75GkGAzEmpXs4VtCkDALosDuX4iY2P8AKH9CVEgykKdibCb
	 ZxWRfgD8xZsDLeu2Fcd+K/CuxLnXFnB6dYMnkzmdzNNIqNGYv01mfBu8v0gKWDj38NDnW
	 vV8gyOVa8owDZ4WhAUVo/HmlYZN5f1WLn7mPX0NFxpo+7ww7BycVz9XYzt8cgG1brQQ==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1785402371;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LXG14I+x6Cjngrv5DIK9wWOthQMmdDhtfcdd3QIRMGQ=;
	b=OaMMZHgA61jUxvuEM4YagIkpGw6NM0SfkDiDHPPZsuZhTHFu8V12CIKgYUb/qUKwCHYm
	 Cub+hmhTsu2IJ/wzp1ec+QzHivSgK3rsiXWNo2B+m1/ovlP8npGX6Biqz7whQWSDymB2P
	 RDCT9zNkUaePSKo0onO1HjkIaQWXgCy8PoFOxm4S0vychzFu0/FU3CTWzgmq0JTdLLiVF
	 Q548NJ4LUMyfYnOcYFkHb/dHo6GCar+sdtBlHlpWUi8EJqAErAOv1Glxpq8WluTAbXTZe
	 urNyMNThFe1h/cqwR7sbtApHKdGY9B2T0cn+B1rCe2GhZuX+3+psJBzEDf32r7xY1uw==
ARC-Authentication-Results: i=1; smtp.kernel.org; dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=ngEahgAc;
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	arc=none smtp.remote-ip=209.85.215.170
Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 608B31F00A3A
	for <syzbot@kernel.org>; Thu, 30 Jul 2026 09:06:11 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=ngEahgAc
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.kernel.org 608B31F00A3A
Authentication-Results: smtp.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-cbb973e6749so2240090a12.1
        for <syzbot@kernel.org>; Thu, 30 Jul 2026 02:06:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785402371; x=1786007171; darn=kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=LXG14I+x6Cjngrv5DIK9wWOthQMmdDhtfcdd3QIRMGQ=;
        b=ngEahgAceXVERppziMfewBqu3IU+/J/3oXeo/tjGZZBTu0ZLvueF2o6rvU7Aiqwux2
         f6BzoRi4Xitbvzg1zg+gRIGZd/mqZBSR0n3uCOdMvpf03wRSl31KxevNd0kSZmvvJpLx
         F+8boc+ytWPMdagsEBP7JcVhsfwvqd3IzfznO92xpGzylBE8q7mRCfBy88fiUYNw68f4
         8CtdgqOTpDRqODVqme9/BLwnCU44IIFgM6GM1Znn2ywe3Nbh0TFxy0k1PhNGaaKQtIWx
         B6Tl04GwKsLSL3hoQBgt9RDyCl3LCq+4sL5FHtR7fQ11+vcgzQnQo1SxCUao9NbOZicP
         xdvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785402371; x=1786007171;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=LXG14I+x6Cjngrv5DIK9wWOthQMmdDhtfcdd3QIRMGQ=;
        b=Axp9wRZ+e/oumEA42YCRqL0Q+Co9wTtdn8Ap7p4gdg9xSBoQxEqHX/BzUZZbGGDGvI
         FUeeq4hEewZ0X2lz1VnbkNk5rOIjrkTmNrDB7mCvRtMkZIOYhgHnWp69wM1uzAPuGLl+
         fYs1ZpNiMAijEUs+WGlxmCOLdHpUchahGY0STO0WEyKgDPONyNla3KU57SOxcEDobGK/
         3GXdWuKhx0+cJ2cz9O8rvHwPGmQx8rMg/S8+FsF4cZj3qpp6xPK0kHEBfQ2wshm/b+GS
         L3rtKc1sedj2ZBDvXvtEafKrvTOxJsG5HUBE4sFNGzcczqXeE2oFpFnInvNlTXji+AnG
         45YQ==
X-Forwarded-Encrypted: i=1; AHgh+RphkXna1M66wbehPVEMgtNkrGgjGyGQBYoSMIZM4n5IIaQnFOO9rOIaOY40XxS3CCaYaiQ+qfk=@kernel.org
X-Gm-Message-State: AOJu0YwMHhjdC3befzSj0dmh9MZ2bkMER5hD6m++IxWK3GrdfHMLsXOZ
	BOP+dcKxje1excHKUP1gyxR25fMCfcciETkB0COwIa7tJeBQHzMJYv/d
X-Gm-Gg: AR+sD12oYGkPZyNHdpvj82cd/z/j45x9zfaZDt0qvfOO8p0swgV9i/+iOsIFdLDn4yM
	q1K3o5IBegysYr4/p2WYipoKvYFaAEoNRhttHpYQuLqD94VTw4QbHSWKrKfKXPguuCtdY113nFM
	TNWTLQhOwCcFreJsj77JM1IsXM5QU0CGQfcDB3pvyFh4oowYULzBnuERNjwf9tVyWRKtarhXKF+
	RUECxG4eXqAL1DUfpcI1g54pofP753kC4fESd7C+8RtR03nrorV9zH13KtOj3Cgk+30NwaqqsrT
	1Ye/44uvSfuMUNPYjaAl/TY6fpgbjNbOBJ6pCq+1DvreiotI7IW6oHzoBiYKfg/5vmotI01CDX6
	EpR1Dopym07fqXiEpsKwrMbjdWYS7GprOGn6tUnQLefna5GMBBSU3R104kb1yzaw1cGtCvCulBf
	aJLeTDrqBQU4JHviVrMIa9Q7RwpGOf8Yu2RoLQWz5aIIZUvqQq0sJ4Kv7sL+3iq0IKIA==
X-Received: by 2002:a05:6a21:4d05:b0:3b7:aefe:4367 with SMTP id adf61e73a8af0-3c900550e54mr1850280637.33.1785402370615;
        Thu, 30 Jul 2026 02:06:10 -0700 (PDT)
Received: from Default ([2409:40f4:100d:2c91:aff5:d71c:30c2:c60a])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-31504b67063sm20269128eec.9.2026.07.30.02.06.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jul 2026 02:06:09 -0700 (PDT)
From: Jeffin Philip <jeffinphilip14@gmail.com>
To: leitao@debian.org
Cc: a.hindborg@kernel.org,
	jeffinphilip14@gmail.com,
	linux-kernel@vger.kernel.org,
	sage@newdream.net,
	syzbot+8358d1f3d9c15bdf1c9a@syzkaller.appspotmail.com,
	syzbot@kernel.org,
	viro@zeniv.linux.org.uk
Subject: Re: [PATCH] configfs: fix race between symlink and rmdir
Date: Thu, 30 Jul 2026 14:35:49 +0530
Message-ID: <20260730090549.11930-1-jeffinphilip14@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <amsLTqLR1I9LOyN2@gmail.com>
References: <amsLTqLR1I9LOyN2@gmail.com>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Thu, 30 Jul 2026 01:30:03 -0700, Breno Leitao wrote:
>On Thu, Jul 30, 2026 at 08:50:40AM +0530, Jeffin Philip wrote:
>> From: syzbot <syzbot@kernel.org>
>
>I have never seen a syzbot fix before. Have the policy change and now we
>have fixes from bots?

Hi Breno,
Apologies for the confusion. That was an oversight on my part when pulling
the commit for testing. I mistakenly forgot to remove the From: tag in the 
commit and ended up accidentally sending it over.

I have tested the patch locally and will send a proper v2 of the patch as
soon as possible. Let me know if I should drop this submission or handle
it differently!

Thanks,
Jeffin.
