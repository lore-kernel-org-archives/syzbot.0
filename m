Received: from mail-oo1-f69.google.com (mail-oo1-f69.google.com [209.85.161.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 280FD33344C
	for <syzbot@lists.linux.dev>; Thu, 26 Feb 2026 17:38:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772127484; cv=none; b=pqVvaHpc6trlXm9V2/fwzpXTNhhQMtQz7fZUqCX8UoRav64LnZ6ateiJlGB+17bar25+3nrIj1m8VE+KAkCT27M6yDzrlpab1gSXHtmi7PP3kMXF0VfEZjN57ZECL9Fi+3r94KHlzvSVaS6aIXetCIiQ3oaAYttf/5ETIRjDm7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772127484; c=relaxed/simple;
	bh=DjcBVY8mJqbGJnCRObWENCx0c6xRt7QNzm9li1dg71c=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=ONZn9AIUJRku5T7WaqhiT9s+LlRNq3qvrJvkY/+O7qOHiT0u+pQqMdqpqp1EDPOeYrxI4XK2AFG+hS0riao5phbb/WVWNIMDNvDnPsTfQc4M4ubiH/N2j2S5tgUge1O0KvbeKExhUE6yxf+PwKYqMJCfeHEzNXcDYaGI2XizPt8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f69.google.com with SMTP id 006d021491bc7-6799654a158so9605450eaf.0
        for <syzbot@lists.linux.dev>; Thu, 26 Feb 2026 09:38:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772127482; x=1772732282;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DjcBVY8mJqbGJnCRObWENCx0c6xRt7QNzm9li1dg71c=;
        b=D4lBeFgwOKvRMEddbhj7Y1P58yagUeipt/ANyWcSYwA61VZ74QKT6Gm/FAq1fG3OjW
         hp4JggUevtTMmMShat7ViTH9P/bHvVDl+0hIigfzm+bYJ1uwG5vCBXvI2UHxOYo+UraB
         V+dhWbSmQsfy73NTHfgVK9SWcZjyX9zhuyvxfKb41F4wiMuKhx+qFlqGnWludoRLzTuu
         SR8QvrNbtxm+f3jgroRBOJXFnhNYXXp5xtbrDeLx1pz8fuzLjuqusbomdGF0ZyUpbM1W
         Kfk+uhBUl6XmN08h6TK3xb03M2UgDh5c5lOTqXuTUxRpnYEbCoSSm3ukemK0T6aMRgRQ
         xAZg==
X-Forwarded-Encrypted: i=1; AJvYcCVfdnNhUKar0mXv/FUzbKjIxiicFjOVaifLcqfubt7xRNKqA17T6rUItU7nxqg14pqsPr/McN8=@lists.linux.dev
X-Gm-Message-State: AOJu0Yyw9t9UIzGg9SzV4m6pmAyFC3mDBlsI1/V2rS+vHNuxcNoyfxqj
	mzOUBYH7tncKJ/tEWC81zUoDvrMgNCkIYWQzqEYu4apudZjvwstRgz1YvjKE4BcmBjLJg16+8RY
	mmnSp4ylPuFSJagZn4qAC47NuXXEVy6P1ouJB6vNnJt9qMO14K71SZcmrCwE=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:1c89:b0:677:fc0b:dc with SMTP id
 006d021491bc7-679fae78a73mr50070eaf.33.1772127482186; Thu, 26 Feb 2026
 09:38:02 -0800 (PST)
Date: Thu, 26 Feb 2026 09:38:02 -0800
In-Reply-To: <20260226173657.1285415-1-memxor@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69a084fa.050a0220.16c224.0009.GAE@google.com>
Subject: Re: [syzbot ci] Re: Close race in freeing special fields and map value
From: syzbot ci <syzbot@syzkaller.appspotmail.com>
To: memxor@gmail.com
Cc: andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org, 
	daniel@iogearbox.net, eddyz87@gmail.com, kernel-team@meta.com, kkd@meta.com, 
	martin.lau@kernel.org, memxor@gmail.com, paulmck@kernel.org, 
	syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com, yatsenko@meta.com
Content-Type: text/plain; charset="UTF-8"


Unknown command

