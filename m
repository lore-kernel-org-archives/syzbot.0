Received: from mail-io1-f71.google.com (mail-io1-f71.google.com [209.85.166.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5A252F5A1F
	for <syzbot@lists.linux.dev>; Fri, 24 Oct 2025 08:13:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761293632; cv=none; b=lJwZQrNbRiRUgjaJ/qp9dt5BTQc5yeJ7ELk19Hv3sRhakKTWQ/dpJI6AlWaDPLAKo82voBD3zePkf9KUpWeoiJqzE+S5h1JJKy5RyTEvXpnxpt34sIeP6MCOtWbYlQqmjTeBpzcptIzEjFG8j0/FaFp8pTKkvMST0dIUID8o3sU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761293632; c=relaxed/simple;
	bh=xiOwpZXLOhC14XSRclnXIsvIwuQYokYV1G657ASRZiI=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=sn4tRExEvlarTJuEHtoJwqHsxXV72oFnuXXO/DvC6PfUp0KuicTfT/owzmd5aociBMsz3xctfZStgwYJopikwkZ5yWPp7yeYDEq91HKags6YD4bFUwVbw9gWq3CL5/6+gectJDNDgJoL+w+0F+h0ylTRgEYNnL27cT9h5ozXC/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-940d395fd10so522765839f.1
        for <syzbot@lists.linux.dev>; Fri, 24 Oct 2025 01:13:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761293630; x=1761898430;
        h=content-transfer-encoding:cc:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8suv3mEoaR15zFOEFy9Sni+DSH/kQ3yGtmdTe1l2IW4=;
        b=CLAfmz2JpnsiO8ei/A/73xIA9Zbj2OhqQTv4Z8QyEeFBtsTpfGjEVeKTU/FReXw+1K
         S0xLEl2qsv8twJG9gNMpcf6qYigKqfiUDUgXeAH2iXAZugUNUjomYj2i/a7Sqbg9ZfoB
         6DGQxSrv6021/OGkJ5XNA1/pIxRD5D3twZproJaZoAySernw7Ym3t7y0EsoKxJDV5BR5
         L31kAh5zAax8aCRsUa7T5f+zpjhOaX569ZZUfZlIXKlVV2tpsl1JFbfB0bTkqqeNJO4S
         l8wK/4aWB5EE/6GtYtQCIXnTsaRPL8hZcPxDDycVcDd9+h+B9geZXtmhxiAkFAOR0dYR
         KOgQ==
X-Gm-Message-State: AOJu0YynywWdbxMrzPrgVwS+G5TkeJUpSyWysF6uMZLe+mJqevwrYFv6
	GZ0O9S2vl6wBE53dDspx1kdEwLbSk/q5zJvs5wLOHsYQELBSc5Xg1PjLqMzWAWMrUr/4lUBQA+u
	odHaSPObspn80N9oylTlxi1bksWhZ5mn6WzTR9+mGkMltosrtDIrQJiNgMEU=
X-Google-Smtp-Source: AGHT+IETVi0ov+I0IfDX0wE+8dptOqWbHixAsXi1kKYWqwMPetRfVrWaBd1yIupa2KvAKN0oQ+Z2CbNstQolpxjfHzRt9pr2P4nB
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:b42:b0:430:b6a3:53b4 with SMTP id
 e9e14a558f8ab-431ebeb3f12mr23292725ab.3.1761293629999; Fri, 24 Oct 2025
 01:13:49 -0700 (PDT)
Date: Fri, 24 Oct 2025 01:13:49 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68fb353d.a70a0220.3bf6c6.015c.GAE@google.com>
Subject: [moderation/CI] Re: Fix ftrace for livepatch + BPF fexit programs
From: syzbot ci <syzbot+cif177115980bd6f63@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v1] Fix ftrace for livepatch + BPF fexit programs
https://lore.kernel.org/all/20251024071257.3956031-1-song@kernel.org
* [PATCH bpf-next 1/3] ftrace: Fix BPF fexit with livepatch
* [PATCH bpf-next 2/3] ftrace: bpf: Fix IPMODIFY + DIRECT in modify_ftrace_=
direct()
* [PATCH bpf-next 3/3] selftests/bpf: Add tests for livepatch + bpf trampol=
ine

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/05031eb1-929e-442e-8c25-a441c742d58b

***

kernel build error

tree:      bpf-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/bpf/bpf=
-next.git
base:      7361c864852f07b39f5e571447060bd4d758a998
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp=
1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/0a3a116e-dcd5-4171-83c2-810b34608a0=
a/config

kernel/bpf/trampoline.c:229:11: error: incomplete definition of type 'struc=
t ftrace_ops'
kernel/bpf/trampoline.c:230:11: error: incomplete definition of type 'struc=
t ftrace_ops'

***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[andrey.grodzovsky@crowdstrike.com andrii@kernel.org ast@kernel.org bpf@vge=
r.kernel.org daniel@iogearbox.net kernel-team@meta.com linux-trace-kernel@v=
ger.kernel.org live-patching@vger.kernel.org mhiramat@kernel.org rostedt@go=
odmis.org song@kernel.org stable@vger.kernel.org]

If the report looks fine to you, reply with:
#syz upstream

