Received: from mail-oo1-f72.google.com (mail-oo1-f72.google.com [209.85.161.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 066933DEAE3
	for <syzbot@lists.linux.dev>; Tue,  3 Mar 2026 18:14:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772561694; cv=none; b=BZ7P+5ghweDAAmGEopCjX65prAhVLEUnB4iuGeiWRuwbdlCrb+XYS+2SVbD52K1pnfZXSNPpuqq85udU+/rVqT+BWevGTiB3G8dGS0D9/neF5x3ljlUqI/mYOgE88XXLjS9wtHx2c0SSFSsQeScuiBfh0wCbx2jmGt1xnP15eDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772561694; c=relaxed/simple;
	bh=GI5f/giDY5ENerWpc9+dcIeaozZgO+Mi/7ocJFozm8g=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=cbUnB/IKCEc3oIMpMoRkCX7K0aMu2S9sFKqBTOz+SIiEJV8envVmxmNoeg5bHtGN2rH53UxUpdMyKToHR8GOu4VyMyOC6vxEoQMPBG6eFmeh7zN/20Mh48vr4ZcQsniGr8sPv4k9RfvoW2dk+k4ESmUpMrRQ0+RwKbD730rQJhw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f72.google.com with SMTP id 006d021491bc7-679862e4413so100733336eaf.0
        for <syzbot@lists.linux.dev>; Tue, 03 Mar 2026 10:14:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772561691; x=1773166491;
        h=content-transfer-encoding:cc:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PWlyqtMGJgRM05NTTwWWBhMppSJWVRD1jqCekbNJ1l4=;
        b=UT9B7eUT15dqmD3xJ8Ix5iVFCk4VLk/Mk8lWD03Az4p0V0OPmg3xWOONEBlo7IxdWS
         qeky8nNyhBV4tY8ke8OmzDi/wd6RbtqltPW/YzSJFegd1XFDSgelbPUDY+ehn1SA/gWS
         8SYn+epxCnrvIJ31uSoVZeMmssZUeoM/4GCFNlztZv8iDr4qkggxKqFSSo4SPkksmMZK
         1FxrVFiE2jIfcb27FxDgGLMPxCn3W/9fNJwL1BZy4CPmGxo3ie2Qrp8zekIgW2HVFvrP
         ownqlKmEJ377lximr2doJLajqaqsOJmV18XkeA1dUbUmAMGKyyplmBNHsoagNmJpZpAu
         OYZA==
X-Gm-Message-State: AOJu0YxCb1/2i1jZNBXtnFV269RRJkPDYlaC7POWnvhyFTtM3BC8uM6u
	e9EupRWDfchdJ1ZPsmvcuP4t/SsMyGkjNAs3OD+fzvx0ejT7bbw9x+RzsoihzHb7Fz71Js1nMdH
	6NAJKnAZuKT2hEPQlQlefKm5vDYDn4Ebe4sWUASWJo2Efiq+ZYO3EHpA8nHY=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:16a2:b0:677:6162:9255 with SMTP id
 006d021491bc7-679fadbefd0mr10737690eaf.11.1772561690799; Tue, 03 Mar 2026
 10:14:50 -0800 (PST)
Date: Tue, 03 Mar 2026 10:14:50 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69a7251a.a70a0220.b118c.0010.GAE@google.com>
Subject: [moderation/CI] Re: dma-buf: heaps: Turn heaps into modules
From: syzbot ci <syzbot+ci03b986107b76ecbe@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v3] dma-buf: heaps: Turn heaps into modules
https://lore.kernel.org/all/20260303-dma-buf-heaps-as-modules-v3-0-24344812=
c707@kernel.org
* [PATCH v3 1/8] dma: contiguous: Turn heap registration logic around
* [PATCH v3 2/8] dma: contiguous: Make dev_get_cma_area() a proper function
* [PATCH v3 3/8] dma: contiguous: Make dma_contiguous_default_area static
* [PATCH v3 4/8] dma: contiguous: Export dev_get_cma_area()
* [PATCH v3 5/8] mm: cma: Export cma_alloc(), cma_release() and cma_get_nam=
e()
* [PATCH v3 6/8] dma-buf: heaps: Export mem_accounting parameter
* [PATCH v3 7/8] dma-buf: heaps: cma: Turn the heap into a module
* [PATCH v3 8/8] dma-buf: heaps: system: Turn the heap into a module

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/c729cea7-f83d-4980-b558-0fb50872302c

***

kernel build error

tree:      drm-next
URL:       https://gitlab.freedesktop.org/drm/kernel.git
base:      17b95278ae6adb9ea5b801fcd2ae5d182448e99d
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp=
1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/378fb3b7-fbfe-400a-8a19-4420a99f0a6=
7/config

ld.lld: error: undefined symbol: dma_heap_cma_register_heap

***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[aesteve@redhat.com akpm@linux-foundation.org benjamin.gaignard@collabora.c=
om brian.starkey@arm.com christian.koenig@amd.com david@kernel.org dri-deve=
l@lists.freedesktop.org iommu@lists.linux.dev jstultz@google.com liam.howle=
tt@oracle.com linaro-mm-sig@lists.linaro.org linux-kernel@vger.kernel.org l=
inux-media@vger.kernel.org linux-mm@kvack.org lorenzo.stoakes@oracle.com m.=
szyprowski@samsung.com mhocko@suse.com mripard@kernel.org robin.murphy@arm.=
com rppt@kernel.org sumit.semwal@linaro.org surenb@google.com tjmercier@goo=
gle.com vbabka@suse.cz]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

