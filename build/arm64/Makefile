STAGE_DIR = stage
BUILD_IMAGE_TAG?=v3

stage_init:
	rm -rf ${STAGE_DIR}; mkdir -p ${STAGE_DIR}
	mkdir -p ${STAGE_DIR}/licenses
	cp ../share/EULA.pdf ${STAGE_DIR}/licenses

stage_fleet_base:
	mkdir -p ${STAGE_DIR}/usr/local/bin/
	mkdir -p ${STAGE_DIR}/usr/lib64
	mkdir -p ${STAGE_DIR}/etc/neuvector/certs/
	mkdir -p ${STAGE_DIR}/etc/neuvector/certs/internal/
	cp ../share/.nvcontainer ${STAGE_DIR}/usr/local/bin/
	cp ../share/etc/neuvector/certs/internal/ca.cert ${STAGE_DIR}/etc/neuvector/certs/internal/
	cp ../share/etc/neuvector/certs/internal/cert.key ${STAGE_DIR}/etc/neuvector/certs/internal/
	cp ../share/etc/neuvector/certs/internal/cert.pem ${STAGE_DIR}/etc/neuvector/certs/internal/
	chmod 660 ${STAGE_DIR}/etc/neuvector/certs/internal/*

stage_scan_base: stage_fleet_base

stage_ctrl_base: stage_fleet_base

stage_enf_base: stage_fleet_base

stage_mgr_base:
	mkdir -p ${STAGE_DIR}/etc/neuvector/certs/
	cp requirements.txt ${STAGE_DIR}/

stage_adpt_base: stage_fleet_base
	mkdir -p ${STAGE_DIR}/etc/neuvector/certs/

updater:
	docker build --no-cache=true -t neuvector/updater:latest -f ${BUILD_IMAGE_TAG}/Dockerfile.updater .

scanner_base: stage_init stage_scan_base
	docker build --no-cache=true -t neuvector/scanner_base -f ${BUILD_IMAGE_TAG}/Dockerfile.scanner_base .

controller_base: stage_init stage_ctrl_base
	docker build --no-cache=true -t neuvector/controller_base -f ${BUILD_IMAGE_TAG}/Dockerfile.controller_base .

enforcer_base: stage_init stage_enf_base
	docker build --no-cache=true -t neuvector/enforcer_base -f ${BUILD_IMAGE_TAG}/Dockerfile.enforcer_base .

manager_base: stage_init stage_mgr_base
	docker build --no-cache=true -t neuvector/manager_base -f ${BUILD_IMAGE_TAG}/Dockerfile.manager_base .

adapter_base: stage_init stage_adpt_base
	docker build --no-cache=true -t neuvector/adapter_base -f ${BUILD_IMAGE_TAG}/Dockerfile.adapter_base .

all_base: stage_init stage_enf_base stage_ctrl_base stage_mgr_base
	docker build --no-cache=true -t neuvector/all_base -f ${BUILD_IMAGE_TAG}/Dockerfile.all_base .


build_manager:
	docker build --no-cache=true -t neuvector/build_manager:latest -f Dockerfile.build_manager .
	docker build --no-cache=true -t neuvector/build_manager:v3 -f Dockerfile.build_manager_v3 .

build_fleet:
	docker build --no-cache=true -t neuvector/build_fleet:latest -f Dockerfile.build_fleet .
	docker build --no-cache=true -t neuvector/build_fleet:v1 -f Dockerfile.build_fleet_v1 .
	docker build --no-cache=true -t neuvector/build_fleet:v2 -f Dockerfile.build_fleet_v2 .
	docker build --no-cache=true -t neuvector/build_fleet:v3 -f Dockerfile.build_fleet_v3 .
