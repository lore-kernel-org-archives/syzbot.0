Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com [209.85.167.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31ABB3FD13B
	for <syzbot@lists.linux.dev>; Mon,  2 Mar 2026 14:09:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772460551; cv=none; b=Ucxz2vyDH1aPUwUuWOEW3QNPL8lWCyX8G/CuTslGJ42Mk6snydVwg5GNeFrw+pJDqbtiuMdeW4YInxri5XyG01eU6c2OXRZ6sNzq8ivAHcWznNqSjLoOtZfp4sF7+3tMcc+Kx881/EKSyCGYZ5fWUq7JZ0FMZFWqqtDJ7jN486s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772460551; c=relaxed/simple;
	bh=Ka6Xvi4Yww6lCaGWo00VHFXKK6uSJ9eN8nTKNsJT8aM=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=Ym9oV/spsoxqhRdjmgUsq0/DtwcHN+JJvc4Fxli+Ngsi44WZU15gI1t7gKtwHUMlZvl9tnkVupF2RdAHZZufFbzCdDDWkJk+4K4/3g+Z+ukLvBbOmRNVmwCs5hASPB12orzoI6f9gJp28tcbCt2J0vSjwJXghwoR82JhyjntjKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f197.google.com with SMTP id 5614622812f47-463b9608e16so53789782b6e.3
        for <syzbot@lists.linux.dev>; Mon, 02 Mar 2026 06:09:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772460549; x=1773065349;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ka6Xvi4Yww6lCaGWo00VHFXKK6uSJ9eN8nTKNsJT8aM=;
        b=FT601BQUea2JTerRAgtfVWCf59DHA4KYo4EZMUjE+HZgOqyM4vDA23IHYhQIESq2iM
         yPjdLPf5IPu0WuwThYdwzmvmLhh87ayXvOQHpdYzmQWIYLYlHSaeca2pyCNemju90ogc
         33CXrzrRXnzYNZlUhfCN4pFw+KUixxGjo6etxpEgnMudPDYxG6gkJagX1aspIcTZZf6g
         U6G+yaIWdcp0/nNFgEZtfYqN+MKkjfhFL0SNbRTJ4mVGyh7sti2t/F/H8lMxBsPq++aq
         iY5SP0GY2CkeisnTIYDN5OScpLxAkapQHBpBRnrumC7vO6+sW2mO7S0wGA9mb3nGQCIz
         KRvg==
X-Forwarded-Encrypted: i=1; AJvYcCUl0Bvhx0eVW884pDSJJVtbLxBlF5POGN4ocoIMnonThruzx+ajjPY6dEH/FtOoiYoqztxQcXU=@lists.linux.dev
X-Gm-Message-State: AOJu0YxYQte08/T5cR2NAQFH8Lx2moqrA187H3YfQ3/pCmXOE3Flibew
	7yCMnBVzxMVxcOVelwkrYwW3Ej0q8Vx9oEx90JudIoG4xInUBbBS8VMDhXujMKg1lmBWSWJZltW
	abEKhtZexylGF4E7bcrEIkzY5HiQgsWoRoJev2dWqW0AEyRZRgXphxj2iIIA=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:2107:b0:679:7aed:9529 with SMTP id
 006d021491bc7-679fadb732emr7481417eaf.1.1772460549093; Mon, 02 Mar 2026
 06:09:09 -0800 (PST)
Date: Mon, 02 Mar 2026 06:09:09 -0800
In-Reply-To: <CANp29Y6bdewVP7aeMAVpoY0KSzzXMg4BP-wp=1L40W0aESzspQ@mail.gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69a59a05.050a0220.1b9591.0007.GAE@google.com>
Subject: Re: Re: [moderation/CI] Re: ext4: avoid infinite loops caused by data conflicts
From: syzbot ci <syzbot@syzkaller.appspotmail.com>
To: nogikh@google.com
Cc: nogikh@google.com, syzbot@lists.linux.dev, 
	syzkaller-upstream-moderation@googlegroups.com
Content-Type: text/plain; charset="UTF-8"


Failed to process the command. Contact syzkaller@googlegroups.com.

