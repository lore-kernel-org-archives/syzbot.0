Received: from mail-oo1-f70.google.com (mail-oo1-f70.google.com [209.85.161.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5FC522E406
	for <syzbot@lists.linux.dev>; Mon,  5 Jan 2026 20:52:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767646363; cv=none; b=txeNeIG4YJQHGX46ai3dz9tr+1rQbY5PJMMXfejptnvUTumuwLaTbGwnQZYoM9EgJ/yyndq6RaB3HYeIHIEFDX236LzHT5IWDqe+JRDklnihBa0jekp5W/L0fMhyxx8kbTdk4wNu4CbsnpLnO/EBG02SM5kQNrc8xB1b9pffBQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767646363; c=relaxed/simple;
	bh=PrlKhB5wtaPjM10jo2cVANy6LaMjrLSIkdZ+lkfZ8TE=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=KBN6baKHsS6cwrakqdb8KfwDjHEzdxnMv3gJSSnHXxqre/WMZrX1AaMnedwpiJtlLNCUEUtmAJKVLiO38RGXdEXFbz3fBfGAMuEtIPa7/HO1NQMKBX+iS/d6TZLwk4bCk0mqFesGsq4dZoHqqHIMXwMKu9U6eA/t44dBjqGZbek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f70.google.com with SMTP id 006d021491bc7-65d004d4e48so574302eaf.3
        for <syzbot@lists.linux.dev>; Mon, 05 Jan 2026 12:52:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767646360; x=1768251160;
        h=cc:to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=d49cHrIWxkwCksAKtsLWKpfUOq29bwTbxeORFfD9ACU=;
        b=C5mOK+DFswaW2TULDDuNBU7Mxh03kB3RlXZ5HcpDqoAkSQkKpDu4J7vtuRvdh8oAVq
         MvQPFUhdsxsAPVDGQP+Ph5gZVPhHYQcl+QX7g+nmadOUWuz8/01IKBau0fFB+NY93eX5
         hSQxS1oVHyOSxoP+o2E3QOVdshlp9zC3jXMff6UKWEyNZUyYamL9vs25Q1mVcaZ0eJMG
         iuRLtgFBTZRlTyEgNcCaMfuzZa4XM43jg6Hec4ccYGKeqztVNOSOIGDu7xFm7GlfBqD6
         ggN68lZr0gN+a1Wvnc2lBzlW21hy7hjd80lvOOFbHUM02kdQ2VgIswqvFdWahYTud6kX
         3jgg==
X-Gm-Message-State: AOJu0YygaGCW5lLhjHm31ie3JbXwpet1wfTOH8KrVVOjg8synIaIOkVb
	TCQDOzg90ySPfWmEH5AuiB+XYdzVMB0miJmsb3ZWzkmaVa74EahvAgtzofkllLjO7r69D+Fc/oF
	gmd7rl/jUeEM/dxIWXIDIBOywK9CPsj1BLeR9JtAWNuBq+Dxsu80saGdhGvM=
X-Google-Smtp-Source: AGHT+IEQw2VReHZb3SYibpZc+v+gx7CL13U4FHrD3Ov/SN7KXKG9S4FEBHT4xq4GDXkLqOpNgUjwm8VNMeDVoJYD1gMOTuWrMJye
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:2282:b0:65b:2944:731a with SMTP id
 006d021491bc7-65f479d335dmr447519eaf.16.1767646360398; Mon, 05 Jan 2026
 12:52:40 -0800 (PST)
Date: Mon, 05 Jan 2026 12:52:40 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <695c2498.050a0220.1c677c.0333.GAE@google.com>
Subject: [moderation/CI] Re: mm: vmscan: add PID and cgroup ID to vmscan tracepoints
From: syzbot ci <syzbot+cia4b487da94a3a29e@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v3] mm: vmscan: add PID and cgroup ID to vmscan tracepoints
https://lore.kernel.org/all/20260105160423.23708-1-tballasi@linux.microsoft.com
* [PATCH v3 1/2] mm: vmscan: add cgroup IDs to vmscan tracepoints
* [PATCH v3 2/2] mm: vmscan: add PIDs to vmscan tracepoints

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/659a6ae2-b1f1-4c9f-a9e9-af8acd8ec22d

***

kernel build error

tree:      mm-new
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/mm.git
base:      a6fffac6b4644300b515c9dfc9bdf41adca63256
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251202083448+f68f64eb8130-1~exp1~20251202083504.46), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/3002ee97-e40e-4a52-8c25-c178ebf7f32e/config

./include/trace/events/vmscan.h:140:4: error: call to undeclared function '__event_in_irq'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
./include/trace/events/vmscan.h:188:3: error: call to undeclared function '__event_in_irq'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
./include/trace/events/vmscan.h:263:4: error: call to undeclared function '__event_in_irq'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
./include/trace/events/vmscan.h:306:4: error: call to undeclared function '__event_in_irq'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]

***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[akpm@linux-foundation.org linux-mm@kvack.org linux-trace-kernel@vger.kernel.org mhiramat@kernel.org rostedt@goodmis.org tballasi@linux.microsoft.com]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

