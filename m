Received: from mail-oo1-f69.google.com (mail-oo1-f69.google.com [209.85.161.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E1A23446C4
	for <syzbot@lists.linux.dev>; Fri, 14 Aug 2026 14:00:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786716005; cv=none; b=r/F5uXoHhHwMGLGZT9dyEGEsoyn4n6PirNJz1NMiRGrJSnxXtQpuBAeHf3R5tZtJmTTvKR6qEhYx61/cyhJFnecfJcIJ5gjPE1AutHVrU7NlEJXXb92ko7pabBV+XJ8TJWWEKsvfxzBXhf2ww234bQM/VfAv6SpxAQU9gmxBXV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786716005; c=relaxed/simple;
	bh=IVdLexSuZcROpf/hvkp6Xr6NU1ovmiPX66oJB2ozh1w=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=bbIKFbjVgQ1WzheE+kkPMplBVZUSPIAOcdu+91nb8Pyq45vJGuuOmujsJ6ADakqeAq65HaHdD5ehYp2CYVJ4CyOkfoqipaztr7bv13OHiaIhKPyl+SmL9f0Mus59ZfFOrc5fFV9GZ2gsK7APiramzB2zfF5ORvILXbZAWpuoIoU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f69.google.com with SMTP id 006d021491bc7-6a17dafd042so1117349eaf.2
        for <syzbot@lists.linux.dev>; Fri, 14 Aug 2026 07:00:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786716002; x=1787320802;
        h=content-type:to:from:subject:message-id:in-reply-to:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=VgtFeurelXguNoym2EWTBBoks03AOBv9fhnKhit1Czo=;
        b=hsSW7+cA11yVEysf4RUD2GgyPfDQr/9BCJRbwGBzI2tjZXV7ROvZYdebUm/YhtMJcu
         OnfUbBQRihKkQuHwJnOcKfEHM7hjh9dvJVATFoeRGyMvabRWs1A+4VOkE2YMgI6u4Wrm
         0wLEj4t8bKQXLm7h41nST2TuIEQocE9bFAzXbiT7SsJcT+Rfx3SOQ5ZmuMdnQfRABkMW
         epl9iVJMOzw0ZZhkzWuyARSAhvJYVd7j/wx+WQjVkiGQqPhNaAImrlNieZTiVfmLmBeK
         DoutD4wtIc8OS2pLM5ILSi5Wgiyh/PoxFk6DGVhpNg85/TbXJtGzQi6abk/SZDTzFfvG
         lmtQ==
X-Forwarded-Encrypted: i=1; AHgh+Rrhsy+cwLcwRYcrz06/zrRIvYhgHL0aGehGTBvk9BRXfvTgn6A8AJ9DW6R1e3b54k9VPQpDLlQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YzqthR6Q4krDYRuFSa/cORCmZYhDi+DKmSzvntzRfmV566UiJuK
	JCBzOa3NDFZmhaWorhR/YEI/8kAw8sjfnU9Xf3n2qw//BzDdYTjLmsKGe1219PoCDM5IEveFRJ0
	ChXvGntdFceyw5skaGkZRTpuEowNjp8DuAja79HMX4Z9vvjl+3erUN8sQGH4=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:338a:20b0:6a1:98e6:a8f5 with SMTP id
 006d021491bc7-6b0d691c798mr3967518eaf.36.1786716002180; Fri, 14 Aug 2026
 07:00:02 -0700 (PDT)
Date: Fri, 14 Aug 2026 07:00:02 -0700
In-Reply-To: <178671419949.2648204.15668657474779239190@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a7f1f62.f7a79266.2f965f.0003.GAE@google.com>
Subject: Re: [syzbot] [tipc?] BUG: soft lockup in do_sock_setsockopt
From: syzbot <syzbot+10a41dc44eef71aa9450@syzkaller.appspotmail.com>
To: davem@davemloft.net, edumazet@google.com, horms@kernel.org, 
	immersa.bartosz.chronowski@gmail.com, jmaloy@redhat.com, kuba@kernel.org, 
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org, pabeni@redhat.com, 
	syzbot@kernel.org, syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com, 
	tipc-discussion@lists.sourceforge.net, tung.quang.nguyen@est.tech
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-by: syzbot+10a41dc44eef71aa9450@syzkaller.appspotmail.com
Tested-by: syzbot+10a41dc44eef71aa9450@syzkaller.appspotmail.com

Tested on:

commit:         1590cf03 Linux 7.2-rc4
git tree:       https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
console output: https://syzkaller.appspot.com/x/log.txt?x=17a00949580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=8e9390a601b4f3bd
dashboard link: https://syzkaller.appspot.com/bug?extid=10a41dc44eef71aa9450
compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44
patch:          https://syzkaller.appspot.com/x/patch.diff?x=10baba9e580000

Note: testing is done by a robot and is best-effort only.
