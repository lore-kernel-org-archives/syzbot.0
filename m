Received: from mail-oo1-f71.google.com (mail-oo1-f71.google.com [209.85.161.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6201E314B6B
	for <syzbot@lists.linux.dev>; Thu, 26 Feb 2026 18:42:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772131342; cv=none; b=l85NAFiXc3htcdq73XM+Jd9mnKz4dlSLlcYnC16/e9QszDhpqlj3LEJYiD9LBfJbIFeEyq+t4V/MbE3IZOdcSN91IimX2C5A5RVFG0g5iR1alUoAMTcxxHEeCxPzdJYa1LwIe0MrnHKtQbT5P12qlQcwwc3LbQDx8k76czR5AUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772131342; c=relaxed/simple;
	bh=DjcBVY8mJqbGJnCRObWENCx0c6xRt7QNzm9li1dg71c=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=bBiDyHY34ZpxCOyziwha7BIBnzeh4DE/zQksohZBVKq6GkSUcaTvvVvnIgTnn4VY2/a7Svw+rckiapPtKTyAuzYeqBYBLJv3b9FE+qkxRB/vG8Apalu1zsf/Li63Wkn7azbk/alOXShDQNcMWA5pk5pPAnQ7kZqxqPIqiSXCTVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f71.google.com with SMTP id 006d021491bc7-676c2e00f3fso33523087eaf.0
        for <syzbot@lists.linux.dev>; Thu, 26 Feb 2026 10:42:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772131340; x=1772736140;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DjcBVY8mJqbGJnCRObWENCx0c6xRt7QNzm9li1dg71c=;
        b=XTNHdxlhNqEkT4ssyNHaViOLRjcRNM6RRbYa9QRsw+s3soiGSilNEhLo7FAxZ4CY3r
         2vKZlLu+21R4dbK/MLq6pRUUXVlu4wfqZUWBGlz/k6Gn9NyxT6Z7Rs1/uWlLPEav3uMN
         1NK3vpNFJMnEN2zcra6vY7/zYISE2Zw4grQX3i2UOKzBLYZ5/sSMW3s5/unQlxOjv2S+
         maaya9yMGG3BS5F63bjKoIQDOCcgStOMzZmHFjigm6UgFsaqHn5PoL+JKN2pjJop+Ov7
         7c/q1e+tnwhh43aVoTl006E6e+p7sRS6xcO/YIv8li8AnpDAJDLbJ/qyYdOPfQLHxmei
         1YIA==
X-Forwarded-Encrypted: i=1; AJvYcCU4KcGfresXSKkI97Lo7tF4upg2MKKbZHo9Tg7bpvXhDaW6pXR4+GmMrjCDWGhTRKwLDCl1SKo=@lists.linux.dev
X-Gm-Message-State: AOJu0YyX4MRB+4aw2bSeOOU9KJPpVNq+8lucyY77MwAZC3+X/jx1beow
	pp+Z88/StWOWCu242D240cpsiIHiZtHULRLxje/qsknYIqvDtp0mZj4oADldrOTKURhDZhuZgh9
	xkACxfLfeDDPvDzRqlnTAgyYx8nuheE71mJm1NIP670UuvWjwC/xgt6WE0Ug=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:2229:b0:679:c346:d8cd with SMTP id
 006d021491bc7-679f2331068mr2227907eaf.28.1772131340529; Thu, 26 Feb 2026
 10:42:20 -0800 (PST)
Date: Thu, 26 Feb 2026 10:42:20 -0800
In-Reply-To: <20260226183653.1812869-1-memxor@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69a0940c.050a0220.3a55be.0008.GAE@google.com>
Subject: Re: [PATCH] please work syzbot
From: syzbot ci <syzbot@syzkaller.appspotmail.com>
To: memxor@gmail.com
Cc: andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org, 
	daniel@iogearbox.net, eddyz87@gmail.com, kernel-team@meta.com, kkd@meta.com, 
	martin.lau@kernel.org, memxor@gmail.com, paulmck@kernel.org, 
	syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com, yatsenko@meta.com
Content-Type: text/plain; charset="UTF-8"


Unknown command

