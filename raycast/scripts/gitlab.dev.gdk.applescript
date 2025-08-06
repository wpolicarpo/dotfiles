#!/usr/bin/osascript

# @raycast.schemaVersion 1
# @raycast.packageName gitlab.dev
# @raycast.title Start GitLab dev environment
# @raycast.mode silent
# @raycast.icon ../icons/gitlab.dev.png

tell application "iTerm2"
    create window with default profile

    tell current window
        tell current session of current tab
            split vertically with default profile
        end tell

        tell first session of current tab
            split horizontally with default profile
        end tell

        tell third session of current tab
            split horizontally with default profile
        end tell

        tell first session of current tab
            set name to "gitlab"
            write text "cd ~/gdk/gitlab"
            write text "printf \"\\e]1337;SetBadgeFormat=%s\\a\" $(echo -n gitlab | base64)"
            write text "k tail rails-web"
        end tell

        tell second session of current tab
            set name to "gitlab"
            write text "printf \"\\e]1337;SetBadgeFormat=%s\\a\" $(echo -n gitlab | base64)"
            write text "cd ~/gdk/gitlab"
        end tell

        tell third session of current tab
            set name to "gateway"
            write text "cd ~/gdk/gitlab-ai-gateway"
            write text "printf \"\\e]1337;SetBadgeFormat=%s\\a\" $(echo -n gateway | base64)"
            write text "k tail gitlab-ai-gateway"
        end tell

        tell fourth session of current tab
            set name to "gateway"
            write text "printf \"\\e]1337;SetBadgeFormat=%s\\a\" $(echo -n gateway | base64)"
            write text "cd ~/gdk/gitlab-ai-gateway"
        end tell
    end tell
end tell
