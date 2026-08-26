Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0766472F75
	for <syzbot@lists.linux.dev>; Wed, 26 Aug 2026 16:48:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787762931; cv=none; b=FfGaMX56EjMIJh5G2VrgyuCO0VLWNx8dgnPhiZKJve6G/0F4mbiJhrWmWikqce6EBTGEv/YkzheN7IiGXc2p2qNvOMOn2zT1gS0At5LZ0hupMADTQXemiN5HFzOVADGI6F6OACpAso/TPk4AkQwMvuj0Y18qRTlKwRahkNcbpns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787762931; c=relaxed/simple;
	bh=423MNxyss8Fw4QJuR3IPWxb3/Ec/x+M8lGSmxh0bCUE=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=Uppc+YEcnWiy1rZp793TVpLAVUF0wCQWn41MUijMynGFFMZuMFv0x7y+f+8YWM0+z327d205LssXKkqeBWntZJGwrTV1km/kftjo5JDMGliVM6C0dVB0GgfA1+DJDRgdlDVjeZuN3uZCHTEj31KgbIv8TTJ6CnFt0tTgCViF3Yc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WfFz7Rtf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WfFz7Rtf"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 6D25A1F000E9;
	Wed, 26 Aug 2026 16:48:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787762902;
	bh=jFsXeI/HRw1b4VGLIZ5ZY5hBIXT/b5WFlSLNbhobhsQ=;
	h=From:To:Cc:Subject:Date;
	b=WfFz7RtfQQvSNjQ/V3tAL3Xnixvm1crV+4YrVR7J+ovbsm8OKlhfYxAB0gKpPxguE
	 LYDIEb8baZsAJMyOl51vyvJizy/pUUxLJiGMwBqpIAvxwWT+yac5QmPcd6aUZByuBx
	 P+gikAynF9giLSkNY4Ldo3bN29aiiW7gExPdED9ZKOVn1SD1kenOSmGHM1QQs8uEz2
	 kBr6N36Di8jX5yBf9oA5HPkTAQ0mw+tL1W1duloXi/xJ1qjm5V/4zBqWZMzo1gXPSL
	 IR5SbpT+3fsfnXR8lTLCNMXmuN0WWu4BubpWz8+m+i6juzXlh86ZPbgbkgWiq4wGS7
	 7IIeKvmqYKuXg==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] net/atm: handle ATM_CI_MAX in find_ci() and __vcc_connect()
Message-ID: <d37c9a7b-6c90-48f3-adf7-236efce529d3@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Wed, 26 Aug 2026 16:48:22 +0000 (UTC)

ATM device drivers such as usbatm initialize ci_range.vpi_bits and
ci_range.vci_bits to ATM_CI_MAX (-1), which denotes the maximum standard
bit widths (8 bits for VPI and 16 bits for VCI). When binding or connecting
a PVC socket, __vcc_connect() validates the requested VPI and VCI values by
shifting them right by dev->ci_range.vpi_bits and dev->ci_range.vci_bits.
When these values are -1, shifting by a negative exponent invokes undefined
behavior and triggers a UBSAN shift-out-of-bounds warning:

UBSAN: shift-out-of-bounds in net/atm/common.c:382:32
shift exponent -1 is negative
CPU: 0 UID: 0 PID: 6100 Comm: a.out Not tainted 6.13.0
Call Trace:
 <TASK>
 __ubsan_handle_shift_out_of_bounds+0x36d/0x400 lib/ubsan.c:494
 __vcc_connect+0x14b4/0x19c0 net/atm/common.c:382
 vcc_connect+0x328/0x8f0 net/atm/common.c:498
 pvc_bind+0x272/0x380 net/atm/pvc.c:52
 __sys_bind+0x2e3/0x410 net/socket.c:1951
 __x64_sys_bind+0x7a/0x90 net/socket.c:1954
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
 </TASK>

Furthermore, dynamic VPI/VCI allocation in find_ci() checks loop bounds
using `1 << vcc->dev->ci_range.vpi_bits` and `1 <<
vcc->dev->ci_range.vci_bits`. When these bit widths are -1, signed integer
shifts evaluate to negative values (e.g. INT_MIN on x86 due to shift count
masking), causing boundary comparisons like `p >= 1 << -1` to always
evaluate to true. This repeatedly resets the allocated indices and breaks
dynamic CI allocation, prematurely returning -EADDRINUSE.

Fix this by resolving ATM_CI_MAX to the standard maximum bit widths (8 for
VPI, 16 for VCI) in local variables within find_ci() and __vcc_connect()
before performing bit shifts and range checks. This eliminates the negative
shifts and restores dynamic allocation while leaving dev->ci_range intact
for ATM_GETCIRANGE ioctl queries.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Assisted-by: Gemini:gemini-3.7-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+f6ac161ee9699270b8dd@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=f6ac161ee9699270b8dd
Link: https://syzkaller.appspot.com/ai_job?id=85f31c7a-29ad-45c0-a4e9-c74384abe250
To: "Chas Williams" <3chas3@gmail.com>
To: "David S. Miller" <davem@davemloft.net>
To: "Eric Dumazet" <edumazet@google.com>
To: "Jakub Kicinski" <kuba@kernel.org>
To: <linux-atm-general@lists.sourceforge.net>
To: <netdev@vger.kernel.org>
To: "Paolo Abeni" <pabeni@redhat.com>
To: "Linus Torvalds" <torvalds@ppc970.osdl.org>
Cc: "Simon Horman" <horms@kernel.org>
Cc: <linux-kernel@vger.kernel.org>

---
diff --git a/net/atm/common.c b/net/atm/common.c
index 81195727f..a21439d69 100644
--- a/net/atm/common.c
+++ b/net/atm/common.c
@@ -334,6 +334,10 @@ static int find_ci(const struct atm_vcc *vcc, short *vpi, int *vci)
 	short old_p;
 	int old_c;
 	int err;
+	int vpi_bits = vcc->dev->ci_range.vpi_bits == ATM_CI_MAX ? 8 :
+		       vcc->dev->ci_range.vpi_bits;
+	int vci_bits = vcc->dev->ci_range.vci_bits == ATM_CI_MAX ? 16 :
+		       vcc->dev->ci_range.vci_bits;
 
 	if (*vpi != ATM_VPI_ANY && *vci != ATM_VCI_ANY) {
 		err = check_ci(vcc, *vpi, *vci);
@@ -342,12 +346,12 @@ static int find_ci(const struct atm_vcc *vcc, short *vpi, int *vci)
 	/* last scan may have left values out of bounds for current device */
 	if (*vpi != ATM_VPI_ANY)
 		p = *vpi;
-	else if (p >= 1 << vcc->dev->ci_range.vpi_bits)
+	else if (p >= 1 << vpi_bits)
 		p = 0;
 	if (*vci != ATM_VCI_ANY)
 		c = *vci;
-	else if (c < ATM_NOT_RSV_VCI || c >= 1 << vcc->dev->ci_range.vci_bits)
-			c = ATM_NOT_RSV_VCI;
+	else if (c < ATM_NOT_RSV_VCI || c >= 1 << vci_bits)
+		c = ATM_NOT_RSV_VCI;
 	old_p = p;
 	old_c = c;
 	do {
@@ -358,13 +362,13 @@ static int find_ci(const struct atm_vcc *vcc, short *vpi, int *vci)
 		}
 		if (*vci == ATM_VCI_ANY) {
 			c++;
-			if (c >= 1 << vcc->dev->ci_range.vci_bits)
+			if (c >= 1 << vci_bits)
 				c = ATM_NOT_RSV_VCI;
 		}
 		if ((c == ATM_NOT_RSV_VCI || *vci != ATM_VCI_ANY) &&
 		    *vpi == ATM_VPI_ANY) {
 			p++;
-			if (p >= 1 << vcc->dev->ci_range.vpi_bits)
+			if (p >= 1 << vpi_bits)
 				p = 0;
 		}
 	} while (old_p != p || old_c != c);
@@ -376,10 +380,14 @@ static int __vcc_connect(struct atm_vcc *vcc, struct atm_dev *dev, short vpi,
 {
 	struct sock *sk = sk_atm(vcc);
 	int error;
+	int vpi_bits = dev->ci_range.vpi_bits == ATM_CI_MAX ? 8 :
+		       dev->ci_range.vpi_bits;
+	int vci_bits = dev->ci_range.vci_bits == ATM_CI_MAX ? 16 :
+		       dev->ci_range.vci_bits;
 
 	if ((vpi != ATM_VPI_UNSPEC && vpi != ATM_VPI_ANY &&
-	    vpi >> dev->ci_range.vpi_bits) || (vci != ATM_VCI_UNSPEC &&
-	    vci != ATM_VCI_ANY && vci >> dev->ci_range.vci_bits))
+	    vpi >> vpi_bits) || (vci != ATM_VCI_UNSPEC &&
+	    vci != ATM_VCI_ANY && vci >> vci_bits))
 		return -EINVAL;
 	if (vci > 0 && vci < ATM_NOT_RSV_VCI && !capable(CAP_NET_BIND_SERVICE))
 		return -EPERM;


base-commit: 8d3ae59288f1e7d58d76558a6ee96d533bc5019f
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to Sign-off the patch as a human author
and send it to the upstream kernel mailing lists.
Reply with '#syz reject' to reject it ('#syz unreject' to undo).

See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
You can comment on the patch as usual, syzbot will try to address
the comments and send a new version of the patch if necessary.
syzbot engineers can be reached at syzkaller@googlegroups.com.
