## ----setup, include=FALSE-----------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  concordance = TRUE
)

## ----loadLibrary--------------------------------------------------------------
library("sos4R")

## ----cheatsheet, eval=FALSE---------------------------------------------------
#  sosCheatSheet()

## ----demos, eval=FALSE--------------------------------------------------------
#  # list available demos:
#  demo(package = "sos4R")
#  # run a demo:
#  demo("airquality")

## ----mySOS--------------------------------------------------------------------
mySOS <- SOS(url = "http://sensorweb.demo.52north.org/sensorwebtestbed/service/kvp", binding = "KVP")

## ----connDetails1-------------------------------------------------------------
cat("URL:", sosUrl(mySOS), "\n")
cat("Title:", sosTitle(mySOS), "\n")
cat("Abstract:", sosAbstract(mySOS), "\n")
cat("Version:", sosVersion(mySOS), "\n")
cat("Time format:", sosTimeFormat(mySOS), "\n")
cat("Binding:", sosBinding(mySOS), "\n")

## ----connDetails2,eval=FALSE--------------------------------------------------
#  sosEncoders(mySOS)
#  sosParsers(mySOS)
#  sosDataFieldConverters(mySOS)

## ----connDetails3-------------------------------------------------------------
mySOS
summary(mySOS)

## ----offering-----------------------------------------------------------------
off.1 <- sosOfferings(mySOS)[["wwu-ws-kli-hsb"]]
summary(off.1)

## ----procedures---------------------------------------------------------------
sosProcedures(off.1)

## ----obsprops-----------------------------------------------------------------
sosObservedProperties(off.1)

## ----fois---------------------------------------------------------------------
sosFeaturesOfInterest(off.1)

## ----download-----------------------------------------------------------------
obs.1 <- getObservation(sos = mySOS,
  offering = off.1,
  procedure = sosProcedures(off.1)[[1]],
	observedProperty = sosObservedProperties(off.1)[1],
	eventTime = sosCreateTime(sos = mySOS, time = "2017-12-01::2017-12-31"))

## ----data---------------------------------------------------------------------
#sosResult(data)
summary(sosResult(obs.1))

## ----leftlet------------------------------------------------------------------
library("leaflet")

obs.1.spatial <- as(obs.1, "Spatial")
leaflet::leaflet(obs.1.spatial) %>%
  addTiles() %>%  # Add default OpenStreetMap map tiles
  addMarkers() %>%
  addMiniMap()

## ----mapview------------------------------------------------------------------
library("mapview")
library("leafpop")

plotfile <- tempfile(fileext = ".png")
png(filename = plotfile)
plot(x = obs.1.spatial$phenomenonTime, y = obs.1.spatial$AirTemperature,
     pch = 20,
     main = sosId(off.1), xlab = "Time", ylab = "Air Temperature")

#FIXME:mapview(obs.1.spatial, popup = leafpop::popupImage(plotfile, embed = TRUE))
mapview(obs.1.spatial)

## ----inspect------------------------------------------------------------------
obs.1 <- getObservation(sos = mySOS, offering = off.1,
	procedure = sosProcedures(off.1)[[1]],
	observedProperty = sosObservedProperties(off.1)[1],
	eventTime = sosCreateTime(sos = mySOS, time = "2017-12-19::2017-12-20"),
	inspect = TRUE)

## ----verbose------------------------------------------------------------------
getObservation(sos = mySOS, offering = off.1,
	procedure = sosProcedures(off.1)[[1]],
	observedProperty = sosObservedProperties(off.1)[2],
	eventTime = sosCreateTime(sos = mySOS, time = "2018-01-01::2018-01-03"),
	verbose = TRUE)

## ----verbose_global, eval=FALSE-----------------------------------------------
#  verboseSOS <- SOS(sosUrl(mySOS),
#                    verboseOutput = TRUE,
#                    binding = sosBinding(mySOS),
#                    dcpFilter = mySOS@dcpFilter)

