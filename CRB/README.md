# Credit Review System
An erlang powered system for storing and tracking credit defaulters

# Dependencies
* Erlang - sudo apt-get install erlang
* Redis - sudo apt-get install redis

# Usage
* Example 1 - Check CRB
	* curl -H "Accept: application/json" -d '{"contact":"kimkiogora@gmail.com"}' http://localhost:8081/check

* Example 2 - Report CRB
	* curl -H "Accept: application/json" -d '{"contact":"kimkiogora@gmail.com", "status":"1", "accrued":"2000"}' http://localhost:8081/report

* Example 3 - Update CRB
	* curl -H "Accept: application/json" -d '{"contact":"kimkiogora@gmail.com", "status":"0"}' http://localhost:8081/update

