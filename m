Received: from mail-oo1-f69.google.com (mail-oo1-f69.google.com [209.85.161.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E17152C032C
	for <syzbot@lists.linux.dev>; Sat, 28 Feb 2026 08:31:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772267465; cv=none; b=dvIVS3HoVN7yv7Qhb4t3xHePkPl34rp4rowPYcjrvGrLnYoqdv/YSEHy7W2QCzjxxDMyRnEyAl2oJCNsz3v4qXIyNZxSOMMnJMQmuR/FmCFu09CbFoSwTyXNQNsyWD4nKs4qOj1WteZyiiVeps9JkZUtEyJffxl3+b0OwoOrbrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772267465; c=relaxed/simple;
	bh=7cEb9/yDyPxdRbqeXamVMiPDH9+omG0wH5unbhNTpnw=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=cEemJn5w9EyeQD4wPDwhaE2ZP0fq1zOiTqlgyY6KqRqHk+mmxhr2Sc7smxeG2VCOaPrLlIMuIR/gB3CxKnxDBcKxBbfDDBFrU039Z6y02X6LpPSW/SYW1SwTarBCwUo4/n72JJeLrFLDo/nUKO2Q/HFfYoLo+S0J7R4OUv1CxkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f69.google.com with SMTP id 006d021491bc7-679dcf1f680so74338055eaf.0
        for <syzbot@lists.linux.dev>; Sat, 28 Feb 2026 00:31:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772267463; x=1772872263;
        h=content-transfer-encoding:cc:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=R95RVc+PB33hif/h4hbYNs3/N0ymbNiSwF99hFv42Ro=;
        b=rbuvw5yodQFXa0rqpz0Ip/fXawiZm2vGQFNYOGYYRqBLlQgT+daBdqPQE13QyCJQN8
         W619vheENkcvKCxhb3Zwyd0x1vuDbOk2ZDo4QNktnf8OzKfov/7QcH6AN5RD7bbLFyHr
         rVo5YjKuXWi04o27kuUAOUplI0VMdKUWPRWu+9FryyHhA0ghH5k6EagOAHMYrsPXiBQc
         AWCoHtJL7iKRSA7st+lbwLaVALOpsm3YEIdMbjgUo2wvWBn/S65kL4qA4U/X6NU3Dz/v
         txcwEbQcbqCo2wXJyAslx/ibT22dFlrc6kAKGwx0vusHP9/+I2YcejBqMpbk9v3bojgV
         UAWw==
X-Gm-Message-State: AOJu0Ywm8+ZvOmXoa2UpQ8wcNO3dEyB0FSh+cpUGMFvD7h4A0hmPrcvu
	WSTj99pZaejMPMLO0XKpdlMrxUbsmbkWElpekoND1LXj8mitjW4hjZZl7SgcAvdDNdlb2LVgkY+
	z0lx4bq2BsNPgqiJ6ImA57QD/smVHoLSjOK1myRNVnak9orEyEFa2IivCm5Y=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:1794:b0:674:4a89:d824 with SMTP id
 006d021491bc7-679fadc26a0mr3750519eaf.2.1772267463008; Sat, 28 Feb 2026
 00:31:03 -0800 (PST)
Date: Sat, 28 Feb 2026 00:31:02 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69a2a7c6.050a0220.3a55be.0034.GAE@google.com>
Subject: [moderation/CI] Re: dma-buf: heaps: Turn heaps into modules
From: syzbot ci <syzbot+ci84ff29baaee05d85@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v2] dma-buf: heaps: Turn heaps into modules
https://lore.kernel.org/all/20260227-dma-buf-heaps-as-modules-v2-0-454aee7e=
06cc@kernel.org
* [PATCH v2 1/9] dma: contiguous: Turn heap registration logic around
* [PATCH v2 2/9] dma: contiguous: Make dev_get_cma_area() a proper function
* [PATCH v2 3/9] dma: contiguous: Make dma_contiguous_default_area static
* [PATCH v2 4/9] mm: cma: Export dev_get_cma_area()
* [PATCH v2 5/9] mm: cma: Export cma_alloc and cma_release
* [PATCH v2 6/9] mm: cma: Export cma_get_name
* [PATCH v2 7/9] dma-buf: heaps: Export mem_accounting parameter
* [PATCH v2 8/9] dma-buf: heaps: cma: Turn the heap into a module
* [PATCH v2 9/9] dma-buf: heaps: system: Turn the heap into a module

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/28e5882f-da22-4c59-97a3-07dd846ccd91

***

kernel build error

tree:      drm-next
URL:       https://gitlab.freedesktop.org/drm/kernel.git
base:      6de23f81a5e08be8fbf5e8d7e9febc72a5b5f27f
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp=
1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/230e0ba3-3d8f-4cf6-b713-a4a00b265dd=
0/config

ld.lld: error: undefined symbol: dma_heap_cma_register_heap

***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[akpm@linux-foundation.org benjamin.gaignard@collabora.com brian.starkey@ar=
m.com christian.koenig@amd.com david@kernel.org dri-devel@lists.freedesktop=
.org iommu@lists.linux.dev jstultz@google.com liam.howlett@oracle.com linar=
o-mm-sig@lists.linaro.org linux-kernel@vger.kernel.org linux-media@vger.ker=
nel.org linux-mm@kvack.org lorenzo.stoakes@oracle.com m.szyprowski@samsung.=
com mhocko@suse.com mripard@kernel.org robin.murphy@arm.com rppt@kernel.org=
 sumit.semwal@linaro.org surenb@google.com tjmercier@google.com vbabka@suse=
.cz]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

