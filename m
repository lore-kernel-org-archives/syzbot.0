Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793988994;
	b=dJSBWVE2+cxIEMhlhSZ4PaIthEHl6Sp+3MPPEBxEjsojiK/BbVAhAFCCd/BS17UxXy0k
	 kImiBcc6hj/6vya0bmPLtxOJYIQdKcS1QucbbAzGlzdYoVKHdBj/aX/Or1HGyCQRJBiEu
	 HWDcuZKusj9lJMophhGGsaM1OLJaxJqIxQU73wNSZhlyTKaibgZURIsLzWt7DIcha6/6B
	 sbtVgfXI9wFg6w3BUmuiECw6bhCqpMmegV45mvNkfheGs86W44UutCYSSbXAlGQvwNwDC
	 PeGRw+QLp+8b0ffXE1tleR+9Bua8Xw8+VYit2/AzXZMDTARj22FY0nC8bbK1JP1awnQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793988994;
	h=Received:Delivered-To:Received:DMARC-Filter:Received:Received:
	 DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=np0rBc7IjhEQu4p09VCEWlO9o9RBufgirnMcmCHN/No=;
	b=5aXbEr1PWnicPZsyjEsOo3ZaVndNheD3ks6o8XicFbIOE//fiEWI0Bo3JyTOSDkxbJVj
	 UD301zCA1HCXrNaqos81lMxJAvR78Qx8zMpjkE/N9lfYyGR8Pwlxd6XHeRtuT7BFOuAi6
	 CQHjnMmUMxuNgnjugKoQnpu5tRZnwVIR5FmmmmkVStEWh0FN4QhCEzTW2r6KpBGJX8i/I
	 m3kUj6Ll5Ff7qB97x5AUhVW/IvR9W3mOGwsqCYTCNRXc+HP+tN2OJbDkpKh/q16DkqWAy
	 EL0DwVie48Aq3m2WRnAbllvn/Q9/HTz0AJpEt6NhxQYqgcApnFXI/HghwaXVGOmHXsQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b="d95EKw/c";
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D49A606A337
	for <syzbot@lists.linux.dev>; Fri,  6 Nov 2026 18:16:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=d95EKw/c
Received: by smtp.kernel.org (Postfix)
	id 127421F0089F; Fri,  6 Nov 2026 18:16:34 +0000 (UTC)
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1793988994;
	b=gbN4ygRuYbIx6ysdPQPP8pUNtDKx7r3VU0DBcJcPisNqwfW7/g4L4Rq0o7umvYm+357y
	 Ceu9lkHJ5mM9JR9VjvE3TtZNbSjOAyHa8AG/UDQXt2YPO5WwDCuRCIyEB2RjY+8sN0iC9
	 yd37PcLEfsKXNzDAUXo5plGf/i+Z8tM3971EQYFHM5Bv/tg371Nsn/ZogmZfVjCJ9Rtat
	 LixUGhi8NnA6iJBsSb0BygAAFvyUDPapnx0ycDTAr0OsY5FfMZZxoWzKm8Q430PsBKXOk
	 H80yqHBpxIYHzhx1R3xPcE+zIXORIiEDBLQMt1GMvTSDCAgaCj8Jq7/qqhoGvqZVl3g==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1793988994;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=np0rBc7IjhEQu4p09VCEWlO9o9RBufgirnMcmCHN/No=;
	b=qxFBSbWqNm9vwZW4MEAI0Xwc/eCKx4Dugg84thAqHw3dZW/+TPLI3w66AoG2nOvgPq96
	 4rbRhq6NS3b3wtYdeSlRR6vP1XEJ1e+Sumz8yvF+c2MtZZzAIV64vaeYIoLPf7w3P5VBw
	 LjjEF3l6TmW6pNs6LtU5PWYl06L2tiuB1ixAdwqJVG2K72Lfyljs/AudqdfUWrPczhRK/
	 jNE5WzSmZi2IZzcQzwZGplF0CVCGV065j9hCWQmkZcHXYVsbL/j8mQPU/eEMEWhkLZw7y
	 up8p/r5Cf1fQagEO7pugiX5XFQYJpJQbC9zDUOvH7VUk21+ev0LdG6W3SxuLD2mCQUw==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b="d95EKw/c";
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.kernel.org (Postfix) with ESMTP id 55B8F1F008A1;
	Fri,  6 Nov 2026 18:16:33 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=d95EKw/c
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.kernel.org 55B8F1F008A1
Authentication-Results: smtp.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4BE0E1682;
	Fri,  6 Nov 2026 10:16:29 -0800 (PST)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 71F2B3F673;
	Fri,  6 Nov 2026 10:16:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793988992; bh=E0Ux+rJXBJFRHQCF+PiknD1DijpMrELS0VMmKTqZ/Rs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=d95EKw/c2iQCv93H00PxABDJ9kn1MVxtlxP3CD2v2pOefm8L8SnZROUPuT75jGECz
	 FiWX+xTnOiS0ChTukXnbcxOAwocaOMf2G6SdagNl8JqWw2/kjzCGqKv5pEh+lv5McW
	 HPQvygA8GlxZMRkHs5bw7kwl+PDlEUmoZ7rfAi8A=
Date: Fri, 6 Nov 2026 18:16:27 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-bugs@googlegroups.com,
	Uladzislau Zhauniarovich <uladzislau.zhauniarovich@gmail.com>,
	linux-arm-kernel@lists.infradead.org, Will Deacon <will@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>, ada.coupriediaz@arm.com,
	linux-kernel@vger.kernel.org, mark.rutland@arm.com,
	ruanjinjie@huawei.com, syzbot@lists.linux.dev,
	vladimir.murzin@arm.com
Subject: Re: [PATCH] arm64: suspend: Only track cpuidle context for idle tasks
Message-ID: <au4Ze0u6L91ve4u7@arm.com>
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
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c49d0138-9e6d-40d4-b46c-518240685bf1@mail.kernel.org>

On Thu, Nov 05, 2026 at 08:19:45PM +0000, syzbot wrote:
> From: Uladzislau Zhauniarovich <uladzislau.zhauniarovich@gmail.com>
> 
> Commit 19235e472798 ("cpuidle, arm64: Fix the ARM64 cpuidle logic") moved
> the calls to ct_cpuidle_enter() and ct_cpuidle_exit() into cpu_suspend() so
> that arm64 cpuidle could keep RCU watching longer and manage context
> tracking internally. However, cpu_suspend() is called not only by cpuidle
> via psci_cpu_suspend_enter() (which runs in the context of the idle task),
> but also during system suspend via psci_system_suspend_enter() (which runs
> in the context of the task initiating suspend, such as a process writing to
> /sys/power/state).
> 
> When entering system suspend, current is a non-idle task. Calling
> ct_cpuidle_enter() invokes ct_kernel_exit() from kernel space (!user) on a
> non-idle task. With CONFIG_RCU_EQS_DEBUG enabled, this violates context
> tracking invariants and triggers a warning:
> 
> WARNING: kernel/context_tracking.c:120 at ct_kernel_exit+0x1b4/0x1f4
> kernel/context_tracking.c:118
> Call trace:
>  ct_kernel_exit+0x1b4/0x1f4 kernel/context_tracking.c:118
>  ct_idle_enter+0x20/0x34 kernel/context_tracking.c:299
>  ct_cpuidle_enter include/linux/cpuidle.h:134 [inline]
>  cpu_suspend+0x264/0x474 arch/arm64/kernel/suspend.c:136
>  psci_system_suspend_enter+0x4c/0x80 drivers/firmware/psci/psci.c:544
>  suspend_enter kernel/power/suspend.c:468 [inline]
>  suspend_devices_and_enter+0x88c/0xd0c kernel/power/suspend.c:533
>  enter_state kernel/power/suspend.c:618 [inline]
>  pm_suspend+0x498/0x698 kernel/power/suspend.c:644
>  state_store+0x14c/0x1fc kernel/power/main.c:819
>  kobj_attr_store+0x6c/0x90 lib/kobject.c:842
>  sysfs_kf_write+0xe0/0x108 fs/sysfs/file.c:145
>  kernfs_fop_write_iter+0x260/0x3b8 fs/kernfs/file.c:345
>  vfs_write+0x51c/0xa0c fs/read_write.c:687
>  ksys_write+0x12c/0x228 fs/read_write.c:739
> 
> A corresponding warning is subsequently triggered in ct_kernel_enter() via
> ct_cpuidle_exit() upon resume.
> 
> Fix this by checking is_idle_task(current) in cpu_suspend() and only
> invoking ct_cpuidle_enter() and ct_cpuidle_exit() when executing in the
> context of an idle task.
> 
> Fixes: 19235e472798 ("cpuidle, arm64: Fix the ARM64 cpuidle logic")
> Assisted-by: Gemini:gemini-3.8-flash Gemini:gemini-3.1-pro-preview syzbot
> Reported-by: syzbot+79883955da3a62652a80@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=79883955da3a62652a80
> Link: https://syzkaller.appspot.com/ai_job?id=5359e16f-013b-4850-9cbc-ddfb3bac95e5
> Signed-off-by: Uladzislau Zhauniarovich <uladzislau.zhauniarovich@gmail.com>

The patch looks fine to me but the authorship is confusing. It was sent
by a bot, also generated by a bot. Uladzislau tested the earlier RFC
(thanks!) and syzbot decided to make him author while dropping the
Tested-by. The original tested-by:

https://lore.kernel.org/all/3e92ccb0-2952-4317-af4c-45457c15efae@gmail.com/

I don't think #syz upstream should automatically translate to
Signed-off-by.

What do we even do with such bot-generated fixes (which may be correct,
so can't be entirely ignored)?

-- 
Catalin
