Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08FE736197E
	for <syzbot@lists.linux.dev>; Fri,  2 Oct 2026 20:39:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790973571; cv=none; b=t2iiWD49khDd7SfNGNpeFG7NRDV5eTRznvnr7AY7aEsquLlHVSNJ04NaNLz8BLxsm9kwCeEEFwGdJrOwcJVHJjSM9qggSrwTHwyoO5t2hGi9FijIf0Gu7zqUh00ffiJJi5KZ434qaRBPFVu3PUmvwO8TmjbtcEBd5HhlbiVUBfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790973571; c=relaxed/simple;
	bh=S0ge2C9Y15thBhCiKs8x41HME8Zo3cnqn4nPcWu4Sog=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=NVjR9mZnmviw4N+UZboMy9EzejC/wsUtlOQsOaAjtXNmd7WqspydpNryGFKuAtEK57c9hawyeLq2/fBlutJcZKFEz71NJuDc7vNCclIfJ2BQmY8MlyzBcyZc0YNMNIxbjBQDGUA7ozwRmCE7npzojOLGLb2jU48o0IFuSS7Wn+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=AYJv55z3; arc=none smtp.client-ip=209.85.214.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="AYJv55z3"
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2df8d1e91c9so305415ad.0
        for <syzbot@lists.linux.dev>; Fri, 02 Oct 2026 13:39:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790973566; x=1791578366; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=J0j9tHQdvgPyeE7kOurEk+4M8mVRW7MJtC+t0YWufic=;
        b=AYJv55z3iyttR0iXGyAtP8j/D1mJ/up932SV0wuRlT60hz5TRr7HWFKZ8jxin/BIBd
         VGaAgnx59/JeaWe7TMAfmO2AusRGlyT3ixVJYGUMK9/zQ5jTiFVr3jbNkz+iABP0DEYN
         61O4cVqunMFFzXfaTgC0oYo5MYse0j0YHbyaa4v80fQhe0yScSymlbHyp2SET16b0K01
         1KJL77gU7YitILC9zscY14oiR7Orbw0kzsU7A8Vvl3bCfQ6SFvJgrzPK8Xq6tYyFjkgD
         7+uMixdcZjAjzU+hwd1btD8iAzbs6nV/mhotgvrdyixdAgJJYof4aL6IdrO+qRPlBa5r
         sUlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790973566; x=1791578366;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=J0j9tHQdvgPyeE7kOurEk+4M8mVRW7MJtC+t0YWufic=;
        b=fBIQFWfyDxfWF8kgrH2wSHOkZplAxAMWbPgZaFtYm0vGCWT/X6/H3aAFXQezeA5Z2P
         jkEmf53lEw1r5K6+tsm/x8LJytu+eKh1kHMPm/eY6clBo0Dws70hEOT0soVrI89HnneI
         +nFeBNPVI5r6zKfJqqkPhqv5mWLcGnFHHU4uajnVw4Ud03enk90iBhzy/5BNsFHcFt8g
         69ctrCBBjSH5aY7OkmyF1OCN+Vk+BITe8MoOFlVrTaON0e33Ok+l1+KBxoI7mhkgz2Yf
         fMNQAmJf+/jOYaEfSkcWmZXpaQ2wuoaYZy+CHZ91ZRc2hnrw3XgmXHvcRiQNMKopGHmF
         rTag==
X-Forwarded-Encrypted: i=1; AKwUvBzxbOoHkjgVhVqwheAstINL3LKjTp4a8gsC2O+tJ4P5FuCDnUAk727WE8+6r1nllRgkg+Nc3B8=@lists.linux.dev
X-Gm-Message-State: AFq9FYJyT+3nbtYj9c3uVmw7kbQxyqvuoHoAnhHf8lmGgY6XAXUIipgb
	f3AWmJQtz1tpLmqCUaXVOpPckq24hB9yPO23LFMLXHNGEDPAnm30yK3uM5ymqHAbsskZvV+rK93
	iN0pYPQ==
X-Received: from plhd13.prod.google.com ([2002:a17:903:230d:b0:2df:8053:e258])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:18b:b0:2e3:1bb4:611d
 with SMTP id d9443c01a7336-2e49b6771e7mr42633885ad.49.1790973566345; Fri, 02
 Oct 2026 13:39:26 -0700 (PDT)
Date: Fri, 2 Oct 2026 13:39:25 -0700
In-Reply-To: <6ac0145f.34119e79.2f92f3.0003.GAE@google.com>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20261001202234.3794060-1-seanjc@google.com> <6ac0145f.34119e79.2f92f3.0003.GAE@google.com>
Message-ID: <asAWfZ0N1MXgwQtn@google.com>
Subject: Re: [syzbot ci] Re: KVM: Fix+harden against bad uaccess using dying VM
From: Sean Christopherson <seanjc@google.com>
To: syzbot ci <syzbot+ci69d67bf25886d3bd@syzkaller.appspotmail.com>
Cc: jmattson@google.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, maddy@linux.ibm.com, npiggin@gmail.com, 
	pbonzini@redhat.com, syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="us-ascii"

On Fri, Oct 02, 2026, syzbot ci wrote:
> ------------[ cut here ]------------
> !__kvm_can_do_uaccess(kvm)
> WARNING: ./include/linux/kvm_host.h:1360 at kvm_can_do_uaccess include/linux/kvm_host.h:1360 [inline], CPU#1: syz.1.18/5858
> WARNING: ./include/linux/kvm_host.h:1360 at kvm_is_guest_access_ok virt/kvm/kvm_main.c:3216 [inline], CPU#1: syz.1.18/5858
> WARNING: ./include/linux/kvm_host.h:1360 at __kvm_read_guest_page+0x38e/0x440 virt/kvm/kvm_main.c:3226, CPU#1: syz.1.18/5858
> Modules linked in:
> CPU: 1 UID: 0 PID: 5858 Comm: syz.1.18 Not tainted syzkaller #0 PREEMPT(full) 
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
> RIP: 0010:kvm_can_do_uaccess include/linux/kvm_host.h:1360 [inline]
> RIP: 0010:kvm_is_guest_access_ok virt/kvm/kvm_main.c:3216 [inline]
> RIP: 0010:__kvm_read_guest_page+0x38e/0x440 virt/kvm/kvm_main.c:3226
> Code: f2 ff ff ff 0f 44 d8 31 ff e8 5e a4 89 00 89 d8 48 83 c4 30 5b 41 5c 41 5d 41 5e 41 5f 5d e9 09 ac a8 0a cc e8 83 9e 89 00 90 <0f> 0b 90 bb f2 ff ff ff eb da e8 73 9e 89 00 90 0f 0b 90 bb f2 ff
> RSP: 0018:ffffc90003157778 EFLAGS: 00010293
> RAX: ffffffff813e2d22 RBX: 0000000000000000 RCX: ffff888174382580
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
> RBP: 1ffff1102217d82a R08: ffff888110bee183 R09: 1ffff1102217dc30
> R10: dffffc0000000000 R11: ffffed102217dc31 R12: ffff888110bee180
> R13: ffff888174382b40 R14: 1ffff1102217dc30 R15: 0000000000000000
> FS:  000055557c0db500(0000) GS:ffff8882a8cda000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f458dfeb840 CR3: 000000016c9d0000 CR4: 0000000000352ef0
> Call Trace:
>  <TASK>
>  kvm_vcpu_read_guest+0x64/0x140 virt/kvm/kvm_main.c:3284
>  nested_vmx_load_msr+0x133/0x4d0 arch/x86/kvm/vmx/nested.c:1107

Oh man.  vmx_leave_nested() is so broken.  If loading MSRs on nested VM-Exit is
broken (and it obviously is), then storing MSRs on nested VM-Exit is also broken,
i.e. there's at least a second case where nVMX can write to random process memory
on vCPU teardown (shadow vmcs12 being the other one).

It probably makes sense to go straight to open coding punting the vCPU out of L2
in vmx_leave_nested() instead of hack-a-fixing a bunch of flows.  I.e. replace
patch 8 and 9 with a proper fix.
