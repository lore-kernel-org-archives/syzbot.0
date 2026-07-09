Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21A8B3C2762
	for <syzbot@lists.linux.dev>; Thu,  9 Jul 2026 07:09:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783580951; cv=none; b=dM4dMDAxRchQ17XzhkPWHtODW+bWylwMfPmg0rKM1lJNoPtFgKmHklMQ6CXyoQuuGVe3qEkVPkIk2gofAzd/Re3vu7ZKRwd/3TLiMC0yzv64caabMEZzQ2Asvudarzms//kCNNuXsmXal6PJxrbQ+wun1l7KSN76j2goWp0wnas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783580951; c=relaxed/simple;
	bh=pRAxiRD81zUfCSNW1J+nMNcDoEYp/FixX/E1Jc8vrq4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FHKpa8inbu6cMcKhQHHOBtFKopOVkFXE6M5mxVLPYQEOfNO2HSIoWKaUK5jXk8ipTZklfZVTOxH5mgldEGGBa2a1rYph1dTe3ZReGcIKX4BWuXvSvdSx2QlVgE4yBShXV1uUc0UOuhht2RJMgHanHtFmGoyWQU2UFtdzRSeSn2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=devineni.in; spf=none smtp.mailfrom=devineni.in; dkim=pass (2048-bit key) header.d=devineni-in.20251104.gappssmtp.com header.i=@devineni-in.20251104.gappssmtp.com header.b=Fv5C40iy; arc=none smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=devineni.in
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=devineni.in
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=devineni-in.20251104.gappssmtp.com header.i=@devineni-in.20251104.gappssmtp.com header.b="Fv5C40iy"
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-381c51fde6bso1642716a91.2
        for <syzbot@lists.linux.dev>; Thu, 09 Jul 2026 00:09:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=devineni-in.20251104.gappssmtp.com; s=20251104; t=1783580948; x=1784185748; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=wsJwI4k59LJTtSSRqcUMygS9266urm8J+OIxscT7x8k=;
        b=Fv5C40iyTJhOVUlbOthHhFXbUeEw0p8X63nNT+Knaz4I01oYLolQgYUSyS9bjQpu8r
         ubgB3NT6EV97hCIxXhTI4pUaYOTygiBRmwiR1kCJvLaFVlOFgqENNXnK+GLHGprJWioC
         6AbgU3C+ltUeOS+DmZ68yFDnLkch9paGyeODwbswrM5orOl/OFugngIVAf3soLgJZhXC
         9REVmdY1AU7rwAWR8a2n+lVM/LH0ofHlSjDi4VGA+qdpNA0cRTNLxWMQXwtoi+ErVUtL
         yEd+sNGCSGmkOR8RD0Y2zIWSbf6DPXCZuaMnTvK0FlmXd25O8zaSekF6OcSNoXokgC4R
         QCfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783580948; x=1784185748;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=wsJwI4k59LJTtSSRqcUMygS9266urm8J+OIxscT7x8k=;
        b=VI2HMeGRnGLd2unWV03MaZZwV4O1vNxx6rSojsWX9vaiE9195YmDTvQo+FSoxfOqKZ
         DehVRCN5dJWGcnFCB4y44EcN2fFaLJNV+eYvebyXGATiy3APKH6ZrS6X7S9HcKBOHQoT
         w1vJQAQvRmYRlowUpJuIQODCzW1oKdjw0S2P41XjV5EdZApV6JlaVJ9/ADhhczpiMKT4
         pV3SO6GLveystBDxzSF7uxfVjdEh8PBhquT9ROXYHMZNdT/O9Fn1qwFbvRqEXwCZ7Wjj
         en0BhxW8SGZuOe5SXQCN213GMgGG4oQvkRdas38hfp81KDeFQP1Qh/ttxBoiZQHJxDLm
         +LHQ==
X-Gm-Message-State: AOJu0YzPWiW4+p6QjgIAaTjfH45UkOLwE55iyPk5HvCQessdt83taQVY
	raM16jjMqKvdwOEuIcNwNhpB8fA9035BXQHsLc2kEh/PSv26hFl5cFneAxl0rbLhVQ==
X-Gm-Gg: AfdE7cmeNvVzSqfbe17U22iURTkZZjRYeZqkx2WCTp19CqMQqi2NQ+hLoInaeq0obpu
	oVMAYxRNObiJP/4dXmVwUwWoZQNfI9sF1+qBoPaddfTeak/kog3YTs38EzEhOS/LRfTXZkNb4sD
	yhfdli2CrCavMiCSBnGzppZ6lQdMZAed4LVaWyk0BNFG/cuCsIje6HgPbXRbeofSfaYWTjMP286
	/59kz1APoVk8f232rUGtqvcLUxb5VruJql9M9K2tsR3DJw4f+3EM+QI2xnVifZq9vo1vmtluhH+
	Dzbc32K7gTrmHbrOVg/KbbOe+UEKSJ5p95Ex2iSuDLsPVGoLZ8t0sVQRBkDSCu//YD4owO5Td6F
	SbSOTmXNQ9c0CpLZk+GJRRSyyRm/LoVrcpoROzSyzzkr/8Pl47m7PwZ1TbzRLID68cCMVPR4znu
	j42kXnOGeE6svTO/Vb2OByK1WR8r+rNUzebaUSFYkUyt/eEklwzzEy/mVKwh3Kuo96T0Oirwash
	ZvqwOtNPmlac2LXLdUJ52dL
X-Received: by 2002:a17:90b:2883:b0:381:28e0:624d with SMTP id 98e67ed59e1d1-389421ae226mr6332130a91.28.1783580948148;
        Thu, 09 Jul 2026 00:09:08 -0700 (PDT)
Received: from [192.168.0.103] ([49.205.97.85])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-38a55a4727bsm672144a91.9.2026.07.09.00.09.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Jul 2026 00:09:07 -0700 (PDT)
Message-ID: <a3d7ee7a-3fbb-41e4-ad7b-dcdb4e2c0c37@devineni.in>
Date: Thu, 9 Jul 2026 12:39:04 +0530
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC] jfs: validate BT_ROOT flag in xt_getpage and
 DT_GETPAGE
To: syzbot <syzbot@kernel.org>, syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
References: <65efb3d8-bbf9-4f4b-800e-b9bc5577b381@mail.kernel.org>
Content-Language: en-US
From: Kusaram Devineni <kusaram@devineni.in>
In-Reply-To: <65efb3d8-bbf9-4f4b-800e-b9bc5577b381@mail.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 27-06-2026 03:44 am, syzbot wrote:
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

keep the current fix direction. The BT_ROOT invariant checks in both 
xt_getpage() and DT_GETPAGE() are correct.

> BUG: spinlock bad magic on CPU#0, syz-executor/6066
>   lock: 0xffff888120999b48, .magic: ffffffff, .owner: <...>/-1902340672,
>   .owner_cpu: 768
> CPU: 0 UID: 0 PID: 6066 Comm: syz-executor Not tainted syzkaller #1
> PREEMPT(full)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS
> 1.16.3-debian-1.16.3-2 04/01/2014
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
>   __dentry_kill+0x206/0x700 fs/dcache.c:718
>   shrink_kill+0xa9/0x2c0 fs/dcache.c:1195
>   shrink_dentry_list+0x2e0/0x5e0 fs/dcache.c:1222
>   shrink_dcache_tree+0xe9/0x5d0 fs/dcache.c:-1
>   do_one_tree+0x28/0xe0 fs/dcache.c:1721
>   shrink_dcache_for_umount+0xa0/0x170 fs/dcache.c:1738
>   generic_shutdown_super+0x6f/0x2d0 fs/super.c:624
>   kill_block_super+0x44/0x90 fs/super.c:1725
>   deactivate_locked_super+0xbc/0x130 fs/super.c:476
>   cleanup_mnt+0x3d3/0x460 fs/namespace.c:1312
>   task_work_run+0x1d9/0x270 kernel/task_work.c:233
>   resume_user_mode_work include/linux/resume_user_mode.h:50 [inline]
>   __exit_to_user_mode_loop kernel/entry/common.c:67 [inline]
>   exit_to_user_mode_loop+0xf3/0x4f0 kernel/entry/common.c:98
>   __exit_to_user_mode_prepare include/linux/irq-entry-common.h:207 [inline]
>   syscall_exit_to_user_mode_prepare include/linux/irq-entry-common.h:230
>   [inline]
>   syscall_exit_to_user_mode include/linux/entry-common.h:318 [inline]
>   do_syscall_64+0x33e/0x560 arch/x86/entry/syscall_64.c:100
>   entry_SYSCALL_64_after_hwframe+0x77/0x7f
>   </TASK>
> 
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Assisted-by: Gemini:gemini-3.1-pro-preview syzbot
> Reported-by: syzbot+e380443eaa59bfb75a84@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=e380443eaa59bfb75a84
> Link: https://syzkaller.appspot.com/ai_job?id=b075f2b7-e5d3-4157-9efa-ee28c166187b
> To: <jfs-discussion@lists.sourceforge.net>
> To: "Dave Kleikamp" <shaggy@kernel.org>
> Cc: "Arnd Bergmann" <arnd@arndb.de>
> Cc: <linux-kernel@vger.kernel.org>
> Cc: "Suchit Karunakaran" <suchitkarunakaran@gmail.com>
> Cc: "Yun Zhou" <yun.zhou@windriver.com>
> Cc: "Zheng Yu" <zheng.yu@northwestern.edu>
> 
> ---
> diff --git a/fs/jfs/jfs_dtree.c b/fs/jfs/jfs_dtree.c
> index ac0f79faf..bbb157daf 100644
> --- a/fs/jfs/jfs_dtree.c
> +++ b/fs/jfs/jfs_dtree.c
> @@ -111,19 +111,26 @@ struct dtsplit {
>   #define DT_PAGE(IP, MP) BT_PAGE(IP, MP, dtpage_t, i_dtroot)
>   
>   /* get page buffer for specified block address */
> -#define DT_GETPAGE(IP, BN, MP, SIZE, P, RC)				\
> -do {									\
> -	BT_GETPAGE(IP, BN, MP, dtpage_t, SIZE, P, RC, i_dtroot);	\
> -	if (!(RC)) {							\
> -		if ((BN) && !check_dtpage(P)) {				\
> -			BT_PUTPAGE(MP);					\
> -			jfs_error((IP)->i_sb,				\
> -				  "DT_GETPAGE: dtree page corrupt\n");	\
> -			MP = NULL;					\
> -			RC = -EIO;					\
> -		}							\
> -	}								\
> -} while (0)
> +#define DT_GETPAGE(IP, BN, MP, SIZE, P, RC)                                       \
> +	do {                                                                      \
> +		BT_GETPAGE(IP, BN, MP, dtpage_t, SIZE, P, RC, i_dtroot);          \
> +		if (!(RC)) {                                                      \
> +			if (((BN) == 0) != !!((P)->header.flag & BT_ROOT)) {      \
> +				BT_PUTPAGE(MP);                                   \
> +				jfs_error(                                        \
> +					(IP)->i_sb,                               \
> +					"DT_GETPAGE: dtree root page corrupt\n"); \
> +				MP = NULL;                                        \
> +				RC = -EIO;                                        \
> +			} else if ((BN) && !check_dtpage(P)) {                    \
> +				BT_PUTPAGE(MP);                                   \
> +				jfs_error((IP)->i_sb,                             \
> +					  "DT_GETPAGE: dtree page corrupt\n");    \
> +				MP = NULL;                                        \
> +				RC = -EIO;                                        \
> +			}                                                         \
> +		}                                                                 \
> +	} while (0)
>   

in DT_GETPAGE(), prefer the existing error message: "DT_GETPAGE: dtree 
page corrupt\n" instead of: "DT_GETPAGE: dtree root page corrupt\n" or 
explain why the new string is desirable despite the check being 
bidirectional. i.e. the invariant is bidirectional and also catches 
non-root pages incorrectly carrying BT_ROOT.

>   /* for consistency */
>   #define DT_PUTPAGE(MP) BT_PUTPAGE(MP)
> diff --git a/fs/jfs/jfs_xtree.c b/fs/jfs/jfs_xtree.c
> index 28c3cf960..6d960dd96 100644
> --- a/fs/jfs/jfs_xtree.c
> +++ b/fs/jfs/jfs_xtree.c
> @@ -118,10 +118,11 @@ static inline xtpage_t *xt_getpage(struct inode *ip, s64 bn, struct metapage **m
>   	if (rc)
>   		return ERR_PTR(rc);
>   	if ((le16_to_cpu(p->header.nextindex) < XTENTRYSTART) ||
> -		(le16_to_cpu(p->header.nextindex) >
> -			le16_to_cpu(p->header.maxentry)) ||
> -		(le16_to_cpu(p->header.maxentry) >
> -			((bn == 0) ? XTROOTMAXSLOT : PSIZE >> L2XTSLOTSIZE))) {
> +	    (le16_to_cpu(p->header.nextindex) >
> +	     le16_to_cpu(p->header.maxentry)) ||
> +	    (le16_to_cpu(p->header.maxentry) >
> +	     ((bn == 0) ? XTROOTMAXSLOT : PSIZE >> L2XTSLOTSIZE)) ||
> +	    ((bn == 0) != !!(p->header.flag & BT_ROOT))) {
>   		jfs_error(ip->i_sb, "xt_getpage: xtree page corrupt\n");
>   		BT_PUTPAGE(*mp);
>   		*mp = NULL;
> 
> 
> base-commit: 8cd9520d35a6c38db6567e97dd93b1f11f185dc6

preserve local indentation/style in `DT_GETPAGE()` and `xt_getpage()`. 
do not reindent the whole DT_GETPAGE() macro or existing xt_getpage() 
condition block. add only the minimal new condition/branch.

-kusaram

