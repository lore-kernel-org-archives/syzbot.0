Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com [209.85.167.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 153257083C
	for <syzbot@lists.linux.dev>; Mon, 28 Sep 2026 01:46:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790560012; cv=none; b=MUwPEflBvMCXQ1vQpf8x/Zi1Hbwenr2D8/EJPDG8gbK68dBIJoPgfDV5Htt6egjJRV3PLlKKDaW6dwRxDv36mg7BUcdjKxFswQog/wtfw7t2UbEuhhR9qXC283AkcSj3l5Bvy4/AetoYFvkKFxArI8ubhuoGNPtOauDUy6La+SI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790560012; c=relaxed/simple;
	bh=BGSjq3rD62G6UietoKvI6EZIb3xUlGPHYyIfMCgfESM=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=PSPskc9l+mfyNrmr50EgIg4PeDkDWMX7NtjjEYU8Upbdjr6vF6SDqaei8XPSKaSEigYjzcpY3k5yNXhKYtKqHOTpG2eIZ8Tcw9w9PuNU9exmGEjcTkM32so7wtvjcxZHcFqK6XdTIxeoW/Qim7mKxCFaH3vMu1U9iTrK1q2g6C0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f200.google.com with SMTP id 5614622812f47-4ab260600easo5236885b6e.1
        for <syzbot@lists.linux.dev>; Sun, 27 Sep 2026 18:46:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790560010; x=1791164810;
        h=content-type:cc:to:from:subject:message-id:in-reply-to:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=RH3u4TMhsdNFlANd5Tp5Xa0rdVtCLYtzYuD/aX9jlLU=;
        b=mk7EZdCxKAZmB9c0aVJOW0iRrYNCRff68aWDjq0ZHso4zXx/mJ+HSuTUlR1sQ8YLRo
         3OMssInqdEOlWhcPI1iBetjOjrhxxUvjHHRW3LhZhtwbBZH6S69GS2ahPS4Q/5O8n5Yx
         2PVE2Jvb6As2JYYjI+e63uokwattrNBVXCNumLl9+iIyRKmyepGylhKbV4SYZTal/wr6
         wuRqW6os5JkDCa8N94EocxFMq9rH7NlxEIhEXyBXXWM2Mf5XNabUkT7ab0Y2rMlJDEsL
         0+ex6La8EvxMFf4Gg9PRgy9DY7BXcfFPlfVeDKhtKsJ3f8hogDWnuVvQ5vbrexqFHOUU
         SFJQ==
X-Gm-Message-State: AFuF++lRp7i2Xz1rs5Yf9uzRE2Jun614fPysWq9s1FONSLNooFyJVDij
	bXvlJvxMastB7Xhohl0iSATCXQtxdHHuOG6zDS570lDNdxCIjJAnllaD5qP6Q8E0V8x/jtuRmWF
	nQi2FsF8lontlHPkIa7gwJEadeaMOGDiMAo30YDluhVHHxyN6knbuQCW4QEM=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:6f86:b0:4d6:9133:cfe9 with SMTP id
 5614622812f47-4d72d06594amr9809473b6e.46.1790560009952; Sun, 27 Sep 2026
 18:46:49 -0700 (PDT)
Date: Sun, 27 Sep 2026 18:46:49 -0700
In-Reply-To: <20260928014639.2230819-1-qwe.aldo@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6ab9c709.e548f532.1ca396.0042.GAE@google.com>
Subject: Forwarded: [PATCH] nfc: llcp: clear stale device pointers on socket close
From: syzbot <syzbot@syzkaller.appspotmail.com>
To: syzbot@lists.linux.dev
Cc: syzbot <syzbot+ci3c472c63e196fe9e@syzkaller.appspotmail.com>, qwe.aldo@gmail.com
Content-Type: text/plain; charset="UTF-8"

For archival purposes, forwarding an incoming command email to
syzbot@lists.linux.dev.

***

Subject: [PATCH] nfc: llcp: clear stale device pointers on socket close
Author: qwe.aldo@gmail.com

#syz test

nfc_llcp_socket_release() and nfc_llcp_recv_dm() can move a socket
to LLCP_CLOSED without clearing llcp_sock->dev.  A bound socket
never owned a device reference (bind puts its temporary ref), and
a connected socket reference is already released here.  A later
reconnect attempt would then put a device reference the socket does
not own.

Clear the pointer when a socket becomes closed so that the reconnect
cleanup only puts references it actually holds.

Signed-off-by: Aldo Ariel Panzardo <qwe.aldo@gmail.com>
---
 net/nfc/llcp_core.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/net/nfc/llcp_core.c b/net/nfc/llcp_core.c
index cac1b5487..f2530bebe 100644
--- a/net/nfc/llcp_core.c
+++ b/net/nfc/llcp_core.c
@@ -81,8 +81,14 @@ static void nfc_llcp_socket_release(struct nfc_llcp_local *local, bool device,
 
 		nfc_llcp_socket_purge(llcp_sock);
 
-		if (sk->sk_state == LLCP_CONNECTED)
+		if (sk->sk_state == LLCP_CONNECTED) {
 			nfc_put_device(llcp_sock->dev);
+			llcp_sock->dev = NULL;
+		} else if (sk->sk_state == LLCP_BOUND ||
+			   sk->sk_state == LLCP_LISTEN) {
+			/* bind() already dropped its temporary device reference. */
+			llcp_sock->dev = NULL;
+		}
 
 		if (sk->sk_state == LLCP_LISTEN) {
 			struct nfc_llcp_sock *lsk, *n;
@@ -1276,6 +1282,10 @@ static void nfc_llcp_recv_dm(struct nfc_llcp_local *local,
 
 	sk = &llcp_sock->sk;
 
+	/* Bound and listening sockets do not own a device reference. */
+	if (sk->sk_state == LLCP_BOUND || sk->sk_state == LLCP_LISTEN)
+		llcp_sock->dev = NULL;
+
 	sk->sk_err = ENXIO;
 	sk->sk_state = LLCP_CLOSED;
 	sk->sk_state_change(sk);
-- 
2.43.0

