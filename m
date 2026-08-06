Received: from mail-ot1-f45.google.com (mail-ot1-f45.google.com [209.85.210.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A047447D448
	for <syzbot@lists.linux.dev>; Thu,  6 Aug 2026 15:31:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786030273; cv=pass; b=PKuLHGiqX928KBGOtf65oL9hG5uktdwcnW/KAi1hSTXbVYfx8Bn7OBss4P2b9E6yNtlFIdVKhdmQmhK0+2Bz4YIKTuq5D/pXc4SyIr08mr8Z9axg2lVEnrtcbr4vtcqCiyevD1VT2X2ebpJJ8Fwu4nGTXiMD4G+yYDidq21S4rg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786030273; c=relaxed/simple;
	bh=fLiER/vmdWlHF+9sZpvO+y7EIGs75XRtDb4SFTSZC4Q=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=H6uBAMGEd7DtJ8zVKrrbJSshNyP+XhaolZcF3RRfMb68d4ZvzGjmhXWVFN0MhfukDG2Y1kQwOJiuEgzpXdTF0UeP4Y6upDWt3JznFEMIb9DIBuIYURVMbHHcRP/GlQnPD3sgc/s0/s7pmAzTJlxIyDTSkPWkwvobC9XTFUdP4TM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=LVFSO+Nk; arc=pass smtp.client-ip=209.85.210.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LVFSO+Nk"
Received: by mail-ot1-f45.google.com with SMTP id 46e09a7af769-7ec1e9d3359so1585379a34.0
        for <syzbot@lists.linux.dev>; Thu, 06 Aug 2026 08:31:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786030269; cv=none;
        d=google.com; s=arc-20260327;
        b=dRaFGvdNBwHSZ+1zX9g0RolqucFYkUYt44JD/uF3/lLtogTfAgiV/ag8HaJLJadZct
         nU4ceAoCa165TN6xqNPrfNKrsBpRiclrAtdXsk5KMSq4o00I5oSNI+LSdUCwp6Jrz1Of
         nG3LKvK23Qnyt/rq9jgGWmaEaocFpUf3L8KibUst8A1sBp2D+NCt1el1XcMgT8BKee4p
         z7Mer47B8Bln8FNBsH+C7tqF/bTCC9I4OQXwqCnlf+zRTpqoXopmEGBhiW2eA33MEYSo
         UKSRHw6BERHpzkT8GUMzOF31aP7qZxz03ttq+kIvflUx8TZFnZJgWhiqPLWH1thaztYP
         Ay9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=OeqDu1CsfKPxF1E2KpHBYLzflhrd36yx3OXDIydobwM=;
        fh=dIah8hwGBsnPd0oDCdfaELx2rQFua8JJSVww/vzsdbA=;
        b=cySqP1Itf/V4ZiI0Jvwl8F1tjen/vk6e++MDFU8nl2OHoDdBZAHRyDydlXg0o6FZiV
         huQ+L8Hqf9LLZnqH4YXg60HdqFZBEnexAe+gc276GVNekK16Sve1nDTeJU5g3HZyRS2P
         UwVIECu12CYoSXZEuMNi2wABvIXPP9sEL4FqNaW5zL6x51TF8Cz0hHN/Lt6knOAp3r73
         ITrZxO2HENejE06me86QhfVsNrRv2sSDU55cin5YK52Pxrt5JUjArZveO9K24AOdXjae
         CDT0iln4kcg80mh287BiYiEoaGfY0njCqsZs0NaIhqLuD/WVGC63YgFzZshe5HtRl1KG
         hojg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786030269; x=1786635069; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=OeqDu1CsfKPxF1E2KpHBYLzflhrd36yx3OXDIydobwM=;
        b=LVFSO+NkNZpy20a6yONERfSHbIMFyZB4YoL+Gz6ehYKWF79FSocu5+apTPakZm5Kth
         rpp2A5q3BWeVNiIoI655tniNuL9smSMK3zL60/BAdmWDTj9cNvx8a+CcxUI8LpJralq5
         sBqPDjyBEarhat0fwh2UHI6e9fw1ScWECDPVXYLCKC4C64Nvmq3Oo7Tfpp6KXFnqmX/u
         gdKBrIE8t5dPngvcxZBnREg9wraHMAGtP4tSAC4AarYZYxFU9FsQhvtot8wqK/ho/AJ4
         ewWWnqsHRmlBVNNbsH7TkxvxtPjTdoNHntD2T38ynkhe3d876+WGSGv0gbGlACpOkxTU
         m8aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786030269; x=1786635069;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=OeqDu1CsfKPxF1E2KpHBYLzflhrd36yx3OXDIydobwM=;
        b=Jhjf/OP12tgk9HHqt/nF5eCKID15d+OLhvZfsAHtiEc/yquUFj8k3guA9iSOVaMaEg
         drMM+fu0980bdRf0iGWscVOYcfg53pfO+/z8W/R+YWp3bc7R0xMYHCyTFEe+gSBBfzOr
         AExek+shWPxF2Kzqcnh+waZJGQ4UI76ao8acMwNs49ID0vK4ZA12RCtf0VKa+Quu261c
         zakdil93+9jggnODZ70sNrZwiKCtJa6lItok2vguZRoFoItR94X1P14u93hMrPiKcRz9
         T2Kab6eQzCZ8x0Wdi/3QITgcKXjsVm2fVdPjBL5gHTKXvQPOdgqMZTW5H+wtg9bdevMj
         oKjA==
X-Forwarded-Encrypted: i=1; AHgh+RoKmnHWJFAxF1m+ewQQkvF5X5b1rty/UNtuxK9aLtdalah/xe2keN0lZfro3KpL+HM8D4IW98o=@lists.linux.dev
X-Gm-Message-State: AOJu0YxLjlvR+MNL4JeIk8Ob/dT3mFtFYw+lp3f5gAubI1bSuxYWjSEX
	SmQaoGr0H8IGp+35vBRgKc75ra3emkTX3TFFZ3LoaA+9WJRttYOpOEBIDmuIBHFCKseaha0T3DI
	DTY60noxdyJEzlbowFRwUZ+pArgj6la5u5CVHaLLd
X-Gm-Gg: AR+sD10NbcSSH6VWS+scc1zNDVB68/kQggaO7zHu9WC66pPBB7tlj+Hl6LIgK9W1+zt
	J4Pk9z/vQguAc2d2QwGBL3sPAaWVP7nNyLokJRukpOqPbNESGlyblYL9afhppViOB/W1D8UJkGC
	BRuzkYgDODLn89E5QCMKf2a6MdDv+linlm7ljaNB76+3XpruJ3gLpPlplLSDL/bwATi+iXA36rZ
	BGghOSc8vztjj5or0PPEf7HH3JZLOc8mHXkF+cXUAavP7Qa8msB7SQ3zfo8JEjPfhYo3o/s90ht
	Dbvla5PMeD2kIBi6ZXuZCMfPE1DM3IKL/NZVUl0V9yDJVB5xajjzIcMTAg4YuwHhpsZmM3Ma6eC
	TmVSGZi1srrWYccJFm58V1GO4uAK54jauhTw7iMLMLB+o/H3JADDks9z1TQvBPc7GbzFmIgEYLL
	olWXVUghmYkmWQ
X-Received: by 2002:a05:6830:6685:b0:7ec:2fe:1ec0 with SMTP id
 46e09a7af769-7f1e5ce9482mr10656413a34.4.1786030267858; Thu, 06 Aug 2026
 08:31:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <2026080322-obsessed-daringly-e6df@gregkh> <20260806142511.2337081-1-nogikh@google.com>
 <2026080617-gave-widely-c5dc@gregkh> <CANp29Y7R1OzK3mo_i6uBxLV6zCgFUVxMgrfozAT-QNivp+gHMg@mail.gmail.com>
 <2026080612-whomever-abide-ff93@gregkh>
In-Reply-To: <2026080612-whomever-abide-ff93@gregkh>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Thu, 6 Aug 2026 17:30:56 +0200
X-Gm-Features: AUfX_mwrhX5F-gcC8SmlgH523aI5MC4Rm26FumdWLixY8oAPIrxsHN1tYB6voys
Message-ID: <CANp29Y4rWajhxvjR5Pag27m1+UiQAJ4LN+o2n86+=2vquaCpBQ@mail.gmail.com>
Subject: Re: [PATCH v2] usb: usbtest: disable dynamic ID support
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Kees Cook <kees@kernel.org>, syzbot@lists.linux.dev, 
	syzbot+7e1e5911f9eac50bedc7@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 6, 2026 at 4:43=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Thu, Aug 06, 2026 at 04:35:12PM +0200, Aleksandr Nogikh wrote:
> > On Thu, Aug 6, 2026 at 4:32=E2=80=AFPM Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > >
> > > On Thu, Aug 06, 2026 at 02:25:11PM +0000, Aleksandr Nogikh wrote:
> > > > The usbtest driver relies on the driver_info field of struct usb_de=
vice_id
> > > > to point to a valid struct usbtest_info descriptor. This structure =
contains
> > > > essential test configurations, such as endpoint addresses and test =
modes,
> > > > which are required during probe.
> > > >
> > > > When a user dynamically adds a new device ID via the sysfs new_id
> > > > interface without specifying a reference device, the USB core initi=
alizes
> > > > driver_info to 0 (NULL). When a matching device is subsequently pro=
bed,
> > > > usbtest_probe() unconditionally casts driver_info to a struct usbte=
st_info
> > > > pointer and dereferences it, leading to a NULL pointer dereference =
crash:
> > > >
> > > >   Oops: general protection fault, probably for non-canonical addres=
s
> > > >   0xdffffc0000000001: 0000 [#1] SMP KASAN NOPTI
> > > >   KASAN: null-ptr-deref in range [0x0000000000000008-0x000000000000=
000f]
> > > >   RIP: 0010:usbtest_probe+0x3b9/0x1280 drivers/usb/misc/usbtest.c:2=
822
> > > >
> > > > Because usbtest strictly requires pre-defined usbtest_info descript=
ors
> > > > to function, dynamic ID binding via sysfs is fundamentally unsuppor=
ted
> > > > for this driver.
> > > >
> > > > Fix this by setting .no_dynamic_id =3D 1 on usbtest_driver. This in=
structs
> > > > the USB core to skip creating the new_id and remove_id sysfs interf=
aces
> > > > for usbtest, preventing invalid dynamic ID entries from being creat=
ed.
> > > >
> > > > Reported-by: syzbot+7e1e5911f9eac50bedc7@syzkaller.appspotmail.com
> > > > Closes: https://syzkaller.appspot.com/bug?extid=3D7e1e5911f9eac50be=
dc7
> > > > Signed-off-by: Aleksandr Nogikh <nogikh@google.com>
> > >
> > > Shouldn't this also get a cc: stable?
> >
> > Is there (in general) value in cc: stable without a Fixes: tag?
>
> Very much so.  Don't you want this in stable trees so that your syzbot
> runs on the older kernels don't fail horribly?  If not, then hey,
> waiting for newer releases is fine with me, but I got the impression
> this was a good thing to fix :)

I see, thanks for the clarification!
I've sent a v3 that Cc's stable.

>
> thanks,
>
> greg k-h
