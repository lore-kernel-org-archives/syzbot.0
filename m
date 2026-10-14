Received: from smtpo75.interia.pl (smtpo75.interia.pl [217.74.67.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0343A457E4A
	for <syzbot@lists.linux.dev>; Wed, 14 Oct 2026 09:45:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.74.67.75
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791971142; cv=none; b=cj1RpyzMHAjzElUkuAvqVBa4Iobkab0is0v6AxSC9fyO60U+lw8jFr+DvbmOo+sRawlDIY0DUGAB4CFr9jydXXFhMzq/SEFdBy8tf/t+jDF3BezjSU1d9OBXg8Rpey5K8Z1yW5CZwxeRiKqBfxC5wGLFld0l9o6AZj3l4C9vJA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791971142; c=relaxed/simple;
	bh=RctnjDYUiBxX3JYFzEJ/x8el5rBqac88XxGAAYaxkVc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lq8q6htdhXqRiDs+DTfb5vVZ3eIv2qEmCzQ+baL5GPJRuHqf6krsw1c9oDeSkhXbfFIaDspWSrV2Bo7YghU3LKI3bHgc6JnFN2V1x5cvuNP5uXRVo6/TdumcMP4UAMDky0VdmtfIsFMhUpZtBiTmq8ZlohVVbHJyThNX8423SXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=poczta.fm; spf=pass smtp.mailfrom=poczta.fm; dkim=pass (1024-bit key) header.d=poczta.fm header.i=@poczta.fm header.b=o6kflu4U; arc=none smtp.client-ip=217.74.67.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=poczta.fm
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=poczta.fm
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=poczta.fm header.i=@poczta.fm header.b="o6kflu4U"
Received: from nr200 (unknown [80.68.231.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by poczta.interia.pl (INTERIA.PL) with ESMTPSA;
	Wed, 14 Oct 2026 11:45:29 +0200 (CEST)
Date: Wed, 14 Oct 2026 11:45:25 +0200
From: Slawomir Stepien <sst@poczta.fm>
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Subject: Re: [PATCH RFC] usb: gadget: f_tcm: fix circular lock dependency in
 usbg_make_tpg()
Message-ID: <as9PNXza2pjH7yGd@nr200>
References: <77d2115f-8e36-403c-bf08-6810b1c6900c@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <77d2115f-8e36-403c-bf08-6810b1c6900c@mail.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=poczta.fm; s=dk;
	t=1791971130; bh=E9CWpDdQ2z6L91yR/lxB6xxvTfdLspoS+KSknq/FL3I=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	b=o6kflu4UPMYb7Qwea/W9am21BSJ2HZKucxWkCgdFZkBBdecX7gpOEm/MdTNr69FdM
	 HyUmwIBh/DxiZGeY27QN2YAt3/84rjW+yVepJD93HIBEkbuCD7lmvWeNfjKXohUzIN
	 pwkMFfGlMI/KDkhMeKOWikh0rFN5cf/Yo1z7dUrg=

On paź 13, 2026 01:38, 'syzbot' via syzkaller-upstream-moderation wrote:
> A circular locking dependency is detected by lockdep between the VFS
> inode_lock of configfs directories (&sb->s_type->i_mutex_key#24) and
> tpg_instances_lock during Target Portal Group (TPG) creation in
> usbg_make_tpg():
> 
> WARNING: possible circular locking dependency detected
> ...
> task is trying to acquire lock:
> ffffffff8fc6d8c8 (gadget_subsys.su_mutex){+.+.}-{4:4}, at:
> uvcg_extension_allow_link+0x6c/0x1f0
> drivers/usb/gadget/function/uvc_configfs.c:1195
> 
> but task is already holding lock:
> ffff8881f3ef6280 (&sb->s_type->i_mutex_key#24){+.+.}-{4:4}, at: inode_lock
> include/linux/fs.h:1024 [inline]
> ffff8881f3ef6280 (&sb->s_type->i_mutex_key#24){+.+.}-{4:4}, at:
> configfs_symlink+0x4d0/0x11d0 fs/configfs/symlink.c:201
> 
> which lock already depends on the new lock.
> 
> the existing dependency chain (in reverse order) is:
> 
>  -> #3 (&sb->s_type->i_mutex_key#24){+.+.}-{4:4}:
>         inode_lock include/linux/fs.h:1024 [inline]
>         configfs_depend_item_unlocked+0x153/0x420 fs/configfs/dir.c:1268
>         usbg_make_tpg+0x1e0/0x550 drivers/usb/gadget/function/f_tcm.c:1692
>         target_fabric_make_tpg+0xa8/0x6d0
>         drivers/target/target_core_fabric_configfs.c:947
>         configfs_mkdir+0x4f6/0x9e0 fs/configfs/dir.c:1369
> 
>  -> #2 (tpg_instances_lock){+.+.}-{4:4}:
>         tcm_alloc_inst+0x65/0x1a0 drivers/usb/gadget/function/f_tcm.c:2687
>         try_get_usb_function_instance drivers/usb/gadget/functions.c:28
>         [inline]
>         usb_get_function_instance+0xe3/0x2f0
>         drivers/usb/gadget/functions.c:44
>         function_make+0x127/0x360 drivers/usb/gadget/configfs.c:626
>         configfs_mkdir+0x4f6/0x9e0 fs/configfs/dir.c:1369
> 
>  -> #1 (func_lock){+.+.}-{4:4}:
>         try_get_usb_function_instance drivers/usb/gadget/functions.c:18
>         [inline]
>         usb_get_function_instance+0x2e/0x2f0
>         drivers/usb/gadget/functions.c:44
>         function_make+0x127/0x360 drivers/usb/gadget/configfs.c:626
>         configfs_mkdir+0x4f6/0x9e0 fs/configfs/dir.c:1369
> 
>  -> #0 (gadget_subsys.su_mutex){+.+.}-{4:4}:
>         uvcg_extension_allow_link+0x6c/0x1f0
>         drivers/usb/gadget/function/uvc_configfs.c:1195
>         configfs_symlink+0x74e/0x11d0 fs/configfs/symlink.c:211
> 
> Chain exists of:
>   gadget_subsys.su_mutex --> tpg_instances_lock -->
>   &sb->s_type->i_mutex_key#24
> 
> The dependency chain arises because during gadget function instantiation
> (such as creating a tcm.usb0 function directory), the VFS layer acquires
> the parent directory inode_lock (&sb->s_type->i_mutex_key#24).
> configfs_mkdir() then acquires gadget_subsys.su_mutex and calls
> function_make(). This invokes usb_get_function_instance(), which acquires
> func_lock and calls tcm_alloc_inst(), which in turn acquires
> tpg_instances_lock. This establishes the locking order: inode_lock ->
> gadget_subsys.su_mutex -> func_lock -> tpg_instances_lock. Conversely, when
> creating a Target Portal Group (TPG) in the target subsystem,
> target_fabric_make_tpg() calls usbg_make_tpg(), which acquires
> tpg_instances_lock and then calls configfs_depend_item_unlocked(). Because
> the target configfs item belongs to a different subsystem (gadget_subsys),
> configfs_depend_item_unlocked() acquires the configfs root directory
> inode_lock. Since all configfs directories share the same inode_lock class
> in lockdep, this creates a circular dependency: inode_lock ->
> gadget_subsys.su_mutex -> func_lock -> tpg_instances_lock -> inode_lock.
> 
> To break this circular dependency, drop tpg_instances_lock around the call
> to configfs_depend_item_unlocked(). This unlock is strictly confined to the
> !opts->has_dep branch where configfs_depend_item_unlocked() is invoked,
> since the opts->has_dep path only calls try_module_get() and does not
> acquire configfs inode locks. Before dropping tpg_instances_lock, pin the
> item via config_item_get() to prevent concurrent release or removal. After
> configfs_depend_item_unlocked() completes, release the reference with
> config_item_put() before re-acquiring tpg_instances_lock so that an
> eventual cleanup cannot deadlock on tpg_instances_lock. Finally, once
> tpg_instances_lock is re-acquired, verify that the instance slot remains
> valid and unassigned (tpg_instances[i].func_inst == &opts->func_inst &&
> !tpg_instances[i].tpg); if another thread claimed or changed the slot while
> unlocked, unwind the dependency with configfs_undepend_item_unlocked() and
> return -EBUSY.
> 
> Fixes: 9dbf74f4022f ("usb: gadget: f_tcm: fix deadlock in usbg_make_tpg()")
> Assisted-by: Gemini:gemini-3.8-flash Gemini:gemini-3.1-pro-preview syzbot
> Reported-by: syzbot+b3410eb576b568216ae5@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=b3410eb576b568216ae5
> Link: https://syzkaller.appspot.com/ai_job?id=7da59cc9-b02a-4e8b-a07f-d2df215094c6
> To: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
> To: <linux-usb@vger.kernel.org>
> To: "Yun Zhou" <yun.zhou@windriver.com>
> Cc: "Jiasheng Jiang" <jiashengjiangcool@gmail.com>
> Cc: <linux-kernel@vger.kernel.org>
> Cc: "Cen Zhang" <zzzccc427@gmail.com>
> 
> ---
> diff --git a/drivers/usb/gadget/function/f_tcm.c b/drivers/usb/gadget/function/f_tcm.c
> index 9e6d4f399..e2399b4cc 100644
> --- a/drivers/usb/gadget/function/f_tcm.c
> +++ b/drivers/usb/gadget/function/f_tcm.c
> @@ -1655,6 +1655,7 @@ static struct se_portal_group *usbg_make_tpg(struct se_wwn *wwn,
>  {
>  	struct usbg_tport *tport = container_of(wwn, struct usbg_tport,
>  			tport_wwn);
> +	struct config_item *item;
>  	struct usbg_tpg *tpg;
>  	u16 tpgt;
>  	int ret;
> @@ -1682,18 +1683,29 @@ static struct se_portal_group *usbg_make_tpg(struct se_wwn *wwn,
>  		if (!try_module_get(opts->dependent))
>  			goto unlock_inst;
>  	} else {
> +		item = config_item_get(&opts->func_inst.group.cg_item);
> +		mutex_unlock(&tpg_instances_lock);
> +
>  		/*
>  		 * configfs_depend_item_unlocked() may acquire the configfs
>  		 * root inode lock when the target belongs to a different
> -		 * subsystem. Calling it under dep_lock would create a
> -		 * circular dependency:
> -		 *   dep_lock -> configfs inode lock -> su_mutex -> dep_lock
> +		 * subsystem. Calling it under tpg_instances_lock would create
> +		 * a circular dependency:
> +		 *   inode_lock -> su_mutex -> func_lock -> tpg_instances_lock -> inode_lock

Altering this comment in this way is a mistake in my view. Comment about the dep_lock should still
be visible - it is still valid.

If you want to comment about tpg_instances_lock add it before unlocking the lock above or rephrase
this comment block such that both locks are mentioned.

>  		 */
>  		ret = configfs_depend_item_unlocked(
>  			wwn->wwn_group.cg_subsys,
> -			&opts->func_inst.group.cg_item);
> +			item);
> +		config_item_put(item);
> +
> +		mutex_lock(&tpg_instances_lock);
>  		if (ret)
>  			goto unlock_inst;
> +		if (tpg_instances[i].func_inst != &opts->func_inst ||
> +		    tpg_instances[i].tpg) {
> +			ret = -EBUSY;
> +			goto unref_dep;
> +		}
>  	}
>  
>  	tpg = kzalloc_obj(struct usbg_tpg);
> 
> 
> base-commit: 24a19b953e2a3d0ea5a8c4951a0ab8f32720c907

-- 
Slawomir Stepien
