Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 880D83054FD
	for <syzbot@lists.linux.dev>; Fri, 14 Nov 2025 10:32:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763116356; cv=none; b=ustbE27Lsew+7xlFNUm9XluUCjnfI1FiSuWsKHVtdCfZ1uu3oWZMIV7XN0JPSCiAIzJa9hs76Bmcl6FJAWDCcM0dj8BUIvUgduSXY3dAY63liaffuxDyYE+b/C8HMr/wV8en72jdtqrkTDr3Tv/eQb1GqYaeurnFshSWzp95Plo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763116356; c=relaxed/simple;
	bh=IOvLQz1ZNikUU4kObHi7ATk2ZrDL1S6wwp4l3YgnzFY=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=YOgy1pvP5CZ6CFeYwwW7DrlR5oX/kFcyLtXvqiQX0jpVfAM3eV5eyE9pFYjdgbYujNKLBOTQuZ0fk8uX/37jp074cfPmB7mWlA5Fc3jjI+DgHtXImavQgys8WiDzIaoFgiCvyitAqWv//ZNBa0RMHuGm+YaB+XKh/Jpjzw5bR7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-43323ffc26bso17602565ab.0
        for <syzbot@lists.linux.dev>; Fri, 14 Nov 2025 02:32:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763116353; x=1763721153;
        h=content-transfer-encoding:cc:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mYiOQ76cfwTn3MreYz5box8VS3UKmJBhX2lToEjQjTw=;
        b=Txpjz1lgUPPzmfkyCdy85NA0+hNkH6HwIj/6Y1MoiW5RvUZdSgoPHoUvBX51U7W4Wq
         zseNzs1x+a6vhDZ+tX/pvHCTNFHya+0VOYbyF6CQU8VQtdL3vnjMpXm59QhZf4sec3No
         m7rNnAQ93tUt917c7fd2vZYC1CCkTdnvxE0tZs98vI6FYWuvNxwmUsTpayY0mwefoKts
         x9nduhBAFTodYKzsUbfFJIbog2XZl7jo6Qh0t9KXng0oYSn9UsCbFed1GwFRwSQJbq6B
         IKtZJkeuazTI8eatGNn/u5W5fcY77K7wp9PIBXhKa1ya9dSywEjJDiuNrTAsBi1yrx/H
         H1ug==
X-Gm-Message-State: AOJu0Yy1/uc3RZEU2IvqEOg6833UUvXPsHXIwUo1Xsd7t1ir7bZS1Qy6
	Eq8e4F1MLb/JKknRfwLjsuTWW1WgyqzO+qq/PVYZ3lQATU3aFntrucUMIGgfo8LktVWVbb9wSTM
	XJaxtDc5rpVxPzyqf+DWFmBeOhmBzTuIyiAI6MC8X+XtgVvM08K3d+a0vmis=
X-Google-Smtp-Source: AGHT+IGgIf8JMbcB1mySb2Zx2isYYpYdhnZ0ug+iDXOY8jt6GiZ4Vb8hnlZ39MtIohT6N9TozJIisdzcgLCYQ98eeywJEixqdQKY
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1563:b0:433:3035:7426 with SMTP id
 e9e14a558f8ab-4348c93b211mr38960255ab.16.1763116352762; Fri, 14 Nov 2025
 02:32:32 -0800 (PST)
Date: Fri, 14 Nov 2025 02:32:32 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69170540.a70a0220.3124cb.004b.GAE@google.com>
Subject: [moderation/CI] Re: bpf trampoline support "jmp" mode
From: syzbot ci <syzbot+ci39ad38d3bb2c360c@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v1] bpf trampoline support "jmp" mode
https://lore.kernel.org/all/20251114092450.172024-1-dongml2@chinatelecom.cn
* [PATCH RFC bpf-next 1/7] ftrace: introduce FTRACE_OPS_FL_JMP
* [PATCH RFC bpf-next 2/7] x86/ftrace: implement DYNAMIC_FTRACE_WITH_JMP
* [PATCH RFC bpf-next 3/7] bpf: fix the usage of BPF_TRAMP_F_SKIP_FRAME
* [PATCH RFC bpf-next 4/7] bpf,x86: adjust the "jmp" mode for bpf trampolin=
e
* [PATCH RFC bpf-next 5/7] bpf: introduce bpf_arch_text_poke_type
* [PATCH RFC bpf-next 6/7] bpf,x86: implement bpf_arch_text_poke_type for x=
86_64
* [PATCH RFC bpf-next 7/7] bpf: implement "jmp" mode for trampoline

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/94b38701-bd30-4339-be30-e395e6237f5b

***

kernel build error

tree:      bpf-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/bpf/bpf=
-next.git
base:      026bcf9c286c42aacc34359a18aebcc1787f12d2
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp=
1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/c564f88b-ade0-465f-87ea-bb953779c1d=
e/config

kernel/bpf/trampoline.c:499:11: error: incomplete definition of type 'struc=
t ftrace_ops'
kernel/bpf/trampoline.c:499:22: error: use of undeclared identifier 'FTRACE=
_OPS_FL_JMP'
kernel/bpf/trampoline.c:501:11: error: incomplete definition of type 'struc=
t ftrace_ops'
kernel/bpf/trampoline.c:501:23: error: use of undeclared identifier 'FTRACE=
_OPS_FL_JMP'

***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[andrii@kernel.org ast@kernel.org bpf@vger.kernel.org daniel@iogearbox.net =
eddyz87@gmail.com haoluo@google.com john.fastabend@gmail.com jolsa@kernel.o=
rg kpsingh@kernel.org linux-kernel@vger.kernel.org linux-trace-kernel@vger.=
kernel.org mark.rutland@arm.com martin.lau@linux.dev mathieu.desnoyers@effi=
cios.com menglong8.dong@gmail.com mhiramat@kernel.org rostedt@goodmis.org s=
df@fomichev.me song@kernel.org yonghong.song@linux.dev]

If the report looks fine to you, reply with:
#syz upstream

