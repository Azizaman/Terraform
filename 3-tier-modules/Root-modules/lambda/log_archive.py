import boto3
import gzip
import json
from datetime import datetime
import base64

s3 = boto3.client("s3")

def lambda_handler(event, context):
    data = event["awslogs"]["data"]
    decoded = gzip.decompress(base64.b64decode(data))
    log_data = json.loads(decoded)

    log_group  = log_data["logGroup"]
    timestamp  = datetime.utcnow().strftime("%Y-%m-%d-%H-%M-%S")
    
    key = f"{log_group}/{timestamp}.json"
    
    s3.put_object(
        Bucket="your-log-archive-bucket",
        Key=key,
        Body=json.dumps(log_data)
    )

    return {"status": "success", "file": key}
