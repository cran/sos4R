## ---- include = FALSE---------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----setup--------------------------------------------------------------------
library("sos4R")
mySos <- SOS(url = "https://climate-sos.niwa.co.nz/",
             binding = "KVP", useDCPs = FALSE, version = "2.0.0")
maxOutputRowsPerExample <- 5
maxOutputColumnsPerExample <- 3

## ----shiny_app, eval=FALSE----------------------------------------------------
#  shiny::runApp(appDir = file.path(path.package("sos4R"), "shiny"))

## ----phenomena----------------------------------------------------------------
phenomena <- phenomena(sos = mySos)
str(phenomena)

## ----phenomena_table----------------------------------------------------------
phenomena[1:maxOutputRowsPerExample,]

## ----phenomena_include_time---------------------------------------------------
phenomena(sos = mySos, includeTemporalBBox = TRUE)[1:maxOutputRowsPerExample,]

## ----phenomena_include_siteid-------------------------------------------------
phenomena(sos = mySos, includeSiteId = TRUE)[1:maxOutputRowsPerExample,]

## ----phenomena_include_all----------------------------------------------------
phenomena(sos = mySos, includeTemporalBBox = TRUE, includeSiteId = TRUE)[1:maxOutputRowsPerExample,]

## ----sites--------------------------------------------------------------------
sites <- sites(sos = mySos)
sites[1:maxOutputRowsPerExample,]

## ----sites_empty--------------------------------------------------------------
sites_with_empty <- sites(sos = mySos, empty = TRUE)
sites_with_empty[1:maxOutputRowsPerExample,]

## ----sites_metadata_phen------------------------------------------------------
sites_with_phenomena <- sites(sos = mySos, includePhenomena = TRUE)
sites_with_phenomena[1:maxOutputRowsPerExample, 1:maxOutputColumnsPerExample]

## ----sites_metadata_temporal--------------------------------------------------
sites_with_temporal_bbox <- sites(sos = mySos, includePhenomena = TRUE, includeTemporalBBox = TRUE)
tail(sites_with_temporal_bbox, n = 3)[,1:maxOutputColumnsPerExample]

## ----sites_with_temporal_bbox_structure---------------------------------------
str(tail(sites_with_temporal_bbox, n = 3)[,1:maxOutputColumnsPerExample])

## ----sites_filtered_by_phenomena----------------------------------------------
sites_filtered_by_phenomena <- sites(sos = mySos, phenomena = phenomena[3,])
nrow(sites_filtered_by_phenomena@data)
str(sites_filtered_by_phenomena)

## ----sites_filtered_by_phenomena_with_metadata--------------------------------
sites_filtered_by_phenomena_with_metadata <- sites(sos = mySos, phenomena = phenomena[3,], includePhenomena = TRUE, includeTemporalBBox = TRUE)
str(sites_filtered_by_phenomena_with_metadata)

## ----sites_filtered_by_time---------------------------------------------------
# under development - no github issue atm
#sites_filtered_by_time <- sites(sos = mySos, begin = parsedate::parse_iso_8601("1904-01-01"), end = parsedate::parse_iso_8601("1905-12-31"))
#nrow(sites_filtered_by_time@data)
#str(sites_filtered_by_time)

## ----sites_coords-------------------------------------------------------------
sp::coordinates(sites)[1:maxOutputRowsPerExample,]

## ----sites_projection---------------------------------------------------------
sites@proj4string

## ----sites_bbox---------------------------------------------------------------
sp::bbox(sites)

## ----sites_map----------------------------------------------------------------
suppressPackageStartupMessages(library("mapview"))

mapview(sites, legend = FALSE, col.regions = "blue")

## ----siteList-----------------------------------------------------------------
siteList <- siteList(sos = mySos)
str(siteList)

## ----siteList_empty-----------------------------------------------------------
siteList_with_empty <- siteList(sos = mySos, empty = TRUE)
siteList_with_empty[1:maxOutputRowsPerExample,]

## ----siteList_includes--------------------------------------------------------
# under development - https://github.com/52North/sos4R/issues/90
#siteListe_with_metadata <- siteList(sos = mySos, includePhenomena = TRUE, includeTemporalBBox = TRUE)
#siteListe_with_metadata[1:maxOutputRowsPerExample,]

## ----siteList_phenomena_time--------------------------------------------------
siteList_filtered_by_time_and_phenomenon <- siteList(sos = mySos,
         phenomena = phenomena$phenomenon[1:2],
         begin = as.POSIXct("1950-01-01"), end = as.POSIXct("1960-12-31")
         )
siteList_filtered_by_time_and_phenomenon

## ----getData_single-----------------------------------------------------------
observationData <- getData(sos = mySos,
                           phenomena = phenomena[18,1],
                           sites = siteList[1:2,1])
str(observationData)

## ----getData_attributes-------------------------------------------------------
attributes(observationData[[3]])

## ----getData_temporal---------------------------------------------------------
observationData <- getData(sos = mySos,
                           phenomena = phenomena[18,1],
                           sites = siteList[1,1],
                           begin = parsedate::parse_iso_8601("1970-01-01T12:00:00+12:00"),
                           end = parsedate::parse_iso_8601("2000-01-02T12:00:00+12:00")
                           )

str(observationData)

## ----getData_summary----------------------------------------------------------
summary(observationData)

## ----getData_timeseries_plot--------------------------------------------------
suppressPackageStartupMessages(library(xts))
ts1056 <- xts(observationData[observationData$siteID == '1056',3], observationData[observationData$siteID == '1056',"timestamp"])
names(ts1056) <- "#1056"
plot(x = ts1056, main = "Monthly: Extreme max. Temp. (°C)", yaxis.right = FALSE, legend.loc = 'topleft')

## ----getData_multipleA--------------------------------------------------------
# TO BE IMPLEMENTED: merge different observation types - see https://github.com/52North/sos4R/issues/96#issuecomment-493424151
observationData <- getData(sos = mySos,
       phenomena = phenomena$phenomenon[1:2],
       sites = siteList$siteID[c(1,58)],
       begin = parsedate::parse_iso_8601("1994-12-31T12:00:00+12:00"),
       end = parsedate::parse_iso_8601("1995-12-31T12:00:00+12:00")
       )
str(observationData)

## ----getData_multipleB--------------------------------------------------------
multipleSites <- siteList$siteID[1:2]
observationData <- getData(sos = mySos,
                           phenomena = phenomena[18, 1],
                           sites = multipleSites,
                           begin = parsedate::parse_iso_8601("1997-01-01T12:00:00+12:00"),
                           end = parsedate::parse_iso_8601("2000-01-02T12:00:00+12:00")
                           )


ts1056 <- xts(observationData[observationData$siteID == '1056', 3], observationData[observationData$siteID == '1056',"timestamp"])
names(ts1056) <- "Station#1056"
ts11234 <- xts(observationData[observationData$siteID == '11234', 3], observationData[observationData$siteID == '11234',"timestamp"])
names(ts11234) <- "Station#11234"
plot(x = na.fill(merge(ts1056, ts11234), list(NA, "extend", NA)), main = "Monthly: Extreme max. Temp. (°C)", yaxis.right = FALSE, legend.loc = 'topleft')

## ----map_of_sites_of_timeseries-----------------------------------------------
sites_of_timeseries <- sites[sites$siteID == "1056" | sites$siteID == "11234",]
mapview(sites_of_timeseries, legend = FALSE, col.regions = "blue")

