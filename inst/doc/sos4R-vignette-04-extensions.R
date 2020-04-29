## ----library_testsos----------------------------------------------------------
library("sos4R")
mySOS <- SOS(url = "http://sensorweb.demo.52north.org/52n-sos-webapp/service/pox",
             binding = "POX", dcpFilter = list("POX" = "/pox"))

## ----function_inclusion_1-----------------------------------------------------
parsers <- SosParsingFunctions(
	"ExceptionReport" = function() {
		return("Got Exception!")
	},
	include = c("GetObservation", "ExceptionReport"))
print(names(parsers))


## ----function_inclusion_2-----------------------------------------------------
parsers <- SosParsingFunctions(
		"ExceptionReport" = function() {
			return("Got Exception!")
		},
		include = c("GetCapabilities"))
print(names(parsers))

## -----------------------------------------------------------------------------
parsers <- SosParsingFunctions(
		exclude = names(SosParsingFunctions())[5:29])
print(names(parsers))

## ----encoders_access, eval=FALSE----------------------------------------------
#  sosEncoders(mySOS)

## ----encoders_names-----------------------------------------------------------
names(sosEncoders(mySOS))

## ----encoders_own, eval=FALSE-------------------------------------------------
#  myPostEncoding <- function(object, sos, verbose) {
#  	return(utils::str(object))
#  }
#  # Connection will not be established because of mising objects
#  mySOS2 = SOS(sosUrl(mySOS),
#  	encoders = SosEncodingFunctions("POST" = myPostEncoding))

## ----encoders_show------------------------------------------------------------
showMethods("encodeXML")
showMethods("encodeKVP")

## ----encoders_override, echo=TRUE, eval=FALSE---------------------------------
#  setMethod(f = "encodeXML",
#    signature = signature(obj = "POSIXt", sos = "SOS"),
#      def = function(obj, sos, verbose) {
#        if(verbose) cat("Using my own time encoding... ")
#  
#        # time zone hack to fix that the time format option
#        # %z does not work on windows machines:
#        .time <- obj + 11 * 60 * 60 # add 11 hours
#        formatted <- strftime(x = .time,
#          format = sosTimeFormat(sos))
#        formatted <- paste(formatted,
#          "+11:00", sep = "")	# append 11:00
#  
#        if(verbose) cat("Formatted ", toString(obj),
#          " to ", formatted, "\n")
#        return(formatted)
#      }
#  )

## ---- echo=TRUE, eval=FALSE---------------------------------------------------
#  sosParsers(mySOS)

## -----------------------------------------------------------------------------
names(sosParsers(mySOS))

## ----parsers_load_or_download-------------------------------------------------
# Create own parsing function:
myER <- function(xml, sos, verbose) {
	return("EXCEPTION!!!11")
}
myParsers <- SosParsingFunctions("ows:ExceptionReport" = myER)
exceptionParserSOS <- SOS(url = "http://sensorweb.demo.52north.org/52n-sos-webapp/service/pox",
                          parsers = myParsers,
                          binding = "POX", useDCPs = FALSE)
# Triggers exception:
erroneousResponse <- getObservation(exceptionParserSOS,
                                    #verbose = TRUE,
                                    offering = sosOfferings(exceptionParserSOS)[[1]],
                                    observedProperty = list("Bazinga!"))
print(erroneousResponse)

## ----parsers_disabled, eval=FALSE---------------------------------------------
#  SosDisabledParsers()

## ----parsers_disabled_names---------------------------------------------------
names(SosDisabledParsers())

## ----reponse_passthrough------------------------------------------------------
disabledParserSOS <- SOS(sosUrl(mySOS),
                         parsers = SosDisabledParsers(),
                         binding = sosBinding(mySOS),
                         dcpFilter = mySOS@dcpFilter)
unparsed <- getObservation(disabledParserSOS,
                           offering = sosOfferings(disabledParserSOS)[[1]],
                           observedProperty = list("Bazinga!"))
class(unparsed)
# (Using XML functions here for accesing the root of a
# document and the name of an element.)
unparsed

## ----converters0--------------------------------------------------------------
value <- 2.0
value.string <- sosConvertString(x = value, sos = mySOS)
print(class(value.string))

value <- "2.0"
value.double <- sosConvertDouble(x = value, sos = mySOS)
print(class(value.double))

value <- "1"
value.logical <- sosConvertLogical(x = value, sos = mySOS)
print(class(value.logical))

value <- "2010-01-01T12:00:00.000"
value.time <- sosConvertTime(x = value, sos = mySOS)
print(class(value.time))

## ----converters1--------------------------------------------------------------
names(SosDataFieldConvertingFunctions())

## ----converters2, eval=FALSE--------------------------------------------------
#  sosDataFieldConverters(mySOS)

## ----converters3a-------------------------------------------------------------
testsos <- SOS("http://sensorweb.demo.52north.org/52n-sos-webapp/sos/pox", binding = "POX", dcpFilter = list("POX" = "/pox"))
testsosoffering <- sosOfferings(testsos)[["http___www.52north.org_test_offering_1"]]
testsosobsprop <- sosObservedProperties(testsosoffering)[1]
getObservation(sos = testsos, offering = testsosoffering, observedProperty = testsosobsprop)

## ----converters3c-------------------------------------------------------------
getObservation(sos = testsos, offering = testsosoffering, observedProperty = testsosobsprop,
               inspect = TRUE)

## ----converters3d-------------------------------------------------------------
testconverters <- SosDataFieldConvertingFunctions(
  # one of the following would suffice
  "test_unit_1" = sosConvertDouble,
	"http://www.52north.org/test/observableProperty/1" = sosConvertDouble
  )

testsos <- SOS("http://sensorweb.demo.52north.org/52n-sos-webapp/sos/pox", binding = "POX", dcpFilter = list("POX" = "/pox"),
               dataFieldConverters = testconverters)
testsosoffering <- sosOfferings(testsos)[["http___www.52north.org_test_offering_1"]]
data <- getObservation(sos = testsos, offering = testsosoffering, observedProperty = testsosobsprop)

## ----converters3e-------------------------------------------------------------
head(sosResult(data))

## ----converters3f-------------------------------------------------------------
attributes(sosResult(data)[[1]])

## ----converters4--------------------------------------------------------------
myConverters <- SosDataFieldConvertingFunctions(
	"S/m" = sosConvertDouble,
	"http://mmisw.org/ont/cf/parameter/sea_water_salinity"
			= sosConvertDouble)

## ----exceptionData------------------------------------------------------------
library("knitr")
knitr::kable(OwsExceptionsData())

## ----exceptionWarning1--------------------------------------------------------
response <- try(getObservationById(sos = mySOS,
                                   observationId = ""))

## ----exceptionWarning2d-------------------------------------------------------
response

