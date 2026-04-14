Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75E353876D7;
	Tue, 14 Apr 2026 08:07:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776154021; cv=none; b=k5c6U/cF8T5TxkmyRyh2OY4NasLug7nH+leaoid5Q3IpwM8FFmsLAuLWy9LAiwKsUmNzmNbixufZhm6wGNWlQa/oB0r7BG467/tbcX2qzvFVHxp083QwQ/H7RW+ZzUyXdj84nf9iwSiLs4sybo2wri4UT6fn2vkhvo7YmR0xQbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776154021; c=relaxed/simple;
	bh=OzjBk4AYOFhybT2ucLvcmVBU3yRTKpZ/qj32G+RhUlo=;
	h=Content-Type:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To; b=X97unsninPyQDhTNRy1WTDcOyx07/0S7qN0T3Or7r7lPm15x6Bff1jQvfDRZYmGMkKDEgYsCKH7mnS5pkPiXL8kp16vB5tBd507fhhoqmxywJuaAzwpNDGf1Epsft9BZb9tybjQYXKLgNY1rIqjskwsrmJjIm1uTVKVFhB+A4yA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GSajAOhh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GSajAOhh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DF9EC19425;
	Tue, 14 Apr 2026 08:06:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776154021;
	bh=OzjBk4AYOFhybT2ucLvcmVBU3yRTKpZ/qj32G+RhUlo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=GSajAOhhw0dMHByeMA6VUOri5zwG36Lr/C+VAkhCsPePHClrSbLBjM6IrZRQrjnBN
	 dNoBZG5SzAc5ShN78uz+F794zZoOK1oHGz67p/7pcBfkHw5tIoI5SskMCFLWxXhngS
	 4v7cFb2yYfeCWhPc95IsCdR4XXXO3CG3YH8jPWn8QjGcolaDhXb4ve/zF6EjJCcBKl
	 qiHxTyVG1epIqKq3nr1+pATIX6OoCsP8f9euA5FI9Kl0UBwL/ZYYmvKSy1/ekkJQMt
	 XPW0xcra8+1HYSByE4dk4SSYNorMFa5mj+9k9lryOJCtbAVNrxRKVMh/RilW6o47Ld
	 doA5HJvKOGlNA==
Content-Type: multipart/mixed; boundary="------------R9ueKS8Bzv10EHzded4CpN98"
Message-ID: <41689f2e-8786-49a6-912d-f65e48245a61@kernel.org>
Date: Tue, 14 Apr 2026 10:06:54 +0200
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot ci] Re: veth: add Byte Queue Limits (BQL) support
To: syzbot ci <syzbot+cib904ea9ebb647254@syzkaller.appspotmail.com>,
 andrew@lunn.ch, ast@kernel.org, bpf@vger.kernel.org, corbet@lwn.net,
 daniel@iogearbox.net, davem@davemloft.net, edumazet@google.com,
 frederic@kernel.org, horms@kernel.org, j.koeppeler@tu-berlin.de,
 john.fastabend@gmail.com, kernel-team@cloudflare.com, kuba@kernel.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, netdev@vger.kernel.org, pabeni@redhat.com,
 sdf@fomichev.me, shuah@kernel.org
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
References: <69dd48c2.a00a0220.468cb.004e.GAE@google.com>
Content-Language: en-US
From: Jesper Dangaard Brouer <hawk@kernel.org>
In-Reply-To: <69dd48c2.a00a0220.468cb.004e.GAE@google.com>

This is a multi-part message in MIME format.
--------------R9ueKS8Bzv10EHzded4CpN98
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 13/04/2026 21.49, syzbot ci wrote:
> syzbot ci has tested the following series
> 
> [v2] veth: add Byte Queue Limits (BQL) support
> https://lore.kernel.org/all/20260413094442.1376022-1-hawk@kernel.org
> * [PATCH net-next v2 1/5] net: add dev->bql flag to allow BQL sysfs for IFF_NO_QUEUE devices
> * [PATCH net-next v2 2/5] veth: implement Byte Queue Limits (BQL) for latency reduction
> * [PATCH net-next v2 3/5] veth: add tx_timeout watchdog as BQL safety net
> * [PATCH net-next v2 4/5] net: sched: add timeout count to NETDEV WATCHDOG message
> * [PATCH net-next v2 5/5] selftests: net: add veth BQL stress test
> 
> and found the following issue:
> WARNING in veth_napi_del_range
> 
> Full report is available here:
> https://ci.syzbot.org/series/ee732006-8545-4abd-a105-b4b1592a7baf
> 
> ***
> 
> WARNING in veth_napi_del_range
>

Attached a reproducer myself.
- I have V3 ready see below for diff

> tree:      net-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netdev/net-next.git
> base:      8806d502e0a7e7d895b74afbd24e8550a65a2b17
> arch:      amd64
> compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
> config:    https://ci.syzbot.org/builds/90743a26-f003-44cf-abcc-5991c47588b2/config
> syz repro: https://ci.syzbot.org/findings/d068bfb2-9f8b-466a-95b4-cd7e7b00006c/syz_repro
> 
> ------------[ cut here ]------------
> index >= dev->num_tx_queues
> WARNING: ./include/linux/netdevice.h:2672 at netdev_get_tx_queue include/linux/netdevice.h:2672 [inline], CPU#0: syz.1.27/6002
> WARNING: ./include/linux/netdevice.h:2672 at veth_napi_del_range+0x3b7/0x4e0 drivers/net/veth.c:1142, CPU#0: syz.1.27/6002
> Modules linked in:
> CPU: 0 UID: 0 PID: 6002 Comm: syz.1.27 Not tainted syzkaller #0 PREEMPT(full)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
> RIP: 0010:netdev_get_tx_queue include/linux/netdevice.h:2672 [inline]
> RIP: 0010:veth_napi_del_range+0x3b7/0x4e0 drivers/net/veth.c:1142
> Code: 00 e8 ad 96 69 fe 44 39 6c 24 10 74 5e e8 41 61 44 fb 41 ff c5 49 bc 00 00 00 00 00 fc ff df e9 6d ff ff ff e8 2a 61 44 fb 90 <0f> 0b 90 42 80 3c 23 00 75 8e eb 94 48 8b 0c 24 80 e1 07 80 c1 03
> RSP: 0018:ffffc90003adf918 EFLAGS: 00010293
> RAX: ffffffff86814ec6 RBX: 1ffff110227a6c03 RCX: ffff888103a857c0
> RDX: 0000000000000000 RSI: 0000000000000002 RDI: 0000000000000002
> RBP: 1ffff110227a6c9a R08: ffff888113f01ab7 R09: 0000000000000000
> R10: ffff888113f01a98 R11: ffffed10227e0357 R12: dffffc0000000000
> R13: 0000000000000002 R14: 0000000000000002 R15: ffff888113d36018
> FS:  000055555ea16500(0000) GS:ffff88818de4a000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007efc287456b8 CR3: 000000010cdd0000 CR4: 00000000000006f0
> Call Trace:
>   <TASK>
>   veth_napi_del drivers/net/veth.c:1153 [inline]
>   veth_disable_xdp+0x1b0/0x310 drivers/net/veth.c:1255
>   veth_xdp_set drivers/net/veth.c:1693 [inline]
>   veth_xdp+0x48e/0x730 drivers/net/veth.c:1717
>   dev_xdp_propagate+0x125/0x260 net/core/dev_api.c:348
>   bond_xdp_set drivers/net/bonding/bond_main.c:5715 [inline]
>   bond_xdp+0x3ca/0x830 drivers/net/bonding/bond_main.c:5761
>   dev_xdp_install+0x42c/0x600 net/core/dev.c:10387
>   dev_xdp_detach_link net/core/dev.c:10579 [inline]
>   bpf_xdp_link_release+0x362/0x540 net/core/dev.c:10595
>   bpf_link_free+0x103/0x480 kernel/bpf/syscall.c:3292
>   bpf_link_put_direct kernel/bpf/syscall.c:3344 [inline]
>   bpf_link_release+0x6b/0x80 kernel/bpf/syscall.c:3351
>   __fput+0x44f/0xa70 fs/file_table.c:469
>   task_work_run+0x1d9/0x270 kernel/task_work.c:233


The BQL reset loop in veth_napi_del_range() iterates
dev->real_num_rx_queues but indexes into peer's TX queues,
which goes out of bounds when the peer has fewer TX queues
(e.g. veth enslaved to a bond with XDP).

Fix is to clamp the loop to the peer's real_num_tx_queues.
Will be included in the V3 submission.

#syz test

---
  drivers/net/veth.c | 4 +++-
  1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index 911e7e36e166..9d7b085c9548 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -1138,7 +1138,9 @@ static void veth_napi_del_range(struct net_device 
*dev, int start, int end)
  	 */
  	peer = rtnl_dereference(priv->peer);
  	if (peer) {
-		for (i = start; i < end; i++)
+		int peer_end = min(end, (int)peer->real_num_tx_queues);
+
+		for (i = start; i < peer_end; i++)
  			netdev_tx_reset_queue(netdev_get_tx_queue(peer, i));
  	}



--------------R9ueKS8Bzv10EHzded4CpN98
Content-Type: application/x-shellscript; name="repro-syzbot-veth-bql.sh"
Content-Disposition: attachment; filename="repro-syzbot-veth-bql.sh"
Content-Transfer-Encoding: base64

IyEvYmluL2Jhc2gKIyBSZXByb2R1Y2VyIGZvciBzeXpib3QgV0FSTklORyBpbiB2ZXRoX25h
cGlfZGVsX3JhbmdlCiMgaHR0cHM6Ly9jaS5zeXpib3Qub3JnL3Nlcmllcy9lZTczMjAwNi04
NTQ1LTRhYmQtYTEwNS1iNGIxNTkyYTdiYWYKIwojIEJ1ZzogdmV0aF9uYXBpX2RlbF9yYW5n
ZSgpIGl0ZXJhdGVzIGRldi0+cmVhbF9udW1fcnhfcXVldWVzCiMgYnV0IGluZGV4ZXMgcGVl
ci0+dHhxW2ldLCBzbyBpZiBkZXYtPnJ4X3F1ZXVlcyA+IHBlZXItPnR4X3F1ZXVlcwojIHdl
IGdldDogV0FSTklORzogbmV0ZGV2X2dldF90eF9xdWV1ZTogaW5kZXggPj0gZGV2LT5udW1f
dHhfcXVldWVzCiMKIyBUcmlnZ2VyOiBjcmVhdGUgdmV0aCB3aXRoIGFzeW1tZXRyaWMgcXVl
dWVzIChyeD0yLCBwZWVyX3R4PTEpLAojIGF0dGFjaCBYRFAsIHRoZW4gZGV0YWNoIGl0IHRv
IGhpdCB2ZXRoX25hcGlfZGVsX3JhbmdlLgoKc2V0IC1lCgojIFJlcXVpcmVzIENPTkZJR19E
RUJVR19ORVQ9eSBmb3IgdGhlIFdBUk5fT05fT05DRSBpbiBuZXRkZXZfZ2V0X3R4X3F1ZXVl
KCkKaWYgWyAtZiAvcHJvYy9jb25maWcuZ3ogXTsgdGhlbgogICAgaWYgISB6Y2F0IC9wcm9j
L2NvbmZpZy5neiB8IGdyZXAgLXEgIkNPTkZJR19ERUJVR19ORVQ9eSI7IHRoZW4KICAgICAg
ICBlY2hvICJTS0lQOiBDT05GSUdfREVCVUdfTkVUPXkgcmVxdWlyZWQgdG8gdHJpZ2dlciB0
aGUgV0FSTklORyIKICAgICAgICBleGl0IDQKICAgIGZpCmZpCgpjbGVhbnVwKCkgewogICAg
aXAgbGluayBkZWwgdmV0aDAgMj4vZGV2L251bGwgfHwgdHJ1ZQogICAgcm0gLWYgL3RtcC94
ZHBfcGFzcy5vCn0KdHJhcCBjbGVhbnVwIEVYSVQKCiMgTWluaW1hbCBYRFAgcHJvZ3JhbSAo
WERQX1BBU1MpCiMgSWYgYnBmdG9vbCBpcyBhdmFpbGFibGUsIGdlbmVyYXRlIGl0OyBvdGhl
cndpc2UgdXNlIGlwIGxpbmsgeGRwIG9iagpjYXQgPiAvdG1wL3hkcF9wYXNzLmMgPDwgJ0VP
RicKI2RlZmluZSBTRUMobmFtZSkgX19hdHRyaWJ1dGVfXygoc2VjdGlvbihuYW1lKSwgdXNl
ZCkpCiNkZWZpbmUgWERQX1BBU1MgMgpzdHJ1Y3QgeGRwX21kOwpTRUMoInhkcCIpCmludCB4
ZHBfcGFzcyhzdHJ1Y3QgeGRwX21kICpjdHgpIHsgcmV0dXJuIFhEUF9QQVNTOyB9CmNoYXIg
X2xpY2Vuc2VbXSBTRUMoImxpY2Vuc2UiKSA9ICJHUEwiOwpFT0YKCiMgVHJ5IHRvIGNvbXBp
bGUgaWYgY2xhbmcgaXMgYXZhaWxhYmxlCmlmIGNvbW1hbmQgLXYgY2xhbmcgJj4vZGV2L251
bGw7IHRoZW4KICAgIGNsYW5nIC1PMiAtZyAtdGFyZ2V0IGJwZiAtYyAvdG1wL3hkcF9wYXNz
LmMgLW8gL3RtcC94ZHBfcGFzcy5vCmVsc2UKICAgIGVjaG8gIlNLSVA6IGNsYW5nIG5vdCBh
dmFpbGFibGUgdG8gY29tcGlsZSBYRFAgcHJvZ3JhbSIKICAgIGV4aXQgNApmaQoKZWNobyAi
PT09IENyZWF0aW5nIHZldGggcGFpciB3aXRoIGFzeW1tZXRyaWMgcXVldWVzID09PSIKZWNo
byAiICAgIHZldGgwOiBudW10eHF1ZXVlcz0xIG51bXJ4cXVldWVzPTIiCmVjaG8gIiAgICB2
ZXRoMTogbnVtdHhxdWV1ZXM9MSBudW1yeHF1ZXVlcz0xIgoKIyB2ZXRoMCBoYXMgMiBSWCBx
dWV1ZXMsIHBlZXIgKHZldGgxKSBoYXMgb25seSAxIFRYIHF1ZXVlCmlwIGxpbmsgYWRkIHZl
dGgwIG51bXR4cXVldWVzIDEgbnVtcnhxdWV1ZXMgMiBcCiAgIHR5cGUgdmV0aCBwZWVyIG5h
bWUgdmV0aDEgbnVtdHhxdWV1ZXMgMSBudW1yeHF1ZXVlcyAxCgppcCBsaW5rIHNldCB2ZXRo
MCB1cAppcCBsaW5rIHNldCB2ZXRoMSB1cAoKZWNobyAiPT09IEF0dGFjaGluZyBYRFAgdG8g
dmV0aDAgKHJ4PTIsIHBlZXJfdHg9MSkgPT09IgojIFRoaXMgcGFzc2VzIHRoZSBYRFAgYXR0
YWNoIGNoZWNrIChkZXYtPnJ4ID49IHBlZXItPnR4OiAyID49IDEpCmlwIGxpbmsgc2V0IGRl
diB2ZXRoMCB4ZHAgb2JqIC90bXAveGRwX3Bhc3MubyBzZWMgeGRwCgplY2hvICI9PT0gVmVy
aWZ5aW5nIHF1ZXVlIGFzeW1tZXRyeSA9PT0iClYwX1JYPSQoY2F0IC9zeXMvY2xhc3MvbmV0
L3ZldGgwL3F1ZXVlcy9yeC0qL3Jwc19jcHVzIHwgd2MgLWwpClYxX1RYPSQobHMgLWQgL3N5
cy9jbGFzcy9uZXQvdmV0aDEvcXVldWVzL3R4LSogMj4vZGV2L251bGwgfCB3YyAtbCkKZWNo
byAiICAgIHZldGgwIHJ4X3F1ZXVlcz0kVjBfUlggIHZldGgxIHR4X3F1ZXVlcz0kVjFfVFgi
CmlmIFsgIiRWMF9SWCIgLWd0ICIkVjFfVFgiIF07IHRoZW4KICAgIGVjaG8gIiAgICBCVUcg
Q09ORElUSU9OOiBkZXYtPnJ4X3F1ZXVlcyAoJFYwX1JYKSA+IHBlZXItPnR4X3F1ZXVlcyAo
JFYxX1RYKSIKZWxzZQogICAgZWNobyAiICAgIFNLSVA6IHF1ZXVlIGFzeW1tZXRyeSBub3Qg
YWNoaWV2ZWQiCiAgICBleGl0IDQKZmkKCmRtZXNnIC1DIDI+L2Rldi9udWxsIHx8IHRydWUK
CmVjaG8gIj09PSBEZXRhY2hpbmcgWERQIGZyb20gdmV0aDAgPT09IgojIFRoaXMgdHJpZ2dl
cnMgdmV0aF9kaXNhYmxlX3hkcCAtPiB2ZXRoX25hcGlfZGVsIC0+CiMgdmV0aF9uYXBpX2Rl
bF9yYW5nZSh2ZXRoMCwgMCwgMikgd2hpY2ggbG9vcHMgaT0wLDEKIyBhbmQgYWNjZXNzZXMg
cGVlcih2ZXRoMSktPnR4cVsxXSAtLSBidXQgcGVlciBvbmx5IGhhcyAxIHR4cSEKaXAgbGlu
ayBzZXQgZGV2IHZldGgwIHhkcCBvZmYKCiMgQ2hlY2sgZG1lc2cgZm9yIFdBUk5JTkcgKHJl
cXVpcmVzIENPTkZJR19ERUJVR19ORVQ9eSBmb3IgdGhlIFdBUk4pCmlmIGRtZXNnIDI+L2Rl
di9udWxsIHwgZ3JlcCAtcWkgIldBUk5JTkcuKnZldGhfbmFwaV9kZWxfcmFuZ2VcfFdBUk5J
TkcuKm5ldGRldmljZS5oIjsgdGhlbgogICAgZWNobyAiPT09IEZBSUw6IFdBUk5JTkcgaW4g
dmV0aF9uYXBpX2RlbF9yYW5nZSAoYnVnIHJlcHJvZHVjZWQpID09PSIKICAgIGRtZXNnIHwg
Z3JlcCAtQjEgLUExMCAiV0FSTklORy4qdmV0aCIKICAgIGV4aXQgMQplbHNlCiAgICBlY2hv
ICI9PT0gUEFTUzogbm8gV0FSTklORyBpbiBkbWVzZyA9PT0iCiAgICBleGl0IDAKZmkK

--------------R9ueKS8Bzv10EHzded4CpN98--
