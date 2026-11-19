Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.160.53
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795071490;
	b=2rIB7RA1SYJHgbwl+yFot0xlUGo5zCCCMQOh9KwimkCAdIIShjq8dGRW4CFnIfFtYzmd
	 I9eAOzfAHy8Z+Or6NLPcgIPi7eu2eWTKW7qXDb26IHw8cDJuilFxD0VSSXRWYPXEj9pJl
	 8YbQMUx7yYz2sPC24PhQQbg3eAhkkAa8ANvDA2nw799ixrZzDw00RJn9INJv0uLWo1zy0
	 O3NAgk2dqHPeVbrTpLSc/z0o3p0h/kB0KLYZea/9TOY4fpBQ1q7MqsrppFU5hMKr/pqI/
	 1uKU5ETVEHrpnB2IAzVioTuVNZ1tB6mMuaBLX39uUkpHGVWduY0bb1Lq86YOphrIWFQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795071490;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=PmzMISo2SrE5tM/12DPNLaN31YDETueY6J9ZU7lO5ks=;
	b=xeNXMrff/uM0NDlK4Q3xGYQKrU6pw6OcBlfgreqKQWuMFceKJuY/qS51tHDyoFlHd2Qn
	 H7+WmzQPNhpddoZMQvXFqrwJ102I3D3FOmkEDo8hrYC/9bARWgBM+HWpt0JJ3W6WA0Cap
	 jKSERv6ME0um+0+WHLEWBiZzQ6Qik8W+J0Npr07Mr58pt1maF74DO0NN+TbjR71gm8Aub
	 aye0CVtGsphe5MY/Aovd5Dsm0yyiQkGpCzEnVmEPjdRQDpONTtk7ewOm3SB4tnXKfSCTx
	 Sad5avhMPU4S33ZDzWZz6h9NTZg5VBeb4cDOGK4nlsEYUWUlXwsJH/U+dsScHKcxCMw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=gPpRKOFh;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.160.53
Received: from mail-oa1-f53.google.com (mail-oa1-f53.google.com [209.85.160.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5F0A606A320
	for <syzbot@lists.linux.dev>; Thu, 19 Nov 2026 06:58:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B5F0A606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=gPpRKOFh
Received: by mail-oa1-f53.google.com with SMTP id 586e51a60fabf-4b0348a4c79so1293564fac.0
        for <syzbot@lists.linux.dev>; Wed, 18 Nov 2026 22:58:09 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795071488; cv=none;
        d=google.com; s=arc-20260327;
        b=PHJe1DoiRC68X66maaXJqQvnhnkkL2AEs/LvVtKDDsO8v8uZrWDL/KHQCh8FWfwKcG
         b4Q8brY7dNdjsLhPxADYv/nTU1yOSLAiv3LvjlL4PfSnjnJSKVH2hk2MeqqH2tuiaO3f
         TSJwvGia1Kp3EKtnmtoRnFBRBQ5Yk0n1qizWgb+J3ZF18U6vwaHdmV59wi15bz71+vY+
         ascsaAgpwIBR2mMv+YTMRNKip4UjP+1KmfV2pYzfpC3doDBL2FuS+5MXx9iN1TmIzYwk
         mwWTMgOgyLKmbv12+C9HZyH5CltSGYtTG5er8ApEfyYljXfwxeZ3abiMP7YGZ/JO5Zl3
         kegA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=PmzMISo2SrE5tM/12DPNLaN31YDETueY6J9ZU7lO5ks=;
        fh=Loj/Kr7Q9+FEo6kA2t3JpcQWAVH2hCnGx8CXggxSUfE=;
        b=imT7cpmmagRBzQEz5XfUtZPir8bnmgb2SE3Se8w+Npa/RkFOj1CtiY3ocAqDfhIPkD
         xiHJnjOEaB2hROh6sunFVdphU+QKcOYRGscfS4pQbN545px3as806/j8+P8XGV5vi0fv
         duootsCnfgdT3c0dyVe9ovb2w2UJh53N9N6lPfIQggmmShlohHTfp+CtJ/lVMcxSgn0e
         Z4mTw3DVaSO5qTDRkO+gs1hIovEQk8BCOR9t6C1t3StfIrZeosSlhy/ioD/iWl6Lzq3M
         xwAWAr7XB63nrQ9prLwzIGeYo+1dgnkcBsYzDs3rQz4cdftYeQHWPOChE9yJRXkLgDvD
         7HkA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795071488; x=1795676288; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=PmzMISo2SrE5tM/12DPNLaN31YDETueY6J9ZU7lO5ks=;
        b=gPpRKOFhARhDaTB0q6SAcNCcpR83b2IPykINSZErSeRGTF1IzphVH3mC6pRvXIaJl2
         SQWNAslFLfJVbuy5tf5cbw9q6bkVOM/gmxeeY35jvT9Y/yIgFuyVlQI/uN0LkMZmMmGH
         mzJ4HgW5qmnNKRtVJMYivVkeO/1aNE9LqJSFpBlnUwaNDbqGovblplxrGqjtps14aYpJ
         GzFRRy/9sSXtFv90RjlDE8j2m+MLjhZFqJveXIbFzFtucI/+0TWfdDJa30h6Rrzhu2Jp
         tRKNfFcA+eZOTUqyxZjWT2c7dEy5MXKsiS3mDngg3AW+erO/7pfTea9cH6/w8+rNg/zG
         U3OQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795071488; x=1795676288;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=PmzMISo2SrE5tM/12DPNLaN31YDETueY6J9ZU7lO5ks=;
        b=uRNT9cDLoh3LbdJ60JqGjDyQ3RYvZK3Xi91YR7IiDvhMV3F7TiYbvchj1NXuFIsiXM
         w9S6eaZrViMGgUE3Rq8/g1aqipFQWr9P+ga5pXSw8HTyFWL5WV9pHfHu5N8LLpIf96VB
         q6Mvn2pLJacUBOSyT/h0Tos8ivLSX2aHOb75BBDF8kYUhLV8tK3jBmVA0EtqetZDIH/V
         VgAAFZE/xrAs1w6E4MWrodAmQyaKoopaew6NNo854rYuzVOqi1EZ3mZ33/J8V/ABdVpH
         /Vx6aERiKkHscMu09P2bH8c1nFUMLd5j7HMxkt+UptXHRKhkYzN0tprs0dPeEWZgNSu+
         Ct3Q==
X-Forwarded-Encrypted: i=1; AL+hErH68P0DrfBx8E+b5+CiFCwV7LGt55LNTPfZCx+roe1JYFEGb2BGijwetpiac5FHnQRddAbyZKI=@lists.linux.dev
X-Gm-Message-State: APuU4Z/uvTWVlm7it7524bWQdcRy6U/1zrGyCNCB25/44sLgySUJv6lk
	8RWrciH5KATQJ8gr5yu9EtuSKiHeVOiAPtChV0vyM6891WiADHo8hIDcxUI3PBTWffQAmH68F2O
	yL36LsNWKpoitsht8jZ2JcJ0+RmA3yvoK3yuUiPWO
X-Gm-Gg: AYBFou1R05rX7O+NteISgCDHsvhREfadgCcCZrRqJjETHN+mAxsw6EemR5OEWIsbz3G
	vOtbrn/+VMvPvaExn2EOr3PFYRY/FpyVi296fg2x5kY6x3FIT4mOQ5BIUiLtIxwE7xXBQpgmCTM
	z0jTOvtfL4GysXyffP6GgmXvZjqI206FqTVFdea3cKDOaKM3TQqc0RMM0YZbNsMZMKP8wJ7xqIA
	GThT6jJtCPPTAdlcU9Mam44WB0iLFb7yJ2Joc+tgVIL5giwJsoYfVgyGmxZMepG3cAVrLPMusGV
	uFrdbB4x7j5zdW5DWcysizTgcaAX52SiVTN88Z75CmKpdlhZpKxFG6GInJje8VeA9WdNmPGuRlR
	uqJiUIZ8yKpPNinSuq9gmzfpb0sMGJWeZv/p9m144+JfBZ+sP9QnT3HEk6lST1GxKP8Pyj1MkKi
	/YhOy2rOdhtkuI8W2+0qWEGSOknbOUzjoVvlNzb5b/CEYcQCb0xCIfg5DkrKVhwqeBlSLuLUelG
	OpDteDT
X-Received: by 2002:a05:6808:16a8:b0:567:e971:200c with SMTP id
 5614622812f47-57741228693mr5615897b6e.41.1795071487763; Wed, 18 Nov 2026
 22:58:07 -0800 (PST)
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Post: <mailto:syzbot@lists.linux.dev>
List-Help: <mailto:syzbot+help@lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
List-Owner: <mailto:syzbot+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <6afe81b2.902182b0.170f33.0002.GAE@google.com>
In-Reply-To: <6afe81b2.902182b0.170f33.0002.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Thu, 19 Nov 2026 07:57:55 +0100
X-Gm-Features: AclHuK8XyrX4akZ4wHYFeXnH5bxPAkPMsPjca7FchFvitNr1TCvHXSpIO9M23Ek
Message-ID: <CANp29Y7VN57T0uwOJyB2jtRjnOh9x9=f=__mADCey2qzh3gLxw@mail.gmail.com>
Subject: Re: [moderation/CI] Re: mm/ksm: clean up scan_get_next_rmap_item() initialization
To: syzbot ci <syzbot+ci6274869ebbf20d77@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Thu, Nov 19, 2026 at 5:57=E2=80=AFAM syzbot ci
<syzbot+ci6274869ebbf20d77@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v2] mm/ksm: clean up scan_get_next_rmap_item() initialization
> https://lore.kernel.org/all/20261115075832.132109-1-xu.xin@linux.dev
> * [PATCH v2 1/2] mm/ksm: extract helper functions for scan cycle cleanup
> * [PATCH v2 2/2] mm/ksm: add initialization helpers for scan_get_next_rma=
p_item()
>
> and found the following issue:
> general protection fault in ksm_do_scan
>
> Full report is available here:
> https://ci.syzbot.org/series/cc51d824-2b5d-4c6d-bd56-c5bdb2bf5e12
>
> ***
>
> general protection fault in ksm_do_scan
>
> tree:      mm-new
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/=
mm.git
> base:      3dfc09a9493ddaa5e7722a29165d8450b55b4d3f
> arch:      amd64
> compiler:  Debian clang version 22.1.8 (1~deb13u4), Debian LLD 22.1.8
> config:    https://ci.syzbot.org/builds/6f9c12e2-f68e-40ee-bbac-84e33b709=
dfb/config
> AI triage: https://ci.syzbot.org/findings/02a8022e-9e9a-4596-8a04-b8c4338=
b7e82/triage_trajectory
>
> Oops: general protection fault, probably for non-canonical address 0xdfff=
fc0000000004: 0000 [#1] SMP KASAN PTI
> KASAN: null-ptr-deref in range [0x0000000000000020-0x0000000000000027]
> CPU: 1 UID: 0 PID: 44 Comm: ksmd Not tainted syzkaller #0 PREEMPT(full)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:ksm_do_scan+0x5da/0x6f40
> Code: c7 05 86 a2 b1 19 00 00 00 00 48 8d 43 28 48 89 05 9b a2 b1 19 48 8=
9 4c 24 40 48 8d 59 20 48 89 d8 48 c1 e8 03 48 89 44 24 78 <42> 80 3c 28 00=
 74 08 48 89 df e8 47 3a 01 00 48 89 5c 24 30 48 8b
> RSP: 0018:ffffc90000b47a60 EFLAGS: 00010202
> RAX: 0000000000000004 RBX: 0000000000000020 RCX: 0000000000000000
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffc90000b47c08
> RBP: ffffc90000b47cd0 R08: ffffc90000b47c07 R09: 0000000000000000
> R10: ffffc90000b47bb0 R11: fffff52000168f81 R12: 1ffff92000168f68
> R13: dffffc0000000000 R14: ffffea00046aca00 R15: 0000000000000000
> FS:  0000000000000000(0000) GS:ffff8882a77fd000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f15aa3f8c38 CR3: 0000000170aa2000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  ksm_scan_thread+0x114/0x520
>  kthread+0x38b/0x480
>  ret_from_fork+0x514/0xb70
>  ret_from_fork_asm+0x1a/0x30
>  </TASK>
> Modules linked in:
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:ksm_do_scan+0x5da/0x6f40
> Code: c7 05 86 a2 b1 19 00 00 00 00 48 8d 43 28 48 89 05 9b a2 b1 19 48 8=
9 4c 24 40 48 8d 59 20 48 89 d8 48 c1 e8 03 48 89 44 24 78 <42> 80 3c 28 00=
 74 08 48 89 df e8 47 3a 01 00 48 89 5c 24 30 48 8b
> RSP: 0018:ffffc90000b47a60 EFLAGS: 00010202
> RAX: 0000000000000004 RBX: 0000000000000020 RCX: 0000000000000000
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffc90000b47c08
> RBP: ffffc90000b47cd0 R08: ffffc90000b47c07 R09: 0000000000000000
> R10: ffffc90000b47bb0 R11: fffff52000168f81 R12: 1ffff92000168f68
> R13: dffffc0000000000 R14: ffffea00046aca00 R15: 0000000000000000
> FS:  0000000000000000(0000) GS:ffff88818bdfd000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 000000110c27b575 CR3: 000000010233e000 CR4: 00000000000006f0
>
>
> ***
>
> If these findings have caused you to resend the series or submit a
> separate fix, please add the following tag to your commit message:
>   Tested-by: syzbot@syzkaller.appspotmail.com
>
> ---
> This report is generated by a bot. It may contain errors.
> syzbot ci engineers can be reached at syzkaller@googlegroups.com.
>
> The email will later be sent to:
> [chengming.zhou@linux.dev david@kernel.org linux-kernel@vger.kernel.org l=
inux-mm@kvack.org ljs@kernel.org xu.xin@linux.dev]
>
> If the report looks fine to you, reply with:
> #syz upstream
>
> If the report is a false positive, reply with
> #syz invalid
>
> --
> You received this message because you are subscribed to the Google Groups=
 "syzkaller-upstream-moderation" group.
> To unsubscribe from this group and stop receiving emails from it, send an=
 email to syzkaller-upstream-moderation+unsubscribe@googlegroups.com.
> To view this discussion visit https://groups.google.com/d/msgid/syzkaller=
-upstream-moderation/6afe81b2.902182b0.170f33.0002.GAE%40google.com.
