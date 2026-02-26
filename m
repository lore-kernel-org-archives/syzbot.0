Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com [209.85.210.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD6203B52EF
	for <syzbot@lists.linux.dev>; Thu, 26 Feb 2026 18:30:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772130619; cv=none; b=PUctNyIbFGteIpLtGUz2ZQm1QgnBobDD7yv8qMjd/02C7p8GheaWpyPKALb/xgueTxZNEl6g6vpepFcAAFwZcllqeBXX5j1lhUwBc3qd7ZLaUkGdJYcMGSrVqhR40Q9lD+zdMLF60N/n3RlJlh4mHl9RCtyNTpp1tUzu04s5oFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772130619; c=relaxed/simple;
	bh=DjcBVY8mJqbGJnCRObWENCx0c6xRt7QNzm9li1dg71c=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=RovLTC4uuT3A5wZP1z36l7J/4nAEbItliKMy1Fk9PlnM/waeyhY6qj4tIoQ9NJd398gIiHVzDv1IbvaxweCLHK6OBvCLo8jB1ixjfmflLcY00TvgfgBcL+h9ORUPjt210zgbPNF2f+37SVSSrHSMJVKYvqR3syo5vmWg14X/r3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.210.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f70.google.com with SMTP id 46e09a7af769-7d195fe3eb4so22581907a34.3
        for <syzbot@lists.linux.dev>; Thu, 26 Feb 2026 10:30:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772130617; x=1772735417;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DjcBVY8mJqbGJnCRObWENCx0c6xRt7QNzm9li1dg71c=;
        b=jf62QPXnNOq3y9RxjcB4I+gQDF5Luuz4Jg47+K/7RMf19mzwEiHCyxSw/s3aGcjejc
         PJIaDlEIp0fET705+aQCv5pmlXspKYZYl+iwqd3alZC75FdxI+ICqcWRiL6OK3ot263g
         rxieebryHPURH8CA9fItjlIUPAJSOQJ89kCH11AqRLjMxifIddiBwlrDlJEu95D4/uSX
         Se1mT20QABVf4B0ybHy12carTQEq7mOaC+d84Q5nRTFBRk4FpLiFZhTSvUQSGO8uRxvB
         KQpdkngaWzI6hntDcQEQkCXEYOZGYTmzh/q95RKgWjXiJ0w0lFtMAUWU5NOdOVxQ7s81
         v8Ig==
X-Forwarded-Encrypted: i=1; AJvYcCXm0OFpvp5FpkBB6juCn2RCK4V9m4/HjbE1aSOIoHM3EJXDKsY7gqJVHjexZDUtGZcoXsxbt7w=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx88yIynN01aiGh/dhO5rtGUT8h712RmnXi9NrPD/FNAn3LGDZc
	EUAFInx9jcbBsShkFKBhbElrEuUGzH3xAqg54vJ4m8QBfNz7d67bqtzp1rS2x+kKDQb7hk1qXBI
	dONENRWTbd1yojX9Knnq0CZVxA+P8C7ZrRpM7HrdQOgQTFAD3pDbO0OTGoL0=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:3105:b0:662:ef26:1505 with SMTP id
 006d021491bc7-679faefbbe0mr174206eaf.46.1772130616866; Thu, 26 Feb 2026
 10:30:16 -0800 (PST)
Date: Thu, 26 Feb 2026 10:30:16 -0800
In-Reply-To: <20260226182822.1734308-1-memxor@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69a09138.050a0220.3a55be.0007.GAE@google.com>
Subject: Re: [syzbot ci] Re: Close race in freeing special fields and map value
From: syzbot ci <syzbot@syzkaller.appspotmail.com>
To: memxor@gmail.com
Cc: andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org, 
	daniel@iogearbox.net, eddyz87@gmail.com, kernel-team@meta.com, kkd@meta.com, 
	martin.lau@kernel.org, memxor@gmail.com, paulmck@kernel.org, 
	syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com, yatsenko@meta.com
Content-Type: text/plain; charset="UTF-8"


Unknown command

