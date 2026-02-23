Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6B1F29AB07
	for <syzbot@lists.linux.dev>; Mon, 23 Feb 2026 14:36:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=10.30.226.201
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771857405; cv=pass; b=l7W1GkS3m/cBfs353Ol7lHRYknNrh4ZcgyFwY0FnDxq6F+xlIK7yEDa1sVdEjDf66pvvZtZIsb13xu5EEOYH3txdVeOE3dwMGc0zz3j2g2cYDYaAvqQFPw+apCL7ZlNI4lx07IgyJaLC7UUTLUZt88a0SI7kFA7UMeqgAraoiYI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771857405; c=relaxed/simple;
	bh=j88nzqxGDcpi5krckH7OxT+BN89QRDXkSXwvN5oduIc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uB6uoHtUB7lAb43CWOYUiBjy6B02P3V/l0nmZeGPfl/phDga/3CUBglpiuX2zIAPSLUX5cZ5f17yJCPBSa24zbV7B+YSaQjUGghoDiZ2zVFF6qtbXEYTZA/7Kq0DwSYGEFWY6PpWe2xuuGmGfaf4RWgPaZUFfGrYXwPfBMJSjRI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jtydElNq; arc=pass smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jtydElNq"
Received: by smtp.kernel.org (Postfix)
	id A0369C19423; Mon, 23 Feb 2026 14:36:44 +0000 (UTC)
Received: from mail-lj1-f171.google.com (mail-lj1-f171.google.com [209.85.208.171])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id B8F3DC116C6
	for <syzbot@kernel.org>; Mon, 23 Feb 2026 14:36:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.kernel.org B8F3DC116C6
Authentication-Results: smtp.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-lj1-f171.google.com with SMTP id 38308e7fff4ca-386b4c28ad6so38301211fa.0
        for <syzbot@kernel.org>; Mon, 23 Feb 2026 06:36:43 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771857401; cv=none;
        d=google.com; s=arc-20240605;
        b=IEsxdCLBKVlSpSPbXV1DtrlBIzZTwnjEt4HQJ3PMdKzJl5PwaXujrn6al39jT/fqMj
         LAgwsrI/lZaGGZlhC4kedZEy0p37U2wAOBmUrbu8WfnCQHMC12C/rTxKi9g3zNd60seC
         1dxS7s0gM/mKeJMXHy/5O2LbBxkhQDEGscYoyoaqlchivadv1XefrYSpslApRQSRiliP
         yD/KrgE7E8Sae+xgChhyIzN+fejFdZiTFnWM+E33xbHly9Zk5lQNuSdPfE4YKBW5dBWh
         YUiwzXUJEf0wc4/zdmOu/+BTu8WQFICsSb0RWnIUDlwGhjSAl9jTW7FFeqT9aD4FsfMs
         YWBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=MM3aKteGZmW/7GayY7dRMfYL0Xw/N+1zNqCVx7UjMoM=;
        fh=SHofx2R2YiD89hIR0fQNBeGZagudU1wZX4M9z2QENdA=;
        b=ZMfQzD+FZbCSbrOjVVUT72YlKcKZZeNrCmkQwxdVUdTCl9/JfZROxxQSNe6rcjFSMp
         HEnNrc4tveb/z2bowZ5PIsfEs3n6UnthAFExReQOVi2tCz/L9RkgtXuuFSRN/2DsqW1Q
         kxNmyS1Yvt9ddM70hBVJ725oUFTQUKHxFcSQ2Q9h6ONvXvmfdJiNtqG7REpfNjZuafWD
         PoSEUShYZ2ojtnXSKeicH7s0kAQx4m+MTp9BKM1oreBNSDjlkJ9hR7ztRdpWg2emIAuW
         NV0WKZ2aifxrNmyZtI7sdZdMbap18vt2uBsmXGwJub9S0XleEPoxwOKrDCRanjg0AEy3
         RbSQ==;
        darn=kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771857401; x=1772462201; darn=kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=MM3aKteGZmW/7GayY7dRMfYL0Xw/N+1zNqCVx7UjMoM=;
        b=jtydElNqSwgzdGnRl+n2Uvfg1z/51Wfx7h9qoHG5z9d6NhJr7YxGO4cS4wqzP+YgpC
         8xBypGrVvnu2XDKhSwaI70m35ZPbtBSkkdg9RXwR6xTXhe8mVzF4OA/W7NzxicAlt/Dq
         raF8i0DVWmrjyHW1aKq5Vm740aIxKAux5AC4Zb6Zg8Dc+XGZ+pslgI5lRxDdPRBD0+a6
         EuDVWXjG8FYfIP8cg69N5at1/wSAIJ3lQN4cRe0o+Zhnrh6C/xsI++S1thbRLEujocVh
         FJBxCg/99fEh41ZSAO7KE34pBIv4qWrAQE5Yt81y9ZkBH3vrvP+bTSDl2aZ7y5/QQ/ia
         iMxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771857401; x=1772462201;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MM3aKteGZmW/7GayY7dRMfYL0Xw/N+1zNqCVx7UjMoM=;
        b=YuaKsFtgUL9vjMXWfATTyflNiEN4TDeLl7lXO3Z+JEz0OuJF4Ht21P5neZDWd+Fwlb
         3nMp07lgmmpwzEuZT1tPaYMoiTctzWLCcZBag7ukUvnrkZW0X4W9V8mboOlbzzbmHG8+
         jvc0Pf0JWvhblqH4kgoRr26IjgTxC9GcaSNn3dYBR209rnaQVyJDc0W/fJYfn74Hl+vP
         85Joy5Gf3L/1Kf8LKdGWDY67I91YRQTotoLfBm6aWxFIIrszPXuNfL1WmfAx5wErkTgr
         3vvscPZdws3ihY732F4ml1XeFJTB50uOM89h7r64+3CW6rXSe5VKqa/sNSWEsAPTC5nf
         OMKg==
X-Gm-Message-State: AOJu0Yz2ZSs2+TbXFPjgkGU0La5BBvmAir32nEehLLPENN3+osWVmfCf
	om68t26aJtbFcKgozM8q74to5UmiY51YUQn4IJNMQUYOMVGRaEVS1Ukl3vKlVeqZbcGlNPHe8x3
	w2oj+ycoljwCO0+wMt6CKXG1ccqJmc0Bw4YFv7/BlwzCN5z+gwWHZkrS53cg=
X-Gm-Gg: AZuq6aJeUj+sdncLROdcQKOpEu4AwF9gh5ZoeyMqPmcgY9KyvIiWM5SjG9KW8AaqyMm
	OXzEoML1PI34fnZZxg1hldYZlcKmqWDJqU1+XkpcxRdvEDqbOlEBpnP5lR5CkfNx2dsbDV8oWxo
	nWbl9Q0d6URBR3YS/pE7xG8eTTGEA+2LC2MbwIdKcYyjjOR9gN+eKi1NZhd21v2iSBmbeSxYte9
	GpM8ZzhNDh0HZ15aTVdv3AZEuVqmzV1oo3oKE0fAbOPxtn6EUpDm6GSW8hgb74XNMbh3fJSn9X9
	XfeXwYJTnmFuO0glR0CqehjTV/SzL8c7/g6jDw==
X-Received: by 2002:a05:651c:31ce:b0:386:fd3e:bff0 with SMTP id
 38308e7fff4ca-389a5e94213mr23326701fa.39.1771857401229; Mon, 23 Feb 2026
 06:36:41 -0800 (PST)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260204092230.2540042-1-syzbot@kernel.org>
In-Reply-To: <20260204092230.2540042-1-syzbot@kernel.org>
From: Dmitry Vyukov <dvyukov@google.com>
Date: Mon, 23 Feb 2026 15:36:29 +0100
X-Gm-Features: AaiRm51tCsRBB7oayfu63tMMIZDAgJ7xHZQrvew4IJNGGTC0wVblcq8ltf71rm0
Message-ID: <CACT4Y+YVb8+XkEg2ucfYKjw-J7uy2Om19kzrGkXvkyxa9XTzvQ@mail.gmail.com>
Subject: Re: [PATCH] jfs: fix array-index-out-of-bounds in dbFindLeaf
To: syzbot <syzbot@kernel.org>
Cc: jfs-discussion@lists.sourceforge.net, shaggy@kernel.org, 
	ghandatmanas@gmail.com, syzbot+1afe7ef2d0062e19eeb3@syzkaller.appspotmail.com, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Wed, 4 Feb 2026 at 10:23, syzbot <syzbot@kernel.org> wrote:
>
> UBSAN reported an array-index-out-of-bounds issue in dbFindLeaf:
>
>   index 1365 is out of range for type 's8[1365]' (aka 'signed char[1365]')
>   CPU: 0 UID: 0 PID: 6287 Comm: syz-executor268 Not tainted ...
>   Call Trace:
>    ...
>    __ubsan_handle_out_of_bounds+0x115/0x140 lib/ubsan.c:455
>    dbFindLeaf+0x308/0x520 fs/jfs/jfs_dmap.c:2976
>    dbFindCtl+0x267/0x520 fs/jfs/jfs_dmap.c:1717
>    ...
>
> The issue is caused by an off-by-one error in the bounds check within
> dbFindLeaf. The function traverses the dmap tree to find free blocks.
> It uses a loop to iterate through the levels of the tree, calculating
> the index `x + n` to access the `tp->dmt_stree` array. The variable
> `max_size` represents the size of this array (CTLTREESIZE (1365) for
> dmapctl or TREESIZE (341) for dmaptree).
>
> The bounds check `if (x + n > max_size)` allows `x + n` to be equal to
> `max_size`. However, since the array size is `max_size`, the valid
> indices are `0` to `max_size - 1`. Accessing `tp->dmt_stree[max_size]`
> results in an array-index-out-of-bounds access.
>
> This can occur when the `dmt_height` field in the on-disk structure is
> corrupted or fuzzed to be larger than the fixed height supported by the
> `dmt_stree` array.
>
> Fix this by changing the condition to `>=` to correctly reject indices
> equal to or greater than the array size.
>
> Signed-off-by: syzbot@kernel.org
> Signed-off-by: Dmitry Vyukov <dvyukov@google.com>
> Fixes: 22cad8bc1d36 ("jfs: fix array-index-out-of-bounds in dbFindLeaf")
> Reported-by: syzbot+1afe7ef2d0062e19eeb3@syzkaller.appspotmail.com
> To: <jfs-discussion@lists.sourceforge.net>
> To: "Dave Kleikamp" <shaggy@kernel.org>
> To: "Manas Ghandat" <ghandatmanas@gmail.com>
> Cc: <linux-kernel@vger.kernel.org>
> Cc: <stable@vger.kernel.org>
> ---
> This patch was generated by Google Gemini LLM model.
> It was pre-reviewed and Signed-off-by a human, but please review carefully.
>
> Gerrit code review with full side-by-side diffs:
> https://linux-review.git.corp.google.com/c/linux/kernel/git/torvalds/linux/+/26122
>
> Change-Id: I92f694e86518349eafa132b2ba314d8dfff6c86e
> ---
>
> diff --git a/fs/jfs/jfs_dmap.c b/fs/jfs/jfs_dmap.c
> index cdfa699..18a7dc5 100644
> --- a/fs/jfs/jfs_dmap.c
> +++ b/fs/jfs/jfs_dmap.c
> @@ -2971,7 +2971,7 @@ static int dbFindLeaf(dmtree_t *tp, int l2nb, int *leafidx, bool is_ctl)
>                         /* sufficient free space found.  move to the next
>                          * level (or quit if this is the last level).
>                          */
> -                       if (x + n > max_size)
> +                       if (x + n >= max_size)
>                                 return -ENOSPC;
>                         if (l2nb <= tp->dmt_stree[x + n])
>                                 break;
>
> base-commit: 63804fed149a6750ffd28610c5c1c98cce6bd377

Hello jfs maintainers,

Is this patch on anybody radaras? Please merge the fix.
Or should JFS patches now be sent to a generic FS tree for merging?
