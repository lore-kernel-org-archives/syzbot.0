Received: from mail-oo1-f51.google.com (mail-oo1-f51.google.com [209.85.161.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E12DF43ABC
	for <syzbot@lists.linux.dev>; Sun, 15 Mar 2026 12:28:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.161.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773577733; cv=pass; b=Yrx7457cha9IJhBG6gaw4jJLjAu9N9UJHZrlCFRU7w1w3RiA4qYZbbZWfKxF5t5Sj/NGHdMSdtvGF3L8boKXZfJVVHtEckLbcKIxg0LIQ0SH+GJwOJjByLfRGwAlDqUvrVg9eNpYUVbzT2yYTDKIHRUSMj3qR8IbDjJ22bb8VGk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773577733; c=relaxed/simple;
	bh=0oevi1PbMolBWAIvtB7xNBzrSbDZ9aA6MxQPJYNxO64=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=etr15iVGsQWcAHPysjFJK5LeRVzsxXlw2/hYSNvNYjQpggoSS4tsJN0NA9rcLYuVSZYWE+EocqnuuWq9aX7yki9P56FFqUOk0FnhWb4CNdhHZmKOrhAqIIhX61MjuBoLsuhnqdCpQHtzK/6PbaQf4JfuhUzPRM904NKcz4SNuj8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=rFU2XQ7P; arc=pass smtp.client-ip=209.85.161.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rFU2XQ7P"
Received: by mail-oo1-f51.google.com with SMTP id 006d021491bc7-67bc8bc0e22so2030552eaf.2
        for <syzbot@lists.linux.dev>; Sun, 15 Mar 2026 05:28:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773577731; cv=none;
        d=google.com; s=arc-20240605;
        b=I5OpNoGSbaDWyAkUP6noUmdppT1JzAvSZHO7ySjOujJ3Bs6Ha/C3DnkHXoYaLmWIKB
         ekOyh/NtIRXt+v0CYJyptYUPpjnOCX5+GA4/S6cknZJxscwp95x4Em96LEECpkl4yDE7
         GhLifhrwcz1eP7gcZds1XV2xTgS0FY+QQjbohTSDRElJ3xrS/7h00Z8/NLpk2EyJ0lhT
         sVqHKKmee+27Ru0iZh/DcvTf7nQguCO+1qW1wCjebts4Cnm6uEgG3vVt69XxHu2BnkXJ
         NJAhE67msRF5hYjDlmsVREM9syw26PwzCs18HwXF4eaoZBwFYsKf97Yt+y1hpssFqpaJ
         3onQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=QeqDDzd840VOJxix9aZJyGlIkyITMsYMJnroyqzeUw8=;
        fh=qgvo9SNoQyAldh3sRyV1cVP5Mrn8CTV9oBggLmxEgv0=;
        b=HRqrhgtMbYjZkosL6IO6pCFw/3aQ+S5wl4Jfe/L44i3i+dceDbxlU72gDvi8y8f2+3
         QaEJooRtnPr3Wq10CC3lmiADvUkEDe5nvot8OP6ucF77gCpzj9Y+BiCg/kuwizUldYi3
         HxBheO7u+VlBiUnJfjEl937d+wcmdI3TtYhtZoJK4aCagLNZOW4L2gbHWOZsj5biuVBM
         lu6sUSxQHtXiLTQHwCTDxDwlnrSfTw2aVG0QMQHs0PahmUBe34BTj73mmN5Sa/tlUnNH
         6Ye/jFyXdrAGNRWf0675BCi04bVF8w1aBsF20qHbKUIV0kqN3T66AWDp0ISgpFVJcXTf
         naeA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773577731; x=1774182531; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QeqDDzd840VOJxix9aZJyGlIkyITMsYMJnroyqzeUw8=;
        b=rFU2XQ7PZtZ6x2m7I2xwY/niGiIapg8mWdJg/qvcH3626gYaM1RWAgqhmX0GB64OoV
         Gxd2NOhdY/I3hrQt5ZUWolJzKa1cF1tG4ICFmrSgpg/fF0ruOwbsYcu8KORo6h+aGwpz
         hR+MVwifGgbfz0EqQ0Mebs8LHlv7eyBFv3nnOpg5sQ/oVmj8uGaeA8dgecGh6zBaCTJj
         mJjbrHS9eU8vfK/9Obhu4bWGQgyUaQpkoWerzdpOkpRJFtXKK4pToB9wvX83gU0QtSgQ
         UYqKmQHPB04TX3+pJDPZ4q0SVLCgLs1WM4MPwAkxdLxV1PUCqv4E02tmWazDWfWrPu8/
         1lcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773577731; x=1774182531;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=QeqDDzd840VOJxix9aZJyGlIkyITMsYMJnroyqzeUw8=;
        b=jkRJ/8fRh5sg3sTAAeApqH3EnfJTtiDzbGX+7u1cLLSwFiayTs8gWbVTJur0kj46zB
         346bHt5MOKvCayLXDZm8tFD8mCqDfC+v1D2z9tJrwuKhtdqzMS8dbmOec6HaIYvdkEDe
         C/XFJbstYPmYNUY/cLQVPTpirhIoWF+hE1SJ4cssjFCqkG8wMv31gpOVybsMcRDfhifJ
         hHkYcXtjp2vmA5Xd8oGzUVLUMmigMKluV8frClcYwDpN0ClYAZL5Ddw+Ii+FsLXaK9xT
         ZGfFfFr+j8cesnSWoTS2mT0dimP/0bT627UsQvVB4rZNzpI/XdSJ7o3bvw/vzHBwivGP
         gDVw==
X-Forwarded-Encrypted: i=1; AJvYcCVpgWAJuMkB8O988sJrbOMKgoeuzYyiN9bTFG4VqqVciRnNwWRu5xKhCK6VY2HmSzJyzIzVoxM=@lists.linux.dev
X-Gm-Message-State: AOJu0YyB43t63msXhIQickGt0LfYNCr5bB7cXUIYziz7EGrxUP1Xz8Sj
	4oUnP47goHPzNzPGndPj/dZxsMIEe30MD0AtAL6B6ec5nyjQJ/TMP707pO7budo2PiSLhf+LgPX
	5UltFkFiPsBFh7mc5hmJkZpRJpqkySW4Zp/MNq7ie
X-Gm-Gg: ATEYQzyFXf0oHJti2bS40bb0Z1CBcKZ/4ymJH1ZS5YL0EK3hpxlQ3xrkL3uKIiwDSf+
	OcbQDVZp1GNcHxKg2rRbXevOhsTogZ+eGUq5RmFzHWsLc9nhGeeJ9QlD8SoRMvT75lIxBmPnnG8
	lBx+o3RFutgROJF89swyykwWCidJ4yuWNRw8SRWanvhJUL746BsaqACoYiejhgU5ErAiMQkGzqc
	UBNssrRWQFiq673BEGkO0tNSWm8jIBpyWH8GIZ4779ZClFl0RzwXVg/WzbDbIwTgsKp4ALiEoj9
	axej+N3AG5o/zHfl3lHLsToh9DXAaz7dQoxL6Mvq793t+1TcX6MFZmGE0Jg8DtGONEHFzCCBHO/
	nJQOzSuE=
X-Received: by 2002:a05:6820:c8d:b0:677:87ab:a78a with SMTP id
 006d021491bc7-67bdaa67adamr6348935eaf.61.1773577730503; Sun, 15 Mar 2026
 05:28:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <69b387e9.050a0220.12d28.00bc.GAE@google.com>
In-Reply-To: <69b387e9.050a0220.12d28.00bc.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Sun, 15 Mar 2026 13:28:39 +0100
X-Gm-Features: AaiRm52-Xu2rKnJpbKtB1RI8w2XWKnBYmgsu4-sJKLS_LUs6Owr8fbkJdKlOW8I
Message-ID: <CANp29Y7fo11cO2e7E3-WYDPd879CG3A-rE5bpCtPDfBywzBRQg@mail.gmail.com>
Subject: Re: [moderation/CI] Re: fs: Replace user_access_{begin/end} by scoped
 user access
To: syzbot ci <syzbot+cif7704bc886472a27@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Looks legit

#syz upstream

On Fri, Mar 13, 2026 at 4:43=E2=80=AFAM syzbot ci
<syzbot+cif7704bc886472a27@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v2] fs: Replace user_access_{begin/end} by scoped user access
> https://lore.kernel.org/all/9b8b9c7f7d533c96c0c1abe5b4aecb7dc19e2abf.1773=
306879.git.chleroy@kernel.org
> * [PATCH v2] fs: Replace user_access_{begin/end} by scoped user access
>
> and found the following issue:
> kernel build error
>
> Full report is available here:
> https://ci.syzbot.org/series/a2ff6791-00cd-4a47-8c1b-9224abc65d04
>
> ***
>
> kernel build error
>
> tree:      torvalds
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torva=
lds/linux
> base:      0257f64bdac7fdca30fa3cae0df8b9ecbec7733a
> arch:      amd64
> compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~e=
xp1~20251221153213.50), Debian LLD 21.1.8
> config:    https://ci.syzbot.org/builds/ab2718fa-ea35-4282-a430-1ceab5b14=
9aa/config
>
> fs/readdir.c:530:60: error: use of undeclared label 'efault'
> fs/readdir.c:538:2: error: unknown type name 'buf'
> fs/readdir.c:538:5: error: expected identifier or '('
> fs/readdir.c:539:2: error: unknown type name 'buf'
> fs/readdir.c:539:5: error: expected identifier or '('
> fs/readdir.c:540:2: error: unknown type name 'ctx'
> fs/readdir.c:540:5: error: expected identifier or '('
> fs/readdir.c:541:2: error: expected identifier or '('
> fs/readdir.c:542:1: error: type specifier missing, defaults to 'int'; ISO=
 C99 and later do not support implicit int [-Wimplicit-int]
> fs/readdir.c:542:7: error: expected ';' after top level declarator
> fs/readdir.c:543:2: error: unknown type name 'buf'
> fs/readdir.c:543:5: error: expected identifier or '('
> fs/readdir.c:544:2: error: expected identifier or '('
> fs/readdir.c:545:1: error: extraneous closing brace ('}')
>
> ***
>
> If these findings have caused you to resend the series or submit a
> separate fix, please add the following tag to your commit message:
>   Tested-by: syzbot@syzkaller.appspotmail.com
>
> ---
> This report is generated by a bot. It may contain errors.
> syzbot ci engineers can be reached at syzkaller@googlegroups.com.
>
> The email will later be sent to:
> [brauner@kernel.org chleroy@kernel.org david.laight.linux@gmail.com jack@=
suse.cz linux-fsdevel@vger.kernel.org linux-kernel@vger.kernel.org tglx@lin=
utronix.de torvalds@linux-foundation.org viro@zeniv.linux.org.uk]
>
> If the report looks fine to you, reply with:
> #syz upstream
>
> If the report is a false positive, reply with
> #syz invalid
>
> --
> You received this message because you are subscribed to the Google Groups=
 "syzkaller-upstream-moderation" group.
> To unsubscribe from this group and stop receiving emails from it, send an=
 email to syzkaller-upstream-moderation+unsubscribe@googlegroups.com.
> To view this discussion visit https://groups.google.com/d/msgid/syzkaller=
-upstream-moderation/69b387e9.050a0220.12d28.00bc.GAE%40google.com.
