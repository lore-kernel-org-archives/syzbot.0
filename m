Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEB2B2641C6
	for <syzbot@lists.linux.dev>; Wed, 19 Aug 2026 02:27:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787106445; cv=fail; b=ku9wVpLxFtvwB8D5v6/T+QmUzjMISSPiSZrFyjTXldQBvSqkHvnk2cTpNlS66v+IrdvchdCwYO4G6bcM9rvAeocoD1Z5I5b+3W2mHowEVv+KzZAjt77Cc8/8ZWiUK1akxOGTpxjqDR+FnD4cnYKYxl+JXZtyueJr6Nc6rt11nHs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787106445; c=relaxed/simple;
	bh=yXTryB4SMUITnTYHRarJvbuqwVi/lLICMe6IZcpBph8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=kl42RTcRBp09bmwcItx3IU+26ChGdfm2mohFunIibLn3F+aMdQEe+a2Zwq05pOGf9+Epnh/tGOgvwgo87/u3QZDN/CLi4rgEvAjpTvDeQUiWorzoIHKpdlIdtHgEe/vt11PJuuXkYI9VOZFX7R4qU4G5JujRz+k/5YkEY+OBNX0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CG+BCIHc; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CG+BCIHc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1787106443; x=1818642443;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=yXTryB4SMUITnTYHRarJvbuqwVi/lLICMe6IZcpBph8=;
  b=CG+BCIHcYOS4Lb6aAHHGyE+VEf/HSevRjDOI9peA4+uZWfNv6H2FqobS
   CjHVQXrtOFjTRSdCYxOg68WVjCmtF7utQIiozFsXuGjjHCHw6W0dFMlBn
   rpRdVaQGatHEko3bag7SklVb2frakRdEriNaHoa+QSLNNEGh09cY/8QrM
   LVJwpvvSCQHDHFmEtAzMPc8oLLv/KYX8KjgcQVi3s8RmuCOJWMPTB1u7u
   Os/4mnQadFUzR62QsKJh/wGeVrYjUAiUpbHQQJhudo/eUlEX/wJ6LHD3x
   JA7q2VTxXmZ9jdb5ANYEv2akfcagElADZ6TazaPJahX28UY3+zq/e6OHn
   Q==;
X-CSE-ConnectionGUID: 5m+THCEyQFqY2icvHOXorg==
X-CSE-MsgGUID: AnD49jqLSFGENLSgFZ4cFQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11879"; a="91482339"
X-IronPort-AV: E=Sophos;i="6.25,230,1779174000"; 
   d="scan'208";a="91482339"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2026 19:27:22 -0700
X-CSE-ConnectionGUID: 0X/S7+5URH+FyHT5d2hmeQ==
X-CSE-MsgGUID: Jdk2sMpgR1+WXZkzuQT9pw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,230,1779174000"; 
   d="scan'208";a="261651951"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2026 19:27:21 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Tue, 18 Aug 2026 19:27:20 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45 via Frontend Transport; Tue, 18 Aug 2026 19:27:20 -0700
Received: from CY3PR05CU001.outbound.protection.outlook.com (40.93.201.58) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Tue, 18 Aug 2026 19:27:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UtLoz7LwxuKJrLoErCleWD8XzzG6mHLrr/ftCreLeWjLizJrL1D+cOnCPk77vfPODJdbTHgJZkyGJzquqFo6AuKZ8dyR6jio1qTGsSuqdCs0+dE9Wre1kpASx2LmnwBaK7UcMod2plkq11fGqRyVuTkHQ7snKL4V4pU9Q7wOCsCqCXWhd04AemwOlJDJL6mEnqiEBhrlx6usFzHpe8UgeDykitNY0l1GZPXOmDc7vycjqKtPWZslwWaJ83wKmqnRL6A0aA/0el6Rqx4Puh/+5OWFIj17jFNgQZ4ROiZ1zyMn8iRAIcEyWX2Hbg1FwVZQuZVl2o+d/UFE52X+YMHZIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yXTryB4SMUITnTYHRarJvbuqwVi/lLICMe6IZcpBph8=;
 b=pV0adp+J8YQ5Mj7QRIZNZZGSWwQwH4oh7glVYJ5xACc+jLcrhAt1CV46jUbLgDc+7ClVNrIQ+5p79h6tsI1mrQHIzqiUMMrJgJf1a+b0pTz7re2MxSZOk1JRLiaW7PixKNVb4uWlCmdFVxqYKuvtVuSDfhvr0GOgJUJFHp0I1XXxH+n4hpdYulnEyutDexFYrIhTduMrMwLJIq6EaNYfFR12P//ugoh/IrD/6lbhQrI8u7y6cELkPk9KNkbu6dWuw+h5HDjTmUhjQ+x6j63S1cmaOqy6sj0cnbkYvMwHeRhW8JtAA0Fe3E+O91Owucx+oAKfiWbvZnvZBV3y89tk3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB6448.namprd11.prod.outlook.com (2603:10b6:8:c3::21) by
 PH0PR11MB5047.namprd11.prod.outlook.com (2603:10b6:510:3c::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.339.8; Wed, 19 Aug 2026 02:27:18 +0000
Received: from DS0PR11MB6448.namprd11.prod.outlook.com
 ([fe80::2346:c494:79d:931]) by DS0PR11MB6448.namprd11.prod.outlook.com
 ([fe80::2346:c494:79d:931%4]) with mapi id 15.21.0339.007; Wed, 19 Aug 2026
 02:27:17 +0000
From: "Wang, Jie" <jie.wang@intel.com>
To: syzbot <syzbot@kernel.org>,
	"syzkaller-upstream-moderation@googlegroups.com"
	<syzkaller-upstream-moderation@googlegroups.com>
CC: "syzbot@lists.linux.dev" <syzbot@lists.linux.dev>
Subject: RE: [PATCH RFC v2] usb: atm: cxacru: fix NULL pointer dereference on
 uninitialized atm_dev
Thread-Topic: [PATCH RFC v2] usb: atm: cxacru: fix NULL pointer dereference on
 uninitialized atm_dev
Thread-Index: AQHdLttIrtx7YKuzVkKT01Eaw8jSE7akpkxQ
Date: Wed, 19 Aug 2026 02:27:17 +0000
Message-ID: <DS0PR11MB64485F854D12FF987BF26B0A98A52@DS0PR11MB6448.namprd11.prod.outlook.com>
References: <e51f4b84-d7ff-4c7c-9e97-019886b0c8ef@mail.kernel.org>
In-Reply-To: <e51f4b84-d7ff-4c7c-9e97-019886b0c8ef@mail.kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB6448:EE_|PH0PR11MB5047:EE_
x-ms-office365-filtering-correlation-id: 33f46065-3de8-42ad-308e-08defd9963c7
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|23010399003|376014|56012099006|10067099003|6133799003|18002099003|22082099003|11063799006|5023799004|38070700021;
x-microsoft-antispam-message-info: Q1RqIFaWWLcOdWtDCDj7PNjtf2jL9yYXt8QPx+GLWO7NOi+hx20eX+dU8sM2Q5Oi03oKoJah/Lqdjl3Tm/YKxvGSslaYqsDUvtsRRUL4TW+8EoY8FBAakf6QZyT+KpPsxdnzsdtMlIY6XG2GITNJVg99la9qZmGsr+ZU5E3gmxEvizQYf9Q3IkTUtADpYBLNi0NhLrrrQdkKEx+zjlUFTdau6JuHKiilZAHAo1IHCVVh/ynUy+vRBFNE3bCxh2RVDfrQp9vqN5UkRsxiTGOFAPXGx+ZOkMuhq0UfcvXU0+LyWWQbv83EofQ/E3RWAVEkuecyMVfAfh83QMcf9G6Ttl6VVPdVc/t5qwGsZ3k3+jnnweSIMNfCsYl08yzwKwcrD1YoNGdEWMSRAQbiVTu8tIZIGS3mH4UKFXl4nQK2kp+yur0fM7dNTOsCbLe9yfVlgSdOlQaTv6kqaRfc0h8pm4PX4PWbi5ZBPvAliyjz75ACNoGDvdLl17qYxMA3TzK9GL18AqvG91fowWK/cB9DB1jAykudR26jSNCWpmqnuxRUkqrz2DCWsMj0NCZ4wcnYIBwEaqgOC1jRz1x/eITDm22fE18jh89pHRxCcxoro7c6w6rfy+wX8XHPyDIU17CvwQVbfjyFUWoIsVBT9dlFZaphGWGiq3DPfa9AXrPENXE=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB6448.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(23010399003)(376014)(56012099006)(10067099003)(6133799003)(18002099003)(22082099003)(11063799006)(5023799004)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Q0Ixa0NLeXpuK2lZVHE5SkRuODdMWXdIYkNuNkdoRjR1MldJNm13MDEzeldM?=
 =?utf-8?B?MUZTTlFDWFI5ZGR6QU54YzFWZXBwSDJCdUNzVDVzamxLSEtXUmVDVERNMnJh?=
 =?utf-8?B?dlZQV1FCQzI3YytxTmZWTlB4YmNWdTRYUUVDNFlzNExsWHRFa0JBTUhDellt?=
 =?utf-8?B?MDM4a2hhUUxKb055NmY3ajJncjBuRitCcW9TMTZ3SWZZbHh2bUFUS3U4N3B2?=
 =?utf-8?B?Q1RydXZZbHlCSUtUb0h1K1piLzRRRnU2TWFZSGdjay9UUWZvL1ZIc0dnVjVW?=
 =?utf-8?B?SWlucWNKdktFVy9BVGhIaE9YUklaQjQzWXluYzNHa3lVOVF0blQ4SjJJYnFC?=
 =?utf-8?B?aHE5YjI0TG54djBaYmROOXZVUldXMElWdFY2YUpkeHBjOVA0NmN1b3FtT0pC?=
 =?utf-8?B?eUJjQkU2RDhBTEh3ZkpyUk1JYXR4MlRRMkZwd2pDa043eGNwRWZ2NXkxYjBJ?=
 =?utf-8?B?bExQUGVvcE9ISGlKVDVyNUFoOWtIU2pURVIxVE56dHdSeDZWZzUyckJ4UEtE?=
 =?utf-8?B?RysrQkJMQnNYS3BLelkyb1J6V1JtYXZtU2d1WWxZNDhyZVViTzRVM0hMSnV1?=
 =?utf-8?B?NEliblN3QzRpUm9LRVJ2eURRUE1XUkRSZG1OeVNyc3EyL3dReVowYmZFSVJ1?=
 =?utf-8?B?UXRVY2hiQWEybmpKbkp5MWFSVlZJR0Q3aWsxekhubzdrdlhjM1YyalQyclEw?=
 =?utf-8?B?R3MzZ29NbXltWlJkSFN4dTNKcnlrNTJOQWRsdk1GVG5vbE5mTTNMb3VLNjQw?=
 =?utf-8?B?Q0Q0TEpDT1BXcHlKaWM1eEVKalRJZDhkVnVaNEJpMlNkNzk1eWNnelV2Uy8v?=
 =?utf-8?B?N3d6WjU0Zk4yK2pVMWp6SFhGamc1My9yYU5BWUk1aG9mR29NLzZGbHFXUUdr?=
 =?utf-8?B?SzRZWC9VUDMwdkJKS0s1UVYvUkNudDFCenFLM3Y2OUpHVFpIWEJqa0FlRy9r?=
 =?utf-8?B?NTlDMGN6WnMzSm0xYTlkbEpMNmZGZW9OTytMaURqUmJNTlVzV0ZyTi9DWGpn?=
 =?utf-8?B?dUFidGQ0S1lxTWJUQXJFSnlrdWFpUmQ2VHJUbTlLRFViUjVCdnRXV2VuR0Jr?=
 =?utf-8?B?eUwzYlBwUTRmVEZxUDc1cFR2YUYxdHlsaWp3VWMvY3ErbWo4SFZwTCttSWNP?=
 =?utf-8?B?ZXhJMTlNam1NWWNjQVZWcUpYRlRIYjltZG1GL1dhUEpqL2doWm5CUHlubnFy?=
 =?utf-8?B?dWFIdjIrSTRQVVk0MjJYcG1pZFpkQVYyTkVCTzR5RjVFZCs5eSs1Rjl1MHQz?=
 =?utf-8?B?MTNoc2cxNVhVKyt5ckF5M0szVW5PdXMyclZ6b3g3RXJUNERZWDN1TFpLMEF0?=
 =?utf-8?B?alFsbDFxd0tTditwNkxnV21JUlJHbkUyQXpRZ0FsdkJCcjlIczlyTG5LNzgv?=
 =?utf-8?B?cVhKODk0bHVsZklsMDhKWXlsOUNyMmZCcE1lTzVza3U3RXJTajNsTHlEL3Rr?=
 =?utf-8?B?VjcwWEhTcXZNSkxZY3kvR1Z5TGRlSlZOR1h6MWh6MkV2bk5GNEZhbVlmMEs1?=
 =?utf-8?B?VXpYQ2doSmpwTVN5aDI4czZFUSswQzZFdWVUbUVmUkxzbEhHUnpRZHNOc0Ri?=
 =?utf-8?B?VjR4a0JEVTBBVEo0V2xmWmFUREdlUkg0SzB4YVhLQkhyelFnV1lGYkZmbjNR?=
 =?utf-8?B?WXdtNGh1azB6d1FQckdYbnI5MWtjNFl0Qzh2MUQzeENXc1hmb1pWT0xHWFd4?=
 =?utf-8?B?NEo1dE1xZ3FZY0d6UVMyVU1TcnpWak9ZRGZtd1Iva0Z3Z3NWSElvY2k2akFz?=
 =?utf-8?B?RWxRdUdLZjcwbG9hUlZEY0ZaYmgwZFdYL0hKSFMvcUlIV3lrZ0FMZDNmSnN3?=
 =?utf-8?B?cUFEM1VSSDliMGduQ3Nyb1g3dVdnTzNqemgvdWFaeS9URTFZbEQxTHhLREhy?=
 =?utf-8?B?RmxFcTdhN1hNbXV1bmx4ckdqQ21kWFlyLzBPUmtMUk1TYTVKYkRtSk1venVs?=
 =?utf-8?B?QUMvMzVlL3dyOWx4MzgwQ2I3RitaSU0yTlRudTl4bU9GYXVNUk9QK0F1d0lC?=
 =?utf-8?B?ekJydVNYZ29TTXFnSDZDSW80RnRLWm5xZVMveElmV1NBNXYxWk03SUJDalE3?=
 =?utf-8?B?NWltdXk0QVBONG95Q1I0UjlpY2IrZEhDT1VKTWFPVFpnRlRraHZkOWVwMmlB?=
 =?utf-8?B?WTNPSTFMcVFPZWRJaWNYd1o1Y0UrZ29tSzJwTG90T21Uck9OUEp4dStKZmxy?=
 =?utf-8?B?aldOTCsrSmRtWFRBTzNwS3I4Zlp0Tlo1SkZaeTR2NUN6YTBoWlJwMnA5U3ZS?=
 =?utf-8?B?OE96Vkl4ZHByRXJwYUQ0NURQYkRVUEtCbjdyWlJHS2E3Zmx5UVplbHZ5d21Z?=
 =?utf-8?Q?l5z4VE0mozT3FzVybk?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: foYGC07lWALebONlWuVuvf1g/mN2ou6Z+iRDvult+ZftAaHHTdI5Ymj315l7QUtqGFBi9vhXhUQF9uf4hV/x+PrEDr5wans6kHkADkd6Oq78VS5ksG4pNgSb9loWkwszzrYYK6VS5fycozGUT1C3ZCXtgx5EiTJtJu5wB6c/472Zc2M5AQh06oicpiLw439DQ5iBfvqo3am8iFQh5KTdO4LjRsQFxAj67Zweq0YYaQpSb3ddAkGnIEnPaLkWwAd+R+qDKh72JeMDp/2fuS20Xfjm/lTEYF1I7QAoJlEvbqtQ882ePdV/nNj6WiLAXQO/Cuhg8Pifk0Hota1T69oJYg==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB6448.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 33f46065-3de8-42ad-308e-08defd9963c7
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Aug 2026 02:27:17.8743
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ivXBSPHqfaYwQW3b9AdqF3NCzt2LlsFHpkm48cCm8h9s9SqhPYzmi50YuCbsXkimYIyyBQ4tt8S8mZvxwpPF8w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5047
X-OriginatorOrg: intel.com

I3N5eiB1cHN0cmVhbQ0KDQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IHN5
emJvdCA8c3l6Ym90QGtlcm5lbC5vcmc+DQo+IFNlbnQ6IFR1ZXNkYXksIEF1Z3VzdCAxOCwgMjAy
NiAyOjMyIFBNDQo+IFRvOiBzeXprYWxsZXItdXBzdHJlYW0tbW9kZXJhdGlvbkBnb29nbGVncm91
cHMuY29tDQo+IENjOiBXYW5nLCBKaWUgPGppZS53YW5nQGludGVsLmNvbT47IHN5emJvdEBsaXN0
cy5saW51eC5kZXYNCj4gU3ViamVjdDogW1BBVENIIFJGQyB2Ml0gdXNiOiBhdG06IGN4YWNydTog
Zml4IE5VTEwgcG9pbnRlciBkZXJlZmVyZW5jZSBvbg0KPiB1bmluaXRpYWxpemVkIGF0bV9kZXYN
Cj4gDQo+IFRoZSBjeGFjcnUgZHJpdmVyIHVzZXMgdGhlIHVzYmF0bSBmcmFtZXdvcmssIHdoaWNo
IGRlZmVycyB0aGUgQVRNIGRldmljZQ0KPiByZWdpc3RyYXRpb24gdG8gYSBrZXJuZWwgdGhyZWFk
ICh1c2JhdG1fZG9faGVhdnlfaW5pdCgpKSBidXQgaW1tZWRpYXRlbHkgcmV0dXJucw0KPiBzdWNj
ZXNzIGZyb20gdGhlIFVTQiBwcm9iZS4gQmVjYXVzZSB0aGUgcHJvYmUgcmV0dXJucyBzdWNjZXNz
LCB0aGUgZHJpdmVyIGNvcmUNCj4gY3JlYXRlcyBzeXNmcyBhdHRyaWJ1dGUgZmlsZXMgKGxpa2Ug
YWRzbF9zdGF0ZSBhbmQgYWRzbF9jb25maWcpLCBtYWtpbmcgdGhlbQ0KPiBhY2Nlc3NpYmxlIHRv
IHVzZXJzcGFjZSBiZWZvcmUgdGhlIEFUTSBkZXZpY2UgaXMgZnVsbHkgaW5pdGlhbGl6ZWQuDQo+
IA0KPiBJZiBhIHVzZXIgd3JpdGVzIHRvIHRoZXNlIHN5c2ZzIGZpbGVzIGJlZm9yZSB0aGUgaW5p
dGlhbGl6YXRpb24gaXMgY29tcGxldGUgb3IgaWYgaXQgZmFpbHMsDQo+IHRoZSBkcml2ZXIgYXR0
ZW1wdHMgdG8gc2VuZCBhIGNvbW1hbmQgdG8gdGhlIGRldmljZS4gSWYgdGhlIGNvbW1hbmQgZmFp
bHMsIHRoZQ0KPiBlcnJvciBoYW5kbGluZyBwYXRoIGNhbGxzIGF0bV9lcnIoKSwgd2hpY2ggdW5j
b25kaXRpb25hbGx5IGRlcmVmZXJlbmNlcyBpbnN0YW5jZS0NCj4gPnVzYmF0bS0+YXRtX2Rldi4g
U2luY2UgYXRtX2RldiBpcyBOVUxMLCB0aGlzIGxlYWRzIHRvIGEgTlVMTCBwb2ludGVyDQo+IGRl
cmVmZXJlbmNlOg0KPiANCj4gT29wczogZ2VuZXJhbCBwcm90ZWN0aW9uIGZhdWx0LCBwcm9iYWJs
eSBmb3Igbm9uLWNhbm9uaWNhbCBhZGRyZXNzDQo+IDB4ZGZmZmZjMDAwMDAwMDAwMjogMDAwMCBb
IzFdIFNNUCBLQVNBTiBOT1BUSQ0KPiBLQVNBTjogbnVsbC1wdHItZGVyZWYgaW4gcmFuZ2UgWzB4
MDAwMDAwMDAwMDAwMDAxMC0weDAwMDAwMDAwMDAwMDAwMTddDQo+IFJJUDogMDAxMDphZHNsX3N0
YXRlX3N0b3JlKzB4NWNjLzB4NzcwIGRyaXZlcnMvdXNiL2F0bS9jeGFjcnUuYzozNTkgQ2FsbA0K
PiBUcmFjZToNCj4gIDxUQVNLPg0KPiAga2VybmZzX2ZvcF93cml0ZV9pdGVyKzB4M2E0LzB4NTQw
IGZzL2tlcm5mcy9maWxlLmM6MzQ1ICBuZXdfc3luY193cml0ZQ0KPiBmcy9yZWFkX3dyaXRlLmM6
NTk1IFtpbmxpbmVdDQo+ICB2ZnNfd3JpdGUrMHg2MTIvMHhiYTAgZnMvcmVhZF93cml0ZS5jOjY4
Nw0KPiAga3N5c193cml0ZSsweDE1MC8weDI3MCBmcy9yZWFkX3dyaXRlLmM6NzM5DQo+ICBkb19z
eXNjYWxsX3g2NCBhcmNoL3g4Ni9lbnRyeS9zeXNjYWxsXzY0LmM6NjMgW2lubGluZV0NCj4gIGRv
X3N5c2NhbGxfNjQrMHgxNzQvMHg1ODAgYXJjaC94ODYvZW50cnkvc3lzY2FsbF82NC5jOjk0DQo+
IGVudHJ5X1NZU0NBTExfNjRfYWZ0ZXJfaHdmcmFtZSsweDc3LzB4N2YNCj4gIDwvVEFTSz4NCj4g
DQo+IFRvIGZpeCB0aGlzLCBhZGQgY2hlY2tzIGZvciBpbnN0YW5jZS0+dXNiYXRtLT5hdG1fZGV2
ID09IE5VTEwgaW4NCj4gYWRzbF9zdGF0ZV9zdG9yZSgpIGFuZCBhZHNsX2NvbmZpZ19zdG9yZSgp
LiBUaGlzIHByZXZlbnRzIHRoZSBmdW5jdGlvbnMgZnJvbQ0KPiBwcm9jZWVkaW5nIGFuZCBkZXJl
ZmVyZW5jaW5nIHRoZSB1bmluaXRpYWxpemVkIGF0bV9kZXYsIGNvbnNpc3RlbnQgd2l0aCBob3cN
Cj4gbWFjX2FkZHJlc3Nfc2hvdygpIGhhbmRsZXMgdGhlIHNhbWUgcmFjZSBjb25kaXRpb24uDQo+
IA0KPiBGaXhlczogZTYwNWMzMDk3N2JiICgiVVNCOiBhdG06IGN4YWNydTogY29udmVydCB0byB1
c2UgZGV2X2dyb3VwcyIpDQo+IEFzc2lzdGVkLWJ5OiBHZW1pbmk6Z2VtaW5pLTMuNi1mbGFzaCBH
ZW1pbmk6Z2VtaW5pLTMuMS1wcm8tcHJldmlldyBzeXpib3QNCj4gUmVwb3J0ZWQtYnk6IHN5emJv
dCs5YjE5NWM0ZjQxMmVhNWM0ZTU2YUBzeXprYWxsZXIuYXBwc3BvdG1haWwuY29tDQo+IENsb3Nl
czogaHR0cHM6Ly9zeXprYWxsZXIuYXBwc3BvdC5jb20vYnVnP2V4dGlkPTliMTk1YzRmNDEyZWE1
YzRlNTZhDQo+IExpbms6IGh0dHBzOi8vc3l6a2FsbGVyLmFwcHNwb3QuY29tL2FpX2pvYj9pZD1i
NjM1MmQ2My1kMDNhLTRlODctOTJhNC0NCj4gYjMzNGMzZWJjZjk3DQo+IFRvOiAiQ2hhcyBXaWxs
aWFtcyIgPDNjaGFzM0BnbWFpbC5jb20+DQo+IFRvOiA8YWNjZXNzcnVubmVyLWdlbmVyYWxAbGlz
dHMuc291cmNlZm9yZ2UubmV0Pg0KPiBUbzogIkdyZWcgS3JvYWgtSGFydG1hbiIgPGdyZWdraEBs
aW51eGZvdW5kYXRpb24ub3JnPg0KPiBUbzogPGxpbnV4LWF0bS1nZW5lcmFsQGxpc3RzLnNvdXJj
ZWZvcmdlLm5ldD4NCj4gVG86IDxsaW51eC11c2JAdmdlci5rZXJuZWwub3JnPg0KPiBUbzogPG5l
dGRldkB2Z2VyLmtlcm5lbC5vcmc+DQo+IENjOiA8bGludXgta2VybmVsQHZnZXIua2VybmVsLm9y
Zz4NCj4gDQo+IC0tLQ0KPiB2MjoNCj4gLSBSZW1vdmVkIGNoYW5nZXMgYW5kIGRlc2NyaXB0aW9u
IGZvciBjeGFjcnVfcG9sbF9zdGF0dXMoKS4NCj4gDQo+IHYxOg0KPiBodHRwczovL2xvcmUua2Vy
bmVsLm9yZy9hbGwvYTIzMjU3NzAtMzEzNy00Y2MzLThhNjktDQo+IGM5OTkxZmM5MDQyY0BtYWls
Lmtlcm5lbC5vcmcvVC8NCj4gLS0tDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3VzYi9hdG0vY3hh
Y3J1LmMgYi9kcml2ZXJzL3VzYi9hdG0vY3hhY3J1LmMgaW5kZXgNCj4gNDI5YWMyMGE4Li5kZWUx
NWY3YjcgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvdXNiL2F0bS9jeGFjcnUuYw0KPiArKysgYi9k
cml2ZXJzL3VzYi9hdG0vY3hhY3J1LmMNCj4gQEAgLTM0Nyw3ICszNDcsNyBAQCBzdGF0aWMgc3Np
emVfdCBhZHNsX3N0YXRlX3N0b3JlKHN0cnVjdCBkZXZpY2UgKmRldiwNCj4gIAkJcmV0dXJuIC1F
SU5WQUw7DQo+ICAJcmV0ID0gMDsNCj4gDQo+IC0JaWYgKGluc3RhbmNlID09IE5VTEwpDQo+ICsJ
aWYgKGluc3RhbmNlID09IE5VTEwgfHwgaW5zdGFuY2UtPnVzYmF0bS0+YXRtX2RldiA9PSBOVUxM
KQ0KPiAgCQlyZXR1cm4gLUVOT0RFVjsNCj4gDQo+ICAJaWYgKG11dGV4X2xvY2tfaW50ZXJydXB0
aWJsZSgmaW5zdGFuY2UtPmFkc2xfc3RhdGVfc2VyaWFsaXplKSkNCj4gQEAgLTQ0NCw3ICs0NDQs
NyBAQCBzdGF0aWMgc3NpemVfdCBhZHNsX2NvbmZpZ19zdG9yZShzdHJ1Y3QgZGV2aWNlICpkZXYs
DQo+ICAJaWYgKCFjYXBhYmxlKENBUF9ORVRfQURNSU4pKQ0KPiAgCQlyZXR1cm4gLUVBQ0NFUzsN
Cj4gDQo+IC0JaWYgKGluc3RhbmNlID09IE5VTEwpDQo+ICsJaWYgKGluc3RhbmNlID09IE5VTEwg
fHwgaW5zdGFuY2UtPnVzYmF0bS0+YXRtX2RldiA9PSBOVUxMKQ0KPiAgCQlyZXR1cm4gLUVOT0RF
VjsNCj4gDQo+ICAJcG9zID0gMDsNCj4gDQo+IA0KPiBiYXNlLWNvbW1pdDogOGQzYWU1OTI4OGYx
ZTdkNThkNzY1NThhNmVlOTZkNTMzYmM1MDE5Zg0KPiAtLQ0KPiBUaGlzIGlzIGFuIEFJLWdlbmVy
YXRlZCBwYXRjaCBzdWJqZWN0IHRvIG1vZGVyYXRpb24uDQo+IFJlcGx5IHdpdGggJyNzeXogdXBz
dHJlYW0nIHRvIFNpZ24tb2ZmIHRoZSBwYXRjaCBhcyBhIGh1bWFuIGF1dGhvciBhbmQgc2VuZCBp
dCB0bw0KPiB0aGUgdXBzdHJlYW0ga2VybmVsIG1haWxpbmcgbGlzdHMuDQo+IFJlcGx5IHdpdGgg
JyNzeXogcmVqZWN0JyB0byByZWplY3QgaXQgKCcjc3l6IHVucmVqZWN0JyB0byB1bmRvKS4NCj4g
DQo+IFNlZSBodHRwczovL2dvby5nbGUvc3l6Ym90LWFpLXBhdGNoZXMgZm9yIGluZm9ybWF0aW9u
IGFib3V0IEFJLWdlbmVyYXRlZA0KPiBwYXRjaGVzLg0KPiBZb3UgY2FuIGNvbW1lbnQgb24gdGhl
IHBhdGNoIGFzIHVzdWFsLCBzeXpib3Qgd2lsbCB0cnkgdG8gYWRkcmVzcyB0aGUgY29tbWVudHMN
Cj4gYW5kIHNlbmQgYSBuZXcgdmVyc2lvbiBvZiB0aGUgcGF0Y2ggaWYgbmVjZXNzYXJ5Lg0KPiBz
eXpib3QgZW5naW5lZXJzIGNhbiBiZSByZWFjaGVkIGF0IHN5emthbGxlckBnb29nbGVncm91cHMu
Y29tLg0K
