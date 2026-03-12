Received: from mail-oi1-f179.google.com (mail-oi1-f179.google.com [209.85.167.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D6D83537EA
	for <syzbot@lists.linux.dev>; Thu, 12 Mar 2026 14:22:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.179
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773325360; cv=pass; b=ATIb8JIxuFvJlrd4LaXdkMfxnU4Ob5jopADc5Nla9zop3t6qKV/zQj3eQAG7ts2mzRmd+n6Br7e0aASTPrrdhYmvMMwc3zms/nQ9s6qWKpLmCIQvfNnTlKEjEY0tSfK3VuR8F0M2QeEN+nI5FqMCMJgovLln8a+yPs4/lRlb5EM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773325360; c=relaxed/simple;
	bh=Mfa/zF3hpJSdyohBEuc/XJZNaC3P7wgsjcQloAhHYw4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=G60/+9S3HvensS6moAtKYp1BXLA1lP9yIsBU4hu3LDyrAZLq1ljQAAzOi47q86MiKCQN0bNVrZrGVDKgwn/mamXGya2XQOReMpwYJyzWzl8emcWk9KBspzN4J3ouIGui5ZBdVMRKDrgdxELBrMGECUqdBWZIpXLfExTNUsi/fXU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=U/1lW0qv; arc=pass smtp.client-ip=209.85.167.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="U/1lW0qv"
Received: by mail-oi1-f179.google.com with SMTP id 5614622812f47-4671cbce2feso482642b6e.3
        for <syzbot@lists.linux.dev>; Thu, 12 Mar 2026 07:22:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773325358; cv=none;
        d=google.com; s=arc-20240605;
        b=H9cYFWI0FcCyp2eJFroe79rCv9xX7uf9rT7G3AFXA+NciHzRa7zi9l/PHS3JdsZCs8
         FU5R2D6lnkisRc+kVAFwkWJp2pFyS8bnNw8weWrY/KCCX57/NdRLNo+uEEXT+zPU01l5
         Wlm+Y+AJ5ol4fHadFdJRA/BjhnulAk5QhXlZqtK2enourFvvAG7Ln6Nm53x41+32E6v3
         p9Ni/7drMq8vt231LeaqGm6RwhJTBmvtbhgF+MJOuLxp4jBnNnRgiE51MPTtEMgTeS7y
         oq152AXw3tIO3rStJ2gXPm2bcle4xwflcJV7huTsWIylw5UJx7blRqeNqMOQBjdz8KpJ
         S1MQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Qi51PO609X1VJwSgrvW/JUNvzxE+YTj3k95/+5FaAEc=;
        fh=LVLVuha+oyWnQYo5f3tIv+5q4jRhYHjUnVCw2Ew8ocw=;
        b=aH2URkgBb5AT6sDJCwgEvJYds7MoeBpdmwmLb7DGvufu2hm9mFLJk0aX3Ume9nrU+4
         1s94VXG1iE8Wzsd+3YHDudtj07O2WfjIURJuiMmrdZaqcU40FQD5E3EAS50/LHS/jcQi
         PGPDbj/kFXdFOVeqwBSirzYfKwFQM7Rkx6SFlf2nsoHx100iT6ShsIjptnf72iB1r6xK
         f1tbUawJAW7yAYUlhkWOYOJHtW4YIqkbqf3z57yHC5lhwuCqtZi8Q0QBGLf/Ca5Vvbqf
         Sbe2xwUs+8ikacwbZyhO/ScIpeh1kcGaQqVZElisGdkZ8h8til8JnxW77F8yDAuQre4p
         ViIA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1773325358; x=1773930158; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Qi51PO609X1VJwSgrvW/JUNvzxE+YTj3k95/+5FaAEc=;
        b=U/1lW0qvt94dmFL3WD3gbSkL6vuKdgOdS3tTwtTcO1oSnZPfy+EivL7GuusP0+9Oa1
         0DSTb80TXK4TX9TzFu+GF6Amn1EttK5UQ56Mp7/AtaLs3ZNrlZebuPx1X64D7Jr+vmJF
         ZGrZHu1xySOPBdNRBebc7kwP+DhL92OYUYn4OzShzCaE0Vyi1AC8v4b41V2idBcgOoul
         tx+yumeH1+c+zupdOEImJNE1FdbwRrJi2ZHuuQpl1gVbnRL6bjKgDEm00tw0xzx9MjMC
         REVOYBUdRZ6T16+AqSbYyC6bmsie/NAs60eFefcamde3IiyCm8cHwgusp6pDvtr0DGE7
         u49g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773325358; x=1773930158;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Qi51PO609X1VJwSgrvW/JUNvzxE+YTj3k95/+5FaAEc=;
        b=YNQ3ap7cNEenWTwY5gdRn3Ii8BiWkCxsgd7XGv46I4EuvrOSyMeXOjsjq6Cm90B5r8
         y9ka2blHY8ymm4aooq16BaIt/W64hXssKGVXOZRVZ5LZdpP8QPoUC010eMOwM5akEqsz
         uOX1TgzHvl9Bwh/0eQ0q11LQDBQZFy9iUnWZu0tI/X2c+xX2AWTiadTPGcOjbtgIuKsS
         078M7nBsROYJQ+k34CjXWCYjPM+/HZGMa3d7LcJr5fdnkXsyzBpyBYnfYI1W5wKONVsN
         fGSMeVWxr4XPjx1/s8ZdewORqyoyy3t6Kw7c/zWip69gpzxgNf20OwH2NOnEzOJJ9UDD
         tQiw==
X-Forwarded-Encrypted: i=1; AJvYcCXXQ3Dwr5VNrtVZ2pKrG2t/uNF5KW1imC+7LJndeoauAel06wosW7AXMyWiFIv4z+PupZ5RDVg=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw7wUzez/pPdf3s5cSinN+0P2xQCryKr4C/EpMjBXYqgiHMMdM8
	zvLeXkl0YOpMtT02A8Dqx0HgLHWAotEDZax/ZuhqR4dT9KntBQ6ZFOfE3Vm2jFdbrN3GUV+DMJ/
	F18pjJmlr5bGtpILSuPUmnAcczJD0lfdjmUz8n3ic3y9sF3rRojA069PD
X-Gm-Gg: ATEYQzxnfiEPeHbSliKvoVEnao4gR78dwnP6dGw6w6PbnTLsYCwU4Hn8niewrm0pcWQ
	/mybyPVwkh5wJYpEvHUWhLJKKFCSERgjBkHcNdW+0Ho8o274gw5X7ahRWPjdI5oW7OUzAstGo9R
	nJv4Voc/nistNsE8CyoIU/6oU0/rIM0iiz3bUnjxCxAngScEpmHp3SjjYsC2Ndzd5u7PP1GV/cx
	dX2JErh1z+xTXRJhn89arU1rP4CzIQDj8mVHZkPykeqIBMZGEgCWzHaOi1yf3l87HW289j6eGcw
	0amTfODHgBBhmxnTFtjFsYHhFnjxLXa7+Ddq3pz9LGUL2lOKmhf0KW7Jbgvis0XmroukyQ==
X-Received: by 2002:a05:6808:4fcb:b0:467:3f4:9077 with SMTP id
 5614622812f47-467335a7f18mr3567328b6e.51.1773325357717; Thu, 12 Mar 2026
 07:22:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <69b2cb18.a00a0220.707e5.0015.GAE@google.com>
In-Reply-To: <69b2cb18.a00a0220.707e5.0015.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Thu, 12 Mar 2026 14:22:26 +0000
X-Gm-Features: AaiRm52_ngflcY7s-DeGqn14uWWvUUQIKEpZiCMpj995wcP5lt4vs-ZzaXlMJyQ
Message-ID: <CANp29Y557s_T2wb-TAJ+ePa3ZnpYsZB6usXMqd4c-ngEBdVoAQ@mail.gmail.com>
Subject: Re: [moderation/CI] Re: iwlwifi + mac80211 stability
To: syzbot ci <syzbot+cia673a663f1f428f2@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Thu, Mar 12, 2026 at 3:18=E2=80=AFPM syzbot ci
<syzbot+cia673a663f1f428f2@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v1] iwlwifi + mac80211 stability
> https://lore.kernel.org/all/20260311230730.163348-1-greearb@candelatech.c=
om
> * [PATCH wireless-next 01/28] wifi: iwlwifi: mld:  Check for NULL before =
lookup.
> * [PATCH wireless-next 02/28] wifi: iwlwifi: mld: Fix un-set return value=
 in error case.
> * [PATCH wireless-next 03/28] wifi: iwlwifi: mld: Add check for null vif =
in stats callback.
> * [PATCH wireless-next 04/28] wifi: mac80211:  Check debugfs creation ret=
urn values.
> * [PATCH wireless-next 05/28] wifi: mac80211: do not fail taking sta to l=
ower state.
> * [PATCH wireless-next 06/28] wifi: mac80211: Mark sta as uploaded if sin=
gle transition succeeds.
> * [PATCH wireless-next 07/28] wifi: mac80211:  Fix use-after-free of debu=
gfs inodes.
> * [PATCH wireless-next 08/28] wifi: mac80211: Debugfs safety checks.
> * [PATCH wireless-next 09/28] wifi: mac80211: Use warn-on-once in drv_rem=
ove_chanctxt
> * [PATCH wireless-next 10/28] wifi: mac80211: Ensure sta debugfs is not d=
ouble-freed.
> * [PATCH wireless-next 11/28] wifi: iwlwifi: mld: Fix stale reference in =
fw_id_to_link_sta
> * [PATCH wireless-next 12/28] wifi: iwlwifi: mld:  Improve logging in err=
or cases.
> * [PATCH wireless-next 13/28] wifi: iwlwifi: mld: Remove warning about BA=
ID.
> * [PATCH wireless-next 14/28] wifi: mac80211: Add dmesg log regarding war=
n-on in drv-stop.
> * [PATCH wireless-next 15/28] wifi: iwlwifi: mld: Fix use-after-free of b=
ss_conf
> * [PATCH wireless-next 16/28] wifi: iwlwifi: mld: Check for null in iwl_m=
ld_wait_sta_txqs_empty
> * [PATCH wireless-next 17/28] wifi: iwlwifi: mld: use warn-on-once in err=
or path.
> * [PATCH wireless-next 18/28] wifi: iwlwifi: mld: Use warn-on-once in eml=
sr exit logic.
> * [PATCH wireless-next 19/28] wifi: iwlwifi: mld: Improve error message i=
n rx path.
> * [PATCH wireless-next 20/28] wifi: iwlwifi: mld: Improve logging message=
.
> * [PATCH wireless-next 21/28] wifi: iwlwifi: mld: Protect from null mld_s=
ta
> * [PATCH wireless-next 22/28] wifi: mac80211: Add force-cleanup call to d=
river.
> * [PATCH wireless-next 23/28] wifi: iwlwifi: mld: Support force-cleanup o=
p
> * [PATCH wireless-next 24/28] wifi: iwlwifi: mld: Fix NPE in flush logic.
> * [PATCH wireless-next 25/28] wifi: iwlwifi: mld: Fix bad return address =
in tx code.
> * [PATCH wireless-next 26/28] wifi: mac80211: Ensure link work-items are =
only initialized once.
> * [PATCH wireless-next 27/28] wifi: iwlwifi: mld: Convert to WARN_ONCE in=
 link removal path.
> * [PATCH wireless-next 28/28] wifi: mac80211: Decrease WARN spam.
>
> and found the following issue:
> WARNING in drv_add_interface
>
> Full report is available here:
> https://ci.syzbot.org/series/d3986751-1907-410b-b80c-976f38583b8c
>
> ***
>
> WARNING in drv_add_interface
>
> tree:      linux-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/next/=
linux-next
> base:      97492c019da4b62df83255e968b23b81c0315530
> arch:      amd64
> compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~e=
xp1~20251221153213.50), Debian LLD 21.1.8
> config:    https://ci.syzbot.org/builds/acf234a5-5041-402a-ace9-5766b71ca=
db4/config
> C repro:   https://ci.syzbot.org/findings/1533841d-c00d-4811-84c1-419f7bc=
cc86a/c_repro
> syz repro: https://ci.syzbot.org/findings/1533841d-c00d-4811-84c1-419f7bc=
cc86a/syz_repro
>
> ------------[ cut here ]------------
> !sdata->vif.debugfs_dir
> WARNING: net/mac80211/driver-ops.h:510 at drv_vif_add_debugfs net/mac8021=
1/driver-ops.h:510 [inline], CPU#1: dhcpcd/5553
> WARNING: net/mac80211/driver-ops.h:510 at drv_add_interface+0x5e5/0x910 n=
et/mac80211/driver-ops.c:84, CPU#1: dhcpcd/5553
> Modules linked in:
> CPU: 1 UID: 0 PID: 5553 Comm: dhcpcd Not tainted syzkaller #0 PREEMPT(ful=
l)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:drv_vif_add_debugfs net/mac80211/driver-ops.h:510 [inline]
> RIP: 0010:drv_add_interface+0x5e5/0x910 net/mac80211/driver-ops.c:84
> Code: f3 fa ff ff e8 9c 22 ae f6 48 8d 3d 85 f2 0a 05 67 48 0f b9 3a e9 c=
1 fc ff ff e8 86 22 ae f6 e9 19 fb ff ff e8 7c 22 ae f6 90 <0f> 0b 90 eb 94=
 e8 71 22 ae f6 4c 8d 35 7a f2 0a 05 49 8d bf 28 0a
> RSP: 0018:ffffc90003b57678 EFLAGS: 00010293
> RAX: ffffffff8b1776f4 RBX: ffff888172594dc0 RCX: ffff8881165657c0
> RDX: 0000000000000000 RSI: 0000000000000002 RDI: 0000000000000006
> RBP: 0000000000000000 R08: ffffffff901146b7 R09: 1ffffffff20228d6
> R10: dffffc0000000000 R11: fffffbfff20228d7 R12: dffffc0000000000
> R13: ffff888172597028 R14: ffff8881725957f8 R15: 0000000000000002
> FS:  00007ff45a6f6740(0000) GS:ffff8882a9465000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 000055d00b0c3161 CR3: 000000010017c000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  ieee80211_do_open+0x929/0x2490 net/mac80211/iface.c:1466
>  ieee80211_open+0x15b/0x200 net/mac80211/iface.c:472
>  __dev_open+0x44d/0x830 net/core/dev.c:1702
>  __dev_change_flags+0x1f7/0x690 net/core/dev.c:9778
>  netif_change_flags+0x88/0x1a0 net/core/dev.c:9841
>  dev_change_flags+0x130/0x260 net/core/dev_api.c:68
>  devinet_ioctl+0x9f2/0x1b30 net/ipv4/devinet.c:1199
>  inet_ioctl+0x42a/0x560 net/ipv4/af_inet.c:1004
>  sock_do_ioctl+0x101/0x320 net/socket.c:1253
>  sock_ioctl+0x5c6/0x7f0 net/socket.c:1374
>  vfs_ioctl fs/ioctl.c:51 [inline]
>  __do_sys_ioctl fs/ioctl.c:597 [inline]
>  __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7ff45a7c4d49
> Code: 5c c3 48 8d 44 24 08 48 89 54 24 e0 48 89 44 24 c0 48 8d 44 24 d0 4=
8 89 44 24 c8 b8 10 00 00 00 c7 44 24 b8 10 00 00 00 0f 05 <41> 89 c0 3d 00=
 f0 ff ff 76 10 48 8b 15 ae 60 0d 00 f7 d8 41 83 c8
> RSP: 002b:00007ffff8603cd8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
> RAX: ffffffffffffffda RBX: 00007ff45a6f66c0 RCX: 00007ff45a7c4d49
> RDX: 00007ffff8613ec8 RSI: 0000000000008914 RDI: 0000000000000011
> RBP: 00007ffff8624088 R08: 00007ffff8613e88 R09: 00007ffff8613e38
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007ffff8613ec8 R14: 0000000000000028 R15: 0000000000008914
>  </TASK>
>
>
> ***
>
> If these findings have caused you to resend the series or submit a
> separate fix, please add the following tag to your commit message:
>   Tested-by: syzbot@syzkaller.appspotmail.com
>
> ---
> This report is generated by a bot. It may contain errors.
> syzbot ci engineers can be reached at syzkaller@googlegroups.com.
>
> The email will later be sent to:
> [greearb@candelatech.com linux-wireless@vger.kernel.org]
>
> If the report looks fine to you, reply with:
> #syz upstream
>
> If the report is a false positive, reply with
> #syz invalid
>
> --
> You received this message because you are subscribed to the Google Groups=
 "syzkaller-upstream-moderation" group.
> To unsubscribe from this group and stop receiving emails from it, send an=
 email to syzkaller-upstream-moderation+unsubscribe@googlegroups.com.
> To view this discussion visit https://groups.google.com/d/msgid/syzkaller=
-upstream-moderation/69b2cb18.a00a0220.707e5.0015.GAE%40google.com.
