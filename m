Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com [209.85.167.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49F1A448CF5
	for <syzbot@lists.linux.dev>; Fri, 11 Sep 2026 08:26:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789115221; cv=none; b=dZCO8kQJ+CLcaU/lYzII7D+EEl3jjpYsGXK3pEspVNS7ewooaZATIPlcsC9X4kudDI8STv6R2t0wfBqET5f9fyuASyZWWw78KBDhe5auOU5ZlluElUkevYAa++Y4xCW7gguYNwgsgmijce/eEy9TGl88P8686cy3814szMxeo2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789115221; c=relaxed/simple;
	bh=suLzmAaORAmOrHA8CkgN4OO8Kgo79ga7dnEm3rl10lQ=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=sFutwwKMJT2ZsDUdjqoasHsSGDwYy5W/RdqYwROxBqinyJKyxRggy7A3V5lDIUh3ryfaNwwGmzjtaY+x1envWCp/80I9IX/HU2G5Pyk5s3QiQh6hRVCqyKOACyk7LsswVsfo+9zNXjweZ6b0Nk62TWtfuA2adLimGrO2nSwoe9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f197.google.com with SMTP id 5614622812f47-4be498aca30so571444b6e.3
        for <syzbot@lists.linux.dev>; Fri, 11 Sep 2026 01:26:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789115219; x=1789720019;
        h=content-type:cc:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=g/DobM8UJXBqYe9G2S9zcX+ih1tLqZZ30FT2g/orkFo=;
        b=Ce5zqUvozGQ3ztKOlm0u/2/AL+AUiQm5eVDg/UT4QF5HZ9hBlnsaadoHdnGO9ZmNpN
         USBxO0A6SUj25DanDHOyuc5NeMq/J1i4h479ljf0zNYccx6loRY0vtC3lL62jozxcyKg
         U02QnPDRPepZNa5Rk73zvIFK6zh5TvPTWw1siMwnFKQH8irmSQtHlZgwUEFeVGvnMpp+
         DGN+q6tcUzAVPoSfD/XHOnspGXTTQoH/H9eibiVnADEX4knQaY8X/+A88wShmnjXr9p0
         2ozvJDi6beipkzFgpYq4wEKDZeTYwcd3+CLxPSGjH6bD9TBQLaja6yAFEZJZYx+stEM6
         S8Zg==
X-Gm-Message-State: AFuF++kaxtlwPh1m0TqFJbjtrYKh6oKzOKD00Xmld9Dt3pFvwvqVYNy6
	CCxv2grFZxjdvVOO0nKpGmuvFKCsMkbS8zGVN852PmaQTzzR9c1gmveuZwqdL9IYSqoDBRlWvVV
	M5Wto41Xbmgs2wYv0QADuH6MbkWLwttMnwO7jcGadK3UEJAlHkOQqw0YM158=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:c44b:20b0:6b3:697f:9f1c with SMTP id
 006d021491bc7-6c0ba820a60mr2666166eaf.8.1789115219124; Fri, 11 Sep 2026
 01:26:59 -0700 (PDT)
Date: Fri, 11 Sep 2026 01:26:59 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6aa3bb53.6e6c5f9e.28f11f.0041.GAE@google.com>
Subject: [moderation/CI] Re: wifi: ath10k: Add missing validation in debugfs
 mem_value and reg_value
From: syzbot ci <syzbot+ci1e11f909a9927f8e@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v1] wifi: ath10k: Add missing validation in debugfs mem_value and reg_value
https://lore.kernel.org/all/20260911072318.5232-1-rivaldihormat@gmail.com
* [PATCH 1/2] wifi: ath10k: Add missing validation in debugfs mem_value and reg_value
* [PATCH 2/2] wifi: ath10k: Add missing validation in ath10k_htt_rx_proc_rx_frag_ind_hl

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/55054cb8-cfc6-44b7-9e7c-0d1a8e719f22

***

kernel build error

tree:      wireless-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/wireless/wireless-next.git
base:      13e51269b6656768dc595ed6025e4974f2026543
arch:      amd64
compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/86cdbdd0-2eaa-4108-8856-d5b5edab4115/config

drivers/net/wireless/ath/ath10k/debug.c:733:31: error: no member named 'reg_size' in 'struct ath10k_hw_params'
drivers/net/wireless/ath/ath10k/debug.c:830:28: error: no member named 'mem_size' in 'struct ath10k_hw_params'
drivers/net/wireless/ath/ath10k/debug.c:836:28: error: no member named 'mem_size' in 'struct ath10k_hw_params'

***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

To test a fix for this bug, please reply with `#syz test`
(on a separate line) and attach the patch to the email.

Notes:
- The patch will be applied on top of the tested series (as an
  incremental fix).
- To test a new version of the whole series, please send it directly
  to syzbot@lists.linux.dev.
- Arguments like custom git repos and branches are not supported.

The email will later be sent to:
[ath10k@lists.infradead.org kvalo@kernel.org linux-wireless@vger.kernel.org rivaldihormat@gmail.com]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

