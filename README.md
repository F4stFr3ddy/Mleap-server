## Build & run

First build the pipeline:
```bash
virtualenv venv
source venv/bin/activate
pip install -r requirements.txt

python create_pipeline.py
```

Then create the server with the models:
```bash
docker build . -t mleap-server
docker run -p 8080:8080 mleap-server
```

## Model meta
```bash
curl --header "Content-Type: application/json" \
    --request GET \
    http://localhost:8080/models/rf/meta
```

Response:
```json
{"bundle":{"uid":"21d0de46-bf4d-4c14-baaa-7265f38cc1ee","name":"pipeline_5c0f3cba-8a2c-11ea-af72-acde48001122","format":"JSON","version":"0.15.0","timestamp":"2020-04-29T17:16:11.608142"},"inputSchema":{"fields":[{"name":"Pclass","dataType":{"base":"DOUBLE","shape":{"base":"SCALAR","isNullable":false}}}]},"outputSchema":{"fields":[{"name":"extracted_features","dataType":{"base":"DOUBLE","shape":{"base":"TENSOR","isNullable":true,"tensorShape":{"dimensions":[{"size":1,"name":""}]}}}},{"name":"raw_prediction","dataType":{"base":"DOUBLE","shape":{"base":"TENSOR","isNullable":true,"tensorShape":{"dimensions":[{"size":2,"name":""}]}}}},{"name":"probability","dataType":{"base":"DOUBLE","shape":{"base":"TENSOR","isNullable":true,"tensorShape":{"dimensions":[{"size":2,"name":""}]}}}},{"name":"Survived","dataType":{"base":"DOUBLE","shape":{"base":"SCALAR","isNullable":false}}}]}}
```


## Transform
```bash
body='{"schema": {"fields": [{"name": "Pclass","type": "double"}]},"rows": [[2.0]]}'

curl --header "Content-Type: application/json" \
  --header "timeout: 1000" \
  --request POST \
  --data "$body" http://localhost:8080/models/rf/transform
```

Response:
```json
{
  "schema": {
    "fields": [{
      "name": "Pclass",
      "type": "double"
    }, {
      "name": "extracted_features",
      "type": {
        "type": "tensor",
        "base": "double",
        "dimensions": [1]
      }
    }, {
      "name": "raw_prediction",
      "type": {
        "type": "tensor",
        "base": "double",
        "dimensions": [2]
      }
    }, {
      "name": "probability",
      "type": {
        "type": "tensor",
        "base": "double",
        "dimensions": [2]
      }
    }, {
      "name": "Survived",
      "type": {
        "type": "basic",
        "base": "double",
        "isNullable": false
      }
    }]
  },
  "rows": [[2.0, {
    "values": [2.0],
    "dimensions": [1]
  }, {
    "values": [5.733780255006897, 4.266219744993103],
    "dimensions": [2]
  }, {
    "values": [0.5733780255006897, 0.42662197449931033],
    "dimensions": [2]
  }, 0.0]]
}
```