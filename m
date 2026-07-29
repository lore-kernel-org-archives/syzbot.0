Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5515339EF3F
	for <syzbot@lists.linux.dev>; Wed, 29 Jul 2026 09:16:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785316566; cv=none; b=MIfSNNCrl5TKn1jMYffhfqjrZQBSZun3puyi2ifPdJFm4oOEV3E6h/fRVFUhx3t7Zss2moXpmHuMc1atZP391BstWO/wgjH+dGpNhglBwjdPBfgtc0ys64bT3kNo6N3F4NN8P+e7P8ePvDNtVBOQgT9uRmldqv4CcTDNXIUjQHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785316566; c=relaxed/simple;
	bh=8vOt1qOw2QasGnPAYpImvZ1g3qItLj5uthb1gjUw1cc=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rKsEDSJT19OjqY+1KRF20AzRK2+2b8MI2zc4ZZUjN3vWAlhwTIxuOwMz1huvQet+SkeJlvn5P7bU4mvCLYDRNGA+rAL8aKk8LrObxJH3XW0iFiZ74lgKSd7hE4TW7sfzAAVrIJTFBhoNSSVuRdDMRAs2+Jm2hDqr/2uU+2McF9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=N+uYxqq2; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=lt0jOTAq; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=0jIUgZWi; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=8cfDM205; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="N+uYxqq2";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="lt0jOTAq";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="0jIUgZWi";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="8cfDM205"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 1B0037C9CD;
	Wed, 29 Jul 2026 09:15:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1785316558; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3zMW4bJA/KFBZl/mm8hnEF29U0iYIM2G/iSU/T9jgkk=;
	b=N+uYxqq2B8zng6JAnPxkuFGjG6PNbVRoqS2IuFoO4KSvvDqQNhU9FLe0QqIaEa/+3Vrhxx
	UF71ir3l3BOwBYzEYb9AvDv4q8kudB/lI8bwdAc0fIf8zynSMwfP6yIF2TqtRx+7Iik/KL
	dc8jhThH/qGVXWzQXlaXM0XtzLxdI68=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1785316558;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3zMW4bJA/KFBZl/mm8hnEF29U0iYIM2G/iSU/T9jgkk=;
	b=lt0jOTAqnbBExB6Ln6KNnM/nQEVehv3Pw1KTK5KNxFjCWFYie9sy8sz8YC6XC5cq9jUdh7
	ifMvg3QSeSPW2pBA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1785316554; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3zMW4bJA/KFBZl/mm8hnEF29U0iYIM2G/iSU/T9jgkk=;
	b=0jIUgZWi4fnWhbhrQe9AWQvvu2cgHSNuWakFJ84C31S1m0cOZWh+w/twunjCSAOghY1pNO
	OvpywmdjoKDLKtjSp8blRNv4pUUsvlyVz5qgnBublnwpIsm0LqlpeqSOGbgk+lfeaTMuok
	T9OCD9wQ+ps9n5y2wjECWVkJKljwM3Y=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1785316554;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3zMW4bJA/KFBZl/mm8hnEF29U0iYIM2G/iSU/T9jgkk=;
	b=8cfDM205j4sY04tH0wdEkNnoj7vFZIzYw+ev3sq0OSpW0Cr9vNK0B8LKLCFYY6uFgovoL8
	IVBSYRJ8YXUTLaBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id AFDA9779A1;
	Wed, 29 Jul 2026 09:15:53 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id YQKUKcnEaWo7fQAAD6G6ig
	(envelope-from <tiwai@suse.de>); Wed, 29 Jul 2026 09:15:53 +0000
Date: Wed, 29 Jul 2026 11:15:53 +0200
Message-ID: <87zeza40mu.wl-tiwai@suse.de>
From: Takashi Iwai <tiwai@suse.de>
To: "syzbot" <syzbot@kernel.org>
Cc: syzkaller-bugs@googlegroups.com,
	Aleksandr Nogikh <nogikh@google.com>,
	"Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
	<linux-usb@vger.kernel.org>,
	"Takashi Iwai" <tiwai@suse.de>,
	christophe.jaillet@wanadoo.fr,
	kees@kernel.org,
	linux-kernel@vger.kernel.org,
	syzbot@lists.linux.dev
Subject: Re: [PATCH] usb: gadget: midi2: Fix null-pointer dereference in f_midi2_free_ep_reqs
In-Reply-To: <cafe65f4-e1bb-46a3-901d-732814b861b2@mail.kernel.org>
References: <cafe65f4-e1bb-46a3-901d-732814b861b2@mail.kernel.org>
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
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCPT_COUNT_SEVEN(0.00)[10];
	MIME_TRACE(0.00)[0:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[wanadoo.fr];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FREEMAIL_CC(0.00)[googlegroups.com,google.com,linuxfoundation.org,vger.kernel.org,suse.de,wanadoo.fr,kernel.org,lists.linux.dev];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[appspotmail.com:email,suse.de:email,suse.de:mid,imap1.dmz-prg2.suse.org:helo,syzkaller.appspot.com:url]

On Wed, 29 Jul 2026 11:04:54 +0200,
syzbot wrote:
> 
> From: Aleksandr Nogikh <nogikh@google.com>
> 
> A null-pointer dereference occurs in f_midi2_free_ep_reqs() when attempting
> to clean up an endpoint that was never initialized.
> 
> When configuring the MIDI 2.0 gadget via configfs and setting the block
> direction to SNDRV_UMP_DIR_INPUT, the initialization of the midi1_ep_out
> endpoint is explicitly skipped during the gadget bind phase
> (f_midi2_bind()). As a result, the usb_ep->card field remains NULL.
> 
> Later, when the host sets the alternate setting, f_midi2_set_alt()
> unconditionally stops both the IN and OUT endpoints by calling
> f_midi2_stop_eps(), which in turn calls f_midi2_free_ep_reqs() for both
> endpoints. When f_midi2_free_ep_reqs() is called for the uninitialized
> midi1_ep_out, it attempts to dereference usb_ep->card to determine the
> number of requests to free, leading to a crash.
> 
> Fix this by using usb_ep->num_reqs instead of usb_ep->card->info.num_reqs
> in f_midi2_free_ep_reqs(). usb_ep->num_reqs is correctly set during
> f_midi2_init_ep() and remains 0 if the endpoint was never initialized,
> safely avoiding the loop. For consistency, apply the same change to
> f_midi2_alloc_ep_reqs().
> 
> Oops: general protection fault, probably for non-canonical address
> 0xdffffc00000000ee: 0000 [#1] SMP KASAN NOPTI
> KASAN: null-ptr-deref in range [0x0000000000000770-0x0000000000000777]
> ...
> RIP: 0010:f_midi2_free_ep_reqs drivers/usb/gadget/function/f_midi2.c:1166
> [inline]
> RIP: 0010:f_midi2_stop_eps+0x28e/0x4d0
> drivers/usb/gadget/function/f_midi2.c:1246
> ...
> Call Trace:
>  <TASK>
>  f_midi2_set_alt+0x11c/0xf00 drivers/usb/gadget/function/f_midi2.c:1296
>  composite_setup+0x1ffd/0x3480 drivers/usb/gadget/composite.c:1933
>  configfs_composite_setup+0xbd/0x100 drivers/usb/gadget/configfs.c:1877
> 
> Fixes: 8b645922b223 ("usb: gadget: Add support for USB MIDI 2.0 function driver")
> Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot
> Reported-by: syzbot+bbb6dad313f4aaa8da6b@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=bbb6dad313f4aaa8da6b
> Link: https://syzkaller.appspot.com/ai_job?id=8ce30b1a-8cf7-4e38-bcf7-1f69e6f6313f
> Signed-off-by: Aleksandr Nogikh <nogikh@google.com>

Reviewed-by: Takashi Iwai <tiwai@suse.de>


thanks,

Takashi
