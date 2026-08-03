Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 987E733B6C2
	for <syzbot@lists.linux.dev>; Mon,  3 Aug 2026 09:32:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785749568; cv=none; b=ZMqly+vc2y3tGCSzZNxVvz89COpcaIQ7KzwJCQQ3M01KoQSbV7SscrFrmLchBujOn6LXMAnuFaU64fHjsCDslx4WVG/tJWwk1TZcZOvSJhd9cIbLifSVbtUqjvwPX1eOp7vW7jM1UCN2zanCkorB5dsqapuwg74Yf1as5T5pJR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785749568; c=relaxed/simple;
	bh=vf5nb6U62PG8hRPzbGui+SSrDSLS+jBTYr7csTXgq0w=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=R3pN9SO7YFnC3wFzqSZ6rujH4oN5inUGkEp/LYKP+wZCURLb300SPShrnQvuFeN+90RRRLueUo2ylvLXF90xdTx6Dr8LXQ3aA1NQMfLdVJ+UiV9PuwxlaJSW/kEap5ul1KZ2HdWbPdduPSZGeyFhn/iRAWZPMn2DP5MPWXRLsRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZwKh29lW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZwKh29lW"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 6A8E31F00A3A;
	Mon,  3 Aug 2026 09:32:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785749560;
	bh=fLW9uN5EAC0VbnDkpTpxfFTeW5NxcLQ9nYwhDJGlHr8=;
	h=From:To:Cc:Subject:Date;
	b=ZwKh29lWmHRxpJB/+alYDL5XWrV0wulDVDimSJXM47RQvH5xl7uev+grBuTNx8Zyp
	 /vDiK8mYbi0oHFG8ei9WE+tSDroyu7ECZdy3W4PyeS02uobeYYrQuG4dcVmCpZpFlc
	 F0CiqeBrjcbCS7K3KwJclVPVFI8ICafH8+fgLYsocyXT9tdxlrtwUcYNgZ5P1vuWV0
	 vo9Hhcj0BPK0XTqbpQdBK7rYH4RCXdtL8lFddJLbjR3OfYx3QdfkujSDjmMjqJOvS1
	 UdCxIF92MFdM+pFTfMoirVhYM8SXibblOGxA382WOU+nwdXEQphML+BXk+Vtpr0JiW
	 pO/aGDMSn9tXg==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] smb: client: fix double decrement of server->in_flight
Message-ID: <05aeff9e-78c8-4060-8efb-7debe418f6dd@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Mon,  3 Aug 2026 09:32:40 +0000 (UTC)

There is a race condition between the error handling path in
compound_send_recv() and the cifsd reconnect thread that can lead to a
double decrement of server->in_flight.

When smb_send_rqst() fails (e.g., with -ECONNRESET), it signals the cifsd
thread for a reconnect. If compound_send_recv() drops the
cifs_server_lock(server) before removing the multiplex IDs (mids) from the
pending queue, the cifsd thread can wake up, acquire the lock, and execute
cifs_abort_connection().

cifs_abort_connection() iterates over server->pending_mid_q, finds the mids
that failed to send, and executes their callbacks (cifs_compound_callback).
Because no response was received, the callback calls add_credits() with 0
credits. smb2_add_credits() unconditionally decrements server->in_flight,
even if the number of credits being added is 0.

After the callback finishes, compound_send_recv() continues its execution,
sees that rc < 0, and explicitly calls add_credits() to return the credits
it originally reserved. This results in a second call to
smb2_add_credits(), which decrements server->in_flight again. Since
in_flight was already decremented to 0 by the callback, this second
decrement triggers a warning and corrupts the counter to -1.

CIFS: VFS: \\127.0.0.1 Error -104 sending data on socket to server
------------[ cut here ]------------
server->in_flight == 0
WARNING: fs/smb/client/smb2ops.c:104 at smb2_add_credits+0x1249/0x2b70
fs/smb/client/smb2ops.c:104
Call Trace:
 <TASK>
 add_credits fs/smb/client/cifsglob.h:894 [inline]
 compound_send_recv+0x13b4/0x2b90 fs/smb/client/transport.c:979
 cifs_send_recv+0x42/0x60 fs/smb/client/transport.c:1106
 SMB2_negotiate+0x164d/0x4030 fs/smb/client/smb2pdu.c:1188
 cifs_negotiate_protocol+0x45d/0x680 fs/smb/client/connect.c:4043
 cifs_get_smb_ses+0x1104/0x1ff0 fs/smb/client/connect.c:2492
 cifs_mount_get_session+0xf1/0x450 fs/smb/client/connect.c:3578
 get_session fs/smb/client/dfs.c:65 [inline]
 dfs_mount_share+0x22e/0x990 fs/smb/client/dfs.c:275
 cifs_mount+0xcc/0xbf0 fs/smb/client/connect.c:3860
 cifs_smb3_do_mount+0x2d0/0x8a0 fs/smb/client/cifsfs.c:1024
 smb3_get_tree_common fs/smb/client/fs_context.c:897 [inline]
 smb3_get_tree+0x2dd/0x400 fs/smb/client/fs_context.c:917
 vfs_get_tree+0x92/0x2a0 fs/super.c:1700
 fc_mount fs/namespace.c:1198 [inline]
 do_new_mount_fc fs/namespace.c:3765 [inline]
 do_new_mount+0x319/0xdc0 fs/namespace.c:3841
 do_mount fs/namespace.c:4174 [inline]
 __do_sys_mount fs/namespace.c:4390 [inline]
 __se_sys_mount+0x31d/0x420 fs/namespace.c:4367
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
 </TASK>

To fix this, ensure that the cifsd thread cannot observe these mids if the
request failed to send (rc < 0) or if no response is expected (flags &
CIFS_NO_SRV_RSP). By calling delete_mid() before dropping
cifs_server_lock(server), we safely remove the mids from the pending queue
while still holding the mutex. This guarantees that cifs_abort_connection()
will not find them and will not execute their callbacks. We also set
cancelled_mid[i] = true so that the common cleanup code safely skips the
already-deleted mids, preventing any double-free issues.

Fixes: ee258d79159a ("CIFS: Move credit processing to mid callbacks for SMB3")
Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+eeb58d2197d88720a228@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=eeb58d2197d88720a228
Link: https://syzkaller.appspot.com/ai_job?id=53130d26-0860-4523-bf44-fbc757857958
To: <linux-cifs@vger.kernel.org>
To: <samba-technical@lists.samba.org>
To: "Steve French" <sfrench@samba.org>
To: "Pavel Shilovsky" <pshilov@microsoft.com>
Cc: "Bharath SM" <bharathsm@microsoft.com>
Cc: <linux-kernel@vger.kernel.org>
Cc: "Paulo Alcantara" <pc@manguebit.org>
Cc: "Ronnie Sahlberg" <ronniesahlberg@gmail.com>
Cc: "Shyam Prasad N" <sprasad@microsoft.com>
Cc: "Tom Talpey" <tom@talpey.com>

---
diff --git a/fs/smb/client/transport.c b/fs/smb/client/transport.c
index fdf4e50c2..8d14225e9 100644
--- a/fs/smb/client/transport.c
+++ b/fs/smb/client/transport.c
@@ -968,6 +968,13 @@ compound_send_recv(const unsigned int xid, struct cifs_ses *ses,
 		server->sequence_number -= 2;
 	}
 
+	if (rc < 0 || (flags & CIFS_NO_SRV_RSP)) {
+		for (i = 0; i < num_rqst; i++) {
+			delete_mid(server, mid[i]);
+			cancelled_mid[i] = true;
+		}
+	}
+
 	cifs_server_unlock(server);
 
 	/*


base-commit: 075b74841bd0065a3bda3440873c747938e69b68
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to Sign-off the patch as a human author
and send it to the upstream kernel mailing lists.
Reply with '#syz reject' to reject it ('#syz unreject' to undo).

See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
You can comment on the patch as usual, syzbot will try to address
the comments and send a new version of the patch if necessary.
syzbot engineers can be reached at syzkaller@googlegroups.com.
