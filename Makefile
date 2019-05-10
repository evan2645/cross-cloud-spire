.PHONY: start stop halt clean

.DELETE_ON_ERROR: build

build:
	./00_configure_minikube.sh
	./10_build_images.sh

start: build
	./20_start_global_tier.sh
	./30_start_regional_tier.sh

stop:
	./80_stop.sh

halt:
	./90_halt.sh

clean:
	./99_clean.sh
