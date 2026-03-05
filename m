Received: from mail-oo1-f70.google.com (mail-oo1-f70.google.com [209.85.161.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFC672868B4
	for <syzbot@lists.linux.dev>; Thu,  5 Mar 2026 09:00:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772701242; cv=none; b=l8uKUzcVEyx6N2tZG5Fvi+dx4y6KZnyEPvzDWVK0oXYjUZ/VBtecaYMW8PnhYu/D46Br4Ty0LP0cvdEQfb64Onr5ylC+KxxsKP18U48W3Je9xJAwiYo/gStkPk5ya2WexZ63a6xU+0/60zC5TA5A1UTu/HR0lpy7mz4Le5IqThE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772701242; c=relaxed/simple;
	bh=vtM0OZFx+A0wIV0RWr2pzdb5hwvTkVA4d4i73bOzE8I=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=emwzLckRDIz1133KOmOJwfiyig7na/KmAn9QtyvQEx2OtX0Bx+JkoGnT2pn0kmejSLJpjnLmlcuXCBJRBT6ARYn/x+xxqX1WePid+05awqHBNlOx5HFNEX8pIjIL0/iupjbRtPcYdPJMlsjnlNYkYeZ+M5mopLtVE7M1aKK2JNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f70.google.com with SMTP id 006d021491bc7-679caf7ec07so135483454eaf.1
        for <syzbot@lists.linux.dev>; Thu, 05 Mar 2026 01:00:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772701239; x=1773306039;
        h=content-transfer-encoding:cc:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JfVwjKGcoDvifgzXjqiQFl4iiHWSBwv8d9akSTOX1yM=;
        b=J8Jq/s8HvxLMk1UYgRgsSkSKRtBXnPJVD+Vcxy0pcC+eROKLuK+KpohRE+Iijk/XBD
         N7aDVD1xcXwZ2bXuDAtSjXuYmm8Ls76wWsaM89CSk6zUr+gsWVfSsLmKS0+i0QNLzXBv
         bWGFe5tbSUCUycemnZuVMCWS8xdrOuwHhElLZgZnHBBD/0vZItQX1CsjOYIhBIDEUSNC
         Q7QyJaZWPd8wGMps4sSClCFEyvxov+Jh06i557AzM13vKdWorBVRX+MEXy+4U2l4ma9U
         AnroxRDBHOBxy9se5cDx+Ply7FB+Y9K6BACR1HgqIJu2e8b33t+qPfHLvhE0GhNX/Xe9
         JWDg==
X-Gm-Message-State: AOJu0Yxj/WvINctRh0tIrMkUBGVAMQLL/4XOvpegLhID4Pc0W7EZpbl5
	yXlOY+H1vymSnj97WOPMDSUhyJyXvvWylnlU8tN4QlfJ4vq/8mMnUrpaXJGUMrZtHCLePzu96gT
	syQ9sTOgd7UVV0a3hGucLGubrT+x4aUN0wGZAoFwq+KYbrli3eb8cQQpHf7s=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:1b05:b0:65f:1012:69c5 with SMTP id
 006d021491bc7-67b1e924142mr2734012eaf.76.1772701239592; Thu, 05 Mar 2026
 01:00:39 -0800 (PST)
Date: Thu, 05 Mar 2026 01:00:39 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69a94637.a70a0220.2f119.0005.GAE@google.com>
Subject: [moderation/CI] Re: netfs: [WIP] Keep track of folios in a segmented
 bio_vec[] chain
From: syzbot ci <syzbot+ci9c12c63dd6fe3f46@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v1] netfs: [WIP] Keep track of folios in a segmented bio_vec[] chain
https://lore.kernel.org/all/20260304140328.112636-1-dhowells@redhat.com
* [RFC PATCH 01/17] netfs: Fix unbuffered/DIO writes to dispatch subrequest=
s in strict sequence
* [RFC PATCH 02/17] vfs: Implement a FIEMAP callback
* [RFC PATCH 03/17] iov_iter: Add a segmented queue of bio_vec[]
* [RFC PATCH 04/17] Add a function to kmap one page of a multipage bio_vec
* [RFC PATCH 05/17] netfs: Add some tools for managing bvecq chains
* [RFC PATCH 06/17] afs: Use a bvecq to hold dir content rather than folioq
* [RFC PATCH 07/17] netfs: Add a function to extract from an iter into a bv=
ecq
* [RFC PATCH 08/17] cifs: Use a bvecq for buffering instead of a folioq
* [RFC PATCH 09/17] cifs: Support ITER_BVECQ in smb_extract_iter_to_rdma()
* [RFC PATCH 10/17] netfs: Switch to using bvecq rather than folio_queue an=
d rolling_buffer
* [RFC PATCH 11/17] cifs: Remove support for ITER_KVEC/BVEC/FOLIOQ from smb=
_extract_iter_to_rdma()
* [RFC PATCH 12/17] netfs: Remove netfs_alloc/free_folioq_buffer()
* [RFC PATCH 13/17] netfs: Remove netfs_extract_user_iter()
* [RFC PATCH 14/17] iov_iter: Remove ITER_FOLIOQ
* [RFC PATCH 15/17] netfs: Remove folio_queue and rolling_buffer
* [RFC PATCH 16/17] netfs: Check for too much data being read
* [RFC PATCH 17/17] netfs: Combine prepare and issue ops and grab the buffe=
rs on request

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/34bae306-6b8c-4cb3-9042-755ab205d7ae

***

kernel build error

tree:      torvalds
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvald=
s/linux
base:      24d87712727a5017ad142d63940589a36cd25647
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp=
1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/d4138731-3994-4f14-bc07-1d9fd838655=
9/config

fs/nfs/fscache.c:275:12: error: use of undeclared identifier 'NETFS_RREQ_US=
E_PGPRIV2'
fs/nfs/fscache.c:276:22: error: no member named 'sreq_max_len' in 'struct n=
etfs_io_stream'

***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[axboe@kernel.dk ceph-devel@vger.kernel.org christian@brauner.io chuck.leve=
r@oracle.com dhowells@redhat.com hch@infradead.org leon@kernel.org linkinje=
on@kernel.org linux-afs@lists.infradead.org linux-block@vger.kernel.org lin=
ux-cifs@vger.kernel.org linux-fsdevel@vger.kernel.org linux-kernel@vger.ker=
nel.org linux-nfs@vger.kernel.org marc.dionne@auristor.com netfs@lists.linu=
x.dev pc@manguebit.com pc@manguebit.org sfrench@samba.org sprasad@microsoft=
.com tom@talpey.com v9fs@lists.linux.dev willy@infradead.org]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

