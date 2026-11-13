Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794573510;
	b=TX71IuIUCKUnr6sQSOhT8XvtuszT4AQohXRwCANs3CvOpCaGfkcvAqGvFSf1z3NX7S6R
	 AnsMQETpCJ4UhMDpPkDwAAZlkcJ5q3wjClZvFseWrhHHPcLfhgHNes84jtfARMVMP2W+u
	 Zwfsq3q5ECfQ0Pf7TsYfwMsr+Kgi2tSlJ7Ru7eyCyMKQEojFFHz62G3mduictwAmhDlrr
	 qTaY73n5zENigIpo5aWYo33Tnz9enztheqV25Mj7IvRmvvuHMh2CvntlydVEyCeob25FT
	 Gi3KyU+OrU9uwkNdxkE4d/Yya49OfuaaWWQcrtq52pJSKhVy+712pPhOvr6Q2sacz2A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794573510;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=ByhlRK6EFaFZEeyBNkEaLFcb6krCRfwemTI9Ed12QHI=;
	b=vsnC+Ljg5dRvPuwrCWTmBeCED7gf63DEsjIiL3EB52WtMt7y3ZpGIv2aguhSBjra21Oe
	 OeENsVwxwCi0FVAfbFii2mv5a/48wAZD4qat7aJSyv5u3jjXc0um4SSwccn+HN6X1f2Fn
	 lluroWVISm/ZuUNpkGrrTadGQiwG6D034dvfClkiPqfNeGyngQTa3kVC6pgxsRSNeb7v5
	 nm1r4+ThKtfE5gZd9xk7Qy2gWBHglCIJaCnbRIvGqZP+DHP0BBp3PMysuDg+aaaNGfXjD
	 N92jkLlyEnswUNOuGFXehnFemUkwjH9FePSYsiGi1ffovOeX2Fn64fUSM9YhtVvPIqw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=oEvkSWdN;
	arc=none smtp.remote-ip=209.85.218.50
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46788606A33E
	for <syzbot@lists.linux.dev>; Fri, 13 Nov 2026 12:38:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 46788606A33E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=oEvkSWdN
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-c4c9abc1824so177254966b.1
        for <syzbot@lists.linux.dev>; Fri, 13 Nov 2026 04:38:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794573508; x=1795178308; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ByhlRK6EFaFZEeyBNkEaLFcb6krCRfwemTI9Ed12QHI=;
        b=oEvkSWdNAmk6VO4YgV4amsXAc8D7dQgruyS2vQqsRekP7AxlwA4FPXhSaKAL+3OTmm
         dQ8HT6FeuG1zpt7728kH+VLzxfTYBPSRHM27F9qh1QGcrRFqDQbquhCxsbfXwc4hxa4U
         WCXwibcjCFIeOtP7EahdlX74rFRyjuK60XtMQEA0x11fe8jwHR3HJ4yCP4EHbdgRw4VM
         QecfPzQQR45rYLTWl4t2wF0D2YHcKPTm2/viUIF9+JJJxelIByz42j6YhP66YEQb6rFF
         E2EMUtpAfAExUYQQ/7aZV9zaaH565d6dO9Wr6w0o7umHj5LTrv4GHsLHvhuj0vWrWy3b
         T+Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794573508; x=1795178308;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ByhlRK6EFaFZEeyBNkEaLFcb6krCRfwemTI9Ed12QHI=;
        b=CgfOnnYX1NPpcdZt3Xw8arZxC6YVg/NPcxirJP9Jgbms7nD9XFQWE4cRB7cUHMFU2f
         p6VMORa9JlxR5X0i+dXOQKmDg359GETDXDCznfxlBbiopDrKtzPVoHwoeOqn0f4Sa+CK
         7MuIIWVWbweLrXbqf9zrjF7F82iiIXKWbhb4tMLAiVeJN9mH9OnyapH/VMYdmMHax1Qb
         UMvJeO6WyPREY/a7KpqRRtXBC+xNicQHFM1Hlw6mvFex1aNCMdVsftGQh/RIQq3sF/76
         st2avG/d043OKHRWU7uUNSOtPAKOQ17dsj3TvUCI665QwZqELOEL9Ak8LGey0t5TLmYf
         xZbg==
X-Forwarded-Encrypted: i=1; AL+hErHCeEdNwfI1O14qf5QaZFhV+DGSyi1NdAUuAlB9ZDOJ/rz+DzWrXh+3vO7vQOcIqc0wPFNXNT0=@lists.linux.dev
X-Gm-Message-State: APuU4Z8SKXe3oEAnzofrzAcm/l4u/EENClK9E0IiV41Srb+x4ksCIr42
	KGnOp2EHkRiHIBMQFXp+l/+Df7FU7oaXzcy3iCsa5HBZmV86x2RnasLJ
X-Gm-Gg: AYBFou1AW9Si3HnCSdfF5N3YM+RRC1kB8KWVe0GQIkJII0GqVcVcHZSb2HEbtys1Q+w
	WmchS3I21+yr4C4x5xkPlxNx+f6tTAgBI2FR8JyZJw3d7FqDW4MbcXQmH0u04QfzdA5Jrp1peGd
	0PSeRcWZEvqMSOpwCKA+EQou0QP3P823bPJPYziGTTTrWLnhcf24fnlEtXs1FGzQmztF3tdixde
	pQBfLKwnCb/s1BuAP7rbrs+41afbNywjByBaOg0D9OsbBAJxqoR0h/+RYI0HA7ebSlusua5jAe8
	14DiP7JqKsrOOagPSrCIHYKXDXANIyL6PEfaBznuOmNifHDx1WK/VlSfdUos0+imBeX1vdacY0x
	Dj/arAxNWt7FTZm02xeRUPqojBhaEFfTIrRFNwIfaDRkT4MuoslCPoIr5AHwt/18bqeBrHD6NvW
	g1K/Ws8gP5afvG0z2uezuuhOTmHfP8VYBGCNKfNPRoXIcRqCyrmHrMaxXPkLRM/xoAdNdZxMweG
	WcLDHHep6QSje6A5IaYO957pNKXZF5Z1o/9LiHkpxDBp1GEjl3A//aqDySoXsltI0AHI028H+Wy
	+KlrStiKkP27mqEeAH2WRWaLsHxHeKS79AUcds7Ij5wTe3P5
X-Received: by 2002:a17:906:1f4a:b0:c50:aa10:d898 with SMTP id a640c23a62f3a-c50aa10db4bmr17965066b.26.1794573508398;
        Fri, 13 Nov 2026 04:38:28 -0800 (PST)
Received: from localhost ([188.146.170.61])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c5095b58981sm87024266b.45.2026.11.13.04.38.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 04:38:28 -0800 (PST)
Date: Fri, 13 Nov 2026 13:38:27 +0100
From: Bartosz Chronowski <immersa.bartosz.chronowski@gmail.com>
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Subject: Re: [PATCH RFC v3] media: az6007: Fix mutex reinitialization and
 buffer overflows
Message-ID: <bwmnrlg2sseox2grlxoytyxexdo5fs3iggauzciqcbkoy6akks@o3qdmtszdgqf>
References: <391e1e11-54c8-4c10-ad15-7ea3659ec388@mail.kernel.org>
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Post: <mailto:syzbot@lists.linux.dev>
List-Help: <mailto:syzbot+help@lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
List-Owner: <mailto:syzbot+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <391e1e11-54c8-4c10-ad15-7ea3659ec388@mail.kernel.org>

Version 3 keeps the sound transfer bounds and one-time probe mutex
initialization. A matched kernel run confirms that the new rate limit cuts
repeated-error log volume, but its shared budget hides first errors from
another adapter and a distinct errno; the patch still needs a logging fix,
corrected metadata and description, and warning-specific proof.

Required changes:
- Commit message: Keep the selected mutex wait-list warning separate from
  the oversized-read UBSAN. Describe the failed-power mutex reset with a
  queued waiter as a separate targeted observation, and state that the
  selected report does not identify the store that damaged the wait list.
- Metadata: Correct the formatter-owned Fixes: trailers before submission.
  Include a2c35d346d9e for mutex initialization and b19280cf2bee for the
  buffer path in this combined patch, or route a split into separately
  described and tagged submissions. Correct Assisted-by: to the documented
  AGENT_NAME:MODEL_VERSION [TOOL] form with accurate attribution, or omit it
  if accurate attribution is unavailable.
- Code: Keep repeated identical errors bounded without sharing the first-error
  budget across adapters or errno values. Include the device and errno in
  each useful diagnostic, and preserve the first distinct error from each
  adapter. Keep the existing transfer guards and probe mutex placement.

Testing:
In matched v2/v3 kernel runs with an emulated AZ6007 adapter and a separately
enabled frontend config, each version received 430 three-byte short replies.
V2 emitted 432 AZ6007 error lines and 23,766 raw dmesg bytes; v3 emitted ten
lines and 3,087 bytes. V3 hid the first -EOPNOTSUPP line, and a two-adapter
run hid the second adapter's first -EIO and -EOPNOTSUPP errors. One paired
process-CPU sample was 52.6 ms on v2 and 100.7 ms on v3; it does not show a
CPU saving.

Syzbot flow request:
After changing the logger, rerun the repeated-short-reply and two-adapter
mixed-error checks, retaining raw logs and enough CPU and latency samples
for any performance claim. Before claiming that the selected corrupted-list
warning is suppressed, obtain a target-positive unpatched control and compare
the revised patch with the same reproducer and config. Report whether USB
reply framing was checked on physical or emulated hardware.

Context:
The selected C reproducer produced the separate AZ6007 UBSAN, not the
selected corrupted-list warning, in all four unpatched moderation-base test
VMs. No crash appeared in four patched test VMs for that input, but the
target-negative control cannot prove suppression of the list warning. The
assembled v3 recipients already use the current media maintainer address
and lists; no recipient change is requested.

Impact assessment:
The old oversized request exceeded the 4096-byte state buffer, and a short
positive reply could copy stale buffer bytes. The retained bounds and reply
checks cover those paths. The shared rate limit reduces diagnostic visibility
without changing the returned transfer error; the selected list warning's
first corrupting store remains unconfirmed.

Kind Regards,
BART CHRONOWSKI

On Fri, Nov 06, 2026 at 06:11:58PM +0000, syzbot wrote:
> A DEBUG_LOCKS_WARN_ON() warning can occur on mutex unlock due to corruption
> of the mutex wait list when state->mutex is reinitialized while in use. On
> the base commit, it was observed that mutex_init(&state->mutex) was called
> inside az6007_power_ctrl() whenever !state->warm. If the initial power-on
> command fails, state->warm remains false, causing subsequent invocations of
> az6007_power_ctrl() to reinitialize state->mutex while the device is
> active. If another thread holds or is queued as a waiter on state->mutex
> during az6007_i2c_xfer(), reinitializing the mutex clears the lock owner
> and wait list, triggering the mutex wait-list corruption warning on unlock.
> This failed-power reset with a queued I2C waiter was observed on the base
> commit, though the crash report does not prove that exact sequence.
> 
> Distinct from the mutex issue, an out-of-bounds buffer access was
> separately found in az6007_i2c_xfer(). User-controlled I2C messages
> transferred via /dev/i2c-* (through i2c-dev) can specify lengths up to 8192
> bytes. The driver uses a fixed 4096-byte bounce buffer, st->data, defined
> in struct az6007_device_state. The driver does not validate message lengths
> against sizeof(st->data) before copying data or issuing USB control
> transfers, leading to out-of-bounds buffer accesses.
> 
> When userspace reads from an I2C device (such as via preadv() on
> /dev/i2c-*), i2cdev_read() calls i2c_master_recv() -> i2c_transfer() ->
> __i2c_transfer() -> az6007_i2c_xfer() with msgs[0].len matching the
> requested read size. In the single read branch, length is computed as
> msgs[i].len + 6. If msgs[i].len exceeds 4090 bytes, length exceeds
> sizeof(st->data). Furthermore, the return value of __az6007_read() was not
> validated before copying bytes from st->data[j + 5] into msgs[i].buf[j].
> When a large read request fails at the USB level, the copy loop still
> executes unconditionally. When j reaches 4091, j + 5 equals 4096, reading
> past the end of st->data and triggering a UBSAN array-index-out-of-bounds
> warning:
> 
> UBSAN: array-index-out-of-bounds in
> drivers/media/usb/dvb-usb-v2/az6007.c:821:22
> index 4096 is out of range for type 'unsigned char[4096]'
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
>  ubsan_epilogue+0xa/0x30 lib/ubsan.c:233
>  __ubsan_handle_out_of_bounds+0xe8/0xf0 lib/ubsan.c:455
>  az6007_i2c_xfer+0x419/0xaa0 drivers/media/usb/dvb-usb-v2/az6007.c:821
>  __i2c_transfer+0x7bf/0x1fe0 drivers/i2c/i2c-core-base.c:-1
>  i2c_transfer+0x1cb/0x2d0 drivers/i2c/i2c-core-base.c:2350
>  i2c_transfer_buffer_flags+0x10d/0x1a0 drivers/i2c/i2c-core-base.c:2378
>  i2c_master_recv include/linux/i2c.h:79 [inline]
>  i2cdev_read+0x10d/0x250 drivers/i2c/i2c-dev.c:155
>  vfs_readv+0x57c/0x850 fs/read_write.c:1021
>  do_preadv fs/read_write.c:1133 [inline]
>  </TASK>
> 
> Similar buffer overflow issues exist in the other transfer paths: the
> combined write+read branch lacked checks on msgs[i + 1].len < 1 and length
> > sizeof(st->data), while the write branch copied msgs[i].len - 1 bytes
> into st->data without verifying that the payload fit within the 64-byte
> maximum supported by __az6007_write(). In addition, the read loops accessed
> st->data[j + 5] without verifying that __az6007_read() returned at least 5
> + len bytes. Additionally, in __az6007_write(), the blen > 64 check was
> performed after dumping the payload to the kernel log under
> az6007_xfer_debug.
> 
> Fix these issues by:
> - Moving mutex initialization out of az6007_power_ctrl() into a newly
> introduced probe callback (az6007_probe) that initializes state->mutex once
> upon device probing.
> - Adding upper-bound checks against sizeof(st->data) in the single read and
> combined write+read paths of az6007_i2c_xfer(), and verifying msgs[i +
> 1].len >= 1 in the combined path.
> - Making writes over 64 bytes fail with -EOPNOTSUPP before copying into the
> state buffer st->data in the write path.
> - Ensuring that short USB replies now return -EIO and that __az6007_read()
> returned at least 5 + len bytes before copying data from st->data to
> msgs[i].buf in the single read and combined paths.
> - Moving the blen > 64 check in __az6007_write() before the debug hex dump.
> - Rate-limiting error logging in az6007_i2c_xfer() with
> pr_info_ratelimited().
> 
> Fixes: b19280cf2bee ("[media] az6007: code cleanups and fixes")
> Assisted-by: Gemini:gemini-4-argon Gemini:gemini-3.8-flash syzbot
> Reported-by: syzbot+0192952caa411a3be209@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=0192952caa411a3be209
> Link: https://syzkaller.appspot.com/ai_job?id=ecf8e51b-3f73-4d50-8052-531d59d7335e
> To: <linux-media@vger.kernel.org>
> To: "Mauro Carvalho Chehab" <mchehab@kernel.org>
> Cc: <linux-kernel@vger.kernel.org>
> 
> ---
> v3:
> - Use pr_info_ratelimited() instead of pr_info() for transfer error logging in az6007_i2c_xfer().
> - Reorder the commit description to lead with the mutex wait-list corruption warning and keep the oversized buffer access issue distinct.
> - Describe the failed-power reset with a queued I2C waiter as observed on the base commit.
> - Clarify in the description that short USB replies now return -EIO and writes over 64 bytes fail before copying into the bounce buffer.
> 
> v2:
> - Require ret >= 5 + len instead of ret >= len in read paths before copying from st->data.
> - Limit write transfers to 64 bytes instead of sizeof(st->data).
> - Clarify in commit description that the crash report indicates mutex wait list corruption, distinct from the out-of-bounds read buffer issue, and that the failed-power mutex reset was observed on the base commit.
> https://lore.kernel.org/all/baa09ccd-e29d-4434-bfd6-cebf6a9b8413@mail.kernel.org/T/
> 
> v1:
> https://lore.kernel.org/all/98467e25-6e27-41d8-94d9-5367714ce9b0@mail.kernel.org/T/
> ---
> diff --git a/drivers/media/usb/dvb-usb-v2/az6007.c b/drivers/media/usb/dvb-usb-v2/az6007.c
> index 65ef045b7..b180a1913 100644
> --- a/drivers/media/usb/dvb-usb-v2/az6007.c
> +++ b/drivers/media/usb/dvb-usb-v2/az6007.c
> @@ -143,6 +143,12 @@ static int __az6007_write(struct usb_device *udev, u8 req, u16 value,
>  {
>  	int ret;
>  
> +	if (blen > 64) {
> +		pr_err("az6007: tried to write %d bytes, but I2C max size is 64 bytes\n",
> +		       blen);
> +		return -EOPNOTSUPP;
> +	}
> +
>  	if (az6007_xfer_debug) {
>  		printk(KERN_DEBUG "az6007: OUT req: %02x, value: %04x, index: %04x\n",
>  		       req, value, index);
> @@ -150,12 +156,6 @@ static int __az6007_write(struct usb_device *udev, u8 req, u16 value,
>  				     DUMP_PREFIX_NONE, b, blen);
>  	}
>  
> -	if (blen > 64) {
> -		pr_err("az6007: tried to write %d bytes, but I2C max size is 64 bytes\n",
> -		       blen);
> -		return -EOPNOTSUPP;
> -	}
> -
>  	ret = usb_control_msg(udev,
>  			      usb_sndctrlpipe(udev, 0),
>  			      req,
> @@ -694,8 +694,6 @@ static int az6007_power_ctrl(struct dvb_usb_device *d, int onoff)
>  	pr_debug("%s()\n", __func__);
>  
>  	if (!state->warm) {
> -		mutex_init(&state->mutex);
> -
>  		ret = az6007_write(d, AZ6007_POWER, 0, 2, NULL, 0);
>  		if (ret < 0)
>  			return ret;
> @@ -770,14 +768,22 @@ static int az6007_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg msgs[],
>  			if (az6007_xfer_debug)
>  				printk(KERN_DEBUG "az6007: I2C W/R addr=0x%x len=%d/%d\n",
>  				       addr, msgs[i].len, msgs[i + 1].len);
> +			if (msgs[i + 1].len < 1) {
> +				ret = -EIO;
> +				goto err;
> +			}
>  			req = AZ6007_I2C_RD;
>  			index = msgs[i].buf[0];
>  			value = addr | (1 << 8);
>  			length = 6 + msgs[i + 1].len;
>  			len = msgs[i + 1].len;
> +			if (length > sizeof(st->data)) {
> +				ret = -EOPNOTSUPP;
> +				goto err;
> +			}
>  			ret = __az6007_read(d->udev, req, value, index,
>  					    st->data, length);
> -			if (ret >= len) {
> +			if (ret >= 5 + len) {
>  				for (j = 0; j < len; j++)
>  					msgs[i + 1].buf[j] = st->data[j + 5];
>  			} else
> @@ -797,6 +803,10 @@ static int az6007_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg msgs[],
>  			value = addr | (1 << 8);
>  			length = msgs[i].len - 1;
>  			len = msgs[i].len - 1;
> +			if (length > 64) {
> +				ret = -EOPNOTSUPP;
> +				goto err;
> +			}
>  			for (j = 0; j < len; j++)
>  				st->data[j] = msgs[i].buf[j + 1];
>  			ret =  __az6007_write(d->udev, req, value, index,
> @@ -815,10 +825,18 @@ static int az6007_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg msgs[],
>  			value = addr;
>  			length = msgs[i].len + 6;
>  			len = msgs[i].len;
> +			if (length > sizeof(st->data)) {
> +				ret = -EOPNOTSUPP;
> +				goto err;
> +			}
>  			ret = __az6007_read(d->udev, req, value, index,
>  					    st->data, length);
> -			for (j = 0; j < len; j++)
> -				msgs[i].buf[j] = st->data[j + 5];
> +			if (ret >= 5 + len) {
> +				for (j = 0; j < len; j++)
> +					msgs[i].buf[j] = st->data[j + 5];
> +			} else {
> +				ret = -EIO;
> +			}
>  		}
>  		if (ret < 0)
>  			goto err;
> @@ -827,7 +845,7 @@ static int az6007_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg msgs[],
>  	mutex_unlock(&st->mutex);
>  
>  	if (ret < 0) {
> -		pr_info("%s ERROR: %i\n", __func__, ret);
> +		pr_info_ratelimited("%s ERROR: %i\n", __func__, ret);
>  		return ret;
>  	}
>  	return num;
> @@ -889,6 +907,15 @@ static int az6007_download_firmware(struct dvb_usb_device *d,
>  	return cypress_load_firmware(d->udev, fw, CYPRESS_FX2);
>  }
>  
> +static int az6007_probe(struct dvb_usb_device *d)
> +{
> +	struct az6007_device_state *state = d_to_priv(d);
> +
> +	mutex_init(&state->mutex);
> +
> +	return 0;
> +}
> +
>  /* DVB USB Driver stuff */
>  static struct dvb_usb_device_properties az6007_props = {
>  	.driver_name         = KBUILD_MODNAME,
> @@ -897,6 +924,7 @@ static struct dvb_usb_device_properties az6007_props = {
>  
>  	.adapter_nr          = adapter_nr,
>  	.size_of_priv        = sizeof(struct az6007_device_state),
> +	.probe               = az6007_probe,
>  	.i2c_algo            = &az6007_i2c_algo,
>  	.tuner_attach        = az6007_tuner_attach,
>  	.frontend_attach     = az6007_frontend_attach,
> @@ -919,11 +947,12 @@ static struct dvb_usb_device_properties az6007_cablestar_hdci_props = {
>  
>  	.adapter_nr          = adapter_nr,
>  	.size_of_priv        = sizeof(struct az6007_device_state),
> +	.probe               = az6007_probe,
>  	.i2c_algo            = &az6007_i2c_algo,
>  	.tuner_attach        = az6007_tuner_attach,
>  	.frontend_attach     = az6007_cablestar_hdci_frontend_attach,
>  	.streaming_ctrl      = az6007_streaming_ctrl,
> -/* ditch get_rc_config as it can't work (TS35 remote, I believe it's rc5) */
> +	/* ditch get_rc_config as it can't work (TS35 remote, I believe it's rc5) */
>  	.get_rc_config       = NULL,
>  	.read_mac_address    = az6007_read_mac_addr,
>  	.download_firmware   = az6007_download_firmware,
> 
> 
> base-commit: c03c1a14507dfaf8b856c2608f9ac216021fc222
> -- 
> This is an AI-generated patch subject to moderation.
> Reply with '#syz upstream' to Sign-off the patch as a human author
> and send it to the upstream kernel mailing lists.
> Reply with '#syz reject' to reject it ('#syz unreject' to undo).
> 
> See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
> You can comment on the patch as usual, syzbot will try to address
> the comments and send a new version of the patch if necessary.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
