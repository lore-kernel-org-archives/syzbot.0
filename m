Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A80733E95A4
	for <syzbot@lists.linux.dev>; Thu,  2 Apr 2026 14:56:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775141797; cv=pass; b=HLYPQJpaF9MHyXeONe3vzAQ+UcE/g/OeOkFFYjqp6jLzJoeH2C8ZxOhapKCg4/xehXLQt0/5ZslaBFCOkrOPRZV38oTbe7iakza2VeqobBqb9lahZ5KSr8/qqsYAZR4Kh7dD0ca+cpx5WtmDM5AQcpFtPkqFT+fFxTKhlUsWCxo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775141797; c=relaxed/simple;
	bh=uAxS5YiO1+amAvCpAqHLE6/1cSDNss5no4TdlFmkOU8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=K5yo4oBGcninZItua7nWsHmKqjdoCdgKgKCKhRAEoHB4373MhbIo88KZ/j9TNs5TgYWdFtYOmluiAiC7wbE7Jppdzp2DgSSNkq7pcNd2NaDZIuB/lK4FiVsSs0ZpN3xukOPzUNXTXEb1IwKgIGMQROaBFM69ZUNvoIBDurE2b6k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IZPjZaqo; arc=pass smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IZPjZaqo"
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-43cfd1f9fd1so633598f8f.3
        for <syzbot@lists.linux.dev>; Thu, 02 Apr 2026 07:56:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775141794; cv=none;
        d=google.com; s=arc-20240605;
        b=BWaN6N/qjf0pjqK0A5gV15ZIFO3sQW9qOUuTW0zSkoa1ac1ZIbmKGzjH9aIKWsNio4
         xqT3U/k1U1s2gp7K8vhq1BJ/3zZvh8uUDs0WNKWfY8ph87u/msKh8tIwgp5g9j5ztGLG
         v0f0yYalJ2xMrlWzYewpOAg5v1clDxbyRusjczsI1ibzOc+qGAUacvqIWDIGHyDIk/XC
         g2vsmtnaTPpBeh8x9q2sD0GscJvanDwmFZK+ULp9qkf0WDnSa8OILByLkoN+WUvE3ERE
         lD55GS/WjULVOW+Bbe2MMx/Q2Ak6QrRdUSN5zpClz4UayjplZTKcOSOgpCq6s2Fj4wM1
         tuEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=uAxS5YiO1+amAvCpAqHLE6/1cSDNss5no4TdlFmkOU8=;
        fh=wTboCPe6ZXqMowt0lZbeEM58+knEHHaw3/lA9828oVs=;
        b=Uoe7QUr8RhaHpYDdKxW1qhyv+s8RN/g9jHrCd7JOTlRXzD5DkyHhntEiLsvDFFnyGd
         hE4mgea4cUweX7ZVxHFKqfWv1VD5MsuSOtMGY2Q3GTxJZFgemSGnxnGzY8xPCfhsqm67
         t89Rb91z9ApaYx/Urj8iBaJQwsEqKp/4nzcuah4HKnvaq5JaoMR1DrS4tM3h5oXmGFZK
         DcxJKwXmHekz09skDJpGsBeT8YhCtbm0nnaqz0U5WgbT6DBxyPsspWevipv2qJJ6cDSB
         1YR82o3GN7CqEMgOzOBxUxTDc/MiTb3rBwrBuPb6ajO4Fxqbbr5h7MRXjvcgFL41o9Uc
         p7Dg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775141794; x=1775746594; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uAxS5YiO1+amAvCpAqHLE6/1cSDNss5no4TdlFmkOU8=;
        b=IZPjZaqo8X/DQcU0RuiKOqQedaaSc3rHjjEFSdO4kQFbca8Qy3HESCoRmiNCmQQ+1m
         DxJal1O6uKGFmR8IjPJlZLy/h60uRGoglsUFDM11/TQZRL769ATKKp2WinKnU+j92bYR
         /1zgW3/dRyifGfojqupQQL/DyHAlu44tNoF0I3hC5qzYW1JklVO/JoScBj0UoIBQ9myQ
         YvHWL/MlDRtLwCiRFsLlYmGGF41VRRs/JM8cxmlAYlp0/d7wakjeAEi/w2v6En0kcgql
         yRoPOoBXSJ4d1t1oZnt/Kz4NY2eaTCLuyt+arZKGRMHzeK+A9Nl7BFkEO6l8t6oACQRw
         L7uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775141794; x=1775746594;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=uAxS5YiO1+amAvCpAqHLE6/1cSDNss5no4TdlFmkOU8=;
        b=TXD/RTLASNHLIYqgljUTedvKmWs9tvbXduaMg8s/hbsrNpPISufWs/gK1RtX5NA7dd
         +5ftoJr9H/EyAVJIqTww1VsIuGKi+TtP94OG/3+uRSlELRsoB5ycaBuPRwxkpHtF03iD
         kdCCgA6sTFZKli2rm84Q+KW4SyR8INVuESj0oFRhTTfwy8rKbIFfalT2L+sDyrI9zmd3
         qu1bgq8xkLXBsrw3ks/tyJupgjWCdE7WDrUGUrC7gos5mEjNXEO7FsD02/qar2cNroOk
         GCHU1B/X+Ri3nnNUMgUkhfFVx5Yg7FhJ+Ayl2Q90EfDYEvk5ZVbr3VcuJWBSI4GOupyo
         Fc6A==
X-Forwarded-Encrypted: i=1; AJvYcCWciwOteQsUjvQPmRZW0OMT8UmvsvNsJ/fmA4ESy4GnitF0YCVs1bpMBvZcBi7+UZZqU/bkXP4=@lists.linux.dev
X-Gm-Message-State: AOJu0YzgPq5syNracG1aZPVw3/ACQynpSv8C6bGaHNV/tWN6ls9W6fT0
	zSIb5Qvjo8JbjgtsVDnVmxIC0gz0la8i5+iHvBehTF1yf42MkvJmPNrzdbpVKYu4O30i1/coz7k
	Dvej8ltLgDVGmi9DAiV15SWShJcd8mdI=
X-Gm-Gg: AeBDietDrBM6FbaovBVnuuMj2cZwG9wOIWtnQxqLJDScxRZDzz7xSwpQuX1D+XRPWqL
	Uyn5jZB3E7vZ/sbEIdRY7jV+w2Dh/ftlV5BX+oLpYFNxA7vw5pUHVxef5spv+IgkMBF4NdDKlLZ
	0ofOpTuFjBjxLgF7h6ryJlKCu8cn0/Mhp8TC8AUpJjyrkG0jjzg9g4jrVAQuXSaaiyedNcl+bsc
	HI6UY6a/xfpB7PznsG2s53/vXdtH468mZGGP7Ie3qb6E2KaPmwLMivFZK9TnGugNiggBlIpz6ue
	J+0GJ2YK35miL4N0fSa1+TOOfbj9h9kTa6Cy3LwE8ThWRXLclBi0pB9m4r0CFuLthfxUrDj0Erw
	O1Ma+LIDPtDGk7EWAsLh81HUEOw==
X-Received: by 2002:a05:6000:178d:b0:43d:4ee:c25a with SMTP id
 ffacd0b85a97d-43d150e3bd6mr13872675f8f.48.1775141793883; Thu, 02 Apr 2026
 07:56:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260402061744.10885-1-alexei.starovoitov@gmail.com> <69ce66da.050a0220.2dbe29.0005.GAE@google.com>
In-Reply-To: <69ce66da.050a0220.2dbe29.0005.GAE@google.com>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Thu, 2 Apr 2026 07:56:21 -0700
X-Gm-Features: AQROBzCTm63wE0_zWPbun-baJuzBXrmRm165qIp6TtIjqCRaUBlXsXPm7P0F0D0
Message-ID: <CAADnVQKzKhHFO+JBRmF7QyH3C9p3Uu+MuJdK-tuiqnt-BGU6Zg@mail.gmail.com>
Subject: Re: [syzbot ci] Re: bpf: Prep patches for static stack liveness.
To: syzbot ci <syzbot+ci5d1af9c009034c4e@syzkaller.appspotmail.com>
Cc: Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>, 
	Daniel Borkmann <daniel@iogearbox.net>, Eduard <eddyz87@gmail.com>, 
	Martin KaFai Lau <martin.lau@kernel.org>, Kumar Kartikeya Dwivedi <memxor@gmail.com>, syzbot@lists.linux.dev, 
	syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 2, 2026 at 5:53=E2=80=AFAM syzbot ci
<syzbot+ci5d1af9c009034c4e@syzkaller.appspotmail.com> wrote:
>
> ------------[ cut here ]------------
> UBSAN: array-index-out-of-bounds in kernel/bpf/verifier.c:21711:16
> index 10 is out of range for type 'u32[10]' (aka 'unsigned int[10]')

Yes, it's speculative out of bounds. r10 will not appear as const,
since loop that populates it goes to ARRAY_SIZE(aux->const_reg_vals);.

If that's the only thing I'll fix it up while applying.
