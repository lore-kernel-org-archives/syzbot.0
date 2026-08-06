Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com [209.85.221.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C104430E0D6
	for <syzbot@lists.linux.dev>; Thu,  6 Aug 2026 15:26:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786030020; cv=none; b=NrkVwH0pbUmWnBdFxgrWFuqmEGfuR2Trq3vxOTAjBcYaPM0gMgFLziexGDrWRPQ4a+AWmIwZlGMYgX59QEOAuIqQJYK1pcTyLLhc1j0DbRr0MXaDWiStKlOYe/6Za4rknMvYXzlvwjgXTVrR2sCkt91Xctbxc15x8XSAharc+0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786030020; c=relaxed/simple;
	bh=R1E/w+AxsfP4UPOWvTWTrQQ9pq/bK7zQxikSG96an4o=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=AyF0aAV3h2s3xE08O8WsJGOwAuw/yVvKQfWttlOm7cPX/Kb63Kc66VfGyh3npiZqN91Sujv44Unwha6gqGS2nQzgrZiCr1FNVS/wiItCkc3H9lRZn7BgC1pIBjYrFtDZlD0gxilTXyqzv9bQ+Z8ozhdbeGAoBgVzlEiHEaY2EQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--nogikh.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=JBbkNsv9; arc=none smtp.client-ip=209.85.221.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--nogikh.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JBbkNsv9"
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-47fe9444eceso1562889f8f.2
        for <syzbot@lists.linux.dev>; Thu, 06 Aug 2026 08:26:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786030016; x=1786634816; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=K+S1QP0FhvyNfqeqWumDjuFSyxYhfuXzC6OVTs+0PE4=;
        b=JBbkNsv9ZKF4vOHh6MmKIoD47tn0EShnPNKYLDsMNdYvV/r29+TM7dJc3vFU5kezhU
         EoGZNnwcSlCHmkXSC+8l+bJiPAUSp3BiaN1OOi4n+gpHM8RB/JUVT7Nwbb53FLidRBQP
         i2JIweiukagAqImsSoDTjDOFgGR2LgC5/PyQTWqpN+l3f1vT2a2KEDbz16b2O5wSv+1j
         zTFPYMbgvXMIdNG6dQFIXGpIBagwdKEpUZpqZyT8ZTtu8mWmVxz1OE7eWqlM3jwuYOCv
         4ghhUsR827LcGVWVc43KfEHm+NW4Mb+Jkt3O+BMg6VvPkomJoMidxHc7Knwszi7V0ZM2
         1RWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786030016; x=1786634816;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=K+S1QP0FhvyNfqeqWumDjuFSyxYhfuXzC6OVTs+0PE4=;
        b=Lt2XqvJZHjXCdKpeJQ0K7lVJOTtc6kmKYDgIhEii03V+H1jGWpSZoXCjyBtijxYQ7F
         bL2BOD7gBTCYiXJQXya2T59sViR1e9nOGt1hn0QLPqWj9py6ojVbbkM9XsRz69dp4b7H
         yJjggIFL0/j/3VW6mcLBqP33krhckHtbVu4byOflHF4uvoKnhUXlBgTgHBvm2tjCB8cV
         zZYjjIbipdamSFUg30hxo4pSXE/JBRY+I3RgxwLVmPc3cPA/lPFs+/FFTtsM9zcCbhTO
         SBS0Sn8l+/3V+55fwFvsxGRuo6aujEPG2ZtZTloB63MPGo39RZ7vP3DOhy9EYOSer3A+
         3eAQ==
X-Forwarded-Encrypted: i=1; AHgh+RquzI8q8DnfhM4liJT0j84RVYmz0ofbQxKlOE+3+lNMCvZJoFlsQJwfNCRTW2h8sPu3tvAEvT0=@lists.linux.dev
X-Gm-Message-State: AOJu0YzK9bza+M/am4/bRU2f5cg7EDFFJcsosevH5Bboo03zny/6UOia
	cnonRC+/uFR0SYyhvc/26u7FIQMdL5f1zrXJfoAaBNWsBLfFlwLOKUika+/c1wzTg8/G5nyIOzJ
	mlEuXzw==
X-Received: from wrmj16.prod.google.com ([2002:adf:e510:0:b0:45e:9abb:86db])
 (user=nogikh job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:4021:b0:47f:f828:9f35
 with SMTP id ffacd0b85a97d-47ff828a369mr8592226f8f.17.1786030016055; Thu, 06
 Aug 2026 08:26:56 -0700 (PDT)
Date: Thu,  6 Aug 2026 15:26:51 +0000
In-Reply-To: <2026080322-obsessed-daringly-e6df@gregkh>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <2026080322-obsessed-daringly-e6df@gregkh>
X-Mailer: git-send-email 2.55.0.654.g21b8a5bc05-goog
Message-ID: <20260806152651.2370795-1-nogikh@google.com>
Subject: [PATCH v3] usb: usbtest: disable dynamic ID support
From: Aleksandr Nogikh <nogikh@google.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Kees Cook <kees@kernel.org>, syzbot@lists.linux.dev, 
	syzbot+7e1e5911f9eac50bedc7@syzkaller.appspotmail.com, 
	Aleksandr Nogikh <nogikh@google.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

The usbtest driver relies on the driver_info field of struct usb_device_id
to point to a valid struct usbtest_info descriptor. This structure contains
essential test configurations, such as endpoint addresses and test modes,
which are required during probe.

When a user dynamically adds a new device ID via the sysfs new_id
interface without specifying a reference device, the USB core initializes
driver_info to 0 (NULL). When a matching device is subsequently probed,
usbtest_probe() unconditionally casts driver_info to a struct usbtest_info
pointer and dereferences it, leading to a NULL pointer dereference crash:

  Oops: general protection fault, probably for non-canonical address
  0xdffffc0000000001: 0000 [#1] SMP KASAN NOPTI
  KASAN: null-ptr-deref in range [0x0000000000000008-0x000000000000000f]
  RIP: 0010:usbtest_probe+0x3b9/0x1280 drivers/usb/misc/usbtest.c:2822

Because usbtest strictly requires pre-defined usbtest_info descriptors
to function, dynamic ID binding via sysfs is fundamentally unsupported
for this driver.

Fix this by setting .no_dynamic_id = 1 on usbtest_driver. This instructs
the USB core to skip creating the new_id and remove_id sysfs interfaces
for usbtest, preventing invalid dynamic ID entries from being created.

Cc: stable@vger.kernel.org
Reported-by: syzbot+7e1e5911f9eac50bedc7@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=7e1e5911f9eac50bedc7
Signed-off-by: Aleksandr Nogikh <nogikh@google.com>
---
Changes in v3:
- Cc stable.
- Link to v2: https://lore.kernel.org/r/20260806142511.2337081-1-nogikh@google.com

Changes in v2:
- Disable dynamic IDs via .no_dynamic_id = 1 instead of adding a runtime NULL
  check in probe().
- Link to v1: https://lore.kernel.org/r/2650cf0f-26f9-48b5-b198-e4cb67c59cf0@mail.kernel.org

 drivers/usb/misc/usbtest.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/misc/usbtest.c b/drivers/usb/misc/usbtest.c
index 98071b25ac076..8759df49be287 100644
--- a/drivers/usb/misc/usbtest.c
+++ b/drivers/usb/misc/usbtest.c
@@ -3054,6 +3054,7 @@ static struct usb_driver usbtest_driver = {
 	.disconnect =	usbtest_disconnect,
 	.suspend =	usbtest_suspend,
 	.resume =	usbtest_resume,
+	.no_dynamic_id = 1,
 };
 
 /*-------------------------------------------------------------------------*/
-- 
base-commit: 48a5a7ab8d6ab7090564339e039c421f315de912
-- 
2.55.0.654.g21b8a5bc05-goog
