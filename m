Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com [209.85.210.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA2944915A4
	for <syzbot@lists.linux.dev>; Wed,  7 Oct 2026 12:04:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791374691; cv=none; b=bbOLSPMowl6l6NyIzQhqp+6l/XWAHFXttKDx76nmsnbJIjt/SsnhCkt5+g6VJ+l5OX1w9oM/XR/4QQHefhM4Zv2Y6/Fgbs4sQmbHSfBF/V9y3xYDHmSEZ6eNRDDyWUue+i4dD0c0Syq4O7saZiK2YBhiUnyk6N6HqSFLhPO8F7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791374691; c=relaxed/simple;
	bh=MiR8aLPAqyZOcKZP3W0qkqXiVzODwPrhXGLgsYKxE94=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=mdn23Tqq8HVR/86Cc8OOzAuJgHmUPw9u9DJBeyYUyZMQ2VjH33Xoh9dKCbTp3xQPdA3UVcZWI6+fZsRnOevKHSWj6UxQx2Vq09iPgVyw7z+x/nOinxM+nRTnH38B5ZXvyUQFzuCPqAZIUpKFq6QmGXOErHZf+7znWmbCMgL3ffk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.210.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f70.google.com with SMTP id 46e09a7af769-80139a2495aso6703465a34.3
        for <syzbot@lists.linux.dev>; Wed, 07 Oct 2026 05:04:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791374682; x=1791979482;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:date:mime-version:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Y1ECL3KxhjdtfjSYvMuuZHqBZKdxidWEgT/kZxHWhn4=;
        b=B2RVqpX3bVhyrO3agrlkZu0EXOkNAGGKsdyyNSmKjBxDTRjWhq/aKT6Uq0neSFsgGJ
         SwNzrV5lvw444GXVesZmImwIpREnSUtbAnDjXcRSq6jkfwsOQaUHQsWvaf4VQU1Rx3+J
         4o4/DzslE/5yTQXQfULjZ5Os9pHlUg9sOkvTqEYWwmvXypCjeNYualAfBih0eOyxnyAk
         AMU2Qoi3GASVsOrnHjb4IUAnuTNqkHxd9KWhPXnkO1aoJPLaR07RY3prjf4KfTgd3ZCr
         3+8P1RwOW4XkS5ctOMnbKW/z3ByQro375CEKrpvOT6beyuQxzM58WhKPt1SmAQNjz62V
         Tg1w==
X-Gm-Message-State: AFuF++mKNHhKLKPjRJiRZm/eJFL2vw63OmkfwlGOGpCZHuTXAWI9TWB8
	FZdKPpQmvkeouSzdA1PdhVnfmIzHr5gQaIlHPBrPfO0khnu6sdsfz9Xh3d3V5DwCeL8UyLtv5pU
	0ymjltoy2Nbjyi+tuQowncstOgJLYzNWS5JqRDGfmp5anpisD5sAxZNUmzzw=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:6718:b0:4bc:be93:3506 with SMTP id
 5614622812f47-4fc426a98e8mr2182130b6e.3.1791374682538; Wed, 07 Oct 2026
 05:04:42 -0700 (PDT)
Date: Wed, 07 Oct 2026 05:04:42 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6ac6355a.d03902a3.74d6f.0007.GAE@google.com>
Subject: [moderation/CI] Re: Landlock: Namespace and capability control
From: syzbot ci <syzbot+cie6ccf05a5ef335ea@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v5] Landlock: Namespace and capability control
https://lore.kernel.org/all/20261007100255.1333386-1-mic@digikod.net
* [PATCH v5 1/8] landlock: Rename quiet_masks to quiet_access
* [PATCH v5 2/8] landlock: Wrap per-layer access masks in struct layer_conf=
ig
* [PATCH v5 3/8] landlock: Enforce namespace use restrictions
* [PATCH v5 4/8] landlock: Enforce capability restrictions
* [PATCH v5 5/8] selftests/landlock: Add namespace restriction tests
* [PATCH v5 6/8] selftests/landlock: Add capability restriction tests
* [PATCH v5 7/8] samples/landlock: Add capability and namespace restriction=
 support
* [PATCH v5 8/8] landlock: Add documentation for capability and namespace r=
estrictions

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/a9bdf7ae-b6df-4d4e-b631-f8271e9358b3

***

kernel build error

tree:      vfs
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/vfs/vfs=
.git
base:      548491e998e1b411eb3526b6615623a2756d9410
arch:      amd64
compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp=
1~20260613092250.77), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/eaeb5ede-e0d4-4eca-934a-028504b1e62=
c/config

security/landlock/ns.c:39:60: error: no member named 'ns' in 'union common_=
audit_data::(unnamed at ./include/linux/lsm_audit.h:81:2)'
security/landlock/ns.c:120:23: error: use of undeclared identifier 'LSM_AUD=
IT_DATA_NS'
security/landlock/ns.c:142:16: error: no member named 'namespace_init' in '=
struct lsm_static_calls_table'
security/landlock/ns.c:143:16: error: no member named 'namespace_install' i=
n 'struct lsm_static_calls_table'

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
[brauner@kernel.org corbet@lwn.net danieldurning.work@gmail.com enlightened=
@google.com gnoack@google.com ivanov.mikhail1@huawei-partners.com kernel-te=
am@cloudflare.com lennart@poettering.net linux-fsdevel@vger.kernel.org linu=
x-kernel@vger.kernel.org linux-security-module@vger.kernel.org m@maowtm.org=
 mic@digikod.net nicolas.bouchinet@oss.cyber.gouv.fr paul@paul-moore.com se=
rge@hallyn.com utilityemal77@gmail.com]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

