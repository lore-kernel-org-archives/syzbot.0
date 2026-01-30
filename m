Received: from mail-oa1-f72.google.com (mail-oa1-f72.google.com [209.85.160.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7171344D89
	for <syzbot@lists.linux.dev>; Fri, 30 Jan 2026 16:41:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769791315; cv=none; b=IwI5X/RrLxzolodn6XavZo4Rx7TD1KGB0vozza9Nu+tUJ8LfEqb5dJvsmzfcYCzq3bHjEweJTNoFr4QkPDgaabo0pcUk3Cnjg5asO7bCU/DmqQ3JlfbNYLpdc3HJawMJ8T+umKsDXAlt9uXwDJLQfKwjWDvp36mQOHB1fQ3w8qs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769791315; c=relaxed/simple;
	bh=DjcBVY8mJqbGJnCRObWENCx0c6xRt7QNzm9li1dg71c=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=eyNhQWyd262sjhpp2OT2LOhQ81mcPNvYL6Jv5GQr+S3zWu92CbJKxQY8j+cyVnAagDvCJxHvVFAMgXzIZd7NFXea+dCRBsVmf0CuPVYeZlAGsMesI7jt+2tT3I/36OSbnXeggXT/cH8/ilOGqqM42lRKh2eNKCeGXVkXO3zV3yM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.160.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oa1-f72.google.com with SMTP id 586e51a60fabf-40948b7e832so7087510fac.0
        for <syzbot@lists.linux.dev>; Fri, 30 Jan 2026 08:41:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769791313; x=1770396113;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DjcBVY8mJqbGJnCRObWENCx0c6xRt7QNzm9li1dg71c=;
        b=UMvGTpHUu5aFVtN8sFDUP46ETmnMb1JIMCsn1O3PfeaN/D50k53TjkWhxwAO1gvirr
         m7OyR35fI3Ppse74nG5Sc3SYbnvnBKI4u+U7whF+8TQMAQSJiT+ORtmapZhULa0V3JUt
         ZZrQCA89nt5wIOyMHDSLQ1H19yG12u4nIpOb7pI2a9fs8R06elKQa2vxC1aWCwbfYfk5
         P/oPtA7DktheLKlwOv6CePKBLDJnys8b6dtM0dikm0iDkvPfMJClulinWpxakKGVSEKH
         zRdDhv/CStrwEf0W7fOSSds33kTfdM+mzmfweOOqGAmZpltyUpNpn8npWjy+oQSW7Dxl
         UsCw==
X-Forwarded-Encrypted: i=1; AJvYcCXLHLKYs6oU6hZ7Z1rl+NCoKro107szhBcBlowYm4ftTACDxbEMzl65vODKvDZOl8I+qPZtOCY=@lists.linux.dev
X-Gm-Message-State: AOJu0YwgtEkJQ4l7OkxNwmx0mSo1/21Pjttaijk9xSBV5rAMM8gLEP3v
	jc5VCNspe1Vm3ivrUqJTy1MoopcMuz1dwMn0zRyn/CodCXHhgmfsp5EIxgVnq2elBSFk0XyvH2V
	4+zbIu8LgdddD+POCjrGa+NxroHuqxL9FxQnDwtKdP5w3SGFXKTqqX79GQKU=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:4613:b0:663:cb2:d67d with SMTP id
 006d021491bc7-6630f04c2bamr1438160eaf.37.1769791312692; Fri, 30 Jan 2026
 08:41:52 -0800 (PST)
Date: Fri, 30 Jan 2026 08:41:52 -0800
In-Reply-To: <2A678D66-2516-4130-A34B-6A0B3549EEA7@nvidia.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <697cdf50.050a0220.371857.00e6.GAE@google.com>
Subject: Re: Re: [syzbot ci] Separate compound page from folio
From: syzbot ci <syzbot@syzkaller.appspotmail.com>
To: ziy@nvidia.com
Cc: akpm@linux-foundation.org, apopple@nvidia.com, axboe@kernel.dk, 
	balbirs@nvidia.com, baohua@kernel.org, baolin.wang@linux.alibaba.com, 
	david@kernel.org, dev.jain@arm.com, hannes@cmpxchg.org, 
	io-uring@vger.kernel.org, jackmanb@google.com, jgg@nvidia.com, 
	lance.yang@linux.dev, liam.howlett@oracle.com, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, lorenzo.stoakes@oracle.com, mhocko@suse.com, 
	muchun.song@linux.dev, npache@redhat.com, osalvador@suse.de, rppt@kernel.org, 
	ryan.roberts@arm.com, surenb@google.com, syzbot@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com, vbabka@suse.cz, willy@infradead.org, 
	ziy@nvidia.com
Content-Type: text/plain; charset="UTF-8"


Unknown command

