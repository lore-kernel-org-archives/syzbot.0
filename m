Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECF3D1DEFE8;
	Thu, 11 Jun 2026 13:52:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781185945; cv=none; b=rqyl1LNzpflbrY8w71xneOttuMYQSGHMHUSFHbKN6DqeCYXMeudE49S/WYQKRnmTcTIBnmTeI5HKJrn7DeOle4pcK9rvcoR4ywCk9MTcWzsDj1CqGK/xXLQh+pPEMhkts/iNXlN6UFVkKVhps/GXzF7h/Is2xUlzAioApNtoAc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781185945; c=relaxed/simple;
	bh=tZZk3D6HLs4E6dfIRlQwYBIiHMyklj2a1B52R2Fq2mQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=K9Q6RyaSNYZoPhAKFTn9kAkJ5/U+Ji0Kj5riq5f5YTGPj2LR2nNItO9rGhy5cYHU5cU/R9lpieO/SKuKZDChX9w0LHed7E5Y55/cXX7OXtup6czY0JS+AjXUGgGk1X38cFJXuFPv4S1GK4bzq7CRoK1EKbSA3LzjBIrE3aJbiwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dM73evRg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dM73evRg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29BD21F00893;
	Thu, 11 Jun 2026 13:52:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781185944;
	bh=trCpG7OYfxnjH2p0gtbocSZgOkcD6A+aryRBCDUbrkc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=dM73evRgIH6Tc0t4MT6FmSArUfNHA6XbB0+n3hG2uul6GVQNExDXuAKD+omFLkxXq
	 L9yih0T0Hr7pZ6W1rmjbx8is8+cgZ61chG+VdVg1KTOp4YrRQh+moiwslzeXmYib96
	 QmwT2TabtDoEDkyjB4FOFb3PiWf8GGJsnyfiIPQ3HBvqYA/GJ/4oICjbiHK4Y6IvP0
	 ByTLMlnoDUfkNRVHy70E/eju975PEOPc9zScG1x5FK/WI+wSaDk+lPtN16CeXoWvY/
	 M7AgL7l2wUwgkuIvRl11zk630XGtsTT65nVCKpr81I4+fChK9tUw6vPaRXBYRlJxni
	 8Joe3Q7i68zJA==
Date: Thu, 11 Jun 2026 15:52:16 +0200
From: "Oscar Salvador (SUSE)" <osalvador@kernel.org>
To: syzbot ci <syzbot+ci07d784447d67ca63@syzkaller.appspotmail.com>
Cc: akpm@linux-foundation.org, david@kernel.org, david@redhat.com,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	lorenzo.stoakes@oracle.com, mhocko@suse.com, muchun.song@linux.dev,
	osalvador@suse.de, vbabka@kernel.org, syzbot@lists.linux.dev,
	syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot ci] Re: Implement a new generic pagewalk API
Message-ID: <aiq9kD3loZWsfZTN@localhost.localdomain>
References: <20260525165528.184397-1-osalvador@suse.de>
 <6a153468.050a0220.7dd1.0004.GAE@google.com>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="HNkqtG5OHNgJiC2N"
Content-Disposition: inline
In-Reply-To: <6a153468.050a0220.7dd1.0004.GAE@google.com>


--HNkqtG5OHNgJiC2N
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, May 25, 2026 at 10:49:28PM -0700, syzbot ci wrote:
> syzbot ci has tested the following series
> 
> [v3] Implement a new generic pagewalk API
> https://lore.kernel.org/all/20260525165528.184397-1-osalvador@suse.de
> * [RFC PATCH v3 1/8] mm: Add softleaf_from_pud
> * [RFC PATCH v3 2/8] mm: Add {pmd,pud}_huge_lock helper
> * [RFC PATCH v3 3/8] mm: Implement folio_pmd_batch
> * [RFC PATCH v3 4/8] mm: Implement pt_range_walk
> * [RFC PATCH v3 5/8] mm: Make /proc/pid/smaps use the new generic pagewalk API
> * [RFC PATCH v3 6/8] mm: Make /proc/pid/numa_maps use the new generic pagewalk API
> * [RFC PATCH v3 7/8] mm: Make /proc/pid/pagemap use the new generic pagewalk API
> * [RFC PATCH v3 8/8] mm: Make /proc/pid/clear_refs use the new generic pagewalk API
> 
> and found the following issue:
> general protection fault in clear_refs_write
> 
> Full report is available here:
> https://ci.syzbot.org/series/0beab2d0-9d88-4288-ac81-b294e51c057d

#syz test

 

-- 
Oscar Salvador
SUSE Labs

--HNkqtG5OHNgJiC2N
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename=0001-fix.patch

From 59776435d1beca2bd9446050450afe04453a99e8 Mon Sep 17 00:00:00 2001
From: Oscar Salvador <osalvador@suse.de>
Date: Thu, 11 Jun 2026 13:58:44 +0200
Subject: [PATCH] fix

---
 fs/proc/task_mmu.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 1134dfb3dab0..fadc6356f84e 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -1710,6 +1710,7 @@ static ssize_t clear_refs_write(struct file *file, const char __user *buf,
 			else if (ret < 0)
 				break;
 
+			flags &= ~PT_TYPE_NONE;
 			pt_type = pt_range_walk_start(&ptw, vma, vma->vm_start, vma->vm_end, flags);
 			while (pt_type != PTW_DONE) {
 
-- 
2.35.3


--HNkqtG5OHNgJiC2N--
