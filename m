Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE8D937BE8E
	for <syzbot@lists.linux.dev>; Sat, 16 May 2026 12:26:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778934361; cv=none; b=sE+xWv2/IV+iGktTv55/0Ug+5lgPEopn/MdSPys10hm/O+ztGW2Mhy0hHyhP9xZZ9pgxDBxtaK8uNbMNOxeKYI6gsJX/nTU+L0eK1NC+HSJfTJwItS1Ms5m7V1KGwtrd2uE4zNc52cmZjQnvlRPnFoALXagsYpK3zN4ePpAa1Mw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778934361; c=relaxed/simple;
	bh=6inoyGeSh18m0UsYrNPMOONxR2O7aI5V1G6yGrPMJQY=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=OB12SUig7Yn3gsDxsCpb1pPa5lnGYNso5bYD+kWTY3a1BTlZLNcxIVowzVPlYWhDq8XV8CU9WGKANFikQ15L+eGe2+UrFpokE27lXefMFqD1dEFxkb3FAvSP2RvJ1/TfLTp68bL4fUTr+DRPkIjyzhku+r8tM1DWLThm0nwFkMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=M0CyL5y/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M0CyL5y/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48FB3C19425;
	Sat, 16 May 2026 12:26:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778934361;
	bh=6inoyGeSh18m0UsYrNPMOONxR2O7aI5V1G6yGrPMJQY=;
	h=From:To:Cc:Subject:Date:From;
	b=M0CyL5y//mnlcBTd1pwZ2y/FfOvYgZOHNM1Hb+mn0MgwM/p+ppRvFgrmNYkX8QxGw
	 WOZQptSUv6CzefGPVwUDMchs2EmfJNoqdVqDW11WJUrGYlS/Z4DqR3sh6fO3ZzUhfV
	 ncHK6snXtPFCDos8CgwYZRzy8z6JAQHU3cbox9PU+9QDXL3cDQmPIiKhp/zGzrV1x5
	 2Itug9wvD5tcR/QZsFyJv1/JXrgXjIFAsdoDOjL29CCG6w5plQILJZWmwi0tPsniYb
	 xMUrt7tAONF/4TTZbN84/VoyuRTPMkG2fSzieI5+6b2Ma+T/lceri1nPXPXQTrP+qu
	 I3zE9Yns/YuQw==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC v2] firmware_loader: Fix recursive lock in device_cache_fw_images()
Message-ID: <83f1cd4e-d372-4be8-8ce6-32cbd7195ab1@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Sat, 16 May 2026 12:26:01 +0000 (UTC)

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

Fixes: ac39b3ea73aacde876d1d5ee1ca3e2719f771482 ("firmware loader: let caching firmware piggyback on loading firmware")
Assisted-by: Gemini:gemini-3.1-pro-preview Gemini:gemini-3-flash-preview
Reported-by: syzbot+e70e4c6f6eee43357ba7@syzkaller.appspotmail.com
Link: https://syzkaller.appspot.com/bug?extid=e70e4c6f6eee43357ba7
Link: https://syzkaller.appspot.com/ai_job?id=8cbf9f7d-812d-4db3-89fa-0aaef3ce3a2f
To: <gregkh@linuxfoundation.org>
To: <linux-kernel@vger.kernel.org>
To: <rafael@kernel.org>
Cc: <dakr@kernel.org>
Cc: <driver-core@lists.linux.dev>
Cc: <mcgrof@kernel.org>
Cc: <russ.weight@linux.dev>

---
v2:
- Removed the empty comment after dpm_for_each_dev().

v1:
https://lore.kernel.org/all/7b8b3fbf-950b-4418-8cf1-772a4d639b14@mail.kernel.org/T/
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
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to send it to the mailing list.
Reply with '#syz reject' to reject it.

See  for more information.
