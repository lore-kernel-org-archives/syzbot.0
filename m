Received: from mail-io1-f72.google.com (mail-io1-f72.google.com [209.85.166.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B0452E7F03
	for <syzbot@lists.linux.dev>; Mon, 27 Oct 2025 11:10:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761563420; cv=none; b=VWhE6iRvvOZcRUs5DfJBXqJo0jfqavhUq+xGHU7Pm2XEjt/ELmyN6QC88DtrUBdQq1ELrsjwqh3qX+05wvgYIcuUDTpUlpOwn+aoHRzp4v45flaYaZybqND/aWEZzw0SCFNHtzolNcEeHxQjxVvvrn0RQSmCaKzNnnRo7iN33uM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761563420; c=relaxed/simple;
	bh=3OHuJz+ZzKhx0BlvnQVkKZkUBbV3uHjb1wYKStSjKQI=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=soxxGxYFfhOI551o4AZITuPiCFEOUtn0OHD88x9gZ+Hf1eQKeAlIWoCGYT57DRajcCD2/4DCe9p4bnz+vs10F8YuU0kxIW40UYwrdT0ETmXsb42xGuGYx6MAGM20vnV3lUpm1B8UC+THs31UckwoKqOlzGRGk3kuOj6m6cn6mKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-93e809242d0so1361452039f.0
        for <syzbot@lists.linux.dev>; Mon, 27 Oct 2025 04:10:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761563418; x=1762168218;
        h=cc:to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ZI2ig/W93vK9LYpfG64petZJ2lttifS6IFbH0MisS7s=;
        b=KTA3Z9ZiSJ7rL7xHN7PsxPjhRTLcJhTtj2SP02gWLYPSCEC2ArzwDklR1CEf1EYKl3
         4I7DjQ9LjKQ/B5qfilmFquuGjOPPJVGj4TJmxC0R9J8tL1IyEFKt2+oKdP8Pirg6c1wf
         z+COAOGA9GfQp2iuydpvmuxo0P8WDmBPTy2TfW6ZTbUDLp5b+jlaHFoxfQ/EymaoSCVi
         khmKZ+qJNglCPX5lWhLdC29UD+400LzWlEt3qFbNjYRWFJAWTXVwuO1rQQpCPYv46Zzn
         AMbQljo9WmhvEad4w3WiPrsv6CrNve6xclYWQ4c7THGovtncBP68waliq3JD6Q47kRht
         VUOA==
X-Gm-Message-State: AOJu0YyHzkC0cNoSnb0S4VtlKDjHe1sJLbu3uJWZU2BYx5Owj4/xK2QR
	auz2CDzD1OauywjWa6FqU8uzsrZRbQOaOiUjncFOMij7lCghtgeUSkXcYLaucnpk6xwp3K4cgGh
	0jkfr+hgnC1zJ6cFNL5JR64iQLpn4YbCd3MYsuxHJWISqvV1dPVMIDvojUW4=
X-Google-Smtp-Source: AGHT+IH0cPc0Ibix3tvABxu2mrlfpnd54LjpJU2J0wa+4En9089O+ZBsgt6FN2D+BQHL2L0JJKLxoeP70Gtydj1EZ0CI/aigjYPB
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1aa7:b0:430:b32d:c1a1 with SMTP id
 e9e14a558f8ab-431dc139f4dmr203893365ab.7.1761563418431; Mon, 27 Oct 2025
 04:10:18 -0700 (PDT)
Date: Mon, 27 Oct 2025 04:10:18 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68ff531a.050a0220.3344a1.037e.GAE@google.com>
Subject: [moderation/CI] Re: vhost: add a new ioctl VHOST_GET_VRING_WORKER_INFO
 and use in net.c
From: syzbot ci <syzbot+ci5018284c6e427e81@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v1] vhost: add a new ioctl VHOST_GET_VRING_WORKER_INFO and use in net.c
https://lore.kernel.org/all/20251027102644.622305-1-nhudson@akamai.com
* [PATCH] vhost: add a new ioctl VHOST_GET_VRING_WORKER_INFO and use in net.c

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/1df205d3-fe0c-4d10-8971-710c01c77f0d

***

kernel build error

tree:      net-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netdev/net-next.git
base:      bfe62db5422b1a5f25752bd0877a097d436d876d
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/d97eaf43-dfb4-484b-ba23-67d850d9c866/config

drivers/vhost/vhost.c:2403:3: error: use of undeclared identifier 'worker'
drivers/vhost/vhost.c:2403:34: error: use of undeclared identifier 'vq'
drivers/vhost/vhost.c:2404:30: error: use of undeclared identifier 'dev'
drivers/vhost/vhost.c:2405:8: error: use of undeclared identifier 'worker'
drivers/vhost/vhost.c:2406:4: error: use of undeclared identifier 'ret'
drivers/vhost/vhost.c:2410:39: error: use of undeclared identifier 'ring_worker_info'; did you mean 'print_worker_info'?
drivers/vhost/vhost.c:2410:11: error: use of undeclared identifier 'ring_worker_info'; did you mean 'print_worker_info'?
drivers/vhost/vhost.c:2411:3: error: use of undeclared identifier 'ring_worker_info'; did you mean 'print_worker_info'?
drivers/vhost/vhost.c:2411:19: error: member reference base type 'void (const char *, struct task_struct *)' is not a structure or union
drivers/vhost/vhost.c:2411:28: error: use of undeclared identifier 'idx'
drivers/vhost/vhost.c:2412:3: error: use of undeclared identifier 'ring_worker_info'; did you mean 'print_worker_info'?
drivers/vhost/vhost.c:2412:19: error: member reference base type 'void (const char *, struct task_struct *)' is not a structure or union
drivers/vhost/vhost.c:2412:32: error: use of undeclared identifier 'worker'
drivers/vhost/vhost.c:2413:3: error: use of undeclared identifier 'ring_worker_info'; did you mean 'print_worker_info'?
drivers/vhost/vhost.c:2413:19: error: member reference base type 'void (const char *, struct task_struct *)' is not a structure or union

***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[eperezma@redhat.com jasowang@redhat.com kvm@vger.kernel.org linux-kernel@vger.kernel.org mst@redhat.com mtottenh@akamai.com netdev@vger.kernel.org nhudson@akamai.com virtualization@lists.linux.dev]

If the report looks fine to you, reply with:
#syz upstream

