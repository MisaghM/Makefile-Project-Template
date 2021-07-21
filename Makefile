PATH_SRC   := src
PATH_LIB   := lib
PATH_BUILD := build
PATH_BIN   := $(PATH_BUILD)/bin
PATH_OBJ   := $(PATH_BUILD)/obj
PATH_DEP   := $(PATH_OBJ)/dep

include vars.mk

LDFLAGS += -L "$(PATH_LIB)"
LDLIBS  += #-l

OUT_EXE := program.exe

#----------------------------------------

VPATH = $(PATH_SRC)

FILES = main.cpp

FILES_DEP = $(patsubst %, $(PATH_DEP)/%.d, $(basename $(FILES)))
FILES_OBJ = $(patsubst %, $(PATH_OBJ)/%.o, $(basename $(FILES)))

#----------------------------------------

all: $(PATH_BIN)/$(OUT_EXE)

$(PATH_BIN)/$(OUT_EXE): $(FILES_OBJ)
	 $(CC) $(LDFLAGS) $^ $(LDLIBS) -o $@

DEPFLAGS    = -MT $@ -MMD -MP -MF $(PATH_DEP)/$*.dTMP
POSTCOMPILE = @$(MOVE) "$(PATH_DEP)/$*.dTMP" "$(PATH_DEP)/$*.d" > $(NULL_DEVICE) && touch $@

$(PATH_OBJ)/%.o: %.cpp
$(PATH_OBJ)/%.o: %.cpp $(PATH_DEP)/%.d | $(PATH_BUILD) $(PATH_BIN) $(PATH_OBJ) $(PATH_DEP)
	 $(CC) $(CPPFLAGS) -c $(DEPFLAGS) $< -o $@
	 $(POSTCOMPILE)

.PRECIOUS: $(FILES_DEP)
$(FILES_DEP): ;
-include $(FILES_DEP)

#----------------------------------------

$(PATH_BUILD): ; $(MKDIR) $@
$(PATH_BIN): ; $(MKDIR) $@
$(PATH_OBJ): ; $(MKDIR) $@
$(PATH_DEP): ; $(MKDIR) $@

.PHONY: all clean clean-obj clean-dep clean-exe delete-build run help

clean: clean-obj clean-dep clean-exe
clean-obj: ; $(RM) $(PATH_OBJ)/*.o
clean-dep: ; $(RM) $(PATH_DEP)/*.d
clean-exe: ; $(RM) $(PATH_BIN)/*.exe
delete-build: ; $(RMDIR) $(PATH_BUILD)

ARGS ?= 
run: ; cd $(PATH_BIN) && ./$(OUT_EXE) $(ARGS)

help:
	@echo Targets: all clean clean-obj clean-dep clean-exe delete-build run
	@echo (make run ARGS="arg1 arg2...")