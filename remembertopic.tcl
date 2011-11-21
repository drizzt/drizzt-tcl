set script "drizzt_remembertopic"

namespace eval $script {
  unset ::script
  bind join - * [namespace current]::join:remembertopic

  bind evnt - prerehash [namespace current]::uninstall

  proc uninstall {args} {
    foreach bind [binds [namespace current]::*] {
      lassign $bind type flags command hits binding

      unbind $type $flags $command $binding
    }
    namespace delete [namespace current]
  }

  proc join:remembertopic {nick uhost hand chan} {
    putnotc $nick [topic $chan]    
  }
}

putlog "Loaded remembertopic.tcl by drizzt"
