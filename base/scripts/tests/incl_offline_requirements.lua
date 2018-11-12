-- Required scripts for offline unit testing (no running server)

package.path = ";../?.lua" .. package.path

require('incl_compat')
require('incl_cs_stubs')
require('globals.globals')
