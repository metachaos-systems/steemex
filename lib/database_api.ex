defmodule Steemex.DatabaseApi do

  def call(method, params) do
    Steemex.call(["database_api", method, params])
  end

  @doc"""
  Returns block data, accepts block height.

  Example response:
  ```
  %{"extensions" => [], "previous" => "002fefd79249e7d045bedbd5b18edef1d39e9ed8",
    "timestamp" => "2016-07-12T19:49:39",
    "transaction_merkle_root" => "b5a941121fb4872bb833b40e7958ad8da29eeea7",
    "transactions" => [%{"expiration" => "2016-07-12T19:49:51",
       "extensions" => [],
       "operations" => [["limit_order_create",
         %{"amount_to_sell" => "74.820 SBD",
           "expiration" => "1969-12-31T23:59:59", "fill_or_kill" => false,
           "min_to_receive" => "43.000 STEEM", "orderid" => 1468352976,
           "owner" => "scrawl"}]], "ref_block_num" => 61355,
       "ref_block_prefix" => 4242992740,
       "signatures" => ["20291edff748042820a8a49ae8f527d56a0fb47c52e936695622cc61105ab13d54503e4a64d22f9a4ce0b96ba348310e8275c9a5c3dbc9260b13f13d6ba840f388"]},
     %{"expiration" => "2016-07-12T19:49:48", "extensions" => [],
       "operations" => [["comment",
         %{"author" => "aziel",
           "body" => "...",
           "json_metadata" => "{\"tags\":[\"news\",\"CHexit\"]}",
           "parent_author" => "", "parent_permlink" => "news",
           "permlink" => "south-china-sea-china-defiant-as-tribunal-backs-philippines",
           "title" => "South China Sea: China defiant as tribunal backs Philippines"}],
        ["vote",
         %{"author" => "aziel",
           "permlink" => "south-china-sea-china-defiant-as-tribunal-backs-philippines",
           "voter" => "aziel", "weight" => 10000}]], "ref_block_num" => 61324,
       "ref_block_prefix" => 447820231,
       "signatures" => ["1f1aeb1bd7888da91d8efd6fc95232b17f4b9ded9c237c74e06f6532292678397076fb90c913a8ebe675118ae0977e31c191d5cef4601ea140b1bac72f8aeae9d3"]},
     %{"expiration" => "2016-07-12T19:49:51", "extensions" => [],
       "operations" => [["vote",
         %{"author" => "germanaure",
           "permlink" => "jeff-garzik-keynote-international-blockchain-real-estate-assn-conference",
           "voter" => "alexfortin", "weight" => 10000}]],
       "ref_block_num" => 61391, "ref_block_prefix" => 806313838,
       "signatures" => ["200c367860effe947ba19b8a65d9465bc4195df2809ed6a9274f45f1a827d042183dc88564b50dcb38d1cbdf2db8e6a6f3a3ad2810a67091bfcb1a76de602d45f2"]},
     %{"expiration" => "2016-07-12T19:49:51", "extensions" => [],
       "operations" => [["vote",
         %{"author" => "blakemiles84",
           "permlink" => "re-pfunk-meet-10-steem-superheroes-the-brave-men-and-women-powering-up-bigtime-20160712t073442453z",
           "voter" => "ajvest", "weight" => 10000}]], "ref_block_num" => 61377,
       "ref_block_prefix" => 4210414829,
       "signatures" => ["207f8d16a2993895cb827cd05a6f7367f10231a2af07e069ce64dcc01faf14d3127c4d924760eb78d6a8c6d3af0132235e2c2f198091ef9a5c03375174366d4b28"]}],
    "witness" => "roadscape",
    "witness_signature" => "2064f08ff9a8c6ca33a05847c06176f431e182c3aa2678d05c021914c7d1ad49a61641c3f0de5424281be5056e54e017cfa16934c4fecee04bb8395aa3bd202281"}
  ```
  """
  @spec get_block(integer) :: map
  def get_block(height) do
    call("get_block", [height])
  end

  def get_content(author, permlink) do
    call("get_content", [author, permlink])
  end

  @doc"""
  Returns account data. Accepts a list of up to 1000 account names

  Example response:
  ```
  [%{"recovery_account" => "steem", "guest_bloggers" => [],
     "posting_rewards" => 44618927, "created" => "2016-03-31T14:21:39",
     "last_bandwidth_update" => "2017-02-06T03:22:39", "to_withdraw" => 0,
     "last_active_proved" => "1970-01-01T00:00:00", "tags_usage" => [],
     "withdraw_routes" => 0, "last_account_update" => "2016-07-15T19:27:51",
     "sbd_last_interest_payment" => "2017-01-14T21:31:33", "json_metadata" => "",
     "active_challenged" => false, "new_average_bandwidth" => "6733326000",
     "vesting_balance" => "0.000 STEEM",
     "last_vote_time" => "2017-02-06T03:22:39", "post_history" => [],
     "blog_category" => %{}, "market_history" => [], "id" => 496,
     "vesting_shares" => "9835900508.693966 VESTS", "vote_history" => [],
     "reset_account" => "null", "sbd_balance" => "50.626 SBD",
     "last_post" => "2017-01-31T23:59:21", "lifetime_vote_count" => 0,
     "savings_sbd_last_interest_payment" => "1970-01-01T00:00:00",
     "mined" => false, "owner_challenged" => false,
     "vesting_withdraw_rate" => "0.000000 VESTS",
     "active" => %{"account_auths" => [],
       "key_auths" => [["STM7YtQZ7fwg7VE2U7wUPwdL2hWwtd3zR45XSPTk5dTirk7Mxud5z",
         1], ["STM7sw22HqsXbz7D2CmJfmMwt9rimtk518dRzsR1f8Cgw52dQR1pR", 1]],
       "weight_threshold" => 1}, "proxy" => "",
     "posting" => %{"account_auths" => [],
       "key_auths" => [["STM4yfYEjUoey4PLrKhnKFo1XKQZtZ77fWLnbGTr2mAUaSt2Sx9W4",
         1], ["STM7sw22HqsXbz7D2CmJfmMwt9rimtk518dRzsR1f8Cgw52dQR1pR", 1]],
       "weight_threshold" => 1}, "last_root_post" => "2016-07-27T15:44:03",
     "savings_balance" => "0.000 STEEM", "average_bandwidth" => 182717207,
     "last_account_recovery" => "1970-01-01T00:00:00",
     "next_vesting_withdrawal" => "1969-12-31T23:59:59", "can_vote" => true,
     "owner" => %{"account_auths" => [],
       "key_auths" => [["STM7H7yZfed2GqkgdLuYy3VVrmQLV4htbiu1WGouRHsjjD4Kq1MvQ",
         1], ["STM7sw22HqsXbz7D2CmJfmMwt9rimtk518dRzsR1f8Cgw52dQR1pR", 1]],
       "weight_threshold" => 1},
     "witness_votes" => ["abit", "arhag", "au1nethyb1", "bhuz", "bitcube",
      "blocktrades", "boatymcboatface", "charlieshrem", ...],
     "reputation" => "50203479326220", "post_count" => 236,
     "last_owner_proved" => "1970-01-01T00:00:00",
     "sbd_seconds_last_update" => "2017-01-21T09:27:12",
     "memo_key" => "STM7qtpUZfaHwyJk9ZwvXH3EsAxJcYWY4913Vj6xVWkskM8SRV2Ub",
     "new_average_market_bandwidth" => 2003955853, "name" => "dan",
     "withdrawn" => 0, ...},
   %{"recovery_account" => "steem", "guest_bloggers" => [],
     "posting_rewards" => 7480629, "created" => "2016-03-31T14:21:45",
     "last_bandwidth_update" => "2017-02-06T14:06:06", "to_withdraw" => 0,
     "last_active_proved" => "1970-01-01T00:00:00", "tags_usage" => [],
     "withdraw_routes" => 0, "last_account_update" => "2017-01-18T20:09:33",
     "sbd_last_interest_payment" => "2017-01-04T19:19:27",
     "json_metadata" => "{\"profile\":{\"profile_image\":\"https://pbs.twimg.com/profile_images/788308793675382784/qeMigCcx.jpg\",\"about\":\"Building on the Steem blockchain. CEO @steemit\",\"location\":\"A vision in  a dream.\",\"name\":\"ned\"}}",
     "active_challenged" => false, "new_average_bandwidth" => "170721511985",
     "vesting_balance" => "0.000 STEEM",
     "last_vote_time" => "2017-02-06T14:06:06", "post_history" => [],
     "blog_category" => %{}, "market_history" => [], "id" => 497,
     "vesting_shares" => "11920950909.517074 VESTS", "vote_history" => [],
     "reset_account" => "null", "sbd_balance" => "1004.474 SBD",
     "last_post" => "2017-02-03T21:32:42", "lifetime_vote_count" => 0,
     "savings_sbd_last_interest_payment" => "2017-01-01T19:19:27",
     "mined" => false, "owner_challenged" => false,
     "vesting_withdraw_rate" => "0.000000 VESTS",
     "active" => %{"account_auths" => [],
       "key_auths" => [["STM6NtAaJVX8Bk85jiphbrDk7swJRFdGGsqCuQtmajDvLFa6aXXjo",
         1]], "weight_threshold" => 1}, "proxy" => "",
     "posting" => %{"account_auths" => [],
       "key_auths" => [["STM6DXAK93uhbvAGKQaSGJG8QGCDyXxbS3GFFMHzqFw743XuUKUn7",
         1]], "weight_threshold" => 1}, "last_root_post" => "2017-01-29T05:46:57",
     "savings_balance" => "45555.000 STEEM", "average_bandwidth" => 148515414,
     "last_account_recovery" => "1970-01-01T00:00:00",
     "next_vesting_withdrawal" => "1969-12-31T23:59:59", "can_vote" => true,
     "owner" => %{"account_auths" => [],
       "key_auths" => [["STM88VeCav3dFi82QRfojbHjB78H7sj9e8SaymGg5gYw6nvzwgKy8",
         1]], "weight_threshold" => 1},
     "witness_votes" => ["aizensou", "anyx", "bacchist", "bitcoiner",
      "busy.witness", "chainsquad.com", "charlieshrem", "dragosroua", ...],
     "reputation" => "23004921512286", "post_count" => 449,
     "last_owner_proved" => "1970-01-01T00:00:00",
     "sbd_seconds_last_update" => "2017-01-30T15:32:00",
     "memo_key" => "STM5Wq24M2wbU9TJgcG9BLVtjVSmeQNX4hnivRBEubFHya5UrqUEH",
     "new_average_market_bandwidth" => "5789473524", "name" => "ned",
     "withdrawn" => 0, ...}]
  ```
  """
  @spec get_accounts([String.t]) :: [map]
  def get_accounts(accounts) do
    call("get_accounts", [accounts])
  end

  @doc"""
  Returns block header data. Accepts block height.

  Example response:
  ```
  %{"extensions" => [], "previous" => "0000000000000000000000000000000000000000",
    "timestamp" => "2016-03-24T16:05:00",
    "transaction_merkle_root" => "0000000000000000000000000000000000000000",
    "witness" => "initminer"}
  ```
  """
  @spec get_block_header(pos_integer) :: map
  def get_block_header(height) do
    call("get_block_header", [height])
  end

  @doc"""
  Unsurprisingly returns a map with dynamic global propeties.
  Example response:

  ```
  %{"average_block_size" => 1128, "confidential_sbd_supply" => "0.000 SBD",
    "confidential_supply" => "0.000 STEEM", "current_aslot" => 9185881,
    "current_reserve_ratio" => 20000, "current_sbd_supply" => "1127800.928 SBD",
    "current_supply" => "242006827.315 STEEM", "current_witness" => "blocktrades",
    "head_block_id" => "008b5de5311d81de95d99b81d5d42399e029964f",
    "head_block_number" => 9133541, "id" => 0,
    "last_irreversible_block_num" => 9133517,
    "max_virtual_bandwidth" => "5986734968066277376",
    "maximum_block_size" => 65536, "num_pow_witnesses" => 172,
    "participation_count" => 128,
    "recent_slots_filled" => "340282366920938463463374607431768211455",
    "sbd_interest_rate" => 300, "sbd_print_rate" => 7166,
    "time" => "2017-02-06T14:54:03", "total_pow" => 437187,
    "total_reward_fund_steem" => "57923.397 STEEM",
    "total_reward_shares2" => "1214871589134524977954294837379",
    "total_vesting_fund_steem" => "204618201.470 STEEM",
    "total_vesting_shares" => "426476786270.109616 VESTS",
    "virtual_supply" => "249126070.673 STEEM", "vote_regeneration_per_day" => 40}
  ```
  """
  @spec get_dynamic_global_properties() :: map
  def get_dynamic_global_properties do
    call("get_dynamic_global_properties", [])
  end

  def get_chain_properties do
    call("get_chain_properties", [])
  end

  def get_feed_history do
    call("get_feed_history", [])
  end

  def get_current_median_history_price do
    call("get_current_median_history_price", [])
  end

  # ACCOUNTS
  def get_account_count() do
   call("get_account_count", [])
  end

  def get_account_history(name, from, limit) do
   call("get_account_history", [name, from, limit])
  end

  def lookup_accounts(lower_bound_name, limit) do
   call("lookup_accounts", [lower_bound_name,  limit])
  end

  def lookup_account_names(account_names) do
   call("lookup_account_names", [account_names])
  end


  # UTILITY
  defp call_db(method, params) do
    call( method, params)
  end
end
