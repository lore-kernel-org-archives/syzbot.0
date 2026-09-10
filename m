Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 241D44A68A1
	for <syzbot@lists.linux.dev>; Thu, 10 Sep 2026 15:14:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=100.103.45.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789053286; cv=pass; b=N4lXFuQn+l3NfsGWJ6T9IzBBIcrVcwyaLMe7IIuVLopITbXsGMl/Tl5TaqbmAtdYYy04O11HV/+VAnz/O+eC7+omVF6/nShbeKnOi/7C7ronff2mRFW7nbfJPp+vnNNrExgOS6TXdkIkPbON+xB66vtXtvVfIXTn9ZtopIlGUBM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789053286; c=relaxed/simple;
	bh=xPUnhtmCJL1zjENUgzc4+IJ2FCGKfLyvIqteJcfnq4M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=P/AM2o3oNJLCxZrVzmnBSnaoSbup1tM4qFPzL/R4562E4TC6FxvDxsQeDLD5/COUygLZ4MQN+4X8K5Ncyw2/C0etQXtErVpQc+Y7td+nGKNAtWRpsiYkvNGla7+Jc+Zm6oJl2NBkA6Vt56S8/mKN1IeCIGaG+mpCsZ3mZTp/SP4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=oyLoMfxZ; arc=pass smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="oyLoMfxZ"
Received: by smtp.kernel.org (Postfix)
	id D657B1F0089C; Thu, 10 Sep 2026 15:14:39 +0000 (UTC)
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=148.163.156.1
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1789053279;
	b=KY0kY+NG5eXpv5FAFREK9VjlPpfWlaoyPUAhOojUEIBkyKi639p7RHx5wSDEk77iBsTL
	 B9FpxioXIEZz7CHHWt90cs1PQK9NUJ7YxK3C1LE5E7VvFZ0V/g1b8QyrT/SReauj202CI
	 kxw6oAHHarGGGA1gINeHSEWrZBKsk4FlsHh5ecyZZT6B1NFiEDIkA1LLoFXF1QgS5+OT7
	 E8MYkALyzBNzbOG0soGCvvzPJ1gBLYHW2JTPwuuNnedbVt2d7uRdiORU+fJtLHwKiyRII
	 47TJ05fgdQN3R6ZvVKsgI19mKLEKzcoJzg+k1UosxvKLhmUQWNgNGNjkFZb700eIMOw==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1789053279;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 Received:Received:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-TM-AS-GCONF:
	 X-Proofpoint-Reinject:X-Authority-Analysis:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Spam-Info:
	 X-Proofpoint-GUID:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=pf6sAm6ySUjeHhH+OX9WrlKoZTISlAaNwcFj+u48Bns=;
	b=FrzD8WnbyvjIvOm/uiP9U7zBJpyxCqb5Jr+G0VDiCBJ33xuaySWs4hfiEkRZvs75lJo5
	 UkXp3O7kBRDUvyAAcUYiIZKom3GVJ/XlMmLigazF9uYAo8O1/7WJrmUzqCzn1EvVELoG6
	 /2rhZXSNPFTD70NMmZIiQ3WXA3u2Cgl6Yeq8zyVM7Z+18VOByZrZMYIa3/yoXkTZY55Mo
	 0y7RzlSeGuZ2rooXjakiw8t04uEV37Z/Sqgvb5aogfaumpRt4HC9ixs0P8rryQbNX4JNu
	 tC4KFA0olG8nifCyRxUYmuye0wqFR0Hoqbu8hdwNZslEV6TXEwE3sBDzx2nLoxMHU8g==
ARC-Authentication-Results: i=1; smtp.kernel.org; dkim=pass header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=oyLoMfxZ;
	dmarc=pass header.from=linux.ibm.com;
	spf=pass smtp.mailfrom=linux.ibm.com;
	arc=none smtp.remote-ip=148.163.156.1
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 2AC071F00899
	for <syzbot@kernel.org>; Thu, 10 Sep 2026 15:14:39 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=oyLoMfxZ
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.kernel.org 2AC071F00899
Authentication-Results: smtp.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68AFDSiC3266754;
	Thu, 10 Sep 2026 15:14:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=pf6sAm
	6ySUjeHhH+OX9WrlKoZTISlAaNwcFj+u48Bns=; b=oyLoMfxZKEkD3CLOOicCuF
	mPrms9UkvbQiJUzr3AiJjXGabXREHdEIPIJhI6Q1BDOpqeFQFIBe7V1Ltgo7eZ2K
	DoSFDnTpk82VNfdvUt7yTsKLeXzOMgDVvlQ78s/3VWnIeAAbpeenprVwJSMvHKty
	6dM2LOVLxWbRmJBmpy2BVlfPDK8TsLCvg8Z6T9JElQVoAmKjzaMTo841u57cG1G4
	S09HT5mYSF5073/vUbdP/q1cbcCUhKmNYbLFVBUSPf8EIVsrcmsuZ+zQZq6Rl2lo
	8rHLDRCn7HULZ8AwwUdV1K/9ysyZwjiEdF0aZB++OIamNPDh/xsN36bwFb7um+aA
	==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gkd8qneu5-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 10 Sep 2026 15:14:35 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 68AF7u1d201998;
	Thu, 10 Sep 2026 15:14:34 GMT
Received: from smtprelay03.wdc07v.mail.ibm.com ([172.16.1.70])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4gkvq2rrbp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 10 Sep 2026 15:14:34 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (smtpav03.dal12v.mail.ibm.com [10.241.53.102])
	by smtprelay03.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 68AFDpUh15598320
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 10 Sep 2026 15:13:52 GMT
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C21CA5803F;
	Thu, 10 Sep 2026 15:14:33 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5290A5805A;
	Thu, 10 Sep 2026 15:14:30 +0000 (GMT)
Received: from [9.61.102.225] (unknown [9.61.102.225])
	by smtpav03.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 10 Sep 2026 15:14:29 +0000 (GMT)
Message-ID: <c9ff6779-feb0-489e-a6ee-9477fd105e61@linux.ibm.com>
Date: Thu, 10 Sep 2026 20:44:28 +0530
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] blk-mq: fix out-of-bounds read in blk_mq_free_rqs
To: syzbot <syzbot@kernel.org>, syzkaller-bugs@googlegroups.com,
        Krystian Kaniewski <krystianmkaniewski@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, syzbot@lists.linux.dev
References: <c92b0c7e-17fb-44c8-99d9-59d45004d05a@mail.kernel.org>
Content-Language: en-US
From: Nilay Shroff <nilay@linux.ibm.com>
In-Reply-To: <c92b0c7e-17fb-44c8-99d9-59d45004d05a@mail.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Authority-Analysis: v=2.4 cv=SpUFe/O0 c=1 sm=1 tr=0 ts=6aa2c95c cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=iQ6ETzBq9ecOQQE5vZCe:22 a=edf1wS77AAAA:8
 a=pGLkceISAAAA:8 a=hSkVLCK3AAAA:8 a=VnNF1IyMAAAA:8 a=7bTMroNJj3-o06XVi28A:9
 a=QEXdDO2ut3YA:10 a=DcSpbTIhAlouE1Uv7lRv:22 a=cQPPKAXgyycSBL8etih5:22
X-Proofpoint-ORIG-GUID: kWznKHegshNxz_gk4fidlEc_sd7b3-tY
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTEwMDE4MiBTYWx0ZWRfXzlU9PNBi2j7D
 n+ImY6bRx3XVJaZg+2CoGkmT68NeSui5ea1hhGXW4A26j4XFloY8iPZZaGORPZMRd+eWyKjlzGm
 r//3M+o8Lj51xDRFkmsHlZ++CPEWOm9C8Or3Qn5xUPSrEPLfIW1rIjh5EXcugV2ToNKXryLiq/p
 nm7Ke2Dk+ETyuyKrLpdXTVD+B+pJ2o8C1vP7zQsKDPlu2ST7yYGOJkNyYGxbOrzJq196k2cE5k0
 /JI9j5I7bccNptOFI3xXfdiSestg6txOOHhakx5YavKPouYIYzNKeES6GN85mwJEZ+q41NjciXF
 VH4e9RuViQf6aICGKgE6JWVD7CgklHV3UxVfOBMKF8muZZ61OGbJZiDJWqWY/ya/0MZ4d7jbwbF
 LKSD6X80AVL9Nt/xLU05gqf7SETDF4lDyONygUvEkKwGZkleNIgp3Wemzrq24Kthb9bHmSRcSF9
 mVS4wIV1pSqPd5EARTA==
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTEwMDE4MiBTYWx0ZWRfX0PQdgdff5wmJ
 4pScsl3oi2cpDKdKylMgO7u6alWVWzm14UGMzIbn3GuAeZmzGOe/HbYlHpIOwIWfv9sPL/SfKSo
 HDSYVJmY9uqtgJScm6H0I3TCVYTx4MU=
X-Proofpoint-GUID: Q6dgpUTMwSxTYiQT4BbgrgGt_2vTpoGw
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-10_05,2026-09-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 adultscore=0 lowpriorityscore=0 suspectscore=0 spamscore=0
 clxscore=1011 phishscore=0 malwarescore=0 impostorscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609100182

On 9/10/26 3:49 PM, syzbot wrote:
> From: Krystian Kaniewski <krystianmkaniewski@gmail.com>
> 
> A KASAN slab-out-of-bounds read can occur in blk_mq_free_rqs() when there
> is a mismatch between the number of hardware queues allocated for the IO
> scheduler (et->nr_hw_queues) and the number of hardware queues in the block
> tag set (set->nr_hw_queues).
> 
> This mismatch can happen if blk_mq_update_nr_hw_queues() fails halfway
> through (e.g., due to memory pressure during
> blk_mq_prealloc_tag_set_tags()). In this error path, the elevator is
> restored with a larger number of hardware queues than the block tag set
> actually has.
> 
> When the elevator is later freed, blk_mq_free_sched_tags() iterates up to
> the new et->nr_hw_queues and calls blk_mq_free_rqs(). In blk_mq_free_rqs(),
> it attempts to access set->tags[hctx_idx] to get the driver tags. Because
> set->nr_hw_queues was not updated due to the earlier failure, set->tags
> still has the old (smaller) size, leading to an out-of-bounds read.
> 
Yes makes sense, this scenario seems feasible.

> BUG: KASAN: slab-out-of-bounds in blk_mq_free_rqs+0xde/0x680
> Read of size 8 at addr ffff88818d67fc28 by task syz-executor117/5839
> Call Trace:
>   blk_mq_free_rqs+0xde/0x680
>   blk_mq_free_map_and_rqs+0x40/0xf0
>   blk_mq_free_sched_tags
>   blk_mq_free_sched_res+0xeb/0x280
>   elevator_change_done+0x1d2/0x5c0
>   elevator_change+0x34f/0x480
>   elv_iosched_store+0x504/0x630
>   queue_attr_store+0x207/0x2b0
> 
> To fix this, explicitly check if hctx_idx < set->nr_hw_queues before
> accessing set->tags[hctx_idx]. If hctx_idx >= set->nr_hw_queues, the
> hardware queue doesn't exist in the tag set, meaning there are no driver
> tags to clear mappings from. In this case, safely set drv_tags to NULL. The
> subsequent call to blk_mq_clear_rq_mapping() already handles a NULL
> drv_tags pointer and will safely return.
> 
Fix looks reasonable.

> This fix also prevents a similar out-of-bounds read in the failure path of
> blk_mq_alloc_rqs(), where a failure during new driver tag allocation could
> lead to blk_mq_free_rqs() being called with an hctx_idx greater than or
> equal to set->nr_hw_queues.
> 
I'm not sure if this is possible. Looking at the callers of blk_mq_alloc_rqs(),
the allocation loops appear to be bounded by set->nr_hw_queues, so an
hctx_idx >= set->nr_hw_queues should not be passed to blk_mq_alloc_rqs() in
that path. Nevertheless, the guard in blk_mq_free_rqs() looks reasonable as
a defensive check and fixes the reported failure.

> Fixes: 04225d13aef1 ("block: fix potential deadlock while running nr_hw_queue update")
> Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot
> Reported-by: syzbot+e90526cab23b9efcd03c@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=e90526cab23b9efcd03c
> Link: https://syzkaller.appspot.com/ai_job?id=827b5760-86a0-4f44-9c69-430b572eac12
> Signed-off-by: Krystian Kaniewski <krystianmkaniewski@gmail.com>
> 
> ---
> diff --git a/block/blk-mq.c b/block/blk-mq.c
> index 2c850330a..8e6726b37 100644
> --- a/block/blk-mq.c
> +++ b/block/blk-mq.c
> @@ -3473,8 +3473,10 @@ void blk_mq_free_rqs(struct blk_mq_tag_set *set, struct blk_mq_tags *tags,
>   
>   	if (blk_mq_is_shared_tags(set->flags))
>   		drv_tags = set->shared_tags;
> -	else
> +	else if (hctx_idx < set->nr_hw_queues)
>   		drv_tags = set->tags[hctx_idx];
> +	else
> +		drv_tags = NULL;
>   
>   	if (tags->static_rqs && set->ops->exit_request) {
>   		int i;
Thanks for the fix! Overall, this looks good to me.

Reviewed-by: Nilay Shorff <nilay@linux.ibm.com>

