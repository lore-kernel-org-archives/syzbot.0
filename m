Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30D5248A2CE
	for <syzbot@lists.linux.dev>; Tue, 25 Aug 2026 15:33:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787671991; cv=none; b=M0pSGrlgIPEER12ZIRIXD26xLu7pT39EYHghTV4B/8vfJEs7N/LEg51BAkjyBcU5TLJRh2nslajUToFu1Rps3znCCKmVEksor4PrUcy66tZDYkPL4Ew68ajI9xStyY2tSyaBrImsIuPtFRSSG/YKRa+k9CPUlxffUPMIhn90EgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787671991; c=relaxed/simple;
	bh=8PwHXIKEVDcUzCgOHNVV7wqIiUC48n4bfxIrX6fCbsk=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=U+LqaDBL7ixkq8WUROzgaeD04tp/dEpnqHvOfjI83nSgzhD+9XJH2kr+jHez6qUf6Fzb5JrFh3V8srcRvqrTOiuctsp325fwqZI65ogSYVlEu1YM6WHwqRrkRXbWZ2ezmz8pwPs3QwYtFyL2Gwy+dAtG5oEJAvimA8a2C72x8Wk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SH8nUEIm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SH8nUEIm"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 57C6B1F00AC4;
	Tue, 25 Aug 2026 15:33:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787671987;
	bh=ka3yelK3994hjAcPVQ9/BzdcniwV0h9B8GWcNCX2TVI=;
	h=From:To:Cc:Subject:Date;
	b=SH8nUEIm71YwRlr8q1d3s8VM8LvtqVnAsyvkrt0W3q73DIzX7T2hSrY3jDzjPqCTp
	 1UwRJsm7bnbD6U/L46eBrn/K60xZM57dJiRVGG96Er4OUyhuFkYFeSbV3wRlow6jB4
	 jp0FklAoSN4YjpiJKiShHj3CxZKAZ/lpH82TyNpIdTG2KC1gjoiFGSGbEEDuif4iAI
	 QVD067PXV/dvBAXXW7LpJiv0yFQBX4e0zta2C5AfaRQkYQKgDYupSCp76z0u5lzj9C
	 ASV0GuhqdpPOJSQqlAP4mhr354AuMp3SaEqCJjXDax9FKutfEcH11H3c/1YL+VWVy3
	 C5e1k2vaTjLyA==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] apparmor: fix error handling in aa_alloc_profile
Message-ID: <205c8a70-057b-492d-a249-3c429c990dea@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Tue, 25 Aug 2026 15:33:07 +0000 (UTC)

When aa_alloc_profile() fails to initialize a profile, it jumps to a single
error label that calls aa_free_profile(). This monolithic cleanup function
calls aa_policy_destroy() on the profile's base policy. However, if the
failure occurs early in aa_policy_init() (e.g., during aa_str_alloc()), the
policy's list heads are not yet initialized. Because the profile is
allocated with kzalloc_flex(), the uninitialized list heads are zeroed,
causing list_empty() to evaluate to false. This triggers an AA_BUG()
assertion in aa_policy_destroy():

  ------------[ cut here ]------------
  AppArmor WARN aa_policy_destroy: (((!list_empty(&policy->profiles) &&
  (&policy->profiles)->prev != ((void *) 0x122 +
  (0xdead000000000000UL))))):
  WARNING: security/apparmor/lib.c:509 at aa_policy_destroy+0x164/0x1b0
  security/apparmor/lib.c:509
  ...
  Call Trace:
   <TASK>
   aa_free_profile+0x9d/0x9f0 security/apparmor/policy.c:334
   aa_alloc_profile+0x1e4/0x3e0 security/apparmor/policy.c:416
   unpack_profile security/apparmor/policy_unpack.c:1153 [inline]
   aa_unpack+0x17db/0x7430 security/apparmor/policy_unpack.c:1748
   aa_replace_profiles+0x226/0x2a20 security/apparmor/policy.c:1183
   policy_update+0x234/0x4a0 security/apparmor/apparmorfs.c:505
   profile_load+0x1cb/0x320 security/apparmor/apparmorfs.c:522
   vfs_write+0x296/0xba0 fs/read_write.c:685

To fix this, modify aa_alloc_profile() to use a strict reverse LIFO goto
ladder for error handling. This ensures that cleanup functions are only
called for fully initialized components, preventing aa_policy_destroy()
from being executed on a partially initialized policy.

Fixes: 637f688dc3dc ("apparmor: switch from profiles to using labels on contexts")
Assisted-by: Gemini:gemini-3.7-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+faed97c4ed43bfe7fee5@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=faed97c4ed43bfe7fee5
Link: https://syzkaller.appspot.com/ai_job?id=8594cc18-d31f-4dc1-9d81-89d765382445
To: <apparmor@lists.ubuntu.com>
To: "Georgia Garcia" <georgia.garcia@canonical.com>
To: "James Morris" <jmorris@namei.org>
To: "John Johansen" <john.johansen@canonical.com>
To: <linux-security-module@vger.kernel.org>
To: "Paul Moore" <paul@paul-moore.com>
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: <linux-kernel@vger.kernel.org>

---
diff --git a/security/apparmor/policy.c b/security/apparmor/policy.c
index 94b4a7e72..7ec43a491 100644
--- a/security/apparmor/policy.c
+++ b/security/apparmor/policy.c
@@ -385,21 +385,21 @@ struct aa_profile *aa_alloc_profile(const char *hname, struct aa_proxy *proxy,
 		return NULL;
 
 	if (!aa_policy_init(&profile->base, NULL, hname, gfp))
-		goto fail;
+		goto fail_profile;
 	if (!aa_label_init(&profile->label, 1, gfp))
-		goto fail;
+		goto fail_policy;
 
 	/* allocate the first ruleset, but leave it empty */
 	profile->label.rules[0] = aa_alloc_ruleset(gfp);
 	if (!profile->label.rules[0])
-		goto fail;
+		goto fail_label;
 	profile->n_rules = 1;
 
 	/* update being set needed by fs interface */
 	if (!proxy) {
 		proxy = aa_alloc_proxy(&profile->label, gfp);
 		if (!proxy)
-			goto fail;
+			goto fail_rules;
 	} else
 		aa_get_proxy(proxy);
 	profile->label.proxy = proxy;
@@ -412,8 +412,14 @@ struct aa_profile *aa_alloc_profile(const char *hname, struct aa_proxy *proxy,
 	/* refcount released by caller */
 	return profile;
 
-fail:
-	aa_free_profile(profile);
+fail_rules:
+	free_ruleset(profile->label.rules[0]);
+fail_label:
+	aa_label_destroy(&profile->label);
+fail_policy:
+	aa_policy_destroy(&profile->base);
+fail_profile:
+	kfree_sensitive(profile);
 
 	return NULL;
 }


base-commit: 8d3ae59288f1e7d58d76558a6ee96d533bc5019f
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to Sign-off the patch as a human author
and send it to the upstream kernel mailing lists.
Reply with '#syz reject' to reject it ('#syz unreject' to undo).

See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
You can comment on the patch as usual, syzbot will try to address
the comments and send a new version of the patch if necessary.
syzbot engineers can be reached at syzkaller@googlegroups.com.
