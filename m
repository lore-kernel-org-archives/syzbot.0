Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC30F40DB56
	for <syzbot@lists.linux.dev>; Thu, 13 Aug 2026 13:59:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786629551; cv=none; b=cU8DPrNBLYYjPbmRcMW4m7tTj9dJfQzJGkeeBSuKig4KMjtQv6xf+tY57tcWtmnzB1TGGzjaM3PHf1PafzNH6NxgDi/YdNUGvlZjgb8m+KwW5pwNzOQEtgbnTJx2kzpJtif2kG+mU10sioJoizYdThISyl2EJ82PrE474t6EIrc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786629551; c=relaxed/simple;
	bh=ECUUUuH2RzBPokA3BPAoSPrG7QbIJG7VIutd5uH99b4=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=f2XtZ72Eeb4cTjKXKM13TJKFgsO4svmxDRVe97rikvNkYXOAOkB40C2jAHJmqiSt6aFvcqyNLfzbWr+wauXWAdKtoa/lOa7plH0JwEIUK0aD8yFMmkVlbEQlDT0ISpSO6eTjLniPhwQr7VJQW2URmMMyylcGTBy5gRJkSuy4yTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JOdzGavT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JOdzGavT"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 2B7571F000E9;
	Thu, 13 Aug 2026 13:59:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786629549;
	bh=dSvJcJJIGGjZruSMMXvndcFuFgVcBxthV7KVjAIjIUI=;
	h=From:To:Cc:Subject:Date;
	b=JOdzGavTmmCUH2V6b8CDDYRxQPiYIk2VrblaDcRMLrWDuZZsEZqsddUn6NmTTY+Fx
	 1tnLqGP18qN6EdgOGElFyy+jFadKUE7mCQNy1qs4aPB89KIlw8nPwbPliwRGJCGvGg
	 NbGdv+7kxNyz79HzSke9OuNb4O9LeVz9s4biCGmuhEkZc3nrlA/m6wDKj8Azy+fcoF
	 MmuamO8j66kj9sNP+h8/5RMt114qzvBsj0SBgQ9HQ5vVIlNiv8sD2UGmMycVcGo4I5
	 cenR2FP2bUswQgmJgT8xfKy2Hrso4vtKjIRpHtcJtmO8/XuV4tLAuQ/GGTb+4zGNDz
	 BXZeeXdV/wpYQ==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: krystianmkaniewski@gmail.com, syzbot@lists.linux.dev
Subject: [PATCH RFC v3] Bluetooth: hci_sync: Fix tx_work queuing race during device close
Message-ID: <5d8471b1-69f3-4f3d-809c-7c0d396aa6f1@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Thu, 13 Aug 2026 13:59:09 +0000 (UTC)

During the shutdown process of a Bluetooth device in hci_dev_close_sync(),
tx_work can still be queued by concurrent transmission paths or raw HCI
socket operations after HCI_UP has been checked or while workqueues are
being flushed. This causes __queue_work() to trigger a warning when
attempting to queue work on a draining workqueue:

WARNING: kernel/workqueue.c:2306 at __queue_work+0xd4a/0x1090
Call Trace:
 <TASK>
 queue_work_on+0x106/0x1c0 kernel/workqueue.c:2452
 l2cap_chan_send+0x168a/0x22f0 net/bluetooth/l2cap_core.c:-1
 l2cap_sock_sendmsg+0x33a/0x4d0 net/bluetooth/l2cap_sock.c:1180
 ____sys_sendmsg+0x54e/0x850 net/socket.c:2684
 ___sys_sendmsg+0x2a5/0x360 net/socket.c:2738
 __sys_sendmmsg+0x273/0x4d0 net/socket.c:2827
 </TASK>

To fix this, flush pending TX work before disabling later scheduling with
disable_work_sync() and re-enable it with enable_work() in
hci_dev_close_sync() to establish a work exclusion interval for
hdev->tx_work while the device is closing. Additionally, ensure raw HCI
socket producers in hci_sock_sendmsg() are quiesced by holding
rcu_read_lock() while checking HCI_UP, paired with synchronize_rcu() in
hci_dev_close_sync() right after disabling tx_work.

Fixes: 76727c02c1e1 ("Bluetooth: Call drain_workqueue() before resetting state")
Assisted-by: Gemini:gemini-3.6-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+b6919040d9958e2fc1ae@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=b6919040d9958e2fc1ae
Link: https://syzkaller.appspot.com/ai_job?id=13d65dad-50b4-4275-9c89-8f2b9ce91f77
To: <linux-bluetooth@vger.kernel.org>
To: "Luiz Augusto von Dentz" <luiz.dentz@gmail.com>
To: "Marcel Holtmann" <marcel@holtmann.org>
To: "Johan Hedberg" <johan.hedberg@intel.com>
Cc: <linux-kernel@vger.kernel.org>

---
v3:
- Flush pending TX work with flush_work() before disabling work scheduling with disable_work_sync().
- Update commit description to note that pending TX work is flushed before scheduling is disabled.

v2:
- Replaced per-send HCI_UP checks in hci_core.c with disable_work_sync() and enable_work() on hdev->tx_work in hci_dev_close_sync() to establish a work exclusion interval during shutdown.
- Added rcu_read_lock() protection around the HCI_UP check in hci_sock_sendmsg() and synchronize_rcu() in hci_dev_close_sync() to quiesce raw HCI producers.
https://lore.kernel.org/all/2df2fce5-9a9d-4baa-8b00-c1ccaf72d400@mail.kernel.org/T/

v1:
https://lore.kernel.org/all/2c2febf2-fc12-4407-9c81-d3d9713f09a4@mail.kernel.org/T/
---
diff --git a/net/bluetooth/hci_sock.c b/net/bluetooth/hci_sock.c
index 070ca388f..8345ebbbd 100644
--- a/net/bluetooth/hci_sock.c
+++ b/net/bluetooth/hci_sock.c
@@ -1850,9 +1850,10 @@ static int hci_sock_sendmsg(struct socket *sock, struct msghdr *msg,
 		goto drop;
 	}
 
+	rcu_read_lock();
 	if (!test_bit(HCI_UP, &hdev->flags)) {
 		err = -ENETDOWN;
-		goto drop;
+		goto drop_rcu;
 	}
 
 	hci_skb_pkt_type(skb) = skb->data[0];
@@ -1870,7 +1871,7 @@ static int hci_sock_sendmsg(struct socket *sock, struct msghdr *msg,
 		    hci_skb_pkt_type(skb) != HCI_ISODATA_PKT &&
 		    hci_skb_pkt_type(skb) != HCI_DRV_PKT) {
 			err = -EINVAL;
-			goto drop;
+			goto drop_rcu;
 		}
 
 		skb_queue_tail(&hdev->raw_q, skb);
@@ -1885,7 +1886,7 @@ static int hci_sock_sendmsg(struct socket *sock, struct msghdr *msg,
 				   &hci_sec_filter.ocf_mask[ogf])) &&
 		    !capable(CAP_NET_RAW)) {
 			err = -EPERM;
-			goto drop;
+			goto drop_rcu;
 		}
 
 		/* Since the opcode has already been extracted here, store
@@ -1908,14 +1909,14 @@ static int hci_sock_sendmsg(struct socket *sock, struct msghdr *msg,
 	} else {
 		if (!capable(CAP_NET_RAW)) {
 			err = -EPERM;
-			goto drop;
+			goto drop_rcu;
 		}
 
 		if (hci_skb_pkt_type(skb) != HCI_ACLDATA_PKT &&
 		    hci_skb_pkt_type(skb) != HCI_SCODATA_PKT &&
 		    hci_skb_pkt_type(skb) != HCI_ISODATA_PKT) {
 			err = -EINVAL;
-			goto drop;
+			goto drop_rcu;
 		}
 
 		skb_queue_tail(&hdev->raw_q, skb);
@@ -1923,14 +1924,16 @@ static int hci_sock_sendmsg(struct socket *sock, struct msghdr *msg,
 	}
 
 	err = len;
+	rcu_read_unlock();
+	goto done;
 
+drop_rcu:
+	rcu_read_unlock();
+drop:
+	kfree_skb(skb);
 done:
 	release_sock(sk);
 	return err;
-
-drop:
-	kfree_skb(skb);
-	goto done;
 }
 
 static int hci_sock_setsockopt_old(struct socket *sock, int level, int optname,
diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index c8d14128c..8cb01e074 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -5471,10 +5471,15 @@ int hci_dev_close_sync(struct hci_dev *hdev)
 
 	hci_leds_update_powered(hdev, false);
 
-	/* Flush RX and TX works */
+	/* Flush RX and TX works. Pending TX work is flushed before
+	 * later scheduling is disabled.
+	 */
 	flush_work(&hdev->tx_work);
+	disable_work_sync(&hdev->tx_work);
 	flush_work(&hdev->rx_work);
 
+	synchronize_rcu();
+
 	if (hdev->discov_timeout > 0) {
 		hdev->discov_timeout = 0;
 		hci_dev_clear_flag(hdev, HCI_DISCOVERABLE);
@@ -5576,6 +5581,8 @@ int hci_dev_close_sync(struct hci_dev *hdev)
 	bacpy(&hdev->random_addr, BDADDR_ANY);
 	hci_codec_list_clear(&hdev->local_codecs);
 
+	enable_work(&hdev->tx_work);
+
 	hci_dev_put(hdev);
 	return err;
 }


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
