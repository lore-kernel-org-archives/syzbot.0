Received: from mail-wr2-f12.google.com (mail-wr2-f12.google.com [74.125.225.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FA69424D7C
	for <syzbot@lists.linux.dev>; Thu, 24 Sep 2026 08:19:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790237946; cv=none; b=JbBBrj+q+xQ0eB7bE4l8DuQJR9aULi9zEEc0gYO/VqJPYgOJ6cW2DB95fF3prU2V7NPdp1Qyoy+17NP18eEpEfRN91W4xAPXlbJBI6/sYZgXjAXpwCsd042mp3ZLxZ7GSUh2x7Xwgv894qnKbv/nFtMGplnUUSsDQUqx4p8Do6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790237946; c=relaxed/simple;
	bh=k8r4Mit6isxGbzezwZVQt+fP51xldiqWhFfQGJ/ZHwE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NMXnhYsSunfx8s3BI7AVKrP+Ce3Tbc1f+Ubt7ErxkQNsa/HY5Rc8x8p/igH4xBQ6NuCTs/DPEb4YNXEl4YcaSY21eu6xKLwLM+Ek9J0TYqvW2TE3NBzjt7PnOIj7NGPZB9h/IpblXGrui6wChdVxa6zC/KgkZ2Zg9m3WG/FPzqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SvqSZOAm; arc=none smtp.client-ip=74.125.225.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SvqSZOAm"
Received: by mail-wr2-f12.google.com with SMTP id ffacd0b85a97d-485933b24c3so1152994f8f.0
        for <syzbot@lists.linux.dev>; Thu, 24 Sep 2026 01:19:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790237943; x=1790842743; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=vPDmEiJWTqhxeivaya9n4navVYHJBo360qvjV6+gdg4=;
        b=SvqSZOAmU0ad7yajq5BD/UKkkR8JQ36jjFao/1HSmVSE+F/3WIsu41Ap7sniij4siS
         X2UV2VT7Er/fqXkLvBEenOQI22oF6Q414XB/3SoNgAYySIU1mUo1kUhzuGcHredkrkU+
         GGBJ99StWqTrT9pwlUxCRHV/TH2FgqshGDSGIvaF/Rx/0YM20rzuANm/BLFMtoVg8Yn8
         fivkhEzXY7FQHu0NkS46tuqmcpM52l7VoOjKgBjbfTEVgS6rDB/eSKVOZPFM4te4ZiPA
         Si9tTqkliq8mhYl+fFRNu67gRK47LMtM4+4qDaOADpd7uPMK/CBhX04aRNFDF0zGJ3Rw
         Z81A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790237943; x=1790842743;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=vPDmEiJWTqhxeivaya9n4navVYHJBo360qvjV6+gdg4=;
        b=1dtPs6HAR0iY3n9yqtNH0TFFVohb3IiX66kf/xgvDfvMCnODsL1XjLLTlZhTpAGSj+
         rjwJfqE6VUg5W1EhPeuYMm1VeXJD9uLk9hM7dpcGucq11t5diBCvRclgjc+4lsVpJMnM
         6d9rgx4IML3L0Sml3nXltGgJqK0QjlAZMVSwSnC/DKy5MhsIi4jtF7Je+S1+jmr8P1Al
         YrEjDwoANdloarkGy1GP4Irv5dZiM3SMFmIEl8JKzAmUy/j1HCdkszOkRdWdHE7psi28
         p0v7jQ4MppgoODO1+I4hv71CR75cNamEtkonBMdFX3dT+kN5ojqw3zQZX4A30+k/iJ/X
         RQDw==
X-Gm-Message-State: AFuF++lHZpgzkv22wchhzEsDukDqJsuuVKbkgY/fkAdytIf7J0fTeaZm
	uRiFwJDo88eT43j0MJnYr4l2iUNzT/L+E7ha31nIYxxhvfUwOol0BSB8
X-Gm-Gg: AYBFou0YUsSWrkA6BWBNzzjZxhEjqBLbfE44mqnW+jPB4iXFXhfCxtbQ3yOp6It1VO1
	L0OvkdUVcTFN1oixB6f0EA0x9aivj2IwXzV4m7WdITZZeok55yqhTVZdMXsySF2ElLqZd5bWhAF
	Bw9OGj020x7MaAmBx8PkOH0GHNX3bsb84YlHRePolIGn0AXZ1b7NbPWqfeP3IgSNviznPbqJ01O
	NzkQ79217Ujqakcl+19TTcI942gmbaA68a9HPwLnLGA1+JMtozeT0hNKmx2jKwW00JIIKbvFJVj
	Lv6Uf7jEOkZFuIcDNgMRWPhiikumuZI4H/jQa2cBrtrYCeztC6q8hTS3RIpi0X8HFCtzRhSvA0b
	4uFEYN2fCso4D28/+nnUEIDpwgGvvNvTpFHxZtbZuRCGxD5qImQONYCtq/HXBel/wbEkDzVQfAw
	q6v7bNNCEFFsNKipgnUQw8WV8YD5YFTaybIX0pjOKyIMRDVY+JZZblOLsU7X5UmwyOoAXGEJvuV
	KJlgZwtK51Zjr04S8/JygQz0kkmtcVkrpTDFcAQVjCULrSgp/t4Y6IlIh1T7a5GY+On0bVXj76r
	oHd+5+WKAnkIQW7h60KW3unlpHPIOE32ave6vkY/XA0N/6DDetB13ZutlpZ75apoPpa8/aeCprC
	B5v+sRHYRChLAhSbiybyeiGpfbHk9OkkFCZXsK3KNrCgsb84=
X-Received: by 2002:a5d:5f83:0:b0:487:725:8204 with SMTP id ffacd0b85a97d-4887170f5a2mr2817418f8f.44.1790237942510;
        Thu, 24 Sep 2026 01:19:02 -0700 (PDT)
Received: from [192.168.100.51] (87-205-15-91.static.ip.netia.com.pl. [87.205.15.91])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-488687791cdsm11882885f8f.22.2026.09.24.01.19.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Sep 2026 01:19:02 -0700 (PDT)
Message-ID: <ba18d9bb-55b5-44ad-8bb6-e610630c465d@gmail.com>
Date: Thu, 24 Sep 2026 10:19:01 +0200
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC] fat: set buffer uptodate before dirtying in
 vfat_update_dotdot_de()
To: syzbot <syzbot@kernel.org>, syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
References: <012d4ac1-83f3-48af-8781-00fbbc4adc93@mail.kernel.org>
Content-Language: en-US
From: Krystian Kaniewski <krystianmkaniewski@gmail.com>
In-Reply-To: <012d4ac1-83f3-48af-8781-00fbbc4adc93@mail.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/22/2026 9:10 PM, syzbot wrote:
> During a directory rename operation (such as rename or rename-exchange),
> vfat_update_dotdot_de() is invoked to update the ".." directory entry to
> point to the new parent directory. In vfat_update_dotdot_de(), the buffer
> head is dirtied via mmb_mark_buffer_dirty(), and if synchronous directory
> operations are enabled (such as when mounted with MS_SYNCHRONOUS where
> IS_DIRSYNC() is true), sync_dirty_buffer() is immediately called to write
> the buffer to disk. If writing the buffer fails due to an I/O error on the
> underlying block device, the block layer completion handler clears the
> BH_Uptodate flag on the buffer head, and sync_dirty_buffer() returns an
> error.
> 
> When vfat_rename_exchange() or vfat_rename() encounters an error during the
> rename sequence, it jumps to an error rollback path to restore the original
> ".." entry by calling vfat_update_dotdot_de() again with the same buffer
> head. When vfat_update_dotdot_de() calls mmb_mark_buffer_dirty(),
> mark_buffer_dirty() checks whether the buffer is uptodate and triggers a
> warning because BH_Uptodate was cleared by the earlier write error:
> 
> !buffer_uptodate(bh)
> WARNING: fs/buffer.c:991 at mark_buffer_dirty+0x299/0x410 fs/buffer.c:991
> Call Trace:
>   <TASK>
>   mmb_mark_buffer_dirty+0x2c/0x1f0 fs/buffer.c:624
>   vfat_update_dotdot_de+0x90/0x1c0 fs/fat/namei_vfat.c:917
>   vfat_rename_exchange fs/fat/namei_vfat.c:1140 [inline]
>   vfat_rename2+0xe3e/0x1c90 fs/fat/namei_vfat.c:1171
>   vfs_rename+0xbd9/0xef0 fs/namei.c:6208
>   filename_renameat2+0x533/0x9a0 fs/namei.c:6326
>   do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
>   entry_SYSCALL_64_after_hwframe+0x77/0x7f
>   </TASK>
> 
> The in-memory data in the buffer head remains valid because it was
> originally read successfully from disk and only modified in memory; the I/O
> failure only indicates that writing it to the media failed. Fix this by
> calling set_buffer_uptodate() in vfat_update_dotdot_de() prior to marking
> the buffer dirty. This ensures that BH_Uptodate is set before
> mark_buffer_dirty() is called, preventing the spurious warning during error
> rollback.
> 
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Assisted-by: Gemini:gemini-3.8-flash Gemini:gemini-3.1-pro-preview syzbot
> Reported-by: syzbot+b0aebd03565f5774f7f8@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=b0aebd03565f5774f7f8
> Link: https://syzkaller.appspot.com/ai_job?id=047c8bd2-3171-476a-9977-78f4bc3e39b3
> To: "OGAWA Hirofumi" <hirofumi@mail.parknet.co.jp>
> To: <linux-kernel@vger.kernel.org>
> To: "Linus Torvalds" <torvalds@ppc970.osdl.org>
> 
> ---
> diff --git a/fs/fat/namei_vfat.c b/fs/fat/namei_vfat.c
> index da3e89c0b..b84228e7f 100644
> --- a/fs/fat/namei_vfat.c
> +++ b/fs/fat/namei_vfat.c
> @@ -914,6 +914,12 @@ static int vfat_update_dotdot_de(struct inode *dir, struct inode *inode,
>   				 struct msdos_dir_entry *dotdot_de)
>   {
>   	fat_set_start(dotdot_de, MSDOS_I(dir)->i_logstart);
> +	/*
> +	 * If a previous sync failed, the block layer's end-io handler clears
> +	 * BH_Uptodate. Set it uptodate before marking dirty to prevent
> +	 * mark_buffer_dirty() from warning during error rollback.
> +	 */
> +	set_buffer_uptodate(dotdot_bh);
>   	mmb_mark_buffer_dirty(dotdot_bh, &MSDOS_I(inode)->i_metadata_bhs);
>   	if (IS_DIRSYNC(dir))
>   		return sync_dirty_buffer(dotdot_bh);
> 
> 
> base-commit: 93f51579e7df248780214094418f205253383cc5

In `vfat_update_dotdot_de()`, remove the unconditional 
`set_buffer_uptodate(dotdot_bh)`. A failed synchronous write clears 
`BH_Uptodate`, and the rename rollback then warns when it dirties the 
same buffer. The current assignment can suppress that warning after one 
isolated failed write, but it claims that the whole buffer is valid 
after changing only two entry fields. It also races with I/O completion, 
which can clear the bit again. The buffer API requires serialization for 
this state change.

Keep the check in this shared VFAT helper. Take `BH_Lock` before testing 
`buffer_uptodate(dotdot_bh)`. If the bit is clear after waiting for I/O, 
unlock and return `-EIO` before changing the `..` entry or marking its 
buffer dirty. Keep the lock through `fat_set_start()` and 
`mmb_mark_buffer_dirty()`, then unlock before the existing 
`sync_dirty_buffer()` call. Preserve the existing buffer reference, 
rename cleanup, and first forward error. Do not duplicate the check in 
the rename rollback labels or expand this revision to the separate MSDOS 
path.

Update the subject so it describes validation rather than forcing the 
bit set. A suitable subject is `fat: validate VFAT dotdot buffers before 
dirtying`. Shorten the body to explain the failed write, the rollback 
warning, and how the locked state check avoids it. Remove the full stack 
trace and the broad claim that the held bytes are always valid after a 
failed write. Keep the existing `Fixes`, `Reported-by`, `Closes`, 
`Link`, and Gemini provenance tags.

