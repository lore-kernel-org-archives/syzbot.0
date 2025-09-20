Received: from mail-io1-f72.google.com (mail-io1-f72.google.com [209.85.166.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E47851F4297
	for <syzbot@lists.linux.dev>; Sat, 20 Sep 2025 05:32:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758346378; cv=none; b=W25USFeyIepT2wwlloguihuw7C319jw3jBFrgz85bt6eWH1HusovPap2XUrdhuLSBZRaAM66DevWbxMz+4xSzhmrFeMe0csgDImgRikZh2S4R6KcjxRmFpNfeETgxt3Qa5jR2TbUczRuAQpJ+FTNpmEu+WJa4P89gjAbD//Uscg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758346378; c=relaxed/simple;
	bh=xTeRPRtb/z82FGWD/vUPHRy2IHIbeXQf6bBU6bc+50M=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=MJsjSsFXusdDd8HjEv+97BpOlyWFNLNSihWqR8c5gRAZpPMcNizxDBNry6Pkh+bMNJWupqRTQDO2QKyouxA5oxtPeN9tThHc8xxSOiuTdcCzVOq63pQWoLn99Ll0Cp82/nrEi7WyUIwIUCclb2h1u14K8BlLu5vEozW9vx0rPpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-889b8d95367so282545039f.1
        for <syzbot@lists.linux.dev>; Fri, 19 Sep 2025 22:32:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758346376; x=1758951176;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BX121JOP+S660ZNIzknKQnVvd/Z/UMYcJSi3DaS1HFY=;
        b=LX/u1tkk5FLpNp5ufqs9OLaSNqeblTwfXGdEkY3Rkcm3bJ6gl0xf9rb3yyxbc94627
         9Tg9dzJs65HI7UhBzOSL4GH2e1iPAgdcxCpMjITpHjhOc6V/afZixPiLeYNQl+Dc2nC/
         F24jSOtOBmpcUU8I/OpytltGtV7MIabrMTT0CYJcKxmA+HsLSLYwGxlQZOI8bf0bIhXV
         EG3o0qpXZAv4AGoOrOl1iOSCEGf62J14Xscyx1YNFKUFD/X1xVq2E2tmq+RtUnDDwINE
         dx4H3VwRF8yKrOwOMFZrQ1MbDKbAR5SnX7ls9QJ2A/U1Ov21w7EaMHBvqlXWIUI/QeFC
         QW3w==
X-Gm-Message-State: AOJu0YxFpSonTfG33WQGI6mo/8zBpJel6HkIJR1ceFxNrQz8KILhXXBA
	DMZH97PAiYHs33JZLcGWqSH3dm29SZUSVVQX6EQVd8u0TGa5Kh3Sm71n41IiELa7U2olNbq1Hrj
	qlzRODK7oTs19PGBFtv1O0NsFzQtg3AEBmEPOGJC0Vc7Wq96ZziMuRV5aZGY=
X-Google-Smtp-Source: AGHT+IHhK4BnYrrwCEZIkw3iAnrm1xFmBEpN+VStYxwu7lVPH3kl9aQlZFRg9YSvloeaBEvkfIA9nTGbylEA6J0COoSho7qN9W+R
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1c0a:b0:40d:e7d8:63fa with SMTP id
 e9e14a558f8ab-42481999d70mr77858665ab.26.1758346375960; Fri, 19 Sep 2025
 22:32:55 -0700 (PDT)
Date: Fri, 19 Sep 2025 22:32:55 -0700
In-Reply-To: <20250919122325.f0abcf092b9b.I04478fde87a79c7909f1cc4249430deaf71e8bd0@changeid>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68ce3c87.a00a0220.37dadf.0025.GAE@google.com>
Subject: [syzbot ci] Re: wifi: cfg80211: remove IEEE80211_CHAN_{1,2,4,8,16}MHZ flags
From: syzbot ci <syzbot+cib69b4e10bd070489@syzkaller.appspotmail.com>
To: johannes.berg@intel.com, johannes@sipsolutions.net, 
	lachlan.hodges@morsemicro.com, linux-wireless@vger.kernel.org
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v1] wifi: cfg80211: remove IEEE80211_CHAN_{1,2,4,8,16}MHZ flags
https://lore.kernel.org/all/20250919122325.f0abcf092b9b.I04478fde87a79c7909f1cc4249430deaf71e8bd0@changeid
* [PATCH wireless-next] wifi: cfg80211: remove IEEE80211_CHAN_{1,2,4,8,16}MHZ flags

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/56aae9dc-2280-4bc7-9761-a0d119923350

***

kernel build error

tree:      torvalds
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvalds/linux
base:      f83ec76bf285bea5727f478a68b894f5543ca76e
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/9c1d861d-4d4d-4c90-a946-8769043ca3e6/config

net/wireless/util.c:118:20: error: use of undeclared identifier 'IEEE80211_CHAN_1MHZ'
net/wireless/util.c:120:25: error: use of undeclared identifier 'IEEE80211_CHAN_2MHZ'
net/wireless/util.c:122:25: error: use of undeclared identifier 'IEEE80211_CHAN_4MHZ'
net/wireless/util.c:124:25: error: use of undeclared identifier 'IEEE80211_CHAN_8MHZ'
net/wireless/util.c:126:25: error: use of undeclared identifier 'IEEE80211_CHAN_16MHZ'
net/wireless/reg.c:1734:18: error: use of undeclared identifier 'IEEE80211_CHAN_1MHZ'
net/wireless/reg.c:1737:18: error: use of undeclared identifier 'IEEE80211_CHAN_2MHZ'
net/wireless/reg.c:1740:18: error: use of undeclared identifier 'IEEE80211_CHAN_4MHZ'
net/wireless/reg.c:1743:18: error: use of undeclared identifier 'IEEE80211_CHAN_8MHZ'
net/wireless/reg.c:1746:18: error: use of undeclared identifier 'IEEE80211_CHAN_16MHZ'

***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.
