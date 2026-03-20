Received: from mail-oo1-f54.google.com (mail-oo1-f54.google.com [209.85.161.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC99E375AB5
	for <syzbot@lists.linux.dev>; Fri, 20 Mar 2026 10:25:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.161.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774002316; cv=pass; b=SJ6iaw9D4HE54Yv+ODwdQclCDK30Gz+JKD9t2FbYL50wI1ADE3mhJjCj0WMAUSdqs5AkHwBd60Iuo4P3cFFbKkF1hUMUHtYy/GMsMzhcmHolTM1uNY+d7LTddSo7T2XnF+H2CfB1E18Y1//8rGSwDCbJ3FLhazvRHMCAaCEmg9E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774002316; c=relaxed/simple;
	bh=GJYHg22c9dHPUZE11UFUZGZQlOWtFVXvZMZSI/GbJxs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DGQNJSFkXhkQFxMbg4tqcFsCsW/RmH4aRrlQ196WQOdgzTMsaQ5KQjQXKN4IAtmcwWIQ2YXHohtNaNp75RoyIQrxVGRR4es+B2VyOAdlxT/Z9F5Ex4TQMy8R8Ven2+q+z5FmbvN4grzdjqQFsolkSRYcGvAVIKnU+QDeoyOmubo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QHdCZqAd; arc=pass smtp.client-ip=209.85.161.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QHdCZqAd"
Received: by mail-oo1-f54.google.com with SMTP id 006d021491bc7-67bb39a1122so1075536eaf.3
        for <syzbot@lists.linux.dev>; Fri, 20 Mar 2026 03:25:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774002309; cv=none;
        d=google.com; s=arc-20240605;
        b=TQTVy16frzdF0VfoEXZF67pHjGBpVX5V3jCPI1myyZS+QL8R+FO8S8bksQcyixl+6H
         Xx01PYQyjjj4RXDk60aCI3NMHEknOA6NgZDxkdW9u4tR+aoFZclj0Y2C5zmXmsb6og8l
         5DEbKTp0NShNQ83w/YqoX/69zKyDZ6SuWx5nVgRdt77NGniZpigD92v8nJApdeeFxyEG
         DIJDEqbfKEyFEhuIA8qv9EIVcdCv6h89JLdAAym8zXp3ayTesl3rPVcoTqMPRyHWAWYo
         paKu0T4vnfqrAzu9PWmJxVUyHjdJNYVrSMb7N8ixw5lTcLjTBiRV2Y/PnFqfZOSmCK/Q
         DIbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=OKVPV5KR9m72gaFhnCfYb9t0z0D82zlROYvVDr70uJ0=;
        fh=VsYbz7Z3PiC7TNiqcNaD/VDMcSHOcEjF58l1En+H388=;
        b=DPuO0YUb+bKoz35ESsqOowBB3sY2pdaacz5kfW7bR2tr2iCtLhsBq/u1IT0udwl5CB
         e3IZ0EcXoZ3eU2rLNMBYvy4s3/PqJDT5PdYzc07azLBx0BtIO5chJibg5QcJyoHpJWzI
         IKorQ9KbNbH2r9kgYhVlyj+JMoXeQ5T5gj7R0NUBS6oM9xqJEkItA+JKMbgBwLcVAmWw
         1jqF/a38amIIOBX/bX8J/KxfOkqZ4tsKoURxLq7EMvPP5Sy72veQAfBGU3oTYYVY9dPB
         Nr46aBs5l9Y9IQ1TQ9LvDh1EboekFo/7vNUagY69i9z4McQEtMb+M7O7w8Oxmm6tWbY/
         sGDQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774002309; x=1774607109; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OKVPV5KR9m72gaFhnCfYb9t0z0D82zlROYvVDr70uJ0=;
        b=QHdCZqAdU9p3jToQqiZo9lK2vJU2/Hc/TNqVqQW5P0dJ74ddYjaXMclpnJzu/3ZQ1g
         Gs7tDekWCbuflYCah4SGZhhU098qxBdfJWPXWhAPEegQkdwBf9g90+NwZ36/NXN1EKs8
         X/bUyLoCcf/wcOle4eLZn1tpCukqFECQ/Ss8yDdvsj1F/oC0Fjv0qRriDTxZfHpP/6Rv
         LX0NrnD5WiYGRye+csF5sMTo0DiQ0NXzxhyPDqSeHS/Iigrs7LBxlcEKpo+vYkEyr/gI
         QMfZ5QGxupuJiZxbAtD35udycat9D5py7WNNY+CMjzh/aqs9+SEWXkR85i7T2kD3VdYa
         eZyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774002309; x=1774607109;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=OKVPV5KR9m72gaFhnCfYb9t0z0D82zlROYvVDr70uJ0=;
        b=cKsHBsfu44h+scQP4uVWTuJGVKjcuNwzVeoiv/A8jOjbMEoxdvCjzTBXlS5CSi9aVA
         qYxVCD2BqOMo/3ilWH+kFDYmaZzg/PsJy1GTl8FqzLOcz9GITKjPTfY/DGCDlZmziu6B
         7DVYIbyHCfD3MoFjklJgJg525pcJlDp/T5MxYscYWW8RLhlTo/duebgriXKYHUmPw5C+
         mZ5RSWTZ4ZDgA7SFeaIXTrYXwvkNKT2t7bFlP1c1nwoYIwImp+mSJvSfMXNZN0YeP8VZ
         62Cwewfc3Ez1mbobod6Y+8V+3ZBQHFAqlkYoq7AlwUgO6dzQheVmbE/d1G9D5R3qmL8I
         Bh6g==
X-Forwarded-Encrypted: i=1; AJvYcCWKJjQhhngENDPgPLtOsQVCB/jiXk0x6N4B8M+kATOeXKrzdc2EvA99xMpULCQAuQaB6a+qVuw=@lists.linux.dev
X-Gm-Message-State: AOJu0YxrPMJk16syoNZTJo8GGkTpWQIOqH4vg3Q2yvAc9JqYVFqT5YMK
	P6gfhJ14ZjUp5iZI2R+udAD/JiS/Yb+kOr1tEc24Dt3kiTQPNb/J1/M7IRAQhpFfvMIoDB9xnG4
	fk3PoF/4GIC5nfLCB9VKVOZ5rqZ6Qu4G2t3t9QYRK
X-Gm-Gg: ATEYQzzuwK4XyW9tmKv8zWVc9sXv+4g+DGkCclov4jtIcxrh6NdiJOplbATUrIxqE3Y
	hA3n9brJSBHA3NfGNsgQ5Z8JhsD936sD6hFuflpe/X74JX2LqsCjB6C4topRsczjjDlqxAIO+v9
	KUKPO1iGO32z2qpa1NRBDwOEHwPgMsbAHct5kJ6rpC8EUcgnZdd2JBAesYkQkuktDCYYKv8oyuY
	F5C3WaNQZKz5183R0853AKRelJ1uxOdPdzXuU7/yJ7M4+JdATtPilaqY2fzPNJu8LYplhotGdyr
	Qc7BwhbtaGs9Ftk8RmY0X01k3HZlM3RHg/Kt6mize4WCktfQd5W9lNxVLIYS6vfWUM2N
X-Received: by 2002:a05:6820:198f:b0:67b:a42f:c332 with SMTP id
 006d021491bc7-67c22feeb54mr1790640eaf.67.1774002309183; Fri, 20 Mar 2026
 03:25:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <69bd1d86.050a0220.3bf4de.0016.GAE@google.com>
In-Reply-To: <69bd1d86.050a0220.3bf4de.0016.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Fri, 20 Mar 2026 11:24:58 +0100
X-Gm-Features: AaiRm50vkGgGaskBEwcs8YoPt369F0lESGGVZ_fPoP-qKeKzBDvyxMlz4RCHT8U
Message-ID: <CANp29Y63=tOvtdKiZQdH+ARf2eirs5RyRVnWhcs97iu1RtiL1w@mail.gmail.com>
Subject: Re: [moderation/CI] Re: ext4: fix use-after-free in update_super_work
 when racing with umount
To: syzbot ci <syzbot+ci0758b13120991e13@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Fri, Mar 20, 2026 at 11:12=E2=80=AFAM syzbot ci
<syzbot+ci0758b13120991e13@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v2] ext4: fix use-after-free in update_super_work when racing with umoun=
t
> https://lore.kernel.org/all/20260319073651.79209-1-jiayuan.chen@linux.dev
> * [PATCH v2] ext4: fix use-after-free in update_super_work when racing wi=
th umount
>
> and found the following issue:
> WARNING in ext4_notify_error_sysfs
>
> Full report is available here:
> https://ci.syzbot.org/series/3b258c63-ea54-492a-ab47-c09e62612658
>
> ***
>
> WARNING in ext4_notify_error_sysfs
>
> tree:      torvalds
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torva=
lds/linux
> base:      0e4f8f1a3d081e834be5fd0a62bdb2554fadd307
> arch:      amd64
> compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~e=
xp1~20251221153213.50), Debian LLD 21.1.8
> config:    https://ci.syzbot.org/builds/8149e3c8-4cb9-4fa0-9bf5-3d6deda68=
99d/config
> C repro:   https://ci.syzbot.org/findings/6f6eafc6-a231-4909-9025-539fa10=
ffcfd/c_repro
> syz repro: https://ci.syzbot.org/findings/6f6eafc6-a231-4909-9025-539fa10=
ffcfd/syz_repro
>
> ------------[ cut here ]------------
> DEBUG_LOCKS_WARN_ON(lock->magic !=3D lock)
> WARNING: kernel/locking/mutex.c:593 at __mutex_lock_common kernel/locking=
/mutex.c:593 [inline], CPU#1: kworker/1:4/5883
> WARNING: kernel/locking/mutex.c:593 at __mutex_lock+0x10a4/0x1300 kernel/=
locking/mutex.c:776, CPU#1: kworker/1:4/5883
> Modules linked in:
> CPU: 1 UID: 0 PID: 5883 Comm: kworker/1:4 Not tainted syzkaller #0 PREEMP=
T(full)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Workqueue: events update_super_work
>
> RIP: 0010:__mutex_lock_common kernel/locking/mutex.c:593 [inline]
> RIP: 0010:__mutex_lock+0x10ab/0x1300 kernel/locking/mutex.c:776
> Code: 11 90 48 c1 e8 03 42 0f b6 04 28 84 c0 0f 85 33 02 00 00 83 3d d9 e=
1 61 04 00 75 13 48 8d 3d 1c f7 64 04 48 c7 c6 c0 e0 cc 8b <67> 48 0f b9 3a=
 90 e9 ac f0 ff ff 90 0f 0b 90 e9 73 f4 ff ff 90 0f
> RSP: 0018:ffffc90004dcf900 EFLAGS: 00010246
> RAX: 0000000000000000 RBX: 1ffff920009b9f38 RCX: ffff888172d3d7c0
> RDX: 0000000000000000 RSI: ffffffff8bcce0c0 RDI: ffffffff9014ec10
> RBP: ffffc90004dcfaa8 R08: ffffffff9011d6c3 R09: 1ffffffff2023ad8
> R10: dffffc0000000000 R11: fffffbfff2023ad9 R12: ffff888172218368
> R13: dffffc0000000000 R14: 0000000000000000 R15: 0000000000000000
> FS:  0000000000000000(0000) GS:ffff8882a945d000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000562af42c7d40 CR3: 0000000111346000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  ext4_notify_error_sysfs+0x23/0xa0 fs/ext4/sysfs.c:600
>  process_one_work kernel/workqueue.c:3276 [inline]
>  process_scheduled_works+0xb6e/0x18c0 kernel/workqueue.c:3359
>  worker_thread+0xa53/0xfc0 kernel/workqueue.c:3440
>  kthread+0x388/0x470 kernel/kthread.c:436
>  ret_from_fork+0x51e/0xb90 arch/x86/kernel/process.c:158
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
>  </TASK>
> ----------------
> Code disassembly (best guess):
>    0:   11 90 48 c1 e8 03       adc    %edx,0x3e8c148(%rax)
>    6:   42 0f b6 04 28          movzbl (%rax,%r13,1),%eax
>    b:   84 c0                   test   %al,%al
>    d:   0f 85 33 02 00 00       jne    0x246
>   13:   83 3d d9 e1 61 04 00    cmpl   $0x0,0x461e1d9(%rip)        # 0x46=
1e1f3
>   1a:   75 13                   jne    0x2f
>   1c:   48 8d 3d 1c f7 64 04    lea    0x464f71c(%rip),%rdi        # 0x46=
4f73f
>   23:   48 c7 c6 c0 e0 cc 8b    mov    $0xffffffff8bcce0c0,%rsi
> * 2a:   67 48 0f b9 3a          ud1    (%edx),%rdi <-- trapping instructi=
on
>   2f:   90                      nop
>   30:   e9 ac f0 ff ff          jmp    0xfffff0e1
>   35:   90                      nop
>   36:   0f 0b                   ud2
>   38:   90                      nop
>   39:   e9 73 f4 ff ff          jmp    0xfffff4b1
>   3e:   90                      nop
>   3f:   0f                      .byte 0xf
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
> [adilger.kernel@dilger.ca jack@suse.cz jiayuan.chen@linux.dev jiayuan.che=
n@shopee.com linux-ext4@vger.kernel.org linux-kernel@vger.kernel.org ritesh=
h@linux.ibm.com tytso@mit.edu yebin10@huawei.com]
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
-upstream-moderation/69bd1d86.050a0220.3bf4de.0016.GAE%40google.com.
