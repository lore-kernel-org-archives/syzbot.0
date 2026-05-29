Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C31644D02B
	for <syzbot@lists.linux.dev>; Fri, 29 May 2026 20:06:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780085210; cv=none; b=NwanTJRDqWO7MzsBJXYBR7Om9Zd15+vlZ1/CEXgwsqJy4/g6TEwUZEDgDMHIqqEj7KiO0KmU8ggjqZUrPc75tyZ96iDClKgz3nD6NIJ+rllwCsYuvQlkRC3xI/Gi1u1Vkes4fzToSl5PybBtbU7+vH5I88LvrNoP6/azhHzgPHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780085210; c=relaxed/simple;
	bh=cWzhAldWygSon5RimXvXEFPj5ifKUkPElkCA3Oh1KCc=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=mv+00jL6WACStayRRbyi1NhVsAVR5Eu4WYxcj0A7hMXQUlWNL757ZMOoA0StLGrXCxqLmYu7F4hv44VPKFZ0vp+Stw4JGEqPR8BjSOvVSSyi3jQh2/bFKQqY8iCGDFu1rcCNQslaJQqmVhkXy7pttyMjWtTbLlfqHYTHui7E6RA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fkJY+76a; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fkJY+76a"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id BD5731F00893;
	Fri, 29 May 2026 20:06:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780085208;
	bh=f74nV8pYW4RGEuno+bfusoaG2ouyngjScgoMKN9weaY=;
	h=From:To:Cc:Subject:Date;
	b=fkJY+76aD2vxsYXUqKL1hqCJMicobV1nMfeALemqV24qLSzbR5cpIjqlcecuOfq6d
	 aE9a8vMA4AtAnXvhrLMX5bALNhbG+8OEWCf7fB0xpr4aV+cHIL5d1gRXaobQ2SPaEn
	 RAV7Iu5FOA6FE6+JwerGcwLEpQptUw3qIeBPqwG7pMqleP2EqijM9my+736D+YDvc9
	 IQ2MjtTK/tIuqsdtnNbNpc0sGpiRWoehW51sqPQ1/I3i2sCNioML26KYw1YNYs440G
	 bhBsDM93JMfl/UnCIhEZ8WQnPWtho5npOGZ8uS7lPfUihsmYDrY+QhVCcD3+EMmUUB
	 0TUmmiedhi6pQ==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] kobject_uevent: explicitly initialize creds in alloc_uevent_skb()
Message-ID: <4c7a0e29-a57a-4e82-818f-3fdf0b348768@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Fri, 29 May 2026 20:06:48 +0000 (UTC)

A KMSAN uninit-value warning in put_cmsg() is triggered when a userspace
process receives a uevent with SO_PASSCRED enabled. The uninitialized data
originates from the ucreds local variable in __scm_recv_common(), which is
populated using scm->creds.pid. The scm cookie is initialized in
netlink_recvmsg() by copying the credentials from the socket buffer's
control block.

In alloc_uevent_skb(), the skb control block is populated, but only the uid
and gid fields of the creds structure are explicitly set, omitting the pid
field. Although __alloc_skb() internally zeroes the skb->cb array, KMSAN's
shadow memory tracking does not consistently unpoison this memory when skbs
are recycled from the NAPI cache. Consequently, the uninitialized state
persists through the netlink transmission and triggers a KMSAN warning when
put_cmsg() attempts to copy the pid to userspace.

To fix this, explicitly zero the entire creds structure in
alloc_uevent_skb() before setting the individual fields. This ensures that
the pid field is properly tracked by KMSAN as initialized memory.

Fixes: 26045a7b14bc ("uevent: add alloc_uevent_skb() helper")
Assisted-by: Gemini:gemini-3.1-pro-preview Gemini:gemini-3-flash-preview syzbot
Reported-by: syzbot+08b819a87faa6def6dfb@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=08b819a87faa6def6dfb
Link: https://syzkaller.appspot.com/ai_job?id=4575cb01-d27e-485e-a646-6fb71c8694da
To: "Andrew Morton" <akpm@linux-foundation.org>
To: "Danilo Krummrich" <dakr@kernel.org>
To: <driver-core@lists.linux.dev>
To: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
To: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: <linux-kernel@vger.kernel.org>

---
diff --git a/lib/kobject_uevent.c b/lib/kobject_uevent.c
index ddbc4d748..9552aaa87 100644
--- a/lib/kobject_uevent.c
+++ b/lib/kobject_uevent.c
@@ -297,6 +297,7 @@ static struct sk_buff *alloc_uevent_skb(struct kobj_uevent_env *env,
 	skb_put_data(skb, env->buf, env->buflen);
 
 	parms = &NETLINK_CB(skb);
+	memset(&parms->creds, 0, sizeof(parms->creds));
 	parms->creds.uid = GLOBAL_ROOT_UID;
 	parms->creds.gid = GLOBAL_ROOT_GID;
 	parms->dst_group = 1;


base-commit: e7ae89a0c97ce2b68b0983cd01eda67cf373517d
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to Sign-off the patch as a human author
and send it to the upstream kernel mailing lists.
Reply with '#syz reject' to reject it ('#syz unreject' to undo).

See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
You can comment on the patch as usual, syzbot will try to address
the comments and send a new version of the patch if necessary.
syzbot engineers can be reached at syzkaller@googlegroups.com.
