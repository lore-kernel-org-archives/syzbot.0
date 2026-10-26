Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.167.200
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793044084;
	b=u5mKY8eSC7RkmmTD4P876a6JJXECntihHAlQRClxbAoGDvBNq+VFqh0slmGFhf+yXG0f
	 7dMDBhoQ0/86MXm4S7HlRY1Yo518hY2X0+SVKVYzbom0zWctywIeaTmenyFJK1dShRRZ4
	 TVgXBGeRMLHerpGlkgHq2qBzjMCfUrBkt6+IP+1JuExi9+kdA4abMc2+ZIFnJGRaX3WI9
	 A0FIG+kIRgvsqN1fdIPd64Q6MmliVJ2A592sqzVjl5XX768EUM07//s274aSeya7IK0+V
	 u9scimW+soCHHH+04+nKbzs891WUPkOrHK/eblQeyoZ9fLEFZe3a/m0CG2SL3fmNNLA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793044084;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 MIME-Version:X-Received:Date:X-Google-Appengine-App-Id:
	 X-Google-Appengine-App-Id-Alias:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=E2JGNrYJXNtv8IMgfKAs9PuJ7Kna9hV7KgKFRKdRTiA=;
	b=oixiV9orao/EbzRuOhYpg8yLDh+N4anqthwA56aGxAHn3cvscxBsEJvpV5+bb7ZjhG5r
	 Z395+/WO5I5O2ZyhHNTNCDyPpp7YKzVMRO5/4pD35hVAVD9krijJ0osVFE8rJh7Uso7Nm
	 HCB+5ED3fBoJ/Oo+NuVhkc/ISsHXJz3kkGuKSUpNXVASsmtlDYNjWpK9AogUIMsWz62gf
	 VC016pKl/bmw/5xyeN7dIL1bTD3Z9Wskkx4RZt/X0zW+MqpqD+px86pOOYsun56aYO9Ap
	 m6eFfQGZ/glQ458NKTUp7kD1Nubf/cPRenbq+SXzpflf8FGz3JGD8RNZ0/UeadYfRSQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=syzkaller.appspotmail.com;
	spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	arc=none smtp.remote-ip=209.85.167.200
Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com [209.85.167.200])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1719606A31A
	for <syzbot@lists.linux.dev>; Mon, 26 Oct 2026 19:48:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C1719606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f200.google.com with SMTP id 5614622812f47-4b37620eb73so5924594b6e.1
        for <syzbot@lists.linux.dev>; Mon, 26 Oct 2026 12:48:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793044083; x=1793648883;
        h=content-type:cc:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=E2JGNrYJXNtv8IMgfKAs9PuJ7Kna9hV7KgKFRKdRTiA=;
        b=IyzgOxVWs9YOYA9Q5putMxQfTDH80A4Qmrzmbo/chTHF9y2DjOa4GCDrDKk+o4HF7J
         ZQBGD7QZ86JdJreBQ2L5HJ1H6y8YIqMQhwT0p1UNsLCAAmidQbn8hDj6VxDIIpjFFbw7
         zbwAMB0iuic5gxL4/EJhIlMD8xuXiDPmtS+hXMMT6P7s0LU5j2tO62TmexFYDGOSGWzj
         mfFeXccXz/K23pl4BHyw1Y2GLuFRLu8oEyfEULmTakIFdOEmIduOvSTjw5p9ZNsFCXT9
         2lc/te9PXhxXJsaCRbaQ3AiuSRSvblJ59lItfg043GTwM88KF8m+zw6ym7GlxxvKVCpD
         UTlg==
X-Gm-Message-State: AFq9FYInWsX5sNKolP+LmUhHtCwaZ55KnvPcgMdWtTnngsc+MZUF7K8g
	vWwzvdJzqrgaR0MLjD7fvWWf7r8xBFNJOzASi+NNWKEqAF8T9SA6xStU+lzglhxE9YrvCBCLE/S
	E6olu/SGu4KCADYtkI0HkiJqFru/yE+0rzDmvGD03VZkhe6oEbViq/oxFGGU=
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Post: <mailto:syzbot@lists.linux.dev>
List-Help: <mailto:syzbot+help@lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
List-Owner: <mailto:syzbot+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-Received: by 2002:a05:6808:4f2b:b0:4f6:5279:5c89 with SMTP id
 5614622812f47-55c0026b905mr4801060b6e.47.1793044082784; Mon, 26 Oct 2026
 12:48:02 -0700 (PDT)
Date: Mon, 26 Oct 2026 12:48:02 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6adfae72.768774f5.3237ab.000f.GAE@google.com>
Subject: [moderation/CI] Re: net: Fix Hole-196 vulnerability by dropping
 unicast ARP/IP in L2 BMC
From: syzbot ci <syzbot+ci0dfcdc44ab9eadd7@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v3] net: Fix Hole-196 vulnerability by dropping unicast ARP/IP in L2 BMC
https://lore.kernel.org/all/20261026150539.1357037-1-starchang@google.com
* [PATCH net v3] net: Fix Hole-196 vulnerability by dropping unicast ARP/IP in L2 BMC

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/ee0be733-8410-476d-be92-1602ae89d8f4

***

kernel build error

tree:      net
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netdev/net.git
base:      d3c157b4cdffd14604c2d8435e279761c511bac2
arch:      amd64
compiler:  Debian clang version 22.1.8 (1~deb13u4), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/027a790e-c04b-4f75-90b1-1e89288623c1/config

net/ipv4/ip_input.c:483:26: warning: missing terminating '"' character [-Winvalid-pp-token]
net/ipv4/ip_input.c:484:1: warning: missing terminating '"' character [-Winvalid-pp-token]
net/ipv4/ip_input.c:483:26: error: expected ')'

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
[davem@davemloft.net dsahern@kernel.org edumazet@google.com horms@kernel.org idosch@nvidia.com kuba@kernel.org linux-kernel@vger.kernel.org netdev@vger.kernel.org pabeni@redhat.com starchang@google.com]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

