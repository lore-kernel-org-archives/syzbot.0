Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F26FE446BFC
	for <syzbot@lists.linux.dev>; Mon, 17 Aug 2026 15:45:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=100.103.45.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786981550; cv=pass; b=bfdSWapkNRitP6W+gan1jpgkIxvlCPeCZ5nnyl/t5XpKdgWQzRkFLVf5JhM5sX/CRPCOp6n39jOv6rSyFo3PErSFal5UuRhSAKIWcN6WstNDBT+DmoOzBMuzx3rL8/P1AgNATZsOCbg/liuSgOk/Id7gUaJHdzCRSyrrWVggMCI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786981550; c=relaxed/simple;
	bh=WgoUXwoPUgqVhPGao7+QJ9DTMWGX+mf2qPAXnx16Ag8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ePwQQKk+QDIH0yaBYC02jCPgqob4xvHEleExGbnLenW/fsoOmNjpH6QZP3zMxSZrb7ilDJjTqdf2oobbdJrpUnnPVtt/iCfZwcsfhbF7z7BWaLgajvjNK/juPGw+DfQ4WHMqs/T9bx6qfjNTLMPJMGCQZFsm15xqzUI5s2h68KE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=rowland.harvard.edu header.i=@rowland.harvard.edu header.b=NfPqMhJs; arc=pass smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rowland.harvard.edu header.i=@rowland.harvard.edu header.b="NfPqMhJs"
Received: by smtp.kernel.org (Postfix)
	id 255741F00A3E; Mon, 17 Aug 2026 15:45:47 +0000 (UTC)
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=209.85.219.49
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1786981547;
	b=iPh4VHybHhQ6HAM/UYaujFEasf9tZfxoxafUXGWYHT5SO/6OOJ+aPRqufUsoq/SBFjwF
	 4F2VjvdQ+/vawxhwS/GDneDyGGYiCGYSzpN59FHIQEH2J323RWuNOp7QrDJM88mN1MwK/
	 kJTgP0YiE02JCf622E33NnNN1oThCcBnVrEKPyJVpDbu/sUs1bKU58H0wVcUQxxNEW5gc
	 hMQ0lu8ljQ41lbmQL2K1RG3ppoLGv4VbKvhws9ovqucu3WCNywtKaaD9FuE1cFlhOkDSj
	 S6M7yun7Mh2mCQpHDcHeAzAgBW+4WQZ9rllO77z2z7OhSwywTKbk3m44dlIP9i3yvSg==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1786981547;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=K1WwIY9ZgTWoG+HT13scDb1WtDYcalENgFFGa4ZZEZ8=;
	b=qbgHBHeTCnw1o5t5rc64Hxus6aIy+DYzc1Kr4ez0E8E0++fwzUGjn/5u+FGE/gYFSiIm
	 GNO6jveyXEf7XRVT7dxY/q9v+3zF8l+KCiGj0e0aGTnccme0EL55EZk6188/Ikl1Yq6wl
	 SWA4Klgudc7mSnwnB4UTzfbwmV/4uc4V6AiUf4zJFO+47wDW6x79fSEKuMJtd75Uf/2i3
	 39ktvL3GeWWqbii+zyr4UIQQpjpDMRkVowQ3U+xL8jbAmkpNoNbzqlIRRGuNw14fxIjfP
	 iRzdzo2l43vlRXlg9+ia1S0xrhVA8TBONzwknnJSxPRdXZ6B1NP7aFTCbbbbF39ZeCg==
ARC-Authentication-Results: i=1; smtp.kernel.org; dkim=pass header.d=rowland.harvard.edu header.i=@rowland.harvard.edu header.a=rsa-sha256 header.s=google header.b=NfPqMhJs;
	dmarc=fail header.from=rowland.harvard.edu;
	spf=fail smtp.mailfrom=g.harvard.edu;
	arc=none smtp.remote-ip=209.85.219.49
Received: from mail-qv1-f49.google.com (mail-qv1-f49.google.com [209.85.219.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 5B7051F000E9
	for <syzbot@kernel.org>; Mon, 17 Aug 2026 15:45:46 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=rowland.harvard.edu header.i=@rowland.harvard.edu header.a=rsa-sha256 header.s=google header.b=NfPqMhJs
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.kernel.org 5B7051F000E9
Authentication-Results: smtp.kernel.org; dmarc=fail (p=none dis=none) header.from=rowland.harvard.edu
Authentication-Results: smtp.kernel.org; spf=fail smtp.mailfrom=g.harvard.edu
Received: by mail-qv1-f49.google.com with SMTP id 6a1803df08f44-902e4af2d9dso194896d6.0
        for <syzbot@kernel.org>; Mon, 17 Aug 2026 08:45:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rowland.harvard.edu; s=google; t=1786981545; x=1787586345; darn=kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=K1WwIY9ZgTWoG+HT13scDb1WtDYcalENgFFGa4ZZEZ8=;
        b=NfPqMhJsti2n9868sBdQkEM+CV4y+x7CVGP9f1vWTSKVMGk8X51Pjg3RuHgpVO4gD4
         mZwT6Sp1z/6fd4VoNwZmtzGUq4hauNBNZOXH993RCs3Em2p9jgv7w4HVjmgH+7UHPeM4
         rXT0VLKy3slnGq5QE4Iqcm3hIIsSlUU0OWpTgEaagyXKdEdqgR4dzjXolTxKBipli2ht
         uTbUrE7zM0/BSnCNPUxbGb4P7nBqMzEZm0l7AA9WLDc6R12bL27VQsk+lkaAaPrxbh0b
         avnBMNzhB5C2saGIabgglmr2fWq3QyR+6SGOU+TweYZS3TBy5dMxgXcaujQ+owKGBWQx
         YI3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786981545; x=1787586345;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=K1WwIY9ZgTWoG+HT13scDb1WtDYcalENgFFGa4ZZEZ8=;
        b=mBNVdFmmvbWm0FgZMVN/cBqaBC6uB+dOM0PQbE2oWRw9Raj0knQrmGfEAzCKVjAC6o
         9mSkD9lNlMxemthlS+r2Qs5Z76tLpvm1ukzjD4QSzMQCry6SccCFNU2+q8XFBjQ0mAo2
         zDfg7NfvH7b9pFhZMjkVvhAlRC1KWIc86whFWsFMk26MoivVBMU/TOlsnSR61lsn0e2w
         UNkEOKl3hBDjnTIYv+Sp8DEfljWBMTWUxv56PXgVyjJEwXVlbmEh+8szi5rLUj0Liv0F
         MPNAsEUuE62nKruoqhqDO+Y6bpC/zFVAYwnyRMbgH/IUdfXN5BhTu1yrQOaY5XGygGl8
         KkkA==
X-Forwarded-Encrypted: i=1; AHgh+RpClLWR9PwZE7gwRLGvGFM7I+/yXxdsuVZ41vRqd3NJ9QtAyPJCx/Ai9K0ijlOy62ejY1ig+ZQ=@kernel.org
X-Gm-Message-State: AOJu0YwbtYcfMre4wEgVNvikYBMlrWdrJRP3wJPN+/Jo2p6dENzn23sl
	foTXBI0jqprTxdF7Jv+eL7ikcDlqcsLufLzvwvsOWQspS0QX8fzNlvMqiywnul73Cg==
X-Gm-Gg: AR+sD13RPZHCDBtq3Fpm33D9op+9KyT9pG1dpVoawoKDZ/Az9i7bd4v0YkxIuoVMHFp
	sjLgTRYWquLKWFPy97YHGgY54lgNGGx0hQebca8xS1muT7L3dRM4rkUYlfLLLwCNoVJwYlixhcX
	zjsjT2Yi+/a4yItDOxiv9qBrslfL9Ofcw7KMe3NOu1laxtgNKakUTggwcQZTzTQKS7Sm5lxncNc
	Z0/mE+P6D6fPx419S24y/vK577BWEexmFQwwGoLI2AK8atUfo4ImN5ErM/lzNPAXEkg68RKZ4OJ
	1EG2AXZOCKhxnBqo8bb8eAJ8y82HOJdkTYCoic6dTeMBjb01b+cNv8iqbP+OnB0MtflwjyaoBba
	nfy8beiREd7Lcy15tW9ZIMzZ/oFd82ebtU52iGQ2VHGh8I8xc2jqk9fikor+ilYEKMBPfd0Jac8
	ASmcmK0hu19TjtcBM4Rak6JRF4gBMriFtrttfAi56c2/tn7gB/botJy+flWneidFeSE6yBowbeu
	NpnZnMfnZ7crUj4BOzqE7K6N4B6DJEWVJtXbV+vCWI=
X-Received: by 2002:a05:6214:3a84:b0:8ee:756a:bc32 with SMTP id 6a1803df08f44-90c4cf2ed8cmr197776d6.15.1786981545001;
        Mon, 17 Aug 2026 08:45:45 -0700 (PDT)
Received: from rowland.harvard.edu ([2607:fb60:1011:2006:2008:aeb7:73d7:d8ff])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-90c4583a4bfsm11630376d6.14.2026.08.17.08.45.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2026 08:45:44 -0700 (PDT)
Date: Mon, 17 Aug 2026 11:45:42 -0400
From: Alan Stern <stern@rowland.harvard.edu>
To: Jens Axboe <axboe@kernel.dk>
Cc: syzbot <syzbot+df9e891bf8ea586f846b@syzkaller.appspotmail.com>,
	asml.silence@gmail.com, brauner@kernel.org,
	gregkh@linuxfoundation.org, io-uring@vger.kernel.org, jack@suse.cz,
	kartikey406@gmail.com, kees@kernel.org,
	linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
	mjguzik@gmail.com, nogikh@google.com, syzbot@kernel.org,
	syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com,
	syzkaller-upstream-moderation@googlegroups.com,
	torvalds@ppc970.osdl.org, viro@zeniv.linux.org.uk
Subject: Re: [syzbot] [usb?] KASAN: slab-use-after-free Read in ep_open
Message-ID: <34e65096-8827-470c-9a88-8c643cccef22@rowland.harvard.edu>
References: <6a830fab.dbb3a75c.20434b.005d.GAE@google.com>
 <7c6ce54c-ec12-4754-a36e-d5550f8337b0@kernel.dk>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7c6ce54c-ec12-4754-a36e-d5550f8337b0@kernel.dk>

On Mon, Aug 17, 2026 at 09:04:06AM -0600, Jens Axboe wrote:
> On 8/17/26 7:42 AM, syzbot wrote:
> > syzbot has bisected this issue to:
> > 
> > commit aa00f67adc2c0d6439f81b5a81ff181377c47a7e
> > Author: Jens Axboe <axboe@kernel.dk>
> > Date:   Tue Oct 22 19:47:00 2024 +0000
> > 
> >     io_uring: add support for fixed wait regions
> > 
> > bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=10e60679580000
> > start commit:   9a143525f62b Merge tag 'ata-7.2-rc7' of git://git.kernel.o..
> > git tree:       upstream
> > final oops:     https://syzkaller.appspot.com/x/report.txt?x=12e60679580000
> > console output: https://syzkaller.appspot.com/x/log.txt?x=14e60679580000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=c44651ea7dd2f307
> > dashboard link: https://syzkaller.appspot.com/bug?extid=df9e891bf8ea586f846b
> > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=120defb9580000
> > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16323fb9580000
> > 
> > Reported-by: syzbot+df9e891bf8ea586f846b@syzkaller.appspotmail.com
> > Fixes: aa00f67adc2c ("io_uring: add support for fixed wait regions")
> 
> That looks like nonsense, I strongly suspect it's a race and hence your
> bisection ends up being mostly useless as it sends you in random directions.

Agreed.

The patch below has already been sent to the USB mailing list.  Has 
syzbot tested it?

Alan Stern

#syz test: git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/ v7.2

From: Aleksandr Nogikh <nogikh@google.com>

A race condition exists between opening a gadgetfs endpoint file and the
destruction of the endpoint files, leading to a use-after-free of the
ep_data object.

When an endpoint file is opened, the VFS looks up the dentry and calls
ep_open(). ep_open() retrieves the ep_data pointer from inode->i_private
and attempts to lock its mutex. Concurrently, if the gadget is unbound,
destroy_ep_files() iterates over the endpoints, unhashes their dentries,
and immediately calls put_ep(). This drops the initial reference to the
ep_data object, freeing it. If another thread is already in the process of
opening the file, it holds a reference to the dentry and the inode. The
inode remains alive, and its i_private pointer still points to the
now-freed ep_data. When ep_open() proceeds to lock data->lock, it accesses
freed memory.

BUG: KASAN: slab-use-after-free in __mutex_lock_common
kernel/locking/mutex.c:625 [inline]
BUG: KASAN: slab-use-after-free in __mutex_lock+0x130/0xf14
kernel/locking/mutex.c:821
Read of size 8 at addr ffff0000f43acc58 by task syz-executor/5900

Call trace:
 __mutex_lock_common kernel/locking/mutex.c:625 [inline]
 __mutex_lock+0x130/0xf14 kernel/locking/mutex.c:821
 mutex_lock_interruptible_nested+0x24/0x30 kernel/locking/mutex.c:899
 ep_open+0x58/0x25c drivers/usb/gadget/legacy/inode.c:823
 do_dentry_open+0x5c4/0xfc0 fs/open.c:947
 vfs_open+0x44/0x2dc fs/open.c:1052

Freed by task 6138:
 kfree+0x188/0x690 mm/slub.c:6692
 put_ep+0xd0/0x144 drivers/usb/gadget/legacy/inode.c:225
 destroy_ep_files+0x244/0x2dc drivers/usb/gadget/legacy/inode.c:1582
 gadgetfs_unbind+0x114/0x1f0 drivers/usb/gadget/legacy/inode.c:1655
 gadget_unbind_driver+0x188/0x790 drivers/usb/gadget/udc/core.c:1724

To fix this, tie the base reference of ep_data to the lifetime of the inode
rather than manually dropping it in destroy_ep_files(). Add an .evict_inode
callback to gadget_fs_operations that drops the reference when the inode is
finally destroyed. Remove the premature put_ep() call from
destroy_ep_files(). Additionally, to prevent a double-free in the error
path of activate_ep_files(), clear inode->i_private in
gadgetfs_create_file() before calling iput() if simple_start_creating()
fails.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+df9e891bf8ea586f846b@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=df9e891bf8ea586f846b
Link: https://syzkaller.appspot.com/ai_job?id=ae49a838-5eb9-4227-93a3-56ad2313483a
Signed-off-by: Aleksandr Nogikh <nogikh@google.com>

---
diff --git a/drivers/usb/gadget/legacy/inode.c b/drivers/usb/gadget/legacy/inode.c
index d87a8ab51..a03062986 100644
--- a/drivers/usb/gadget/legacy/inode.c
+++ b/drivers/usb/gadget/legacy/inode.c
@@ -1579,8 +1579,6 @@ static void destroy_ep_files (struct dev_data *dev)
 		/* break link to dcache */
 		simple_remove_by_name(dev->sb->s_root, ep->name, NULL);
 
-		put_ep (ep);
-
 		spin_lock_irq (&dev->lock);
 	}
 	spin_unlock_irq (&dev->lock);
@@ -1996,6 +1994,7 @@ static int gadgetfs_create_file (struct super_block *sb, char const *name,
 
 	dentry = simple_start_creating(sb->s_root, name);
 	if (IS_ERR(dentry)) {
+		inode->i_private = NULL;
 		iput(inode);
 		return PTR_ERR(dentry);
 	}
@@ -2006,9 +2005,18 @@ static int gadgetfs_create_file (struct super_block *sb, char const *name,
 	return 0;
 }
 
+static void gadgetfs_evict_inode(struct inode *inode)
+{
+	truncate_inode_pages_final(&inode->i_data);
+	clear_inode(inode);
+	if (inode->i_private && inode->i_fop == &ep_io_operations)
+		put_ep(inode->i_private);
+}
+
 static const struct super_operations gadget_fs_operations = {
 	.statfs =	simple_statfs,
 	.drop_inode =	inode_just_drop,
+	.evict_inode =	gadgetfs_evict_inode,
 };
 
 static int


base-commit: f5098b6bae761e346ebcd9da7f95622c04733cff
-- 
See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
You can comment on the patch as usual, syzbot will try to address
the comments and send a new version of the patch if necessary.
syzbot engineers can be reached at syzkaller@googlegroups.com.

