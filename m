Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B70B2C0F9B
	for <syzbot@lists.linux.dev>; Fri, 15 Aug 2025 15:24:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755271475; cv=none; b=Xs6brY4eq4wcWuh6wFp9cHREB3Cnf1I45hVra1um4DJRghydnAmwkH0lwezosPfcyPUD6253dLpVCAZqWVfuOAenQhf4D0BTEKTO+GHhr8K5FKjhPRj/KzcMqsOpNX/pGPCopPurE0ERZImsbD2hWJwfN5DaKoU0r7cEELAn0XI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755271475; c=relaxed/simple;
	bh=tQ1PHm9SWlFPoQSw5LhxX2Vf55dtCDNr9DNH1mD2vQk=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=izvT7SP00YB96PZ98k8yLmcrRwvwieK9XyRuikj3CZI5az8m78l+OVWo44Rby8RnoGdomWJju3lAvq0IAyVy+bw2miC5ABKBw5vqrpRwkmsf/qAF7fH9yXMwhqtKbGu/cJMrggdP0RQgQxlIN4VMRWDHnPoVntG/Yp+fG4HEtt4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-3e5758168ffso17956575ab.2
        for <syzbot@lists.linux.dev>; Fri, 15 Aug 2025 08:24:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755271472; x=1755876272;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3An1IRlggyZJ01ddy564k2J0NFqGWkP3JTvHFV9nJ1s=;
        b=lIKcr5lP9xJDFS4zUrhaV1FcofCjEvEAzSzaCMRPb9A3DXdwzVHp6WZDBUoGj4BrpO
         NpOfM0gy2BJan76mron6kUf05Y5zF2f18nJR5iirMyivzmQahL6g8rNPUFBM5K9ZPUgA
         242txqxyp3jAC+Wf8Lrlj1eyOBPvrWLG9gfBRHE7y6vWSIdGU0CEIwKTziEVUgZl6evg
         cKHu9Qho4Re28RmK41FpzND54YwMJY4Jb0fn9PpKVboF6m0vzLPxZcAJ14UPTd9Q9UUv
         1yD6mtYwVqInP6Ej5PQPt8GdD1nsumSqVQ3BSXPgihBJxRDWLi3M/xiuAUpNXD25Setz
         DR1A==
X-Gm-Message-State: AOJu0YxynlY9vq/CImYNk5Pb5l8VDRVcnqdPoI/f13xHqCXYxmOQHvmY
	82lNBWf8XUmZzkDv1JngUer4+hUOrWh8SaUVFWACJdaSVtsrQe4Tq6SsQXswYlfapsgIlEUHoK+
	t3UDsZ1bC4ACvrfC0tn9yH3nrdjjf1Cw69//X7UBkXhF4s7DAuoVzzcNkVSg=
X-Google-Smtp-Source: AGHT+IEakOhgxRRfPY5H+tcDUiu14RwKBGYJsspvG2JWF62Kfi/uJ9cHZ/es+6WI+rEO1p7QmdXuW6Sxt9pIBEwsWGvL5PlCj6Rj
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:2196:b0:3e5:51bb:9cd9 with SMTP id
 e9e14a558f8ab-3e57e80ddbemr43145025ab.8.1755271465045; Fri, 15 Aug 2025
 08:24:25 -0700 (PDT)
Date: Fri, 15 Aug 2025 08:24:25 -0700
In-Reply-To: <20250814120237.2469583-1-dwmw2@infradead.org>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <689f5129.050a0220.e29e5.0019.GAE@google.com>
Subject: [syzbot ci] Re: Support "generic" CPUID timing leaf as KVM guest and host.
From: syzbot ci <syzbot+ci156aec4dff349a40@syzkaller.appspotmail.com>
To: ajay.kaher@broadcom.com, akataria@vmware.com, alexey.makhalov@broadcom.com, 
	bp@alien8.de, dave.hansen@linux.intel.com, dwmw2@infradead.org, 
	graf@amazon.de, hpa@zytor.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, mingo@redhat.com, pbonzini@redhat.com, 
	seanjc@google.com, tglx@linutronix.de, vkuznets@redhat.com, x86@kernel.org
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v1] Support "generic" CPUID timing leaf as KVM guest and host.
https://lore.kernel.org/all/20250814120237.2469583-1-dwmw2@infradead.org
* [PATCH 1/3] KVM: x86: Restore caching of KVM CPUID base
* [PATCH 2/3] KVM: x86: Provide TSC frequency in "generic" timing infomation CPUID leaf
* [PATCH 3/3] x86/kvm: Obtain TSC frequency from CPUID if present

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/a9510b1a-8024-41ce-9775-675f5c165e20

***

kernel build error

tree:      torvalds
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvalds/linux
base:      dfc0f6373094dd88e1eaf76c44f2ff01b65db851
arch:      amd64
compiler:  Debian clang version 20.1.7 (++20250616065708+6146a88f6049-1~exp1~20250616065826.132), Debian LLD 20.1.7
config:    https://ci.syzbot.org/builds/590edf8b-b2a0-4cbd-a80e-35083fe0988e/config

arch/x86/kernel/kvm.c:899:30: error: a function declaration without a prototype is deprecated in all versions of C [-Werror,-Wstrict-prototypes]

***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.
