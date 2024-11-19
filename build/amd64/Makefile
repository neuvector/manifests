STAGE_DIR = stage
BASEOS?=bci
BUILD_IMAGE_TAG?=v3

stage_init:
	rm -rf ${STAGE_DIR}; mkdir -p ${STAGE_DIR}
	mkdir -p ${STAGE_DIR}/licenses
	cp ../share/EULA.pdf ${STAGE_DIR}/licenses

stage_fleet_base:
	mkdir -p ${STAGE_DIR}/usr/local/bin/
	mkdir -p ${STAGE_DIR}/usr/lib
	mkdir -p ${STAGE_DIR}/etc/neuvector/certs/
	mkdir -p ${STAGE_DIR}/etc/neuvector/certs/internal/
	cp ../share/.nvcontainer ${STAGE_DIR}/usr/local/bin/
	cp ../share/etc/neuvector/certs/internal/ca.cert ${STAGE_DIR}/etc/neuvector/certs/internal/
	cp ../share/etc/neuvector/certs/internal/cert.key ${STAGE_DIR}/etc/neuvector/certs/internal/
	cp ../share/etc/neuvector/certs/internal/cert.pem ${STAGE_DIR}/etc/neuvector/certs/internal/
	chmod 660 ${STAGE_DIR}/etc/neuvector/certs/internal/*
ifeq ("$(BASEOS)", "alpine")
	cp prebuild/binary/glibc-2.33-r0.apk ${STAGE_DIR}/
	cp ../share/etc/neuvector/certs/ssl-cert.pem ${STAGE_DIR}/etc/neuvector/certs/
	cp ../share/etc/neuvector/certs/ssl-cert.key ${STAGE_DIR}/etc/neuvector/certs/
endif

stage_scan_base: stage_fleet_base

stage_ctrl_base: stage_fleet_base
ifeq ($(BUILD_IMAGE_TAG),)
	gzip -cd prebuild/binary/consul.1.11.11.gz > ${STAGE_DIR}/usr/local/bin/consul
	chmod +x ${STAGE_DIR}/usr/local/bin/consul
	gzip -cd prebuild/binary/opa.0.48.0.gz > ${STAGE_DIR}/usr/local/bin/opa
	chmod +x ${STAGE_DIR}/usr/local/bin/opa
	cp prebuild/binary/libpcre.so.3.13.1 ${STAGE_DIR}/usr/local/bin/
endif

stage_enf_base: stage_fleet_base
ifeq ($(BUILD_IMAGE_TAG),)
	gzip -cd prebuild/binary/consul.1.11.11.gz > ${STAGE_DIR}/usr/local/bin/consul
	chmod +x ${STAGE_DIR}/usr/local/bin/consul
	gzip -cd prebuild/binary/yq.4.43.1.gz > ${STAGE_DIR}/usr/local/bin/yq
	chmod +x ${STAGE_DIR}/usr/local/bin/yq
	tar -xvf prebuild/binary/iptables-1.8.9.tar.xz -C ${STAGE_DIR}/
ifeq ("$(BASEOS)", "alpine")
	cp prebuild/binary/tcpdump ${STAGE_DIR}/usr/local/bin/tcpdump
endif
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
endif

stage_mgr_base:
	mkdir -p ${STAGE_DIR}/etc/neuvector/certs/
	cp requirements.txt ${STAGE_DIR}/
ifeq ("$(BASEOS)", "alpine")
	cp ../share/etc/neuvector/certs/ssl-cert.pem ${STAGE_DIR}/etc/neuvector/certs/
	cp ../share/etc/neuvector/certs/ssl-cert.key ${STAGE_DIR}/etc/neuvector/certs/
endif

stage_adpt_base: stage_fleet_base
	mkdir -p ${STAGE_DIR}/etc/neuvector/certs/
ifeq ("$(BASEOS)", "alpine")
	cp ../share/etc/neuvector/certs/ssl-cert.pem ${STAGE_DIR}/etc/neuvector/certs/
	cp ../share/etc/neuvector/certs/ssl-cert.key ${STAGE_DIR}/etc/neuvector/certs/
endif

updater:
ifeq ($(BUILD_IMAGE_TAG),)
	docker build --no-cache=true -t neuvector/updater:latest -f ${BASEOS}/Dockerfile.updater .
else
	docker build --no-cache=true -t neuvector/updater:latest -f ${BASEOS}_${BUILD_IMAGE_TAG}/Dockerfile.updater .
endif

scanner_base: stage_init stage_scan_base
ifeq ($(BUILD_IMAGE_TAG),)
	docker build --no-cache=true -t neuvector/scanner_base -f ${BASEOS}/Dockerfile.scanner_base .
else
	docker build --no-cache=true -t neuvector/scanner_base -f ${BASEOS}_${BUILD_IMAGE_TAG}/Dockerfile.scanner_base .
endif

controller_base: stage_init stage_ctrl_base
ifeq ($(BUILD_IMAGE_TAG),)
	docker build --no-cache=true -t neuvector/controller_base -f ${BASEOS}/Dockerfile.controller_base .
else
	docker build --no-cache=true -t neuvector/controller_base -f ${BASEOS}_${BUILD_IMAGE_TAG}/Dockerfile.controller_base .
endif

enforcer_base: stage_init stage_enf_base
ifeq ($(BUILD_IMAGE_TAG),)
	docker build --no-cache=true -t neuvector/enforcer_base -f ${BASEOS}/Dockerfile.enforcer_base .
else
	docker build --no-cache=true -t neuvector/enforcer_base -f ${BASEOS}_${BUILD_IMAGE_TAG}/Dockerfile.enforcer_base .
endif

manager_base: stage_init stage_mgr_base
ifeq ($(BUILD_IMAGE_TAG),)
	docker build --no-cache=true -t neuvector/manager_base -f ${BASEOS}/Dockerfile.manager_base .
else
	docker build --no-cache=true -t neuvector/manager_base -f ${BASEOS}_${BUILD_IMAGE_TAG}/Dockerfile.manager_base .
endif

adapter_base: stage_init stage_adpt_base
ifeq ($(BUILD_IMAGE_TAG),)
	docker build --no-cache=true -t neuvector/adapter_base -f ${BASEOS}/Dockerfile.adapter_base .
else
	docker build --no-cache=true -t neuvector/adapter_base -f ${BASEOS}_${BUILD_IMAGE_TAG}/Dockerfile.adapter_base .
endif

all_base: stage_init stage_enf_base stage_ctrl_base stage_mgr_base
ifeq ($(BUILD_IMAGE_TAG),)
	docker build --no-cache=true -t neuvector/all_base -f ${BASEOS}/Dockerfile.all_base .
else
	docker build --no-cache=true -t neuvector/all_base -f ${BASEOS}_${BUILD_IMAGE_TAG}/Dockerfile.all_base .
endif


build_manager:
	docker build --no-cache=true -t neuvector/build_manager:latest -f Dockerfile.build_manager .
	docker build --no-cache=true -t neuvector/build_manager:v3 -f Dockerfile.build_manager_v3 .

build_fleet:
	docker build --no-cache=true -t neuvector/build_fleet:latest -f Dockerfile.build_fleet .
	docker build --no-cache=true -t neuvector/build_fleet:v1 -f Dockerfile.build_fleet_v1 .
	docker build --no-cache=true -t neuvector/build_fleet:v2 -f Dockerfile.build_fleet_v2 .
	docker build --no-cache=true -t neuvector/build_fleet:v3 -f Dockerfile.build_fleet_v3 .
