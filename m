Received: from mail-oa1-f72.google.com (mail-oa1-f72.google.com [209.85.160.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3923F343892
	for <syzbot@lists.linux.dev>; Tue, 19 May 2026 19:05:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779217517; cv=none; b=u9AwFwhTinx3EF4EeRzqAVqXhTjEYJQB6yr6zpxE2eL0vJCskFhi6AXGUuQe/Fww1CxqKKSjvTUd4EdiLThwoVHwRXwftTA4cpiQCyacWFs4Pfzn79oy+YupskWNped3TGsUoeo+7ivQZ4qn9cpNWEbiuD3Ua4MVt0gX01X9lsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779217517; c=relaxed/simple;
	bh=Ducp9V5dy5GDYxqBMlX3Dcn4P3x0psk58+D+7yg207s=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=uIK8oUNtZVOdeSV/PB8me+OEjPgoNF1Fio421P/EEcFpe6GxWZkmk4M3cyH67ICV4WZch1ZGmlm4gLassIr55P5WAvTjxdxgqhFbZHan07RwmVu1sJ6BHVFm2huwHfx6driJHY4NnqW+dsQFx3H5iUeCsCmuBP0ym8sQEUIEiUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.160.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oa1-f72.google.com with SMTP id 586e51a60fabf-43a3e6ebe0cso10036098fac.0
        for <syzbot@lists.linux.dev>; Tue, 19 May 2026 12:05:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779217515; x=1779822315;
        h=content-transfer-encoding:cc:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ReAem7h7y346RtXvc996VxNaVfFZ9vbk5MxlP99Ebmw=;
        b=FQ8iiN6KeKS6MHfmUCkwGcKkDyGib1cUcA5P5lsOrbW8LlbfhQSpXVAflBOTpg8cpm
         SS9ObPpzPyS06ESAk2sKJVIEs0YZDHIKaIR9YnkAYneKk1yi2y2on88A2pyBG9/uGm0F
         YiQwt32AZ225RtngO3nN67ATM2AeXK1fEHPJKtqLTOwFBSBjHX07F363lktyoXc6vpxp
         Q52PsdHfxS0pr3T2ahfZYXqw1A0ZNhLy70DE9+osutzfuO9yEN4CBG02Z+ZnmsYu2ZFW
         d+7w3toY502uLtahdFp/W7lXBhsHv7hMwVVf2A8s7J1vDujjh/hfuiISsfeOvr3nD0pd
         po2Q==
X-Gm-Message-State: AOJu0Yw4bjw/V4yTAe32ImYLARtGDUS3TqcNCHsPeJqq1a5lBv0cHq1M
	ElmwtjNqdZbe5lGyfI9kbcYjYL1BUa5dn6VthgfizFj/bAvP3Y26MERf3JkVbwWZsnpebtgnfKK
	Q0X9VfbbjEXjrLtYPkGbsQ/iX52MWZl1UDrJ6Yily8dHrOqbBsk8bFtArboY=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:2918:b0:696:248f:809e with SMTP id
 006d021491bc7-69c9458ab1dmr12923873eaf.47.1779217515215; Tue, 19 May 2026
 12:05:15 -0700 (PDT)
Date: Tue, 19 May 2026 12:05:15 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a0cb46b.170a0220.1f6c2d.0002.GAE@google.com>
Subject: [moderation/CI] Re: tracing/eprobes: Allow use of BTF names to
 dereference pointers
From: syzbot ci <syzbot+ci13eeff92c06ff596@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v5] tracing/eprobes: Allow use of BTF names to dereference pointers
https://lore.kernel.org/all/20260519130144.40e71a00@fedora
* [PATCH v5] tracing/eprobes: Allow use of BTF names to dereference pointer=
s

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/f81b9fe9-8c22-470c-b845-8bd6b44da760

***

kernel build error

tree:      bpf-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/bpf/bpf=
-next.git
base:      523d2f42b406f5be2989f436b03eacebf3679835
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp=
1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/6f3b7bf4-5584-4add-ad1d-2881c45abb7=
5/config

kernel/trace/trace_probe.c:1035:7: error: call to undeclared function 'pars=
e_trace_event'; ISO C99 and later do not support implicit function declarat=
ions [-Wimplicit-function-declaration]
kernel/trace/trace_probe.c:1803:20: error: call to undeclared function 'ctx=
_btf'; ISO C99 and later do not support implicit function declarations [-Wi=
mplicit-function-declaration]
kernel/trace/trace_probe.c:1803:14: error: incompatible integer to pointer =
conversion initializing 'struct btf *' with an expression of type 'int' [-W=
int-conversion]

***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

To test a patch for this bug, please reply with `#syz test`
(should be on a separate line).

The patch should be attached to the email.
Note: arguments like custom git repos and branches are not supported.

The email will later be sent to:
[akpm@linux-foundation.org bpf@vger.kernel.org douglas.raillard@arm.com iro=
gers@google.com linux-kernel@vger.kernel.org linux-trace-kernel@vger.kernel=
.org mark.rutland@arm.com mathieu.desnoyers@efficios.com mhiramat@kernel.or=
g namhyung@kernel.org olsajiri@gmail.com peterz@infradead.org rostedt@goodm=
is.org takayas@google.com tglx@linutronix.de zanussi@kernel.org]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

