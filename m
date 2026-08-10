Received: from mail-ot1-f72.google.com (mail-ot1-f72.google.com [209.85.210.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20BF043F4BB
	for <syzbot@lists.linux.dev>; Mon, 10 Aug 2026 21:44:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786398301; cv=none; b=GX7BG8VBAYUgUJagXP277x+V3FsISWrPjJEFqd0fp/gOFRvI4bOzaoUQp7ewemOECOcUsYR0s/ctBj3LWWUjtLzXwpCU4lXavBZ/wtaL4QxItygDvIaRIYcRrvFmJgioaWb530RFPPjB+lBkf+7Kl7JEV+/oAnCnB7pfomFTc7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786398301; c=relaxed/simple;
	bh=9HWWY4h2wwOQF4DTYHJFZ+81IuDUEq1czrkYu4RPblw=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=BBLlkgxmmNQ/Kta6XFORPU72yZQz3OoMYijzgEiIfwTOkFgabNwiyEjjQIKivwy9JjQV2yfk4DVSUXS6TtxjxEREPOu/Ectukwirof1mfUnj2Pf0UIC5oJyGcOuRzVypjLdEUYnsFQ4h/1fR0wcxNTY3rykAoYkJqIXF6qbg+T8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.210.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f72.google.com with SMTP id 46e09a7af769-7ee1e335245so1939535a34.1
        for <syzbot@lists.linux.dev>; Mon, 10 Aug 2026 14:44:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786398298; x=1787003098;
        h=content-type:cc:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=oQAQoXTiCT/6yb9nFaDpZmPoRN9HI2EMxevBvpRselo=;
        b=NdsnbOoFLYeqs0mq8TaHAwEyIDKaCvXfEwqjtrTh0vVhVW7VUVTfT83uE9TdeW3/Lh
         bdP4hZAMBlozNAsm5agUmcicLziyY6sI+LEeLSl3wqc6X06hxsjw/Nuc4Py2fgQmi6gM
         7VlzYjFJxLb7RAMUGm25dZHLBBXb8teE0iqVDyX6yXYrPk/N5maJowRcVECyQY4gxuHv
         tz2YS/PW2NId7qMBvWK0cFAyeu+ZJFZM3LCzSIOaAcnSD4BYsxP5+2dQp+T+Zd0RdrXT
         OAtvGUYBDIocZYUfwYKMOCyJqBbGt/219tcxwICLM8u9sNHNFOIyQwFbfW+xmPmmilRy
         eJkw==
X-Gm-Message-State: AOJu0YwXf7Z2cmR0s9S88ciNiG3O4YzfKGXhqeEPc4rHx7HiOhtRJ6dM
	4Y2/deqhzOjaW9dwm7RLVFfY9sKMoaZfPRljw6KGxCKo/P8QlpHQdJ53h+ZJxwJxPjCxACTSh6R
	61vGZ/lbGSx9r7n99/jGMwBty42s8wM8+g8TgFEs1wsml5AC1Xu03v0c8EsY=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a4a:ee17:0:b0:6ae:42c7:ef95 with SMTP id
 006d021491bc7-6b041f7ff09mr10749693eaf.13.1786398297851; Mon, 10 Aug 2026
 14:44:57 -0700 (PDT)
Date: Mon, 10 Aug 2026 14:44:57 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a7a4659.b50370da.49fe0.005b.GAE@google.com>
Subject: [moderation/CI] Re: NTB: Add direct TX/RX using PCI endpoint DMA
From: syzbot ci <syzbot+cid828235d04229e5c@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v1] NTB: Add direct TX/RX using PCI endpoint DMA
https://lore.kernel.org/all/20260810165136.2292436-1-den@valinux.co.jp
* [PATCH 01/16] NTB: ntb_transport: Abort link setup on QP MW allocation failure
* [PATCH 02/16] NTB: ntb_transport: Reject oversized TX buffers
* [PATCH 03/16] NTB: ntb_transport: Start TX offload thread after queue setup
* [PATCH 04/16] NTB: ntb_transport: Stop QP work before freeing a queue
* [PATCH 05/16] NTB: ntb_transport: Run RX processing on system workqueue
* [PATCH 06/16] NTB: ntb_transport: Define direct-DMA shared state
* [PATCH 07/16] NTB: ntb_transport: Negotiate direct-DMA queue layout
* [PATCH 08/16] NTB: ntb_transport: Add opt-in direct-DMA channel reservation
* [PATCH 09/16] NTB: ntb_transport: Allocate direct-DMA queue state
* [PATCH 10/16] NTB: ntb_transport: Implement direct-DMA QP session handshake
* [PATCH 11/16] NTB: ntb_transport: Implement direct-DMA RX buffer publication
* [PATCH 12/16] NTB: ntb_transport: Implement direct-DMA TX submission
* [PATCH 13/16] NTB: ntb_transport: Implement safe direct-DMA teardown
* [PATCH 14/16] NTB: ntb_transport: Enable direct-DMA queues
* [PATCH 15/16] NTB: ntb_transport: Report the direct-DMA payload limit
* [PATCH 16/16] NTB: ntb_transport: Add optional polling for direct-DMA RX

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/47a24886-7793-47c5-afcb-099b60961996

***

kernel build error

tree:      net-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netdev/net-next.git
base:      001b5d347d8ba39b2dccaefcc57967b18caec8fe
arch:      amd64
compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/ed6a2ec8-60c9-4ac5-8010-3ffdf21a07e7/config

drivers/ntb/ntb_transport.c:3052:13: error: call to undeclared function 'dmaengine_prep_config_single_safe'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
drivers/ntb/ntb_transport.c:3052:11: error: incompatible integer to pointer conversion assigning to 'struct dma_async_tx_descriptor *' from 'int' [-Wint-conversion]
drivers/ntb/ntb_transport.c:3072:14: error: incompatible integer to pointer conversion assigning to 'struct dma_async_tx_descriptor *' from 'int' [-Wint-conversion]
drivers/ntb/ntb_transport.c:3149:16: error: call to undeclared function 'dmaengine_prep_config_single_safe'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
drivers/ntb/ntb_transport.c:3149:14: error: incompatible integer to pointer conversion assigning to 'struct dma_async_tx_descriptor *' from 'int' [-Wint-conversion]

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
[allenbh@gmail.com cassel@kernel.org dave.jiang@intel.com den@valinux.co.jp frank.li@kernel.org gregkh@linuxfoundation.org jdmason@kudzu.us linux-kernel@vger.kernel.org nab@linux-iscsi.org netdev@vger.kernel.org ntb@lists.linux.dev]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

