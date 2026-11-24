Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.71
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795487304;
	b=2ZVAAGeOZlzJP3qegWpkK18OiDigusNBwKwo4Q/JF/az8Zd95DlwMokJ+IV/GsQDzYUS
	 YMlbMsKJrBpcMFe8r3AUNvjVgvZJK4AI3Rub+CbNEwieZ+cQCkM1FvaYPqAvBpFQE72Ix
	 OSn+w+22lFr3qjrNjC2UcNVHOATi8yK+kY79lNqcuGsYZpjEEJbEE/2siz0UvQjiZVLEX
	 o1E5eetBndHiJZMPNv3tJ3QjVAlq1k55az/VXc0DT10MC/RzBoDo4bx98iiQZYxWDMODn
	 T9KKHxDN+dvYDqbKVnWKw4o43z7gbYuCEOyAdT53Mj1b4Gz+IWpSKgE05JNcQaOrPbg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795487304;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 MIME-Version:X-Received:Date:X-Google-Appengine-App-Id:
	 X-Google-Appengine-App-Id-Alias:Message-ID:Subject:From:To:Cc:
	 Content-Type:Content-Transfer-Encoding;
	bh=daMli+na3AERw8DkKcmsotokxxrrM0kIOzAJ4BIAmIY=;
	b=t9IvZEZJGYX2C/Uan2vpx3ICuRKkRfz4r7vUgyfluLLETDRT/Y/SveVXh2AYvXbgmUgs
	 QzaWO6VYKh9ePdM1EHbdkrn45V1eYFRRoVS9ZHD84+2temiaynf6y/KvM4cbhimceWL29
	 0Eq5Pw4RW5OUAZnMCSRnlwmGYWD0AOCjfl8JdCVPXQIjx4jaGSS1n9qBrYsZntbYvAjZ0
	 cDs6jZYgCXDTtyzULI7i7FXPwgMmQWoz267TEB7v9QBLi37+9HijDH2IjefxuPf8K5t5u
	 wta3N9j8iZtXqEPjV+5OSip03InITba1nXa4ZLTwIdZImDcXQdFmiAqfMGTsYgy5dmw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=syzkaller.appspotmail.com;
	spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	arc=none smtp.remote-ip=209.85.210.71
Received: from mail-ot1-f71.google.com (mail-ot1-f71.google.com [209.85.210.71])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45E50606A31E
	for <syzbot@lists.linux.dev>; Tue, 24 Nov 2026 02:28:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 45E50606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f71.google.com with SMTP id 46e09a7af769-862a5ad18d0so4706548a34.3
        for <syzbot@lists.linux.dev>; Mon, 23 Nov 2026 18:28:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795487303; x=1796092103;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:date:mime-version:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=daMli+na3AERw8DkKcmsotokxxrrM0kIOzAJ4BIAmIY=;
        b=ld9DDzJFAzQKYLVv1EQnhcgai5qEvQiql18XgdcEwVrBGc56SDf/4YeD2vJ+YK1Dz6
         WTaA52RR7H7PdaDd6hP5f7mYTCXQ9xLWmmMrqstcYmR/VxnqM9YANsMqYts6EeaOp/ek
         UaT2rDrdAcqUuT9LBNYkmnSuhWdDHU2ylLQMGWkTPjiemHJTBnwL2fPtGSFn+f/M8d3i
         JqQGwpE10TwgwcsS79Nr2UPNYNQz9K8fQUhREap/PfoQCXWywCt4Ob43ft5KKKtlbNMz
         wYJvzDs5tcP0HU5peak9BQC2OH5y/Po90xl+UE8/iF0MeLYD8Ev60Na3Vi8vlS50kvg9
         V6Gw==
X-Gm-Message-State: APuU4Z+eq2/ykiK40AP7v3A5VJ6q9e3jcPXQNWfbKTTN2roYIv5IVYBd
	tRRqQT+6uK4+6mXI8m1FkQaaATi/9IhV1gBOsDXDVm07+WApbmEFr5FOOXhKywHgQV8cEAZnD+T
	WdSdYU9qidtwscPhmUwTP1WcQRFRxgIgQcp4qYK8Ljc77imjLi6lJxbUjK0A=
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Post: <mailto:syzbot@lists.linux.dev>
List-Help: <mailto:syzbot+help@lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
List-Owner: <mailto:syzbot+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-Received: by 2002:a05:6808:3502:b0:4ec:77df:f4b1 with SMTP id
 5614622812f47-57a09e0c7f1mr15736469b6e.25.1795487303385; Mon, 23 Nov 2026
 18:28:23 -0800 (PST)
Date: Mon, 23 Nov 2026 18:28:23 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6b04f647.44b41460.34b83f.0038.GAE@google.com>
Subject: [moderation/CI] Re: mm/huge_memory: copy PMDs at fork like the PTE
 path does
From: syzbot ci <syzbot+ci8a78565f4200c734@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v6] mm/huge_memory: copy PMDs at fork like the PTE path does
https://lore.kernel.org/all/20261119-b4-prep-vstor-149847-copy_huge_pmd-rec=
heck-special-pmd-v6-0-efa7817a2bb3@virtuozzo.com
* [PATCH v6 1/4] mm/rmap: duplicate a PMD mapping as one in folio_dup_file_=
rmap_pmd()
* [PATCH v6 2/4] mm/huge_memory: copy file THPs at fork like copy_present_p=
tes() does
* [PATCH v6 3/4] mm/huge_memory: read a special PMD under the lock in copy_=
huge_pmd()
* [PATCH v6 4/4] selftests/mm: test fork of PMD-mapped shmem THPs

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/3d54bacd-d9c6-4667-b9cb-90bc93043559

***

kernel build error

tree:      kvm-x86
URL:       https://github.com/kvm-x86/linux.git
base:      cbe54fc3462b3949ab27b9ae81fb9ddb509040c7
arch:      amd64
compiler:  Debian clang version 22.1.8 (1~deb13u4), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/3530314e-3b31-47a0-af62-2f7aa3ad985=
e/config

mm/huge_memory.c:2012:16: error: call to undeclared function 'folio_ref_cou=
nt_over_limit'; ISO C99 and later do not support implicit function declarat=
ions [-Wimplicit-function-declaration]

***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[akpm@linux-foundation.org alex@shazbot.org azpijr@gmail.com baohua@kernel.=
org baolin.wang@linux.alibaba.com david@kernel.org dev.jain@arm.com dri-dev=
el@lists.freedesktop.org jgg@ziepe.ca kas@kernel.org khorenko@virtuozzo.com=
 kvm@vger.kernel.org lance.yang@linux.dev liam@infradead.org linux-kernel@v=
ger.kernel.org linux-kselftest@vger.kernel.org linux-mm@kvack.org linuxppc-=
dev@lists.ozlabs.org ljs@kernel.org loic.molinari@collabora.com maddy@linux=
.ibm.com nico.pache@linux.dev peterx@redhat.com ritesh.list@gmail.com ryan.=
roberts@arm.com sashiko-bot@kernel.org shuah@kernel.org stable@vger.kernel.=
org usama.arif@linux.dev ziy@nvidia.com]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

