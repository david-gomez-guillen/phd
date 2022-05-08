# Cost-Effectiveness Analysis package

This R package allows to specify, run and visualize results on different types of cost-effectiveness models. It features:

* Separation from model specification and parameter instantiation via contexts (see below).
* Model visualization methods for easier debugging/understanding.
* TODO

## Contexts

Contexts are named lists determining values for the named parameters defined in the model specification. Using them allows to separate the model structure from the actual values used in the model evaluation.

For example if we have a decision tree with a given list of used parameters, we can run the models using different parameter values with:

```r
library(CEAModel)

tree <- loadDecisionTree('sample_tree.yaml')

ctx <- list(
	p_test_positive=.1,
	p_cancer_test_p=.95,
	p_no_cancer_test_p=.01,
	c_treatment=1000,
	c_late_treatment=2000,
	ly_cancer=10,
	ly_no_cancer=40,
	ly_late_cancer=2
)
ce.results1 <- tree$getCostEffectiveness(context=ctx)

ctx$p_test_positive <- .2
ce.results2 <- tree$getCostEffectiveness(context=ctx)
```

Context parameters can have multiple values to be used in multiple executions, for instance in a sensitivity analysis.

```r
ctx <- list(
	p_test_positive=c(.1, .2),
	p_cancer_test_p=c(.95, .95),
	p_no_cancer_test_p=c(.01, .02),
	c_treatment=c(1000, 1500),
	c_late_treatment=c(2000, 2000),
	ly_cancer=c(10, 15),
	ly_no_cancer=c(40, 45),
	ly_late_cancer=c(2, 3)
)
```

For easier context handling, two functions are implemented to save and load contexts from xlsx files.

```r
ctx <- loadContextFile('context.xlsx')
ctx$c_treatment <- 3000
saveContextFile(ctx, 'context_modified.xlsx')
```

### Stratified contexts

To allow data stratification (e.g. by age, screening year, ...), some methods allow stratified contexts. Stratified contexts are implemented simply as a two-level named list: the first level is the stratum name and the second one the parameter. Each stratum should have the same parameters, even if their values don't change among strata.

```r
strat.ctx <- list(
	_40=list(
		p_test_positive=.1,
		p_cancer_test_p=.95,
		p_no_cancer_test_p=.01,
		c_treatment=1000,
		c_late_treatment=2000,
		ly_cancer=10,
		ly_no_cancer=40,
		ly_late_cancer=3
	),
	40_50=list(
		p_test_positive=.2,
		p_cancer_test_p=.95,
		p_no_cancer_test_p=.01,
		c_treatment=1000,
		c_late_treatment=2000,
		ly_cancer=5,
		ly_no_cancer=30,
		ly_late_cancer=2
	),
	50_=list(
		p_test_positive=.3,
		p_cancer_test_p=.95,
		p_no_cancer_test_p=.01,
		c_treatment=1000,
		c_late_treatment=2000,
		ly_cancer=2,
		ly_no_cancer=20,
		ly_late_cancer=1
	)
)
		
```

Similarly to regular contexts, two functions are implemented to save and load contexts from xlsx files, each stratum in a different (named) sheet.

```r
ctx <- loadContextFile('context.xlsx')
ctx$c_treatment <- 3000
saveContextFile(ctx, 'context_modified.xlsx')
```

Also, a pregenerated context file can be created by using the function `generateContextFile` with the models the will be using that file. The function scans all the used parameters and generates a list of parameters initialized to zero. Strata can be defined as well.

```r
tree <- loadDecisionTree('sample_tree.yaml')
markov <- loadMarkovModels('markov_test.xlsx')
generateContextFile(
		tree, markov,
		'generated_context.xlsx',
		strata=c('_40', '40_50', '50_'))
```

## Common methods

All CEA models share some common methods:

* `getUsedParameters`: Returns all the parameter names used in the model.
* `getNodes`: Returns a list of all the nodes of the model.

## Decision trees

Decision trees are created using the `loadDecisionTree` function and a [YAML](https://en.wikipedia.org/wiki/YAML) file with the tree specification.

```r
library(CEAModel)

tree <- loadDecisionTree('sample_tree.yaml')
```

### Decision tree YAML specification
Decision tree specifications are implemented as a YAML nested list, where each list item represents a node with a short name (not necessarily unique). Each node can have the following fields:

* `description`: Node long/pretty name to be displayed.
* `in_transition`: In non-root nodes, label that will be displayed on the transition to the node.
* `probs`: Comma separated values, either literal (e.g. .5) or parameterized (e.g. p\_cancer), that determine the probability of each children (see `children` field below). The special value `_` corresponds to the complementary (i.e. 1 minus the sum of the rest of probabilities).
* `children`: List of children nodes. `probs` and `children` must appear together (or not at all if the node is a leaf). The number of children must be equal to the number of values in `probs`.
* `include`: Path to the YAML file that defines another tree that will be included as a subtree in this node.
* `suffix`: When including a subtree, the suffix that will be appended to the probability parameter names. This way we can differentiate probabilities from the same tree included more than once in the same parent tree. For example, a parameter `p_cancer` included in a subtree with suffix `test_positive` will appear as `p_cancer__test_positive`. If the same parameter appears in a subtree with suffix `hpv_positive` included within the previous subtree it will appear as `p_cancer__test_positive_hpv_positive`.

Besides these, other custom fields can be added and retrieved within the node's `info` field. Two special custom fields are `cost` and `outcome`, used in cost-effectiveness analysis.

```r
tree <- loadDecisionTree('sample_tree.yaml')

root.node <- tree$root
root.node.cost <- root.node$info$cost
```

Decision tree YAML example:

```yaml
test:
  description: Medical test
  probs: p_test_positive, _
  children:
    - outcome_positive:
        in_transition: positive
        description: Cancer
        probs: p_cancer_test_p, _
        children:
          - detected_cancer:
              in_transition: cancer
              description: Detected cancer
              cost: c_treatment
              outcome: ly_cancer
          - false_positive:
              in_transition: no cancer
              description: False positive
              cost: c_treatment
              outcome: ly_no_cancer
    - outcome_negative:
        in_transition: negative
        description: No cancer
        probs: p_no_cancer_test_p, _
        children:
          - undetected_cancer:
              in_transition: cancer
              description: Undetected cancer
              cost: c_late_treatment
              outcome: ly_late_cancer
          - no_intervention:
              in_transition: no cancer
              description: No intervention
              cost: 0
              outcome: ly_no_cancer

```

## Markov models

TODO

## Microsimulation models

TODO

















































