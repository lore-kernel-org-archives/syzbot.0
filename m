Received: from mail-oo1-f69.google.com (mail-oo1-f69.google.com [209.85.161.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 056BB1E1A33
	for <syzbot@lists.linux.dev>; Tue,  3 Mar 2026 01:07:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772500073; cv=none; b=hutZzqiRl490tiVUQFEUxw9Lcm+IQ8twoel2Hcgl8FNFYOmoG9LkqGsQNn1+qxgWJUQW2hOUMuKYWHiL7gwzI7ySh0xO8Un5hIjTVt02NlLrNcESBSjaqvkRWtLlmw/nuo5+izwxO5Zey1aRhFSnT1HE5Oenay2c8lwhjsC0lx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772500073; c=relaxed/simple;
	bh=DjcBVY8mJqbGJnCRObWENCx0c6xRt7QNzm9li1dg71c=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=UPohFwt1Kyez/OUc6q9yIjBdGdqMRHxt5uWXsR8vibEROIgppWR5y1nU5PP1trHEbngP2DJ8+YYjppDJeY4q1Z0BzgZbuxCPMusG16IezwYvys5rpqLsq/jYC3gEJdWZjjwtkRRntaT87583Ctvi3I45KYTaVunv5mdtzOsplgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f69.google.com with SMTP id 006d021491bc7-679c51b2d6cso77214615eaf.2
        for <syzbot@lists.linux.dev>; Mon, 02 Mar 2026 17:07:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772500071; x=1773104871;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DjcBVY8mJqbGJnCRObWENCx0c6xRt7QNzm9li1dg71c=;
        b=opvAjSN9G97ouDzkyfsouYHbbVLICoLHTgoLk2dsOHNHkOKgXShOG6pFKB37vptZXv
         26o0G8B6BYc9XlLt6U+IDs4Kxges2W/aROZMvR2iGMHVgcR+kaLYHiycf7kINi7t04F5
         uvC6L3eaeDTR2+Gv0JzRbwk3mvTpiGz9zC5inyldQ8hZ4Z0bxavPx+DRiG5z9ZOcUVkm
         FhXP8zXsRywZRgCEjqWnBl9KIyjJCHaJJH0tuFKzEXSuedMvxVLrVIbGI70R3zU3tOEW
         dnhgqj7XkalQ37ffdZ/Q6JzxG/Z6cIqShpnw0h2OrKXUJO/1egAk3ZELL9CvYEHbuLUu
         7uaw==
X-Forwarded-Encrypted: i=1; AJvYcCXv7wLkz/BmEcDdSn4T+uYvJEvd+onwz1xjqAfis8rQjEgMLO8d4bVxw0LQOnVJuEmXEd8Qxh8=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw22fjvOkwYOQeGKEK0b6REEhCt2hGo6Mn++4+LktXVAIO0CpAi
	tosjRd1izC1OigFXdLerCNIk9nV3Xz2yR+4mvfnXmTp9KtqH2K/lSEmfUIjPCh06yweDbt2Rgum
	HfWQDo3OC+cYVe6XmPOLuziHwlrsyQx/hCZ4AHr87/YgpRA8P6LrhvwDmyiI=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:220f:b0:66e:88e3:5c46 with SMTP id
 006d021491bc7-679fadc3271mr8509413eaf.10.1772500071051; Mon, 02 Mar 2026
 17:07:51 -0800 (PST)
Date: Mon, 02 Mar 2026 17:07:51 -0800
In-Reply-To: <85f9e0cb6cc44a36b0ce624b6766ddc6@BJMBX01.spreadtrum.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69a63467.a70a0220.135158.0005.GAE@google.com>
Subject: Re: reply: [syzbot ci] Re: mm: bail out when the PMD has been set in
 bloom filter
From: syzbot ci <syzbot@syzkaller.appspotmail.com>
To: zhaoyang.huang@unisoc.com
Cc: akpm@linux-foundation.org, huangzhaoyang@gmail.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, steve.kang@unisoc.com, 
	syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com, yuzhao@google.com, 
	zhaoyang.huang@unisoc.com
Content-Type: text/plain; charset="UTF-8"


Unknown command

