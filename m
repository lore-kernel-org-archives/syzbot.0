Received: from mail-oo2-f13.google.com (mail-oo2-f13.google.com [74.125.231.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1DDD316199
	for <syzbot@lists.linux.dev>; Thu, 24 Sep 2026 02:39:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.231.141
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790217566; cv=pass; b=J68B8eQI2NVnFzJvWNBvP/6kD0OFzcVBKYyqekBeagYSUJchyvUX/ZIwC0mwGXGfL3Nu3hQ4+gG/MzvPUVAZgsML8Di5kUTqPMmxz+mTgaMtXeu0cPFMELyBNkOiO6V7+VY3wSJYSP64Vj6DFnJIFwtPTv8QD3kg6wN6U/zvVpk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790217566; c=relaxed/simple;
	bh=j7djDTi4QJGY1uNpHL+zAl1+wJD5rf1K3gMhFEzUSLE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=O52SCFyTdsD9nT3l3RGMo8xsipPyXV7tLIV9OVKF0QBlYIzf4QIKerwvKD53pwAjb9Il1LesqQGWITxyZRCFiis5m2mxxmAHyY4r4Q0HgLRPnHcr8IkaZf6t+UT43g28uoAqZ/48TXK+VjU6gNQR8RPIEfdhGzSpAC9zoEt9QfA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=SQz1NLmN; arc=pass smtp.client-ip=74.125.231.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="SQz1NLmN"
Received: by mail-oo2-f13.google.com with SMTP id 006d021491bc7-6b1ae7089c0so920937eaf.0
        for <syzbot@lists.linux.dev>; Wed, 23 Sep 2026 19:39:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790217563; cv=none;
        d=google.com; s=arc-20260327;
        b=H9NbCbRh4V6KSeFfqFfj5t9CJqxoKxLLR6BG9FT6NIQhvEzV9eTrfKlSotWHtci46i
         Dvf9bP7zn7AKF+gsFsH8XMXV8eUBCfQQgplW9QNvpnyGfzYgJfOrZlEsFL7Zkp40nYqy
         q4pPA135gA7wMmNE5aI+opW4VwyO4S01ycS1sbHfoqo9h6amKQQc3Ad1CrjMJg0Isg6O
         seq2EjofTMEc5wcJLIZ34SFokTOtsrAhjPeSHFJ7Ngnn1+pBNUQ4gwBNvdXQI89l7tsz
         JVesTEOCJiYlQcaq+LqEC9CrHC3BjOPIdUwpCCnWFKqfCyVCMvmKLfZqzt2gxov7FWrp
         z+vQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Uajv4mXUq7Ls7Es7Ds+yoeRl1RQdqSglbaOjoCTbFm0=;
        fh=BSXuhccYyObe+n4oG7dSjNf6j3nRD/ZbDh8F4CUXMNk=;
        b=pYsCEdUs0TI9so+nvNwxXeQGhQnJaooUoNUpJ5pO4dm3/2xwq0XUPQmIrrPO7AHXin
         esSn5f+I3fq7g7CaiCOynOyhQAzf91oc1sO8XGmMDM0aKj8EUbXdACAySiLDC2mEk3/i
         ik7y2TD1RUdm+gEieDN0Gc0SiHiMhUJkCQA2Rc4VDtjhRJ6XnmbUIHdbqEsfNdsT+5hE
         tYe6IKHlTMQiOB0465QQR0zXI+YCQ2ennUHTFCdwcnx8q0/9sZOBkRga38SJUSshalYr
         W/emQXZWpnOAKo1lR9NxNpQ4pLLnshLzLywuY8Q8SXrp4T+dGXPYJY83OBY3d3wPeI+Y
         b5bg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790217563; x=1790822363; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Uajv4mXUq7Ls7Es7Ds+yoeRl1RQdqSglbaOjoCTbFm0=;
        b=SQz1NLmNXYQlDykBPsC3Tx6ixYp69d5CP0J+VsFsPGky1H+UGhbeL+MWwZiEprpsGc
         bm6grilygphEXbnwKHqt/9vcUV/synAFAKtH96iicH458jX7rK+jFZey5NpaNhuiQTfx
         0E8ZbAIESNXtOoMp3bgMCGMkmw+4vW3hitK19rAjFv3WfhHCFe2XOcq97/RMondoDP1o
         QiRFL5yLsp20zOWHs+FvI9s0UXIA6weko3nXpU/bnlB2PzlM95ghs8QTP31JAw3ykcP7
         LHJbwg+P7h1pL/V7w7/YYyy79T142Ui9SkYrx9xcjzhwDD+cG437iJzl43UqXeS5SaXX
         UzLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790217563; x=1790822363;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Uajv4mXUq7Ls7Es7Ds+yoeRl1RQdqSglbaOjoCTbFm0=;
        b=zOoHZnC3nMXQMLHeZtCdiSnycrjzO47cXEAmlaiOobq3PUchQcMowFlhHl5JRWs7yV
         4Iy+/N6BxbqlpI1qXKdGYZmgaphYSgSL7ysZd6nvq7mYC4JW6aCKuTF80VbjJJa6y/SA
         q4dPOtqOuHpjp43eIoMbIJ9LTrJnMnJsaRbS1PQZwoo+VwvBXMm198qC3yjScGBch7kl
         FWP+rENBkzNON6Fwsz1OCrEgE3QihiS0GfWhp5E42TfQozcblxaD9gkkoLpFN+GEVrel
         xwIvjzLD3pRH2/I8VBY/LGGe+5CoJ282ljeNvavk1Zn8N5W67jrhjNKGaEXI1KQf3Oae
         /tfg==
X-Forwarded-Encrypted: i=1; AKwUvBzReZZ7M/d/EUjLy1kx4AT58ioOVq1683BEP2o9xlBPlGCp6B/j0oWdmLJuZNe52nFjNASDyj4=@lists.linux.dev
X-Gm-Message-State: AFuF++mENeSX0w/fi9J8Q15wIzfCtWbmNxDHplCHHXhm1FLhCXkT+Lh3
	ad2RT07+/mlp4r5RwCXBnVyg7XqEfzA58azsk9nJa4HMkpZshAuSGtIZlGaQOYwoftYR0Qb5CQ4
	RQseEhZjiHcFz9e4QA+8zAgJiDvPi4sodQUVvBBIy
X-Gm-Gg: AYBFou32MIhxVNN5mjxQ4jKBFI2HS4Qd2IBmIGty1iyMb0Nb5XmRKqZ4F5SjOtzKNk7
	9UZtsSo9kuY9/b4VX1kfGz/6tgflfYKswNXNHxjtcyaad1tdMgUVPgHmmsRMQedADf1Y5YZ/VHC
	klWWb7opOmeY3NgvcwW9nG7X956n5Pg2NALn3pqbdiTTlM+QH7Mn9uMTgbgm+y1JFOolCsHbnku
	SQQYjW4BHlhHoya1YCWBvd+fPGNImcVCoKV5p87ZCaKi1heX8ytH9XhF0KH6jRrBlow1hLTaPRA
	tdbI4xN2fWT6k9J0fkrjXOKqmQb4+Jdlyx4C6f29lfZ0g2ZEQU9lC/NOk7zqQ7G2fis3x8muWsS
	GgeZ3ySrU4sd+NJdYkGfiDHpljx+Ts+qgP17LOdNu6bI05BLA4qIKuEg98pquxUTyFSzU
X-Received: by 2002:a05:6820:218:b0:6b7:8396:f3c9 with SMTP id
 006d021491bc7-6d4413c3cc6mr1226763eaf.43.1790217562895; Wed, 23 Sep 2026
 19:39:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <6ab46495.fb6b21f1.1b3075.0006.GAE@google.com>
In-Reply-To: <6ab46495.fb6b21f1.1b3075.0006.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Wed, 23 Sep 2026 22:39:11 -0400
X-Gm-Features: AclHuK_qG5__uRdsUq4SohZN9it1DDo2UylsqmOJPdyBB0MI_9vFo94p2qNDrzw
Message-ID: <CANp29Y7rGBF0MgvSKwYw=RLE7bpT3Y15533fxr_bYvYdAXKkNg@mail.gmail.com>
Subject: Re: [moderation/CI] Re: net: opt loopback into instance locking
To: syzbot ci <syzbot+ci2e26614b55697582@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Wed, Sep 23, 2026 at 7:45=E2=80=AFPM syzbot ci
<syzbot+ci2e26614b55697582@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v2] net: opt loopback into instance locking
> https://lore.kernel.org/all/20260921190452.1467853-1-kuba@kernel.org
> * [PATCH net-next v2] net: opt loopback into instance locking
>
> and found the following issue:
> possible deadlock in default_device_exit_batch
>
> Full report is available here:
> https://ci.syzbot.org/series/23f51d46-5d1a-4839-a0a8-35d88361ffdb
>
> ***
>
> possible deadlock in default_device_exit_batch
>
> tree:      net-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netde=
v/net-next.git
> base:      944ae66642b726bd6b25ae71b1e9ff88a0e0bdb0
> arch:      amd64
> compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~e=
xp1~20260613092250.77), Debian LLD 22.1.8
> config:    https://ci.syzbot.org/builds/014063b0-7001-43f1-aa04-57649607f=
ebc/config
> AI triage: https://ci.syzbot.org/findings/6bb35d14-7fe7-4d73-9528-891c80c=
f7f1c/triage_trajectory
>
> batman_adv: batadv0: Removing interface: batadv_slave_0
> batman_adv: batadv0: Removing interface: batadv_slave_1
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
> WARNING: possible circular locking dependency detected
> syzkaller #0 Not tainted
> ------------------------------------------------------
> kworker/u8:3/5652 is trying to acquire lock:
> ffff88811671ae70 (&dev_instance_lock_key#3){+.+.}-{4:4}, at: unregister_n=
etdevice_many_notify+0x5bb/0x2140
>
> but task is already holding lock:
> ffff88816d8dae70 (&dev_instance_lock_key){+.+.}-{4:4}, at: unregister_net=
device_many_notify+0x5bb/0x2140
>
> which lock already depends on the new lock.
>
>
> the existing dependency chain (in reverse order) is:
>
> -> #1 (&dev_instance_lock_key){+.+.}-{4:4}:
>        __mutex_lock+0x19d/0x1550
>        unregister_netdevice_many_notify+0x5bb/0x2140
>        default_device_exit_batch+0x6d4/0x760
>        ops_undo_list+0x4b4/0x8d0
>        cleanup_net+0x572/0x810
>        process_scheduled_works+0xc3d/0x1630
>        worker_thread+0xa47/0xfb0
>        kthread+0x38b/0x480
>        ret_from_fork+0x514/0xb70
>        ret_from_fork_asm+0x1a/0x30
>
> -> #0 (&dev_instance_lock_key#3){+.+.}-{4:4}:
>        __lock_acquire+0x164c/0x2de0
>        lock_acquire+0x115/0x350
>        __mutex_lock+0x19d/0x1550
>        unregister_netdevice_many_notify+0x5bb/0x2140
>        default_device_exit_batch+0x6d4/0x760
>        ops_undo_list+0x4b4/0x8d0
>        cleanup_net+0x572/0x810
>        process_scheduled_works+0xc3d/0x1630
>        worker_thread+0xa47/0xfb0
>        kthread+0x38b/0x480
>        ret_from_fork+0x514/0xb70
>        ret_from_fork_asm+0x1a/0x30
>
> other info that might help us debug this:
>
>  Possible unsafe locking scenario:
>
>        CPU0                    CPU1
>        ----                    ----
>   lock(&dev_instance_lock_key);
>                                lock(&dev_instance_lock_key#3);
>                                lock(&dev_instance_lock_key);
>   lock(&dev_instance_lock_key#3);
>
>  *** DEADLOCK ***
>
> locks held by kworker/u8:3/5652: 6, last CPU#1:
>  #0: ffff8881012d5940 ((wq_completion)netns){+.+.}-{0:0}, at: process_sch=
eduled_works+0x97a/0x1630
>  #1: ffffc9000481fc40 (net_cleanup_work){+.+.}-{0:0}, at: process_schedul=
ed_works+0x97a/0x1630
>  #2: ffffffff90244f08 (pernet_ops_rwsem){++++}-{4:4}, at: cleanup_net+0xf=
5/0x810
>  #3: ffffffff90253760 (rtnl_mutex){+.+.}-{4:4}, at: default_device_exit_b=
atch+0xd0/0x760
>  #4: ffff888120c40e70 (&dev_instance_lock_key#3){+.+.}-{4:4}, at: unregis=
ter_netdevice_many_notify+0x5bb/0x2140
>  #5: ffff88816d8dae70 (&dev_instance_lock_key){+.+.}-{4:4}, at: unregiste=
r_netdevice_many_notify+0x5bb/0x2140
>
> stack backtrace:
> CPU: 1 UID: 0 PID: 5652 Comm: kworker/u8:3 Not tainted syzkaller #0 PREEM=
PT(full)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Workqueue: netns cleanup_net
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0xe8/0x150
>  print_circular_bug+0x2e2/0x300
>  check_noncircular+0x12f/0x150
>  __lock_acquire+0x164c/0x2de0
>  lock_acquire+0x115/0x350
>  __mutex_lock+0x19d/0x1550
>  unregister_netdevice_many_notify+0x5bb/0x2140
>  default_device_exit_batch+0x6d4/0x760
>  ops_undo_list+0x4b4/0x8d0
>  cleanup_net+0x572/0x810
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
> [andrew@lunn.ch davem@davemloft.net edumazet@google.com horms@kernel.org =
kuba@kernel.org netdev@vger.kernel.org pabeni@redhat.com]
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
-upstream-moderation/6ab46495.fb6b21f1.1b3075.0006.GAE%40google.com.
