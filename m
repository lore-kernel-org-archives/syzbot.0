Received: from mail-oo1-f69.google.com (mail-oo1-f69.google.com [209.85.161.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DD34274B40
	for <syzbot@lists.linux.dev>; Mon,  2 Feb 2026 19:50:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770061833; cv=none; b=FMSYmtlMgzeSdR5D2mS8Tj89xIs2WgUNINUqkuckrUxVhxts3DISzNjUlIKqo9Qm13P1a9Us8kScF09ShflOItlQNN777+isHG14XYC6vGA1HC0Tn45xUtg7BzvYMUmRkGLxEpmvtnNaktTmlA1cZff+TK7fPYcLPk5wYep7nck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770061833; c=relaxed/simple;
	bh=GfX8yBGqeWmz3tBIRn4TwYvuvCj4nlwz+ZnoqoF6QiM=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=PIas2366DnIyyLN028ufzQod7vC7/YHGkScZN1Ijm6iAqdWSXKj4UIWlpGVdks+RDW5c684vrinutzUMfsSWhjHvM20MWsx2mc5cuu4susUP6RanXMF5yb8Urz2nMh/ykOtPGhY3nado76Mdg4GFI99PvZ+g/am0viNgvd53SXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f69.google.com with SMTP id 006d021491bc7-662f738c3bfso18668567eaf.0
        for <syzbot@lists.linux.dev>; Mon, 02 Feb 2026 11:50:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770061828; x=1770666628;
        h=content-transfer-encoding:cc:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wu30YakWnY6j6/qFXe6YMLVJvnoh85p5uAefyF3O/xQ=;
        b=gynH72BqMCRD5du2id/XVXOnk+UjeW7Prl3Rrf9b3birLwRetqHQUFdEQF7YVcYXmK
         x9E19qVzZQdRtwJTdvfE8oLRaF9pRF9Qmmjdoo1a/DsV125y9fuCVizOqOrJ7u+gjxCT
         u+gWrqPJ11QDYTpyUmtek3FXTj5aD/AsXLUdNsyRDBrWA6bZx03xW0mZBSfqyVb+gA5I
         uF3+x6NjgIR9GGlr/Qoi8B9qMAbFkZRzw+d6AGs0Jo4xaCSnu9195OS3S+As5Qp9B1Kr
         HrDOAQ0+NHdBWUxuV61eRKBKYlzAbcyMvZjHuDZSu9lpP+xa2F1k0bTGaCQENXTQw0TX
         hQCw==
X-Gm-Message-State: AOJu0YxM1uolT1gU1N8l9omt1+kB5bAme9/i6EuiU2YnFu6S6R9T0sQS
	BqpTdZfwS6l4i7tzRusytQ4cOsZ/BOd2lazsIkbxvqyBGgTMiUW5IpkfcrFUpjOYvMmhaBNxrHV
	QNbm0rSyM8l1eT2T2Rw7JyDEbiIrViS8nsAN2tbeTQ0fdXjk6uTkLfM05e+Y=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:1a08:b0:661:ae2:95fb with SMTP id
 006d021491bc7-6630f3b82abmr5382180eaf.75.1770061828117; Mon, 02 Feb 2026
 11:50:28 -0800 (PST)
Date: Mon, 02 Feb 2026 11:50:28 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69810004.050a0220.1d0a41.002c.GAE@google.com>
Subject: [moderation/CI] Re: dpll: Core improvements and ice E825-C SyncE support
From: syzbot ci <syzbot+ci68b7621f6fabdcd1@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v4] dpll: Core improvements and ice E825-C SyncE support
https://lore.kernel.org/all/20260202171638.17427-1-ivecera@redhat.com
* [PATCH net-next v4 1/9] dpll: Allow associating dpll pin with a firmware =
node
* [PATCH net-next v4 2/9] dpll: zl3073x: Associate pin with fwnode handle
* [PATCH net-next v4 3/9] dpll: Add notifier chain for dpll events
* [PATCH net-next v4 4/9] dpll: Support dynamic pin index allocation
* [PATCH net-next v4 5/9] dpll: zl3073x: Add support for mux pin type
* [PATCH net-next v4 6/9] dpll: Enhance and consolidate reference counting =
logic
* [PATCH net-next v4 7/9] dpll: Add reference count tracking support
* [PATCH net-next v4 8/9] drivers: Add support for DPLL reference count tra=
cking
* [PATCH net-next v4 9/9] ice: dpll: Support E825-C SyncE and dynamic pin d=
iscovery

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/6e56fe77-3149-48fd-a446-971924fed7c5

***

kernel build error

tree:      net-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netdev/=
net-next.git
base:      a22f57757f7e88c890499265c383ecb32900b645
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp=
1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/067661f9-73a6-46e9-bc30-e091796a524=
d/config

./include/linux/dpll.h:235:1: error: expected identifier or '('

***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[aleksander.lobakin@intel.com aleksandr.loktionov@intel.com andrew@lunn.ch =
anthony.l.nguyen@intel.com arkadiusz.kubalewski@intel.com davem@davemloft.n=
et edumazet@google.com grzegorz.nitka@intel.com intel-wired-lan@lists.osuos=
l.org ivecera@redhat.com jiri@resnulli.us jonathan.lemon@gmail.com kuba@ker=
nel.org leon@kernel.org linux-kernel@vger.kernel.org linux-rdma@vger.kernel=
.org mbloch@nvidia.com netdev@vger.kernel.org pabeni@redhat.com poros@redha=
t.com prathosh.satish@microchip.com przemyslaw.kitszel@intel.com richardcoc=
hran@gmail.com saeedm@nvidia.com tariqt@nvidia.com vadim.fedorenko@linux.de=
v]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

