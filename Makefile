PROTO_PATH=./protos
GO_PACKAGE_PATH=./api/pb
GO_PACKAGE_NAME=api/pb
PROTO_FILES = `find $(PROTO_PATH) -name "*.proto"`

gopb:
	mkdir -p $(GO_PACKAGE_PATH)

	@for file in $(PROTO_FILES); do\
		OPT=$$OPT" --go_opt=M$$(basename $$file)=$(GO_PACKAGE_NAME)/$$(basename $$file .proto) --go-grpc_opt=M$$(basename $$file)=$(GO_PACKAGE_NAME)/$$(basename $$file .proto)";\
	done; echo $$OPT > _pfopts

	@for file in $(PROTO_FILES); do \
		NAME=$$(basename $$file .proto);\
		mkdir -p $(GO_PACKAGE_PATH)/$$NAME;\
		cp $$file $(GO_PACKAGE_PATH)/$$NAME/; \
		protoc \
		--go_out=$(GO_PACKAGE_PATH)/$$NAME \
		--go-grpc_out=$(GO_PACKAGE_PATH)/$$NAME \
		--go_opt=paths=source_relative \
		--go-grpc_opt=paths=source_relative \
		$$(cat _pfopts) \
		--proto_path $(PROTO_PATH) \
		$$file;\
	done;\
	# rm -r _pfopts

goapi_linux:
	cd api; mkdir -p bin; env GOOS=linux GOARCH=amd64 go build -o bin/api

goapi_macos:
	cd api; mkdir -p bin; env GOOS=darwin GOARCH=arm64 go build -o bin/api

install:
	apt-get update
	apt-get install -y protobuf-compiler
	go install google.golang.org/protobuf/cmd/protoc-gen-go@v1.28
	go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@v1.2

