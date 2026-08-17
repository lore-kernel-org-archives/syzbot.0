Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C64C3AEF5F
	for <syzbot@lists.linux.dev>; Mon, 17 Aug 2026 22:11:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787004681; cv=none; b=hvjQ4nR2fd0u0yYpL24Mj9U+T8nG5ihdYHeYRK87dqhx9S2i9IaDoLBuKYodcuDkX4peH2N2crlHobh70edi22QMdAU1wHx4Q8m9ZMx3MNPBvOS0gkk7HkSYB3yILu3Nk0H0fmNy5tI/tzje2jL/2dO0l9ZebllV4QKziRJtJxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787004681; c=relaxed/simple;
	bh=13rn2XO+i7q6/LV62GgnHV8KcVmshSeL9WmWJigGRJY=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=mlPeZgy095Uu+ai0vb27kCFUNi3nCuummgjDYTwIAg8+6/A0z/qL7JemExtoetb+JkzLVf/VBFveqRHKnhCWNYtqpunoOkpb2OhIXu0c88QLYtdTQCrxAq+Imq6dWgwTR3BBPlfnGhKDSciLhvk4KpaFQ4jsEK0hu5S5t8azZTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TiVPi4Ll; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TiVPi4Ll"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 9F3B91F000E9;
	Mon, 17 Aug 2026 22:11:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787004679;
	bh=7TXyt+Qd2p5bb4CVshBhxTgRAkoEC8I9ogtUVE6jHsI=;
	h=From:To:Cc:Subject:Date;
	b=TiVPi4LlxCrzYBah4BrJQEpMCUSlPpcYq1WNSD5pc/ED+RvflqwNYrDtuy+ffER/K
	 SL+9ja3stOC3Vi4r9fhGRpPvxGRrgcaSsEi2ZsIc1AsP9RExCJ0ezhj2dBYKA5reAX
	 NH7TvP7VIu4esBFlaRa8fAC21Ta3Thm+eUQn8HMRC2KG/9RljE3xBKT6seR1oQlb2C
	 1NvJ3LSMoGM9DY3DAMaPnXJaO3WmZwxOnk0zvTr2f11nASIEwvpmjPf3hVFKbfmYof
	 CfXRtB1uhkUwYu94dTjRgBiUn5oVZXLzDqBQTjplVvoaUrqSut69AXPJIzfOsFLoEB
	 1L6p/+zfNVn2Q==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] media: ttusb-dec: fix buffer overflow in ttusb_dec_send_command()
Message-ID: <e78cd021-f23c-4737-b60c-a57001be13c9@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Mon, 17 Aug 2026 22:11:19 +0000 (UTC)

The ttusb_dec_send_command() function allocates a 64-byte buffer
(COMMAND_PACKET_SIZE + 4) for USB communication. After receiving a
response, it reads the payload length from b[3] (which is fully controlled
by the USB device) and copies the payload into the caller-provided
cmd_result buffer. There are two missing bounds checks. First, b[3] can be
up to 255, exceeding the 60-byte payload capacity of the allocated buffer,
leading to an out-of-bounds read. Second, the size of cmd_result is not
passed to the function, so a large b[3] can cause a buffer overflow in the
destination buffer (e.g., a 4-byte buffer in
ttusbdecfe_dvbt_read_status()).

This can result in a fortify panic:

memcpy: detected buffer overflow: 75 byte read of buffer size 60
WARNING: lib/string_helpers.c:1037 at __fortify_report+0xa0/0xb8
lib/string_helpers.c:1036
...
Call trace:
 __fortify_report+0xa0/0xb8 lib/string_helpers.c:1036 (P)
 __fortify_panic+0x10/0x14 lib/string_helpers.c:1043
 fortify_memcpy_chk include/linux/fortify-string.h:549 [inline]
 ttusb_dec_start_feed+0x0/0x10ac
 drivers/media/usb/ttusb-dec/ttusb_dec.c:372
 ttusb_dec_get_stb_state drivers/media/usb/ttusb-dec/ttusb_dec.c:392
 [inline]
 ttusb_dec_init_stb drivers/media/usb/ttusb-dec/ttusb_dec.c:1413 [inline]
 ttusb_dec_probe+0x724/0x1aa0 drivers/media/usb/ttusb-dec/ttusb_dec.c:1671

Fix this by adding a cmd_result_len parameter to ttusb_dec_send_command()
and the send_command callback in ttusbdecfe_config. Update all callers to
pass the correct buffer size. Inside ttusb_dec_send_command(), validate
param_length, ensure actual_len is at least 4 bytes, and check that b[3]
does not exceed COMMAND_PACKET_SIZE, actual_len - 4, or cmd_result_len.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Assisted-by: Gemini:gemini-3.6-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+e1dbaae5eefaa2dfbc35@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=e1dbaae5eefaa2dfbc35
Link: https://syzkaller.appspot.com/ai_job?id=372cefef-e134-4934-87ec-0fbe6dfbc958
To: <linux-media@vger.kernel.org>
To: "Mauro Carvalho Chehab" <mchehab@kernel.org>
To: "Linus Torvalds" <torvalds@ppc970.osdl.org>
Cc: "Kees Cook" <kees@kernel.org>
Cc: <linux-kernel@vger.kernel.org>

---
diff --git a/drivers/media/usb/ttusb-dec/ttusb_dec.c b/drivers/media/usb/ttusb-dec/ttusb_dec.c
index 825a38759..b54b7b4bb 100644
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
 
+	if (param_length > COMMAND_PACKET_SIZE)
+		return -EINVAL;
+
 	b = kzalloc(COMMAND_PACKET_SIZE + 4, GFP_KERNEL);
 	if (!b)
 		return -ENOMEM;
@@ -366,10 +370,25 @@ static int ttusb_dec_send_command(struct ttusb_dec *dec, const u8 command,
 			       __func__, actual_len, b);
 		}
 
+		if (actual_len < 4) {
+			result = -EIO;
+			goto err_mutex_unlock;
+		}
+
+		if (b[3] > COMMAND_PACKET_SIZE || b[3] > actual_len - 4) {
+			result = -EIO;
+			goto err_mutex_unlock;
+		}
+
 		if (result_length)
 			*result_length = b[3];
-		if (cmd_result && b[3] > 0)
+		if (cmd_result && b[3] > 0) {
+			if (b[3] > cmd_result_len) {
+				result = -EIO;
+				goto err_mutex_unlock;
+			}
 			memcpy(cmd_result, &b[4], b[3]);
+		}
 	}
 
 err_mutex_unlock:
@@ -389,7 +408,8 @@ static int ttusb_dec_get_stb_state (struct ttusb_dec *dec, unsigned int *mode,
 
 	dprintk("%s\n", __func__);
 
-	result = ttusb_dec_send_command(dec, 0x08, 0, NULL, &c_length, c);
+	result = ttusb_dec_send_command(dec, 0x08, 0, NULL, &c_length, c,
+					sizeof(c));
 	if (result)
 		return result;
 
@@ -448,7 +468,7 @@ static void ttusb_dec_set_pids(struct ttusb_dec *dec)
 	memcpy(&b[2], &audio, 2);
 	memcpy(&b[4], &video, 2);
 
-	ttusb_dec_send_command(dec, 0x50, sizeof(b), b, NULL, NULL);
+	ttusb_dec_send_command(dec, 0x50, sizeof(b), b, NULL, NULL, 0);
 
 	dvb_filter_pes2ts_init(&dec->a_pes2ts, dec->pid[DMX_PES_AUDIO],
 			       ttusb_dec_audio_pes2ts_cb, dec);
@@ -902,7 +922,7 @@ static int ttusb_dec_set_interface(struct ttusb_dec *dec,
 			break;
 		case TTUSB_DEC_INTERFACE_IN:
 			result = ttusb_dec_send_command(dec, 0x80, sizeof(b),
-							b, NULL, NULL);
+							b, NULL, NULL, 0);
 			if (result)
 				return result;
 			result = usb_set_interface(dec->udev, 0, 8);
@@ -1021,7 +1041,7 @@ static int ttusb_dec_start_ts_feed(struct dvb_demux_feed *dvbdmxfeed)
 
 	}
 
-	result = ttusb_dec_send_command(dec, 0x80, sizeof(b0), b0, NULL, NULL);
+	result = ttusb_dec_send_command(dec, 0x80, sizeof(b0), b0, NULL, NULL, 0);
 	if (result)
 		return result;
 
@@ -1056,7 +1076,7 @@ static int ttusb_dec_start_sec_feed(struct dvb_demux_feed *dvbdmxfeed)
 	memcpy(&b0[5], &dvbdmxfeed->filter->filter.filter_value[0], 1);
 
 	result = ttusb_dec_send_command(dec, 0x60, sizeof(b0), b0,
-					&c_length, c);
+					&c_length, c, sizeof(c));
 
 	if (!result) {
 		if (c_length == 2) {
@@ -1114,7 +1134,7 @@ static int ttusb_dec_stop_ts_feed(struct dvb_demux_feed *dvbdmxfeed)
 	struct ttusb_dec *dec = dvbdmxfeed->demux->priv;
 	u8 b0[] = { 0x00 };
 
-	ttusb_dec_send_command(dec, 0x81, sizeof(b0), b0, NULL, NULL);
+	ttusb_dec_send_command(dec, 0x81, sizeof(b0), b0, NULL, NULL, 0);
 
 	dec->pva_stream_count--;
 
@@ -1135,7 +1155,7 @@ static int ttusb_dec_stop_sec_feed(struct dvb_demux_feed *dvbdmxfeed)
 	list_del(&finfo->filter_info_list);
 	spin_unlock_irqrestore(&dec->filter_info_list_lock, flags);
 	kfree(finfo);
-	ttusb_dec_send_command(dec, 0x62, sizeof(b0), b0, NULL, NULL);
+	ttusb_dec_send_command(dec, 0x62, sizeof(b0), b0, NULL, NULL, 0);
 
 	dec->filter_stream_count--;
 
@@ -1238,7 +1258,7 @@ static int ttusb_init_rc( struct ttusb_dec *dec)
 	if (usb_submit_urb(dec->irq_urb, GFP_KERNEL))
 		printk("%s: usb_submit_urb failed\n",__func__);
 	/* enable irq pipe */
-	ttusb_dec_send_command(dec,0xb0,sizeof(b),b,NULL,NULL);
+	ttusb_dec_send_command(dec, 0xb0, sizeof(b), b, NULL, NULL, 0);
 
 	return 0;
 }
@@ -1354,7 +1374,7 @@ static int ttusb_dec_boot_dsp(struct ttusb_dec *dec)
 	firmware_csum_ns = htons(firmware_csum);
 	memcpy(&b0[6], &firmware_csum_ns, 2);
 
-	result = ttusb_dec_send_command(dec, 0x41, sizeof(b0), b0, NULL, NULL);
+	result = ttusb_dec_send_command(dec, 0x41, sizeof(b0), b0, NULL, NULL, 0);
 
 	if (result) {
 		release_firmware(fw_entry);
@@ -1395,7 +1415,7 @@ static int ttusb_dec_boot_dsp(struct ttusb_dec *dec)
 		}
 	}
 
-	result = ttusb_dec_send_command(dec, 0x43, sizeof(b1), b1, NULL, NULL);
+	result = ttusb_dec_send_command(dec, 0x43, sizeof(b1), b1, NULL, NULL, 0);
 
 	release_firmware(fw_entry);
 	kfree(b);
@@ -1621,10 +1641,13 @@ static void ttusb_dec_exit_filters(struct ttusb_dec *dec)
 
 static int fe_send_command(struct dvb_frontend* fe, const u8 command,
 			   int param_length, const u8 params[],
-			   int *result_length, u8 cmd_result[])
+			   int *result_length, u8 cmd_result[],
+			   int cmd_result_len)
 {
 	struct ttusb_dec* dec = fe->dvb->priv;
-	return ttusb_dec_send_command(dec, command, param_length, params, result_length, cmd_result);
+	return ttusb_dec_send_command(dec, command, param_length, params,
+				      result_length, cmd_result,
+				      cmd_result_len);
 }
 
 static const struct ttusbdecfe_config fe_config = {
diff --git a/drivers/media/usb/ttusb-dec/ttusbdecfe.c b/drivers/media/usb/ttusb-dec/ttusbdecfe.c
index 215221370..b013d6dfc 100644
--- a/drivers/media/usb/ttusb-dec/ttusbdecfe.c
+++ b/drivers/media/usb/ttusb-dec/ttusbdecfe.c
@@ -44,7 +44,8 @@ static int ttusbdecfe_dvbt_read_status(struct dvb_frontend *fe,
 
 	*status=0;
 
-	ret=state->config->send_command(fe, 0x73, sizeof(b), b, &len, result);
+	ret = state->config->send_command(fe, 0x73, sizeof(b), b, &len, result,
+					  sizeof(result));
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
