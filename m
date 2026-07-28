Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4EC92FFF8B;
	Tue, 28 Jul 2026 10:25:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785234339; cv=none; b=oMATasCK/SvEuTKQBKSJFvGN0D5Y2fYISh4CqXoG/yQYMOUBzchq0n/WhnjnQ2CwcRRh1bPAZN0o+0kkRYrIGb4drTUESEXbA6A+37wtB3AK9zuAXRmYHCBKk3uITPs/a7n//jHWw+FnYkaJDuwZPmF7D9DakkUHN02fsm0cxFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785234339; c=relaxed/simple;
	bh=kcEkfz+ZCfXOsIXQnsOGf3nIuYdKTGxilPpWgHEMF58=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=r8xMayaoqULS/bsNXdXh4IWEvasFw0HMHBGFP3mB7mjO1Laov8h7MAwOdqtV6/kv0stBeDOGnWrq/5ny1MHPIwLge8cfSDQps2QGWtOhwk8krM2KL6TFefQaNb42OcAQtd2X10ogRWJKaWZCk0ZQxEC4Jx/DTx6DOOYsa/4dN18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cRqtQzUS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cRqtQzUS"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 133301F000E9;
	Tue, 28 Jul 2026 10:25:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785234337;
	bh=hJu0lR51o8IvVMj4GsYy7qbL2iP0dJ6hZ1TdUfXicZo=;
	h=From:To:Cc:Subject:Date;
	b=cRqtQzUSP2JpAg9qVda8W4+cWbnVJx4SMHm2bUrE1080ecz0HwcvoMsQa+/YTG0+t
	 9hUUeULaJXAJx3OCsCcovDPCQ4qBQiCg0B+2p8RyEkgsam9PrGEuarm3waq8X4CR+R
	 3Q2i4++NvNAByHzjUoTlAuPaF/QipU3EMYTE0cTzsGMtpcGClZ/qbNQb6/Ogz29aTM
	 ZrBXbi9qOPc0sGH8/mE9o6HaWGJUxmRvuwsD43u6NpKDQOHNzNA/lP5w4n5yUMz/fr
	 /AXqMJ5R4tFEGiH82GeEaiQyd/ScrpEiiqnas0brsvfqz6OVIul5FH7BcJWtst+WE8
	 n+g7n2IC0BeVQ==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-bugs@googlegroups.com, Krystian Kaniewski <krystianmkaniewski@gmail.com>, "Jens Axboe" <axboe@kernel.dk>, "Josef Bacik" <josef@toxicpanda.com>, <linux-block@vger.kernel.org>, <nbd@other.debian.org>, "Christoph Hellwig" <hch@lst.de>
Cc: linux-kernel@vger.kernel.org, syzbot@lists.linux.dev
Subject: [PATCH] nbd: skip queue limits update for size-only reconfigure
Message-ID: <1ec17dae-f9ac-424a-b597-b2794f157dbb@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Tue, 28 Jul 2026 10:25:37 +0000 (UTC)

From: Krystian Kaniewski <krystianmkaniewski@gmail.com>

Commit 242a49e5c878 ("nbd: freeze the queue for queue limits updates")
correctly added queue freezing for live updates of real queue limits.
However, nbd_set_size() is also used for capacity-only generic netlink
updates, so the freeze is unnecessarily broad for the reported request.

When an NBD server becomes unresponsive, it leaves I/O in flight. An
unnecessary queue freeze during a size-only reconfigure will wait forever
for these in-flight I/Os to complete while the global genl_mutex is held,
leading to a global generic netlink stall.

A size-only reconfigure can update config->bytesize and disk capacity
directly because the effective block size and all other queue limits stay
unchanged.

This patch introduces nbd_size_set() to handle size-only updates directly
without freezing the queue or committing queue limits. Capacity-only
generic netlink reconfiguration no longer freezes the queue, while startup
and real block-size changes continue to use the existing frozen limits
update via nbd_set_size().

Fixes: 242a49e5c878 ("nbd: freeze the queue for queue limits updates")
Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot <syzbot+f272bbfbf8498ddadea5@syzkaller.appspotmail.com>
Closes: https://syzkaller.appspot.com/bug?extid=f272bbfbf8498ddadea5
Link: https://syzkaller.appspot.com/ai_job?id=786b3bd0-fdad-4252-9e86-7a6a35c3b756
Signed-off-by: Krystian Kaniewski <krystianmkaniewski@gmail.com>

---
diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index fe63f3c55..567b031ec 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -331,6 +331,27 @@ static void nbd_mark_nsock_dead(struct nbd_device *nbd, struct nbd_sock *nsock,
 	nsock->sent = 0;
 }
 
+static void nbd_size_update(struct nbd_device *nbd)
+{
+	struct nbd_config *config = nbd->config;
+
+	if (max_part)
+		set_bit(GD_NEED_PART_SCAN, &nbd->disk->state);
+	if (!set_capacity_and_notify(nbd->disk, config->bytesize >> 9))
+		kobject_uevent(&nbd_to_dev(nbd)->kobj, KOBJ_CHANGE);
+}
+
+static int nbd_size_set(struct nbd_device *nbd, loff_t bytesize)
+{
+	if (bytesize < 0)
+		return -EINVAL;
+
+	nbd->config->bytesize = bytesize;
+	if (nbd->pid)
+		nbd_size_update(nbd);
+	return 0;
+}
+
 static int nbd_set_size(struct nbd_device *nbd, loff_t bytesize, loff_t blksize)
 {
 	struct queue_limits lim;
@@ -375,10 +396,7 @@ static int nbd_set_size(struct nbd_device *nbd, loff_t bytesize, loff_t blksize)
 	if (error)
 		return error;
 
-	if (max_part)
-		set_bit(GD_NEED_PART_SCAN, &nbd->disk->state);
-	if (!set_capacity_and_notify(nbd->disk, bytesize >> 9))
-		kobject_uevent(&nbd_to_dev(nbd)->kobj, KOBJ_CHANGE);
+	nbd_size_update(nbd);
 	return 0;
 }
 
@@ -2062,11 +2080,19 @@ static int nbd_genl_size_set(struct genl_info *info, struct nbd_device *nbd)
 	if (info->attrs[NBD_ATTR_SIZE_BYTES])
 		bytes = nla_get_u64(info->attrs[NBD_ATTR_SIZE_BYTES]);
 
-	if (info->attrs[NBD_ATTR_BLOCK_SIZE_BYTES])
+	if (info->attrs[NBD_ATTR_BLOCK_SIZE_BYTES]) {
 		bsize = nla_get_u64(info->attrs[NBD_ATTR_BLOCK_SIZE_BYTES]);
+		if (!bsize)
+			bsize = 1u << NBD_DEF_BLKSIZE_BITS;
+		if (blk_validate_block_size(bsize))
+			return -EINVAL;
+	}
 
-	if (bytes != config->bytesize || bsize != nbd_blksize(config))
-		return nbd_set_size(nbd, bytes, bsize);
+	if (bytes != config->bytesize || bsize != nbd_blksize(config)) {
+		if (bsize != nbd_blksize(config))
+			return nbd_set_size(nbd, bytes, bsize);
+		return nbd_size_set(nbd, bytes);
+	}
 	return 0;
 }
 


base-commit: 8cd9520d35a6c38db6567e97dd93b1f11f185dc6
-- 
See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
You can comment on the patch as usual, syzbot will try to address
the comments and send a new version of the patch if necessary.
syzbot engineers can be reached at syzkaller@googlegroups.com.
