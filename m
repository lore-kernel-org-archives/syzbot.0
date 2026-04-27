Received: from mail-oo1-f69.google.com (mail-oo1-f69.google.com [209.85.161.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1AD83CBE75
	for <syzbot@lists.linux.dev>; Mon, 27 Apr 2026 12:47:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777294028; cv=none; b=d1hZuxvr7k0MZ8YRclE7pLThqKPy1O7U/IVSGG4mvV73fyzn9cn/N+tHtiiTjF5AfFXPdnPYOki5jGmyhlhF/iyNsx37Nwntw/V/rtO135osZ1YHJlhcDXz86xpJJQMByzblHAnvfoX+glRqnXAENpbVKK9U7LsgJ43MsRiIpqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777294028; c=relaxed/simple;
	bh=F54yBpEWvaqb9v2oAnncucqiCLrTG9tgjyiUEFVsr/c=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=rEYpg9kPIf0QWLAc7x4X67yYe614YgTHTn1Q1zWT361slMKVdmPYXwjpabl0Cmw4mZ2elAiOWpXXDu1YFcqQl2DQptgZ/BqVnMSgf7RX5i4RJMUhy6oSXTqOlQATrn/D/hcEQN5dF4n20RFTocEdrLqGodeUoxQnSTCAFGoap/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f69.google.com with SMTP id 006d021491bc7-696266291d6so2800389eaf.1
        for <syzbot@lists.linux.dev>; Mon, 27 Apr 2026 05:47:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777294026; x=1777898826;
        h=cc:to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DeioKSKnwBgVJU5IpZtuf34JfPU2bIkTaRsDEIqsje8=;
        b=nexkkIJ1nPUxHHcJNVYr1sq677xYnpCTxH/r07j9JrWDOpc2Nyo7dXSi2ETwLSSarx
         WJKXZw41fnWyW9tm0DZdwpYBvuzlxgypMMVGTtCv25cEEdFhGM1spxlFi8+ayh0a5Je+
         8Ax1zozj/yyKA6erL0ysfR4JPOgVCj05931xGM5RgYXblMOZQLA95oqpBRzjIilEs63x
         2vTiSkwPlWKprfLNw2n4f80lowyny+ilrtnto1ZmKUgZHzp6xDPzCwme+1oJZEUcddkC
         IAQ0RHvNyszXgh3M46jpFyV1kJk+DlFf0vN4MXEgQfhoMDP5UIOuelzIxGgC8qCZMItV
         lnZA==
X-Gm-Message-State: AOJu0YzxAeICvsbYmU7wJBKJ0MQZHB9PODZkGYp+dDprdp3j5iDhoX7D
	HXIoQAlyvd6NMcJoAV8i3AdsoB8l9i0XcduMPl4LLr7ddhckiYVfyV2cOjxU3ufDA25AXizhta1
	KWL/4Pv7qeZ82rCQ8phRAcz7UEhbAtqxUHnt3ZEIcHqkdz0EhHzexhO07JaY=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:1907:b0:680:1c3b:7cc8 with SMTP id
 006d021491bc7-69462f0aee4mr24848387eaf.39.1777294025857; Mon, 27 Apr 2026
 05:47:05 -0700 (PDT)
Date: Mon, 27 Apr 2026 05:47:05 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69ef5ac9.170a0220.11de9.001e.GAE@google.com>
Subject: [moderation/CI] Re: KVM: VMX/SVM: use the same SPEC_CTRL assembly code
From: syzbot ci <syzbot+ci4d0ea0497ee92158@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v2] KVM: VMX/SVM: use the same SPEC_CTRL assembly code
https://lore.kernel.org/all/20260427105848.44865-1-pbonzini@redhat.com
* [PATCH v2 1/7] KVM: VMX: remove regs argument of __vmx_vcpu_run
* [PATCH v2 2/7] KVM: VMX: more cleanups to __vmx_vcpu_run
* [PATCH v2 3/7] KVM: SVM: prepare for making SPEC_CTRL switch common with VMX
* [PATCH v2 4/7] KVM: SVM: adopt the same VMX_RUN_* flags as VMX
* [PATCH v2 5/7] KVM: SVM: extract RESTORE_*_SPEC_CTRL_BODY out of svm/vmenter.S
* [PATCH v2 6/7] KVM: VMX: switch to RESTORE_GUEST_SPEC_CTRL_BODY
* [PATCH v2 7/7] KVM: VMX: replace vmx_spec_ctrl_restore_host with RESTORE_HOST_SPEC_CTRL_BODY

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/e48d8401-7303-4f81-804f-a93c02c9505c

***

kernel build error

tree:      torvalds
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvalds/linux
base:      254f49634ee16a731174d2ae34bc50bd5f45e731
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/2410fecc-1fe5-4aba-8811-67a29d852242/config

arch/x86/kvm/svm/svm.c:4420:29: error: incompatible pointer types passing 'struct vcpu_svm *' to parameter of type 'struct kvm_vcpu *' [-Werror,-Wincompatible-pointer-types]

***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

To test a patch for this bug, please reply with `#syz test`
(should be on a separate line).

The patch should be attached to the email.
Note: arguments like custom git repos and branches are not supported.

The email will later be sent to:
[binbin.wu@linux.intel.com chang.seok.bae@intel.com kvm@vger.kernel.org linux-kernel@vger.kernel.org pbonzini@redhat.com seanjc@google.com ubizjak@gmail.com]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

