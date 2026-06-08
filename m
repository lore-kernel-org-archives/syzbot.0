Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC25433F8D6;
	Mon,  8 Jun 2026 19:36:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780947377; cv=none; b=a/WCrFnpfDEiUvQZIdMBdq1FDeNfZX9PJCcVT30Uwy74C+XYwdMFfpqf0nGdkJwgxmTtjILUKPzPbvJ7qkjZVZ00cvNYgZ8+rxaQBaZcVDP0N7tZrtqTVAu5d6d+xl4DkAnLHIxx8/0VK+Qav5cltvCPIP6LSrpRR2/oKmuiHwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780947377; c=relaxed/simple;
	bh=F5VSOkaDBKFMv3plU/tPY24C9FeI45SVsYJDgF9K8rY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=H146H4apUcs66PTjXwAuKUTj9nOc+Ba9MZWFNIaYSc+sZ834N/VXGL4o+MuX8vLm08ONiBhcxBRiZQG+CCfbTii6Fn/xUfw3mMHip8P92Dv2ffHB67XQtlv5UgrmY5gkRs2SWTfdlaC4mE+yHl50mW3tc3YODXbSaavvnUUk56k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=h6LGTaKH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="h6LGTaKH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B62B11F00893;
	Mon,  8 Jun 2026 19:36:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780947376;
	bh=h4qlBC+6dI5jRssc1LiNucL2AmkYGVRaw6E1se/+S3w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h6LGTaKHNNpraoYU2c11+CMvtsiWw9qFP+UHJmkQAyjXSAAOS08rYYyuv6WggghYr
	 nzuaRk1kZuGA0DOdR2sT6sBvIfmZSHyRZQrhkg3KBAMxNKNiQGtEKJPDgApyVxVwXW
	 xFXJwqvcgNwQ292KvqZq1HfnODI1rTtosAezcY/fBgzf8u+JJ68l18p4MIZgwzb373
	 OEakWFb2HqjDTQVsO6uCViW/N5srgfR8d5ztzkrsyjfPGi/x1eQ5zpRkNoPbRev1U4
	 JwkFEQ13YtK1sEll/sccSUvV+NC1uLRKTTBb/g4OEHlg1ZYj8pOJ+syQW/B2fC/skd
	 c2JffXwVMdsXw==
From: Danilo Krummrich <dakr@kernel.org>
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-bugs@googlegroups.com,
	Danilo Krummrich <dakr@kernel.org>,
	driver-core@lists.linux.dev,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Luis Chamberlain <mcgrof@kernel.org>,
	"Rafael J . Wysocki" <rafael@kernel.org>,
	Russ Weight <russ.weight@linux.dev>,
	linux-kernel@vger.kernel.org,
	syzbot@lists.linux.dev
Subject: Re: [PATCH v2] firmware_loader: Fix recursive lock in device_cache_fw_images()
Date: Mon,  8 Jun 2026 21:35:59 +0200
Message-ID: <20260608193559.779934-1-dakr@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <48b092a5-f49d-48a4-95f4-f65bebfc6bc3@mail.kernel.org>
References: <48b092a5-f49d-48a4-95f4-f65bebfc6bc3@mail.kernel.org>
X-Patch-Reply: applied
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On Fri, 29 May 2026 15:09:06 +0000 (UTC), syzbot wrote:
> [PATCH v2] firmware_loader: Fix recursive lock in device_cache_fw_images()

Applied, thanks!

  Branch: driver-core-testing
  Tree:   git://git.kernel.org/pub/scm/linux/kernel/git/driver-core/driver-core.git

[1/1] firmware_loader: Fix recursive lock in device_cache_fw_images()
      commit: d3ec78f8f8d4

The patch will appear in the next linux-next integration (typically within 24
hours on weekdays).

The patch is in the driver-core-testing branch and will be promoted to
driver-core-next after validation.
