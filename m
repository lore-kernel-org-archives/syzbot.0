Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F279200110
	for <syzbot@lists.linux.dev>; Sun, 19 Jul 2026 08:54:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784451285; cv=none; b=hfPd4ltJGJpH4gtAAnpg9+JAkfy345Pug//tMgvvOYIexszzQO5aZ23xxMzErZM2kl/zJ2m2p2VXRSKD1tc953XooldqtNLMFt0xQsGmT6GMt5qki7aUqTo8g0CtCI46SAYN7VYc4udXFpkKpK9GHjQSLvAi3JXBx1hUyRlU3XQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784451285; c=relaxed/simple;
	bh=cayEyOwFNYZBtwBqK/WoaNV7vNtBiAf186GYW/ecdMk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fDrBTyzAESjsKrLexL/4MxpLMsbcJbNO0ZFgXyZoDVUHw50LYvYxo6tjtawuX7taLjwwD+WIvpmzwkgSGuAtIZpiJzT9GLfFlSqLbwzqJh7uSP+YxSMZiysVwXQ6T3StsCcm6Ru8GNoaJRnv4pOVMECF+UbBluLkZZ99xqflfhw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZTdQw2fD; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZTdQw2fD"
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-c15cd3fd760so1035838966b.2
        for <syzbot@lists.linux.dev>; Sun, 19 Jul 2026 01:54:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784451281; x=1785056081; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=CMaStQtxHA/bzIm2jRoC4ccUi9vRiuMHVhYiN4Z8Yh0=;
        b=ZTdQw2fDzKX9Sn9rIfLAObsateSlca1olvvwURdlTwDEcLz/451PEW8pGoZ2OHWRtq
         Px6gL/CyTHGG8YKBdS/YF1kV7WKgkbJS9pelhIRb8/xaDnGAOM/6wR3q+JKkJyTrb2FI
         Lg80Z5gKATqLbsLNwfNFnhgLeXw71/0GNRNQZx6URhh+dxknK5Ec2SBgghhOBVG6FN6d
         TfzgDUzY5vqKskOGpZHLt7n5EuUEZRtqeHjaIHSXEq5EOIp+YlQJgRTa4hLYKzGom5PO
         ppqLLPhzA6pSI+FDrlpgCJ0xAHFbeicxeV0id52LzqP+WLI3flvrtjHquJfnSoSZWGgK
         ZoUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784451281; x=1785056081;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=CMaStQtxHA/bzIm2jRoC4ccUi9vRiuMHVhYiN4Z8Yh0=;
        b=lXPo30u4rLfRVGZeyjEqwAsvZaTPJpsk/YhwnyoDilYSHKzBI85/RVJ2BiyNJd3TsM
         dEfLMz3jC8+KKN2DKp5kF2QWl8Kt4OXZXdmyR0ir/MTFC2PbuW+2/bq/MeF6uPrbqS2A
         h3VF+uOCXGgVvwOeIEkffkVGN6hsSNXSUQhs9rnLIPbGrk6c/SK4w84ejfpzMOtUKzjr
         VBcIdsuOuY4JeVETQYtoYkeaYfeaybSjXUbKQBVd+UttrJQcNd91dZqqqopV19+COlDp
         G7NRPJFWbVwkta2p+lKu/IisPJ4NQkm704rVyAz6u/0eFUXipe+WUSujE0vBsd+LvMVy
         pJWA==
X-Gm-Message-State: AOJu0Yw80RnB+8QpTMBda7905bZ88ThC9PtkOWRBk/l7+9uh2+Zue9az
	AB5x/df7oXi/BnDhmRKYpK7GYPY8khX/alk9YQYyszyZ/pUAC1ZRZlI7
X-Gm-Gg: AfdE7ck0BDh4FeYbkL20BVsp1WF373kJoT2c2kPAjpyHsHONFQb0U1hoWLEIDRIMCe6
	XPQ2YR6t1M2uFVKkcaShlS10WJa/uW3zug+9QtxY9pAaCsHMo69JUscRhDsuwEoYAuoaDfiMmAW
	OKFW/odvzoYTYFI+ircRz0k19347qLyAG2VAHnBrMU+1iWZXcDPtAFJAFmsv/rGADrcAbve+0v9
	u7gtXbpsN0lM0bwSpKi55W+Xmuohw10PzQ1XbIguoD93MQ+IuThLdFD0kRjHZzo8nTbZ7HJyamT
	w+0MXxLmRVBerMbKVthz3IeQglM2QV6LNIV9ZY5iW4Lx53vz1DZJZLYT5sIE+iBn315Vir/AWlv
	BY3s1OhuyBcygJ9YjvakifhdQLWzgVfI9IXNFSPUP3Rh95a4C1Flkeu3zIZl9TA3EZj6WuCj2pQ
	ShsP3gcVqu1WqwfZ8iwt9QX+Ti3TP/5zTE+kK0r5Cd3QeCf9ZmjnZSl/3X0PaVSr6onGC1WTX7k
	utKBJrqdy7jdLANXe8Cc9jmPourA2EdZZxBmWxAeH/jCO0bkBv6JnnQ4wmWJHzDoqWkjRoSfKqm
	Rwnjh3s=
X-Received: by 2002:a17:907:e1ce:10b0:c19:4ea0:f4a3 with SMTP id a640c23a62f3a-c194ea0f712mr142385666b.22.1784451281069;
        Sun, 19 Jul 2026 01:54:41 -0700 (PDT)
Received: from [192.168.100.51] (87-205-15-91.static.ip.netia.com.pl. [87.205.15.91])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c17009adfe7sm315114266b.6.2026.07.19.01.54.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 19 Jul 2026 01:54:40 -0700 (PDT)
Message-ID: <c18892a5-ac3a-4073-a546-d2ad72da01c6@gmail.com>
Date: Sun, 19 Jul 2026 10:54:39 +0200
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v2] ocfs2: fix circular locking dependency in
 ocfs2_init_acl()
To: syzbot <syzbot@kernel.org>, syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
References: <50178043-8171-44ae-ac9e-72449ba95928@mail.kernel.org>
Content-Language: en-US
From: Krystian Kaniewski <krystianmkaniewski@gmail.com>
In-Reply-To: <50178043-8171-44ae-ac9e-72449ba95928@mail.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Thanks for the v2 update. It fixes the ACL handling problem from v1 and 
appears to remove the reported lock inversion. Please prepare another 
revision with the following cleanup and semantic requirements.

Keep the main locking rule from v2: the parent default ACL must be read 
and prepared before ocfs2_start_trans(). The new version must not 
reintroduce any path that acquires the parent ip_xattr_sem while holding 
j_trans_barrier.

Please centralize ACL preparation in fs/ocfs2/acl.c. A small state 
structure containing the prepared default ACL, prepared access ACL, and 
resulting mode would make the ownership and cleanup rules clearer. Both 
ocfs2_mknod() and ocfs2_init_security_and_acl() should use this common 
preparation path instead of duplicating the ACL lookup and 
__posix_acl_create() handling.

The mode passed to ACL preparation must start from inode->i_mode after 
mode_strip_sgid() and inode_init_owner() have completed. Do not use the 
original local mode argument as the starting value. That would lose 
changes already made by inode initialization, including inherited 
S_ISGID on new directories, or could restore S_ISGID that 
mode_strip_sgid() removed.

ACL preparation should not update inode->i_mode directly. Store the 
resulting mode in the prepared ACL state, then apply it through 
ocfs2_acl_set_mode() while using the existing creation transaction. 
Preserve the old operation order:

1. Store the default ACL for a directory.
2. Apply the prepared inode mode.
3. Store the access ACL when one is required.

Preserve the existing mode-update behavior and error propagation, 
including the behavior when the calculated mode is unchanged, unless 
there is a documented reason to change it.

Keep ocfs2_get_acl_nolock() and ocfs2_acl_set_mode() private to acl.c. 
Their locking and transaction requirements should not become part of a 
wider interface. Expose only the higher-level ACL preparation, release, 
and initialization operations needed by the callers.

Preserve the __posix_acl_create() result semantics exactly:

- A negative result must abort and propagate the error.
- A zero result means that no access ACL needs to be stored, so release 
and clear it.
- A positive result means that the access ACL must be retained and written.
- A default ACL must only be stored for directories.
- Symlinks must not have their mode filtered through the umask or ACL path.

Keep the accurate xattr reservation introduced by v2. Calculate space 
and external clusters independently for the prepared default and access 
ACLs. Do not read the parent ACL again from ocfs2_calc_xattr_init().

Use the same preparation helper in the non-preserve reflink path. Keep 
security initialization before ACL mode preparation, matching the 
previous behavior.

Remove parameters that become unused after this refactoring. In 
particular, ocfs2_init_acl() should no longer receive dir or dir_bh if 
it only consumes prepared ACL state, and ocfs2_calc_xattr_init() should 
not receive dir_bh if it no longer reads the parent xattr. Also remove 
headers that are no longer needed after moving current_umask() handling 
back into acl.c.

Please keep the patch focused on this OCFS2 lock-ordering problem. 
Update the commit message to describe the lock cycle and the 
preparation-before-transaction solution without including the full 
lockdep report. Keep the existing Fixes, Reported-by, Closes, Link, 
recipient, and base information. Do not invent a human Signed-off-by line.

Before sending the next version, please check at least the following cases:

- POSIX ACL support disabled.
- No parent default ACL.
- Equivalent and non-equivalent access ACLs.
- A directory with a default ACL.
- Large default and access ACLs using external xattr storage.
- A new directory under an S_ISGID parent retains inherited S_ISGID.
- An unprivileged non-directory does not regain an S_ISGID bit removed 
by mode_strip_sgid().
- The non-preserve reflink initialization path.
- The original lockdep reproducer.

Please also build fs/ocfs2/, run checkpatch, and confirm that the 
reproducer no longer reports the circular locking dependency.

On 7/15/2026 6:14 PM, syzbot wrote:
> A lockdep warning indicates a circular locking dependency between
> `&oi->ip_xattr_sem` and `&journal->j_trans_barrier`.
>
> The deadlock involves two code paths:
> Path 1 (setxattr): `ocfs2_xattr_set()` acquires `ip_xattr_sem` (write) and
> then starts a transaction, which acquires `j_trans_barrier` (read).
> Path 2 (mkdir/mknod): `ocfs2_mknod()` starts a transaction
> (`j_trans_barrier` read) and then calls `ocfs2_init_acl()`, which attempts
> to acquire `ip_xattr_sem` (read) on the parent directory to retrieve the
> default ACL.
>
> Because rw_semaphores are subject to writer priority, a pending writer on
> `j_trans_barrier` (e.g., the journal commit thread) can cause Path 1 to
> block, while Path 2 is blocked waiting for Path 1 to release
> `ip_xattr_sem`.
>
> ======================================================
> WARNING: possible circular locking dependency detected
> syz.0.17/6116 is trying to acquire lock:
> ffff88811dd5a2e8 (&oi->ip_xattr_sem){++++}-{4:4}, at:
> ocfs2_init_acl+0x2fd/0x7e0 fs/ocfs2/acl.c:367
>
> but task is already holding lock:
> ffff888119b518e0 (&journal->j_trans_barrier){.+.+}-{4:4}, at:
> ocfs2_start_trans+0x3ab/0x700 fs/ocfs2/journal.c:369
>
> which lock already depends on the new lock.
>
> Chain exists of:
>    &oi->ip_xattr_sem --> sb_internal#2 --> &journal->j_trans_barrier
>
>   Possible unsafe locking scenario:
>
>         CPU0                    CPU1
>         ----                    ----
>    rlock(&journal->j_trans_barrier);
>                                 lock(sb_internal#2);
>                                 lock(&journal->j_trans_barrier);
>    rlock(&oi->ip_xattr_sem);
>
>   *** DEADLOCK ***
>
> The patch fixes the lock ordering by precomputing the ACL state before
> starting the OCFS2 transaction, while preserving POSIX ACL storage
> semantics and the existing inode/security initialization order. By reading
> the parent directory's default ACL and preparing the new inode's ACLs
> outside the transaction, `ip_xattr_sem` is always acquired before
> `j_trans_barrier`.
>
> Update `ocfs2_calc_xattr_init()` and `ocfs2_init_acl()` to use these
> precomputed ACLs, removing internal `ip_xattr_sem` acquisition and
> redundant disk reads. In `ocfs2_mknod()` and
> `ocfs2_init_security_and_acl()`, the umask or default ACL is applied to
> `inode->i_mode` before the transaction begins. If `__posix_acl_create()`
> indicates an access ACL is not needed, it is released immediately.
>
> Fixes: 16c8d569f570 ("ocfs2/acl: use 'ip_xattr_sem' to protect getting extended attribute")
> Assisted-by: Gemini:gemini-3.1-pro-preview Gemini:gemini-3-flash-preview syzbot
> Reported-by: syzbot+4007ab5229e732466d9f@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=4007ab5229e732466d9f
> Link: https://syzkaller.appspot.com/ai_job?id=c2b46419-cb28-4c0c-b757-f315188c1ae8
> To: "Joel Becker" <jlbec@evilplan.org>
> To: "Joseph Qi" <joseph.qi@linux.alibaba.com>
> To: "Mark Fasheh" <mark@fasheh.com>
> To: <ocfs2-devel@lists.linux.dev>
> Cc: <linux-kernel@vger.kernel.org>
>
> ---
> v2:
> - Updated ocfs2_calc_xattr_init() to accept precomputed ACLs for more accurate credit and size calculation.
> - Modified ocfs2_mknod() and ocfs2_init_security_and_acl() to fetch and create ACLs before starting a transaction, resolving the lock ordering issue.
> - Ensured inode->i_mode is updated correctly during the pre-transaction ACL creation phase.
> - Added logic to release the access ACL object if it is not required for storage (i.e., matches the file mode).
>
> v1:
> https://lore.kernel.org/all/bbc14e84-b364-4f93-90e0-bfe42220b2b1@mail.kernel.org/T/
> ---
> diff --git a/fs/ocfs2/acl.c b/fs/ocfs2/acl.c
> index af1e2cedb..ec4b36004 100644
> --- a/fs/ocfs2/acl.c
> +++ b/fs/ocfs2/acl.c
> @@ -110,9 +110,8 @@ static void *ocfs2_acl_to_xattr(const struct posix_acl *acl, size_t *size)
>   	return ocfs2_acl;
>   }
>   
> -static struct posix_acl *ocfs2_get_acl_nolock(struct inode *inode,
> -					      int type,
> -					      struct buffer_head *di_bh)
> +struct posix_acl *ocfs2_get_acl_nolock(struct inode *inode, int type,
> +				       struct buffer_head *di_bh)
>   {
>   	int name_index;
>   	char *value = NULL;
> @@ -156,8 +155,8 @@ static struct posix_acl *ocfs2_get_acl_nolock(struct inode *inode,
>    * will not have di_bh or a journal handle to pass, in which case it
>    * will create it's own.
>    */
> -static int ocfs2_acl_set_mode(struct inode *inode, struct buffer_head *di_bh,
> -			      handle_t *handle, umode_t new_mode)
> +int ocfs2_acl_set_mode(struct inode *inode, struct buffer_head *di_bh,
> +		       handle_t *handle, umode_t new_mode)
>   {
>   	int ret, commit_handle = 0;
>   	struct ocfs2_dinode *di;
> @@ -349,63 +348,33 @@ int ocfs2_acl_chmod(struct inode *inode, struct buffer_head *bh)
>    * Initialize the ACLs of a new inode. If parent directory has default ACL,
>    * then clone to new inode. Called from ocfs2_mknod.
>    */
> -int ocfs2_init_acl(handle_t *handle,
> -		   struct inode *inode,
> -		   struct inode *dir,
> -		   struct buffer_head *di_bh,
> -		   struct buffer_head *dir_bh,
> +int ocfs2_init_acl(handle_t *handle, struct inode *inode, struct inode *dir,
> +		   struct buffer_head *di_bh, struct buffer_head *dir_bh,
>   		   struct ocfs2_alloc_context *meta_ac,
> -		   struct ocfs2_alloc_context *data_ac)
> +		   struct ocfs2_alloc_context *data_ac,
> +		   struct posix_acl *default_acl, struct posix_acl *acl)
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
> -		}
> -		if (!acl) {
> -			mode = inode->i_mode & ~current_umask();
> -			ret = ocfs2_acl_set_mode(inode, di_bh, handle, mode);
> -			if (ret) {
> -				mlog_errno(ret);
> -				goto cleanup;
> -			}
> -		}
> -	}
> -	if ((osb->s_mount_opt & OCFS2_MOUNT_POSIX_ACL) && acl) {
> -		if (S_ISDIR(inode->i_mode)) {
> +	int ret = 0;
> +
> +	if (S_ISLNK(inode->i_mode))
> +		return 0;
> +
> +	if (osb->s_mount_opt & OCFS2_MOUNT_POSIX_ACL) {
> +		if (S_ISDIR(inode->i_mode) && default_acl) {
>   			ret = ocfs2_set_acl(handle, inode, di_bh,
> -					    ACL_TYPE_DEFAULT, acl,
> +					    ACL_TYPE_DEFAULT, default_acl,
>   					    meta_ac, data_ac);
>   			if (ret)
> -				goto cleanup;
> -		}
> -		mode = inode->i_mode;
> -		ret = __posix_acl_create(&acl, GFP_NOFS, &mode);
> -		if (ret < 0)
> -			return ret;
> -
> -		ret2 = ocfs2_acl_set_mode(inode, di_bh, handle, mode);
> -		if (ret2) {
> -			mlog_errno(ret2);
> -			ret = ret2;
> -			goto cleanup;
> +				return ret;
>   		}
> -		if (ret > 0) {
> +
> +		if (acl) {
>   			ret = ocfs2_set_acl(handle, inode,
>   					    di_bh, ACL_TYPE_ACCESS,
>   					    acl, meta_ac, data_ac);
>   		}
>   	}
> -cleanup:
> -	posix_acl_release(acl);
> +
>   	return ret;
>   }
> diff --git a/fs/ocfs2/acl.h b/fs/ocfs2/acl.h
> index 667c6f03f..786b4d32b 100644
> --- a/fs/ocfs2/acl.h
> +++ b/fs/ocfs2/acl.h
> @@ -23,6 +23,11 @@ extern int ocfs2_acl_chmod(struct inode *, struct buffer_head *);
>   extern int ocfs2_init_acl(handle_t *, struct inode *, struct inode *,
>   			  struct buffer_head *, struct buffer_head *,
>   			  struct ocfs2_alloc_context *,
> -			  struct ocfs2_alloc_context *);
> +			  struct ocfs2_alloc_context *, struct posix_acl *,
> +			  struct posix_acl *);
> +struct posix_acl *ocfs2_get_acl_nolock(struct inode *inode, int type,
> +				       struct buffer_head *di_bh);
> +int ocfs2_acl_set_mode(struct inode *inode, struct buffer_head *di_bh,
> +		       handle_t *handle, umode_t new_mode);
>   
>   #endif /* OCFS2_ACL_H */
> diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
> index 1277666c7..30b945ba9 100644
> --- a/fs/ocfs2/namei.c
> +++ b/fs/ocfs2/namei.c
> @@ -27,6 +27,7 @@
>   #include <linux/highmem.h>
>   #include <linux/quotaops.h>
>   #include <linux/iversion.h>
> +#include <linux/fs_struct.h>
>   
>   #include <cluster/masklog.h>
>   
> @@ -256,6 +257,7 @@ static int ocfs2_mknod(struct mnt_idmap *idmap,
>   	sigset_t oldset;
>   	int did_block_signals = 0;
>   	struct ocfs2_dentry_lock *dl = NULL;
> +	struct posix_acl *default_acl = NULL, *acl = NULL;
>   
>   	trace_ocfs2_mknod(dir, dentry, dentry->d_name.len, dentry->d_name.name,
>   			  (unsigned long long)OCFS2_I(dir)->ip_blkno,
> @@ -330,10 +332,41 @@ static int ocfs2_mknod(struct mnt_idmap *idmap,
>   		}
>   	}
>   
> +	if (osb->s_mount_opt & OCFS2_MOUNT_POSIX_ACL) {
> +		down_read(&OCFS2_I(dir)->ip_xattr_sem);
> +		default_acl = ocfs2_get_acl_nolock(dir, ACL_TYPE_DEFAULT,
> +						   parent_fe_bh);
> +		up_read(&OCFS2_I(dir)->ip_xattr_sem);
> +		if (IS_ERR(default_acl)) {
> +			status = PTR_ERR(default_acl);
> +			default_acl = NULL;
> +			goto leave;
> +		}
> +		if (default_acl) {
> +			acl = posix_acl_dup(default_acl);
> +			if (!acl) {
> +				status = -ENOMEM;
> +				goto leave;
> +			}
> +			status = __posix_acl_create(&acl, GFP_NOFS,
> +						    &inode->i_mode);
> +			if (status < 0)
> +				goto leave;
> +			if (status == 0) {
> +				posix_acl_release(acl);
> +				acl = NULL;
> +			}
> +		} else {
> +			inode->i_mode &= ~current_umask();
> +		}
> +	} else {
> +		inode->i_mode &= ~current_umask();
> +	}
> +
>   	/* calculate meta data/clusters for setting security and acl xattr */
> -	status = ocfs2_calc_xattr_init(dir, parent_fe_bh, mode,
> -				       &si, &want_clusters,
> -				       &xattr_credits, &want_meta);
> +	status = ocfs2_calc_xattr_init(dir, parent_fe_bh, mode, &si,
> +				       &want_clusters, &xattr_credits,
> +				       &want_meta, default_acl, acl);
>   	if (status < 0) {
>   		mlog_errno(status);
>   		goto leave;
> @@ -412,7 +445,7 @@ static int ocfs2_mknod(struct mnt_idmap *idmap,
>   	}
>   
>   	status = ocfs2_init_acl(handle, inode, dir, new_fe_bh, parent_fe_bh,
> -			 meta_ac, data_ac);
> +				meta_ac, data_ac, default_acl, acl);
>   
>   	if (status < 0) {
>   		mlog_errno(status);
> @@ -477,6 +510,9 @@ static int ocfs2_mknod(struct mnt_idmap *idmap,
>   	brelse(parent_fe_bh);
>   	kfree(si.value);
>   
> +	posix_acl_release(default_acl);
> +	posix_acl_release(acl);
> +
>   	ocfs2_free_dir_lookup_result(&lookup);
>   
>   	if (inode_ac)
> diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
> index fcddd3c13..3b7d2aea7 100644
> --- a/fs/ocfs2/xattr.c
> +++ b/fs/ocfs2/xattr.c
> @@ -26,6 +26,7 @@
>   #include <linux/module.h>
>   #include <linux/string.h>
>   #include <linux/security.h>
> +#include <linux/fs_struct.h>
>   
>   #include <cluster/masklog.h>
>   
> @@ -611,13 +612,11 @@ int ocfs2_calc_security_init(struct inode *dir,
>   	return ret;
>   }
>   
> -int ocfs2_calc_xattr_init(struct inode *dir,
> -			  struct buffer_head *dir_bh,
> -			  umode_t mode,
> -			  struct ocfs2_security_xattr_info *si,
> -			  int *want_clusters,
> -			  int *xattr_credits,
> -			  int *want_meta)
> +int ocfs2_calc_xattr_init(struct inode *dir, struct buffer_head *dir_bh,
> +			  umode_t mode, struct ocfs2_security_xattr_info *si,
> +			  int *want_clusters, int *xattr_credits,
> +			  int *want_meta, struct posix_acl *default_acl,
> +			  struct posix_acl *acl)
>   {
>   	int ret = 0;
>   	struct ocfs2_super *osb = OCFS2_SB(dir->i_sb);
> @@ -628,19 +627,14 @@ int ocfs2_calc_xattr_init(struct inode *dir,
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
> +		if (default_acl && S_ISDIR(mode)) {
> +			acl_len = default_acl->a_count *
> +				  sizeof(struct ocfs2_acl_entry);
> +			a_size += ocfs2_xattr_entry_real_size(0, acl_len);
> +		}
> +		if (acl) {
> +			acl_len = acl->a_count * sizeof(struct ocfs2_acl_entry);
> +			a_size += ocfs2_xattr_entry_real_size(0, acl_len);
>   		}
>   	}
>   
> @@ -683,14 +677,28 @@ int ocfs2_calc_xattr_init(struct inode *dir,
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
> +		if (default_acl && S_ISDIR(mode)) {
> +			acl_len = default_acl->a_count *
> +				  sizeof(struct ocfs2_acl_entry);
> +			if (acl_len > OCFS2_XATTR_INLINE_SIZE) {
> +				new_clusters = ocfs2_clusters_for_bytes(
> +					dir->i_sb, acl_len);
> +				*xattr_credits += ocfs2_clusters_to_blocks(
> +					dir->i_sb, new_clusters);
> +				*want_clusters += new_clusters;
> +			}
> +		}
> +		if (acl) {
> +			acl_len = acl->a_count * sizeof(struct ocfs2_acl_entry);
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
> @@ -7257,6 +7265,8 @@ int ocfs2_init_security_and_acl(struct inode *dir,
>   {
>   	int ret = 0;
>   	struct buffer_head *dir_bh = NULL;
> +	struct posix_acl *default_acl = NULL, *acl = NULL;
> +	umode_t mode = inode->i_mode;
>   
>   	ret = ocfs2_init_security_get(inode, dir, qstr, NULL);
>   	if (ret) {
> @@ -7269,12 +7279,55 @@ int ocfs2_init_security_and_acl(struct inode *dir,
>   		mlog_errno(ret);
>   		goto leave;
>   	}
> -	ret = ocfs2_init_acl(NULL, inode, dir, NULL, dir_bh, NULL, NULL);
> +
> +	if (OCFS2_SB(dir->i_sb)->s_mount_opt & OCFS2_MOUNT_POSIX_ACL) {
> +		down_read(&OCFS2_I(dir)->ip_xattr_sem);
> +		default_acl =
> +			ocfs2_get_acl_nolock(dir, ACL_TYPE_DEFAULT, dir_bh);
> +		up_read(&OCFS2_I(dir)->ip_xattr_sem);
> +		if (IS_ERR(default_acl)) {
> +			ret = PTR_ERR(default_acl);
> +			default_acl = NULL;
> +			goto unlock;
> +		}
> +		if (default_acl) {
> +			acl = posix_acl_dup(default_acl);
> +			if (!acl) {
> +				ret = -ENOMEM;
> +				goto unlock;
> +			}
> +			ret = __posix_acl_create(&acl, GFP_NOFS, &mode);
> +			if (ret < 0)
> +				goto unlock;
> +			if (ret == 0) {
> +				posix_acl_release(acl);
> +				acl = NULL;
> +			}
> +		} else {
> +			mode &= ~current_umask();
> +		}
> +	} else {
> +		mode &= ~current_umask();
> +	}
> +
> +	if (mode != inode->i_mode) {
> +		ret = ocfs2_acl_set_mode(inode, NULL, NULL, mode);
> +		if (ret) {
> +			mlog_errno(ret);
> +			goto unlock;
> +		}
> +	}
> +
> +	ret = ocfs2_init_acl(NULL, inode, dir, NULL, dir_bh, NULL, NULL,
> +			     default_acl, acl);
>   	if (ret)
>   		mlog_errno(ret);
>   
> +unlock:
>   	ocfs2_inode_unlock(dir, 0);
>   	brelse(dir_bh);
> +	posix_acl_release(default_acl);
> +	posix_acl_release(acl);
>   leave:
>   	return ret;
>   }
> diff --git a/fs/ocfs2/xattr.h b/fs/ocfs2/xattr.h
> index 65e9aa743..34f8904de 100644
> --- a/fs/ocfs2/xattr.h
> +++ b/fs/ocfs2/xattr.h
> @@ -55,9 +55,9 @@ int ocfs2_init_security_set(handle_t *, struct inode *,
>   int ocfs2_calc_security_init(struct inode *,
>   			     struct ocfs2_security_xattr_info *,
>   			     int *, int *, struct ocfs2_alloc_context **);
> -int ocfs2_calc_xattr_init(struct inode *, struct buffer_head *,
> -			  umode_t, struct ocfs2_security_xattr_info *,
> -			  int *, int *, int *);
> +int ocfs2_calc_xattr_init(struct inode *, struct buffer_head *, umode_t,
> +			  struct ocfs2_security_xattr_info *, int *, int *,
> +			  int *, struct posix_acl *, struct posix_acl *);
>   
>   /*
>    * xattrs can live inside an inode, as part of an external xattr block,
>
>
> base-commit: dc59e4fea9d83f03bad6bddf3fa2e52491777482
