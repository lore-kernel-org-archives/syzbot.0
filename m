Received: from mail-oo1-f70.google.com (mail-oo1-f70.google.com [209.85.161.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F14239B49A
	for <syzbot@lists.linux.dev>; Tue, 14 Apr 2026 11:15:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776165336; cv=none; b=Hfh9J/cKReq3q8zeU/fZbTlly83syXZON+cRvDpmVVpOs/GzOlnLk23fZqXmBjHhUjTC1II0MCy4xD0e9nshitFC5apAAEeLcKmDIiv9kf+jM2nvAKZaC1BgtDxAmGUf3Cx+UaeWj7Ic3IuzpsF7keq9nj6UkxHwVDXHtLpNCEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776165336; c=relaxed/simple;
	bh=iVczHDa0yb7kMde1Z9ZjgM/q1S2ZDptpwNRDbynkDUY=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=gCmJdjb4BWvL+BBkqU6YOwOoUNbQF9F2/24guf8fEhbsDZWBN+3HJTS3goNY9Udw9lbYygNoLGJA2/yvrHVagJ106MG28mdWvoIv9rEXLXzRbV4lMTjXLZUaazU6EDNERzz0U2/FZqMEG3lnwEc8onBkfCvmTXhLm32JuAurno4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f70.google.com with SMTP id 006d021491bc7-679c51b2d6cso9115278eaf.2
        for <syzbot@lists.linux.dev>; Tue, 14 Apr 2026 04:15:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776165332; x=1776770132;
        h=cc:to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NflrQLJ7yA3YY84tTlkreZ0rX13IAYTISZPKgi+CHsY=;
        b=BV1VYxJWu9ZZlNKuNA7Qvrcvkx69oX+pv9IaeIB1bAcEQnDd6IRw4/qpqdOEtxUyTX
         zDPno4v7xszhSOXEdO6+FA0s8aaxRdeNraTTrQswaNaH0+PLcGs3iMUN5cxMr5qqFXd3
         5cyxuQ7m5ckuoaTVpwIMl5H9/13d4bPv/ms9UA6kIaurfalY4VNTjV1JSzSWan49Rdxt
         yDBXdXHQuDvXNH0tNv9o8M2wPppVpjoIsW9GU0K3R1JovHxbdx1Dcnf4bbK1+Jd5Ro0/
         Gh+VZXUlgBbKfLPs3Wrvm+aWSgenh/kVqa5Eqd8CZiL2nodpaig84fHgScsLjbgjwP6u
         y2sQ==
X-Gm-Message-State: AOJu0YydFokJHqv9pcFL63KzB7Gzfzm1I2GC0+zh1528oy/wFnZBtbMt
	oi5Uls6m+FxSzogy7Mo3U0BgxuCyN4Nd/PRCz3lNSVg/POmuvzGJZzOctEjZvDz/WBBjiNA3RHQ
	nv4EWkvRFkSbKo9K9tVwjnNItF4zZFeTk1pTQCaEhR8ZOp+e+Lh3uC73zW9A=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:1f05:b0:67e:f8c:6bdb with SMTP id
 006d021491bc7-68be681bc69mr7888827eaf.24.1776165331946; Tue, 14 Apr 2026
 04:15:31 -0700 (PDT)
Date: Tue, 14 Apr 2026 04:15:31 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69de21d3.a00a0220.468cb.005e.GAE@google.com>
Subject: [moderation/CI] Re: EML Capabilities compliance changes
From: syzbot ci <syzbot+ci33b6c2303971f18f@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v2] EML Capabilities compliance changes
https://lore.kernel.org/all/20260409135035.4018725-1-pmartin-gomez@freebox.fr
* [PATCH v2 1/4]  wifi: Remove invalid 128TU transition timeout constant
* [PATCH v2 2/4] wifi: Remove EMLMR Delay subfield definitions
* [PATCH v2 3/4] wifi: Rename EMLSR delay constants and add EMLMR helpers and definitions
* [PATCH v2 4/4] wifi: Update EML function documentation to remove EMLSR-specific references

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/967a3c8a-f52b-456f-ba2d-fc09cb006ba9

***

kernel build error

tree:      linux-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/next/linux-next
base:      709503c4a2102b32de4b4e64687df86503c74eba
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/0de3eafc-c510-49f5-b272-35bc499d3d4f/config

./include/linux/ieee80211-eht.h:1138:18: error: use of undeclared identifier 'IEEE80211_EML_CAP_EMLSR_PADDING_DELAY_256US'
./include/linux/ieee80211-eht.h:1188:25: error: use of undeclared identifier 'IEEE80211_EML_CAP_EMLMR_SUPP'
./include/linux/ieee80211-eht.h:1200:18: error: use of undeclared identifier 'IEEE80211_EML_CAP_EMLMR_PADDING_DELAY_256US'
./include/linux/ieee80211-eht.h:1218:25: error: use of undeclared identifier 'IEEE80211_EML_CAP_EMLMR_SUPP'

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
[johannes@sipsolutions.net linux-wireless@vger.kernel.org pmartin-gomez@freebox.fr]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

