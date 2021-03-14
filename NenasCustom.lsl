/* This is a sample code for Nena :D */
float time = 0.3;

default{
    on_rez(integer Reboot){
        llResetScript();
    }
    state_entry(){
        llSetTimerEvent(time);
    }
    timer(){
        llSetColor(<llFrand(1.0),llFrand(1.0),llFrand(1.0)>,-1);
    }
}