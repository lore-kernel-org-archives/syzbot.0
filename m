Received: from mail-ot1-f53.google.com (mail-ot1-f53.google.com [209.85.210.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11E402F5498
	for <syzbot@lists.linux.dev>; Wed, 12 Aug 2026 13:33:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786541628; cv=pass; b=XDnHniGzp5ejEMZh06YMP+HcUuJQSoQfAYZ10hTwOAptnjcnXBwa9YZRiu2dWPvN2m6seS0/M0pKSd1pjf77Y3W6+DLnUWwUOjlcIvEU5TO96UixJaEH/B3oXqPCKA0aF3DNSYlhu4ap597p60O1ISGWzyvMljuUCLNJI1f0tTk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786541628; c=relaxed/simple;
	bh=zkI3vqOXKDQkJM5dXUTTpAFDeFX0Yj98DkjINtweYqA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FP/TXSwRNrFIo3N0/XE9RjbpOGQKTKUIf719i3hiBj8RCVFkp5ABAQciK8KJ6aRklPpJpEKPvzOHVCdlHg7ZgUcnc0pIMdYH11Bp6K7gmLxQ11nai2aFGfwizI4aZ57fQ68LTT/RJErkEGeDJ5iHkSdxgB/q3QBAFCtMx/muvoo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PEhjubCG; arc=pass smtp.client-ip=209.85.210.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PEhjubCG"
Received: by mail-ot1-f53.google.com with SMTP id 46e09a7af769-7ec49608332so392781a34.3
        for <syzbot@lists.linux.dev>; Wed, 12 Aug 2026 06:33:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786541625; cv=none;
        d=google.com; s=arc-20260327;
        b=lycQDYO2IV9ZFOGvui3dPTrmxyMMSiCqmN3KhKrT//z1JD8lXOTJn0jZNLTrwurZ/A
         VRGeN4S0niBqqbYll8P6+UkKUChDzT10WRK851BTDyHtzXMNIzxHvj0Dkat1Jv/bCoPk
         dMYd2QjHIsh/eyETBicm6QkRGNYV6+AZZAgWr/OMYmeiRqI5iVUUFKyNtpoVrcdPVtV2
         E/nAyVUcdGfnTWbV9YRUucFB6jj2YxBuycpQlfo6rQFWmB7i4aj8kC62xFNvnbmP82Ih
         zVb5CItaxvawTAeUHlx15hBhm2e7EsL2iRsZd+raE02wUBqMjA1nW7BLsNciWX55GmhP
         gjkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=2j4fjJsR4N0TrrCKJn8BeRXM4E2S8PfLPWJ3uZ5sNw8=;
        fh=XIZD9oazKRRLXAfDc+FAkOArjBbECL4vQEn4FUFSBHc=;
        b=INvt28/R7vx756gDI4a1YwVxaC41szDN9ofR1eJ+GHpFzZmPDouByhER7N4DwDuUTP
         kq2B1FRKMB9C/QxLGUEHyEiQ3qpAwHiFIl8Ti69vrCZK4s5OOzz4ywEO/vHC3ETVIcvp
         AmvucYFmp3s+qPi5VFvJzNV77JHRE8RtQHaMMQ7wkbQ+YdyocZskfPg5e0UesChimuC4
         43Yw84nLyEiJTycSWmPNltkpTBkf/VFTG0gUfRSV3sZliu3GbrBMq4GfT25ueOZK2AsQ
         N+edbGdx3ByBA7u6rHQlYj5wOBpUpySMboWT8NgcRf+XK31dRLGLZaKBQOUFq9q2UhDq
         +o6Q==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786541625; x=1787146425; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=2j4fjJsR4N0TrrCKJn8BeRXM4E2S8PfLPWJ3uZ5sNw8=;
        b=PEhjubCGKu9mfqM9D9RuJtkMVop2Vq0x4WiRX/sgew30o2fbin54OG6IWeUXDajRr3
         Wuvp9rw2wK82hgxIIroDKEW60CXZjwKeADPCFOQJ+k3HmVMmoMwMVvYb4//sEHEEwH1B
         AtCuEBy6pyQxfbdusKuwii9OaQ4q+C7Fmlem4Foi11oPTBoXqjO7fmacz37zTiF3kAC0
         HsbkBji4ZIv2TTCDyjCEbI/5MGP86kgj02mIWuSV76U5h9Ykt+Rc0meRneFxHnQu8ppn
         JPYO0d2FfOI7THeNuVthnLrn3h3sa6vQyxIgy2VHF3QHY2ojMdZijNgNZVUXKWRbBwUT
         Kp2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786541625; x=1787146425;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2j4fjJsR4N0TrrCKJn8BeRXM4E2S8PfLPWJ3uZ5sNw8=;
        b=M1XhKpcIAnW/26Xy0pdJdFP2yku5mSoNsJxHXfbBlEYDbRyWjvgAgF2HKcUPFc3pEA
         ZQvPYONY1WkI1DCs4G1ZgeId2+OJd++B1Hn2UbLp9hPPRUUrxAj2gFFEkBBXJAHQu2A2
         kIpQu6DjEwdOtJR9clgGTshZ5Dv2rwe+h1I7kAjY3Ia1SsW2jQZGg3uJ/7D1LRv0h/fc
         duufU5bU1oOeEhGSonspZV0VyBh1jmnBaunznADhJ2TscJmUVr4No6IFW0qJ7eiw4pkl
         xnxA3xR8FImCOF2Nq2L4ZyE3pOraUPxvO4qUj7p/znQ/0Z3EyunKH4K/jOup61n27pbU
         fyBA==
X-Forwarded-Encrypted: i=1; AHgh+RpWVD2imKAXdifvU7uXj250CkeqoLA0hPuST0aF7vGCz3u36dIChqLXuHZPl3eCd8CbK3BDKlI=@lists.linux.dev
X-Gm-Message-State: AOJu0YxtE7vw3LDK0uhoIptZc/XvHNJiVBWdLdwkjcrMz3BFznSkUHeT
	KCct1L0ZfJYPOC0qR0HBNNIUwm7WcuTu/eF9yTSnXhYIyBizxGSpWFexmIqGCQ5dMqwUgPhbgJA
	wIP8NJfyC5mCdAhoEOEiUHMsLLlUKuZw/p+EQ54jD1xdrsNMSEQCuTCkDpkw=
X-Gm-Gg: AR+sD13EBzoXn8CGCixGVxQNYTeZBldL8l1szX1ESZBUHkyomUjBVkPdhcc3y8JoH7K
	viH9UMDeDrtNnOoynesqqhxg3Oiy0GOKbPrKiKn2yuEVORogPaiagowSSiJyiPAuuEA/qQBC45w
	AwNlXYdULN7AAsvTvAcsfaxniSv8qSMHGXw4R4bjd84GIObx2Orn/BftgGKNXgEOUTNlYJF0Btk
	b5ukn3NV5fruIEN5ZMdJWz1Vm/OE9IG34ruCNRa64FreyH0poE1gXdJ/H3wFo78G9EQoqMiNEbq
	NQu6VhNbTcLlSRRa0rWY1WpgTPU/xHyWekl07gTs+309kb4Xegb8udniH7h1X5fOh86J+bHBGi4
	JqxD+hjvV4hm8JSOBuPsPC8AKla1W9E9svc42xmroKzeRGEGa5X3dnEmRriYoxXh/KI3MFKxdOE
	ou0F6gm2Bvi6pN
X-Received: by 2002:a05:6830:7103:b0:7e7:8dc0:3951 with SMTP id
 46e09a7af769-7f3b77281e8mr5032778a34.8.1786541624310; Wed, 12 Aug 2026
 06:33:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <ceeaac79-e6f5-4a49-b72f-c3fda07d5d7c@mail.kernel.org>
In-Reply-To: <ceeaac79-e6f5-4a49-b72f-c3fda07d5d7c@mail.kernel.org>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Wed, 12 Aug 2026 15:33:32 +0200
X-Gm-Features: AUfX_mxhEUolQaSSgNLVxszVTBeoyUiTv5VKJZyOhma3v2TwaZNvn5V64j9VDUI
Message-ID: <CANp29Y5F5C+Px=JJH_GTgYfC6sH-GLUkgd_TPsFWxAJ=TmEdFQ@mail.gmail.com>
Subject: Re: [PATCH RFC] ALSA: Validate MMIO BARs before mapping
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

This patches the symptom across 12 individual ALSA drivers when the
root cause is in the PCI devres subsystem.

 `pcim_iomap_region()` wraps `pci_iomap()`, so unlike
`pci_ioremap_bar()` it does not validate `IORESOURCE_MEM`. When an I/O
BAR is mapped, subsequent MMIO accessors (`readl`/`readw`) page fault
on x86.

Rather than scattering boilerplate checks across drivers, this should
be solved centrally in the PCI core (e.g. by validating
`IORESOURCE_MEM` in `pcim_iomap_region()` or introducing a managed
`pcim_ioremap_bar()`)

On Wed, Aug 12, 2026 at 3:19=E2=80=AFPM 'syzbot' via
syzkaller-upstream-moderation
<syzkaller-upstream-moderation@googlegroups.com> wrote:
>
> The `snd_hda_intel` driver assumes PCI BAR 0 is a memory-mapped I/O (MMIO=
)
> region, but it fails to verify this assumption before mapping and accessi=
ng
> it. If a device with an I/O Port BAR at BAR 0 is bound to the driver (e.g=
.,
> via the `new_id` sysfs interface), `pcim_iomap_region()` successfully map=
s
> it and returns an I/O port cookie. The driver then attempts to read from
> this address using MMIO accessors like `readw()`, which directly
> dereferences the pointer. On x86, this results in a supervisor read acces=
s
> page fault:
>
> BUG: unable to handle page fault for address: 000000000001c094
> #PF: supervisor read access in kernel mode
> #PF: error_code(0x0000) - not-present page
> RIP: 0010:readw arch/x86/include/asm/io.h:58 [inline]
> RIP: 0010:snd_hdac_reg_readw include/sound/hdaudio.h:458 [inline]
> RIP: 0010:snd_hdac_bus_parse_capabilities+0x47/0x750
> sound/hda/core/controller.c:412
> Call Trace:
>  azx_first_init sound/hda/controllers/intel.c:1936 [inline]
>  azx_probe_continue sound/hda/controllers/intel.c:2365 [inline]
>  azx_probe_work+0x85e/0x2860 sound/hda/controllers/intel.c:1737
>
> To fix this issue, verify that the BAR is an MMIO region using
> `pci_resource_is_mem()` before attempting to map it. If the BAR is not an
> MMIO region, log an error and abort the probe process with `-ENXIO`.
>
> A subsystem-wide audit revealed that several other ALSA PCI drivers use
> `pcim_iomap_region()` and subsequently use MMIO accessors on the returned
> pointer without validating the resource type. To ensure comprehensive
> protection, apply the same validation pattern to all vulnerable ALSA PCI
> drivers, including `snd_ad1889`, `snd_atiixp`, `snd_atiixp_modem`,
> `snd_au88x0`, `snd_aw2`, `snd_bt87x`, `snd_cs4281`, `snd_cs5530`,
> `snd_lola`, `snd_hdspm`, and `loongson_i2s_pci`.
>
> Fixes: 3fcaf24e5dce ("ALSA: hda: Allocate resources with device-managed A=
PIs")
> Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot
> Reported-by: syzbot+10cd2d1efe8eeb604bee@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3D10cd2d1efe8eeb604bee
> Link: https://syzkaller.appspot.com/ai_job?id=3Ddd4258ea-3be3-4977-b597-0=
fc0910b0f51
> To: "Mark Brown" <broonie@kernel.org>
> To: "Clemens Ladisch" <clemens@ladisch.de>
> To: "Liam Girdwood" <lgirdwood@gmail.com>
> To: <linux-parisc@vger.kernel.org>
> To: <linux-sound@vger.kernel.org>
> To: "Jaroslav Kysela" <perex@perex.cz>
> To: "Takashi Iwai" <tiwai@suse.com>
> To: "Binbin Zhou" <zhoubinbin@loongson.cn>
> To: "Takashi Iwai" <tiwai@suse.de>
> Cc: "Chandra Mohan Sundar" <chandramohan.explore@gmail.com>
> Cc: "Kai Vehmanen" <kai.vehmanen@linux.intel.com>
> Cc: "Kees Cook" <kees@kernel.org>
> Cc: <linux-kernel@vger.kernel.org>
> Cc: "Peter Ujfalusi" <peter.ujfalusi@linux.intel.com>
> Cc: "Philipp Stanner" <phasta@kernel.org>
> Cc: "Thomas Gleixner" <tglx@kernel.org>
> Cc: =3D?utf-8?b?VXdlIEtsZWluZS1Lw7ZuaWcgKFRoZSBDYXBhYmxlIEh1Yik=3D?=3D <u=
.kleine-koenig@baylibre.com>
> Cc: "Haotian Zhang" <vulab@iscas.ac.cn>
>
> ---
> diff --git a/sound/hda/controllers/intel.c b/sound/hda/controllers/intel.=
c
> index 28c55c5a2..22c2b5b42 100644
> --- a/sound/hda/controllers/intel.c
> +++ b/sound/hda/controllers/intel.c
> @@ -1926,6 +1926,11 @@ static int azx_first_init(struct azx *chip)
>         if (chip->driver_type =3D=3D AZX_DRIVER_ZHAOXINHDMI)
>                 bus->polling_mode =3D 1;
>
> +       if (!pci_resource_is_mem(pci, 0)) {
> +               dev_err(card->dev, "Invalid PCI BAR 0: not an MMIO region=
\n");
> +               return -ENXIO;
> +       }
> +
>         bus->remap_addr =3D pcim_iomap_region(pci, 0, "ICH HD audio");
>         if (IS_ERR(bus->remap_addr))
>                 return PTR_ERR(bus->remap_addr);
> diff --git a/sound/pci/ad1889.c b/sound/pci/ad1889.c
> index f4ec404c0..4f208f962 100644
> --- a/sound/pci/ad1889.c
> +++ b/sound/pci/ad1889.c
> @@ -803,6 +803,11 @@ snd_ad1889_create(struct snd_card *card, struct pci_=
dev *pci)
>         chip->pci =3D pci;
>         chip->irq =3D -1;
>
> +       if (!pci_resource_is_mem(pci, 0)) {
> +               dev_err(card->dev, "Invalid PCI BAR 0: not an MMIO region=
\n");
> +               return -ENXIO;
> +       }
> +
>         /* (1) PCI resource allocation */
>         chip->iobase =3D pcim_iomap_region(pci, 0, card->driver);
>         if (IS_ERR(chip->iobase))
> diff --git a/sound/pci/atiixp.c b/sound/pci/atiixp.c
> index b738295b4..9b346b9b0 100644
> --- a/sound/pci/atiixp.c
> +++ b/sound/pci/atiixp.c
> @@ -1531,6 +1531,12 @@ static int snd_atiixp_init(struct snd_card *card, =
struct pci_dev *pci)
>         chip->card =3D card;
>         chip->pci =3D pci;
>         chip->irq =3D -1;
> +
> +       if (!pci_resource_is_mem(pci, 0)) {
> +               dev_err(card->dev, "Invalid PCI BAR 0: not an MMIO region=
\n");
> +               return -ENXIO;
> +       }
> +
>         chip->remap_addr =3D pcim_iomap_region(pci, 0, "ATI IXP AC97");
>         if (IS_ERR(chip->remap_addr))
>                 return PTR_ERR(chip->remap_addr);
> diff --git a/sound/pci/atiixp_modem.c b/sound/pci/atiixp_modem.c
> index 8aaeb197c..32a80297a 100644
> --- a/sound/pci/atiixp_modem.c
> +++ b/sound/pci/atiixp_modem.c
> @@ -1163,6 +1163,12 @@ static int snd_atiixp_init(struct snd_card *card, =
struct pci_dev *pci)
>         chip->card =3D card;
>         chip->pci =3D pci;
>         chip->irq =3D -1;
> +
> +       if (!pci_resource_is_mem(pci, 0)) {
> +               dev_err(card->dev, "Invalid PCI BAR 0: not an MMIO region=
\n");
> +               return -ENXIO;
> +       }
> +
>         chip->remap_addr =3D pcim_iomap_region(pci, 0, "ATI IXP MC97");
>         if (IS_ERR(chip->remap_addr))
>                 return PTR_ERR(chip->remap_addr);
> diff --git a/sound/pci/au88x0/au88x0.c b/sound/pci/au88x0/au88x0.c
> index bb0294579..9b2c9361a 100644
> --- a/sound/pci/au88x0/au88x0.c
> +++ b/sound/pci/au88x0/au88x0.c
> @@ -157,6 +157,11 @@ snd_vortex_create(struct snd_card *card, struct pci_=
dev *pci)
>         chip->card =3D card;
>         chip->irq =3D -1;
>
> +       if (!pci_resource_is_mem(pci, 0)) {
> +               dev_err(card->dev, "Invalid PCI BAR 0: not an MMIO region=
\n");
> +               return -ENXIO;
> +       }
> +
>         // (1) PCI resource allocation
>         // Get MMIO area
>         //
> diff --git a/sound/pci/aw2/aw2-alsa.c b/sound/pci/aw2/aw2-alsa.c
> index 60a87322e..c9c7129e4 100644
> --- a/sound/pci/aw2/aw2-alsa.c
> +++ b/sound/pci/aw2/aw2-alsa.c
> @@ -223,6 +223,11 @@ static int snd_aw2_create(struct snd_card *card,
>         chip->pci =3D pci;
>         chip->irq =3D -1;
>
> +       if (!pci_resource_is_mem(pci, 0)) {
> +               dev_err(card->dev, "Invalid PCI BAR 0: not an MMIO region=
\n");
> +               return -ENXIO;
> +       }
> +
>         /* (1) PCI resource allocation */
>         chip->iobase_virt =3D pcim_iomap_region(pci, 0, "Audiowerk2");
>         if (IS_ERR(chip->iobase_virt))
> diff --git a/sound/pci/bt87x.c b/sound/pci/bt87x.c
> index 383def1f2..e71fe10ce 100644
> --- a/sound/pci/bt87x.c
> +++ b/sound/pci/bt87x.c
> @@ -690,6 +690,11 @@ static int snd_bt87x_create(struct snd_card *card,
>         chip->irq =3D -1;
>         spin_lock_init(&chip->reg_lock);
>
> +       if (!pci_resource_is_mem(pci, 0)) {
> +               dev_err(card->dev, "Invalid PCI BAR 0: not an MMIO region=
\n");
> +               return -ENXIO;
> +       }
> +
>         chip->mmio =3D pcim_iomap_region(pci, 0, "Bt87x audio");
>         if (IS_ERR(chip->mmio))
>                 return PTR_ERR(chip->mmio);
> diff --git a/sound/pci/cs4281.c b/sound/pci/cs4281.c
> index f51f4bb63..792a63d36 100644
> --- a/sound/pci/cs4281.c
> +++ b/sound/pci/cs4281.c
> @@ -1298,6 +1298,11 @@ static int snd_cs4281_create(struct snd_card *card=
,
>         }
>         chip->dual_codec =3D dual_codec;
>
> +       if (!pci_resource_is_mem(pci, 0) || !pci_resource_is_mem(pci, 1))=
 {
> +               dev_err(card->dev, "Invalid PCI BARs: not MMIO regions\n"=
);
> +               return -ENXIO;
> +       }
> +
>         chip->ba0 =3D pcim_iomap_region(pci, 0, "CS4281");
>         if (IS_ERR(chip->ba0))
>                 return PTR_ERR(chip->ba0);
> diff --git a/sound/pci/cs5530.c b/sound/pci/cs5530.c
> index 292b65aa7..dc5e30947 100644
> --- a/sound/pci/cs5530.c
> +++ b/sound/pci/cs5530.c
> @@ -91,6 +91,11 @@ static int snd_cs5530_create(struct snd_card *card,
>         chip->card =3D card;
>         chip->pci =3D pci;
>
> +       if (!pci_resource_is_mem(pci, 0)) {
> +               dev_err(card->dev, "Invalid PCI BAR 0: not an MMIO region=
\n");
> +               return -ENXIO;
> +       }
> +
>         mem =3D pcim_iomap_region(pci, 0, "CS5530");
>         if (IS_ERR(mem))
>                 return PTR_ERR(mem);
> diff --git a/sound/pci/lola/lola.c b/sound/pci/lola/lola.c
> index 34a3ba17d..fdef79879 100644
> --- a/sound/pci/lola/lola.c
> +++ b/sound/pci/lola/lola.c
> @@ -579,6 +579,11 @@ static int lola_create(struct snd_card *card, struct=
 pci_dev *pci, int dev)
>                 chip->sample_rate_min =3D 16000;
>         }
>
> +       if (!pci_resource_is_mem(pci, 0) || !pci_resource_is_mem(pci, 2))=
 {
> +               dev_err(card->dev, "Invalid PCI BARs: not MMIO regions\n"=
);
> +               return -ENXIO;
> +       }
> +
>         iomem =3D pcim_iomap_region(pci, 0, DRVNAME);
>         if (IS_ERR(iomem))
>                 return PTR_ERR(iomem);
> diff --git a/sound/pci/rme9652/hdspm.c b/sound/pci/rme9652/hdspm.c
> index d8bbedbc8..344008ff7 100644
> --- a/sound/pci/rme9652/hdspm.c
> +++ b/sound/pci/rme9652/hdspm.c
> @@ -6456,6 +6456,11 @@ static int snd_hdspm_create(struct snd_card *card,
>         int err;
>         unsigned long io_extent;
>
> +       if (!pci_resource_is_mem(pci, 0)) {
> +               dev_err(card->dev, "Invalid PCI BAR 0: not an MMIO region=
\n");
> +               return -ENXIO;
> +       }
> +
>         hdspm->irq =3D -1;
>         hdspm->card =3D card;
>
> diff --git a/sound/soc/loongson/loongson_i2s_pci.c b/sound/soc/loongson/l=
oongson_i2s_pci.c
> index f5b560465..5e634d467 100644
> --- a/sound/soc/loongson/loongson_i2s_pci.c
> +++ b/sound/soc/loongson/loongson_i2s_pci.c
> @@ -41,6 +41,11 @@ static int loongson_i2s_pci_probe(struct pci_dev *pdev=
,
>         i2s->dev =3D dev;
>         pci_set_drvdata(pdev, i2s);
>
> +       if (!pci_resource_is_mem(pdev, 0)) {
> +               dev_err(dev, "Invalid PCI BAR 0: not an MMIO region\n");
> +               return -ENXIO;
> +       }
> +
>         i2s->reg_base =3D pcim_iomap_region(pdev, 0, DRIVER_NAME);
>         if (IS_ERR(i2s->reg_base)) {
>                 dev_err(dev, "iomap_region failed\n");
>
>
> base-commit: db2ddb87143519e20a95aa36c60b36107b736a58
> --
> This is an AI-generated patch subject to moderation.
> Reply with '#syz upstream' to Sign-off the patch as a human author
> and send it to the upstream kernel mailing lists.
> Reply with '#syz reject' to reject it ('#syz unreject' to undo).
>
> See https://goo.gle/syzbot-ai-patches for information about AI-generated =
patches.
> You can comment on the patch as usual, syzbot will try to address
> the comments and send a new version of the patch if necessary.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
>
> --
> You received this message because you are subscribed to the Google Groups=
 "syzkaller-upstream-moderation" group.
> To unsubscribe from this group and stop receiving emails from it, send an=
 email to syzkaller-upstream-moderation+unsubscribe@googlegroups.com.
> To view this discussion visit https://groups.google.com/d/msgid/syzkaller=
-upstream-moderation/ceeaac79-e6f5-4a49-b72f-c3fda07d5d7c%40mail.kernel.org=
.
