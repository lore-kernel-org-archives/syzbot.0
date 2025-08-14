Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5A681A08AF
	for <syzbot@lists.linux.dev>; Thu, 14 Aug 2025 23:22:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755213775; cv=none; b=WzdywXj/JjWugAk7ohxQUClpCjsyGyMKliomFJJQNbdIBNvF3GWjrfIpYsCe9RJcXtiHCmL/DTEtt5pFEyDrlOJBzsSNSF0UO2XeiGK/jLhg3eFjUzwA12nA0VSwQJVQY8i43R3YIeJpOEVIwGGRcb1iG0IVZKsocv+tD0huVGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755213775; c=relaxed/simple;
	bh=F7U7EQiPYEgKrJQ+W8NGpfSXh7J0P+JV57NjBYD4A18=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=qvqkV+OpgM9fyQb0ymboZzLnWYEnrz9dt3DhhxilKWUvYZp7o1OBra09/f9DGVOPzi0QuOmk40RWvQOcJc9XDpQsUgIqofTbn89upfo8QqGiF8lKz1k/1x2SW+dK4hPSXPofPMmgxGKSWQq86Yaj6CiUi2c42klzyt8//8Mv+jk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-3e56ffd20d9so40083095ab.1
        for <syzbot@lists.linux.dev>; Thu, 14 Aug 2025 16:22:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755213773; x=1755818573;
        h=cc:to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=z1U4kaYWzsVsduKKWhRuGCBzhAwj2M52Uxbpj2AiriI=;
        b=lyaTrpRsuaECuegsMPfTGAIEbxLsY9/hxHFkPZ/N5ElaRdYxz5rLMZ0OOSE5OcnEQ0
         EuKZCDJl8Sgv2oIX0hOvL8SBddYHJnVqvI7FAO4V47wx34rFtiDKoo+vhh4RZihH/CKf
         vSp2j6KJlYDROeytbYirSMQx6wbu6LovM0vX4Oxvd/By93SoQGDeyErQH76CiD/zvoPB
         mMUrtHMpN0xhLJxyK82JnnDR28047sVZxhnSTXsv6+SCk51GT6o0Sp3uSy/NNCvcL2qt
         Jqm556XTtjzlJ0wmp/lHWU/x6S53uYP4+VoXN6ThfSJOYiw1hMHi6aqP8sJ70BPRtU6t
         JK+w==
X-Gm-Message-State: AOJu0YycLH9alSV+pht85s+Oih8Xi38LA4e/SMuIKkiTqF+6bfLyjwG7
	eHuehAuUYVq8nQ5HYoC/hpF1uQqz8k9qrI7abtkcYy5bqFvstdvYWM3+iXfbYHJrYwYfqq4ccRH
	qI+IKh7CN+PSdtQJ/RRY7KgjnvDIz/g47jFRNxvBlBjoILSoOY5z02STJFW0=
X-Google-Smtp-Source: AGHT+IEDf0nQGzMdYSievxab4LdonUcapCapthDAeP9vmAtdEF10CYbL+moFlCOtQtu24B1/LYMWG8HpDKT99LUoHUHEYAucmiLi
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1521:b0:3e5:4e4f:65e6 with SMTP id
 e9e14a558f8ab-3e57ba4bbfcmr17250865ab.13.1755213772950; Thu, 14 Aug 2025
 16:22:52 -0700 (PDT)
Date: Thu, 14 Aug 2025 16:22:52 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <689e6fcc.050a0220.e29e5.0005.GAE@google.com>
Subject: [moderation/CI] Re: Error recovery for vfio-pci devices on s390x
From: syzbot ci <syzbot+ci747c86ae05ccc15e@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v1] Error recovery for vfio-pci devices on s390x
https://lore.kernel.org/all/20250813170821.1115-1-alifm@linux.ibm.com
* [PATCH v1 1/6] s390/pci: Restore airq unconditionally for the zPCI device
* [PATCH v1 2/6] s390/pci: Update the logic for detecting passthrough device
* [PATCH v1 3/6] s390/pci: Store PCI error information for passthrough devices
* [PATCH v1 4/6] vfio-pci/zdev: Setup a zpci memory region for error information
* [PATCH v1 5/6] vfio-pci/zdev: Perform platform specific function reset for zPCI
* [PATCH v1 6/6] vfio: Allow error notification and recovery for ISM device

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/381ee9ac-99e2-4fb3-beb8-13bdd21fbe9b

***

kernel build error

tree:      torvalds
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvalds/linux
base:      dfc0f6373094dd88e1eaf76c44f2ff01b65db851
arch:      amd64
compiler:  Debian clang version 20.1.7 (++20250616065708+6146a88f6049-1~exp1~20250616065826.132), Debian LLD 20.1.7
config:    https://ci.syzbot.org/builds/070067a8-b021-418d-b5b8-5fe961b07ad6/config

ld.lld: error: duplicate symbol: vfio_pci_zdev_reset

***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[alex.williamson@redhat.com alifm@linux.ibm.com kvm@vger.kernel.org linux-kernel@vger.kernel.org linux-s390@vger.kernel.org mjrosato@linux.ibm.com schnelle@linux.ibm.com]

If the report looks fine to you, reply with:
#syz upstream

