STAGE_DIR = stage
BASEOS?=alpine

stage_init:
	rm -rf ${STAGE_DIR}; mkdir -p ${STAGE_DIR}
	mkdir -p ${STAGE_DIR}/licenses
	cp ../share/EULA.pdf ${STAGE_DIR}/licenses

stage_fleet_base:
	mkdir -p ${STAGE_DIR}/usr/local/bin/
	mkdir -p ${STAGE_DIR}/usr/lib
	mkdir -p ${STAGE_DIR}/etc/neuvector/certs/
	mkdir -p ${STAGE_DIR}/etc/neuvector/certs/internal/
	cp prebuild/binary/glibc-2.33-r0.apk ${STAGE_DIR}/
	cp ../share/.nvcontainer ${STAGE_DIR}/usr/local/bin/
	cp ../share/etc/neuvector/certs/internal/ca.cert ${STAGE_DIR}/etc/neuvector/certs/internal/
	cp ../share/etc/neuvector/certs/internal/cert.key ${STAGE_DIR}/etc/neuvector/certs/internal/
	cp ../share/etc/neuvector/certs/internal/cert.pem ${STAGE_DIR}/etc/neuvector/certs/internal/

stage_scan_base: stage_fleet_base

stage_ctrl_base: stage_fleet_base
	gzip -cd prebuild/binary/consul.1.11.11.gz > ${STAGE_DIR}/usr/local/bin/consul
	chmod +x ${STAGE_DIR}/usr/local/bin/consul
	gzip -cd prebuild/binary/opa.0.48.0.gz > ${STAGE_DIR}/usr/local/bin/opa
	chmod +x ${STAGE_DIR}/usr/local/bin/opa
	cp ../share/etc/neuvector/certs/ssl-cert.pem ${STAGE_DIR}/etc/neuvector/certs/
	cp ../share/etc/neuvector/certs/ssl-cert.key ${STAGE_DIR}/etc/neuvector/certs/
	cp prebuild/binary/libpcre.so.3.13.1 ${STAGE_DIR}/usr/local/bin/

stage_enf_base: stage_fleet_base
	gzip -cd prebuild/binary/consul.1.11.11.gz > ${STAGE_DIR}/usr/local/bin/consul
	chmod +x ${STAGE_DIR}/usr/local/bin/consul
	gzip -cd prebuild/binary/yq.4.43.1.gz > ${STAGE_DIR}/usr/local/bin/yq
	chmod +x ${STAGE_DIR}/usr/local/bin/yq
	tar -xvf prebuild/binary/iptables-1.8.9.tar.xz -C ${STAGE_DIR}/
	cp prebuild/binary/tcpdump ${STAGE_DIR}/usr/local/bin/tcpdump
	cp prebuild/binary/libpcap.so.1 ${STAGE_DIR}/usr/lib/libpcap.so.1
	cp prebuild/binary/libcrypto.so.1.1 ${STAGE_DIR}/usr/lib/libcrypto.so.1.1
	cp prebuild/binary/libgcc_s.so.1 ${STAGE_DIR}/usr/local/bin/
	cp prebuild/binary/libstdc++.so.6.0.19 ${STAGE_DIR}/usr/local/bin/
	cp prebuild/binary/libpcre.so.3.13.1 ${STAGE_DIR}/usr/local/bin/
	cp prebuild/binary/liburcu.so.2.0.0 ${STAGE_DIR}/usr/local/bin/liburcu.so.2
	cp prebuild/binary/liburcu-cds.so.2.0.0 ${STAGE_DIR}/usr/local/bin/liburcu-cds.so.2
	cp prebuild/binary/libnfnetlink.so.0.2.0 ${STAGE_DIR}/usr/local/bin/libnfnetlink.so.0.2.0
	cp prebuild/binary/libnetfilter_queue.so.1.5.0 ${STAGE_DIR}/usr/local/bin/libnetfilter_queue.so.1.5.0
	cp prebuild/binary/libmnl.so.0.1.0 ${STAGE_DIR}/usr/local/bin/libmnl.so.0.1.0

stage_mgr_base:
	mkdir -p ${STAGE_DIR}/etc/neuvector/certs/
	cp ../share/etc/neuvector/certs/ssl-cert.pem ${STAGE_DIR}/etc/neuvector/certs/
	cp ../share/etc/neuvector/certs/ssl-cert.key ${STAGE_DIR}/etc/neuvector/certs/
	cp requirements.txt ${STAGE_DIR}/

stage_adpt_base: stage_fleet_base
	mkdir -p ${STAGE_DIR}/etc/neuvector/certs/
	cp ../share/etc/neuvector/certs/ssl-cert.pem ${STAGE_DIR}/etc/neuvector/certs/
	cp ../share/etc/neuvector/certs/ssl-cert.key ${STAGE_DIR}/etc/neuvector/certs/

updater:
	docker build --no-cache=true -t neuvector/updater:latest -f ${BASEOS}/Dockerfile.updater .

scanner_base: stage_init stage_scan_base
	docker build --no-cache=true -t neuvector/scanner_base -f ${BASEOS}/Dockerfile.scanner_base .

controller_base: stage_init stage_ctrl_base
	docker build --no-cache=true -t neuvector/controller_base -f ${BASEOS}/Dockerfile.controller_base .

enforcer_base: stage_init stage_enf_base
	docker build --no-cache=true -t neuvector/enforcer_base -f ${BASEOS}/Dockerfile.enforcer_base .

manager_base: stage_init stage_mgr_base
	docker build --no-cache=true -t neuvector/manager_base -f ${BASEOS}/Dockerfile.manager_base .

adapter_base: stage_init stage_adpt_base
	docker build --no-cache=true -t neuvector/adapter_base -f ${BASEOS}/Dockerfile.adapter_base .

all_base: stage_init stage_enf_base stage_ctrl_base
	cp requirements.txt ${STAGE_DIR}/
	docker build --no-cache=true -t neuvector/all_base -f ${BASEOS}/Dockerfile.all_base .


build_manager:
	docker build --no-cache=true -t neuvector/build_manager:latest -f Dockerfile.build_manager .

build_fleet:
	docker build --no-cache=true -t neuvector/build_fleet:latest -f Dockerfile.build_fleet .
	docker build --no-cache=true -t neuvector/build_fleet:v1 -f Dockerfile.build_fleet_v1 .
	docker build --no-cache=true -t neuvector/build_fleet:v2 -f Dockerfile.build_fleet_v2 .
