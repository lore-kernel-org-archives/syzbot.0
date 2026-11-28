Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.167.198
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795848115;
	b=4Ncv0Vh5nez3ZcM1o3sGMbI+9c38YsQJ+65ByZyyOP6S6OwCR+LV/3VbAMNDdIIR/hJ9
	 9PqXg9nY0dc/ZYoyW9cPgCRLlMB3DenMx8p1s0DdzDL0CXo5GP4V3b0cOXxLrUrafyQDb
	 YjYXVLyKnncC+sST9LbLJyTGjavzbGZOyIGNHOEf9nsh9ORqcKEmAWDQY5aUvB/plzzbF
	 3ODvDMrZLKiBpGHuWKRkJ+mZTa9oP1/reBuTEXtFjGuNTE1G3uQ52sdA+5IduEXFfN/+5
	 EqbCLiqSuy1QpqnIBpMLuJW6NmzSLpEQKE+vwOGplHVdMUikwloA14Nv+iU4+YFvWHA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795848115;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 MIME-Version:X-Received:Date:X-Google-Appengine-App-Id:
	 X-Google-Appengine-App-Id-Alias:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=t+LhQCZEk3IZb+PsnzQ6A8MkpoUZcoBUStLoma2uY44=;
	b=NCzGsjfWrHl7Qq2sKTAzdV79HQkMf4fAElsjlQzw/VzT1DgsSoZ/e2xNKpxhFGTnXv36
	 O7v2wqjkYeSnU+EfR3UGghniP4GucxbnQRftugfy2spFzkNO49762E0dZWx8t4kMgDruK
	 dcPg2g6Bz6SPbrDSD+oAOeWMFYBd8GapqVvTnCMa2/Dhg4DZmDWmcYycA/Nht1psSfPBu
	 V14tsmC3ZUABzPt8fRSxyyv1BQfwRT/bh4i+0Itdw8rt/PKwSdXcoxWm9jpaiavcTXyVJ
	 /7bEfJ/sueHL+ohrZBYB8jZo5SadqrImo2rYrfc7WAWHq9JlHJm3F8JwuF4bMqHFT+Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=syzkaller.appspotmail.com;
	spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	arc=none smtp.remote-ip=209.85.167.198
Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com [209.85.167.198])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21926606A31C
	for <syzbot@lists.linux.dev>; Sat, 28 Nov 2026 06:41:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 21926606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f198.google.com with SMTP id 5614622812f47-4f8281066c4so10075074b6e.2
        for <syzbot@lists.linux.dev>; Fri, 27 Nov 2026 22:41:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795848114; x=1796452914;
        h=content-type:cc:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=t+LhQCZEk3IZb+PsnzQ6A8MkpoUZcoBUStLoma2uY44=;
        b=nMg7n1QsMSjaGBI7dXvZUHXqoR3SjMQLI9sIS/ZBBTeknnsdAI6ct5Sx1Dh3JtMsMg
         56BQs0a79giX3FtsgOfs0D+DN4L/GLRPNnR3YEdH59Jvtvg50FoS99IBt9xLVnv+PB3T
         r79yywhEeJjDQQT874Q9FuNNFsbVa+d00jx9A3Ww9xqXwxhjPvTvmFRr2i5RUXRjQo1s
         0UHmiMh1Yh/MFNPj4RWZHq50KpiICvVFCKqLEGiJugjHM7sO+GYSYN59lOoDqTlwuFTd
         emBmwkXqkdrb2NKpTf/ZX+wl+zmSP2Ya3f7hK3yNJGo79A4GwmwbfQC4UOYlCuEV2oA9
         TM5w==
X-Gm-Message-State: APuU4Z+HRXY3Y7dVJ+ceb+HZ9w8BWvj5mNFP9PFe9lA+hJzg+K9shgSL
	B+JpNYOwMjhZaGCbHDwx6X1rRLgTaqeJDLOfF6laJUvFQfAXuShERyqWuPIXXv2FUvV6wE04984
	4ivXrvZdpXu1f9DdBbiPAoZAH5XqXBI0xiF93sWrt8ICRNmkO2K33/9rgsuc=
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Post: <mailto:syzbot@lists.linux.dev>
List-Help: <mailto:syzbot+help@lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
List-Owner: <mailto:syzbot+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-Received: by 2002:a05:6808:6711:b0:4f5:4eb5:1cd3 with SMTP id
 5614622812f47-57a0cdde540mr27967653b6e.61.1795848114100; Fri, 27 Nov 2026
 22:41:54 -0800 (PST)
Date: Fri, 27 Nov 2026 22:41:54 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6b0a77b2.ec6686d0.16faa.0153.GAE@google.com>
Subject: [moderation/CI] Re: ext4: protect ext4_acquire_dquot against freezing
From: syzbot ci <syzbot+ci5d852395095566ec@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v1] ext4: protect ext4_acquire_dquot against freezing
https://lore.kernel.org/all/20261123114602.66520-1-yebin@huaweicloud.com
* [PATCH] ext4: protect ext4_acquire_dquot against freezing

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/ffcb4d7b-2774-44b1-979f-c307573b0348

***

kernel build error

tree:      torvalds
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvalds/linux
base:      f4585067150b85e33f60876149a6e742928da75e
arch:      amd64
compiler:  Debian clang version 22.1.8 (1~deb13u5), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/7e320dda-bb3e-4444-80cf-12496abec085/config

fs/ext4/super.c:7165:6: error: use of undeclared identifier 'freeze_protected'; did you mean 'freeze_processes'?

***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[adilger.kernel@dilger.ca brauner@kernel.org jack@suse.cz linux-ext4@vger.kernel.org tytso@mit.edu yebin@huaweicloud.com]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

