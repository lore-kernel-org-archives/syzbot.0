Received: from mail-oo1-f69.google.com (mail-oo1-f69.google.com [209.85.161.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B8E2394471
	for <syzbot@lists.linux.dev>; Sat,  1 Aug 2026 09:47:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785577657; cv=none; b=AIRYa0iU4DhEzcQVBXrRJel49l50D9o1m1nLM4A4RQqGziOfzvZLwinqGM0OyhHbRMTJX46EMWIqaBbRbEUNiPHakC5r+lj24SDJCzU+/zp8c1JfeCrXskVbeWv83VeAdBardY7r7m79SfcUTGbnUlXpbl5Wb2hvVRnf3tSVjvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785577657; c=relaxed/simple;
	bh=vRNee5mbDHkejPRg5hKT9IdjO9y4pvcm+sAmrKVn0qo=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=I3v/sv81MAuCEd2nl4dIgNAe4ypDePDlTOEYZ7M/cTvY+7Z6xlHgYd+Fu+N0xXGjEKtOUuI5fWGVSG3nhG9YDJz7p9g5KLQ0gssM8o9F74SdJhA+qLapLBPSTRLiP+heDHApv07mnM+eC71/aIaEjNng6eYkX50TgeJgxSDEn0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f69.google.com with SMTP id 006d021491bc7-6a313ec13ceso865826eaf.2
        for <syzbot@lists.linux.dev>; Sat, 01 Aug 2026 02:47:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785577654; x=1786182454;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:date:mime-version:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=mfqjDPR1qqRNcsUKc3LWFgThd1ZWmwKUYU3WowwgDzo=;
        b=bBRBgZOl5n9dK/DkPguX8om8iB4V8ArgwbqOo36zTeWErj4Hwj80Q+blf259CbgEOV
         k2B7YiMDWIChs2gSmuMKJTPRHnrepZS72JMAK+r1FAbyPX1NzxbhfKEOxxsv5M7obAUl
         XjIGFjw2QrOAIRjRGYnZAXYagDnokTqDbkckgiI87QQ2DeMX1D90jTDVasaBvT/Ri52S
         2TpdLvu8waAAHfSlBAiXZ/Aibb0GR/w8ahUEoslwhOm1FioWjAofhClFD92XpUoDwf5y
         BWnXfxLHBhosIJkzWWMZdll3aiB8XvwWNzaCxHPNUqNtiXdL9y1GORV+uWsqLP7PzTr8
         grCA==
X-Gm-Message-State: AOJu0YwQW357E3mQ/mMVPNFgGhsG1Lp6cs89wlQFrOvRjzup8IzxH3hq
	MIuhJP3QV8Uoq23wPZ1ggUp9h2LTvaCFEQoQWAtKLJ7KhtgFAYnijBcoq/gj5Pm7Sy9QVXU51p7
	lUSRhIvz3qkbAH1nhKDRMYOkfFH7pgVDuu+W3x5gB8YddochEobvFqOngOBg=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:4109:b0:6a3:5be4:a803 with SMTP id
 006d021491bc7-6ae4334a8abmr4451584eaf.28.1785577654114; Sat, 01 Aug 2026
 02:47:34 -0700 (PDT)
Date: Sat, 01 Aug 2026 02:47:34 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a6dc0b6.1aa927e4.17d4bf.000d.GAE@google.com>
Subject: [moderation/CI] Re: Drivers: hv: decrypt netvsc buffers on contiguous
 direct-map addresses
From: syzbot ci <syzbot+cifb2f229051386c6f@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v2] Drivers: hv: decrypt netvsc buffers on contiguous direct-map addresses
https://lore.kernel.org/all/20260730233359.3850612-1-kameroncarr@linux.micr=
osoft.com
* [PATCH v2 1/2] Drivers: hv: vmbus: add vmbus_establish_gpadl_caller_decry=
pted()
* [PATCH v2 2/2] hv_netvsc: Allocate host-visible GPADL buffers as decrypte=
d contiguous chunks

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/906224ad-265a-4866-9b19-2c5cdd4676a5

***

kernel build error

tree:      net-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netdev/=
net-next.git
base:      c4c0673e4cb15b0c127e6d00732a2427bdd12c11
arch:      amd64
compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp=
1~20260613092250.77), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/7b0a9d79-afae-469b-ad42-3ec27d11487=
8/config

drivers/hv/channel.c:718:11: error: call to '__compiletime_assert_982' decl=
ared with 'error' attribute: min(order, ( __builtin_constant_p(remaining) ?=
 ((remaining) < 2 ? 0 : 63 - __builtin_clzll(remaining)) : (sizeof(remainin=
g) <=3D 4) ? __ilog2_u32(remaining) : __ilog2_u64(remaining) )) signedness =
error

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
[andrew@lunn.ch davem@davemloft.net decui@microsoft.com edumazet@google.com=
 haiyangz@microsoft.com kameroncarr@linux.microsoft.com kuba@kernel.org kys=
@microsoft.com linux-hyperv@vger.kernel.org linux-kernel@vger.kernel.org lo=
ngli@microsoft.com mhklinux@outlook.com netdev@vger.kernel.org pabeni@redha=
t.com wei.liu@kernel.org]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

