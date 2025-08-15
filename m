Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C480B1D5CEA
	for <syzbot@lists.linux.dev>; Fri, 15 Aug 2025 15:02:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755270176; cv=none; b=SPg9Zhsqmqk9+k6WCwfvBzP2G/mzqezlOBO2l6JmPX9D1z0xpV4149bMycgRJh+RejCOnuHaHw4YmnbhLbzBCC1qsMTPhbIgjqPn8KJhDm0kkFbHhDiJsb399TYURVG6wC4GTP4TiA9YAiVprWHfjiaW7YQaczPOrQYK9zEc3fw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755270176; c=relaxed/simple;
	bh=U7olVsKihR+AgI0XpUlJavEMLIGNF8JHlgT8Hu7Fm3c=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=i+2MN8A7dfXVsC75d6sYgNPl5MMntY4umSthRg2W4KPkWCt4Of0fzNxm+GLj2/bgUbfvRHkI/XWLcVCS9oXVI9u66ojU9w8KgoxNV/sx0zCQrU6vHYNZZPZGZ2CvZSfEyt9jYnsBJBOnxZhwA611IKBU5Zm4YNrFrD2HOR8TB1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-3e570014392so51238235ab.2
        for <syzbot@lists.linux.dev>; Fri, 15 Aug 2025 08:02:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755270174; x=1755874974;
        h=content-transfer-encoding:cc:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sZB2/GzOPufErV6SoBLHuCMACPccPtFEnL3ZHJ4av0o=;
        b=CwZRXE/EQ0rJ2+BGolBfHzLQV91alP1PB3OAnfewOOOIMEHi0/IPKsjdC8JXMEtOBW
         W4ByMOPSKTWRv7D0fye3V742GEJaq8q/PHIKymYqVlY0kTdXuLNB6usfDgsYXU7PPW45
         mNX3bLgMDGhurCvgyTn9h5UjolTsUQBWIZ2CM8BSTMKDSkSMB5XJxRASAq3r8TInHP9x
         iyY93AvBlVhaXqKLRNgcHmRkdjhbVUjm1UX5n7z5DGETvpv18hp2Z/O0sL0UjYonNbrH
         GkFpuLglZEvRbo8e5G3zuLE1tGxtVVZ7JPrr7881fBuf4prrwDGC8PbPt7Trg4l6nilv
         iSlQ==
X-Gm-Message-State: AOJu0YzvaEpgJ+iD/1E/FSGMBI1lmeFd7J7/mYxhbsSO9srD5j9VvVqt
	giQUm1AOsKrEt9BZaANtC9nLQcA4tbTKXt+QfemtsmE0+xWOdwO+N8YQ06hvtkOKyg7t1OYEnJI
	efD3rfVBF8tDIZaw4Z5Y+vJSRF4KROLaH0TJeAy+KSl6hW+pHO2Ae+Sx4IFQ=
X-Google-Smtp-Source: AGHT+IFm2UDVJ621TA1F24IFMi2D/OPsQ5C4tC4ShxLr17mGb1y63xc/RGSKj5iQVjCQ1Kzpk+UvBFEI3g7LRyT7HOuNxMUg+BBJ
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1d86:b0:3e5:4c7d:b799 with SMTP id
 e9e14a558f8ab-3e57e8b10f3mr43009485ab.13.1755270173855; Fri, 15 Aug 2025
 08:02:53 -0700 (PDT)
Date: Fri, 15 Aug 2025 08:02:53 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <689f4c1d.050a0220.e29e5.0018.GAE@google.com>
Subject: [moderation/CI] Re: Support "generic" CPUID timing leaf as KVM guest
 and host.
From: syzbot ci <syzbot+ci4406e0cb3d089e22@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v1] Support "generic" CPUID timing leaf as KVM guest and host.
https://lore.kernel.org/all/20250814120237.2469583-1-dwmw2@infradead.org
* [PATCH 1/3] KVM: x86: Restore caching of KVM CPUID base
* [PATCH 2/3] KVM: x86: Provide TSC frequency in "generic" timing infomatio=
n CPUID leaf
* [PATCH 3/3] x86/kvm: Obtain TSC frequency from CPUID if present

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/a9510b1a-8024-41ce-9775-675f5c165e20

***

kernel build error

tree:      torvalds
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvald=
s/linux
base:      dfc0f6373094dd88e1eaf76c44f2ff01b65db851
arch:      amd64
compiler:  Debian clang version 20.1.7 (++20250616065708+6146a88f6049-1~exp=
1~20250616065826.132), Debian LLD 20.1.7
config:    https://ci.syzbot.org/builds/590edf8b-b2a0-4cbd-a80e-35083fe0988=
e/config

arch/x86/kernel/kvm.c:899:30: error: a function declaration without a proto=
type is deprecated in all versions of C [-Werror,-Wstrict-prototypes]

***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[ajay.kaher@broadcom.com akataria@vmware.com alexey.makhalov@broadcom.com b=
p@alien8.de dave.hansen@linux.intel.com dwmw2@infradead.org graf@amazon.de =
hpa@zytor.com kvm@vger.kernel.org linux-kernel@vger.kernel.org mingo@redhat=
.com pbonzini@redhat.com seanjc@google.com tglx@linutronix.de vkuznets@redh=
at.com x86@kernel.org]

If the report looks fine to you, reply with:
#syz upstream

