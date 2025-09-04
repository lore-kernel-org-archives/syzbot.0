Received: from mail-yb1-f181.google.com (mail-yb1-f181.google.com [209.85.219.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AD76238C19
	for <syzbot@lists.linux.dev>; Thu,  4 Sep 2025 23:25:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757028358; cv=none; b=gfKHLl/1NRE9etLghaOo5zYeizTSTSsCiNqKCUzXwwDFNGLdoR1fqecnajWzInmyKNGl33V5iJ8BOZb2/2lO6UHeXG2eJnmUEgnQRi0x6PM7AyWKNrL5I2C+zzHvUJKVCJ6j+ryUofNzMN0YRK29905jtXcCrIQX1WzqGvVo/e4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757028358; c=relaxed/simple;
	bh=0z4W131kc7IZA/MZBmrE2/S7QjivMLpZDRe6D8mSq1w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=g5CGQzwIWet2OXEljvVXkx4XwqqdgJ3bsUOwI+xcfVbANh/pk8mA/JWqqaPs1fJ0EnTA9JP/HuMk7974jkegR2z1Jv7aB+Yrno5IWtppG9BgFfLAzAhEYn8UjG39KPrt+WIh43U8KBgYvgQbPjuZzxBtaT3DW2+kOkqZSDq2+4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=gOEtAi1o; arc=none smtp.client-ip=209.85.219.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="gOEtAi1o"
Received: by mail-yb1-f181.google.com with SMTP id 3f1490d57ef6-e96e1c82b01so1607985276.1
        for <syzbot@lists.linux.dev>; Thu, 04 Sep 2025 16:25:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1757028355; x=1757633155; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7xozTMnAUTSGP/OIsr+6T7j3/FSd9yXb5HKJfOm++2A=;
        b=gOEtAi1oDovKiT63NEMoNC024lASOUW7hs1SxXHKfKigjDg1GNFK+yccfOgnrOqYob
         bsWSedXM7NE3gyWt+eXAXii++F/v25TbRa6J5ku9vBXRIIfHpd36oVrmL3EOqKjMEd9Y
         zp+VqjWu30P8C+4kM+2IA6Mr/1x3L+fAlK8YDSB/Ii9N5pjgE5j57QLeWYN/cQJj0nNK
         K7R+DYnADTRFZYltoDm+nS7vmdP1bG+MVnYXssDHozpzKW3Vs/2LT0uNGBjT94owW2bI
         /iYLVlmIl8/FVouaCh9tdDj73U7jMcU25IcbSFGB+IqLVyC7OQrnKhLgZwgYREHmxC/F
         0UjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757028355; x=1757633155;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7xozTMnAUTSGP/OIsr+6T7j3/FSd9yXb5HKJfOm++2A=;
        b=LstOJZao3u25TuZJMzOn2wuKMxZKnskXMjNYQJvq4VnXaHC/TkP9/JH/dydvfd/MkD
         qq3gfV9Su0PY6aFSF9jUp6RD5wBA2IHVDFYD+gOzoKpNqJjJ4TRDimxbBghAd+LpOiNP
         idPVuinCjPB5+WYnIaxufod3wEPBc+Vr1pehKRbhhVMPHt1VzfpxXcHQtI4Gd6POW39O
         RG0EedfcSbBYYeIIidDcbr12C8S6AbdoGrZhJ75L0RU3FPBxJRO3smDBJu6j48GrQpEO
         1SpKBM/hnUAP8/Pk9yqhfjmMRbX4jZOHw2zvpZrFD5YIJ1WRXEo04iCki3vi/DxeiXEH
         ItYg==
X-Forwarded-Encrypted: i=1; AJvYcCWlqxlxD4kdCjxAcmD7Kl5lKVU5a31xh5h251MVxCL2WprgSrQGPZHUWoMxu+X2AT5MN88pquY=@lists.linux.dev
X-Gm-Message-State: AOJu0YyJge8Y6qr6e51O/L1YfOkptZSJ/HK1YuO6417ScM2i4BJuGGyr
	ElcLS9UFvBGiyvDNH2KnVHUN1SP7GHF/Xf3f219YNyP3Ps+fh32RPoJT7ZiIaOn595IwUbfLrS1
	goEco
X-Gm-Gg: ASbGnctz0SVnr4KbDlMvBHdPJ8gajX2F4H8FfmvHLw6491MZ+uP45oVTlo2aN6d8kRr
	goJ841zBX/snQ/SJIMH8HxNKL2hgNUOyVccWtXu7eNsA2xkg6QYRpp2jsqjKcCw4zmK7ODVRTbe
	NmYdnBpEhQJ8PFBn2FYL+e+w0HdZ1O6BVQGZDQhhibDMsUskf5aq9RQK8260PwXgcUcnu8HTfLs
	oUV7QXHWw1chbsQMqR3m3wuSrcUOGJCWZ9vpdx0GIfSiP3m5P1SiqW67OFYPHJmEsshnUG0HBhb
	Cmn6hdNaSxVwD2ssgjbZHP2u/X5ka8AGJ9/LVyOUaZNTxtCSjMKxnWNRn2psA+sJ2Speulbroit
	NnZDurX4DteBE26aK9fySN6WnDz3V
X-Google-Smtp-Source: AGHT+IHYyMuPItddACX1ADJHnCstSzAXvHPDxAQjNdgUGdiE0877dFLHUdUXWRUOoRlz4okMbYYr6A==
X-Received: by 2002:a05:6902:158c:b0:e90:6ed1:ec51 with SMTP id 3f1490d57ef6-e98a578c92cmr23210220276.14.1757028355311;
        Thu, 04 Sep 2025 16:25:55 -0700 (PDT)
Received: from [10.0.3.24] ([50.227.229.138])
        by smtp.gmail.com with ESMTPSA id 3f1490d57ef6-e9d6a5cdb43sm1149951276.8.2025.09.04.16.25.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Sep 2025 16:25:54 -0700 (PDT)
Message-ID: <d3c5e370-5d60-4f00-9f92-d783e0e4a051@kernel.dk>
Date: Thu, 4 Sep 2025 17:25:54 -0600
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot ci] Re: io_uring: avoid uring_lock for
 IORING_SETUP_SINGLE_ISSUER
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: syzbot ci <syzbot+cibd93ea08a14d0e1c@syzkaller.appspotmail.com>,
 io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
 syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
References: <68b8b95f.050a0220.3db4df.0206.GAE@google.com>
 <26aa509e-3070-4f6b-8150-7c730e05951d@kernel.dk>
 <CADUfDZpTtLjyQjURhTOND5XbdJOSEduDLdSuyUJVk_OKG9HVGA@mail.gmail.com>
 <CADUfDZot=DxWjERupMofRuyvK3jKx79yQUOSniqT4uhMac2dbw@mail.gmail.com>
 <CADUfDZq-x3t6gfzAg8kxe8oNezDwYKggkeZ4o1Jw-Q1smjh6aQ@mail.gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CADUfDZq-x3t6gfzAg8kxe8oNezDwYKggkeZ4o1Jw-Q1smjh6aQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/4/25 10:50 AM, Caleb Sander Mateos wrote:
> On Thu, Sep 4, 2025 at 9:46?AM Caleb Sander Mateos
> <csander@purestorage.com> wrote:
>>
>> On Thu, Sep 4, 2025 at 7:52?AM Caleb Sander Mateos
>> <csander@purestorage.com> wrote:
>>>
>>> On Wed, Sep 3, 2025 at 4:30?PM Jens Axboe <axboe@kernel.dk> wrote:
>>>>
>>>> On 9/3/25 3:55 PM, syzbot ci wrote:
>>>>> syzbot ci has tested the following series
>>>>>
>>>>> [v1] io_uring: avoid uring_lock for IORING_SETUP_SINGLE_ISSUER
>>>>> https://lore.kernel.org/all/20250903032656.2012337-1-csander@purestorage.com
>>>>> * [PATCH 1/4] io_uring: don't include filetable.h in io_uring.h
>>>>> * [PATCH 2/4] io_uring/rsrc: respect submitter_task in io_register_clone_buffers()
>>>>> * [PATCH 3/4] io_uring: factor out uring_lock helpers
>>>>> * [PATCH 4/4] io_uring: avoid uring_lock for IORING_SETUP_SINGLE_ISSUER
>>>>>
>>>>> and found the following issue:
>>>>> WARNING in io_handle_tw_list
>>>>>
>>>>> Full report is available here:
>>>>> https://ci.syzbot.org/series/54ae0eae-5e47-4cfe-9ae7-9eaaf959b5ae
>>>>>
>>>>> ***
>>>>>
>>>>> WARNING in io_handle_tw_list
>>>>>
>>>>> tree:      linux-next
>>>>> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/next/linux-next
>>>>> base:      5d50cf9f7cf20a17ac469c20a2e07c29c1f6aab7
>>>>> arch:      amd64
>>>>> compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
>>>>> config:    https://ci.syzbot.org/builds/1de646dd-4ee2-418d-9c62-617d88ed4fd2/config
>>>>> syz repro: https://ci.syzbot.org/findings/e229a878-375f-4286-89fe-b6724c23addd/syz_repro
>>>>>
>>>>> ------------[ cut here ]------------
>>>>> WARNING: io_uring/io_uring.h:127 at io_ring_ctx_lock io_uring/io_uring.h:127 [inline], CPU#1: iou-sqp-6294/6297
>>>>> WARNING: io_uring/io_uring.h:127 at io_handle_tw_list+0x234/0x2e0 io_uring/io_uring.c:1155, CPU#1: iou-sqp-6294/6297
>>>>> Modules linked in:
>>>>> CPU: 1 UID: 0 PID: 6297 Comm: iou-sqp-6294 Not tainted syzkaller #0 PREEMPT(full)
>>>>> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
>>>>> RIP: 0010:io_ring_ctx_lock io_uring/io_uring.h:127 [inline]
>>>>> RIP: 0010:io_handle_tw_list+0x234/0x2e0 io_uring/io_uring.c:1155
>>>>> Code: 00 00 48 c7 c7 e0 90 02 8c be 8e 04 00 00 31 d2 e8 01 e5 d2 fc 2e 2e 2e 31 c0 45 31 e4 4d 85 ff 75 89 eb 7c e8 ad fb 00 fd 90 <0f> 0b 90 e9 cf fe ff ff 89 e9 80 e1 07 80 c1 03 38 c1 0f 8c 22 ff
>>>>> RSP: 0018:ffffc900032cf938 EFLAGS: 00010293
>>>>> RAX: ffffffff84bfcba3 RBX: dffffc0000000000 RCX: ffff888107f61cc0
>>>>> RDX: 0000000000000000 RSI: 0000000000001000 RDI: 0000000000000000
>>>>> RBP: ffff8881119a8008 R08: ffff888110bb69c7 R09: 1ffff11022176d38
>>>>> R10: dffffc0000000000 R11: ffffed1022176d39 R12: ffff8881119a8000
>>>>> R13: ffff888108441e90 R14: ffff888107f61cc0 R15: 0000000000000000
>>>>> FS:  00007f81f25716c0(0000) GS:ffff8881a39f5000(0000) knlGS:0000000000000000
>>>>> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>>>>> CR2: 0000001b31b63fff CR3: 000000010f24c000 CR4: 00000000000006f0
>>>>> Call Trace:
>>>>>  <TASK>
>>>>>  tctx_task_work_run+0x99/0x370 io_uring/io_uring.c:1223
>>>>>  io_sq_tw io_uring/sqpoll.c:244 [inline]
>>>>>  io_sq_thread+0xed1/0x1e50 io_uring/sqpoll.c:327
>>>>>  ret_from_fork+0x47f/0x820 arch/x86/kernel/process.c:148
>>>>>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
>>>>>  </TASK>
>>>>
>>>> Probably the sanest thing to do here is to clear
>>>> IORING_SETUP_SINGLE_ISSUER if it's set with IORING_SETUP_SQPOLL. If we
>>>> allow it, it'll be impossible to uphold the locking criteria on both the
>>>> issue and register side.
>>>
>>> Yup, I was thinking the same thing. Thanks for taking a look.
>>
>> On further thought, IORING_SETUP_SQPOLL actually does guarantee a
>> single issuer. io_uring_enter() already avoids taking the uring_lock
>> in the IORING_SETUP_SQPOLL case because it doesn't issue any SQEs
>> itself. Only the SQ thread does that, so it *is* the single issuer.
>> The assertions I added in io_ring_ctx_lock()/io_ring_ctx_unlock() is
>> just unnecessarily strict. It should expect current ==
>> ctx->sq_data->thread in the IORING_SETUP_SQPOLL case.
> 
> Oh, but you are totally correct about needing the mutex to synchronize
> between issue on the SQ thread and io_uring_register() on other
> threads. Yeah, I don't see an easy way to avoid taking the mutex on
> the SQ thread unless we disallowed io_uring_register() completely.
> Clearing IORING_SETUP_SINGLE_ISSUER seems like the best option for
> now.

Right - I don't disagree that SQPOLL is the very definition of "single
issuer", but it'll still have to contend with the creating task doing
other operations that they would need mutual exclusion for. I don't
think clearing SINGLE_ISSUER on SQPOLL is a big deal, it's not like it's
worse off than before. It's just not getting the same optimizations that
the !SQPOLL single issuer path would get.

-- 
Jens Axboe
