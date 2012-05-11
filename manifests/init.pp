class tftp {
  include tftp::params
  include tftp::install
  include tftp::config
  include tftp::service
}
