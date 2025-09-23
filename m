Received: from mail-io1-f70.google.com (mail-io1-f70.google.com [209.85.166.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C04625394A
	for <syzbot@lists.linux.dev>; Tue, 23 Sep 2025 22:45:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758667525; cv=none; b=k9g/3eps3NxhVQgmsfG0IIo7Shs3JaG/6e+Nm45vSkafB7FGQBE+mhr78DaxuPZr6BV3YfjqlYZ/lKJ/CWqdvThGN6lmmpHb3NcVvgybijgTuOUwGzziTT/FyV0ex4iA8WADd4vNQd8ihU6CXlo7/Ik0nnq64iQL7DFA146zZVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758667525; c=relaxed/simple;
	bh=ZzIjkzpQalGJvDssLq786CrdC+BQo/KRDyF9Kf4Qflg=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=u6H13JWKPD7sPq3L+PFKdAlwYAwoaSTGMCP9Vbx2NwaxibiGGb2K1vfGDfFVY0fU2P5LBdLrePygskhbG7sZ6FeUdHcjck7FhaxAhywtcYgO2HwdFaugzM/0YiL+qjfb9HqdKwSMQbiSYJW4hDdBhHoF6jk5q5e3zBMCycjC5XY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-8d88b7034deso246108539f.3
        for <syzbot@lists.linux.dev>; Tue, 23 Sep 2025 15:45:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758667523; x=1759272323;
        h=content-transfer-encoding:cc:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0QcTs3UwvcXKVa+oLjxIrY03BzMCwafDw0UFCTcXLQk=;
        b=rRAfmmnxf/XylcrPQmiYPX1OPPukg0oL9sRy2CEIEFiwoTsazcFQnNwzoFrch6BRbi
         O29taH06n4E/8I6Eve03zX0Txytz8upXA4T+WXhJDlfKbPqWUDWOw5WVwTXcBVtdDYP4
         dxjvIMJCLE647cQwcsA6QYMoz6DPT4lg0bsV0nCbqPe09HBJt0oLK/Wz9DW4t5rOpolh
         VJLNQYOByJdRioDckI2Hn9Foy/wIMXe+b04T25uHMil0tiH63agovaO/8Vfpl1yH0r/i
         9d+gmL9MkhrpclKHjdE77h+l20J1RGX1q+0Br2hD4LJAoS4HQ0ZUvO8smutsR2+0bx+h
         56UQ==
X-Gm-Message-State: AOJu0YyTFCYWHfwVK7FPcCDiNG+7bppU5vvIZHpEDHSA4NY7p31QTQWr
	11a07sJvQ5VM0QvHjHPGEd3u/0T/1TK2kDZG4y+wp4NYcjTT/a4WKpbvfurf0lguyd/vWghQj5C
	L/GNUSh+ajpAiYcIDuyRSD38ZlWnx/VazDLOcM2m669HHgiulQJtQUPwGi00=
X-Google-Smtp-Source: AGHT+IGwN8jiC9XsF3jG/bOr/mMQ6jr6WyOnDqly5RzKgQpJGKBoC0mT3Z1O1zUxC19gW3VGbmK82e6DeeaIpCuwtsc7ctKBODr5
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:190d:b0:424:57d:1a53 with SMTP id
 e9e14a558f8ab-42581e04a1dmr52425805ab.7.1758667523148; Tue, 23 Sep 2025
 15:45:23 -0700 (PDT)
Date: Tue, 23 Sep 2025 15:45:23 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68d32303.a70a0220.4f78.0010.GAE@google.com>
Subject: [moderation/CI] Re: ftrace,bpf: Use single direct ops for bpf trampolines
From: syzbot ci <syzbot+ci776c8b6bec447c54@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v1] ftrace,bpf: Use single direct ops for bpf trampolines
https://lore.kernel.org/all/20250923215147.1571952-1-jolsa@kernel.org
* [PATCH 1/9] ftrace: Make alloc_and_copy_ftrace_hash direct friendly
* [PATCH 2/9] ftrace: Add register_ftrace_direct_hash function
* [PATCH 3/9] ftrace: Add unregister_ftrace_direct_hash function
* [PATCH 4/9] ftrace: Add modify_ftrace_direct_hash function
* [PATCH 5/9] ftrace: Export some of hash related functions
* [PATCH 6/9] ftrace: Use direct hash interface in direct functions
* [PATCH 7/9] bpf: Add trampoline ip hash table
* [PATCH 8/9] ftrace: Factor ftrace_ops ops_func interface
* [PATCH 9/9] bpf, x86: Use single ftrace_ops for direct calls

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/d43b97e0-0a8d-4035-8052-301be44fb4ba

***

kernel build error

tree:      bpf-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/bpf/bpf=
-next.git
base:      5a427fddec5e76360725a0f03df3a2a003efbe2e
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp=
1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/22bf6a56-bac1-4606-9b59-4fe45ae685d=
d/config

kernel/trace/trace.h:907:24: error: incomplete definition of type 'struct f=
trace_hash'
kernel/trace/trace.h:907:40: error: incomplete definition of type 'struct f=
trace_hash'

***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[andrii@kernel.org ast@kernel.org bpf@vger.kernel.org daniel@iogearbox.net =
jolsa@kernel.org linux-arm-kernel@lists.infradead.org linux-kernel@vger.ker=
nel.org linux-trace-kernel@vger.kernel.org mark.rutland@arm.com menglong8.d=
ong@gmail.com revest@google.com rostedt@kernel.org]

If the report looks fine to you, reply with:
#syz upstream

