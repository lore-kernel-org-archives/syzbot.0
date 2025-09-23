Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D8CC2CCC0
	for <syzbot@lists.linux.dev>; Tue, 23 Sep 2025 03:24:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758597886; cv=none; b=lj3RrZ/j1Z5qxqNg/aRxuU5Yh04moCdC/4EaL5Ua02Y3k1sSMeraLV+ZJwpgg3A4v6AUISg93Q8m15NWO8fEn4ulzY9A04UcZr5kfhGsiUpEuXKzXrY3rAKCd8nCOfayQFb/1P4+Maxr+u49nFsGjPsGxhqEppZysgbAg4soXJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758597886; c=relaxed/simple;
	bh=yLjlh05K1YHO8iWC59ZrKSsQqrlf1mpwNzNgwjoxtG0=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=OUE7DMA7ib55VQJACGQ8tARY52fR77IyUe2w5WcZj6AKa6Iri5e/AQTWF7/iCtgAB4w9nHieEpm+vkJPwrsgI4j+f7TevxiG4+4+78V5cGudt19T5MPVLNE+kLr5zjdPc1l4KEbfjRjBzf0AksRSzyyS+MEwSMxeBpccEblBeHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-425787ea1ceso26776745ab.3
        for <syzbot@lists.linux.dev>; Mon, 22 Sep 2025 20:24:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758597883; x=1759202683;
        h=cc:to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=pL/1ZRfz8GFJ0gGzrAIVBDOHHsf612b4hpzPUkSftbU=;
        b=kyfXW5tpbRCeaITo0fQoKqYzmgOQufAd5P5xmjs5xBa8Rokw7i9hXcbuT2evstzKNA
         pVtfMgWd0XSjLf07tkYhpndqdNGE4A3yg1oLWg2cn4VhxZYuuHVDv1YSu1J8one4iuJu
         jEDoavPdUjOmLrHv6WYLZF941vm7QmcR1N6EIG6V1qQQ4oHxDpegLXa1/HyQm4QWJ3L7
         rHcnluTJqe4vF4SuvDAjGfmLpvmS5efscLP+U5se6/cYz6sz6JoenTk8eIyWdAtH5phP
         P9HJmQ9qE1mtrVKEIkDYU0qyOBOwUEBXk7lX+CD0WRjqf6GM0GMZInPyxoX5BrkOlWke
         KzZg==
X-Gm-Message-State: AOJu0YyKCZGyXFYtp0k9+RXDE2nJEB7dHXokJFS0zjL8B0pe6sZmvsBZ
	804KSllXrreKgEKg6kFX/RlZ7SdHEFmc+WVV0Sh7mBf5a0H6OfKN6QD0NcHqcuJkDmK543i3c29
	SVDyh1SPBkr4oibXgcFxTtlQaAyf8IEWh3da/CNE8/C/T4xZGZ/PsXmqYgts=
X-Google-Smtp-Source: AGHT+IFemdrbWpL5hWzoafPIjbcodj/H0vFPz8FHAKl51E24zw1OciyJlL8X+Y4jRhY1u6zHV6fmfUDxEKu3f0CCDe9ZD4HJJ1gH
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:3c06:b0:424:6c2d:2225 with SMTP id
 e9e14a558f8ab-42581e27f62mr17894955ab.9.1758597883671; Mon, 22 Sep 2025
 20:24:43 -0700 (PDT)
Date: Mon, 22 Sep 2025 20:24:43 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68d212fb.a70a0220.1b52b.002b.GAE@google.com>
Subject: [moderation/CI] Re: wifi: cfg80211/mac80211: validate radio frequency
 range for monitor mode
From: syzbot ci <syzbot+cibed07b82d1a5a3cb@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v1] wifi: cfg80211/mac80211: validate radio frequency range for monitor mode
https://lore.kernel.org/all/e7ede0553bc7ed186eb6bf4ef467d9081a159c0d.1758593329.git.Ryder Lee ryder.lee@mediatek.com
* [PATCH] wifi: cfg80211/mac80211: validate radio frequency range for monitor mode

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/d7ce8d62-3d8e-43bd-b0a1-904aad07e61f

***

kernel build error

tree:      torvalds
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvalds/linux
base:      07e27ad16399afcd693be20211b0dfae63e0615f
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/4b162140-95dc-4d5c-ad2b-78f10ec70238/config

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
[evelyn.tsai@mediatek.com johannes@sipsolutions.net linux-wireless@vger.kernel.org nbd@nbd.name ryder.lee@mediatek.com ryderleeryder.lee@mediatek.com shayne.chen@mediatek.com]

If the report looks fine to you, reply with:
#syz upstream

