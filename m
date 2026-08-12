Received: from TY3P286CU002.outbound.protection.outlook.com (mail-japaneastazon11020141.outbound.protection.outlook.com [52.101.229.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 568212BB13
	for <syzbot@lists.linux.dev>; Wed, 12 Aug 2026 04:47:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.229.141
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786510077; cv=fail; b=k6VzWFxpGafdvjo1fgVGYlz7pve9ji0gcpt6AksxNhEMdEU8Zjitju1AQ1AeMQjS/OhrdAnsO4Hyonlzzo6cCBruJUueu6QjnfjUX5b/YERH2/50FKHlXsppC5eN9edAsO1eV7ZCSt3vzYUh0DvR5nlo/G1MRV5lGzS0ZIhinxQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786510077; c=relaxed/simple;
	bh=yO09lTL+prdKspsdeh7OJbPx6tN4TZuK75FsvkZPlVw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=OjVptWk8IAiGEj4Q0VW3mu6Ldcjs7qSbQeF9bKjvz6BoIJFp976es3AqH71YQR1nn0zUYxZiX8vtJUh94KbcAvNpRm37AnxOle77yGMqE+xIXy2SOWpMqMjH9EPJ6dw9/1vkFWQxpujeQIztWYApnDGfTorDmhKwY1KYcCm4z60=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=valinux.co.jp; spf=pass smtp.mailfrom=valinux.co.jp; dkim=pass (1024-bit key) header.d=valinux.co.jp header.i=@valinux.co.jp header.b=H+eOJNUP; arc=fail smtp.client-ip=52.101.229.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=valinux.co.jp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=valinux.co.jp
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=valinux.co.jp header.i=@valinux.co.jp header.b="H+eOJNUP"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YRSUi0cYBeZvxeTo49yq00MlDah8hpd8qSQvClK9rjlubsu6UcH/eTFK+dxuWFnUE9iJWWoHy4ORqs4xCogop8155OKianPETLz6VdJ3DMFGDmTPyLfv+ITWC2boCwrcbFB+JZdzcUlo2sfB/XASdD5goU3dbRyphf9DYQj2hEN6aKnGAfMqNSYlZDQn4Rbupk+exxX5ekDEaVvVeZJwuAcRhPypwUPj6qxrRdu4gipJw9bjvk8gt//sAm7Nz2qiTcJOVsyaC03EKAVofksS4fLRKr/2YE2IWx5dggo6khHiJPsL/rt0stVbmDvD6xpRhi5D4O6PihQnrKS3ZZCpPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LY9LH/ag5ChzIRwGScNGxBSusakVHADqGvkODDcSL7A=;
 b=nx7tTOClB14lrGN1ixYSe0klGaNDPE3ZLSRvVolcBWHvs5GrYl3ry55EzjcGVq+un/yuK5tpinuCU/PziSAlzouC39MId45rRx03PaxOes4PhyT1DDs+po+oYdEic4kq6kpqkXZ4PWApg11ukmTxVDF9BTUQVCqWCAH0b6BYSRo0Zg67bq5sNDxZfmZIVtbsyVr/G3FFm2GHZxJODuPPNEM44Qn+a8Z5cfcGevEYTaFGhY097V3dZLywAGg43N9PDq0b2uboNZN2xp6bTU4/E9/l11tHfheU3FIqQb8KLPq7dr2RRiguGsdY7qyjXZCcgvcv+aa/GGfv9NRjDEA/iQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=valinux.co.jp; dmarc=pass action=none
 header.from=valinux.co.jp; dkim=pass header.d=valinux.co.jp; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=valinux.co.jp;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LY9LH/ag5ChzIRwGScNGxBSusakVHADqGvkODDcSL7A=;
 b=H+eOJNUPW44mUCo3rNfxW0QBhftqiVT5ZqQTtHvADk71CNgsaXu1L67Fbai+l4sCfpbpj1qcjfzpTfWMta2O2dWQe7U+q6XdG/Q+Io5R8El9F8DnVaR227kY68BLDT8Ml85m+YBXukIeuR/6Mp7igeQlifeiqLBqQVSkDHKmLmQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=valinux.co.jp;
Received: from TY7P286MB7722.JPNP286.PROD.OUTLOOK.COM (2603:1096:405:38f::10)
 by OS9P286MB4783.JPNP286.PROD.OUTLOOK.COM (2603:1096:604:2bc::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.25; Wed, 12 Aug
 2026 04:47:50 +0000
Received: from TY7P286MB7722.JPNP286.PROD.OUTLOOK.COM
 ([fe80::2305:327c:28ec:9b32]) by TY7P286MB7722.JPNP286.PROD.OUTLOOK.COM
 ([fe80::2305:327c:28ec:9b32%3]) with mapi id 15.21.0292.024; Wed, 12 Aug 2026
 04:47:50 +0000
Date: Wed, 12 Aug 2026 13:47:49 +0900
From: Koichiro Den <den@valinux.co.jp>
To: syzbot ci <syzbot+cid828235d04229e5c@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Subject: Re: [moderation/CI] Re: NTB: Add direct TX/RX using PCI endpoint DMA
Message-ID: <ld2d2ktolrvjif34x6e3qztqaappegf6plicpduahbry3mtwxl@q3aloaahf5av>
References: <6a7a4659.b50370da.49fe0.005b.GAE@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6a7a4659.b50370da.49fe0.005b.GAE@google.com>
X-ClientProxiedBy: TY4P301CA0124.JPNP301.PROD.OUTLOOK.COM
 (2603:1096:405:37e::14) To TY7P286MB7722.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:405:38f::10)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: TY7P286MB7722:EE_|OS9P286MB4783:EE_
X-MS-Office365-Filtering-Correlation-Id: 6530eba5-9b17-47de-41ec-08def82cdd02
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|10070799003|366016|1800799024|23010399003|376014|56012099006|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	bXGzr1nEudIrpFFETNTaEI2sB1SmzDCm0JImlFH5VAoRSF7BJPmU3YHuecNogq2rY2zG7AHgDZa63Kg/N+Xw6ILljBjCR/1tCChDXJZuvRi4inaaH7O24jQ+eZOXbK8JcQRIBmRY21+Yovg6BTG5nhY63ypp9iuSDoFeQVfhdXZ6I34VgyX1biHOOZNqDGe24Bv3PinenchI1junkZcT7yPVjWi8emQL0cE/cvYrxX0WMdU2eCYIOtahWKQKx69LBRitABvG/u/3oTAr2axaNbEdARx8Cu/S5Kw/xf2TgC6kh7yDyuNr+jwGtJsYBA3LjnnX3rGgmxjyz9aWv1ObowGPpmPPWYB7dDJqxl3G3AZBrCzZkbP4uESXQQYInnucbSSt4bELJSTkHsEx3VpInRzs5YDB6ctSe4bCXrnhikRlxZz4fj+ufp+YKA3BOE2JGLw0f5fmeExBJ7g5H1UAe0Vi1H2KWXudM+0/hE47lPIxdOoICgf7Zwm3Jao+jqifM2UorWP+Fgj85hz0KoVw39rxrfd+ZDjOCTJyOhAmnaL0YMPKdUiUv1VuCu/FVPFCCX9udzqMLeM/JO1kMdG3Wcw9j9OVbYOunvAGsj5+tgc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TY7P286MB7722.JPNP286.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(366016)(1800799024)(23010399003)(376014)(56012099006)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?0phQOC5cnXdXK07w2NGRlw/Ga7yk0WtHFDyUuBpq1ldOF8kIb210bTUgke5V?=
 =?us-ascii?Q?DNXFFbUlStW3uDSUhK/pyLrQHsNpKxkDmSv4heFT3vEKfoqgK9LFr8YVUX4Y?=
 =?us-ascii?Q?Kxmi8x16TqnX72CA5rHLWGH6gXylspsL+OnMkMmTJyv/5nO87TvrH50TMxYk?=
 =?us-ascii?Q?7YsvUU8T41yBsOhHLGbLlAAz17C5Jk7muhEcnwJvvgB+1nWqBUhCKHEOmKSo?=
 =?us-ascii?Q?qJiAFSOEY86SU3wZuSPQ3d1Ab+deo6to8eS9J3uOIuKO6RidkszNIPOdbUsw?=
 =?us-ascii?Q?tGFKG9zJLrrWfgYdEtC8Ix9VJQ+vRKTDVnYvnRVZ/WLwm43kTZUEQ5rHzdwy?=
 =?us-ascii?Q?M9X0dqA8YDCBTpjVZcxW7OcGWznwiPR2Xqh/Lb5GYqU8noahWRvuAhn2bLl8?=
 =?us-ascii?Q?epqN/k2DmGVRe0pa55kSA7wF3dQXLsbinfge6pMHJLjhUKM4zngiNbT4bHoA?=
 =?us-ascii?Q?fcvnCAdR+NWhFQO4jeKa8saf0pNTx+jBlQg7BFEDAY7ROMTwCoWJ/cfm5o7z?=
 =?us-ascii?Q?DKD5yMMv/DtRWXSYd0UnZ2D6U04aJtFdJPSOYNLXA2UXVSFnQimGbzl0xSAk?=
 =?us-ascii?Q?Jijh8Ub/6iigkxJ54SjDPn/15+d8/Km9ZlpaunNU/XCtjqae+dfif4QuqM2/?=
 =?us-ascii?Q?aPOBeRZcAgCkWwAQVQcjsG6LkhNCgBE6K1Z5UXkRIhFWYlegjVZD/0f7U/rn?=
 =?us-ascii?Q?G3U1yl5qmY9TVqkfmHZSIpdU4SoI3Nokj4baC76IAJcGRs405RxO/0vt1+aH?=
 =?us-ascii?Q?OzMilsrN/ctOwHHedzEAY+eelKaWS/x7nsESVBmrFOuI3mb0OnjQKclLCLy0?=
 =?us-ascii?Q?poV76xxTfMrXmHSlY0wtQ6eDCv8qGPGkDP2k0yjVFVhZiD8qsEvWLAubyCSc?=
 =?us-ascii?Q?BlwDcLTDq9PkLosDYyQyXYbdP4Awxf92j7vH0I+Y1V0P0pIeDmoa3vnxq0n2?=
 =?us-ascii?Q?6aIyOQlv1fBRggqtvhEz/jEwNRdhIYZiJGwfVNU3xJnXuWkwg8fFH8o48zoF?=
 =?us-ascii?Q?Hh5J9wzUhYAlqP5xaYP0tbJhpzUVWBq6F0mYOSRbLr8sbxUQdfLBNnL1TwVS?=
 =?us-ascii?Q?Q8s5QDuPEpASdxUmEucqmDmvAyOphWys2D/Yc6CEiHt8FcnXiT/71tgfxOGf?=
 =?us-ascii?Q?5MPTcs493syZArB3YUqYKM9XkcR2xq/ND0Ll9Ru6dKUuspebPw5X2pl6Nb4s?=
 =?us-ascii?Q?sWqVvB2tLKwB16Za8rQdJEUFs5fDr+WB0/F3Qs83qi9/m85udCLbSR85iEbQ?=
 =?us-ascii?Q?ygvwRh0LWJOtlcv7mIrGDa4nvCvDdjMW32uno7e5OIVaVKP9qCS3FBSZywrN?=
 =?us-ascii?Q?+hDF7d7bBONFR7QpvplbVydh+EtCdRAThL0oQWyTtPZ2lFFV00Eu0Z/ystHI?=
 =?us-ascii?Q?uB9vMlllRHliKygkG1LEFccYbLvfqRfFRLxePCMACapkdMRmjIrsMY4MKwPz?=
 =?us-ascii?Q?ChvEowsXRZl4AmqQCa4mFuoGVnjXP1cFFLV9II9l8J/WO2Y/Zuw95Y//X8lz?=
 =?us-ascii?Q?TVOVcenTqVjrUXXVfOdizyBAGy9NWTvhv1xVShcqUhgON++Dtx5CCelP6wyS?=
 =?us-ascii?Q?ERZWwcgl1MiuxuQubOPNpSaXVxe1izi7naxnmyQvGtWUSs2MH+bEYUDIDoU9?=
 =?us-ascii?Q?Iv4w3X+GcF2COZ7UOg9W/Fz/DPigrwea2+Zs52x4TpQsKwXjm3A/i5J5M4ZH?=
 =?us-ascii?Q?cE5VMaLvhTJxZIRZ8+yTyrkyVWrx1JL7aPdNgLEQJaSfzAzp4T/wJ59QwX8E?=
 =?us-ascii?Q?EsF4C/zUSknisWkAos4g2R0nlF4AQzX00spvVmL6qTlT70hg4GB5?=
X-OriginatorOrg: valinux.co.jp
X-MS-Exchange-CrossTenant-Network-Message-Id: 6530eba5-9b17-47de-41ec-08def82cdd02
X-MS-Exchange-CrossTenant-AuthSource: TY7P286MB7722.JPNP286.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Aug 2026 04:47:50.4564
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 7a57bee8-f73d-4c5f-a4f7-d72c91c8c111
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9RT5kEeH0ZdiFeHxh1HcdPAbFfRamdVGg49EEvLsagsF5fKjrwLRWe/VDQG6nS6iuSmmFdcVr21HLR7YdmRxgg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OS9P286MB4783

On Mon, Aug 10, 2026 at 02:44:57PM -0700, syzbot ci wrote:
> syzbot ci has tested the following series
> 
> [v1] NTB: Add direct TX/RX using PCI endpoint DMA
> https://lore.kernel.org/all/20260810165136.2292436-1-den@valinux.co.jp
> * [PATCH 01/16] NTB: ntb_transport: Abort link setup on QP MW allocation failure
> * [PATCH 02/16] NTB: ntb_transport: Reject oversized TX buffers
> * [PATCH 03/16] NTB: ntb_transport: Start TX offload thread after queue setup
> * [PATCH 04/16] NTB: ntb_transport: Stop QP work before freeing a queue
> * [PATCH 05/16] NTB: ntb_transport: Run RX processing on system workqueue
> * [PATCH 06/16] NTB: ntb_transport: Define direct-DMA shared state
> * [PATCH 07/16] NTB: ntb_transport: Negotiate direct-DMA queue layout
> * [PATCH 08/16] NTB: ntb_transport: Add opt-in direct-DMA channel reservation
> * [PATCH 09/16] NTB: ntb_transport: Allocate direct-DMA queue state
> * [PATCH 10/16] NTB: ntb_transport: Implement direct-DMA QP session handshake
> * [PATCH 11/16] NTB: ntb_transport: Implement direct-DMA RX buffer publication
> * [PATCH 12/16] NTB: ntb_transport: Implement direct-DMA TX submission
> * [PATCH 13/16] NTB: ntb_transport: Implement safe direct-DMA teardown
> * [PATCH 14/16] NTB: ntb_transport: Enable direct-DMA queues
> * [PATCH 15/16] NTB: ntb_transport: Report the direct-DMA payload limit
> * [PATCH 16/16] NTB: ntb_transport: Add optional polling for direct-DMA RX
> 
> and found the following issue:
> kernel build error
> 
> Full report is available here:
> https://ci.syzbot.org/series/47a24886-7793-47c5-afcb-099b60961996
> 
> ***
> 
> kernel build error
> 
> tree:      net-next

This series implementation uses a new API introduced by Frank's series:
https://lore.kernel.org/r/20260521-dma_prep_config-v7-0-1f73f4899883@nxp.com/
which is queued for v7.3 and is not yet present in net-next.

If accepted, I expected this series go through ntb-next (rather than net-next),
most likely for v7.4, by which time the API should be in the tree.

#syz invalid

Best regards,
Koichiro


> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netdev/net-next.git
> base:      001b5d347d8ba39b2dccaefcc57967b18caec8fe
> arch:      amd64
> compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
> config:    https://ci.syzbot.org/builds/ed6a2ec8-60c9-4ac5-8010-3ffdf21a07e7/config
> 
> drivers/ntb/ntb_transport.c:3052:13: error: call to undeclared function 'dmaengine_prep_config_single_safe'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
> drivers/ntb/ntb_transport.c:3052:11: error: incompatible integer to pointer conversion assigning to 'struct dma_async_tx_descriptor *' from 'int' [-Wint-conversion]
> drivers/ntb/ntb_transport.c:3072:14: error: incompatible integer to pointer conversion assigning to 'struct dma_async_tx_descriptor *' from 'int' [-Wint-conversion]
> drivers/ntb/ntb_transport.c:3149:16: error: call to undeclared function 'dmaengine_prep_config_single_safe'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
> drivers/ntb/ntb_transport.c:3149:14: error: incompatible integer to pointer conversion assigning to 'struct dma_async_tx_descriptor *' from 'int' [-Wint-conversion]
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
> 
> To test a patch for this bug, please reply with `#syz test`
> (should be on a separate line).
> 
> The patch should be attached to the email.
> Note: arguments like custom git repos and branches are not supported.
> 
> The email will later be sent to:
> [allenbh@gmail.com cassel@kernel.org dave.jiang@intel.com den@valinux.co.jp frank.li@kernel.org gregkh@linuxfoundation.org jdmason@kudzu.us linux-kernel@vger.kernel.org nab@linux-iscsi.org netdev@vger.kernel.org ntb@lists.linux.dev]
> 
> If the report looks fine to you, reply with:
> #syz upstream
> 
> If the report is a false positive, reply with
> #syz invalid
> 
