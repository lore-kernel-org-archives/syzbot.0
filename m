Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C58E37649E
	for <syzbot@lists.linux.dev>; Mon, 16 Mar 2026 21:14:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773695667; cv=fail; b=Xcgl/a/WCCL25PXKwIFEEheM6LAM5nj5qxt3s0cByqbVd+2CR93WZnWbsG+Kg/76e32zgkUDmxQSpZoxB5Bn8359yLJKyPnthFjR1zBZrSijd7FzBoD0Yrw/YjMYh164IDrFVuMmIeUaRsqNsjsknrJbZPzOSzLn4/ozThMYjiY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773695667; c=relaxed/simple;
	bh=kR/JCcPCw5CA0BA6PwvC49EF8H12KTxb+KxLNYZI78Y=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=C8tazciLUNIs5ouPqA/Gr/2mvfSWOUN6/2z+8xLkmY9w9zifcgsKe9j7n6vsw6EtmbhevZu46PRwZMu7ya8+SEyYCSXcG03BQ1/UI88vFxxQbKoqkkDS4cxXXzdUkRDSVBP8y9/2K0dR78L0AGyqsBBCm1IqlJ8+1fMp8rq7teA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=hHEvxxy9; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=vGB0t8DR; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="hHEvxxy9";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="vGB0t8DR"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62GKXaN2494946;
	Mon, 16 Mar 2026 21:14:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=FNSD6j1Y1zNZdgg0nsIJm1a+SdjaGCR2mEvsZMs+3c0=; b=
	hHEvxxy9baYfxYT9+QlUqa5N3CpHnm0hC1Ctdlbsg2gNb+1bRjIcQk+zGEAUTR0/
	fxmJ6BW5OWmpGZ4s8XRowwF214KXLX/aou2qmNWHFocXTPNM+CpOauX1dwxmVnMk
	vcstEvy9wIUCLbi8MBnIrk+VZRBqYOMxUSlEyq4ihPrX8BIY9qnfwh8cBjILHj8h
	oDxGAGaRDRfRH4VbrxaHllIiKJ4ydAejINAeP0skMYKrmWdpPIzH+GlRxGbR44NF
	LliEXAsvxZNWJYBgSckapWQ4IqvpRa98/vhcwgbhcHoESDVtp3AamBpwm6jn0+65
	+8GApHu/lCmd4CO71gNbfQ==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cvy9ru2pm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 16 Mar 2026 21:14:23 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 62GJNL0B002854;
	Mon, 16 Mar 2026 21:14:23 GMT
Received: from bl0pr03cu003.outbound.protection.outlook.com (mail-eastusazon11012060.outbound.protection.outlook.com [52.101.53.60])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4cvx4kdmm7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 16 Mar 2026 21:14:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ifEU0FOROYtZw4mS7sjPrdDkSFzecRsXAjlX064vCG0/5Mx+Z6NSAObZBdCtbDyBUFigwGxirWyh3JAUow/JxYkftGT7lVhUdVfvauOTg71ufMfDjr4LRMHIUBM2TvTW+OMkVxSfcJKE+GjLbYtH0sV59d3h1iY3mObMag+jrFot2DEtBRUpDiOF65pJEhEoUHJUeWtAF37YRF7eNvh02w+4E8Tz0IALFfStXb5g/FkgKF22reJUxZsiOFtwNadAksxDWNvwqc9cuJV16XVJyxxr2LS0t+INAlqvwK/FHtOFBQl3VIdD8PFGUoimCCTJf/WIYvArHeIzpahXDBx/9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FNSD6j1Y1zNZdgg0nsIJm1a+SdjaGCR2mEvsZMs+3c0=;
 b=CAT/YjVucJr9lIxMyQEl27XKfIxKmr7qm5aCKjz/Mt2MCJA3DVlu6h3cq3zF7HpYjoEbovtEInIlfz6/m2+kzLQJfAma77YPbTPkew2oW7rEqE+/7VXlYUsGuQgxoNLNbgfKd3EOt7Lym+o909REvyyi4MuRzv24zR6y+31M026bs4QUicXBx6kzATS8rDgBzVRWVupMOsKR9hx7TtaLV9ODbGUqMjn1ktdMwdGkB76qkeNs2FAPM9ua6ZwRDxOTGFJHTX/3hC04CN04m5UXDgq7nhNFnvn2ZwKANO/nX1mFJ0bzgSsKI/GmPm5O91bDuWQFWpdrsjfqeUmFRB5OVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FNSD6j1Y1zNZdgg0nsIJm1a+SdjaGCR2mEvsZMs+3c0=;
 b=vGB0t8DRQbrG3/OOwsMbigyqDWHDfOEu02mtzgYtQggPF8qOJILKLlUXwRAtdb6Mg9U4iG5u8VuD6m12jilmSSULX926sdODLlQgYf7q14JLaMiqrHILTVmT2lIwr62n4pHbBDHaZUp8O++k6d/6RBzAlTZU1DVt/B4aMCJ1zVM=
Received: from IA1PR10MB8212.namprd10.prod.outlook.com (2603:10b6:208:463::20)
 by CH5PR10MB997695.namprd10.prod.outlook.com (2603:10b6:610:2ee::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.24; Mon, 16 Mar
 2026 21:14:20 +0000
Received: from IA1PR10MB8212.namprd10.prod.outlook.com
 ([fe80::ee8a:bd21:f1cb:c79a]) by IA1PR10MB8212.namprd10.prod.outlook.com
 ([fe80::ee8a:bd21:f1cb:c79a%6]) with mapi id 15.20.9700.013; Mon, 16 Mar 2026
 21:14:20 +0000
Message-ID: <f6b3746c-4357-4a00-b743-79b1cb0c2d4c@oracle.com>
Date: Mon, 16 Mar 2026 16:14:19 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] jfs: Extend the done of the window period
To: Edward Adam Davis <eadavis@qq.com>,
        syzbot+ci1f1a4e9c887bc6ea@syzkaller.appspotmail.com
Cc: axboe@kernel.dk, jfs-discussion@lists.sourceforge.net,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzbot@lists.linux.dev, syzbot@syzkaller.appspotmail.com,
        syzkaller-bugs@googlegroups.com
References: <69415e37.050a0220.1ff09b.001d.GAE@google.com>
 <tencent_48DDBA00BB1033889E551BDE4B721B042508@qq.com>
Content-Language: en-US
From: Dave Kleikamp <dave.kleikamp@oracle.com>
In-Reply-To: <tencent_48DDBA00BB1033889E551BDE4B721B042508@qq.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH2PR10CA0025.namprd10.prod.outlook.com
 (2603:10b6:610:4c::35) To IA1PR10MB8212.namprd10.prod.outlook.com
 (2603:10b6:208:463::20)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA1PR10MB8212:EE_|CH5PR10MB997695:EE_
X-MS-Office365-Filtering-Correlation-Id: 136da9a4-5863-467c-d0f0-08de83a0fda2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|366016|18002099003|56012099003|22082099003|7053199007;
X-Microsoft-Antispam-Message-Info:
	5JgUHzO7RbbknMXV+j48sPCoFOgCwkSOC2PjHQPfkRG9KL6euzyeWrqFMhpqlUZBJS65mR1BFW+IDbSFN1d1E7VlXX/hFZryt6AX6iij4vrnmYcQ5tA6yIPdE3FSMYhFJHf02OwBZB7NG/ohmdemWD4yLEfyM22Z9o/K7HITNcriRL5R//bo4uePXHMAkfdOTYubMxjIZGPqW50XrnWRJWWD4UYY5ZBWKkrnjLwjzQM26IwELjM54ECfbnxXRCmqSsd5TfAdcfe2f/g2U7AbDfbkD6+QVgLt0OnGbOVolCVd9j4jrISLXDt+D42m0cAX4O78n2q9kXO0qwrD8vSjjm5uXy9Lp5Koi+QWeaUoPXfVDNFLzajFrNTTrBOy+lkKjXTcRN4Ly0WuOEihNjxYgM5DrbzqDAkVA5PJNXdmnkwSt6A6vXdFfyg6bCG/7qduVYZ5bArNqtuynNi2+W2ECZpThQG4Eq9M3Waq5mi06qudEOcolcbMaykisXHnls5NzsO+vF6QzpDuwtEpZESG9iJjitkdv74xxvUJoXOpJR3fc/zOFAu0kotS9/FUpu1Zw8+ai1ogX/LVV8V8qb9MebKFNOoL+shJkrM6WYrEXaw1tvxIzLJRDEdoGVflBeCCAsOHNVwuQuWWJHYJz0huIe5WTQZSKHJqnQqbiNKyNz2X4gGTQpBtkt8YqdrwMr1h
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR10MB8212.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(18002099003)(56012099003)(22082099003)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NWJ1QmtENng2aHFFb3psY01QRTZ2NURhc3dGMFBJTTRNMTRmQnNNUVEvYVJt?=
 =?utf-8?B?a1ByQSsxZFN3RERJbHZxVjJBa3lBeDhSOVErNGtYVDlXbEVOMlYzYS9iUmZs?=
 =?utf-8?B?SHFtQS9ZcHJVNDZKYjFGTXNnYmpSYjJDcVNiN3d5QndlT1BtSWlJMVVrbEpi?=
 =?utf-8?B?UVN0YVF5Ukd4anp2OSsraXpOL1l3bldvcjJiREE4MlpFZ0pKbjZiREgvN0ZF?=
 =?utf-8?B?TmNmZ3hjSFdBNE81Q0ZCVmNBd0dFakdTb3ZVTDdtSXpGbEorR24wam5YNzVx?=
 =?utf-8?B?cVlpUlRtaklHYlJnTmlDUW0xUzYxc0lVNG16V1IrMkpEaEFtV2pCQ2hMTVZW?=
 =?utf-8?B?SklFRXJLQnpLMmJSN0o5MjVxM1BvMzAxUnBMNG9QenZxbXVVVDBRNVVHOTc5?=
 =?utf-8?B?cHM3Q1ZyalZSc2pNSnppQzU4R01vSzR3c1YyMVgzV0JJcUlyblZTbVE3aUVV?=
 =?utf-8?B?NDBOMVVXUjdIOVpLU0ttTEFxVjF6S2F1VVd6RHl1bUJWbCszRU9zUUNYTytG?=
 =?utf-8?B?NlBYNk9nRDdHeHhoMHgxSklXUjMrQndFWDJuNFpnRmdxeGxFUUZtZUcydHEv?=
 =?utf-8?B?dUFkY3Z6RTZRN05oeTJ2YkxGSHRWWTEwZGhKZ1dSWEpCcXdzYjJyOHlDcmRK?=
 =?utf-8?B?T3Bwb0k2aUJFekJzbGRCbkZQMFYvQmNsYkR6VUVsN3J1ZE1hcGxycS9HZUNZ?=
 =?utf-8?B?Y1hxS2VMb09Fb3VPUE96ZVowZlJvK3MxTnFGYzlHTnBJZVRxRDJ0ZmJvbFFn?=
 =?utf-8?B?NkEwNCtYK25vTE80T0JHWFpGSmxxQ0NETVppeHRENTFUM3lkQXhIclorVENq?=
 =?utf-8?B?WXhpT2JDc0kyZXpMbWI0aXV5VTloVVB6VVRXVXUyOExZb2tlSXVhVElobkd0?=
 =?utf-8?B?M2FTREVpWG9HNE41QlkvVG44TUgzSDVPckE5aG1MNisxcE9pTnBDT1J0UlBw?=
 =?utf-8?B?WE00UkFOa2dBMVhXajVyWjU4a3JnUnpuaC90UjdkZ053ZkFRaEdMSS9jWTY0?=
 =?utf-8?B?ZkFuRGcrMFovdDRRazJzRkFkT2VQTzBRZ1pUOUgxbnV6N2tuYU5oeFRCOVJQ?=
 =?utf-8?B?NTA3OFpsdVhNdHpZQWtUbm5COW5COEpyREZRbGhidkxUSnBoUlJpdjJZcU8x?=
 =?utf-8?B?L1lMK3pqbSs1K1lGRmNEd2o1bWZSdTRZZlR5cjNZTklNRFlzSTdMdWp2cVRm?=
 =?utf-8?B?eDZUYzA5K0M0NzlxMHBIMWI5T3pERjlJQ1VPNFVvd3drVXBrbk9DTkRYWEpZ?=
 =?utf-8?B?eXVZNmhndEhnTmF3Y3VPUjdRSW8rbzdxTDZOeE8rNU1IR2pWWUlmZ2NCeHNY?=
 =?utf-8?B?aFl1MjQ4c1Q1VTNZQitpM1ZZUm1PSll1NXNlLy9TQ1pqTjd5MjdmZEViNWJG?=
 =?utf-8?B?MkowZlVXNzh4SWNIWXY1YXZ3dG94alhHdk1FMkQ5WURZNTZwVnF3THRKdVUw?=
 =?utf-8?B?MU5hZ2Y1cTh0Rk9pYXVTRnBkVTZ2MnRkRHZHdkdTd3B1eVVZN0lvdTVWaG10?=
 =?utf-8?B?K0RTcDRUeW9kNDgySXI5bFA4MENrUjhtaXVqNWJKRWd3bWxVd0tDbzgrcFBx?=
 =?utf-8?B?aC8zdDJ4RXI3TlV5d2JnSU5LRTNSdTBRR0JENjU5ZFJZMmlUZVArSk9QQlpV?=
 =?utf-8?B?RWp4MmVSejY1ejE5WEZkYW1LOUpTNU9rTUt0bWkwT3BYRDZiZ1lwYUN2ZUxa?=
 =?utf-8?B?RnI0eituNnRyZk11RlBkaXZEUEpDNnFtSDRwK0NiM2c5TkpjbjUwN3hkS1d6?=
 =?utf-8?B?U0RTUjZ1TnJmK0V2SW02c0tHKzRBMlBTUmNzTmljSTVybDVjRlB1VklHa04r?=
 =?utf-8?B?RzhqL2xtdFdhSU1UVEl6UkpVRDFTVXhjRi90MjhnZU9WU1NjV0JFV1F3ZHNK?=
 =?utf-8?B?dDNrUXJrckpsT09vM0JMbjhvZ29YRUFZd2NRODUvbFo4WVg1eVJIU1Z4Zk10?=
 =?utf-8?B?dmM2bFFVbExWT2tpbGtJQlRHZjM1eWdJNHhQbzlwSDM0UUZ3TlJGbjVuZDRw?=
 =?utf-8?B?ZzFKWHY3WDJqT3k5cmVSRSsvVW13SWtMVVF6Qng4eVFHRFdGcENLSGRmay9Q?=
 =?utf-8?B?Tk9mUEs0eFVnSE0vejlDR0xBbktjV2hKaS9uTTduQmtTeUZKbEpXbE4yaHZr?=
 =?utf-8?B?MlJXTm13VHp1VjZ6Uk5iaFdvd2Y1SHFjMEx3RFVNQkRubWI5bjlxaDRFMHcw?=
 =?utf-8?B?VVpHaE1WYWgyUFFEenk0RXhDUWdQN21LMks1N3ZrdHU1Y3JuQkdFcjVmRTBU?=
 =?utf-8?B?b1ViUmQxWmhsK3RQMWkzWHA2TElkQUE1dTNrWk0vZXBiZGt1T3MyWFcraXdU?=
 =?utf-8?B?c1dyR2NFU2RNWTNHbmhkcEM5MUExSkl5Uzk0Qkt6eGxPdW5HZnVxMG94dGhG?=
 =?utf-8?Q?OrFe62OCm1paW1+M=3D?=
X-Exchange-RoutingPolicyChecked:
	byxzA4pzENW5DoK7RErD72X0Fawqlislo2LBmAjS3+PVooXD8CLj5xcYlaYc322kepA2SA396+V/gcR+Ck8Abc69tapf+0quqiNZBnk+TgyWgYIbCc7SWSnvvWnuLuK0CS0PDyHWHt/sg7t1ctcIV+5eRde7jrA/hnFVKR009uB6DZlyvaRBhTl8gA2bpORFd28o7WiDAiWuhZJUCi4Cu3I/bXidJCDUU7bUnEmnnPMUzamYMh8TUp+7d4Zg2UdB0nEQcoaxt2VV2Ib1HucF1BZZUQKGVrHcfpELldXVkNvzwONvXzg9kAjgadTu6F46XjPCEfFXhhhzMvgVHTryNA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Sf5ovYGoYND2F/pKCsfxqOzcKlpD4h7Ei9eJu7jUkhPxsfea5gL8JmLgBxpmeu1a42+oyqfZgU6hwsI3hClcg54N3qmI/Uv5NSji8bqPljRN4QBiiq6JXtjdirfBTEZkV5fbZiCirJHamTS/mjv7kX6aXTHqwvyuDMxReE7XQ09H8mHZagRXM5DDGr1UdbdduH6qxrqqYuZebP3okLN0JrzUY3lO2JbIXXpf9kloS6MJxH+2D2KHOiHKN3BA8oM+KUtpVqJ5d8qsofYKLEOnIeupmWqr6+7H0Xsq/8KbVd29O53bvMXLfQdQGlQcJ/0clHOzBAFb9VAh7PAQBlfIHG70toPweb6DbGA/TTPen6IicK5uMp6KZR2JXmdfVfFfMFYErq1O3eQNx4r/qgw4Y/aZIHQn8CDM1IEhzrmXj6RTJDbniiFg7Plp3J8csCO6LZJoT+9U8TaB9y2obJ4D1qEU0Xsfg792wpFdqL2UV0eeoES1Lx97axjIhamCEjgskWI9I+aT4WMkWL99AsZFbDfPWo4n5hNErGhOj1Pp8THyLXB+dObumQYa2K+KfZQUlYL79y6tr0+CswmDMeBR/+MdWv5PDmLl4X9F6zDlYEY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 136da9a4-5863-467c-d0f0-08de83a0fda2
X-MS-Exchange-CrossTenant-AuthSource: IA1PR10MB8212.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Mar 2026 21:14:20.7543
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VExmETpezTv5X4K1aYa2l1LLLRI3gaVEvfQp0+C9G8i+i06WG7yf2frBdXm3pwp2dhV/F2fZIdgwyxXRpXP6kBPw3LPV9PCuZsQDw2epxZ8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH5PR10MB997695
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-16_05,2026-03-16_06,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 spamscore=0
 adultscore=0 malwarescore=0 mlxlogscore=999 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2603050001
 definitions=main-2603160173
X-Authority-Analysis: v=2.4 cv=X5Vf6WTe c=1 sm=1 tr=0 ts=69b872af b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Yq5XynenixoA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=3I1J8UUJPc9JN9BFgKH3:22 a=edf1wS77AAAA:8
 a=hSkVLCK3AAAA:8 a=dZbOZ2KzAAAA:8 a=_kx3Eaa6GAHt6zYSFLwA:9
 a=+jEqtf1s3R9VXZ0wqowq2kgwd+I=:19 a=QEXdDO2ut3YA:10 a=DcSpbTIhAlouE1Uv7lRv:22
 a=cQPPKAXgyycSBL8etih5:22 cc=ntf awl=host:12271
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzE2MDE3MyBTYWx0ZWRfX8zBUKjWSWplq
 G2HA/7hUW5z1om/6C4GmHXaz1oIzN+WkQi0HuZdXl2cxa5iyG3PeH452Da+QBbmK1DNlsDR2BBw
 x8MkspEjfgtcgzKDnPDXYUevSSbe8p4vqdQliuwRZ/m/ktsOFPo/IRq4y/gMvBv2DL3JM55mNtI
 8cDwqNF8GMvIbw29+8QWHNNFEIpMPp6/iGwy814PblGL7Bhystv1SrEM+EbNHuVzKLS6Fjcae7c
 1+SUDGa0LZbJGNx/gv6GgqZPfKw4DrK/qUTNdpxs3eEBM4FnEgzRE5PCNsOrWsJX5uqPKE2q2yL
 e/ugQ9mVYT6rXaDo8nBxKEJunT0Eof8rF+PdCPAxILluun0LkaUzB0kTcXKQT9kBnWnNZDsCioM
 UF/O54L0z249O6qchXxN4vi+SD+IngK7S9PhdHA224DVMW21PjxzxTpumxBtcFzbfRIRHDJ/rP2
 3ByMPZJzRlbYdFcAOGEzbsyD3v0RTt8HJVbCSyDQ=
X-Proofpoint-GUID: gW2AlYxvwoawHZ3GR1sGZpvNsGe1MJ6I
X-Proofpoint-ORIG-GUID: gW2AlYxvwoawHZ3GR1sGZpvNsGe1MJ6I

Finally tested and applied to jfs-next

Thank you and thank you for your patience,

Shaggy

On 12/16/25 7:57AM, Edward Adam Davis wrote:
> In lbmRead(), the I/O event waited for by wait_event() finishes before
> it goes to sleep, and the lbmIODone() prematurely sets the flag to
> lbmDONE, thus ending the wait. This causes wait_event() to return before
> lbmREAD is cleared (because lbmDONE was set first), the premature return
> of wait_event() leads to the release of lbuf before lbmIODone() returns,
> thus triggering the use-after-free vulnerability reported in [1].
> 
> Moving the operation of setting the lbmDONE flag to after clearing lbmREAD
> in lbmIODone() avoids the use-after-free vulnerability reported in [1].
> 
> [1]
> BUG: KASAN: slab-use-after-free in rt_spin_lock+0x88/0x3e0 kernel/locking/spinlock_rt.c:56
> Call Trace:
>   blk_update_request+0x57e/0xe60 block/blk-mq.c:1007
>   blk_mq_end_request+0x3e/0x70 block/blk-mq.c:1169
>   blk_complete_reqs block/blk-mq.c:1244 [inline]
>   blk_done_softirq+0x10a/0x160 block/blk-mq.c:1249
> 
> Allocated by task 6101:
>   lbmLogInit fs/jfs/jfs_logmgr.c:1821 [inline]
>   lmLogInit+0x3d0/0x19e0 fs/jfs/jfs_logmgr.c:1269
>   open_inline_log fs/jfs/jfs_logmgr.c:1175 [inline]
>   lmLogOpen+0x4e1/0xfa0 fs/jfs/jfs_logmgr.c:1069
>   jfs_mount_rw+0xe9/0x670 fs/jfs/jfs_mount.c:257
>   jfs_fill_super+0x754/0xd80 fs/jfs/super.c:532
> 
> Freed by task 6101:
>   kfree+0x1bd/0x900 mm/slub.c:6876
>   lbmLogShutdown fs/jfs/jfs_logmgr.c:1864 [inline]
>   lmLogInit+0x1137/0x19e0 fs/jfs/jfs_logmgr.c:1415
>   open_inline_log fs/jfs/jfs_logmgr.c:1175 [inline]
>   lmLogOpen+0x4e1/0xfa0 fs/jfs/jfs_logmgr.c:1069
>   jfs_mount_rw+0xe9/0x670 fs/jfs/jfs_mount.c:257
>   jfs_fill_super+0x754/0xd80 fs/jfs/super.c:532
> 
> Reported-by: syzbot+1d38eedcb25a3b5686a7@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=1d38eedcb25a3b5686a7
> Signed-off-by: Edward Adam Davis <eadavis@qq.com>
> ---
> v1 -> v2: fix potential deadlock
> 
>   fs/jfs/jfs_logmgr.c | 18 +++++++-----------
>   1 file changed, 7 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/jfs/jfs_logmgr.c b/fs/jfs/jfs_logmgr.c
> index b343c5ea1159..0db4bc9f2d6c 100644
> --- a/fs/jfs/jfs_logmgr.c
> +++ b/fs/jfs/jfs_logmgr.c
> @@ -2180,8 +2180,6 @@ static void lbmIODone(struct bio *bio)
>   
>   	LCACHE_LOCK(flags);		/* disable+lock */
>   
> -	bp->l_flag |= lbmDONE;
> -
>   	if (bio->bi_status) {
>   		bp->l_flag |= lbmERROR;
>   
> @@ -2196,12 +2194,10 @@ static void lbmIODone(struct bio *bio)
>   	if (bp->l_flag & lbmREAD) {
>   		bp->l_flag &= ~lbmREAD;
>   
> -		LCACHE_UNLOCK(flags);	/* unlock+enable */
> -
>   		/* wakeup I/O initiator */
>   		LCACHE_WAKEUP(&bp->l_ioevent);
>   
> -		return;
> +		goto out;
>   	}
>   
>   	/*
> @@ -2225,8 +2221,7 @@ static void lbmIODone(struct bio *bio)
>   
>   	if (bp->l_flag & lbmDIRECT) {
>   		LCACHE_WAKEUP(&bp->l_ioevent);
> -		LCACHE_UNLOCK(flags);
> -		return;
> +		goto out;
>   	}
>   
>   	tail = log->wqueue;
> @@ -2278,8 +2273,6 @@ static void lbmIODone(struct bio *bio)
>   	 * leave buffer for i/o initiator to dispose
>   	 */
>   	if (bp->l_flag & lbmSYNC) {
> -		LCACHE_UNLOCK(flags);	/* unlock+enable */
> -
>   		/* wakeup I/O initiator */
>   		LCACHE_WAKEUP(&bp->l_ioevent);
>   	}
> @@ -2290,6 +2283,7 @@ static void lbmIODone(struct bio *bio)
>   	else if (bp->l_flag & lbmGC) {
>   		LCACHE_UNLOCK(flags);
>   		lmPostGC(bp);
> +		LCACHE_LOCK(flags);		/* disable+lock */
>   	}
>   
>   	/*
> @@ -2302,9 +2296,11 @@ static void lbmIODone(struct bio *bio)
>   		assert(bp->l_flag & lbmRELEASE);
>   		assert(bp->l_flag & lbmFREE);
>   		lbmfree(bp);
> -
> -		LCACHE_UNLOCK(flags);	/* unlock+enable */
>   	}
> +
> +out:
> +	bp->l_flag |= lbmDONE;
> +	LCACHE_UNLOCK(flags);
>   }
>   
>   int jfsIOWait(void *arg)

