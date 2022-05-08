source('load_models.R')
source('markov.R')

cat('Running markov model...\n')
markov.outputs <- list()
# Lynch simulation

# initial.state <- sapply(markov$nodes,
#                         function(n) if (n$name=='lynch') 1 else 0)
# markov.result.lynch <- simulate('lynch',
#                                 strategies.lynch,
#                                 markov,
#                                 strat.ctx,
#                                 initial.state,
#                                 start.age=LYNCH.START.AGE,
#                                 max.age=LYNCH.MAX.AGE,
#                                 discount.rate = .03)
# print(markov.result.lynch$plot)

# PMB simulation

initial.state <- sapply(markov$nodes,
                        function(n) if (n$name=='postmenopausal_bleeding') 1 else 0)
markov.result.bleeding <- simulate('bleeding',
                                   strategies.bleeding,
                                   markov,
                                   strat.ctx,
                                   initial.state,
                                   start.age=BLEEDING.START.AGE,
                                   max.age=BLEEDING.MAX.AGE,
                                   discount.rate = .03)
print(markov.result.bleeding$plot
+ coord_cartesian(xlim=c(10000,15000), ylim=c(15.75,18.05)))

# Asymptomatic simulation

# initial.state <- sapply(markov$nodes, 
#                         function(n) if (n$name=='postmenopausal_asymptomatic') 1 else 0)
# markov.result.asymptomatic <- simulate('asymptomatic',
#                                        strategies.asymptomatic,
#                                        markov,
#                                        strat.ctx,
#                                        initial.state,
#                                        start.age=ASYMPTOMATIC.START.AGE,
#                                        max.age=ASYMPTOMATIC.MAX.AGE)
# print(markov.result.asymptomatic$plot)

cat('Done.\n')
