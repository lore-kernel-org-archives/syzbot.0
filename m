Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBAF73D5C06
	for <syzbot@lists.linux.dev>; Tue, 25 Aug 2026 08:00:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=100.103.45.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787644861; cv=pass; b=a+3u2baFbA0N9hvhPwcfQt6UKFCq65k1JlEWOOm49vKWT/WnLsp9CU2W84SgLgkN5htfwsY1d1sQsA779+VOZxE4MgUOH9o8/FXF2gEvmtArfrIZeTF1l1N2JVfOTLa30g/e8lsmuxBfQh0uF7GJFyNW/cbPCgBf52VSoyvEtUg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787644861; c=relaxed/simple;
	bh=4wuKdClDEtyiCer3EcQsfP1rv7pakVvgh/SVlmX65tY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qP2T2swX86wbN6/2y9JOWID2f16LBhSu86UCVOTZQElspg4Wz0quroUTIZ9q2P4nNGII8TYNnOUvul9jNQM8JZ0IxsT9Jmzkoli3Ftgoa/SODj3mf64fzaWlzC7Nb3e1wEhoFtDjUIdJRunhXLVzySmQqUluJCsGqjNu+B8bw9U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=sQCagDmq; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=2NLh5ZER; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=y+VpEsA0; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Q2Qkf/9G; arc=pass smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="sQCagDmq";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="2NLh5ZER";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="y+VpEsA0";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Q2Qkf/9G"
Received: by smtp.kernel.org (Postfix)
	id D74DF1F00A3D; Tue, 25 Aug 2026 08:00:59 +0000 (UTC)
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1787644859;
	b=NMQN33ZPYTvlpfR6R/RzNO3hRAsGfv70tBEjmLlnGGPtabhRVlGAyTjIvd3qrVigmYVe
	 IYAjug5YBQWHQj5pKMHhPsW4aB0+K0nzTqC0rPAG1wso6yUJKhBjfqChKm8IaKgVl6rAG
	 xrNHs2JZNLNg7cikYCy8KIlTQVLGy2Wt/a2h1BtZHPlTIB66xntTkJR+p0XrgtvXa8Z0x
	 59tvBJy+FDF3NJfqANHLmxO4nQwe6MTce+IYcgObYT48o2qdyS2LmVPMlhMZmNkHZnhY4
	 L05yQ4LeP4037mZk1jdHwmdAAFZDtmrkRVMeztP/PjeNDQgRiz69uovzTUKm5my32sA==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1787644859;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:Autocrypt:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding:X-Spamd-Result:
	 X-Spam-Flag:X-Spam-Score:X-Spam-Level:X-Rspamd-Queue-Id:
	 X-Rspamd-Server:X-Rspamd-Action;
	bh=f9+UYLkhFMeqJpdRKe3KSbiCGXI7lAcmJIinawqugjk=;
	b=G/ek2kloz1lfV8xOo7pFG/uylADcV28q+S8kueKCz1uV3LKi4G3zXZnvRRVlwbrjzzEy
	 ZzoSvmu7oUacwPj8xBSwNvR1FcItaE4zfqK4fyNBN5I44A7r/fJv98YVWE2ibFlRYOB8u
	 OjXmmkb9bEHpA6wjZxsmt/pOPZFSS3T52qwroKXbnx35OjgnS7vtt+94dQtXBVOawt7mY
	 r2kfx489zgxV7wAY31cfn2ly+FO6IfwVsMBlhVcm5bt4N+KvpKHSsoec+NcBt2yPtrCna
	 aZvgTHFHQ7lSpWfFKIGnSOIam1nTxfvmoWqRk8s3xjTk9FBdrk+lNpFMJgecM2mBHmg==
ARC-Authentication-Results: i=1; smtp.kernel.org; dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=sQCagDmq;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=2NLh5ZER;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=y+VpEsA0;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b="Q2Qkf/9G";
	dmarc=pass header.from=suse.de;
	spf=pass smtp.mailfrom=suse.de;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id D89B61F000E9
	for <syzbot@kernel.org>; Tue, 25 Aug 2026 08:00:58 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=sQCagDmq;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=2NLh5ZER;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=y+VpEsA0;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=Q2Qkf/9G
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.kernel.org D89B61F000E9
Authentication-Results: smtp.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id EBF0E86D2E;
	Tue, 25 Aug 2026 08:00:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1787644853; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=f9+UYLkhFMeqJpdRKe3KSbiCGXI7lAcmJIinawqugjk=;
	b=sQCagDmq4peuTng23qhcJG6M4r9xOAd3Cuz5f1XNti6+c0ZmrqjuwEyN5YB39Rq3mRPp8j
	3UhnWvdms8uQaUjWxRXqI4hhU0sNybTxPdlcNo1RFYBqMT9TxpB2ertWLXeW9+vL3W4jPJ
	US2MKY2tIjcH4+TaTN5aXW2pJSG1wMg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1787644853;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=f9+UYLkhFMeqJpdRKe3KSbiCGXI7lAcmJIinawqugjk=;
	b=2NLh5ZERTPBVrMuypQYRhEnyIQmd8LgFJtqI+gOqO+r5MUdvWOR6+kayyfK+fQnv7ykorS
	1DKOHjNgame+wOAA==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=y+VpEsA0;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="Q2Qkf/9G"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1787644847; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=f9+UYLkhFMeqJpdRKe3KSbiCGXI7lAcmJIinawqugjk=;
	b=y+VpEsA0xHwysqE9yxmGDTRhylsKhDEAy5b1WoOHJYCbv2ZeWJEAHcBX8zjCNRjhaMBrRE
	eBEEvVpw8j9nKDNKvsyvZBwZyZbErDJzs8Dl77e7HbIPlBBDIzFsIO1ZjudBVLoliU+xyb
	Jhpji2I+csN5UaXagCCFme0olCgNB0E=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1787644847;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=f9+UYLkhFMeqJpdRKe3KSbiCGXI7lAcmJIinawqugjk=;
	b=Q2Qkf/9G4xRnKvTmpGkTmp7pUNHTyQa9D4XZSkZ9MLX3foSfKXZJfjtM1DkjAfa/D2Lc7Y
	ZylZtGdWpMU95PCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id CCA1913335;
	Tue, 25 Aug 2026 08:00:47 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 3U/RMK9LjWoacgAAD6G6ig
	(envelope-from <tzimmermann@suse.de>); Tue, 25 Aug 2026 08:00:47 +0000
Message-ID: <ce0912d6-fdc4-4ead-9388-a9e0e9a1954c@suse.de>
Date: Tue, 25 Aug 2026 10:00:47 +0200
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] drm/cirrus-qemu: Validate BAR0 size during probe
To: sashiko-reviews@lists.linux.dev, syzbot <syzbot@kernel.org>, sst@poczta.fm
Cc: dri-devel@lists.freedesktop.org
References: <b11f8965-5896-4119-98b7-6bd0eb9fa139@mail.kernel.org>
 <20260825074432.0B4511F00A3A@smtp.kernel.org>
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
In-Reply-To: <20260825074432.0B4511F00A3A@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FREEMAIL_TO(0.00)[lists.linux.dev,kernel.org,poczta.fm];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[poczta.fm];
	MID_RHS_MATCH_FROM(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	RCVD_TLS_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[poczta.fm:email,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,syzkaller.appspot.com:url,suse.com:url,suse.de:mid,suse.de:dkim];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+]
X-Spam-Flag: NO
X-Spam-Score: -4.51
X-Spam-Level: 
X-Rspamd-Queue-Id: EBF0E86D2E
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action

(cc: Slawomir)

Hi,

thanks for the fix. Please see below for changes that should go into the 
patch.

Best regards
Thomas

Am 25.08.26 um 09:44 schrieb sashiko-bot@kernel.org:
> Thank you for your contribution! Sashiko AI review found 2 potential issue(s) to consider:
> - [High] The exact equality check for BAR0 size (`!= CIRRUS_VRAM_SIZE`) incorrectly rejects valid QEMU configurations with larger VRAM.
> - [High] The VRAM size validation check is placed after `aperture_remove_conflicting_pci_devices()`, meaning the firmware framebuffer is permanently destroyed even if the driver ultimately fails to bind.
> --
>
> --- Patch [1]: [PATCH] drm/cirrus-qemu: Validate BAR0 size during probe ---
> commit 75467ead62a494b6afbc057c666ab59f7e4b8915
> Author: Slawomir Stepien <sst@poczta.fm>
>
> drm/cirrus-qemu: Validate BAR0 size during probe
>
> This commit adds a check during PCI probe to verify that the BAR0 resource
> length equals CIRRUS_VRAM_SIZE. This is intended to prevent supervisor write
> page faults caused by writing past the end of the mapped I/O memory when
> smaller BARs are presented.
>
> Link: https://syzkaller.appspot.com/ai_job?id=ba262a3a-bccf-4ad8-a1b0-583c55d34fd6
>
>> diff --git a/drivers/gpu/drm/tiny/cirrus-qemu.c b/drivers/gpu/drm/tiny/cirrus-qemu.c
>> index 075221b431d37..70c995025f508 100644
>> --- a/drivers/gpu/drm/tiny/cirrus-qemu.c
>> +++ b/drivers/gpu/drm/tiny/cirrus-qemu.c
>> @@ -602,6 +602,9 @@ static int cirrus_pci_probe(struct pci_dev *pdev,
>>   
>>   	dev = &cirrus->dev;
>>   
>> +	if (pci_resource_len(pdev, 0) != CIRRUS_VRAM_SIZE)
>> +		return -ENODEV;
>> +
> [Severity: High]
> Does this strict equality check unintentionally break valid QEMU
> configurations that have more than 4 MB of VRAM?
>
> When a VM is booted with a configuration like -device cirrus-vga,vgamem_mb=8,
> the BAR0 size will be 8 MB. The check in cirrus_pci_probe() evaluates
> to true (since 8 MB is not equal to 4 MB) and rejects the device by
> returning -ENODEV.
>
> Would it be safer to check if pci_resource_len(pdev, 0) < CIRRUS_VRAM_SIZE
> instead of requiring an exact match?
>
> [Severity: High]
> Is it safe to place this validation check after the call to
> aperture_remove_conflicting_pci_devices() earlier in cirrus_pci_probe()?
>
> If this new size check fails (either due to a malformed device or a larger
> valid VRAM size), cirrus_pci_probe() aborts with -ENODEV. However, because
> aperture_remove_conflicting_pci_devices() was already executed at the start
> of the probe function, the firmware framebuffers (like efifb or simplefb)
> have been permanently destroyed.
>
> Could this leave the system with a dead display output? Would it make sense
> to move this PCI configuration check to the very beginning of the probe
> function, before any destructive actions occur?
>
>>   	cirrus->vram = devm_ioremap(&pdev->dev, pci_resource_start(pdev, 0),
>>   				    pci_resource_len(pdev, 0));
>>   	if (cirrus->vram == NULL)

-- 
--
Thomas Zimmermann
Graphics Driver Developer
SUSE Software Solutions Germany GmbH
Frankenstr. 146, 90461 Nürnberg, Germany, www.suse.com
GF: Jochen Jaser, Andrew McDonald, (HRB 36809, AG Nürnberg)


