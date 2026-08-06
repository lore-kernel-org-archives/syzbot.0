Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 183F63290C7
	for <syzbot@lists.linux.dev>; Thu,  6 Aug 2026 09:42:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786009344; cv=pass; b=Rdz32kjRIHuTir5YOuYe+JsaaChVG6liD+xZ+Z9zM/5VTlenSwGt4e0LV4QiUtubU0ZmjcEEw/R+d8R2Mt0MMZh473FKo/ww99Q62NX6f0BEbhXW3QU7XXKFJpxI3YudzojlCY9/CWhgylHJ3lwnyufk6sZgJ7SI+ExuAM3wSao=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786009344; c=relaxed/simple;
	bh=JerVKqTNqWo+3tl/VZM83zaT3KXPxJdBvXoohYg+AME=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ScMjuTjBvaA2qDzXX4pVwDNj/TmtWrwMAQm4H4TxXz6wgJb2g6kyfsOY6ctQaorochyUBLAOnF0sWDwkYBy6t51D+IfbvfwaweZv6HiccL7WuVdjJLJDgxUR56ag4llMxTYfcMpTZa7UdItM8nE912T+ct3pJdcPNeCVUBmfhsU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dlOo2l8i; arc=pass smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dlOo2l8i"
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-c15cb6f5c12so319516166b.0
        for <syzbot@lists.linux.dev>; Thu, 06 Aug 2026 02:42:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786009340; cv=none;
        d=google.com; s=arc-20260327;
        b=QpmPsMoO5RdnmR06btxMCCsXnz3B/CcRPUmD4ZNPIrNcHoPABYp++o+5/BQU70ic4w
         jsgVCiO4I6ElYY3ETuSxNWBzd1BctC9TQ0U/sw+UWdC7TiEdldvIkB124huynXLMWIng
         FMCaaWiNShXk523Zlj/iKWhXnjcID8O8x+UxEJuiEF/6F3f8cWfeTQ0JOrth5at1L/FM
         rht8uievQmEG0gNcsKwULu0LLHS729AE3hfJCJrKkuIlXAb6BDMm1lPizwrN4GcjtnE1
         6da6kubNkT7U64xzbu1O/YAHwrFMoIgz/6WyywAd3OOKhXW1GcWz1R4zwqn9/Y7AN1iW
         CC9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=PGm65M9+UlRi9qd2XWkqOZxg5s2mnHs8QR89EiTHzHc=;
        fh=K/8qPfQQbfVKwYIdAS4NDCKupAx8sBF7wv5iboeP16o=;
        b=EXubVX+RcQmUgUq5jqlwYIjWL1Y04bt5LWJ9PDeAXDMV2lDIB1RueeLm61fwL7UR7f
         cVxc0JjoI63DNW/p4IEHR38m+ChgBPYYGBkhgr/Q1rem9Nmm2jAh98wnO+W0JM94wyM3
         P5jbc1sAA4kxHrhvCdNfcjH/Yuo1VoPVF3m93Bg1zd7+tDl/dzyz8ZoeSJu8RE8cS7hR
         8b/rCHCuiuNTJxTJwu6Zl3COlCiXwkk7HXItHjH3TchPxh6dxhIwCputaorJXJfdbdI9
         GpuSqFkTHhClzmqDcLaAoA3xWVKINo7vLAMT55B3b0rtxVXqrYo/ukckGY8BE6l4kjof
         GleA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786009340; x=1786614140; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=PGm65M9+UlRi9qd2XWkqOZxg5s2mnHs8QR89EiTHzHc=;
        b=dlOo2l8icl1s/eVkHXBmCaD+TObT5Ofs1Kuf0/RPpC6iB6T66K7M0a4lAhHbeel6ny
         Si32XBmE3tFfS/3ZV7b6DdA5kjqVvCgdN/fuOKcbbe68eU9yUFVPz9rEMXfJTjMAL+LK
         aS9judCM3YVie/0LU7Kf3j7tp09BDBqc4OWqRAglEIZl/i8z601hu1sMFp0spGwOtO8X
         HsYkYrrz56WS60hJMKH0oZ4vL19dYbgT9k4eaox75S8kl4Gh6MaBeY1wN751X67NTWE6
         5UFj/WBTkilRSiVllWXYgZ9AD8i3pgl8MOtUE97bct+KYpQ7TU1T1s942aUnFXJN8g9E
         5JyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786009340; x=1786614140;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=PGm65M9+UlRi9qd2XWkqOZxg5s2mnHs8QR89EiTHzHc=;
        b=UGI6Sjn5jeoGQ/DbZrja5nG6/YIX+iOlkIwZo6nsTaEq5KnV0Wl9keQE6DwJnYYqyR
         yj5v88DNPi9aDVRPeO2S/JOwOqayBSResQniGJEm47c1ICzmS7/wxty2yfXkNavOxe8N
         l9zmnqUd2V1Wlsr0pvAifVywPjABqwvg6UxJqRwdIcHdU+C9CD4jSC9n8Hlon5qoVonV
         xofAutWLfsOVvsQ+E5Mein8ub1EtZRxMphXXoV4fCn3vv1tUmUSyS+GdYZzXT9npFglu
         t7fTlsz7KGTRIU/6qZVyBLS29cFP7RtpGq3ZKFcWkVLTItf0gKteYDHRKKec4IX6Ocsl
         1Kbg==
X-Forwarded-Encrypted: i=1; AHgh+Rpgh2fMNaWJ9ZuAw9OALyaBkWvxwquFgc4BwGiNCOfRyeGxkr9/umSmvKVF8FYufX7y1u3Jd+Q=@lists.linux.dev
X-Gm-Message-State: AOJu0YwlGP1iW4g4Ci6kyW7L0l3SQRhbgut3lLq7nxBWkVxjsisMHyDK
	OAEl2x1b3F1mrxzLUQDXAZ/gPUcXKiIBjZrv/WN+fQwouMvVsRkflL9bgWqrWbZ9yQ1P2Yph6vt
	Yj/lzO3WFDJPux6LDQFlwyR8gjjFGd684fhamJdU3
X-Gm-Gg: AR+sD118pskSK6tFK20dzGkbc7aKHy/BOWESpB06OFla7CSIYql7OqdlbP2OJz/8aXJ
	v34KILc3wKP3NtZ2Hi80hfxrCWFJWE2ym4LaIdpP1J0BtcA2ajHF03QRY8fnGRM2s8x4ktmiAsn
	D8jW8rfdncaq0FoYfp0H8aqmiY9SwxkVcP2F4DO9TpelXhbwcEhGN3L7qB9BDOsKy/zJ48YOov5
	BckQ9ZYge/q1bb0WPUPSeRm0vskumJMwE0QHc4LJdZKXEur8pc0Ov0STRhY4BikxT+oITYhv9w2
	ATrJwfBbgmQGrTiR+5Yaa+63fo74zCfbxY1NmcvqgRlHXFr2dJdcCibp3i5M6zYAxB90IWvoq4J
	QMrnmZBPLCd4=
X-Received: by 2002:a17:906:9f91:b0:c20:2eee:97b7 with SMTP id
 a640c23a62f3a-c2039d2dfbemr712567466b.10.1786009339126; Thu, 06 Aug 2026
 02:42:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <e88ab678-71c6-4de9-85e6-1d20d1579f28@mail.kernel.org>
In-Reply-To: <e88ab678-71c6-4de9-85e6-1d20d1579f28@mail.kernel.org>
From: Alexander Potapenko <glider@google.com>
Date: Thu, 6 Aug 2026 11:41:41 +0200
X-Gm-Features: AUfX_my126g9IFCw7qIz4F6b4xZfKrF0LANV0kCe0sEWxwIUG_iLCPrqBudr_lU
Message-ID: <CAG_fn=V13HOr+U+fvbu+YwkTSv9ikyGacN6cEVbEoku+m+m0Kw@mail.gmail.com>
Subject: Re: [PATCH RFC v2] KVM: pfncache: Check gpc->active before sanity
 checking GPA and HVA
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-upstream-moderation@googlegroups.com, nogikh@google.com, 
	syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 29, 2026 at 4:56=E2=80=AFPM 'syzbot' via
syzkaller-upstream-moderation
<syzkaller-upstream-moderation@googlegroups.com> wrote:
>
> When attempting to refresh a gfn_to_pfn_cache (gpc) that has never been
> activated, KVM triggers a sanity-check warning in __kvm_gpc_refresh(). Th=
is
> occurs because an inactive cache naturally has both its GPA and HVA
> initialized to error values, which violates the condition that exactly on=
e
> of them must be valid.
>
> This can be triggered via the KVM_XEN_HVM_EVTCHN_SEND ioctl. If the guest
> has not yet set up the shared info page, the shinfo_cache is inactive.
> Attempting to deliver the event returns -EWOULDBLOCK, prompting KVM to
> attempt a refresh of the cache, leading to the warning:
>
> ------------[ cut here ]------------
> kvm_is_error_gpa(gpa) =3D=3D kvm_is_error_hva(uhva)
> WARNING: arch/x86/kvm/../../../virt/kvm/pfncache.c:267 at
> __kvm_gpc_refresh+0x1510/0x1710 virt/kvm/pfncache.c:267
> ...
> Call Trace:
>  <TASK>
>  kvm_gpc_refresh+0xe1/0x110 virt/kvm/pfncache.c:382
>  kvm_xen_set_evtchn+0x14f/0x220 arch/x86/kvm/xen.c:1945
>  kvm_xen_hvm_evtchn_send+0x120/0x1e0 arch/x86/kvm/xen.c:2036
>  kvm_arch_vm_ioctl+0xfad/0x1a10 arch/x86/kvm/x86.c:7523
>  kvm_vm_ioctl+0x8f7/0xd30 virt/kvm/kvm_main.c:5381
> ...
>
> The warning can also be triggered via vcpu_info_cache if an event is sent
> while the cache is inactive, causing the vCPU to attempt a refresh when
> injecting pending events.
>
> Fix this by moving the check for an inactive cache to kvm_gpc_refresh(),
> before calling __kvm_gpc_refresh(). It is completely safe to check
> gpc->active under gpc->refresh_lock because all modifications to
> gpc->active are fully serialized by gpc->refresh_lock. Bailing out early
> also avoids the overhead of unnecessarily acquiring and releasing the loc=
k
> (which disables and re-enables interrupts) for a cache that cannot be
> refreshed.
>
> Fixes: 721f5b0dda78 ("KVM: pfncache: allow a cache to be activated with a=
 fixed (userspace) HVA")
> Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot
> Reported-by: syzbot+cde12433b6c56f55d9ed@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3Dcde12433b6c56f55d9ed
> Link: https://syzkaller.appspot.com/ai_job?id=3D06c5ed03-3710-4a03-8db9-c=
370eb80da49
> To: <kvm@vger.kernel.org>
> To: "Paolo Bonzini" <pbonzini@redhat.com>
> To: "Paul Durrant" <pdurrant@amazon.com>
> Cc: <linux-kernel@vger.kernel.org>
Suggested-by: Sean Christopherson <seanjc@google.com>
