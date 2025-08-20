Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8DEC1C3F0C
	for <syzbot@lists.linux.dev>; Wed, 20 Aug 2025 10:46:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755686766; cv=none; b=YDtZANv7gpcH5OXYJZpKKCYKIapAePF0fq0Huqv7nyk9Bnb/QfRQNttYfzYOAzlBO66v12Wpbr2MLHtShL7iPmDmibiir7LPkGzpeZ1uhj2Ul1Yhs+ZVNaRlYsesK9m41BBxHdSci2zzYUCE6qMev2ZXzDprgXzwp6Z5iKeeQjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755686766; c=relaxed/simple;
	bh=3Me8tP3A/Dq4n2o7fv0IO64KsodsWLaH93wYg8ejh9A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FS+K6svoTVWIGK05E4LoEdJct+S/30h4uhiaGneWhorEB8ga2YlGQyzarL4iTSb/mdeWtfR0WhP4TjqEtec6h94QSUolfwY8cuaohfmdQlk1DVwh5raOEEGgtOPq5fBwH4kCRMBDBESFl/pWIDzGycKjWCOjyZ4WE+UzpEAaS5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=WaZcr62b; arc=none smtp.client-ip=209.85.215.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WaZcr62b"
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-b4755f37c3eso1427698a12.3
        for <syzbot@lists.linux.dev>; Wed, 20 Aug 2025 03:46:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755686764; x=1756291564; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3Me8tP3A/Dq4n2o7fv0IO64KsodsWLaH93wYg8ejh9A=;
        b=WaZcr62b43vTpcHCJsXuNTlaVFMA30JkRArAUbNloPT23y1E/SlAFv/OD4YvniG3dl
         cvZjw3sfb5/7d6Yq9rpIkd7cP31sTvuGKVr5Sulypv2YZGcdb7n4f20FzBGDLa7LNR8W
         h3cQRfpmmwjJufRRxS1bs36Ix7uXVYcbo/ITei7xmiGRLletjn1Nq4YtJOP5AVMFWm89
         PwqjHgFJ0dpIrKus7xvGGVDTNDC41MHe831ySeisVgWH8qWnUx7Yvd185zsl3hBu2Wwn
         RElk2LdUJShrN6EZFSTTQ9fanMv8LIG6TggEqkikljThzbLJGtW+d+LLGmuKXarwKHHc
         SzEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755686764; x=1756291564;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3Me8tP3A/Dq4n2o7fv0IO64KsodsWLaH93wYg8ejh9A=;
        b=HKKLvI9rKG/0s0HARHSt9nxHErHqwgcNfwNFUFyHT5S66htDSQlvQa1maEJCA0agDH
         Xt4WHFSg9LVV+Q0ia89eQH187hN39bdC24DYoqisAXUQWXavPQM9phv3PT2U5LjG/JQs
         EmrpXDtUq/II7x2BHtHCx01Dd0E2eu5gw/EiCm0DYskLmrEgzAWX0lz7kuQ/UX+jF1qO
         TDTN7+gthOHoYEEaISzo3C8Kb5BKUlxKyzWMEk2/N5daYCkAeDlk+g+BxkqluZkKqoge
         SQfQa/tgStpbluQnl1ztM4RuVzIcFvZlJv3wpNB6dbJaS+oGYitwBdb8S5Rfc67ngyLA
         /ySw==
X-Forwarded-Encrypted: i=1; AJvYcCUYUq9jenYndlWqx1Z4YMlj6xu93DqL5cPNX5sDsKTjKOCut7OGcJploCnNSuLZlH3fu0Sd75c=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz+eODAWa5k/BE5ml3ZJ1lOzkSP1hsuhA0w6D0ovY2wsp4joQzM
	F6GIKPLBQjkasRf8P/7zQv366T9cBAi5Bd4GIGUxAMH4H9zeS79QM6gXKGc7HT7nRQ6a9W4VDsb
	AkrPrNmh2M/QdfOiJWKLRNdP+Es9c1vSFNeZUm0HB
X-Gm-Gg: ASbGncv/22958J9WtB/VZbjOyAVO7HJ9ftp0ksv+hTPhIj23JqFuzWt+lhF19hHjNaz
	6k9t/JOU9W5I8lYcBF/iKPFtIueE13JJTs2KhHg+B1bL3sNHssLfGjzhfaSDP7odS0Vt7UjrYeq
	AGhAdAnpHJ2keGOWC/fHu39/krnMN9aFNVkS5f6vdHKoT1yERGLf2vhPdqLmVHAF8CsLJd703w5
	La0ns10q3S9MGv+xUVnzEP3URZVzkKRjxfWM7MgJhc0KdwcLySWNXo=
X-Google-Smtp-Source: AGHT+IEKtl2lrK5/2y4ZHW8BdiMqTimWqMJrLgdgwZdhWnnQOIhxftCfwBi0pC/VAlu+Wj78IDSFaxfyMArkbO0q10c=
X-Received: by 2002:a17:902:cecc:b0:23f:e2e0:f89b with SMTP id
 d9443c01a7336-245ef0bf919mr29929205ad.3.1755686763672; Wed, 20 Aug 2025
 03:46:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250818154032.3173645-1-sdf@fomichev.me> <68a49b30.050a0220.e29e5.00c8.GAE@google.com>
 <20250819175842.7edaf8a5@kernel.org>
In-Reply-To: <20250819175842.7edaf8a5@kernel.org>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Wed, 20 Aug 2025 12:45:52 +0200
X-Gm-Features: Ac12FXzOW9XPurRHcsWYD8YIbcfeKfyX5uwi588A3HEp9L6p1uEzyk061ngsuoE
Message-ID: <CANp29Y4g6kzpsjis4=rUjhfg=BPMiR9Jk68z=NT0MeDyJS7CaQ@mail.gmail.com>
Subject: Re: [syzbot ci] Re: net: Convert to skb_dstref_steal and skb_dstref_restore
To: Jakub Kicinski <kuba@kernel.org>
Cc: syzbot ci <syzbot+ci77a5caa9fce14315@syzkaller.appspotmail.com>, 
	abhishektamboli9@gmail.com, andrew@lunn.ch, ayush.sawal@chelsio.com, 
	coreteam@netfilter.org, davem@davemloft.net, dsahern@kernel.org, 
	edumazet@google.com, fw@strlen.de, gregkh@linuxfoundation.org, 
	herbert@gondor.apana.org.au, horms@kernel.org, kadlec@netfilter.org, 
	linux-kernel@vger.kernel.org, linux-staging@lists.linux.dev, mhal@rbox.co, 
	netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, pabeni@redhat.com, 
	pablo@netfilter.org, sdf@fomichev.me, steffen.klassert@secunet.com, 
	syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Jakub,

Thanks for the heads-up!
I didn't even think that this tag could pose problems for other
automatic tools :)

On Wed, Aug 20, 2025 at 2:58=E2=80=AFAM Jakub Kicinski <kuba@kernel.org> wr=
ote:
>
> On Tue, 19 Aug 2025 08:41:36 -0700 syzbot ci wrote:
> > syzbot ci has tested the following series
> >
> > [v2] net: Convert to skb_dstref_steal and skb_dstref_restore
> > https://lore.kernel.org/all/20250818154032.3173645-1-sdf@fomichev.me
> > * [PATCH net-next v2 1/7] net: Add skb_dstref_steal and skb_dstref_rest=
ore
> > * [PATCH net-next v2 2/7] xfrm: Switch to skb_dstref_steal to clear dst=
_entry
> > * [PATCH net-next v2 3/7] netfilter: Switch to skb_dstref_steal to clea=
r dst_entry
> > * [PATCH net-next v2 4/7] net: Switch to skb_dstref_steal/skb_dstref_re=
store for ip_route_input callers
> > * [PATCH net-next v2 5/7] staging: octeon: Convert to skb_dst_drop
> > * [PATCH net-next v2 6/7] chtls: Convert to skb_dst_reset
> > * [PATCH net-next v2 7/7] net: Add skb_dst_check_unset
>
> > ***
> >
> > If these findings have caused you to resend the series or submit a
> > separate fix, please add the following tag to your commit message:
> > Tested-by: syzbot@syzkaller.appspotmail.com
>
> Hi Aleksandr!
>
> Could we do something about this Tested-by: tag?
> Since the syzbot CI reports are sent in reply to a series patchwork and
> other tooling will think that syzbot is sending it's Tested-by tag for
> this series.
>
> In some cases we know that the issues found are unrelated, or rather
> expect them to be fixed separately.

FWIW if you notice the reported issues that are completely unrelated,
please let me know.

>
> Could we perhaps indent the tag with a couple of spaces? Not 100% sure
> but I _think_ most tools will match the tags only from start of line.

Sure, that sounds like a very simple solution.
I've adjusted the email template - now there are several leading
whitespaces on the tag line. I hope it will help (otherwise we'll see
what else can be done).

--=20
Aleksandr
