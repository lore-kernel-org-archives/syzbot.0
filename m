Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7EFB3AAF52
	for <syzbot@lists.linux.dev>; Tue, 18 Aug 2026 15:37:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787067443; cv=none; b=HTYE/G6/niuweacMgcv1X/g0agHVWIOQnpKQbTxLMN0YEDQZUfNTOsJmrcWl3iTWYBajElSe1oqGezO/IwYi0V6MMIlgAUTKTHBqKRe/Zjac6/pUt/RUTL7zy9QNJI/6ppZ/24E3nGPyMN3AdfPnGZW6QgSrZl6fP3s/0BntGrQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787067443; c=relaxed/simple;
	bh=aZqZYi18fHUjbAUY/ZshE0O4WseDB0xSTbF69cVs//I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qtsCRvpPux8A0bcvzXITWB0rSkSEcpTcNDS7nbGCIfkkiJryDaxfNj06Ack8yRUKPeqaesznS4J46XisVlucZhd81gzCwUUJ55W4enBIqJB9MVOYcjSnPC7Fw+ajitGNEyCHY1ofNfAp0zdLY0naHh9QXjE+C4upTUehpE9/e4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rowland.harvard.edu; spf=fail smtp.mailfrom=g.harvard.edu; dkim=pass (2048-bit key) header.d=rowland.harvard.edu header.i=@rowland.harvard.edu header.b=Dvz2qngr; arc=none smtp.client-ip=209.85.160.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rowland.harvard.edu
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=g.harvard.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rowland.harvard.edu header.i=@rowland.harvard.edu header.b="Dvz2qngr"
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-517dc520840so36141041cf.3
        for <syzbot@lists.linux.dev>; Tue, 18 Aug 2026 08:37:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rowland.harvard.edu; s=google; t=1787067440; x=1787672240; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=mLqAQEw3rXL8/MZPDsV2OgUVMCATzjFwzJYqncXsPSY=;
        b=Dvz2qngr22PETxFE9S8qkZ4JAKAbMub5wIVGtFaUHEcXtk79UHlcw8Eg7D/wNAbpkN
         W7eryrzM1dqIgkmdLyWFgsbwaDJGFN7JekaDas9WUwSsLZTgro52SioSoCovJ2KI+C7Z
         0yX6fRq+I1QbOZ57D7sY/t7fn7OdxAw3Vw+Rn7oa/7V2f9YGE9ANeAtJKyWOaDWEYJi3
         AAxgpUg8ywBW47M1sq3PWAvmONd9W9nhHRs4w4INDresUlL4lhxeiQOPTmpgcYtsMmS9
         9mdi6T8bWRC4f1yLlS/yRF7cRqfu3YDWFwzi1MEdjiJl65ujyAqj08a1sUuOO4kepA2j
         Rn4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787067440; x=1787672240;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mLqAQEw3rXL8/MZPDsV2OgUVMCATzjFwzJYqncXsPSY=;
        b=QwQ8iieEa0vQNRLmQExG8aeUC/732Y/g3VadDwZk0rk5cJhukgGVjl2fQ8rPG0R4Vy
         2Qd9qJd//6I/Hzna/3U+TaCEn5iFL1QDVa9qy44PCvKdvEIWcSVpcGiYKkeoguUS20RB
         Jkm9OrL60F19kudogsL+ndPc2bXAvDHJYj+v1UPilqdd7RNQ1EMfAHp/CjIKGFU+GGHn
         +rfW6pdma9dW74rBGa7uF68ygz0Os9+mYNo3DxtNqBxH+swnR+dTDO0Qu4QbKNvVnc1g
         ZyTfNn3DHBSzZaY4HLpzEc6R2nzJpEaOqwST2GSQrR3ofg47VDUlq4+04ee4QXXxca3j
         TbdQ==
X-Forwarded-Encrypted: i=1; AHgh+RogfqWONA5G4AkN18EVSCIIbN5Kz+0uoEPMcKK/P6Bv+Eh9ez4fNubp61oAzKnkXpeaSDkYuFk=@lists.linux.dev
X-Gm-Message-State: AOJu0YyWgR8hemWk5fvEAK6BX9UyQNUPuI+Vkn8LJcGuo6J9SShxh2D3
	P3UWY05Q/H3WohVSluQAZlCGGaTWRDFPVUtNuebMH5Ma5sSUjQzheFtCOJXQGPKlJw==
X-Gm-Gg: AR+sD12hw1SOFYYW9cS+ZuBXpTYsePcwBu3m9Y538iM1SZpbw5YN3aWa+TSA/x4ZOOU
	6Mq555OVc5s9pKql4fCCR4wrS529v30TFTPd3MCp+yFZ6O5efR/EUZs8SZkGdYWzWXBQuYj3SHJ
	2nEB6Q9EWL1A+MLY19l59Am0awYhzrXLcrilj9Wc3gzsKGnSr7+gis5GlJ9Q0epfXfOgICxGloa
	/9PXaVksShjUWJO7sZYFb88zxgQCDB7H95HbhnsRlcxcecUB4e2xcAvJk4k29Fnmo5QGmgo40hS
	6kKP7iaOK+Q5XdtAlBRzhvWbHdRAsZYAT9uW6Q3NCXzQd9M17ZVxc8B9NaLOlwgGypWOIFqjcW/
	/e1o+wF0yVT1NO2T6cb6NICZ85h90utF3jTxAfcUdtc7SCE04wR3a7qcVdAm/qtSfjZRjsd0EMU
	9bXiohGl6WYsPtRBdBHm3AmnrTfN8gaR/VZV9hHNXkvTLNyOMr6PtkKKE4IG8GAaA=
X-Received: by 2002:ac8:5911:0:b0:52d:354c:5b91 with SMTP id d75a77b69052e-52d853e367dmr373102671cf.16.1787067440100;
        Tue, 18 Aug 2026 08:37:20 -0700 (PDT)
Received: from rowland.harvard.edu ([2601:19b:d01:d210::dfd8])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-52db62175b1sm44141481cf.19.2026.08.18.08.37.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Aug 2026 08:37:19 -0700 (PDT)
Date: Tue, 18 Aug 2026 11:37:16 -0400
From: Alan Stern <stern@rowland.harvard.edu>
To: Greg KH <gregkh@linuxfoundation.org>
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
Message-ID: <6232f9c1-8b07-42b9-8660-ad514702ae1c@rowland.harvard.edu>
References: <34e65096-8827-470c-9a88-8c643cccef22@rowland.harvard.edu>
 <6a8338ea.dbb3a75c.20434b.006a.GAE@google.com>
 <16741050-a3e2-4193-bfca-232a615a1311@rowland.harvard.edu>
 <2026081849-flatbed-unashamed-a52d@gregkh>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2026081849-flatbed-unashamed-a52d@gregkh>

On Tue, Aug 18, 2026 at 09:42:34AM +0200, Greg KH wrote:
> On Mon, Aug 17, 2026 at 02:14:17PM -0400, Alan Stern wrote:
> > Greg:
> > 
> > Has this patch ever been queued?
> > 
> > https://lore.kernel.org/linux-usb/ee41fbfd-f368-4a06-95d6-ae9b4267fd82@mail.kernel.org/
> 
> No because it looks like there are competing patches here as you point
> out.
> 
> > Looks like you can add syzbot's Tested-by: tag, as well as my Acked-by:.
> > 
> > Note that a different patch to fix the same problem was submitted here:
> > 
> > https://lore.kernel.org/linux-usb/20260731230603.4637-1-kartikey406@gmail.com/
> > 
> > IMO the first patch above is superior.
> 
> So Aleksandr's patch should be applied and not Deepanshu's?

That's my recommendation.  You can take a quick look at the two patches 
and see what you think.

We haven't heard back from Deepanshu.  Aleksandr doesn't seem to have 
strong feelings either way.

Alan Stern
