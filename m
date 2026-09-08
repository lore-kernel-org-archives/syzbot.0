Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A148525A96
	for <syzbot@lists.linux.dev>; Tue,  8 Sep 2026 11:05:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788865535; cv=none; b=OenNQ+MgGwv84q6Z1pR3xj/AWT3bF/4ob5/SSwoGLqgu9+iHm+xuYGwyv2i5DXJNjKs6XJpX9EbyQvUOztFGFb/YADkS6sMr/1FM4XX4sZNQBIr0W4UvbRtXJ2qjANv08R8xIxMZJrBMSm0oCraTQqRX7fgXNS+E5G04/KKVwVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788865535; c=relaxed/simple;
	bh=7DNkFEzRYYnav9OjGI/WFZdCWbrFYQ/bxBkgbI4g9nU=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=RzeOL6ww5uEOxAvFfy7LHYtxqeHZRp7R5MxjhuL2OsJ8nUSjGB1ggVB2XxVCoHhFnbepRzPYrfodKlBopDS1wsWRTC9KVlHS+Yw8F83Wt/86lLYBv97AfFk5r21gMWNU/lti4pX4vF8LfEc398wN/zdCeg0Olc6ZwnyxxLF88vA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Bax8S0Lp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Bax8S0Lp"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id AD4F51F00A3A;
	Tue,  8 Sep 2026 11:05:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788865532;
	bh=/fhYxUkyYeUK/W4Dp0pfExfeYqs89Q+mWMUmlE6CFcI=;
	h=From:To:Cc:Subject:Date;
	b=Bax8S0LpEbB2U2fbN9/G557h6GNVX4eU/hCdlOhHcefqim+yuJOizUIUN4Y6C1zmf
	 oxoPIUQ8SPK/grGNaFC3peSi/yyfqHEE2QHR79pIJioZ/vqdeMcWQtkiBLvjXFNBPF
	 sO1VpN6g2rfw0hAGSf1Q1mcAv10eF6QBHTi1d+mSyJv9Yw1WnkEU9U23r1N8pKSaZJ
	 grBSdpRDU8+sLnWObzcp3kaRZospppvquiw7JRva154s2I1dA18PH4JDkPD2qK9RoH
	 GRTPz7IDFUWJZFSuNUCuH5bFOZGc1bj8B2Jq8A89TM62bnHmWJVp/hZ5kYPt+RP2qN
	 M8YjngDIw0OuQ==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] usb: phy: do not overwrite dev->type in usb_add_phy_dev()
Message-ID: <36d44b2d-6fd1-4bc6-8bf6-78f1f4e9558b@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Tue,  8 Sep 2026 11:05:32 +0000 (UTC)

In usb_add_phy_dev(), x->dev->type is overwritten with &usb_phy_dev_type.
However, the underlying struct device is allocated and managed by a parent
subsystem or bus driver, such as an I2C client device in phy-isp1301.
Overwriting x->dev->type clobbers the original device type (e.g.
i2c_client_type) and removes its lifecycle release callback (such as
i2c_client_dev_release).

When an I2C client device using a USB PHY is deregistered and its reference
count drops to zero, device_release() falls back to dev->type->release
since dev->release is NULL for I2C clients. Because usb_phy_dev_type does
not provide a .release callback, a warning is triggered and the memory of
the client structure is leaked:

Device '2-002c' does not have a release() function, it is broken and must
be fixed. See Documentation/core-api/kobject.rst.
WARNING: drivers/base/core.c:2643 at device_release+0x194/0x1f0
drivers/base/core.c:2642
Call Trace:
 <TASK>
 kobject_cleanup lib/kobject.c:689 [inline]
 kobject_release lib/kobject.c:720 [inline]
 kref_put include/linux/kref.h:65 [inline]
 kobject_put+0x222/0x550 lib/kobject.c:737
 i2c_deregister_clients+0x281/0x3a0 drivers/i2c/i2c-core-base.c:1783
 i2c_del_adapter+0x124/0x440 drivers/i2c/i2c-core-base.c:1827
 i2c_tiny_usb_disconnect+0x49/0xd0 drivers/i2c/busses/i2c-tiny-usb.c:282
 usb_unbind_interface+0x295/0x9f0 drivers/usb/core/driver.c:461
 device_remove drivers/base/dd.c:618 [inline]
 __device_release_driver drivers/base/dd.c:1349 [inline]
 device_release_driver_internal+0x4f5/0x880 drivers/base/dd.c:1372
 bus_remove_device+0x444/0x560 drivers/base/bus.c:664
 device_del+0x524/0x8f0 drivers/base/core.c:3965
 </TASK>

Platform devices were unaffected because platform_device_release is
assigned directly to dev->release, which device_release() checks before
dev->type->release. However, subsystems should not overwrite dev->type on
devices they do not own.

Fix this by removing usb_phy_dev_type and its assignment in
usb_add_phy_dev(). To maintain the charger uevents, construct the
environment variables directly and pass them to kobject_uevent_env() in
usb_phy_notify_charger_work().

Fixes: a8534cb092d7 ("usb: phy: introduce usb_phy device type with its own uevent handler")
Assisted-by: Gemini:gemini-3.7-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+3fb7629cfd12d04beeab@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=3fb7629cfd12d04beeab
Link: https://syzkaller.appspot.com/ai_job?id=313c85bd-96bf-44e8-a1a6-e25813b43afe
To: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
To: <linux-usb@vger.kernel.org>
To: "Grzegorz Jaszczyk" <grzegorz.jaszczyk@linaro.org>
Cc: "Diogo Ivo" <diogo.ivo@tecnico.ulisboa.pt>
Cc: <linux-kernel@vger.kernel.org>

---
diff --git a/drivers/usb/phy/phy.c b/drivers/usb/phy/phy.c
index 5a9b9353f..7c85c7ca1 100644
--- a/drivers/usb/phy/phy.c
+++ b/drivers/usb/phy/phy.c
@@ -42,12 +42,6 @@ static const char *const usb_chger_type[] = {
 	[ACA_TYPE]			= "USB_CHARGER_ACA_TYPE",
 };
 
-static const char *const usb_chger_state[] = {
-	[USB_CHARGER_DEFAULT]	= "USB_CHARGER_DEFAULT",
-	[USB_CHARGER_PRESENT]	= "USB_CHARGER_PRESENT",
-	[USB_CHARGER_ABSENT]	= "USB_CHARGER_ABSENT",
-};
-
 static struct usb_phy *__usb_find_phy(struct list_head *list,
 	enum usb_phy_type type)
 {
@@ -80,18 +74,6 @@ static struct usb_phy *__of_usb_find_phy(struct device_node *node)
 	return ERR_PTR(-EPROBE_DEFER);
 }
 
-static struct usb_phy *__device_to_usb_phy(const struct device *dev)
-{
-	struct usb_phy *usb_phy;
-
-	list_for_each_entry(usb_phy, &phy_list, head) {
-		if (usb_phy->dev == dev)
-			return usb_phy;
-	}
-
-	return NULL;
-}
-
 static void usb_phy_set_default_current(struct usb_phy *usb_phy)
 {
 	usb_phy->chg_cur.sdp_min = DEFAULT_SDP_CUR_MIN;
@@ -123,6 +105,9 @@ static void usb_phy_set_default_current(struct usb_phy *usb_phy)
 static void usb_phy_notify_charger_work(struct work_struct *work)
 {
 	struct usb_phy *usb_phy = container_of(work, struct usb_phy, chg_work);
+	char uchger_state[50] = { 0 };
+	char uchger_type[50] = { 0 };
+	char *envp[] = { uchger_state, uchger_type, NULL };
 	unsigned int min, max;
 
 	switch (usb_phy->chg_state) {
@@ -130,11 +115,15 @@ static void usb_phy_notify_charger_work(struct work_struct *work)
 		usb_phy_get_charger_current(usb_phy, &min, &max);
 
 		atomic_notifier_call_chain(&usb_phy->notifier, max, usb_phy);
+		snprintf(uchger_state, ARRAY_SIZE(uchger_state),
+			 "USB_CHARGER_STATE=%s", "USB_CHARGER_PRESENT");
 		break;
 	case USB_CHARGER_ABSENT:
 		usb_phy_set_default_current(usb_phy);
 
 		atomic_notifier_call_chain(&usb_phy->notifier, 0, usb_phy);
+		snprintf(uchger_state, ARRAY_SIZE(uchger_state),
+			 "USB_CHARGER_STATE=%s", "USB_CHARGER_ABSENT");
 		break;
 	default:
 		dev_warn(usb_phy->dev, "Unknown USB charger state: %d\n",
@@ -142,36 +131,9 @@ static void usb_phy_notify_charger_work(struct work_struct *work)
 		return;
 	}
 
-	kobject_uevent(&usb_phy->dev->kobj, KOBJ_CHANGE);
-}
-
-static int usb_phy_uevent(const struct device *dev, struct kobj_uevent_env *env)
-{
-	const struct usb_phy *usb_phy;
-	char uchger_state[50] = { 0 };
-	char uchger_type[50] = { 0 };
-	unsigned long flags;
-
-	spin_lock_irqsave(&phy_lock, flags);
-	usb_phy = __device_to_usb_phy(dev);
-	spin_unlock_irqrestore(&phy_lock, flags);
-
-	if (!usb_phy)
-		return -ENODEV;
-
-	snprintf(uchger_state, ARRAY_SIZE(uchger_state),
-		 "USB_CHARGER_STATE=%s", usb_chger_state[usb_phy->chg_state]);
-
 	snprintf(uchger_type, ARRAY_SIZE(uchger_type),
 		 "USB_CHARGER_TYPE=%s", usb_chger_type[usb_phy->chg_type]);
-
-	if (add_uevent_var(env, uchger_state))
-		return -ENOMEM;
-
-	if (add_uevent_var(env, uchger_type))
-		return -ENOMEM;
-
-	return 0;
+	kobject_uevent_env(&usb_phy->dev->kobj, KOBJ_CHANGE, envp);
 }
 
 static void __usb_phy_get_charger_type(struct usb_phy *usb_phy)
@@ -675,11 +637,6 @@ int usb_add_phy(struct usb_phy *x, enum usb_phy_type type)
 }
 EXPORT_SYMBOL_GPL(usb_add_phy);
 
-static const struct device_type usb_phy_dev_type = {
-	.name = "usb_phy",
-	.uevent = usb_phy_uevent,
-};
-
 /**
  * usb_add_phy_dev - declare the USB PHY
  * @x: the USB phy to be used; or NULL
@@ -705,8 +662,6 @@ int usb_add_phy_dev(struct usb_phy *x)
 	if (ret)
 		return ret;
 
-	x->dev->type = &usb_phy_dev_type;
-
 	ATOMIC_INIT_NOTIFIER_HEAD(&x->notifier);
 
 	spin_lock_irqsave(&phy_lock, flags);


base-commit: df2908090cda368b01ff43709f51890076c56157
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to Sign-off the patch as a human author
and send it to the upstream kernel mailing lists.
Reply with '#syz reject' to reject it ('#syz unreject' to undo).

See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
You can comment on the patch as usual, syzbot will try to address
the comments and send a new version of the patch if necessary.
syzbot engineers can be reached at syzkaller@googlegroups.com.
