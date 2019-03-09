#!/vendor/bin/sh

################################################################################
# helper functions to allow Android init like script

function write() {
    echo -n $2 > $1
}

function get-set-forall() {
    for f in $1 ; do
    cat $f
    write $f $2
    done
}
# macro to write pids to system-background cpuset
function writepid_sbg() {
    if [ ! -z "$1" ]
    then
    echo -n $1 > /dev/cpuset/system-background/tasks
    fi
}

function writepid_top_app() {
    if [ ! -z "$1" ]
    then
    echo -n $1 > /dev/cpuset/top-app/tasks
    fi
}
################################################################################

if grep -q 'AntiGravity' /proc/version
then
    sleep 3
    #
    write /sys/block/mmcblk0/queue/scheduler zen
    setprop sys.io.scheduler "zen"
    write /proc/sys/kernel/sched_upmigrate_min_nice 0
    get-set-forall /sys/class/devfreq/qcom,cpubw*/bw_hwmon/io_percent 20
    get-set-forall /sys/class/devfreq/qcom,cpubw*/bw_hwmon/guard_band_mbps 100
    write /sys/module/msm_thermal/core_control/enabled 0
    #
    write /sys/devices/system/cpu/cpu0/core_ctl/disable 0
    chmod 0666 /proc/fingerprint/proximity_status
    ##
    swapoff /dev/block/zram0
    echo "0" > /sys/block/zram0/disksize
    echo interactive > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor 
    echo 1555200 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
    echo 302400 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq
    echo "1 0 0 0" > /sys/devices/system/cpu/cpu4/core_ctl/always_online_cpu
    echo 4 > /sys/devices/system/cpu/cpu4/core_ctl/max_cpus
    echo 4 > /sys/devices/system/cpu/cpu4/core_ctl/min_cpus
    sleep 1
    echo interactive > /sys/devices/system/cpu/cpu4/cpufreq/scaling_governor
    echo 1766400 > /sys/devices/system/cpu/cpu4/cpufreq/scaling_max_freq
    echo 302400 > /sys/devices/system/cpu/cpu4/cpufreq/scaling_min_freq
    echo 1 > /sys/devices/system/cpu/cpu4/core_ctl/min_cpus
    echo 4 > /sys/devices/system/cpu/cpu4/core_ctl/max_cpus
    echo 0 > /sys/module/cpu_boost/parameters/input_boost_enabled
    echo 1 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/powersave_bias
    echo 1 > /sys/devices/system/cpu/cpu4/cpufreq/interactive/powersave_bias
    echo 1 > /sys/module/adreno_idler/parameters/adreno_idler_active
    echo 27000000 > /sys/class/kgsl/kgsl-3d0/devfreq/min_freq
    echo 630000000 > /sys/class/kgsl/kgsl-3d0/max_gpuclk
    echo 630000000 > /sys/class/kgsl/kgsl-3d0/devfreq/max_freq
    echo 1 > /sys/class/kgsl/kgsl-3d0/devfreq/adrenoboost
    echo 1 > /sys/class/kgsl/kgsl-3d0/max_pwrlevel
    echo 1 > /sys/module/msm_thermal/parameters/enabled
    echo 1 > /sys/module/msm_thermal/vdd_restriction/enabled

    FINGERPRINTD=`pidof fingerprintd`
    QSEECOMD=`pidof qseecomd`
    THERMAL_ENGINE=`pidof thermal_engine`
    TIME_DAEMON=`pidof time_daemon`
    IMSQMIDAEMON=`pidof imsqmidaemon`
    IMSDATADAEMON=`pidof imsdatadaemon`
    DASHD=`pidof dashd`
    CND=`pidof cnd`
    DPMD=`pidof dpmd`
    RMT_STORAGE=`pidof rmt_storage`
    TFTP_SERVER=`pidof tftp_server`
    NETMGRD=`pidof netmgrd`
    IPACM=`pidof ipacm`
    QTI=`pidof qti`
    LOC_LAUNCHER=`pidof loc_launcher`
    QSEEPROXYDAEMON=`pidof qseeproxydaemon`
    IFAADAEMON=`pidof ifaadaemon`
    MM_CAMERA_DAEMON=`pidof mm-qcamera-daemon`
    REMOSAIC_DAEMON=`pidof remosaic_daemon`
    CAMERASERVER=`pidof cameraserver`
    LOGCAT=`pidof logcat`
    LMKD=`pidof lmkd`
    writepid_top_app $FINGERPRINTD
    writepid_sbg $QSEECOMD
    writepid_sbg $THERMAL_ENGINE
    writepid_sbg $TIME_DAEMON
    writepid_sbg $IMSQMIDAEMON
    writepid_sbg $IMSDATADAEMON
    writepid_sbg $DASHD
    writepid_sbg $CND
    writepid_sbg $DPMD
    writepid_sbg $RMT_STORAGE
    writepid_sbg $TFTP_SERVER
    writepid_sbg $NETMGRD
    writepid_sbg $IPACM
    writepid_sbg $QTI
    writepid_sbg $LOC_LAUNCHER
    writepid_sbg $QSEEPROXYDAEMON
    writepid_sbg $IFAADAEMON
    writepid_sbg $LOGCAT
    writepid_sbg $LMKD
    ##
    setprop dalvik.vm.heapminfree 2m
    write /sys/module/cpu_boost/parameters/input_boost_freq "0:960000 1:0 2:0 3:0 4:0 5:0 6:0 7:0"
    write /sys/devices/platform/kcal_ctrl.0/kcal "230 232 252"
    write /sys/devices/platform/kcal_ctrl.0/kcal_cont 248
    write /sys/devices/platform/kcal_ctrl.0/kcal_sat 265
    write /sys/devices/platform/kcal_ctrl.0/kcal_val 263
    write /proc/sys/vm/swappiness 0
    write /proc/sys/vm/overcommit_ratio 0
    write /proc/sys/vm/dirty_writeback_centisecs 0
    write /proc/sys/vm/dirty_expire_centisecs 0
    write /proc/sys/fs/lease-break-time 5
    write /proc/sys/fs/dir-notify-enable 0
    write /sys/class/mmc_host/mmc0/clk_scaling/scale_down_in_low_wr_load 1
    write /sys/devices/system/cpu/cpu0/cpufreq/interactive/screen_off_maxfreq 960000
    write /sys/devices/system/cpu/cpu4/cpufreq/interactive/screen_off_maxfreq 960000
    write /sys/devices/system/cpu/cpu0/cpufreq/interactive/use_sched_load 0
    write /sys/devices/system/cpu/cpu4/cpufreq/interactive/use_sched_load 0
    write /sys/devices/system/cpu/cpu0/cpufreq/interactive/align_windows 1
    write /sys/devices/system/cpu/cpu4/cpufreq/interactive/align_windows 1
    write /sys/class/misc/boeffla_wakelock_blocker/wakelock_blocker "wlan_pno_wl;wlan_ipa;wcnss_filter_lock;[timerfd];hal_bluetooth_lock;IPA_WS;sensor_ind;wlan;netmgr_wl;qcom_rx_wakelock;wlan_wow_wl;wlan_extscan_wl;"
    write /sys/class/timed_output/vibrator/vtg_level 2134
    write /sys/sweep2sleep/sweep2sleep 0
    write /sys/module/qpnp_fg/parameters/debug_mask 1
    write /sys/module/qpnp_fg/parameters/sense_type 0
    write /sys/module/qpnp_smbcharger/parameters/vf_adjust_high_threshold 99
    write /sys/module/qpnp_smbcharger/parameters/vf_adjust_low_threshold  55
    write /sys/module/qpnp_fg/parameters/first_est_dump 1
    write /sys/kernel/slab/:at-0000016/cpu_partial 5
    write /sys/kernel/slab/:at-0000016/min_partial 58
    write /sys/kernel/slab/:at-0000016/cpu_slabs 99
    write /sys/kernel/slab/:at-0000024/cpu_partial 5
    write /sys/kernel/slab/:at-0000024/min_partial 58
    write /sys/kernel/slab/:at-0000024/cpu_slabs 99
    write /sys/kernel/slab/:at-0000032/cpu_partial 5
    write /sys/kernel/slab/:at-0000032/min_partial 58
    write /sys/kernel/slab/:at-0000032/cpu_slabs 99
    write /sys/kernel/slab/:at-0000040/cpu_partial 5
    write /sys/kernel/slab/:at-0000040/min_partial 58
    write /sys/kernel/slab/:at-0000040/cpu_slabs 99
    write /sys/kernel/slab/:at-0000064/cpu_partial 5
    write /sys/kernel/slab/:at-0000064/min_partial 58
    write /sys/kernel/slab/:at-0000064/cpu_slabs 99
    write /sys/kernel/slab/:at-0000088/cpu_partial 5
    write /sys/kernel/slab/:at-0000088/min_partial 58
    write /sys/kernel/slab/:at-0000088/cpu_slabs 99
    write /sys/kernel/slab/:at-0000104/cpu_partial 5
    write /sys/kernel/slab/:at-0000104/min_partial 58
    write /sys/kernel/slab/:at-0000104/cpu_slabs 99
    write /sys/kernel/slab/:at-0000112/cpu_partial 5
    write /sys/kernel/slab/:at-0000112/min_partial 58
    write /sys/kernel/slab/:at-0000112/cpu_slabs 99
    write /sys/kernel/slab/:at-0000136/cpu_partial 5
    write /sys/kernel/slab/:at-0000136/min_partial 58
    write /sys/kernel/slab/:at-0000136/cpu_slabs 99
    write /sys/kernel/slab/:at-0000192/cpu_partial 5
    write /sys/kernel/slab/:at-0000192/min_partial 58
    write /sys/kernel/slab/:at-0000192/cpu_slabs 99
    write /sys/kernel/slab/:at-0000256/cpu_partial 5
    write /sys/kernel/slab/:at-0000256/min_partial 58
    write /sys/kernel/slab/:at-0000256/cpu_slabs 99
    write /sys/kernel/slab/:at-0000296/cpu_partial 5
    write /sys/kernel/slab/:at-0000296/min_partial 58
    write /sys/kernel/slab/:at-0000296/cpu_slabs 99
    write /sys/devices/system/cpu/cpu0/core_ctl/busy_down_thres "40"
    write /sys/devices/system/cpu/cpu0/core_ctl/busy_up_thres "50"
    write /sys/devices/system/cpu/cpu4/core_ctl/busy_down_thres "50"
    write /sys/devices/system/cpu/cpu4/core_ctl/busy_up_thres "60"
    stop perfd
fi
# .
