Received: from mail-io1-f70.google.com (mail-io1-f70.google.com [209.85.166.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F12B2E7637
	for <syzbot@lists.linux.dev>; Thu, 25 Sep 2025 07:19:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758784744; cv=none; b=RUq7WGUGDssVPxqPlrKo2NiaB5VQN3NOt6z9eZ6oyzTmLFBlJEezGCZtlsvwuemTiHfWt+oZEA5dNTTaOhRgPRvQtbpoNX89EqOyhAExOC6I1xpQDvk5s0Ebt5J04J54L69FdAxouzd6zO4P3J1GR14hQE7AyChEQriHYm/zJM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758784744; c=relaxed/simple;
	bh=Ka6Xvi4Yww6lCaGWo00VHFXKK6uSJ9eN8nTKNsJT8aM=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=ZIlehuudlIUsLseLRBMGNTdp6BYSwl3sZtGX2cnLC7Wxh0FPOKGkzvPMNja2CbnFr/Ik5AktOLlAEYApEDl77nQfRiC4tJtcGWyWAVb5uGFHAd1X2AGzSCwwzc0tSlCddCV1oP8RAGvOO/AF9Ac8UtehIqNacS2tIRQKaCdph14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-8874f33d067so92557039f.3
        for <syzbot@lists.linux.dev>; Thu, 25 Sep 2025 00:19:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758784742; x=1759389542;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ka6Xvi4Yww6lCaGWo00VHFXKK6uSJ9eN8nTKNsJT8aM=;
        b=UK7CttYUSAEhECnzCEkKQgtYJExsXtgz7VC8ub1ObmZuFT1wSt4xFYU8hUYhN9QiBt
         e3/Mqrftn6dfngVW3aljtL80oMN5T3XQF4ESYmV2RzFO2LZcnxWOWdcanaDzgkqrpX/Y
         7c9NuuWhfpmuofhAz0pJauDn7ZqHJYBw626wH9BTvGPxLkE4CSVIVhj97Aq1UvouLLym
         3kxM2CaALvjtR/EfucgmL8DxSkaulbePR0Dmciln5RDAdl8H5pzBqkJ7cmI76vS8JcDq
         qDbIaG+trZ31w3xatF2p1VvO/plLNfsALqxRvIKajxr4GTy+y/Z55evSg/Cjg/oTFjQu
         aCdA==
X-Forwarded-Encrypted: i=1; AJvYcCX6lxr4csI0NENDoKo18V4WkijmSxNt4ggl+9cxe4KtDpQmCkOIOnd/tEFYSYUI3lQ/FxSl+5A=@lists.linux.dev
X-Gm-Message-State: AOJu0YwbQnQshMkPjU2ovYSauoyPxQDNunwS4r4zsHuuXr6vqpSgYYlM
	FOqYg6S7cqsAIRHOAcAv6jrI3fiXKFHhmWoaNTrklS/3VwWsmvAaoSj2RmWuVBIq4dMCQlFx2YZ
	CYtaD7FcSY41inUOYgKv3ZI91kQHQZWPsQSgPNCw9xO2Y5uoEi9LyjkNjpX4=
X-Google-Smtp-Source: AGHT+IFhvykbd4EPbrKfpqQ6rCbpWctQsXUWlvAS1AXrjYMd7F7GLkmW3ZINEeZTv6e4obpuAhGzkd+zVdFxfjKZ2tBjxKdeeQcI
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1aae:b0:424:7ef5:aeb with SMTP id
 e9e14a558f8ab-4259563befbmr33661665ab.17.1758784742302; Thu, 25 Sep 2025
 00:19:02 -0700 (PDT)
Date: Thu, 25 Sep 2025 00:19:02 -0700
In-Reply-To: <CANpmjNM7cCDoLUGV4J+MfAbQFedmEXhNrhf7fYiFs7Gi7Yz0mg@mail.gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68d4ece6.a00a0220.303701.0004.GAE@google.com>
Subject: Re: Re: [syzbot ci] Re: fixes two virtio-net related bugs.
From: syzbot ci <syzbot@syzkaller.appspotmail.com>
To: elver@google.com
Cc: alvaro.karsz@solid-run.com, andrew@lunn.ch, davem@davemloft.net, 
	edumazet@google.com, elver@google.com, eperezma@redhat.com, 
	hengqi@linux.alibaba.com, jasowang@redhat.com, jiri@resnulli.us, 
	kuba@kernel.org, mst@redhat.com, netdev@vger.kernel.org, pabeni@redhat.com, 
	syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com, 
	virtualization@lists.linux.dev, willemb@google.com, 
	xuanzhuo@linux.alibaba.com
Content-Type: text/plain; charset="UTF-8"


Failed to process the command. Contact syzkaller@googlegroups.com.

