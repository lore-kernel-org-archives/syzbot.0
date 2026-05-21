Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF93C1E4AF
	for <syzbot@lists.linux.dev>; Thu, 21 May 2026 00:41:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779324077; cv=none; b=YrpFYbn1xh+e5T2skUGFB72yv5umCX+7vGsQU6U/t9Q2v+xepx/OWqDu8PDG1FhbVGNkG6LGhzQB0UoScx9rBSOOy7gbJ0LD6XSmcMp7Uoq1rX/qlruqQ77Xq/K/FfLajbWteXdEkkEcm1m3WPejFzrk+P6JBuFZ9CFZGTbbEMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779324077; c=relaxed/simple;
	bh=fUBqazL/OMDBihJ4ZZmQX/zfLCqtetJqyWLeZx1Qg90=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=Pr+KuoeJsRvdLaL+1GOL3IpSSzeoO90RQdmb3kr9XO8qBJ3O9FluNonzqHsFvX8oG48/qJgCEDKeLIpzGsimH5d9CPGZIVrHQvZoca1hhLsnpuY6Ba5vHFPRe06vF5t2b53KvyC06asag5DB6Wtm+vth1PCYEXF2p6PjLSaPbbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dzDsIa+g; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dzDsIa+g"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 190181F000E9;
	Thu, 21 May 2026 00:41:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779324074;
	bh=Uz/K+pMSfNTkE77PCJGUcg6QmY1RiR9JCEGxbKBeBv0=;
	h=From:To:Cc:Subject:Date;
	b=dzDsIa+g8s7SqLEJN827RlYhweBZEAFUL1zOTSyjvkX+t0/CXCDEm8SElAHgiq0br
	 Zr7neptaF3NilvvJH1iqyTFfXgK81vJIhXcxCKnfZYQRUaq3YR6NvKAF+Qi2Q3i32d
	 Oa74AATzRfGnGblaRqQSkWc6zuZB/wKFUK9rPbzfUkU5WxZzCicSvj02+jeXwRcgDu
	 WDDC8d/3vgBpK5VjIWYJXzIYbUs7FcqTkkF1S/gg14t3F9Qp+3xHenvR77CDrssnsI
	 zY5caTx3vDObUdM3cmekdR39vRSa5MuNlED9XEQo1yfaqAh2lMUH+46tQkuEvTgrdr
	 huLli7mIkaIoA==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] media: dvb-core: fix refcount double-put and use-after-free
Message-ID: <973d95aa-7d67-4c7d-8674-8cd1d1250a46@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Thu, 21 May 2026 00:41:14 +0000 (UTC)

A KASAN slab-use-after-free was detected in dvb_device_open() when
accessing dvbdev->fops. This happens because the dvb_device object is
prematurely freed due to a reference counting double-put in the error
path of dvb_frontend_open().

When dvb_device_open() is called, it acquires a reference to the
dvb_device object via dvb_device_get(). If the device-specific .open
handler (e.g., dvb_frontend_open()) returns an error, dvb_device_open()
correctly drops this reference by calling dvb_device_put(). However,
dvb_frontend_open() was calling dvb_generic_release() on its error path,
which also calls dvb_device_put(), resulting in a double-put. This
allows the refcount to drop to 0 prematurely, freeing the dvb_device
while it is still in the dvb_minors array, causing a use-after-free on
the next open.

Furthermore, a similar issue exists in several .release handlers across
the DVB core:
1. dvb_frontend_release(), dvb_ca_en50221_io_release(), and
dvb_net_close() were calling dvb_generic_release() (which drops the
kref) and then accessing dvbdev->users and dvbdev->wait_queue. If the
reference dropped by dvb_generic_release() was the last one, dvbdev
would be freed, leading to a use-after-free when accessing its members.
2. dvb_demux_release() and dvb_dvr_release() were decrementing
dvbdev->users but failing to call dvb_device_put() at all, leading to
memory leaks of the dvb_device object.

To fix these issues:
- In dvb_frontend_open(), replace the call to dvb_generic_release() in
the error path with manual undoing of dvb_generic_open() (incrementing
dvbdev->users and dvbdev->readers/dvbdev->writers) without calling
dvb_device_put().
- In dvb_frontend_release(), dvb_ca_en50221_io_release(), and
dvb_net_close(), replace the call to dvb_generic_release() with manual
counter increments, and move the dvb_device_put() call to the very end
of the function, after all accesses to dvbdev have completed.
- In dvb_demux_release() and dvb_dvr_release(), add the missing
dvb_device_put() calls at the end of the functions to fix the reference
leaks.

Fixes: 0fc044b2b5e2 ("media: dvbdev: adopts refcnt to avoid UAF")
Assisted-by: Gemini:gemini-3.1-pro-preview
Reported-by: syzbot+1eb177ecc3943b883f0a@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=1eb177ecc3943b883f0a
Link: https://syzkaller.appspot.com/ai_job?id=bda97d4d-bc81-4721-bd6f-812340864221
To: <linux-media@vger.kernel.org>
To: "Mauro Carvalho Chehab" <mchehab@kernel.org>
Cc: "Ariel Silver" <arielsilver77@gmail.com>
Cc: "Hans Verkuil" <hverkuil@kernel.org>
Cc: "Kees Cook" <kees@kernel.org>
Cc: <linux-kernel@vger.kernel.org>
Cc: "Xichao Zhao" <zhao.xichao@vivo.com>

---
diff --git a/drivers/media/dvb-core/dmxdev.c b/drivers/media/dvb-core/dmxdev.c
index 3c8bc75e4..a9a816997 100644
--- a/drivers/media/dvb-core/dmxdev.c
+++ b/drivers/media/dvb-core/dmxdev.c
@@ -239,6 +239,8 @@ static int dvb_dvr_release(struct inode *inode, struct file *file)
 	} else
 		mutex_unlock(&dmxdev->mutex);
 
+	dvb_device_put(dvbdev);
+
 	return 0;
 }
 
@@ -1256,6 +1258,8 @@ static int dvb_demux_release(struct inode *inode, struct file *file)
 	} else
 		mutex_unlock(&dmxdev->mutex);
 
+	dvb_device_put(dmxdev->dvbdev);
+
 	return ret;
 }
 
diff --git a/drivers/media/dvb-core/dvb_ca_en50221.c b/drivers/media/dvb-core/dvb_ca_en50221.c
index 1b91ebb8f..b2fc8e308 100644
--- a/drivers/media/dvb-core/dvb_ca_en50221.c
+++ b/drivers/media/dvb-core/dvb_ca_en50221.c
@@ -1783,7 +1783,11 @@ static int dvb_ca_en50221_io_release(struct inode *inode, struct file *file)
 	ca->open = 0;
 	dvb_ca_en50221_thread_update_delay(ca);
 
-	err = dvb_generic_release(inode, file);
+	if ((file->f_flags & O_ACCMODE) == O_RDONLY)
+		dvbdev->readers++;
+	else
+		dvbdev->writers++;
+	dvbdev->users++;
 
 	module_put(ca->pub->owner);
 
@@ -1796,7 +1800,9 @@ static int dvb_ca_en50221_io_release(struct inode *inode, struct file *file)
 		mutex_unlock(&ca->remove_mutex);
 	}
 
-	return err;
+	dvb_device_put(dvbdev);
+
+	return 0;
 }
 
 /**
diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
index d082b6c57..52a372665 100644
--- a/drivers/media/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb-core/dvb_frontend.c
@@ -2887,7 +2887,11 @@ static int dvb_frontend_open(struct inode *inode, struct file *file)
 	mutex_unlock(&fe->dvb->mdev_lock);
 err2:
 #endif
-	dvb_generic_release(inode, file);
+	if ((file->f_flags & O_ACCMODE) == O_RDONLY)
+		dvbdev->readers++;
+	else
+		dvbdev->writers++;
+	dvbdev->users++;
 err1:
 	if (dvbdev->users == -1 && fe->ops.ts_bus_ctrl)
 		fe->ops.ts_bus_ctrl(fe, 0);
@@ -2911,7 +2915,11 @@ static int dvb_frontend_release(struct inode *inode, struct file *file)
 		mb();
 	}
 
-	ret = dvb_generic_release(inode, file);
+	if ((file->f_flags & O_ACCMODE) == O_RDONLY)
+		dvbdev->readers++;
+	else
+		dvbdev->writers++;
+	dvbdev->users++;
 
 	if (dvbdev->users == -1) {
 		wake_up(&fepriv->wait_queue);
@@ -2932,8 +2940,9 @@ static int dvb_frontend_release(struct inode *inode, struct file *file)
 	}
 
 	dvb_frontend_put(fe);
+	dvb_device_put(dvbdev);
 
-	return ret;
+	return 0;
 }
 
 static const struct file_operations dvb_frontend_fops = {
diff --git a/drivers/media/dvb-core/dvb_net.c b/drivers/media/dvb-core/dvb_net.c
index a2159b2bc..0304b73bc 100644
--- a/drivers/media/dvb-core/dvb_net.c
+++ b/drivers/media/dvb-core/dvb_net.c
@@ -1595,7 +1595,11 @@ static int dvb_net_close(struct inode *inode, struct file *file)
 
 	mutex_lock(&dvbnet->remove_mutex);
 
-	dvb_generic_release(inode, file);
+	if ((file->f_flags & O_ACCMODE) == O_RDONLY)
+		dvbdev->readers++;
+	else
+		dvbdev->writers++;
+	dvbdev->users++;
 
 	if (dvbdev->users == 1 && dvbnet->exit == 1) {
 		mutex_unlock(&dvbnet->remove_mutex);
@@ -1604,6 +1608,8 @@ static int dvb_net_close(struct inode *inode, struct file *file)
 		mutex_unlock(&dvbnet->remove_mutex);
 	}
 
+	dvb_device_put(dvbdev);
+
 	return 0;
 }
 


base-commit: 5200f5f493f79f14bbdc349e402a40dfb32f23c8
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to send it to the mailing list.
Reply with '#syz reject' to reject it.

See https://github.com/google/syzkaller/blob/master/docs/syzbot_ai_patches.md for more information.
