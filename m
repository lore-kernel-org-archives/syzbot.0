Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.70
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793667323;
	b=aJ+0GhamqkwAxNr1tuGSB2567UaZW8nNl4KhumQcd8KVChGvkGfiEY8ud/1sACcV/28B
	 0x7aX+HntSQwJ9saFJnI+PrM2eaxRbJEsYiqAPU8MODN8Uy6GD5oBDM3L5+GrzdCmpAVs
	 Q6l6JQZvkdzvgPZNLEPDJmDKXSISgW3Ut5BktS6CGinq70Yp2OcFnb0LqhI3Ag+UHyGw/
	 zTGInil7LaSytzw481hB+GdMu6ztiGjmbs/20GhUtkudpVAtNcW49ztr6j6qO6x1K+5FW
	 CONsir7J6RjvQH4Pl7wzg0GzyZdm8hwPB6cJdlzJNF12SgbA1ADUSGkF6lQIIPPNtrg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793667323;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 MIME-Version:X-Received:Date:X-Google-Appengine-App-Id:
	 X-Google-Appengine-App-Id-Alias:Message-ID:Subject:From:To:Cc:
	 Content-Type:Content-Transfer-Encoding;
	bh=JnEYbNI7yHPElY4+uYltSnpg1gnA2yqgik2epRMQGQA=;
	b=Y4tytNhQ1CXw/Y6lqZ2Fmjpid9oFCfFhxlScoXGUTegFEDK3cU3REI0aCS6fkZf1vWSe
	 9OgyhAZEr7kgMMiqYsA8yBZORNBUV12nAg+eX7F2AW68uGi+GaPNJSiVDhDOELaFojaiP
	 hy2Ec8xYot9qkiyEfAXUEzWZBYWHg1++AqGRWpfKBbm0my37SQy8Kuc/HHyzPv9vzyMyf
	 /ho3XuC7GWiHT+pL4h1Hj2p8b/rQFR9B0C+weqdNLCD3t8mgmnc+p+ntdoPHsavHC5VCj
	 aK1Rkrt/maABnYCXoLmLzzwmYOTUJpU7/Bbw38aZb/vcZWjLBi+bm6Qex6aDc180SYw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=syzkaller.appspotmail.com;
	spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	arc=none smtp.remote-ip=209.85.210.70
Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com [209.85.210.70])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7DD2606A324
	for <syzbot@lists.linux.dev>; Tue,  3 Nov 2026 00:55:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C7DD2606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f70.google.com with SMTP id 46e09a7af769-824cc5f7fcdso4496998a34.3
        for <syzbot@lists.linux.dev>; Mon, 02 Nov 2026 16:55:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793667322; x=1794272122;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:date:mime-version:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=JnEYbNI7yHPElY4+uYltSnpg1gnA2yqgik2epRMQGQA=;
        b=RJ40EZC+lKPa04IN57iShLpFTwPqan/xjqeLKDqVJMEpoE8tOXCOIsezLrAQyn8uur
         5GoSA3lHxEezMIVuEW1QckDCUM6juG+7lsASXn+PBGMWxrbSZFW9xPfQ4YghpEwnPiH8
         R3vZsONF8mCh3jKXjWIz3IcqztQe20q/ds1txZTNvX9mLa4sIr7+t768WsbDXSs/y8Z4
         DFqFT6dCtHW5RU6siBSj0pT+hTG2SwXqh0rALU0WRtR7u2P6eRkWzsdGOfaz0MkxBfQV
         FLKVnzU7mixKuzrFtqm2aXvzeNVv0tiWmrhQKxKp43dQzU8Ca+IIAkP6pe46p1eSv6Ni
         kfTQ==
X-Gm-Message-State: AFq9FYKXzVvCz4kiFHwzGYLuuEFCNZCR1cvm99L22TBszD75eJalFoa3
	QuipJtkDLlfiZ6Q4DS994UsbpMiHtz+huTrD1X1yOGmybEPI/rMk9rpGF5fU2GieZjigIZDiQzS
	QLoW63TzJLilt04oV4k8DdUEtPF490FEApDYnuRgzXoygFQmLSYAlIuuXy7A=
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Post: <mailto:syzbot@lists.linux.dev>
List-Help: <mailto:syzbot+help@lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
List-Owner: <mailto:syzbot+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-Received: by 2002:a05:6808:124a:b0:4e9:7d56:846f with SMTP id
 5614622812f47-5640dd5fca9mr7543561b6e.41.1793667321782; Mon, 02 Nov 2026
 16:55:21 -0800 (PST)
Date: Mon, 02 Nov 2026 16:55:21 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6ae930f9.52c4c7f9.b7231.0007.GAE@google.com>
Subject: [moderation/CI] Re: KVM: SVM: Support direct setting of VMSA for
 SEV-SNP guests
From: syzbot ci <syzbot+ci882598b7c73b14af@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v3] KVM: SVM: Support direct setting of VMSA for SEV-SNP guests
https://lore.kernel.org/all/20261102114137.1198982-1-joro@8bytes.org
* [PATCH v3 1/8] KVM: SEV: Document SNP direct VMSA userspace ABI
* [PATCH v3 2/8] KVM: SVM: Implement GET_AP_APIC_IDS NAE event
* [PATCH v3 3/8] KVM: SVM: Hold SRCU while reloading guest-owned VMSAs
* [PATCH v3 4/8] KVM: SEV: Add direct VMSA capability
* [PATCH v3 5/8] KVM: SEV: Allow VMSA pages in SNP launch updates
* [PATCH v3 6/8] KVM: SEV: Add SNP vCPU state get and set commands
* [PATCH v3 7/8] KVM: selftests: Test the SNP APIC-ID-list GHCB request
* [PATCH v3 8/8] KVM: selftests: Test SNP vCPU state and direct VMSA launch

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/01dc1cf6-36a7-4046-a74c-d1aa7cc54a5c

***

kernel build error

tree:      torvalds
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvald=
s/linux
base:      6628e7d4c6b25c8d18f1345e3a20d21829aae7e4
arch:      amd64
compiler:  Debian clang version 22.1.8 (1~deb13u4), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/43f9299c-2cb7-46c9-8c71-1cf0c3c09d1=
e/config

arch/x86/kvm/svm/svm.c:5477:2: error: cannot jump from switch statement to =
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

