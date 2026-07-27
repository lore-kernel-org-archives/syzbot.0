Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06D99353A61
	for <syzbot@lists.linux.dev>; Mon, 27 Jul 2026 10:46:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785149181; cv=none; b=Z5A0iHtUVtjSbv4WbZH5C5RbULM832C2IiMk1WM6dezJjwJY0hoWqpbhrdEySSWqmD2k3kMbn7tyIrpos17EVzmA8Qtt8s9ZoOwCvk/WreGP9dM6SNkOn2f5uvxFjhXZrhwPzG4ubRpSHFHvybc6AJe16TunLKnZrJqrVvqUCn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785149181; c=relaxed/simple;
	bh=TaR0W4jZLeaYjw+LMGLjK8cAJrD3jrvWZzs2orM84P0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JtFt2eRmr+LejHUe73YHzNwylZsbIGWqMlUEW1qfGeR9xZxjAdlRlJ11q5ilkRFnCO5xDemqpbEj2GT4dhK4L65KF8BJqn5TSOFF0ytRyl2QEpmQVEk2y8eD+8Vkc/n7Jha5ZTN5mNGvw3yVwGLMT+OHpirdMJJNU5HLzrA3N6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=s2jEAQEr; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="s2jEAQEr"
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-c15cd3fd760so258783466b.2
        for <syzbot@lists.linux.dev>; Mon, 27 Jul 2026 03:46:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785149177; x=1785753977; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=s11uK0Ljaw9k8Yl2+My2oK1bg9On7R2tFWiHkOx0azo=;
        b=s2jEAQEr2mbcw0FkISG0GXtiT0KhTjj4UfmU+7iE8ubxU3Usui50Sh5szYoqpWVbFY
         I13Ve4Eg8yxEqIVaSSNalZGlbaWVSYc6HCOisqHCycUiIetzuzfb7jfzQ8HzMzpGitjP
         bsvXtsDVgLAokEisH2Mh37h2QaOcVQVhVQCVUErbUJt7ntsRmtcDl/8OVQ7zr3e40jLq
         HWX5NoYKL8NDvnFqXbN1Dhrcc7USHW9Z0EQdsnvYpcek0vn2LqblxzO94DSZKvka1iHw
         CfG/n3xnbQXaNqWLjAqlTQSWPvGeG4Eb8YX7jkUwxhRm1vaovhe/sICxLE7cIof8NkX3
         cg0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785149177; x=1785753977;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=s11uK0Ljaw9k8Yl2+My2oK1bg9On7R2tFWiHkOx0azo=;
        b=n9RFdi9yOcpTHJ9P8x53paKO7+SAxyTCMlR/pNeiSjvNWuZML4w1TzO1rxwz9UZKrG
         HiGKlZE6ZeWxTUHsQtKKpPsATAizjg5QjdaoOsUtuhSQSGPOQ4pWSI3R47+2E859YdNh
         M3JFLlieG5JroBvhobtYIzoKGXh1sg93E+cPdOlnBiCX3q4iL4hxlzBWkt67QYjXTUFH
         PLWK6Q6TE4ONTatkMbj+n3fdDf/oQRDcH0X75PvoGzuahJ4+7B05fr6pLtFM/1t0jStt
         JC34f/vOOq38MS2UUqO+iIpmLExOG3SJpTjrdFqkNUmN5Pqr1O+AFVrqDs3LNpF0NSib
         n2GQ==
X-Gm-Message-State: AOJu0Yz+JPRRTl2wUQfVZ9PB3Ud2r9AM10rcC1E2LoeOaXOSTVkzHK25
	NnhFoq+v/VORQNJ65ybeOkm6ugotuzWax+5XFmf+LYaN6pF4UGlF9ROS
X-Gm-Gg: AR+sD10gSEvLLuil05f/bsmrB5eztgRymroa10JzMX7cPydLPlOsad2kG6T70KTFmjD
	aJrL4+XQpQXWOotBk9L1I5ZSx2LxMiw0fMPzGubaHvLTF3i2tu2Wnv5SOJDMQBZHrnjtyt/Dl8e
	U+d+G52H+WAvP3wDoXYKJsZHbUWjoV/wd3c/nTcR1AUXpAr28fE3K9uNzey+BKRamTme/8sn8cE
	CZMxjrw36BXmH8vJ1eyqtzekvs/PMwjFr3xu+o6zxHA4mKQb8HBN3G1QT6hm1DiHl5HeuPjp8z1
	clrqBhFfxA+DSeKBZnp9ZLHqyxjOTD+xXW4KvoAjYbMLtZKh4grNxMfrgAERecr4AiY+BOnblmY
	1AwpjpX/Y3TfceYBXcQ+8q1As/Ooci6KqA6H3MOd7JkTHHFaN56NjOaZUb6hoSVkvg37iA2JVsP
	FOk85u3p7ousVvwYaXuV1fOWWW1SLmcUWdtDx9r7WaycgdGe8nrq6luedAr1as5F+wl79RxECbj
	k/Wyf0JDaix/qRTMqctZiZiiKuTwW7llwXy0Esj7nIp6RiWDqheS54mBtSas/FajZlWnr7b
X-Received: by 2002:a17:906:6a03:b0:c12:9e83:643 with SMTP id a640c23a62f3a-c1f1eabed86mr307170166b.10.1785149176796;
        Mon, 27 Jul 2026 03:46:16 -0700 (PDT)
Received: from [192.168.100.51] (87-205-15-91.static.ip.netia.com.pl. [87.205.15.91])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c1c32af244asm614301566b.27.2026.07.27.03.46.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Jul 2026 03:46:16 -0700 (PDT)
Message-ID: <19a7f81a-196d-4eef-96ab-3e772c62cd41@gmail.com>
Date: Mon, 27 Jul 2026 12:46:15 +0200
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v6] ocfs2: fix circular locking dependency in
 ocfs2_init_acl()
To: syzbot <syzbot@kernel.org>, syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
References: <73bcd909-be17-4293-89ce-d63dfeb2e9a2@mail.kernel.org>
Content-Language: en-US
From: Krystian Kaniewski <krystianmkaniewski@gmail.com>
In-Reply-To: <73bcd909-be17-4293-89ce-d63dfeb2e9a2@mail.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Please prepare a commit-message-only revision.

Replace only this paragraph:

We introduce `struct ocfs2_acl_state` to encapsulate the prepared ACL
state, along with `ocfs2_acl_init_prepare()` and `ocfs2_acl_init_release()`
helpers to avoid code duplication between `ocfs2_mknod()` and
`ocfs2_init_security_and_acl()`. `ocfs2_calc_xattr_init()` and
`ocfs2_init_acl()` are updated to use this precomputed state, removing
internal `ip_xattr_sem` acquisition and redundant disk reads.

with:

`struct ocfs2_acl_state` encapsulates the prepared ACL state, while
`ocfs2_acl_init_prepare()` and `ocfs2_acl_init_release()` avoid code
duplication between `ocfs2_mknod()` and
`ocfs2_init_security_and_acl()`. `ocfs2_calc_xattr_init()` and
`ocfs2_init_acl()` use this precomputed state, removing internal
`ip_xattr_sem` acquisition and redundant disk reads.

Keep the subject, every other commit message paragraph, all tags, and 
the code
diff unchanged. Do not alter locking, ACL ownership, mode handling, xattr
reservation, error cleanup, helper interfaces, source comments, or any other
code.

On 7/23/2026 12:00 PM, syzbot wrote:
> A lockdep warning indicates a circular locking dependency between
> `&oi->ip_xattr_sem` and `&journal->j_trans_barrier`:
>
> WARNING: possible circular locking dependency detected
> is trying to acquire lock:
>   (&oi->ip_xattr_sem){++++}-{4:4}, at: ocfs2_init_acl+0x2fd/0x7e0
>   fs/ocfs2/acl.c:367
>
> but task is already holding lock:
>   (&journal->j_trans_barrier){.+.+}-{4:4}, at: ocfs2_start_trans+0x3ab/0x700
>   fs/ocfs2/journal.c:369
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
> Additionally, remove the `ip_xattr_sem` acquisition from
> `ocfs2_xattr_set_handle()`. This function is only used while initializing a
> new inode that has not yet been inserted into the inode hash or attached to
> a dentry, meaning there is no risk of concurrent access and the lock is
> unnecessary.
>
> Fixes: 16c8d569f570 ("ocfs2/acl: use 'ip_xattr_sem' to protect getting extended attribute")
> Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot
> Reported-by: syzbot+4007ab5229e732466d9f@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=4007ab5229e732466d9f
> Link: https://syzkaller.appspot.com/ai_job?id=06dccead-4002-42ee-8d2d-14b14ddf18e0
> To: "Joel Becker" <jlbec@evilplan.org>
> To: "Joseph Qi" <joseph.qi@linux.alibaba.com>
> To: "Mark Fasheh" <mark@fasheh.com>
> To: <ocfs2-devel@lists.linux.dev>
> Cc: <linux-kernel@vger.kernel.org>
>
> ---
> v6:
> - Updated the comment above ocfs2_xattr_set_handle() to clarify that it is only used on unpublished/unhashed inodes and why omitting ip_xattr_sem is safe.
> - Removed the long hyphen and equal sign separator lines from the lockdep report in the commit message to prevent checkpatch from treating them as patch separators.
>
> v5:
> - Removed `ip_xattr_sem` locking from `ocfs2_xattr_set_handle()` as it is only called during initialization of unhashed/unattached inodes.
> https://lore.kernel.org/all/7ae71a37-e360-413c-9618-2acc77194fa2@mail.kernel.org/T/
>
> v4:
> - Initialize `ocfs2_acl_state` structures to `{ 0 }` to ensure safe cleanup.
> - Fix memory leaks in `ocfs2_acl_init_prepare()` error paths.
> - Ensure `ocfs2_acl_init_release()` is always called in `ocfs2_init_security_and_acl()`.
> - Reset pointers to `NULL` in `ocfs2_acl_init_release()` after releasing them.
> - Add parameter names to `ocfs2_calc_xattr_init()` prototype in `xattr.h`.
> https://lore.kernel.org/all/b2e72251-ea1a-458d-961e-7b7e99950e26@mail.kernel.org/T/
>
> v3:
> - Introduced `struct ocfs2_acl_state` to encapsulate the prepared ACL state.
> - Added `ocfs2_acl_init_prepare()` and `ocfs2_acl_init_release()` helpers to avoid code duplication between `ocfs2_mknod()` and `ocfs2_init_security_and_acl()`.
> - Updated `ocfs2_calc_xattr_init()` and `ocfs2_init_acl()` to accept the new `ocfs2_acl_state` structure.
> https://lore.kernel.org/all/857bb6cb-547c-48fb-ae38-b9ffff129432@mail.kernel.org/T/
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
> index af1e2cedb..090ec60fb 100644
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
> @@ -349,63 +348,105 @@ int ocfs2_acl_chmod(struct inode *inode, struct buffer_head *bh)
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
> +void ocfs2_acl_init_release(struct ocfs2_acl_state *state)
> +{
> +	posix_acl_release(state->default_acl);
> +	posix_acl_release(state->acl);
> +	state->default_acl = NULL;
> +	state->acl = NULL;
> +}
> +
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
> +		if (state->default_acl) {
> +			state->acl = posix_acl_dup(state->default_acl);
> +			if (!state->acl) {
> +				ret = -ENOMEM;
>   				goto cleanup;
>   			}
> +			ret = __posix_acl_create(&state->acl, GFP_NOFS,
> +						 &state->mode);
> +			if (ret < 0)
> +				goto cleanup;
> +			if (ret == 0) {
> +				posix_acl_release(state->acl);
> +				state->acl = NULL;
> +			}
> +			if (!S_ISDIR(inode->i_mode)) {
> +				posix_acl_release(state->default_acl);
> +				state->default_acl = NULL;
> +			}
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
> +cleanup:
> +	ocfs2_acl_init_release(state);
> +	return ret;
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
> index 1277666c7..d9aba16a8 100644
> --- a/fs/ocfs2/namei.c
> +++ b/fs/ocfs2/namei.c
> @@ -256,6 +256,7 @@ static int ocfs2_mknod(struct mnt_idmap *idmap,
>   	sigset_t oldset;
>   	int did_block_signals = 0;
>   	struct ocfs2_dentry_lock *dl = NULL;
> +	struct ocfs2_acl_state acl_state = { 0 };
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
> index fcddd3c13..083c60605 100644
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
> +				new_clusters = ocfs2_clusters_for_bytes(dir->i_sb,
> +									acl_len);
> +				*xattr_credits += ocfs2_clusters_to_blocks(dir->i_sb,
> +									   new_clusters);
> +				*want_clusters += new_clusters;
> +			}
> +		}
> +		if (acl_state->acl) {
> +			acl_len = acl_state->acl->a_count *
> +				  sizeof(struct ocfs2_acl_entry);
> +			if (acl_len > OCFS2_XATTR_INLINE_SIZE) {
> +				new_clusters = ocfs2_clusters_for_bytes(dir->i_sb,
> +									acl_len);
> +				*xattr_credits += ocfs2_clusters_to_blocks(dir->i_sb,
> +									   new_clusters);
> +				*want_clusters += new_clusters;
> +			}
> +		}
>   	}
>   
>   	return ret;
> @@ -3483,9 +3491,10 @@ static int __ocfs2_xattr_set_handle(struct inode *inode,
>   }
>   
>   /*
> - * This function only called duing creating inode
> - * for init security/acl xattrs of the new inode.
> - * All transanction credits have been reserved in mknod.
> + * This helper is only for setting initial ACL or security xattrs on an inode
> + * that is still unpublished, unhashed, and unattached to a dentry.
> + * Ordinary xattr updates must use ocfs2_xattr_set().
> + * All transaction credits have been reserved in mknod or symlink callers.
>    */
>   int ocfs2_xattr_set_handle(handle_t *handle,
>   			   struct inode *inode,
> @@ -3542,8 +3551,6 @@ int ocfs2_xattr_set_handle(handle_t *handle,
>   	xis.inode_bh = xbs.inode_bh = di_bh;
>   	di = (struct ocfs2_dinode *)di_bh->b_data;
>   
> -	down_write(&OCFS2_I(inode)->ip_xattr_sem);
> -
>   	ret = ocfs2_xattr_ibody_find(inode, name_index, name, &xis);
>   	if (ret)
>   		goto cleanup;
> @@ -3556,7 +3563,6 @@ int ocfs2_xattr_set_handle(handle_t *handle,
>   	ret = __ocfs2_xattr_set_handle(inode, di, &xi, &xis, &xbs, &ctxt);
>   
>   cleanup:
> -	up_write(&OCFS2_I(inode)->ip_xattr_sem);
>   	brelse(xbs.xattr_bh);
>   	ocfs2_xattr_bucket_free(xbs.bucket);
>   
> @@ -7257,6 +7263,7 @@ int ocfs2_init_security_and_acl(struct inode *dir,
>   {
>   	int ret = 0;
>   	struct buffer_head *dir_bh = NULL;
> +	struct ocfs2_acl_state acl_state = { 0 };
>   
>   	ret = ocfs2_init_security_get(inode, dir, qstr, NULL);
>   	if (ret) {
> @@ -7269,10 +7276,17 @@ int ocfs2_init_security_and_acl(struct inode *dir,
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
> +unlock:
> +	ocfs2_acl_init_release(&acl_state);
>   	ocfs2_inode_unlock(dir, 0);
>   	brelse(dir_bh);
>   leave:
> diff --git a/fs/ocfs2/xattr.h b/fs/ocfs2/xattr.h
> index 65e9aa743..5cdd6c6b4 100644
> --- a/fs/ocfs2/xattr.h
> +++ b/fs/ocfs2/xattr.h
> @@ -55,9 +55,12 @@ int ocfs2_init_security_set(handle_t *, struct inode *,
>   int ocfs2_calc_security_init(struct inode *,
>   			     struct ocfs2_security_xattr_info *,
>   			     int *, int *, struct ocfs2_alloc_context **);
> -int ocfs2_calc_xattr_init(struct inode *, struct buffer_head *,
> -			  umode_t, struct ocfs2_security_xattr_info *,
> -			  int *, int *, int *);
> +
> +struct ocfs2_acl_state;
> +int ocfs2_calc_xattr_init(struct inode *dir, umode_t mode,
> +			  struct ocfs2_security_xattr_info *si,
> +			  int *want_clusters, int *xattr_credits,
> +			  int *want_meta, struct ocfs2_acl_state *acl_state);
>   
>   /*
>    * xattrs can live inside an inode, as part of an external xattr block,
>
>
> base-commit: dc59e4fea9d83f03bad6bddf3fa2e52491777482
