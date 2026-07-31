Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2346F3DA7D6;
	Fri, 31 Jul 2026 10:15:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785492936; cv=none; b=gaU0W50XBhA7PL4ATUmkwN0S3cNU0DR8FlmomN1kfDvNuOoRQ69e1xidKoWXz0D1DN6hTDzUMAuI2nKuqzi60DGfbDZw5+4gT7AJBSdkOIE4JOWqNFoY+IYP1VNXskIEL7yZrMdrozuT3V9DdlMoUNFMxQTIKSJUc4IYe2MwEIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785492936; c=relaxed/simple;
	bh=iKGZZoPiLZbpP6fqsFth6A6aZtjn2VQzfx5vDbpAxLA=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=NiRs0jC0i7X5aOIpUN0CGPPmPbGwbFevOTjdbk5M0LiQEp6znOrrsUzrx2dGG3JNf9adOBizM9uF/SvE8fY6KzPEjKLelFwXrpiBF4bdjf76PAe0i39gVMXKkQjDVvPpu4MhSG+9jnuvMdwQ6uG+F4LfZxWDohoXDGh9ML0D10g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Nl+rJ6Gy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Nl+rJ6Gy"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id A57751F000E9;
	Fri, 31 Jul 2026 10:15:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785492921;
	bh=igCGcuVr3RVFJK8/Uk1UFFC3NA0FBLSNwlzVaDvkXzA=;
	h=From:To:Cc:Subject:Date;
	b=Nl+rJ6GyKZ8ba+2bqo7MGDCHI6P2EgJHg3evd07ZnjdThA+IyhB9/ajWpjgi2SaAD
	 a+EiGm3E3f7rGgJXCK1NOLFZtlyjgvoVZ5yvW/Yw/Y42JWKE3Iv0OWgwi9xeV3vctO
	 T+v49hvwnyiMlBPij8iMIqDjTwEkuLl+D5+KlP5mR1/5mu/S8vpfwOZmKyk36irpTa
	 Q5miiZgEQIvHTlNuHCXJE8/HiJzm/62vzT0VW/Jpj2XnbGvzJ0OrCfOAbxfTSYwVE3
	 neQ1fTw4ywM2c+uAicwJOx/H19runwL4ednFQ4KH5zGzcYRnFNlkciauRcLac6KdpJ
	 L56hXNuQqPdlQ==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-bugs@googlegroups.com, Aleksandr Nogikh <nogikh@google.com>, "Chas Williams" <3chas3@gmail.com>, <accessrunner-general@lists.sourceforge.net>, "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>, <linux-atm-general@lists.sourceforge.net>, <linux-usb@vger.kernel.org>, <netdev@vger.kernel.org>, "Duncan Sands" <duncan.sands@math.u-psud.fr>
Cc: linux-kernel@vger.kernel.org, syzbot@lists.linux.dev
Subject: [PATCH] usb: atm: cxacru: properly kill rcv_urb on error in cxacru_cm()
Message-ID: <91edfa4c-a63d-400c-9f00-31f3e1f98c00@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Fri, 31 Jul 2026 10:15:20 +0000 (UTC)

From: Aleksandr Nogikh <nogikh@google.com>

If cxacru_cm() encounters an error while submitting or waiting for snd_urb,
it aborts and returns the error without killing the already submitted
rcv_urb. This leaves the rcv_urb active.

When this happens during initialization (e.g., in cxacru_atm_start()), the
driver may ignore the error and proceed to call cxacru_poll_status(), which
invokes cxacru_cm() again. Attempting to submit the still-active rcv_urb
triggers a warning in usb_submit_urb():

cxacru 1-1:1.0: send of cm 0x84 failed (-104)
ATM dev 0: cxacru_atm_start: CHIP_ADSL_LINE_START returned -104
------------[ cut here ]------------
URB ffff88812658d200 submitted while active
WARNING: drivers/usb/core/urb.c:379 at usb_submit_urb+0x79/0x18b0
drivers/usb/core/urb.c:379
...
Call Trace:
 <TASK>
 cxacru_cm+0x21a/0xf10 drivers/usb/atm/cxacru.c:631
 cxacru_cm_get_array drivers/usb/atm/cxacru.c:722 [inline]
 cxacru_poll_status+0x178/0x1110 drivers/usb/atm/cxacru.c:828
 cxacru_atm_start+0x185/0x360 drivers/usb/atm/cxacru.c:814
 usbatm_atm_init+0x144/0x3a0 drivers/usb/atm/usbatm.c:927
 usbatm_usb_probe+0x15cb/0x1db0 drivers/usb/atm/usbatm.c:1178
 cxacru_usb_probe+0x17f/0x220 drivers/usb/atm/cxacru.c:1370
...

To fix this, ensure that rcv_urb is properly killed if cxacru_cm() aborts
early. We can safely call usb_kill_urb() on rcv_urb in the error path, as
it is safe to call even if the URB is not active (e.g., if it failed to
submit in the first place, or if it already completed).

Fixes: 1b0e61465234 ("[PATCH] USB ATM: driver for the Conexant AccessRunner chipset cxacru")
Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+c9dff578c3a41775176a@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=c9dff578c3a41775176a
Link: https://syzkaller.appspot.com/ai_job?id=75fec6f2-c8a6-43b1-b184-4d26baba86cc
Signed-off-by: Aleksandr Nogikh <nogikh@google.com>

---
diff --git a/drivers/usb/atm/cxacru.c b/drivers/usb/atm/cxacru.c
index f1900c567..429ac20a8 100644
--- a/drivers/usb/atm/cxacru.c
+++ b/drivers/usb/atm/cxacru.c
@@ -700,6 +700,8 @@ static int cxacru_cm(struct cxacru_data *instance, enum cxacru_cm_request cm,
 	ret = offd;
 	usb_dbg(instance->usbatm, "cm %#x\n", cm);
 fail:
+	if (ret < 0)
+		usb_kill_urb(instance->rcv_urb);
 	mutex_unlock(&instance->cm_serialize);
 err:
 	return ret;


base-commit: f5098b6bae761e346ebcd9da7f95622c04733cff
-- 
See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
You can comment on the patch as usual, syzbot will try to address
the comments and send a new version of the patch if necessary.
syzbot engineers can be reached at syzkaller@googlegroups.com.
