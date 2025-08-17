Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F6052185BC
	for <syzbot@lists.linux.dev>; Sun, 17 Aug 2025 22:07:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755468442; cv=none; b=SSDMOuQWjymR0CZUKfI/Gb6lEnqqJ+QEX9lLvO5Yf6ORXmaezlYcwugWHusGeOIRnlSGVZmsBpBGIYYT2/X5KduW+cekFxSaJcE0jSFoYp/9wNo5AQZJ2mgF7raDSoczIMeOcYwRRa9U+hJLx4fErI9AO5HUrgE102yczleQj+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755468442; c=relaxed/simple;
	bh=OZFpk1sAprio5MD5YibK4LuxYV4cuBbHgxDa9Gldct8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cYVLOHSxEeL/78UHE6O5H0C1Hegcv6YH3rL3IIQtWslt2io7F93t5dlPVPgH7juh7Fpt1XXsYVvEG1EZqH1P4ft9e4fY9gbSoiNBh5/rz+fV/jPw26CpcGODKYeSliN23xGFBxi37MDN6q5bzRaGsluY1dY/rSDpcC17/yoyBYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=B11xlaiJ; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="B11xlaiJ"
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-3b9edf504e6so1598601f8f.3
        for <syzbot@lists.linux.dev>; Sun, 17 Aug 2025 15:07:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755468439; x=1756073239; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+4TW3KyyMehJGEqo7XJGATzLA+dXwwdrg+uaHD6xWZo=;
        b=B11xlaiJSTmNjrfrKOmVNO19V5EeKJx2JcTq5IUr1CN650APGEeRp9LvPdqzNXMJtf
         0nhImdcDI5pvC2ab27Ju44L9A2ouvVJJSXod7uP6JqqbJr/y4q4xK7NnB7maR2fJdxpu
         mSfIaIrtzqTmBk3q8nb7goQCyllkeQW4XyyUzIIGUa8MsRsNhfYthvJF9KbQ/QvRcXa2
         7W3AOt4drYYpGwtFkmZCfiyDGWHxLkO/jJpnoS03dF0I54BOdVxIGMVOEAKpSMK0/deb
         XXKLmxwIYbuoLvJhnsPco1McHHAG1cHhN0cwDyioJ3sShk8MbDThRa1XMvf8ORZWuRqC
         q0Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755468439; x=1756073239;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+4TW3KyyMehJGEqo7XJGATzLA+dXwwdrg+uaHD6xWZo=;
        b=qzioQGi6r3QjpCXw23BQYiL0enN3ZcyWTIZvdPYV84DPicuDFP2wXEdRm5+IOl5jHE
         fjhW4jlyCkvBQa8PFXoF6ho4Mm0bdj6qnab+UCI2wn0n2MoTiH/TgemboZ6zDqFx3T6D
         HWxVW1Rv/Ua0KKFMBjvK1rj/0ZI3STZxCFImyFj4SBQHwpnOAceMsGIjzolQoivbkUF4
         tZk2gU7Q164naXcbhQlyjP8AEF2j+j6MDue4iTMPuv/nVIwxDI4XX+WaI8tF2Tgor3cf
         NpGQ/76sRXaJWZqLQSFhiAa0o6jA73DPTUsbpCb6or6wbK6NUYtA54I1sFl/Mmqofz5j
         a4OA==
X-Gm-Message-State: AOJu0YwrhwR/Nt7sTC67btgCr1bTmt69vD40JtICt/+tWnwTxqS4HcyN
	OYs3XSbeJO3SgbAwQHpJcujhqRhVy2qklB8/vqLlJu0xcogLdDV951JI
X-Gm-Gg: ASbGncuhh6t5+NNMP9CsJplZnDZcHdWLx1o3CsYGX6P9CRwhl6ercpl+XzTtvj+J3nO
	duAA63SPU+FHLkt9nYrfWITKtobdntpv8V8G/3DYlYDiYG2k8WENyhVh4/ZROQ2c7IX0skcF/uj
	cDhRT+uIywDe0aPCHI+4Vdx0xVTBDYtucYa/L4rC2RmYYAYep3cLmfiHEvQ1HgOfwKQJg4eiKus
	maekm2oxdTE/o9/yE/Uxd99Env7ewoZke6atOlAXs6t/SqXwYuB+H4WFKxD1w4zTMnI2Ce9w1FA
	x/7S+s9CpxrQCCamnrsYaxDWvQNzOc6bfDrEPu6MSOuZgSyVmLGEYggfVoEH68XzPdIniZG9RzJ
	RP2UkzHkz86hYbchyzrJCCOOUslGpzW9uRrIoC0w3
X-Google-Smtp-Source: AGHT+IEWNfmhEOrUkMkj8FGnjLO4mUdcinlE7BpsjISMw+YOANRnlZOQHiSFZ3raxtH54WrLxcuVNw==
X-Received: by 2002:a05:6000:2c04:b0:3b8:d0bb:7554 with SMTP id ffacd0b85a97d-3bb6617ea0amr6420068f8f.7.1755468439097;
        Sun, 17 Aug 2025 15:07:19 -0700 (PDT)
Received: from [192.168.8.100] ([185.69.144.43])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45a1b26a3dcsm80185505e9.2.2025.08.17.15.07.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 17 Aug 2025 15:07:18 -0700 (PDT)
Message-ID: <873ab36d-65aa-481a-b056-8f475a56b5e7@gmail.com>
Date: Sun, 17 Aug 2025 23:08:30 +0100
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot ci] Re: io_uring: add request poisoning
To: syzbot ci <syzbot+ci13e386d4235544e2@syzkaller.appspotmail.com>,
 io-uring@vger.kernel.org
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
References: <68a03392.050a0220.e29e5.0041.GAE@google.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <68a03392.050a0220.e29e5.0041.GAE@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/16/25 08:30, syzbot ci wrote:
> syzbot ci has tested the following series
> 
> [v1] io_uring: add request poisoning
> https://lore.kernel.org/all/b98edbb8ec4495b053dfb11cb3588f17f5253b6e.1755182071.git.asml.silence@gmail.com
> * [PATCH 1/1] io_uring: add request poisoning
> 
> and found the following issue:
> general protection fault in __io_queue_proc

It dug up a hack poll_add does to initialise ->async_data. Not a
pre-existent bug, but definitely one of the things the patch is
supposed to uncover. I'll update it.

-- 
Pavel Begunkov

