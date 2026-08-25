Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 413F23F8717;
	Tue, 25 Aug 2026 12:16:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787660188; cv=none; b=V9gT21x4nBwhqcB/6YdXj0GMvt3Xi0jwkZutfEo2OQUz19WwHwQ9Nqp5pwOBr8wcisNbO2ZPv4BVEWXsgMmgAF5FJUQ/pP345fKelWHtgfm21Oew4luvkJLD9Cp2NyQ5V+DWWgfMcC18jUZE0lqLlqOVv8y3os1A+XqyhQBpjWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787660188; c=relaxed/simple;
	bh=osZ54KNJsfR2Abmha9iAnbKAKX1atJ8ukrdhRlxrBZQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qAq9LcbXNOd8xv9Av5cKXT1JMd6aNcD8jcMIcI0UrX2xMEgNBb/9IOI8FSpXUZdkuvGuxG/+J+SIbEBH2RMJQyQhZSocc9pro8EniVkiE7NisNvNln5wBrynWuZX9bE7JlFOiebV6jy+b4ZUx738iyDVKwZ032hUm6VHOPCcoFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=W+ajTKJA; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=LvE2oQEM; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=IhIA+oZS; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=DpA/JdYl; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="W+ajTKJA";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="LvE2oQEM";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="IhIA+oZS";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="DpA/JdYl"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 35B031F7EA;
	Tue, 25 Aug 2026 12:15:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1787660159; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=FoPRiT8GsCz3Iz2j5y0BJhZbaqn9I/93BvKkFAXazK4=;
	b=W+ajTKJAhGQ+G0jYIB5lk2KUXL8xAcx1N6iOVW6nDFfVq6Cznw+zZqCjTPzXZ9wZPTsEWq
	XJ0oDSbMRgRUpLMZHzsjnB5WkurdsLRhv1yidtRCxyjWZLBdWH6YtWrQCBh/gKgSceo0IO
	5sjjRn5A+q2c5iRzp/WxRrVVGLcWtHU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1787660159;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=FoPRiT8GsCz3Iz2j5y0BJhZbaqn9I/93BvKkFAXazK4=;
	b=LvE2oQEM/sHCN0gnGqmIu4WsW/BOmse974N8VzMAMDSRL2aQBw3Ro/tieM74dUgaC4MzWy
	45QLerSsFg0aq/Bg==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1787660155; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=FoPRiT8GsCz3Iz2j5y0BJhZbaqn9I/93BvKkFAXazK4=;
	b=IhIA+oZSIyjCo4ln3M3yquCOeKaQSqstlLyPUfHAlBbG5nP56EY0vsEeg3J4m+TjPRWjEu
	YyOxT7V/6TL4bRMkLvAE9PR+U2ydiq25XER7RhIO4U59aq237UZ8JH0vFUuSFrRY4NGOZ1
	sAvVLD9ITS4Wy3qBjhiIPTNPAYDfch8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1787660155;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=FoPRiT8GsCz3Iz2j5y0BJhZbaqn9I/93BvKkFAXazK4=;
	b=DpA/JdYlwmMumvY3aO2gdwdrX3yJf8ntrRNKKcGav3K0vH4j9vZHNL59SSVI6IhLp5wFNd
	NwjIoV33wYPI2GDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D82B113331;
	Tue, 25 Aug 2026 12:15:54 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Ps2ZM3qHjWqAbwAAD6G6ig
	(envelope-from <tzimmermann@suse.de>); Tue, 25 Aug 2026 12:15:54 +0000
Message-ID: <7a3b43c7-91f0-4b24-b8fe-09dfbdc5296b@suse.de>
Date: Tue, 25 Aug 2026 14:15:54 +0200
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] drm/cirrus-qemu: Validate BAR0 size during probe
To: Slawomir Stepien <sst@poczta.fm>, syzkaller-bugs@googlegroups.com,
 airlied@gmail.com, airlied@redhat.com, dri-devel@lists.freedesktop.org,
 kraxel@redhat.com, maarten.lankhorst@linux.intel.com, mripard@kernel.org,
 simona@ffwll.ch, virtualization@lists.linux.dev
Cc: jani.nikula@intel.com, linux-kernel@vger.kernel.org,
 syzbot@lists.linux.dev, syzbot+2442951a6abb004df963@syzkaller.appspotmail.com
References: <20260825120729.493611-1-sst@poczta.fm>
Content-Language: en-US
From: Thomas Zimmermann <tzimmermann@suse.de>
Autocrypt: addr=tzimmermann@suse.de; keydata=
 xsBNBFs50uABCADEHPidWt974CaxBVbrIBwqcq/WURinJ3+2WlIrKWspiP83vfZKaXhFYsdg
 XH47fDVbPPj+d6tQrw5lPQCyqjwrCPYnq3WlIBnGPJ4/jreTL6V+qfKRDlGLWFjZcsrPJGE0
 BeB5BbqP5erN1qylK9i3gPoQjXGhpBpQYwRrEyQyjuvk+Ev0K1Jc5tVDeJAuau3TGNgah4Yc
 hdHm3bkPjz9EErV85RwvImQ1dptvx6s7xzwXTgGAsaYZsL8WCwDaTuqFa1d1jjlaxg6+tZsB
 9GluwvIhSezPgnEmimZDkGnZRRSFiGP8yjqTjjWuf0bSj5rUnTGiyLyRZRNGcXmu6hjlABEB
 AAHNJ1Rob21hcyBaaW1tZXJtYW5uIDx0emltbWVybWFubkBzdXNlLmRlPsLAjgQTAQgAOAIb
 AwULCQgHAgYVCgkICwIEFgIDAQIeAQIXgBYhBHIX+6yM6c9jRKFo5WgNwR1TC3ojBQJftODH
 AAoJEGgNwR1TC3ojx1wH/0hKGWugiqDgLNXLRD/4TfHBEKmxIrmfu9Z5t7vwUKfwhFL6hqvo
 lXPJJKQpQ2z8+X2vZm/slsLn7J1yjrOsoJhKABDi+3QWWSGkaGwRJAdPVVyJMfJRNNNIKwVb
 U6B1BkX2XDKDGffF4TxlOpSQzdtNI/9gleOoUA8+jy8knnDYzjBNOZqLG2FuTdicBXblz0Mf
 vg41gd9kCwYXDnD91rJU8tzylXv03E75NCaTxTM+FBXPmsAVYQ4GYhhgFt8S2UWMoaaABLDe
 7l5FdnLdDEcbmd8uLU2CaG4W2cLrUaI4jz2XbkcPQkqTQ3EB67hYkjiEE6Zy3ggOitiQGcqp
 j//OwE0EWznS4AEIAMYmP4M/V+T5RY5at/g7rUdNsLhWv1APYrh9RQefODYHrNRHUE9eosYb
 T6XMryR9hT8XlGOYRwKWwiQBoWSDiTMo/Xi29jUnn4BXfI2px2DTXwc22LKtLAgTRjP+qbU6
 3Y0xnQN29UGDbYgyyK51DW3H0If2a3JNsheAAK+Xc9baj0LGIc8T9uiEWHBnCH+RdhgATnWW
 GKdDegUR5BkDfDg5O/FISymJBHx2Dyoklv5g4BzkgqTqwmaYzsl8UxZKvbaxq0zbehDda8lv
 hFXodNFMAgTLJlLuDYOGLK2AwbrS3Sp0AEbkpdJBb44qVlGm5bApZouHeJ/+n+7r12+lqdsA
 EQEAAcLAdgQYAQgAIAIbDBYhBHIX+6yM6c9jRKFo5WgNwR1TC3ojBQJftOH6AAoJEGgNwR1T
 C3ojVSkIALpAPkIJPQoURPb1VWjh34l0HlglmYHvZszJWTXYwavHR8+k6Baa6H7ufXNQtThR
 yIxJrQLW6rV5lm7TjhffEhxVCn37+cg0zZ3j7zIsSS0rx/aMwi6VhFJA5hfn3T0TtrijKP4A
 SAQO9xD1Zk9/61JWk8OysuIh7MXkl0fxbRKWE93XeQBhIJHQfnc+YBLprdnxR446Sh8Wn/2D
 Ya8cavuWf2zrB6cZurs048xe0UbSW5AOSo4V9M0jzYI4nZqTmPxYyXbm30Kvmz0rYVRaitYJ
 4kyYYMhuULvrJDMjZRvaNe52tkKAvMevcGdt38H4KSVXAylqyQOW5zvPc4/sq9c=
In-Reply-To: <20260825120729.493611-1-sst@poczta.fm>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	FREEMAIL_TO(0.00)[poczta.fm,googlegroups.com,gmail.com,redhat.com,lists.freedesktop.org,linux.intel.com,kernel.org,ffwll.ch,lists.linux.dev];
	TAGGED_RCPT(0.00)[2442951a6abb004df963];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[14];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com,poczta.fm];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:url,poczta.fm:email,cirrus_driver.name:url,suse.de:mid,suse.de:email,imap1.dmz-prg2.suse.org:helo,appspotmail.com:email,syzkaller.appspot.com:url]
X-Spam-Flag: NO
X-Spam-Score: -2.80
X-Spam-Level: 

Hi

Am 25.08.26 um 14:07 schrieb Slawomir Stepien:
> The `cirrus-qemu` driver relies on `CIRRUS_VRAM_SIZE` (4 MB) to validate
> framebuffer sizes. However, during PCI probe, the driver mapped BAR0
> without verifying that its size matches `CIRRUS_VRAM_SIZE`.
>
> If a PCI device with a BAR0 smaller than 4 MB is bound to the driver, the
> mapped VRAM will be smaller than expected. Because validation checks assume
> 4 MB VRAM, framebuffers larger than the mapped memory can be created.
>
> When the display plane is updated (e.g. during release),
> `cirrus_primary_plane_helper_atomic_update()` copies the framebuffer to
> VRAM using `drm_fb_memcpy()`. Writing past the end of the mapped I/O memory
> causes a supervisor write page fault:
>
> BUG: unable to handle page fault for address: ffffc9000389c000
> ...
> RIP: 0010:memcpy_toio+0x7c/0xe0 arch/x86/lib/iomem.c:110
> ...
> Call Trace:
>   <TASK>
>   iosys_map_memcpy_to include/linux/iosys-map.h:285 [inline]
>   drm_fb_memcpy+0x325/0x5d0 drivers/gpu/drm/drm_format_helper.c:442
>   cirrus_primary_plane_helper_atomic_update+0x98a/0xb00
>   drivers/gpu/drm/tiny/cirrus-qemu.c:358
>   drm_atomic_helper_commit_planes+0x626/0xea0
>   drivers/gpu/drm/drm_atomic_helper.c:3038
>   drm_atomic_helper_commit_tail+0x60/0x510
>   drivers/gpu/drm/drm_atomic_helper.c:1989
>   commit_tail+0x2b1/0x3c0 drivers/gpu/drm/drm_atomic_helper.c:2074
>   drm_atomic_helper_commit+0xa77/0xb10
>   drivers/gpu/drm/drm_atomic_helper.c:2312
>
> Fix this by validating in `cirrus_pci_probe()` that the PCI BAR0 resource
> is not less than `CIRRUS_VRAM_SIZE`, returning `-ENODEV` if it is less.
>
> Fixes: ab3e023b1b4c ("drm/cirrus: rewrite and modernize driver.")
> Assisted-by: Gemini:gemini-3.6-flash Gemini:gemini-3.1-pro-preview syzbot
> Reported-by: syzbot+2442951a6abb004df963@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=2442951a6abb004df963
> Link: https://syzkaller.appspot.com/ai_job?id=ba262a3a-bccf-4ad8-a1b0-583c55d34fd6
> Signed-off-by: Slawomir Stepien <sst@poczta.fm>

Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>

Thanks for fixing this issue.

Best regards
Thomas

> ---
> v2:
> * move the check before aperture_remove_conflicting_pci_devices() as suggested by sashiko.
> * check if the pci_resource_len() for BAR0 is less than CIRRUS_VRAM_SIZE as suggested by Thomas. The
>    qemu emulates 4, (8 and 16 MB for compatibility) - never less than 4MB.
>
> v1:
> * https://lore.kernel.org/all/b11f8965-5896-4119-98b7-6bd0eb9fa139@mail.kernel.org/T/
> ---
>   drivers/gpu/drm/tiny/cirrus-qemu.c | 3 +++
>   1 file changed, 3 insertions(+)
>
> diff --git a/drivers/gpu/drm/tiny/cirrus-qemu.c b/drivers/gpu/drm/tiny/cirrus-qemu.c
> index 075221b431d3..3bf23fcf6574 100644
> --- a/drivers/gpu/drm/tiny/cirrus-qemu.c
> +++ b/drivers/gpu/drm/tiny/cirrus-qemu.c
> @@ -582,6 +582,9 @@ static int cirrus_pci_probe(struct pci_dev *pdev,
>   	struct cirrus_device *cirrus;
>   	int ret;
>   
> +	if (pci_resource_len(pdev, 0) < CIRRUS_VRAM_SIZE)
> +		return -ENODEV;
> +
>   	ret = aperture_remove_conflicting_pci_devices(pdev, cirrus_driver.name);
>   	if (ret)
>   		return ret;

-- 
--
Thomas Zimmermann
Graphics Driver Developer
SUSE Software Solutions Germany GmbH
Frankenstr. 146, 90461 Nürnberg, Germany, www.suse.com
GF: Jochen Jaser, Andrew McDonald, (HRB 36809, AG Nürnberg)


