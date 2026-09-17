# Cloudflare Tunnels - Configuración Automática

**Sistema de acceso remoto permanente sin VPN**

---

## 🎯 URLs de Acceso

### **Open WebUI (Usuario):**
Accesible desde cualquier lugar del mundo (iPhone, laptop, etc.):

```bash
# Ver URL actual
cat ~/cloudflare-tunnels/openwebui-url.txt

# O ejecutar
~/cloudflare-tunnels/ver-urls.sh
```

**URL Ejemplo:** `https://legs-examined-identifies-dans.trycloudflare.com`

---

### **SSH (Agente/Desarrollo):**
Para configuraciones y desarrollo remoto:

```bash
# Ver URL actual
cat ~/cloudflare-tunnels/ssh-url.txt
```

**URL Ejemplo:** `https://sisters-women-administration-eng.trycloudflare.com`

---

## ✅ Características

| Característica | Estado |
|----------------|--------|
| **Auto-inicio** | ✅ Inicia con la Mac |
| **Sin terminales** | ✅ No necesita ventanas abiertas |
| **Acceso global** | ✅ Funciona desde China y cualquier lugar |
| **Sin VPN** | ✅ No necesita Tailscale |
| **Open WebUI** | ✅ Puerto 3000 expuesto |
| **SSH** | ✅ Puerto 22 expuesto |

---

## 📂 Archivos Instalados

```
~/cloudflare-tunnels/
├── start-openwebui-tunnel.sh         # Script Open WebUI
├── start-ssh-tunnel.sh                # Script SSH
├── ver-urls.sh                        # Ver URLs actuales ⭐
├── openwebui-url.txt                  # URL de Open WebUI
├── ssh-url.txt                        # URL de SSH
├── openwebui-tunnel.log               # Log Open WebUI
├── ssh-tunnel.log                     # Log SSH
└── README.md                          # Documentación

~/Library/LaunchAgents/
├── com.cloudflare.tunnel.openwebui.plist   # Servicio Open WebUI
└── com.cloudflare.tunnel.ssh.plist         # Servicio SSH
```

---

## 🚀 Uso Diario

### **Desde iPhone/China:**

1. Abrir Safari
2. Ejecutar en Mac (o guardar la URL):
   ```bash
   ~/cloudflare-tunnels/ver-urls.sh
   ```
3. Copiar URL de Open WebUI
4. Abrir en Safari
5. ¡Listo! Acceso completo al sistema

---

### **Para Desarrollo (Agente):**

El agente puede conectarse automáticamente usando:

```bash
# Obtener URL SSH actual
ssh pcia@mac "cat ~/cloudflare-tunnels/ssh-url.txt"

# Conectarse
ssh -o ProxyCommand="cloudflared access tcp --hostname <URL>" pcia@localhost
```

---

## ⚠️ Importante: URLs Dinámicas

**Las URLs cambian cada vez que reinicia la Mac.**

### **Después de Reiniciar:**

1. Esperar 30 segundos (servicios iniciando)
2. Ejecutar:
   ```bash
   ~/cloudflare-tunnels/ver-urls.sh
   ```
3. Usar las nuevas URLs

---

## 📋 Comandos Útiles

### **Ver URLs Actuales:**
```bash
~/cloudflare-tunnels/ver-urls.sh
```

### **Ver Logs:**
```bash
# Open WebUI
tail -f ~/cloudflare-tunnels/openwebui-tunnel.log

# SSH
tail -f ~/cloudflare-tunnels/ssh-tunnel.log
```

### **Reiniciar Servicios:**
```bash
# Ambos servicios
launchctl unload ~/Library/LaunchAgents/com.cloudflare.tunnel.*.plist
launchctl load ~/Library/LaunchAgents/com.cloudflare.tunnel.*.plist
```

### **Ver Estado:**
```bash
launchctl list | grep com.cloudflare.tunnel
```

### **Detener:**
```bash
launchctl unload ~/Library/LaunchAgents/com.cloudflare.tunnel.*.plist
```

---

## 🔧 Solución de Problemas

### **No hay URLs en los archivos:**

```bash
# Ver logs para diagnosticar
tail -50 ~/cloudflare-tunnels/*.log

# Reiniciar servicios
launchctl unload ~/Library/LaunchAgents/com.cloudflare.tunnel.*.plist
sleep 2
launchctl load ~/Library/LaunchAgents/com.cloudflare.tunnel.*.plist

# Esperar 30 segundos
sleep 30
~/cloudflare-tunnels/ver-urls.sh
```

---

### **Servicio no inicia:**

```bash
# Ver si está cargado
launchctl list | grep cloudflare

# Ver logs de error
cat ~/cloudflare-tunnels/*-stderr.log

# Verificar que cloudflared esté instalado
which cloudflared
```

---

### **URL no funciona:**

```bash
# Verificar que el servicio esté corriendo
lsof -i :3000  # Open WebUI
lsof -i :22    # SSH

# Verificar URL actual
~/cloudflare-tunnels/ver-urls.sh

# Probar acceso local primero
curl http://localhost:3000
```

---

## 💡 Ventajas vs Tailscale

| Aspecto | Tailscale | Cloudflare Tunnel |
|---------|-----------|-------------------|
| Configuración | Compleja | Simple |
| Acceso desde China | ⚠️ Puede bloquearse | ✅ Funciona |
| Dispositivos | Necesita app | Solo navegador |
| Estabilidad | Depende de relay | Excelente |
| Firewall | Problemas comunes | Sin problemas |

---

## 🎯 Sistema Completo

Con esta configuración tienes:

- ✅ **Open WebUI:** Accesible globalmente
- ✅ **SSH:** Para desarrollo y configuraciones
- ✅ **Auto-inicio:** No necesitas hacer nada
- ✅ **Sin mantenimiento:** Todo automático
- ✅ **Documentos accesibles:** Base de conocimientos funcional
- ✅ **Sistema de análisis:** Completo y operacional

---

## 📞 Soporte

Para ver toda la documentación del sistema:

- `~/analisis-documentos-ia/` - Sistema de análisis
- `~/open-webui-app/` - Open WebUI
- `~/cloudflare-tunnels/` - Tunnels (esta configuración)

---

*Configurado: 8 de Septiembre de 2026*  
*Ubicación Mac: Colombia*  
*Usuario: China*
