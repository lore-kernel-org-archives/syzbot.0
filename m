Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com [209.85.167.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEDBD5293F9
	for <syzbot@lists.linux.dev>; Tue,  8 Sep 2026 13:38:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788874744; cv=none; b=dwLkmkJb2IezaCYgok9yz9sx3IOLeFWzLoRnTWIGanm91DBxqfTZbuicaMUivcPwMhVQHRttZt8+KuDZ2jlqRAtQoABkNYcaCKEgz+faRjGSuLZFFQW7VLdukeuRSHYDyaiz7PBulLchpIQsS94Xm4EKTQDjbXq7R7yz/cFbsUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788874744; c=relaxed/simple;
	bh=hiYUQAmBX2yLVGTRb19plEugaSw6RlRybDEzwB/EqYg=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=fJq7pgTC4yYqwo+kjv4vDL9/8sI6nNBY+dv0bsYvVtj0rfWJylqncN6SmOdEE2GcrW6sFgHnluZe4iDSBcweVbhUOPJ+xVepa/Y5kSkek2JmDjaidvMK0STawLu5RAeDJtlGQ6RCIA21bFK5Kx+kYYGzg0tn7BTK0HbfIzybWf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f198.google.com with SMTP id 5614622812f47-4b28deb7ee3so5479375b6e.0
        for <syzbot@lists.linux.dev>; Tue, 08 Sep 2026 06:38:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788874729; x=1789479529;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:date:mime-version:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=i4BJnlSnwcUFL4p2EujRGcE4vHMgKPRjrn4y2h8K2JY=;
        b=skDpDQ/FgcHgQit3pbpHWkgAg1DDjFOte8aLz+p/HrrTLA9fK3aDu5HmYWHooM/N29
         7TUUNhvck+ohwL1CgzyPaBek3octAdcKVx4fwoTb9Qk89U2V5glqvhWxDZjW7mQ5X3+G
         f0wUcfd8FQhIaj18+DihbjiXqHDHQJZP7UU+/sk8ZxA+PywsK1VKaf/EtRE8JUbRZONE
         HkNonFV1Q6DxDrKNGSSlJov/ClCgf4t6jmH6RkzjNnN2ngb5s8sDgTV5KP4s8jlN+lzy
         JxLd1In5sGWJYrqvIDVgbM1CRipiyyEbrdHUxSLB4h+bdsuVcuUKHuUktmpmeCTkFY2/
         PCVw==
X-Gm-Message-State: AFuF++n0C1MAuD/vCRYrsiF7GjICtLDXyjiP9nHcMhe5G1iCn8W5Yllr
	hHqAndUQFVwqrgnXRr2xBYBTJdn9+gfVZicdOUvzPnRN/b3ND+URoWeiWrDzyYQN2+tpaZkvd9n
	kwG05+DBwmIZ4NjW9bldwPvQPeM4awWLto4xdmXefqRVh10JBOS0G+F5FP6Y=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:250d:b0:4b1:bc4f:57cf with SMTP id
 5614622812f47-4b96153a535mr16270702b6e.12.1788874729408; Tue, 08 Sep 2026
 06:38:49 -0700 (PDT)
Date: Tue, 08 Sep 2026 06:38:49 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6aa00fe9.f81106d8.285f0a.0002.GAE@google.com>
Subject: [moderation/CI] Re: KVM: SVM: Support direct setting of VMSA for
 SEV-SNP guests
From: syzbot ci <syzbot+ci6eb4396eec0fdf67@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v2] KVM: SVM: Support direct setting of VMSA for SEV-SNP guests
https://lore.kernel.org/all/20260908103338.427254-1-joro@8bytes.org
* [PATCH v2 1/8] KVM: SEV: Document SNP direct VMSA userspace ABI
* [PATCH v2 2/8] KVM: SVM: Implement GET_AP_APIC_IDS NAE event
* [PATCH v2 3/8] KVM: SVM: Hold SRCU while reloading guest-owned VMSAs
* [PATCH v2 4/8] KVM: SEV: Add direct VMSA capability
* [PATCH v2 5/8] KVM: SEV: Allow VMSA pages in SNP launch updates
* [PATCH v2 6/8] KVM: SEV: Add SNP vCPU state get and set commands
* [PATCH v2 7/8] KVM: selftests: Test the SNP APIC-ID-list GHCB request
* [PATCH v2 8/8] KVM: selftests: Test SNP vCPU state and direct VMSA launch

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/cec648dd-2a50-4821-b110-268d2ecf091f

***

kernel build error

tree:      axboe
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/axboe/l=
inux.git
base:      df2908090cda368b01ff43709f51890076c56157
arch:      amd64
compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp=
1~20260613092250.77), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/0356e5b2-bf16-445c-a2bf-b8eec005744=
f/config

arch/x86/kvm/svm/svm.c:5344:2: error: cannot jump from switch statement to =
this case label

***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

To test a fix for this bug, please reply with `#syz test`
(on a separate line) and attach the patch to the email.

Notes:
- The patch will be applied on top of the tested series (as an
  incremental fix).
- To test a new version of the whole series, please send it directly
  to syzbot@lists.linux.dev.
- Arguments like custom git repos and branches are not supported.

The email will later be sent to:
[coconut-svsm@lists.linux.dev james.bottomley@hansenpartnership.com joerg.r=
oedel@amd.com joro@8bytes.org kvm@vger.kernel.org liam.merwick@oracle.com l=
inux-doc@vger.kernel.org linux-kernel@vger.kernel.org linux-kselftest@vger.=
kernel.org michael.roth@amd.com ninadnaik07@gmail.com pbonzini@redhat.com s=
eanjc@google.com thomas.lendacky@amd.com vannapurve@google.com]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

