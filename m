Received: from mail-io1-f71.google.com (mail-io1-f71.google.com [209.85.166.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4BE219755B
	for <syzbot@lists.linux.dev>; Fri, 19 Sep 2025 11:04:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758279896; cv=none; b=f4ZIOiBoptx2R4Iv6rqZKqm9x6UNzfDVl35CK20/CPfz1pLozVZvvn/Ir2AuOGYf4M+mJ3Wzm7jxUMLIcl7Ssgl3AZrDgb36U99ao2aSPDJuw73JHTjvjbwoGBwVNfjgMr8+gv9rB+ck0D6y1lVpzp3WqPB9K40aYMhDeT+2r/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758279896; c=relaxed/simple;
	bh=hzggguZ8qtFZMGV98LvEDRS0uaWAa0hsy7mxmlIMeiQ=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=m4F5yNVntLeVRXwMteau3KrOCkjXhRGrmHV0tOaaWR8alQC6kkYl3EfysAzSGP7dhro013SWmaM0Hx+81lmIxK0j2LymLUgRKp5cRG6yraEkFWd3/Cd+cW9zx2tuFaBp5xsgLoMngULjPrxF1EnJOOAQ3t8KgK6+mpV+a/AkTFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-887777bd720so220261439f.3
        for <syzbot@lists.linux.dev>; Fri, 19 Sep 2025 04:04:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758279894; x=1758884694;
        h=cc:to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=No/rCZ5PiI+tFcng2ZiGfP1hr89cjEp4yfj3EUkyg7w=;
        b=pgrcGMQPr/rM6tFblfThCeNEqzHKVLFzON4ojJLLNwYjjyhh/pPrrRYPvUqAr6FVZe
         37GfYrdWfSZwHkW991YKQzO4Z36NbUqhKRO6AZ0culkOruVKy6sFwlsFuPCpqV6oPxjU
         QYpH06GGfQah1EXXz6o+1v6AGctdoGNNgOw6UlJAgWT8VH8yNJruB6ng7y7knIEWqhHq
         hqUi6NsFK51KAJ8/oKiF+KdiSqUf2Q9ILtkpAiRsF4SaxE5BEMX8VXMidSgGxQz9t3Tc
         aUSiUP1LMjiqElgkhgYmyzJxN3de/7Jm3CZLQHuaH0os94dIXtovX9Cma0lFMN14L/oV
         JzyQ==
X-Gm-Message-State: AOJu0YwfDvlqr0QoTMm/dNSP58Dyni8bDigYMoV3VfMUn+WArt7GvZan
	NwBj8cUx0ywNMTDM/dh1vBHvjsCxL2iDPLnYZ9RP8Y5xJ/mAmFceIXfogtlTCMA9wg0cd6Cs8uN
	KCTLn+wyMQo1f9i64DNg1beJjyPC3C8uTAAmQmheqXwK/3+iHJEbdnDUSVL0=
X-Google-Smtp-Source: AGHT+IGkVIXGU9tL/gA02To7Li34BvBMJQk8l1j2UuwYSdHEl0reA1shxBLi+EFeFVS4Qvbm893liY0JcsCpl2OKCJTWfaimOs1z
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a92:c7d1:0:b0:424:81fb:9248 with SMTP id
 e9e14a558f8ab-42481fb9d75mr26974875ab.30.1758279893943; Fri, 19 Sep 2025
 04:04:53 -0700 (PDT)
Date: Fri, 19 Sep 2025 04:04:53 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68cd38d5.050a0220.ba58e.0449.GAE@google.com>
Subject: [moderation/CI] Re: wifi: cfg80211: remove IEEE80211_CHAN_{1,2,4,8,16}MHZ
 flags
From: syzbot ci <syzbot+cib729075734784e16@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
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

The email will later be sent to:
[johannes.berg@intel.com johannes@sipsolutions.net lachlan.hodges@morsemicro.com linux-wireless@vger.kernel.org]

If the report looks fine to you, reply with:
#syz upstream

