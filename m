Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 154C23F4DE9
	for <syzbot@lists.linux.dev>; Thu,  6 Aug 2026 23:30:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=100.103.45.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786059027; cv=pass; b=dKxLe9kWhBSFu+VgpazRG/6Cd0MZ9YFw2yaMaOcd6oPQoi0kMYay/gfA2AiasuzDGVScaE/tU5j+QdDMctemSbGn/UuaF7eFHCC95gKMvY18EPY8s3yX6eJIekT8G0qYbTujUrP7NjolZWL7OeYnScsOOAUigSEjtvF75+KFJH4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786059027; c=relaxed/simple;
	bh=LLPIVZLkcDBEXmcY+m6qHFAz6hVv8iBq31NdOIuv73Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qp/lB9uYs6ZKhXsD4UBAb+QIxdA9jehJ73B6wES6MDf4iNcCrDRSHxMB7c2v1drhrPizsC3t6Ywv5Y+oCMokIOxD073LBbyHenutcI/BM8LgH4Y1NqANmZBz3KU3JdZtMdFsgqPkAqFeRK5g2BIlZ8FRkTUcy+4+X24nJb2nK+Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=sina.com header.i=@sina.com header.b=FegA9rv3; arc=pass smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=sina.com header.i=@sina.com header.b="FegA9rv3"
Received: by smtp.kernel.org (Postfix)
	id EAA0B1F00A3A; Thu,  6 Aug 2026 23:30:25 +0000 (UTC)
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=202.108.3.165
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1786059025;
	b=tYTtouaBCP6C5WnklBMezC3/lUJ/0Mswbq2X7JX22lEZrH1Pl8kWbqNy/nJ5csYf7+vL
	 fTVmqI8d+w+qHOtt0vD3ioHDz9TzW4t7Gw3RM1xzD14EGTOL8ITeVLy9cgy0blYm3xgby
	 sae8twG+TR2FiENJuSKPJycxfsKZledvVoPZTeMzyKZBuLBLoN6aMrEWmzDbCxSK5A7W2
	 uu6adbFX1rvHi7nbZh1abuClAq3n1GC+uSqrPSwi1fPVyM6G5ROSUAjFyl6AMgOou/915
	 Swh9icpkJ2BDIW0dh5Gs42PnEs3SasbxSrycBeXQXISM3zWsh4j4Wnl5A9m2FTU+V2g==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1786059025;
	h=DMARC-Filter:DKIM-Signature:X-SMAIL-HELO:Received:X-Sender:X-Auth-ID:
	 X-SMAIL-MID:X-SMAIL-UIID:From:To:Cc:Subject:Date:Message-ID:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=LLPIVZLkcDBEXmcY+m6qHFAz6hVv8iBq31NdOIuv73Q=;
	b=E58E/zL76qc4D43AqNzPo1KK7m106BAHZcB8Fzwqq1gxOKeqQzXr0GXR7OSfYYQt4tDC
	 tdeS4UNMX7CAhFWaLFEPttUrSPMbzPUJv4gRZ0R8YVLGWoe97bYuHZUgjj/PvteX9OqAf
	 2YkKtXQEEPnsCxlLgCJI7DR5eVPSqOqqOg4LvC9dKUaVYfVO1RJXRWtW0vJBYRp+DPW5v
	 +YVIeaJ2oTCS6pAGZ3Tm78+AvT+cAWkNMr7wzfyEX9aIJv6yk69j5zTiqUMVHrMjL92zc
	 +2gLOQC+AfX5DADCbsZtqOzSAudoS7ByZIU3r5qLCnNUbxinz5g80v0voOQ+rAfLR2g==
ARC-Authentication-Results: i=1; smtp.kernel.org; dkim=pass header.d=sina.com header.i=@sina.com header.a=rsa-sha256 header.s=201208 header.b=FegA9rv3;
	dmarc=pass header.from=sina.com;
	spf=pass smtp.mailfrom=sina.com;
	arc=none smtp.remote-ip=202.108.3.165
Received: from mail3-165.sinamail.sina.com.cn (mail3-165.sinamail.sina.com.cn [202.108.3.165])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 56BC71F000E9
	for <syzbot@kernel.org>; Thu,  6 Aug 2026 23:30:22 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=sina.com header.i=@sina.com header.a=rsa-sha256 header.s=201208 header.b=FegA9rv3
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.kernel.org 56BC71F000E9
Authentication-Results: smtp.kernel.org; dmarc=pass (p=none dis=none) header.from=sina.com
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=sina.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sina.com; s=201208; t=1786059023;
	bh=LLPIVZLkcDBEXmcY+m6qHFAz6hVv8iBq31NdOIuv73Q=;
	h=From:Subject:Date:Message-ID;
	b=FegA9rv3OfKYr1k9KdzJ4x63BfxM7dRqCjyrX+W/YyF9ZnkBP9bISMHshucbOmw3b
	 Fl9XuzPQSbZebZ1+4npEEYAyzx5azSYtG4p2uzWLIYFPZ+87SKAJcO+9tCihq7UhAf
	 gCWSXBlIb0Hy0N7cr4lTu6I0TTdsQwzgTPnFdyIw=
X-SMAIL-HELO: localhost.localdomain
Received: from unknown (HELO localhost.localdomain)([221.216.154.155])
	by sina.com (10.54.253.33) with ESMTP
	id 6A75190300000BF6; Thu, 7 Aug 2026 07:30:14 +0800 (CST)
X-Sender: hdanton@sina.com
X-Auth-ID: hdanton@sina.com
Authentication-Results: sina.com;
	 spf=none smtp.mailfrom=hdanton@sina.com;
	 dkim=none header.i=none;
	 dmarc=none action=none header.from=hdanton@sina.com
X-SMAIL-MID: 5296506685417
X-SMAIL-UIID: DB663BE915C8410096AD3F36CA1047D9-20260807-073014-1
From: Hillf Danton <hdanton@sina.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Slawomir Stepien <sst@poczta.fm>,
	Aleksandr Nogikh <nogikh@google.com>,
	syzbot <syzbot@kernel.org>,
	syzkaller-bugs@googlegroups.com,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	syzbot@lists.linux.dev,
	Krystian Kaniewski <krystianmkaniewski@gmail.com>
Subject: Re: sysbot AI patches and wireless
Date: Fri,  7 Aug 2026 07:30:00 +0800
Message-ID: <20260806233001.997-1-hdanton@sina.com>
In-Reply-To: <8a0020fb5318ed645b0331d3790a75f83c0ee443.camel@sipsolutions.net>
References: 
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Thu, 06 Aug 2026 16:49:45 +0200 Johannes Berg wrote:
>
> It's definitely part of the job to train new contributors, and it's
> actually very rewarding to see someone grow from first time contributor.
> Sadly, now there's basically no "first-contact signal" that says "I care
> about this more than landing this one patch". :-/ Getting a well-formed
> (and well-argued) patch used to be worth something, now it's basically not.
>
Nope, who cares (LPC/Unix)?
Is Linux helping make the earth a better place (for who/all)?
