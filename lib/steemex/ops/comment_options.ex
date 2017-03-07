defmodule Steemex.Ops.CommentOptions do
  @enforce_keys [:allow_curation_rewards, :allow_votes, :author, :extensions, :max_accepted_payout, :percent_steem_dollars, :permlink ]
  defstruct [:allow_curation_rewards, :allow_votes, :author, :extensions, :max_accepted_payout, :percent_steem_dollars, :permlink ]
end
