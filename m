Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com [209.85.167.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F59B3815D4
	for <syzbot@lists.linux.dev>; Tue, 30 Jun 2026 09:23:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782811430; cv=none; b=CbxCSMPVlCPdZoMtdgkt9r7HUhcMW2Lpg1WwqVdOt95v0qvNkiloXTB5tQEkuV+oW22UU8Yi6n6j7E6lZrD55gF6pW0EpRMQI0uJPNTP0U8zzpkhqSIXV6QFgLPW/6ZZeqAZzlPP89n0CZums39jOD2n8OUhGDfcP8lufLMOTh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782811430; c=relaxed/simple;
	bh=aqczyMpEG5BbZ598I8o/Wi9L5s+QEPdes93UA6gNdPs=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=excW8e55upPyGkBH5PQ0jQWjQ4JyrHnxikxA223nbD4FUJkjINI4MDEeyqkkrXWx0oGx66ZrouVgPcWrNI9tAop+WvA3h4+qQPhsrB6WQI56r32PKkm3A+H9nNebGjBj4GAVkUy+aTh94M2l4T8NephALCPO2LOmD3UiqxDb/To=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f197.google.com with SMTP id 5614622812f47-4893fc86bebso6422573b6e.0
        for <syzbot@lists.linux.dev>; Tue, 30 Jun 2026 02:23:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782811428; x=1783416228;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=t34TSfkiH4ytfaQmHSXYPoxFCM5arp0uf4f1vQVJqI0=;
        b=HTyYOqpPLYgZG3W0iOQXH5KdGZcJ0yu1znI/K8GJyeQyrb/2Cx0rt3xlrGztdkG1xS
         Qeh0ujLql+x4OPCOxuNeLZJlxvQeRLEcYr2Kyw67y0u4LDs62c6EtvWkQln0kt2WOfyT
         kWoMIyCOKY9JItUE48PGgbcCqd9Qtq4jd3Me5zw4g32X/zZFmlgHJ9l9hiejvKjC5BBH
         8/GQoHYrpNDYTp+X+5kObzM90yRRa2tRhuvAim4qrX5EWBBz5wlfVLZ1Po/au4Czorhg
         2KxDlq6ruoJFc5gV/m98NrKb0f58KtYIYFRPXrt/r78oeHYSxVMiu/a6bxdK9N4VzynN
         uchA==
X-Gm-Message-State: AOJu0YzksJ7DNe6LPOn5SATdlwglknfzc5YLe9Sf7teC0Easd0sqYBCd
	df5RVXHfJyiiht0fiS4Jt8nunUzihgtmPnOe0VpXeBbHdAg1pvOLU+wKw3PTljoPAEE4ZG4BciG
	w2GegxuxrL10aSgh1oZouKp8BMZg5Ag9Atobw5m7hwXETSZpGT9HON4q+CMs=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:4fe0:b0:490:9b13:e9cd with SMTP id
 5614622812f47-495eaf31d75mr2574075b6e.24.1782811428183; Tue, 30 Jun 2026
 02:23:48 -0700 (PDT)
Date: Tue, 30 Jun 2026 02:23:48 -0700
In-Reply-To: <20260630023443.3026627-2-sanghyun.park.cnu@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a438b24.6124255a.dd83.0009.GAE@google.com>
Subject: [syzbot ci] Re: bpf: Fix use-after-free on mm_struct in bpf_find_vma()
From: syzbot ci <syzbot+cid1a625374f9dbb34@syzkaller.appspotmail.com>
To: andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org, 
	daniel@iogearbox.net, eddyz87@gmail.com, emil@etsalapatis.com, 
	haoluo@google.com, john.fastabend@gmail.com, jolsa@kernel.org, 
	kpsingh@kernel.org, linux-kernel@vger.kernel.org, martin.lau@linux.dev, 
	memxor@gmail.com, puranjay@kernel.org, sanghyun.park.cnu@gmail.com, 
	sdf@fomichev.me, song@kernel.org, yonghong.song@linux.dev
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v5] bpf: Fix use-after-free on mm_struct in bpf_find_vma()
https://lore.kernel.org/all/20260630023443.3026627-2-sanghyun.park.cnu@gmail.com
* [PATCH bpf-next v5] bpf: Fix use-after-free on mm_struct in bpf_find_vma()

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/f0ce67c9-2c09-418c-bbe2-c698246e9c7f

***

kernel build error

tree:      bpf-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/bpf/bpf-next.git
base:      53435562a725962e4de0c29653223129ba11643a
arch:      amd64
compiler:  Debian clang version 22.1.6 (++20260514074242+fc4aad7b5db3-1~exp1~20260514074407.73), Debian LLD 22.1.6
config:    https://ci.syzbot.org/builds/a434cf48-2810-46a3-bb75-064be88b96be/config

kernel/bpf/task_iter.c:1017:3: error: call to undeclared function 'bpf_iter_mmput_async'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]

***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

To test a patch for this bug, please reply with `#syz test`
(should be on a separate line).

The patch should be attached to the email.
Note: arguments like custom git repos and branches are not supported.
