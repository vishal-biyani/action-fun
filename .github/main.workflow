workflow "OnPush" {
  on = "push"
  resolves = ["Close issue"]
}

action "Issue" {
  uses = "swinton/httpie.action@master"
  args = ["--auth-type=jwt", "--auth=$GITHUB_TOKEN", "POST", "api.github.com/repos/$GITHUB_REPOSITORY/issues", "title=Hello\\ world"]
  secrets = ["GITHUB_TOKEN"]
}

action "Comment on issue" {
  needs = ["Issue"]
  uses = "swinton/httpie.action@master"
  args = ["--auth-type=jwt", "--auth=$GITHUB_TOKEN", "POST", "`jq .comments_url /github/home/Issue.response.body --raw-output`", "body=Thanks\\ for\\ playing\\ :v:"]
  secrets = ["GITHUB_TOKEN"]
}

action "Close issue" {
  needs = ["Issue", "Comment on issue"]
  uses = "swinton/httpie.action@master"
  args = ["--auth-type=jwt", "--auth=$GITHUB_TOKEN", "PATCH", "`jq .url /github/home/Issue.response.body --raw-output`", "state=closed"]
  secrets = ["GITHUB_TOKEN"]
}
