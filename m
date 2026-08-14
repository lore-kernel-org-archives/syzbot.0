Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50B68463B7E
	for <syzbot@lists.linux.dev>; Fri, 14 Aug 2026 12:14:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786709664; cv=none; b=JjupNkd0GPtUpUb3N4+WQbvg+Ez6DgNz5ThJG7YdW63KN8HNvk1ot/xnOLQ1L4ppXQLk9eQvdYXKCGmRMJMtr9nCsh/9aO2WyphvrYKrYNw/46CuT0d6/2yV0MX3os1MQSPEfgxZY5vRFN6O7zyFIJU8Gcc2BKxYdCbcDIGsOcg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786709664; c=relaxed/simple;
	bh=dWfvOgjB9QyB4B2j5fREN+TFkeLagT6PRv7O5wmdFMU=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XJvl/Oqu1sWIiuCTcvihd7TLIS4S+NSh5jdKN/moL2bGRoXs0p7MT39+wZEBF450audyf5DTIcV44DygpT7lgzXyV8m6bCHiT5M3CqW19sD+qkoKgWebJ/CnvGHtk9noB9CI2XTBbuFHRrXNlBpWmK2OKrUIzLffhy6Xhusew0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=yul6r4V3; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=bt1qKlnx; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=sXk5lkOz; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Fy0/ycHY; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="yul6r4V3";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="bt1qKlnx";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="sXk5lkOz";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Fy0/ycHY"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 4C9E73EAF;
	Fri, 14 Aug 2026 12:14:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1786709657; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=j68MXISQ7pOQPyguqP+Sikl3yjbW7vPhqaCPTnTT6os=;
	b=yul6r4V3jeRXwblDLB0BJK3wdeXx+syjVEIQ5W4IE7WlUhhScrRrT7oOwEHF+/44UsbgyF
	CadOb7QgunyCyMipZTYdawYn/3DHyH9gLRkicsyTN9cCixzD0CsmNu0ejkBDUhypM+Go+U
	i4qhKi/9BJhR0J+eZMFC+rhgICBT3mI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1786709657;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=j68MXISQ7pOQPyguqP+Sikl3yjbW7vPhqaCPTnTT6os=;
	b=bt1qKlnxwYDVuLoI6P/6b4n+er32CXWkooRJvaCbQioShWfMJSIh44wj7YQ0PNCZQ3rWXj
	w8uxxDDwDnyt/cBQ==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1786709653; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=j68MXISQ7pOQPyguqP+Sikl3yjbW7vPhqaCPTnTT6os=;
	b=sXk5lkOzue7njV97bVuYS0GLOyZFUgrnsT+YOyHX1p3clOQcyh94CIUo6cY8EDyJkgET+g
	oc+hWOg1DjS1ThjCydxymZOILPNTAu2MOEaQ3ls/LiILZHE2MesPHEDdxCM5EeKva3DqL5
	9SORUXFkEFZMiF3PMNCIeA2VfdOQuU4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1786709653;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=j68MXISQ7pOQPyguqP+Sikl3yjbW7vPhqaCPTnTT6os=;
	b=Fy0/ycHY5UwqdnCs2n+KqTnlAoh8dmUKB+2AU/fvezPFNqv0u6v88e0bsKiiTvJMkEkneq
	BDux8u3SPrwcNxAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id EB7B57838B;
	Fri, 14 Aug 2026 12:14:12 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id hEFGOJQGf2pbCQAAD6G6ig
	(envelope-from <tiwai@suse.de>); Fri, 14 Aug 2026 12:14:12 +0000
Date: Fri, 14 Aug 2026 14:14:12 +0200
Message-ID: <877blsew6j.wl-tiwai@suse.de>
From: Takashi Iwai <tiwai@suse.de>
To: "syzbot" <syzbot@kernel.org>
Cc: syzkaller-bugs@googlegroups.com,
	Aleksandr Nogikh <nogikh@google.com>,
	<linux-sound@vger.kernel.org>,
	"Jaroslav Kysela" <perex@perex.cz>,
	"Takashi Iwai" <tiwai@suse.com>,
	"Takashi Iwai" <tiwai@suse.de>,
	broonie@kernel.org,
	cassiogabrielcontato@gmail.com,
	cezary.rojewski@intel.com,
	kees@kernel.org,
	linux-kernel@vger.kernel.org,
	syzbot@lists.linux.dev
Subject: Re: [PATCH] ALSA: core: Fix use-after-free in snd_card_do_free()
In-Reply-To: <02042186-27b7-42a9-b64e-f93ce8fbe05a@mail.kernel.org>
References: <02042186-27b7-42a9-b64e-f93ce8fbe05a@mail.kernel.org>
User-Agent: Wanderlust/2.15.9 (Almost Unreal) Emacs/30.2 Mule/6.0
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0 (generated by SEMI-EPG 1.14.7 - "Harue")
Content-Type: text/plain; charset=US-ASCII
X-Spam-Score: -3.30
X-Spam-Level: 
X-Spam-Flag: NO
X-Spamd-Result: default: False [-3.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_TLS_ALL(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[13];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FREEMAIL_CC(0.00)[googlegroups.com,google.com,vger.kernel.org,perex.cz,suse.com,suse.de,kernel.org,gmail.com,intel.com,lists.linux.dev];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,syzkaller.appspot.com:url,suse.de:mid,appspotmail.com:email]

On Fri, 14 Aug 2026 14:05:43 +0200,
syzbot wrote:
> 
> From: Aleksandr Nogikh <nogikh@google.com>
> 
> A use-after-free was detected in snd_card_do_free() when a sound card
> managed by devres is unbound while a user-space application still holds an
> open file descriptor.
> 
> For managed cards, the memory is allocated using devres_alloc(), and its
> release function is set to __snd_card_release(), which calls
> snd_card_free(). When the device is unbound, the unbind thread calls
> snd_card_free(), which drops a reference to the card's device. If the user
> thread still has an open file descriptor, the reference count does not
> reach zero, and the unbind thread blocks on wait_for_completion(&released).
> 
> When the user thread closes the file descriptor, it drops the final
> reference, invoking the device release callback release_card_device(),
> which calls snd_card_do_free(). snd_card_do_free() performs cleanup and
> calls complete(card->release_completion). This wakes up the unbind thread,
> which returns from snd_card_free() and __snd_card_release(). The devres
> core then immediately frees the memory block containing the snd_card
> structure.
> 
> Meanwhile, the user thread continues execution in snd_card_do_free() and
> evaluates `if (!card->managed)`. It reads the `managed` boolean from the
> snd_card structure that was just freed by the unbind thread, triggering a
> KASAN use-after-free.
> 
> Fix this by caching the value of card->managed in a local variable before
> calling complete(). This ensures that the card pointer is not dereferenced
> after the unbind thread has been woken up and potentially freed the card.
> 
> BUG: KASAN: use-after-free in snd_card_do_free sound/core/init.c:604
> [inline]
> BUG: KASAN: use-after-free in release_card_device+0x1ab/0x1b0
> sound/core/init.c:153
> Read of size 1 at addr ffff8881912ec909 by task syz-executor130/5857
> 
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
>  print_address_description+0x55/0x1e0 mm/kasan/report.c:378
>  print_report+0x58/0x70 mm/kasan/report.c:482
>  kasan_report+0x117/0x150 mm/kasan/report.c:595
>  snd_card_do_free sound/core/init.c:604 [inline]
>  release_card_device+0x1ab/0x1b0 sound/core/init.c:153
>  device_release+0xc4/0x1f0 drivers/base/core.c:-1
>  kobject_cleanup lib/kobject.c:689 [inline]
>  kobject_release lib/kobject.c:720 [inline]
>  kref_put include/linux/kref.h:65 [inline]
>  kobject_put+0x222/0x550 lib/kobject.c:737
>  snd_card_file_remove+0x331/0x390 sound/core/init.c:1125
>  snd_pcm_release+0x12c/0x160 sound/core/pcm_native.c:2986
>  __fput+0x418/0xa50 fs/file_table.c:512
>  fput_close_sync+0x11f/0x240 fs/file_table.c:617
>  __do_sys_close fs/open.c:1511 [inline]
>  __se_sys_close fs/open.c:1496 [inline]
>  __x64_sys_close+0x7e/0x110 fs/open.c:1496
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>  </TASK>
> 
> Fixes: e8ad415b7a55 ("ALSA: core: Add managed card creation")
> Assisted-by: Gemini:gemini-3.6-flash Gemini:gemini-3.1-pro-preview syzbot
> Reported-by: syzbot+7061d72c26b7daebe2b4@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=7061d72c26b7daebe2b4
> Link: https://syzkaller.appspot.com/ai_job?id=24752a23-f0b6-49c1-bf20-4fa89c2e7eb2
> Signed-off-by: Aleksandr Nogikh <nogikh@google.com>

Applied to for-next branch.  Thanks.


Takashi
