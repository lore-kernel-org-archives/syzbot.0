Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1431F2F8EB8
	for <syzbot@lists.linux.dev>; Fri,  8 May 2026 19:16:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778267768; cv=none; b=JKdRzzQLIlTWmWK9/nttdCOf/einAoszw62L0MqEDe708Wuh+FE4AMnN26WMj6FC9pmPF5TGym6MV0FVjpt4pENseUadpaUyZPil4G5baCMx/EE/Kn2fofzh3+oFkjHzVzl7Bz26XAaOmMEGbPH9MdNez8GI6KZZLS2lJvqdNcc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778267768; c=relaxed/simple;
	bh=amRjUOdbE7c5Abs7odHg7jmxqzBxQzuMagElI1jmrrU=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=u8okKuurZ4HvNTXkX1RecWrHZOwKFh6t0WFFVvZVjSerwHvlvqo2tXuPk/Y6xAxC83vVUmJfpDkvMtV3EPv7nsB87dsqGsVW8eAdKwGqcaOm7ciJTNf3cChegguwZnLr9tA1nj9PvFtLDIhBEgHuSXMaMRS9HFf1vrCOg4CFkqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jm1CSUIe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jm1CSUIe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB669C2BCB0;
	Fri,  8 May 2026 19:16:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778267768;
	bh=amRjUOdbE7c5Abs7odHg7jmxqzBxQzuMagElI1jmrrU=;
	h=From:To:Cc:Subject:Date:From;
	b=jm1CSUIeZRUIHfo1PwWdL1N4bR7f6DlwovjFtcanxqj34Wt/bVRCVKVBZS7GM3P21
	 a97WZUUny3e8KyT/FMbFhrXOrHUhlx3XFsArq7p43yfQAERCCv0tnm/5N4IB9t33ZT
	 nXzXi7/D7eZfTpCB55VDhKApzqfOxXwS83okuaDdcKaISmiSGWrp/mTBZ4H+UWdGq/
	 INMFQl/eoVYO03BdoyiAz0OwwY3ennAoVyvDBOvjpCgqFa8IfbfEXvr55hlOHUNj0V
	 tg9VtX45m6liqGoQSJ1pMVGiU0LSUgxpn+OBVaREmyGtgq5fVZOADwVMlBoVX+MOkJ
	 DGI2LaC1wDfQA==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] jbd2: fix null-ptr-deref in jbd2_journal_dirty_metadata()
Message-ID: <784d7c31-66f4-4f22-8115-2888a33b5260@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Fri,  8 May 2026 19:16:07 +0000 (UTC)

jbd2: fix null-ptr-deref in jbd2_journal_dirty_metadata()

The syzkaller reproducer triggers a null-pointer dereference in
jbd2_journal_dirty_metadata().

The root cause is that jbd2_journal_dirty_metadata() unconditionally
dereferences handle->h_transaction->t_journal at the very beginning of
the function. If handle->h_transaction is NULL, this causes a kernel
panic.

This can happen when a journal is aborted. For example, ocfs2_xa_set()
calls ocfs2_xa_prepare_entry(), which attempts to allocate clusters for
a large xattr and calls ocfs2_extend_trans() to extend the transaction.
ocfs2_extend_trans() calls jbd2_journal_restart() to restart the
transaction. In jbd2_journal_restart(), the handle is first detached
from the current transaction (handle->h_transaction = NULL), and then
start_this_handle() is called to start a new transaction. Because the
journal is aborted, start_this_handle() fails and returns -EROFS.
jbd2_journal_restart() returns this error, leaving handle->h_transaction
as NULL.

The -EROFS error propagates back up to ocfs2_xa_set(). ocfs2_xa_set()
catches the error and jumps to the out_dirty label. By design, it tries
to dirty the buffer to leave the xattr header in a sane state despite
the error, so it calls ocfs2_xa_journal_dirty().
ocfs2_xa_journal_dirty() calls jbd2_journal_dirty_metadata() with the
detached handle.

In jbd2_journal_dirty_metadata(), the local variable journal is
initialized with transaction->t_journal at the declaration block. Since
transaction (handle->h_transaction) is NULL, dereferencing it causes the
KASAN null-ptr-deref crash.

This bug was made more prominent by commit 4a734f0869f9 ("jbd2: fix
assertion 'jh->b_frozen_data == NULL' failure when journal aborted"),
which removed the early is_handle_aborted(handle) check in
jbd2_journal_dirty_metadata(). However, even before that commit, the
variable journal was initialized at declaration, so the NULL pointer
dereference technically existed but was less obvious.

To fix this, add an early check for is_handle_aborted(handle) (which
safely handles !handle->h_transaction by short-circuiting) before
dereferencing transaction->t_journal. The existing
is_handle_aborted(handle) check inside the jh->b_state_lock is kept to
prevent the race condition that commit 4a734f0869f9 originally fixed.

Assisted-by: Gemini:gemini-3.1-pro-preview
To: <linux-kernel@vger.kernel.org>
Cc: <jack@suse.com>
Cc: <linux-ext4@vger.kernel.org>
Cc: <tytso@mit.edu>

---
diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
index 4885903bb..183688035 100644
--- a/fs/jbd2/transaction.c
+++ b/fs/jbd2/transaction.c
@@ -1517,10 +1517,15 @@ void jbd2_buffer_abort_trigger(struct journal_head *jh,
 int jbd2_journal_dirty_metadata(handle_t *handle, struct buffer_head *bh)
 {
 	transaction_t *transaction = handle->h_transaction;
-	journal_t *journal = transaction->t_journal;
+	journal_t *journal;
 	struct journal_head *jh;
 	int ret = 0;
 
+	if (is_handle_aborted(handle))
+		return -EROFS;
+
+	journal = transaction->t_journal;
+
 	if (!buffer_jbd(bh))
 		return -EUCLEAN;
 


base-commit: 7fd2df204f342fc17d1a0bfcd474b24232fb0f32
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to send it to the mailing list.
Reply with '#syz reject' to reject it.

See  for more information.
