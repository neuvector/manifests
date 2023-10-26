STAGE_DIR = stage

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

stage_scan_base: stage_fleet_base

stage_ctrl_base: stage_fleet_base
	gzip -cd prebuild/binary/consul_1.11.11_linux_arm64.gz > ${STAGE_DIR}/usr/local/bin/consul
	chmod +x ${STAGE_DIR}/usr/local/bin/consul
	gzip -cd prebuild/binary/opa.0.48.0.gz > ${STAGE_DIR}/usr/local/bin/opa
	chmod +x ${STAGE_DIR}/usr/local/bin/opa
	cp ../share/etc/neuvector/certs/ssl-cert.pem ${STAGE_DIR}/etc/neuvector/certs/
	cp ../share/etc/neuvector/certs/ssl-cert.key ${STAGE_DIR}/etc/neuvector/certs/
	cp prebuild/binary/libpcre.so.3.13.3 ${STAGE_DIR}/usr/local/bin/libpcre.so.3

stage_enf_base: stage_fleet_base
	gzip -cd prebuild/binary/consul_1.11.11_linux_arm64.gz > ${STAGE_DIR}/usr/local/bin/consul
	chmod +x ${STAGE_DIR}/usr/local/bin/consul
	cp prebuild/binary/libjemalloc.so.2 ${STAGE_DIR}/usr/local/bin/
	cp prebuild/binary/libpcre.so.3.13.3 ${STAGE_DIR}/usr/local/bin/libpcre.so.3

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
	docker build --no-cache=true -t neuvector/updater:latest -f Dockerfile.updater .

scanner_base: stage_init stage_scan_base
	docker build --no-cache=true -t neuvector/scanner_base -f Dockerfile.scanner_base .

controller_base: stage_init stage_ctrl_base
	docker build --no-cache=true -t neuvector/controller_base -f Dockerfile.controller_base .

enforcer_base: stage_init stage_enf_base
	docker build --no-cache=true -t neuvector/enforcer_base -f Dockerfile.enforcer_base .

manager_base: stage_init stage_mgr_base
	docker build --no-cache=true -t neuvector/manager_base -f Dockerfile.manager_base .

adapter_base: stage_init stage_adpt_base
	docker build --no-cache=true -t neuvector/adapter_base -f Dockerfile.adapter_base .

all_base: stage_init stage_enf_base stage_ctrl_base
	docker build --no-cache=true -t neuvector/all_base -f Dockerfile.all_base .


build_manager:
	docker build --no-cache=true -t neuvector/build_manager:latest -f Dockerfile.build_manager .

build_fleet:
	docker build --no-cache=true -t neuvector/build_fleet:latest -f Dockerfile.build_fleet .
	docker build --no-cache=true -t neuvector/build_fleet:v1 -f Dockerfile.build_fleet_v1 .
