Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4F0F3E022D
	for <syzbot@lists.linux.dev>; Wed,  5 Aug 2026 07:03:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785913416; cv=none; b=RVOq+MftZxystOOnYLybsuYjrhOk3q5nZmGUlgYsb+3Su5xfX79po+0JmVtYWSn2xSyKjuB+/0TAOORc1DZs7AQGz6ptr4iiN4yUqnUu53/qPqVHqbGp0YFN5BGvabFEJH5XhYq+0zfFLjNKUP/OWrpx3Jy0lig1AMjE9fvZqgI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785913416; c=relaxed/simple;
	bh=OQJKeOfZLFHD04F/YZRA1CBnza1mHp8Fykqr7PvPMNI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vF/mBOW7zXjTvy+ggjGIF1oUa6ThET+a5A0EjdmtXcYtE3/+fsbzUMv/v7NgdGtsD3N0RaFB0w07WCscdOy6wG+lVqusOHk4pe4VHShct0XRCVQNf30MUHF7QgUbS5oWsOwQC+Zfk/Ft05pXaW6gX08/+XunTPNH6CFJjP2kwws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=R5gg4WbY; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="R5gg4WbY"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2cf6d65d8a7so9746865ad.0
        for <syzbot@lists.linux.dev>; Wed, 05 Aug 2026 00:03:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785913415; x=1786518215; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=OQJKeOfZLFHD04F/YZRA1CBnza1mHp8Fykqr7PvPMNI=;
        b=R5gg4WbYzX+3nNgzneFV3fO05gDcc3T34mIqsf70h/fnq4Mb7xJlqNeMA7FDejZyvm
         xD1RFwNAkD9F3Pu64g+n5wy2mcrt/yS9HEC0yMC0xpT4/ONo+DRQnwhFpCNZOj+wvZux
         0JymM56qa0X+TKLTc9M3smzim7KN6vC9lx1CD9tNoIV1zoLwGN8ZSvVbGGaJo5LCpxgQ
         3IBL/TbaCuaY0CBL/wUntUMpVDp6oWoDxLEv+Kw0THy+TiIlaSvQIJLQsUYIHrZl29/5
         35e4nfOOTY6nnLrILciGMgQWSz7R3vDiPhBdq8nLGezYtaGrPcKriMXszgMw8oIWBswI
         sE1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785913415; x=1786518215;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=OQJKeOfZLFHD04F/YZRA1CBnza1mHp8Fykqr7PvPMNI=;
        b=ZjWOuj4HeSwe9W9ifS/YirI0VXulrACVQqV7vOF5YchLVhMvpLB56koNqWuU7ku0Xj
         HWoBU74CT/4aHpquXNVlw3N/4tZC5tNJRPnxpUk25FgGT0UbsHzXb/t4CMJPqp6FZxmp
         dYetW4+wEI0vY23u282/oaM8h7eebm7IwMPIqd9EZQOif5wDgLmk6VC92tFA6GnXXOr8
         v4SmHjdP16AtsuEPYPwWqG62S3PdmLsVpqgm/UEHS6WjdVAEMPNB1ARQKRnLXppySe6I
         e+5+OyhfJNPWMcJYuuWwxx67SvONrtBCz/O2P6SIIBtX2riGTxjK7Ik6G0oLt4524Wl9
         MX0Q==
X-Gm-Message-State: AOJu0Yzc29wPp1Q2B3ucc3yASJTT9SIz0dONiZWvZ3YzuXeqCFpbYto2
	37NrH269HbNX391qGrotlUBPvBFF9rzvdAVemqt2PE7anRp8wIkgWg9WwqATmQ==
X-Gm-Gg: AR+sD11imoLnonCfKhb4JO1VVfVmiYmFGnoZSBJBm0oFEmjz8W3r8atTplJfsocRYpb
	+7lCvFeiWYrrtArIyG22NFNgOjTgG62vKUfNkZdoc9VNJAvlwIf9CAXwk4KjdbqQBjkRPlNyq6J
	7rBlK4Hlk3BwUHbFiVHmTdobKBfdEcUEuc66lhJ8YewZcGNi4FB27Hbubcvs7cvrbWB3I7Zbuar
	T4X0NT+gHrtKsuI2rtKdzf3+N9ZQuLJHTbbpdYHEP8keX5IFZMBPplCGNQKrwVBy+jJO5unZwBm
	Ebb/oI8qf9bwIsgU8Z0W2vm3EBcSFGJRUZcJdtxUdRJTKf2Vs1WY8Rf3EVSeakVv6jPCf15HoQU
	jCSP2BiuNSZX577XPC/4iCw0L1IauRH8J13Zwt7jmp7PSi7w7ksiVoX8ppulMFDnGo8REyYhQeY
	IiBpNV71HS+DR1kTBE0FhamtFHLCAOX9WxFB+3I0IcEnfYjc4CpCTnqHOBChmWdbKuQMqe+ekC1
	Ub1
X-Received: by 2002:a05:6a20:7283:b0:3c3:bbe6:95c7 with SMTP id adf61e73a8af0-3cb85e2b458mr4686754637.17.1785913414902;
        Wed, 05 Aug 2026 00:03:34 -0700 (PDT)
Received: from Default ([2409:40f4:10f6:3022:af2c:e3f6:6996:3cd7])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-31586401507sm12333306eec.9.2026.08.05.00.03.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Aug 2026 00:03:32 -0700 (PDT)
From: Jeffin Philip <jeffinphilip14@gmail.com>
To: syzbot@kernel.org
Cc: syzbot@lists.linux.dev,
	syzkaller-upstream-moderation@googlegroups.com
Subject: [PATCH RFC] firmware_loader: Reject 0-size firmware in batched requests
Date: Wed,  5 Aug 2026 12:33:17 +0530
Message-ID: <20260805070317.132039-1-jeffinphilip14@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <3a4d5500-d967-427a-a7e1-f8c69fad4cfe@mail.kernel.org>
References: <3a4d5500-d967-427a-a7e1-f8c69fad4cfe@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

#syz upstream
