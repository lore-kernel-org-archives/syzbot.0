Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8570F2C1586
	for <syzbot@lists.linux.dev>; Fri, 31 Jul 2026 19:45:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785527125; cv=none; b=MimDK+mgGHv7xnU+ZHZKlv/1nZhGErC0HAB/H3sTruK3fzKegljgJVH5q6hZKdHhCe24r1AG20LTJ3yiFPxT9JUBMBCD6Q8omuRkARLMD8sPlqOOL1re6qb0bkc9UoCMcgcUsOcJp1jlKdxa55tKHZnWOgqPTq1dZRFxJ5sSJgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785527125; c=relaxed/simple;
	bh=NWJQXpMun4RvJz+N1cruXjW8PFVvRG8ukGxWBva6L8Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Sxwzm5LQnn1kmgmhnHNlXFXNvgYyQreHDY2z9tcB0iQ8Qmc/s5QsqJ/8bWCtWAsiXOhosh31z+VBRHaHPnAFBr5U3/xX1FM0c6iveGbmlsKW723+8mOhx9EXt9OD9e/+ieLe8T4rB/ozfsmq4dcNp+zb3p/oNoUPv2l4x3LbrZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BeJ9+1mi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BeJ9+1mi"
Received: by smtp.kernel.org (Postfix)
	id 580AC1F00ACA; Fri, 31 Jul 2026 19:45:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0838D1F00AC4;
	Fri, 31 Jul 2026 19:45:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785527124;
	bh=3jI9CC/sZ4ARLXSiOgtugxrCVXTNu14jQbrcYaBcmFo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=BeJ9+1miorW0FS3VdnJ/I13Q7ie9xhc+/fDIbznrDrx734J1CKN/t9TEaWThrc37G
	 b6FYEszzaVww3XJ/Ub1E7fY18S9s/vrpxID8jmH33+PgPJAZI3H8DEq7AjsyRjJeiF
	 vdfixkVkVzB4xMG4SbJP4ONe2JkgiJPv4gd8qIaHWwWu+s9M5KmVdF9YjI89tcQR3n
	 RO4Eg80xATtrLtjikTeM3FbsvnTQuB6bVem2mTil4xJVMGAlNYA4YQZ5kZ8ezA9ryt
	 ruFq4wOE5WukvObQB5LwM1cIPk+m2KWPmTTMXbR3Dt02l4FMMlam2D/Nu6Pt+doGmo
	 m8RDb0wvW8xWg==
Message-ID: <1bc703a1-132f-4472-a703-d5c804d215c8@kernel.org>
Date: Fri, 31 Jul 2026 21:45:19 +0200
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] wifi: zd1211rw: reject secondary interfaces to prevent
 conflicts
Content-Language: en-US
To: Jeff Johnson <jeff.johnson@oss.qualcomm.com>, syzbot <syzbot@kernel.org>,
 syzkaller-bugs@googlegroups.com, Slawomir Stepien <sst@poczta.fm>,
 linux-wireless@vger.kernel.org, Daniel Drake <dsd@gentoo.org>
Cc: johannes.berg@intel.com, kees@kernel.org, linux-kernel@vger.kernel.org,
 nihaal@cse.iitm.ac.in, syzbot@lists.linux.dev, workflows@vger.kernel.org
References: <0720e3ad-d98e-47d7-89af-4d22416b0fbc@mail.kernel.org>
 <dbe5b96e-c95c-474e-aca0-8227fee4682a@oss.qualcomm.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <dbe5b96e-c95c-474e-aca0-8227fee4682a@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 7/31/26 19:36, Jeff Johnson wrote:
> On 7/29/2026 1:04 AM, syzbot wrote:
>> From: Slawomir Stepien <sst@poczta.fm>
>> 
>> The zd1211rw driver is designed for single-function Wi-Fi dongles and
>> hardcodes its USB endpoints. When a malformed USB device exposes multiple
>> interfaces that match the driver's device ID, the driver blindly binds to
>> all of them.
>> 
>> During probe(), the driver calls usb_reset_device(), which iterates over
>> all interfaces and invokes the pre_reset() callback for each bound
>> interface. Since multiple interfaces are bound to zd1211rw, pre_reset() is
>> called sequentially for each instance, acquiring their respective
>> &mac->chip.mutex. Because all instances initialize their mutexes with the
>> same lock class, lockdep detects a task acquiring a lock of the same class
>> it already holds and flags it as a possible recursive deadlock:
>> 
>> WARNING: possible recursive locking detected
>> kworker/0:1/11 is trying to acquire lock:
>> ffff88810371dde0 (&chip->mutex){+.+.}-{4:4}, at:
>> zd_chip_disable_rxtx+0x20/0x50
>> drivers/net/wireless/zydas/zd1211rw/zd_chip.c:1465
>> 
>> but task is already holding lock:
>> ffff8881138ddde0 (&chip->mutex){+.+.}-{4:4}, at: pre_reset+0x28c/0x380
>> drivers/net/wireless/zydas/zd1211rw/zd_usb.c:1505
>> 
>> Fix this by explicitly rejecting secondary interfaces (bInterfaceNumber !=
>> 0) during probe(). This ensures that only a single instance of the driver
>> binds to the device, eliminating the recursive locking scenario.
>> 
>> Fixes: e85d0918b54f ("[PATCH] ZyDAS ZD1211 USB-WLAN driver")
>> Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot
>> Reported-by: syzbot+0ec3d1a6cf1fbe79c153@syzkaller.appspotmail.com
>> Closes: https://syzkaller.appspot.com/bug?extid=0ec3d1a6cf1fbe79c153
>> Link: https://syzkaller.appspot.com/ai_job?id=00724ef7-fd77-4cde-9779-895b8f63c2f6
>> Signed-off-by: Slawomir Stepien <sst@poczta.fm>
> 
> E-mail from syzbot but SOB from a human?
> 
> I read the trailer, but this seems to violate:
> https://docs.kernel.org/process/coding-assistants.html
> 
> Namely:
> AI agents MUST NOT add Signed-off-by tags. Only humans can legally certify the
> Developer Certificate of Origin (DCO).
> 
> +workflows list

The original mail [1] has this at the bottom:

> See https://goo.gle/syzbot-ai-patches for information about AI-generated
patches.

Where it says:

> Patches mailed to the kernel mailing lists were reviewed and Signed-off-by
by at least one human developer in accordance with AI Coding Assistants
guidelines.

Since From: and S-o-b: refers to a human developer, and there's Assisted-by:
it seems to be according to the rules. The "From: syzbot" seems to be just a
sending mechanism, that wouldn't even make it to the git commit log.

[1]
https://lore.kernel.org/all/0720e3ad-d98e-47d7-89af-4d22416b0fbc@mail.kernel.org/


