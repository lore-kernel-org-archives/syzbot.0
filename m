Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D3B141A572
	for <syzbot@lists.linux.dev>; Tue, 28 Jul 2026 09:03:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785229391; cv=none; b=P8/v/MUPfT481e9/BOB1DoW/tixto3zJLzlbvqHz3Op13gxwgzHyS0yIDy7S2VckJK4K8V4pdPLVO0o2npgSR2RwHKHEHoCCbqoximEJL85KiAjq8uv+Kvl3Ih14WInyFoag9J4yZcbkMhb3dcFZjqWRMWG8xFiwG2QwOkgeFNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785229391; c=relaxed/simple;
	bh=xRtFpwBE5btOYRqc4YyVaCj34uRwpPKlqYCWnsbY4Do=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JmpO6+K6o6rmgofeXt5Jzo1T+gNMh6X2cTSnt3pLC5efadOrZ0l2/BOc/10DFmOu/UefjJjqab2mgKY/i2VlY/gqlNseWLr6ZHVu7Xp1t0s9KzT1fzSHg0cMxCAE2pQFSqfTMSLD8a2+tVIMAz0QNOPFLDXQkJddHtO2wTcUQy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Naethge3; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Naethge3"
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-c1c52d920b8so481849466b.2
        for <syzbot@lists.linux.dev>; Tue, 28 Jul 2026 02:03:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1785229388; x=1785834188; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=q81FhYY1LJ5QPAojqGqmrpxbE8W117HJkzYSfq3Ntzk=;
        b=Naethge3N3PuB00SfSanTnFI6g2axMgh/PK5U2B5EPcpOlXVaeqM39OF/ZJDhE0v2F
         KA31xwxxlR/pMnw4ctz+1MXb7eAjryIr5Hk/o3tA9g0Sd7SksD6r6f6MgghKAiyqHmBe
         igLJpk9rq/hC72sD661hjzniY5WibVhWor2J4Tmo4qwOqPCg5YH2VD8sf2DcB9OOyeHy
         lHCfz1LmUIRoCsI6+ZT7SLAQYjk86L7QLpiGAIemX+XjCezvzxv9CTCgbav8/6zSgTVW
         x4lmL3ZqKKGdC2nv3Ff0Pvv2dsHLApPqjqpkDav8gEy3xEeXx4DlWANb/hiVRz+KL6AL
         fY5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785229388; x=1785834188;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=q81FhYY1LJ5QPAojqGqmrpxbE8W117HJkzYSfq3Ntzk=;
        b=AmujMPAUqh4SOnyztwyZrlktdNL6Es2IyM+n8DA9y2UrHxIET/NPxagHbC2astbGMy
         tTdU8UNH0/6huPbijaStVeQLMNY87uKkaOHNVNyFgoFiiKrPzvObPVI2T5TZ/BjCxkaw
         ErlPxRMS3hYXuwgSL1HcmhNEWdnU9Z55tS0ZSyKK/UFxVDWb6W6XoGqpCu2BVXI8mLXm
         IDaYcpVb2Si0DThOS08ZDC1FPCMGuYsPOaiyZfuF2F9e+JF29rOZfi6vgK+rboyC5iSq
         rZAPAP2StxHhcNiJlpe8ox70zMq042tdTGtpJ9aUrbqxoYE5xVNPKpfzMrnbacuQiUbY
         KryA==
X-Forwarded-Encrypted: i=1; AHgh+Rrc1MGKxOWlHYi2dob5UXVJ5iZiP4vLcioPkT61frREoccmaGQsf4GwXu4PG9tlp6l7zT5mtc4=@lists.linux.dev
X-Gm-Message-State: AOJu0Yzy6WD7vqYatgqES0LrkPV6UiyKw8eKhlBJLCbnRKTg7UlRfVPF
	oeyAlSJLhqGJwiHnHFjuK1wr6rPfHXlAoqRTTSREyfri5ZCzW/GKAhYGumvrG6xJOTE=
X-Gm-Gg: AR+sD10Uf9bvCZWms9Y+IqCHFPyMMwsc4oCSy+dkK/QAH+9J4qwEwWnod+5m/EHCLuJ
	LA0L9MUSt/uPI9dI8IohZAmIIWXfAQIDWb16ygNN8kKq/Wo5WRpPHtZC+oCUDYLzR3NiYlukPU3
	115nNPzly722EQ7mSXMfdnDU0k86dOmupDEbeOydIKfy11ZITnQfIYjv89HJNeJlHFM7F0o8xzX
	660pPCNpZa9mO6tiS8YUSTPDSPLldleMeMsmByjb9tloRLMneRsXTVK1EK0qmroTZXYQ914/Uum
	fDjiypwJ+8TZjcOBqtD07huPNXOpfHbGRBg6BWMhJ4Uwm23iPm3YccFsFpMBOEO8rebHnLtnVNu
	YZdmPckyc/HvNBmq9HC4Arh86qV7Vry6lTpcMkHHOa6nzT+Ec6/84r5h+dSH60hC4AQ5EZwY=
X-Received: by 2002:a17:907:8b99:b0:c16:28b9:a203 with SMTP id a640c23a62f3a-c1f7251a933mr70709566b.38.1785229387596;
        Tue, 28 Jul 2026 02:03:07 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84e5346dc8bsm4151943b3a.61.2026.07.28.02.03.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Jul 2026 02:03:06 -0700 (PDT)
Message-ID: <9d9d207e-ad2a-4af6-9d0b-9a2bfc61d442@suse.com>
Date: Tue, 28 Jul 2026 18:33:00 +0930
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: commit current transaction in
 btrfs_relocate_block_group
To: syzbot <syzbot@kernel.org>, syzkaller-bugs@googlegroups.com,
 Bartosz Chronowski <immersa.bartosz.chronowski@gmail.com>,
 Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>,
 linux-btrfs@vger.kernel.org, "Yan, Zheng" <zheng.yan@oracle.com>
Cc: linux-kernel@vger.kernel.org, syzbot@lists.linux.dev
References: <a06b5077-baa5-473f-9c65-bf72ac651b14@mail.kernel.org>
Content-Language: en-US
From: Qu Wenruo <wqu@suse.com>
Autocrypt: addr=wqu@suse.com; keydata=
 xsBNBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAHNGFF1IFdlbnJ1byA8d3F1QHN1c2UuY29tPsLAlAQTAQgAPgIbAwULCQgHAgYVCAkKCwIE
 FgIDAQIeAQIXgBYhBC3fcuWlpVuonapC4cI9kfOhJf6oBQJnEXVgBQkQ/lqxAAoJEMI9kfOh
 Jf6o+jIH/2KhFmyOw4XWAYbnnijuYqb/obGae8HhcJO2KIGcxbsinK+KQFTSZnkFxnbsQ+VY
 fvtWBHGt8WfHcNmfjdejmy9si2jyy8smQV2jiB60a8iqQXGmsrkuR+AM2V360oEbMF3gVvim
 2VSX2IiW9KERuhifjseNV1HLk0SHw5NnXiWh1THTqtvFFY+CwnLN2GqiMaSLF6gATW05/sEd
 V17MdI1z4+WSk7D57FlLjp50F3ow2WJtXwG8yG8d6S40dytZpH9iFuk12Sbg7lrtQxPPOIEU
 rpmZLfCNJJoZj603613w/M8EiZw6MohzikTWcFc55RLYJPBWQ+9puZtx1DopW2jOwE0EWdWB
 rwEIAKpT62HgSzL9zwGe+WIUCMB+nOEjXAfvoUPUwk+YCEDcOdfkkM5FyBoJs8TCEuPXGXBO
 Cl5P5B8OYYnkHkGWutAVlUTV8KESOIm/KJIA7jJA+Ss9VhMjtePfgWexw+P8itFRSRrrwyUf
 E+0WcAevblUi45LjWWZgpg3A80tHP0iToOZ5MbdYk7YFBE29cDSleskfV80ZKxFv6koQocq0
 vXzTfHvXNDELAuH7Ms/WJcdUzmPyBf3Oq6mKBBH8J6XZc9LjjNZwNbyvsHSrV5bgmu/THX2n
 g/3be+iqf6OggCiy3I1NSMJ5KtR0q2H2Nx2Vqb1fYPOID8McMV9Ll6rh8S8AEQEAAcLAfAQY
 AQgAJgIbDBYhBC3fcuWlpVuonapC4cI9kfOhJf6oBQJnEXWBBQkQ/lrSAAoJEMI9kfOhJf6o
 cakH+QHwDszsoYvmrNq36MFGgvAHRjdlrHRBa4A1V1kzd4kOUokongcrOOgHY9yfglcvZqlJ
 qfa4l+1oxs1BvCi29psteQTtw+memmcGruKi+YHD7793zNCMtAtYidDmQ2pWaLfqSaryjlzR
 /3tBWMyvIeWZKURnZbBzWRREB7iWxEbZ014B3gICqZPDRwwitHpH8Om3eZr7ygZck6bBa4MU
 o1XgbZcspyCGqu1xF/bMAY2iCDcq6ULKQceuKkbeQ8qxvt9hVxJC2W3lHq8dlK1pkHPDg9wO
 JoAXek8MF37R8gpLoGWl41FIUb3hFiu3zhDDvslYM4BmzI18QgQTQnotJH8=
In-Reply-To: <a06b5077-baa5-473f-9c65-bf72ac651b14@mail.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/7/28 18:15, syzbot 写道:
> From: Bartosz Chronowski <immersa.bartosz.chronowski@gmail.com>
> 
> During block group relocation, btrfs_relocate_block_group() is called to
> relocate a block group. It first makes the block group read-only by calling
> btrfs_inc_block_group_ro(). If there are pending space reservations or
> pinned extents in the current transaction, making the block group read-only
> can fail, leading to a transaction abort and a warning in
> cleanup_transaction() during the transaction commit in
> prepare_to_relocate().
> 
> To fix this, commit the current transaction before calling
> btrfs_inc_block_group_ro() in btrfs_relocate_block_group(). This drains the
> current transaction before the block group becomes read-only,

What if a another workload triggered space reservation between the just 
committed transaction and btrfs_inc_block_group_ro()?

> ensuring that
> pending extents are unpinned and space reservations are committed. This
> does not claim global settlement of every reservation or later transaction,
> but it provides a clean state for marking the block group read-only. The
> setup commit in prepare_to_relocate() remains necessary because it commits
> the transaction started during the relocation setup (such as creating the
> reloc tree) to ensure everything is in a consistent state before starting
> to move extents.
> 
> WARNING: fs/btrfs/transaction.c:2068 at cleanup_transaction+0x727/0x7c0
> Call Trace:
>   <TASK>
>   btrfs_commit_transaction+0x262c/0x30b0 fs/btrfs/transaction.c:2664
>   prepare_to_relocate+0x3dd/0x4e0 fs/btrfs/relocation.c:3541
>   relocate_block_group+0x141/0xe90 fs/btrfs/relocation.c:3566
>   do_nonremap_reloc+0xa7/0x560 fs/btrfs/relocation.c:5323
>   btrfs_relocate_block_group+0x6e2/0xaf0 fs/btrfs/relocation.c:5490
>   btrfs_relocate_chunk+0x114/0x830 fs/btrfs/volumes.c:3647
>   __btrfs_balance+0x1b6e/0x29e0 fs/btrfs/volumes.c:4586
>   btrfs_balance+0xaa6/0x1180 fs/btrfs/volumes.c:4973
>   btrfs_ioctl_balance+0x3dd/0x640 fs/btrfs/ioctl.c:3474
>   </TASK>
> 
> Fixes: 3fd0a5585eb9 ("Btrfs: Metadata ENOSPC handling for balance")
> Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot
> Reported-by: syzbot+021d10c4d4edc87daa03@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=021d10c4d4edc87daa03
> Link: https://syzkaller.appspot.com/ai_job?id=ca6bd6c4-fbcf-4533-af07-79b4a0eba74d
> Signed-off-by: Bartosz Chronowski <immersa.bartosz.chronowski@gmail.com>
> 
> ---
> diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
> index fb85bc8b3..05f5110c2 100644
> --- a/fs/btrfs/relocation.c
> +++ b/fs/btrfs/relocation.c
> @@ -5430,6 +5430,10 @@ int btrfs_relocate_block_group(struct btrfs_fs_info *fs_info, u64 group_start,
>   	if (ret < 0)
>   		goto out_put_rc;
>   
> +	ret = btrfs_commit_current_transaction(extent_root);
> +	if (ret)
> +		goto out;
> +
>   	ret = btrfs_inc_block_group_ro(rc->block_group, true);
>   	if (ret)
>   		goto out;
> 
> 
> base-commit: 8cdeaa50eae8dad34885515f62559ee83e7e8dda

