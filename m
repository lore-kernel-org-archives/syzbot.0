Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 299B23191D6;
	Fri,  7 Aug 2026 14:25:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786112728; cv=none; b=elVWuLWAYWbMWlCfKsnK2fpGQg3T1eGAd6pJKOoC6iKhJilha3sdGNWcDCeRjnSCJG0Tj5jAZrCJGA6PsqdejR1PkJPP2q8vHaiJbE8TfKi0le7mk93dZkcKeOLVplsHCSInPXQx+2S3JUmzsY/axAVeFczFEovg7SGW05PARBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786112728; c=relaxed/simple;
	bh=6uB8OWGDpym6y9oJ5qxsX//ZJFpXKbzjj/VL1bHouGI=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=Pmdo/m/StBM5rz3uuZSYx6QsdeomcRZ9LNKi9ujb23bYGh/WTDv8Rp1Q9DPs0Ms2iKiHMD+8xWLaxtvSzbwAtzbqRcXODEwZEiXEDrj1XZ7y1gGh2UPBfqcTfcXqpLE80OaUdslycdUURcAexGEqjpr8RNykkiUHzAtoQHnYHUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WsGoffZ9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WsGoffZ9"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 796871F000E9;
	Fri,  7 Aug 2026 14:25:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786112726;
	bh=P2Hsg1cdmQwQMSFF8/2gaSQ0nlfQSkMtLeSn0RlCfJM=;
	h=From:To:Cc:Subject:Date;
	b=WsGoffZ9aRBHc/D9e3a1UTjFZYbEVYEIVd33nFgJWvd05XbSdyLb6Dhwfn+kVcNTf
	 zdmnP66eQU0wvkkxbwexWodc7a4kTGZoAirDmIZp97GIaizl1aQrjv5H5JhUmN1UpE
	 VfVvSrxPl1SUEaBwJ145jtfDAFlTzr5lEN2QswfT06kfkZA/nzXJpf8d7pV/Fjhm0M
	 5zq2N3/nDyfEmSGAp+HEl+MW7DtXlS2388nS4Ab/lvhdF/eJByTEhB1V561JkEv5Wi
	 MrPmsuVkJqUmHFl6f2XVUNjyztpd2+8OQdy9jgMernNq0YwJnQ3PMlaHhFyFYPbPzI
	 N4f6x5A5KnTZg==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-bugs@googlegroups.com, Aleksandr Nogikh <nogikh@google.com>, <linux1394-devel@lists.sourceforge.net>, "Takashi Sakamoto" <o-takashi@sakamocchi.jp>
Cc: linux-kernel@vger.kernel.org, syzbot@lists.linux.dev
Subject: [PATCH] firewire: ohci: fix NULL pointer dereference in ar_context_release
Message-ID: <90c5db71-dd1f-4d46-b9d3-2f1046cbd5ea@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Fri,  7 Aug 2026 14:25:26 +0000 (UTC)

From: Aleksandr Nogikh <nogikh@google.com>

During the error handling path of the driver's probe function, a NULL
pointer dereference can occur in ar_context_release().

When pci_probe() fails early (e.g., if pcim_enable_device() or MMIO mapping
fails), the devres cleanup mechanism invokes release_ohci(). This function
unconditionally calls ar_context_release() to clean up the asynchronous
receive contexts. However, if ar_context_init() was not yet called,
ctx->ohci remains NULL (as the fw_ohci structure is zero-initialized by
devres_alloc()).

ar_context_release() immediately dereferences ctx->ohci to get the dev
pointer before checking if the context was actually initialized, leading to
a crash:

Oops: general protection fault, probably for non-canonical address
0xdffffc0000000001: 0000 [#1] SMP KASAN NOPTI
KASAN: null-ptr-deref in range [0x0000000000000008-0x000000000000000f]
RIP: 0010:ar_context_release+0x3f/0x380 drivers/firewire/ohci.c:543
Call Trace:
 release_ohci+0x3f/0x60 drivers/firewire/ohci.c:3567
 release_nodes drivers/base/devres.c:546 [inline]
 devres_release_all+0x1a8/0x260 drivers/base/devres.c:576
 device_unbind_cleanup drivers/base/dd.c:597 [inline]
 really_probe+0x451/0xae0 drivers/base/dd.c:772

To fix this, move the assignment of the dev pointer after the !ctx->buffer
check. If ctx->buffer is NULL, it indicates that the context was never
successfully initialized and there is nothing to release, safely avoiding
the dereference of the uninitialized ctx->ohci pointer.

Fixes: 5716e58aecdd ("firewire: ohci: release buffer for AR req/resp contexts when managed resource is released")
Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+d30aad27833a559defab@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=d30aad27833a559defab
Link: https://syzkaller.appspot.com/ai_job?id=10a18617-7893-42dd-bf1c-cd49e19e95d9
Signed-off-by: Aleksandr Nogikh <nogikh@google.com>

---
diff --git a/drivers/firewire/ohci.c b/drivers/firewire/ohci.c
index 8153d62c5..e947227e0 100644
--- a/drivers/firewire/ohci.c
+++ b/drivers/firewire/ohci.c
@@ -540,11 +540,13 @@ static void ar_context_link_page(struct ar_context *ctx, unsigned int index)
 
 static void ar_context_release(struct ar_context *ctx)
 {
-	struct device *dev = ctx->ohci->card.device;
+	struct device *dev;
 
 	if (!ctx->buffer)
 		return;
 
+	dev = ctx->ohci->card.device;
+
 	for (int i = 0; i < AR_BUFFERS; ++i) {
 		dma_addr_t dma_addr = ctx->dma_addrs[i];
 		if (dma_addr)


base-commit: 075b74841bd0065a3bda3440873c747938e69b68
-- 
See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
The person who has signed off on the patch is responsible for
addressing comments.
syzbot engineers can be reached at syzkaller@googlegroups.com.
