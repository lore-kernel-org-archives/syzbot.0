Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4151B43F0BC
	for <syzbot@lists.linux.dev>; Wed, 29 Jul 2026 09:08:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785316099; cv=none; b=sUpTWjuDoGjwgO9a+4XdK7BqTJKLDfIM//hUKeKmFCiqY9YbImdycbs0+OEWjOBUGkKiS/mZDU0z1XE7CmXKwNEnChLh8RybEM/Di7Ju1Nti+lMGGhogl4W5qKC1dQEz3ZaFZWeSwWj5YVmPE8V9H6DHjY8n05ZPfbDFzdHEWDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785316099; c=relaxed/simple;
	bh=ZEBPBnhk6HhJr2XxqpmYmLROaHdMvAg92olce0fyuVI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jDAB1yY1NO03/LM224ACYHDwDKZhDj091fdOzJXAyfec2idM1MgcivAZ+JZIHEtR6FMmn3ya2/oqRyGxVRxekPzCdSvArIOsrdxofhi3HfPDDusD/JKh6tydQ2aDks7cQAu6CqCPzCVSs3UACSDe9tBm3NDUvlRelImOnUFC6Eo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=devineni.in; spf=none smtp.mailfrom=devineni.in; dkim=pass (2048-bit key) header.d=devineni.in header.i=@devineni.in header.b=TnsD+inh; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=devineni.in
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=devineni.in
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=devineni.in header.i=@devineni.in header.b="TnsD+inh"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2cacb8416a1so7772485ad.1
        for <syzbot@lists.linux.dev>; Wed, 29 Jul 2026 02:08:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=devineni.in; s=google; t=1785316096; x=1785920896; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0RUO4XzPfeWLlkMcISYpm0aLMz5oBUNFwN33JKuZawQ=;
        b=TnsD+inh+GNrCOwN7+NEeyQ6s3Mw8xZz0FfCUFyvvc0FfZ9KEisndYQYxD3oPf5Wc7
         r+St2ynNZ8+TA0d97zFweuJPKr/fZRrDdIGhedRQbVZN2iB1iDqK3EP4uDa5zaFFxznC
         F4W4DdnlkiNV7dlieKzkt7xE6eDHpc1zesLwQYRpd+2iE7+cH7HAiTwthI69+tISEV6u
         1pcwUxANKBm5r14aOYMQ+4NYNYjqzzAwz+qK8DVkhF6sLROEwPhjrnhgNflQxCUOkn+U
         UsRWZWNbM9AN1fhGzF300NTXh5fubpUXfamc467VBC22FaWmNovganVWZ2+vvvIVYm0n
         0pFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785316096; x=1785920896;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=0RUO4XzPfeWLlkMcISYpm0aLMz5oBUNFwN33JKuZawQ=;
        b=Fx6HzaTog8QWpmQSapo8BxlqRcS/5pDjxrHgqZTLcDJMCzXCc6FIE6ysarXXyBxAZ7
         qDPFaAu4O+7BlwQtiFR/izBY1wW1ca8ty7wub4akAu9ryfD5TvfE5/J4DX0uH3egBBcJ
         ByG3r3s6j8KJA8tIqfmHH6VTMYsHIh1d9ji0ayphjul5sgOfaASdaKkthJuXm8wKpb0O
         Phj2EOJlBhQhDTqoIawgPeuMJqgZuqGNYImWxD3QmBa+oYgdMgDXoNbmmQrSxSkY4nz7
         dlsiP+5ZXoNcp77Yz3uDPmwEUQzOLEZuv9MqG5VwTOo0Vn6Ybd2vX91XSc0nRtlo3zRu
         Yqiw==
X-Gm-Message-State: AOJu0YwzhfzIknrhlLGjsCDn/HpYJAxgN3JHYGUBwqh4x0ZZurQJpTGZ
	crzo9oaqXeKvAmsYgYgSGAjYbe4PCcwoM+SSbq3KQmTuAWaA7VWktGupG65pA+rjI5K0rjbrWg4
	DeHo=
X-Gm-Gg: AR+sD10Bb1DkEEDh9b7VESpcX8D1B32agjcbN3Pi9KdhPNIOf8i+uqLBNifQkYDX9no
	SfSyh1eDTtRrhw+gBgqf2s6K3CNBDCd4Uf8UK2Su+jnAT2t68GfUZicSMTP4eCKtwSddcjKMn6U
	dLSn6wl7WvdqMHYC2nkM6NdtXaolL0XvqY6ACaR03tdL5c3E0ih443hPzHtSc+HyPhiDg1Fq+OF
	j0X1g8egh1byUbYXut96GPIB6rwbSMkxsy/2r5n6W8svtZ7a4lTKcX+po6Q45xrLsDyvh0pggG+
	dH7igG0hYHtXGSz/0zLAihIHDOUCFzKZHLfnV0Acym0Ftco223+mGE23Mfs6x0m0Uf5XS9lEYSc
	6u9MPAgD3uXDcjg6/A1RJ0NODMzRQ/fGTfo7DRgAzeuhaNE5oLCQ+ZqPvtvF0R0Br98etvLV7mN
	75aJFx5CufcevMu2vH1j8A9qhP+CJrB1MLaPwx7jzLaOx5zPW/kFvKXD07aMW4LUJ8RLtkGqAZ7
	R+PtmLkZPgVncBaZmhDdTEw98RCkw3SDVWKjL1vinI3t3YL3lgg3obmdB+dVUR57DEjxOtGxwG3
	nAuFGvzIIJ1zyB3NkDK4QHdBcnVvJnYWCl45ui/v1T/Pt5V8a50RcQ==
X-Received: by 2002:a17:903:390d:b0:2c9:97a8:afef with SMTP id d9443c01a7336-2d015d6e468mr66309905ad.40.1785316096425;
        Wed, 29 Jul 2026 02:08:16 -0700 (PDT)
Received: from [192.168.0.120] ([49.205.104.3])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d022a167b5sm8177625ad.7.2026.07.29.02.08.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Jul 2026 02:08:15 -0700 (PDT)
Message-ID: <2a9a22b3-0372-49e8-ab38-944fda03f0d7@devineni.in>
Date: Wed, 29 Jul 2026 14:38:02 +0530
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v3] jfs: validate BT_ROOT flag in xt_getpage and
 DT_GETPAGE
To: syzbot <syzbot@kernel.org>, syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
References: <31d895c9-6ed8-4661-ab39-2e3709540323@mail.kernel.org>
Content-Language: en-US
From: Kusaram Devineni <kusaram@devineni.in>
In-Reply-To: <31d895c9-6ed8-4661-ab39-2e3709540323@mail.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 15-07-2026 08:58 pm, syzbot wrote:
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
> BUG: spinlock bad magic on CPU#1, syz-executor/6078
>   lock: 0xffff8881f55f1b48, .magic: ffffffff, .owner: /-1902340672,
>   .owner_cpu: 768
> CPU: 1 UID: 0 PID: 6078 Comm: syz-executor Not tainted syzkaller #1
> PREEMPT(full)
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
> CPU: 1 UID: 0 PID: 6078 Comm: syz-executor Not tainted syzkaller #1
> PREEMPT(full)
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
> Assisted-by: Gemini:gemini-3.1-pro-preview Gemini:gemini-3-flash-preview syzbot
> Reported-by: syzbot+e380443eaa59bfb75a84@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=e380443eaa59bfb75a84
> Link: https://syzkaller.appspot.com/ai_job?id=20a14f45-b85b-4c13-8896-26c43b87a29b
> To: <jfs-discussion@lists.sourceforge.net>
> To: "Dave Kleikamp" <shaggy@kernel.org>
> Cc: "Arnd Bergmann" <arnd@arndb.de>
> Cc: <linux-kernel@vger.kernel.org>
> Cc: "Yun Zhou" <yun.zhou@windriver.com>
> Cc: "Zheng Yu" <zheng.yu@northwestern.edu>
> 
> ---
> v3:
> - Validated root/non-root invariant failures and non-root dtpage integrity failures.

update the above changelog statement with something simpler, like below...

"Kept the existing DT_GETPAGE error message for both corruption checks."

> - Removed '------------[ cut here ]------------' from the commit message.
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

in DT_GETPAGE() macro above, preserve the existing tab-aligned macro 
style and avoid reindenting the whole macro. limit the change only to 
the condition/branch needed for the BT_ROOT invariant check.

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

in the change to xt_getpage() block made above, preserve the existing 
continuation indentation of the nextindex and maxentry checks. add only 
the new BT_ROOT invariant condition.

>   		jfs_error(ip->i_sb, "xt_getpage: xtree page corrupt\n");
>   		BT_PUTPAGE(*mp);
>   		*mp = NULL;
> 
> 
> base-commit: 8cd9520d35a6c38db6567e97dd93b1f11f185dc6

-kusaram

