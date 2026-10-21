Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.210.46
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792570783;
	b=VkPuQARLjpCvLkCmbFlvPC9xl3XhJAnRyskDVhTnPbbiJwOSulp4ZeZd+vjoKDc6kkuq
	 ngJkDrT+f1PvWudUyosMmvJfFMRM6b6wJchyucs9HTJk5UFS8DjR12+BEvJwysF5HKnlZ
	 WkXYUa4QSyMoc0EnwWmrJfNZf/2zdTTpehVHZXFmFSc2i/y2NCgkGKAx95gboObIRynBm
	 5y57n2fuXgb3aUTRMF1mIFhkPCUlZR3pgX6Pg9hlW5KYiP6mCwvlY2zFrlIM+HL5l89k7
	 pt0XBp1XmQo/ykuICWCfBAVWixdOxFcAwkUP6aTpcjw79VSSgFoC3CFRKyLZila4+vQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792570783;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=aOETIRHCqwYatvUBXgOmr8SiFiHEwcfa3ycdLC3WLzU=;
	b=FQphiu9bL2c8bQrXCAkWph278s7cpHQiUWXYSbDF705d/yo7PMTAIdJoeVG38Fmhca3y
	 TCgqTqN1oOUf6pA1qd14kA72/GlfFHXxUlCIQWeAVBt33C+keUfZQK+jOJPgh51Ui1CtU
	 oHgKqCEEc4KtGu49gSCbsXv+fQ7IsuNqCJH/Wb8DP1uxTaHOB/281rOddvFykwnK+UVUf
	 gxHAovmJkC4ytQXDQEc+1msrrdMUkXvAIzneWciv6Vyoi9K8hkOIhFU8CJjN5VxPTY9KW
	 mB+9IVH4C8a2grOvKcIe7NJiVkrvVQWQKVlaBiBybbx4o4z3e99FDlXlCuaRTbfA+aQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=A0lxb7RU;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.210.46
Received: from mail-ot1-f46.google.com (mail-ot1-f46.google.com [209.85.210.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD806606A32A
	for <syzbot@lists.linux.dev>; Wed, 21 Oct 2026 08:19:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AD806606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=A0lxb7RU
Received: by mail-ot1-f46.google.com with SMTP id 46e09a7af769-8256106635eso242798a34.0
        for <syzbot@lists.linux.dev>; Wed, 21 Oct 2026 01:19:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792570781; cv=none;
        d=google.com; s=arc-20260327;
        b=JTwAIbH9bfsDg0JOfoalFrmEPsd1j8ZJ7VixbExaIIwwoHa3RijHbRH80bhDzEPh1V
         Lha4hxiYgwLbB5vC8N1wXe5jN8oXTE2EZj+n/Z5TqobnV8Uus0G2r1P40l52ZF817pav
         +ItxLNq1TbLWyAmMT3P5nmaQA0w2stFazlaEHLCY1FOGPM/+el1EXLKQdpKtyhDuJ/1z
         UGgq1tAN+CFjcbUtjfXA1emNYUgXZIEXcULmPc2Thmetc9Xy5Z8iHLiNXI2GQ8XpTBP7
         NHi2nDZ9Mno3PIyMu00qCoat6uewORc3c7VlsBqaXID3/QN8jiiIU4i2aDoc8eiKN254
         vJLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=aOETIRHCqwYatvUBXgOmr8SiFiHEwcfa3ycdLC3WLzU=;
        fh=FfrGBLnVPqPJKND0gAQKJZYxXkM4AvhEpLq5QW7HHd8=;
        b=enItvLx1fp/qtnNmxoXy+7gggMclcnH5HuS6C+4Bc+41TRpeFabU6kiQP1/E+XyKj/
         tusff4NvaxID4VDoVVoS0Dzvm2/sBCwY7T8xhSWiqIzhcNQPScPnEO4k0DjG4ppHyahw
         vUgTedKnp+2McAmXDqJQuAPDCu4nAqAO1Ur8eTHLA+h+1e10adi+Q36PSRHE7DAdxVSH
         7O31OvZHZZc1gwA1l3Hj7rN6VkRgJ83KfEAYVVViJjP3Cc/VPt6cBa8G9oJyts7/I9BV
         c6JvqvrBz4EggZPmz6TsrV+RIVvDUSp78RTsDqROcL/9iS3ic8DHcV63hxFSdB0y1EiA
         31Iw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792570781; x=1793175581; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=aOETIRHCqwYatvUBXgOmr8SiFiHEwcfa3ycdLC3WLzU=;
        b=A0lxb7RUba1EBkVd3/aWC96ZlGs9+g/ZOVTaQd/ue3+wUOYFEunPnhXblMqQ2RPn5Y
         a84EyN51jok85Gov6JVBUfvLoHu9gpZEsfxoC7YLKPVkbwoIV/5gWD5RWjWXMG1l3MfT
         0NOQEeoqKhmBaFRJwvU77ovxIHtByZzkbRWdpeJ5EOS9eZ05XLkdZl3lnQT0nKwZv7UX
         5mscwS/JE/lmay34YXMskPcYG53eBBzsCGarHcDm+jTrS36IeELbqiYPF/JFSa45BqBb
         Vwe58gNOOLdgA7KFZBj1hgpHTHZIt9tEdoftYTH8ROUpuqfC/6YY0lZmHYnWMxKfPRJE
         RamQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792570781; x=1793175581;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=aOETIRHCqwYatvUBXgOmr8SiFiHEwcfa3ycdLC3WLzU=;
        b=lMo3taemDv7fF01N5YbUS3vSKPMUzwvmYHxUW2d8fvP5PH8SP33+qvEHdGrHzEml10
         g2RZWDqPxCjiYCwZO2dTeJXF1Uy7+p0orwviKKbAmeKZa/hdSUqOEGkYvzZuGzZokhlx
         aQNvtHRKVElwylRZdsCP4dwWgW8IjCpxQuP/w3zkzkj81Udi8DVqIGmuDQ3Px963jlGk
         XouwSqyU/IlBTqw5svczG9TZQ7ag+iEOt5FK4Zu1P/uyzgr+H4jzzAiFl9iPD12nN0xC
         LDnE0QrcVl8jirH+XZYRneMFsjouksOF7qfcI/0Ymq1WiMfEHnhnQ7IEikGN6oBwx67I
         4/Ig==
X-Forwarded-Encrypted: i=1; AKwUvBxHTqQK130e5lMSkFdDrbeNS3fqnauC9zOaMOVxV16JoBzGdurAXi6AV2sqlOp1+ibQpA1vlt0=@lists.linux.dev
X-Gm-Message-State: AFq9FYKn779Vrw06G6YLNslhxa4BXr2hWXfW2Wo5XgBby+yebnu48LdG
	53YmUJ0jTGKkHQwUy54kWmVqx9USqxGMzVIvKmmkS9OasDhVsWD68PRX0pDbFxEHBVN1+qb1/i1
	C4Xr52FFJlygK0yebDTC7CvbzWB+L5L73uVdKuzn9
X-Gm-Gg: AYBFou0+eKcmXY3aM3pyBr4sobbVBZDP7WaXTMd0ZOzAz7A038okSSUymK3Oa3BalAK
	4dQwFO8pezt2JPDQdmIUPmMVztOayg3IZ6FhR60y/WtrIKxt3+r09p1I08c+aDhH5Q6rhz0RD/T
	AXOcz2zbYtsSB9sPayTW39nBeusYEqfUvmWwR0TP6MYny4lsWwYbiNUdaLnpsHg4Q9GjhH1xwUV
	ic+tY4G1PD43oWClUz690jgE8Ze4IrbsKTrMnNLvkeMS4B+JoG8BNqmJrqyhyubgGzNeyXOASTj
	7YBNVS4dM38RqwAlzqMIFIEzapJZJmNiiVS7oO8YapUqhhKU7jNVDEn3uGRvbqpWX31OZb5U9/h
	YF1O1jj+C2p82LSfM3FjC5Kd83Iue75MZvWM1F4q9vxfKEulPjflv4gvm4JPLzQsVlDOb+G3DFc
	F09wPNE9vfPT3n0C4lzuRoDORXTucIUBNTyRk5GU7NZdh7GkM5bYRHz2Kj3O2hiQB3Ipc5ELMpH
	bo3T131
X-Received: by 2002:a05:6808:3501:b0:4d6:9232:b3bc with SMTP id
 5614622812f47-5535e5556ecmr905290b6e.51.1792570780721; Wed, 21 Oct 2026
 01:19:40 -0700 (PDT)
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Post: <mailto:syzbot@lists.linux.dev>
List-Help: <mailto:syzbot+help@lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
List-Owner: <mailto:syzbot+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <6ad802ff.5c73e770.1a06c9.013d.GAE@google.com>
In-Reply-To: <6ad802ff.5c73e770.1a06c9.013d.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Wed, 21 Oct 2026 10:19:29 +0200
X-Gm-Features: AclHuK-fGMNjspGEh6rQDbB1nmlkHC7y6Z4TV4VwG8o_Wc-I3gnphMvoZiSRq0Y
Message-ID: <CANp29Y41OFKQY59yDEA7X8aM22s0jRpYV6w07xnJ72qU7WhvYA@mail.gmail.com>
Subject: Re: [moderation/CI] Re: KEYS: Return user session keyring on lookup
To: syzbot ci <syzbot+ci174dd4219b0034e2@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream


On Wed, Oct 21, 2026 at 2:10=E2=80=AFAM syzbot ci
<syzbot+ci174dd4219b0034e2@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v2] KEYS: Return user session keyring on lookup
> https://lore.kernel.org/all/20261019145624.309790-1-jarkko@kernel.org
> * [PATCH v2 1/2] KEYS: Return user session keyring on lookup
> * [PATCH v2 2/2] KEYS: Reject keyring creation with overridden credential=
s
>
> and found the following issue:
> general protection fault in keyctl_session_to_parent
>
> Full report is available here:
> https://ci.syzbot.org/series/7566814a-52ba-4f0b-b506-d7adf67fda29
>
> ***
>
> general protection fault in keyctl_session_to_parent
>
> tree:      linux-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/next/=
linux-next
> base:      17a7501b9612a52b38bc57e33c7b64636d438bc0
> arch:      amd64
> compiler:  Debian clang version 22.1.8 (1~deb13u4), Debian LLD 22.1.8
> config:    https://ci.syzbot.org/builds/eee373c7-f447-49cf-a350-83830580c=
7b2/config
> AI triage: https://ci.syzbot.org/findings/38560df7-46ef-4e6d-b6fa-6e0718f=
03397/triage_trajectory
>
> Oops: general protection fault, probably for non-canonical address 0xdfff=
fc000000001b: 0000 [#1] SMP KASAN PTI
> KASAN: null-ptr-deref in range [0x00000000000000d8-0x00000000000000df]
> CPU: 0 UID: 0 PID: 5730 Comm: syz.0.6 Not tainted syzkaller #0 PREEMPT(fu=
ll)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:keyctl_session_to_parent+0x825/0xa30
> Code: 35 3b fd e9 fe fa ff ff e8 38 35 3b fd e9 f4 fa ff ff e8 2e 35 3b f=
d 48 8b 54 24 20 48 81 c2 d8 00 00 00 48 89 d0 48 c1 e8 03 <0f> b6 04 18 84=
 c0 0f 85 b2 01 00 00 8b 2a 89 ef 8b 5c 24 1c 89 de
> RSP: 0018:ffffc9000621fc70 EFLAGS: 00010006
> RAX: 000000000000001b RBX: dffffc0000000000 RCX: ffff88810b603c00
> RDX: 00000000000000d8 RSI: 0000000000000000 RDI: 0000000000000000
> RBP: 0000000000000000 R08: 0000000000000003 R09: 0000000000000004
> R10: dffffc0000000000 R11: fffff52000c43f7c R12: ffff88811a010000
> R13: 0000000000000000 R14: ffff88810c2631a8 R15: 0000000000000000
> FS:  00007f7f2068b6c0(0000) GS:ffff88818c4bf000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f7f2068aff8 CR3: 000000010cae8000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  __se_sys_keyctl+0x780/0x9d0
>  do_syscall_64+0x166/0x520
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f7f1f79f559
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007f7f2068b028 EFLAGS: 00000246 ORIG_RAX: 00000000000000fa
> RAX: ffffffffffffffda RBX: 00007f7f1fa26270 RCX: 00007f7f1f79f559
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000012
> RBP: 00007f7f1f836b20 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f7f1fa26308 R14: 00007f7f1fa26270 R15: 00007ffe789f59b8
>  </TASK>
> Modules linked in:
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:keyctl_session_to_parent+0x825/0xa30
> Code: 35 3b fd e9 fe fa ff ff e8 38 35 3b fd e9 f4 fa ff ff e8 2e 35 3b f=
d 48 8b 54 24 20 48 81 c2 d8 00 00 00 48 89 d0 48 c1 e8 03 <0f> b6 04 18 84=
 c0 0f 85 b2 01 00 00 8b 2a 89 ef 8b 5c 24 1c 89 de
> RSP: 0018:ffffc9000621fc70 EFLAGS: 00010006
> RAX: 000000000000001b RBX: dffffc0000000000 RCX: ffff88810b603c00
> RDX: 00000000000000d8 RSI: 0000000000000000 RDI: 0000000000000000
> RBP: 0000000000000000 R08: 0000000000000003 R09: 0000000000000004
> R10: dffffc0000000000 R11: fffff52000c43f7c R12: ffff88811a010000
> R13: 0000000000000000 R14: ffff88810c2631a8 R15: 0000000000000000
> FS:  00007f7f2068b6c0(0000) GS:ffff88818c4bf000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f7f2068aff8 CR3: 000000010cae8000 CR4: 00000000000006f0
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
> To test a fix for this bug, please reply with `#syz test`
> (on a separate line) and attach the patch to the email.
>
> Notes:
> - The patch will be applied on top of the tested series (as an
>   incremental fix).
> - To test a new version of the whole series, please send it directly
>   to syzbot@lists.linux.dev.
> - Arguments like custom git repos and branches are not supported.
>
> The email will later be sent to:
> [corbet@lwn.net dhowells@redhat.com ebiggers@kernel.org jannh@google.com =
jarkko@kernel.org jmorris@namei.org keyrings@vger.kernel.org linux-doc@vger=
.kernel.org linux-kernel@vger.kernel.org linux-security-module@vger.kernel.=
org paul@paul-moore.com rdunlap@infradead.org serge@hallyn.com skhan@linuxf=
oundation.org stable@vger.kernel.org]
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
-upstream-moderation/6ad802ff.5c73e770.1a06c9.013d.GAE%40google.com.
