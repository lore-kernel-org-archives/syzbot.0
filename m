Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D278E4B8277
	for <syzbot@lists.linux.dev>; Thu,  8 Oct 2026 14:53:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=100.103.45.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791471232; cv=pass; b=pFByqyl6OaerkQJdriel4PXJjryKUkljJLhTr0JFJFreSxyG8JLz1MDMOYU+awuWHExQep+GRPImuDRlyBa1896+HGGvnvQ2nu/p5lGfi5+k88VyJqJsyjORR9RlRHRpQ/9ms01qEGPYVqKah0lWfRH65P3D0rjzHwlWicHDYE0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791471232; c=relaxed/simple;
	bh=ZUDhlRz7n3MqOfIKAlkE0SET0e/DHD7eqMBz/N+WkXg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iXx3lSRtFiiJ2VntUtpaGESN/b/8W7VNSvWsDvWhwGA+Y8J2ybt9406uMaU7l+DxVoENgogs18GCX7wFg/XkWYQZ/jldFNEPSB2n7jhyxAay2Y67BtD7rNhsdIjCQdKFncvjmC8pPM5k7TU8/k1b8T0OdLfLG0FaD4fFdxEztQ8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WO80BWBl; arc=pass smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WO80BWBl"
Received: by smtp.kernel.org (Postfix)
	id 8C8C21F00893; Thu,  8 Oct 2026 14:53:42 +0000 (UTC)
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=209.85.221.51
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1791471222;
	b=U4SkisFRiXuX3x+1EzL0ljFgn867rbBNVf/Gcuw2AGgeUCOEeE/sB6YLWdjcsmQm5Ip7
	 2U60nKRhtqEpblOUvs09AEMiwCtnANXkn+VxSNjneFTYulkS5ZXaCx/0fu88nVqc6kmUf
	 S0Y37bp5RxE5T5nsvsDiKulaomowJIUUqkDsZZ9PlK8DjKqkDPZ3dMnMj5nWT0pUsUvNv
	 rM5uNco94pLp5QDMjBDaxr/4SZgudjkJfFINol+NkxcllEwJvn3Y2o55uVNZFMjNKJi2m
	 g3G9WWSkq5+GJpS3feRq6EsxtX3P8yvyuRpVvRKFx6LB7kOui2s5oUMGpPdqXibUHyQ==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1791471222;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=IlmhEHpoaCJJ/so+oF2G5zgKRLdDXZ0yN/faJTT9N/E=;
	b=cSs+0InY/7JSP0VeiqZ8xe/L+1BOm8/zlYWo2Ntg/Eb03hp2gpop5HyjL6tP/LyeSXNm
	 uUqRRX9+QWgTPtEKmkJ+AXmsevw+WlTQqk5ef+GeGz65Ee3RkANU4Jf1Z6xD3ry6gYQRF
	 cNDpTr/BrhyHvZ/aB1HwHk1VMaXIKZQ/P8Eg/l2GyvvJ1NW+PEHwTaXZJy7l7dTrOuUtB
	 m37Uk+fmGWqFcxt6eo99MevYt9AJ+UTH6s/poi1FUblT7K0L6xfRJeHrR3MSsrWot40a5
	 f4yxutuCfucIpe06NLjc3wQe21FpUwDaWmw15aQAnlPT7Lar3aRUfcawfxCyjSlMjlw==
ARC-Authentication-Results: i=1; smtp.kernel.org; dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=WO80BWBl;
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	arc=none smtp.remote-ip=209.85.221.51
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id CA5EF1F000FF
	for <syzbot@kernel.org>; Thu,  8 Oct 2026 14:53:41 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=WO80BWBl
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.kernel.org CA5EF1F000FF
Authentication-Results: smtp.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-48c45111bebso2068585f8f.0
        for <syzbot@kernel.org>; Thu, 08 Oct 2026 07:53:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791471220; x=1792076020; darn=kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=IlmhEHpoaCJJ/so+oF2G5zgKRLdDXZ0yN/faJTT9N/E=;
        b=WO80BWBlI23PvozbCH67PuOhM7/cNj3D3aHXums0m8AXQtv/8P1qbtDcfuHAjErmuN
         U5N1TKfcvdkkH/Yyo8nQ4DXGMtN48ILLW6LsEqUnFqH29E4xXXDuIGJnWe0yOifMlYPE
         Qj3do6fvpGdowbaCacxdssj2xHKvKajCiymBmoK0MfVADCwRANbRKiU4BTLvmrZMPu8v
         vs/qnqYxQCvGddozAp11ICOtlmh0V6fILosVbfZQGGT0oKiZ2jSCjU1in2fwURCfPV+u
         IYuTJl9R/OH78GfS2ahqs5Fn0+L9agRBaEGPHwStYVaTLKCe8R9nr0w/En/t5SRWlY4U
         FNzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791471220; x=1792076020;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=IlmhEHpoaCJJ/so+oF2G5zgKRLdDXZ0yN/faJTT9N/E=;
        b=eBsrh2gyFpoqjw2OuIUaEcrlVvE5jiKsxS2l+9ZEHOxziRt5UsIIjE5Z38nd2+rqi3
         i0mfnSKrajpkdrbZQEXLECZDMkCgvMg/Y6O5sTHYmoHWdc2Qz/Jx/Bf5PJ1H3yMzntSL
         UebeELtAvhhJsMhZJ+efOP/MWu/0Ey/HwcZ30Oq1z1KFRN6XFRHeRCVGNEI3SZYxP2x9
         PT/ynVPg874Y/QUVyvpa7wsbuejbk0vyOavp24MlchR5SksQQAtb1/d9W1FyQNE2vZiM
         DYFMvMXfj1dtVXSs4AdNFaDW9wIfDumq1imJXcjADS5QQdj9K4csyGtfxEOt6IVwa5es
         JzCQ==
X-Gm-Message-State: AFuF++nonTrlMW9dVMQlKQUCCceWMI+4ipGqHfWhgc4TSo/p2fQG+X4r
	JH7WgyVqUHQDM+mvr4fXiVfCOyeD9LRfuAq5EYOBOHGW/OW4UERE0hpqJAet5ywX
X-Gm-Gg: AYBFou0WyHtTevz06ecCpxs2DL+fSNaYrtIADx7lH0ZU3SXB87e/r0DIH1FS+ylLhtu
	XXh89oEtFSLbe5KTUtoHzdrNKDHqtOoujRrMVHTapAAwHiXXpN8aQmaymwqndg4+YKClZKimmWh
	CPBCMA9DV5WZj1f+fC+V4rRCi89qetoLJM2r+1MPsefptY7VR5s/at8hpjtypXhV4Hm6hnd/P5J
	m9gLgYPjwfMyoc6TkmYNRJHPW01AdoRcp7KLCHhnIXTLBV4KgIsomYm8vQBjHDrJPIDxH5JKiEI
	O7RYFlDcwRxwPekRzcaOryP9oxLCD/cNxY9lYxrPlZWHvcWuejtkqdashnv4XjtUuSudo7YH5B6
	50HR4xJaAYIWt3HNatFwHWq6ZF7Mi4juHLhMqvXKNc2rM8wHhBQ1XaYuZ5o6RMsAEFQdyHWvBn3
	p8t2KxSR0AwEofvWDfExEH1YnWwHYL14FTIIGe3JZoCU9dSSaGHqWklE+sSAFPyoyVZbWS8sI6Q
	PGRnCNXbRFZgi6/ATQUy5bb6s1aviTvBs2C/ZLJo+LTr4RhmCODerfLsOhFpHcDOoCyoQIydMVW
	De++5D/LKD/dRyGAjlUK6FF6d17wYccWAEm3eWdMYH1OEWYg0bhX8pR+BDuaDftmMD8XT5LgOvD
	au+sVV8Wb6ws4TKsLHTN57y7Ac3v3bwgGEQ==
X-Received: by 2002:a05:600c:1551:b0:4a0:1c0e:b2a8 with SMTP id 5b1f17b1804b1-4a18043cbd5mr96812475e9.28.1791471219759;
        Thu, 08 Oct 2026 07:53:39 -0700 (PDT)
Received: from [192.168.100.100] (87-205-15-91.static.ip.netia.com.pl. [87.205.15.91])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a184262f8asm75690025e9.0.2026.10.08.07.53.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Oct 2026 07:53:38 -0700 (PDT)
Message-ID: <5e4ead68-38c7-455d-9d83-5f6ffee4c214@gmail.com>
Date: Thu, 8 Oct 2026 16:53:37 +0200
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC] kernfs: drop splice_write support
To: syzbot <syzbot@kernel.org>, syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
References: <af4efe2d-7856-46ff-9088-28400130dbce@mail.kernel.org>
Content-Language: en-US
From: Krystian Kaniewski <krystianmkaniewski@gmail.com>
In-Reply-To: <af4efe2d-7856-46ff-9088-28400130dbce@mail.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 9/24/26 09:11, syzbot wrote:
> A circular locking dependency was detected between &pipe->mutex (in str=
uct
> pipe_inode_info), &of->mutex (in struct kernfs_open_file), and
> &sbi->pipe_mutex (in struct autofs_sb_info).
>=20
> The cycle arises from two conflicting execution paths:
>=20
> First, splicing data from a pipe into a kernfs file (such as a sysfs
> attribute) invokes iter_file_splice_write(), which locks the pipe via
> pipe_lock(pipe) (&pipe->mutex) and then calls kernfs_fop_write_iter(),
> acquiring mutex_lock(&of->mutex). This establishes the dependency
> &pipe->mutex -> &of->mutex.
>=20
> Second, a regular write to a kernfs attribute (such as /sys/power/resum=
e)
> acquires mutex_lock(&of->mutex) in kernfs_fop_write_iter() and invokes =
the
> attribute's store handler (resume_store()). In resume_store(), path
> resolution via lookup_bdev() and kern_path() can traverse an automount
> point managed by autofs. This triggers autofs_d_automount() ->
> autofs_wait() -> autofs_notify_daemon(), which acquires
> mutex_lock(&sbi->pipe_mutex) and writes a notification packet to the
> automount daemon pipe via __kernel_write(). That write enters
> anon_pipe_write() -> anon_pipe_prefill_and_lock() and acquires
> mutex_lock(&pipe->mutex). This establishes the dependency &of->mutex ->=

> &sbi->pipe_mutex -> &pipe->mutex.
>=20
> Because all anonymous pipes share the same lockdep lock class
> (&pipe->mutex), this creates an ABBA circular locking dependency:
>=20
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
> WARNING: possible circular locking dependency detected
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
> task is trying to acquire lock:
> ffff888113c20c60 (&pipe->mutex){+.+.}-{4:4}, at:
> anon_pipe_write+0x28f/0x1a30 fs/pipe.c:534
>=20
> but task is already holding lock:
> ffff888115813938 (&sbi->pipe_mutex){+.+.}-{4:4}, at:
> autofs_notify_daemon+0x72a/0xe80 fs/autofs/waitq.c:164
>=20
> which lock already depends on the new lock.
>=20
> the existing dependency chain (in reverse order) is:
>=20
>  -> #2 (&sbi->pipe_mutex){+.+.}-{4:4}:
>        __mutex_lock+0x19d/0x1550 kernel/locking/mutex.c:821
>        autofs_notify_daemon+0x72a/0xe80 fs/autofs/waitq.c:164
>        autofs_wait+0x11bd/0x1880 fs/autofs/waitq.c:426
>        autofs_d_automount+0x64e/0x810 fs/autofs/root.c:410
>        kern_path+0x3d/0x150 fs/namei.c:3036
>        lookup_bdev+0xc8/0x2b0 block/bdev.c:1268
>        resume_store+0x16f/0x4f0 kernel/power/hibernate.c:1278
>        kernfs_fop_write_iter+0x3a4/0x540 fs/kernfs/file.c:345
>        vfs_write+0x612/0xba0 fs/read_write.c:687
>        ksys_write+0x150/0x270 fs/read_write.c:739
>=20
>  -> #1 (&of->mutex){+.+.}-{4:4}:
>        __mutex_lock+0x19d/0x1550 kernel/locking/mutex.c:821
>        kernfs_fop_write_iter+0x1d8/0x540 fs/kernfs/file.c:336
>        iter_file_splice_write+0xa31/0x1240 fs/splice.c:736
>        do_splice+0xc3e/0x16a0 fs/splice.c:1349
>        __do_sys_splice fs/splice.c:1634 [inline]
>=20
>  -> #0 (&pipe->mutex){+.+.}-{4:4}:
>        __mutex_lock+0x19d/0x1550 kernel/locking/mutex.c:821
>        anon_pipe_write+0x28f/0x1a30 fs/pipe.c:534
>        __kernel_write+0x106/0x170 fs/read_write.c:641
>        autofs_notify_daemon+0x73d/0xe80 fs/autofs/waitq.c:164
>        autofs_wait+0x11bd/0x1880 fs/autofs/waitq.c:426
>        autofs_d_automount+0x64e/0x810 fs/autofs/root.c:410
>        kern_path+0x3d/0x150 fs/namei.c:3036
>        lookup_bdev+0xc8/0x2b0 block/bdev.c:1268
>        resume_store+0x16f/0x4f0 kernel/power/hibernate.c:1278
>        kernfs_fop_write_iter+0x3a4/0x540 fs/kernfs/file.c:345
>        vfs_write+0x612/0xba0 fs/read_write.c:687
>        ksys_write+0x150/0x270 fs/read_write.c:739
>=20
> Fix this by removing .splice_write =3D iter_file_splice_write from
> kernfs_file_fops. Kernfs attributes (sysfs, cgroupfs) are control
> interfaces designed for small configuration strings and numbers, rather=

> than high-throughput data streams. Kernfs does not do page-cache zero-c=
opy
> writes; kernfs_fop_write_iter() allocates a kernel buffer and copies da=
ta
> from the iterator via copy_from_iter(), so splice_write provides no ben=
efit
> over write(). In addition, kernfs write callbacks invoke arbitrary
> subsystem callbacks across the kernel, and holding a generic VFS lock l=
ike
> pipe->mutex across them breaks subsystem layering and creates lock
> inversion hazards whenever an attribute callback interacts with pipes,
> usermode helpers, or automounts. Dropping .splice_write aligns kernfs w=
ith
> other pseudo-filesystems such as procfs, debugfs, tracefs, and configfs=
,
> and causes splice() into a kernfs file to return -EINVAL.
>=20
> Fixes: f2d6c2708bd8 ("kernfs: wire up ->splice_read and ->splice_write"=
)
>=20
> Fixes: f2d6c2708bd8 ("kernfs: wire up ->splice_read and ->splice_write"=
)
> Assisted-by: Gemini:gemini-3.8-flash Gemini:gemini-3.1-pro-preview syzb=
ot
> Reported-by: syzbot+002fb7b2d0bc53bf7e75@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3D002fb7b2d0bc53bf7e75
> Link: https://syzkaller.appspot.com/ai_job?id=3Db88d0e47-6c54-4575-a4c8=
-62628424d6ba
> To: <driver-core@lists.linux.dev>
> To: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
> To: "Tejun Heo" <tj@kernel.org>
> To: "Christoph Hellwig" <hch@lst.de>
> Cc: <linux-kernel@vger.kernel.org>
>=20
> ---
> diff --git a/fs/kernfs/file.c b/fs/kernfs/file.c
> index 8e0e90c93..2f87e426c 100644
> --- a/fs/kernfs/file.c
> +++ b/fs/kernfs/file.c
> @@ -1015,7 +1015,6 @@ const struct file_operations kernfs_file_fops =3D=
 {
>  	.poll		=3D kernfs_fop_poll,
>  	.fsync		=3D noop_fsync,
>  	.splice_read	=3D copy_splice_read,
> -	.splice_write	=3D iter_file_splice_write,
>  };
> =20
>  /**
>=20
>=20
> base-commit: 93f51579e7df248780214094418f205253383cc5
Please keep .splice_write in kernfs_file_fops and fix the lock dependency=
 inside kernfs instead, by not holding of->mutex while the ->store() call=
back of a regular sysfs attribute runs.

Removing .splice_write does not remove the dependency that lockdep report=
ed. splice_file_to_pipe() also holds the pipe locked while copy_splice_re=
ad() calls ->read_iter(), and kernfs_seq_start() or kernfs_file_read_iter=
() then takes of->mutex. For a file opened with O_RDWR this is the same l=
ockdep class that /sys/power/resume uses when it is written. A splice fro=
m such a file into a pipe, followed by the write to /sys/power/resume, re=
cords the same cycle through &of->mutex and &sbi->pipe_mutex, and with on=
e shared open file of /sys/power/resume and the autofs daemon pipe two ta=
sks can still deadlock. The change also makes splice() and sendfile() int=
o every kernfs file fail with -EINVAL, for sysfs text and binary attribut=
es and for cgroup files. Commit f2d6c2708bd8 restored exactly this suppor=
t after users reported that sendfile() and splice() into sysfs files had =
stopped working, so it has to stay.

The dependency that has to go is the one from of->mutex to whatever ->sto=
re() takes or waits for. sysfs_kf_write() calls ops->store(kobj, attr, bu=
f, count) and does not pass the open file, so a ->store() callback keeps =
no state per open file, and two opens of the same attribute already run i=
t concurrently. Add a bool to struct kernfs_ops, for example write_unlock=
ed, for ->write() callbacks that do not need to be serialized per open fi=
le. Copy it into struct kernfs_open_file in kernfs_fop_open() next to ato=
mic_write_len, because the ops table may only be read with an active refe=
rence and of->mutex nests outside it. In kernfs_fop_write_iter() take of-=
>mutex only if the cached flag is not set, release it under the same cond=
ition, and make sure that the path on which kernfs_get_active_of() fails =
does not unlock a mutex that was never taken. Set the flag in the four sy=
sfs kernfs_ops tables that use sysfs_kf_write(): sysfs_file_kfops_wo, sys=
fs_file_kfops_rw, sysfs_prealloc_kfops_wo and sysfs_prealloc_kfops_rw. Le=
ave of->prealloc_mutex as it is, it protects the preallocated buffer. Kee=
p of->mutex for the read side and for cgroup, resctrl and binary sysfs at=
tributes, whose callbacks receive the open file, and keep both splice met=
hods. Do not change autofs, splice or the pipe code. Document the new fla=
g at its declaration, say at sysfs_kf_write() why it is called without of=
->mutex, and add to the comment about the lockdep keys in kernfs_fop_open=
() that regular sysfs attributes no longer run ->store() under of->mutex.=


The subject and the commit message have to follow the new change, for exa=
mple "kernfs: do not hold of->mutex across sysfs ->store()". Quote the ch=
ain of the report in one line (&pipe->mutex --> &of->mutex --> &sbi->pipe=
_mutex) and explain its two halves: splice calls ->write_iter() or ->read=
_iter() of the kernfs file with the pipe locked, and resume_store() resol=
ves the written path under of->mutex, where an autofs mount writes its re=
quest to the daemon pipe. Say that ->store() no longer runs under of->mut=
ex and why that is safe, that other kernfs users keep the serialization p=
er open file, and that attributes with a preallocated buffer still run ->=
store() under of->prealloc_mutex. Use a single Fixes: 1e8c813b083c ("PM: =
hibernate: don't use early_lookup_bdev in resume_store"), the commit that=
 made resume_store() resolve a path, and remove both Fixes: lines for f2d=
6c2708bd8. Do not claim that every cycle is gone. A pipe that is spliced =
into such an attribute stays locked while ->store() resolves the path, so=
 lockdep can still report that pipe mutex against the autofs locks withou=
t of->mutex. A callback that holds a lock of its own across the lookup an=
d takes it in ->show() as well, such as a module parameter whose setter o=
pens a path, keeps a dependency through that lock. Keep the Reported-by, =
Closes, Link and Assisted-by tags.

While rewriting the message, please also keep it short. The lockdep trace=
 of more than 40 lines is not needed, the one line with the chain is enou=
gh. Leave out the comparison with procfs, because /proc/sys files do prov=
ide .splice_write.

--=20
Krystian Kaniewski
