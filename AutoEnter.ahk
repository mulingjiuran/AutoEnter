#Requires AutoHotkey v2.0
;using "alt+W" write and using "ESC" quit
;using UTF-8

global over:=true
global id:=0

Esc::{
    over:=false
    ExitApp
}

!w::{
    global id
    MouseGetPos , , &id, &control,2
    ToolTip "ahk_id " id "`nahk_class " WinGetClass(id) "`n" WinGetTitle(id) "`nControl: " control
    SetTimer () => ToolTip(), -3000
    ControlSendText  "123", , "ahk_id " id
    file := FileSelect(3, , "Open a file")

    MyGui := Gui(,"设置")
    MyGui.Opt("+Resize +MinSize210x100")
    MyGui.Add("Text", "x10 y10", "输入间隔延时(毫秒):")
    MyGui.Add("Edit", "x10 y30 w100")
    MyGui.Add("UpDown", "vMyUpDown Range1-10000", 1)
    MyBtn := MyGui.Add("Button", "Default x10 y60 w60 h25", "确定")
    MyGui.Add("Text", "x130 y75 c0x808080", "仅支持UTF-8")
    MyBtn.OnEvent("Click", MyBtn_Click)

    if file =  ""
        MyGui.Destroy()
    else
        MyGui.Show()

    MyBtn_Click(*){
        global id
        obj := MyGui.Submit()
        text := FileRead(file, "UTF-8")
        switchIMEbyID(134481924)
        SetKeyDelay obj.MyUpDown
        SendCode(text, obj.MyUpDown)
        return
    }
}

switchIMEbyID(IMEID){
    winTitle:=WinGetTitle("A")
    PostMessage(0x50, 0, IMEID,, WinTitle )
}

SendCode(text,rate){
    Loop parse, text, "`n" , "`r"
    {
        if (!over)
            break
        DeleteThisLine(rate)
        ControlSendText A_LoopField, , "ahk_id " id
    }
}

DeleteThisLine(rate){
    ControlSend "{Enter}", , "ahk_id " id
    ControlSend "{Tab}", , "ahk_id " id
    ControlSend "{Home}", , "ahk_id " id
    ControlSend "{Shift down}{End}{Shift up}", , "ahk_id " id
    ControlSend "{Backspace}", , "ahk_id " id  
}