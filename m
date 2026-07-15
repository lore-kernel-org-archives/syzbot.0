Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D7204418DC
	for <syzbot@lists.linux.dev>; Wed, 15 Jul 2026 12:25:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=100.103.45.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784118311; cv=pass; b=cj6FWaX6bfK3eZKDnfTrGwndSzAUZdElWyI0hhoTjCTCDqDYtS+agQr6O3OgR0186/EU/yUVZ8lwLLtQve5cgk5Cu30cb1eiGeYKBWOernLIV3zStZ3VU0MBucFcM23qa00TLPsGZnn9WAl+yxk3jgSNJeCa4R7Ei/P+k/qAzzM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784118311; c=relaxed/simple;
	bh=tJfiogHWeWDHXJKJvGNdM6STAkOYTunGbP1INq5kyRM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IWQFOObGo/ElXfqij6vycF4qSp6LWC8kIW3OKJhhhQ7n4A46zW5/zf76M08CITK74ZNPiY94M2JlzHt04/65GFtKTW07LYjLbhb9kz5r8UQjWv39QOeAo5dAWK7fbaAriGRE8+1IG2xnipBNQiUfkPgem8Nfj4D66c8CsWH+g4E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=poczta.fm header.i=@poczta.fm header.b=U/2s90vm; arc=pass smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=poczta.fm header.i=@poczta.fm header.b="U/2s90vm"
Received: by smtp.kernel.org (Postfix)
	id 4FAB81F00A3A; Wed, 15 Jul 2026 12:25:09 +0000 (UTC)
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=217.74.67.49
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1784118309;
	b=j6VU0PxZ2k2KT1yqsy8T39Qe7n86zWBoGFplohafO5RhruOeF19OT6fVXyqGJeuZWiT9
	 Y/+KsxG3yxE54iXhcXXvcUJhPfLwD7CLeAiWVp3a1Meq3v171ilOjlQfmI5+DWqrvsN7q
	 LWOcrgJEleUzW+rsKSpm7bwmoxcoSRczMaehFIkVSTEac1lD77LBn8pKeTP1/lmgUZ2vh
	 vZmsX5c9ks7/ZKGIEZl4TWVqpvOG32bQLz21GRulav0rFVRzzTlAo4C+igXoV2wXwsQIc
	 64Fbq53xuUCk428159I9nk+Bo4El+0tkstoDS7W9loKlB5eFqxZD/LuawbrHm54IzAw==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1784118309;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To:
	 DKIM-Signature;
	bh=szkplQV0tCXtlXsr42TsJMEqmmpTrYCs33Blad9txeA=;
	b=AOD7veYiIIQrxK6XaPldjwQDzn7q7Cip2MwfxxkivMKlQSSsPpcvsRjT6UmBgwjDT5oQ
	 g6wFKDcjR5ZK65ZdLbFaQfVZY0Q3AbHBI7wH5GhIIPXawsOEe0cuz5R34vjagrK0qMoRn
	 9a2ZBSTVujEe6Yw8MNC+6GlO0E1m3WJ/5Jc9309yXcIKuuxCda3M1mNmXQRHqIA8iKdee
	 i7Ll9OWeJOnwASgrcZaz/U3dy2rEl1Zx2SSGZQBNxuBnjsP/R3g2I3SlAwhpaWMNAoUII
	 8wqwxOXEH8uodqMuSl4rSjadERlyt7cKAsRWudY0oIn+6z+/1WE7lwMHY0h1EF5VbUw==
ARC-Authentication-Results: i=1; smtp.kernel.org; dkim=pass header.d=poczta.fm header.i=@poczta.fm header.a=rsa-sha256 header.s=dk header.b="U/2s90vm";
	dmarc=pass header.from=poczta.fm;
	spf=pass smtp.mailfrom=poczta.fm;
	arc=none smtp.remote-ip=217.74.67.49
Received: from smtpo49.interia.pl (smtpo49.interia.pl [217.74.67.49])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 267641F000E9
	for <syzbot@kernel.org>; Wed, 15 Jul 2026 12:25:06 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=poczta.fm header.i=@poczta.fm header.a=rsa-sha256 header.s=dk header.b=U/2s90vm
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.kernel.org 267641F000E9
Authentication-Results: smtp.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=poczta.fm
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=poczta.fm
Received: from nr200 (unknown [80.68.231.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by poczta.interia.pl (INTERIA.PL) with ESMTPSA;
	Wed, 15 Jul 2026 14:24:57 +0200 (CEST)
Date: Wed, 15 Jul 2026 14:24:55 +0200
From: Slawomir Stepien <sst@poczta.fm>
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Subject: Re: [PATCH RFC] fs/ntfs3: handle partial allocation in
 attr_data_get_block_locked()
Message-ID: <ald8F82-k3GK79RB@nr200>
References: <69fc5364-da7a-4a91-bdff-078af00db6f6@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <69fc5364-da7a-4a91-bdff-078af00db6f6@mail.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=poczta.fm; s=dk;
	t=1784118298; bh=szkplQV0tCXtlXsr42TsJMEqmmpTrYCs33Blad9txeA=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	b=U/2s90vmPVWxUP5rrs78qMUWsGRmSkRf4+ix7MqvU67fTWxbvTPnQh2mQSDfGJJQI
	 I5jmSC8SkuDWISTgFzqAiNs5ppRTRxI7dF1zPL5LiDQyQwqqLN8PdQBfzjxNhEOQw8
	 YPeeMH/x2GAJNrM+U/cEgawQthikHKDm5FEkCvuE=

#syz upstream

On lip 09, 2026 12:07, 'syzbot' via syzkaller-upstream-moderation wrote:
> When allocating clusters for a sparse or compressed attribute in
> attr_data_get_block_locked(), the requested virtual cluster number (vcn0)
> is aligned down to a frame boundary (vcn). The function then attempts to
> allocate a full frame of clusters.
> 
> If the disk is nearly full and highly fragmented, attr_allocate_clusters()
> might only manage to allocate a small fragment and return success with a
> partial allocation length. If this partial allocation is so small that it
> does not even reach the originally requested vcn0 (i.e., end <= vcn0), vcn0
> remains unallocated (a sparse hole).
> 
> When the code subsequently calls run_lookup_entry() for vcn0, it finds the
> original SPARSE_LCN entry, which triggers a WARN_ON(1).
> 
> Fix this by adding a check to verify if the partial allocation reached
> vcn0. If it did not (vcn0 >= end), treat this as an -ENOSPC failure and
> jump to the undo1 label. This safely rolls back the partial allocation,
> restores the original size, and repacks the runs, leaving the inode in a
> consistent state before returning the error to the caller.
> 
> WARNING: fs/ntfs3/attrib.c:1236 at attr_data_get_block_locked+0x1980/0x25d0
> fs/ntfs3/attrib.c:1236
> RIP: 0010:attr_data_get_block_locked+0x1980/0x25d0 fs/ntfs3/attrib.c:1236
> Call Trace:
>  <TASK>
>  attr_data_get_block+0x1f1/0x2a0 fs/ntfs3/attrib.c:979
>  ntfs_fallocate+0xd3d/0xf70 fs/ntfs3/file.c:670
>  vfs_fallocate+0x663/0x7f0 fs/open.c:338
>  ksys_fallocate fs/open.c:362 [inline]
>  __do_sys_fallocate fs/open.c:367 [inline]
>  __se_sys_fallocate fs/open.c:365 [inline]
>  __x64_sys_fallocate+0xbf/0x110 fs/open.c:365
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>  </TASK>
> 
> Fixes: 099ef9ab9203 ("fs/ntfs3: implement iomap-based file operations")
> Assisted-by: Gemini:gemini-3.1-pro-preview Gemini:gemini-3-flash-preview syzbot
> Reported-by: syzbot+7be6ad5cb228286af3e3@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=7be6ad5cb228286af3e3
> Link: https://syzkaller.appspot.com/ai_job?id=3c9dee6e-001d-4972-8bf6-f6c960708246
> To: "Konstantin Komarov" <almaz.alexandrovich@paragon-software.com>
> To: <ntfs3@lists.linux.dev>
> Cc: <linux-kernel@vger.kernel.org>
> 
> ---
> diff --git a/fs/ntfs3/attrib.c b/fs/ntfs3/attrib.c
> index c621a4c58..786fd0ec0 100644
> --- a/fs/ntfs3/attrib.c
> +++ b/fs/ntfs3/attrib.c
> @@ -1227,6 +1227,10 @@ int attr_data_get_block_locked(struct ntfs_inode *ni, CLST vcn, CLST clen,
>  	total_size = total_size0 + ((u64)*len << cluster_bits);
>  
>  	if (vcn != vcn0) {
> +		if (vcn0 >= end) {
> +			err = -ENOSPC;
> +			goto undo1;
> +		}
>  		if (!run_lookup_entry(run, vcn0, lcn, len, NULL)) {
>  			err = -EINVAL;
>  			goto out;
> 
> 
> base-commit: 8cdeaa50eae8dad34885515f62559ee83e7e8dda

-- 
Slawomir Stepien
