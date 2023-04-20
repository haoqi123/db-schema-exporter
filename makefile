# Makefile

# Set the name of your go program
PROGNAME=db-schema-exporter

# Set the go source files
SRCS=db-schema-exporter.go

# Set the go build flags
BUILD_FLAGS=-ldflags="-s -w"

# Set the output directory
OUTDIR=./bin

# Set the output filename
OUTFILE=$(OUTDIR)/$(PROGNAME)

# Set the default make target
.DEFAULT_GOAL := build

# Build the program
build:
	mkdir -p $(OUTDIR)
	go build $(BUILD_FLAGS) -o $(OUTFILE) $(SRCS)

# Clean the program
clean:
	rm -rf $(OUTDIR)

# Rebuild the program
rebuild: clean build

# Run the program
run:
	$(OUTFILE)

# Show help
help:
	@echo "Usage: make [target]"
	@echo ""
	@echo "Targets:"
	@echo "  build      Build the program"
	@echo "  clean      Clean the program"
	@echo "  rebuild    Clean and rebuild the program"
	@echo "  run        Run the program"
	@echo "  help       Show this help message"
