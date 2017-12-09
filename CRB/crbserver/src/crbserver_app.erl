% Author	: kim kiogora <kimkiogora@gmail.com>
% Usage		: CRB Server
-module(crbserver_app).
-behaviour(application).
-export([start/2]).
-export([stop/1]).


start(_Type, _Args) ->
	%application:start(mnesia),
	%createdb(),
	mnesia:create_schema([node()]),
	Dispatch = cowboy_router:compile([{'_', [
						{"/",default_page, []},
						{"/check", check_handler, []},
						{"/report", report_handler, []},
						{"/update", update_handler, []}																		                                         ]}]),
	%LOGPATH = getLogFile(),
        {ok, _} = cowboy:start_clear(http, [{port, 9002}], #{env => #{dispatch => Dispatch}}),
	%ProtoOpts = [{env, [{file, "/var/log/erlang/crbserver.log"},{dispatch, Dispatch}]}],
        %{ok, _} = cowboy:start_clear(http, [{port, 9002}], ProtoOpts),
	crbdbase:init(),
	crbserver_sup:start_link().

stop(_State) ->
	%application:stop(mnesia),
	ok.

%createdb()->
%	crbdbase:init().
%getLogFile()->
%        {ok, AP} = application:get_env(file),
%        AP.

