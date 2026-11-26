Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795711274;
	b=WDnNjJGhEskvFL93fTBYdvasxA+U0C5mtYYCu1gY6v3vCJo2RrCtcdygVH6QTd5kphRs
	 HQNjP/3k1RBD6tGBaYJJLDUUf1XRryuG0nBCIpgxEoDdg9M/vOydFfQQIqBKzZtFtIQc5
	 YujCdTVsLRbcmwkaXBNftiJCoTj7FEJJthjJDR688da/nvuFvuDcjttsXv07Psh5Ojy4f
	 n2He/EVXiR3C7CPhoGy6QMyP/V9JSXeUI8DRE+34c18sHOc0OSXIelzSv83Inx/zaHe7L
	 hgkuIH9yR5p3/GWv7URxhW+gb/tXMMzPgPCWAe7MwCEfvuNljf2uYgdSaw9twpOHZgA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795711274;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Message-ID:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Date;
	bh=7pGVcnyCCOfV7sYm8+3euVTJqmPuA5Re8gukiMfAmY8=;
	b=Ke/R9VbYLkaeojMWnzT1w6UOWNt6rFyKKwOu8eKHOF6pQwlJWYew4V/mCyh/BJwrc8lF
	 Akx7wptxYi/vFOBw6/V5zdkrceEfg68Dr5rv4bBRs5an/ygWtH4q63ouzfWgM06Rb3UHC
	 /wh0ZEy0xnbhOdWTcleFp+GDhR+MRoQathRZFSXtSupDsJoiESlsdQu+uc40APzWkinsE
	 sbJjn0X/5I1enN/dez0GgKYFiXjvnS9RQzjwge76jOISm53Kpi9BKs76uMOWLNjrEsEEg
	 yJjr62zbbW19YXBkbV7gCokfzVKfShjg7EFi916gGCguXwspRm3TBMxUQNZNdVB3MUg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XhqMeip1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 3C4BD606A327
	for <syzbot@lists.linux.dev>; Thu, 26 Nov 2026 16:41:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XhqMeip1
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 85C5F1F000CA;
	Thu, 26 Nov 2026 16:41:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795711273;
	bh=7pGVcnyCCOfV7sYm8+3euVTJqmPuA5Re8gukiMfAmY8=;
	h=From:To:Cc:Subject:Date;
	b=XhqMeip1GCCHRA1KRus3jOqU40uxMEusnvTkbhIec8zPv6LA1h4rjx53/VuTBAzZm
	 f1KU+s6iNtKQwFKbTry5tAb1vbjBR2rN8EPc1YsmyOoWA6dvY2fd0iKibMMo5RefhQ
	 C9VNbo7nGfSRRuvekWKZVeyiFYpHnXBncDCbWYN4cezICZvZQD/A5Jwk++06ociRuH
	 FP43zPZO67VvyeiOO74l8oCiykoS9z0z+6Bs5ZjyDS1hq4ScJ4OE0Arrpw0V5E+j3W
	 E4mP1bCaIXMqbbMWvUypGxXgq+2vQ+f5tlUlblIHmwYNuzW2aMSXWSXL9vwYYc1cWe
	 aLPpKWClXFPGA==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: krystianmkaniewski@gmail.com, syzbot@lists.linux.dev
Subject: [PATCH RFC v2] ima: annotate iint->mutex per filesystem type and stacking depth
Message-ID: <c9ac2764-cb73-4ae0-a70d-109d40ba5b9d@mail.kernel.org>
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
Date: Thu, 26 Nov 2026 16:41:13 +0000 (UTC)

ima_iint_lockdep_annotate() currently assigns a global lockdep class
ima_iint_mutex_key[depth] indexed solely by inode->i_sb->s_stack_depth.
Consequently, all non-stacked filesystems (s_stack_depth == 0) share the
same lockdep class for iint->mutex, allowing lockdep to falsely bridge lock
dependencies across unrelated filesystems.

With a custom IMA FILE_CHECK policy measuring files across filesystems,
lockdep observes a false circular dependency cycle between overlayfs, ext4,
and sysfs: overlayfs directory creation links ovl_i_mutex_dir_key to ext4
sb_writers, opening an ext4 file with O_TRUNC links sb_writers to
ima_iint_mutex_key[0] in process_measurement(), opening /sys/power/resume
with O_RDWR links the same ima_iint_mutex_key[0] to kernfs of->mutex via
integrity_kernel_read(), and writing an overlayfs path to /sys/power/resume
acquires ovl_i_mutex_dir_key while holding of->mutex in resume_store().

Fix this by adding per-filesystem-type lockdep keys
i_ima_iint_key[FILESYSTEM_MAX_STACK_DEPTH + 1] (guarded by CONFIG_IMA) to
struct file_system_type and updating ima_iint_lockdep_annotate() to set the
class of iint->mutex to &sb->s_type->i_ima_iint_key[depth]. This isolates
iint->mutex across unrelated filesystems, breaks the false cycle between
ext4 and sysfs, and preserves distinct lockdep classes for each stacking
layer (including nested overlayfs and pseudo-filesystems with s_stack_depth
== FILESYSTEM_MAX_STACK_DEPTH).

Assisted-by: Gemini:gemini-4-hydrogen Gemini:gemini-3.8-flash syzbot
Reported-by: syzbot+da1d15f707a556f6e48c@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=da1d15f707a556f6e48c
Link: https://syzkaller.appspot.com/ai_job?id=f0feaef1-2d84-47cc-908f-143543aa7da9
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
Cc: "Eric Snowberg" <eric.snowberg@oracle.com>
Cc: "Jan Kara" <jack@suse.cz>

---
v2:
- Shortened the commit message by removing the quoted lockdep report and detailed lock chain walkthrough.
- Removed Markdown backticks from the commit message.

v1:
https://lore.kernel.org/all/3579fbbf-56d8-4607-b372-3ef99fd7b51a@mail.kernel.org/T/
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
