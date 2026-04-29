Received: from mail-oo1-f71.google.com (mail-oo1-f71.google.com [209.85.161.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB6F9379979
	for <syzbot@lists.linux.dev>; Wed, 29 Apr 2026 17:41:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777484481; cv=none; b=HTb5NOKa8e+Rz2uKVSzqHqqW1yv716VfjfS/SkT/8iMkoBs3sVzZljW3fXbc+v/YxUy98iNxW4eIzdZWGB0nZoGG/NZqBfpInCq+s3Xwth977IZ+VLU72k2iB5UkImJ7HK/CwhiX6qzJ0041L6zoxSukTWkmR4gzJOWQyd19QxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777484481; c=relaxed/simple;
	bh=Y6gq13x4S1mU7/dKrAd/f8L1j3aZt9T+ZGUKWczHqZo=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=FOZferlIBnVILiQGE7xjtWU0dM5DAn0SKcrEX9nQZH9DT7gfqnILmudb2rajcRmt8Tk0PAoQKOzHJ1FJovsNnVTQJNJfep5ETmQK4rTDwIwIXJbrR1BUbFbRET7aYL1ps7+0MvQ+LxvSlntXYgNfdCS6sl4dRGBDqlIzaLBJScI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f71.google.com with SMTP id 006d021491bc7-694867ca29cso134059eaf.2
        for <syzbot@lists.linux.dev>; Wed, 29 Apr 2026 10:41:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777484479; x=1778089279;
        h=content-transfer-encoding:cc:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5dTQCJBo2mfKc/QXhulN1++HUUdth28AD6MuYrCeRNQ=;
        b=MDn1C3Z6t5zELEoxLY00giimHejDGZdtbEt09GrSed3vkbJiFgh/vPRmiRhMI4FYI6
         w5CXxxvCTLGtTTaZNRPgfPnRRn88uVEB8iX3RsFdEcOFSrifNI/z0IqjpqZj+pw3HPMY
         pzxXrrQg+q9BeWlvm5GhsIZFfUs9LQzdwNpB5iCV+fkChMTJZAuXkE3pb8gl+svLn82i
         FXbbqaThheK0pId89RwrDPvFSyPYhKx3wh5PygtqpZ0EB8Y4QCezNas9rTfOBr8ENMTi
         zjgCLlR2remzqZFMG8NhmHMZkT7iLumJwMOf7qzqpmpjBk8SdR2G2JIhBLh057iKPgQz
         F6lg==
X-Gm-Message-State: AOJu0YxToERP/VW5hvSb5C+aQ/yAd6WvHgK397h4ZTfu0W0jaKJ/Yjko
	13TTWiNfBnJUdHM8+o/XLl5WyRd7RPweigsv7wvUUK8sVGdWPJ3/nx5LVgVz0JJbW+JW14tUAz5
	ssyUCjZuqcF6LdYl7q885L0RwrDxalmacCvmwzIK/bWMk0Opb033raKdhH5g=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:f09:b0:681:b070:3dc6 with SMTP id
 006d021491bc7-6965ca3e4b5mr4918872eaf.10.1777484478833; Wed, 29 Apr 2026
 10:41:18 -0700 (PDT)
Date: Wed, 29 Apr 2026 10:41:18 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69f242be.050a0220.11c491.0002.GAE@google.com>
Subject: [moderation/CI] Re: block/blk-iolatency: Add the processing flow of
 the chained bio in the QoS and define the related types to solve the problem
 of incorrect inflight processing in the QoS. The usage of the done_split_bio
 abstract function in the blk-iolatency project.
From: syzbot ci <syzbot+ci52818c7451ee549c@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v1] block/blk-iolatency: Add the processing flow of the chained bio in the=
 QoS and define the related types to solve the problem of incorrect infligh=
t processing in the QoS. The usage of the done_split_bio abstract function =
in the blk-iolatency project.
https://lore.kernel.org/all/20260429094148.2394-1-likunyu10@163.com
* [PATCH] block/blk-iolatency: Add the processing flow of the chained bio i=
n the QoS and define the related types to solve the problem of incorrect in=
flight processing in the QoS. The usage of the done_split_bio abstract func=
tion in the blk-iolatency project.

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/e8a9be3d-e77c-42af-9dec-9b1ccee3a9bb

***

kernel build error

tree:      torvalds
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvald=
s/linux
base:      dca922e019dd758b4c1b4bec8f1d509efddeaab4
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp=
1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/7e1c0e84-c99c-43ae-95f1-10f4069710d=
a/config

block/blk-merge.c:159:17: error: use of undeclared identifier 'split'

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
[axboe@kernel.dk josef@toxicpanda.com likunyu10@163.com linux-block@vger.ke=
rnel.org linux-kernel@vger.kernel.org tj@kernel.org]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

