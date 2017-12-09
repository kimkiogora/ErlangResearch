-module(crbdbase).
-author("kim kiogora <kimkiogora@gmail.com>").
-include("../crbserver/src/defaulters.hrl").
-include("/usr/lib/erlang/lib/stdlib-3.4.1/include/qlc.hrl"). 
-import(logger,[log/2]).
-export([init/0, insert/4, find/1, findall/0, findN/1, update/2]).
-define(LOGPATH, "/var/log/erlang/crbserver.log").

init()->
	 %mnesia:create_schema([node()]),
	 mnesia:start(),
	 mnesia:create_table(defaulters,
	                    [{attributes, record_info(fields, defaulters)},
	                     {disc_copies, [node()]}]),
	 mnesia:wait_for_tables([defaulters], 1000),
	 ok.

% Creates a record on our defaulters DB
insert(Contact, Status, Company, Amount)->
	%mnesia:start(),
	%mnesia:wait_for_tables([defaulters], 1000),
	Insert = fun()->mnesia:write(
			  #defaulters{contact=Contact,status=Status,company=Company,amount=Amount})
		 end,
	{atomic, Results} = mnesia:transaction(Insert),
	Results.

% Finds a record on our defaulters DB
find( Contact ) ->
	%mnesia:start(),
	%mnesia:wait_for_tables([defaulters], 1000),
	Query = fun() -> mnesia:match_object({defaulters, Contact, '_', '_', '_' } )
		end,
	Res = mnesia:transaction( Query),
	logger:log([?LOGPATH], io_lib:format("DB res ~p",[Res])),
	{_, YD } = Res,
	%{atomic, [Row]} = Res,
	logger:log([?LOGPATH], io_lib:format("Check if row is set ~p",[YD])),
	case YD =:= [] of 
		true -> 
			logger:log([?LOGPATH], "No match found"),
			[Contact,"FALSE"];
		false ->
			{atomic, [Row]} = Res,
			logger:log([?LOGPATH], "Found match"),
			[Row#defaulters.contact, Row#defaulters.status]
	end.

% Finds a record for update.
findN( Contact ) ->
        %mnesia:start(),
        %mnesia:wait_for_tables([defaulters], 1000),
        Query = fun() -> mnesia:match_object({defaulters, Contact, '_', '_', '_' } )
                 end,
	Res = mnesia:transaction( Query),
	logger:log([?LOGPATH], io_lib:format("DB res ~p",[Res])),
	{_, YD } = Res,
	logger:log([?LOGPATH], io_lib:format("Check if row is set ~p",[YD])),
	case YD =:= [] of
	        true ->
	               logger:log([?LOGPATH], "No match found"),[Contact,"FALSE","NA", "0"];
	        false ->
	               {atomic, [Row]} = Res,
	               logger:log([?LOGPATH], "Found match "),
		       [Row#defaulters.contact, Row#defaulters.status, Row#defaulters.company, Row#defaulters.amount]	                                                             
	end.

% Finds all records on the defaulters DB
findall()->
	%mnesia:start(),
	%mnesia:wait_for_tables([defaulters], 1000),
	Query =  
	    fun() -> qlc:eval( qlc:q([ X || X <- mnesia:table(defaulters)])) 
	    end,
	{atomic, Results} = mnesia:transaction(Query),
	Results.

% Updates a record.
update(Contact, Status)->
        [_,_, M, A] = findN(Contact),
        Res = insert(Contact, Status, M, A),
        Res.

