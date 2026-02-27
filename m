Received: from mail-oo1-f71.google.com (mail-oo1-f71.google.com [209.85.161.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F1F7314A67
	for <syzbot@lists.linux.dev>; Fri, 27 Feb 2026 06:28:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772173697; cv=none; b=tx9rR2Nh6dhx2SiNy8eTosJ4uyHR7S/3nIZWBZqTyD5gG1/dJ8bkX+A0U6htYX1cT3N1vHm3MO9zs0b7Cun1UCeXl1co82LDmi53rfHVqs55QWnnE/++F40kF7zyDRLh+Tz8JWlBvy2pmj27Ifx1n7l0NWyqzw+WRJAZ9WwDASA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772173697; c=relaxed/simple;
	bh=nDZbJjn37ZU0QxErwl2GjMZ2Nd91n/GbvLQPfqQp1ls=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=cPSqPSX4V5FZogxGMOvRvGTCIz/Q0EkUSfQdRR71YwgjfQCyDivgYPHg3ewVeTSvebLuqiyzrAa3um/6oCv3C9RyrVNFZyn1/PrKtsxQXYhjCJ9ByqPOGbFWNXywTcyMcbX8Y7H3bkyP3CKuzS08FcB1BDWdYZRHJKfN3d4b59Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f71.google.com with SMTP id 006d021491bc7-679deba5e9fso19508814eaf.0
        for <syzbot@lists.linux.dev>; Thu, 26 Feb 2026 22:28:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772173694; x=1772778494;
        h=cc:to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=HRTVfDeIVVWOo6rTncvpshM9TyHdDmTFTx/IG6V9ycw=;
        b=VmL+CW4hjRa5BU3kSBbFKP1C/nCJMwtJeaIhR8f94m8fw2JGrlpKv8wBxZDm8cUYLY
         L+YZfD1q9bxLGa3sqHk2eWp3aJeqWC8ARkMI2T0uWSXGswKqs+Pm9jkzTG5GAZqDOzXn
         iJHL1jugcWzjQHjMNiptTupZFbgdtoZd30yh+Dvt7oc3cRxY5fTtUdalo+P91Wm9uO9n
         vuBwuE0I8gcNhKYwFiGrPga5LlNIlUXP+nTgbq7fkgj/6mJeWZyH5i57TOc4Unc4o9Ve
         OcNmpXwMNDpN0zWnlL5RTqCwNagPFYrkwoT8jUfoJFjLEcmunNuwoOlYlm4AuF+xGU9w
         0ogw==
X-Gm-Message-State: AOJu0YzT1AoJEbfTDGHebdlhs7EXg/j19NYLBzexsTpAkjyRDBr5za7d
	mkBDiM2Y2JCgNuGpgFNqCmOO+BIAD19TRAj2ExfOB3XHDDT4dPcVFJlAHf+duvwWzZUa/Vs3EG5
	I7tXj+fHzGQ+/sGVJs8awBsjvCQ7ESe5+ft18m2bElTP56q7tKBT41axUKpE=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:2913:b0:679:e7b2:9fb8 with SMTP id
 006d021491bc7-679fadb8af6mr1338283eaf.14.1772173694146; Thu, 26 Feb 2026
 22:28:14 -0800 (PST)
Date: Thu, 26 Feb 2026 22:28:14 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69a1397e.050a0220.305b49.009b.GAE@google.com>
Subject: [moderation/CI] Re: KVM: pfncache: Add guest_memfd support to pfncache
From: syzbot ci <syzbot+ci3927569010008011@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v2] KVM: pfncache: Add guest_memfd support to pfncache
https://lore.kernel.org/all/20260226135309.29493-1-itazur@amazon.com
* [RFC PATCH v2 1/7] KVM: x86: Avoid silent kvm-clock activation failures
* [RFC PATCH v2 2/7] KVM: pfncache: Resolve PFNs via kvm_gmem_get_pfn() for gmem-backed GPAs
* [RFC PATCH v2 3/7] KVM: pfncache: Obtain KHVA via vmap() for gmem with NO_DIRECT_MAP
* [RFC PATCH v2 4/7] KVM: Rename invalidate_begin to invalidate_start for consistency
* [RFC PATCH v2 5/7] KVM: pfncache: Rename invalidate_start() helper
* [RFC PATCH v2 6/7] KVM: Rename mn_* invalidate-related fields to generic ones
* [RFC PATCH v2 7/7] KVM: pfncache: Invalidate on gmem invalidation and memattr updates

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/56b5d8d0-838b-4843-928c-57e1b9b92df5

***

kernel build error

tree:      kvm-next
URL:       https://kernel.googlesource.com/pub/scm/virt/kvm/kvm/
base:      e89f0e9a0a007e8c3afb8ecd739c0b3255422b00
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/d1858f86-fac5-4d85-97c0-6aea927508ab/config

arch/x86/kvm/../../../virt/kvm/kvm_main.c:2624:34: error: too few arguments provided to function-like macro invocation
arch/x86/kvm/../../../virt/kvm/kvm_main.c:2624:2: error: use of undeclared identifier 'kvm_for_each_memslot'

***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[david@kernel.org dwmw2@infradead.org itazur@amazon.com jackmanb@google.com kalyazin@amazon.com kvm@vger.kernel.org patrick.roy@campus.lmu.de pbonzini@redhat.com pdurrant@amazon.com seanjc@google.com tabba@google.com vkuznets@redhat.com zulinx86@gmail.com]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

