## ----setup, include=FALSE------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  concordance = TRUE
)

## ----loadLibrary---------------------------------------------------------
library("sos4R")

## ----cheatsheet, eval=FALSE----------------------------------------------
#  sosCheatSheet()

## ----demos, eval=FALSE---------------------------------------------------
#  # list available demos:
#  demo(package = "sos4R")
#  # run a demo:
#  demo("airquality")

## ----mySOS---------------------------------------------------------------
mySOS <- SOS(url = "http://sensorweb.demo.52north.org/sensorwebtestbed/service/kvp", binding = "KVP")

## ----connDetails1--------------------------------------------------------
sosUrl(mySOS)
sosTitle(mySOS)
sosAbstract(mySOS)
sosVersion(mySOS)
sosTimeFormat(mySOS)
sosBinding(mySOS)

## ----connDetails2,eval=FALSE---------------------------------------------
#  sosEncoders(mySOS)
#  sosParsers(mySOS)
#  sosDataFieldConverters(mySOS)

## ----connDetails3--------------------------------------------------------
mySOS
summary(mySOS)

## ----offering------------------------------------------------------------
off.1 <- sosOfferings(mySOS)[[1]]
summary(off.1)

## ----procedures----------------------------------------------------------
sosProcedures(off.1)

## ----obsprops------------------------------------------------------------
sosObservedProperties(off.1)

## ----fois----------------------------------------------------------------
sosFeaturesOfInterest(off.1)

## ----download------------------------------------------------------------
obs.1 <- getObservation(sos = mySOS,
  offering = off.1,
  procedure = sosProcedures(off.1)[[1]],
	observedProperty = sosObservedProperties(off.1)[1],
	eventTime = sosCreateTime(sos = mySOS, time = "2017-12-19::2017-12-20"))

## ----data----------------------------------------------------------------
#sosResult(data)
summary(sosResult(obs.1))

## ----inspect-------------------------------------------------------------
obs.1 <- getObservation(sos = mySOS, offering = off.1,
	procedure = sosProcedures(off.1)[[1]],
	observedProperty = sosObservedProperties(off.1)[1],
	eventTime = sosCreateTime(sos = mySOS, time = "2017-12-19::2017-12-20"),
	inspect = TRUE)

## ----verbose-------------------------------------------------------------
getObservation(sos = mySOS, offering = off.1,
	procedure = sosProcedures(off.1)[[1]],
	observedProperty = sosObservedProperties(off.1)[2],
	eventTime = sosCreateTime(sos = mySOS, time = "2018-01-01::2018-01-03"),
	verbose = TRUE)

## ----verbose_global, eval=FALSE------------------------------------------
#  verboseSOS <- SOS(sosUrl(mySOS),
#                    verboseOutput = TRUE,
#                    binding = sosBinding(mySOS),
#                    dcpFilter = mySOS@dcpFilter)

