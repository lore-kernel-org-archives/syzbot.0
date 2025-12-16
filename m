Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com [209.85.167.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58D543AA191
	for <syzbot@lists.linux.dev>; Tue, 16 Dec 2025 13:47:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765892873; cv=none; b=HCSqTJO/sa2lnbaOpwtIh7G/BkYVUioUpntT6oAMekBreaUub5smu9hSLK9xUWqtKe3gYBARlyMKBiq2C1nDzgE08pfxDKkH1327KfD8TSvn8mwwko3esuzNn9UrgDWzIDnjDRQXe/+fJWv9aulTjhytpXP2SZt7xW1R/xE+O9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765892873; c=relaxed/simple;
	bh=ngWfemLDWR9bCDDDve/XaCr8M6QIjvP4P6QMO3ule4Y=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=byOXWxtw1QuxEhqEMtXf+4/+YvhSDMBF1MFhQv8ME8Op1yHv77jRF8txP2I0npFDK+VTQ5w3OSpgbK7wsVs8EUu5aE+Xl7VO5GYMnVthmR/R8UVzHNr0OguNGhFUduTIvKtQGgbt3fz+xhQF2a6qaRaRSwICrwODKZN2nZleOrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f198.google.com with SMTP id 5614622812f47-4511a6fde00so6800742b6e.0
        for <syzbot@lists.linux.dev>; Tue, 16 Dec 2025 05:47:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765892870; x=1766497670;
        h=content-transfer-encoding:cc:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Wy919vfWNhGK7S09krPhbr1m/HOkKV6q+3W4TPl7VTY=;
        b=ODn8E69/iMUifnXGsbHkY2Y2ky+i9JWkKEJqM2dW6KhvlGHs87TSIfqa+EQ3xYAsjw
         nzUqbn1uo4hpRiLJB1LEVaQdMZf7v0FxLHMiE70v2QppxtNTYcHzBbKuuoDWzjX3Yk4o
         OHQSM78AqJlm3PoPz0OBHmMvLW7Vdu221kfIKc+7FV3byNQwZgNfT/GRxiCpD1buJBV5
         g9TobtHHw73LMLiXsnaA33jQ04pUxq4PvovZ43uOizfJH5M4TDABx3cARi2HmEzMThSr
         mOyqr5aR6Zr/znYCgAx/5zRBz4Pa/m25hadYVxVYup/KoyGKL3JDik2Ug4GST5NiCXHR
         n+Ew==
X-Gm-Message-State: AOJu0YzHIWVUOuaN3wbg9koQkSdvRP1wCZE8dL/NkmomHIQ5tLkNyQJE
	NfUBKSEz5fcH2kGPMyx8icx7tcWU2nIIlyJ4g0jkcreaPMWZ8xyIEqLmSuner1T2RD5UjG6A9Vs
	ygt2pXQGV/O6sitGl1m4j2ArCMwfPxHzOxO20EoS5f2m8j1LpnCoNkKJ/tbY=
X-Google-Smtp-Source: AGHT+IHWWNYQfS/mifacHXSAE9Ucug2SBFMYL4K5u4WgiVcy7bGx78rKawi5A9VLzhzcirUDN1KRIuPaCn0lWHYaBDHvNYQ/OyBH
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a4a:ee0f:0:b0:659:9a49:8e38 with SMTP id
 006d021491bc7-65b38027330mr8565183eaf.42.1765892870401; Tue, 16 Dec 2025
 05:47:50 -0800 (PST)
Date: Tue, 16 Dec 2025 05:47:50 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69416306.a70a0220.33cd7b.013f.GAE@google.com>
Subject: [moderation/CI] Re: Bluetooth: hci_sync: Initial LE Channel Sounding
 support by defining required HCI command/event structures.
From: syzbot ci <syzbot+cicc6ab7b4d8f508c1@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v1] Bluetooth: hci_sync: Initial LE Channel Sounding support by defining r=
equired HCI command/event structures.
https://lore.kernel.org/all/20251216113753.3969183-1-naga.akella@oss.qualco=
mm.com
* [PATCH v1] Bluetooth: hci_sync: Initial LE Channel Sounding support by de=
fining required HCI command/event structures.

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/a48bd25e-42b6-4a0c-bddb-26e955f3e39e

***

kernel build error

tree:      net-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netdev/=
net-next.git
base:      8f7aa3d3c7323f4ca2768a9e74ebbe359c4f8f88
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp=
1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/afe547a4-e1e3-444b-89cc-794f55470c1=
d/config

./include/net/bluetooth/hci.h:2430:8: error: redefinition of 'hci_cp_le_cs_=
set_proc_param'

***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[anubhavg@qti.qualcomm.com davem@davemloft.net edumazet@google.com hbandi@q=
ti.qualcomm.com horms@kernel.org johan.hedberg@gmail.com kuba@kernel.org li=
nux-bluetooth@vger.kernel.org linux-kernel@vger.kernel.org luiz.dentz@gmail=
.com marcel@holtmann.org mohamull@qti.qualcomm.com naga.akella@oss.qualcomm=
.com netdev@vger.kernel.org pabeni@redhat.com]

If the report looks fine to you, reply with:
#syz upstream

