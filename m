Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=35.157.23.187
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793173247;
	b=bp3RX4zLGrq4tuAZ5vRsDQrCf/Gu6lKE+JeWRYY3lwrAsuGduVo27strnERfBZIzNsng
	 o1/ctXnEwBJf++nbxZ4woJEEemiJLfnNd1keFGtS5+/qWfCwTBwO72uhVWVfsWa5UBp5c
	 O07YkZoluMsJe3MVR49h5gd4t3li+Ub71CGqM6pSy1dk+zXjnTwiPqqaSi9pIhoD5ht2R
	 nX/U0zQonZw3Z5SpfzVmrHMrVLK068trvy/AGQSfqkMZrYFSKJJvYpPHDC2kZZ/dQ3Tgx
	 KUFm8CKj7zuOI3SALRAMyXO7Mp3G5wcsT6E4E59SKoTCRka9sZItAqfX0BcIvXyInKg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793173247;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:CC:References:
	 Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-Originating-IP:X-ClientProxiedBy;
	bh=JgSqjGLkhPK3vICnAOXyWbM67kSh/OMJMraMs0151RA=;
	b=uetwnEAzRmsB7Kxr0a5Nn20ymr+v9YL9eU8ajjsCWLRKi4KL/tXr1zDu3nBKLFv1MtZE
	 dp5NNfXz65E7klv4dafQVMIfsRm3QCmLH3PaP0XHFUMeoF2uLSRL1xJ0mfJhHF3xAYu/8
	 nkqz8UlUmjczM0Z3c3LJrudZOHcFdT4Yl8IFK5cshopdBUVNEkCtzHWaT/wLip6xpiDcm
	 EAjbwS6jpomiDdJrgzv+Uw6wx9Jh22yAm+oTpp3KI8D6S125QypOqggcDeGS6xXNjodPG
	 cQl1nToyUuCBvTcQo/gZneHCjG7IKg6K/RqmFre19tW/jqrPaIb4SnMe5cxw+9ckLfg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=paragon-software.com;
	spf=pass smtp.mailfrom=paragon-software.com;
	dkim=pass header.d=paragon-software.com header.i=@paragon-software.com header.a=rsa-sha256 header.s=mail header.b=NoEC3t0D;
	arc=none smtp.remote-ip=35.157.23.187
Received: from relayaws-01.paragon-software.com (relayaws-01.paragon-software.com [35.157.23.187])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 097DF606A31D;
	Wed, 28 Oct 2026 07:40:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 097DF606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=paragon-software.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=paragon-software.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=paragon-software.com header.i=@paragon-software.com header.a=rsa-sha256 header.s=mail header.b=NoEC3t0D
Received: from relayfre-01.paragon-software.com (relayfre-01.paragon-software.com [176.12.100.13])
	by relayaws-01.paragon-software.com (Postfix) with ESMTPS id 95D6D1D15;
	Wed, 28 Oct 2026 07:41:32 +0000 (UTC)
Authentication-Results: relayaws-01.paragon-software.com;
	dkim=pass (1024-bit key; unprotected) header.d=paragon-software.com header.i=@paragon-software.com header.b=NoEC3t0D;
	dkim-atps=neutral
Received: from dlg2.mail.paragon-software.com (vdlg-exch-02.paragon-software.com [172.30.1.105])
	by relayfre-01.paragon-software.com (Postfix) with ESMTPS id 0F881D9;
	Wed, 28 Oct 2026 07:40:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=paragon-software.com; s=mail; t=1793173245;
	bh=JgSqjGLkhPK3vICnAOXyWbM67kSh/OMJMraMs0151RA=;
	h=Date:Subject:To:CC:References:From:In-Reply-To;
	b=NoEC3t0DHZkfT3Qqa/klBaPU3+nWgQJJd1zTNeR7hQXw9AC0sTIKlByhPUlxDSu/Z
	 hFjbxknPQ2chfPTzsM9yT0s++dIK1Kq89xw3ODrQtdUptswNKYATiN6xwpJK6UJA/F
	 JPKEeSO8rl33wb0vvVrHVchOKJnu7S9OUjSEzYcc=
Received: from [192.168.95.128] (172.30.20.183) by
 vdlg-exch-02.paragon-software.com (172.30.1.105) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.7; Wed, 28 Oct 2026 10:40:43 +0300
Message-ID: <16cff409-fe5e-4aa7-8f0f-abe0b62982f5@paragon-software.com>
Date: Wed, 28 Oct 2026 08:40:42 +0100
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Post: <mailto:syzbot@lists.linux.dev>
List-Help: <mailto:syzbot+help@lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
List-Owner: <mailto:syzbot+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] fs/ntfs3: handle partial allocation in
 attr_data_get_block_locked()
To: Slawomir Stepien <sst@poczta.fm>, <ntfs3@lists.linux.dev>
CC: syzbot <syzbot@kernel.org>, <syzkaller-bugs@googlegroups.com>,
	<linux-kernel@vger.kernel.org>, <syzbot@lists.linux.dev>,
	<syzkaller-upstream-moderation@googlegroups.com>
References: <8fc44517-e231-4539-a353-3dd47045a203@mail.kernel.org>
 <ammdVFSsD9cP8eYU@nr200>
Content-Language: en-US
From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
In-Reply-To: <ammdVFSsD9cP8eYU@nr200>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: vobn-exch-01.paragon-software.com (172.30.72.13) To
 vdlg-exch-02.paragon-software.com (172.30.1.105)

On 7/29/26 08:27, Slawomir Stepien wrote:

> Hello
>
> A gentle reminder about this PATCH.
>
> On lip 15, 2026 12:29, syzbot wrote:
>> From: Slawomir Stepien <sst@poczta.fm>
>>
>> When allocating clusters for a sparse or compressed attribute in
>> attr_data_get_block_locked(), the requested virtual cluster number (vcn0)
>> is aligned down to a frame boundary (vcn). The function then attempts to
>> allocate a full frame of clusters.
>>
>> If the disk is nearly full and highly fragmented, attr_allocate_clusters()
>> might only manage to allocate a small fragment and return success with a
>> partial allocation length. If this partial allocation is so small that it
>> does not even reach the originally requested vcn0 (i.e., end <= vcn0), vcn0
>> remains unallocated (a sparse hole).
>>
>> When the code subsequently calls run_lookup_entry() for vcn0, it finds the
>> original SPARSE_LCN entry, which triggers a WARN_ON(1).
>>
>> Fix this by adding a check to verify if the partial allocation reached
>> vcn0. If it did not (vcn0 >= end), treat this as an -ENOSPC failure and
>> jump to the undo1 label. This safely rolls back the partial allocation,
>> restores the original size, and repacks the runs, leaving the inode in a
>> consistent state before returning the error to the caller.
>>
>> WARNING: fs/ntfs3/attrib.c:1236 at attr_data_get_block_locked+0x1980/0x25d0
>> fs/ntfs3/attrib.c:1236
>> RIP: 0010:attr_data_get_block_locked+0x1980/0x25d0 fs/ntfs3/attrib.c:1236
>> Call Trace:
>>   <TASK>
>>   attr_data_get_block+0x1f1/0x2a0 fs/ntfs3/attrib.c:979
>>   ntfs_fallocate+0xd3d/0xf70 fs/ntfs3/file.c:670
>>   vfs_fallocate+0x663/0x7f0 fs/open.c:338
>>   ksys_fallocate fs/open.c:362 [inline]
>>   __do_sys_fallocate fs/open.c:367 [inline]
>>   __se_sys_fallocate fs/open.c:365 [inline]
>>   __x64_sys_fallocate+0xbf/0x110 fs/open.c:365
>>   do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>>   do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
>>   entry_SYSCALL_64_after_hwframe+0x77/0x7f
>>   </TASK>
>>
>> Fixes: 099ef9ab9203 ("fs/ntfs3: implement iomap-based file operations")
>> Assisted-by: Gemini:gemini-3.1-pro-preview Gemini:gemini-3-flash-preview syzbot
>> Reported-by: syzbot+7be6ad5cb228286af3e3@syzkaller.appspotmail.com
>> Closes: https://syzkaller.appspot.com/bug?extid=7be6ad5cb228286af3e3
>> Link: https://syzkaller.appspot.com/ai_job?id=3c9dee6e-001d-4972-8bf6-f6c960708246
>> Signed-off-by: Slawomir Stepien <sst@poczta.fm>
>>
>> ---
>> diff --git a/fs/ntfs3/attrib.c b/fs/ntfs3/attrib.c
>> index c621a4c58..786fd0ec0 100644
>> --- a/fs/ntfs3/attrib.c
>> +++ b/fs/ntfs3/attrib.c
>> @@ -1227,6 +1227,10 @@ int attr_data_get_block_locked(struct ntfs_inode *ni, CLST vcn, CLST clen,
>>        total_size = total_size0 + ((u64)*len << cluster_bits);
>>
>>        if (vcn != vcn0) {
>> +             if (vcn0 >= end) {
>> +                     err = -ENOSPC;
>> +                     goto undo1;
>> +             }
>>                if (!run_lookup_entry(run, vcn0, lcn, len, NULL)) {
>>                        err = -EINVAL;
>>                        goto out;
>>
>>
>> base-commit: 8cdeaa50eae8dad34885515f62559ee83e7e8dda
> --
> Slawomir Stepien

Hello,

Sorry for the delay. Your patch was applied, thanks.

Regards,
Konstantin

