Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B33CB29D292
	for <syzbot@lists.linux.dev>; Wed, 17 Sep 2025 19:59:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758139179; cv=none; b=WNdDNIojOxucy5eofk8loQHLu8rLwWO6M7F63ZyQVsbQICPZyWy86gTb3FJZTrmGXZCNz/t0WMivU4gU6C4qDANy9HGE7Uw3OXHT2LiJjDZHRhneqtGaOaghOfpGFbmh6xQVPhAqYK3BSrItK9kaT7vPKezsHW1e9vBx3J+l6QQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758139179; c=relaxed/simple;
	bh=lT+6fz4hGzB3x5TxZKL3rSaWn/F8+CECdWOTuWodsnQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fcGF3ef2ddDC0JCZZ7q4+1Cqwx4ijkvD2RVHADlyNwXr7oe0NsBsIW/81Brr15Swmei9tvQtrXZBarVVcr8Fd8kdm0i0ifjCtmFeJqEqY21YOWuh9ItsIvHLxD/JT33ZpXS6IQtUM+dCA0qgDURtS08YugM30aEmOIthfWjdf20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=L2K9klTt; arc=none smtp.client-ip=209.85.160.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="L2K9klTt"
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-4b7a8ceaad3so2116881cf.2
        for <syzbot@lists.linux.dev>; Wed, 17 Sep 2025 12:59:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758139176; x=1758743976; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lT+6fz4hGzB3x5TxZKL3rSaWn/F8+CECdWOTuWodsnQ=;
        b=L2K9klTtaYyanFHDUOlG/auzSjIFdgfzi/ehGV97EpqZTh4+9gSzewjzjvz4XfEWfd
         FQ2CcTRFKgO4Kwsm/33dcFv8sSuqnPRbubznRyFUVosR7m7BCqhnRSNFvHuyF4DkCd4n
         FIhFcNIWWuQqWP6UsTq/A5X98OqOufJJtqiVntJQ0AF37k9yHYUZDzgDqMLRXasikk0Y
         8BALo8raw650GAZUheO+blopeCA2yvDzwVlT8GVrlpwznn81u6W5FXpbAB+5U8vZfuzt
         PBbw+kB4hgoG+Yng+u1Y3HtslWGFjAAkenNtLrZJmNwzbr9vOu2tNDpgZanO94agE0/B
         nogA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758139176; x=1758743976;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lT+6fz4hGzB3x5TxZKL3rSaWn/F8+CECdWOTuWodsnQ=;
        b=AHtticANjY8rCo1Crr6JrQ4eyiUsUYR3YQFarcJKeG0iOQ2vJUCGEAgC6/iSzNJpF6
         hKat0k44zzTCmbf1h82rpi4WAXCdbm0jJQsM9VJx95Q7f7vzMY0Q+Mhbw2rzihzIBLUQ
         ZaxPlIyCbK/rOhJMAn+twOR6Qv5rdo2jD/QHgt9HQOBIMoO4MR8Ak4xHODc2xhFa84Jo
         Zva/OUx7/Wuw+LFt7kZXN0+LhkyA8+9dg1FZMyLTBuFRAgnyIcCMYLCUMgy1W2mE3+r/
         2s6GCDKojCdugERH+ITugJSU1T2zidnpfAj8eYJ2JotM+HZwIvBJvKMrAhMSWvyks0Z0
         fdbw==
X-Forwarded-Encrypted: i=1; AJvYcCW/wUtzd+5uVZBOcmeBJ78QkY5y+RQLT1i3WiKyGOkFwaBVoUDbIDjZugRsImyNYX66rJm6fIo=@lists.linux.dev
X-Gm-Message-State: AOJu0YzLt56tHbCcEhKn6yTjBPEKRCVonEaBBMsLHOU8rk6goyGyiJb9
	+IegsuMEPhFWHrO+iPBl1Pv4EEIFZTStVcU3rX/DuV42/xnzlGBV/sJqCeyUW4AxaWVkoKVCINX
	RdWYto/E94+wrIcZyAXADOIgq2VOtXAo=
X-Gm-Gg: ASbGncva6fM80z9CaH0Ofkb1AvqlfbtlNig5xd48HWaEYZbxzf6BpGSBuueMFYxvfpN
	jkMKcbVZ/OV7/MTzsqMVVidOX1b5O4dX7UPx1lqKxkyA/gWXnKFhwRQNQd17lQpfYEMb14tOjlI
	r7W49VmdfqWNXGMNiRQPTNEckHDMIg1nnZQjI94a7gr/IQV4Nr+8Dk827U21jQ+wvFP3rzfie3R
	VjolaYYZEF7UXPSWogS1M3vkeen0PffRdp9JsFzOUh+vz3QWGan1B3g+VA=
X-Google-Smtp-Source: AGHT+IGMvsb9hFrlxwdIt/gNCY+ZXtdov7G+eqQ0YehxgnuYGPrrjhUsF8j6K/mIV15UQttqUMf4NVIbg9l0zFWT/EU=
X-Received: by 2002:ac8:5a03:0:b0:4b3:10f0:15ba with SMTP id
 d75a77b69052e-4ba6a20181amr52761081cf.39.1758139176357; Wed, 17 Sep 2025
 12:59:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250916234425.1274735-1-joannelkoong@gmail.com> <68ca71bd.050a0220.2ff435.04fc.GAE@google.com>
In-Reply-To: <68ca71bd.050a0220.2ff435.04fc.GAE@google.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Wed, 17 Sep 2025 12:59:25 -0700
X-Gm-Features: AS18NWC14gUDKzQcBj3qPbZdYHs2cE9cQhtC5cBOuvB6NHeNGl3mJTY7LRXGD5w
Message-ID: <CAJnrk1YKPWkaBXe7D2mftN2DMEBqFow80reUGE=2_U8oVFc1tQ@mail.gmail.com>
Subject: Re: [syzbot ci] Re: fuse: use iomap for buffered reads + readahead
To: syzbot ci <syzbot+ci9b5a486340e6bcdf@syzkaller.appspotmail.com>, 
	syzbot <syzkaller@googlegroups.com>
Cc: brauner@kernel.org, djwong@kernel.org, gfs2@lists.linux.dev, 
	hch@infradead.org, hch@lst.de, hsiangkao@linux.alibaba.com, 
	kernel-team@meta.com, linux-block@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, miklos@szeredi.hu, 
	syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 17, 2025 at 1:37=E2=80=AFAM syzbot ci
<syzbot+ci9b5a486340e6bcdf@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v3] fuse: use iomap for buffered reads + readahead
> https://lore.kernel.org/all/20250916234425.1274735-1-joannelkoong@gmail.c=
om
> * [PATCH v3 01/15] iomap: move bio read logic into helper function
> * [PATCH v3 02/15] iomap: move read/readahead bio submission logic into h=
elper function
> * [PATCH v3 03/15] iomap: store read/readahead bio generically
> * [PATCH v3 04/15] iomap: iterate over entire folio in iomap_readpage_ite=
r()
> * [PATCH v3 05/15] iomap: rename iomap_readpage_iter() to iomap_read_foli=
o_iter()
> * [PATCH v3 06/15] iomap: rename iomap_readpage_ctx struct to iomap_read_=
folio_ctx
> * [PATCH v3 07/15] iomap: track read/readahead folio ownership internally
> * [PATCH v3 08/15] iomap: add public start/finish folio read helpers
> * [PATCH v3 09/15] iomap: add caller-provided callbacks for read and read=
ahead
> * [PATCH v3 10/15] iomap: add bias for async read requests
> * [PATCH v3 11/15] iomap: move buffered io bio logic into new file
> * [PATCH v3 12/15] iomap: make iomap_read_folio() a void return
> * [PATCH v3 13/15] fuse: use iomap for read_folio
> * [PATCH v3 14/15] fuse: use iomap for readahead
> * [PATCH v3 15/15] fuse: remove fc->blkbits workaround for partial writes
>
> and found the following issues:
> * WARNING in iomap_iter_advance
> * WARNING in iomap_readahead
> * kernel BUG in folio_end_read
>
> Full report is available here:
> https://ci.syzbot.org/series/6845596a-1ec9-4396-b9c4-48bddc606bef
>
> ***
>
Thanks. Do you get run on every patchset that is sent upstream or is
it random? Trying to figure out if this means v2 is right and i just
messed up v3 or if you just didn't run on v2.

Thanks,
Joanne
