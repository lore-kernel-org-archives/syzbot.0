Received: from mail-ot1-f71.google.com (mail-ot1-f71.google.com [209.85.210.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 447D0379975
	for <syzbot@lists.linux.dev>; Tue, 17 Mar 2026 04:48:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773722892; cv=none; b=XTtDG5leX9Lj2/Il4J8XuY9+q2fL4P94U0ya23ZJTLqfCLkDzrWI/lBWIAt/B6xPpE5Yi2csqEH7ML0U3Nz+nyYrTuKe8TGsMLcPWykIMTDSQYT96jZNQioN5h00v5lqLwbsmf+jk3dmz4baF2AoHwprvhaeothLrj/HNf6WX7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773722892; c=relaxed/simple;
	bh=vjXpq51466/MwfsRlII1enerQ7fzE+I5m0PhAY9UK9I=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=rI+Rn2vEcsd58LWFlE3Sy5AhSel6EKzhMHvfhyqnVf6PX1BVt5r7fYUGA16L6wsisC4yitQSjmPHhFDYmgEq/ZQGzGtRDUW7opsKEZHc/vwHg+ki2EWqomrCvfftyjV+Y/zPuWhMdsd+62D6XaTw0tAq28aQ19e4/nCgrhC/Y7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.210.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f71.google.com with SMTP id 46e09a7af769-7d740d7e5a3so48166748a34.2
        for <syzbot@lists.linux.dev>; Mon, 16 Mar 2026 21:48:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773722888; x=1774327688;
        h=content-transfer-encoding:cc:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GoPEEx393sXx6VlljxwvF2f5//xu/ysF9eQEPRJfxac=;
        b=g//YjgNenTqy+NJF1/mFVssk+OqpLTP8d/+xFPS19GtGZmQMEjHvLxl0JEiSoQAXPq
         PWLH+xLzLCNl47pj7gPXfTeODQ8QyRdmxp+DJiaTYNrl4yyFuSekFS9XSomRj+p+3bcu
         6hqoeq9q9tasY92lwSYPbb7gnerbI+RyMXAmDz7R/sjOslaz1YTZT/nE7+EKJTOwEbxM
         kjptY/ZaPGbfC1Bj6G6SeWCB/yf7qW3qrpFq2Zkh7TIq8gHlDzwRZmVgtGncs9MEmnuu
         F0oN/A6NYCmWX4HNB8R+LM8S4t25psyDlIbIWqzPor06b/dSkMtVXKMjQxvg8NhiV232
         mx6g==
X-Gm-Message-State: AOJu0YzDH/sIivRToIPmMMVlMC84CghXufG+m2WlWCZ+XzEhAN1i9B3T
	qGHYvG6JGopUOfHjPUIRHQU+KZG4jro/hMD4PGgl1tIfHfhiBpet4O8ZAIPngvq33H1uPCevuCy
	30SWE181qqCbAKR0EEY9Wz48GXG4Jh8YP4kwX3iJQ1/AWEU/ICSziEkWi9Tc=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:c86:b0:67b:b8e5:e456 with SMTP id
 006d021491bc7-67bdaa9ccb2mr11540303eaf.70.1773722888017; Mon, 16 Mar 2026
 21:48:08 -0700 (PDT)
Date: Mon, 16 Mar 2026 21:48:08 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69b8dd08.050a0220.12d28.016a.GAE@google.com>
Subject: [moderation/CI] Re: net: devmem: support devmem with netkit devices
From: syzbot ci <syzbot+ci951a3f613d1ab765@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v1] net: devmem: support devmem with netkit devices
https://lore.kernel.org/all/20260316-scratch-bobbyeshleman-tcp-dm-netkit5-v=
1-0-b53c8cd72b23@meta.com
* [PATCH net-next 1/6] net: devmem: support TX through netkit leased queues
* [PATCH net-next 2/6] selftests: drv-net: extract _find_bss_map_id helper =
in NetDrvContEnv
* [PATCH net-next 3/6] selftests: drv-net: add skip-config flag to ncdevmem
* [PATCH net-next 4/6] selftests: drv-net: add primary RX redirect support =
to NetDrvContEnv
* [PATCH net-next 5/6] selftests: drv-net: add netkit devmem RX test
* [PATCH net-next 6/6] selftests: drv-net: add netkit devmem TX test

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/e4c5419d-2378-4270-8913-bc133f1504a9

***

kernel build error

tree:      net-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netdev/=
net-next.git
base:      5446b8691eb8278f10deca92048fad84ffd1e4d5
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp=
1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/fe1afa06-5895-437c-b959-86c0087a6d5=
b/config

net/core/netdev-genl.c:1095:58: error: no member named 'lease' in 'struct n=
etdev_rx_queue'

***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[almasrymina@google.com andrew@lunn.ch bobbyeshleman@gmail.com bobbyeshlema=
n@meta.com bpf@vger.kernel.org davem@davemloft.net dw@davidwei.uk edumazet@=
google.com horms@kernel.org kuba@kernel.org linux-kernel@vger.kernel.org li=
nux-kselftest@vger.kernel.org netdev@vger.kernel.org pabeni@redhat.com sdf@=
fomichev.me shuah@kernel.org weibunny@fb.com]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

