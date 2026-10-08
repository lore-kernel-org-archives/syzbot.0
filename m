Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF5D018AE3
	for <syzbot@lists.linux.dev>; Thu,  8 Oct 2026 00:06:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791417967; cv=none; b=S1PmOAnOOifMisAGYZ7sopABoDVxXOnrZ/al7noXGkiquZpGVq9edmTZN0kxxpn5ZRX30HKJMjKJd72D3h6JEXIXjiuIX9X33XCW1t/Y5R2k6or1aWuprqPvSK5iOVhgEGW324SsC3DHJuM+SWOjCJuNG+7sOpP14OLmzsrUavw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791417967; c=relaxed/simple;
	bh=kAr9FEy5u9ZpKNkbWoealcU7XqczvHkzFdZdh5j0/ck=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=Umojzc+ZIeRs2wvrZVLC1QRVbrVCiJjyiwIv6XtXTR78Us+AtpIBnjF6rud2ZabQIq4rl96yK3NfHF31+s1vW0jY5P0Wv7t97n4KumSUZXAAyNfxh3mNLfiDl4bvmvqUgFdHY9COFtDn1jDhzhhFA9KGZMqrR3px9xLbuYQSR3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YW9qZ5w6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YW9qZ5w6"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 524D81F000FF;
	Thu,  8 Oct 2026 00:06:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791417965;
	bh=GdAuaSgg+ltBQ7GTPkBdioOgrQyyX0Y/ZiH27TWvJwc=;
	h=From:To:Cc:Subject:Date;
	b=YW9qZ5w6QT9nOzLMi0XvKLrJr0F1VQt15LiXOXlv05kUSZ8yyWxzDS39KvwjEiPar
	 rS0rLJ8jhSaDcSg8Ai1cANh8CLbaDRW5AqICenHaCwYezUw0JXSzjQbyze+XnijSEk
	 O3m2JDvTVM7UuP0/wlhvJnVCfnPal6/aaHE01NtIAohL2KE8aSrQEpzHxXOOm3uBJc
	 Qj6AMzb0tLvdbm/T7csaA26AgC+RMyepQO0fYssw7cUkIrzIs+FNsSHoA9LbAVcpVU
	 QZQMnS7q63iWShvVboRRSC0fboqo1PkBFKCZmxTxKErQ8dIHEmlx3y+HZUtYqHGzsO
	 5MhR/kdD9hmag==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: krystianmkaniewski@gmail.com, syzbot@lists.linux.dev
Subject: [PATCH RFC v2] media: ttusb-dec: fix buffer overflow in ttusb_dec_send_command()
Message-ID: <6324a2b9-ac49-4fbd-a6e8-94dd51e93729@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Thu,  8 Oct 2026 00:06:05 +0000 (UTC)

In ttusb_dec_send_command(), a 64-byte buffer is allocated
(COMMAND_PACKET_SIZE + 4, where COMMAND_PACKET_SIZE is 60) for sending a
command to the USB device and receiving the response via usb_bulk_msg().
After receiving the response, the fourth byte b[3] is treated as the
payload length and used directly in memcpy(cmd_result, &b[4], b[3]) without
validating it against the actual number of received bytes (actual_len), the
allocated source buffer bounds, or the capacity of the destination buffer
cmd_result.

During device probe in ttusb_dec_probe(), ttusb_dec_init_stb() calls
ttusb_dec_get_stb_state() to query the device state. If the device returns
a response with an untrusted payload length b[3] greater than
COMMAND_PACKET_SIZE (e.g. 75), memcpy() reads past the end of the source
buffer and overflows the caller's 60-byte destination buffer on the stack,
triggering a FORTIFY_SOURCE buffer overflow failure ("memcpy: detected
buffer overflow: 75 byte read of buffer size 60").

Moreover, other callers such as ttusbdecfe_dvbt_read_status() supply
destination buffers as small as 4 bytes, which can lead to a stack buffer
overflow even if the device returns fewer than 60 bytes. Additionally,
param_length is copied into &b[4] without checking whether it exceeds
COMMAND_PACKET_SIZE.

Fix this by first verifying that param_length is non-negative and does not
exceed COMMAND_PACKET_SIZE. Next, add a cmd_result_len parameter to
ttusb_dec_send_command(), fe_send_command(), and struct
ttusbdecfe_config.send_command to pass the destination buffer capacity, and
update all callers accordingly. Finally, strictly reject malformed replies
with -EIO if actual_len is less than 4 bytes, if the untrusted payload
length b[3] exceeds the remaining received bytes (actual_len - 4), or if
cmd_result is provided and b[3] exceeds cmd_result_len. This ensures that
invalid replies fail safely and memcpy() never performs an out-of-bounds
read or write.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Assisted-by: Gemini:gemini-3.8-flash syzbot
Reported-by: syzbot+e1dbaae5eefaa2dfbc35@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=e1dbaae5eefaa2dfbc35
Link: https://syzkaller.appspot.com/ai_job?id=5d2e7c8a-5cf6-49fe-a6e9-124e4d1e051d
To: <linux-media@vger.kernel.org>
To: "Mauro Carvalho Chehab" <mchehab@kernel.org>
To: "Linus Torvalds" <torvalds@ppc970.osdl.org>
Cc: "Kees Cook" <kees@kernel.org>
Cc: <linux-kernel@vger.kernel.org>

---
v2:
- Strictly reject malformed replies with -EIO instead of clamping the payload length
- Update commit description to reflect strict reply validation and remove the full stack trace

v1:
https://lore.kernel.org/all/84b5473b-2ef9-4a91-90fb-57fea553af7b@mail.kernel.org/T/
---
diff --git a/drivers/media/usb/ttusb-dec/ttusb_dec.c b/drivers/media/usb/ttusb-dec/ttusb_dec.c
index 825a38759..524be8f10 100644
--- a/drivers/media/usb/ttusb-dec/ttusb_dec.c
+++ b/drivers/media/usb/ttusb-dec/ttusb_dec.c
@@ -314,13 +314,17 @@ static u16 crc16(u16 crc, const u8 *buf, size_t len)
 
 static int ttusb_dec_send_command(struct ttusb_dec *dec, const u8 command,
 				  int param_length, const u8 params[],
-				  int *result_length, u8 cmd_result[])
+				  int *result_length, u8 cmd_result[],
+				  int cmd_result_len)
 {
 	int result, actual_len;
 	u8 *b;
 
 	dprintk("%s\n", __func__);
 
+	if (param_length < 0 || param_length > COMMAND_PACKET_SIZE)
+		return -EINVAL;
+
 	b = kzalloc(COMMAND_PACKET_SIZE + 4, GFP_KERNEL);
 	if (!b)
 		return -ENOMEM;
@@ -366,6 +370,12 @@ static int ttusb_dec_send_command(struct ttusb_dec *dec, const u8 command,
 			       __func__, actual_len, b);
 		}
 
+		if (actual_len < 4 || b[3] > actual_len - 4 ||
+		    (cmd_result && b[3] > cmd_result_len)) {
+			result = -EIO;
+			goto err_mutex_unlock;
+		}
+
 		if (result_length)
 			*result_length = b[3];
 		if (cmd_result && b[3] > 0)
@@ -389,7 +399,8 @@ static int ttusb_dec_get_stb_state (struct ttusb_dec *dec, unsigned int *mode,
 
 	dprintk("%s\n", __func__);
 
-	result = ttusb_dec_send_command(dec, 0x08, 0, NULL, &c_length, c);
+	result = ttusb_dec_send_command(dec, 0x08, 0, NULL, &c_length, c,
+					sizeof(c));
 	if (result)
 		return result;
 
@@ -448,7 +459,7 @@ static void ttusb_dec_set_pids(struct ttusb_dec *dec)
 	memcpy(&b[2], &audio, 2);
 	memcpy(&b[4], &video, 2);
 
-	ttusb_dec_send_command(dec, 0x50, sizeof(b), b, NULL, NULL);
+	ttusb_dec_send_command(dec, 0x50, sizeof(b), b, NULL, NULL, 0);
 
 	dvb_filter_pes2ts_init(&dec->a_pes2ts, dec->pid[DMX_PES_AUDIO],
 			       ttusb_dec_audio_pes2ts_cb, dec);
@@ -902,7 +913,7 @@ static int ttusb_dec_set_interface(struct ttusb_dec *dec,
 			break;
 		case TTUSB_DEC_INTERFACE_IN:
 			result = ttusb_dec_send_command(dec, 0x80, sizeof(b),
-							b, NULL, NULL);
+							b, NULL, NULL, 0);
 			if (result)
 				return result;
 			result = usb_set_interface(dec->udev, 0, 8);
@@ -1021,7 +1032,7 @@ static int ttusb_dec_start_ts_feed(struct dvb_demux_feed *dvbdmxfeed)
 
 	}
 
-	result = ttusb_dec_send_command(dec, 0x80, sizeof(b0), b0, NULL, NULL);
+	result = ttusb_dec_send_command(dec, 0x80, sizeof(b0), b0, NULL, NULL, 0);
 	if (result)
 		return result;
 
@@ -1056,7 +1067,7 @@ static int ttusb_dec_start_sec_feed(struct dvb_demux_feed *dvbdmxfeed)
 	memcpy(&b0[5], &dvbdmxfeed->filter->filter.filter_value[0], 1);
 
 	result = ttusb_dec_send_command(dec, 0x60, sizeof(b0), b0,
-					&c_length, c);
+					&c_length, c, sizeof(c));
 
 	if (!result) {
 		if (c_length == 2) {
@@ -1114,7 +1125,7 @@ static int ttusb_dec_stop_ts_feed(struct dvb_demux_feed *dvbdmxfeed)
 	struct ttusb_dec *dec = dvbdmxfeed->demux->priv;
 	u8 b0[] = { 0x00 };
 
-	ttusb_dec_send_command(dec, 0x81, sizeof(b0), b0, NULL, NULL);
+	ttusb_dec_send_command(dec, 0x81, sizeof(b0), b0, NULL, NULL, 0);
 
 	dec->pva_stream_count--;
 
@@ -1135,7 +1146,7 @@ static int ttusb_dec_stop_sec_feed(struct dvb_demux_feed *dvbdmxfeed)
 	list_del(&finfo->filter_info_list);
 	spin_unlock_irqrestore(&dec->filter_info_list_lock, flags);
 	kfree(finfo);
-	ttusb_dec_send_command(dec, 0x62, sizeof(b0), b0, NULL, NULL);
+	ttusb_dec_send_command(dec, 0x62, sizeof(b0), b0, NULL, NULL, 0);
 
 	dec->filter_stream_count--;
 
@@ -1238,7 +1249,7 @@ static int ttusb_init_rc( struct ttusb_dec *dec)
 	if (usb_submit_urb(dec->irq_urb, GFP_KERNEL))
 		printk("%s: usb_submit_urb failed\n",__func__);
 	/* enable irq pipe */
-	ttusb_dec_send_command(dec,0xb0,sizeof(b),b,NULL,NULL);
+	ttusb_dec_send_command(dec, 0xb0, sizeof(b), b, NULL, NULL, 0);
 
 	return 0;
 }
@@ -1354,7 +1365,7 @@ static int ttusb_dec_boot_dsp(struct ttusb_dec *dec)
 	firmware_csum_ns = htons(firmware_csum);
 	memcpy(&b0[6], &firmware_csum_ns, 2);
 
-	result = ttusb_dec_send_command(dec, 0x41, sizeof(b0), b0, NULL, NULL);
+	result = ttusb_dec_send_command(dec, 0x41, sizeof(b0), b0, NULL, NULL, 0);
 
 	if (result) {
 		release_firmware(fw_entry);
@@ -1395,7 +1406,7 @@ static int ttusb_dec_boot_dsp(struct ttusb_dec *dec)
 		}
 	}
 
-	result = ttusb_dec_send_command(dec, 0x43, sizeof(b1), b1, NULL, NULL);
+	result = ttusb_dec_send_command(dec, 0x43, sizeof(b1), b1, NULL, NULL, 0);
 
 	release_firmware(fw_entry);
 	kfree(b);
@@ -1621,10 +1632,12 @@ static void ttusb_dec_exit_filters(struct ttusb_dec *dec)
 
 static int fe_send_command(struct dvb_frontend* fe, const u8 command,
 			   int param_length, const u8 params[],
-			   int *result_length, u8 cmd_result[])
+			   int *result_length, u8 cmd_result[],
+			   int cmd_result_len)
 {
 	struct ttusb_dec* dec = fe->dvb->priv;
-	return ttusb_dec_send_command(dec, command, param_length, params, result_length, cmd_result);
+	return ttusb_dec_send_command(dec, command, param_length, params,
+				      result_length, cmd_result, cmd_result_len);
 }
 
 static const struct ttusbdecfe_config fe_config = {
diff --git a/drivers/media/usb/ttusb-dec/ttusbdecfe.c b/drivers/media/usb/ttusb-dec/ttusbdecfe.c
index 215221370..1c2892a1e 100644
--- a/drivers/media/usb/ttusb-dec/ttusbdecfe.c
+++ b/drivers/media/usb/ttusb-dec/ttusbdecfe.c
@@ -44,7 +44,8 @@ static int ttusbdecfe_dvbt_read_status(struct dvb_frontend *fe,
 
 	*status=0;
 
-	ret=state->config->send_command(fe, 0x73, sizeof(b), b, &len, result);
+	ret = state->config->send_command(fe, 0x73, sizeof(b), b, &len,
+					  result, sizeof(result));
 	if(ret)
 		return ret;
 
@@ -85,7 +86,7 @@ static int ttusbdecfe_dvbt_set_frontend(struct dvb_frontend *fe)
 
 	__be32 freq = htonl(p->frequency / 1000);
 	memcpy(&b[4], &freq, sizeof (u32));
-	state->config->send_command(fe, 0x71, sizeof(b), b, NULL, NULL);
+	state->config->send_command(fe, 0x71, sizeof(b), b, NULL, NULL, 0);
 
 	return 0;
 }
@@ -130,7 +131,7 @@ static int ttusbdecfe_dvbs_set_frontend(struct dvb_frontend *fe)
 	lnb_voltage = htonl(state->voltage);
 	memcpy(&b[28], &lnb_voltage, sizeof(u32));
 
-	state->config->send_command(fe, 0x71, sizeof(b), b, NULL, NULL);
+	state->config->send_command(fe, 0x71, sizeof(b), b, NULL, NULL, 0);
 
 	return 0;
 }
@@ -149,7 +150,7 @@ static int ttusbdecfe_dvbs_diseqc_send_master_cmd(struct dvb_frontend* fe, struc
 
 	state->config->send_command(fe, 0x72,
 				    sizeof(b) - (6 - cmd->msg_len), b,
-				    NULL, NULL);
+				    NULL, NULL, 0);
 
 	return 0;
 }
diff --git a/drivers/media/usb/ttusb-dec/ttusbdecfe.h b/drivers/media/usb/ttusb-dec/ttusbdecfe.h
index 73828bb22..96600ad4c 100644
--- a/drivers/media/usb/ttusb-dec/ttusbdecfe.h
+++ b/drivers/media/usb/ttusb-dec/ttusbdecfe.h
@@ -14,7 +14,8 @@ struct ttusbdecfe_config
 {
 	int (*send_command)(struct dvb_frontend* fe, const u8 command,
 			    int param_length, const u8 params[],
-			    int *result_length, u8 cmd_result[]);
+			    int *result_length, u8 cmd_result[],
+			    int cmd_result_len);
 };
 
 extern struct dvb_frontend* ttusbdecfe_dvbs_attach(const struct ttusbdecfe_config* config);


base-commit: 93f51579e7df248780214094418f205253383cc5
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to Sign-off the patch as a human author
and send it to the upstream kernel mailing lists.
Reply with '#syz reject' to reject it ('#syz unreject' to undo).

See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
You can comment on the patch as usual, syzbot will try to address
the comments and send a new version of the patch if necessary.
syzbot engineers can be reached at syzkaller@googlegroups.com.
