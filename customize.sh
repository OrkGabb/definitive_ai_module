#!/system/bin/sh

ui_print ""
ui_print "       DEFINITIVE.AI - Confirmação de Consentimento"
ui_print ""
ui_print " Deseja permitir o envio anônimo de dados para"
ui_print " aprimoramento da IA?"
ui_print ""
ui_print "  VOLUME+ = Aceitar"
ui_print "  VOLUME- = Recusar"
ui_print ""

choose_volume_key() {
  timeout 10 getevent -qlc 1 | grep -q KEY_VOLUMEUP && return 0
  timeout 10 getevent -qlc 1 | grep -q KEY_VOLUMEDOWN && return 1
  return 2
}

choose_volume_key
RESULT=$?

if [ "$RESULT" = "0" ]; then
  ui_print "Você ACEITOU o envio anônimo."
  touch /data/ai_user_consented
elif [ "$RESULT" = "1" ]; then
  ui_print "Você recusou o envio. Abortando instalação..."
  exit 1
else
  ui_print "Nenhuma tecla detectada. Abortando..."
  exit 1
fi
