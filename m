Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B38C3B1ECC
	for <syzbot@lists.linux.dev>; Tue, 21 Jul 2026 20:43:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666626; cv=none; b=We9MAM0ZnbFvfsyFCoBAgbQRDVao16KnfQwgQaVpZZgyHtVSLPdCHb07mO5EOYdeJKLlQaVrlwt0oeEzeX5uSrlH0LvlnfWNEUB804m/pFVq9BbogOmPH2TowxI2dPcQE05HlMAQiMpBraEzOZ5XgIwpn/umOEXG9AShssGTc3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666626; c=relaxed/simple;
	bh=BOg2HzF54uH8nZkVKxFlhi6BAxqgO1Dr7mPrqd+Qzcc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LuobUXy+SQKGHpr8No36hmAKKxKORPbZZa24SWSYAhrN5pMt5iD0Rbh+tZzAirwbg79rPWxmpUd9llVLOvXJ2tJwCEBVCFccX7t0T4dt9gf2r/1HpP7g2Kl+ARzuF7dWETNGUV29EQe1vpS2czt0wK2FezXnDdZm1yCEiBs5Zgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PMl8kkN5; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PMl8kkN5"
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-c15ca7a7ca9so888615066b.0
        for <syzbot@lists.linux.dev>; Tue, 21 Jul 2026 13:43:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784666623; x=1785271423; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=O41E++T94a5c3mtgnazDz9EIqfVHij61z+g8YCR0B2c=;
        b=PMl8kkN5B6hDZjLN+xVXv9RACpV1Fg5MEzUy07/DJm3XVVJ8f8OKb+DPZwxHoy/5ze
         Z3Ip+E6Lp2ag1mg3fUNsnKsfnrH5q3oLhH02U2YthgnJrbj094edwZv5E0I+STqEEkDQ
         I1+1Mf11N9tdz9jT4eQbkq2tWCcWC1P94ofBd4U6y4sTK+jtDQAds5/yd6ic1VYSbmcZ
         Xxgw3CFYqEG0ESlDOcfx8nLQLA41/LQ5DohOLXcEBPuWdn1gzReqZnex8G0mjTkRPx9N
         1P7/cpeY9IInHsCpQlvKcfcv16UvV6/rtqCgWiS0NNKymXQBOZQpV78B/tf3MaPwjRWf
         y5FQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784666623; x=1785271423;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=O41E++T94a5c3mtgnazDz9EIqfVHij61z+g8YCR0B2c=;
        b=nKyYB/kMCt5oxVqOl9v1ebwz5N10yD/44IFUOH/bVnT9e3d84sudwZqvXBOWztlvDq
         hAYIcnJEMCJjf0E75qKs5cIRiIsl1xHJRVxSotP2EGj9u20Q3nyWeG/kCPLifIvkNhXk
         jaG1e+r0sHpYa1Qvk77rFUn0n4x6KJi9E7SbJdh29ZrHUhOMq9TPxyv3IVes7ndSAa0V
         jliN3hymqcGvwheX2T1xIB5/mKg+9bzl//mNelj33baiD1IJqsHecKrb4ASKoAE8VtKM
         19MWtYAXGPHJ49ggcM9qvCV37f/3ug5PBF9fhTlA19iohrx8WJjYMj2RV5Wr4fNaiFKa
         GOjA==
X-Forwarded-Encrypted: i=1; AHgh+RqdQ/fRBml8uwS5CSsv72IeaPdJRWx2hxMtLoXJRrzjQs6dv1h95Yd2ZCqjLF1mMtw8EsihtOI=@lists.linux.dev
X-Gm-Message-State: AOJu0Ywjp5RFAMNXoJ/6wuWTShyg9Nq3a6slwEqXLt0kI3BwXxZvrgN5
	3k/gCEePWHlFiIfkcguDTkpg/QuxsuzaqKbE193oqxiEuDTR8WFA3gKx
X-Gm-Gg: AR+sD11t0tfOYBC0UUu9MEd2LYq98ISILeirCSNb3RVYxPRw5/hWo/f5OhzGMTaxpnd
	fZN5ZvrtGPlouToYJvy34y6I/9IqXnH/fV7UH2avI3DttqLZJBV2PPl1vim7snOkaZTZ8tjwW+E
	NOqTZnXl1l/etx14PO0cK4RCjESHvwP6y7cis4dDGMoL+B3Yu0xOuQBOJ51oQSkCexiaotI1JaA
	BS/G6pZdBB+DDk8/OwbxzSIPLn7jPc+xw12bbko2MQ4fZm2ecZiSmbTWXijL03svGQhqXFqQWaK
	LMzpjSijVPM7eY+m+/HxTBgTW+Sk2V03dj+axdBKzUHG+HuzW6mO7RHNGDdojzj7d2WjGyeUYTU
	bEkEof0avWrhKtoM83RQgUapg3HKiScnJoSos3lML2BVfmdcXJwXRJKhjAuDPt0Q7Px//7EG5n0
	q4za++BOAc7NCSLyJVnkJxR0aXCMETz7qt3iH3unWQWUckpxvnMwIFHY/qZTVtn7mIHh+3hyzzu
	E01K4CZOXNh+FM9rog9miD30bO1bGVbhRe2qFtesx+khCJ6QwwqFf0HOKr5MIpKx87N5j3t
X-Received: by 2002:a17:907:1b19:b0:c16:28b9:a203 with SMTP id a640c23a62f3a-c16b47814d3mr808280266b.38.1784666622433;
        Tue, 21 Jul 2026 13:43:42 -0700 (PDT)
Received: from [192.168.100.51] (87-205-15-91.static.ip.netia.com.pl. [87.205.15.91])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c1c32af244asm15636766b.27.2026.07.21.13.43.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Jul 2026 13:43:41 -0700 (PDT)
Message-ID: <d90aff0f-1748-48f6-8e9d-b6e55658f6ec@gmail.com>
Date: Tue, 21 Jul 2026 22:43:40 +0200
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot ci] Re: nbd: skip queue limits update for size-only
 reconfigure
To: syzbot ci <syzbot+ci5a934432463e5344@syzkaller.appspotmail.com>,
 syzbot@kernel.org, syzbot@lists.linux.dev,
 syzkaller-upstream-moderation@googlegroups.com
Cc: syzkaller-bugs@googlegroups.com
References: <6a5f3c97.42649fcc.22d900.0001.GAE@google.com>
Content-Language: en-US
From: Krystian Kaniewski <krystianmkaniewski@gmail.com>
In-Reply-To: <6a5f3c97.42649fcc.22d900.0001.GAE@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Please generate a v3 patch for syzbot issue f272bbfbf8498ddadea5, `INFO: 
task hung in queue_limits_commit_update_frozen`. The reviewed v2 job is 
`e5538deb-f4ac-4b3b-a22a-b47c828fc99e`. Start from the original base 
commit `8cd9520d35a6c38db6567e97dd93b1f11f185dc6`.

The main v2 fix is correct and should remain unchanged. The supplied 
reproducer leaves NBD I/O in flight against an unresponsive server, then 
sends a size-only `NBD_CMD_RECONFIGURE`. Calling 
`queue_limits_commit_update_frozen()` for that request waits 
indefinitely for the queue to drain while generic netlink serialization 
is held. Since the effective block size and all other queue limits are 
unchanged, updating `config->bytesize` and disk capacity directly is the 
right fix.

Keep these parts of v2:

1. Keep the small helper which publishes the existing NBD capacity 
update, including `GD_NEED_PART_SCAN`, `set_capacity_and_notify()`, and 
the fallback `KOBJ_CHANGE` event.
2. Keep the generic netlink capacity-only path which validates the byte 
size, stores `config->bytesize`, and avoids queue-limit update and queue 
freezing when the effective block size is unchanged.
3. Keep initial connect behavior. When `nbd->pid` is zero, store the 
requested size without notifying a live disk, then let 
`nbd_start_device()` perform the full queue-limits update.
4. Keep zero block-size normalization before comparison and keep 
validation of invalid nonzero block sizes.
5. Keep real generic netlink block-size changes on `nbd_set_size()`.
6. Keep `NBD_SET_BLKSIZE`, `NBD_SET_SIZE`, and `NBD_SET_SIZE_BLOCKS` on 
their existing full `nbd_set_size()` path. Legacy `NBD_SET_FLAGS` 
followed by a size ioctl must still republish flag-derived queue limits.

Required corrections:

1. Remove `nbd_total_devices--` from `nbd_dev_remove()`. The corrected 
code diff should otherwise be identical to the v2 code diff.
2. Remove the `Added decrement of nbd_total_devices in nbd_dev_remove()` 
bullet from the v2 changelog. Do not change `nbd_total_devices`, add a 
device limit, or attempt another accounting fix in this patch.
3. Correct the opening commit reference. Commit `242a49e5c878` is titled 
`nbd: freeze the queue for queue limits updates`, not `nbd: fix queue 
freeze vs limits lock order`.

The counter change must be removed because `nbd_dev_remove()` may run 
from asynchronous destroy-on-disconnect work. V2 decrements the plain 
counter after releasing `nbd_index_mutex`, while `nbd_dev_add()` 
increments it outside that mutex and `nbd_genl_status()` uses it to size 
an skb. Concurrent removal and creation can lose an update, and a later 
removal can make the counter negative. This can make status enumeration 
fail or turn the skb estimate into a very large unsigned allocation 
size. The decrement also cannot fix `MAX_LOCKDEP_KEYS`: device creation 
does not consult this counter, and changing the count does not release 
lockdep classes. The final test result therefore does not justify the line.

Use this subject:

nbd: skip queue limits update for size-only reconfigure

Keep the commit message narrowly scoped. Explain that capacity-only 
generic netlink reconfiguration no longer freezes the queue, while 
startup and real block-size changes retain the frozen limits update. Do 
not claim that all NBD reconfiguration hangs are fixed, since a real 
block-size change still requires queue serialization.

Keep this exact tag:

Fixes: 242a49e5c878 ("nbd: freeze the queue for queue limits updates")

Preserve the syzbot report and issue tags for f272bbfbf8498ddadea5.

On 7/21/2026 11:32 AM, syzbot ci wrote:
> syzbot ci has tested the following series
>
> [v2] nbd: skip queue limits update for size-only reconfigure
> https://lore.kernel.org/all/514764a5-5acd-4e5d-a8eb-f40c403e7514@mail.kernel.org
> * [PATCH RFC v2] nbd: skip queue limits update for size-only reconfigure
>
> and found no issues.
>
> Full report is available here:
> https://ci.syzbot.org/series/409945b0-159c-4d52-ae37-bc7c04383918
>
> ***
>
> If these findings have caused you to resend the series or submit a
> separate fix, please add the following tag to your commit message:
>    Tested-by: syzbot@syzkaller.appspotmail.com
>
> ---
> This report is generated by a bot. It may contain errors.
> syzbot ci engineers can be reached at syzkaller@googlegroups.com.
