include $(TOPDIR)/rules.mk

PKG_NAME:=luci-app-proxy-upgrade
PKG_VERSION:=1.0
PKG_RELEASE:=1

PKG_MAINTAINER:=User <user@example.com>
PKG_LICENSE:=MIT

include $(INCLUDE_DIR)/package.mk

define Package/luci-app-proxy-upgrade
  SECTION:=luci
  CATEGORY:=LuCI
  SUBMENU:=3. Applications
  TITLE:=Proxy Upgrade for OpenWrt
  PKGARCH:=all
  DEPENDS:=+luci-base +curl +wget +ca-certificates
endef

define Package/luci-app-proxy-upgrade/description
  A LuCI plugin to upgrade OpenWrt system via a proxy server (HTTP/SOCKS5).
endef

define Build/Compile
endef

define Package/luci-app-proxy-upgrade/install
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/controller
	$(INSTALL_DATA) ./luasrc/controller/proxy-upgrade.lua $(1)/usr/lib/lua/luci/controller/
	
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/model/cbi
	$(INSTALL_DATA) ./luasrc/model/cbi/proxy-upgrade.lua $(1)/usr/lib/lua/luci/model/cbi/
	
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/view/proxy-upgrade
	$(INSTALL_DATA) ./luasrc/view/proxy-upgrade/status.htm $(1)/usr/lib/lua/luci/view/proxy-upgrade/
	
	$(INSTALL_DIR) $(1)/usr/lib/proxy-upgrade
	$(INSTALL_BIN) ./root/usr/lib/proxy-upgrade/test-proxy.sh $(1)/usr/lib/proxy-upgrade/
	$(INSTALL_BIN) ./root/usr/lib/proxy-upgrade/upgrade.sh $(1)/usr/lib/proxy-upgrade/
	
	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_CONF) ./root/etc/config/proxy-upgrade $(1)/etc/config/
endef

$(eval $(call BuildPackage,luci-app-proxy-upgrade))
