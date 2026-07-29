Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B987382371
	for <syzbot@lists.linux.dev>; Wed, 29 Jul 2026 18:53:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785351218; cv=none; b=kMrVR8O+tgjbR1bppQdQHrB/mASeiknwL8hEekRCmvuo7nkqKNPHMbX+4CraIMJGkDdMPk2k/IGkjWsCughbLzMCjthvO54wP2Q0vR2fWBA/kScKTi99uu9aRnSvftVxk6z8pI39PtBJBNMFzwpqj+IxDvs7opCMKYlsXhuCdrg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785351218; c=relaxed/simple;
	bh=mIdBjX8uWqj3jMTW4Q4CHO0TOmt+GQF84JHyOLNKTHY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Y/17gKDUSKM+2USZtf5YIE8baxTWqeh14b3wJBaaH/EorDTwqWv5fuYTg+rCk0BRLqqhje92apZBX+QyKetE9HzJ+CVCAJ3msjNe2LSDiLDMSa98RH1/xwFPuoqlZe6urceE4S5CwPwW648g9BhIBJSOXlKf33i2cwFQPRjI+hk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=CpMHFBK0; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=amJ3Bb1s; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="CpMHFBK0";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="amJ3Bb1s"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66TIQqLm2830835
	for <syzbot@lists.linux.dev>; Wed, 29 Jul 2026 18:53:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	GGb/D0+cHzWfDdgb8vv4OyJOIxrUr1v/2y04Z8q3NrA=; b=CpMHFBK0Dt3WId6t
	94I3Gp4gLVZx+iRAu4EGJk19Pgd2L29Szjb1iMI214t1oAG3jWxypJSPfIJ/qRKj
	sijV3O6LKp0e6/qq+5zecS0Ga9RG+BeHfKbb0h0Un6ffOmTUDiticdMCLI+P+eYB
	umAbrER3dIeFaLdDEJ9shbRKuRQNf4BYc/r5lT8pQPyHEUsTLkLs+7Cr3yklMKTk
	QRBMRSyQa6wSabS+/iSfa07huE6x5ZiD0WbMcNKtFRvAWP0KNTbsxhoUXmc9MZX8
	jXxKCtHMS6BdMRru09gYb3R0QoZ9TzP8DwU7o8AVps4QGMAM+ks/QAZlwPIb8dVV
	2aDvcQ==
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fqhe9a2ah-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <syzbot@lists.linux.dev>; Wed, 29 Jul 2026 18:53:36 +0000 (GMT)
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2cc7e86e7c5so24050995ad.3
        for <syzbot@lists.linux.dev>; Wed, 29 Jul 2026 11:53:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1785351216; x=1785956016; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=GGb/D0+cHzWfDdgb8vv4OyJOIxrUr1v/2y04Z8q3NrA=;
        b=amJ3Bb1syloMdaaBTRQ3EYeklKXhg6LKj44HNYbDGwBWpArzwzsPu+NsTqwkgIUS2a
         j4YiTYymK+EK9yeohH4RDkHRRA81HEOkfo5x3r4PRnrH2H8gQWGzaC8JEqsuwQldkAEc
         Oeb5zMrWEgkf9aocgCXnYJ4vMHtK1fgow8p0HtfYdNhqzPg/OmG+6hG6stgY51zsPQDm
         mfD5w4La03svJb3+4bcoqPKJY2187pCvt1gQbrtd9iWNyQfXe3C/3ZmtEEtOYZZFoYQs
         f+KZ2EPf3HzfhKwgqFYd5lsiPLxna1jqSxhk78M9Tgw58fdGG242yRMnybrWlrs3T95+
         I8eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785351216; x=1785956016;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=GGb/D0+cHzWfDdgb8vv4OyJOIxrUr1v/2y04Z8q3NrA=;
        b=cp7YTmbJpjvYC/XTpHKdBBgJS9D7ScJqMnBnsXXkDmyOF+EcyOkZEq+8P2gsU5sW5o
         t0xXHMzypr6A8pI+HPR+ecQNBGuyQ5LV7acR4eJvx6VZswE+xGki31rdWW6PnujpqfMk
         5q7UnD1FkTXUBfrMwIWyMO07JiHFij70P7eDHm4njg9DsZ+OxPBf4deP+058TPz32nqJ
         TeBcYacvUh8RrjBC3zcx/QqAVDtRlzdzNLNrzFuzBa57qmf2LZRJPRIvVudUfEitDA6D
         p2osBRDodXBfECR0y+R2dlMrqsjP/Wo2FkaKjujAIkjMS70bjvNHZDXAIYRR/EEQjadH
         +XiQ==
X-Forwarded-Encrypted: i=1; AHgh+RpWsanXLJPG+AHBjMVLPDD3fKB2TIDEz6OGskAhBVAPH7iWfHBaekxJPV9marndkaZV5aua+tw=@lists.linux.dev
X-Gm-Message-State: AOJu0YwZ4nK3Zbk4ZJjXtOFSwZnjbBRW66E51jtd7hjQcegFO97rnGhl
	OY2ud2JHHIQlek7FBkElQ8IHIwxtsqdTHGr2NbjzVl7EDWkEeWQaAU25F6LRgiQL90+6zCNTWCN
	QuEnCayySsh0lFNh9aWATc/mR5zkreCZ/hgQLglRRDn+qV+tYJylZiLdVwi9pFOTeTP8=
X-Gm-Gg: AR+sD109R6UZBuicAzXTL+ARaS/h7aeXKqaIzDYKV32RYb80KJCvgwxL8sv85MrZwKq
	3o1ZAMdI7SGlkjdqN6nfco2PSTBh1HKS/D3EMDcJgzCGaE2ARVPZTJC3VgABt4/DVnnMdXX4VCK
	LP83fC1/594jFB4chbsjXNwMpEZeS71nbRQntGc/nZ9ZN29fK2xtZXyEjSNmddJx6RO5Qvu9Lo2
	0KlHpoKtgxiG9SA7BnXVyuJVSrVYLCc/oFxtG+hW6gZGP4zK7fuwqH8QZrJnHQTpv9+kJzqfUM/
	piR2K1WxWVYCixz4iwZYBCaR13Gyt1KqLf11b5IwFdXEjNlfk6BPw5lNCyCCGBr2OhT7JJ6EmRi
	Q76rAXaRGmetDa9MibSZlblooW9DsnlWxY8ADrvpu8gIN5GUq0+wjG5BpZBMs
X-Received: by 2002:a17:903:19e4:b0:2cc:c9cb:371c with SMTP id d9443c01a7336-2d033d576c7mr632925ad.40.1785351215755;
        Wed, 29 Jul 2026 11:53:35 -0700 (PDT)
X-Received: by 2002:a17:903:19e4:b0:2cc:c9cb:371c with SMTP id d9443c01a7336-2d033d576c7mr632705ad.40.1785351215381;
        Wed, 29 Jul 2026 11:53:35 -0700 (PDT)
Received: from [10.227.110.203] (i-global254.qualcomm.com. [199.106.103.254])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-31504baa01dsm13218325eec.12.2026.07.29.11.53.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Jul 2026 11:53:34 -0700 (PDT)
Message-ID: <a8e1200f-5f79-4c86-915c-96464596fd0e@oss.qualcomm.com>
Date: Wed, 29 Jul 2026 11:53:32 -0700
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
        nihaal@cse.iitm.ac.in, syzbot@lists.linux.dev
References: <0720e3ad-d98e-47d7-89af-4d22416b0fbc@mail.kernel.org>
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <0720e3ad-d98e-47d7-89af-4d22416b0fbc@mail.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI5MDE0NCBTYWx0ZWRfX/pXKWN3khoWq
 Qq03sGb2uJg0uO4dBXT+k3daOr+b3+rvnyN0SRH83Gx4OX127lbpd13RfaX++ZQg8VvlXuztxGi
 vZLVsQdDmADt+7lrbEpfF1UNu8w08ruz/ifiGoqXyqOMgi7PZA9z3DVtp7bbmiFDrTkOAOG2a9f
 h8emit7jdfBE++x1htfMAYKlBLH3AVGbYg/NvuWesxfe8VggUA0pHFqE/MIickerKlCArfjb/sk
 gNaRztK+Z0UVFw2BFqVv666MINq8FbnnGZ7V1dggtSZ6Nm13ax6In09wC+AADscVDLrrZDXE2P+
 xjk3cxI8lASaxS3zH7pcnlczLXxihIckhd4V5BCQi46p41TylCDy9XS3879eJX42NSL/2+Tt9jl
 lTzD2H64T21cgGxO4fXX5zelhkbWXQQag+4hUIYAAt7PbFiLFo3FkS+CCzjStGu7sW87f541OCb
 X/581mS0NrbK5R2/H7w==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI5MDE0NCBTYWx0ZWRfX9+UwN7Gy6CAi
 NLz5YXMTcn8PpebAu6u5uBg2JpR+k2yPem7MxccSi9P+fHzzV2IgBXrl/Dsx9mkjowDBD/+64rQ
 zcGRK+qHZRBC6haQ4jtDs22O+WdegVk=
X-Proofpoint-ORIG-GUID: 05NhGaICmUFAR_49c0oaYAKmgOP-RgWB
X-Proofpoint-GUID: 05NhGaICmUFAR_49c0oaYAKmgOP-RgWB
X-Authority-Analysis: v=2.4 cv=EsriaycA c=1 sm=1 tr=0 ts=6a6a4c30 cx=c_pps
 a=JL+w9abYAAE89/QcEU+0QA==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yOCtJkima9RkubShWh1s:22
 a=hi2ICmPa-PouKQFzbIkA:9 a=QEXdDO2ut3YA:10 a=324X-CrmTo6CU4MGRt3R:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-29_07,2026-07-29_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1011 bulkscore=0 malwarescore=0 adultscore=0 priorityscore=1501
 spamscore=0 lowpriorityscore=0 impostorscore=0 phishscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607290144

On 7/29/2026 1:04 AM, syzbot wrote:
> @@ -1353,6 +1353,13 @@ static int probe(struct usb_interface *intf, const struct usb_device_id *id)
>  	struct zd_usb *usb;
>  	struct ieee80211_hw *hw = NULL;
>  
> +	/* ZD1211 devices are single-function. Reject secondary interfaces

this does not follow linux block comment style
/* should be on a separate line
(at one time networking code had a different style, but not now)

> +	 * to prevent multiple instances from conflicting on hardcoded endpoints
> +	 * and triggering recursive locking warnings.
> +	 */
> +	if (intf->cur_altsetting->desc.bInterfaceNumber != 0)
> +		return -ENODEV;
> +
>  	print_id(udev);
>  
>  	if (id->driver_info & DEVICE_INSTALLER)
> 
> 
> base-commit: 1590cf0329716306e948a8fc29f1d3ee87d3989f

