Received: from mail-io1-f70.google.com (mail-io1-f70.google.com [209.85.166.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70DC32C21F6
	for <syzbot@lists.linux.dev>; Wed,  5 Nov 2025 09:11:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762333898; cv=none; b=TUQM+5hvrVLyCzH6pkBNfnH4hbraeJb++Bi4plUEOElRQNnC3K6eFDj1GzU3yh/iy9LxwIrlJle9oLQcTYLcwpEPdNzmqbqVZXkPnX52ALqMwX2Lc8FrA3gEC2DM9hx+zh5/2zTRRm+dVMg52LHVKzgmoZFmwxWt0HjcfuECPVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762333898; c=relaxed/simple;
	bh=UKkkQeDM3PBsMiDWBOlV32QnRzoN9SGY3FZLZM4evEQ=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=ZZh9WOhP3LAdVZOjI3xAiHufbIpgohP4mveq3wPVCTLFcVZ+kC5D1ZqGePCWmrR2t3g1rDEAX3A0jG6TRtBi8D68Yw/Otr7DwVbptj7S2DR4sIQLA7MnzB20sp3vZLNZKFcXfTWi2G32fYNicVdOjxabYSVV+h2IMWuySwUOEUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-93e8092427aso645054039f.0
        for <syzbot@lists.linux.dev>; Wed, 05 Nov 2025 01:11:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762333895; x=1762938695;
        h=content-transfer-encoding:cc:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qYALj00TijOy0iWVtXvO2sPwgBROp16HIMqBdrzVDeM=;
        b=Wu0mOfQ36FHXD3Ier9UtNX/KVP31K1JdPM9sctHU15bzT0jNb9dU+h2YWQDdpypvGd
         dkBhQMT5Q5wF0+MKjjQGvxxa0Az32MFaMs+4fGz/gpYzgw4ibbtJSKWwe4kUTUbV5WUK
         6sCnHXI9FVnOEUhR3Gv7KJpW/2e4gV5BaXHsbPzVBzF5YiLQxunrJtveOWtnD/xLXJh/
         v4Yjbd56+SDpwVOEt1DGexAkxhAd8rW0z16dGeG/PeZjetdgrOK5I1wpfKh9wlH4+ZGS
         j+niemFMF3PMkn4pJhTklJR3Mp7i/Mu0K6tq5HtcMUMsBVerJtZaunI2J7XoU3Qf1jtE
         E7Yg==
X-Gm-Message-State: AOJu0Yx6O4rueoPPYizobj+ZOUT2sHenjWvShxW9/NjinPOZYTbMx4VY
	dUMULdFnaJAzLBAqT/4usDEgZkl+ohZ00bqT6nWCQNe8hyekyn48CLKd+hIIMaac6Ou688S+4V6
	g3QPspCvxM3EI8Y6t+hQco2IUu9J1ja22tt9s1zuJk2+ScLEoPYEE3c9qyDk=
X-Google-Smtp-Source: AGHT+IHFcQ+EH9mEId9r4IR34veDSnSBBPiSSf2nWh8Z9DhdpWfwI7TCqUiocOJ3ABzKHX3OAWNsEVR4NUghBugc8X081Gt8/x/s
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6602:1548:b0:948:6673:e4ae with SMTP id
 ca18e2360f4ac-94869e3e6a0mr421360439f.13.1762333895660; Wed, 05 Nov 2025
 01:11:35 -0800 (PST)
Date: Wed, 05 Nov 2025 01:11:35 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <690b14c7.050a0220.3d0d33.0026.GAE@google.com>
Subject: [moderation/CI] Re: firmware_loader: make RUST_FW_LOADER_ABSTRACTIONS
 select FW_LOADER
From: syzbot ci <syzbot+cifdccccd385d723f6@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v2] firmware_loader: make RUST_FW_LOADER_ABSTRACTIONS select FW_LOADER
https://lore.kernel.org/all/20251105-b4-select-rust-fw-v2-0-156d9014ed3b@nv=
idia.com
* [PATCH v2 1/3] firmware_loader: make RUST_FW_LOADER_ABSTRACTIONS select F=
W_LOADER
* [PATCH v2 2/3] gpu: nova-core: select RUST_FW_LOADER_ABSTRACTIONS
* [PATCH v2 3/3] net: phy: select RUST_FW_LOADER_ABSTRACTIONS

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/76fd3c47-41d0-42f0-92eb-9c8532b99c68

***

kernel build error

tree:      net-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netdev/=
net-next.git
base:      01cc760632b875c4ad0d8fec0b0c01896b8a36d4
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp=
1~20250708183702.136)
config:    https://ci.syzbot.org/builds/4f4c4b4f-8c38-41c7-ac02-9054002b7df=
5/config

drivers/base/firmware_loader/Kconfig:41: syntax error
drivers/base/firmware_loader/Kconfig:41: invalid statement
drivers/base/firmware_loader/Kconfig:42: invalid statement

***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[a.hindborg@kernel.org acourbot@nvidia.com airlied@gmail.com alex.gaynor@gm=
ail.com aliceryhl@google.com andrew@lunn.ch bjorn3_gh@protonmail.com boqun.=
feng@gmail.com dakr@kernel.org davem@davemloft.net dri-devel@lists.freedesk=
top.org edumazet@google.com fujita.tomonori@gmail.com gary@garyguo.net greg=
kh@linuxfoundation.org hkallweit1@gmail.com kuba@kernel.org linux-kernel@vg=
er.kernel.org linux@armlinux.org.uk lossin@kernel.org mcgrof@kernel.org net=
dev@vger.kernel.org nouveau@lists.freedesktop.org ojeda@kernel.org pabeni@r=
edhat.com rafael@kernel.org russ.weight@linux.dev rust-for-linux@vger.kerne=
l.org simona@ffwll.ch tmgross@umich.edu]

If the report looks fine to you, reply with:
#syz upstream

