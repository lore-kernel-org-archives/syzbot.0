Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.161.70
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792989070;
	b=fwmBXlUKyCB24s8mTdeBSzhx2f/LB+5HmKSFa1a+Hb9dQ3YqtQvg1uK+hR7H+OZ8r68D
	 rQt5d/TJuYh3/2yj2XfEnZxZYMIGlyTvtHnkSohchvzESvqRgGmlp5e4vvmhRkxQpg6cE
	 6tp1gwGESz0oJ5SNr7vU1M2dwHcKGbcbApn3+b+F1+nyzKlMh5nDSD4ol1Msrmd81go8X
	 m25dZ7R1xFMRJWOIyRtVQExpEe6cqv+sZZKCQV1kZ5ap53awWE0K4mNB4aaYLy7KGI1uF
	 PEPosDvH5y8D1D0/ZJRvN12cf23jXmKW+gWKFaU1BGx5pywd43nYPIRIM/7AYV8+E5A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792989070;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 MIME-Version:X-Received:Date:X-Google-Appengine-App-Id:
	 X-Google-Appengine-App-Id-Alias:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=OQs243hi4TP3a4bYDmqKFZ9ICRHLh9gwSWSYngGj5hg=;
	b=CxRUb0gr6Y8kFTH8vAK56nfTlC09Cyl6wws/2q08uEcZmwgjZ0ppNXPr2EdvE9YYeFW0
	 6eVSJMCERxY9Ws4hOwUS6h3j+kpt+zvUb7kS+4vratZx6xq9AU2PuAePuATqBSRixOrTO
	 R9HLl8QXnP34Y3ABAMNr6d24TtRKgkBeDIYbhQ5+YeW/eYvRQTKx/ojFF8HySv3Lnp8er
	 W4D+wSzMt/Oue25/Q9BBQLNmrqSPUEd96ti15dSkcXHjCnYUxVnWphysMSasFq5oBaQjY
	 x4VBIvdwNqFcuCpbhOk86SovvSElvBLW8GsiF+YaJMSDcK1fM2FK2Y+aEvLJ4CcwSOA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=syzkaller.appspotmail.com;
	spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	arc=none smtp.remote-ip=209.85.161.70
Received: from mail-oo1-f70.google.com (mail-oo1-f70.google.com [209.85.161.70])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F161E606A31A
	for <syzbot@lists.linux.dev>; Mon, 26 Oct 2026 04:31:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F161E606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f70.google.com with SMTP id 006d021491bc7-704aee0b7b2so2570826eaf.2
        for <syzbot@lists.linux.dev>; Sun, 25 Oct 2026 21:31:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792989069; x=1793593869;
        h=content-type:cc:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=OQs243hi4TP3a4bYDmqKFZ9ICRHLh9gwSWSYngGj5hg=;
        b=rmVzbGHevkJ5+wIrk9g2u+YnkPFs8ucFI44vpTrmUiafOKYGDvXIzZUJRmrqtnFOOc
         pvdWkimt212SuBs5htT8kfTKsggKLI+7ydUgznIxNCOTUa++gC7uV8rz8XNtUgh2CR0N
         neRdCmD5UXwTgDNrWQTerKwLk/MsI2GSMZPGsxOiAo4MnhjGJ2ZNB/UXdlLyGQ+XM7oX
         FeEImsr0qxiVWmtySj9qtEKG3N5jV0JiZK+3AT0YT1Pg76dTa/pBSTOq3to2DF4KN+SH
         N8jizPfBTzZt+MA9O+ecLkEKMOztScdKf9WAL5mOw+oW5Trni8fRcgvh/IEAy9CvQV7R
         R/RQ==
X-Gm-Message-State: AFq9FYLt2Z6GU3jcSGBDmLxy6CpXl2OdOutvy/TR+x5L52Bz4zGw8T6b
	R2KuAJ3W2kmXXLEIubgav+Wo2sqOTZWPvBaM71a07XT/g2nySr3l53H5R7bWSdj4LH5WItn2htc
	S2iGvqAMz9gW2BH4r8qBULzHxo59G87VQfk0SaQfv4RGTryxgxkK129x9+Hc=
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Post: <mailto:syzbot@lists.linux.dev>
List-Help: <mailto:syzbot+help@lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
List-Owner: <mailto:syzbot+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-Received: by 2002:a05:6820:61d:b0:70c:f411:40b7 with SMTP id
 006d021491bc7-70cf41148a2mr1359222eaf.43.1792989068941; Sun, 25 Oct 2026
 21:31:08 -0700 (PDT)
Date: Sun, 25 Oct 2026 21:31:08 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6aded78c.8652420f.2f2d6f.0486.GAE@google.com>
Subject: [moderation/CI] Re: bpf: Stack in arena and a verifier that joins states
From: syzbot ci <syzbot+cicf0749ccfce5598d@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v1] bpf: Stack in arena and a verifier that joins states
https://lore.kernel.org/all/20261026025943.404450-1-alexei.starovoitov@gmail.com
* [PATCH bpf 01/81] selftests/bpf: Remove tests for global data in arena
* [PATCH bpf 02/81] libbpf: Remove .arena.data
* [PATCH bpf 03/81] libbpf: Keep format strings of bpf_printk() in .rodata
* [PATCH bpf 04/81] selftests/bpf: Remove tests for arena access through numbers
* [PATCH bpf 05/81] bpf: Remove BPF_F_ARENA_SCALAR
* [PATCH bpf 06/81] bpf, x86: Remove r0_on_stack from fetching atomics in arena
* [PATCH bpf 07/81] bpf: One time slice of may_goto for a run of a prog
* [PATCH bpf 08/81] selftests/bpf: Test may_goto in a loop that calls a subprog that spins
* [PATCH bpf 09/81] bpf: Clear delta of a register that scalar evolution widens
* [PATCH bpf 10/81] selftests/bpf: Test that a widened register is not linked
* [PATCH bpf 11/81] selftests/bpf: Wait for the last maps of map_kptr to be freed
* [PATCH bpf 12/81] bpf: Don't widen a pointer to a buffer in scalar evolution
* [PATCH bpf 13/81] selftests/bpf: Test a loop that moves a pointer to a buffer
* [PATCH bpf 14/81] bpf: Fix a false verifier bug in the clamp of scalar evolution
* [PATCH bpf 15/81] selftests/bpf: Test induction variables that come back out of range
* [PATCH bpf 16/81] libbpf: Make arena 1 Gbyte when max_entries is not set
* [PATCH bpf 17/81] selftests/bpf: Test the default size of arena
* [PATCH bpf 18/81] bpf: Treat addr_space_cast of a pointer that is not in arena as a move
* [PATCH bpf 19/81] selftests/bpf: Test addr_space_cast of pointers that are not in arena
* [PATCH bpf 20/81] libbpf: Support .bss.addr_space.1 section
* [PATCH bpf 21/81] libbpf: Relocate pointers that are stored in arena
* [PATCH bpf 22/81] selftests/bpf: Test pointers in arena and .bss.addr_space.1
* [PATCH bpf 23/81] bpf: Introduce bpf register BPF_REG_ARENA_SP
* [PATCH bpf 24/81] bpf: Add stacks for programs to arena
* [PATCH bpf 25/81] bpf, x86: Add BPF_ATOMIC_LOCAL
* [PATCH bpf 26/81] bpf: Support BPF_REG_ARENA_SP in the verifier
* [PATCH bpf 27/81] bpf, x86: Support BPF_REG_ARENA_SP
* [PATCH bpf 28/81] bpf, arm64: Support BPF_REG_ARENA_SP
* [PATCH bpf 29/81] selftests/bpf: Add tests for BPF_REG_ARENA_SP
* [PATCH bpf 30/81] bpf: Add bpf_arena_memcmp() and bpf_arena_memcpy() kfuncs
* [PATCH bpf 31/81] bpf: Add bpf_alloc() and bpf_free() kfuncs
* [PATCH bpf 32/81] bpf: Count stack arguments of a static subprog from its code
* [PATCH bpf 33/81] selftests/bpf: Test static subprogs that don't take what BTF says
* [PATCH bpf 34/81] bpf: Let scalar evolution see loads from read-only maps
* [PATCH bpf 35/81] selftests/bpf: Test scalar evolution with a loop bound in .rodata
* [PATCH bpf 36/81] bpf: Helpers don't write through ARG_ANYTHING
* [PATCH bpf 37/81] selftests/bpf: Test scalar evolution with stack address as ARG_ANYTHING
* [PATCH bpf 38/81] bpf: Simplify (zext32 (zext32 x)) in scalar evolution
* [PATCH bpf 39/81] selftests/bpf: Test scalar evolution with a latch on a 32-bit copy
* [PATCH bpf 40/81] bpf: Keep the range of a packet pointer when a number >= 0 is added
* [PATCH bpf 41/81] selftests/bpf: Test range of a packet pointer after a number is added
* [PATCH bpf 42/81] bpf: Allow BPF_MAX_SUBPROGS targets of a read from a table of functions
* [PATCH bpf 43/81] bpf: Tell user space that a run of a prog was cut short
* [PATCH bpf 44/81] bpf: Mask the count of a 32-bit shift in scalar evolution
* [PATCH bpf 45/81] selftests/bpf: Expect the masked count of 32-bit shifts
* [PATCH bpf 46/81] bpf: Finish the insn in the state that maybe_fork_scalars() splits off
* [PATCH bpf 47/81] bpf: Add join of verifier states
* [PATCH bpf 48/81] bpf: Describe loops that scalar evolution cannot count exactly
* [PATCH bpf 49/81] selftests/bpf: Adjust tests to loops that are counted now
* [PATCH bpf 50/81] bpf: Add may_goto to the loops that the verifier marks
* [PATCH bpf 51/81] bpf: Check stack and count calls of recursive subprogs at run time
* [PATCH bpf 52/81] bpf: Add the main pass as a fixpoint over the control flow graph
* [PATCH bpf 53/81] bpf: Verify programs as a fixpoint over the control flow graph
* [PATCH bpf 54/81] bpf: Allow 24 arguments of static subprogs
* [PATCH bpf 55/81] selftests/bpf: Test a static subprog with 24 arguments
* [PATCH bpf 56/81] bpf: Bump MAX_CALL_FRAMES to 32
* [PATCH bpf 57/81] selftests/bpf: Test 32 and 33 call frames
* [PATCH bpf 58/81] bpf: Bump BPF_MAX_SUBPROGS to 1024
* [PATCH bpf 59/81] selftests/bpf: Make room in veristat for the stats of 1024 subprogs
* [PATCH bpf 60/81] bpf: Remove is_state_visited()
* [PATCH bpf 61/81] bpf: Remove precision tracking
* [PATCH bpf 62/81] bpf: Remove prune points, levels of state comparison and pop_stack()
* [PATCH bpf 63/81] bpf: Print 0 as the limit in the statistics line
* [PATCH bpf 64/81] bpf: Remove bpf_compute_scc()
* [PATCH bpf 65/81] bpf: Update comments about paths, pruning and explored states
* [PATCH bpf 66/81] bpf: Remove iter.depth
* [PATCH bpf 67/81] bpf: Remove leftovers of precision tracking and read marks
* [PATCH bpf 68/81] bpf: Track a pointer to one of a set of functions
* [PATCH bpf 69/81] bpf, docs: Rewrite verifier.rst
* [PATCH bpf 70/81] selftests/bpf: Adjust tests of precision tracking
* [PATCH bpf 71/81] selftests/bpf: Adjust tests of linked registers and spills
* [PATCH bpf 72/81] selftests/bpf: Adjust tests of pruning
* [PATCH bpf 73/81] selftests/bpf: Adjust tests of loops
* [PATCH bpf 74/81] selftests/bpf: Adjust tests of recursion
* [PATCH bpf 75/81] selftests/bpf: Adjust tests to the order of verification and to the log
* [PATCH bpf 76/81] selftests/bpf: Adjust tests of unprivileged progs
* [PATCH bpf 77/81] selftests/bpf: Test states that are not joined
* [PATCH bpf 78/81] selftests/bpf: Test progs that run out of budget
* [PATCH bpf 79/81] selftests/bpf: Test 'unwound' in bpf_prog_info
* [PATCH bpf 80/81] selftests/bpf: Test the stack in arena after recursion ran out of budget
* [PATCH bpf 81/81] selftests/bpf: Test callx of one of a set of functions

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/45f1822d-501b-4bc7-af4e-fef834185aa4

***

kernel build error

tree:      bpf
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/bpf/bpf.git
base:      00d2cdf1637e340e66fa30900363a35af12fabd8
arch:      amd64
compiler:  Debian clang version 22.1.8 (1~deb13u4), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/8e6582f7-e11d-4730-9e80-8cd1dbc1e7ea/config

kernel/bpf/fixups.c:791:3: error: too many arguments provided to function-like macro invocation
kernel/bpf/fixups.c:791:40: error: too many arguments provided to function-like macro invocation
kernel/bpf/fixups.c:833:2: error: too many arguments provided to function-like macro invocation
kernel/bpf/fixups.c:833:35: error: too many arguments provided to function-like macro invocation
kernel/bpf/fixups.c:864:3: error: too many arguments provided to function-like macro invocation
kernel/bpf/fixups.c:864:36: error: too many arguments provided to function-like macro invocation

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
[alexei.starovoitov@gmail.com andrii@kernel.org bpf@vger.kernel.org daniel@iogearbox.net eddyz87@gmail.com memxor@gmail.com]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

