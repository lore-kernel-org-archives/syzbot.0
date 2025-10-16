Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FB0A229B12
	for <syzbot@lists.linux.dev>; Thu, 16 Oct 2025 21:03:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760648585; cv=none; b=mMtzGNFovdIGIdP5qbRMG4rOE3ujpxfouTGe8VuHyoFf/aTAdm6yOSDuMbkQNK2jjAnaYOGwPVSsnIMMGnChWtTUH+/r+C7rp/dpnpiH7FNu+FsJQIllBZO9224+fP/pdxOn5XmKbLipKUb4vydDQJVetm2ZVk+P6zuz8DcANi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760648585; c=relaxed/simple;
	bh=FhGrJyOs/+e4ezAcxUnyvWl2DSRDdqZ+yxxSCOwNKCw=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=Lj3Awj+KiKvhRO0xIXDnTWKso1Dl71+t9usC25oQubQleUHtvfB1lg9NXEghndFFWt8NAuVDPEoU97kjuouK8OfI3n+/y2URVa37OXhkB3pSLx0tv6aw1yYjDFnqFFiKz8HS/sdVsQxEWYBTITmfcMFEWNSe0dH5EmXJu7ZQe2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-430c523ce49so7799805ab.2
        for <syzbot@lists.linux.dev>; Thu, 16 Oct 2025 14:03:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760648583; x=1761253383;
        h=cc:to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DloZ6obhCoCBRhyYtC77CGcZ9YHxyMbTMoFqqclFo1Q=;
        b=NSjddChXIV7r9TYd0ZuNQ+s7acd7TE2RXgCBFbD2XhLlF7pzXzSyc6J+4UV3H6+Bfw
         l/j/oLyx68OclGJ6jfYljB7ezoOqAmuYH97HqIkOYr6iJcn/DkTlnalqVn4puf/26M4i
         JR8gn/kG6L4ioXMBJ3JPZ9AUSCNeul9CdRKDDFFhk2h95ie9WQ4/VWI2AKOYauqPdp6E
         uRdvd/IhmBbIONNPIIOkHmnovlUJJ6t3olkcsZHnreUWxMlXx8Jg55O87qof67w9+97S
         cBFjqa3M45G144t1skE6JQUacrlQcCBTsoY/ALmlpjRBEgShDtlEJCa2es5bfTITkBsX
         GQwA==
X-Gm-Message-State: AOJu0YyziKKFn/A5jZLAea19zXh8dkEYBENoC7DynSc6MRu3pBo8xOXE
	gqnGwZ18eylAYjl9bWIk4/pudbsG0V/HKcN4aTDoycYfmEkeZ7kO4phAFFCKPKhg2VGLcE7/37l
	Kh+fORODSiAIami/adMBBxWyxymM4vOYGycX45+LxSnsiDOo3Vg1kyGvjles=
X-Google-Smtp-Source: AGHT+IFdvnSfeZaWqTrWCE2TnxOZN+mrRYnWzYpl4qkJTSaIX+96T1qjxYtDOY+d6h7q2tmDRFykVfBIWfGzyXf4Qs26C+GsdNkr
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1745:b0:42f:91aa:510b with SMTP id
 e9e14a558f8ab-430c51eac3dmr23411525ab.4.1760648583084; Thu, 16 Oct 2025
 14:03:03 -0700 (PDT)
Date: Thu, 16 Oct 2025 14:03:03 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68f15d87.050a0220.91a22.0412.GAE@google.com>
Subject: [moderation/CI] Re: KVM: VMX: Unify L1D flush for L1TF
From: syzbot ci <syzbot+cidcbd3ba62d4d6738@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v3] KVM: VMX: Unify L1D flush for L1TF
https://lore.kernel.org/all/20251016200417.97003-1-seanjc@google.com
* [PATCH v3 1/4] KVM: VMX: Flush CPU buffers as needed if L1D cache flush is skipped
* [PATCH v3 2/4] KVM: VMX: Bundle all L1 data cache flush mitigation code together
* [PATCH v3 3/4] KVM: VMX: Disable L1TF L1 data cache flush if CONFIG_CPU_MITIGATIONS=n
* [PATCH v3 4/4] KVM: x86: Unify L1TF flushing under per-CPU variable

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/896ab447-a77c-4f92-9f4d-c9a2b181a369

***

kernel build error

tree:      linux-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/next/linux-next
base:      1fdbb3ff1233e204e26f9f6821ae9c125a055229
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/de03686e-4a5c-4654-81c3-18166a3dec18/config

arch/x86/kvm/vmx/vmx.c:313:29: error: too many arguments to function call, expected 0, have 1
arch/x86/kvm/vmx/vmx.c:406:4: error: non-void function 'vmx_l1d_flush' should return a value [-Wreturn-mismatch]

***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[jackmanb@google.com kvm@vger.kernel.org linux-kernel@vger.kernel.org pawan.kumar.gupta@linux.intel.com pbonzini@redhat.com seanjc@google.com]

If the report looks fine to you, reply with:
#syz upstream

