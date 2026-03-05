Received: from mail-oo1-f69.google.com (mail-oo1-f69.google.com [209.85.161.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A3A419C54E
	for <syzbot@lists.linux.dev>; Thu,  5 Mar 2026 00:38:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772671104; cv=none; b=oBNn2xbdjFC+P8psA55Qrdmvtzoayvd8Te6Dl6OpktXFw0085bB7noQ5pfRPu8UHUczR/gLOBeH3hIgaqtovrIz6rl2jLn+Iuew9I34u3N/f7+WAUDCMIo0Lmke8Uep6p9imX13cyx9WNXdOGTnxvpxc437pu/wmlCoudPMF0T0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772671104; c=relaxed/simple;
	bh=oNnVWXWB3k+WvHyyYB0Wh8c3fKKfSeePLLsWw7IQhPc=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=n7zqtmtn8jSlGnKuCPBq8ZRwXIEv0oahK+j3ZY2Wi1lWpa3IJmm9iZGC4DY/1TipGGm4eSEu+EMcWoD5jcby3tSz99Xmm7TX/c++jxSXCdg2ZtzRqBWczIi5iM0WaN1Q1rtrxa83Pv9TDtLSueqFO0cX4nVAql6VkFLY/TcjveI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f69.google.com with SMTP id 006d021491bc7-679943693c0so125311432eaf.3
        for <syzbot@lists.linux.dev>; Wed, 04 Mar 2026 16:38:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772671102; x=1773275902;
        h=content-transfer-encoding:cc:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mCvwUHxIqY3csfT08M8lxXcHT8accZOdR5vy1WvsW8I=;
        b=qDYrwD8b1OnvXsialkGwSaMQlLDgNztH2iMgrTSndH0xcA5bvlyarhCGHadvQCktLQ
         /PI0uB+lz8HOWPqveXND4T9PMUzAR/QTxLaE17l72Lt3EmOAJlFFUkoRCla/anuDlics
         0wB40NzLsr7/wqJgpVkKjfWWMov3RJ5PnHc+48F1DVlYjrdTi9ooQV4qCjL/kWANtf/f
         NAm+xJlbCfT9/JxgmnkUnn6bKkccyZfuR3c+MxM3uJhrGsYCSNPKk63RRY1fFEVPhV7c
         AnQA8RPRIitt0tAci2CwtwSvP8r4MFRMAPPrxvy7RAlDqDlW2B/FncrOCu/nLyIN/Nyk
         sA8g==
X-Gm-Message-State: AOJu0Yy2pCqGcFWQkr1K5xhutOg9zjLm5ZqSSOyi0dJIglHhX2y0aNbf
	9cKbv8Ra2KzQfmRASiBy6XqoAWjEizdY/p/UbZhS54Jhp2WxjlNsbXAnkg04E5UTCbqhrUIAj/6
	mvWoG0jLPldMs374kuIuN4zd/45EINFaxqogiuNKX45WSM+K7YvMW4WnXKJk=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:f06b:b0:67b:92be:ef8d with SMTP id
 006d021491bc7-67b92bef052mr796031eaf.1.1772671102194; Wed, 04 Mar 2026
 16:38:22 -0800 (PST)
Date: Wed, 04 Mar 2026 16:38:22 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69a8d07e.a70a0220.135158.0013.GAE@google.com>
Subject: [moderation/CI] Re: bsg: add io_uring command support for SCSI passthrough
From: syzbot ci <syzbot+cif6582a959155eabe@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v5] bsg: add io_uring command support for SCSI passthrough
https://lore.kernel.org/all/20260304080313.675768-1-yangxiuwei@kylinos.cn
* [PATCH v5 1/3] bsg: add bsg_uring_cmd uapi structure
* [PATCH v5 2/3] bsg: add io_uring command support to generic layer
* [PATCH v5 3/3] scsi: bsg: add io_uring passthrough handler

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/d10fb67c-0756-49f2-a7fd-bfade2305b9a

***

kernel build error

tree:      torvalds
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvald=
s/linux
base:      ecc64d2dc9ff9738d2a896beb68e02c2feaf9a02
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp=
1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/8abf8676-4535-40d8-b35f-6f8ab7e8bbe=
e/config

drivers/scsi/scsi_bsg.c:111:64: error: too few arguments provided to functi=
on-like macro invocation
drivers/scsi/scsi_bsg.c:111:36: error: use of undeclared identifier 'io_uri=
ng_sqe_cmd'
drivers/scsi/scsi_bsg.c:137:64: error: too few arguments provided to functi=
on-like macro invocation
drivers/scsi/scsi_bsg.c:137:36: error: use of undeclared identifier 'io_uri=
ng_sqe_cmd'
drivers/scsi/scsi_bsg.c:203:14: error: incompatible function pointer types =
assigning to 'rq_end_io_fn *' (aka 'enum rq_end_io_ret (*)(struct request *=
, unsigned char, const struct io_comp_batch *)') from 'enum rq_end_io_ret (=
struct request *, blk_status_t)' (aka 'enum rq_end_io_ret (struct request *=
, unsigned char)') [-Wincompatible-function-pointer-types]

***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[axboe@kernel.dk bvanassche@acm.org fujita.tomonori@lab.ntt.co.jp io-uring@=
vger.kernel.org james.bottomley@hansenpartnership.com linux-block@vger.kern=
el.org linux-kernel@vger.kernel.org linux-scsi@vger.kernel.org martin.peter=
sen@oracle.com yangxiuwei@kylinos.cn]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

