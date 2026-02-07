Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 976152E3387
	for <syzbot@lists.linux.dev>; Sat,  7 Feb 2026 05:41:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770442890; cv=none; b=Gh85NPjaQzu6kI+Or3F8Qb002RlHDDhUHv9Yl9ocIhpiRLVgOF0eTCoRP5s+wYwzsasUp0hpX0ODmHOToSvEqDIK9rS3/L6Bnby2GfgXwhaOKsA30hkUtL47Hr4hWt1O9CIuzHyYOBLAgqrlWlNwtmiFQ0NsQBkbu1brFmN/xLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770442890; c=relaxed/simple;
	bh=pM9/YDTyKKI0sD4Dhh4VK/fPcuA6cFUij7u1q0xmBNM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JZvXP4K13gPcBUH3irgUhtkUYPH6M6zl066nLAaAeul/l6nGhTrVtaDiXhvVFtWo/KpOXaJieRGQRTT4ozR3IdeNgT1OtIdnRp6cLwIMjMd0YhXW5yfs+e1yuwjasZGbRM7GwhEPfj12YIvsNIU2o1Ua2zImey6Q/UcLU6LKCKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cJ3hDO6a; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cJ3hDO6a"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770442890; x=1801978890;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=pM9/YDTyKKI0sD4Dhh4VK/fPcuA6cFUij7u1q0xmBNM=;
  b=cJ3hDO6agHpneUapqL8hugQJPaHUtzp59ONG8RF9q12ZQz24SWYNEIH3
   k2m8B2h1JpmAsrSbCKEOZ/olCIQLjVJA7PtBflTisUJOCbBOWWN6iGIH/
   14ecX+SYBzMo/ZF6Z9m6Qz+61tAZ4WCH/zvss26798TfrBLS5JmALAPw1
   ksuaQw8NL34fdf7yECIeo7VqEyCZFmnAvhwRQs2SD3UineJvoT4LG99T1
   ahUvl+qbjqKrMWX+d4B1Q/f/6TUeKsJcmMF4bWX9PSI4MUKX8NaUKk9PF
   zmxNmD7wb4Q78o7tbTkQ/O/+9REQs0QK+81/sWfoLMuyzXb5r0lLCLkbi
   g==;
X-CSE-ConnectionGUID: xZlKJGM4RQeQ21kbnxZ3vQ==
X-CSE-MsgGUID: 1uSpSClhTZ6ltezGRNdtTg==
X-IronPort-AV: E=McAfee;i="6800,10657,11693"; a="81963076"
X-IronPort-AV: E=Sophos;i="6.21,277,1763452800"; 
   d="scan'208";a="81963076"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Feb 2026 21:41:30 -0800
X-CSE-ConnectionGUID: xgKTgBFESxew693gJUYllQ==
X-CSE-MsgGUID: NvLtUkYgQiOg8muxH6UkYA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,277,1763452800"; 
   d="scan'208";a="211090153"
Received: from mgerlach-mobl1.amr.corp.intel.com (HELO localhost) ([10.124.222.204])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Feb 2026 21:41:29 -0800
Date: Fri, 6 Feb 2026 21:41:29 -0800
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: syzbot ci <syzbot+ci66a37fb2e2f8de71@syzkaller.appspotmail.com>
Cc: isaku.yamahata@gmail.com, isaku.yamahata@intel.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, oliver.sang@intel.com,
	pbonzini@redhat.com, seanjc@google.com, yang.zhong@linux.intel.com,
	syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com,
	isaku.yamahata@linux.intel.com
Subject: Re: [syzbot ci] Re: KVM: VMX APIC timer virtualization support
Message-ID: <aYbQiS8k5K23bHE_@iyamahat-desk>
References: <cover.1770116050.git.isaku.yamahata@intel.com>
 <6982f952.050a0220.3b3015.0012.GAE@google.com>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <6982f952.050a0220.3b3015.0012.GAE@google.com>

On Tue, Feb 03, 2026 at 11:46:26PM -0800,
syzbot ci <syzbot+ci66a37fb2e2f8de71@syzkaller.appspotmail.com> wrote:
...
> Full report is available here:
> https://ci.syzbot.org/series/febd2a47-f17d-45ba-954d-44cd44564c81
> 
> ***
> 
> general protection fault in kvm_sync_apic_virt_timer

This case is caused because in-lapic is disabled.
I'll fix this gp fault with the next respin by adding in-kernel lapic check
to disable nested apic timer virtualization.
-- 
Isaku Yamahata <isaku.yamahata@intel.com>
