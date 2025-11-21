Received: from mail-io1-f71.google.com (mail-io1-f71.google.com [209.85.166.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99EE026F2A1
	for <syzbot@lists.linux.dev>; Fri, 21 Nov 2025 17:18:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763745516; cv=none; b=QYOJyrLF17RhFRu7LO1p4NIlt9ksPddSCdQlZ7ZZuqq+xtNplsMt95qY1YagI235vXdzPIcucSPMHz99UotdaNBWfBxqH4vkCk7J5JQH+xzrGen3SRyTfeEnO4X5smWUXnuYbK9cPKI4/V+f3NHfcM4ETLqxoGzU/Uk6XXayj0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763745516; c=relaxed/simple;
	bh=dlHWn7XRitTWclAAGXKu/zRvyLMIUUvuCsKABxUobj0=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=dd89m0ZZs8gwgpZHsBpBkVO0L4HMJ/4mm9RzqXRy32IjrY0N48XAFzbUdBNNQpGj7VOAz4k3O73iL0jphRRRLUDyZHvEnxjmgGtR714HRZ42zEdcsX07FWiHrbXSd5wdCQiX0/MDX+2LziJZ7AJAGecfsdiz4rAhX4ZAlDVYfYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-9489bfaef15so158105639f.1
        for <syzbot@lists.linux.dev>; Fri, 21 Nov 2025 09:18:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763745513; x=1764350313;
        h=content-transfer-encoding:cc:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BF9AXSMBG0Y6MlBjwNf0WZGKYs3nnKkzllXrGYhYDXI=;
        b=xPZpAtOKYAee+v9+qQgEIvlCKFIFlbIta4xNwAv1uMgp9mV/Vs4HO41kvysRJ9D1ca
         zGd4lE5aIExU+AZCsSMHYzLEf55cXRy8hr6xr63Y98TtypwHenbsaYSvewrfF1wFCYBU
         iNd+yVZhcakwrQQ9OoIRZoL+fHdxdze34xashtxtuWiJRRrDaaDSsRQKp1NfnxE72UZW
         mn4BEUdjTo2O1REwISf4XKQzOsARyAZ/uzc843AJVI1hrLthg1D1pkuUb3K/buNWky0W
         7P4kxRe19Z5WvwkDr7ZTo5ZrMVzk6jks2D3ORZ0QkvpNenOvYMdcAqO7J1Xdktrx+Xnt
         V6Bg==
X-Gm-Message-State: AOJu0Yy9IKSBlvfSutBPkyFwDgDuAmqPZZRuaU+7KNxByM0tUlmo3wXj
	VG6vEsqtq8q+mbh8vx7BjYbZGhtAcB3bUTSKOnHmjgr+G1R2L6SidnFYfTLL0HdwkqUHXgsnKLi
	dwND1pmlzaYT3ChrLn5ju2pC075M/Ws2SMsy9BvpytIXn+8zVi6lI5JCKqNc=
X-Google-Smtp-Source: AGHT+IF6udinbRfaNzLCBlTqGCx9QUc9UTUhcgesZzJjmb3K2JIR+cSZCxnX0j09lFXzHJE4MOV3lfqwVZgG8t/EaxHcr53nvKd3
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:8e:b0:435:a148:d2a with SMTP id
 e9e14a558f8ab-435b8ebe819mr28510665ab.41.1763745513697; Fri, 21 Nov 2025
 09:18:33 -0800 (PST)
Date: Fri, 21 Nov 2025 09:18:33 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69209ee9.a70a0220.d98e3.0048.GAE@google.com>
Subject: [moderation/CI] Re: uprobe/x86: Add support to optimize prologue
From: syzbot ci <syzbot+cib2b453890fc5f147@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v1] uprobe/x86: Add support to optimize prologue
https://lore.kernel.org/all/20251117124057.687384-1-jolsa@kernel.org
* [RFC PATCH 1/8] uprobe/x86: Introduce struct arch_uprobe_xol object
* [RFC PATCH 2/8] uprobe/x86: Use struct arch_uprobe_xol in emulate callbac=
k
* [RFC PATCH 3/8] uprobe/x86: Add support to emulate mov reg,reg instructio=
ns
* [RFC PATCH 4/8] uprobe/x86: Add support to emulate sub imm,reg instructio=
ns
* [RFC PATCH 5/8] uprobe/x86: Add support to optimize on top of emulated in=
structions
* [RFC PATCH 6/8] selftests/bpf: Add test for mov and sub emulation
* [RFC PATCH 7/8] selftests/bpf: Add test for uprobe prologue optimization
* [RFC PATCH 8/8] selftests/bpf: Add race test for uprobe proglog optimizat=
ion

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/865d9b3b-99d7-4496-93bd-baab28cad7e0

***

kernel build error

tree:      bpf-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/bpf/bpf=
-next.git
base:      4722981cca373a338bbcf3a93ecf7144a892b03b
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp=
1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/58f329f8-355c-473d-8b62-b6392fa11d2=
1/config

arch/x86/kernel/uprobes.c:1665:39: error: too few arguments to function cal=
l, expected 2, have 1
arch/x86/kernel/uprobes.c:1668:38: error: too few arguments to function cal=
l, expected 2, have 1
arch/x86/kernel/uprobes.c:1695:34: error: too few arguments to function cal=
l, expected 2, have 1

***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[andrii@kernel.org bpf@vger.kernel.org david.laight@aculab.com john.fastabe=
nd@gmail.com jolsa@kernel.org linux-kernel@vger.kernel.org linux-trace-kern=
el@vger.kernel.org mhiramat@kernel.org mingo@kernel.org oleg@redhat.com pet=
erz@infradead.org rostedt@goodmis.org songliubraving@fb.com x86@kernel.org =
yhs@fb.com]

If the report looks fine to you, reply with:
#syz upstream

