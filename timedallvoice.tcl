set script "drizzt_allvoice"

namespace eval $script {
  unset ::script

  setudef flag allvoice
  bind join - * [namespace current]::avjoin

  bind evnt - prerehash [namespace current]::uninstall

  proc uninstall {args} {
    foreach bind [binds [namespace current]::*] {
      lassign $bind type flags command hits binding

      unbind $type $flags $command $binding
    }
    namespace delete [namespace current]
  }

  proc autovoice {nick chan} {
    if {[botisop $chan] && ![isvoice $nick $chan]} {
      pushmode $chan +v $nick
    }
  }

  proc avjoin {nick uhost hand chan} {
    if {![isbotnick $nick] && [channel get $chan allvoice] && [botisop $chan]} {
      utimer 2 [list [namespace current]::autovoice $nick $chan]
    }
  }
}

putlog "Loaded timedallvoice.tcl by drizzt"
