options = {
	directory: 'templates',
	layout: 'layout',
	extensions: { 'tmpl', 'html' },
	'content-type': 'text/html',
}

find_file = (directory, filename, extensions) ->
	is_file = (filename) ->
		import attributes from require 'lfs'

		f = attributes filename

		return false unless f and f.mode == 'file'
		true

	for e in *extensions
		layout_file = string.format "%s/%s.%s", directory, filename, e
		return layout_file if is_file layout_file

read_file = (f) ->
	file = io.open f
	return unless file

	output = file\read '*a'
	file\close!
	output

html = (o, p) ->
	(args) ->
		import compile from require 'etlua'

		p.response\set_options {'Content-Type': o['content-type']} if o['content-type']

		directory = o.directory or options.directory

		local layout
		if o.layout
			layout_file = find_file directory, o.layout, o.extensions
			unless layout_file or o.layout != 'layout'
				print "unable to open layout: #{o.layout}"
				return

			layout = compile read_file layout_file

		template_file = find_file directory, args.template, o.extensions
		unless template_file
			print 'unable to find template file'
			return

		template = compile read_file template_file

		rendered_template = template args.data or {}
		if layout
			data = args.data or {}
			data.template = rendered_template
			p.response\write layout data or {}
			return

		p.response\write rendered_template

json = (o, p) ->
	(args) ->
		json = require 'cjson'
		if args.data
			p.response\set_options {'Content-Type': 'application/json', status: args.status or 200}
			p.response\write json.encode args.data if args.data
		else
			p.response\write json.encode args

Render = (args = {}) ->
	for k,v in pairs options
		args[k] = v unless args[k]

	(p) ->
		p.gimlet\map 'render', {
			html: html(args, p),
			json: json(args, p),
		}

{ :Render, :options }
