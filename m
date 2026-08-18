Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3238331ED4
	for <syzbot@lists.linux.dev>; Tue, 18 Aug 2026 07:42:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787038960; cv=none; b=IHgsKoJA5zhrTShNXNd5PStfg/PVHioDm92huD66f2ryIimj95tGQBbmo56mbvbiANsKXRsuX7pVSuVLCf+ptN4TpPWi9fTaTos2VMxxFdyhwgSzQsWlhOSRNGhmYm1wE32CQUdmpbjIIsBUsIYJep77Xxv83FQzJsxtE4g7B3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787038960; c=relaxed/simple;
	bh=xV6tfEMYQp5jxATMNguyGVsaLqLJMvnyo3b09SoUrDE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LaWA5Bg64IuSwkKjKY+8xh5597o+9c7Mj16MWBjbVZwnFiy7JAKWdoN20YjlbFBo2Rj8PuSjU2WSyvJOo4vC6Libk2ExMWG9hiX7f3U/Uy9fil5K3hA1rVkUVi/uRkcxgO9cbX42C7kKWYxW0o2yz1SW3Apz2K19bosXomw5E5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YV+Uulyp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YV+Uulyp"
Received: by smtp.kernel.org (Postfix)
	id 670991F00A3A; Tue, 18 Aug 2026 07:42:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CA691F000E9;
	Tue, 18 Aug 2026 07:42:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787038959;
	bh=Kgjlnk0JKpgsBJedth1XapTfdRX4ogpVMh4MyZZwLHc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=YV+UulypVyUktjztQAs48LW9mXOhoBwnE1tQxsduhXTAVP8h+bulp0ko8MbZRh/j2
	 CDVeyjIwTQUeqS0By5opmkGxu8Hh5i63bfLY6isMbjpEZzkFWyeo5kQxIG/l+ksSap
	 ywOprk3ITcrBpQFF1i7TACX0DMar4Sdt+sTs8W8o=
Date: Tue, 18 Aug 2026 09:42:34 +0200
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
Message-ID: <2026081849-flatbed-unashamed-a52d@gregkh>
References: <34e65096-8827-470c-9a88-8c643cccef22@rowland.harvard.edu>
 <6a8338ea.dbb3a75c.20434b.006a.GAE@google.com>
 <16741050-a3e2-4193-bfca-232a615a1311@rowland.harvard.edu>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <16741050-a3e2-4193-bfca-232a615a1311@rowland.harvard.edu>

On Mon, Aug 17, 2026 at 02:14:17PM -0400, Alan Stern wrote:
> On Mon, Aug 17, 2026 at 09:38:02AM -0700, syzbot wrote:
> > Hello,
> > 
> > syzbot has tested the proposed patch and the reproducer did not trigger any issue:
> > 
> > Reported-by: syzbot+df9e891bf8ea586f846b@syzkaller.appspotmail.com
> > Tested-by: syzbot+df9e891bf8ea586f846b@syzkaller.appspotmail.com
> > 
> > Tested on:
> > 
> > commit:         8d3ae592 Linux 7.2
> > git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/ v7.2
> > console output: https://syzkaller.appspot.com/x/log.txt?x=16a91a25580000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=c44651ea7dd2f307
> > dashboard link: https://syzkaller.appspot.com/bug?extid=df9e891bf8ea586f846b
> > compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44
> > patch:          https://syzkaller.appspot.com/x/patch.diff?x=15790679580000
> > 
> > Note: testing is done by a robot and is best-effort only.
> 
> Greg:
> 
> Has this patch ever been queued?
> 
> https://lore.kernel.org/linux-usb/ee41fbfd-f368-4a06-95d6-ae9b4267fd82@mail.kernel.org/

No because it looks like there are competing patches here as you point
out.

> Looks like you can add syzbot's Tested-by: tag, as well as my Acked-by:.
> 
> Note that a different patch to fix the same problem was submitted here:
> 
> https://lore.kernel.org/linux-usb/20260731230603.4637-1-kartikey406@gmail.com/
> 
> IMO the first patch above is superior.

So Aleksandr's patch should be applied and not Deepanshu's?

thanks,

greg k-h
