Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A67CA3382E5
	for <syzbot@lists.linux.dev>; Wed, 26 Aug 2026 04:39:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787719174; cv=none; b=u8dqaLiJJiUA0JU/mLIWDVbyJxS9/06FIqiXUfR/I+MWaBP1fOkxGHZrWtmuB8IVE1TeIFPkOLGsI52O8ijzljrX1KUnckG2R21ioyQxAr+kbzr5s1DV4p0YMNlooFnR+MmF59rp3zS0ZUpiUadIw5RI+RozXfggufLrs8JPROI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787719174; c=relaxed/simple;
	bh=8ytuA+T5Tytz6F7rz8yPoAsf8h6STdlzBbBmS0gAyV8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=H8s4vaqLTPs75bIT9wKuF6/V8cny9LLPOfANQ4ZpEnbG85ckYPRZoREOKPTHl7jEOWTow4jjclXZEPmJLa2DW1SKVQDACIKYDPnO62vAElsVyuqnyvZ2QUOZbVG0Y5JPvk0ujQ4FbpeJneLLI0MYZOGFptJ19/An3059TzXuqL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LZ8tkXEr; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LZ8tkXEr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1787719172; x=1819255172;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=8ytuA+T5Tytz6F7rz8yPoAsf8h6STdlzBbBmS0gAyV8=;
  b=LZ8tkXErzSInFJ7wgrRIuGWgYP0jQKM39ihcKo6rIu/aDwRqRfijVPJl
   rIFR8rUV90rEDFfrl8EZb6fSXCOGrSYQD1YU5ezx5tXruUAAyat7toBq4
   rTk/8j2mQFZCQm/lO5+XfQJ+3uWKrEGieqiulZw68kLS5a0WbPmUlXoe/
   S7VENelaKuEpMbVcVfA5d/oM0ouW2WE+qKE08QhN0nc+NYY/GzHifOnEb
   gdAUCSdTmEToKBdW7N/ulXhKanPYIIZO+zeCL8aLqwVxxd+M4kzR7PKtV
   hWC2vks1dkZsJ/VQcLjH57aD+dzeM+iMjSg62DswM8bWs9kPP1HDHdM1A
   A==;
X-CSE-ConnectionGUID: ud5psU9nTKWO54SWF7RArw==
X-CSE-MsgGUID: pq5MCIiAR5mMiyGfOizP5g==
X-IronPort-AV: E=McAfee;i="6800,10657,11886"; a="98867582"
X-IronPort-AV: E=Sophos;i="6.25,244,1779174000"; 
   d="scan'208";a="98867582"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2026 21:39:32 -0700
X-CSE-ConnectionGUID: RHUMZXEzSq67Dw5tq2wM8w==
X-CSE-MsgGUID: HEOx8XOEQ2WbdkuYKgNq3g==
X-ExtLoop1: 1
Received: from black.igk.intel.com ([10.91.253.5])
  by fmviesa003.fm.intel.com with ESMTP; 25 Aug 2026 21:39:30 -0700
Received: by black.igk.intel.com (Postfix, from userid 1001)
	id 23F1A99; Wed, 26 Aug 2026 06:39:29 +0200 (CEST)
Date: Wed, 26 Aug 2026 06:39:29 +0200
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-bugs@googlegroups.com, Marco Elver <elver@google.com>,
	Yehezkel Bernat <YehezkelShB@gmail.com>,
	Andreas Noever <andreas.noever@gmail.com>,
	linux-usb@vger.kernel.org, Mika Westerberg <westeri@kernel.org>,
	linux-kernel@vger.kernel.org, syzbot@lists.linux.dev
Subject: Re: [PATCH] thunderbolt: Validate BAR 0 resource type and size
Message-ID: <20260826043929.GM893316@black.igk.intel.com>
References: <9e0d4fdc-4e1d-4195-80c0-7a70d34d1fc2@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <9e0d4fdc-4e1d-4195-80c0-7a70d34d1fc2@mail.kernel.org>

Hi,

On Tue, Aug 25, 2026 at 04:09:37PM +0000, syzbot wrote:
> From: Marco Elver <elver@google.com>
> 
> The thunderbolt driver can crash with a page fault if it binds to an
> arbitrary PCI device (e.g., via sysfs driver_override) that has an I/O port
> BAR at index 0 instead of an MMIO BAR.

Well, if you bind it to a random PCIe device you get what you asked for.
This is specifically the reason we have the PCI IDs and the like in the
drivers. Anything outside of that you need to know what you are doing.
