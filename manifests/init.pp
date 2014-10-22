class core {
    package { 
      ["python-software-properties"]: 
      ensure => ["installed"]
    }

    exec { "apt-add":
      path => "/usr/bin:/bin",
      command => "sudo add-apt-repository ppa:ubuntugis/ppa",
      require => Package["python-software-properties"]
    }

    exec { "apt-add-update":
      command => "/usr/bin/sudo apt-get update -qq",
      require => Exec['apt-add']
    }
  
    exec { "apt-update":
      command => "/usr/bin/sudo apt-get -y update",
      require => Exec["apt-add-update"]
    }
  
    package { 
      [ "vim", "git-core", "build-essential"]:
        ensure => ["installed"],
        require => Exec['apt-update']    
    }
}

class python {

    package { 
      [ "python", "python-setuptools", "python-dev", "python-pip"]:
        ensure => ["installed"],
        require => Exec['apt-update']    
    }

    exec {
      "virtualenv":
      command => "/usr/bin/sudo pip install virtualenv",
      require => Package["python-dev", "python-pip"]
    }

    exec {
      "ipython":
      command => "/usr/bin/sudo pip install ipython",
      require => Package["python-dev", "python-pip"]
    }

    exec {
      "requests":
      command => "/usr/bin/sudo pip install requests",
      require => Package["python", "python-pip"],
    }

}

class geo {
  package { 
      [ "python-numpy", "libgdal1h", "gdal-bin", "libgdal-dev" ]:
        ensure => ["installed"],
        require => Package['python']    
    }
}

class fiona {
  exec {
    "fi":
    command => "/usr/bin/sudo pip install Fiona",
    require => Package["python", "python-pip", "gdal-bin"]
  }
}

class rasterio {
  exec {
    "reqs":
    command => "/usr/bin/sudo pip install -r https://raw.githubusercontent.com/mapbox/rasterio/master/requirements.txt",
    require => Package["python", "python-pip", "gdal-bin"]
  }

	exec {
		"rio":
		command => "/usr/bin/sudo pip install rasterio",
		require => [Package["python", "python-pip", "gdal-bin"], Exec["reqs"]]
	}
}

include core
include python
include geo
include fiona
include rasterio



