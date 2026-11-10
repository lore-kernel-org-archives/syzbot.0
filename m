Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.167.199
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794292940;
	b=OA2UZK6kKSD5Iso4VSOa96YzPRuBJsqgPQIVLe6CnUHtKA7rjswy3+y3lcgNicvzsfDg
	 U40Goxt9qeEchy+ogRl08IJZEU1vfkt+6Gzl2u2YwRNCg6+oVmjIUW5YIEo+IbZ5FVoV1
	 rprZRdMC0qDg6aiARZX0m2FLmUfM/LdczT2fvGLL2tK5sbpotB+mC0/te8AM2MmRU5gDx
	 9KrbmYqTdo9nkSKLjKM5TmF09z5UgxHaFCcyg15aJpRmXLAGjrnKhjSkZ49L4Ytqx90PR
	 zfqPIvy5AhxyUS+HjrHFJeuxwZ30ldfqyDBBNxNX1c80Aa+j5htnyzXiPwftnIxZhrQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794292940;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 MIME-Version:X-Received:Date:X-Google-Appengine-App-Id:
	 X-Google-Appengine-App-Id-Alias:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=XmQDJHQXRpFczfLlXTmYv4d0Bcvw+C41/ERY1C4zYwQ=;
	b=BRmLVIelbamhr7oYL67SF4EJlzJh+dgUpmE9KwaEWxtpwANv5Fw2buTuxtFecEfLSzCH
	 34ZQirYvC3PbG0xAokWod9kLuv+iLvvuXZgnMG3F5HAFVVATSye+1RAgmCqkztJZCDmRX
	 Xhzi9XeS/HQHYa8kAhNO3KawaAebND/RClNtTGesPcZpiVqLJv1VuWUN5XuDSaAVulCTG
	 mOJVGDLUbJXN1U4g3przDTH2a8n8+kPfkihnCRpxXJYmTmb8e24Yqo4KCBCG2YFFHAnj+
	 XISgRkDVgL8u+4McUYm8WQ5crsQL65CSwVAUjuB2CxDQ+55s3R18XIteRDAd+1F1OQg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=syzkaller.appspotmail.com;
	spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	arc=none smtp.remote-ip=209.85.167.199
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com [209.85.167.199])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B6F6606A33B
	for <syzbot@lists.linux.dev>; Tue, 10 Nov 2026 06:42:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2B6F6606A33B
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f199.google.com with SMTP id 5614622812f47-567e742f481so1027018b6e.3
        for <syzbot@lists.linux.dev>; Mon, 09 Nov 2026 22:42:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794292939; x=1794897739;
        h=content-type:cc:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XmQDJHQXRpFczfLlXTmYv4d0Bcvw+C41/ERY1C4zYwQ=;
        b=I3U4dTNnCFhuifvJkxbjAJJlD3/e9ez/nhnl1xCSQeTh+9davKAiKXxUqNr4SW4fWK
         XQiEtNnE0Yqbm+1mriZYEL0uhkM47uo9DFZMJ/YLRM0H0zOAl36JknGYJ3CRVdy9cl4b
         j/PAu1KQCzt4ods2642bBoEzaXdQvV6wrQattjpjk7anu+Y21owr+g14/YuMn7S7CX68
         PvisOGJRnnrWzYg141sZzqJqwKsfx9Z5QJSvWxnqbNONQiu2bZO/WKH+RK1+gxB03Wmj
         TRtpSVik3AxyQmdfQCDzkN5bndnxUb7Z29tdAA3RXNn/cj2gycqWW6A39qKEdVEwzaw0
         +edQ==
X-Gm-Message-State: APuU4Z88nCAiireC7Br9flD4OgovEUPYHQABpt25/OMktedGQZfuhbYQ
	o3aIvHyElAYt33SY/BQ5BV/eIjvs36MA3HM1YqZwS9Pf3eNzc1YAOIS5QSypAi2TQ72SUsTEBC8
	iJAT6lEJJii3f0vYR7ebqzbz05N69d7UTs3KevWxzAM1O0wklwHK+1z4hD+4=
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Post: <mailto:syzbot@lists.linux.dev>
List-Help: <mailto:syzbot+help@lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
List-Owner: <mailto:syzbot+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-Received: by 2002:a05:6808:1993:b0:4d6:9273:251d with SMTP id
 5614622812f47-5683cdc80camr1400033b6e.57.1794292939108; Mon, 09 Nov 2026
 22:42:19 -0800 (PST)
Date: Mon, 09 Nov 2026 22:42:19 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6af2bccb.f27d6985.26ae05.004b.GAE@google.com>
Subject: [moderation/CI] Re: net: leave O_NONBLOCK to the sendmsg and recvmsg syscalls
From: syzbot ci <syzbot+ciaae744690cd95ee5@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v1] net: leave O_NONBLOCK to the sendmsg and recvmsg syscalls
https://lore.kernel.org/all/f084de67-85b0-4759-845f-513879ebee5f@kernel.dk
* [PATCH] net: leave O_NONBLOCK to the sendmsg and recvmsg syscalls

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/4835d68c-fc3f-41c6-9499-8a9de6613c8c

***

kernel build error

tree:      net-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netdev/net-next.git
base:      dce8f33934591b405067149ea4603ec89c878a6f
arch:      amd64
compiler:  Debian clang version 22.1.8 (1~deb13u4), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/5113e912-7848-4b30-a836-740c8331eae2/config

make[3]: *** No rule to make target 'net/socket.o', needed by 'net/built-in.a'.  Stop.

***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

To test a fix for this bug, please reply with `#syz test`
(on a separate line) and attach the patch to the email.

Notes:
- The patch will be applied on top of the tested series (as an
  incremental fix).
- To test a new version of the whole series, please send it directly
  to syzbot@lists.linux.dev.
- Arguments like custom git repos and branches are not supported.

The email will later be sent to:
[axboe@kernel.dk edumazet@kernel.org kuba@kernel.org kuniyu@google.com netdev@vger.kernel.org pabeni@redhat.com willemb@google.com]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

