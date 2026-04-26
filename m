Received: from mail-oo1-f54.google.com (mail-oo1-f54.google.com [209.85.161.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 847111DF25C
	for <syzbot@lists.linux.dev>; Sun, 26 Apr 2026 19:01:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.161.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777230072; cv=pass; b=tRGq+apR86//C7M9Y5dCj92+0VcTlzmC917NnJiBoqwhCWi05BaV/BYZi1AE72TPyRLalcxt0fbnHp6vDsD9vpOscQ4T6vMWKwj1uoUNhmeuAlNEtDPPfJjfovi5ED1V+oayrpkbRLXC//2xXCu6TvOUetFZJ9AobMr0u30P+pw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777230072; c=relaxed/simple;
	bh=UPPONXZo6FKd/jYSRKLIBYmjo/9hSRzBUNEcQZdiB7k=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=m2GJOApVZxPLBnfXOvPKC3LYs+wT069RvH3pKge8pt03sgXg5yD8P2T3LVzmApjf+RZcDR9+csTTVeVd8EVM3J3sqm35soeS6x7ijq20W4DcbqH476rfZpvyotg5CqZZt5FtLZV/w3oPzhYYCZ3GqEsePwDmCnu6s/kVZlgsqrU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KCXE55Hy; arc=pass smtp.client-ip=209.85.161.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KCXE55Hy"
Received: by mail-oo1-f54.google.com with SMTP id 006d021491bc7-66f747175d8so4795251eaf.0
        for <syzbot@lists.linux.dev>; Sun, 26 Apr 2026 12:01:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777230069; cv=none;
        d=google.com; s=arc-20240605;
        b=P61i3Lw9ufloOnCVtiOH7/+Cux2hJ/+RD/bkvYyZIUjhKSesalD1PoOI45KRYc4Cc1
         IXgLughRsKTQqzDXDJwGueyurvOqXPWTl+Y4Y9znhTt3jgz5FEwabBE6JRaAESWR1sfD
         cji+Ypx22OvL2KxELEvVaIr1jyiG2Q+2kDY8uInqMIMmJofA/amFpoauXXUnPU9cLt8w
         oYY81sL4/hScwEu8FyUHRkERGeeLHs2j8JvLWMll/OJFExJ/8kT1E/T3+wYUcSKQiAjF
         DZ8lCsbCefqZW5N6dbHK1XfnTC9KEQ/0sgk3rOkruXA6bjdcGM9X1PRvVZpjF/5yW6Zn
         e9Ng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=8EXoswaChD9c9bQp4Y7ErHV/sCDHPybxlFVKOdCvz34=;
        fh=Um5yy7sH6wBnl1EVRfUyBTT3sP3elYT8tw/JnA7Ng1c=;
        b=a0RtHZ/ceHRZo0mOwr8feEp+V75GI1BBXWCjzYX5+xtKtSXBYLH0UYEOtRkuf7oiVf
         ROU+fvsHN3t916Z722PpMe8loMrlNxn6zhzaubC8LdFdf3LgsLSGXbmxyQht+IYxVBg/
         yD5sH9L/AOIN+cz4uBHWcfIyPJ95ZcNL75yKbkVm87FpQ+39C6EBbPhTxeOJ3CxCVMRr
         GFzBMGTuuT0mEIj1xbGakZk7XXTVvufnkePHS54015Upp87lpKxl+GLrga/roQmptEsp
         EcroXr2yhqK3Dkhx5UmL/kYKrJeVGUkg0w2fja2kMM6owE018+H+ZJXkFaFkwBywuwZ+
         ut2A==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777230069; x=1777834869; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8EXoswaChD9c9bQp4Y7ErHV/sCDHPybxlFVKOdCvz34=;
        b=KCXE55HyTNQfBsPA1nv7uDN/eQUFX0o590EgF5GMz7XID54YtNpRcX6wnWOm7UKWfW
         2Ij8sUm/1jHI43eNe8pL7FxbtsyBSvxRhFT19DgpZkNY5cytE5BHmY5utuLMF4TZ9y2/
         YCiRN1obiNMptxzQ0tY/ZPlNMoW1EsV/UTNY4K3NBBmAuBLEe1pry35IiadfGvdvK0VZ
         7Tv67RuRryKzPdDfwXsrkcNh12kBkFafMPMGuJqRBjiDKjx1Bcnv3ND5KqL1I2bNfecj
         +KP4+7Gu2dl1fE+4s7pKmEf9OHxx0cpKEuviRx7tHxwLMAoUIORxeUyYa8ffb1cKHaRR
         hoiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777230069; x=1777834869;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=8EXoswaChD9c9bQp4Y7ErHV/sCDHPybxlFVKOdCvz34=;
        b=GfTp93jXn5TvYBnN+1xKnwDlg7qIT8F0F54Dqr75mRkwoGsSTAuD/5PbQkDtATW4qj
         5Se4Tnd9/8qmqJ64MV/N0/LS5MH/fJjUJUZWI3kK0u4km6oeYSxcydFs4ZlarmFqYpHT
         mVQquGeeBwyhmo+tzwW9vwFb9DqVt3LevjE+K6l4Tw1YQFGN0sTkPl8K4iWWh1zviEut
         XGRKPh0msfjZLCTEyGJBItTxN7jc+GmTKETLqBb3pSCeHqhMan5Vi0WYjs3I71kwM2Nd
         AKb2Ee4p9JFTEKRKKhv44SvNQvKcnE3+UEnoV+1zUcPSHLIr/eykVfKGvZ/2EoC4K7i8
         WKbw==
X-Forwarded-Encrypted: i=1; AFNElJ+Jeg/v7eqim60GWzwXaPoLRG1RcgqAeuQ6DVFSVTmDmyRReSyBdE3hHcqYwQKOVNylZfmgbDk=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw4QWafqL4W3EV5D2OyZpCnnXq93aQDKY+XNxKiiT1aQMxPIo1X
	HFg4gvmbxpUaGaJpyMdO0SN556QkLT0hcRxSFwVe3qrqWLc9yFnfaFR4Ytpftyg/zdrDDfhvg4V
	k2SQFqoryIpXT9Snfcrn6MjoU3NzQP7YZSrUZzwU2
X-Gm-Gg: AeBDieuOuwKLdJCWKe6jzkWlDzQ4hnaopclsYSOQpb6YuIl9sH81qJowRoMgLUhsogm
	CaD1L3D/k1Kq2MDAFsBs+yTQMlYqXWXuPa6ADBG9AcAaQ6ow6++K9Bd7Q4BjMDavfgwh5wG7GX9
	aRJNJlpizsdjFTrTrrDvQLfRkABbMNTUnBhwcEPMVDz86wtf159nMrTVKPqWY3xIOVw4SqfBq00
	D1jrkjE0Q7O1wNKrHkOK0LzaRMthA23DntPx2fpkox0WDkfSh4UIobojPk3xFIcz9dmrHHzRwDh
	4vwzUkemW5ekK+M0JeS0d8DkUglhvZ4uflTTAmDS7C8IzzKyr8r3NGvZQDezSRnezd0a6m1qPd7
	m4kIPy9cb9UBYGj74yTm/IXMzBpM=
X-Received: by 2002:a05:6820:2002:b0:694:9a8a:2ce with SMTP id
 006d021491bc7-6949a8a0f5amr12988113eaf.8.1777230069075; Sun, 26 Apr 2026
 12:01:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <69ee35ed.a00a0220.316485.0004.GAE@google.com>
In-Reply-To: <69ee35ed.a00a0220.316485.0004.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Sun, 26 Apr 2026 21:00:57 +0200
X-Gm-Features: AVHnY4KST2LdW-zqNz1Y-nW2YrWCQq550U-_95cN-9cFQpGKx-p5COdrhNVrNsA
Message-ID: <CANp29Y5YH-Lu+1NmEWnWd7M-k5O=TbpTZQpmytrdUGfRwJMFSg@mail.gmail.com>
Subject: Re: [moderation/CI] Re: mm: improve write performance with RWF_DONTCACHE
To: syzbot ci <syzbot+ci5ae010b5f41f7212@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Sun, Apr 26, 2026 at 5:57=E2=80=AFPM syzbot ci
<syzbot+ci5ae010b5f41f7212@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v3] mm: improve write performance with RWF_DONTCACHE
> https://lore.kernel.org/all/20260426-dontcache-v3-0-79eb37da9547@kernel.o=
rg
> * [PATCH v3 1/4] mm: add NR_DONTCACHE_DIRTY node page counter
> * [PATCH v3 2/4] mm: kick writeback flusher for IOCB_DONTCACHE with targe=
ted dirty tracking
> * [PATCH v3 3/4] testing: add nfsd-io-bench NFS server benchmark suite
> * [PATCH v3 4/4] testing: add dontcache-bench local filesystem benchmark =
suite
>
> and found the following issue:
> WARNING in __mod_memcg_lruvec_state
>
> Full report is available here:
> https://ci.syzbot.org/series/e53aef43-ac7a-4cb7-8714-bb927aaee659
>
> ***
>
> WARNING in __mod_memcg_lruvec_state
>
> tree:      torvalds
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torva=
lds/linux
> base:      27d128c1cff64c3b8012cc56dd5a1391bb4f1821
> arch:      amd64
> compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~e=
xp1~20251221153213.50), Debian LLD 21.1.8
> config:    https://ci.syzbot.org/builds/c10ddd10-bb16-48c2-90fb-3625d3b25=
8aa/config
> syz repro: https://ci.syzbot.org/findings/1e8993c1-818b-4ddf-b90b-30f051b=
3a9d6/syz_repro
>
> ------------[ cut here ]------------
> __mod_memcg_lruvec_state: missing stat item 21
> WARNING: mm/memcontrol.c:911 at __mod_memcg_lruvec_state+0x1f3/0x360 mm/m=
emcontrol.c:911, CPU#0: syz.0.17/5831
> Modules linked in:
> CPU: 0 UID: 0 PID: 5831 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:__mod_memcg_lruvec_state+0x1fc/0x360 mm/memcontrol.c:911
> Code: 00 11 85 c0 74 31 48 83 c4 08 5b 41 5c 41 5d 41 5e 41 5f 5d e9 95 2=
e 72 09 cc 48 8d 3d 7d c4 fd 0d 48 c7 c6 5d b4 f5 8d 89 da <67> 48 0f b9 3a=
 eb d5 90 0f 0b 90 eb 90 e8 02 22 fb fe eb c8 48 8d
> RSP: 0018:ffffc900039e7520 EFLAGS: 00010046
> RAX: 0000000000000000 RBX: 0000000000000015 RCX: dffffc0000000000
> RDX: 0000000000000015 RSI: ffffffff8df5b45d RDI: ffffffff90363d90
> RBP: 0000000000000001 R08: ffffffff82388833 R09: ffffffff8e95cd60
> R10: dffffc0000000000 R11: fffff940008c3f49 R12: ffff8881026eee80
> R13: 00000000000000ff R14: 0000000000000001 R15: ffff888173a80e00
> FS:  00007f5f76bca6c0(0000) GS:ffff88818dc95000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 000055d77c624128 CR3: 0000000171fde000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  mod_memcg_lruvec_state+0xa7/0x220 mm/memcontrol.c:941
>  mod_lruvec_state mm/memcontrol.c:964 [inline]
>  lruvec_stat_mod_folio+0x239/0x3e0 mm/memcontrol.c:984
>  folio_account_dirtied mm/page-writeback.c:2634 [inline]
>  __folio_mark_dirty+0x633/0xec0 mm/page-writeback.c:2692
>  mark_buffer_dirty+0x261/0x410 fs/buffer.c:1110
>  block_commit_write+0x15d/0x270 fs/buffer.c:2115
>  block_write_end+0x6e/0xb0 fs/buffer.c:2191
>  ext4_write_end+0x27d/0xa30 fs/ext4/inode.c:1458
>  ext4_da_write_end+0x86/0xcb0 fs/ext4/inode.c:3296
>  generic_perform_write+0x620/0x8f0 mm/filemap.c:4350
>  ext4_buffered_write_iter+0xcb/0x370 fs/ext4/file.c:316
>  ext4_file_write_iter+0x298/0x1bd0 fs/ext4/file.c:-1
>  do_iter_readv_writev+0x619/0x8c0 fs/read_write.c:-1
>  vfs_writev+0x33c/0x990 fs/read_write.c:1059
>  do_pwritev fs/read_write.c:1155 [inline]
>  __do_sys_pwritev2 fs/read_write.c:1213 [inline]
>  __se_sys_pwritev2+0x184/0x2a0 fs/read_write.c:1204
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x15f/0xf80 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f5f75d9cdd9
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007f5f76bca028 EFLAGS: 00000246 ORIG_RAX: 0000000000000148
> RAX: ffffffffffffffda RBX: 00007f5f76015fa0 RCX: 00007f5f75d9cdd9
> RDX: 0000000000000001 RSI: 00002000000001c0 RDI: 0000000000000004
> RBP: 00007f5f75e32d69 R08: 0000000000000001 R09: 0000000000000081
> R10: 0000000000000003 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f5f76016038 R14: 00007f5f76015fa0 R15: 00007fffe7503ad8
>  </TASK>
> ----------------
> Code disassembly (best guess):
>    0:   00 11                   add    %dl,(%rcx)
>    2:   85 c0                   test   %eax,%eax
>    4:   74 31                   je     0x37
>    6:   48 83 c4 08             add    $0x8,%rsp
>    a:   5b                      pop    %rbx
>    b:   41 5c                   pop    %r12
>    d:   41 5d                   pop    %r13
>    f:   41 5e                   pop    %r14
>   11:   41 5f                   pop    %r15
>   13:   5d                      pop    %rbp
>   14:   e9 95 2e 72 09          jmp    0x9722eae
>   19:   cc                      int3
>   1a:   48 8d 3d 7d c4 fd 0d    lea    0xdfdc47d(%rip),%rdi        # 0xdf=
dc49e
>   21:   48 c7 c6 5d b4 f5 8d    mov    $0xffffffff8df5b45d,%rsi
>   28:   89 da                   mov    %ebx,%edx
> * 2a:   67 48 0f b9 3a          ud1    (%edx),%rdi <-- trapping instructi=
on
>   2f:   eb d5                   jmp    0x6
>   31:   90                      nop
>   32:   0f 0b                   ud2
>   34:   90                      nop
>   35:   eb 90                   jmp    0xffffffc7
>   37:   e8 02 22 fb fe          call   0xfefb223e
>   3c:   eb c8                   jmp    0x6
>   3e:   48                      rex.W
>   3f:   8d                      .byte 0x8d
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
> [akpm@linux-foundation.org axboe@kernel.dk axelrasmussen@google.com baohu=
a@kernel.org brauner@kernel.org chuck.lever@oracle.com david@kernel.org hch=
@infradead.org jack@suse.cz jlayton@kernel.org kasong@tencent.com liam.howl=
ett@oracle.com linux-fsdevel@vger.kernel.org linux-kernel@vger.kernel.org l=
inux-mm@kvack.org linux-nfs@vger.kernel.org linux-trace-kernel@vger.kernel.=
org ljs@kernel.org mathieu.desnoyers@efficios.com mhiramat@kernel.org mhock=
o@suse.com qi.zheng@linux.dev ritesh.list@gmail.com rostedt@goodmis.org rpp=
t@kernel.org shakeel.butt@linux.dev snitzer@kernel.org surenb@google.com vb=
abka@kernel.org viro@zeniv.linux.org.uk weixugc@google.com willy@infradead.=
org yuanchu@google.com]
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
-upstream-moderation/69ee35ed.a00a0220.316485.0004.GAE%40google.com.
