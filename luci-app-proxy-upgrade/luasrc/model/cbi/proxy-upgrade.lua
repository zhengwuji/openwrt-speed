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

o = s:option(Value, "timeout", translate("连接超时(秒)"))
o.datatype = "uinteger"
o.default = "5"

o = s:option(Flag, "global_proxy", translate("出口UI设置"), translate("打勾代表，所有设备都会按照选择的IP，作为出口流量，也就是全局代理所有网路，使用的是选中的ip,确保网路软件配置不要冲突能正常使用，被选中的IP，不受影响"))
o.default = "0"

t = s:option(DummyValue, "_buttons")
t.template = "proxy-upgrade/status"

function m.on_after_commit(self)
    luci.sys.call("/usr/lib/proxy-upgrade/set-global-proxy.sh > /dev/null 2>&1 &")
end

return m
