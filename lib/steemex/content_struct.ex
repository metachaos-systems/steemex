defmodule ContentStruct do
  defstruct [allow_replies: nil, body: nil, total_vote_weight: nil, reward_weight: nil,
  vote_rshares: nil, root_title: nil, children: nil, category: nil,
  pending_payout_value: nil, curator_payout_value: nil,
  total_pending_payout_value: nil, max_accepted_payout: nil, mode: nil,
  created: nil, url: nil, parent_author: nil, author: nil, children_rshares2: nil,
  children_abs_rshares: nil, allow_curation_rewards: nil, last_update: nil,
  abs_rshares: nil, cashout_time: nil, percent_steem_dollars: nil,
  json_metadata: nil, depth: nil, author_reputation: nil, max_cashout_time: nil,
  last_payout: nil, root_comment: nil, permlink: nil, parent_permlink: nil,
  net_votes: nil, author_rewards: nil, net_rshares: nil, allow_votes: nil,
  replies: nil, id: nil, active: nil, total_payout_value: nil, title: nil
  ]

  use ExConstructor
end
