Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591527;
	b=g4avk7GtMf46Z59YV7xWrfNmoN9cybYrh9NVEBAs8ujyXdBXd/1x/yhd/bOaZDRa2IHR
	 4vHGL4FJVOmAX5v/SoBAQcDaf6hHNxBw5E4p3PJx+wVvBqQnzhgYBUIaTmcXPhsonpbPx
	 wG1rmL/kNOh2HyYyJFcRlutXLedlFiOY1BOwu7l6HWEbcgnJ9Jn0Ta3C1z8Z3JSri6kox
	 /A7KgVvdx1foWRN9izUtjNVbHoI9XYKF5PC0mHcAo2TWus034qTRCmjMTRcFKIdgRS+Tt
	 OBFyDau5noSkmZbclsCe7fF49afLwn0WAnPwvWHyCnfV6/g1chwhSHCstnRohIWlcPA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591527;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Type:Content-Transfer-Encoding;
	bh=Wb1OXX+yliqJmjn2ESkgHuebZuic8EqdBrdlJXh89ms=;
	b=xp3Zm6JG9K3mThQZCa2gWJgFzEn8vrByc51CX/0Vi3L8pqRX2ts+Rdhuld6d4knwF9K+
	 4nW7p/wZbEzUG4V6Qhz4Mq0Bn1Sr0/ZsRU0TQoijUsRBERBAadhmCd0XnSiCrzzwnVdmo
	 dK8F+Y1gVamkHHKZNYsAODh8w4suuI6Ksow9TGhfD43haCdpIeOuvVU44ZTju6zjisIcr
	 C8+9EVp6EI9cgSdNQFehawpH0oj5H14dOvSwx+t7MVaB3c+uKgsekpce/AATeS5wOXGSz
	 6N7oI6dvDqCbIPvRs/WSfZwVAT/tVh8Bo7dTPw1uPOFRJlQEqL16xN9GWkgN5GX/kgw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=ZaxXc6dg;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 74447606D4B8
	for <syzbot@lists.linux.dev>; Fri, 13 Nov 2026 17:38:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 74447606D4B8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=ZaxXc6dg
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D082E143D;
	Fri, 13 Nov 2026 09:38:43 -0800 (PST)
Received: from gaia.lan (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E45503F8C6;
	Fri, 13 Nov 2026 09:38:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794591526; bh=p3PS1SVNPQdF2HUhwZLzdl6Jo2D89+v/wFidAgUFVFs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZaxXc6dgXkbZA2sirb0dK5VwB39J/16ShYuz27ReoHwmF9e4cB0MGPPYD2JomEZgb
	 QwIHeCl24QntfFH7fZNvp8tUf6tZ+srD+EdxYJpQuDZt6sIOQ7m0VihlmwQXCHShcO
	 rMccEIa1A551K79aXv8Q7YUe4erVYGZra3eVoBSs=
From: Catalin Marinas <catalin.marinas@arm.com>
To: syzkaller-bugs@googlegroups.com,
	Uladzislau Zhauniarovich <uladzislau.zhauniarovich@gmail.com>,
	linux-arm-kernel@lists.infradead.org,
	Will Deacon <will@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	syzbot <syzbot@kernel.org>
Cc: ada.coupriediaz@arm.com,
	linux-kernel@vger.kernel.org,
	mark.rutland@arm.com,
	ruanjinjie@huawei.com,
	syzbot@lists.linux.dev,
	vladimir.murzin@arm.com
Subject: Re: [PATCH] arm64: suspend: Only track cpuidle context for idle tasks
Date: Fri, 13 Nov 2026 17:38:41 +0000
Message-ID: <179459121446.3758917.12081688129224269638.b4-ty@b4>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <c49d0138-9e6d-40d4-b46c-518240685bf1@mail.kernel.org>
References: <c49d0138-9e6d-40d4-b46c-518240685bf1@mail.kernel.org>
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Post: <mailto:syzbot@lists.linux.dev>
List-Help: <mailto:syzbot+help@lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
List-Owner: <mailto:syzbot+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Thu, 05 Nov 2026 20:19:45 +0000, syzbot wrote:
> Commit 19235e472798 ("cpuidle, arm64: Fix the ARM64 cpuidle logic") moved
> the calls to ct_cpuidle_enter() and ct_cpuidle_exit() into cpu_suspend() so
> that arm64 cpuidle could keep RCU watching longer and manage context
> tracking internally. However, cpu_suspend() is called not only by cpuidle
> via psci_cpu_suspend_enter() (which runs in the context of the idle task),
> but also during system suspend via psci_system_suspend_enter() (which runs
> in the context of the task initiating suspend, such as a process writing to
> /sys/power/state).
> 
> [...]

After some pondering, I decided to keep Uladzislau as author. The RFC
posted by syzbot does say that if you reply with "#syz upstream", you
adopted the patch and your sign-off will be added.

Applied to arm64 (for-next/fixes), thanks!

[1/1] arm64: suspend: Only track cpuidle context for idle tasks
      https://git.kernel.org/arm64/c/ad3fc05c7e65
