Received: from mail-oo1-f72.google.com (mail-oo1-f72.google.com [209.85.161.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF28D212542
	for <syzbot@lists.linux.dev>; Sun, 22 Mar 2026 12:38:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774183135; cv=none; b=sRyuw3txUhwsapmga8wichO4Th3bbctReOFpJqZMReKmC5N05jxhbMnLnfGsWxUFjgfjGc1knKfslegVvDGfOxL733sdZEOLbhqxhT9xc81O/ib2wn73GFlntxJAPx5en8mVguAqA3PGAwwoHuGNMVvGRG1lbSF/rU3xA+VcG5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774183135; c=relaxed/simple;
	bh=satYM5fGm5NxtEO7gQHzgrdT13jAV7/jwxl6N8n0VR0=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=eoq9oPZZnp2ELJMXc0I5D/aO3aqcxKf4fZdb6KvXZ+RUIJaBSeeFP8tl3rO6+x3ZScR9NfVl/E2+IzMVjga51/EONTGRv/WQXk20gIJGhMuCPYdWbwcMnIsR58ouCSz6vjKn/PnSVqWKUBvO8u+y7V+lmJjy85dJ2jBRHcRxWx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f72.google.com with SMTP id 006d021491bc7-679c5ed0942so40013366eaf.1
        for <syzbot@lists.linux.dev>; Sun, 22 Mar 2026 05:38:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774183133; x=1774787933;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=satYM5fGm5NxtEO7gQHzgrdT13jAV7/jwxl6N8n0VR0=;
        b=SQRmkqLCc48EyepPa6+rvHBiZ27b4ghk3G24SdpzJ5YtvwbOWaGjL9Y/O6Y/gVLqoK
         lx2558iACH5D4lsUfkE0v3xhO5DGh1L4ZP4RpFRNWmuHet/Tw8wG9vk82IYsjFCf8GaV
         ecFE8GmaAVsZT26O5QO2lC0JBVnzDrhJqM2MLNLxohrozysCxZxImrJrvY9RTo1NiJdB
         uuE+KPAcwvlx7KvbfOEnFSff4W5RtVSFBULzN0NYfbie5B07Jg4Jr1eFB6iddw/48I2C
         kPD/5oTvVlg7SL8Pfc1rjnxsrcha3LNWMnx3gPhINvN8umaRWNSAatsr4s9H5dQ4tsYb
         cuAQ==
X-Forwarded-Encrypted: i=1; AJvYcCUlYfKB++P4RDyhQLIfuJDySVUHesVM+cgKMi+fyeVT/i47Ady0N8c5KnVnSpNSxYGLXWPozeU=@lists.linux.dev
X-Gm-Message-State: AOJu0YzP88qopyrcdR+Tme+2u6I63wtp7u3eRHC5iuHsmynuDc1dtves
	NqrJem4AQ3o91CY6qaU1RAnrAPRf2iezUJZJEsPuK2nlVcmQsDsyW/MWOvBa8uxbxId8x5G9KhC
	sakBupfDS43flXtdcCFuWTuTOAEJG/54OZNuyP9vm25jnRfSgmPzncIkychE=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:4b94:b0:67b:aac6:640b with SMTP id
 006d021491bc7-67c22ee4831mr6499198eaf.26.1774183132930; Sun, 22 Mar 2026
 05:38:52 -0700 (PDT)
Date: Sun, 22 Mar 2026 05:38:52 -0700
In-Reply-To: <20260322123545.39132-1-dxdt@dev.snart.me>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69bfe2dc.050a0220.3bf4de.007e.GAE@google.com>
Subject: Re: RE: [syzbot ci] Re: exfat: add limited FALLOC_FL_ZERO_RANGE support
From: syzbot ci <syzbot@syzkaller.appspotmail.com>
To: dxdt@dev.snart.me
Cc: dxdt@dev.snart.me, linkinjeon@kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, sj1557.seo@samsung.com, syzbot@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com, yuezhang.mo@sony.com
Content-Type: text/plain; charset="UTF-8"


syzbot-ci does not support `test` command

