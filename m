Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.167.197
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792590627;
	b=KJVQMESd6Bv1kGSEN2lrb8TJhXuXZS5alVPj+N16VagwIyeE2O27AumQ4qjVuL8zIFH5
	 ZG5F6Rv3pvXrANvxdBm2EW9ZA9jHGner6HdE8so5L6vaScAsFObdLjiF+LaPahtrIRicO
	 JJlKaNFwxheoXHUmbctjT7NtS+2FHVFHQtxfgxTi1qR1ASSfIcwFEG0zNI3ZV7kTdw0Ow
	 5lOOaK87n991ljcFGMHHJxiwej8IYzQTbpB7jZmDV/gh8aO8lgpiAqRKfJrys0VmJbPBU
	 iVL+eHNA99enY+W807l3fjCelo5joQRzm5oMNShAlr5u6YIjOoGp5hMBZWU695l9nhw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792590627;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 MIME-Version:X-Received:Date:X-Google-Appengine-App-Id:
	 X-Google-Appengine-App-Id-Alias:Message-ID:Subject:From:To:Cc:
	 Content-Type:Content-Transfer-Encoding;
	bh=YqXwsIuVHHgPFbpTbjaFhQFOWetJOCvYOYn5lXCbEAk=;
	b=DyGQZ+gxrZCKM7CVY6uw3k26fvz6o2jD6A7a0ZmM9mahUoQEGJXddvMsnah5dMPxsMGj
	 UIkLXtadX/B4gQzsMpiCmeP4A0cz5R7eiwYCknDOXO8NSKoQ+DYmkKeVxPiE/zWqc0hTD
	 qGClwefj0gh/BfDlidrhi1ZqChxu3C3khJFiRp08nh7hZGodE3cj+Fz3Qd9upHomg2BrO
	 DdIfd+QeG2u1ov4eRKGGmRQ8Bv1lg/K4uZlyUPJlJj0PKG5VV+mzWcXaLGgj/kwPXWcoy
	 8tnd5nTHO0F5XHprPD95poUAQKs/S0y9sw33fWUnNWGL2Fzq2IPxniFgMcoLUgdzFwg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=syzkaller.appspotmail.com;
	spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	arc=none smtp.remote-ip=209.85.167.197
Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com [209.85.167.197])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F2EC60A260C
	for <syzbot@lists.linux.dev>; Wed, 21 Oct 2026 13:50:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4F2EC60A260C
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f197.google.com with SMTP id 5614622812f47-4ab260600easo2338306b6e.1
        for <syzbot@lists.linux.dev>; Wed, 21 Oct 2026 06:50:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792590626; x=1793195426;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:date:mime-version:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=YqXwsIuVHHgPFbpTbjaFhQFOWetJOCvYOYn5lXCbEAk=;
        b=WKnoN+12dwvFqDs2zLmkWPSCRPdJ6Ds8qYgJ+LWk228iwDoS54DkZMcP7EqUTkR1LR
         8FjyLNw/a/OkDH9GLlvmqUyEs6MfhLA4afaVzrvtpC+UhB2+EwY+vWe6IoaY2j8BXRFZ
         cVPLOpciJ1+9z7c0N/wbWKDovz1N1PawCP3X57iEkuF2ckr1nJsUrUnWen9aQi0ad9qv
         UW3gnw7+8nClYRkao9uUO9fazLql3hMbUc1talxS/Ig+nWqSRFoPgaAa0CjhlsUp5856
         hSnzRh0QuVwo7S93I5L9ymoFJ5+yAb900GfmtD4MijhfWhjg2mU3EVnYq/E4RQHGYPgH
         10Ow==
X-Gm-Message-State: AFq9FYJPf6v7tgu0l7QIpKwfJ63enEs+cgw/lC2wr87olDrAwxGWAVex
	3nPLYXWXX6CPJVQnQiiA4Nb/IVcvV3Cu3eY34YEzbr9VJ0igPIMlyhYUk/h4NGoS5zDj9BiU6uH
	76+dLoFw8rzESdsVG9dassl1UX4dT+4OmRMd2+k5V2Dy29YFN2j8Ra1v7s/k=
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Post: <mailto:syzbot@lists.linux.dev>
List-Help: <mailto:syzbot+help@lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
List-Owner: <mailto:syzbot+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-Received: by 2002:a05:6808:c224:b0:4e6:76eb:b991 with SMTP id
 5614622812f47-54d950c7a3emr3095435b6e.29.1792590626219; Wed, 21 Oct 2026
 06:50:26 -0700 (PDT)
Date: Wed, 21 Oct 2026 06:50:26 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6ad8c322.297debc7.3b379c.0000.GAE@google.com>
Subject: [moderation/CI] Re: UUID and GUID user and group ids (*_r system calls)
From: syzbot ci <syzbot+ci4891a3a45469a242@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v2] UUID and GUID user and group ids (*_r system calls)
https://lore.kernel.org/all/cover.1792552161.git.jan.koester@tuxist.de
* [RFC PATCH v2 01/41] uuid: move uuid_t and guid_t into <linux/uuid_types.=
h>
* [RFC PATCH v2 02/41] uapi: add <linux/uidgid_r.h> for 128 bit capable use=
r and group ids
* [RFC PATCH v2 03/41] uidgid: add uid_is_legacy() and gid_is_legacy()
* [RFC PATCH v2 04/41] net: sock: read sk_uid through a seqcount
* [RFC PATCH v2 05/41] af_unix: keep sender ids in skb->cb only when they a=
re classic ids
* [RFC PATCH v2 06/41] netlink: keep classic sender ids in skb->cb
* [RFC PATCH v2 07/41] Bluetooth: keep classic sender ids in skb->cb
* [RFC PATCH v2 08/41] smb: client: use __kuid_val() for the unix SIDs of t=
he caller
* [RFC PATCH v2 09/41] uidgid: let kuid_t and kgid_t hold a UUID or a GUID
* [RFC PATCH v2 10/41] uidgid: convert between kernel ids and the ids of th=
e *_r system calls
* [RFC PATCH v2 11/41] fscrypt: show the whole uid in the description of us=
er key claims
* [RFC PATCH v2 12/41] keys: name per-user keyrings of UUID and GUID users =
by the whole uid
* [RFC PATCH v2 13/41] ublk: refuse unprivileged devices to UUID and GUID u=
sers
* [RFC PATCH v2 14/41] nfsd: don't hand out uid 0 for read layouts of UUID-=
owned files
* [RFC PATCH v2 15/41] SUNRPC: name UUID and GUID users to gssd as uid_r=3D
* [RFC PATCH v2 16/41] ecryptfs: hash daemons by kuid_hash()
* [RFC PATCH v2 17/41] quota: don't account UUID and GUID owners
* [RFC PATCH v2 18/41] fs: keep UUID and GUID owners off filesystems that c=
an't store them
* [RFC PATCH v2 19/41] cred: add the *_r variants of the get/set*id() syste=
m calls
* [RFC PATCH v2 20/41] groups: add getgroups_r() and setgroups_r()
* [RFC PATCH v2 21/41] fs: add chown_r(), lchown_r(), fchown_r() and fchown=
at_r()
* [RFC PATCH v2 22/41] arch: wire up the *_r uid and gid system calls
* [RFC PATCH v2 23/41] statx: report UUID and GUID owners
* [RFC PATCH v2 24/41] shmem, ramfs: allow UUID and GUID owners
* [RFC PATCH v2 25/41] uidgid: parse and print ids in their text form
* [RFC PATCH v2 26/41] proc: show UUID and GUID ids in status, accept them =
for loginuid
* [RFC PATCH v2 27/41] audit: log UUID and GUID ids in full
* [RFC PATCH v2 28/41] net: add SO_PEERCRED_R, SO_PEERGROUPS_R and SCM_CRED=
ENTIALS_R
* [RFC PATCH v2 29/41] signal: report the sender's UUID or GUID uid in si_u=
id_r
* [RFC PATCH v2 30/41] ipc: add IPC_STAT_R and IPC_SET_R
* [RFC PATCH v2 31/41] ext4: add the uid_r feature for UUID and GUID owners
* [RFC PATCH v2 32/41] ext4: let uid_r be turned on while the filesystem is=
 mounted
* [RFC PATCH v2 33/41] posix_acl: support UUID and GUID entries
* [RFC PATCH v2 34/41] ext4: store ACLs with UUID and GUID entries on uid_r=
 filesystems
* [RFC PATCH v2 35/41] Documentation: describe UUID and GUID user and group=
 ids
* [RFC PATCH v2 36/41] selftests: add tests for UUID and GUID ids
* [RFC PATCH v2 37/41] ovl: allow UUID and GUID owners when the upper layer=
 does
* [RFC PATCH v2 38/41] devpts: allow UUID and GUID owners
* [RFC PATCH v2 39/41] ksmbd: log in UUID and GUID users and map them to SI=
Ds
* [RFC PATCH v2 40/41] nfsd, nfs: carry UUID and GUID owners as their text =
form
* [RFC PATCH v2 41/41] Documentation: uid_r: describe SMB and NFSv4

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/89b2b873-9ea1-40a5-88ca-0f427c9de5f3

***

kernel build error

tree:      axboe
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/axboe/l=
inux.git
base:      24a19b953e2a3d0ea5a8c4951a0ab8f32720c907
arch:      amd64
compiler:  Debian clang version 22.1.8 (1~deb13u4), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/1702ff95-4e48-4182-9d0c-18d968407a2=
6/config

drivers/net/tun.c:2452:17: error: call to '__compiletime_assert_2155' decla=
red with 'error' attribute: Unsupported access size for {READ,WRITE}_ONCE()=
.
drivers/net/tun.c:3337:3: error: call to '__compiletime_assert_2179' declar=
ed with 'error' attribute: Unsupported access size for {READ,WRITE}_ONCE().
drivers/net/tun.c:3324:3: error: call to '__compiletime_assert_2178' declar=
ed with 'error' attribute: Unsupported access size for {READ,WRITE}_ONCE().

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
[arnd@arndb.de audit@vger.kernel.org brauner@kernel.org jack@suse.cz jan.ko=
ester@tuxist.de keyrings@vger.kernel.org linux-api@vger.kernel.org linux-ar=
ch@vger.kernel.org linux-cifs@vger.kernel.org linux-ext4@vger.kernel.org li=
nux-fsdevel@vger.kernel.org linux-kernel@vger.kernel.org linux-nfs@vger.ker=
nel.org linux-security-module@vger.kernel.org netdev@vger.kernel.org paul@p=
aul-moore.com serge@hallyn.com tytso@mit.edu viro@zeniv.linux.org.uk]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

