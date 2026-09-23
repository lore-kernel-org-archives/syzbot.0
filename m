Received: from mail-ot1-f69.google.com (mail-ot1-f69.google.com [209.85.210.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A669F53A389
	for <syzbot@lists.linux.dev>; Wed, 23 Sep 2026 20:00:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790193624; cv=none; b=UfTdf2fDpevC7FWTQTqkHENdXrGRYOD+4bjekILayOOyBnJdql665htFlaPCLdv6QINnZ4xlpHhGgtU8yGIctLGRSzAc1GuLDI0hcTSFBRLMM8kUM9o1qxENllvJqPZ8Nl6hCDPJ4WduI6NqEpfEoHG7JngQCO02Ll7C18rK3/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790193624; c=relaxed/simple;
	bh=Ln1CaRAz5yhmpmIV2bNeFY8S6UvvLoFrF8dx6im5KDY=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=pQj0ZLc/AMh3ZWR2+mHP+7vQdk+Zb5fh0bM6sFsTb7+nDc+URcxlupXOQNJj7CYh0xO3T+/jLTQa75fZCRw5ObUo87arF8FM0MznCKaq9TnWXsUCYu7IuJxqp2NxaYIltsWwZSgXxXX3ZsL34TtffulQqHeDzt72F1jTPAHby+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.210.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f69.google.com with SMTP id 46e09a7af769-81482599b3cso2560063a34.2
        for <syzbot@lists.linux.dev>; Wed, 23 Sep 2026 13:00:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790193612; x=1790798412;
        h=content-type:cc:to:from:subject:message-id:in-reply-to:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=1DD51enbnQ7FLUQimWQmuCMYdC5ARBlUMukwD/j/WF8=;
        b=hlhSLuK0x7mdn0qk/G5zOWcmxQHIK+jmsLqGsO+VNIECOnEugcztJOWYc5HGskIc9v
         42pBmkcV8NGk7OFQDTTUGUAMiyfIBmwFhzvZllU4mU3swTbp/wCjH6uB+UB4pQvwIRvA
         3jZMie7pQ+BYufvN3ImIyYOr8IQ8Cv3pJiZELXqtFU5V1X4VJdme2gbn3xlKdKguNJ+0
         gIONXtpcSCpcVHU4B6amMRuZJCRSRVzSy+R5xaketb1yAkzRl8Jle1xzzyoUutY7meLF
         RzGj5vIwsnlDxlXL0jRYNp+g+ipRcNr/Dwvc1hjh6Cy+VpQtfUSBg+6Mi28vrdHFlif1
         3ZlQ==
X-Gm-Message-State: AFuF++lPZPTkLEBceuWf89QCpKFdn3PaRqPm8VBOU3fNlIw9BwDYQID0
	wzKBk6CcFjoyigrtYuWRGy8j7i6WWQuxVuD68GM0mGvOonEFJNqogBQMXTnX2Ay17GS9GRooIZb
	R0nN8dU6cJ6UrpyEtUWaflqdRP6Z+DcMkfSYJm0h7Jb4cNDyRy+DNIBfUkK0=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:81c5:b0:6c3:98aa:75ac with SMTP id
 006d021491bc7-6d43e80c6d4mr379567eaf.27.1790193612568; Wed, 23 Sep 2026
 13:00:12 -0700 (PDT)
Date: Wed, 23 Sep 2026 13:00:12 -0700
In-Reply-To: <20260921191239.4249-1-alucerop@amd.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6ab42fcc.e9f5c185.9abc8.0002.GAE@google.com>
Subject: [syzbot ci] Re: Type2 multipf support
From: syzbot ci <syzbot+ci99860126897da844@syzkaller.appspotmail.com>
To: alucerop@amd.com, davem@davemloft.net, ecree.xilinx@gmail.com, 
	edumazet@google.com, icheng@nvidia.com, kuba@kernel.org, 
	linux-cxl@vger.kernel.org, netdev@vger.kernel.org, pabeni@redhat.com, 
	rafael@kernel.org
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v1] Type2 multipf support
https://lore.kernel.org/all/20260921191239.4249-1-alucerop@amd.com
* [PATCH v1 1/4] driver core: Rely on supplier driver binding at link creation
* [PATCH v1 2/4] cxl/region: Add region reference in memdev attach
* [PATCH v1 3/4] cxl/memdev: Add support for multi PF devices
* [PATCH v1 4/4] sfc: add multipf support

and found the following issue:
WARNING: synchronous SCSI scan failed without making any progress, switching to async

Full report is available here:
https://ci.syzbot.org/series/cce74032-73a7-4071-a29e-65a7ec02c350

***

WARNING: synchronous SCSI scan failed without making any progress, switching to async

tree:      axboe
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/axboe/linux.git
base:      93f51579e7df248780214094418f205253383cc5
arch:      amd64
compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/50697200-bc23-49c1-b943-c9c91049cf06/config

ata1: Failed to create link to scsi device 0:0:0:0
scsi_alloc_sdev: Allocation failure during SCSI scanning, some SCSI devices might not be configured
ata1: Failed to create link to scsi device 0:0:0:0
scsi_alloc_sdev: Allocation failure during SCSI scanning, some SCSI devices might not be configured
ata1: Failed to create link to scsi device 0:0:0:0
scsi_alloc_sdev: Allocation failure during SCSI scanning, some SCSI devices might not be configured
ata1: Failed to create link to scsi device 0:0:0:0
scsi_alloc_sdev: Allocation failure during SCSI scanning, some SCSI devices might not be configured
ata1: Failed to create link to scsi device 0:0:0:0
scsi_alloc_sdev: Allocation failure during SCSI scanning, some SCSI devices might not be configured
ata1: Failed to create link to scsi device 0:0:0:0
scsi_alloc_sdev: Allocation failure during SCSI scanning, some SCSI devices might not be configured
ata1: WARNING: synchronous SCSI scan failed without making any progress, switching to async


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

To test a fix for this bug, please reply with `#syz test`
(on a separate line) and attach the patch to the email.

Notes:
- The patch will be applied on top of the tested series (as an
  incremental fix).
- To test a new version of the whole series, please send it directly
  to syzbot@lists.linux.dev.
- Arguments like custom git repos and branches are not supported.
