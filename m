Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CFF621B9E1
	for <syzbot@lists.linux.dev>; Fri, 15 Aug 2025 15:22:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755271325; cv=none; b=uQwQPVnPhW7dgSo2SKomRBMsvh8oXGQdvvom4jxGX/AHIYqpbP/j0YeNQDshOtNPOxZAS2EV1SncpiBvNM1W9M0tZxuwnJr7c75DEnqS0kBTHWh0o98dMUYU6oLJiPuQuZotaNi3zWmvJcVV52ry+kP8UnXV4HxDVjMH1Ia841Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755271325; c=relaxed/simple;
	bh=j2pZOp/Ll8xME4l8hvDTH5a2Er3LEWl8eRfXHYXMWGY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qKogZPJWeUHBBnKa4x3L5tpXrZegbf89lE9Gvu9q5ras4bse+avligcbdnmtkvDb7IEQQjOZ7l/kiviTGesoPIAQc9GJ468FWsvtLzFr6J3bdDnP+3MJKz7V25UEbsw/8Ba+Zf3kka/urexC0jhvwXhcVCmdow056LiOY9x7xB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=x450RjGo; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="x450RjGo"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-24458194d83so14448445ad.2
        for <syzbot@lists.linux.dev>; Fri, 15 Aug 2025 08:22:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755271323; x=1755876123; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xuyH90gkUAf5XyPitU31xhXzReShLZrWvyxuJeeZHjk=;
        b=x450RjGoHxhzax6b6wJi7pifnpnR2v9YHo98JDJOZQP5Y0m5KaGR3ekNIIXWtuBu7B
         l8yxxDGQ5iK2jx7tzyVQGz7c3Dc5POeGPXI20ZxoUHyhuP4aPEXRAfI5Xe5DUWTdhieP
         U+33VH1L3ig73+af3zBK7ta6cP0nsuE2nABnUaneujZQymmEhVB5UEW1S129oxUoZ8G3
         Sw4Ah+yNGKD/IpOVhMmAxBX1r0ORqA2kn7E6yBGNSuDZfSN4bNmEe+fdhO+m2W3EvK+n
         PB8XMyKkctYg/Vmf508OhE2qjcmN576IDEwwqtUAtRJ2UfaGUCz0SRKVifjNtcyjiLXy
         AP6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755271323; x=1755876123;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xuyH90gkUAf5XyPitU31xhXzReShLZrWvyxuJeeZHjk=;
        b=ov4N/+EtRzsqtPksnboOzuE/g/KkwFm6Er6m/hMCIIt8Xkj0kQpMomPfPacNvkxpv9
         DhmQSPC1nRzYGhlR/vJs2VXrTt2qDX0HH5gr77eCsW5G5JwDLBRq3QI5WP0F8YNlkmwo
         vLoPZUAz93es/4ibcwZ1g/ePwp8++sisRz/5qFVx1SMEP4JpO6FK6G9nTdoza7njjBzm
         5UfESEpgY0UrYRm4baJH0a5DJnlVGv7ZTON7UkhCwh1Dr6a0pErX5C04C9FuGC+zy4h+
         NE5ZsgTczRoVV69OqYmeIzC2yI5jw5UV2gOBTRoSjjm2mhUk5EBe3nhOfjts3qLj/KJZ
         ln/A==
X-Forwarded-Encrypted: i=1; AJvYcCX+jg2ZJ8ws73Sd2vGZKgY93nIjaIipT6MXMIaGDyuUsVVHpURSy4TXRBSzkNn2tEgKFNgiauU=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy+xHe3YbTIOoQVelhv6ggtyb8NAtLxZc5tESPRkAQ4dJZ1VHez
	wx8bqLHdtWP5Nybdcce7StI3DwtgMzL0Nk76hpcP4PBeoBc7FJZtCHAAL5QZbjfDJvr6i3S1k8b
	G01mt8uTmYqlWdg5kBMmeNtgB1XGXiEkeMKKTeyCW9UPLltAOBYHjpyNd
X-Gm-Gg: ASbGncsgOBSbKs/mMIXg2cQcXsBOSzgcciZqD1pPH1uNgezatIO0x129OZWcmkPtbTR
	bfU1yn5G3w0FA/xWY03KTEoMA1XYuvLg1DltUzq3q7X+EW2GT22g0qJ8lAO6qCwsfR+kZfVsnlQ
	AmiAqm++qM4z8Of4MnGxVSsTzfTIVP9Xtcf5galMsr6vLC94hjUz3BSDzHYnsd53ZzJszEoIHlC
	0ybx1RpHXugrbJ8Gjd4CnCUZKqHsV01X8Pa5TU3TDzo5g==
X-Google-Smtp-Source: AGHT+IGfewVjcCO2QDoaPewG/2JmNxawbROGmBIR2TLrn5d2FlTXDoj2bsrrDMGBDAXZIg55gDgVVPnN5d8pMsSbIXE=
X-Received: by 2002:a17:902:f64d:b0:242:9bc6:6bbf with SMTP id
 d9443c01a7336-2446d9dc37fmr34261615ad.54.1755271322645; Fri, 15 Aug 2025
 08:22:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <689f4c1d.050a0220.e29e5.0018.GAE@google.com>
In-Reply-To: <689f4c1d.050a0220.e29e5.0018.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Fri, 15 Aug 2025 17:21:50 +0200
X-Gm-Features: Ac12FXzDqJyOU_hX2Ealk7lWsasSHTvi6zvU4AxOX5TYK0t09k6xpmJ5dmpn99c
Message-ID: <CANp29Y79weXCPFU3z7j23teQUA5jHDmb-MYigdCR6jc5jX8GGw@mail.gmail.com>
Subject: Re: [moderation/CI] Re: Support "generic" CPUID timing leaf as KVM
 guest and host.
To: syzbot ci <syzbot+ci4406e0cb3d089e22@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Fri, Aug 15, 2025 at 5:02=E2=80=AFPM syzbot ci
<syzbot+ci4406e0cb3d089e22@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v1] Support "generic" CPUID timing leaf as KVM guest and host.
> https://lore.kernel.org/all/20250814120237.2469583-1-dwmw2@infradead.org
> * [PATCH 1/3] KVM: x86: Restore caching of KVM CPUID base
> * [PATCH 2/3] KVM: x86: Provide TSC frequency in "generic" timing infomat=
ion CPUID leaf
> * [PATCH 3/3] x86/kvm: Obtain TSC frequency from CPUID if present
>
> and found the following issue:
> kernel build error
>
> Full report is available here:
> https://ci.syzbot.org/series/a9510b1a-8024-41ce-9775-675f5c165e20
>
> ***
>
> kernel build error
>
> tree:      torvalds
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torva=
lds/linux
> base:      dfc0f6373094dd88e1eaf76c44f2ff01b65db851
> arch:      amd64
> compiler:  Debian clang version 20.1.7 (++20250616065708+6146a88f6049-1~e=
xp1~20250616065826.132), Debian LLD 20.1.7
> config:    https://ci.syzbot.org/builds/590edf8b-b2a0-4cbd-a80e-35083fe09=
88e/config
>
> arch/x86/kernel/kvm.c:899:30: error: a function declaration without a pro=
totype is deprecated in all versions of C [-Werror,-Wstrict-prototypes]
>
> ***
>
> If these findings have caused you to resend the series or submit a
> separate fix, please add the following tag to your commit message:
> Tested-by: syzbot@syzkaller.appspotmail.com
>
> ---
> This report is generated by a bot. It may contain errors.
> syzbot ci engineers can be reached at syzkaller@googlegroups.com.
>
> The email will later be sent to:
> [ajay.kaher@broadcom.com akataria@vmware.com alexey.makhalov@broadcom.com=
 bp@alien8.de dave.hansen@linux.intel.com dwmw2@infradead.org graf@amazon.d=
e hpa@zytor.com kvm@vger.kernel.org linux-kernel@vger.kernel.org mingo@redh=
at.com pbonzini@redhat.com seanjc@google.com tglx@linutronix.de vkuznets@re=
dhat.com x86@kernel.org]
>
> If the report looks fine to you, reply with:
> #syz upstream
>
> --
> You received this message because you are subscribed to the Google Groups=
 "syzkaller-upstream-moderation" group.
> To unsubscribe from this group and stop receiving emails from it, send an=
 email to syzkaller-upstream-moderation+unsubscribe@googlegroups.com.
> To view this discussion visit https://groups.google.com/d/msgid/syzkaller=
-upstream-moderation/689f4c1d.050a0220.e29e5.0018.GAE%40google.com.
