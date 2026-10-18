Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com [209.85.167.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 888453DB337
	for <syzbot@lists.linux.dev>; Sun, 18 Oct 2026 17:48:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792345708; cv=none; b=ev4DCu0rrP4DkD5tX9SfWekDl0UtvfLAHwr/nrRx9S42toGHM7ZhttKsAB1otAj1hDg7MUnu9BBerdQ/3KMVpt+CdOmaVHSFWFvYucoYRkbDH8jItUkBM7f86rJ476CxYzg7GQRKveZj/HMtOUDdLM5r+zResGEIedcItVLez8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792345708; c=relaxed/simple;
	bh=7rQa7rdfErAGWaxQQi64Jh/b7eLyL1isnKpyVN4Xfko=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=nnhyf+67cGIjOkclgal46I52M5Y8dzz4zdfs01KNPLWx12y5sDXh1s1m75i/h4lVXE5uF8zdfUqJtbZzoeoBwGHZdS+04R5FQSRv6ZIvhiuj4QAx2obLs7bJUV67gvTln5OAVm33rUPT7RNlo+ax7EhggdhCK9CrlD75WKNuClM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f200.google.com with SMTP id 5614622812f47-4e937c5bd4fso1807274b6e.2
        for <syzbot@lists.linux.dev>; Sun, 18 Oct 2026 10:48:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792345704; x=1792950504;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:date:mime-version:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=bgXMcMdcc5Fki3QNx1JrlNz3qi+WiSYDJxX7Opn3+9k=;
        b=z5sCeoI1OaKSQSlXwnVqwWV2d4d8jefH+SFxTL3UBSJE75FKb1l0NPiGDmRto+LFKZ
         Sl0t84u148PqZ9xwGQDBu/R+q5cyhbJ1o2aKsCeckcLdUmoUU/OHbTu2yamc7WNaQc86
         bXXLfcWQztm2qoykdIvF1AYQSzbP/ZDqbBPUFvBC+uvPcMFyOM8fll4SADRZZ8jr69Id
         SJyihmpRJYPriJCSqmwjo0NLmuZEOdw7Me/hUrJ8ICfP+WWLZr++VWBeAKS+6Xs/o12Y
         hpU8qPTJRMwkzDfA/vwNbO4UCcSsTsZir5fEfmbNJd3lha0U01/Yjwz+CBUW63NK/5Em
         BBFw==
X-Gm-Message-State: AFq9FYJpGqqZvlKq0v9vDGV2/hJ9h3pUNBjZZ+9zWYQvUJSRSbqKDjhK
	9Onc6d9fAsOiyNYnCp3rV2XvS9DAe/yIuTxjTsdj78UM1lmMhlPuvt7Wo4hZSu2fb1yNu9VY5td
	KVv7JwBmbI9e9mha9se689NF8uAl25/TkCPMEyOGW1cfUFeU53bR5vs7tC18=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:6808:b0:4c3:a091:52f9 with SMTP id
 5614622812f47-53cc3e3c6a7mr5084041b6e.2.1792345704130; Sun, 18 Oct 2026
 10:48:24 -0700 (PDT)
Date: Sun, 18 Oct 2026 10:48:24 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6ad50668.7f4e89eb.3d59aa.00b6.GAE@google.com>
Subject: [moderation/CI] Re: kallsyms: optimise symbol search by name
From: syzbot ci <syzbot+ci0f5f89ea9f7f1dc5@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v2] kallsyms: optimise symbol search by name
https://lore.kernel.org/all/20261018155206.132411-1-david.laight.linux@gmai=
l.com
* [PATCH v2 next 01/15] kallsyms: scripts/kallsyms.c: Avoid overrunning on-=
stack buffer
* [PATCH v2 next 02/15] kallsyms: Fix selftest startup delay
* [PATCH v2 next 03/15] kallsyms: Improve selftest test_perf_kallsyms_looku=
p_name() output
* [PATCH v2 next 04/15] kallsyms: scripts/kallsyms: Check for output file w=
rite errors
* [PATCH v2 next 05/15] kallsyms: Match compressed tokens on the fly during=
 binary search
* [PATCH v2 next 06/15] kallsyms: Optimise symbol name search
* [PATCH v2 next 07/15] kallsyms: Optimise detection of duplicate symbol na=
mes
* [PATCH v2 next 08/15] kallsyms: Support changing the density of the kalls=
yms_markers[] array
* [PATCH v2 next 09/15] kallsyms: Add a kernel parameter for the marker shi=
ft
* [PATCH v2 next 10/15] kallsyms: scripts/kallsyms: Rename some variables f=
or clarity
* [PATCH v2 next 11/15] kallsyms: scripts/kallsyms: Keep full expansion of =
tokens
* [PATCH v2 next 12/15] kallsyms: scripts/kallsyms: Optimise compress_symbo=
ls()
* [PATCH v2 next 13/15] kallsyms: scripts/kallsyms: Reuse tokens that have =
no references
* [PATCH 14/15] kallsyms: scripts/kallsyms: Reduce the output file size
* [PATCH 15/15] kallsyms: scripts/kallsyms: Improve compression by about 2%

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/b38c1cac-393b-482e-8fc6-3608acd56bbe

***

kernel build error

tree:      bpf-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/bpf/bpf=
-next.git
base:      cee9395acd8043be0644b25c34bfa86623f2b935
arch:      amd64
compiler:  Debian clang version 22.1.8 (1~deb13u4), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/125a8c98-5370-4a3f-8594-fda40dba54a=
1/config

timedout after 1h0m0s ["make" "KERNELVERSION=3Dsyzkaller" "KERNELRELEASE=3D=
syzkaller" "LOCALVERSION=3D-syzkaller" "-j" "48" "ARCH=3Dx86_64" "LLVM=3D1"=
 "bzImage"]

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
[akpm@linux-foundation.org andrey.grodzovsky@crowdstrike.com bpf@vger.kerne=
l.org david.laight.linux@gmail.com jim.cromie@gmail.com kees@kernel.org lin=
ux-kbuild@vger.kernel.org linux-kernel@vger.kernel.org ljs@kernel.org mcgro=
f@kernel.org pmladek@suse.com rostedt@goodmis.org]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

