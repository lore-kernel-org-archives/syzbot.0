Received: from mail-ot1-f69.google.com (mail-ot1-f69.google.com [209.85.210.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D95C8227BA4
	for <syzbot@lists.linux.dev>; Mon, 26 Jan 2026 18:21:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769451719; cv=none; b=tzpQXR02VW0fI7a3LkorJ8XIXvc9AqYReTZuuc2jBDmPzLXTm2nfBQClxNmuR/Mgi6OYXz5SEan4k+xePxNYeePc1fOv0AMRzijwuLWiySMT7hHDHQvyci8gAOB/UKt0S+5L9Z7yMGoBBBlOpieTTwPq7Dzr/SAkCC9i+OLEV8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769451719; c=relaxed/simple;
	bh=jb95aMzlK2FEeUI9GLXR+uDGLcw+wEr17s2QckJczto=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=Y1YF6yG3gwFLxFZ/NS1V6kor1J3tWRdeLYudtFOh0zs1weacO/v3wInfyhTtu+n24oZ4x8/c1AffUEeyGowQQ0nzrwevsM2hvUhMAyZmQZMiR9plB4EifSslaTN4gV/Sxa977ElxWxEwrsMEAX8+N8X5rHdUOP4ks+5pI1EHrnM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.210.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f69.google.com with SMTP id 46e09a7af769-7ce5218a74cso13829868a34.3
        for <syzbot@lists.linux.dev>; Mon, 26 Jan 2026 10:21:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769451717; x=1770056517;
        h=cc:to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8qcuxBu9DMeExrVPiRGYUEDLGo1eo5YrKtPR22SDq8s=;
        b=IxRCMG6V9H7cVOzc478NNqM2iTvdNvimnimQBhuWHRWGsqW3d3Lwlr1mNKb+e1t3sr
         CXXt4oXotrk7vLycEoxnJix3EfImabYoZLKBBBzLyDhm+s3g3PMiii7GcH+iriCbpg8N
         EU9X9cCszG1tx0gAO35bdu0k6KGxjvMvzlfY3Az+X/zJlYusCKAlaaiBk0df+28gKNWG
         MuXEXWnt3PU1oVbOLvY8MkGtS2XOZRmJGpa3lc0fteVmhmoHNKktqnCbJKItpzJK0QgR
         0iqBsxNRL4Gi78VmkeU0PGmGbbiUxxtlqD3rTrx65Qh8Hwj8+uh6RxKwL5BNo0r77n9m
         C60w==
X-Gm-Message-State: AOJu0YyYp+H3pMmJq2UAOtI72jKbQYd7N9KX4kzw+6DycMGVBa5rTEFm
	0NLnJX4vHvLuTXMJJAEIGso48DSYP5cLarQxqUt0qkmbcdKW9BKmnmIs26YpVglgIqzZpmevaSe
	hyLgpBRH60gi7I0dTSvwnxksntEBwc3RGcFQV58ddV0RgxJPskS01MpJBdi8=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:308b:b0:65c:fe8b:53b3 with SMTP id
 006d021491bc7-662e02c61bcmr2225349eaf.9.1769451716796; Mon, 26 Jan 2026
 10:21:56 -0800 (PST)
Date: Mon, 26 Jan 2026 10:21:56 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6977b0c4.050a0220.c9109.0001.GAE@google.com>
Subject: [moderation/CI] Re: bpf: fix TCX/netkit detach permissions when prog
 FD isn't given
From: syzbot ci <syzbot+ci6186b1296ebfdf4d@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v1] bpf: fix TCX/netkit detach permissions when prog FD isn't given
https://lore.kernel.org/all/20260126170731.16321-1-ggonnet.linux@gmail.com
* [PATCH bpf] bpf: fix TCX/netkit detach permissions when prog FD isn't given

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/27bcd0de-cf56-40f9-9814-657ef19ee66c

***

kernel build error

tree:      bpf-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/bpf/bpf-next.git
base:      59ef78d403806b9d1f8373ea1a2fe63f88ba17da
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/2f4b4a71-aa8e-4af5-be8d-f3fb59fcba6e/config

kernel/bpf/syscall.c:4580:2: error: non-void function does not return a value in all control paths [-Werror,-Wreturn-type]
kernel/bpf/syscall.c:4580:4: error: expected identifier or '('
kernel/bpf/syscall.c:4583:4: error: expected identifier or '('
kernel/bpf/syscall.c:4589:2: error: expected identifier or '('
kernel/bpf/syscall.c:4621:2: error: expected identifier or '('
kernel/bpf/syscall.c:4623:2: error: expected identifier or '('
kernel/bpf/syscall.c:4624:1: error: extraneous closing brace ('}')

***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[ast@kernel.org bpf@vger.kernel.org daniel@iogearbox.net ggonnet.linux@gmail.com john.fastabend@gmail.com martin.lau@linux.dev]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

