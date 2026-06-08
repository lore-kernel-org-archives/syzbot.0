Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9D5A33F8D6;
	Mon,  8 Jun 2026 19:35:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780947350; cv=none; b=jJ24lMQeleCmSW1vqzDIq7TFMpm1sycgEh22mAIpK42eTTHR296UZCcowws4lXssdR5RgtPX1SovTBLI345BugbMfzc1Vs51BvZRZzTVqzYIng4yZqtTNwHE2JLOI3aohpnUxU44+XAwBkIMHG+VKpfjBELQm0DVzOEt6UuEgGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780947350; c=relaxed/simple;
	bh=/DBAYoClECj2dTRrZLgRx6NFxmOK6IygV3U020KZG3Q=;
	h=Mime-Version:Content-Type:Date:Message-Id:Subject:Cc:To:From:
	 References:In-Reply-To; b=J+MVwkJ0pglFllqRQmzwm4W6ROy/UxvUT6G4hz0ss9XrNRLKef8C3by+XsMj9EaM2bl1jLoUMXEk7RCq/FXEFKB8OPH8XhX2/PpvzQzZTdBzD3AJJcLGBN+lpNsTC3of/bZPs6a95vozVkTggrVYbbRTs87BBKwnCkm2UpvU3nw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ElfYByMT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ElfYByMT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D22861F00893;
	Mon,  8 Jun 2026 19:35:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780947349;
	bh=/DBAYoClECj2dTRrZLgRx6NFxmOK6IygV3U020KZG3Q=;
	h=Date:Subject:Cc:To:From:References:In-Reply-To;
	b=ElfYByMTHhnZIIapo9GpWKwSXWWIgQ1k0qNSuwIX7+AliqPTn9SLAsQk7n/cpVegp
	 hC+MyODZWKbQiuEDnQVn8vRlWdmx6RtkBSzKmRx+3g1wCH+THBkvLyfah60i7LiCjM
	 iskvEtbWEiAc8DK93E964H4fS/Z71Lr0lY/8XScgYtF0fiznRPkFXBUz9c7LXLWYfs
	 wAL2HHZd60wDUoB8IipQpOAQ+zNPDQ7P3PPevUQMtU8Vxpl7iieGrj8+RzRRYOUusE
	 6s59m4Vakskspoz+wlQIsgSrbedJVzijTSatX6ODwAxggIoOcqFTk5aixxAqFZOfBx
	 JDB7SB9g/K/ow==
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 08 Jun 2026 21:35:46 +0200
Message-Id: <DJ3X585GG3FJ.2OS0MKDAZPK61@kernel.org>
Subject: Re: [PATCH v2] firmware_loader: Fix recursive lock in
 device_cache_fw_images()
Cc: <syzkaller-bugs@googlegroups.com>, <driver-core@lists.linux.dev>, "Greg
 Kroah-Hartman" <gregkh@linuxfoundation.org>, "Luis Chamberlain"
 <mcgrof@kernel.org>, "Rafael J. Wysocki" <rafael@kernel.org>, "Russ Weight"
 <russ.weight@linux.dev>, <linux-kernel@vger.kernel.org>,
 <syzbot@lists.linux.dev>
To: "syzbot" <syzbot@kernel.org>
From: "Danilo Krummrich" <dakr@kernel.org>
References: <48b092a5-f49d-48a4-95f4-f65bebfc6bc3@mail.kernel.org>
In-Reply-To: <48b092a5-f49d-48a4-95f4-f65bebfc6bc3@mail.kernel.org>

On Fri May 29, 2026 at 5:09 PM CEST, syzbot wrote:
> From: Dmitry Vyukov <dvyukov@google.com>
>
> A recursive locking deadlock can occur in the firmware loader's power
> management notification handler.
>
> During system suspend or hibernation preparation, fw_pm_notify() calls
> device_cache_fw_images(). This function acquires fw_lock to set the
> firmware cache state to FW_LOADER_START_CACHE and then iterates over all
> devices using dpm_for_each_dev() while still holding the lock.
>
> For each device, dev_cache_fw_image() schedules asynchronous work to cach=
e
> the firmware. If memory allocation for the async work entry fails (e.g., =
in
> out-of-memory conditions), async_schedule_node_domain() falls back to
> executing the work function synchronously in the current thread.
>
> The synchronous execution path (__async_dev_cache_fw_image() ->
> cache_firmware() -> request_firmware() -> assign_fw()) attempts to acquir=
e
> fw_lock again. Since the current thread already holds fw_lock, this resul=
ts
> in a recursive locking deadlock.
>
> Fix this by releasing fw_lock immediately after updating the cache state
> and before calling dpm_for_each_dev(). The lock is only needed to protect
> the state update. Concurrent firmware requests will correctly see the
> FW_LOADER_START_CACHE state and use the piggyback mechanism, which is
> independently protected by its own fwc->name_lock.
>
> Fixes: ac39b3ea73aa ("firmware loader: let caching firmware piggyback on =
loading firmware")
> Assisted-by: Gemini:gemini-3.1-pro-preview Gemini:gemini-3-flash-preview =
syzbot
> Reported-by: syzbot+e70e4c6f6eee43357ba7@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3De70e4c6f6eee43357ba7
> Link: https://syzkaller.appspot.com/ai_job?id=3D8b4af9fd-24af-423f-8acb-1=
159fd34c1a5
> Signed-off-by: Dmitry Vyukov <dvyukov@google.com>

I think Sashiko found an orthogonal issue that looks valid at a first glanc=
e, in
case you are interested to dig in further.

[1] https://sashiko.dev/#/patchset/48b092a5-f49d-48a4-95f4-f65bebfc6bc3%40m=
ail.kernel.org
