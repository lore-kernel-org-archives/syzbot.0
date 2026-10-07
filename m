Received: from mail-ot1-f51.google.com (mail-ot1-f51.google.com [209.85.210.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A79912C534
	for <syzbot@lists.linux.dev>; Wed,  7 Oct 2026 08:37:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791362232; cv=pass; b=qAmYMW87wd9IeNkrIwIIhOny/eol9uvBZvKNxBlp4jq8UizodvH6+Cv9D0IhZ9+MsNvsrl3hrVIQgwjOrjpdtW4N4a7/Ax6KHqEjkaALFj1WlqzJisIze35oRp2gGl5RQaxNFAL5pEZk3mxXiy93cuBHE2waGwP1kl7lgMKKk84=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791362232; c=relaxed/simple;
	bh=V6DhUSrl7lPeMd8LbUhZhNmEdZbT8m8lmjZbffYGM9E=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nE9cvTux9bkOCLZSvvhWZ8zuLqBolgOBiZTQ7DQgfvwpJlC+JefgRtlocV1jp1KU76MZggGudLtTyc4iyCVdfF2Qj3MX4CSI7wLkSmcGcYH2fu3X3YClPEOSsFoCTd2oxlcY9/kV3PW4xiL6pgq2Wa8r2p33J+XKsC9WoZxpQqo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fIcBKMZ+; arc=pass smtp.client-ip=209.85.210.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fIcBKMZ+"
Received: by mail-ot1-f51.google.com with SMTP id 46e09a7af769-825b40f8a26so726331a34.1
        for <syzbot@lists.linux.dev>; Wed, 07 Oct 2026 01:37:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791362228; cv=none;
        d=google.com; s=arc-20260327;
        b=K8/8G5zgUYYEBHLszWo9oRX4S10Kvg689PFXZpo+3407jWLnLgqCuSlYjBXTNjFm/4
         LPez9FkjBRvNE9rjyn0pQRCbfiEzKKOLA37EjR0/BZVqZY2yajKFH9y0ThCtq7At7auY
         +6Zuz4SHN0nsGx4hBejIZAja6CHgdPDjezVjyhJgrqLovY0ojI7DQNm3XVhedTGYPSU5
         /Fm+bWVj3y4NvBmgQwGOKEmQAdjxsWA/hGZT8NDvycvi4D+MWLZXZCUCHUtyVf/hpnR/
         08lZT+MjxA2wErDm/XFofiBMdYjayFPXYHTd27C29fXGS0mG+4DERhhODVSvKxE//Jb4
         cTDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=a1vg2cGQY/7ceieEynUZEE5Mf5IzpVOoJZWBZI51lJg=;
        fh=a3asOULK7dBqbe7WkpalHHdaZwwieqIylvhri2nHu1A=;
        b=AknQh2LLtOJc7q2OgY1JY/JR5t/WkPUApW0NnE6jVQpJ+JqrZMvznS+x2ET/JDZg+G
         JgbzzNM8Ez6p1s3XgUyKIv25qFALqS6fHBciuQb5YqsobDGdD/WCLi3kIFeliDT6rPPE
         XKRDLi2RsD+eQzDQ+lKc5aV/H35Nu5ushxosvKhWsPEeDnrBDB7C+z0JWVVUZ9DABwgk
         JaWfOmxk/jcUEcloM9BgaaMwDylm3vMDaLksQumsygDBb2JFbfHVcGMSjclCJ6GICSor
         FGdNL68SZByLJh9g9zvcP5+QtX5jbtWUNC61s1zdTXNJxPoUx1e7NnII8AweSPT2g6/z
         MEqQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791362228; x=1791967028; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=a1vg2cGQY/7ceieEynUZEE5Mf5IzpVOoJZWBZI51lJg=;
        b=fIcBKMZ+3j/7PrVnTJBpTHWAi4f1MiPCFmOJcKmC0GL1fb6fIBQLmmrxRk6HYNwTGY
         Eugu+ITxWnHKdUnifly7q/ApAvsmvdLAUIThGtIOJGQhZhGi2iMfS61rTnOKC7mHHg9V
         Z3y8qi3VTltBVr7u8Ymw/z1pfobubR/R69+TiL7afAVR3XY/5gJ5WBb+fruYmmcCDdPf
         SEdkb4bWwlMgK2EAOHhoy0+aDvRcx/mPMJ++YZB3VugSJnuPoqrB6gLjQg2yDBSA+OOM
         nZ9LXevss60Mq1N4+ZViTk39xg4OQwskJmKlm6ZlIKFwND85oMISrQ4kylyG7QI3aM6I
         zvxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791362228; x=1791967028;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=a1vg2cGQY/7ceieEynUZEE5Mf5IzpVOoJZWBZI51lJg=;
        b=DZH7rboMza3/HRsT0Kd/EOFuNXSa89u3BVea2aNQcNGZ3XD+gY47RfY9XaDozlV+Ro
         0jnM1CEV73cGs7P71NiLMQ+pSB2xga6KnxyjAGtVa0BpqtE15AHymErLb5dTGhQgNBFm
         /0MAmHw561+zE2Rm65rVu7ac90XEoeFNj0tTgyaihzSX8J7tCacovUN0NjE3OwOOuS1i
         RGYEbHd5u/AoGehs9nJ77nsYUNtERMDqQj11vWP+3b1GuvN62cfC/AU0AEJZgIzA4wL0
         n8W12CdAYKAzWjYQleQxw+HsC68z6N5FD5AK6py+SeJblN6o4XlfNNASOWM0SgZo819c
         dU6w==
X-Forwarded-Encrypted: i=1; AKwUvBxU3DPsEFeTsB8fVk+EGYDic+s5CdBg+uR/02Wl9ydM7CmePzZAovRdy/P8mV0WJxrqwtj4LhM=@lists.linux.dev
X-Gm-Message-State: AFuF++maSV6SLSfmau62Jg9sB2eEkUbUIkIfR7hVyihf/KJGCqJuOV0r
	a9bBTHh5v7MBxSxli9XUd5Zl3dJyXlgp6YbG3FUTSDraE9BFvAjydP21v6V53451l/5SjC1mREe
	zWgxbvg2xO+sbTNMeuQ6D5xhk5Nm6f+nQJ7UkfOzp
X-Gm-Gg: AYBFou1nt2jHwHqMRWv2LWUT5RpfSR1BOvr+UGjjHCgNuzjOHYKu+BmBUd8m68Mp+NG
	0nCWsNEsXtPO/OOCQ8rICpJ3kkerlH6piJMtooHcyHzAg3kNQft+b9WoSCUNAE5jIsAo1ETYI+i
	zvhDtFF4k0uupfHNF5dHzINS16G0fKJX1H/wMAJg0VTFuseCeqDynCQo54P0+2AVF8Ddw0Cbj+e
	wdSAXX1vIvaovVcuBAxOI/JZi+f7X7wd76uVGfZpmTobtibMx3h37B8geY/ak+GGGz9ZQbVWTFP
	v1BRHQLDC3ahaXnuAl3XYfiNhT9Ftt9h+Q5LncooYPC0qM8VmygAEprdsuN5MzMbVdfNvT46WzX
	rBD3xWgwaxGEyN8GQ466VJIOEKVngQrYSa0jycBvVscTho0iqdVcMZTVYh09EuDzZO7U=
X-Received: by 2002:a05:6808:f0a:b0:4d6:9293:9bc3 with SMTP id
 5614622812f47-4fc46f9a5e3mr1945060b6e.61.1791362227617; Wed, 07 Oct 2026
 01:37:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <eca86078-6360-4453-9893-a384d3df0065@mail.kernel.org>
In-Reply-To: <eca86078-6360-4453-9893-a384d3df0065@mail.kernel.org>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Wed, 7 Oct 2026 10:36:55 +0200
X-Gm-Features: AclHuK-VNPnFgmxt3VRGTOvmEq7ub1nE6c_RbwPc3c0S8xkUKTFYOtp4TEVn4iE
Message-ID: <CANp29Y4DUS2u=2aCvpYGrQntBFUVPcbTOdxGMmPmrzaKBbX-bA@mail.gmail.com>
Subject: Re: [PATCH RFC] x86/mce: Synchronize sysfs reconfiguration against
 CPU hotplug
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz reject

On Tue, Oct 6, 2026 at 8:02=E2=80=AFPM 'syzbot' via
syzkaller-upstream-moderation
<syzkaller-upstream-moderation@googlegroups.com> wrote:
>
> When offlining a CPU, the CPU hotplug teardown callback mce_cpu_pre_down(=
)
> is invoked at CPUHP_AP_ONLINE_DYN to disable MCE reporting and delete the
> per-CPU timer via timer_delete_sync(). However, the CPU remains marked in
> cpu_online_mask until the later CPUHP_TEARDOWN_CPU state. If a user
> concurrently updates MCE configuration settings via sysfs (such as
> ignore_ce, cmci_disabled, check_interval, or bank controls), the sysfs
> handlers broadcast configuration changes across all online CPUs using
> on_each_cpu(). Because cpus_read_lock() is not held by the sysfs store
> handlers, an offlining CPU that is still present in cpu_online_mask can
> receive the IPI after its timer has already been deactivated. The IPI
> handler (such as mce_enable_ce() or mce_cpu_restart()) calls
> __mcheck_cpu_init_timer(), which re-arms the timer on the dying CPU. The
> CPU then finishes the offline teardown and halts with an active timer lef=
t
> in the timer wheel.
>
> When the CPU is subsequently brought back online, identify_secondary_cpu(=
)
> calls mcheck_cpu_init() -> __mcheck_cpu_setup_timer(), which invokes
> timer_setup() on the already active timer, triggering a debugobjects
> warning:
>
> ODEBUG: init active (active state 0) object: ffff88827be234a0 object type=
:
> timer_list hint: mce_timer_fn+0x0/0x280
> WARNING: lib/debugobjects.c:632 at debug_print_object+0xec/0x230
> lib/debugobjects.c:629
> Call Trace:
>  <TASK>
>  __debug_object_init+0x224/0x350 lib/debugobjects.c:818
>  timer_init_key+0x41/0x2c0 kernel/time/timer.c:880
>  __mcheck_cpu_setup_timer arch/x86/kernel/cpu/mce/core.c:2087 [inline]
>  mcheck_cpu_init+0x3dc/0x600 arch/x86/kernel/cpu/mce/core.c:2262
>  identify_cpu+0x1f2c/0x3940 arch/x86/kernel/cpu/common.c:2126
>  identify_secondary_cpu+0xaa/0x160 arch/x86/kernel/cpu/common.c:2187
>  ap_starting+0x9c/0x150 arch/x86/kernel/smpboot.c:190
>  start_secondary+0x66/0x110 arch/x86/kernel/smpboot.c:280
>  common_startup_64+0x13e/0x157
>  </TASK>
>
> Fix this by acquiring cpus_read_lock() around mce_sysfs_mutex in the sysf=
s
> store handlers (set_bank(), set_ignore_ce(), set_cmci_disabled(), and
> store_int_with_restart()). Holding cpus_read_lock() serializes sysfs
> reconfigurations against CPU hotplug, ensuring that CPUs undergoing
> teardown do not receive broadcast IPIs to re-enable or re-arm MCE timers
> after mce_cpu_pre_down() has cleaned them up.
>
> Fixes: b3b7c4795cca ("x86/MCE: Serialize sysfs changes")
> Assisted-by: Gemini:gemini-3.8-flash Gemini:gemini-3.1-pro-preview syzbot
> Reported-by: syzbot+edc6b57cbed1fb72d0f9@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3Dedc6b57cbed1fb72d0f9
> Link: https://syzkaller.appspot.com/ai_job?id=3Dc8580209-1c6b-40d9-834d-2=
e3ce14f6111
> To: "Borislav Petkov" <bp@alien8.de>
> To: "Dave Hansen" <dave.hansen@linux.intel.com>
> To: <linux-edac@vger.kernel.org>
> To: "Ingo Molnar" <mingo@redhat.com>
> To: "Thomas Gleixner" <tglx@kernel.org>
> To: "Tony Luck" <tony.luck@intel.com>
> To: <x86@kernel.org>
> To: "Seunghun Han" <kkamagui@gmail.com>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: <linux-kernel@vger.kernel.org>
>
> ---
> diff --git a/arch/x86/kernel/cpu/mce/core.c b/arch/x86/kernel/cpu/mce/cor=
e.c
> index 39f238952..6ba802a5c 100644
> --- a/arch/x86/kernel/cpu/mce/core.c
> +++ b/arch/x86/kernel/cpu/mce/core.c
> @@ -2532,9 +2532,11 @@ static ssize_t set_bank(struct device *s, struct d=
evice_attribute *attr,
>
>         b->ctl =3D new;
>
> +       cpus_read_lock();
>         mutex_lock(&mce_sysfs_mutex);
>         mce_restart();
>         mutex_unlock(&mce_sysfs_mutex);
> +       cpus_read_unlock();
>
>         return size;
>  }
> @@ -2548,6 +2550,7 @@ static ssize_t set_ignore_ce(struct device *s,
>         if (kstrtou64(buf, 0, &new) < 0)
>                 return -EINVAL;
>
> +       cpus_read_lock();
>         mutex_lock(&mce_sysfs_mutex);
>         if (mca_cfg.ignore_ce ^ !!new) {
>                 if (new) {
> @@ -2562,6 +2565,7 @@ static ssize_t set_ignore_ce(struct device *s,
>                 }
>         }
>         mutex_unlock(&mce_sysfs_mutex);
> +       cpus_read_unlock();
>
>         return size;
>  }
> @@ -2575,6 +2579,7 @@ static ssize_t set_cmci_disabled(struct device *s,
>         if (kstrtou64(buf, 0, &new) < 0)
>                 return -EINVAL;
>
> +       cpus_read_lock();
>         mutex_lock(&mce_sysfs_mutex);
>         if (mca_cfg.cmci_disabled ^ !!new) {
>                 if (new) {
> @@ -2588,6 +2593,7 @@ static ssize_t set_cmci_disabled(struct device *s,
>                 }
>         }
>         mutex_unlock(&mce_sysfs_mutex);
> +       cpus_read_unlock();
>
>         return size;
>  }
> @@ -2602,9 +2608,11 @@ static ssize_t store_int_with_restart(struct devic=
e *s,
>         if (check_interval =3D=3D old_check_interval)
>                 return ret;
>
> +       cpus_read_lock();
>         mutex_lock(&mce_sysfs_mutex);
>         mce_restart();
>         mutex_unlock(&mce_sysfs_mutex);
> +       cpus_read_unlock();
>
>         return ret;
>  }
>
>
> base-commit: a90ee4305c4a5df72c11b31dacfdc76e00fcf78a
> --
> This is an AI-generated patch subject to moderation.
> Reply with '#syz upstream' to Sign-off the patch as a human author
> and send it to the upstream kernel mailing lists.
> Reply with '#syz reject' to reject it ('#syz unreject' to undo).
>
> See https://goo.gle/syzbot-ai-patches for information about AI-generated =
patches.
> You can comment on the patch as usual, syzbot will try to address
> the comments and send a new version of the patch if necessary.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
>
> --
> You received this message because you are subscribed to the Google Groups=
 "syzkaller-upstream-moderation" group.
> To unsubscribe from this group and stop receiving emails from it, send an=
 email to syzkaller-upstream-moderation+unsubscribe@googlegroups.com.
> To view this discussion visit https://groups.google.com/d/msgid/syzkaller=
-upstream-moderation/eca86078-6360-4453-9893-a384d3df0065%40mail.kernel.org=
.
