
function sendCommand(cmd) {
  fetch('/run/' + cmd)
    .then(r => r.text())
    .then(t => document.getElementById('responseBox').textContent = t)
    .catch(() => document.getElementById('responseBox').textContent = "Erro ao executar.");
}
function toggleDND(state) {
  sendCommand(state ? "dnd_on" : "dnd_off");
}
