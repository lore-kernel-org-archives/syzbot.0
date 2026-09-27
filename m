Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com [209.85.167.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 332593BED38
	for <syzbot@lists.linux.dev>; Sun, 27 Sep 2026 23:23:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790551440; cv=none; b=LGwQQZLJUl3TJUf70rryG316MwJxFxD+fHRPi+F4qdNLn7VK+QYgAmws+6EYeFUgmfCzTVpAl022wtb2ihhc58qEHNbAFZX43bayyyQLC6UNbn18FP0cUf4VgMRaVe+8wj9uNh+Y8G1LKh45XxPuphlq1Uxz/uc7gDz8GJXzodU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790551440; c=relaxed/simple;
	bh=bRyFcsVjDYOiPQLlH3oX5aeZ8Ia1BLK8qaCWKtCBBnA=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=CLLRWPwCs4TroYUU5Lplj9ANqt1Nk5eiExnEkAvLLyxJCIluDBjMHeqGGXQ9gJxnsCb0lSaIwIEeT6XbWrbLqWD8hqUFFD7igz3igXiSAVi0d0Py9ERN+jjHxrRO9O9g/Ol1NH67Ct07VX9c4/sjVR1GbWssydGfpRYAl3TeVQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f198.google.com with SMTP id 5614622812f47-4b28d7ffab1so4373523b6e.1
        for <syzbot@lists.linux.dev>; Sun, 27 Sep 2026 16:23:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790551438; x=1791156238;
        h=content-type:cc:to:from:subject:message-id:in-reply-to:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=xyZDKoTGeP1svw19j8H2HBS2WMauDaO9iXzwJKLa9kg=;
        b=mYPia5EY5hdwja6S7ID4u6+TDhpl1Il5UAW9OvbDIuMKJnb/tpwK66MI7TmLl6jIRm
         UK+Dli/8ZOXM7kvPcwfsch3NI2PjeY2DvOkcTvtqDC9V3lM2/s4E3xU6pnguLtSDF/1G
         zyR6+KaY9BTq7AT34Hn70QSR+ENsOoJietAdJ7lnW4sGqBVfJWmToNwRhLVFt4ze8JR4
         rKOI/hlo8HXxyGilpLYgip6btrl1PALM04XNIxaZZBZYH5FvOtMVtSuqV2XnzE32LnSs
         VX5PyyJ4MgISW+I7t5m74pVGNOm38sU3lgW5Jig+MPbYYlWQQNgQDdnCc4OUoQiAB+KN
         OCHg==
X-Gm-Message-State: AFuF++mMUKa0EZ1Jua3A2+mVCxdhsSaEctPsAHfpCV1Mz8QKFZofkklK
	cs3eUhL2HZQRMYg1hG/tyH5IDkoaENhq/A9OszkAwScSrTchsM3Bhl45eMUyOhs90OIlgstao1F
	qjyBujGFtNfS/P8Bj3JLb/f5tznZnRRv6awJN17XBqJGWcX8VBt9iAw7a0Hg=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:16aa:b0:4c9:f7ca:82b1 with SMTP id
 5614622812f47-4d72cd3640amr8798887b6e.33.1790551438083; Sun, 27 Sep 2026
 16:23:58 -0700 (PDT)
Date: Sun, 27 Sep 2026 16:23:58 -0700
In-Reply-To: <20260927232347.2160670-1-qwe.aldo@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6ab9a58e.80e1c6cc.1e8e5f.0067.GAE@google.com>
Subject: Forwarded: nfc: llcp: clear stale device pointers on socket close
From: syzbot <syzbot@syzkaller.appspotmail.com>
To: syzbot@lists.linux.dev
Cc: syzbot <syzbot+ci3c472c63e196fe9e@syzkaller.appspotmail.com>, qwe.aldo@gmail.com
Content-Type: text/plain; charset="UTF-8"

For archival purposes, forwarding an incoming command email to
syzbot@lists.linux.dev.

***

Subject: nfc: llcp: clear stale device pointers on socket close
Author: qwe.aldo@gmail.com

#syz test

nfc_llcp_socket_release() and nfc_llcp_recv_dm() can move a socket
to LLCP_CLOSED without clearing llcp_sock->dev.  A bound socket
never owned a device reference (bind puts its temporary ref), and
a connected socket's reference is already released here.  A later
reconnect attempt would then put a device reference the socket does
not own.

Clear the pointer when a socket becomes closed so that the reconnect
cleanup only puts references it actually holds.

Signed-off-by: Aldo Ariel Panzardo <qwe.aldo@gmail.com>
---
 net/nfc/llcp_core.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/net/nfc/llcp_core.c b/net/nfc/llcp_core.c
index 74bf81700..174e92ea5 100644
--- a/net/nfc/llcp_core.c
+++ b/net/nfc/llcp_core.c
@@ -95,8 +95,14 @@ static void nfc_llcp_socket_release(struct nfc_llcp_local *local, bool device,

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
@@ -1329,6 +1335,10 @@ static void nfc_llcp_recv_dm(struct nfc_llcp_local *local,
 	if (connecting)
 		nfc_llcp_sock_unlink(&local->connecting_sockets, sk);

+	/* Bound and listening sockets do not own a device reference. */
+	if (sk->sk_state == LLCP_BOUND || sk->sk_state == LLCP_LISTEN)
+		llcp_sock->dev = NULL;
+
 	sk->sk_err = ENXIO;
 	sk->sk_state = LLCP_CLOSED;
 	sk->sk_state_change(sk);
--
2.43.0
