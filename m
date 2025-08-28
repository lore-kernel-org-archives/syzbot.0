Received: from mail-io1-f71.google.com (mail-io1-f71.google.com [209.85.166.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63DAB28BABB
	for <syzbot@lists.linux.dev>; Thu, 28 Aug 2025 09:47:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756374428; cv=none; b=AUn8PWeiZljIDBiNT64HMJZVHff3h3fi82I/NEc6VqulcPkQXpdXuGT3vB4Q7b+07SKFHOORrXLevEF51SKDnD1Hq3fucCvWumBf/hmqZ+gJCmq8EiXeKEmvKj7EbYsu5pW3L4Fa4rW8X3/vGQ3wAqL4MisF8K/7SwDGFqF4ZyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756374428; c=relaxed/simple;
	bh=MSLaMs3rAa+prGfPmlV1WWXXnC993y/fQtNGUWuqhLI=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=ACMnvi9sSH8eQE/lXAk/1bic1Ry332Rbnw6pE63ikbfuLsZdazpf43vwPT6Cn52R26+/RbofZHfGxeTTzvbhn3g3iamkYbKM4716ottFNrKLozPAzm0Yi5Ub97SAC4jYxWzJWlDCpV3KeTBHzEubtXyzo3tunqVcjcXaSDa81kk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-88428cc6d2fso241917539f.1
        for <syzbot@lists.linux.dev>; Thu, 28 Aug 2025 02:47:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756374426; x=1756979226;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gmLL3Yors61Iq+sDMZvn9f+Icd5Wdo+SAXBhmo6lSbU=;
        b=ePkhQ6LOX7beLh7Lyy9QNv6ndnT0AmubSG4kJoLcJmcA1stkyruMYy4Wc/R3cil3YB
         yLk/L35mD3H9Os9yWKGaCmkKrUkPAdrAgzRwglpZ7tBpU3nExEECrr4gGYOOEjfzj07C
         u4Y7jSQSZNyiMiT75CWoqOfaZvJ6VA8xFx9e15SICESQDGvXiHm4ST4bzTUID54wMIxJ
         d1dtsoaAeLYOEHVMpBk48m4AnuDZ3A2hFjYCVmsJWezdbv4A19uzIhdGqvLsWGXrlmGt
         CROoIsCxDL7mt+qbOqL+3iA/djC2wxBPLQgalD46hzZjML5JBOwbLatQ7VKiC7+OexRo
         /x8w==
X-Gm-Message-State: AOJu0Ywr+o2UC8Q/qUPSuneeEevbFI03ALjZgqs76UZ+LuWzyJZyPOY6
	w3CzPRa3D7ajFsQl4YBIxMuUbMgLEGM1WmeQ+002KzOv/hMnqcrSzjpfH74Vjdv3BkqaeBQqgGV
	u9grqnGzOJzWJzjCstMT+m5a2W1enTxU83cHfHwNgDc/loHnTHzKDQDd8f7M=
X-Google-Smtp-Source: AGHT+IFmtkVHPGY5fLLeWN31O6o6YPd0eaLQh58jPo7hoDlIZOdtl0ZFb/x/ObUbYprxjK5wjsiCRyA45J3YhpVFU+n4D5vKtMMq
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:160a:b0:3ed:d368:48b0 with SMTP id
 e9e14a558f8ab-3ef08858acamr113953225ab.0.1756374426372; Thu, 28 Aug 2025
 02:47:06 -0700 (PDT)
Date: Thu, 28 Aug 2025 02:47:06 -0700
In-Reply-To: <20250828060354.57846-1-menglong.dong@linux.dev>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68b0259a.050a0220.8762d.0008.GAE@google.com>
Subject: [syzbot ci] Re: sched: make migrate_enable/migrate_disable inline
From: syzbot ci <syzbot+ci553dbf0055ebca13@syzkaller.appspotmail.com>
To: andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org, bsegall@google.com, 
	daniel@iogearbox.net, dietmar.eggemann@arm.com, eddyz87@gmail.com, 
	haoluo@google.com, jani.nikula@intel.com, john.fastabend@gmail.com, 
	jolsa@kernel.org, juri.lelli@redhat.com, kpsingh@kernel.org, 
	linux-kernel@vger.kernel.org, martin.lau@linux.dev, menglong.dong@linux.dev, 
	mgorman@suse.de, mingo@redhat.com, peterz@infradead.org, rostedt@goodmis.org, 
	sdf@fomichev.me, simona.vetter@ffwll.ch, song@kernel.org, tzimmermann@suse.de, 
	vincent.guittot@linaro.org, vschneid@redhat.com, yonghong.song@linux.dev
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v4] sched: make migrate_enable/migrate_disable inline
https://lore.kernel.org/all/20250828060354.57846-1-menglong.dong@linux.dev
* [PATCH v4 1/3] arch: add the macro COMPILE_OFFSETS to all the asm-offsets.c
* [PATCH v4 2/3] sched: make migrate_enable/migrate_disable inline
* [PATCH v4 3/3] sched: fix some typos in include/linux/preempt.h

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/aac2d563-711a-4b4b-89c3-7365b1c03190

***

kernel build error

tree:      bpf-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/bpf/bpf-next.git
base:      d3abefe897408718799ae3bd06295b89b870a38e
arch:      amd64
compiler:  Debian clang version 20.1.7 (++20250616065708+6146a88f6049-1~exp1~20250616065826.132), Debian LLD 20.1.7
config:    https://ci.syzbot.org/builds/bb1748d9-0b48-4894-b30e-ea91020f1c78/config

./include/linux/rcupdate.h:968:3: error: call to undeclared function 'migrate_disable'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
./include/linux/rcupdate.h:976:3: error: call to undeclared function 'migrate_enable'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
./include/linux/sched.h:2402:20: error: static declaration of 'migrate_disable' follows non-static declaration
./include/linux/sched.h:2407:20: error: static declaration of 'migrate_enable' follows non-static declaration

***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.
