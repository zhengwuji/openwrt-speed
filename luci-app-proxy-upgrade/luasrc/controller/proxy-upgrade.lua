module("luci.controller.proxy-upgrade", package.seeall)

function index()
	entry({"admin", "system", "proxy-upgrade"}, cbi("proxy-upgrade"), _("代理升级"), 90).dependent = true
	entry({"admin", "system", "proxy-upgrade", "test"}, call("action_test")).leaf = true
	entry({"admin", "system", "proxy-upgrade", "run"}, call("action_run")).leaf = true
	entry({"admin", "system", "proxy-upgrade", "log"}, call("action_log")).leaf = true
end

function action_test()
	local ip = luci.http.formvalue("ip")
	local port = luci.http.formvalue("port")
	local type = luci.http.formvalue("type") or "http"
	
	luci.http.prepare_content("text/plain")
	local cmd = "/usr/lib/proxy-upgrade/test-proxy.sh " .. ip .. " " .. port .. " " .. type
	local f = io.popen(cmd)
	local output = f:read("*all")
	f:close()
	luci.http.write(output)
end

function action_run()
	luci.sys.call("/usr/lib/proxy-upgrade/upgrade.sh > /tmp/proxy-upgrade.log 2>&1 &")
	luci.http.prepare_content("text/plain")
	luci.http.write("Started")
end

function action_log()
	local f = io.open("/tmp/proxy-upgrade.log", "r")
	local content = ""
	if f then
		content = f:read("*all")
		f:close()
	end
	luci.http.prepare_content("text/plain")
	luci.http.write(content)
end
