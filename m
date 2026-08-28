Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E889343CEED
	for <syzbot@lists.linux.dev>; Fri, 28 Aug 2026 12:25:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=100.103.45.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787919942; cv=pass; b=EZmJYGEfdMoDCwO4/Qwf3a3Q3FIPBnlHVAkvCLwAchpxdrCWj9NJiAeySv5wCSFUP1X6/Pms2ufe5KpgT6Y5r00pmJPGATKzKINCdv/krA/Sy966MdA1LhfHxHIir0/epRL+SUkSOj7t6zADZLwEEM4h7/Y5IwCQsO2SEMrkR1g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787919942; c=relaxed/simple;
	bh=4dOHM4Jcyiynb24Yy3fBsCK4hNeRCYxIhYIo1vRb0qU=;
	h=Message-ID:Date:Content-Type:MIME-Version:From:To:Subject:
	 In-Reply-To:References; b=E2rwB5ShNzloiYgNwS4g6Fl4K11wXGNg5D/ePmzLeIhNTDNz6bHEminmjbbSGDNCye6Lf1o72lajmGkFrXRDf1FzncjbDraG2sTODg+QV+XGzyW/uAu7KKBhs+aYjk08wwSJN5N+vE1cMUBA4IJ94alNwc2QcM7/WuQN7r4bzjo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=boWz+vhZ; arc=pass smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="boWz+vhZ"
Received: by smtp.kernel.org (Postfix)
	id B46D01F00A3A; Fri, 28 Aug 2026 12:25:31 +0000 (UTC)
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=209.85.160.50
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1787919931;
	b=k5k7xjzMfFl8wkPp6skNHzionKDCq8i1zi06Tl6N4gHFXpZTuI/Wa2GTbQff8d9ugoM0
	 QzKIAGOgLu5k4FiOoKrBK+e80jun0dqXUZV3Tg9jiN5ROhuKdArKNClPB3DRPudQ5hgak
	 VQhVDfVwGN2498saLr/l/MGKzkMU6dZmSa9zr+gUvSGPWA9JT8hXTz8FQ6vL8suiX1j5j
	 /Lc0rD+hSHVN1ZLAYkQFKXtnjdDF/8MdQSU23gLNusNpL5HvCVeaNUNVmEKLsUYjbX9zX
	 HUwK7lLC0Q1lSdbkcBa+MpdTv7qD8vo66SMTHom1x+VUhOJiy1HRMS7gYmhFQYUtWRg==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1787919931;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Date:Content-Type:MIME-Version:From:To:Subject:In-Reply-To:
	 References:Reply-To;
	bh=Taeen07Ab6QBzP5rvV4V5up2Wbw1UZylpsmEgYYI6Bg=;
	b=Dh83sOiUIMwvteIj6mfJk1cSyxT4ZMVLmt3CPj00Ljq+YyuOm2iLRUZTlxjS4mF8Leic
	 LsCjsE6IiOFlyS32AgAuZtpRfW5pxSzCVlmQ/QUhCQXgKjkaUrbdZmq7zlYSHIT8ONXiO
	 LnGH16YwpiHzv8tZz1ebkUK2NPHc5aO4SkYdY4gF9H3bg7fcMZWeLG6tCuP9cygDIMCgC
	 a/d5amCJHgAsPfpW2/hofj3yVLTg9HG2Y7H+zPyw96KeiufqHynk7mCrhAsiU7/tLU2zP
	 doq2dXDEK/4MrcZRsUk5VTEXm0Fe6oS/9jWySOZEo94cui8YGqW/0QMLghnrjKcBSoA==
ARC-Authentication-Results: i=1; smtp.kernel.org; dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=boWz+vhZ;
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	arc=none smtp.remote-ip=209.85.160.50
Received: from mail-oa1-f50.google.com (mail-oa1-f50.google.com [209.85.160.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 2AA9D1F000E9
	for <syzbot@kernel.org>; Fri, 28 Aug 2026 12:25:31 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=boWz+vhZ
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.kernel.org 2AA9D1F000E9
Authentication-Results: smtp.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oa1-f50.google.com with SMTP id 586e51a60fabf-465cfc7e33dso810567fac.1
        for <syzbot@kernel.org>; Fri, 28 Aug 2026 05:25:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787919930; x=1788524730; darn=kernel.org;
        h=reply-to:references:in-reply-to:subject:to:from:mime-version
         :content-type:date:message-id:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=Taeen07Ab6QBzP5rvV4V5up2Wbw1UZylpsmEgYYI6Bg=;
        b=boWz+vhZhUyMoYXJhqWvZ1TwqFgcK975THnaMsY263vWB6qqU8oDLd2PVsA4+HGdMC
         dq4cE52DBKSs9eHYy9NHAiHvYjN3kFVqvpRI+sVZZb3qUFj1SFHAfYXc16YpH0jK0a0A
         8ZS37BLCiqQLYPvydRR+yek0PYqQkciv0HlC1ns8W+2ya7UA9hhY1ztbsTjJ9DFQCQeV
         uUuil+cDQAxdqcybfqptybK9BaaHjtwG9jQLG5BaD8uWOlChQXLkbOlGeDSg8gaxbfyr
         hLzW7q15pOLvOijNSybeJJATCofWS75Jnefp8hXKo+Z7AiAVZD5rCuVkAZpCMkiypF4u
         LxGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787919930; x=1788524730;
        h=reply-to:references:in-reply-to:subject:to:from:mime-version
         :content-type:date:message-id:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=Taeen07Ab6QBzP5rvV4V5up2Wbw1UZylpsmEgYYI6Bg=;
        b=ao2hzRU9ew9Cf2NKcx0OZmNHJTqxAfJX6CJAT4xwfKfS77xEGVB44X/LTlOIbq3goZ
         Ypy1DcZO8jIs6EcfZsh4vI9D75WwNsJR7AvN5EqeDUFKjUR5UB5Ei814ZTelU0ct5ztL
         5aU0YvvyvamkyILY9prX2bQP0kK4oM+4XfEJP5A7u4NR3JyC0c+vDxfzvuy+YYRd/pI5
         ktgz/fiSb8THbnnUZUu2TkVeTbLmjm5/U64eqLqha1bu+hGX5368q36OGCloQZQkDn3D
         g+xxITiospVp63/VjNeLKimzFcj8rFInAPeDDre30blEPomehksGdPbUbEoHdUA5LPEZ
         nZqw==
X-Forwarded-Encrypted: i=1; AHgh+RrLrt3XVYsjyZb0QuHl2Y+0EHV6iZXvte6VSyAiz4izEpHt5YQmjeYTpn2lQ/g/NxhwPASKNAk=@kernel.org
X-Gm-Message-State: AFuF++msIUgu9OskbGWE7iRKFLv068RR1iqM+IhQL6bac1ULBuy13NRZ
	S9892BfZTUxLZjo4Gun+ro4q2b6EEcoxsZmq+6H66fP+Juq2MJb0Njlwf5WbwA==
X-Gm-Gg: AR+sD13849H+Hi+WtzA25d7+G6MV3vF3ig81qlZ8XJmSGtc0EBlIr8YONi7TCBn2Khg
	2OP4hurJHSB+XVLr+2z306d3KGNR+iJo/QykEgGjUbtaGQtezGgy9M2stZ3O4ZwKXMpogSHMh1g
	+mvIZa08yvu9vrLnnOt2VqwJG2N4yI6QufQ+edPh4nW/+BnbqP70obZhQ5rrjR8QbaMNG6Y51xg
	Eqh9BeFsqbmxI1WWl5T6/E7WaPaTpnLEnntVr5/6LiRZSb3mKJtdW5Zkzwp/yosLd7NfpYDwvEv
	GYkzMhb9U5DGBSbHX9VBzp65E8xYFU3phkcz63vNQz5IaF6QaAoPFwMe0ec+MTjiNo9flsgHLKh
	BlLD4cXE0D50Qu2GPjIoxnwxGGg2+l+mZhtttg5Szr0v2mTfANvgAgIdb/VgCcXaAqv3rc+gvEs
	WrVkE8vlDbN2qngvO45PT8G4MLibLCdzsNo42mi70NX9R0+TbQyqBl2LHrTGybuKO5mulM
X-Received: by 2002:a05:6870:a0b2:b0:44a:e7ac:b14 with SMTP id 586e51a60fabf-46837136d60mr7040279fac.11.1787919929902;
        Fri, 28 Aug 2026 05:25:29 -0700 (PDT)
Received: from [172.17.0.2] ([52.173.162.101])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-468a353d45asm1370173fac.7.2026.08.28.05.25.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Aug 2026 05:25:29 -0700 (PDT)
Message-ID: <6a917e39.566b9172.fde58.8cb8@mx.google.com>
Date: Fri, 28 Aug 2026 05:25:29 -0700 (PDT)
Content-Type: multipart/mixed; boundary="===============2566281102231485205=="
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
From: bluez.test.bot@gmail.com
To: linux-bluetooth@vger.kernel.org, syzbot@kernel.org
Subject: RE: Bluetooth: hci_core: Fix race condition during device registration
In-Reply-To: <7f282e86-b9fa-4a3d-8dea-208975771b35@mail.kernel.org>
References: <7f282e86-b9fa-4a3d-8dea-208975771b35@mail.kernel.org>
Reply-To: linux-bluetooth@vger.kernel.org

--===============2566281102231485205==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

This is automated email and please do not reply to this email!

Dear submitter,

Thank you for submitting the patches to the linux bluetooth mailing list.
This is a CI test results with your patch series:
PW Link:https://patchwork.kernel.org/project/bluetooth/list/?series=1153084

---Test result---

Test Summary:
CheckPatch                    PASS      0.89 seconds
VerifyFixes                   PASS      0.11 seconds
VerifySignedoff               PASS      0.11 seconds
GitLint                       PASS      0.29 seconds
SubjectPrefix                 PASS      0.10 seconds
BuildKernel                   PASS      27.41 seconds
CheckAllWarning               PASS      34.74 seconds
CheckSparse                   PASS      28.58 seconds
BuildKernel32                 PASS      25.52 seconds
CheckKernelLLVM               SKIP      0.00 seconds
TestRunnerSetup               PASS      466.41 seconds
TestRunner_l2cap-tester       PASS      64.57 seconds
TestRunner_iso-tester         PASS      132.46 seconds
TestRunner_bnep-tester        PASS      19.08 seconds
TestRunner_mgmt-tester        FAIL      216.23 seconds
TestRunner_rfcomm-tester      PASS      25.55 seconds
TestRunner_sco-tester         PASS      31.73 seconds
TestRunner_ioctl-tester       PASS      26.83 seconds
TestRunner_mesh-tester        FAIL      26.22 seconds
TestRunner_smp-tester         PASS      24.29 seconds
TestRunner_userchan-tester    PASS      20.68 seconds
TestRunner_6lowpan-tester     PASS      24.25 seconds
IncrementalBuild              PASS      25.80 seconds

Details
##############################
Test: CheckKernelLLVM - SKIP
Desc: Build kernel with LLVM + context analysis
Output:
Clang not found
##############################
Test: TestRunner_mgmt-tester - FAIL
Desc: Run mgmt-tester with test-runner
Output:
Total: 501, Passed: 496 (99.0%), Failed: 1, Not Run: 4

Failed Test Cases
Read Exp Feature - Success                           Failed       0.236 seconds
##############################
Test: TestRunner_mesh-tester - FAIL
Desc: Run mesh-tester with test-runner
Output:
Total: 10, Passed: 8 (80.0%), Failed: 2, Not Run: 0

Failed Test Cases
Mesh - Send cancel - 1                               Timed out    1.872 seconds
Mesh - Send cancel - 2                               Timed out    1.988 seconds


https://github.com/bluez/bluetooth-next/pull/660

---
Regards,
Linux Bluetooth


--===============2566281102231485205==--
