package = "gimlet-render"
version = "dev-1"

source = {
	url = "git://github.com/losinggeneration/gimlet-render.git"
}

description = {
	summary = "A renderer for HTML templates and JSON for Gimlet Cocktail",
	homepage = "http://losinggeneration.github.io/gimlet-render",
	maintainer = "Harley Laue <losinggeneration@gmail.com>",
	license = "MIT"
}

dependencies = {
	"lua >= 5.1",
	"gimlet-cocktail >= " .. version,
	"luafilesystem >= 1.5",
	"lua-cjson >= 2.1.0",
	"etlua >= 1.2.0",
}

build = {
	type = "builtin",
	modules = {
		["gimlet.render"] = "gimlet/render/init.lua",
	},
}

