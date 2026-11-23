Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795445093;
	b=1oiduECR4dBEoQJuy/Ho6dTAs2R1cp9ZuuIRO4ofFBCpFETtE++TVKktF1GPapYpX4kf
	 hAZHsmLAq1T4OHR6M57fzR68guG0SCusGKRdQo8ahnpECQNFxm/mnVnz/iBJx4MgvO2DT
	 CJKgbKEQ+dher/d5Ca+ejacpHhM5jOC70aKEtnQekymQ7kL/h73IXVT/KhAlWX4PvvPpi
	 zzCcs6XdaMcxqH8mq3JyR0F+ZC/OJ/F1oOh//em51ajRwS9tiQooji3K1RMCDFiBvuALw
	 fhw+DKSMwdM2yOt7/GCn3HHp2zypcdi4enjewG4x95hH8yvBzX4rzR1exsK7/LWVWow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795445093;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=Y5ucrZO/jejtruL7fxSeeuVVyWePaAW5207TyTdtcK4=;
	b=sqVXIQVtIIF3FEPeOmVUg2SdmYwBiQPLlCmbziT8HM2ssnbDGF4xUeACgekM8I0GuF7t
	 9t5ZkEDzJdeOuEGCYPhWrVBsGL8ADe4o386sAOdeYVFKvZNnEhIXJOnKwIV06EM+9hVlL
	 7d2jcYay5pMljyWIWcx33FbL1i00KJ0USyZ4FH2WW9kdnq5hb49ZFDA1QSay7ZkTBbQMj
	 r1678sMy+ZcMEnqgaOYLyeWh7j+FjI0aSZVkS3z7va0YjT9m3ZIlLvpmcQQ35CtpL8keo
	 jCGOzN4GyMyd+usdk1oWb8x7cYABVrLeqSExWcZFeUYKWrmsHwzuWSDhOukPW+QMrbQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=TopCg0hM;
	arc=none smtp.remote-ip=209.85.208.42
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A3FD606A31A
	for <syzbot@lists.linux.dev>; Mon, 23 Nov 2026 14:44:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1A3FD606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=TopCg0hM
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-6b86bbce3d1so4419288a12.0
        for <syzbot@lists.linux.dev>; Mon, 23 Nov 2026 06:44:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795445091; x=1796049891; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Y5ucrZO/jejtruL7fxSeeuVVyWePaAW5207TyTdtcK4=;
        b=TopCg0hMZ5OSZv5WqcFcIbUfOKdkv2tXNyjnrYU96/FYISvHg5F1J1mz6RoqLMitDs
         2TNwl0nNtOraKoDxJpaw2BYh96w50XeYK3qN/nHdLC8+BaDyNWJ6U5wlW24cY4/ivtl/
         +9sxO+3Ke1WnySa0S5q25gXU8/r/AJ9KQju3OiJocYF4tZHbO60lLMHwIzx1MO+ZUsIA
         BxRUFQHdq6YgydjByrKJLi+B/NN3iGfn7S9tdN5ygi6WEeo/LWp8yobBpS7XwzBbzkL3
         pCieTErgB3hreUNZIiOzCcZ4eqC4crcpBxr1mXe2kJ6/FwP/Nbj/kBqjwnspyuvFBD38
         LhEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795445091; x=1796049891;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Y5ucrZO/jejtruL7fxSeeuVVyWePaAW5207TyTdtcK4=;
        b=JdZQirALUdjl+v/R2o8/A0/qXc+ZpXjeRfOi3zM+iiiNkzznt1qov3vYzG0nS0lkyE
         NQFKlmr4Jmv73olSomC71TgTa2vcQ3A7VwKU2uu1482pcIpcVarBVAlxGJr7vWlRyLln
         k4EVkJXNfFJJaI3hdd2zKbihlfzpPBhlEXKsU2H4T650qKacgL3MADSBP1Ns9ecjO7H3
         HMcp0hMpdO4C4rIf8EvLj1X1g+xrgQvneFDa2WPRwWGC7LbpjJ4258lIpaDFtI7ipnlX
         OJkip1zPRPpwthaCHT0CbZONf/Nw5xTKcc9irc3V+icmW0Vxm9iNGwgMtLH13GZs5XFx
         sWlQ==
X-Forwarded-Encrypted: i=1; AL+hErENZsn3uKBvVm60L0P/00EqoaSY7n4VD/VA7Em8xngJbx5KfsnEbSatGePO+3D0bZTRQ2/kuPY=@lists.linux.dev
X-Gm-Message-State: APuU4Z+rpvh9WbqSqsNo8hCAut9kOCNiHFEUjRe9McfIgvPg77slaDC9
	GoXE9MMqxPu4heW5oxEi/o7O8r50c870B+O/I1lLsv8kgo/QC5oEJ/yx
X-Gm-Gg: AZFdTZcexFERl1ixv0KHtoi1ICMuZ3QfQbmbNItnyiBm88yI9fMwl1dBMOkAQ9jxSro
	HrpY1yXv0TYo3G1QUC8K7RzgyQiSPY0Qasgmemnmn+2hKGyy0vEr1por5JKxGQQ3dpK+A3t9oII
	IIJZxFbQucs7mhZH/qMkuw995LDIdNbO9IIedar2cuS1t7WH1GAxCSO437DLEb/e93n3E2d+W83
	nlTSvY9ttoMdYj5pxg5hPW06ixL5XLEHSx8Drrl1euyxaxqZGSxX3BChUF84ChidmpHFMbrX5yp
	nqwiA+cW7Z24JgzMKdvsFUSHY/KBQF/hKy6OwyxmLWu3Io4AmilA0WByOjpL/N5fjFV7X8jx18s
	6hhMKM8VN4v5aREeqgilSMwsNRDQmxIXmm68HXUD+4J7/OIpIU8L7gsPmUW4fcagkSW+kfTJXsM
	D6EbbQuJio7Illj7ShgzuSCTN8RTjZ8HP0XZQcooXmcJyp/1d/qzGAW2JCD2CNi0IOoNmo9oe5K
	nYGBSewg4LjblSZE/rVZnD7GKGI+U5cIyia2GJWHzJ1UqTYBEpTXEnH9IVyMq1a4vr3sAdsMciR
	1k5Ufghsr+CNOMOU90t4Mm1+AjgCR8Afj4c3SD8CdHduhu9kUdS5zhZhmGUDbTQANtAy6sRy81t
	oFviKaKuIQZttOY5nG/86hBkT
X-Received: by 2002:a05:6402:c887:b0:6b7:8444:a456 with SMTP id 4fb4d7f45d1cf-6ba37ac9ec2mr6235009a12.0.1795445091161;
        Mon, 23 Nov 2026 06:44:51 -0800 (PST)
Received: from server.tail8f139e.ts.net (185-164-142-169.cgnat.inetia.pl. [185.164.142.169])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6ba36e35636sm5500060a12.2.2026.11.23.06.44.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2026 06:44:50 -0800 (PST)
From: Uladzislau Zhauniarovich <uladzislau.zhauniarovich@gmail.com>
To: syzbot@kernel.org
Cc: syzkaller-upstream-moderation@googlegroups.com,
	syzbot@lists.linux.dev
Subject: Re: [PATCH RFC v3] md: drop a never-started reshape request when stopping the array
Date: Mon, 23 Nov 2026 15:44:49 +0100
Message-ID: <20261123144449.104164-1-uladzislau.zhauniarovich@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <fb44a7d5-0913-46d2-bc67-4958b18ad923@mail.kernel.org>
References: <fb44a7d5-0913-46d2-bc67-4958b18ad923@mail.kernel.org>
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Post: <mailto:syzbot@lists.linux.dev>
List-Help: <mailto:syzbot+help@lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
List-Owner: <mailto:syzbot+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Thanks. The diff is final: v3 is byte-identical to v2, which I tested.
Please keep it exactly as it is.

One item from my previous mail is still missing. Please send a v4
that changes only the stack trace in the commit message.

The trace was not replaced. It is still your own trace, with
"raid5_run+0x2550/0x2560" and "drivers/md/md.c:-1"; neither appears
in the syzbot report. Do not take the trace from your reproduction
run. Replace everything from "kernel BUG at" to "</TASK>" with
exactly these lines from the report:

  kernel BUG at drivers/md/raid5.c:8117!
  RIP: 0010:raid5_run+0x11a7/0x1670 drivers/md/raid5.c:8117
  Call Trace:
   md_run+0xc2f/0x2510 drivers/md/md.c:6779
   do_md_run+0x36/0x660 drivers/md/md.c:6880
   array_state_store+0x9c5/0xcf0 drivers/md/md.c:4765

Keep everything else as it is, including the Cc to Yogesh Gaur and the
Tested-by.
