Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BC1A3F58D6
	for <syzbot@lists.linux.dev>; Mon, 20 Jul 2026 16:06:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784563580; cv=none; b=d+Afpff2dAwYqqd8R8uIv7hvqbBo53cwCbVbwxpJUXchBPFRuEpp00xjETcliCKNjXPCz/SBvYJwMhW8pZbB7seuH+okbhwL6U14n7oWWq9WljfnXUkh+gVVMYm6++vkX0xLQajeRVzfu59sWbNmPEbrCIi+eGBL8EBtdXMOCY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784563580; c=relaxed/simple;
	bh=BuBtmJ+mMsnSQ6q0VPi2wy5SQg9JaQVcXx94KbWXYQk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hYpw6DbGlfAQ/kCry01sBgrsxl7SZ5Ao9SrKzTay5ylRR09zIQjxqxBG0c7mpEBdAqbLf0fnZPvPsKquxxwCNHWyaeV3Qs/8omai4aN+cMWIO3fXg7ivocay0SXTOQEY6agvWNQDluMRzuabzZekPHtV5qtkPyNYE1u+533bIyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AIyH1eVA; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AIyH1eVA"
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-c15d47266baso843931966b.3
        for <syzbot@lists.linux.dev>; Mon, 20 Jul 2026 09:06:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784563576; x=1785168376; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2o9x9efxTgzBU1nbh/IyeS6QEoVDt6FERXD+Sd6z7L4=;
        b=AIyH1eVAJhINLwu6rvqf+jOl0JfHS6ioqoDRYtfeYByiLG26xUPujx1LbkfgTInbXX
         5Dmu6H6UH9x4HjRDQrZk/+dswgVAlCdHGYcqq094i2r04joEwA5M9sXKvad/0iS3AI1U
         RwLthQI1Gkbt4dME7viN3ESyIqlisQ5fTLjJT6nqne0vsAUT79qOxWPc20TGuwbER5JA
         yEvV1jyIpIWF5zeNH4KxB4S+/jDZe4vx1+xPNtj3PB4NDuX+tNj7fTj+DDwXwKLW2X9H
         mlTGOkwFPLVbWbmdYAFQHlJpn4xLjJJXTb8wKIAEnUZXDkqF8pOe1Y9vVwh2v3sE8G2t
         sZCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784563576; x=1785168376;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=2o9x9efxTgzBU1nbh/IyeS6QEoVDt6FERXD+Sd6z7L4=;
        b=cMtdIIWkjY2C0C1J7bNevMf9xoTiA5/CYwl8zPuXp0W+1M5pJT+7kzH9IP9fGnZoZY
         38Lbwahb1kHJTcH7pgwrpIEPIxvFK02PiHE2vCfbQwCu8Qi52MyxhQzXBfdUNlZZKIzQ
         mFcNBoGBPFe4/Gfz15kcPWkGKWRuAI5gt7l835yGz9E++4XDN7DTXJYrtc0RPhGHpdeG
         zzBE69tx9K6fvUtGC1kXzW2x/B//E8MhEijorFyxVst2/jGchsmMBpXirk3FrAvRTQ60
         1reuC/1Vot6mP5yiNCHwQxRZeTB/CRWAfJnu7bYArz+pnwlxHyvLY7ECJAADjAkPiMtX
         VZ2w==
X-Gm-Message-State: AOJu0YxQ7mwWsNg6OB9G+CtZmd05nFbVDG1Pcnz6zPN5O6vTeOdWMUCx
	ylzsQvpJqe9oBBFKouDOhXiOIvll2xH9O8GSvaxO0mvl3zRGxVK15u33IvRQ08y8n78=
X-Gm-Gg: AfdE7cnnmMIIM3GBdzPlwUzspvkhk2Uuz4cjw+lB6XKxM+YgMsjdxl6ruyYMrVmIZEm
	Eo57N8MY78/2hv7njgYYOHIRw9vaFQMmz6UcenaCzlC9T36CPs5iM6D7mCzGpFXXVwOe5iXwqy1
	fZ76+GTIpLKul15XLrbcot9AD76XVa+Icnq624+BxyRYdWP9jCkTeglQvWhFN0SGcH9C8IM1DAb
	1Y1Zkdi+39DGvc+lRs4gvsMybGVVf/3Uydoz6BezzLMJSVkzi/tu7id3CfMzwXDQ/VXPsgiaEaF
	4ZHe9rHpSuQ4FjwboYlYR4hlaG85IdYGZiZ53i0AIyQRfMtyIwc/gONtBOI7+AwZcixEcbkgJIn
	kCpiuiE5of5W6KYiYtW89p2OT30IrGEWMAMc1YS+3/k85J0DZn3Ki/hw3iM3O0Fyp38b98tft2V
	RwyEvPx+U4MA9W+DGXz1fU9EvBy0wZhEutoRnCCslP77SXeNH1VmFFd0MG0I5F0uCOKdaJcOnTS
	8zkKU1rowm+AyebFQs3kVL8vOVDFF8v+o8RpUl6jyhjRW70xiL40ruV8xZ1tohyVHdi7bol
X-Received: by 2002:a17:906:ef08:b0:c16:7414:4c29 with SMTP id a640c23a62f3a-c16b473acc7mr781317166b.25.1784563576030;
        Mon, 20 Jul 2026 09:06:16 -0700 (PDT)
Received: from [192.168.100.51] (87-205-15-91.static.ip.netia.com.pl. [87.205.15.91])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c1724f50b72sm491289066b.48.2026.07.20.09.06.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Jul 2026 09:06:15 -0700 (PDT)
Message-ID: <c939be59-105f-44e2-bd61-1e50b49a930b@gmail.com>
Date: Mon, 20 Jul 2026 18:06:13 +0200
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v3] ocfs2: fix circular locking dependency in
 ocfs2_init_acl()
To: syzbot <syzbot@kernel.org>, syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
References: <857bb6cb-547c-48fb-ae38-b9ffff129432@mail.kernel.org>
Content-Language: en-US
From: Krystian Kaniewski <krystianmkaniewski@gmail.com>
In-Reply-To: <857bb6cb-547c-48fb-ae38-b9ffff129432@mail.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Please prepare a v4 for syzbot issue 4007ab5229e732466d9f, based on AI 
patch v3 from job ab0834d2-5e5e-4e65-98fb-1e8a48ab683a and kernel commit 
dc59e4fea9d83f03bad6bddf3fa2e52491777482.

Keep the current fix direction. The parent default ACL must be read and 
derived before ocfs2_start_trans(), and ocfs2_init_acl() must not 
reacquire the parent ip_xattr_sem after the transaction starts. Also 
preserve the current v3 handling of __posix_acl_create(), mode and 
security initialization order, exact default and access ACL reservation, 
the ocfs2_acl_state abstraction, and the existing subject and tags.

V3 has two ownership bugs which must be fixed.

First, ocfs2_mknod() declares struct ocfs2_acl_state without 
initialization, but its common leave path always calls 
ocfs2_acl_init_release(). Many exits reach leave before 
ocfs2_acl_init_prepare(), including link-limit failure, a deleted 
parent, an existing entry, directory insertion failure, inode 
reservation failure, inode allocation failure, and security 
initialization failure. In those cases the release helper receives 
indeterminate pointers and can pass them to posix_acl_release(). This 
can turn a normal create error into an invalid memory access or kernel 
memory corruption.

Second, ocfs2_acl_init_prepare() can return an error after obtaining 
state->default_acl. __posix_acl_create() clears state->acl on failure, 
but the default ACL reference remains held. 
ocfs2_init_security_and_acl() jumps directly to its unlock label when 
preparation fails and skips ocfs2_acl_init_release(), leaking the 
default ACL reference.

Use one clear state ownership contract across both callers:

1. Zero-initialize every struct ocfs2_acl_state at declaration so 
release is safe before or after preparation.
2. Make ocfs2_acl_init_release() leave both pointer fields NULL after 
releasing them.
3. Make ocfs2_acl_init_prepare() clean up and leave an empty state on 
every error after acquiring an ACL reference.
4. Run state release on the ocfs2_init_security_and_acl() unlock path 
even when preparation fails. With an empty-on-error contract this should 
be safe and idempotent for the caller.
5. Keep the common ocfs2_mknod() cleanup balanced for errors before 
preparation, preparation errors, reservation failures, transaction 
failures, and errors after ACL application.

Do not move ACL mode derivation before inode owner setup or security 
xattr collection. Do not reintroduce an ACL lookup inside 
ocfs2_init_acl(). Continue to release and clear the access ACL when 
__posix_acl_create() returns zero, and keep it only for a positive 
return. Keep separate xattr space and cluster calculations for the 
default and access ACLs which will actually be stored.

Clean up the unnamed parameters in the ocfs2_calc_xattr_init() 
declaration and the four expression line breaks reported by strict 
checkpatch without making unrelated changes.

Validate v4 with the supplied lockdep reproducer and a focused OCFS2 
build. Also cover these cases:

- ocfs2_mknod() exits before ACL preparation because the target exists, 
the directory link limit is reached, or allocation fails;
- ACL preparation fails after the parent default ACL has been acquired;
- reflink security and ACL initialization hits an ACL cloning or 
creation failure;
- create and mkdir with no default ACL, an equivalent access ACL, and a 
non-equivalent access ACL;
- creation on a mount without POSIX ACL support and symlink creation.

Return the complete replacement patch email against the original base 
commit. Do not send an incremental diff on top of v3.

On 7/19/2026 12:30 PM, syzbot wrote:
> A lockdep warning indicates a circular locking dependency between
> `&oi->ip_xattr_sem` and `&journal->j_trans_barrier`.
>
> The deadlock involves two code paths: Path 1 (setxattr) where
> `ocfs2_xattr_set()` acquires `ip_xattr_sem` (write) and then starts a
> transaction, which acquires `j_trans_barrier` (read); and Path 2
> (mkdir/mknod) where `ocfs2_mknod()` starts a transaction (`j_trans_barrier`
> read) and then calls `ocfs2_init_acl()`, which attempts to acquire
> `ip_xattr_sem` (read) on the parent directory to retrieve the default ACL.
>
> Because rw_semaphores are subject to writer priority, a pending writer on
> `j_trans_barrier` (e.g., the journal commit thread) can cause Path 1 to
> block, while Path 2 is blocked waiting for Path 1 to release
> `ip_xattr_sem`.
>
> The patch fixes the lock ordering by precomputing the ACL state before
> starting the OCFS2 transaction, while preserving POSIX ACL storage
> semantics and the existing inode/security initialization order. By reading
> the parent directory's default ACL and preparing the new inode's ACLs
> outside the transaction, `ip_xattr_sem` is always acquired before
> `j_trans_barrier`.
>
> We introduce `struct ocfs2_acl_state` to encapsulate the prepared ACL
> state, along with `ocfs2_acl_init_prepare()` and `ocfs2_acl_init_release()`
> helpers to avoid code duplication between `ocfs2_mknod()` and
> `ocfs2_init_security_and_acl()`. `ocfs2_calc_xattr_init()` and
> `ocfs2_init_acl()` are updated to use this precomputed state, removing
> internal `ip_xattr_sem` acquisition and redundant disk reads.
>
> Fixes: 16c8d569f570 ("ocfs2/acl: use 'ip_xattr_sem' to protect getting extended attribute")
> Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot
> Reported-by: syzbot+4007ab5229e732466d9f@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=4007ab5229e732466d9f
> Link: https://syzkaller.appspot.com/ai_job?id=ab0834d2-5e5e-4e65-98fb-1e8a48ab683a
> To: "Joel Becker" <jlbec@evilplan.org>
> To: "Joseph Qi" <joseph.qi@linux.alibaba.com>
> To: "Mark Fasheh" <mark@fasheh.com>
> To: <ocfs2-devel@lists.linux.dev>
> Cc: <linux-kernel@vger.kernel.org>
>
> ---
> v3:
> - Introduced `struct ocfs2_acl_state` to encapsulate the prepared ACL state.
> - Added `ocfs2_acl_init_prepare()` and `ocfs2_acl_init_release()` helpers to avoid code duplication between `ocfs2_mknod()` and `ocfs2_init_security_and_acl()`.
> - Updated `ocfs2_calc_xattr_init()` and `ocfs2_init_acl()` to accept the new `ocfs2_acl_state` structure.
>
> v2:
> - Updated ocfs2_calc_xattr_init() to accept precomputed ACLs for more accurate credit and size calculation.
> - Modified ocfs2_mknod() and ocfs2_init_security_and_acl() to fetch and create ACLs before starting a transaction, resolving the lock ordering issue.
> - Ensured inode->i_mode is updated correctly during the pre-transaction ACL creation phase.
> - Added logic to release the access ACL object if it is not required for storage (i.e., matches the file mode).
> https://lore.kernel.org/all/50178043-8171-44ae-ac9e-72449ba95928@mail.kernel.org/T/
>
> v1:
> https://lore.kernel.org/all/bbc14e84-b364-4f93-90e0-bfe42220b2b1@mail.kernel.org/T/
> ---
> diff --git a/fs/ocfs2/acl.c b/fs/ocfs2/acl.c
> index af1e2cedb..1c45993e3 100644
> --- a/fs/ocfs2/acl.c
> +++ b/fs/ocfs2/acl.c
> @@ -110,8 +110,7 @@ static void *ocfs2_acl_to_xattr(const struct posix_acl *acl, size_t *size)
>   	return ocfs2_acl;
>   }
>   
> -static struct posix_acl *ocfs2_get_acl_nolock(struct inode *inode,
> -					      int type,
> +static struct posix_acl *ocfs2_get_acl_nolock(struct inode *inode, int type,
>   					      struct buffer_head *di_bh)
>   {
>   	int name_index;
> @@ -349,63 +348,98 @@ int ocfs2_acl_chmod(struct inode *inode, struct buffer_head *bh)
>    * Initialize the ACLs of a new inode. If parent directory has default ACL,
>    * then clone to new inode. Called from ocfs2_mknod.
>    */
> -int ocfs2_init_acl(handle_t *handle,
> -		   struct inode *inode,
> -		   struct inode *dir,
> -		   struct buffer_head *di_bh,
> -		   struct buffer_head *dir_bh,
> -		   struct ocfs2_alloc_context *meta_ac,
> -		   struct ocfs2_alloc_context *data_ac)
> +int ocfs2_acl_init_prepare(struct inode *inode, struct inode *dir,
> +			   struct buffer_head *dir_bh,
> +			   struct ocfs2_acl_state *state)
>   {
>   	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
> -	struct posix_acl *acl = NULL;
> -	int ret = 0, ret2;
> -	umode_t mode;
> -
> -	if (!S_ISLNK(inode->i_mode)) {
> -		if (osb->s_mount_opt & OCFS2_MOUNT_POSIX_ACL) {
> -			down_read(&OCFS2_I(dir)->ip_xattr_sem);
> -			acl = ocfs2_get_acl_nolock(dir, ACL_TYPE_DEFAULT,
> -						   dir_bh);
> -			up_read(&OCFS2_I(dir)->ip_xattr_sem);
> -			if (IS_ERR(acl))
> -				return PTR_ERR(acl);
> +	int ret = 0;
> +
> +	state->default_acl = NULL;
> +	state->acl = NULL;
> +	state->mode = inode->i_mode;
> +
> +	if (S_ISLNK(inode->i_mode))
> +		return 0;
> +
> +	if (osb->s_mount_opt & OCFS2_MOUNT_POSIX_ACL) {
> +		down_read(&OCFS2_I(dir)->ip_xattr_sem);
> +		state->default_acl =
> +			ocfs2_get_acl_nolock(dir, ACL_TYPE_DEFAULT, dir_bh);
> +		up_read(&OCFS2_I(dir)->ip_xattr_sem);
> +		if (IS_ERR(state->default_acl)) {
> +			ret = PTR_ERR(state->default_acl);
> +			state->default_acl = NULL;
> +			return ret;
>   		}
> -		if (!acl) {
> -			mode = inode->i_mode & ~current_umask();
> -			ret = ocfs2_acl_set_mode(inode, di_bh, handle, mode);
> -			if (ret) {
> -				mlog_errno(ret);
> -				goto cleanup;
> +		if (state->default_acl) {
> +			state->acl = posix_acl_dup(state->default_acl);
> +			if (!state->acl)
> +				return -ENOMEM;
> +			ret = __posix_acl_create(&state->acl, GFP_NOFS,
> +						 &state->mode);
> +			if (ret < 0)
> +				return ret;
> +			if (ret == 0) {
> +				posix_acl_release(state->acl);
> +				state->acl = NULL;
> +			}
> +			if (!S_ISDIR(inode->i_mode)) {
> +				posix_acl_release(state->default_acl);
> +				state->default_acl = NULL;
>   			}
> +		} else {
> +			state->mode &= ~current_umask();
>   		}
> +	} else {
> +		state->mode &= ~current_umask();
>   	}
> -	if ((osb->s_mount_opt & OCFS2_MOUNT_POSIX_ACL) && acl) {
> -		if (S_ISDIR(inode->i_mode)) {
> +
> +	return 0;
> +}
> +
> +void ocfs2_acl_init_release(struct ocfs2_acl_state *state)
> +{
> +	posix_acl_release(state->default_acl);
> +	posix_acl_release(state->acl);
> +}
> +
> +int ocfs2_init_acl(handle_t *handle, struct inode *inode,
> +		   struct buffer_head *di_bh,
> +		   struct ocfs2_alloc_context *meta_ac,
> +		   struct ocfs2_alloc_context *data_ac,
> +		   struct ocfs2_acl_state *state)
> +{
> +	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
> +	int ret = 0;
> +
> +	if (S_ISLNK(inode->i_mode))
> +		return 0;
> +
> +	if (osb->s_mount_opt & OCFS2_MOUNT_POSIX_ACL) {
> +		if (S_ISDIR(inode->i_mode) && state->default_acl) {
>   			ret = ocfs2_set_acl(handle, inode, di_bh,
> -					    ACL_TYPE_DEFAULT, acl,
> -					    meta_ac, data_ac);
> +					    ACL_TYPE_DEFAULT,
> +					    state->default_acl, meta_ac,
> +					    data_ac);
>   			if (ret)
> -				goto cleanup;
> +				return ret;
>   		}
> -		mode = inode->i_mode;
> -		ret = __posix_acl_create(&acl, GFP_NOFS, &mode);
> -		if (ret < 0)
> -			return ret;
> +	}
>   
> -		ret2 = ocfs2_acl_set_mode(inode, di_bh, handle, mode);
> -		if (ret2) {
> -			mlog_errno(ret2);
> -			ret = ret2;
> -			goto cleanup;
> -		}
> -		if (ret > 0) {
> -			ret = ocfs2_set_acl(handle, inode,
> -					    di_bh, ACL_TYPE_ACCESS,
> -					    acl, meta_ac, data_ac);
> +	ret = ocfs2_acl_set_mode(inode, di_bh, handle, state->mode);
> +	if (ret) {
> +		mlog_errno(ret);
> +		return ret;
> +	}
> +
> +	if (osb->s_mount_opt & OCFS2_MOUNT_POSIX_ACL) {
> +		if (state->acl) {
> +			ret = ocfs2_set_acl(handle, inode, di_bh,
> +					    ACL_TYPE_ACCESS, state->acl,
> +					    meta_ac, data_ac);
>   		}
>   	}
> -cleanup:
> -	posix_acl_release(acl);
> +
>   	return ret;
>   }
> diff --git a/fs/ocfs2/acl.h b/fs/ocfs2/acl.h
> index 667c6f03f..a91f9ce27 100644
> --- a/fs/ocfs2/acl.h
> +++ b/fs/ocfs2/acl.h
> @@ -20,9 +20,20 @@ struct posix_acl *ocfs2_iop_get_acl(struct inode *inode, int type, bool rcu);
>   int ocfs2_iop_set_acl(struct mnt_idmap *idmap, struct dentry *dentry,
>   		      struct posix_acl *acl, int type);
>   extern int ocfs2_acl_chmod(struct inode *, struct buffer_head *);
> -extern int ocfs2_init_acl(handle_t *, struct inode *, struct inode *,
> -			  struct buffer_head *, struct buffer_head *,
> -			  struct ocfs2_alloc_context *,
> -			  struct ocfs2_alloc_context *);
> +struct ocfs2_acl_state {
> +	struct posix_acl *default_acl;
> +	struct posix_acl *acl;
> +	umode_t mode;
> +};
> +
> +int ocfs2_acl_init_prepare(struct inode *inode, struct inode *dir,
> +			   struct buffer_head *dir_bh,
> +			   struct ocfs2_acl_state *state);
> +void ocfs2_acl_init_release(struct ocfs2_acl_state *state);
> +int ocfs2_init_acl(handle_t *handle, struct inode *inode,
> +		   struct buffer_head *di_bh,
> +		   struct ocfs2_alloc_context *meta_ac,
> +		   struct ocfs2_alloc_context *data_ac,
> +		   struct ocfs2_acl_state *state);
>   
>   #endif /* OCFS2_ACL_H */
> diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
> index 1277666c7..1d492f359 100644
> --- a/fs/ocfs2/namei.c
> +++ b/fs/ocfs2/namei.c
> @@ -256,6 +256,7 @@ static int ocfs2_mknod(struct mnt_idmap *idmap,
>   	sigset_t oldset;
>   	int did_block_signals = 0;
>   	struct ocfs2_dentry_lock *dl = NULL;
> +	struct ocfs2_acl_state acl_state;
>   
>   	trace_ocfs2_mknod(dir, dentry, dentry->d_name.len, dentry->d_name.name,
>   			  (unsigned long long)OCFS2_I(dir)->ip_blkno,
> @@ -330,10 +331,13 @@ static int ocfs2_mknod(struct mnt_idmap *idmap,
>   		}
>   	}
>   
> +	status = ocfs2_acl_init_prepare(inode, dir, parent_fe_bh, &acl_state);
> +	if (status < 0)
> +		goto leave;
> +
>   	/* calculate meta data/clusters for setting security and acl xattr */
> -	status = ocfs2_calc_xattr_init(dir, parent_fe_bh, mode,
> -				       &si, &want_clusters,
> -				       &xattr_credits, &want_meta);
> +	status = ocfs2_calc_xattr_init(dir, mode, &si, &want_clusters,
> +				       &xattr_credits, &want_meta, &acl_state);
>   	if (status < 0) {
>   		mlog_errno(status);
>   		goto leave;
> @@ -411,8 +415,8 @@ static int ocfs2_mknod(struct mnt_idmap *idmap,
>   		inc_nlink(dir);
>   	}
>   
> -	status = ocfs2_init_acl(handle, inode, dir, new_fe_bh, parent_fe_bh,
> -			 meta_ac, data_ac);
> +	status = ocfs2_init_acl(handle, inode, new_fe_bh, meta_ac, data_ac,
> +				&acl_state);
>   
>   	if (status < 0) {
>   		mlog_errno(status);
> @@ -477,6 +481,8 @@ static int ocfs2_mknod(struct mnt_idmap *idmap,
>   	brelse(parent_fe_bh);
>   	kfree(si.value);
>   
> +	ocfs2_acl_init_release(&acl_state);
> +
>   	ocfs2_free_dir_lookup_result(&lookup);
>   
>   	if (inode_ac)
> diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
> index fcddd3c13..25e52633c 100644
> --- a/fs/ocfs2/xattr.c
> +++ b/fs/ocfs2/xattr.c
> @@ -611,13 +611,10 @@ int ocfs2_calc_security_init(struct inode *dir,
>   	return ret;
>   }
>   
> -int ocfs2_calc_xattr_init(struct inode *dir,
> -			  struct buffer_head *dir_bh,
> -			  umode_t mode,
> +int ocfs2_calc_xattr_init(struct inode *dir, umode_t mode,
>   			  struct ocfs2_security_xattr_info *si,
> -			  int *want_clusters,
> -			  int *xattr_credits,
> -			  int *want_meta)
> +			  int *want_clusters, int *xattr_credits,
> +			  int *want_meta, struct ocfs2_acl_state *acl_state)
>   {
>   	int ret = 0;
>   	struct ocfs2_super *osb = OCFS2_SB(dir->i_sb);
> @@ -628,19 +625,15 @@ int ocfs2_calc_xattr_init(struct inode *dir,
>   						     si->value_len);
>   
>   	if (osb->s_mount_opt & OCFS2_MOUNT_POSIX_ACL) {
> -		down_read(&OCFS2_I(dir)->ip_xattr_sem);
> -		acl_len = ocfs2_xattr_get_nolock(dir, dir_bh,
> -					OCFS2_XATTR_INDEX_POSIX_ACL_DEFAULT,
> -					"", NULL, 0);
> -		up_read(&OCFS2_I(dir)->ip_xattr_sem);
> -		if (acl_len > 0) {
> -			a_size = ocfs2_xattr_entry_real_size(0, acl_len);
> -			if (S_ISDIR(mode))
> -				a_size <<= 1;
> -		} else if (acl_len != 0 && acl_len != -ENODATA) {
> -			ret = acl_len;
> -			mlog_errno(ret);
> -			return ret;
> +		if (acl_state->default_acl && S_ISDIR(mode)) {
> +			acl_len = acl_state->default_acl->a_count *
> +				  sizeof(struct ocfs2_acl_entry);
> +			a_size += ocfs2_xattr_entry_real_size(0, acl_len);
> +		}
> +		if (acl_state->acl) {
> +			acl_len = acl_state->acl->a_count *
> +				  sizeof(struct ocfs2_acl_entry);
> +			a_size += ocfs2_xattr_entry_real_size(0, acl_len);
>   		}
>   	}
>   
> @@ -683,14 +676,29 @@ int ocfs2_calc_xattr_init(struct inode *dir,
>   							   new_clusters);
>   		*want_clusters += new_clusters;
>   	}
> -	if (osb->s_mount_opt & OCFS2_MOUNT_POSIX_ACL &&
> -	    acl_len > OCFS2_XATTR_INLINE_SIZE) {
> -		/* for directory, it has DEFAULT and ACCESS two types of acls */
> -		new_clusters = (S_ISDIR(mode) ? 2 : 1) *
> -				ocfs2_clusters_for_bytes(dir->i_sb, acl_len);
> -		*xattr_credits += ocfs2_clusters_to_blocks(dir->i_sb,
> -							   new_clusters);
> -		*want_clusters += new_clusters;
> +	if (osb->s_mount_opt & OCFS2_MOUNT_POSIX_ACL) {
> +		if (acl_state->default_acl && S_ISDIR(mode)) {
> +			acl_len = acl_state->default_acl->a_count *
> +				  sizeof(struct ocfs2_acl_entry);
> +			if (acl_len > OCFS2_XATTR_INLINE_SIZE) {
> +				new_clusters = ocfs2_clusters_for_bytes(
> +					dir->i_sb, acl_len);
> +				*xattr_credits += ocfs2_clusters_to_blocks(
> +					dir->i_sb, new_clusters);
> +				*want_clusters += new_clusters;
> +			}
> +		}
> +		if (acl_state->acl) {
> +			acl_len = acl_state->acl->a_count *
> +				  sizeof(struct ocfs2_acl_entry);
> +			if (acl_len > OCFS2_XATTR_INLINE_SIZE) {
> +				new_clusters = ocfs2_clusters_for_bytes(
> +					dir->i_sb, acl_len);
> +				*xattr_credits += ocfs2_clusters_to_blocks(
> +					dir->i_sb, new_clusters);
> +				*want_clusters += new_clusters;
> +			}
> +		}
>   	}
>   
>   	return ret;
> @@ -7257,6 +7265,7 @@ int ocfs2_init_security_and_acl(struct inode *dir,
>   {
>   	int ret = 0;
>   	struct buffer_head *dir_bh = NULL;
> +	struct ocfs2_acl_state acl_state;
>   
>   	ret = ocfs2_init_security_get(inode, dir, qstr, NULL);
>   	if (ret) {
> @@ -7269,10 +7278,17 @@ int ocfs2_init_security_and_acl(struct inode *dir,
>   		mlog_errno(ret);
>   		goto leave;
>   	}
> -	ret = ocfs2_init_acl(NULL, inode, dir, NULL, dir_bh, NULL, NULL);
> +
> +	ret = ocfs2_acl_init_prepare(inode, dir, dir_bh, &acl_state);
> +	if (ret)
> +		goto unlock;
> +
> +	ret = ocfs2_init_acl(NULL, inode, NULL, NULL, NULL, &acl_state);
>   	if (ret)
>   		mlog_errno(ret);
>   
> +	ocfs2_acl_init_release(&acl_state);
> +unlock:
>   	ocfs2_inode_unlock(dir, 0);
>   	brelse(dir_bh);
>   leave:
> diff --git a/fs/ocfs2/xattr.h b/fs/ocfs2/xattr.h
> index 65e9aa743..789c5500a 100644
> --- a/fs/ocfs2/xattr.h
> +++ b/fs/ocfs2/xattr.h
> @@ -55,9 +55,11 @@ int ocfs2_init_security_set(handle_t *, struct inode *,
>   int ocfs2_calc_security_init(struct inode *,
>   			     struct ocfs2_security_xattr_info *,
>   			     int *, int *, struct ocfs2_alloc_context **);
> -int ocfs2_calc_xattr_init(struct inode *, struct buffer_head *,
> -			  umode_t, struct ocfs2_security_xattr_info *,
> -			  int *, int *, int *);
> +
> +struct ocfs2_acl_state;
> +int ocfs2_calc_xattr_init(struct inode *, umode_t,
> +			  struct ocfs2_security_xattr_info *, int *, int *,
> +			  int *, struct ocfs2_acl_state *);
>   
>   /*
>    * xattrs can live inside an inode, as part of an external xattr block,
>
>
> base-commit: dc59e4fea9d83f03bad6bddf3fa2e52491777482
