# Introduction  
**Robot Framework** is a generic open source automation framework for acceptance testing, acceptance test driven development (ATDD), and robotic process automation (RPA). It has easy-to-use tabular test data syntax and it utilizes the keyword-driven testing approach. Its testing capabilities can be extended by test libraries implemented either with Python or Java, and users can create new higher-level keywords from existing ones using the same syntax that is used for creating test cases. Refer the official website of [Robot Framework](https://robotframework.org/).

# Prerequisites
 Docker should be installed.

# Usage  
Follow the below steps to run the test cases on your system    
Step #1: Clone this repository and open the *robot* directory.
Step #2: Assign proper values to the environment variables declared in the docker-compose.yml file.
Step #3: Now run the following command to execute smoke test cases
~~~
    docker-compose up -d
~~~
The above command will execute all the test cases.
If you want to execute only the *smoke test cases* then assign *smoke* to *TEST_TYPE* variable in the docker-compose.yml file and then run the same docker command.  

Similarly, to execute only the *sanity test cases*, assign *sanity* to *TEST_TYPE* variable in the docker-compose.yml file and then run the docker command.

## Checking the results
Once after running the docker command, 3 files will be generated, viz., log.html, report.html and output.xml. The report files will be present in the *generic_files* directory. You can go through these files by opening them in a browser. You can also see the docker logs by running the command. 
~~~
    docker logs -f aikaan-robot
~~~
