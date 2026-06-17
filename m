Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9A642FB969
	for <syzbot@lists.linux.dev>; Wed, 17 Jun 2026 02:41:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781664119; cv=none; b=OlJGYIM4/6M+9Pn2haCbkc66cTz9SuQF3/wXMrevU4o0Wit6Zs5DnQ0qBLbGJZ9n6Vp2HjVCV+s+6j5oso7rwkY6zRICgi8UDJDu68+fXuquPCjgadXdmIo7yvbmpnPr42mBO9aYS4BzLaWJRmR90cGhEdo7XIeHzu0X9J4zGeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781664119; c=relaxed/simple;
	bh=Lz55FVw/FiFzvvV1pJpJBW6xjuc9f4yAbDkp9gtshZo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=t+YgxSZ16UTS1EtF4p60jFODhrBOWKWw8vLR/WU7FgWXeJj8CN9mOgJQLKIYMXZtZThT96Hllqpot70ZUh+/oqBVgW15xEniPImUMHwGhPu3rOFblRZ/2X5DghSjqnUaqa873yoWbBVP86/BAJICm9JBYv7up98gpTvDFvcFhLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=AMFXRYcc; arc=none smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="AMFXRYcc"
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-6954b5a14c0so64034a12.0
        for <syzbot@lists.linux.dev>; Tue, 16 Jun 2026 19:41:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1781664116; x=1782268916; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=vA+ON9BWXCgajXFSiirszaYnsVqaL1L7Vrh58zTSnCg=;
        b=AMFXRYccI98WBkIwdXEnSC2x4UEDnk6Xi8gzdJ0YB7a2s5ef35obyIQwYeyTEqRMdC
         u/cCEnic5somz7hftE2v09mlSKkzNzRQ2d8YxOT9SmGJLVfZWhL//HxS4A53QYDjY9Md
         9IZOE1rS945aS5wuNZfINWOP21BELYJScL6yOug74oB7NxdsHkLa460Gk2JXo6nPDrTu
         ycKN3K/8du2e8k6TkYMS/kgXiPxondM6jM5SCd43aOkSL2P7BNx4/53EZoikyuAxLGPz
         LoP4m+3Up/VoYi7bZ/tV2mGuQA8DpF7yQTGZA/caCZBUGSx6yUf6fdD2bU6DOmDmv2iK
         uBow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781664116; x=1782268916;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vA+ON9BWXCgajXFSiirszaYnsVqaL1L7Vrh58zTSnCg=;
        b=rVoZJjsNkdy/3fFubdeaJ9IryaECE9EMj9BJhQx23il+8Jrk9Y6ZPRAIkGQO/e4lgc
         avD+uByky3SzVOckG0JfsgAf/7ST9a7RLZN38/EiVXEGZcFrqrN7jfpbljshUJ6EoFRE
         iuTCX7CCiGjPRK3VW55YIDYUsRZA3vqdNYWNDmlfdFHUgvNpeyBcv7sFe9B13G82hjna
         68jzSwiLCACGuwFY0mE2i6CHz7rJzOZeKMujaDZGrJjyC33NHyhE0zWsP/WhrXd43kUp
         5vu1d1TOEoUH1+v2WTHEy6wqZgDgy1qrxH85qKi8knucNgjKOZxSjLS9OSINP9OaHMnN
         3Raw==
X-Forwarded-Encrypted: i=1; AFNElJ9vicTh1Z9xx3euSM23PR6kXA59F83z4AoUY3fhQ44ptGd+J9srxgTPleBI05zozgnzMUWKwUg=@lists.linux.dev
X-Gm-Message-State: AOJu0YxnbGQF1UrPNFrJLIPkT5OlVez3XL5U66R+VkgVW8jaqtAU98O/
	d44x21hXdc0bBGyhQlRJDBxoBEzaaTrNNvVa+T3FnZKdjSsyOqJkwFdDJhrBBkawPOQ=
X-Gm-Gg: Acq92OFHM6tc5TtpM+nOGhMB049hZgZAUoi9KW4Y34eS9Yzzf37JELUkskVFxIgAxjZ
	ImRGtaOaIyiq3lo9WO9VhfmOzUaAalUdInPi/TOyufHJbik8LYFfooIX8or4uluS6Mo7FwsDMgF
	RFxBRyaB2wdlPazrWomQ/OjVskShwpNfcJbda3/eSGGbS/9NqxPh9+XUcbUf8WdPSjEsd9+8pQ7
	xjEo0LUH3+pvUCzOCLKN1pnQPOivtHZf/FoHP6KgeMKQVjW7rYEkrwOA8Q2X9GyfmnpPgxhJqoh
	/3i9GjySSqmn7+5bYnOuUej7QOkg8utoznGXHMeVLspYfVT86IZH8/A6jKlqu8PsFHgniJ6l0kQ
	wutuXfDT2iDIP6QuJuNOb9lE7EF7E+7jeONKJ/Qt/vB5/2LP0FDxJDGUrLLmEb6UglGmkbyv5FD
	KG6Sj2cnfS7po=
X-Received: by 2002:a05:6402:3214:b0:68b:6b71:4114 with SMTP id 4fb4d7f45d1cf-69547443c00mr396857a12.6.1781664116104;
        Tue, 16 Jun 2026 19:41:56 -0700 (PDT)
Received: from localhost ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8434accac96sm15635254b3a.14.2026.06.16.19.41.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Jun 2026 19:41:55 -0700 (PDT)
Date: Wed, 17 Jun 2026 10:41:52 +0800
From: Heming Zhao <heming.zhao@suse.com>
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: syzbot <syzbot@kernel.org>, Aleksandr Nogikh <nogikh@google.com>, 
	syzkaller-bugs@googlegroups.com, Joel Becker <jlbec@evilplan.org>, Mark Fasheh <mark@fasheh.com>, 
	ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org, syzbot@lists.linux.dev
Subject: Re: [PATCH] ocfs2: fix circular locking dependency in
 ocfs2_dio_end_io_write
Message-ID: <ajIIwKsnlN5yPawm@p15>
References: <97c902a6-3bcf-43ea-9b70-f1f136a6c3f2@mail.kernel.org>
 <ai-qJbXLuniGv-mr@p15>
 <6f95cc40-3014-4628-9739-28f47bec825b@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6f95cc40-3014-4628-9739-28f47bec825b@linux.alibaba.com>

On Tue, Jun 16, 2026 at 02:00:40PM +0800, Joseph Qi wrote:
> 
> 
> On 6/15/26 3:32 PM, Heming Zhao wrote:
> > On Fri, Jun 12, 2026 at 11:50:20AM +0000, syzbot wrote:
> >> From: Aleksandr Nogikh <nogikh@google.com>
> >>
> >> A circular locking dependency involves INODE_ALLOC_SYSTEM_INODE,
> >> EXTENT_ALLOC_SYSTEM_INODE, and ORPHAN_DIR_SYSTEM_INODE.
> >>
> >> 1. ocfs2_mknod() acquires INODE_ALLOC then EXTENT_ALLOC.
> >> 2. ocfs2_dio_end_io_write() acquires EXTENT_ALLOC for unwritten extents,
> >> then ORPHAN_DIR via ocfs2_del_inode_from_orphan() while still holding
> >> EXTENT_ALLOC.
> >> 3. ocfs2_wipe_inode() acquires ORPHAN_DIR then INODE_ALLOC via
> >> ocfs2_remove_inode.
> >>
> >> Break the cycle in ocfs2_dio_end_io_write() by freeing the allocation
> >> contexts (releasing EXTENT_ALLOC) before acquiring ORPHAN_DIR.
> >>
> >> WARNING: possible circular locking dependency detected
> >> ------------------------------------------------------
> >> is trying to acquire lock:
> >> ffff8881e78b33a0
> >> (&ocfs2_sysfile_lock_key[INODE_ALLOC_SYSTEM_INODE]){+.+.}-{4:4}, at:
> >> ocfs2_evict_inode+0x1539/0x43b0 fs/ocfs2/inode.c:1299
> >>
> >> but task is already holding lock:
> >> ffff8881e78b4fa0
> >> (&ocfs2_sysfile_lock_key[ORPHAN_DIR_SYSTEM_INODE]){+.+.}-{4:4}, at:
> >> ocfs2_evict_inode+0xe97/0x43b0 fs/ocfs2/inode.c:1299
> >>
> >> the existing dependency chain (in reverse order) is:
> >>
> >> -> #2 (&ocfs2_sysfile_lock_key[ORPHAN_DIR_SYSTEM_INODE]){+.+.}-{4:4}:
> >>        inode_lock include/linux/fs.h:1029 [inline]
> >>        ocfs2_del_inode_from_orphan+0x12e/0x7a0 fs/ocfs2/namei.c:2728
> >>        ocfs2_dio_end_io+0xf9c/0x1370 fs/ocfs2/aops.c:2418
> >>        dio_complete+0x25b/0x790 fs/direct-io.c:281
> >>
> >> -> #1 (&ocfs2_sysfile_lock_key[EXTENT_ALLOC_SYSTEM_INODE]){+.+.}-{4:4}:
> >>        inode_lock include/linux/fs.h:1029 [inline]
> >>        ocfs2_reserve_suballoc_bits+0x16d/0x4840 fs/ocfs2/suballoc.c:882
> >>        ocfs2_reserve_new_metadata_blocks+0x415/0x9a0
> >>        fs/ocfs2/suballoc.c:1078
> >>        ocfs2_mknod+0x10f3/0x2260 fs/ocfs2/namei.c:351
> >>
> >> -> #0 (&ocfs2_sysfile_lock_key[INODE_ALLOC_SYSTEM_INODE]){+.+.}-{4:4}:
> >>        __lock_acquire+0x15a5/0x2cf0 kernel/locking/lockdep.c:5237
> >>        lock_acquire+0x106/0x350 kernel/locking/lockdep.c:5868
> >>        down_write+0x96/0x200 kernel/locking/rwsem.c:1625
> >>        inode_lock include/linux/fs.h:1029 [inline]
> >>        ocfs2_remove_inode fs/ocfs2/inode.c:733 [inline]
> >>        ocfs2_wipe_inode fs/ocfs2/inode.c:896 [inline]
> >>        ocfs2_delete_inode fs/ocfs2/inode.c:1157 [inline]
> >>        ocfs2_evict_inode+0x1539/0x43b0 fs/ocfs2/inode.c:1299
> >>
> >> Chain exists of:
> >>   &ocfs2_sysfile_lock_key[INODE_ALLOC_SYSTEM_INODE] -->
> >>   &ocfs2_sysfile_lock_key[EXTENT_ALLOC_SYSTEM_INODE] -->
> >>   &ocfs2_sysfile_lock_key[ORPHAN_DIR_SYSTEM_INODE]
> >>
> >>  Possible unsafe locking scenario:
> >>
> >>        CPU0                    CPU1
> >>        ----                    ----
> >>   lock(&ocfs2_sysfile_lock_key[ORPHAN_DIR_SYSTEM_INODE]);
> >>                                lock(&ocfs2_sysfile_lock_key[EXTENT_ALLOC_SYSTEM_INODE]);
> >>                                lock(&ocfs2_sysfile_lock_key[ORPHAN_DIR_SYSTEM_INODE]);
> >>   lock(&ocfs2_sysfile_lock_key[INODE_ALLOC_SYSTEM_INODE]);
> >>
> >>  *** DEADLOCK ***
> >>
> 
> Better to describe the solution here.
> 
> >> Fixes: d647c5b2fbf8 ("ocfs2: split transactions in dio completion to avoid credit exhaustion")
> >> Assisted-by: Gemini:gemini-3.1-pro-preview Gemini:gemini-3-flash-preview syzbot
> >> Reported-by: syzbot+b225d4dfce6219600c42@syzkaller.appspotmail.com
> >> Closes: https://syzkaller.appspot.com/bug?extid=b225d4dfce6219600c42
> >> Link: https://syzkaller.appspot.com/ai_job?id=0b53ce1e-2972-4192-aa85-8097a702762c
> >> Signed-off-by: Aleksandr Nogikh <nogikh@google.com>
> > 
> > LGTM.
> > After d647c5b2fbf8, ocfs2_dio_end_io_write() spends a significant amount of time
> > looping through the unwritten extent list before it finally acquires the
> > ORPHAN_DIR lock. This gives other functions (such as ocfs2_wipe_inode() mentioned
> > in this patch) a chance to preemptively grab the ORPHAN_DIR lock, thereby
> > triggering the circular locking.
> > What d647c5b2fbf8 actually did was widen the race window, turning a pre-existing,
> > low-probability issue into an easily reproducible one.
> > 
> 
> Ummm... before d647c5b2fbf8, ocfs2_del_inode_from_orphan() is called
> before down_write(&ip_alloc_sem) and ocfs2_lock_allocators().
> So I think the 'Fixes' tag looks reasonable.
> 
> Thanks,
> Joseph

Thanks for the info, your got the key.

- Heming
> 
> > Reviewed-by: Heming Zhao <heming.zhao@suse.com>
> >>
> >> ---
> >> diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
> >> index 6ec198bda..4acdbb708 100644
> >> --- a/fs/ocfs2/aops.c
> >> +++ b/fs/ocfs2/aops.c
> >> @@ -2372,6 +2372,15 @@ static int ocfs2_dio_end_io_write(struct inode *inode,
> >>  unlock:
> >>  	up_write(&oi->ip_alloc_sem);
> >>  
> >> +	if (data_ac) {
> >> +		ocfs2_free_alloc_context(data_ac);
> >> +		data_ac = NULL;
> >> +	}
> >> +	if (meta_ac) {
> >> +		ocfs2_free_alloc_context(meta_ac);
> >> +		meta_ac = NULL;
> >> +	}
> >> +
> >>  	/* everything looks good, let's start the cleanup */
> >>  	if (!ret && dwc->dw_orphaned) {
> >>  		BUG_ON(dwc->dw_writer_pid != task_pid_nr(current));
> >> @@ -2383,10 +2392,6 @@ static int ocfs2_dio_end_io_write(struct inode *inode,
> >>  	ocfs2_inode_unlock(inode, 1);
> >>  	brelse(di_bh);
> >>  out:
> >> -	if (data_ac)
> >> -		ocfs2_free_alloc_context(data_ac);
> >> -	if (meta_ac)
> >> -		ocfs2_free_alloc_context(meta_ac);
> >>  	ocfs2_run_deallocs(osb, &dealloc);
> >>  	ocfs2_dio_free_write_ctx(inode, dwc);
> >>  
> >>
> >>
> >> base-commit: e7ae89a0c97ce2b68b0983cd01eda67cf373517d
> >> -- 
> >> See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
> >> You can comment on the patch as usual, syzbot will try to address
> >> the comments and send a new version of the patch if necessary.
> >> syzbot engineers can be reached at syzkaller@googlegroups.com.
> >>
> 
