Received: from mail-oa1-f48.google.com (mail-oa1-f48.google.com [209.85.160.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CB3129994B
	for <syzbot@lists.linux.dev>; Fri, 22 Aug 2025 19:27:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755890829; cv=none; b=EDSVSGIv3ZMC8I5BNZo6DagYIxD+ZGuHIJuVBVHS7bwiI4lTCrMqzGYb5YAeZq9ORy4I+FgWbs8ObVprKIqyOA/H4ZJmtLyPt+LB0gPIujHIlWgSJ2ddtLF0t3QTJuLegY6E9lYU3jKazuclEhYHnC3fL8W8d0/LQ+d+hkH6H9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755890829; c=relaxed/simple;
	bh=Mq3ZYdSII7JmwJ3FvwhPWk4mwkrakoHb9Iv84Kk6xuI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bWeezrBoD8xpOcr5QQYhK77KsniW5VFDHaVHraHbeuoAU6sBTiKAeolxAwuuJWYckFiiB1a4uOsrhAwBrpfU2UXH3+iIBp6v9KCYbS+8na78rzWp5WuE1Ax36nnoTnJuJCzGYcEoKTWUrpHy3cDfAASWtDuA45coriRlwiAUAM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=IWMxysmM; arc=none smtp.client-ip=209.85.160.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IWMxysmM"
Received: by mail-oa1-f48.google.com with SMTP id 586e51a60fabf-30cceb07f45so1566831fac.2
        for <syzbot@lists.linux.dev>; Fri, 22 Aug 2025 12:27:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755890826; x=1756495626; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YAIlRs2OEtf45UXF4j4ncwxyFEmvyp6yjlvj+pfyztc=;
        b=IWMxysmMOEQPLatIl2GfsOa3OU6aYvpw0XpKw9xC6RyF/WNHkVkfe66x48OQReLWYt
         aT1QKxxkV644+tmT+pcklWDS9ESbezvDFkBK2Acmu9bXKlo9rHS06AFz7zsgE5ZdmZSs
         hBDzFYTE8r+V7S4hXq5rGd7XJ6SWDwkX7ncbN3sdP8j75Yrwk5RMdiLLzKHdN5djepjr
         eu0VAQo16kh4xzP5dvMKDgKeYd9DdWR6MiKV2fXwZCOXyNjYjGly/p2bfjm4IkqolG03
         lmrpa3zshNPY18E6WvDxxu5cKlxO8OaAiLBPajr7KnMC6IrGd/wwckoQQpjsCbc7HbZu
         yfgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755890826; x=1756495626;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YAIlRs2OEtf45UXF4j4ncwxyFEmvyp6yjlvj+pfyztc=;
        b=a+pph6AcBvW8rZ5yz3fKBRLgyWR+DlXl4uRZ7/truTrObvbbPyrnxvhqxtM85k2BiG
         i0nd9PQxWWWsedaeKrVKaB44jOl9EGfrfjTzmGfq2fA5gzdQgyAM65EpNluETrXfB+TY
         oHBwo1hD1ZK9kMGE3PX1jpBYTuEwzL2PwyNQlfQPAcCx9OFNfNhz+P+ky/CDRJOzEgNf
         hs3BEp2WnRNq6MmdPT14qSIy3m1KwsMTnQIVJObqLCnJusSYKJZlQk+PQgfmGqFk99tq
         ejLiRb4JcoeycIG1l38viTyvhXQtpKtrjWXKZ+2WRGnsQYgZHTx640oq5Id3FQWmmiro
         /nAg==
X-Forwarded-Encrypted: i=1; AJvYcCXgzxjBPj0Cr6Hi/NxPu3+YfOObInnjzZP5N3urL3CiIPfc0ZmHF2P7RKZmHpldxQs12VmgBKQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YwEK7+YHThG8kggUE1OEYH7zV9B1El7kIzpSA1fd6OxfQRDaoz+
	y8qQ7jD7zfYtYO1iTdkaFbp+8gStH2rVIOxZM2WBBHnaEGHkLT8/fco+hdTkxfvXaZImJrceN3S
	lnuoBsvpUBkyAzlkHT/7kOFB6MXZe5p/nwkzQ6xIzNC/SLE/idKMREbyk
X-Gm-Gg: ASbGncvwXlmJ3nkR9/gc0pbW4OT53TMGthCIOS5YkQiY5ri6H6lPTZeqQjZchPiFpuj
	+SHiHQ6nP+Cf+zLVVyJwuzAU50VHq3NNknIEGGQfeAyEhM1zhUlGbAZAUC03ogoVhdUdJZ4Ekw5
	HCwwPb7V+O0kVz1X+ARaVrT2P4zk9wkFiHRbCXfswMplPuOnYqK8ddC8onpsZM3laT2vmkslQ0Y
	I2HuodvMgL7o+0RyCwIWruw00Atg/hrQlTMel46HZHBXrhrLFpLuPM4
X-Google-Smtp-Source: AGHT+IGSgdajCyigpxVmVCtHLEo68ytPxb3SARpyPeIrGh4BonqSAVSdYiEROW87st4pZSpN2g3TGHn/mERTIyATeXc=
X-Received: by 2002:a05:6871:810e:b0:2f5:2bb1:e85e with SMTP id
 586e51a60fabf-314dcd2db9fmr1571383fac.24.1755890826286; Fri, 22 Aug 2025
 12:27:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <68a8b9d2.050a0220.37038e.0059.GAE@google.com>
In-Reply-To: <68a8b9d2.050a0220.37038e.0059.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Fri, 22 Aug 2025 21:26:55 +0200
X-Gm-Features: Ac12FXxblRMvnH0HoYyVAdGUejj7B1JB6S8OqIhKWHT1hWWFXzfa2-eukuRKgNM
Message-ID: <CANp29Y4CcHyiPT-_Douuy7Xfgkrk0XLtP5c6t5wPXE75gAu2Bw@mail.gmail.com>
Subject: Re: [moderation/CI] Re: ovl: Enable support for casefold layers
To: syzbot ci <syzbot+ci16957c631d6b7071@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Fri, Aug 22, 2025 at 8:41=E2=80=AFPM syzbot ci
<syzbot+ci16957c631d6b7071@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v6] ovl: Enable support for casefold layers
> https://lore.kernel.org/all/20250822-tonyk-overlayfs-v6-0-8b6e9e604fa2@ig=
alia.com
> * [PATCH v6 1/9] fs: Create sb_encoding() helper
> * [PATCH v6 2/9] fs: Create sb_same_encoding() helper
> * [PATCH v6 3/9] ovl: Prepare for mounting case-insensitive enabled layer=
s
> * [PATCH v6 4/9] ovl: Create ovl_casefold() to support casefolded strncmp=
()
> * [PATCH v6 5/9] ovl: Ensure that all layers have the same encoding
> * [PATCH v6 6/9] ovl: Set case-insensitive dentry operations for ovl sb
> * [PATCH v6 7/9] ovl: Add S_CASEFOLD as part of the inode flag to be copi=
ed
> * [PATCH v6 8/9] ovl: Check for casefold consistency when creating new de=
ntries
> * [PATCH v6 9/9] ovl: Support mounting case-insensitive enabled layers
>
> and found the following issue:
> WARNING in ovl_dentry_weird
>
> Full report is available here:
> https://ci.syzbot.org/series/efd002b5-e585-4cf8-86e7-4f24ba2247c7
>
> ***
>
> WARNING in ovl_dentry_weird
>
> tree:      torvalds
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torva=
lds/linux
> base:      068a56e56fa81e42fc5f08dff34fab149bb60a09
> arch:      amd64
> compiler:  Debian clang version 20.1.7 (++20250616065708+6146a88f6049-1~e=
xp1~20250616065826.132), Debian LLD 20.1.7
> config:    https://ci.syzbot.org/builds/039eb31b-2b45-4207-b63e-71a25ed89=
f00/config
> C repro:   https://ci.syzbot.org/findings/726ae90b-83b6-49e2-a496-9bfe444=
dc24f/c_repro
> syz repro: https://ci.syzbot.org/findings/726ae90b-83b6-49e2-a496-9bfe444=
dc24f/syz_repro
>
> EXT4-fs (loop0): 1 orphan inode deleted
> EXT4-fs (loop0): mounted filesystem 00000000-0000-0000-0000-000000000000 =
r/w without journal. Quota mode: none.
> ------------[ cut here ]------------
> WARNING: CPU: 0 PID: 6001 at fs/overlayfs/ovl_entry.h:118 OVL_FS fs/overl=
ayfs/ovl_entry.h:118 [inline]
> WARNING: CPU: 0 PID: 6001 at fs/overlayfs/ovl_entry.h:118 ovl_dentry_weir=
d+0x15a/0x1a0 fs/overlayfs/util.c:206
> Modules linked in:
> CPU: 0 UID: 0 PID: 6001 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:OVL_FS fs/overlayfs/ovl_entry.h:118 [inline]
> RIP: 0010:ovl_dentry_weird+0x15a/0x1a0 fs/overlayfs/util.c:206
> Code: e8 6b f9 8f fe 83 e5 03 0f 95 c3 31 ff 89 ee e8 9c fd 8f fe 89 d8 5=
b 41 5c 41 5e 41 5f 5d e9 3d b9 4c 08 cc e8 47 f9 8f fe 90 <0f> 0b 90 e9 08=
 ff ff ff 44 89 f1 80 e1 07 80 c1 03 38 c1 0f 8c 0b
> RSP: 0018:ffffc90002caf9c8 EFLAGS: 00010293
> RAX: ffffffff832fb1e9 RBX: ffff888109730000 RCX: ffff888023295640
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff88802b624a48
> RBP: dffffc0000000000 R08: 0000000030656c69 R09: 1ffff110048d0ce0
> R10: dffffc0000000000 R11: ffffed10048d0ce1 R12: dffffc0000000000
> R13: 0000000000000003 R14: ffff88802b624a48 R15: ffff888109730028
> FS:  0000555581e17500(0000) GS:ffff8880b861b000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000200000001000 CR3: 00000000242f4000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  ovl_mount_dir_check fs/overlayfs/params.c:300 [inline]
>  ovl_do_parse_layer+0x307/0xbb0 fs/overlayfs/params.c:422
>  ovl_parse_layer fs/overlayfs/params.c:448 [inline]
>  ovl_parse_param+0xb62/0xee0 fs/overlayfs/params.c:633
>  vfs_parse_fs_param+0x1a9/0x420 fs/fs_context.c:146
>  vfs_parse_fs_string fs/fs_context.c:188 [inline]
>  vfs_parse_monolithic_sep+0x24d/0x310 fs/fs_context.c:230
>  do_new_mount+0x273/0x9e0 fs/namespace.c:3804
>  do_mount fs/namespace.c:4136 [inline]
>  __do_sys_mount fs/namespace.c:4347 [inline]
>  __se_sys_mount+0x317/0x410 fs/namespace.c:4324
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f0c2558ebe9
> Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffd67150878 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
> RAX: ffffffffffffffda RBX: 00007f0c257b5fa0 RCX: 00007f0c2558ebe9
> RDX: 0000200000000b80 RSI: 0000200000000100 RDI: 0000000000000000
> RBP: 00007f0c25611e19 R08: 0000200000000180 R09: 0000000000000000
> R10: 0000000000000008 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f0c257b5fa0 R14: 00007f0c257b5fa0 R15: 0000000000000005
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
> [amir73il@gmail.com andrealmeid@igalia.com brauner@kernel.org jack@suse.c=
z kernel-dev@igalia.com krisman@kernel.org linux-fsdevel@vger.kernel.org li=
nux-kernel@vger.kernel.org linux-unionfs@vger.kernel.org miklos@szeredi.hu =
tytso@mit.edu viro@zeniv.linux.org.uk]
>
> If the report looks fine to you, reply with:
> #syz upstream
>
> --
> You received this message because you are subscribed to the Google Groups=
 "syzkaller-upstream-moderation" group.
> To unsubscribe from this group and stop receiving emails from it, send an=
 email to syzkaller-upstream-moderation+unsubscribe@googlegroups.com.
> To view this discussion visit https://groups.google.com/d/msgid/syzkaller=
-upstream-moderation/68a8b9d2.050a0220.37038e.0059.GAE%40google.com.
