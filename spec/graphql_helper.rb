# frozen_string_literal: true
require_relative "../app/graphql/sample_app2_schema"

def execute_graphql_test
  SampleApp2Schema.execute(
    query_string,
    context: context,
    variables: variables,
  )
end

def execute_graphql_test_custom(query_string, context, variables)
  SampleApp2Schema.execute(
    query_string,
    context: context,
    variables: variables,
  )
end

# helper for testing results quicker
# takes the result of graphql and digs into
# 'data', query_name (if defined), and then parameters
def data_dig(*nodes)
  dig_through(result, *nodes)
end

def data_ids
  data_dig("data").collect { |n| n["id"] }
end

def dig_through(result, *nodes)
  return nil if result.nil?
  dig_for = ["data"]
  dig_for << query_name if defined?(query_name)
  dig_for += nodes
  result.dig(*dig_for)
end

def count_records(result)
  res = dig_through(result)
  return 0 unless res
  return res&.length if res.is_a? Array
  return res["data"]&.length if res.key?("data")
  0
end

def dig_through_ids(result)
  return nil if result.nil?
  results = dig_through(result)
  return results.collect { |n| n["id"] } if results.instance_of?(Array)
  return results["data"].collect { |n| n["id"] } if results.instance_of?(Hash) && results.key?("data")
  return results["edges"].collect { |edge| edge["node"]["id"] } if results.instance_of?(Hash) && results.key?("edges")
  [results["id"]]
end
