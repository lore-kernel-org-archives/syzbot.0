Received: from mail-ej2-f12.google.com (mail-ej2-f12.google.com [74.125.228.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 864DA224234
	for <syzbot@lists.linux.dev>; Thu, 24 Sep 2026 08:49:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790239801; cv=none; b=sAieqxwAwzibLtIs4V3mkIn2ktwvmOTZsOIyDBOq6HOE3+iJmU7OV5XaVxf/mst14n69RO3Sza3sJVv2LacV0T+mY4CrnGCbggQLGnkAEoaVu8JES1tGltDOPv/DnqUnj8VCSGseQ6x+y6hf6sE9dGUoG6Y258wRoC4WB5aiKiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790239801; c=relaxed/simple;
	bh=RTolrfWc72Cy+7e76YB0IcJJ7ooAp/AC6TNHC4OWuek=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TiuF8btp38sF2MsUFxFYPY0I4SPujNj8yWpgXEC1+GT4ZnO073+A1F73l8iW9yUVNDYRZ2cNKe4BHfKkDiMaPsYRY50Tsn/9qve97Dq/EhpvK6gPgSimeJr0licB55jsfD++2nTlNm9IRvb2eyDGs/IWC+tNrfCF39XxPBbxcUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ECQK+oCP; arc=none smtp.client-ip=74.125.228.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ECQK+oCP"
Received: by mail-ej2-f12.google.com with SMTP id a640c23a62f3a-c2940ef15c1so223512366b.1
        for <syzbot@lists.linux.dev>; Thu, 24 Sep 2026 01:49:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790239793; x=1790844593; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=1b80XxLjp7p9yNMOdcMsvgCe3vPig69itQP5JgqdKTA=;
        b=ECQK+oCPQJiT985t33KKWY/NqW921P9yBRSo9odywnmviX3Dg8PEeWu6l0qbBmdr8/
         F0nOUigF2GiedobyTrlFim5yJtVMiNkLdY3zu6Klp0Idp+D74/zh2BibzAzeWvXboxzD
         2BU6Gc/fnL3bvnZELboWDZ51AaWNyqudwQPLw8HIbwU8aQfv7HxS9pW8TOlfe3LKaqM7
         hRl51lmuTIWUeOqTayt8f0GJJB7G7YOiYyXytp2hcAST6Uk1rIY9gGQa1zkZ2Dbi2C36
         4v0TpBCNlp2xDQMJznk7WXCdJeMAE6z/iJ4AdJYGAoztbHSy6QpFJbgKQs2jauNWc6Ny
         Uzrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790239793; x=1790844593;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1b80XxLjp7p9yNMOdcMsvgCe3vPig69itQP5JgqdKTA=;
        b=uqgdyuzYP6r2Jzu+R6inqJarUShi8MneGhyQbLcjV0HNppV4I4Z58EdhABsu1y20Xz
         Ry3ZeP9WRuasryt2xrsSt+o4jCSCqXQW/CfTDWerJhEN7o9kylrnhuZb5NMHuAqovMYV
         FWRxOJRNDVtdwQ8jkOdGbpjpr31WGzGJFoKYgP95Ox557yHsCrPiS7mdV0kvRof6pqr/
         OGLzJ9Pk2PViQpAy3Wlj0T64zt538GAR8oyveKOmBTx+NJjWw+/1PR6l6PZPsPR7ia9X
         tBO5FMugTPIt4e6KxchMDgfvYu7zw4Z9M06kChMwNFJJOuV64VNI0ZvvY3YGBEKst1QY
         AlCQ==
X-Forwarded-Encrypted: i=1; AKwUvBy/Cl9a8e2iRB09Fr87JK1O1ljue33l+pH8Gu8Hbaqn6PQ4hdd9VHA79szYN2RUKPRitLSJnLk=@lists.linux.dev
X-Gm-Message-State: AFuF++l+NexzwDfNwLn1ecsA6tN87natMOzcJSRxgfc8HTXM25YrYnZq
	cOoDceN1gjbWJ3pgISp7HuOZ0yixO5BSItZy27PpwOw2NM3Ijs+nKkxn
X-Gm-Gg: AYBFou25PzjQOqB+9/bPNFfAAFi+zvjZV9OvW+rfZ2zf9xP92pcnbWuJ6W2yYkG3n42
	F9bpdKInNQiZ4j/M2ZjO1SudQJ89PpRdtIq+rCZQ4Go9lsDVwITyDybGiPr17SWfuL2syscLqht
	WcdW1gZ6sKRmRN1ocsxPf2eqF7sWSSANAriXPe0W1MgsAy+FQrZRcEgq8V53iIzrNaSxhDqmxEr
	CzEj9Pts7zEQksmwxdnil+NSVMXazNdJ4lsP2ziMvZUryXffEmmFdsJ+erwldNfGBbOa4stGc3I
	6SNnfzJNipFBweGmS7qTUptwrans7JSMK5Gi+iLtzRLeHOdz8TQ9RHVhNrEJx0IBsra1Q0B63eU
	8XySYCH1y1CRc5opLLZnXH6qXNKuaT4PO/oq5Y5AE3e9XV3Q/broZpUc/rg2e5JUbITbu/Gldc/
	nY2iw2Ro9CtKn/EfpttqKjdHgLE/pLMqNlRIyrzQrcJGvVcKhTlwqfpNxE7gzdoety5U6X2rM3O
	ypAeSMTEnfN4jsh8FPlZmiCyyrg8z5MZK2FW8uTRAeX6mZ54XfwiJ37mhdYHu+DZvRUuiumU//d
	dWNLz2mJJAdZoowb3XQI1DMWBmIML7z2Du4rigPYK974bTcnHHrNYwvD0gmXazRQwacKIqWr8PT
	vOhjzylKC2D9WEfX+6JT81U6devSzquGJLZ/OF5nzQ14thUaFHuM=
X-Received: by 2002:a17:907:7214:b0:c25:c54d:d1a2 with SMTP id a640c23a62f3a-c2ac23c0f05mr127635366b.18.1790239792459;
        Thu, 24 Sep 2026 01:49:52 -0700 (PDT)
Received: from Ubuntu.ts.net (87-205-15-91.static.ip.netia.com.pl. [87.205.15.91])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c2aae687318sm266221466b.44.2026.09.24.01.49.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Sep 2026 01:49:52 -0700 (PDT)
From: Krystian Kaniewski <krystianmkaniewski@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>,
	Vincent Donnefort <vdonnefort@google.com>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	linux-trace-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	linux-kernel@vger.kernel.org,
	syzkaller-bugs@googlegroups.com,
	syzbot@lists.linux.dev,
	syzbot+de3d7f9bcc9212f3fae1@syzkaller.appspotmail.com
Subject: [PATCH v2] ring-buffer: Fix false warning in ring_buffer_map_get_reader()
Date: Thu, 24 Sep 2026 10:49:42 +0200
Message-ID: <20260924084946.20104-1-krystianmkaniewski@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <15bc282f-669e-4a94-911d-bb435513461f@mail.kernel.org>
References: <15bc282f-669e-4a94-911d-bb435513461f@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The mmap reader can warn when it catches up with a writer that is still
committing events. rb_get_reader_page() returns NULL in this case, but
ring_buffer_map_get_reader() treats that result as an error.

The initial rb_per_cpu_empty() check filters out an empty buffer, but it
does not guarantee that the next reader page has committed data. Writers
do not take reader_lock and can advance commit_page before publishing the
committed length on the new page. rb_get_reader_page() can swap to that
page, catch up with the writer and return NULL.

Handle NULL through the existing no-data exit without warning. Remove the
caller's reader_page == commit_page check as well, since the reader-page
helper already handles that case. The existing metadata update and return
path remain in place.

Fixes: 117c39200d9d ("ring-buffer: Introducing ring-buffer mapping functions")
Assisted-by: Gemini:gemini-3.8-flash syzbot
Reported-by: syzbot+de3d7f9bcc9212f3fae1@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=de3d7f9bcc9212f3fae1
Link: https://syzkaller.appspot.com/ai_job?id=488adc18-a10e-42d2-a205-25327c38837f
Signed-off-by: Krystian Kaniewski <krystianmkaniewski@gmail.com>
---
Changes since v1:
- Rewrite the commit message to explain the race more concisely.
- Clarify why the earlier empty-buffer check does not exclude this case.
- Remove the redundant reader_page == commit_page check, as discussed
  with Vincent. Let rb_get_reader_page() handle the caught-up reader.

v1: https://lore.kernel.org/all/15bc282f-669e-4a94-911d-bb435513461f@mail.kernel.org/

 kernel/trace/ring_buffer.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 9c03a555a6ba..9222fc881bc2 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -7990,12 +7990,8 @@ consume:
 		goto out;
 	}
 
-	/* Did the reader catch up with the writer? */
-	if (cpu_buffer->reader_page == cpu_buffer->commit_page)
-		goto out;
-
 	reader = rb_get_reader_page(cpu_buffer);
-	if (WARN_ON(!reader))
+	if (!reader)
 		goto out;
 
 	/* Check if any events were dropped */

base-commit: df2908090cda368b01ff43709f51890076c56157
-- 
2.53.0
