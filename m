Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D63A63BFAD7;
	Thu, 21 May 2026 11:30:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779363045; cv=none; b=DG/mo7RqKGupNc03Zl4xA7Zhzt0ryL+90Ib9Xawr63EojnvL+3N8m7kJfy1b4jLALqTiF/GZ7fE1nldMsik0lx7Rm3mH85+FT4Zu7qFi4dgXoaGdLa2mgf5hLl6f4MdAeHnZRUm/B+qX2wEtXU3GxLQr5nbl1DI52AYgN2MGgPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779363045; c=relaxed/simple;
	bh=kikolszf4w9PXS8Iw7m1gGgVUfa9dVQ+uQN7hot1xy0=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=TITEP0oLZ4YQuITi1Db1o7cvbGx8+GZEreY6NgK/Kes+GqbV77J9L6KhPNek+k47WxxRWo+pppHE282y/8xD0nsPjFYQ7NJ8H+ermrb52KGIJ/rsZYe6ioceWftjFy8heEgM3i55fgvPlhAJItViBAQg1LXXWq9a3t6XzbuZkT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DJF1eqth; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DJF1eqth"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 288EC1F00A3B;
	Thu, 21 May 2026 11:30:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779363044;
	bh=g6UPmuyFKZf8/EbDhEVEqHRNyMYrw3ry909YZziWJqE=;
	h=From:To:Cc:Subject:Date;
	b=DJF1eqthW/vFlgeuK59r94s4JBYJBqFVcKlmRPA532bjWXZ9YnXRZG8cCWY7rPi76
	 Q5RKD2we/hPLTc4Y4MoFq9IeCDrzLD4T26Ip3S8w2zY1PrxhGGidBGGpfwS3ppAfM0
	 OnexPMdAVtLpegGE44+jRKhoUdukMfQ9Y+5sfNC96gMLLyrCX8GpxMbC2YoyQNY+Dy
	 IHdniCw8PlEfsOXPxSlScyW/FBdThObaRkdO7y44e8oJ6h/6vM8jI+bQam6atZ/ThQ
	 QefHXexd+1xgf0ziGwYV9JBCAwjTXC9jDXtfUY4k9vQJ4LRgPUzJSEpVFpGwsUR6CF
	 2aVdAdPRPqieQ==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-bugs@googlegroups.com, "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>, <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rafael@kernel.org>
Cc: dakr@kernel.org, driver-core@lists.linux.dev, mcgrof@kernel.org, russ.weight@linux.dev, syzbot@lists.linux.dev
Subject: [PATCH] firmware_loader: Fix recursive lock in device_cache_fw_images()
Message-ID: <dff1dcc7-59bd-40c7-981e-bd805ae6b3c1@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Thu, 21 May 2026 11:30:44 +0000 (UTC)

A recursive locking deadlock can occur in the firmware loader's power
management notification handler.

During system suspend or hibernation preparation, fw_pm_notify() calls
device_cache_fw_images(). This function acquires fw_lock to set the
firmware cache state to FW_LOADER_START_CACHE and then iterates over
all devices using dpm_for_each_dev() while still holding the lock.

For each device, dev_cache_fw_image() schedules asynchronous work to
cache the firmware. If memory allocation for the async work entry fails
(e.g., in out-of-memory conditions), async_schedule_node_domain()
falls back to executing the work function synchronously in the current
thread.

The synchronous execution path (__async_dev_cache_fw_image() ->
cache_firmware() -> request_firmware() -> assign_fw()) attempts
to acquire fw_lock again. Since the current thread already holds
fw_lock, this results in a recursive locking deadlock.

Fix this by releasing fw_lock immediately after updating the cache
state and before calling dpm_for_each_dev(). The lock is only needed
to protect the state update. Concurrent firmware requests will correctly
see the FW_LOADER_START_CACHE state and use the piggyback mechanism,
which is independently protected by its own fwc->name_lock.

Fixes: ac39b3ea73aa ("firmware loader: let caching firmware piggyback on loading firmware")
Assisted-by: Gemini:gemini-3.1-pro-preview Gemini:gemini-3-flash-preview
Reported-by: syzbot+e70e4c6f6eee43357ba7@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=e70e4c6f6eee43357ba7
Link: https://syzkaller.appspot.com/ai_job?id=8cbf9f7d-812d-4db3-89fa-0aaef3ce3a2f
Signed-off-by: Dmitry Vyukov <dvyukov@google.com>

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
See https://github.com/google/syzkaller/blob/master/docs/syzbot_ai_patches.md for more information.
