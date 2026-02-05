Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com [209.85.210.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F89E33A036
	for <syzbot@lists.linux.dev>; Thu,  5 Feb 2026 06:10:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770271844; cv=none; b=HPRmlPCyUQC228BeRdrplUYXkLhPArwZUYInslI9O6j6DsRFy+QryDEe5LCnNh8FcPe4U7HiqMHiBE8eZVulz2wLkG1Q9kkIOcr3dtgLJdEtJr9juDC0Y12y63OuYccg76aCmLQmzskcZZxGOiQDj7dXETM3vpUadaHuZL12BJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770271844; c=relaxed/simple;
	bh=2ziJc7cI/uyrs7Juk6JuEis7CRg9VsH66Cj99UmTTvI=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=XJFILzZDP860kUqpNJRKH+cSu4RY4FXqQihKtt/jSuRxaa1QDgovwS9Wh3TSsK+CSsxALvBy0RnQ44ImsDNlPc2EeP6zJCh5sb2f0sa3WHeUEgvdgwViWPieWOGWivfnkhDgPOar27ma17JtygNWX4AybMliEnQqT8bTWRyulsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.210.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f70.google.com with SMTP id 46e09a7af769-7d1936b8a7cso1999713a34.3
        for <syzbot@lists.linux.dev>; Wed, 04 Feb 2026 22:10:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770271843; x=1770876643;
        h=content-transfer-encoding:cc:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OEy15XFvZI8rtJdzmih8MrgyxTy/0auvPGDXVOh8Qtg=;
        b=UucpjFi8z5WH9XB5FFOF4bCCkKxgAlQt33oO2KzcYgfLkqzfaj0mGLBSjSf2pWVW+G
         XI3dJDWZJ6McLMdCswSHVXKiO629MLGqPTjQxz5ftPlytLgfNINMGwjfV5GvznRNKbcE
         SuZC9ADbV+Ys17GFH8x+X1mnv2mmpQWDWLqPHpPNt1jRUNgF0mVetdXA5co9ujpNS/nK
         tX57XSaPbT1DAv+dpT0oowTjh4SPCHlsYq4jhFjKZBM8FHp0LeNXEy16rN6jwkx/zDj5
         EOmTEAzVjIE2IYt6gyrLmClYyZM+wihrkwwJLrXi8q1ITyWxFqJJW46/7uGXuOIZbHND
         A4Dw==
X-Gm-Message-State: AOJu0YwDnH1C36nwMRo30ZgcUh8zBcVR9vW6BlyKmDkrcQTGC/Q2M4Kf
	h9YQ3xSn7Y3dQ3xyqfT9UjnG5WdaRaPSXtS/m8xTNTur1irxizsQG+2XKTeNbXyFW+cdgha5+0s
	V503KJvfuRapWcNWDTPZZi5WFe8Nl/KnofULTLWF7iIR1F5kew2ACXDbWr3c=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:81ca:b0:663:1239:9ece with SMTP id
 006d021491bc7-66a20c6c8f6mr2549300eaf.26.1770271843052; Wed, 04 Feb 2026
 22:10:43 -0800 (PST)
Date: Wed, 04 Feb 2026 22:10:43 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69843463.050a0220.3b3015.0019.GAE@google.com>
Subject: [moderation/CI] Re: x86/fred: Fix early boot failures on SEV-ES/SNP guests
From: syzbot ci <syzbot+ci4cf204126508c574@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v1] x86/fred: Fix early boot failures on SEV-ES/SNP guests
https://lore.kernel.org/all/20260205051030.1225975-1-nikunj@amd.com
* [PATCH] x86/fred: Fix early boot failures on SEV-ES/SNP guests

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/4b020042-5efd-47f8-a065-ef24bf5af659

***

kernel build error

tree:      linux-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/next/li=
nux-next
base:      0f8a890c4524d6e4013ff225e70de2aed7e6d726
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp=
1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/af53275e-610d-499c-8272-fb848e13a00=
c/config

arch/x86/entry/entry_fred.c:213:11: error: call to undeclared function 'use=
r_exc_vmm_communication'; ISO C99 and later do not support implicit functio=
n declarations [-Wimplicit-function-declaration]
arch/x86/entry/entry_fred.c:213:4: error: void function 'fred_hwexc' should=
 not return a value [-Wreturn-mismatch]
arch/x86/entry/entry_fred.c:215:11: error: call to undeclared function 'ker=
nel_exc_vmm_communication'; ISO C99 and later do not support implicit funct=
ion declarations [-Wimplicit-function-declaration]
arch/x86/entry/entry_fred.c:215:4: error: void function 'fred_hwexc' should=
 not return a value [-Wreturn-mismatch]

***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[bp@alien8.de dave.hansen@linux.intel.com hpa@zytor.com jon.grimm@amd.com k=
vm@vger.kernel.org linux-kernel@vger.kernel.org mingo@redhat.com nikunj@amd=
.com pbonzini@redhat.com seanjc@google.com stable@vger.kernel.org tglx@kern=
el.org thomas.lendacky@amd.com x86@kernel.org xin@zytor.com]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

