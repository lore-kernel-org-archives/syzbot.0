Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE9893B3C06
	for <syzbot@lists.linux.dev>; Fri, 31 Jul 2026 17:36:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785519408; cv=none; b=UwrrJ1jp0puG/tRZZk0IzYgvVFu7h9e77VA/5akN+qzZ9ZVoeUNTLnLmK4/d85CaxZ0YUgWh/SV+W9nbKH4gDQu+LIaX+lIkMIdETXLdfEjBPBGKAm2afyxKeOGjlP+jKJ+qqMG7AgMhYp9I8aGEYugfZlGZPXAhwaEpswmmfqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785519408; c=relaxed/simple;
	bh=5rMAalagN56/weROSlL6wJbFGqOBGeThRNRcu4xHlZ8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KMDigwkFoJOOkYpzQLHITyFhMJFX2Za1wV8U70/Db4k2HCCGtlJgL29tR0LSs2kC2XbRYYIiF16keNWt1kyrgZmJziRU5QtZYCyMvETcaiILtuegsiz8IIWENQ3BMAyOX+gAaFSPA2tF9MMB/kmLjrVLxxOJ82ZCos6SJCpiaMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=e+YaYwMt; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=cSpjkT0k; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="e+YaYwMt";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="cSpjkT0k"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66VFOXt8353851
	for <syzbot@lists.linux.dev>; Fri, 31 Jul 2026 17:36:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	0gEn7xw74OTgVFYsNjZCPpjdx5PO6g9E5jzZSDfnuIg=; b=e+YaYwMtjJZQJ1rn
	5tP7le+ir/4lsZo2BN2rMfNaQGS1YLtY7VhVM2bOmKR8ci2W3EAh3YLI0BtZGVRJ
	1sXLGkWMWP3vXsw75BlddZ8RFxOgUAEdy83K/I6jjlibYSSMDMAZ2mJSesDCYOjN
	bXTjZxBe0tJ15y5a8zkPQvTD9VJngy/NOa/x1zNVC4sNCmOK1X+tLkd7SBybT27B
	mhlrfh6Qgca3aOB51/87X1pjcRvZDqs6Xvwq1OjiLr+3cjyn6k2z4etuU8Odu4vK
	gyAUyYZ0ncb0KHyogjQrm5Inszia+Qf2xwPft4xiAo8xFISo6LE/AfCscW6HW/Bk
	6jjhwA==
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com [209.85.215.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fru481c7s-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <syzbot@lists.linux.dev>; Fri, 31 Jul 2026 17:36:45 +0000 (GMT)
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-cbb92868263so1575222a12.2
        for <syzbot@lists.linux.dev>; Fri, 31 Jul 2026 10:36:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1785519405; x=1786124205; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0gEn7xw74OTgVFYsNjZCPpjdx5PO6g9E5jzZSDfnuIg=;
        b=cSpjkT0kA4+3Mhk+xhNOE+Gx3mtl3uOlTM9duD0LmkrxW02hPLzkcerVIN4Z+wCBSq
         vsydhMe2Lf3r3mEtm8H6YmggXBYBIJ/6laPcG/AsEqhaMoCI0jPC5CmFvh83eCfrJD1m
         RaBKBGI+q9w+/Eg959CoeEq/tIDJXCGKSCsGhP4yfaKychRHB9Lp91IrsAYIJFmIUgET
         TPW5AiyFeckEAyq/IfJanJEVLgOBvMcjwIozlsrKyvSs93IXqxdzuLYModawO2flBsC0
         +o2+xWZaZPHoWpjXLD3DL4BcwxSOEpVneKXILSP2NS8Se6AK5/AwKfle8UlzGVYekLup
         nUeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785519405; x=1786124205;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=0gEn7xw74OTgVFYsNjZCPpjdx5PO6g9E5jzZSDfnuIg=;
        b=K3InbninxdBoFqVGkCPXklx4jQ+AaoeCzNjIWaaBv8W+huy3lPAvDEnWOy5fILh1Kz
         GTbp6AUryovc3zaJ6ZMRK+80PJ8kC2SRjqjFOuNUhLwADQqDbH9TZY9lO2EPPN22O4B4
         RHF1PCQrkva4u/lDZp6IBSTZf/H792mqJOOB5CCoTK2ut7tLCD3Fdu6caTWWfEkm5qOM
         2dZWkGfuH8qf+cySSzR+vWoN7TTpCnPFrotv5lcB+ykjbdUvpoWNMcdP+iIuAM4Vk/cG
         +AWqPTVfenfGdVHVaiI7AQisk21AG1bRdoFUCcIhvhmlobv5eyi4zSuPPG8dt6sMWjfr
         ECzw==
X-Forwarded-Encrypted: i=1; AHgh+RqNji+FzCXyVzLgbyTPCCDoageT2bCO9HpPxndQj8wz4Np5v/jQvalXgZUvQ3YSLWFp1NS0rTs=@lists.linux.dev
X-Gm-Message-State: AOJu0YypZRtL4SRvKTKCtKlYAS4nt9cA4E6SL1HgYwE3YReTBlq/UgJh
	vCW4uasJR14lliVSCeS7AzWBsxKgpm8/4M1UA3WDtRRU/uR5FQqgDqB+pxYL/a+5IZdH3bQR7lK
	1Dpu8PWv2MuVySqs5O7nmcwYJPLWemhisq4TxvaziUiudqeporB5W+qCa/zlapvuGYEI=
X-Gm-Gg: AR+sD10ldo+J1NxDCh5AcmXoX41Xh217sCFWHRwL9aCLdFxBj07ZaYH312aurP/1Fr4
	grrdxP8lL0FOnhmB3M/hUngek2sy5tOQrheLymff/bPNwiSOcprJy7G3pRf/GDHQNvQFNyQoDUg
	k5aST+eUM+CYbmdECmzpJa7VKvKVMDO0KCj/xi2Ehl3rxlz7GtPOi4+MXkg2QtBrTGsBJwCAOo3
	ZsrFKUYJryFKmPu0X8yCEpla5LT7o2cK0LX4RLka5LU64ECk0IbzkCCF2U9bY8Lj5AiHAq5nv2s
	ufupv2f7mrmZyWPQ6F1r93Dy0RNkhM6Zt+osX0OX+qmWkCFk3VxcJ7Wq8GBoD0ixsNMFP7ZeV+s
	optizEhKz0/pitHHuc9jfT19YX+WV3Qpl45ec6MxRWbefsb8Z/IOcpepRVr+W
X-Received: by 2002:a05:6a20:4387:b0:3ba:e5e2:73bf with SMTP id adf61e73a8af0-3c92a8139b0mr653023637.43.1785519404680;
        Fri, 31 Jul 2026 10:36:44 -0700 (PDT)
X-Received: by 2002:a05:6a20:4387:b0:3ba:e5e2:73bf with SMTP id adf61e73a8af0-3c92a8139b0mr652994637.43.1785519404267;
        Fri, 31 Jul 2026 10:36:44 -0700 (PDT)
Received: from [10.227.110.203] (i-global254.qualcomm.com. [199.106.103.254])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3153e06f8dbsm8202554eec.22.2026.07.31.10.36.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 31 Jul 2026 10:36:43 -0700 (PDT)
Message-ID: <dbe5b96e-c95c-474e-aca0-8227fee4682a@oss.qualcomm.com>
Date: Fri, 31 Jul 2026 10:36:42 -0700
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] wifi: zd1211rw: reject secondary interfaces to prevent
 conflicts
To: syzbot <syzbot@kernel.org>, syzkaller-bugs@googlegroups.com,
        Slawomir Stepien <sst@poczta.fm>, linux-wireless@vger.kernel.org,
        Daniel Drake <dsd@gentoo.org>
Cc: johannes.berg@intel.com, kees@kernel.org, linux-kernel@vger.kernel.org,
        nihaal@cse.iitm.ac.in, syzbot@lists.linux.dev,
        workflows@vger.kernel.org
References: <0720e3ad-d98e-47d7-89af-4d22416b0fbc@mail.kernel.org>
Content-Language: en-US
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
In-Reply-To: <0720e3ad-d98e-47d7-89af-4d22416b0fbc@mail.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=IJsyzAvG c=1 sm=1 tr=0 ts=6a6cdd2d cx=c_pps
 a=Oh5Dbbf/trHjhBongsHeRQ==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22
 a=edf1wS77AAAA:8 a=VwQbUJbxAAAA:8 a=hSkVLCK3AAAA:8 a=I3P1pAe5SESMdPKYoDcA:9
 a=QEXdDO2ut3YA:10 a=_Vgx9l1VpLgwpw_dHYaR:22 a=DcSpbTIhAlouE1Uv7lRv:22
 a=cQPPKAXgyycSBL8etih5:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzMxMDEzNSBTYWx0ZWRfXxBi42e0UPNqi
 FlpIcgwGsmfzC4MjLUTyWyjwzOssaYY3fo3cXU9bFbiksMl95jSQZp7i8Jn2iXIlzrc3VWYPLAV
 qCjcydllaILMGiYni9YLAux8ortPerA=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzMxMDEzNSBTYWx0ZWRfX+VCV3Zi6nkNr
 U6y45VqWR84BJ2ORfwJbOZRl8Xsvvt49KP17q95kVSFUBQicTx9sZhDTpclWTO4FPo6tAyr1iRN
 bv67YUG2qUbREgjLoyz3mwOVPEnfVvDZNrqvvYOEsWfq0uI5Jw1kMb4MgccEsToE2RpnyxN6Kfc
 tT8E4/PjLPrd1huqw1gV0Yfg3p/gMSIl0M/tUR5rY9cs8FbDFFMoqAUzdleqpuu7/jS320JGR6d
 h5KW4SCsXazj2lfgBt9FE5Clv2sPBA2Nky15Mxq1R+ctLmcVh4Xwuioo7SWd2K/wFm6qObYiOEC
 FoHMv94G/UOw+8sh7nn+aEC60Wy27Xc6iAYqll07SeakzbPl58d9o3+yC9eb6fChqNrKrMNu7hA
 wJNFA5TWvEaX2zejsb7TmAfpbGwDWTsR4QkQN5sc7orm8ZAm5Ktj5elFlEDhH1jmIES4mQPsa8P
 6QDCUiPCCKSTZOHdEoA==
X-Proofpoint-GUID: HZUoRXVPLR2LDQVc-6I9JXtVM2Ht5ifO
X-Proofpoint-ORIG-GUID: HZUoRXVPLR2LDQVc-6I9JXtVM2Ht5ifO
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-31_05,2026-07-30_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 priorityscore=1501 malwarescore=0 suspectscore=0 phishscore=0
 adultscore=0 clxscore=1015 lowpriorityscore=0 spamscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607310135

On 7/29/2026 1:04 AM, syzbot wrote:
> From: Slawomir Stepien <sst@poczta.fm>
> 
> The zd1211rw driver is designed for single-function Wi-Fi dongles and
> hardcodes its USB endpoints. When a malformed USB device exposes multiple
> interfaces that match the driver's device ID, the driver blindly binds to
> all of them.
> 
> During probe(), the driver calls usb_reset_device(), which iterates over
> all interfaces and invokes the pre_reset() callback for each bound
> interface. Since multiple interfaces are bound to zd1211rw, pre_reset() is
> called sequentially for each instance, acquiring their respective
> &mac->chip.mutex. Because all instances initialize their mutexes with the
> same lock class, lockdep detects a task acquiring a lock of the same class
> it already holds and flags it as a possible recursive deadlock:
> 
> WARNING: possible recursive locking detected
> kworker/0:1/11 is trying to acquire lock:
> ffff88810371dde0 (&chip->mutex){+.+.}-{4:4}, at:
> zd_chip_disable_rxtx+0x20/0x50
> drivers/net/wireless/zydas/zd1211rw/zd_chip.c:1465
> 
> but task is already holding lock:
> ffff8881138ddde0 (&chip->mutex){+.+.}-{4:4}, at: pre_reset+0x28c/0x380
> drivers/net/wireless/zydas/zd1211rw/zd_usb.c:1505
> 
> Fix this by explicitly rejecting secondary interfaces (bInterfaceNumber !=
> 0) during probe(). This ensures that only a single instance of the driver
> binds to the device, eliminating the recursive locking scenario.
> 
> Fixes: e85d0918b54f ("[PATCH] ZyDAS ZD1211 USB-WLAN driver")
> Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot
> Reported-by: syzbot+0ec3d1a6cf1fbe79c153@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=0ec3d1a6cf1fbe79c153
> Link: https://syzkaller.appspot.com/ai_job?id=00724ef7-fd77-4cde-9779-895b8f63c2f6
> Signed-off-by: Slawomir Stepien <sst@poczta.fm>

E-mail from syzbot but SOB from a human?

I read the trailer, but this seems to violate:
https://docs.kernel.org/process/coding-assistants.html

Namely:
AI agents MUST NOT add Signed-off-by tags. Only humans can legally certify the
Developer Certificate of Origin (DCO).

+workflows list
