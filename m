Received: from mail-ot1-f45.google.com (mail-ot1-f45.google.com [209.85.210.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF1AC317173
	for <syzbot@lists.linux.dev>; Sun, 11 Oct 2026 19:21:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791746506; cv=pass; b=i60Es2bJVgkWAlbOl5cnOcjraFK4Oq1Fvo69PXaBN+u2gJsz98Y0/fbWASjKf6eGYuaw7v2uzbo9izxSKjAMo1oaZRet68glhzywvDtqz5vxjdcB4r/HJzy28SSKbNzqFM51+kUTQnwQh9C2DqT+Yez9HtR3vibOqabHvwLjQ5Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791746506; c=relaxed/simple;
	bh=KAlF37wCgw4n6XVIKFzCKV1/s/GJ6v0sgOolpKd7Om8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jqFCFRasYhzDpgudU1kLZeBjg490xOHhLd8TDntbnR6xh2xkDs5KaeirlWM77IHJJmgi1LuQNqxEBpFO1EVXPHshKX9fOrzvpR1YPnHtBbLi759BkY4oRBRqjgdZtXUYGouIjqjqP+srdVZBsHKV0dC5QgvSvU5UpdprRa2VF2M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hKiY/3jR; arc=pass smtp.client-ip=209.85.210.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hKiY/3jR"
Received: by mail-ot1-f45.google.com with SMTP id 46e09a7af769-8249c775215so782806a34.3
        for <syzbot@lists.linux.dev>; Sun, 11 Oct 2026 12:21:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791746503; cv=none;
        d=google.com; s=arc-20260327;
        b=izjYAFJGMn6aR6/GUU1Pnu+LTLxRRhbNVsPmusO7EUPyEoJt7gpEuA+dx35X2ZpZI5
         bicb6v9jWek9/LFHoyEcx156a6ONkYpQZqd4kt63ZO67Tn0YLDTUFHR584LSM91LXPHq
         iZKqseJZhw7RWzIpKg8u0n3iGWRp/9usrxx7JlkgPOh+gs08rQt4wgufW9rufRSbfnQj
         CyxneUV2AA0F4aYMBvMYs0Rc8hkCedGC/71GM1DUWtLbkC3GBOdIJJ0wil3+1AtI/PXm
         Nxz0MD0XrH64mW7r1l83BB8YHJE7yvGfNfxiutK+BdZUGCPRZvqdilGRFYBmi1MXLvQ3
         AiKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=fndfjAhhuiMUTJhH3bx5m6HSONq/yHaDrqlr9EMW5I4=;
        fh=L1zacQe+7p/HD/RnB/UAE+uruQKwJ6WNwIOn6Jpud8E=;
        b=oMI6M9rD86KTPNfJTx3eSyVKCen3Uckr6wPk3w0EWNa7jx71Af4Rm72oYoqkbZIz9C
         t+ytUYj8XxTEpFqCyokJplw8w1xJXRroWngwZoly5jEFua7Jo+RQzNAm4rbrnXi/RB7A
         LQ6hSXm44rIBEP3LoKcrja0rM9ur1r/2eWRixmpiel5HPOCGi2etxJvHUuliMjAN4hIu
         DRx7DZ0Ju7Py6yWNUGd9k95wtQzRZKLloxQeJpBSMeoQUniMXrUUqfLWKlCH8WCz5fx0
         Eyb3Buzot6ZYOkX1YiBYyn8Qr/+vesr/2ngEbhc05IDMRNBAEi8yX7xbQLAZ7ewjqCdK
         tQHQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791746503; x=1792351303; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=fndfjAhhuiMUTJhH3bx5m6HSONq/yHaDrqlr9EMW5I4=;
        b=hKiY/3jRg9Mlxjo1gCoDtOZdhz2bh2aRPSzBOT3UTTRs3g7nBrCBzReyAhejnQe/fg
         3KuSp+CmWDForoKIjAy3MpQdRS6dlYIw/okPrwO5/Qa6Uzj4OX0fMOMFdrGsg5tqth0L
         pSf3w84gtXaJ0QClcys+9vr4KhXUVLTasI6FuB5B5oCPkumsw5G5KtK67fpFea7rJKSS
         Cak0RWhZXRNe2NHnBWSQNSnPNkb9krjsOLneXz2Umc0yVC8x5BqeM2TOEhgWeRGd6ZVk
         olwOrquVxHIUPwkLmpAU9QcrahXqsmpvHc4oBdcXpXk9rxPY2COgWEuT+dIAmV7lasqG
         fBiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791746503; x=1792351303;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=fndfjAhhuiMUTJhH3bx5m6HSONq/yHaDrqlr9EMW5I4=;
        b=XwbztCvoF0wVAx0hMdorMMwE3dr2excjmYc0Rq/3AcIkoUeTpGWa4Ol8uvI+4wAEja
         j3RdeosZJhebIqUc8X3nDfSZeVDqta2N/H7YvHvpmu+NQSEVSijNtOMv89Fu4LAVdQ4+
         Pu/sYZs5tLEUyaW29lr3QA9z9O1Oq4GzXgFkEklVDEZLxEh9WdxtpHX2ogMI1Hryu9pB
         QgQuMBvwZKmlXvZg73fcqiX/0a6RJgRXM4h9o9emOQXdWvxavKWKPb64Jk0792Bv7xLg
         EMGz3/N1K1NjkDCMDfqe95MB86OZ9MDQ03G+sqG1NDp/zHBwXjgI5JKM4cg7PH4ZrzDh
         Mxig==
X-Forwarded-Encrypted: i=1; AKwUvByH24++4a5BMKwUAYyQV7+ML/lAdTy0OIGWURb6cv78XJb8PwXlUo1YZwa+UBeGGY2brabjlX0=@lists.linux.dev
X-Gm-Message-State: AFq9FYJQrHXaZH8eU+KeM0v2q0DnxpbLVctqLvJgWoMqi5VhoLUoDkCg
	OcAoq9OsZHFfDygpfspxZuw+6+iHohKDg5SU+6gTYe3+wtJiscxuFJnBd79oeFyl0aWgtXuSQWM
	20X5dPXGI2yMU46yEQMEAvZEdWeQ2x4hvg3y7cjHw
X-Gm-Gg: AYBFou3vMaUWoF1/9Ms1dPuMpNtXmE7UUhnQDklQ/uc4QctK/AWsnFgHFnd07ivaNmu
	Gv4YLOfO4/d+6u18vzDL66Ltcnlz9mZUDWxfrXSScvIZsHuumK3B3zWmlPds3wfHuoixsK2hkX0
	WP+ocSYq1QawXeDtzg/HMq/izqxCQjs0vHKpMJ2R+HEDH7THMpJNtH9U318gWCVbsp14wPdMlIH
	z33fyNJGZtnaIGciNNYNsQJwsyVY/HP0RmguTbMuXelTOc3JVTxHYgX4bzRXF9tI40J15w+8x9d
	Ugz4kMT4ztv9IQrbWhfKsFV0VLiAMiT81qCKQto/qBiKejtWeGWLtyoGpopTwHMxi21BZDRjFx5
	7r3Hv+3+jRqoL/Kml5jQPX5nl//XPvD4V5y2Jg7l8GmynD8VQh0KWq9VKghIQ5v2VprRn4i40nw
	ga1YcJM2NkMwdJ9Ch+fEXJtriRYTk=
X-Received: by 2002:a05:6808:13c3:b0:4d6:93e2:5bc4 with SMTP id
 5614622812f47-50c59f38b43mr7798852b6e.64.1791746502148; Sun, 11 Oct 2026
 12:21:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <6acbc9a8.6d14cce4.2677ed.012d.GAE@google.com>
In-Reply-To: <6acbc9a8.6d14cce4.2677ed.012d.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Sun, 11 Oct 2026 21:21:30 +0200
X-Gm-Features: AclHuK8g1Tr6PZ_KO3tU7tyzXd75yRyP9S7YkpUQT8ftUJ65SpaoIQrU_mgaGEk
Message-ID: <CANp29Y5R92u2O9ssuY2CJqaJJb7e5tqL_LPtnzaXo-Bx2RDo-g@mail.gmail.com>
Subject: Re: [moderation/CI] Re: loop: Detect write requests that failed to
 wait for completion.
To: syzbot ci <syzbot+ciebc1a7ad3d6a80ae@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Sun, Oct 11, 2026 at 7:38=E2=80=AFPM syzbot ci
<syzbot+ciebc1a7ad3d6a80ae@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v3] loop: Detect write requests that failed to wait for completion.
> https://lore.kernel.org/all/cc2910d3-3113-44d4-94ef-0c8d365fac9c@I-love.S=
AKURA.ne.jp
> * [PATCH v3] loop: Detect write requests that failed to wait for completi=
on.
>
> and found the following issues:
> * BUG: found I/O issued by syz.NUM.NUM/NUM but loop0 is no longer bound.
> * BUG: found I/O issued by syz.NUM.NUM/NUM but loop2 is no longer bound.
>
> Full report is available here:
> https://ci.syzbot.org/series/d3a0b036-fd1e-44c6-8869-386ea1642385
>
> ***
>
> BUG: found I/O issued by syz.NUM.NUM/NUM but loop0 is no longer bound.
>
> tree:      axboe
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/axboe=
/linux.git
> base:      4da93acb4f2ed06640255ad98801d0f0c734ff07
> arch:      amd64
> compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~e=
xp1~20260613092250.77), Debian LLD 22.1.8
> config:    https://ci.syzbot.org/builds/a23afb97-88bb-4fba-8885-d3062b589=
0e2/config
> syz repro: https://ci.syzbot.org/findings/c9ad5ff9-784f-4528-805f-7971e03=
59600/syz_repro
>
> BUG: found I/O issued by syz.0.760/7647 but loop0 is no longer bound.
> Call Trace:
>      loop_queue_rq+0x232/0xc90 drivers/block/loop.c:1922
>      __blk_mq_issue_directly block/blk-mq.c:2708 [inline]
>      blk_mq_try_issue_directly+0x3f4/0x880 block/blk-mq.c:2768
>      blk_mq_submit_bio+0x21de/0x2bb0 block/blk-mq.c:3220
>      __submit_bio_noacct_mq block/blk-core.c:756 [inline]
>      submit_bio_noacct_nocheck+0x2f4/0xa40 block/blk-core.c:790
>      bh_submit fs/buffer.c:1146 [inline]
>      __bh_read fs/buffer.c:2943 [inline]
>      bh_readahead include/linux/buffer_head.h:437 [inline]
>      __breadahead+0x15c/0x1f0 fs/buffer.c:1359
>      nilfs_search_super_root+0x2be/0x1530 fs/nilfs2/recovery.c:891
>      load_nilfs+0x363/0xfb0 fs/nilfs2/the_nilfs.c:259
>      nilfs_fill_super+0x1a0/0x4e0 fs/nilfs2/super.c:1073
>      nilfs_get_tree+0x491/0x850 fs/nilfs2/super.c:1226
>      vfs_get_tree+0x92/0x2a0 fs/super.c:1932
>      fc_mount fs/namespace.c:1198 [inline]
>      do_new_mount_fc fs/namespace.c:3772 [inline]
>      do_new_mount+0x319/0xdc0 fs/namespace.c:3848
>      do_mount fs/namespace.c:4181 [inline]
>      __do_sys_mount fs/namespace.c:4397 [inline]
>      __se_sys_mount+0x31d/0x420 fs/namespace.c:4374
>      do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
>      do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
>      entry_SYSCALL_64_after_hwframe+0x77/0x7f
> BUG: found I/O issued by syz.0.760/7647 but loop0 is no longer bound.
> Call Trace:
>      loop_queue_rq+0x232/0xc90 drivers/block/loop.c:1922
>      __blk_mq_issue_directly block/blk-mq.c:2708 [inline]
>      blk_mq_try_issue_directly+0x3f4/0x880 block/blk-mq.c:2768
>      blk_mq_submit_bio+0x21de/0x2bb0 block/blk-mq.c:3220
>      __submit_bio_noacct_mq block/blk-core.c:756 [inline]
>      submit_bio_noacct_nocheck+0x2f4/0xa40 block/blk-core.c:790
>      bh_submit fs/buffer.c:1146 [inline]
>      __bh_read fs/buffer.c:2943 [inline]
>      bh_readahead include/linux/buffer_head.h:437 [inline]
>      __breadahead+0x15c/0x1f0 fs/buffer.c:1359
>      nilfs_search_super_root+0x2be/0x1530 fs/nilfs2/recovery.c:891
>      load_nilfs+0x363/0xfb0 fs/nilfs2/the_nilfs.c:259
>      nilfs_fill_super+0x1a0/0x4e0 fs/nilfs2/super.c:1073
>      nilfs_get_tree+0x491/0x850 fs/nilfs2/super.c:1226
>      vfs_get_tree+0x92/0x2a0 fs/super.c:1932
>      fc_mount fs/namespace.c:1198 [inline]
>      do_new_mount_fc fs/namespace.c:3772 [inline]
>      do_new_mount+0x319/0xdc0 fs/namespace.c:3848
>      do_mount fs/namespace.c:4181 [inline]
>      __do_sys_mount fs/namespace.c:4397 [inline]
>      __se_sys_mount+0x31d/0x420 fs/namespace.c:4374
>      do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
>      do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
>      entry_SYSCALL_64_after_hwframe+0x77/0x7f
>
>
> ***
>
> BUG: found I/O issued by syz.NUM.NUM/NUM but loop2 is no longer bound.
>
> tree:      axboe
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/axboe=
/linux.git
> base:      4da93acb4f2ed06640255ad98801d0f0c734ff07
> arch:      amd64
> compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~e=
xp1~20260613092250.77), Debian LLD 22.1.8
> config:    https://ci.syzbot.org/builds/a23afb97-88bb-4fba-8885-d3062b589=
0e2/config
> syz repro: https://ci.syzbot.org/findings/bad9ae98-7887-4209-8226-7e84bb0=
70faa/syz_repro
>
> BUG: found I/O issued by syz.2.866/7955 but loop2 is no longer bound.
> Call Trace:
>      loop_queue_rq+0x232/0xc90 drivers/block/loop.c:1922
>      __blk_mq_issue_directly block/blk-mq.c:2708 [inline]
>      blk_mq_try_issue_directly+0x3f4/0x880 block/blk-mq.c:2768
>      blk_mq_submit_bio+0x21de/0x2bb0 block/blk-mq.c:3220
>      __submit_bio_noacct_mq block/blk-core.c:756 [inline]
>      submit_bio_noacct_nocheck+0x2f4/0xa40 block/blk-core.c:790
>      bh_submit fs/buffer.c:1146 [inline]
>      __bh_read fs/buffer.c:2943 [inline]
>      bh_readahead include/linux/buffer_head.h:437 [inline]
>      __breadahead+0x15c/0x1f0 fs/buffer.c:1359
>      nilfs_search_super_root+0x2be/0x1530 fs/nilfs2/recovery.c:891
>      load_nilfs+0x363/0xfb0 fs/nilfs2/the_nilfs.c:259
>      nilfs_fill_super+0x1a0/0x4e0 fs/nilfs2/super.c:1073
>      nilfs_get_tree+0x491/0x850 fs/nilfs2/super.c:1226
>      vfs_get_tree+0x92/0x2a0 fs/super.c:1932
>      fc_mount fs/namespace.c:1198 [inline]
>      do_new_mount_fc fs/namespace.c:3772 [inline]
>      do_new_mount+0x319/0xdc0 fs/namespace.c:3848
>      do_mount fs/namespace.c:4181 [inline]
>      __do_sys_mount fs/namespace.c:4397 [inline]
>      __se_sys_mount+0x31d/0x420 fs/namespace.c:4374
>      do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
>      do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
>      entry_SYSCALL_64_after_hwframe+0x77/0x7f
> BUG: found I/O issued by syz.2.866/7955 but loop2 is no longer bound.
> Call Trace:
>      loop_queue_rq+0x232/0xc90 drivers/block/loop.c:1922
>      __blk_mq_issue_directly block/blk-mq.c:2708 [inline]
>      blk_mq_try_issue_directly+0x3f4/0x880 block/blk-mq.c:2768
>      blk_mq_submit_bio+0x21de/0x2bb0 block/blk-mq.c:3220
>      __submit_bio_noacct_mq block/blk-core.c:756 [inline]
>      submit_bio_noacct_nocheck+0x2f4/0xa40 block/blk-core.c:790
>      bh_submit fs/buffer.c:1146 [inline]
>      __bh_read fs/buffer.c:2943 [inline]
>      bh_readahead include/linux/buffer_head.h:437 [inline]
>      __breadahead+0x15c/0x1f0 fs/buffer.c:1359
>      nilfs_search_super_root+0x2be/0x1530 fs/nilfs2/recovery.c:891
>      load_nilfs+0x363/0xfb0 fs/nilfs2/the_nilfs.c:259
>      nilfs_fill_super+0x1a0/0x4e0 fs/nilfs2/super.c:1073
>      nilfs_get_tree+0x491/0x850 fs/nilfs2/super.c:1226
>      vfs_get_tree+0x92/0x2a0 fs/super.c:1932
>      fc_mount fs/namespace.c:1198 [inline]
>      do_new_mount_fc fs/namespace.c:3772 [inline]
>      do_new_mount+0x319/0xdc0 fs/namespace.c:3848
>      do_mount fs/namespace.c:4181 [inline]
>      __do_sys_mount fs/namespace.c:4397 [inline]
>      __se_sys_mount+0x31d/0x420 fs/namespace.c:4374
>      do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
>      do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
>      entry_SYSCALL_64_after_hwframe+0x77/0x7f
> BUG: found I/O issued by syz.2.866/7955 but loop2 is no longer bound.
> Call Trace:
>      loop_queue_rq+0x232/0xc90 drivers/block/loop.c:1922
>      __blk_mq_issue_directly block/blk-mq.c:2708 [inline]
>      blk_mq_try_issue_directly+0x3f4/0x880 block/blk-mq.c:2768
>      blk_mq_submit_bio+0x21de/0x2bb0 block/blk-mq.c:3220
>      __submit_bio_noacct_mq block/blk-core.c:756 [inline]
>      submit_bio_noacct_nocheck+0x2f4/0xa40 block/blk-core.c:790
>      bh_submit fs/buffer.c:1146 [inline]
>      __bh_read fs/buffer.c:2943 [inline]
>      bh_readahead include/linux/buffer_head.h:437 [inline]
>      __breadahead+0x15c/0x1f0 fs/buffer.c:1359
>      nilfs_search_super_root+0x2be/0x1530 fs/nilfs2/recovery.c:891
>      load_nilfs+0x363/0xfb0 fs/nilfs2/the_nilfs.c:259
>      nilfs_fill_super+0x1a0/0x4e0 fs/nilfs2/super.c:1073
>      nilfs_get_tree+0x491/0x850 fs/nilfs2/super.c:1226
>      vfs_get_tree+0x92/0x2a0 fs/super.c:1932
>      fc_mount fs/namespace.c:1198 [inline]
>      do_new_mount_fc fs/namespace.c:3772 [inline]
>      do_new_mount+0x319/0xdc0 fs/namespace.c:3848
>      do_mount fs/namespace.c:4181 [inline]
>      __do_sys_mount fs/namespace.c:4397 [inline]
>      __se_sys_mount+0x31d/0x420 fs/namespace.c:4374
>      do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
>      do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
>      entry_SYSCALL_64_after_hwframe+0x77/0x7f
> BUG: found I/O issued by syz.2.866/7955 but loop2 is no longer bound.
> Call Trace:
>      loop_queue_rq+0x232/0xc90 drivers/block/loop.c:1922
>      __blk_mq_issue_directly block/blk-mq.c:2708 [inline]
>      blk_mq_try_issue_directly+0x3f4/0x880 block/blk-mq.c:2768
>      blk_mq_submit_bio+0x21de/0x2bb0 block/blk-mq.c:3220
>      __submit_bio_noacct_mq block/blk-core.c:756 [inline]
>      submit_bio_noacct_nocheck+0x2f4/0xa40 block/blk-core.c:790
>      bh_submit fs/buffer.c:1146 [inline]
>      __bh_read fs/buffer.c:2943 [inline]
>      bh_readahead include/linux/buffer_head.h:437 [inline]
>      __breadahead+0x15c/0x1f0 fs/buffer.c:1359
>      nilfs_search_super_root+0x2be/0x1530 fs/nilfs2/recovery.c:891
>      load_nilfs+0x363/0xfb0 fs/nilfs2/the_nilfs.c:259
>      nilfs_fill_super+0x1a0/0x4e0 fs/nilfs2/super.c:1073
>      nilfs_get_tree+0x491/0x850 fs/nilfs2/super.c:1226
>      vfs_get_tree+0x92/0x2a0 fs/super.c:1932
>      fc_mount fs/namespace.c:1198 [inline]
>      do_new_mount_fc fs/namespace.c:3772 [inline]
>      do_new_mount+0x319/0xdc0 fs/namespace.c:3848
>      do_mount fs/namespace.c:4181 [inline]
>      __do_sys_mount fs/namespace.c:4397 [inline]
>      __se_sys_mount+0x31d/0x420 fs/namespace.c:4374
>      do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
>      do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
>      entry_SYSCALL_64_after_hwframe+0x77/0x7f
> BUG: found I/O issued by syz.2.866/7955 but loop2 is no longer bound.
> Call Trace:
>      loop_queue_rq+0x232/0xc90 drivers/block/loop.c:1922
>      __blk_mq_issue_directly block/blk-mq.c:2708 [inline]
>      blk_mq_try_issue_directly+0x3f4/0x880 block/blk-mq.c:2768
>      blk_mq_submit_bio+0x21de/0x2bb0 block/blk-mq.c:3220
>      __submit_bio_noacct_mq block/blk-core.c:756 [inline]
>      submit_bio_noacct_nocheck+0x2f4/0xa40 block/blk-core.c:790
>      bh_submit fs/buffer.c:1146 [inline]
>      __bh_read fs/buffer.c:2943 [inline]
>      bh_readahead include/linux/buffer_head.h:437 [inline]
>      __breadahead+0x15c/0x1f0 fs/buffer.c:1359
>      nilfs_search_super_root+0x2be/0x1530 fs/nilfs2/recovery.c:891
>      load_nilfs+0x363/0xfb0 fs/nilfs2/the_nilfs.c:259
>      nilfs_fill_super+0x1a0/0x4e0 fs/nilfs2/super.c:1073
>      nilfs_get_tree+0x491/0x850 fs/nilfs2/super.c:1226
>      vfs_get_tree+0x92/0x2a0 fs/super.c:1932
>      fc_mount fs/namespace.c:1198 [inline]
>      do_new_mount_fc fs/namespace.c:3772 [inline]
>      do_new_mount+0x319/0xdc0 fs/namespace.c:3848
>      do_mount fs/namespace.c:4181 [inline]
>      __do_sys_mount fs/namespace.c:4397 [inline]
>      __se_sys_mount+0x31d/0x420 fs/namespace.c:4374
>      do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
>      do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
>      entry_SYSCALL_64_after_hwframe+0x77/0x7f
> BUG: found I/O issued by syz.2.866/7955 but loop2 is no longer bound.
> Call Trace:
>      loop_queue_rq+0x232/0xc90 drivers/block/loop.c:1922
>      __blk_mq_issue_directly block/blk-mq.c:2708 [inline]
>      blk_mq_try_issue_directly+0x3f4/0x880 block/blk-mq.c:2768
>      blk_mq_submit_bio+0x21de/0x2bb0 block/blk-mq.c:3220
>      __submit_bio_noacct_mq block/blk-core.c:756 [inline]
>      submit_bio_noacct_nocheck+0x2f4/0xa40 block/blk-core.c:790
>      bh_submit fs/buffer.c:1146 [inline]
>      __bh_read fs/buffer.c:2943 [inline]
>      bh_readahead include/linux/buffer_head.h:437 [inline]
>      __breadahead+0x15c/0x1f0 fs/buffer.c:1359
>      nilfs_search_super_root+0x2be/0x1530 fs/nilfs2/recovery.c:891
>      load_nilfs+0x363/0xfb0 fs/nilfs2/the_nilfs.c:259
>      nilfs_fill_super+0x1a0/0x4e0 fs/nilfs2/super.c:1073
>      nilfs_get_tree+0x491/0x850 fs/nilfs2/super.c:1226
>      vfs_get_tree+0x92/0x2a0 fs/super.c:1932
>      fc_mount fs/namespace.c:1198 [inline]
>      do_new_mount_fc fs/namespace.c:3772 [inline]
>      do_new_mount+0x319/0xdc0 fs/namespace.c:3848
>      do_mount fs/namespace.c:4181 [inline]
>      __do_sys_mount fs/namespace.c:4397 [inline]
>      __se_sys_mount+0x31d/0x420 fs/namespace.c:4374
>      do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
>      do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
>      entry_SYSCALL_64_after_hwframe+0x77/0x7f
> BUG: found I/O issued by syz.2.866/7955 but loop2 is no longer bound.
> Call Trace:
>      loop_queue_rq+0x232/0xc90 drivers/block/loop.c:1922
>      __blk_mq_issue_directly block/blk-mq.c:2708 [inline]
>      blk_mq_try_issue_directly+0x3f4/0x880 block/blk-mq.c:2768
>      blk_mq_submit_bio+0x21de/0x2bb0 block/blk-mq.c:3220
>      __submit_bio_noacct_mq block/blk-core.c:756 [inline]
>      submit_bio_noacct_nocheck+0x2f4/0xa40 block/blk-core.c:790
>      bh_submit fs/buffer.c:1146 [inline]
>      __bh_read fs/buffer.c:2943 [inline]
>      bh_readahead include/linux/buffer_head.h:437 [inline]
>      __breadahead+0x15c/0x1f0 fs/buffer.c:1359
>      nilfs_search_super_root+0x2be/0x1530 fs/nilfs2/recovery.c:891
>      load_nilfs+0x363/0xfb0 fs/nilfs2/the_nilfs.c:259
>      nilfs_fill_super+0x1a0/0x4e0 fs/nilfs2/super.c:1073
>      nilfs_get_tree+0x491/0x850 fs/nilfs2/super.c:1226
>      vfs_get_tree+0x92/0x2a0 fs/super.c:1932
>      fc_mount fs/namespace.c:1198 [inline]
>      do_new_mount_fc fs/namespace.c:3772 [inline]
>      do_new_mount+0x319/0xdc0 fs/namespace.c:3848
>      do_mount fs/namespace.c:4181 [inline]
>      __do_sys_mount fs/namespace.c:4397 [inline]
>      __se_sys_mount+0x31d/0x420 fs/namespace.c:4374
>      do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
>      do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
>      entry_SYSCALL_64_after_hwframe+0x77/0x7f
> BUG: found I/O issued by syz.2.866/7955 but loop2 is no longer bound.
> Call Trace:
>      loop_queue_rq+0x232/0xc90 drivers/block/loop.c:1922
>      __blk_mq_issue_directly block/blk-mq.c:2708 [inline]
>      blk_mq_try_issue_directly+0x3f4/0x880 block/blk-mq.c:2768
>      blk_mq_submit_bio+0x21de/0x2bb0 block/blk-mq.c:3220
>      __submit_bio_noacct_mq block/blk-core.c:756 [inline]
>      submit_bio_noacct_nocheck+0x2f4/0xa40 block/blk-core.c:790
>      bh_submit fs/buffer.c:1146 [inline]
>      __bh_read fs/buffer.c:2943 [inline]
>      bh_readahead include/linux/buffer_head.h:437 [inline]
>      __breadahead+0x15c/0x1f0 fs/buffer.c:1359
>      nilfs_search_super_root+0x2be/0x1530 fs/nilfs2/recovery.c:891
>      load_nilfs+0x363/0xfb0 fs/nilfs2/the_nilfs.c:259
>      nilfs_fill_super+0x1a0/0x4e0 fs/nilfs2/super.c:1073
>      nilfs_get_tree+0x491/0x850 fs/nilfs2/super.c:1226
>      vfs_get_tree+0x92/0x2a0 fs/super.c:1932
>      fc_mount fs/namespace.c:1198 [inline]
>      do_new_mount_fc fs/namespace.c:3772 [inline]
>      do_new_mount+0x319/0xdc0 fs/namespace.c:3848
>      do_mount fs/namespace.c:4181 [inline]
>      __do_sys_mount fs/namespace.c:4397 [inline]
>      __se_sys_mount+0x31d/0x420 fs/namespace.c:4374
>      do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
>      do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
>      entry_SYSCALL_64_after_hwframe+0x77/0x7f
> BUG: found I/O issued by syz.2.866/7955 but loop2 is no longer bound.
> Call Trace:
>      loop_queue_rq+0x232/0xc90 drivers/block/loop.c:1922
>      __blk_mq_issue_directly block/blk-mq.c:2708 [inline]
>      blk_mq_try_issue_directly+0x3f4/0x880 block/blk-mq.c:2768
>      blk_mq_submit_bio+0x21de/0x2bb0 block/blk-mq.c:3220
>      __submit_bio_noacct_mq block/blk-core.c:756 [inline]
>      submit_bio_noacct_nocheck+0x2f4/0xa40 block/blk-core.c:790
>      bh_submit fs/buffer.c:1146 [inline]
>      __bh_read fs/buffer.c:2943 [inline]
>      bh_readahead include/linux/buffer_head.h:437 [inline]
>      __breadahead+0x15c/0x1f0 fs/buffer.c:1359
>      nilfs_search_super_root+0x2be/0x1530 fs/nilfs2/recovery.c:891
>      load_nilfs+0x363/0xfb0 fs/nilfs2/the_nilfs.c:259
>      nilfs_fill_super+0x1a0/0x4e0 fs/nilfs2/super.c:1073
>      nilfs_get_tree+0x491/0x850 fs/nilfs2/super.c:1226
>      vfs_get_tree+0x92/0x2a0 fs/super.c:1932
>      fc_mount fs/namespace.c:1198 [inline]
>      do_new_mount_fc fs/namespace.c:3772 [inline]
>      do_new_mount+0x319/0xdc0 fs/namespace.c:3848
>      do_mount fs/namespace.c:4181 [inline]
>      __do_sys_mount fs/namespace.c:4397 [inline]
>      __se_sys_mount+0x31d/0x420 fs/namespace.c:4374
>      do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
>      do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
>      entry_SYSCALL_64_after_hwframe+0x77/0x7f
> BUG: found I/O issued by syz.2.866/7955 but loop2 is no longer bound.
> Call Trace:
>      loop_queue_rq+0x232/0xc90 drivers/block/loop.c:1922
>      __blk_mq_issue_directly block/blk-mq.c:2708 [inline]
>      blk_mq_try_issue_directly+0x3f4/0x880 block/blk-mq.c:2768
>      blk_mq_submit_bio+0x21de/0x2bb0 block/blk-mq.c:3220
>      __submit_bio_noacct_mq block/blk-core.c:756 [inline]
>      submit_bio_noacct_nocheck+0x2f4/0xa40 block/blk-core.c:790
>      bh_submit fs/buffer.c:1146 [inline]
>      __bh_read fs/buffer.c:2943 [inline]
>      bh_readahead include/linux/buffer_head.h:437 [inline]
>      __breadahead+0x15c/0x1f0 fs/buffer.c:1359
>      nilfs_search_super_root+0x2be/0x1530 fs/nilfs2/recovery.c:891
>      load_nilfs+0x363/0xfb0 fs/nilfs2/the_nilfs.c:259
>      nilfs_fill_super+0x1a0/0x4e0 fs/nilfs2/super.c:1073
>      nilfs_get_tree+0x491/0x850 fs/nilfs2/super.c:1226
>      vfs_get_tree+0x92/0x2a0 fs/super.c:1932
>      fc_mount fs/namespace.c:1198 [inline]
>      do_new_mount_fc fs/namespace.c:3772 [inline]
>      do_new_mount+0x319/0xdc0 fs/namespace.c:3848
>      do_mount fs/namespace.c:4181 [inline]
>      __do_sys_mount fs/namespace.c:4397 [inline]
>      __se_sys_mount+0x31d/0x420 fs/namespace.c:4374
>      do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
>      do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
>      entry_SYSCALL_64_after_hwframe+0x77/0x7f
> BUG: found I/O issued by syz.2.866/7955 but loop2 is no longer bound.
> Call Trace:
>      loop_queue_rq+0x232/0xc90 drivers/block/loop.c:1922
>      __blk_mq_issue_directly block/blk-mq.c:2708 [inline]
>      blk_mq_try_issue_directly+0x3f4/0x880 block/blk-mq.c:2768
>      blk_mq_submit_bio+0x21de/0x2bb0 block/blk-mq.c:3220
>      __submit_bio_noacct_mq block/blk-core.c:756 [inline]
>      submit_bio_noacct_nocheck+0x2f4/0xa40 block/blk-core.c:790
>      bh_submit fs/buffer.c:1146 [inline]
>      __bh_read fs/buffer.c:2943 [inline]
>      bh_readahead include/linux/buffer_head.h:437 [inline]
>      __breadahead+0x15c/0x1f0 fs/buffer.c:1359
>      nilfs_search_super_root+0x2be/0x1530 fs/nilfs2/recovery.c:891
>      load_nilfs+0x363/0xfb0 fs/nilfs2/the_nilfs.c:259
>      nilfs_fill_super+0x1a0/0x4e0 fs/nilfs2/super.c:1073
>      nilfs_get_tree+0x491/0x850 fs/nilfs2/super.c:1226
>      vfs_get_tree+0x92/0x2a0 fs/super.c:1932
>      fc_mount fs/namespace.c:1198 [inline]
>      do_new_mount_fc fs/namespace.c:3772 [inline]
>      do_new_mount+0x319/0xdc0 fs/namespace.c:3848
>      do_mount fs/namespace.c:4181 [inline]
>      __do_sys_mount fs/namespace.c:4397 [inline]
>      __se_sys_mount+0x31d/0x420 fs/namespace.c:4374
>      do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
>      do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
>      entry_SYSCALL_64_after_hwframe+0x77/0x7f
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
> To test a fix for this bug, please reply with `#syz test`
> (on a separate line) and attach the patch to the email.
>
> Notes:
> - The patch will be applied on top of the tested series (as an
>   incremental fix).
> - To test a new version of the whole series, please send it directly
>   to syzbot@lists.linux.dev.
> - Arguments like custom git repos and branches are not supported.
>
> The email will later be sent to:
> [axboe@kernel.dk bvanassche@acm.org eadavis@qq.com hch@lst.de jfs-discuss=
ion@lists.sourceforge.net linux-block@vger.kernel.org nilay@linux.ibm.com p=
enguin-kernel@i-love.sakura.ne.jp shaggy@kernel.org]
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
-upstream-moderation/6acbc9a8.6d14cce4.2677ed.012d.GAE%40google.com.
