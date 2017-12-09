-module(db).
-include("src/defaulters.hrl").
-include("/usr/lib/erlang/lib/stdlib-3.4.1/include/qlc.hrl"). 
-export([init/0, insert/4, find/1, findall/0, findN/1, update/2]).

init() ->
	%application:set_env(mnesia, dir, "db/")
	mnesia:create_schema([node()]),
	mnesia:start(),
	mnesia:create_table(defaulters,
			    [{attributes, record_info(fields, defaulters)},
			     {disc_copies, [node()]}]),
	ok.

insert(Contact, Status, Company, Amount)->
	mnesia:start(),
	mnesia:wait_for_tables([defaulters], 1000),
	Insert = fun()->mnesia:write(
			  #defaulters{contact=Contact,status=Status,company=Company,amount=Amount})
		 end,
	{atomic, Results} = mnesia:transaction(Insert),
	Results.

find( Contact ) ->
	mnesia:start(),
	mnesia:wait_for_tables([defaulters], 1000),
	Query = fun() -> mnesia:match_object({defaulters, Contact, '_', '_', '_' } )
		end,
%	{atomic, Results} = mnesia:transaction( Query),
	{atomic, [Row]} = mnesia:transaction( Query),
	[Row#defaulters.contact, Row#defaulters.status].

findN( Contact ) ->
	mnesia:start(),
	mnesia:wait_for_tables([defaulters], 1000),
	Query = fun() -> mnesia:match_object({defaulters, Contact, '_', '_', '_' } )
	        end,
	{atomic, [Row]} = mnesia:transaction( Query),
	[Row#defaulters.contact, Row#defaulters.status, Row#defaulters.company,Row#defaulters.amount].
				

findall()->
	mnesia:start(),
	mnesia:wait_for_tables([defaulters], 1000),
	Query =  
	    fun() -> qlc:eval( qlc:q([ X || X <- mnesia:table(defaulters)])) 
	    end,
	{atomic, Results} = mnesia:transaction(Query),
	Results.

update(Contact, Status)->
	[_,_, M, A] = findN(Contact),
	Res = insert(Contact, Status, M, A),
	Res.
