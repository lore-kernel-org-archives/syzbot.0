Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792487744;
	b=eK77+QkQ9fXBhYwkbpe9KrIXe/EnkwG8juBgEXIvhEp3AxB4NBwiJv2PzwRFlxXrQ3qO
	 CV9omfh73Mv7QXu1yMBd83lPJIPwqM333gL+tZGBYTbbw5CJrjXrrIDgIMLjORB6dsTJV
	 +S1rAEPTfLvzJWuXcB3fSw2qvcZamDWeUpvy5KfkBjhyom6spgQCepfGx1Lajq9eaDdoa
	 SmaA52YxBkxI/LqWlgXqFhoS6WnIgNcmrQpSfrTwGIHYe0EnNFzYepLSg5Ml0z/A+tJww
	 BLlBLt3T+UXIFMb0qOh0Up+rKObn2FQ9zF4mA6mGws2Fm1HvBwIyEOBgSXJfwJq8u6A==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792487744;
	h=Received:Delivered-To:Received:DMARC-Filter:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:Content-Transfer-Encoding:In-Reply-To:
	 DKIM-Signature;
	bh=Lx6BS2qc7eFv1NSrhWZBESIdu0s4cEF0hyli7vCfKdE=;
	b=ylRuqVe47CAxPjgEir2lJ7dK7VBFrGpqh+R3e1jXEV0Ol4+UDkoX/ZQhLVWV32HI8+uE
	 00sSgJob3PE7m2FE0KSzQI0630hJpD73hW+u4PiyL0VtzbEGDEQyTflpQq1cXdlXUxMQI
	 jrj4uCGUwpaVKw5s+7MOtFiRs83r5O/RBeckfs18sRCzBgxhkBhLO4QiRzSWrHfnb2wUb
	 iPzLrkdS7BjFR5qQjkhcXZRKN0vbP/peD2j1sVnps/Dw1MbzVLOU61s8lSFB4eNG+nLhb
	 flbewO0TULKXc79+xWCSfYEuFVuyZDhi9U7ebOfSf6lDreiHrrKK/8yftyMU/DUSaWg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=poczta.fm header.i=@poczta.fm header.a=rsa-sha256 header.s=dk header.b="mq+Umk/E";
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F4E7606A319
	for <syzbot@lists.linux.dev>; Tue, 20 Oct 2026 09:15:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=poczta.fm header.i=@poczta.fm header.a=rsa-sha256 header.s=dk header.b=mq+Umk/E
Received: by smtp.kernel.org (Postfix)
	id E87871F000C4; Tue, 20 Oct 2026 09:15:42 +0000 (UTC)
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=217.74.67.63
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1792487742;
	b=EYPgPf1Bnv8+hkvges/o5ORBF/tAV9A2egRcI4ySvwL+cL3My4/cJL9lw5fCkomHjnZJ
	 cmHAjc2VIbSrCFHZ2i5F7Ir9s2KaS7ED74RdOAEUeScKnWg/pxw/ik9v2JE2vO013simX
	 9YhwFgRGlrx0eYd9OxV0zhniBzoZna34LQgaDRkk7kE5Mxchs/wC3CMkxFi8mvKX201gP
	 nedl5A236mfcBLCLU1r4C7juaR6tRGVh713aCc75/p/IlaJYq4oYDpfyyP4BiW3EjWK9P
	 zjYkjwm9v2s60L51sb2rTaGzhbo8G9Soq0RdejTh1+NAWov79Q/SPXvVIkC1GBGJDXw==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1792487742;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To:DKIM-Signature;
	bh=Lx6BS2qc7eFv1NSrhWZBESIdu0s4cEF0hyli7vCfKdE=;
	b=xmYw+FaMCbc0dOFaHUI6XTs5H5kmu5hm2aqP1Y+Ss3DLFeX+cbSrdr3OGEw/hobjfQGK
	 n+w+65CuebcBeqZsVFpy97SXWvC0GxU9P6WgLqlZJEQiPzF56AiOpi18fNy/79mBE6xwt
	 rOVC5orqRRThcBwyXKQviJl/Gq0eY1X4liIoMdxoRA0j8fSsT5bDSGqtwLSv+xg6g2W3R
	 qNCeEzFdIO25b5KZoc3lq6EZkjXrGwTlXZIu+3BMadOLEANRRPEO7fz/e5T5uY2zX39cu
	 Hm/XC1Qm0JD+qwZzK3zRYFac8i3dfFVSOlyEw4REOL90uDVzwfwZ35/kXiEth02UFOw==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	dkim=pass header.d=poczta.fm header.i=@poczta.fm header.a=rsa-sha256 header.s=dk header.b="mq+Umk/E";
	dmarc=pass header.from=poczta.fm;
	spf=pass smtp.mailfrom=poczta.fm;
	arc=none smtp.remote-ip=217.74.67.63
Received: from smtpo63.interia.pl (smtpo63.interia.pl [217.74.67.63])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 58FA01F000C6
	for <syzbot@kernel.org>; Tue, 20 Oct 2026 09:15:40 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=poczta.fm header.i=@poczta.fm header.a=rsa-sha256 header.s=dk header.b=mq+Umk/E
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.kernel.org 58FA01F000C6
Authentication-Results: smtp.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=poczta.fm
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=poczta.fm
Received: from nr200 (unknown [80.68.231.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by poczta.interia.pl (INTERIA.PL) with ESMTPSA;
	Tue, 20 Oct 2026 11:15:36 +0200 (CEST)
Date: Tue, 20 Oct 2026 11:15:34 +0200
From: Slawomir Stepien <sst@poczta.fm>
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Subject: Re: [PATCH RFC v3] usb: gadget: f_tcm: fix circular lock dependency
 in usbg_make_tpg()
Message-ID: <atcxNsu1ziVNMJ97@nr200>
References: <f0f928b0-ce5b-4a70-aa39-e3f535ad9139@mail.kernel.org>
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Post: <mailto:syzbot@lists.linux.dev>
List-Help: <mailto:syzbot+help@lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
List-Owner: <mailto:syzbot+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f0f928b0-ce5b-4a70-aa39-e3f535ad9139@mail.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=poczta.fm; s=dk;
	t=1792487737; bh=Lx6BS2qc7eFv1NSrhWZBESIdu0s4cEF0hyli7vCfKdE=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	b=mq+Umk/EdXGSqYZnKEP8+b2j8Qeul6P6l7+VcW3pyZSHJm+8NQF+ezs1/UvkoJ0SA
	 8eYWCWFjk71Fw75wMGENQOqikkrCO9Yd6GqOZSSlMhsH0JfN3FdPofErFjiv4ohLGu
	 qcbRaQzwzcY9wVGkQup76wup4mjlE+Az6z3C0aSM=

On paź 20, 2026 08:19, syzbot wrote:
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

Here the config_item_get() is wrong now. The config_item_get_unless_zero() is now used. Note also
that using config_item_get_unless_zero() does not prevent "concurrent release or removal". It is
used to skip it in case when concurrent release is happening. Update the message to reflect that.

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
> Assisted-by: Gemini:gemini-4-argon Gemini:gemini-3.8-flash syzbot
> Reported-by: syzbot+b3410eb576b568216ae5@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=b3410eb576b568216ae5
> Link: https://syzkaller.appspot.com/ai_job?id=d0831a0b-a285-410d-96bd-ed4809099137
> To: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
> To: <linux-usb@vger.kernel.org>
> To: "Yun Zhou" <yun.zhou@windriver.com>
> Cc: "Jiasheng Jiang" <jiashengjiangcool@gmail.com>
> Cc: <linux-kernel@vger.kernel.org>
> Cc: "Cen Zhang" <zzzccc427@gmail.com>
> 
> ---
> v3:
> - Use config_item_get_unless_zero() instead of config_item_get() to safely handle concurrent teardown.
> 
> v2:
> - Retain original comment about dep_lock in usbg_make_tpg() instead of replacing it.
> https://lore.kernel.org/all/82dbe31c-49fb-446b-93b9-fcdec2504876@mail.kernel.org/T/
> 
> v1:
> https://lore.kernel.org/all/77d2115f-8e36-403c-bf08-6810b1c6900c@mail.kernel.org/T/
> ---
> diff --git a/drivers/usb/gadget/function/f_tcm.c b/drivers/usb/gadget/function/f_tcm.c
> index 9e6d4f399..a27f23191 100644
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
> @@ -1682,18 +1683,35 @@ static struct se_portal_group *usbg_make_tpg(struct se_wwn *wwn,
>  		if (!try_module_get(opts->dependent))
>  			goto unlock_inst;
>  	} else {
> +		item = config_item_get_unless_zero(&opts->func_inst.group.cg_item);
> +		if (!item)
> +			goto unlock_inst;
> +		mutex_unlock(&tpg_instances_lock);
> +
>  		/*
>  		 * configfs_depend_item_unlocked() may acquire the configfs
>  		 * root inode lock when the target belongs to a different
>  		 * subsystem. Calling it under dep_lock would create a
>  		 * circular dependency:
>  		 *   dep_lock -> configfs inode lock -> su_mutex -> dep_lock
> +		 *
> +		 * Calling it under tpg_instances_lock would create a
> +		 * circular dependency:
> +		 *   inode_lock -> su_mutex -> func_lock -> tpg_instances_lock -> inode_lock
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
