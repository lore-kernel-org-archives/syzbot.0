Received: from mail-oo1-f69.google.com (mail-oo1-f69.google.com [209.85.161.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6AD8332917
	for <syzbot@lists.linux.dev>; Tue, 10 Feb 2026 08:14:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770711253; cv=none; b=qCy2QB822j/bsOYcyoqbUw5J4i7PAcFj2HIj9j0wBe4TYznXWVVh47dIRy91YipBRDrERzhbfVTWmhEYI40bgyrr5vvShX14yAwqv1FVu1ohZBq0NTyYJVrpYwwhBjT4h22Beou7ekI844P5oQhhcuEpXF+vI8OLbW0oiJ6vZcM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770711253; c=relaxed/simple;
	bh=FOXwCY481o62juFErMPqMs9pzybTQorkO2pMpVqo3Rs=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=OPAUW5VO7wOmGbMVXD4xfyxQWbnSlVBQXYGwv9sWyp9IOw/LuvmL//Xpo0srnbmui2Nv9kmyu1YmvEGDd2ZVCHk1DfXYItyYFoamC2MhJnFMBMq+oElTxwFap3GobgyAYMTu047fbVaSGi8kH/6UjLbgAQv2DSD4fRyMyj2Kcus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f69.google.com with SMTP id 006d021491bc7-662f738c3bfso2158486eaf.0
        for <syzbot@lists.linux.dev>; Tue, 10 Feb 2026 00:14:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770711251; x=1771316051;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FOXwCY481o62juFErMPqMs9pzybTQorkO2pMpVqo3Rs=;
        b=nUUGNMB1wTRuJlYwYP3vEgpV5anRibU47BCvor6GkDUbTm1DG6fhwwL/IZZY34tHUx
         F/BmhCLU7KGlweUadn+1P8lSmmDMMdE0rnM2iEYOQM+wdr4CT+W3eTIFbqjP+ab4Ego+
         xBpRRdtqWm/PEBW/xWpT3zmgi20iEHhqlFxD2oqv9f0YyySUkTuOGHSeEtdIW1s1dXSy
         VcUGJ2XXSrPQkw6/LUNrkuetNqEMGlyi3lMSP4iX3EtXLjJhi2dMqGY1n6+7Tw2/WSk3
         XDJOfRW2FIy5v/dSq/8x1Fv9dj0TcaRzTKJKuRFnP6iMnEh8MW15IUP26wOIjRp53Tu+
         UqOA==
X-Gm-Message-State: AOJu0Yyo0JBjVp7eb/tu3r1IpJWYdb24TPv0E4Xm1dUKJoxyi1PdWMiK
	nOHv1EwHG8YiKrLs6QC12ghbl5vrnjoYbrhPK3QM88y7GT/q0Vow/lXYcexvFTDiW6GV+21ItqN
	UzqxKwOC+MB84gc7UWPpb5K17dlrqAaWyR7d7C7ogrmIeJaWK6n+aCy128bs=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:4b8c:b0:66a:ebc4:66ca with SMTP id
 006d021491bc7-66d0d8ca18bmr5971797eaf.83.1770711250714; Tue, 10 Feb 2026
 00:14:10 -0800 (PST)
Date: Tue, 10 Feb 2026 00:14:10 -0800
In-Reply-To: <54193ab13758d5496be6c8b5de9c32992d79f30b.camel@oracle.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <698ae8d2.050a0220.3b3015.008e.GAE@google.com>
Subject: Forwarded: Re: [syzbot ci] Re: net/rds: RDS-TCP reconnect and fanout improvements
From: syzbot <syzbot@syzkaller.appspotmail.com>
To: syzbot@lists.linux.dev
Cc: syzbot <syzbot+ci858e84e8400d24b3@syzkaller.appspotmail.com>, 
	allison.henderson@oracle.com
Content-Type: text/plain; charset="UTF-8"

For archival purposes, forwarding an incoming command email to
syzbot@lists.linux.dev.

***

Subject: Re: [syzbot ci] Re: net/rds: RDS-TCP reconnect and fanout improvements
Author: allison.henderson@oracle.com

#syz test: https://github.com/allisonhenderson/rds_work.git rds_tcp_bug_fixes_v15

