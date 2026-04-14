Received: from mail-ot1-f71.google.com (mail-ot1-f71.google.com [209.85.210.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C249C38E5CA
	for <syzbot@lists.linux.dev>; Tue, 14 Apr 2026 08:08:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776154090; cv=none; b=mi20w00c0/0lusdHcUHRMOCzq3r5BVKSb2Is6EEtxYtDfADrtOC0KmY3dT5tkUPyjdIcBeqaGUlAyYReyATU8BhDQ6a75cAczcBeUBEr+zwgR6Hkln6MzkUd2ZI70xwqILlZvlpnPZtredwVUjigSxCB/cKcxcfYbZDbpa3BwHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776154090; c=relaxed/simple;
	bh=NCU7HC1t3iEDC4IqX2izve0FBoiDBcxRNyhBdT9YCoc=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=sK7/tvRRY0GyIsVjatPO1GAvf7xWZdnZfYe+A3jVYQUvAJfzd2G2VbHsbvgAgQK9PS2EVFh6m+gzSKf17Lc9mhTKVYXSkbjC4L0SKzm1H0Tf1FuB8SvGRNCQspBihylr/yEGSrN/Yy62HgPgvHF89aS/bK9/S040pg+zXBQInIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.210.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f71.google.com with SMTP id 46e09a7af769-7d7e995a87cso1344836a34.1
        for <syzbot@lists.linux.dev>; Tue, 14 Apr 2026 01:08:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776154088; x=1776758888;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NCU7HC1t3iEDC4IqX2izve0FBoiDBcxRNyhBdT9YCoc=;
        b=ZmfTSIc+vM5ItkoW8ZAuXWrRYB71WFMGjB0ZdF8Xw6hVg0QFBRPwcarPxpqbL9d6Zr
         jUb7eOFr68wVLCCDGkf2T3BPFGONwGeRH1QWREByhXbFnwiKu0l0rTGpfRE0DYoNuRy1
         UIHi6hx4FYcmY6ExMsVSMl/f5xJL7esCI3+8km2q9buJr8J2q5bVMpJzTXareFQqAur9
         rGjlEir4rSpsq3U/aSpMjJwfHTgMQYzvdxQ/1h0/Z3bjJc/hAUGphS2Qpy/4WhWfNJ/Z
         56secbvmGiBNktahWUA2xGmUZJnFerzZg56Q7ahp8ElyJi8MPx2C+HeBgL+bRELKF/am
         DwPw==
X-Forwarded-Encrypted: i=1; AFNElJ8f0LQCccOS8XcSsGnjS0ddlZkuPsCzTwuUWcPeZDobuSWAAMVSuR6z2r+VIJOCSwWSTIroD64=@lists.linux.dev
X-Gm-Message-State: AOJu0YzHyp/Mb1SLVBPhV4yeGtZrHX/Spp60QvsiS78O2tFH+ifGzPbY
	NNykDG3687UAOEKqmt0YBfkaCblnQsFXWF0lmfKtWxtBq/O16VVAvjnNkPhTHfpNBAyKPjR5CcV
	3hCADKxKEylko64UfWfkeA3hKjaBhf9jSBUfkpyqCWwp6Y4F5kut467uEydM=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:8183:b0:67e:1c67:ebd8 with SMTP id
 006d021491bc7-68be7ee1b88mr7508599eaf.40.1776154087806; Tue, 14 Apr 2026
 01:08:07 -0700 (PDT)
Date: Tue, 14 Apr 2026 01:08:07 -0700
In-Reply-To: <41689f2e-8786-49a6-912d-f65e48245a61@kernel.org>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69ddf5e7.a00a0220.468cb.005b.GAE@google.com>
Subject: Re: Re: [syzbot ci] Re: veth: add Byte Queue Limits (BQL) support
From: syzbot ci <syzbot@syzkaller.appspotmail.com>
To: hawk@kernel.org
Cc: andrew@lunn.ch, ast@kernel.org, bpf@vger.kernel.org, corbet@lwn.net, 
	daniel@iogearbox.net, davem@davemloft.net, edumazet@google.com, 
	frederic@kernel.org, hawk@kernel.org, horms@kernel.org, 
	j.koeppeler@tu-berlin.de, john.fastabend@gmail.com, 
	kernel-team@cloudflare.com, kuba@kernel.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	netdev@vger.kernel.org, pabeni@redhat.com, sdf@fomichev.me, shuah@kernel.org, 
	syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"


Please attach the patch to act upon.

