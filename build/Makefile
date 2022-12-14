STAGE_DIR = stage

stage_init:
	rm -rf ${STAGE_DIR}; mkdir -p ${STAGE_DIR}
	mkdir -p ${STAGE_DIR}/licenses
	cp EULA.pdf ${STAGE_DIR}/licenses

stage_fleet_base:
	mkdir -p ${STAGE_DIR}/usr/local/bin/
	mkdir -p ${STAGE_DIR}/usr/lib
	mkdir -p ${STAGE_DIR}/etc/neuvector/certs/
	mkdir -p ${STAGE_DIR}/etc/neuvector/certs/internal/
	cp prebuild/binary/glibc-2.33-r0.apk ${STAGE_DIR}/
	cp .nvcontainer ${STAGE_DIR}/usr/local/bin/
	cp prebuild/etc/neuvector/certs/internal/ca.cert ${STAGE_DIR}/etc/neuvector/certs/internal/
	cp prebuild/etc/neuvector/certs/internal/cert.key ${STAGE_DIR}/etc/neuvector/certs/internal/
	cp prebuild/etc/neuvector/certs/internal/cert.pem ${STAGE_DIR}/etc/neuvector/certs/internal/

stage_scan_base: stage_fleet_base

stage_ctrl_base: stage_fleet_base
	gzip -cd prebuild/binary/consul.1.11.9.gz > ${STAGE_DIR}/usr/local/bin/consul
	chmod +x ${STAGE_DIR}/usr/local/bin/consul
	gzip -cd prebuild/binary/opa.0.46.1.gz > ${STAGE_DIR}/usr/local/bin/opa
	chmod +x ${STAGE_DIR}/usr/local/bin/opa
	cp prebuild/etc/neuvector/certs/ssl-cert.pem ${STAGE_DIR}/etc/neuvector/certs/
	cp prebuild/etc/neuvector/certs/ssl-cert.key ${STAGE_DIR}/etc/neuvector/certs/
	cp prebuild/binary/libpcre.so.3.13.1 ${STAGE_DIR}/usr/local/bin/

stage_enf_base: stage_fleet_base
	gzip -cd prebuild/binary/consul.1.11.9.gz > ${STAGE_DIR}/usr/local/bin/consul
	chmod +x ${STAGE_DIR}/usr/local/bin/consul
	cp prebuild/binary/tcpdump ${STAGE_DIR}/usr/local/bin/tcpdump
	cp prebuild/binary/libpcap.so.1 ${STAGE_DIR}/usr/lib/libpcap.so.1
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
	cp prebuild/etc/neuvector/certs/ssl-cert.pem ${STAGE_DIR}/etc/neuvector/certs/
	cp prebuild/etc/neuvector/certs/ssl-cert.key ${STAGE_DIR}/etc/neuvector/certs/
	cp requirements.txt ${STAGE_DIR}/

updater:
	docker build --no-cache=true -t neuvector/updater:latest -f Dockerfile.updater .

scanner_base: stage_init stage_scan_base
	docker build --no-cache=true -t neuvector/scanner_base -f Dockerfile.scanner_base .

controller_base: stage_init stage_ctrl_base
	docker build --no-cache=true -t neuvector/controller_base -f Dockerfile.controller_base .

enforcer_base: stage_init stage_enf_base
	docker build --no-cache=true -t neuvector/enforcer_base -f Dockerfile.enforcer_base .

manager_base: stage_init stage_mgr_base
	docker build --no-cache=true -t neuvector/manager_base -f Dockerfile.manager_base .

all_base: stage_init stage_enf_base stage_ctrl_base
	docker build --no-cache=true -t neuvector/all_base -f Dockerfile.all_base .


build_manager:
	docker build --no-cache=true -t neuvector/build_manager:latest -f Dockerfile.build_manager .

build_fleet:
	docker build --no-cache=true -t neuvector/build_fleet:latest -f Dockerfile.build_fleet .
