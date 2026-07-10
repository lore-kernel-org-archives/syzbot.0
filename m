Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F47D3A9879
	for <syzbot@lists.linux.dev>; Fri, 10 Jul 2026 06:05:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783663534; cv=none; b=t/rMYfjWVEXicaVxlfvd1ThSNJOhcOocIsQnzuPOs30O2dTV+rr6EtlAr9W+1XFxrLltuLZLZsvDb7FowYiXb/PXKAlIibV8J2hN8efRY0HfE94XfIzDL2836w9lpqluu/XYiOYm2uKqgDg18HHwRcFBbqSTccjvPcxVF0Ynaeg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783663534; c=relaxed/simple;
	bh=24oauDtAx4p5Ezzzgrl44FQm+KsvqSpZKXtmXPG17Tc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eohB/qfA/Bhy5UodKkhBcl/HYkmrzdCr0L8lhJskOQcd//yrYVZs6ipN8Cd63nS1D+tyt5JkTMzt0MuRwPF5TPB//yCBRpWA1gKfEcxCty+v/PTjCe10swlQBhB8Qn4DZne2uR+wuhu9yDt7swe7a2SLNS5+ZauDJ4vpkf/Q9KY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=devineni.in; spf=none smtp.mailfrom=devineni.in; dkim=pass (2048-bit key) header.d=devineni-in.20251104.gappssmtp.com header.i=@devineni-in.20251104.gappssmtp.com header.b=WJZbdkDG; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=devineni.in
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=devineni.in
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=devineni-in.20251104.gappssmtp.com header.i=@devineni-in.20251104.gappssmtp.com header.b="WJZbdkDG"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2cace7da66eso5640075ad.0
        for <syzbot@lists.linux.dev>; Thu, 09 Jul 2026 23:05:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=devineni-in.20251104.gappssmtp.com; s=20251104; t=1783663531; x=1784268331; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=A2i3tDffGLIBHBbRePj+Bb2zX/2S3rD/nqG4TFhx9PM=;
        b=WJZbdkDGIysyt7d1MPTBujUyCpTs7lQHKPzFFmJ9uEUIf0RwaGeQP0Jf8uHgVqMx51
         ovxDN/FR88befP3pkVt4FArfHNap/pwqu7wi+FG6zOeHIvRL8nmsXBoQRvg0YMx94Q5P
         U8Z5/n/+G+T5EP2C82nxdF0uZ9BkUd7Wjoh0pybiJnV/Ou86Q1PrhmUAmWl/hDSJxZmY
         YRfV4HrH2GhIpirjq63lX616OJAZfAYQQqSWADZ33QpkoMjorlxVRYq67phvEFfBQg+o
         wR3k436Wvsm8WunwxNO8uPRQe/HevLjbNVynHCi+kcpdgTXV0jVhsaczM1g8uGHgQag3
         rwYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783663531; x=1784268331;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=A2i3tDffGLIBHBbRePj+Bb2zX/2S3rD/nqG4TFhx9PM=;
        b=L6S0z6GAW8WD5+c6I12WoV0bWS7kK7muC9rmJNFjvXHehhiVtdiKOs+ctQ5DefZYCs
         /PFGhdXA8iXK0U9IYUmTbu8itIKkNqDdVnUOHz7FCC3OZh6JWshvMzmTJOIm+wXKIf4E
         iwo8w9oPU3+C4ekVyIzl5jyWyzGrzh/TubOL7d6ybI6cmeNuW5MkrZIezSL93v+/Aamq
         yheVFjw3mrw1d2Zallz6uuWgbfjyQnaVoOrakqJUOqEkoxiOGylxKUBaklIiUfKFaNt7
         X+YcLlDn6+eNvyUL5eGKmOZnAP2B/WAuYyC7p6EgbdMvzmLGaudDcehSYrQylBQwYl1M
         31WA==
X-Gm-Message-State: AOJu0YwDnPeGcoD6UVCSjApNEvjjlJQ5VczEPzmyu870IU5Il16/ME3t
	hbbicCkmYl7ap6//nJlCDx2I2oNVX9gGi4iuP5fFA6XZzZ7uH2F7eL/XINy8sdHCKGXEFILW+fl
	HHIU=
X-Gm-Gg: AfdE7cn5jIlzO3bnKzOQeJ/FrVQ0FVhA3ozGQBof2/ZPrffseHXzGyP2WeKu73Umsg8
	0YEZKZI+Al0D3jvFAB1GDn3Q1nKW4BhhKOp7E+VuKmXfipiJAVOhatRzYvkt/06SuJArXd2Nc9y
	5Cbeb3DA9ii+8t0FSAX1Cjbcygg/cj8Q5GuP9CuGsY5o2PE9V8BU3SQkOSIaFC3tIb1SLRlNIQL
	wjB4Xzx+hI+R6evROVB9pAmu8vZ81QHlctD8IGVBlPBp1b2IZpBCUPKX9lSMaYkCdCNmbU4hl8N
	uSfBdS5bTFwBPstSui4FFT+uyhSmk/9WB9UM29nggC22Fs5XMlPfQqcQbAOU6BTzUpIkS4fJuOx
	BN76sTiqJVd62nTGZSQJihB+XjjQTd1R3A6Fh92zVS7pAmiAqCk3Mtn7DDXe70RrXxxvCATcUFG
	1cc11sKW+lnbeypfaPqn8xtEzLq9O0H+V7/0G2pdri9RdMBAOufNlw0180MnZNvLSlQq5h/7EGN
	5R2XwSewqq3dpc=
X-Received: by 2002:a17:902:ff8e:b0:2cc:9179:325 with SMTP id d9443c01a7336-2ccea387551mr112168365ad.13.1783663530647;
        Thu, 09 Jul 2026 23:05:30 -0700 (PDT)
Received: from [192.168.0.103] ([49.205.107.67])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ccc9bdb73asm54363715ad.17.2026.07.09.23.05.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Jul 2026 23:05:29 -0700 (PDT)
Message-ID: <f5d9b884-cad2-400a-bea4-197ccc887a5c@devineni.in>
Date: Fri, 10 Jul 2026 11:35:16 +0530
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v2] jfs: validate BT_ROOT flag in xt_getpage and
 DT_GETPAGE
To: syzbot <syzbot@kernel.org>, syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
References: <b94e1523-acdb-4470-904e-373249bbf83d@mail.kernel.org>
Content-Language: en-US
From: Kusaram Devineni <kusaram@devineni.in>
In-Reply-To: <b94e1523-acdb-4470-904e-373249bbf83d@mail.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 09-07-2026 01:50 pm, syzbot wrote:
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
> BUG: spinlock bad magic on CPU#1, syz-executor/6074
>   lock: 0xffff8881f71d1b48, .magic: ffffffff, .owner:  /-1902340672,
>   .owner_cpu: 768
> CPU: 1 UID: 0 PID: 6074 Comm: syz-executor Not tainted syzkaller #1
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
> RIP: 0033:0x7fbf84d9e097
>   </TASK>
> ------------[ cut here ]------------

- checkpatch.pl considers the line above "------------[ cut here 
]------------" that is added inside the commit message as "ERROR: 
Invalid commit separator". remove it.

> UBSAN: array-index-out-of-bounds in kernel/locking/qspinlock.h:68:9
> index 8945 is out of range for type 'unsigned long[8]'
> CPU: 1 UID: 0 PID: 6074 Comm: syz-executor Not tainted syzkaller #1
> PREEMPT(full)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS
> 1.16.3-debian-1.16.3-2 04/01/2014
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
>   </TASK>
> 
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Assisted-by: Gemini:gemini-3.1-pro-preview Gemini:gemini-3-flash-preview syzbot
> Reported-by: syzbot+e380443eaa59bfb75a84@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=e380443eaa59bfb75a84
> Link: https://syzkaller.appspot.com/ai_job?id=755ca394-6f1f-4a09-8e45-1a3c045336ed
> To: <jfs-discussion@lists.sourceforge.net>
> To: "Dave Kleikamp" <shaggy@kernel.org>
> Cc: "Arnd Bergmann" <arnd@arndb.de>
> Cc: <linux-kernel@vger.kernel.org>
> Cc: "Suchit Karunakaran" <suchitkarunakaran@gmail.com>
> Cc: "Yun Zhou" <yun.zhou@windriver.com>
> Cc: "Zheng Yu" <zheng.yu@northwestern.edu>
> 
> ---
> v2:
> - Combined the BT_ROOT flag validation with the existing page integrity check in DT_GETPAGE.
> - Unified the error message in DT_GETPAGE for both root and leaf page corruption.
> 

- change v2 changelog wording from “root and leaf page corruption” to 
“root/non-root invariant failures and non-root dtpage integrity 
failures.”, as check_dtpage() is for non-root dtpage integrity 
generally, not leaf-only.

> v1:
> https://lore.kernel.org/all/65efb3d8-bbf9-4f4b-800e-b9bc5577b381@mail.kernel.org/T/
> ---
> diff --git a/fs/jfs/jfs_dtree.c b/fs/jfs/jfs_dtree.c
> index ac0f79faf..2b6bdea1f 100644
> --- a/fs/jfs/jfs_dtree.c
> +++ b/fs/jfs/jfs_dtree.c
> @@ -111,19 +111,20 @@ struct dtsplit {
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
> +#define DT_GETPAGE(IP, BN, MP, SIZE, P, RC)                                    \
> +	do {                                                                   \
> +		BT_GETPAGE(IP, BN, MP, dtpage_t, SIZE, P, RC, i_dtroot);       \
> +		if (!(RC)) {                                                   \
> +			if ((((BN) == 0) != !!((P)->header.flag & BT_ROOT)) || \
> +			    ((BN) && !check_dtpage(P))) {                      \
> +				BT_PUTPAGE(MP);                                \
> +				jfs_error((IP)->i_sb,                          \
> +					  "DT_GETPAGE: dtree page corrupt\n"); \
> +				MP = NULL;                                     \
> +				RC = -EIO;                                     \
> +			}                                                      \
> +		}                                                              \
> +	} while (0)
>   
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

- limit the formatting changes to only the lines, block, or branch being 
modified. in DT_GETPAGE() and xt_getpage(), avoid reindenting the 
surrounding existing code; add only the new BT_ROOT invariant condition 
and keep the local style unchanged.

> 
> base-commit: 8cd9520d35a6c38db6567e97dd93b1f11f185dc6

-kusaram
