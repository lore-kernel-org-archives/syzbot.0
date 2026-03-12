Received: from dispatch1-us1.ppe-hosted.com (dispatch1-us1.ppe-hosted.com [148.163.129.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0821375F88
	for <syzbot@lists.linux.dev>; Thu, 12 Mar 2026 15:26:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.129.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773329163; cv=none; b=po7XLTxjDXKKvDfJsNjbjmzghc5bVR1B1BBKZj3UP+d39s1fmUifIST1AdELlXN+dqAmswjP+L6Z5yoSTJiS/T+GLtF3wvHwIRKsu54K6v7jHsrfwuoKeb8yHE3A8+7yQ9jdVdtT7ZW8ecEJu7+fj6eoZcNOAsyzLhjGwfJYQE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773329163; c=relaxed/simple;
	bh=GxBZGsZcjbhkPfeni9/dqSoSwNOLFB7WrPvV+OQrcO8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oXnY8esBeGDyK0XdSHXrCPU0s7jEriYoSTmkvNB/MOynAqKKPtNQ7mUx6Sq6Dl62VUXR2WYUo6i9/5eQMtBJps3kKTQ3YUS05ztZF5oVWb3Q2iKJC4XU0ZPAmZjc+stEI1lvYL6gw+LOGAOtOeHRXzyUeavPY+9fMO+1wbJ4BSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=candelatech.com; spf=pass smtp.mailfrom=candelatech.com; dkim=pass (1024-bit key) header.d=candelatech.com header.i=@candelatech.com header.b=UYDCR6vu; arc=none smtp.client-ip=148.163.129.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=candelatech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=candelatech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=candelatech.com header.i=@candelatech.com header.b="UYDCR6vu"
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mail3.candelatech.com (mail.candelatech.com [208.74.158.173])
	by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 1A0DD1C0077;
	Thu, 12 Mar 2026 15:26:00 +0000 (UTC)
Received: from [192.168.100.159] (firewall.candelatech.com [50.251.239.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by mail3.candelatech.com (Postfix) with ESMTPSA id C351713C2B0;
	Thu, 12 Mar 2026 08:25:57 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com C351713C2B0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
	s=default; t=1773329157;
	bh=GxBZGsZcjbhkPfeni9/dqSoSwNOLFB7WrPvV+OQrcO8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=UYDCR6vuSeCvEigdLy8t4YPLuP94rGVvfk9KsLOu5TrTW6Z/OJxXzCjMBq5JCmRpX
	 A+V2bxltwiXaU0AumVOCJX+QYCA/GDlotZ+P+73+JmRwYYPVC1KKNF9WNlzkn0wTg1
	 vYhphogDuJBZOU9rJMn2Wv93PEaLhNcdsmIxqhqU=
Message-ID: <1e6b8cbb-0f89-6b9b-b2cf-d21ca80dd7a2@candelatech.com>
Date: Thu, 12 Mar 2026 08:25:57 -0700
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [syzbot ci] Re: iwlwifi + mac80211 stability
Content-Language: en-US
To: syzbot ci <syzbot+cibf86f11719f1261d@syzkaller.appspotmail.com>,
 linux-wireless@vger.kernel.org
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
References: <69b2ccdb.a00a0220.707e5.0016.GAE@google.com>
From: Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
In-Reply-To: <69b2ccdb.a00a0220.707e5.0016.GAE@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-MDID: 1773329161-dDe3xVk7VNRa
X-PPE-STACK: {"stack":"us5"}
X-MDID-O:
 us5;ut7;1773329161;dDe3xVk7VNRa;<greearb@candelatech.com>;04bf2bda8b1ce0f817f0a112ab4abb0d
X-PPE-TRUSTED: V=1;DIR=OUT;

On 3/12/26 07:25, syzbot ci wrote:
> syzbot ci has tested the following series

Thank you syzbot.

The logs show this:

[   74.595871][   T64] wlan0: Created IBSS using preconfigured BSSID 50:50:50:50:50:50
[   74.604375][   T64] wlan0: Creating new IBSS network, BSSID 50:50:50:50:50:50
[   74.621865][ T1095] wlan1: Created IBSS using preconfigured BSSID 50:50:50:50:50:50
[   74.624268][ T1095] wlan1: Creating new IBSS network, BSSID 50:50:50:50:50:50
[   74.667157][ T5962] Failed to create local keys debugfs dir, rv: -13 phyd: 0xfffffffffffffff3
[   74.673187][ T5962] wlan2: Failed to create netdev dir, rv: -13 name: netdev:wlan2 wiphy dir: 0xfffffffffffffff3
[   74.885583][ T5553] ------------[ cut here ]------------


Which would be triggered by this from patch 0004, I guess.   The phyd
pointer appears to be an error code -13 instead of clean NULL, so I guess I
need to add checks for where that is created as well.

--- a/net/mac80211/debugfs.c
+++ b/net/mac80211/debugfs.c
@@ -680,6 +680,12 @@ void debugfs_hw_add(struct ieee80211_local *local)
  		return;

  	local->debugfs.keys = debugfs_create_dir("keys", phyd);
+	if (IS_ERR(local->debugfs.keys)) {
+		pr_err("Failed to create local keys debugfs dir, rv: %ld phyd: 0x%px\n",
+		       (long)(local->debugfs.keys), phyd);
+		local->debugfs.keys = NULL;
+		return;
+	}

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com


