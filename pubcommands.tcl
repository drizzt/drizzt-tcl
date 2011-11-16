set script "drizzt_commands"

namespace eval $script {
  unset ::script

  bind pub o|o !ban     [namespace current]::pub:ban
  bind pub o|o !unban   [namespace current]::pub:unban
  bind pub o|o !opme    [namespace current]::pub:opme
  bind pub o|o !op      [namespace current]::pub:op
  bind pub o|o !deopme  [namespace current]::pub:deopme
  bind pub o|o !deop    [namespace current]::pub:deop
  bind pub o|o !kick    [namespace current]::pub:kick
  bind pub o|o !voice   [namespace current]::pub:voice
  bind pub o|o !devoice [namespace current]::pub:devoice

  bind evnt - prerehash [namespace current]::uninstall

  proc uninstall {args} {
    foreach bind [binds [namespace current]::*] {
      lassign $bind type flags command hits binding

      unbind $type $flags $command $binding
    }
    namespace delete [namespace current]
  }

  proc changemode { chan mode nicks } {
    foreach whom $nicks {
      if {![isbotnick $whom]} {
        pushmode $chan $mode $whom
      }
    }
  }

  proc pub:ban { nick uhost hand chan text } {
    set whom [lindex $text 0]
    set reason [lrange $text 1 end]
    set banmask *!*@[lindex [split [getchanhost $whom $chan] @] 1]
    newchanban $chan $banmask $nick $reason
  }

  proc pub:unban { nick uhost hand chan text } {
    foreach whom $text {
      killchanban $chan $whom
    }
  }

  proc pub:op { nick uhost hand chan text } {
    changemode $chan +o $text
  }

  proc pub:opme { nick uhost hand chan text } {
    pushmode $chan +o $nick
  }

  proc pub:deop { nick uhost hand chan text } {
    changemode $chan -o $text
  }

  proc pub:deopme { nick uhost hand chan text } {
    pushmode $chan -o $nick
  }

  proc pub:kick { nick uhost hand chan text } {
    set whom [lindex $text 0]
    set reason [lrange $text 1 end]

    putkick $chan $whom $reason
  }

  proc pub:voice { nick uhost hand chan text } {
    changemode $chan +v $text
  }

  proc pub:devoice { nick uhost hand chan text } {
    changemode $chan -v $text
  }
}

putlog "Loaded pubcommands.tcl by drizzt"
