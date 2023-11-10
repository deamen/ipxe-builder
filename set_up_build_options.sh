# Enable NFS support
sed -i 's/#undef\tDOWNLOAD_PROTO_NFS/#define\tDOWNLOAD_PROTO_NFS/' config/general.h

# Enable HTTPS support
sed -i 's/#undef\tDOWNLOAD_PROTO_HTTPS/#define\tDOWNLOAD_PROTO_HTTPS/' config/general.h
##
# Enable Ping support
##
sed -i 's/\/\/#define\ PING_CMD/#define\ PING_CMD/' config/general.h
sed -i 's/\/\/#define\ IPSTAT_CMD/#define\ IPSTAT_CMD/' config/general.h

# Enalbe Reboot command
sed -i 's/\/\/#define\ REBOOT_CMD/#define\ REBOOT_CMD/' config/general.h
# Enable Poweroff command
sed -i 's/\/\/#define\ POWEROFF_CMD/#define\ POWEROFF_CMD/' config/general.h
# Enable Certificate management commands
sed -i 's/\/\/#define\ CERT_CMD/#define\ CERT_CMD/' config/general.h

##
# Disable unwanted command
##
# Infiniband
sed -i 's/#define\ IBMGMT_CMD/#undef\ IBMGMT_CMD/' config/general.h
# Fibre Channel
sed -i 's/#define\ FCMGMT_CMD/#undef\ FCMGMT_CMD/' config/general.h

##
# Disable insecure 802.11 protocols
##
# Disable WEP
sed -i 's/#define\ CRYPTO_80211_WEP/#undef\ CRYPTO_80211_WEP/' config/general.h
# Disable WPA
sed -i 's/#define\ CRYPTO_80211_WPA/#undef\ CRYPTO_80211_WPA/' config/general.h

##
# Disable unwanted SAN boot protocols
##
# Disable AOE
sed -i 's/\/\/#undef\ SANBOOT_PROTO_AOE/#undef\ SANBOOT_PROTO_AOE/' config/general.h
# Disable IB_SRP Infiniband SCSI RDMA protocol
sed -i 's/\/\/#undef\ SANBOOT_PROTO_IB_SRP/#undef\ SANBOOT_PROTO_IB_SRP/' config/general.h
# Disable FCP Fibre Channel protocol
sed -i 's/\/\/#undef\ SANBOOT_PROTO_FCP/#undef\ SANBOOT_PROTO_FCP/' config/general.h