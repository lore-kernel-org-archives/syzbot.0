Received: from mail-oo1-f70.google.com (mail-oo1-f70.google.com [209.85.161.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B053399013
	for <syzbot@lists.linux.dev>; Wed, 12 Aug 2026 06:36:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786516597; cv=none; b=qs9Wg2C/STsR3Swqnn197sF4dgLFhIbiCTeHwD1V25bbQGU3zsQy0ZbHCYYricJk9+OWr7/ncnP98VOx9HZpNSEair36gYgGSlh2tZw++xAqQQhBozYGZmbOPmQnUAYggQvjAxEKfWDjRSeUi8b0vkzo7ZWqIW1nAKstak1l8dI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786516597; c=relaxed/simple;
	bh=cVNKo3QNadU4XdtPBoXzvF+aTTuiJch+/uhmG0KUpCc=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=G7/HUrGVKm+x4D8B7f0U7qOeDvWgPVqWWIeBK46HblAAFCnlYOf3g8Gu8UuiKatO7RSNuQcI6QfeR7/PBNX8/lx2Oe0dGiO9fqgEJsgdtSw/ew49jb6VraC0NLTkglPLDvt43qRav30Zu1gcMuHTzTQ0/25WJw2FEGTFQ2WTTys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f70.google.com with SMTP id 006d021491bc7-6ae344f1690so270707eaf.3
        for <syzbot@lists.linux.dev>; Tue, 11 Aug 2026 23:36:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786516595; x=1787121395;
        h=content-type:cc:to:from:subject:message-id:in-reply-to:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=cVNKo3QNadU4XdtPBoXzvF+aTTuiJch+/uhmG0KUpCc=;
        b=VCipcj+r0Z9E5DqrD58GMqJxD3v5Dq4ElRgB7OtsssUiwXMWKKEKoVRr1/S1VAraBV
         tM0Fc2OvTr/BHvs4pPtSVf2wtaJa3kP0lKFivnPHmM94SnXoqce2lpT8xFUAY4B6crlC
         GMYbtq695NYLOyMlwgbfeZGKg+G5AGezWn4V42TEKVueiKu5P82KAxQk3+pWJ+/GWl3t
         r6WupMkYlm85EvCLPjx0h9XoJvLcwRaJk8oretRMLD4MkKpC1MmsyWNUjzLoWvyNSIMx
         jRnmVzB9fSJXzKWy95q5kpvsVl6CSSFhoyB1tHkC5CzO3cQqpNb7ZYwpH5eHVcsPv5br
         Gs+Q==
X-Forwarded-Encrypted: i=1; AHgh+RrmjGHaHN4E2iHiO7GxcMThytSUFA3OrWyQyoif41v/XH5O5jwG02KgxoVNmsSvv6g7S9IbOjI=@lists.linux.dev
X-Gm-Message-State: AOJu0YwPnVqsWnVVUVEAJWfCLpNPlfdp+mSoab7R9E/wInXAeBUG8bJo
	xOSRT02K5coxFkBjZ0wGnSdtEgDfstCwCloVWr9Xc4afnrhdFZbZ6jnjvEK95qQdTXLZaaxmHqJ
	NyabJn+77RKRLOCvriVxh27XqWao5P9q4p65MR/VKoHCwDdd/bakcmkzhs14=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:208a:b0:6ae:9d2a:c29b with SMTP id
 006d021491bc7-6b0b255d16dmr2230586eaf.13.1786516595182; Tue, 11 Aug 2026
 23:36:35 -0700 (PDT)
Date: Tue, 11 Aug 2026 23:36:35 -0700
In-Reply-To: <6a7c1432.a2bb2777.31c27d.000f.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a7c1473.c5ad36c8.12f49d.0026.GAE@google.com>
Subject: Re: Forwarded: Re: [syzbot ci] Re: net/smc: fix clcsock and lgr/lnk
 races in smc_diag dump path
From: syzbot ci <syzbot@syzkaller.appspotmail.com>
To: syzbot@syzkaller.appspotmail.com
Cc: mjambigi@linux.ibm.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

> For archival purposes, forwarding an incoming command email to
> syzbot@lists.linux.dev.
>
> ***
>
> Subject: Re: [syzbot ci] Re: net/smc: fix clcsock and lgr/lnk races in smc_diag dump path
> Author: mjambigi@linux.ibm.com
>
> #syz test

Please attach the patch to act upon.

>
> v4: Moves mutex_init(&clcsock_release_lock) before sk->sk_prot->hash(sk)
> in smc_sk_init() to fix the uninitialized mutex warning you reported.
