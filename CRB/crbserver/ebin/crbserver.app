{application, 'crbserver', [
	{description, "CRB Server for Internal Use"},
	{vsn, "0.1.0"},
	{modules, ['check_handler','crbdbase','crbserver_app','crbserver_sup','default_page','logger','report_handler','update_handler']},
	{registered, [crbserver_sup]},
	{applications, [kernel,stdlib,cowboy,mnesia]},
	{mod, {crbserver_app, []}},
	{env, []}
]}.
