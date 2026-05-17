Received: from mail-oo1-f72.google.com (mail-oo1-f72.google.com [209.85.161.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C24F4502F
	for <syzbot@lists.linux.dev>; Sun, 17 May 2026 19:49:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779047351; cv=none; b=NHyW2NTPrSSwUExOLKDMuPR0k38AhnGpCLV/fqk6ajbOr6GgtsUcxbXMmwM992pXO8R7OOikZDpvD18MBqLC+cdDu3HzRKCJDisJOB3P6Cfu4sTg0QuApikG12hak4rF3bH4cTpRnvMegRayxrz2rVddMEiK9QTFtrXX9Ex/Nz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779047351; c=relaxed/simple;
	bh=4m/3GRoml7BrxVTtZ0NW3oaO0GITfFCggpRW55Pabwk=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=UGzKQPdkx56LgdgqwezxYQ/xrX8Cr4DjDdcgHy3LomOLWrfQozPLcMD+Zf/ilRbps69tK5i1W4J8nF4fSK3wwlT7m7LgITHahH19OyZZBQIARjgv+wtl+51ZE9HC59WQ1Rdruumm96CTsgYpmdvDwLxMv7eKEDTxbqn43LUhdoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f72.google.com with SMTP id 006d021491bc7-69b3a3c798dso1013932eaf.1
        for <syzbot@lists.linux.dev>; Sun, 17 May 2026 12:49:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779047348; x=1779652148;
        h=content-transfer-encoding:cc:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SYiRxJDf62D2zexmentp9sueybrLT8jNeROSZwLbPuw=;
        b=bOqBWr2Uau0isc/M9L9DFCRSMTNIPj3JCsQSl8tzBIPtH7PNf3nuPbeWyOo2ldhvk7
         gOZR3Fo8JB+qOHGaRBCWUwfir7VfKbJpldDyQJDgFBCzV1I4RdrSriI/IZLzldu53Nqt
         DxBr81GqB324o0fOFS2tqtIyoz/pytJX9cTEUJ7hKaz40v49ZGNYkuCcgRGDMarb+J4M
         sjfbPCrJ0p+qM9Xx/S+Y9pOQgyj9uVSimUxhMV/4DolSUScqg5y2Mpz+nZ5VDT8lIrwV
         YpAsoRUa4zQIDJ/EegqSEhct3OpssQAd3K0nYC28kubv2qNSxyHKw/AyQRnQRMpebjJY
         4N1Q==
X-Gm-Message-State: AOJu0YyoIZWTjkqKinwU/LEH5WVI+QuSD9rXVvAvnHiLq7AZIMuOwBJ4
	tEotRiNSK0F4zxaxOGZTxw4uAMw32gutbuQ6z2IE7a2oKswn/rWSH3uehRh05YhBl0XzXxMqlnT
	KSeINYSWB/I0+yZjmLwH+HWFCEEhdvaAV0+h5OObw3t4NKYNH7V8SI+VWrlY=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:4b8f:b0:696:97e3:1195 with SMTP id
 006d021491bc7-69c9bfb094cmr7455554eaf.49.1779047348593; Sun, 17 May 2026
 12:49:08 -0700 (PDT)
Date: Sun, 17 May 2026 12:49:08 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a0a1bb4.a00a0220.300e5b.000b.GAE@google.com>
Subject: [moderation/CI] Re: sched: Add support for long task name
From: syzbot ci <syzbot+ci976947bc4b8c0f5f@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v1] sched: Add support for long task name
https://lore.kernel.org/all/20260517-tonyk-long_name-v1-0-3c282eaa91e2@igal=
ia.com
* [PATCH 1/6] sched: Update get_task_comm() comment
* [PATCH 2/6] treewide: Get rid of get_task_comm()
* [PATCH 3/6] string: Introduce strtostr() for safe and performance string =
copies
* [PATCH 4/6] sched: Extend task command name to 64 bytes
* [PATCH 5/6] prctl: Add support for long user thread names
* [PATCH 6/6] selftests: prctl: Add test for long thread names

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/ebe3a5a0-c138-4f99-ad22-8a880dc176ca

***

kernel build error

tree:      bpf
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/bpf/bpf=
.git
base:      5d6919055dec134de3c40167a490f33c74c12581
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp=
1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/108b7ff7-5ce1-4980-a6f7-e69a669ec7e=
6/config

net/netfilter/nf_tables_api.c:9714:46: error: incompatible integer to point=
er conversion passing 'ssize_t' (aka 'long') to parameter of type 'const ch=
ar *' [-Wint-conversion]

***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

To test a patch for this bug, please reply with `#syz test`
(should be on a separate line).

The patch should be attached to the email.
Note: arguments like custom git repos and branches are not supported.

The email will later be sent to:
[akpm@linux-foundation.org andrealmeid@igalia.com andrii.nakryiko@gmail.com=
 arnaldo.melo@gmail.com bhupesh@igalia.com brauner@kernel.org david.laight.=
linux@gmail.com juri.lelli@redhat.com kees@kernel.org kernel-dev@igalia.com=
 laoar.shao@gmail.com linux-api@vger.kernel.org linux-kernel@vger.kernel.or=
g linux-mm@kvack.org mathieu.desnoyers@efficios.com peterz@infradead.org pm=
ladek@suse.com rostedt@goodmis.org shuah@kernel.org torvalds@linux-foundati=
on.org vincent.guittot@linaro.org willy@infradead.org]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

