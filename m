Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F6CE3C4172;
	Fri, 31 Jul 2026 10:14:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785492906; cv=none; b=bKVU1Edo0aRCk6x0jaYvUWXrrZvVt/j6BYPJ+vo0HhiY0hHAhmDfILDsCy+5nLqers+LnJvFAQ0eCmG23c/6PC84RzvsqqhCNGyJFrii0C2D0SV2PJtFX5cNbJPBSbF7vUPG5qYwqPgN0MBMxz3TpUk+EKhpVvwlgigj88Cf0mY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785492906; c=relaxed/simple;
	bh=hOVBjEhj881AduAfxRM4Kkaam08OAvoklM/AEWeXIGU=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=mcPofQ89iW+eG0Q+Slu73YliI1X8gbF0mayq4sDiwqo0pPpwMY2Pl67oQlaDxcLh+j7FNOs07ZZw2tsZkxr0/j0mxMbN+y63k1+ApqbZJexI1X5hAiauh/wKg9olYWcyv7gVgs2RM2ce/I4A40BNwP3MssH/5g+o3lMOuHBB7A4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZOdnbWRB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZOdnbWRB"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id A32E91F000E9;
	Fri, 31 Jul 2026 10:14:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785492891;
	bh=+kH9xojsM2T8bI2xbrx2KxKoYuIBEFYn1YpY4NiUPik=;
	h=From:To:Cc:Subject:Date;
	b=ZOdnbWRBBiYXh37AazNkz55xQ5rrmJA4j7sH800oh+MmowC0n/wO2Ku9rADhan4R1
	 fYoNnLicSXnMkI+40Rlcg9ejYPrUJPLOuZSls6ylW5srN8ipTFBz0KifwjAtFw737q
	 oXCv2MU275GXauob/oTqZ3JV2Z/60Z0E57ltHvGPjdbm9h3mWfB0a0qAI5mpHAhZLX
	 RQRY2qS7PoZe32ehEtZKXWTRUmiQSj6Q2jXlNV4kqxgh8+6Ox64p5WHo0kBLTan0zr
	 RGuxgJlLqkSF7xaDxtbRZod5/VDcBBybu5159bul950BgnuCLflR1SNVIhW7MY11L+
	 y3Dma6bl5Bihg==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-bugs@googlegroups.com, Aleksandr Nogikh <nogikh@google.com>, "Alex Markuze" <amarkuze@redhat.com>, <ceph-devel@vger.kernel.org>, "Ilya Dryomov" <idryomov@gmail.com>, "Viacheslav Dubeyko" <slava@dubeyko.com>
Cc: linux-kernel@vger.kernel.org, syzbot@lists.linux.dev
Subject: [PATCH] libceph: validate banner payload length
Message-ID: <88076cd2-1b1c-4988-905d-aa4745af3872@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Fri, 31 Jul 2026 10:14:50 +0000 (UTC)

From: Aleksandr Nogikh <nogikh@google.com>

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
Signed-off-by: Aleksandr Nogikh <nogikh@google.com>

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
See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
You can comment on the patch as usual, syzbot will try to address
the comments and send a new version of the patch if necessary.
syzbot engineers can be reached at syzkaller@googlegroups.com.
