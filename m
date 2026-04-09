Received: from mail-oo1-f70.google.com (mail-oo1-f70.google.com [209.85.161.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A25D3E1CFC
	for <syzbot@lists.linux.dev>; Thu,  9 Apr 2026 18:14:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775758498; cv=none; b=KfmbzYmZZOmEefLlEdguDpiUdZVxb7Dhxm6RSkEyMVuKppMj0tjCFWP8zjF2sD6bdaprPFvh0qaIXhR/eKvbIYEU/3X+ZvupcFfOuGbcWVsaOlF8gngwzej+KTUnso2po3TG7XVfEoSg9UKZMR19KIXNMrFvlpyBaDJXMFz76iU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775758498; c=relaxed/simple;
	bh=XW73k0dLfmP0RPybu5ieMYDYHZlmhLwFmSjltfSIS60=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=Qe04RzpnCCHAO8J9+1WB6Cm3nLdt6Iem4Jui/O0/zo3/IP9tMe2tzVjJLUiRPhUu2e84/8NJFdJnBtkQ1V5MiKQFFbalD+SdoK4RftjOBFXE970q+iWo8z94Oi13HEfZLQdzHJxy3V65OcMG36bqUXZBYAoOKAwxU3p0YOWMv/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f70.google.com with SMTP id 006d021491bc7-68b313c42e7so697440eaf.2
        for <syzbot@lists.linux.dev>; Thu, 09 Apr 2026 11:14:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775758496; x=1776363296;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=q3NYOWXDNeiZWwIZ+Cmzm6u5x/uWo3OsskHrItd/r+8=;
        b=PRGNop38vsIKQtlzO6Lm0JcZbKCFgp5E1hR7gbjYoXLm/NURPivuCM/TY5Vp0jSlM3
         ps0jPKQDGFY8tEw5zcUIm47/wi1mdtvK8mAgPOietSK7kE4ZLFBeifh6Df/9qdW2TsCS
         rZTmA0uChIAMAS8xQEj/Qdl4bz7Ndn00SLes0uUIgE7J9eCFs+fGSasWgyPNzV4JPB2L
         bsKP1oN7avsCIzaqnOS9vX9fneYh3TjP2k1wElmIPbGeA34z7Yl0rvIHyud5llfbNsF2
         6tDMMWLD9yBEnwQ/r08XPZUJrF3pvZS2x9GuumbXBo1ySSjhv2cr7ZvRznTEh8UDF3ia
         K4cw==
X-Gm-Message-State: AOJu0YyvdoKgCBBvQMdZxynvhYBPXl6N33RGi1zutoAadrafq6HyLMyv
	VVyrHF2Fy60Oeq4c3D/tZmCv7gkXUa/PPoZnk6Onb6cDAkXONX71xFCp8Uvwplli3oMie4BoH9k
	/sp8WVQBWZQ5ArOHwHWss+bmxzdZJ3WVlj+TNIoNo2LgyoJjOMV3UG15xkZc=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:205:b0:67e:33fb:221b with SMTP id
 006d021491bc7-68be6335cd6mr83257eaf.16.1775758495741; Thu, 09 Apr 2026
 11:14:55 -0700 (PDT)
Date: Thu, 09 Apr 2026 11:14:55 -0700
In-Reply-To: <c20b8457-5255-1328-41df-aa02efbc0ea9@netfilter.org>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69d7ec9f.050a0220.3030df.001a.GAE@google.com>
Subject: Forwarded: Re: [syzbot ci] Re: netfilter: ipset: concurrent add and
 dump fixes
From: syzbot <syzbot@syzkaller.appspotmail.com>
To: syzbot@lists.linux.dev
Cc: syzbot <syzbot+cidea2d6bafc0138d9@syzkaller.appspotmail.com>, 
	kadlec@netfilter.org
Content-Type: text/plain; charset="UTF-8"

For archival purposes, forwarding an incoming command email to
syzbot@lists.linux.dev.

***

Subject: Re: [syzbot ci] Re: netfilter: ipset: concurrent add and dump fixes
Author: kadlec@netfilter.org

#syz test

-- 
E-mail : kadlec@netfilter.org, kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.hu
Address: Wigner Research Centre for Physics
         H-1525 Budapest 114, POB. 49, Hungary
