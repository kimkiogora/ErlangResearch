%% @doc REST time handler.
-module(update_handler).
-import(logger,[log/2]).
-import(string,[equal/2]).
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
	logger:log([?LOGPATH], "Call?update_handler: XXXX"),
	QsVals = cowboy_req:parse_qs(Req),
	logger:log([?LOGPATH], io_lib:format("Request params ~p", [QsVals])),
	FBody = case QsVals =:= [] of
			true ->
"{ 
    \"status\": 201,
    \"message\": \"STATUS NOT IN PAYLOAD\"
}";
			false->
				proceed(QsVals)
		end,
    	logger:log([?LOGPATH], "Call?update_handler: Response sent back. End#"),
    	{FBody, Req, State}.

proceed(QSVals)->
	{_, Contact} = lists:keyfind(<<"contact">>, 1, QSVals),
	{_, Status} = lists:keyfind(<<"status">>, 1, QSVals),
	logger:log([?LOGPATH], io_lib:format("Call?update_handler: XXXX status ~s",[Status])),
	StrState = io_lib:format("~s",[Status]),
	case equal(StrState,"")  of 
			false -> check_contact(Contact, StrState);
			true ->
"{
    \"status\": \"201\",
    \"message\": \"STATUS NOT IN PAYLOAD\"
}"
	end.

check_contact(XContact, XUpdate)->
	UContact = io_lib:format("~s",[XContact]),
	case equal(UContact,"")  of 
		false ->
			send_update(UContact, XUpdate);
		true ->
"{
    \"status\": \"201\",
    \"message\": \"CONTACT NOT IN PAYLOAD\"
}"
	end.

% Check exists
% If exists delete/update
send_update(Contact, StatusUpdate)->
	logger:log([?LOGPATH],io_lib:format("Updating record ~s to status ~s",[Contact, StatusUpdate])),
	FC = crbdbase:find(stringify(Contact)),
	case FC =:= [] of 
		true -> 
			logger:log([?LOGPATH], io_lib:format("Record ~s not found -Ignore",[Contact]));
		false ->
			logger:log([?LOGPATH], io_lib:format("Record ~s found -update",[Contact])),
			ST = crbdbase:update(stringify(Contact), stringify(StatusUpdate)),
			logger:log([?LOGPATH],io_lib:format("Update status ~s",[ST]))
	end,
	success_message().

% Convert to string
stringify(Item)->
	NItem = lists:flatten(Item),
	logger:log([?LOGPATH], NItem),
	NItem.

% Print error message
%error_message()->
%	Body = 
%"{
%    \"status\": \"201\",
%    \"message\": \"FAIL\"
%}",
%	Body.

% Print success message.
success_message()->
	Body = 
"{
     \"status\": \"200\",
    \"message\": \"OK\"
}",
        Body.

