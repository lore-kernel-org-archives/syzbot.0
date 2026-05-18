Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B580F495505
	for <syzbot@lists.linux.dev>; Mon, 18 May 2026 16:53:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.173
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779123222; cv=pass; b=LdX8TI7cgiTrfhyk/ywfDYNws9m7V1k1vtQ/rX9xzMWp/JKTmBmTXelQU/TfT2mWeZEKKgkQ1LnE7GFC3zUGc/SUfrWZ7OOecDrQwkHYEHcVA5WD+qqfZDdWa9Zq8xCa8uX6uN3e2gAV0GygT+94mDuuw/YhHO17X7eNMzenLR0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779123222; c=relaxed/simple;
	bh=x+r14v4NcgfqM+BoLOUWBvhLtJ/fJvWtGOg0SdTAeC4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=U91Tp3CNUHrlfoPCO7S2+QrZjMBW+S9SX17bHU5Psn4n1OuK5FWjTcOU9cVLWFELRPluiGHk1qKbR/xnkoUmrgczTtq6iqjpCd09vH+XMDvzxmjqFBxS1LkObhYXJX94sbmORN3jHFeeTaJW3k+xI1MFlwaebwbFbkGf6g6mBrs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Ubtb6IIA; arc=pass smtp.client-ip=209.85.160.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Ubtb6IIA"
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-514ae601df2so11296051cf.0
        for <syzbot@lists.linux.dev>; Mon, 18 May 2026 09:53:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779123219; cv=none;
        d=google.com; s=arc-20240605;
        b=Oj4yfHZa+IKrBwYCD7RkqDSEe6voTRlkLwUSb3e4w4NDmZoow1bN1LSnQ/LXxxPDPQ
         pvO6V7GYROuC6z13NI5hh0PZL2CFNYpvUX4xXHvksZBIxw2t8s0mg7fiDitJXJATjZ8q
         JZ2KaNRmlmK6kSq+EweLaVH2HCvDUbym5r9D/57z3PBD+KDDc2Y4Lu1PqSVKYMihMBFR
         WYwNU6eeTGTodnkwmuv+ibqzmabC3F2A7rcvHqpf4EIJGvb5Ciet6rLbSaQ4P0OyLhvW
         ywzSGMLbgnltFzRRiBtB4Iij+7h5HqNsk+PVTRNj3gG6ftaxJxMXigfLMDEkyWIiKz+Q
         ZAmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=lZU5aZ2FB26+Pbl9hgcLSa+cp+VkctUsnWHJjJyyE0s=;
        fh=prVAj1b1kGsa03HLP4+Pr91laWIcCXU3Y5qK9eFt58w=;
        b=Cj4R8UVEUekOdkR3qXypcMunYabVzeJoZ7iL9C+cNzcMdLMk799/jTyrnBeT/PmLHJ
         6jClI4xW71Xl6mrTzimW+XmL1etdBvDQUEkrlUmis5IriH10jGPQ2udUsDKOH8RU53Cy
         K8eb/HcbommVsuyIU+vAj62XFSeerlbIOvupDzYl9JFTsSRMID3vafpyGZOC4cufZlan
         7bZuUPBQSV4mdgoxUfNPIKfCayBH+r3WR3Gyjhzi3Crh0575DVAm7H0rYDMCDTfOsXX3
         lLUVfULp6sBU41oA+0lTAx+p1CHWH5JuxCN6iG5hxMcjHoMp0NxJERsld2BbooYbuFu2
         6ZMQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779123219; x=1779728019; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lZU5aZ2FB26+Pbl9hgcLSa+cp+VkctUsnWHJjJyyE0s=;
        b=Ubtb6IIAjIOIQHl4VQ8AgwDrwDg2pB/+4gkAX1wGsIVVbwuPm281NQ+Zhfc3MaMqWM
         3kOB/SHHaQGVddtSUf1WqbrxY3jJzeMsm8bCZ/nsobu+nqYrVT4B4j1v85bWpo9d6kas
         CEI0xjl3m/wuS0LZAdZ94Wmk8fWUITxV/r9+A8UIFCfSN6qhIC3uvbYWhQSmsyZiwR0s
         0yo7h0Qm6GXJAv2IjoM6rL+BW1NPNffu0KMPyRXsVhl/4e/RJw939nCQZ99IwDjwEval
         MxqU3ujNnVAlz7n9ja6EtsBuQb6rz7CuJJ34qpTdybk1XxKszz15sRaoFAyzXn2yh2LM
         5xEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779123219; x=1779728019;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=lZU5aZ2FB26+Pbl9hgcLSa+cp+VkctUsnWHJjJyyE0s=;
        b=IuSPvlTaZA78ajHaASBBsiSJzOqtBWgGLsXlrGUFSMmEL7YohmMu6/33vW2FAE6hsX
         DmGvuKXkTG36BEWFSBeN4gjfk2iY8vY5sVV5Mysl1APls5l4sV6sHJ7UPxu1jGLDyHKE
         m8tuV8/L3MkhZoQIcnRrO3U3izuPMViuoe4oNRHCCKMxhGsYiWenu4ToUKAvIoCgGT+R
         NJFadLYvmv3Gk9sJjxtedKt2yov1THYOvmUX6NjLb0Wgr3+fgbIgF1CcmYQ2zVPf90zV
         38lvlSRFugaIs6h+F9iCVGMC8+GdiUEGt2VttXn7rmK8uXy55ptSWjrptcXlmY2zgsMz
         h+HQ==
X-Forwarded-Encrypted: i=1; AFNElJ/oeHSz+SbjC7PseRmA9chNih3uihE8eYKPwczVMCxLHIXWfINZzpqa09Nzbn4bZHifUGuLYHQ=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz7tD4us2j5LYjKkqeN9vOqrLM/nJ4R603pqxAzQqJqXSdhY9QH
	Z4uEy0QLTDKM6zzhaEfNv/E0COZFa61Kx7sE/NysycJp5t5qgCkq7Fc9zPDbdA3kaag8VaJM5+A
	Rf4x27N3TgF4wcM9Ir9ra7FdzFFKZhcxbO52ycAEb
X-Gm-Gg: Acq92OG5Euu1lw4LiwF9mjwyBFG36PBTFjUPFrubKJA1e6fI9o6sH68ccOlfARbiPzv
	W7dXCJglCqkQr8FzyoNHi+gZX99u5lQ4SSduljoONg0rtukg0owXmnLEgtI1jyL9VW8KNLKvfmF
	ynOJED4a7W4jKeEXiEWHd+YDHHAODgPgTOS369JxBWW4gVzN+V3Z3lbAEihoNoKWPEd9ETnE8Wh
	O2JVoW7EdjuVtV0ge85qC+tA67eR3Z/43soSEXc/2d7dgXNTQu4lx0ScOJ5LKamRWBWmUz5OfsD
	8SWWJUb/xkYK8eweTEUMez6bo5p+VIzBlEy1yUPd82sjeVFWmgzuLzXBnqDTNsNpsKU+odiLrvK
	VoemJAFTZMGZ02pUTwsgaEKy/eD1rt6bkZIEilcWQv1xcpK3JH8SUsgC1UNE0Ibbh
X-Received: by 2002:a05:622a:1aa1:b0:50f:b2e6:c033 with SMTP id
 d75a77b69052e-5165a29e0a5mr222360331cf.58.1779123218561; Mon, 18 May 2026
 09:53:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260518100134.809042-1-edumazet@google.com> <6a0b409a.a70a0220.202581.0005.GAE@google.com>
In-Reply-To: <6a0b409a.a70a0220.202581.0005.GAE@google.com>
From: Eric Dumazet <edumazet@google.com>
Date: Mon, 18 May 2026 09:53:27 -0700
X-Gm-Features: AVHnY4IywEJqZc78JgSJNP5UAI8nXBFQDchsRYDpjiLSabtzqOaMRwZOorrTfFY
Message-ID: <CANn89iJH0Ofh_+Aza7kCvnHwU_PuaNby+9JyzG+5g-eo3bQL=Q@mail.gmail.com>
Subject: Re: [syzbot ci] Re: rtnetlink: RTNL avoidance in rtnl_getlink()
To: syzbot ci <syzbot+ci0e37b1eaa858ac77@syzkaller.appspotmail.com>
Cc: davem@davemloft.net, eric.dumazet@gmail.com, horms@kernel.org, 
	kuba@kernel.org, kuniyu@google.com, netdev@vger.kernel.org, pabeni@redhat.com, 
	syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, May 18, 2026 at 9:38=E2=80=AFAM syzbot ci
<syzbot+ci0e37b1eaa858ac77@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v1] rtnetlink: RTNL avoidance in rtnl_getlink()
> https://lore.kernel.org/all/20260518100134.809042-1-edumazet@google.com
> * [PATCH net-next 1/2] rtnetlink: use nla_nest_end_safe() in rtnl_fill_pr=
op_list()
> * [PATCH net-next 2/2] rtnetlink: do not acquire RTNL for RTM_GETLINK wit=
h RTEXT_FILTER_NAME_ONLY
>
> and found the following issue:
> WARNING in rtnl_fill_ifinfo
>
> Full report is available here:
> https://ci.syzbot.org/series/c0efec5e-90ce-4ba2-8383-16d7bc172521
>
> ***
>

Hmmm.  I thought I moved the ASSERT_RTNL(), but apparently this part was lo=
st.
