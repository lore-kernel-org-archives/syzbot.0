Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.167.198
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792785378;
	b=vW85HmwVsKvV5IrZYjlKr/vyTbYTYB9x4G7AmntIcKOxmFO9r6A7l6rE8kJMDqadGKJO
	 ZZ5aeqaHRhyRPN0Zl9Hq/unelb3yknrnMQDkgUgozAZjOhfjbkH7dv8HmmRXjlCaNSl2f
	 8zRNHzGvZJWJFwmotJwLsFCwYT5tYY1zrgK8xqsij6zOdBiZGQaNTTQJwjfpvw135JLOG
	 yUQwgbrQOW/q3keC7EjYQQk6swucFlhrhdIPHZdBBq7xOwAFyldU9ueE4wtjK1dYuW5s0
	 lLvZhTsG69Ehpx2+RFTidb6ygLA8DtnqwRLHz7EfHQgpFL6Kc13WcqGtfCb/49WSxxA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792785378;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 MIME-Version:X-Received:Date:X-Google-Appengine-App-Id:
	 X-Google-Appengine-App-Id-Alias:Message-ID:Subject:From:To:Cc:
	 Content-Type:Content-Transfer-Encoding;
	bh=gpxqi/nRwmawImFJ+GsztdpFAoM716oXTpOkbUkHER8=;
	b=DlWP7DD7nJfDpj2KP2iSB63MvUBkzjr/PmKHFfwsFyoOSQ2ZnZwvFcgEJHrcRPw99mK9
	 wauWocIXvAPK1J8buYzxjdUNumX3vIOjBwCDf42AY2SkriZgcouIKDFmkx5ajn0g190+y
	 b061IgQSirB3v6UfC6GOFOo88BQXZzJ+k42OrbOhaF62nx5EbBmVK+gjfNU5ygJeObde+
	 SgN5kOfO0TTEy3o8IV+8iGqZQZSabSlq3oJ0VDninb+uthMG+C/TuiYMmzKzLOVnkBeWF
	 /xu2DjjDf2O4n4q3WaU5wJ33aJ7MAHK5nMj242Zm8jVKdeNnNBrdNZxoag1aGXkhCWA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=syzkaller.appspotmail.com;
	spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	arc=none smtp.remote-ip=209.85.167.198
Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com [209.85.167.198])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 000B2606BED7
	for <syzbot@lists.linux.dev>; Fri, 23 Oct 2026 19:56:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 000B2606BED7
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f198.google.com with SMTP id 5614622812f47-4e937c5bd4fso1128922b6e.2
        for <syzbot@lists.linux.dev>; Fri, 23 Oct 2026 12:56:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792785377; x=1793390177;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:date:mime-version:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=gpxqi/nRwmawImFJ+GsztdpFAoM716oXTpOkbUkHER8=;
        b=UXU3CjAs/ehmt9fnD/WaAbTUXuPaLJgnS8n60qPqyPIo7QeGbDb290GtxoRpH7UA0j
         o0AQOZ465bKSMmSuxfsoO6zljWgdAlYCQN7yGxwN2scB7BVHiRBydeRW3UyvZuhm45vp
         0Jy8B5ptHJml9E8nz74QU6fU+eba+p8TZ25KYzQxfmDSw13UjkYF3zSseIdDHAYyXkcj
         p8mLtrJeIXsUsELsnIPzQd1JWp7Gxl6nsJmOXMqAXFmu6UDX+Cfh1P4BFRHY2hJr6SLV
         yscJlvO7a6uSLcAiKKykdRXAr+ED8SBcmg3sAx/yHRJWUJzv6ERtjNNLht0lCC1Hw8Bw
         Zw1w==
X-Gm-Message-State: AFq9FYKY4tvLYdAnv8qDsZFqCJS+VcpNdXsiUqXpbr0qQD6nZz/HRt6K
	wx7z4x9jWmPLDszIbHg9g4rqAgMPZNDEtU2ZB4jTx8KsEhNcZFjGBYoVX3Q/g+Tr7t5Ue3siltr
	x9Ca5JZ8jYXZQXw8sPC6oIPcskh0VvQ0LcMJ4NhHC+4e//zvek7jdnRYvEiI=
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Post: <mailto:syzbot@lists.linux.dev>
List-Help: <mailto:syzbot+help@lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
List-Owner: <mailto:syzbot+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-Received: by 2002:a05:6808:14d3:b0:4d6:90f3:74ae with SMTP id
 5614622812f47-55c0038dea9mr165435b6e.46.1792785376990; Fri, 23 Oct 2026
 12:56:16 -0700 (PDT)
Date: Fri, 23 Oct 2026 12:56:16 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6adbbbe0.3f6e6ada.1e998b.0058.GAE@google.com>
Subject: [moderation/CI] Re: 7.2.13-rc1 review
From: syzbot ci <syzbot+ci1549a03dc4e08709@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v1] 7.2.13-rc1 review
https://lore.kernel.org/all/20261023163713.816071858@linuxfoundation.org
* [PATCH 7.2 001/242] ksmbd: exempt FSCTL_PIPE_TRANSCEIVE from the generic =
file-id lookup
* [PATCH 7.2 002/242] i2c: qcom-geni: Restore the source-clock selection po=
licy
* [PATCH 7.2 003/242] soc/tegra: fuse: Add missing newline to APBMISC error=
 message
* [PATCH 7.2 004/242] ARM: dts: ti/omap: dra7: fix PCIe PHY clock divider d=
efinition
* [PATCH 7.2 005/242] power: supply: Fix maintenance charge table kernel-do=
c
* [PATCH 7.2 006/242] power: supply: ds2780: Fix ds2780_get_capacity() retu=
rning raw value
* [PATCH 7.2 007/242] soc/tegra: pmc: Fix uninitialised clock rate
* [PATCH 7.2 008/242] Drivers: hv: Avoid infinite retry loop in init_vp_ind=
ex()
* [PATCH 7.2 009/242] x86/hyperv: Avoid using per-cpu output page in hv_api=
cid_to_vp_index()
* [PATCH 7.2 010/242] Drivers: hv: Dont reset VMBus connection state on err=
or/exit paths
* [PATCH 7.2 011/242] pinctrl: qcom: nord: fix GPIO interrupt target width
* [PATCH 7.2 012/242] pinctrl: qcom: hawi: Fix intr_target_width
* [PATCH 7.2 013/242] pinctrl: qcom: qcs8300: Fix intr_target_width
* [PATCH 7.2 014/242] ARM: configs: sama5: enable current Microchip KSZ DSA=
 symbols
* [PATCH 7.2 015/242] pinctrl: qcom: ipq5018: add missing pwm3 function on =
gpio13
* [PATCH 7.2 016/242] pinctrl: qcom: spmi-gpio: make direction changes excl=
usive
* [PATCH 7.2 017/242] tools/power turbostat: Warn, but dont Err on out-date=
d perf systems
* [PATCH 7.2 018/242] tools/power turbostat: Fix fd_perf leak on reset
* [PATCH 7.2 019/242] tools/power turbostat: Fix CWF PMT off-by-one
* [PATCH 7.2 020/242] tools/power turbostat: Fix PMT error path fd handling
* [PATCH 7.2 021/242] tools/power turbostat: Fix add_counter issue if > 24 =
counters.
* [PATCH 7.2 022/242] power: supply: generic-adc-battery: Fix temperature I=
IO channel conversion
* [PATCH 7.2 023/242] power: supply: core: prevent unregistering a power su=
pply while a callback runs
* [PATCH 7.2 024/242] pinctrl: qcom: ipq5018: replace gcc_plltest with pwm2=
 on gpio12
* [PATCH 7.2 025/242] pinctrl: sunxi: dt: do not accumulate npins across pr=
obe attempts
* [PATCH 7.2 026/242] drm/vc4: hdmi: Move packet RAM enable to PM runtime
* [PATCH 7.2 027/242] gpio: nct6694: Mark the GPIO controller as sleeping
* [PATCH 7.2 028/242] vsock: treat TCP_CLOSING as once-established
* [PATCH 7.2 029/242] net/rds: dont let the rdma_cm destroy an id RDS still=
 owns on route failure
* [PATCH 7.2 030/242] accel/amdxdna: Fix Kconfig invalid configuration
* [PATCH 7.2 031/242] ASoC: Intel: avs: Reset the stream unless it is alrea=
dy prepared
* [PATCH 7.2 032/242] ASoC: stm32: spdifrx: fix synchronization state check
* [PATCH 7.2 033/242] ASoC: cs42l56: Put the Limiter Cushion control on the=
 limiter register
* [PATCH 7.2 034/242] ASoC: cs42l52: Fix the NG Type Switch bit
* [PATCH 7.2 035/242] ASoC: pcm3168a: Fix the DAC zero flag polarity bit
* [PATCH 7.2 036/242] ASoC: max98371: Fix the Speaker DHT Min Volume bits
* [PATCH 7.2 037/242] ASoC: wm8978: Fix the 128x oversampling switch bits
* [PATCH 7.2 038/242] ASoC: nau8822: Fix the 128x oversampling switch bits
* [PATCH 7.2 039/242] regmap: Drop map lock during cache init and exit
* [PATCH 7.2 040/242] netlink: reset skb headers before unicast and multica=
st filtering
* [PATCH 7.2 041/242] accel/rocket: clear rdev on device init failure
* [PATCH 7.2 042/242] net/mlx5: HWS, release L2 to L3 tunnel reformats to t=
heir own pool
* [PATCH 7.2 043/242] net/mlx5: HWS, fix flow meter offset within its bulk
* [PATCH 7.2 044/242] ASoC: amd: yc: disable MSI on resume
* [PATCH 7.2 045/242] drm/xe: skip eviction of a BO with no resource
* [PATCH 7.2 046/242] drm/xe/oa: Zero OA buffer at allocation
* [PATCH 7.2 047/242] spi: tegra114: assert CS GPIO for every transfer in a=
 message
* [PATCH 7.2 048/242] nios2: fix __wsum type degradation in csum_fold()
* [PATCH 7.2 049/242] scsi: st: Save the visited block for the partition th=
e drive is in
* [PATCH 7.2 050/242] scsi: target: Disable interrupts while holding delaye=
d_cmd_lock
* [PATCH 7.2 051/242] scsi: target: iscsi: Fix race in discovery auth updat=
es
* [PATCH 7.2 052/242] sched/core: Call wakeup_preempt() for queued tasks du=
ring class change
* [PATCH 7.2 053/242] entry: Account the deferred hrtimer rearm as hardirq =
context for lockdep
* [PATCH 7.2 054/242] iommupt/kunit: Use if_changed_rule for the kunit
* [PATCH 7.2 055/242] drm/panthor: fix immortalis condition
* [PATCH 7.2 056/242] ocfs2/dlm: Protect the recovery list during debugfs r=
eads
* [PATCH 7.2 057/242] samples: pidfd: fix userprogs typo
* [PATCH 7.2 058/242] exit: fix lost-update race on the child_subreaper bit=
fields
* [PATCH 7.2 059/242] pipe: preserve existing fasync readers on writer setu=
p failure
* [PATCH 7.2 060/242] fs: add switch_fs_struct()
* [PATCH 7.2 061/242] fs: notice when init abandons fs sharing
* [PATCH 7.2 062/242] fs: add scoped_with_init_fs()
* [PATCH 7.2 063/242] fs: add real_fs to track tasks actual fs_struct
* [PATCH 7.2 064/242] fs: make userspace_init_fs a dynamically-initialized =
pointer
* [PATCH 7.2 065/242] fs: add umh argument to struct kernel_clone_args
* [PATCH 7.2 066/242] fs: pass flags to copy_fs()
* [PATCH 7.2 067/242] fs: let idle threads share init_fs
* [PATCH 7.2 068/242] tracing: Fix empty symbol names in simple_ring_buffer=
 undef check
* [PATCH 7.2 069/242] tracing: Fix simple_ring_buffer undef check on parisc
* [PATCH 7.2 070/242] tracing: Fix simple_ring_buffer undef check on sparc6=
4
* [PATCH 7.2 071/242] ring-buffer: Skip si_mem_available() for persistent a=
nd remote buffers
* [PATCH 7.2 072/242] tracing: probes: error if BTF is required but unavail=
able
* [PATCH 7.2 073/242] scsi: libsas: Fix SMP IO deadlock during HA resume
* [PATCH 7.2 074/242] netlink: avoid hashing the network namespace pointer
* [PATCH 7.2 075/242] net: hisilicon: hisi_femac: Move setting of netops to=
 fix crash
* [PATCH 7.2 076/242] net: hisilicon: hip04_eth: Move setting of netops to =
fix crash
* [PATCH 7.2 077/242] net: ethernet: actions: Move setting of netops to fix=
 crash
* [PATCH 7.2 078/242] net: mv643xx: move setting of netops to fix crash
* [PATCH 7.2 079/242] net: au1000: move setting of netops to fix crash
* [PATCH 7.2 080/242] net: ethoc: move setting of netops to fix crash
* [PATCH 7.2 082/242] net: ti: icssm-prueth: Move setting of netops to fix =
crash
* [PATCH 7.2 083/242] net: bcmgenet: unshare the skb before writing the con=
trol block
* [PATCH 7.2 084/242] calipso: keep BIG TCP payload_len in calipso_skbuff_s=
etattr()
* [PATCH 7.2 085/242] gpiolib: fix memory leak in gpiod_set_array_value_com=
plex() on error paths
* [PATCH 7.2 086/242] gpio: mxc: fix race between chained IRQ handler insta=
ll and probe completion
* [PATCH 7.2 087/242] gpio: mxc: fix both_edges bit operations
* [PATCH 7.2 088/242] gpio: mxc: fix wakeup_pads bit operations
* [PATCH 7.2 089/242] gpio: mxc: fix race between gpiochip registration and=
 IRQ domain setup
* [PATCH 7.2 090/242] ring-buffer: Use subbuf_order in available memory est=
imation
* [PATCH 7.2 091/242] net: stmmac: dwmac1000: clear the RGMII status interr=
upt
* [PATCH 7.2 092/242] perf/x86/intel/uncore: Fix DMR CXL CM invert filter
* [PATCH 7.2 093/242] perf: Fix perf_pmu_migrate_context() leaving events b=
ehind
* [PATCH 7.2 094/242] printk: Postpone kthread startup
* [PATCH 7.2 095/242] PCI: Ignore Immediate Readiness on Samsung 990 PRO an=
d 990 EVO Plus NVMe
* [PATCH 7.2 096/242] PCI: Dont treat ~0 as ready in pci_dev_wait() with RR=
S SV
* [PATCH 7.2 097/242] x86/insn-eval: Fix shadowed segment index in get_seg_=
reg_override_idx()
* [PATCH 7.2 098/242] firewire: core: fix race condition in split transacti=
on handling
* [PATCH 7.2 099/242] 9p: free the session after a grace period
* [PATCH 7.2 100/242] accel/rocket: search every core slot when a core is r=
emoved
* [PATCH 7.2 101/242] accel/rocket: search every core slot when looking up =
a scheduler
* [PATCH 7.2 102/242] afs: free the super info after a grace period
* [PATCH 7.2 103/242] ASoC: SOF: ipc4-topology: Fix shift-out-of-bounds for=
 aggregated ALH capture
* [PATCH 7.2 104/242] ASoC: SOF: sof-client: Use event-handler mutex consis=
tently
* [PATCH 7.2 105/242] autofs: ignore notification errors from a replaced pi=
pe
* [PATCH 7.2 106/242] bootconfig: give the footer size static_assert a mess=
age
* [PATCH 7.2 107/242] unicode: free the map after a grace period
* [PATCH 7.2 108/242] watch_queue: Fix note pool publication race in watch_=
queue_set_size()
* [PATCH 7.2 109/242] x86/kvm: Dont consume async #PF flags on a kernel #PF=
 in NMI context
* [PATCH 7.2 110/242] KVM: SEV: Fix page dirtying in sev_gmem_post_populate=
()
* [PATCH 7.2 111/242] KVM: nVMX: Reset MMU back to the root MMU if loading =
L2 state fails for !VM-Entry
* [PATCH 7.2 112/242] fsnotify: prevent mark additions during connector tea=
rdown
* [PATCH 7.2 113/242] pid_namespace: make zap_pid_ns_processes() freezable
* [PATCH 7.2 114/242] ext4: free the sbi after a grace period
* [PATCH 7.2 115/242] eventfs: Free the eventfs_inode after an rcu grace pe=
riod too
* [PATCH 7.2 116/242] ipc: drop the mqueue mount with kern_unmount() on set=
up failure
* [PATCH 7.2 117/242] ntfs3: free the sbi after a grace period
* [PATCH 7.2 118/242] namespace: a mount that copy_tree() leaves out cant t=
ake over a lock
* [PATCH 7.2 119/242] namei: test for a negative dentry the way traverse_mo=
unts() does
* [PATCH 7.2 120/242] futex: Fix mm reuse handling for FUT_OFF_MMSHARED
* [PATCH 7.2 121/242] lib/crypto: arm64: Fix lost Poly1305 carry when resum=
ing NEON state
* [PATCH 7.2 122/242] lib/crypto: poly1305: Use memzero_explicit() in poly1=
305_final()
* [PATCH 7.2 123/242] mshv_vtl: Check per-CPU register page before mmap
* [PATCH 7.2 124/242] net/sched: fix use-after-free in __tcf_action_put()
* [PATCH 7.2 125/242] net: rds: fix uninitialized trans dereference in CM e=
vent handler
* [PATCH 7.2 126/242] pinctrl: amd: Clear S4 wake bits when firmware has _A=
EI
* [PATCH 7.2 127/242] power: sequencing: qcom-wcn: power off WLAN at probe
* [PATCH 7.2 128/242] riscv: dts: microchip: beaglev-fire: remove double de=
finition of gpio interrupts
* [PATCH 7.2 129/242] sctp: revalidate output stream after association conn=
ect wait
* [PATCH 7.2 130/242] spi: imx: fix slab corruption from undersized DMA bou=
nce buffers
* [PATCH 7.2 131/242] tools/power turbostat: Read complete CPU lists
* [PATCH 7.2 132/242] tools: gpio: fix building from the top level with O=
=3D
* [PATCH 7.2 133/242] tracing/histograms: Reject non-stacktrace fields for =
synthetic stacktrace fields
* [PATCH 7.2 134/242] gpio: shared: fix use-after-free bug when adding shar=
ed proxies
* [PATCH 7.2 135/242] gpio: shared: gracefully handle no-device lookup of s=
hared GPIOs
* [PATCH 7.2 136/242] i2c: qcom-cci: Fix HALT_ACK reset request being dropp=
ed
* [PATCH 7.2 137/242] i2c: viai2c-wmt: Fix clock leak in wmt_i2c_probe()
* [PATCH 7.2 139/242] perf: Track the perf mlock gift separately
* [PATCH 7.2 140/242] perf: Update cgroup time when rotating multiplexed ev=
ents
* [PATCH 7.2 141/242] ring-buffer: Do not show buffer_meta for CPUs without=
 a buffer
* [PATCH 7.2 142/242] ring-buffer: Fix the sub-buffer array base in rb_meta=
_subbuf_idx()
* [PATCH 7.2 143/242] ring-buffer: Fix false warning in ring_buffer_map_get=
_reader()
* [PATCH 7.2 144/242] scsi: bsg: Pass reply_len to bsg_setup_queue() to fit=
 UFS ARPMB replies
* [PATCH 7.2 145/242] scsi: st: Fix use-after-free race between st_remove()=
 and st_open()
* [PATCH 7.2 146/242] scsi: xen/scsifront: Check for a NULL shadow entry on=
 a backend response
* [PATCH 7.2 147/242] scsi: libiscsi: Reject a negative task index from par=
se_pdu_itt
* [PATCH 7.2 148/242] scsi: libiscsi: Validate the ITT reflected in a Rejec=
t PDU
* [PATCH 7.2 149/242] scsi: libiscsi: Validate the task named by a manageme=
nt response
* [PATCH 7.2 150/242] drm/amd/display: Fix NULL sink dereference in USB4 ba=
ndwidth functions
* [PATCH 7.2 151/242] drm/amd/pm: add zero fan stop temperature support on =
smu 14.0.2
* [PATCH 7.2 152/242] drm/amdgpu/sdma3: Work around POLL_REGMEM / FENCE han=
g
* [PATCH 7.2 153/242] drm/amdgpu/uvd3.1: Fix checking whether UVD firmware =
keyselect was already set
* [PATCH 7.2 154/242] drm/amdgpu: destroy mutex when tearing down ttm buffe=
r entity
* [PATCH 7.2 155/242] drm/amdgpu: dont drop the runtime PM reference twice =
in amdgpu_gpr
* [PATCH 7.2 156/242] drm/amdgpu: fix GEM object leak on ENOMEM in userptr =
ioctl
* [PATCH 7.2 157/242] drm/amdgpu: fix sched entity leak in ttm buffer entit=
y init
* [PATCH 7.2 158/242] drm/amdgpu: keep the eviction fence until the last ha=
ndle is closed
* [PATCH 7.2 159/242] drm/amdgpu: report the BO alignment in bytes in GEM_L=
IST_HANDLES
* [PATCH 7.2 160/242] drm/exec: dont immediately add prelocked obj to array=
 of locked objs
* [PATCH 7.2 161/242] drm/i915/cx0_phy: Fix ARL-S host bridge detection
* [PATCH 7.2 162/242] drm/i915/dmc: Add sanity check for DMC load address
* [PATCH 7.2 163/242] drm/xe: Bump LRU for external objects on exec and reb=
ind
* [PATCH 7.2 164/242] drm/xe: Dont transfer shrinker pages for pinned bos o=
n purgeable state change
* [PATCH 7.2 165/242] sched_ext: Fix use-after-free of a destroyed user DSQ=
 by a deferred reenqueue
* [PATCH 7.2 166/242] sched_ext: idle: Respect task affinity in restricted =
CPU selection
* [PATCH 7.2 167/242] sched_ext: Propagate every bypass depth change to the=
 descendants
* [PATCH 7.2 168/242] tracing: Fix the shift out of bounds in the log2 hist=
ogram modifier
* [PATCH 7.2 169/242] tracing: Keep the predicate limit separate from progr=
am capacity
* [PATCH 7.2 170/242] tracing: Take trace_types_lock when dropping the buff=
er_meta reference
* [PATCH 7.2 171/242] tracing: Check operator stack capacity before pushing
* [PATCH 7.2 172/242] tracing: Do not initialize tracefs work if tracing is=
 disabled
* [PATCH 7.2 173/242] tracing: Fix crash in print_graph_function_event()
* [PATCH 7.2 174/242] tracing: Fix hist trigger timestamps for buffered eve=
nts
* [PATCH 7.2 175/242] tracing: Fix ignored return value of resize_buffer_du=
plicate_size()
* [PATCH 7.2 176/242] wifi: p54: validate firmware record lengths
* [PATCH 7.2 177/242] tcp: fix use-after-free in do_tcp_getsockopt(TCP_CONG=
ESTION)
* [PATCH 7.2 178/242] tcp: fix use-after-free in do_tcp_getsockopt(TCP_CC_I=
NFO)
* [PATCH 7.2 179/242] cgroup: fix spurious SIGKILL of CLONE_INTO_CGROUP chi=
ldren
* [PATCH 7.2 180/242] cifs: add revalidation on FSCTL failure in smb2_dupli=
cate_extents()
* [PATCH 7.2 181/242] cifs: dont update i_size in cifs_do_truncate without =
a cached handle
* [PATCH 7.2 182/242] dm cache: fix demotion stats in passthrough mode
* [PATCH 7.2 183/242] dm cache: fix issue with background work locking
* [PATCH 7.2 184/242] dm-crypt: fix a tiny race condition in crypt_dec_pend=
ing
* [PATCH 7.2 185/242] dm-ebs: fix incorrect device offset check in ebs_ctr(=
)
* [PATCH 7.2 186/242] dm-integrity: fix infinite loop on discard with large=
 tag size
* [PATCH 7.2 187/242] dm-integrity: require stable writes for internal hash=
 modes
* [PATCH 7.2 188/242] mac802154: fix data race and NULL deref on local->ass=
oc_dev
* [PATCH 7.2 189/242] net/iucv: fix the recvmsg window update
* [PATCH 7.2 190/242] xfs: dont hold buffer locks across sync transaction c=
ommit in xfs_sync_sb_buf
* [PATCH 7.2 191/242] xfs: fix capability check in xfs
* [PATCH 7.2 192/242] xfs: fix zoned write iomap flags assignments
* [PATCH 7.2 193/242] netlink: specs: fix the conntrack filter type
* [PATCH 7.2 194/242] netlink: specs: add missing mask attributes for connt=
rack dump
* [PATCH 7.2 195/242] io_uring/cancel: dont spin on local work the task can=
t run
* [PATCH 7.2 196/242] workqueue: Use raise_softirq() to trigger softirq in =
irq_work handler
* [PATCH 7.2 197/242] workqueue: Annotate cb_lock nesting when draining a d=
ead BH pool
* [PATCH 7.2 198/242] tipc: protect node reset trace dump with node lock
* [PATCH 7.2 199/242] selinux: fix BPF token permission checks
* [PATCH 7.2 200/242] sctp: validate chunk length in the inqueue parser
* [PATCH 7.2 201/242] page_pool: keep frag_offset aligned for odd-sized req=
uests
* [PATCH 7.2 202/242] s390/ctcm: Prevent XID null dereference
* [PATCH 7.2 203/242] s390/pai: Handle multiple PMU stop callback invocatio=
ns
* [PATCH 7.2 204/242] s390/pci: Fix leak of uninitialized kernel data in SC=
LP report
* [PATCH 7.2 205/242] vsock/virtio: validate packet source for connected so=
ckets
* [PATCH 7.2 206/242] vsock/vmci: validate packet source for connected sock=
ets
* [PATCH 7.2 207/242] ipv4: avoid divide by zero in fib_rebalance
* [PATCH 7.2 208/242] drm/amdgpu: Fix VCE 3 ring align_mask
* [PATCH 7.2 209/242] KVM: x86/mmu: Cope with the SS bit being set in #NPF =
exit codes
* [PATCH 7.2 210/242] drm/amdgpu: correct reservation fence slots for userq=
 per-vm BOs eviction
* [PATCH 7.2 211/242] drm/amdgpu/userq: actually validate userq BOs
* [PATCH 7.2 212/242] drm/i915/dmc: Harden DMC firmware payload parsing
* [PATCH 7.2 213/242] net: bridge: mcast: dont truncate the port group walk=
 on teardown
* [PATCH 7.2 214/242] net: ntb_netdev: Fix statistics races
* [PATCH 7.2 215/242] net: psp: do not inherit the Rx association on clone
* [PATCH 7.2 216/242] ksmbd: fill in FileSysIdentifier in FS_POSIX_INFORMAT=
ION
* [PATCH 7.2 217/242] ksmbd: initialize FileSystemControlFlags in FS_CONTRO=
L_INFORMATION
* [PATCH 7.2 218/242] ksmbd: zero the FS_OBJECT_ID_INFORMATION buffer befor=
e filling it in
* [PATCH 7.2 219/242] net/sched: cls_flower: validate mask pointer after nl=
a_next()
* [PATCH 7.2 220/242] smb: client: fix data corruption with concurrent writ=
es and O_TRUNC
* [PATCH 7.2 221/242] smb: client: fix heap overflow in cifs_do_set_acl()
* [PATCH 7.2 222/242] smb: client: fix multiuser mount with krb5
* [PATCH 7.2 223/242] smb: client: reject SetEA requests that do not fit th=
e request buffer
* [PATCH 7.2 224/242] ntfs: handle signal interruption in fallocate
* [PATCH 7.2 225/242] ntfs: fix FITRIM range alignment
* [PATCH 7.2 226/242] ntfs: fix incorrect MFT record pointer passed to ntfs=
_attr_record_resize
* [PATCH 7.2 227/242] ntfs: fix undefined behavior in mft/index record size=
 calculation
* [PATCH 7.2 228/242] genirq/proc: Fix missing CPU header in /proc/interrup=
ts
* [PATCH 7.2 229/242] drm/amdgpu: Remove the bo list mutex
* [PATCH 7.2 230/242] drm/amdgpu: free the userptr ranges when a CS fails a=
fter parser_bos
* [PATCH 7.2 231/242] sched_ext: Fix stall when a task enqueued with SCX_EN=
Q_LAST lands back on its CPUs local DSQ
* [PATCH 7.2 232/242] tracing: Use __free() for expr_str() buffer
* [PATCH 7.2 233/242] tracing: Bound histogram expression strings with seq_=
buf
* [PATCH 7.2 234/242] tracing: Fix NULL dereference when copying keys for a=
 field variable
* [PATCH 7.2 235/242] sched_ext: Fix the bypass dispatch claim for schedule=
rs bypassed by an ancestor
* [PATCH 7.2 236/242] workqueue: Fix unbound pool lifetime for pending pwqs
* [PATCH 7.2 237/242] ntfs: use pagecache_isize_extended() on size extensio=
n
* [PATCH 7.2 238/242] ntfs: take invalidate_lock in ntfs_setattr_size()
* [PATCH 7.2 239/242] ntfs: fix resident conversion in ntfs_new_attr_flags
* [PATCH 7.2 240/242] ntfs: move attribute payload before shrinking its rec=
ord
* [PATCH 7.2 241/242] ntfs: fix memmove overlap in ntfs_new_attr_flags
* [PATCH 7.2 242/242] smb: client: drain outstanding I/O before truncating =
on O_TRUNC open

and found the following issue:
general protection fault in rest_init

Full report is available here:
https://ci.syzbot.org/series/6369cbfb-3e1e-40c5-b290-88703aed5dbc

***

general protection fault in rest_init

tree:      stable
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/stable/=
linux-stable.git
base:      cc9de5d4b5ab6459f5774946aa3195ad51236fa8
arch:      amd64
compiler:  Debian clang version 22.1.8 (1~deb13u4), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/94200b35-695d-4d66-9b75-f7f98bd6a41=
0/config

kfence: initialized - using 2097152 bytes for 255 objects at 0xffff88823c40=
0000-0xffff88823c600000
Console: colour VGA+ 80x25
printk: legacy console [ttyS0] enabled
printk: legacy console [ttyS0] enabled
printk: legacy bootconsole [earlyser0] disabled
printk: legacy bootconsole [earlyser0] disabled
Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
... MAX_LOCKDEP_SUBCLASSES:  8
... MAX_LOCK_DEPTH:          48
... MAX_LOCKDEP_KEYS:        8192
... CLASSHASH_SIZE:          4096
... MAX_LOCKDEP_ENTRIES:     1048576
... MAX_LOCKDEP_CHAINS:      1048576
... CHAINHASH_SIZE:          524288
 memory used by lock dependency info: 106625 kB
 memory used for stack traces: 8320 kB
 per task-struct memory footprint: 1920 bytes
mempolicy: Enabling automatic NUMA balancing. Configure with numa_balancing=
=3D or the kernel.numa_balancing sysctl
ACPI: Core revision 20260408
clocksource: hpet: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 19=
112604467 ns
APIC: Switch to symmetric I/O mode setup
x2apic enabled
APIC: Switched APIC routing to: physical x2apic
..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D-1
clocksource: tsc-early: mask: 0xffffffffffffffff max_cycles: 0x285c3ee517e,=
 max_idle_ns: 440795257231 ns
Calibrating delay loop (skipped) preset value.. 5599.99 BogoMIPS (lpj=3D279=
99980)
Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
mitigations: Enabled attack vectors: user_kernel, user_user, guest_host, gu=
est_guest, SMT mitigations: auto
Speculative Store Bypass: Vulnerable
Spectre V2 : Mitigation: Retpolines
ITS: Mitigation: Aligned branch/return thunks
MDS: Vulnerable: Clear CPU buffers attempted, no microcode
Spectre V1 : Mitigation: usercopy/swapgs barriers and __user pointer saniti=
zation
Spectre V2 : Spectre v2 / SpectreRSB: Filling RSB on context switch and VME=
XIT
active return thunk: its_return_thunk
x86/fpu: x87 FPU will use FXSAVE
pid_max: default: 32768 minimum: 301
landlock: Up and running.
Yama: becoming mindful.
TOMOYO Linux initialized
AppArmor: AppArmor initialized
LSM support for eBPF active
Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes, vmalloc=
 hugepage)
Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes, vmalloc h=
ugepage)
Mount-cache hash table entries: 16384 (order: 5, 131072 bytes, vmalloc)
Mountpoint-cache hash table entries: 16384 (order: 5, 131072 bytes, vmalloc=
)
VFS: Finished mounting rootfs on nullfs
Running RCU synchronous self tests
Running RCU synchronous self tests
Oops: general protection fault, probably for non-canonical address 0xdffffc=
0000000005: 0000 [#1] SMP KASAN PTI
KASAN: null-ptr-deref in range [0x0000000000000028-0x000000000000002f]
CPU: 0 UID: 0 PID: 0 Comm: swapper/0 Not tainted syzkaller #0 PREEMPT(full)=
=20
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16=
.2-1 04/01/2014
RIP: 0010:rest_init+0xf8/0x300
Code: f5 49 bf 00 00 00 00 00 fc ff df 89 ef 48 c7 c6 c0 c5 9f 8f e8 89 2d =
b5 f5 49 89 c6 48 89 c7 48 83 c7 2c 48 89 f8 48 c1 e8 03 <42> 0f b6 04 38 8=
4 c0 0f 85 d9 01 00 00 41 80 4e 2f 04 e8 81 e4 ff
RSP: 0000:ffffffff8f807ee0 EFLAGS: 00010207
RAX: 0000000000000005 RBX: ffffffff8bdb3f71 RCX: ffffffff8f88ef80
RDX: 0000000000000000 RSI: ffffffffffffffea RDI: 000000000000002c
RBP: 00000000ffffffea R08: ffffffff8bdb3f71 R09: 0000000000000000
R10: dffffc0000000000 R11: fffffbfff22b0a87 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000000 R15: dffffc0000000000
FS:  0000000000000000(0000) GS:ffff88818c718000(0000) knlGS:000000000000000=
0
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffff88823ffff000 CR3: 000000000f946000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 start_kernel+0x392/0x3e0
 x86_64_start_reservations+0x24/0x30
 x86_64_start_kernel+0x137/0x1b0
 common_startup_64+0x13e/0x157
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:rest_init+0xf8/0x300
Code: f5 49 bf 00 00 00 00 00 fc ff df 89 ef 48 c7 c6 c0 c5 9f 8f e8 89 2d =
b5 f5 49 89 c6 48 89 c7 48 83 c7 2c 48 89 f8 48 c1 e8 03 <42> 0f b6 04 38 8=
4 c0 0f 85 d9 01 00 00 41 80 4e 2f 04 e8 81 e4 ff
RSP: 0000:ffffffff8f807ee0 EFLAGS: 00010207
RAX: 0000000000000005 RBX: ffffffff8bdb3f71 RCX: ffffffff8f88ef80
RDX: 0000000000000000 RSI: ffffffffffffffea RDI: 000000000000002c
RBP: 00000000ffffffea R08: ffffffff8bdb3f71 R09: 0000000000000000
R10: dffffc0000000000 R11: fffffbfff22b0a87 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000000 R15: dffffc0000000000
FS:  0000000000000000(0000) GS:ffff88818c718000(0000) knlGS:000000000000000=
0
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffff88823ffff000 CR3: 000000000f946000 CR4: 00000000000006f0


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

To test a fix for this bug, please reply with `#syz test`
(on a separate line) and attach the patch to the email.

Notes:
- The patch will be applied on top of the tested series (as an
  incremental fix).
- To test a new version of the whole series, please send it directly
  to syzbot@lists.linux.dev.
- Arguments like custom git repos and branches are not supported.

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

