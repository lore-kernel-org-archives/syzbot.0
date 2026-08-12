Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27A77364042
	for <syzbot@lists.linux.dev>; Wed, 12 Aug 2026 13:34:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=100.103.45.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786541700; cv=pass; b=OCJvQPOwHHkZuKc+zIrrY91E4rr29O91USBVitHvO3sAeJC6MxblrCd4cQ1sdudrwzUetqzht6rBsv3/539whDs7zSpPe51C7LUfdY89xjfmR1ApMKQjBehdSRGrtsilPC7GRE+HMQlhYGj9JCRCv9JvezplOPCMBOZOkrK0n2w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786541700; c=relaxed/simple;
	bh=aLZs9/OLdBpXe8GAdK/E02aGac/fTZMReSo59UQcxFw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:content-type; b=QDuplWXd6WwfnX9Nv+repsBpKaTWEd1ctQVth768/5Jv3r8J7bon0zQcG0JtxWPFfSlhGyAKTUuXncWHjfbd0arzwwyDKMtA19qkv5FnKB6ioJKGkgIccxxhR/joZ0YBOGuV8lqsU/mtHVf7cuwzTGk+61CLJcr5PgYJhUBo3/o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cmZaLL7p; arc=pass smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cmZaLL7p"
Received: by smtp.kernel.org (Postfix)
	id E98371F00A3D; Wed, 12 Aug 2026 13:34:55 +0000 (UTC)
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1786541695;
	b=ePqH6iyP+bUuoczIzkXzQ2DR8iJZCKJFAA/RET7mDn13MwSMJC4FjsAyUVitnrisQiPA
	 04jv8ozVyK69kJfe5nPiGJXhTC89PA2LYmG/2XL/OQBkhhbpcGHUxL07RIMVsSEsCWoo1
	 fWborJ7WrOhd5b5pVeGwPnkkfgfz8560fpY7T4njAJxQ/MwDOwOzm2I1aeSBPMM4XBK7o
	 dNu3nxebyFj3n/4el46lIRJSx81tegdGHUK5+p1KLwUtXZddYIMCuFZdoWPiEWOP0uhdA
	 MWLh0dNP73Lv7MlsVG7aURZYbXNwQUktmiHZQnASiBYiiFeWE0G+4PB5ZRpYBG+UTUQ==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1786541695;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:From:To:Cc:
	 Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 X-Mimecast-Spam-Score:X-Mimecast-MFC-PROC-ID:X-Mimecast-Originator:
	 Content-Transfer-Encoding:content-type;
	bh=89Ot9HnzcEwJJKpGeowFJUBn4sQpdYR+K9a0+2a5Sag=;
	b=NBhoPLOUwSqg3grEtWpnHa6m8bsLKk9hf10yP5a9qh3Yt9luj3s6rJsstnbymX7VIc2F
	 LhgLRAkuufRWZ7kjz6a9vG4W5uL4zSV09a4WyQjXLXlwppAjpi+hxP38Ya+u/tCf7sv9t
	 lybGkPjOKsc3niWvgLmKiPW10BxvH/yxvZF/z+5deDM7BoUpcRiKTgG83EjX+mmdMloP+
	 uT5PFJFdeXwaYuHXdeIYQu3nSUs4287ugD4DwLOiptl2ECn3k6XX9i0BywS7wBtqpD8UU
	 bLq5hYqc7ZZDqaw+XxKmJhlikc4/nSuPq785+xFqDzS+jC2ddP/kzBO5GZ0+0UljFqw==
ARC-Authentication-Results: i=1; smtp.kernel.org; dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=cmZaLL7p;
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 1EFBF1F000E9
	for <syzbot@kernel.org>; Wed, 12 Aug 2026 13:34:54 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=cmZaLL7p
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.kernel.org 1EFBF1F000E9
Authentication-Results: smtp.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786541694;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=89Ot9HnzcEwJJKpGeowFJUBn4sQpdYR+K9a0+2a5Sag=;
	b=cmZaLL7pXw5dLYj0TEtAhIkJkwC4fRXpGHoSob+Tc6ZR2CKKBGyjlJY6uDBT++/TODdVOL
	zh0g3PMiklZi9qwy2t369x77LEUiu99zdlxbYmorNWyHr7kE9MxlTTFInfz6lp1phZwr/f
	sJTxmgjda964cnPqfSDZaIS75W1uM5k=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-177-0krj9E6uPdiNdCiVkX9N1Q-1; Wed, 12 Aug 2026 09:34:48 -0400
X-MC-Unique: 0krj9E6uPdiNdCiVkX9N1Q-1
X-Mimecast-MFC-AGG-ID: 0krj9E6uPdiNdCiVkX9N1Q_1786541687
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-c1630a90890so56513566b.1
        for <syzbot@kernel.org>; Wed, 12 Aug 2026 06:34:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786541686; x=1787146486;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=89Ot9HnzcEwJJKpGeowFJUBn4sQpdYR+K9a0+2a5Sag=;
        b=KqqH9PUfjVV5sSKLMHCM6ciXftw56UKvybfskV/c+IB49kqK89GbQk39B3OEmsFnro
         xSZbgoMQ5R3F52UQvexawd0GicD4uI3wueg5fAj/dOCUwYLaQIe76/G5X+K81MNr48Yi
         KmmgP6XXMSJqhUMi0hMuBnssQWgjnBEXQG5vUdEVsQ+ySktFL3BQN5lbdfBUK90tchJT
         XF69rFv0h2GwyzVg874kLanA+z6NXd5tGvZ143qUXdKX+13ePPMmNzcEDY3/qlTCgM1A
         sgCFBHLeXixEy6n9vT8hSma4dmSiBQSKrfRJRhZtqadpzJg3wnIvvrxfRz3P24wZI3Pu
         m5sA==
X-Gm-Message-State: AOJu0YytuACuCZ2ZEx3Uh+ow9B3wbBwFJaP2di8q/twYWDFBWr4DsMmV
	aadcwN7TUDbi+8UCI0z9Me58vyj93nlsi16CuDkYtkz9sfzHXWXPMfL1m4vqLTyyPCrauo6+DXT
	7i+vaFpGQMU+1o26MDAkSPQdnTJCEQfeXlqEdVl9RPGItW4Dguy/ZrtpE8ydIWJFVtyf5aAPbod
	VHgnCZX7KJ0Ge1truxwFTSuza2uq0Cd1P86COnyg==
X-Gm-Gg: AR+sD137SRuzhYl/2sD8DGiDL0DTSkcpczpE+c6plv7tZhJ9UCc+3Fw1Z9CGnvF3S/4
	MZfdLqL+/EGnqb7fQWJH8vjQFMgWHPTppSUVVxthg4wJbcHaY2bGEbJBsr7/yIOeNIwbPWMdT3z
	91XaVsaylft9r6HYRfn5iGwSS/wLppJ+Dl+jeSJv6eeOab8iJprrQiT3ZywSGs172p9XUkK+f/f
	DP+BRk79VD5CN8hPcQYDRR1V29e6L2oMwf5rCeuHhD1wVYwwTa1Ekji9vZ5ER7JM/RKhQP/rgO9
	Cxg6MIrsGqKrm1HG000o1+87+415vbmUz19qsRwzd4SOdssKL0yYtruavjKVl8Oia0KASX5KKZ0
	qFv1heLZv399mWVtASIqIkqehFSrxgMaaSg==
X-Received: by 2002:a17:907:c1a:b0:c15:fc59:cdf3 with SMTP id a640c23a62f3a-c20f2ea968cmr208005866b.12.1786541686675;
        Wed, 12 Aug 2026 06:34:46 -0700 (PDT)
X-Received: by 2002:a17:907:c1a:b0:c15:fc59:cdf3 with SMTP id a640c23a62f3a-c20f2ea968cmr208002866b.12.1786541686238;
        Wed, 12 Aug 2026 06:34:46 -0700 (PDT)
Received: from cluster.. (4f.55.790d.ip4.static.sl-reverse.com. [13.121.85.79])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c20f059195asm93538966b.0.2026.08.12.06.34.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Aug 2026 06:34:45 -0700 (PDT)
From: Alex Markuze <amarkuze@redhat.com>
To: syzbot@kernel.org
Cc: ceph-devel@vger.kernel.org
Subject: Re: libceph: validate banner payload length
Date: Wed, 12 Aug 2026 13:34:44 +0000
Message-Id: <20260812133444.3288921-1-amarkuze@redhat.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <88076cd2-1b1c-4988-905d-aa4745af3872@mail.kernel.org>
References: <88076cd2-1b1c-4988-905d-aa4745af3872@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: xOdJqcq6L_dLYJGrZ-ozx7Z8sxcJ_V_bhpMLhE7cA-U_1786541687
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

Hi syzbot,

Thanks for the patch.

Reviewed-by: Alex Markuze <amarkuze@redhat.com>

-- 
Alex Markuze

