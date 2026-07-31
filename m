Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A3DF43D515
	for <syzbot@lists.linux.dev>; Fri, 31 Jul 2026 15:26:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785511612; cv=none; b=uJ/yjgkrQXTmnKwnJ1cTaJAdXWWnZiD7GLaDzh6E6Bqnv1YKeQ6X0TY0aEhhDfsvRBiEC5zKRGDQo72nmchQAJq90JURRcw6q4crWT2EES2ktRUVfMdSqF0P8PJ0TYY0x8C5ROoktMSEiizVlYtB4dwqFRJwUIsNyVjGLxZJqZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785511612; c=relaxed/simple;
	bh=ekZSXlK7nOWmxBvqyYWcsvILC5Ha00m9agYcLRTMXgU=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=aX3njAGhnAgpktocIhZab+toYhiuzBOlT8GDVDf84rtybeoLFJ5ahXlN6oFoH2elyLFwyIq8yU6kcztTIFttRlU08eHER8PmI5ZTbCYiQZ6FA0KZWslENmZma57fBcfImjn3Nd1oiIRne0RSZsl/uSUIPPyBsTTIvplhDMI+jcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YpnnwHCm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YpnnwHCm"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 9C42E1F00A3A;
	Fri, 31 Jul 2026 15:26:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785511610;
	bh=vLPkfYcUGl/B+XidVKISuiin6j5FwdN6WAva/6ZI3Q0=;
	h=From:To:Cc:Subject:Date;
	b=YpnnwHCmoBjBD7+F9UNAD94Q9ufQCC5c/i0+VdZSf7ncSNlLfpeq1tK7Fd/GiVTfe
	 1slH0mGwZamsZXsqrDnv4ozhQXRWzzfxt1ZEJxfmKLWbdV7SZ7oYlfQQQCh7s+UpXQ
	 Ct6HMssl+q5LLOsbaCLv50hcJY2ZWpQx1UEBb36sfKlWZGlTGjyxUTFmHIaCgmwXvn
	 1aoYvYkKRjGxI0wlm9LmCkPTuJMmqy7WhfIUMi0G2bcOzzUJekL9GC7u9mNYcjuoyR
	 S4NcWJdEy+djgAXy+upa9gAQJ7AQHca274oQ45QI2FS+drX6ep9UiHjuib7yKhcSwu
	 s01itPnLxorVw==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] x86/cpu: Replace WARN_ON() with pr_err() for late feature clearing
Message-ID: <ab024666-d81f-4373-be4a-775133519fb2@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Fri, 31 Jul 2026 15:26:50 +0000 (UTC)

A warning can be triggered when a CPU feature is cleared after alternatives
have been patched. This can happen if a privileged user modifies
architectural MSRs (like MSR_IA32_MISC_ENABLE) from userspace and then
hotplugs a CPU. This creates an inconsistent SMP state where a secondary
CPU lacks a feature that the boot CPU had.

The warning looks like this:

------------[ cut here ]------------
alternatives_patched
WARNING: arch/x86/kernel/cpu/cpuid-deps.c:127 at
do_clear_cpu_cap+0x416/0x450 arch/x86/kernel/cpu/cpuid-deps.c:127, CPU#1:
swapper/1/0
Call Trace:
 <TASK>
 early_init_intel+0xb3d/0xea0 arch/x86/kernel/cpu/intel.c:309
 init_intel+0x28/0x780 arch/x86/kernel/cpu/intel.c:528
 identify_cpu+0xc7a/0x3660 arch/x86/kernel/cpu/common.c:2053
 identify_secondary_cpu+0xaa/0x160 arch/x86/kernel/cpu/common.c:2177
 ap_starting+0x9c/0x150 arch/x86/kernel/smpboot.c:190
 start_secondary+0x66/0x110 arch/x86/kernel/smpboot.c:280
 common_startup_64+0x13e/0x157
 </TASK>

WARN_ON() must not be used for conditions that can legitimately happen,
such as a privileged user modifying MSRs or a broken BIOS. Replace the
WARN_ON() with a pr_err() that logs a clear error message indicating that a
CPU feature was cleared late, and explicitly prints the name of the feature
being cleared to provide better context.

To achieve this, move the x86_feature_name() helper function higher up in
arch/x86/kernel/cpu/cpuid-deps.c so it can be utilized inside
do_clear_cpu_cap().

Fixes: ee8962082a44 ("x86/alternatives: Catch late X86_FEATURE modifiers")
Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+907f82f5bbbf4a0d89fc@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=907f82f5bbbf4a0d89fc
Link: https://syzkaller.appspot.com/ai_job?id=c3c1fb43-1c46-43f9-9819-b9e6b7d3e0b4
To: "Borislav Petkov" <bp@alien8.de>
To: "Dave Hansen" <dave.hansen@linux.intel.com>
To: <linux-kernel@vger.kernel.org>
To: "Ingo Molnar" <mingo@redhat.com>
To: "Thomas Gleixner" <tglx@kernel.org>
To: <x86@kernel.org>
Cc: "Babu Moger" <babu.moger@amd.com>
Cc: "Elena Reshetova" <elena.reshetova@intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Reinette Chatre" <reinette.chatre@intel.com>
Cc: "Sohil Mehta" <sohil.mehta@intel.com>
Cc: "Tom Lendacky" <thomas.lendacky@amd.com>

---
diff --git a/arch/x86/kernel/cpu/cpuid-deps.c b/arch/x86/kernel/cpu/cpuid-deps.c
index 99801e844..a7c57cc81 100644
--- a/arch/x86/kernel/cpu/cpuid-deps.c
+++ b/arch/x86/kernel/cpu/cpuid-deps.c
@@ -114,6 +114,21 @@ static inline void clear_feature(struct cpuinfo_x86 *c, unsigned int feature)
 /* Take the capabilities and the BUG bits into account */
 #define MAX_FEATURE_BITS ((NCAPINTS + NBUGINTS) * sizeof(u32) * 8)
 
+/*
+ * Return the feature "name" if available, otherwise return
+ * the X86_FEATURE_* numerals to make it easier to identify
+ * the feature.
+ */
+static const char *x86_feature_name(unsigned int feature, char *buf)
+{
+	if (x86_cap_flags[feature])
+		return x86_cap_flags[feature];
+
+	snprintf(buf, 16, "%d*32+%2d", feature / 32, feature % 32);
+
+	return buf;
+}
+
 static void do_clear_cpu_cap(struct cpuinfo_x86 *c, unsigned int feature)
 {
 	DECLARE_BITMAP(disable, MAX_FEATURE_BITS);
@@ -123,8 +138,12 @@ static void do_clear_cpu_cap(struct cpuinfo_x86 *c, unsigned int feature)
 	if (WARN_ON(feature >= MAX_FEATURE_BITS))
 		return;
 
-	if (boot_cpu_has(feature))
-		WARN_ON(alternatives_patched);
+	if (boot_cpu_has(feature) && alternatives_patched) {
+		char feature_buf[16];
+
+		pr_err("x86/cpu: CPU feature %s cleared after alternatives patched\n",
+		       x86_feature_name(feature, feature_buf));
+	}
 
 	clear_feature(c, feature);
 
@@ -157,21 +176,6 @@ void setup_clear_cpu_cap(unsigned int feature)
 	do_clear_cpu_cap(NULL, feature);
 }
 
-/*
- * Return the feature "name" if available, otherwise return
- * the X86_FEATURE_* numerals to make it easier to identify
- * the feature.
- */
-static const char *x86_feature_name(unsigned int feature, char *buf)
-{
-	if (x86_cap_flags[feature])
-		return x86_cap_flags[feature];
-
-	snprintf(buf, 16, "%d*32+%2d", feature / 32, feature % 32);
-
-	return buf;
-}
-
 void check_cpufeature_deps(struct cpuinfo_x86 *c)
 {
 	char feature_buf[16], depends_buf[16];


base-commit: f5098b6bae761e346ebcd9da7f95622c04733cff
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to Sign-off the patch as a human author
and send it to the upstream kernel mailing lists.
Reply with '#syz reject' to reject it ('#syz unreject' to undo).

See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
You can comment on the patch as usual, syzbot will try to address
the comments and send a new version of the patch if necessary.
syzbot engineers can be reached at syzkaller@googlegroups.com.
