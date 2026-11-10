#Requires AutoHotkey v2.0
#SingleInstance Force

; Richiede la tastiera US (non internazionale)

; ============================================================
; IMPOSTAZIONI GENERALI
; ============================================================

SendMode "Input"
SetWorkingDir A_ScriptDir


; ============================================================
; TASTI WINDOWS
; ============================================================

; Disabilita i due tasti Windows
;LWin::Return
;RWin::Return


; ============================================================
; CTRL + ALTGR
; ============================================================

; LCtrl + AltGr → AltGr
LControl & RAlt::Send "{RAlt}"


; ============================================================
; PARENTESI SU LAYOUT US
; ============================================================

[::SendText "("
]::SendText ")"

+[::SendText "{"
+]::SendText "}"

+9::SendText "["
+0::SendText "]"


; ============================================================
; COMPOSE KEY
; Menu → vocale → accento
;
; Menu → e → `  = è
; Menu → e → '  = é
; Menu → a → `  = à
; Menu → E → `  = È
; ============================================================

composeActive := false
composeLetter := ""


; ------------------------------------------------------------
; MENU = attiva Compose

AppsKey::
{
    global composeActive, composeLetter

    composeActive := true
    composeLetter := ""
}


; ------------------------------------------------------------
; Mentre Compose è attivo

#HotIf composeActive


; Vocali minuscole
a::SetComposeLetter("a")
e::SetComposeLetter("e")
i::SetComposeLetter("i")
o::SetComposeLetter("o")
u::SetComposeLetter("u")


; Vocali maiuscole
+a::SetComposeLetter("A")
+e::SetComposeLetter("E")
+i::SetComposeLetter("I")
+o::SetComposeLetter("O")
+u::SetComposeLetter("U")


; Accento grave
`::SetComposeAccent("grave")


; Accento acuto
'::SetComposeAccent("acute")


; ESC annulla Compose
Escape::
{
    global composeActive, composeLetter

    composeActive := false
    composeLetter := ""
}


#HotIf


; ------------------------------------------------------------
; FUNZIONI COMPOSE

SetComposeLetter(letter)
{
    global composeActive, composeLetter

    composeLetter := letter
}


SetComposeAccent(accent)
{
    global composeActive, composeLetter

    if (composeLetter = "")
    {
        composeActive := false
        return
    }

    if (accent = "grave")
    {
        chars := Map(
            "a", "à",
            "e", "è",
            "i", "ì",
            "o", "ò",
            "u", "ù",

            "A", "À",
            "E", "È",
            "I", "Ì",
            "O", "Ò",
            "U", "Ù"
        )
    }
    else
    {
        chars := Map(
            "a", "á",
            "e", "é",
            "i", "í",
            "o", "ó",
            "u", "ú",

            "A", "Á",
            "E", "É",
            "I", "Í",
            "O", "Ó",
            "U", "Ú"
        )
    }

    if chars.Has(composeLetter)
        SendText chars[composeLetter]

    composeActive := false
    composeLetter := ""
}


; ============================================================
; ALTRE SCORCIATOIE
; ============================================================

; Per chiudere la connessione su telnet
; Ctrl + 0 → Ctrl + ]
^0::Send "^]"

; Alt + - -> ~
!-::SendText "~"
; Alt + = -> `
!=::SendText "``"

#[::up
#/::down
#;::left
#'::right

^;::
{
    Send "^{Left}"
}

^'::
{
    Send "^{Right}"
}

^+;::
{
    Send "^+{Left}"
}

^+'::
{
    Send "^+{Right}"
}

^+(::
{
    Send "+{Up}"
}

^+/::
{
    Send "+{Down}"
}

; Win sinistro + Backspace → Delete
<#Backspace::Send "{Delete}"

; Win sinistro + Ctrl + Backspace → Ctrl + Delete
<#^Backspace::Send "^{Delete}"

; Ctrl + [ → Home
^[::
{
    Send "{Home}"
}

; Ctrl + / → End
^/::
{
    Send "{End}"
}

; Ctrl + Alt + [ → Ctrl + Home
^![::
{
    Send "^{Home}"
}

; Ctrl + Alt + / → Ctrl + End
^!/::
{
    Send "^{End}"
}


; ============================================================
; Per la mia tastiera Trust
; ============================================================

; Browser Home → Esc
Browser_Home::Escape

; ` → Caps Lock
;`::CapsLock

; Shift + ` → :
;+`:::


; ============================================================
; CAMBIO TAB
; ============================================================

; Freccia destra → Ctrl + Tab
Right::Send "^{Tab}"

; Freccia sinistra → Ctrl + Shift + Tab
Left::Send "^+{Tab}"

; Freccia su → Ctrl destro
Up::RControl


; ============================================================
; Per VMWARE
; ============================================================

SetTitleMatchMode 2

#HotIf WinActive("VMware")

LWin & LAlt::
{
    Click
}

#HotIf


; ============================================================
; ESC -> CAPS LOCK
; CAPS LOCK → CTRL
; CAPS LOCK DA SOLO → ESC
; ============================================================

Esc::CapsLock

*CapsLock::
{
    Send "{Blind}{LControl down}"
}

*CapsLock up::
{
    Send "{Blind}{LControl up}"

    ; Se CapsLock è stato premuto e rilasciato
    ; senza premere altri tasti → Esc
    if A_PriorKey = "CapsLock"
        Send "{Esc}"
}


; ============================================================
; CAPS LOCK REALE
; ============================================================

; Se in futuro vuoi riattivare CapsLock tramite una hotkey,
; puoi usare questa funzione che fa un toggling di capslock
; es: key::ToggleCaps()

ToggleCaps()
{
    SetStoreCapsLockMode false
    Send "{CapsLock}"
    SetStoreCapsLockMode true
}
