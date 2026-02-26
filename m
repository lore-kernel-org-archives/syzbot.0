Received: from mail-oo1-f69.google.com (mail-oo1-f69.google.com [209.85.161.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66F2F428475
	for <syzbot@lists.linux.dev>; Thu, 26 Feb 2026 16:53:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772124792; cv=none; b=KyDATbS9qxNJcANzgGqi9ehtt5WO6GJdsmIjuO6VCD58aq0zFCcUGyr0weHxTnQOf2AhTn7hOzk1U7MI4LaSevU0pqImPfn3UkGlbYhbhVQ8spJFZv8/jWj4yH8qzYuwX0BW7k1aB4Pr3QSFiSYdDT9EO3ndKtibyy7dvfbtNsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772124792; c=relaxed/simple;
	bh=sjcggyY/Wg32FPKDiF0u8ZbE+FgLveGqD1GCA47aquY=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=PYFbQO6b7+toLtDKIFjrmPx30Z9oh0LMP+4ol11Sx4eFA1o7qO+4wjJhoVvLa1OcGnZwx3kUhElN3HTTKcKI3kdVROcuYfz2e99tFmg/aeJFs7hF2BtIGcAFX0X+sTCmb9CViuZ/Mnh80xcff+GzB2mm4RdWU89PnROV95RSxzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f69.google.com with SMTP id 006d021491bc7-679dcff168dso9040142eaf.3
        for <syzbot@lists.linux.dev>; Thu, 26 Feb 2026 08:53:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772124790; x=1772729590;
        h=cc:to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=l7OIHIIVcFolVSIBjGWpqWMgSsJqxa0zxTpPY/7rZ4o=;
        b=EYITEi2kdKkl6cc7nxjJoT/59wi3tcyZXOb5iY+7OZoCD3oU8nqy2yzqw4F7fJJ8bX
         EXoZ8zEY9j7AxdKLjUzV228ysbj5bB4LYWLG17SciEOU+0KrV1dDTZzfZp8dbSCGGpHQ
         lXJweNKKwS+lGOmIqLjEAIYOSjisJSd+l9yWtXEy72LlRNnFX63Ba5fDzpmcQL0KYMeQ
         JhAn7gJQ13/WF4cThd1VjggGcnci1jvTk3JEZiAlBna78gwDNphtqMi6+2lnmpfBpWWr
         ga8TmYXF7AIWQVTpDTOiD9cpnuRB+mM5VI7QmBChPyhI039v57ze9Aw2Qz8/lKK5RADB
         h5sg==
X-Gm-Message-State: AOJu0YzIZ8szoVTNhMWmfHQdv7c02CY27IjWXFj3y+gHh3BBG3f67Nag
	mEEuQ072WeTdQjxVPZe+/WIdQaSDvSdfCewoy2x6Y/m2y/BqwdA4zGTZ7gkY5wcjibpPoQRRm0c
	G0qSr5xleBlZ5F4rXUT3/DgYYPaIcuxHpHYl10ooTUUk0sAaSfqMT6VXtnrE=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:f03:b0:663:c5:2f93 with SMTP id
 006d021491bc7-679ef7faea6mr2346406eaf.14.1772124790342; Thu, 26 Feb 2026
 08:53:10 -0800 (PST)
Date: Thu, 26 Feb 2026 08:53:10 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69a07a76.050a0220.3a55be.0005.GAE@google.com>
Subject: [moderation/CI] Re: ipmr: No RTNL for RTNL_FAMILY_IPMR rtnetlink.
From: syzbot ci <syzbot+ci1ead13f60be6c868@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v1] ipmr: No RTNL for RTNL_FAMILY_IPMR rtnetlink.
https://lore.kernel.org/all/20260226023637.1335854-1-kuniyu@google.com
* [PATCH v1 net-next 01/15] selftest: net: Add basic functionality tests for ipmr.
* [PATCH v1 net-next 02/15] ipmr: Annotate access to mrt->mroute_do_{pim,assert,wrvifwhole}.
* [PATCH v1 net-next 03/15] ipmr: Convert ipmr_rtm_dumplink() to RCU.
* [PATCH v1 net-next 04/15] ipmr: Use MAXVIFS in mroute_msgsize().
* [PATCH v1 net-next 05/15] ipmr: Convert ipmr_rtm_getroute() to RCU.
* [PATCH v1 net-next 06/15] ipmr: Convert ipmr_rtm_dumproute() to RCU.
* [PATCH v1 net-next 07/15] ipmr: Move unregister_netdevice_many() out of mroute_clean_tables().
* [PATCH v1 net-next 08/15] ipmr: Move unregister_netdevice_many() out of ipmr_free_table().
* [PATCH v1 net-next 09/15] ipmr: Convert ipmr_net_exit_batch() to ->exit_rtnl().
* [PATCH v1 net-next 10/15] ipmr: Remove RTNL in ipmr_rules_init() and ipmr_net_init().
* [PATCH v1 net-next 11/15] ipmr: Call fib_rules_unregister() without RTNL.
* [PATCH v1 net-next 12/15] ipmr: Define net->ipv4.{ipmr_notifier_ops,ipmr_seq} under CONFIG_IP_MROUTE.
* [PATCH v1 net-next 13/15] ipmr/ip6mr: Convert net->ipv[46].ipmr_seq to atomic_t.
* [PATCH v1 net-next 14/15] ipmr: Add dedicated mutex for mrt->{mfc_hash,mfc_cache_list}.
* [PATCH v1 net-next 15/15] ipmr: Don't hold RTNL for ipmr_rtm_route().

and found the following issue:
WARNING in ipmr_free_table

Full report is available here:
https://ci.syzbot.org/series/d7068eba-72b1-4110-aeb0-d4528e03fd24

***

WARNING in ipmr_free_table

tree:      net-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netdev/net-next.git
base:      c7f5c6fb0f2b1a44490a36582a251f0a304d6b0c
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/0afa280b-14ff-4aec-8a20-7f8507025dd8/config
C repro:   https://ci.syzbot.org/findings/e38687c7-5a8b-4c68-909c-a0ffdd17a674/c_repro
syz repro: https://ci.syzbot.org/findings/e38687c7-5a8b-4c68-909c-a0ffdd17a674/syz_repro

------------[ cut here ]------------
!net_initialized(net) && !list_empty(dev_kill_list)
WARNING: net/ipv4/ipmr.c:450 at ipmr_free_table+0x150/0x180 net/ipv4/ipmr.c:450, CPU#1: syz.1.18/6004
Modules linked in:
CPU: 1 UID: 0 PID: 6004 Comm: syz.1.18 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:ipmr_free_table+0x150/0x180 net/ipv4/ipmr.c:450
Code: 23 e8 f4 5c 95 f7 5b 41 5c 41 5d 41 5e 41 5f 5d c3 cc cc cc cc cc e8 df 5c 95 f7 90 0f 0b 90 e9 64 ff ff ff e8 d1 5c 95 f7 90 <0f> 0b 90 eb d7 44 89 e1 80 e1 07 80 c1 03 38 c1 0f 8c 03 ff ff ff
RSP: 0018:ffffc900037afa70 EFLAGS: 00010293
RAX: ffffffff8a302fbf RBX: ffffc900037afb60 RCX: ffff888172a70000
RDX: 0000000000000000 RSI: ffffffff8def033c RDI: ffffffff8c27a480
RBP: 0000000000000001 R08: ffffffff901166b7 R09: 1ffffffff2022cd6
R10: dffffc0000000000 R11: fffffbfff2022cd7 R12: ffff88816a392758
R13: dffffc0000000000 R14: ffff8881b8960000 R15: ffff88816a392758
FS:  00007f5a2d24e6c0(0000) GS:ffff8882a9469000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f7b7544e9d3 CR3: 0000000172316000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 ipmr_rules_exit_rtnl net/ipv4/ipmr.c:297 [inline]
 ipmr_net_exit_rtnl+0x156/0x1a0 net/ipv4/ipmr.c:3339
 ops_exit_rtnl_list net/core/net_namespace.c:181 [inline]
 ops_undo_list+0x347/0x940 net/core/net_namespace.c:248
 setup_net+0x2f0/0x340 net/core/net_namespace.c:462
 copy_net_ns+0x50e/0x730 net/core/net_namespace.c:581
 create_new_namespaces+0x3e7/0x6a0 kernel/nsproxy.c:130
 unshare_nsproxy_namespaces+0x11a/0x160 kernel/nsproxy.c:226
 ksys_unshare+0x4f4/0x900 kernel/fork.c:3174
 __do_sys_unshare kernel/fork.c:3245 [inline]
 __se_sys_unshare kernel/fork.c:3243 [inline]
 __x64_sys_unshare+0x38/0x50 kernel/fork.c:3243
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f5a2c39c629
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f5a2d24e028 EFLAGS: 00000246 ORIG_RAX: 0000000000000110
RAX: ffffffffffffffda RBX: 00007f5a2c615fa0 RCX: 00007f5a2c39c629
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 000000006a040000
RBP: 00007f5a2c432b39 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f5a2c616038 R14: 00007f5a2c615fa0 R15: 00007fffb0e41968
 </TASK>


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[davem@davemloft.net dsahern@kernel.org edumazet@google.com horms@kernel.org kuba@kernel.org kuni1840@gmail.com kuniyu@google.com netdev@vger.kernel.org pabeni@redhat.com]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

