Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87BAE3AA50B
	for <syzbot@lists.linux.dev>; Wed, 29 Jul 2026 19:38:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785353896; cv=none; b=iFU5HbkCmoXoonqLGu26DrOhBkp2LawEeGsN/XztNfMzCRfRFIB7pAKqQQE9bV8lJxrRwZwXfc9jbuuZBpQdSxzVsliHhLXr0m+Y3faSeo6Yuz0xgQkBajvXsSFJtGzSrzuIWjkn9bSHtmeAof/mE/t1xAEedlnf6zNdid4x1pQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785353896; c=relaxed/simple;
	bh=XwNgm9ATHQcGjGNk+lydH01xqpvPa6t/7xgikX+lowA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mGJru9O4d2E3e/gHbtNzOyBUhrjpk5ldb1fU1gcRCnVtugm0GHLgpNgh+onse4NeCQTr30gDIp5X4xAt5VvR7vaYTkQxGlkubiCKL3WgcqESoMkOf/ZwKy5dTL5RyMejm3tND90i447Z4Y1TGEaBVmwf3bkNh7naQYNm3BVSSs0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PyHnG4vZ; arc=none smtp.client-ip=209.85.216.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PyHnG4vZ"
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-381216921aaso1250050a91.1
        for <syzbot@lists.linux.dev>; Wed, 29 Jul 2026 12:38:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785353895; x=1785958695; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=fGQJH3HgC5JOXAIct0TTf3DXud55D/ZhU/Mkkd98GCc=;
        b=PyHnG4vZjtBc8LS/dUsiq6jzHh7Vt+xjrsYd4/BWrCxME9YWptS5yf+0PvWOwsio4I
         f/FPNWbHO8ktXWVr05uJZBGfP3A9wHzPIHZVsbps4Zv/Uj76QUFWLcnxL0oh8hdmTC5a
         hG+CbOQdUQd1BK+jeLhj1HgAs2dLIVOVlHBH8qSncP8jpwyd3iH7zaUH7o+Iu+Gq+OQx
         7vZgRCqBb+CmTJKfw9wNghC7wX1VCyBJ/5p+mqyB2mXWaz5DUIfu6vqR2bsSYWnslfN6
         9mvrLLCILPxhNPS3N3SnajHKF1R5QcobMoBNxRy87ZvShEBrO0EOe7dPEhuaDXbeC9ty
         IuFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785353895; x=1785958695;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=fGQJH3HgC5JOXAIct0TTf3DXud55D/ZhU/Mkkd98GCc=;
        b=roiCLJL/+4uISyOFX+1KqQUzHgbf4trqznd00IeMlaFEcK5Df1r9q+s427WHdCy7tG
         UJfoCLTFKthieYzE5cL1iRr9dDJSjVLwSRPdLq+fSYwMKOBxuOwVZfyEl5RjDpUPv747
         hDuZvv7Wykfm77f7nMoQo8kOtQL11L16/09wvuTviN3GQIcpFLXq4PBv675okzRJDti7
         1Kr1z0wK5km7vVZzHIzzGH8mbwAsvrjQszwMIDFyAOQtwVGBCTbJPsZ980k+R7HQjJMY
         odBDB1D+E7WWzeZlnJl3MAAvxB3injzyb6E1yENbNXY7jQyuXJhVetVQ/kgZwrtUplPq
         cYtg==
X-Forwarded-Encrypted: i=1; AHgh+Roo+n81LPtx0aJHb3aJrCVT/nN+EvxDJLVrR1Wq5GcLR23tJ9NUfxqHTLtZtNj28FFfhdy0kOo=@lists.linux.dev
X-Gm-Message-State: AOJu0YzYWfaQH+eTzECBlAkGtliVp4UHCf+wjx2/79ICJm2CdZukamHL
	INPXkEf2gNatIjw9SFhFfRr4MNZyRM5wRKwY/2QhM19Y7CWXAakiv0VH
X-Gm-Gg: AR+sD13bEwlDDBZFov7V477qg4Be+wx1OBPL+2DaY40SlHUxrLqbw6ghtX2tKMv/o9r
	IbT2nPYTO0uvV60WjvbM+FELsF7L1vDmspfXsbc7awfp5FEFbndWv4uNNiYwI6n2SPacdg8hQLt
	lwP6dDgysjLPrE+r4ZWYxRG/8i57sd5ArszUrIcrD4drZIDGeII6uNAh7vrhzZPK4BFD5GOzxjr
	AHQzUCb3fkyiNFmjn/h+7aiaFR+T6TplmjpEMUUu5UX6JEkERqbocKBDTmEJrHTK5KDoPI4coaR
	lU3FQ+vrFafyL95nHFLpgI2leYIGgBlw9VBb6m/9z21y8gaTWJtuJuBfgTkPySMPFmvnNYuZnBp
	Ja3bjiM9wVg1ER3YPv99LzD++S71KN/mCAjnAaq1IdKfGxmPzzAJhWtH6uH2tD4diGpe3iFePnJ
	JO9MbtWGjYOK/WnfnqEqnieFhx03ltQZVMoNxii89mt0AsrZZ0HvkFAQrpWjSQFqWQ
X-Received: by 2002:a17:90b:498f:b0:37f:9ce3:ca95 with SMTP id 98e67ed59e1d1-38f993843fdmr155523a91.30.1785353894717;
        Wed, 29 Jul 2026 12:38:14 -0700 (PDT)
Received: from Default ([2409:40f4:100c:ca91:db1d:88f3:514:9ded])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-31504927a7bsm14207721eec.0.2026.07.29.12.38.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2026 12:38:14 -0700 (PDT)
From: Jeffin Philip <jeffinphilip14@gmail.com>
To: syzbot@kernel.org
Cc: christophe.jaillet@wanadoo.fr,
	gregkh@linuxfoundation.org,
	kees@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-usb@vger.kernel.org,
	nogikh@google.com,
	syzbot@lists.linux.dev,
	syzkaller-bugs@googlegroups.com,
	tiwai@suse.de,
	Jeffin Philip <jeffinphilip14@gmail.com>
Subject: Re: [PATCH] usb: gadget: midi2: Fix null-pointer dereference in f_midi2_free_ep_reqs
Date: Thu, 30 Jul 2026 01:07:45 +0530
Message-ID: <20260729193746.313378-1-jeffinphilip14@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <cafe65f4-e1bb-46a3-901d-732814b861b2@mail.kernel.org>
References: <cafe65f4-e1bb-46a3-901d-732814b861b2@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Wed, 29 Jul 2026 11:04:54 +0200,
syzbot wrote:
> 
> From: Aleksandr Nogikh <nogikh@google.com>
> 
> A null-pointer dereference occurs in f_midi2_free_ep_reqs() when attempting
> to clean up an endpoint that was never initialized.
> 
> When configuring the MIDI 2.0 gadget via configfs and setting the block
> direction to SNDRV_UMP_DIR_INPUT, the initialization of the midi1_ep_out
> endpoint is explicitly skipped during the gadget bind phase
> (f_midi2_bind()). As a result, the usb_ep->card field remains NULL.
> 
> Later, when the host sets the alternate setting, f_midi2_set_alt()
> unconditionally stops both the IN and OUT endpoints by calling
> f_midi2_stop_eps(), which in turn calls f_midi2_free_ep_reqs() for both
> endpoints. When f_midi2_free_ep_reqs() is called for the uninitialized
> midi1_ep_out, it attempts to dereference usb_ep->card to determine the
> number of requests to free, leading to a crash.
> 
> Fix this by using usb_ep->num_reqs instead of usb_ep->card->info.num_reqs
> in f_midi2_free_ep_reqs(). usb_ep->num_reqs is correctly set during
> f_midi2_init_ep() and remains 0 if the endpoint was never initialized,
> safely avoiding the loop. For consistency, apply the same change to
> f_midi2_alloc_ep_reqs().
> 
> Oops: general protection fault, probably for non-canonical address
> 0xdffffc00000000ee: 0000 [#1] SMP KASAN NOPTI
> KASAN: null-ptr-deref in range [0x0000000000000770-0x0000000000000777]
> ...
> RIP: 0010:f_midi2_free_ep_reqs drivers/usb/gadget/function/f_midi2.c:1166
> [inline]
> RIP: 0010:f_midi2_stop_eps+0x28e/0x4d0
> drivers/usb/gadget/function/f_midi2.c:1246
> ...
> Call Trace:
>  <TASK>
>  f_midi2_set_alt+0x11c/0xf00 drivers/usb/gadget/function/f_midi2.c:1296
>  composite_setup+0x1ffd/0x3480 drivers/usb/gadget/composite.c:1933
>  configfs_composite_setup+0xbd/0x100 drivers/usb/gadget/configfs.c:1877
> 
> Fixes: 8b645922b223 ("usb: gadget: Add support for USB MIDI 2.0 function driver")
> Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot
> Reported-by: syzbot+bbb6dad313f4aaa8da6b@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=bbb6dad313f4aaa8da6b
> Link: https://syzkaller.appspot.com/ai_job?id=8ce30b1a-8cf7-4e38-bcf7-1f69e6f6313f
> Signed-off-by: Aleksandr Nogikh <nogikh@google.com>

Closes: https://syzkaller.appspot.com/bug?extid=01a17afb30637396955e

Thanks,
Jeffin.
