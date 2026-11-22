Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.167.199
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795319284;
	b=OOLLB7MtJCfzkYIGUv8KzJbBBgsgvDKy2jp+C2qxZQ+b70LbhxBKMxfyrlZBjhtIEB3R
	 y7pD6foEZ8JgywuTsm7SMyniCyKxyQd5f/pJn/Sm+nxmrEVPDkgmJ8oNKDDANEkbe6cJg
	 6rUja/O3JWofTgAhOTIUvGa6y/LEYp3p5GRNRdkQGwXrmEvr2X4nE5Io4w6S0kMaq9ljk
	 tdu+JHVn4qSaSrohW9J9jwvxyMEOi90KRElpPJuPyGw/njlQa9sNo/k6X8OOwgc2PBU6H
	 4xG6POgVyvJqyxrkEYYzKvsliySyy3E0LHmyEWE0DxohiyBpr3a2I4OjUsAoKoV7fNQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795319284;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 MIME-Version:X-Received:Date:X-Google-Appengine-App-Id:
	 X-Google-Appengine-App-Id-Alias:Message-ID:Subject:From:To:Cc:
	 Content-Type:Content-Transfer-Encoding;
	bh=zbfqw7+qUyq9teHDQnZ4a6O8CTkxA+XnF2WOslKyHX4=;
	b=FPIQo8CH45claj+LnzoKfBf9On0CuLAuFaPCOHyLCJdCK9yGuCa2fJROA0GQIg0PWJQu
	 cshhViAQyGeWmJh8Cmw4hVRMpjwYbLpGt7V5B6l9o0FLVzJtczLpOnGbpxReQcsFylvUo
	 b3JiJB+Mk7tV1ldIssqDO0cJ/ef/7x5YD+5U4Xdoede0uIgVjXfNgWRLikeKvvwyj/Vg5
	 2Q18q5wveqdhPymiBKS0w33Oc6IDu2T0K5UQLaUHXqLJ7BTW/tlC0NY7zXazNRghuIZFw
	 aE54tcEkQTUAXch+Aq7Qn9WMSOPqg6tWup9e7kk8AdKXLcdA6JS23amaGnuloE66nOg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=syzkaller.appspotmail.com;
	spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	arc=none smtp.remote-ip=209.85.167.199
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com [209.85.167.199])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA82C606A32A
	for <syzbot@lists.linux.dev>; Sun, 22 Nov 2026 03:48:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EA82C606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f199.google.com with SMTP id 5614622812f47-4a41f46d629so3371148b6e.3
        for <syzbot@lists.linux.dev>; Sat, 21 Nov 2026 19:48:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795319283; x=1795924083;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:date:mime-version:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=zbfqw7+qUyq9teHDQnZ4a6O8CTkxA+XnF2WOslKyHX4=;
        b=KtX4oDB6sO0VCZtSny3/LxUvYNNKKL9yDF5EQ0DoKVMExCe78NW1nASYNnbcl3QJQn
         PZeTc/kNUIFDtMpvBwY2srJFD5ZdCwP5emiH31UvNVNV6A77VGLjxJRO0v60vNgRazXf
         9qy6aoe0e+lVnO6q+5+z6H4vah2ySG6zThWNzCG9K/TEwTZRzM3YIxh1TZ2Ct+hF2TES
         iIrDOghdce2y7uthEoNsDIhk7y8On2dgcQyN13Mt7eZhC06H/uzB4Tv14gjIL3/DRjua
         9H8yK8IfPHpnjoqYThVm3xBz9RFp1SkJd24c84iooJ4+SLm8AZoYCCilMstx68dj/j/m
         yeGg==
X-Gm-Message-State: APuU4Z/hDgh1NVg73iCDPqbqBnnaNx+DcvyjyZy+FfXl/KoB37sNB751
	GtvEtq51c3k+7IQM991a2l+FDYTW57djQMJM9nUcO3fyXWwZniinhIFgIrrwJ2QlRTFAUc+20pT
	z0z9pLdKkOz4H+Yd1uP7N0qLylxAUP0xNj3FNDlN/b9qNRlSGeYerByp6HUw=
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Post: <mailto:syzbot@lists.linux.dev>
List-Help: <mailto:syzbot+help@lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
List-Owner: <mailto:syzbot+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-Received: by 2002:a05:6808:6d92:b0:56e:1e8c:7e42 with SMTP id
 5614622812f47-57a056c84edmr8265382b6e.6.1795319282847; Sat, 21 Nov 2026
 19:48:02 -0800 (PST)
Date: Sat, 21 Nov 2026 19:48:02 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6b0265f2.91c4c7f9.2424d6.0008.GAE@google.com>
Subject: [moderation/CI] Re: userfaultfd: assorted fixes (part 1)
From: syzbot ci <syzbot+ci1d33b535723bf070@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v3] userfaultfd: assorted fixes (part 1)
https://lore.kernel.org/all/20261117-uffd-state-fixes-v3-0-b617009d1a4a@col=
umbia.edu
* [PATCH v3 1/9] userfaultfd: use anonymous memory for UFFDIO_ZEROPAGE on p=
rivate file mappings
* [PATCH v3 2/9] userfaultfd: refuse UFFDIO_MOVE into a non-present huge de=
stination PMD
* [PATCH v3 3/9] fs/proc/task_mmu: downgrade writable migration entries in =
PAGEMAP_SCAN write-protect
* [PATCH v3 4/9] mm/migrate: warn on a writable migration entry with the uf=
fd bit set
* [PATCH v3 5/9] fs/proc/task_mmu: write-protect device-private THPs in PAG=
EMAP_SCAN
* [PATCH v3 6/9] mm/huge_memory: build the moved huge zero PMD from the des=
tination VMA
* [PATCH v3 7/9] mm/mremap: resolve uffd state when the context is dropped,=
 not during the move
* [PATCH v3 8/9] mm/migrate_device: do not migrate a uffd-protected zero pa=
ge
* [PATCH v3 9/9] mm/userfaultfd: check the hugetlb alignment of every VMA i=
n the pre-scan

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/a3101d5d-8274-4d7e-b5fd-8e1979fc69a3

***

kernel build error

tree:      drm-next
URL:       https://gitlab.freedesktop.org/drm/kernel.git
base:      601c30449c80926947d4820d50cec974687d1d11
arch:      amd64
compiler:  Debian clang version 22.1.8 (1~deb13u4), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/129807db-e647-48ab-9611-e947c7420d3=
b/config

mm/userfaultfd.c:3145:3: error: call to undeclared function 'userfaultfd_cl=
ear_ptes'; ISO C99 and later do not support implicit function declarations =
[-Wimplicit-function-declaration]

***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[aarcange@redhat.com akpm@linux-foundation.org amd-gfx@lists.freedesktop.or=
g apopple@nvidia.com arnd@arndb.de avagin@gmail.com balbirs@nvidia.com baoh=
ua@kernel.org baolin.wang@linux.alibaba.com byungchul@sk.com dakr@kernel.or=
g david@kernel.org dev.jain@arm.com dri-devel@lists.freedesktop.org felix.k=
uehling@amd.com gourry@gourry.net intel-xe@lists.freedesktop.org jannh@goog=
le.com jgg@ziepe.ca joshua.hahnjy@gmail.com jthoughton@google.com kas@kerne=
l.org lance.yang@linux.dev leitao@debian.org leon@kernel.org liam@infradead=
.org linux-fsdevel@vger.kernel.org linux-kernel@vger.kernel.org linux-mm@kv=
ack.org ljs@kernel.org lyude@redhat.com matthew.brost@intel.com mhocko@suse=
.com miko.lenczewski@arm.com mirq-linux@rere.qmqm.pl muchun.song@linux.dev =
nico.pache@linux.dev nouveau@lists.freedesktop.org osalvador@suse.de peterx=
@redhat.com pfalcato@suse.de rppt@kernel.org ryan.roberts@arm.com sfr@canb.=
auug.org.au stable@vger.kernel.org surenb@google.com thomas.hellstrom@linux=
.intel.com tz2294@columbia.edu usama.anjum@arm.com usama.arif@linux.dev vba=
bka@kernel.org ying.huang@linux.alibaba.com ziy@nvidia.com]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

