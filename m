Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07CF1393DC8
	for <syzbot@lists.linux.dev>; Mon, 18 May 2026 21:05:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779138328; cv=none; b=XlrniO3f7PlAUep605/YVQBDOpVIrHqq0v+xU/x6TZFPzXK1Jn6BT1g49ddj2OfrOUwXdZn55/Xl6ArjFhfdQyaVby5JtKHicnNWVHtOWDS8uiftZoXTKxb7y6ieQBPlr9Dy6O/l8krEXPyqUmP0VQ1EfMt3nCtUYQ1TBjNFg/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779138328; c=relaxed/simple;
	bh=Geewj8yhyMfi/COi+5lNdNm2aLKU+FOYAqjRQsEWlZg=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=QqtE9uzFZ2RrQuLSjKtYnMR9DdqmFu3byAc8dDzMuT1hgnu/OvlHWFdBUNkGmZZ6Yqj3S/uEhTshFwykfxhiUwBP9XnfcB72gfDgVLyb0++YF2RI+Mdv6yv8oofG+Vc5PVrp3y0L50kgw33j0o6FO5/ThZD6LhNKe7Y2ssDkhfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FiMPauNV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FiMPauNV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 842CAC2BCB7;
	Mon, 18 May 2026 21:05:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779138327;
	bh=Geewj8yhyMfi/COi+5lNdNm2aLKU+FOYAqjRQsEWlZg=;
	h=From:To:Cc:Subject:Date:From;
	b=FiMPauNV4q+aLlLXv0iT2aGmIFFsmsizmArnqovReTvOVf2THL7VbwvRaL+blR7Md
	 eFvCevjX1hcHX7MX+t3K3e5WitLWlWDCP+v8ox10GpTr1lG4/mo5qRRRkBPdn3rZ3s
	 ITNAfLplytjXZ1h+24X6Gw5TKMRBVBd4G2v8Y/zUeVx76rVxe5JQaN+hfFoYwwtwfs
	 uK6mnIijLBWgtCRlh4r2ZCULycw0VZlKarHQaA2IRJ892nBRsdQ4HHU0pWkuj0BRuZ
	 4uDpeJu06pGkzE+O0mbmO5MynMcBaXSsdPiFCyZsMcwstUAbZmK7K/DSTcvj1JjrNE
	 JYnh/Z3RNFsWw==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] bpf: Fix out-of-bounds write in bpf_bprintf_prepare()
Message-ID: <22954901-ef80-45be-8a06-9797118d2084@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Mon, 18 May 2026 21:05:27 +0000 (UTC)

The `bpf_bprintf_prepare()` function formats arguments into a temporary
512-byte buffer. There are two distinct bugs in this function that allow
`tmp_buf` to advance past `tmp_buf_end`, bypassing bounds checks and
causing out-of-bounds memory writes.

First, when handling the `%pB` and `%pI4`/`%pI6` format specifiers,
`snprintf()` is used to format the string. `snprintf()` returns the
number of characters that would have been written if the buffer was
large enough. If the remaining buffer space is smaller than the
formatted string, the return value will be greater than or equal to the
remaining space. The code previously advanced `tmp_buf` by `err + 1`,
which could push `tmp_buf` past `tmp_buf_end`.

Second, when handling standard format specifiers, the code aligns
`tmp_buf` and checks if there is enough space using `tmp_buf_end -
tmp_buf < sizeof_cur_arg`. Since `sizeof_cur_arg` is an unsigned
`size_t`, the signed `ptrdiff_t` result of the pointer subtraction is
implicitly cast to unsigned. If `tmp_buf` has already been advanced past
`tmp_buf_end`, the negative difference becomes a huge positive number,
bypassing the check and allowing further out-of-bounds writes.

Fix these issues by checking the return value of `snprintf()` for `%pB`
and `%pI4`/`%pI6`. If it indicates truncation or an error, return
`-ENOSPC` or `-EINVAL` respectively, ensuring the buffer is not overrun
and `bstr_printf()` does not read malformed data. Additionally, rewrite
the bounds checks to use pointer addition (`tmp_buf + sizeof_cur_arg >
tmp_buf_end`), which eliminates the integer signedness bypass, and
harden equality checks for buffer fullness from `tmp_buf_end == tmp_buf`
to `tmp_buf >= tmp_buf_end`.

This prevents memory corruption that can lead to soft lockups and other
crashes.

Fixes: 48cac3f4a96ddf08df8e53809ed066de0dc93915 ("bpf: Implement formatted output helpers with bstr_printf")
Assisted-by: Gemini:gemini-3.1-pro-preview Gemini:gemini-3-flash-preview
Reported-by: syzbot+d17177af4afd8c6f804c@syzkaller.appspotmail.com
Link: https://syzkaller.appspot.com/bug?extid=d17177af4afd8c6f804c
Link: https://syzkaller.appspot.com/ai_job?id=081c2505-21d7-4259-a6ab-cad80355a99b
To: <linux-kernel@vger.kernel.org>
Cc: <andrii@kernel.org>
Cc: <ast@kernel.org>
Cc: <bpf@vger.kernel.org>
Cc: <daniel@iogearbox.net>
Cc: <eddyz87@gmail.com>
Cc: <jolsa@kernel.org>
Cc: <martin.lau@linux.dev>
Cc: <memxor@gmail.com>
Cc: <song@kernel.org>
Cc: <yonghong.song@linux.dev>

---
diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
index 2bb60200c..0e3d3bddd 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -921,10 +921,22 @@ int bpf_bprintf_prepare(const char *fmt, u32 fmt_size, const u64 *raw_args,
 
 			if (fmt[i + 1] == 'B') {
 				if (tmp_buf)  {
+					if (tmp_buf >= tmp_buf_end) {
+						err = -ENOSPC;
+						goto out;
+					}
 					err = snprintf(tmp_buf,
 						       (tmp_buf_end - tmp_buf),
 						       "%pB",
 						       (void *)(long)raw_args[num_spec]);
+					if (err < 0) {
+						err = -EINVAL;
+						goto out;
+					}
+					if (err >= tmp_buf_end - tmp_buf) {
+						err = -ENOSPC;
+						goto out;
+					}
 					tmp_buf += (err + 1);
 				}
 
@@ -944,12 +956,13 @@ int bpf_bprintf_prepare(const char *fmt, u32 fmt_size, const u64 *raw_args,
 			if (!tmp_buf)
 				goto nocopy_fmt;
 
-			sizeof_cur_ip = (fmt[i] == '4') ? 4 : 16;
-			if (tmp_buf_end - tmp_buf < sizeof_cur_ip) {
+			if (tmp_buf >= tmp_buf_end) {
 				err = -ENOSPC;
 				goto out;
 			}
 
+			sizeof_cur_ip = (fmt[i] == '4') ? 4 : 16;
+
 			unsafe_ptr = (char *)(long)raw_args[num_spec];
 			err = copy_from_kernel_nofault(cur_ip, unsafe_ptr,
 						       sizeof_cur_ip);
@@ -964,6 +977,14 @@ int bpf_bprintf_prepare(const char *fmt, u32 fmt_size, const u64 *raw_args,
 			ip_spec[3] = fmt[i];
 			err = snprintf(tmp_buf, tmp_buf_end - tmp_buf,
 				       ip_spec, &cur_ip);
+			if (err < 0) {
+				err = -EINVAL;
+				goto out;
+			}
+			if (err >= tmp_buf_end - tmp_buf) {
+				err = -ENOSPC;
+				goto out;
+			}
 
 			tmp_buf += err + 1;
 			num_spec++;
@@ -982,7 +1003,7 @@ int bpf_bprintf_prepare(const char *fmt, u32 fmt_size, const u64 *raw_args,
 			if (!tmp_buf)
 				goto nocopy_fmt;
 
-			if (tmp_buf_end == tmp_buf) {
+			if (tmp_buf >= tmp_buf_end) {
 				err = -ENOSPC;
 				goto out;
 			}
@@ -1004,7 +1025,7 @@ int bpf_bprintf_prepare(const char *fmt, u32 fmt_size, const u64 *raw_args,
 			if (!tmp_buf)
 				goto nocopy_fmt;
 
-			if (tmp_buf_end == tmp_buf) {
+			if (tmp_buf >= tmp_buf_end) {
 				err = -ENOSPC;
 				goto out;
 			}
@@ -1038,7 +1059,7 @@ int bpf_bprintf_prepare(const char *fmt, u32 fmt_size, const u64 *raw_args,
 nocopy_fmt:
 		if (tmp_buf) {
 			tmp_buf = PTR_ALIGN(tmp_buf, sizeof(u32));
-			if (tmp_buf_end - tmp_buf < sizeof_cur_arg) {
+			if (tmp_buf + sizeof_cur_arg > tmp_buf_end) {
 				err = -ENOSPC;
 				goto out;
 			}


base-commit: 5200f5f493f79f14bbdc349e402a40dfb32f23c8
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to send it to the mailing list.
Reply with '#syz reject' to reject it.

See  for more information.
