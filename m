Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13FD53BA24F;
	Fri, 29 May 2026 15:09:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780067348; cv=none; b=k4SzdUbt/mOxM1qkuuZ1wVtMx6JCZHNHesniaN/ytmTJB38y0jipbkSLxe6CW+RdazySjQeJpQcT/E+KhQeneKrvSKWgjjKa9TtkfSZSzHm+cMS3H3S8RNhLe9udRU+M0cJn1kkXLqn18xUf+FKbofMWTORo64mKaBC1XhokZvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780067348; c=relaxed/simple;
	bh=yoRDc3CW4KL7N6WXuaihwF/b7WcCWr04XcKKb6kcs48=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=IuQtD6xdVXuecgOkShi501g8fkqNqcd2dKReX/v4faHRQD0HiIQg7dhrdVCTi9w6ypQSvw/YXCtC2BTieHk3AYqLb70wUXtrj7qC5yhQ0pxxRGTYtrDY7SwcWjYx8C4+Twq/6aJNjnNYPdtv19JHgSp687L7/faiMji7GZrx10Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IxorH6rJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IxorH6rJ"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 4F3DB1F00893;
	Fri, 29 May 2026 15:09:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780067346;
	bh=do7qptOmJTrK8aQUXA6m9d7yz85d6OF2eFi/f8phMEw=;
	h=From:To:Cc:Subject:Date;
	b=IxorH6rJe6ocE+kmuxttnHtQKcnYmV9OesKV2+Qzih9s+ufqtZuDhynm6XeUtNu4z
	 StXOD857LcSgbdgH/RKdNsYI3srkuA1q1TwlMUBLC7nUM98TgMYEtBU3CEVBQ9LD0q
	 2ruvm0ecA3mM3Xn/r/BoOD8l8mwO42BFju80N6RjkwOLvowL6e9ji03aP9gasf/YTB
	 OMxdH+Yy/OYdy/0nEAhXNpoKkenXX2NjsXxKsTmF4fQuQBKVaYTLqTqQNyJ90UkPi6
	 m7BjiPNCpfvQGgr6OkEcgjZFto6b5zTJ7+qKBxWAJZx+MVcQMZQ9xBYBggcVEGIzQl
	 y+hEn/RHiO/2A==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-bugs@googlegroups.com, "Danilo Krummrich" <dakr@kernel.org>, <driver-core@lists.linux.dev>, "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>, "Luis Chamberlain" <mcgrof@kernel.org>, "Rafael J. Wysocki" <rafael@kernel.org>, "Russ Weight" <russ.weight@linux.dev>
Cc: linux-kernel@vger.kernel.org, syzbot@lists.linux.dev
Subject: [PATCH v2] firmware_loader: Fix recursive lock in device_cache_fw_images()
Message-ID: <48b092a5-f49d-48a4-95f4-f65bebfc6bc3@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Fri, 29 May 2026 15:09:06 +0000 (UTC)

From: Dmitry Vyukov <dvyukov@google.com>

A recursive locking deadlock can occur in the firmware loader's power
management notification handler.

During system suspend or hibernation preparation, fw_pm_notify() calls
device_cache_fw_images(). This function acquires fw_lock to set the
firmware cache state to FW_LOADER_START_CACHE and then iterates over all
devices using dpm_for_each_dev() while still holding the lock.

For each device, dev_cache_fw_image() schedules asynchronous work to cache
the firmware. If memory allocation for the async work entry fails (e.g., in
out-of-memory conditions), async_schedule_node_domain() falls back to
executing the work function synchronously in the current thread.

The synchronous execution path (__async_dev_cache_fw_image() ->
cache_firmware() -> request_firmware() -> assign_fw()) attempts to acquire
fw_lock again. Since the current thread already holds fw_lock, this results
in a recursive locking deadlock.

Fix this by releasing fw_lock immediately after updating the cache state
and before calling dpm_for_each_dev(). The lock is only needed to protect
the state update. Concurrent firmware requests will correctly see the
FW_LOADER_START_CACHE state and use the piggyback mechanism, which is
independently protected by its own fwc->name_lock.

Fixes: ac39b3ea73aa ("firmware loader: let caching firmware piggyback on loading firmware")
Assisted-by: Gemini:gemini-3.1-pro-preview Gemini:gemini-3-flash-preview syzbot
Reported-by: syzbot+e70e4c6f6eee43357ba7@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=e70e4c6f6eee43357ba7
Link: https://syzkaller.appspot.com/ai_job?id=8b4af9fd-24af-423f-8acb-1159fd34c1a5
Signed-off-by: Dmitry Vyukov <dvyukov@google.com>

---
v2:
- Resend to fix the From: line as requested by reviewer.

v1:
https://lore.kernel.org/all/dff1dcc7-59bd-40c7-981e-bd805ae6b3c1@mail.kernel.org/T/
---
diff --git a/drivers/base/firmware_loader/main.c b/drivers/base/firmware_loader/main.c
index a11b30dda..c96312ac2 100644
--- a/drivers/base/firmware_loader/main.c
+++ b/drivers/base/firmware_loader/main.c
@@ -1503,9 +1503,10 @@ static void device_cache_fw_images(void)
 
 	mutex_lock(&fw_lock);
 	fwc->state = FW_LOADER_START_CACHE;
-	dpm_for_each_dev(NULL, dev_cache_fw_image);
 	mutex_unlock(&fw_lock);
 
+	dpm_for_each_dev(NULL, dev_cache_fw_image);
+
 	/* wait for completion of caching firmware for all devices */
 	async_synchronize_full_domain(&fw_cache_domain);
 


base-commit: 7fd2df204f342fc17d1a0bfcd474b24232fb0f32
-- 
See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
You can comment on the patch as usual, syzbot will try to address
the comments and send a new version of the patch if necessary.
syzbot engineers can be reached at syzkaller@googlegroups.com.
