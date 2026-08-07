Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A534441F36F
	for <syzbot@lists.linux.dev>; Fri,  7 Aug 2026 11:35:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786102559; cv=none; b=SyLeka0WqbNFNRwtrl4GIPZTvbOViy9GSsHmHSJvc+w9y3O7h9t2IE3wCtJnS51Q/SykRfUVWRebVGUGewBsLqQJI3Zver6QvrBKaxeilVC99SdySXscVNUvgWp4632+VR3C4nXL5eNvR+k4+ApnsskP5uIUOoyWeRbkwXhl3lE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786102559; c=relaxed/simple;
	bh=eQs7+U8Y+vBjdYII607JqtkDKbgPDSUq93UhEdM1oo4=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=XFTTfsL8e56+rtM4PXRTMomEX5gnHZohsTbg398w+QtvXd1jPz63EXZQ6oVrVpxIyDeFH+A+5076KJI2gE8I6Y8ch0bBFq7tZfnzUohG+eP+gFeI7RLKDr2pIr53y/ax5hBYS3pzx6O/M3sRAx73eJ8TbOjEKG0ka+CPnEJmNEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jjQHB3V2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jjQHB3V2"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 96B841F000E9;
	Fri,  7 Aug 2026 11:35:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786102556;
	bh=K7uJEEow9ftkOZGm7TxIg4RWt7nJDUDvcl0yljCKLOA=;
	h=From:To:Cc:Subject:Date;
	b=jjQHB3V2lvWVhhrFowVtz5VrAP8WOLuJISTSCm6hqOf42nBP7AlKRe9Z9Ge5Hc8Zp
	 oXNKaEj4fe1S8/SHAhHfdmuq7oAutzHXaMqKP86EnQ6jP2NRyjkkgj9QoNtTcQLjNi
	 sd51l0lWlBuxH2hA5lh/VH6zKawNmzrsKShI6Lbw7tpEdjWg4o1Mn1nRttQXhGjEcU
	 vaVKhSSiGYGDhKJIdlnVKG7y8cBdJKW9WRNdZhYOX4ODVnPX+WY6EAoz3eRjO7w42/
	 izq0BV3NCEBvcF2aKhvvQz9DHnio9iRG6K9u62HqIqIxIFoOXCB76wIWRnt5KMVjqw
	 kDeeo7sKBBqxA==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: immersa.bartosz.chronowski@gmail.com, syzbot@lists.linux.dev
Subject: [PATCH RFC v2] smb: client: fix double decrement of server->in_flight
Message-ID: <8eee63bf-fe76-434c-9a55-3886e41bb755@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Fri,  7 Aug 2026 11:35:56 +0000 (UTC)

During a failed send or reconnect, the reconnect thread can process a
still-queued multiplex ID (MID) before the sender returns the same
reservation. This double completion corrupts request accounting, wraps the
unsigned server->in_flight counter to UINT_MAX, and can affect system
availability by blocking further requests.

Specifically, when smb_send_rqst() fails (e.g., with -ECONNRESET), it
signals the cifsd thread for a reconnect. If compound_send_recv() drops the
cifs_server_lock(server) before removing the MIDs from the pending queue,
the cifsd thread can wake up, acquire the lock, and execute
cifs_abort_connection().

cifs_abort_connection() iterates over server->pending_mid_q, finds the MIDs
that failed to send, and executes their callbacks (cifs_compound_callback).
Because no response was received, the callback calls add_credits() with 0
credits. smb2_add_credits() unconditionally decrements server->in_flight,
even if the number of credits being added is 0.

After the callback finishes, compound_send_recv() continues its execution,
sees that rc < 0, and explicitly calls add_credits() to return the credits
it originally reserved. This results in a second call to
smb2_add_credits(), which decrements server->in_flight again. Since
in_flight was already decremented to 0 by the callback, this second
decrement triggers a warning and wraps the unsigned counter to UINT_MAX.

CIFS: VFS: \\127.0.0.1 Error -32 sending data on socket to server
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

To fix this, ensure that the cifsd thread cannot observe these MIDs if the
request failed to send (rc < 0) or if no response is expected (flags &
CIFS_NO_SRV_RSP). By calling delete_mid() before dropping
cifs_server_lock(server), we safely remove the MIDs from the pending queue
while still holding the mutex. This guarantees that cifs_abort_connection()
will not find them and will not execute their callbacks. We also set
cancelled_mid[i] = true so that the common cleanup code safely skips the
already-deleted MIDs, preventing any double-free issues.

Fixes: ee258d79159a ("CIFS: Move credit processing to mid callbacks for SMB3")
Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+eeb58d2197d88720a228@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=eeb58d2197d88720a228
Link: https://syzkaller.appspot.com/ai_job?id=41f83e92-1b53-4701-b089-30a34a1b8cc8
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
v2:
- Updated the commit description to lead with the failed-send/reconnect trigger and its impact on request accounting and system availability.
- Corrected the description to state that the unsigned server->in_flight counter wraps to UINT_MAX instead of becoming -1.

v1:
https://lore.kernel.org/all/05aeff9e-78c8-4060-8efb-7debe418f6dd@mail.kernel.org/T/
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
The person who has signed off on the patch is responsible for
addressing comments.
syzbot engineers can be reached at syzkaller@googlegroups.com.
