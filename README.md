### NAME

**carbon-copy** - loads data from a JSON file into Graphite

###SYNOPSIS

**carbon-copy** [options] \<data_source>

###DESCRIPTION

**carbon-copy** can be used to reload event data from Graphite in JSON format into the same or differnt Graphite
instace. There are two primary methods of reloading the data.

If no options are supplied, all the data will be loaded at once and the timestamps will be adjusted to make the
data appear as recent as possible. If *--replay* is provided, the data will be loaded as if it were occurring live
even if multiple targets are present in the data source.

###OPTIONS

**carbon-copy**'s default mode is to reload all data at once into a local Graphite instance.

These options can be used to change this behavior:

**-h, --host <s>**<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Graphite hostname (default: localhost)

**-p, --port <i>**<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Graphite line port (default: 2003)

**-v, --verbose**<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Enable verbose output

**-r, --replay**<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Replays data as if it were live

You may additional check the version or ask for help:

**-e, --version**<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Print version and exit

**-l, --help**<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Print help and exit

###SAMPLE DATA
```
[
    {
        "target": "stats_counts.ad_server.web_traffic.impression",
        "datapoints": [
            [55.0, 1362710720],
            [51.0, 1362710730],
            [49.0, 1362710740],
            [54.0, 1362710750],
            [52.0, 1362710760],
            [null, 1362710770]
        ]
    }
]
```
