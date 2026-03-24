Received: from mail-oo1-f70.google.com (mail-oo1-f70.google.com [209.85.161.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 851CE40824B
	for <syzbot@lists.linux.dev>; Tue, 24 Mar 2026 17:47:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774374433; cv=none; b=j6G3ahpeozx1dwZCnh+DmzpduVAN03Ce4qIIbXwE8RB258C428u6kIZuVbbH44A2dyKtYG5y1lDruHn67GL+8c8EYNbTCYREg2JUirHQYFRSJM6tBkX4P/iD+9n9zS+h4TMQb2trsin3gigWnk2ab7/UCuMvkgOvVjVpRYpQ1GM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774374433; c=relaxed/simple;
	bh=WpYfSTEG8EwlGJMbTJTSjwUHewHoUWk6pfelAjItKlw=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=I78wXoSTqyOyZtwC/lX4C6rU1tv4HeRdX+CZz0zr0ngoSPGeobp8sO8IEHHfljjBSqRqjS9kcQrUXhaYtjD+eTbWIEc9EtFY2+8LURgK61c7zuenuf7Ytc/ZBNEXhZMlupm0rV6fxjAyVZ1eAAeQiiF4qUT5GlxPPu+NCoF7uFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f70.google.com with SMTP id 006d021491bc7-672c40f3873so20988786eaf.2
        for <syzbot@lists.linux.dev>; Tue, 24 Mar 2026 10:47:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774374431; x=1774979231;
        h=cc:to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=k63m8TA33rM0im6YZHwU4iMgvOtUUmk69F4n7VnJUcM=;
        b=cdRAfPmr1WaLjd23s0yVCuMu+UcthFOMYL6aWLmnX9rQBcFr+v1brpDDqAa37TxCmx
         fG7CzhxnDm3eHdmUmPXRi0olNwtsGzBiZBW+66gRk7yY+1GBp180+HUo3lmWjxMIgtj6
         6Epd7tt4ZwnM9mX1FQIZq/Bp7B5WlYCJXUhjWlmWiW4mZ/COxaQTjAsPweoqk5/Y/azq
         a5ipU7onhHdpYindANV/e+S+hkGXYT00joza7Ja7p/dpBpqzw9BZRW7PChvul3s80cWi
         x+8hcFDvXCOwdmE1uI3a7PySBnZegqtpnSIKSVX1vS2sKcPcB5Zj8ftzWq5+qI4wKF1e
         6skg==
X-Gm-Message-State: AOJu0YxUNqhnQXz9cmzfkJvTh5PnxksR5zgZuu1cv8B1ySvsNj9Ie+jY
	NMk2Ne+d48N6D4dQ7ah1U1FoSDEL088Gm5GU087n8g1vD+zhdO1oPLpUtYDhUqmA67NeL8lCLSd
	zkaaENJTwmiLwIDsUEtCFrNieXA1X72+cqJCvXoDRgbsUcYGbVT5AcaJT/eo=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:210f:b0:67b:f37b:60fe with SMTP id
 006d021491bc7-67dff37c85bmr389816eaf.14.1774374431420; Tue, 24 Mar 2026
 10:47:11 -0700 (PDT)
Date: Tue, 24 Mar 2026 10:47:11 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69c2ce1f.a70a0220.3cae05.0011.GAE@google.com>
Subject: [moderation/CI] Re: net: hsr: subsystem cleanups and modernization
From: syzbot ci <syzbot+ci22ec02407fef8213@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v1] net: hsr: subsystem cleanups and modernization
https://lore.kernel.org/all/20260324144630.189094-1-luka.gejak@linux.dev
* [PATCH net-next v1 1/7] net: hsr: constify hsr_ops and prp_ops protocol operation structures
* [PATCH net-next v1 2/7] net: hsr: replace fallthrough comments with fallthrough macro
* [PATCH net-next v1 3/7] net: hsr: remove unnecessary void function return statement
* [PATCH net-next v1 4/7] net: hsr: use __func__ instead of hardcoded function name
* [PATCH net-next v1 5/7] net: hsr: remove unnecessary braces for single statement block
* [PATCH net-next v1 6/7] net: hsr: add missing blank lines after function declarations
* [PATCH net-next v1 7/7] net: hsr: use BIT() macro for bit shift constant

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/a2540c74-9225-4792-841e-9245a4fe3552

***

kernel build error

tree:      net-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netdev/net-next.git
base:      b1c803d5c8167026791abfaed96fd3e6a1fcd750
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/2decc47a-a674-4a52-860c-677592fe5f4a/config

net/hsr/hsr_netlink.c:436:2: error: fallthrough annotation is outside switch statement
net/hsr/hsr_netlink.c:527:2: error: fallthrough annotation is outside switch statement

***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[davem@davemloft.net edumazet@google.com fmaurer@redhat.com horms@kernel.org kuba@kernel.org linux-kernel@vger.kernel.org liuhangbin@gmail.com luka.gejak@linux.dev netdev@vger.kernel.org pabeni@redhat.com]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

