Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E94DDDCD
	for <syzbot@lists.linux.dev>; Sun, 10 May 2026 13:05:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778418338; cv=none; b=HeVzrhdArEpMKq8rSF/viBzCkXmCjxPcRsCaCoDvD7Hzpv1MuKyV7Huo0FxXLfDx73TGh2KdP1V10x5LJv7kVIY3RnNRxSR/oWiQ7mzOaJ95BC5gF+O4v0deQ7VVv5Sp05WcssmC4mjlvEXXpOkskWwjVZ83uZK55kJOHb6wxrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778418338; c=relaxed/simple;
	bh=/Prm7pQ+X/kmYfwDxkM7gykr6oWZM1B1XmGRybs5MpQ=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=LQWVEw24w9YKIqHY8Tpqrh/X60uMIpOKJdBLO4vbF54Dh2V8QirZ1EM815QmZgL+xAGWbjQeEaME7+ZZBxMrxtkEzUjeagyB/R5QTF6u5RPgVesZIukfgEhFS9w/hpWzJG+5YvKz23qXur4Slk2kUi7LV90FD6YvpNnTqu1R+kQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WIQDvGkW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WIQDvGkW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06FCEC2BCB8;
	Sun, 10 May 2026 13:05:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778418338;
	bh=/Prm7pQ+X/kmYfwDxkM7gykr6oWZM1B1XmGRybs5MpQ=;
	h=From:To:Cc:Subject:Date:From;
	b=WIQDvGkWlxJ+4h2JAVy65FljG9ezXDTtdtwk+HaHMP4sugn2vByDjyoM7B2EAnJQU
	 tWeHqST/U+Nn/UOieQ23ennDWvpqO/0r9VIusFDx+2uL0m3n/PGJrf4smdf69noD47
	 PtW5co+WXhQ12YtuMX/wGqOz32zj4FRIgL7eVUnuoPRtX0FQObHSGNg/uV7PU3PbhO
	 FRwL/usdmWv1MJJUqgrLXV8FhEVEoACfCHmPYEf1RO+4qOzBWd2a+7YcTWG9jn5FYB
	 qua+P/yvY0ffDaEd9J3NBuuSEmMmFwzib6PRf8Gd8nVDgrq3aOIfW9Rl5C8kdcEriY
	 5swxl0s+krnjg==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] firmware_loader: Fix recursive lock in device_cache_fw_images()
Message-ID: <7b8b3fbf-950b-4418-8cf1-772a4d639b14@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Sun, 10 May 2026 13:05:37 +0000 (UTC)

firmware_loader: Fix recursive lock in device_cache_fw_images()

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

Assisted-by: Gemini:gemini-3.1-pro-preview Gemini:gemini-3-flash-preview
To: <gregkh@linuxfoundation.org>
To: <linux-kernel@vger.kernel.org>
To: <rafael@kernel.org>
Cc: <dakr@kernel.org>
Cc: <driver-core@lists.linux.dev>
Cc: <mcgrof@kernel.org>
Cc: <russ.weight@linux.dev>

---
diff --git a/drivers/base/firmware_loader/main.c b/drivers/base/firmware_loader/main.c
index a11b30dda..68d5d30aa 100644
--- a/drivers/base/firmware_loader/main.c
+++ b/drivers/base/firmware_loader/main.c
@@ -1503,10 +1503,11 @@ static void device_cache_fw_images(void)
 
 	mutex_lock(&fw_lock);
 	fwc->state = FW_LOADER_START_CACHE;
-	dpm_for_each_dev(NULL, dev_cache_fw_image);
 	mutex_unlock(&fw_lock);
 
-	/* wait for completion of caching firmware for all devices */
+	dpm_for_each_dev(NULL, dev_cache_fw_image); /*
+
+*/	/* wait for completion of caching firmware for all devices */
 	async_synchronize_full_domain(&fw_cache_domain);
 
 	fw_fallback_set_default_timeout();


base-commit: 7fd2df204f342fc17d1a0bfcd474b24232fb0f32
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to send it to the mailing list.
Reply with '#syz reject' to reject it.

See  for more information.
