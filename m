Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.167.199
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795667248;
	b=scopSpgGEu1f/PojwnGOM2oydJmpWt6spQ65XRMsRbblhm1xvWp0CYK+/zdL6fD6AXiZ
	 Yy61p1GPr1WxFJ0ij18RScN6h1OhhMim3Yk2OfMtZ2Tmkh1J5VxRTSVMR2dIKEGeBmMMA
	 3vpu85CgFgHZj4UxrX5kNp/n84ckyTrmJILcu3a/QhF0ZrgB+/vdBk47ECl3V3S/OI9/p
	 r4JRRyJz6GYGQFhLpUEK//OIJutJhHWVC2gUmxNDA1ZHW7kNxGcgqRer2QlDNXIsQpHZv
	 VUy0wT04exJ5OA3rZEf2HV2G1cGevAhsP5Q2Jzr3tsk+JeXoB9Soic8+FjhMh7fSk6g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795667248;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 MIME-Version:X-Received:Date:X-Google-Appengine-App-Id:
	 X-Google-Appengine-App-Id-Alias:Message-ID:Subject:From:To:Cc:
	 Content-Type:Content-Transfer-Encoding;
	bh=4wMRvZyy90bJGa/lbLfTNlhRSaPwfQU87hEdP+oxwVg=;
	b=2BaOP+SeApjv7jruAjaVX5KgX2cLdDoitYTzorbNKvuL3wZGDyKyqQgHmKCR08hQ5RhF
	 B8kH2oK/7l42YZWATOgjEdPtsVLpkFv7O3qkfAopZTmmfZrwUhnNgltBpLzVgAvmKKA03
	 jyQ1t4chqqrUBOPv6XKl1KJ8y3lwGL1LxhmSsyw4a1XAB/WwBMFZXIAEmZpDo+IrwOOSp
	 /1GU1nj1i3kuWvcUsIGdVHSpUBxflgCIqaihe7sZ/t2jbcazjnViHovDAyQCHNnGQ9WXk
	 EArN7PXnB9fr19MHKxhjhxbY7yTII65ElSfJ1cGI9/F6Ob0eOk42prCvH8JgrieqXEw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=syzkaller.appspotmail.com;
	spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	arc=none smtp.remote-ip=209.85.167.199
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com [209.85.167.199])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60ED4606A31E
	for <syzbot@lists.linux.dev>; Thu, 26 Nov 2026 04:27:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 60ED4606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f199.google.com with SMTP id 5614622812f47-574ae6cc614so6129979b6e.1
        for <syzbot@lists.linux.dev>; Wed, 25 Nov 2026 20:27:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795667247; x=1796272047;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:date:mime-version:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=4wMRvZyy90bJGa/lbLfTNlhRSaPwfQU87hEdP+oxwVg=;
        b=PSSfpPGBEU6KT9NG1VnjgxaAYQi40trqA4uRu1Q6x5aNbqJ0NwPI0q0jE0q8K+Nz/p
         DhDtsFdK8MjZ95CzJ/oigmuJGfHdAQTUBnBkgjsbORT1Xyz3pRn5KjAoEKNh6Ob4tFXm
         8mz8+WkY7r2Ax3czaaJKckZLHUTRyEgWnNpsWOj/YcbcXao+uNWrMPWua8RA2uJc39QK
         EX8x5ZhZs82qPihCyBWFv2WXTBV+l60yKtCro7IXxJ7qjFDoncm1vJUgUqZENagQ9wyG
         S5OPBZResceTUs3yWQcE0up+7r6sDkvZcDMMwVA5ueYj7UK3AIpfx3Gy4hy1svGP6YuQ
         3JZA==
X-Gm-Message-State: APuU4Z/VPerrOMxtlUs8Ncd7cygMo7FdT/aWtfos21wwycc68qlglogh
	qQBQ0cXtnbvVE1LI8/nSXtTkp3sYhSeZDDB8V2E0lG1/Z9TLM0NUI3aeaXlRqCs+ul2xRiPrUF5
	RNEoHYpfjG1kcPT0cqq4olTm6OVG6SkYIsmI5HFBxoOmcomJt1NpLDkDwUaA=
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Post: <mailto:syzbot@lists.linux.dev>
List-Help: <mailto:syzbot+help@lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
List-Owner: <mailto:syzbot+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-Received: by 2002:a05:6808:6b8e:b0:521:561a:8e8c with SMTP id
 5614622812f47-5797d6add74mr14700450b6e.33.1795667247429; Wed, 25 Nov 2026
 20:27:27 -0800 (PST)
Date: Wed, 25 Nov 2026 20:27:27 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6b07b52f.1fb41460.314c8.0053.GAE@google.com>
Subject: [moderation/CI] Re: rootns: fd-bound process closures
From: syzbot ci <syzbot+cie7db4e290cbfd1c9@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v5] rootns: fd-bound process closures
https://lore.kernel.org/all/20261121000844.1863324-1-jarkko@kernel.org
* [RFC PATCH v5 01/25] userns: Factor out idmap validation and commit helpe=
rs
* [RFC PATCH v5 02/25] userns: Add userns_set_idmap() system call
* [RFC PATCH v5 03/25] arch: Wire up userns_set_idmap() system call
* [RFC PATCH v5 04/25] mount: Add mnt_ns_get_root()
* [RFC PATCH v5 05/25] mount: Enforce mount_too_revealing() for foreign mnt=
ns
* [RFC PATCH v5 06/25] mount: Support MOVE_MOUNT_T_MNTNS in move_mount()
* [RFC PATCH v5 07/25] mount: Support MOVE_MOUNT_CLONE with MOVE_MOUNT_T_MN=
TNS
* [RFC PATCH v5 08/25] userns: Factor out install_user_ns_cred()
* [RFC PATCH v5 09/25] nsfs: Add nsproxy_open_namespace()
* [RFC PATCH v5 10/25] nsproxy: Pass nsproxy to create_new_namespaces()
* [RFC PATCH v5 11/25] rootns: Add core infrastructure for root namespaces
* [RFC PATCH v5 12/25] rootns: Track init lifecycle via copy_process() and =
pid_namespace
* [RFC PATCH v5 13/25] rootns: Add rootns() system call
* [RFC PATCH v5 14/25] rootns: Add ROOTNS_WAIT ioctl
* [RFC PATCH v5 15/25] rootns: Add ROOTNS_KILL ioctl
* [RFC PATCH v5 16/25] fork: Support CLONE_INTO_ROOTNS in clone3()
* [RFC PATCH v5 17/25] fs: Support FSCONFIG_SET_ROOTNS in fsconfig()
* [RFC PATCH v5 18/25] proc: Implement ->set_rootns() fs_context operation
* [RFC PATCH v5 19/25] ipc/mqueue: Implement ->set_rootns() fs_context oper=
ation
* [RFC PATCH v5 20/25] security: Add rootns LSM hooks
* [RFC PATCH v5 21/25] bpf: Register rootns LSM hooks
* [RFC PATCH v5 22/25] arch: Wire up rootns() system call
* [RFC PATCH v5 23/25] docs: Document root namespace uAPI
* [RFC PATCH v5 24/25] selftests/rootns: Add root namespace test suite
* [RFC PATCH v5 25/25] MAINTAINERS: Add entry for ROOT NAMESPACE

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/3a4b626b-0582-4849-a186-ca483259d7dd

***

kernel build error

tree:      mm-new
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/mm=
.git
base:      a036649714c3446abfdc36d0ae483046432b16c5
arch:      amd64
compiler:  Debian clang version 22.1.8 (1~deb13u4), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/0691f9a5-381a-4ffc-8165-badff08d7ae=
6/config

ld.lld: error: undefined symbol: __x64_sys_sys_userns_set_idmap
ld.lld: error: undefined symbol: __x64_sys_sys_rootns
ld.lld: error: undefined symbol: __ia32_sys_sys_userns_set_idmap
ld.lld: error: undefined symbol: __ia32_sys_sys_rootns

***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[alex@amutable.com brauner@kernel.org corbet@lwn.net dhowells@redhat.com ja=
ck@suse.cz jarkko@kernel.org josef@toxicpanda.com kees@kernel.org linux-api=
@vger.kernel.org linux-doc@vger.kernel.org linux-fsdevel@vger.kernel.org li=
nux-kernel@vger.kernel.org linux-kselftest@vger.kernel.org linux-mm@kvack.o=
rg linux-security-module@vger.kernel.org luto@amacapital.net neal@gompa.dev=
 paul@paul-moore.com sergeh@kernel.org viro@zeniv.linux.org.uk zygmunt.kryn=
icki@canonical.com]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

