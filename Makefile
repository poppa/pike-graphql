parser:
	cd parser-graphql && pike -x module

parser-install: parser
	cd parser-graphql && sudo pike -x module install

devmodule: parser
	cd parser-graphql && pike -x module pike_external_module

run-generator:
	cd dev && ./generator.sh
