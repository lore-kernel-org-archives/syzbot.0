Received: from mail-oo1-f71.google.com (mail-oo1-f71.google.com [209.85.161.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC237209F43
	for <syzbot@lists.linux.dev>; Tue, 10 Mar 2026 01:02:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773104524; cv=none; b=O3O+KTgVJozoCPtngGxZfbctvFJrvQhpwlZHUj8nq7nhBqCATsZ6bnYiXKPEmmCCOsXmjW0j/U04x5Mdo3RUZVfb5m4TEhAhqoicAGYEYykM1b5qV4Dumc78mbTXDnUSaG5NIgofuwyh1Gf71Z8L39cR/UUhdtCTrOiXfDYGpSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773104524; c=relaxed/simple;
	bh=b1qvtP92nZHUBNNrAuQIo9YToKG7c+Gj+pytAC66FS0=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=cotsQ88WsYfzEjjIHxpbYSsTItbtDmJanEhd7R7VxVBJbdDJKZ8ylcfw2cksIb8fCkuad2M4fcxvV8oG8i7GUHrKUqIHTW2GdvI75LFrNCXfIpUfEtXductxIUb71hxu1XJVwFSTxzvuYI1d3+8oNVMgNdW4e+vVOt0eXzB0IXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f71.google.com with SMTP id 006d021491bc7-67ba8eabf6dso26801372eaf.1
        for <syzbot@lists.linux.dev>; Mon, 09 Mar 2026 18:02:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773104520; x=1773709320;
        h=content-transfer-encoding:cc:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KCshG7L8bVm1A/ycOIpb9bRrj/aapZxMch2UA7y8vvg=;
        b=kV9jv/sYePd2tiahwu9XvAORISRF3FQ1X3MpkyzQ9q1jdfQ85DsYtBuHX8OvSmGucO
         X+DAoFvBqTrzjJNFDNYNxSKD5/xy2fT9bqiLd+t/tPROyr1mRPHITwfuSwGo5eZKHPyG
         0OHGOAla3cBoz9TT5exWWEnxxAHKhO0UWoY9qHfhfU7LgWfITrrvcPj5GMoLPwt1rn6b
         qf0EEsskKa6PmHbqZ2NYokFeK/SUjjFNag1X92jSpNwdKVClFHuC19L/Hs0EmrbZRY6B
         4D5JbmYXKXbEyw+/OU6eoRyN7+CHlS03aNhVqx4kDAgAroZh9FUXuqf2ZwQUSM3UG08f
         OJrA==
X-Gm-Message-State: AOJu0YzdjFR03ZQ7+8ZZEsxwZtPn43LbininVNr0hDmWb6kuSLAEApaL
	08vxdWpNn2UrMaTN7C1TIzqr8opjht3nFD6LWTZJSkFXBQgCAye2q0eof7OL4f43SityPtBUxRY
	LlOMqLEm6egq+tCRXSLVnnRL+4kGR8FXQOOiJJPwQ38OhZVrR9Lq1q+i1EwU=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:2017:b0:67b:b5ca:cdf9 with SMTP id
 006d021491bc7-67bb5cad13cmr3365175eaf.57.1773104520659; Mon, 09 Mar 2026
 18:02:00 -0700 (PDT)
Date: Mon, 09 Mar 2026 18:02:00 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69af6d88.050a0220.310d8.0036.GAE@google.com>
Subject: [moderation/CI] Re: hsr: Add additional info to send/ receive skbs
From: syzbot ci <syzbot+cib68faf1da08cba19@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v2] hsr: Add additional info to send/ receive skbs
https://lore.kernel.org/all/20260309-hsr_ptp-v2-0-798262aad3a4@linutronix.d=
e
* [PATCH RFC net-next v2 1/2] hsr: Allow to send a specific port and with H=
SR header
* [PATCH RFC net-next v2 2/2] af_packet: Add port specific handling for HSR

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/bd2344c8-000c-4973-9c61-c1487f460d8f

***

kernel build error

tree:      bpf-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/bpf/bpf=
-next.git
base:      1f318b96cc84d7c2ab792fcc0bfd42a7ca890681
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp=
1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/8f8db96c-13f9-4426-bdfe-fbfcae8c11c=
d/config

./include/linux/if_hsr.h:58:12: error: call to undeclared function 'skb_ext=
_find'; ISO C99 and later do not support implicit function declarations [-W=
implicit-function-declaration]
./include/linux/if_hsr.h:58:30: error: use of undeclared identifier 'SKB_EX=
T_HSR'
./include/linux/if_hsr.h:71:12: error: call to undeclared function 'skb_ext=
_find'; ISO C99 and later do not support implicit function declarations [-W=
implicit-function-declaration]
./include/linux/if_hsr.h:71:30: error: use of undeclared identifier 'SKB_EX=
T_HSR'
./include/linux/if_hsr.h:85:12: error: call to undeclared function 'skb_ext=
_find'; ISO C99 and later do not support implicit function declarations [-W=
implicit-function-declaration]
./include/linux/if_hsr.h:85:30: error: use of undeclared identifier 'SKB_EX=
T_HSR'
./include/linux/if_hsr.h:99:12: error: call to undeclared function 'skb_ext=
_add'; ISO C99 and later do not support implicit function declarations [-Wi=
mplicit-function-declaration]
./include/linux/if_hsr.h:99:29: error: use of undeclared identifier 'SKB_EX=
T_HSR'
./include/linux/skbuff.h:5034:7: error: conflicting types for 'skb_ext_add'
./include/linux/skbuff.h:5079:21: error: conflicting types for 'skb_ext_fin=
d'

***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[andrew@lunn.ch bigeasy@linutronix.de c-vankar@ti.com d-qiu@ti.com danishan=
war@ti.com davem@davemloft.net edumazet@google.com fmaurer@redhat.com horms=
@kernel.org j-rameshbabu@ti.com kuba@kernel.org netdev@vger.kernel.org pabe=
ni@redhat.com richardcochran@gmail.com willemdebruijn.kernel@gmail.com]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

