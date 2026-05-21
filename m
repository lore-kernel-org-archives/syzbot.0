Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9542E3C4B88
	for <syzbot@lists.linux.dev>; Thu, 21 May 2026 11:46:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779363977; cv=none; b=qLerEFW1ANX73kjUm4K6afK1JQF0FSMhBm92f/Au4y4keUt0nluanvWAy1q27dl0QtRYRwqINOIsoQABsAUb6XpQ7hejadVIbDDCc/cs/k0bpDZs1mcexQe3/vMsFP5ntxhJRyZC97mND6LypNFyznd5/FJy0dwD7u4uz2YAyuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779363977; c=relaxed/simple;
	bh=88YWbpA4s562i+uRzCAHGOkjwm+Gi21/0R3m2QgzXcY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aCXOfqukVnDmNmTep/uxUcd6b03DUygUk5rMCCfdEQgIjeZhfkuqDSdpcxTITo/IJy/j9yVdFPqe9rIE/E4u2X4OPpXuF/Nq4NQystmzZz691qBJ/EDAyMc2uLB0Eb68KNjWp0vvx696rNzU7dEVoC5bgNl2OklV9miYkVLGBJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=floP4nZn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="floP4nZn"
Received: by smtp.kernel.org (Postfix)
	id 7EDC01F00A3B; Thu, 21 May 2026 11:46:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB9FA1F000E9;
	Thu, 21 May 2026 11:46:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779363976;
	bh=zTSi112qJzyCLhgpvHNZdwlnR4ZDk7z5Dtx5aftlRgw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=floP4nZnvbJHFGzoxEMM9najVP9LN6JdEbhYQxd/ATq83g/oBeCw6aKHSKMVSqbYg
	 4O1g6v8hUn6US8S2xjCRfDaR5e9HWtqLGhlphAwPP6opvK2VSG+9vNm6DGv8mPSi2m
	 Ul5lB91ZoAIADePqfsGRJnOeaLK7Dm8DULrd+fiw=
Date: Thu, 21 May 2026 13:46:19 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-bugs@googlegroups.com, linux-kernel@vger.kernel.org,
	"Rafael J. Wysocki" <rafael@kernel.org>, dakr@kernel.org,
	driver-core@lists.linux.dev, mcgrof@kernel.org,
	russ.weight@linux.dev, syzbot@lists.linux.dev
Subject: Re: [PATCH] firmware_loader: Fix recursive lock in
 device_cache_fw_images()
Message-ID: <2026052107-recast-opt-946d@gregkh>
References: <dff1dcc7-59bd-40c7-981e-bd805ae6b3c1@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dff1dcc7-59bd-40c7-981e-bd805ae6b3c1@mail.kernel.org>

On Thu, May 21, 2026 at 11:30:44AM +0000, syzbot wrote:
> A recursive locking deadlock can occur in the firmware loader's power
> management notification handler.
> 
> During system suspend or hibernation preparation, fw_pm_notify() calls
> device_cache_fw_images(). This function acquires fw_lock to set the
> firmware cache state to FW_LOADER_START_CACHE and then iterates over
> all devices using dpm_for_each_dev() while still holding the lock.
> 
> For each device, dev_cache_fw_image() schedules asynchronous work to
> cache the firmware. If memory allocation for the async work entry fails
> (e.g., in out-of-memory conditions), async_schedule_node_domain()
> falls back to executing the work function synchronously in the current
> thread.
> 
> The synchronous execution path (__async_dev_cache_fw_image() ->
> cache_firmware() -> request_firmware() -> assign_fw()) attempts
> to acquire fw_lock again. Since the current thread already holds
> fw_lock, this results in a recursive locking deadlock.
> 
> Fix this by releasing fw_lock immediately after updating the cache
> state and before calling dpm_for_each_dev(). The lock is only needed
> to protect the state update. Concurrent firmware requests will correctly
> see the FW_LOADER_START_CACHE state and use the piggyback mechanism,
> which is independently protected by its own fwc->name_lock.
> 
> Fixes: ac39b3ea73aa ("firmware loader: let caching firmware piggyback on loading firmware")
> Assisted-by: Gemini:gemini-3.1-pro-preview Gemini:gemini-3-flash-preview
> Reported-by: syzbot+e70e4c6f6eee43357ba7@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=e70e4c6f6eee43357ba7
> Link: https://syzkaller.appspot.com/ai_job?id=8cbf9f7d-812d-4db3-89fa-0aaef3ce3a2f
> Signed-off-by: Dmitry Vyukov <dvyukov@google.com>

"syzbot" can not be an author :(

