Received: from mail-ot1-f69.google.com (mail-ot1-f69.google.com [209.85.210.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6D442931E9
	for <syzbot@lists.linux.dev>; Wed,  7 Oct 2026 02:49:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791341355; cv=none; b=CK3NEAiGy5InyqC6oJ/FaOHW41+ST7vdfzyC3Uuz1RydbVv/mDYflfIF6zvqDvvZZErooFT5pHFBktHfIbGWGJL4qq29cNn/Kga2+Je1/cl+2ygbWNANulCC2CRAU80/rzv2JBFwXprckfe/TjyfNUuvDu5u/iatZmFkzvBG2gU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791341355; c=relaxed/simple;
	bh=+IEr2BTKp2XjqaduRORJhzYXSRJDuQVMpkd0ADJBfRg=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=YPGFoc/ooR0omLa2thFrU1OxutrHbZpEqIY8kZM9JcbBajLNrrJA8KXBEq2q0uNUzJikUIrSnZ2WlImUT2TUkOVGmZPpLXeUYo0fVxuutz0yd9+aJ10F73E5OsCcF59PvrMaXORB5g5F2tMzqhq9PXK13OB5uyKPsvFGno34gZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.210.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f69.google.com with SMTP id 46e09a7af769-82412fd5f11so4924919a34.1
        for <syzbot@lists.linux.dev>; Tue, 06 Oct 2026 19:49:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791341352; x=1791946152;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:date:mime-version:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=UchB3u6jBQU3iT49vlL0+TqEm8u9BLAnOH/RpHKqQE0=;
        b=L74Z3oDdn4lApkF0Qatc+Mswjq0K9ZLuj0ls2cDUxqCfMVBb2M/G6MsujFyLWXcAKe
         A4bicjrhJIZXVlQFLkpwgnLNhzzIo4z6kqKgNS+yPXkOJ/zYReLNwzFAwxRjDUZvqRkc
         1mkbaCK5qLyqpvQf6pz6Mk2P3AiL1piWD9eNO3j+PtdF2UR/lbtHb0bnBz4ELyExNMTi
         Ud6TJEZjZJe+OVkiIr05+w7Vrg7QQg2IrnPgN+nrXO6OapObZwSzA4QQnhph0YuK5t2r
         mnll9SKBNZS0MbKde2Cjj1hW+ADaaA3aEzx6iBDwHfHbUYROs3MWllJlPRfvTQNmiZHF
         UUmw==
X-Gm-Message-State: AFuF++m8NqImuAhaFG+qDlvQ5E2+SUeFr8RJFBW1oQPgWyYv10Y0Ek6u
	KucsDX269dNlrm92ZKVzuKLcu0OnFRRY+be9djkDtnqkk6Upg4ZHza9d6DQunltDSeMZuqUnZZN
	Bc2aSy38YnaDx0q0u7YozFDonTK2SwiemQEOJqyFcL7DV3xWPlT873NLZ88A=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:14c2:b0:490:315d:e0d5 with SMTP id
 5614622812f47-4fc45041d0bmr1260395b6e.16.1791341352555; Tue, 06 Oct 2026
 19:49:12 -0700 (PDT)
Date: Tue, 06 Oct 2026 19:49:12 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6ac5b328.9ad129c8.3ce5b3.0011.GAE@google.com>
Subject: [moderation/CI] Re: Add dmabuf read/write via io_uring
From: syzbot ci <syzbot+ci4ae19a64bceb36f8@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v8] Add dmabuf read/write via io_uring
https://lore.kernel.org/all/cover.1791336002.git.asml.silence@gmail.com
* [PATCH v8 01/13] block: always adjust bi_offset on bio_advance_iter
* [PATCH v8 02/13] block: introduce dma map backed bio type
* [PATCH v8 03/13] block: add dma-buf support for raw bdev
* [PATCH v8 04/13] nvme-pci: rename nvme_pci_sgl_set_data to nvme_pci_dma_i=
ter_set_sgl
* [PATCH v8 05/13] nvme-pci: implement dma-buf backed requests
* [PATCH v8 06/13] nvme seaparate file
* [PATCH v8 07/13] nvme-pci: add SGL support for the dmabuf path
* [PATCH v8 08/13] nvme sgl fixup
* [PATCH v8 09/13] io_uring/rsrc: introduce buf registration structure
* [PATCH v8 10/13] io_uring/rsrc: extend buffer update
* [PATCH v8 11/13] io_uring/rsrc: add uncloneable regbuf flag
* [PATCH v8 12/13] io_uring/rsrc: add regbuf import flags
* [PATCH v8 13/13] io_uring/rsrc: add dmabuf backed registered buffers

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/9e2044d9-8e0f-4dfc-aed6-ad086308f512

***

kernel build error

tree:      axboe
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/axboe/l=
inux.git
base:      c71f470705faa9d1a5ad546aaf3aa3b24de5c188
arch:      amd64
compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp=
1~20260613092250.77), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/d03c4b75-f8db-4210-8ec8-4afca36d93e=
b/config

./include/linux/bio.h:447:32: error: call to undeclared function 'iov_iter_=
is_dmabuf_map'; ISO C99 and later do not support implicit function declarat=
ions [-Wimplicit-function-declaration]

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
[agk@redhat.com akpm@linux-foundation.org anuj20.g@samsung.com asml.silence=
@gmail.com axboe@kernel.dk bmarzins@redhat.com brauner@kernel.org christian=
.koenig@amd.com dm-devel@lists.linux.dev dri-devel@lists.freedesktop.org hc=
h@lst.de io-uring@vger.kernel.org jack@suse.cz joshi.k@samsung.com kbusch@k=
ernel.org linaro-mm-sig@lists.linaro.org linux-block@vger.kernel.org linux-=
fsdevel@vger.kernel.org linux-kernel@vger.kernel.org linux-media@vger.kerne=
l.org linux-nvme@lists.infradead.org matthew.brost@intel.com mpatocka@redha=
t.com nj.shetty@samsung.com sagi@grimberg.me snitzer@kernel.org sumit.semwa=
l@linaro.org tushar.gohad@intel.com viro@zeniv.linux.org.uk william.power@i=
ntel.com]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

