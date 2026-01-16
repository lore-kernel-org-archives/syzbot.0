Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEC5F1F0991
	for <syzbot@lists.linux.dev>; Fri, 16 Jan 2026 14:03:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768572203; cv=fail; b=dDfHvX5tF697Hf+Yka2F3qBA0KiCDG2MnLSNYjoXp1ljnYfbcTO9ufRHIRc9lIRMlLDj+rOwggzzngTz+OfvmDYRt0QQjcWXwuW57rT94mMbjvCNEq7ktbwJVNlZ2C0CDrZT5tgBpv/BXsVIOlLtnb7xvw2RDQw6ygBwRHKaVtA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768572203; c=relaxed/simple;
	bh=QRCTh/ja7ta5n5ibjvYcY/+btkLb2glWPoGwx9AYFig=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Mm935L8IA2ffzvtGVAjkY/++/A7/NA1fLAVVQXhrO8T0TmxufXb/2Fw40T7CYK7VlX8ZyQUNCtKoVoqgbTY900+S5dQt4jd/EeaRxCUbEGJGI7YcSgqc4jI0sUnEYxC249JD4g7B0tL48ES8U+w1m73R8/zTN9iWVL51Lhmrpqw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=JU1pJwXb; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=FRO6yuv2; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="JU1pJwXb";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="FRO6yuv2"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60GDsMCv2455524;
	Fri, 16 Jan 2026 14:03:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=4HLCYUq3muhBpF3dzR
	lot2Por7hx1y8j/9rUjjulP1U=; b=JU1pJwXbqFafVGdjxworgQDoEVUsFbSjDS
	ACtE3er3/qrLjpJ1eqS3LKnWAhZP5BtUdMU6ZpKnZhX3joEB1WgwqTzzgdjutNqL
	FcSQv6493GkhScejpwpKJBAmUXWHK+dJurqEFabTGQE2Q4CiRILMKE2/O5MhnUsf
	nOUPD8IeZqHmxXmm0ioNiuBm0GGg/7kKAHzWsKx5qKGMe7yTi4sgGRe1u+tcidO5
	MKLXn/xaIko6Nsr9D1IDTWSINCe2S6dh54Wqgt++FYwyCdYrgn6cijnnsZxzzoQM
	ulC1iA1siyDu0VfZIWr9mNjDL05ToA+vbzlmUoeWia83ALPrcwog==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bp5p3dbk4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 16 Jan 2026 14:03:06 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60GDt8nn032683;
	Fri, 16 Jan 2026 14:03:05 GMT
Received: from ph7pr06cu001.outbound.protection.outlook.com (mail-westus3azon11010069.outbound.protection.outlook.com [52.101.201.69])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4bkd7cxfch-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 16 Jan 2026 14:03:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cYxoowyL5L2Op4KJM5O+GeKHccu+T3GFWX0HWp2ZnjjZk2jWOSTXDSDJtMqzepnfE7L5/bZQdt0SrMvL+jQOkQutulXph54YhHg3CsCqC6wrG7e3ZbDgRa31Trp5909Mphc260j4db76SqBEOfaO8dj88RMZF3WHF8egoh2L+VtXx+YUhpS74/P8TzHFJTFU8lacdf2zkWSreJkUjq+Wiqj+knqN7sJqIbvGTVs8ZvaNuG7xjIH/zJxgwu5zn179Mkag6MC6jfOlYbUcLnj3CXWtRfvC7oT2J4OujKbhvQoSrmhFQpbUxzB3CwrKJ3ugqyk/DoZ/nXj0PTExiySB6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4HLCYUq3muhBpF3dzRlot2Por7hx1y8j/9rUjjulP1U=;
 b=kV+KUBbWIZnjS2/ZeIn0EvjTvycVZxKPxIEkm8+5A2427imFgxZCzncgm/txKx4t/Y9mulSt+n17jMevD79Kk3XvVIImbQBrk3iRrRHvdNgxm55F6BsJMFDKBnZ6KaV90KZY5dL5ul44UXMSjU4lPlOi2IuwqTJ7Xz6Ai6l/LnakgoqkzI3awTQdDERe2lSAOwn+FfGt0XaNmyW2Wb2n13BetFphh6ppMEy3AoF7u3/I8vWk+GTF8REAoO+eiQ8WoAqhBCSKX3MCtiIdHSrJ60rIuDVZQHAXD/ZH31DTuEMxyRGMaU/1RNj8PG9782ld+Pi6ayy9APEYgT0260hT9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4HLCYUq3muhBpF3dzRlot2Por7hx1y8j/9rUjjulP1U=;
 b=FRO6yuv2pRGbVxuW4LYwVHBwEYm0WulMIgiGC/9+l0rSwzJW/YuQYPSO+S+0bFmTBHMaIipeW3Hp6bqRChly+IlWjTwPadcYSGAwI2lCfPJOUZupU6RuB1U5/Vrk6Z2/lQ8yGndLWP515I/FYsI9S9Mm4FogyG+f0YM9rsdSAW8=
Received: from BL4PR10MB8229.namprd10.prod.outlook.com (2603:10b6:208:4e6::14)
 by CY5PR10MB5985.namprd10.prod.outlook.com (2603:10b6:930:2b::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.4; Fri, 16 Jan
 2026 14:03:01 +0000
Received: from BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582]) by BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582%6]) with mapi id 15.20.9520.005; Fri, 16 Jan 2026
 14:03:01 +0000
Date: Fri, 16 Jan 2026 14:03:04 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: syzbot ci <syzbot+ci80398e89ae0989e0@syzkaller.appspotmail.com>
Cc: akpm@linux-foundation.org, david@kernel.org, jannh@google.com,
        liam.howlett@oracle.com, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, mhocko@suse.com, rppt@kernel.org,
        shakeel.butt@linux.dev, surenb@google.com, vbabka@suse.cz,
        syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot ci] Re: add and use vma_assert_stabilised() helper
Message-ID: <1dd32f21-4bdc-49e6-ad21-5d27c08ab255@lucifer.local>
References: <cover.1768558900.git.lorenzo.stoakes@oracle.com>
 <696a4245.050a0220.58bed.004e.GAE@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <696a4245.050a0220.58bed.004e.GAE@google.com>
X-ClientProxiedBy: LO4P265CA0058.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2af::8) To BL4PR10MB8229.namprd10.prod.outlook.com
 (2603:10b6:208:4e6::14)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR10MB8229:EE_|CY5PR10MB5985:EE_
X-MS-Office365-Filtering-Correlation-Id: 20f9dc12-3ca0-4c67-eb3c-08de5507f5f7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|366016|7142099003;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?9lvP0LusFJvDeAzWKrvZK2EMXOHMMEB+nUaqGUwJjkbjIdiNab9M0fuB42Fp?=
 =?us-ascii?Q?0BkD9Vziumq03vt6OUNNL4XHi67xFT0kM0mbSFnhs23rWaBCaXMnJFAlrTbJ?=
 =?us-ascii?Q?ozpnYoMqWhtOaJ2qw8BCPOdQ8Od0zEjvVrwJiOF1fOghwlTmLHaZIsuDDKYV?=
 =?us-ascii?Q?y4Z5NzGhYylhgXo0eIKAz8cZOS9JigkUyeYL2GqApPj+fwAsQ/D0HrvEBPlB?=
 =?us-ascii?Q?kzS+CmV91p1YTT4bcV6+kZKcYUm0rkXNe7daCZA6bCrEpyWV5ttZWkrGqa6M?=
 =?us-ascii?Q?u1oYi784Kf+EPsFtvdypqbgDLHIF9P0Gph0GBSkKvAVRMc7VJVkM/sn7xxGm?=
 =?us-ascii?Q?Nob0KPjcmJMnnn8ZblNnqduqTi4xtrcyd9vL9KyePVOUZDqlhDi4Or4uoQbr?=
 =?us-ascii?Q?ckGktcP1k/wXEgk0+OnAKz7Kz7baWhTePwBjl3a2RbM9RfyjwO5EmfbjIE+y?=
 =?us-ascii?Q?IgEUfZbxfHF9O+z6JAZ+RJYaa0CEOug6fa8NGIyHsz12eyJcSX7v98xfGKzg?=
 =?us-ascii?Q?YCjiLp0ex/87JTNsW+J1Eq0vWfU3XGBmiVKXv94ON758Bc9DHpbVUuphXjcH?=
 =?us-ascii?Q?qIaCxvvMcgIELn7ixhs/lbEZTupO/5peo2VESdlWXc0fnXAC3kRJi+SskhxV?=
 =?us-ascii?Q?92zFVz6d6oeq8+78qJnEPdjSYHWdpDfQh0WLZoqb9EkFQB8j24hunZAquLCA?=
 =?us-ascii?Q?R5ftbrmJRNyVJJY9w2/NEkNIvSNfsmW9Hqkoa74st79mfFdfVoVw7vpiGQng?=
 =?us-ascii?Q?DszimltJaNm7Tzp/iAfoiyfxujZmevg7Fn6kg7ZXAcg3DIAuCS8T4nwhGRwT?=
 =?us-ascii?Q?h+PemiYtf6JKl3rWC10iizXdn2lZnP74JZ0KPirnjoPNrGi2WL8QmH7VBgNE?=
 =?us-ascii?Q?Kk4EIZvMjAe2ufOUokAgPt45AO5LDp94OBk0x20o7+Lt0RW/qYTAGr+mS8aI?=
 =?us-ascii?Q?QaqJPvmAhqxzLDiLUIq/InjUQ6uXOuKucGQuQUtzre0EdWWYaSgVham1IsHN?=
 =?us-ascii?Q?eGbz+ns6hgNkFJj16AtzKN/dUHLMbRXGsaAnnWkUJ/Y9EHUDrb1lyumt6hbJ?=
 =?us-ascii?Q?ibTzvCtIdyNJcMVH0jvgnc6DllHnrZnqIWWSgLJYckUQ1pBO7pj3D6r9s86r?=
 =?us-ascii?Q?Hul/nVV857l2QROFZVMN2tafyNU2PXF5unokk/VQCuLms9lLI5riLb+zeamD?=
 =?us-ascii?Q?0fceW/ABuIFJqABD/Xc1xI/Qs+zMhuWerx5g2/n6qNCzkA1C6OJHgqdHGW9f?=
 =?us-ascii?Q?Kq76qXVAMeaajtbvrUB7WBTqpZEPbV84VJue2fhTP1QS5OquZxANPaC9DiMu?=
 =?us-ascii?Q?9Mx6OD0mfnwbrcySosSU5JQUIqDxUFdxpZNGNPHw1QcklHNbebcpJiPHXwkT?=
 =?us-ascii?Q?dFcIFeRy8mpvbcCRbP1zuZJMhuLmq+/0c8vU1s0PB3g8SBwirCnxPkhelh0d?=
 =?us-ascii?Q?3Lji0bXnAEMH9RlPDbAammZOBuMQg9tPgDWzfKSIFkzNzC2HBfiUBg0hpc11?=
 =?us-ascii?Q?R/fDz9Pq1FDjT9J5kXmP6ueTmG+gqwdihV2D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR10MB8229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(7142099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ggjz13sVSZethCaih+ZjUzIKlo5KlZM1IXX57MxOGed1JyIMa44OL38CUU7/?=
 =?us-ascii?Q?ZKAeNtSpignhY5P4apbJunf1UzZp2Ayf7Jh1W7pNYgJX6LetUUHbXtar2KJS?=
 =?us-ascii?Q?8wSu/IWByAfxMOem0ZJnLfYOzRbVLj/cY455Ru84ciYy+WFhjtFjDEMGUvBn?=
 =?us-ascii?Q?grdkLhp8rvqWnD/BGKh6P/68/CrHMHFZcPhDrVuV1/yAVTTc6gs7cv0BF7MB?=
 =?us-ascii?Q?ftFqLRtH1x13OjrAzhDFIVgABVbaH9SYNcRuo+9kh/eUGwkAIuHSa5tLEh1b?=
 =?us-ascii?Q?+phCMDfW+o1wBynmbJ3OsbYT4lgS+wH8Qn9YtH/mEPmj7y9toF0MJthsSemQ?=
 =?us-ascii?Q?VVP20RPCNAUBGr61/hbnNVXdRvvYZzBHL3cm5SEVN8KTz1iQ5/1BLHNF2pQ+?=
 =?us-ascii?Q?Re3URMt0qCAY0/GXs3gJIqr8jqQ5YaqXvBurw7B0ZsPqXq0XpcT4X28txAtw?=
 =?us-ascii?Q?ECGphcPWrnobRwJr3Y1tBRUnUI9drSxd8AncfmZ/UDAlu91h8PdKxpUVfrkX?=
 =?us-ascii?Q?4NveZPGHWHJgs6L44Tb91sZ889b9T85ZDMFt6MxTifULL2FNRWdSpo26Ljdd?=
 =?us-ascii?Q?QIHDtjNo+lOmJHBRnXECU5N9PJQfCXMuw8Z4zMkVroYkIFubKS5hEWy6b0ou?=
 =?us-ascii?Q?wK/1OO+FkTNqM2cD9ptZHKLLWCg4UUgYbbdCH858pEuoEsnO4R+h3C3Ti/pI?=
 =?us-ascii?Q?6Lw4aVqSmYyC8MeKArBH0GZ+MTbxSBFKs+x0dXMFvtg9x5Z8CUEqJlMEf4kL?=
 =?us-ascii?Q?3H8ijDzFU9Cqawv81bYjddCybxRnfR4tfyKP+RJ6WbRB7uYUmvTvFPiBFeoP?=
 =?us-ascii?Q?NhgXrDA2Va2yRMCN1YoJYZvXjRqb2cEqEXb72fNP70riH4nsKTqoOYQgHt3U?=
 =?us-ascii?Q?2I+t2ItaiSL5ceFqNdFsDs+vTIjjUsX91TPS8PKY4AWy/vhUuZ2O4MXyHbPd?=
 =?us-ascii?Q?OcmnUa7rBDVYxlYprS5PDWhzhIsKOlMpXw3SsRZrXz4obkv0dhyIT4xxWFKS?=
 =?us-ascii?Q?8swbrL1s+B2Q5hr7eMb1DyuXWwkgcnKDHggxxUCv8tSDPL1aZmiO8C/WOGG3?=
 =?us-ascii?Q?IejOwP05BeFGhrsUg4pWemRLkVBeYhh4+vC2E7wczDAOgh3Lslo13eh9MP8R?=
 =?us-ascii?Q?59DrhAQOlvtP2ehFye8PpCGxQJja7Va9zib/EW3apVA0yst0bFU4QyVHAGip?=
 =?us-ascii?Q?ivWPj9xYxrdnjlPetXwmTSqy4612OKEx/FUy70ALm4bg7NdQWrSreU1DVnbo?=
 =?us-ascii?Q?EqDH4EKy2j1cDSKL5oWOuVj6zUZR5td5gMEM8gzZUMVDQZl+J0DWhvpuixTy?=
 =?us-ascii?Q?CwkVHk3c55d0iFAV4k3phVVVA+am2E1c8yhIIl5OVR+KpvfxGBb3nfDXZKGE?=
 =?us-ascii?Q?y/hL2pHthbOMKJ4OZmh3p0qzR18/N+KCrvuwTAwTOUXURli3HsurTFnPMbOj?=
 =?us-ascii?Q?jMM7vqVrPyE2zwJsYGWQ6MeMik9FCtRixZ25p4VJgjvz3NM6IeX3BvWnxa2S?=
 =?us-ascii?Q?LqWqQVyhqqVbkoeJ2Def5e/XjInauXMwaEO1ozYeJM2S8hiULxEcfqoMFYBo?=
 =?us-ascii?Q?AumS9wVIqnG4yUTp9TeR2UopejqssJq9GOoCdyXq4OK5se77ygMiTXynzu44?=
 =?us-ascii?Q?KPdtxS2l5epx/JdGu216jMmRdQ6CWwYY8ONo9x5VB7+p1C03PRcjALmDjX1g?=
 =?us-ascii?Q?uVCQzXi5el8pMlWWq4c7fCMEdtNNce4zmKC9tgHpDSrNOuAT12NM4xYVwmR2?=
 =?us-ascii?Q?9JK5LllhDpq5VB70JwZDXD6prHViQYA=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	AvS6b0LpwrB0p5naNzsWYjkXgpZpyyTIm0YaD0RggSd2b1cPanJ5a4a/JZ0VilgO/1xiYmWFHDupysjmlzANsWSC9ohyLum4WTwwSTf2ORsdnb4azqaO+oxH1Cz2c/IYhX1uED/T+2SsIyUFCGGnFByQ9lfa0vUoUQel9Uii3OMEIr3Q+tJecB08EZzJJ7zgyJJ2pXENeXprMw61lZFRIpoelk+JknLPdjD0tscuZ/iUFPSWPE1UoR59jOo9DLav6wSUSTY4jAXuDiEcf6mzHKzh4ytNfIcFSw2r1hhnpqiQYSUHho1y83jtZjDH56Z1dVAsFxS3TtcIvl9nuirbH6ZbOGVo4XJupIsADEyqu62lLueBy7VvPGXItTSds2bRgFj9lR1dsqSUt1EHNGvTNJPg7lPw1LazIop471V+cZw1PkE/yEcP+0YS+ocq3lTgcAXij8TreAw9RiShs+Gla6LGLOpP0jDYmEBF2iEHKhXK0db/R9TNJaK2vgo1b4uUujGaeKarLLNJCs8SAoWuUkPXVfaUVMlw7aJPuCZ4HmMFHx180Q4jLtH0gWNPLLOz1MmOBotWa/rTBjgTsnqu8DVtjplSvOrvQOuOSqvw/s8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 20f9dc12-3ca0-4c67-eb3c-08de5507f5f7
X-MS-Exchange-CrossTenant-AuthSource: BL4PR10MB8229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jan 2026 14:03:01.4750
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BbM6bjveooVFov/dMM9Mj2rIAeH7h+RaoV1Lup5Ak3odSelSrbF0PsWG5LDf1BF30kxMBLifibjXnyufe5VNQW/604m8Y6cT+xevf4VC+kc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR10MB5985
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-16_05,2026-01-15_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 suspectscore=0
 mlxlogscore=999 bulkscore=0 malwarescore=0 phishscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2601160098
X-Authority-Analysis: v=2.4 cv=OJUqHCaB c=1 sm=1 tr=0 ts=696a451a b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=-ibLmwfWAAAA:8 a=Oh2cFVv5AAAA:8
 a=hSkVLCK3AAAA:8 a=4RBUngkUAAAA:8 a=ZO2UzhHidKYDF09PdiMA:9 a=CjuIK1q_8ugA:10
 a=A6MkUVyZPcTV1i89ro0M:22 a=7KeoIwV6GZqOttXkcoxL:22 a=cQPPKAXgyycSBL8etih5:22
 a=_sbA2Q-Kp09kWB8D3iXc:22
X-Proofpoint-ORIG-GUID: wexcxG7-iACWUGb6TghL097OMGAcZlWa
X-Proofpoint-GUID: wexcxG7-iACWUGb6TghL097OMGAcZlWa
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE2MDA5OCBTYWx0ZWRfXx2YuAsAM9WNy
 Tui9qIKkpxlguDf/Loh3+CSNPDgS5QVAqoLxJlQ32VCpKSy+2+7ah4/Vxab9Kc6/wsWUoXHUIKQ
 AUpxvVkoKF0U4CORepU9DLCqtW7P5MAdcFGWWmF+Ueiz9FXhq1AQLE1IHvVl8Aq1S6w80K6H7hd
 jV4e5eHMkOsnq1YVyCYAFSwir3EWci+iC9Vk58nb9QzHQ9nPmN0jYpM4ieBzGrAM34KOG2l1xTv
 afNOGBAs4Ut3IY4R/Pxt7kAAMbnJebQUqXwlJeg+7WkRxvyHdZiabWItcG2LPmiMGTEfLIYgCdJ
 LXQjfrsECdHhkFh+s923wEoA5Y/tsUhWajtk2tvOzvaSFFqfZPGuEuChvW0qvc+Q6dZIvLY7MYO
 lchmi6vDlZL2uMYwQmDYTaUu2APft+6qLTS//Ck4WE53Exx5ERSbDvirRyctTMs8GpdJvaC74VS
 4+LmU5hGE9rCSHWDuKQ==

Please ignore, this whole series has been resent at [0].

Cheers, Lorenzo

[0]: https://lore.kernel.org/linux-mm/cover.1768569863.git.lorenzo.stoakes@oracle.com/

On Fri, Jan 16, 2026 at 05:51:01AM -0800, syzbot ci wrote:
> syzbot ci has tested the following series
>
> [v1] add and use vma_assert_stabilised() helper
> https://lore.kernel.org/all/cover.1768558900.git.lorenzo.stoakes@oracle.com
> * [PATCH 1/2] mm/vma: add vma_is_*_locked() helpers
> * [PATCH 2/2] mm: add + use vma_is_stabilised(), vma_assert_stabilised() helpers
>
> and found the following issue:
> kernel BUG in anon_vma_name
>
> Full report is available here:
> https://ci.syzbot.org/series/a3867085-bae4-4416-9704-3b23ef9c6006
>
> ***
>
> kernel BUG in anon_vma_name
>
> tree:      mm-new
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/mm.git
> base:      eeb33083cc4749bdb61582eaeb5c200702607703
> arch:      amd64
> compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
> config:    https://ci.syzbot.org/builds/2e5b4d7e-a1a9-48c8-ae3b-654d3ac32e5c/config
>
> Loaded X.509 cert 'Build time autogenerated kernel key: 65176d093d4baf94ab1e788ee9f46804766f83ba'
> ima: Allocated hash algorithm: sha256
> ima: No architecture policies found
> evm: Initialising EVM extended attributes:
> evm: security.selinux (disabled)
> evm: security.SMACK64 (disabled)
> evm: security.SMACK64EXEC (disabled)
> evm: security.SMACK64TRANSMUTE (disabled)
> evm: security.SMACK64MMAP (disabled)
> evm: security.apparmor
> evm: security.ima
> evm: security.capability
> evm: HMAC attrs: 0x1
> PM:   Magic number: 10:472:582
> tty ptyc0: hash matches
> netconsole: network logging started
> gtp: GTP module loaded (pdp ctx size 128 bytes)
> rdma_rxe: loaded
> cfg80211: Loading compiled-in X.509 certificates for regulatory database
> Loaded X.509 cert 'sforshee: 00b28ddf47aef9cea7'
> Loaded X.509 cert 'wens: 61c038651aabdcf94bd0ac7ff06c7248db18c600'
> clk: Disabling unused clocks
> ALSA device list:
>   #0: Dummy 1
>   #1: Loopback 1
>   #2: Virtual MIDI Card 1
> check access for rdinit=/init failed: -2, ignoring
> md: Waiting for all devices to be available before autodetect
> md: If you don't use raid, use raid=noautodetect
> md: Autodetecting RAID arrays.
> md: autorun ...
> md: ... autorun DONE.
> EXT4-fs (sda1): mounted filesystem b4773fba-1738-4da0-8a90-0fe043d0a496 ro with ordered data mode. Quota mode: none.
> VFS: Mounted root (ext4 filesystem) readonly on device 8:1.
> devtmpfs: mounted
> Freeing unused kernel image (initmem) memory: 26044K
> Write protecting the kernel read-only data: 212992k
> Freeing unused kernel image (text/rodata gap) memory: 388K
> Freeing unused kernel image (rodata/data gap) memory: 1776K
> x86/mm: Checked W+X mappings: passed, no W+X pages found.
> x86/mm: Checking user space page tables
> x86/mm: Checked W+X mappings: passed, no W+X pages found.
> Failed to set sysctl parameter 'max_rcu_stall_to_panic=1': parameter not found
> Run /sbin/init as init process
> vma ffff888175272d80 start 00007fffffffe000 end 00007ffffffff000 mm ffff888100079880
> prot 8000000000000025 anon_vma ffff888110bf8000 vm_ops 0000000000000000
> pgoff 7fffffffe file 0000000000000000 private_data 0000000000000000
> refcnt 1
> flags: 0x8118173(read|write|mayread|maywrite|mayexec|growsdown|seqread|randread|account|softdirty)
> ------------[ cut here ]------------
> kernel BUG at ./include/linux/mmap_lock.h:476!
> Oops: invalid opcode: 0000 [#1] SMP KASAN PTI
> CPU: 0 UID: 0 PID: 1 Comm: init Not tainted syzkaller #0 PREEMPT(full)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
> RIP: 0010:anon_vma_name+0x253/0x260
> Code: ff 4c 89 ff e8 8e 7d 0a 00 e9 e9 fe ff ff e8 34 db a2 ff eb 0c e8 2d db a2 ff eb 05 e8 26 db a2 ff 48 89 df e8 6e 77 08 ff 90 <0f> 0b 66 66 2e 0f 1f 84 00 00 00 00 00 90 90 90 90 90 90 90 90 90
> RSP: 0000:ffffc90000067550 EFLAGS: 00010286
> RAX: 000000000000014c RBX: ffff888175272d80 RCX: 37717524f4bb9000
> RDX: 0000000000000000 RSI: 0000000080000000 RDI: 0000000000000000
> RBP: 0000000000000003 R08: 0000000000000003 R09: 0000000000000004
> R10: dffffc0000000000 R11: fffffbfff1c3ae40 R12: dffffc0000000000
> R13: dffffc0000000000 R14: 0000000000000001 R15: 0000000000000001
> FS:  0000000000000000(0000) GS:ffff88818e405000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: ffff88823ffff000 CR3: 0000000110c5a000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  vma_modify_flags+0x203/0x330
>  mprotect_fixup+0x46a/0xa50
>  setup_arg_pages+0x565/0xae0
>  load_elf_binary+0xc5e/0x2980
>  bprm_execve+0x93d/0x1410
>  kernel_execve+0x8ef/0x9e0
>  try_to_run_init_process+0x13/0x60
>  kernel_init+0xad/0x1d0
>  ret_from_fork+0x51b/0xa40
>  ret_from_fork_asm+0x1a/0x30
>  </TASK>
> Modules linked in:
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:anon_vma_name+0x253/0x260
> Code: ff 4c 89 ff e8 8e 7d 0a 00 e9 e9 fe ff ff e8 34 db a2 ff eb 0c e8 2d db a2 ff eb 05 e8 26 db a2 ff 48 89 df e8 6e 77 08 ff 90 <0f> 0b 66 66 2e 0f 1f 84 00 00 00 00 00 90 90 90 90 90 90 90 90 90
> RSP: 0000:ffffc90000067550 EFLAGS: 00010286
> RAX: 000000000000014c RBX: ffff888175272d80 RCX: 37717524f4bb9000
> RDX: 0000000000000000 RSI: 0000000080000000 RDI: 0000000000000000
> RBP: 0000000000000003 R08: 0000000000000003 R09: 0000000000000004
> R10: dffffc0000000000 R11: fffffbfff1c3ae40 R12: dffffc0000000000
> R13: dffffc0000000000 R14: 0000000000000001 R15: 0000000000000001
> FS:  0000000000000000(0000) GS:ffff88818e405000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: ffff88823ffff000 CR3: 0000000110c5a000 CR4: 00000000000006f0
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
