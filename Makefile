PROGRAM = app
INCLUDE = -I ./include
LIB = ./lib
LIBS = $(LIB)/model.a
LIBTOOLS = $(LIB)/model.a
LDEPENDENCY = -lmodel
LTOOLSDEPENDENCY = -ljansson -lmodel
WARNINGS = -ggdb3 # -Wall -Werror -Wextra
MODULE = ./module
MODULES = $(MODULE)/enseignant.o $(MODULE)/horaire.o $(MODULE)/creneau.o $(MODULE)/salle.o $(MODULE)/formation.o $(MODULE)/enseignants.o $(MODULE)/salles.o
TOOLS = $(MODULE)/enseignant.o $(MODULE)/horaire.o $(MODULE)/creneau.o $(MODULE)/salle.o $(MODULE)/formation.o $(MODULE)/enseignants.o $(MODULE)/salles.o
SRC = ./src
DEST = ./bin
TEST = -DTEST
DEPTEST = -DJSON
DEBUG = -DDEBUG

# program compile

start: $(DEST)/release/$(PROGRAM)
	$<

# ! build on .o files if .a compile fail (case study on WSL)
$(DEST)/release/$(PROGRAM): $(SRC)/$(PROGRAM).c $(LIBS) # $(LIBTOOLS)
	gcc $(INCLUDE) -L $(LIB) $(WARNINGS) $< -o $@ $(LDEPENDENCY) $(LTOOLSDEPENDENCY) || gcc $(INCLUDE) $(MODULES) $(TOOLS) $(WARNINGS) $< -o $@

# program debug

debug: $(DEST)/debug/$(PROGRAM)
	$<

# ! build on .o files if .a compile fail (case study on WSL)
$(DEST)/debug/$(PROGRAM):
	gcc $(INCLUDE) -L $(LIB) $(WARNINGS) $(DEBUG) $< -o $@ $(LDEPENDENCY) $(LTOOLSDEPENDENCY) || gcc $(INCLUDE) $(MODULES) $(TOOLS) $(WARNINGS) $(DEBUG) $< -o $@


# library compile

init: $(LIBS) $(LIBTOOLS)

# ? using pattern rules to automatically compile .o files from MODULES source list
# https://www.gnu.org/software/make/manual/html_node/Static-Usage.html#Static-Usage
$(LIBS): $(LIB)/%.a: $(SRC)/%
	rm -f $(MODULE)/*
	cd $< && make init

#$(LIBTOOLS): $(LIB)/%.a: $(SRC)/%
#	cd $< && make init

# dependencies unit tests

# ! build on .o files if .a compile fail (case study on WSL)
test/%: $(SRC)/%.c $(LIBTOOLS)
	gcc $(INCLUDE) -L $(LIB) $(WARNINGS) $(DEBUG) $(TEST) $< -o $(SRC)/$* $(LTOOLSDEPENDENCY) || gcc $(INCLUDE) $(TOOLS) $(WARNINGS) $(DEBUG) $(TEST) $< -o $(SRC)/$*
	./$(SRC)/$*
	rm $(SRC)/$*

# ! build on .o files if .a compile fail (case study on WSL)
testdep/%: $(SRC)/%.c $(LIBTOOLS)
	gcc $(INCLUDE) -L $(LIB) $(WARNINGS) $(DEBUG) $(TEST) $(DEPTEST) $< -o $(SRC)/$* $(LTOOLSDEPENDENCY) || gcc $(INCLUDE) $(TOOLS) $(WARNINGS) $(DEBUG) $(TEST) $(DEPTEST) $< -o $(SRC)/$*
	./$(SRC)/$*
	rm $(SRC)/$*

# project cleanup

prune:
	rm -f $(MODULE)/*
#	rm -f $(LIB)/*
	rm -f $(DEST)/*