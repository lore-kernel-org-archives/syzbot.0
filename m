Received: from mail-oa1-f44.google.com (mail-oa1-f44.google.com [209.85.160.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 076CE1A23A0
	for <syzbot@lists.linux.dev>; Thu,  8 Jan 2026 07:34:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767857655; cv=none; b=ddffMmJk2Q/ZGy7Qt4ertm4GAtJUAg5XkScAsYRJVGG2Xoy5A4sArfW1NsLUq3AKml/ns+HHBLuTHqr/0hdzysnmZQdW9YeOkpn+LcYockscsDVfUY/algz2es65OzNAY4ttmsrW1dYeulP068H5KD4gpha+8L+YeWpQ9rS8nPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767857655; c=relaxed/simple;
	bh=k+W7DtOcWcI0IWb8vXcQVwZpULNwDViPgIolvs5tLXo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WYI/DLOvmgLNBYaQwklytUSxsHz+O61oGtffsQ0OsSjvxtgbWRONqO0RXxKkiR/jcYD0CeqvZiXIZMrbdEAH5F+H4XNzvGuOcaBSVQMIUPl/gze6XWhYnBZvfwcnsnoCJWOooKVWBwYynL9aaraLI334uXluKbGf4EfWvOk8BOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=nIzVO+eh; arc=none smtp.client-ip=209.85.160.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="nIzVO+eh"
Received: by mail-oa1-f44.google.com with SMTP id 586e51a60fabf-3ec3cdcda4eso2154577fac.1
        for <syzbot@lists.linux.dev>; Wed, 07 Jan 2026 23:34:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767857653; x=1768462453; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vnmKfkwkAjzus8j24+RtADOHUg5vtZzxo5Dw1KTLN3g=;
        b=nIzVO+ehjuFDN895mrjDXftTW+sF/BZrqPT0PWFJE+T89E3aRwQWe6CdfAw9LSE0Sv
         QpNTJGFhEBm99TP2n4h91FDCEfaLRqiFppNxrdTZXElrdoO3+uf/6HAuLcvgf2SyMwY+
         pFef4fSXlc9FPpWnfptcbE7T8TzAEKzNu05fTv/x20FT6+x8fbvs4I6+UA5exbe2kgxR
         6olY0FqVZriOJGrsuHUqSiZF60DikDy8zvO1b3FV+8+XynvoPfMHyWPHiRmcmsokMg+N
         NmGd5WTYUjCN3/waLXJNMTcibm0BuNgdtTSCAKddccer63utjea+AWVMJ5aaXPwg5/H5
         2fXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767857653; x=1768462453;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=vnmKfkwkAjzus8j24+RtADOHUg5vtZzxo5Dw1KTLN3g=;
        b=BX7WN0zeNDW+vScRai/OSMNZZlpFDOBusRHhNXfWFKOniKHatW97hm1zn4roq8DjFc
         imZTaSt3r6kY1605xT54HPShhxW60y9cZG0llaVRk/O8n0Nu7HVOw5Htdd7vCB8hfrld
         O1DErhYI5xFJM0VA9d3K53MqniRSwOJi3xDDhnPUwVkNFNRgI99aZu6rLPtD7BnB58t0
         m6wK1qTTJbOyUjpXA9IFnOpWgtJlW0SnWs+sDgBFOpwyo4kPRx9jmUT8ALnVly37Gt2u
         I0928MI1QKV56iWa6iiYW/MrJ9X2aneghpq5k3Pq92VkPyssEJBdMmUg0VQM904rn614
         WodA==
X-Forwarded-Encrypted: i=1; AJvYcCVVNjUOoEuL3v5/7i/q3aECdVTSwM3k3ZfKX3jYwf9ZBfiLHDT0d5aCVbZA5p59OA3hxblFq2I=@lists.linux.dev
X-Gm-Message-State: AOJu0Yyz7feTelo1vpcpqOGmUfdyZCRJ3t9XRmZeD/9Tv1xd0wAxPVSv
	N3hXViLokrkpFJiO4kZXzVdL1jfvkCksKEp/ePdgV+yDUWdsv6wzbOxNHm59KPuO6Hp7rqVYhFz
	1szK+4MXh+rZ3MIt29xeRRPaWzc9Ewoqz4234KYV3
X-Gm-Gg: AY/fxX4xy4zj83D/k6+vVyFhuU8oRmrD89YSsfU37iJT99VJv5uOPwGeJAtPGFRwTHY
	HKNuEv7zqPZeaUTn7IAK2QgrJIg2t1b2YJiHnANEmO87mDzWJy+YOE6cjTPSc09h9vEggz3M0tA
	tUgwCA/XgC+o1k0SSTweIipCIFdOrUwwJkqUWJ4g+Z8AO2N8ZLZu6O9xpmQ+b/es8xOmQtet8LJ
	1T2UBdny9HWVNsQTEFNRldcY/u4g3UKxF1zRG3oL30w9HrUj77aEwpj8QdPIQIS4E7b1WHkW53R
	zSNLs5DQJP7IAvztKz0QK1778PloKNQJ+Oyme1Z7lUNKa7ximozsmOZzkw==
X-Google-Smtp-Source: AGHT+IENpn6XBUi9dagQg8uF4ULdqMH7A/mJLZ9HmbguFDa/Ek5CnHw5Wb9fr8VFnWl6JuexHoaenVvERZst2Iev4Wc=
X-Received: by 2002:a05:6870:d88b:b0:3ec:a4ed:cf4a with SMTP id
 586e51a60fabf-3ffc0967bc1mr2108074fac.7.1767857652653; Wed, 07 Jan 2026
 23:34:12 -0800 (PST)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <695edb46.050a0220.1c677c.0382.GAE@google.com>
In-Reply-To: <695edb46.050a0220.1c677c.0382.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Thu, 8 Jan 2026 08:33:59 +0100
X-Gm-Features: AQt7F2pe6QxmZT2DRFBshYkDVWRQ2fxPEa426uF4AlFN1v3jh_i1N7QMeSoZFPI
Message-ID: <CANp29Y7TT_5C6JOpo-535h3baNXgfdgTpwXndeR35Os_ooWEfg@mail.gmail.com>
Subject: Re: [moderation/CI] Re: wifi: cfg80211/nl80211: Add NAN Data Path support
To: syzbot ci <syzbot+cid3aa03d338736052@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Wed, Jan 7, 2026 at 11:16=E2=80=AFPM syzbot ci
<syzbot+cid3aa03d338736052@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v1] wifi: cfg80211/nl80211: Add NAN Data Path support
> https://lore.kernel.org/all/20260107132003.2291979-1-miriam.rachel.korenb=
lit@intel.com
> * [PATCH wireless-next 01/15] wifi: nl80211: refactor nl80211_parse_chand=
ef
> * [PATCH wireless-next 02/15] wifi: nl80211/cfg80211: support stations of=
 non-netdev interfaces
> * [PATCH wireless-next 03/15] wifi: cfg80211: refactor wiphy_suspend
> * [PATCH wireless-next 04/15] wifi: nl80211: don't allow DFS channels for=
 NAN
> * [PATCH wireless-next 05/15] wifi: cfg80211: Add an API to configure loc=
al NAN schedule
> * [PATCH wireless-next 06/15] wifi: cfg80211: store the chandefs used for=
 NAN
> * [PATCH wireless-next 07/15] wifi: cfg80211: make sure NAN chandefs are =
valid
> * [PATCH wireless-next 08/15] wifi: cfg80211: add support for NAN data in=
terface
> * [PATCH wireless-next 09/15] wifi: cfg80211: separately store HT, VHT an=
d HE capabilities for NAN
> * [PATCH wireless-next 10/15] wifi: nl80211: add support for NAN stations
> * [PATCH wireless-next 11/15] wifi: nl80211: define an API for configurin=
g the NAN peer's schedule
> * [PATCH wireless-next 12/15] wifi: cfg80211: allow ToDS=3D0/FromDS=3D0 d=
ata frames on NAN data interfaces
> * [PATCH wireless-next 13/15] wifi: nl80211: allow reporting spurious NAN=
 Data frames
> * [PATCH wireless-next 14/15] wifi: cfg80211: support key installation on=
 non-netdev wdevs
> * [PATCH wireless-next 15/15] wifi: cfg80211: allow protected action fram=
e TX for NAN
>
> and found the following issue:
> possible deadlock in cfg80211_leave
>
> Full report is available here:
> https://ci.syzbot.org/series/233ae6b9-f1a6-42ee-a9ad-23778617ac45
>
> ***
>
> possible deadlock in cfg80211_leave
>
> tree:      torvalds
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torva=
lds/linux
> base:      805f9a061372164d43ddef771d7cd63e3ba6d845
> arch:      amd64
> compiler:  Debian clang version 21.1.8 (++20251202083448+f68f64eb8130-1~e=
xp1~20251202083504.46), Debian LLD 21.1.8
> config:    https://ci.syzbot.org/builds/ef828e0d-7b43-4e85-a3b3-c8a39bcbb=
3c9/config
> C repro:   https://ci.syzbot.org/findings/f7def9d9-24af-4952-b991-2e6c88f=
8fb50/c_repro
> syz repro: https://ci.syzbot.org/findings/f7def9d9-24af-4952-b991-2e6c88f=
8fb50/syz_repro
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> WARNING: possible recursive locking detected
> syzkaller #0 Not tainted
> --------------------------------------------
> kworker/1:3/1286 is trying to acquire lock:
> ffff888113640788 (&rdev->wiphy.mtx){+.+.}-{4:4}, at: class_wiphy_construc=
tor include/net/cfg80211.h:6552 [inline]
> ffff888113640788 (&rdev->wiphy.mtx){+.+.}-{4:4}, at: cfg80211_leave+0x17e=
/0x240 net/wireless/core.c:1507
>
> but task is already holding lock:
> ffff888113640788 (&rdev->wiphy.mtx){+.+.}-{4:4}, at: class_wiphy_construc=
tor include/net/cfg80211.h:6552 [inline]
> ffff888113640788 (&rdev->wiphy.mtx){+.+.}-{4:4}, at: cfg80211_destroy_ifa=
ces+0x128/0x1e0 net/wireless/core.c:394
>
> other info that might help us debug this:
>  Possible unsafe locking scenario:
>
>        CPU0
>        ----
>   lock(&rdev->wiphy.mtx);
>   lock(&rdev->wiphy.mtx);
>
>  *** DEADLOCK ***
>
>  May be due to missing lock nesting notation
>
> 4 locks held by kworker/1:3/1286:
>  #0: ffff888100075948 ((wq_completion)events){+.+.}-{0:0}, at: process_on=
e_work kernel/workqueue.c:3232 [inline]
>  #0: ffff888100075948 ((wq_completion)events){+.+.}-{0:0}, at: process_sc=
heduled_works+0x9d4/0x17a0 kernel/workqueue.c:3340
>  #1: ffffc90008c3fbc0 ((work_completion)(&rdev->destroy_work)){+.+.}-{0:0=
}, at: process_one_work kernel/workqueue.c:3233 [inline]
>  #1: ffffc90008c3fbc0 ((work_completion)(&rdev->destroy_work)){+.+.}-{0:0=
}, at: process_scheduled_works+0xa0f/0x17a0 kernel/workqueue.c:3340
>  #2: ffffffff8f714e88 (rtnl_mutex){+.+.}-{4:4}, at: cfg80211_destroy_ifac=
e_wk+0x19/0x30 net/wireless/core.c:424
>  #3: ffff888113640788 (&rdev->wiphy.mtx){+.+.}-{4:4}, at: class_wiphy_con=
structor include/net/cfg80211.h:6552 [inline]
>  #3: ffff888113640788 (&rdev->wiphy.mtx){+.+.}-{4:4}, at: cfg80211_destro=
y_ifaces+0x128/0x1e0 net/wireless/core.c:394
>
> stack backtrace:
> CPU: 1 UID: 0 PID: 1286 Comm: kworker/1:3 Not tainted syzkaller #0 PREEMP=
T(full)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Workqueue: events cfg80211_destroy_iface_wk
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
>  print_deadlock_bug+0x279/0x290 kernel/locking/lockdep.c:3041
>  check_deadlock kernel/locking/lockdep.c:3093 [inline]
>  validate_chain kernel/locking/lockdep.c:3895 [inline]
>  __lock_acquire+0x253f/0x2cf0 kernel/locking/lockdep.c:5237
>  lock_acquire+0x106/0x330 kernel/locking/lockdep.c:5868
>  __mutex_lock_common kernel/locking/mutex.c:614 [inline]
>  __mutex_lock+0x19f/0x1340 kernel/locking/mutex.c:776
>  class_wiphy_constructor include/net/cfg80211.h:6552 [inline]
>  cfg80211_leave+0x17e/0x240 net/wireless/core.c:1507
>  cfg80211_destroy_ifaces+0x137/0x1e0 net/wireless/core.c:396
>  cfg80211_destroy_iface_wk+0x21/0x30 net/wireless/core.c:425
>  process_one_work kernel/workqueue.c:3257 [inline]
>  process_scheduled_works+0xaec/0x17a0 kernel/workqueue.c:3340
>  worker_thread+0x89f/0xd90 kernel/workqueue.c:3421
>  kthread+0x726/0x8b0 kernel/kthread.c:463
>  ret_from_fork+0x51b/0xa40 arch/x86/kernel/process.c:158
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:246
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
> [avraham.stern@intel.com daniel.gabay@intel.com johannes.berg@intel.com l=
inux-wireless@vger.kernel.org miriam.rachel.korenblit@intel.com]
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
-upstream-moderation/695edb46.050a0220.1c677c.0382.GAE%40google.com.
