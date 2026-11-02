Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.51
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793631457;
	b=LdQrtCw2c76++i75XD3jqequq+Jv902nccN4G5XPEznGX0o9HsuIqs0ev39OtlEdnUar
	 +2fbluihlFmK/Olxx0RHpFULk2wvFpE6o13lCE7rk9JotKzXqfTB9VubVa9cqc2+GdYmk
	 wK9vssGRlCd02PHM0T7tkbS98LVb0FUYjU/fKG+T9fQW/D5JU/DUgXzPPx/W25us00HL/
	 Ovhb1htEFlHsmC+ZWL5Tkglvk5obyj3kqQ20Lw4CWwoqlqL+pKBBopswk4PQ6K546Dcal
	 dGD2D/e7EYH1NNivUCLGfr0GFxKNU7+XrDM46ybQEuoLbG1GH17yL15Yrj9BeKYt0TQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793631457;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=Qnp94G0DRTWbZFaxE19m6TH0NvUhAeFNTa2yNCglEGI=;
	b=XZRzbsNBfx18P0A7JAZNJFwEDCjwNuDxQ0Kosprt2gWx9PcBvR3dsNQFzqCVmEnz5GJ4
	 YYgt2i6hguMcK/FeNibZCZCflgZXcwNZ89dkOV7PtL5/qO7VN9VWlsxP6bLO9mzD/aUXg
	 OdP+whAip3aLKt87ZVbyx3F83rOjh88R1csontOtj6p2+U2pMUZQz8ltwsDFRCUVoGu1W
	 2S1RGIqnHOYIMQV3V1gisBToTeXSn0xVVaUW7Jwnm6keWCuj2o3803w/0hcHQAnyNQbkp
	 jD0PI/wqjWhv0ktCvZZLlunhXnBT9bd3HwsMhGyHH+xNncDNCRQIawnXj0krqzPBPdg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=gcSiuNCP;
	arc=none smtp.remote-ip=209.85.218.51
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F2EA606A5A7
	for <syzbot@lists.linux.dev>; Mon,  2 Nov 2026 14:57:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6F2EA606A5A7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=gcSiuNCP
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-c40e02b2ebaso538547066b.1
        for <syzbot@lists.linux.dev>; Mon, 02 Nov 2026 06:57:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793631456; x=1794236256; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Qnp94G0DRTWbZFaxE19m6TH0NvUhAeFNTa2yNCglEGI=;
        b=gcSiuNCPB6xh5c8Tsjt79eS0gF6dtPEFPmbP3TD+jr/Q5/8/yMdnHG/1zzeYqEgRHk
         g/3R7L7RpdpWXUW7cT5wAaBzTNf4U+v1wtiUcnIU7rEiSeg+e/D4pV02a9yJxqRB3SDW
         XHoogAFRPpu4hTe13qeyrHhhwHgszDc6o9Fhv4qxVHcYSH/JwJMw9XPKrMLq6phnMMOF
         jdsqRFGUvf9p1yRlzy9oDLamFoSEPCqlapTR4Fn6uFpJp9ecb1L8CqUYdbASmcrZkr3P
         +Y+SK3XRfxCoarhMItS8jeyBEyOMQGNKlnBDz++7wq0XnGHnbiqX6rlCrsingaqatJvv
         UOTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793631456; x=1794236256;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Qnp94G0DRTWbZFaxE19m6TH0NvUhAeFNTa2yNCglEGI=;
        b=qDECyr2E5DmHNYtnmLmZCY/OrAFYJKJrZCtFfSYRIKV1tNvmCJu0qa7U/Cw+ue9tgf
         4vN3wxuBTc6x1TJm2GRqHEAB29i1Z5uQUIU57j0/DTVmTjCJneXJWUUeJXaIkP1iyLOp
         vEa4Q4WQVuDlXYJSuYWquhpF9e88hD+p8lwV8F54cF+dm+nSU4UGd3Cgw3ZiksqBNtOL
         yy+kZ7n/NLM0CA89z0U2cX9rpnXSVW+xgV410IcuSvXVaIZR5DZcPLOVRfw82WycbKFn
         cQHWAz8b5M9BXaDhXjxy+0q6+goOKOcxeFLksieq0JvxP3vA1oYt0XowFGie3JWcQi4F
         dOJQ==
X-Gm-Message-State: APuU4Z932TyJhG2qb5cVjVwtC31QPJhv1li5FnyqZeX+19fNKOSvi6Pq
	HuZW9MB48x51UpWqwSEMlnow7+lOmVJFV7otrHGTprKtHPVuo0OF5UgK
X-Gm-Gg: AYBFou1/dRQjro+Xopds27HkNb8AlmIALEawYopATYVY735g2POWaj7qONNZ/cnzIkC
	RuIep0gWFPjzFe0OqW+EPOkJ/7aWkeaPm7Vf4phHyjtkH32Vtaiy9eGGcL1jtm7LRRNGtVaJ3sg
	AM70ulJZnQER8nuu6xDClc/6jb6nmoklMuGYb/5HTItiObNlj40d4PoNp1/s3NWM+tfC54Vdoxc
	8dB9R8YaPnZFKMlbGknGL/V0opUFmXGJZOw4aMjB6JKUDXG1LtfzbHmUA0WjmI1POLY8Bsw+1PG
	Ewhrf0Nxpc/0p7iWRVQ0AshODRGWkAyi3Y4/V1eWa++9v4LJeupZnu0m6F+krYILEgCojWC5DCa
	OVRWpQQlCnO6dS86pSblo/Jz14SIJu/DHzTwnlOj9Rkb+QOYTTInBvsxCX2tA+aFkVWmafiki//
	CTUIyNxA+dSpnNESb98TniMcPegtivKoglXVqHJqCu2RfHqgKAdAtUfinqz/Z6kAOy91nbDGz16
	njK8FCAeSR9URPdbnxf8kxtBII2QCwmJz3fmem8VRHuTD4opm8+J7EbWnXs8QQXW/k5WeyMBrTE
	oT63Xn3rgWlDq0BRSN7kVmt4OW8IYXzpvbyRhhMx21ZZWlmiDb/xu5JHztB81cR94kg8UFxdMJg
	Pyq7r
X-Received: by 2002:a17:907:1b29:b0:c41:26b8:c49d with SMTP id a640c23a62f3a-c4ca7ab18d6mr848792366b.38.1793631455654;
        Mon, 02 Nov 2026 06:57:35 -0800 (PST)
Received: from [192.168.0.50] (93-159-22-200.cgnat.inetia.pl. [93.159.22.200])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c4cabe1003fsm401959266b.44.2026.11.02.06.57.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Nov 2026 06:57:35 -0800 (PST)
Message-ID: <fff5f1f4-b5b7-4378-b679-30d8a292e14d@gmail.com>
Date: Mon, 2 Nov 2026 15:57:34 +0100
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
Subject: Re: [PATCH RFC] md: clear pending reshape parameters in __md_stop()
To: syzbot <syzbot@kernel.org>, syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
References: <0bbc5530-3021-49ec-a8cd-a006c2639d53@mail.kernel.org>
Content-Language: en-US
From: Uladzislau Zhauniarovich <uladzislau.zhauniarovich@gmail.com>
In-Reply-To: <0bbc5530-3021-49ec-a8cd-a006c2639d53@mail.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Thanks. The fix is in the right place and the guard is right. Please
send a v2, rebased on current mainline (v7.4-rc1 or later), with the
changes below.

1) Context: mainline now has a related fix.

   0669c7dbd1d3 ("md/raid5: don't BUG() on an inconsistent reshape state 
from the superblock")

It is in v7.4-rc1. It turns the BUG_ON()s in raid5_run() into
"inconsistent reshape state - aborting." and -EINVAL, so the reproducer
no longer oopses. But the stale request is still there: after the
reproducer the array cannot be started again (writing "active" to
array_state fails). Your hunk is what makes it start again, so v2 is a
follow-up to 0669c7dbd1d3. Do not touch drivers/md/raid5.c.

2) Keep your hunk in __md_stop(), with its guard and the five
    assignments, exactly as they are:

 > +    if (mddev->reshape_position == MaxSector) {
 > +        mddev->delta_disks = 0;
 > +        mddev->reshape_backwards = 0;
 > +        mddev->new_level = mddev->level;
 > +        mddev->new_layout = mddev->layout;
 > +        mddev->new_chunk_sectors = mddev->chunk_sectors;
 > +    }

Keep it at the end of __md_stop(), after
clear_bit(MD_RECOVERY_FROZEN, ...). Do not move it into md_run() or
do_md_run(). At that point new_* may legitimately come from the
superblock, which 0669c7dbd1d3 deliberately rejects, and dm-raid sets
new_* before md_run().

3) Add a reset of rdev->new_data_offset inside the same block, as
    reshape_position_store() does:

     if (mddev->reshape_position == MaxSector) {
         struct md_rdev *rdev;

         mddev->delta_disks = 0;
         ...
         mddev->new_chunk_sectors = mddev->chunk_sectors;
         rdev_for_each(rdev, mddev)
             rdev->new_data_offset = rdev->data_offset;
     }

- new_offset (new_offset_store()) is part of the same pending request.
- super_1_sync() writes it only while reshape_position != MaxSector.
- A stale value makes update_raid_disks() refuse a later valid
   raid_disks change.
- reconfig_mutex is held here, so use plain rdev_for_each(), not the
   _rcu variant.

4) Add this comment above the if-block:

     /*
      * A reshape that was requested on the running array (raid_disks,
      * layout or chunk_size written) but never started with
      * sync_action=reshape exists only in memory: the superblock records
      * delta_disks and the new geometry only while reshape_position !=
      * MaxSector.  Drop it together with the personality, as
      * reshape_position_store() does, so that the next md_run() does not
      * see the geometry of a reshape that is not in progress.  A reshape
      * that has started has reshape_position != MaxSector and is kept.
      */

5) Tags and commit message for v2:

   - Subject: "md: drop a never-started reshape request when stopping 
the array"
   - Fixes: 9e653b6342c9 ("[PATCH] md: Set/get state of array via sysfs")
     instead of 91adb56473fe. 9e653b6342c9 added array_state=inactive
     (do_md_stop() mode 2), the only stop that keeps the configuration.
   - Cc: stable@vger.kernel.org. 0669c7dbd1d3 has a Fixes: tag, so it
     will be backported, and backported arrays will then fail to restart
     in this case too.
   - Cc: Yogesh Gaur <yogeshgaur.83@gmail.com>
   - Keep Reported-by: and Closes:.
   - Rewrite the changelog around the mechanism:
     * Writing raid_disks, layout or chunk_size to a running array only
       records a request. update_raid_disks() sets delta_disks, not
       new_level. The reshape starts only on sync_action=reshape;
       "frozen" and a spare are not needed.
     * super_90_sync() and super_1_sync() write the request only while
       reshape_position != MaxSector, so dropping it at stop matches
       what reassembling from disk gives.
     * Minimal sequence:
         # raid5 running on 3 devices
         echo 4 > /sys/block/md0/md/raid_disks   # delta_disks = 1, 
never started
         echo inactive > /sys/block/md0/md/array_state
         echo active > /sys/block/md0/md/array_state
       A pending layout or chunk_size change ends the same way.
     * Quote the trace from the syzbot report (raid5.c:8117), not the
       one in v1 with "md.c:-1".
     * Say what is left after 0669c7dbd1d3. raid5 refuses to start.
       raid10 has no check at all: setup_conf() uses new_layout and
       new_chunk_sectors, so after a pending layout change and
       inactive -> active a raid10 array silently returns different
       data.
     * Do not write "Fix this". Two inputs are left to 0669c7dbd1d3's
       -EINVAL: new_level written while the array is inactive, and a
       crafted superblock with RESHAPE_ACTIVE and reshape_position ~0.
       Say that a started reshape (reshape_position != MaxSector) is kept
       and resumes.

The diff should be a single hunk at the end of __md_stop() in
drivers/md/md.c: 22 added lines, nothing removed.

I tested exactly that hunk in QEMU with KASAN on a v7.2-rc5 based tree,
with 0669c7dbd1d3 applied:

- The reproducer: 2/2 BUG without any fix, -EINVAL and an array that
   stays down with only 0669c7dbd1d3, 3/3 clean with the hunk; the array
   starts again with its old geometry.
- The layout, chunk_size, shrink-by-2 and readonly-restart variants are
   clean with the hunk.
- raid10 with a pending layout change keeps its data intact.
- A real grow 3->4 still completes.
- A reshape parked at reshape_position 49152 and then taken
   inactive -> active resumes at 49152 and finishes with the data intact.

On 09/09/2026 23:45, syzbot wrote:
> When reconfiguring an active MD array (for instance, updating the number of
> disks via the raid_disks sysfs attribute), pending reshape parameters such
> as delta_disks, new_level, new_layout, and new_chunk_sectors are stored in
> struct mddev. At this stage, the reshape has not yet started running and
> mddev->reshape_position remains set to MaxSector.
>
> If userspace deactivates or stops the array before the reshape begins (such
> as by writing "inactive" to array_state), do_md_stop() invokes __md_stop().
> Unlike a full stop which invokes md_clean() to clear all configuration
> fields, __md_stop() detaches the personality and frees private data but
> leaves the pending reshape parameters in struct mddev. When the array is
> later restarted (e.g. by writing "active" to array_state), md_run() calls
> the personality's run method, raid5_run(). Because mddev->reshape_position
> is still MaxSector, raid5_run() assumes no reshape is taking place and
> expects no pending reshape parameters, causing BUG_ON(mddev->delta_disks !=
> 0) to trigger:
>
> kernel BUG at drivers/md/raid5.c:8117!
> Oops: invalid opcode: 0000 [#1] SMP
> RIP: 0010:raid5_run+0x2550/0x2560 drivers/md/raid5.c:8117
> Call Trace:
>   <TASK>
>   md_run+0xc3d/0x1cd0 drivers/md/md.c:6779
>   do_md_run+0x35/0x720 drivers/md/md.c:6880
>   array_state_store+0x958/0xe90 drivers/md/md.c:-1
>   md_attr_store+0x3b7/0x640 drivers/md/md.c:6158
>   kernfs_fop_write_iter+0x3a4/0x540 fs/kernfs/file.c:345
>   vfs_write+0x612/0xba0 fs/read_write.c:687
>   ksys_write+0x150/0x270 fs/read_write.c:739
>   do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
>   entry_SYSCALL_64_after_hwframe+0x77/0x7f
>   </TASK>
>
> Fix this by clearing pending reshape parameters in __md_stop() if no
> reshape is currently running (mddev->reshape_position == MaxSector).
> Specifically, reset delta_disks and reshape_backwards to 0, and reset
> new_level, new_layout, and new_chunk_sectors to level, layout, and
> chunk_sectors, respectively. If a reshape is actively in progress
> (mddev->reshape_position != MaxSector), the parameters are preserved so the
> reshape can resume when the array is restarted.
>
> Fixes: 91adb56473fe ("md/raid5: refactor raid5 "run"")
> Assisted-by: Gemini:gemini-3.8-flash Gemini:gemini-3.1-pro-preview syzbot
> Reported-by: syzbot+1f5a7de91d547763f4c8@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=1f5a7de91d547763f4c8
> Link: https://syzkaller.appspot.com/ai_job?id=ebe142c5-4399-48c5-aad4-4ee23cb2055d
> To: <linux-raid@vger.kernel.org>
> To: "Song Liu" <song@kernel.org>
> To: "Yu Kuai" <yukuai@fygo.io>
> To: "NeilBrown" <neilb@suse.de>
> Cc: <linux-kernel@vger.kernel.org>
> Cc: "Li Nan" <magiclinan@didiglobal.com>
> Cc: "Xiao Ni" <xiao@kernel.org>
>
> ---
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 680b34a63..38ab41bbc 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -7095,6 +7095,14 @@ static void __md_stop(struct mddev *mddev)
>   	mddev->private = NULL;
>   	put_pers(pers);
>   	clear_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
> +
> +	if (mddev->reshape_position == MaxSector) {
> +		mddev->delta_disks = 0;
> +		mddev->reshape_backwards = 0;
> +		mddev->new_level = mddev->level;
> +		mddev->new_layout = mddev->layout;
> +		mddev->new_chunk_sectors = mddev->chunk_sectors;
> +	}
>   }
>   
>   void md_stop(struct mddev *mddev)
>
>
> base-commit: df2908090cda368b01ff43709f51890076c56157
