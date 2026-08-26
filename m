Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 766C8340282;
	Wed, 26 Aug 2026 06:57:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787727474; cv=none; b=FkD7cEeRLTNovypt1AOJzbLWcFR4dojzfXnBReIYNrBSOXomJcSBVBmV/YJktQP+FBQtSzSrwzJ6fegDkQiKSQjH4YOgaI7WPi7cLJzHdJaLV9UprB2mL2baDA1x1271pRBt24MitJbI2mHLLsxaUjgi2iozFJA6+f4u1sEages=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787727474; c=relaxed/simple;
	bh=8kIL6rfYZGU93VPgF4RHtZ/NmSk+6kT2wyBnkTxQ2js=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Q59iN+weBJydFKaR/C5+rkuukYJk8tdg7bVLGiowWRkDiaGYpVp8Zt+TJCIoiFvadB/kEpKrPSv6EO5tzjFSU6R8kp/9k35naMW8KGR2inRuqAeuWM+r+6R0mNo/6eHbZYSTImV3U39x+2rkNsa5ILBenzkzLaq4V7c/FYdCT7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=1dopK4gm; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=1HDIgZRC; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=jxzi81Wq; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=qfiqrytB; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="1dopK4gm";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="1HDIgZRC";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="jxzi81Wq";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="qfiqrytB"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 1239E1F7F6;
	Wed, 26 Aug 2026 06:57:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1787727452; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=sBfgI5vwAaQkNS2Sqa0AXBE6+/CTnkGwvymAGJWg9RE=;
	b=1dopK4gmbdUGldC8wPoHsZ/q91A8028zEwWab1SqBcu2lqkRmdOCwqcvkTNTC+foFmnDpf
	LraETcBNykLGV6yZ4MyxyHXZtqZw09FWWQITEbGc67kHTHpTQq5UeWx+Rj9d86p0dO6XqA
	VeY4R6zF/HCB9/KUleC/6099ZXU14NU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1787727452;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=sBfgI5vwAaQkNS2Sqa0AXBE6+/CTnkGwvymAGJWg9RE=;
	b=1HDIgZRCX3PAYrMZ+8Cjv+dl468knsXrys4RScm6BIcnGbwrns29gGDBP30j9lWtRGj/a3
	8EbrPdxWfzRVRACw==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=jxzi81Wq;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=qfiqrytB
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1787727448; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=sBfgI5vwAaQkNS2Sqa0AXBE6+/CTnkGwvymAGJWg9RE=;
	b=jxzi81Wq/ORegKCwe5YqxK/kUKzRQXd3SGYysLGmtSOW7rGvf0iDZNvRks1r6EMaOVV7a1
	7tn65HQc+dWJbW5Tsl0QWPJY5KrWvDb4qULm5g4JcsWulTtP1xQ+1XeIEcNDnRSi3vNV5N
	2CwRuDfsrHrz0RTHpDTDjRVRYsbAVRY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1787727448;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=sBfgI5vwAaQkNS2Sqa0AXBE6+/CTnkGwvymAGJWg9RE=;
	b=qfiqrytBjmFogEQnk7guycXfrOVc0q9/7qMFJe8uoUpEffgYKlB7WR/Zz2ub3B932wK5WR
	m1TGu6BYAyk03ICA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B03B813533;
	Wed, 26 Aug 2026 06:57:27 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id KtzaKVeOjmpjVQAAD6G6ig
	(envelope-from <tzimmermann@suse.de>); Wed, 26 Aug 2026 06:57:27 +0000
Message-ID: <03ab9470-60c6-40fe-8d24-89c820b978ec@suse.de>
Date: Wed, 26 Aug 2026 08:57:27 +0200
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
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FREEMAIL_TO(0.00)[poczta.fm,googlegroups.com,gmail.com,redhat.com,lists.freedesktop.org,linux.intel.com,kernel.org,ffwll.ch,lists.linux.dev];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[14];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_ENVRCPT(0.00)[gmail.com,poczta.fm];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	TAGGED_RCPT(0.00)[2442951a6abb004df963];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid,suse.de:dkim,suse.com:url,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,appspotmail.com:email]
X-Spam-Flag: NO
X-Spam-Score: -3.01
X-Spam-Level: 
X-Rspamd-Queue-Id: 1239E1F7F6
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action

Merged into drm-misc-fixes

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


