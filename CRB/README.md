# Credit Review System
An erlang powered system for storing and tracking credit defaulters
API uses GET protocol

# Dependencies
* Erlang - sudo apt-get install erlang
* Redis - sudo apt-get install redis

# Usage
* Run the server
	* cd crbserver/
	* ./_rel/crbserver_release/bin/crbserver_release status
	* ./_rel/crbserver_release/bin/crbserver_release start
	* ./_rel/crbserver_release/bin/crbserver_release stop
* Check the server - curl -H "Accept: application/json" http://localhost:9002/
	```
	Response

	{
	    "status": "200",
 	    "message": "Error"
	}

* Example 1 - Check CRB
	* curl -H "Accept: application/json" http://localhost:9002/check?contact=XXXYYY
	```
	Respose - FAIL means contact is no in CRB, OK means otherwise

	{
	    "status": "200",
	    "message": "FAIL"
	}

* Example 2 - Report CRB
	* curl -H "Accept: application/json" http://localhost:9002/report?contact=XXXYYYZZZ&status=1&accrued=2000
	```
	Response - OK means its saved in CRB, FAIL means otherwise
	
	{
	    "status": "200",
	    "message": "OK"
	}


* Example 3 - Update CRB - status can be False/True
	* curl -H "Accept: application/json" http://localhost:9002/update?status=False
	```
	Response - OK means its saved in CRB, FAIL means otherwise
	{
	    "status": "200",
	    "message": "OK"
	}

