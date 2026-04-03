#!/bin/bash
echo "Renaming issues for project $OWNER/Beyond-Blood-Sugar..."

issues=$(gh issue list --limit 40 --json number,title)

echo "$issues" | jq -c '.[]' | while read -r issue; do
  number=$(echo "$issue" | jq -r '.number')
  title=$(echo "$issue" | jq -r '.title')
  
  phase=""
  case $number in
    1|2|3) phase="0" ;;
    4|5|6|7) phase="1" ;;
    8) phase="2" ;;
    9|10|11) phase="3" ;;
    12|13) phase="4" ;;
    14|15|16|17|18|19) phase="5" ;;
    20|21) phase="6" ;;
    22|23|24) phase="7" ;;
    25|26|27|28) phase="8" ;;
    29|30|31|32|33) phase="9" ;;
  esac

  new_title="[Phase $phase] $title"
  echo "Renaming Issue #$number to: $new_title"
  gh issue edit "$number" --title "$new_title" > /dev/null
done

echo "Done."
