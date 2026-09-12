Received: from mail-oo2-f41.google.com (mail-oo2-f41.google.com [74.125.231.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F789429CC7
	for <syzbot@lists.linux.dev>; Sat, 12 Sep 2026 08:47:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.231.169
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789202848; cv=pass; b=V3eUX0St9MdE1aDBUVtyknmU2Hs6ao4fgqnsd8NQ5y7YsU86z/rMwmu7A1uGgIR1N4LbLVEW9Z2s7PrdDDRmE7WQBw5BUYqquuNRC9wkeluMIv/1E0gEFJyOQM0zQ82ajS3SCxELMjd7TI/eIYEnoPCtWJBu/mnapelP2TKPXhw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789202848; c=relaxed/simple;
	bh=1W8iP9iXvTZGt7a9W24ogbYwAKLJf8DWTclvU97URhw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MBJBtCKLiaKeE/k+WMH09ZjVTcP+5vCWxkuAILvsE+JPbFNm/kxjTvXb3XWcylRH5xJbAf4m+XIr4gxJt830D34KJ4g5twtlKL9xtBICrdF6cyg6iAGAuKVdsM7zjKmyhB3/5diLD1P+BcekrV5QA6evoQbv55pBrJNdC7TofHw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=LAklOQW2; arc=pass smtp.client-ip=74.125.231.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LAklOQW2"
Received: by mail-oo2-f41.google.com with SMTP id 006d021491bc7-6b1ae6f5fc7so401703eaf.3
        for <syzbot@lists.linux.dev>; Sat, 12 Sep 2026 01:47:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789202841; cv=none;
        d=google.com; s=arc-20260327;
        b=qaLJ0R5cjszPRZzNe4UfgAU9AJLKxDu11OhZ21kDsxYz0mZlhmUzFGI59jkL9EchTo
         pM8fgjAGnQruJ9ewC3NFCeqlmrG+bAb0e9SRq7bNjFOXe+qVWj9Zl3hTL+bn6P02OdqX
         VUGkzDIpePxSOdQfeMdhFHFCxWKNLUBR36Ok+9ylxMrFdv6FzYAZGSNgOYwvYI+48wff
         kH5ykniyldjku9yfg3zFGmnFk96tEvvvD+fGKCx0//3Hgxw/sT4xVUJKnO9DfmhY0fGE
         W2w/r7r39W2G9koJhUZcdJpG8Fr7yYVqytWoqZJc6dIcJh/m/RnszI5Yw4L+OdNbf8o6
         lStg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=E3hjXf8+fnpunWI31lO3vapP4Fa0DZ3rgjaft2wsRaE=;
        fh=oAY9tjIzZ2Ory5uSn9XOB/FAeNmsfczhMXwevpAT8tc=;
        b=fn9+eOU1VE/ZWxeiRScvGXekt5K8BsZtSj1nMAWATbV3YnNYcASQj1bR13cHnGycl+
         C7KfHjGVY7okXtryebEPWR719A7l2PQRhUofb0OGb06uxAi2hePDgLNAeX3T9tYnO/UZ
         OsIg+qys/kbTW+WIV+fSsm3kB4rSE0iJhA2vUSTvOAGUe6Y7Uc4hw0jh7/BJMaaKq7xx
         dDMBieAwlLrmlQCaOjmjMhwzteonh3MPdZn3v5y3ee3VnQXrMEOwksHaFnIgg//i4LUK
         dzCZhXZzRGSX9aNGssVvTQj4+vu38SonY03CBQrOBrL9V2iDjSzLzpzQe76IxPqi6Hc4
         g1Ww==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789202841; x=1789807641; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=E3hjXf8+fnpunWI31lO3vapP4Fa0DZ3rgjaft2wsRaE=;
        b=LAklOQW29peC7UwDqEPkseFjI5noLRBz8lTYw29SiYzT5TdmHVc1tknIgfjnhki/nP
         ZMYeDtXKg0n6sz8Vt8lrXfWRFGVqNd6zuqe0PkqqgnNBjbXI01lW7eMr6rl1ttCRz0zL
         l7WY74gfdNMt7c81ULuudtYgldzpKz0yjT7V0rBRwyEaRdbnPQbE0oLh2Bm14krLlwnf
         3jI5RS1bNoMXBftNvBtunS0atCkGL5g1tJRFhKkMEj8cjGAJPpXxkiVkIokMdCpV2la4
         VdnLKwqSCLlYV6NSY0KTX+Kd89i6NFENCyIC62vjUh7K79ugEUHx2pU5V3sN9s7YeMcX
         4p7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789202841; x=1789807641;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=E3hjXf8+fnpunWI31lO3vapP4Fa0DZ3rgjaft2wsRaE=;
        b=LGhXHl5tF+BEoSEjiei9EYFhpYvkG8Jbxz7xz+hKTBhNM9n57+lyLpOpMBr74dB1iU
         yO03yFuoNmjLxIv+jn/i7fiMq4sURMdEEU1lUPx0Oi3Culx+FzkUgMZZwl4tXgWu9FtY
         VGuAF0gPyeQ2gpbhkK7x5tDQWjQ52ANckcf9gA6u7Rc87icvkraA0hkitFQVlvr6gqNF
         SsP7MShbJY9FT8riIsq87dKkrsmwweJE4mhQoX2NOm/zjlSDe3tquErw/D8bsBWaQPZI
         R6Sh8VOF5p2BmLvbU2w41agFWJwOO7Vy4cpawstXJEXL6OHyMVe5x+hhCBR8RqW1S5z8
         eCMw==
X-Forwarded-Encrypted: i=1; AKwUvBw3BF0cUwgdKXvarweLXx9xAzvX+QCAjf0TMA+dg0nKhARmiLVfNiNk11KViLrslZA5znpjSj8=@lists.linux.dev
X-Gm-Message-State: AFuF++ms2UV1JC9nFoVBnC3BgW67ss8taBapHpldPCz46w0YLbK+YOKn
	uMS/lBB+Q9PTs6hHe1SIKQOwd81V6RVOO4NW8fhFxBSD/Eyt42zorIt+nCDAD/NJzm7+/4II/n8
	9FbFd7+TB6pBw35sJOnnMLH6Efij3hl5zr5Fx1gET
X-Gm-Gg: AYBFou1fF6zxzri6RqE/1Z745oNgbE9KyJm6kG/MzDjIkaILI2izUkD8FhmoUy1zQk+
	4h1g5eMsYnKnj6HO5j9ZJWF7BRK3vb97p2H5Wn5cGKIKZZNe+SCpqmXlETpXijS7BuCZg1b4hna
	RPbd9FNQOMHrCJ32cU5BPPHItzWepE9Lx0iSdpnCMPMtAGhZqbgmPEEeeQgvgvU7at5OlYd/e7e
	h4DNi0/jfqfA0Ja7CdAJfcT0u1HGlSQwIYdWWHSKNkQ6SU3firJX/qRp/unHiWCJvWtcmM3C730
	yCCWDYmMDsfZyeFItclXne9yZHBo9C5F2jjjvRaUR+1MGzrya/r1DCOCQzOox/zA2WpAqURHzgH
	sQJfO25LlHhpaZwHhZtysVPpa0/EJp09RkQbfGw9uLI8fivtVBzD2spnoMmnkqNm2O1DUdruH5A
	HSwvpLvhEdnKDj+jGdvmysf00oQoEw+fvuD7MSWw==
X-Received: by 2002:a05:6820:55d2:20b0:6b1:a812:987b with SMTP id
 006d021491bc7-6c0bb2f8fc4mr7953493eaf.14.1789202840843; Sat, 12 Sep 2026
 01:47:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <6aa48513.6e6c5f9e.28f11f.004b.GAE@google.com>
In-Reply-To: <6aa48513.6e6c5f9e.28f11f.004b.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Sat, 12 Sep 2026 10:47:09 +0200
X-Gm-Features: AcwNN1Uup7MRN1Bm3aLcs13V4CRDHVf8RTj-8yG3998os01rwB-UBblTejq-pjs
Message-ID: <CANp29Y6=VQNnMWNO3r_PMLuL1JoWTGBasC=vX3ZoX1RjQF4ovA@mail.gmail.com>
Subject: Re: [moderation/CI] Re: KVM: unbounded per-VM kernel memory growth
 via KVM_SET_MEMORY_ATTRIBUTES
To: syzbot ci <syzbot+ci111ff5cfa790edc5@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Sat, Sep 12, 2026 at 12:47=E2=80=AFAM syzbot ci
<syzbot+ci111ff5cfa790edc5@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v1] KVM: unbounded per-VM kernel memory growth via KVM_SET_MEMORY_ATTRIB=
UTES
> https://lore.kernel.org/all/20260911184819.101123-1-davimaba.v@proton.me
> * [PATCH 1/2] KVM: Bound per-VM GFN materialization in KVM_SET_MEMORY_ATT=
RIBUTES
> * [PATCH 2/2] KVM: Account mem_attr_array nodes to the caller's memcg
>
> and found the following issue:
> WARNING: suspicious RCU usage in kvm_vm_ioctl_set_mem_attributes
>
> Full report is available here:
> https://ci.syzbot.org/series/734bda86-476d-49cf-9a5e-335cc5b006c0
>
> ***
>
> WARNING: suspicious RCU usage in kvm_vm_ioctl_set_mem_attributes
>
> tree:      kvm-next
> URL:       https://kernel.googlesource.com/pub/scm/virt/kvm/kvm/
> base:      d4b7fb647204f0c81dfeae2d1a708e4d858e0c94
> arch:      amd64
> compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~e=
xp1~20260613092250.77), Debian LLD 22.1.8
> config:    https://ci.syzbot.org/builds/a54b5b46-809d-4f22-a473-c317ec575=
648/config
> syz repro: https://ci.syzbot.org/findings/c345c736-c3eb-46c9-9d9d-cc78ce4=
bf677/syz_repro
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
> WARNING: suspicious RCU usage
> syzkaller #0 Not tainted
> -----------------------------
> ./include/linux/xarray.h:1211 suspicious rcu_dereference_check() usage!
>
> other info that might help us debug this:
>
>
> rcu_scheduler_active =3D 2, debug_locks =3D 1
> locks held by syz.2.19/5790: 1, last CPU#0:
>  #0: ffff88810b9900a0 (&kvm->slots_lock){+.+.}-{4:4}, at: kvm_vm_set_mem_=
attributes virt/kvm/kvm_main.c:2605 [inline]
>  #0: ffff88810b9900a0 (&kvm->slots_lock){+.+.}-{4:4}, at: kvm_vm_ioctl_se=
t_mem_attributes+0x365/0x1af0 virt/kvm/kvm_main.c:2690
>
> stack backtrace:
> CPU: 0 UID: 0 PID: 5790 Comm: syz.2.19 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
>  lockdep_rcu_suspicious+0x140/0x1d0 kernel/locking/lockdep.c:6938
>  xa_head include/linux/xarray.h:1210 [inline]
>  xas_start+0x618/0x770 lib/xarray.c:191
>  xas_load+0x2c/0x5a0 lib/xarray.c:239
>  xas_find+0x157/0x980 lib/xarray.c:1409
>  kvm_count_mem_attr_entries virt/kvm/kvm_main.c:2558 [inline]
>  kvm_vm_set_mem_attributes virt/kvm/kvm_main.c:2660 [inline]
>  kvm_vm_ioctl_set_mem_attributes+0x1578/0x1af0 virt/kvm/kvm_main.c:2690
>  kvm_vm_ioctl+0xb33/0xd30 virt/kvm/kvm_main.c:5421
>  vfs_ioctl fs/ioctl.c:51 [inline]
>  __do_sys_ioctl fs/ioctl.c:597 [inline]
>  __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
>  do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
>  do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f4321f9e159
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007f4322e33028 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
> RAX: ffffffffffffffda RBX: 00007f4322225fa0 RCX: 00007f4321f9e159
> RDX: 0000200000002200 RSI: 000000004020aed2 RDI: 0000000000000004
> RBP: 00007f432203503b R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f4322226038 R14: 00007f4322225fa0 R15: 00007ffea2b6d9c8
>  </TASK>
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
> WARNING: suspicious RCU usage
> syzkaller #0 Not tainted
> -----------------------------
> ./include/linux/xarray.h:1227 suspicious rcu_dereference_check() usage!
>
> other info that might help us debug this:
>
>
> rcu_scheduler_active =3D 2, debug_locks =3D 1
> locks held by syz.2.19/5790: 1, last CPU#0:
>  #0: ffff88810b9900a0 (&kvm->slots_lock){+.+.}-{4:4}, at: kvm_vm_set_mem_=
attributes virt/kvm/kvm_main.c:2605 [inline]
>  #0: ffff88810b9900a0 (&kvm->slots_lock){+.+.}-{4:4}, at: kvm_vm_ioctl_se=
t_mem_attributes+0x365/0x1af0 virt/kvm/kvm_main.c:2690
>
> stack backtrace:
> CPU: 0 UID: 0 PID: 5790 Comm: syz.2.19 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
>  lockdep_rcu_suspicious+0x140/0x1d0 kernel/locking/lockdep.c:6938
>  xa_entry include/linux/xarray.h:1226 [inline]
>  xas_descend lib/xarray.c:208 [inline]
>  xas_load+0x4dc/0x5a0 lib/xarray.c:246
>  xas_find+0x157/0x980 lib/xarray.c:1409
>  kvm_count_mem_attr_entries virt/kvm/kvm_main.c:2558 [inline]
>  kvm_vm_set_mem_attributes virt/kvm/kvm_main.c:2660 [inline]
>  kvm_vm_ioctl_set_mem_attributes+0x1578/0x1af0 virt/kvm/kvm_main.c:2690
>  kvm_vm_ioctl+0xb33/0xd30 virt/kvm/kvm_main.c:5421
>  vfs_ioctl fs/ioctl.c:51 [inline]
>  __do_sys_ioctl fs/ioctl.c:597 [inline]
>  __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
>  do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
>  do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f4321f9e159
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007f4322e33028 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
> RAX: ffffffffffffffda RBX: 00007f4322225fa0 RCX: 00007f4321f9e159
> RDX: 0000200000002200 RSI: 000000004020aed2 RDI: 0000000000000004
> RBP: 00007f432203503b R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f4322226038 R14: 00007f4322225fa0 R15: 00007ffea2b6d9c8
>  </TASK>
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
> WARNING: suspicious RCU usage
> syzkaller #0 Not tainted
> -----------------------------
> ./include/linux/xarray.h:1227 suspicious rcu_dereference_check() usage!
>
> other info that might help us debug this:
>
>
> rcu_scheduler_active =3D 2, debug_locks =3D 1
> locks held by syz.2.19/5790: 1, last CPU#0:
>  #0: ffff88810b9900a0 (&kvm->slots_lock){+.+.}-{4:4}, at: kvm_vm_set_mem_=
attributes virt/kvm/kvm_main.c:2605 [inline]
>  #0: ffff88810b9900a0 (&kvm->slots_lock){+.+.}-{4:4}, at: kvm_vm_ioctl_se=
t_mem_attributes+0x365/0x1af0 virt/kvm/kvm_main.c:2690
>
> stack backtrace:
> CPU: 0 UID: 0 PID: 5790 Comm: syz.2.19 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
>  lockdep_rcu_suspicious+0x140/0x1d0 kernel/locking/lockdep.c:6938
>  xa_entry include/linux/xarray.h:1226 [inline]
>  xas_next_entry include/linux/xarray.h:1731 [inline]
>  kvm_count_mem_attr_entries virt/kvm/kvm_main.c:2558 [inline]
>  kvm_vm_set_mem_attributes virt/kvm/kvm_main.c:2660 [inline]
>  kvm_vm_ioctl_set_mem_attributes+0x1834/0x1af0 virt/kvm/kvm_main.c:2690
>  kvm_vm_ioctl+0xb33/0xd30 virt/kvm/kvm_main.c:5421
>  vfs_ioctl fs/ioctl.c:51 [inline]
>  __do_sys_ioctl fs/ioctl.c:597 [inline]
>  __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
>  do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
>  do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f4321f9e159
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007f4322e33028 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
> RAX: ffffffffffffffda RBX: 00007f4322225fa0 RCX: 00007f4321f9e159
> RDX: 0000200000002200 RSI: 000000004020aed2 RDI: 0000000000000004
> RBP: 00007f432203503b R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f4322226038 R14: 00007f4322225fa0 R15: 00007ffea2b6d9c8
>  </TASK>
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
> WARNING: suspicious RCU usage
> syzkaller #0 Not tainted
> -----------------------------
> ./include/linux/xarray.h:1244 suspicious rcu_dereference_check() usage!
>
> other info that might help us debug this:
>
>
> rcu_scheduler_active =3D 2, debug_locks =3D 1
> locks held by syz.2.19/5790: 1, last CPU#0:
>  #0: ffff88810b9900a0 (&kvm->slots_lock){+.+.}-{4:4}, at: kvm_vm_set_mem_=
attributes virt/kvm/kvm_main.c:2605 [inline]
>  #0: ffff88810b9900a0 (&kvm->slots_lock){+.+.}-{4:4}, at: kvm_vm_ioctl_se=
t_mem_attributes+0x365/0x1af0 virt/kvm/kvm_main.c:2690
>
> stack backtrace:
> CPU: 0 UID: 0 PID: 5790 Comm: syz.2.19 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
>  lockdep_rcu_suspicious+0x140/0x1d0 kernel/locking/lockdep.c:6938
>  xa_parent+0xec/0xf0 include/linux/xarray.h:1243
>  xas_find+0x6f2/0x980 lib/xarray.c:1422
>  kvm_count_mem_attr_entries virt/kvm/kvm_main.c:2558 [inline]
>  kvm_vm_set_mem_attributes virt/kvm/kvm_main.c:2660 [inline]
>  kvm_vm_ioctl_set_mem_attributes+0x1578/0x1af0 virt/kvm/kvm_main.c:2690
>  kvm_vm_ioctl+0xb33/0xd30 virt/kvm/kvm_main.c:5421
>  vfs_ioctl fs/ioctl.c:51 [inline]
>  __do_sys_ioctl fs/ioctl.c:597 [inline]
>  __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
>  do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
>  do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f4321f9e159
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007f4322e33028 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
> RAX: ffffffffffffffda RBX: 00007f4322225fa0 RCX: 00007f4321f9e159
> RDX: 0000200000002200 RSI: 000000004020aed2 RDI: 0000000000000004
> RBP: 00007f432203503b R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f4322226038 R14: 00007f4322225fa0 R15: 00007ffea2b6d9c8
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
> [davimaba.v@proton.me kvm@vger.kernel.org pbonzini@redhat.com security@ke=
rnel.org]
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
-upstream-moderation/6aa48513.6e6c5f9e.28f11f.004b.GAE%40google.com.
