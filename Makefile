# Directory variables
SRC_DIR = src
INSTALL_DIR = /usr/local/sbin

# List of Python scripts to install
SCRIPTS = echolog el-monitor el-server

# Default target
all:
	@echo "Default make does not perform installation. Use 'make install' to install scripts."

# Install target
install:
	@echo "Installing scripts to $(INSTALL_DIR)..."
	@for script in $(SCRIPTS); do \
		echo "Installing $$script..."; \
		install -m 755 $(SRC_DIR)/$$script $(INSTALL_DIR)/$$script; \
	done

# Uninstall target
uninstall:
	@echo "Removing scripts from $(INSTALL_DIR)..."
	@for script in $(SCRIPTS); do \
		echo "Removing $$script..."; \
		rm -f $(INSTALL_DIR)/$$script; \
	done

# Clean target
clean:
	@echo "Clean target does nothing for now..."

# Phony targets
.PHONY: all install uninstall clean

