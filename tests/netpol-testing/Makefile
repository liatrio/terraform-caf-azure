ifeq (, $(shell which gotest))
GOTEST := go test
else
GOTEST := gotest
endif

netpol-testing build:
	go build .

test:
	$(GOTEST) -v