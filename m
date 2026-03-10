Received: from mail-oo1-f71.google.com (mail-oo1-f71.google.com [209.85.161.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CA6A286430
	for <syzbot@lists.linux.dev>; Tue, 10 Mar 2026 13:38:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773149912; cv=none; b=NqGUQzYj1umBMRvFNRPBGqrH9AqkqDGhpvybmAdyQbEFbIu02IKdAmFFOxnJALgqoLRPlhdkU93rpn81Im7CEZjF50qy3d0wxBNOhrcYVFzJU5YHnLTQOd2IkqU69J1h/3i9AoQZyao70DFbRpxApLSCRkQhIK+or3vPCekFMv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773149912; c=relaxed/simple;
	bh=NrSr913bZlpn9PjzS8vFLD+5lW4Ml8cqc9Eh1mUrH94=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=ba/2BsA+3v2rAP1tRifFi4SolDQZmgzp2LZGXHuHX/faT8vxk0rBahSkCfC5+ItBtynHMF/vyTqUNhUqskqzt2Mj8Ze3Va3FjwWUC6Pyo78NWMLNb6CE7y5JdZkWg8kCa6Y5ylGDO9CmX/QJ1yX0UyoHY6weygJ+xdjdhQVTeh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f71.google.com with SMTP id 006d021491bc7-679c5ed0942so143353606eaf.1
        for <syzbot@lists.linux.dev>; Tue, 10 Mar 2026 06:38:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773149910; x=1773754710;
        h=cc:to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jWbFWwKhQq4BCL+E2UmAzaiIbxFXXw1K0sauLZcGNVo=;
        b=NBO19oiITotHNpCRofi+TpLGvvNvRxQNNuNGHJY8/ygwOqW4EpPgLm7Wse7azOoDKs
         YgYbffk/EsRe/0zV90dz6D4P6BKTFwAAMYsvYbnSBTnoHINiNbN4vABQ8tCe0l7ws09D
         g4X2S/51YICTcWwiBsmiSqytAPImZWHgGCze845vXynrGM9Y0x54llBveF5ZJ053sHuQ
         xa9xLwVGBm61R+gwt5DbKFRE05DAH8FpW5Vh+o41bLR3Z6djWvWEl5GV0reM0NkZiwI0
         S/fP+k+1DZEd7plROdrdiU70sMmIEjSZ3X96HWE2ViMSF0cIhnQiVjIpc4WRA5tkkfFd
         ZT0g==
X-Gm-Message-State: AOJu0YwmZKv0nZPFdLICakQDFb506gTQJqwVIJRtCFWHWHC2gnnpQcpL
	d2Yz90mb/Q8GwiXgfTmDdQN1IxWdeOaj1pyDlzpZmKKtxpw0GdIrUmDiQMVMwCtGF2B6DHuqyOE
	G4+7MjHI5eCSVceZh+2Ls9QilhlNsj06zzTKpXSNyRejbSoH9iq3QzOtfhas=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:1ca9:b0:67b:b2a0:6955 with SMTP id
 006d021491bc7-67bb2a0735cmr4441671eaf.48.1773149910003; Tue, 10 Mar 2026
 06:38:30 -0700 (PDT)
Date: Tue, 10 Mar 2026 06:38:29 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69b01ed5.a70a0220.be77.0114.GAE@google.com>
Subject: [moderation/CI] Re: KVM: pfncache: Add guest_memfd support to pfncache
From: syzbot ci <syzbot+ci0d589002099e63f1@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v3] KVM: pfncache: Add guest_memfd support to pfncache
https://lore.kernel.org/all/20260310063647.15665-1-itazur@amazon.com
* [RFC PATCH v3 1/6] KVM: pfncache: Resolve PFNs via kvm_gmem_get_pfn() for gmem-backed GPAs
* [RFC PATCH v3 2/6] KVM: pfncache: Obtain KHVA via vmap() for gmem with NO_DIRECT_MAP
* [RFC PATCH v3 3/6] KVM: Rename invalidate_begin to invalidate_start for consistency
* [RFC PATCH v3 4/6] KVM: pfncache: Rename invalidate_start() helper
* [RFC PATCH v3 5/6] KVM: Rename mn_* invalidate-related fields to generic ones
* [RFC PATCH v3 6/6] KVM: pfncache: Invalidate on gmem invalidation and memattr updates

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/ccfe2969-11ff-4a60-b754-7e88e8a233a5

***

kernel build error

tree:      kvm-next
URL:       https://kernel.googlesource.com/pub/scm/virt/kvm/kvm/
base:      e89f0e9a0a007e8c3afb8ecd739c0b3255422b00
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/1ac93cba-4964-499e-b638-ce065647b0dd/config

arch/x86/kvm/../../../virt/kvm/pfncache.c:107:18: error: call to undeclared function 'mapping_no_direct_map'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]

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

