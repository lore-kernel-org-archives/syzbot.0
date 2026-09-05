Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7F1B374E79
	for <syzbot@lists.linux.dev>; Sat,  5 Sep 2026 13:29:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788614999; cv=none; b=L+B1j1pSzRGeoWvX8WmxCOtPwjCS7F1zatUN9yQOpK7OaNrbSa4vrkKzVnZNqYo+d+lEXjqpbB9EVIava6ojF8NIUb5HUiJRYoTabXsiYqZU6eFKN6ovbXOzEcU+/tYrirfi6UUA5/d3Cgl50cYjcmgnxIy1o1sJPsYflaGdh9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788614999; c=relaxed/simple;
	bh=SltN6IXvVZySJLNlF9QjGwMOqiRfXZapoOtgvjPGYc4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K/iHstt5+QLhlLrIFJhDZURCBzMm3Cl8SGN7ncM1MvIzN7vzqBb5E0K+TKG0wbhMxMR4yt/sbQ/yxZUHmnu+IHBKU+oycyv8utY4QCvnO7uIa+JvzeH3PdC9XHI86Gzy/eOaWJuCF2u5MgAeQwOaR4mFS45bAkIYHy+k/ztb/1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=p7B57l5C; arc=none smtp.client-ip=209.85.215.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="p7B57l5C"
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-c9aea40d799so1129370a12.0
        for <syzbot@lists.linux.dev>; Sat, 05 Sep 2026 06:29:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788614989; x=1789219789; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=y4u0GWyaTeRSvMtQ0YnsmqSEps2foZyTtNF0hC2tn64=;
        b=p7B57l5CzCzmEdpJ6bcRPzsgv+XscH3kFkxUUW9u0UiGuM14TQIA2BuZAznUl0kXr7
         vBCDu0tt14/Gn+na60DcrHI1Q50Rq5nzfikj6O+eAAICAjMbE2ViLh3eFLkaej/i3NQO
         avi35A7H6HmMRrh8CjtDZ4OK4dXl9r9A1eriWoHe59zksKIm7v/uIdzCO7JUXR3AJoVq
         ng/4T6sp8Epwss2w51m0ZNZPXSr7m98zpP5tuJ6/YwSc8/8v1ahRYi3gHOM6m3TYdnoN
         O8rZTyKQ0IKGv8YKJSn8X6F6yx7qkTQDBItYcMrdX9+ic1s9RCJPMBrwgBtERg/5kzl9
         uxGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788614989; x=1789219789;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=y4u0GWyaTeRSvMtQ0YnsmqSEps2foZyTtNF0hC2tn64=;
        b=OX02QfrRcs5heEqNlQt1h+drS+OpJSuUrYVcWQh2zbAUjuO0YzEQil5XJ3u4q5lUjy
         nAb4nnFwPr5PiqKaXDh5POZxNsgXjcxYse+TRF3t79AWsCZFkEem7UztLFNIBVbqoKDD
         IhUYDyo40gWquxwnzbBS3/7DWELFibmLovsYJnvt270Eew6IufpGbMTHn+d9kP0QcApY
         4vjwrbiQ+Np0nD1AYPRhGctr46VwFNQH4vEW1xSLeyoO3XrjI+07RlKAtCWp6utTtx5Z
         ci/woS6zK3c4LKYXQNUtLEImqucHyU/kCqxMHK2TTpvo0G+Ys2I4d5jMD6Wta+m5VZkF
         FIDw==
X-Gm-Message-State: AFuF++mfsxWW+Q7HVG7rJEyJF0g2bhBJjCO3JwF2uATWzW8e3rVYcDCg
	Uqs+XrUcIc+F+bGcC5rDWGmpgcLNk774nr8B4X5g+9A/3dfOMF31abl2
X-Gm-Gg: AYBFou0eQ2xeTht4PRdumgtstWrfEOVanoF1r+8nHnxNDk9YGd1iIE0+Rio8GO0A/YZ
	4pWC2SNbXngrmIWSHTm0W/tnkKHMYXmfx2hHX9MkIiCF/1pvgb29UmUn0ltUvkA/Kq8wz07qyTw
	GC1vTCrqlRssi+S0i3qiz1YzEB35JHE/EUxHYU9Fe2sVM31lRqkUGNEbHJpwDl5rOAOvO0djUYq
	dWbW6loKwiOodVgic3FdFMWrYcB54mZeMfOiFc54Vm7hfLIpyKj5695DAPolqmDjLGPjn5mCze3
	yJNENxQXjxryccBhzkgWaXxiKebwLkixnCl32J2P3pBKxW3O6p+EmkTbAdb/qJcgKcE7Imy1OHB
	XPV8szns4WmlgmPx1lAABVNex0ZaPi+SA4kUu7/ac7tvAVCeONRbwRUP12AjuxtvpMq5K5WouZP
	XaWg7BAe+ixk72uXk0rostc80C+4wbmNPrESrW0UH3bHlbZeqFALdzUpMVwh84PT7PQBBwZsh3Z
	tGi+0Obi77MUkm+Og/6YA==
X-Received: by 2002:a17:90b:4d06:b0:366:10f1:3d91 with SMTP id 98e67ed59e1d1-39b2614df74mr17583898a91.1.1788614988974;
        Sat, 05 Sep 2026 06:29:48 -0700 (PDT)
Received: from qiwenjie-ThinkCentre-M760t.mioffice.cn ([43.224.245.241])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39b08c397b1sm16146499a91.8.2026.09.05.06.29.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Sep 2026 06:29:47 -0700 (PDT)
From: Wenjie Qi <qwjhust@gmail.com>
To: syzbot+cid5582b8164122eda@syzkaller.appspotmail.com
Cc: syzbot@lists.linux.dev,
	syzkaller-bugs@googlegroups.com,
	jaegeuk@kernel.org,
	chao@kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-kernel@vger.kernel.org,
	hch@lst.de,
	jack@suse.cz,
	axboe@kernel.dk,
	tz2294@columbia.edu,
	baohua@kernel.org,
	linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	qiwenjie@xiaomi.com,
	qwjhust@gmail.com
Subject: [PATCH] f2fs: handle NULL kiocb in write_begin
Date: Sat,  5 Sep 2026 21:29:40 +0800
Message-ID: <5fdd4d960a6b47ab7cfa6ef0f44fb575fc45d1ca.1788611415.git.qiwenjie@xiaomi.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <6a9bbf94.a5e650b3.26d8a.0006.GAE@google.com>
References: <cover.1788438786.git.qiwenjie@xiaomi.com> <6a9bbf94.a5e650b3.26d8a.0006.GAE@google.com>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Wenjie Qi <qiwenjie@xiaomi.com>

The address-space write_begin callback is also used by internal callers
that pass a NULL kiocb, including page_symlink().

Check iocb before propagating IOCB_DONTCACHE into the F2FS-specific folio
lookup flags.

Fixes: cd5bc4fbb900 ("f2fs: enable buffered RWF_DONTCACHE")
Reported-by: syzbot+cid5582b8164122eda@syzkaller.appspotmail.com
Closes: https://ci.syzbot.org/series/cbb9ded8-1388-4a7b-bfa7-44082b04025b
Signed-off-by: Wenjie Qi <qiwenjie@xiaomi.com>
---
#syz test

 fs/f2fs/data.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 6e816c9349a..63625ab3f1e 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -3890,7 +3890,7 @@ static int f2fs_write_begin(const struct kiocb *iocb,
 	block_t blkaddr = NULL_ADDR;
 	int err = 0;
 
-	if (iocb->ki_flags & IOCB_DONTCACHE)
+	if (iocb && iocb->ki_flags & IOCB_DONTCACHE)
 		fgp_flags |= FGP_DONTCACHE;
 
 	trace_f2fs_write_begin(inode, pos, len);
-- 
2.43.0
