Received: from mail-io1-f71.google.com (mail-io1-f71.google.com [209.85.166.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52D6C22CBD3
	for <syzbot@lists.linux.dev>; Tue,  5 Aug 2025 19:56:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754423779; cv=none; b=D9OByqvk1yyY+UHzG68V6wpiFfRhG6TD/QFmf1rxAxPki1bCLBrrvformdzXyl2OKDJ+8w1OolFzhUADMEEGLIg2LQQhAIYLJX9q/KUPgCVGC0ZifMVfDtXZcq523fcX3ZqoIwWEKRSxwCJP4CxCRLgBkApGKGndb42nkhwYz/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754423779; c=relaxed/simple;
	bh=9Yz7H4YEmOigrMhWN7z1ddPO7FE8em/A7pOtP2ySLD4=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=nBNmbzBjKePVdByivKfEa/hM3H7IQiWOknLNzq/4T3O2j9GSJfLUhNduwEKQUaQL1X2UFrgdZTmEtFfOSuMxdRhZOOEjzi71qkEzeQ/V6PVTyuabJ5Zn1vkktFwov1LxNZq84/4CeDXPZWdgG1eJ0eJHihou8AvnysQVw2D9btk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-8817d15cad2so240040139f.3
        for <syzbot@lists.linux.dev>; Tue, 05 Aug 2025 12:56:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754423777; x=1755028577;
        h=cc:to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3yQoPUAH6VGsG3Qpg7Gnmxq3HONoTIk6S+rie+F7yWw=;
        b=OCRG/f5GPC0Zj1wlKYu+TbKkqhaKVBglil5pPZM/dQ09n5IS+AdoOTKibkB/nETQjb
         fs2DwUxYRr3mV1Q9HTMEVpLMxX7DqRMr15NZZPEDndEAwWBDxKxJaI5EKHZSiVdY5jZb
         UbdH7QN7Sr1l9V0MY/8J17tGfpJPhgNzv6bUMv0q3gEu91z1dWRMmKG+4IBVZbXWzhdF
         4F51K18JwC05dSvtJ6AzrRsaK7oq47LwDXIoz6AwymkVIj0N5z8VlcCVeRlF4bkznknw
         2g2e7TwmXkQzmrRDB/F0Fwdju3tXFDaXzX6O9DTj8hlmFhPUka+9S0qxm21TXyAFgYZy
         eEwg==
X-Gm-Message-State: AOJu0YzCTXFok6fdcVA9SPyAmhr/8TmMN72mWFuPKYT+UW4aMe1Q3JR1
	8LeHxm30jiMF2psbFD8TjqvzoddgrbV4jcA0eYZSO5KEO0fHNWE52HDpi8P/2uRFC+DcDUqUCh5
	FiQmShQuP0kd5Q+KlioRmpxUIDrNTKErwcBppjcbblrIEOJYpabL9oOnAN64=
X-Google-Smtp-Source: AGHT+IGQkZCzYHHup70+t/Hh/aYpyET0XraOJo6SgIoowChvSzmJfUe2K9K/LE0JRXKUz4btcvih+79czzqVPSy2W6ld4Igg9ua4
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a5e:c24d:0:b0:881:739b:e575 with SMTP id
 ca18e2360f4ac-8819f14b410mr16697139f.14.1754423777471; Tue, 05 Aug 2025
 12:56:17 -0700 (PDT)
Date: Tue, 05 Aug 2025 12:56:17 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <689261e1.050a0220.7f033.0030.GAE@google.com>
Subject: [moderation/CI] Re: KVM: x86: Fastpath cleanups and PMU prep work
From: syzbot ci <syzbot+ci784267f4474d940e@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v1] KVM: x86: Fastpath cleanups and PMU prep work
https://lore.kernel.org/all/20250805190526.1453366-1-seanjc@google.com
* [PATCH 01/18] KVM: SVM: Skip fastpath emulation on VM-Exit if next RIP isn't valid
* [PATCH 02/18] KVM: x86: Add kvm_icr_to_lapic_irq() helper to allow for fastpath IPIs
* [PATCH 03/18] KVM: x86: Only allow "fast" IPIs in fastpath WRMSR(X2APIC_ICR) handler
* [PATCH 04/18] KVM: x86: Drop semi-arbitrary restrictions on IPI type in fastpath
* [PATCH 05/18] KVM: x86: Unconditionally handle MSR_IA32_TSC_DEADLINE in fastpath exits
* [PATCH 06/18] KVM: x86: Acquire SRCU in WRMSR fastpath iff instruction needs to be skipped
* [PATCH 07/18] KVM: x86: Unconditionally grab data from EDX:EAX in WRMSR fastpath
* [PATCH 08/18] KVM: x86: Fold WRMSR fastpath helpers into the main handler
* [PATCH 09/18] KVM: x86/pmu: Move kvm_init_pmu_capability() to pmu.c
* [PATCH 10/18] KVM: x86/pmu: Add wrappers for counting emulated instructions/branches
* [PATCH 11/18] KVM: x86/pmu: Calculate set of to-be-emulated PMCs at time of WRMSRs
* [PATCH 12/18] KVM: x86/pmu: Rename pmc_speculative_in_use() to pmc_is_locally_enabled()
* [PATCH 13/18] KVM: x86/pmu: Open code pmc_event_is_allowed() in its callers
* [PATCH 14/18] KVM: x86/pmu: Drop redundant check on PMC being globally enabled for emulation
* [PATCH 15/18] KVM: x86/pmu: Drop redundant check on PMC being locally enabled for emulation
* [PATCH 16/18] KVM: x86/pmu: Rename check_pmu_event_filter() to pmc_is_event_allowed()
* [PATCH 17/18] KVM: x86: Push acquisition of SRCU in fastpath into kvm_pmu_trigger_event()
* [PATCH 18/18] KVM: x86: Add a fastpath handler for INVD

and found the following issue:
SYZFATAL: image testing failed w/o kernel bug

Full report is available here:
https://ci.syzbot.org/series/dcb800fc-bfef-4784-bed8-2bc7e47a8ca0

***

SYZFATAL: image testing failed w/o kernel bug

tree:      torvalds
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvalds/linux
base:      260f6f4fda93c8485c8037865c941b42b9cba5d2
arch:      amd64
compiler:  Debian clang version 20.1.7 (++20250616065708+6146a88f6049-1~exp1~20250616065826.132), Debian LLD 20.1.7
config:    https://ci.syzbot.org/builds/219bab5b-2202-4205-b5a6-de3ed39ac197/config



***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[dapeng1.mi@linux.intel.com kvm@vger.kernel.org linux-kernel@vger.kernel.org pbonzini@redhat.com sandipan.das@amd.com seanjc@google.com xin@zytor.com]

If the report looks fine to you, reply with:
#syz upstream

