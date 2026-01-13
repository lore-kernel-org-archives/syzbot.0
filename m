Received: from mail-oo1-f69.google.com (mail-oo1-f69.google.com [209.85.161.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6EF4299949
	for <syzbot@lists.linux.dev>; Tue, 13 Jan 2026 13:34:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768311294; cv=none; b=Mue6+Nx0YBdZ2WeJlk6G+X5t8PwqthS6oznrPcP51aiAfJ7H+isoh39gbhmpTctVsNR0/6ZGVYB2tfNHQPk0/u2HjaEl7VjCAvQc/Lhz196yC1wFMPV6tstF68Tnb7b5vceurH2LP1saaWVZktQYC79sLjoAbT3/WuooCSaYXq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768311294; c=relaxed/simple;
	bh=dvEzE81V3oBhCAUVKufQNSSJ6ec8XHVImfDiIZC7vpA=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=DiNI/BawZQyKEn60lKN77ldz6ojDhZbNIhM7gBS7IoUGcyi3xKkcLkPN1zl1R/hoGzg3MraL9Cg7NqAFsJuUTEt893g4aNkwdIrS7RLK9YyOqiBdSyLL/e7o98xfr8FUYYBlIpwjHbh/R4mH+ZvS1S5fJpeaq1Al6tNFD1GVZGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f69.google.com with SMTP id 006d021491bc7-65f6c6e6c3fso10396828eaf.2
        for <syzbot@lists.linux.dev>; Tue, 13 Jan 2026 05:34:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768311292; x=1768916092;
        h=content-transfer-encoding:cc:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Z/0HhOKGepVKraOdP1IRBIOygWDOmmd7O2EvJVKHWtU=;
        b=T9xF+Sr8LypZYNl3AwWWzuAKsILkzk9yg0dG2cJ8is0X7O8rBOsbUV5SdmW5WGgS7m
         /819GF2/tIG0ZOT7Xg8szNpi7h1gkIwkhbaezvLQ5XMmbQ3VyP3qDzW7ySMQTzsPg6W4
         wyMRFRMVj+1ZtrGOknbyRMmSI15Gg1X97gaSehD/QAbPTkykqJxtQcSoMrpvzDAsACMk
         g5Dgg2KQ4d2/OtwDn+N7qxltznZYemSs5xmwKNnDck24BQuYVwNAeE8Ax6KzLlQ81jv0
         d50EEhd/SGtOeo5dArkeYe+Y7QlFldB82yReB67x4XVOkgDv5eEZBcJsNxpZYPhmwvl9
         5Wtg==
X-Gm-Message-State: AOJu0YwjHgPO3mU4VxlgcuzORmhhjHViWUOcN4b+c2cTNIV+L6taSVZ0
	xW5HroMPNsO6N5zCu7iov4wrk5kw3rQwRgHTy7AKxO2fiKNYAsKoRSdlQtFscC/YoTVvhBdo32E
	qxtxVrq0Aw0lj2pb0vcYaVH+HZFnu/UUH45dUf8m8SDlDXf7C/MuNTxS9Dfs=
X-Google-Smtp-Source: AGHT+IFV1IC/ke6V+LTVRQvb9HouZy3qfgaW6iCOzvWRqh3Oh6vSJ+YOrkXOTB+42EiZjXxCJOkSErbQ6TKieM1qfaZFXr9EVcbQ
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:2289:b0:65f:6b62:1b6f with SMTP id
 006d021491bc7-65f6b622261mr6593179eaf.79.1768311291908; Tue, 13 Jan 2026
 05:34:51 -0800 (PST)
Date: Tue, 13 Jan 2026 05:34:51 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <696649fb.050a0220.3be5c5.0016.GAE@google.com>
Subject: [moderation/CI] Re: BPF-based NUMA balancing
From: syzbot ci <syzbot+ci1833856fd0cc9a23@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v1] BPF-based NUMA balancing
https://lore.kernel.org/all/20260113121238.11300-1-laoar.shao@gmail.com
* [RFC PATCH bpf-next 1/3] sched: add helpers for numa balancing
* [RFC PATCH bpf-next 2/3] mm: add support for bpf based numa balancing
* [RFC PATCH bpf-next 3/3] mm: set numa balancing hot threshold with bpf

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/63489828-86b0-4cf0-b097-51d3db6c9ba2

***

kernel build error

tree:      bpf-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/bpf/bpf=
-next.git
base:      9c1a3525fd64839d71e0c1a21170003a4621e6e8
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251202083448+f68f64eb8130-1~exp=
1~20251202083504.46), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/763a3f6b-2e7b-4dda-81ae-cef10b6e332=
7/config

mm/bpf_numa_balancing.c:151:10: error: call to undeclared function 'mem_cgr=
oup_get_from_ino'; ISO C99 and later do not support implicit function decla=
rations [-Wimplicit-function-declaration]
mm/bpf_numa_balancing.c:151:8: error: incompatible integer to pointer conve=
rsion assigning to 'struct mem_cgroup *' from 'int' [-Wint-conversion]
mm/bpf_numa_balancing.c:177:10: error: call to undeclared function 'mem_cgr=
oup_get_from_ino'; ISO C99 and later do not support implicit function decla=
rations [-Wimplicit-function-declaration]
mm/bpf_numa_balancing.c:177:8: error: incompatible integer to pointer conve=
rsion assigning to 'struct mem_cgroup *' from 'int' [-Wint-conversion]
mm/bpf_numa_balancing.c:197:10: error: call to undeclared function 'mem_cgr=
oup_get_from_ino'; ISO C99 and later do not support implicit function decla=
rations [-Wimplicit-function-declaration]
mm/bpf_numa_balancing.c:197:8: error: incompatible integer to pointer conve=
rsion assigning to 'struct mem_cgroup *' from 'int' [-Wint-conversion]

***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[akpm@linux-foundation.org andrii@kernel.org ast@kernel.org bpf@vger.kernel=
.org daniel@iogearbox.net inwardvessel@gmail.com laoar.shao@gmail.com linux=
-mm@kvack.org mkoutny@suse.com roman.gushchin@linux.dev shakeel.butt@linux.=
dev yu.c.chen@intel.com zhao1.liu@intel.com]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

