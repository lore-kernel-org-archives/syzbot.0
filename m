Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB8F44E322A
	for <syzbot@lists.linux.dev>; Fri,  2 Oct 2026 16:05:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790957154; cv=none; b=sKJ8MoQ63lnwj9DEIwDNPYFVx7V88n+phA4gQxQ0kkuBuN+qXdnRFA06SKsrLFkZAKnNjXsbCBfdnr3Sfax8cnZSY4o2/kyvCo/1XMqTT+xON3Zng7zstlyRNvutV8rJX8+kffe66iI6mD5IeWxjrutaJcbxsSWPHwUZ9djDdLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790957154; c=relaxed/simple;
	bh=uBpz2zarEN8chCcdxZttOwIfXWk+sPx7EaNqOmzDXTM=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=PIOqRDE59PPzr9KGJuOzzXDT1fnlfwOktP97UGVQcGArq/YkIZ2c1M5PQq9Uxq3HP3KMdl//la6bcXyOlqBXGOZ04NABzc7jQzruYkE+fpsRHkiIj0JuTWN0YkfNlGaHq1wXbL6T6JQP0fSbrno2mfDCmZUETdo55FQ+NTdE/do=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TKSu+IIT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TKSu+IIT"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 7A07A1F0089A;
	Fri,  2 Oct 2026 16:05:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790957152;
	bh=MCWwin93sjmuO+pHXgOxVtwN9Tt3DrFnlgX1uQUiEIk=;
	h=From:To:Cc:Subject:Date;
	b=TKSu+IITc2SSLsrkeX+4AXulybn+xKsSdyrnHxxMvEhPMdXsKb5MK69CpsGRs3i0s
	 /qu6Swt3AYc7Wp29knd1t+5A8ZDfur6l5bjbIvOUl+j7c1MjMv0ILXzMjHUB+PQEY+
	 ypJ2GE29F/vfsO8mljSktQcDVklYxZYxf9CsZ+BkH2VlCAao/908ApWHtrTQWu3owO
	 c3jugoK3jelnVeLA6Akr3CsB2QDe36AUFV9NfyQCaR2lgQdwv41wkDswAFKyPHJZNf
	 MK3U7QJcfTNfQd45Pr1Zx4TeE9ttrLyzs4HAdRyjzjMLFOvSChkl+hkzhnzaYZXUOu
	 WTFoLF4ctdLzw==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] sunrpc: remove unnecessary inode_lock() from cache_write()
Message-ID: <f13e915b-c516-4e9b-9f0e-3e573c6ed61e@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Fri,  2 Oct 2026 16:05:52 +0000 (UTC)

When writing to a sunrpc cache channel file in procfs (such as
/proc/net/rpc/nfsd.export/channel), cache_write() acquires inode_lock() on
the procfs file before calling cache_downcall(). The downcall handler (for
example, svc_export_parse()) may perform path lookup via kern_path(). If
the process's current working directory is set to a directory on procfs,
lookup_slow() acquires inode_lock_shared() on the procfs directory inode
during the path walk. Because both the cache channel file inode and the
directory inode share the same lockdep lock class (&sb->s_type->i_mutex_key
for procfs), lockdep warns of a possible recursive deadlock:

WARNING: possible recursive locking detected
a task is trying to acquire lock:
ffff88819dff12d0 (&sb->s_type->i_mutex_key#11){++++}-{4:4}, at:
lookup_slow+0x46/0x70 fs/namei.c:1935

but task is already holding lock:
ffff88819dff1880 (&sb->s_type->i_mutex_key#11){++++}-{4:4}, at:
cache_write+0x7b/0x210 net/sunrpc/cache.c:961

Call Trace:
 <TASK>
 down_read+0x97/0x200 kernel/locking/rwsem.c:1574
 inode_lock_shared include/linux/fs.h:1039 [inline]
 lookup_slow+0x46/0x70 fs/namei.c:1935
 walk_component fs/namei.c:2282 [inline]
 lookup_last fs/namei.c:2789 [inline]
 path_lookupat+0x3f5/0x8c0 fs/namei.c:2813
 filename_lookup+0x265/0x5d0 fs/namei.c:2842
 kern_path+0x3d/0x150 fs/namei.c:3036
 svc_export_parse+0x237/0xa90 fs/nfsd/export.c:1341
 cache_do_downcall net/sunrpc/cache.c:922 [inline]
 cache_downcall net/sunrpc/cache.c:944 [inline]
 cache_write+0x194/0x210 net/sunrpc/cache.c:962
 proc_reg_write+0x1f6/0x2f0 fs/proc/inode.c:342
 vfs_write+0x29f/0xbb0 fs/read_write.c:685
 ksys_write+0x156/0x270 fs/read_write.c:739
 do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
 </TASK>

Historically, commit da77005f0d64 ("SUNRPC: Remove the global temporary
write buffer in net/sunrpc/cache.c") replaced the shared static write
buffer with page cache allocations and protected those operations with
inode->i_mutex. Later, commit 4b5cff7ed8af ("sunrpc: clean-up cache
downcall") transitioned cache downcalls to private per-call buffers
allocated via kvmalloc().

Since downcalls now allocate a local buffer with kvmalloc() and execute the
thread-safe parse callback without sharing per-file state (unlike
cache_read(), which uses filp->private_data to serialize reader offsets),
inode_lock() in cache_write() is completely unnecessary. Retaining it
needlessly holds the inode lock across callbacks that may invoke VFS
operations.

Remove inode_lock() and inode_unlock() from cache_write(), eliminate the
unused inode and mapping local variables, and drop the unused mapping
argument from cache_downcall().

Fixes: da77005f0d64 ("SUNRPC: Remove the global temporary write buffer in net/sunrpc/cache.c")
Assisted-by: Gemini:gemini-3.8-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+65459fd3b61877d717a3@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=65459fd3b61877d717a3
Link: https://syzkaller.appspot.com/ai_job?id=1c6b93ad-02c3-4136-b61e-7e93a3bcdd07
To: "Anna Schumaker" <anna@kernel.org>
To: "Chuck Lever" <cel@kernel.org>
To: "David S. Miller" <davem@davemloft.net>
To: "Eric Dumazet" <edumazet@google.com>
To: "Jeff Layton" <jlayton@kernel.org>
To: "Jakub Kicinski" <kuba@kernel.org>
To: <linux-nfs@vger.kernel.org>
To: <netdev@vger.kernel.org>
To: "Paolo Abeni" <pabeni@redhat.com>
To: "Trond Myklebust" <trondmy@kernel.org>
To: "Trond Myklebust" <Trond.Myklebust@netapp.com>
Cc: "Dai Ngo" <Dai.Ngo@oracle.com>
Cc: "Simon Horman" <horms@kernel.org>
Cc: <linux-kernel@vger.kernel.org>
Cc: "NeilBrown" <neil@brown.name>
Cc: "Olga Kornievskaia" <okorniev@redhat.com>
Cc: "Tom Talpey" <tom@talpey.com>

---
diff --git a/net/sunrpc/cache.c b/net/sunrpc/cache.c
index 1bc04109d..f77cb9235 100644
--- a/net/sunrpc/cache.c
+++ b/net/sunrpc/cache.c
@@ -925,8 +925,7 @@ static ssize_t cache_do_downcall(char *kaddr, const char __user *buf,
 	return ret;
 }
 
-static ssize_t cache_downcall(struct address_space *mapping,
-			      const char __user *buf,
+static ssize_t cache_downcall(const char __user *buf,
 			      size_t count, struct cache_detail *cd)
 {
 	char *write_buf;
@@ -951,16 +950,12 @@ static ssize_t cache_write(struct file *filp, const char __user *buf,
 			   size_t count, loff_t *ppos,
 			   struct cache_detail *cd)
 {
-	struct address_space *mapping = filp->f_mapping;
-	struct inode *inode = file_inode(filp);
 	ssize_t ret = -EINVAL;
 
 	if (!cd->cache_parse)
 		goto out;
 
-	inode_lock(inode);
-	ret = cache_downcall(mapping, buf, count, cd);
-	inode_unlock(inode);
+	ret = cache_downcall(buf, count, cd);
 out:
 	return ret;
 }


base-commit: 72d3fcf802c45d00b300f25b848a93c3a2bd7c7e
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to Sign-off the patch as a human author
and send it to the upstream kernel mailing lists.
Reply with '#syz reject' to reject it ('#syz unreject' to undo).

See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
You can comment on the patch as usual, syzbot will try to address
the comments and send a new version of the patch if necessary.
syzbot engineers can be reached at syzkaller@googlegroups.com.
