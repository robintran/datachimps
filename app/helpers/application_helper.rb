module ApplicationHelper
  def entry_rating(entry, opts = {})
    raw([:quality, :amount, :speed].map do |dimension|
      options = {dimension: dimension, remote_options: {url: rate_contest_entry_path(entry.contest, entry)}}.merge(opts)
      "<span class='dimension-name'>#{dimension.to_s.capitalize}</span>: " + ratings_field_for(entry, options)
    end.join(""))
  end

  def ratings_field_for(entry, options = {})
    if current_user == entry.contest.user
      ratings_for(entry, options)
    else
      ratings_for(entry, :static, options)
    end
  end
end
