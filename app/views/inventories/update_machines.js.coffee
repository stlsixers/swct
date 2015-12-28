$("#machines_select").empty()
	.append("<%= escape_javascript(render(:partial => @machines)) %>")