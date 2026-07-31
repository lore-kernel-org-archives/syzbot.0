Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03177403AE1
	for <syzbot@lists.linux.dev>; Fri, 31 Jul 2026 10:15:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=100.103.45.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785492946; cv=pass; b=VPm1Lf2vjaFojyLoM9UY1kbtJUa2y300qHgY2bTkcfXbqEtjSOZvhfT7JR7KV9iN97iFsbfTRNdbAjaNiTXW6Hmw4ssXA/dUnh4vBW71Kn0R5E4i0vpHiON3wc0Kw9WJA3O81HczKfRa3RhXf0gvVy7kpfKjItYzIRReN0ENn2U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785492946; c=relaxed/simple;
	bh=ZydqOx6NgyipRG59qdGpZhLl70JnIuuCp2iBlcBeoks=;
	h=Subject:From:To:MIME-Version:Content-Type:Message-ID:Date; b=bN1LN0W8ZHb37/d0XAEaGsnrkYoz4vbORoVVeMSumEmh/EtkfhqNTixUomU8MqC3bfU9+/Dhoqp67KGaqBjknONqq7ZI7P0rLlbvk+vQbVlVnIdCm0VEVb5TZ3fPsfpZEj+SOCSRayXg4eB1n9o5mtrnN/k03OOKiLKXnI+EGfo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=lists.sourceforge.net header.i=@lists.sourceforge.net header.b=XHx4yMwo; arc=pass smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=lists.sourceforge.net header.i=@lists.sourceforge.net header.b="XHx4yMwo"
Received: by smtp.kernel.org (Postfix)
	id 2B0B91F00A3A; Fri, 31 Jul 2026 10:15:39 +0000 (UTC)
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=216.105.38.7
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1785492939;
	b=dPcTmLNfTXbvOENxzcOCBQXlgBvSLoKXWna9RQ0rIIEQg43v+aMs6nWT1tqnI2NZ5zCC
	 IZFYdiaT1V2rs0UK659dUS0cuIWt+fFtv0AObNLDZ9FFFS4Qd5YLt5n7ialyUCqwUuMyD
	 B++iHNBFEi4GqywHhcDpuXJzW13Z1TTgjo4WfpcokPQURv2Gabo2Xy0CbP9HQN468rIEb
	 jXRqI+8qvdmqupCca47MOLKAZj45JnBBlvppIDY/BgNrvxp7PsGbe85yNJp7EJhyZtzwq
	 7Lzq015wqnuXUa/nWpmPGwTsA5lkucu9Ln8choAj8G8ZyaN/s3D1DpPGFHAF44E8ONw==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1785492939;
	h=DMARC-Filter:DKIM-Signature:Received:Subject:From:To:MIME-Version:
	 Content-Type:Message-ID:Date:Precedence:X-BeenThere:X-Mailman-Version:
	 List-Id:X-List-Administrivia:Errors-To;
	bh=B63kxWl2lIq6mQoveHJbCa8Yv1Kv/4sMluTdONEjTRo=;
	b=KP1c/9/tTGoGI9uC3znNJfk8Wg9AeMpwRYSPJ+mJJkwXuypZELrB+cl4R2KStOxhlZBC
	 gbmgrWllD8w248+bpHHzrlzU8RXaOpnNUOK53YyISxOCDnUAXNgl1GS97apIDOm8KMa3W
	 VLLKe6FD8/RS7amuJxWpRyS0itPemcc4+yDE8H+t6Vpum2/Zq0rzkIoJErGvYKEzuJQTc
	 Z+FRxV8GOpmmsun9JtpADABS01lmJWoB/9OxzUMhKY+IN3r2IApR3ZekWs0LD9o25kbi2
	 DmHB4zTC0jsnEMw1AHjshDCNS7hXYyRvWXgXIvaA6mVw+F3bopULBlB+1RMwGg3GjhA==
ARC-Authentication-Results: i=1; smtp.kernel.org; dkim=pass header.d=lists.sourceforge.net header.i=@lists.sourceforge.net header.a=rsa-sha256 header.s=beta header.b=XHx4yMwo;
	dmarc=pass header.from=lists.sourceforge.net;
	spf=pass smtp.mailfrom=lists.sourceforge.net;
	arc=none smtp.remote-ip=216.105.38.7
Received: from lists.sourceforge.net (lists.sourceforge.net [216.105.38.7])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 8EA861F000E9
	for <syzbot@kernel.org>; Fri, 31 Jul 2026 10:15:38 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=lists.sourceforge.net header.i=@lists.sourceforge.net header.a=rsa-sha256 header.s=beta header.b=XHx4yMwo
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.kernel.org 8EA861F000E9
Authentication-Results: smtp.kernel.org; dmarc=pass (p=none dis=none) header.from=lists.sourceforge.net
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=lists.sourceforge.net
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=lists.sourceforge.net; s=beta; h=List-Id:Date:Message-ID:Content-Type:
	MIME-Version:To:From:Subject:Sender:Reply-To:Cc:Content-Transfer-Encoding:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=B63kxWl2lIq6mQoveHJbCa8Yv1Kv/4sMluTdONEjTRo=; b=XHx4yMwowylbv/6B0nqLrSOG3P
	LmyS/dbUOcm6UYMs2PNQjl83UruT5KHZHiJm6Te42DTdyblPjT8epQ8tY7GY8nlyzgxTSwr8KAbQV
	TdB9LeZWnNm6teKwBOXNyLG6mNnQ94i6JCzGJxv+ymTJ8ImADwsBRdKNl/C4bTxtm+gg=;
Received: from [127.0.0.1] (helo=sfs-ml-2.v29.lw.sourceforge.com)
	by sfs-ml-2.v29.lw.sourceforge.com with esmtp (Exim 4.95)
	(envelope-from <accessrunner-general-bounces@lists.sourceforge.net>)
	id 1wpkHB-0003qv-Ar
	for syzbot@kernel.org;
	Fri, 31 Jul 2026 10:15:38 +0000
Subject: [PATCH] usb: atm: cxacru: properly kill rcv_urb on error in
 cxacru_cm()
From: accessrunner-general-owner@lists.sourceforge.net
To: syzbot@kernel.org
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="===============6763272119743767391=="
Message-ID: <mailman.108067.1785492929.1583.accessrunner-general@lists.sourceforge.net>
Date: Fri, 31 Jul 2026 10:15:29 +0000
Precedence: bulk
X-BeenThere: accessrunner-general@lists.sourceforge.net
X-Mailman-Version: 2.1.21
X-List-Administrivia: yes
Errors-To: accessrunner-general-bounces@lists.sourceforge.net

--===============6763272119743767391==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

Your message has been rejected, probably because you are not
subscribed to the mailing list and the list's policy is to prohibit
non-members from posting to it.  If you think that your messages are
being rejected in error, contact the mailing list owner at
accessrunner-general-owner@lists.sourceforge.net.


--===============6763272119743767391==
Content-Type: message/rfc822
MIME-Version: 1.0

Received: from [172.30.29.66] (helo=mx.sourceforge.net)
	by sfs-ml-2.v29.lw.sourceforge.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <syzbot@kernel.org>)
	id 1wpkH1-0003q0-M2;
	Fri, 31 Jul 2026 10:15:28 +0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sourceforge.net; s=x; h=Date:Content-Transfer-Encoding:Content-Type:
	MIME-Version:Message-ID:Subject:Cc:To:From:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=igCGcuVr3RVFJK8/Uk1UFFC3NA0FBLSNwlzVaDvkXzA=; b=BFj3d7Idf4HlZB9QPpRMI33Ao6
	bSXXWM9NQohM/+fx9jcpoRxCWlUHyPGxVB+UM2mhIOJuaoacTnbDGBPUT6g7lBZrq7P10qjkti4RR
	1QwV0kZQCIsKugiNXobVKY1RdlQfOG/6rnCMVz7ul3Hlcs6G4+onmrknJrGDjGsFUc80=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
	; h=Date:Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:
	Subject:Cc:To:From:Sender:Reply-To:Content-ID:Content-Description:Resent-Date
	:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:
	References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:List-Post:
	List-Owner:List-Archive; bh=igCGcuVr3RVFJK8/Uk1UFFC3NA0FBLSNwlzVaDvkXzA=; b=m
	8tbfwQbZXmE0/LQITHhHA7gQDxm14Y74oEBB/WK+SK8Y/0+VUyBUNyLe3RGaY4SSExlpt0w8RSszK
	wQWuWZuvsoB83QJYgJu4OtsLRAMa+mHXBGj7a0R8K5noUIcF3615/DnmkiBT5TZHdAhkfvPlMHjO3
	EDZyjAA/fv1Ijer4=;
Received: from sea.source.kernel.org ([172.234.252.31])
	by sfi-mx-1.v28.lw.sourceforge.com with esmtps (TLS1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
	(Exim 4.95)
	id 1wpkH4-0001ER-9H;
	Fri, 31 Jul 2026 10:15:28 +0000
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with UTF8SMTP id 4516943790;
	Fri, 31 Jul 2026 10:15:21 +0000 (UTC)
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
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Fri, 31 Jul 2026 10:15:20 +0000 (UTC)
X-Spam-Score: -0.2 (/)
X-Spam-Report: Spam detection software, running on the system "sfi-spamd-1.hosts.colo.sdot.me",
 has NOT identified this incoming email as spam.  The original
 message has been attached to this so you can view it or label
 similar future email.  If you have any questions, see
 the administrator of that system for details.
 
 Content preview:  From: Aleksandr Nogikh <nogikh@google.com> If cxacru_cm()
   encounters an error while submitting or waiting for snd_urb, it aborts and
    returns the error without killing the already submitted rcv_urb. This leaves
    the rcv_urb active. 
 
 Content analysis details:   (-0.2 points, 5.0 required)
 
  pts rule name              description
 ---- ---------------------- --------------------------------------------------
  0.1 DKIM_SIGNED            Message has a DKIM or DK signature, not necessarily valid
 -0.1 DKIM_VALID_EF          Message has a valid DKIM or DK signature from
                             envelope-from domain
 -0.1 DKIM_VALID             Message has at least one valid DKIM or DK signature
 -0.1 DKIM_VALID_AU          Message has a valid DKIM or DK signature from author's
                             domain
X-Headers-End: 1wpkH4-0001ER-9H

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


--===============6763272119743767391==--
