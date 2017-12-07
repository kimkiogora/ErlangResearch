# Credit Review System
An erlang powered system for storing and tracking credit defaulters

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
	{
	    "status": "200",
   	    "message": "Error"
	}
	```

* Example 1 - Check CRB
	* curl -H "Accept: application/json" -d '{"contact":"kimkiogora@gmail.com"}' http://localhost:9002/check
	```
	{
            "status": "200",
            "message": "FAIL"
        }

	```

* Example 2 - Report CRB
	* curl -H "Accept: application/json" -d '{"contact":"kimkiogora@gmail.com", "status":"1", "accrued":"2000"}' http://localhost:9002/report
	```
        {
            "status": "200",
            "message": "OK"
        }

        ```

* Example 3 - Update CRB
	* curl -H "Accept: application/json" -d '{"contact":"kimkiogora@gmail.com", "status":"0"}' http://localhost:9002/update
	```
        {
            "status": "200",
            "message": "OK"
        }

        ```
