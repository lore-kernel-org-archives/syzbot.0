Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19FF0385D8E
	for <syzbot@lists.linux.dev>; Wed, 26 Aug 2026 06:10:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787724631; cv=none; b=a3EOH/MMeaRHhrDAvo2LQlUdgyeriesQfbrbt7YP+mHvC3E0ThlJTjogZX8bVN6XC4CHAwvjvnwweICpxpL3KTEchIDkVW6G5D8CzZj4ET8TG/LFFokEXsPWOh8ySUE4jIwjoBzSyAucDInzDbGd6rrygOvm0rXBmeKGrYO/jhs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787724631; c=relaxed/simple;
	bh=+pKbfSojXMdWncfZ6cPmxHkjSWOZq+MQlp7gop/jr9U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rW1voQL7fEl8RF1EDOzb4MmNoU8ex80I3RGaZPAsPo1ubOBjA6wl5lyT5P5FIB8kQZlSi8/5Ok35AEL3zYUJKrtKPqczi/bf5PSPSuCO6QZSqV6lF+D/j34jc2wj9ADUF9/hgvJx1LVqIOxFWrSw7F4smUBeFJzTMFfQt0RXANM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1bciFrVX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1bciFrVX"
Received: by smtp.kernel.org (Postfix)
	id B53941F00A3A; Wed, 26 Aug 2026 06:10:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20E6B1F000E9;
	Wed, 26 Aug 2026 06:10:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787724629;
	bh=ijTHpg4ninK7jcdWXq8TEYH1Zx2GGUA5GeBrdUC9EZs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=1bciFrVXZoV1QrB6sneKhG3TKczj8GqNmKnPkjRQsmRKxS3jVls7kHiJU5VDRtP5g
	 MpKibOfcogGTxwJrHUcUW/hm6mAfuhuM1T8fCte31Bvfa4vQubMSPjZy4H8v/rtV8n
	 JDmny6WD+l5LU0fLhxZ/ygLsZqM08Df8cpe59/I8=
Date: Wed, 26 Aug 2026 08:08:48 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: syzbot <syzbot@kernel.org>, syzkaller-bugs@googlegroups.com,
	Marco Elver <elver@google.com>,
	Yehezkel Bernat <YehezkelShB@gmail.com>,
	Andreas Noever <andreas.noever@gmail.com>,
	linux-usb@vger.kernel.org, Mika Westerberg <westeri@kernel.org>,
	linux-kernel@vger.kernel.org, syzbot@lists.linux.dev
Subject: Re: [PATCH] thunderbolt: Validate BAR 0 resource type and size
Message-ID: <2026082622-bunkmate-bleep-6716@gregkh>
References: <9e0d4fdc-4e1d-4195-80c0-7a70d34d1fc2@mail.kernel.org>
 <20260826043929.GM893316@black.igk.intel.com>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260826043929.GM893316@black.igk.intel.com>

On Wed, Aug 26, 2026 at 06:39:29AM +0200, Mika Westerberg wrote:
> Hi,
> 
> On Tue, Aug 25, 2026 at 04:09:37PM +0000, syzbot wrote:
> > From: Marco Elver <elver@google.com>
> > 
> > The thunderbolt driver can crash with a page fault if it binds to an
> > arbitrary PCI device (e.g., via sysfs driver_override) that has an I/O port
> > BAR at index 0 instead of an MMIO BAR.
> 
> Well, if you bind it to a random PCIe device you get what you asked for.
> This is specifically the reason we have the PCI IDs and the like in the
> drivers. Anything outside of that you need to know what you are doing.
> 

And again, I keep telling the syzbot people that this is not a valid
thing to care about...
