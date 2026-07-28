Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com [209.85.167.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19A04346A19
	for <syzbot@lists.linux.dev>; Tue, 28 Jul 2026 18:21:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785262877; cv=none; b=p9thCUP+R3+lRBIV5tH2yjxsI5HrrAktfVC2Q1wTWNM/Cbi22MMoQ0I5beDYm1qpaq0vqmF6U5uaXlLyOZvGfO3Uhh7qqxmVa8oHaAbAVis9HZchX19iGP6lDw1HS2TcDx8vcv5ZEcNHsW+uo6pFQNgxt03II7iph+UajDhLnnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785262877; c=relaxed/simple;
	bh=+vWGEE55N1E1uTvWNk5fDMZeYF9b3MwQ/5Zj8W1mFNU=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=V/zut5nrIVB4m3XPnQYYiH0xkMC7Sfcluo9mdt/PL4S17il0+hMXKJtbRo+Rji6JkaPMy8wBCPAL0PfNb6LQ13MOQKgtcmX2bZRhOELA5v3o6K17U+ZN+Z4BCI3B7FKKYYg5A4PGVzVxKBfZWcPin8ohga3H8ZR+DhhCFy/+Y6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f198.google.com with SMTP id 5614622812f47-4a45b3f0bdfso114979b6e.1
        for <syzbot@lists.linux.dev>; Tue, 28 Jul 2026 11:21:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785262875; x=1785867675;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:date:mime-version:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=3uYReQo/mpijD01q1tNRkjYlP5++1I0PQY6Dr9W7oJw=;
        b=VTl16pzu4ZJNG0f4yVGoe6zbTZgkk+Zu02bogs+FzRv+SScaDPE5EW7Rw/WNoQkSY/
         Vc/80MLN3Xj2pISQKA18omIQm+44Ok84WIKDg75shOf8FW5EBcsJaDje6DO2dShZo6WV
         sUHOlBO5Dy9x3jPQI1uXPBVeb/vdIVloTo9aWBGyamcHuuSzi3ABR9+xN9rsrKxO/BWJ
         wUd1CB49tR84Z5TvPDTHk3xX7DrlbKYFEYjMNMp1OJ17xCAlfwjqDpsVRXbBFPKwHekg
         2sdB3/kKNtsJUUk51szPaLkciZcebue9mOp2IVGgNKqxZs6/Dk7ssxZz8xuFlQIo3uW5
         IVEA==
X-Gm-Message-State: AOJu0Ywzk8NQ+vc+ekUXVkyWHoSnGcZVpiZP2qdYBfxXWhKvz/EmdAeL
	FKJAtO6NaeuY0UkrlblZ0SsnVNmkLSHO+VI1My4I6K8IOh58n2WV952eYyqG0EJlxUpo1Dh8qUY
	woavNtJMsptTQGSEob1mUvM6OW1HpplKu+dkqTccSpb73oEQirZXotgsthXk=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:4f2c:b0:495:dfbc:c1c6 with SMTP id
 5614622812f47-4ad5bc26b95mr2155372b6e.40.1785262874856; Tue, 28 Jul 2026
 11:21:14 -0700 (PDT)
Date: Tue, 28 Jul 2026 11:21:14 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a68f31a.d9e86bb5.297b12.003a.GAE@google.com>
Subject: [moderation/CI] Re: KVM: x86/pmu: Add hardware Topdown metrics support
From: syzbot ci <syzbot+cic88c5c5505cf8153@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v7] KVM: x86/pmu: Add hardware Topdown metrics support
https://lore.kernel.org/all/20260727192131.582105-1-zide.chen@intel.com
* [PATCH v7 1/9] KVM: x86/pmu: Do not map fixed counters >=3D 3 to generic =
perf events
* [PATCH v7 2/9] KVM: x86/pmu: Support Intel fixed counter 3 on mediated vP=
MU
* [PATCH v7 3/9] KVM: x86/pmu: Rename and move vcpu_get_perf_capabilities()=
 to pmu.h
* [PATCH v7 4/9] KVM: x86/pmu: Snapshot host IA32_PERF_CAPABILITIES in kvm_=
host
* [PATCH v7 5/9] KVM: x86/pmu: Support PERF_METRICS MSR in mediated vPMU
* [PATCH v7 6/9] KVM: x86/pmu: Move RDPMC emulation into per-vendor callbac=
ks
* [PATCH v7 7/9] KVM: x86/pmu: Restrict RDPMC passthrough to known CPUs
* [PATCH v7 8/9] KVM: x86/pmu: Emulate RDPMC on performance metrics
* [PATCH v7 9/9] KVM: selftests: Add PERF_METRICS and fixed counter 3 tests

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/a13c8555-bb2f-4a56-8e6e-44118c51c80c

***

kernel build error

tree:      kvm-next
URL:       https://kernel.googlesource.com/pub/scm/virt/kvm/kvm/
base:      a204badd8432f93b7e862e7dac6db0fe3d65f370
arch:      amd64
compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp=
1~20260613092250.77), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/3201c48d-2519-42bd-9cfd-04d5c26c628=
e/config

arch/x86/kvm/pmu.c:90:16: error: use of undeclared identifier 'INTEL_PANTHE=
RLAKE_R'

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
[ak@linux.intel.com dapeng1.mi@linux.intel.com jmattson@google.com kvm@vger=
.kernel.org linux-kernel@vger.kernel.org manali.shukla@amd.com mizhang@goog=
le.com pbonzini@redhat.com sandipan.das@amd.com seanjc@google.com thomas.fa=
lcon@intel.com xudong.hao@intel.com zide.chen@intel.com]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

