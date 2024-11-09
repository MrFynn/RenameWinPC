# **Rename PC with WMIC Script**

This batch script provides an interactive menu to rename or restore the computer’s name using Windows Management Instrumentation Command-line (WMIC) on Windows. Designed for easy use, it helps users manage computer names with minimal effort, ensuring administrative rights and preventing duplicate entries.
**Features**

* Rename Computer Name: Prompt for a new computer name, confirm changes, and automatically apply them.
* Restore Old Computer Name: Select from previous computer names stored in a backup file (Old_PC_Name.BAK) to easily revert to a prior name.
* Admin Privileges Handling: Automatically relaunches the script with administrative privileges if required.
* Duplicate Prevention: Uses PowerShell to prevent duplicate entries in the backup file.
* Optional Reboot Prompt: Asks if the user would like to reboot after renaming for changes to take effect.

**Requirements**

* PowerShell: For removing duplicate entries from the list of previous names.
* WMIC: Must be available on the system for the script to rename the computer.
* Administrator Rights: Required for renaming the computer.

**Usage**

* Run the script as an administrator.
* Confirm any prompts as needed.

**Notes**

* The script is compatible with Windows and works best on systems with PowerShell and WMIC installed.
* For troubleshooting, ensure you have administrator privileges and that PowerShell execution is allowed.
