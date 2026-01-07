Received: from mail-oo1-f69.google.com (mail-oo1-f69.google.com [209.85.161.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F0C51E5201
	for <syzbot@lists.linux.dev>; Wed,  7 Jan 2026 22:14:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767824081; cv=none; b=d/Z9OQc50aGx+w7hIUfKh2BrmBSzJOb8q9enjuBINDZ4qvZgN/7oZ56xeDCZQYxs3nRlaQAvdTDd6FAAxTZ9TMNX8xLCuswe3SbyhNrQDlfjJFRspHXLymmo9jwAPPwrDy0mNzSPUSUVMaNlvUBnNajr/eFolPDHFsMRx7cpVqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767824081; c=relaxed/simple;
	bh=EtqN4d+Ct5bcpCJa0gxYDJ+Yjo0CtUeqmc52ezkOQ5c=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=HyKeNnbWNzx86hy7BUBETWh6lah/GwMZUKARlQX8tZKaYUreXeuWt1DQty6giN09oV7OOrl4rbqWk1f55oDerAfPf423jpCj+XkO0h0eIItuHx7zBuZ56NWoMd5XwHe6UqmgeJhDi0tOmT92e3QLLPisGsJQHXQ5f4WCCNSs2eo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f69.google.com with SMTP id 006d021491bc7-65eccb3f95cso4253602eaf.3
        for <syzbot@lists.linux.dev>; Wed, 07 Jan 2026 14:14:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767824078; x=1768428878;
        h=content-transfer-encoding:cc:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vzrFwvRz40ECKFeo7YU9ntuy5esmoM+rm5Tbn9lmCRg=;
        b=etUd76MLv/RnxZbm/I+3suL1hXjQhNmCZo0Tn7EX9ZDmPpKL5/A7P+8CkZprYQWKHL
         DdT0w6ZiHvhS+O/PwrcYld6XHHK8QyOcpH1NwbI7FhasuWz5PbGOBZJqV7t8NyZuwnuT
         vZu8rn9HyPLSKkehWVFWsYq3VQ2x/bKjUOmnIkzx4ZhpcVVw293A92cVAhe9Pnc2ei9u
         +SfH+Hd1uJ2ZY35R8GLiWVRBQkJdCXj4N1jKvnFRhJF/sKpOxZ103mneF0xTTaF6JUNA
         UylMomVxGqh7QPpmxoiPEKopSMoFdNUpUxPW0h8YwaHYCeJs5PpdZDAM70uplSI7H7Ru
         skAA==
X-Gm-Message-State: AOJu0YxQhBNhDwim5Wj0UhjTnJUsQ6JkmbOVDwvsbBP6qw5j+Xj6m38j
	xvlYglDG4OubFH5FqV29n3V79SLiz/1It6sAZtb0F0bN+ZkmWjkdZDuA/XWna4pCNxjfNLRn0ds
	eBqaKpNxDONlszo9XJnBfq2oQFqGALBJUneeXCX2jceJO9T+oTTmGFsVkZpo=
X-Google-Smtp-Source: AGHT+IF08IrRpNar7ldAYfGvMPBpyNA1YXLXQPC8WJrNKt+6i7VI5fGivM9a1uE6WOvOL4jrT8Rzd4krMtniKCkVTkKCLTz2TAP/
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a4a:be8c:0:b0:659:9a49:8fd9 with SMTP id
 006d021491bc7-65f550a8a81mr1054420eaf.82.1767824078333; Wed, 07 Jan 2026
 14:14:38 -0800 (PST)
Date: Wed, 07 Jan 2026 14:14:38 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <695edace.050a0220.1c677c.0381.GAE@google.com>
Subject: [moderation/CI] Re: bpf: lru: Fix unintended eviction when updating
 lru hash maps
From: syzbot ci <syzbot+ci5443f6aaadd2fbf0@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v3] bpf: lru: Fix unintended eviction when updating lru hash maps
https://lore.kernel.org/all/20260107151456.72539-1-leon.hwang@linux.dev
* [PATCH bpf-next v3 1/5] bpf: lru: Tidy hash handling in LRU code
* [PATCH bpf-next v3 2/5] bpf: lru: Factor out bpf_lru_node_reset_state hel=
per
* [PATCH bpf-next v3 3/5] bpf: lru: Factor out bpf_lru_move_next_inactive_r=
otation helper
* [PATCH bpf-next v3 4/5] bpf: lru: Fix unintended eviction when updating l=
ru hash maps
* [PATCH bpf-next v3 5/5] selftests/bpf: Add tests to verify no unintended =
eviction when updating lru_[percpu_,]hash maps

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/887ab165-3ba2-4319-a149-b620e5250ed5

***

kernel build error

tree:      bpf-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/bpf/bpf=
-next.git
base:      a069190b590e108223cd841a1c2d0bfb92230ecc
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251202083448+f68f64eb8130-1~exp=
1~20251202083504.46), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/55140e3d-5909-40ea-81ee-75ba1f1d215=
d/config

kernel/bpf/hashtab.c:1230:24: error: too many arguments to function call, e=
xpected 4, have 5

***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[andrii@kernel.org ast@kernel.org bpf@vger.kernel.org daniel@iogearbox.net =
davem@davemloft.net eddyz87@gmail.com haoluo@google.com john.fastabend@gmai=
l.com jolsa@kernel.org kernel-patches-bot@fb.com kpsingh@kernel.org leon.hw=
ang@linux.dev linux-kernel@vger.kernel.org linux-kselftest@vger.kernel.org =
martin.lau@linux.dev sdf@fomichev.me shuah@kernel.org skb99@linux.ibm.com s=
ong@kernel.org yonghong.song@linux.dev]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

