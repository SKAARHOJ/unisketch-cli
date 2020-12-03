function duplicate_checker_main() {
  for var in $(seq 0 300) 
  do 
    result=$(cat VMix.php | grep -E "\s+$var\s*=>\s*\[\s*HWC" | wc -l)
    
    if [[ $result -gt 1 ]]
    then 
      echo "$var is duplicate"
    fi
  done
}

