Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5727376483
	for <syzbot@lists.linux.dev>; Thu, 30 Jul 2026 03:21:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=100.103.45.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785381681; cv=pass; b=Y9a6Losfxig2VfmjWHQOCbHRabGyJ/pyRE52GGYcoLEM3fkV2u9i2yzVFWMGEmDuQDZjcFCkSVi/F2pxDMW6k6bxrVjtNd/g5hddaLp/n0tWQkqbbQVpzEV/QjCNsiScwn9H00r8oVlGdsmc21LkdSHQDykGCWorp+47ongiaiQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785381681; c=relaxed/simple;
	bh=t2huo+mCGdLek46QfERmroLw4DKaWEsCEWpbUxuoh7E=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=QVAsDinCdpiGcJUnSsKTmLoNplp6hxZikAb/2fnEPMl/pjggukgIQLsckbcJNbk2pMzedBeYJJ6YZkaNJs5XUyuRd99zjBywZkfQan9fl5cGTie9gqnTpr6uFgC4P/jmX7zh0njvdLZjAp78OOEvPP3MAYO5owB/GS6vU6GGrvI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KJmU0wtA; arc=pass smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KJmU0wtA"
Received: by smtp.kernel.org (Postfix)
	id D29E51F000E9; Thu, 30 Jul 2026 03:21:19 +0000 (UTC)
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=209.85.214.176
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1785381679;
	b=nNwjds9m9gpCxEp+PQk1/MzRVIrOeIH2y599WyR9EmtobqJ/aqkvszgZux8ZHXUQGgF5
	 ryEaroXd8IIJ4i+saNk4+EPjj+hAPhU2zATsFaSVspttjugmwpG/nmcG16lJPZwpSXqbA
	 rmmhZx7IRWziTFIPukQRcQLdjeboB57lKzCxDCOUVYTwbHZDm3hC0NyDa49Q747TEyPwm
	 xnYeqegwlPMxiFYGzdwXPtZmFQLN03q0gllSS80hroaM1jcxoqM+3nZQaUJzK2Q5pM8gM
	 SBpI4zUI8Ow4btm1/3WfaoqKDeAR1uHJ0w/UEgDH3FEWcQUCwmrR8VhxpPKIzJl+Rbw==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1785381679;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=dRRJUQ6lF/VrBQ+d8mUK6cjq2Ts7AEbYsxt8dcHAa3Q=;
	b=iDIVNvdpe3JadrirloErHwQGwdsLjvGsZhqXrnGEO0TDrWgCqrfxI7OvjpKy0Z3wy7gF
	 CESxidqVAmkyvKc6PebZqrjyQbDyLgQMXNe66yrcRKFn+sOR4RxE4vZ98g4w7KOo30DYN
	 bIYKGQEccJPqmj9bS5T04z7KYjguclXbCsJjDZnckkHwpNqi7RbzKOBbWjGQB3Fgm9H0p
	 +QQDKLcCaXDhR47unMVBjFAfpysYMPwMkbYVZEywgUasAZBn37c3Z0DCcnmNH5Y1+Lvuj
	 wpbHXoluTIWDjhkFwvoIJEDa1+vBNyagOxrfC9x5xWCxaGGoN+tK+Gxjjaq6ocghfIg==
ARC-Authentication-Results: i=1; smtp.kernel.org; dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=KJmU0wtA;
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	arc=none smtp.remote-ip=209.85.214.176
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 9BF2B1F00A3A
	for <syzbot@kernel.org>; Thu, 30 Jul 2026 03:21:18 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=KJmU0wtA
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.kernel.org 9BF2B1F00A3A
Authentication-Results: smtp.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2cfff5f88dbso18966155ad.3
        for <syzbot@kernel.org>; Wed, 29 Jul 2026 20:21:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785381678; x=1785986478; darn=kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=dRRJUQ6lF/VrBQ+d8mUK6cjq2Ts7AEbYsxt8dcHAa3Q=;
        b=KJmU0wtAQLGjVeZj6jkFPxSo9s+E1zJycemFd06oXnRo7QQyca6bt5+07wp/K2D2Hs
         4rzneLv3sDZztotpJ/nGGKj7bUKCs2I5npQAMRX2tmRiNbZ7Q8OijZkTHlBMe+GnSOEl
         TjtJhrPn+sLA7ZnK1H/VR1+D4rBRcrEhPJ8qJlw0kFrKnqyCp7Z925HZjalcHSKYc5de
         qBiEL0w8py5eo2+op29/ZEYBgr6VPfZDtnJDkFTljeHPZI6RiKvjGXaoNyo4Vh9NhTVa
         4eBFww+OGGlXUAQum9ycPVeRySWdV4yv2gdTfmbR2rEjb1AmJYDmws7SAGMLch8iRMWX
         yDaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785381678; x=1785986478;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=dRRJUQ6lF/VrBQ+d8mUK6cjq2Ts7AEbYsxt8dcHAa3Q=;
        b=NnxAPN8bUUDGPEXdOdwY6Jc0hSxo8zFIgxAFrWMFooovXrynDtHx3SIu4tPZvs9XnJ
         vs8ntmfJ+zy8wy7cixbHUfe85PXzvUD9SEL7XZiNgmOAgCptRHdLj5BRzn7eYYcOu590
         tzj0b2YiFJdkf5Dr1jBszAd5YmAQE6aDUkEpjZTRBqR/rMBA9ZfZZi40Nfyflo4AIEEN
         bD0gIt2PE6guquR7qXWLhbphEbXr9UD3W9vN9OK4aCzF3sU+LQRNYsUeYB3PbdLbjd0/
         T02FtvguorJIEtpBF5CBoeXqDGtAQoH5HsnB4R8p3/wMaC1weI0va/xJC3/Xl0HpVyfX
         z47g==
X-Forwarded-Encrypted: i=1; AHgh+RquBX+2HLNtSRCK5etMLxIv0AW5qZuLkA/z0VyQ3yB8lw1ERkDR7unFHC/dXpcBrtowa8LSw2g=@kernel.org
X-Gm-Message-State: AOJu0Yy5WNxuWuaqEEW6DFSADy7Vq5z9ghirxWVVwheVVJge2bBsbhHD
	rWQKjU4r8OSHfTfCtT/DrKc+b/Ut6wpJGJgzXortVpTJ5Wzey/BLX2Mi
X-Gm-Gg: AR+sD10acXGE+g74Epv2UTcX6DpLsKIuIbghnPpSQZs4vUHNr2/AQU04mnbOn9wST9Y
	HpsE9VYZOtQrI/uHsSE34jJQS2nNaSkblU4AdFlgEN03OOVrxA5t+9p+SAbrCJx6F7c1wTSu0Iw
	P5P/xnznGYIY6poZGq5yGEkuvV3jrRXCFzsMjofO86feWBfE/TE7a4J/VHEuY/CWgxEmQnr5yvl
	2lAQdFXC/12YIjn16mWn71BNb4H1rnS/Y2RMIkGkiuiRUwDLeDT1aVQRg7jIpStqYJOn/dQMHTI
	GlNEEwwFHR4QwyQMGER76Wi6akQRQCkqvM5Q13osljGiO2PBsvZllZ7/M8s2YRntVb4cVXEkYFZ
	NuZAbHIwgaq8QiUC6N6ZcAXgIKDU1GKgwvePRmbFSRUoSpjzEQjOD4zZ2PFWZIqHc/yWKVyhjUS
	vH/Xsu9aq8XhvIi8x+hyKEuEqpBM/pqkn7zT2Tqi6GZh68iVnsMt19P+txzkhvMSDMxw==
X-Received: by 2002:a17:90b:1d8c:b0:38e:8300:af51 with SMTP id 98e67ed59e1d1-38f9bd62f1dmr780987a91.8.1785381677731;
        Wed, 29 Jul 2026 20:21:17 -0700 (PDT)
Received: from Default ([2409:40f4:1008:1710:a945:87ad:2d3e:163d])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-13e72643a12sm22869726c88.5.2026.07.29.20.21.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2026 20:21:16 -0700 (PDT)
From: Jeffin Philip <jeffinphilip14@gmail.com>
To: a.hindborg@kernel.org
Cc: leitao@debian.org,
	viro@zeniv.linux.org.uk,
	sage@newdream.net,
	linux-kernel@vger.kernel.org,
	syzbot <syzbot@kernel.org>,
	syzbot+8358d1f3d9c15bdf1c9a@syzkaller.appspotmail.com,
	Jeffin Philip <jeffinphilip14@gmail.com>
Subject: [PATCH] configfs: fix race between symlink and rmdir
Date: Thu, 30 Jul 2026 08:50:40 +0530
Message-ID: <20260730032040.95378-1-jeffinphilip14@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: syzbot <syzbot@kernel.org>

A race condition between configfs_rmdir() and configfs_symlink() can lead
to a use-after-free of a config_item.

When a directory is removed, configfs_rmdir() frees the associated
config_item but leaves the dentry hashed until vfs_rmdir() calls
d_delete(). This creates a window where a concurrent symlinkat() can find
the hashed dentry, see that !d_unhashed(dentry) is true, and attempt to
increment the refcount of the already freed config_item, triggering a
warning:

  refcount_t: addition on 0; use-after-free.
  WARNING: lib/refcount.c:25 at refcount_warn_saturate+0x9f/0x110
  ...
  Call Trace:
   __refcount_add include/linux/refcount.h:-1 [inline]
   __refcount_inc include/linux/refcount.h:366 [inline]
   refcount_inc include/linux/refcount.h:383 [inline]
   kref_get include/linux/kref.h:45 [inline]
   config_item_get+0x88/0x90 fs/configfs/item.c:104
   configfs_get_config_item fs/configfs/configfs_internal.h:127 [inline]
   get_target fs/configfs/symlink.c:128 [inline]
   configfs_symlink+0x4ab/0x1030 fs/configfs/symlink.c:185
   vfs_symlink+0x18b/0x330 fs/namei.c:5660
   filename_symlinkat+0x1cd/0x420 fs/namei.c:5685
   __do_sys_symlinkat fs/namei.c:5705 [inline]
   __se_sys_symlinkat+0x4e/0x2b0 fs/namei.c:5700

To fix this, add d_drop(dentry) in configfs_rmdir() immediately after
detaching the group/item and before unlinking the object. This ensures that
any concurrent kern_path() will either not find the dentry, or
configfs_get_config_item() will see d_unhashed(dentry) == true and safely
return NULL.

However, adding d_drop(dentry) exposes a secondary use-after-free bug in
create_link(). configfs_symlink() calls get_target(), which resolves the
path, gets the config_item, and then immediately drops the path reference.
If configfs_rmdir() runs concurrently, it drops its config_item reference,
and vfs_rmdir() calls d_delete_notify(). Since the dentry has only 1
reference left, dentry_unlink_inode() is called, freeing the
configfs_dirent. Later, create_link() accesses the freed configfs_dirent.

To fix this secondary issue, modify get_target() to return the path, and
hold the path reference in configfs_symlink() until after create_link()
finishes. By holding the path reference, the dentry's refcount remains >=
2, preventing d_delete() from calling dentry_unlink_inode(), which keeps
the configfs_dirent alive. The path is safely cleaned up using the
__free(path_put) attribute in configfs_symlink().

Fixes: 98702467f829 ("configfs: remove unnecessary dentry_unhash on rmdir, dir rename")
Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+8358d1f3d9c15bdf1c9a@syzkaller.appspotmail.com
Tested-by: Jeffin Philip <jeffinphilip14@gmail.com>
Reviewed-by: Jeffin Philip <jeffinphilip14@gmail.com>
Signed-off-by: Jeffin Philip <jeffinphilip14@gmail.com>
Closes: https://syzkaller.appspot.com/bug?extid=8358d1f3d9c15bdf1c9a
Link: https://syzkaller.appspot.com/ai_job?id=13fec684-23f7-4f06-99db-ed37ae92a405
Cc: Breno Leitao <leitao@debian.org>
---
 fs/configfs/dir.c     |  2 ++
 fs/configfs/symlink.c | 14 +++++++-------
 2 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/fs/configfs/dir.c b/fs/configfs/dir.c
index 3c88f13f1ca2..b0812432f6c5 100644
--- a/fs/configfs/dir.c
+++ b/fs/configfs/dir.c
@@ -1552,12 +1552,14 @@ static int configfs_rmdir(struct inode *dir, struct dentry *dentry)
 
 	if (sd->s_type & CONFIGFS_USET_DIR) {
 		configfs_detach_group(dentry);
+		d_drop(dentry);
 
 		mutex_lock(&subsys->su_mutex);
 		client_disconnect_notify(parent_item, item);
 		unlink_group(to_config_group(item));
 	} else {
 		configfs_detach_item(dentry);
+		d_drop(dentry);
 
 		mutex_lock(&subsys->su_mutex);
 		client_disconnect_notify(parent_item, item);
diff --git a/fs/configfs/symlink.c b/fs/configfs/symlink.c
index 31eb28b27309..c8a2d9ad6cac 100644
--- a/fs/configfs/symlink.c
+++ b/fs/configfs/symlink.c
@@ -114,18 +114,17 @@ static int create_link(struct config_item *parent_item,
 }
 
 
-static int get_target(const char *symname, struct config_item **target,
-		      struct super_block *sb)
+static int get_target(const char *symname, struct path *path,
+		      struct config_item **target, struct super_block *sb)
 {
-	struct path path __free(path_put) = {};
 	int ret;
 
-	ret = kern_path(symname, LOOKUP_FOLLOW|LOOKUP_DIRECTORY, &path);
+	ret = kern_path(symname, LOOKUP_FOLLOW | LOOKUP_DIRECTORY, path);
 	if (ret)
 		return ret;
-	if (path.dentry->d_sb != sb)
+	if (path->dentry->d_sb != sb)
 		return -EPERM;
-	*target = configfs_get_config_item(path.dentry);
+	*target = configfs_get_config_item(path->dentry);
 	if (!*target)
 		return -ENOENT;
 	return 0;
@@ -136,6 +135,7 @@ int configfs_symlink(struct mnt_idmap *idmap, struct inode *dir,
 		     struct dentry *dentry, const char *symname)
 {
 	int ret;
+	struct path path __free(path_put) = {};
 	struct configfs_dirent *sd;
 	struct config_item *parent_item;
 	struct config_item *target_item = NULL;
@@ -182,7 +182,7 @@ int configfs_symlink(struct mnt_idmap *idmap, struct inode *dir,
 	 *  AV, a thoroughly annoyed bastard.
 	 */
 	inode_unlock(dir);
-	ret = get_target(symname, &target_item, dentry->d_sb);
+	ret = get_target(symname, &path, &target_item, dentry->d_sb);
 	inode_lock(dir);
 	if (ret)
 		goto out_put;
-- 
2.55.0

