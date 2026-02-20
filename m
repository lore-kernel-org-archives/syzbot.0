Received: from mail-oo1-f69.google.com (mail-oo1-f69.google.com [209.85.161.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03707248F5A
	for <syzbot@lists.linux.dev>; Fri, 20 Feb 2026 15:21:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771600864; cv=none; b=Txg6CA1TSIrP0zkq4p5tBEcHWDmiPLDbNmAqEdVaTuYS7kiLcwcWABBQ7z6VntoijSflO3IpThbAK41WwvFdFk+faZTp/kdWCQlWgB0ebV+RAN8jIOpGQnAZSH3Ihp/ZPk/CXOdB1xPMO2NR9tFR0v4mFqagblUzwW2fiIXCT44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771600864; c=relaxed/simple;
	bh=aUmloWxJBE56C+BVdnNVm8TOD8Vh4NEo25zXcLXi/0I=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=GG+2w5EkkhHgKGB0zkeseYCe2RtVLQ4HUspBnM9uVqwI4YJdo5qxkcKfCFBFvXc0uUuu96wx0rqWu3LuI9KiJ8VgbDjpiCsdveOZ2+knnCCOjKgIscUtpjvIfiuSm7WmVN0rthkhvJbjnXmufNy8Uuz5m28bjRbikU0vatf9ues=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f69.google.com with SMTP id 006d021491bc7-6798921eff4so25179608eaf.1
        for <syzbot@lists.linux.dev>; Fri, 20 Feb 2026 07:21:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771600862; x=1772205662;
        h=cc:to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NmxIReBPJsAHbCfl66P/vX+2ZnjTe1Fwbq2oEWA9REo=;
        b=aSW1ycWM9RYeDgEqdE0LPW71c8evXAgvE/3/PtsxpVO1vRi4eO30YNXmOakTqdCekC
         THKUvUKeQRUZaHBlqxY9qo1H0tAig25yxLKcuuh0ovpP0GPSZhl8DJfy4OqJgfSNzzPn
         vN0AtClRS0nuCjwrlPm9O5Nb+QSjkL+pti0lfc5K0zYsM1EHggZrruEg/KqY2Hq/BN9o
         Mf6KIQygB7klPZKXbhZVhKPv5NziteFZ0Azx7JNy0RdJ6IxClMS4Pks40e89rWw307mY
         LxrngErTKbfwGCE5o9rDnRvKK/2rikEXjwDEg10ZzLzjMtED9+S3mxcoRXkFLbhJSCaN
         KxAA==
X-Gm-Message-State: AOJu0YyFAKWz29EMVAQ/Yv81pj6or0KLwxrKLG3z/koulofBzTgdBMT1
	UQoKLyN1C4057JkBiItXxzdufbUnAdjd+cZ4ShI5V4cHnvh4ZinKts1oRrivimgKw+iZvU8MM1J
	dZ7SV6x2CV5zr04GsQjnr0NNHDecAmBea+F941B+PQ2ipJd/k+FVH9HhifVs=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a4a:cf12:0:b0:679:c466:343f with SMTP id
 006d021491bc7-679c4663637mr72989eaf.45.1771600861808; Fri, 20 Feb 2026
 07:21:01 -0800 (PST)
Date: Fri, 20 Feb 2026 07:21:01 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69987bdd.a70a0220.2c38d7.0141.GAE@google.com>
Subject: [moderation/CI] Re: Adding NO_STA flag and reworking RX link resolution
From: syzbot ci <syzbot+cife30c3707edc3682@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v1] Adding NO_STA flag and reworking RX link resolution
https://lore.kernel.org/all/20260220141929.206976-10-benjamin@sipsolutions.net
* [RFC PATCH 1/8] wifi: iwlwifi: use link_sta internally to the driver
* [RFC PATCH 2/8] wifi: mac80211: change public RX API to use link stations
* [RFC PATCH 3/8] wifi: mac80211: refactor RX link_id and station handling
* [RFC PATCH 4/8] wifi: mac80211: rework RX packet handling
* [RFC PATCH 5/8] wifi: cfg80211: add attribute for TX/RX denoting there is no station
* [RFC PATCH 6/8] wifi: mac80211: report to cfg80211 when no STA is known for a frame
* [RFC PATCH 7/8] wifi: mac80211: pass station to ieee80211_tx_skb_tid
* [RFC PATCH 8/8] wifi: mac80211: pass error station if non-STA transmit was requested

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/aef950c6-dd02-4cc0-af4f-be3d1739f909

***

kernel build error

tree:      torvalds
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvalds/linux
base:      8bf22c33e7a172fbc72464f4cc484d23a6b412ba
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/89235db4-5426-4ae6-95de-9d6c07b940e7/config

drivers/net/wireless/ath/ath11k/dp_rx.c:2503:28: error: incompatible pointer types passing 'struct ieee80211_sta *' to parameter of type 'struct ieee80211_link_sta *' [-Werror,-Wincompatible-pointer-types]

***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[benjamin.berg@intel.com benjamin@sipsolutions.net linux-wireless@vger.kernel.org ramasamy.kaliappan@oss.qualcomm.com rameshkumar.sundaram@oss.qualcomm.com]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

