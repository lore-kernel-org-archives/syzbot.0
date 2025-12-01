Received: from out162-62-57-252.mail.qq.com (out162-62-57-252.mail.qq.com [162.62.57.252])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA3B81F09B3;
	Mon,  1 Dec 2025 03:41:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=162.62.57.252
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764560485; cv=none; b=V1hiZPtJT4BOGAd72jnGHs1lAsoI2Q8VImUv86v/QPBiFPaHs64KrdhF8vnrTDMnj0PAsk3mpfjg75idktYkqI0TgaFwjpDpYP8qdcv3AD73J7mPrZwCinfu7B7qBBecGzLyJ3jAgxi28MSzj8LS1296RXvKCM7MQdTn5goMBdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764560485; c=relaxed/simple;
	bh=leCy//KoczHnqhz2R2YoPDhsJC6dgrFmCg+gWRwh7T4=;
	h=Message-ID:From:To:Cc:Subject:Date:In-Reply-To:References:
	 MIME-Version; b=NBej2KJHNXqUQqVWpQOKMvTFDUuRVqqVnoLbGAvk2S9vSKZhETtVdkkHqHCyQd5V0XYxhxGY7uVQltLzgIK8Ii+Lh1yAc20YcCRoac7LJz4bBdchCdqsd8z7i51WwWcdacU8VdcpBJcceT777fXwXzGPgUtuLNT1GbhCM/oB4ao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=zrNYlckH; arc=none smtp.client-ip=162.62.57.252
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="zrNYlckH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1764560470; bh=h1ElSL1Dua1skk8vctxiE38fat4PN7OeW8/o828lFH0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zrNYlckHZ29+sbZuH9lr99zbht65ADgBrT3M3JyfW06Iquh2IdciCnWyq/Ix8aD82
	 SHPaKYnVuDacKN3rjr9u3cqBDd2eJ7z382WT9r9zyiyYZDwNtxafQ+qny0K0TYZcQD
	 gS4e16spgpBMXAnTTldE0UqeHF/Warl9LwDPonJ4=
Received: from lxu-ped-host.. ([111.201.7.117])
	by newxmesmtplogicsvrszb51-0.qq.com (NewEsmtp) with SMTP
	id A4628C90; Mon, 01 Dec 2025 11:41:06 +0800
X-QQ-mid: xmsmtpt1764560466tv4m7kq4c
Message-ID: <tencent_7B73E6D013636363696CC3A34444F77AF705@qq.com>
X-QQ-XMAILINFO: M1rD3f8svNznlXm1wtdwYLpaX6NI7m7ByGt+tAfGDFF8BgBVgBU80YYV6OZs9/
	 gcY/Piad/qhewzLPwuV6BMcBWBTLZEie7bvFNEg+wIq735cke7o6NP/VBDpAgH+9Mmntxou+p/RT
	 +zJDJFLXvnHWK8vUtE4d4NsFNZ2tvH3hmF1MkivD2geXIoKsHb0e14GN9RWpzneXjpyjyhvnWdEm
	 0b3lORU9WItCgu9bLGMJL4jDlXptvmZj+jI6zCZoxmhtZ+Q0UFxApFfYuvYkuVGyTTPg1tVJkGqW
	 pJusXEdL25gPBK4NehgzrgZyRItZsVGx0n8q/fm3O3QAfLAoJtQ0C3X2kLeukTqMWbe15e5QSXBe
	 wTOedVbVCRUTKWpTalubRdI9OAWaFAdHlLKGaM1WKa+b+ujrwnAdD7CCgJXUvmv3NZvI0klw1Qxc
	 tTBehPxv+fbFYoCuZVMwfv0i8PojyO7e+66rq70IzngkdhfY86uDa3tuaIMDVIRehKmP5ivabJ0T
	 og0pEEf3c931ms1HrqP8wTv7wVG1D54uORehCKxrwIaug/fbMk3VWvp2XKgceVXQD7Z+t/pqRw0W
	 o4/eOurfxJE7S15h6D6xafRauGnXXlagotaLgzJL+8VbRf2crCNxeVY1ZUv5PJblr3AO8LGJM5SM
	 vGb43NI4lrKyljLEuQDLibHsGH6Tzco4xtX5UWi1Bcpc0JCY7LVMMGSmnyHT2CxxQXa/HsH9WNEC
	 DutOMuFdQMy95sL0dlPw0eJPlWmEbHSrHdB4jGxId0VjVOu+sAhJv/zlHeyvFFNv9FjDQgPMSgzX
	 5uGwcui810S5yNIhX/7RUhM/rHNeLecqJvkNzHOGGRWsiv7TAmbWfw+o0sYQ/WkoMdQIag625WfU
	 IwHP6EeNFUsLUYh9zsE4uR7thsUeqImvfqGlTYMVvmGFlyVdWwxWwp+LPhgDLhsju16TMoUFIgIV
	 E+eTCVAqg2vBezwVz96fexbPF/TPGTgcdfrhQfQ7AiZPFJMAXu/Lx27IHx2CEOa4aV5Wo0yHEbXn
	 ixccxcLUM2rv0fxa6Xp4Bf6uHze3w=
X-QQ-XMRINFO: OD9hHCdaPRBwq3WW+NvGbIU=
From: Edward Adam Davis <eadavis@qq.com>
To: kuba@kernel.org
Cc: davem@davemloft.net,
	eadavis@qq.com,
	edumazet@google.com,
	eperezma@redhat.com,
	horms@kernel.org,
	jasowang@redhat.com,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	mst@redhat.com,
	netdev@vger.kernel.org,
	pabeni@redhat.com,
	sgarzare@redhat.com,
	stefanha@redhat.com,
	syzbot+ci3edb9412aeb2e703@syzkaller.appspotmail.com,
	syzbot@lists.linux.dev,
	syzbot@syzkaller.appspotmail.com,
	syzkaller-bugs@googlegroups.com,
	virtualization@lists.linux.dev,
	xuanzhuo@linux.alibaba.com
Subject: Re: [PATCH Next V2] net: restore the iterator to its original state when an error occurs
Date: Mon,  1 Dec 2025 11:41:07 +0800
X-OQ-MSGID: <20251201034106.206190-2-eadavis@qq.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251128093946.18c645c6@kernel.org>
References: <20251128093946.18c645c6@kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Fri, 28 Nov 2025 09:39:46 -0800, Jakub Kicinski wrote:
> > In zerocopy_fill_skb_from_iter(), if two copy operations are performed
> > and the first one succeeds while the second one fails, it returns a
> > failure but the count in iterator has already been decremented due to
> > the first successful copy. This ultimately affects the local variable
> > rest_len in virtio_transport_send_pkt_info(), causing the remaining
> > count in rest_len to be greater than the actual iterator count. As a
> > result, packet sending operations continue even when the iterator count
> > is zero, which further leads to skb->len being 0 and triggers the warning
> > reported by syzbot [1].
> 
> Please follow the subsystem guidelines for posting patches:
> https://www.kernel.org/doc/html/next/process/maintainer-netdev.html
> Your patch breaks zerocopy tests.
I see that they all timed out. I'm not familiar with this test, how can
I get more details about it?

