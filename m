Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D729027467D
	for <syzbot@lists.linux.dev>; Thu, 11 Sep 2025 21:09:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757624992; cv=none; b=ltncohG0Mz71HVno4y2K1HhlsyDh8zlOyN2OonQdg6SEI+H6Nlk/oc0+IQlPaPKBvpMoMNvRmq2Lvd1rPYtMFgH2HUcx7BYPUncMKgcHFhIkEEcSvzUJ7KoF4S//DcpULqBulHi+KGO8KoWG3sHXQ/4lcWiM5IoITWHNh0VyjAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757624992; c=relaxed/simple;
	bh=42+AewX2K0aBhKb9Jp4C1qMxzFpyBNEkV4nBBMBwXPk=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=hy0i7c/8Bh2BF2qlHBpq2XwXX6x7crm4WR9DtJlkFBvFCcZZAunS1Vz+QjBIlM0SqdEJIyXjrFKHroSF3O4XFwAfjmpiiwL40u4v4z8wB7IajKpUbJFkITtAtZlopXLajuMuOV2VrLGfcyLJPXhpfh+ETjSkdup0Jq/nwC/ED00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SG3PNu+0; arc=none smtp.client-ip=209.85.216.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SG3PNu+0"
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-32d6c194134so1766406a91.0
        for <syzbot@lists.linux.dev>; Thu, 11 Sep 2025 14:09:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757624990; x=1758229790; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=3ZvXk7oObUVKxhZ1q7736GiFkPBmqmJmQ0Y/DU0xscQ=;
        b=SG3PNu+0iDS3EgGMKJ1B9Qj5X1zmCQI8ME5BiA3dOSt/vJKmE96T0LOFqJd45uKVIU
         Hps5I+/PBcCnIwA1hFbjhpsJLRSp1x/x+URrIaXIKY31VL78gCEIvOPgwkL1HWDF+WQt
         olGoPbtbovSSXSDKNuYCP/zbDZNCkP8l/hikc8WKYbrIOLreaFcIjG9Jgqsi448eqgGG
         mycNHJe5vwVtFjMtYLdZckzw0b91SuVY0D+ki8Cv5NTXEvev11pW8P94/MQ/xoRc9cls
         sPBZvtRJD5sEJNBjQmtR8o/Mzq1wcBy22cjIrEPK0tcO/FIgvveku18Y6mFOKtMh4gDW
         6Cng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757624990; x=1758229790;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3ZvXk7oObUVKxhZ1q7736GiFkPBmqmJmQ0Y/DU0xscQ=;
        b=wNEIauIkQT4m42iVVfWXyxdaLsRMHt64Ex/v79y50ABxeEx4+RzRXllUoW3GsQR8RR
         gzXA+o0Cla0vGRyA/M4hotxiqbWWBtroyEQsCsh3GqporqqkGTey3//A65cMuYciFxk7
         wrUbmXNXNKRIZxaH8L/OuHivYfwqHS9peeHgW1jwgYhc+Yw4RjB0vZi52hA5gEApwAMh
         1TOXj9H/i1UEjtKGIh1vnfwMnfDoC8DAxCzr+2BcP8vEHFTQk06F9z4zXtYxSxX5dVfl
         21I2RfiAGRxb86Y3yC9xG3Es6TekNEr6Al1vmwDTgO5DjuEVuqISYhoojnkb/WhAsEOG
         1iTA==
X-Gm-Message-State: AOJu0YwxEdH7vTvbdEnkT2P4u99VYZgAKmhwDEnZzS6NrqRe+bShwKJz
	4bh2DXn2etpXINuVEuEgHBJtAN1XfAGCDsUTu5oFoO3E48pg6UBaHFaZ
X-Gm-Gg: ASbGncurmjaZWrKb7xhDpBSxGFI4Mk/gY49nw33+AgLfezvMHuBqu/XRUQf1AwMhYaT
	iHvwJ7/lkzJSwBBpDr4+TX/efjJMk5b1AXdBenNBPzh0jIzqc0dot4ziYz0zq8mutYdmPkvnM+b
	M9qNJ1uTlT1W/sF+XQtYQA9bzBYKNPteWoQmvFv5UJmo4TMk1gj+5knnj71T9xBwefdY/ST1pu8
	8s2nmBOo9F47Omc50zy0LjdulVerd1wYiDlTgL3dxhSqavvpNTiz609e3MqcYvJW+z2q03j/ap6
	kYPmn6ulV1tNTNFEfLnBkIJQ9dkYu0MZKV0ewMmyJSqsoFerMPtn//TSaNEOPDRaqJ+PJwiB3YZ
	IYO9JYkm12FHweJz2ZK06uwrL6J9y7w==
X-Google-Smtp-Source: AGHT+IEppR+vd18tlXbSJVuWb6c+0vIjqzXttlPBKvBI6LHMvtcOm1F6DDbRWwk94Ceu+po18rJ2rw==
X-Received: by 2002:a17:90b:2d47:b0:32d:17ce:49d5 with SMTP id 98e67ed59e1d1-32de4f8f8b0mr559708a91.23.1757624990087;
        Thu, 11 Sep 2025 14:09:50 -0700 (PDT)
Received: from [192.168.0.226] ([38.34.87.7])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-32dd6306edfsm3723573a91.18.2025.09.11.14.09.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Sep 2025 14:09:49 -0700 (PDT)
Message-ID: <03440441db6f719e8576cafe0318aa9994621cab.camel@gmail.com>
Subject: Re: [syzbot ci] Re: bpf: replace path-sensitive with
 path-insensitive live stack analysis
From: Eduard Zingerman <eddyz87@gmail.com>
To: syzbot ci <syzbot+ci8e503a0d4aea89ba@syzkaller.appspotmail.com>, 
	andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
 daniel@iogearbox.net, 	kernel-team@fb.com, martin.lau@linux.dev,
 yonghong.song@linux.dev
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Date: Thu, 11 Sep 2025 14:09:46 -0700
In-Reply-To: <68c272e7.050a0220.2ff435.00f3.GAE@google.com>
References: <68c272e7.050a0220.2ff435.00f3.GAE@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2 (3.56.2-1.fc42) 
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Wed, 2025-09-10 at 23:57 -0700, syzbot ci wrote:
> syzbot ci has tested the following series
>=20
> [v1] bpf: replace path-sensitive with path-insensitive live stack analysi=
s
> https://lore.kernel.org/all/20250911010437.2779173-1-eddyz87@gmail.com
> * [PATCH bpf-next v1 01/10] bpf: bpf_verifier_state->cleaned flag instead=
 of REG_LIVE_DONE
> * [PATCH bpf-next v1 02/10] bpf: use compute_live_registers() info in cle=
an_func_state
> * [PATCH bpf-next v1 03/10] bpf: remove redundant REG_LIVE_READ check in =
stacksafe()
> * [PATCH bpf-next v1 04/10] bpf: declare a few utility functions as inter=
nal api
> * [PATCH bpf-next v1 05/10] bpf: compute instructions postorder per subpr=
ogram
> * [PATCH bpf-next v1 06/10] bpf: callchain sensitive stack liveness track=
ing using CFG
> * [PATCH bpf-next v1 07/10] bpf: enable callchain sensitive stack livenes=
s tracking
> * [PATCH bpf-next v1 08/10] bpf: signal error if old liveness is more con=
servative than new
> * [PATCH bpf-next v1 09/10] bpf: disable and remove registers chain based=
 liveness
> * [PATCH bpf-next v1 10/10] bpf: table based bpf_insn_successors()
>=20
> and found the following issue:
> KASAN: slab-out-of-bounds Write in compute_postorder
>=20
> Full report is available here:
> https://ci.syzbot.org/series/c42e236b-f40c-4d72-8ae7-da4e21c37e17
>=20
> ***
>=20
> KASAN: slab-out-of-bounds Write in compute_postorder
>=20
> tree:      bpf-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/bpf/b=
pf-next.git
> base:      e12873ee856ffa6f104869b8ea10c0f741606f13
> arch:      amd64
> compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~e=
xp1~20250708183702.136), Debian LLD 20.1.8
> config:    https://ci.syzbot.org/builds/6d2bc952-3d65-4bcd-9a84-1207b810a=
1b5/config
> C repro:   https://ci.syzbot.org/findings/338e6ce4-7207-484f-a508-9b00b31=
21701/c_repro
> syz repro: https://ci.syzbot.org/findings/338e6ce4-7207-484f-a508-9b00b31=
21701/syz_repro
>=20
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> BUG: KASAN: slab-out-of-bounds in compute_postorder+0x802/0xcb0 kernel/bp=
f/verifier.c:17840
> Write of size 4 at addr ffff88801f1d4b98 by task syz.0.17/5991

The error is caused by the following program:

  (e5) if r15 (null) 0xffffffff goto pc-1 <---- absence of DISCOVERED/EXPLO=
RED mark here
  (71) r1 =3D *(u8 *)(r1 +70)	     	  	leads to instruction being put on st=
ack second time
  (85) call pc+2
  (85) call bpf_get_numa_node_id#42
  (95) exit
  (95) exit

And this is the fix:

--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -17840,6 +17840,7 @@ static int compute_postorder(struct bpf_verifier_en=
v *env)
                stack_sz =3D 1;
                do {
                        top =3D stack[stack_sz - 1];
+                       state[top] |=3D DISCOVERED;
                        if (state[top] & EXPLORED) {
                                postorder[cur_postorder++] =3D top;
                                stack_sz--;
[...]
