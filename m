Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793892708;
	b=4IkkgamOqR5/r2i+00hu5rJXCX2TMhIDh6H/AstMErXvOWDa/eStCiWk8SjmHp/8+URW
	 7sodg3OmZKUZhg2JtA06XSpGJHIpATD3B93/2uCP6zs61a8jpRU7gDWRgfV35UoZ7USq3
	 7afjWUb2s0sSgHD8Rg8zQDaw79TRg4dvLFNDSmCawWhTjaC3giOK2H4hcLPtD4+DKF326
	 lXRxlXHv75jHTQIszQNsLAM0BVrVItu3UAnxm1CjeuIqZdi5FtMF+DUV7CCrY1sRhyTYb
	 4VvBfzssH+Pe01/dXrustkDCdo4F4TrMihja3tkqgRQLTH6T/Axsfzjph7Qoj5+CsTQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793892708;
	h=Received:Delivered-To:Received:DMARC-Filter:Received:DKIM-Signature:
	 X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 Received:Message-ID:Date:Subject:From:To:Reply-To:Cc:In-Reply-To:
	 References:Content-Type:Content-Transfer-Encoding:MIME-Version;
	bh=CgrgcR/Qznv2UxV78SRAe2w6aq04pP3vyGHaTftQ3Vw=;
	b=cCXEXM7s4ecp2mkXhK5ztd9qeb2+j+KeflINV4GtDWXmv1nzjiKPYKeBpSGpEs3i7DZZ
	 sE7OtxG3fnRXILKvP4nwHXMk+7Ya4J9n81LTreekJxAK3u5OEc1EzrDA4q4vx6Ee8frTD
	 3TgAox6fjRY3g7S4haYMpAiQIanuIKvtE+gh8m5gPy9ZCzC8agBiAcFwfDg7oq+wZ2B11
	 hxw8vHcgdnaeZLVQN1QELJCmfNv6mf5Q4AiEMYFEn1yko+5NocsrPrhMJ66zBXYDdec9M
	 nrqSkJOzy2gJ9ANyxdV7SUM6/ZPPwn6dClFy+aGEKtbJFrTyPikhZencHl5VOCkdwHA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=ribalda-com.20260707.gappssmtp.com header.i=@ribalda-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=ofYWk2Nz;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3886606A329
	for <syzbot@lists.linux.dev>; Thu,  5 Nov 2026 15:31:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ribalda-com.20260707.gappssmtp.com header.i=@ribalda-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=ofYWk2Nz
Received: by smtp.kernel.org (Postfix)
	id C46AC1F00A15; Thu,  5 Nov 2026 15:31:47 +0000 (UTC)
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=209.85.160.41
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1793892707;
	b=Vrn3H40tb0bJKxfnVXFPyD0wrT3czyIatKCzai7LqHU++aeOaNbzgQsE5XpAnBlt4yoB
	 MXjCrx3jYxg/yiaFqHpFIIc4hq2ufyCY1RBE1nFnnABtMvpDNngj4Ps5IgeCgu6Xu7o7y
	 FpN6HSHZ/nmsVC+tz3v4RQ3O2WxG5sHBlsOpQaVHjV+jhqaXL2IWu+hZ4P6TqK9eV3CBr
	 tdy5BmcwgcE4Sfd5ZygzeX507tN0qNGAF11lSTjboe621d39xEYBtVu6dk8SjT5THMM/D
	 XHqX1gWEok5XD2EJLHlSGpJOO1R3MfEBQt0HJtr9ohVRvBQmCHgkcLI5s5u4fwyDyVw==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1793892707;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 Subject:From:To:Reply-To:Cc:In-Reply-To:References:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=CgrgcR/Qznv2UxV78SRAe2w6aq04pP3vyGHaTftQ3Vw=;
	b=CVB+LZxDKTu1IIiIluobiKmzdsJiSUhSRyhlKWXkhMtv3/bN7qlfIsVfBQDQfXXc6ytW
	 RDfYzqjPT9nmOl0uI4R0Ffmo/HQnFrMSgT1gMiBFTQvkTGmyyHi4R3ax+mj0sK5mPhZGJ
	 oG9Six9gGg8H8MRVgTSiC0D5DVL8Wbcb9d51Bt8W3ICROoGwiaAyYnEreCJuBcAJd4jkE
	 OWgJ0uWeqVl/qeuTilPlc8/ldbJIllusFd3BZfkKXepvyAHX430Yp1J/WFB3JlUe+OlDg
	 tkg1TaIGMQlQt0wCncmOSBdXXsabIP8003wAuwgf9tugPpIpgTyn+fnbuXvkJ+DH1/g==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	dkim=pass header.d=ribalda-com.20260707.gappssmtp.com header.i=@ribalda-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=ofYWk2Nz;
	dmarc=none header.from=media-ci.org;
	spf=none smtp.mailfrom=ribalda.com;
	arc=none smtp.remote-ip=209.85.160.41
Received: from mail-oa1-f41.google.com (mail-oa1-f41.google.com [209.85.160.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 0AA521F00919
	for <syzbot@kernel.org>; Thu,  5 Nov 2026 15:31:46 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ribalda-com.20260707.gappssmtp.com header.i=@ribalda-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=ofYWk2Nz
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.kernel.org 0AA521F00919
Authentication-Results: smtp.kernel.org; dmarc=none (p=none dis=none) header.from=media-ci.org
Authentication-Results: smtp.kernel.org; spf=none smtp.mailfrom=ribalda.com
Received: by mail-oa1-f41.google.com with SMTP id 586e51a60fabf-4a85c656c58so1251827fac.3
        for <syzbot@kernel.org>; Thu, 05 Nov 2026 07:31:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ribalda-com.20260707.gappssmtp.com; s=20260707; t=1793892706; x=1794497506; darn=kernel.org;
        h=mime-version:content-transfer-encoding:content-type:references
         :in-reply-to:cc:reply-to:to:from:subject:date:message-id:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=CgrgcR/Qznv2UxV78SRAe2w6aq04pP3vyGHaTftQ3Vw=;
        b=ofYWk2NzcML2MQ8LpMOsGKJ4fUzNHyljAbIV1KUTb8166tqz6OzctaeA7OJILUZsLv
         Yy4UPXLLmNfN4ZDOOjJ8o2fRjfAXPGuHVEZSK5YDOZhAChJQt3KX34zz2zOj7n6r5LVx
         nyP104Z9t6oMnxCN4TOqaDMruiXXVX3O8Qh4KUpeKmJn9xkhFACnSvTrtJ8GFQ+4MOAU
         ZajKCVJ4srmzra4zp7rIsygNzyy4Ldi1kUBy74gLU379Hw/2bbVtaGK0QCrbPMKybZnM
         RBmqVZi4I7XtI/RUi1tu7hFcJq4SDpKo9RsfAY1sN/xIGhkf4XT93RHaZWxlnQGvQ+/1
         5gow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793892706; x=1794497506;
        h=mime-version:content-transfer-encoding:content-type:references
         :in-reply-to:cc:reply-to:to:from:subject:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=CgrgcR/Qznv2UxV78SRAe2w6aq04pP3vyGHaTftQ3Vw=;
        b=H/q/vbJ5Ccnx1GXaDA6gvz592arrtr0cm0RzZPsr2P/wPzGZYk2ZO2TX17iqNjKMaB
         6Y6LHU6lT8FgDeJUB/9b+mZm40UnmgnbJvXo/h6zxvL2Rn7l3k3yVssbsxtBqlxDsb8l
         HURlJszbyWgV+rdnTLUCXomtZtipQXx/aOvbm5jFMlbkhLbcRTPWIW7FZydDNA3/8nAn
         cxxkb0VJPhOt0zdEnO6zEVIH6z6Fw05AeHs+phrIddnsedNxTBeVAWjjMsPdSJvYHfjA
         dCFxVO5a8QS0CUDyR/B48gxcu9fU6FXC554/Fk8xY7pqJAyn0bNwupEXI7vGMQ4UjG50
         2Zyw==
X-Gm-Message-State: APuU4Z/hODyxR6rS4JRMKH3jn2aE4p3WeRVNrTr3elnmnLWZk/Itzbe6
	r213YYPO8+7TgSKyDxyoAKQpLZJ2h/TiF+eDoUpZKwx9L0poufpOTUQTSKywb+J5/HDMW0lT6Fr
	ni8Ju8/w=
X-Gm-Gg: AYBFou1FdknRe9osXclNN8X8Vqs1vlInjgE22eEltRc2JvBIaZlshayT/oLquxAircZ
	xNLOSHGNeGKNv6XiMPesGlmmbf8Rkr9VeCHcAttED7JT5YnaFbxKyCDZ8saqutLSgEcbDqcvtmW
	l6IbcS/nSzIANg+Bc8FJu5zkJBaXMXnf2Iz655B4o0xzXShGYmtX2KV67rev3HY449+hB6Rla2y
	x9dx0Pyf1L+ImIM+OFleaMYPtnkisCdn5H5GNT7JSABmUWbCL9cpIE5sK/ORoryewjHtNQcaob8
	X9EAmxRrYKrfiTsR1vWmbCsC/f+QUUa4PkMiEPW2gHG/uT+cmq738grwNI2jLm9BPQU20MjE7NC
	obPAFdpZKd3T1opeVCBalXnNGLPZolHAgKybtoIAb4Xi0JaHRgPCF8MIli+u5bSPvcyjWsIuRdm
	ASxxysOvodJB4io8RXblsbLkTsiUJDcl0AMxg2D8vpMZ7FFL/FY+89NZBQ/tvi3Fw5/D8BKt4mu
	y92c8ZqDMpPL8qHUWhqUOS3oXhTLsIXjF63uQbhVIaypwK4XKE8XzLNGyMGkkjko/Qv38rg7lRZ
	dvHjSqCZQo9A10SyUZiqzkNjzeE2sgzwicC9or0+SWpS6UsjsTWNGoKg/aKBZg6Lg2KXL0mxARL
	9E9kMMUNzMgbo0danlpgcb8AG5k2PcQ==
X-Received: by 2002:a05:6871:cd8a:b0:4ad:5a7a:f7e9 with SMTP id 586e51a60fabf-4ad5a7bfbc7mr2844880fac.34.1793892705575;
        Thu, 05 Nov 2026 07:31:45 -0800 (PST)
Received: from gitlab-scheduler.us-central1-a.c.linux-media-ci.internal (172.60.173.34.bc.googleusercontent.com. [34.173.60.172])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-4acea680cacsm4559948fac.16.2026.11.05.07.31.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2026 07:31:45 -0800 (PST)
Message-ID: <6aeca161.99d0dbd8.3801b.50e8@mx.google.com>
Date: Thu, 05 Nov 2026 07:31:45 -0800 (PST)
Subject: Re: media: mxl111sf: initialize state->d and fe_lock in probe
From: Patchwork Integration <patchwork@media-ci.org>
To: syzbot <syzbot@kernel.org>
Reply-To: linux-media@vger.kernel.org
Cc: Linux Media CI <media-ci@linuxtv.org>
In-Reply-To: <7cbccdb8-870c-46c4-bc61-2e40d8c4b4db@mail.kernel.org>
References: <7cbccdb8-870c-46c4-bc61-2e40d8c4b4db@mail.kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Post: <mailto:syzbot@lists.linux.dev>
List-Help: <mailto:syzbot+help@lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
List-Owner: <mailto:syzbot+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0

Dear syzbot:

Thanks for your patches! Unfortunately the Media CI robot detected some
issues:

# Test media-patchstyle:./0001-media-mxl111sf-initialize-state-d-and-fe_lock-=
in-pro.patch media style
ERROR: Commit 4c66c9205c0788e18eb09d482461aa2f551ee046 found in the stable tr=
ee, but stable@vger.kernel.org not in Cc:
WARNING: Non-standard signature: Assisted-by:
#65:=20
Assisted-by: Gemini:gemini-3.8-flash syzbot

ERROR: Unrecognized email address: 'Gemini:gemini-3.8-flash syzbot'
#65:=20
Assisted-by: Gemini:gemini-3.8-flash syzbot

total: 1 errors, 1 warnings, 57 lines checked

ERROR: Fails one or more mandatory checkpatch tests

# Test checkpatch:./0001-media-mxl111sf-initialize-state-d-and-fe_lock-in-pro=
.patch checkpatch
WARNING: Non-standard signature: Assisted-by:
#65:=20
Assisted-by: Gemini:gemini-3.8-flash syzbot

ERROR: Unrecognized email address: 'Gemini:gemini-3.8-flash syzbot'
#65:=20
Assisted-by: Gemini:gemini-3.8-flash syzbot

total: 1 errors, 1 warnings, 0 checks, 57 lines checked



Please fix your series, and upload a new version. If you have a patchwork
account, do not forget to mark the current series as Superseded.

For more details, check the full report at:
https://linux-media.pages.freedesktop.org/-/users/patchwork/-/jobs/115152362/=
artifacts/report.htm .



Best regards, and Happy Hacking!
Media CI robot on behalf of the linux-media community.

---
Check the latest rules for contributing your patches at:
https://docs.kernel.org/driver-api/media/maintainer-entry-profile.html

If you believe that the CI is wrong, kindly open an issue at
https://gitlab.freedesktop.org/linux-media/media-ci/-/issues or reply-all
to this message.

