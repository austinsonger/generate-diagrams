from diagrams import Diagram
from diagrams.aws.compute import EC2
from diagrams.aws.network import ELB
from diagrams.aws.database import RDS
import datetime
import os

# Get the current date in YYYY-MM-DD format
current_date = datetime.datetime.now().strftime('%Y-%m-%d')

# Define the output directory and filename
output_directory = 'output'
output_file = f"{output_directory}/output-{current_date}.png"

# Create the 'Output' directory if it doesn't exist
if not os.path.exists(output_directory):
    os.makedirs(output_directory)

# Generate the diagram and save it in the 'Output' directory with the new file name
with Diagram("Simple Web Service", show=False, filename=output_file):
    ELB("lb") >> EC2("web") >> RDS("db")

print(f"Diagram saved as {output_file}")
