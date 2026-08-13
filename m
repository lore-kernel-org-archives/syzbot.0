Received: from canpmsgout08.his.huawei.com (canpmsgout08.his.huawei.com [113.46.200.223])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C76C184
	for <syzbot@lists.linux.dev>; Thu, 13 Aug 2026 02:39:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.223
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786588756; cv=none; b=fZ6YDToY5ZZY4bnBQrRDKoEfWU9AwKhVwPUnUUc0EFEfzfoIQy23TdJyoOunGEU1fu2ew1U+a6KsQ+yFjKy5q20PGsn2G1LAmGXQP32Nn3ct94ust0OXLW/6dhkdXuhXGaDVkp3ZmSRVy9Gcvbfh9v16dGdZUBQGVkyiDkCEHy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786588756; c=relaxed/simple;
	bh=TzC0oSr9ZAATzqlPVDX5tJdB9ZCc7zDocZz8B0fH0ec=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SJ4uZO9krRp8RUT/c2gmvCoUrvOMAtCogDEjz7q/uz1NfxYfD5OVLe5uL/9CDZ/1WXSAMQocWIDCuUDFESC1KBoWeFJNjL1w5J71sk5KCjF6RsMXz+/8jqk8x0lMx0UeneowiVaBkPeK6a3c6J7Vdg22UrSdbXs8xvyFUq+F5dY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=K+BaWxOl; arc=none smtp.client-ip=113.46.200.223
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="K+BaWxOl"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=TzC0oSr9ZAATzqlPVDX5tJdB9ZCc7zDocZz8B0fH0ec=;
	b=K+BaWxOl5ZMxbt7ouBxEZbK7rUZs5RW9/9hoi76tM6SYBE3yk0p0QNN9PBQ5+FTgWNX3J9LJb
	9JEfavgZZ2/uhfZPqvkYjlIP0KS6mw3ZrTKikJv25i2TuGQGf3lCE8jIYdc4OuKKNrFG+xkM2eB
	k5zzZrNMJuSltlYbERolRtY=
Received: from mail.maildlp.com (unknown [172.19.163.200])
	by canpmsgout08.his.huawei.com (SkyGuard) with ESMTPS id 4hL8RY4YXPzmV7C;
	Thu, 13 Aug 2026 10:28:25 +0800 (CST)
Received: from dggpemr500006.china.huawei.com (unknown [7.185.36.185])
	by mail.maildlp.com (Postfix) with ESMTPS id 2081D4055B;
	Thu, 13 Aug 2026 10:39:03 +0800 (CST)
Received: from localhost.localdomain (10.50.85.180) by
 dggpemr500006.china.huawei.com (7.185.36.185) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Thu, 13 Aug 2026 10:39:02 +0800
From: Yao Kai <yaokai34@huawei.com>
To: <syzbot@kernel.org>
CC: <syzbot@lists.linux.dev>,
	<syzkaller-upstream-moderation@googlegroups.com>, <liuyongqiang13@huawei.com>
Subject: Re: [PATCH RFC] futex: Fix might_sleep() warning in futex_pivot_pending()
Date: Thu, 13 Aug 2026 10:58:56 +0800
Message-ID: <20260813025856.3666670-1-yaokai34@huawei.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <1f966921-7789-4c70-92cd-ae6c4f8d5be4@mail.kernel.org>
References: <1f966921-7789-4c70-92cd-ae6c4f8d5be4@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 dggpemr500006.china.huawei.com (7.185.36.185)

The MP ordering itself looks sound. However, hash_new is now
intentionally accessed locklessly. Please use WRITE_ONCE() for all
post-publication stores to hash_new so that the access annotations are
consistent and the code remains clean under strict KCSAN.

Thanks,
Yao Kai
