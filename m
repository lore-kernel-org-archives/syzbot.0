Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com [209.85.167.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8A3443CE45
	for <syzbot@lists.linux.dev>; Mon, 17 Aug 2026 16:38:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786984685; cv=none; b=YrJBfp/BKbaHISiwO2/UunCG9n3algfStcK4MDBiWFmbE4VSQ58ofyCZNT/uZgA1RDvid/UeY5tXBsbX9RuqactvKNDb8ybQoWcRex9FJjnWm+aC4J0qksYUSGxzeBrtG+ukQHskT+yefFgWj26wB+riYOAKIqps3AtSR6zFNK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786984685; c=relaxed/simple;
	bh=O5tWgxmwgMrUnydp1q9GOvUzClrE/Mq92ksXIVL8dHY=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=arSt5ZaFS7BA+I7983Qtr3pxtKZjSK+hLMiXVzpiF6gdLw84PxRACQyTYV9RaRsEn9kPNW/HIJbWZ86fgo6h+++hvvdF8gqV4r5bOyQYAsWklwXIPjSjI1Q8dXrEWzfH2e28iYsd6U0YNMZBO2FOg4wnOG6ducYbx5j5/nvmyQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f199.google.com with SMTP id 5614622812f47-4b28dbf4197so756697b6e.2
        for <syzbot@lists.linux.dev>; Mon, 17 Aug 2026 09:38:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786984683; x=1787589483;
        h=content-type:to:from:subject:message-id:in-reply-to:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=6ry6iaEim5a44990Oh54c+d4+LN5Mgz5CQaOqSlmlJI=;
        b=jflO0NVF/CfdCJDKMOa7vt3hjvKhLmK9j5IIwdy/uzYyKHSUIiQ2Xz1Z7Mum/ABPJv
         bg08+El2w/cCC2cRdpVid5AHL+oW3UsoiMq5XjUTQM0PyXliUGw1SOIrpggb+L2vw8S5
         jW8hfD3i0h60zp3lCuFoD1dtdMW0I5hhNtf5SSWBHKztQJBCYrIGXfnMYsiJtDMWkhVQ
         vYxetlgoo9KX9UbLFBo2fvnBaVBp1sfv8Vn+N5popUdURnYYjJUqn/P1gwUKYIRkhK++
         E0DPkWZbaPX7o6sAba3rnW3OUQxlFYoABq4MwGj4cUzCqX9a3R0Z31bXfAAsIv/SNGAx
         NRTw==
X-Forwarded-Encrypted: i=1; AHgh+Rr9VgDHsS5j919uYAQ/RbtLDT8UOrhhLASVpVymAthhZKi36OiwpNBLboVdbc6vukUAyD97yHE=@lists.linux.dev
X-Gm-Message-State: AOJu0YzUty6H8Xjlhzus0AG6auol85A5/L89VzDD2WUZ9l69TrhD67Vu
	6ceJ7CkOcuZTQ7g6wCesF6icuGimVJbdiv+KfGFoIUqWGOHgWF+5ctDh3IrdB+zlC/XiMqCRg47
	mksrAfrB+d7lHTHa0kAlrjANXsFISM5Ta17izLOG752lDBF4/inrbg1/bZLs=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:1990:b0:6ae:aa38:a0bb with SMTP id
 006d021491bc7-6b0d692d722mr21841468eaf.33.1786984682847; Mon, 17 Aug 2026
 09:38:02 -0700 (PDT)
Date: Mon, 17 Aug 2026 09:38:02 -0700
In-Reply-To: <34e65096-8827-470c-9a88-8c643cccef22@rowland.harvard.edu>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a8338ea.dbb3a75c.20434b.006a.GAE@google.com>
Subject: Re: [syzbot] [usb?] KASAN: slab-use-after-free Read in ep_open
From: syzbot <syzbot+df9e891bf8ea586f846b@syzkaller.appspotmail.com>
To: asml.silence@gmail.com, axboe@kernel.dk, brauner@kernel.org, 
	gregkh@linuxfoundation.org, io-uring@vger.kernel.org, jack@suse.cz, 
	kartikey406@gmail.com, kees@kernel.org, linux-kernel@vger.kernel.org, 
	linux-usb@vger.kernel.org, mjguzik@gmail.com, nogikh@google.com, 
	stern@rowland.harvard.edu, syzbot@kernel.org, syzbot@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com, 
	syzkaller-upstream-moderation@googlegroups.com, torvalds@ppc970.osdl.org, 
	viro@zeniv.linux.org.uk
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-by: syzbot+df9e891bf8ea586f846b@syzkaller.appspotmail.com
Tested-by: syzbot+df9e891bf8ea586f846b@syzkaller.appspotmail.com

Tested on:

commit:         8d3ae592 Linux 7.2
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/ v7.2
console output: https://syzkaller.appspot.com/x/log.txt?x=16a91a25580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c44651ea7dd2f307
dashboard link: https://syzkaller.appspot.com/bug?extid=df9e891bf8ea586f846b
compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44
patch:          https://syzkaller.appspot.com/x/patch.diff?x=15790679580000

Note: testing is done by a robot and is best-effort only.
