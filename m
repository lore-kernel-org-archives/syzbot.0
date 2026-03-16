Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com [209.85.210.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF6D03659E8
	for <syzbot@lists.linux.dev>; Mon, 16 Mar 2026 21:39:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773697201; cv=none; b=P1NlUHGagh4wtZMRe4tkfn4GUE12D2RSWCyw3KhAF0V5Dwr411fb1jM+GKESqXRNFm9ASY1g54w8yVB7eWkUjMnlpLTeEd7jbiSLl2Pb/VbmU7tLWNC0vKkLWWaKtefVypFfe8oqJzs75FWuTdoqRVfSm/zgmVjCMOezfsx64kQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773697201; c=relaxed/simple;
	bh=xfZjFacUfBagkoy2u5mACn49PxEes5fwWIlEH05EL0I=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=BJAx3LVE5uOn63pJjaWZSTPVpD1Uf8PXYyhVO7ss5xPPyKaOEu+LGNBxsPplqKr12QBqJKgqezjlG38XVYCjk3YcpDrbiRQPgUxSsFM03Un4kKEJpY//aF7yOH8+3o1tvvmBBI6sKkK2JrTsaGiRkfya90A4uzJ3DPWHWcbe4RU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.210.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f70.google.com with SMTP id 46e09a7af769-7d777c61520so21116724a34.3
        for <syzbot@lists.linux.dev>; Mon, 16 Mar 2026 14:39:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773697199; x=1774301999;
        h=content-transfer-encoding:cc:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Z4MjmWxjOBr/ksQrebnWVN2g9cjzB97k/ZzHqWdVZZw=;
        b=B7/QV5VvGCPL32hGOWXXtDT+G7Rov75Ze2kCkdM2zScyGCX8x5b1Tk9AqDnjqUPUe0
         /dHi1eHxhY2xp4FPAZuMTQNBC5JT3PQ3jhDKkyOB670nqEUjLu/YLA/vbPnzOUGMsWXX
         ss+DMoHWUlE1vfUGNnj9yVHvmdw2nK9xE5ZwgK5vJAOlnMvVfQtlJK5FleZZXYyhu6n8
         J6ZcoacuPbeX/DMMeh9biyygWesYtIzQhebyYptdK2Ue3CuTRSXmpCc3qJL2lChC11Ns
         MSIPCotFLj0DOWoR1YCD1t/mle1kxGcXeabyKnjEKSSgymiEfiRvhc1ZsfPOt7B1FUHF
         7xkw==
X-Gm-Message-State: AOJu0Yxca2f0EG+zAUYVt+qEHjt1hFrSvVpXTZp2/VDumVeKvmbuB99O
	mhI9aoTOr30j4I1TQAgmytd0yhipvHu14xeGsrrGcfhQdA/JqYHMsWc85m1wgxhrP8q/PDNxp6/
	gbzhiotxhjPuKuqhxsHVAd72WItneiuCbn2rtZ8Nmh5XMdGZ7uJmGZl+geX0=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:621:b0:67b:af79:4c21 with SMTP id
 006d021491bc7-67bda97f485mr8497696eaf.2.1773697198857; Mon, 16 Mar 2026
 14:39:58 -0700 (PDT)
Date: Mon, 16 Mar 2026 14:39:58 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69b878ae.050a0220.248e02.011d.GAE@google.com>
Subject: [moderation/CI] Re: Use the QMI service IDs from the QMI header
From: syzbot ci <syzbot+cie83dda8cdc358949@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v2] Use the QMI service IDs from the QMI header
https://lore.kernel.org/all/20260316171419.2619620-1-daniel.lezcano@oss.qua=
lcomm.com
* [PATCH v2 1/4] net: ipa: Use the unified QMI service ID instead of defini=
ng it locally
* [PATCH v2 2/4] wifi: ath: Use the unified QMI service ID instead of defin=
ing it locally
* [PATCH v2 3/4] slimbus: qcom-ngd-ctrl: Use the unified QMI service ID ins=
tead of defining it locally
* [PATCH v2 4/4] ALSA: usb-audio: qcom: Use the unified QMI service ID inst=
ead of defining it locally

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/a7a585ab-172d-40a0-ba91-1886887daddf

***

kernel build error

tree:      net-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netdev/=
net-next.git
base:      97e4567d39941248579da34b7fbb568e6659511e
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp=
1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/c4068879-f990-4c0a-9fec-fd918102a7e=
1/config

drivers/net/wireless/ath/ath11k/qmi.c:3340:40: error: use of undeclared ide=
ntifier 'QMI_SERVICE_ID_WLFW'

***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[andersson@kernel.org andrew@lunn.ch arnd@arndb.de ath10k@lists.infradead.o=
rg ath11k@lists.infradead.org ath12k@lists.infradead.org broonie@kernel.org=
 dan.carpenter@linaro.org daniel.lezcano@oss.qualcomm.com davem@davemloft.n=
et dmitry.baryshkov@oss.qualcomm.com edumazet@google.com elder@kernel.org g=
regkh@linuxfoundation.org jjohnson@kernel.org kees@kernel.org konradybcio@k=
ernel.org kuba@kernel.org linux-arm-msm@vger.kernel.org linux-kernel@vger.k=
ernel.org linux-remoteproc@vger.kernel.org linux-sound@vger.kernel.org linu=
x-wireless@vger.kernel.org mathieu.poirier@linaro.org netdev@vger.kernel.or=
g pabeni@redhat.com perex@perex.cz quic_wcheng@quicinc.com srini@kernel.org=
 tiwai@suse.com]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

