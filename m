Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4FB0824BD
	for <syzbot@lists.linux.dev>; Thu, 20 Nov 2025 04:28:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763612889; cv=none; b=oMF5yEQyoxt0XsAe52N3BgELIcJpObjyoMMBS2A9ZMn3cxV5Mzv2sziqZvG2Z1XadpAWQUurlhX7jmJrIvMMfKkTInDz1yqYSdrYsFN1pCpHO1KdbhhJZ9cjok/RJouARxPeWO7mjdbaP4uYJv3iZuOoOMMdQ+bY/ahiVd2L358=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763612889; c=relaxed/simple;
	bh=doUor6fw0t/uGgZ9T12Hmrn8TlIDmY7bcmb0K6LBhMw=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=maqYMTm93siu0bqHq69M1CmwERL8hjZsZ3kbnRmtOghHr9sLWHr0pvaQik01c2UIrNj+15lVSFP24nlrN+WkYerGAiZ6DPA2SUVI4T4+s7k3U8ZBfubuo1qoRutRKWvA0xz0BRj43aWX3NY8QiwT314lJ6/8a4DUfps42yE0mCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-43373024b5eso5509335ab.1
        for <syzbot@lists.linux.dev>; Wed, 19 Nov 2025 20:28:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763612884; x=1764217684;
        h=cc:to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=cVAulT8PozrmP7XAynLXdbeMpDg1Zn58FSZ8Ijoy0cQ=;
        b=Fh4S0grpG98sW5JFD1nRf/VuDmnDJWc1XH8FL3wOwt/vmDXtg0p4GPm6+GdoXYFZmX
         2SNmR0AOeBSgv69nQUydRzNyz03mTJRrsu2/zXnkj2CifBPoYj+wIMLdqnnBVMMbD5oN
         7MxQs/7SYjYeX1tCed5QW6ssL7d91DX8AqVYKARp1MCGHwcsi9XWMiBCYyhUc7bhpBhn
         crmJsTsh3ThtZP4XoYkDgBE3M8d+aKwiuv6wl2LZmkyZ4BTaXpsrRRJxs5dfKyqWKwWJ
         6PhF4t/al05blU4tvZgTziVg+0Ru/O87tjcyU9wVFNSjaYnGK6kMltxvjD3muOhDzwZ/
         5Efw==
X-Gm-Message-State: AOJu0YzZ1dLI4P/L8NyvPagEHkNxI7euu5j45ZTLrwUElc1FR8hoZtCi
	EfOcyJHsc93LArRuRxx7KbSXIKIMcYECfbp7fgJodEmZSZxBYn7imH4hhw8yeQtwnxCBvNyI0PX
	lRkz9cwp1xGDUhIYg3nZgT+IdxCCUZfJ2fMQVvoPfaTq2UnTa4plIpv5EmyA=
X-Google-Smtp-Source: AGHT+IHJYacEf806iMB5PqxkEgtlH71yg62OvBp3XRSSpkQ8Tnfw2ibNfAsfWb5uENIp1fJ3O2v/PoXBX1laBxA0YUh5Rdd4AGq8
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a92:ca0e:0:b0:433:5a5c:5d75 with SMTP id
 e9e14a558f8ab-435a902b607mr18603995ab.18.1763612883770; Wed, 19 Nov 2025
 20:28:03 -0800 (PST)
Date: Wed, 19 Nov 2025 20:28:03 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <691e98d3.a70a0220.2ea503.0026.GAE@google.com>
Subject: [moderation/CI] Re: blk-mq: use array manage hctx map instead of xarray
From: syzbot ci <syzbot+ciacb870c958a5824a@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v1] blk-mq: use array manage hctx map instead of xarray
https://lore.kernel.org/all/20251120031626.92425-1-fengnanchang@gmail.com
* [PATCH 1/2] blk-mq: use array manage hctx map instead of xarray
* [PATCH 2/2] blk-mq: fix potential uaf for 'queue_hw_ctx'

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/ddd2aa61-2dfe-4251-b809-24a58dfcfb5b

***

kernel build error

tree:      torvalds
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvalds/linux
base:      23cb64fb76257309e396ea4cec8396d4a1dbae68
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/25f0aac1-09a9-4e9a-b0bd-2043ee6ba006/config

drivers/block/rnbd/rnbd-clt.c:1324:2: error: call to undeclared function 'queue_hctx'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
drivers/block/rnbd/rnbd-clt.c:1324:2: error: incompatible integer to pointer conversion assigning to 'struct blk_mq_hw_ctx *' from 'int' [-Wint-conversion]

***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[axboe@kernel.dk changfengnan@bytedance.com fengnanchang@gmail.com hare@suse.de hch@lst.de linux-block@vger.kernel.org ming.lei@redhat.com yukuai3@huawei.com]

If the report looks fine to you, reply with:
#syz upstream

