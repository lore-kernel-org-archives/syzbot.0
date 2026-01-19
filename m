Received: from mail-ot1-f69.google.com (mail-ot1-f69.google.com [209.85.210.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 235422571B0
	for <syzbot@lists.linux.dev>; Mon, 19 Jan 2026 07:36:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768808214; cv=none; b=Rgr//LyHEKaPmIXnBINodXIEYvs0vFS0pbttD+TjQMJW+u0DA8PNR/4sIyK6043+CQKrvY9v94boqD6qqihE7c4ROH+epVYwV2CG9Ilc0IsEjBJp9EJALAVChtgSu8Lg8fNWuCIEmXXsjf0wUQJ7o2B/NGQ1GDFpXUwDMswm/Wk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768808214; c=relaxed/simple;
	bh=HuUrOh/aZlJmGbsPUWkGbSeJNG0jkOM9n10Ak0nVLy4=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=D7CJQTQfLgNooSy3/RP9dZV4Zi3dhq/4keoaJ/mpf8eLxToMimj2sjBK93Z8//ycG3vgV0WVZFo2NHR4LWlgP9r4oewTSOeH6n1V0nBI7RC2BvOubL5ShfLKc48zMWXxdseSkya4EpDvCQsZRW0fK3fgHdpzeY5h3eX4YSC6zp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.210.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f69.google.com with SMTP id 46e09a7af769-7cfcc64fb5aso3525090a34.3
        for <syzbot@lists.linux.dev>; Sun, 18 Jan 2026 23:36:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768808212; x=1769413012;
        h=content-transfer-encoding:cc:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=58ugz7mDp3C1DxMVLVk5JvVtFXwk0YGsy5qOwlBysWs=;
        b=VRTzEstNHdv2IBYODTzjlb0PZmXddoEROhTW9eCJwXfD0rSkkC8GiW7nBQXd5ZLyom
         02UwIiMxt64L96NFsRHTdkFjuBSRXmkMj/RhcNrC7zwOo9H/Jg9wR1WQncZjwl3vWItd
         t0xkTpRT6F+YB9ZFS0YDQvtK5t8lfOF5xMedBREiwk/s7hNn3R16U/c/WGlm+tCNY5yp
         KPwJZRYR17BkG3ZfAbTl7cSBuI5V4VyxDSEVeD0g2NQtIajLn1GExb0XjRvFkmGtv97q
         fDK+sqpESu9ZbbhoiohDwOk54AHOApmPAhByeh+CVd4/2bUPVlQIKDf1al+e0iDwFLSn
         DTPg==
X-Gm-Message-State: AOJu0YzBSXe/M6D/IWICPMqc77ko6IPgbi69JeuKHfyPEbRA+ygkQ2oH
	ieQHpqWaCI2P6Bt9AyYQYGUu1oqlF6iBHk53uuU47oWRo0DOOoG1dfgM5+qjVEIAXPJ7qhvRCjJ
	OTRAYpU4Z/tHA0df1+AO4RdP4dmjrZLRpIAkPOxWnq9Q1hxWf++iE6l8eb6Q=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:627:b0:65e:f0f9:aa5f with SMTP id
 006d021491bc7-66117a11c24mr4723901eaf.68.1768808211770; Sun, 18 Jan 2026
 23:36:51 -0800 (PST)
Date: Sun, 18 Jan 2026 23:36:51 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <696ddf13.a70a0220.34546f.0421.GAE@google.com>
Subject: [moderation/CI] Re: mm/readahead: batch folio insertion to improve performance
From: syzbot ci <syzbot+ci6f93ead4dbeb73e2@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v1] mm/readahead: batch folio insertion to improve performance
https://lore.kernel.org/all/20260119065027.918085-1-zhiguo.zhou@intel.com
* [PATCH 1/2] mm/filemap: refactor __filemap_add_folio to separate critical=
 section
* [PATCH 2/2] mm/readahead: batch folio insertion to improve performance

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/18c2323b-a79e-49af-b87d-c7efb03f88c2

***

kernel build error

tree:      mm-new
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/mm=
.git
base:      ab43a28fc5b9faf53aa9e3210dcc0b5a0842e241
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp=
1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/4578b5ab-2df7-4d96-b41a-c357791c029=
f/config

mm/filemap.c:861:2: error: member reference type 'spinlock_t' (aka 'struct =
spinlock') is not a pointer; did you mean to use '.'?
mm/filemap.c:861:2: error: cannot take the address of an rvalue of type 'st=
ruct lockdep_map'
mm/filemap.c:941:3: error: member reference type 'spinlock_t' (aka 'struct =
spinlock') is not a pointer; did you mean to use '.'?
mm/filemap.c:941:3: error: cannot take the address of an rvalue of type 'st=
ruct lockdep_map'
mm/filemap.c:944:3: error: member reference type 'spinlock_t' (aka 'struct =
spinlock') is not a pointer; did you mean to use '.'?
mm/filemap.c:944:3: error: cannot take the address of an rvalue of type 'st=
ruct lockdep_map'

***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[akpm@linux-foundation.org david@kernel.org gang.deng@intel.com liam.howlet=
t@oracle.com linux-fsdevel@vger.kernel.org linux-kernel@vger.kernel.org lin=
ux-mm@kvack.org lorenzo.stoakes@oracle.com mhocko@suse.com muchun.song@linu=
x.dev osalvador@suse.de rppt@kernel.org surenb@google.com tianyou.li@intel.=
com tim.c.chen@linux.intel.com vbabka@suse.cz willy@infradead.org zhiguo.zh=
ou@intel.com]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

