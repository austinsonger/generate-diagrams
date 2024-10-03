from diagrams import Cluster, Diagram
from diagrams.aws.compute import ECS, EKS, Lambda
from diagrams.aws.database import Redshift
from diagrams.aws.integration import SQS
from diagrams.aws.storage import S3
import datetime
import os

# Get the current date and time in YYYY-MM-DD-HH-MM-SS format
current_datetime = datetime.datetime.now().strftime('%Y-%m-%d-%H-%M-%S')

# Define the output directory and filename
output_directory = 'output'
output_file = f"{output_directory}/mingrammer/output-{current_datetime}.png"

# Create the 'output' directory if it doesn't exist
if not os.path.exists(output_directory):
    os.makedirs(output_directory)

with Diagram("Event Processing", show=False, filename=output_file):
    source = EKS("k8s source")
    # Main shell representing the company infrastructure
    with Cluster("Event Flows"):
        with Cluster("Event Workers"):
            workers = [ECS("worker1"),
                       ECS("worker2"),
                       ECS("worker3")]

        queue = SQS("event queue")

        with Cluster("Processing"):
            handlers = [Lambda("proc1"),
                        Lambda("proc2"),
                        Lambda("proc3")]

    store = S3("events store")
    dw = Redshift("analytics")

    source >> workers >> queue >> handlers
    handlers >> store
    handlers >> dw

print(f"Diagram saved as {output_file}")
