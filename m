Received: from mail-io1-f69.google.com (mail-io1-f69.google.com [209.85.166.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA6BE1397
	for <syzbot@lists.linux.dev>; Thu, 13 Nov 2025 14:59:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763045994; cv=none; b=d/fyhoYaHpqoNZzwjwrM3gPM9eYSaX21z6f7uu6Gp+s6BPKPF6IIwCCx+h+5uOKyrKEVc7TFCWmTcFwxH2DcG0S7ZBogolvYv5sDU47zI9AtoJMNAlznu+6fKBCruZNvwdkr7cR0uL3QKgM1UeStXxbU9qiHxKALR4u1NnPh75w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763045994; c=relaxed/simple;
	bh=0qk4jipGMYPaCztdkQbC5ty4pgQIjn0MEQ5Wtjr6LiA=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=BEtPtChe41T2+iPBmG5ovwSnLDY03BZZHJnMyENt//u4x998CoLayyxZsl9IJp6MKfTHI4MLCPnVh/54Mqs9x+UOtJfZYSkC4Kh5FotD08cx6Imd2FBNfpDh6M+cATsQ/H5Jd9Jm/+d0yWpyx5nXByRiP+sa5SBvxG/KYTZGPcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-9487df8723aso300089739f.3
        for <syzbot@lists.linux.dev>; Thu, 13 Nov 2025 06:59:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763045992; x=1763650792;
        h=cc:to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=PKSETZpeEzWVSwcIjj5YkK/NUIyAPnL535bKorkXcts=;
        b=hs/3Zp/o54XJJ3Xi8Hugy+m6F+umQK4ZF7OvyU9gFqX0Dv9z1oTmjxQZfmEjNB5Z1L
         3WWJtg5lQw4STgaMMie5LAO9uQlKDMTO4BRKCrRGEzQsWaXIesTd7+KrdK7i0YHI6zdY
         0tEuHt5F922vu1ymKtqaE3SM1Jhyjgc0ZOh7uUD7RrKytQJIQmWg0pKbRBOtsFEHL1uV
         FcGXCCOSmmZtj72npKwjTVEyXVfrvo9KHBqZxcT5gBMBvbM4fvuVeqTsJ1m3sn2t7XfD
         iHrFt3ZSr1MD+MNZ8bfuMRNAwkXEy5T2GflhL2JkI6bAcoSm00z2iLNXoHBsfycf2uqr
         f6fA==
X-Gm-Message-State: AOJu0YzX0OZECct+Y35JnHOdTV0U0U1TuII2sHBumAViiacrutvZay7c
	kfK5kWK8EAjZQWw5uNxSNHa4Y7CC0qQFpidDh/PTPlRDIthx34zdQn1gdo9m3AWDUW8fi59Bo3D
	reLvlLKw4EPYyOx7eUUla3uFMIbFV2PPHVnm0oo6on+ifsRWAI/RDod/Qcuk=
X-Google-Smtp-Source: AGHT+IG5LM/ZUjGv0ChveV/Hm8ZKqaliEjcXTvo2aZXmO1Lvfj2xa4TomnG7WigWyOt8hsB0hucWdxkn2315a69baRq+LucvAC73
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:2194:b0:433:2240:a516 with SMTP id
 e9e14a558f8ab-43473db18f6mr93888315ab.30.1763045991961; Thu, 13 Nov 2025
 06:59:51 -0800 (PST)
Date: Thu, 13 Nov 2025 06:59:51 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6915f267.050a0220.3565dc.002a.GAE@google.com>
Subject: [moderation/CI] Re: ovl: convert to cred guard
From: syzbot ci <syzbot+ci462f0453bcab1eba@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v1] ovl: convert to cred guard
https://lore.kernel.org/all/20251113-work-ovl-cred-guard-v1-0-fa9887f17061@kernel.org
* [PATCH RFC 01/42] ovl: add override_creds cleanup guard extension for overlayfs
* [PATCH RFC 02/42] ovl: port ovl_copy_up_flags() to cred guards
* [PATCH RFC 03/42] ovl: port ovl_create_or_link() to cred guard
* [PATCH RFC 04/42] ovl: port ovl_set_link_redirect() to cred guard
* [PATCH RFC 05/42] ovl: port ovl_do_remove() to cred guard
* [PATCH RFC 06/42] ovl: port ovl_create_tmpfile() to cred guard
* [PATCH RFC 07/42] ovl: port ovl_open_realfile() to cred guard
* [PATCH RFC 08/42] ovl: port ovl_llseek() to cred guard
* [PATCH RFC 09/42] ovl: port ovl_fsync() to cred guard
* [PATCH RFC 10/42] ovl: port ovl_fallocate() to cred guard
* [PATCH RFC 11/42] ovl: port ovl_fadvise() to cred guard
* [PATCH RFC 12/42] ovl: port ovl_flush() to cred guard
* [PATCH RFC 13/42] ovl: port ovl_setattr() to cred guard
* [PATCH RFC 14/42] ovl: port ovl_getattr() to cred guard
* [PATCH RFC 15/42] ovl: return directly
* [PATCH RFC 16/42] ovl: port ovl_permission() to cred guard
* [PATCH RFC 17/42] ovl: port ovl_get_link() to cred guard
* [PATCH RFC 18/42] ovl: port do_ovl_get_acl() to cred guard
* [PATCH RFC 19/42] ovl: port ovl_set_or_remove_acl() to cred guard
* [PATCH RFC 20/42] ovl: port ovl_fiemap() to cred guard
* [PATCH RFC 21/42] ovl: port ovl_fileattr_set() to cred guard
* [PATCH RFC 22/42] ovl: port ovl_fileattr_get() to cred guard
* [PATCH RFC 23/42] ovl: port ovl_maybe_validate_verity() to cred guard
* [PATCH RFC 24/42] ovl: port ovl_maybe_lookup_lowerdata() to cred guard
* [PATCH RFC 25/42] ovl: port ovl_check_whiteout() to cred guard
* [PATCH RFC 26/42] ovl: port ovl_iterate() to cred guard
* [PATCH RFC 27/42] ovl: port ovl_dir_llseek() to cred guard
* [PATCH RFC 28/42] ovl: port ovl_check_empty_dir() to cred guard
* [PATCH RFC 29/42] ovl: port ovl_nlink_start() to cred guard
* [PATCH RFC 30/42] ovl: port ovl_nlink_end() to cred guard
* [PATCH RFC 31/42] ovl: port ovl_xattr_set() to cred guard
* [PATCH RFC 32/42] ovl: port ovl_xattr_set() to cred guard
* [PATCH RFC 33/42] ovl: port ovl_listxattr() to cred guard
* [PATCH RFC 34/42] ovl: refactor ovl_rename()
* [PATCH RFC 35/42] ovl: port ovl_rename() to cred guard
* [PATCH RFC 36/42] ovl: port ovl_copyfile() to cred guard
* [PATCH RFC 37/42] ovl: refactor ovl_lookup()
* [PATCH RFC 38/42] ovl: port ovl_lookup() to cred guard
* [PATCH RFC 39/42] ovl: port ovl_lower_positive() to cred guard
* [PATCH RFC 40/42] ovl: refactor ovl_fill_super()
* [PATCH RFC 41/42] ovl: port ovl_fill_super() to cred guard
* [PATCH RFC 42/42] ovl: remove ovl_revert_creds()

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/0603abd0-5f0c-4739-8099-dce1a3b8ff9b

***

kernel build error

tree:      torvalds
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvalds/linux
base:      24172e0d79900908cf5ebf366600616d29c9b417
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/12ae2954-8155-4bb1-94ad-467c4ed2efbf/config

fs/overlayfs/overlayfs.h:441:1: error: unknown type name 'class_override_creds_t'
fs/overlayfs/overlayfs.h:441:1: error: call to undeclared function 'class_override_creds_destructor'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
fs/overlayfs/overlayfs.h:441:1: error: unknown type name 'class_override_creds_t'; did you mean 'class_override_creds_ovl_t'?
fs/overlayfs/overlayfs.h:441:1: error: incompatible pointer to integer conversion initializing 'class_override_creds_ovl_t' (aka 'int') with an expression of type 'const struct cred *' [-Wint-conversion]
fs/overlayfs/super.c:1565:2: error: 'cleanup' argument is not a function
fs/overlayfs/super.c:1565:2: error: call to undeclared function 'class_override_creds_ovl_lock_ptr'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
fs/overlayfs/super.c:1565:2: error: use of undeclared identifier 'class_override_creds_ovl_is_conditional'

***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[amir73il@gmail.com brauner@kernel.org linux-fsdevel@vger.kernel.org linux-unionfs@vger.kernel.org miklos@szeredi.hu torvalds@linux-foundation.org]

If the report looks fine to you, reply with:
#syz upstream

