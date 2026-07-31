Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B09163CC9F2
	for <syzbot@lists.linux.dev>; Fri, 31 Jul 2026 09:52:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785491558; cv=none; b=m+SHKcpWUoVoMqFcVqAUiPU2zRkYr/P7hVsivdMzUFBnHJQglQQI0wkpAriVZkSyQPoa9qOT3jhNs6B+x2koFeh7G04QHkceNhpiTgJGtAO2Iw1mPwBZSlp2XtXlKkhcSE+LyXhKYV8VWpphB4Ami9Yqj9G3tFEwvMbrq8Csd4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785491558; c=relaxed/simple;
	bh=VGKxfEbviSbja/eMNJzF+TPtjbms/kv7Cux6FzsrxB4=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=T35dZdH7HIK7DDEazDu3DUK60AYHWGX95lLsv0yxVpXP19Fiwl/g+4WEdidIC6doEFg2J6ZfpoPEyxiEnZXGYhIeT5E/W8cVZA0BpmE267kGsAhHsEMX5HRgFJS57nLewIuIayuIcXi8KGOU1d/kL7X+Ki/J4THQ1+Tr5fs6D4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cqkMqIpW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cqkMqIpW"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 6704E1F00A3A;
	Fri, 31 Jul 2026 09:52:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785491554;
	bh=4lkjisO35TlzepT078oVsqte7AcZhzAxjCR720frHOg=;
	h=From:To:Cc:Subject:Date;
	b=cqkMqIpWOQlO5P5aJidvuWTKH11sjW2HZIoHqWEmHM2gliwOasbppTs9CL1hLliYw
	 xk44o8DvSa9ZNfoy6Mj8NihcEMPUl0BFlFux0RcbMfpFTCxHTbxydqByvH3l1XVYLk
	 XNIHBISUHjliz+3XyHsVlYy52NPxD/eWAbej+HiGS6EKg7r6z/UUJuVindbVQLLVl/
	 mMd2ReSztX+0YPW5hAyN8mYqnFSGgBKjZewr2f+IG2eetkjo2VuLTig9yh4m8cHVGo
	 +hWdPPkuNS0e4+W6ySoFNzDGSpLDF8Yrq8CYDQ3cgPxIzrzPkRdIRIQK4Qa/qNK4y6
	 9w1AvaQv3NYnw==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] libceph: validate banner payload length
Message-ID: <10fa68ab-b588-4ca1-8ac1-dd13a95cff91@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Fri, 31 Jul 2026 09:52:34 +0000 (UTC)

When parsing the Ceph messenger v2 protocol banner, the `payload_len` field
is decoded from the banner prefix. If a client sends a banner with a
`payload_len` of 0, the kernel sets up a 0-length socket read. This
violates an invariant in the state machine, triggering a warning in
`populate_in_iter()`:

------------[ cut here ]------------
!iov_iter_count(&con->v2.in_iter)
WARNING: net/ceph/messenger_v2.c:3129 at populate_in_iter
net/ceph/messenger_v2.c:3129 [inline], CPU#1: kworker/1:3/5070
WARNING: net/ceph/messenger_v2.c:3129 at ceph_con_v2_try_read+0x6634/0x6810
net/ceph/messenger_v2.c:3159, CPU#1: kworker/1:3/5070
...
Call Trace:
 <TASK>
 ceph_con_workfn+0x1f5/0x14a0 net/ceph/messenger.c:1575
 process_one_work kernel/workqueue.c:3322 [inline]
 process_scheduled_works+0xa8e/0x14e0 kernel/workqueue.c:3405
 worker_thread+0xa47/0xfb0 kernel/workqueue.c:3486
 kthread+0x388/0x470 kernel/kthread.c:436
 ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>

According to the msgr2 protocol specification, the banner payload is
expected to contain at least two 64-bit integers (`server_feat` and
`server_req_feat`). Therefore, `payload_len` must be at least 16 bytes.

Fix this by adding a check in `process_banner_prefix()` to reject a
`payload_len` smaller than 16 bytes. This prevents the 0-length read and
correctly aborts the connection with a protocol error.

Fixes: cd1a677cad99 ("libceph, ceph: implement msgr2.1 protocol (crc and secure modes)")
Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+87c7c2d63c44e41c77a3@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=87c7c2d63c44e41c77a3
Link: https://syzkaller.appspot.com/ai_job?id=c8ca3d63-717a-4933-89ec-f3d761b8690d
To: "Alex Markuze" <amarkuze@redhat.com>
To: <ceph-devel@vger.kernel.org>
To: "Ilya Dryomov" <idryomov@gmail.com>
To: "Viacheslav Dubeyko" <slava@dubeyko.com>
Cc: <linux-kernel@vger.kernel.org>

---
diff --git a/net/ceph/messenger_v2.c b/net/ceph/messenger_v2.c
index 05f6eea29..b323b61e7 100644
--- a/net/ceph/messenger_v2.c
+++ b/net/ceph/messenger_v2.c
@@ -2142,6 +2142,11 @@ static int process_banner_prefix(struct ceph_connection *con)
 	payload_len = ceph_decode_16(&p);
 	dout("%s con %p payload_len %d\n", __func__, con, payload_len);
 
+	if (payload_len < sizeof(u64) + sizeof(u64)) {
+		con->error_msg = "protocol error, bad banner payload len";
+		return -EINVAL;
+	}
+
 	return prepare_read_banner_payload(con, payload_len);
 }
 


base-commit: f5098b6bae761e346ebcd9da7f95622c04733cff
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to Sign-off the patch as a human author
and send it to the upstream kernel mailing lists.
Reply with '#syz reject' to reject it ('#syz unreject' to undo).

See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
You can comment on the patch as usual, syzbot will try to address
the comments and send a new version of the patch if necessary.
syzbot engineers can be reached at syzkaller@googlegroups.com.
