Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.167.197
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795708503;
	b=qpwT0s90sQq32VlcSNE38y7D5TFtSz6cCMKKOGfCNgVLThgYV/9Sga4YAjN0PhOsWG9U
	 FEWKlwM70RGIFx/URoqXqzCojHqgFGyvNPM4KB8A/3sU3bzT4408yiAEwkDG/WEbyQmAD
	 GH7gdWoLdXDI4YHmvP0Ua0IPDbQEhO6wAn0YGuY6nNrcch5T4QeMNNlxFEV89agjq7RDj
	 /u5Fqjbhc2vRC2g4a74gnmfHX4Nwa/eswXJD/32RZsW3kU+nvjU0dUNfQis3XTIicrb9F
	 EuhSaqD/m3wY+2CsUoCdrTNodw9pezfvUNoR3ELhDIxUOFOAPd/emd0EnetTyW1caSg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795708503;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 MIME-Version:X-Received:Date:X-Google-Appengine-App-Id:
	 X-Google-Appengine-App-Id-Alias:Message-ID:Subject:From:To:Cc:
	 Content-Type:Content-Transfer-Encoding;
	bh=bbzu/R5YwRrglVLb4EBFEDj4K2Qx3xFd4YS1Tx5wHFk=;
	b=esuUZUO/2GN7WzdIg7TZMy9s/Z+zXeFjsPoqdPXfupSoXukXDKCx/pBUtTnjPj/Mwr2K
	 eF54/LuWQILvEPnWO68x/xElepxzK1W333Itu2YzTPGe/aAgbvfdCuSPExCu9o5NjoLtg
	 BWJLsBrhAEGGyVs/SkPo9xSWWEAmuuRSywAHjtRd0hbg1S0Y/nDRYl1WZXZ4lcpP4MMiB
	 vfGmH28skwmgkU6svgfdvr1+dEL14n9VTZIRfMJ4jz8Dy67FIdymkShbuFU6I8zvtOshX
	 /IU9BFA0CixuUOCilzBDJV6G/yBFF0UW3u4bzHj98G1g/aE4V6Qk/LMK6bKHFEiUVOA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=syzkaller.appspotmail.com;
	spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	arc=none smtp.remote-ip=209.85.167.197
Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com [209.85.167.197])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 992A9606A323
	for <syzbot@lists.linux.dev>; Thu, 26 Nov 2026 15:55:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 992A9606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f197.google.com with SMTP id 5614622812f47-57489477aabso7034473b6e.1
        for <syzbot@lists.linux.dev>; Thu, 26 Nov 2026 07:55:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795708501; x=1796313301;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:date:mime-version:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=bbzu/R5YwRrglVLb4EBFEDj4K2Qx3xFd4YS1Tx5wHFk=;
        b=ECjPeb3FTN9OPjiRQNLK6AcTDIN/WQc/Wtoyn6QawlHf29A54ifcSpG3GFps7To2fx
         ks8T/P4Ht4z9b/UWWUGJ9PrBcnDci4vPl0XJMuZv8NXbXZq1tRRPnJZKeisXTkiO//DU
         GI05Qf5oIuF+WefFLz8C1AEmiF1NpfQt/ljcg08s1uRJKV9/jB1D1CoBxv1/lKbRe9wy
         Ho/x9KVLRWTXiisCRtKLb7hnOvmfUYEQJsUBKNydfUlf5jOuyWFtBT6r1ncu1IPCX4IX
         0drDlJsTk5UdwYFNy+Pp9O7yOu+8H4vuFTu0pZHqfmT+2lWax3H2iSLkkr6l0umBIgmK
         sc4Q==
X-Gm-Message-State: APuU4Z9dUai//U7nH1k4gSIjK96j+q6/ExIGQkCh1ZGSRn3OTU/LAjjt
	QDcw/cx5OPR8qhxCIBnAaxXeM3v2MUr/EExM6HA3DS3l0642TtuUY4NXPTB0msKCyKtTIgFuJTa
	4ekLsIZwmwvUyySmEelBsHpKlY4KqvM0L6rM3JIeSMRHzsIJsIseDcni6/KU=
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Post: <mailto:syzbot@lists.linux.dev>
List-Help: <mailto:syzbot+help@lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
List-Owner: <mailto:syzbot+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-Received: by 2002:a05:6808:1a0c:b0:55c:856:8216 with SMTP id
 5614622812f47-57a09400cd4mr22925443b6e.37.1795708501631; Thu, 26 Nov 2026
 07:55:01 -0800 (PST)
Date: Thu, 26 Nov 2026 07:55:01 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6b085655.de3f39fe.14ea85.0105.GAE@google.com>
Subject: [moderation/CI] Re: 5.10.276-rc1 review
From: syzbot ci <syzbot+ciaf1e7ddb4961a498@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v1] 5.10.276-rc1 review
https://lore.kernel.org/all/20261126143605.076581697@linuxfoundation.org
* [PATCH 5.10 001/265] media: uvcvideo: Undup use uvc_endpoint_max_bpi() co=
de
* [PATCH 5.10 002/265] netfilter: nft_ct: expectation timeouts are passed i=
n milliseconds
* [PATCH 5.10 003/265] netfilter: nft_ct: move custom expectation support t=
o helper
* [PATCH 5.10 004/265] mm/khugepaged: preserve dirty bits when collapsing P=
TE-mapped THPs
* [PATCH 5.10 005/265] mt76: mt7615: Fix memory leak in mt7615_mcu_wtbl_sta=
_add()
* [PATCH 5.10 006/265] net: ravb: Fix missing rtnl lock in suspend/resume p=
ath
* [PATCH 5.10 007/265] i3c: master: Fix recursive locking during device reg=
istration
* [PATCH 5.10 008/265] drm/amdgpu: Check cs flags.
* [PATCH 5.10 009/265] vdpa: factor out vhost_vdpa_pa_map() and vhost_vdpa_=
pa_unmap()
* [PATCH 5.10 010/265] vhost/vdpa: reject overflowing PA map page counts on=
 32-bit
* [PATCH 5.10 011/265] vhost-vdpa: fix pinned page leak in vhost_vdpa_pa_ma=
p() error path
* [PATCH 5.10 012/265] ARM: OMAP2+: omap4-common: Fix refcount leak bug
* [PATCH 5.10 013/265] ASoC: mt6359: Fix refcount leak bug
* [PATCH 5.10 014/265] virtio-blk: fix implicit overflow on virtio_max_dma_=
size
* [PATCH 5.10 015/265] remoteproc: imx_rproc: Fix refcount leak in imx_rpro=
c_addr_init
* [PATCH 5.10 016/265] fs: aio: reject partial mremap to avoid Null-pointer=
-dereference error
* [PATCH 5.10 017/265] ASoC: rt7*-sdw: harden jack_detect_handler
* [PATCH 5.10 018/265] udf: validate VAT inode size for old VAT format
* [PATCH 5.10 019/265] udf: validate vat20->lengthHeader and VAT inode size=
 in udf_load_vat()
* [PATCH 5.10 020/265] Input: destroy force-feedback device on input unregi=
stration
* [PATCH 5.10 021/265] staging: media: atomisp: use array3_size() for overf=
low-safe allocation
* [PATCH 5.10 022/265] xfrm: zero-initialise km_event in the replay-notify =
path
* [PATCH 5.10 023/265] batman-adv: avoid WARN_ON for orig_ifinfo allocation=
 failure
* [PATCH 5.10 024/265] wifi: ath9k_htc: start ANI when an AP interface begi=
ns to beacon
* [PATCH 5.10 025/265] scsi: aic7xxx: Fix REQUEST SENSE allocation length o=
n big-endian hosts
* [PATCH 5.10 026/265] ath10k: turn rawmode into frame_mode
* [PATCH 5.10 027/265] ath10k: add encapsulation offloading support
* [PATCH 5.10 028/265] wifi: ath10k: Fix miscellaneous spelling errors
* [PATCH 5.10 029/265] wifi: ath10k: Stop unanswered temperature reads
* [PATCH 5.10 030/265] gpio: omap: Propagate runtime PM failures in probe a=
nd request
* [PATCH 5.10 031/265] btrfs: scrub: fix lost wakeup and hang when cancelli=
ng a scrub that is finishing
* [PATCH 5.10 032/265] scsi: target: Validate REGISTER AND MOVE TransportID=
 length
* [PATCH 5.10 033/265] tipc: reject attaching bearer of different media to =
the same occupied device
* [PATCH 5.10 034/265] spi: pic32-sqi: fail transfer when the BD ring is ex=
hausted
* [PATCH 5.10 035/265] bpf: Dont let bpf_skb_adjust_room() raise gso_size t=
o GSO_BY_FRAGS
* [PATCH 5.10 036/265] bpf: Reject non-IPv6 packets in BPF_LWT_ENCAP_SEG6
* [PATCH 5.10 037/265] bpf: Limit the SRH length in bpf_lwt_seg6_adjust_srh=
()
* [PATCH 5.10 038/265] bpf: Move the MAC header in bpf_lwt_seg6_adjust_srh(=
)
* [PATCH 5.10 039/265] bpf: Dont leave a stale MAC header in bpf_lwt_push_i=
p_encap()
* [PATCH 5.10 040/265] bpf: Move the transport header with the moved header=
s
* [PATCH 5.10 041/265] bpf: lwt: Free the skb when bpf_xmit() fails to expa=
nd the headroom
* [PATCH 5.10 042/265] sfc: ptp: drop the stale frequency reset in efx_ptp_=
start()
* [PATCH 5.10 043/265] sfc: ptp: serialize host and MC synchronization tran=
sactions
* [PATCH 5.10 044/265] sfc: ptp: avoid racing PPS timestamp updates
* [PATCH 5.10 045/265] vhost-scsi: preserve event ordering
* [PATCH 5.10 046/265] vhost-iotlb: Add an opaque pointer for vhost IOTLB
* [PATCH 5.10 047/265] vhost: fix hung thread due to erroneous iotlb entrie=
s
* [PATCH 5.10 048/265] vhost: allow batching hint without size
* [PATCH 5.10 049/265] vhost: Allow null msg.size on VHOST_IOTLB_INVALIDATE
* [PATCH 5.10 050/265] vhost: reject invalid IOTLB update permissions
* [PATCH 5.10 051/265] regmap: teach regmap to use raw spinlocks if request=
ed in the config
* [PATCH 5.10 052/265] regulator: qcom_spmi: Drop unnecessary of_find_prope=
rty() call
* [PATCH 5.10 053/265] regulator: qcom_spmi: dont take a sleeping lock in t=
he SAW IPI
* [PATCH 5.10 054/265] net/iucv: take a private, writable frame before rewr=
iting it in place
* [PATCH 5.10 055/265] Bluetooth: hci_core: Initialize IRK before publicati=
on
* [PATCH 5.10 056/265] Bluetooth: hci_core: Initialize link key before publ=
ication
* [PATCH 5.10 057/265] Bluetooth: hci_core: Initialize LTK before publicati=
on
* [PATCH 5.10 058/265] Bluetooth: btintel: fix buffer over-read in fw paylo=
ad
* [PATCH 5.10 059/265] Bluetooth: hci_core: Keep link-key filtering inside =
RCU
* [PATCH 5.10 060/265] vhost-scsi: validate event queue descriptor directio=
n
* [PATCH 5.10 061/265] vhost-scsi: reject delayed virtqueue setup
* [PATCH 5.10 062/265] vhost: reject backend enable without a kick file
* [PATCH 5.10 063/265] block: partitions: reject GPT entries with starting_=
lba > ending_lba
* [PATCH 5.10 064/265] null_blk: improve zone locking
* [PATCH 5.10 065/265] null_blk: Improve implicit zone close
* [PATCH 5.10 066/265] null_blk: fix opening closed zones at the active zon=
e limit
* [PATCH 5.10 067/265] net: dsa: b53: Enable IGMP and MLD control packet CP=
U copies
* [PATCH 5.10 068/265] nvmet-rdma: take a device off the list last
* [PATCH 5.10 069/265] nvmet-rdma: queue the release work under the mutex
* [PATCH 5.10 070/265] nvme-tcp: handle number of queue changes
* [PATCH 5.10 071/265] nvme: fix various comment typos
* [PATCH 5.10 072/265] nvmet-rdma: disconnect a queue on device removal
* [PATCH 5.10 073/265] tcp: Fix dup-ack detection on non-SACK bidirectional=
 data transfer.
* [PATCH 5.10 074/265] net: skbuff: reject zero MPLS TTL before decrementin=
g
* [PATCH 5.10 075/265] PM: runtime: Fix check_flush_dependency warning from=
 pm_runtime_remove
* [PATCH 5.10 076/265] net: ipv6: use the new fib6_nh_release_dsts helper i=
n fib6_nh_release
* [PATCH 5.10 077/265] ipv6: Flush exception route while replacing nexthop.
* [PATCH 5.10 078/265] ipv4: Call rt_add_uncached_list() if !do_cache in ip=
_route_input_slow().
* [PATCH 5.10 079/265] ACPI: scan: Print the offline failure message in acp=
i_bus_offline()
* [PATCH 5.10 080/265] Bluetooth: L2CAP: Clear request identifiers on incom=
ing LE connections
* [PATCH 5.10 081/265] net: ethernet: bgmac: preserve forced 2.5 Gbps link =
speed
* [PATCH 5.10 082/265] net: dsa: b53: Force flow control for BCM5301X CPU p=
ort(s)
* [PATCH 5.10 083/265] net: dsa: b53: restore the NSP IMP port 2 Gbps mode
* [PATCH 5.10 084/265] ALSA: hda/core: Stop capability walk on empty capabi=
lity header
* [PATCH 5.10 085/265] net: 8139cp: keep Rx masked while NAPI is scheduled
* [PATCH 5.10 086/265] bonding: 3ad: dont set BOND_LINK_FAIL on a slave tha=
t is not up
* [PATCH 5.10 087/265] netfilter: x_tables: check target name before access=
ing verdict
* [PATCH 5.10 088/265] netfilter: nf_conntrack_sip: fix OOB read in ct_sip_=
parse_transport()
* [PATCH 5.10 089/265] netfilter: nat: zero newrange before filling it in
* [PATCH 5.10 090/265] MIPS: Avoid dead code/data elimination when using re=
cordmcount
* [PATCH 5.10 091/265] MIPS: Alchemy: Save the Ethernet address before reus=
ing PROM memory
* [PATCH 5.10 092/265] MIPS: SB1250: Validate and update IRQ affinity
* [PATCH 5.10 093/265] initrd: flush deferred fput() before mounting root
* [PATCH 5.10 094/265] vfs: preserve subsecond timestamps at filesystem tim=
e limits
* [PATCH 5.10 095/265] include/linux/fs.h: add inode_lock_killable()
* [PATCH 5.10 096/265] fs/read_write: make default_llseek() killable
* [PATCH 5.10 097/265] fs: reject negative offsets for SEEK_DATA and SEEK_H=
OLE in default_llseek()
* [PATCH 5.10 098/265] sched/pelt: Fix u32 truncation of the PELT period co=
unt
* [PATCH 5.10 099/265] locking/osq_lock: Clarify osq_wait_next() calling co=
nvention
* [PATCH 5.10 100/265] locking/osq: Switch osq_wait_next()/atomic_cmpxchg()=
 ordering
* [PATCH 5.10 101/265] locking/osq: Fix unlink queue corruption
* [PATCH 5.10 102/265] cpufreq: Replace deprecated CPU-hotplug functions
* [PATCH 5.10 103/265] cpufreq: Return -EOPNOTSUPP if no policy supports bo=
ost
* [PATCH 5.10 104/265] cpufreq: Preserve global boost state on failed updat=
es
* [PATCH 5.10 105/265] cpufreq: Serialize global boost updates
* [PATCH 5.10 106/265] Bluetooth: reject invalid LE supervision timeout rel=
ationships
* [PATCH 5.10 107/265] net/mlx5e: IPoIB, Fix QPN lookup race
* [PATCH 5.10 108/265] calipso: do not charge request socket options to the=
 listener
* [PATCH 5.10 109/265] ipv6: ICMPV6: Use swap() instead of open coding it
* [PATCH 5.10 110/265] ipv6: Check the Home Address option again before its=
 address is used
* [PATCH 5.10 111/265] ata: libata-scsi: fix MODE SELECT handling of data a=
fter the mode page
* [PATCH 5.10 112/265] ata: libata-scsi: Simplify ata_scsi_mode_select_xlat=
()
* [PATCH 5.10 113/265] ata: libata-scsi: reject MODE SELECT mode pages with=
 a wrong SPF bit
* [PATCH 5.10 114/265] ata: libata-scsi: fix MODE SELECT field pointer for =
block descriptor length
* [PATCH 5.10 115/265] gpiolib: of: return -ENOENT from of_gpio_count() stu=
b
* [PATCH 5.10 116/265] NFSv4.1: retain MDS I/O until both thresholds are me=
t
* [PATCH 5.10 117/265] SUNRPC: wake poll waiters when an empty pipe is unli=
nked
* [PATCH 5.10 118/265] SUNRPC: preserve timeout policy when cloning clients
* [PATCH 5.10 119/265] ipv6: ignore link state in gateway check
* [PATCH 5.10 120/265] team: Add matching error label for failed action
* [PATCH 5.10 121/265] team: fix promisc/allmulti leak in team_port_add err=
or path
* [PATCH 5.10 122/265] net: protect negative destination advice with RCU
* [PATCH 5.10 123/265] neigh: introduce neigh_confirm() helper function
* [PATCH 5.10 124/265] net: require a full socket in sock_confirm_neigh()
* [PATCH 5.10 125/265] tun: delete the flow entries of the moved queue on d=
etach
* [PATCH 5.10 126/265] ipv4: route: dont blackhole in-use routes when retir=
ing fnhe routes
* [PATCH 5.10 127/265] fou: gue: check IP version of held packets for direc=
t IP encapsulation
* [PATCH 5.10 128/265] drm/bridge: sii902x: validate I2S data lane values
* [PATCH 5.10 129/265] xen/grant-table: annotate on-stack work in gnttab_un=
map_refs_sync()
* [PATCH 5.10 130/265] ASoC: max98090: keep the MIC boost across mic input =
power-up
* [PATCH 5.10 131/265] tun: disallow setting IEEE 802.15.4 and 6LoWPAN link=
 types via TUNSETLINK
* [PATCH 5.10 132/265] tls: fix async encryption race on weakly ordered arc=
hitectures
* [PATCH 5.10 133/265] igmp: use the joined device when leaving a multicast=
 group
* [PATCH 5.10 134/265] net: usb: cdc_ncm: dont underflow the NDP room check
* [PATCH 5.10 135/265] tracing: skip boot kprobe setup when no events were =
requested
* [PATCH 5.10 136/265] docs, kprobes: Fix bracket
* [PATCH 5.10 137/265] KEYS: do not let an unmatched key decide the search =
result
* [PATCH 5.10 138/265] ALSA: aw2-alsa: select SND_PCM
* [PATCH 5.10 139/265] Xen/gnttab: improve error handling in gnttab_dma_{al=
loc,free}_pages()
* [PATCH 5.10 140/265] KEYS: Reject descriptions larger than KEY_MAX_DESC_S=
IZE
* [PATCH 5.10 141/265] KEYS: Verify the key identity in __key_unlink_begin
* [PATCH 5.10 142/265] bootconfig: Allow keys with the maximum supported de=
pth
* [PATCH 5.10 143/265] ALSA: caiaq: Kill EP1 URB before unregistering the i=
nput device
* [PATCH 5.10 144/265] ALSA: usb-audio: Drop capture packets with bogus act=
ual_length
* [PATCH 5.10 145/265] tracing/selftests: Fix false bashism in kprobe_non_u=
niq_symbol.tc
* [PATCH 5.10 146/265] mmc: mmci: fix DMA channel leak when mmc_add_host() =
fails
* [PATCH 5.10 147/265] mmc: meson-gx: report busy from DAT0 alone
* [PATCH 5.10 148/265] mmc: meson-gx: honour the busy timeout for R1b comma=
nds
* [PATCH 5.10 149/265] mmc: meson-gx: name the limit of the CMD_CFG timeout=
 field
* [PATCH 5.10 150/265] aio: dont let exit_aio() return before complete() is=
 done
* [PATCH 5.10 151/265] mm/mmzone: read the zoneref slot once in zonelist_zo=
ne()
* [PATCH 5.10 152/265] mm/page_alloc: detect zonelist rebuilds from memory =
hot-add
* [PATCH 5.10 153/265] net: dst_metadata: fix memcmp overread in skb_metada=
ta_dst_cmp
* [PATCH 5.10 154/265] ext4: avoid infinite loops caused by residual data
* [PATCH 5.10 155/265] net/rds: Do not unpin a page after a failed atomic p=
in
* [PATCH 5.10 156/265] net: bridge: use one headroom snapshot for ND replie=
s
* [PATCH 5.10 157/265] net: leave O_NONBLOCK to the sendmsg and recvmsg sys=
calls
* [PATCH 5.10 158/265] tls: only install push_pending_record for a TX conte=
xt
* [PATCH 5.10 159/265] ipv4: keep XFRM headers out of corked skb lengths
* [PATCH 5.10 160/265] ipv4: fib_trie: prevent speculative out-of-bounds ch=
ild access
* [PATCH 5.10 161/265] ipv6: fix cached route reuse for control messages
* [PATCH 5.10 162/265] ipv6: reject routes without an inet6_dev
* [PATCH 5.10 163/265] ipvs: Defer application parent freeing until after R=
CU readers
* [PATCH 5.10 164/265] ipvs: fix protocol data lifetime during namespace te=
ardown
* [PATCH 5.10 165/265] netfilter: xt_recent: do not call remove_proc_entry(=
) under recent_lock
* [PATCH 5.10 166/265] net/sched: sch_teql: reject qdiscs from another netw=
ork namespace
* [PATCH 5.10 167/265] net/sched: act_ife: encode configured zero metadata =
values
* [PATCH 5.10 168/265] PM: runtime: Update last_busy in rpm_resume() for ac=
tive devices
* [PATCH 5.10 169/265] Bluetooth: hci_qca: fix use-after-free in ibs debugf=
s files
* [PATCH 5.10 170/265] crypto: essiv - fix use-after-free in AEAD path
* [PATCH 5.10 171/265] fs/adfs: bound directory entry name length in adfs_f=
plus_getnext()
* [PATCH 5.10 172/265] fs/proc: fix the write length returned by proc_sys_c=
all_handler()
* [PATCH 5.10 173/265] cpufreq: acpi-cpufreq: fix P-state index mismatch in=
 extract_io()
* [PATCH 5.10 174/265] timekeeping: Read getboottime64() offsets under the =
sequence counter
* [PATCH 5.10 175/265] tpm: acpi: Fix memory leak at tpm_read_log_acpi() er=
ror path
* [PATCH 5.10 176/265] tpm: eventlog: check the payload size before reading=
 tag events
* [PATCH 5.10 177/265] x86/mm: Ensure write visibility during LDT installat=
ion
* [PATCH 5.10 178/265] xen/gntdev: fix deadlock between map ioctl and mmap
* [PATCH 5.10 179/265] xen/pvcalls: destroy the per-socket workqueue on rel=
ease
* [PATCH 5.10 180/265] s390/dasd: Fix wrong free and refcount leak in build=
_check_tcw error path
* [PATCH 5.10 181/265] s390/dasd: Dont trust userspace-supplied result fiel=
d in format check
* [PATCH 5.10 182/265] sctp: abort unordered partial delivery when its mess=
age is skipped
* [PATCH 5.10 183/265] sctp: avoid requeueing pending control chunks
* [PATCH 5.10 184/265] sctp: fix ASCONF address change on single-homed host=
s
* [PATCH 5.10 185/265] sctp: fix I-FORWARD-TSN handling of fragments on oth=
er streams
* [PATCH 5.10 186/265] sctp: report the partially delivered MID in PARTIAL_=
DELIVERY_ABORTED
* [PATCH 5.10 187/265] sctp: reset stored flag for each association
* [PATCH 5.10 188/265] wifi: ath9k_htc: do not start ANI before the first c=
hannel is set
* [PATCH 5.10 189/265] wifi: cfg80211: release rejected nontransmitted BSS =
reference
* [PATCH 5.10 190/265] wifi: cfg80211: dont truncate the merged MBSSID prof=
ile length
* [PATCH 5.10 191/265] wifi: mac80211: recheck injected headers after remov=
ing FCS
* [PATCH 5.10 192/265] wifi: mac80211: recheck the IBSS station limit befor=
e insertion
* [PATCH 5.10 193/265] wifi: mac80211: recheck the OCB station limit before=
 insertion
* [PATCH 5.10 194/265] wifi: mac80211: bound pending IBSS station allocatio=
ns
* [PATCH 5.10 195/265] wifi: mac80211: bound pending OCB station allocation=
s
* [PATCH 5.10 196/265] gpio: brcmstb: fix UAF after IRQ domain setup failur=
e
* [PATCH 5.10 197/265] gpio: sodaville: fix use-after-free bug when registe=
ring the irqchip
* [PATCH 5.10 198/265] dm log userspace: drop the device reference on error
* [PATCH 5.10 199/265] dm cache: reject kcopyd client destory if it setup f=
ailed
* [PATCH 5.10 200/265] dm crypt: fix use of uninitialized percpu_counter in=
 ctr error path
* [PATCH 5.10 201/265] dm mpath: fix buffer overflow in parse_hw_handler()
* [PATCH 5.10 202/265] dm mpath: cap queue_if_no_path_timeout_secs
* [PATCH 5.10 203/265] dm thin: avoid wrapping no_space_timeout
* [PATCH 5.10 204/265] dm-sysfs: fix misbehavior if kobject_init_and_add fa=
ils
* [PATCH 5.10 205/265] dm persistent data: dont leak bufio buffer if find_l=
eaf fails
* [PATCH 5.10 206/265] dm snapshot: fix discard writing into the next COW c=
hunk
* [PATCH 5.10 207/265] dm zoned: back off when reclaim cannot make progress
* [PATCH 5.10 208/265] dm zoned: do not reclaim a random zone into another =
random zone
* [PATCH 5.10 209/265] dm-cache: fix NULL pointer dereference on open failu=
re
* [PATCH 5.10 210/265] dm-cache: fix ending a cursor that never began
* [PATCH 5.10 211/265] dm-integrity: dont attempt to commit journal on disa=
bled device
* [PATCH 5.10 212/265] dm-raid: bound array_position before indexing failed=
_devices
* [PATCH 5.10 213/265] dm-thin: fix leak if __set_snapshot_details fails
* [PATCH 5.10 214/265] dm-thin: fix parsing of feature arguments
* [PATCH 5.10 215/265] iio: hid-sensors: fix a division by zero
* [PATCH 5.10 216/265] misc: ibmvmc: initialize HMC state before device reg=
istration
* [PATCH 5.10 217/265] serial: 8250_lpss: dont divide by 0 above 6.25 Mbaud
* [PATCH 5.10 218/265] serial: samsung: put the previous baud clock
* [PATCH 5.10 219/265] usb: pci-quirks: always assert xHCI OS ownership
* [PATCH 5.10 220/265] USB: serial: garmin_gps: fix deadlock on reset reque=
st
* [PATCH 5.10 221/265] USB: serial: oti6858: fix the teardown order in clos=
e
* [PATCH 5.10 222/265] usb: uas: ignore UAS for ASMT135x bridges (174c:55aa=
)
* [PATCH 5.10 223/265] usb: usbtest: prevent divide by zero in simple_io() =
with zero length
* [PATCH 5.10 224/265] usb: gadget: f_mass_storage: take filesem in nofua s=
tore to fix backing-file UAF
* [PATCH 5.10 225/265] usb: gadget: f_midi: fix UAF race during IN request =
handling
* [PATCH 5.10 226/265] usb: gadget: u_serial: fix NULL deref in gs_close() =
after failed open
* [PATCH 5.10 227/265] w1: dont hold list_mutex while a slave is torn down
* [PATCH 5.10 228/265] w1: ds2482: set the strong pull-up with its byte
* [PATCH 5.10 229/265] w1: ds2805: use the bus mutex to talk on the bus
* [PATCH 5.10 230/265] w1: ds28e04: use the bus mutex to talk on the bus
* [PATCH 5.10 231/265] w1: netlink: drop the slave after the bus is unlocke=
d
* [PATCH 5.10 232/265] w1: remove the masters files before taking its locks
* [PATCH 5.10 233/265] w1: use the bus mutex for the "rw" file
* [PATCH 5.10 234/265] w1: w1_therm: leave the slaves of other families alo=
ne
* [PATCH 5.10 235/265] USB: serial: garmin_gps: validate packet data length=
 in nat_receive()
* [PATCH 5.10 236/265] USB: serial: sierra: validate URB length in instat c=
allback
* [PATCH 5.10 237/265] USB: serial: io_edgeport: fix NULL-deref on early st=
atus
* [PATCH 5.10 238/265] USB: serial: io_edgeport: fix potential close() use-=
after-free
* [PATCH 5.10 239/265] USB: serial: io_edgeport: fix potential NULL-deref a=
t open
* [PATCH 5.10 240/265] USB: serial: io_edgeport: fix potential fifo corrupt=
ion
* [PATCH 5.10 241/265] USB: serial: io_edgeport: fix potential use-after-fr=
ee on disconnect
* [PATCH 5.10 242/265] USB: serial: io_edgeport: serialise MCR accesses
* [PATCH 5.10 243/265] iio: accel: kxsd9: Fix potential use-after-free on r=
emoval
* [PATCH 5.10 244/265] iio: atlas-ezo: Fix humidity channel read support
* [PATCH 5.10 245/265] iio: dac: mcp4725: Update the cached DAC value only =
on success
* [PATCH 5.10 246/265] iio: gyro: bmg160: reject duplicate event disable
* [PATCH 5.10 247/265] iio: hid-sensor: Fix scale for magnetic north headin=
g
* [PATCH 5.10 248/265] iio: hid-sensors: fix fractional part for unit expon=
ents -7 and -8
* [PATCH 5.10 249/265] iio: humidity: am2315: fix negative temperature deco=
ding
* [PATCH 5.10 250/265] iio: imu: inv_mpu6050: fix magnetometer scale of Y a=
nd Z axes
* [PATCH 5.10 251/265] iio: imu: kmx61: reject duplicate event disable
* [PATCH 5.10 252/265] iio: light: vcnl4035: Fix reversed ALS mode bit
* [PATCH 5.10 253/265] iio: magnetometer: mmc35240: leave cache-only mode b=
efore the cache sync
* [PATCH 5.10 254/265] iio: trigger: Return an error when the trigger has n=
o free irq
* [PATCH 5.10 255/265] sctp: fix skb_over_panic when adding addresses with =
a pending delete of another family
* [PATCH 5.10 256/265] nvme: fix deadlock on nvme_subsystems_lock in nvme_i=
nit_subsystem()
* [PATCH 5.10 257/265] tcp: fix NULL pointer dereference when restarting a =
Fast Open listener
* [PATCH 5.10 258/265] powerpc/watchdog: disable watchdog when watchdog_thr=
esh=3D0
* [PATCH 5.10 259/265] vhost: handle error while adding split ranges to iot=
lb
* [PATCH 5.10 260/265] vfio/platform: prevent read-only region mappings fro=
m becoming writable
* [PATCH 5.10 261/265] vfio/fsl-mc: prevent read-only region mappings from =
becoming writable
* [PATCH 5.10 262/265] fs/stat.c: avoid harmless garbage value problem in v=
fs_statx_path()
* [PATCH 5.10 263/265] bootconfig: Trim unquoted values at end of file
* [PATCH 5.10 264/265] Bluetooth: hci_core: Fix not checking skb length on =
hci_scodata_packet
* [PATCH 5.10 265/265] module: fix [e_shstrndx].sh_size=3D0 OOB access

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/9eee27ad-622f-4802-8bed-7f825e6fe655

***

kernel build error

tree:      stable
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/stable/=
linux-stable.git
base:      99112ea818e35b606397c84fbc05e6fadb6ea162
arch:      amd64
compiler:  Debian clang version 22.1.8 (1~deb13u4), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/3cca7c96-e6f8-4fa0-a59f-77e00128101=
4/config

scripts/bpf_helpers_doc.py:42: SyntaxWarning: invalid escape sequence '\w'
scripts/bpf_helpers_doc.py:44: SyntaxWarning: invalid escape sequence '\*'
scripts/bpf_helpers_doc.py:90: SyntaxWarning: invalid escape sequence '\*'
scripts/bpf_helpers_doc.py:98: SyntaxWarning: invalid escape sequence '\*'
scripts/bpf_helpers_doc.py:112: SyntaxWarning: invalid escape sequence '\*'
scripts/bpf_helpers_doc.py:121: SyntaxWarning: invalid escape sequence '\*'
scripts/bpf_helpers_doc.py:135: SyntaxWarning: invalid escape sequence '\*'
scripts/bpf_helpers_doc.py:290: SyntaxWarning: invalid escape sequence '\ '
scripts/bpf_helpers_doc.py:372: SyntaxWarning: invalid escape sequence '\ '
init/do_mounts_rd.c:277:2: error: implicit declaration of function 'init_fl=
ush_fput' [-Werror,-Wimplicit-function-declaration]

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

