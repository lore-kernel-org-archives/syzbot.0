Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89F203B47E2
	for <syzbot@lists.linux.dev>; Tue, 21 Jul 2026 20:47:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666865; cv=none; b=tmbV05iMp//o/mcWJ3WXFQK2JpAqpVYrEAtS4PnHbEE8kb+q+IFRdbWKTyFMMP0q/PFaZN4hONoW2OUIzPtO9RVCt77V35vuEr2UmMYvtRT2Wdk6UzNdIySjeCOD0n/8Uo/fPn07621FONpfowPPpTzEKwhn4NFN/MLuqFTHZgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666865; c=relaxed/simple;
	bh=4GdCxQHpm1dfuuT7pTUz6ZJAUZJG7zEe5oMuejpfkZg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=m69iMniWxA6Pt6n4/vdAjNkBhi90FaCCU6chCA4KYx1eLEJo4PLtAy8YhZ2k+fhDR+toE3zd0Mn4IXsE9LdWt/tEK8NiolvxtyYXQyx9xyni8zn4i6RO3EhGSFVRsju+n2P4FJjTOo9oEdwwBO0DRvO+s3tngPdClFo5RYo3gIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SeHYWAJd; arc=none smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SeHYWAJd"
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-6986578d8c0so18368217a12.1
        for <syzbot@lists.linux.dev>; Tue, 21 Jul 2026 13:47:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784666862; x=1785271662; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Zhj9h72GMYOB/umIZkhqr7SOHFhH6DffYYGInFNkOlg=;
        b=SeHYWAJdj3F8nrVt249j30GMvCAGhm4lnaJdce5ynDcdnxqPu4b80MmaGjcly8ih+M
         BGjfiaw57FbQcgV65cw2F9leNPPV4TpTe1kYX4mCKfbQFBuBq/8+dhFAUSjKBqWk0ERz
         9tkYrQW/yR3mvnkJbBLeVRQOXLFuomsm0sKCrIP8LM4CGcyuafEKHE84aHbim3UM44ea
         pnmTIGJbFpR/0pvReNexejsVII2k7p5lXgOeOyBTupCGnKG8MwYspy0MJ8cKrhVDhwyt
         giXOrWTadK12e19QaEQAK9AugzI/quS1Q6RM1q3Yql/czGggI9+9HXET5CMQU4WSCirJ
         zeBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784666862; x=1785271662;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Zhj9h72GMYOB/umIZkhqr7SOHFhH6DffYYGInFNkOlg=;
        b=a5HuYFIB7bgUDgMsFUjgWfptQXUy4DRJEujGBMWWSCGTebDJzGZXKpHKdxpdD3ZDON
         dJryYa6rWgjb7z3/CPZ58gWDZR+HZF98LFLFpPsXKGgwMVAeBrP7SFZngC7vhyc/biC8
         9OB0V+NnXOzuMJutmp+743vAq+S4LRZBCVBp9gY2maR46X/TyE3LmYkLrarLeW9zR+Zg
         hqXyLxpKvGzfFkceo3UWKYMbjqG5VLdLlTtUAaAWLEvlwGOk6ZP8P1rTKuzVkIeB9Sjz
         J9hH4kb6Kds9DHdclRjVL6l1MTQVJ3OxrSyTwLnMb2Y3aAXyehJ0H+2Db8GtMKUrY4Lf
         JVMQ==
X-Forwarded-Encrypted: i=1; AHgh+RpPQYnDg64l4xlt7bQjFdr+xQSHjCzeYM/zZB//PBjy7EtJAg1iSsdt+DAtxnDcg7RMjY6oqiU=@lists.linux.dev
X-Gm-Message-State: AOJu0YznV3DntNOM19L/rKSYLkdoHhhDqgu9DncTHJ5yz73yeaIbnfOo
	r7AL2LlBKA/dJygJDapMFj5r0T1Wm2mpjwE+pedOeIXkjJ5iD0+l3M/Dgq2R8tuI9dI=
X-Gm-Gg: AR+sD10Gn17Gmj1Qw8yPaJzf28WrADBB2UlmnnnCOuJUXWF4fnDOsR9EzWQozFG4xGO
	b987msC12aPo8+tD3/NYhRn/A+PVQglUbkPsqByTXs3lUEcL7fGzxSKr/PX90FkptSK6OQy+amJ
	RvnUKFtGjILU0FJw9X50+5wcv/Lo09rVCjW8jJlxjSBj/KhB8/O62I+wOdka2FjkEQPeVkuQpfy
	Sq9VMOIyZP/l4F6izALQudbbtyJbZYj4p0R9trX7WhR1HLPC7iFfQTEp2EK01bUSMN1LQxI6vym
	HzpSHCtuMohOHfXg71EhndHM9vm2mWNx1EFB9yJq51kYtQcfZCZ2hw3Oev036tf3wP+u9q4TIXe
	5R2ptpyldb2s5+9bl4JMKEvsf35fCWbYLGs3LDiU3jKGbjehvkOFoEtCzggLNKCM5CJlGmcl0P9
	FmCtIBxhsAPge0Bed5CBVD+sOX4G4DtUB5gf/VvO1kuMddxA/oJ9gTsiFrXoy6V4yVkXslitYBK
	go0tD/NNHLBa89ksmiky2g0JEVhZThGaTo+RL2wEA0VcW9Xurh9m9E1jCQcx1P6Bj+ONjqI
X-Received: by 2002:a17:906:eecd:b0:c16:71:d9ce with SMTP id a640c23a62f3a-c16b46acbc1mr949754166b.8.1784666861525;
        Tue, 21 Jul 2026 13:47:41 -0700 (PDT)
Received: from [192.168.100.51] (87-205-15-91.static.ip.netia.com.pl. [87.205.15.91])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c1c32a78e0fsm16027966b.2.2026.07.21.13.47.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Jul 2026 13:47:40 -0700 (PDT)
Message-ID: <91da73b7-6d8b-4301-93a2-76e180818176@gmail.com>
Date: Tue, 21 Jul 2026 22:47:40 +0200
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot ci] Re: ocfs2: fix circular locking dependency in
 ocfs2_init_acl()
To: syzbot ci <syzbot+cie18720fdd9aae60a@syzkaller.appspotmail.com>,
 syzbot@kernel.org, syzbot@lists.linux.dev,
 syzkaller-upstream-moderation@googlegroups.com
Cc: syzkaller-bugs@googlegroups.com
References: <6a5f3cd4.83245ca4.2d5e11.0001.GAE@google.com>
Content-Language: en-US
From: Krystian Kaniewski <krystianmkaniewski@gmail.com>
In-Reply-To: <6a5f3cd4.83245ca4.2d5e11.0001.GAE@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

V4 correctly moves the parent default ACL lookup and ACL derivation 
before allocator reservation and ocfs2_start_trans(). It also fixes the 
v3 ownership problems by zero-initializing the ACL state, clearing 
released pointers, cleaning the state on every preparation error, and 
releasing it on the reflink failure path. Keep those changes, together 
with the current POSIX ACL result semantics, mode and security ordering, 
and exact reservation calculations.

One lock-order problem remains. ocfs2_mknod() starts its transaction and 
then calls ocfs2_init_acl(). When a directory inherits a default ACL, or 
when the derived access ACL must be stored, ocfs2_set_acl() reaches 
ocfs2_xattr_set_handle(). Initial security labels reach the same helper 
through ocfs2_init_security_set(). ocfs2_xattr_set_handle() still takes 
inode->ip_xattr_sem while the create path already holds allocation 
resources, sb_internal, and j_trans_barrier.

The ordinary ocfs2_xattr_set() path establishes the reverse dependency 
by taking ip_xattr_sem before reserving metadata and starting its 
transaction. All ip_xattr_sem instances are initialized at the same call 
site and therefore share one lockdep class. It does not matter to 
lockdep that the create path locks the new inode rather than the parent. 
A create under a parent with a default ACL can still establish the same 
circular class dependency.

The existing reproducer does not prove this path is fixed. It sets 
system.posix_acl_access rather than an inheritable 
system.posix_acl_default, so mkdir can avoid both default and access ACL 
xattr writes after the transaction starts. It also does not necessarily 
force an initial security xattr.

Required corrections:

1. Audit every caller of ocfs2_xattr_set_handle(). Confirm and document 
that this helper is used only while initializing a new inode that has 
not yet been inserted into the inode hash or attached to a dentry.
2. Make creation-time ACL and security xattr writes avoid acquiring the 
normal ip_xattr_sem class after allocator reservation and transaction 
start. A suitable approach is to remove the unnecessary semaphore 
acquisition from the private new-inode helper or split out an explicit 
no-lock creation helper. If serialization is still required, acquire it 
before the allocator resources and transaction, with balanced cleanup on 
every exit.
3. Keep the locking in the ordinary ocfs2_xattr_set() path unchanged. Do 
not suppress a real dependency with a lockdep annotation unless the 
private-inode lifetime argument is explicit and valid for every caller.
4. Preserve the v4 ACL state ownership fixes, __posix_acl_create() 
zero-versus-positive handling, inode owner and security initialization 
order, symlink and no-POSIX-ACL behavior, reflink behavior, and separate 
default/access ACL reservation calculations.
5. Clean up the four expression line breaks in ocfs2_calc_xattr_init() 
that end immediately after an opening parenthesis.

On 7/21/2026 11:33 AM, syzbot ci wrote:
> syzbot ci has tested the following series
>
> [v4] ocfs2: fix circular locking dependency in ocfs2_init_acl()
> https://lore.kernel.org/all/b2e72251-ea1a-458d-961e-7b7e99950e26@mail.kernel.org
> * [PATCH RFC v4] ocfs2: fix circular locking dependency in ocfs2_init_acl()
>
> and found no issues.
>
> Full report is available here:
> https://ci.syzbot.org/series/78a8c280-1c08-431d-aab1-f2054f103460
>
> ***
>
> If these findings have caused you to resend the series or submit a
> separate fix, please add the following tag to your commit message:
>    Tested-by: syzbot@syzkaller.appspotmail.com
>
> ---
> This report is generated by a bot. It may contain errors.
> syzbot ci engineers can be reached at syzkaller@googlegroups.com.
