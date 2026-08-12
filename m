Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB3162E612E
	for <syzbot@lists.linux.dev>; Wed, 12 Aug 2026 05:24:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786512261; cv=none; b=t+jQXbVJP5rqBXELjFqlELisdEpf79mMkXohMenQLh9IoOTwAK09ZxgXSSiFUmgK8eHSi6sLy1sqGUyULXbin9R+4v4zD41NZ9JeAzB3hl+WosVF1SbfFDHFXOIkPP2oMBYiPfwF0r6K/+TvlwAwms4rlBLT6Lw5jI5DWeWJ5xE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786512261; c=relaxed/simple;
	bh=X98jPDJe7337ui6aO5GS+duYuLNf+p4vbMKqgdEJXpM=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=Y/dy198rrAZGIACHiAffXRfgBAfmxTsN0YNbfpIFY8W0UP2ahx1xkDb8xiBKVqEPXXqaPgJVfqjRE2Bgyao2UDdRO2euMdTFSkuEMQvoJHDsLIptSknwayA69Ssas197LZQm0JB3RNF/K66ccMZ/9DCA0+1C0tT7g9hyZI0PuQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=o0bNXDpd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="o0bNXDpd"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 631EA1F000E9;
	Wed, 12 Aug 2026 05:24:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786512259;
	bh=7ZEhZLCN+dGOblilwGLl+7BNaLlyCgmglXOrPPsy5Bo=;
	h=From:To:Cc:Subject:Date;
	b=o0bNXDpdXHcTRObk1QccPMhi3NZoPthAmy5undZAZMSytEH+9yxpIhVWM0JKQqEct
	 MmLW4Ua/FqzdB3DVT8GvmBgCB8jYFKDy7RuuaxTc0Ty0dpFoykm8KIqeev8RKkBPfp
	 3sNOZubLxVHCiC4pRn8FuD3Xvr2IguI81y5n1BPyj6+lJuW5S56737nqOL5fRHK+2U
	 2gp3UYKkN5rEmyX5OeE9y+2E51lX05DT8U8dtaU59N6lX+o/LQQxrTQAVJ3S7DxrvS
	 bGS9BAyB3x0TY++fuFL6xVhAnQz3qeqXudtQjGO94CccihkmtqDd8J0nHU1X7iF2da
	 oxYxAtx7HZ55w==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] i2c: core: fix adapter deregistration race and USB PHY type overwrite
Message-ID: <cfb582d8-dbab-4e13-a732-e113dfd66617@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Wed, 12 Aug 2026 05:24:19 +0000 (UTC)

The USB PHY subsystem incorrectly overwrites the `type` of the device
passed to it in `usb_add_phy_dev()`. This destroys the device's original
`release` function (e.g., `i2c_client_dev_release`), leading to a memory
leak and a warning when the device is removed:

WARNING: drivers/base/core.c:2639 at device_release+0x194/0x1f0
Call Trace:
 kobject_put+0x222/0x550 lib/kobject.c:737
 i2c_deregister_clients+0x281/0x3a0 drivers/i2c/i2c-core-base.c:1782
 i2c_del_adapter+0x10c/0x430 drivers/i2c/i2c-core-base.c:1820
 i2c_tiny_usb_disconnect+0x49/0xd0 drivers/i2c/busses/i2c-tiny-usb.c:282

Additionally, there is a race condition between `new_device_store()` and
`i2c_del_adapter()`. If `new_device_store()` creates a new client device
while `i2c_del_adapter()` is deregistering clients, it can result in a
double unregister of the I2C client. There is also a race involving debugfs
removal during adapter deregistration, which triggers KASAN null-ptr-deref
errors:

KASAN: null-ptr-deref in range [0x0000000000000140-0x0000000000000147]
Call Trace:
 __kasan_check_byte+0x12/0x40 mm/kasan/common.c:573
 lock_acquire+0x84/0x350 kernel/locking/lockdep.c:5842
 down_write_nested+0x9d/0x210 kernel/locking/rwsem.c:1757
 start_dirop+0x4f/0x90 fs/namei.c:2942
 debugfs_create_dir+0x24/0x350 fs/debugfs/inode.c:572
 i2c_device_probe+0x814/0xbf0 drivers/i2c/i2c-core-base.c:588

To fix the USB PHY issue, we stop overwriting `dev->type` in
`usb_add_phy_dev()` and instead pass the uevent environment variables
directly in `usb_phy_notify_charger_work()`. We also add
`cancel_work_sync(&x->chg_work)` in `usb_remove_phy()` to ensure no pending
work accesses the freed PHY.

To fix the I2C race condition, we hold `adap->userspace_clients_lock` in
`new_device_store()` before checking the IDR and keep it held while calling
`i2c_new_client_device()`. This ensures that if `i2c_del_adapter()` is
running, it will either block waiting for the lock to finish and safely
unregister the newly created client, or it has already removed the adapter
from the IDR, causing `new_device_store()` to abort.

Finally, we move `debugfs_remove_recursive(adap->debugfs)` to the end of
`i2c_del_adapter()` to prevent use-after-free issues if debugfs files are
accessed during adapter removal.

Fixes: a8534cb092d7 ("usb: phy: introduce usb_phy device type with its own uevent handler")
Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+3fb7629cfd12d04beeab@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=3fb7629cfd12d04beeab
Link: https://syzkaller.appspot.com/ai_job?id=63493d50-95d9-4a1c-9ccf-fa45ca05bef8
To: "Andi Shyti" <andi.shyti@kernel.org>
To: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
To: <linux-i2c@vger.kernel.org>
To: <linux-usb@vger.kernel.org>
To: "Grzegorz Jaszczyk" <grzegorz.jaszczyk@linaro.org>
Cc: "Diogo Ivo" <diogo.ivo@tecnico.ulisboa.pt>
Cc: <linux-kernel@vger.kernel.org>

---
diff --git a/drivers/i2c/i2c-core-base.c b/drivers/i2c/i2c-core-base.c
index 3ec04787a..f4ff6ce5b 100644
--- a/drivers/i2c/i2c-core-base.c
+++ b/drivers/i2c/i2c-core-base.c
@@ -1304,12 +1304,24 @@ new_device_store(struct device *dev, struct device_attribute *attr,
 		info.flags |= I2C_CLIENT_SLAVE;
 	}
 
+	mutex_lock_nested(&adap->userspace_clients_lock,
+			  i2c_adapter_depth(adap));
+
+	mutex_lock(&core_lock);
+	if (idr_find(&i2c_adapter_idr, adap->nr) != adap) {
+		mutex_unlock(&core_lock);
+		mutex_unlock(&adap->userspace_clients_lock);
+		return -ENODEV;
+	}
+	mutex_unlock(&core_lock);
+
 	client = i2c_new_client_device(adap, &info);
-	if (IS_ERR(client))
+	if (IS_ERR(client)) {
+		mutex_unlock(&adap->userspace_clients_lock);
 		return PTR_ERR(client);
+	}
 
 	/* Keep track of the added device */
-	mutex_lock(&adap->userspace_clients_lock);
 	list_add_tail(&client->detected, &adap->userspace_clients);
 	mutex_unlock(&adap->userspace_clients_lock);
 	dev_info(dev, "%s: Instantiated device %s at 0x%02hx\n", "new_device",
@@ -1826,8 +1838,6 @@ void i2c_del_adapter(struct i2c_adapter *adap)
 
 	i2c_host_notify_irq_teardown(adap);
 
-	debugfs_remove_recursive(adap->debugfs);
-
 	/* wait until all references to the device are gone
 	 *
 	 * FIXME: This is old code and should ideally be replaced by an
@@ -1847,6 +1857,8 @@ void i2c_del_adapter(struct i2c_adapter *adap)
 	/* Clear the device structure in case this adapter is ever going to be
 	   added again */
 	memset(&adap->dev, 0, sizeof(adap->dev));
+
+	debugfs_remove_recursive(adap->debugfs);
 }
 EXPORT_SYMBOL(i2c_del_adapter);
 
diff --git a/drivers/usb/phy/phy.c b/drivers/usb/phy/phy.c
index 5a9b9353f..e5643d4ce 100644
--- a/drivers/usb/phy/phy.c
+++ b/drivers/usb/phy/phy.c
@@ -80,18 +80,6 @@ static struct usb_phy *__of_usb_find_phy(struct device_node *node)
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
@@ -123,6 +111,9 @@ static void usb_phy_set_default_current(struct usb_phy *usb_phy)
 static void usb_phy_notify_charger_work(struct work_struct *work)
 {
 	struct usb_phy *usb_phy = container_of(work, struct usb_phy, chg_work);
+	char uchger_state[50] = { 0 };
+	char uchger_type[50] = { 0 };
+	char *envp[3];
 	unsigned int min, max;
 
 	switch (usb_phy->chg_state) {
@@ -130,11 +121,15 @@ static void usb_phy_notify_charger_work(struct work_struct *work)
 		usb_phy_get_charger_current(usb_phy, &min, &max);
 
 		atomic_notifier_call_chain(&usb_phy->notifier, max, usb_phy);
+		snprintf(uchger_state, ARRAY_SIZE(uchger_state),
+			 "USB_CHARGER_STATE=%s", usb_chger_state[usb_phy->chg_state]);
 		break;
 	case USB_CHARGER_ABSENT:
 		usb_phy_set_default_current(usb_phy);
 
 		atomic_notifier_call_chain(&usb_phy->notifier, 0, usb_phy);
+		snprintf(uchger_state, ARRAY_SIZE(uchger_state),
+			 "USB_CHARGER_STATE=%s", usb_chger_state[usb_phy->chg_state]);
 		break;
 	default:
 		dev_warn(usb_phy->dev, "Unknown USB charger state: %d\n",
@@ -142,36 +137,12 @@ static void usb_phy_notify_charger_work(struct work_struct *work)
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
+	envp[0] = uchger_state;
+	envp[1] = uchger_type;
+	envp[2] = NULL;
+	kobject_uevent_env(&usb_phy->dev->kobj, KOBJ_CHANGE, envp);
 }
 
 static void __usb_phy_get_charger_type(struct usb_phy *usb_phy)
@@ -675,11 +646,6 @@ int usb_add_phy(struct usb_phy *x, enum usb_phy_type type)
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
@@ -705,8 +671,6 @@ int usb_add_phy_dev(struct usb_phy *x)
 	if (ret)
 		return ret;
 
-	x->dev->type = &usb_phy_dev_type;
-
 	ATOMIC_INIT_NOTIFIER_HEAD(&x->notifier);
 
 	spin_lock_irqsave(&phy_lock, flags);
@@ -727,9 +691,13 @@ void usb_remove_phy(struct usb_phy *x)
 {
 	unsigned long	flags;
 
+	if (!x)
+		return;
+
+	cancel_work_sync(&x->chg_work);
+
 	spin_lock_irqsave(&phy_lock, flags);
-	if (x)
-		list_del(&x->head);
+	list_del(&x->head);
 	spin_unlock_irqrestore(&phy_lock, flags);
 }
 EXPORT_SYMBOL_GPL(usb_remove_phy);


base-commit: db2ddb87143519e20a95aa36c60b36107b736a58
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to Sign-off the patch as a human author
and send it to the upstream kernel mailing lists.
Reply with '#syz reject' to reject it ('#syz unreject' to undo).

See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
You can comment on the patch as usual, syzbot will try to address
the comments and send a new version of the patch if necessary.
syzbot engineers can be reached at syzkaller@googlegroups.com.
