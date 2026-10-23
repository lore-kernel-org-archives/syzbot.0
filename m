Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.160.72
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792758168;
	b=x+B0VQJbWguLnBA03gcg7T1HR/VH0P42KOx3/ioFHaK6JmlfdtWLhVzRSvtaLZPtPsZM
	 4GtCLtr1uymN7Oa523ypZOAu58Nk7KdsXmB6XDPrFYlr9Vl93bK1w3N1pWGpaRu5tb4+i
	 c15NxA0CEnafZNTee1mtf9ataKHOVPSiAscyq+wfi6H6VsZ2u3VW4/KDxGU1M7TWpbfLZ
	 LwABs08Bn4V7zflJMlitUaXYzDCSVuazlaus+wNTXtae7K1dtr8ruQSklxOZ0V4sbYS4/
	 HUMtZcxXa8e5pjPeR+o7lD9YwxYcJAfgrtbkQC1rdYCmwZa0HUMww+XrGd8yHv59jwg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792758168;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 MIME-Version:X-Received:Date:X-Google-Appengine-App-Id:
	 X-Google-Appengine-App-Id-Alias:Message-ID:Subject:From:To:Cc:
	 Content-Type:Content-Transfer-Encoding;
	bh=5ySgMFKl6x4wtCDvBw5MhMaADaPEUXsvz4QxwWoLXIU=;
	b=aS+Jh0h+HBS8k5EDxMomaq94rv0fvZ9iRP4+n3/ngVBuHmghjXw/LXkGLcUR5/oxKEti
	 odGBBAa/60MJCIGiIhEKSgfHJ9QCDy6sFKIuXTolB8FoDfxoinwxEN3mWnHMWTjj/s16j
	 GCjYW2DMXYAcfCrKyFOQXIiq5Q97zjao350lM//wF022/lH0tssg+SYLpG4aDDy4efPd9
	 p28j2B3vzWyloIQmRV+xDtwUcihlY7oY/14ESyMLImUHkGBAC4nZ0VrbkWTNxhfaV+oXz
	 jJWT5UauPwy5+iV57yeDifc3kbDBtZLPPIwF1SyFObbvqO/Yarm/5ojOs5UP2I62Ufw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=syzkaller.appspotmail.com;
	spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	arc=none smtp.remote-ip=209.85.160.72
Received: from mail-oa1-f72.google.com (mail-oa1-f72.google.com [209.85.160.72])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39DD3606A326
	for <syzbot@lists.linux.dev>; Fri, 23 Oct 2026 12:22:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 39DD3606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oa1-f72.google.com with SMTP id 586e51a60fabf-492f39f29c4so920279fac.1
        for <syzbot@lists.linux.dev>; Fri, 23 Oct 2026 05:22:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792758167; x=1793362967;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:date:mime-version:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=5ySgMFKl6x4wtCDvBw5MhMaADaPEUXsvz4QxwWoLXIU=;
        b=EpMTQGqfr4/CwF9vQxA3X4sS23ZKlHM/CblfnXX1QbZWbmLL4emRgoKMrpF3zX5k3j
         VAoH4BACv32GoV6ScYJQ6X5dvySTSNMllA0RXtqYq07Kzk5ftjK4yC0qu7PcJvVe2EJA
         VHvwQc3DN4HPCCLuTkMghtitPmC/XVJ70xdAH0ISRky7sHeyh3odW3Hj8oub8PYRSp9E
         1PGw5dpO2I4BAsmo+ONRiCGj/TW8w1CbgZ+QyIUaIt3N/naTCxN8V+eqlCbbl6PeYhpr
         RF5JfzHJRE7gVYS4RSNUnrXffFIpQOIdUzAMknIelp+b1SD3onID0xhwcysr7upD88lA
         Jd5A==
X-Gm-Message-State: AFq9FYIoH+6Ao1gJeYvpvaiFab0YgepJlsYmOCQI09LeKP160dmhUyoy
	4tWmblehGaVheqyIPJ1Y95EwrRXYD2ie4a+RH1yuXRgW2sLdPq5pIVRNRme7/nh9FzaTGUMKw8T
	oGrXJDArZkDnwehBiUzZkAB1Ergus+HmjKhnKEYFCwV/8ZJzw9mdCiMMO8gY=
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Post: <mailto:syzbot@lists.linux.dev>
List-Help: <mailto:syzbot+help@lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
List-Owner: <mailto:syzbot+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-Received: by 2002:a05:6808:c213:b0:4e7:a404:92e3 with SMTP id
 5614622812f47-55be8303a14mr1096492b6e.17.1792758167265; Fri, 23 Oct 2026
 05:22:47 -0700 (PDT)
Date: Fri, 23 Oct 2026 05:22:47 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6adb5197.3ebfcf67.79b0c.25a5.GAE@google.com>
Subject: [moderation/CI] Re: liveupdate: Preserve tmpfs files across Live Update
From: syzbot ci <syzbot+cid215e48543b447a0@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v2] liveupdate: Preserve tmpfs files across Live Update
https://lore.kernel.org/all/20261022225035.377445-1-dmatlack@google.com
* [PATCH v2 01/10] liveupdate: Pass user argument to file preserve and retr=
ieve
* [PATCH v2 02/10] selftests: liveupdate: Add tests for preserve and retrie=
ve user argument
* [PATCH v2 03/10] liveupdate: Allow file handlers to mark retrieve failure=
s as retryable
* [PATCH v2 04/10] mm: Rename memfd_luo to shmem_luo
* [PATCH v2 05/10] liveupdate: Don't WARN if tracking a retrieved file fail=
s
* [PATCH v2 06/10] mm/shmem_luo: Don't make early retrieve failures permane=
nt
* [PATCH v2 07/10] mm/shmem_luo: Retrieve tmpfs files onto a tmpfs mount ch=
osen by userspace
* [PATCH v2 08/10] mm/shmem_luo: Allow preserving tmpfs files that are stil=
l linked
* [PATCH v2 09/10] mm/shmem_luo: Allow retrieving tmpfs files with O_RDONLY
* [PATCH v2 10/10] selftests/liveupdate: Add a test for preserving tmpfs fi=
les

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/2816c2da-cbb6-401c-a706-161071b40ae4

***

kernel build error

tree:      linux-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/next/li=
nux-next
base:      bd1ecbb61afefc6a8b876ccbc31e9228b44e9eab
arch:      amd64
compiler:  Debian clang version 22.1.8 (1~deb13u4), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/87530454-496d-4027-a57a-40856ca7f0f=
5/config

mm/shmem_luo.c:335:20: error: initializing 'struct mnt_idmap *' with an exp=
ression of type 'const struct mnt_idmap *' discards qualifiers [-Werror,-Wi=
ncompatible-pointer-types-discards-qualifiers]

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
[akpm@linux-foundation.org baolin.wang@linux.alibaba.com brauner@kernel.org=
 corbet@lwn.net david@kernel.org dmatlack@google.com graf@amazon.com hughd@=
google.com kexec@lists.infradead.org liam@infradead.org linux-doc@vger.kern=
el.org linux-kernel@vger.kernel.org linux-kselftest@vger.kernel.org linux-m=
m@kvack.org ljs@kernel.org mhocko@suse.com pasha.tatashin@soleen.com pratyu=
sh@kernel.org rdunlap@infradead.org rppt@kernel.org skhan@linuxfoundation.o=
rg skhawaja@google.com surenb@google.com vbabka@kernel.org]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

