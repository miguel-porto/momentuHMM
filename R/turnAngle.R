
#' Turning angle
#'
#' Used in \code{\link{prepData}} and \code{\link{simData}}.
#'
#' @param x First point
#' @param y Second point
#' @param z Third point
#' @param type \code{'UTM'} if easting/northing provided (the default), \code{'LL'} if longitude/latitude.
#'
#' @return The angle between vectors (x,y) and (y,z).  
#' 
#' If \code{type='LL'} then turning angle is calculated based on initial bearings using \code{\link[geosphere]{bearing}}.
#'
#' @examples
#' \dontrun{
#' x <- c(0,0)
#' y <- c(4,6)
#' z <- c(10,7)
#' momentuHMM:::turnAngle(x,y,z)
#' }
#' @importFrom geosphere bearing

turnAngle <- function(x,y,z,type='UTM')
{
  # NA angle if zero step length
  if(all(x==y) | all(y==z))
    return(NA)

  if(type=='UTM'){
    v <- c(y[1]-x[1],y[2]-x[2])
    w <- c(z[1]-y[1],z[2]-y[2])
    angle <- atan2(w[2],w[1])-atan2(v[2],v[1])
  } else {
    angle <- (geosphere::bearing(x,y)-geosphere::bearing(y,z))*pi/180
  }
  while(angle<=(-pi)) angle <- angle + 2*pi
  while(angle>pi) angle <- angle -2*pi
  return(angle)
}
