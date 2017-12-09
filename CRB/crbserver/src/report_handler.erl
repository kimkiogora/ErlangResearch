%% @doc REST time handler.
-module(report_handler).
-import(logger,[log/2]).

-define(LOGPATH, "/var/log/erlang/crbserver.log").

%% Webmachine API
-export([
         init/2,
         content_types_provided/2
        ]).

-export([
         time_to_json/2
        ]).

init(Req, Opts) ->
    {cowboy_rest, Req, Opts}.

content_types_provided(Req, State) ->
    {[
        {<<"application/json">>, time_to_json}
    ], Req, State}.

%Actual API Call
time_to_json(Req, State) ->
	logger:log([?LOGPATH], "Call?time_to_json: XXXX"),
	Body = "
{
	\"status\": \"200\",
    	\"message\": \"OK\"
}",
    	logger:log([?LOGPATH], "Call?time_to_json: Response sent back. End#"),
    	{Body, Req, State}.
