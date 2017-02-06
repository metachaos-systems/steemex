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

  def get_accounts(accounts) do
    accounts = List.wrap(accounts)
    call("get_accounts", [accounts])
  end

  def get_block_header(height) do
    call("get_block_header", [height])
  end

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
