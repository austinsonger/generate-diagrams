from diagrams import Diagram
from diagrams.aws.compute import EC2
from diagrams.aws.network import ELB
from diagrams.aws.network import VPC, PrivateSubnet, PublicSubnet
from diagrams.aws.security import Shield, WAF
from diagrams.generic.network import Subnet
from diagrams.onprem.client import Users
from diagrams.aws.database import RDS
import datetime
import os

# Get the current date and time in YYYY-MM-DD-HH-MM-SS format
current_datetime = datetime.datetime.now().strftime('%Y-%m-%d-%H-%M-%S')

# Define the output directory and filename
output_directory = 'output'
output_file = f"{output_directory}/output-{current_datetime}.png"

# Create the 'output' directory if it doesn't exist
if not os.path.exists(output_directory):
    os.makedirs(output_directory)

# Generate the diagram and save it in the 'output' directory with the new file name
with Diagram("FedRAMP ABD Component Shell", show=False, filename=output_file):
    # Main shell representing the company infrastructure
    with Cluster("<Company> FedRAMP ABD Component Shell"):
        
        # Defining users (Customer User, Admin, CSP Admin, CSP Security)
        customer_user = Users("Customer User")
        customer_admin = Users("Customer Admin")
        csp_admin = Users("CSP Admin")
        csp_security = Users("CSP Security")

        # First security boundary (outer shell)
        with Cluster("Security Boundary 1"):
            with Cluster("VPC Boundary"):
                # Cloud resources in the VPC
                with Cluster("Green Zone"):
                    public_subnet = PublicSubnet("Public Subnet")
                    private_subnet = PrivateSubnet("Private Subnet")
                
                # Further components inside the VPC (App, DB, etc.)
                with Cluster("Blue Zone"):
                    app_instance = EC2("Application Server")
                    db_instance = EC2("Database Server")
                
                # Connections and resources inside the blue zone
                app_instance >> db_instance

            # Second security boundary (inner shell)
            with Cluster("Security Boundary 2"):
                # Replace Firewall with Security Group or another valid network resource
                internal_firewall = SecurityGroup("Internal Security Group")
                storage_instance = EC2("Storage Server")
                api_instance = EC2("API Server")

                # Connections between resources within the second security boundary
                storage_instance >> api_instance

        # External connections represented outside the main boundaries
        customer_user >> public_subnet
        customer_admin >> private_subnet
        csp_admin >> app_instance
        csp_security >> internal_firewall

print(f"Diagram saved as {output_file}")
