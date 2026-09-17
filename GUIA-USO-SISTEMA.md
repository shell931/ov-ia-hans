# Guía de Uso - Sistema de Análisis Inteligente de Documentos

**Fecha:** 8 de Septiembre de 2026  
**Mac:** M5 Pro, 64GB RAM  
**Estado:** ✅ Operacional y Auto-inicio configurado

---

## 🚀 Inicio Automático

Al encender el Mac, el sistema inicia automáticamente:

1. **Ollama** (motor de IA) - ~15 segundos
2. **Open WebUI** (interfaz web) - ~30 segundos

**URL de acceso:** http://localhost:3000

---

## 🌐 Acceso a la Interfaz

### Primera vez:

1. Abrir navegador (Safari, Chrome, etc.)
2. Ir a: `http://localhost:3000`
3. **Crear cuenta** (registro local, primera vez)
   - Usuario: [tu elección]
   - Email: [tu elección]
   - Contraseña: [tu elección]
4. ¡Listo para usar!

### Usos posteriores:

1. Abrir: `http://localhost:3000`
2. Iniciar sesión con tus credenciales

---

## 💡 Funcionalidades Disponibles

### 1. Chat con IA (Llama 3.1 70B)

- Modelo instalado: **Llama 3.1 70B** (42GB)
- Idioma: **Español** (configurado)
- Calidad: Excelente para análisis profundo
- Velocidad: ~1-3 minutos por respuesta compleja

### 2. Análisis de Documentos

**Keywords soportadas:**
- kit
- Preconteo
- Escrutinio
- E14
- E11
- Plan de comunicaciones
- Infraestructura tecnología
- Requerimientos tecnología

**Tipos de archivo:** PDF, DOCX (próximamente)

### 3. Comparación de Documentos

**Dos frentes de análisis:**

**A) Comparación Uno a Uno:**
- Diff línea por línea
- Cambios palabra por palabra
- Ubicación exacta de modificaciones

**B) Análisis Analítico:**
- Impacto de los cambios (Alto/Medio/Bajo)
- Recomendaciones
- Resumen ejecutivo
- Riesgos y oportunidades

---

## 📂 Estructura del Sistema

### En el Mac:

```
~/analisis-documentos-ia/          # Backend Python
├── venv/                           # Entorno virtual
├── test_sistema.py                 # Script de pruebas
└── [futuro código del sistema]

~/open-webui-app/                   # Frontend
├── venv/                           # Entorno virtual Python 3.11
├── start-openwebui.sh             # Script de inicio
├── stdout.log                      # Logs de salida
├── stderr.log                      # Logs de errores
└── .webui_secret_key              # Clave secreta

~/Library/LaunchAgents/             # Servicios auto-inicio
├── sh.brew.ollama.plist           # Ollama
└── com.openwebui.service.plist    # Open WebUI
```

---

## 🛠️ Comandos Útiles

### Ver Estado de Servicios

```bash
# Ver servicios activos
brew services list

# Ver estado de Open WebUI
launchctl list | grep openwebui

# Ver puertos en uso
lsof -i :3000  # Open WebUI
lsof -i :11434 # Ollama
```

### Ver Logs

```bash
# Logs de Open WebUI
tail -f ~/open-webui-app/stdout.log

# Logs de errores
tail -f ~/open-webui-app/stderr.log
```

### Reiniciar Servicios (si necesario)

```bash
# Reiniciar Ollama
brew services restart ollama

# Reiniciar Open WebUI
launchctl unload ~/Library/LaunchAgents/com.openwebui.service.plist
launchctl load ~/Library/LaunchAgents/com.openwebui.service.plist
```

### Detener Servicios (si necesario)

```bash
# Detener Ollama
brew services stop ollama

# Detener Open WebUI
launchctl unload ~/Library/LaunchAgents/com.openwebui.service.plist
```

---

## 🐍 Desarrollo (Backend)

### Activar entorno Python

```bash
cd ~/analisis-documentos-ia
source venv/bin/activate
```

### Ejecutar scripts

```bash
python mi_script.py
```

### Probar conexión con Ollama

```bash
python test_sistema.py
```

---

## 📦 Stack Tecnológico Instalado

### IA / Modelos

```yaml
Ollama: 0.33.3
Llama 3.1 8B: 4.9 GB (desarrollo)
Llama 3.1 70B: 42 GB (producción) ✓
```

### Backend Python

```yaml
Python: 3.14.7
DocLing: 2.126.0 (procesamiento de documentos)
LangChain: 1.4.0 (orquestación)
Pandas: 3.0.5 (manejo de tablas)
PyMuPDF: instalado (lector PDF backup)
spaCy: instalado (NLP)
```

### Frontend

```yaml
Open WebUI: 0.9.6
Python: 3.11.16
Puerto: 3000
```

---

## ⚠️ Resolución de Problemas

### Open WebUI no carga

1. Verificar que Ollama esté corriendo:
   ```bash
   brew services list | grep ollama
   ```

2. Ver logs de Open WebUI:
   ```bash
   tail -50 ~/open-webui-app/stderr.log
   ```

3. Reiniciar Open WebUI:
   ```bash
   launchctl unload ~/Library/LaunchAgents/com.openwebui.service.plist
   launchctl load ~/Library/LaunchAgents/com.openwebui.service.plist
   ```

### Modelo responde lento

- **Normal:** Llama 70B toma 1-3 minutos para análisis complejo
- **Razón:** Es un modelo grande (42GB) que analiza profundamente
- **Alternativa rápida:** Usar Llama 8B para pruebas (se puede cambiar en Open WebUI)

### Error de conexión

1. Verificar puertos:
   ```bash
   lsof -i :3000   # Open WebUI
   lsof -i :11434  # Ollama
   ```

2. Reiniciar Mac (todo debería auto-iniciarse)

---

## 📞 Próximos Pasos

### Fase 4: Desarrollo del Sistema Core (SIGUIENTE)

- [ ] Módulo de extracción con DocLing
- [ ] Detector de capítulos por keywords
- [ ] Sistema de comparación (dos frentes)
- [ ] Integración completa con Open WebUI

### Uso Actual

Mientras se desarrolla el sistema completo, Open WebUI ya puede:
- ✅ Chatear con Llama 70B en español
- ✅ Hacer preguntas generales
- ✅ Análisis de texto (copiar/pegar)
- ⏳ Subir documentos (funcionalidad base de Open WebUI)

---

## 🎯 Resumen

**Sistema operacional:** ✅  
**Auto-inicio configurado:** ✅  
**Modelo 70B activo:** ✅  
**Interfaz funcionando:** ✅  
**URL:** http://localhost:3000

**Todo listo para usar y desarrollar.** 🚀

---

*Última actualización: 2026-09-08 09:20 UTC*
