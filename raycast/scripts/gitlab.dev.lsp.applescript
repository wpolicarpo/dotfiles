#!/usr/bin/osascript

# @raycast.schemaVersion 1
# @raycast.packageName gitlab.dev
# @raycast.title Start GitLab LSP dev environment
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
            set name to "gitlab-lsp"
            write text "cd ~/git/gitlab-lsp"
            write text "printf \"\\e]1337;SetBadgeFormat=%s\\a\" $(echo -n gitlab-lsp | base64)"
            write text "npm run watch -- --editor=vscode"
        end tell

        tell second session of current tab
            set name to "gitlab-lsp"
            write text "cd ~/git/gitlab-lsp"
            write text "printf \"\\e]1337;SetBadgeFormat=%s\\a\" $(echo -n gitlab-lsp | base64)"
        end tell

        tell third session of current tab
            set name to "vscode"
            write text "cd ~/git/gitlab-vscode-extension"
            write text "printf \"\\e]1337;SetBadgeFormat=%s\\a\" $(echo -n vscode | base64)"
            write text "npm run watch:desktop"
        end tell

        tell fourth session of current tab
            set name to "vscode"
            write text "cd ~/git/gitlab-vscode-extension"
            write text "printf \"\\e]1337;SetBadgeFormat=%s\\a\" $(echo -n vscode | base64)"
            write text "NODE_ENV=development GITLAB_VSCODE_ENV=development code --extensionDevelopmentPath=./dist-desktop --add ~/git/gitlab-lsp --add ~/git/gitlab-vscode-extension"
        end tell
    end tell
end tell
