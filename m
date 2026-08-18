Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com [209.85.167.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0D292F1FF4
	for <syzbot@lists.linux.dev>; Tue, 18 Aug 2026 10:59:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787050778; cv=none; b=dEn1yLC7wUBj55jcDGoNSLvtQegVTnTQb2OcXVNP8xDUA7NzFoox9+MdNYdyyjkJSEv1jZGcxggvv+m4kObp5F2dL3Qmr4vsASxzIpmrH5b0NRmxlcqMZ1pk1/o91rbg9yOdJyPTfRCfBBNbMERL+HF31U66q7PuykiGTxGOC5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787050778; c=relaxed/simple;
	bh=2l3QVzeolST1KXj1m6ojH+9nTpWzlwUC4o82p5YV03M=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=Dk1c8uuu7iKBIBn3N/y3hAJoZmpg/fUNgbwrkELCWVPZknQ5rlhP3t1Sg++pEgjGaOgKUyBrz9keG3rDx1eOS6kRJJ6PXtWWaiasVJ/BWotozTr8nkHeHj2x/jEkFBnIdER1tEKKtrA8sID2SVew98Tc+p9M5M6ybwNm6KzmzZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f197.google.com with SMTP id 5614622812f47-4b1bd347d5fso4927825b6e.3
        for <syzbot@lists.linux.dev>; Tue, 18 Aug 2026 03:59:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787050776; x=1787655576;
        h=content-type:cc:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=MadyXl/pLeg5QpsO6+6I0sgYbH0IUt9XgczHHf5b2X8=;
        b=fs3UvLAhR901m5pte7CEMbOxB6SLbchKsZSMLFhH7JGRiRaTEMp+YAafhVyi8ptGoo
         LGTmpGUCzXDetEsc+WFqPAuhRYCnjoga4WS7heABHSD6YFpYBMPSJ2SUo84w0PhPGa5p
         DlJFq9ndyvqMWFaeiju1vPNOTtAuf8FvX7j0AvbOOQxfuwv1+sLMq21SlvkyikH21IbH
         xg0SpX/BX0upkUQv7vFkJb6kNvsfHmDLMq/VZYFpH28h3plZIiIzH8AsGBtx/ewyIMmh
         O10YTRk5GvL1yirh3QHlWEHhi7RX9cZwYrIGe7ykd/zsR4a+l2U17ZbrBDnYNPfM+bHF
         bh1g==
X-Gm-Message-State: AOJu0Yx6MegNqYnKzuuDkDDmec9b9G1a7F65q6G/HzHXQMjSvp1AGR2d
	kKbOeJK1UFrIZKBaxob5ABpRrACmXUBrfvqj9E84yxESgV8fLc9bWiBNO9mul0+nrugY2ttILef
	4yxN1zukZ1E+PZdlYtdgi/gEB8W7T7DZgqkUi7dMBq3Mj45ssCZWP/5EfpUs=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:200f:b0:6b0:1abe:5b01 with SMTP id
 006d021491bc7-6b11e31f84dmr5949526eaf.29.1787050775820; Tue, 18 Aug 2026
 03:59:35 -0700 (PDT)
Date: Tue, 18 Aug 2026 03:59:35 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a843b17.c8649fcc.3bb87.0004.GAE@google.com>
Subject: [moderation/CI] Re: bpf: guard classic uprobes against private-stack corruption
From: syzbot ci <syzbot+cic6d4650364926968@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v1] bpf: guard classic uprobes against private-stack corruption
https://lore.kernel.org/all/20260818095545.314358-1-simon@swine.de
* [PATCH bpf] bpf: guard classic uprobes against private-stack corruption

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/5af4a9db-80ae-4f3b-b927-c56b1321522d

***

kernel build error

tree:      bpf
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/bpf/bpf.git
base:      a13307e97d5c54b65720bb71fa379960ded1e51a
arch:      amd64
compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/37fdf0c7-1ff7-4d3f-b725-6f37b29b9f1f/config

./include/linux/bpf.h:2652:48: error: passing 'const struct bpf_prog *' to parameter of type 'struct bpf_prog *' discards qualifiers [-Werror,-Wincompatible-pointer-types-discards-qualifiers]
./include/linux/bpf.h:2653:32: error: passing 'const struct bpf_prog *' to parameter of type 'struct bpf_prog *' discards qualifiers [-Werror,-Wincompatible-pointer-types-discards-qualifiers]
./include/linux/bpf.h:2654:35: error: passing 'const struct bpf_prog *' to parameter of type 'struct bpf_prog *' discards qualifiers [-Werror,-Wincompatible-pointer-types-discards-qualifiers]
./include/linux/bpf.h:2668:34: error: passing 'const struct bpf_prog *' to parameter of type 'struct bpf_prog *' discards qualifiers [-Werror,-Wincompatible-pointer-types-discards-qualifiers]

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
[andrii@kernel.org ast@kernel.org bpf@vger.kernel.org daniel@iogearbox.net martin.lau@kernel.org simon@swine.de stable@vger.kernel.org tj@kernel.org yonghong.song@linux.dev]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

