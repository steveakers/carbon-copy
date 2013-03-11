carbon-copy
===========

Carbon-copy allows you to reload an event from graphite to avoid losing resolution due to aggregation. The default reloads all the data at once, making it as current as possible. You can also choose to replay, which will load each datapoint as if it were occurring live.