Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 236F63C9429
	for <syzbot@lists.linux.dev>; Thu, 21 May 2026 12:40:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779367235; cv=none; b=jMkai+N3Fbp/U31fZq8JpG4eD3FbTCtmh9sDHE/6C6ev41IrItg0GgTHpskQhrLh84meyM8t6EB+7BQxFnMSFC6qjCBePFtILMySmOfKRLoVFUWGud53opWu+OTp1MEdDUB8crfaEDl+q8MIQoTQD4UZ6Mumyk71f9wq+Ls7qoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779367235; c=relaxed/simple;
	bh=ca0rCXCVQF4XkvG5/JV3qZM6cQmKPlaW0vtfQB7+lso=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bgGNGl1kQ3p58O/hbYB/PcgDwO2jKjCby7PAvzQGfys7U4JHCD8AqeZ3ucP2N0NC3DKy3CfQ+uxUrbrtENQ8f1jbQAJLDKKwWXWjhSWUZ5winf10SrZU5Y8ocrKntNTyUXmyezF6Qcaj//NOGqdwQkCTEnAfeRPkX+wbfR0NbJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=E0xM8H6h; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="E0xM8H6h"
Received: by smtp.kernel.org (Postfix)
	id D10931F00A3C; Thu, 21 May 2026 12:40:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BE7F1F000E9;
	Thu, 21 May 2026 12:40:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779367233;
	bh=runKwkzf6NmsA6ICmTLGmbaDzOtOu2w+RHrsoXu/SlU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E0xM8H6hjjvJo/DNJfJlWC9WdevFFz/mrABvyVBgIPV0hvtv/KZ/PYDqzIGaHphpb
	 LxXHHvtH+ApZlnedT5ydk8ek5WKoyAT9UDXkfjSvapTfCi7gY+FtiPmD5hne4dUhnK
	 FTJvLALxDOViGYy0kEhqhPMhU3Uv8YZyT2H0Y9li/bLAwWVAtPRpukWtP45ZCpEP1h
	 M0UHqEHzOlBUtHoouyuO4v/Fkr7CfwhDl/NxZzEaqJbMYOIY8PRyCJZzEHgjXjJV21
	 13Osp0sQQLqbaL9CX8tf/ha1083HIfF1nl8jSr6LgcRpO7qhB1HGHlnOyaScT1V/t5
	 lBeHV/VC31cMQ==
From: Christian Brauner <brauner@kernel.org>
To: syzkaller-bugs@googlegroups.com,
	linux-kernel@vger.kernel.org,
	syzbot <syzbot@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>,
	adrianhuang0701@gmail.com,
	akpm@linux-foundation.org,
	kexinsun@smail.nju.edu.cn,
	oleg@redhat.com,
	peterz@infradead.org,
	syzbot@lists.linux.dev,
	tglx@kernel.org
Subject: Re: [PATCH] signal: clear JOBCTL_PENDING_MASK for caller in zap_other_threads()
Date: Thu, 21 May 2026 14:40:24 +0200
Message-ID: <20260521-kultur-zahnpasta-f09198836179@brauner>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <36638f2b-6f91-4e33-b630-fd7045eebc84@mail.kernel.org>
References: <36638f2b-6f91-4e33-b630-fd7045eebc84@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Developer-Signature: v=1; a=openpgp-sha256; l=1423; i=brauner@kernel.org; h=from:subject:message-id; bh=ca0rCXCVQF4XkvG5/JV3qZM6cQmKPlaW0vtfQB7+lso=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWTx/bVS7FOv32Ex5WTwv2L1aU/KFT48s0jpFLspf0ZQK ETfJ2FDRykLgxgXg6yYIotDu0m43HKeis1GmRowc1iZQIYwcHEKwETYjBkZFkr+3eJyKv2MkKPj 5sSX05LeyUxvZDGUq1c4tjfu6Z+4nYwMfR6mrAc/zIhYv3C99bYHKYfsRYyXpu+2aLE5L1W1+VQ bKwA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit

On Thu, 21 May 2026 09:05:43 +0000, syzbot wrote:
> When a multi-threaded process receives a stop signal (e.g., SIGSTOP),
> do_signal_stop() sets JOBCTL_STOP_PENDING and JOBCTL_STOP_CONSUME on all
> threads and sets signal->group_stop_count to the number of threads. If
> one of the threads concurrently calls execve(), de_thread() invokes
> zap_other_threads() to kill all other threads. zap_other_threads()
> aborts the pending group stop by resetting signal->group_stop_count to 0
> and clears the JOBCTL_PENDING_MASK for all other threads. However, it
> fails to clear the job control flags for the calling thread.
> 
> [...]

Applied to the vfs.fixes branch of the vfs/vfs.git tree.
Patches in the vfs.fixes branch should appear in linux-next soon.

Please report any outstanding bugs that were missed during review in a
new review to the original patch series allowing us to drop it.

It's encouraged to provide Acked-bys and Reviewed-bys even though the
patch has now been applied. If possible patch trailers will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. If in doubt, please check the listed branch.

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git
branch: vfs.fixes

[1/1] signal: clear JOBCTL_PENDING_MASK for caller in zap_other_threads()
      https://git.kernel.org/vfs/vfs/c/71556f3d55ee
