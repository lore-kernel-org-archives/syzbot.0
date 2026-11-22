Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.160.71
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795383024;
	b=XP/lbOgqbjqRIB3MVJINksZMbJa/61kz99hKJpy5Rm7s+1TWXFyQ0U6ZrBQKMj0oo58Z
	 Lgpb2tkQEE8x3XgCmsuVZepNrFXcliu7TBwr4c1hNpq2742Un3sMs6WwxdNVLY8gJqQiM
	 xb2undJM9VDID4AXT1T2bwAKwiNP+PGQfjr/im0c7QSxSkWNv744zpdVTl4YTT1qgsbKd
	 LM3Dcbb4/Di4XyKl1ADs/vyag1t6aqvwwKVCuiSFNYLzH9YLtf4tAFp+D7SWg4YC2iRH6
	 AB8NjbwVkngh/r+0jV1UksYnuD+g1p+ghkhLeiwiz7oV6qtgZfaWzZ+Qffaq/zqezYQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795383024;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 MIME-Version:X-Received:Date:X-Google-Appengine-App-Id:
	 X-Google-Appengine-App-Id-Alias:Message-ID:Subject:From:To:Cc:
	 Content-Type:Content-Transfer-Encoding;
	bh=Jyu/Wlipt/GwAy/tQiSfIsjYkjpvGdDQezMtZAHPmCE=;
	b=jjkN3A+KZFa5bGjLUPkJlrrYwTtPRXl/2tjtYcIQjjfonn3hoTnJuzPScSnaDnWEIgIX
	 qbT/CJrvSka/8pPnC9pyZ3hl49qGAJjGuT8ZOhASQSe1aBR9Ea3ek3HyZ9qbGXnnAuWTB
	 moCRjRl7rX6NZzpRmXQDSNDGttwwWHDOQPp2JSyK1YZUG8MH4+MnqmO5OnFZUh0rMQD9i
	 zJwH1oCRKbXaHH/mGr3tUvdeLMyc6ySZ9OdyvweXtIgo4GD107q14aQOOhAtrYIq5Yz7U
	 zs82jKtaGnZ1HdJy5rjNcOO1YPX2NK1Du5t4Xt48zhSKPNsiSEkFixbiF6Uafb12ZDQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=syzkaller.appspotmail.com;
	spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	arc=none smtp.remote-ip=209.85.160.71
Received: from mail-oa1-f71.google.com (mail-oa1-f71.google.com [209.85.160.71])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88CB7606A31A
	for <syzbot@lists.linux.dev>; Sun, 22 Nov 2026 21:30:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 88CB7606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oa1-f71.google.com with SMTP id 586e51a60fabf-4a72bcd6599so2181159fac.0
        for <syzbot@lists.linux.dev>; Sun, 22 Nov 2026 13:30:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795383023; x=1795987823;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:date:mime-version:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Jyu/Wlipt/GwAy/tQiSfIsjYkjpvGdDQezMtZAHPmCE=;
        b=iYgrq19HJ9FsaT1WaHZIH9vcSchtWSY1vOfwej21QBjJ7Ue/Cq/prSjzD/own5KpCt
         rP8Xns2D53EJQqZZ7D+itrjtap63bmkJAv+JHSQQCSEvzVo8niC9JiaaEWVkNsXZEpU+
         VkFTvL36hFAGLmic3qZGudPrGEymNNGS70bG2hCInNd6PQ/FZ47C4eVW9KMIXjop+8ep
         d+V/H9oQZgNRJpVL6JRjCgXRVKPEQ+14n8LkqXwUKScgLWj/R07lMlFUMx0MmZjLIKKj
         eIwY09phKju+v1S4ERyOd9v0KV3Qq3o2vjFD5stVICcJ3pn6o4fLMjM4U98dtmsqazqC
         aFnw==
X-Gm-Message-State: APuU4Z8ePfI4/ISbvH5Kukz7eT7K0rUMVV2MDAE8iCohFs7hT/vPyrE6
	Lxo51gf4vEMxOyYF69Yec7oEq71RT4yjLhvKAhr1ikBOlfXTBULPfrhryYMqNq/UoHGICUbx79s
	i4QYw7PX/xUiL3X9A0CjTXvuuYSywJ+tcj0ekAXoAFud94bDlZoeUsK/ZG0Y=
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Post: <mailto:syzbot@lists.linux.dev>
List-Help: <mailto:syzbot+help@lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
List-Owner: <mailto:syzbot+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-Received: by 2002:a05:6808:244e:b0:574:6f37:671d with SMTP id
 5614622812f47-57a056c81c5mr10691316b6e.5.1795383023532; Sun, 22 Nov 2026
 13:30:23 -0800 (PST)
Date: Sun, 22 Nov 2026 13:30:23 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6b035eef.91c4c7f9.2424d6.0012.GAE@google.com>
Subject: [moderation/CI] Re: rust: page: add page kinds
From: syzbot ci <syzbot+ci2f72dcb2c27f3747@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v22] rust: page: add page kinds
https://lore.kernel.org/all/20261118-page-ownable-v22-0-d63ff73f4075@kernel=
.org
* [PATCH v22 1/6] rust: page: add page kinds and make `Page` reference coun=
ted
* [PATCH v22 2/6] rust: page: add `from_raw()`
* [PATCH v22 3/6] mm/page_alloc: make alloc_frozen_pages() available outsid=
e of mm
* [PATCH v22 4/6] rust: page: add `Exclusive` page kind for race-free page =
access
* [PATCH v22 5/6] rust: page: add `Frozen` page kind
* [PATCH v22 6/6] rust: page: add slice access to `Page<Exclusive>`

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/95bcb9c8-1b27-47d1-9aa9-dc274c9eb2d0

***

kernel build error

tree:      axboe
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/axboe/l=
inux.git
base:      7475ea8b58616b33c04afb976cf0fbaad9dd63fb
arch:      amd64
compiler:  Debian clang version 22.1.8 (1~deb13u4), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/063c2aa2-c365-4183-977c-ec133249267=
3/config

error[E0432]: unresolved imports `crate::types::Ownable`, `crate::types::Ow=
ned`
error[E0405]: cannot find trait `RefCounted` in module `aref`
error[E0046]: not all trait items implemented, missing: `inc_ref`, `dec_ref=
`

***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[a.hindborg@kernel.org acourbot@nvidia.com akpm@linux-foundation.org alicer=
yhl@google.com arve@android.com bjorn3_gh@protonmail.com boqun@kernel.org b=
rauner@kernel.org brendan.jackman@linux.dev cmllamas@google.com dakr@kernel=
.org daniel.almeida@collabora.com david@kernel.org gary@garyguo.net gourry@=
gourry.net gregkh@linuxfoundation.org hannes@cmpxchg.org igor.b@beldev.am j=
oshua.hahnjy@gmail.com liam@infradead.org linux-kernel@vger.kernel.org linu=
x-mm@kvack.org ljs@kernel.org lossin@kernel.org mhocko@suse.com ojeda@kerne=
l.org rakie.kim@sk.com rppt@kernel.org rust-for-linux@vger.kernel.org suren=
b@google.com tamird@kernel.org tkjos@android.com tmgross@umich.edu urezki@g=
mail.com vbabka@kernel.org vitaly.wool@konsulko.se willy@infradead.org work=
@onurozkan.dev ying.huang@linux.alibaba.com ziy@nvidia.com]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

