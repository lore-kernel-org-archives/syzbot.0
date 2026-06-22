Received: from mail-ot1-f53.google.com (mail-ot1-f53.google.com [209.85.210.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94D892E2DD2
	for <syzbot@lists.linux.dev>; Mon, 22 Jun 2026 17:00:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782147614; cv=pass; b=WKdUyemGnLuYVUca2TBODlFOk7l85+eI6vQBIj7azY8vUbEJasyOazujAYcxxdY5xN67GtunNu3S/geGUHN/CLfb69Qb+0LguAYueTP3BzhIxCvY0C1EGnC6dBzFHA+ux/v0wuhu5Bu8xkVev8mnW6kX6c43MlU0ukDqINT8jHw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782147614; c=relaxed/simple;
	bh=kwR/LnfgRdiqml203pW4BvVWaGKGSQN+8c2PbW9aiCY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rCX6wpSGPdKwCkFRo8B414ty/fQw6DOKbtRK1DoXmQtBrTZdLlS8RBnkbw20gQmzBbqGIGuwHxtv7CD8o+FZcweI8O7KhYuDU83xqdrmMsjSuSejEuJ58+KFfMubGPN71ch8imfNHKw8IvUNwI3EmO28EOUR2RYjnKewziPs0CU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pMfoftg5; arc=pass smtp.client-ip=209.85.210.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pMfoftg5"
Received: by mail-ot1-f53.google.com with SMTP id 46e09a7af769-7e93c3f1717so1146531a34.2
        for <syzbot@lists.linux.dev>; Mon, 22 Jun 2026 10:00:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782147611; cv=none;
        d=google.com; s=arc-20240605;
        b=XwarnlJsQ78VR+PcI+B3dDhmZx9W8LUmtQZhAfjzLmDO36wgwXA8BjsrnPKLZzoPV4
         BnWLYggRA+8vCnYztrSmqD5BWlK1gzzSH+FuLKBtgN+Dy8VcpSjmoo36i68zT/n6PE9+
         aTpab08QOkwPNhulhm3evmQ5nCbRYUCSH/RQV5XsQhYBgDXI+YAtUf+QrohQTcWDSFvi
         N4KTAkIEXxLRAGqLnEJMNWuUUzXIONODbC0UrxPM5zukiz3HstrKQ6kk95HR/FsQ8qcq
         g2V80OEheIyfYX6Kyy21kBTVhluhcrOGb3LNI08FV3t2tsXmzyylqkEfl1U+83rA4unZ
         xprg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=iEbOcj+kdmY8OuI7UymxmoV5Y/5E563h4P0VJssYbnw=;
        fh=+k1NLrV2MqCcoNOezRbvNCZ9zxbzWIKWlZjg/POwYAk=;
        b=YgQ343MS1uRnUDoSu7S+dSXdVIhmAn5mMyGCZr7XbfqN+F9b2H9CNk++yB7zLZ7Tg6
         3bLIz9hRlwLVgiz0Ly4hXnZO5y+sdPso8xgBe08ek7NGTGgpTWYTge4QROvQLr+qBQuh
         1Jl9Pm3a1gz44GBf1NPF6qeYgy3IknVv706T+avYZf60cJ7yF3bMcN16GMNyYD5MgNlE
         TAacETS0w3e+bLV7F3TBl63zcPrc+DdqQ5CQIal1vQcnlndk5AHiQQglM1X3PuBFgKqT
         oMeUAdWudUmd0kHOxYHadKmM6WWVKsrwB3otqQ+tod9Swr+qOGlJiD+FoKz6QFyUAYWt
         x+hA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782147611; x=1782752411; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iEbOcj+kdmY8OuI7UymxmoV5Y/5E563h4P0VJssYbnw=;
        b=pMfoftg5lz+0T/Zu4qfbWfW53AwOHMUmcLVSCQWCS/pY8pKJAhN+pG9D4i9+H+fIOi
         rKF3a51AkIAnQNsdy4nYhK5fnfaczzXmNAwvMTjKgLgQb0penynWcC4rnz9b+lebdUTu
         qtkzkbpgZwoIGa7FW6KIliVtGcBdhlOWml5vLk58WPBJHUvsui+FF3ACq2QNNH+k1YtJ
         4QWjAP/5prNbAGhMp2YbSTHfUAcZ2G4IzVhVSV/DY5FtKrwFhN7ihV7yKS8kAozSayyp
         mYagMi0f5WhpMv0+n4TLPVJOIJV1j3vgtJMbB2EWcfg0GXvebzOWO4H0EHq+bj6FfL8C
         nVFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782147611; x=1782752411;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=iEbOcj+kdmY8OuI7UymxmoV5Y/5E563h4P0VJssYbnw=;
        b=rgx91/8wqno67Ui8hCSLwTTlxRkava23wuoVy43M6ik/6/kxLnlT+wVKb7dr9M9d63
         0wqfwrKqTCbeXSFcMBG6QJuEVAw5hGvPXd33ojHBWn2DMprbs8+ZCL9dAY/p3jlZTkmJ
         EKoHTMOTCRM1o0AnTm2XXzf3NUkyHTIwAq7k/mjW31Xl1qe/dPXYJ/InbpLjqUdcBxdw
         aUOn+rkoq/r7hywLsOtWljRjqBBUvfApfpjcf2rb07FBvfgqzKzKVtVvUuHrlRnWkIsv
         m2MR47W85GwQRFIjeHiicxy4pXRUvGVMlI7X2mSv9VoQtBChTiSQCumROF+BsoMFpP+W
         FMlg==
X-Forwarded-Encrypted: i=1; AFNElJ8Bq3UCHhY62YI01bekm2dJ7SWTpbLRlA1atmxZto4tUoMogv7U3eRPLNcZhzPMnCzqFeeL/Lg=@lists.linux.dev
X-Gm-Message-State: AOJu0YzxZ5pgF8tNwhQebEWxVT4U5aHH+fr0DDa3tPADLUq0fLLfLlUk
	d2v6QM9iBOc/XZKr/MWIugW04mWp3QWwR4znTH3XYOMEDR+YOgPoBEmcGGyBrdPRO3awHl/RDNL
	w3kJ2arExib3cIxLEVHSVxwhZH4PlnoW4oFTOdEIz
X-Gm-Gg: AfdE7cn2si8z46fADz/YV5GIdAS6VqkSyq5iWKS2wZpj97/M5bzG4rWry8gYYdwbMUJ
	OPulzLA2aRXwyGyOEJnmzKa9KhqdfBfnPEU3qfdjVvglrtRnCG6mspP1sWUvcrHDlWTSfmapuSX
	fXDDgYf0zWUd8VjgBMFTsXD6+a/u9+k3GbnfjBbM990aEsC7DSUuc3aRIgMysqnZAVcFWEtUSWZ
	+Qdqfm6cSJUDqr5qUIiZEfrP1K+XN/N4f1i9l+Nw6BGSRgfq+ARtLPTFAq9FKpYCCwSFQFEaGn/
	j/LtdLvWpsNwT/ronREtPn9LGPErG9gQYc4F9+PLH14Y9D58EgI95ImiWMH2zhtMiv4UW9rR7pH
	ZjwcConIpnBay1zoRBTFiN4ce6f5Nb/cYQHQJx5fXMw==
X-Received: by 2002:a05:6808:4fec:b0:46c:e542:cc3e with SMTP id
 5614622812f47-489aeaa5629mr10774092b6e.6.1782147610847; Mon, 22 Jun 2026
 10:00:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <6a396189.af26c8ab.2133ed.0002.GAE@google.com>
In-Reply-To: <6a396189.af26c8ab.2133ed.0002.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Mon, 22 Jun 2026 18:59:59 +0200
X-Gm-Features: AVVi8Cc7B8Ggimof32dOY100NrU4o-goRr-Y_hH3A7PRnhZdWNnDJsrMZuGpgpg
Message-ID: <CANp29Y7vJzmCSZ3qaBunHhqH-ZXcMRm5w=8aZTtaNM-N_Z9CSg@mail.gmail.com>
Subject: Re: [moderation/CI] Re: mm: page_ext: add count limit to
 page_ext_iter_next to prevent invalid PFN access
To: syzbot ci <syzbot+ci9034b419fa5cb4c6@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Mon, Jun 22, 2026 at 6:23=E2=80=AFPM syzbot ci
<syzbot+ci9034b419fa5cb4c6@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v2] mm: page_ext: add count limit to page_ext_iter_next to prevent inval=
id PFN access
> https://lore.kernel.org/all/20260622-page_ext-v2-1-135d4cfbc42f@oss.qualc=
omm.com
> * [PATCH v2] mm: page_ext: add count limit to page_ext_iter_next to preve=
nt invalid PFN access
>
> and found the following issue:
> WARNING in depot_fetch_stack
>
> Full report is available here:
> https://ci.syzbot.org/series/092dd7dc-cb78-46b6-8703-6044fff2631d
>
> ***
>
> WARNING in depot_fetch_stack
>
> tree:      mm-new
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/=
mm.git
> base:      e1201ff76176ef666b13d1a4ec6b6190ddc6abc8
> arch:      amd64
> compiler:  Debian clang version 22.1.6 (++20260514074242+fc4aad7b5db3-1~e=
xp1~20260514074407.73), Debian LLD 22.1.6
> config:    https://ci.syzbot.org/builds/18f461a2-7098-44bc-9d42-634b56ba4=
8d9/config
>
> ------------[ cut here ]------------
> !refcount_read(&stack->count)
> WARNING: lib/stackdepot.c:517 at depot_fetch_stack+0x91/0xa0, CPU#0: kwor=
ker/u9:4/1114
> Modules linked in:
> CPU: 0 UID: 0 PID: 1114 Comm: kworker/u9:4 Not tainted syzkaller #0 PREEM=
PT(full)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Workqueue: events_unbound call_usermodehelper_exec_work
> RIP: 0010:depot_fetch_stack+0x91/0xa0
> Code: 39 f5 72 d0 48 8d 3d 7e 1b 4d 0b 89 ee 44 89 f2 89 d9 67 48 0f b9 3=
a 31 c0 5b 41 5e 5d e9 87 67 b8 06 cc 90 0f 0b 90 eb ee 90 <0f> 0b 90 eb e8=
 66 2e 0f 1f 84 00 00 00 00 00 90 90 90 90 90 90 90
> RSP: 0000:ffffc900079a6ce0 EFLAGS: 00010246
> RAX: ffff888168b94000 RBX: 0000000000000ce0 RCX: 0000000000000067
> RDX: 0000000000000000 RSI: ffffffff8e215937 RDI: ffffffff8c28ab20
> RBP: 0000000000000067 R08: ffff88810495a407 R09: 1ffff1102092b480
> R10: dffffc0000000000 R11: ffffed102092b481 R12: 00000000019c0068
> R13: 0000000000000001 R14: 000000000000010f R15: ffff88810afb1dc0
> FS:  0000000000000000(0000) GS:ffff88818dcb5000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: ffff88823ffff000 CR3: 000000000e74a000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  __set_page_owner+0x140/0x4c0
>  post_alloc_hook+0x1f9/0x250
>  get_page_from_freelist+0x21fa/0x2270
>  __alloc_frozen_pages_noprof+0x18d/0x380
>  alloc_pages_mpol+0x212/0x380
>  alloc_pages_noprof+0xac/0x2a0
>  get_free_pages_noprof+0xf/0x80
>  __kasan_populate_vmalloc+0x38/0x1c0
>  alloc_vmap_area+0xd1a/0x1420
>  __get_vm_area_node+0x1f2/0x300
>  __vmalloc_node_range_noprof+0x358/0x1730
>  __vmalloc_node_noprof+0xc2/0x100
>  dup_task_struct+0x28e/0x830
>  copy_process+0x79d/0x4380
>  kernel_clone+0x2d7/0x940
>  user_mode_thread+0x110/0x180
>  call_usermodehelper_exec_work+0x5c/0x230
>  process_scheduled_works+0xa8e/0x14e0
>  worker_thread+0xa47/0xfb0
>  kthread+0x389/0x470
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
> To test a patch for this bug, please reply with `#syz test`
> (should be on a separate line).
>
> The patch should be attached to the email.
> Note: arguments like custom git repos and branches are not supported.
>
> The email will later be sent to:
> [akpm@linux-foundation.org david@kernel.org hannes@cmpxchg.org jackmanb@g=
oogle.com kernel@oss.qualcomm.com ketan.kishore@oss.qualcomm.com liam@infra=
dead.org linux-kernel@vger.kernel.org linux-mm@kvack.org ljs@kernel.org lui=
zcap@redhat.com mhocko@suse.com rppt@kernel.org stable@vger.kernel.org sure=
nb@google.com vbabka@kernel.org willy@infradead.org ziy@nvidia.com]
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
-upstream-moderation/6a396189.af26c8ab.2133ed.0002.GAE%40google.com.
