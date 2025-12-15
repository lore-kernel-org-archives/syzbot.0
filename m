Received: from mail-oo1-f71.google.com (mail-oo1-f71.google.com [209.85.161.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF0068C1F
	for <syzbot@lists.linux.dev>; Mon, 15 Dec 2025 10:09:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765793403; cv=none; b=Zo5D7mdyfh/XEvpUO7wSkcX73wB+GHD0ArV3KndlskEGRERrsD52fIQiZToqWENHWvLpqj42vGepVyFRGcorQHtAGIaPof/Ne0cn2AbDmun0cpAhPOGq6o0nr9I6xcB47KCF719t4lItOwZROni942n5jfnWSXy0H0/0sFXOVFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765793403; c=relaxed/simple;
	bh=gOruKoXOKBZSRWO7Sa6Ml3l0AVyj3uJYKjVHGhsGgLo=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=l+S3l39x6z+4vmP1TybXj4EWI99Ch7V0aGeKYeIrAaPSKH0pvrSkgawgL7Zu8e0jpCbI4KzLaEGL/yQZkGtDsIYAMdj47rP21MKol8+W1B0DR5lJPzW73KkUut9Hnpmu7JB9hF7ca4t7W0CuwzuL1Tg17gDgs31AzjAtFOKzx+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f71.google.com with SMTP id 006d021491bc7-65746235dd4so2583911eaf.3
        for <syzbot@lists.linux.dev>; Mon, 15 Dec 2025 02:09:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765793399; x=1766398199;
        h=cc:to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ph7rG4br0VDHnQe6FzY146eMyrMDhe52nO/P0v18DUs=;
        b=uM5jBVOQ4QElq1SOMkqCIFjf4jiSuo66yxllcV7WcsTMQi45+azOAeRkWMCy/8RNRE
         dF8boPfQmU6n0Cjk42bZGeVDhRVGUcEHWx+n8En2/nDG7nmuxsEpt43RlR3+Rn2DcU+9
         y6bg0xrArX8ykv97r12DaWb509G/wI77T+LQ+1T5RHgXwkDHUS25oxfo0JlhzJT/hzPo
         v7+h6ikJMgZ9jm61/+uWYLe+ZNds55NhaXsUAeKoLD5nFpqlF01YZxaWbxIxxQRTM4Ae
         ktoNivCVVRW8A8xes8ujP5H6SPVUP5Xn4aQIg6ohQJTGjRVgSOAXd6LTgwOu1hy/jddA
         8e3g==
X-Gm-Message-State: AOJu0YyCRFasZ2QmwYcsNVFL7mHnEgN6ivNPUjyCD+28MVNJsjjeXBPM
	QjipLwEIW99T93wsbKh8j91xYHjRTGU2FQt7ZYSjDh5EkMBRVRK7mjXVqLCpS+EolR0Rvy/hUX5
	UCaZYmtwV/biuAZIjOb82coIgJclWEoS5S+7gJgQtntcuWQE9RsbwwmCtUkQ=
X-Google-Smtp-Source: AGHT+IE8hs7JhF9YObXfnxqOpalL4u8hUubwCoTQKUPnKPCLoalF08ImhPOk8O9HPmgWh5d95uCSc1IHmjA8TmOR29/yo2j6DhxP
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:4c14:b0:659:9a49:8e7e with SMTP id
 006d021491bc7-65b4529e4c7mr4904104eaf.78.1765793398934; Mon, 15 Dec 2025
 02:09:58 -0800 (PST)
Date: Mon, 15 Dec 2025 02:09:58 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <693fde76.a70a0220.33cd7b.00f6.GAE@google.com>
Subject: [moderation/CI] Re: Improve khugepaged scan logic
From: syzbot ci <syzbot+ci25e9803aeb356e4a@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v1] Improve khugepaged scan logic
https://lore.kernel.org/all/20251215090419.174418-1-yanglincheng@kylinos.cn
* [PATCH 1/4] mm: khugepaged: add trace_mm_khugepaged_scan event
* [PATCH 2/4] mm: khugepaged: remove mm when all memory has been collapsed
* [PATCH 3/4] mm: khugepaged: move mm to list tail when MADV_COLD/MADV_FREE
* [PATCH 4/4] mm: khugepaged: set to next mm direct when mm has MMF_DISABLE_THP_COMPLETELY

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/6c67be4d-245c-468c-977f-a76d79039a9b

***

kernel build error

tree:      mm-new
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/mm.git
base:      db411a1da7e162908fd11d5d8780e1f9c7fdff65
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/86d1ae0e-f606-44a7-9c85-9e09254f0704/config

mm/khugepaged.c:2509:9: error: use of undeclared identifier 'SCAN_PMD_NULL'; did you mean 'SCAN_VMA_NULL'?
mm/khugepaged.c:2510:9: error: use of undeclared identifier 'SCAN_PMD_NONE'

***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[akpm@linux-foundation.org baohua@kernel.org david@kernel.org lance.yang@linux.dev linux-kernel@vger.kernel.org linux-mm@kvack.org lorenzo.stoakes@oracle.com npache@redhat.com vernon2gm@gmail.com yanglincheng@kylinos.cn ziy@nvidia.com]

If the report looks fine to you, reply with:
#syz upstream

