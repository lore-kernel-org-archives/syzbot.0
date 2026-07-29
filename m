Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF852488D91
	for <syzbot@lists.linux.dev>; Wed, 29 Jul 2026 13:17:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785331079; cv=none; b=NZaOwPeH+Za38YtNQcRE+fZ7UiuJa22aUk0F9uWRUlY2/7jDaJ/zA95ZVfti2ebLg/9bps7rS/vbBn2EZlRgiVenBY5jnZIv+CWf14jMoX2cLzy0D+ye8qNoIkTu9iNh+cr1A+X2r1NWs+pj3bxTeM1BB5ilumo/qxWpcZ54Ils=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785331079; c=relaxed/simple;
	bh=ZSFiB9M/qtrEJYDThINsJFB6RBwaJPI9l/L4uzoi1pw=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=HwOtzJHYgke3PHQSg7dPzDCKMtVY56oNaRLdkVfPg9noM9MDYsztLyWZIQjk78h6tksxfvEOTdeePf3AYc3SFNmcaYxg2XnXsRVMcLrH9scEm5SyL8nb0VI30uu5QDt5iy2RGxA823yebnA0AgDHrsD3AcxxgsM6CCvbHe6cfX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WsNzug67; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WsNzug67"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 70D2E1F00A3F;
	Wed, 29 Jul 2026 13:17:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785331077;
	bh=X9l8vtZzyQ6VF0G8e/G9Hupph/jVwBQgkio/2NdIplw=;
	h=From:To:Cc:Subject:Date;
	b=WsNzug67ICRXyCuwYOXugUPLQKl6aCg63n2mEqJeR90jYIFLblCCaZEwt/ERrGaAz
	 a+nXrlMMbD1NO4lnhBZ5ULKVHskESenQcJbgzhZwiR1pTCGQJRcWLuyyghyQGGpkDz
	 CqF1VtwHTGCrPJoonTnb67UgHnuNb6r3J6IcNzh3vdZoyLeFR89+zjTODGn186Nq58
	 tyYEusKiYolrx8Jnb72GjwyPqYpPy8tdbdvvH/n3gOQZLgQO4kHJKDNzGbUbqzDBCd
	 j+fBUn+KUONiZ01d6UM2Dv3UQvrif8vxGWZwbd3ofjc5yVPYP4zsa1JpoJbu78OJi7
	 eSYBmhBhpbR3w==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] KVM: pfncache: Check gpc->active before sanity checking GPA and HVA
Message-ID: <a144cc7e-406a-4896-9299-9f425c722100@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Wed, 29 Jul 2026 13:17:57 +0000 (UTC)

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

Fix this by moving the check for an inactive cache to the very beginning of
__kvm_gpc_refresh(), before the WARN_ON_ONCE and before acquiring the
gpc->lock. It is completely safe to check gpc->active before acquiring
gpc->lock because all modifications to gpc->active are fully serialized by
gpc->refresh_lock, which is already held and asserted at the start of the
function. Bailing out early also avoids the overhead of unnecessarily
acquiring and releasing the lock (which disables and re-enables interrupts)
for a cache that cannot be refreshed.

Fixes: 721f5b0dda78 ("KVM: pfncache: allow a cache to be activated with a fixed (userspace) HVA")
Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+cde12433b6c56f55d9ed@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=cde12433b6c56f55d9ed
Link: https://syzkaller.appspot.com/ai_job?id=4e819403-979c-4f19-96ab-28961c06eab0
To: <kvm@vger.kernel.org>
To: "Paolo Bonzini" <pbonzini@redhat.com>
To: "Paul Durrant" <pdurrant@amazon.com>
Cc: <linux-kernel@vger.kernel.org>

---
diff --git a/virt/kvm/pfncache.c b/virt/kvm/pfncache.c
index 728d2c1b4..fcfd5555b 100644
--- a/virt/kvm/pfncache.c
+++ b/virt/kvm/pfncache.c
@@ -263,19 +263,17 @@ static int __kvm_gpc_refresh(struct gfn_to_pfn_cache *gpc, gpa_t gpa, unsigned l
 	void *old_khva;
 	int ret;
 
+	lockdep_assert_held(&gpc->refresh_lock);
+
+	if (!gpc->active)
+		return -EINVAL;
+
 	/* Either gpa or uhva must be valid, but not both */
 	if (WARN_ON_ONCE(kvm_is_error_gpa(gpa) == kvm_is_error_hva(uhva)))
 		return -EINVAL;
 
-	lockdep_assert_held(&gpc->refresh_lock);
-
 	write_lock_irq(&gpc->lock);
 
-	if (!gpc->active) {
-		ret = -EINVAL;
-		goto out_unlock;
-	}
-
 	old_pfn = gpc->pfn;
 	old_khva = (void *)PAGE_ALIGN_DOWN((uintptr_t)gpc->khva);
 	old_uhva = PAGE_ALIGN_DOWN(gpc->uhva);


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
