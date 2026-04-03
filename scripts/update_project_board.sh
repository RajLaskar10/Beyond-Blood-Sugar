#!/bin/bash
PROJECT_NUMBER=2
OWNER="RajLaskar10"

# Status Option IDs from field-list:
# Todo: f75ad846
# In Progress: 47fc9ee4
# In- Review: ad3613e1
# Done: 98236657
STATUS_FIELD_ID="PVTSSF_lAHOAnrNk84BSzk5zhAO49s"
TODO_OPTION_ID="f75ad846"
DONE_OPTION_ID="98236657"

RAJ="RajLaskar10"
GAURAV="GauravBidani16"
NAMYA="namya-singh"

echo "Fetching issue list..."
issues=$(gh issue list --limit 40 --json number,id)

echo "Processing issues..."

echo "$issues" | jq -c '.[]' | while read -r issue; do
  number=$(echo "$issue" | jq -r '.number')
  
  assignees=""
  status_option="$TODO_OPTION_ID"
  
  # Assignment Logic
  case $number in
    1|2|3|4|5|6|7|8|12|29) assignees="$RAJ" ;;
    13|14|15|16|17|18|19|20|22|30) assignees="$GAURAV" ;;
    9|10|11|21|23|25|26|27|28|31) assignees="$NAMYA" ;;
    24|32|33) assignees="$RAJ,$GAURAV,$NAMYA" ;;
  esac

  # Status Logic
  if [ "$number" -le 3 ]; then
    status_option="$DONE_OPTION_ID"
  fi

  echo "Updating Issue #$number (Assigning to $assignees, Status: $( [ "$status_option" == "$DONE_OPTION_ID" ] && echo "Done" || echo "Todo" ))..."
  
  # 1. Assign Issue
  gh issue edit "$number" --add-assignee "$assignees" > /dev/null
  
  # 2. Add to Project (idempotent)
  item_id=$(gh project item-add $PROJECT_NUMBER --owner $OWNER --url "https://github.com/$OWNER/Beyond-Blood-Sugar/issues/$number" --format json | jq -r '.id')
  
  # 3. Set Status
  if [ -n "$item_id" ] && [ "$item_id" != "null" ]; then
    gh project item-edit $PROJECT_NUMBER --id "$item_id" --field-id "$STATUS_FIELD_ID" --project-id "PVT_kwHOAnrNk84BSzk5" --single-select-option-id "$status_option" > /dev/null
  fi
done

echo "Project board and issues updated successfully."
