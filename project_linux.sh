#!/bin/bash
VOTE_FILE="votes.txt"
LOCK_FILE="vote.lock"
CANDIDATES=("Candidate A" "Candidate B" "Candidate C" "Candidate D")

cast_vote() {
echo "---CAST YOUR VOTE---"
while ! mkdir "$LOCK_FILE" 2>/dev/null; do
echo "Another process is voting. Waiting..."
sleep 1
done

echo "Available Candidates:"
for i in "${!CANDIDATES[@]}"; do
echo "$((i+1)). ${CANDIDATES[i]}"
done
echo "--------------------"
read -r -p "Enter the number of the candidate you wish to vote for (1-4): " choice
if [[ "$choice" =~ ^[1-4]$ ]]; then
index=$((choice - 1))
candidate="${CANDIDATES[index]}"
echo "$candidate" >> "$VOTE_FILE"
echo "Thank you! Your vote for **$candidate** has been recorded."
else
echo "Invalid choice. Please enter a number between 1 and 4."
fi
rmdir "$LOCK_FILE"
echo ""

}

show_results(){
echo "---ELECTION RESULTS---"
if [ ! -f  "$VOTE_FILE" ]; then
echo "No votes have been cast yet."
return
fi

echo "Vote Count:"
cat "$VOTE_FILE" | sort | uniq -c | sort -nr | while read -r count name; do
echo " $name: **$count** votes"
done

echo "--------------------"
total_votes=$(wc -l < "$VOTE_FILE")
echo "Total votes cast: **$total_votes**"
echo ""
}

while true; do
echo "===SIMPLE VOTING SYSTEM==="
echo "1. CAST VOTE"
echo "2. VIEW RESULTS"
echo "3. EXIT"
echo "=========================="
read -r -p "Enter your choice (1-3):" main_choice
case "$main_choice" in
1)
cast_vote
;;
2)
show_results
;;
3)
echo "Goodbye!"
exit 0
;;
*)
echo "Invalid Option. Please try again."
echo ""
;;
esac
done
                                                    
