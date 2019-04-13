## ----setup, include = FALSE----------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  concordance = TRUE
)

## ----loadPackage---------------------------------------------------------
library("sos4R")

## ----supported01---------------------------------------------------------
SosSupportedOperations()
SosSupportedServiceVersions()
SosSupportedBindings()
SosSupportedResponseFormats()

## ----supported02---------------------------------------------------------
SosSupportedResponseModes()
SosSupportedResultModels()

## ----supported03---------------------------------------------------------
SosSupportedSpatialOperators()

## ----supported04---------------------------------------------------------
toString(SosSupportedTemporalOperators())

## ----default-------------------------------------------------------------
SosDefaultBinding()
SosDefaults()

## ----converterFunc, eval=FALSE-------------------------------------------
#  SosEncodingFunctions()
#  SosParsingFunctions()
#  SosDataFieldConvertingFunctions()

## ----conn----------------------------------------------------------------
mySOS <- SOS(url = "http://sensorweb.demo.52north.org/sensorwebtestbed/service/kvp", binding = "KVP")

## ----connDetails1, eval=FALSE--------------------------------------------
#  sosUrl(mySOS)
#  sosTitle(mySOS)
#  sosAbstract(mySOS)
#  sosVersion(mySOS)
#  sosTimeFormat(mySOS)
#  sosBinding(mySOS)

## ----connDetails2, eval=FALSE--------------------------------------------
#  sosEncoders(mySOS)
#  sosParsers(mySOS)
#  sosDataFieldConverters(mySOS)

## ----connDetails3--------------------------------------------------------
mySOS
summary(mySOS)

## ----capsOriginal, eval=FALSE--------------------------------------------
#  sosCapabilitiesDocumentOriginal(sos = mySOS)

## ----getCap1, eval=FALSE-------------------------------------------------
#  getCapabilities(sos = mySOS)

## ----getCap2a------------------------------------------------------------
sosServiceIdentification(mySOS)

## ----getCap2b------------------------------------------------------------
sosServiceProvider(mySOS)

## ----getCap2c------------------------------------------------------------
sosFilter_Capabilities(mySOS)

## ----getCap2d------------------------------------------------------------
sosContents(mySOS)

## ----getCap3-------------------------------------------------------------
sosTime(mySOS)

## ----getCap4, eval=FALSE-------------------------------------------------
#  sosOperationsMetadata(mySOS)
#  sosOperation(mySOS, "GetCapabilities")
#  sosOperation(mySOS, sosGetCapabilitiesName)

## ----getCap5a------------------------------------------------------------
sosResponseFormats(mySOS)

## ----getCap5b------------------------------------------------------------
sosResponseMode(mySOS)

## ----getCap5c------------------------------------------------------------
sosResultModels(mySOS)

## ----getCap6-------------------------------------------------------------
sosResponseMode(mySOS, unique = TRUE)

## ----getCap9-------------------------------------------------------------
toString(sosResultModels(mySOS)[[sosGetObservationName]])

## ----getCap10------------------------------------------------------------
unlist(sosResponseFormats(mySOS)[[sosGetObservationName]])

## ----getCRSa-------------------------------------------------------------
sosGetCRS("urn:ogc:def:crs:EPSG::4326")

## ----getCRSb-------------------------------------------------------------
# returns the CRS of offering(s) based on the CRS
# used in the element gml:boundedBy:
sosGetCRS(mySOS)[1:2]

## ----getCRSc-------------------------------------------------------------
sosGetCRS(sosOfferings(mySOS)[[1]])

## ----sosPlot-------------------------------------------------------------
# background map:
library("maps"); library("mapdata"); library("maptools")
data(worldHiresMapEnv)
crs <- sosGetCRS(mySOS)[[1]]
worldHigh <- pruneMap(
		map(database = "worldHires",
			region = c("Germany", "Austria", "Netherlands"),
			plot = FALSE))
worldHigh.lines <- map2SpatialLines(worldHigh, proj4string = crs)

# the plot:
plot(worldHigh.lines, col = "grey50")
plot(mySOS, add = TRUE, lwd = 3)
title(main = paste("Offerings by '", sosTitle(mySOS), "'", sep = ""),
		sub = toString(names(sosOfferings(mySOS))))

## ----describeSensor1-----------------------------------------------------
mySensor <- describeSensor(sos = mySOS,
		procedure = sosProcedures(mySOS)[[1]],
		outputFormat = 'text/xml; subtype="sensorML/1.0.1"', # space is needed!
		)

mySensor

## ----describeSensor2, eval=FALSE-----------------------------------------
#  sosCoordinates(mySensor)

## ----describeSensor3, eval=FALSE-----------------------------------------
#  sosId(mySensor)
#  sosName(mySensor)
#  sosAbstract(mySensor)

## ----describeSensorCoords, eval=FALSE------------------------------------
#  mySensor.coords <- sosCoordinates(mySensor)
#  attributes(mySensor.coords)

## ----box-----------------------------------------------------------------
sosBoundedBy(mySensor)

## ----describeSensorPlotCodeForText, eval=FALSE---------------------------
#  library("maps"); library("mapdata"); library("maptools")
#  data(worldHiresMapEnv)
#  
#  # get sensor descriptions
#  procs <- unique(unlist(sosProcedures(mySOS)))
#  procs.descr <- lapply(X = procs, FUN = describeSensor,
#                        sos = mySOS,
#                        outputFormat = 'text/xml; subtype="sensorML/1.0.1"')
#  
#  sensors.crs <- sosGetCRS(procs.descr[[1]])
#  worldHigh <- pruneMap(map(database = "worldHires",
#                            region = c("Germany"),
#                            plot = FALSE))
#  worldHigh.lines <- map2SpatialLines(worldHigh, proj4string = sensors.crs)
#  
#  plot(worldHigh.lines, col = "grey50", ylim = c(44.0, 54.8))
#  for(x in procs.descr)
#  	plot(x, add = TRUE, pch = 19)
#  text(sosCoordinates(procs.descr)[c("x", "y")],
#  		labels = sosId(procs.descr), pos = 4, cex = 0.8)
#  title(main = paste("Sensors of", sosTitle(mySOS)))

## ----metadataExtraction1a, eval=FALSE------------------------------------
#  sosOfferings(mySOS)

## ----metadataExtraction1b------------------------------------------------
#length(sosOfferings(mySOS))
sosOfferings(mySOS)[[1]]

## ----metadataExtraction1c------------------------------------------------
summary(sosOfferings(mySOS)[[1]])

## ----metadataExtraction2a------------------------------------------------
sosOfferingIds(mySOS)

## ----metadataExtraction2b------------------------------------------------
names(sosOfferings(mySOS))

## ----metadataExtraction2c------------------------------------------------
sosName(sosOfferings(mySOS))

## ----metadataExtraction3-------------------------------------------------
myOffering <- sosOfferings(mySOS)[["ws2500"]]

## ----metadataExtraction4a------------------------------------------------
sosId(myOffering)
sosName(myOffering)

## ----metadataExtraction4b------------------------------------------------
sosResultModels(myOffering)

## ----metadataExtraction4c------------------------------------------------
sosResponseMode(myOffering)

## ----metadataExtraction4d------------------------------------------------
sosResponseFormats(myOffering)

## ----metadataExtraction5-------------------------------------------------
sosBoundedBy(myOffering)

## ----metadataExtraction6-------------------------------------------------
sosBoundedBy(myOffering, bbox = TRUE)

## ----metadataExtraction7a------------------------------------------------
myOffering.time <- sosTime(myOffering)
str(myOffering.time)

## ----metadataExtraction7b------------------------------------------------
myOffering.time@beginPosition@time
myOffering.time@endPosition@time
class(myOffering.time@endPosition@time)

## ----metadataExtraction8-------------------------------------------------
myOffering.time.converted <- sosTime(myOffering, convert = TRUE)
str(myOffering.time.converted)

## ----metadataExtraction9-------------------------------------------------
sosProcedures(myOffering)
sosObservedProperties(myOffering)
sosFeaturesOfInterest(myOffering)

## ----metadataExtraction10a-----------------------------------------------
sosProcedures(mySOS)[1:2]

## ----metadataExtraction10b-----------------------------------------------
sosObservedProperties(mySOS)[1:2]

## ----metadataExtraction10c-----------------------------------------------
sosFeaturesOfInterest(mySOS)[1:2]

## ----metadataExtraction10d-----------------------------------------------
sosProcedures(sosOfferings(mySOS)[2:3])

## ----metadataExtraction10e-----------------------------------------------
sosObservedProperties(sosOfferings(mySOS)[2:3])

## ----metadataExtraction10f-----------------------------------------------
sosFeaturesOfInterest(sosOfferings(mySOS)[1:2])

## ----getObservation, eval=FALSE------------------------------------------
#  getObservation(sos = mySOS, offering = myOffering, ...)

## ----defaultValue--------------------------------------------------------
defaultResponseFormatGetObs <- gsub(pattern = "&quot;", replacement = "'", x = sosDefaultGetObsResponseFormat)
defaultResponseFormatGetObs

## ----getObsPropPhen1, eval=FALSE-----------------------------------------
#  myObservationData.procedure.1 <- getObservation(sos = mySOS,
#  	offering = myOffering)

## ----getObsPropPhen2, eval=FALSE-----------------------------------------
#  getObservation(sos = mySOS,
#  	offering = myOffering,
#  	procedure = sosProcedures(myOffering),
#  	#procedure = sosProcedures(myOffering)[[1]],
#  	observedProperty = as.list(names(sosObservedProperties(mySOS)[3:4])))

## ----getObs0-------------------------------------------------------------
myObservationData <- getObservation(sos = mySOS,
		offering = myOffering,
		eventTime = sosCreateTime(sos = mySOS,
		                          time = "2018-01-01::2018-01-06"))

## ----getObs1a------------------------------------------------------------
class(myObservationData)
str(myObservationData, max.level = 2)

## ----getObs1b------------------------------------------------------------
length(myObservationData)

## ----getObs1c------------------------------------------------------------
myObservationData[[1]]

## ----getObs1d------------------------------------------------------------
summary(myObservationData)

## ----getObs1e------------------------------------------------------------
summary(myObservationData[[1]])

## ----getObs1f, eval=FALSE------------------------------------------------
#  myObservationData[2:3]

## ----getObs1_foi---------------------------------------------------------
index.foiId <- sosFeaturesOfInterest(myOffering)[[1]]
index.foiId
cat("------\n")
myObservationData[index.foiId]

## ----getObs1_obsprop-----------------------------------------------------
index.obsProp <- sosObservedProperties(myOffering)[[1]]
index.obsProp
cat("------\n")
myObservationData[index.obsProp]

## ----getObs1_proc--------------------------------------------------------
index.proc <- sosProcedures(myOffering)
index.proc.alternative1 <- sosProcedures(myOffering)[1]
index.proc.alternative2 <- sosProcedures(mySOS)

index.proc
cat("------\n")
myObservationData[index.proc]

## ----getObs2a------------------------------------------------------------
names(myObservationData)

## ----getObs2b------------------------------------------------------------
myObservationData.result.2 <- sosResult(myObservationData[[1]])
myObservationData.result.2

## ----getObs3a------------------------------------------------------------
attributes(myObservationData.result.2)

## ----getObs3b------------------------------------------------------------
attributes(myObservationData.result.2[["phenomenonTime"]])

## ----getObs3c------------------------------------------------------------
attributes(myObservationData.result.2[["AirTemperature"]])

## ----getObsSpatial1a-----------------------------------------------------
sosFeatureIds(myObservationData)

## ----getObsSpatial1b, eval = FALSE---------------------------------------
#  sosCoordinates(myObservationData)
#  sosCoordinates(myObservationData[[1]])

## ----getObsSpatial1c-----------------------------------------------------
sosBoundedBy(myObservationData)

## ----getObsSpatial1d-----------------------------------------------------
sosBoundedBy(myObservationData, bbox = TRUE)

## ----getObsSpatial3, eval=FALSE------------------------------------------
#  myObservationData.data <- merge(x = myObservationData.result.2, y = myObservationData.coords)
#  str(myObservationData.data, max.level = 2)

## ----getObsSpatial4, eval=FALSE------------------------------------------
#  head(sosResult(myObservationData[1], coordinates = TRUE))

## ----temporalFiltering1a-------------------------------------------------
# temporal interval creation based on POSIXt classes:
lastWeek.period <- sosCreateTimePeriod(sos = mySOS,
	begin = (Sys.time() - 3600 * 24 * 7),
	end = Sys.time())

period <- sosCreateTimePeriod(sos = mySOS,
		begin = as.POSIXct("2015/11/01"),
		end = as.POSIXct("2015/11/02"))
eventTime <- sosCreateEventTimeList(period)
eventTime

## ----temporalFiltering1b-------------------------------------------------
sosCreateTime(sos = mySOS, time = "2007-07-07 07:00::2008-08-08 08:00")
sosCreateTime(sos = mySOS, time = "2007-07-07 07:00/2010-10-10 10:00")

sosCreateTime(sos = mySOS, time = "::2007-08-05")
sosCreateTime(sos = mySOS, time = "2007-08-05/")

## ----temporalFiltering2a-------------------------------------------------
mySOSpox <- SOS(url = "http://sensorweb.demo.52north.org/sensorwebtestbed/service/pox", 
             binding = "POX", useDCPs = FALSE)
nov2015 <- getObservation(sos = mySOSpox,
                          offering = myOffering,
                          eventTime = eventTime)

## ----temporalFiltering2b-------------------------------------------------
nov2015.result.1 <- sosResult(nov2015[[1]])
summary(nov2015.result.1)

## ----temporalFiltering3--------------------------------------------------
lastDay.instant <- sosCreateTimeInstant(
	time = as.POSIXct(Sys.time() - 3600 * 24), sos = mySOSpox)
lastDay.eventTime <- sosCreateEventTime(time = lastDay.instant,
	operator = SosSupportedTemporalOperators()[["TM_After"]])
print(lastDay.eventTime)

## ----temporalFiltering4--------------------------------------------------
sept15.period <- sosCreateTimePeriod(sos = mySOS,
                                     begin = as.POSIXct("2015-09-01 00:00"),
                                     end = as.POSIXct("2015-09-30 00:00"))
sept15.eventTimeList <- sosCreateEventTimeList(sept15.period)
obs.sept15 <- getObservation(sos = mySOS,
	offering = myOffering,
	eventTime = sept15.eventTimeList)

## ----spatialFiltering3---------------------------------------------------
request.bbox <- sosCreateBBOX(lowLat = 5.0, lowLon = 1.0,
                              uppLat = 10.0, uppLon = 3.0,
                              srsName = "urn:ogc:def:crs:EPSG::4326")
request.bbox.foi <- sosCreateFeatureOfInterest(spatialOps = request.bbox)

obs.sept15.bbox <- getObservation(sos = mySOSpox,
                                  offering = myOffering,
                                  featureOfInterest = request.bbox.foi,
                                  eventTime = sept15.eventTimeList)

## ----spatialFiltering1b--------------------------------------------------
summary(sosCoordinates(obs.sept15))
cat("--------\n")
sosCoordinates(obs.sept15.bbox)

## ----featureFiltering1---------------------------------------------------
myOffering.fois <- sosFeaturesOfInterest(myOffering)
request.fois <- sosCreateFeatureOfInterest(
	objectIDs = list(myOffering.fois[[1]]))
encodeXML(obj = request.fois, sos = mySOSpox)

## ----featureFiltering1a--------------------------------------------------
obs.oneWeek.fois <- getObservation(sos = mySOSpox,
	offering = myOffering,
	featureOfInterest = request.fois,
	eventTime = eventTime)

## ----featureFiltering1b--------------------------------------------------
length(sosFeaturesOfInterest(obs.oneWeek.fois))

## ----valueFiltering1, eval=FALSE-----------------------------------------
#  # TODO update result filter example with xml2
#  #filter.value <- -2.3
#  #filter.propertyname <- xmlNode(name = ogcPropertyNameName, namespace = ogcNamespacePrefix)
#  #xmlValue(filter.propertyname) <- "urn:ogc:def:property:OGC::Temperature"
#  #filter.literal <- xmlNode(name = ogcLiteralName, namespace = ogcNamespacePrefix)
#  #xmlValue(filter.literal) <- as.character(filter.value)
#  #filter.comparisonop <- xmlNode(name = ogcComparisonOpGreaterThanName,
#  #                               namespace = ogcNamespacePrefix,
#  #                               .children = list(filter.propertyname,
#  #                                                filter.literal))
#  #filter.result <- xmlNode(name = sosResultName,
#  #                         namespace = sosNamespacePrefix,
#  #                         .children = list(filter.comparisonop))

## ----valueFiltering2, eval=FALSE-----------------------------------------
#  filter.result

## ----valueFiltering3a, eval=FALSE----------------------------------------
#  obs.oneWeek.filter <- getObservation(sos = mySOS,
#  		eventTime = eventTime,
#  		offering = sosOfferings(mySOS)[["wxt520"]],
#  		result = filter.result)

## ----valueFiltering3b, eval=FALSE----------------------------------------
#  # request  values for the week with a value higher than 0 degrees:
#  obs.oneWeek.filter <- getObservation(sos = mySOS,
#  	eventTime = eventTime,
#  	offering = sosOfferings(mySOS)[["ATMOSPHERIC_TEMPERATURE"]],
#  	result = filter.result)
#  

## ----valueFiltering3c, eval=FALSE----------------------------------------
#  # FIXME
#  # print(paste("Filtered:", dim(sosResult(obs.oneWeek.filter))[[1]],
#  #	"-vs.- Unfiltered:", dim(sosResult(obs.oneWeek))[[1]]))

## ----resultExporting1----------------------------------------------------
library("sp")
obs.oneWeek <- getObservation(sos = mySOSpox,
	offering = myOffering,
	procedure = sosProcedures(myOffering),
	eventTime = eventTime)

## ----resultExporting3, eval=FALSE----------------------------------------
#  # Create SpatialPointsDataFrame from result features
#  coords <- sosCoordinates(obs.oneWeek[[1]])
#  crs <- sosGetCRS(obs.oneWeek[[1]])
#  spdf <- SpatialPointsDataFrame(coords = coords[,1:2],
#  	data = data.frame(coords[,4]), proj4string = crs)
#  str(spdf)

## ----getObsCRS-----------------------------------------------------------
sosGetCRS(obs.oneWeek)

## ----geObsById-----------------------------------------------------------
obsId <- getObservationById(sos = mySOSpox, observationId = "http://www.52north.org/test/observation/1")
sosResult(obsId, coordinates = TRUE)

