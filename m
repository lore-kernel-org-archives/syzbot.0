Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.167.200
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795797138;
	b=tb8RGUZJL6qrLlwQuiLD2GzLhpvRSYCcDGPECWLBwugK3x3ZO/oZeVeEq3CUur8oIY8k
	 tyE06Hy1wUTg9TurCzefob1UnF//G7yRGmdVIgD8vBgS9R5sVUXMY/uRC6C0r1NT9r9qW
	 mXxvEUswtSaFmBy6rq9FWjCetMR4m3JoLjMnPnUavwDRfnaZNyRPx6kLL4JRpOsVV80Sl
	 5xyvf2VVPPbRtXjcF/vyZl08l6KTpaddLCqjP/lnm/r/6PjEq7b05Q1MghHL2Y+2w/ryR
	 J4hjHfr6XzeahmvQA8PDVgI48LhkhMSB15hspFWPt+ThEQkXSq0cLy1Iyr2FAzK6uOg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795797138;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 MIME-Version:X-Received:Date:X-Google-Appengine-App-Id:
	 X-Google-Appengine-App-Id-Alias:Message-ID:Subject:From:To:Cc:
	 Content-Type:Content-Transfer-Encoding;
	bh=DclYKZfX4Xd2Igpf48u6zoKg8hrd6RY61FAoR0M2P0A=;
	b=aARwD0G5p9t31cMLNOuteyX/UOf5zuPI3qUxN2QhNyj7Ayv4tOPkpoRfkYivHQbr5HN1
	 nyDaLg0ILmMn7T+JQdMd9XwmGR1D8OeA6LcSS1ZQBc7KRXtk7V7S4ennZDH0s37Z+8xur
	 h6VrXgKu3T9kfrgkeO46bU8rpVd7ooAz/i01jrQH6ScqsO2/gwJBZIcR0IU+IM+j6OG0Y
	 MrUAuZEIpTuIgwUGJIb34uJb3N5n5ACNyf5zpvGdArtmBBKJOfD1R88LM+eyJlUY9F++k
	 P2C0zXiYAZcgG9T8pyRWPfyJdwDGO1/vQBEHniq8VnuLyCkTV5zTL1gDXgXTP/u3xLg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=syzkaller.appspotmail.com;
	spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	arc=none smtp.remote-ip=209.85.167.200
Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com [209.85.167.200])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E55F3606A31C
	for <syzbot@lists.linux.dev>; Fri, 27 Nov 2026 16:32:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E55F3606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f200.google.com with SMTP id 5614622812f47-4e937c5bd4fso6989944b6e.2
        for <syzbot@lists.linux.dev>; Fri, 27 Nov 2026 08:32:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795797137; x=1796401937;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:date:mime-version:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=DclYKZfX4Xd2Igpf48u6zoKg8hrd6RY61FAoR0M2P0A=;
        b=SEkaICiY2uicuSEhI8jrJ3WvXbu7y4G4gebzs0b0E2hxGLzP8BoABEpOLF4e+RYvi8
         7Q00O+gmgBqElwu3NTI1ze2Mb6EEp0C4GSM7nss7LoTtyeARdpYqeDnFmFF0oICYH49p
         EBUiuSGSszB0yW/E41xtVsspwzI8dZ8PsPUfBXANUBYD9rByzdOW4i/JXDO4MJVhnnrr
         Exadf3QK6B5ESd/bFHBErwMMwFcvs8iwlpfOrrpi1BnY8JakOwGPEWi54FDUy7Q6s002
         6BVCq1Bn0TRbYaM68CMUu07ILW2nGcZdlPQns/agfjyOA8tMm0kos/i8NrOj2BbO2Mhq
         1WUw==
X-Gm-Message-State: APuU4Z8CNBLPTXncG2dzfXaoV+QFgWsI+PRw0T1PFjEvtzlDhWtVzMgh
	p912dzpwD3y1q0tKeJduUqBMx5R/M6NsSklGabtGwQzihxLDbJ7RPRdSB7JuGYjI7UFQoUxTGUI
	RJ+KhaFVe3Hr9TN5ktPHwf9AvRk1GDu/k7enRM/RqMhvvb1KAxVs3tw6waLM=
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Post: <mailto:syzbot@lists.linux.dev>
List-Help: <mailto:syzbot+help@lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
List-Owner: <mailto:syzbot+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-Received: by 2002:a05:6808:1a10:b0:564:48f3:dfa8 with SMTP id
 5614622812f47-57a0a111c93mr27696403b6e.11.1795797136982; Fri, 27 Nov 2026
 08:32:16 -0800 (PST)
Date: Fri, 27 Nov 2026 08:32:16 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6b09b090.8ccee5ca.1045fd.0274.GAE@google.com>
Subject: [moderation/CI] Re: unwind: Minimal DWARF CFI stack unwinding for
 x86, arm64, and riscv
From: syzbot ci <syzbot+ci6363fbdbfa31535f@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v1] unwind: Minimal DWARF CFI stack unwinding for x86, arm64, and riscv
https://lore.kernel.org/all/20261122235757.3456048-1-irogers@google.com
* [RFC PATCH v1 01/11] unwind: Add Minimal DWARF CFI bytecode interpreter a=
nd KUnit tests
* [RFC PATCH v1 02/11] unwind_user: Support Minimal DWARF CFI user-space un=
winding
* [RFC PATCH v1 03/11] scripts, unwind: Add build-time .eh_frame minifier
* [RFC PATCH v1 04/11] objtool/ibt: Ignore .eh_frame relocations during END=
BR validation
* [RFC PATCH v1 05/11] x86/unwind: Add Minimal DWARF CFI kernel unwinder
* [RFC PATCH v1 06/11] arm64: unwind_user: Support Minimal DWARF CFI and FP=
 user unwinding
* [RFC PATCH v1 07/11] arm64/unwind: Add Minimal DWARF CFI kernel unwinder
* [RFC PATCH v1 08/11] riscv: unwind_user: Support Minimal DWARF CFI and FP=
 user unwinding
* [RFC PATCH v1 09/11] riscv/unwind: Add Minimal DWARF CFI kernel unwinder
* [RFC PATCH v1 10/11] selftests/perf_events: Add Minimal DWARF CFI deferre=
d user unwind test
* [RFC PATCH v1 11/11] scripts: Add eh_frame_min.py .eh_frame coverage and =
size analyzer

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/ce9f5a45-b59b-480c-a630-f01db8cae398

***

kernel build error

tree:      axboe
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/axboe/l=
inux.git
base:      4843f6873f7c4835e62f2c73ba0fd538e57a2f22
arch:      amd64
compiler:  Debian clang version 22.1.8 (1~deb13u4), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/7019f7d2-7e58-48fb-b627-81ed58d79b3=
1/config

ld.lld: error: undefined symbol: arch_rethook_trampoline

***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[acme@kernel.org alex@ghiti.fr andrii@kernel.org aou@eecs.berkeley.edu ardb=
@kernel.org ast@kernel.org bp@alien8.de bpf@vger.kernel.org catalin.marinas=
@arm.com daniel@iogearbox.net dave.hansen@linux.intel.com dylanbhatch@googl=
e.com indu.bhagat@oracle.com irogers@google.com jpoimboe@kernel.org jremus@=
linux.ibm.com kvmarm@lists.linux.dev linux-arch@vger.kernel.org linux-arm-k=
ernel@lists.infradead.org linux-efi@vger.kernel.org linux-kbuild@vger.kerne=
l.org linux-kernel@vger.kernel.org linux-kselftest@vger.kernel.org linux-pe=
rf-users@vger.kernel.org linux-riscv@lists.infradead.org linux-trace-kernel=
@vger.kernel.org mark.rutland@arm.com maz@kernel.org mhiramat@kernel.org mi=
ngo@redhat.com namhyung@kernel.org nathan@kernel.org nsc@kernel.org ojeda@k=
ernel.org oupton@kernel.org palmer@dabbelt.com peterz@infradead.org pjw@ker=
nel.org rostedt@goodmis.org rust-for-linux@vger.kernel.org shuah@kernel.org=
 tglx@kernel.org will@kernel.org wnliu@google.com x86@kernel.org]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

