Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com [209.85.210.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DEBE56B857
	for <syzbot@lists.linux.dev>; Wed, 23 Sep 2026 19:43:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790192594; cv=none; b=VWNqrYXuL8bttkV/krHCFilTrEBLymD+OK/LReGq/E36annx7dcp+NME0OfFmV0BejQttYMfatxHf3WmYozz9XIJZi+GBHPOHI3FAOVUOUTMxi4razMq6hJTU3PtAzXZVjzTiTSh5EBSRkKAxUXUc2U7lgxWN5JZx3ECdl4WVBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790192594; c=relaxed/simple;
	bh=NGhKtDXvpc7V/7qI/grawgLuEF2axcQ64R3pNESHBNM=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=dX7rLIVoMy33zJ7Fy5gM7kkF5EGWV+Vj7UY91m1RG10pp64iQse52TbitVGbx8E5offXx9M/47mr9gyV6y2lGYYttByMqbJjuK88+sAPn9Z39lVlNvoTvLNQBALgqboteYXVcqfuRkAQkVkfg5PFpNKffhjZ5Ahq18qgI1Y2PrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.210.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f70.google.com with SMTP id 46e09a7af769-816cd7b7838so933276a34.2
        for <syzbot@lists.linux.dev>; Wed, 23 Sep 2026 12:43:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790192591; x=1790797391;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:date:mime-version:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=XFz9+xmfz3P+gZK6eEAiMnxq0YY4jqAmnHzTSCLe5zo=;
        b=PZp28VICHCEaWA+n8C3n0nENHejXZTiiBYOjAGhYH9mtLxoiL70t0/Jv4MglCX+nay
         UFqJS09+BpiPkn872gmUGyM0yMlgFIe8+0iSYbMgoM8UWbVSq8ziU2tHUbtdcgnXzMzp
         XrMKSZygX6gR9ZivogJVoNi/WiQrRfp9O7Md6e6ktEPJT11QtnCZ6HJAkC3cl5SrhW3s
         TaJs+JGzVCnYn4HHsDJPrQtbX/Nh8o5AT4PQyYaQZh9cJlXcKIhZAxg00ItU9iqwNPNY
         1gcjwV86hUR0SF0ji6Am7HoR75FaSaYLeCHtUT3Sj8vRR3LMwZNTwBasgatUBFj+V0mP
         G/xQ==
X-Gm-Message-State: AFuF++n7XF5adQo5FhMmBL5FQ0nmNCrbLI+B4bulhTEyiRlQbV7cmIpH
	zqDTmRqzLY1saE/YUGNIb1gaT7sgzDY1p4cIrFX0RElsG2G34f20EKN/oVkO3kPOwkwJbcXeesQ
	Sxrn759seMTKEudAl1+crV5INZZe5Z4/yCgIEELc+/IBCRS8dzAO1CHkE0Ls=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:6ae3:b0:6c9:80d8:a1e9 with SMTP id
 006d021491bc7-6d43fd7c524mr292156eaf.38.1790192591416; Wed, 23 Sep 2026
 12:43:11 -0700 (PDT)
Date: Wed, 23 Sep 2026 12:43:11 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6ab42bcf.e9f5c185.9abc8.0001.GAE@google.com>
Subject: [moderation/CI] Re: KVM: Use atomic SRCU for gfn-to-pfn cache,
 reinstate guest mode for x86 nesting
From: syzbot ci <syzbot+ciecc21ea4e87657c0@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v1] KVM: Use atomic SRCU for gfn-to-pfn cache, reinstate guest mode for x8=
6 nesting
https://lore.kernel.org/all/20260920211920.928306-1-dwmw2@infradead.org
* [PATCH 01/17] KVM: pfncache: Use atomic SRCU for readers instead of a rwl=
ock
* [PATCH 02/17] KVM: x86/xen: Extract delivery of event to vCPU into a sepa=
rate helper
* [PATCH 03/17] KVM: x86/xen: Explicitly tag "shared info" page as never be=
ing dirty tracked
* [PATCH 04/17] KVM: x86/xen: Don't dirty track "vCPU info" page
* [PATCH 05/17] KVM: x86: Request the guest TLB flush from record_steal_tim=
e()
* [PATCH 06/17] KVM: x86: Use gfn_to_pfn_cache for steal time / preempted s=
tatus
* [PATCH 07/17] KVM: pfncache: Add guest-mode pinning (GUEST_USES_PFN succe=
ssor)
* [PATCH 08/17] KVM: pfncache: Return -EAGAIN for a lookup which hits an in=
valid memslot
* [PATCH 09/17] KVM: x86: Post KVM_REQ_GET_NESTED_STATE_PAGES on memslot up=
dates
* [PATCH 10/17] KVM: nVMX: Implement cache for L1 MSR bitmap
* [PATCH 11/17] KVM: nVMX: Use pinned pfncache for L1 APIC virtualization p=
ages
* [PATCH 12/17] KVM: selftests: Add nested VMX APIC cache invalidation test
* [PATCH 13/17] KVM: x86: Move nested GPC lock helpers to x86.h as kvm_gpc_=
lock_page()
* [PATCH 14/17] KVM: nSVM: Use a gfn_to_pfn_cache for the vmcb12 page
* [PATCH 15/17] KVM: nSVM: Cache L1's MSR permissions map pages
* [PATCH 16/17] KVM: nSVM: Cache L1's IO permissions map pages
* [PATCH 17/17] KVM: selftests: Add nested transition benchmark

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/b30937af-ed9b-4623-9756-ab12f5e10d48

***

kernel build error

tree:      kvm-next
URL:       https://kernel.googlesource.com/pub/scm/virt/kvm/kvm/
base:      d4b7fb647204f0c81dfeae2d1a708e4d858e0c94
arch:      amd64
compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp=
1~20260613092250.77), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/9ea66f31-e98a-4e31-b4bf-071f60d487b=
9/config

./include/linux/srcu.h:640:7: error: call to undeclared function 'srcu_read=
_unlock_atomic'; ISO C99 and later do not support implicit function declara=
tions [-Wimplicit-function-declaration]
./include/linux/srcu.h:639:17: error: call to undeclared function 'srcu_rea=
d_lock_atomic'; ISO C99 and later do not support implicit function declarat=
ions [-Wimplicit-function-declaration]

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
[bigeasy@linutronix.de boqun.feng@gmail.com clrkwllms@kernel.org dmatlack@g=
oogle.com dwmw2@infradead.org dwmw@amazon.co.uk fgriffo@amazon.co.uk jgg@zi=
epe.ca jiangshanlai@gmail.com joelagnelf@nvidia.com josh@joshtriplett.org k=
alyazin@amazon.com keirf@google.com kunwu.chan@gmail.com kunwu.chan@linux.d=
ev kvm@vger.kernel.org linux-kernel@vger.kernel.org linux-kselftest@vger.ke=
rnel.org linux-rt-devel@lists.linux.dev mathieu.desnoyers@efficios.com mhoc=
ko@suse.com neeraj.upadhyay@kernel.org nh-open-source@amazon.com paul@xen.o=
rg paulmck@kernel.org pbonzini@redhat.com qiang.zhang@linux.dev rcu@vger.ke=
rnel.org rostedt@goodmis.org sashiko-bot@kernel.org seanjc@google.com stoll=
mc@amazon.com syzbot@syzkaller.appspotmail.com vkuznets@redhat.com]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

