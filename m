Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com [209.85.167.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A77934AA024
	for <syzbot@lists.linux.dev>; Sun,  4 Oct 2026 21:24:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791149088; cv=none; b=mIsYK6H52veI9vCo8VdQc7G5Sk1IJ+4o9EGUkBDpQKb0qPRwRYJQqTzWYfyxfpfMG8k1Q7kNEwW1hw65fyliiVldt4T3pk5eN2iX4KSWBVX4CPSEFO37oG3hOkjUMxZwHl3jceI8gnlOlGE5Pj4YI6R9JrisfEs6ALPL6J79vek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791149088; c=relaxed/simple;
	bh=iScre4XUs9qmr06nU8XMjWBP8BXNl9+fAEd+DwRN+7I=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=IZXH/8lBLNIs1GyPrvFmGMmKv5tD+XauA58qbj02FJwckJPyWG7Bmp+vIXbQgVvg4ZxkMe1MwGnFAfcy7eOKhBFLfiLOBVhYXzAUIHczanEPVRRQ/962BZAQsJ1iZq/xFWBF4O/8sRN+nOhDNS7l0Ot9fpDRER7rnmxUI7EkXg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f197.google.com with SMTP id 5614622812f47-4e778acdbc6so2176447b6e.3
        for <syzbot@lists.linux.dev>; Sun, 04 Oct 2026 14:24:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791149084; x=1791753884;
        h=content-type:cc:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ObpYd4OCM6MMbOhU8Tp9fytVhfbQBcP/7zYzn2Dp9v4=;
        b=oC9fDsyNN8L6gXWGlejN0pbPgw5aK+0Z8nDfjHYVPZrULvaYlB69Fi6r8j9Jjo/AEj
         EIjLS8rBGBg9AszDwx96+X+aREBDtq5sT7YNt/Jb0Qy5KKxeLjwA8ITeslYJaOnicv2D
         mhAE/l9ht6/wAD0KkC//mYJoRR/E4hyq6NsQZoB4mHkuBpu3PrE+hFUslbUrFoOymOv5
         +CebzYRakNWZonRn3Kd86vetR+5SSdyR3hfiT6XFqq4rTUkfI0Lwbs1vMQyAQRhp5gHM
         Wp56rj2dp1iaZeabK/w3usQmNGOvVtUJ8uxQ5nCjbvOTeZoSdmI/Z+1Q6e3KOki4QQ8/
         AJdQ==
X-Gm-Message-State: AFuF++mdX15dX7EDPGqFkahLrdH80qpkbFI/1Jdrt1Ijoth1Y18enAJK
	8K/IIoq7feP7FurktWAdJfnbcqvLhDfttMiSmxLa5M/fJvfzT80TCfRBXwpL7u1VPeA+Hr2HyvZ
	oEDXbpQ2WnU2aZrjWDCt+QY/Sv+UbDmHZ6dl0376CDLj6l+dAzu6sXO9v/n0=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:1823:b0:4c3:95d:91f1 with SMTP id
 5614622812f47-4f526948ca0mr10669723b6e.1.1791149084518; Sun, 04 Oct 2026
 14:24:44 -0700 (PDT)
Date: Sun, 04 Oct 2026 14:24:44 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6ac2c41c.9ad129c8.3858c0.0035.GAE@google.com>
Subject: [moderation/CI] Re: wifi: further RTNL redux
From: syzbot ci <syzbot+ci1ee7eee4e49c2917@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v1] wifi: further RTNL redux
https://lore.kernel.org/all/20261004190122.1559001-20-johannes@sipsolutions.net
* [PATCH wireless-next 01/18] wifi: cfg80211: track netdev running state under wiphy mutex
* [PATCH wireless-next 02/18] wifi: nl80211: allow device lookup under RCU
* [PATCH wireless-next 03/18] wifi: nl80211: avoid rtnl for commands that don't want it
* [PATCH wireless-next 04/18] wifi: nl80211: don't take rtnl for most dumps
* [PATCH wireless-next 05/18] wifi: cfg80211: reg: update channels under wiphy mutex
* [PATCH wireless-next 06/18] wifi: cfg80211: reg: set intersected regd under wiphy mutex
* [PATCH wireless-next 07/18] wifi: cfg80211: update channel DFS data under wiphy mutex
* [PATCH wireless-next 08/18] wifi: mac80211_hwsim: call cfg80211 event with wiphy mutex
* [PATCH wireless-next 09/18] wifi: cfg80211: document wiphy mutex for radar/CAC events
* [PATCH wireless-next 10/18] wifi: cfg80211: add a mutex for regulatory/device list
* [PATCH wireless-next 11/18] wifi: cfg80211: allow walking wiphy list under cfg80211_mutex
* [PATCH wireless-next 12/18] wifi: ath: use freq_reg_info() under RCU
* [PATCH wireless-next 13/18] wifi: brcmsmac: use freq_reg_info() under RCU
* [PATCH wireless-next 14/18] wifi: rtlwifi: use freq_reg_info() under RCU
* [PATCH wireless-next 15/18] wifi: nl80211: read WMM reg rule under RCU
* [PATCH wireless-next 16/18] wifi: ath11k: read wiphy regd under RCU
* [PATCH wireless-next 17/18] wifi: ath12k: read wiphy regd under RCU
* [PATCH wireless-next 18/18] wifi: cfg80211: regulatory: stop using RTNL

and found the following issue:
SYZFATAL: image testing failed w/o kernel bug

Full report is available here:
https://ci.syzbot.org/series/0ddad86e-f612-4f74-9efc-50b8333a678f

***

SYZFATAL: image testing failed w/o kernel bug

tree:      wireless-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/wireless/wireless-next.git
base:      f49defea7668d8c68ec19fa085ef3da6075561c7
arch:      amd64
compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/542e9d51-0d68-4eac-8303-1412498c7192/config



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
[johannes.berg@intel.com johannes@sipsolutions.net linux-wireless@vger.kernel.org]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

