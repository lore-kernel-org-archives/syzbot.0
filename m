Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 845C23D3332
	for <syzbot@lists.linux.dev>; Fri, 22 May 2026 15:19:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779463160; cv=none; b=XugNM6DU15NANygDlNudRAytv6HVCfZF6bJnDTcCoxnaI5ol0ddDzdVBp/djYvGVQj/Bqf6/q2y9PDy0YD7iCfH3bJyFwES/SN21k0zDRQq1lpwbMNTNehPal4RRbOmMoOzqdnNatLh2eQ6YMYDcdlIem1oIlLFEn27pNUbymJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779463160; c=relaxed/simple;
	bh=2foWLkrj8STor7c9+ss1DThiZVazCw8DTA7X3U3ximw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=Ay03CyC+xJS0R4XWJncp2STa/7MtGpp7HmzB8U1ZgXRmkwRX/xeqdvX8SD3tqk0O+rIwnJQ9mP6UgP2TrZBAzBfxC+BdAGt/qISW3fuS4ESD/pQFgujLw4vOzC+machZFNcpG/BZCOv5pJfqLDGsjDL0MrEnIy9BOwo4AdJxtjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=H9FSDw6X; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="H9FSDw6X"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779463154;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2foWLkrj8STor7c9+ss1DThiZVazCw8DTA7X3U3ximw=;
	b=H9FSDw6XpYL2Xv4Yi1q7AsrAg+9PuicmKsn2ln4v69mV+dvyH2VukJNTIeuv+XEK6HgpPz
	pmPfPnK9atTK+pGBWXA7rSob5G6Y7OPgRquxiPRpWIOGVXsNXs8D4DmVwx+FDv8TSTgXwH
	vUiAedhQNyqRq/N4kcfzZ/VRhN1Md1o=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-687-SPcr6a4JP_SepOAJet3SEQ-1; Fri,
 22 May 2026 11:19:09 -0400
X-MC-Unique: SPcr6a4JP_SepOAJet3SEQ-1
X-Mimecast-MFC-AGG-ID: SPcr6a4JP_SepOAJet3SEQ_1779463148
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 84CB81956046;
	Fri, 22 May 2026 15:19:07 +0000 (UTC)
Received: from fedora (unknown [10.44.48.45])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id DEADD19560A3;
	Fri, 22 May 2026 15:19:02 +0000 (UTC)
Received: by fedora (nbSMTP-1.00) for uid 1000
	oleg@redhat.com; Fri, 22 May 2026 17:19:07 +0200 (CEST)
Date: Fri, 22 May 2026 17:19:01 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Christian Brauner <brauner@kernel.org>
Cc: syzkaller-bugs@googlegroups.com, linux-kernel@vger.kernel.org,
	Aleksandr Nogikh <nogikh@google.com>, adrianhuang0701@gmail.com,
	akpm@linux-foundation.org, kexinsun@smail.nju.edu.cn,
	peterz@infradead.org, syzbot@lists.linux.dev, tglx@kernel.org,
	dvyukov@google.com,
	syzbot+b109633ea805cac54a61@syzkaller.appspotmail.com
Subject: Re: [PATCH v2] signal: clear JOBCTL_PENDING_MASK for caller in
 zap_other_threads()
Message-ID: <ahBz5cBxfZiJSfqk@redhat.com>
References: <20260521142240.2973022-1-nogikh@google.com>
 <20260522-enthoben-planquadrat-tanzabend-5072faf6ae6b@brauner>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20260522-enthoben-planquadrat-tanzabend-5072faf6ae6b@brauner>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-MFC-PROC-ID: dzu6CqBw64szB5eSMEbQ6zCExPo89D94rZHmA1Dk9G8_1779463148
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 05/22, Christian Brauner wrote:
>
> It's encouraged to provide Acked-bys and Reviewed-bys even though the
> patch has now been applied. If possible patch trailers will be updated.

I have already acked V1, let me ack V2 as well.

Acked-by: Oleg Nesterov <oleg@redhat.com>

