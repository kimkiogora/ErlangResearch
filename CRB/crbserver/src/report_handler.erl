%% @doc REST time handler.
-module(report_handler).
-import(logger,[log/2]).
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
   \"message\": \"PARAMS [ contact, accrued, reportedBy ] NOT IN PAYLOAD\"
}";
			false->
				proceed(QsVals)
		end,
	logger:log([?LOGPATH], "Call?check_handler: Response sent back. End#"),
	{FBody, Req, State}.

proceed(QSVals)->
	{_, Contact} = lists:keyfind(<<"contact">>, 1, QSVals),
	{_, Accrued} = lists:keyfind(<<"accrued">>, 1, QSVals),
	{_, Reporter} = lists:keyfind(<<"reportedBy">>, 1, QSVals),
	logger:log([?LOGPATH], io_lib:format("Call?check_handler: XXXX contact ~s has accrued ~s from ~s",[Contact, Accrued, Reporter])),
	StrContact = io_lib:format("~s",[Contact]),
	StrAccrued = io_lib:format("~s",[Accrued]),
	StrReporter = io_lib:format("~s",[Reporter]),
	case equal(StrContact,"")  or equal(StrAccrued, "") or equal(StrReporter, "") of 
		false -> send_report(StrContact, StrAccrued, StrReporter);
		true ->
"{
    \"status\": \"201\",
    \"message\": \"Either PARAMS [ contact, accrued, reportedBy ] NOT IN PAYLOAD\"
}"
	end.

% Push the report to the in memory DB
send_report(XContact, XAccrued, XReporter)->
	logger:log([?LOGPATH], io_lib:format("Call?check_handler: send_report | for contact ~s has accrued ~s from ~s",[XContact, XAccrued, XReporter])),
	XStatus = "True",
	DB = crbdbase:insert(stringify(XContact),XStatus,stringify(XReporter),stringify(XAccrued)),
	logger:log([?LOGPATH], io_lib:format("Call?check_handler: DB status ~p",[DB])),
	Body = 
"{
    \"status\": \"200\",
    \"message\": \"OK\"
}",
   	Body.

% Convert to string
 stringify(Item)->
         NItem = lists:flatten(Item),
         %logger:log([?LOGPATH], NItem),
         NItem.
