Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com [209.85.167.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 611CC35F165
	for <syzbot@lists.linux.dev>; Fri,  9 Oct 2026 17:28:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791566884; cv=none; b=nnhOfhh62WxLRPc63/BX4VBtKvnNVLGUG1OQOXcWS3B0yDh6iv3N0xqcB2F7cDpIk3LC2WzRpsFoRhFnsKeg9eSttEbTp5/NytU4oeEPjRQ88JuxfnHvR8Jf4i5s6usUVu/VGG0D3IT0jbYGCJApoPJ1aSgjGFWIUswsYdSuI5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791566884; c=relaxed/simple;
	bh=lWX+/1RyjNePJnt8pr9EgTlPhArvoVlvf7b5HMomPnY=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=tuQkifTBc4+ieCwv3bgSbAkqr2D1lxw+QT6YgCvgSqKNWcW5N1IMHmVN7tzidcbxoYCZC1qACyp9PdeLyjdekKRhgkZka5NtYyJynCanH+BnIiiiaLVb4OtAwoOjEyxYJB/OZTJLPrviIBBbKhSMkBibWyAFITmbA7KnCml9szQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f197.google.com with SMTP id 5614622812f47-4dc57e2a3f2so58415b6e.0
        for <syzbot@lists.linux.dev>; Fri, 09 Oct 2026 10:28:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791566882; x=1792171682;
        h=content-type:to:from:subject:message-id:in-reply-to:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=NB7QKtmwUFWZSd8u8+y+zdCE4WNPIGCC42KAhXJZKz0=;
        b=1ZGrtrTXW8Xe7ShMTmhKt5SUxj8v31OdC1YXBk2wlsNjJYPeraq7RvS06Ppncsh+6f
         pZhSvmYoB5aGzicJNfOf+JNo9J1IUW6vhQ50Dv54XtmahmnGyCwBRXnsMFW2liLYhBO1
         ep1l2kdk/pVNxlXJt23dpv2WIgmDiah2SQ1O0VCpwb1rMxWI21/dxZKrlZmqQi1iqKSg
         UNjKm08MvMGCLl4AGfqhKZ4hoscpmxexrDfflUltMg+tUyhKpX8EVTSTmqr0PQTpAAZs
         uBxA6N4EU8MpSyL+0Dp7JT0R7Y2CUQHlKlXqvcY6RKLox2SBmOFTMLHLuoD3H+yXBjSd
         3pjQ==
X-Forwarded-Encrypted: i=1; AKwUvBytqbfNTfkuw6p3aD8I/+f6/JUvDFcUSHYih7Wpm5/f+t5aQI0qjCp7Huwc8Bq+bloMuCDkb/8=@lists.linux.dev
X-Gm-Message-State: AFuF++nhqQq7y6CvYcF1IRKBzxzTiqO14pOxCU2sg7k3XJ29rG9XdpEf
	T3YAk556Yr4MDMyFjAlKoIc/rXFawX2z0q1zuLR7AAotsAtMUEYc0Lbz936Tjp3ouy0dxEd+nbw
	NYD7syIRXxxJ0P5WwKKuozSDhdFUkBFWxASyoHAiEs+KwfsQJ8oubtr03ULY=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:508d:b0:4d6:9153:295c with SMTP id
 5614622812f47-50c57695ff0mr2437078b6e.45.1791566882342; Fri, 09 Oct 2026
 10:28:02 -0700 (PDT)
Date: Fri, 09 Oct 2026 10:28:02 -0700
In-Reply-To: <6a698f41.d9e86bb5.297b12.0051.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6ac92422.8cdf6287.1eb53.004f.GAE@google.com>
Subject: Re: [syzbot] [usb?] KASAN: invalid-free in f_uac2_opts_c_srate_store
From: syzbot <syzbot+a4f65284f1451010b0a8@syzkaller.appspotmail.com>
To: a0yami@mailbox.org, christophe.jaillet@wanadoo.fr, 
	gregkh@linuxfoundation.org, julian@jusst.de, kartikey406@gmail.com, 
	kees@kernel.org, linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org, 
	pavel.hofman@ivitera.com, syzbot@kernel.org, syzbot@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com, 
	syzkaller-upstream-moderation@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot suspects this issue was fixed by commit:

commit 844d83d5964b87919b958ff48405188c6ddae9cc
Author: Qing Ming <a0yami@mailbox.org>
Date:   Tue May 19 14:33:19 2026 +0000

    usb: gadget: uac: validate rate list length before storing

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=12c8c671580000
start commit:   f5bbbfec59b4 Merge tag 'probes-fixes-v7.2-rc7' of git://gi..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=158601bb8cb292dd
dashboard link: https://syzkaller.appspot.com/bug?extid=a4f65284f1451010b0a8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1504aa9e580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=149f7879580000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: usb: gadget: uac: validate rate list length before storing

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
