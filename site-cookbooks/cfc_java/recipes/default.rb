unless platform?(%w{oracleserver})
  include_recipe "java"
end
