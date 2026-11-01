Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.167.200
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793524443;
	b=bfQq5+2bGsbShDmF6HkVLl0zhJ0zOZs/HPk0IzQ7c/awVw4fBmOV5u2rlqPGZ99MOqK5
	 O+Bfp/AIXsqxhNiVYslDB9ocuBDXmyNAcAcKETW/Xi4DPjGPp6rmIsKx7DVGu41wmEoRm
	 GPHvjq80eyGMbAgAc5kKyABLuj0VDRJRnInZHsslRWFZ+F5aNsi8DpEjKtTBc9xqa9JSF
	 PGwocOoDimxYVmN6dn3sxfLcSsVXfW7+JWQtNMaLKGsvYA066NqyyIOhTtji7WRQg3Oz1
	 ts3Hx4xtXMChQv8K8X7i2mtKjkASrSknDzqvgtJqZ75CkXPBpzGVDIg4Oha0iGfqO2w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793524443;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 MIME-Version:X-Received:Date:X-Google-Appengine-App-Id:
	 X-Google-Appengine-App-Id-Alias:Message-ID:Subject:From:To:Cc:
	 Content-Type:Content-Transfer-Encoding;
	bh=F3sJQP0gPQiTDUHhSH1cpDBDdq2LNHzoT7mV4zPmjR8=;
	b=3V0U35NXCg7VSlOhHLtw4UcV0+HYN+O+GgqA/PQw2ZWoN34agJnTAW/wf9j1YsXhs+hc
	 8W/hLjTlBPfKvA+yQ+9h4VlJUpusB9jRSXYtNYEOk28YtkrOj/9CyMaAS6jGDSrIPbkT0
	 X/MU5UXLagZOEAsyqY9p7l0GODczEWFdO0UKJ4GDCgdWXgdVCK1qoMXQFeVCFFjIN2qsF
	 lmdJWYrdFnm4ByuYtjn9qQzulpMkHTE0f5/J+aWID9EbkqMP+g2wY8+vM4qZZ5RA/FpDa
	 RwXLwGVTfDuWecab3hS47mCS6ggq/OXgDG+E8KX9c1DZ9hJn4eFOw+EqWB0KtveECSg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=syzkaller.appspotmail.com;
	spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	arc=none smtp.remote-ip=209.85.167.200
Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com [209.85.167.200])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91C12606A324
	for <syzbot@lists.linux.dev>; Sun,  1 Nov 2026 09:14:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 91C12606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f200.google.com with SMTP id 5614622812f47-540537f959fso2973554b6e.0
        for <syzbot@lists.linux.dev>; Sun, 01 Nov 2026 01:14:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793524442; x=1794129242;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:date:mime-version:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=F3sJQP0gPQiTDUHhSH1cpDBDdq2LNHzoT7mV4zPmjR8=;
        b=NesilmhOd5Aoxh3AABJoiDd2eEjUqgNM4Bt+NNGv8RxsqyXRvi9K0yo3kGKd2CCi7k
         7MzVfUaO0lvn45JRSYNYOyAfrsipPFuPco72lKM9aGa3Rt23pPkmvXA/fOVTXrJBOeNx
         QrR2NrG1Bcv+9r0M2GlFzO12KxMJikiGNeeasOwBWyaZq/iczsRcersmzzPlnbIwBQxJ
         TGRFeROPgjNVLSrzrMsZITuSBsNc+0cCLIS3N21Dt77VR+KyQznbkVUmWn3KjUDYLmLA
         VI1siLjXBob+AfKCJOuDvwmGK2E1Sah7zJnuN1mDjCWhlFlH+z/HTwlEc+cp55oo+Ao+
         wzHw==
X-Gm-Message-State: AFq9FYLteGQ9yNig+XzAk3R85A0icHqopeVtubzlI05LhtKxHO14BITB
	M2m4/B0UljahEzXi6xA4Z0Vkr/z3uOT+gpKCeNbb1q5F4H0FyfEXM4M1t6zAReO0SYRMfi/dTgM
	H9Ry4scSGHwEE3CWIew8TLNqpWOg2T1X2IA46lRD+mriL5YTgcD5sio9MKSQ=
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Post: <mailto:syzbot@lists.linux.dev>
List-Help: <mailto:syzbot+help@lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
List-Owner: <mailto:syzbot+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-Received: by 2002:a05:6808:220f:b0:4e8:e73e:e945 with SMTP id
 5614622812f47-5640de36543mr4429793b6e.63.1793524442502; Sun, 01 Nov 2026
 01:14:02 -0800 (PST)
Date: Sun, 01 Nov 2026 01:14:02 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6ae702da.2ce51036.253fae.0003.GAE@google.com>
Subject: [moderation/CI] Re: bpf: keep the vmlinux BTF compressed until first
 use (CONFIG_DEBUG_INFO_BTF_LAZY) to save ~6 MB memory
From: syzbot ci <syzbot+ci4d65943d509edaf9@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v1] bpf: keep the vmlinux BTF compressed until first use (CONFIG_DEBUG_INF=
O_BTF_LAZY) to save ~6 MB memory
https://lore.kernel.org/all/20261031130959.23472-1-wanjay@amazon.com
* [PATCH bpf-next 01/13] bpf: match program context types by name without v=
mlinux BTF
* [PATCH bpf-next 02/13] bpf: fetch the vmlinux BTF where kernel types ente=
r a program
* [PATCH bpf-next 03/13] bpf: check CAP_SYS_ADMIN before looking up bpffs d=
elegation names
* [PATCH bpf-next 04/13] bpf: move bpf_get_btf_vmlinux() to btf.c
* [PATCH bpf-next 05/13] bpf: let btf_parse_module() adopt the caller's cop=
y of the module BTF
* [PATCH bpf-next 06/13] bpf: look up the struct_ops common value type in t=
he given BTF
* [PATCH bpf-next 07/13] bpf: parse the vmlinux BTF before taking cand_cach=
e_mutex
* [PATCH bpf-next 08/13] tracing: parse the vmlinux BTF when BTF-typed outp=
ut is enabled
* [PATCH bpf-next 09/13] bpf: keep the vmlinux BTF zstd-compressed in the k=
ernel image
* [PATCH bpf-next 10/13] bpf: defer kfunc and struct_ops registrations unti=
l first BTF use
* [PATCH bpf-next 11/13] bpf: keep module BTF until the vmlinux BTF is pars=
ed
* [PATCH bpf-next 12/13] selftests/bpf: keep ksyms and linked_vars working =
without __start_BTF
* [PATCH bpf-next 13/13] Documentation/bpf: describe CONFIG_DEBUG_INFO_BTF_=
LAZY

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/a458b725-04a7-4acd-8bae-03303a203fc2

***

kernel build error

tree:      bpf-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/bpf/bpf=
-next.git
base:      eaae576c34d7e001767b6845a5950b0b8db3e68a
arch:      amd64
compiler:  Debian clang version 22.1.8 (1~deb13u4), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/4c72fd33-a422-4d38-8276-d463202193f=
f/config

./scripts/gen-btf.sh: 96: zstd: not found

***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

To test a fix for this bug, please reply with `#syz test`
(on a separate line) and attach the patch to the email.

Notes:
- The patch will be applied on top of the tested series (as an
  incremental fix).
- To test a new version of the whole series, please send it directly
  to syzbot@lists.linux.dev.
- Arguments like custom git repos and branches are not supported.

The email will later be sent to:
[abuehaze@amazon.com almagui@kernel.org andrii@kernel.org arnd@arndb.de ast=
@kernel.org bpf@vger.kernel.org daniel@iogearbox.net doebel@amazon.de eddyz=
87@gmail.com ihor.solodrai@linux.dev jay.wang.upstream@gmail.com jolsa@kern=
el.org linux-arch@vger.kernel.org linux-doc@vger.kernel.org linux-kbuild@vg=
er.kernel.org linux-kernel@vger.kernel.org linux-trace-kernel@vger.kernel.o=
rg martin.lau@linux.dev mathieu.desnoyers@efficios.com memxor@gmail.com mhi=
ramat@kernel.org mpohlack@amazon.de nathan@kernel.org nsc@kernel.org rosted=
t@goodmis.org wanjay@amazon.com x86@kernel.org yonghong.song@linux.dev]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

