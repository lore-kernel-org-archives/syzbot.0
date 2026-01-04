Received: from mail-oa1-f72.google.com (mail-oa1-f72.google.com [209.85.160.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34ABE225760
	for <syzbot@lists.linux.dev>; Sun,  4 Jan 2026 14:24:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767536660; cv=none; b=H4QbupP4INOXUTzRd2ipgyNQKkHKqx072TaxgdOeU9EmeeAfC2JB9YiRLD6rgCHLEyJTBUUgQAaqXK9jEqUkuH+j1pAxW8+qRUJPjfUFBXbaMt281+WkBctmuWRskJclHz3BFRgqltJ/7SAFUxu40PHwEGE12kX6Z212QnY6bwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767536660; c=relaxed/simple;
	bh=TzXYAjtiCSVgWopxQrMbrC2GywM7dit3auCp6HcOp8g=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=hC8ZFD2w/cxXPWoKb6UOjfaahnC6NiDxVCnQvF0uV6bMDtUfl2LsBHi2ZhNLCgyRrY+jp0NSHNjBu3tiKMeUUKpAqh8+tfQ8vUPsmhwy9woybKCuPVdrE+/obcNJN2wwtm9I489gAsMeVRqbbZvEtHNeM764cpbiBg1j2cLxe3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.160.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oa1-f72.google.com with SMTP id 586e51a60fabf-3f5af20add2so24518356fac.2
        for <syzbot@lists.linux.dev>; Sun, 04 Jan 2026 06:24:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767536657; x=1768141457;
        h=content-transfer-encoding:cc:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bk8ie5XPGmx+rHZb91xKr5f5hm6cQRpEMGtj1vshcC8=;
        b=aZHL8F23FklbsMSRbVP5FyhA3AiiVONA5HtJjmDLYHVOuSlA10pbe1t0m+MgzdHBkg
         JxGIZmZeE7v4SHqLp15xv6yQb7ua87MTbR3h9R16gNz406PLF937bb0ydeWHikGsRIaO
         +M/YM7g8D1EIem8GAvBrEhvxsjrR68XKquMzbZ2JL/PxPzjGi5wtZkUoeYSi0ZRB269o
         9Lu0mhfeFQ/UK5V1v9xKSfXUx484SfHdr31fg6aTt9P/vQ9zS4nmN+tZadQ9Duak8BgQ
         wn63nQPc6399rpzKKY1ScllSz2v3WfE2GbAyyNpSHFpEDZxGe9fy8KwxMXViJcpo10kj
         TZqQ==
X-Gm-Message-State: AOJu0YxZ4okBBhqaU2bjXCoe4WERX+s6ytluuVwospabQ7ftSPymqC/r
	M6F4qtoks0BLvIlsvLKUS7hI/6wm4sonmkjtdngVG+jFrc9SuTEdutEvvzGDHKLlmP+YOGmRJny
	gkp5TMRPlGmFZ7T5mGlP43itPAL4C4RaEn07f+QHloVlpBYxKVRhl/iyV0a0=
X-Google-Smtp-Source: AGHT+IH48QtZ5vmOU4n5rLwDfeKdS+CDm8uxPGiVrsHCPcOpLYoMsWsB29PLiqBbIdtJmH0iKXH+QiwoRidccfg6MuB5LM1/+WuU
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:162a:b0:659:9a49:9069 with SMTP id
 006d021491bc7-65d0ea9711amr19730783eaf.52.1767536657736; Sun, 04 Jan 2026
 06:24:17 -0800 (PST)
Date: Sun, 04 Jan 2026 06:24:17 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <695a7811.050a0220.a5285.0007.GAE@google.com>
Subject: [moderation/CI] Re: net: phy: realtek: various improvements for 2.5GE PHYs
From: syzbot ci <syzbot+ci37d09443e97ece12@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v1] net: phy: realtek: various improvements for 2.5GE PHYs
https://lore.kernel.org/all/cover.1767531485.git.daniel@makrotopia.org
* [PATCH net-next 1/4] net: phy: realtek: fix whitespace in struct phy_driv=
er initializers
* [PATCH net-next 2/4] net: phy: realtek: implement configuring in-band an
* [PATCH net-next 3/4] net: phy: realtek: use paged access for MDIO_MMD_VEN=
D2 in C22 mode
* [PATCH net-next 4/4] net: phy: realtek: get rid of magic number in rtlgen=
_read_status()

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/9009a077-7bd6-47b8-a711-0cb598911f48

***

kernel build error

tree:      net-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netdev/=
net-next.git
base:      dbf8fe85a16a33d6b6bd01f2bc606fc017771465
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251202083448+f68f64eb8130-1~exp=
1~20251202083504.46), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/0b028738-ab1f-4b33-ac87-91dafd61651=
c/config

drivers/net/phy/realtek/realtek_main.c:1262:16: error: use of undeclared id=
entifier 'mmdreg'; did you mean 'mmdrop'?
drivers/net/phy/realtek/realtek_main.c:1262:16: error: incompatible pointer=
 to integer conversion passing 'void (struct mm_struct *)' to parameter of =
type 'u32' (aka 'unsigned int') [-Wint-conversion]
drivers/net/phy/realtek/realtek_main.c:1271:19: error: use of undeclared id=
entifier 'mmdreg'; did you mean 'mmdrop'?
drivers/net/phy/realtek/realtek_main.c:1271:19: error: incompatible pointer=
 to integer conversion passing 'void (struct mm_struct *)' to parameter of =
type 'u16' (aka 'unsigned short') [-Wint-conversion]
drivers/net/phy/realtek/realtek_main.c:1310:17: error: use of undeclared id=
entifier 'mmdreg'; did you mean 'mmdrop'?
drivers/net/phy/realtek/realtek_main.c:1310:17: error: incompatible pointer=
 to integer conversion passing 'void (struct mm_struct *)' to parameter of =
type 'u32' (aka 'unsigned int') [-Wint-conversion]
drivers/net/phy/realtek/realtek_main.c:1319:19: error: use of undeclared id=
entifier 'mmdreg'; did you mean 'mmdrop'?
drivers/net/phy/realtek/realtek_main.c:1319:19: error: incompatible pointer=
 to integer conversion passing 'void (struct mm_struct *)' to parameter of =
type 'u16' (aka 'unsigned short') [-Wint-conversion]

***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[andrew@lunn.ch bevan.weiss@gmail.com daniel@makrotopia.org davem@davemloft=
.net edumazet@google.com hkallweit1@gmail.com kuba@kernel.org linux-kernel@=
vger.kernel.org linux@armlinux.org.uk michael@fossekall.de netdev@vger.kern=
el.org olek2@wp.pl pabeni@redhat.com vladimir.oltean@nxp.com]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

