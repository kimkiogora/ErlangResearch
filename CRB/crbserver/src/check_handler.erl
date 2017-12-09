%% @doc REST time handler.
-module(check_handler).
-import(logger,[log/2]).
-import(string,[concat/2]).
-import(string,[len/1]).
-import(string,[equal/2]).

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
	QsVals = cowboy_req:parse_qs(Req),
	logger:log([?LOGPATH], io_lib:format("Request params ~p", [QsVals])),
	FBody = case QsVals =:= [] of
		true ->
"{ 
   \"status\": 201,
   \"message\": \"CONTACT NOT IN PAYLOAD\"
}";
		false->
			proceed(QsVals)
		end,

    	logger:log([?LOGPATH], "Call?check_handler: Response sent back. End#"),
	{FBody, Req, State}.

proceed(QSVals)->
	{_, Contact} = lists:keyfind(<<"contact">>, 1, QSVals),
	logger:log([?LOGPATH], io_lib:format("Call?check_handler: XXXX contact ~s",[Contact])),
	StrContact = io_lib:format("~s",[Contact]),
	case equal(StrContact,"")  of 
		false -> format_response(StrContact);
		true ->
"{
   \"status\": \"201\",
   \"message\": \"CONTACT NOT IN PAYLOAD\"
 }"
	end.

% ETS Functions
% Function to check contact in ETS table
format_response(XContact)->
    %logger:log([?LOGPATH], XContact),
    C = lists:flatten(XContact),
    logger:log([?LOGPATH], C),
    S = crbdbase:find(C),
    DT = io_lib:format("Results from DB ~p",[S]),
    logger:log([?LOGPATH], [DT]),
    case S =:= [] of 
	    true ->
"
{
    \"status\": \"201\",
    \"message\": \"NOT IN CRB\"
}";
	    false ->
		format_response_again(S)
    end.

format_response_again(Response)->
	[_,Y] = Response,
	case Y =:= "true" orelse Y =:= "True" of
		true ->
"
{
    \"status\": \"200\",
    \"message\": \"TRUE\"
}";
		false ->
"
{
    \"status\": \"201\",
    \"message\": \"FALSE\"
}"
	end.
	 
            
      
            
            
            
            
            
            
            

