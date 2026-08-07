Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B08F1A9FB7
	for <syzbot@lists.linux.dev>; Fri,  7 Aug 2026 10:18:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786097898; cv=none; b=DEMZURXycl+ItJRnUi692E/RmN5R/mXMoQoZiRxR06OC1nddLfeL/OenkBnH+DgsSxFCXaW+aJKFtq+vvcv6tNCoYwf3VGuUKVdTeS14lj/zIIxb+ylt8YI0bEg3/p0aVVtrTjwdFGuXQ5dzx4sPGwLdNn0aWeW1KWoe3hHtNUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786097898; c=relaxed/simple;
	bh=wvMnncUteHPExM7e/0bTT2X0HRxyEZZGFcPdHutbbfE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nsxJ0D1Xi9gTl80SLvXaum1ulkMC3c0pjZ3cVcVoDQz59QqbCdajblWWRuQ7Yk9tqrUJXTDersug3esc8BiH56YJbZIX1mtqKpwodBeWp57ZHtIirP+V5Ky1PGAx2j9ZltwX1plrNx6QODcdKMDxhm2GCWnfDLvxUsqeESQq6jE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MhWOtdhT; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MhWOtdhT"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4955aa106b1so28054335e9.0
        for <syzbot@lists.linux.dev>; Fri, 07 Aug 2026 03:18:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786097894; x=1786702694; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=qxTa/ZBtGMKDMLBbFcTLlIghDTBkFRKsN0B4WO3iXak=;
        b=MhWOtdhTCrSHzXsWgDl3aqIpGdFv0XyJAcwLzu9gSn3iMDtlQEYpvjPBp32qJqM09e
         a+mtexQXzS8+YZ8yWipJJcnNErVwXVksRwEmboRo3XxRmVyQbfv7zQ7UmsXuSybKqCGf
         ua52Bz4KFlHOQD+iLHPldk6m36/oHyRuA7m7ifsFn6JoMOvw3pm7AX0QACU9Cqee1bYf
         0PcywsfhMXEKJ7FyZ66CXzKjuEclp6Esaxh9etqsjpsfj4iq2HwBzjAgI++4o7t8xYiU
         wRmt23C68wQroggYsf3r1l6xK6TTAP5awYx69+PZy+xn6tRRh9devBSHL5EIHDigMva2
         gAxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786097894; x=1786702694;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=qxTa/ZBtGMKDMLBbFcTLlIghDTBkFRKsN0B4WO3iXak=;
        b=pL+aceLTQVurkB2hVkX8HmQf/IuJ384CD/IO/Hhl0pm+7nvoKl6OIIOv20gzUb8P23
         EY4dTwheJhPlxgS/yUF+aQgdJdu3zBTe+4DlGKFGhkVhxLOYxAG4FIm7XAiKQnAJU3hO
         YfOfxYNRyjTM06Ed0KWTqldtt99QtZu1s+INYuWCP9r/bXYTL7+g/mwGnHonRGTMqUFo
         pte4AYoM/yUvMfDg6n++2KIpCZBLN5hqNU3iXGRVR3631Hc+MMUpfQjwh0VzI82wrm0K
         mwWSj0BTBi3dMlpZ6KzFDHohIQC4Xl4mK7SN5ltvkMZuvCY4+c1AoK9zxkHqGtn+wlqz
         Qi3A==
X-Forwarded-Encrypted: i=1; AHgh+Ro8YuF5qrfm2dcUNVCyrZGK1mM6UZ+qT0ZB0xeL4hSOvVBEJgGqjG0we/x9lHz8t+/+GkMbMTs=@lists.linux.dev
X-Gm-Message-State: AOJu0YyklutRVQ97M1OFLwoD/wRzRBGSB1ntu+lws0pXyzVJkxBdUDGl
	w3yQ7PaPNVNDIgB+CFVs/A+5/PychdEV65jQWah0QuEuiRbt9OZo8+wi
X-Gm-Gg: AR+sD10ESlHcpxBfXegpQMPBbY5j2g+nGuacbHnqRf1AKqR9hcXbpYU9WEd7QkrHytB
	UApzGy+oja/DbKLZ/VSdkifBeBeZ6RW2OhVzGU2X8jvR354tfeNKTr0jjcfLVvaPYaPsZ5jHCMG
	xstzybn9stLJskEcG7PoZBcup7GsO0pWdLIb7V0UE67fn7Q3TgXtgqDPN5jl7ZGBIH9RXnLn5lw
	0qIUVPUr9Op7nR2/SEfHs2ia9mlqnUpzru+jqL9ggPl+WA+DZf2g5Au1j1F7Wssq3CyqkKXS7ba
	0tdRwHDF1qwjGke9Y5O4dQJGN831D9F8e5yTn5tlU8Kd6/y/CMFqiuQbR+zw6rZ3OxZBg1pjVhk
	fLzEiV21HLQaepio2cUYk7kHqvNrDsSFW7VFbW8NSITjhRZUshkXdT9LkwOy0IgdGkg22il1nzW
	TI+mCk0j0Npz493zt53rXSJSv0rUFmRCpdId0QWxyHfwzuplTN4QaTE4bciPzklhnihvnzkIY0w
	qaEOUGDZSyeAA==
X-Received: by 2002:a05:600c:a47:b0:496:c379:b2a1 with SMTP id 5b1f17b1804b1-4994e71296fmr279313355e9.2.1786097893830;
        Fri, 07 Aug 2026 03:18:13 -0700 (PDT)
Received: from localhost ([37.30.44.17])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4995bdca3ddsm42943795e9.1.2026.08.07.03.18.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Aug 2026 03:18:13 -0700 (PDT)
Date: Fri, 7 Aug 2026 12:18:12 +0200
From: Bartosz Chronowski <immersa.bartosz.chronowski@gmail.com>
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Subject: Re: [PATCH RFC] smb: client: fix double decrement of
 server->in_flight
Message-ID: <gn67lcblu7pgg6mmh5dstx2mlmkh3mzdv2m3te5crxnxz2xykd@lzin2sfbp5iy>
References: <05aeff9e-78c8-4060-8efb-7debe418f6dd@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <05aeff9e-78c8-4060-8efb-7debe418f6dd@mail.kernel.org>

The v1 code change direction is correct: failed-send and no-response MIDs are removed
before cifs_server_unlock(), and cancelled_mid[] makes the common cleanup skip
the MIDs already removed there. The exact-base reproducer hit the warning in
4/4 unpatched runs and 0/4 patched runs; all four patched runs completed the
full 270-second window. The patch is not yet correct.

Removing each MID from pending_mid_q while the server mutex is held prevents
reconnect cleanup from taking callback ownership. The sender then remains the
sole owner of the credit return, while successful response-bearing requests
keep their existing callback-owned accounting.

For v2:

- Replace the claim that server->in_flight becomes -1. The counter is unsigned,
  so the second decrement wraps it to UINT_MAX.
- Lead the description with the failed-send/reconnect trigger: reconnect can
  process a still-queued MID before the sender returns the same reservation.
  Evaluate and stet if the resulting double completion corrupts request accounting and
  can affect availability.


On Mon, Aug 03, 2026 at 09:32:40AM +0000, syzbot wrote:
> There is a race condition between the error handling path in
> compound_send_recv() and the cifsd reconnect thread that can lead to a
> double decrement of server->in_flight.
> 
> When smb_send_rqst() fails (e.g., with -ECONNRESET), it signals the cifsd
> thread for a reconnect. If compound_send_recv() drops the
> cifs_server_lock(server) before removing the multiplex IDs (mids) from the
> pending queue, the cifsd thread can wake up, acquire the lock, and execute
> cifs_abort_connection().
> 
> cifs_abort_connection() iterates over server->pending_mid_q, finds the mids
> that failed to send, and executes their callbacks (cifs_compound_callback).
> Because no response was received, the callback calls add_credits() with 0
> credits. smb2_add_credits() unconditionally decrements server->in_flight,
> even if the number of credits being added is 0.
> 
> After the callback finishes, compound_send_recv() continues its execution,
> sees that rc < 0, and explicitly calls add_credits() to return the credits
> it originally reserved. This results in a second call to
> smb2_add_credits(), which decrements server->in_flight again. Since
> in_flight was already decremented to 0 by the callback, this second
> decrement triggers a warning and corrupts the counter to -1.
> 
> CIFS: VFS: \\127.0.0.1 Error -104 sending data on socket to server
> ------------[ cut here ]------------
> server->in_flight == 0
> WARNING: fs/smb/client/smb2ops.c:104 at smb2_add_credits+0x1249/0x2b70
> fs/smb/client/smb2ops.c:104
> Call Trace:
>  <TASK>
>  add_credits fs/smb/client/cifsglob.h:894 [inline]
>  compound_send_recv+0x13b4/0x2b90 fs/smb/client/transport.c:979
>  cifs_send_recv+0x42/0x60 fs/smb/client/transport.c:1106
>  SMB2_negotiate+0x164d/0x4030 fs/smb/client/smb2pdu.c:1188
>  cifs_negotiate_protocol+0x45d/0x680 fs/smb/client/connect.c:4043
>  cifs_get_smb_ses+0x1104/0x1ff0 fs/smb/client/connect.c:2492
>  cifs_mount_get_session+0xf1/0x450 fs/smb/client/connect.c:3578
>  get_session fs/smb/client/dfs.c:65 [inline]
>  dfs_mount_share+0x22e/0x990 fs/smb/client/dfs.c:275
>  cifs_mount+0xcc/0xbf0 fs/smb/client/connect.c:3860
>  cifs_smb3_do_mount+0x2d0/0x8a0 fs/smb/client/cifsfs.c:1024
>  smb3_get_tree_common fs/smb/client/fs_context.c:897 [inline]
>  smb3_get_tree+0x2dd/0x400 fs/smb/client/fs_context.c:917
>  vfs_get_tree+0x92/0x2a0 fs/super.c:1700
>  fc_mount fs/namespace.c:1198 [inline]
>  do_new_mount_fc fs/namespace.c:3765 [inline]
>  do_new_mount+0x319/0xdc0 fs/namespace.c:3841
>  do_mount fs/namespace.c:4174 [inline]
>  __do_sys_mount fs/namespace.c:4390 [inline]
>  __se_sys_mount+0x31d/0x420 fs/namespace.c:4367
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>  </TASK>
> 
> To fix this, ensure that the cifsd thread cannot observe these mids if the
> request failed to send (rc < 0) or if no response is expected (flags &
> CIFS_NO_SRV_RSP). By calling delete_mid() before dropping
> cifs_server_lock(server), we safely remove the mids from the pending queue
> while still holding the mutex. This guarantees that cifs_abort_connection()
> will not find them and will not execute their callbacks. We also set
> cancelled_mid[i] = true so that the common cleanup code safely skips the
> already-deleted mids, preventing any double-free issues.
> 
> Fixes: ee258d79159a ("CIFS: Move credit processing to mid callbacks for SMB3")
> Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot
> Reported-by: syzbot+eeb58d2197d88720a228@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=eeb58d2197d88720a228
> Link: https://syzkaller.appspot.com/ai_job?id=53130d26-0860-4523-bf44-fbc757857958
> To: <linux-cifs@vger.kernel.org>
> To: <samba-technical@lists.samba.org>
> To: "Steve French" <sfrench@samba.org>
> To: "Pavel Shilovsky" <pshilov@microsoft.com>
> Cc: "Bharath SM" <bharathsm@microsoft.com>
> Cc: <linux-kernel@vger.kernel.org>
> Cc: "Paulo Alcantara" <pc@manguebit.org>
> Cc: "Ronnie Sahlberg" <ronniesahlberg@gmail.com>
> Cc: "Shyam Prasad N" <sprasad@microsoft.com>
> Cc: "Tom Talpey" <tom@talpey.com>
> 
> ---
> diff --git a/fs/smb/client/transport.c b/fs/smb/client/transport.c
> index fdf4e50c2..8d14225e9 100644
> --- a/fs/smb/client/transport.c
> +++ b/fs/smb/client/transport.c
> @@ -968,6 +968,13 @@ compound_send_recv(const unsigned int xid, struct cifs_ses *ses,
>  		server->sequence_number -= 2;
>  	}
>  
> +	if (rc < 0 || (flags & CIFS_NO_SRV_RSP)) {
> +		for (i = 0; i < num_rqst; i++) {
> +			delete_mid(server, mid[i]);
> +			cancelled_mid[i] = true;
> +		}
> +	}
> +
>  	cifs_server_unlock(server);
>  
>  	/*
> 
> 
> base-commit: 075b74841bd0065a3bda3440873c747938e69b68
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
> 
