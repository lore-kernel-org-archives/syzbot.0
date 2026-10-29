Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.70
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793252653;
	b=bIn+byegtURLg0IxlEBQNInd1lNFQAx6fJpjyWarPOa5HAqk1ixLRlmb9geb1CmzsTBb
	 UlpuvCFmZYPlqxfJhfEVrVbjFkLfTJhqjKGD9pfCoaAfrv2nd12nm/TTcfdhs1DLs1KxF
	 Ya6qqoXUIsnNnBcet+Aj89VB+VSQEu+KQ5+kUG1AOPmxD3CWBKFSU86dQjE7CD8VFk8DF
	 FHRcdBjSF9b/9qvNfncYYR7iIh0fCQI394dTxPjWSLYbYkqDUd5h3v+EGdJSTghMBOStq
	 NKVTKx+9kioJinjqVRSJsF1y0vuBJi3OfmVkWw9RZMw1eR9xoQRQnVHB/AZW9yBHKjw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793252653;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 MIME-Version:X-Received:Date:X-Google-Appengine-App-Id:
	 X-Google-Appengine-App-Id-Alias:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=2j6VMoOHf24qtLklshNlxQn7trhd0UynWlgN3C9xbYY=;
	b=xZXmJm4Y21oddjEhLvy+FAfE+weNBt8UIdgeGX1cSvCP/YsSrmhb+EU1D7dArYHq0VzQ
	 C9A6DSJELL0NEp5CZ8z6Ui2ClOcUFldjP6IKDlVkVLiWNmHoWjfdRfOkHLpRaimD1JJlv
	 8+CTYZNZi6Wvgx0Yf8JAiBDLxKiSDNdnHfLF3ZHVjulALNq23l2WC6RSSLW3j9o2lcr0+
	 baYlnhUrme9wykIstG8somqWW32rPYKXzaiw7mPJTyFSPcbQqwgsdYv5if/Mz1L+Yyh+A
	 oP8V3E7Pt5gIbC5rHgFbAKhqXqz+wrN+NFaEt+vK2KQ7LbESozhTFZBc9VCD4PE3Uyg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=syzkaller.appspotmail.com;
	spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	arc=none smtp.remote-ip=209.85.210.70
Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com [209.85.210.70])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EFB3606A31C
	for <syzbot@lists.linux.dev>; Thu, 29 Oct 2026 05:44:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2EFB3606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f70.google.com with SMTP id 46e09a7af769-84fe2593525so2716154a34.3
        for <syzbot@lists.linux.dev>; Wed, 28 Oct 2026 22:44:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793252652; x=1793857452;
        h=content-type:cc:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2j6VMoOHf24qtLklshNlxQn7trhd0UynWlgN3C9xbYY=;
        b=tMYonIpVW+c1ndIyGLJEJP4EvK99UiR6LA7lPydRLf40ViCjltAZyGfpwf3RNMYcqy
         PUyrXefl34bmOpK9EUvvJgL9bSVqySBghSnDtzKRgpLc5Gut12oaVy58Nut7tu/1yQd4
         FQstkiG57gENjFrQ1iCbg8Fvdlox9TP/MQRvjSPRTTL8ZGF16ggPtQEeVXcoOHsdDGF5
         cS1GQjp7SRxczzicxwlBoqpmWyu8pqjUgQoUQAYOCGK/WYUDka5fi++XCagv8Vrpra+D
         i56zPKZBOFQBresFyuhszhH6v6AIIoZF8MM0PFmGAvG5v1hb9RpdNG0XTmeECgmnHrDt
         6/Xw==
X-Gm-Message-State: AFq9FYLySLIf4KxpY48xSgCEjDhwunWyv7NMIBcP1UrZiZecRbeN3wPI
	XDGQa/qREpg3gneTKWkdeskfFwtfIGzrHEgMFGHQF7hL7ezMAHJL2vpxlQ2OyLj623kKEAkXwiG
	xuBxzRAAUPiWMeGH5v3dlkyb0r7NEAV1koF7msaGinj/vSm/PrVDB4F0nMW4=
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Post: <mailto:syzbot@lists.linux.dev>
List-Help: <mailto:syzbot+help@lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
List-Owner: <mailto:syzbot+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-Received: by 2002:a05:6808:318b:b0:4c4:28a5:1885 with SMTP id
 5614622812f47-5637ffe1390mr2753078b6e.9.1793252652208; Wed, 28 Oct 2026
 22:44:12 -0700 (PDT)
Date: Wed, 28 Oct 2026 22:44:12 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6ae2dd2c.5451848c.f7707.0005.GAE@google.com>
Subject: [moderation/CI] Re: sysctl: replace overloaded extra pointers with
 typed bounds and context
From: syzbot ci <syzbot+ci0660e05383ed849c@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v1] sysctl: replace overloaded extra pointers with typed bounds and context
https://lore.kernel.org/all/cover.1793204511.git.wen.yang@linux.dev
* [RFC PATCH 01/39] sysctl: replace overloaded extra pointers with typed bounds and context
* [RFC PATCH 02/39] test_sysctl: convert bounds to numeric values
* [RFC PATCH 03/39] sysctl: add KUnit coverage for numeric bounds and handlers
* [RFC PATCH 04/39] sysctl: cover runtime ranges and context lifecycles in KUnit
* [RFC PATCH 05/39] sysctl: cover priv in KUnit and the debug test module
* [RFC PATCH 06/39] sysctl: convert core table bounds to numeric values
* [RFC PATCH 07/39] sysctl: store architecture sysctl bounds by value
* [RFC PATCH 08/39] sysctl: store crypto sysctl bounds by value
* [RFC PATCH 09/39] sysctl: store device sysctl bounds by value
* [RFC PATCH 10/39] sysctl: store filesystem sysctl bounds by value
* [RFC PATCH 11/39] sysctl: store message-queue sysctl bounds by value
* [RFC PATCH 12/39] sysctl: store kernel sysctl bounds by value
* [RFC PATCH 13/39] sysctl: store memory-management sysctl bounds by value
* [RFC PATCH 14/39] sysctl: store IPv6 scalar sysctl bounds by value
* [RFC PATCH 15/39] sysctl: store netfilter scalar sysctl bounds by value
* [RFC PATCH 16/39] sysctl: store RPC sysctl bounds by value
* [RFC PATCH 17/39] sysctl: store remaining network sysctl bounds by value
* [RFC PATCH 18/39] sysctl: store security sysctl bounds by value
* [RFC PATCH 19/39] io_uring: store its sysctl bounds by value
* [RFC PATCH 20/39] sysctl: refresh dynamic scheduler and PID bounds per call
* [RFC PATCH 21/39] sysctl: refresh device-dependent bounds per call
* [RFC PATCH 22/39] sysctl: refresh namespace IPC bounds per call
* [RFC PATCH 23/39] yama: preserve scope locking with numeric sysctl bounds
* [RFC PATCH 24/39] net: refresh core sysctl limits without bound pointers
* [RFC PATCH 25/39] sctp: resolve numeric ranges from the current namespace
* [RFC PATCH 26/39] rds: preserve live reconnect limits with numeric bounds
* [RFC PATCH 27/39] ipv4: preserve live and vector bounds with numeric sysctls
* [RFC PATCH 28/39] net: refresh fragment and remaining dynamic sysctl bounds
* [RFC PATCH 29/39] neighbour: derive sysctl ownership independently of bounds
* [RFC PATCH 30/39] net: resolve sysctl owners from their backing data
* [RFC PATCH 31/39] ipvs: derive sysctl ownership from numeric storage
* [RFC PATCH 32/39] sysctl: remove obsolete nr_open bound variables
* [RFC PATCH 33/39] ipv6: move address sysctl context to priv
* [RFC PATCH 34/39] ipv4: move device sysctl context to priv
* [RFC PATCH 35/39] netfilter: move logger sysctl context to priv
* [RFC PATCH 36/39] parport: move device sysctl context to priv
* [RFC PATCH 37/39] net: move namespace sysctl context to priv
* [RFC PATCH 38/39] arm64: move vector-length sysctl context to priv
* [RFC PATCH 39/39] sysctl: remove the extra pointers and the compatibility bounds read

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/8e088b70-2ce9-4d52-8432-4d6d97db8a29

***

kernel build error

tree:      torvalds
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvalds/linux
base:      c339f4010dea8b0d754f84ace70cd1b089878ef8
arch:      amd64
compiler:  Debian clang version 22.1.8 (1~deb13u4), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/9097eda1-eee1-4198-9a33-035873aa2fda/config

net/unix/sysctl_net_unix.c:23:4: error: field designator 'extra1' does not refer to any field in type 'const struct ctl_table'
net/unix/sysctl_net_unix.c:24:4: error: field designator 'extra2' does not refer to any field in type 'const struct ctl_table'
net/unix/sysctl_net_unix.c:32:36: error: invalid application of 'sizeof' to an incomplete type 'const struct ctl_table[]'
net/unix/sysctl_net_unix.c:54:12: error: invalid application of 'sizeof' to an incomplete type 'const struct ctl_table[]'

***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

To test a fix for this bug, please reply with `#syz test`
(on a separate line) and attach the patch to the email.

Notes:
- The patch will be applied on top of the tested series (as an
  incremental fix).
- To test a new version of the whole series, please send it directly
  to syzbot@lists.linux.dev.
- Arguments like custom git repos and branches are not supported.

The email will later be sent to:
[joel.granados@kernel.org linux-fsdevel@vger.kernel.org linux-kernel@vger.kernel.org wen.yang@linux.dev]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

