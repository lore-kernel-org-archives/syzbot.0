Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.161.51
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793262985;
	b=hu7MzSj5h6S6EJmZDG6igWy/YDAc4oeihXRdIhqr7XKJ0p/n010+/y0MpRom/uB5hv89
	 YF6tgSAvvDofYZDtPWDRywPvFjU2Qh4x9BQxZTHxutznV7TNGku11b+oj1Fy+FdM1TAmq
	 lY4EqStBA2AwxQ1x5iC7FzyGpPAtXDXt6vm6FIbj/P2CF4S7ZlYP2DjmtkARBiEpsfqKC
	 AstF5subCPE2OjKXAicrt4EcgoWSBXybTC+p3UU+r/xfQvMJ03qnOUgej7ts1d+PdItnK
	 Cjnl7ihvCOAIZSMEra+h4YunxRWuAjJVFnit0gZUonWAAfC0Q1pGynWpjVRxWL7cNjg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793262985;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=xwaYUSC5hUmTFigd1QZcVmO6bnrJemdrao73ozvgHF4=;
	b=G8vE6f3Dcl++ESTSRzK5xocTbx54U0gGhC9JC5iLe+O0nZ/bBC8vgRqH+PGf8zZO+cU8
	 qEZKqesm38QF2VZO9Lge7WwzFyZ5ND9FTgwnN7cipxlyGXyPLbUiwK9hnzDvfHjw6Cj3B
	 VZeYqeuu933F73Qhsj2DZ1GJK9nlkOF+u95FalHjz9YKICeJTcVxt1g2abJM2r2SHqL+o
	 0lnX2gd6YG4ceAzYGtucNqUjNjrHrzhsRjuG+5iGsXU+xCBWZ0eXvkmJAxbg5OBki4+Jy
	 CyfAVUGz4TEfk1fKs38R3HV93d5L2JfW3+sThSyWUjmfKKg9OID3jpemiaZ6WCfoHRA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=XJy81d4+;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.161.51
Received: from mail-oo1-f51.google.com (mail-oo1-f51.google.com [209.85.161.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82A0E606A31A
	for <syzbot@lists.linux.dev>; Thu, 29 Oct 2026 08:36:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 82A0E606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=XJy81d4+
Received: by mail-oo1-f51.google.com with SMTP id 006d021491bc7-70b875f6f1fso1470469eaf.2
        for <syzbot@lists.linux.dev>; Thu, 29 Oct 2026 01:36:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793262983; cv=none;
        d=google.com; s=arc-20260327;
        b=RUMq4yLb9mgc3TlxbNctKkfxY8J8i5uJyuEKOYkCPBRtWOd/x+vVcL8JOMCzxpueAo
         XybORNn0r0bx09ZdQXLI9ZsziWAhWjcZaZnBG8PsdCYwm02JOHy8iWPhwkWvuEMLs/g9
         gcfSIoV3a4gB52KE8dQeelXyQEClSfIQuzGB2lRG8LSMwrJxB04clQdS0rKt2chiLebN
         689D+mCDAeOTwj3Jh1IZzcKHTZRZCdimjXgi91UKlqMXsUOq8h2i5o6CghrRl5ZrzMeY
         7Ev/RJWY9yEfti+wlfr8fyGLAHblP25nNRSDcTsSr7zX631P/m/O+1RgcmSPBosj1PST
         0KYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=xwaYUSC5hUmTFigd1QZcVmO6bnrJemdrao73ozvgHF4=;
        fh=JaUuloDTqQo2AQrOjWHdfuAYa9SNwOjMDj3EGyARM4M=;
        b=H0ymYFkmKTfCIpDtOQpyN5AV4E/rqkT302/9ZA3b9Q6uLEL1TV6jNykNyyaxvhUZI3
         gC2AoWytGcre4MM+shfpxwBXvy2PXYCMf2PdhRvsOc7nj4neRLfQfdhuCGi/LV5Ck524
         gW1q3ZiwDpeySIt5cHYxgUHZdOYfqSBLWvhJ7J3+rp4ie6aoKMI+DS+u73NpY54pfeMU
         86yTb/Y/8WUKuRaHEWcoJyWFRFycFzfRPvWVmtCdCnbuCozHCA3h4sDQFsrIudTTXTcV
         7dn9wbo2IYhaZK+V5N9DaldqJxwqxABQDCW3rpkMVvXOg/JZJkFamER8VbXwBb99aHMc
         I3bQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793262983; x=1793867783; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=xwaYUSC5hUmTFigd1QZcVmO6bnrJemdrao73ozvgHF4=;
        b=XJy81d4+Wknryw9ZBiyDVDPajRtVmSBxNs6varJjf4sNXylcnz3Ch2dO7Wj4wVjgQW
         LykLlzvptrY1Z7HcoTQS6F+LPRt8u1sMml5j5QU6cZEbp8S2gmCGNIULFl2FuPx9riEh
         6869tF9rFS7kyi2mvm7AA5LEs+BDZPHxcDM5HH0iS5mmyihmzfmUkUIFDp7nkpa5JIAh
         YqhBYinLCM2EtVIT+pD3chQZSYbsz5W5F+mZJUxUnPKKOaQds1opGdxSHImMgx8DUiHd
         /oFj6z7SpGOfc/u6OZHaavq6uY3a1pbWBiUxCtUNfeO1c25UwfRNhfm/JaWc8LuZxtBj
         xEBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793262983; x=1793867783;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xwaYUSC5hUmTFigd1QZcVmO6bnrJemdrao73ozvgHF4=;
        b=uiZoeuRFpC22ZbN8QX2UOv3FSuRnMcKeMc62qwfzdI2FsjZAQ90ZR4Jq/Ijvz7Jusw
         gZHUN5xB4s5GdnTgf3h+rq9gPWnnhMTyoIU+aWmR454EMEkGCS8ieoYXNt8ZRyc0BgSw
         J5zelBLIF60BzxriTMN0GojpsWGrhsURR4qjtvd0BV36tGoAfvWugwM2/o5p8+uU5ZFT
         gKLSfW/i4O8coDsiTUhgarWgwQHaylvBdve9iRJ6E+m6dhP4JF+Pb5tY5Cc5SkkHQd0U
         S37a8+qLUY7acXQdpWXT82O4KAhm3SF9dVOa33QniE8egPCkYgZ2VYnaogG+cZ7TZRzV
         ziBA==
X-Forwarded-Encrypted: i=1; AKwUvBytKGhBraYb9A34gys1P8oYKztop62wcXRhlCCh6raP1+Hjj2RzZh9x3qOA/YjcZUnh6P+y/3U=@lists.linux.dev
X-Gm-Message-State: AFq9FYJA+lLXjH95AgPVnE6imx1cdaQGpyaDr8GSOQUHSDhk373qVrn2
	b3iuozihdNZVN3f0Va5FYtTA2dy2JFbH7C4fPCJcdyCH2m17oAkss49zzRMPLDW6PVzGTgevdDC
	9C4FlYWqTF3BP4MqzuAqBEQWQuywomHiVuCIlTyW3
X-Gm-Gg: AYBFou0cHoJ8sLBG/s93xuAjmlue3mN7WxZA/7/3cFlKzCCvtujvTdKBqMRsxAsv634
	3+/PDfhEyfXLcrHTJWFGZYeBor+QIj5qS1r3ODWeEBed6lW24UZTNDlodQG/imkKfpFyKhkKmiQ
	hqINpSuHa76/1G/NV6NMPgNc6knobbphYdQsOZoZ0xH9pk2HShgel5cwUNw0UK+RFt6v1WO5GAj
	pbW6f63NvcD9JZKH+Cv3jwTPEbb3ed0ux2ZYubUmbuC9LfrP8Haw9eyvMjF2WR618TgABMfDZ49
	AqJUEwq8wxEiJMxdcvrkQ7odZ8c2zaVuHBJcjBvrhqoYq2gw8k8rdX2IQQxtYxCiFgFLAQ1wgG/
	WRdDOkG/axloLfM4BvcWt+PBkUYbZH/yKzYKWq4U09z7VuqMlZSjdzJrR2M19VFtmxeLnvQQnn4
	ZZS8B4bqP9/b5EaxeqfWKG1JfN5p1O0s18OuRfVM6SUwakE5qMW8m1mIoSeCeddrZCA34Pl8R2P
	CQDIsII
X-Received: by 2002:a05:6820:339a:20b0:6d7:c2d2:3bb6 with SMTP id
 006d021491bc7-713ef23f726mr2150260eaf.74.1793262982809; Thu, 29 Oct 2026
 01:36:22 -0700 (PDT)
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Post: <mailto:syzbot@lists.linux.dev>
List-Help: <mailto:syzbot+help@lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
List-Owner: <mailto:syzbot+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <6ae2c7d2.84012103.26b497.0737.GAE@google.com>
In-Reply-To: <6ae2c7d2.84012103.26b497.0737.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Thu, 29 Oct 2026 09:36:11 +0100
X-Gm-Features: AclHuK-UT2xyB8HNjrKLjc6xg1-plMj8XE6Xvr1HrRmCfhB8rY_GSU1yR0kR0ao
Message-ID: <CANp29Y5gG-1FD6BrPERf3M-V7B7GJwdYxin6TuGs0COLW=PXWQ@mail.gmail.com>
Subject: Re: [moderation/CI] Re: wifi: mac80211_hwsim: fix netlink release and
 radio removal races
To: syzbot ci <syzbot+ci2858acb32e2d0908@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Thu, Oct 29, 2026 at 5:13=E2=80=AFAM syzbot ci
<syzbot+ci2858acb32e2d0908@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v1] wifi: mac80211_hwsim: fix netlink release and radio removal races
> https://lore.kernel.org/all/20261028141751.6728-1-enderaoelyther@gmail.co=
m
> * [PATCH 1/2] wifi: mac80211_hwsim: ignore non-generic netlink releases
> * [PATCH 2/2] wifi: mac80211_hwsim: serialize radio removal with frame co=
mmands
>
> and found the following issue:
> INFO: task hung in mac80211_hwsim_netlink_notify
>
> Full report is available here:
> https://ci.syzbot.org/series/fe9cfff2-ef52-45eb-993c-ea84c287686d
>
> ***
>
> INFO: task hung in mac80211_hwsim_netlink_notify
>
> tree:      wireless-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/wirel=
ess/wireless-next.git
> base:      864c07de0c7dcbca58b61625dfa2e461ae63b242
> arch:      amd64
> compiler:  Debian clang version 22.1.8 (1~deb13u4), Debian LLD 22.1.8
> config:    https://ci.syzbot.org/builds/ffa94119-c540-48f2-b244-f5fa2d953=
1b2/config
> AI triage: https://ci.syzbot.org/findings/1d1df02a-8709-4cb9-9450-7f2ae94=
c0965/triage_trajectory
>
> INFO: task syz-executor:21314 blocked for more than 143 seconds.
>       Not tainted syzkaller #0
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> task:syz-executor    state:D stack:22184 pid:21314 tgid:21314 ppid:1     =
 task_flags:0x400140 flags:0x00080002
> Call Trace:
>  <TASK>
>  __schedule+0x17dd/0x5820
>  schedule+0x164/0x2b0
>  schedule_preempt_disabled+0x13/0x30
>  __mutex_lock+0x7c4/0x15a0
>  mac80211_hwsim_netlink_notify+0x193/0x1140
>  notifier_call_chain+0x1a5/0x3d0
>  blocking_notifier_call_chain+0x6a/0x90
>  netlink_release+0x1211/0x1a90
>  __sock_release+0xa0/0x1f0
>  sock_close+0x1c/0x30
>  __fput+0x408/0xa40
>  fput_close_sync+0x11f/0x240
>  __se_sys_close+0xa2/0x160
>  do_syscall_64+0x166/0x520
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7fed3715fd8e
> RSP: 002b:00007fffadf594c8 EFLAGS: 00000246 ORIG_RAX: 0000000000000003
> RAX: ffffffffffffffda RBX: 000055557b013500 RCX: 00007fed3715fd8e
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000005
> RBP: 0000000000000005 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 00007fed37f54670
> R13: 0000000000000014 R14: 00007fed37f54864 R15: 00000000000001f4
>  </TASK>
>
> Showing all locks held in the system:
> locks held by kworker/u8:1/13: 3, on CPU#0:
>  #0: ffff888111e50148 ((wq_completion)ipv6_addrconf){+.+.}-{0:0}, at: pro=
cess_scheduled_works+0x97a/0x1630
>  #1: ffffc90000127c40 ((work_completion)(&(&ifa->dad_work)->work)){+.+.}-=
{0:0}, at: process_scheduled_works+0x97a/0x1630
>  #2: ffffffff9125a680 (rtnl_mutex){+.+.}-{4:4}, at: addrconf_dad_work+0x1=
16/0x15c0
> locks held by khungtaskd/35: 1, last CPU#1:
>  #0: ffffffff8fd59ca0 (rcu_read_lock){....}-{1:3}, at: debug_show_all_loc=
ks+0x2e/0x180
> locks held by getty/5413: 2, on CPU#1:
>  #0: ffff88811659a0a0 (&tty->ldisc_sem){++++}-{0:0}, at: tty_ldisc_ref_wa=
it+0x25/0x70
>  #1: ffffc9000348b2e8 (&ldata->atomic_read_lock){+.+.}-{4:4}, at: n_tty_r=
ead+0x45a/0x1360
> locks held by kworker/u8:2/5484: 3, last CPU#0:
>  #0: ffff88810b983148 ((wq_completion)krds_cp_wq#3/0){+.+.}-{0:0}, at: pr=
ocess_scheduled_works+0x97a/0x1630
>  #1: ffffc90004407c40 ((work_completion)(&(&cp->cp_conn_w)->work)){+.+.}-=
{0:0}, at: process_scheduled_works+0x97a/0x1630
>  #2: ffff88811a039280 (&tc->t_conn_path_lock){+.+.}-{4:4}, at: rds_tcp_co=
nn_path_connect+0x1cc/0x920
> locks held by kworker/u9:17/30931: 3, last CPU#1:
>  #0: ffff8881000ac148 ((wq_completion)events_unbound){+.+.}-{0:0}, at: pr=
ocess_scheduled_works+0x97a/0x1630
>  #1: ffffc90006befc40 ((work_completion)(&(&nsim_dev->trap_data->trap_rep=
ort_dw)->work)){+.+.}-{0:0}, at: process_scheduled_works+0x97a/0x1630
>  #2: ffff888054278258 (&devlink->lock_key#13){+.+.}-{4:4}, at: nsim_dev_t=
rap_report_work+0x57/0xb30
> locks held by kworker/u9:38/30947: 3, last CPU#1:
>  #0: ffff8881000ac148 ((wq_completion)events_unbound){+.+.}-{0:0}, at: pr=
ocess_scheduled_works+0x97a/0x1630
>  #1: ffffc9000765fc40 ((work_completion)(&(&nsim_dev->trap_data->trap_rep=
ort_dw)->work)){+.+.}-{0:0}, at: process_scheduled_works+0x97a/0x1630
>  #2: ffff888075278258 (&devlink->lock_key#12){+.+.}-{4:4}, at: nsim_dev_t=
rap_report_work+0x57/0xb30
> locks held by kworker/u9:39/30948: 3, last CPU#1:
>  #0: ffff8881000ac148 ((wq_completion)events_unbound){+.+.}-{0:0}, at: pr=
ocess_scheduled_works+0x97a/0x1630
>  #1: ffffc9000768fc40 ((work_completion)(&(&nsim_dev->trap_data->trap_rep=
ort_dw)->work)){+.+.}-{0:0}, at: process_scheduled_works+0x97a/0x1630
>  #2: ffff88806cffd258 (&devlink->lock_key#5){+.+.}-{4:4}, at: nsim_dev_tr=
ap_report_work+0x57/0xb30
> locks held by kworker/u8:7/20795: 7, on CPU#0:
>  #0: ffff8881012dd948 ((wq_completion)netns){+.+.}-{0:0}, at: process_sch=
eduled_works+0x97a/0x1630
>  #1: ffffc9000791fc40 (net_cleanup_work){+.+.}-{0:0}, at: process_schedul=
ed_works+0x97a/0x1630
>  #2: ffffffff9124be48 (pernet_ops_rwsem){++++}-{4:4}, at: cleanup_net+0xf=
5/0x810
>  #3: ffffffff90a92d40 (hwsim_radio_mutex){+.+.}-{4:4}, at: hwsim_exit_net=
+0xc9/0xf70
>  #4: ffffffff9125a680 (rtnl_mutex){+.+.}-{4:4}, at: wiphy_unregister+0x26=
f/0xb20
>  #5: ffff888068390800 (&rdev->wiphy.mtx){+.+.}-{4:4}, at: wiphy_unregiste=
r+0x279/0xb20
>  #6: ffffffff8fd60328 (rcu_state.exp_mutex){+.+.}-{4:4}, at: synchronize_=
rcu_expedited+0x2cb/0x760
> locks held by kworker/u8:8/20796: 2, last CPU#0:
>  #0: ffff888113926148 ((wq_completion)bat_events){+.+.}-{0:0}, at: proces=
s_scheduled_works+0x97a/0x1630
>  #1: ffffc9000793fc40 ((work_completion)(&(&bat_priv->dat.work)->work)){+=
.+.}-{0:0}, at: process_scheduled_works+0x97a/0x1630
> locks held by syz-executor/21314: 3, on CPU#0:
>  #0: ffff8881bfaa2640 (&sb->s_type->i_mutex_key#13){+.+.}-{4:4}, at: __so=
ck_release+0x7a/0x1f0
>  #1: ffffffff912c9268 ((netlink_chain).rwsem){++++}-{4:4}, at: blocking_n=
otifier_call_chain+0x54/0x90
>  #2: ffffffff90a92d40 (hwsim_radio_mutex){+.+.}-{4:4}, at: mac80211_hwsim=
_netlink_notify+0x193/0x1140
> locks held by kworker/0:5/21344: 3, on CPU#0:
>  #0: ffff88810006ad48 ((wq_completion)events){+.+.}-{0:0}, at: process_sc=
heduled_works+0x97a/0x1630
>  #1: ffffc90003ed7c40 (netdev_work){+.+.}-{0:0}, at: process_scheduled_wo=
rks+0x97a/0x1630
>  #2: ffffffff9125a680 (rtnl_mutex){+.+.}-{4:4}, at: netdev_work_proc+0x6f=
/0x770
> locks held by syz-executor/21396: 3, on CPU#0:
>  #0: ffff888112f5c440 (&sb->s_type->i_mutex_key#13){+.+.}-{4:4}, at: __so=
ck_release+0x7a/0x1f0
>  #1: ffffffff912c9268 ((netlink_chain).rwsem){++++}-{4:4}, at: blocking_n=
otifier_call_chain+0x54/0x90
>  #2: ffffffff90a92d40 (hwsim_radio_mutex){+.+.}-{4:4}, at: mac80211_hwsim=
_netlink_notify+0x193/0x1140
> locks held by syz-executor/21403: 3, on CPU#1:
>  #0: ffff888013e16240 (&sb->s_type->i_mutex_key#13){+.+.}-{4:4}, at: __so=
ck_release+0x7a/0x1f0
>  #1: ffffffff912c9268 ((netlink_chain).rwsem){++++}-{4:4}, at: blocking_n=
otifier_call_chain+0x54/0x90
>  #2: ffffffff90a92d40 (hwsim_radio_mutex){+.+.}-{4:4}, at: mac80211_hwsim=
_netlink_notify+0x193/0x1140
> locks held by syz-executor/21473: 3, on CPU#0:
>  #0: ffff8881a662e240 (&sb->s_type->i_mutex_key#13){+.+.}-{4:4}, at: __so=
ck_release+0x7a/0x1f0
>  #1: ffffffff912c9268 ((netlink_chain).rwsem){++++}-{4:4}, at: blocking_n=
otifier_call_chain+0x54/0x90
>  #2: ffffffff90a92d40 (hwsim_radio_mutex){+.+.}-{4:4}, at: mac80211_hwsim=
_netlink_notify+0x193/0x1140
> locks held by syz-executor/21500: 3, on CPU#0:
>  #0: ffff88816a9b4440 (&sb->s_type->i_mutex_key#13){+.+.}-{4:4}, at: __so=
ck_release+0x7a/0x1f0
>  #1: ffffffff912c9268 ((netlink_chain).rwsem){++++}-{4:4}, at: blocking_n=
otifier_call_chain+0x54/0x90
>  #2: ffffffff90a92d40 (hwsim_radio_mutex){+.+.}-{4:4}, at: mac80211_hwsim=
_netlink_notify+0x193/0x1140
> locks held by syz-executor/21503: 3, on CPU#1:
>  #0: ffff8881a652ee40 (&sb->s_type->i_mutex_key#13){+.+.}-{4:4}, at: __so=
ck_release+0x7a/0x1f0
>  #1: ffffffff912c9268 ((netlink_chain).rwsem){++++}-{4:4}, at: blocking_n=
otifier_call_chain+0x54/0x90
>  #2: ffffffff90a92d40 (hwsim_radio_mutex){+.+.}-{4:4}, at: mac80211_hwsim=
_netlink_notify+0x193/0x1140
> locks held by syz-executor/21537: 3, on CPU#1:
>  #0: ffff8881bfaa5040 (&sb->s_type->i_mutex_key#13){+.+.}-{4:4}, at: __so=
ck_release+0x7a/0x1f0
>  #1: ffffffff912c9268 ((netlink_chain).rwsem){++++}-{4:4}, at: blocking_n=
otifier_call_chain+0x54/0x90
>  #2: ffffffff90a92d40 (hwsim_radio_mutex){+.+.}-{4:4}, at: mac80211_hwsim=
_netlink_notify+0x193/0x1140
> locks held by syz-executor/21559: 7, on CPU#0:
>  #0: ffff888117068460 (sb_writers#7){.+.+}-{0:0}, at: vfs_write+0x22b/0xb=
a0
>  #1: ffff888120412c80 (&of->mutex){+.+.}-{4:4}, at: kernfs_fop_write_iter=
+0x1d8/0x540
>  #2: ffff88816bbcf4b8 (kn->active#49){.+.+}-{0:0}, at: kernfs_fop_write_i=
ter+0x22b/0x540
>  #3: ffffffff90ad1400 (nsim_bus_dev_list_lock){+.+.}-{4:4}, at: new_devic=
e_store+0x13c/0x6d0
>  #4: ffff8881c71ac128 (&dev->mutex){....}-{4:4}, at: __device_attach+0x88=
/0x450
>  #5: ffff8881c71a9258 (&devlink->lock_key#14){+.+.}-{4:4}, at: nsim_drv_p=
robe+0xfb/0xbb0
>  #6: ffffffff9125a680 (rtnl_mutex){+.+.}-{4:4}, at: rtnl_net_dev_lock+0x2=
57/0x2f0
> locks held by syz-executor/21566: 3, last CPU#1:
>  #0: ffff88819720ac40 (&sb->s_type->i_mutex_key#13){+.+.}-{4:4}, at: __so=
ck_release+0x7a/0x1f0
>  #1: ffffffff912c9268 ((netlink_chain).rwsem){++++}-{4:4}, at: blocking_n=
otifier_call_chain+0x54/0x90
>  #2: ffffffff8fd59ca0 (rcu_read_lock){....}-{1:3}, at: nl80211_netlink_no=
tify+0x75/0x860
> locks held by kworker/u9:0/21570: 3, last CPU#1:
>  #0: ffff8881000ac148 ((wq_completion)events_unbound){+.+.}-{0:0}, at: pr=
ocess_scheduled_works+0x97a/0x1630
>  #1: ffffc90003e87c40 ((work_completion)(&(&nsim_dev->trap_data->trap_rep=
ort_dw)->work)){+.+.}-{0:0}, at: process_scheduled_works+0x97a/0x1630
>  #2: ffff8881bbf09258 (&devlink->lock_key){+.+.}-{4:4}, at: nsim_dev_trap=
_report_work+0x57/0xb30
> locks held by syz-executor/21598: 2, on CPU#0:
>  #0: ffffffff909c0ba8 (&ops->srcu#2){.+.+}-{0:0}, at: rtnl_link_ops_get+0=
x23/0x250
>  #1: ffffffff9125a680 (rtnl_mutex){+.+.}-{4:4}, at: rtnl_newlink+0xc10/0x=
1c30
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
>  dump_stack_lvl+0xe8/0x150
>  nmi_cpu_backtrace+0x274/0x2d0
>  nmi_trigger_cpumask_backtrace+0x17d/0x390
>  sys_info+0x135/0x170
>  watchdog+0xfd2/0x1030
>  kthread+0x38b/0x480
>  ret_from_fork+0x514/0xb70
>  ret_from_fork_asm+0x1a/0x30
>  </TASK>
> Sending NMI from CPU 1 to CPUs 0:
> NMI backtrace for cpu 0
> CPU: 0 UID: 0 PID: 20796 Comm: kworker/u8:8 Not tainted syzkaller #0 PREE=
MPT(full)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Workqueue: bat_events batadv_dat_purge
> RIP: 0010:native_apic_msr_write+0x39/0x50
> Code: 74 2a 83 ff 30 74 25 eb 10 81 ff d0 00 00 00 74 1b 81 ff e0 00 00 0=
0 74 13 c1 ef 04 81 c7 00 08 00 00 89 f9 89 f0 31 d2 0f 30 <66> 90 c3 cc cc=
 cc cc cc 89 f6 31 d2 e9 e6 17 aa 03 66 0f 1f 44 00
> RSP: 0018:ffffc90000007e50 EFLAGS: 00000046
> RAX: 000000000000000f RBX: ffff888120e23f40 RCX: 0000000000000838
> RDX: 0000000000000000 RSI: 000000000000000f RDI: 0000000000000838
> RBP: ffffc90000007f10 R08: 0000000000000100 R09: 0000000000000001
> R10: 0000000000000003 R11: ffffffff81758510 R12: ffffffff81758510
> R13: 1ffff110241c47f1 R14: 0000000000000000 R15: ffff888120e23f8c
> FS:  0000000000000000(0000) GS:ffff88818c4a4000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f85c76b3866 CR3: 0000000169088000 CR4: 00000000000006f0
> Call Trace:
>  <IRQ>
>  lapic_next_event+0x11/0x20
>  clockevents_program_event+0x44e/0x630
>  hrtimer_run_softirq+0x255/0x2e0
>  handle_softirqs+0x265/0x8d0
>  do_softirq+0x77/0xd0
>  </IRQ>
>  <TASK>
>  __local_bh_enable_ip+0x100/0x140
>  batadv_dat_purge+0x2d7/0x3c0
>  process_scheduled_works+0xc3d/0x1630
>  worker_thread+0xa47/0xfb0
>  kthread+0x38b/0x480
>  ret_from_fork+0x514/0xb70
>  ret_from_fork_asm+0x1a/0x30
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
> [enderaoelyther@gmail.com jlopex@gmail.com johannes@sipsolutions.net jukk=
a.rissanen@linux.intel.com linux-kernel@vger.kernel.org linux-wireless@vger=
.kernel.org linville@tuxdriver.com stable@vger.kernel.org]
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
-upstream-moderation/6ae2c7d2.84012103.26b497.0737.GAE%40google.com.
