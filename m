Received: from mail-oo1-f72.google.com (mail-oo1-f72.google.com [209.85.161.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FFAE3290BD
	for <syzbot@lists.linux.dev>; Tue,  8 Sep 2026 02:01:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788832920; cv=none; b=e/XfVYxNZ3SR633d05w/6HT+brb3zitqS52/rfCSNxg5s9aw5FVgWzMKNnfZGkSeeaIJY38aAG7GskVlOgCh2KzAgYclzBIR7UVYimovHi9phZgUDWRqYh3qIwiVeF8Ab1P4qtCrVPFQukOiXrDgzLn5sqelb6dnHjp2efcRSw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788832920; c=relaxed/simple;
	bh=x48JtcQT3UuGKZKoY70j62nzSJi6WpRf+uwIhaPm8qU=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=DJiub31E915d6zBMdcS1TEj1vd1Czml7aWDEAx4o77sVC+lWXdt9n/aC6RCdKMkvfY9FDI6IDcTZWlscTHffvnYxadmbQ9SZMCxkkhOp/qnqyuKyQl8+loF0++528uzWUHyjPbs2IcmAufmE5DP4Eel85qKidfr3/90DebpolMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f72.google.com with SMTP id 006d021491bc7-6b34e02c466so4510827eaf.1
        for <syzbot@lists.linux.dev>; Mon, 07 Sep 2026 19:01:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788832917; x=1789437717;
        h=content-type:cc:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=EGEFtXtRkvyUQzhG8lrKYvwfQmWxFzASTDwT46i68M8=;
        b=am82rQQEEuN82Z9nRXgbv9sq1jv8cZL/q1CCDnT4Vqm9D4i1+bIYp9WkIXQ5Sh8N/a
         ol252F4wLOFGXQeAGH29NaT6+I208XohVJYi4mLCzI4b7PW+aG6mKYD6x5IG8WxUT8z0
         EHc3BFtUe0KT85QBOHppeaBVG0nsxhkaqsFeQPzS1jVLTnrlJLjYcIu3r8ouwhBRD3Rc
         ZsPEyQNmVEFD22GRNDXYriL0H/y0Wb7eCvvWHoA8kzh1rOUW28Bwd1bsp8+VXOe3rEeT
         C8WadC3MWVKwBXYKdih5u+LHUnkUoKInP8FU003yWkFoLjl3I6tVtBqrNqOFHHqyDd6G
         9WoQ==
X-Gm-Message-State: AFuF++nD3g3M7E8NTVWAj9+fyljt+Y07JqAu1SoED/FFYF2wQoSqYhXl
	ElWfH1xO4F4EPoWAuZuKeBOkKtB8l2rJh6Tc7I2lJa2F7QdQr7fcw/1yToFXdtMOXTE4WXJM/ZR
	REd0OGvgtXX81XtoAFv6yMSdigwPMRwaclWUv0LH/lWBA2R6cE1yiPu/fq4Q=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:c0cb:10b0:6ba:7e88:7490 with SMTP id
 006d021491bc7-6ba7e88762dmr2603285eaf.33.1788832917254; Mon, 07 Sep 2026
 19:01:57 -0700 (PDT)
Date: Mon, 07 Sep 2026 19:01:57 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a9f6c95.f614420e.2bf292.0003.GAE@google.com>
Subject: [moderation/CI] Re: wifi: Add Seamless Mobility Domain (SMD) AP support
From: syzbot ci <syzbot+cid9ff6b9648f04d63@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v1] wifi: Add Seamless Mobility Domain (SMD) AP support
https://lore.kernel.org/all/20260908-smd-v1-0-65ad4ab30fbd@oss.qualcomm.com
* [PATCH wireless-next 01/18] net: skbuff: Add SKB extension support to wireless drivers
* [PATCH wireless-next 02/18] wifi: nl80211: Define Seamless Mobility Domain (SMD) device capability
* [PATCH wireless-next 03/18] wifi: nl80211: Add kernel interfaces for Seamless Mobility Domain setup
* [PATCH wireless-next 04/18] wifi: cfg80211/mac80211: Configure AP with SMD capabilities
* [PATCH wireless-next 05/18] wifi: cfg80211/mac80211: Parse SMD parameters in STA addition/modification
* [PATCH wireless-next 06/18] wifi: nl80211/cfg80211: Indicate STA creation via SMD BSS Transition
* [PATCH wireless-next 07/18] wifi: nl80211/mac80211: Add SMD BSS Transition sub-state STA flags
* [PATCH wireless-next 08/18] wifi: mac80211: Add driver_op for SMD substate changes
* [PATCH wireless-next 09/18] wifi: mac80211: Send BlockAck policy in AMPDU action
* [PATCH wireless-next 10/18] wifi: mac80211: Define SMD BSS Transition context for transport
* [PATCH wireless-next 11/18] wifi: mac80211: Enable skb extensions along with mac80211
* [PATCH wireless-next 12/18] wifi: nl80211: Define attributes to pack SMD BSS Transition context
* [PATCH wireless-next 13/18] wifi: cfg80211/mac80211: Handle UHR Link Reconfiguration frame
* [PATCH wireless-next 14/18] wifi: nl80211: Pack SMD dynamic context along with frame
* [PATCH wireless-next 15/18] wifi: nl80211/cfg80211: Add support for SMD context programming
* [PATCH wireless-next 16/18] wifi: mac80211: Add mac80211 support to handle NL80211_CMD_SET_SMD_CTX
* [PATCH wireless-next 17/18] wifi: nl80211/cfg80211: Add support for querying SMD context for target AP MLD
* [PATCH wireless-next 18/18] wifi: mac80211: Add mac80211 support to handle NL80211_CMD_GET_SMD_CTX

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/1a388df4-b5e3-46c7-9980-6133726b7606

***

kernel build error

tree:      linux-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/next/linux-next
base:      1b60ed34f712e9f606d80951f1586f4274ebadf1
arch:      amd64
compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/221dc5b5-3615-4d21-b5bf-bcd5f2afaec7/config

net/wireless/nl80211.c:19576:7: error: use of undeclared identifier 'n_dl_tids'

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
[davem@davemloft.net edumazet@google.com horms@kernel.org johannes@sipsolutions.net kuba@kernel.org linux-kernel@vger.kernel.org linux-wireless@vger.kernel.org netdev@vger.kernel.org pabeni@redhat.com pooventhiran.g@oss.qualcomm.com]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

