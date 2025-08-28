Received: from mail-oa1-f52.google.com (mail-oa1-f52.google.com [209.85.160.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E24D425E44D
	for <syzbot@lists.linux.dev>; Thu, 28 Aug 2025 09:45:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756374331; cv=none; b=Ja7tKxirIs5xl78L+CgxM5CxwdKQYwmOUUoAIDGI2iZ8SUfs4Tz45MWOnxjIhlTVMhcH1HZchKf8S9oLNwC1MoR+jlIgWsVc9l/1QB7ER/EkkVgMi/g6VRmtJptYZspKEwVvIZLMlNzh/FN/Z74Ku+j9YmHL+BA4zuzX5PgNFRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756374331; c=relaxed/simple;
	bh=7hMnCIf0s/j/kyQBEeUMb6C45NGSJc89PEL7WlpbmWs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qPGefXFTdMk6gXsdmrK44mZufC2n6e/pR0DQuh2ULY7zrafu9zPK/9WnVr+hgG4p5T8Khw8f1mIe7/1CyOJq0/q7JFW1WVZfWIXpBR3s7cTB02Ae6PDcoFMcBeeFWQtKT1A9kH2d7rgRxYxUEIj9/aKVFhIK7UJrl2cFk5xC/qI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=yyNRc5X8; arc=none smtp.client-ip=209.85.160.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="yyNRc5X8"
Received: by mail-oa1-f52.google.com with SMTP id 586e51a60fabf-315a7547f26so47353fac.0
        for <syzbot@lists.linux.dev>; Thu, 28 Aug 2025 02:45:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756374328; x=1756979128; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2nW5/x/BfzMvK6r7ZByg7vrfvCcfZPA6yFMIaMeXES8=;
        b=yyNRc5X8/wZoZOnPE93NbSkc3tF++XECyiwJ/7REdoN9U9pK24rV8KH2W7EvHjwiKL
         Z2nvXftvPf70rdCdFLLZSHuQBzfaEV0Lrq/gQp8sS9jptdDjdcSDSpgQXVZrR2ypUE+j
         GBpm7RX5td+dQhZTj4H9rj5EaWyed1lHVlZidbxnsM+1RVzxWZLJgwO75qnbMaj0YFOQ
         gF74X5TANk2BU70eM+COHAlb3lG035p99Zgq0a/FsxeGxts9HgwtQ1C7/jmKP4uZxTvw
         NP7bsEkPmLqcNNkCbmKOzONS27QHRWlYgHqa34GQT1D55DitSR63+FUdgF+JpIYI4idD
         yh2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756374328; x=1756979128;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2nW5/x/BfzMvK6r7ZByg7vrfvCcfZPA6yFMIaMeXES8=;
        b=Vty5XO4IYZnZqLg5RKzYl6h5PrjopJ2eJ6ROtO098ufbm6RGm2oqzmlok1CmdGylpF
         zIgE8HflzQpMRbPsPPEEeX8g+V/VG+xhG1WqTbSHGm1mKQSXJdpjQCi5XHo8wFRO40ym
         szPJPI+6L+FYvl6FIlXgzZD0LWi2IARR8LTHyFZx+8S3mWKxIyhX/GM8sF2DOfGMls9t
         Ymn8kPKiAPDPzMb1GQmkIIQ9zKBX2EiYbjY82jtWYAx93S8M0cbVj3KmI5QqEjE0IwHD
         HqdL9pyEPH28zXMF3+ky/PraOmIS7i6bRJFh+uxRyRgHMPVhP1Kb2IBq/dCUsyG29Yaf
         6lmA==
X-Forwarded-Encrypted: i=1; AJvYcCV+XpxAcIoOQYc7IePwo4CI3yLu+ThNPn8yvZCyzHa+GpVNZdshwzeOFx5xcyItYeyAG05j2D4=@lists.linux.dev
X-Gm-Message-State: AOJu0YxhiZxudzdov8pPMJxOwo9gKeeVkEeWItTlLSBme7axSyQLRMED
	0hCt+RmlH82M5dfLGyn8xiMDYv5DdvbP/6U3pHP67N/Q+rukQUcFiyxIVi8hwEj166LKUSLa+i7
	4HiwaXM+OQ1uxZpd4zs2MkmwfOEG4iGzFPTUPdWEQ5t7umAL/RHC5i5DP
X-Gm-Gg: ASbGncvcnje1X2BUkeRGDeCKmU7W8VnoOBi5NtjFtDuq595v//xdyUrpA7UoMOvI7wu
	e9X4cOfKokZrzIjHDydSWuZ1uzqcwEi/3H0UdSMX79XrV4SbIeXIkRv5Rij+YBGd31Vobj92UwO
	LqkO8gEUqSSWtPJcHjf1x4PzVUX3tvWXf2Mts1ng6hLvEOOEbCpnodPCVZZlvrBmKAjllsgzXpn
	v76hlxqnXE3YNMQ7d8N3++tDENpKEkEIJh97ewb/YelrL0YTF+rWQ==
X-Google-Smtp-Source: AGHT+IGc/TbQC7eLvjB7SIjJGw0aoCG7PkiCmsDQOWFae8/lETHPMVfgYkRwHJHo+W7n/HNbz9nBBSXlVgk3JlvcvwM=
X-Received: by 2002:a05:6871:410a:b0:307:b1b1:aeb9 with SMTP id
 586e51a60fabf-314dcdcd49dmr13056038fac.35.1756374327745; Thu, 28 Aug 2025
 02:45:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <68aff912.a00a0220.1337b0.0002.GAE@google.com>
In-Reply-To: <68aff912.a00a0220.1337b0.0002.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Thu, 28 Aug 2025 11:45:16 +0200
X-Gm-Features: Ac12FXzjW38cLRS2Aca7mmLLTHyqOaeunth4tS9WR4r8rAUI-YrzxQ-mNB4bE9Y
Message-ID: <CANp29Y4YXiBp+sAe=DUsN9QNhqTpSu7UKQMQiBrh0KCG-LaPew@mail.gmail.com>
Subject: Re: [moderation/CI] Re: sched: make migrate_enable/migrate_disable inline
To: syzbot ci <syzbot+cief93fb72b20f6026@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Thu, Aug 28, 2025 at 8:37=E2=80=AFAM syzbot ci
<syzbot+cief93fb72b20f6026@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v4] sched: make migrate_enable/migrate_disable inline
> https://lore.kernel.org/all/20250828060354.57846-1-menglong.dong@linux.de=
v
> * [PATCH v4 1/3] arch: add the macro COMPILE_OFFSETS to all the asm-offse=
ts.c
> * [PATCH v4 2/3] sched: make migrate_enable/migrate_disable inline
> * [PATCH v4 3/3] sched: fix some typos in include/linux/preempt.h
>
> and found the following issue:
> kernel build error
>
> Full report is available here:
> https://ci.syzbot.org/series/aac2d563-711a-4b4b-89c3-7365b1c03190
>
> ***
>
> kernel build error
>
> tree:      bpf-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/bpf/b=
pf-next.git
> base:      d3abefe897408718799ae3bd06295b89b870a38e
> arch:      amd64
> compiler:  Debian clang version 20.1.7 (++20250616065708+6146a88f6049-1~e=
xp1~20250616065826.132), Debian LLD 20.1.7
> config:    https://ci.syzbot.org/builds/bb1748d9-0b48-4894-b30e-ea91020f1=
c78/config
>
> ./include/linux/rcupdate.h:968:3: error: call to undeclared function 'mig=
rate_disable'; ISO C99 and later do not support implicit function declarati=
ons [-Wimplicit-function-declaration]
> ./include/linux/rcupdate.h:976:3: error: call to undeclared function 'mig=
rate_enable'; ISO C99 and later do not support implicit function declaratio=
ns [-Wimplicit-function-declaration]
> ./include/linux/sched.h:2402:20: error: static declaration of 'migrate_di=
sable' follows non-static declaration
> ./include/linux/sched.h:2407:20: error: static declaration of 'migrate_en=
able' follows non-static declaration
>
> ***
>
> If these findings have caused you to resend the series or submit a
> separate fix, please add the following tag to your commit message:
>   Tested-by: syzbot@syzkaller.appspotmail.com
>
> ---
> This report is generated by a bot. It may contain errors.
> syzbot ci engineers can be reached at syzkaller@googlegroups.com.
>
> The email will later be sent to:
> [andrii@kernel.org ast@kernel.org bpf@vger.kernel.org bsegall@google.com =
daniel@iogearbox.net dietmar.eggemann@arm.com eddyz87@gmail.com haoluo@goog=
le.com jani.nikula@intel.com john.fastabend@gmail.com jolsa@kernel.org juri=
.lelli@redhat.com kpsingh@kernel.org linux-kernel@vger.kernel.org martin.la=
u@linux.dev menglong.dong@linux.dev mgorman@suse.de mingo@redhat.com peterz=
@infradead.org rostedt@goodmis.org sdf@fomichev.me simona.vetter@ffwll.ch s=
ong@kernel.org tzimmermann@suse.de vincent.guittot@linaro.org vschneid@redh=
at.com yonghong.song@linux.dev]
>
> If the report looks fine to you, reply with:
> #syz upstream
>
> --
> You received this message because you are subscribed to the Google Groups=
 "syzkaller-upstream-moderation" group.
> To unsubscribe from this group and stop receiving emails from it, send an=
 email to syzkaller-upstream-moderation+unsubscribe@googlegroups.com.
> To view this discussion visit https://groups.google.com/d/msgid/syzkaller=
-upstream-moderation/68aff912.a00a0220.1337b0.0002.GAE%40google.com.
