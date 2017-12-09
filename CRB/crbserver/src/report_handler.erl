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
         handle_request/2
        ]).

init(Req, Opts) ->
    {cowboy_rest, Req, Opts}.

content_types_provided(Req, State) ->
    {[
        {<<"application/json">>, handle_request}
    ], Req, State}.

%Actual API Call
handle_request(Req, State) ->
	logger:log([?LOGPATH], "Call?handle_request: XXXX"),
	Body = "
{
	\"status\": \"200\",
    	\"message\": \"OK\"
}",
    	logger:log([?LOGPATH], "Call?handle_request: Response sent back. End#"),
    	{Body, Req, State}.
