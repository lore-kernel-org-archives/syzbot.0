Received: from mail-oo1-f70.google.com (mail-oo1-f70.google.com [209.85.161.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5138537B41F
	for <syzbot@lists.linux.dev>; Mon,  4 May 2026 22:13:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777932841; cv=none; b=YG38VQP0XLw+D+x5Ud9Jyiabyiarw+VWWNPI8m3dVFWFBZAHTbHH11A5Xs2Xl+AdE39svAhaTRMPRFE90O0RlX/NwHclYarlqTP8216NU/Y7sq3F75Rp0uWVqkK3RdHAl/v3PWO6aXZ8SvvEEObcrcdLFByKFof+MMEhf1Ii7k4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777932841; c=relaxed/simple;
	bh=JoUokRH01gcvVryF8eDp7xWwW20EcrDPQhoh9NB+ULU=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=VDTCywBaV+ht795/YjYCynan0ThvovP5G43KhagPWEsbnYYG5Q2vqb38cxyWQfFd1RtZG3TJpKBQdhvLWgqh9cXXPQF32YjHDCPJEbTLttUXEil0OiAReUXPY0UwpIaBl/+uly/2NIex+uTLBDkjKa4l+SOOFaNkLGm0F2B2Nrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f70.google.com with SMTP id 006d021491bc7-68e924f632bso9192890eaf.0
        for <syzbot@lists.linux.dev>; Mon, 04 May 2026 15:13:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777932838; x=1778537638;
        h=content-transfer-encoding:cc:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mLBN9o077Ldikd6PkwIy4yApGcOIgb8bbwoiZsTfQYw=;
        b=NT3NFGkVpvwLA2GZ4i09xmceVuMLrEf7pwlMO0EMvp3VsscYeEIkavkiYB0blcZjJB
         UVDQr6BCrg3AXUh/ji+mxEJbjLNEZjLOyltHEOzkv9uvKyHkjT6nf9Ebdb6tBDkXOr4S
         IGJV1tqan2UXVOQ7GT/mv9nnXHcKS1NzyXFe1uElMVb8Z4UGF/CfCji7Anz9FyLE6BN4
         eHDIeN2Ie7CpaTYWZKay/CWO0sysjE6L0iXBybTIITWKsoyiVdPI7hcE2sBtLm4ByPAd
         2UC0YpNFGpvSFAMY9dGG3SeN7HSIadl9NkWwoi6HmhAQq0+EApEpqN+oiOhnfXV3sIXm
         VrlA==
X-Gm-Message-State: AOJu0Ywe/ExgAV8L6Zjd3jzw2oV/0qRuyzmNHyml69w9fMApJFe7RfSn
	FtsZgWvZM+SFlLBsq+MxvauKOhc0xB+NBvolF39RzR0CcXJQXgdDe5fuXD64ftao6F/4bi/xYyI
	+Ysg6BXR30/CGXmveNOkSfL0Fd0rIsWQjoNGvWsENT4XHp333d14hVB5qU/0=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a4a:ec46:0:b0:694:a362:e3ab with SMTP id
 006d021491bc7-69697df7335mr5922490eaf.55.1777932838421; Mon, 04 May 2026
 15:13:58 -0700 (PDT)
Date: Mon, 04 May 2026 15:13:58 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69f91a26.050a0220.892e9.00da.GAE@google.com>
Subject: [moderation/CI] Re: batman-adv: use neigh_node's orig_node only as id
From: syzbot ci <syzbot+ci03da7a54cc6d1041@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v1] batman-adv: use neigh_node's orig_node only as id
https://lore.kernel.org/all/20260504-neigh_node-no-orig_node-v1-1-33b282272=
711@narfation.org
* [PATCH batadv-next] batman-adv: use neigh_node's orig_node only as id

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/544b4a3b-4abc-44f9-ad92-7f08624a2cf7

***

kernel build error

tree:      bpf-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/bpf/bpf=
-next.git
base:      1f5ffc672165ff851063a5fd044b727ab2517ae3
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp=
1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/f4c3a9b9-a9f0-48b5-9136-49c963cda40=
8/config

net/batman-adv/bat_iv_ogm.c:186:14: error: no member named 'orig_node' in '=
struct batadv_neigh_node'
net/batman-adv/bat_iv_ogm.c:1040:48: error: no member named 'orig_node' in =
'struct batadv_neigh_node'
net/batman-adv/bat_iv_ogm.c:1042:53: error: no member named 'orig_node' in =
'struct batadv_neigh_node'
net/batman-adv/bat_iv_ogm.c:1375:50: error: no member named 'orig_node' in =
'struct batadv_neigh_node'

***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

To test a patch for this bug, please reply with `#syz test`
(should be on a separate line).

The patch should be attached to the email.
Note: arguments like custom git repos and branches are not supported.

The email will later be sent to:
[antonio@mandelbit.com b.a.t.m.a.n@lists.open-mesh.org bird@lzu.edu.cn dave=
m@davemloft.net edumazet@google.com horms@kernel.org kuba@kernel.org linux-=
kernel@vger.kernel.org marek.lindner@mailbox.org n05ec@lzu.edu.cn netdev@vg=
er.kernel.org pabeni@redhat.com sven@narfation.org sw@simonwunderlich.de to=
mapufckgml@gmail.com wangjiexun2025@gmail.com yifanwucs@gmail.com yuantan09=
8@gmail.com]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

