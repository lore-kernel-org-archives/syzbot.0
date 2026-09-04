Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFD754A9D4B
	for <syzbot@lists.linux.dev>; Fri,  4 Sep 2026 14:27:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=100.103.45.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788532076; cv=pass; b=HBGUFomDnbfV+p6uVy8Ug30U3BL0BPEyFJwUHXYoOUCCmboPBTTimVKAEVSMXQ8retOUkMiLQO8RudRigUVbDVd/yRI5VOdTmL0zQMocQdU8pEOc+k+I+D1EoY3x/IDt9RKTGvJNclASsf52dqu/wQR6JNFt8WMZ2DiWU9UGy+M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788532076; c=relaxed/simple;
	bh=6lFk0S149fgCPNaFiJWpb+pm0L8Kv++NX4HPCqLLNXo=;
	h=Message-ID:Date:Content-Type:MIME-Version:From:To:Subject:
	 In-Reply-To:References; b=FIhIkNK0O764zJoWyIwO0Vu5/3nbiqOyUpFNlV7R4u/9NN9FtiuZtjA4VEeN2DqSk5RyDom66DUU+uPSkz3XuJZGLtnzaLmP4fZ64o4oxluFHFzIqYboDsbHtZduG87c0ITV57uRFX9hgP+9Cuu/v/yn/yT2v0Ep/URoGgHROTc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ImmUqbTe; arc=pass smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ImmUqbTe"
Received: by smtp.kernel.org (Postfix)
	id BC3261F00A3E; Fri,  4 Sep 2026 14:27:55 +0000 (UTC)
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=209.85.160.47
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1788532075;
	b=VKsms1hj/DFwuw1cqp1wPYk+A5lUHYqFFuGI7ZO0MoAWmfA9CpMydLwd3gUj5BroZf0Y
	 JstaJq8dK9KHf1Gn06p3iWBQ1noBe9PiD7EuawPiy0z99UG8xxagqGI3bTUatIzFyBKgd
	 /11oZYTzUP4cVZnNNJR0PvF5pC60hhpxL7Sm9aXImBj96EnqR++JBngHGoXpgdBRRIb3Q
	 H000pqSDDwsDHzmiTXPVu17yTXUerFm7foLAxNdTHKjWG7MNTD+GpNVVxx1M3zWF3diLe
	 97w0O8ekJ3Tuyy+n3HMtEBtsx6cgDwGTCTdcl9GdKhbW7x5+C8WASk188j5WrddfdHQ==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1788532075;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Date:Content-Type:MIME-Version:From:To:Subject:In-Reply-To:
	 References:Reply-To;
	bh=ggIVotpWA5C/SZeEfzMLbPMFrffkhMuKxlCmQG2N5w4=;
	b=udbEDz9iKUxKAcYifTzA61r6OPKjhDuwLqa6pCwBrBgAOIFb9Ik4jcQPG9EjWEvTDhGd
	 HnmxCXeOZdc5HThk7ztrCDDYxe94qVsBqvNlmP9mOynCs2hPQGITnUKs68cdwwVl2OfU5
	 aqGTAvl+4V3AspUyhHjGqyaiD/SoLctrNs03J32wlW26ha64Z++2laMfCcRwhHrJCIrPP
	 2O0mbRDTvpBIHyEwzS1RbfQMiRMGmnrJ9lL+uYKxtr3cW7tzsFJuN5t/oRsWqhbufaIMR
	 hNna8GNBHCVDOnIg30LncMqEGKIYDCkA2UgSPPNTUFdNlgLvL2c9dhVhHVRbJLuxAzg==
ARC-Authentication-Results: i=1; smtp.kernel.org; dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=ImmUqbTe;
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	arc=none smtp.remote-ip=209.85.160.47
Received: from mail-oa1-f47.google.com (mail-oa1-f47.google.com [209.85.160.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 2CC301F00A3D
	for <syzbot@kernel.org>; Fri,  4 Sep 2026 14:27:55 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=ImmUqbTe
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.kernel.org 2CC301F00A3D
Authentication-Results: smtp.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oa1-f47.google.com with SMTP id 586e51a60fabf-465cfc7e33dso634494fac.1
        for <syzbot@kernel.org>; Fri, 04 Sep 2026 07:27:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788532074; x=1789136874; darn=kernel.org;
        h=reply-to:references:in-reply-to:subject:to:from:mime-version
         :content-type:date:message-id:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=ggIVotpWA5C/SZeEfzMLbPMFrffkhMuKxlCmQG2N5w4=;
        b=ImmUqbTedcUwXz++vxIUc63lStCR2zW4SWZIuyYB1VlyCZJASz1vYgtqf+nrgKpiU6
         YNkM/7NQxidLo5yQiUdE2T07h5sk3QHPLbrrydn5aUrGGhfLQydUkm8tUwebD0dWbPjw
         Y9iBN0+DI79EyzktTjhQIDHnhDkVQA7goXmlS3IXaN3tLJ020RA4dalnpq4ZVJTpS3mM
         LkYPQQrZ9ZRfjvLNJIv7W8A/dUv4lWCW/I9aedl7iKcGE+PCUH6AiZ/tN5noO5KwZO2R
         3LJ6KhqvoJXs15QzxLt8/MUhUPNWMOsRjuAB8ZILitDxUfA0R/z3XpfFFx1tkex0D0eN
         zpbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788532074; x=1789136874;
        h=reply-to:references:in-reply-to:subject:to:from:mime-version
         :content-type:date:message-id:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=ggIVotpWA5C/SZeEfzMLbPMFrffkhMuKxlCmQG2N5w4=;
        b=e/wWLZuusOLkZ450o4J8ORJjLTEmUuMS0SbWJM6qlQcwrjdZ4o/mxB9aUj3y5dS53C
         18lG/NdRgeDb0ocSlXJEAFnpcIfTv09z+tw9BMWOlxrPz9yLfvE+6bwsfGwfzIDwXyAj
         WAOp0RIKXGHzfU6HnaJ7eag+uEPEBWQOPCKBHOwBrkRHXwW6bKEQEcE8075QBnNgnCeb
         RPbMxfeH48uE+tqHneYu0T0Vq9i0i99Swec1obcao9Io3UmIpIjnyqjH6ih0O2H7EsVd
         gpwFcXlmxkj1MZcWxArw1FHTmgfZf7vk49NPkqD848DkwtxaBmqvIHJ2MSfJhUqFC49W
         5Z7w==
X-Forwarded-Encrypted: i=1; AKwUvBzP8GjQSgEeINH3Xh+9BtCQYkX+G8QVT+tdc1IEg0G0KbgXIJFXMZaOHSBzI6Hx8giS4yD763M=@kernel.org
X-Gm-Message-State: AFuF++l1Kf2N18Yn+eU8540pg5uhG/CxC3E46txTcrwmsXXOwt+6ki0Y
	HuZHOdwFokmGEWTNm5/Ue4CzYY+ACbWsgzYLobVPzuqS+eScERrGeNGpjxZGTw==
X-Gm-Gg: AYBFou37q0jGiZEZ7tpAK5JQJDxoCnGiRxAy3bFcoUjxEyXkqKCgcpQQm8XGGxRx77v
	3M2e/uZjvSHcpBMvmypNiE3iMNOAZHmgJqYTnbSwBAgYxc9PHiJVKFgfOq1hGMTgKS+UGZ5bo3I
	3EzeqjTcYkP/SZ+i71gZohAU43Swb2PkHl05bxzef4jSqt8BYkocNPKJxiUU6RZHm5/tIb6c5Za
	7buEGNdfTEe8OO9HMGgMqiPBE0pdxafB+c9IA8VnbZC0untl6OPftnBT00S2vKlTDJPXRW2OOXm
	FU4VicqbFp3UdYSHpXC8rFF9DL0XPEVEvY87dq15irPcALGDnMNTouIsBYHHNA5pV/dyksmv+SW
	sDej80+2rX52Yem9NDAwE92FYFylwhMV2mPtz9TK2Zs6gQ1/ab34neJaXPf+jy8rBzNGQqHuil+
	xBlbiYAe4FQ96lp7Hzpf5DimWoBu0JEyusE5riomCWIL5ljxuy7CnkGbwcwohTE11AW0E=
X-Received: by 2002:a05:6870:326b:b0:448:9d5b:6393 with SMTP id 586e51a60fabf-47552f997eamr5422727fac.14.1788532073674;
        Fri, 04 Sep 2026 07:27:53 -0700 (PDT)
Received: from [172.17.0.2] ([40.78.174.137])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-475541a8becsm2126742fac.6.2026.09.04.07.27.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2026 07:27:53 -0700 (PDT)
Message-ID: <6a9ad569.8cf4c31a.265cdb.1cdc@mx.google.com>
Date: Fri, 04 Sep 2026 07:27:53 -0700 (PDT)
Content-Type: multipart/mixed; boundary="===============3690236689241224167=="
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
From: bluez.test.bot@gmail.com
To: linux-bluetooth@vger.kernel.org, syzbot@kernel.org
Subject: RE: Bluetooth: hci_sysfs: Fix NULL pointer dereference in device_del()
In-Reply-To: <388cbac3-b865-4843-bd65-c74059a5a459@mail.kernel.org>
References: <388cbac3-b865-4843-bd65-c74059a5a459@mail.kernel.org>
Reply-To: linux-bluetooth@vger.kernel.org

--===============3690236689241224167==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

This is automated email and please do not reply to this email!

Dear submitter,

Thank you for submitting the patches to the linux bluetooth mailing list.
This is a CI test results with your patch series:
PW Link:https://patchwork.kernel.org/project/bluetooth/list/?series=1158014

---Test result---

Test Summary:
CheckPatch                    PASS      0.65 seconds
VerifyFixes                   PASS      0.11 seconds
VerifySignedoff               PASS      0.11 seconds
GitLint                       PASS      0.27 seconds
SubjectPrefix                 PASS      0.14 seconds
BuildKernel                   PASS      25.18 seconds
CheckAllWarning               PASS      27.84 seconds
CheckSparse                   PASS      26.18 seconds
BuildKernel32                 PASS      24.60 seconds
CheckKernelLLVM               SKIP      0.00 seconds
TestRunnerSetup               PASS      443.05 seconds
TestRunner_l2cap-tester       PASS      68.34 seconds
TestRunner_iso-tester         PASS      120.15 seconds
TestRunner_bnep-tester        PASS      18.43 seconds
TestRunner_mgmt-tester        FAIL      228.15 seconds
TestRunner_rfcomm-tester      PASS      25.11 seconds
TestRunner_sco-tester         PASS      31.71 seconds
TestRunner_ioctl-tester       PASS      25.97 seconds
TestRunner_mesh-tester        FAIL      25.05 seconds
TestRunner_smp-tester         PASS      22.84 seconds
TestRunner_userchan-tester    PASS      19.23 seconds
TestRunner_6lowpan-tester     PASS      22.58 seconds
IncrementalBuild              PASS      23.17 seconds

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
Read Exp Feature - Success                           Failed       0.256 seconds
##############################
Test: TestRunner_mesh-tester - FAIL
Desc: Run mesh-tester with test-runner
Output:
Total: 10, Passed: 8 (80.0%), Failed: 2, Not Run: 0

Failed Test Cases
Mesh - Send cancel - 1                               Timed out    2.028 seconds
Mesh - Send cancel - 2                               Timed out    1.984 seconds


https://github.com/bluez/bluetooth-next/pull/706

---
Regards,
Linux Bluetooth


--===============3690236689241224167==--
