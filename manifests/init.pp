class motd {
  $motd = '/etc/motd'

  concat { $motd:
    owner => 'root',
    group => '0',
    mode  => '0644'
  }

  concat::fragment{ 'motd_role_header':
    target  => $motd,
    content => "\nThis host is managed via Puppet, and has the following role:\n\n",
    order   => '01'
  }
  concat::fragment{ 'motd_site_header':
    target  => $motd,
    content => "\nThis host belongs to the site:\n",
    order   => '11'
  }
  concat::fragment{ 'motd_profile_header':
    target  => $motd,
    content => "\nThe following profiles belong to that role:\n\n",
    order   => '15'
  }
}

define motd::register_role($content="") {
  if $content == "" {
    $hostrole = $name
  } else {
    $hostrole = $content
  }

  concat::fragment{ "motd_role_fragment_$name":
    target  => '/etc/motd',
    order   => '10',
    content => "   -- $hostrole\n"
  }
}

define motd::register_site($content="") {
  if $content == "" {
    $sitename = $name
  } else {
    $sitename = $content
  }

  concat::fragment{ "motd_site_fragment_$name":
    target  => '/etc/motd',
    order   => '12',
    content => "   -- $sitename\n"
  }
}

define motd::register_profiles($profiles="") {
  concat::fragment{ "motd_profile_fragment_$name":
    target  => '/etc/motd',
    order   => '20',
    content => template("motd/profile.erb")
  }
}

define motd::register_accounts($accounts="") {
  concat::fragment{ "motd_accounts_fragment_$name":
    target  => '/etc/motd',
    order   => '40',
    content => template("motd/accounts.erb"),
  }
}

define motd::register_facilities($facilities="") {
  concat::fragment{ "motd_facilities_fragment_$name":
    target  => '/etc/motd',
    order   => '30',
    content => template("motd/facilities.erb"),
  }
}
