name 'rbenv'
maintainer 'The Authors'
maintainer_email 'you@example.com'
license 'All Rights Reserved'
description 'Installs/Configures rbenv'
long_description 'Installs/Configures rbenv'
version '0.1.0'
chef_version '>= 12.1' if respond_to?(:chef_version)
depends 'ruby_rbenv', '~> 2.0.4'
