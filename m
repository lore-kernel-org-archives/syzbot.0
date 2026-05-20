Received: from mail-vk1-f182.google.com (mail-vk1-f182.google.com [209.85.221.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D19DA3D7D82
	for <syzbot@lists.linux.dev>; Wed, 20 May 2026 12:17:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.182
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779279454; cv=pass; b=h17sfrk7GWSxLBDwsKfJjswTJlJJj2oeEe1/OqSIO49MUJBKn4hbKlMvVnc5S3tbHRR2kdC59D9FkonxrM7mc00NeNjy4QR6xfFfGdT5OiiAR+29DL/Oa/AIJ6eszrpOP1rXDQajzJHZ1UQNpjS/QVAd58TVeL9tkqoc9saYJ7s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779279454; c=relaxed/simple;
	bh=tVRpAENu0j4udstoaGBAp7/JNWejoykhjzLo390RiZs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=f0LLPM0DOnB3TaTltBSB7u6GvVrc3XLgzrDVl2awHd0cRhv+8FmRLUK9KxH4+YakjwzAtjAXdUKmuhpAQX16xVRSi63OfYJenJy7fEvYD1I5qzAkO3P0Bpq3i/GrXGWpST7kaw+ZG1HvPVEczK8eD39amHOqvJb3G0XRUTxxZ8g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=AjAicUnJ; arc=pass smtp.client-ip=209.85.221.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="AjAicUnJ"
Received: by mail-vk1-f182.google.com with SMTP id 71dfb90a1353d-57533363201so1397985e0c.0
        for <syzbot@lists.linux.dev>; Wed, 20 May 2026 05:17:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779279452; cv=none;
        d=google.com; s=arc-20240605;
        b=RSqSIS2BXbN/dx6dSV3YSW+UaG8cOr3VZq/uwKNVsc7Jyy+yvPEl+RoD0VNm97SpOk
         pfeAxpPM+IJwq2m6fuZuYZ+ivCNoWLzwWuV9xDe2CSb/e/RSQNdcbe2+oFIAcRp5/f+z
         UztPkLyxY9Pdt3go7SasHskf82joQlfO1ixFielSHNzFLenz7xsDH78t9R8lHlxQYkzy
         R8S81RzrIj5gWfjRFWCytVFdaStC/lhQmOULMoIJCO0gxg5OkWowebsLApKiMyIILQIr
         dHGta1aP501jw7serFHbhv2gghydch3UY+3YGVigEFJaRHjTKepSx0ghqGJmSPqYUeLR
         /FFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=tVRpAENu0j4udstoaGBAp7/JNWejoykhjzLo390RiZs=;
        fh=UskLtjCrUTpHxJK1jf57fjSaAxR3lDDzKLXFPWgsVWw=;
        b=YxnkZvB1OPiu2znRH4q6AJ0ut5qbehw+x9nvuHTeBQbarFHv7KWiVUa9DXBnBHjPqn
         jh4VVIXIkiB5BRv65pG7DSectyQpf/I9snlKkQpCuPFeHEw8nwtLGAVHh91Hz5pkxwC0
         nenaznrWzy1CWleHFDIrEop2c4A1Ot7Sl13tTLrZfZbqGV61sI98A59RGr8/TzZe2tKc
         0SgaiFGfYZyk3Hj2Kv4v+kNM4t5tvFJltIcmIs+7cGv6ggLK896Es6fBGghuZvbmg01K
         7yYvbTL9B/Cl6BkW7hZa9UThDFoL4Pd3bjhQqA6R2XS9RDGioPCoFyDlNtXpOl0ZAKHe
         9yEw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779279452; x=1779884252; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=tVRpAENu0j4udstoaGBAp7/JNWejoykhjzLo390RiZs=;
        b=AjAicUnJLxJYRBjCuJtTOuEFVuLhHUxGRcr2D5MLWR+OLMtscS6gtVlBRe3qyrQbr3
         ZmVCDjYV7MgUDhmY7GcPTbIIKqSV3SA7gurKRhgFhRaTNo3QomEUL9YmjI46pyTYmV63
         xnuF3lYDV77NesMOccvJTF5lbM0XYCsqDahMkCTUiVQn2GOlIuJcGPMsCOv4AnfcsPG1
         Gms4qPmMTML6pF5TkQdwJoTBJdxzi3/zgbZxHEoDyFFDrak4m1IaBTzPH6vKeto43W/S
         QSjVD8MGOb8WW+OBrGg8H9EE4QitR1KdnGb20AU+ZVURYus0dyEgCa29cxAy/53QaNv1
         poXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779279452; x=1779884252;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tVRpAENu0j4udstoaGBAp7/JNWejoykhjzLo390RiZs=;
        b=AEmVSfWWwkZf4SOwcemx3RIsNtA5RFaJF3aFMTyeHt5sITzudtTtJZXzrChPLMskmH
         zTO3XBFMlgn05I57CEd7XCInp6r1kDR37/KWDPs4fyLQWVZ4zoaY1YOyiXlzdTTIER2c
         pNCscBIHtvCxOfEIioDEio1qPA7bUtHpzReWGXkHlBXxgkPH0Z1U0EiBQJ75ulDIzkoe
         SQZNcYiZo7Yx2NrWdH3HOZjCyi6AB0R73KECv0xbuQ9HI1IFOwfhDGrMFUhWS60iIGe5
         6/IP/mgtqy++MfqnP1+WWu/54nKFGWEdrXgaJzYUHXruUju0XDRL8XPPG7iErs7/2RLu
         25qg==
X-Forwarded-Encrypted: i=1; AFNElJ9w96Cp+2J3NEj7IPsJGf3mwqMoi1EvsYjN7oUo2jKen/Hxhf1PdIkAL9AK92K2yNEqzMo82pI=@lists.linux.dev
X-Gm-Message-State: AOJu0YxNr98YVi+hQuWloN6jO9FWJ3d3kLEfUoHV5Z7zFnZfHPvERXiI
	PyrdKIdZpnLgI6jjeNfT8aGAOvYsBUqDIWNR0Uu3azoowVjVwBAEC2Au3nRbChc4uNlKEqDXGol
	MHwoSl5BQRYm8wJ2krWg4uW3VeCSyYpM4B8/aqmMrmhR1vgDCbxRjBVlhq4s=
X-Gm-Gg: Acq92OF3Rs/MY9vq6PhDyAlxjAfRmBCUDd+eA4uJS47rOJ/focz3LvRjXpASECMt7hX
	SsrvNsZ2h7c7qBmsY4ES2/ImANntsrSQxiCkkpe1hTTEtC3IVzZgx943NNDlwrG/aZ2DmvQjz0P
	deb78rr/uXynqb5LsSAXausQIHkfQqUjsJXt3IMvv1ZHhGiEQPvryXYI5rNC65aQSfZC05tDw9i
	mLgX95opWkr0sVy4iYGDcLD+pqXDzPcU+UDmmTFl8S8RUBUmNMHqD2dZh+QSrwNW96xInQtdgfg
	Rc+doPxU9eqtuK+Xd52ZDeXWWdSlbpVGJmJBGUVDNfuF3iyH
X-Received: by 2002:a05:6123:4202:20b0:576:c4b:460a with SMTP id
 71dfb90a1353d-5760c4b4e54mr7604588e0c.8.1779279451185; Wed, 20 May 2026
 05:17:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <0218bc04-f3e4-492b-a6a8-ae0d487c487b@mail.kernel.org>
In-Reply-To: <0218bc04-f3e4-492b-a6a8-ae0d487c487b@mail.kernel.org>
From: Alexander Potapenko <glider@google.com>
Date: Wed, 20 May 2026 14:16:53 +0200
X-Gm-Features: AVHnY4K2L_Gg3kprENoJmD2H4Rl714iNxxmmcfq16OJufZAU2PhTQ9s9yKMZgI8
Message-ID: <CAG_fn=XUif3iitq0eJxhsLU0CaoibGHgwM_7_VW1SwGOrbr2VQ@mail.gmail.com>
Subject: Re: [PATCH RFC v2] net/sched: fix watchdog timer teardown race
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

> safely call netdev_put() to balance the refcount. The WARN_ON is removed
> as it must not be used for conditions that can legitimately happen.

This is not the reason why we remove it.
As you mentioned in the previous patch version, "You're right, since
`timer_delete_sync()` ensures the timer is deactivated and any running
callbacks have finished, `timer_pending()` will always be false at
this point. The `WARN_ON` is indeed redundant now."

So it's not that `timer_pending()=1` can legitimately happen now, but
rather that `timer_pending()` is always 0.
