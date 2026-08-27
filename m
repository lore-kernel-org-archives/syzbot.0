Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7714E27CCE0
	for <syzbot@lists.linux.dev>; Thu, 27 Aug 2026 00:50:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787791824; cv=none; b=hi+SZNRSuxmsFsgi3kt2PPeBOWVu0CAC3w/vN3J1HfxICODQY2jP7Z/L3cwLKWdkxosQtCzxuMisVs8MH1EdYnRLjNyX/IUwiBiKOhpVWSS3BM4BzTIw7wWg2maY4q6lWHaCurBj5eLobfatewZdTkdVEk3UEQ6T+a59KsBBNqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787791824; c=relaxed/simple;
	bh=x45RyO1DR0RsbgyO0MBTfO8yHPKAu2WXzifa4EHSZyY=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=tAg0L2H/Q8Q1LixshE5dd+Yx+XM2lGN0LeLjroHKnXvUtSExdmyqr3IZs2MpU2l6EXjWX6kKaktd//Gu8SyyD6QNz/Akr12C8ewfUBaaP/N2Nf8H912y5dCyX//AOACYdLYPc0WFXsZMyafeVayPAg8d6rriM3bZeN5jqyq2fGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bSLX9K3/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bSLX9K3/"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id E13D11F000E9;
	Thu, 27 Aug 2026 00:50:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787791823;
	bh=KmGyiWQJ5BdDGuNotI/0IY4bU34hKM0WTox8fkXETWk=;
	h=From:To:Cc:Subject:Date;
	b=bSLX9K3/ZYph2d7DQcRNqyUqj4xnt36BXf6xAPT4NYj5tVH8qKdcfP1c80OjUrOi7
	 f6Sem9wSgKzhdVJLlcQvjTTfnKgugrO1RYLoyl2u0/6kC+F7z85vnQ/+tRlbIJSdLQ
	 T7AViQe8QYGxTY2AIH+V5rVx+wBdrWkFJXxQ3j4oMiGH1QveGkvtBdaBCXpOWKkrWZ
	 e12qrbD0HMiVXPP+Xd8cwaGzO+fv2eXcC1C+9TL1fr9nzhcHt0ruuoDjnVGbVk4w2h
	 hczcjBhZPxgD7kaBM7Taia+8PQpsCnNVNVe0oCsm5sp6K3S5cdXcqwliFpZjogSule
	 eZBH0jfHXcmgQ==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] nfc: llcp: Fix out-of-bounds reads in pr_debug() calls
Message-ID: <e062a9ce-ba97-415c-9853-e55b5f92185e@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Thu, 27 Aug 2026 00:50:22 +0000 (UTC)

When binding an NFC LLCP socket, userspace provides a sockaddr_nfc_llcp
structure containing a service name and its length (service_name_len). In
llcp_sock_bind(), memory for the service name is allocated using kmemdup()
with the exact length provided. Because kmemdup() copies only
service_name_len bytes, the resulting buffer is not guaranteed to be
null-terminated. When llcp_sock_bind() subsequently calls
nfc_llcp_get_sdp_ssap(), it invokes nfc_llcp_wks_sap(), which attempts to
print service_name using pr_debug("%s\n", service_name). When dynamic
debugging is enabled, vsnprintf() reads past the bounds of the allocated
buffer until it finds a null byte, triggering a KASAN slab-out-of-bounds
read:

BUG: KASAN: slab-out-of-bounds in string_nocheck+0xd8/0x140
lib/vsprintf.c:648
Read of size 1 at addr ffff0000d3cd4e5c

Call trace:
 string_nocheck+0xd8/0x140 lib/vsprintf.c:648
 string+0x8c/0xc8 lib/vsprintf.c:730
 vsnprintf+0x880/0xd10 lib/vsprintf.c:2945
 pointer+0x668/0x734 lib/vsprintf.c:2573
 vsnprintf+0x618/0xd10 lib/vsprintf.c:2949
 _printk+0xe0/0x130 kernel/printk/printk.c:2504
 __dynamic_pr_debug+0x148/0x1e4 lib/dynamic_debug.c:879
 nfc_llcp_wks_sap net/nfc/llcp_core.c:344 [inline]
 nfc_llcp_get_sdp_ssap+0x350/0x3fc net/nfc/llcp_core.c:420
 llcp_sock_bind+0x2e0/0x58c net/nfc/llcp_sock.c:114
 __sys_bind+0x1c4/0x268 net/socket.c:1951

Similar issues exist in two other locations in the LLCP subsystem: in
nfc_llcp_recv_snl(), pr_debug("Looking for %.16s\n", service_name) reads up
to 16 bytes from packet buffer data even when service_name_len is shorter
than 16 bytes; in nfc_llcp_build_sdreq_tlv(), pr_debug("uri: %s, len:
%zu\n", uri, uri_len) prints a URI buffer passed from Netlink attribute
data which is not guaranteed to be null-terminated.

Fix these issues by using the "%.*s" precision format specifier with
explicit lengths ((int)service_name_len and (int)uri_len) for these
pr_debug() calls, ensuring vsnprintf() never reads past the bounded buffer
lengths.

Fixes: d646960f7986 ("NFC: Initial LLCP support")
Assisted-by: Gemini:gemini-3.7-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+1e3df0852e82c21ca418@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=1e3df0852e82c21ca418
Link: https://syzkaller.appspot.com/ai_job?id=cfd94357-aa11-4c11-8b2d-74269e2bc0e6
To: "David S. Miller" <davem@davemloft.net>
To: "David Heidelberg" <david@ixit.cz>
To: "Eric Dumazet" <edumazet@google.com>
To: "Jakub Kicinski" <kuba@kernel.org>
To: <netdev@vger.kernel.org>
To: <oe-linux-nfc@lists.linux.dev>
To: "Paolo Abeni" <pabeni@redhat.com>
To: "Samuel Ortiz" <sameo@linux.intel.com>
Cc: "Simon Horman" <horms@kernel.org>
Cc: <linux-kernel@vger.kernel.org>

---
diff --git a/net/nfc/llcp_commands.c b/net/nfc/llcp_commands.c
index 291f26fac..476004ebb 100644
--- a/net/nfc/llcp_commands.c
+++ b/net/nfc/llcp_commands.c
@@ -135,7 +135,7 @@ struct nfc_llcp_sdp_tlv *nfc_llcp_build_sdreq_tlv(u8 tid, const char *uri,
 {
 	struct nfc_llcp_sdp_tlv *sdreq;
 
-	pr_debug("uri: %s, len: %zu\n", uri, uri_len);
+	pr_debug("uri: %.*s, len: %zu\n", (int)uri_len, uri, uri_len);
 
 	/* sdreq->tlv_len is u8, takes uri_len, + 3 for header, + 1 for NULL */
 	if (WARN_ON_ONCE(uri_len > U8_MAX - 4))
diff --git a/net/nfc/llcp_core.c b/net/nfc/llcp_core.c
index dc65c719f..970820aa9 100644
--- a/net/nfc/llcp_core.c
+++ b/net/nfc/llcp_core.c
@@ -341,7 +341,7 @@ static int nfc_llcp_wks_sap(const char *service_name, size_t service_name_len)
 {
 	int sap, num_wks;
 
-	pr_debug("%s\n", service_name);
+	pr_debug("%.*s\n", (int)service_name_len, service_name);
 
 	if (service_name == NULL)
 		return -EINVAL;
@@ -1320,7 +1320,7 @@ static void nfc_llcp_recv_snl(struct nfc_llcp_local *local,
 			service_name = (char *) &tlv[3];
 			service_name_len = length - 1;
 
-			pr_debug("Looking for %.16s\n", service_name);
+			pr_debug("Looking for %.*s\n", (int)service_name_len, service_name);
 
 			if (service_name_len == strlen("urn:nfc:sn:sdp") &&
 			    !strncmp(service_name, "urn:nfc:sn:sdp",


base-commit: 8d3ae59288f1e7d58d76558a6ee96d533bc5019f
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to Sign-off the patch as a human author
and send it to the upstream kernel mailing lists.
Reply with '#syz reject' to reject it ('#syz unreject' to undo).

See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
You can comment on the patch as usual, syzbot will try to address
the comments and send a new version of the patch if necessary.
syzbot engineers can be reached at syzkaller@googlegroups.com.
