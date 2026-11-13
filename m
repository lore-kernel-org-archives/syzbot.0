Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.161.72
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794545915;
	b=bFIOVumEyk4Ly3QKetrhYuWscvAUnSYHRYKo+CZELDJik3mVz5Z5zOC0JQG8Y+rq2EV9
	 wcqo1h9LQsNBeqm4UOQeeaELuRbpTOnQOGI014ONIZFzAkBgHAmDTJ2U1gA38IZP6W12l
	 Ce7OioRtWuv2GiQvigB+fkIIupNa1X+wPjxqqSQKlZA+/AtGZdlFNzANTtogfK6AGY4C6
	 8PF/WEkpmWmKhs3cFR7mxcrdodXfuDA8CgmNKgh+I23mbPYCOdcJSukS92GILQ/nqsziF
	 JrI+BAmU04ieiGppQhh62Txc5WiDgIWtMp3WB+wnleQA5zUys/54mXzAuHfTAKUnt0w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794545915;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 MIME-Version:X-Received:Date:X-Google-Appengine-App-Id:
	 X-Google-Appengine-App-Id-Alias:Message-ID:Subject:From:To:Cc:
	 Content-Type:Content-Transfer-Encoding;
	bh=xtHgysPgrczk6LpxQoNwhqS3nCWVjfEv2PMqvR+TINc=;
	b=3FtwEq/vs1NoCqbYeIqahdhJGBkoS72sNdujKpXfWtRBCOJNUD49nIrb/pIXzs1kLexy
	 SFNHoz4xCzZRAgRR9RE+7+krWLqUYhiBCJ0KLHbEJiQnbXFdWgraJAfKhRRPkfapHk+81
	 z5Af4xFAWwniAArol2EMTxv1SXPnNVmXieo8aAlCIGZB6ixS+XxrYHnvudfvKkULZIqto
	 Irotu+KU4PkwAe6SfMWTCWgE+1WuKocf81rSZTzbkDyF99q5BSj3v4zYc10xbvqZDDZcN
	 VPqQ+Jx3d2/6OVfM5FdLqhtOVuWSEHdMTV4lmfbZno2yiw4tdKrPu2zF4FEQfzrrX/A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=syzkaller.appspotmail.com;
	spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	arc=none smtp.remote-ip=209.85.161.72
Received: from mail-oo1-f72.google.com (mail-oo1-f72.google.com [209.85.161.72])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93558606A31C
	for <syzbot@lists.linux.dev>; Fri, 13 Nov 2026 04:58:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 93558606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f72.google.com with SMTP id 006d021491bc7-716e12adef7so965116eaf.1
        for <syzbot@lists.linux.dev>; Thu, 12 Nov 2026 20:58:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794545913; x=1795150713;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:date:mime-version:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=xtHgysPgrczk6LpxQoNwhqS3nCWVjfEv2PMqvR+TINc=;
        b=039cSAJoIaoaneX6klfvq33Qj/FOO8J8Kswk3mlzlQDbnN2orTqwkhDGxa2dOnbNdj
         Y26W2W0/5LCqhocf02QEuQklKjvXOSW/2dO1613mU7+YYnC75658GuXTM7Ja7K4Jzz9y
         uKl8nybzhT3uxrVlxuoFJMrlbo56DWt2Bhof6EJ/84O+1MOZK8aPfI4dYxtVWEpkcCPV
         7SiMJaN9xAD5EQnaycKVubnuvDO3P1mPAqebQhAypGaXF9BYIztL7Qfi5nQqHDUkbqSl
         DykOnWOgfq19n6kne/W4dXSdFg4ja3EikoriyIgfDDuLMt747H69LSWIiUApwQg8y9xR
         TFFw==
X-Gm-Message-State: APuU4Z+HXJX5tOgEf17gp2j0Z4dB0Crop0tNMNG9jxzXl3QMIEti5H5M
	tvlkz0RI0X3+rq64YOzNBkd1hfQlPYXl3o1BcLVd5p/NeML5vOr25RcN5D6E5pmk6sKTvvAlADn
	r5odoJoIDCy58WbNIWy1f5PkR3XSCx8Nun704RbQQZLhcJeGlcYyS0hVXqlE=
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Post: <mailto:syzbot@lists.linux.dev>
List-Help: <mailto:syzbot+help@lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
List-Owner: <mailto:syzbot+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-Received: by 2002:a05:6820:1c85:b0:6d3:abd1:9b97 with SMTP id
 006d021491bc7-7197cfb69a1mr3413084eaf.61.1794545913676; Thu, 12 Nov 2026
 20:58:33 -0800 (PST)
Date: Thu, 12 Nov 2026 20:58:33 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6af698f9.e4c0560b.3d4154.0002.GAE@google.com>
Subject: [moderation/CI] Re: KEYS: Replace assoc_array with rhashtable
From: syzbot ci <syzbot+cia9761817c4f42e6b@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v8] KEYS: Replace assoc_array with rhashtable
https://lore.kernel.org/all/20261110044043.2608600-1-jarkko@kernel.org
* [PATCH v8 1/3] KEYS: Introduce keyring_is_empty()
* [PATCH v8 2/3] KEYS: Replace assoc_array with rhashtable
* [PATCH v8 3/3] lib: Remove assoc_array

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/e8662095-cae7-4b37-9a5b-182619bd9a6a

***

kernel build error

tree:      torvalds
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvald=
s/linux
base:      7e1392a42ea288d70a266f6553fe06f57f8647ea
arch:      amd64
compiler:  Debian clang version 22.1.8 (1~deb13u4), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/75f641d3-d64a-4016-a6db-a89bcebbee3=
9/config

security/keys/keyring.c:1211:3: error: cannot jump from this goto statement=
 to its label
security/keys/keyring.c:1205:3: error: cannot jump from this goto statement=
 to its label
security/keys/keyring.c:1197:3: error: cannot jump from this goto statement=
 to its label

***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[agk@redhat.com akpm@linux-foundation.org alexs@kernel.org andrii@kernel.or=
g ast@kernel.org bmarzins@redhat.com bpf@vger.kernel.org corbet@lwn.net dan=
iel@iogearbox.net dhowells@redhat.com dm-devel@lists.linux.dev dzm91@hust.e=
du.cn ebiggers@kernel.org eddyz87@gmail.com emil@etsalapatis.com fsverity@l=
ists.linux.dev ignat@linux.win ihor.solodrai@linux.dev jarkko@kernel.org jm=
orris@namei.org jolsa@kernel.org keyrings@vger.kernel.org linux-doc@vger.ke=
rnel.org linux-kernel@vger.kernel.org linux-kselftest@vger.kernel.org linux=
-security-module@vger.kernel.org martin.lau@linux.dev memxor@gmail.com mpat=
ocka@redhat.com paul@paul-moore.com rdunlap@infradead.org serge@hallyn.com =
si.yanteng@linux.dev skhan@linuxfoundation.org snitzer@kernel.org song@kern=
el.org torvalds@linux-foundation.org tytso@mit.edu yonghong.song@linux.dev]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

