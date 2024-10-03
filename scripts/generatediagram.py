from diagrams import Diagram
from diagrams.aws.compute import EC2
from diagrams.aws.network import ELB
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
with Diagram("Simple Web Service", show=False, filename=output_file):
    ELB("lb") >> EC2("web") >> RDS("db")

print(f"Diagram saved as {output_file}")
