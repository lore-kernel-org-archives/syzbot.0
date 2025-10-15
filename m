Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8784D2FF666
	for <syzbot@lists.linux.dev>; Wed, 15 Oct 2025 20:06:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760558813; cv=none; b=UjzrGKgnf3V8QG0jXQzHeDsmzgbedG6tgepGLPblTvlq2a4xe3FHq8rvZW9D/tlU8vH6qBP4Db3MTWB46Jq/UhB7QXVNdbKeptFzw00V0E2C8+u4GHHXfhhjvngbzVjLnASYCpN3iJPeAFGPY+LwtNP719PISlw+Iw3nulgVEOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760558813; c=relaxed/simple;
	bh=9JZjQpckIUDZ44/4oxVFulJkfUi3Y7Y1cWJS2zRObco=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=HScZuEGKH/Ur5dKafhnvzm3ZwyryFswZQxpOXOM0qZcS+3ep6eYeyLIlfescnsyoJc7IE/V0DeXyz2Io/KRch4k9Fd8XYzk5pDq6o1eMV/Yl/QRDHnWbftLE36KXYM3uLRZqKUnpUZImQ5JUBW/M9jrWt9B7HKMP+IFQcBH4Tdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-430a73ebac7so60854265ab.0
        for <syzbot@lists.linux.dev>; Wed, 15 Oct 2025 13:06:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760558810; x=1761163610;
        h=content-transfer-encoding:cc:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DtMOXTzmlyqXzgemDiJeAcYVHKo8vsb96bt90FjFBtc=;
        b=wLmV3GzlYAPjrPCvIB69Fpuzmvo7UHnxvkEfS+HnDNrsLDwrp3RS1JBd5pznqykba0
         LlwLy2Heo6KsMloudpttZbMFnPyOkeD1GHBz86Xifv5qFxmJ3RqFJ7PmS6d2uEAEEThN
         zS0u4aXH5hDUmxgJ8qb+iJmsZ00i9dx4MOaIcA6zDkoDBZ1F7L4gDkeT5FhrziyHb0qC
         ZXX/efd7dlaQvbF4uS4Mg+c0XyWOjcvftCAF7cprvQZ+KZ1pMviGAyZedlsoV58HAE6D
         wgCzZ5PsuvWlQ1PpcWSXVhclmdnn4drkEiJM8O937IX5046cWrQJwm/ewJMPJymlFL4I
         flqA==
X-Gm-Message-State: AOJu0Ywhm4fDdVlI8a9zg2nh1Ruf2f6v0pPvuE48eY+BmzGdpyc9tZnP
	+UMRGKnq31Nc0zp8SS++lqNAxg5hBZiLTP/m7iQh/cuNhlMl8dIysNtFRe9pHlKHy8VHAJtsGBz
	FiZtvl69g4DT4wCgVYOSbQASfWi4TRXBMUV7E91p7NgnmOXqFt0FOlPe+210=
X-Google-Smtp-Source: AGHT+IFrf/vmkA4qT1utSTbXWsYOs6PuS3ux+iT3kblgmvLpiKzMN1frNAvkWmL6VPYi3V6Bh/t+Ci4tdleY2Yy7UMAayLIUXTvX
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:168e:b0:42e:70f3:4dc8 with SMTP id
 e9e14a558f8ab-42f873e4fd9mr326083725ab.27.1760558810615; Wed, 15 Oct 2025
 13:06:50 -0700 (PDT)
Date: Wed, 15 Oct 2025 13:06:50 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68effeda.050a0220.91a22.02e5.GAE@google.com>
Subject: [moderation/CI] Re: rust: replace kernel::str::CStr w/ core::ffi::CStr
From: syzbot ci <syzbot+cid3c52e67e9f5c428@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v17] rust: replace kernel::str::CStr w/ core::ffi::CStr
https://lore.kernel.org/all/20251015-cstr-core-v17-0-dc5e7aec870d@gmail.com
* [PATCH v17 01/11] samples: rust: platform: remove trailing commas
* [PATCH v17 02/11] rust_binder: remove trailing comma
* [PATCH v17 03/11] rust_binder: use `kernel::fmt`
* [PATCH v17 04/11] rust_binder: use `core::ffi::CStr` method names
* [PATCH v17 05/11] rnull: use `kernel::fmt`
* [PATCH v17 06/11] rust: alloc: use `kernel::fmt`
* [PATCH v17 07/11] rust: debugfs: use `kernel::fmt`
* [PATCH v17 08/11] rust: pci: use `kernel::fmt`
* [PATCH v17 09/11] rust: remove spurious `use core::fmt::Debug`
* [PATCH v17 10/11] rust: support formatting of foreign types
* [PATCH v17 11/11] rust: replace `CStr` with `core::ffi::CStr`

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/af2e031f-3a7b-43c2-828d-95c98148c564

***

kernel build error

tree:      torvalds
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvald=
s/linux
base:      3a8660878839faadb4f1a6dd72c3179c1df56787
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp=
1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/72c75c0e-85b8-4094-a4be-adf23f82bc8=
c/config

failed to run ["make" "KERNELVERSION=3Dsyzkaller" "KERNELRELEASE=3Dsyzkalle=
r" "LOCALVERSION=3D-syzkaller" "-j" "48" "ARCH=3Dx86_64" "LLVM=3D1" "bzImag=
e"]: exit status 2

***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[a.hindborg@kernel.org alex.gaynor@gmail.com aliceryhl@google.com arve@andr=
oid.com axboe@kernel.dk bhelgaas@google.com bjorn3_gh@protonmail.com boqun.=
feng@gmail.com brauner@kernel.org cmllamas@google.com dakr@kernel.org gary@=
garyguo.net gregkh@linuxfoundation.org jack@suse.cz joelagnelf@nvidia.com j=
ustinstitt@google.com kwilczynski@kernel.org liam.howlett@oracle.com linux-=
block@vger.kernel.org linux-fsdevel@vger.kernel.org linux-kernel@vger.kerne=
l.org linux-pci@vger.kernel.org llvm@lists.linux.dev longman@redhat.com lor=
enzo.stoakes@oracle.com lossin@kernel.org maco@android.com mcgrof@kernel.or=
g mingo@redhat.com morbo@google.com nathan@kernel.org nick.desaulniers@gmai=
l.com ojeda@kernel.org peterz@infradead.org rafael@kernel.org russ.weight@l=
inux.dev rust-for-linux@vger.kernel.org surenb@google.com tamird@gmail.com =
tkjos@android.com tmgross@umich.edu urezki@gmail.com vbabka@suse.cz viro@ze=
niv.linux.org.uk will@kernel.org]

If the report looks fine to you, reply with:
#syz upstream

