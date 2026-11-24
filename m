Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795544625;
	b=wHKjyVC9aBC1fELmDuZOeGa9fT0ZPmFQsrg0eDoMcg5zQ0fENDkZijTlaONbCWga44Gg
	 9xHofnknRuplWPE0RGgnyeqmBnkAZbhjsMn6r8/rPGKG///wiIS2m5IUPAVs2HfGiqdQ+
	 4oB72baZsk2J3lWDfmm0iPb3ys21ydYp62/0656kaXeMfa6DWT4/rO3AtAggDj7tujCRd
	 HjSv4ImoQ8Bat9Af/km/7tB58tGgdP178pCMs7PrDaMbt3Qx0uF4tRhZ2DbDDOK+3Jc1B
	 1cQNtm+JANBYrwUJKOQUNnimx4Xs1WvJfPapQR22MZC8mOBP5yLVMf4RAp2IHIT4xdQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795544625;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Message-ID:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Date;
	bh=3ZLHHzTFSPCq8KFxJzOD+ChaGCpFtIixu8ZR6KRCiek=;
	b=Li+yA66MXAOi/Gx/+fm1LAdsoE+aMRl7qoJpHjMWhsRgWIZI85BoeIEua1nl9vHEXqb5
	 MpwlnN/YvvpbpS+1+x2t9d0qDmDjoohmGJjJXDs/FxXFNZrILGyGR8iSk84S8xtyGzXfn
	 4OFznFVb0jw1ygIXqaOlCMcyJU64QV1IW8274nfBBbxHyhujx7FM1WTCX98TQVhp6e3kn
	 H2mjKAj9u4f2/iY6QJnZ88m6K20iNnkv5UAy/HwK62P4C1elvIgRTbhpHW95q/q1Apknl
	 DZvFVISF74mRqOqmqgrOpYDUQmhLh1PblgnAeLgAnAPSpwNeh99Avwk4DcfYhycfgZg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=W8EhYogK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 0EFDA606A32A
	for <syzbot@lists.linux.dev>; Tue, 24 Nov 2026 18:23:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=W8EhYogK
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 2D51F1F000C0;
	Tue, 24 Nov 2026 18:23:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795544624;
	bh=3ZLHHzTFSPCq8KFxJzOD+ChaGCpFtIixu8ZR6KRCiek=;
	h=From:To:Cc:Subject:Date;
	b=W8EhYogKldMNN+KGkF9v/Y3Teg5pskEPTv9zSnnXLhUuqeZOMwBL4Kbosl/F65GKx
	 qaUTqWJ0nw/BAxVwhsSYk6IUS4LFepe1XfxwLmDdbdHtT3Hi2uZKptn4heG1O6sNHi
	 sTvL3Eua1ZmzUegrMGru3Q5b775mCA2hruaCSEpS5xTKo5gY0ui6do6s0iHANUDhJP
	 H7duSMWkvtkWjWJj8CvV/di7g5722I6ydnWHg4piUiVb9UlcGgABWmq7yqKSXSLQ4O
	 s5wYyeTcQh6/wYIsdvNTHE74Onc/iWmGxCRKuFzhV4S6IeMaF63cQtvjHxkkvhNNJn
	 YwLHIz6Sy/9Ew==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] ima: annotate iint->mutex per filesystem type and stacking depth
Message-ID: <3579fbbf-56d8-4607-b372-3ef99fd7b51a@mail.kernel.org>
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Post: <mailto:syzbot@lists.linux.dev>
List-Help: <mailto:syzbot+help@lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
List-Owner: <mailto:syzbot+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Tue, 24 Nov 2026 18:23:44 +0000 (UTC)

ima_iint_lockdep_annotate() currently assigns a global lockdep class
(`ima_iint_mutex_key[depth]`) indexed solely by
`inode->i_sb->s_stack_depth`. Because of this, all non-stacked filesystems
(`s_stack_depth == 0`) share the exact same lockdep class
`&ima_iint_mutex_key[0]` for `ima_iint_cache::mutex`, allowing lockdep to
falsely bridge lock dependencies between unrelated filesystems such as ext4
and sysfs.

Specifically, creating an entry in an overlayfs directory acquires the
overlayfs directory `inode->i_rwsem` (`&ovl_i_mutex_dir_key[depth]#2`) and
then `sb_writers#4` on the upper ext4 superblock in `ovl_create_object()`.
Opening an existing regular file on ext4 with `O_TRUNC` acquires
`sb_writers#4` via `mnt_want_write()` in `do_open()` before calling
`security_file_post_open()` -> `ima_file_check()` ->
`process_measurement()`, which locks `iint->mutex`
(`&ima_iint_mutex_key[0]`). When a custom IMA policy allows measuring sysfs
files, opening `/sys/power/resume` with `O_RDWR` causes
`process_measurement()` to lock `iint->mutex` (also classified as
`&ima_iint_mutex_key[0]`) and read the sysfs file via
`integrity_kernel_read()` -> `seq_read_iter()` -> `kernfs_seq_start()`,
establishing `&ima_iint_mutex_key[0]` -> `&p->lock` -> `&of->mutex` (using
the writable `of->mutex` lockdep class due to `FMODE_WRITE`). Writing an
uncached path on the overlayfs mount to `/sys/power/resume` then holds
`&of->mutex` in `kernfs_fop_write_iter()` while `resume_store()` ->
`lookup_bdev()` -> `kern_path()` -> `lookup_slow()` acquires
`&ovl_i_mutex_dir_key[depth]#2`, completing the false lockdep cycle:

WARNING: possible circular locking dependency detected
is trying to acquire lock:
ffff888076a38c50 (&ovl_i_mutex_dir_key[depth]#2){++++}-{4:4}, at:
lookup_slow+0x46/0x80 fs/namei.c:1941
but task is already holding lock:
ffff88807a4fa480 (&of->mutex){+.+.}-{4:4}, at:
kernfs_fop_write_iter+0x1d8/0x540 fs/kernfs/file.c:336
which lock already depends on the new lock.

the existing dependency chain (in reverse order) is:
-> #4 (&of->mutex){+.+.}-{4:4}:
       kernfs_seq_start+0x5d/0x420 fs/kernfs/file.c:165
       seq_read_iter+0x37e/0xca0 fs/seq_file.c:226
       __kernel_read+0x4ca/0x960 fs/read_write.c:512
       integrity_kernel_read+0x89/0xd0 security/integrity/iint.c:28
       ima_calc_file_hash+0x451/0x890
       security/integrity/ima/ima_crypto.c:280
       ima_collect_measurement+0x51b/0xa00
       security/integrity/ima/ima_api.c:300
       process_measurement+0x1272/0x1c10
       security/integrity/ima/ima_main.c:425
       ima_file_check+0xdc/0x130 security/integrity/ima/ima_main.c:686
       security_file_post_open+0xb3/0x260 security/security.c:2777
-> #3 (&p->lock){+.+.}-{4:4}:
       seq_read_iter+0xa4/0xca0 fs/seq_file.c:183
       ...
-> #2 (&ima_iint_mutex_key[depth]){+.+.}-{4:4}:
       process_measurement+0x7d0/0x1c10
       security/integrity/ima/ima_main.c:319
       ima_file_check+0xdc/0x130 security/integrity/ima/ima_main.c:686
       security_file_post_open+0xb3/0x260 security/security.c:2777
-> #1 (sb_writers#4){.+.+}-{0:0}:
       sb_start_write+0x48/0x1c0 include/linux/fs/super.h:125
       mnt_want_write+0x41/0x90 fs/namespace.c:531
       ovl_create_object+0x10d/0x3b0 fs/overlayfs/dir.c:717
       lookup_open+0x102d/0x1ae0 fs/namei.c:4575
-> #0 (&ovl_i_mutex_dir_key[depth]#2){++++}-{4:4}:
       down_read+0x45/0x320 kernel/locking/rwsem.c:1574
       lookup_slow+0x46/0x80 fs/namei.c:1941
       lookup_bdev+0xc8/0x2b0 block/bdev.c:1268
       resume_store+0x181/0x500 kernel/power/hibernate.c:1286
       kernfs_fop_write_iter+0x3a4/0x540 fs/kernfs/file.c:345

Fix this by adding a per-filesystem-type array
`i_ima_iint_key[FILESYSTEM_MAX_STACK_DEPTH + 1]` (guarded by `CONFIG_IMA`)
to `struct file_system_type`, similar to the existing per-filesystem-type
inode lockdep keys, and updating `ima_iint_lockdep_annotate()` to set the
class of `iint->mutex` to `&sb->s_type->i_ima_iint_key[depth]`. This
isolates `iint->mutex` across unrelated filesystems while preserving
distinct lockdep classes for each stacking layer (including nested
overlayfs mounts) and avoiding collisions at `FILESYSTEM_MAX_STACK_DEPTH`
with non-stacked pseudo-filesystems that set `s_stack_depth =
FILESYSTEM_MAX_STACK_DEPTH`.

Fixes: e044374a8a0a ("ima: annotate iint mutex to avoid lockdep false positive warnings")
Assisted-by: Gemini:gemini-4-hydrogen Gemini:gemini-4-carbon Gemini:gemini-3.8-flash syzbot
Reported-by: syzbot+da1d15f707a556f6e48c@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=da1d15f707a556f6e48c
Link: https://syzkaller.appspot.com/ai_job?id=a9eee2d2-a95f-4524-a3f7-213929fe8238
To: "Christian Brauner" <brauner@kernel.org>
To: "Dmitry Kasatkin" <dmitry.kasatkin@gmail.com>
To: "James Morris" <jmorris@namei.org>
To: <linux-fsdevel@vger.kernel.org>
To: <linux-integrity@vger.kernel.org>
To: <linux-security-module@vger.kernel.org>
To: "Paul Moore" <paul@paul-moore.com>
To: "Roberto Sassu" <roberto.sassu@huawei.com>
To: "Serge E. Hallyn" <serge@hallyn.com>
To: "Alexander Viro" <viro@zeniv.linux.org.uk>
To: "Mimi Zohar" <zohar@linux.ibm.com>
To: "Amir Goldstein" <amir73il@gmail.com>
Cc: "Eric Snowberg" <eric.snowberg@oracle.com>
Cc: "Jan Kara" <jack@suse.cz>

---
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 5b3a100ab..8fd02c303 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2323,6 +2323,9 @@ struct file_system_type {
 	struct lock_class_key i_mutex_key;
 	struct lock_class_key invalidate_lock_key;
 	struct lock_class_key i_mutex_dir_key;
+#ifdef CONFIG_IMA
+	struct lock_class_key i_ima_iint_key[FILESYSTEM_MAX_STACK_DEPTH + 1];
+#endif
 
 	struct lock_class_key d_lookup_key;
 };
diff --git a/security/integrity/ima/ima_iint.c b/security/integrity/ima/ima_iint.c
index 00b249101..9372a2eec 100644
--- a/security/integrity/ima/ima_iint.c
+++ b/security/integrity/ima/ima_iint.c
@@ -32,26 +32,26 @@ struct ima_iint_cache *ima_iint_find(struct inode *inode)
 	return ima_inode_get_iint(inode);
 }
 
-#define IMA_MAX_NESTING (FILESYSTEM_MAX_STACK_DEPTH + 1)
-
 /*
- * It is not clear that IMA should be nested at all, but as long is it measures
- * files both on overlayfs and on underlying fs, we need to annotate the iint
- * mutex to avoid lockdep false positives related to IMA + overlayfs.
- * See ovl_lockdep_annotate_inode_mutex_key() for more details.
+ * Annotate the iint mutex per filesystem type and stacking depth to avoid
+ * lockdep false positives across unrelated filesystems as well as between
+ * stacked filesystems (e.g. overlayfs, including nested overlayfs) and their
+ * underlying filesystems.
+ * See lockdep_annotate_inode_mutex_key() and
+ * ovl_lockdep_annotate_inode_mutex_key() for more details.
  */
 static inline void ima_iint_lockdep_annotate(struct ima_iint_cache *iint,
 					     struct inode *inode)
 {
 #ifdef CONFIG_LOCKDEP
-	static struct lock_class_key ima_iint_mutex_key[IMA_MAX_NESTING];
-
-	int depth = inode->i_sb->s_stack_depth;
+	struct super_block *sb = inode->i_sb;
+	struct file_system_type *type = sb->s_type;
+	int depth = sb->s_stack_depth;
 
-	if (WARN_ON_ONCE(depth < 0 || depth >= IMA_MAX_NESTING))
+	if (WARN_ON_ONCE(depth < 0 || depth > FILESYSTEM_MAX_STACK_DEPTH))
 		depth = 0;
 
-	lockdep_set_class(&iint->mutex, &ima_iint_mutex_key[depth]);
+	lockdep_set_class(&iint->mutex, &type->i_ima_iint_key[depth]);
 #endif
 }
 


base-commit: b6a9fa34ce4187cb69d3c588a4bbffc31ce5db8f
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to Sign-off the patch as a human author
and send it to the upstream kernel mailing lists.
Reply with '#syz reject' to reject it ('#syz unreject' to undo).

See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
You can comment on the patch as usual, syzbot will try to address
the comments and send a new version of the patch if necessary.
syzbot engineers can be reached at syzkaller@googlegroups.com.
