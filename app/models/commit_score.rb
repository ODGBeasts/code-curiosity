class CommitScore
  def initialize(commit, repo)
    @commit = commit
    @repo = repo
    @pr = commit.pull_request
  end
  
  def calculate
    rand(10)
  end
end
