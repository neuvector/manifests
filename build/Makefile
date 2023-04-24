STAGE_DIR = stage
BUILD_IMAGE_TAG = latest

stage_build_opa:
	docker build -t neuvector/build_opa -f Dockerfile.build_opa --build-arg build_version=v0.52.0 .
	set -e ; \
	container_id=$$(docker create "neuvector/build_opa:latest") ; \
	docker cp "$$container_id:/build/opa/opa" . ; \
	docker rm "$$container_id"

stage_build_consul:
	docker build -t neuvector/build_consul -f Dockerfile.build_consul --build-arg build_version=v1.15.2 .
	set -e ;\
	container_id=$$(docker create "neuvector/build_consul:latest") ; \
	docker cp "$$container_id:/build/consul/consul" . ; \
	docker rm "$$container_id"

stage_init:
	rm -rf ${STAGE_DIR}; mkdir -p ${STAGE_DIR}
	mkdir -p ${STAGE_DIR}/licenses
	cp EULA.pdf ${STAGE_DIR}/licenses

stage_fleet_base:
	mkdir -p ${STAGE_DIR}/usr/local/bin/
	mkdir -p ${STAGE_DIR}/usr/lib
	mkdir -p ${STAGE_DIR}/etc/neuvector/certs/
	mkdir -p ${STAGE_DIR}/etc/neuvector/certs/internal/
	cp .nvcontainer ${STAGE_DIR}/usr/local/bin/
	cp prebuild/etc/neuvector/certs/internal/ca.cert ${STAGE_DIR}/etc/neuvector/certs/internal/
	cp prebuild/etc/neuvector/certs/internal/cert.key ${STAGE_DIR}/etc/neuvector/certs/internal/
	cp prebuild/etc/neuvector/certs/internal/cert.pem ${STAGE_DIR}/etc/neuvector/certs/internal/

stage_scan_base: stage_fleet_base

stage_ctrl_base: stage_fleet_base stage_build_opa stage_build_consul 
	cp consul ${STAGE_DIR}/usr/local/bin/consul
	chmod +x ${STAGE_DIR}/usr/local/bin/consul
	cp opa ${STAGE_DIR}/usr/local/bin/opa
	chmod +x ${STAGE_DIR}/usr/local/bin/opa
	cp prebuild/etc/neuvector/certs/ssl-cert.pem ${STAGE_DIR}/etc/neuvector/certs/
	cp prebuild/etc/neuvector/certs/ssl-cert.key ${STAGE_DIR}/etc/neuvector/certs/

stage_enf_base: stage_fleet_base stage_build_consul
	cp consul ${STAGE_DIR}/usr/local/bin/consul
	chmod +x ${STAGE_DIR}/usr/local/bin/consul

stage_mgr_base:
	mkdir -p ${STAGE_DIR}/etc/neuvector/certs/
	cp prebuild/etc/neuvector/certs/ssl-cert.pem ${STAGE_DIR}/etc/neuvector/certs/
	cp prebuild/etc/neuvector/certs/ssl-cert.key ${STAGE_DIR}/etc/neuvector/certs/
	cp requirements.txt ${STAGE_DIR}/

stage_adpt_base: stage_fleet_base
	mkdir -p ${STAGE_DIR}/etc/neuvector/certs/
	cp prebuild/etc/neuvector/certs/ssl-cert.pem ${STAGE_DIR}/etc/neuvector/certs/
	cp prebuild/etc/neuvector/certs/ssl-cert.key ${STAGE_DIR}/etc/neuvector/certs/

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
	docker buildx build --no-cache=true -t neuvector/build_manager:latest -f Dockerfile.build_manager .

build_fleet:
	docker buildx build --no-cache=true -t neuvector/build_fleet:latest -f Dockerfile.build_fleet .
	docker buildx build --no-cache=true -t neuvector/build_fleet:v1 -f Dockerfile.build_fleet_v1 .
