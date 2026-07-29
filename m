Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70A37449ECB
	for <syzbot@lists.linux.dev>; Wed, 29 Jul 2026 14:51:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785336715; cv=none; b=BlllvH2y0dcSkBYzN1QUV93SaZxhlsQeX2DPd2rKR1cCKLGcgN9wSLXnU4xq7/ZCCwv6rmbll9KkExkS0K8Y0/wldKDsryg1fJFYFGAKYrmo2fvdSZUK/SpYaklznZcv9/MHQp6IP0HVpZXegxMABZVaM0Uifix2b97ZUa/DMKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785336715; c=relaxed/simple;
	bh=Umgxl/7agEKAJYvOIMMPOoBcpn25dFp8xGrATIdZFM4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GhWGWJedjcjDnLt+Pec2Z3OVxMEn9xmVwspSH1Ez2Ayh4JLGiBa0CT99GkNyHbTucf1VQN9CRjLWYpSucxqthw7lC0E53QV1qVkv76JLkXCKIE6RCuKtAlVloU0T40f29zTmU7SMDunBBWmd65Hk2qJ426dfYbqSqEouBNPKt1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=devineni.in; spf=none smtp.mailfrom=devineni.in; dkim=pass (2048-bit key) header.d=devineni.in header.i=@devineni.in header.b=YgWFMvhg; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=devineni.in
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=devineni.in
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=devineni.in header.i=@devineni.in header.b="YgWFMvhg"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2cf52d15d88so10850275ad.2
        for <syzbot@lists.linux.dev>; Wed, 29 Jul 2026 07:51:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=devineni.in; s=google; t=1785336710; x=1785941510; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=PIstJNJbf1Ri/OAt46WRF4WkQxHExQKlD8q9Yq/6H2Y=;
        b=YgWFMvhgZU4pLJiRMvCbJ3kfPjgU9RPcxcGYYYymFrg48CrWGCrc5T38RFTrp8xcah
         0iuLJyezvxrv2nQj2iOk3KwCDXnV1VQVSKVnGfG44Rty0sbZ2x0V1RKTt2ijNrM8j4te
         s6DdDsJYayu4qM5eAe9Qotkz3iA6DppFnySrsTF7sZ6tLP0IAHX6C8pYX3N/5Teg3+Op
         2hU9Tt9glPWNBfrglnkMZxMwshEBMRsYnQ+ZzffsCm0LCamLOuDBVvbiPNeeINALvpaa
         CKA+TTQQhnB+fz6moKNrMKKkO1ruKC4V8utdalFxgtkPvRMuFwzIcAytyihd91S+Ib5E
         U2MQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785336710; x=1785941510;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=PIstJNJbf1Ri/OAt46WRF4WkQxHExQKlD8q9Yq/6H2Y=;
        b=dc12zF1OzpCdlEQQVzPPAJAqJvuv7S176Q+aOZybkIAsm3VXG7SeB6WKzexzuqzFPv
         DTuPQeXa0eiNBrX+zUkAt2ODGDuDyyIXpd/LFD/2veUnfqg7DX0YR+H4l22dPk/j8fnL
         V9uvk5yibg/gGm3TWN03wq/7iEkvlwjDVZHR1onKlTNrxUQu+CRyPxbBcWB8lpjZmqAK
         EZGKqupW+plxIEMNwkNNSREE9ljPn2JsJzbzheycu+UBXWfjgpdehoCPdZXG9s+bxHkt
         ESolGVANjMBtXe9PLoTLXDMIGDdwFxWAsmlp+a+utyqZJiutxwB/L0E7TERDfb/PH6vA
         G6dA==
X-Gm-Message-State: AOJu0YxepQRhtXC2F84F/E1ishyIGXyBhXU39PDV8ntfj7y4eL+vOYWc
	bsYBTaBGAd4WDf9csmg1VsmqKfmYM31aoVjcy8F5UzqELCl9f5ZK+tp/GgQYxrS74g==
X-Gm-Gg: AR+sD108p+YIsCvLjctRc4646zJXLDfiAOtsc9Gn3Rhg1IwDW06wbCHUXdgl3nWAvs5
	Rb043PvzwuqAu38qPGUyH+RWR9ajZZ/dB+f9rkCtESlSW3ANLWkavazh+X4PXAsZGv3vxlM+LFS
	ls1R8mvJhDwQCmKjIOWeKNgKbnQs1OsrfJiuOyZidLEAAujiJbJEM9EBHf+DAUylfwIt1SPjWFw
	fjGXR1UIOL8gRNJGL/RKNuvLkYItQUvVrX7ijw18T92Ka2ooJKkxs01DGGqgcoV698bvMqdtNFk
	iTu1+zQMcYVSyGpJcyVFdom++Nd0seaXI0+s1MiGVLudud0f/+YsCXkeMH5RSxb7ROeiW+bp4xu
	zjTzeNc6Qr2yzdjH5ZOWiqd/yfw7gUan2BJsA9+8ihQzW6kdH9WEaI+4EnPuasTmXPL+HpxjQho
	g4l/Vt0/ha0nzJNk3QbnTiggWV1iA8CBYkfxwexCmw/dHTgkI0nGSDixW0x6C+v/wo2Z3plCyl5
	H4OaEdW+Q8gb3wtNZ5mrK4z0uu0F89JaJiK2by+v0Xeovw8DleMn4aDFIxuzRKUSg6S6I41x/oQ
	jHMVAEhaGNnlRjLa6kGTUtimV56ilkvqbQRH1q2ru+BRTGmI/GfbaA==
X-Received: by 2002:a17:903:b0d:b0:2c9:c991:6ed3 with SMTP id d9443c01a7336-2d015aee3d6mr82199675ad.12.1785336710140;
        Wed, 29 Jul 2026 07:51:50 -0700 (PDT)
Received: from [192.168.0.120] ([49.205.104.3])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d022a7fabasm12992545ad.37.2026.07.29.07.51.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Jul 2026 07:51:49 -0700 (PDT)
Message-ID: <62d1eca6-8dd3-4d94-b683-0bb7c54fe16c@devineni.in>
Date: Wed, 29 Jul 2026 20:21:35 +0530
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v4] jfs: validate BT_ROOT flag in xt_getpage and
 DT_GETPAGE
To: syzbot <syzbot@kernel.org>, syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
References: <e6d4dd6f-c7c4-4c4e-92dd-8338fa4c1404@mail.kernel.org>
Content-Language: en-US
From: Kusaram Devineni <kusaram@devineni.in>
In-Reply-To: <e6d4dd6f-c7c4-4c4e-92dd-8338fa4c1404@mail.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 29-07-2026 04:15 pm, syzbot wrote:
> A corrupted JFS image can trick the kernel into calling release_metapage()
> on a pseudo-metapage embedded within the inode, leading to an out-of-bounds
> memory access and a spinlock crash.
> 
> When operating on the root page of an xtree or dtree (which is stored
> inline within the inode), JFS doesn't use a real struct metapage. Instead,
> BT_GETPAGE() sets the metapage pointer to the address of
> JFS_IP(ip)->bxflag. Because this is a pseudo-metapage, it does not have a
> valid wait_queue_head_t wait field. Accessing mp->wait reads out-of-bounds
> memory in struct jfs_inode_info.
> 
> In xt_getpage(), the code validates nextindex and maxentry, but it fails to
> verify that the BT_ROOT flag is set in p->header.flag for the root page (bn
> == 0). If the inline xtree root page has a corrupted header.flag where
> BT_ROOT is missing, xtTruncate() will mistakenly treat the root page as a
> regular leaf page and call discard_metapage(mp).
> 
> Unlike XT_PUTPAGE() which safely checks !BT_IS_ROOT(mp) before releasing,
> discard_metapage() calls release_metapage(mp) directly. This assumes mp is
> a real metapage and calls unlock_metapage(mp), which executes
> wake_up(&mp->wait), accessing garbage memory and resulting in a spinlock
> bad magic BUG or UBSAN out-of-bounds array access.
> 
> Fix this by enforcing the invariant that the BT_ROOT flag is set if and
> only if bn == 0 in both xt_getpage() and DT_GETPAGE().
> 
> BUG: spinlock bad magic on CPU#1, comm/6074
>   lock: 0xffff8881f71d1b48, .magic: ffffffff, .owner: /-1902340672,
>   .owner_cpu: 768
> CPU: 1 UID: 0 PID: 6074 Comm: comm Not tainted #1 PREEMPT(full)
> Call Trace:
>   <TASK>
>   dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
>   spin_bug kernel/locking/spinlock_debug.c:78 [inline]
>   debug_spin_lock_before kernel/locking/spinlock_debug.c:86 [inline]
>   do_raw_spin_lock+0x1e5/0x2f0 kernel/locking/spinlock_debug.c:115
>   __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:133 [inline]
>   _raw_spin_lock_irqsave+0x4c/0x60 kernel/locking/spinlock.c:166
>   __wake_up_common_lock+0x30/0x1f0 kernel/sched/wait.c:124
>   unlock_metapage fs/jfs/jfs_metapage.c:40 [inline]
>   release_metapage+0x131/0xa60 fs/jfs/jfs_metapage.c:872
>   xtTruncate+0xeaa/0x2eb0 fs/jfs/jfs_xtree.c:-1
>   jfs_free_zero_link+0x35b/0x4c0 fs/jfs/namei.c:760
>   jfs_evict_inode+0x356/0x430 fs/jfs/inode.c:159
>   evict+0x624/0xb50 fs/inode.c:841
>   ...
>   </TASK>
> 
> UBSAN: array-index-out-of-bounds in kernel/locking/qspinlock.h:68:9
> index 8945 is out of range for type 'unsigned long[8]'
> CPU: 1 UID: 0 PID: 6074 Comm: comm Not tainted #1 PREEMPT(full)
> Call Trace:
>   <TASK>
>   dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
>   ubsan_epilogue+0xa/0x30 lib/ubsan.c:233
>   __ubsan_handle_out_of_bounds+0xe8/0xf0 lib/ubsan.c:455
>   decode_tail kernel/locking/qspinlock.h:68 [inline]
>   __pv_queued_spin_lock_slowpath+0xaf3/0xbc0 kernel/locking/qspinlock.c:285
>   pv_queued_spin_lock_slowpath arch/x86/include/asm/paravirt-spinlock.h:35
>   [inline]
>   queued_spin_lock_slowpath arch/x86/include/asm/paravirt-spinlock.h:66
>   [inline]
>   queued_spin_lock include/asm-generic/qspinlock.h:114 [inline]
>   do_raw_spin_lock+0x26c/0x2f0 kernel/locking/spinlock_debug.c:116
>   __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:133 [inline]
>   _raw_spin_lock_irqsave+0x4c/0x60 kernel/locking/spinlock.c:166
>   __wake_up_common_lock+0x30/0x1f0 kernel/sched/wait.c:124
>   unlock_metapage fs/jfs/jfs_metapage.c:40 [inline]
>   release_metapage+0x131/0xa60 fs/jfs/jfs_metapage.c:872
>   xtTruncate+0xeaa/0x2eb0 fs/jfs/jfs_xtree.c:-1
>   ...
>   </TASK>
> 
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot
> Reported-by: syzbot+e380443eaa59bfb75a84@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=e380443eaa59bfb75a84
> Link: https://syzkaller.appspot.com/ai_job?id=a0b45181-6c6e-42a4-85c9-89f4273612e3
> To: <jfs-discussion@lists.sourceforge.net>
> To: "Dave Kleikamp" <shaggy@kernel.org>
> Cc: "Arnd Bergmann" <arnd@arndb.de>
> Cc: <linux-kernel@vger.kernel.org>
> Cc: "Yun Zhou" <yun.zhou@windriver.com>
> Cc: "Zheng Yu" <zheng.yu@northwestern.edu>
> 
> ---
> v4:
> - Avoided unnecessary whitespace and formatting changes in DT_GETPAGE and xt_getpage.
> - Kept the existing DT_GETPAGE error message for both corruption checks.
> 
> v3:
> - Validated root/non-root invariant failures and non-root dtpage integrity failures.
> - Removed '------------[ cut here ]------------' from the commit message.
> https://lore.kernel.org/all/31d895c9-6ed8-4661-ab39-2e3709540323@mail.kernel.org/T/
> 
> v2:
> - Combined the BT_ROOT flag validation with the existing page integrity check in DT_GETPAGE.
> - Unified the error message in DT_GETPAGE for both root and leaf page corruption.
> https://lore.kernel.org/all/b94e1523-acdb-4470-904e-373249bbf83d@mail.kernel.org/T/
> 
> v1:
> https://lore.kernel.org/all/65efb3d8-bbf9-4f4b-800e-b9bc5577b381@mail.kernel.org/T/
> ---
> diff --git a/fs/jfs/jfs_dtree.c b/fs/jfs/jfs_dtree.c
> index ac0f79faf..0d372a237 100644
> --- a/fs/jfs/jfs_dtree.c
> +++ b/fs/jfs/jfs_dtree.c
> @@ -115,7 +115,8 @@ struct dtsplit {
>   do {									\
>   	BT_GETPAGE(IP, BN, MP, dtpage_t, SIZE, P, RC, i_dtroot);	\
>   	if (!(RC)) {							\
> -		if ((BN) && !check_dtpage(P)) {				\
> +		if ((((BN) == 0) != !!((P)->header.flag & BT_ROOT)) ||	\
> +		    ((BN) && !check_dtpage(P))) {			\
>   			BT_PUTPAGE(MP);					\
>   			jfs_error((IP)->i_sb,				\
>   				  "DT_GETPAGE: dtree page corrupt\n");	\
> diff --git a/fs/jfs/jfs_xtree.c b/fs/jfs/jfs_xtree.c
> index 28c3cf960..3a5f9d035 100644
> --- a/fs/jfs/jfs_xtree.c
> +++ b/fs/jfs/jfs_xtree.c
> @@ -121,7 +121,8 @@ static inline xtpage_t *xt_getpage(struct inode *ip, s64 bn, struct metapage **m
>   		(le16_to_cpu(p->header.nextindex) >
>   			le16_to_cpu(p->header.maxentry)) ||
>   		(le16_to_cpu(p->header.maxentry) >
> -			((bn == 0) ? XTROOTMAXSLOT : PSIZE >> L2XTSLOTSIZE))) {
> +			((bn == 0) ? XTROOTMAXSLOT : PSIZE >> L2XTSLOTSIZE)) ||
> +		((bn == 0) != !!(p->header.flag & BT_ROOT))) {
>   		jfs_error(ip->i_sb, "xt_getpage: xtree page corrupt\n");
>   		BT_PUTPAGE(*mp);
>   		*mp = NULL;
> 
> 
> base-commit: 8cd9520d35a6c38db6567e97dd93b1f11f185dc6

#syz upstream

