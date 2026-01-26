Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AF191B6D08
	for <syzbot@lists.linux.dev>; Mon, 26 Jan 2026 03:11:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769397108; cv=none; b=VPpMn2tz6rcjJaM78U/g3GibVM1z7VInFTsB/g/UOjahDiaW7iGY2dO6gf/Ld9yP9qwEdxQahwnNsAFOnbl9DtzSvy6QUj4yvPQM4aJU/rAPWePi5mZ8AghJHBXNzSjmEKkPGhEXrqhAhstIomUdALBg0r0Ba6b58PdJu89t2+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769397108; c=relaxed/simple;
	bh=03OtnC4EGRJa+xmuo72DEf5kQeNr+TJzxRdoiIqPnEk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SjI2dzlAJ0lE5VgMt09l1a8BmfCtll+6vZrjlyz96OVK5JFJ54K4HR/tvuYkcBLKIoNEmnTrCKJ5nsM9bpCtZr2wB7GeDJDFVjHdUOR6JxKhxWD3lUMBViY9+DQI4Qj9P44H+9zNf2mvCvNTakZ+xsSwlk9JDJ4plQhiJw7Ro1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Qi5Ilk/8; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Qi5Ilk/8"
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-81f5381d168so3830845b3a.2
        for <syzbot@lists.linux.dev>; Sun, 25 Jan 2026 19:11:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769397106; x=1770001906; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=zhlapqH4ikiODVcmKIYx08XtjNQj8jB08PiPoS1TveU=;
        b=Qi5Ilk/8I2mP8A5YyPMPP1MgHHCuYHWemgBlgNgWCnDCJDpcoqGHbqJrZFEXU4EcPU
         Op55jQq8UtxhRiyfbR1hoNrgql1AURRGF0YKGCwLdhPcKxOTv//SNZo3hfVU7cJRdVD9
         aNDF7/JdD11DlHM1pZmDholMfTIPFPZS4IARm1vvoED+jzTRyOB2KbL2BJA0rB5oCALc
         LrboJSqu5Sf6rKOlK4Ryq/RAWd6OX48E9BUZEy5c83SiSb66cbFXqohlWrYK06jfZAOe
         fK6ZgnaTxg6Jp+QFXRsBE+fUT+tBuI6N5c1p8spUaW8tHwyxuiiFRoIO+X94eJnMxdtM
         KxBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769397106; x=1770001906;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zhlapqH4ikiODVcmKIYx08XtjNQj8jB08PiPoS1TveU=;
        b=MyBKa32swpVo8V9iwbPbnd6fVjzXJTMUK3tkChYohQb35NtAsDnaTWf3/Tf2YQ/Swd
         vmu1OBY/D/tTIiAkST+ieloN+bYVeCaAQjfMR/A3zBOKuy8L+J8hSQppfQrRUkghhYKF
         IfLFF+9dEL5HRZ+kSmoI8HyLCIWqtFgbh9eUQ7ynDjbvBNkyj4xb4D0/23sAiJ3kWy2d
         IJ5PszcC+X2Bfcyka0Xs25+DBLvluwoXwXs5okzyJ7OzFk2yuwwcjqVt1QLCT67gpMMh
         9Ko5L8qwvUqkWbxesmRS6PpOus8FNPsQpEOryM7PekGS2ak30Jfi5zQ33HL+wggZiyH1
         VAaA==
X-Forwarded-Encrypted: i=1; AJvYcCXBi/9yLE/whXbk+4yF8pSLaLdrDlW0Lx0QFLXeWq2VWfG1eWcFKzLzYnvmZz2gQIsspPTk+qA=@lists.linux.dev
X-Gm-Message-State: AOJu0YxnY+UWgiCwQ5Rc4g9ljoKr3sfdVLoDltHC/e+Jh4v6OgsRF9+5
	ppQ0rAxMLIyvKihZWhw9DQG3pCFxM5uvvFEJCZNz/t17e37N9HViq8Xc
X-Gm-Gg: AZuq6aJ157qzrHqKIRrZ+v0JbSbgbPgSp+NwD+eIxFSOAxHLlh70gnSAWkG7X1M3rni
	HLzaWfjVyqG3cWEEF42/CuaWoBkq3XtoVB9Z16VekBayfLaomMpbuncL9d7zo2+/hl1b18svun7
	p5aNJ+VLOg8AfC+ds0P1KeuqD1EdhHngHJ3p5AK+Se+VwV28AzVcxs5umu3/H15Xq4RY/uN6TiT
	akf79wiFgm5Zh59AHBQD/tGjStiFWX1JclJiLDXUslfNlWGJ8/t5/mj0Be+m43zB+hZpy7PKx6L
	WlpHvhVLiZ3K5/jGawydXLrfyjbv63J+5GCpcek870x2w3os6lYsBZfG0tHMf/uTb5c89hCVoIW
	qLZJQWPYkquU0+e4a0lQmi7aozBeLG7In9DaxnGJ2mtH7NNNYVNhxy66tiS90SYLNjy/DkI7XHF
	OB1ROBExFI76UojNTItMH8nI8l3pZVtY59Ok1M1IZ613w3IBnpUw2CRCki
X-Received: by 2002:aa7:888b:0:b0:81f:52d9:5f5 with SMTP id d2e1a72fcca58-823411b7b78mr3026632b3a.10.1769397106186;
        Sun, 25 Jan 2026 19:11:46 -0800 (PST)
Received: from KASONG-MC4 ([43.132.141.24])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8231876e5d0sm7996541b3a.61.2026.01.25.19.11.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Jan 2026 19:11:45 -0800 (PST)
Date: Mon, 26 Jan 2026 11:11:37 +0800
From: Kairui Song <ryncsn@gmail.com>
To: syzbot ci <syzbot+cie25b4769e5d96875@syzkaller.appspotmail.com>
Cc: akpm@linux-foundation.org, baohua@kernel.org, bhe@redhat.com, 
	chrisl@kernel.org, david@kernel.org, hannes@cmpxchg.org, kasong@tencent.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, lorenzo.stoakes@oracle.com, 
	nphamcs@gmail.com, shikemeng@huaweicloud.com, syzbot@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot ci] Re: mm, swap: swap table phase III: remove swap_map
Message-ID: <aXbbCQ3Pibj-T_fN@KASONG-MC4>
References: <20260126-swap-table-p3-v1-0-a74155fab9b0@tencent.com>
 <69769595.a00a0220.33ccc7.002b.GAE@google.com>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <69769595.a00a0220.33ccc7.002b.GAE@google.com>

On Sun, Jan 25, 2026 at 02:13:41PM +0800, syzbot ci wrote:
> syzbot ci has tested the following series
> 
> [v1] mm, swap: swap table phase III: remove swap_map
> https://lore.kernel.org/all/20260126-swap-table-p3-v1-0-a74155fab9b0@tencent.com
> * [PATCH 01/12] mm, swap: protect si->swap_file properly and use as a mount indicator
> * [PATCH 02/12] mm, swap: clean up swapon process and locking
> * [PATCH 03/12] mm, swap: remove redundant arguments and locking for enabling a device
> * [PATCH 04/12] mm, swap: consolidate bad slots setup and make it more robust
> * [PATCH 05/12] mm/workingset: leave highest bits empty for anon shadow
> * [PATCH 06/12] mm, swap: implement helpers for reserving data in the swap table
> * [PATCH 07/12] mm, swap: mark bad slots in swap table directly
> * [PATCH 08/12] mm, swap: simplify swap table sanity range check
> * [PATCH 09/12] mm, swap: use the swap table to track the swap count
> * [PATCH 10/12] mm, swap: no need to truncate the scan border
> * [PATCH 11/12] mm, swap: simplify checking if a folio is swapped
> * [PATCH 12/12] mm, swap: no need to clear the shadow explicitly
> 
> and found the following issue:
> WARNING in swap_cluster_lock
> 
> Full report is available here:
> https://ci.syzbot.org/series/3f6169fc-e24a-4a19-ba56-e5907b448edc
> 
> ***
> 
> WARNING in swap_cluster_lock
> 
> tree:      mm-new
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/mm.git
> base:      5a3704ed2dce0b54a7f038b765bb752b87ee8cc2
> arch:      amd64
> compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
> config:    https://ci.syzbot.org/builds/0eabd97a-86d8-4606-9d94-dbe4e7fd7c07/config
> C repro:   https://ci.syzbot.org/findings/5b039fd0-70da-4954-817d-8bf86315c684/c_repro
> syz repro: https://ci.syzbot.org/findings/5b039fd0-70da-4954-817d-8bf86315c684/syz_repro
> 
> ------------[ cut here ]------------
> offset >= si->max
> WARNING: mm/swap.h:88 at __swap_offset_to_cluster mm/swap.h:88 [inline], CPU#1: syz.0.548/6508
> WARNING: mm/swap.h:88 at __swap_cluster_lock mm/swap.h:101 [inline], CPU#1: syz.0.548/6508
> WARNING: mm/swap.h:88 at swap_cluster_lock+0xef/0x130 mm/swap.h:132, CPU#1: syz.0.548/6508

This is a good catch from the bot. It's caused by the patch "[PATCH 10/12] mm, swap: no need to truncate the scan border", however that patch is not wrong, it just have to update the debug check too:

diff --git a/mm/swap.h b/mm/swap.h
index 087cef49cf69..386a289ef8e7 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -85,7 +85,7 @@ static inline struct swap_cluster_info *__swap_offset_to_cluster(
                struct swap_info_struct *si, pgoff_t offset)
 {
        VM_WARN_ON_ONCE(percpu_ref_is_zero(&si->users)); /* race with swapoff */
-       VM_WARN_ON_ONCE(offset >= si->max);
+       VM_WARN_ON_ONCE(offset >= roundup(si->max, SWAPFILE_CLUSTER));
        return &si->cluster_info[offset / SWAPFILE_CLUSTER];
 }

I'll update this in V2.
