Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D440437D12E
	for <syzbot@lists.linux.dev>; Thu, 15 Oct 2026 07:38:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=100.103.45.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792049884; cv=pass; b=jYCs3FdLnktFmSwpgWxfg4DbHbx7Dz+2OzXtzGaVpDENLAB3YKQiUcWBPCwYW4enedCp7p/N/BJ3hId+G7Zs38vawpK02GRjgxGhNuOXj0Pi7rHEjap0MLlAojxQNWmTNgnhqUQF+WnZ4wwHxrWT3st5JwVZCV4OFW+xrZy7+gs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792049884; c=relaxed/simple;
	bh=d6DkC92zMO+UnA43I1S28puVWW0ym74YgF7oXD4uyug=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VbCxxXDzousdlIpwGn5zv3m+JtV54hupyKdZ9H38phBv04g2LmvNfNtzU/U1Esg61UlgK3OepsjEZIBJa8qP8rfl0Rvb6ERg+2PEZp2xnBJwogr87pCu48HHlcWky3gdwvBVU9M++z4E9KEZbrlJvU2bn2uEavd67FAxE6xC3AA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=poczta.fm header.i=@poczta.fm header.b=CPzKiv/L; arc=pass smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=poczta.fm header.i=@poczta.fm header.b="CPzKiv/L"
Received: by smtp.kernel.org (Postfix)
	id 50D2A1F000C5; Thu, 15 Oct 2026 07:38:00 +0000 (UTC)
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=217.74.67.49
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1792049880;
	b=JYJKxn2Ei044t2bH5QBdGhWp1nYKKaKPhL6GWJpsOSvXLVO6CZmzIl2SnTBpsxYdX01R
	 HzB7AwZzyCyQy8FJRfLA0W8Z6712FC9Zz+OBqH9NTc8grGob5ki6ydozUR/7nlsmHOxIA
	 LimK0GeamN6AGElq6N71R5XYD7xzJFynmU+7mLLOhAEBsJWTldNZqEj9dRjyjA/Bi3lVZ
	 vYCEZW1Scr5kgwDR8xcigwh+/lOW2L/PrNuEnrvulh+wJ0/Iz6Y4wAxSvG3rnjuQMbyWw
	 x7/HSREfWhbkoboMJ50q/fxg1dJ9UM5p55zKmYNDbdQD60GqMJTvPCGVa+Yd0qe101g==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1792049880;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To:DKIM-Signature;
	bh=moe5XAHKdHePJ1NO9H704caWkaA/3oWAgzw2zfqjEJ8=;
	b=0vD2bWczyvojtdT1WZcjrKthWjkSY7wwG+vGegDTT4mZf4zMtO4cYtRftIBMXlIMzm2i
	 lqqt2wEHTa496Y//A13w3UQz4vzp9Pgu9iQ33Nu21rryZPU4/5xSuB53Joc3ScqJrVm7e
	 +N8Z83vLeupTCglESofLDQ4LB0oBPPXKbhcz8UEiOxwi/gx23gH6xirmY6oCp2tLr+wlT
	 QQCug7luV5CCfXUlVYAEULd9IjF/RzMFHhZpBB1dh4Bs9StDHJYfI/hUPCowJ/Gh7So8X
	 Lx6t5uh7Z9lis2D3vahPneReoXQlNpTo6KgBQndUYYl54JzPZgheMtLHzGih+ttQJtw==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	dkim=pass header.d=poczta.fm header.i=@poczta.fm header.a=rsa-sha256 header.s=dk header.b="CPzKiv/L";
	dmarc=pass header.from=poczta.fm;
	spf=pass smtp.mailfrom=poczta.fm;
	arc=none smtp.remote-ip=217.74.67.49
Received: from smtpo49.interia.pl (smtpo49.interia.pl [217.74.67.49])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id F17251F000C4
	for <syzbot@kernel.org>; Thu, 15 Oct 2026 07:37:57 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=poczta.fm header.i=@poczta.fm header.a=rsa-sha256 header.s=dk header.b=CPzKiv/L
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.kernel.org F17251F000C4
Authentication-Results: smtp.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=poczta.fm
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=poczta.fm
Received: from nr200 (unknown [80.68.231.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by poczta.interia.pl (INTERIA.PL) with ESMTPSA;
	Thu, 15 Oct 2026 09:37:54 +0200 (CEST)
Date: Thu, 15 Oct 2026 09:37:51 +0200
From: Slawomir Stepien <sst@poczta.fm>
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Subject: Re: [PATCH RFC] usb: gadget: f_tcm: defer TPG assignment to fix
 circular locking
Message-ID: <atCCz_-iwbVFC5w_@nr200>
References: <b1646de9-ae67-4626-89f3-76a04e181581@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b1646de9-ae67-4626-89f3-76a04e181581@mail.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=poczta.fm; s=dk;
	t=1792049875; bh=moe5XAHKdHePJ1NO9H704caWkaA/3oWAgzw2zfqjEJ8=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	b=CPzKiv/LPAdiHt68ei0+aiMqh5Z0iveB1felsMrd01J7EwUe6IPslW6tT3Vfh89jc
	 Q+cXGOYJP3T6fBJzsR7siA2ilTQMomgI7FQVaVabF/8ZCPKuqH5GOWYPnnfy8R/5LX
	 no34dYfGeq5+aRQ80SeAnTXmvUuuMB6JZ4h2cZZo=

On paź 06, 2026 00:20, 'syzbot' via syzkaller-upstream-moderation wrote:
> A circular locking dependency exists between tpg_instances_lock, the
> configfs directory inode_lock, and the gadget info lock gi->lock when
> configuring TCM gadget functions through configfs.
> 
>   WARNING: possible circular locking dependency detected
>   ======================================================
>   task is trying to acquire lock:
>   ffffffff8f24ae58 (tpg_instances_lock){+.+.}-{4:4}, at:
>   tcm_alloc+0x21/0x2f0 drivers/usb/gadget/function/f_tcm.c:2734
> 
>   but task is already holding lock:
>   ffff888192990388 (&gi->lock){+.+.}-{4:4}, at:
>   config_usb_cfg_link+0x59/0x260 drivers/usb/gadget/configfs.c:439
> 
>   which lock already depends on the new lock.
> 
>   the existing dependency chain (in reverse order) is:
> 
>    -> #2 (&gi->lock){+.+.}-{4:4}:
>          config_usb_cfg_link+0x59/0x260 drivers/usb/gadget/configfs.c:439
>          configfs_symlink+0x74e/0x11d0 fs/configfs/symlink.c:211
>          vfs_symlink+0x18b/0x330 fs/namei.c:5794
> 
>    -> #1 (&sb->s_type->i_mutex_key#24){+.+.}-{4:4}:
>          inode_lock include/linux/fs.h:1024 [inline]
>          configfs_depend_item_unlocked+0x153/0x420 fs/configfs/dir.c:1268
>          usbg_make_tpg+0x1e0/0x550 drivers/usb/gadget/function/f_tcm.c:1692
>          target_fabric_make_tpg+0xa8/0x6d0
>          drivers/target/target_core_fabric_configfs.c:947
>          configfs_mkdir+0x4f6/0x9e0 fs/configfs/dir.c:1369
> 
>    -> #0 (tpg_instances_lock){+.+.}-{4:4}:
>          tcm_alloc+0x21/0x2f0 drivers/usb/gadget/function/f_tcm.c:2734
>          usb_get_function+0x63/0xb0 drivers/usb/gadget/functions.c:61
>          config_usb_cfg_link+0x148/0x260 drivers/usb/gadget/configfs.c:469
>          configfs_symlink+0x74e/0x11d0 fs/configfs/symlink.c:211
> 
> The deadlock arises from two conflicting lock acquisition paths across
> configfs:
> 
> 1. When creating a Target Portal Group (TPG) directory in configfs (e.g.
> target/usb_gadget/.../tpgt_1), VFS takes the directory inode_lock. In
> usbg_make_tpg(), tpg_instances_lock is acquired. While holding
> tpg_instances_lock, usbg_make_tpg() calls configfs_depend_item_unlocked()
> to depend on the gadget function item, which acquires the configfs root
> directory inode_lock across subsystems (tpg_instances_lock -> inode_lock).
> 
> 2. When linking the TCM function to a gadget configuration (e.g. symlink
> functions/tcm.usb0 configs/c.1/tcm.usb0), VFS acquires the configuration
> directory inode_lock. The callback configfs_symlink() calls
> config_usb_cfg_link(), acquiring gi->lock. While holding gi->lock,
> config_usb_cfg_link() calls usb_get_function(), invoking tcm_alloc(). In
> tcm_alloc(), tpg_instances_lock was acquired to search the tpg_instances
> array and set fu->tpg (inode_lock -> gi->lock -> tpg_instances_lock).
> 
> In addition to the deadlock, initializing fu->tpg in tcm_alloc() introduces
> a race condition. If the user symlinks the function into a gadget
> configuration before creating the TPG directory, tpg_instances[i].tpg is
> NULL, causing tcm_alloc() to leave fu->tpg as NULL. When the TPG is later
> created and enabled, tcm_bind() succeeds because opts->can_attach is true,
> but fu->tpg remains NULL. When USB transfers are subsequently processed,
> dereferencing fu->tpg results in a NULL pointer dereference crash.
> Furthermore, removing an enabled TPG via rmdir calls usbg_drop_tpg()
> directly without detaching, leaving opts->can_attach set to true and
> permitting subsequent binds against a destroyed TPG.
> 
> Fix these issues by storing the TPG pointer in struct f_tcm_opts, removing
> the tpg_instances_lock acquisition from tcm_alloc(), and deferring fu->tpg
> assignment until tcm_bind(). The function instance is already valid for the
> item's lifetime, making the search in tcm_alloc() redundant; removing it
> breaks the circular lock dependency cycle. In tcm_bind(), fu->tpg is
> assigned under opts->dep_lock after validating that both opts->can_attach
> and opts->tpg are valid. In usbg_make_tpg(), opts->tpg is set under
> opts->dep_lock. In usbg_drop_tpg(), both opts->can_attach is reset to false
> and opts->tpg is cleared under opts->dep_lock, ensuring consistent state
> and preventing NULL pointer dereferences.
> 
> Fixes: 4bb8548df632 ("usb: gadget: f_tcm: add configfs support")
> Assisted-by: Gemini:gemini-3.8-flash Gemini:gemini-3.1-pro-preview syzbot
> Reported-by: syzbot+2799146a53c356f8017d@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=2799146a53c356f8017d
> Link: https://syzkaller.appspot.com/ai_job?id=a5b86f29-4d77-48c4-90c7-2467ea27765f
> To: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
> To: <linux-usb@vger.kernel.org>
> To: "Andrzej Pietrasiewicz" <andrzej.p@samsung.com>
> Cc: "Jiasheng Jiang" <jiashengjiangcool@gmail.com>
> Cc: <linux-kernel@vger.kernel.org>
> Cc: "Yun Zhou" <yun.zhou@windriver.com>
> Cc: "Cen Zhang" <zzzccc427@gmail.com>
> 
> ---
> diff --git a/drivers/usb/gadget/function/f_tcm.c b/drivers/usb/gadget/function/f_tcm.c
> index 9e6d4f399..c7bdedd46 100644
> --- a/drivers/usb/gadget/function/f_tcm.c
> +++ b/drivers/usb/gadget/function/f_tcm.c
> @@ -1720,6 +1720,9 @@ static struct se_portal_group *usbg_make_tpg(struct se_wwn *wwn,
>  
>  	tpg_instances[i].tpg = tpg;
>  	tpg->fi = tpg_instances[i].func_inst;
> +	mutex_lock(&opts->dep_lock);
> +	opts->tpg = tpg;
> +	mutex_unlock(&opts->dep_lock);
>  	mutex_unlock(&tpg_instances_lock);
>  	return &tpg->se_tpg;
>  
> @@ -1760,6 +1763,8 @@ static void usbg_drop_tpg(struct se_portal_group *se_tpg)
>  		opts = container_of(tpg_instances[i].func_inst,
>  			struct f_tcm_opts, func_inst);
>  		mutex_lock(&opts->dep_lock);
> +		opts->can_attach = false;
> +		opts->tpg = NULL;
>  		if (opts->has_dep)
>  			module_put(opts->dependent);
>  		else
> @@ -2300,10 +2305,11 @@ static int tcm_bind(struct usb_configuration *c, struct usb_function *f)
>  	opts = container_of(f->fi, struct f_tcm_opts, func_inst);
>  
>  	mutex_lock(&opts->dep_lock);
> -	if (!opts->can_attach) {
> +	if (!opts->can_attach || !opts->tpg) {
>  		mutex_unlock(&opts->dep_lock);
>  		return -ENODEV;
>  	}
> +	fu->tpg = opts->tpg;
>  	mutex_unlock(&opts->dep_lock);
>  	us = usb_gstrings_attach(c->cdev, tcm_strings,
>  		ARRAY_SIZE(tcm_us_strings));
> @@ -2729,22 +2735,10 @@ static void tcm_unbind(struct usb_configuration *c, struct usb_function *f)
>  static struct usb_function *tcm_alloc(struct usb_function_instance *fi)
>  {
>  	struct f_uas *fu;
> -	unsigned i;
> -
> -	mutex_lock(&tpg_instances_lock);
> -	for (i = 0; i < TPG_INSTANCES; ++i)
> -		if (tpg_instances[i].func_inst == fi)
> -			break;
> -	if (i == TPG_INSTANCES) {
> -		mutex_unlock(&tpg_instances_lock);
> -		return ERR_PTR(-ENODEV);
> -	}
>  
>  	fu = kzalloc_obj(*fu);
> -	if (!fu) {
> -		mutex_unlock(&tpg_instances_lock);
> +	if (!fu)
>  		return ERR_PTR(-ENOMEM);
> -	}
>  
>  	fu->function.name = "Target Function";
>  	fu->function.bind = tcm_bind;
> @@ -2754,12 +2748,10 @@ static struct usb_function *tcm_alloc(struct usb_function_instance *fi)
>  	fu->function.setup = tcm_setup;
>  	fu->function.disable = tcm_disable;
>  	fu->function.free_func = tcm_free;
> -	fu->tpg = tpg_instances[i].tpg;
>  	INIT_WORK(&fu->delayed_set_alt, tcm_delayed_set_alt);
>  	spin_lock_init(&fu->delayed_set_alt_lock);
>  
>  	hash_init(fu->stream_hash);
> -	mutex_unlock(&tpg_instances_lock);
>  
>  	return &fu->function;
>  }
> diff --git a/drivers/usb/gadget/function/u_tcm.h b/drivers/usb/gadget/function/u_tcm.h
> index 2cd15d9a1..1376b6ebc 100644
> --- a/drivers/usb/gadget/function/u_tcm.h
> +++ b/drivers/usb/gadget/function/u_tcm.h
> @@ -15,6 +15,8 @@
>  
>  #include <linux/usb/composite.h>
>  
> +struct usbg_tpg;
> +
>  /**
>   * @dependent: optional dependent module. Meant for legacy gadget.
>   * If non-null its refcount will be increased when a tpg is created and
> @@ -23,10 +25,12 @@
>   * @ready: true if the dependent module information is set.
>   * @can_attach: true a function can be bound to gadget
>   * @has_dep: true if there is a dependent module
> + * @tpg: target portal group

This new comment is lacking a bit in content. Explain a bit more what @tpg member holds in this
structure.

>   *
>   */
>  struct f_tcm_opts {
>  	struct usb_function_instance	func_inst;
> +	struct usbg_tpg			*tpg;
>  	struct module			*dependent;
>  	struct mutex			dep_lock;
>  	bool				ready;
> 
> 
> base-commit: a90ee4305c4a5df72c11b31dacfdc76e00fcf78a

-- 
Slawomir Stepien
