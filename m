Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BB7E4779BE
	for <syzbot@lists.linux.dev>; Wed, 29 Jul 2026 14:55:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785336959; cv=none; b=bRqwnQtoPl++bSD//bMUsnCb0zj7e7UqroXxxs+ji/a9kV+sc16Weqo5u0oO/XauUtCq7c9rdV2xJ/Ch+jT97VYCS08moF91bTEJJ7mJBxb3BFvI5WxUX7jGuWAVPtbycaBbhjzGCELacGUWSGUcMqgNH5hDbR1KdgeSLkgZdYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785336959; c=relaxed/simple;
	bh=mAfmUh1bpNYYnlnQpNmPvysYtculY/uqr1HNzgHqHGw=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=M8pfV1m+L7cJaX/ubnOKyezsSl6IDqpVHvOCZxjFhfjJYeZNOAi6go33PqC5sUvZOtxQqbo2QgmbR+HnCGg2SOgh/3uK63uL/r9eFSrrrlGELMFLRs0698PPFKVeaH8I4cRjUoEDYAdcOTAagU3Frsqqa8xUvOCCiSZlTSfDTmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Qa52b72u; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Qa52b72u"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 8F0FC1F00A3A;
	Wed, 29 Jul 2026 14:55:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785336957;
	bh=gQ9Uv0vNCJIfElwb5LIstL8DP6y3ADbwQiT6ergXrpA=;
	h=From:To:Cc:Subject:Date;
	b=Qa52b72ulJr56fIt9Mh+Z97ruNBO9LV8SectE9cmrwYUk6TWaww/bfR1coHityYIj
	 4tJjRLYnJ/UFe/pkOtI2ii975lJjCh8J7C9XKw3akvA5W4kBFdTakpmy4oZBtSCrxV
	 Ie4r0x2OSOO+ssCLgMvan4sblmQN6rWUAXoZ2V8DhP5JxVv8ptmi4WwW9lLACeFePF
	 NwW/ge1hRDqXSd08utIs08FEX6Wm60jzMLJyEYCUyBGkF54cotbJ4MS/3OGCKxbMBO
	 HsEpnTokQJ3u+aP9+kDgH5V6k0ApzwGX6iqiSLa/rhnG0cDklHhdJJJNC+lGee8fNm
	 4vTM3wpW+QMqQ==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: nogikh@google.com, syzbot@lists.linux.dev
Subject: [PATCH RFC v2] KVM: pfncache: Check gpc->active before sanity checking GPA and HVA
Message-ID: <e88ab678-71c6-4de9-85e6-1d20d1579f28@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Wed, 29 Jul 2026 14:55:57 +0000 (UTC)

When attempting to refresh a gfn_to_pfn_cache (gpc) that has never been
activated, KVM triggers a sanity-check warning in __kvm_gpc_refresh(). This
occurs because an inactive cache naturally has both its GPA and HVA
initialized to error values, which violates the condition that exactly one
of them must be valid.

This can be triggered via the KVM_XEN_HVM_EVTCHN_SEND ioctl. If the guest
has not yet set up the shared info page, the shinfo_cache is inactive.
Attempting to deliver the event returns -EWOULDBLOCK, prompting KVM to
attempt a refresh of the cache, leading to the warning:

------------[ cut here ]------------
kvm_is_error_gpa(gpa) == kvm_is_error_hva(uhva)
WARNING: arch/x86/kvm/../../../virt/kvm/pfncache.c:267 at
__kvm_gpc_refresh+0x1510/0x1710 virt/kvm/pfncache.c:267
...
Call Trace:
 <TASK>
 kvm_gpc_refresh+0xe1/0x110 virt/kvm/pfncache.c:382
 kvm_xen_set_evtchn+0x14f/0x220 arch/x86/kvm/xen.c:1945
 kvm_xen_hvm_evtchn_send+0x120/0x1e0 arch/x86/kvm/xen.c:2036
 kvm_arch_vm_ioctl+0xfad/0x1a10 arch/x86/kvm/x86.c:7523
 kvm_vm_ioctl+0x8f7/0xd30 virt/kvm/kvm_main.c:5381
...

The warning can also be triggered via vcpu_info_cache if an event is sent
while the cache is inactive, causing the vCPU to attempt a refresh when
injecting pending events.

Fix this by moving the check for an inactive cache to kvm_gpc_refresh(),
before calling __kvm_gpc_refresh(). It is completely safe to check
gpc->active under gpc->refresh_lock because all modifications to
gpc->active are fully serialized by gpc->refresh_lock. Bailing out early
also avoids the overhead of unnecessarily acquiring and releasing the lock
(which disables and re-enables interrupts) for a cache that cannot be
refreshed.

Fixes: 721f5b0dda78 ("KVM: pfncache: allow a cache to be activated with a fixed (userspace) HVA")
Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+cde12433b6c56f55d9ed@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=cde12433b6c56f55d9ed
Link: https://syzkaller.appspot.com/ai_job?id=06c5ed03-3710-4a03-8db9-c370eb80da49
To: <kvm@vger.kernel.org>
To: "Paolo Bonzini" <pbonzini@redhat.com>
To: "Paul Durrant" <pdurrant@amazon.com>
Cc: <linux-kernel@vger.kernel.org>

---
v2:
- Move the `gpc->active` check from `__kvm_gpc_refresh()` to `kvm_gpc_refresh()`.

v1:
https://lore.kernel.org/all/a144cc7e-406a-4896-9299-9f425c722100@mail.kernel.org/T/
---
diff --git a/virt/kvm/pfncache.c b/virt/kvm/pfncache.c
index 728d2c1b4..aac85a140 100644
--- a/virt/kvm/pfncache.c
+++ b/virt/kvm/pfncache.c
@@ -271,11 +271,6 @@ static int __kvm_gpc_refresh(struct gfn_to_pfn_cache *gpc, gpa_t gpa, unsigned l
 
 	write_lock_irq(&gpc->lock);
 
-	if (!gpc->active) {
-		ret = -EINVAL;
-		goto out_unlock;
-	}
-
 	old_pfn = gpc->pfn;
 	old_khva = (void *)PAGE_ALIGN_DOWN((uintptr_t)gpc->khva);
 	old_uhva = PAGE_ALIGN_DOWN(gpc->uhva);
@@ -369,6 +364,9 @@ int kvm_gpc_refresh(struct gfn_to_pfn_cache *gpc, unsigned long len)
 
 	guard(mutex)(&gpc->refresh_lock);
 
+	if (!gpc->active)
+		return -EINVAL;
+
 	if (!kvm_gpc_is_valid_len(gpc->gpa, gpc->uhva, len))
 		return -EINVAL;
 


base-commit: f5098b6bae761e346ebcd9da7f95622c04733cff
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to Sign-off the patch as a human author
and send it to the upstream kernel mailing lists.
Reply with '#syz reject' to reject it ('#syz unreject' to undo).

See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
You can comment on the patch as usual, syzbot will try to address
the comments and send a new version of the patch if necessary.
syzbot engineers can be reached at syzkaller@googlegroups.com.
