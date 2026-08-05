Received: from mail-oa1-f41.google.com (mail-oa1-f41.google.com [209.85.160.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 712323537F9
	for <syzbot@lists.linux.dev>; Wed,  5 Aug 2026 14:13:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785939210; cv=pass; b=g/B1Y41MjqNvEln8HAl2gny+zf1TxvctSXnpaHmLpLszYVIZqDBhH4VUEDNYQGQmv8gifsSzs/4HcFV9pziTVm+XCCYipMtKRVEZFBDQpaWoLWid7wAfd8KjhlWnKKGy3dtgN6WwnZi2f2nRNSAbQRXXShIlIt2VDFpWeO3qOlM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785939210; c=relaxed/simple;
	bh=afhhqFuykcv7hhvulqRjFX0bdgZOLtv2/4ShhBtmydM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WE62p6Um68EymNRxlfu4rlp2emZEcfefMSusIo8ijVIgiY/AD0XAQM/5H9d7M1Wxq8TAm2IczQFMl8zKGXtnbZW/t78s35K5sVaXVmNFvBcyfgzf8Gow4Q1ns9fWHxvZWL3MOEbRuF55ZE293ekDkNhRqNElMozRccplyRyVgCc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UXRyRiz8; arc=pass smtp.client-ip=209.85.160.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UXRyRiz8"
Received: by mail-oa1-f41.google.com with SMTP id 586e51a60fabf-44caeb973b3so718340fac.1
        for <syzbot@lists.linux.dev>; Wed, 05 Aug 2026 07:13:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785939207; cv=none;
        d=google.com; s=arc-20260327;
        b=GHmLSzxQaXhxz3txhPJRf3wyHPSGHbj3Giw7XT6t0Iu8TxhYAT5uzYjq7TJH6RzHQY
         N4r/YIRCfbvAMkp9r6+eFl1cHc739IiYNVlkymJRANYJYZgvchZ/89sDVYwv9pUr0zel
         LwODJkJA768XRo/NJLK28OH9Qha4P/GhjFZPUEg0mtO09nT4s/PxFLIXScd/0E4hof64
         QrgIR6/bGvyQ49WdLWcZq+Yf8G7W1xSSxRotXo3GW/fLfwdXMqLTx1OfhE42My09hfNc
         3ZUWE+NeJxdiS0L3xSuRKVIYemrH4TGq7FbGlXGa564L5tniX7/rjefzqoWuGc+S1SBw
         Ju6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=bXctWwNo3iIy6LzUUnEZmgCBo1i4OHbmKz1fGWKMmxg=;
        fh=8ZHkXfmr0fj6MmalgCtKqKnB9OqvX7RfL6QET2GGUmc=;
        b=XvocvtVEuTMw7vrY2ST/Yfqsrm5G8/M6qO3GZrnmn60AjutvP/npeD8V/hh4m9bgfn
         7v2LUuc51NJHEd7sp8aZNxWZvbyssLSXLlyidf7lZvgvogxun5uDgeiyvvKXfuNVTlMg
         edMlrlK9blbyjriJSgXLjA1212KyUJYHMtdqKGkF9/Lt9pFZ0Yebb1XMARQJufePHHyS
         ps988q7V10FD+/v2BBmV0GtdXRSARGF6vZgaZhyZmOFkkFjYiYp5PvQtGo434Xq7z5RM
         p+D8eoz3Xa/0q1++XofKgDjfo/zzCZpPZ/jM9s/OlE61eonJkHJPQVgb31drbcZAvhgT
         x33w==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785939207; x=1786544007; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=bXctWwNo3iIy6LzUUnEZmgCBo1i4OHbmKz1fGWKMmxg=;
        b=UXRyRiz8s39MY0NPZGl5r9/qs8kfeXG1QDX41XrQ9+SHKjuKoAL888GlKRnkEFbPAm
         8guhvJH8hi+vSM9jFOGWdKG9qXhMKxLwsIFCdK9zfz154J/nMlZnqzNnjHxtWUPgpabX
         0YV+kNbakKWOtOPBs07uQbG40pBxjgzgv8Pi0cYu8dOLmUe8pA9PnGb9JQb3U/GVru1I
         NDfj+YYCDHGnk0f31a5cAv9ENiLatGXHd12NyCLldmAagcjpWHwi5B6owDqAMniDzADz
         Jj+UfeENGo9OiHIrCb2tP3X7SGf+1K/08ZLVZl+W/3N+1/Jk52qqCbg9hJqv6pGA/+I9
         Cirw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785939207; x=1786544007;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=bXctWwNo3iIy6LzUUnEZmgCBo1i4OHbmKz1fGWKMmxg=;
        b=Fr0xrlTCRpyUbVMEKJc5RrxDhOHPownTJbxq/3tN7k2HgIchiU6u4s61YyAzdlAJ8I
         qP7qo5e/m8K/I2nvXbMTnwY7nf38a8/vp+jBqPQTDKGsC9mnu1lhBOGPjcj7JwCUA+SP
         PRb3Es7IdFF6tfWnQaMufM0DvlEB+9kp61rEq+gy9BOABHfjJZvonFquZZaDUNs19Fx/
         2TQnKcjA2SnZxMrOTnl41JINqda6Rl6zRJIsM6+yl+o8mIoGPtoX9QcyB7IsNen7Vuh6
         y7FOjy5qrUQlmc7RD4J2mXjZCkJnX8Kqn43X4KUlDtsMLGkJRJ2W1e4n4RqPuyltEriT
         7tKA==
X-Forwarded-Encrypted: i=1; AHgh+Rq9CNu/daEp3Ry/kwWvFZxqDzZ3/uIhHWH7YsCux647UgYmL613Qmgyi3gVYnTdVg/ulNBGK7k=@lists.linux.dev
X-Gm-Message-State: AOJu0Ywk48DFMzNaAn54Pr0qdmjcBWCCi85wbgj8nWPeFQQmVnZPBglv
	rlEnWIkIrNhQKe+iD6ODhAgaW6q0NWiShGJJIyuIZinru39ncuoee+BkhDv45JSpIL2PHB1AON+
	xmOG+IrgPyf35brm66KtldL5IPWrtpUAo5Wz3NnJm
X-Gm-Gg: AR+sD12TQ7JAu6HlSZnTlZrgJeCWcinoR+6MfD4yiniC7QZpu3TrkDZlzBnOstV1YzZ
	5aL12R0F5mUC0K1Tpun9YLZKutpuCBkJAfQ91+y+a/nrLjjNOxQW+Xz8miuiFy7G/QjtHH/hs38
	UXK7lnRfEPxPOx16n734aDwv51iJfVSrLG7CfyHBTrh46/dvg1jjYNi92nJ22U6koeXa697i7L+
	TNikrkvStTYZgzwGFStdSPd3FKQ/3LJ/ROzlFx6h42el608K89m4/M92uJelVSq1wWUL9F7hyNJ
	QjHfKq5vdZ+6oh5Fcw1YnkORGJ2XHxw0xEcFsPcaumr2d8GG4qyvrYxLFmZ+nsrARm92q0/bx7v
	fVULal2kPbxot5jc1eQigcli40nPkXZdKxDjwXNaydFwWkY7b5bVtTIRfcQ3pDpOoTJPxMi5OYH
	UaThX9Wj1GwHv7
X-Received: by 2002:a05:6870:8112:b0:456:b9a1:796e with SMTP id
 586e51a60fabf-4599eaafda8mr3840710fac.2.1785939206668; Wed, 05 Aug 2026
 07:13:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <92acf44b-fcee-4138-90ea-0a2275b9ddd8@mail.kernel.org>
In-Reply-To: <92acf44b-fcee-4138-90ea-0a2275b9ddd8@mail.kernel.org>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Wed, 5 Aug 2026 16:13:14 +0200
X-Gm-Features: AUfX_mwo-IMtmn1U2DU4Q8aqSX4yQfNmgbx0x5dnMhiuqWbD8rjK5fjzjK9t1J4
Message-ID: <CANp29Y5s=yArS31h-PQj-mYfxcx8m_ud4ydOUFT0DQ84jvNQBw@mail.gmail.com>
Subject: Re: [PATCH RFC] usb: gadgetfs: fix unbalanced refcount in
 gadgetfs_bind() error path
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Wed, Aug 5, 2026 at 2:59=E2=80=AFPM 'syzbot' via
syzkaller-upstream-moderation
<syzkaller-upstream-moderation@googlegroups.com> wrote:
>
> In gadgetfs_bind(), if an error occurs (for example, failing to allocate
> the endpoint request), the error path calls gadgetfs_unbind().
> gadgetfs_unbind() unconditionally drops a reference to the device object
> (dev) by calling put_dev(). However, gadgetfs_bind() only acquires a
> reference to dev at the very end of the function upon success. This
> mismatch causes the reference count to drop prematurely.
>
> If multiple UDCs are available, the driver core will attempt to bind the
> driver to each of them. If the first bind fails, the premature put_dev()
> can drop the reference count to zero, freeing the dev object. Subsequent
> bind attempts will then trigger a use-after-free when accessing the freed
> dev object.
>
> BUG: KASAN: slab-use-after-free in gadgetfs_bind+0xd8/0xae0
> drivers/usb/gadget/legacy/inode.c:1682
> Write of size 8 at addr ffff88819002e900 by task syz.0.17/6152
>
> Call Trace:
>  <TASK>
>  gadgetfs_bind+0xd8/0xae0 drivers/usb/gadget/legacy/inode.c:1682
>  gadget_bind_driver+0x2ca/0x9e0 drivers/usb/gadget/udc/core.c:1662
>  call_driver_probe drivers/base/dd.c:-1 [inline]
>  really_probe+0x254/0xae0 drivers/base/dd.c:706
>  __driver_probe_device+0x1e8/0x360 drivers/base/dd.c:868
>  driver_probe_device+0x4f/0x240 drivers/base/dd.c:898
>  __driver_attach+0x339/0x600 drivers/base/dd.c:1292
>  bus_for_each_dev+0x23e/0x2c0 drivers/base/bus.c:383
>  bus_add_driver+0x348/0x670 drivers/base/bus.c:763
>  driver_register+0x23a/0x320 drivers/base/driver.c:174
>  usb_gadget_register_driver_owner+0xf9/0x270
>  drivers/usb/gadget/udc/core.c:1752
>  dev_config+0xe4e/0x12c0 drivers/usb/gadget/legacy/inode.c:1883
>  vfs_write+0x29f/0xbb0 fs/read_write.c:685
>  ksys_write+0x156/0x270 fs/read_write.c:739
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>  </TASK>
>
> To fix this, move the get_dev(dev) call to the beginning of
> gadgetfs_bind(), right after the gadget data pointers are set up and befo=
re
> any potential failure paths that lead to gadgetfs_unbind(). This ensures
> that the reference count is properly balanced when gadgetfs_unbind() is
> invoked on the error path.
>
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot
> Reported-by: syzbot+f63ad1084fd77fab48e4@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3Df63ad1084fd77fab48e4
> Link: https://syzkaller.appspot.com/ai_job?id=3D6fafa316-17a5-4928-b109-4=
b866d73749d
> To: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
> To: <linux-usb@vger.kernel.org>
> To: "Linus Torvalds" <torvalds@ppc970.osdl.org>
> Cc: "Christian Brauner" <brauner@kernel.org>
> Cc: "Jan Kara" <jack@suse.cz>
> Cc: "Kees Cook" <kees@kernel.org>
> Cc: <linux-kernel@vger.kernel.org>
> Cc: "Mateusz Guzik" <mjguzik@gmail.com>
> Cc: "Al Viro" <viro@zeniv.linux.org.uk>
>
> ---
> diff --git a/drivers/usb/gadget/legacy/inode.c b/drivers/usb/gadget/legac=
y/inode.c
> index d87a8ab51..ba901023d 100644
> --- a/drivers/usb/gadget/legacy/inode.c
> +++ b/drivers/usb/gadget/legacy/inode.c
> @@ -1682,6 +1682,8 @@ static int gadgetfs_bind(struct usb_gadget *gadget,
>         dev->gadget =3D gadget;
>         gadget->ep0->driver_data =3D dev;
>
> +       get_dev(dev);
> +
>         /* preallocate control response and buffer */
>         dev->req =3D usb_ep_alloc_request (gadget->ep0, GFP_KERNEL);
>         if (!dev->req)
> @@ -1696,7 +1698,6 @@ static int gadgetfs_bind(struct usb_gadget *gadget,
>         spin_lock_irq(&dev->lock);
>         dev->state =3D STATE_DEV_UNCONNECTED;
>         spin_unlock_irq(&dev->lock);
> -       get_dev (dev);
>         return 0;
>
>  enomem:
>
>
> base-commit: 075b74841bd0065a3bda3440873c747938e69b68
> --
> This is an AI-generated patch subject to moderation.
> Reply with '#syz upstream' to Sign-off the patch as a human author
> and send it to the upstream kernel mailing lists.
> Reply with '#syz reject' to reject it ('#syz unreject' to undo).
>
> See https://goo.gle/syzbot-ai-patches for information about AI-generated =
patches.
> You can comment on the patch as usual, syzbot will try to address
> the comments and send a new version of the patch if necessary.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
>
> --
> You received this message because you are subscribed to the Google Groups=
 "syzkaller-upstream-moderation" group.
> To unsubscribe from this group and stop receiving emails from it, send an=
 email to syzkaller-upstream-moderation+unsubscribe@googlegroups.com.
> To view this discussion visit https://groups.google.com/d/msgid/syzkaller=
-upstream-moderation/92acf44b-fcee-4138-90ea-0a2275b9ddd8%40mail.kernel.org=
.
