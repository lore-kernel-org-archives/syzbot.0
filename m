Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85E3C288C2D
	for <syzbot@lists.linux.dev>; Thu, 23 Apr 2026 21:40:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776980433; cv=none; b=YIs3RSKHVt/CgHblQVZuRU2eS+KycshYfWauG/UdYf7xf/g93S3dpwH63xfXuL7mH+o7mZ2NbhF/MlwzpeNXN0pvPu0DcBwoXyqv0nW5QVYTgV8R/gNi9XX+4Rk/5UQJequNQrZqffMQvukkdccTW7RyW7B7SoWVVvE2bPTySao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776980433; c=relaxed/simple;
	bh=CbPwkH8GGpVhvquOXvmjt1B4zlAW22+V1IEsQz0Q8Qk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=TFkxtaAHiMzz6CDdW25EKVN+yeY+a8m7QmhD2uZp4vTlVHdZU2+8DeEeDqf4ih5Br9qnK5dm5Pur1Xw5vYvIVnY4vW5HpiVhzfku+chZ/NvL9bSBpvOQtqylr9WBsPTeyQBktEnIUA7zlWksfZZYMXN/Nref65KaUArF5kn9Iys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=C857QSwX; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="C857QSwX"
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-82f85179263so8739766b3a.3
        for <syzbot@lists.linux.dev>; Thu, 23 Apr 2026 14:40:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1776980431; x=1777585231; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Idm038EH6nKJVMjStePrzmNY1P6l5m6C6WmOOw+gdn8=;
        b=C857QSwXP2blrD0a0mtTTjdp5lMic8MhKNIdf4ZO5bABlRDbtXRivzCN8Dm2qYu9ao
         MJJPUhofcKU3j0o8+C8x2qdg0qlnRizb+tKjzeQO+BGrbjd1nPmlET9aY8ShH7eixtxN
         kLt652xfGH1BVYjUB0WeO4XV8TKIwzGtKauqDrKJ/h7Bqd4GhOkkgUWP/QetGAkiyYZq
         o+GapW4Zx41tCIa4s7fJUWD4KXMp/4HEPk/uao7e0w0EN/gg23leBgQu8R5srcBLs36k
         bqBYtqMutUSByyLp/zPNbp4xVHdjwN0r3kGmoZ0CbGSqUgqFCUBqlQ8AukS3Z/v9W3x4
         gmwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776980431; x=1777585231;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Idm038EH6nKJVMjStePrzmNY1P6l5m6C6WmOOw+gdn8=;
        b=RRSjcWCjohvm+MrKMFujKfcM0uWfX3UkCewOVPDgryXwpdfrO93OgKD2ytob3n0PEy
         xEm1VLXSLdmetL3GZ6h/EAVJ98L4IvPLnmzRPY9dsU3Dz37RIV679nCzhMmqTgKCl4bD
         6KPUptIaNVMg0VQS4WbQ81Oei+E/7aUqAAKniMhnQsUOSdKbENAx+i4zR0ZgYIv7RgMu
         gkZH395Z5yldw9kmUvnvBWPBCfdJA1rXEVW1AUN2NV0/qtpZ9FiHoGmZ6AFchMk60YKY
         1KVkS9icCbTPQOWr1oZs2rrqoyWISlrRfeRMjhdELF8aQOdYO+y6kRGNiwVoBjbWv0sD
         4PFA==
X-Forwarded-Encrypted: i=1; AFNElJ9XaEmX+BDhVcoTwjAP2lo39+rfankmWk9OmmUApPLlarhYncQ2sS8q/k5lbPZGTvLTU/kxZ0E=@lists.linux.dev
X-Gm-Message-State: AOJu0YzcXjApI+QXAgFVIVC7I51/YHoBXfA4R4k05Ltqr0vYF8g54p3/
	2ihzgEW75xvdAtEyBz91+n4+wt5E6dm59RTq5kfZV4VitQgb3GxIEOH8+iWDrMZKhQ5He4v9uK1
	I5BItEg==
X-Received: from pfbde11.prod.google.com ([2002:a05:6a00:468b:b0:82f:3ec7:cdd])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:6702:b0:82d:2086:de2a
 with SMTP id d2e1a72fcca58-82f8c8e8ad6mr19051710b3a.35.1776980430742; Thu, 23
 Apr 2026 14:40:30 -0700 (PDT)
Date: Thu, 23 Apr 2026 14:40:29 -0700
In-Reply-To: <69ea8687.a00a0220.9259.002c.GAE@google.com>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260423140833.439512-1-seanjc@google.com> <69ea8687.a00a0220.9259.002c.GAE@google.com>
Message-ID: <aeqRzanSaa9P_EPg@google.com>
Subject: Re: [syzbot ci] Re: KVM: x86/hyperv: Fix racy usage of vcpu->arch.hyperv
From: Sean Christopherson <seanjc@google.com>
To: syzbot ci <syzbot+ciae116ac2b0afefad@syzkaller.appspotmail.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, pbonzini@redhat.com, 
	vkuznets@redhat.com, syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="us-ascii"

On Thu, Apr 23, 2026, syzbot ci wrote:
> syzbot ci has tested the following series
> ***
> 
> WARNING in kvm_hv_vcpu_uninit
> 
> tree:      linux-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/next/linux-next
> base:      85f871f6ba46f20d7fbc0b016b4db648c33220dd
> arch:      amd64
> compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
> config:    https://ci.syzbot.org/builds/4f8c36c7-e865-4f65-bb81-e22962e8a1e0/config
> syz repro: https://ci.syzbot.org/findings/60fac5d8-1296-4ec7-a8e3-40f561d007e9/syz_repro
> 
> ------------[ cut here ]------------
> debug_locks && !(lock_is_held(&(&vcpu->mutex)->dep_map) || !refcount_read(&vcpu->kvm->users_count))
> WARNING: arch/x86/kvm/hyperv.h:79 at to_hv_vcpu arch/x86/kvm/hyperv.h:78 [inline], CPU#1: syz.2.19/5974
> WARNING: arch/x86/kvm/hyperv.h:79 at kvm_hv_vcpu_uninit+0x163/0x1b0 arch/x86/kvm/hyperv.c:906, CPU#1: syz.2.19/5974
> Modules linked in:
> CPU: 1 UID: 0 PID: 5974 Comm: syz.2.19 Not tainted syzkaller #0 PREEMPT(full) 
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
> RIP: 0010:to_hv_vcpu arch/x86/kvm/hyperv.h:78 [inline]
> RIP: 0010:kvm_hv_vcpu_uninit+0x163/0x1b0 arch/x86/kvm/hyperv.c:906
> Call Trace:
>  <TASK>
>  kvm_arch_vcpu_destroy+0x1a9/0x380 arch/x86/kvm/x86.c:12963
>  kvm_vm_ioctl_create_vcpu+0x69a/0x930 virt/kvm/kvm_main.c:4269
>  kvm_vm_ioctl+0x893/0xd50 virt/kvm/kvm_main.c:5168
>  vfs_ioctl fs/ioctl.c:51 [inline]
>  __do_sys_ioctl fs/ioctl.c:597 [inline]
>  __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f

Argh, what a pain.  It's effectively the same issue that I fudged around in
kvm_hv_set_cpuid(): KVM queries HyperV state during vCPU creation, before taking
vcpu->mutex makes any sense.

One thought I had was to initialize vcpu_idx to -1, so that to_hv_vcpu() could
detect that the vCPU isn't yet visible to others.  Arguably that would be also
nice-to-have as it would harden against consuming vcpu->vcpu_idx before it's
fully initialized.  As-is, goofs would result in KVM thinking its vCPU0.

diff --git virt/kvm/kvm_main.c virt/kvm/kvm_main.c
index 7fcb92c69dc8..35e92cfb2a45 100644
--- virt/kvm/kvm_main.c
+++ virt/kvm/kvm_main.c
@@ -4198,6 +4198,8 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, unsigned long id)
                goto vcpu_decrement;
        }
 
+       vcpu->vcpu_idx = -1;
+
        BUILD_BUG_ON(sizeof(struct kvm_run) > PAGE_SIZE);
        page = alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
        if (!page) {
