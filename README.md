# Technical exercise 

Here you have some terraform, which does not work! 
Please fix it and send us your fixed version.
Feel free to add useful functionality where you feel its appropriate and please list out any questions or assumptions you make.

# +++++++++++++++++

The terraform file had the following error intially.

to debug the error, I run the 'terraform plan' command.

++++++++++++++++++++++++++++++++++++++++++++


-by changing it from 'var.env' to var.environment help me to fix this issue.

- the CIDR block "10.0.2.0/16" is invalid, and the correct block should be "10.0.0.0/16", which is logical error | Classified Subnet

-The error was caused because you referenced the IAM role incorrectly. Instead of using aws_iam_role.ecs.execution_role.arn, the correct reference should be aws_iam_role.ecs_execution_role.arn. Fixing this typo resolved the issue.


Other some tweaks are done in the code. To make it more secure.
-Break Down code into section to debug easilt
-Ensured subnets have unique CIDR blocks.
-Correct port mappings for the load balancer .
-Move RDS to private subnets for security.
-Fix the route table CIDR block (0.0.0.0/0) for internet gateway
-Review security group settings, especially for the database, to ensure it's not publicly exposed.
-other mentioned in code.

# Break Things!! Then F!x It!!

# The Real Learning happened here.