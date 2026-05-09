Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6399F2032D
	for <syzbot@lists.linux.dev>; Sat,  9 May 2026 07:31:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778311864; cv=none; b=t8UMNZPFccGciOs+8ep0GCAb9z3DfRyoSLxg85XDx05uNESOSA4LA8gL0hTEU+lXXgkzQZmjqJhN27k1CC7dqURhCpR37RNDuBykkZd1N5d55XWuuEWUyj7CAq/zWC+wmiHnB6bfwMMPdX2RJ2+1FGo5P9HlGuFy19Apb0kVcjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778311864; c=relaxed/simple;
	bh=Jqb5yoHNZh9ENP3p1v2/P3KYQxk1tLqiuO0HnDQgIQE=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=nnTepbII2p2g51lEqzfw9UeqHeILiZBL+Y0mD72qnTSVNE9TeWpz32tXjEKMNWaeFxr/h1KkuEU+XxCvf5iMdhCcNtSLrar447LAux1738C4nVwuy9b6GJ8W/cAQxxth4b3jWIeFzELUFcQVQMJEY2yyrR4nkXp+5tK8y8dlRAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix)
	id 08DEEC2BCB2; Sat,  9 May 2026 07:31:04 +0000 (UTC)
Received: from mail-oo1-f69.google.com (mail-oo1-f69.google.com [209.85.161.69])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 03650C2BCC4
	for <syzbot@kernel.org>; Sat,  9 May 2026 07:31:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.kernel.org 03650C2BCC4
Authentication-Results: smtp.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f69.google.com with SMTP id 006d021491bc7-6948d83a548so6346358eaf.0
        for <syzbot@kernel.org>; Sat, 09 May 2026 00:31:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778311862; x=1778916662;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JlvuAohsU/8jJl6Tpx0FJbRhS8sDkEtylgE4JNVOPE8=;
        b=FohnndN/vhJQmYLW7ZP6tHrc1s48fo0VnfUFvCeEDlR6JA7g86EwQopu2wNreU0tax
         OOMfDe+TyQGamAUIbCHXQXQCLvsfSLAbi3c0K2WNCyjbb0VA4WuJi5VcDdPtsqX1uP+T
         DDxJ7Z6IYoV9AEZuNDxMRq5NW+EbjURJSIqLLy5ziLDmcoa4qaX7zSR+U1tU31NBrcQ/
         CBVwEDDasifl3gioLufyj4RHJYabTiIHh+8EkGAiSfRh21y6du57yZIMZLCBzgdqT3a8
         yQfiArSBCRrF6ilCjMyW3yewBWzIk0F+8aMPDQ6w3wbxqqOB7DXE+I2ZiNajdvQ3Amwd
         za6A==
X-Forwarded-Encrypted: i=1; AFNElJ81QgZOWdEZahhS7fzwqQ4SciCNx9njIwUsLWlGR3vGskqZp/9g6L34NNC++KteFFQ5vdw8IAo=@kernel.org
X-Gm-Message-State: AOJu0YwksdwJXMgtJzCu6TBjaKQqGU5tPIGavBLqYpuacMdzvd9fn4LX
	U/QswR7Yw8DQeAEqIzXfK/Xia5JRpxYoQteBUfEU9salxSbQK4EAZn0qcYw5l8XKqnK67HZTKHz
	k/p1fRfhw82H4NxOuCnVZLeQo2LFraCSvVmWkRZTLPTe0c/M9NbvWz8bmXLs=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:607:b0:696:72c4:5da3 with SMTP id
 006d021491bc7-69998c95834mr9182533eaf.15.1778311861972; Sat, 09 May 2026
 00:31:01 -0700 (PDT)
Date: Sat, 09 May 2026 00:31:01 -0700
In-Reply-To: <CACT4Y+a_ts-XVcHgwSBt8fwQ-QP-qkc21b_0kva0ET1FU_XcRw@mail.gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69fee2b5.050a0220.1036b8.0008.GAE@google.com>
Subject: Re: [PATCH RFC] udf: Replace WARN_ON with error handling in __udf_add_aext()
From: syzbot <syzbot@syzkaller.appspotmail.com>
To: dvyukov@google.com
Cc: dvyukov@google.com, syzbot@kernel.org, syzbot@lists.linux.dev, 
	syzkaller-upstream-moderation@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

> #syz upstream

I see the command but can't find the corresponding bug.
Please resend the email to syzbot+HASH@syzkaller.appspotmail.com address
that is the sender of the bug report (also present in the Reported-by tag).

>
> On Sat, 9 May 2026 at 00:07, 'syzbot' via
> syzkaller-upstream-moderation
> <syzkaller-upstream-moderation@googlegroups.com> wrote:
>>
>> udf: Replace WARN_ON with error handling in __udf_add_aext()
>>
>> syzbot reported a crash triggered by a WARN_ON() assertion in
>> __udf_add_aext(). The assertion fails because a maliciously crafted UDF
>> image can contain a 0-length extent (which acts as an EOF marker) before
>> the end of the space declared by lengthAllocDescs. When udf_next_aext()
>> stops at this 0-length extent, epos->offset is left pointing to it,
>> which is strictly less than the end of lengthAllocDescs, triggering the
>> WARN_ON().
>>
>> WARN_ON() must not be used for conditions that can legitimately happen
>> due to corrupted filesystem images, as it can panic the kernel if
>> panic_on_warn is set. Instead, log the inconsistency using pr_err() and
>> fix the corruption by recalculating and setting i_lenAlloc and
>> lengthAllocDescs to the correct length based on epos->offset. This
>> effectively truncates any garbage data after the 0-length extent and
>> restores the filesystem to a consistent state.
>>
>> Fixing lengthAllocDescs before calling udf_write_aext() is crucial.
>> udf_write_aext() calls udf_update_tag(), which calculates a CRC over
>> the length specified by lengthAllocDescs. If we blindly add adsize to a
>> corrupted (artificially large) length, udf_update_tag() will read out
>> of bounds, causing a buffer overflow. By fixing the length first, we
>> ensure the CRC is calculated over the correct bounds.
>>
>> Finally, replace the WARN_ON(epos->offset + adsize >
>> inode->i_sb->s_blocksize)
>> with an error return. If this condition is met, continuing execution
>> will result in udf_write_aext() writing past the end of the block
>> buffer. Instead of just warning, log the error and return -EFSCORRUPTED
>> to safely abort the operation.
>>
>> Assisted-by: Gemini:gemini-3.1-pro-preview Gemini:gemini-3-flash-preview
>> To: <jack@suse.com>
>> To: <linux-kernel@vger.kernel.org>
>>
>> ---
>> diff --git a/fs/udf/inode.c b/fs/udf/inode.c
>> index 67bcf8375..f7266551e 100644
>> --- a/fs/udf/inode.c
>> +++ b/fs/udf/inode.c
>> @@ -2078,13 +2078,30 @@ int __udf_add_aext(struct inode *inode, struct extent_position *epos,
>>                 return -EIO;
>>
>>         if (!epos->bh) {
>> -               WARN_ON(iinfo->i_lenAlloc !=
>> -                       epos->offset - udf_file_entry_alloc_offset(inode));
>> +               if (iinfo->i_lenAlloc !=
>> +                   epos->offset - udf_file_entry_alloc_offset(inode)) {
>> +                       pr_err("udf: alloc length %u != offset %u\n",
>> +                              iinfo->i_lenAlloc,
>> +                              epos->offset -
>> +                                      (uint32_t)udf_file_entry_alloc_offset(
>> +                                              inode));
>> +                       iinfo->i_lenAlloc = epos->offset -
>> +                                           udf_file_entry_alloc_offset(inode);
>> +               }
>>         } else {
>>                 aed = (struct allocExtDesc *)epos->bh->b_data;
>> -               WARN_ON(le32_to_cpu(aed->lengthAllocDescs) !=
>> -                       epos->offset - sizeof(struct allocExtDesc));
>> -               WARN_ON(epos->offset + adsize > inode->i_sb->s_blocksize);
>> +               if (le32_to_cpu(aed->lengthAllocDescs) !=
>> +                   epos->offset - sizeof(struct allocExtDesc)) {
>> +                       pr_err("udf: alloc length %u != offset %zu\n",
>> +                              le32_to_cpu(aed->lengthAllocDescs),
>> +                              epos->offset - sizeof(struct allocExtDesc));
>> +                       aed->lengthAllocDescs = cpu_to_le32(
>> +                               epos->offset - sizeof(struct allocExtDesc));
>> +               }
>> +               if (epos->offset + adsize > inode->i_sb->s_blocksize) {
>> +                       pr_err("udf: no space left in block\n");
>> +                       return -EFSCORRUPTED;
>> +               }
>>         }
>>
>>         udf_write_aext(inode, epos, eloc, elen, inc);
>>
>>
>> base-commit: 7fd2df204f342fc17d1a0bfcd474b24232fb0f32
>> --
>> This is an AI-generated patch subject to moderation.
>> Reply with '#syz upstream' to send it to the mailing list.
>> Reply with '#syz reject' to reject it.
>>
>> See  for more information.
>>
>> --
>> You received this message because you are subscribed to the Google Groups "syzkaller-upstream-moderation" group.
>> To unsubscribe from this group and stop receiving emails from it, send an email to syzkaller-upstream-moderation+unsubscribe@googlegroups.com.
>> To view this discussion visit https://groups.google.com/d/msgid/syzkaller-upstream-moderation/cc1b2586-5c5b-45f1-ba7e-e6ca8265ab95%40mail.kernel.org.
>
> -- 
> You received this message because you are subscribed to the Google Groups "syzkaller-upstream-moderation" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to syzkaller-upstream-moderation+unsubscribe@googlegroups.com.
> To view this discussion visit https://groups.google.com/d/msgid/syzkaller-upstream-moderation/CACT4Y%2Ba_ts-XVcHgwSBt8fwQ-QP-qkc21b_0kva0ET1FU_XcRw%40mail.gmail.com.
