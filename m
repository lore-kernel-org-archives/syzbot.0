Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A47E9259498
	for <syzbot@lists.linux.dev>; Sun,  2 Aug 2026 20:47:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785703632; cv=none; b=pXtL18107o7naRRBFXFwWNM67sJPug7u/aienr3z2uKHKkNAuCaUPGV0eTNgYpFt/QlQNC72wJvBeGXPI3i0iHchOJG1acTJseCS59lXRpk9oLox6s29IfNjrRHtJRbFj+FtLWimYt+wKIgpQj8OBdHIi5wrkyiK3o+lm1HdSKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785703632; c=relaxed/simple;
	bh=MGvJ6IW9bTcjwxz446L77nlvrlAt7quw67uI/Xu9AVM=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=KwaTUfn+euivja7lLppnhj+nvywyMNMX8R5ng4jIoUr3RhYJg5ySfeaXFWYAiokZgJCLmpB6Cf95YEQyDNFf/Pd7ezVEy5bI3knCoqXPcsj2Svi+uGb8ZoiS4tA6tzUpNfrTD0UoPFmfdzjICVXL2WvgCtkCYKuKotlv/kcM764=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fBMjRJx3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fBMjRJx3"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 756EF1F00A3A;
	Sun,  2 Aug 2026 20:47:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785703630;
	bh=JKNCbEvyILTyitRkboJsY2QayOUgKErViz0TckvaiMo=;
	h=From:To:Cc:Subject:Date;
	b=fBMjRJx3UfGyK3t6voAxETS1Kbr0m0+B53mf/TO5DcKChUyXzDCHq0SubT1RgxTlQ
	 MlwBuyc6UPkUO47fJ+eg4TtPc2yjfu8E5dRKncAvzdhbZKCW4TZrLc0aPEgITxiwF8
	 pSeKXuiliDVJPnuBgW4UtdckHR5N9rZqAztywYqiUru2TyI0q6mylGPhM5bsfuXwol
	 AvFmB/jvJbKvdzqqHTPph7cD3IA0YPwbbRZKM5ulQGRBODyg22hrJYe6JNQZXY7T2/
	 e+L5g462yNzSePOiKKmanNBxgU2RQZanFvb2MG6RQyqW2FODWUwKdQKZaFnmspEBdF
	 NtHJbVTpFDfyg==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] media: ttusb-dec: fix buffer overflow in ttusb_dec_send_command()
Message-ID: <9ffeb96e-84cb-45be-b55c-93826550f3bd@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Sun,  2 Aug 2026 20:47:10 +0000 (UTC)

The `ttusb_dec_send_command()` function sends a command to the USB device
and reads back the response into a dynamically allocated buffer. If the
bulk message succeeds, the function blindly trusts `b[3]` (which is
controlled by the USB device) as the length of the payload to copy into the
caller-provided `cmd_result` buffer.

This leads to two distinct buffer overflow issues. First, a read overflow:
the buffer `b` is 64 bytes long, meaning the payload starting at `&b[4]`
has exactly 60 bytes of space. If the device sends a packet where `b[3] >
60`, `memcpy()` will read past the end of the `b` buffer. Second, a write
overflow: the function has no knowledge of the size of the `cmd_result`
buffer provided by the caller. In `ttusb_dec_get_stb_state()`, the buffer
is 60 bytes on the stack. In `ttusbdecfe_dvbt_read_status()`, the buffer is
only 4 bytes. A length greater than the buffer size will result in a stack
buffer overflow.

This issue can be observed in the following crash report:

------------[ cut here ]------------
memcpy: detected buffer overflow: 75 byte read of buffer size 60
WARNING: lib/string_helpers.c:1037 at __fortify_report+0x6b/0xa0
lib/string_helpers.c:1036, CPU#1: kworker/1:1/38
...
Call Trace:
 <TASK>
 __fortify_panic+0x9/0x10 lib/string_helpers.c:1043
 fortify_memcpy_chk include/linux/fortify-string.h:549 [inline]
 ttusb_dec_send_command+0x681/0x690
 drivers/media/usb/ttusb-dec/ttusb_dec.c:372
 ttusb_dec_get_stb_state drivers/media/usb/ttusb-dec/ttusb_dec.c:392
 [inline]
 ttusb_dec_init_stb drivers/media/usb/ttusb-dec/ttusb_dec.c:1413 [inline]
 ttusb_dec_probe+0x8e4/0x2160 drivers/media/usb/ttusb-dec/ttusb_dec.c:1671
 usb_probe_interface+0x653/0xc60 drivers/usb/core/driver.c:396
...

To fix this, update the API signature of `ttusb_dec_send_command()` and the
`send_command` callback to take the destination buffer length
(`cmd_result_len`). Add validation in `ttusb_dec_send_command()` to ensure
the length field `b[3]` does not exceed the actual received USB packet
length and the destination buffer size. Update all callers to pass the
correct buffer size.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+ac9880be0b0b1a5f54d6@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=ac9880be0b0b1a5f54d6
Link: https://syzkaller.appspot.com/ai_job?id=fb923fb6-2d12-42a7-a06c-83685d3f6461
To: <linux-media@vger.kernel.org>
To: "Mauro Carvalho Chehab" <mchehab@kernel.org>
To: "Linus Torvalds" <torvalds@ppc970.osdl.org>
Cc: "Kees Cook" <kees@kernel.org>
Cc: <linux-kernel@vger.kernel.org>

---
diff --git a/drivers/media/usb/ttusb-dec/ttusb_dec.c b/drivers/media/usb/ttusb-dec/ttusb_dec.c
index 825a38759..41e9501cd 100644
--- a/drivers/media/usb/ttusb-dec/ttusb_dec.c
+++ b/drivers/media/usb/ttusb-dec/ttusb_dec.c
@@ -314,7 +314,8 @@ static u16 crc16(u16 crc, const u8 *buf, size_t len)
 
 static int ttusb_dec_send_command(struct ttusb_dec *dec, const u8 command,
 				  int param_length, const u8 params[],
-				  int *result_length, u8 cmd_result[])
+				  int *result_length, u8 cmd_result[],
+				  int cmd_result_len)
 {
 	int result, actual_len;
 	u8 *b;
@@ -361,15 +362,26 @@ static int ttusb_dec_send_command(struct ttusb_dec *dec, const u8 command,
 		       __func__, result);
 		goto err_mutex_unlock;
 	} else {
+		int rlen = 0;
+
 		if (debug) {
 			printk(KERN_DEBUG "%s: result: %*ph\n",
 			       __func__, actual_len, b);
 		}
 
+		if (actual_len >= 4) {
+			rlen = b[3];
+			if (rlen > actual_len - 4)
+				rlen = actual_len - 4;
+		}
+
+		if (cmd_result && rlen > cmd_result_len)
+			rlen = cmd_result_len;
+
 		if (result_length)
-			*result_length = b[3];
-		if (cmd_result && b[3] > 0)
-			memcpy(cmd_result, &b[4], b[3]);
+			*result_length = rlen;
+		if (cmd_result && rlen > 0)
+			memcpy(cmd_result, &b[4], rlen);
 	}
 
 err_mutex_unlock:
@@ -389,7 +401,8 @@ static int ttusb_dec_get_stb_state (struct ttusb_dec *dec, unsigned int *mode,
 
 	dprintk("%s\n", __func__);
 
-	result = ttusb_dec_send_command(dec, 0x08, 0, NULL, &c_length, c);
+	result = ttusb_dec_send_command(dec, 0x08, 0, NULL, &c_length, c,
+					sizeof(c));
 	if (result)
 		return result;
 
@@ -448,7 +461,7 @@ static void ttusb_dec_set_pids(struct ttusb_dec *dec)
 	memcpy(&b[2], &audio, 2);
 	memcpy(&b[4], &video, 2);
 
-	ttusb_dec_send_command(dec, 0x50, sizeof(b), b, NULL, NULL);
+	ttusb_dec_send_command(dec, 0x50, sizeof(b), b, NULL, NULL, 0);
 
 	dvb_filter_pes2ts_init(&dec->a_pes2ts, dec->pid[DMX_PES_AUDIO],
 			       ttusb_dec_audio_pes2ts_cb, dec);
@@ -902,7 +915,7 @@ static int ttusb_dec_set_interface(struct ttusb_dec *dec,
 			break;
 		case TTUSB_DEC_INTERFACE_IN:
 			result = ttusb_dec_send_command(dec, 0x80, sizeof(b),
-							b, NULL, NULL);
+							b, NULL, NULL, 0);
 			if (result)
 				return result;
 			result = usb_set_interface(dec->udev, 0, 8);
@@ -1021,7 +1034,7 @@ static int ttusb_dec_start_ts_feed(struct dvb_demux_feed *dvbdmxfeed)
 
 	}
 
-	result = ttusb_dec_send_command(dec, 0x80, sizeof(b0), b0, NULL, NULL);
+	result = ttusb_dec_send_command(dec, 0x80, sizeof(b0), b0, NULL, NULL, 0);
 	if (result)
 		return result;
 
@@ -1056,7 +1069,7 @@ static int ttusb_dec_start_sec_feed(struct dvb_demux_feed *dvbdmxfeed)
 	memcpy(&b0[5], &dvbdmxfeed->filter->filter.filter_value[0], 1);
 
 	result = ttusb_dec_send_command(dec, 0x60, sizeof(b0), b0,
-					&c_length, c);
+					&c_length, c, sizeof(c));
 
 	if (!result) {
 		if (c_length == 2) {
@@ -1114,7 +1127,7 @@ static int ttusb_dec_stop_ts_feed(struct dvb_demux_feed *dvbdmxfeed)
 	struct ttusb_dec *dec = dvbdmxfeed->demux->priv;
 	u8 b0[] = { 0x00 };
 
-	ttusb_dec_send_command(dec, 0x81, sizeof(b0), b0, NULL, NULL);
+	ttusb_dec_send_command(dec, 0x81, sizeof(b0), b0, NULL, NULL, 0);
 
 	dec->pva_stream_count--;
 
@@ -1135,7 +1148,7 @@ static int ttusb_dec_stop_sec_feed(struct dvb_demux_feed *dvbdmxfeed)
 	list_del(&finfo->filter_info_list);
 	spin_unlock_irqrestore(&dec->filter_info_list_lock, flags);
 	kfree(finfo);
-	ttusb_dec_send_command(dec, 0x62, sizeof(b0), b0, NULL, NULL);
+	ttusb_dec_send_command(dec, 0x62, sizeof(b0), b0, NULL, NULL, 0);
 
 	dec->filter_stream_count--;
 
@@ -1238,7 +1251,7 @@ static int ttusb_init_rc( struct ttusb_dec *dec)
 	if (usb_submit_urb(dec->irq_urb, GFP_KERNEL))
 		printk("%s: usb_submit_urb failed\n",__func__);
 	/* enable irq pipe */
-	ttusb_dec_send_command(dec,0xb0,sizeof(b),b,NULL,NULL);
+	ttusb_dec_send_command(dec, 0xb0, sizeof(b), b, NULL, NULL, 0);
 
 	return 0;
 }
@@ -1354,7 +1367,7 @@ static int ttusb_dec_boot_dsp(struct ttusb_dec *dec)
 	firmware_csum_ns = htons(firmware_csum);
 	memcpy(&b0[6], &firmware_csum_ns, 2);
 
-	result = ttusb_dec_send_command(dec, 0x41, sizeof(b0), b0, NULL, NULL);
+	result = ttusb_dec_send_command(dec, 0x41, sizeof(b0), b0, NULL, NULL, 0);
 
 	if (result) {
 		release_firmware(fw_entry);
@@ -1395,7 +1408,7 @@ static int ttusb_dec_boot_dsp(struct ttusb_dec *dec)
 		}
 	}
 
-	result = ttusb_dec_send_command(dec, 0x43, sizeof(b1), b1, NULL, NULL);
+	result = ttusb_dec_send_command(dec, 0x43, sizeof(b1), b1, NULL, NULL, 0);
 
 	release_firmware(fw_entry);
 	kfree(b);
@@ -1621,10 +1634,14 @@ static void ttusb_dec_exit_filters(struct ttusb_dec *dec)
 
 static int fe_send_command(struct dvb_frontend* fe, const u8 command,
 			   int param_length, const u8 params[],
-			   int *result_length, u8 cmd_result[])
+			   int *result_length, u8 cmd_result[],
+			   int cmd_result_len)
 {
 	struct ttusb_dec* dec = fe->dvb->priv;
-	return ttusb_dec_send_command(dec, command, param_length, params, result_length, cmd_result);
+
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
