set -e
if [ "$TEST_TYPE" = "all" ]; then
   robot -V generic_files/env_variables.py -d generic_files/output/. */*.robot
else
    robot -V generic_files/env_variables.py -d generic_files/output/. -i $TEST_TYPE  */*.robot
fi
