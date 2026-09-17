# 🤖 IA Hans - Sistema de Análisis Inteligente de Documentos

Sistema RAG (Retrieval Augmented Generation) para análisis y comparación de documentos con detección inteligente de capítulos y keywords.

## 🎯 Objetivo

Crear un sistema que lea, analice y compare documentos identificando capítulos específicos mediante keywords, NO solo buscando texto literal.

## 📋 Funcionalidades

### ✅ Implementadas

1. **Base de Conocimientos RAG**
   - Carga de documentos (PDF, DOCX, TXT)
   - Búsqueda semántica
   - Integración con Open WebUI

2. **Detección de Capítulos por Keywords**
   - kit
   - Preconteo
   - Escrutinio
   - E14 / E11
   - Plan de comunicaciones
   - Infraestructura tecnología
   - Requerimientos tecnología

3. **Comparación de Documentos**
   - Análisis entre múltiples documentos
   - Detección de diferencias
   - Tablas comparativas

4. **Cloudflare Tunnel**
   - Acceso remoto seguro
   - Auto-start en boot

## 📁 Estructura

```
ia-hans/
├── GUIA-BASE-CONOCIMIENTOS.md          ← RAG / Open WebUI
├── GUIA-COMPARACION-TABLAS.md          ← Análisis comparativo
├── GUIA-USO-COMPLETA.md                ← Guía completa del sistema
├── GUIA-USO-SISTEMA.md                 ← Guía básica
├── PLAN-SISTEMA-ANALISIS-DOCUMENTOS.md ← Arquitectura y plan
└── CONFIGURACION-CLOUDFLARE-TUNNEL.md  ← Setup de túnel
```

## 🔧 Tecnologías

- **LLM**: Modelos configurables (Qwen, LLaMA, etc.)
- **Vector DB**: Qdrant / ChromaDB
- **Interface**: Open WebUI
- **Tunnel**: Cloudflare
- **Deploy**: Docker Compose

## 📖 Guías Disponibles

| Guía | Descripción |
|------|-------------|
| [Base de Conocimientos](GUIA-BASE-CONOCIMIENTOS.md) | Cómo usar RAG y cargar documentos |
| [Comparación de Tablas](GUIA-COMPARACION-TABLAS.md) | Análisis comparativo de documentos |
| [Uso Completo](GUIA-USO-COMPLETA.md) | Guía detallada del sistema |
| [Uso Sistema](GUIA-USO-SISTEMA.md) | Guía rápida para usuarios |
| [Plan del Sistema](PLAN-SISTEMA-ANALISIS-DOCUMENTOS.md) | Arquitectura completa |
| [Cloudflare Tunnel](CONFIGURACION-CLOUDFLARE-TUNNEL.md) | Setup de acceso remoto |

## 🚀 Quick Start

```bash
# Clonar repo
git clone https://github.com/shell931/ia-hans.git
cd ia-hans

# Ver guías específicas según tu necesidad
cat GUIA-USO-SISTEMA.md
```

---

**Última actualización**: Sep 17, 2026  
**Tipo**: Sistema RAG de análisis documental
