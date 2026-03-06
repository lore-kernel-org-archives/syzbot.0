Received: from mail-oo1-f70.google.com (mail-oo1-f70.google.com [209.85.161.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 551FA32ABCA
	for <syzbot@lists.linux.dev>; Fri,  6 Mar 2026 22:49:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772837400; cv=none; b=UfnSZUl0na31ofxhn3WDvgffowVJMbsC3JNAW37OebDJAQKg23Y0TlxA9MDnXNdUk98UGm7Nw98nyqYazAAm+QhF8tLCuY3aM01g5XyvxzNxd8CsQmS+Ed+3vHaWUY6YDji8w1oUAGLnB+p23JdVdr2nDzdCdrz88vj+hSjIq1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772837400; c=relaxed/simple;
	bh=54B18YmyntzpYxvBaC84e4iHqLAAW/sJkzq3ydsy9MY=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=PIm3bKb4MKxPtqN1E3RGCipawWOHjD3EQWPrcswLMCflrTQcU9TxtdOKqjl05BXMtd3zyuzxa9i2BIsGxkzGN4dAFUKmnYeuxH32KzM4aQnFJLLacfbq+CywEP2Ml4Q92dd2bV0TY4GZY9deg9OYxzoFKgl10LkBDhedahw7naI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f70.google.com with SMTP id 006d021491bc7-672c40f3873so155606698eaf.2
        for <syzbot@lists.linux.dev>; Fri, 06 Mar 2026 14:49:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772837398; x=1773442198;
        h=content-transfer-encoding:cc:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SQxSMtcn5Q1anvHD4noxVq7j65wjOlDAUUTAGsu43D0=;
        b=nxceVHro+Q1UrwXrwWtLSJWWszf7WiPMKEszTK2lAfioV//grmLXln2k10eCkQhnNN
         k9zEbZNGAXzbAU1ibVzNqbGHx/ugUk031osNQVauuk1GRGgfO7dfiqtFjwzK7CT6cTls
         5S3bBCShXKNLmjBLS+G4pmTB0yjTbOOr4NFHZFfUmD82pOCiCXnuCCLTREeb4/bCWUxM
         ViOmXzHz/H96mt7/PjBhI1r9sYI6chCPCPzaex3hgY3g6fpT+NbSK3XEIovEVHQdFSs1
         6ih61xJV7NwNYELYM2Eneckj8AjWGEqLaSqGS0uN37woHTxjnnosfcerK7oKks6a0cR8
         qong==
X-Gm-Message-State: AOJu0YxwgIsp/X3VX3B3UyEh6OiR4YSK5AP9LgdFZjEQhwOlFwbrSFDn
	s2zTiN84oCZoIkk2jihjLil6fb7PN8tWN5vQN1maXegi+M95S1glCOBhipmJnTSgo/oP6Fz/qdI
	kNq9qwu9rdsLOW/7X9/GW4nPQOj4Ty00NS0TnvR2J0zHfztgcuLq2g9WPoWg=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:1c9b:b0:679:97d5:dd25 with SMTP id
 006d021491bc7-67b9bd50018mr2314483eaf.56.1772837398345; Fri, 06 Mar 2026
 14:49:58 -0800 (PST)
Date: Fri, 06 Mar 2026 14:49:58 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69ab5a16.050a0220.13f275.002d.GAE@google.com>
Subject: [moderation/CI] Re: KVM: Change [g|h]va_t as u64
From: syzbot ci <syzbot+ci56069e20f01c594c@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v1] KVM: Change [g|h]va_t as u64
https://lore.kernel.org/all/20260306041125.45643-1-anshuman.khandual@arm.co=
m
* [PATCH] KVM: Change [g|h]va_t as u64

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/e04b964e-423e-4ce1-b23b-a651a9975809

***

kernel build error

tree:      kvm-next
URL:       https://kernel.googlesource.com/pub/scm/virt/kvm/kvm/
base:      e89f0e9a0a007e8c3afb8ecd739c0b3255422b00
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp=
1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/b576e88e-e388-49ca-b4ca-3999c747bc0=
0/config

arch/x86/kvm/x86.c:8869:25: error: incompatible function pointer types init=
ializing 'int (*)(struct x86_emulate_ctxt *, unsigned long, void *, unsigne=
d int, struct x86_exception *, bool)' (aka 'int (*)(struct x86_emulate_ctxt=
 *, unsigned long, void *, unsigned int, struct x86_exception *, _Bool)') w=
ith an expression of type 'int (struct x86_emulate_ctxt *, gva_t, void *, u=
nsigned int, struct x86_exception *, bool)' (aka 'int (struct x86_emulate_c=
txt *, unsigned long long, void *, unsigned int, struct x86_exception *, _B=
ool)') [-Wincompatible-function-pointer-types]
arch/x86/kvm/x86.c:8870:25: error: incompatible function pointer types init=
ializing 'int (*)(struct x86_emulate_ctxt *, unsigned long, void *, unsigne=
d int, struct x86_exception *, bool)' (aka 'int (*)(struct x86_emulate_ctxt=
 *, unsigned long, void *, unsigned int, struct x86_exception *, _Bool)') w=
ith an expression of type 'int (struct x86_emulate_ctxt *, gva_t, void *, u=
nsigned int, struct x86_exception *, bool)' (aka 'int (struct x86_emulate_c=
txt *, unsigned long long, void *, unsigned int, struct x86_exception *, _B=
ool)') [-Wincompatible-function-pointer-types]
arch/x86/kvm/x86.c:8871:25: error: incompatible function pointer types init=
ializing 'int (*)(struct x86_emulate_ctxt *, unsigned long, void *, unsigne=
d int, struct x86_exception *)' with an expression of type 'int (struct x86=
_emulate_ctxt *, gva_t, void *, unsigned int, struct x86_exception *)' (aka=
 'int (struct x86_emulate_ctxt *, unsigned long long, void *, unsigned int,=
 struct x86_exception *)') [-Wincompatible-function-pointer-types]

***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[anshuman.khandual@arm.com kvm@vger.kernel.org linux-kernel@vger.kernel.org=
 pbonzini@redhat.com]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

