# Generate Diagrams in Github Action

- [Directory Structure](#idirectory-structure)
- [Script](#script)
- [Actual Output](#actual-output)

## Directory Structure
```yaml
/generate-diagrams
├── README.md
├── .github/workflows/generate-diagram.yml
├── output
│   ├── README.md
│   ├── output-YYYY-MM-DD-HH-MM-SS.png.png
├── scripts
│   └── generatediagram.py
```

## Script
```bash
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
output_file = f"{output_directory}/output-{current_datetime}.png"

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
```


## Actual Output

![](output/output-2024-10-03-16-30-19.png.png)




