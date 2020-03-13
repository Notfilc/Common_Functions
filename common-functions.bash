# 13 March 2020, Nick Clifton
# 80-column guide, remove when not needed 34567890123456789012345678901234567890
# Set of common functions to be included in other scripts by use of the 'source'
# command.
# Each function has a description of what to pass to it (PASS) and what it
# does (DOES).
# All function names should start "common_...", e.g. "common_usage"
# Useful link for parameter substitution (sorry, this exceeds 80 columns):
#  https://www.gnu.org/software/bash/manual/html_node/Shell-Parameter-Expansion.html

common_variables(){
# 80-column guide, remove when not needed 34567890123456789012345678901234567890
  # PASS: No parameters
  # DOES: Sets common constants and variables, names should start "c_...,
  # e.g.: c_script_path  c_exit_code
  
  # Get set up for screen positioning and colours, not my own work, I extracted
  # this from /etc/init.d/functions and /etc/sysconfig/init files and adapted.
  if [[ -z "${COLUMNS}" ]]; then COLUMNS=80; fi
  if [[ -z "${CONSOLETYPE}" ]]; then CONSOLETYPE="$(/sbin/consoletype)"
  boot_up=colour
  reserved_col=60
  move_to_col="echo -en \\033[${reserved_col}G"
  colour_success="echo -en \\033[[0;32m"
  colour_failure="echo -en \\033[[0;31m"
  colour_warning="echo -en \\033[[0;33m"
  colour_normal="echo -en \\033[[0;39m"
  if [[ "${CONSOLETYPE}" = "serial" ]]; then
    boot_up=serial
    move_to_col=""
    colour_success=""
    colour_failure=""
    colour_warning=""
    colour_normal=""
  fi
    
  c_script_path="$( pwd $( dirname $0 ) )"
  c_script_name="$( basename $0 )"
  c_exit_code=0
  c_exit_mssg=""
}





common_usage(){
# 80-column guide, remove when not needed 34567890123456789012345678901234567890
  # Parameters:
  #   1 - variable containing the usage message unique to the calling script. 
  # Output:
  #   Clears screen then outputs the usage message with a blank line before and
  #   after. If null or unset parameter, outputs default message to this effect.
  # While making this a function might seem excessive, it allows for future
  # changes to the output layout, such as a corporate header before the message.
  
  missing_usage="No usage message has been provided for this script"
  clear
  echo "
Usage: ${1:-${missing_usage}}

"
}






#!/bin/bash

# 19 Feb, Nick Clifton
#
# Set of common functions to be included in other scripts by use of the 'source'
# command.
# Each function has a description of what to pass to it (PASS) and what it
# does (DOES).

# Function              Description
# --------------------  --------------------------------------------------------
# init_common_variables  Sets up common constants and variables
# display_message        Outputs a string preceeded and followed by a blank line
# exit_script            Outputs a string preceeded and followed by a blank line
#                        then exits from the script
# test_directory         
# test_file              

init_common_variables(){
  # PASS: No parameters
  # DOES: Sets common constants and variables, such as script_path, exit_code
  
  # Get set up for screen positioning and colours, extracted from
  # /etc/init.d/functions and /etc/sysconfig/init files
  if [[ -z "${COLUMNS:-}" ]]; then COLUMNS=80; fi
  if [[ -z "${CONSOLETYPE:-}" ]]; then CONSOLETYPE="$(/bin/consoletype)"
  boot_up=colour
  reserved_col=60
  move_to_col="echo -en \\033[${reserved_col}G"
  colour_success="echo -en \\033[[0;32m"
  colour_failure="echo -en \\033[[0;31m"
  colour_warning="echo -en \\033[[0;33m"
  colour_normal="echo -en \\033[[0;39m"
  if [[ "${CONSOLETYPE}" = "serial" ]]; then
    boot_up=serial
    move_to_col=""
    colour_success=""
    colour_failure=""
    colour_warning=""
    colour_normal=""
  fi
    
  script_path="$( pwd $( dirname $0 ) )"
  script_name="$( basename $0 )"
  exit_code=0
  exit_mssg=""
}

display_message(){
  # PASS: 1 - String to be displayed, 'echo' escape codes allowed
  # DOES: Outputs the string with a blank line before and after
  echo ""
  echo -e "$1"
  echo ""
}

exit_script(){
  # PASS: 1 - Exit message, may contain escape codes relevant to echo
  #       2 - Exit code to be passed back when script exits
  # DOES: Outputs exit message with a blank line before and after, then exits
  #       passing back the code
  echo ""
  echo -e "$1"
  echo ""
  exit $2
}

test_directory(){
  # PASS: 1 - Directory name with full path
  # DOES: Checks that the variable is not empty, that the item actually exists,
  #       and that it is actually a directory
  local dir_path="$1"
  return_code=0
  if [[ -z "${dir_path}" ]];then
    display_message "Error: No directory name has been specified"
    return_code=10
  else
    if [[ ! -e "${dir_path}" ]];then
      display_message "Error: Directory '${directory_name}' does not exist"
      return_code=11
    else
      if [[ ! -d "${dir_path}" ]]; then
        display_message "Error: Object '${directory_name}' is not a directory"
        return_code=12
      fi
    fi
  fi
  return ${return_code}
}

test_file(){
  # PASS: 1 - File name with full path
  # DOES: Checks that the variable is not empty, that the item is not just a
  #       path, that the item exists and that it is a file
  local file_name="$1"
  local last_char="${file_name:((${#file_name}-1)):1}"
  return_code=0

  if [[ -z "${file_name}" ]] || [[ "${last_char}" = "/" ]]; then
    display_message "Error: No file name has been specified"
    return_code=20
  else
    if [[ ! -e "${file_name_and_path}" ]];then
      display_message "Error: File '${file_name}' does not exist"
      return_code=21
    else
      if [[ ! -f "${file_name}" ]]; then
        display_message "Error: Object '${file_name_and_path}' is not a file"
        return_code=22
      fi
    fi
  fi
  return ${return_code}
}

display_status(){
  local status_mssg="$1"
  local status_colour=""
  case status_colour in
    [[ "${status_mssg}" = "0" ]])
      status_colour="${colour_success}"
      ;;
    [[ "${status_mssg}" = "1" ]])
      status_colour="${colour_failure}"
      ;;
    *)
      status_colour="${colour_warning}"
      ;;
  esac
  
  echo -n "${move_to_col}["
  echo -n "${status_colour}${status_mssg}"
  echo -n "${colour_normal}]"
  echo -ne "\r"
  return 0
  
}
