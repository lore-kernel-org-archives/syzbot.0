Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com [209.85.167.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D489442900C
	for <syzbot@lists.linux.dev>; Wed, 29 Jul 2026 21:27:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785360433; cv=none; b=UYQBCwYLE+TkWOhq66D7xGag8L1oX9Jj7ifJzsQh93XaV1tltOt8P9+MDWTx+yMzhSAllnXEEihC9bRJWCIFhWteqY7m55IYHKeksugrgpb9o2+BqELrRuVEar/bVySnZi3efhTiE9obuWT3dGrpoVavttHR605asUDylEWAGbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785360433; c=relaxed/simple;
	bh=5Qe0IKPnEuPLGIW2ZWoNJaEG7aBVEHHb4zMuI/w3dL8=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=RLETwk5+LKV9VaO/Mavqb7TMHt2Ep5zl323Nk4pRLvtiDqPNomF0pSLQhajtPao0eNIbcQAnCwZz8spOoMyhqUCTiMtRYEydHP0LwL/4ba3ZYpDEffMFCURAm7HSKdOcVUNkZnNXhRGx+bs21vdKvgCYWggPAh0gJvHHNA8snXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f199.google.com with SMTP id 5614622812f47-4a4a7d0362eso1467182b6e.0
        for <syzbot@lists.linux.dev>; Wed, 29 Jul 2026 14:27:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785360428; x=1785965228;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:date:mime-version:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=zlgtTQGlHElflLR0cumuyMIcUboBIrkYXpeuHJ1Y/VM=;
        b=WV+Rq+ZWJWUQRgBpS1gMOlQZNMainuOqyTiwqqkPk682uupi96z00mIgn9TfYwkaba
         3Phr4L/tmeJuLjLAadx5UQD5e331b01XmVNXan2Xso/4MJ7f3NnfStF8Nnlj9zbWuLRk
         WMuCuzOdWhG8i6/EmDp6ltZ1QZ10KnYtrGNvZwEmV6y8nqUK8pV4LKEmo6Ywi8VPFjpy
         AyEZjJXUXJCerH6ubz41bHZ8mhAUV+wKt8fjNHrooB0YqW0wBaids8u03j0/6rISdwKd
         PXXIIIBcDiHA8f9V3/X9g1RHPWHYii5KrO+6/m4n5AcNNrMsREzZXlfje2wBxYi3LLOL
         uTXw==
X-Gm-Message-State: AOJu0YxMZa7tCucRWvgFkXEvtsuCYNUV3tgd/mWSUGHfwHenh8Nk3Km7
	TILmseuqRQPYv7tF+2QikrH8a+aRb5ku7u/n3CRjv6Hx2NLqCIX+vs6f7NMDP/XYq52iJ44tfcD
	nwZSt9f/GO8+Nev8GZgIXcokquZwabVv22a7tMXof0fjrgV21pfJvVr94sQg=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:13c7:b0:4a4:adaf:5576 with SMTP id
 5614622812f47-4ad8780be9emr109560b6e.4.1785360428590; Wed, 29 Jul 2026
 14:27:08 -0700 (PDT)
Date: Wed, 29 Jul 2026 14:27:08 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a6a702c.57649fcc.360844.0005.GAE@google.com>
Subject: [moderation/CI] Re: Cleaning up the KVM clock mess
From: syzbot ci <syzbot+ci6e398c6b63e189f8@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v7] Cleaning up the KVM clock mess
https://lore.kernel.org/all/20260728144954.355376-1-dwmw2@infradead.org
* [PATCH v7 01/36] KVM: x86: Improve accuracy of KVM clock when TSC scaling=
 is in force
* [PATCH v7 02/36] KVM: x86: Explicitly disable TSC scaling without CONSTAN=
T_TSC
* [PATCH v7 03/36] KVM: x86: Activate master clock immediately on vCPU crea=
tion
* [PATCH v7 04/36] KVM: x86: Avoid NTP frequency skew for KVM clock on 32-b=
it host
* [PATCH v7 05/36] KVM: x86: Fold __get_kvmclock() into get_kvmclock()
* [PATCH v7 06/36] KVM: x86: Drop CPU pinning in get_kvmclock()
* [PATCH v7 07/36] KVM: x86: Restructure get_kvmclock()
* [PATCH v7 08/36] KVM: x86: Fix KVM clock precision in get_kvmclock() with=
 TSC scaling
* [PATCH v7 09/36] KVM: x86: Use get_kvmclock() in kvm_get_wall_clock_epoch=
()
* [PATCH v7 10/36] KVM: x86: Fix compute_guest_tsc() to handle negative tim=
e deltas
* [PATCH v7 11/36] KVM: x86: Restructure kvm_guest_time_update() for TSC up=
scaling
* [PATCH v7 12/36] KVM: x86: Simplify and comment kvm_get_time_scale()
* [PATCH v7 13/36] KVM: x86: Remove implicit rdtsc() from kvm_compute_l1_ts=
c_offset()
* [PATCH v7 14/36] KVM: x86: Improve synchronization in kvm_synchronize_tsc=
()
* [PATCH v7 15/36] KVM: x86: Kill last_tsc_{nsec,write,offset} fields
* [PATCH v7 16/36] KVM: x86: Replace nr_vcpus_matched_tsc count with all_vc=
pus_matched_tsc bool
* [PATCH v7 17/36] KVM: x86: Allow KVM master clock mode when TSCs are offs=
et from each other
* [PATCH v7 18/36] KVM: x86: Factor out kvm_use_master_clock()
* [PATCH v7 19/36] KVM: x86: Avoid gratuitous global clock updates
* [PATCH v7 20/36] KVM: x86/xen: Prevent runstate times from becoming negat=
ive
* [PATCH v7 21/36] KVM: x86: Avoid redundant masterclock updates from multi=
ple vCPUs
* [PATCH v7 22/36] KVM: x86: Remove runtime Xen TSC frequency CPUID update
* [PATCH v7 23/36] KVM: x86: Re-synchronize TSC after KVM_SET_TSC_KHZ
* [PATCH v7 24/36] KVM: x86: Use ktime_get_snapshot_id() for master clock
* [PATCH v7 25/36] KVM: x86: Compute kvmclock base without pvclock_gtod_dat=
a
* [PATCH v7 26/36] KVM: x86: Cache host vclock_mode for masterclock eligibi=
lity checks
* [PATCH v7 27/36] KVM: x86: Remove pvclock_gtod_data and private timekeepi=
ng code
* [PATCH v7 28/36] KVM: x86: Activate master clock from kvm_arch_init_vm()
* [PATCH v7 29/36] UAPI: x86: Move pvclock-abi to UAPI for x86 platforms
* [PATCH v7 30/36] KVM: selftests: Use UAPI pvclock-abi.h in xen_shinfo_tes=
t
* [PATCH v7 31/36] KVM: x86: Add KVM_[GS]ET_CLOCK_GUEST for accurate KVM cl=
ock migration
* [PATCH v7 32/36] KVM: x86: Add KVM_VCPU_TSC_SCALE and fix the documentati=
on on TSC migration
* [PATCH v7 33/36] KVM: selftests: Add KVM/PV clock selftest to prove timer=
 correction
* [PATCH v7 34/36] KVM: selftests: Add master clock offset test
* [PATCH v7 35/36] KVM: selftests: Add Xen/generic CPUID timing leaf test
* [PATCH v7 36/36] KVM: selftests: Add Xen runstate migration test

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/d9831298-9bd0-48af-8723-35fb5dfd0d61

***

kernel build error

tree:      kvm-next
URL:       https://kernel.googlesource.com/pub/scm/virt/kvm/kvm/
base:      a204badd8432f93b7e862e7dac6db0fe3d65f370
arch:      amd64
compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp=
1~20260613092250.77), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/f94277a2-d36b-4aee-8a28-5c6042355c1=
8/config

arch/x86/kvm/x86.c:1418:13: error: no member named 'valid' in 'struct syste=
m_time_snapshot'
arch/x86/kvm/x86.c:1426:12: error: no member named 'hw_csid' in 'struct sys=
tem_time_snapshot'
arch/x86/kvm/x86.c:1426:45: error: no member named 'hw_cycles' in 'struct s=
ystem_time_snapshot'
arch/x86/kvm/x86.c:1427:26: error: no member named 'hw_cycles' in 'struct s=
ystem_time_snapshot'
arch/x86/kvm/x86.c:1438:2: error: call to undeclared function 'ktime_get_sn=
apshot_id'; ISO C99 and later do not support implicit function declarations=
 [-Wimplicit-function-declaration]
arch/x86/kvm/x86.c:1442:50: error: no member named 'systime' in 'struct sys=
tem_time_snapshot'
arch/x86/kvm/x86.c:1454:2: error: call to undeclared function 'ktime_get_sn=
apshot_id'; ISO C99 and later do not support implicit function declarations=
 [-Wimplicit-function-declaration]
arch/x86/kvm/x86.c:1458:32: error: no member named 'systime' in 'struct sys=
tem_time_snapshot'
arch/x86/kvm/x86.c:1474:2: error: call to undeclared function 'ktime_get_sn=
apshot_id'; ISO C99 and later do not support implicit function declarations=
 [-Wimplicit-function-declaration]
arch/x86/kvm/x86.c:1478:33: error: no member named 'systime' in 'struct sys=
tem_time_snapshot'

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
[boris.ostrovsky@oracle.com bp@alien8.de corbet@lwn.net dave.hansen@linux.i=
ntel.com dongli.zhang@oracle.com dwmw2@infradead.org hpa@zytor.com jalliste=
@amazon.com jgross@suse.com jic23@kernel.org joe.jin@oracle.com joey.gouly@=
arm.com kvm@vger.kernel.org linux-doc@vger.kernel.org linux-kernel@vger.ker=
nel.org linux-kselftest@vger.kernel.org maz@kernel.org mingo@redhat.com pau=
l@xen.org pbonzini@redhat.com sascha.bischoff@arm.com seanjc@google.com skh=
an@linuxfoundation.org tglx@kernel.org vkuznets@redhat.com x86@kernel.org x=
en-devel@lists.xenproject.org]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

