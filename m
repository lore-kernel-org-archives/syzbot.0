Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 008E54A92D2
	for <syzbot@lists.linux.dev>; Mon, 31 Aug 2026 17:21:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788196875; cv=none; b=cyheF9JZmfUSNfLyAE5v1Qg9G6xj3nA0A7Cbv+l4LEAcSc2qhtFkTUtBtKb3YDhTuQSiPu2+9tEpABe7lczJVTkWxKyj7Rgp2OQA41bNlZGESIf2wvCC86RLEKqk5f2DqHQbF5hluFoUlVbZv1IcFMXXDT++InuY2p73EbC8t3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788196875; c=relaxed/simple;
	bh=A2Fb2BJLLa8WywQNEhyRAqurBRM0sIyaNi+/eNOKGRY=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=it70C3Je86zN+xoYH1GTfOb5UUOnvdWYAjITduTkpKPNXHJ5HpQf6nRh0OGFjqfywvQJpe5FqtTim+6Gvyx6CQyTsPuCFo8nJveu1WK7WO+RLuUL1VmvjA/1+mAUwg+KcJ1MxnVK/FdUJrNWBErPnhdaKeqO2p/QC375Cr2x+gA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TJdwDrhG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TJdwDrhG"
Received: by smtp.kernel.org (Postfix)
	id B899C1F00A3D; Mon, 31 Aug 2026 17:21:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A074F1F000E9;
	Mon, 31 Aug 2026 17:21:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788196873;
	bh=dqs07UrmJC4WYoGrW53i6oe+pcaROH6TcoP+t5hJ+Rk=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=TJdwDrhGZD957gGbOXRtLLUKoT4d+TsWs49Zfp3ZQU1fpxRCncfycPS6E0N2mbKOd
	 V3v2ZfjBphJhxPHsg9AL6qX4MhpmiOKi5LABCFkyRp2VZh6/n9knsMowkya0jApmaf
	 TZEOn9flM5RQLF8poWI1YFi0HnE7YMk1jUvFCwNS86/bbErFLWnd2PWGiS0b9NmiY9
	 RUbGk4jN8Qr8UB9sUHJ7vWe+1tyDyfkQA17LJoEMdn80cpAtnmtH/EXqh+YwF/nE9s
	 OMt6yPhzIXjUtFZL2fok4nx7rgIhX2iaVVdRIpcLUIosGLWh7fc3kzPwjb4uCfTkCL
	 ZmdcZj65dCtdg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 01A693924458;
	Mon, 31 Aug 2026 17:20:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] Bluetooth: hci_core: Fix race condition during device
 registration
From: patchwork-bot+bluetooth@kernel.org
Message-Id: 
 <178819681664.671757.11271710951105188207.git-patchwork-notify@kernel.org>
Date: Mon, 31 Aug 2026 17:20:16 +0000
References: <7f282e86-b9fa-4a3d-8dea-208975771b35@mail.kernel.org>
In-Reply-To: <7f282e86-b9fa-4a3d-8dea-208975771b35@mail.kernel.org>
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-bugs@googlegroups.com, nogikh@google.com,
 linux-bluetooth@vger.kernel.org, luiz.dentz@gmail.com, marcel@holtmann.org,
 hildawu@realtek.com, linux-kernel@vger.kernel.org, syzbot@lists.linux.dev

Hello:

This patch was applied to bluetooth/bluetooth-next.git (master)
by Luiz Augusto von Dentz <luiz.von.dentz@intel.com>:

On Fri, 28 Aug 2026 08:55:09 +0000 (UTC) you wrote:
> From: Aleksandr Nogikh <nogikh@google.com>
> 
> In hci_register_dev(), the power_on work item is queued to
> hdev->req_workqueue before initializing hdev->adv_monitors_idr and
> registering the MSFT extension via msft_register(). For devices marked with
> quirks such as HCI_QUIRK_RAW_DEVICE, the HCI_UNCONFIGURED flag is set on
> the device. When the power_on work item runs concurrently on another CPU,
> hci_power_on() detects that the device is unconfigured and immediately
> invokes hci_dev_do_close(), which calls msft_do_close().
> 
> [...]

Here is the summary with links:
  - Bluetooth: hci_core: Fix race condition during device registration
    https://git.kernel.org/bluetooth/bluetooth-next/c/78f08df9649c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


