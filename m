Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E11DE304BB3
	for <syzbot@lists.linux.dev>; Tue, 18 Aug 2026 05:26:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787030801; cv=none; b=TVKeE7iL8nPRyTIfIPhH6/E3s52LRA/m1muJTmZnikASHQOA7jbvdmvzUQk5JuWyKo4O2xM7n/OG5KPwtWuERXNUyAfq5bBbXb3EKXD50PtgdmKB61FBTal6aHclbJEAERLUfktg5y9c1HIAujHjefb3kPMHVV/1s9q/LduXOKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787030801; c=relaxed/simple;
	bh=Xclq9wBLwl/TgKYkvOJJdhjk5DHy93yQ08wD4ooJmEU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=bDPozNmvkzDKnsA/JKPrirA6wYz6XdyAyZcUz6FOT8Job3YRdSNbShKHJ0DKrvNxs0YiRByDOvTEFC5fuRL8HRSSD7/F16ddHfMRf0kQB2N6PaBWNFf+up9vm0CpsZIlHvWqDLEpAEmfGbANlDC3KifpFHvmzs4GdWnRcHIZJqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=X69BN8Se; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="X69BN8Se"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1787030798; x=1818566798;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Xclq9wBLwl/TgKYkvOJJdhjk5DHy93yQ08wD4ooJmEU=;
  b=X69BN8SeppgO+kCzQPfpaclP85ziDuSErvzFFOK/oAik/CJ/txsSuNpc
   CT/tfV1ZTLcaCZlUV586nHQENYzN25zsPHq4fKi7H90dKXYcq71hkhdkK
   7gEhyGwQCGdV0FNIMxO6BtuNZ0HwrPlwoYeQb+qLXMOTMUKkzCic2obSA
   1ujBt4uhX3/oJnCju4G2AlAM7E+zZI00ekQo1SKu9nonHSc1TTVDpcPXk
   7WAcxKLrd6OGFphD07QYyI8fc6gnXaxaqdDydb7875ZW+Hccv9fyskaJd
   R9f5yCZPkl4Q7J61Wy3jAEbYIojUjrNTq8FKRHitGgICYOEYHKI6yJLJn
   Q==;
X-CSE-ConnectionGUID: EVssf+AETGyLGiv/iD3wwg==
X-CSE-MsgGUID: gT6VURTMRMWzR6QEsWTimA==
X-IronPort-AV: E=McAfee;i="6800,10657,11878"; a="110297164"
X-IronPort-AV: E=Sophos;i="6.25,230,1779174000"; 
   d="scan'208";a="110297164"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Aug 2026 22:26:38 -0700
X-CSE-ConnectionGUID: 68lhQoFBQwuAFwMiO+6BuA==
X-CSE-MsgGUID: k1d9nZLaQJyykhlIRA4XqQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,230,1779174000"; 
   d="scan'208";a="267086232"
Received: from qat-server-366.sh.intel.com ([10.239.92.77])
  by fmviesa004.fm.intel.com with ESMTP; 17 Aug 2026 22:26:33 -0700
From: Jie Wang <jie.wang@intel.com>
To: syzbot@kernel.org
Cc: syzbot@lists.linux.dev,
	syzkaller-upstream-moderation@googlegroups.com,
	Jie Wang <jie.wang@intel.com>
Subject: Re: [PATCH RFC] usb: atm: cxacru: fix NULL pointer dereference on uninitialized atm_dev
Date: Tue, 18 Aug 2026 13:12:47 +0000
Message-Id: <20260818131247.3844855-1-jie.wang@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <a2325770-3137-4cc3-8a69-c9991fc9042c@mail.kernel.org>
References: <a2325770-3137-4cc3-8a69-c9991fc9042c@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The cxacru_poll_status() hunk guards an unreachable state:
cxacru_atm_start() only fails on the MAC read, which is before polling
starts, so usbatm_atm_init() never reaches its atm_dev = NULL path with
poll_work pending, and cxacru_unbind() already cancels the work via
cancel_delayed_work_sync().
