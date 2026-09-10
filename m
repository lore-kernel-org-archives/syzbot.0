Received: from mail-ot1-f72.google.com (mail-ot1-f72.google.com [209.85.210.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DECA3603C2
	for <syzbot@lists.linux.dev>; Thu, 10 Sep 2026 09:29:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789032589; cv=none; b=HGaUuprm8JQ7J/1IFvSxRasZA3x+Ie7BpGdSxm6f+qEHsY8WrM/6Ffxek13my7d7PscoepbQ/qnWIyk7kfiWygHoMe4d/cuaC9qvhS1WTb2VT+uiLxZX+hrsrDF78vBZI8o6rojlQp/Twjfk0/uprvisXAOquACC5Z69YZHSJio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789032589; c=relaxed/simple;
	bh=wnLkqRWjyvkd9HdhyYyqeosFFx4UNYsd19Du2P3N8II=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=ssxedGl1oRgiWC3BbWlS7FwNhxC21+MdfRqVGTtJXTJMDJJ08lK902L85TRmtonnvZt5AwS9aSZdxwQsQQsankDukogD/p+lpOYCjBJjLT0Fb6WZrqmMto/a5idvsha1s5MIx/PxJ9BieXUs9CikEfbhNMy5VdiQqirPi4JCqWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.210.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f72.google.com with SMTP id 46e09a7af769-7f1ddcd241aso316319a34.0
        for <syzbot@lists.linux.dev>; Thu, 10 Sep 2026 02:29:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789032586; x=1789637386;
        h=content-type:cc:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8h6oIBuaUz2xHhkrkuF2G2rwFFaf+TfiBtx1auYe4fQ=;
        b=pJnU254Z2Jr2Bjz78+0SxB0i/DVjJNe9Dls5gjdHoBeL6PcnuuxOqrijDmInTb7BmO
         vk0AX5pP3pdrcHj4FmEhCB19jhpmAV2EAHRzcZBpgSiQcSk4+HDe6s0dUhUPSSig8DiH
         6cMGVOJ/MnfFkkC3Jsi8KJijphIN9a6kdh6HWWR5h56cz9fYGYOOI5g6w6DQSA5zyEYe
         6U57nDoCWqhYNgcTgamXiDUJN6Stf03KdKDo8sFXTJ5rbKJSvMKyrz2G7yqTxq2sEnRx
         yu2Rufnp204/t5H/J8iSW1v1ns/XOBHUBIy+/sHUvymFlyHEG5JiowUxKmL4L3VZn+69
         purA==
X-Gm-Message-State: AFuF++mgU9msz9IwxE81bSD/zKiNwUmnLqfqEnxj/7v9PVAK7Qx5/0eR
	z9fRey46GhkscaJKDQ0hLfVllt5muEexJcNKf2yuV/0h51PWw9bgHQyLKCPDePwroIEiz9+873k
	2jwCdmzOzWv3dFt+PopSPoE8cb2G6yKHcwGEsoYh1cG9syBcmoUpE2g7geKc=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:2909:b0:6b9:9d40:f982 with SMTP id
 006d021491bc7-6b99d40fb59mr15343809eaf.61.1789032586409; Thu, 10 Sep 2026
 02:29:46 -0700 (PDT)
Date: Thu, 10 Sep 2026 02:29:46 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6aa2788a.6e6c5f9e.28f11f.002f.GAE@google.com>
Subject: [moderation/CI] Re: wifi: ath10k: Add missing validation in debugfs
 mem_value and reg_value
From: syzbot ci <syzbot+cif28a83f3687f414c@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v1] wifi: ath10k: Add missing validation in debugfs mem_value and reg_value
https://lore.kernel.org/all/20260910080659.20831-1-rivaldihormat@gmail.com
* [PATCH 1/2] wifi: ath10k: Add missing validation in debugfs mem_value and reg_value
* [PATCH 2/2] wifi: ath10k: Add missing validation in ath10k_htt_rx_proc_rx_frag_ind_hl

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/576ba9bc-1756-4f5a-9fa2-c13dc11f2a6d

***

kernel build error

tree:      wireless-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/wireless/wireless-next.git
base:      13e51269b6656768dc595ed6025e4974f2026543
arch:      amd64
compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/e53ca595-54df-4bd2-9bd0-df2488ec7ea6/config

drivers/net/wireless/ath/ath10k/debug.c:733:31: error: no member named 'reg_size' in 'struct ath10k_hw_params'
drivers/net/wireless/ath/ath10k/debug.c:830:28: error: no member named 'mem_size' in 'struct ath10k_hw_params'
drivers/net/wireless/ath/ath10k/debug.c:836:28: error: no member named 'mem_size' in 'struct ath10k_hw_params'

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
[ath10k@lists.infradead.org kvalo@kernel.org linux-wireless@vger.kernel.org rivaldihormat@gmail.com]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

