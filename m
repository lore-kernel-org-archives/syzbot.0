Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.45
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792772504;
	b=neng4LxYAyUeieTkzCdBG6IGvjpgCZN0YwyYOIxBa/ZvJSnmDsa30KAaisiSgDHZN42q
	 6+vibXgJhO+4Rs1XYRTBWDFjbH4c8VLqN2Aos/jnALCWUz1JlXIZlQQ+16AF6nLtJNp1H
	 +FCAoSQFLD3AIT2XysUpIwYGM8etv3IWUvEPG/xUupBtUwhinraKAkbfu1SduE7c/OOZE
	 LM1LH9YwWWa/wmSkvanXXv5WHD7Vjy4xhTSp1sDQE/cLP4M+mVhPON/CSW3G+FDxk9Lgk
	 obSU5FrjsA1A8lfQT267LXMkZjpOwOS1u3whE8nqqhLF8pG2fxqeencIsE9fOjKngbg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792772504;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ObpDvAOX1klXfqsSNdhdP4hJ47WYvmcb7PIfyXC1CRw=;
	b=1Yav63mEWxmp+99IlsWCqLaCeR4HSSNOQtx5XvAk+NovsE09fTcYgyFXAKEfHppYgv2A
	 onPIbzDBU3zOZlAR/WtBCRz1VSZERQ4UjveY/+37hp+WIrwwr+uqgjF1Ob0mn6xhZYIKF
	 gvYLRI5oFdWFuNMs0/+6wKxFcCyzKd3Q3ifeQAHsaksGUfrNCY7FeRyhapoFD7Xu/GVra
	 JgqN4RLxXkEsfqDqmaXpo8s+DnOLgz4DkHsCqSRYByIfjEUqraVfE/FbLDTKPlPwIdpUO
	 lK2UFmJJTa+ukEyxJqRjfUF4HYG/Pbu5WaU4o3WARJuaTUz707teM4wvccAsEvuG5IA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=SKkxBXc4;
	arc=none smtp.remote-ip=209.85.221.45
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2786606A31E
	for <syzbot@lists.linux.dev>; Fri, 23 Oct 2026 16:21:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A2786606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=SKkxBXc4
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-487049569b6so643253f8f.1
        for <syzbot@lists.linux.dev>; Fri, 23 Oct 2026 09:21:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792772502; x=1793377302; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ObpDvAOX1klXfqsSNdhdP4hJ47WYvmcb7PIfyXC1CRw=;
        b=SKkxBXc4GedY4s9TjPejwb9c/WIwKnFTkl8NgQc+/w31VaHUpyxU8vjDjdDrm1IkEb
         eBi1kUXUWO9qnVWy3sOQWXxwqxfQt0B5DMjL62G+nIXEXZMX/UjuK+ooZx1N3qMo6g7L
         gN/DZ+TU6NjeX/Yb0T1RSWcKphKIN/On2b5d2cSRUtn8LV/4A2lNqzxYDF71K+NTxgQL
         PFID9h+Ayobm8T1hZI5zfkBxJc0qcCfCajwfrrgAxjqLoOzU3lkbTngmBpE9L9/pQ+Ig
         gerhS4VXVFFTUi2JtQkXQxtPB+rv6rs1v4XssF7jSiWmnkX5ohr4hVO9+bx2Q/vmf4AY
         lpiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792772502; x=1793377302;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ObpDvAOX1klXfqsSNdhdP4hJ47WYvmcb7PIfyXC1CRw=;
        b=Ri8kHVLqdiLBRbh5jhXsmfx88IFnj46kAcgOgVKi0xOehmv/+61eAf4qPijtwPjPPU
         kcI1ITigILTyyMDLTQuPATK0L8S4LM+YDwf5L11znRRdc9FSqYZIh37yuqQUIv/fhR7i
         zxL6vap9msIs3DZtQIzKGLSLOwNYXVqvuRr476M491W3nohUKPKKVsoQNXjRfrKFOC9W
         AsV+500ixQcUo1tRhjPCOZmYYh2ag26XyQMjHfvvA1j1HH47xvChKATUZncrLypzmSDF
         lrHQLAS3Mn9um2fsDpbWrLW/YYX9gfTWZUv4wxdKZZTvBW8L2RinUC8HD04gNjYX5fR4
         MQNA==
X-Forwarded-Encrypted: i=1; AKwUvBySCwaaj1dJaECSHnvzlYZzGAp2OLU1l/8g7KtBcI7Uu0Q7WWqqJKlWRTZFDYGM99FMd+jC7Ms=@lists.linux.dev
X-Gm-Message-State: AFq9FYIKpJ4K2vyygdc8BYskatj0KEQTxOoqd2dWaS1GOc1pOmfzbm6R
	/TrEyHlfAbFmld1ZCA3bpPAlH7WC3X9ZgPGx/eO/PiHUP8WVkmh2Aa9K
X-Gm-Gg: AYBFou2WYsuGzvLYOMWvRtVS68uE8EMPhhJ43A8RyQUbrr2hmAF4rXmrTknLsGw7JDC
	VK4gqbOixnG2MdeHiDT9OnQy34qtuXgXaEkHEeCexQkR33JejTHGEM3O/GQAGqZtl1l1rvsenxI
	CFdgOAZK2nBlRU1iNqu2C/1eeWpm0+EWsWcDZby2YwjTlvhareApoXid+G/HMrQDXkroYtViyKn
	xSD7iiaRx494c2ewcl+GVUBl6NnvVl7Vrp478KADVzqAlD0wqp8uqdCGFudnQ4DyR32Ez7Zill4
	OmryrPPUnkC08mPwuTlRy+gRHMINA/acz5cvZxPzHBN1es5absHProkL2SjlQ4r6ftOq23YYwQc
	zXlPOTL5eiRyddn3LAZxk1wByi1KYBRnJ/JKlgzNaUBC7g6z6/Eja+k9k6iwsH/h+oS8qaazhd7
	n7ZlbbaF4TAlzVJwBI1qVSyYDrkY6ct6p5rHolo6ejdFG3ImMC/BlhGdxAXNio4zrjve7M37T1/
	2tfKxkA1rH8Z5Dm+LnucnqG3edsID7jZWIS4kVpDlM9FDtJ/uEqzG6hKjsONA==
X-Received: by 2002:a5d:64e3:0:b0:487:106f:ee31 with SMTP id ffacd0b85a97d-48e385a6690mr4354135f8f.27.1792772501780;
        Fri, 23 Oct 2026 09:21:41 -0700 (PDT)
Received: from deb05.proceq.com ([213.160.61.66])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e3d37ca2asm901583f8f.8.2026.10.23.09.21.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Oct 2026 09:21:41 -0700 (PDT)
From: Mehmet Fide <mehmet.fide@gmail.com>
To: Krystian Kaniewski <krystianmkaniewski@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Neill Kapron <nkapron@google.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	linux-usb@vger.kernel.org,
	Brian Ellis <brianellis@gotenna.com>,
	Johan Hovold <johan@kernel.org>,
	Jiri Slaby <jirislaby@kernel.org>,
	linux-serial@vger.kernel.org,
	syzkaller-bugs@googlegroups.com,
	aichao@kylinos.cn,
	kees@kernel.org,
	linux-kernel@vger.kernel.org,
	syzbot@lists.linux.dev,
	stable@kernel.org,
	mehmet.fide@screeningeagle.com
Subject: Re: [PATCH v2] usb: gadget: u_serial: pin ports while TTYs are installed
Date: Fri, 23 Oct 2026 18:21:39 +0200
Message-ID: <20261023162139.3308-1-mehmet.fide@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261022091359.1187468-1-krystianmkaniewski@gmail.com>
References: 
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

Hi Krystian,

On 2026-10-22, Krystian Kaniewski wrote:
> - Do not carry Mehmet's Tested-by tag because the registration ordering
>   changed after his test.

Retested v2 on a Colibri VF50 (7.2-rc1, ACM next to NCM) with a 3 s
delay in gs_close(): freeing the line during a close, opens of the
retired line, re-creating it and 4 add/remove cycles with the port held
open behave as with v1, every port is destroyed once and there are no
new kernel warnings. 3000 opens racing 30 creations of the function all
succeeded.

Tested-by: Mehmet Fide <mehmet.fide@screeningeagle.com>

Thanks,
Mehmet
