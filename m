Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEF9C201004
	for <syzbot@lists.linux.dev>; Sat, 23 May 2026 03:49:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779508173; cv=none; b=WB8NiwhXy9avelP2LT8RwRqlyBZS+6EA10X1iABuwhBl3GLmSRcNoH3DZbeuFAc3WojrAVC20Emlv2mja2r14FxPiyfJ4Mm3SradjiHgyQ/DO5W06E/1pA3O8j45vhreZXZBkdvC7Q9m1JoyJamkpYdjCDrd3rCl6Vj2wyZjAU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779508173; c=relaxed/simple;
	bh=RVvghwjz2v9F9PoCQtV3EQLlIskD8Yf+jzQ198IkktY=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=fGYHvDUQp5i7nDnvpRw5QFnFj1MkRapztlZNVwFGGGc3z/9c8hcfp9vjMsvAdXxZAwERnAKz8+ktU3Z9Aa50jsWU3DxsxfO/sih5O/nz8WGVgiRu3UG5yZ8bd2ux6jsxev9nptAXNQtJ5oj8NB3YeiNvs1oUF6xu6PdCgOsuiks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dtE1b5np; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dtE1b5np"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 2DC051F000E9;
	Sat, 23 May 2026 03:49:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779508172;
	bh=r+Mh+oSF+gjK8FZ0axyOXwR7mXc4DZyKz65TEV0Ju2w=;
	h=From:To:Cc:Subject:Date;
	b=dtE1b5np0TMzsZRgPVamLHJubsFNiZRPjbtzuuJWdfGZMDWIyvYNrXT68owPCL0cb
	 ez7wI3F4ECrFSiB/yMHQOv2HwhZkEJpWnojl2TMklJkKuK0rOYgxUu6C+4kvWSxxLR
	 6+9WIyhdSaCtwUZbzgNByAuFcjUwaN5WmAk6CaFOnd/NuysuWAB8vXicfaIqnt8Ymj
	 NuwA152zL0NE8kwz647rIznU35dYZt8v0Ffiks467IAwauIn8qo2m0eQd/ggjVv++/
	 N2NcXsHFVG3UolKzATbH1Rc9DdNYAb/op/DQNxCJ3o0JmrKWoIXB0sq95CNFVOsAGU
	 KDvXHfKXDD8CQ==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC v2] ieee802154: fix kernel-infoleak in dgram_recvmsg()
Message-ID: <127f2164-d295-47e9-95c4-31959dcc8460@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Sat, 23 May 2026 03:49:32 +0000 (UTC)

KMSAN reported a kernel-infoleak in move_addr_to_user():

BUG: KMSAN: kernel-infoleak in instrument_copy_to_user
include/linux/instrumented.h:131 [inline]
BUG: KMSAN: kernel-infoleak in _inline_copy_to_user
include/linux/uaccess.h:205 [inline]
BUG: KMSAN: kernel-infoleak in _copy_to_user+0xcc/0x120
lib/usercopy.c:26
 instrument_copy_to_user include/linux/instrumented.h:131 [inline]
 _inline_copy_to_user include/linux/uaccess.h:205 [inline]
 _copy_to_user+0xcc/0x120 lib/usercopy.c:26
 copy_to_user include/linux/uaccess.h:236 [inline]
 move_addr_to_user+0x2e7/0x440 net/socket.c:302
 ____sys_recvmsg+0x232/0x610 net/socket.c:2925
 ...
 Uninit was stored to memory at:
 ieee802154_addr_to_sa include/net/ieee802154_netdev.h:369 [inline]
 dgram_recvmsg+0xa09/0xbe0 net/ieee802154/socket.c:739

The issue occurs because the `pan_id` field of `struct ieee802154_addr`
is left uninitialized when the address mode is `IEEE802154_ADDR_NONE`.
The execution flow is as follows:

1. `__ieee802154_rx_handle_packet()` declares a local `struct
ieee802154_hdr hdr` on the stack.
2. `ieee802154_hdr_pull()` calls `ieee802154_hdr_get_addr()` to parse
the source and destination addresses into this structure.
3. If the address mode is `IEEE802154_ADDR_NONE`,
`ieee802154_hdr_get_addr()` previously only set the `mode` field,
leaving the `pan_id` field containing uninitialized stack memory.
4. This uninitialized `pan_id` is later copied into a `struct
sockaddr_ieee802154` in `dgram_recvmsg()` via `ieee802154_addr_to_sa()`.
5. Finally, `move_addr_to_user()` copies the socket address structure to
user space, leaking the uninitialized bytes.

Fix this by using `memset` to zero out the address structure in
`ieee802154_hdr_get_addr()` when the mode is `IEEE802154_ADDR_NONE`.

Fixes: 94b4f6c21cf5 ("ieee802154: add header structs with endiannes and operations")
Assisted-by: Gemini:gemini-3.1-pro-preview Gemini:gemini-3-flash-preview syzbot
Reported-by: syzbot+346474e3bf0b26bd3090@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=346474e3bf0b26bd3090
Link: https://syzkaller.appspot.com/ai_job?id=a507a109-d683-4a2c-bc03-93394f491b17
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
v2:
- Zero out the entire address structure using memset when the mode is IEEE802154_ADDR_NONE.
- Include the KMSAN error report in the commit description.
- Add a step-by-step explanation of how the uninitialized memory is propagated to user space.

v1:
https://lore.kernel.org/all/3d57ee87-f29b-43a2-8e22-2ca4d86cb799@mail.kernel.org/T/
---
diff --git a/net/ieee802154/header_ops.c b/net/ieee802154/header_ops.c
index 41a556be1..a9f0c8df5 100644
--- a/net/ieee802154/header_ops.c
+++ b/net/ieee802154/header_ops.c
@@ -173,10 +173,13 @@ ieee802154_hdr_get_addr(const u8 *buf, int mode, bool omit_pan,
 {
 	int pos = 0;
 
-	addr->mode = mode;
-
-	if (mode == IEEE802154_ADDR_NONE)
+	if (mode == IEEE802154_ADDR_NONE) {
+		memset(addr, 0, sizeof(*addr));
+		addr->mode = IEEE802154_ADDR_NONE;
 		return 0;
+	}
+
+	addr->mode = mode;
 
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
