% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/nLogLike.R
\name{nLogLike}
\alias{nLogLike}
\title{Negative log-likelihood function}
\usage{
nLogLike(wpar, nbStates, formula, bounds, parSize, data, dist, covs,
  estAngleMean, circularAngleMean, zeroInflation, oneInflation,
  stationary = FALSE, cons, fullDM, DMind, workcons, Bndind, knownStates,
  fixPar, wparIndex, nc, meanind)
}
\arguments{
\item{wpar}{Vector of working parameters.}

\item{nbStates}{Number of states of the HMM.}

\item{formula}{Regression formula for the transition probability covariates.}

\item{bounds}{Named list of 2-column matrices specifying bounds on the natural (i.e, real) scale of the probability 
distribution parameters for each data stream.}

\item{parSize}{Named list indicating the number of natural parameters of the data stream probability distributions}

\item{data}{An object \code{momentuHMMData}.}

\item{dist}{Named list indicating the probability distributions of the data streams.}

\item{covs}{data frame containing the model covariates (if any)}

\item{estAngleMean}{Named list indicating whether or not to estimate the angle mean for data streams with angular 
distributions ('vm' and 'wrpcauchy').}

\item{circularAngleMean}{Named list indicating whether to use circular-linear (FALSE) or circular-circular (TRUE) 
regression on the mean of circular distributions ('vm' and 'wrpcauchy') for turning angles.}

\item{zeroInflation}{Named list of logicals indicating whether the probability distributions of the data streams are zero-inflated.}

\item{oneInflation}{Named list of logicals indicating whether the probability distributions of the data streams are one-inflated.}

\item{stationary}{\code{FALSE} if there are covariates. If \code{TRUE}, the initial distribution is considered
equal to the stationary distribution. Default: \code{FALSE}.}

\item{cons}{Named list of vectors specifying a power to raise parameters corresponding to each column of the design matrix 
for each data stream.}

\item{fullDM}{Named list containing the full (i.e. not shorthand) design matrix for each data stream.}

\item{DMind}{Named list indicating whether \code{fullDM} includes individual- and/or temporal-covariates for each data stream
specifies (-1,1) bounds for the concentration parameters instead of the default [0,1) bounds.}

\item{workcons}{Named list of vectors specifying constants to add to the regression coefficients on the working scale for 
each data stream.}

\item{Bndind}{Named list indicating whether \code{DM} is NULL with default parameter bounds for each data stream.}

\item{knownStates}{Vector of values of the state process which are known prior to fitting the
model (if any).}

\item{fixPar}{Vector of working parameters which are assumed known prior to fitting the model (NA indicates parameters is to be estimated).}

\item{wparIndex}{Vector of indices for the elements of \code{fixPar} that are not NA.}

\item{nc}{indicator for zeros in fullDM}

\item{meanind}{index for circular-circular regression mean angles with at least one non-zero entry in fullDM}
}
\value{
The negative log-likelihood of the parameters given the data.
}
\description{
Negative log-likelihood function
}
\examples{
\dontrun{
# data is a momentuHMMData object (as returned by prepData), automatically loaded with the package
data <- example$m$data
m<-example$m
Par <- list(step=example$par0$Par$step,angle=example$par0$Par$angle)
nbStates <- length(m$stateNames)

inputs <- momentuHMM:::checkInputs(nbStates,m$conditions$dist,Par,m$conditions$estAngleMean,
          m$conditions$circularAngleMean,m$conditions$zeroInflation,m$conditions$oneInflation,
          m$conditions$DM,m$conditions$userBounds,m$conditions$cons,m$conditions$workcons,
          m$stateNames)

wpar <- momentuHMM:::n2w(Par,m$conditions$bounds,m$mle$beta,m$mle$delta,nbStates,
       m$conditions$estAngleMean,m$conditions$DM,m$conditions$cons,m$conditions$workcons,
       m$conditions$Bndind)

l <- momentuHMM:::nLogLike(wpar,nbStates,m$conditions$formula,m$conditions$bounds,
     inputs$p$parSize,data,m$conditions$dist,model.matrix(m$conditions$formula,data),
                   m$conditions$estAngleMean,m$conditions$circularAngleMean,
                   m$conditions$zeroInflation,m$conditions$oneInflation,m$conditions$stationary,
                   m$conditions$cons,m$conditions$fullDM,m$conditions$DMind,m$conditions$workcons,
                   m$conditions$Bndind,m$knownStates,unlist(m$conditions$fixPar),
                   m$conditions$wparIndex)
}

}
