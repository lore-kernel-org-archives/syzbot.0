Received: from mail-oa1-f43.google.com (mail-oa1-f43.google.com [209.85.160.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72B3E37F8C4
	for <syzbot@lists.linux.dev>; Thu, 30 Apr 2026 07:54:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777535647; cv=pass; b=d0XeboNX4+YC8Qcm+ISEuskh4BAQVncXomVNNRFHSz88fLvcZnm4vadnspB2Bo3/lvnKPMXEjtOHy4ZDQKL71tiB8YrkjyLHQUXOrMKH5Srhq7/EoohRCi6uLX/pv/NoV1wiEx+TkaTPUuyefwgy88T7aIvLsJQtGS293WpnClg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777535647; c=relaxed/simple;
	bh=7EY93OqwUZPSBfpB0rCDzk6Rd3SBev3EiQfPFjsFmj8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DrrTeprXsvCS2Q/uj4L94OBvPCioZ8UAXZR59ajmZ+9MDKqUxy+3Zj/zNELJm+OmJ22cGEsUuXjwiz6RsxrQtEYHxqSh+m60TfF5uEFIHcBY1YGEzrWFZW8bkdP6FC1Io1rYhZE+Re3myDYHWjEKqhSUulmmdqNby6Zyb9Yc93U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jJ908hm4; arc=pass smtp.client-ip=209.85.160.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jJ908hm4"
Received: by mail-oa1-f43.google.com with SMTP id 586e51a60fabf-4303eb92930so436610fac.3
        for <syzbot@lists.linux.dev>; Thu, 30 Apr 2026 00:54:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777535644; cv=none;
        d=google.com; s=arc-20240605;
        b=etdqaZQQV+29SCwVxFYgv5kEnogW5qOE5U2shF0NYUBxi6AwcwGLMiRAdEapEcrdpY
         lPPOKsMqUgLm2hmqh0od+Q5BDI6mSFw5VOQXV1aMQbNGwVS00odCEXslkUWWjBWlcqeU
         gwN+xcJRbiE4N+NXAMmxcSH5ScPkU4rI8KK5rJ3eahF/ZQ1ANSgGaZW02P/yShsVplzc
         HHrrckcYoz4qiLlYCq6qMUoYGMcld3agu2Pnk/avGe7kMDZboNOl95iVmUdvt9su9CUD
         qfFfxNlU6bikFovU4EhUkHgB8e+FWt/nm7Wm8/M79F4BvzlqiBJ+GSVe4+4W+hjQFC9A
         FYlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Xx/WfI0BvA5CvB/ZMUYE5/C58hTevVrdBepjFcBOZkE=;
        fh=T0dYQAvaJUKWmzwtJxM5roudaj6N5dRLgS1aokGAbiQ=;
        b=exkNiO3AOQhHxcPsHUQinR2BKGuxKoKiiRklSg/9mYr4VLRf8EDgqDS2TOxiHoPoGt
         JAFDkr0sb9kU7vsR8AySN+vWvbOYMbaSEG0uIW9UkdHz5i3+opdH0x3CqrQhmFUAYzjM
         tVjFH2e+W0fh/3nQflSXOlnLrmJgCWocpJQ3pfPdEDYNNiQYO0hIOIOl/N8T9jk5wIQ3
         H2y7ufWPzK/ueHFrRPrSiq8J9LfhJ5wG/LeiYfrguVK31zhiSCHeyXO7wQdGz/A1sr4t
         K9YxwQ5woe1ogXuunJ3wh0xYZxLJ26Rt0r+C/LYfsdxDymuxbvF29Ca/saL6Ga103+tJ
         r+/A==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777535644; x=1778140444; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Xx/WfI0BvA5CvB/ZMUYE5/C58hTevVrdBepjFcBOZkE=;
        b=jJ908hm4cd3N3LPYGiQHQ/+4e465SZH62LmxSNoXQxeUY4HdtJJFZSmWGnLFCLXfft
         maSXyqk+amxwz1Uqvw+8fOmkHAVZcaDuvbQt9w/RmnJ6zETnaP8JYUbks5hqkZQzq3Wh
         UEwMGLTkWhWdlZBjmmsL6/zYxBvr82lI3g8WodBesXgVRAL+4I/svQKB2sSyLL77jddW
         bDArYApDaU/PzVvLhtTeU14pixH7X8invGjsHQXqTQEzs7PdcmEBkH1zebYDSw+l8iy0
         nVSXU87TGahlpx/IAECOlQVmCv37vFgYwazSR0wBszMK0asrSRhM3PyYDPd1DNpV+wT9
         wHow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777535644; x=1778140444;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Xx/WfI0BvA5CvB/ZMUYE5/C58hTevVrdBepjFcBOZkE=;
        b=cYnoKNQhUZRe4IUAzV7EhW3MD4VWGO+xfOBsYlposQ2bEgm65/DOiFkXPOcFLvIpyY
         EEwNE6BIjS7o08UIkUxBWKWLRkccQpuc3VcFxbQp2mYNdyckTUjag9vBs2LiBIMWJqPs
         IpmBfVEF0XJ1LU0AR545zdrAPrsnwy3TKiMirZJ4ahfcxk5nk0sx4XjXdowhfodMgvvF
         zdJTUQT51h70cij4bRvXeZb3k7qMmMD5CVk6rXdeoyj0o1lNHFWBImfhp/cFfdJ5mKWc
         mArpr5LIUebVe+bOW8OPtuKhkuedhsR5TXSZCa8QwYuIWBfKcue3A81ynEo7WWsZibXt
         bRuA==
X-Forwarded-Encrypted: i=1; AFNElJ+nNSZiK6LJ6d3ULpbQ2WCRm+lHhFAfYPOlZwSSJBiW0Yu2olYQikvy1NOgRC6uTKkUS7fqcrY=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy3fn8l8wgWrxcIKGvqZ8eF1wCS+I6tnVoio5hZyoJ5NfEt80b6
	gkUjc+q2nGwkO/zqnC3XXWZonKGooj/cMUsTnDeqv9wZY/YkmwZwW7cNJF3bfwJ08biMSyxxOyX
	nBerO1CPUGJDcZfmXjmYjIe4BGANapJFSF5F3Dznb
X-Gm-Gg: AeBDiesiCmNfnfuAxZt7bqRAce3jCkCkhGMY5O5ogQV2ZF+OknBDMLL7hpXWl19E//s
	jarHO8ku6Rp/ZRD+0QRhOm7CDDsGA7J8wU8tyWCw6TvgrXcWP7IR5zIc38quIqDykLv0U5P4Kuo
	ODoAa2OJtTwMm9Ewjv/ceccEAAkSAUIrUwNzg+bPaT2WJijs0GlVZ50+yW899aRm5chuaJdxoXj
	oRUd9+NH7EvKak+KBYcVp3aCIV6uuqZ5hFZ+1Orv/fH9nfcvnf6pqIkcLOg1RaO9fkCS6yHrW//
	IO9SdmCc3zLHDS4aHsFF0xGXq/7c7Y1XKI37JtKQ+A5adW3gFlS5tkJ8g9MoDBVNWrbDVqFSi6B
	eOIvLxopAJEoCi3GLaCVg8FCtfg==
X-Received: by 2002:a05:6871:c91f:b0:41c:a61:b612 with SMTP id
 586e51a60fabf-43437c455bemr703699fac.1.1777535643783; Thu, 30 Apr 2026
 00:54:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <69f2f661.050a0220.11c491.000a.GAE@google.com>
In-Reply-To: <69f2f661.050a0220.11c491.000a.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Thu, 30 Apr 2026 09:53:52 +0200
X-Gm-Features: AVHnY4KJ7JAdtnkNPs80WdauN8lKDRUCfw2d8-A_Wu7VJkCn0Hy5jQw6SrzTgkI
Message-ID: <CANp29Y5tBqRK4r8ms6Lc+eA1k3Zckma0V8X-3n7vb+SBUbqimg@mail.gmail.com>
Subject: Re: [moderation/CI] Re: mm: Make per-VMA locks available in all builds
To: syzbot ci <syzbot+cife3f6234f9070b16@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Thu, Apr 30, 2026 at 8:27=E2=80=AFAM syzbot ci
<syzbot+cife3f6234f9070b16@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v1] mm: Make per-VMA locks available in all builds
> https://lore.kernel.org/all/20260429181954.F50224AE@davehans-spike.ostc.i=
ntel.com
> * [PATCH 1/6] mm: Make per-VMA locks available universally
> * [PATCH 2/6] binder: Make shrinker rely solely on per-VMA lock
> * [PATCH 3/6] mm: Add RCU-based VMA lookup that waits for writers
> * [PATCH 4/6] binder: Remove mmap_lock fallback
> * [PATCH 5/6] tcp: Remove mmap_lock fallback path
> * [PATCH 6/6] x86/mm: Avoid mmap lock for shadow stack pop fast path
>
> and found the following issue:
> WARNING in mbind_range
>
> Full report is available here:
> https://ci.syzbot.org/series/374f338e-4b3b-4645-871c-78964f944bbd
>
> ***
>
> WARNING in mbind_range
>
> tree:      torvalds
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torva=
lds/linux
> base:      57b8e2d666a31fa201432d58f5fe3469a0dd83ba
> arch:      amd64
> compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~e=
xp1~20251221153213.50), Debian LLD 21.1.8
> config:    https://ci.syzbot.org/builds/786ac31f-0f5e-4ceb-88c7-45f4bee79=
d60/config
> syz repro: https://ci.syzbot.org/findings/4b270176-3e48-4ac7-8ddb-f326d68=
83d93/syz_repro
>
> pgoff 200000000 file 0000000000000000 private_data 0000000000000000
> flags: 0x8100077(read|write|exec|mayread|maywrite|mayexec|account|softdir=
ty)
> ------------[ cut here ]------------
> 1
> WARNING: ./include/linux/mmap_lock.h:332 at vma_assert_write_locked inclu=
de/linux/mmap_lock.h:332 [inline], CPU#0: syz.2.19/5876
> WARNING: ./include/linux/mmap_lock.h:332 at vma_replace_policy mm/mempoli=
cy.c:1016 [inline], CPU#0: syz.2.19/5876
> WARNING: ./include/linux/mmap_lock.h:332 at mbind_range+0x57a/0x810 mm/me=
mpolicy.c:1063, CPU#0: syz.2.19/5876
> Modules linked in:
> CPU: 0 UID: 0 PID: 5876 Comm: syz.2.19 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:vma_assert_write_locked include/linux/mmap_lock.h:332 [inline]
> RIP: 0010:vma_replace_policy mm/mempolicy.c:1016 [inline]
> RIP: 0010:mbind_range+0x57a/0x810 mm/mempolicy.c:1063
> Code: 97 ff e9 b2 fb ff ff e8 a4 4a 97 ff 90 0f 0b 90 e9 14 fe ff ff e8 9=
6 4a 97 ff 4c 89 ff e8 0e b5 f9 fe c6 05 9c 2e ec 0d 01 90 <0f> 0b 90 4d 85=
 e4 0f 85 48 fe ff ff e8 75 4a 97 ff 31 db 4d 8d 77
> RSP: 0018:ffffc90003bc7c78 EFLAGS: 00010292
> RAX: 000000000000011f RBX: 000000000000000b RCX: a410c902b7e34800
> RDX: 0000000000000000 RSI: 0000000080000000 RDI: 0000000000000000
> RBP: 0000000000000009 R08: ffffc90003bc7967 R09: 1ffff92000778f2c
> R10: dffffc0000000000 R11: fffff52000778f2d R12: ffff8881012c9e00
> R13: dffffc0000000000 R14: ffff888115b99bf8 R15: ffff8881162fa300
> FS:  00007fa09187c6c0(0000) GS:ffff88818dc93000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000001b33b63fff CR3: 0000000115bda000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  do_mbind mm/mempolicy.c:1560 [inline]
>  kernel_mbind mm/mempolicy.c:1757 [inline]
>  __do_sys_mbind mm/mempolicy.c:1831 [inline]
>  __se_sys_mbind+0xad4/0x10f0 mm/mempolicy.c:1827
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x15f/0xf80 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7fa09099cdd9
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007fa09187c028 EFLAGS: 00000246 ORIG_RAX: 00000000000000ed
> RAX: ffffffffffffffda RBX: 00007fa090c15fa0 RCX: 00007fa09099cdd9
> RDX: 0000000000000001 RSI: 0000000000600000 RDI: 0000200000000000
> RBP: 00007fa090a32d69 R08: 0000000000000000 R09: 0000000000000003
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007fa090c16038 R14: 00007fa090c15fa0 R15: 00007ffff596d0f8
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
> To test a patch for this bug, please reply with `#syz test`
> (should be on a separate line).
>
> The patch should be attached to the email.
> Note: arguments like custom git repos and branches are not supported.
>
> The email will later be sent to:
> [akpm@linux-foundation.org dave.hansen@linux.intel.com liam.howlett@oracl=
e.com linux-kernel@vger.kernel.org linux-mm@kvack.org ljs@kernel.org shakee=
l.butt@linux.dev surenb@google.com vbabka@kernel.org]
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
-upstream-moderation/69f2f661.050a0220.11c491.000a.GAE%40google.com.
