Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76F4219D8BC
	for <syzbot@lists.linux.dev>; Fri, 11 Sep 2026 00:20:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789086058; cv=none; b=WiUXx05Q2iEv2xT4KGC452amoLC7Oj/Pzd+Vr8W1fDt+Z28Y8/j2teehWwgmvBH0kS3QzQOyJ9TXfOD5e8CrZsm8jjUA20yTohYgpbEHhaDzoeb6QTFu8RtIAxGZe8AbjIGRWmeNHa9Ds3Odz47a4/N3dZ4G38DQsDP9+VBsqvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789086058; c=relaxed/simple;
	bh=z4ESMCNv6AM6/dIc91hSieOKdyfxrI2eJMOMKPCzVIg=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=j0TureCAK3GL8Je6zsIGY9oaTan6GlJLiKZlH7kszJmBd/Enw4/imMwsuItquRQyfNEEaKndaW/moNA4hwj6Er5trPzoxz3dO4Kps4Asz4NMysWaQ5ILPPPWoU6Yz6C4MR7NlADr0c3VBCem9oRGNs8ouUO+8yGEmBtqihLL4x4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CEbw41NG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CEbw41NG"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id E8A0A1F000FF;
	Fri, 11 Sep 2026 00:20:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789086057;
	bh=Qmpp3HyYo6dr/8B5f9cE8xvViLRrNYKnpypL1g+zY4Y=;
	h=From:To:Cc:Subject:Date;
	b=CEbw41NG/52EsbAVmHJOUkMnlEVNMlvjxLIIk7sXbl+gtwUTvv9pwa7fGg4ANYO7M
	 mI1pSvfxYI/bgXfjhwxclDGr1MZFqOS1e2v9JH4KPjtVt9IsMg4YuDSpKs4zThul/c
	 juJmdNHCcJXzd8cfLjU2gaJA+gT7DzGjzkwFo2VW8FIuwQ9Z9P3YLogd4HIfmoTTY+
	 qKlG6VgqG68Xd1Sty3rKRVoE5PemNksiKwycaRTPXFkgX3VoiulpxdoQjSVHsYWVp/
	 phuhNSpl54jwRWuy+TktJWLpfvwr7uz84hVlD4fhAiuxiAkXwfXa8spbnTUzHSmcXg
	 Z0w/hCN8SnX8A==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] ceph: reset mon_addr on parse failure and validate initial monmap
Message-ID: <9caae9d3-381b-4026-9411-b38fc08d7ef0@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Fri, 11 Sep 2026 00:20:56 +0000 (UTC)

When configuring Ceph mount options via the fscontext API, setting the
"mon_addr" parameter with an invalid monitor address causes
ceph_parse_mon_addr() to take ownership of param->string into
fsopt->mon_addr before calling ceph_parse_mon_ips(). When
ceph_parse_mon_ips() fails to parse or resolve the address, it returns an
error code without updating copts->num_mon (which remains 0). However,
ceph_parse_mon_addr() returned without freeing or clearing fsopt->mon_addr,
leaving it pointing to the invalid string.

If user space ignores the error returned by the FSCONFIG_SET_STRING command
and proceeds to execute FSCONFIG_CMD_CREATE, ceph_get_tree() is called. The
validation check `if (fsopt->new_dev_syntax && !fsopt->mon_addr)` passes
because fsopt->mon_addr was left non-NULL despite the parsing failure.
ceph_get_tree() then creates the client via create_fs_client() and
ceph_create_client(). During ceph_monc_init(), build_initial_monmap()
allocated a monmap using opt->num_mon without verifying that num_mon is at
least 1, creating a monmap with zero monitors. Later, when
ceph_real_mount() initiates a session with the monitor cluster via
__ceph_open_session() -> pick_new_mon(), pick_new_mon() triggers
BUG_ON(monc->monmap->num_mon < 1):

kernel BUG at net/ceph/mon_client.c:211!
Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
RIP: 0010:pick_new_mon net/ceph/mon_client.c:211 [inline]
RIP: 0010:__open_session+0x799/0x940 net/ceph/mon_client.c:245
Call Trace:
 <TASK>
 ceph_monc_open_session+0x56/0x1a0 net/ceph/mon_client.c:534
 __ceph_open_session+0x16d/0x5e0 net/ceph/ceph_common.c:798
 ceph_real_mount fs/ceph/super.c:1173 [inline]
 ceph_get_tree+0xaef/0x1a40 fs/ceph/super.c:1362
 vfs_get_tree+0x92/0x2a0 fs/super.c:1947
 vfs_cmd_create+0xa2/0x200 fs/fsopen.c:231
 __do_sys_fsconfig fs/fsopen.c:463 [inline]
 __se_sys_fsconfig+0x6b9/0x810 fs/fsopen.c:350
 do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
 </TASK>

Fix this issue in two ways: First, in ceph_parse_mon_addr(), free and reset
fsopt->mon_addr to NULL when ceph_parse_mon_ips() returns an error. This
ensures a consistent context state so that subsequent mount attempts in
ceph_get_tree() correctly reject the configuration with "No monitor
address". Second, as defense-in-depth, validate in build_initial_monmap()
that num_mon is between 1 and CEPH_MAX_MON, returning -EINVAL otherwise,
preventing the creation of a client with an invalid monitor map.

Assisted-by: Gemini:gemini-3.8-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+1dbed5969931c19d3eb5@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=1dbed5969931c19d3eb5
Link: https://syzkaller.appspot.com/ai_job?id=5cec5833-21da-4596-8bd4-1a3b1783fe0d
To: "Alex Markuze" <amarkuze@redhat.com>
To: <ceph-devel@vger.kernel.org>
To: "Ilya Dryomov" <idryomov@gmail.com>
To: "Viacheslav Dubeyko" <slava@dubeyko.com>
Cc: <linux-kernel@vger.kernel.org>

---
diff --git a/fs/ceph/super.c b/fs/ceph/super.c
index 72935f665..0d706b7b3 100644
--- a/fs/ceph/super.c
+++ b/fs/ceph/super.c
@@ -394,13 +394,20 @@ static int ceph_parse_mon_addr(struct fs_parameter *param,
 {
 	struct ceph_parse_opts_ctx *pctx = fc->fs_private;
 	struct ceph_mount_options *fsopt = pctx->opts;
+	int ret;
 
 	kfree(fsopt->mon_addr);
 	fsopt->mon_addr = param->string;
 	param->string = NULL;
 
-	return ceph_parse_mon_ips(fsopt->mon_addr, strlen(fsopt->mon_addr),
-				  pctx->copts, fc->log.log, '/');
+	ret = ceph_parse_mon_ips(fsopt->mon_addr, strlen(fsopt->mon_addr),
+				 pctx->copts, fc->log.log, '/');
+	if (ret) {
+		kfree(fsopt->mon_addr);
+		fsopt->mon_addr = NULL;
+	}
+
+	return ret;
 }
 
 static int ceph_parse_mount_param(struct fs_context *fc,
diff --git a/net/ceph/mon_client.c b/net/ceph/mon_client.c
index c56457378..bcbcf4750 100644
--- a/net/ceph/mon_client.c
+++ b/net/ceph/mon_client.c
@@ -1141,6 +1141,9 @@ static int build_initial_monmap(struct ceph_mon_client *monc)
 	int num_mon = opt->num_mon;
 	int i;
 
+	if (num_mon < 1 || num_mon > CEPH_MAX_MON)
+		return -EINVAL;
+
 	/* build initial monmap */
 	monc->monmap = kzalloc_flex(*monc->monmap, mon_inst, num_mon);
 	if (!monc->monmap)


base-commit: df2908090cda368b01ff43709f51890076c56157
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to Sign-off the patch as a human author
and send it to the upstream kernel mailing lists.
Reply with '#syz reject' to reject it ('#syz unreject' to undo).

See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
You can comment on the patch as usual, syzbot will try to address
the comments and send a new version of the patch if necessary.
syzbot engineers can be reached at syzkaller@googlegroups.com.
