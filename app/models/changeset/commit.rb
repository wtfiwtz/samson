class Changeset::Commit
  PULL_REQUEST_MERGE_MESSAGE = /\AMerge pull request #(\d+)/

  def initialize(repo, data)
    @repo, @data = repo, data
  end

  def author_name
    @data.commit.author.name
  end

  def author
    @author ||= Changeset::GithubUser.new(@data.author) if @data.author
  end

  def author_avatar_url
    author.avatar_url if author.present?
  end

  def author_url
    author.url if author.present?
  end

  def summary
    summary = @data.commit.message.split("\n").first
    summary.truncate(80)
  end

  def sha
    @data.sha
  end

  def short_sha
    @data.sha[0...7]
  end

  def hotfix?
    @data.commit.message.start_with?("HOTFIX")
  end

  def pull_request_number
    if summary =~ PULL_REQUEST_MERGE_MESSAGE
      Integer($1)
    end
  end

  def url
    "https://github.com/#{@repo}/commit/#{sha}"
  end
end
