Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com [209.85.167.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B31463ED5CD
	for <syzbot@lists.linux.dev>; Tue,  9 Jun 2026 22:00:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781042460; cv=none; b=hiJ0K8CEsWWpTHsgcc6jemnD6d9n+t62zHMkxZSERE7nGROsjoyt2fGbfTQQXlfXttmEaL4abmGtc41VLIwx5ZodzNGIevdX+5vNybKR7Pw9EFEbCONdaQM6T8KDbpEvRBRPwDgDQl6YTBcTj1YTbCoF3YHAxoaoXmZUaI51EeM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781042460; c=relaxed/simple;
	bh=gywX7BYpSKLg7gKTGA19iUfRsc2aJmdFafwnoLISue4=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=NSqpOxQOl85XIQ/Z7E2Zs8PXBc14NbJmuLacOaOuwF/Y2ZLTq0hN5cz/J3yumsDy74/RGY76jXqWdKsxtqyra1ZrD1nxWjUnu0jucY7arscYM2Ta4WGOWnb7YiHEqNBBGmF5k5Fv2NAwSEBGBMcObyKXmQNk3LOUiPEIhypQNAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f198.google.com with SMTP id 5614622812f47-486cc29e03bso4229241b6e.3
        for <syzbot@lists.linux.dev>; Tue, 09 Jun 2026 15:00:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781042458; x=1781647258;
        h=content-transfer-encoding:cc:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bUNf/J4bq5WouM+YsRdi/wXwHjEw809Iin1HBtJr4gY=;
        b=rgm1iLfpwZSdOkIHzp+cXTqgh3nr7AybZXIbVcImCAm/O7sXItyWrvaUzFUZ052KXP
         AlMzfq7HwhGIARVlkyQgB7aqavclalKIaEytHVQ2f5H6H5PEkRpn97URXbEsFpdJTDIU
         oHs4BEe8cJ5QiuKOKBvC5zYtJk0eEt8g2FUoAkdrmmj962yqT1rcyye/jQAwew6E3o/P
         X32+U1Zrc5kapbb2AhRPfto+62amKvfSOlura0IibUXpCzrNE3wfAs/Y6fYw1aFfmO4S
         1LeZ8Om3UMicIZkfUpVB8sLfxAzSQfwTqB5jqcNqH590CpoRrTKWhc/Oxeg8trmQNWmL
         QzMQ==
X-Gm-Message-State: AOJu0YxCNN4gxM3DYOzyqbI21NoGvi08EojXMNb2E4a68cTPHEImLt+C
	zhfPrO+drE2ti8xHppFIs+0ySrXXqyQyvP+GJLW7x0tAult8EZoUMxiWbcHUO1EBivNB+K2BnYb
	JG/tiOiT8QsHzKVc6PVco2UYoW2sn77HghGlqWx6cwlbR0hvyulF/vZsMuE8=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:3442:b0:46a:869c:b576 with SMTP id
 5614622812f47-4868dc82813mr13525233b6e.2.1781042457597; Tue, 09 Jun 2026
 15:00:57 -0700 (PDT)
Date: Tue, 09 Jun 2026 15:00:57 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a288d19.39669fcc.33b062.00a6.GAE@google.com>
Subject: [moderation/CI] Re: scsi/block: NUMA-local scan allocations,
 shared-tag path cleanup, and SCSI I/O counters
From: syzbot ci <syzbot+cid87965fa0bcd0f6e@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v3] scsi/block: NUMA-local scan allocations, shared-tag path cleanup, and =
SCSI I/O counters
https://lore.kernel.org/all/20260609121806.2121755-1-sumit.saxena@broadcom.=
com
* [PATCH v3 1/4] scsi: scan: allocate sdev and starget on the NUMA node of =
the host adapter
* [PATCH v3 2/4] scsi: host: allocate struct Scsi_Host on the NUMA node of =
the host adapter
* [PATCH v3 3/4] block: drop shared-tag fairness throttling
* [PATCH v3 4/4] scsi: use percpu counters for iostat counters in struct sc=
si_device

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/360774d1-fc19-4efa-ad7f-1b57f3911dc1

***

kernel build error

tree:      linux-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/next/li=
nux-next
base:      a87737435cfa134f9cdcc696ba3080759d04cf72
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp=
1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/3435ab05-0af5-4da8-9aea-dcf5f7401be=
7/config

drivers/ata/libata-scsi.c:4637:57: error: too few arguments to function cal=
l, expected 3, have 2

***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

To test a patch for this bug, please reply with `#syz test`
(should be on a separate line).

The patch should be attached to the email.
Note: arguments like custom git repos and branches are not supported.

The email will later be sent to:
[aacraid@microsemi.com aliakc@web.de anil.gurumurthy@qlogic.com aradford@gm=
ail.com axboe@kernel.dk bcm-kernel-feedback-list@broadcom.com brking@us.ibm=
.com bvanassche@acm.org chandrakanth.patil@broadcom.com chleroy@kernel.org =
cleech@redhat.com daniel@thingy.jp decui@microsoft.com don.brace@microchip.=
com eperezma@redhat.com fischer@norbit.de fthain@linux-m68k.org geoff@infra=
dead.org gotom@debian.or.jp gr-qlogic-storage-upstream@marvell.com haiyangz=
@microsoft.com hare@suse.com james.bottomley@hansenpartnership.com james.ri=
zzo@broadcom.com jasowang@redhat.com jgross@suse.com jinpu.wang@cloud.ionos=
.com john.g.garry@oracle.com justin.tee@broadcom.com kartilak@cisco.com kas=
hyap.desai@broadcom.com khalid@gonehiking.org kys@microsoft.com lduncan@sus=
e.com lenehan@twibble.org linux-arm-kernel@lists.infradead.org linux-block@=
vger.kernel.org linux-hyperv@vger.kernel.org linux-scsi@vger.kernel.org lin=
ux@armlinux.org.uk linux@highpoint-tech.com linuxdrivers@attotech.com linux=
ppc-dev@lists.ozlabs.org liyihang9@h-partners.com longli@microsoft.com madd=
y@linux.ibm.com martin.petersen@oracle.com mdr@sgi.com megaraidlinux.pdl@br=
oadcom.com michael.christie@oracle.com mpe@ellerman.id.au mpi3mr-linuxdrv.p=
dl@broadcom.com]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

