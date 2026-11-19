Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795088104;
	b=IHeOqStXg0fR2YoRO9f6W9ToFgNCxq08K+pkTeCCXePuk0pZxYtB/g++QaTCkuqMYqY7
	 eDqoA6NMG2n4BpebcAFyZX4WaS1ymJ0HYuqMIEhsN1rQZ7KDdtzhq9oabUrCdlxtTNwtG
	 2mmuOJmvAXI7ioxdaiIsj74uh7AIg/PyJfnP8ggOvGBl7vPkgUvNM88GpXk0+UGKmAQwv
	 aDDWflHM3gImd5O7d0nPLRPNF4C526RIf71l1SQZDfwhiy00FWMD0jo3OnIhG5zlKSj+j
	 F/SCIkhhLqC+BDQtK3t5sZUS2JAM5usKqntXYDSW+KfUz/vgndZ3eNoRXfIT49twwCQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795088104;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=8h0AQ2AaFUfn65GPUCjEobw3d58HZ4RkTCU34IcUc0E=;
	b=yYCkEeYVGS+DuxvqSfzSfpK0h6zw8Tv6MxSWhAE2u6vEVROQfCMSO1owtTmz4v/dfxXZ
	 aANxg0zHc0I0+5WA9BgFOZ74017QO/vaIj3CcbL2zJSS5GdA7yXllhMZ1CM2duiVD1srh
	 nTu99r/rcKPxk83J9ILgUA3q/SCMAD4tryX1lsST1DMN9+48f8nK1gTqCmpjq1rIb8duy
	 v6bVuwTTspCPWqVbW0xmBM1BirC8Tqqas1HUJ/qbBMWXo5GV85hGxBiNVAjmiEYZ+BOeJ
	 aK4vfIDezxnROQTJkm13dYKh4Hzmbr9tnvAwlU59IbQrkjkPxzfZF7YQWHCB02nunFA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aj5juQwK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D79B606A320;
	Thu, 19 Nov 2026 11:35:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aj5juQwK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BC121F000C4;
	Thu, 19 Nov 2026 11:35:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795088103;
	bh=8h0AQ2AaFUfn65GPUCjEobw3d58HZ4RkTCU34IcUc0E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=aj5juQwK5Tgh4ZyrABmScWfWYkyDllKaiWJc/WSAIrRzPaQEUXXSl2RvmoRjhZlgy
	 Iwtn0ulXet4XcF/wTvrORPsbhOWbPQpVB/wt9sRwP53deYja0GZ9btePG2rbbIfUja
	 AkflxyqSNtC+oEu4dIxOhCiKeBX9v04kGl1kd8Czpo1EUkW4yagb9WFHMPukIxMq+N
	 dUEWIukb9n7jR+4545FyhdRgfbBgxQI3vl6Iq8vdWQ9CzD+m2FGgRAjymygKWwtZuM
	 2o/koWq1DPJ6g4Ezf/GHR/xoXEus43tWf0Sz8RzCRwNTVqbExTGqsdCBmhbEJcG/WA
	 kFT8/Ir1NGT1A==
Date: Thu, 19 Nov 2026 11:34:58 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: syzbot ci <syzbot+ci7e1f981ab411668d@syzkaller.appspotmail.com>
Cc: chengming.zhou@linux.dev, david@kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, xu.xin@linux.dev, syzbot@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot ci] Re: mm/ksm: clean up scan_get_next_rmap_item()
 initialization
Message-ID: <av7e0B-1GCyk6sDs@gremlin>
References: <20261115075832.132109-1-xu.xin@linux.dev>
 <6afe9e8e.92f98041.20636d.0002.GAE@google.com>
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Post: <mailto:syzbot@lists.linux.dev>
List-Help: <mailto:syzbot+help@lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
List-Owner: <mailto:syzbot+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6afe9e8e.92f98041.20636d.0002.GAE@google.com>

On Wed, Nov 18, 2026 at 11:00:30PM -0800, syzbot ci wrote:
> syzbot ci has tested the following series
>
> [v2] mm/ksm: clean up scan_get_next_rmap_item() initialization
> https://lore.kernel.org/all/20261115075832.132109-1-xu.xin@linux.dev
> * [PATCH v2 1/2] mm/ksm: extract helper functions for scan cycle cleanup
> * [PATCH v2 2/2] mm/ksm: add initialization helpers for scan_get_next_rmap_item()
>
> and found the following issue:
> general protection fault in ksm_do_scan
>
> Full report is available here:
> https://ci.syzbot.org/series/cc51d824-2b5d-4c6d-bd56-c5bdb2bf5e12

I guess it didn't see the v3? Likely this is the sashiko thing, fixed there

>
> ***
>
> general protection fault in ksm_do_scan
>
> tree:      mm-new
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/mm.git
> base:      3dfc09a9493ddaa5e7722a29165d8450b55b4d3f
> arch:      amd64
> compiler:  Debian clang version 22.1.8 (1~deb13u4), Debian LLD 22.1.8
> config:    https://ci.syzbot.org/builds/6f9c12e2-f68e-40ee-bbac-84e33b709dfb/config
>
> Oops: general protection fault, probably for non-canonical address 0xdffffc0000000004: 0000 [#1] SMP KASAN PTI
> KASAN: null-ptr-deref in range [0x0000000000000020-0x0000000000000027]
> CPU: 1 UID: 0 PID: 44 Comm: ksmd Not tainted syzkaller #0 PREEMPT(full)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
> RIP: 0010:ksm_do_scan+0x5da/0x6f40
> Code: c7 05 86 a2 b1 19 00 00 00 00 48 8d 43 28 48 89 05 9b a2 b1 19 48 89 4c 24 40 48 8d 59 20 48 89 d8 48 c1 e8 03 48 89 44 24 78 <42> 80 3c 28 00 74 08 48 89 df e8 47 3a 01 00 48 89 5c 24 30 48 8b
> RSP: 0018:ffffc90000b47a60 EFLAGS: 00010202
> RAX: 0000000000000004 RBX: 0000000000000020 RCX: 0000000000000000
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffc90000b47c08
> RBP: ffffc90000b47cd0 R08: ffffc90000b47c07 R09: 0000000000000000
> R10: ffffc90000b47bb0 R11: fffff52000168f81 R12: 1ffff92000168f68
> R13: dffffc0000000000 R14: ffffea00046aca00 R15: 0000000000000000
> FS:  0000000000000000(0000) GS:ffff8882a77fd000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f15aa3f8c38 CR3: 0000000170aa2000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  ksm_scan_thread+0x114/0x520
>  kthread+0x38b/0x480
>  ret_from_fork+0x514/0xb70
>  ret_from_fork_asm+0x1a/0x30
>  </TASK>
> Modules linked in:
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:ksm_do_scan+0x5da/0x6f40
> Code: c7 05 86 a2 b1 19 00 00 00 00 48 8d 43 28 48 89 05 9b a2 b1 19 48 89 4c 24 40 48 8d 59 20 48 89 d8 48 c1 e8 03 48 89 44 24 78 <42> 80 3c 28 00 74 08 48 89 df e8 47 3a 01 00 48 89 5c 24 30 48 8b
> RSP: 0018:ffffc90000b47a60 EFLAGS: 00010202
> RAX: 0000000000000004 RBX: 0000000000000020 RCX: 0000000000000000
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffc90000b47c08
> RBP: ffffc90000b47cd0 R08: ffffc90000b47c07 R09: 0000000000000000
> R10: ffffc90000b47bb0 R11: fffff52000168f81 R12: 1ffff92000168f68
> R13: dffffc0000000000 R14: ffffea00046aca00 R15: 0000000000000000
> FS:  0000000000000000(0000) GS:ffff88818bdfd000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 000000110c27b575 CR3: 000000010233e000 CR4: 00000000000006f0
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

--
Cheers, Lorenzo
