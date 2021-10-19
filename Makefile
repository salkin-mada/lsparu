PKG_NAME := lsparu
AUR_PATH := ~/kode/aur_packages
VERSION := $(shell cat VERSION)
ARCHIVE := $(PKG_NAME)-$(VERSION).tar.gz
.PHONY: all install release version_sync

define archive_ok
    @echo "Archive ok?"; \
    read HVAD;
endef

define pkgbuild_ok
    @echo "PKGBUILD ok?"; \
    read HVAD;
endef

define check_aur_push
    @echo "Push to ssh://aur@aur.archlinux.org/$(PKG_NAME).git?"; \
    read HVAD;
endef

version_sync:
	sed -i -e "s/^version=.*/version=$(VERSION)/" lsparu
	sed -i -e "s/^version=.*/version=$(VERSION)/" lsparu-query
	sed -i -e "s/^Latest Release .*/Latest Release $(VERSION)/" README.md
	sed -i -e "s/^pkgver=.*/pkgver=$(VERSION)/" PKGBUILD

clean:
	rm -rf src/
	rm -rf pkg/

release: clean version_sync
	git commit -am 'Release $(VERSION)'
	git tag $(VERSION)
	git archive --format=tar.gz -o $(ARCHIVE) --prefix lsparu-$(VERSION)/ HEAD
	git push origin $(VERSION)
	git archive --format=zip -o $(PKG_NAME)-$(VERSION).zip --prefix lsparu-$(VERSION)/ HEAD
	sed -i -e "s/^sha256sums=.*/sha256sums=('`sha256sum $(ARCHIVE) | cut -d' ' -f1`')/" PKGBUILD
	makepkg
	namcap PKGBUILD
	$(call pkgbuild_ok)
	git commit -am 'Update PKGBUILD'
	git push origin main
	cp PKGBUILD $(AUR_PATH)/$(PKG_NAME)/PKGBUILD
	updpkgsums
	makepkg --printsrcinfo > .SRCINFO
	mv .SRCINFO $(AUR_PATH)/$(PKG_NAME)/.SRCINFO
	cd $(AUR_PATH)/$(PKG_NAME) && makepkg -ci && git commit -am 'Release $(VERSION)' && namcap $(ARCHIVE)
	$(call archive_ok)
	$(call check_aur_push)
	# git push origin master

install:
	install -m755 lsparu /usr/local/bin/
	install -m755 lsparu-query /usr/local/bin/

