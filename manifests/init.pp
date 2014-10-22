class core {
  
    exec { "apt-update":
      command => "/usr/bin/sudo apt-get -y update"
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

class pythonxml {
	package {
		["libxml2-dev", "libxslt1-dev"]: 
		ensure => ["installed"],
        require => Exec['apt-update'] 
	}

	exec {
		"lxml":
		command => "/usr/bin/sudo pip install lxml",
		require => Package["libxml2-dev", "libxslt1-dev"],
	}
}

include core
include python
include pythonxml
include saxonb
include install_xerces



