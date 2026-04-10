Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 420483A75B6
	for <syzbot@lists.linux.dev>; Fri, 10 Apr 2026 21:54:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775858085; cv=fail; b=QHLPMRiwj2qRX3TMjRtBTKa3ARQRlqrs018lh6/xK99rxL5WYwbKvWZwLgR5/EKVMGwtP/KPEIScUJiFQMBgodiyaGQ1Rb0S6Q6y9jhjbPyerPTHsblsRSOI1N6WXBmwgxaErpElrLoQ5f4MLNbXmSXA7NxiRAF/o1OzJ+VtcIc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775858085; c=relaxed/simple;
	bh=peLHaDT9aniu1WRRXL2kEt2YObeq9wH7nLmEotZUXRQ=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=jElcyDsC6yTtXk11DAvJ3jFDzDo1f8NsfgA1YSUXHjpqks8FmhqumvlrXEx6ESH3+4rz6ICVJmpnjkM2f2U3+IRKevMfXUuN692ePspslAlsVGg0V2U758/+Up2TarXHTxNfOyLTZR5rq5fNhuGMbaXW/4yP+rTEkuGONdE0Er0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=U/pfTjoI; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=f09l93Hw; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="U/pfTjoI";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="f09l93Hw"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63AIW8QX1163272;
	Fri, 10 Apr 2026 21:54:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=0Gi9fNDlG0MoN/vkSE/osnWRNGVA+v7RKzhb13SX3ec=; b=
	U/pfTjoIdZQ5qxCug5pxScIvO/GXcfCOzUDwnwAqhfIxxpgy9l3gX3vmmYATBKTI
	nw7HPCUSJqxB+WG2YyW7JOCLSOZcU9psWVK0RD4YKcVJ/PMOSz3dXMJB8LX++xLt
	vf05Slb9nLtqZ4eKJrVh+yrtf2iRX+C9lmnoj7dHFeXGEev9703/rxk20OiWdr90
	kCe19LDdgMnFwrcZt3UbJ+MJHDqB/n2jX2zu29JdAa1prVehi8OUovQZHJ6bUilz
	98nPENFpBbNE0ylHxLEPkAlJT5onmhrISsibt2NBr/Qt0utLRZyC2LxFh3pbMtMe
	y+Z4dIt6SeXoG+10aEVTLg==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4dcmqejf6n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 10 Apr 2026 21:54:21 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 63AJOMkx004407;
	Fri, 10 Apr 2026 21:54:20 GMT
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013040.outbound.protection.outlook.com [40.93.201.40])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4deydpeagv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 10 Apr 2026 21:54:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ie311hbHLEXzZOFlj2Mkt7oNqFzw+8uEM1zwaYM9caOeVbvQtryfGSE1lgFGpVW8/2WtmGAyIUzSC0D6ovjYrAB9eJT0HUiZ0Vazrrg01v+lcY8Q2Z/ZuZDy5wcB9LYKyMI62DGzytHOTaSsUlMIzKiI9513OVt+PvXSU8RTTRJym/BbBaTs5G6R9kC4/wzEW9mDt8RQOy6OqOVOcQh6VguBP793BdkYCdTl46uhLXO+DaPtg/xGO4mKy8CsR/DHAYdztQsx2GLfK2CbqQKrFTDr7FalKs1deuC+FxQJ3zlTCAEXzzQCq2XhF0z4At/YI7yTYe/2o3unUIv6184oQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0Gi9fNDlG0MoN/vkSE/osnWRNGVA+v7RKzhb13SX3ec=;
 b=gnN7jQ5HGfX7FndHWBWckKSA3t0roAknyeebf/v6VgzY1sxFtGJqR590O6/FPpTg5/hyJxsq+2iBoPZrCallrhUb79qu8XLZB798ANVGEZB8/JsuiNM8aqxzbNbEJE8G+xHBmu6Yl00/f07mzdI+DUugINmOFjawCfQu4IBKQek5Qp2XE/hmj5LFaxX+/hIAmPJjYc3mHJzlSKjEAkm51RckvgIEbjdlCl1Ev0RFL3+ZfYsGVirQI49cKsVb/kkSSY+JvkcLQBnF0eOOqtnWmPZvZU08ZBblzZso1bojBAp1I7SUtEKl9351ZBEJ2DWj76zkjXeiV0FKagCvbI8XgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0Gi9fNDlG0MoN/vkSE/osnWRNGVA+v7RKzhb13SX3ec=;
 b=f09l93HwUwtB+sLN44MEIE0PLg5JVhFH5gpYgKu1+EeX4IwB/StGhFr53Wio6cW2TRqESMEhnP7DcqiLQ3Z4qPqypZSs55LQM/HGFjS/BAjirFsHull8tUfsp7hw9vaY4zNnUDyl/8JMIET5KNhHdXMX2C/lGe0Tlp7ZTKdsISc=
Received: from DS0PR10MB7364.namprd10.prod.outlook.com (2603:10b6:8:fe::6) by
 SJ5PPF4561E4FCB.namprd10.prod.outlook.com (2603:10b6:a0f:fc02::79c) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.42; Fri, 10 Apr
 2026 21:54:17 +0000
Received: from DS0PR10MB7364.namprd10.prod.outlook.com
 ([fe80::a4df:c903:e1aa:322f]) by DS0PR10MB7364.namprd10.prod.outlook.com
 ([fe80::a4df:c903:e1aa:322f%3]) with mapi id 15.20.9769.041; Fri, 10 Apr 2026
 21:54:17 +0000
Message-ID: <f0510c38-9e0b-4265-a8f0-16d332937336@oracle.com>
Date: Fri, 10 Apr 2026 14:54:13 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot ci] Re: hugetlb: normalize exported interfaces to use
 base-page indices
To: syzbot ci <syzbot+ci1ddebc06ab8137f5@syzkaller.appspotmail.com>,
        akpm@linux-foundation.org, baolin.wang@linux.alibaba.com,
        corbet@lwn.net, david@kernel.org, hughd@google.com,
        liam.howlett@oracle.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        lorenzo.stoakes@oracle.com, mhocko@suse.com, muchun.song@linux.dev,
        osalvador@suse.de, peterx@redhat.com, rppt@kernel.org,
        skhan@linuxfoundation.org, surenb@google.com, vbabka@kernel.org
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
References: <69d89c97.050a0220.3030df.0026.GAE@google.com>
Content-Language: en-US
From: jane.chu@oracle.com
In-Reply-To: <69d89c97.050a0220.3030df.0026.GAE@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY1P220CA0023.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:a03:5c3::11) To DS0PR10MB7364.namprd10.prod.outlook.com
 (2603:10b6:8:fe::6)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR10MB7364:EE_|SJ5PPF4561E4FCB:EE_
X-MS-Office365-Filtering-Correlation-Id: e918754a-a4ee-44d4-86cd-08de974bb623
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|921020|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	0xQEk/NkAmgi+IoxAWOJLKAfNSSGnWJDzqOdok5dS5B59UOvFd32zwwovBwcOj2m+lQAZKkErDYUS1Orxd1mrP9x+U+XAg8b1ac1LCjJsczcZFY5do4Vdmt0CNd8syNhfh1y2ZdnuUTduyv64L7TMy0EmzrZF414FSuXchXyKaegmTk38sc2hIIuyCWUdF82sS+rSlhz2MePOWadbDvl9x1Hz5rj/T4Y2qzckRa7thAcImsHSLbnfAooG5DyPCMoGwArd20IE1ZjeVNlVuCW/3/c2eN++K7suDscuxYIXpGf3Nwzb+bH8eIyTn7G9RB9+XKZe8bO4/kNsaVD2DCkYsEA9fAua+mNha1bkmqGUHgzXeiRM+XJi85Ub1dsZI2dsyY/li3Z2FVrTfbqGpbogu7wr6xPvFk0KhNRLFQe/Obhkx+UiH8Axea4mnDdrUlJ5XCrHEok8QnakqsojmegouIujCyHSNPfjYpSCXB/iTuWyYh97SnQEiOTWukAwRxcn0D6+eRBo/rTu5718oALukfEnivy+Y58C+JcACyOWdc+AqzNy3RnLLuJQvXjJ6dLXxlG9TtBx0DEL+I9i+53clZsvWwp28n4aF9PQAo2WbFbsiATWEFV29Rnl2+z34uodZENJXAEN8LbVLzxHg+EM/Pc9Jjdt0r2YgIA4VCAijBgmy9LBVzYtX0AlTutKpXGDLk6plcbSvjmchzBUCKSVlSospbOdtx7KcKcQvwKDsw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR10MB7364.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(921020)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cDBLbzFsb2hPOTFJYjdUVkNjWFlIK3ZGRW1UaC9HUnNMNjcwZmY4cDBsQ0xZ?=
 =?utf-8?B?Znd1bEs4Zm1OZDRsK0FSSnp4YURTQkpqcFA4T1NwSnpWbFNlOXpYRkRjWGs1?=
 =?utf-8?B?b0tJRlp1R0pTaXBFOWtmNUdjQVphakZCdzlSSnk1YTlTNnBKbXNjOEJuSkUz?=
 =?utf-8?B?V3FsNGlpeUE5WUI4WlNMaDdkTWI2Q1k1T1o5ZVFiblNTMGlwM3c2enhySUJs?=
 =?utf-8?B?by9hTWVXNXpWcUc0bUhsejBBTlFneU96a1hjS2JpZWJqQ3h4VzNhMWlHN1RF?=
 =?utf-8?B?dzJtbFBrWUJJNUVaK0NMclJUU3JlbzVISjZ1VmpQNFNybTZ2a3RuUTU4eGdq?=
 =?utf-8?B?ZUU1eHlwbWhWQ2FwTlY0VENvTk9lUCszQUJ0OXRTS1UvTlNvZUZaV0hyeHZt?=
 =?utf-8?B?NEZ4K040V2JpRWxqcXVlM0xvTE5OTU85cGVFVWRuVm1CMUxpTjRDdFJnNlZ4?=
 =?utf-8?B?OVpDaXFTUG43dUVrelpRaENIRkM0YWdKMWxBZ1kyUzR5elN6Mkltb3R0S2VJ?=
 =?utf-8?B?Ri9IZ1U1bURFMGs4akt5Njlzc1pGWHdKaDd2ZXE4Q0JGNFo3NVhkQXFQYlRD?=
 =?utf-8?B?M1dqaHlNU1ZQY1RTR3FyV1BmWXg0aDNSaWRuR2ZNdDhwSnlrSWdKSkgyRjMr?=
 =?utf-8?B?Vkk0Q0FSaDU2WVMrc0htV29mSHNWYWx0TDV3SjFsVk1RWC9KNVMvVXdLNFAw?=
 =?utf-8?B?bGJSSU94cnVTN2toRHdLLzZ4Sm1TU3FxeTBlallCZXdyMTRlMVZCU1JDSUM1?=
 =?utf-8?B?S3p4UFNaY290Z0psQjQwMEN0S3M3VXRGemtlNjBOR2IyMXdHb1QwVWRyc1h1?=
 =?utf-8?B?UlhRL0RBeDdLaVlsdG1SMG5TeDFkVDdsdUE3Z0p2eGxPaklHT1dvbTYxMjZ4?=
 =?utf-8?B?SWREQ1hwdjJhMFFiZ0pvOUgrK2F5TThzZE1KZDgyYTZyZm1pWjBET0xzcEFO?=
 =?utf-8?B?ckEybWc2clNkYnhUS1lwdGpzaFlCRzBTT21JZVJMT2xCRFJ2RGI1QWYxTzN5?=
 =?utf-8?B?N05MM2xpdEtOWk83QzlIeVpKVTZQT1RLUFVwc3hKK3R4clIydFViQjJRSE15?=
 =?utf-8?B?RnhqUGl4NmplSTUvcFNIR2JjUHk1Tm5KNUZmSkdWdXZjaWc1MHhMaWhmNndu?=
 =?utf-8?B?TkJtSUVrck1oeExvMXRSMW5JYUJBMGJGL1oycmo4ejloZDllQVVzWmdEQUl5?=
 =?utf-8?B?aGhSS21vSWw2azNNSEE5cXZTaXlhWDhqbVIxZXJkTFd3dnFnaW5FYnNhRlhR?=
 =?utf-8?B?dmNCUUFWZWVNbldhcmdUV1FDRU9WZGxSakc0dEtJQTA5RGFDaHYrTzFtYUlB?=
 =?utf-8?B?L3ZYR2N6OHZxWEwxYkRRbWg5S2Y2ejZ3Z0h1VG02NGwvSVl0Mk1Bczh1NWVt?=
 =?utf-8?B?QjhVbEVaQ1JOazlibk0zRkoyMytqSU4zdzBxNjdtSFJYV1YwU0hWVmR2WWkw?=
 =?utf-8?B?MW5oaExMSUxnekJCaWVaV0UyUnRBc2RkTEFEZ1l0cWxwTWE1TS9aV1R3UVBu?=
 =?utf-8?B?OUxaMjA0QTB6dnZQNlVYQTBSeFpycTU2OGttMkE3N1ZOQnZzUlk2RnJyOUx0?=
 =?utf-8?B?OGdGeGJpMHYzbWNSWXJPUUhTQTIyZWp3TzQzVjNGYWQ2bmsvQ0FockpHMW9T?=
 =?utf-8?B?NlNtclhmZ25UZndjazFnS1RjMVN5S0cybWRTWGdMR3pseUU0bVRock5JTFV0?=
 =?utf-8?B?dHVxemxSdVZrcDhPTVE1OHExK1dYZUNHRjlPdm1UcW1zdkRpLzl4VHR4Qmpl?=
 =?utf-8?B?cEtYTE9IemZEZ0lreis1U3h6WVJRVWw1eXVQK2gwZlY0OEJpWnZZSzR1bG9m?=
 =?utf-8?B?bVU4Nk5MOWlwTWFIV3pweCtGU0N4WW5yVGpwSzdKdGY3MkM1djl0K0F5bGJT?=
 =?utf-8?B?cU9UMFZQK0ZoVVVjYkRaTkc3UytEN01YbXk4d3liRzgydlVtMUI0czZSMGly?=
 =?utf-8?B?UExLMW5CenBGSUkvNlhCczQxTGQ3RlVNSUp4dW5hYWQxWnBDeWVWczU1TEJI?=
 =?utf-8?B?d3AwL0g0dXZqN1pBZ0d4L216RjFodUZtVE9uYjJNSXc4WDlZeUY5ZWlrVnJa?=
 =?utf-8?B?WXNVR2R3RG4waEwwRFNxRkFNdTF0RXd3RTdWNzBxNE81VFQ1R2cvbndsTG1B?=
 =?utf-8?B?eGlDTjRSc2FHVmFPbE5ROElqcHMwZEUrRkF5ZlhMU0ZjSVJGcGxxVXNrTGVN?=
 =?utf-8?B?UVVWSFByQzJCbjNtMmtWVkRNNDZ0Z24yaGtqdDg0NjUySjd0T2JlTHFVdXZ3?=
 =?utf-8?B?SUhKU2hkYTVLVWlLcWdyMDZWaDVNcWNBRkZIVENIaWR5YnVSdU5Xem5JTE1q?=
 =?utf-8?B?R2VMZThFMW80TXFTeGE0MUFFR0FLUlUwOHo5YU8wUHNLTlJNTHloQT09?=
X-Exchange-RoutingPolicyChecked:
	VtX8weMtJGKHuoD5xHyTWKvAnNzPf96Ogx4XnsOh4Y6rDkWchWVgT0krT3Sr9gkS396YgqufAsPAqLjuwDAKL65SV1hg31+o29zmlqukm7tylAE5QkJXZwpV3+8CyhzPYqoGeAky8k2UvXXuOOP1nybxnqBNLiEhVDBgFXc0OKwF5LhUqd/vzPsljGi/KFyYhRFE+iDEHcOmSpNuwt6HBzozHOsPB1mw6C7Gvu02CESi8amr8+35KyK/tLRShkMl8bd3ij+XJoCamlYSwm/ndwQlISo3r37cC7Ier5FKm0Bol+tpfZEEJkQgAWg3Mu04A+UAvJse+xPD/eVrg6p5eA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	R/U15vJh79rJKQzXLi/+DBAussyd/JexhO/GaTt/2/jiS/9bk8+ipPtdPRNos8FaPV6UWGJVIR3lUtmeBQoKZ870DdFaVY1aoB5kNYun0KjNQX8ycmOauROF786v/3rOUo7V2V5SMLBybmtU7MRfQiVasdbpG68Rn7yfcgaRAMqse2mOC7e9LcncuglYEYcfwKB+sBbj/+Za7GDflEgtyM5K3CaHiTV5T2nnLA1lBv1jyjWU6cE0r+bV4mM5g5wbl+7OtRBeCIt7YFg9owxEB40Tz75MS98eqhRr8TE+r6FMfiC51wb/TBJg+9ha+MIVJecsR4MibhLdUr0G1/He6jub2dtTD2TAqaPs5JwWc6JzwVvkqqKR6YP6GiN3peXWFWnbWxH0rilVww9RMe4L5QW9cpmOKgC04kCGqontyvOUuDPFGNMk0ZRGFcDjzgOJ1oDQKextfXlu/rZ+uX3Dx1hsAmOXMBTbrhOlMKv3yzr7NZ4rqqXHjEwGeAedenGqbQa5b+SZl6snG29u3EUyaYA52jpA7a40j8PTP7I/TPU4cmC5159+XiP/Emng7S2vOG/oqP7nIeDr+qlhg3WsSZIYf5KKEvd5p1VwcWSvzI4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e918754a-a4ee-44d4-86cd-08de974bb623
X-MS-Exchange-CrossTenant-AuthSource: DS0PR10MB7364.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Apr 2026 21:54:16.9692
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zDnkAZea1Vl/YnFocXGQieIgGP/pIbLJQY0YCR18sIDDpKxchm67q5WexK83yxF4DSkMLIG3BfyIJdNUP5RWbg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF4561E4FCB
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-10_06,2026-04-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 phishscore=0
 bulkscore=0 mlxlogscore=999 spamscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2604010000
 definitions=main-2604100203
X-Authority-Analysis: v=2.4 cv=MtJiLWae c=1 sm=1 tr=0 ts=69d9718d b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=A5OVakUREuEA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x4eqshVgHu-cdnggieHk:22 a=VwQbUJbxAAAA:8
 a=yPCof4ZbAAAA:8 a=-ibLmwfWAAAA:8 a=Oh2cFVv5AAAA:8 a=hSkVLCK3AAAA:8
 a=4RBUngkUAAAA:8 a=8S1yexDsxx-BWL7rOGYA:9 a=QEXdDO2ut3YA:10
 a=A6MkUVyZPcTV1i89ro0M:22 a=7KeoIwV6GZqOttXkcoxL:22 a=cQPPKAXgyycSBL8etih5:22
 a=_sbA2Q-Kp09kWB8D3iXc:22
X-Proofpoint-GUID: K1tUmO7UXK_6ezKlWdczFaZGDyRcpv2l
X-Proofpoint-ORIG-GUID: K1tUmO7UXK_6ezKlWdczFaZGDyRcpv2l
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDEwMDIwNCBTYWx0ZWRfXzOzTXieJ7Ygw
 jQ9s44monckhoPDcYwHjM+RbfPwWdYDhsQg5rjBvcvjZaqa1E2L945CRlODLZeyREBkhPbBFmlM
 3hNOdchygirAGXjq9V9wOnLQLdeEIeg/G/yv0XCbA/j3UFId7gzJPu0/OsTQH5clNSiZr1tETQ2
 u+XqkTefHEuTLqEKEvbpIEDFqfjk5VC4omeyYF9vPip6h1f7RS/1sl44VFeefwMC7wEBLF14MG3
 6iq75FS4g5h5UfKpBxjhW90gyCOA1vx2AgT6HmDDWcTNv1LjlRvPpYYJheSrmuStMQ0VhnQOT91
 W9sAjMCKQlxdSC1KfmvcWx1BlTwOWPRivrnStFgxlJBLMW/xD3E25GZ3LtfhXe3nOuwnJFFtUn+
 CETBnUj2daNTsos94D6LttwP+S2E4WEG1wx77AWBECC+OVEAMQrziklAXqpojFUJvBjgLVMntLr
 eZbj6lMYi+EMAHSj2IQ==



On 4/9/2026 11:45 PM, syzbot ci wrote:
> syzbot ci has tested the following series
> 
> [v1] hugetlb: normalize exported interfaces to use base-page indices
> https://lore.kernel.org/all/20260409234158.837786-1-jane.chu@oracle.com
> * [PATCH 1/6] hugetlb: open-code hugetlb folio lookup index conversion
> * [PATCH 2/6] hugetlb: remove the hugetlb_linear_page_index() helper
> * [PATCH 3/6] hugetlb: make hugetlb_fault_mutex_hash() take PAGE_SIZE index
> * [PATCH 4/6] hugetlb: drop vma_hugecache_offset() in favor of linear_page_index()
> * [PATCH 5/6] hugetlb: make hugetlb_add_to_page_cache() use PAGE_SIZE-based index
> * [PATCH 6/6] hugetlb: pass hugetlb reservation ranges in base-page indices
> 
> and found the following issue:
> WARNING: bad unlock balance in hugetlb_no_page

Thanks for catching the bug. I was able to reproduce by turning on a few 
configs.  It appears below change fixed the issue, please confirm.

$ diff -c mm/hugetlb.c-BAD mm/hugetlb.c
*** mm/hugetlb.c-BAD    2026-04-10 13:36:52.417044993 -0600
--- mm/hugetlb.c        2026-04-10 14:33:31.637033381 -0600
***************
*** 5659,5665 ****
         u32 hash;
         pgoff_t index;

!       index = linear_page_index((const struct vm_area_struct *)vmf, 
vmf->address);
         hash = hugetlb_fault_mutex_hash(mapping, index);

         /*
--- 5659,5665 ----
         u32 hash;
         pgoff_t index;

!       index = linear_page_index(vmf->vma, vmf->address);
         hash = hugetlb_fault_mutex_hash(mapping, index);


thanks,
-jane

> 
> Full report is available here:
> https://ci.syzbot.org/series/95c5ba82-0135-4026-b7c7-b0819e1ca4d6
> 
> ***
> 
> WARNING: bad unlock balance in hugetlb_no_page
> 
> tree:      mm-new
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/mm.git
> base:      06a6cfb92448a97ef429a7fbd395a20a9d388acc
> arch:      amd64
> compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
> config:    https://ci.syzbot.org/builds/cefe8576-3c99-42d3-9b51-1e70d62a64a7/config
> syz repro: https://ci.syzbot.org/findings/3a14cc12-14a8-4fac-9614-ae7ae2555e58/syz_repro
> 
> =====================================
> WARNING: bad unlock balance detected!
> syzkaller #0 Not tainted
> -------------------------------------
> syz.0.17/5971 is trying to release lock (&hugetlb_fault_mutex_table[i]) at:
> [<ffffffff8229b876>] hugetlb_handle_userfault mm/hugetlb.c:5686 [inline]
> [<ffffffff8229b876>] hugetlb_no_page+0x1986/0x1da0 mm/hugetlb.c:5770
> but there are no more locks to release!
> 
> other info that might help us debug this:
> 2 locks held by syz.0.17/5971:
>   #0: ffff88816b85fb88 (vm_lock){++++}-{0:0}, at: lock_vma_under_rcu+0x1d1/0x500 mm/mmap_lock.c:310
>   #1: ffff88816079e338 (&hugetlb_fault_mutex_table[i]){+.+.}-{4:4}, at: hugetlb_fault+0x317/0x1440 mm/hugetlb.c:5991
> 
> stack backtrace:
> CPU: 0 UID: 0 PID: 5971 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
> Call Trace:
>   <TASK>
>   dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
>   print_unlock_imbalance_bug+0xdc/0xf0 kernel/locking/lockdep.c:5298
>   __lock_release kernel/locking/lockdep.c:5537 [inline]
>   lock_release+0x248/0x3d0 kernel/locking/lockdep.c:5889
>   __mutex_unlock_slowpath+0xd3/0x7d0 kernel/locking/mutex.c:938
>   hugetlb_handle_userfault mm/hugetlb.c:5686 [inline]
>   hugetlb_no_page+0x1986/0x1da0 mm/hugetlb.c:5770
>   hugetlb_fault+0x67f/0x1440 mm/hugetlb.c:-1
>   handle_mm_fault+0x2007/0x3170 mm/memory.c:6716
>   do_user_addr_fault+0xa73/0x1340 arch/x86/mm/fault.c:1334
>   handle_page_fault arch/x86/mm/fault.c:1474 [inline]
>   exc_page_fault+0x6a/0xc0 arch/x86/mm/fault.c:1527
>   asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:618
> RIP: 0033:0x7fa742251964
> Code: 41 89 00 31 c0 c3 b9 40 00 00 00 bf 40 00 00 00 eb bc 0f 1f 40 00 48 89 7c 24 f8 48 89 74 24 f0 48 8b 7c 24 f8 4c 8b 44 24 f0 <8b> 4f 50 8b 47 58 4c 01 c1 41 8b 34 00 8b 11 21 d6 89 f0 8d 72 01
> RSP: 002b:00007fa7431fd018 EFLAGS: 00010212
> RAX: 00007fa742251950 RBX: 00007fa742615fa0 RCX: 0000000000000000
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000200000400000
> RBP: 00007fa742432c91 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000200000400000 R11: 0000000000000000 R12: 0000000000000000
> R13: 00007fa742616038 R14: 00007fa742615fa0 R15: 00007ffe952c6908
>   </TASK>
> 
> 
> ***
> 
> If these findings have caused you to resend the series or submit a
> separate fix, please add the following tag to your commit message:
>    Tested-by: syzbot@syzkaller.appspotmail.com
> 
> ---
> This report is generated by a bot. It may contain errors.
> syzbot ci engineers can be reached at syzkaller@googlegroups.com.
> 
> To test a patch for this bug, please reply with `#syz test`
> (should be on a separate line).
> 
> The patch should be attached to the email.
> Note: arguments like custom git repos and branches are not supported.

