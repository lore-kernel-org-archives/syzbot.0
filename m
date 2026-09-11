Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3274549BD68
	for <syzbot@lists.linux.dev>; Fri, 11 Sep 2026 16:04:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=100.103.45.18
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789142695; cv=fail; b=oRBUEFMtX1wxGjqy7aJARaiMA47p4HVYENgpkx+3/KmP3NSHIwnOzfeIiEc/ysXpdvhVpjoPMwt23egt3SHREmwed2rAKYNz2Om9hIzK2hgGe0h/k6/fmjoDh3ReH1s7yVjKn6ALfrdt/iPIqhaFkFbO1Ogn34KoREOqCH/jw+E=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789142695; c=relaxed/simple;
	bh=+tEG7rObBeWGI5I92ZZxFmjEEXvPX0+vRfxjGgNtYVw=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=RqP/WRi7F426qMWt8HuzRr+LaAc11Nn4GIzl0Uhvy0j55/mgnSkfoK6ICLdPW9Gg/JhMZBZnxlSOO147UTtPi57R9P5wfPxsoWxu+idszmi36ZA75VuQczk7DijKVK/bHs5381ktp1laITLGE1MZ1i/FPKN9vsr9cdLhu/PeE9U=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=12NxZ5hv; arc=fail smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="12NxZ5hv"
Received: by smtp.kernel.org (Postfix)
	id 028981F00898; Fri, 11 Sep 2026 16:04:54 +0000 (UTC)
Authentication-Results: smtp.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.43.58
ARC-Seal: i=2; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=pass;
	t=1789142693;
	b=RUitoh2cna210mxXErBlg+jANj9ZXJb/t5NcvmXAHfInY/KAmsxVs/qhPA1e3l/ELXks
	 izX9yljiZo8kGkKkZkDpj4IGFPBCLeAnGvdbRJ6ag4sgc23yWUW5Ss7zE2pfKjVEkDmpO
	 cztySdyWBKSjg0lvGN75f9U++T6fzImVhKG2ANOaDIIuQYy4avsHlrx+TjiYgyVY9QCL7
	 M4DJYpLwCaiLiTQoQ4Igq/sBsK3RHdKxFwRAC/I0lDOtlOnV0Vt4xS4Hn5kf0UpTuLItf
	 d9ObJADDroGGPYl7UomziP5R4Q2mCealcHEKLuNXRzVerRaWGUmohe+LczIqtlTLe/w==
ARC-Message-Signature: i=2; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1789142693;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Message-ID:Date:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-ClientProxiedBy:MIME-Version:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=3Rd2Bke16N5dThj3QtiRrWX+Jfm80NExMjdKoubMoAA=;
	b=0MB/8xUV1xsDxn0/vFXlQ/dFg/QObCwfDODv/Xh5iKlc/3D8Zzl5F/dQtxtBK7qYfyzD
	 b4uaQJUFUKxWSCAHZ5afZEqxzpD3Lx3j5mO4ek8aLS4+14y5A+glysFLVY5LqM0pUq2Om
	 M0fTHGbI+3ls4FTq9YmndWiZMQN0UHqKd2tpl5VaUV1t98/bGtYwrVG5nVLgefzLX96HD
	 qsKCN1rSMdYkZtLoWRCpDbC0qG6jCGuMOeVFHORnA/RH1TkC6iBU5buuZA765+kAyNdWO
	 WmgLkIApkaq4Ocdi+379ymzVww+I0RwbkA+71hFbPPmhbs9GkNdFjDwWFJL5WnE/8nQ==
ARC-Authentication-Results: i=2; smtp.kernel.org; dkim=pass header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=12NxZ5hv;
	dmarc=fail header.from=amd.com;
	spf=fail smtp.mailfrom=amd.com;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.43.58
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012058.outbound.protection.outlook.com [52.101.43.58])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 3AD431F000FF;
	Fri, 11 Sep 2026 16:04:52 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=12NxZ5hv
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.kernel.org 3AD431F000FF
Authentication-Results: smtp.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wj630LoCoVTcridZdRayE+V9oBakDxX0URMKfeOksgg5AMd+HWxTxtv0+BzjxOUufnEfZm/Cto/s0WC/0kRzfXuway90dFtO4IwCEvTqq5pqCYifIZfsSb8TDWK0/+hOkIEnTtp7GD4tjh2rD6msbN6sCZBYACBDAqJ7PTzsu1EpELgAsAvg7Q8RuCTWw1BCKkA0Ss0eH2wlphhVVnh6QDt6pAthPdsY3maklZbtHC2TzJTIrxCo+30DlVquNQ66b5iviaeAqeklW50bj0keYo5XuuAMS7N1oPA1nJHmG40TRmykasiLyw5JoEqY97zaFMM6Hc8G44W2x4TB+NSRNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3Rd2Bke16N5dThj3QtiRrWX+Jfm80NExMjdKoubMoAA=;
 b=LPneIk3hNkvC652pTSOeqMt3wVq3h1Sgs/ehzR+TvMJFqQ762LFFFgCRF8nu257vlva0qaaKtnHoyhQpjhVLlWz0CEhIoHA3VTfKzWqfkgJ3KCJ1WrELFJFg4qmCMYvC8kGK/UsCyEQy4v8v9uzuuG1jUu2CnjO4vKf6ha2W5w8UE9MrvzkBozJaO2BWVPalXzWIYwYU0cCrBLfkQaqkw74uqVJRn2IJEc1VzOsCDkyxQew19Ej6YB2AS37cpcVCp2wXiyGEZBK8F8YajzPLHjLHhczxzqgNhR9qftH6+iXMhu/hPx2/dZXYz1+hxmqqixmxihuDf+5syXkAnldItg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3Rd2Bke16N5dThj3QtiRrWX+Jfm80NExMjdKoubMoAA=;
 b=12NxZ5hvzFU8PSNZ2pyE3/PTUpQCIKaRc8SSkmMqMGOxBCbAa2vglbJCarHKVOQ+Ei0BXkkrSVuGWbkXjBRV/9wxd6pScWp9xhPlxqqg3w6VAFMIkgIaq6ZJgSbL8PQ57dk3W3M5xrPzp/JBYHmJT1FfUs+dpLo9XHRjTdPIlHU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6559.namprd12.prod.outlook.com (2603:10b6:8:d1::6) by
 SAWPR12MB999293.namprd12.prod.outlook.com (2603:10b6:806:560::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.10; Fri, 11 Sep
 2026 16:03:29 +0000
Received: from DS0PR12MB6559.namprd12.prod.outlook.com
 ([fe80::3f99:f532:cf6b:ea46]) by DS0PR12MB6559.namprd12.prod.outlook.com
 ([fe80::3f99:f532:cf6b:ea46%4]) with mapi id 15.21.0406.007; Fri, 11 Sep 2026
 16:03:28 +0000
Message-ID: <7f8690bc-17c7-45e7-bacd-a341b2ef0a4b@amd.com>
Date: Fri, 11 Sep 2026 21:33:21 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] HID: amd_sfh: Validate PCI BAR size before mapping
To: syzbot <syzbot@kernel.org>, syzkaller-bugs@googlegroups.com,
 Slawomir Stepien <sst@poczta.fm>,
 Basavaraj Natikar <basavaraj.natikar@amd.com>,
 Benjamin Tissoires <bentiss@kernel.org>, Jiri Kosina <jikos@kernel.org>,
 linux-input@vger.kernel.org, Sandeep Singh <sandeep.singh@amd.com>
Cc: linux-kernel@vger.kernel.org, syzbot@lists.linux.dev
References: <94704655-d654-4500-8122-b80bea9bd908@mail.kernel.org>
Content-Language: en-US
From: Basavaraj Natikar <bnatikar@amd.com>
In-Reply-To: <94704655-d654-4500-8122-b80bea9bd908@mail.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PEPF000001A8.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c04::e) To DS0PR12MB6559.namprd12.prod.outlook.com
 (2603:10b6:8:d1::6)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6559:EE_|SAWPR12MB999293:EE_
X-MS-Office365-Filtering-Correlation-Id: bf890438-df40-4c09-54aa-08df101e37d1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|376014|1800799024|3023799007|10067099003|56012099006|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	YUc5CHQQLtJR4vP2rdaPiyojGfafNE8HCSKqV4i5gGJwLhmYUqAE6jVL1604VlhX2GxH6l5wEWA1LI7CwxlH6RPwEteORN3JuUkGLbMo45huJXVDvHojAtxM6d/1yBD3RXpl/SrxZNu6bMGgsqc2EV5jRPI9VJsVv5yz7fYQKhcxMwpGH8A7/EwQruSwga6//WUFewKyr6Z+2Wl6YzN6DhUYJH6GDDI+y3gnTa+U1qQNyC56TZsqlk4mfde0l4NhyS3G/4SUH8B33vF8AjLEXm9sO2DkElJpyVCvrnld9TObZczz6Nd4d4BFTuV1W/hGj9Ghc1oF5LnQGbEVC6EIKG3euhRwVyGGRitFqrZV7aSoGM7ZNUVGhFnKGNzTyThbSdFMeJqK8CV4VrnB1XqkdtiEohTnmOSTL2uTFgr113d++fNOEFo5sEBHwF7tJWkd5SsWhOFp4WQaQtfSZK2KEmWoGoYw2GMtMkEPNhAMl4L4HBF+fAuQh27SD4rudPJn043xQy0zSZt8FhaqMKhD8u5o8tRGdXXQZh7XIxLI0jyE7bGDKllOg7PdfT1X3ZxytNTiW6JBWbkgOEUGsz8+aAVVi3IdNkQYTt9Y/OEEQCE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6559.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(376014)(1800799024)(3023799007)(10067099003)(56012099006)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TTk3emRRSnNManJ4NGE1YkRYcnVLYlM4UUd0eWIxaXFSc2J2L1FHdGhSbDZ3?=
 =?utf-8?B?TmZNemdxc1ptVGhyNUpyQkJ6eStkSG02d1c5enNwVGQyM1RFWnFCc1J1TVF0?=
 =?utf-8?B?ZEtQQ1J5NVlSbEJFczQ1UlU2c1hsc3VJTVY2K3YzTFE4ZnpNNjlkV1pRZzht?=
 =?utf-8?B?Ky93Q0dqZm5VK2xoejhKNVkwdGlCL0lpenlWV3R6OUVyWmRuNzJTMTdqQkp1?=
 =?utf-8?B?M294Tk56YmlWR2JaT1BzQmVtazlOUVBJTm14UDVOeHRoL3hJV1F2aFIzb2RW?=
 =?utf-8?B?d0E2TXNLSGRsSnhRVXNzYlIreEh3Z0lFcTk4VzJNYktiZGowOFN2aWgxdkcz?=
 =?utf-8?B?RzBHMm9QSlN0c2czNWpOVnVOMXI0RzVLTm1KS2FKVFNXMENhcXZPNHVoeHc3?=
 =?utf-8?B?dWNyd25tQ044ZGFkQTFMeDNLR3hqM1ZaT2wrOHFZcHpvMVR6cVFJOTFRWmFW?=
 =?utf-8?B?NWg5NjRaM2tQS2RtSkhzK1RiZkN2MG1WUnUwSGsrVStzWkVVb2k1UUI3RUpB?=
 =?utf-8?B?L3lab2VJcWsrSUNaMkJyUVl2VjNWUGplcWJhemxSRzZ1dzhUTEwvMWJBeHlW?=
 =?utf-8?B?VHRqbWZFS0NLbU9BNXozK3pwemxSTzMwM3N0NzVHOVFIYUo0V3U0aG1VYzY0?=
 =?utf-8?B?U3p1ZXg4d1ExV283cjIvcU1qWUtmbnVJZDNyS3hjUk9DUXNia3U1cHpCWW9j?=
 =?utf-8?B?L2pHRktRN1NtVVJDZFpVWjN2REJ3aEVXaFppdVVCN3h2NUVveDZ1SUNxb0NS?=
 =?utf-8?B?cExIN3NNTFYxY1lNb3duUytKZTRmdlZ2Zk1qRi9wQ1ErUzNTQTVTQnpuV0FH?=
 =?utf-8?B?VmY4Y0cxODZyVlZBODdwMGVoT1ZXdFpWUGtadW8reXZlbHZkMVlYRGhvU0Vt?=
 =?utf-8?B?anRtT1NXT05IWm1DSjNRbDVFUm8zY0diWnVCM0g0bUlHSFhEMWh2ZFFvQTNT?=
 =?utf-8?B?czllR0NDUE1UajRVSjFrWk4xbjRyK3podmk2ZWxVUTRmZU9GM21FTTk1TUtm?=
 =?utf-8?B?UG9PdHhBNHZ4SzNLNm1tdE5zWk0vdDRwNDBHdDFMT1JCcTJUdFZHdlNYRVRN?=
 =?utf-8?B?bk1xVlpIa1dIRU1XVGtsa2N1ek9qVWZuVWk3Y3c4R0wvUklSZkFYSUhoRVVD?=
 =?utf-8?B?eHBEaGV6NEhJcFR2R0NrRDcySVRnNUNyOHQybnRwL0JxQ0lOTkpYMXpnbWtN?=
 =?utf-8?B?ZStXM1k2Z1JsVDlTT1l4dEFweU85TVNwSUF2cEpUa1BURnBzd1BpOWRSTzRh?=
 =?utf-8?B?TFFqQmxJNTA3bUs0Q0N1QXF1alpTMHpyMWdkMU1Gd254ZDRja3pwQkt2NHZX?=
 =?utf-8?B?UVRxR243Y2lleU5YSnNWaEZrWWxvMEZHc2V5T0pFQmVldnY5dFRqUllRRkJM?=
 =?utf-8?B?VmpTM1g0V3doMkdKS29SdzJqTjVXWEkwcXFtckNjR0ZtVVVTQXVLVHBBN3hF?=
 =?utf-8?B?YnhhdllkTUtSaE9lc2VxcWEwd1ZLZ3Nxelo1UHh4b1V0a3ZCcjBkZ1FQZTAy?=
 =?utf-8?B?Q1luWWZwdnBBZThHT0xpWkQxZnRpOUp3N2oyVkdjZmFkYll4WnA1WU9aTVkr?=
 =?utf-8?B?c2lvU3JZNjc5ZFNWTkg3VjhoaE9GM3J3MVlEeE4wWWFGc1pQbTRaUnI5UlJT?=
 =?utf-8?B?NnZtTm43S2VrSEJLSHFYeS9rYVVSRURicmswaHRVVkd4Um5DcVFYTHF1Y2xx?=
 =?utf-8?B?eUY4UEEvVU9pVW4vWjdhRjVFcktKZFAzQWxEZjJlQnBqdExBM052cnZiYmxE?=
 =?utf-8?B?OXRJWUU2bTJGK3FEcE9xdWtHZVZJV2gzUjEyN2RoeGkrY0pTWFF2NjRMeU5l?=
 =?utf-8?B?bGJyZzBET0JMWWRQRzNQckFtZ1BxeUVQQ2pCT3RhTkxQNzBiMWs3QzRjcnNX?=
 =?utf-8?B?azRmRlorT05UN2tmcE1uV2VXaDU1MjVpQ0dhOUpNejd6bk1oTEozSXkvd29D?=
 =?utf-8?B?UzFTVUdJaW5BYUtNWnZXQ0JGOW5xNzN6d0w2dWE5WHAva0RaQlFjNXBHeHEz?=
 =?utf-8?B?Nm9tdzhDWjVJRFcwR0RkL1ZzaEdBN2hlMzd2ZHdjS2ZVQlYxaHN0VlQ3N0JB?=
 =?utf-8?B?UGVJMytKcmcxck1uSEMyYnJkNitrbXA4S0c5MGROZGtzM0FRVWx4TlR0Uklu?=
 =?utf-8?B?VmRmWWRDMEJHU0c0R1F0Wmg3cGF6bGIwejNrTUxvZzNXbU02cEtHTFNoR0hB?=
 =?utf-8?B?cUZkM3RSNTIyMkN3OWRhQWx2a0FLeTdMQnBFbFpramVHN2Q4cVhMOGdFYll1?=
 =?utf-8?B?ZWx0ZWR5dUk1OHNMUE8wMTJKR0h2ZzYxSjdncHpucEw1SWU3dG1CSHg2R0VB?=
 =?utf-8?B?RkNtQWVUd0wwVW1WdmtXSkc5R1lyVXJwaEdYMmZRaTFJWXIyU3BnUT09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bf890438-df40-4c09-54aa-08df101e37d1
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6559.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Sep 2026 16:03:28.3711
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QmHsmACGgLBLOJyKBettdFZ5xf2eF1scu00ojdzgcOt1+i8WKFBwyerZY6L9+TqMY4z6wjcpWhoQdajTTCm9Og==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SAWPR12MB999293


On 8/27/2026 12:06 PM, syzbot wrote:
> [You don't often get email from syzbot@kernel.org. Learn why this is important at https://aka.ms/LearnAboutSenderIdentification ]
>
> From: Slawomir Stepien <sst@poczta.fm>
>
> The amd_sfh driver maps PCI BAR 2 using pcim_iomap_regions() and
> subsequently accesses MMIO registers at offsets up to 0x10958 (e.g.,
> AMD_P2C_MSG3 at 0x1068C). However, the driver never validates that the BAR
> size is large enough to cover these accesses. If the driver is bound to a
> device with a smaller BAR 2, this leads to an out-of-bounds memory access
> and a page fault during the probe function.
>
> For example, a page fault can occur when reading from privdata->mmio +
> AMD_P2C_MSG3 in mp2_select_ops():
>
>    BUG: unable to handle page fault for address: ffffc9000390368c
>    PGD 100000067 P4D 100000067 PUD 1012c1067 PMD 105b64067 PTE 0
>    Oops: Oops: 0000 [#1] SMP KASAN NOPTI
>    RIP: 0010:readl arch/x86/include/asm/io.h:59 [inline]
>    RIP: 0010:mp2_select_ops drivers/hid/amd-sfh-hid/amd_sfh_pcie.c:282
>    [inline]
>    RIP: 0010:amd_mp2_pci_probe+0x337/0x5f0
>    drivers/hid/amd-sfh-hid/amd_sfh_pcie.c:487
>    Call Trace:
>     <TASK>
>     local_pci_probe drivers/pci/pci-driver.c:332 [inline]
>     pci_call_probe drivers/pci/pci-driver.c:394 [inline]
>     __pci_device_probe drivers/pci/pci-driver.c:455 [inline]
>     pci_device_probe+0x431/0xc90 drivers/pci/pci-driver.c:489
>
> Fix this by verifying that the length of BAR 2 is at least 128KB before
> attempting to map it. Since the maximum accessed offset is 0x10958, and PCI
> BAR sizes are powers of 2, any legitimate hardware will have a BAR size of
> at least 128KB.
>
> Fixes: 4f567b9f8141 ("SFH: PCIe driver to add support of AMD sensor fusion hub")
> Assisted-by: Gemini:gemini-3.7-flash Gemini:gemini-3.1-pro-preview syzbot
> Reported-by: syzbot+4eadd4dfe9e66522bae8@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=4eadd4dfe9e66522bae8
> Link: https://syzkaller.appspot.com/ai_job?id=3bc1c45c-548f-4ab5-8243-d2c8ec321d6c
> Signed-off-by: Slawomir Stepien <sst@poczta.fm>
>
> ---
> diff --git a/drivers/hid/amd-sfh-hid/amd_sfh_common.h b/drivers/hid/amd-sfh-hid/amd_sfh_common.h
> index 78f830c13..c0c324565 100644
> --- a/drivers/hid/amd-sfh-hid/amd_sfh_common.h
> +++ b/drivers/hid/amd-sfh-hid/amd_sfh_common.h
> @@ -17,6 +17,8 @@
>   #define PCI_DEVICE_ID_AMD_MP2          0x15E4
>   #define PCI_DEVICE_ID_AMD_MP2_1_1      0x164A
>
> +#define AMD_SFH_MIN_BAR_SIZE           (128 * 1024)

Please use SZ_128K instead of the open-coded (128 * 1024), A short comment noting the value
must cover the highest register offset (0x10958) would also help future readers.

With that:
Acked-by: Basavaraj Natikar <Basavaraj.Natikar@amd.com>

Thanks,
--
Basavaraj

> +
>   #define AMD_C2P_MSG(regno) (0x10500 + ((regno) * 4))
>   #define AMD_P2C_MSG(regno) (0x10680 + ((regno) * 4))
>
> diff --git a/drivers/hid/amd-sfh-hid/amd_sfh_pcie.c b/drivers/hid/amd-sfh-hid/amd_sfh_pcie.c
> index 4b81cebdc..039b6ac32 100644
> --- a/drivers/hid/amd-sfh-hid/amd_sfh_pcie.c
> +++ b/drivers/hid/amd-sfh-hid/amd_sfh_pcie.c
> @@ -451,6 +451,16 @@ static int amd_mp2_pci_probe(struct pci_dev *pdev, const struct pci_device_id *i
>          if (rc)
>                  return rc;
>
> +       if (!(pci_resource_flags(pdev, 2) & IORESOURCE_MEM)) {
> +               dev_err(&pdev->dev, "BAR 2 is not IORESOURCE_MEM\n");
> +               return -ENODEV;
> +       }
> +
> +       if (pci_resource_len(pdev, 2) < AMD_SFH_MIN_BAR_SIZE) {
> +               dev_err(&pdev->dev, "BAR 2 is too small\n");
> +               return -EINVAL;
> +       }
> +
>          rc = pcim_iomap_regions(pdev, BIT(2), DRIVER_NAME);
>          if (rc)
>                  return rc;
>
>
> base-commit: db2ddb87143519e20a95aa36c60b36107b736a58
> --
> See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
> The person who has signed off on the patch is responsible for
> addressing comments.
> syzbot engineers can be reached at syzkaller@googlegroups.com.

