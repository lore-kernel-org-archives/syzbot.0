Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793616160;
	b=QtOGgoOLcF93G9fRlW1dKIKEXilci1jilnillf8fyrQ7U+ruYGiLpQ9mGfBvnkHhXx2t
	 JnvtOBw4zdwnUQrG1Dgmvr5Okd++JXfOmYNieYTf/oPWc4HWAh5DeqqZz/mGbNyqT8/uA
	 27ky8f0s//G59/lzJXXc55e96+YK94HTFqzfcPETS/p/rsPesdSXZC7IQT33VzDKzUqrq
	 m7KJ7gjjBp0oCO/hJX1Oqg/qg+OWqqM0kVabakklJ+YjZCZStA2ryCmVzKdSrQHTzTDeY
	 V3hf41fBVktpOLw3PXr4yEFkXc3gLn6S3/xaVbsS3ONj3qbUNEcCLeuqmO1gi4Vlmdg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793616160;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=KXRF5NFKMdcuYVka3K7Jjgx1eiDiSmm0GhEZsRoOLRA=;
	b=kIp2DWsHIpxkhN691GnbzleJLkby58zY2QxNcZn/bU4tjuqTzhuDeBNSrFt0iqab/ATY
	 CkTP/pxlMZiXj4quAVLG+ruTjr70tjiqV6WZn5TAaliffnOTlKtM9CZX3HPyAVwXN8+zh
	 ps7isBk4gF8VoIH3T08SBqhCAxusB3UJIp+8Yi/psO36Oj8YmFS0K17MmPPvBmotiiwdx
	 N5YJ7LwjCyJqDQXRxQAoCKEc9nAQBqSuw4uSqFFBGWLWjOggM3S3RDeSpz2ZIs/SCXiJD
	 7zh/YQpFNAxCAwXorIbdKP1q94+zr3R5eCXiXoxJUxpmkU1/XtkJaBfXMbi10CHZ0fg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=r4263GOm;
	arc=none smtp.remote-ip=209.85.218.46
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05CC460A6F51
	for <syzbot@lists.linux.dev>; Mon,  2 Nov 2026 10:42:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 05CC460A6F51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=r4263GOm
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-c37b612635bso385759666b.3
        for <syzbot@lists.linux.dev>; Mon, 02 Nov 2026 02:42:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793616158; x=1794220958; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=KXRF5NFKMdcuYVka3K7Jjgx1eiDiSmm0GhEZsRoOLRA=;
        b=r4263GOmPUClj9CUO5ycyXpmqkapj5lKpL7lFKE1Ew6r6uJ5TSFwGT/I6UEOhByhWb
         JdgNU/0Mpoqq2V1Cqr8UHlNeafD8WYzf4BgVKi48jFtS2BebokpNEjBoXHBGeFx3GLHG
         tS2H56tOgSKdk+T4FakQtD1ryBeFKAGLSATOMkAvzGAi0QimTLkKvt5Iyik7QaOk2kyo
         5ko3gU/P+yXGz+VQfPVTqkTQsP+lICZ1fU4FojxCWveQvLsQ6EDulCoCgW8Jn49QxGdV
         OuIw3K9htyvXy8l0kN97ifURG5z6RjRDyJyly10rgrFQDf6mjm+Mt4fA4NpeevKFRGUF
         c0vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793616158; x=1794220958;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=KXRF5NFKMdcuYVka3K7Jjgx1eiDiSmm0GhEZsRoOLRA=;
        b=p3NE8OCc46uewE5So7lDHdGm273ZM1MXnGm7YQdMON1E8Xnj/lRjlNef4Y213jtdp0
         M/o0vmWj6PX4duFVzMACShne/POXKay9G7tZp9+Kd5MBjxtT1CfPpGq64crb7hGL+Pom
         bB3BZqyRJ0kkBQqNdvA0Jr4oaBHafZsHvXLSGsVFqOqtrfO6Dy++xLqNh1CmCDoaW813
         jm0esw1Uqd0g5IDhKLz9YEk0F+fDTzjYPakl1HlzP3Se+2ZF4Ar9jvKH7kCbytbP60el
         FlIDVzZ7lX/Zx2sUFeKAqmKKFy3jxb8zKhIvnEv2XkNgMVmtu84EH43UMMU3yPkip8BW
         QVBA==
X-Forwarded-Encrypted: i=1; AKwUvBw7qOjqfuswzy3A0SRSTaOfqrgVKw53a5rp3tYdbufRR0vTBFuve43xLtu91+mN3ex85A/Vzl0=@lists.linux.dev
X-Gm-Message-State: AFq9FYLDloKmLnZQNjuNuZo19AF09C8N/2rxIxNMO2nlbeEQ9sc+zv2U
	DNZfLy4a1DrV5jVQMfwdaDdig8zd7vZ0IdFSVsIWMeFZOc+pJ0Zl7Vr/RaPQZoXfqRA8oA==
X-Gm-Gg: AYBFou1WRfIfeMX0xLjd21Rcq/mopLNFTjS+0ZSu11tZvkKepLtZmfwBDFEwHWHphak
	0xrGaQIu2p9Zxs9wY6KT40+y3oH9iyy+c4vkk/PJa7ygPvbRt+iMbg6n0KGlaczg1AeWfphvNf3
	fYlEh4HfmxZQ6OEN5wkVGQ4qhCiZxtAMCJX3+29Rv0v+uRYYcIRLzX4i/qB1xfjVBSzhWiuxTRW
	CTR0gSrJ18acnrj8ywAlCyNL5s9BaLiGqy9vbYJa92FX559DJRuLasehZA/tplVEIFVOaBzS+W3
	2JWkG5qOHZog6JGmOdDxSPxeSkO+Pn2uClLW93kmVZaixZPIeFkPfgI+tAY8NvWbTwzGxalGKil
	N9xh4LvWc3V+L0CjLoGfnDvvmOzU6QIVIi6+5EFRFG6Cqa7BOuY7KSlpyatg0j4oo45T/ABP4rp
	ATPg70WE02Bb9QGbvNJdCYZGaFcoJCxw4Adp7XTj2iJQJl0vLKf6NpK427Q08o3xl5TkT7XL4Z/
	IA0tmXR1/j/ptZRGrLxZ1+/FKCQVfv3rr3RFj/dBBoW6alC42ssv9wIwXw6entysMH1HHU3Yqaf
	yBBp7g3QCGMVkejJTW0DQj4k3R0EcpEeCYx1NOhBiWMCM/ctdlrbUe6+ILAHCFfxaxkppBD4Wzv
	8q8Nc9LAk6OEtBO5MZyVdUy5Wiscb0UpTpKG12626sRV9cqpKpjvWW9ce0DyAZY6fUxJ9Ik1n/5
	oYvb0PxXbsRmvDu3iY/DOHLFCf08Nbrm+KihwEGeI2i3FHa5bJuwt792qhOyct3RI=
X-Received: by 2002:a17:907:6d20:b0:c46:75e7:25af with SMTP id a640c23a62f3a-c4ca7a0dcb0mr776863566b.11.1793616158273;
        Mon, 02 Nov 2026 02:42:38 -0800 (PST)
Received: from [192.168.100.100] (87-205-15-91.static.ip.netia.com.pl. [87.205.15.91])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c4cabc18ec5sm368948866b.12.2026.11.02.02.42.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Nov 2026 02:42:37 -0800 (PST)
Message-ID: <6f97dc68-b2e1-494a-b0f8-13c36fd84044@gmail.com>
Date: Mon, 2 Nov 2026 11:42:36 +0100
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Post: <mailto:syzbot@lists.linux.dev>
List-Help: <mailto:syzbot+help@lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
List-Owner: <mailto:syzbot+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: sg: Fix shift-out-of-bounds in sg_build_indirect()
To: syzbot <syzbot@kernel.org>, syzkaller-bugs@googlegroups.com,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 Doug Gilbert <dgilbert@interlog.com>, linux-scsi@vger.kernel.org,
 "Martin K. Petersen" <mkp@kernel.org>,
 FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-kernel@vger.kernel.org, syzbot@lists.linux.dev
References: <e68a2050-dc97-4531-95e2-29f4d1a109cb@mail.kernel.org>
Content-Language: en-US
From: Krystian Kaniewski <krystianmkaniewski@gmail.com>
In-Reply-To: <e68a2050-dc97-4531-95e2-29f4d1a109cb@mail.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/17/26 10:04, syzbot wrote:
> From: Krystian Kaniewski <krystianmkaniewski@gmail.com>
> 
> Writing an invalid value such as 0 or a negative number to
> /sys/module/sg/parameters/scatter_elem_sz, or setting it at module load
> time, causes a shift-out-of-bounds bug during subsequent device operations.
> In init_sg(), scatter_elem_sz is checked against PAGE_SIZE, but because
> PAGE_SIZE is unsigned, the comparison is unsigned and bypasses negative
> values. When opening a device via sg_open(), the driver calls
> sg_build_indirect() to allocate scatter-gather buffers. In
> sg_build_indirect(), scatter_elem_sz is read into the local snapshot
> variable num. Because PAGE_SIZE is unsigned, comparing num against
> PAGE_SIZE also results in an unsigned comparison that bypasses negative
> values. Furthermore, even if the condition is met, the code updates the
> global scatter_elem_sz and scatter_elem_sz_prev variables but leaves the
> local snapshot variable num unupdated before get_order(). As a result, an
> invalid value such as 0 remains in num and is passed to order =
> get_order(num). Calling get_order(0) is undefined and underflows to 52 on
> 64-bit systems, causing ret_sz = 1 << (PAGE_SHIFT + order) to compute 1 <<
> 64. Shifting a 32-bit int by 64 bits triggers a UBSAN shift-out-of-bounds
> warning:
> 
> UBSAN: shift-out-of-bounds in drivers/scsi/sg.c:1887:13
> shift exponent 64 is too large for 32-bit type 'int'
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
>  ubsan_epilogue+0xa/0x30 lib/ubsan.c:233
>  __ubsan_handle_shift_out_of_bounds+0x36d/0x400 lib/ubsan.c:494
>  sg_build_indirect+0x559/0x870 drivers/scsi/sg.c:1887
>  sg_build_reserve drivers/scsi/sg.c:1997 [inline]
>  sg_add_sfp drivers/scsi/sg.c:2177 [inline]
>  sg_open+0x1128/0x18a0 drivers/scsi/sg.c:349
>  chrdev_open+0x4d9/0x600 fs/char_dev.c:411
>  do_dentry_open+0x816/0x1380 fs/open.c:996
>  vfs_open+0x3b/0x340 fs/open.c:1101
>  </TASK>
> 
> Fix this by casting PAGE_SIZE to int in both init_sg() and
> sg_build_indirect() so that the comparisons are signed and negative values
> do not bypass the check, and by updating the local snapshot variable num to
> PAGE_SIZE when num < (int)PAGE_SIZE in sg_build_indirect() before
> get_order() is called.
> 
> Fixes: 10db10d144c0 ("sg: convert the indirect IO path to use the block layer")
> Assisted-by: Gemini:gemini-3.8-flash syzbot
> Reported-by: syzbot+270f1c719ee7baab9941@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=270f1c719ee7baab9941
> Link: https://syzkaller.appspot.com/ai_job?id=1d412b83-5bbc-4d73-b690-4c798d45cee4
> Signed-off-by: Krystian Kaniewski <krystianmkaniewski@gmail.com>
> 
> ---
> diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
> index 5408f002e..46117d1a1 100644
> --- a/drivers/scsi/sg.c
> +++ b/drivers/scsi/sg.c
> @@ -1667,7 +1667,7 @@ init_sg(void)
>  {
>  	int rc;
>  
> -	if (scatter_elem_sz < PAGE_SIZE) {
> +	if (scatter_elem_sz < (int)PAGE_SIZE) {
>  		scatter_elem_sz = PAGE_SIZE;
>  		scatter_elem_sz_prev = scatter_elem_sz;
>  	}
> @@ -1875,9 +1875,10 @@ sg_build_indirect(Sg_scatter_hold * schp, Sg_fd * sfp, int buff_size)
>  
>  	num = scatter_elem_sz;
>  	if (unlikely(num != scatter_elem_sz_prev)) {
> -		if (num < PAGE_SIZE) {
> +		if (num < (int)PAGE_SIZE) {
>  			scatter_elem_sz = PAGE_SIZE;
>  			scatter_elem_sz_prev = PAGE_SIZE;
> +			num = PAGE_SIZE;
>  		} else
>  			scatter_elem_sz_prev = num;
>  	}
> 
> 
> base-commit: df2908090cda368b01ff43709f51890076c56157
Hi Martin, Doug,

A gentle ping on this patch. Patchwork currently shows it as deferred.
Is there anything you would like me to change, or should I simply leave
it pending?

Thanks,
-- 
Krystian Kaniewski
