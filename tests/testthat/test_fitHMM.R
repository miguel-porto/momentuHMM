
context("fitHMM")

test_that("Exceptions are thrown",{
  data <- example$data
  simPar <- example$simPar
  par0 <- example$par0

  expect_error(fitHMM(data=data,nbStates=simPar$nbStates,Par=par0$Par,
                     beta0=par0$beta0,delta0=par0$delta0,formula=par0$formula,dist=simPar$dist,estAngleMean=example$m$conditions$estAngleMean), NA)

  # if nbStates<1
  expect_error(fitHMM(data=data,nbStates=0,Par=par0$Par,
                     beta0=par0$beta0,delta0=par0$delta0,formula=par0$formula,dist=simPar$dist,estAngleMean=example$m$conditions$estAngleMean))

  # if data empty
  expect_error(fitHMM(data=data.frame(),nbStates=simPar$nbStates,Par=par0$Par,
                     beta0=par0$beta0,delta0=par0$delta0,formula=par0$formula,dist=simPar$dist,estAngleMean=example$m$conditions$estAngleMean))

  # if Par empty
  expect_error(fitHMM(data=data,nbStates=simPar$nbStates,Par=list(),
                     beta0=par0$beta0,delta0=par0$delta0,formula=par0$formula,dist=simPar$dist,estAngleMean=example$m$conditions$estAngleMean))

  # if stepDist not in list
  expect_error(fitHMM(data=data,nbStates=simPar$nbStates,Par=par0$Par,
                     beta0=par0$beta0,delta0=par0$delta0,formula=par0$formula,
                     dist=list(step="unif",angle=simPar$dist$angle),estAngleMean=example$m$conditions$estAngleMean))

  # if angleDist not in list
  expect_error(fitHMM(data=data,nbStates=simPar$nbStates,Par=par0$Par,
                     beta0=par0$beta0,delta0=par0$delta0,formula=par0$formula,
                     dist=list(step=simPar$dist$step,angle="norm"),estAngleMean=example$m$conditions$estAngleMean))

  # if stepPar not within bounds
  expect_error(fitHMM(data=data,nbStates=simPar$nbStates,Par=list(step=-par0$Par$step,angle=par0$Par$angle),
                     beta0=par0$beta0,delta0=par0$delta0,formula=par0$formula,dist=simPar$dist,estAngleMean=example$m$conditions$estAngleMean))

  # if wrong number of initial parameters
  expect_error(fitHMM(data=data,nbStates=simPar$nbStates,Par=list(step=par0$stepPar0[-1],angle=par0$anglePar0),
                     beta0=par0$beta0,delta0=par0$delta0,formula=par0$formula,dist=simPar$dist,estAngleMean=example$m$conditions$estAngleMean))

  # if stepPar are missing
  expect_error(fitHMM(data=data,nbStates=simPar$nbStates,Par=par0$Par[-1],
                     beta0=par0$beta0,delta0=par0$delta0,formula=par0$formula,dist=simPar$dist,estAngleMean=example$m$conditions$estAngleMean))

  # if beta0 has the wrong dimensions
  expect_error(fitHMM(data=data,nbStates=simPar$nbStates,Par=par0$Par,
                     beta0=par0$beta0[1,],delta0=par0$delta0,formula=par0$formula,dist=simPar$dist,estAngleMean=example$m$conditions$estAngleMean))

  # if delta0 has the wrong length
  expect_error(fitHMM(data=data,nbStates=simPar$nbStates,Par=par0$Par,
                     beta0=par0$beta0,delta0=par0$delta0[-1],formula=par0$formula,dist=simPar$dist,estAngleMean=example$m$conditions$estAngleMean))
  
  # invalid userBounds
  expect_error(fitHMM(data=data,nbStates=simPar$nbStates,Par=par0$Par,
                     beta0=par0$beta0,delta0=par0$delta0,formula=par0$formula,dist=simPar$dist,estAngleMean=example$m$conditions$estAngleMean,
                     userBounds=list(step=matrix(c(-Inf,-Inf,0,0,Inf,Inf,Inf,Inf),simPar$nbStates*2,2))))
  
  # invalid DM
  expect_error(fitHMM(data=data,nbStates=simPar$nbStates,Par=list(step=log(par0$Par$step),angle=par0$Par$angle),
                     beta0=par0$beta0,delta0=par0$delta0,formula=par0$formula,dist=simPar$dist,estAngleMean=example$m$conditions$estAngleMean,
                     DM=list(step=diag(3))))
  
  # invalid cons
  expect_error(fitHMM(data=data,nbStates=simPar$nbStates,Par=list(step=log(par0$Par$step),angle=par0$Par$angle),
                     beta0=par0$beta0,delta0=par0$delta0,formula=par0$formula,dist=simPar$dist,estAngleMean=example$m$conditions$estAngleMean,
                     DM=list(step=diag(4)),cons=list(step=c(1,1,1))))
  
  # invalid workcons
  expect_error(fitHMM(data=data,nbStates=simPar$nbStates,Par=list(step=log(par0$Par$step),angle=par0$Par$angle),
                     beta0=par0$beta0,delta0=par0$delta0,formula=par0$formula,dist=simPar$dist,estAngleMean=example$m$conditions$estAngleMean,
                     DM=list(step=diag(4)),workcons=list(step=c(0,0,0))))

})

test_that("The output has the right class",{
  data <- example$data
  simPar <- example$simPar
  par0 <- example$par0

  m <- fitHMM(data=data,nbStates=simPar$nbStates,Par=par0$Par,
                beta0=par0$beta0,delta0=par0$delta0,formula=par0$formula,dist=simPar$dist,estAngleMean=example$m$conditions$estAngleMean)

  expect_equal(length(which(class(m)=="momentuHMM")),1)
})

test_that("Step length only + zero-inflation works",{
  set.seed(1)
  nbAnimals <- 2
  nbStates <- 2
  nbCovs <- 2
  mu <- c(10,60)
  sigma <- c(10,40)
  zeromass <- c(0.4,0.001)
  stepPar <- c(mu,sigma,zeromass)
  anglePar <- NULL
  stepDist <- "gamma"
  angleDist <- "none"
  zeroInflation <- TRUE
  nbAnim <- c(50,100)

  data <- simData(nbAnimals=nbAnimals,nbStates=nbStates,dist=list(step=stepDist),
                  Par=list(step=stepPar),nbCovs=nbCovs,zeroInflation=list(step=zeroInflation),
                  obsPerAnimal=nbAnim)

  mu0 <- c(20,50)
  sigma0 <- c(15,30)
  zeromass0 <- c(0.2,0.05)
  stepPar0 <- c(mu0,sigma0,zeromass0)
  anglePar0 <- NULL
  angleMean <- NULL
  formula <- ~cov1+cov2

  expect_error(fitHMM(data=data,nbStates=nbStates,Par=list(step=c(log(stepPar0[1:(2*nbStates)]),boot::logit(zeromass0))),DM=list(step=diag(3*nbStates)),dist=list(step=stepDist),formula=formula,
              verbose=0), NA)
})

test_that("equivalent momentuHMM and moveHMM models match",{

  simPar <- example$simPar
  par0 <- example$par0
  nbStates<-simPar$nbStates
  
  data<-simData(nbAnimals=2,model=example$m)
  momentuHMM_fit<-fitHMM(data=data,nbStates=nbStates,Par=list(step=log(par0$Par$step),angle=par0$Par$angle),
                         beta0=par0$beta0[1,,drop=FALSE],delta0=par0$delta0,DM=list(step=diag(4)),dist=simPar$dist,estAngleMean=example$m$conditions$estAngleMean)
  moveHMM_fit<-moveHMM::fitHMM(moveData(data),nbStates=nbStates,stepPar=par0$Par$step,anglePar=par0$Par$angle,stepDist=simPar$dist$step,angleDist=simPar$dist$angle,beta0=par0$beta0[1,,drop=FALSE],delta0=par0$delta0)
  expect_equal(momentuHMM_fit$mod$estimate,moveHMM_fit$mod$estimate)
  expect_equal(momentuHMM_fit$mod$minimum,moveHMM_fit$mod$minimum)
})