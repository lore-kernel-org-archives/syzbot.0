Received: from mail-io1-f71.google.com (mail-io1-f71.google.com [209.85.166.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEFCC2741B5
	for <syzbot@lists.linux.dev>; Wed, 29 Oct 2025 00:25:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761697511; cv=none; b=JhfnPbnT8ToocmfcUCWo4F6lCndB0KH/ZaKlGxG5YEMpJCN31mS1XpXGgDNSPeB88BYc2P70XoUxO2mzrzYw6cSzJ0hoj08QHoL5vI9uW+dCb34Anpsih5TEUTcCjbBOkXxrNQ63Cy13E7xh8bnDMVkX+gX4btB2YotU7CmwgbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761697511; c=relaxed/simple;
	bh=DjcBVY8mJqbGJnCRObWENCx0c6xRt7QNzm9li1dg71c=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=owIs6n2LN4mYO2J3azAa0mlM8gB24TrX4NC0IHdUGGz4erfyRbFYhlQt65Cmmuz9OkYBSLxg8YIhFboy8cpV9QyPT1zXQsXNLpSqC9TWWJMbBx+8VZFidJPR4KmyHGhXbRXdu12RSExdX3dSqovXwpLNStWGfn19c5V7BRO+Om8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-9435917adb9so464931939f.2
        for <syzbot@lists.linux.dev>; Tue, 28 Oct 2025 17:25:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761697509; x=1762302309;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DjcBVY8mJqbGJnCRObWENCx0c6xRt7QNzm9li1dg71c=;
        b=UgyWVmwnkNX+0jpcsX+XKfdenXqDK5FsQEUtrOs1JkvmLpOE8yXr8CjhiPMc/9k9CF
         JRlFQEVHgYKomOZdc/1ixkfZ6Aj/EEDu7unDt2iyyUPPGw4MFLzgk2vU4bWOAoCMWtZX
         qjvKx4wq8Sn79i7141/fWH3HPoFWA3Z3BYpqs1X/tH/179cukiSOZvjbAyzdVoEtlf7/
         p1mLdXiAVvO2J5lZf12JkxHP/tGaaNB02+0OKzKlhssUO8tIs79FWnwigRaSHTGABT9n
         H8qpknpNfWJ0i9FfLEVbs8yipj1nqUMWOLHCQhrJDLIWKcyU15O0HVa7SOpstlo7aTEi
         /0sg==
X-Forwarded-Encrypted: i=1; AJvYcCVBFgiEuz2cfuXjqwW5AlBY4ZFqGwbR+dtZFsjojqRQuXwDOoZ2nNKQjmAWz10kfpy3PU/Pf8o=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz65g6PUE7UpaP4d3hml2KEPpN7V3g+qViFIjp6pBeVcCB+/LtG
	LVm9b4o/EWP9RcKT+67eZ5ZoAGsIHwAoDbq4oAagKoZLumunNuUG0T3L4rAHsn02ciaRlhMvDHx
	TYBR+UnjosTh/y6WsY7qbir2vSPIT4pnj5Ohu0s8korCWRlD2IkjQdNw2B7g=
X-Google-Smtp-Source: AGHT+IHRPJ5vQoHGCAChMRTb+GIwk2dkZrqG6byeJVWlhSwoPis1XmTYkNmxVcxDmVOk4U7RHrNmmt0Y0/QA/uPrHF/tucDVAqRX
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:9:b0:42e:d74:7252 with SMTP id
 e9e14a558f8ab-432f906642amr16004065ab.31.1761697508978; Tue, 28 Oct 2025
 17:25:08 -0700 (PDT)
Date: Tue, 28 Oct 2025 17:25:08 -0700
In-Reply-To: <aQFeMG8WEvrWaNf0@hyeyoo>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69015ee4.050a0220.3344a1.03f9.GAE@google.com>
Subject: Re: Re: [syzbot ci] Re: Eliminate Dying Memory Cgroup
From: syzbot ci <syzbot@syzkaller.appspotmail.com>
To: harry.yoo@oracle.com
Cc: akpm@linux-foundation.org, axelrasmussen@google.com, 
	cgroups@vger.kernel.org, chengming.zhou@linux.dev, david@redhat.com, 
	hannes@cmpxchg.org, harry.yoo@oracle.com, hughd@google.com, 
	imran.f.khan@oracle.com, kamalesh.babulal@oracle.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, lorenzo.stoakes@oracle.com, 
	mhocko@suse.com, muchun.song@linux.dev, nphamcs@gmail.com, qi.zheng@linux.dev, 
	roman.gushchin@linux.dev, shakeel.butt@linux.dev, songmuchun@bytedance.com, 
	syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com, weixugc@google.com, 
	yuanchu@google.com, zhengqi.arch@bytedance.com, ziy@nvidia.com
Content-Type: text/plain; charset="UTF-8"


Unknown command

