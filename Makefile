SHELL := /bin/bash

# Making sure no parallelization is performed
.NOTPARALLEL:

# Compiler choice.
# Default: gcc
ifndef $CC
CC:=gcc
endif

# Directory choice.
# Default: original
ifndef $DIR
DIR:=original
endif

# By default, we test only original
# Vs fission_manual
all: original fission_manual

# Optimization levels
OPT_LEVELS = O0 O1 O2 O3

# Sizes.
# Cf. https://web.cse.ohio-state.edu/~pouchet.2/software/polybench/
SIZES = MINI SMALL MEDIUM LARGE EXTRALARGE

# Rules for folders

.PHONY: original
original:
	 $(foreach size, $(SIZES), $(foreach opt, $(OPT_LEVELS), ./run.sh -c $(CC) -d original -s $(size) -o $(opt); ))

.PHONY: original_autopar
original_autopar:
	 $(foreach size, $(SIZES), $(foreach opt, $(OPT_LEVELS), ./run.sh -c $(CC) -d original_autopar -s $(size) -o $(opt); ))

.PHONY: fission_manual
fission_manual:
	 $(foreach size, $(SIZES), $(foreach opt, $(OPT_LEVELS), ./run.sh -c $(CC) -d fission_manual -s $(size) -o $(opt); ))


.PHONY: fission_autopar
fission_autopar:
	 $(foreach size, $(SIZES), $(foreach opt, $(OPT_LEVELS), ./run.sh -c $(CC) -d fission_autopar -s $(size) -o $(opt); ))

# Benchmark specific programs
# Specify DIR argument otherwise it defaults to original

3mm:
	 $(foreach size, $(SIZES), $(foreach opt, $(OPT_LEVELS), ./run.sh -c $(CC) -d $(DIR) -p 3mm -s $(size) -o $(opt); ))

bicg:
	 $(foreach size, $(SIZES), $(foreach opt, $(OPT_LEVELS), ./run.sh -c $(CC) -d $(DIR) -p bicg -s $(size) -o $(opt); ))

deriche:
	 $(foreach size, $(SIZES), $(foreach opt, $(OPT_LEVELS), ./run.sh -c $(CC) -d $(DIR) -p deriche -s $(size) -o $(opt); ))

fdtd-2d:
	 $(foreach size, $(SIZES), $(foreach opt, $(OPT_LEVELS), ./run.sh -c $(CC) -d $(DIR) -p fdtd-2d -s $(size) -o $(opt); ))

getsummv:
	 $(foreach size, $(SIZES), $(foreach opt, $(OPT_LEVELS), ./run.sh -c $(CC) -d $(DIR) -p getsummv -s $(size) -o $(opt); ))

mvt:
	 $(foreach size, $(SIZES), $(foreach opt, $(OPT_LEVELS), ./run.sh -c $(CC) -d $(DIR) -p mvt -s $(size) -o $(opt); ))

# Rule to measure all the folders
# This uses order-only-prerequisites to make sure that 
# the targets are executed one after the other.
everything: | clean original original_autopar fission_manual fission_autopar

# Cleaning command
clean:
	rm -rf compiled*/
	rm -rf results/
	rm -rf _*_autopar/
