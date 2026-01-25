messages=(
  ""                          # empty
  "Hi"                        # 2 chars
  "OK"                        # 2 chars
  "Yes"                       # 3 chars
  "No"                        # 2 chars
  "Wait"                      # 4 chars
  "Done"                      # 4 chars
  "K"                         # 1 char
  "Bye"                       # 3 chars
  "Thx"                       # 3 chars
  "Hello there!"              # longer
  "How are you doing?"        # longer
  "Just checking in"          # longer
  "Meeting at 3pm"            # longer
  "Don't forget the deadline" # longer
  "Great work today"          # longer
  "See you tomorrow"          # longer
  "Quick question for you"    # longer
  "Thanks for your help"      # longer
  "Running a bit late"        # longer
)

for i in {1..200}; do
  random_msg="${messages[$RANDOM % ${#messages[@]}]}"

  curl -s -o /dev/null -w "stable req $i -> %{http_code}\n" \
    -H "Host: sms.local" \
    -H "Content-Type: application/json" \
    -b "user-experiment=stable" \
    -d "{\"sms\":\"$random_msg\"}" \
    "http://192.168.56.95/sms"

  curl -s -o /dev/null -w "stable req $i -> %{http_code}\n" \
    -H "Host: sms.local" \
    -H "Content-Type: application/json" \
    -b "user-experiment=canary" \
    -d "{\"sms\":\"$random_msg\"}" \
    "http://192.168.56.95/sms"
done
