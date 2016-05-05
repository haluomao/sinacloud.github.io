define CONFIG_YAML
name: blog4sinacloud
version: 1
endef

export CONFIG_YAML

deploy: build
	cd _site && echo "$$CONFIG_YAML" > config.yaml && saecloud deploy

build:
	jekyll build
