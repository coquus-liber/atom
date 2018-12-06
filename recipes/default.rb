# Cookbook:: atom
# Recipe:: default

apt_repository 'AtomEditor_atom' do
  arch         "amd64"
  distribution "any"
  components   %w(main)
  key          "https://packagecloud.io/AtomEditor/atom/gpgkey"
  uri          "https://packagecloud.io/AtomEditor/atom/any/"
end

apt_package 'atom'

# atom_proxy "http://proxy:80"

atom_package 'atom-beautify'
atom_package 'nuclide'
atom_package 'file-icons'
atom_package 'language-rspec'
atom_package 'tool-bar'

