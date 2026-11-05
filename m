Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.44
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793909639;
	b=sH2hxgkU1fsl7Z2kU2DF/9ngUWSTISPzfvJ4n6f/tztwbTqacxHN5cikXl75fgPZxwN/
	 8Hgt9fGNG7xfm/RbXs9APJee1aVxIDMyclfBwY2uJeX0Pqui7+9JP4doDsFQB3lxsiRcF
	 E9djcJZgGJHxLH1dJl3x7LFAkNCE5gO3ZURqyUha7nXZLgQ6FYHjHQW+d2AkMPRo7OywH
	 9kBsEbNlSkOlpyfSAaLIn/HfTujp4lhIlgNWkQ667S+OeWbytDumMUU+PTeRO3sbcWjlx
	 H2udkBCw7pNQ6QF5Balv6K/BfI9Ulfqo+a57V6FE7U0+GyWToeuYNj3aCAWltfWSHhA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793909639;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=m9D8HPdRH3wBOu/HW6Hvrf2w7eScenCvY2iLT/64eTM=;
	b=a453156ymAwvZqlw29Rzb3Zui1z5xgRQkW0WnKguzBST1taaJhB8N8/NPBVWqHHX7+QQ
	 s+F86A/b5CVJW0xMJHIUf7HXXEsfJHfsFQUllLeArHAehR7clXlF9mlY42PiQ0ADXJdsB
	 /T9+GCtUyR3fr4eShqP1aOd+M+4+5c7yTwwEAF2VtGiYyMKSV/0hFpZvLFPoasKMs+MSN
	 KyQKazsEXMGPNjXuQMesjrceX7xXA/gOASbIHJOwtsW9F4PpOnY4AHyAcgNc/Qc4Av8+u
	 59InuUvWec0hHOMZrsdlylib/EgCfq8rDqsB75QOGb4TgL85QGr6x3LGITlYZMPQ8OQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=jzOrfWYv;
	arc=none smtp.remote-ip=209.85.208.44
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94057606A31B
	for <syzbot@lists.linux.dev>; Thu,  5 Nov 2026 20:13:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 94057606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=jzOrfWYv
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-6b561b60b78so1537921a12.1
        for <syzbot@lists.linux.dev>; Thu, 05 Nov 2026 12:13:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793909637; x=1794514437; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=m9D8HPdRH3wBOu/HW6Hvrf2w7eScenCvY2iLT/64eTM=;
        b=jzOrfWYvSQIWz0g6PHruCka1plnvP0KHGWkl3lexEgV29e3NQs92KeiDsqxYhSuO0b
         ej7lRWHYFW7rIwJOfFyIJuexmylOG2OiR1dO7klGMii6811xxm1cKz6G8cnubhuI7HKf
         aX814ttYPlujcHXIAPlVnGG6KlBPmDK989fEbLCdTbL7F7W7JIZeLaA69gprLxk0LPh2
         ifEAv0WJoN2aFO2lRYFh+UvBGeWUQeM8MhRI6HTiG1mw4gUQL3GWGme/Le0+ArZBwav3
         uNZiqdK+N4u/jC2jTiv7BdqiibcI87TACX9Qn9ZFcbP4VHzClfyp7Y5QmdN9vT68w5Bi
         snDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793909637; x=1794514437;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=m9D8HPdRH3wBOu/HW6Hvrf2w7eScenCvY2iLT/64eTM=;
        b=wqZsYozQJHqeamtCEmJP9N0gUi2QuVJEtRiTST9wFvMy9TDzEhSm6YvjC0VqbYhxBc
         /kcXW9lDszjCIHmlsCRpPTc8KtNAcYncGMuqxZ7CxyOIXeGC4UR/yeg0BB3UDUQ+Segt
         g0M2etbAG2BPtR2VZVLuj2GN+VxI2g+emIl4w1zTsxUkc8LUrg2WMW0RfyxecBF7ikJh
         mSd4C+UUCrEV/QShO4NDec8yOdEUkngDtrWZu4c3ysi5Rdn4ZIkR3mdmQt7EaEULA8cy
         4a5UzBVHFKvO4UbbHP8uDIHsURQ23wYyxYkGMWVzFEWdN8kgNeZ600oGo4Iu/gTQ8Mkv
         71JQ==
X-Gm-Message-State: APuU4Z/Sz5GHT5tt5GlcfnvOFqpa5Jg/Zq/qKAfJyrWR+2YHmj1L6mJl
	x0VAtmKKTt8DJhHH6w0Etq7jS1mpqnNYrtz2u9e63AS/on5Y86MCU95j
X-Gm-Gg: AYBFou0nWPUTVGLKzfWBaNg4lmR7lYj/Srcc2Q8cMIUDUoz37vJUhyq9u2X5poVWjb9
	ZT/J8Fu6xEc3asuiasnTwTkauRirA7aRhNyvlQDGYtCBGIS9ndRKGWayO31wsrucd+wRGXPENl4
	vLYCUM5evURPsCdb6HGL66Z1YcdaGgWvopcm7R5+RTbpx2X6ZIbOgG8N3+G+F0cHhBeRknNTiJy
	YUfaWBBEZe5eY/u4iwrBx4aikp1xeDlTqStJyFCrIIp0XqLWpvLBZeghrl8ObsxVtubiDrSl+Jr
	6wPXA7E8WEjbhpHblIePUwEDyxtEVKhd5D+CSdChS0ADCYsCLwSfIiKG2//C4ZpIvdwyxxeeD83
	EgpcIzdrEBFLBLhNYCFfUAilsi249Ox7XmHi/+3/7+TN1oGOU05I94Fl/rUEFNpo0/m84q8a9SH
	cUsOEJL8NXcX2QYvdKsHBLXSM7NfWASmHmDkPaFwZlX4VvEeqrYWaITKoGMrHxbqRYhnKGCGPBW
	gUJHfqC8aRnpLcWbGGx9/0XQA85LXwFqyarB9qLZIhqreke3G9hxyxkfUCeoOnJ0cqrQBoSNDgu
	ccDD/EMQaMbcIZWOFXZCBgwxF7VlGzrPNIDAG7igJyH2FNvc2E1hmztPkZNMNqUgTJDjafsnwJ9
	4XA==
X-Received: by 2002:a17:907:3906:b0:c2a:4847:231b with SMTP id a640c23a62f3a-c4d3557096amr38617666b.24.1793909636820;
        Thu, 05 Nov 2026 12:13:56 -0800 (PST)
Received: from [192.168.0.50] (93-159-22-87.cgnat.inetia.pl. [93.159.22.87])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c4d356ea58esm14035366b.81.2026.11.05.12.13.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Nov 2026 12:13:56 -0800 (PST)
Message-ID: <3e92ccb0-2952-4317-af4c-45457c15efae@gmail.com>
Date: Thu, 5 Nov 2026 21:13:55 +0100
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Post: <mailto:syzbot@lists.linux.dev>
List-Help: <mailto:syzbot+help@lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
List-Owner: <mailto:syzbot+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC] arm64: suspend: Only track cpuidle context for idle
 tasks
To: syzbot <syzbot@kernel.org>, syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
References: <c2fd8aff-c1ea-4bfc-a24d-79a58f58b6aa@mail.kernel.org>
Content-Language: en-US
From: Uladzislau Zhauniarovich <uladzislau.zhauniarovich@gmail.com>
In-Reply-To: <c2fd8aff-c1ea-4bfc-a24d-79a58f58b6aa@mail.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


The patch is correct as it is. I reproduced the bug and tested the fix
in QEMU (virt,secure=on, TF-A as EL3 firmware, so PSCI SYSTEM_SUSPEND
is available). The kernel was arm64 defconfig plus CONFIG_RCU_EQS_DEBUG
and CONFIG_PROVE_LOCKING. The test runs
"echo mem > /sys/power/state" with mem_sleep=deep:
  - without the patch, 3/3 runs hit both warnings
    (ct_kernel_exit and ct_kernel_enter, called from cpu_suspend()
    <- psci_system_suspend_enter());
  - with the patch, 3/3 runs complete suspend and resume with no
    warnings and no other splats.

Tested-by: Uladzislau Zhauniarovich <uladzislau.zhauniarovich@gmail.com>

#syz upstream


On 29/09/2026 23:44, syzbot wrote:
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
> To: "Catalin Marinas" <catalin.marinas@arm.com>
> To: <linux-arm-kernel@lists.infradead.org>
> To: "Will Deacon" <will@kernel.org>
> To: "Peter Zijlstra" <peterz@infradead.org>
> Cc: "Ada Couprie Diaz" <ada.coupriediaz@arm.com>
> Cc: <linux-kernel@vger.kernel.org>
> Cc: "Mark Rutland" <mark.rutland@arm.com>
> Cc: "Jinjie Ruan" <ruanjinjie@huawei.com>
> Cc: "Vladimir Murzin" <vladimir.murzin@arm.com>
> 
> ---
> diff --git a/arch/arm64/kernel/suspend.c b/arch/arm64/kernel/suspend.c
> index c41724a40..cde0b8c19 100644
> --- a/arch/arm64/kernel/suspend.c
> +++ b/arch/arm64/kernel/suspend.c
> @@ -5,6 +5,7 @@
>  #include <linux/uaccess.h>
>  #include <linux/pgtable.h>
>  #include <linux/cpuidle.h>
> +#include <linux/sched.h>
>  #include <asm/alternative.h>
>  #include <asm/cacheflush.h>
>  #include <asm/cpufeature.h>
> @@ -99,6 +100,7 @@ int cpu_suspend(unsigned long arg, int (*fn)(unsigned long))
>  	int ret = 0;
>  	unsigned long flags;
>  	struct sleep_stack_data state;
> +	bool idle = is_idle_task(current);
>  
>  	/*
>  	 * Some portions of CPU state (e.g. PSTATE.{PAN,DIT}) are initialized
> @@ -133,7 +135,8 @@ int cpu_suspend(unsigned long arg, int (*fn)(unsigned long))
>  	 */
>  	pause_graph_tracing();
>  
> -	ct_cpuidle_enter();
> +	if (idle)
> +		ct_cpuidle_enter();
>  
>  	if (__cpu_suspend_enter(&state)) {
>  		/* Call the suspend finisher */
> @@ -149,9 +152,11 @@ int cpu_suspend(unsigned long arg, int (*fn)(unsigned long))
>  		if (!ret)
>  			ret = -EOPNOTSUPP;
>  
> -		ct_cpuidle_exit();
> +		if (idle)
> +			ct_cpuidle_exit();
>  	} else {
> -		ct_cpuidle_exit();
> +		if (idle)
> +			ct_cpuidle_exit();
>  		__cpu_suspend_exit();
>  	}
>  
> 
> 
> base-commit: 72d3fcf802c45d00b300f25b848a93c3a2bd7c7e

