
#MOst of the functions we will be working with are from the "bnlearn' package.
#"visNetwork' and "networkD3' help us visualize the model.
library(tidyverse)
library(bnlearn)
library(networkD3)
library(visNetwork)

#load some example data
dat <- read_csv("FLOATdataset.csv")

#log-transform and scale all the variable so they work better
dat = mutate(dat, logzoops = log(FallZoops), logCHL = log(FallChla2), 
             logPred = log(Predators), logFMWT = log(FMWT)) %>%
  select(-FallZoops, -FallChla2, -Predators, -FMWT) 

datscaled = mutate(dat,
                   across(SprNDOI:logFMWT, ~scale(.x)))

### Learn the structure of the network. 
#The 'gs' function from the 'bnlearn' package uses machine learning
#to determin the equivalence class of a directed acyclic graph from the data.
#'cextend' then converts this into a network diagram.

dag <- cextend(gs(datscaled))

### Plot the force directed network
networkData <- data.frame(arcs(dag))

simpleNetwork(
  networkData,
  Source = "from",
  Target = "to"
)

### Print the network score

score(dag, datscaled)


### Fit the model parameters and show the CPT for node A
fit = bn.fit(dag, datscaled, debug = TRUE)
fit$logCHL
fit$logzoops
fit$logFMWT


##############################################
#However, usually you don't want to trust the computer to make the network for you.
#it might come up with some interesting relationships you hadn't thought about,
#but more likely it just wont make any sense. 


#This is a function I copied and pasted from the internet
#to help plotting the networks. 
plot.network <- function(structure, ht = "400px"){
  nodes.uniq <- unique(c(structure$arcs[,1], structure$arcs[,2]))
  nodes <- data.frame(id = nodes.uniq,
                      label = nodes.uniq,
                      color = "darkturquoise",
                      shadow = TRUE)
  edges <- data.frame(from = structure$arcs[,1],
                      to = structure$arcs[,2],
                      arrows = "to",
                      smooth = TRUE,
                      shadow = TRUE,
                      color = "black")
  return(visNetwork(nodes, edges, height = ht, width = "100%"))
}

# Create an empty graph that includes all the nodes we might want to use.
structure <- empty.graph(c("logzoops","logCHL", "logPred", "SummerTemp" ,
                           "FallNDOI","FallTemp","logFMWT",
                           "Secchi"))

# Set relationships manually.
#The format of the model strings is as follows. The local structure of each node 
#is enclosed in square brackets ("[]"); the first string is the label of that node. 
#The parents of the node (if any) are listed after a ("|") and separated by 
#colons (":"). All nodes (including isolated and root nodes) must be listed.
?modelstring
modelstring(structure) <- "[logFMWT|logzoops:Secchi:FallTemp:logPred][logzoops|logCHL:FallNDOI:FallTemp][logCHL|FallNDOI:SummerTemp][SummerTemp][FallNDOI][FallTemp][Secchi|FallNDOI][logPred]"

# subset and fit
dattest = select(datscaled, logzoops,logCHL, logPred, SummerTemp,
                         FallNDOI,FallTemp,logFMWT,
                         Secchi)
bn.mod <- bn.fit(structure, data =dattest)
bn.mod

plot.network(structure)

#We can assess the probability of any node given the other nodes. 

#what is the probability of a FMWT index greater than 20 when secchi is less than 5 and temp is less than 20?
cat("P(logFMWT >6 | FallTemp <20 and Secchi <5) =", cpquery(bn.mod, (logFMWT > .5), (FallTemp < 20 & Secchi < 5 )), "\n")

#or zooplankton...
cpquery(bn.mod, (logzoops > .55), (FallTemp < 20 & Secchi < 5 ))

#https://www.bnlearn.com/examples/xval/

#Loss is predictions are computed from an arbitrary set of nodes using 
#likelihood weighting to obtain Bayesian posterior estimates.

#So how good are our predictinos of FMWT?
eval = bn.cv(data = dattest, bn = structure, loss = "cor-lw", loss.args = list(target = "logFMWT"))
loss(eval)

