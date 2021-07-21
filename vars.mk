CXX      = g++
CXXFLAGS += -Wall -Wextra -pedantic
CC       = $(CXX) $(CXXFLAGS)
CPPFLAGS += -std=c++11

AR      = ar
ARFLAGS += rvs

ifeq ($(OS),Windows_NT)
	MKDIR  = mkdir
	RM     = del
	RMDIR  = rmdir /s /Q
	COPY   = copy
	MOVE   = move
	RENAME = ren
	NULL_DEVICE = nul
else
	MKDIR  = mkdir -p
	RM     = rm -f
	RMDIR  = rm -r
	COPY   = cp
	MOVE   = mv -f
	RENAME = mv -f
	NULL_DEVICE = /dev/null
endif