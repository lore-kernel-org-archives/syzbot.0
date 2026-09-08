Received: from mail-oa1-f69.google.com (mail-oa1-f69.google.com [209.85.160.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35FDA524B08
	for <syzbot@lists.linux.dev>; Tue,  8 Sep 2026 21:45:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788903919; cv=none; b=Wn7igo0Xgj1l5er7/U4Lex9FLeiu0j+HXG1atHwNuT0yKjfgqGRhD6AD4FrPx3mvHrCqEDyLvaTkbvYeb69YL1hoNBTiHmfxCaM+VaG6LhLrAdd1FiKEFO5wIzG4OKlyPtRpR/Sg0pAEHVXQrC01ec8FyzAW57Thv9uzC0NZFa0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788903919; c=relaxed/simple;
	bh=uQW2+Dbv/tSQWMrQKnQt38dNZR+6zjHCUK9RWW7+ziA=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=VN2Hsc/4ojMs1mVHiIn0K4XUVN2wUCGCR2iCSyTBPKDC7Mue1ruvgAzABSd4nUUBHH/4ILdeSOezgdZZDFIFRc8e3yQzUu85wzHP8CTnH8/n2K3smnghE1Wrzos7T8s/wtXnBJPIfsoONDhBX7IHrqNdTVGn603Sy4MYOHgeXyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.160.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oa1-f69.google.com with SMTP id 586e51a60fabf-45ecb9dd589so3012850fac.0
        for <syzbot@lists.linux.dev>; Tue, 08 Sep 2026 14:45:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788903917; x=1789508717;
        h=content-type:cc:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FQA8PpJUJIMqFWTVOuzCafqVH3VRje2wdmaucgJF6L8=;
        b=SigOKfluMjv0c+Iaw9N/ic2QGltU0JFGhnzshpYMpQGCgbrgjuJ/b5DMPYEnma/r3I
         vRqHljBmfdtvNhTSn3AXK1IyRBidToNrome5R4gZIBDiak5CQ3wLc7aCq/dejtxuoWa2
         o/hqLeDha6xKnIJI/mzBpbJpkdeEy42tERMIPXTQuxzQX60yfSMwR/6o3RDdHISK4wDR
         ARsS2t9bC5/Si2AYkIBnU3Y3+9jDujCVEBbBlhF9NuW0MitHV83OGdq71YJH2NzDEKkW
         av+4l14q0K9UBGRfPzZZGACyz5Y3LnFf3mpIfE95mXwWgySdmXDWRtVyh90YlOdazeZV
         S7Nw==
X-Gm-Message-State: AFuF++ldDL0TBS0g+dczeAPtUkzZe6VH2vfoSFGJP7I2Dxfs0v3oApt6
	kUvWRdOoCxh5Y6xQMrIL1QwXjpRro+LdNc51+nBHCfryUlBOmHj3MvgT9/vOCc2S1Ed0yH1RPl7
	q9IMVTbdmTpeIoP5vCI3+3XVC/fKV9JHsQDBwN9XJqAuEXC5ENaRMXTwS5GQ=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:f02c:b0:6b7:8396:f3c4 with SMTP id
 006d021491bc7-6b78396f8b9mr17876517eaf.38.1788903917161; Tue, 08 Sep 2026
 14:45:17 -0700 (PDT)
Date: Tue, 08 Sep 2026 14:45:17 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6aa081ed.6e6c5f9e.28f11f.001a.GAE@google.com>
Subject: [moderation/CI] Re: wifi: Add Seamless Mobility Domain (SMD) AP support
From: syzbot ci <syzbot+ci4b9092ac2b5224d4@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v1] wifi: Add Seamless Mobility Domain (SMD) AP support
https://lore.kernel.org/all/20260908-smd-v1-0-9fd2d876a1fb@oss.qualcomm.com
* [PATCH RESEND wireless-next 01/18] net: skbuff: Add SKB extension support to wireless drivers
* [PATCH RESEND wireless-next 02/18] wifi: nl80211: Define Seamless Mobility Domain (SMD) device capability
* [PATCH RESEND wireless-next 03/18] wifi: nl80211: Add kernel interfaces for Seamless Mobility Domain setup
* [PATCH RESEND wireless-next 04/18] wifi: cfg80211/mac80211: Configure AP with SMD capabilities
* [PATCH RESEND wireless-next 05/18] wifi: cfg80211/mac80211: Parse SMD parameters in STA addition/modification
* [PATCH RESEND wireless-next 06/18] wifi: nl80211/cfg80211: Indicate STA creation via SMD BSS Transition
* [PATCH RESEND wireless-next 07/18] wifi: nl80211/mac80211: Add SMD BSS Transition sub-state STA flags
* [PATCH RESEND wireless-next 08/18] wifi: mac80211: Add driver_op for SMD substate changes
* [PATCH RESEND wireless-next 09/18] wifi: mac80211: Send BlockAck policy in AMPDU action
* [PATCH RESEND wireless-next 10/18] wifi: mac80211: Define SMD BSS Transition context for transport
* [PATCH RESEND wireless-next 11/18] wifi: mac80211: Enable skb extensions along with mac80211
* [PATCH RESEND wireless-next 12/18] wifi: nl80211: Define attributes to pack SMD BSS Transition context
* [PATCH RESEND wireless-next 13/18] wifi: cfg80211/mac80211: Handle UHR Link Reconfiguration frame
* [PATCH RESEND wireless-next 14/18] wifi: nl80211: Pack SMD dynamic context along with frame
* [PATCH RESEND wireless-next 15/18] wifi: nl80211/cfg80211: Add support for SMD context programming
* [PATCH RESEND wireless-next 16/18] wifi: mac80211: Add mac80211 support to handle NL80211_CMD_SET_SMD_CTX
* [PATCH RESEND wireless-next 17/18] wifi: nl80211/cfg80211: Add support for querying SMD context for target AP MLD
* [PATCH RESEND wireless-next 18/18] wifi: mac80211: Add mac80211 support to handle NL80211_CMD_GET_SMD_CTX

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/8d747db8-d307-40ad-aa87-3069da74c69e

***

kernel build error

tree:      linux-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/next/linux-next
base:      1b60ed34f712e9f606d80951f1586f4274ebadf1
arch:      amd64
compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/702b616f-509b-4fdc-8f3d-60b1cf2ff58d/config

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

