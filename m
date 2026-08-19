Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88F66448D05;
	Wed, 19 Aug 2026 12:27:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787142421; cv=none; b=tTMpuRXboCPCZ22xyqKCAeUgslTOXfDlLum/CkT04yZMIfXhEq69KDgwEwFgS3wghjy8j/Zwm0R5FW/kE3RY9GqoeSB52WPKpZNGovyeDmbVmmlhwd57rzLzZFTzh5qtAdM+k/Qpwo9TIJ9tBslfFT0xwXRb8vHe+RHiHosBEz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787142421; c=relaxed/simple;
	bh=xvy76afzqrjZfTVLB4UNNNQtHgPbZ45FXx+pRWkQAaI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OSPRZcvW+j/+yo49sGajovEvhyC/0SfGvZimrKqEroe6aVOi2TPctAcbN7xy2dIp2i1Wl16Y4TErBN9PiwDdPpSNkltpvaMmh9wX4RCXpyWQ3cdkBIgrt2yRFgJS0djLfIlre1uz5p/QAixAuGaF8psNdQ6HRmTCs8IjnaDdB8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ni1zrXGo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ni1zrXGo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D95EF1F00A3A;
	Wed, 19 Aug 2026 12:26:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787142420;
	bh=XPbX6PsQGH85lxvob7JhlQFhog6YchHNLpyShfsHTtY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Ni1zrXGotEMmjhh/Ax69CVpU5xlqZorAQzkKy7V6RBu0otLdZKSZ9LILqzNOz6IzK
	 Tx+6gQx5XVqpJYM008OgTCfpjw1i6pl+XVsp44fu1pu0ExAL9ljO9aFvHH5PYvCchU
	 KHLqzb7QlgtlyGd7nErM3UvTNK/ylEgTsAotpjko=
Date: Wed, 19 Aug 2026 14:26:54 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: syzbot <syzbot+df9e891bf8ea586f846b@syzkaller.appspotmail.com>,
	asml.silence@gmail.com, axboe@kernel.dk, brauner@kernel.org,
	io-uring@vger.kernel.org, jack@suse.cz, kartikey406@gmail.com,
	kees@kernel.org, linux-kernel@vger.kernel.org,
	linux-usb@vger.kernel.org, mjguzik@gmail.com, nogikh@google.com,
	syzbot@kernel.org, syzbot@lists.linux.dev,
	syzkaller-bugs@googlegroups.com,
	syzkaller-upstream-moderation@googlegroups.com,
	torvalds@ppc970.osdl.org, viro@zeniv.linux.org.uk
Subject: Re: [syzbot] [usb?] KASAN: slab-use-after-free Read in ep_open
Message-ID: <2026081906-possible-seltzer-6db9@gregkh>
References: <34e65096-8827-470c-9a88-8c643cccef22@rowland.harvard.edu>
 <6a8338ea.dbb3a75c.20434b.006a.GAE@google.com>
 <16741050-a3e2-4193-bfca-232a615a1311@rowland.harvard.edu>
 <2026081849-flatbed-unashamed-a52d@gregkh>
 <6232f9c1-8b07-42b9-8660-ad514702ae1c@rowland.harvard.edu>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6232f9c1-8b07-42b9-8660-ad514702ae1c@rowland.harvard.edu>

On Tue, Aug 18, 2026 at 11:37:16AM -0400, Alan Stern wrote:
> On Tue, Aug 18, 2026 at 09:42:34AM +0200, Greg KH wrote:
> > On Mon, Aug 17, 2026 at 02:14:17PM -0400, Alan Stern wrote:
> > > Greg:
> > > 
> > > Has this patch ever been queued?
> > > 
> > > https://lore.kernel.org/linux-usb/ee41fbfd-f368-4a06-95d6-ae9b4267fd82@mail.kernel.org/
> > 
> > No because it looks like there are competing patches here as you point
> > out.
> > 
> > > Looks like you can add syzbot's Tested-by: tag, as well as my Acked-by:.
> > > 
> > > Note that a different patch to fix the same problem was submitted here:
> > > 
> > > https://lore.kernel.org/linux-usb/20260731230603.4637-1-kartikey406@gmail.com/
> > > 
> > > IMO the first patch above is superior.
> > 
> > So Aleksandr's patch should be applied and not Deepanshu's?
> 
> That's my recommendation.  You can take a quick look at the two patches 
> and see what you think.
> 
> We haven't heard back from Deepanshu.  Aleksandr doesn't seem to have 
> strong feelings either way.

Aleksandr's patch is much more simple, and relies on the reference
counting logic in the inode itself, instead of "hand rolling" it like
Deepanshu's does.

I'll take it after -rc1 is out.  As this is a syzbot-only type of thing,
there's no rush here.

thanks,

greg k-h
