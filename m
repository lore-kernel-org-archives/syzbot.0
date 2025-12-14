Received: from out203-205-221-242.mail.qq.com (out203-205-221-242.mail.qq.com [203.205.221.242])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E34D11FF5F9;
	Sun, 14 Dec 2025 02:49:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.205.221.242
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765680588; cv=none; b=uyS5WXC7euxtnP/7tVWw3cWr6TFol5WWqqutNCM/E9NbZZjDJrEYCFbMxJE93zVWGj9wb+epnIrFEy9/YlA2oSBcGHmUAXAOlL6qJhkS0TqxNtmFwa8+m4H9bQf2AhZBePIt6LRfMlJKUMR0C+LZSCyLbCcxTD95vrPlcqbH1Ow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765680588; c=relaxed/simple;
	bh=nN7B3Qdh5Nc5GqxXdyl95sJL9td2JS18OMmoBxYKWTM=;
	h=Message-ID:From:To:Cc:Subject:Date:In-Reply-To:References:
	 MIME-Version; b=SXV0Np1I59Epz786FhdPRWQGUgQ1uWuPxPyvu3ZL5/+ODoKRidBvumjc1iLCJBzpuGsfDbLntpAkoKI0naWw2dTRwkin6xTdBvjYB1yf61NQFlarq07u6w5AxZwm7ZkTHjO/Zfyay6kaFeTTHDa6wjeb3XZjm3wN/brTX62sKPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=BWLcDRD+; arc=none smtp.client-ip=203.205.221.242
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="BWLcDRD+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1765680580; bh=K2OZpHYHYZfWcCHPoZC/EThAw3ioCUEy54sUZxS6dz8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BWLcDRD+7A9911K+fi2EdNHjWakBalYHdcptpok25Gsth4EaXC5WrqSCb5W8vgtjs
	 aHTCtlpfWkfLy1jeIIFmF2RVI3Pd9061XawYGBRk/78KPVnOEbvfdxGZHJI6bHCbgb
	 lmoujIUpf0vZkgrwycD7NPwdk3HInnzxtA/MeFfI=
Received: from lxu-ped-host.. ([111.201.7.117])
	by newxmesmtplogicsvrsza56-0.qq.com (NewEsmtp) with SMTP
	id C62A4629; Sun, 14 Dec 2025 10:49:34 +0800
X-QQ-mid: xmsmtpt1765680574tmqa0m9qx
Message-ID: <tencent_922CC96DE097F8E8EAECA6CED47BCA6C840A@qq.com>
X-QQ-XMAILINFO: NQp/UN4soYLTE6XaGnoCUWXJp5y/lq1f7iO2t7sZtSbsh4Qdr/QfObtsCXPKAy
	 73IUanxQx0OLkY2WTV931kJDMcjliNFTQdvhiKGPrbFC2Bq04eC821g1s9FjwndJd4Cl6dqEnQYG
	 5u0hoX8lHX1/DHMUguz5i6Q4d+gRyNIhxPrTxFePG2SAWXEY2YWRXhGRuJABh66NbGFQsMniDRrG
	 U2PRsZhGnH4cL4ojz6o/zsJX5hZWdrwyWlWLUmtqkvdOvCM9hal3v9uLkE3qCeDCJLR8rEorg0tK
	 e64pG9C5HzgK7UgbIBI7eUWg4uN5nI8kU9XPVHJVG0ksiSZtZ4jHdLbTDzquVtcucHBqJNCphbDD
	 Xq4UAF5Gn7ky6IJKgJX8n5s/d04MNDG86vj+IrR+NxpLx3Z3/k5SlpnKqiD6ZDpVFRJpspbQboIB
	 BOYgbO21S0BFaJLH5XeGLEdjWNKTo2dyB1ob4VzLQ7U3v3Q1lf1/DMuRcfZpMQcrWzKm0HdWou4x
	 +JG8Pr30gnJJKnygzlkt+FVEWdGwxJWyu9Fa2MEwXkoSE2rO0pKa0jXy77wcHLnV8+cr4G83bJGt
	 Opf+S1B08M5kU4pDLMcfr7b1K+j41B9pmvU/DJJ04KLH9zyRw0YmHdGfdD6sI0riSz0wpLqYu9f6
	 8wTP4IZiuMBxQYJS7PGFeayPCDAXXn4IZKXZtQFN2RQxDduNnFZ0r71l+30OYMFI/t/xAbDEUTwQ
	 7bOJCnMOW0GRStWNhvlDcq8zXXhsl1W3cRZapET80HUlFlWrgD2PVUemiwnxrC9LAQ2m/fZqptVv
	 QVzcEHKyL+PaBiXCAtpeVMVj+YilSISVmXjIzn8t+Qrih2CR/xUw+Lb3hA1uXfjKvSdVxfe14ZVb
	 Uu4XD0YQkklEE9hVfXJB/YdNh4qc+wY4UvoDFN/aPxnxiXEHdJIPd63V8h8unLVW893FlxXAdVXh
	 GdR1bt1+b7GnLjU943u4mk0Pvz+kcHMQlkG4zB41Q2u34jE+IRY/fimGF4c+Npm0/7AIkh68momw
	 +ZyRLvPxf+LB0fjjqcARM/wZE0gze4jpD8spHj3XkFOPoTAzZX
X-QQ-XMRINFO: MSVp+SPm3vtS1Vd6Y4Mggwc=
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
Subject: Re: [PATCH net-next v4] net: restore the iterator to its original state when an error occurs
Date: Sun, 14 Dec 2025 10:49:34 +0800
X-OQ-MSGID: <20251214024933.62895-2-eadavis@qq.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251213083717.44fb78c4@kernel.org>
References: <20251213083717.44fb78c4@kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Sat, 13 Dec 2025 08:37:17 +0900, Jakub Kicinski wrote:
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
> Please address the feedback from previous revision and when you repost
> use net as the subject tag.
I have added the following explanation in the comments:
Regarding the judgment condition, I aligned it with the condition in
skb_zerocopy_iter_stream().

syzbot reported the issue in the linux-next repository, and I also
tested and created the patch using the linux-next source code repository.
Therefore, I added the subject net-next tag.
If you think adding the net subject tag directly is acceptable, I will
adjust it in the next version of the patch.

