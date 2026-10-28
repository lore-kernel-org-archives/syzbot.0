Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.54
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793151775;
	b=YBzl3oZXbdCf3yhZy8jkCJ2s+CK+bKgghHPjYEQtaGL97RscOBYptdWqwy/WEqR65KiM
	 SX96pq5zMTVs/uRo5yDHtvYtkUD5Dj2mmwgfseRpQcuSwYEKP+np+Qd2POCjxE/2NA+dl
	 g3TwxZR4+MeQ+bSCTVKV0e7tkMncQwKqMbZWWYONbWuuy6NCUn2u3S96e0VBp4yUWn5YR
	 ErJ0G0bKQbRgSE2g3NZDmV62x/R3SPwrfaHnnWIRXpz8nDwge1uKYaSGxm7YK3tWiV0XS
	 5mcGvO0J5gqYIrFo7pftiSwD35TSOAPkhcWha1Z8GgWJLZAyKBU5AtFjih32VHzr3qw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793151775;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Date:MIME-Version:User-Agent:Subject:From:To:Cc:References:
	 Content-Language:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=F2b/C//SFL1IpqmZ4dlyGzFHOKnAQfZ+yoE8clPtWLc=;
	b=SMKRgSH/JtK42dXhIByzeGrkcVErX/KNZVvMWT+TO1ag2Jb+ZiVTec2ULirYi1hSxALN
	 jq/9w7x3aFVFBrTLSruIIVo8CC+8Rt8OhTuMeqb3UdoSmoPmXwwEkzZFnEnQN1A3yKI3V
	 lLYVjHBbL/9YD6khEiIFGpVJVjFytLONKAQyEoZ1PJKo2R6r6hPTaqFtbUBqwRmc2Kzy7
	 ODt8K+c1GDCjzPxh+4IJJKJOTQQsW8DiiZEXQfrw6LlIphSL3rerjNFqlQfnBwYmaOeFo
	 cRZyQeXqNeROk0BZCqeTuxsG2iRJqZRLEsrpIXRPM6R2RE2/5JMrr1tnLdZbwcAUdPw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=dvXVnqDO;
	arc=none smtp.remote-ip=209.85.218.54
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84118606A31F
	for <syzbot@lists.linux.dev>; Wed, 28 Oct 2026 01:42:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 84118606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=dvXVnqDO
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-c411e139259so37169766b.2
        for <syzbot@lists.linux.dev>; Tue, 27 Oct 2026 18:42:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793151774; x=1793756574; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:cc:to:from:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=F2b/C//SFL1IpqmZ4dlyGzFHOKnAQfZ+yoE8clPtWLc=;
        b=dvXVnqDOMI58WCoZLVYj5NUCRdx4/mm8bqpcg6wX82WdqUoGbG9Z3GyS94qOWETSCi
         RDWUo8XPUlfwZNnue5uJBm3eTDXOIEF14UTLxhmHLoKMWUGqGrOmqt976hXVqeFPocdp
         FhkGIsS97Orm6m6Yf6USOc4yuLXGjEtKtzHud+GwsQYjPqeC7UJ86yiMXFPhnwhr+A+i
         DvUIQdbPZBaS4XzBWt7RrnlIbBYKIxnvo1u4bJRjYoQgsGdVyoQyR9UKNfFtoLdcKZlj
         SHRETacV48ZzOUMWLevQvBndMC4YvWj8F4+HQsVKC4rQ1L7Ykoxud7mMlmyyl2N/AuKq
         mbQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793151774; x=1793756574;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:cc:to:from:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=F2b/C//SFL1IpqmZ4dlyGzFHOKnAQfZ+yoE8clPtWLc=;
        b=h19uJbO8NI0/zbfbl6v+AYtKePBignUzPFd404K3M30Flic0TqfAmfjX+r9qhn9ET3
         FrR/qErHssM4w0FeMfzhlWoS/qfRPwAHF+f/M4l0B82yZWc0KVFiga4+QbixvRWIILNI
         MFfE6P0UX9LrfIbnlcx4Ay+By93geSj3GHRQV1AfqFy5eu1YlSORENw/AqFInuelLRsz
         la8XRKtFc7nLLod336BOsoF+dBBlNBGEz8RxbZIXSvo2t4HlPG7+LGWi0cpSFvx4gNkN
         SdoNXueJzqJKzzqmtUZ8S8q3+XTy9rVbIz5v3ib9ac9a7DZ1wzbIP1Q0f8OFO85I0vQD
         qNyA==
X-Forwarded-Encrypted: i=1; AKwUvBx490Kn2sd+sXHQ7rzOaQ6W7tulrum+Avt6QTSLivluQ+G7WnkXpSA1m7IljHTEiuyE34A52zk=@lists.linux.dev
X-Gm-Message-State: AFq9FYJxvfIZT3PtAY5qQbo8hW52UhRRoasQ+GmOlQzXMmh/THnhNL8O
	iYqnZ7VO73bQeXVyUzXQjWpU5JO/Icr3Q8+DA5gEGHRi7woUH8WidyoZ
X-Gm-Gg: AYBFou2Nl65nbYuG6Rp/QeLv+uf2TPnumvG+pgLbBgfy3MzCB1mTaA3W/gUPg2M7C/i
	CZ5h/XwFcta2SMn4M0x6wWtEv3ukDOaLxxONWuXLmzi8DuY8tEVffVHZPsHf2EYVc/0IrhlZ7cG
	zRBAOqaabWrFbqXcLOPB/sqYuDXqi7hJ7+N7m5TBz1PcEmh1joo40+fJE290EnrX/z0GrOQKJN0
	1OHE/TYUwORHJWa7fuatuH9BD/hv2gVVhx86ehnT8Fa+4kh4syr0aV55VORQtCOjAcllq7+vnf8
	Pet8EFF6LMUdf/qe0oC5FL0DlFytdYGLF71JqAz69ngwwHKhKlOxzZLnzjiBIpxlYrBrAfWjOOz
	VX+S3UMDJ0dmpBMdAG47rGxDUFje7W9xoua+2ZKsYaq3yDorSlNed30s8rKXU8oKg5pb5SAsbBr
	bGOtz8M92N9DjNDSuFNpGke2DOzwJBNpqS//bUqmZu/Vw+BPvqYDjlpqjvJJCMsv2WtyOvpg/Ob
	BGyyfPlT0VdcKTTI5LIXu0xTVT69ZOm/YtCFLo7TC8KvHIeq+GSooE6HwTy7mDeOrOEWIHuLOGN
	eqVEa994xcqHP5+C5kg3B7cIgs2yGWO6FUVepLzsxIX9+C3B/uHIhC74rY+Kx6l5qU2D8yh6sr2
	W6A3YLZKop3cAfBkhG12Dprg844bOMvB/Zz4kaTYLdpostn4WRdZLpUKAbFqe9S4AjUAYAuZkGM
	oI7Uw3P+npP9Vgw2jZhke3bQw7QXp1HOLrKeFjmwc3Uitgn/BKe4ZhRLaWm7EocL4J
X-Received: by 2002:a17:907:2d10:b0:c3f:153a:8663 with SMTP id a640c23a62f3a-c49bdf3abbdmr75122166b.23.1793151773813;
        Tue, 27 Oct 2026 18:42:53 -0700 (PDT)
Received: from [192.168.100.100] (87-205-15-91.static.ip.netia.com.pl. [87.205.15.91])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c49a530f520sm217876066b.23.2026.10.27.18.42.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Oct 2026 18:42:53 -0700 (PDT)
Message-ID: <096b2691-238e-4f43-b5b6-e1565b62664f@gmail.com>
Date: Wed, 28 Oct 2026 02:42:52 +0100
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Post: <mailto:syzbot@lists.linux.dev>
List-Help: <mailto:syzbot+help@lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
List-Owner: <mailto:syzbot+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] usb: gadget: u_serial: pin ports while TTYs are
 installed
From: Krystian Kaniewski <krystianmkaniewski@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Neill Kapron <nkapron@google.com>, linux-usb@vger.kernel.org,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Mehmet Fide <mehmet.fide@gmail.com>, Brian Ellis
 <brianellis@gotenna.com>, Johan Hovold <johan@kernel.org>,
 Jiri Slaby <jirislaby@kernel.org>, linux-serial@vger.kernel.org,
 syzkaller-bugs@googlegroups.com, Ai Chao <aichao@kylinos.cn>,
 Kees Cook <kees@kernel.org>, linux-kernel@vger.kernel.org,
 syzbot@lists.linux.dev,
 syzbot+fe63e4d633540f230624@syzkaller.appspotmail.com, stable@kernel.org,
 syzbot+bca09f5d8b843bbf7571@syzkaller.appspotmail.com
References: <6941beb7-8cae-4cc5-ba07-e1c8a8753fe1@mail.kernel.org>
 <20261022091359.1187468-1-krystianmkaniewski@gmail.com>
Content-Language: en-US
In-Reply-To: <20261022091359.1187468-1-krystianmkaniewski@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

This patch also fixes another syzbot report with the same cause,
"KASAN: slab-use-after-free Write in release_tty":
https://syzkaller.appspot.com/bug?extid=bca09f5d8b843bbf7571

It is the close side of the same lifetime bug. gs_close() drops
port->port.count to zero, gserial_free_line() frees the gs_port, and
release_tty() then writes tty->port->itty in the freed memory. The
tty_init_dev() report is the same race on the open side. With this
patch the TTY holds a tty_port reference from gs_install() to
gs_cleanup(), so the port outlives both paths.

Tested in QEMU on the base of this patch (usb-next bdf12cde3083) with
the syzbot configuration and C reproducer of that report. Without the
patch KASAN reported the use-after-free in release_tty() within a
second in each of five boots. With the patch five runs of 300 seconds
each (about 8,600 reproducer iterations) showed no reports.

If the patch is accepted, these tags would close that report as well:

Reported-by: syzbot+bca09f5d8b843bbf7571@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=bca09f5d8b843bbf7571

Thanks,
--
Krystian Kaniewski
