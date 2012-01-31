def cfc_search(query)
  return Chef::Search::Query.new.search(:node, query).first
end

#return the ipaddress for the given role name (e.g. "hub", "db", "dmz")
def cfc_role_address(name)
  #defined in roles/{prod,qa}/cfc-env.rb
  if entry = node[:cfc][:hosts][name]
    return entry[:ipaddress]
  end

  #fallback to role based search
  role_node = cfc_search("role:cfc-#{name}").first
  if role_node
    return role_node.ipaddress
  end

  #worstcase, depend on dns
  return name
end

def cfc_profile_host
  if entry = node[:cfc][:hosts]["profile"]
    return entry[:ipaddress]
  end

  cfc_role_address("dmz") #should only reach in local env
end

def cfc_hudson_url
  hudson_url = URI.parse(node.cfc.hudson_url)
  if node.cfc.artifacts[:http_user]
    hudson_url.userinfo = node.cfc.artifacts.http_user + ":" + node.cfc.artifacts.http_password
  end
  hudson_url
end
