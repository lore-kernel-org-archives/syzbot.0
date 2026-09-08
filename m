Received: from mail-oo2-f42.google.com (mail-oo2-f42.google.com [74.125.231.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4069A3AB496
	for <syzbot@lists.linux.dev>; Tue,  8 Sep 2026 08:09:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.231.170
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788854974; cv=pass; b=m0aTbNW2EZArmJeJnM70sfFZRUi3856mhgmUdULXDuDmTXb2EOUfnbFAmJrjo0QELjwbHSd/VYdPkT8E25PVUnlNaAjc161FhpPROROClg4yTTjJcEQ+i4VL1snbDA8G40Rs5HXwN+Taf7fdj1ShXy+6F6a2qb4mYSCT711XBDY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788854974; c=relaxed/simple;
	bh=imZ6MqbLK2Ex6ePTcrNKyERk+5kJ5DGb5NO1voSkQjw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=iPGUTFGCs5jLncrblcX0BQ2VSFJO9myoUEpMdPTsqWiyuVuZ7Ptx4bjR670aw9sGTsKorI8BrsyG1nSy0j8h0JNMeXD8+YJGLp8FWq29bWO1PF2n3l9P+Wi6fd5LjV7KfQIjUty3XiVL61m4bEnEQwqLcHe4Ly3wRseCwAxWW1Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=SNbJsc1P; arc=pass smtp.client-ip=74.125.231.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="SNbJsc1P"
Received: by mail-oo2-f42.google.com with SMTP id 46e09a7af769-7f4f1354076so191000a34.1
        for <syzbot@lists.linux.dev>; Tue, 08 Sep 2026 01:09:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788854971; cv=none;
        d=google.com; s=arc-20260327;
        b=qzTwBHNQpHT7tQU8gxQ+2nv+FExxBqWMdPiLogQikKHnqRij0/SxG+jR7/mQ9+DRgj
         Lf1pl2bXRWMaf9g2CI7jwyGIl4WsPkajd+X232lX2fkTRKIs7N7CAy0hV8dtT7p53wU5
         EkcANLeZr4GmTMhqtEignpNIyLTU+smrj6avjv+jqkjfavxnkl08wiN0KezxENWyRwEW
         N1TiMMlBkXAyLsKweSCSBSRUdKqEvnOoAscAZn7gLQoXlp7NtjsLqezhARMtYGN2UXBC
         7j5fjVKW2ruGcd5o4psK+OLmPTbTyMC92orlaLc8bhDNoOaBjVTkBlZxn0DFP3c4uSq9
         363w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=uKtUr6DtFPsF52TtLQ71Spqz9Kc1hn/dG/viPwiwYkQ=;
        fh=cJ3vPs4yaIHF2rxTpVmSaH6vMlHWzCpVWIyyA5KZ86Q=;
        b=PmOPJO3+A54ogej4J37BPk/OcTI22JHRkBTDtkJEWGsRrAF3i0/5obiTfZbP6lARm8
         FL5p5DxgSSrb5nIcS48ovB0yhreYXuthMk1AMbEN0JZlU3/YWyrN4TlWMAfPNoqpGKm5
         /FQ1xAa3O81FDZlX1id3GUxRmJV8bToUH6cEil4rYb/zSBuf0vxrxdT6qkxEt5ivKkoc
         a02PTz+C4DUN7+cd7smk+JB7i93jB0VzQtjEKPZLPCSlOakJ/blA8+kqUv6xboYVGOoe
         wW59eOdjQN3gwnt6GidfmhxdVkHIYtlvQOYiJKdPU7GR5qn8yAJt4AwQKAaI0zfo/bEG
         sfYg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788854971; x=1789459771; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=uKtUr6DtFPsF52TtLQ71Spqz9Kc1hn/dG/viPwiwYkQ=;
        b=SNbJsc1PrHZampRUk6LKyCnqSOM6xDnDyOzrpNsVXkodTNWaelRpXgIS+it7CSLyDG
         +hKpa/XYwSeiZQEV76xhSVq7tgRZDqiyAClO90WuWsir0lBh7hMLpzvJWxREhUwyfne1
         AspvbMfv8IoAJnkErqsQWxuJtUw+oOGcDnMLbPJCdhv1N+cN4rQBnBvjk3Yy+Tg+rLik
         AcpVpxsZ7o6Q/3WsufjCfIlxj30mIaerVSxy97cS5ubq81HoUS7E9uHR8fVPpJQL+cXU
         HcG5f7Mk+EDIj9M3mWKHmbluhIry+h6qagjM5uRN4/3gWXQohdQTfwu3P3hlUf23oXTU
         ypnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788854971; x=1789459771;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=uKtUr6DtFPsF52TtLQ71Spqz9Kc1hn/dG/viPwiwYkQ=;
        b=B8kjO1fja2iq1uiX6Q8mxx/zvriKCyJzIPIGSrPYc+1+rrAJ0OG82nebc/Do67uGZZ
         fhxZN2p2n7jsuBhmhU6iUQimuXgpyFolL4wt7k82L8D82cKJU9YNMwdRgo4iy+Fctzwa
         QNp/EAOOwNnr8rdR5kfyKbG6lHMgGXfMRF944G5AhyQgbA2EGTaTLnpO4YfR45/TASEU
         RuXHmhX5dLrVbZNjqyDaI3oin4/h78ZgKIuCE32H3Lu/iKSsQSbL8maXL7kKzLSSD8b9
         mzxXjf1rsMCNktA/VFUFAiQT3ylsqd1fe4zkJxqzJsX6bqzbZN0xChEa4/vsCArqBf/v
         RPsg==
X-Forwarded-Encrypted: i=1; AKwUvBwIJT6sCbJA9zjUZ0ICFY99akyQdz5b38NC0P0xSFEOjrzBX4bZeegOioXw7Inb1/e6lGq8Zuw=@lists.linux.dev
X-Gm-Message-State: AFuF++m3cahTYSAJ3XVgyglaAhO2EY98G86wPTaXR65m6DgXdUMNzdIG
	2elAAnDW1YuZFedNuUIozxBHPZszmJWv0bakGpvmJEIgT7QCr4YOEqyWtxAIXV22Cc4pusEm4D0
	US87VK379neIw/n4Dm/DgWRa74k+6fOFpXBAMG0gq
X-Gm-Gg: AYBFou37dMGq8OPIeMZLsqbellvf1VvUSPLMLAsGpTs0usvZO7Lvgg2NuQq1qFox87B
	P/JyxiUjbZov1MN4K+XI0GH1RkhGANbNWrJWfypAA4SSCKMvOk/nXZU+8gSkUwGtfe7BJuHyJRu
	jT4E2MzEIWcTASkGgaXuSx1W/zIjBdNGPdiP5bwItxAUn1WFufQrnBM29KmiShZ+9YbL6wY1C2f
	uahgu6tn1XgL4Awe+F1i6XvX6BdORPpTcwGO7ZlwjxTCGsPCIF56pw1m6F77sU8vzQvvshzFUcs
	iek6zmi+7hJu6GGR9U5OwvAtdYqYGn0gltQfDvLuzOj0iLaHEyfH85RUwM9ynpo77uQMKlyjNd+
	5dZ8GyZSN8FBTOBclBnz0j5kBiZgXhO8/x/YEqK/Lw9Ox64R4hi4qj7Jz3VxKyS+3NE89NPd+dO
	fY+ZoDiynhkPGd
X-Received: by 2002:a05:6820:997:b0:6a1:8132:cb27 with SMTP id
 006d021491bc7-6bc2515e98amr1610518eaf.9.1788854970234; Tue, 08 Sep 2026
 01:09:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <6a9faf76.f614420e.2bf292.0008.GAE@google.com>
In-Reply-To: <6a9faf76.f614420e.2bf292.0008.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Tue, 8 Sep 2026 10:09:15 +0200
X-Gm-Features: AcwNN1W92XkYdnApwvjVJSHu1u-12LL5V3cgHramD8ZLGhhJcK6QKnqsL4fcynw
Message-ID: <CANp29Y4oKzx9DeqGK7jTkFYHUQeyVUDdXQsgepyNTBuZqsndsQ@mail.gmail.com>
Subject: Re: [moderation/CI] Re: rxrpc: Fix use-after-free in rxrpc_destroy_all_peers()
To: syzbot ci <syzbot+cib496eea2de0fa8bf@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Tue, Sep 8, 2026 at 8:47=E2=80=AFAM syzbot ci
<syzbot+cib496eea2de0fa8bf@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v2] rxrpc: Fix use-after-free in rxrpc_destroy_all_peers()
> https://lore.kernel.org/all/20260907222242.3361174-2-elver@google.com
> * [PATCH v2] rxrpc: Fix use-after-free in rxrpc_destroy_all_peers()
>
> and found the following issue:
> INFO: task hung in rxrpc_destroy_all_calls
>
> Full report is available here:
> https://ci.syzbot.org/series/72f7714d-3fb8-4e04-aa6f-2891301ed056
>
> ***
>
> INFO: task hung in rxrpc_destroy_all_calls
>
> tree:      net-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netde=
v/net-next.git
> base:      31f961de2f90fbf52eb2d4e15b3eeaa09f9b4fc2
> arch:      amd64
> compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~e=
xp1~20260613092250.77), Debian LLD 22.1.8
> config:    https://ci.syzbot.org/builds/6dafa5c2-5fb1-49b9-b4e5-8877f26c5=
afd/config
> syz repro: https://ci.syzbot.org/findings/4eb5795c-f73d-43ee-b3df-3291d86=
44727/syz_repro
>
> INFO: task kworker/u8:2:5453 blocked for more than 143 seconds.
>       Not tainted syzkaller #0
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> task:kworker/u8:2    state:D stack:26848 pid:5453  tgid:5453  ppid:2     =
 task_flags:0x4208060 flags:0x00080000
> Workqueue: netns cleanup_net
> Call Trace:
>  <TASK>
>  context_switch kernel/sched/core.c:5520 [inline]
>  __schedule+0x17db/0x58f0 kernel/sched/core.c:7270
>  __schedule_loop kernel/sched/core.c:7347 [inline]
>  schedule+0x164/0x2b0 kernel/sched/core.c:7362
>  rxrpc_destroy_all_calls+0x43d/0x560 net/rxrpc/call_object.c:756
>  rxrpc_pre_exit_net+0x6f/0x90 net/rxrpc/net_ns.c:109
>  ops_pre_exit_list net/core/net_namespace.c:161 [inline]
>  ops_undo_list+0x17d/0x8d0 net/core/net_namespace.c:235
>  cleanup_net+0x572/0x810 net/core/net_namespace.c:706
>  process_one_work kernel/workqueue.c:3396 [inline]
>  process_scheduled_works+0xc3d/0x1630 kernel/workqueue.c:3479
>  worker_thread+0xa47/0xfb0 kernel/workqueue.c:3560
>  kthread+0x38b/0x480 kernel/kthread.c:436
>  ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
>  </TASK>
>
> Showing all locks held in the system:
> locks held by kworker/u8:1/13: 4, last CPU#0:
>  #0: ffff888177a23940 ((wq_completion)bat_events){+.+.}-{0:0}, at: rcu_lo=
ck_acquire include/linux/rcupdate.h:309 [inline]
>  #0: ffff888177a23940 ((wq_completion)bat_events){+.+.}-{0:0}, at: rcu_re=
ad_lock include/linux/rcupdate.h:849 [inline]
>  #0: ffff888177a23940 ((wq_completion)bat_events){+.+.}-{0:0}, at: proces=
s_one_work kernel/workqueue.c:3361 [inline]
>  #0: ffff888177a23940 ((wq_completion)bat_events){+.+.}-{0:0}, at: proces=
s_scheduled_works+0x97a/0x1630 kernel/workqueue.c:3479
>  #1: ffff88823c624408 (psi_seq){-.-.}-{0:0}, at: psi_task_switch+0x57/0x7=
d0 kernel/sched/psi.c:933
>  #2: ffff88823c626118 (&base->lock){-.-.}-{2:2}, at: __mod_timer+0x904/0x=
ed0 kernel/time/timer.c:1117
>  #3: ffffffff9abf4d30 (&obj_hash[i].lock){-.-.}-{2:2}, at: debug_object_a=
ctivate+0xb7/0x420 lib/debugobjects.c:873
> locks held by pr/ttyS0/16: 2, last CPU#0:
>  #0: ffffffff8ec362b8 (console_srcu){....}-{0:0}, at: rcu_try_lock_acquir=
e include/linux/rcupdate.h:314 [inline]
>  #0: ffffffff8ec362b8 (console_srcu){....}-{0:0}, at: srcu_read_lock_nmis=
afe include/linux/srcu.h:439 [inline]
>  #0: ffffffff8ec362b8 (console_srcu){....}-{0:0}, at: console_srcu_read_l=
ock+0x30/0x60 kernel/printk/printk.c:291
>  #1: ffffffff9ad32098 (&port_lock_key){-.-.}-{3:3}, at: __uart_port_lock_=
irqsave include/linux/serial_core.h:613 [inline]
>  #1: ffffffff9ad32098 (&port_lock_key){-.-.}-{3:3}, at: univ8250_console_=
device_lock+0x67/0xc0 drivers/tty/serial/8250/8250_core.c:413
> locks held by kworker/1:0/25: 3, on CPU#1:
>  #0: ffff88810006b140 ((wq_completion)events){+.+.}-{0:0}, at: rcu_lock_a=
cquire include/linux/rcupdate.h:309 [inline]
>  #0: ffff88810006b140 ((wq_completion)events){+.+.}-{0:0}, at: rcu_read_l=
ock include/linux/rcupdate.h:849 [inline]
>  #0: ffff88810006b140 ((wq_completion)events){+.+.}-{0:0}, at: process_on=
e_work kernel/workqueue.c:3361 [inline]
>  #0: ffff88810006b140 ((wq_completion)events){+.+.}-{0:0}, at: process_sc=
heduled_works+0x97a/0x1630 kernel/workqueue.c:3479
>  #1: ffffc900001f7c40 ((work_completion)(&data->fib_event_work)){+.+.}-{0=
:0}, at: rcu_lock_acquire include/linux/rcupdate.h:309 [inline]
>  #1: ffffc900001f7c40 ((work_completion)(&data->fib_event_work)){+.+.}-{0=
:0}, at: rcu_read_lock include/linux/rcupdate.h:849 [inline]
>  #1: ffffc900001f7c40 ((work_completion)(&data->fib_event_work)){+.+.}-{0=
:0}, at: process_one_work kernel/workqueue.c:3361 [inline]
>  #1: ffffc900001f7c40 ((work_completion)(&data->fib_event_work)){+.+.}-{0=
:0}, at: process_scheduled_works+0x97a/0x1630 kernel/workqueue.c:3479
>  #2: ffff88819efed250 (&data->fib_lock){+.+.}-{4:4}, at: nsim_fib_event_w=
ork+0x1fd/0x3b0 drivers/net/netdevsim/fib.c:1490
> locks held by khungtaskd/35: 1, last CPU#1:
>  #0: ffffffff8ed5c6e0 (rcu_read_lock){....}-{1:3}, at: rcu_lock_acquire i=
nclude/linux/rcupdate.h:309 [inline]
>  #0: ffffffff8ed5c6e0 (rcu_read_lock){....}-{1:3}, at: rcu_read_lock incl=
ude/linux/rcupdate.h:849 [inline]
>  #0: ffffffff8ed5c6e0 (rcu_read_lock){....}-{1:3}, at: debug_show_all_loc=
ks+0x2e/0x180 kernel/locking/lockdep.c:6837
> locks held by getty/5425: 2, on CPU#0:
>  #0: ffff8881001f80a0 (&tty->ldisc_sem){++++}-{0:0}, at: tty_ldisc_ref_wa=
it+0x25/0x70 drivers/tty/tty_ldisc.c:243
>  #1: ffffc900034762e8 (&ldata->atomic_read_lock){+.+.}-{4:4}, at: n_tty_r=
ead+0x45a/0x1360 drivers/tty/n_tty.c:2211
> locks held by kworker/u8:2/5453: 3, on CPU#1:
>  #0: ffff8881012d5940 ((wq_completion)netns){+.+.}-{0:0}, at: rcu_lock_ac=
quire include/linux/rcupdate.h:309 [inline]
>  #0: ffff8881012d5940 ((wq_completion)netns){+.+.}-{0:0}, at: rcu_read_lo=
ck include/linux/rcupdate.h:849 [inline]
>  #0: ffff8881012d5940 ((wq_completion)netns){+.+.}-{0:0}, at: process_one=
_work kernel/workqueue.c:3361 [inline]
>  #0: ffff8881012d5940 ((wq_completion)netns){+.+.}-{0:0}, at: process_sch=
eduled_works+0x97a/0x1630 kernel/workqueue.c:3479
>  #1: ffffc90003edfc40 (net_cleanup_work){+.+.}-{0:0}, at: rcu_lock_acquir=
e include/linux/rcupdate.h:309 [inline]
>  #1: ffffc90003edfc40 (net_cleanup_work){+.+.}-{0:0}, at: rcu_read_lock i=
nclude/linux/rcupdate.h:849 [inline]
>  #1: ffffc90003edfc40 (net_cleanup_work){+.+.}-{0:0}, at: process_one_wor=
k kernel/workqueue.c:3361 [inline]
>  #1: ffffc90003edfc40 (net_cleanup_work){+.+.}-{0:0}, at: process_schedul=
ed_works+0x97a/0x1630 kernel/workqueue.c:3479
>  #2: ffffffff90242108 (pernet_ops_rwsem){++++}-{4:4}, at: cleanup_net+0xf=
5/0x810 net/core/net_namespace.c:677
> locks held by kworker/0:6/5822: 3, on CPU#0:
>  #0: ffff88810006b140 ((wq_completion)events){+.+.}-{0:0}, at: rcu_lock_a=
cquire include/linux/rcupdate.h:309 [inline]
>  #0: ffff88810006b140 ((wq_completion)events){+.+.}-{0:0}, at: rcu_read_l=
ock include/linux/rcupdate.h:849 [inline]
>  #0: ffff88810006b140 ((wq_completion)events){+.+.}-{0:0}, at: process_on=
e_work kernel/workqueue.c:3361 [inline]
>  #0: ffff88810006b140 ((wq_completion)events){+.+.}-{0:0}, at: process_sc=
heduled_works+0x97a/0x1630 kernel/workqueue.c:3479
>  #1: ffffc9000388fc40 (netdev_work){+.+.}-{0:0}, at: rcu_lock_acquire inc=
lude/linux/rcupdate.h:309 [inline]
>  #1: ffffc9000388fc40 (netdev_work){+.+.}-{0:0}, at: rcu_read_lock includ=
e/linux/rcupdate.h:849 [inline]
>  #1: ffffc9000388fc40 (netdev_work){+.+.}-{0:0}, at: process_one_work ker=
nel/workqueue.c:3361 [inline]
>  #1: ffffc9000388fc40 (netdev_work){+.+.}-{0:0}, at: process_scheduled_wo=
rks+0x97a/0x1630 kernel/workqueue.c:3479
>  #2: ffffffff90250960 (rtnl_mutex){+.+.}-{4:4}, at: netdev_work_proc+0x6f=
/0x770 net/core/netdev_work.c:132
> locks held by syz-executor/3546: 1, last CPU#0:
>  #0: ffffffff8ed5c6e0 (rcu_read_lock){....}-{1:3}, at: rcu_lock_acquire i=
nclude/linux/rcupdate.h:309 [inline]
>  #0: ffffffff8ed5c6e0 (rcu_read_lock){....}-{1:3}, at: rcu_read_lock incl=
ude/linux/rcupdate.h:849 [inline]
>  #0: ffffffff8ed5c6e0 (rcu_read_lock){....}-{1:3}, at: class_rcu_construc=
tor include/linux/rcupdate.h:1216 [inline]
>  #0: ffffffff8ed5c6e0 (rcu_read_lock){....}-{1:3}, at: unwind_next_frame+=
0x8f/0x2550 arch/x86/kernel/unwind_orc.c:495
> locks held by syz-executor/4305: 3, last CPU#0:
>  #0: ffffffff90250960 (rtnl_mutex){+.+.}-{4:4}, at: rtnl_lock net/core/rt=
netlink.c:80 [inline]
>  #0: ffffffff90250960 (rtnl_mutex){+.+.}-{4:4}, at: rtnl_nets_lock net/co=
re/rtnetlink.c:366 [inline]
>  #0: ffffffff90250960 (rtnl_mutex){+.+.}-{4:4}, at: rtnl_newlink+0xc10/0x=
1c30 net/core/rtnetlink.c:4214
>  #1: ffff8881a15ace70 (&dev_instance_lock_key#23){+.+.}-{4:4}, at: netdev=
_lock include/linux/netdevice.h:2861 [inline]
>  #1: ffff8881a15ace70 (&dev_instance_lock_key#23){+.+.}-{4:4}, at: netdev=
_lock_ops include/net/netdev_lock.h:42 [inline]
>  #1: ffff8881a15ace70 (&dev_instance_lock_key#23){+.+.}-{4:4}, at: do_set=
link+0x3d4/0x4670 net/core/rtnetlink.c:3176
>  #2: ffffffff90242048 (net_rwsem){++++}-{4:4}, at: wireless_nlevent_flush=
 net/wireless/wext-core.c:350 [inline]
>  #2: ffffffff90242048 (net_rwsem){++++}-{4:4}, at: wext_netdev_notifier_c=
all+0x28/0x110 net/wireless/wext-core.c:370
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
> NMI backtrace for cpu 1
> CPU: 1 UID: 0 PID: 35 Comm: khungtaskd Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
>  nmi_cpu_backtrace+0x274/0x2d0 lib/nmi_backtrace.c:123
>  nmi_trigger_cpumask_backtrace+0x17d/0x390 lib/nmi_backtrace.c:66
>  trigger_all_cpu_backtrace include/linux/nmi.h:164 [inline]
>  __sys_info lib/sys_info.c:157 [inline]
>  sys_info+0x135/0x170 lib/sys_info.c:165
>  check_hung_uninterruptible_tasks kernel/hung_task.c:353 [inline]
>  watchdog+0xfd7/0x1030 kernel/hung_task.c:561
>  kthread+0x38b/0x480 kernel/kthread.c:436
>  ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
>  </TASK>
> Sending NMI from CPU 1 to CPUs 0:
> NMI backtrace for cpu 0
> CPU: 0 UID: 0 PID: 16 Comm: pr/ttyS0 Not tainted syzkaller #0 PREEMPT(ful=
l)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:io_serial_out+0x7c/0xc0 drivers/tty/serial/8250/8250_port.c:416
> Code: b2 55 fc 44 89 f9 d3 e5 49 83 c6 40 4c 89 f0 48 c1 e8 03 42 80 3c 2=
0 00 74 08 4c 89 f7 e8 cc 7b c5 fc 41 03 2e 89 d8 89 ea ee <5b> 41 5c 41 5e=
 41 5f 5d e9 c7 4f 75 06 cc 44 89 f9 80 e1 07 38 c1
> RSP: 0018:ffffc90000157900 EFLAGS: 00000002
> RAX: 000000000000005b RBX: 000000000000005b RCX: 0000000000000000
> RDX: 00000000000003f8 RSI: 0000000000000000 RDI: 0000000000000020
> RBP: 00000000000003f8 R08: 0000000000000003 R09: 0000000000000004
> R10: dffffc0000000000 R11: ffffffff85720850 R12: dffffc0000000000
> R13: 000000000000005b R14: ffffffff9ad320c0 R15: 0000000000000000
> FS:  0000000000000000(0000) GS:ffff88818d6d9000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007fdb361ed158 CR3: 00000001a3b52000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  serial_port_out include/linux/serial_core.h:817 [inline]
>  serial8250_console_putchar drivers/tty/serial/8250/8250_port.c:3287 [inl=
ine]
>  __serial8250_console_fifo_write+0x1e6/0x3e0 drivers/tty/serial/8250/8250=
_port.c:3359
>  serial8250_console_fifo_write drivers/tty/serial/8250/8250_port.c:3378 [=
inline]
>  __serial8250_console_write drivers/tty/serial/8250/8250_port.c:3429 [inl=
ine]
>  serial8250_console_write+0xaa1/0x1200 drivers/tty/serial/8250/8250_port.=
c:3493
>  nbcon_emit_next_record+0xef5/0x1a90 kernel/printk/nbcon.c:-1
>  nbcon_emit_one kernel/printk/nbcon.c:1157 [inline]
>  nbcon_kthread_func+0x679/0x880 kernel/printk/nbcon.c:1271
>  kthread+0x38b/0x480 kernel/kthread.c:436
>  ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
>  </TASK>
>
>
> ***
>
> If these findings have caused you to resend the series or submit a
> separate fix, please add the following tag to your commit message:
>   Tested-by: syzbot@syzkaller.appspotmail.com
>
> ---
> This report is generated by a bot. It may contain errors.
> syzbot ci engineers can be reached at syzkaller@googlegroups.com.
>
> To test a fix for this bug, please reply with `#syz test`
> (on a separate line) and attach the patch to the email.
>
> Notes:
> - The patch will be applied on top of the tested series (as an
>   incremental fix).
> - To test a new version of the whole series, please send it directly
>   to syzbot@lists.linux.dev.
> - Arguments like custom git repos and branches are not supported.
>
> The email will later be sent to:
> [davem@davemloft.net dhowells@redhat.com edumazet@google.com elver@google=
.com horms@kernel.org kasan-dev@googlegroups.com kuba@kernel.org linux-afs@=
lists.infradead.org linux-kernel@vger.kernel.org marc.dionne@auristor.com n=
etdev@vger.kernel.org pabeni@redhat.com syzbot@syzkaller.appspotmail.com sy=
zkaller-bugs@googlegroups.com]
>
> If the report looks fine to you, reply with:
> #syz upstream
>
> If the report is a false positive, reply with
> #syz invalid
>
> --
> You received this message because you are subscribed to the Google Groups=
 "syzkaller-upstream-moderation" group.
> To unsubscribe from this group and stop receiving emails from it, send an=
 email to syzkaller-upstream-moderation+unsubscribe@googlegroups.com.
> To view this discussion visit https://groups.google.com/d/msgid/syzkaller=
-upstream-moderation/6a9faf76.f614420e.2bf292.0008.GAE%40google.com.
