Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 623C3EEB3
	for <syzbot@lists.linux.dev>; Mon, 29 Dec 2025 09:44:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767001474; cv=none; b=ewN7xbhDYNppvVI50OfsOlzKdNVyUO9uJuIp5TzGitH4qVvGqyjkc5EZJ4lCT+jKrW16FOQF+OMMnQ4sz7DXnA1ghsVvlGa23rLFTG5GwNzEmly0z+Jg6aDs+r1Xs7ERmyAaVICW6aYpRTJfhFiJ6DLyfONx473YO344w5L2hEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767001474; c=relaxed/simple;
	bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=W5ijJGux4lmHMbrhR5NYN3sS+c3cnD1ifvrjReXBlkXNa/7EZ3D2iXHgdRvZiJeuWsDHeudXprSoF0mxO0TjyDXVUu8RmNyuho463zD7RSIv+j+PAroKLzhb2aNVI4kxd9ZZGNatTQB7nRjh/cCv2Iu/CBMC/Vq/fs94MAGk/SU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=IVurruwf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IVurruwf"
Received: by smtp.kernel.org (Postfix)
	id 039BAC116D0; Mon, 29 Dec 2025 09:44:34 +0000 (UTC)
Received: from mail-oo1-f46.google.com (mail-oo1-f46.google.com [209.85.161.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 48FF8C4CEF7
	for <syzbot@kernel.org>; Mon, 29 Dec 2025 09:44:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.kernel.org 48FF8C4CEF7
Authentication-Results: smtp.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-oo1-f46.google.com with SMTP id 006d021491bc7-65749fe614bso2395773eaf.1
        for <syzbot@kernel.org>; Mon, 29 Dec 2025 01:44:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767001472; x=1767606272; darn=kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
        b=IVurruwfNQAm3vnKug37XJUF8gDP5YpIVP45SGt5boSYzIraEllopnzCl9Xv5Ilyx3
         WmsMqoopdhL3PeDzuq8PAbBUSA2TQ0lL5GKv8+Dm9todmvIJqyj3PlthhKguCcxDv5J0
         LyTCcb5H+uP/DwA20rbAB8oQ0uQhRrqU0bb7IanEuTZv+Cf43UdNfVls7cZDAr9ylDzm
         GtKdQhY5dSE+5fcV2CLVs/0aziQfOtBExv4J5Gd9qij5PKo392HRLUiYnEw9nhul5cPA
         AtCGf47PERhUyHCAtz/R5/AgL3kUf9PhM10S8paHJ4IjDVTtmFp2Xbjb9MQEQyF/bqWJ
         Nvyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767001472; x=1767606272;
        h=to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
        b=IitaBncxDFUVQkB2+6V89cgfLyZrTfpCw1PNI7bTVn97QEZmHL2GqRjfMSd6wudHKp
         NmVO6NtRcPND7KoWOQBKKQ88P/0OeGsA3NTQzEcrOCvhK2ROXQx43plNN2GdzJvbISvU
         g/iW/qpzvbRsM++iprXfh9S9Vp3eR8520MbsrzNkRHgZvq0WZJ9L+Btmwq/DGvisWIsq
         zUbefso4jZj9f/33VecJdY6/un3DhfZqLhSO0tYYzpwlvxS3qFAznyP1nJ5hEiw2lwoY
         +YeXKWkS0gDM8vlurOZ9rytauUNRt+l1EZtt57r+KnXbBZ9v2g2MDac0f1XXDfAqoOPn
         l+sA==
X-Gm-Message-State: AOJu0YxgSJ3TNG2Gqfe4vU5ZjADpdaKsuiVDHFtDovRRFsSYtJaOb+zR
	AKqyWTKbEeJO4PSjtlLMH6F4m77Zm9tssC9ke8hDjjS1f0oAc6N72WUhUhdjK/galu3pSpD8xv8
	AUeID+ipTWmkHER9l35JcbmrpTkWYPwdYCA2q9U5sop1p2SXgQ/wS+cst
X-Gm-Gg: AY/fxX49oAaVqzrDmeqBJxcAgc8l9zFK10Y6CHQQDNwLrVDe4I2YLad4TzW18XljJLH
	53oxHeE2SPfI6pDqG2kGJtaCNvP7eEPOxZFVm3xgPgsXw2mZXPVfAtvYLtjEu1fD6x/M4hv6cPw
	MYDyPEcVYKmt26xEWQQ1vxOrPsq6bnfv9KbBob//4xLbwgZevj4AxcBt+X965Xn5F0JRyRYwrdX
	XIfo9Vt6q7+Qv0Ei7h6yX2yqpTXgGHn1lDZGh/5hthuYqjIQQWPzifYYmYKr5O+UnUmy4MCWmZ4
	UhMuaskSPgStEL9XqhcD7APYYvwe2oHfziPGbjRJTZcShWjcQcYFnw1T0FDLaa8A610=
X-Google-Smtp-Source: AGHT+IGKn2QJHeJIhbt0MZepswboPU4Ioze2Z/Sy++KkeR73dEwWfn3BP1eGepjBShJtVk5pI6G1wCTAz7fsuu8tujs=
X-Received: by 2002:a05:6820:221a:b0:65d:4d4:e7b0 with SMTP id
 006d021491bc7-65d0e6b4200mr14970812eaf.0.1767001471642; Mon, 29 Dec 2025
 01:44:31 -0800 (PST)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
From: Aleksandr Nogikh <nogikh@google.com>
Date: Mon, 29 Dec 2025 10:44:20 +0100
X-Gm-Features: AQt7F2oGjYVBTPn4rE-xoV74vDC1c4ebOQ1hIPELoy9C-9YzQOMXwmx8g4JfYkc
Message-ID: <CANp29Y7-rVMGVMeHWmGoDwVzXycFw37i20zt=ftkgPmvbYE=Rw@mail.gmail.com>
Subject: Direct email
To: syzbot@kernel.org
Content-Type: text/plain; charset="UTF-8"


