Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED4B43FF1
	for <syzbot@lists.linux.dev>; Fri, 22 May 2026 07:31:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779435091; cv=none; b=aXqo09/CE9xVVAHqzPEjHH6j4rmMn+s3656SzAGBvpPc4COOAlIc6qSj1JiZ+fogdFXvF33h2qrT28sZx5fMSIBCjfPD6a4h/I0GG4VcEdOoNzVSOaRJ9/1siMFnyHwGthSVpBLUlV/hi4QDp5+Lz0Taicd1+cBhhJ4HqsGE+lg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779435091; c=relaxed/simple;
	bh=IF3vUSowAAD+OKaZ3Pl8jgui/j40Ag6EFEQ+sGREZh8=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=ccIkVFPWd5fVWKFIWEg1+fEgIyYQYLGwcdFj4o8LYRthD2AB/eLqEsJA+EXL40Zmlp/zzsaRp4IFdsR0WGJYeV2f71+2c90NatUnMTk2t0EQ54WH9J34WE4DSpluEUGR7oqtuDDb78zVBl6eqw8Gu0P0JAokie5cTlFmiyUDG4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=H9zkK5bE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H9zkK5bE"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id B3FA61F000E9;
	Fri, 22 May 2026 07:31:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779435089;
	bh=2hwWZXI2Ey94ij3BWeKjtS7wkD33yjBLAX/nrddLxFw=;
	h=From:To:Cc:Subject:Date;
	b=H9zkK5bEEu9wnTg7p7k1tLmRwwbhHA1i+GMke0GszqS7xRctyZaKOmgTahR2hDN7q
	 uXQ499ybSmcmFQzqR0sd51OBwB33ZnFXkUdB/8Ge8IBoUb1UizS/fsGryiEuJs0qgC
	 ki3uqqDi0HF5aiARysP9eiiEZDhLrD6LiI8EqQJt3zqQGcyNUYY5iWvShMsMlI0C3h
	 rm0ejhawqCj/epW+Ykml4rqeRnxTj7jAPoYbRl2cSn6Cckw6fjEzjQD9DyNMauYs8E
	 K7EgdghaV7JuUU/Ke7XRbb6HYA7euU6cW5F91nX6tDfi3hzf+/JjuNfQXuOAaqQP/A
	 /y09mLKGM8XMQ==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] ieee802154: fix kernel-infoleak in dgram_recvmsg()
Message-ID: <3d57ee87-f29b-43a2-8e22-2ca4d86cb799@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Fri, 22 May 2026 07:31:29 +0000 (UTC)

KMSAN reports a kernel-infoleak in dgram_recvmsg(). The issue occurs
because the `pan_id` field of the IEEE 802.15.4 MAC header is
unconditionally copied to a socket address structure and subsequently
leaked to user space during a `recvmsg` syscall.

In `dgram_recvmsg()`, the kernel zeroes out a `struct
sockaddr_ieee802154` and then populates it using
`ieee802154_addr_to_sa()`. Inside `ieee802154_addr_to_sa()`, the
`pan_id` is unconditionally copied from the source address to the socket
address.

The source of the uninitialized memory is a local, uninitialized `struct
ieee802154_hdr hdr` variable in `__ieee802154_rx_handle_packet()`. The
header is parsed by `ieee802154_parse_frame_start()`, which eventually
calls `ieee802154_hdr_get_addr()` to extract the destination and source
addresses. If the address mode is `IEEE802154_ADDR_NONE`, the function
returns early and leaves `addr->pan_id` uninitialized (containing stack
garbage).

To fix this issue, explicitly initialize `addr->pan_id` to `0` when the
address mode is `IEEE802154_ADDR_NONE` in `ieee802154_hdr_get_addr()`.
This ensures that no uninitialized stack memory is ever propagated or
copied to user space.

Fixes: 94b4f6c21cf5 ("ieee802154: add header structs with endiannes and operations")
Assisted-by: Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+346474e3bf0b26bd3090@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=346474e3bf0b26bd3090
Link: https://syzkaller.appspot.com/ai_job?id=afe5d617-6767-4025-9746-41a5ff62a35f
To: "Alexander Aring" <alex.aring@gmail.com>
To: "David S. Miller" <davem@davemloft.net>
To: "Eric Dumazet" <edumazet@google.com>
To: "Jakub Kicinski" <kuba@kernel.org>
To: <linux-wpan@vger.kernel.org>
To: "Miquel Raynal" <miquel.raynal@bootlin.com>
To: <netdev@vger.kernel.org>
To: "Paolo Abeni" <pabeni@redhat.com>
To: "Stefan Schmidt" <stefan@datenfreihafen.org>
Cc: "Simon Horman" <horms@kernel.org>
Cc: <linux-kernel@vger.kernel.org>

---
diff --git a/net/ieee802154/header_ops.c b/net/ieee802154/header_ops.c
index 41a556be1..8f2ec62de 100644
--- a/net/ieee802154/header_ops.c
+++ b/net/ieee802154/header_ops.c
@@ -175,8 +175,10 @@ ieee802154_hdr_get_addr(const u8 *buf, int mode, bool omit_pan,
 
 	addr->mode = mode;
 
-	if (mode == IEEE802154_ADDR_NONE)
+	if (mode == IEEE802154_ADDR_NONE) {
+		addr->pan_id = 0;
 		return 0;
+	}
 
 	if (!omit_pan) {
 		memcpy(&addr->pan_id, buf + pos, 2);


base-commit: 5200f5f493f79f14bbdc349e402a40dfb32f23c8
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to Sign-off the patch as a human author
and send it to the upstream kernel mailing lists.
Reply with '#syz reject' to reject it ('#syz unreject' to undo).

See https://github.com/google/syzkaller/blob/master/docs/syzbot_ai_patches.md for information about AI-generated patches.
You can comment on the patch as usual, syzbot will try to address
the comments and send a new version of the patch if necessary.
syzbot engineers can be reached at syzkaller@googlegroups.com.
