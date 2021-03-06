% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/prepData.R
\name{prepData}
\alias{prepData}
\title{Preprocessing of the data streams and covariates}
\usage{
prepData(data, type = c("UTM", "LL"), coordNames = c("x", "y"),
  covNames = NULL, spatialCovs = NULL, centers = NULL, angleCovs = NULL)
}
\arguments{
\item{data}{Either a data frame of data streams or a \code{\link{crwData}} object (as returned by \code{\link{crawlWrap}}). If \code{data} is a data frame, it can optionally include a field \code{ID}
(identifiers for the observed individuals), coordinates from which step length ('step') 
and turning angle ('angle') are calculated, and any covariates (with names matching \code{covNames} and/or \code{angleCovs}). 
If step length and turning angle are to be calculated from coordinates, the \code{coordNames} argument 
must identify the names for the x- (longitunal) and y- (latitudinal) coordinates.
With the exception of \code{ID} and \code{coordNames}, all variables in \code{data} are treated as data streams unless identified
as covariates in \code{covNames} and/or \code{angleCovs}.}

\item{type}{\code{'UTM'} if easting/northing provided (the default), \code{'LL'} if longitude/latitude. If \code{type='LL'} then step lengths are calculated in kilometers and turning angles are based on initial bearings (see \code{\link{turnAngle}}).
Ignored if \code{data} is a \code{\link{crwData}} object.}

\item{coordNames}{Names of the columns of coordinates in the \code{data} data frame. Default: \code{c("x","y")}. If \code{coordNames=NULL} then step lengths, turning angles, 
and location covariates (i.e., those specified by \code{spatialCovs}, \code{centers}, and \code{angleCovs}) are not calculated. Ignored if \code{data} is a \code{\link{crwData}} object.}

\item{covNames}{Character vector indicating the names of any covariates in \code{data} dataframe. Any variables in \code{data} (other than \code{ID}) that are not identified in 
\code{covNames} and/or \code{angleCovs} are assumed to be data streams (i.e., missing values will not be accounted for).}

\item{spatialCovs}{List of \code{\link[raster]{Raster-class}} objects for spatio-temporally referenced covariates. Covariates specified by \code{spatialCovs} are extracted from the raster 
layer(s) based on the location data (and the z values for a raster \code{\link[raster]{stack}} 
or \code{\link[raster]{brick}}) for each time step.  If an element of \code{spatialCovs} is a raster \code{\link[raster]{stack}} or \code{\link[raster]{brick}}, 
then z values must be set using \code{\link[raster]{setZ}} and \code{data} must include column(s) of the corresponding z value(s) for each observation (e.g., 'time').}

\item{centers}{2-column matrix providing the x-coordinates (column 1) and y-coordinates (column 2) for any activity centers (e.g., potential 
centers of attraction or repulsion) from which distance and angle covariates will be calculated based on the location data. If no row names are provided, then generic names are generated 
for the distance and angle covariates (e.g., 'center1.dist', 'center1.angle', 'center2.dist', 'center2.angle'); otherwise the covariate names are derived from the row names
of \code{centers} as \code{paste0(rep(rownames(centers),each=2),c(".dist",".angle"))}. As with covariates identified in \code{angleCovs}, note that the angle covariates for each activity center are calculated relative to 
the previous movement direction (instead of standard direction relative to the x-axis); this is to allow mean turning angle to be modelled as a function of these covariates using circular-circular regression in \code{\link{fitHMM}}
or \code{\link{MIfitHMM}}.}

\item{angleCovs}{Character vector indicating the names of any circular-circular regression angular covariates in \code{data} or \code{spatialCovs} that need conversion from standard direction (in radians relative to the x-axis) to turning angle (relative to previous movement direction) 
using \code{\link{circAngles}}.}
}
\value{
An object \code{\link{momentuHMMData}}, i.e., a dataframe of:
\item{ID}{The ID(s) of the observed animal(s)}
\item{...}{Data streams (e.g., 'step', 'angle', etc.)}
\item{x}{Either easting or longitude (if \code{coordNames} is specified or \code{data} is a \code{crwData} object)}
\item{y}{Either norting or latitude (if \code{coordNames} is specified or \code{data} is a \code{crwData} object)}
\item{...}{Covariates (if any)}

If \code{data} is a \code{\link{crwData}} object, the \code{\link{momentuHMMData}} object created by \code{prepData} includes step lengths and turning angles calculated from the best predicted 
locations (\code{crwData$crwPredict$mu.x} and \code{crwData$crwPredict$mu.y}). Prior to using \code{prepData}, additional data streams or covariates unrelated to location (including z-values associated with
\code{spatialCovs} raster stacks or bricks) can be merged with the \code{crwData} object using \code{\link{crawlMerge}}.
}
\description{
Preprocessing of the data streams, including calculation of step length, turning angle, and covariates from location data to be suitable for
analysis using \code{\link{fitHMM}}
}
\examples{
coord1 <- c(1,2,3,4,5,6,7,8,9,10)
coord2 <- c(1,1,1,2,2,2,1,1,1,2)
cov1 <- rnorm(10)

data <- data.frame(coord1=coord1,coord2=coord2,cov1=cov1)
d <- prepData(data,coordNames=c("coord1","coord2"),covNames="cov1")

# include additional data stream named 'omega'
omega <- rbeta(10,1,1)
data <- data.frame(coord1=coord1,coord2=coord2,omega=omega,cov1=cov1)
d <- prepData(data,coordNames=c("coord1","coord2"),covNames="cov1")

# include 'forest' example raster layer as covariate
data <- data.frame(coord1=coord1*1000,coord2=coord2*1000)
spatialCov <- list(forest=forest)
d <- prepData(data,coordNames=c("coord1","coord2"),spatialCovs=spatialCov)

# include 2 activity centers
data <- data.frame(coord1=coord1,coord2=coord2,cov1=cov1)
d <- prepData(data,coordNames=c("coord1","coord2"),covNames="cov1",
              centers=matrix(c(0,10,0,10),2,2,dimnames=list(c("c1","c2"),NULL)))
              
# Include angle covariate that needs conversion to 
# turning angle relative to previous movement direction
u <- rnorm(10) # horizontal component
v <- rnorm(10) # vertical component
cov2 <- atan2(v,u)
data <- data.frame(coord1=coord1,coord2=coord2,cov1=cov1,cov2=cov2)
d <- prepData(data,coordNames=c("coord1","coord2"),covNames="cov1",
              angleCovs="cov2")

}
\seealso{
\code{\link{crawlMerge}}, \code{\link{crawlWrap}}, \code{\link{crwData}}
}
