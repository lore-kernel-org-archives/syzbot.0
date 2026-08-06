Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com [209.85.128.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63B5039B4B9
	for <syzbot@lists.linux.dev>; Thu,  6 Aug 2026 14:25:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786026317; cv=none; b=YcTPE9WucIxz4kDnM2WkQ2Lee8Ov5XMyIzzRnLGRK+j0FEtpSsnBSspYDHi7w9mvrFjX8yCro8IkwLTc/QplXStevUPaAYWJubpeR4RIH22el/8IsERW1yrSmCjdKCz4OlRV3T9q0bYpfMkShh3rmXSD/dSNuKrDK5fHmVOpkhE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786026317; c=relaxed/simple;
	bh=AvjA1M5b99YYhvvLAZYS047Vqnyc3DiDJbzlTqcxLRQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=NTzhZ3iV5x79MlWLXBRiKMNQkPNsCIJBpNJZX8pJe5UkrKwkZE7s9nOqsKFgWxwrnFkx5nPduubdfxbU/HGsD281VU2ma9Ho2vsuUev44En68s/hvNSYlTM4IplhjSiZwmzvqsgE2tSqRDw6RUplqthG/l3fj5OXn3cdIHCKTrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--nogikh.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=q4JFcOSA; arc=none smtp.client-ip=209.85.128.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--nogikh.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="q4JFcOSA"
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-49554715277so20167955e9.1
        for <syzbot@lists.linux.dev>; Thu, 06 Aug 2026 07:25:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786026314; x=1786631114; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2QH/vyaXc9mQlWmLqa26CL98fda7tXqOOXhnKxF4DxQ=;
        b=q4JFcOSAr4g7orba29/e4NHPyywviEbQL5OK1GJ5ZF/0zNUMU5n92YVPXOEWxwaHgP
         DWVPEWALn6LNGT4lp1b8WC1ky3hTJOXzY8Q6dH0Q0b0qvsBzmd/0ATNcab98weJCdzs3
         AD4fRtc/nGnammGbKJEYg/XWAERbHcbnXrjWfW9jhu/9RbmF5SSYLcS/TkieM/SQ6moo
         ei9F0S9wyzrTwV16NjmiOc8s7KfWJg+PZ4trCQYYD/SjrCTDm42bbMu+F5FoiBp3GGep
         q9lZk0HNO2oSO05hOtPqmMKHnJ2v0z75CQVSkIhGdKnCbi6DY9nFnInTUIZCONreX8EO
         RIDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786026314; x=1786631114;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=2QH/vyaXc9mQlWmLqa26CL98fda7tXqOOXhnKxF4DxQ=;
        b=Lv4IN70KUVCIeQutfaopr7qv8z9Ftr6zJO0wVpnrHqiMYgEXx7/2jnc/QOcFrTYxQ8
         VgvzxYMaVY2h6LuTkBZmJJN+VNFtnBpC39rCK/emi14DgI3i/EMfFO41Lg4uASOkfz9k
         IuKmWg94seCwPa7rh+/5f3f71RBK5QwXtgVWFrDJiK+O7F5h7Dey+p324W8E79nZiDmA
         0gdep7HBQk81bSP3lL86agfEiMcnxnEMh83zzv7NdWLZSknUD+7KSXncRZ1m0ciAQNHO
         nvr4M8AkQ2uQxVkf6FdawbxI+29TUG4OlNrRvYR+d0qPP3yS/qe3fLWPMJApqQ+tHt1v
         hZJw==
X-Forwarded-Encrypted: i=1; AHgh+RphEdbAW2SdVqHP8IA8JjBdO0l4TAh/tXsiY9GfAUQuDuL8GEsOb+DYIPwpLJza9HIE6SgTVyU=@lists.linux.dev
X-Gm-Message-State: AOJu0YzZuy0nyiCFMFC9O5WhZyC4rQM9XTL9WOUpUc/UVA2KHMC2Nu9B
	WgBAPAFjDKYFWZfLWlWH8HiWF6B5yq76cRPGQGiIn+4rIVymh5jvb1Pjh6YilJmZaiZEeTADjAF
	cg5Kw/w==
X-Received: from wmix24-n2.prod.google.com ([2002:a05:600c:e558:20b0:495:3d1b:2bc5])
 (user=nogikh job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:840f:b0:496:c1f3:e8fb
 with SMTP id 5b1f17b1804b1-4994e71ffafmr198271475e9.8.1786026314072; Thu, 06
 Aug 2026 07:25:14 -0700 (PDT)
Date: Thu,  6 Aug 2026 14:25:11 +0000
In-Reply-To: <2026080322-obsessed-daringly-e6df@gregkh>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <2026080322-obsessed-daringly-e6df@gregkh>
X-Mailer: git-send-email 2.55.0.654.g21b8a5bc05-goog
Message-ID: <20260806142511.2337081-1-nogikh@google.com>
Subject: [PATCH v2] usb: usbtest: disable dynamic ID support
From: Aleksandr Nogikh <nogikh@google.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Kees Cook <kees@kernel.org>, syzbot@lists.linux.dev, 
	syzbot+7e1e5911f9eac50bedc7@syzkaller.appspotmail.com, 
	Aleksandr Nogikh <nogikh@google.com>
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

Reported-by: syzbot+7e1e5911f9eac50bedc7@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=7e1e5911f9eac50bedc7
Signed-off-by: Aleksandr Nogikh <nogikh@google.com>
---
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
