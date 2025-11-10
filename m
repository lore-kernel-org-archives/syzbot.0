Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC6CC2AD13
	for <syzbot@lists.linux.dev>; Mon, 10 Nov 2025 12:17:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762777073; cv=fail; b=aRVjJ78Q06uJVVpwhxrKNRunXqgZNOPCFB1jpnSs2umftKODkmG1V94tqgy4Vl5Rd99KW7Q3HQZWDy4vPUJ+eZrkzMGvT3TaeSEr9bFKC2ap+DC1aW9VUMtJLWHDH/R1moILieahp35i1qp9y8riCnuIqWaiwAgZ5iM9Z92lH00=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762777073; c=relaxed/simple;
	bh=JsNfCk17ufaJe5Lta1PQiMQxzXXipy5Qf+jFNMNJSxU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=ewEGJ5/HqoA/jkVjzElVmE8kgvovqAqkZcaFXykGz0mijLWj5q1vsjolbwalL+bXesZjoYrRFb2O6WfuhywrYmaD+EZ9lGL8C0VNzxj+WNOL6OuZrxavkp3NvqYxJEeCN+fwvVpkxcmHqn337Z1+UyDemqKFYAm14uQL4FV003E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=O2RjEmAA; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=wBXfDbr7; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="O2RjEmAA";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="wBXfDbr7"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AA95B4b011538;
	Mon, 10 Nov 2025 12:17:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=c2uCxJA1d8WiL4FlLB
	oq55WIVy+xjHvRH8s+QOblXbo=; b=O2RjEmAATit+dVMV4zmJwZsv742Za7rWDK
	NejpYueRb+aMaJRnYlSqhxEVELJS3i3hcN6KFYTEuorABe9BLb5MqfjZCaqhCOUk
	9SH9vzn3F8nc9wtEruywc67kJv38HrqdWJCw38M4Yk9HFgcLwuoHDpZ4yDmfXL14
	uTPjzJhna09+Pk7RBvfTFm9sUrcsIC1xgYQd3vrkZ81/PzE/5p/JH3bFNuNJpVEn
	2P/10KVnEOzx3CNpDmdVjD/s5aUpVEw4GaHO2sumd62yKzWh30Pp1JJfG+EntR6v
	Ct7VMHv7+FIK4oIMs95kyV4d1jBm/nVrpEl/cBfqlsv3VcBjBzgA==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4abd3wrdj9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 10 Nov 2025 12:17:39 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AAAAYi9039928;
	Mon, 10 Nov 2025 12:17:38 GMT
Received: from bl2pr02cu003.outbound.protection.outlook.com (mail-eastusazon11011031.outbound.protection.outlook.com [52.101.52.31])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4a9va8350s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 10 Nov 2025 12:17:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FzpRIOeiEV716EECPdfcu5a9jKihHeTdKx/EaesbGC/wDhLcIEqvBN7jt5ciA7jaxxe96P64z9/f/4QtQ5i1CVpHYKvQnOr2uA/lZhFkW6X5cj1h1U7lOjVg+ipA5TcAvbZp2ML0O/HveaD674stf3hk0HCqGjJY771+7/umtfjljA8SinC4rqKKCVq0a8K0i+08ubad3DCTfEea8rKjiV+IS0zudQ/KhdFVeRWbVnJxpkZI0dfdXU+KLx+unGEomIUmPqFH/BCr46FcclwTWDqJCMiKBYnxGIMM+xzaZCSq1WTjBS7bJGdw2amiF2r29nQ2C5gxydRAtobB7XCkWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c2uCxJA1d8WiL4FlLBoq55WIVy+xjHvRH8s+QOblXbo=;
 b=A//Om6GMIkdr6np0IvbVZMd2hidRICH9S/nR2khYWffejVqEtNskZP67br1h/IPOLiAahtyxlUXUUxYX35H9PvnaZg+61PspCU8Qyt32VjkAvHSQRrAi60IAqy2pGZ/LVuOOSKhaCPHyPGIPyavqkZmv3/wbm9ni8Fou+XF2yvTDhzemC5/DBJYr7/zoDq3d/UKyYMe51rdvhb9RlghvDQB+4+pGqVnKjC/MUpbyVzkCZa98bhU+9DhEVprcnz6Hj+gi7GaCn3i1UsGqAmqnn5r7jflKHeBGkRK8MMpSERvNT/Zc2AcKTDT5DNA8aMjnrS9co/h4o5uV45O2J+I1nQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c2uCxJA1d8WiL4FlLBoq55WIVy+xjHvRH8s+QOblXbo=;
 b=wBXfDbr7CFBGWeHTMQFxt8aMB/w/UBF+J38rBjcD0G0HlCbc/AiG0pqy/x3E3/04QmXpGSVi/fIb+/sgl5EWYjlIJo5AFdpfcbVq8oqdcV/JEDRycGaXMiDHnSMlvSmtD6wXwXqJO0EnneFe131CBhzXgYx1/ut6qsLSMcdfnpo=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by DS0PR10MB6750.namprd10.prod.outlook.com (2603:10b6:8:133::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.16; Mon, 10 Nov
 2025 12:17:33 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%5]) with mapi id 15.20.9298.015; Mon, 10 Nov 2025
 12:17:33 +0000
Date: Mon, 10 Nov 2025 21:17:25 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Lance Yang <lance.yang@linux.dev>
Cc: akpm@linux-foundation.org,
        syzbot+3f5f9a0d292454409ca6@syzkaller.appspotmail.com,
        syzbot+ci5a676d3d210999ee@syzkaller.appspotmail.com, david@redhat.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        muchun.song@linux.dev, osalvador@suse.de,
        syzkaller-bugs@googlegroups.com, syzbot@lists.linux.dev,
        syzbot@syzkaller.appspotmail.com
Subject: Re: [PATCH v2 1/1] mm/hugetlb: fix possible deadlocks in hugetlb VMA
 unmap paths
Message-ID: <aRHX1XIyymGGWKHd@hyeyoo>
References: <20251110111553.88384-1-lance.yang@linux.dev>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251110111553.88384-1-lance.yang@linux.dev>
X-ClientProxiedBy: SE2P216CA0187.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2c5::12) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|DS0PR10MB6750:EE_
X-MS-Office365-Filtering-Correlation-Id: 70b36036-d0f7-4918-5367-08de2053208d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?9jltgdm6sec3mF2ocMauspAyRhSpI4hffrQ7ibx29suxrblB3e7B275Rap3N?=
 =?us-ascii?Q?AAqarIMlxBrZTf0bHcQp9cBXruWqn/AyXOfEZU0OHu4k24xZREyXPIePyRHL?=
 =?us-ascii?Q?29/OnIc6DD+ZjYJVQEscNq8aVa+XE5NoOJuyBCgKZsnaCvwedaxCExm5IHU1?=
 =?us-ascii?Q?eAQqbf5lE0jr5uBKz+XLebqQL0+dgJ8sjbJhQEqmN7m4jHFFMxja5K8w4ppB?=
 =?us-ascii?Q?2UhBq5VA/Zsbg+40oe4pJkr2Lafj7ikhZirhIgin2gDcWje7XNUaRYtJwtIS?=
 =?us-ascii?Q?N1qWTYBXHp3oR12IIrFyXI6DcNIpApIuIXk4UWi7n5F8stSTOqjFCpr7THUd?=
 =?us-ascii?Q?mZOIUryUOki1XwE1UCMymLa+4ER7Vs5PfN0tZEN57ov+KsPNZamLowdBLz/J?=
 =?us-ascii?Q?IBSXlmYSoD5BvQXD2uV9Bx8P7MsOqy9vL9LhfynV8UGdp7X+UsDwO08XYOhx?=
 =?us-ascii?Q?NpCAu8lOFdCJB7q4AwO2/YxYbDgu12NSD3n7xqrPLk1VxpfiHUuaZj3ZPUUL?=
 =?us-ascii?Q?gap4Xlhe3S1YH2Nu7mUe04Jf+bZtP5QjqXvd18vBmMnrM2uiCR1MotPPJ9xu?=
 =?us-ascii?Q?gUgkZ1Sm2uVpqh/O0h2c+NFy+Dvp6JOnlTt3Xx5sUQ7pM27MWKt6g6SvSQtv?=
 =?us-ascii?Q?EaZ3QlPChs5egovA3bkNUwka8s5uRkevd7yMKZcrRXU+BajZSGYvXvG5gtOU?=
 =?us-ascii?Q?e0XF3Ko7Qd39g54Dlyl0iij/c42trswRXLF1XOGmRmm5UnyS92k1UEcmrqaH?=
 =?us-ascii?Q?zJ7RrhgQ+DmfZYeD29bXTdqvQCeAhFN/X2dVSMqKotpSweIATrweEoL3IUKX?=
 =?us-ascii?Q?91v/YC2h3R3H+0VKZlwZUbAFTScEIX7Dt1QzmNyOy0eCGaS1GECt4rmchO4q?=
 =?us-ascii?Q?zABMcX3HsHnPOa8NKKJHf0iZU/bl2U9gUD10APCJbsvdAwSoos9HULai+Q1h?=
 =?us-ascii?Q?AIaKy+razUAGktl2ALsaBpXlmpnDn/b4ZuxPJ6h0omJNisRAn2WL/XhZLYQK?=
 =?us-ascii?Q?ug519KV9olcqcFf3BRjjJtA6wS+epFzVFcZ0hNjSI2xPoLSj887m1wprPetV?=
 =?us-ascii?Q?7oYDoFjoY8NenTJl8zdLy1tUQ9Vuy/KvX5yI30ZF04Ya4TQN+7MeFPDz1mmQ?=
 =?us-ascii?Q?sfpAtb0C4rgfGNdlEXMRSuJ4YUVv0oB96+2zd3CC1VNjizOB4rIg8jiNLCGp?=
 =?us-ascii?Q?gLK6K0YaRwyj+m2cjL3PgE/QqnE7o1/g7JLLGpe8tylA71uWkM12kcSKBK8Q?=
 =?us-ascii?Q?3r9xyU2ACHF13gSJlIZk9yrdQ4Y18nFz7B3Ezav8aYu1uYHMsUvqa2UCpSsy?=
 =?us-ascii?Q?qIDfNneg4jIFU8h1AqDfOL3bEvGJ8wHVhQGF+Kxa1hDiQdw1UTX4sCd13r8F?=
 =?us-ascii?Q?uNDJcIYJMMxPLDBfch8cc7Z/mCJiHz/MMVearLsa/6FDzdgJx6gKXXRCG+Sn?=
 =?us-ascii?Q?dYnIylmovVDKIyAgwCM3qHOc3jdGByQXKvMd3JiwaPRuQG8jBALUhg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?fwhHVuPw2i3cE4wKnSwoQZShuHeChb233rcxRlX0N01vgD+MRc7F+7Ze1Lt/?=
 =?us-ascii?Q?rWFson0QlyAQhFp1PfWy1jq45U9agQDUoVcbmA1fgUirj1cSRWWjKJGxXvCa?=
 =?us-ascii?Q?CUI7xIwpgoJp5ee2+Nxxcc546w7lkYAWpMV7/kwNe9IUAZsbUpEYxzIANQIp?=
 =?us-ascii?Q?t7BFE7dAKlc3XkxpskXIGE7c5seTPeeN8unkWWJ2/8nIphRl1n1TmNONtZqI?=
 =?us-ascii?Q?8KDPGSaPBVDyidjXz2X2DhDpplQs0JxQxQW+juigVZpG0CnRGGtu4YNY9OFK?=
 =?us-ascii?Q?vFRf+IIHsQfXYWq1+X+04ek1XK7hUOaOJc6AbaV9kVlBC2fNKQQngqhHokuK?=
 =?us-ascii?Q?rYEcagm1tt1yr/lm/a7OapW3BtNvFqiM+zcDzblSxAAngePdlxqw8sAaSTES?=
 =?us-ascii?Q?GQcSMRf4Bv/1gWC/wdabVLGyKfmOCQQ91TBq5ZmBBKvTbCF74soGgAkooX4U?=
 =?us-ascii?Q?WPUtoFPGLhGT4RVTzZp76A2ndFve59fwEHTjulW7LGoJu7A8vl4MsR0XIuS4?=
 =?us-ascii?Q?XSGEzZFTaYv95Ekbdzlv6WwwhT0QENLbrFRJqQDubdNSr6v23yFYLYugbhH8?=
 =?us-ascii?Q?Wk/EXsbHgDnXOcKzA9Sn+Sd8nVz/P8kAZBUecZ60SjQt7QSnIqPiWULTqvMt?=
 =?us-ascii?Q?w8jycGXmauVMp6kr3tjiuWmCHCVuiHjmR6jpPWRx5V0Cyq5wi6Txk1Bgz2bB?=
 =?us-ascii?Q?6sDHtyO1KficGj6zip/KsKjmKq21RD1TQBsSbLdRmbrUUiGPI12rL278NZ23?=
 =?us-ascii?Q?i4UYuiEpFgeXjssdagRaFk7kzfDoreH6OzAOnW93VKbhvvMCLOgGtarjM+2s?=
 =?us-ascii?Q?4FFkQE8QlLZEl3/gcIRxDrbW+e2xIi6uK05aqiFsf13ALgT/tPZYYXMxZ2Nr?=
 =?us-ascii?Q?O/epE+U3mkB6byPzc7KY4QNSHE1Uh8Jsn720uy1ky++YKoIPcriUNCbGROl2?=
 =?us-ascii?Q?cgLvJXdlOsXsVRH8hJMmcH3j9GGuBYOLfB8YNh3H0moreMJjXYTn3FABbjrg?=
 =?us-ascii?Q?45oWakr3AIVWcWlJ2Zc20nVsx15r9JbWN09OG+NQcZPcxwsbJlraoqr64jKh?=
 =?us-ascii?Q?1KeO4D4THbbwfmVC4F09r1dEhaol/+TYQ9B5OXsYGKQkWN7eOJV6C8BWSkEm?=
 =?us-ascii?Q?3XCt9RFPfxN546gUSwy40WToWkAkfR821bh97vr9NYOOqfdYxwQWxip3E+5e?=
 =?us-ascii?Q?6wg8llu89gKJpdnuQkanGU3ct3uUe5HGScjCrNZy9bqIjxl8NERg5MbSH55L?=
 =?us-ascii?Q?923tscRNORatOxYrodcz3/gMPMss2Zb+HD1xTkhIcsBqYfvbobMAQ2CylsQw?=
 =?us-ascii?Q?3MzURHmvCfecJD2ey053WYGsIa8ewQShCBsNWw1g1YzaVA9tbql7hIFRv+6m?=
 =?us-ascii?Q?IpOHEDAuUhtVIpoJdvIuuKN9iJUM+iHHq6B8pWJlwpZEalIuWA4A16a6BCTq?=
 =?us-ascii?Q?cnbaEcyifUEFSAHvYUWG3VwySWIXG2ee+lobPS/A9p3oGo9dvoi8K9CShBd3?=
 =?us-ascii?Q?9GnFiScBtb3ZcdPUCa+wQCgXh24mmTtlLz6AdHPkqAsEr8LNmBXnB9yyW4kV?=
 =?us-ascii?Q?pApTHbxwpc+X7ue/zuwHdzB47yCiR6tyxgo7jn5D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	SpKqXPhhVnN5bXKLXqAKTCvTV2Mof13RR19zfQVFuYDL38q63k6Yn27n+TDjOyOh8xIWwJqnt79T6vUCyyaRL5BDQ/ivHTVpiDD+5U83OHug6aJwjWnmYWzvp3MZS0xopm0RgAo8lxnTCU0Y/g5JPe2HlohJVpouSRUb0byEFS/p0EegGsDmTV5huXeKsxJqxS0HkKr5l0BMI6JSLptXErsroLO4JfO2mK2KT0GdLPAwO+VkbGzvWboxBbv/HE5cq81levrd0ysD6RUVwFTjoNMr81SM0CeFgCpLJ2+NNZv/kIiDE43tviGmNF2Ai/zbyekUPehAw1yn65z7Xf5b+G1sZyVxv+FDRzWqCAWi/7+dvwNSDqIWAWeXVcWl5YerHmfzgiZvMrIjJi3vK/WXWVysfWkx/kUN+mRYmKLnGtGMOt7iyaIpaoz0k9EbG/LOko/hEGW8P8vrl/yLW0XalvQtbrPcXrJy01CWDh8WESf3AJme8ifTmbk2+f4aOaV8STNDuwjrwlUWSl1Zv5C45zaYW9npoII5c7rro2NcXWm2mXXSBqzYmjFkE/BQdNBDBBxnOGoz8J/U9nKW3xp4kYQjwQY0NAiMbOfFWMWErnA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 70b36036-d0f7-4918-5367-08de2053208d
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2025 12:17:33.5717
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NEiZ88t39iwEbk6m6ISebTNelDuagoG0jJj4BNCSU5lM7rPhrvgrqI6kL445cqrobmqjSjJRf8nL+2sQjxB23A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6750
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-10_05,2025-11-10_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 phishscore=0
 mlxlogscore=999 spamscore=0 suspectscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511100107
X-Proofpoint-GUID: Ycr7WnQ9zzVNTyIdpCXZRxht1yAl4BTv
X-Proofpoint-ORIG-GUID: Ycr7WnQ9zzVNTyIdpCXZRxht1yAl4BTv
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTEwMDA3OSBTYWx0ZWRfX3iWtfI/Tz/kL
 24jAkDIB5+MAXuRow7L001IjunQ5d54z29bowvUfHiY+J+Gu+c+EbZnwyJsm2Y+DDPzneXFQxjW
 lGFOC82P4Hdeh7kT/ztyTzLAFJZcm9cd12V6A7eNGBF0z2tElwpwSIPj7CiNPEOcnGY8cjZsEKW
 6rdpP7e/qXSMXtsGusbpN/hkCFn4X8Cvc4sN36JHvhGOpuxRYE2pBmenmL3w923b/qx3p0QynTy
 d+zweD5ASLWQiz/Ahslu8ntTGwEnubVD3W1my4ZWhP/cTDeJLXQlafvgNXwAfq/pKIOHWvBvVMV
 4bwF8d7ZsLS89aOT5w5IIqt80+nZhK/UEp9DZU57J71QDwoGuRajF/2/vdiZ/EuRsEPhkYB91IO
 3FG+VcmN95J89zk1vwg2QQ57r+fagw==
X-Authority-Analysis: v=2.4 cv=Fv0IPmrq c=1 sm=1 tr=0 ts=6911d7e3 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=1XWaLZrsAAAA:8 a=hSkVLCK3AAAA:8 a=JyIbgIBVFyHZYdhiUh4A:9
 a=CjuIK1q_8ugA:10 a=cQPPKAXgyycSBL8etih5:22

On Mon, Nov 10, 2025 at 07:15:53PM +0800, Lance Yang wrote:
> From: Lance Yang <lance.yang@linux.dev>
> 
> The hugetlb VMA unmap path contains several potential deadlocks, as
> reported by syzbot. These deadlocks occur in __hugetlb_zap_begin(),
> move_hugetlb_page_tables(), and the retry path of
> hugetlb_unmap_file_folio() (affecting remove_inode_hugepages() and
> unmap_vmas()), where vma_lock is acquired before i_mmap_lock. This lock
> ordering conflicts with other paths like hugetlb_fault(), which establish
> the correct dependency as i_mmap_lock -> vma_lock.
> 
> Possible unsafe locking scenario:
> 
> CPU0                                 CPU1
> ----                                 ----
> lock(&vma_lock->rw_sema);
>                                      lock(&i_mmap_lock);
>                                      lock(&vma_lock->rw_sema);
> lock(&i_mmap_lock);
> 
> Resolve the circular dependencies reported by syzbot across multiple call
> chains by reordering the locks in all conflicting paths to consistently
> follow the established i_mmap_lock -> vma_lock order.

But mm/rmap.c says:
> * hugetlbfs PageHuge() take locks in this order:                               
> *   hugetlb_fault_mutex (hugetlbfs specific page fault mutex)                  
> *     vma_lock (hugetlb specific lock for pmd_sharing)                         
> *       mapping->i_mmap_rwsem (also used for hugetlb pmd sharing)              
> *         folio_lock                                                           
> */

I think the commit message should explain why the locking order described
above is incorrect (or when it became incorrect) and fix the comment?

> Reported-by: syzbot+3f5f9a0d292454409ca6@syzkaller.appspotmail.com
> Closes: https://lore.kernel.org/linux-mm/69113a97.a70a0220.22f260.00ca.GAE@google.com/
> Signed-off-by: Lance Yang <lance.yang@linux.dev>
> ---
> V1 -> V2:
>   - Update changelog
>   - Resolve three related deadlock scenarios reported by syzbot
>     https://lore.kernel.org/linux-mm/6911ad38.a70a0220.22f260.00dc.GAE@google.com/
>   - https://lore.kernel.org/linux-mm/20251110051421.29436-1-lance.yang@linux.dev/
> 
>  fs/hugetlbfs/inode.c | 2 +-
>  mm/hugetlb.c         | 4 ++--
>  2 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
> index 3919fca56553..d1b0b5346728 100644
> --- a/fs/hugetlbfs/inode.c
> +++ b/fs/hugetlbfs/inode.c
> @@ -447,8 +447,8 @@ static void hugetlb_unmap_file_folio(struct hstate *h,
>  		 * a reference.  We must 'open code' vma locking as we do
>  		 * not know if vma_lock is still attached to vma.
>  		 */
> -		down_write(&vma_lock->rw_sema);
>  		i_mmap_lock_write(mapping);
> +		down_write(&vma_lock->rw_sema);
>  
>  		vma = vma_lock->vma;
>  		if (!vma) {
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index b1f47b87ae65..f0212d2579f6 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -5110,8 +5110,8 @@ int move_hugetlb_page_tables(struct vm_area_struct *vma,
>  	mmu_notifier_invalidate_range_start(&range);
>  	last_addr_mask = hugetlb_mask_last_page(h);
>  	/* Prevent race with file truncation */
> -	hugetlb_vma_lock_write(vma);
>  	i_mmap_lock_write(mapping);
> +	hugetlb_vma_lock_write(vma);
>  	for (; old_addr < old_end; old_addr += sz, new_addr += sz) {
>  		src_pte = hugetlb_walk(vma, old_addr, sz);
>  		if (!src_pte) {
> @@ -5327,9 +5327,9 @@ void __hugetlb_zap_begin(struct vm_area_struct *vma,
>  		return;
>  
>  	adjust_range_if_pmd_sharing_possible(vma, start, end);
> -	hugetlb_vma_lock_write(vma);
>  	if (vma->vm_file)
>  		i_mmap_lock_write(vma->vm_file->f_mapping);
> +	hugetlb_vma_lock_write(vma);
>  }
>  
>  void __hugetlb_zap_end(struct vm_area_struct *vma,
> -- 
> 2.49.0
> 
> 

-- 
Cheers,
Harry / Hyeonggon
