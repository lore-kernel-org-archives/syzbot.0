Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAE2D1DFDA1
	for <syzbot@lists.linux.dev>; Mon, 13 Jul 2026 16:43:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783961002; cv=none; b=KNUy9dfafSVYMuYjTosjQL0zqrdfMOeNZXCVwz41iIq+G7/hZui/0/mdWrnqfSNP11BgBUveAkz75PC+2ln3V1dzd+dzZb2a+ZbqxJr9KFCi3I1h7OjvZyocIWmTaF7noSX8MrEc8LqE86c80iwMQjrHPbILxCRyDNwNvLGJ0Lw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783961002; c=relaxed/simple;
	bh=hwzze2P4d2/sE2vYRfkhrCPGHb3rM6NMWnhpCzr5Kvg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DIWumDghjzjOMAAMz4a2FYJnJ+MhmbJYxVw57FkHeL0lqAhHttgt4RtMkcLaALVjWCgVFHAlfGc1MDD0eyMDQ/2ThTi4zCtop3yyyeARHg9fb6w60ctgd53l0sCT6BYPf7511bXlol3JBiItODkTA0Gw3sGrJXOgpCAc6d1zN9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Dpal/7uF; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Dpal/7uF"
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-475cb71a4ebso3278358f8f.0
        for <syzbot@lists.linux.dev>; Mon, 13 Jul 2026 09:43:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783960997; x=1784565797; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=egO0BBSSmMb+8SLbHwzs83itVcl/KLzLl6aTaxXhlK0=;
        b=Dpal/7uFrLVbOQxaWm3CC+KYc2urDLyjH6MwhOAok2J1vTdMkjZDBlDMHINA3S+l8w
         xLVAngWjLZvxoEuOAcmfvFJ3zfcjNR91GNM2BscFqdEaqswZ6W0SSjIJHatzI9LwYKdc
         UVNAklUaNL2EUhlLLFLBdzFWHzPNJZ78iOtp4Qhhx6nQkROTbXoZmhke1mP4+d5bPDn9
         y0LbLywF/AiUSvee/936Tj6tkvkoVNGrvVbFDUMbNd9vZr3Aicec2CC+J2vdCmVmGqYH
         0/EXvdigH0mcgnBzXe0msACgQgXBi8LWuME9OQGi5Yx91CgTIRojxhqJrPP04cAbrQ42
         LjyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783960997; x=1784565797;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=egO0BBSSmMb+8SLbHwzs83itVcl/KLzLl6aTaxXhlK0=;
        b=RgAzMGlWBdXJCrDdTfr3n0lI9QZRgmUpOKMK6YEna2TPde29UNeygZmSvtFZL424/w
         CSgnV/JPC71NAPY3NiyQd/5PfE/HIGt5A4MRI8TmvWURQ890D1rw6WraLQ6eWtdv84ve
         YJwSI3fVGfesBbMTwOdXFPppDpfs1/uD1tbuqdHd6kwsaICfFmZWm4kbdhNY0+5DKTl+
         4VzZOaW2HDLUP9SgmRlTL9cMMpKj2r/jdHyYJV6+9oqNeDV09zP2l2MWW4bTeMD+41UL
         UAw3deRFrHMbVtrC1MShwplMzUnIh6cXqCfOY4peya3iHZJsYUK0vzOmMinvfGipAhOA
         r3iA==
X-Forwarded-Encrypted: i=1; AHgh+RpANKJ6EF5OIj9bqj4yL/4YL+d+97mOxKenEkd6SXZ50mSiQ17Df+M6LiuLdsr+f9GJ2on4Jpo=@lists.linux.dev
X-Gm-Message-State: AOJu0YyEkP1tjvGeSRkRf2R8Cyhx9zkoBEGYpdlFgAi2ChUYk5XDjQpQ
	tnR9JbpAVb/ADav3KZHqkUppgcwfD7iyJRH3B8bSXR3GTZDgYNA+eByfZ+lXFDSz66g=
X-Gm-Gg: AfdE7cnDtazxmDtHmZ8TkZChlgHsCLdFPyVwrWEye9buWdGfr0qiAWm+TIhv3XOKX2p
	HmB51iayZMfhSIlxj588/snucw04QVXMYW6/ppunFu/KVklOesvrTD29Ars8GhXdIN6ONoiLX0a
	ZG6C0qLpL1U/0fJAb7BtEkjohsTEl1WfOL3jJO+5skJ1dHdFqCNxZ3Z/AQezFOXqcgc3ec2qFKX
	LXWw//eCIH49ySV7bofluT66yoSuf0V2rWDF/Q2M8rcZznd8noU3p42qIUlKWXutTQLwxWilzmF
	g7YwwxnR0TWjSYipCk9uEXxLST9eYWMUdBoRstSBXqgu5D+jdUXgJBX6LgzRfJ+bCJCaTsuXyVu
	bnuaV9zopOfqQi4ey1ZGOVGsybTJBXOpsUhc+sk+od53IvXBhkTSyjwS1Qzc9Y4S+Kf1/wHJne5
	IkubNM0m4EQXuttpON8gxtvM4YbutrvbuY38JN1Q==
X-Received: by 2002:a05:6000:22c5:b0:46d:d6e0:9cc8 with SMTP id ffacd0b85a97d-47f2dcfcd4amr11175720f8f.46.1783960996713;
        Mon, 13 Jul 2026 09:43:16 -0700 (PDT)
Received: from localhost ([37.30.50.91])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f464b7f09sm558676f8f.26.2026.07.13.09.43.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2026 09:43:16 -0700 (PDT)
Date: Mon, 13 Jul 2026 18:43:15 +0200
From: Bartosz Chronowski <immersa.bartosz.chronowski@gmail.com>
To: syzbot <syzbot@kernel.org>, 
	syzbot+a843f6ae2130a987d63b@syzkaller.appspotmail.com
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Subject: Re: [PATCH RFC] jfs: replace BUG() with error return in txLock()
Message-ID: <cwurrj7snyy6v5nfyw2pje5slhayb2lh4lxa4jf2xkjsg5qql4@gbkcndau4g7c>
References: <9d2eba88-93bf-4f3c-a3b2-b554e1fffe80@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9d2eba88-93bf-4f3c-a3b2-b554e1fffe80@mail.kernel.org>

Rewrite patch from the JFS block-map boundary, not from txLock().

This feedback is per syzbot bug page reproducer path. Aim to fix all possible
`kernel BUG in txLock` paths.

The syzbot AI patch states the ground failure correctly: "a block can be
incorrectly marked as free in the bmap while it is actually in use as an inode
table block."

The implementation fixes where the bug got exposed (the crash sink), not the
place that lets that impossible state form. txLock() only shows that a normal
fileset metapage is already transaction-locked by another transaction. If
directory split code got a block that is already used or locked as different
metadata, the bad allocation already escaped.

Please rewrite the patch so the allocator stops returning overlapping or stale
blocks. Validate JFS dmap/block-map metadata before allocation, free, or
pmap-update users trust it, and reject inconsistent dmap header, range, tree,
and bitmap state with -EIO.

Do not convert txLock() into an ERR_PTR-returning API. Keep txLock() as the
transaction invariant detector and fix the bug at the dmap/block-map validation
boundary before tree, quota, metapage, dirty, or transaction state can be
mutated from already incorrect allocation data.

Please create a loop and iterate on the solution until all acceptance criteria below pass:

Stop condition: if an iteration cannot make technical progress toward these
criteria, do not keep sending equivalent patch versions. Stop the loop, state
which criteria still fail, explain the blocker, and say what evidence or design
change is required before another version is useful.

1. Root Cause: identify the bmap/dmap validation bug as the cause, and keep
   txLock() separate as where the bug got exposed (the crash sink).
2. Approach: stop the allocator from returning overlapping or stale blocks by
   validating JFS dmap/block-map metadata before allocator, free, or
   pmap-update users trust it.
3. Patch Description: describe crafted JFS dmap corruption, the validation
   boundary, and the -EIO failure mode in normal kernel commit-message style,
   using only kernel-standard attribution.
4. To/Cc List: run get_maintainer.pl for the actual rewritten files and use the
   JFS maintainer, JFS list, LKML, and relevant history-based recipients.
5. Fixes Tag: include a Fixes tag only if history proves the commit introduced
   the dmap/bmap trust bug that the rewritten fix changes. Do not use the
   initial JFS import, the commit that added the `txLock()` assertion, or any
   other crash-sink history unless it also introduced the allocator-side stale
   or overlapping-block condition being fixed.
6. Kernel RCA Criteria: reconstruct the syzbot bug page triggering path,
   separate cause from crash sink, reject wrong alternatives, and prove the fix
   covers the allocator invariant break.
7. checkpatch.pl: run scripts/checkpatch.pl on the rewritten patch and make it
   pass with 0 errors and 0 warnings.
8. checkpatch.pl --strict: run scripts/checkpatch.pl --strict on the same
   rewritten patch and iterate until strict has no unresolved findings.
9. Performance Review: avoid unnecessary hot-path churn, new lock contention,
   allocations in critical sections, algorithmic complexity increases, and
   unjustified branch hints.
10. Regression-Risk Review: preserve the txLock() return contract and avoid
    broad caller churn; the rewritten fix should not require new txLock()
    ERR_PTR handling across dtree, xtree, imap, or namei callers.
11. Logic Review: enforce the dmap header, range, tree, and bitmap invariants
    before JFS allocates, frees, or updates pmap state from the page.
12. Security Impact Review: fail closed on malformed JFS metadata before it can
    drive allocator decisions or mutate other metadata state.
13. Memory Management and Lifetime Review: prove every error path releases or
    preserves metapages, tlocks, transactions, quota state, dirty state, and
    linelock state correctly.
14. Focused Condition Checks: pass invariant/boundary, API/return-contract,
    error-unwind/state-consistency, corruption-handling, and verification
    mapping checks.
15. Verification Mapping: state what each check proves, including apply,
    checkpatch, strict checkpatch, build, reproducer/no-repro, and targeted
    regression coverage.
16. Reproducer Validation: prove the syzbot bug page reproducer path is no
    longer reproducible with the rewritten patch; ideally also validate
    adjacent paths that can reach `kernel BUG in txLock` and document no-repro
    results or remaining gaps.

On Mon, Jun 29, 2026 at 10:55:11PM +0000, syzbot wrote:
> A corrupted JFS filesystem image can cause a concurrency issue where the
> block allocation map (bmap) and the inode map are out of sync.
> Specifically, a block can be incorrectly marked as free in the bmap while
> it is actually in use as an inode table block.
> 
> This corruption can lead to a race condition between the VFS writeback
> thread and a user thread. For example, the writeback thread might lock the
> inode table block's metapage to write a dirty inode. Concurrently, a user
> thread might allocate the exact same block for a directory btree split (due
> to the corrupted bmap) and attempt to lock its metapage. This causes
> txLock() to detect that the metapage is already locked by a different
> transaction for a non-aggregate inode, triggering a BUG():
> 
> ------------[ cut here ]------------
> kernel BUG at fs/jfs/jfs_txnmgr.c:836!
> Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
> CPU: 0 UID: 0 PID: 5543 Comm: syz.0.52 Not tainted
> RIP: 0010:txLock+0x1cc3/0x1d10 fs/jfs/jfs_txnmgr.c:836
> ...
> Call Trace:
>  <TASK>
>  dtSplitRoot+0x38d/0x18a0 fs/jfs/jfs_dtree.c:1924
>  dtSplitUp fs/jfs/jfs_dtree.c:990 [inline]
>  dtInsert+0xeb2/0x5890 fs/jfs/jfs_dtree.c:868
>  jfs_create+0x730/0xae0 fs/jfs/namei.c:138
>  lookup_open fs/namei.c:4508 [inline]
>  open_last_lookups fs/namei.c:4608 [inline]
>  path_openat+0x133a/0x3830 fs/namei.c:4856
>  do_file_open+0x23e/0x4a0 fs/namei.c:4888
>  do_sys_openat2+0x115/0x200 fs/open.c:1368
>  do_sys_open fs/open.c:1374 [inline]
>  __do_sys_open fs/open.c:1382 [inline]
>  __se_sys_open fs/open.c:1378 [inline]
>  __x64_sys_open+0x11e/0x150 fs/open.c:1378
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x15f/0x560 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>  </TASK>
> 
> To fix this, replace the BUG() in txLock() with a call to jfs_error() to
> mark the filesystem as corrupted, and return ERR_PTR(-EIO) to gracefully
> handle the error.
> 
> Since txLock() can now return an error pointer, update all of its callers
> across the JFS codebase to check for IS_ERR() and properly propagate the
> error up the call stack. This includes changing the return types of several
> helper functions (such as lock_index(), free_index(), modify_index(),
> dtInitRoot(), xtInitRoot(), and dtInsertEntry()) from void to int, and
> ensuring that resources like pinned metapages are properly released on the
> new error paths.
> 
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Assisted-by: good-balanced Gemini:gemini-3.1-pro-preview Gemini:gemini-3-flash-preview best-expensive syzbot
> Reported-by: syzbot+a843f6ae2130a987d63b@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=a843f6ae2130a987d63b
> Link: https://syzkaller.appspot.com/ai_job?id=62ec5f45-38f7-4129-96f4-2509f8ed6b21
> To: <jfs-discussion@lists.sourceforge.net>
> To: "Dave Kleikamp" <shaggy@kernel.org>
> Cc: "Arnd Bergmann" <arnd@arndb.de>
> Cc: "Christian Brauner (Amutable)" <brauner@kernel.org>
> Cc: "Damien Le Moal" <dlemoal@kernel.org>
> Cc: "Jan Kara" <jack@suse.cz>
> Cc: "Jori Koolstra" <jkoolstra@xs4all.nl>
> Cc: "Jeff Layton" <jlayton@kernel.org>
> Cc: "Kees Cook" <kees@kernel.org>
> Cc: <linux-kernel@vger.kernel.org>
> Cc: "Mateusz Guzik" <mjguzik@gmail.com>
> Cc: "Richard Weinberger" <richard@nod.at>
> Cc: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> Cc: "Shaurya Rane" <ssrane_b23@ee.vjti.ac.in>
> Cc: "Suchit Karunakaran" <suchitkarunakaran@gmail.com>
> Cc: "Al Viro" <viro@zeniv.linux.org.uk>
> Cc: "Yun Zhou" <yun.zhou@windriver.com>
> Cc: "Hongling Zeng" <zenghongling@kylinos.cn>
> Cc: "Zheng Yu" <zheng.yu@northwestern.edu>
> 
> ---
> diff --git a/fs/jfs/jfs_dtree.c b/fs/jfs/jfs_dtree.c
> index 8ce6e4458..936e408ab 100644
> --- a/fs/jfs/jfs_dtree.c
> +++ b/fs/jfs/jfs_dtree.c
> @@ -167,8 +167,8 @@ static void dtGetKey(dtpage_t * p, int i, struct component_name * key,
>  static int ciGetLeafPrefixKey(dtpage_t * lp, int li, dtpage_t * rp,
>  			      int ri, struct component_name * key, int flag);
>  
> -static void dtInsertEntry(dtpage_t * p, int index, struct component_name * key,
> -			  ddata_t * data, struct dt_lock **);
> +static int dtInsertEntry(dtpage_t *p, int index, struct component_name *key,
> +			 ddata_t *data, struct dt_lock **);
>  
>  static void dtMoveEntry(dtpage_t * sp, int si, dtpage_t * dp,
>  			struct dt_lock ** sdtlock, struct dt_lock ** ddtlock,
> @@ -286,14 +286,16 @@ static struct dir_table_slot *find_index(struct inode *ip, u32 index,
>  	return slot;
>  }
>  
> -static inline void lock_index(tid_t tid, struct inode *ip, struct metapage * mp,
> -			      u32 index)
> +static inline int lock_index(tid_t tid, struct inode *ip, struct metapage *mp,
> +			     u32 index)
>  {
>  	struct tlock *tlck;
>  	struct linelock *llck;
>  	struct lv *lv;
>  
>  	tlck = txLock(tid, ip, mp, tlckDATA);
> +	if (IS_ERR(tlck))
> +		return PTR_ERR(tlck);
>  	llck = (struct linelock *) tlck->lock;
>  
>  	if (llck->index >= llck->maxcnt)
> @@ -307,6 +309,8 @@ static inline void lock_index(tid_t tid, struct inode *ip, struct metapage * mp,
>  	lv->offset = ((index - 2) & 511) >> 1;
>  	lv->length = 1;
>  	llck->index++;
> +
> +	return 0;
>  }
>  
>  /*
> @@ -383,7 +387,13 @@ static u32 add_index(tid_t tid, struct inode *ip, s64 bn, int slot)
>  		/*
>  		 * Initialize empty x-tree
>  		 */
> -		xtInitRoot(tid, ip);
> +		if (xtInitRoot(tid, ip)) {
> +			memcpy(&jfs_ip->i_dirtable, temp_table,
> +			       sizeof(temp_table));
> +			dbFree(ip, xaddr, sbi->nbperpage);
> +			dquot_free_block(ip, sbi->nbperpage);
> +			goto clean_up;
> +		}
>  
>  		/*
>  		 * Add the first block to the xtree
> @@ -408,6 +418,13 @@ static u32 add_index(tid_t tid, struct inode *ip, s64 bn, int slot)
>  			goto clean_up;
>  		}
>  		tlck = txLock(tid, ip, mp, tlckDATA);
> +		if (IS_ERR(tlck)) {
> +			release_metapage(mp);
> +			xtTruncate(tid, ip, 0, COMMIT_PWMAP);
> +			memcpy(&jfs_ip->i_dirtable, temp_table,
> +			       sizeof(temp_table));
> +			goto clean_up;
> +		}
>  		llck = (struct linelock *) & tlck->lock;
>  		ASSERT(llck->index == 0);
>  		lv = &llck->lv[0];
> @@ -453,7 +470,10 @@ static u32 add_index(tid_t tid, struct inode *ip, s64 bn, int slot)
>  		goto clean_up;
>  	}
>  
> -	lock_index(tid, ip, mp, index);
> +	if (lock_index(tid, ip, mp, index)) {
> +		release_metapage(mp);
> +		goto clean_up;
> +	}
>  
>  	dirtab_slot =
>  	    (struct dir_table_slot *) ((char *) mp->data + page_offset);
> @@ -478,27 +498,31 @@ static u32 add_index(tid_t tid, struct inode *ip, s64 bn, int slot)
>   *
>   *	Marks an entry to the directory index table as free.
>   */
> -static void free_index(tid_t tid, struct inode *ip, u32 index, u32 next)
> +static int free_index(tid_t tid, struct inode *ip, u32 index, u32 next)
>  {
>  	struct dir_table_slot *dirtab_slot;
>  	s64 lblock;
>  	struct metapage *mp = NULL;
> +	int rc = 0;
>  
>  	dirtab_slot = find_index(ip, index, &mp, &lblock);
>  
>  	if (!dirtab_slot)
> -		return;
> +		return 0;
>  
>  	dirtab_slot->flag = DIR_INDEX_FREE;
>  	dirtab_slot->slot = dirtab_slot->addr1 = 0;
>  	dirtab_slot->addr2 = cpu_to_le32(next);
>  
>  	if (mp) {
> -		lock_index(tid, ip, mp, index);
> -		mark_metapage_dirty(mp);
> +		rc = lock_index(tid, ip, mp, index);
> +		if (!rc)
> +			mark_metapage_dirty(mp);
>  		release_metapage(mp);
>  	} else
>  		set_cflag(COMMIT_Dirtable, ip);
> +
> +	return rc;
>  }
>  
>  /*
> @@ -506,24 +530,28 @@ static void free_index(tid_t tid, struct inode *ip, u32 index, u32 next)
>   *
>   *	Changes an entry in the directory index table
>   */
> -static void modify_index(tid_t tid, struct inode *ip, u32 index, s64 bn,
> -			 int slot, struct metapage ** mp, s64 *lblock)
> +static int modify_index(tid_t tid, struct inode *ip, u32 index, s64 bn,
> +			int slot, struct metapage **mp, s64 *lblock)
>  {
>  	struct dir_table_slot *dirtab_slot;
> +	int rc = 0;
>  
>  	dirtab_slot = find_index(ip, index, mp, lblock);
>  
>  	if (!dirtab_slot)
> -		return;
> +		return 0;
>  
>  	DTSaddress(dirtab_slot, bn);
>  	dirtab_slot->slot = slot;
>  
>  	if (*mp) {
> -		lock_index(tid, ip, *mp, index);
> -		mark_metapage_dirty(*mp);
> +		rc = lock_index(tid, ip, *mp, index);
> +		if (!rc)
> +			mark_metapage_dirty(*mp);
>  	} else
>  		set_cflag(COMMIT_Dirtable, ip);
> +
> +	return rc;
>  }
>  
>  /*
> @@ -879,6 +907,10 @@ int dtInsert(tid_t tid, struct inode *ip,
>  	 * acquire a transaction lock on the leaf page
>  	 */
>  	tlck = txLock(tid, ip, mp, tlckDTREE | tlckENTRY);
> +	if (IS_ERR(tlck)) {
> +		DT_PUTPAGE(mp);
> +		return PTR_ERR(tlck);
> +	}
>  	dtlck = (struct dt_lock *) & tlck->lock;
>  	ASSERT(dtlck->index == 0);
>  	lv = & dtlck->lv[0];
> @@ -888,7 +920,11 @@ int dtInsert(tid_t tid, struct inode *ip,
>  	lv->length = 1;
>  	dtlck->index++;
>  
> -	dtInsertEntry(p, index, name, &data, &dtlck);
> +	rc = dtInsertEntry(p, index, name, &data, &dtlck);
> +	if (rc) {
> +		DT_PUTPAGE(mp);
> +		return rc;
> +	}
>  
>  	/* linelock stbl of non-root leaf page */
>  	if (!(p->header.flag & BT_ROOT)) {
> @@ -1256,9 +1292,15 @@ static int dtSplitUp(tid_t tid,
>  			 * acquire a transaction lock on the parent page
>  			 */
>  			tlck = txLock(tid, ip, smp, tlckDTREE | tlckENTRY);
> -			dtlck = (struct dt_lock *) & tlck->lock;
> +			if (IS_ERR(tlck)) {
> +				rc = PTR_ERR(tlck);
> +				DT_PUTPAGE(smp);
> +				DT_PUTPAGE(rmp);
> +				goto splitOut;
> +			}
> +			dtlck = (struct dt_lock *)&tlck->lock;
>  			ASSERT(dtlck->index == 0);
> -			lv = & dtlck->lv[0];
> +			lv = &dtlck->lv[0];
>  
>  			/* linelock header */
>  			lv->offset = 0;
> @@ -1270,13 +1312,18 @@ static int dtSplitUp(tid_t tid,
>  				lv++;
>  				n = skip >> L2DTSLOTSIZE;
>  				lv->offset = sp->header.stblindex + n;
> -				lv->length =
> -				    ((sp->header.nextindex -
> -				      1) >> L2DTSLOTSIZE) - n + 1;
> +				lv->length = ((sp->header.nextindex - 1) >>
> +					      L2DTSLOTSIZE) -
> +					     n + 1;
>  				dtlck->index++;
>  			}
>  
> -			dtInsertEntry(sp, skip, &key, data, &dtlck);
> +			rc = dtInsertEntry(sp, skip, &key, data, &dtlck);
> +			if (rc) {
> +				DT_PUTPAGE(smp);
> +				DT_PUTPAGE(rmp);
> +				goto splitOut;
> +			}
>  
>  			/* exit propagate up */
>  			break;
> @@ -1375,6 +1422,10 @@ static int dtSplitPage(tid_t tid, struct inode *ip, struct dtsplit * split,
>  	 * acquire a transaction lock on the new right page
>  	 */
>  	tlck = txLock(tid, ip, rmp, tlckDTREE | tlckNEW);
> +	if (IS_ERR(tlck)) {
> +		DT_PUTPAGE(rmp);
> +		return PTR_ERR(tlck);
> +	}
>  	rdtlck = (struct dt_lock *) & tlck->lock;
>  
>  	rp = (dtpage_t *) rmp->data;
> @@ -1388,6 +1439,10 @@ static int dtSplitPage(tid_t tid, struct inode *ip, struct dtsplit * split,
>  	 * action:
>  	 */
>  	tlck = txLock(tid, ip, smp, tlckDTREE | tlckENTRY);
> +	if (IS_ERR(tlck)) {
> +		DT_PUTPAGE(rmp);
> +		return PTR_ERR(tlck);
> +	}
>  	sdtlck = (struct dt_lock *) & tlck->lock;
>  
>  	/* linelock header of split page */
> @@ -1452,7 +1507,11 @@ static int dtSplitPage(tid_t tid, struct inode *ip, struct dtsplit * split,
>  		f->next = -1;
>  
>  		/* insert entry at the first entry of the new right page */
> -		dtInsertEntry(rp, 0, split->key, split->data, &rdtlck);
> +		rc = dtInsertEntry(rp, 0, split->key, split->data, &rdtlck);
> +		if (rc) {
> +			DT_PUTPAGE(rmp);
> +			return rc;
> +		}
>  
>  		goto out;
>  	}
> @@ -1476,6 +1535,11 @@ static int dtSplitPage(tid_t tid, struct inode *ip, struct dtsplit * split,
>  		 * acquire a transaction lock on the next page
>  		 */
>  		tlck = txLock(tid, ip, mp, tlckDTREE | tlckRELINK);
> +		if (IS_ERR(tlck)) {
> +			DT_PUTPAGE(mp);
> +			DT_PUTPAGE(rmp);
> +			return PTR_ERR(tlck);
> +		}
>  		jfs_info("dtSplitPage: tlck = 0x%p, ip = 0x%p, mp=0x%p",
>  			tlck, ip, mp);
>  		dtlck = (struct dt_lock *) & tlck->lock;
> @@ -1577,40 +1641,54 @@ static int dtSplitPage(tid_t tid, struct inode *ip, struct dtsplit * split,
>  		mp = NULL;
>  		stbl = DT_GETSTBL(rp);
>  		for (n = 0; n < rp->header.nextindex; n++) {
> -			ldtentry = (struct ldtentry *) & rp->slot[stbl[n]];
> -			modify_index(tid, ip, le32_to_cpu(ldtentry->index),
> -				     rbn, n, &mp, &lblock);
> +			ldtentry = (struct ldtentry *)&rp->slot[stbl[n]];
> +			rc = modify_index(tid, ip, le32_to_cpu(ldtentry->index),
> +					  rbn, n, &mp, &lblock);
> +			if (rc)
> +				break;
>  		}
>  		if (mp)
>  			release_metapage(mp);
> +		if (rc) {
> +			DT_PUTPAGE(rmp);
> +			return rc;
> +		}
>  	}
>  
>  	/*
> -	 * the skipped index was on the left page,
> -	 */
> +		 * the skipped index was on the left page,
> +		 */
>  	if (skip <= off) {
>  		/* insert the new entry in the split page */
> -		dtInsertEntry(sp, skip, split->key, split->data, &sdtlck);
> +		rc = dtInsertEntry(sp, skip, split->key, split->data, &sdtlck);
> +		if (rc) {
> +			DT_PUTPAGE(rmp);
> +			return rc;
> +		}
>  
>  		/* linelock stbl of split page */
>  		if (sdtlck->index >= sdtlck->maxcnt)
> -			sdtlck = (struct dt_lock *) txLinelock(sdtlck);
> -		slv = & sdtlck->lv[sdtlck->index];
> +			sdtlck = (struct dt_lock *)txLinelock(sdtlck);
> +		slv = &sdtlck->lv[sdtlck->index];
>  		n = skip >> L2DTSLOTSIZE;
>  		slv->offset = sp->header.stblindex + n;
>  		slv->length =
> -		    ((sp->header.nextindex - 1) >> L2DTSLOTSIZE) - n + 1;
> +			((sp->header.nextindex - 1) >> L2DTSLOTSIZE) - n + 1;
>  		sdtlck->index++;
>  	}
>  	/*
> -	 * the skipped index was on the right page,
> -	 */
> +		 * the skipped index was on the right page,
> +		 */
>  	else {
>  		/* adjust the skip index to reflect the new position */
>  		skip -= nxt;
>  
>  		/* insert the new entry in the right page */
> -		dtInsertEntry(rp, skip, split->key, split->data, &rdtlck);
> +		rc = dtInsertEntry(rp, skip, split->key, split->data, &rdtlck);
> +		if (rc) {
> +			DT_PUTPAGE(rmp);
> +			return rc;
> +		}
>  	}
>  
>        out:
> @@ -1702,13 +1780,19 @@ static int dtExtendPage(tid_t tid,
>  			stbl = DT_GETSTBL(sp);
>  			for (n = 0; n < sp->header.nextindex; n++) {
>  				ldtentry =
> -				    (struct ldtentry *) & sp->slot[stbl[n]];
> -				modify_index(tid, ip,
> -					     le32_to_cpu(ldtentry->index),
> -					     xaddr, n, &mp, &lblock);
> +					(struct ldtentry *)&sp->slot[stbl[n]];
> +				rc = modify_index(tid, ip,
> +						  le32_to_cpu(ldtentry->index),
> +						  xaddr, n, &mp, &lblock);
> +				if (rc)
> +					break;
>  			}
>  			if (mp)
>  				release_metapage(mp);
> +			if (rc) {
> +				DT_PUTPAGE(pmp);
> +				return rc;
> +			}
>  		}
>  	}
>  
> @@ -1724,7 +1808,11 @@ static int dtExtendPage(tid_t tid,
>  	 * acquire a transaction lock on the extended/leaf page
>  	 */
>  	tlck = txLock(tid, ip, smp, tlckDTREE | type);
> -	dtlck = (struct dt_lock *) & tlck->lock;
> +	if (IS_ERR(tlck)) {
> +		DT_PUTPAGE(pmp);
> +		return PTR_ERR(tlck);
> +	}
> +	dtlck = (struct dt_lock *)&tlck->lock;
>  	lv = & dtlck->lv[0];
>  
>  	/* update buffer extent descriptor of extended page */
> @@ -1811,7 +1899,11 @@ static int dtExtendPage(tid_t tid,
>  	/*
>  	 * insert the new entry
>  	 */
> -	dtInsertEntry(sp, split->index, split->key, split->data, &dtlck);
> +	rc = dtInsertEntry(sp, split->index, split->key, split->data, &dtlck);
> +	if (rc) {
> +		DT_PUTPAGE(pmp);
> +		return rc;
> +	}
>  
>  	BT_MARK_DIRTY(pmp, ip);
>  	/*
> @@ -1830,8 +1922,12 @@ static int dtExtendPage(tid_t tid,
>  	 * acquire a transaction lock on the parent/root page
>  	 */
>  	tlck = txLock(tid, ip, pmp, tlckDTREE | tlckENTRY);
> -	dtlck = (struct dt_lock *) & tlck->lock;
> -	lv = & dtlck->lv[dtlck->index];
> +	if (IS_ERR(tlck)) {
> +		DT_PUTPAGE(pmp);
> +		return PTR_ERR(tlck);
> +	}
> +	dtlck = (struct dt_lock *)&tlck->lock;
> +	lv = &dtlck->lv[dtlck->index];
>  
>  	/* linelock parent entry - 1st slot */
>  	lv->offset = 1;
> @@ -1922,6 +2018,10 @@ static int dtSplitRoot(tid_t tid,
>  	 * acquire a transaction lock on the new right page
>  	 */
>  	tlck = txLock(tid, ip, rmp, tlckDTREE | tlckNEW);
> +	if (IS_ERR(tlck)) {
> +		DT_PUTPAGE(rmp);
> +		return PTR_ERR(tlck);
> +	}
>  	dtlck = (struct dt_lock *) & tlck->lock;
>  
>  	rp->header.flag =
> @@ -1993,17 +2093,27 @@ static int dtSplitRoot(tid_t tid,
>  		stbl = DT_GETSTBL(rp);
>  		for (n = 0; n < rp->header.nextindex; n++) {
>  			ldtentry = (struct ldtentry *) & rp->slot[stbl[n]];
> -			modify_index(tid, ip, le32_to_cpu(ldtentry->index),
> -				     rbn, n, &mp, &lblock);
> +			rc = modify_index(tid, ip, le32_to_cpu(ldtentry->index),
> +					  rbn, n, &mp, &lblock);
> +			if (rc)
> +				break;
>  		}
>  		if (mp)
>  			release_metapage(mp);
> +		if (rc) {
> +			DT_PUTPAGE(rmp);
> +			return rc;
> +		}
>  	}
>  	/*
>  	 * insert the new entry into the new right/child page
>  	 * (skip index in the new right page will not change)
>  	 */
> -	dtInsertEntry(rp, split->index, split->key, split->data, &dtlck);
> +	rc = dtInsertEntry(rp, split->index, split->key, split->data, &dtlck);
> +	if (rc) {
> +		DT_PUTPAGE(rmp);
> +		return rc;
> +	}
>  
>  	/*
>  	 *	reset parent/root page
> @@ -2019,6 +2129,10 @@ static int dtSplitRoot(tid_t tid,
>  	 * acquire a transaction lock on the root page (in-memory inode)
>  	 */
>  	tlck = txLock(tid, ip, smp, tlckDTREE | tlckNEW | tlckBTROOT);
> +	if (IS_ERR(tlck)) {
> +		DT_PUTPAGE(rmp);
> +		return PTR_ERR(tlck);
> +	}
>  	dtlck = (struct dt_lock *) & tlck->lock;
>  
>  	/* linelock root */
> @@ -2139,7 +2253,11 @@ int dtDelete(tid_t tid,
>  			    (struct ldtentry *) & p->slot[stbl[index + 1]];
>  			next_index = le32_to_cpu(ldtentry->index);
>  		}
> -		free_index(tid, ip, table_index, next_index);
> +		rc = free_index(tid, ip, table_index, next_index);
> +		if (rc) {
> +			DT_PUTPAGE(mp);
> +			return rc;
> +		}
>  	}
>  	/*
>  	 * the leaf page becomes empty, delete the page
> @@ -2159,6 +2277,10 @@ int dtDelete(tid_t tid,
>  		 * acquire a transaction lock on the leaf page
>  		 */
>  		tlck = txLock(tid, ip, mp, tlckDTREE | tlckENTRY);
> +		if (IS_ERR(tlck)) {
> +			DT_PUTPAGE(mp);
> +			return PTR_ERR(tlck);
> +		}
>  		dtlck = (struct dt_lock *) & tlck->lock;
>  
>  		/*
> @@ -2202,12 +2324,18 @@ int dtDelete(tid_t tid,
>  			for (i = index; i < p->header.nextindex; i++) {
>  				ldtentry =
>  				    (struct ldtentry *) & p->slot[stbl[i]];
> -				modify_index(tid, ip,
> -					     le32_to_cpu(ldtentry->index),
> -					     bn, i, &imp, &lblock);
> +				rc = modify_index(tid, ip,
> +						  le32_to_cpu(ldtentry->index),
> +						  bn, i, &imp, &lblock);
> +				if (rc)
> +					break;
>  			}
>  			if (imp)
>  				release_metapage(imp);
> +			if (rc) {
> +				DT_PUTPAGE(mp);
> +				return rc;
> +			}
>  		}
>  
>  		DT_PUTPAGE(mp);
> @@ -2251,11 +2379,11 @@ static int dtDeleteUp(tid_t tid, struct inode *ip,
>  		 *
>  		 * dtInitRoot() acquires txlock on the root
>  		 */
> -		dtInitRoot(tid, ip, PARENT(ip));
> +		rc = dtInitRoot(tid, ip, PARENT(ip));
>  
>  		DT_PUTPAGE(fmp);
>  
> -		return 0;
> +		return rc;
>  	}
>  
>  	/*
> @@ -2319,19 +2447,19 @@ static int dtDeleteUp(tid_t tid, struct inode *ip,
>  		 */
>  		if (nextindex == 1) {
>  			/*
> -			 * keep the root internal page which has become empty
> -			 */
> +				 * keep the root internal page which has become empty
> +				 */
>  			if (p->header.flag & BT_ROOT) {
>  				/*
> -				 * reset the root
> -				 *
> -				 * dtInitRoot() acquires txlock on the root
> -				 */
> -				dtInitRoot(tid, ip, PARENT(ip));
> +					 * reset the root
> +					 *
> +					 * dtInitRoot() acquires txlock on the root
> +					 */
> +				rc = dtInitRoot(tid, ip, PARENT(ip));
>  
>  				DT_PUTPAGE(mp);
>  
> -				return 0;
> +				return rc;
>  			}
>  			/*
>  			 * free the parent page
> @@ -2381,6 +2509,10 @@ static int dtDeleteUp(tid_t tid, struct inode *ip,
>  		 * action: router entry deletion
>  		 */
>  		tlck = txLock(tid, ip, mp, tlckDTREE | tlckENTRY);
> +		if (IS_ERR(tlck)) {
> +			DT_PUTPAGE(mp);
> +			return PTR_ERR(tlck);
> +		}
>  		dtlck = (struct dt_lock *) & tlck->lock;
>  
>  		/* linelock header */
> @@ -2464,6 +2596,10 @@ static int dtRelink(tid_t tid, struct inode *ip, dtpage_t * p)
>  		 * action: update prev pointer;
>  		 */
>  		tlck = txLock(tid, ip, mp, tlckDTREE | tlckRELINK);
> +		if (IS_ERR(tlck)) {
> +			DT_PUTPAGE(mp);
> +			return PTR_ERR(tlck);
> +		}
>  		jfs_info("dtRelink nextbn: tlck = 0x%p, ip = 0x%p, mp=0x%p",
>  			tlck, ip, mp);
>  		dtlck = (struct dt_lock *) & tlck->lock;
> @@ -2493,6 +2629,10 @@ static int dtRelink(tid_t tid, struct inode *ip, dtpage_t * p)
>  		 * action: update next pointer;
>  		 */
>  		tlck = txLock(tid, ip, mp, tlckDTREE | tlckRELINK);
> +		if (IS_ERR(tlck)) {
> +			DT_PUTPAGE(mp);
> +			return PTR_ERR(tlck);
> +		}
>  		jfs_info("dtRelink prevbn: tlck = 0x%p, ip = 0x%p, mp=0x%p",
>  			tlck, ip, mp);
>  		dtlck = (struct dt_lock *) & tlck->lock;
> @@ -2518,7 +2658,7 @@ static int dtRelink(tid_t tid, struct inode *ip, dtpage_t * p)
>   *
>   * initialize directory root (inline in inode)
>   */
> -void dtInitRoot(tid_t tid, struct inode *ip, u32 idotdot)
> +int dtInitRoot(tid_t tid, struct inode *ip, u32 idotdot)
>  {
>  	struct jfs_inode_info *jfs_ip = JFS_IP(ip);
>  	dtroot_t *p;
> @@ -2570,6 +2710,8 @@ void dtInitRoot(tid_t tid, struct inode *ip, u32 idotdot)
>  	 */
>  	tlck = txLock(tid, ip, (struct metapage *) & jfs_ip->bxflag,
>  		      tlckDTREE | tlckENTRY | tlckBTROOT);
> +	if (IS_ERR(tlck))
> +		return PTR_ERR(tlck);
>  	dtlck = (struct dt_lock *) & tlck->lock;
>  
>  	/* linelock root */
> @@ -2600,7 +2742,7 @@ void dtInitRoot(tid_t tid, struct inode *ip, u32 idotdot)
>  	/* init '..' entry */
>  	p->header.idotdot = cpu_to_le32(idotdot);
>  
> -	return;
> +	return 0;
>  }
>  
>  /*
> @@ -2637,6 +2779,12 @@ static int add_missing_indices(struct inode *inode, s64 bn)
>  	ASSERT(p->header.flag & BT_LEAF);
>  
>  	tlck = txLock(tid, inode, mp, tlckDTREE | tlckENTRY);
> +	if (IS_ERR(tlck)) {
> +		rc = PTR_ERR(tlck);
> +		DT_PUTPAGE(mp);
> +		txAbort(tid, 0);
> +		goto end;
> +	}
>  	if (BT_IS_ROOT(mp))
>  		tlck->type |= tlckBTROOT;
>  
> @@ -3624,8 +3772,8 @@ static void dtGetKey(dtpage_t * p, int i,	/* entry index */
>   *
>   * return: entry slot index
>   */
> -static void dtInsertEntry(dtpage_t * p, int index, struct component_name * key,
> -			  ddata_t * data, struct dt_lock ** dtlock)
> +static int dtInsertEntry(dtpage_t *p, int index, struct component_name *key,
> +			 ddata_t *data, struct dt_lock **dtlock)
>  {
>  	struct dtslot *h, *t;
>  	struct ldtentry *lh = NULL;
> @@ -3640,6 +3788,7 @@ static void dtInsertEntry(dtpage_t * p, int index, struct component_name * key,
>  	int xsi, n;
>  	s64 bn = 0;
>  	struct metapage *mp = NULL;
> +	int rc = 0;
>  
>  	klen = key->namlen;
>  	kname = key->name;
> @@ -3752,18 +3901,22 @@ static void dtInsertEntry(dtpage_t * p, int index, struct component_name * key,
>  			s64 lblock;
>  
>  			/*
> -			 * Need to update slot number for entries that moved
> -			 * in the stbl
> -			 */
> +				 * Need to update slot number for entries that moved
> +				 * in the stbl
> +				 */
>  			mp = NULL;
>  			for (n = index + 1; n <= nextindex; n++) {
> -				lh = (struct ldtentry *) & (p->slot[stbl[n]]);
> -				modify_index(data->leaf.tid, data->leaf.ip,
> -					     le32_to_cpu(lh->index), bn, n,
> -					     &mp, &lblock);
> +				lh = (struct ldtentry *)&(p->slot[stbl[n]]);
> +				rc = modify_index(data->leaf.tid, data->leaf.ip,
> +						  le32_to_cpu(lh->index), bn, n,
> +						  &mp, &lblock);
> +				if (rc)
> +					break;
>  			}
>  			if (mp)
>  				release_metapage(mp);
> +			if (rc)
> +				return rc;
>  		}
>  	}
>  
> @@ -3771,8 +3924,9 @@ static void dtInsertEntry(dtpage_t * p, int index, struct component_name * key,
>  
>  	/* advance next available entry index of stbl */
>  	++p->header.nextindex;
> -}
>  
> +	return 0;
> +}
>  
>  /*
>   *	dtMoveEntry()
> @@ -4270,6 +4424,10 @@ int dtModify(tid_t tid, struct inode *ip,
>  	 * acquire a transaction lock on the leaf page of named entry
>  	 */
>  	tlck = txLock(tid, ip, mp, tlckDTREE | tlckENTRY);
> +	if (IS_ERR(tlck)) {
> +		DT_PUTPAGE(mp);
> +		return PTR_ERR(tlck);
> +	}
>  	dtlck = (struct dt_lock *) & tlck->lock;
>  
>  	/* get slot index of the entry */
> diff --git a/fs/jfs/jfs_dtree.h b/fs/jfs/jfs_dtree.h
> index dfc87b669..33528521f 100644
> --- a/fs/jfs/jfs_dtree.h
> +++ b/fs/jfs/jfs_dtree.h
> @@ -238,7 +238,7 @@ typedef union {
>  /*
>   *	external declarations
>   */
> -extern void dtInitRoot(tid_t tid, struct inode *ip, u32 idotdot);
> +extern int dtInitRoot(tid_t tid, struct inode *ip, u32 idotdot);
>  
>  extern int dtSearch(struct inode *ip, struct component_name * key,
>  		    ino_t * data, struct btstack * btstack, int flag);
> diff --git a/fs/jfs/jfs_imap.c b/fs/jfs/jfs_imap.c
> index b84ba4d7d..4a0f76501 100644
> --- a/fs/jfs/jfs_imap.c
> +++ b/fs/jfs/jfs_imap.c
> @@ -650,8 +650,12 @@ int diWrite(tid_t tid, struct inode *ip)
>  	 * acquire transaction lock on the on-disk inode;
>  	 * N.B. tlock is acquired on ipimap not ip;
>  	 */
> -	if ((ditlck =
> -	     txLock(tid, ipimap, mp, tlckINODE | tlckENTRY)) == NULL)
> +	ditlck = txLock(tid, ipimap, mp, tlckINODE | tlckENTRY);
> +	if (IS_ERR(ditlck)) {
> +		release_metapage(mp);
> +		return PTR_ERR(ditlck);
> +	}
> +	if (ditlck == NULL)
>  		goto retry;
>  	dilinelock = (struct linelock *) & ditlck->lock;
>  
> @@ -1231,6 +1235,7 @@ int diFree(struct inode *ip)
>  	tid = txBegin(ipimap->i_sb, COMMIT_FORCE);
>  	mutex_lock(&JFS_IP(ipimap)->commit_mutex);
>  
> +retry:
>  	/* acquire tlock of the iag page of the freed ixad
>  	 * to force the page NOHOMEOK (even though no data is
>  	 * logged from the iag page) until NOREDOPAGE|FREEXTENT log
> @@ -1239,6 +1244,16 @@ int diFree(struct inode *ip)
>  	 * N.B. linelock is overlaid as freed extent descriptor;
>  	 */
>  	tlck = txLock(tid, ipimap, mp, tlckINODE | tlckFREE);
> +	if (IS_ERR(tlck)) {
> +		rc = PTR_ERR(tlck);
> +		txAbort(tid, 0);
> +		mutex_unlock(&JFS_IP(ipimap)->commit_mutex);
> +		AG_UNLOCK(imap, agno);
> +		release_metapage(mp);
> +		return rc;
> +	}
> +	if (tlck == NULL)
> +		goto retry;
>  	pxdlock = (struct pxd_lock *) & tlck->lock;
>  	pxdlock->flag = mlckFREEPXD;
>  	pxdlock->pxd = freepxd;
> diff --git a/fs/jfs/jfs_txnmgr.c b/fs/jfs/jfs_txnmgr.c
> index 083dbbb0c..f5e28dc24 100644
> --- a/fs/jfs/jfs_txnmgr.c
> +++ b/fs/jfs/jfs_txnmgr.c
> @@ -820,39 +820,32 @@ struct tlock *txLock(tid_t tid, struct inode *ip, struct metapage * mp,
>  	 * page is being locked by another transaction:
>  	 */
>        waitLock:
> -	/* Only locks on ipimap or ipaimap should reach here */
> -	/* assert(jfs_ip->fileset == AGGREGATE_I); */
> -	if (jfs_ip->fileset != AGGREGATE_I) {
> -		printk(KERN_ERR "txLock: trying to lock locked page!");
> -		print_hex_dump(KERN_ERR, "ip: ", DUMP_PREFIX_ADDRESS, 16, 4,
> -			       ip, sizeof(*ip), 0);
> -		print_hex_dump(KERN_ERR, "mp: ", DUMP_PREFIX_ADDRESS, 16, 4,
> -			       mp, sizeof(*mp), 0);
> -		print_hex_dump(KERN_ERR, "Locker's tblock: ",
> -			       DUMP_PREFIX_ADDRESS, 16, 4, tid_to_tblock(tid),
> -			       sizeof(struct tblock), 0);
> -		print_hex_dump(KERN_ERR, "Tlock: ", DUMP_PREFIX_ADDRESS, 16, 4,
> -			       tlck, sizeof(*tlck), 0);
> -		BUG();
> -	}
> -	INCREMENT(stattx.waitlock);	/* statistics */
> -	TXN_UNLOCK();
> -	release_metapage(mp);
> -	TXN_LOCK();
> -	xtid = tlck->tid;	/* reacquire after dropping TXN_LOCK */
> -
> -	jfs_info("txLock: in waitLock, tid = %d, xtid = %d, lid = %d",
> -		 tid, xtid, lid);
> -
> -	/* Recheck everything since dropping TXN_LOCK */
> -	if (xtid && (tlck->mp == mp) && (mp->lid == lid))
> -		TXN_SLEEP_DROP_LOCK(&tid_to_tblock(xtid)->waitor);
> -	else
> -		TXN_UNLOCK();
> -	jfs_info("txLock: awakened     tid = %d, lid = %d", tid, lid);
> -
> -	return NULL;
> -}
> +	      /* Only locks on ipimap or ipaimap should reach here */
> +	      /* assert(jfs_ip->fileset == AGGREGATE_I); */
> +	      if (jfs_ip->fileset != AGGREGATE_I) {
> +		      TXN_UNLOCK();
> +		      jfs_error(ip->i_sb,
> +				"txLock: trying to lock locked page!\n");
> +		      return ERR_PTR(-EIO);
> +	      }
> +	      INCREMENT(stattx.waitlock); /* statistics */
> +	      TXN_UNLOCK();
> +	      release_metapage(mp);
> +	      TXN_LOCK();
> +	      xtid = tlck->tid; /* reacquire after dropping TXN_LOCK */
> +
> +	      jfs_info("txLock: in waitLock, tid = %d, xtid = %d, lid = %d",
> +		       tid, xtid, lid);
> +
> +	      /* Recheck everything since dropping TXN_LOCK */
> +	      if (xtid && (tlck->mp == mp) && (mp->lid == lid))
> +		      TXN_SLEEP_DROP_LOCK(&tid_to_tblock(xtid)->waitor);
> +	      else
> +		      TXN_UNLOCK();
> +	      jfs_info("txLock: awakened     tid = %d, lid = %d", tid, lid);
> +
> +	      return NULL;
> +      }
>  
>  /*
>   * NAME:	txRelease()
> diff --git a/fs/jfs/jfs_xtree.c b/fs/jfs/jfs_xtree.c
> index 28c3cf960..2944a8dbd 100644
> --- a/fs/jfs/jfs_xtree.c
> +++ b/fs/jfs/jfs_xtree.c
> @@ -643,6 +643,10 @@ int xtInsert(tid_t tid,		/* transaction id */
>  	/* Don't log it if there are no links to the file */
>  	if (!test_cflag(COMMIT_Nolink, ip)) {
>  		tlck = txLock(tid, ip, mp, tlckXTREE | tlckGROW);
> +		if (IS_ERR(tlck)) {
> +			rc = PTR_ERR(tlck);
> +			goto out;
> +		}
>  		xtlck = (struct xtlock *) & tlck->lock;
>  		xtlck->lwm.offset =
>  		    (xtlck->lwm.offset) ? min(index,
> @@ -734,6 +738,8 @@ xtSplitUp(tid_t tid,
>  		/* Don't log it if there are no links to the file */
>  		if (!test_cflag(COMMIT_Nolink, ip)) {
>  			tlck = txLock(tid, ip, smp, tlckXTREE | tlckGROW);
> +			if (IS_ERR(tlck))
> +				return PTR_ERR(tlck);
>  			xtlck = (struct xtlock *) & tlck->lock;
>  			xtlck->lwm.offset = (xtlck->lwm.offset) ?
>  			    min(skip, (int)xtlck->lwm.offset) : skip;
> @@ -904,6 +910,11 @@ xtSplitUp(tid_t tid,
>  			if (!test_cflag(COMMIT_Nolink, ip)) {
>  				tlck = txLock(tid, ip, smp,
>  					      tlckXTREE | tlckGROW);
> +				if (IS_ERR(tlck)) {
> +					XT_PUTPAGE(smp);
> +					XT_PUTPAGE(rmp);
> +					return PTR_ERR(tlck);
> +				}
>  				xtlck = (struct xtlock *) & tlck->lock;
>  				xtlck->lwm.offset = (xtlck->lwm.offset) ?
>  				    min(skip, (int)xtlck->lwm.offset) : skip;
> @@ -1012,12 +1023,22 @@ xtSplitPage(tid_t tid, struct inode *ip,
>  		 * acquire a transaction lock on the new right page;
>  		 */
>  		tlck = txLock(tid, ip, rmp, tlckXTREE | tlckNEW);
> +		if (IS_ERR(tlck)) {
> +			rc = PTR_ERR(tlck);
> +			XT_PUTPAGE(rmp);
> +			goto clean_up;
> +		}
>  		rxtlck = (struct xtlock *) & tlck->lock;
>  		rxtlck->lwm.offset = XTENTRYSTART;
>  		/*
>  		 * acquire a transaction lock on the split page
>  		 */
>  		tlck = txLock(tid, ip, smp, tlckXTREE | tlckGROW);
> +		if (IS_ERR(tlck)) {
> +			rc = PTR_ERR(tlck);
> +			XT_PUTPAGE(rmp);
> +			goto clean_up;
> +		}
>  		sxtlck = (struct xtlock *) & tlck->lock;
>  	}
>  
> @@ -1089,8 +1110,15 @@ xtSplitPage(tid_t tid, struct inode *ip,
>  		 *
>  		 * action:sibling pointer update;
>  		 */
> -		if (!test_cflag(COMMIT_Nolink, ip))
> +		if (!test_cflag(COMMIT_Nolink, ip)) {
>  			tlck = txLock(tid, ip, mp, tlckXTREE | tlckRELINK);
> +			if (IS_ERR(tlck)) {
> +				rc = PTR_ERR(tlck);
> +				XT_PUTPAGE(mp);
> +				XT_PUTPAGE(rmp);
> +				goto clean_up;
> +			}
> +		}
>  
>  		p->header.prev = cpu_to_le64(rbn);
>  
> @@ -1295,6 +1323,10 @@ xtSplitRoot(tid_t tid,
>  
>  	if (!test_cflag(COMMIT_Nolink, ip)) {
>  		tlck = txLock(tid, ip, rmp, tlckXTREE | tlckNEW);
> +		if (IS_ERR(tlck)) {
> +			XT_PUTPAGE(rmp);
> +			return PTR_ERR(tlck);
> +		}
>  		xtlck = (struct xtlock *) & tlck->lock;
>  		xtlck->lwm.offset = XTENTRYSTART;
>  		xtlck->lwm.length = le16_to_cpu(rp->header.nextindex) -
> @@ -1326,6 +1358,10 @@ xtSplitRoot(tid_t tid,
>  
>  	if (!test_cflag(COMMIT_Nolink, ip)) {
>  		tlck = txLock(tid, ip, split->mp, tlckXTREE | tlckGROW);
> +		if (IS_ERR(tlck)) {
> +			XT_PUTPAGE(rmp);
> +			return PTR_ERR(tlck);
> +		}
>  		xtlck = (struct xtlock *) & tlck->lock;
>  		xtlck->lwm.offset = XTENTRYSTART;
>  		xtlck->lwm.length = 1;
> @@ -1397,6 +1433,10 @@ int xtExtend(tid_t tid,		/* transaction id */
>  	BT_MARK_DIRTY(mp, ip);
>  	if (!test_cflag(COMMIT_Nolink, ip)) {
>  		tlck = txLock(tid, ip, mp, tlckXTREE | tlckGROW);
> +		if (IS_ERR(tlck)) {
> +			XT_PUTPAGE(mp);
> +			return PTR_ERR(tlck);
> +		}
>  		xtlck = (struct xtlock *) & tlck->lock;
>  	}
>  
> @@ -1552,6 +1592,10 @@ int xtUpdate(tid_t tid, struct inode *ip, xad_t * nxad)
>  	 */
>  	if (!test_cflag(COMMIT_Nolink, ip)) {
>  		tlck = txLock(tid, ip, mp, tlckXTREE | tlckGROW);
> +		if (IS_ERR(tlck)) {
> +			XT_PUTPAGE(mp);
> +			return PTR_ERR(tlck);
> +		}
>  		xtlck = (struct xtlock *) & tlck->lock;
>  	}
>  
> @@ -1730,10 +1774,10 @@ int xtUpdate(tid_t tid, struct inode *ip, xad_t * nxad)
>  		if (IS_ERR(p))
>  			return PTR_ERR(p);
>  		/*
> -		 * if leaf root has been split, original root has been
> -		 * copied to new child page, i.e., original entry now
> -		 * resides on the new child page;
> -		 */
> +			 * if leaf root has been split, original root has been
> +			 * copied to new child page, i.e., original entry now
> +			 * resides on the new child page;
> +			 */
>  		if (p->header.flag & BT_INTERNAL) {
>  			ASSERT(p->header.nextindex ==
>  			       cpu_to_le16(XTENTRYSTART + 1));
> @@ -1748,8 +1792,13 @@ int xtUpdate(tid_t tid, struct inode *ip, xad_t * nxad)
>  
>  			BT_MARK_DIRTY(mp, ip);
>  			if (!test_cflag(COMMIT_Nolink, ip)) {
> -				tlck = txLock(tid, ip, mp, tlckXTREE|tlckGROW);
> -				xtlck = (struct xtlock *) & tlck->lock;
> +				tlck = txLock(tid, ip, mp,
> +					      tlckXTREE | tlckGROW);
> +				if (IS_ERR(tlck)) {
> +					XT_PUTPAGE(mp);
> +					return PTR_ERR(tlck);
> +				}
> +				xtlck = (struct xtlock *)&tlck->lock;
>  			}
>  		} else {
>  			/* is nXAD on new page ? */
> @@ -1810,6 +1859,10 @@ int xtUpdate(tid_t tid, struct inode *ip, xad_t * nxad)
>  		BT_MARK_DIRTY(mp, ip);
>  		if (!test_cflag(COMMIT_Nolink, ip)) {
>  			tlck = txLock(tid, ip, mp, tlckXTREE | tlckGROW);
> +			if (IS_ERR(tlck)) {
> +				XT_PUTPAGE(mp);
> +				return PTR_ERR(tlck);
> +			}
>  			xtlck = (struct xtlock *) & tlck->lock;
>  		}
>  
> @@ -1902,8 +1955,13 @@ printf("xtUpdate.updateLeft.split p:0x%p\n", p);
>  
>  			BT_MARK_DIRTY(mp, ip);
>  			if (!test_cflag(COMMIT_Nolink, ip)) {
> -				tlck = txLock(tid, ip, mp, tlckXTREE|tlckGROW);
> -				xtlck = (struct xtlock *) & tlck->lock;
> +				tlck = txLock(tid, ip, mp,
> +					      tlckXTREE | tlckGROW);
> +				if (IS_ERR(tlck)) {
> +					XT_PUTPAGE(mp);
> +					return PTR_ERR(tlck);
> +				}
> +				xtlck = (struct xtlock *)&tlck->lock;
>  			}
>  		}
>  	} else {
> @@ -2082,6 +2140,10 @@ int xtAppend(tid_t tid,		/* transaction id */
>  	 * action: xad insertion/extension;
>  	 */
>  	tlck = txLock(tid, ip, mp, tlckXTREE | tlckGROW);
> +	if (IS_ERR(tlck)) {
> +		rc = PTR_ERR(tlck);
> +		goto out;
> +	}
>  	xtlck = (struct xtlock *) & tlck->lock;
>  
>  	/* insert the new entry: mark the entry NEW */
> @@ -2111,17 +2173,21 @@ int xtAppend(tid_t tid,		/* transaction id */
>   *
>   * initialize file root (inline in inode)
>   */
> -void xtInitRoot(tid_t tid, struct inode *ip)
> +int xtInitRoot(tid_t tid, struct inode *ip)
>  {
>  	xtroot_t *p;
> +	struct tlock *tlck;
>  
>  	/*
>  	 * acquire a transaction lock on the root
>  	 *
>  	 * action:
>  	 */
> -	txLock(tid, ip, (struct metapage *) &JFS_IP(ip)->bxflag,
> +	tlck = txLock(tid, ip, (struct metapage *)&JFS_IP(ip)->bxflag,
>  		      tlckXTREE | tlckNEW);
> +	if (IS_ERR(tlck))
> +		return PTR_ERR(tlck);
> +
>  	p = &JFS_IP(ip)->i_xtroot;
>  
>  	p->header.flag = DXD_INDEX | BT_ROOT | BT_LEAF;
> @@ -2134,8 +2200,7 @@ void xtInitRoot(tid_t tid, struct inode *ip)
>  		ip->i_size = 0;
>  	}
>  
> -
> -	return;
> +	return 0;
>  }
>  
>  
> @@ -2295,13 +2360,18 @@ s64 xtTruncate(tid_t tid, struct inode *ip, s64 newsize, int flag)
>  	 * sure that the next pointer is zero.
>  	 */
>  	if (p->header.next) {
> -		if (log)
> +		if (log) {
>  			/*
> -			 * Make sure this change to the header is logged.
> -			 * If we really truncate this leaf, the flag
> -			 * will be changed to tlckTRUNCATE
> -			 */
> -			tlck = txLock(tid, ip, mp, tlckXTREE|tlckGROW);
> +				 * Make sure this change to the header is logged.
> +				 * If we really truncate this leaf, the flag
> +				 * will be changed to tlckTRUNCATE
> +				 */
> +			tlck = txLock(tid, ip, mp, tlckXTREE | tlckGROW);
> +			if (IS_ERR(tlck)) {
> +				XT_PUTPAGE(mp);
> +				return PTR_ERR(tlck);
> +			}
> +		}
>  		BT_MARK_DIRTY(mp, ip);
>  		p->header.next = 0;
>  	}
> @@ -2310,8 +2380,8 @@ s64 xtTruncate(tid_t tid, struct inode *ip, s64 newsize, int flag)
>  		goto getChild;
>  
>  	/*
> -	 *	leaf page
> -	 */
> +		 *	leaf page
> +		 */
>  	freed = 0;
>  
>  	/* does region covered by leaf page precede Teof ? */
> @@ -2327,16 +2397,20 @@ s64 xtTruncate(tid_t tid, struct inode *ip, s64 newsize, int flag)
>  	if (log) {
>  		if (++locked_leaves > MAX_TRUNCATE_LEAVES) {
>  			/*
> -			 * We need to limit the size of the transaction
> -			 * to avoid exhausting pagecache & tlocks
> -			 */
> +				 * We need to limit the size of the transaction
> +				 * to avoid exhausting pagecache & tlocks
> +				 */
>  			XT_PUTPAGE(mp);
>  			newsize = (xoff + xlen) << JFS_SBI(ip->i_sb)->l2bsize;
>  			goto getParent;
>  		}
>  		tlck = txLock(tid, ip, mp, tlckXTREE);
> +		if (IS_ERR(tlck)) {
> +			XT_PUTPAGE(mp);
> +			return PTR_ERR(tlck);
> +		}
>  		tlck->type = tlckXTREE | tlckTRUNCATE;
> -		xtlck = (struct xtlock *) & tlck->lock;
> +		xtlck = (struct xtlock *)&tlck->lock;
>  		xtlck->hwm.offset = le16_to_cpu(p->header.nextindex) - 1;
>  	}
>  	BT_MARK_DIRTY(mp, ip);
> @@ -2533,20 +2607,24 @@ s64 xtTruncate(tid_t tid, struct inode *ip, s64 newsize, int flag)
>  		/* has any entry deleted from parent ? */
>  		if (index < le16_to_cpu(p->header.nextindex) - 1) {
>  			/* (re)acquire tlock on the parent page */
> -			if (log) {	/* COMMIT_PWMAP */
> +			if (log) { /* COMMIT_PWMAP */
>  				/* txCommit() with tlckTRUNCATE:
> -				 * free child extents covered by parent [);
> -				 */
> +					 * free child extents covered by parent [);
> +					 */
>  				tlck = txLock(tid, ip, mp, tlckXTREE);
> -				xtlck = (struct xtlock *) & tlck->lock;
> +				if (IS_ERR(tlck)) {
> +					XT_PUTPAGE(mp);
> +					return PTR_ERR(tlck);
> +				}
> +				xtlck = (struct xtlock *)&tlck->lock;
>  				if (!(tlck->type & tlckTRUNCATE)) {
>  					xtlck->hwm.offset =
> -					    le16_to_cpu(p->header.
> -							nextindex) - 1;
> -					tlck->type =
> -					    tlckXTREE | tlckTRUNCATE;
> +						le16_to_cpu(
> +							p->header.nextindex) -
> +						1;
> +					tlck->type = tlckXTREE | tlckTRUNCATE;
>  				}
> -			} else {	/* COMMIT_WMAP */
> +			} else { /* COMMIT_WMAP */
>  
>  				/* free child extents covered by parent */
>  				xadlock.xdlist = &p->xad[index + 1];
> @@ -2605,20 +2683,24 @@ s64 xtTruncate(tid_t tid, struct inode *ip, s64 newsize, int flag)
>  	}
>  
>  	/*
> -	 * parent page become empty: free the page
> -	 */
> +		 * parent page become empty: free the page
> +		 */
>  	if (index == XTENTRYSTART) {
> -		if (log) {	/* COMMIT_PWMAP */
> +		if (log) { /* COMMIT_PWMAP */
>  			/* txCommit() with tlckFREE:
> -			 * free child extents covered by parent;
> -			 * invalidate parent if COMMIT_PWMAP;
> -			 */
> +				 * free child extents covered by parent;
> +				 * invalidate parent if COMMIT_PWMAP;
> +				 */
>  			tlck = txLock(tid, ip, mp, tlckXTREE);
> -			xtlck = (struct xtlock *) & tlck->lock;
> +			if (IS_ERR(tlck)) {
> +				XT_PUTPAGE(mp);
> +				return PTR_ERR(tlck);
> +			}
> +			xtlck = (struct xtlock *)&tlck->lock;
>  			xtlck->hwm.offset =
> -			    le16_to_cpu(p->header.nextindex) - 1;
> +				le16_to_cpu(p->header.nextindex) - 1;
>  			tlck->type = tlckXTREE | tlckFREE;
> -		} else {	/* COMMIT_WMAP */
> +		} else { /* COMMIT_WMAP */
>  
>  			/* free child extents covered by parent */
>  			xadlock.xdlist = &p->xad[XTENTRYSTART];
> @@ -2832,8 +2914,12 @@ s64 xtTruncate_pmap(tid_t tid, struct inode *ip, s64 committed_size)
>  		return (xoff + xlen) << JFS_SBI(ip->i_sb)->l2bsize;
>  	}
>  	tlck = txLock(tid, ip, mp, tlckXTREE);
> +	if (IS_ERR(tlck)) {
> +		XT_PUTPAGE(mp);
> +		return PTR_ERR(tlck);
> +	}
>  	tlck->type = tlckXTREE | tlckFREE;
> -	xtlck = (struct xtlock *) & tlck->lock;
> +	xtlck = (struct xtlock *)&tlck->lock;
>  	xtlck->hwm.offset = index;
>  
>  
> @@ -2865,7 +2951,11 @@ s64 xtTruncate_pmap(tid_t tid, struct inode *ip, s64 committed_size)
>  		 * invalidate parent if COMMIT_PWMAP;
>  		 */
>  		tlck = txLock(tid, ip, mp, tlckXTREE);
> -		xtlck = (struct xtlock *) & tlck->lock;
> +		if (IS_ERR(tlck)) {
> +			XT_PUTPAGE(mp);
> +			return PTR_ERR(tlck);
> +		}
> +		xtlck = (struct xtlock *)&tlck->lock;
>  		xtlck->hwm.offset = le16_to_cpu(p->header.nextindex) - 1;
>  		tlck->type = tlckXTREE | tlckFREE;
>  
> diff --git a/fs/jfs/jfs_xtree.h b/fs/jfs/jfs_xtree.h
> index 0f6cf5a1c..fd654908f 100644
> --- a/fs/jfs/jfs_xtree.h
> +++ b/fs/jfs/jfs_xtree.h
> @@ -99,7 +99,7 @@ typedef union {
>   */
>  extern int xtLookup(struct inode *ip, s64 lstart, s64 llen,
>  		    int *pflag, s64 * paddr, int *plen, int flag);
> -extern void xtInitRoot(tid_t tid, struct inode *ip);
> +extern int xtInitRoot(tid_t tid, struct inode *ip);
>  extern int xtInsert(tid_t tid, struct inode *ip,
>  		    int xflag, s64 xoff, int xlen, s64 * xaddrp, int flag);
>  extern int xtExtend(tid_t tid, struct inode *ip, s64 xoff, int xlen,
> diff --git a/fs/jfs/namei.c b/fs/jfs/namei.c
> index 442d62679..1d538b107 100644
> --- a/fs/jfs/namei.c
> +++ b/fs/jfs/namei.c
> @@ -128,7 +128,11 @@ static int jfs_create(struct mnt_idmap *idmap, struct inode *dip,
>  	/*
>  	 * initialize the child XAD tree root in-line in inode
>  	 */
> -	xtInitRoot(tid, ip);
> +	rc = xtInitRoot(tid, ip);
> +	if (rc) {
> +		txAbort(tid, 0);
> +		goto out3;
> +	}
>  
>  	/*
>  	 * create entry in parent directory for child directory
> @@ -261,7 +265,11 @@ static struct dentry *jfs_mkdir(struct mnt_idmap *idmap, struct inode *dip,
>  	/*
>  	 * initialize the child directory in-line in inode
>  	 */
> -	dtInitRoot(tid, ip, dip->i_ino);
> +	rc = dtInitRoot(tid, ip, dip->i_ino);
> +	if (rc) {
> +		txAbort(tid, 0);
> +		goto out3;
> +	}
>  
>  	/*
>  	 * create entry in parent directory for child directory
> @@ -944,7 +952,11 @@ static int jfs_symlink(struct mnt_idmap *idmap, struct inode *dip,
>  	/*
>  	 * write symbolic link target path name
>  	 */
> -	xtInitRoot(tid, ip);
> +	rc = xtInitRoot(tid, ip);
> +	if (rc) {
> +		txAbort(tid, 0);
> +		goto out3;
> +	}
>  
>  	/*
>  	 * write source path name inline in on-disk inode (fast symbolic link)
> @@ -1260,6 +1272,10 @@ static int jfs_rename(struct mnt_idmap *idmap, struct inode *old_dir,
>  			tlck = txLock(tid, old_ip,
>  				    (struct metapage *) &JFS_IP(old_ip)->bxflag,
>  				      tlckDTREE | tlckBTROOT | tlckRELINK);
> +			if (IS_ERR(tlck)) {
> +				rc = PTR_ERR(tlck);
> +				goto out_tx;
> +			}
>  			dtlck = (struct dt_lock *) & tlck->lock;
>  			ASSERT(dtlck->index == 0);
>  			lv = & dtlck->lv[0];
> 
> 
> base-commit: dc59e4fea9d83f03bad6bddf3fa2e52491777482
> -- 
> This is an AI-generated patch subject to moderation.
> Reply with '#syz upstream' to Sign-off the patch as a human author
> and send it to the upstream kernel mailing lists.
> Reply with '#syz reject' to reject it ('#syz unreject' to undo).
> 
> See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
> You can comment on the patch as usual, syzbot will try to address
> the comments and send a new version of the patch if necessary.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
