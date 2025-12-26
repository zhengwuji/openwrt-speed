m = Map("proxy-upgrade", translate("代理升级"), translate("通过局域网代理服务器升级OpenWrt系统"))

s = m:section(TypedSection, "proxy", "")
s.anonymous = true

o = s:option(ListValue, "enabled", translate("启用代理"))
o:value("1", translate("启用"))
o:value("0", translate("禁用"))
o.default = "0"

o = s:option(Value, "proxy_ip", translate("代理服务器IP"))
o.datatype = "ipaddr"
o.rmempty = false 

-- Auto-discovery logic using luci.sys.net.host_hints()
local sys = require "luci.sys"
local hints = sys.net.host_hints()

for mac, info in pairs(hints) do
    local ip = info.ipaddr
    local name = info.name or info.hostname
    
    if ip then
        local label = ip
        if name and name ~= "" then
            label = label .. " (" .. name .. ")"
        else
            label = label .. " (" .. mac .. ")"
        end
        o:value(ip, label)
    end
end

o = s:option(Value, "proxy_port", translate("代理端口"))
o.datatype = "port"

o = s:option(ListValue, "proxy_type", translate("代理类型"))
o:value("http", "HTTP")
o:value("socks5", "SOCKS5")
o.default = "http"

t = s:option(DummyValue, "_buttons")
t.template = "proxy-upgrade/status"

return m
