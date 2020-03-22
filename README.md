# Docker image that proxies and caches GCP Storage Bucket(s)

Initially thought as a local cache for Munki content.
Uses nytimes/gcs-helper and nginx

## Set in ENV:

The following environment variables control the behavior of gcs-helper/nginx:

| Variable                     | Default value | Required | Description                                                                                             |
| -----------------------------| ------------- | -------- | --------------------------------------------------------------------------------------------------------|
| GCS_HELPER_BUCKET_NAME       |               | Yes      | Name of the bucket                                                                                      |
| GCS_HELPER_LOG_LEVEL         | debug         | No       | Logging level                                                                                           |
| GCS_HELPER_PROXY_TIMEOUT     | 10s           | No       | Defines the maximum time in serving the proxy requests, this is a hard timeout and includes retries     |
| GCS_CLIENT_TIMEOUT           | 2s            | No       | Hard timeout on requests that gcs-helper sends to the Google Storage API                                |
| GCS_CLIENT_IDLE_CONN_TIMEOUT | 120s          | No       | Maximum duration of idle connections between gcs-helper and the Google Storage API                      |
| GCS_CLIENT_MAX_IDLE_CONNS    | 10            | No       | Maximum number of idle connections to keep open. This doesn't control the maximum number of connections |
| CACHE_MAX_SIZE               | 1g            | No       | Sets the upper limit of the size of the cache                                                           |
| CACHE_INACTIVE               | 1h            | No       | Specifies how long an item can remain in the cache without being accessed                               |

Requires a GCS json file with credentials for the bucket in question to be mapped to /etc/google-creds.json eg.

```
 -v /local/path/google-creds.json:/etc/google-creds.json:ro
```

in your docker command, or map another file with an env:

```
GOOGLE_APPLICATION_CREDENTIALS="/path/to/your/creds-file.json"
```

## Use at your own peril
