# Enhanced PATH manager: view, deduplicate, add, and remove PATH entries
ppath() {
  emulate -L zsh
  
  # Parse options
  local mode="default"  # default|raw|preview|apply|remove|insert
  local target=""
  
  while [[ $# -gt 0 ]]; do
    case $1 in
      -u|--raw)      mode="raw"; shift ;;
      -p|--preview)  mode="preview"; shift ;;
      -a|--apply)    mode="apply"; shift ;;
      -r|--remove)   mode="remove"; target="$2"; shift 2 ;;
      -i|--insert)   mode="insert"; target="$2"; shift 2 ;;
      -h|--help)     _ppath_help; return 0 ;;
      *) echo "Unknown option: $1"; _ppath_help; return 1 ;;
    esac
  done
  
  # Split PATH into array
  local -a _paths
  _paths=(${(s/:/)PATH})
  
  case $mode in
    default)
      _ppath_display_default "${_paths[@]}"
      ;;
    raw)
      _ppath_display_raw "${_paths[@]}"
      ;;
    preview)
      _ppath_preview_duplicates "${_paths[@]}"
      ;;
    apply)
      _ppath_apply_dedup "${_paths[@]}"
      ;;
    remove)
      _ppath_remove_entry "$target" "${_paths[@]}"
      ;;
    insert)
      _ppath_insert_entry "$target" "${_paths[@]}"
      ;;
  esac
}

# Display deduplicated PATH entries (default mode)
_ppath_display_default() {
  local -a paths=("$@")
  local -a deduped=(${(u)paths})
  
  print -P "%F{blue}╭─ PATH Entries (deduplicated)%f"
  local i=1 p disp
  for p in "${deduped[@]}"; do
    disp=$p
    [[ -z $disp ]] && disp="(empty → current dir)"
    disp=${disp/#$HOME/\~}
    print -P "%F{blue}│%f %F{cyan}${(l:3::0:)i}.%f  %F{green}${disp}%f"
    ((i++))
  done
  print -P "%F{blue}╰─ Total: ${#deduped} entries%f"
}

# Display raw PATH entries without deduplication (sorted)
_ppath_display_raw() {
  local -a paths=("$@")
  local -a sorted=("${(@on)paths}")
  
  print -P "%F{blue}╭─ PATH Entries (raw, sorted)%f"
  local i=1 p disp
  for p in "${sorted[@]}"; do
    disp=$p
    [[ -z $disp ]] && disp="(empty → current dir)"
    disp=${disp/#$HOME/\~}
    print -P "%F{blue}│%f %F{cyan}${(l:3::0:)i}.%f  %F{yellow}${disp}%f"
    ((i++))
  done
  print -P "%F{blue}╰─ Total: ${#sorted} entries%f"
}

# Preview which entries would be removed (duplicates)
_ppath_preview_duplicates() {
  local -a paths=("$@")
  local -a deduped=(${(u)paths})
  local -a removed=()
  local -A seen
  
  # Find duplicates
  for p in "${paths[@]}"; do
    if [[ -n ${seen[$p]} ]]; then
      removed+=("$p")
    else
      seen[$p]=1
    fi
  done
  
  if (( ${#removed} == 0 )); then
    print -P "%F{green}✓ No duplicates found! PATH is already clean.%f"
    return 0
  fi
  
  print -P "%F{yellow}╭─ Preview: Duplicate entries that would be removed%f"
  local i=1 disp
  for p in "${removed[@]}"; do
    disp=$p
    [[ -z $disp ]] && disp="(empty)"
    disp=${disp/#$HOME/\~}
    print -P "%F{yellow}│%f %F{red}✗%f %F{243}${disp}%f"
    ((i++))
  done
  print -P "%F{yellow}╰─ Would remove ${#removed} duplicate(s)%f"
  print -P "%F{cyan}Tip: Run 'ppath -a' to apply deduplication%f"
}

# Apply deduplication and show removed entries
_ppath_apply_dedup() {
  local -a paths=("$@")
  local -a deduped=(${(u)paths})
  local -a removed=()
  local -A seen
  
  # Find duplicates
  for p in "${paths[@]}"; do
    if [[ -n ${seen[$p]} ]]; then
      removed+=("$p")
    else
      seen[$p]=1
    fi
  done
  
  if (( ${#removed} == 0 )); then
    print -P "%F{green}✓ No duplicates found! PATH is already clean.%f"
    return 0
  fi
  
  # Update PATH
  PATH=${(j/:/)deduped}
  export PATH
  
  print -P "%F{green}╭─ Deduplication applied successfully!%f"
  local i=1 disp
  for p in "${removed[@]}"; do
    disp=$p
    [[ -z $disp ]] && disp="(empty)"
    disp=${disp/#$HOME/\~}
    print -P "%F{green}│%f %F{red}✗ Removed:%f %F{243}${disp}%f"
    ((i++))
  done
  print -P "%F{green}╰─ Removed ${#removed} duplicate(s)%f"
  print -P "%F{cyan}New PATH has ${#deduped} unique entries%f"
}

# Remove entry by index number (based on raw PATH)
_ppath_remove_entry() {
  local idx="$1"
  shift
  local -a paths=("$@")
  
  # Validate index
  if [[ ! $idx =~ ^[0-9]+$ ]]; then
    print -P "%F{red}✗ Error: Index must be a number%f"
    return 1
  fi
  
  if (( idx < 1 || idx > ${#paths} )); then
    print -P "%F{red}✗ Error: Index $idx out of range (1-${#paths})%f"
    return 1
  fi
  
  local removed="${paths[$idx]}"
  local disp=${removed/#$HOME/\~}
  [[ -z $disp ]] && disp="(empty)"
  
  # Remove the entry
  paths[$idx]=()
  PATH=${(j/:/)paths}
  export PATH
  
  print -P "%F{green}╭─ Entry removed successfully!%f"
  print -P "%F{green}│%f %F{red}✗ Removed #${idx}:%f %F{243}${disp}%f"
  print -P "%F{green}╰─ New PATH has ${#paths} entries%f"
}

# Insert a new directory to PATH
_ppath_insert_entry() {
  local new_dir="$1"
  shift
  local -a paths=("$@")
  
  if [[ -z $new_dir ]]; then
    print -P "%F{red}✗ Error: No directory specified%f"
    return 1
  fi
  
  # Expand ~ if present
  new_dir="${new_dir/#\~/$HOME}"
  
  # Check if directory exists
  if [[ ! -d $new_dir ]]; then
    print -P "%F{yellow}⚠ Warning: Directory does not exist: ${new_dir}%f"
    read -q "REPLY?Continue anyway? (y/n) "
    echo
    if [[ $REPLY != "y" ]]; then
      print -P "%F{red}✗ Cancelled%f"
      return 1
    fi
  fi
  
  # Check if already in PATH
  if (( ${paths[(I)$new_dir]} )); then
    print -P "%F{yellow}⚠ Warning: Directory already in PATH%f"
    return 1
  fi
  
  # Add to beginning of PATH
  paths=("$new_dir" "${paths[@]}")
  PATH=${(j/:/)paths}
  export PATH
  
  local disp=${new_dir/#$HOME/\~}
  print -P "%F{green}╭─ Entry added successfully!%f"
  print -P "%F{green}│%f %F{green}✓ Added at position 1:%f %F{cyan}${disp}%f"
  print -P "%F{green}╰─ New PATH has ${#paths} entries%f"
}

# Display help message
_ppath_help() {
  cat << 'EOF'
ppath - Enhanced PATH manager for zsh

Usage:
  ppath [OPTIONS]

Options:
  (none)           Display deduplicated PATH entries (default)
  -u, --raw        Display raw PATH entries without deduplication (sorted)
  -p, --preview    Preview duplicate entries that would be removed
  -a, --apply      Apply deduplication and show removed entries
  -r, --remove N   Remove PATH entry at index N (from raw view)
  -i, --insert DIR Insert directory at the beginning of PATH
  -h, --help       Show this help message

Examples:
  ppath                      # View deduplicated PATH
  ppath -u                   # View all entries with duplicates
  ppath -p                   # Preview what would be removed
  ppath -a                   # Remove duplicates from PATH
  ppath -r 5                 # Remove entry #5
  ppath -i ~/my/bin          # Add ~/my/bin to PATH

Tips:
  - Use 'ppath -u' to see entry numbers before removing
  - Changes to PATH are temporary (current session only)
  - Use 'ppath -p' before 'ppath -a' to preview changes
EOF
}
