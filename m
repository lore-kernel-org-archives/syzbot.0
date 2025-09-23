Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34342227B95
	for <syzbot@lists.linux.dev>; Tue, 23 Sep 2025 03:22:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758597765; cv=none; b=DPo/KtjCJP6bfr1D3lwrS5yA520W3UlvBZpSiXMLh+lF2zRW58nwNFkm7CFKX7V9AHGxO8wQMmlA5wcFTZSz8PEaZzHalGkh/WNkp7a532Hg1tSDF02qrJJSIEgf3KstCk9glmtMUtNqJvgYf9x/vKKnRnhzHGE5TauNUB6JKwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758597765; c=relaxed/simple;
	bh=She/ELyKZhXNWTbNgEi3ILIiFuipX3T23xo0q3yzssk=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=TWcejm6KbejHswmq/c+qahqVTF/1+Ee3XLwKId5kS4LculjvpFzsGqyKP04wj/8OtsCTWDOATkHFcShnByfgWrZhJI6Fdemg14I58LgTm+iefGuy8E/scbzQMS1YM9vDJM4o2fHREuqDnemJoSJlaZkpun7/BjYvi5h1eU9s6Yc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-4257ba85609so25681395ab.2
        for <syzbot@lists.linux.dev>; Mon, 22 Sep 2025 20:22:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758597763; x=1759202563;
        h=cc:to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=AV4mVbHDGMbumH+Un9ywyOoWoqbl8hLKy/G4JVpLkyQ=;
        b=he6r6jU12xPY3Dm2br6nCSsi5745ekArJ/e0Bfwze0QXpuRh7MNnoS5bK0ao+of8cT
         QSAqm8jRDpNzsDSUR8e7PEz8dscTsKIHQ9IS/Ji0ABdBFJluvPkD0yfFwCcR0zHznUPl
         T/Hu3Wqf+FY5KUaITuSge1yfq3qBwrIDiBTNUaaVu3zBrI0U4hFFNNHw6Zcok43MeiZj
         Uckk8LYGQq01r8NcuMT4ZsqXCnD1/13jFWO/gXcYScqid9eqr5lwfX/c0wFPh0ACVNAQ
         rpqD6VUNnK7MdaSSXgK5w4OvJ+C5mFwvzxa0j2XQLXuY8nM2YZ1DPn4RqbURJ9M4VR7r
         IANw==
X-Gm-Message-State: AOJu0YyYLxjGoVwcWrYwcxdjWHELzfY6ZdA3mv1BWM2xWIrbgw5ns/hI
	pigZHMVguB7Qa8up0UZO4O+xZ+ylTa70r4NY8+zXdIzBOSRFq5dsLw+QVzIOgfyQAV6riOiQtH0
	2RdN+glXq5CI7kKZaqQJzsyBuukJdWfgVx61YOaRzpa6AuEFczefHckohO30=
X-Google-Smtp-Source: AGHT+IFPyRr60B+N95l3tfk1UG6rxN4GM793zJO/JyjR6m7pi2ytJjO47THLvi3IkHMel5TWwck1+DlJtfTE3M4J9bVG3HnsdGol
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1a6f:b0:424:1e39:bf0b with SMTP id
 e9e14a558f8ab-42581e2897dmr15029255ab.8.1758597763227; Mon, 22 Sep 2025
 20:22:43 -0700 (PDT)
Date: Mon, 22 Sep 2025 20:22:43 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68d21283.a70a0220.1b52b.002a.GAE@google.com>
Subject: [moderation/CI] Re: wifi: cfg80211/mac80211: validate radio frequency
 range for monitor mode
From: syzbot ci <syzbot+ci11f370d3ad0ca08f@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v1] wifi: cfg80211/mac80211: validate radio frequency range for monitor mode
https://lore.kernel.org/all/9589ba59a05d43f2fff5218493c5a6f4fd6087d2.1758595078.git.ryder.lee@mediatek.com
* [PATCH v1] wifi: cfg80211/mac80211: validate radio frequency range for monitor mode

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/97628458-1e85-4265-8bf9-030331d5de1d

***

kernel build error

tree:      torvalds
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvalds/linux
base:      07e27ad16399afcd693be20211b0dfae63e0615f
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/a4eca271-57f2-4a26-b896-a954203600d1/config

net/wireless/util.c:2972:6: error: conflicting types for 'ieee80211_radio_freq_range_valid'
net/wireless/util.c:2996:40: error: incompatible pointer types passing 'const struct wiphy_radio *' to parameter of type 'const struct wiphy_radio *' [-Werror,-Wincompatible-pointer-types]
net/wireless/util.c:3000:48: error: incompatible pointer types passing 'const struct wiphy_radio *' to parameter of type 'const struct wiphy_radio *' [-Werror,-Wincompatible-pointer-types]
net/mac80211/rx.c:803:41: error: incompatible pointer types passing 'const struct wiphy_radio *' to parameter of type 'const struct wiphy_radio *' [-Werror,-Wincompatible-pointer-types]

***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[evelyn.tsai@mediatek.com johannes@sipsolutions.net linux-wireless@vger.kernel.org nbd@nbd.name ryder.lee@mediatek.com shayne.chen@mediatek.com]

If the report looks fine to you, reply with:
#syz upstream

