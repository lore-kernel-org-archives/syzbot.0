Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.167.198
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795708744;
	b=05J1VqOCi67QCR2dhGUhxAZ+DZ8jqtTIbdOBoBHPLFe9xj+OFuqWvqpN2F02LXHr/vJa
	 B2FQrZjwtHIPfJZJ22rXaxHysx35tLUYeqeJTka1dnayBqiyxKRqpDpIfn5ZSbltucbjx
	 aOPKGrtHFyVF2OVbmH6QiORF0YcvfXvnIKoiazWP87IEy1qpWd8N6nybk4AiLCAqyVVmo
	 cs00xSksYX9FQY9mi8P4MqA16IOKUGGNmjUo+sgNBvzq8mT6U+G+DTSZo9auK/HzjjgB8
	 immuk9//8InQisLJAUd3Xg/yrMdAkwiuh/uQKCnd2H/Y0XlG4lJU2bk+BDPNbKWkv5Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795708744;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 MIME-Version:X-Received:Date:X-Google-Appengine-App-Id:
	 X-Google-Appengine-App-Id-Alias:Message-ID:Subject:From:To:Cc:
	 Content-Type:Content-Transfer-Encoding;
	bh=xdiqiWgqIhiuHrJkiP3Tw0w0ZlwX9SfuLpbXKlUXYBU=;
	b=NHGGQjb/TGAHLWmmgJ7LmzO8+v/OCeLu6vDUY1ysw1hbiv+ecugbYrX5UHFM8UY2OaSM
	 DyiVVR/UsD7ffkd7NV5wjMgptTRINJfjj0pub9FU3CEVDKmV7A0TejXDg/oyJEmSQ4fIY
	 vhSn8nl1lqsLsCg0+jbabP7jyWTaAESlV4Z/kacpacQlUlfNc3SHcPPuyO0D5nTJhN5df
	 FsO/1sbYeqcZ6rb8KtiZE4uYRaB2FoI8aFEQpArFFVTereEzQjOCkJvHsoz5GeHoB4+CW
	 OK27+cQaOtfARVReZXwV16JLSWI4/qLzi8SLIhDaoPBgLb4oM7VZskBmEjgVlidN3vQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=syzkaller.appspotmail.com;
	spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	arc=none smtp.remote-ip=209.85.167.198
Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com [209.85.167.198])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51DF4606A31C
	for <syzbot@lists.linux.dev>; Thu, 26 Nov 2026 15:59:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 51DF4606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f198.google.com with SMTP id 5614622812f47-54dbbf252cdso7103378b6e.2
        for <syzbot@lists.linux.dev>; Thu, 26 Nov 2026 07:59:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795708742; x=1796313542;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:date:mime-version:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=xdiqiWgqIhiuHrJkiP3Tw0w0ZlwX9SfuLpbXKlUXYBU=;
        b=TYXoc6TeQzLjy5nJWA/GCALBBI+52u/lKkzWb3j6kkDrScjtxllmEaVEb+vdVV4aCs
         L11GeG9pmmnxiq+wNnV5HJ78+Xe2RkQQ6FBgetBr/PCWfK262MUtyOgiBQ3cqNPzE3Ra
         QYadRPe5eAIlnYPTqCtzmOlecqcD1DoZRRJt51V9B+bRgYhGGJ6pzy7rTKlA9IQAObpu
         +CskxetPbxrBf38aR/f/sJOKSGeqxHC2B08uxSb3/EM9kbCWd8nUcmWEk+FbMnaAfuBA
         seqFUA5CUOI3m5HKafWrJMlzW5DKbTEEsI1o3lC+kfy8/iGdzoKcjSkdKmOQDf2GIIik
         LVNw==
X-Gm-Message-State: APuU4Z8ZpDO4NaHabH9vZyodRgAd1uLq+wQkwnpLMJPeSVU1HDVLtuvi
	S6ZnY0lGpnMpTy5xIbJwVqQa83vp4RptD6kq4rMd1nHhxlAHwI8PtflUV/8LIoU8PBjKOwsR8jJ
	XDhmn0XdMEOYlevB2LrXl+iWlvTjoEDYI13kQQ9wHO80nf+Gubq1grcr32O8=
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Post: <mailto:syzbot@lists.linux.dev>
List-Help: <mailto:syzbot+help@lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
List-Owner: <mailto:syzbot+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-Received: by 2002:a05:6808:c236:b0:573:a2a3:b747 with SMTP id
 5614622812f47-57a0bc9d295mr23851734b6e.41.1795708742278; Thu, 26 Nov 2026
 07:59:02 -0800 (PST)
Date: Thu, 26 Nov 2026 07:59:02 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6b085746.1492ceaa.187240.0073.GAE@google.com>
Subject: [moderation/CI] Re: 5.15.227-rc1 review
From: syzbot ci <syzbot+ciaad0872bd4e79950@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v1] 5.15.227-rc1 review
https://lore.kernel.org/all/20261126144006.732901931@linuxfoundation.org
* [PATCH 5.15 001/319] media: uvcvideo: Undup use uvc_endpoint_max_bpi() co=
de
* [PATCH 5.15 002/319] netfilter: nft_ct: expectation timeouts are passed i=
n milliseconds
* [PATCH 5.15 003/319] netfilter: nft_ct: move custom expectation support t=
o helper
* [PATCH 5.15 004/319] mptcp: fix UAF of child socket on listener close
* [PATCH 5.15 005/319] mm/khugepaged: preserve dirty bits when collapsing P=
TE-mapped THPs
* [PATCH 5.15 006/319] net: ravb: Fix missing rtnl lock in suspend/resume p=
ath
* [PATCH 5.15 007/319] i3c: master: Fix recursive locking during device reg=
istration
* [PATCH 5.15 008/319] drm/amdgpu: Check cs flags.
* [PATCH 5.15 009/319] ARM: OMAP2+: omap4-common: Fix refcount leak bug
* [PATCH 5.15 010/319] bpf: Drop inet_conn_established from lsm sleepable h=
ooks
* [PATCH 5.15 011/319] mm: page_alloc: remove ALLOC_NON_BLOCK from ALLOC_RE=
SERVES
* [PATCH 5.15 012/319] fs: aio: reject partial mremap to avoid Null-pointer=
-dereference error
* [PATCH 5.15 013/319] udf: validate VAT inode size for old VAT format
* [PATCH 5.15 014/319] udf: validate vat20->lengthHeader and VAT inode size=
 in udf_load_vat()
* [PATCH 5.15 015/319] Input: destroy force-feedback device on input unregi=
stration
* [PATCH 5.15 016/319] staging: media: atomisp: use array3_size() for overf=
low-safe allocation
* [PATCH 5.15 017/319] fs/9p: switch vfsmount to use v9fs_get_new_inode
* [PATCH 5.15 018/319] fs/9p: rework qid2ino logic
* [PATCH 5.15 019/319] 9p: skip intermediate directory entry name copy in p=
9dirent_read()
* [PATCH 5.15 020/319] xfrm: zero-initialise km_event in the replay-notify =
path
* [PATCH 5.15 021/319] batman-adv: avoid WARN_ON for orig_ifinfo allocation=
 failure
* [PATCH 5.15 022/319] wifi: ath9k_htc: start ANI when an AP interface begi=
ns to beacon
* [PATCH 5.15 023/319] scsi: aic7xxx: Fix REQUEST SENSE allocation length o=
n big-endian hosts
* [PATCH 5.15 024/319] scsi: aha1542: Remove unneeded scsi_dma_unmap() call
* [PATCH 5.15 025/319] ath10k: turn rawmode into frame_mode
* [PATCH 5.15 026/319] ath10k: add encapsulation offloading support
* [PATCH 5.15 027/319] wifi: ath10k: Fix miscellaneous spelling errors
* [PATCH 5.15 028/319] wifi: ath10k: Stop unanswered temperature reads
* [PATCH 5.15 029/319] gpio: omap: Propagate runtime PM failures in probe a=
nd request
* [PATCH 5.15 030/319] btrfs: verity: propagate orphan insertion errors whe=
n enabling verity
* [PATCH 5.15 031/319] btrfs: scrub: fix lost wakeup and hang when cancelli=
ng a scrub that is finishing
* [PATCH 5.15 032/319] ptp: drain virtual clock sysfs operations before unr=
egistering children
* [PATCH 5.15 033/319] ptp: unwind partially completed virtual clock creati=
on
* [PATCH 5.15 034/319] scsi: target: Validate REGISTER AND MOVE TransportID=
 length
* [PATCH 5.15 035/319] tipc: reject attaching bearer of different media to =
the same occupied device
* [PATCH 5.15 036/319] spi: pic32-sqi: fail transfer when the BD ring is ex=
hausted
* [PATCH 5.15 037/319] bpf: Dont let bpf_skb_adjust_room() raise gso_size t=
o GSO_BY_FRAGS
* [PATCH 5.15 038/319] bpf: Reject non-IPv6 packets in BPF_LWT_ENCAP_SEG6
* [PATCH 5.15 039/319] bpf: Limit the SRH length in bpf_lwt_seg6_adjust_srh=
()
* [PATCH 5.15 040/319] bpf: Dont look for the SRH again in the End.BPF help=
ers
* [PATCH 5.15 041/319] bpf: Move the MAC header in bpf_lwt_seg6_adjust_srh(=
)
* [PATCH 5.15 042/319] bpf: Dont leave a stale MAC header in bpf_lwt_push_i=
p_encap()
* [PATCH 5.15 043/319] bpf: Move the transport header with the moved header=
s
* [PATCH 5.15 044/319] spi: Remove unused function spi_busnum_to_master()
* [PATCH 5.15 045/319] spi: Create helper API to lookup ACPI info for spi d=
evice
* [PATCH 5.15 046/319] spi: Support selection of the index of the ACPI Spi =
Resource before alloc
* [PATCH 5.15 047/319] spi: remove duplicate parameters check in acpi_spi_a=
dd_resource()
* [PATCH 5.15 048/319] spi: Fix ACPI SPI resources using relative path
* [PATCH 5.15 049/319] spi: acpi: only look up the IRQ of confirmed SPI dev=
ices
* [PATCH 5.15 050/319] bpf: lwt: Free the skb when bpf_xmit() fails to expa=
nd the headroom
* [PATCH 5.15 051/319] net: stmmac: copy XDP metadata in AF_XDP zero-copy R=
X
* [PATCH 5.15 052/319] sfc: ptp: drop the stale frequency reset in efx_ptp_=
start()
* [PATCH 5.15 053/319] sfc: ptp: serialize host and MC synchronization tran=
sactions
* [PATCH 5.15 054/319] sfc: ptp: avoid racing PPS timestamp updates
* [PATCH 5.15 055/319] vhost-scsi: preserve event ordering
* [PATCH 5.15 056/319] vhost: reject invalid IOTLB update permissions
* [PATCH 5.15 057/319] regulator: qcom_spmi: Drop unnecessary of_find_prope=
rty() call
* [PATCH 5.15 058/319] regulator: qcom_spmi: dont take a sleeping lock in t=
he SAW IPI
* [PATCH 5.15 059/319] gpio: mpc8xxx: Convert to platform remove callback r=
eturning void
* [PATCH 5.15 060/319] gpio: mpc8xxx: Add wake on GPIO support
* [PATCH 5.15 061/319] gpio: mpc8xxx: use a helper variable to store the ad=
dress of pdev->dev
* [PATCH 5.15 062/319] gpio: mpc8xxx: Fix potential use-after-free of IRQ d=
omain
* [PATCH 5.15 063/319] net/iucv: take a private, writable frame before rewr=
iting it in place
* [PATCH 5.15 064/319] ASoC: meson: axg-fifo: request the irq with the cloc=
k enabled
* [PATCH 5.15 065/319] Bluetooth: hci_core: Initialize IRK before publicati=
on
* [PATCH 5.15 066/319] Bluetooth: hci_core: Initialize link key before publ=
ication
* [PATCH 5.15 067/319] Bluetooth: hci_core: Initialize LTK before publicati=
on
* [PATCH 5.15 068/319] Bluetooth: btintel: fix buffer over-read in fw paylo=
ad
* [PATCH 5.15 069/319] Bluetooth: hci_core: Keep link-key filtering inside =
RCU
* [PATCH 5.15 070/319] ksmbd: implement error handling for STATUS_INFO_LENG=
TH_MISMATCH in smb server
* [PATCH 5.15 071/319] ksmbd: require NUL-terminated EA names
* [PATCH 5.15 072/319] soreuseport: annotate data-races around reuse->socks=
[] and num_socks
* [PATCH 5.15 073/319] vhost-scsi: validate event queue descriptor directio=
n
* [PATCH 5.15 074/319] vhost-scsi: reject delayed virtqueue setup
* [PATCH 5.15 075/319] vhost: reject backend enable without a kick file
* [PATCH 5.15 076/319] block: partitions: reject GPT entries with starting_=
lba > ending_lba
* [PATCH 5.15 077/319] null_blk: fix opening closed zones at the active zon=
e limit
* [PATCH 5.15 078/319] net: dsa: b53: Enable IGMP and MLD control packet CP=
U copies
* [PATCH 5.15 079/319] nvmet-rdma: disconnect only established queues
* [PATCH 5.15 080/319] nvmet-tcp: limit the connections accepted per work r=
un
* [PATCH 5.15 081/319] nvmet-rdma: take a device off the list last
* [PATCH 5.15 082/319] nvmet-rdma: queue the release work under the mutex
* [PATCH 5.15 083/319] nvme-tcp: handle number of queue changes
* [PATCH 5.15 084/319] nvme: fix various comment typos
* [PATCH 5.15 085/319] nvmet-rdma: disconnect a queue on device removal
* [PATCH 5.15 086/319] tcp: Fix dup-ack detection on non-SACK bidirectional=
 data transfer.
* [PATCH 5.15 087/319] net: skbuff: reject zero MPLS TTL before decrementin=
g
* [PATCH 5.15 088/319] PM: runtime: Fix check_flush_dependency warning from=
 pm_runtime_remove
* [PATCH 5.15 089/319] net: ipv6: use the new fib6_nh_release_dsts helper i=
n fib6_nh_release
* [PATCH 5.15 090/319] ipv6: Flush exception route while replacing nexthop.
* [PATCH 5.15 091/319] ipv4: Call rt_add_uncached_list() if !do_cache in ip=
_route_input_slow().
* [PATCH 5.15 092/319] drm/amd/pm: track BACO state in the SMU v11 ArmD3 se=
quence
* [PATCH 5.15 093/319] ACPI: scan: Print the offline failure message in acp=
i_bus_offline()
* [PATCH 5.15 094/319] ACPI: scan: Introduce acpi_fetch_acpi_dev()
* [PATCH 5.15 095/319] ACPI: scan: Do not hold physical_node_lock across de=
vice_offline() and device_online()
* [PATCH 5.15 096/319] Bluetooth: L2CAP: Clear request identifiers on incom=
ing LE connections
* [PATCH 5.15 097/319] net: ethernet: bgmac: preserve forced 2.5 Gbps link =
speed
* [PATCH 5.15 098/319] net: dsa: b53: Force flow control for BCM5301X CPU p=
ort(s)
* [PATCH 5.15 099/319] net: dsa: b53: restore the NSP IMP port 2 Gbps mode
* [PATCH 5.15 100/319] ALSA: hda/core: Stop capability walk on empty capabi=
lity header
* [PATCH 5.15 101/319] net: 8139cp: keep Rx masked while NAPI is scheduled
* [PATCH 5.15 102/319] bonding: 3ad: dont set BOND_LINK_FAIL on a slave tha=
t is not up
* [PATCH 5.15 103/319] net: bridge: disable MRP ports before the FDB flush =
in del_nbp()
* [PATCH 5.15 104/319] netfilter: x_tables: check target name before access=
ing verdict
* [PATCH 5.15 105/319] netfilter: nf_conntrack_sip: fix OOB read in ct_sip_=
parse_transport()
* [PATCH 5.15 106/319] netfilter: nf_tables: fix memleak when rule deletion=
 fails with hardware offload
* [PATCH 5.15 107/319] netfilter: nat: zero newrange before filling it in
* [PATCH 5.15 108/319] ipv6/tcp: small drop monitor changes
* [PATCH 5.15 109/319] tcp: ipv6: free ireq->ipv6_opt after an RCU grace pe=
riod
* [PATCH 5.15 110/319] MIPS: Avoid dead code/data elimination when using re=
cordmcount
* [PATCH 5.15 111/319] MIPS: Alchemy: Save the Ethernet address before reus=
ing PROM memory
* [PATCH 5.15 112/319] MIPS: SB1250: Validate and update IRQ affinity
* [PATCH 5.15 113/319] initrd: flush deferred fput() before mounting root
* [PATCH 5.15 114/319] vfs: preserve subsecond timestamps at filesystem tim=
e limits
* [PATCH 5.15 115/319] include/linux/fs.h: add inode_lock_killable()
* [PATCH 5.15 116/319] fs/read_write: make default_llseek() killable
* [PATCH 5.15 117/319] fs: reject negative offsets for SEEK_DATA and SEEK_H=
OLE in default_llseek()
* [PATCH 5.15 118/319] sched/pelt: Fix u32 truncation of the PELT period co=
unt
* [PATCH 5.15 119/319] locking/osq_lock: Clarify osq_wait_next() calling co=
nvention
* [PATCH 5.15 120/319] locking/osq: Switch osq_wait_next()/atomic_cmpxchg()=
 ordering
* [PATCH 5.15 121/319] locking/osq: Fix unlink queue corruption
* [PATCH 5.15 122/319] cpufreq: Return -EOPNOTSUPP if no policy supports bo=
ost
* [PATCH 5.15 123/319] cpufreq: Preserve global boost state on failed updat=
es
* [PATCH 5.15 124/319] cpufreq: Serialize global boost updates
* [PATCH 5.15 125/319] Bluetooth: reject invalid LE supervision timeout rel=
ationships
* [PATCH 5.15 126/319] net/mlx5e: IPoIB, Fix QPN lookup race
* [PATCH 5.15 127/319] calipso: do not charge request socket options to the=
 listener
* [PATCH 5.15 128/319] ipv6: ICMPV6: Use swap() instead of open coding it
* [PATCH 5.15 129/319] ipv6: Check the Home Address option again before its=
 address is used
* [PATCH 5.15 130/319] ata: libata-scsi: fix MODE SELECT handling of data a=
fter the mode page
* [PATCH 5.15 131/319] ata: libata-scsi: Simplify ata_scsi_mode_select_xlat=
()
* [PATCH 5.15 132/319] ata: libata-scsi: reject MODE SELECT mode pages with=
 a wrong SPF bit
* [PATCH 5.15 133/319] ata: libata-scsi: fix MODE SELECT field pointer for =
block descriptor length
* [PATCH 5.15 134/319] tracing/probes: bound symstr stores to reserved leng=
th
* [PATCH 5.15 135/319] gpiolib: of: return -ENOENT from of_gpio_count() stu=
b
* [PATCH 5.15 136/319] NFSv4.1: retain MDS I/O until both thresholds are me=
t
* [PATCH 5.15 137/319] SUNRPC: wake poll waiters when an empty pipe is unli=
nked
* [PATCH 5.15 138/319] SUNRPC: preserve timeout policy when cloning clients
* [PATCH 5.15 139/319] SUNRPC: Balance switch queue length on transport rem=
oval
* [PATCH 5.15 140/319] SUNRPC: Balance queue accounting when relocating a t=
ask
* [PATCH 5.15 141/319] ipv6: ignore link state in gateway check
* [PATCH 5.15 142/319] team: Add matching error label for failed action
* [PATCH 5.15 143/319] team: fix promisc/allmulti leak in team_port_add err=
or path
* [PATCH 5.15 144/319] net: protect negative destination advice with RCU
* [PATCH 5.15 145/319] neigh: introduce neigh_confirm() helper function
* [PATCH 5.15 146/319] net: require a full socket in sock_confirm_neigh()
* [PATCH 5.15 147/319] bonding: fix slave_cnt leak on XDP enslave failure
* [PATCH 5.15 148/319] tun: delete the flow entries of the moved queue on d=
etach
* [PATCH 5.15 149/319] ipv4: route: dont blackhole in-use routes when retir=
ing fnhe routes
* [PATCH 5.15 150/319] ptp: kvm: x86: Leak clock_pair page if changing its =
encryption fails
* [PATCH 5.15 151/319] fou: gue: check IP version of held packets for direc=
t IP encapsulation
* [PATCH 5.15 152/319] udp: do not use a cross-family sk_rx_dst in early de=
mux
* [PATCH 5.15 153/319] drm/bridge: sii902x: validate I2S data lane values
* [PATCH 5.15 154/319] xen/grant-table: annotate on-stack work in gnttab_un=
map_refs_sync()
* [PATCH 5.15 155/319] ASoC: max98090: keep the MIC boost across mic input =
power-up
* [PATCH 5.15 156/319] net: ena: Keep the RX buffer mapped if skb allocatio=
n fails
* [PATCH 5.15 157/319] net: ena: avoid RX copybreak for multi-descriptor pa=
ckets
* [PATCH 5.15 158/319] tun: disallow setting IEEE 802.15.4 and 6LoWPAN link=
 types via TUNSETLINK
* [PATCH 5.15 159/319] tls: fix async encryption race on weakly ordered arc=
hitectures
* [PATCH 5.15 160/319] igmp: use the joined device when leaving a multicast=
 group
* [PATCH 5.15 161/319] tcp: Pass req->rsk_listener to inet_csk_reqsk_queue_=
drop() in tcp_check_req().
* [PATCH 5.15 162/319] net: usb: cdc_ncm: dont underflow the NDP room check
* [PATCH 5.15 163/319] tracing: skip boot kprobe setup when no events were =
requested
* [PATCH 5.15 164/319] docs, kprobes: Fix bracket
* [PATCH 5.15 165/319] KEYS: do not let an unmatched key decide the search =
result
* [PATCH 5.15 166/319] ALSA: aw2-alsa: select SND_PCM
* [PATCH 5.15 167/319] Xen/gnttab: improve error handling in gnttab_dma_{al=
loc,free}_pages()
* [PATCH 5.15 168/319] KEYS: Reject descriptions larger than KEY_MAX_DESC_S=
IZE
* [PATCH 5.15 169/319] KEYS: Verify the key identity in __key_unlink_begin
* [PATCH 5.15 170/319] bootconfig: Allow keys with the maximum supported de=
pth
* [PATCH 5.15 171/319] ALSA: caiaq: Kill EP1 URB before unregistering the i=
nput device
* [PATCH 5.15 172/319] ALSA: usb-audio: Drop capture packets with bogus act=
ual_length
* [PATCH 5.15 173/319] tracing/selftests: Fix false bashism in kprobe_non_u=
niq_symbol.tc
* [PATCH 5.15 174/319] mmc: mmci: fix DMA channel leak when mmc_add_host() =
fails
* [PATCH 5.15 175/319] mmc: meson-gx: report busy from DAT0 alone
* [PATCH 5.15 176/319] mmc: meson-gx: honour the busy timeout for R1b comma=
nds
* [PATCH 5.15 177/319] mmc: meson-gx: name the limit of the CMD_CFG timeout=
 field
* [PATCH 5.15 178/319] aio: dont let exit_aio() return before complete() is=
 done
* [PATCH 5.15 179/319] mm/mmzone: read the zoneref slot once in zonelist_zo=
ne()
* [PATCH 5.15 180/319] mm/memory_hotplug: resize zones under their seqlock
* [PATCH 5.15 181/319] mm/page_alloc: detect zonelist rebuilds from memory =
hot-add
* [PATCH 5.15 182/319] net: dst_metadata: fix memcmp overread in skb_metada=
ta_dst_cmp
* [PATCH 5.15 183/319] nvmem: core: Check input parameter for NULL in nvmem=
_unregister()
* [PATCH 5.15 184/319] ext4: avoid infinite loops caused by residual data
* [PATCH 5.15 185/319] mctp: accept MSG_CMSG_COMPAT in recvmsg
* [PATCH 5.15 186/319] net/rds: Do not unpin a page after a failed atomic p=
in
* [PATCH 5.15 187/319] net: bridge: use one headroom snapshot for ND replie=
s
* [PATCH 5.15 188/319] net: leave O_NONBLOCK to the sendmsg and recvmsg sys=
calls
* [PATCH 5.15 189/319] net: mana: report RX checksum offload for IPv6
* [PATCH 5.15 190/319] tls: only install push_pending_record for a TX conte=
xt
* [PATCH 5.15 191/319] seg6: validate state in netfilter continuations
* [PATCH 5.15 192/319] mptcp: reject DATA_ACKs against a reversed send inte=
rval
* [PATCH 5.15 193/319] ipv4: keep XFRM headers out of corked skb lengths
* [PATCH 5.15 194/319] ipv4: fib_trie: prevent speculative out-of-bounds ch=
ild access
* [PATCH 5.15 195/319] ipv6: fix cached route reuse for control messages
* [PATCH 5.15 196/319] ipv6: reject routes without an inet6_dev
* [PATCH 5.15 197/319] ipvs: Defer application parent freeing until after R=
CU readers
* [PATCH 5.15 198/319] ipvs: fix protocol data lifetime during namespace te=
ardown
* [PATCH 5.15 199/319] hv_netvsc: Stop PPI parsing on invalid metadata
* [PATCH 5.15 200/319] netfilter: xt_recent: do not call remove_proc_entry(=
) under recent_lock
* [PATCH 5.15 201/319] net/sched: sch_teql: reject qdiscs from another netw=
ork namespace
* [PATCH 5.15 202/319] net/sched: act_ife: encode configured zero metadata =
values
* [PATCH 5.15 203/319] PM: runtime: Update last_busy in rpm_resume() for ac=
tive devices
* [PATCH 5.15 204/319] Bluetooth: hci_qca: fix use-after-free in ibs debugf=
s files
* [PATCH 5.15 205/319] crypto: essiv - fix use-after-free in AEAD path
* [PATCH 5.15 206/319] fs/adfs: bound directory entry name length in adfs_f=
plus_getnext()
* [PATCH 5.15 207/319] fs/proc: fix the write length returned by proc_sys_c=
all_handler()
* [PATCH 5.15 208/319] cpufreq: acpi-cpufreq: fix P-state index mismatch in=
 extract_io()
* [PATCH 5.15 209/319] cpufreq: intel_pstate: Clear last written P-state va=
lue on suspend
* [PATCH 5.15 210/319] cpufreq: Cache post-resolution target frequency in _=
_resolve_freq()
* [PATCH 5.15 211/319] software node: only let the owner release a managed =
node
* [PATCH 5.15 212/319] timekeeping: Read getboottime64() offsets under the =
sequence counter
* [PATCH 5.15 213/319] tpm: acpi: Fix memory leak at tpm_read_log_acpi() er=
ror path
* [PATCH 5.15 214/319] tpm: eventlog: check the payload size before reading=
 tag events
* [PATCH 5.15 215/319] x86/mm: Ensure write visibility during LDT installat=
ion
* [PATCH 5.15 216/319] xen/gntdev: fix deadlock between map ioctl and mmap
* [PATCH 5.15 217/319] xen/pvcalls: unwind pvcalls_new_active_socket() step=
 by step
* [PATCH 5.15 218/319] xen/pvcalls: destroy the per-socket workqueue on rel=
ease
* [PATCH 5.15 219/319] hwmon: (aht10) Fix update_interval overflow on 64-bi=
t
* [PATCH 5.15 220/319] s390/dasd: Fix wrong free and refcount leak in build=
_check_tcw error path
* [PATCH 5.15 221/319] s390/dasd: Dont trust userspace-supplied result fiel=
d in format check
* [PATCH 5.15 222/319] sctp: abort unordered partial delivery when its mess=
age is skipped
* [PATCH 5.15 223/319] sctp: avoid requeueing pending control chunks
* [PATCH 5.15 224/319] sctp: fix ASCONF address change on single-homed host=
s
* [PATCH 5.15 225/319] sctp: fix I-FORWARD-TSN handling of fragments on oth=
er streams
* [PATCH 5.15 226/319] sctp: report the partially delivered MID in PARTIAL_=
DELIVERY_ABORTED
* [PATCH 5.15 227/319] sctp: reset stored flag for each association
* [PATCH 5.15 228/319] tracing/eprobe: Fix 1-byte signed field fetch in get=
_event_field()
* [PATCH 5.15 229/319] wifi: ath9k_htc: do not start ANI before the first c=
hannel is set
* [PATCH 5.15 230/319] wifi: cfg80211: release rejected nontransmitted BSS =
reference
* [PATCH 5.15 231/319] wifi: cfg80211: dont truncate the merged MBSSID prof=
ile length
* [PATCH 5.15 232/319] wifi: mac80211: recheck injected headers after remov=
ing FCS
* [PATCH 5.15 233/319] wifi: mac80211: recheck the IBSS station limit befor=
e insertion
* [PATCH 5.15 234/319] wifi: mac80211: recheck the OCB station limit before=
 insertion
* [PATCH 5.15 235/319] wifi: mac80211: bound pending IBSS station allocatio=
ns
* [PATCH 5.15 236/319] wifi: mac80211: bound pending OCB station allocation=
s
* [PATCH 5.15 237/319] gpio: brcmstb: fix UAF after IRQ domain setup failur=
e
* [PATCH 5.15 238/319] gpio: rockchip: Fix debounce arithmetic for GPIO v2
* [PATCH 5.15 239/319] gpio: sodaville: fix use-after-free bug when registe=
ring the irqchip
* [PATCH 5.15 240/319] dm log userspace: drop the device reference on error
* [PATCH 5.15 241/319] dm cache: reject kcopyd client destory if it setup f=
ailed
* [PATCH 5.15 242/319] dm crypt: fix use of uninitialized percpu_counter in=
 ctr error path
* [PATCH 5.15 243/319] dm mpath: fix buffer overflow in parse_hw_handler()
* [PATCH 5.15 244/319] dm mpath: cap queue_if_no_path_timeout_secs
* [PATCH 5.15 245/319] dm thin: avoid wrapping no_space_timeout
* [PATCH 5.15 246/319] dm-sysfs: fix misbehavior if kobject_init_and_add fa=
ils
* [PATCH 5.15 247/319] dm persistent data: dont leak bufio buffer if find_l=
eaf fails
* [PATCH 5.15 248/319] dm snapshot: fix discard writing into the next COW c=
hunk
* [PATCH 5.15 249/319] dm zoned: back off when reclaim cannot make progress
* [PATCH 5.15 250/319] dm zoned: do not reclaim a random zone into another =
random zone
* [PATCH 5.15 251/319] dm-cache: fix NULL pointer dereference on open failu=
re
* [PATCH 5.15 252/319] dm-cache: fix ending a cursor that never began
* [PATCH 5.15 253/319] dm-integrity: dont recalculate with HMAC because of =
a dirty bitmap
* [PATCH 5.15 254/319] dm-integrity: dont attempt to commit journal on disa=
bled device
* [PATCH 5.15 255/319] dm-raid: bound array_position before indexing failed=
_devices
* [PATCH 5.15 256/319] dm-thin: fix leak if __set_snapshot_details fails
* [PATCH 5.15 257/319] dm-thin: fix parsing of feature arguments
* [PATCH 5.15 258/319] vt: serialise the producers of the flip buffer
* [PATCH 5.15 259/319] comedi: addi_apci_1500: fix clearing of the gate ena=
ble
* [PATCH 5.15 260/319] comedi: ni_660x: dont poll without a DMA channel
* [PATCH 5.15 261/319] comedi: ni_tio: Fix overflow of the clock period
* [PATCH 5.15 262/319] comedi: vmk80xx: report failed transfers of the K806=
1
* [PATCH 5.15 263/319] iio: hid-sensors: fix a division by zero
* [PATCH 5.15 264/319] misc: bcm-vk: fix DMA allocation memory leak
* [PATCH 5.15 265/319] misc: ibmvmc: initialize HMC state before device reg=
istration
* [PATCH 5.15 266/319] serial: 8250_lpss: dont divide by 0 above 6.25 Mbaud
* [PATCH 5.15 267/319] serial: samsung: dont leak the tty on an RX IRQ
* [PATCH 5.15 268/319] serial: samsung: put the previous baud clock
* [PATCH 5.15 269/319] usb: pci-quirks: always assert xHCI OS ownership
* [PATCH 5.15 270/319] USB: serial: garmin_gps: fix deadlock on reset reque=
st
* [PATCH 5.15 271/319] USB: serial: oti6858: fix the teardown order in clos=
e
* [PATCH 5.15 272/319] usb: uas: ignore UAS for ASMT135x bridges (174c:55aa=
)
* [PATCH 5.15 273/319] usb: usbtest: prevent divide by zero in simple_io() =
with zero length
* [PATCH 5.15 274/319] usb: gadget: f_mass_storage: take filesem in nofua s=
tore to fix backing-file UAF
* [PATCH 5.15 275/319] usb: gadget: f_midi: fix UAF race during IN request =
handling
* [PATCH 5.15 276/319] usb: gadget: f_ncm: restart the TX timer if the TX f=
reelist is empty
* [PATCH 5.15 277/319] usb: gadget: u_serial: fix NULL deref in gs_close() =
after failed open
* [PATCH 5.15 278/319] usb: dwc3: gadget: Clear delayed stop on End Transfe=
r completion
* [PATCH 5.15 279/319] usb: dwc3: gadget: Recover from End Transfer timeout
* [PATCH 5.15 280/319] w1: dont hold list_mutex while a slave is torn down
* [PATCH 5.15 281/319] w1: ds2482: set the strong pull-up with its byte
* [PATCH 5.15 282/319] w1: ds2805: use the bus mutex to talk on the bus
* [PATCH 5.15 283/319] w1: ds28e04: use the bus mutex to talk on the bus
* [PATCH 5.15 284/319] w1: netlink: drop the slave after the bus is unlocke=
d
* [PATCH 5.15 285/319] w1: remove the masters files before taking its locks
* [PATCH 5.15 286/319] w1: use the bus mutex for the "rw" file
* [PATCH 5.15 287/319] w1: w1_therm: leave the slaves of other families alo=
ne
* [PATCH 5.15 288/319] USB: serial: garmin_gps: validate packet data length=
 in nat_receive()
* [PATCH 5.15 289/319] USB: serial: sierra: validate URB length in instat c=
allback
* [PATCH 5.15 290/319] USB: serial: io_edgeport: fix NULL-deref on early st=
atus
* [PATCH 5.15 291/319] USB: serial: io_edgeport: fix potential close() use-=
after-free
* [PATCH 5.15 292/319] USB: serial: io_edgeport: fix potential NULL-deref a=
t open
* [PATCH 5.15 293/319] USB: serial: io_edgeport: fix potential fifo corrupt=
ion
* [PATCH 5.15 294/319] USB: serial: io_edgeport: fix potential use-after-fr=
ee on disconnect
* [PATCH 5.15 295/319] USB: serial: io_edgeport: serialise MCR accesses
* [PATCH 5.15 296/319] iio: accel: kxsd9: Fix potential use-after-free on r=
emoval
* [PATCH 5.15 297/319] iio: afe: rescale: expose offset if rescaler or sour=
ce has one
* [PATCH 5.15 298/319] iio: atlas-ezo: Fix humidity channel read support
* [PATCH 5.15 299/319] iio: dac: mcp4725: Update the cached DAC value only =
on success
* [PATCH 5.15 300/319] iio: gyro: bmg160: reject duplicate event disable
* [PATCH 5.15 301/319] iio: hid-sensor: Fix scale for magnetic north headin=
g
* [PATCH 5.15 302/319] iio: hid-sensors: fix fractional part for unit expon=
ents -7 and -8
* [PATCH 5.15 303/319] iio: humidity: am2315: fix negative temperature deco=
ding
* [PATCH 5.15 304/319] iio: imu: inv_mpu6050: fix magnetometer scale of Y a=
nd Z axes
* [PATCH 5.15 305/319] iio: imu: kmx61: reject duplicate event disable
* [PATCH 5.15 306/319] iio: light: tsl2591: dont divide by zero
* [PATCH 5.15 307/319] iio: light: vcnl4035: Fix reversed ALS mode bit
* [PATCH 5.15 308/319] iio: magnetometer: mmc35240: leave cache-only mode b=
efore the cache sync
* [PATCH 5.15 309/319] iio: trigger: Return an error when the trigger has n=
o free irq
* [PATCH 5.15 310/319] sctp: fix skb_over_panic when adding addresses with =
a pending delete of another family
* [PATCH 5.15 311/319] nvme: fix deadlock on nvme_subsystems_lock in nvme_i=
nit_subsystem()
* [PATCH 5.15 312/319] tcp: fix NULL pointer dereference when restarting a =
Fast Open listener
* [PATCH 5.15 313/319] powerpc/watchdog: disable watchdog when watchdog_thr=
esh=3D0
* [PATCH 5.15 314/319] ARM: 9359/1: flush: check if the folio is reserved f=
or no-mapping addresses
* [PATCH 5.15 315/319] vfio/platform: prevent read-only region mappings fro=
m becoming writable
* [PATCH 5.15 316/319] vfio/fsl-mc: prevent read-only region mappings from =
becoming writable
* [PATCH 5.15 317/319] fs/stat.c: avoid harmless garbage value problem in v=
fs_statx_path()
* [PATCH 5.15 318/319] bootconfig: Trim unquoted values at end of file
* [PATCH 5.15 319/319] Bluetooth: hci_core: Fix not checking skb length on =
hci_scodata_packet

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/d03e0968-5f1a-43c5-b83a-652de46b73d9

***

kernel build error

tree:      stable
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/stable/=
linux-stable.git
base:      4f2df9a01754521fbba3493e8ad91ef65515e68c
arch:      amd64
compiler:  Debian clang version 22.1.8 (1~deb13u4), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/7a55fe70-1cd8-4335-a347-a62ee186abf=
e/config

scripts/bpf_doc.py:55: SyntaxWarning: invalid escape sequence '\w'
scripts/bpf_doc.py:57: SyntaxWarning: invalid escape sequence '\*'
scripts/bpf_doc.py:104: SyntaxWarning: invalid escape sequence '\*'
scripts/bpf_doc.py:108: SyntaxWarning: invalid escape sequence '\*'
scripts/bpf_doc.py:123: SyntaxWarning: invalid escape sequence '\*'
scripts/bpf_doc.py:131: SyntaxWarning: invalid escape sequence '\*'
scripts/bpf_doc.py:145: SyntaxWarning: invalid escape sequence '\*'
scripts/bpf_doc.py:154: SyntaxWarning: invalid escape sequence '\*'
scripts/bpf_doc.py:168: SyntaxWarning: invalid escape sequence '\*'
scripts/bpf_doc.py:375: SyntaxWarning: invalid escape sequence '\ '
scripts/bpf_doc.py:457: SyntaxWarning: invalid escape sequence '\ '
init/do_mounts_rd.c:277:2: error: call to undeclared function 'init_flush_f=
put'; ISO C99 and later do not support implicit function declarations [-Wim=
plicit-function-declaration]

***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[achill@achill.org akpm@linux-foundation.org broonie@kernel.org conor@kerne=
l.org f.fainelli@gmail.com gregkh@linuxfoundation.org hargar@microsoft.com =
jonathanh@nvidia.com linux-kernel@vger.kernel.org linux@roeck-us.net lkft-t=
riage@lists.linaro.org patches@kernelci.org patches@lists.linux.dev pavel@n=
abladev.com rwarsow@gmx.de shuah@kernel.org sr@sladewatkins.com stable@vger=
.kernel.org sudipm.mukherjee@gmail.com torvalds@linux-foundation.org]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

