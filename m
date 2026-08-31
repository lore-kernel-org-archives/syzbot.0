Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07EF84A0123
	for <syzbot@lists.linux.dev>; Mon, 31 Aug 2026 14:40:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=100.103.45.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788187254; cv=pass; b=K6F74hxI+ADxl287r/XoeglDfYvM73sA1AhDbqb8+J2iZWZW/mcBNopb5mmBdlolwzS805Ut4fnepfKWYpSIggYZyoL7P41+yxwaxE8aMGo+pYZZIjHpNQJpdOsLNiMktNFuF2Eeq11zB0b+jgd2bFb/BTFZKhqu9YpqCJ8UYPw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788187254; c=relaxed/simple;
	bh=kzLXRzqa+6/0FUZulDYpxaLyLkJaimYvFiG5Xdn9Gpo=;
	h=Subject:From:To:MIME-Version:Content-Type:Message-ID:Date; b=P8z1dpYOpO2tWKMPQ8ZJjDTGj5E3V0i42o1GHqN7QJ6iidSTYERgcPIaxx7xlwQYLEhiI3PF7SYVb+7KJg+v9dn/N5bElj6+MIZxtsWOMXJSpxwMreOJ69AMe833oyhqpUNGWoixD/YYMcyureLUGtZb43pUiuRN8PXUfkV51JI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=lists.sourceforge.net header.i=@lists.sourceforge.net header.b=gOJj6Qby; arc=pass smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=lists.sourceforge.net header.i=@lists.sourceforge.net header.b="gOJj6Qby"
Received: by smtp.kernel.org (Postfix)
	id C0E9B1F00A3D; Mon, 31 Aug 2026 14:40:52 +0000 (UTC)
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=216.105.38.7
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1788187252;
	b=h3YeO720EtP9ccoB2djdCO8nhXTr1hJ5x+jS4VJ4jOIeEvg6Mi1MG9RIwEUOC2MWXCKw
	 FZN3lRGg5/vD+r2OdsizaCmAVb3NqULesqZvo7i+U3OPL2n3Vg7M755JbAsqkXFvzz8n9
	 pJfguYdoRHTi4NFGNGRnFZ26/tCE/hLpSdQAQU9UvCfl7gzxJhReb55UCVUbF2B7tv/bh
	 0zOM/S7NcuzwQhXMU7IIWzVpBLQphCErQRbLR3zu+6sVdmsHg98WiejlwOUjo2adVhuOE
	 bgiWeSlr6CsQhXS5chOUa3qOPyUQhfQWxUAg0D5J6ZMQunmpJz/CqsXMQQD1NslTltg==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1788187252;
	h=DMARC-Filter:DKIM-Signature:Received:Subject:From:To:MIME-Version:
	 Content-Type:Message-ID:Date:Precedence:X-BeenThere:X-Mailman-Version:
	 List-Id:X-List-Administrivia:Errors-To;
	bh=f9a22850AIj9DWRwYByLQzx8gq/u+ikUdTRcg4u6zqs=;
	b=XkNJW24H8ZSQBY8fkmgIQP8+jAsYIGz0cP/lIfOp2+xPpSzM1k43CNNxm8PVq1ep2TsO
	 9qt6OVLHiFvlaHNsLciCwHbbv82tJpgzB+VhsJrNKD2xUfTJnOrEL9VCWcYEUAakYaYcz
	 z4ZupjJh3/dJDj9rjbYfRZB1w/whpstnznKNmD+eWYmpzo0x68PHp1m9PTVPtBqoiAlnC
	 Veo3VVn1zShS+Gcf2Rdm7m7DS5khJkXNpoSvO0Du55g2nIvz/dwKesCSnXmJeV5rRFylq
	 NgeUYAUAWfOrZdTFa0Rnw6nG7jLyZYVSByitFb0LCUX0vXAILnRecURF9KQHAY8C5Cw==
ARC-Authentication-Results: i=1; smtp.kernel.org; dkim=pass header.d=lists.sourceforge.net header.i=@lists.sourceforge.net header.a=rsa-sha256 header.s=beta header.b=gOJj6Qby;
	dmarc=pass header.from=lists.sourceforge.net;
	spf=pass smtp.mailfrom=lists.sourceforge.net;
	arc=none smtp.remote-ip=216.105.38.7
Received: from lists.sourceforge.net (lists.sourceforge.net [216.105.38.7])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 2B2401F000E9
	for <syzbot@kernel.org>; Mon, 31 Aug 2026 14:40:52 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=lists.sourceforge.net header.i=@lists.sourceforge.net header.a=rsa-sha256 header.s=beta header.b=gOJj6Qby
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.kernel.org 2B2401F000E9
Authentication-Results: smtp.kernel.org; dmarc=pass (p=none dis=none) header.from=lists.sourceforge.net
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=lists.sourceforge.net
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=lists.sourceforge.net; s=beta; h=List-Id:Date:Message-ID:Content-Type:
	MIME-Version:To:From:Subject:Sender:Reply-To:Cc:Content-Transfer-Encoding:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=f9a22850AIj9DWRwYByLQzx8gq/u+ikUdTRcg4u6zqs=; b=gOJj6QbydWc9Nlwc5oTT6B4I3H
	aPbIa7A96db461FKYlw1nzPd61+1cYPSn1wAbDFrgZYy16jylELi0+ERn9yYfveylHu7QZ5lTMLj6
	acPJfI+OcmRm1HCmMm7eVTarpik4et/jtN2H+HG26ArEJtrBF8HWMZCADTDMVf5i5W1M=;
Received: from [127.0.0.1] (helo=sfs-ml-1.v29.lw.sourceforge.com)
	by sfs-ml-1.v29.lw.sourceforge.com with esmtp (Exim 4.95)
	(envelope-from <accessrunner-general-bounces@lists.sourceforge.net>)
	id 1x13Bu-0001qf-32
	for syzbot@kernel.org;
	Mon, 31 Aug 2026 14:40:51 +0000
Subject: [PATCH] usb: atm: cxacru: fix NULL pointer dereference on
 uninitialized atm_dev
From: accessrunner-general-owner@lists.sourceforge.net
To: syzbot@kernel.org
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="===============2050781004579442797=="
Message-ID: <mailman.36331.1788187251.1621.accessrunner-general@lists.sourceforge.net>
Date: Mon, 31 Aug 2026 14:40:51 +0000
Precedence: bulk
X-BeenThere: accessrunner-general@lists.sourceforge.net
X-Mailman-Version: 2.1.21
X-List-Administrivia: yes
Errors-To: accessrunner-general-bounces@lists.sourceforge.net

--===============2050781004579442797==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

Your message has been rejected, probably because you are not
subscribed to the mailing list and the list's policy is to prohibit
non-members from posting to it.  If you think that your messages are
being rejected in error, contact the mailing list owner at
accessrunner-general-owner@lists.sourceforge.net.


--===============2050781004579442797==
Content-Type: message/rfc822
MIME-Version: 1.0

Received: from [172.30.29.66] (helo=mx.sourceforge.net)
	by sfs-ml-1.v29.lw.sourceforge.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <syzbot@kernel.org>)
	id 1x13Bt-0001qW-7g;
	Mon, 31 Aug 2026 14:40:50 +0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sourceforge.net; s=x; h=Date:Content-Transfer-Encoding:Content-Type:
	MIME-Version:Message-ID:Subject:Cc:To:From:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=glU5brsq9stFhaeEUTYuaXur4gpoMrHcD9Sa+u8+sdg=; b=WiP2jGfYMN3XdFkSbbO/BFh7fA
	NifP0wmRE4R2eS9HdssJ1PGKnQIxz0rmODYi61WZwINaIocv7hSYdDy2UK8tJYXw77JPDNoK2Bzei
	S4ClY4vKgOsk844Pj493Qlnp5gQtIBO96scZmZufSOwnVcvAkudDFLCPgbpLuL5Q5Oew=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
	; h=Date:Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:
	Subject:Cc:To:From:Sender:Reply-To:Content-ID:Content-Description:Resent-Date
	:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:
	References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:List-Post:
	List-Owner:List-Archive; bh=glU5brsq9stFhaeEUTYuaXur4gpoMrHcD9Sa+u8+sdg=; b=D
	Ags0Y8/V57KpvfDUcplMoKYWNDI471pbvCbBHtH9MWkIW2NUYelbL/P/KtI2Fvuteadzj8YeuEDv6
	VJU6Y2TRR0CpvEbGw/10VlLHEQlQ9zg5mHhinUKWO37qDvbgmjnK5YhuGB8YJqpjpEu00u2b7hPyR
	OFKDBoMMY5iswRF0=;
Received: from tor.source.kernel.org ([172.105.4.254])
	by sfi-mx-2.v28.lw.sourceforge.com with esmtps (TLS1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
	(Exim 4.95)
	id 1x13Bo-0004t7-Uu;
	Mon, 31 Aug 2026 14:40:50 +0000
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with UTF8SMTP id 3FD4E60120;
	Mon, 31 Aug 2026 14:40:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 769651F000E9;
	Mon, 31 Aug 2026 14:40:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788187243;
	bh=glU5brsq9stFhaeEUTYuaXur4gpoMrHcD9Sa+u8+sdg=;
	h=From:To:Cc:Subject:Date;
	b=hfJBce/fvMIR4mLQ4PXQ3TRh9fkfE4WBk2bYRVZ/iYYtplkxC3nwZMky4QTC5BLVI
	 rPSzFKiGkQLoJ5WSVkzb9XC/I4n/OFEHTVNdKE8aaujzRwWgR154mDedpth9LTnhHv
	 dizKdiUKcuNtNuqDIvaevQ7g94iF6667dQOy+kzY3qdiLiCSzWFfKJn8Mw3CVeiW6X
	 lq7XAD0p/TzzLwGKcgVe4wmjr5Lcu5JPOpgmxAHTnjGKZhWTBKdjmsZQttCykmWI05
	 apiXUI8LXhjQoiOGeVnZLxQKusOXa2e1MRslSbEXjll5ShMj3AGMecd9ZwCDWn5jce
	 jU0CQydiPoXMQ==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-bugs@googlegroups.com, "Wang, Jie" <jie.wang@intel.com>, "Chas Williams" <3chas3@gmail.com>, <accessrunner-general@lists.sourceforge.net>, "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>, <linux-atm-general@lists.sourceforge.net>, <linux-usb@vger.kernel.org>, <netdev@vger.kernel.org>
Cc: linux-kernel@vger.kernel.org, syzbot@lists.linux.dev
Subject: [PATCH] usb: atm: cxacru: fix NULL pointer dereference on uninitialized atm_dev
Message-ID: <f3ef0a67-79d7-47da-be6e-7e82d92e68fe@mail.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Mon, 31 Aug 2026 14:40:42 +0000 (UTC)
X-Spam-Score: -0.2 (/)
X-Spam-Report: Spam detection software, running on the system "sfi-spamd-1.hosts.colo.sdot.me",
 has NOT identified this incoming email as spam.  The original
 message has been attached to this so you can view it or label
 similar future email.  If you have any questions, see
 the administrator of that system for details.
 
 Content preview:  From: "Wang, Jie" <jie.wang@intel.com> The cxacru driver uses
    the usbatm framework, which defers the ATM device registration to a kernel
    thread (usbatm_do_heavy_init()) but immediately returns success from the
   USB probe. Because the probe [...] 
 
 Content analysis details:   (-0.2 points, 5.0 required)
 
  pts rule name              description
 ---- ---------------------- --------------------------------------------------
 -0.1 DKIM_VALID_AU          Message has a valid DKIM or DK signature from author's
                             domain
 -0.1 DKIM_VALID             Message has at least one valid DKIM or DK signature
 -0.1 DKIM_VALID_EF          Message has a valid DKIM or DK signature from
                             envelope-from domain
  0.1 DKIM_SIGNED            Message has a DKIM or DK signature, not necessarily valid
X-Headers-End: 1x13Bo-0004t7-Uu

From: "Wang, Jie" <jie.wang@intel.com>

The cxacru driver uses the usbatm framework, which defers the ATM device
registration to a kernel thread (usbatm_do_heavy_init()) but immediately
returns success from the USB probe. Because the probe returns success, the
driver core creates sysfs attribute files (like adsl_state and
adsl_config), making them accessible to userspace before the ATM device is
fully initialized.

If a user writes to these sysfs files before the initialization is complete
or if it fails, the driver attempts to send a command to the device. If the
command fails, the error handling path calls atm_err(), which
unconditionally dereferences instance->usbatm->atm_dev. Since atm_dev is
NULL, this leads to a NULL pointer dereference:

Oops: general protection fault, probably for non-canonical address
0xdffffc0000000002: 0000 [#1] SMP KASAN NOPTI
KASAN: null-ptr-deref in range [0x0000000000000010-0x0000000000000017]
RIP: 0010:adsl_state_store+0x5cc/0x770 drivers/usb/atm/cxacru.c:359
Call Trace:
 <TASK>
 kernfs_fop_write_iter+0x3a4/0x540 fs/kernfs/file.c:345
 new_sync_write fs/read_write.c:595 [inline]
 vfs_write+0x612/0xba0 fs/read_write.c:687
 ksys_write+0x150/0x270 fs/read_write.c:739
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
 </TASK>

To fix this, add checks for instance->usbatm->atm_dev == NULL in
adsl_state_store() and adsl_config_store(). This prevents the functions
from proceeding and dereferencing the uninitialized atm_dev, consistent
with how mac_address_show() handles the same race condition.

Fixes: e605c30977bb ("USB: atm: cxacru: convert to use dev_groups")
Assisted-by: Gemini:gemini-3.6-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+9b195c4f412ea5c4e56a@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=9b195c4f412ea5c4e56a
Link: https://syzkaller.appspot.com/ai_job?id=b6352d63-d03a-4e87-92a4-b334c3ebcf97
Signed-off-by: "Wang, Jie" <jie.wang@intel.com>

---
diff --git a/drivers/usb/atm/cxacru.c b/drivers/usb/atm/cxacru.c
index 429ac20a8..dee15f7b7 100644
--- a/drivers/usb/atm/cxacru.c
+++ b/drivers/usb/atm/cxacru.c
@@ -347,7 +347,7 @@ static ssize_t adsl_state_store(struct device *dev,
 		return -EINVAL;
 	ret = 0;
 
-	if (instance == NULL)
+	if (instance == NULL || instance->usbatm->atm_dev == NULL)
 		return -ENODEV;
 
 	if (mutex_lock_interruptible(&instance->adsl_state_serialize))
@@ -444,7 +444,7 @@ static ssize_t adsl_config_store(struct device *dev,
 	if (!capable(CAP_NET_ADMIN))
 		return -EACCES;
 
-	if (instance == NULL)
+	if (instance == NULL || instance->usbatm->atm_dev == NULL)
 		return -ENODEV;
 
 	pos = 0;


base-commit: 8d3ae59288f1e7d58d76558a6ee96d533bc5019f
-- 
See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
The person who has signed off on the patch is responsible for
addressing comments.
syzbot engineers can be reached at syzkaller@googlegroups.com.


--===============2050781004579442797==--
