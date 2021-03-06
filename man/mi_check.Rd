% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/mi.R
\name{mi_check}
\alias{mi_check}
\title{Posterior predictive checking for topics}
\usage{
mi_check(m, k, groups = NULL, n_reps = 20)
}
\arguments{
\item{m}{\code{mallet_model} object \emph{with sampling state loaded} via
\code{\link{load_sampling_state}}}

\item{k}{topic number (calculations are only done for one topic at a time)}

\item{groups}{optional grouping factor for documents. If supplied, the IMI
values will be for words over groups rather than over individual documents}

\item{n_reps}{number of simulations}
}
\value{
a single-row data frame with \code{topic}, \code{mi}, and
  \code{deviance} columns. The latter is the MI standardized by the mean and
  standard deviation of the simulated values. The vector of simulated values
  is available as the \code{"simulated"} attribute of the returned data
  frame.
}
\description{
This function provides a way to check the fit of the topic model by comparing
the obtained mutual information for topics to values derived from simulations
from the posterior. Large deviations from simulated values may indicate a
poorer fit.
}
\details{
For a given topic \eqn{k}, a simulation draws a new term-document matrix from
the posterior for \eqn{d}. Since a topic is simply a multinomial distribution
over the words, for a given document \eqn{d} we simply draw the same number
of samples from this multinomial as there were words allocated to topic
\eqn{k} in \eqn{d} in the model we are checking. Under the assumptions of the
model, this is how the distribution \eqn{p(w, d|k)} arises. With this
simulated topic-specific term-document matrix in hand, we recalculate the MI.
The process is replicated to obtain a reference distribution to compare the
values from \code{\link{mi_topic}} to.
}
\references{
Mimno, D., and Blei, D. 2011. Bayesian Checking for Topic Models.
  \emph{Empirical Methods in Natural Language Processing}.
  \url{http://www.cs.columbia.edu/~blei/papers/MimnoBlei2011.pdf}.
}
\seealso{
\code{\link{imi_check}}, \code{\link{mi_topic}}
}
