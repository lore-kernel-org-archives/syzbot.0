Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com [209.85.167.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFB5D225775
	for <syzbot@lists.linux.dev>; Fri, 10 Jul 2026 20:03:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783713814; cv=none; b=KNColOLBWbpwQuS+Nr23Z1dQ6EmGJFez53zCFpjSUKsjufP+C/N67K6rDmRtdy9eQektMTHZfOu6DlczlitKE2myyJdS7IZqGR68pg7vyoEmy7RTNKyF4B6OMSPlb4HdxymO4YGvn80Y5vP/KkINYnfR3kQ8R5AMcTDnrYkP8Uk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783713814; c=relaxed/simple;
	bh=HpQyhdseRO5XlmqVddsA0KDZlbRXq7wZ4rBtaMG5664=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=i8btSq6XAbHI+vPndbWpqAQVGcyYp51UE3niuZMUR/l/hzlNF/E569DN6504tWpHikXAW/qPrQ+xYPKgDz4FPoJYobJVOCRBEbrxVOoN+HzqwkPMn2kAp2EfIQsMSD6LQa3GAgRTn08MKBJ/T8eTgqu9qSR+cUouTPZAQSZmhDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f198.google.com with SMTP id 5614622812f47-48f0e5e664aso1043697b6e.1
        for <syzbot@lists.linux.dev>; Fri, 10 Jul 2026 13:03:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783713811; x=1784318611;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:date:mime-version:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=trY+Ael0cHzZ8pMTXPq+b0p574hm1KZNVvhpjxpyHAE=;
        b=g6/u4/VMMMfXA3MTKFqscajtB+VPF6ZWTIi+lRdg+rueA9BQnV1E7KTMbchI6WCZ28
         n+pWn3VCEzJeaxOW1hYb39tsJ7nkHR6AUNxKjT1B6d9q5fdBBAjQtmAaWHDlv42pDtAs
         gnJXZ72B/W2Ar3nP64ch4AJLwxNwC1HqQZHetu3C/0uAOF8Qpgz+pSD6k7+HTWWTknOV
         PovAk+BHQt7bXFsfEHyYKcSOUMsDF0xUOwgMd+7FDPYIrp422Xf9acLMAqMxUuoy2mPa
         p8EqJaLqXqX/32e8Vb2KjLxgLE0Ut7VatMDhxdnCkuFlPTyEWkiY2zeb7OORWPa3iZdk
         7w+w==
X-Gm-Message-State: AOJu0YyLEGQpPivYhp9F/seiaoI7OItOo5F5c0uH15pkNf9wCaFl6nai
	GOSRgkUbBMlZpQ2mhj2sbz3TPcQCwkR+Qt7k0aHXgiSg1efaacnSjcy3TLUOOkSvvNK8lBWAmuI
	NYkwZs/dOEQpqNFdAbu1oyEHy/2jzQiCW4dXjabRzS9Jp4SkOZp4brNiWEJ0=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:5283:b0:490:a8da:71aa with SMTP id
 5614622812f47-4a42aca24abmr415581b6e.19.1783713811681; Fri, 10 Jul 2026
 13:03:31 -0700 (PDT)
Date: Fri, 10 Jul 2026 13:03:31 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a515013.63a5fcd8.28bd53.0004.GAE@google.com>
Subject: [moderation/CI] Re: ACPI: Add support for ACPI RAS2 feature table
From: syzbot ci <syzbot+cie9054e6d791e80a4@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v22] ACPI: Add support for ACPI RAS2 feature table
https://lore.kernel.org/all/20260709210750.424659-1-shijujose2008@gmail.com
* [PATCH v22 1/2] ACPI:RAS2: Add driver for the ACPI RAS2 feature table
* [PATCH v22 2/2] ras: mem: Add ACPI RAS2 memory driver

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/5040b478-7bdb-4326-a6b4-5685754ec2d4

***

kernel build error

tree:      mm-new
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/mm=
.git
base:      1e692e85500fd3a971da0241f044f4572b2be8b6
arch:      amd64
compiler:  Debian clang version 22.1.6 (++20260514074242+fc4aad7b5db3-1~exp=
1~20260514074407.73), Debian LLD 22.1.6
config:    https://ci.syzbot.org/builds/4aba36a3-6777-42f1-bcad-f10d6ceb7cd=
f/config

drivers/ras/acpi_ras2.c:68:2: error: call to undeclared function 'iowrite64=
'; ISO C99 and later do not support implicit function declarations [-Wimpli=
cit-function-declaration]
drivers/ras/acpi_ras2.c:92:20: error: call to undeclared function 'ioread64=
'; ISO C99 and later do not support implicit function declarations [-Wimpli=
cit-function-declaration]
drivers/ras/acpi_ras2.c:115:2: error: call to undeclared function 'iowrite6=
4'; ISO C99 and later do not support implicit function declarations [-Wimpl=
icit-function-declaration]
drivers/ras/acpi_ras2.c:339:3: error: call to undeclared function 'iowrite6=
4'; ISO C99 and later do not support implicit function declarations [-Wimpl=
icit-function-declaration]
drivers/ras/acpi_ras2.c:447:2: error: call to undeclared function 'iowrite6=
4'; ISO C99 and later do not support implicit function declarations [-Wimpl=
icit-function-declaration]

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
[akpm@linux-foundation.org ashok.raj@oss.qualcomm.com bp@alien8.de dave.han=
sen@linux.intel.com dferguson@amperecomputing.com duenwen@google.com erdema=
ktas@google.com gthelen@google.com james.morse@arm.com jiaqiyan@google.com =
jic23@kernel.org jon.grimm@amd.com jthoughton@google.com kangkang.shen@futu=
rewei.com lenb@kernel.org linux-acpi@vger.kernel.org linux-doc@vger.kernel.=
org linux-edac@vger.kernel.org linux-mm@kvack.org linuxarm@huawei.com mcheh=
ab@kernel.org naoya.horiguchi@nec.com nifan.cxl@gmail.com pgonda@google.com=
 prime.zeng@hisilicon.com rafael@kernel.org rientjes@google.com roberto.sas=
su@huawei.com rppt@kernel.org shijujose2008@gmail.com somasundaram.a@hpe.co=
m tanxiaofei@huawei.com tony.luck@intel.com wanghuiqiang@huawei.com wbs@os.=
amperecomputing.com wschwartz@amperecomputing.com yazen.ghannam@amd.com]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

