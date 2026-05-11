Received: from mail-oa1-f42.google.com (mail-oa1-f42.google.com [209.85.160.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80D911E9B3D
	for <syzbot@lists.linux.dev>; Mon, 11 May 2026 20:47:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778532430; cv=pass; b=IO4z6M/ZJd1c8qGgTQqCqEN2oFRsXqwryTdinLWUY1UR/W03x7xE89NfgyVFZuyt5bzOKlERWmTfDER6UhlQky5D1/Rn9C0FaqIYlkj4Dul5C9arH3s0iV+qN/TqMLW4MqpP40tGccOiYoXwYvamfrqOzm3deSryxVW4un+v9Wk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778532430; c=relaxed/simple;
	bh=tqYV6nyg+rX3wUN+I3Iaud595m98nsPfa70JK2QSADY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Qrz5sOMpuN0WXhEe1mySmTnnp/wwu0mfkzzFT8GQmKY4TufEsi4OHpHb14MjdWi4ql50rw9iBoubG/Ju1AsMuWxKYYlaEbZpvzq4SSwqvd0I3isdbbwafQsOiXCdgrSiCKVj4qtGu51UfvPVbjph4VMr5Rt4uUD53ToTel04sbc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=d7UUtB56; arc=pass smtp.client-ip=209.85.160.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="d7UUtB56"
Received: by mail-oa1-f42.google.com with SMTP id 586e51a60fabf-42ff0576868so2175761fac.1
        for <syzbot@lists.linux.dev>; Mon, 11 May 2026 13:47:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778532427; cv=none;
        d=google.com; s=arc-20240605;
        b=LdWJpC6Fjj931IkXgD+nyzOaav9nxyXTOeAFOImUECKQakvNeEEuhsqcI09HcKm+Do
         4GgGdsjrYXz768tfW+Z1t5nXSFA1x5rtQqbFJwP7q8lf5Q5UnopJUoagUXlorVxXVzur
         67uyIXJh8Yff5digihM5w+9QlvrwKXxgkmShaXnGy9J57bT83gp2jk/rhlWIdhHm7vbE
         s0Ui6uLDD707jvsTSj9c3uf03j0gXKhh2XuQAOvTFGHbDBviI4kWXlRwIsfsElQAfTcH
         P29UUxg3ftioFa6P4Hiw/wQ0WpTKoffMgVgQsMcN+E5juRwXdeuK9kIOanYY9vlQS32A
         thlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=i/G4mfw8oVnYhq0bHln6JeMG6cT+ZpxIGcRIxTPqoEk=;
        fh=Gv4rd465NOd6L6rS+dXmtme9fKHZKrV8xs6czKM5JeQ=;
        b=As+U8UivYKioeA5a+W1IG4DZFcPQygmo4O8Wf4LN/8LilDCAJHTrlrXFOZxDDLDVkR
         nVPJ8QRlODRAxxPM5ox8vLvqd7xa3/7QwdzozVe6IgIgcGbP/P9+tAtbIB5m8xnCPqar
         xnLDrJkHITcUausjocKw9FoJsSaGOf8Sj2+UCNwQhiKXJe3J0nSdJg5SlQec/LWTnP2+
         dux2Laz1Khdw7zo4vfcpIdjGhJ5WYO23KhnV+9ZT+VWI2GuZOXzu5hQ2e/rxgyX0xriF
         qZkP3d6J/NDXcfv4VfKr++dQiir3C6p52XZD7lHGPkuNuO4+tKDxixpuOjJ9yeNvnRgc
         YZNg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778532427; x=1779137227; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=i/G4mfw8oVnYhq0bHln6JeMG6cT+ZpxIGcRIxTPqoEk=;
        b=d7UUtB56SoWbl1fL8h4+QnnNnh2VlxfGCTvmUU2jq2ffmJ0fayK4qZZcjAOnXUDhct
         iwTffVWeTvzdMJXhOh+ioLS7tOTG3PgGX33hG5p6TAvE7Ou48dukFsCtOTWTCazJivIs
         5bcpDO4HTrc6u47U9GhgKkH2dvskpc2s3JfBQlA8diJ6o40UFHN3iYCJIqnO+NGXQBZh
         gNJ/LPfV/W3bWnJyAQN1g7j8AxUh0s3jKYRJo+go+R2orutHGtoleyQO67iR2oW/Lrd5
         JgYoKJoPrjpQvKaev28B6XUpsiGQp/QZYofkCUG1bKnpf2JbCfFssUe3oehQjpXQDfCa
         zjZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778532427; x=1779137227;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=i/G4mfw8oVnYhq0bHln6JeMG6cT+ZpxIGcRIxTPqoEk=;
        b=TWw5GI8TKxNCVEDRsMkgu37ATXT3R2Krqk0hnFK5qH8lRwNu3ntifbVubo9hk3Vu6o
         woFTFRViJWLJ5c9iNa2gog/pADWhRLFpa7vBoZy3opasNL2zfhofgVo2Mm0bAvERQhAW
         c+2UbDJUJSfZhNVRCh+kUVVodcYn6funVz1YQjAF1JdP9qN/MkqrWTVTk3cUFvXcnH7u
         1rX1YkYn+7w4mj/qzhXAdrWPjkHQx7YE19JWMpR3c6GZm+R93krh7ofSTMsy2iYbTtPC
         lXnJBHAZNU3I68IreGkbdfcUPXzHPzz40g/G8CyMwb5jyxE8epmAbnrp4mg/Yw47is4C
         ytgA==
X-Forwarded-Encrypted: i=1; AFNElJ+X8o2NsO4F0Nlzu2PhxPn/wrIF0mIQPbmH1Rig0gRe7paKO5d1pv37OWTG0G1HM+fep3Sz7C0=@lists.linux.dev
X-Gm-Message-State: AOJu0YxX2L3IPlqoYhREIsBhZ4tscHkv7Oq6MGXuc5KBxDwkoY2BZEJ8
	3hugn5QBuLOGvyLFD/dWWLXpkvffvl9Q/f4FINF8dKsRcqzjHldLD2/pN1pGcSpk2z/OgNsB70l
	1rOVlNT9v99dDF5V26YYSmnHsnAJ9dk/SGuvREmCW
X-Gm-Gg: Acq92OFX5xHVQsQO0Tm1PWoS0KlQ8qWdyEKrevLpfsMTumradLjqv1Zpx8NbBQ09i/R
	JTbr10op5zUK9LLY56knq+A2Cp8wfaewPMN9INGPf/h0vvWkxQJw8T04gH39g7D8GNNUeOQ3nDl
	iHg5BpE3EtJSTwD4Hjyg68EEMHEdi0iHGWxxiO+uQiHF7Ue0LMGTfXyIBGwT85W/nKiau4/xDfE
	FRChttBx1NzBfd6iIIUuyehgGDsV+SnuKKy/MuGPcTy9+g+B0CUnPWTs9fEzrVsc4H+4/tvOiYy
	7qlve2VHgvpBMPleLs+1bGAiBTkjLzuNzJz3YkhsPJCjLsXMpRmhiu0Q/Wun0wTkvJxhsKMC2J9
	4xx30IF4=
X-Received: by 2002:a05:6870:334c:b0:435:1e04:5e79 with SMTP id
 586e51a60fabf-435892b0e1bmr7033593fac.36.1778532426969; Mon, 11 May 2026
 13:47:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <6a02309c.170a0220.7f9b3.0000.GAE@google.com>
In-Reply-To: <6a02309c.170a0220.7f9b3.0000.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Mon, 11 May 2026 22:46:55 +0200
X-Gm-Features: AVHnY4IuavqrFpu-KDzNOPoUAieeQWAtyqCSGY-ntlkxFNrARHF1QLO2lQTn5Qk
Message-ID: <CANp29Y74MSGkZtgsuEG4_SEiw=7pSFQnioUeHrxJwZ9P2Asy7A@mail.gmail.com>
Subject: Re: [moderation/CI] Re: fs: Fix missed inode write during fsync
To: syzbot ci <syzbot+ci14567cf62024b9b0@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream


On Mon, May 11, 2026 at 9:40=E2=80=AFPM syzbot ci
<syzbot+ci14567cf62024b9b0@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v1] fs: Fix missed inode write during fsync
> https://lore.kernel.org/all/20260511115725.28441-1-jack@suse.cz
> * [PATCH 1/9] affs: Drop support for metadata bh tracking
> * [PATCH 2/9] ext4: Allocate mapping_metadata_bhs struct on demand
> * [PATCH 3/9] fs: Writeout inode buffer from mmb_sync()
> * [PATCH 4/9] ext2: Fix possibly missing inode write on fsync(2)
> * [PATCH 5/9] udf: Fix possibly missing inode write on fsync(2)
> * [PATCH 6/9] fat: Fix possibly missing inode write on fsync(2)
> * [PATCH 7/9] minix: Fix possibly missing inode write on fsync(2)
> * [PATCH 8/9] bfs: Fix possibly missing inode write on fsync(2)
> * [PATCH 9/9] ext4: Use mmb infrastructure for inode buffer writeout
>
> and found the following issue:
> KASAN: null-ptr-deref Write in write_dirty_buffer
>
> Full report is available here:
> https://ci.syzbot.org/series/d987d2d8-3775-4aa9-959f-8a045778888c
>
> ***
>
> KASAN: null-ptr-deref Write in write_dirty_buffer
>
> tree:      torvalds
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torva=
lds/linux
> base:      5d6919055dec134de3c40167a490f33c74c12581
> arch:      amd64
> compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~e=
xp1~20251221153213.50), Debian LLD 21.1.8
> config:    https://ci.syzbot.org/builds/567d596c-ca65-43c9-bd7d-1e60cfe9d=
a2a/config
> syz repro: https://ci.syzbot.org/findings/1bc13af8-2d91-4fbd-b43e-fbe72f2=
9ca41/syz_repro
>
> EXT4-fs (loop2): unmounting filesystem 00000000-0000-0000-0000-0000000000=
00.
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> BUG: KASAN: null-ptr-deref in instrument_atomic_read_write include/linux/=
instrumented.h:112 [inline]
> BUG: KASAN: null-ptr-deref in test_and_set_bit_lock include/asm-generic/b=
itops/instrumented-lock.h:57 [inline]
> BUG: KASAN: null-ptr-deref in trylock_buffer include/linux/buffer_head.h:=
425 [inline]
> BUG: KASAN: null-ptr-deref in lock_buffer include/linux/buffer_head.h:431=
 [inline]
> BUG: KASAN: null-ptr-deref in write_dirty_buffer+0x37/0x190 fs/buffer.c:2=
760
> Write of size 8 at addr 0000000000000000 by task syz-executor/5742
>
> CPU: 1 UID: 0 PID: 5742 Comm: syz-executor Not tainted syzkaller #0 PREEM=
PT(full)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
>  kasan_report+0x117/0x150 mm/kasan/report.c:595
>  check_region_inline mm/kasan/generic.c:-1 [inline]
>  kasan_check_range+0x264/0x2c0 mm/kasan/generic.c:200
>  instrument_atomic_read_write include/linux/instrumented.h:112 [inline]
>  test_and_set_bit_lock include/asm-generic/bitops/instrumented-lock.h:57 =
[inline]
>  trylock_buffer include/linux/buffer_head.h:425 [inline]
>  lock_buffer include/linux/buffer_head.h:431 [inline]
>  write_dirty_buffer+0x37/0x190 fs/buffer.c:2760
>  mmb_sync+0x74c/0xed0 fs/buffer.c:603
>  ext4_evict_inode+0x2fa/0x1040 fs/ext4/inode.c:199
>  evict+0x61e/0xb10 fs/inode.c:841
>  ext4_quota_off+0x470/0x580 fs/ext4/super.c:7326
>  ext4_quotas_off fs/ext4/super.c:1195 [inline]
>  ext4_put_super+0xdf/0xd80 fs/ext4/super.c:1306
>  generic_shutdown_super+0x13d/0x2d0 fs/super.c:646
>  kill_block_super+0x44/0x90 fs/super.c:1725
>  ext4_kill_sb+0x68/0xb0 fs/ext4/super.c:7494
>  deactivate_locked_super+0xbc/0x130 fs/super.c:476
>  cleanup_mnt+0x437/0x4d0 fs/namespace.c:1312
>  task_work_run+0x1d9/0x270 kernel/task_work.c:233
>  resume_user_mode_work include/linux/resume_user_mode.h:50 [inline]
>  __exit_to_user_mode_loop kernel/entry/common.c:67 [inline]
>  exit_to_user_mode_loop+0xf3/0x4d0 kernel/entry/common.c:98
>  __exit_to_user_mode_prepare include/linux/irq-entry-common.h:207 [inline=
]
>  syscall_exit_to_user_mode_prepare include/linux/irq-entry-common.h:238 [=
inline]
>  syscall_exit_to_user_mode include/linux/entry-common.h:318 [inline]
>  do_syscall_64+0x33e/0xf80 arch/x86/entry/syscall_64.c:100
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7fd8d1b9e017
> Code: a2 c7 05 dc 06 25 00 00 00 00 00 eb 96 e8 e1 12 00 00 90 31 f6 e9 0=
9 00 00 00 66 0f 1f 84 00 00 00 00 00 b8 a6 00 00 00 0f 05 <48> 3d 00 f0 ff=
 ff 77 01 c3 48 c7 c2 e8 ff ff ff f7 d8 64 89 02 b8
> RSP: 002b:00007ffef04ebf88 EFLAGS: 00000246 ORIG_RAX: 00000000000000a6
> RAX: 0000000000000000 RBX: 00007fd8d1c32120 RCX: 00007fd8d1b9e017
> RDX: 0000000000000000 RSI: 0000000000000009 RDI: 00007ffef04ec040
> RBP: 00007ffef04ec040 R08: 00007ffef04ed040 R09: 00000000ffffffff
> R10: 0000000000000000 R11: 0000000000000246 R12: 00007ffef04ed0d0
> R13: 00007fd8d1c32120 R14: 0000000000014595 R15: 00007ffef04ed110
>  </TASK>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
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
> [aivazian.tigran@gmail.com brauner@kernel.org dsterba@suse.com hirofumi@m=
ail.parknet.co.jp jack@suse.cz linux-ext4@vger.kernel.org linux-fsdevel@vge=
r.kernel.org tytso@mit.edu]
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
-upstream-moderation/6a02309c.170a0220.7f9b3.0000.GAE%40google.com.
