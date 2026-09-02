Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE2CB3F9F22
	for <syzbot@lists.linux.dev>; Wed,  2 Sep 2026 21:59:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788386353; cv=none; b=asHivShHd7CMk8Tcf1O8FMwZ3tuybB3/HD3U08fACD1MVM52uFWbAjxh3MnVeHU9awNyR5+au41lXV5sa0pshcYf8+C4tOcKxT0dwo0uY45b6WjJb7aaTu0dqi6P7Io8KT3/AT/t7CAI+Zz0/OyHme/Gpk2bpSyJSKBEPa40K2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788386353; c=relaxed/simple;
	bh=DTdoDC6CibLwxjV2C/+1DlIvp4jlBOjQP58QdhQ6itE=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=b3cV7/aG6phPrmmzfRVRkjdF/zoEP5q+Ig/LOcuqCjHTz6Lyox3BtAM5QLX/b91/A3MLiDNpeAy6IRTO28IwCE+fcLo7byknHUrtQ2mRzyc7C+5OrN6kitQNDIJV/xBvaJiCdwwAtSMNZWpEFFp0phE6XTC0opThu+myvWAm9ho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OArkYjBK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OArkYjBK"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 6C7371F00AC4;
	Wed,  2 Sep 2026 21:59:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788386342;
	bh=OtF2jJIM65mhauzFojjw8dOCjwYo2DX5bC6AKHKj/RE=;
	h=From:To:Cc:Subject:Date;
	b=OArkYjBK6lPbLYvWmItBZIRUeDyVWqEP4tt1WzDrjDVcDf+tPKc/YiPDUjxe+aOz2
	 OfpKhDbsBzExn8VtBI7a0bzHksBHSA7nZ2IK6D2jW1oPz4w8Hc+zQxSk/Rdf0f9gsB
	 5fh06wntbS5InWXNjzPb2cdbPJ4sDCnPEElt2PmOfQfwDe7EM64hYY2H4T5oYpC48Q
	 X0Uh2SoJ5Ct8BA51rEgzuvJduNRKeNk2n4Y1LOOZKeCGEqb0ZiUPS6C2dG/aKlPVYZ
	 3veg6PHZ0a0wQ1BQzt0DP/3Es+dONEpGycmCENTw4G22rvoqhlsMYv6z1OG0EfOPJA
	 7by6ofAgX0DAA==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] sunrpc: reject socket already in use in svc_addsock()
Message-ID: <1613a189-598e-44de-8e58-e4b40633eda2@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Wed,  2 Sep 2026 21:59:02 +0000 (UTC)

When a socket is added to an RPC service via svc_addsock() (for example, by
writing its file descriptor to /proc/fs/nfsd/portlist), svc_setup_socket()
saves the original socket callbacks (such as sk_state_change) into struct
svc_sock and replaces them with RPC-specific callbacks (such as
svc_tcp_state_change). It also attaches the new svc_sock to
sk->sk_user_data.

If the same socket file descriptor is added to an RPC service again,
svc_addsock() invokes svc_setup_socket() a second time on the same socket.
During the second setup, svsk->sk_ostate is assigned the socket's current
sk_state_change callback, which was already replaced with
svc_tcp_state_change. When a state change event subsequently occurs on the
socket (for example, when connect() is called), svc_tcp_state_change()
invokes svsk->sk_ostate, calling itself in an infinite recursion until the
kernel stack overflows and triggers a stack guard page fault:

BUG: TASK stack guard page was hit at ffffc900030b7ff8 (stack is
ffffc900030b8000..ffffc900030c0000)
Oops: stack guard page: 0000 [#1] SMP KASAN NOPTI
...
Call Trace:
 <TASK>
 svc_tcp_state_change+0x76/0x2e0 net/sunrpc/svcsock.c:917
 svc_tcp_state_change+0x76/0x2e0 net/sunrpc/svcsock.c:917
 svc_tcp_state_change+0x76/0x2e0 net/sunrpc/svcsock.c:917
 ...
 tcp_done_with_error net/ipv4/tcp_input.c:4877 [inline]
 tcp_reset+0x176/0x380 net/ipv4/tcp_input.c:4909
 tcp_rcv_synsent_state_process net/ipv4/tcp_input.c:6903 [inline]
 tcp_rcv_state_process+0x13bc/0x48a0 net/ipv4/tcp_input.c:7197
 tcp_v4_do_rcv+0xafc/0x1530 net/ipv4/tcp_ipv4.c:1876
 sk_backlog_rcv include/net/sock.h:1192 [inline]
 __release_sock+0x25b/0x390 net/core/sock.c:3260
 release_sock+0x190/0x260 net/core/sock.c:3859
 inet_wait_for_connect net/ipv4/af_inet.c:616 [inline]
 __inet_stream_connect+0x863/0xe00 net/ipv4/af_inet.c:710
 inet_stream_connect+0x66/0xa0 net/ipv4/af_inet.c:755
 connect_socket net/socket.c:2141 [inline]
 __sys_connect_file net/socket.c:2166 [inline]
 __sys_connect+0x316/0x450 net/socket.c:2183
 ...
 </TASK>

Fix this by checking if so->sk->sk_user_data is already set in
svc_addsock() before proceeding with svc_setup_socket(). If it is already
non-NULL, return -EBUSY to prevent re-initializing an active socket.

Fixes: fa9251afc33c ("SUNRPC: Call the default socket callbacks instead of open coding")
Assisted-by: Gemini:gemini-3.7-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+c9834a0c0215e6d8697a@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=c9834a0c0215e6d8697a
Link: https://syzkaller.appspot.com/ai_job?id=30de91d1-1d14-4676-8c38-a3564f7acf48
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
To: "Trond Myklebust" <trond.myklebust@primarydata.com>
Cc: "Dai Ngo" <Dai.Ngo@oracle.com>
Cc: "Simon Horman" <horms@kernel.org>
Cc: <linux-kernel@vger.kernel.org>
Cc: "NeilBrown" <neil@brown.name>
Cc: "Olga Kornievskaia" <okorniev@redhat.com>
Cc: "Tom Talpey" <tom@talpey.com>

---
diff --git a/net/sunrpc/svcsock.c b/net/sunrpc/svcsock.c
index 50e5e7f5b..e8cc4329f 100644
--- a/net/sunrpc/svcsock.c
+++ b/net/sunrpc/svcsock.c
@@ -1541,6 +1541,9 @@ int svc_addsock(struct svc_serv *serv, struct net *net, const int fd,
 	err = -EISCONN;
 	if (so->state > SS_UNCONNECTED)
 		goto out;
+	err = -EBUSY;
+	if (so->sk->sk_user_data)
+		goto out;
 	err = -ENOENT;
 	if (!try_module_get(THIS_MODULE))
 		goto out;


base-commit: cee9395acd8043be0644b25c34bfa86623f2b935
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to Sign-off the patch as a human author
and send it to the upstream kernel mailing lists.
Reply with '#syz reject' to reject it ('#syz unreject' to undo).

See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
You can comment on the patch as usual, syzbot will try to address
the comments and send a new version of the patch if necessary.
syzbot engineers can be reached at syzkaller@googlegroups.com.
