Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51CF43F23BF;
	Thu, 11 Jun 2026 12:01:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781179302; cv=none; b=WziH9ZxsgU2tEaq5a4IIE6c7/C6YbZ5sUZsxRA/gMCWxN+BGo1RydQos/BZZRoqHziyxL9fZS52i6+QeLzyD9VAhc2/QAZzwicaubpQ9MQZGqinfsIhqUX5TvddDKxsZrgoSrMmuWCScONpUKWPmvic/LIgrur+7YjEw5g0MSKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781179302; c=relaxed/simple;
	bh=McOEWWC9dR8/OifOaNYfjsSL6GwbDAkOq/D9dUAXmxo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KQ1FbPzXV4e0i9qtMXG1E2hE7Ser3pe1BGK4y/Vy6yTJ7cgbKukAgftbdn/mObrVnbSt0xhgKpoHuac7LfeZAjvMhU5uPJDuf8QbV1TNGZlhVKFJlRcXhbMOfqeucrM31MefUNlLmDsUvOoyQuwiWGTPQvfM0M9mz35Q3TMIxMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LUPT9KJF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LUPT9KJF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3B501F00893;
	Thu, 11 Jun 2026 12:01:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781179301;
	bh=HH5VtNr2KT+68fL1jugLmwwkhnImVC0Sb5WzuYdHcBw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=LUPT9KJF2Gly/lJageiBR5OS+ZsSCltsXDAWTqNgnjDvRXpNw6VROiYW4xMsf4Nfz
	 zlkPMmkEKXvzpCSeT1Q+Vt2z26rP+5AsqV987kmlh26TsPaoDh/qcDDjaeS2mApyVf
	 LlWnRQ4otUasQ16KJiDnuYX+4unwZ/hLpQ97mdkbBi9PPEp3FxHBiB2IQxlNcnfImk
	 thAwEMXBVmmxLWhu5elHFtcI2QfxWCc4bmlDjgVhYTuUhS+Ynpadpw2L1JxhJbnZ5t
	 +P4ZjjljRfEkBaN7YtDyw6RImW1RLetIFeAtm/p9NYItFEJlCTWDVjeLVSeixgY1+F
	 sNHm3kh/McQgg==
Date: Thu, 11 Jun 2026 14:01:34 +0200
From: "Oscar Salvador (SUSE)" <osalvador@kernel.org>
To: syzbot ci <syzbot+ci07d784447d67ca63@syzkaller.appspotmail.com>
Cc: akpm@linux-foundation.org, david@kernel.org, david@redhat.com,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	lorenzo.stoakes@oracle.com, mhocko@suse.com, muchun.song@linux.dev,
	osalvador@suse.de, vbabka@kernel.org, syzbot@lists.linux.dev,
	syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot ci] Re: Implement a new generic pagewalk API
Message-ID: <aiqjnj613Ut2bK1n@localhost.localdomain>
References: <20260525165528.184397-1-osalvador@suse.de>
 <6a153468.050a0220.7dd1.0004.GAE@google.com>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="OMyYprDkbMQMsjSv"
Content-Disposition: inline
In-Reply-To: <6a153468.050a0220.7dd1.0004.GAE@google.com>


--OMyYprDkbMQMsjSv
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

--OMyYprDkbMQMsjSv
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename=0001-fix.patch

From 252fd5679cc74ebe82d01d5bf1523184f7e323be Mon Sep 17 00:00:00 2001
From: Oscar Salvador <osalvador@suse.de>
Date: Thu, 11 Jun 2026 13:58:44 +0200
Subject: [PATCH] fix

---
 fs/proc/task_mmu.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 1134dfb3dab0..87515949b09d 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -1710,6 +1710,7 @@ static ssize_t clear_refs_write(struct file *file, const char __user *buf,
 			else if (ret < 0)
 				break;
 
+			flags &= ~PT_TYPE_NONE
 			pt_type = pt_range_walk_start(&ptw, vma, vma->vm_start, vma->vm_end, flags);
 			while (pt_type != PTW_DONE) {
 
-- 
2.35.3


--OMyYprDkbMQMsjSv--
