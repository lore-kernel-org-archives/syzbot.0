Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9BCD2EFDBB
	for <syzbot@lists.linux.dev>; Wed, 29 Oct 2025 20:14:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761768856; cv=none; b=cwTuwB2O1g76U9fWqB90IqT69N2bDqJY6TRF4PwXDDdvg37VnCyFI8nuZyM3TQgwcQ1L5XgTeuo8CwI7XKJuJgNmhfu9RKGsZs0J+StVyZOLFqboDYOr74ob3mQq6Y075YTSsFVW+fSR0EbF3p/hTA2Z77iV2wTkirJIJRdcMw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761768856; c=relaxed/simple;
	bh=G+9/8jcp8AXP8mVZwtvzhJNv4mXeuYdzpFHVfthTi8k=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=dAuOi04hHhAF7XI6R5fYIRgAaAwYBqnv3jAW8CPqvo9wx40x30hJr6KjvGZzxTSEDpNwr7oJp0a7lVPkPR5W8BnBuSPBuqLpRVsqYG598FLCsITv9mSW6J6WRzCR4OSpEBXQRuNqsZA9QhxBBn9k7w7wn2vIb+T8415OD9EgRTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-430d4a4dec5so8981635ab.1
        for <syzbot@lists.linux.dev>; Wed, 29 Oct 2025 13:14:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761768854; x=1762373654;
        h=cc:to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6cm2VbLxcfPQVytuNpC4NSXtsDTrYo5sb+RcPuhKPXQ=;
        b=eV6rA3TThWDIXbs2oGL+FJnwPMQ5F4sLzka5WIpdlh2WhhdInVi5Sc5aLF51rPhefz
         +xKSXtwDWtu/2Wrf9acqWO1rykGMrR0yn29HGAbam2zXwZajcHc8SxIuBrrK7ojXdB5r
         7bhRZLEU5Dc6nKDalN/BNqOhLj3p+rx1ohGyL0nW6BhglAzDNoBksQEH35siUF8cqdNQ
         FlX3dOoigBs4TVopgzfklUzwcDlPJiymsqoU7CPRPEl9wKvlVxi5R875JYztr0Jpq38m
         0pD935E21KURfmg70FF1U4xO++10oyHHJUE/n0oaeVA9W78tcLhZmGzC3fFJ9ffm5f/m
         eiPA==
X-Gm-Message-State: AOJu0Yz2JJ/WS14cphYTHqMRbHcyFDkQfT2O0A56sR9Tf8hFX2JGni1K
	2CWzPbgGMcstkqQa1+t3sDks5E/N/W2R1QnAukSZyyAGTsUBoNy+oYmhKPw9GksEdDouKd9M7he
	GJlwGtmuTnsIZcH6z1605jWGlzNLqHUSCvFsiYcThJjRVU6fWe4O3JSzPqgU=
X-Google-Smtp-Source: AGHT+IEWJZh+Y45p40PCR/VH7Ok31D9hixltcruIiIJgQHt6yQmxs7g4wyGsu2WA5TR4qmqgW5zok1yhqEnw9smTPEld7BRxC0zD
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:308b:b0:430:b2e3:8fb with SMTP id
 e9e14a558f8ab-432f8fad6e3mr60458385ab.9.1761768854008; Wed, 29 Oct 2025
 13:14:14 -0700 (PDT)
Date: Wed, 29 Oct 2025 13:14:13 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69027595.050a0220.3344a1.0431.GAE@google.com>
Subject: [moderation/CI] Re: bpf: magic kernel functions
From: syzbot ci <syzbot+ci7b3ea35a8e8f336d@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v1] bpf: magic kernel functions
https://lore.kernel.org/all/20251029190113.3323406-1-ihor.solodrai@linux.dev
* [PATCH bpf-next v1 1/8] bpf: Add BTF_ID_LIST_END and BTF_ID_LIST_SIZE macros
* [PATCH bpf-next v1 2/8] bpf: Refactor btf_kfunc_id_set_contains
* [PATCH bpf-next v1 3/8] bpf: Support for kfuncs with KF_MAGIC_ARGS
* [PATCH bpf-next v1 4/8] bpf: Support __magic prog_aux arguments for kfuncs
* [PATCH bpf-next v1 5/8] bpf: Re-define bpf_wq_set_callback as magic kfunc
* [PATCH bpf-next v1 6/8] bpf,docs: Document KF_MAGIC_ARGS flag and __magic annotation
* [PATCH bpf-next v1 7/8] bpf: Re-define bpf_task_work_schedule_* kfuncs as magic
* [PATCH bpf-next v1 8/8] bpf: Re-define bpf_stream_vprintk as a magic kfunc

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/a0db24e6-4dc0-4e96-9ec7-a38b92e6c3db

***

kernel build error

tree:      bpf-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/bpf/bpf-next.git
base:      54c134f379ee2816f60130d44e0e386c261dff45
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/6a004c3f-8609-4657-8665-e36f93dc75e7/config

kernel/bpf/verifier.c:3280:1: error: invalid storage class specifier in function declarator
kernel/bpf/verifier.c:3280:12: error: parameter named 'magic_kfunc_by_impl' is missing
kernel/bpf/verifier.c:3280:49: error: expected ';' at end of declaration
kernel/bpf/verifier.c:3278:17: error: parameter 'magic_kfuncs' was not declared, defaults to 'int'; ISO C99 and later do not support implicit int [-Wimplicit-int]
kernel/bpf/verifier.c:3278:1: error: type specifier missing, defaults to 'int'; ISO C99 and later do not support implicit int [-Wimplicit-int]
kernel/bpf/verifier.c:3284:18: error: call to undeclared function 'BTF_ID_LIST_SIZE'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
kernel/bpf/verifier.c:3285:19: error: subscripted value is not an array, pointer, or vector
kernel/bpf/verifier.c:3285:26: error: use of undeclared identifier 'impl_func_id'
kernel/bpf/verifier.c:3286:23: error: subscripted value is not an array, pointer, or vector
kernel/bpf/verifier.c:3278:1: error: a function definition without a prototype is deprecated in all versions of C and is not supported in C23 [-Werror,-Wdeprecated-non-prototype]
kernel/bpf/verifier.c:3295:18: error: call to undeclared function 'BTF_ID_LIST_SIZE'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
kernel/bpf/verifier.c:3416:17: error: call to undeclared function 'magic_kfunc_by_impl'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
kernel/bpf/verifier.c:13752:17: error: call to undeclared function 'magic_kfunc_by_impl'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]

***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[acme@kernel.org alan.maguire@oracle.com andrii@kernel.org ast@kernel.org bpf@vger.kernel.org dwarves@vger.kernel.org eddyz87@gmail.com ihor.solodrai@linux.dev kernel-team@meta.com tj@kernel.org]

If the report looks fine to you, reply with:
#syz upstream

