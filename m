Received: from mail-ot1-f72.google.com (mail-ot1-f72.google.com [209.85.210.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2C5B221DB6
	for <syzbot@lists.linux.dev>; Wed,  7 Jan 2026 23:45:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767829545; cv=none; b=XopA4Jqy/vDfDgLYhdj7Iptt8ilT5ylqX0x0XHcFe5EtbKz/QYRfxKjtRG65IjwmYUCy7ktoUngTVaxdR50uv7qYVtU7F8W1u3lUwQmGv1KJTMfEmrfHmInDg1DXNh4YGT7WnYikwIpiyK9UeNwG6RfD34Xx5lrupioaFfvl3+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767829545; c=relaxed/simple;
	bh=t+ao9UPrlci4x5UYA3NVBnkZ6KxH10OUKAhFNsCYZ/s=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=bzW0Qae5r2v0tQ3NdZattTCtr85aUk3fyyH9InoBWqH7BHlAGtay44u/RSfMTs6yqopm0fHO6Oc0hoG6NGZHcHO03d8oDd/lMD77tIMGe2jNtkJmen+5SMVLxKYPPy9MCdrzrqJsvdFhCjdkXefQZRFCyGRD0MRtOXl9qFFLYww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.210.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f72.google.com with SMTP id 46e09a7af769-7c70930bdf4so7330189a34.2
        for <syzbot@lists.linux.dev>; Wed, 07 Jan 2026 15:45:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767829542; x=1768434342;
        h=cc:to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fgxljMrR2i3eU0vLmn2rIAZQ2GiZXWn/+Nx64S/glEs=;
        b=SjKp2rdogh5XfyAB7UjVe2SPX8P2tSot/rzW+JbCTgwOInPuH2N7Ev0uAG2yv91HS4
         fJD7RGjjSe1tJz5LbHpjdSd87nvL5pWPZRO88vT5Rn/nuzz3w1SjLJ+g9tAvNB5Dz00O
         B3f5d8Ch+BJqwylFUuYus7AV1JX4MIbUOKw7mb5JLUj3j7ux8z2X74fWW6pCftAik5vm
         keZ/TiIWLpCSIrQQ9UAOiBVQBeX5WJv65RBxypDKRjkUv14ALmJz8FD27ERtFj0CCk43
         wWprySrg1hBR6Yh1NKZHLEs/+a+OqMrJ5DAXJssDhz2skErQlt/gMMHtDwG6nst2XS5M
         Lk4g==
X-Gm-Message-State: AOJu0YwieOvynicOxij/LWnqEaow8YBdE9WD3Utv1FM5gTxFEpM7SlyY
	Sy6ps9MQbSBtJRv+nkxPsumhamqpElTjrelb1CHXXT++IyPll6TVXQSb1S8tfEZpAVrJ0RbhgEb
	EbPN2GsdFFvcpx1kg2VSSIjFNWNwVnvcsx2XwJNbBzTzhVpct11NjgWouYp4=
X-Google-Smtp-Source: AGHT+IGNQvyh2VC1MjjpvguuEn+GGxIz+PsVxLYOCrZypK0VIkfQhNo96tzj5S+lTqITlBwDx1VOYPokzo0opjYSxNDa347qsdYd
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:1c91:b0:659:9a49:9071 with SMTP id
 006d021491bc7-65f54f6be01mr1768244eaf.60.1767829541847; Wed, 07 Jan 2026
 15:45:41 -0800 (PST)
Date: Wed, 07 Jan 2026 15:45:41 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <695ef025.050a0220.1c677c.0385.GAE@google.com>
Subject: [moderation/CI] Re: bpf: Avoid locks in bpf_timer and bpf_wq
From: syzbot ci <syzbot+ci4f7e07ad5d3fa724@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v3] bpf: Avoid locks in bpf_timer and bpf_wq
https://lore.kernel.org/all/20260107-timer_nolock-v3-0-740d3ec3e5f9@meta.com
* [PATCH RFC v3 01/10] bpf: Refactor __bpf_async_set_callback()
* [PATCH RFC v3 02/10] bpf: Factor out timer deletion helper
* [PATCH RFC v3 03/10] bpf: Simplify bpf_timer_cancel()
* [PATCH RFC v3 04/10] bpf: Add lock-free cell for NMI-safe async operations
* [PATCH RFC v3 05/10] bpf: Enable bpf timer and workqueue use in NMI
* [PATCH RFC v3 06/10] bpf: Add verifier support for bpf_timer argument in kfuncs
* [PATCH RFC v3 07/10] bpf: Introduce bpf_timer_cancel_async() kfunc
* [PATCH RFC v3 08/10] selftests/bpf: Refactor timer selftests
* [PATCH RFC v3 09/10] selftests/bpf: Add stress test for timer async cancel
* [PATCH RFC v3 10/10] selftests/bpf: Verify bpf_timer_cancel_async works

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/595c48b9-bc4e-4ede-847d-8f2d847f2dcb

***

kernel build error

tree:      bpf-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/bpf/bpf-next.git
base:      a069190b590e108223cd841a1c2d0bfb92230ecc
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251202083448+f68f64eb8130-1~exp1~20251202083504.46), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/429abbbb-1b09-420d-ada7-16187822d5b4/config

kernel/bpf/helpers.c:32:10: error: 'mpmc_cell.h' file not found with <angled> include; use "quotes" instead

***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[andrii@kernel.org ast@kernel.org bpf@vger.kernel.org daniel@iogearbox.net eddyz87@gmail.com kafai@meta.com kernel-team@meta.com memxor@gmail.com mykyta.yatsenko5@gmail.com yatsenko@meta.com]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

