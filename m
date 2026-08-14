Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 798A23DB337;
	Fri, 14 Aug 2026 03:25:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786677909; cv=none; b=fah8uSgCAph6/AiDI17LrPwC/mEbxRDbZgsH923km3cwUhahsAb7e0MKX4mYC7QuwTQKlUdiJlDUjhUlP0c/zmKscJ5b06JZCOOb7eL17dmPxsLn19fSXiGiBZB2K3jNz9HyqJ4X55xHO4PXxQjcOhehwBFtdXS59EQ2KYdMrR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786677909; c=relaxed/simple;
	bh=rrJLqI5L3XDl2608oj8KosFurOpFQrUYdFPe2EsvyOo=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=YNo7qQ7UYgUmQIkjy2AbCeiZLKatJDHUrh7QXM13ZwyrsxC0013gu3D6XaiySofQPdp2Ihsi7XPFToUHXQChrldq9Ldaly05lLpgFq/KQF16wD6X8hY/QkT9cHpdqGbotXjTeD/UseyQmukp9tptq7qYHy4+Qnwbmkj5LqKeHq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VzacpZbi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VzacpZbi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29D521F00A3A;
	Fri, 14 Aug 2026 03:25:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786677908;
	bh=iH8eSdEYw4RB1vwQf/Hy10ZBq5zezQ1OD40p5kCGoYw=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=VzacpZbiRwyxeqc9LKxXTS1BJBPiKaK8AQaMOqrBofFSENutHQyBLCD1i4g4mlHay
	 h1Kjtjx/87QMOEp1m2Kimph69BTWI6HyrD8Pk52J63k8/iHKFce++NWXxrXu636IP0
	 Xx3B2k2tTTmgYGh0/4Zll5uM31Ji53WQ4u63FSJKIcrnakbinqfoV2xOqzrTJISqOw
	 lJXldtxRpSbAH3SrjEwKDull2bXv2N1sNYu+YDvZgwV4lVPnviirfeRm17XOvdM21Z
	 DVB/29btucxPA2x0tVF/1n1sxGLXm6zrMmQQMeKKr8ThxCFZ2rL8xjECc8u2ySZ/pG
	 C4moMYBLlAs7w==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id D09EE3810900;
	Fri, 14 Aug 2026 03:24:23 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] netdevsim: drop the ability to change max_vfs via
 debugfs
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <178667786239.3150297.10278646018244471870.git-patchwork-notify@kernel.org>
Date: Fri, 14 Aug 2026 03:24:22 +0000
References: <20260810085717.570382-1-sst@poczta.fm>
In-Reply-To: <20260810085717.570382-1-sst@poczta.fm>
To: Slawomir Stepien <sst@poczta.fm>
Cc: kuba@kernel.org, andrew+netdev@lunn.ch, davem@davemloft.net,
 edumazet@google.com, pabeni@redhat.com, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
 syzbot@lists.linux.dev, syzbot+3147c5de186107ffc7a1@syzkaller.appspotmail.com

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 10 Aug 2026 10:57:17 +0200 you wrote:
> This debugfs file isn't used by kernel's selftests, so drop it.
> 
> Reported-by: syzbot+3147c5de186107ffc7a1@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3147c5de186107ffc7a1
> Suggested-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Slawomir Stepien <sst@poczta.fm>
> 
> [...]

Here is the summary with links:
  - [v2] netdevsim: drop the ability to change max_vfs via debugfs
    https://git.kernel.org/netdev/net-next/c/b3217bdb0091

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


