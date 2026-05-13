Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AF9A3B0AD0
	for <syzbot@lists.linux.dev>; Wed, 13 May 2026 19:34:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778700880; cv=none; b=H7rEBeUkR7UwQg1c79/yx0NZSV2mB1vVlRrGEFdmpzabyxGWLvZkRyhmtJjgCmGja4KlgnwTGVLWqVbBpGk+beddQYFsmBc6Y5lfu313IpCJjhlLZBT3P4+K2Yt1xRDaoHHXvD/fp4qr5ihRHH/EkfB59DHeafAMUlKfGKDQvCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778700880; c=relaxed/simple;
	bh=OTugY+A5oUiZ5f3cAYiMEoUZLGwwpDUzE19iD9ZTBr8=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=cqHXaGw/mQGvypvw/EOejKAnM9wO2bgG5st8Mz1Rr2IpU0/6ovdeH67o9PHYEQaMxkA/WZual87PDMtK0QMCZ1/kCTfHA7iUAUyH1Gq2XpEnvBFePPJoic3e41VtuAzsuukuqsFca/OlkkJtqzLzfu7S+qM/RKvn5qP+CitlgQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lYkmG+ty; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lYkmG+ty"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B85F9C19425;
	Wed, 13 May 2026 19:34:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778700879;
	bh=OTugY+A5oUiZ5f3cAYiMEoUZLGwwpDUzE19iD9ZTBr8=;
	h=From:To:Cc:Subject:Date:From;
	b=lYkmG+ty15d11BO8cRd7iHzoWt+RJnaW2DjwA3RtyS487XjRI++H4LDbQsHQBxQbj
	 pIvCaKb13MeZMyPb50W5JWhOI3RH1diLeRog+J3DpNpw4LlD5fvhFABCgpmetF18bn
	 LNWvPoDzPwJUCbpeBI+TcP4tzTQxT3nuQ3w0fYbvNQfXZd/B9VgkoLjsvxPAYOQHdE
	 rExWste7Gcgi6KURIU2E786ucf8NJcv27XzBkLx+LFecVjyFUHCwaJbY0AODoBk5F6
	 /Ev3WZ/E9uho5I78eXtZ6kdomFqOhmEuAsNmnqBHUmirdJ12QMHMmRlLlLSD0ZYURm
	 lC9HtHmLZLVvg==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] wifi: mac80211: remove broken reset debugfs interface
Message-ID: <4c7d0e03-ed9c-4c92-ab8c-7f9346ab3bb9@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Wed, 13 May 2026 19:34:39 +0000 (UTC)

The `reset` debugfs entry was originally introduced as a hack to test
the suspend/resume code paths without requiring a full system suspend.
However, since the generic suspend/resume procedures were cleaned up in
2013, the responsibility for tearing down interfaces and releasing
channel contexts before a suspend was delegated to the `cfg80211` layer.

The `reset_write()` function bypassed this `cfg80211` teardown phase,
directly calling `__ieee80211_suspend()`. As a result, if there were any
active interfaces, their channel contexts were never released, leading
to a `WARN_ON(!list_empty(&local->chanctx_list))` assertion failure in
`__ieee80211_suspend()`.

Because the `reset` debugfs entry can no longer accurately simulate a
real suspend/resume cycle and has been fundamentally broken for over a
decade when active interfaces are present, remove it entirely to prevent
the crash.

Fixes: 12e7f517029dad819c45eca9ca01fdb9ba57616b ("mac80211: cleanup generic suspend/resume procedures")
Assisted-by: Gemini:gemini-3.1-pro-preview
Reported-by: syzbot+56a1a45a9a2c04d425ff@syzkaller.appspotmail.com
Link: https://syzkaller.appspot.com/bug?extid=56a1a45a9a2c04d425ff
Link: https://syzkaller.appspot.com/ai_job?id=42504dac-87d9-412c-b393-0d219ade8e49
To: <johannes@sipsolutions.net>
To: <linux-wireless@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>

---
diff --git a/net/mac80211/debugfs.c b/net/mac80211/debugfs.c
index 5a1831b08..46630d997 100644
--- a/net/mac80211/debugfs.c
+++ b/net/mac80211/debugfs.c
@@ -400,33 +400,6 @@ static const struct debugfs_short_fops force_tx_status_ops = {
 	.llseek = default_llseek,
 };
 
-#ifdef CONFIG_PM
-static ssize_t reset_write(struct file *file, const char __user *user_buf,
-			   size_t count, loff_t *ppos)
-{
-	struct ieee80211_local *local = file->private_data;
-	int ret;
-
-	rtnl_lock();
-	wiphy_lock(local->hw.wiphy);
-	__ieee80211_suspend(&local->hw, NULL);
-	ret = __ieee80211_resume(&local->hw);
-	wiphy_unlock(local->hw.wiphy);
-
-	if (ret)
-		cfg80211_shutdown_all_interfaces(local->hw.wiphy);
-
-	rtnl_unlock();
-
-	return count;
-}
-
-static const struct debugfs_short_fops reset_ops = {
-	.write = reset_write,
-	.llseek = noop_llseek,
-};
-#endif
-
 static const char *hw_flag_names[] = {
 #define FLAG(F)	[IEEE80211_HW_##F] = #F
 	FLAG(HAS_RATE_CONTROL),
@@ -682,9 +655,6 @@ void debugfs_hw_add(struct ieee80211_local *local)
 	DEBUGFS_ADD(rate_ctrl_alg);
 	DEBUGFS_ADD(queues);
 	DEBUGFS_ADD(misc);
-#ifdef CONFIG_PM
-	DEBUGFS_ADD_MODE(reset, 0200);
-#endif
 	DEBUGFS_ADD_MODE(hwflags, 0600);
 	DEBUGFS_ADD(user_power);
 	DEBUGFS_ADD(power);


base-commit: 5d6919055dec134de3c40167a490f33c74c12581
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to send it to the mailing list.
Reply with '#syz reject' to reject it.

See  for more information.
