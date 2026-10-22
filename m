Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.167.198
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792671798;
	b=IYBeeqvkOmV7daSvMG29+2LDu2N1UJCPka25x9fcOU1prwu5ymiKXs8ZQ175LRJO9bly
	 Gco5mzV1sIUV4WeQHE58TDIpBjBT/LOV5Uy/EAhOdwpNZ3z6Fw5yn9/dKK0xBy27P4Ma+
	 kKAzc4OqyCJlIP8Q0iJkjySR12US4zIuf3Fd5A76a5saATNj724I9vUclXAERRrc4VNrV
	 GFt4r+nVItLNNsFwTcfgAJdyAmd/jorUZii/PkSSHGNhpPMoU/DfMbic+SIllKIQlfvNF
	 foTi1qXeJQrlOsFKw0qBxUxKgj2HBKCA1pl0M/29DaXjoHMqIDZmzySY3LonmNuIYEQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792671798;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 MIME-Version:X-Received:Date:In-Reply-To:X-Google-Appengine-App-Id:
	 X-Google-Appengine-App-Id-Alias:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=Ex3v+nUtspkWwmtwtRWmMReUEuTf1Kf0fPafU9skoAQ=;
	b=cCU6hsQmaS4QgtYA5hvYs+343RnZ7eR/ALaj907wP4FSBFpdD07g8jZIEfaC3lLo6ZIy
	 C6O+EqUB+kzo01aMX9B+bfHikWk7jvToKW0uG64kgvhphVIB7N/MHACK/vnn2fpWx8F7q
	 Hb6p1abCI9+5VQQS8cJ+PaHGhh1WgpQPFEo8+nzS/4P5smYb3CTLUcJspb/4jmzPMc0XG
	 IXOF1zM4jZmC1FGYwY/bob9yCBokZOvBZZ0+9aIvPYAGoVHz4EnD7rwXWEvE/48G9573N
	 ON2avfuFg6tlg0l5V4moVIcHt46FaBIp+H3q0GfuIzC2GYfU8TNFDJE9JK+jjOZskSw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=syzkaller.appspotmail.com;
	spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	arc=none smtp.remote-ip=209.85.167.198
Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com [209.85.167.198])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58C04606A31B
	for <syzbot@lists.linux.dev>; Thu, 22 Oct 2026 12:23:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 58C04606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f198.google.com with SMTP id 5614622812f47-4b28deb7ee3so2330592b6e.0
        for <syzbot@lists.linux.dev>; Thu, 22 Oct 2026 05:23:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792671797; x=1793276597;
        h=content-type:cc:to:from:subject:message-id:in-reply-to:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=Ex3v+nUtspkWwmtwtRWmMReUEuTf1Kf0fPafU9skoAQ=;
        b=rZKnABiffrPG+FhK3QqWfmUf8/BPm9G/RuzGE26cleL+2FlPd47fzpGNgkrnqmnM/u
         ciobcCrNuwzWBReG0D99FksZ5QqkstgwhHp3zVw0iz7KwQkgEa3PCaVFR9Qlso3PgWE4
         0zIGYcHOZbv2SZbjPR9A3Wc//C3kkHliGxBuXRSuzMPGqH3doiZvWcZhN/cUo9YkMmBZ
         U10pffoBsRvdJM7FZxZ6ZT4S8ZoViVO5uv2JAuTonUtJng/ySSouJNRO2EZAFOljp96k
         7LIy8rYckEv7xR9hFrO7hAFoqga9UC5tZvf8SkZxqP1pmppqD6MvQYc4SUY//Gi19Qtf
         T1Ng==
X-Gm-Message-State: AFq9FYLvVezeSsmXuUPbBXgZyegjfIJ0uXCNxnD6Cymr3IylUAD+ruIM
	iaiiRwH6X8aqX+iznA9ytjg/jg7DoDoxbFEMAmmRotq9ctGylOHGgR6GuIAWEje33hIZICDOuDx
	sbVGGFl/XhAg4DX3BqN4agBLrTeELyVq2dxC/0c7S44KSnwIm9GMujFtUsC8=
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Post: <mailto:syzbot@lists.linux.dev>
List-Help: <mailto:syzbot+help@lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
List-Owner: <mailto:syzbot+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-Received: by 2002:a05:6808:1645:b0:4b9:a8ac:480 with SMTP id
 5614622812f47-55357011b97mr3507709b6e.30.1792671797429; Thu, 22 Oct 2026
 05:23:17 -0700 (PDT)
Date: Thu, 22 Oct 2026 05:23:17 -0700
In-Reply-To: <20261022091359.1187468-1-krystianmkaniewski@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6ada0035.d1c214cc.659fa.00d7.GAE@google.com>
Subject: [syzbot ci] Re: usb: gadget: u_serial: pin ports while TTYs are installed
From: syzbot ci <syzbot+ci3a56453f83e593ee@syzkaller.appspotmail.com>
To: krystianmkaniewski@gmail.com
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v2] usb: gadget: u_serial: pin ports while TTYs are installed
https://lore.kernel.org/all/20261022091359.1187468-1-krystianmkaniewski@gmail.com
* [PATCH v2] usb: gadget: u_serial: pin ports while TTYs are installed

and found no issues.

Full report is available here:
https://ci.syzbot.org/series/527b6451-5a65-410e-a17a-7e4342ac8ec1

***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.
