def c2c_search(query)
  return Chef::Search::Query.new.search(:node, query).first
end

#return the ipaddress for the given role name (e.g. "hub", "db", "dmz")
def c2c_role_address(name)
  #defined in roles/{prod,qa}/c2c-env.rb
  if entry = node[:c2c][:hosts][name]
    return entry[:ipaddress]
  end

  #fallback to role based search
  role_node = c2c_search("role:c2c-#{name}").first
  if role_node
    return role_node.ipaddress
  end

  #worstcase, depend on dns
  return name
end

def c2c_profile_host
  if entry = node[:c2c][:hosts]["profile"]
    return entry[:ipaddress]
  end

  c2c_role_address("dmz") #should only reach in local env
end

def c2c_hudson_url
  hudson_url = URI.parse(node.c2c.hudson_url)
  if node.c2c.artifacts[:http_user]
    hudson_url.userinfo = node.c2c.artifacts.http_user + ":" + node.c2c.artifacts.http_password
  end
  hudson_url
end
