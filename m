Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.210.42
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793889543;
	b=NBAGwPGeuJ3cjDT6BOxxSgFfQdpIo0ypWOdAA9PLyZE0q9xcpwfgXxy1tv+FZffivG9q
	 Mhx/O8r2zL3VjJOmSwvfAV1jLEqPgEXdUBoSwWczo22SA9RCJ+PnXSZtVFAIqKmz6FiAM
	 K2fiGilXKnNBOO2ZgXVRG48qxZQKaDUlxtA31zY+euuyXh3JYFZ85b8eYn0IdI+EVlG40
	 k4f5MyDac+SqTObgB/0FTcvskA0gxvgnN+LnWl6oNj9WqxA/ehC40TRWS8kbblRRCvAOl
	 pmjR0H2PBiju7Dlg7WEECdka0A73M6QEhhq25TKigSY8gNYt1/+lJUITyZN1qT1y6zg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793889543;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=t3C2r/vKnPtFFRgOtRFNlBz4cjzvnmKkelZA9UbvJbk=;
	b=i3uNsyxcIaHlCRI+SI/SSX8m40hC22owHdnvkfKoHPIADQs0SVVKPob/A3m3zQ3wnSPz
	 Yoa6PQHuqSAb+b414tvEVN6WRdCu+zGpxeKx6iBVOvzQKPb70oKjkcVoIJsXma6PizkqN
	 29Cm/XR8WzJo+fXZS9KRLoV9IjZJnRhGMih4t9CLyNhgAnEnLDDqZfcp4kX+WTY6WcRPa
	 ypx78AZzdHiELIl7xoXn2TULal17mkdWdbnYGx04tDBI8sqTYDKKreiXLayZU6Mtjrfdg
	 PiMkC0s3kpoPjEx1sgWs7WdYmQnomsZ/SAYWwiF8Mz59rfnpQPglzrnOYOFYX60q+iw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=I+AhPzmv;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.210.42
Received: from mail-ot1-f42.google.com (mail-ot1-f42.google.com [209.85.210.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F66A606A32F
	for <syzbot@lists.linux.dev>; Thu,  5 Nov 2026 14:39:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7F66A606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=I+AhPzmv
Received: by mail-ot1-f42.google.com with SMTP id 46e09a7af769-845788309b4so758100a34.1
        for <syzbot@lists.linux.dev>; Thu, 05 Nov 2026 06:39:02 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793889541; cv=none;
        d=google.com; s=arc-20260327;
        b=pE3+UMp33J7q4DjNwf+/CFDy90juhhaa5pTJ6nXsjWPss44Qo5st3zkgv7N/uIuwHw
         VeFuODjfVXBZBbYe11E5jdr/7rvDXdK/23x+ePAxx3h0EHYFj47eMuEhRngmtQEDHARa
         ak6SKVZRtaJ9l0CTjGUBpHBhIa8DQbR3SAHwP1C6UTzYAyi466qRT2DyTPUXElTQ2cb0
         73JhZVHg5Np2wiDeFYRN8PBOC6xLUvC8Erf/isy437a0WFTpmon6IcO57h+m5eWydW7j
         6pNpUPtsR86o+Vm4exRMl/qDDoFvra+U2EHel/qoAitaB+yv9xFkniNZlhvCs7kf4buf
         aQVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=t3C2r/vKnPtFFRgOtRFNlBz4cjzvnmKkelZA9UbvJbk=;
        fh=R1h6qK48ydqclKMf+andg5LMDdp4A6F8lsDItfWdyvI=;
        b=SCGDQDwzWLpCffFeyx31c8TaMneeckVYVZxFi4PA3DQUBk+ixwYrm8t4ELmEQX2V8c
         WeDd78IAcR0baLJxz9ayLMa0FlNGyKAjZzlmPubRuDaUT9NVjH2SENXrMZSY8VwDwxUA
         DS8cfDBpjVOmmkV1RqAkOeTHe3iBrZ+rKmnWAMP8JStM+4K8cB3+F8HNhoq1XGG9Y+Cm
         n/f8kiqruExBU4MaiJL2pXAW8pmoQfyu7dPE+iy94n8/zmbYIfK3Xcpm+6EX2lHvb3gT
         d8MbVuLJtCd96HSvw3S+6uwa5T9oikzLhZ7F4OWy5DS9aV3jhyu9eZvHVEV+OhlXzb9z
         lF0w==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793889541; x=1794494341; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=t3C2r/vKnPtFFRgOtRFNlBz4cjzvnmKkelZA9UbvJbk=;
        b=I+AhPzmveZRqyOzJvGONVhOV52gjUq3bO77Pj1R/9b4cbUBZINbwyF0mtLuD2g147D
         ZT4CsCx2B0kQFdC9tb4oq+SnCiK0EMJyt6i0Yp+afbJi406yFmwrrnlRcLG1VUwjli2M
         tNuuH0LaLI3cKthla0tEE8mLnDvZp22j6AaKhLWuoUI7mzd6qMeDZ6tLUg0kjaTkneP8
         WDqynCXI0I60hqBer9KfihhjaGqk/witEx+3IRlLNG/e6S2ehqHPY8/6RNufC1bCgbBf
         bZYZduNI2Q8zbs7ToqEM3994+b17LBy6rSIgs6cJnZZ6fSGv3ALIFUoln87LO9ourVP1
         rp7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793889541; x=1794494341;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=t3C2r/vKnPtFFRgOtRFNlBz4cjzvnmKkelZA9UbvJbk=;
        b=V8TUdV+roPaU4E27LysghxGavvmrQODptZWB1WdbDDU23yYCRJbYbjlRclJ4ikxDIA
         Nj852SJlMEn8G6TgvMhXR2P0ZEqh5dZs0fj5WyFFLOjUNeNeFDfCY3olplvQ5HTc4rcE
         Ft3n9ZVSLKNH7ZcUxSnoL1fcs89o+XuF7xmGaW+qvEe89kNHl+/koAKaLs4MWVUrFSox
         jtwCb2iEYzXbQsbnY+c0KsfwgihPOrgzxivlEj7rR/mTyJZMT8OvL+QB4O9Cbr2xo6Nl
         lXRtTw79oSk3c0X9+8pUofvM5wQoqLUvl0tXxVsKYIObyEro/PiSWtcLuS8gTshRAbap
         kgog==
X-Forwarded-Encrypted: i=1; AKwUvBzm+f+/WGrK1g+cJequms2b1VyOo6IG9RNioZI3tNxVCBBqwMaJ1kxQAlLODhdst/TsErBERlY=@lists.linux.dev
X-Gm-Message-State: APuU4Z/SWfUYyGvLerdg5dNVzRnPUEOnw0weT2anwt1d9zrczzAFeOFI
	ary13l4SkZeHdbrm2gwWJQuSHyjLWpagMo4Qz5RtqxfRi49jwoUoQvVHyNVy8cTD2MpUIHnYbrl
	9D0clIm68gRkbYwBrY3jv0oxVmVhoSnXMYhoeC9U6IwyrfRORN+Ae0ieU
X-Gm-Gg: AYBFou13TjAasR6rQdz8kcfpSllWtiIWJI3hc0kcY0Va4XnN5qb7aUVOZmOol6C3NGF
	9wSjKNM5bDuL2s0fe8rZjPvANT+0fWHDc2kiZRLdhy965khBdMcgvrzW9RoE3o6m+F6nv8vo0Hm
	5lQoN+5DB+GUYxRFwfUI0H4WUnTetxqqgej7vq7YtJaNId6zWh642ClJ4tLIUOXNXHsWAYnqR7C
	CpwyrVH9OW9FUi8bfYkQRTDxMpQ/Tjb/FwND6YaYR46soknL2D/PuznHAGdgbpjTJtBxhZ9Wrv0
	SJtHm5fwAKW7Hy9S1dzuFeTami2wET9ESysjRgveCrQs7zvCTYzXYxfi4n7HkYkE8u1k4BwgQg0
	BUHPEgKtjYDc/xTpK/Bjkr7V6orPGb0FcNYd/THCqO9q/POG+P9fZ33xpI8jYu5StGRFTFce6Bk
	Ex5tIrN4rsAjJs3dH7GIB6pu1B3VlIsCt0qe/3FbZ06LQOmudyo6eJXL7HxWN39Bg4f5C3cfdyj
	9NBUouA
X-Received: by 2002:a05:6808:50a1:b0:4f5:6c14:7978 with SMTP id
 5614622812f47-5640dd1b1c3mr15254108b6e.24.1793889539890; Thu, 05 Nov 2026
 06:38:59 -0800 (PST)
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Post: <mailto:syzbot@lists.linux.dev>
List-Help: <mailto:syzbot+help@lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
List-Owner: <mailto:syzbot+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <6aec8d04.b98d4f1a.72a9.0025.GAE@google.com>
In-Reply-To: <6aec8d04.b98d4f1a.72a9.0025.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Thu, 5 Nov 2026 15:38:48 +0100
X-Gm-Features: AclHuK8p8JL0-WAylUrAuPXsRls2N5Xccv1yNlF8BPNYS-D9XHxQ8Fqg6kzy34M
Message-ID: <CANp29Y4JfoA=xQRQc8Pe_UuZ4mpz+f636wUa+SAVgNQjdp3JCg@mail.gmail.com>
Subject: Re: [moderation/CI] Re: 6.18.61-rc1 review
To: syzbot ci <syzbot+ci9c0d851683911c8c@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Thu, Nov 5, 2026 at 3:04=E2=80=AFPM syzbot ci
<syzbot+ci9c0d851683911c8c@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v1] 6.18.61-rc1 review
> https://lore.kernel.org/all/20261104211043.516122098@linuxfoundation.org
> * [PATCH 6.18 0001/1005] net: skbuff: propagate shared-frag marker in skb=
_zerocopy()
> * [PATCH 6.18 0002/1005] ksmbd: wait for negotiation before receiving ano=
ther PDU
> * [PATCH 6.18 0003/1005] mm: vmscan: fix dirty folios throttling on cgrou=
p v1 for MGLRU
> * [PATCH 6.18 0004/1005] iio: hid-sensor: als: scale each channel individ=
ually
> * [PATCH 6.18 0005/1005] platform: cznic: turris-omnia-mcu: Add missing M=
ODULE_DEVICE_TABLE()
> * [PATCH 6.18 0006/1005] kbuild: link-vmlinux.sh: improve detection of th=
ird pass requirement
> * [PATCH 6.18 0007/1005] hwmon: (lm90) Rely on subsystem locking
> * [PATCH 6.18 0008/1005] exec: cancel io_uring requests before de_thread(=
)
> * [PATCH 6.18 0009/1005] fork: move the coredump and exec checks into cre=
ate_io_thread()
> * [PATCH 6.18 0010/1005] fork: dont create io threads once PF_POSTCOREDUM=
P is set
> * [PATCH 6.18 0011/1005] coredump: prevent TIF_NOTIFY_SIGNAL from interru=
pting coredumps
> * [PATCH 6.18 0012/1005] net: bonding: use workqueue to make sure peer no=
tify updated in lacp mode
> * [PATCH 6.18 0013/1005] net: bonding: move bond_should_notify_peers, e.g=
. into rtnl lock block
> * [PATCH 6.18 0014/1005] ALSA: line6: Clear prev_fbuf on capture buffer r=
elease
> * [PATCH 6.18 0015/1005] drm/rockchip: dw_hdmi: Use resume_early pm ops f=
or system suspend
> * [PATCH 6.18 0016/1005] drm/virtio: abort virtqueue wait on device remov=
al to avoid hung task
> * [PATCH 6.18 0017/1005] drm/panel-edp: Add BOE NV116WH2-M30, BOE NT116WH=
M-N21, BOE NV116FH1-M31, BOE NV116FH1-M30
> * [PATCH 6.18 0018/1005] drm/amdgpu/mes_v12_0: use mes schedule pipe for =
legacy queues on unified MES
> * [PATCH 6.18 0019/1005] drm/amd/pm: Validate OD DPM triples before mutat=
ing tables
> * [PATCH 6.18 0020/1005] drm/amdgpu: Gate debugfs MMIO access on kernel l=
ockdown
> * [PATCH 6.18 0021/1005] drm/amd/display: fix max dispclk_khz/dppclk_khz =
double 1000
> * [PATCH 6.18 0022/1005] drm/radeon: avoid double free in r600 DPM cleanu=
p
> * [PATCH 6.18 0023/1005] drm/amdgpu: add buf length check
> * [PATCH 6.18 0024/1005] drm/amdgpu: add bounds check to prevent array ov=
erflow
> * [PATCH 6.18 0025/1005] gpio: pca9570: Use I2C match data
> * [PATCH 6.18 0026/1005] selftests/filesystems/overlayfs: fix set_layers_=
via_fds link error
> * [PATCH 6.18 0027/1005] HID: wacom: avoid copying Bluetooth input report=
s
> * [PATCH 6.18 0028/1005] w1: ds2482: add OF device match table
> * [PATCH 6.18 0029/1005] ALSA: hda: Add support for Hygon family 18h mode=
l 5h HD-Audio
> * [PATCH 6.18 0030/1005] ALSA: hda: Force resume if acomp notified during=
 system suspend
> * [PATCH 6.18 0031/1005] media: cec: stm32: return an error when log-addr=
ess wait times out
> * [PATCH 6.18 0032/1005] ALSA: usb-audio: Release components on probe err=
ors
> * [PATCH 6.18 0033/1005] irqdomain: Plug leak in irq_domain_alloc_irqs_lo=
cked() error path
> * [PATCH 6.18 0034/1005] ASoC: sma1303: remove fault-check sysfs group on=
 remove
> * [PATCH 6.18 0035/1005] spi: qpic-snand: free OOB buffer with ECC contex=
t
> * [PATCH 6.18 0036/1005] clk: zynq: handle kasprintf() failure in periph_=
clk registration
> * [PATCH 6.18 0037/1005] ASoC: tlv320aic26: remove keyclick sysfs file
> * [PATCH 6.18 0038/1005] ASoC: hdac_hdmi: Fix resource cleanup on probe f=
ailure
> * [PATCH 6.18 0039/1005] regmap: maple: Workaround for another false-posi=
tive compiler warning
> * [PATCH 6.18 0040/1005] selftests/cgroup: Adjust cpu test duration based=
 on HZ
> * [PATCH 6.18 0041/1005] ARM: OMAP2+: Add CFI type for omap4_finish_suspe=
nd
> * [PATCH 6.18 0042/1005] iio: accel: fxls8962af: clamp the device-reporte=
d FIFO sample count
> * [PATCH 6.18 0043/1005] perf/x86/intel: Fallback to sw branch type decod=
ing if no hw decoding
> * [PATCH 6.18 0044/1005] drm/sysfb: simpledrm: Validate mmap size against=
 framebuffer size
> * [PATCH 6.18 0045/1005] perf/core: Fix kernel register info leak via har=
dware skid
> * [PATCH 6.18 0046/1005] fat: reject name longer than NAME_MAX in msdos_f=
ormat_name()
> * [PATCH 6.18 0047/1005] perf/x86/intel/uncore: Fix PCI PMU cleanup on se=
tup failure
> * [PATCH 6.18 0048/1005] fs/namespace: notify pollers of legacy propagati=
on changes
> * [PATCH 6.18 0049/1005] spi: bcm-qspi: return error from failed controll=
er suspend
> * [PATCH 6.18 0050/1005] spi: bcm63xx: return error from failed controlle=
r suspend
> * [PATCH 6.18 0051/1005] spi: bcm63xx-hsspi: return error from failed con=
troller suspend
> * [PATCH 6.18 0052/1005] drm/panel-edp: Add BOE NE160QDM-NY1 panel
> * [PATCH 6.18 0053/1005] spi: fsl-dspi: clean up after failed suspend and=
 resume
> * [PATCH 6.18 0054/1005] spi: nxp-fspi: disable runtime PM on probe failu=
res
> * [PATCH 6.18 0055/1005] spi: bcmbca-hsspi: return error from failed cont=
roller suspend
> * [PATCH 6.18 0056/1005] memory: stm32_omm: initialize ret in stm32_omm_s=
et_amcr
> * [PATCH 6.18 0057/1005] wifi: ath12k: avoid setting 320MHz support on no=
n 6GHz band
> * [PATCH 6.18 0058/1005] i2c: amd-asf: Validate firmware-reported length
> * [PATCH 6.18 0059/1005] netpoll: do not warn when the best-effort pool r=
efill fails
> * [PATCH 6.18 0060/1005] i2c: acpi: Force ELAN1300 touchpads to 100 kHz
> * [PATCH 6.18 0061/1005] drm/amdgpu: Add checks to vbios fetch through AT=
RM
> * [PATCH 6.18 0062/1005] drm/amdgpu: Validate ATPX buffer length before u=
se
> * [PATCH 6.18 0063/1005] drm/amdgpu: Fix kobject cleanup in xcp sysfs
> * [PATCH 6.18 0064/1005] drm/amdgpu: Validate ATIF buffer length before u=
se
> * [PATCH 6.18 0065/1005] drm/amdgpu: validate XCP topology counts before =
division
> * [PATCH 6.18 0066/1005] drm/amd/pm: validate vega10 profile mode inputs
> * [PATCH 6.18 0067/1005] drm/amdgpu: Support some Barco AMD based graphic=
s adapters
> * [PATCH 6.18 0068/1005] drm/amdgpu: Guard reads in pcie state readout
> * [PATCH 6.18 0069/1005] drm/amdgpu: add check for xcp id
> * [PATCH 6.18 0070/1005] drm/amd/pm: Validate Vega hwmgr PowerPlay table =
bounds
> * [PATCH 6.18 0071/1005] drm/amd/pm: Validate pp_table header before read=
ing size
> * [PATCH 6.18 0072/1005] drm/amd/pm: Use uploaded size for legacy custom =
PPTable
> * [PATCH 6.18 0073/1005] drm/amdkfd: use node XCC count for v9 CRIU contr=
ol stack restore
> * [PATCH 6.18 0074/1005] drm/amd/pm: Validate Tonga PowerPlay state array=
 bounds
> * [PATCH 6.18 0075/1005] drm/amd/pm: Guard VBIOS AC timing table walk
> * [PATCH 6.18 0076/1005] drm/amd/pm: Validate Tonga PPTable subtable boun=
ds
> * [PATCH 6.18 0077/1005] drm/amd/pm: Validate Vega10 PPTable subtable bou=
nds
> * [PATCH 6.18 0078/1005] drm/amd/pm: Validate legacy hwmgr PP table offse=
ts
> * [PATCH 6.18 0079/1005] drm/amdkfd: add sanity check in svm_range_is_val=
id
> * [PATCH 6.18 0080/1005] drm/panel-edp: Support MB116AS013 edp panel
> * [PATCH 6.18 0081/1005] libbpf: Skip bpf_object__probe_loading() when BP=
F token is in use
> * [PATCH 6.18 0082/1005] net: usb: rtl8150: handle link status read failu=
res
> * [PATCH 6.18 0083/1005] netfilter: ebtables: bound num_counters like nen=
tries in do_replace()
> * [PATCH 6.18 0084/1005] soundwire: dmi-quirks: Disable ghost Realtek on =
Asus Expertbook
> * [PATCH 6.18 0085/1005] dmaengine: pl330: remove debugfs file on teardow=
n
> * [PATCH 6.18 0086/1005] net: mvneta_bm: add suspend/resume support to pr=
event crash after resume
> * [PATCH 6.18 0087/1005] dmaengine: dw-axi-dmac: fix __le32 on set of CH_=
CTL_H_LLI_VALID
> * [PATCH 6.18 0088/1005] wifi: rtlwifi: rtl8723be: Remove unnecessary irq=
 save/restore in hw_init()
> * [PATCH 6.18 0089/1005] wifi: rtw89: wow: only WiFi 6 chips initialize R=
F registers in WoWLAN mode
> * [PATCH 6.18 0090/1005] wifi: rtlwifi: fix disabling of ASPM for RTL8723=
BE with AER flooding
> * [PATCH 6.18 0091/1005] wifi: rtw89: wow: add QoS control field to WoWLA=
N ARP response for MLO
> * [PATCH 6.18 0092/1005] soc: amlogic: meson-clk-measure: remove debugfs =
tree
> * [PATCH 6.18 0093/1005] block: reject block device inodes with i_rdev =
=3D=3D 0 in lookup_bdev()
> * [PATCH 6.18 0094/1005] iio: adc: max1241: add missing MODULE_DEVICE_TAB=
LE()
> * [PATCH 6.18 0095/1005] RDMA/irdma: Suppress PF reset on HMC error
> * [PATCH 6.18 0096/1005] soc: qcom: socinfo: Add SoC ID for SDM850
> * [PATCH 6.18 0097/1005] RDMA/rxe: Check PDs for memory window binds
> * [PATCH 6.18 0098/1005] dt-bindings: arm: qcom,ids: Add SoC ID for Snapd=
ragon SDM 850
> * [PATCH 6.18 0099/1005] gpio: sifive: add missing MODULE_DEVICE_TABLE()
> * [PATCH 6.18 0100/1005] mmc: moxart: report DMA completion timeout
> * [PATCH 6.18 0101/1005] mmc: cqhci: fix to missed endian conversions
> * [PATCH 6.18 0102/1005] mmc: sdhci-of-ma35d1: add missing MODULE_DEVICE_=
TABLE()
> * [PATCH 6.18 0103/1005] mmc: dw_mmc: stop and complete DMA also in STATE=
_DATA_BUSY state
> * [PATCH 6.18 0104/1005] clk: sunxi-ng: fix ccu probe clock unregister on=
 error
> * [PATCH 6.18 0105/1005] remoteproc: core: Full attach detach during reco=
very
> * [PATCH 6.18 0106/1005] nvme: handle positive error codes in nuse_show()
> * [PATCH 6.18 0107/1005] nvme-auth: use crypto_memneq for DH-HMAC-CHAP re=
sponse comparison
> * [PATCH 6.18 0108/1005] nvme: zns: cap zone report nr_zones by DMA buffe=
r size
> * [PATCH 6.18 0109/1005] staging: rtl8723bs: fix missing unregister_netde=
v on sdio_alloc_irq failure
> * [PATCH 6.18 0110/1005] usb: typec: mux: tusb1046: add missing MODULE_DE=
VICE_TABLE()
> * [PATCH 6.18 0111/1005] udf: validate extent partition references in udf=
_current_aext()
> * [PATCH 6.18 0112/1005] udf: avoid recursive s_alloc_mutex deadlock when=
 freeing AED blocks
> * [PATCH 6.18 0113/1005] ASoC: codecs: uda1342: Leave cache-only mode bef=
ore syncing
> * [PATCH 6.18 0114/1005] drm/amdgpu/atomfirmware: WARN() rather than BUG(=
)
> * [PATCH 6.18 0115/1005] drm/amdgpu/gfx11: WARN() rather than BUG() for i=
nvalid SDMA engine
> * [PATCH 6.18 0116/1005] nvme: dont reference NS after unlocking in nvme_=
ns_head_ctrl_ioctl()
> * [PATCH 6.18 0117/1005] bus: mhi: core: Fix sys error transition latency
> * [PATCH 6.18 0118/1005] platform/x86/amd/hsmp: Validate ACPI UID before =
parsing socket index
> * [PATCH 6.18 0119/1005] ASoC: codecs: max98396: Unwind supplies on resum=
e failure
> * [PATCH 6.18 0120/1005] platform/x86/amd/hsmp: Validate _DSD mailbox sub=
-package element count
> * [PATCH 6.18 0121/1005] PCI/ATS: Ensure pci_ats_supported() is PF-aware =
for VFs
> * [PATCH 6.18 0122/1005] rpmsg: char: Check for ongoing chrdev destroy
> * [PATCH 6.18 0123/1005] media: cec: tegra: add missing MODULE_DEVICE_TAB=
LE()
> * [PATCH 6.18 0124/1005] media: v4l2-tpg: reduce stack usage for kasan bu=
ilds
> * [PATCH 6.18 0125/1005] mmc: block: reject invalid perdev_minors before =
division
> * [PATCH 6.18 0126/1005] serial: 8250: force synchronous probe for the IS=
A and PNP drivers
> * [PATCH 6.18 0127/1005] tty: serial: pch_uart: add check for pci_get_slo=
t()
> * [PATCH 6.18 0128/1005] serial: qcom_geni: Disable closing_wait for cons=
ole to prevent shutdown timeout
> * [PATCH 6.18 0129/1005] usb: fsl_qe_udc: check qe_alloc_request() failur=
e in ch9getstatus()
> * [PATCH 6.18 0130/1005] usb: gadget: u_audio: clean up capture endpoint =
on feedback failure
> * [PATCH 6.18 0131/1005] usb_string_copy: Use kzalloc() to avoid leaking =
old data
> * [PATCH 6.18 0132/1005] USB: gadget: inode: fix mm lifetime handling
> * [PATCH 6.18 0133/1005] pinctrl: sx150x: add missing MODULE_DEVICE_TABLE=
()
> * [PATCH 6.18 0134/1005] crypto: keembay - add missing MODULE_DEVICE_TABL=
E()
> * [PATCH 6.18 0135/1005] gpio: vf610: add missing MODULE_DEVICE_TABLE()
> * [PATCH 6.18 0136/1005] pmdomain: qcom: rpmhpd: Skip retention by defaul=
t
> * [PATCH 6.18 0137/1005] mmc: rtsx_usb_sdmmc: suppress false CD after ini=
t timeout
> * [PATCH 6.18 0138/1005] media: em28xx: dev_info->pr_info since dev has b=
een freed
> * [PATCH 6.18 0139/1005] media: em28xx: requeue buffers if start_streamin=
g fails
> * [PATCH 6.18 0140/1005] media: em28xx: use vb2_video_unregister_device
> * [PATCH 6.18 0141/1005] drm/xe: only resume exec queues that were actual=
ly suspended
> * [PATCH 6.18 0142/1005] soundwire: dmi-quirks: add a global ghost list
> * [PATCH 6.18 0143/1005] soundwire: intel_auxdevice: Add cs42l44 to wake_=
capable_list
> * [PATCH 6.18 0144/1005] hfs: validate catalog CNIDs before instantiating=
 inodes
> * [PATCH 6.18 0145/1005] nvme: bound ns descriptor header and body to ide=
ntify buffer
> * [PATCH 6.18 0146/1005] iwlwifi: dvm: add missing cleaup for on error pa=
th
> * [PATCH 6.18 0147/1005] nvme: clamp FDP nruhsd to allocated RUH status d=
escriptor count
> * [PATCH 6.18 0148/1005] media: i2c: ov8865: Drop the runtime PM usage co=
unt on stream failure
> * [PATCH 6.18 0149/1005] drm/etnaviv: check all modules for idle after re=
set
> * [PATCH 6.18 0150/1005] drm/etnaviv: check MMUv2 status after reset
> * [PATCH 6.18 0151/1005] media: i2c: ov8865: Program the sensor on stream=
 start
> * [PATCH 6.18 0152/1005] media: ivtv: stop VBI start-code scan before sho=
rt tail
> * [PATCH 6.18 0153/1005] media: cx18: stop VBI start-code scan before sho=
rt tail
> * [PATCH 6.18 0154/1005] media: go7007: avoid undefined shifts in MPEG-4 =
headers
> * [PATCH 6.18 0155/1005] remoteproc: qcom: Check subdev start status in r=
proc_stop()
> * [PATCH 6.18 0156/1005] wifi: iwlwifi: validate PNVM SKU TLV length
> * [PATCH 6.18 0157/1005] wifi: iwlwifi: support TTL platform device ID
> * [PATCH 6.18 0158/1005] wifi: iwlwifi: validate UEFI reduced-power SKU T=
LV length
> * [PATCH 6.18 0159/1005] wifi: iwlwifi: mld: validate D3_END notif size
> * [PATCH 6.18 0160/1005] remoteproc: core: cancel crash_handler work in r=
proc_add() error path
> * [PATCH 6.18 0161/1005] wifi: iwlwifi: mld: reset the driver state upon =
firmware recovery
> * [PATCH 6.18 0162/1005] ASoC: cs35l56: Add support for CS35L62 for Sound=
Wire
> * [PATCH 6.18 0163/1005] wifi: iwlwifi: mvm: reset the smart fifo state u=
pon FW stop
> * [PATCH 6.18 0164/1005] wifi: iwlwifi: mld: cancel wiphy work before fre=
eing wiphy
> * [PATCH 6.18 0165/1005] tools/lib/api: Fix potential double-free from fd=
array__grow()
> * [PATCH 6.18 0166/1005] gpu: host1x: Wait for timeout worker completion =
on channel free
> * [PATCH 6.18 0167/1005] wifi: iwlwifi: mld: support aborting an ongoing =
ftm request
> * [PATCH 6.18 0168/1005] wifi: iwlwifi: mld: Do not cleanup FW state when=
 the device is dead
> * [PATCH 6.18 0169/1005] scsi: qla2xxx: Handle INTx not connected while p=
assing through
> * [PATCH 6.18 0170/1005] media: cec: tegra_cec: dont break off msg on NAC=
K
> * [PATCH 6.18 0171/1005] media: cec/core: drop cec_post_state_event call
> * [PATCH 6.18 0172/1005] usb: musb: host: clear stale RX interrupt on thr=
ee-strikes error
> * [PATCH 6.18 0173/1005] usb: misc: cypress_cy7c63: check result of IO
> * [PATCH 6.18 0174/1005] USB: misc: uss720: Fix leak in get_1284_register
> * [PATCH 6.18 0175/1005] uio: sercos3: add missing MODULE_DEVICE_TABLE()
> * [PATCH 6.18 0176/1005] comedi: ni_atmio16d: Add sanity check to interru=
pt handler
> * [PATCH 6.18 0177/1005] comedi: ni_at_a2150: Fix sanity check in interru=
pt handler
> * [PATCH 6.18 0178/1005] comedi: pcm818: Fix sanity check in interrupt ha=
ndler
> * [PATCH 6.18 0179/1005] comedi: quatech_daqp_cs: Fix sanity check in int=
errupt handler
> * [PATCH 6.18 0180/1005] comedi: das6402: Add sanity check to interrupt h=
andler
> * [PATCH 6.18 0181/1005] comedi: dt2811: Fix sanity check in interrupt ha=
ndler
> * [PATCH 6.18 0182/1005] comedi: pcm711: Fix sanity check in interrupt ha=
ndler
> * [PATCH 6.18 0183/1005] comedi: aio_iiro_16: Add sanity check to interru=
pt handler
> * [PATCH 6.18 0184/1005] comedi: pcmmio: Add sanity check to interrupt ha=
ndler
> * [PATCH 6.18 0185/1005] comedi: pcm816: Fix sanity check in interrupt ha=
ndler
> * [PATCH 6.18 0186/1005] comedi: pcmuio: Add sanity check to interrupt ha=
ndler
> * [PATCH 6.18 0187/1005] misc: bcm-vk: validate write size before allocat=
ion
> * [PATCH 6.18 0188/1005] misc: genwqe: handle a first DMA address of zero
> * [PATCH 6.18 0189/1005] misc: hpilo: validate device queue entries befor=
e use
> * [PATCH 6.18 0190/1005] misc: rp1: clear chained IRQ handlers on teardow=
n
> * [PATCH 6.18 0191/1005] greybus: manifest: validate string descriptor he=
ader
> * [PATCH 6.18 0192/1005] misc: ibmvmc: release send buffer on write error=
s
> * [PATCH 6.18 0193/1005] ipack: ipoctal: add rwsem to guard against TOCTO=
U in remove path
> * [PATCH 6.18 0194/1005] misc: ibmvmc: reject oversized inbound messages
> * [PATCH 6.18 0195/1005] PCI: switchtec: Add Microchip PCI1008 device ID
> * [PATCH 6.18 0196/1005] PCI: switchtec: Add Microchip PCI1008 to NTB DMA=
 alias quirk
> * [PATCH 6.18 0197/1005] driver core: attribute_container: Unwind device_=
add() on attr failure
> * [PATCH 6.18 0198/1005] drm/msm/adreno: Add support for A704 GPU
> * [PATCH 6.18 0199/1005] wifi: iwlwifi: mld: validate wake packet crypto =
overhead
> * [PATCH 6.18 0200/1005] wifi: iwlwifi: mld: drop connection on D3 resume=
 failure
> * [PATCH 6.18 0201/1005] wifi: iwlwifi: mvm: ignore sync frames when sync=
 is disabled
> * [PATCH 6.18 0202/1005] media: dvb-core: fix feed leak on failed DMX_ADD=
_PID
> * [PATCH 6.18 0203/1005] media: go7007: s2250: propagate control I/O fail=
ures
> * [PATCH 6.18 0204/1005] drm/panel: panel-edp: Adjust T8 timing for AUO B=
116XAK01.6 and B140XTK02.4
> * [PATCH 6.18 0205/1005] platform/x86: asus-nb-wmi: map ProArt key (0x8b)=
 to KEY_PROG3
> * [PATCH 6.18 0206/1005] ALSA: hda: Check snd_hda_power_pm construct erro=
r before executing verb
> * [PATCH 6.18 0207/1005] ACPI: FPDT: validate table and record lengths
> * [PATCH 6.18 0208/1005] ACPI: battery: Sanitise model_number by dropping=
 unprintable characters
> * [PATCH 6.18 0209/1005] platform/x86/amd/pmc: Add T14 Gen2 AMD (20XL) to=
 s2idle quirk list
> * [PATCH 6.18 0210/1005] ext4: reduce max cluster size to match documente=
d 256MB limit
> * [PATCH 6.18 0211/1005] PCI: vmd: Handle BUS_RESTRICT_CFG value 3 for Ar=
row Lake-HX
> * [PATCH 6.18 0212/1005] ext4: set EXT4_STATE_NO_EXPAND in ext4_evict_ino=
de
> * [PATCH 6.18 0213/1005] wifi: mac80211: ibss: read deauth reason_code af=
ter frame length check
> * [PATCH 6.18 0214/1005] wifi: mac80211_hwsim: clear PMSR request state o=
n abort
> * [PATCH 6.18 0215/1005] ACPI: sysfs: Properly map BERT and CCEL data to =
their ACPI tables
> * [PATCH 6.18 0216/1005] riscv, bpf: Add support for BPF_SDIV and BPF_SMO=
D in RV32 JIT
> * [PATCH 6.18 0217/1005] power: supply: cros_pchg: unregister EC notifier
> * [PATCH 6.18 0218/1005] net: sfp: add quirk for HORACO copper SFP+ modul=
e
> * [PATCH 6.18 0219/1005] net: prestera: ignore duplicate RIF destruction =
events
> * [PATCH 6.18 0220/1005] power: reset: piix4-poweroff: add missing MODULE=
_DEVICE_TABLE()
> * [PATCH 6.18 0221/1005] riscv, bpf: Add support for BPF_MOVSX in RV32 JI=
T
> * [PATCH 6.18 0222/1005] wifi: cfg80211: include cf1 offset when sending =
chandef
> * [PATCH 6.18 0223/1005] ext4: reject mount if clusters/inodes per group =
are not 8-aligned
> * [PATCH 6.18 0224/1005] iommu/arm-smmu-qcom: Add SM8450 MDSS compatible
> * [PATCH 6.18 0225/1005] drm/panel: simple: Add Kyocera tcg070wvlq panel
> * [PATCH 6.18 0226/1005] iommu/qcom: Check pm_runtime_resume_and_get() re=
turn in probe
> * [PATCH 6.18 0227/1005] iommu/qcom: Enable clocks before hardware access=
 in qcom_iommu_ctx_probe()
> * [PATCH 6.18 0228/1005] thermal: intel: int340x: clean up RFIM groups on=
 DVFS failure
> * [PATCH 6.18 0229/1005] iommu/qcom: Publish pgtbl_ops before releasing i=
nit_mutex
> * [PATCH 6.18 0230/1005] net: libwx: disable TX VLAN offload for packets =
with >2 VLAN tags
> * [PATCH 6.18 0231/1005] wifi: ath11k: validate regulatory capability phy=
_id
> * [PATCH 6.18 0232/1005] wifi: ath10k: trigger hardware recovery upon rx =
failures
> * [PATCH 6.18 0233/1005] wifi: ath12k: fix scan command endianness on big=
 endian
> * [PATCH 6.18 0234/1005] ext4: check return value of ext4_get_block() in =
ext4_load_tail_bh()
> * [PATCH 6.18 0235/1005] ext4: use FGP_WRITEBEGIN for tail block zeroing
> * [PATCH 6.18 0236/1005] bitops: make the *_bit_le functions use unsigned=
 long
> * [PATCH 6.18 0237/1005] ata: pata_ep93xx: fix PIO fallback when DMA init=
 fails
> * [PATCH 6.18 0238/1005] drm/etnaviv: force flush on power register ops
> * [PATCH 6.18 0239/1005] soc: ixp4xx: qmgr: add missing MODULE_DEVICE_TAB=
LE()
> * [PATCH 6.18 0240/1005] ntfs3: initialize err in attr_wof_frame_info
> * [PATCH 6.18 0241/1005] PCI/portdrv: Allow probing even without child se=
rvices
> * [PATCH 6.18 0242/1005] fs/ntfs3: reserve NUL byte when converting UTF-1=
6 names
> * [PATCH 6.18 0243/1005] ntfs3: fix info-leak in ntfs_rename()
> * [PATCH 6.18 0244/1005] fs/ntfs3: fix lseek EINVAL on sparse/compressed =
files with 64-bit clusters
> * [PATCH 6.18 0245/1005] fs/ntfs3: load ATTR_BITMAP run extents from $MFT=
 extension records
> * [PATCH 6.18 0246/1005] platform/x86: int1092: Fix info leak in parse_pa=
ckage()
> * [PATCH 6.18 0247/1005] firmware: imx: scu: manage mailbox channels and =
global handle
> * [PATCH 6.18 0248/1005] pinctrl: npcm8xx: enable RMII outputs from RMII =
groups
> * [PATCH 6.18 0249/1005] pinctrl: npcm8xx: clear pending GPIO events duri=
ng init
> * [PATCH 6.18 0250/1005] pinctrl: npcm8xx: fix debounce register selectio=
n
> * [PATCH 6.18 0251/1005] pinctrl: npcm8xx: move GPIO IRQ setup into reque=
st_resources
> * [PATCH 6.18 0252/1005] hsi: omap_ssi: remove debugfs on port creation f=
ailure
> * [PATCH 6.18 0253/1005] iommu/rockchip: Clear stale page faults before e=
nabling stall
> * [PATCH 6.18 0254/1005] scsi: ibmvfc: check for NULL evt in implicit LOG=
O and target delete path
> * [PATCH 6.18 0255/1005] scsi: ibmvfc: free ibmvfc_target allocations wit=
h mempool_free
> * [PATCH 6.18 0256/1005] udf: Fix bh leak for unallocated space entries
> * [PATCH 6.18 0257/1005] udf: bound lengthAllocDescs from unallocated spa=
ce entry
> * [PATCH 6.18 0258/1005] exfat: write moved entry before removing source
> * [PATCH 6.18 0259/1005] remoteproc: Force shutdown during device removal
> * [PATCH 6.18 0260/1005] iommu/tegra241-cmdqv: Rate-limit the error ISRs =
log message
> * [PATCH 6.18 0261/1005] clk: imx: imx8qxp: add missing MODULE_DEVICE_TAB=
LE()
> * [PATCH 6.18 0262/1005] clk: imx: imx8qxp-lpcg: add missing MODULE_DEVIC=
E_TABLE()
> * [PATCH 6.18 0263/1005] media: cx88: fix memory leak in cx8802_register_=
driver() error path
> * [PATCH 6.18 0264/1005] clk: mediatek: mt6735-vdecsys: add missing MODUL=
E_DEVICE_TABLE()
> * [PATCH 6.18 0265/1005] clk: mediatek: mt6735-vencsys: add missing MODUL=
E_DEVICE_TABLE()
> * [PATCH 6.18 0266/1005] clk: tegra: support 48MHz clock for pll_p_out1
> * [PATCH 6.18 0267/1005] clk: clocking-wizard: fix clock difference detec=
tion
> * [PATCH 6.18 0268/1005] ata: ata_generic: Dont store pci_device_id
> * [PATCH 6.18 0269/1005] i2c: qup: Propagate clock enable failures
> * [PATCH 6.18 0270/1005] scsi: smartpqi: Add new PCI device-ids
> * [PATCH 6.18 0271/1005] drm/amdkfd: Fix signal reset event
> * [PATCH 6.18 0272/1005] drm/amd/display: Fix rounding errors in Calculat=
ePrefetchSchedule
> * [PATCH 6.18 0273/1005] arm64/runtime-const: Use aarch64_insn_patch_text=
_nosync() for patching
> * [PATCH 6.18 0274/1005] exfat: clean up new entry on add entry failure
> * [PATCH 6.18 0275/1005] ALSA: hda/conexant: Add NULL check for dc_mode_p=
ath
> * [PATCH 6.18 0276/1005] drm/msm: Move nr_cmds initialization
> * [PATCH 6.18 0277/1005] drm/msm: Fix barriers accessing ctx vm
> * [PATCH 6.18 0278/1005] platform/x86: dell-smbios-wmi: Fix chardev resou=
rce management
> * [PATCH 6.18 0279/1005] s390/mm: Add missing mm check to do_secure_stora=
ge_access()
> * [PATCH 6.18 0280/1005] s390/mm: Fix handling of vmalloc area in do_secu=
re_storage_access()
> * [PATCH 6.18 0281/1005] drm/panel-edp: Add BOE NE140QDM-NX2
> * [PATCH 6.18 0282/1005] soc: mediatek: add missing MODULE_DEVICE_TABLE()
> * [PATCH 6.18 0283/1005] exfat: free new directory cluster if zeroing fai=
ls
> * [PATCH 6.18 0284/1005] ALSA: hda/realtek: add missing NULL check for co=
dec->bus->pci
> * [PATCH 6.18 0285/1005] fs/ntfs3: Fix memory leak in indx_find_sort()
> * [PATCH 6.18 0286/1005] mfd: ipaq-micro: Fix out-of-bounds stack read in=
 ipaq_micro_str
> * [PATCH 6.18 0287/1005] ALSA: hda/realtek: add missing error checks for =
COEF index reads in alc269
> * [PATCH 6.18 0288/1005] mfd: axp20x: Preserve other control bits when po=
wering off
> * [PATCH 6.18 0289/1005] regulator: rt6245: Restore state on enable failu=
re
> * [PATCH 6.18 0290/1005] md/raid5: complete discard bios while reshape is=
 active
> * [PATCH 6.18 0291/1005] romfs: detect hard link cycles
> * [PATCH 6.18 0292/1005] nvmem: brcm_nvram: reject empty NVRAM partition
> * [PATCH 6.18 0293/1005] nvmem: brcm_nvram: fix out-of-bounds access on m=
alformed flash data
> * [PATCH 6.18 0294/1005] virtio_console: take a kref in find_port_by_vq()=
 to fix port UAF
> * [PATCH 6.18 0295/1005] wifi: mt76: mt7603: free beacon SKB on error
> * [PATCH 6.18 0296/1005] wifi: mt76: mt76x02: report rx FCS errors to mac=
80211
> * [PATCH 6.18 0297/1005] wifi: mt76: mt7915: configure noise floor report=
ing on reset
> * [PATCH 6.18 0298/1005] wifi: mt76: mt7921: fix memory leak when skb_lin=
earize fails in mcu rx event
> * [PATCH 6.18 0299/1005] wifi: mt76: mt7603: add 0x7592 EEPROM chip ID
> * [PATCH 6.18 0300/1005] wifi: mt76: wed: fix kernel panic on non-DBDC MT=
7986
> * [PATCH 6.18 0301/1005] netfilter: conntrack: tcp: use UNACK timeout for=
 non-closing RST packets
> * [PATCH 6.18 0302/1005] netfilter: nf_tables: call skb_valid_dst() befor=
e skb_dst()
> * [PATCH 6.18 0303/1005] perf: marvell: Cancel CN10K DDR PMU hrtimer on d=
evice remove
> * [PATCH 6.18 0304/1005] wifi: ath11k: fix resource leak on error in ext =
IRQ setup
> * [PATCH 6.18 0305/1005] ASoC: SOF: Intel: mtl: Power down DSP if it is l=
eft enabled in pre_fw_run()
> * [PATCH 6.18 0306/1005] wifi: mt76: mt7615: fix NULL deref in mt7615_mac=
_set_rates
> * [PATCH 6.18 0307/1005] wifi: mt76: set the EOSP bit in the QoS header o=
f the last released frame
> * [PATCH 6.18 0308/1005] wifi: mt76: mt7603: fix U-APSD service period te=
rmination
> * [PATCH 6.18 0309/1005] wifi: mt76: mt7603: restore hardware PS bufferin=
g after a service period
> * [PATCH 6.18 0310/1005] wifi: brcmfmac: Set DMA direction for msgbuf pac=
ket IDs
> * [PATCH 6.18 0311/1005] wifi: brcmfmac: validate msgbuf flowring IDs bef=
ore use
> * [PATCH 6.18 0312/1005] wifi: wilc1000: validate monitor transmit frame =
headers
> * [PATCH 6.18 0313/1005] ALSA: hda/realtek: Add quirk for ASUS VivoBook M=
515DA/X515DAP
> * [PATCH 6.18 0314/1005] HID: logitech-hidpp: Add support for G502 X Plus=
 USB mouse
> * [PATCH 6.18 0315/1005] HID: quirks: Add ALWAYS_POLL quirk for Beitong B=
TP-KP20D dongle
> * [PATCH 6.18 0316/1005] HID: quirks: add ALWAYS_POLL quirk for AULA Mini=
 60 HE Pro Dongle
> * [PATCH 6.18 0317/1005] HID: intel-ish-hid: ignore post-init ENUM_DEVICE=
S from firmware
> * [PATCH 6.18 0318/1005] net/rds: dont use unpin_user_pages_dirty_lock() =
from atomic context
> * [PATCH 6.18 0319/1005] net/rds: hold the socket while an rds_mr referen=
ces it
> * [PATCH 6.18 0320/1005] net/rds: fix rds_message leak in the rds_send_xm=
it() drop path
> * [PATCH 6.18 0321/1005] net/rds: unpin MR pages with unpin_user_pages_di=
rty_lock()
> * [PATCH 6.18 0322/1005] kconfig: abort rather than loop for ever on EOF
> * [PATCH 6.18 0323/1005] s390/dasd: Snapshot intrc before freeing the req=
uest block
> * [PATCH 6.18 0324/1005] ALSA: hda/realtek: Add mute LED support for HP P=
avilion 15-eh2xxx
> * [PATCH 6.18 0325/1005] ACPI: video: force native backlight on Acer Nitr=
o AN515-46
> * [PATCH 6.18 0326/1005] wifi: mt76: mt7603: file buffered frames under t=
he TID reported to mac80211
> * [PATCH 6.18 0327/1005] net: stmmac: raise TX completion interrupt at th=
e end of an xmit burst
> * [PATCH 6.18 0328/1005] net: usb: cdc_ether: add quirk for AMI BMC stale=
 link events
> * [PATCH 6.18 0329/1005] xsk: account ring allocations to memcg
> * [PATCH 6.18 0330/1005] ALSA: hda/realtek: Enable mute LED on HP Laptop =
15-dy0xxx
> * [PATCH 6.18 0331/1005] ALSA: hda/realtek: Limit mic boost on Positivo N=
15RPE-S
> * [PATCH 6.18 0332/1005] opp: Use clk_get_optional() to avoid leaving opp=
_table->clk as an error pointer
> * [PATCH 6.18 0333/1005] soundwire: dmi-quirks: Disable ghost Realtek on =
Asus Zenbook Duo
> * [PATCH 6.18 0334/1005] wifi: rsi: Fix types to appease CFI
> * [PATCH 6.18 0335/1005] arm64: mm: fix accidental linear mapping of no-m=
ap reserved memory
> * [PATCH 6.18 0336/1005] drm/amd/pm: derive stable PPT limits from PPTabl=
e
> * [PATCH 6.18 0337/1005] HID: rmi: check report length before trimming se=
ntinel bytes
> * [PATCH 6.18 0338/1005] ext4: guard against NULL s_group_info in ext4_ge=
t_group_info
> * [PATCH 6.18 0339/1005] ALSA: hda/realtek: Enable mute LEDs on HP Spectr=
e x360 16-aa0xxx
> * [PATCH 6.18 0340/1005] md/raid5: reject zero-sector reshape chunks
> * [PATCH 6.18 0341/1005] md: skip bitmap accounting for empty write range=
s
> * [PATCH 6.18 0342/1005] md: add cond_resched() to md_do_sync()s skip pat=
h
> * [PATCH 6.18 0343/1005] tools/lib/thermal: Fix misplaced extern "C" clos=
ing brace
> * [PATCH 6.18 0344/1005] selftests/ftrace: Force C locale in ftracetest
> * [PATCH 6.18 0345/1005] Bluetooth: btusb: Add USB ID 13d3:3625 for Media=
Tek MT7922
> * [PATCH 6.18 0346/1005] Bluetooth: btusb: Add support for 1357:c123 Real=
tek 8852BE device
> * [PATCH 6.18 0347/1005] Bluetooth: hci_nokia: validate firmware packet b=
ounds
> * [PATCH 6.18 0348/1005] Bluetooth: btnxpuart: Fix use-after-free in prob=
e error path
> * [PATCH 6.18 0349/1005] Bluetooth: bfusb: validate received block bounda=
ries
> * [PATCH 6.18 0350/1005] btrfs: fix memory barrier order in reloc_root_is=
_dead()
> * [PATCH 6.18 0351/1005] drm/amd: Add DCN6 register headers
> * [PATCH 6.18 0352/1005] ACPI: APEI: Handle repeated SEA error storms
> * [PATCH 6.18 0353/1005] ALSA: hda/realtek: Fix headset mic on ASUS Vivob=
ook S14 S5406SA
> * [PATCH 6.18 0354/1005] ALSA: hda/realtek: Fix speakers on ASUS ROG Zeph=
yrus G14 GA403UM
> * [PATCH 6.18 0355/1005] ALSA: hda/conexant: Add pin config quirk for Hua=
wei Matebook
> * [PATCH 6.18 0356/1005] ALSA: hda/realtek: Add quirk for Acer Nitro ANV1=
6-42 headset mic
> * [PATCH 6.18 0357/1005] Bluetooth: btrsi: Move set_bt_context after succ=
essful HCI registration
> * [PATCH 6.18 0358/1005] Bluetooth: hci_bcsp: validate received packet le=
ngths
> * [PATCH 6.18 0359/1005] Bluetooth: fix BT dependency for submodules
> * [PATCH 6.18 0360/1005] Bluetooth: hci_sync: Disable legacy instances ex=
t adv before setup snapshot
> * [PATCH 6.18 0361/1005] net: dsa: mt7530: error out on failed PHY_IAC co=
mmand writes
> * [PATCH 6.18 0362/1005] Bluetooth: hci_event: fix out-of-bounds read in =
LE PA report reassembly
> * [PATCH 6.18 0363/1005] net: dsa: mt7530: check bus->read() error in cor=
e_rmw()
> * [PATCH 6.18 0364/1005] net: pcs: mtk-lynxi: check regmap reads in mtk_p=
cs_lynxi_get_state()
> * [PATCH 6.18 0365/1005] net: dsa: mt7530: check CORE_PLL_GROUP4 access i=
n mt7531_setup()
> * [PATCH 6.18 0366/1005] riscv: kprobes: Prevent probes in breakpoint han=
dlers
> * [PATCH 6.18 0367/1005] RISC-V: perf: fix resource cleanup on driver pro=
be failure
> * [PATCH 6.18 0368/1005] fbdev: omap2: dsi: do not copy isr table
> * [PATCH 6.18 0369/1005] fbdev: udlfb: validate vendor descriptor items
> * [PATCH 6.18 0370/1005] iommu/vt-d: Fix CACHE_TAG_NESTING_DEVTLB polluti=
ng shared variables in flush loop
> * [PATCH 6.18 0371/1005] ALSA: usx2y: Stop clearing urb->hcpriv before su=
bmission
> * [PATCH 6.18 0372/1005] perf/x86: Unregister PMI handler on PMU init fai=
lure
> * [PATCH 6.18 0373/1005] perf/x86: Free hybrid state on PMU init failure
> * [PATCH 6.18 0374/1005] nvmet: passthru: fix OOB reads when parsing ns i=
d descriptor list
> * [PATCH 6.18 0375/1005] selftests/net: fin_ack_lat: fix latency threshol=
d typo
> * [PATCH 6.18 0376/1005] docs: cgroup-v2: fix stale "io" controller intro=
duction
> * [PATCH 6.18 0377/1005] nvme-tcp: look up host_iface in the current netn=
s
> * [PATCH 6.18 0378/1005] tap: fix incorrect variable used for USO check i=
n set_offload()
> * [PATCH 6.18 0379/1005] apparmor: fix auditing of mount binary data
> * [PATCH 6.18 0380/1005] selftests: net: reuseport_bpf_numa: consider cpu=
less numa node
> * [PATCH 6.18 0381/1005] iommu/amd: Fix missing CMD_COMPLETE_PPR response=
 for invalid PPR requests
> * [PATCH 6.18 0382/1005] nfc: mrvl: spi: Unregister dev on allocation fai=
l
> * [PATCH 6.18 0383/1005] nfc: nxp-nci: Add remove on IRQ error
> * [PATCH 6.18 0384/1005] nvme: ratelimit the completion-path messages dri=
ven by device data
> * [PATCH 6.18 0385/1005] alpha: run the remote RTC access in a worker, no=
t an IPI callback
> * [PATCH 6.18 0386/1005] ALSA: hda/conexant: Add mute LED quirk for HP Pr=
oBook 440 G5
> * [PATCH 6.18 0387/1005] hfsplus: validate extent record length before wr=
iting it back
> * [PATCH 6.18 0388/1005] regulator: fan53555: Add support for FAN53555BUC=
23X type
> * [PATCH 6.18 0389/1005] soundwire: dmi-quirks: Disable ghost Realtek on =
Asus ROG Zephyrus Duo
> * [PATCH 6.18 0390/1005] ipmi: Fix leak in __ipmi_bmc_register
> * [PATCH 6.18 0391/1005] PCI: Avoid saving config space state if inaccess=
ible
> * [PATCH 6.18 0392/1005] ALSA: hda/intel: Add sanity check for BAR0 size
> * [PATCH 6.18 0393/1005] xhci: include all root port children in recovery=
 prevention on link error
> * [PATCH 6.18 0394/1005] ALSA: usb-audio: Rename the Audient iD14 monitor=
 mix volume control
> * [PATCH 6.18 0395/1005] HID: amd_sfh: Serialize access to the shared emp=
2 pointer
> * [PATCH 6.18 0396/1005] drm/virtio: reclaim pending vbufs before tearing=
 down vqs
> * [PATCH 6.18 0397/1005] exfat: keep FITRIM within the requested range
> * [PATCH 6.18 0398/1005] gre: fix ERSPAN o_flags race/corruption in xmit =
and fill_info
> * [PATCH 6.18 0399/1005] crypto: keembay - use crypto_memneq() to compare=
 GCM AEAD tags
> * [PATCH 6.18 0400/1005] crypto: sa2ul - use crypto_memneq() to compare A=
EAD tag
> * [PATCH 6.18 0401/1005] libbpf: Fix ring buffer consumer loop on 32-bit =
position wrap
> * [PATCH 6.18 0402/1005] crypto: keembay - use crypto_memneq() to compare=
 CCM AEAD tags
> * [PATCH 6.18 0403/1005] ksmbd: protect private extended attributes
> * [PATCH 6.18 0404/1005] ksmbd: preserve access denied status for copychu=
nk
> * [PATCH 6.18 0405/1005] ksmbd: allow I/O on directory named streams
> * [PATCH 6.18 0406/1005] ksmbd: fix durable handle v2 default timeout uni=
ts (60 -> 60000)
> * [PATCH 6.18 0407/1005] ksmbd: reject SMB3.1.1 binding with mismatched c=
ipher
> * [PATCH 6.18 0408/1005] ksmbd: fix off-by-one rejecting minimal COPYCHUN=
K query-limits request
> * [PATCH 6.18 0409/1005] ksmbd: return buffer too small for short securit=
y queries
> * [PATCH 6.18 0410/1005] ksmbd: handle empty QUERY_ALLOCATED_RANGES outpu=
t
> * [PATCH 6.18 0411/1005] ksmbd: honor byte-range locks for zero data
> * [PATCH 6.18 0412/1005] ksmbd: allow FSCTL_SET_SPARSE without input buff=
er
> * [PATCH 6.18 0413/1005] ksmbd: skip fallocate for SMB2_CREATE_ALLOCATION=
_SIZE on a stream handle
> * [PATCH 6.18 0414/1005] ksmbd: report actual xattr value length in strea=
m enumeration
> * [PATCH 6.18 0415/1005] smb/server: cancel async requests when closing c=
onnection
> * [PATCH 6.18 0416/1005] ALSA: hda/realtek: Fix mute LED for HP Victus 15=
-fa1xxx (MB 8C3F)
> * [PATCH 6.18 0417/1005] ksmbd: fix SMB2 byte-range lock end offset
> * [PATCH 6.18 0418/1005] ksmbd: fix AsyncId zeroed before use in smb2_loc=
k() cancel response
> * [PATCH 6.18 0419/1005] ksmbd: reject blocking compound lock requests
> * [PATCH 6.18 0420/1005] ksmbd: honor client signing-required in all mode=
s
> * [PATCH 6.18 0421/1005] smb: server: Make sure that passkey is not leake=
d on the heap in user_config.c
> * [PATCH 6.18 0422/1005] pNFS: honor clora_changed when recalling a layou=
t
> * [PATCH 6.18 0423/1005] ksmbd: notify parent directory leases on child c=
reate
> * [PATCH 6.18 0424/1005] smb: server: Free session data in user_session.c=
 with kfree_sensitive()
> * [PATCH 6.18 0425/1005] NFS: Verify symlink inode before caching target
> * [PATCH 6.18 0426/1005] ALSA: hda: Add Lisuan HDMI controller and codec =
support
> * [PATCH 6.18 0427/1005] NFSv4: pin the superblock for active state owner=
s
> * [PATCH 6.18 0428/1005] net: stmmac: use dma_addr_t for DMA addresses
> * [PATCH 6.18 0429/1005] NFSv4/flexfiles: report cancelled I/O as a layou=
t error
> * [PATCH 6.18 0430/1005] platform/x86: msi-ec: Add MSI Katana GF76 11UEK =
EC firmware
> * [PATCH 6.18 0431/1005] platform/x86: thinkpad_acpi: Fix fan speed repor=
ting on Edge E330
> * [PATCH 6.18 0432/1005] ASoC: codec: max98926: fixup invert setup mask
> * [PATCH 6.18 0433/1005] vdpa_sim: hold iommu_lock across dma_unmap passt=
hrough transition
> * [PATCH 6.18 0434/1005] drm/radeon: fix internal display on iMac11, 1 (R=
V770/DCE3.1)
> * [PATCH 6.18 0435/1005] vdpa/mlx5: roll back MR update after VQ setup fa=
ilure
> * [PATCH 6.18 0436/1005] ALSA: usb-audio: Add MIN_MUTE quirk for Creative=
 Sound Blaster Play! 3
> * [PATCH 6.18 0437/1005] virtio_balloon: warn on failed buffer add in tel=
l_host()
> * [PATCH 6.18 0438/1005] rtc: ab-eoz9: add missing MODULE_DEVICE_TABLE()
> * [PATCH 6.18 0439/1005] PCI: vmd: Add Nova Lake (NVL) and Dunlow (DNL) D=
evice IDs
> * [PATCH 6.18 0440/1005] virtio_ring: fix infinite loop in virtnet_poll_c=
leantx when device is broken
> * [PATCH 6.18 0441/1005] ASoC: rt712-sdca: Pull high JD2 to prevent from =
entering TV mode
> * [PATCH 6.18 0442/1005] rtc: ds1307: fix RX8130 wakeup alarm WADA bit fo=
r day-of-month mode
> * [PATCH 6.18 0443/1005] rtc: brcmstb-waketimer: add missing MODULE_DEVIC=
E_TABLE()
> * [PATCH 6.18 0444/1005] spi: loongson: pm: add .freeze .poweroff .thaw .=
restore
> * [PATCH 6.18 0445/1005] i2c: imx-lpi2c: properly unwind resources on pro=
be failure
> * [PATCH 6.18 0446/1005] fbdev: maxine: fix 64-bit build error
> * [PATCH 6.18 0447/1005] fbdev: platinumfb: add error checking for iorema=
p calls
> * [PATCH 6.18 0448/1005] ksmbd: enable TCP keepalive for accepted connect=
ions
> * [PATCH 6.18 0449/1005] sched_ext/scx_flatcg: expire cached hweights on =
weight changes
> * [PATCH 6.18 0450/1005] ACPI: button: Add DMI quirk for Razer Blade Pro =
17 early 2020 lid switch
> * [PATCH 6.18 0451/1005] f2fs: avoid setting SBI_NEED_FSCK on transient r=
esize failure
> * [PATCH 6.18 0452/1005] ALSA: hda/realtek: Fix ALC700 audio on Intel Had=
es Canyon
> * [PATCH 6.18 0453/1005] ALSA: usb-audio: Add iD14 MkI to monitor-mix vol=
ume quirk
> * [PATCH 6.18 0454/1005] scsi: snic: Fix SCSI host leak on workqueue allo=
cation failure
> * [PATCH 6.18 0455/1005] docs: block: fix dead http link in blk-mq.rst
> * [PATCH 6.18 0456/1005] net: ethernet: mtk_wed: increase WED v2 WDMA RES=
V_BUFF to 0x80
> * [PATCH 6.18 0457/1005] fbcon: Fix KASAN slab-out-of-bounds Read in fbco=
n_prepare_logo
> * [PATCH 6.18 0458/1005] powercap: intel_rapl: Fix kernel panic during PM=
U unbind
> * [PATCH 6.18 0459/1005] net: stmmac: fix device node reference leaks in =
stmmac_mtl_setup()
> * [PATCH 6.18 0460/1005] ALSA: hda/realtek: Add quirk for Lenovo IdeaPad =
Slim 3 15ABR8
> * [PATCH 6.18 0461/1005] fuse: zero the partial EOF page when extending a=
 file
> * [PATCH 6.18 0462/1005] ASoC: amd: yc: Add DMI entry for Alienware m18 R=
1 AMD
> * [PATCH 6.18 0463/1005] HID: i2c-hid: Add a quirk for a Cirque I2C devic=
e.
> * [PATCH 6.18 0464/1005] HID: multitouch: Fix stale MT slots when contact=
 count drops to zero
> * [PATCH 6.18 0465/1005] tpm: tpm_tis_spi: fix nodef CR50 tpm_tis_spi_res=
ume is null
> * [PATCH 6.18 0466/1005] tpm: atmel: depend on X86
> * [PATCH 6.18 0467/1005] ALSA: usb-audio: Skip mixer creation on M-Audio =
Venom
> * [PATCH 6.18 0468/1005] ASoC: amd: acp3x-es83xx: Add HVY-WXX9/M1060 DMI =
quirk
> * [PATCH 6.18 0469/1005] ceph: do not cache negative dentries for snapped=
 directories
> * [PATCH 6.18 0470/1005] ALSA: hda/conexant: Always enable the headset-mi=
c pin on plugin
> * [PATCH 6.18 0471/1005] ASoC: amd: acp-config: Add HVY-WXX9/M1060 DMI qu=
irk
> * [PATCH 6.18 0472/1005] ceph: fix use-after-dereference of NULL ci in __=
ceph_remove_cap()
> * [PATCH 6.18 0473/1005] netfilter: tproxy: use DEBUG_NET_WARN_ON_ONCE fo=
r protocol fallbacks
> * [PATCH 6.18 0474/1005] ksmbd: handle allocated range queries on dense f=
iles
> * [PATCH 6.18 0475/1005] regmap: irq: Free the irqdomain we create
> * [PATCH 6.18 0476/1005] HID: i2c-hid: Add i2c-hid-quirk-bad-input-size q=
uirk for 0911:5288 device
> * [PATCH 6.18 0477/1005] HID: i2c-hid: add reset quirk for Lenovo Yoga Sl=
im 7x Gen 11 keyboard
> * [PATCH 6.18 0478/1005] HID: elecom: Add support for ELECOM M-XT4DRBK (0=
18E)
> * [PATCH 6.18 0479/1005] nvme-fc: do not warn on controller removal race
> * [PATCH 6.18 0480/1005] HID: roccat: fix locking in roccat_connect() and=
 roccat_disconnect()
> * [PATCH 6.18 0481/1005] scsi: devinfo: Add BLIST_SKIP_IO_HINTS for EMC S=
ymmetrix
> * [PATCH 6.18 0482/1005] ASoC: amd: yc: Add Lenovo ThinkPad E16 Gen 2 (21=
JN) to quirks
> * [PATCH 6.18 0483/1005] gpio: mvebu: keep resume masks within the irqchi=
p cache
> * [PATCH 6.18 0484/1005] sfc: add X4D PF support
> * [PATCH 6.18 0485/1005] ASoC: amd: yc: Add DMI quirk for Lenovo V15 G6 A=
RP
> * [PATCH 6.18 0486/1005] HID: universal-pidff: Add support for Turtle Bea=
ch VelocityOne Race
> * [PATCH 6.18 0487/1005] HID: Intel-thc-hid: Intel-quickspi: Fix buffer o=
verflow
> * [PATCH 6.18 0488/1005] HID: Intel-thc-hid: Intel-quicki2c: Fix buffer o=
verflow
> * [PATCH 6.18 0489/1005] ASoC: Intel: bytcr_rt5651: Add quirk for Chuwi H=
i8 with generic DMI strings
> * [PATCH 6.18 0490/1005] nvme-tcp: delay nvme_tcp_reclassify_socket()
> * [PATCH 6.18 0491/1005] docs: update the unmount propagation rule
> * [PATCH 6.18 0492/1005] ALSA: hda/realtek: Limit internal mic boost on H=
P Pavilion 15 (103c:2164)
> * [PATCH 6.18 0493/1005] ALSA: usb-audio: Add mixer mapping for MSI MAG B=
850M MORTAR WIFI
> * [PATCH 6.18 0494/1005] ALSA: hda/realtek: Add quirk for Lenovo ThinkBoo=
k 16p Gen 3 ARH (21EK)
> * [PATCH 6.18 0495/1005] ALSA: hda/realtek: Add quirk for Lenovo ThinkBoo=
k G8+
> * [PATCH 6.18 0496/1005] ALSA: hda/realtek: Add mute LED quirk for HP Pav=
ilion 15-ec1xxx
> * [PATCH 6.18 0497/1005] ALSA: hda/realtek: Add quirk for HP ENVY 13-aq1x=
xx
> * [PATCH 6.18 0498/1005] ALSA: hda/realtek: Add mute LED quirk for HP Vic=
tus 15-fb2xxx
> * [PATCH 6.18 0499/1005] ALSA: hda/realtek: Add quirk for Acer Nitro AN51=
5-45
> * [PATCH 6.18 0500/1005] ALSA: hda/realtek: Fix speakers on ASUS PM3406CH=
A
> * [PATCH 6.18 0501/1005] ALSA: hda/realtek: Add mute LED quirk for HP Pav=
ilion 14-dv1001TU
> * [PATCH 6.18 0502/1005] usb: mtu3: Fix double dereference in TP_printk
> * [PATCH 6.18 0503/1005] net: usb: qmi_wwan: add Rolling Wireless RN947R
> * [PATCH 6.18 0504/1005] ALSA: hda/realtek: Add quirk for ASRock NUC BOX-=
358H
> * [PATCH 6.18 0505/1005] ALSA: hda/realtek: Add ALC235 support for headse=
t mode
> * [PATCH 6.18 0506/1005] spi: cadence-qspi: Fix status polling with octal=
 DTR chips
> * [PATCH 6.18 0507/1005] ALSA: hda/realtek: Add mute LED quirk for HP Pav=
ilion 15-eg3xxx (103c:8bfd)
> * [PATCH 6.18 0508/1005] ALSA: usb-audio: Add native DSD support for Camb=
ridge Audio streamers
> * [PATCH 6.18 0509/1005] drm/amdgpu/gfx12: set KMD_QUEUE for kernel gfx q=
ueues
> * [PATCH 6.18 0510/1005] drm/amdgpu/gfx11: set KMD_QUEUE for kernel gfx q=
ueues
> * [PATCH 6.18 0511/1005] RISC-V: errata: Add SiFive MAL-9092 workaround
> * [PATCH 6.18 0512/1005] regmap: Remove debugfs before cache teardown
> * [PATCH 6.18 0513/1005] nbcon/reboot: Switch NBCON consoles into the eme=
rgency mode in emergency_restart()
> * [PATCH 6.18 0514/1005] Revert "namei: dont reveal overmounted entries i=
n refwalk"
> * [PATCH 6.18 0515/1005] media: em28xx: use video_unregister_device for r=
adio_dev
> * [PATCH 6.18 0516/1005] ARM: 9524/1: mm: align hugetlb mappings to the h=
uge page size
> * [PATCH 6.18 0517/1005] blk-crypto: fix NULL deref and UAF in __blk_cryp=
to_evict_key()
> * [PATCH 6.18 0518/1005] ceph: fail readdir when the MDS reply carries no=
 dirfrag
> * [PATCH 6.18 0519/1005] fuse: dont BUG when the copy buffer is exhausted
> * [PATCH 6.18 0520/1005] kcov: ignore an out-of-range comparison count in=
 write_comp_data()
> * [PATCH 6.18 0521/1005] kcsan: Avoid division by zero in kcsan_prandom_u=
32_max()
> * [PATCH 6.18 0522/1005] libceph: bound mon_command ack decode to front l=
en
> * [PATCH 6.18 0523/1005] media: cx88: Disable PCI device on MPEG initiali=
zation failure
> * [PATCH 6.18 0524/1005] media: em28xx: reject audio endpoint with zero p=
acket size
> * [PATCH 6.18 0525/1005] media: go7007: only set audio_enabled if go7007_=
snd_init() succeeded
> * [PATCH 6.18 0526/1005] net: ipv4: add zero check for snd_cwnd_clamp
> * [PATCH 6.18 0527/1005] net: usb: pegasus: do not advance rx_skb->data o=
n dropped frames
> * [PATCH 6.18 0528/1005] nfsd: fix race between client_info_show() and fr=
ee_client()
> * [PATCH 6.18 0529/1005] ocfs2/dlm: drain join handlers before releasing =
module text
> * [PATCH 6.18 0530/1005] ocfs2: drain quorum work before removing the clu=
ster
> * [PATCH 6.18 0531/1005] ocfs2: pin owning modules for open debugfs files
> * [PATCH 6.18 0532/1005] ocfs2: publish the filecheck owner before adding=
 sysfs attributes
> * [PATCH 6.18 0533/1005] thunderbolt: Do not RPM complete unrelated subtr=
ees on unplug
> * [PATCH 6.18 0534/1005] udf: fix return value for non-recorded-allocated=
 extents in udf_map_block()
> * [PATCH 6.18 0535/1005] wwan: wwan_hwsim: Pin module for debugfs file op=
erations
> * [PATCH 6.18 0536/1005] xfs: fix integer overflow problem when setting l=
arge free areas
> * [PATCH 6.18 0537/1005] netfilter: nf_conntrack_expect: use conntrack GC=
 to reap expectations
> * [PATCH 6.18 0538/1005] netfilter: nf_conntrack_expect: add and use nf_c=
t_expect_related_pair()
> * [PATCH 6.18 0539/1005] netfilter: ctnetlink: do not expose expectation =
DEAD flag
> * [PATCH 6.18 0540/1005] sctp: auth: discard auth_chunk when skb_clone fa=
ils
> * [PATCH 6.18 0541/1005] dt-bindings: interrupt-controller: gicv5: Relax =
IRS properties constraints
> * [PATCH 6.18 0542/1005] irqchip/gic-v5: Fix standalone IRSes OF probe
> * [PATCH 6.18 0543/1005] drm/xe/display: skip FORCE_WC and vm_bound check=
 for external dma-bufs
> * [PATCH 6.18 0544/1005] KVM: x86: Always initialize EFER reserved bits o=
n vendor initialization
> * [PATCH 6.18 0545/1005] mm/migrate: use huge_ptep_get() in remove_migrat=
ion_pte()
> * [PATCH 6.18 0546/1005] HID: input: read battery capacity from its actua=
l report offset
> * [PATCH 6.18 0547/1005] mm/page_alloc: dont spin_trylock() when disallow=
ed in free_one_page()
> * [PATCH 6.18 0548/1005] i3c: master: Fix potential UAF in i3c_device_uev=
ent()
> * [PATCH 6.18 0549/1005] LoongArch: KVM: Check kvm_request_pending() in k=
vm_late_check_requests()
> * [PATCH 6.18 0550/1005] LoongArch: KVM: Deliver interrupt after IN_GUEST=
_MODE is set
> * [PATCH 6.18 0551/1005] LoongArch: KVM: Set vcpu->cpu before IN_GUEST_MO=
DE is set
> * [PATCH 6.18 0552/1005] rust: bug: fix warn_on macro build error on UML
> * [PATCH 6.18 0553/1005] nfsd: dedup nfs4_client_to_reclaim inserts
> * [PATCH 6.18 0554/1005] nfsd: use test_and_clear_bit for somebody_reclai=
med to prevent lost update
> * [PATCH 6.18 0555/1005] LoongArch: Expand module virtual address space t=
o 2GB
> * [PATCH 6.18 0556/1005] rust: cfi: disable function merging if CFI is en=
abled
> * [PATCH 6.18 0557/1005] mm/kmemleak: stop the task stack scan early when=
 interrupted
> * [PATCH 6.18 0558/1005] mm/kmemleak: report RCU-tasks quiescent states d=
uring the scan
> * [PATCH 6.18 0559/1005] mm/migrate_device: clear stale mapping after fre=
eing swapcache
> * [PATCH 6.18 0560/1005] smb: client: reject SetEA requests that do not f=
it the request buffer
> * [PATCH 6.18 0561/1005] riscv: hwprobe: initialize pair->value in hwprob=
e_one_pair()
> * [PATCH 6.18 0562/1005] ipv6: udp: Create exceptions before socket match=
ing
> * [PATCH 6.18 0563/1005] thunderbolt: Make the DP tunnel activation callb=
ack mandatory
> * [PATCH 6.18 0564/1005] drm/amd/display: DML2.1 Reintegration
> * [PATCH 6.18 0565/1005] drm/amd/display: Update P-state naming for clari=
ty.
> * [PATCH 6.18 0566/1005] drm/amd/display: add const qualifiers to waterma=
rk params struct
> * [PATCH 6.18 0567/1005] drm/amd/display: Remove const Qualifier From Non=
-Pointer Fields
> * [PATCH 6.18 0568/1005] LoongArch: KVM: Add unregister helpers for the K=
VM interrupt devices
> * [PATCH 6.18 0569/1005] LoongArch: KVM: Fix resource leak in kvm_loongar=
ch_env_init() error path
> * [PATCH 6.18 0570/1005] s390/crypto: Replace cond_resched() with msleep(=
1)
> * [PATCH 6.18 0571/1005] s390/crypto: Fix return code handling at skciphe=
r_walk_done in PAES algorithms
> * [PATCH 6.18 0572/1005] s390/crypto: Fix use of mutex in atomic context =
in PAES
> * [PATCH 6.18 0573/1005] s390/crypto: Fix handling of EBUSY in PAES when =
req is pushed to crypto engine
> * [PATCH 6.18 0574/1005] MIPS: Fix HOTPLUG_PARALLEL dependency
> * [PATCH 6.18 0575/1005] mips: select CONFIG_WEAK_REORDERING_BEYOND_LLSC =
from CONFIG_EYEQ
> * [PATCH 6.18 0576/1005] smb: client: fix uid/gid override in getattr wit=
h posix extensions
> * [PATCH 6.18 0577/1005] smb: client: fix WSL reparse point uid/gid overr=
ide
> * [PATCH 6.18 0578/1005] hwmon: (asus_rog_ryujin) Rely on subsystem locki=
ng
> * [PATCH 6.18 0579/1005] hwmon: (asus_rog_ryujin) Add per-device configur=
ation
> * [PATCH 6.18 0580/1005] hwmon: (asus_rog_ryujin) Validate HID report len=
gths
> * [PATCH 6.18 0581/1005] hwmon: (asus_rog_ryujin) Synchronize HID command=
 and report handling
> * [PATCH 6.18 0582/1005] drm/amd/pm: fix gpu metrics energy accumulator f=
or smu 13.0.0/13.0.7
> * [PATCH 6.18 0583/1005] selftests/ublk: fix Makefile to rebuild on heade=
r changes
> * [PATCH 6.18 0584/1005] selftests: ublk: add utility to get block device=
 metadata size
> * [PATCH 6.18 0585/1005] selftests: ublk: increase timeout to 150 seconds
> * [PATCH 6.18 0586/1005] selftests: ublk: install test_common.sh and trac=
e/ scripts
> * [PATCH 6.18 0587/1005] smb: client: fix fattr leaking on wsl_to_fattr()=
 failure
> * [PATCH 6.18 0588/1005] RISC-V: KVM: Release unused page after MMU inval=
idation
> * [PATCH 6.18 0589/1005] RISC-V: KVM: Fix sdata leak and stale snapshot_a=
ddr in snapshot_set_shmem
> * [PATCH 6.18 0590/1005] xfs: dont cross reference rmapbt with bitmaps if=
 theyre incomplete
> * [PATCH 6.18 0591/1005] drm/amdkfd: Guard m->cp_hqd_eop_control setting =
by q->eop_ring_buffer_size
> * [PATCH 6.18 0592/1005] drm/amdkfd: Avoid integer underflow with ffs in =
EOP ring size calc
> * [PATCH 6.18 0593/1005] drm/amdkfd: Avoid integer underflow in EOP ring =
size calculation.
> * [PATCH 6.18 0594/1005] smb: client: delete compound mids on send failur=
e before unlock
> * [PATCH 6.18 0595/1005] KVM: x86: Fill kvm_run exit fields in common get=
_nested_state_pages() error paths
> * [PATCH 6.18 0596/1005] serial: serial_core: simplify uart_ioctl() retur=
ns
> * [PATCH 6.18 0597/1005] serial: fix ioctl hangup race
> * [PATCH 6.18 0598/1005] serial: abort TIOCMIWAIT on hangup
> * [PATCH 6.18 0599/1005] net/sched: act_ct: remove add_helper dead code
> * [PATCH 6.18 0600/1005] KVM: SVM: Preserve TLB control (i.e. pending TLB=
 flush) on failed VMRUN
> * [PATCH 6.18 0601/1005] KVM: SVM: Update control fields on #VMEXIT if an=
d only if VMRUN succeeded
> * [PATCH 6.18 0602/1005] ALSA: hda/realtek: add quirk for Acer Nitro ANV1=
5-51
> * [PATCH 6.18 0603/1005] ALSA: hda/realtek: Add micmute LED quirk for Ace=
r Swift SFG16-72
> * [PATCH 6.18 0604/1005] smb: client: clear post-EOF pagecache when exten=
ding a file via truncate
> * [PATCH 6.18 0605/1005] smb: client: discard post-EOF pagecache when ext=
ending a file via clone range
> * [PATCH 6.18 0606/1005] smb: client: drain and invalidate before server-=
side copy/clone
> * [PATCH 6.18 0607/1005] smb: client: only require read lease for size-ex=
tending zero range
> * [PATCH 6.18 0608/1005] smb: client: require stable pages for signed con=
nections
> * [PATCH 6.18 0609/1005] tools/power turbostat: Read complete CPU lists
> * [PATCH 6.18 0610/1005] drm/amd/display: Fix fast updates on DCE 6.x
> * [PATCH 6.18 0611/1005] drm/amdgpu: remove gart_window_lock usage from g=
mc v12
> * [PATCH 6.18 0612/1005] drm/amdgpu/gmc12: properly pass flush_type to gm=
c_v12_0_flush_vm_hub()
> * [PATCH 6.18 0613/1005] drm/amd/display: guard dc_sink dereferences in M=
ST mode validation
> * [PATCH 6.18 0614/1005] accel/rocket: search every core slot when lookin=
g up a scheduler
> * [PATCH 6.18 0615/1005] ipc: create_ipc_ns: drop mqueue mount on sysctl =
setup failure
> * [PATCH 6.18 0616/1005] ipc: drop the mqueue mount with kern_unmount() o=
n setup failure
> * [PATCH 6.18 0617/1005] ntfs3: free replaced mount options after a grace=
 period
> * [PATCH 6.18 0618/1005] tracing: Fix fully-qualified variable reference =
printing in histograms
> * [PATCH 6.18 0619/1005] tracing: Use __free() for expr_str() buffer
> * [PATCH 6.18 0620/1005] tracing: Return ERR_PTR() from expr_str()
> * [PATCH 6.18 0621/1005] tracing: Bound histogram expression strings with=
 seq_buf
> * [PATCH 6.18 0622/1005] tracing: Fix NULL dereference when copying keys =
for a field variable
> * [PATCH 6.18 0623/1005] drm/amdgpu/uvd3.1: Fix checking whether UVD firm=
ware keyselect was already set
> * [PATCH 6.18 0624/1005] RISC-V: KVM: Fix double-free of sdata in kvm_pmu=
_clear_snapshot_area()
> * [PATCH 6.18 0625/1005] serial: core: fix TIOCSSERIAL and TIOCSERCONFIG =
on uninitialised ports
> * [PATCH 6.18 0626/1005] net/sched: cls_bpf: accept dev-bound programs on=
 shared blocks
> * [PATCH 6.18 0627/1005] net/sched: cls_flower: avoid stale mask referenc=
es after delete
> * [PATCH 6.18 0628/1005] net/sched: sch_teql: fix slaves_lock IRQ deadloc=
k
> * [PATCH 6.18 0629/1005] net/sched: sch_teql: fix use-after-free on lower=
 qdisc drop
> * [PATCH 6.18 0630/1005] net/sched: fix packet reordering on requeue
> * [PATCH 6.18 0631/1005] net/sched: act_ife: do not consume the inner hea=
der on egress
> * [PATCH 6.18 0632/1005] driver core: take parent lock on deferred probe
> * [PATCH 6.18 0633/1005] driver core: Limit the messages on a refused uev=
ent
> * [PATCH 6.18 0634/1005] driver core: fix parent lock use-after-free on U=
SB disconnect
> * [PATCH 6.18 0635/1005] Drivers: hv: vmbus: Bounds check the shared ring=
 buffer indices
> * [PATCH 6.18 0636/1005] backlight: lm3630a: Cancel delayed work before d=
estroying workqueue
> * [PATCH 6.18 0637/1005] backlight: qcom-wled: Fix NULL pointer dereferen=
ce in wled_remove()
> * [PATCH 6.18 0638/1005] backlight: qcom-wled: Fix unbalanced OVP IRQ ena=
ble at probe
> * [PATCH 6.18 0639/1005] backlight: qcom-wled: Fix WLED3 brightness regis=
ter stride
> * [PATCH 6.18 0640/1005] ksmbd: accept share config responses from ksmbd-=
tools before 3.5.3
> * [PATCH 6.18 0641/1005] ksmbd: avoid restoring only in-memory EOF after =
allocation change
> * [PATCH 6.18 0642/1005] ksmbd: fix extended session security negotiation=
 for raw NTLMSSP
> * [PATCH 6.18 0643/1005] ksmbd: fix OOB read and cross-share confusion in=
 ksmbd_validate_name_reconnect()
> * [PATCH 6.18 0644/1005] ksmbd: fix overflow in dacloffset bounds check i=
n build_sec_desc()
> * [PATCH 6.18 0645/1005] ksmbd: fix parent dentry lifetime in directory e=
numeration
> * [PATCH 6.18 0646/1005] ksmbd: ignore network devices of other namespace=
s
> * [PATCH 6.18 0647/1005] ksmbd: preserve unreadable named streams on open
> * [PATCH 6.18 0648/1005] ksmbd: reserve space for the UTF-16 terminator i=
n stream info
> * [PATCH 6.18 0649/1005] ksmbd: return end of file for reads past a named=
 streams data
> * [PATCH 6.18 0650/1005] ksmbd: use u8 for SMB2 oplock level values
> * [PATCH 6.18 0651/1005] ksmbd: validate security descriptor offsets befo=
re pointer arithmetic
> * [PATCH 6.18 0652/1005] tcp: Fix potential UAF in reqsk_timer_handler().
> * [PATCH 6.18 0653/1005] vlan: restore HW VLAN tag insertion with reorder=
_hdr off
> * [PATCH 6.18 0654/1005] cgroup: serialize migrations of newly forked pro=
cesses
> * [PATCH 6.18 0655/1005] Revert "Bluetooth: btusb: Add ASUS USB-BT600 for=
 Realtek 8761CU"
> * [PATCH 6.18 0656/1005] Revert "Bluetooth: btusb: Add ASUS USB-BT540 for=
 Realtek 8761CU"
> * [PATCH 6.18 0657/1005] KVM: x86/mmu: pass PFERR_GUEST_PAGE/FINAL_MASK t=
o kvm_translate_gpa
> * [PATCH 6.18 0658/1005] KVM: x86: Tell ->inject_page_fault() whether or =
a fault came from hardware
> * [PATCH 6.18 0659/1005] KVM: VMX: Synthesize nested EPT violation GVA_IS=
_VALID/GVA_TRANSLATED bits
> * [PATCH 6.18 0660/1005] x86/ioperm: Prevent NULL dereference on theoreti=
cal missing IO bitmap
> * [PATCH 6.18 0661/1005] wifi: b43: fix use-after-free in b43_bcma_remove=
()
> * [PATCH 6.18 0662/1005] SUNRPC: fix netns use-after-free in write_gssp()
> * [PATCH 6.18 0663/1005] spmi: Fix potential use-after-free by grabbing o=
f_node reference
> * [PATCH 6.18 0664/1005] smb: client: fix use-after-free infoleak via the=
 readdir resume name
> * [PATCH 6.18 0665/1005] smb: client: fix use-after-free in cifs_ses_add_=
channel()
> * [PATCH 6.18 0666/1005] RDMA/irdma: avoid use-after-free in icrdma_remov=
e
> * [PATCH 6.18 0667/1005] rapidio: mport_cdev: fix use-after-free in mport=
_mm_close()
> * [PATCH 6.18 0668/1005] platform/x86/amd: hfi: Fix a use-after-free when=
 unloading the driver
> * [PATCH 6.18 0669/1005] nvmet: fix use-after-free of the old registrant =
in nvmet_pr_preempt()
> * [PATCH 6.18 0670/1005] nvmet-fc: fix use-after-free in nvmet_fc_ls_crea=
te_connection()
> * [PATCH 6.18 0671/1005] iommufd: Fix event queue release use-after-free
> * [PATCH 6.18 0672/1005] landlock: Fix superblock use-after-free in relea=
se_inode()
> * [PATCH 6.18 0673/1005] lockd: Fix use-after-free in nlmsvc_retry_blocke=
d
> * [PATCH 6.18 0674/1005] media: au0828: fix use-after-free in bulk_timeou=
t timer on disconnect
> * [PATCH 6.18 0675/1005] media: cx23885: Fix use-after-free in cx23885_fi=
nidev due to race condition
> * [PATCH 6.18 0676/1005] media: hackrf: fix use-after-free in hackrf_allo=
c_urbs() error path
> * [PATCH 6.18 0677/1005] media: imon: fix use-after-free in display_close=
 via dev_dbg
> * [PATCH 6.18 0678/1005] mm/hugetlb: fix use-after-free in hugetlb_mfill_=
atomic_pte()
> * [PATCH 6.18 0679/1005] mm/hugetlb: fix use-after-free of a new anon fol=
io
> * [PATCH 6.18 0680/1005] apparmor: fix a use-after-free in aa_lookupn_ns(=
)
> * [PATCH 6.18 0681/1005] ASoC: audio-graph-card2: Fix use-after-free in a=
udio_graph2_link_c2c()
> * [PATCH 6.18 0682/1005] ata: sata_fsl: Fix use-after-free of host_priv o=
n probe() failure
> * [PATCH 6.18 0683/1005] drm/msm: Fix vm_bo use-after-free in with_vm_loc=
ks()
> * [PATCH 6.18 0684/1005] s390/cpum_cf: Check session mask before cpu offl=
ine
> * [PATCH 6.18 0685/1005] s390/extable: Fix mvcos instruction decoding
> * [PATCH 6.18 0686/1005] s390/kprobes: Prevent kprobes on instructions wi=
th exception table entry
> * [PATCH 6.18 0687/1005] s390/probes: Fix wrong opcode for cgrb fixup
> * [PATCH 6.18 0688/1005] s390/signal: Fix incorrect return address in sig=
nal frame
> * [PATCH 6.18 0689/1005] s390/zcrypt: Fix out-of-bounds ptr advance in cc=
a_query_crypto_facility()
> * [PATCH 6.18 0690/1005] HID: wacom: Use hdev->product in wacom_setup_tou=
ch_input_capabilities
> * [PATCH 6.18 0691/1005] HID: wacom: Advertise SW_MUTE_DEVICE capability =
prior to registration
> * [PATCH 6.18 0692/1005] HID: wacom: Fix Use-After-Free in wacom_intuos_p=
ad
> * [PATCH 6.18 0693/1005] HID: wacom: Fix Use-After-Free in wacom_bamboo_p=
ad
> * [PATCH 6.18 0694/1005] HID: wacom: Redesign shared sibling data lifecyc=
le
> * [PATCH 6.18 0695/1005] HID: wacom: Setup SW_MUTE_DEVICE according to th=
e order of input registration
> * [PATCH 6.18 0696/1005] HID: wacom: Write shared touch initial status on=
ly once
> * [PATCH 6.18 0697/1005] klist: avoid accesses after waking klist_remove(=
)
> * [PATCH 6.18 0698/1005] objtool/rust: add one more `noreturn` Rust funct=
ion for Rust 1.101.0
> * [PATCH 6.18 0699/1005] rust: bitmap: restrict bitmap length to at most =
i32::MAX
> * [PATCH 6.18 0700/1005] rust: block: fix `Send` bound for `GenDisk`
> * [PATCH 6.18 0701/1005] rust: block: require `Sync` for `Operations::Que=
ueData`
> * [PATCH 6.18 0702/1005] rust: configfs: fix data offset calculation for =
subsystem callbacks
> * [PATCH 6.18 0703/1005] rust: cpufreq: reject NULL from cpufreq_cpu_get(=
)
> * [PATCH 6.18 0704/1005] rust: rcpufreq_dt: add module alias
> * [PATCH 6.18 0705/1005] ALSA: control: Fix UAF in snd_ctl_elem_add() on =
card disconnect
> * [PATCH 6.18 0706/1005] ALSA: emux: Fix UAF of soundfont zones at note-o=
n
> * [PATCH 6.18 0707/1005] ALSA: pcmtest: handle multiple wraps in random c=
apture fill
> * [PATCH 6.18 0708/1005] ASoC: amd: ps: fix snd_acp63_remove() teardown o=
rdering
> * [PATCH 6.18 0709/1005] Bluetooth: hci_vhci: Pin module for debugfs file=
 operations
> * [PATCH 6.18 0710/1005] drm/panthor: Fix TOCTOU race between GROUP_REGIS=
TERED check and erase
> * [PATCH 6.18 0711/1005] fbdev: atmel_lcdfb: Prevent FIFO work after remo=
val
> * [PATCH 6.18 0712/1005] fbdev: udlfb: dont rebuild the mode list while t=
he framebuffer is in use
> * [PATCH 6.18 0713/1005] fs/proc/task_mmu: pin mm_users in do_pagemap_sca=
n()
> * [PATCH 6.18 0714/1005] genirq: Defer kfree(irqaction) until irq_thread_=
dtor() finishes
> * [PATCH 6.18 0715/1005] genirq: Move interrupt thread exit_work object t=
o irqaction
> * [PATCH 6.18 0716/1005] HID: hiddev: keep state alive through disconnect=
 unlock
> * [PATCH 6.18 0717/1005] io_uring/io-wq: save worker type before dropping=
 its reference
> * [PATCH 6.18 0718/1005] iomap: dont resubmit an ioend after ->writeback_=
submit() failed
> * [PATCH 6.18 0719/1005] iommu/arm-smmu-v3: Disable the impl before disab=
ling the SMMU on shutdown
> * [PATCH 6.18 0720/1005] KVM: PPC: Book3S HV: Add SRCU protection for vir=
tual-mode HPT hcalls
> * [PATCH 6.18 0721/1005] media: cx23885: unregister DVB bus when SP2 CI s=
etup fails
> * [PATCH 6.18 0722/1005] media: gspca: use vb2_video_unregister_device() =
on disconnect
> * [PATCH 6.18 0723/1005] media: imx-jpeg: cancel timeout worker when stre=
aming stops
> * [PATCH 6.18 0724/1005] media: marvell: mcam: stop DMA and cancel s_bh_w=
ork before freeing DMA buffers
> * [PATCH 6.18 0725/1005] media: microchip-csi2dc: fix async notifier leak=
 on probe error path
> * [PATCH 6.18 0726/1005] media: microchip-isc: take a reference on the pa=
rsed endpoints
> * [PATCH 6.18 0727/1005] media: redrat3: fix UAF in probe error path leav=
ing rc device registered
> * [PATCH 6.18 0728/1005] media: s5p-mfc: use timer_shutdown_sync() for th=
e self-rearming watchdog
> * [PATCH 6.18 0729/1005] mm/slab: sample slab_state once in kmem_cache_de=
stroy()
> * [PATCH 6.18 0730/1005] mm: khugepaged: fix folio is used after folio_pu=
t/unlock()
> * [PATCH 6.18 0731/1005] scsi: dc395x: sync the waiting_timer before free=
ing the host
> * [PATCH 6.18 0732/1005] serial: core: shut down initialized port on remo=
val
> * [PATCH 6.18 0733/1005] xen-blkfront: unbind irq before tearing down rin=
g and shadow requests
> * [PATCH 6.18 0734/1005] wifi: ath9k: delete channel-context timers on de=
init
> * [PATCH 6.18 0735/1005] wifi: mt76: mt7996: unlink TWT flow if the MCU r=
ejects the agreement
> * [PATCH 6.18 0736/1005] usb: gadget: fix refcount underflow in gadgetfs_=
bind() error path
> * [PATCH 6.18 0737/1005] ufs: use u64 for directory size in ufs_last_byte
> * [PATCH 6.18 0738/1005] spi: spi-pci1xxxx: quiesce DMA engines on transf=
er timeout
> * [PATCH 6.18 0739/1005] resource: report a devm_request_resource() confl=
ict under the lock
> * [PATCH 6.18 0740/1005] phy: core: Fix race-condition between _of_phy_ge=
t() and try_module_get()
> * [PATCH 6.18 0741/1005] power: supply: sbs-battery: disable polling befo=
re supply teardown
> * [PATCH 6.18 0742/1005] nvmem: core: Fix OOB read for bit offsets of mor=
e than one byte
> * [PATCH 6.18 0743/1005] media: rc: Ensure that rc_unregister_device() do=
es not free input device
> * [PATCH 6.18 0744/1005] media: rc: Ensure registered is cleared in error=
 path
> * [PATCH 6.18 0745/1005] media: rc: fintek-cir: process a full RX buffer =
instead of overflowing it
> * [PATCH 6.18 0746/1005] media: rc: Fix race between bpf(BPG_PROG_ATTACH)=
 and device unregister
> * [PATCH 6.18 0747/1005] media: rc: mce_kbd: Fix inconsistent locking of =
keylock
> * [PATCH 6.18 0748/1005] media: rc: Use after free in ir_raw_event_handle=
()
> * [PATCH 6.18 0749/1005] media: rc: After rc_unregister_device() timers c=
an be re-armed
> * [PATCH 6.18 0750/1005] media: rc: Fix use after free in bpf progs
> * [PATCH 6.18 0751/1005] media: rc: Fix ABBA deadlock by making locks mor=
e fine grained
> * [PATCH 6.18 0752/1005] ocfs2/heartbeat: unlink live slots when their no=
de is missing
> * [PATCH 6.18 0753/1005] ocfs2/dlm: hold a lock reference across grant AS=
T enqueue
> * [PATCH 6.18 0754/1005] ocfs2/dlm: hold the lookup reference across conv=
ert AST enqueue
> * [PATCH 6.18 0755/1005] ocfs2: cancel quota sync work before freeing quo=
ta info
> * [PATCH 6.18 0756/1005] ocfs2: fix chunk number of the first chunk in a =
local quota file
> * [PATCH 6.18 0757/1005] ocfs2: pin refcount trees before dropping the lo=
okup lock
> * [PATCH 6.18 0758/1005] ocfs2: snapshot dentry names in file and setattr=
 traces
> * [PATCH 6.18 0759/1005] smb: client: fix OOB last_entry pointer from unb=
ounded LastNameOffset
> * [PATCH 6.18 0760/1005] smb: client: stop processing a read response aft=
er a receive error
> * [PATCH 6.18 0761/1005] ovl: set OVL_WHITEOUTS before publishing the upp=
er dir
> * [PATCH 6.18 0762/1005] ovl: take a snapshot of the name for copy up
> * [PATCH 6.18 0763/1005] ovl: use the pinned upper dir in ovl_fix_origin(=
)
> * [PATCH 6.18 0764/1005] ovl: always encode the origin fh when index is e=
nabled
> * [PATCH 6.18 0765/1005] ovl: check the casefold flag of directories only
> * [PATCH 6.18 0766/1005] ovl: do not copy up an xattr value that was neve=
r read
> * [PATCH 6.18 0767/1005] ovl: fix a torn path in ovl_get_redirect()
> * [PATCH 6.18 0768/1005] ovl: fortify ovl_copy_xattr() against underlying=
 layer modifications
> * [PATCH 6.18 0769/1005] ovl: read the nlink xattr of every indexed non-d=
ir
> * [PATCH 6.18 0770/1005] ovl: reserve space for the casefolded name termi=
nator
> * [PATCH 6.18 0771/1005] ovl: set the revalidate flags after d_instantiat=
e()
> * [PATCH 6.18 0772/1005] ovl: skip copy up of empty security.capability
> * [PATCH 6.18 0773/1005] xfs: clear the symlink zapped flag if inline sym=
link is ok
> * [PATCH 6.18 0774/1005] xfs: mark cow extents bad if theres no rmap mapp=
ing for them
> * [PATCH 6.18 0775/1005] xfs: compute the correct fdblocks/frextents for =
repair when theyre negative
> * [PATCH 6.18 0776/1005] xfs: fix ondisk symlink target validation in xre=
p_dinode_check_dfork
> * [PATCH 6.18 0777/1005] xfs: fix xfs_rename_space_res for non-pptr files=
ystems
> * [PATCH 6.18 0778/1005] xfs: fix missing xfs_qm_adjust_dqlimits call in =
quotacheck repair
> * [PATCH 6.18 0779/1005] xfs: fix buffer overruns in xfs_ioc_attr_list
> * [PATCH 6.18 0780/1005] xfs: online quotacheck must dirty dquot if enfor=
cement adjustments needed
> * [PATCH 6.18 0781/1005] xfs: avoid cross-rtgroup reaping after a repair
> * [PATCH 6.18 0782/1005] xfs: actually lock the metafile reservation when=
 adjusting after repair
> * [PATCH 6.18 0783/1005] xfs: fix unnecessary dapos truncation in xchk_di=
r_walk
> * [PATCH 6.18 0784/1005] xfs: fix buffer overflow in corrupt inline attr =
structure
> * [PATCH 6.18 0785/1005] xfs: actually report corrupt xattrs as XFAIL dur=
ing cross-referencing
> * [PATCH 6.18 0786/1005] xfs: fix inode btree repair when a cluster is la=
rger than a chunk
> * [PATCH 6.18 0787/1005] xfs: always reset incore attr fork buffer when r=
esetting fork
> * [PATCH 6.18 0788/1005] xfs: dont pass iget failures up when marking ond=
isk inodes
> * [PATCH 6.18 0789/1005] xfs: zero out di_metatype when removing the meta=
dir file iflag
> * [PATCH 6.18 0790/1005] xfs: flag excessive delalloc rt extents as corru=
ption
> * [PATCH 6.18 0791/1005] xfs: dont fix the directory tree if live update =
fails
> * [PATCH 6.18 0792/1005] xfs: validate rc_domain in xchk_rtrefcount_merge=
able
> * [PATCH 6.18 0793/1005] xfs: dont proceed with xattr repair if the live =
update fails
> * [PATCH 6.18 0794/1005] xfs: fix skipped inode mask handling in iscan
> * [PATCH 6.18 0795/1005] xfs: dont repair fs summary counters with garbag=
e
> * [PATCH 6.18 0796/1005] xfs: fix lost errno returned from xfarray_folios=
ort
> * [PATCH 6.18 0797/1005] xfs: allow softlimit with no hardlimit in quota =
scrub
> * [PATCH 6.18 0798/1005] xfs: assign an owner to scrub_stats_fops
> * [PATCH 6.18 0799/1005] xfs: bail out of directory tree repairs on error
> * [PATCH 6.18 0800/1005] xfs: fix revalidation of xchk_dquot_iter cached =
mappings
> * [PATCH 6.18 0801/1005] xfs: abort dirtree repair if the live update hoo=
k dies
> * [PATCH 6.18 0802/1005] xfs: check fork type against dabtree block magic=
 number
> * [PATCH 6.18 0803/1005] xfs: mark overfull dabtree node blocks as corrup=
t
> * [PATCH 6.18 0804/1005] xfs: jump out of xchk_bmap_check_rmap if fatal s=
ignals
> * [PATCH 6.18 0805/1005] xfs: cross-reference the primary superblock
> * [PATCH 6.18 0806/1005] xfs: adjust checks for cross-AG reaping issues
> * [PATCH 6.18 0807/1005] xfs: actually check XFS_DIFLAG2_METADATA for met=
adata btree data forks
> * [PATCH 6.18 0808/1005] xfs: fix xchk_stats_estimate_bufsize to allow fo=
r the trailing null
> * [PATCH 6.18 0809/1005] sched_ext: sync disable_irq_work in bpf_scx_unre=
g()
> * [PATCH 6.18 0810/1005] sched_ext: Fix scx_flush_disable_work() UAF race
> * [PATCH 6.18 0811/1005] netfilter: disable payload mangling in userns
> * [PATCH 6.18 0812/1005] ipv6: Implement limits on extension header parsi=
ng
> * [PATCH 6.18 0813/1005] netfilter: nfnetlink_queue: restrict writes to n=
etwork header
> * [PATCH 6.18 0814/1005] netfilter: nft_meta: add double-tagged vlan and =
pppoe support
> * [PATCH 6.18 0815/1005] netfilter: nftables: restrict linklayer and netw=
ork header writes
> * [PATCH 6.18 0816/1005] netfilter: nftables: restrict checkum update off=
set
> * [PATCH 6.18 0817/1005] netfilter: validate L4 headers after userspace p=
acket writes
> * [PATCH 6.18 0818/1005] netfilter: nft_payload: restrict checksum offset=
s to known values
> * [PATCH 6.18 0819/1005] netfilter: nf_tables: fix netdev hook allocation=
 memleak with dormant tables
> * [PATCH 6.18 0820/1005] ksmbd: serialize directory emptiness checks with=
 readdir
> * [PATCH 6.18 0821/1005] ksmbd: fix breaking_cnt leak on early return in =
oplock_break()
> * [PATCH 6.18 0822/1005] rtnetlink: wait for RCU readers in rtnl_link_unr=
egister()
> * [PATCH 6.18 0823/1005] EDAC/mc: Really fix error path ordering in edac_=
mc_alloc()
> * [PATCH 6.18 0824/1005] Revert "net: Convert proto_ops bind() callbacks =
to use sockaddr_unsized"
> * [PATCH 6.18 0825/1005] media: usbtv: drop redundant device reference
> * [PATCH 6.18 0826/1005] media: usbtv: fix null-pointer dereference on di=
sconnect
> * [PATCH 6.18 0827/1005] xfs: reduce new btree slack factor if free space=
 is negative
> * [PATCH 6.18 0828/1005] xfs: reject absurdly large xattr value lengths i=
n xchk_xattr_actor
> * [PATCH 6.18 0829/1005] xfs: reject out-of-range attribute value lengths=
 in xfs_attr_copy_value
> * [PATCH 6.18 0830/1005] xfs: reject remote xattr entries with an out-of-=
range value length
> * [PATCH 6.18 0831/1005] xfs: release ip after unlinked list store failur=
e
> * [PATCH 6.18 0832/1005] xfs: rescan the AGs if incore delalloc counter i=
s negative
> * [PATCH 6.18 0833/1005] xfs: update quota flags on secondary supers when=
 metadir enabled
> * [PATCH 6.18 0834/1005] xfs: abort directory tree repair whenever dl->ab=
orted is set
> * [PATCH 6.18 0835/1005] xfs: always forget cached ACLs if the attr fork =
swap succeeds
> * [PATCH 6.18 0836/1005] xfs: always report inode repair setup failures
> * [PATCH 6.18 0837/1005] xfs: always report scrub errors in tracepoints
> * [PATCH 6.18 0838/1005] xfs: always zero the whole shortform header when=
 zeroing attr fork
> * [PATCH 6.18 0839/1005] xfs: bound da-node entry count against the corre=
ct geometry
> * [PATCH 6.18 0840/1005] xfs: bound inode fork length against the fork si=
ze during log recovery
> * [PATCH 6.18 0841/1005] xfs: check for fragments when full-extent sharin=
g matches
> * [PATCH 6.18 0842/1005] xfs: check for termination during rmap btree wal=
k
> * [PATCH 6.18 0843/1005] xfs: clarify various parts of the bitmap API
> * [PATCH 6.18 0844/1005] xfs: clear set[ug]id mode bits when zapping attr=
 fork
> * [PATCH 6.18 0845/1005] xfs: complain loudly when dirtree checker finds =
broken links
> * [PATCH 6.18 0846/1005] xfs: dont allow sm_agno for non-group metadir pa=
th checking
> * [PATCH 6.18 0847/1005] xfs: dont clear COWEXTSIZE on directories on ref=
link filesystems
> * [PATCH 6.18 0848/1005] xfs: dont overrun incore inode when cleaning att=
r forks
> * [PATCH 6.18 0849/1005] xfs: dont queue rmap update twice when reaping a=
 fork
> * [PATCH 6.18 0850/1005] xfs: dont rescan ifree and icount when frozen
> * [PATCH 6.18 0851/1005] xfs: dont scan across metadata/regular directory=
 trees for dirents
> * [PATCH 6.18 0852/1005] xfs: dont set a metadata directorys parent to sb=
_rootino
> * [PATCH 6.18 0853/1005] xfs: dont subtract excess usage twice when compu=
ting agf_btreeblks
> * [PATCH 6.18 0854/1005] xfs: dont try to repair rtsummary if the summary=
 file isnt computed
> * [PATCH 6.18 0855/1005] xfs: dont try to scrub self-referential dirent i=
n metapath checker
> * [PATCH 6.18 0856/1005] xfs: fix correction of unwritten extents in quot=
a file data fork
> * [PATCH 6.18 0857/1005] xfs: fix data fork block count check in xrep_ino=
de_blockcounts
> * [PATCH 6.18 0858/1005] xfs: init inode number for tracepoint
> * [PATCH 6.18 0859/1005] xfs: never reset the default quota timer
> * [PATCH 6.18 0860/1005] xfs: only written file data blocks can be shared
> * [PATCH 6.18 0861/1005] xfs: opportunistically skip btree block checks
> * [PATCH 6.18 0862/1005] xfs: propagate errors while checking null siblin=
gs
> * [PATCH 6.18 0863/1005] xfs: range-check bc_levels array access in scrub=
 tracepoints
> * [PATCH 6.18 0864/1005] xfs: reattach dquots after changing inode ids
> * [PATCH 6.18 0865/1005] x86/bugs: Adapt SRSO mitigation to Zen6
> * [PATCH 6.18 0866/1005] smb: server: size directory name conversion buff=
er correctly
> * [PATCH 6.18 0867/1005] smb: client: dont resurrect an exiting tcon from=
 cached dir workers
> * [PATCH 6.18 0868/1005] smb: client: fix buffer overflow in SMB2_tcon()
> * [PATCH 6.18 0869/1005] smb: client: fix fiemap wild read on empty trunc=
ated response
> * [PATCH 6.18 0870/1005] smb: client: fix slab-out-of-bounds write in id_=
mode_to_cifs_acl()
> * [PATCH 6.18 0871/1005] smb: client: validate NT transaction response la=
yout and offsets
> * [PATCH 6.18 0872/1005] pNFS: Fix CB_NOTIFY_DEVICEID CHANGE to consume n=
dc_immediate
> * [PATCH 6.18 0873/1005] pnfs/blocklayout: Complete a device upcall only =
on its own reply
> * [PATCH 6.18 0874/1005] pnfs/blocklayout: Complete a device upcall when =
the pipe is closed
> * [PATCH 6.18 0875/1005] NFSv4/pnfs: Free the netid when draining a data-=
server address list
> * [PATCH 6.18 0876/1005] NFSv4.1/pnfs: suspend pNFS on NFS4ERR_TOOSMALL f=
rom LAYOUTGET
> * [PATCH 6.18 0877/1005] NFSv4/filelayout: Anchor page coalescing on patt=
ern_offset
> * [PATCH 6.18 0878/1005] NFSv4/flexfiles: fail I/O to the data server onc=
e a lock is lost
> * [PATCH 6.18 0879/1005] NFSv4/flexfiles: Use the full 64-bit offset for =
read DS selection
> * [PATCH 6.18 0880/1005] NFSv4/flexfiles: Use the full 64-bit stripe_unit
> * [PATCH 6.18 0881/1005] NFSv4/flexfiles: Bound page coalescing on the ab=
solute stripe offset
> * [PATCH 6.18 0882/1005] NFS: Fix stale negative cache on failed nfs_mkdi=
r()
> * [PATCH 6.18 0883/1005] NFS/localio: fix nfs_local_dio_misaligned tracep=
oint
> * [PATCH 6.18 0884/1005] NFS/localio: report the stability a DIO WRITE ac=
tually has
> * [PATCH 6.18 0885/1005] NFSD: cap the number of listeners accepted in li=
stener_set
> * [PATCH 6.18 0886/1005] nfsd: clear XDR padding in GETXATTR replies
> * [PATCH 6.18 0887/1005] NFSD: copy SETXATTR data from all XDR buffer seg=
ments
> * [PATCH 6.18 0888/1005] NFSD: Do not send CB_RECALL_ANY to NFSv4.0 clien=
ts
> * [PATCH 6.18 0889/1005] NFSD: Dont complete a cld upcall the daemon has =
not read
> * [PATCH 6.18 0890/1005] nfsd: dont modify a session slot when replaying =
its cached reply
> * [PATCH 6.18 0891/1005] NFSD: Fail a pool_threads read whose reply does =
not fit
> * [PATCH 6.18 0892/1005] nfsd: fetch direct I/O alignment for files hande=
d to the filecache
> * [PATCH 6.18 0893/1005] nfsd: Fix id-to-name cache entry leak in idtonam=
e_parse()
> * [PATCH 6.18 0894/1005] NFSD: Fix out-of-bounds read in the rpc_status d=
ump
> * [PATCH 6.18 0895/1005] nfsd: hold cl_lock in client_has_openowners()
> * [PATCH 6.18 0896/1005] nfsd: honour client-provided attributes for NFS4=
_CREATE_EXCLUSIVE4_1
> * [PATCH 6.18 0897/1005] NFSD: map fh_verify() status codes for NFS_ACLv3=
 replies
> * [PATCH 6.18 0898/1005] NFSD: Map flex file layout IDs through the reque=
sts user namespace
> * [PATCH 6.18 0899/1005] nfsd: preflight SEQUENCE replies before acceptin=
g a slot
> * [PATCH 6.18 0900/1005] nfsd: propagate SETXATTR value decode errors
> * [PATCH 6.18 0901/1005] NFSD: Reject an oversized principal hash from nf=
sdcld
> * [PATCH 6.18 0902/1005] NFSD: Resolve the recall-any mask names in the t=
race format
> * [PATCH 6.18 0903/1005] NFSD: Return NFSERR_ISDIR for NFSv2 READ and WRI=
TE on a non-regular file
> * [PATCH 6.18 0904/1005] NFSD: Set nn->cld_net before registering the cld=
 pipe
> * [PATCH 6.18 0905/1005] NFSD: validate transport name in listener_set be=
fore serv creation
> * [PATCH 6.18 0906/1005] nfsd: zero NFSv4 COMPOUND tag padding
> * [PATCH 6.18 0907/1005] SUNRPC: Copy the deferred RPC Call from the head=
 buffer
> * [PATCH 6.18 0908/1005] SUNRPC: Do not credit control-record octets to t=
he RPC stream
> * [PATCH 6.18 0909/1005] SUNRPC: fix oversized GSS proxy token copy
> * [PATCH 6.18 0910/1005] SUNRPC: keep the first error in svc_register()
> * [PATCH 6.18 0911/1005] sunrpc: pin gss module across auth_domain RCU fr=
ee
> * [PATCH 6.18 0912/1005] SUNRPC: Reject a socket that already has an svc_=
sock attached
> * [PATCH 6.18 0913/1005] SUNRPC: Reject a TLS alert record that is not tw=
o octets
> * [PATCH 6.18 0914/1005] SUNRPC: Resume receiving after a TLS control rec=
ord
> * [PATCH 6.18 0915/1005] SUNRPC: trace an accepted transport before publi=
shing it
> * [PATCH 6.18 0916/1005] sunrpc: treat empty auth.unix.gid replies as neg=
ative entries
> * [PATCH 6.18 0917/1005] SUNRPC: Treat every TLS error alert as fatal
> * [PATCH 6.18 0918/1005] rxrpc: Fix update of call->tx_pending without ho=
lding lock
> * [PATCH 6.18 0919/1005] rxrpc: Fix lack of short-send handling in rxrpc_=
kernel_send_data()
> * [PATCH 6.18 0920/1005] afs: Fix afs to abort the rxrpc call on send err=
or
> * [PATCH 6.18 0921/1005] rxrpc: Fix double IRQ enablement
> * [PATCH 6.18 0922/1005] rxrpc: Fix return in rxrpc_recvmsg_data() for se=
rvice calls
> * [PATCH 6.18 0923/1005] x86/cpuid: Mark CPUID function 0x23 as being ind=
exed
> * [PATCH 6.18 0924/1005] x86/mm/pat: Fix effective RW computation in look=
up_address_in_pgd_attr()
> * [PATCH 6.18 0925/1005] KVM: SVM: Trigger new ASID allocation in both VM=
CBs on pCPU switch
> * [PATCH 6.18 0926/1005] KVM: nSVM: Ignore EFER.LMA if EFER.LME=3D0 when =
preparing L2 state
> * [PATCH 6.18 0927/1005] KVM: Use goto to handle errors during memslot pr=
eparation
> * [PATCH 6.18 0928/1005] KVM: VMX: Disallow using to_vmx() in common VT c=
ode
> * [PATCH 6.18 0929/1005] KVM: VMX: Make handle_bus_lock_vmexit() a shared=
 helper
> * [PATCH 6.18 0930/1005] KVM: VMX: Preserve negative return value in vmx_=
handle_exit() with bus lock detected
> * [PATCH 6.18 0931/1005] KVM: x86/mmu: Bug the VM if KVM attempts to walk=
 more levels than the MMU has
> * [PATCH 6.18 0932/1005] KVM: x86/mmu: Bug the VM if KVM calcs a CPU role=
 with EFER.LMA=3D1 && CR4.PAE=3D0
> * [PATCH 6.18 0933/1005] KVM: x86/xen: Enforce 4-byte alignment of vcpu_i=
nfo registration
> * [PATCH 6.18 0934/1005] KVM: x86/xen: Take kvm->srcu in __kvm_xen_has_in=
terrupt()
> * [PATCH 6.18 0935/1005] KVM: x86: Clear hardware HLT state when userspac=
e makes a vCPU not-halted
> * [PATCH 6.18 0936/1005] KVM: x86: Preserve DR6.BLD (Bus Lock Detect) whe=
n delivering #DB payload
> * [PATCH 6.18 0937/1005] KVM: x86: Request event processing for exception=
 VM-Exits
> * [PATCH 6.18 0938/1005] KVM: x86: Take SRCU in kvm_zap_gfn_range()
> * [PATCH 6.18 0939/1005] KVM: x86: Zero reserved synic flags when deliver=
ing message to avoid stack leak
> * [PATCH 6.18 0940/1005] KVM: TDX: Check if there is valid exit infos bas=
ed on vp_enter_ret
> * [PATCH 6.18 0941/1005] KVM: TDX: Enable Notify VM exit
> * [PATCH 6.18 0942/1005] KVM: TDX: Enable Bus Lock VM exit
> * [PATCH 6.18 0943/1005] KVM: PPC: Book3S HV: Add preempt_disable() aroun=
d virtual-mode HPTE bit-lock users
> * [PATCH 6.18 0944/1005] KVM: PPC: Fix get_d_signext() 12-bit displacemen=
t for paired-single D-form
> * [PATCH 6.18 0945/1005] HID: zydacron: validate key report length
> * [PATCH 6.18 0946/1005] HID: amd_sfh: Remove unsupported motion-state fi=
eld from accelerometer report
> * [PATCH 6.18 0947/1005] HID: amd_sfh: Use report type from request node
> * [PATCH 6.18 0948/1005] HID: core: Fix out-of-bounds left shift by 32 in=
 s32ton()
> * [PATCH 6.18 0949/1005] HID: cougar: reject short special-key reports
> * [PATCH 6.18 0950/1005] HID: cp2112: validate response report lengths
> * [PATCH 6.18 0951/1005] HID: elo: reject short touchscreen reports
> * [PATCH 6.18 0952/1005] HID: logitech-dj: validate unnumbered keyboard r=
eports
> * [PATCH 6.18 0953/1005] HID: mcp2200: validate READ_ALL response length
> * [PATCH 6.18 0954/1005] HID: mcp2221: validate response report length
> * [PATCH 6.18 0955/1005] HID: picoLCD: check for fb_deferred_io_init() er=
ror
> * [PATCH 6.18 0956/1005] HID: prodikeys: validate fixed-format MIDI repor=
ts
> * [PATCH 6.18 0957/1005] HID: pxrc: reject short input reports
> * [PATCH 6.18 0958/1005] HID: quirks: Always poll the Anne Pro 2 with pro=
duct ID a292
> * [PATCH 6.18 0959/1005] HID: roccat: isku: reject short button reports
> * [PATCH 6.18 0960/1005] HID: roccat: koneplus: reject short button repor=
ts
> * [PATCH 6.18 0961/1005] HID: roccat: konepure: reject short button repor=
ts
> * [PATCH 6.18 0962/1005] HID: roccat: kovaplus: reject short button repor=
ts
> * [PATCH 6.18 0963/1005] HID: roccat: pyra: reject short button reports
> * [PATCH 6.18 0964/1005] HID: roccat: ryos: reject short special reports
> * [PATCH 6.18 0965/1005] HID: roccat: savu: reject short special reports
> * [PATCH 6.18 0966/1005] ovl: check that the parents of volatile/dirty ar=
e dirs
> * [PATCH 6.18 0967/1005] ovl: hold a reference on the parent in readdir
> * [PATCH 6.18 0968/1005] ovl: do not copy up a dentry that was removed
> * [PATCH 6.18 0969/1005] ovl: fix mount setup failing when override_creds=
 drops CAP_SYS_ADMIN
> * [PATCH 6.18 0970/1005] smb: smbdirect: fix buffer length underflow in R=
DMA transfers
> * [PATCH 6.18 0971/1005] io_uring/kbuf: advance head when a pickup emptie=
s the buffer ring
> * [PATCH 6.18 0972/1005] io_uring/net: keep recvmsg buffer select length =
within MAX_RW_COUNT
> * [PATCH 6.18 0973/1005] io_uring/net: dont retry a non-blocking connect(=
) that fails with -EAGAIN
> * [PATCH 6.18 0974/1005] io_uring/io-wq: no new workers once the exit has=
 begun
> * [PATCH 6.18 0975/1005] io_uring/rsrc: charge buffer arrays and nodes to=
 memcg
> * [PATCH 6.18 0976/1005] io_uring: charge tctx nodes and personalities
> * [PATCH 6.18 0977/1005] io_uring: free XArray nodes left by a failed sto=
re
> * [PATCH 6.18 0978/1005] io_uring/sqpoll: dont wait for the thread to exi=
t
> * [PATCH 6.18 0979/1005] io_uring: defer foreign io-wq enqueues to task_w=
ork
> * [PATCH 6.18 0980/1005] io_uring/timeout: count cancelled timeouts in cq=
_timeouts
> * [PATCH 6.18 0981/1005] io_uring/net: fix multishot recv length limit ac=
counting
> * [PATCH 6.18 0982/1005] smb: client: do not pass a NULL buf to is_oplock=
_break()
> * [PATCH 6.18 0983/1005] smb: client: fix early procfs exposure race
> * [PATCH 6.18 0984/1005] driver core: Check drivers_autoprobe for all add=
ed devices
> * [PATCH 6.18 0985/1005] driver core: take parent lock in async device at=
tach
> * [PATCH 6.18 0986/1005] ksmbd: deny access for an empty DACL instead of =
granting the request
> * [PATCH 6.18 0987/1005] ksmbd: fix session reference leak on compounded =
SESSION_SETUP
> * [PATCH 6.18 0988/1005] ksmbd: prevent share root removal through empty =
paths
> * [PATCH 6.18 0989/1005] ksmbd: prevent stale data from being written by =
SMB2 WRITE requests
> * [PATCH 6.18 0990/1005] ksmbd: fix invalid pointer dereference when get_=
inode_acl() fails
> * [PATCH 6.18 0991/1005] ksmbd: use the existing xattr name for a named s=
tream
> * [PATCH 6.18 0992/1005] ksmbd: fix out-of-bounds read when padding the f=
inal compound response
> * [PATCH 6.18 0993/1005] ksmbd: fix named stream write and EOF handling
> * [PATCH 6.18 0994/1005] ksmbd: verify transform SessionId matches the de=
crypted header
> * [PATCH 6.18 0995/1005] ksmbd: fix use-after-free after a failed durable=
 reconnect
> * [PATCH 6.18 0996/1005] media: ipu-bridge: Fix use-after-free in IVSC er=
ror path
> * [PATCH 6.18 0997/1005] pps: change pps_gen_class to a const struct
> * [PATCH 6.18 0998/1005] pps: generators: fix use-after-free when closing=
 a removed device
> * [PATCH 6.18 0999/1005] mm/rmap: dont discard lazyfree THPs at PMD level
> * [PATCH 6.18 1000/1005] media: rc: Fix build failure with CONFIG_LIRC di=
sabled
> * [PATCH 6.18 1001/1005] selftests: ublk: add missing gitignore for metad=
ata_size binary
> * [PATCH 6.18 1002/1005] drm/amdgpu/powerplay: Align get_tonga_state_arra=
y() header with prototype
> * [PATCH 6.18 1003/1005] netfilter: conntrack: always lower timeout for n=
on-closing RST packets
> * [PATCH 6.18 1004/1005] opp: fix use after free in _update_opp_table_clk=
()
> * [PATCH 6.18 1005/1005] ALSA: hda/realtek: Fix audio after Windows reboo=
t on ASUS Q423SA
>
> and found the following issue:
> WARNING: lock held when returning to user space in uart_set_ldisc
>
> Full report is available here:
> https://ci.syzbot.org/series/530f70c1-b89b-4aea-9f60-b37ea51b8ceb
>
> ***
>
> WARNING: lock held when returning to user space in uart_set_ldisc
>
> tree:      stable
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/stabl=
e/linux-stable.git
> base:      f45ed76d6791cf72ff1265ee93511175bbbc2f18
> arch:      amd64
> compiler:  Debian clang version 22.1.8 (1~deb13u4), Debian LLD 22.1.8
> config:    https://ci.syzbot.org/builds/29ef7d8d-54c9-4916-91c8-e2793ec68=
4f2/config
> syz repro: https://ci.syzbot.org/findings/a8ef2ca8-d3da-4fa6-b5c9-47061f7=
b2d3f/syz_repro
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> WARNING: lock held when returning to user space!
> syzkaller #0 Not tainted
> ------------------------------------------------
> syz.2.19/5834 is leaving the kernel with locks still held!
> 1 lock held by syz.2.19/5834:
>  #0: ffff888109e20e90 (&port->mutex){+.+.}-{4:4}, at: uart_set_ldisc+0x51=
/0x1e0 drivers/tty/serial/serial_core.c:1658
>
>
> ***
>
> If these findings have caused you to resend the series or submit a
> separate fix, please add the following tag to your commit message:
>   Tested-by: syzbot@syzkaller.appspotmail.com
>
> ---
> This report is generated by a bot. It may contain errors.
> syzbot ci engineers can be reached at syzkaller@googlegroups.com.
>
> To test a fix for this bug, please reply with `#syz test`
> (on a separate line) and attach the patch to the email.
>
> Notes:
> - The patch will be applied on top of the tested series (as an
>   incremental fix).
> - To test a new version of the whole series, please send it directly
>   to syzbot@lists.linux.dev.
> - Arguments like custom git repos and branches are not supported.
>
> The email will later be sent to:
> [achill@achill.org akpm@linux-foundation.org broonie@kernel.org conor@ker=
nel.org f.fainelli@gmail.com gregkh@linuxfoundation.org hargar@microsoft.co=
m jonathanh@nvidia.com linux-kernel@vger.kernel.org linux@roeck-us.net lkft=
-triage@lists.linaro.org patches@kernelci.org patches@lists.linux.dev pavel=
@nabladev.com rwarsow@gmx.de shuah@kernel.org sr@sladewatkins.com stable@vg=
er.kernel.org sudipm.mukherjee@gmail.com torvalds@linux-foundation.org]
>
> If the report looks fine to you, reply with:
> #syz upstream
>
> If the report is a false positive, reply with
> #syz invalid
>
> --
> You received this message because you are subscribed to the Google Groups=
 "syzkaller-upstream-moderation" group.
> To unsubscribe from this group and stop receiving emails from it, send an=
 email to syzkaller-upstream-moderation+unsubscribe@googlegroups.com.
> To view this discussion visit https://groups.google.com/d/msgid/syzkaller=
-upstream-moderation/6aec8d04.b98d4f1a.72a9.0025.GAE%40google.com.
