Received: from mail-oo1-f70.google.com (mail-oo1-f70.google.com [209.85.161.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 041A43EC829
	for <syzbot@lists.linux.dev>; Mon, 17 Aug 2026 23:20:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787008805; cv=none; b=jazkBPaiSGb5mxOIsWNek6CMk14vLOOdlXoX5gIT/yfDy6llP7uZKmVfiTj7Ps+qPIAUgmwMJuCflZM8edUfNxg2+jFgbEGqdA9nfWUE0z8JstEU0reWb1g8yMiu1sL4lMDBhnCqI4MTdZWtRGshlzKQKlrlkYANVn8OgUImtcI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787008805; c=relaxed/simple;
	bh=iLjeVV55Fcw34Rf9/V9Y7KfCCfd+XfalLgM/aPC/AZ8=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=ZlUabBfETS4e/b993pOG0BIQIAluNdyEQFFQgCT1zr5LeHlGczehIO+kkylDdibshWkYaKqBMou65zNieIJvsK1o3dKcReMnfsWnjxoKVJmpiKnak2F/jc/narB4kSM3rpGSOmqL11Ciy/Ddo8PL7t0sTVK/44J7x5dgPBT17yA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f70.google.com with SMTP id 006d021491bc7-6b026a31fcdso4434740eaf.1
        for <syzbot@lists.linux.dev>; Mon, 17 Aug 2026 16:20:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787008803; x=1787613603;
        h=content-type:to:from:subject:message-id:in-reply-to:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=lgcDQhtaB4Hm6vLhZWeOiFt/hMdrxuNVdLV0aKbT9FM=;
        b=Sqe9MhFFCEOD953t2I73xRTIWIga3BytBgeiPdib+dvTK0VONulf7SVb+ksiDCp5l/
         +PaWRlP7tC9KDb1sHiGDGk8xPV71tZApAA3ZUNCA5Ei5XhgW2Oa/AURj+IGPaEPOWNaP
         gt7p0zUZti4fdL1xoHe1fd3GfnJofJxbYcVxwEH1wjt80jXcdRMziAZFXAahA6SA3tV1
         VfDEjz06BJKfCplmD452fDCsi62uP9wquGlkPk29x63xJsHoMxjNK/wvpbhjAPJ05DYD
         TAHmYW+C/It2yM7z9UlPrcvUZ8ZPx0KLdC/sTFJXVO583FRMssZzukpRouWkGCKY6rct
         0hSA==
X-Forwarded-Encrypted: i=1; AHgh+RqKc3rslQliVi0NeKFC7wcpWaTrBvicpNItd6FhVxeIarhIz+l49njg9ye5QTL7OvDgZ3DVOwI=@lists.linux.dev
X-Gm-Message-State: AOJu0YzywaBYTjXWbYNwVphqZkiHlU+R8LVEdmIce8rhSe7rbKkH6aqq
	Z52eJZC5iUvU1LSmqWi/aRbirPA1AkSZU7libgIntI1HlvVZrZa7N3FnFMX5vBP7hU5cD7cC9vx
	UaCcyKwQKYbBHOIRttH4kRMmr/3hMyHwFn1Xiolp3SBOl5cib/l+4VWn7IuE=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:16a4:b0:6b0:4a79:5d31 with SMTP id
 006d021491bc7-6b0d68f62f5mr21095447eaf.30.1787008802761; Mon, 17 Aug 2026
 16:20:02 -0700 (PDT)
Date: Mon, 17 Aug 2026 16:20:02 -0700
In-Reply-To: <69725516.a00a0220.3ad28e.ea7a.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a839722.f7a79266.2f965f.002e.GAE@google.com>
Subject: Re: [syzbot] [ocfs2?] possible deadlock in ocfs2_xattr_remove
From: syzbot <syzbot+7df4afa14aeda476a7a1@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, nogikh@google.com, 
	ocfs2-devel@lists.linux.dev, syzbot@kernel.org, syzbot@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com, 
	syzkaller-upstream-moderation@googlegroups.com, teddy.astie@vates.tech, 
	tglx@kernel.org
Content-Type: text/plain; charset="UTF-8"

syzbot suspects this issue was fixed by commit:

commit f24df84cbe05e4471c04ac4b921fc0340bbc7752
Author: Thomas Gleixner <tglx@kernel.org>
Date:   Tue Jun 9 15:14:45 2026 +0000

    time/jiffies: Register jiffies clocksource before usage

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=156f3949580000
start commit:   5862221fdded Merge tag 'parisc-for-7.1-rc3' of git://git.k..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=f2e8ebfec4636d32
dashboard link: https://syzkaller.appspot.com/bug?extid=7df4afa14aeda476a7a1
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10f2200e580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11ae9636580000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: time/jiffies: Register jiffies clocksource before usage

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
