Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.51
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793716290;
	b=I4IXNP1+yg5mSK5ft576zoDb2gKbi8pBnU2m7p+EGXh0Og6na13n3yLrQGOZ2xUAGmap
	 JwYSCQr59AqMfVwliI7sdQgWPzM+wRBr+HeFlm0uZUC2qTOgJ2cc8Jk64uwCgeoXyMF9W
	 0YOcHzD1DINbDgZ2DtOdkEoLhMP4Y8cYM66zw9W9VWb7YRU746G0JJwS1y11T2gfWgzEM
	 B11FYZtD142y+mSIzkQnE73PhH04fVctoBYsDPXaSFR2lVeRRyWpJQFnRY4AL47M3tl4M
	 V09cNgeCEEawiZcCulCUZJGj9CGu4iyXuLrPdnAdi2kLxvbl0dBwZ2vYTgNHJaO2Fgw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793716290;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:X-Mailer;
	bh=lQP5UfoJGZ61K5R3SQuKiGS3++XV/5Fqa+MZBDFEMdI=;
	b=YmnsqnVx8nJXXm75zUhatp5sS8KdlqhkB5UYmUlyNloFD1r0gTMHpsV7ckE666t7/rjr
	 1D/JJ6aix0HEAryjC4XyDzwJty+0uUlk7gtibRePIubE18r0qPEQLehTCt/H3ntYa1t4N
	 FgSgiJb3ne1ggNxAvuGud4P9Ju5UxwxoP2rYQX/vwwkLU6d1J7Hj4ZewRnVucEKAlt3QB
	 818aOW9sZEe10jljT4W/t+JreWwr5np+6I5CjoCkbLOkULfEv6BARPh795Di3kVdXt8nQ
	 MPwxinAVO5str1c2OV1Hh8dhV6+LNTmGlTzW/Tw4Gr6aOq+Qi5oHza9d8roIFZCxojg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=kernel.dk;
	spf=pass smtp.mailfrom=kernel.dk;
	dkim=pass header.d=kernel-dk.20260707.gappssmtp.com header.i=@kernel-dk.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=GEjWWQYH;
	arc=none smtp.remote-ip=74.125.82.51
Received: from mail-dl1-f51.google.com (mail-dl1-f51.google.com [74.125.82.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 652F7606D80F
	for <syzbot@lists.linux.dev>; Tue,  3 Nov 2026 14:31:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 652F7606D80F
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel-dk.20260707.gappssmtp.com header.i=@kernel-dk.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=GEjWWQYH
Received: by mail-dl1-f51.google.com with SMTP id a92af1059eb24-1ae58d17cd9so1141416c88.1
        for <syzbot@lists.linux.dev>; Tue, 03 Nov 2026 06:31:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20260707.gappssmtp.com; s=20260707; t=1793716289; x=1794321089; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=lQP5UfoJGZ61K5R3SQuKiGS3++XV/5Fqa+MZBDFEMdI=;
        b=GEjWWQYHBiWz232e/2kMhszE47N6ih5Tlnrjpp74riBsRE/TsQc1u/QHWol7YSgKH+
         YM0z2JAnd5+IZEzk7/Vzcn0iHd4RNE2w/dW2drwL43/V1jvHASNThmD8SPHxjV3n4I/N
         N0aFzwsn/4xJSYFmpbvW13Onb72kzvYl7voaKqMKj97gU7j8f8Us9vvTNmn91v7OemM7
         eFvOAtx4EVanCWWZVX9n1Eft7pgrZ9FQpfS40dPJUMviTWhDEw+P69sWf/BDz1ao/vng
         tMfFMwhVRSURbXjPVqr+RCrjxEVJf+bczKerSptqrn8gvbvfDLaa/Cilf28YmhBS5mvJ
         +dIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793716289; x=1794321089;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=lQP5UfoJGZ61K5R3SQuKiGS3++XV/5Fqa+MZBDFEMdI=;
        b=2gSoIHXQX8fm8nr84REXIBo5ODnRYyKpvYcKn1WTnSDsFxb1vOa8mQklxtW5G2UcD1
         6T5mtztsEqih6QG34TYex1nuxlQ3WZ0zJMnmjSQ/SYavFTarh8Dd6brYK6CRi9hyT8hr
         nlOeBsLXzNCSTKE/31mtrJKVwawuEh7XAO46fxsbD17h/+fA2OvvEbagPpe4sRKpsu9g
         gCrye+98pIm9AkVIT4dvuATflJHd6ELOC7pfV/bfSMDIdKhzTEBdKPlhUMyoPoAU6ENM
         KLb985ZYw9EsxRehznXUmfy+PKJzkLETB95PmP7u7/HgghwQGzbA3f0nOqz64xgk7oaH
         +mgQ==
X-Forwarded-Encrypted: i=1; AKwUvByg1trlQhi1ypL1rtGdriXx+7zBCzQCEFUBA8mtVlvv7eZBQm0qXKe8Ld/b7W2vZI7BrYzT/i8=@lists.linux.dev
X-Gm-Message-State: APuU4Z9tgn25k/UUtsjaIYmqlubiXpushXF5QZbllGJjxTberV517LSc
	Mf40UCgolgl9A+jujO8YJhzWOL8lP/jqER2Uo7AVs+xWKJWJ59uglFYahJ0IoTg45+e4IZhDH37
	nSN9fA/w=
X-Gm-Gg: AYBFou0UQL7w9M9o9Y11xqcEsoRmF5k/i8bUiRLFow/Oz8LwuXWie4qI5zjMzMNmyaj
	dx206fzIsey1LhT+0NXXZNkk72r7ogSo0bqbsKC7X8lO4CzWO8Oebc/nIAXZY4c5da26C97nUR0
	8xFFSbXpsNP3iLL+rga64RQosjug7XSDoDe3BTfw2ME7q0wE0wumr0kjKFlbiY3xJCK/I+LRuMd
	plyndoSF6am33i7G3H7kISIlt/hYm6MaaiKo7tFZJuYxZLmoag2MtnnhW4bi38HM99/8pbX43XJ
	y2AzlIHQAeyFCyNmQcZAaya65nP144P3TqvmvPJILsiiS+puMHO9ZMFWjA5e6rdqi0p3gyHQTTk
	ockOFQy1inacIpl/zL3qQ44p110l9nw07cu7mGToGeaeoH0/9tJ1LrbIYyNRzEAFX/2t3YvGcNd
	IX/Czh1A2PsfhRBHJ5eHJZPpkSuIDy6HaK9mkQR99JN7vJ4rJ+9kGL7CbOc70xalu/GctBULtsm
	xAHP1hFg9lyi9aXgF/jfiRDroUr0iLtYoWhX9lFFhHMglUC2cbPPZlP4f2VW9F563JQxVFjKZcN
	W0nctka6dfxeiua/WPtWc4AoyKxF/BheuFxZPHxU/8d9WyHB+YFjidKtL05qTqmKfzmnW7B8sFy
	UCIp2TfyzfRKI
X-Received: by 2002:a05:7023:d0b:b0:144:e535:3ef6 with SMTP id a92af1059eb24-1ac5de53bbdmr21036321c88.41.1793716289438;
        Tue, 03 Nov 2026 06:31:29 -0800 (PST)
Received: from [192.168.1.106] ([198.8.77.135])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b23b847348sm9534779c88.4.2026.11.03.06.31.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 06:31:28 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: linux-block@vger.kernel.org, 
 Krystian Kaniewski <krystianmkaniewski@gmail.com>
Cc: Nilay Shroff <nilay@linux.ibm.com>, Hannes Reinecke <hare@suse.de>, 
 Ming Lei <ming.lei@redhat.com>, linux-kernel@vger.kernel.org, 
 stable@vger.kernel.org, syzkaller-bugs@googlegroups.com, 
 syzbot@lists.linux.dev, 
 syzbot+e90526cab23b9efcd03c@syzkaller.appspotmail.com
In-Reply-To: <20261014170538.1089448-1-krystianmkaniewski@gmail.com>
References: <20261014170538.1089448-1-krystianmkaniewski@gmail.com>
Subject: Re: [PATCH v2] blk-mq: fix out-of-bounds read in blk_mq_free_rqs
Message-Id: <179371628848.3691261.276757911523604089.b4-ty@b4>
Date: Tue, 03 Nov 2026 07:31:28 -0700
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Post: <mailto:syzbot@lists.linux.dev>
List-Help: <mailto:syzbot+help@lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
List-Owner: <mailto:syzbot+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15.2


On Wed, 14 Oct 2026 19:05:36 +0200, Krystian Kaniewski wrote:
> A KASAN slab-out-of-bounds read can occur in blk_mq_free_rqs() when there
> is a mismatch between the number of hardware queues allocated for the IO
> scheduler (et->nr_hw_queues) and the number of hardware queues in the block
> tag set (set->nr_hw_queues).
> 
> This mismatch can happen if blk_mq_update_nr_hw_queues() fails halfway
> through (e.g., due to memory pressure during
> blk_mq_prealloc_tag_set_tags()). In this error path, the elevator is
> restored with a larger number of hardware queues than the block tag set
> actually has.
> 
> [...]

Applied, thanks!

[1/1] blk-mq: fix out-of-bounds read in blk_mq_free_rqs
      commit: 894e4e6084924cfd590968d45fad20908e02ddae

Best regards,
-- 
Jens Axboe



