# Plan: Sistema de Análisis Inteligente de Documentos

**Fecha:** 8 de Septiembre de 2026  
**Contexto:** Sistema para análisis y comparación de documentos con detección inteligente de capítulos

---

## 🎯 Objetivo Principal

Crear un sistema que lea, analice y compare documentos identificando capítulos específicos mediante keywords, NO solo buscando texto.

---

## 📋 Keywords (Filtros de Capítulos)

El sistema debe reconocer estos capítulos:

1. **kit**
2. **Preconteo**
3. **Escrutinio**
4. **E14**
5. **E11**
6. **Plan de comunicaciones**
7. **Infraestructura tecnología**
8. **Requerimientos tecnología**

**Nota crítica:** Cada keyword representa UN capítulo en el documento, aunque la palabra aparezca múltiples veces en el texto.

---

## 🔍 Problema Principal a Resolver

### Identificar CAPÍTULOS vs Menciones

**Ejemplo:**
- La keyword "E14" puede aparecer 50 veces en un documento
- Solo 1 vez es el **capítulo de E14** (título/sección principal)
- Las otras 49 son menciones/referencias

**Solución:** Análisis estructural + semántico usando:
- Jerarquía del documento (H1, H2, H3)
- Formato visual (negrita, tamaño)
- Contexto semántico
- Longitud del contenido siguiente

---

## 🏗️ Arquitectura del Sistema

### 1. Extracción Estructurada de Documentos

```
Documento PDF → DocLing → Estructura Jerárquica
```

**Componentes:**
- **DocLing**: Extracción estructurada principal
- **PyMuPDF**: Backup para PDFs complejos

**Extrae:**
- Títulos y encabezados (H1, H2, H3...)
- Tablas estructuradas (celda por celda)
- Jerarquía completa del documento
- Metadata (páginas, secciones)

### 2. Sistema de Detección de Capítulos

**Criterios para identificar un capítulo:**

1. ✅ Nivel de encabezado (H1, H2)
2. ✅ Formato especial (negrita, tamaño grande)
3. ✅ Posición en jerarquía del documento
4. ✅ Contexto semántico (introduciendo tema, no referenciando)
5. ✅ Longitud del contenido siguiente (capítulo tiene mucho contenido)

**NO es capítulo si:**
- Solo texto normal que menciona la keyword
- Referencia a otra sección
- Está en medio de un párrafo

### 3. Modelo de IA

**Modelos Recomendados (NO Qwen por riesgo de respuestas en chino):**

| Modelo | Ventajas | Tamaño | Uso |
|--------|----------|--------|-----|
| **Llama 3.1 70B** | Excelente español, análisis profundo | ~40GB | Principal |
| **Mistral 7B** | Rápido, bueno en español | ~4GB | Alternativo |
| **Phi-3 Medium** | Compacto, buen razonamiento | ~8GB | Alternativo |

**Configuración obligatoria:**
```python
system_prompt = """
Eres un asistente de análisis de documentos. 
Responde SIEMPRE en español.
Analiza documentos técnicos y comparaciones.
"""
```

---

## 📊 Requerimientos Funcionales

### A. Extracción de Información

**Entrada:** Documento + Keyword (ej: "E14")

**Proceso:**
1. DocLing extrae estructura completa
2. Sistema identifica el capítulo de la keyword
3. Extrae SOLO información del capítulo identificado
4. Ignora menciones de la keyword en otros capítulos

**Salida:** Contenido completo del capítulo incluyendo tablas

### B. Comparación de Documentos

**Entrada:** doc_v1.pdf + doc_v2.pdf + Keyword (opcional)

**Proceso:**

#### 1. Extracción de Capítulos
- Extraer capítulo de TODAS las keywords de ambos documentos
- Mantener estructura original
- Preservar tablas

#### 2. Comparación en DOS FRENTES

##### **FRENTE 1: Comparación Uno a Uno (Detallada)**

Comparación línea por línea, palabra por palabra:

- ✅ **Contenido igual**: Texto exactamente igual
- ⚠️ **Contenido modificado**: 
  - Mostrar diff línea por línea
  - Resaltar palabras cambiadas
  - Indicar posición exacta (página, párrafo)
- ➕ **Contenido nuevo en v2**: 
  - Texto completo agregado
  - Ubicación exacta
- ➖ **Contenido eliminado en v1**: 
  - Texto completo eliminado
  - Dónde estaba originalmente

**Formato de salida:**
```
Línea 45 (v1): "El procedimiento debe realizarse cada 24 horas"
Línea 45 (v2): "El procedimiento debe realizarse cada 12 horas"
                                                      ^^^^^^^^^^
Cambio: "24" → "12"
```

##### **FRENTE 2: Análisis Analítico (Alto Nivel)**

Análisis de impacto y contexto:

- 📊 **Impacto de los cambios**:
  - Alto / Medio / Bajo impacto
  - Áreas afectadas
  - Consecuencias operativas
  
- 🎯 **Gravedad de modificaciones**:
  - Crítico: Requiere acción inmediata
  - Importante: Requiere atención
  - Menor: Informativo

- 📋 **Resumen ejecutivo**:
  - Qué cambió en términos generales
  - Por qué es importante
  - Tendencias observadas

- 💡 **Recomendaciones**:
  - Acciones sugeridas
  - Riesgos a considerar
  - Siguientes pasos

#### 3. Comparación de Tablas

**Proceso celda por celda:**
```
Tabla v1:
| Campo | Valor |
|-------|-------|
| A     | 100   |
| B     | 200   |

Tabla v2:
| Campo | Valor |
|-------|-------|
| A     | 150   | ← MODIFICADO
| B     | 200   |
| C     | 300   | ← NUEVO

Resultado:
- Celda A: 100 → 150 (incremento +50%)
- Celda B: Sin cambios
- Celda C: Nueva fila añadida
```

### C. Comparación Completa de Documentos

**Entrada:** doc_v1.pdf + doc_v2.pdf (sin keyword específica)

**Proceso:**
1. Comparar TODOS los capítulos de todas las keywords
2. Comparar contenido general no clasificado
3. Resumen global de cambios
4. Análisis de impacto general

**Salida:**
- Reporte completo de diferencias
- Estadísticas (% de cambios, secciones afectadas)
- Visualización de cambios

---

## ⚙️ Stack Tecnológico

### Backend
```yaml
Lenguaje: Python 3.14+
Framework: FastAPI
Orquestación: LangChain
Procesamiento Docs: DocLing + PyMuPDF
```

### IA/ML
```yaml
Motor: Ollama
Modelo: Llama 3.1 70B (producción)
Modelo Rápido: Llama 3.1 8B (desarrollo)
Embeddings: sentence-transformers ✅ INSTALADO
Vector DB: ChromaDB ✅ INSTALADO
```

### Base de Conocimientos (RAG)
```yaml
Sistema: ChromaDB + sentence-transformers
Ubicación: ~/analisis-documentos-ia/knowledge_db/
Script: knowledge_base.py
Funcionalidad:
  - Subir documentos una sola vez
  - Búsqueda semántica automática
  - Vectorización con DocLing
  - Chunks inteligentes (1000 chars)
  - Metadata por documento (keywords, fecha)
Integración:
  - Open WebUI (nativo, interfaz visual)
  - Python API (programático)
  - LangChain (contexto automático)
```

### Procesamiento
```yaml
NLP: spaCy (español) - detección de estructura
Diff: difflib + custom logic
Tablas: pandas + docling
```

### Frontend / Interfaz de Usuario
```yaml
Open WebUI: Interfaz web tipo ChatGPT
Funcionalidad:
  - Subir documentos (PDF/DOCX)
  - Chat con el modelo sobre documentos
  - Comparar dos versiones de documentos
  - Análisis por keywords
  - Visualización de resultados
Puerto: http://localhost:3000
Integración: Conectado a Ollama (Llama 70B)
```

---

## 🔄 Flujo de Trabajo del Usuario

### Preparación: Cargar Base de Conocimientos
```
Usuario: Sube múltiples documentos históricos
   ↓
Open WebUI Knowledge Base:
1. Recibe archivos (PDF/DOCX)
2. DocLing extrae contenido estructurado
3. ChromaDB vectoriza y almacena
4. Embeddings generados con sentence-transformers
   ↓
Documentos disponibles para TODAS las conversaciones
(No necesita volver a subirlos)
```

### Caso 1: Consulta Simple con Base de Conocimientos
```
Usuario (navegador): "Analiza el capítulo de E14"
   ↓
Sistema Backend:
1. ChromaDB busca documentos relevantes con "E14"
2. Recupera contexto de base de conocimientos
3. DocLing identifica el capítulo específico de E14
4. Llama 70B analiza con contexto completo
   ↓
Open WebUI: Respuesta basada en documentos reales
Usuario: "Compara con la versión anterior"
   ↓
Sistema: Busca versiones anteriores en base de conocimientos
   ↓
Open WebUI: Muestra comparación automática
```

### Caso 1B: Consulta sin Base de Conocimientos (Subida Manual)
```
Usuario (navegador): Sube documento.pdf
   ↓
Open WebUI: Recibe archivo (solo para esta conversación)
   ↓
Sistema Backend:
1. DocLing extrae estructura del documento
2. Identifica capítulos por keywords
3. Llama 70B analiza el contenido
   ↓
Open WebUI: Muestra análisis al usuario
Usuario: "Analiza el capítulo de E14"
   ↓
Sistema: Extrae y analiza solo ese capítulo
   ↓
Open WebUI: Respuesta detallada del análisis
```

### Caso 2: Comparación de Versiones (via Open WebUI)
```
Usuario: Sube doc_v1.pdf y doc_v2.pdf
Usuario: "Compara E14 entre ambas versiones"
   ↓
Sistema:
1. Extrae capítulo E14 de ambos docs
2. Ejecuta comparación (dos frentes)
3. Genera análisis analítico
   ↓
Open WebUI: Muestra resultados con formato
- Cambios uno a uno (diff línea por línea)
- Análisis de impacto (recomendaciones)
- Comparación de tablas
```

### Caso 3: Comparación Completa (via Open WebUI)
```
Usuario: "Compara documento completo v1 vs v2"
   ↓
Sistema:
1. Extrae TODOS los capítulos (todas las keywords)
2. Compara cada capítulo
3. Compara contenido no clasificado
4. Genera reporte global
   ↓
Open WebUI: Reporte interactivo
- Resumen ejecutivo
- Desglose por capítulo
- Estadísticas de cambios
- Navegación entre secciones
```

---

## 🎨 Formato de Salida Esperado

### Ejemplo: Comparación de Capítulo E14

El sistema generará DOS reportes complementarios:

---

## 📊 FRENTE 1: Comparación Uno a Uno (Detallada)

```markdown
# Comparación Línea por Línea: Capítulo E14

## Metadata
- **Documento 1**: v1.0 (Fecha: 2026-01-15) - Páginas 45-52
- **Documento 2**: v2.0 (Fecha: 2026-08-20) - Páginas 48-57
- **Total de cambios detectados**: 47 modificaciones

---

## Sección 3.1: Introducción al E14

### Párrafo 1
✅ **SIN CAMBIOS**

v1.0 (Línea 1-3):
> El sistema E14 constituye el mecanismo principal de verificación 
> electoral según lo establecido en la normativa vigente.

v2.0 (Línea 1-3):
> El sistema E14 constituye el mecanismo principal de verificación 
> electoral según lo establecido en la normativa vigente.

---

### Párrafo 2
⚠️ **MODIFICADO**

v1.0 (Línea 4-6):
> El procedimiento debe realizarse cada 24 horas durante el período
> electoral, con supervisión del coordinador técnico designado.

v2.0 (Línea 4-6):
> El procedimiento debe realizarse cada 12 horas durante el período
> electoral, con supervisión del coordinador técnico y auditor externo.

**Cambios detectados:**
- Línea 4, posición 40-42: "24" → "12"
- Línea 5, posición 35-37: + "y auditor externo"

---

### Párrafo 3
➕ **NUEVO CONTENIDO (v2.0)**

v2.0 (Línea 7-10):
> En caso de identificarse anomalías durante la verificación, se debe
> activar inmediatamente el protocolo de contingencia descrito en el
> anexo C. El tiempo máximo de respuesta no debe exceder los 30 minutos.

**Ubicación:** Insertado después del párrafo 2

---

## Sección 3.2: Especificaciones Técnicas

### Subsección 3.2.1: Requisitos de Hardware

⚠️ **MODIFICADO**

v1.0 (Línea 15-17):
> - Voltaje de operación: 220V ±10%
> - Frecuencia: 50Hz
> - Potencia nominal: 1000W

v2.0 (Línea 18-21):
> - Voltaje de operación: 220V ±10%
> - Frecuencia: 60Hz
> - Potencia nominal: 1500W
> - Factor de potencia: 0.95 mínimo

**Cambios detectados:**
- Línea 16: "50Hz" → "60Hz"
- Línea 17: "1000W" → "1500W"
- Línea 21: + Nueva línea "Factor de potencia: 0.95 mínimo"

---

## Sección 3.5: Protocolo de Emergencia

➕ **SECCIÓN COMPLETAMENTE NUEVA (v2.0)**

Esta sección no existía en v1.0

v2.0 (Líneas 95-125):
> [Contenido completo de 30 líneas sobre protocolo de emergencia]

**Ubicación:** Nueva sección insertada después de 3.4

---

## Sección 2.3: Procedimiento Antiguo

➖ **SECCIÓN ELIMINADA**

v1.0 (Líneas 32-45):
> [Contenido completo de 13 líneas que fue eliminado]

Esta sección completa fue removida en v2.0

---

## Estadísticas del Diff

| Métrica | Valor |
|---------|-------|
| Líneas idénticas | 234 (70.3%) |
| Líneas modificadas | 48 (14.4%) |
| Líneas nuevas (v2) | 38 (11.4%) |
| Líneas eliminadas (v1) | 13 (3.9%) |
| Total v1 | 295 líneas |
| Total v2 | 320 líneas |
| Diferencia neta | +25 líneas |
```

---

## 📈 FRENTE 2: Análisis Analítico (Alto Nivel)

```markdown
# Análisis Analítico: Capítulo E14

## Resumen Ejecutivo

La versión 2.0 del documento introduce **cambios significativos** en la 
operación del sistema E14, con énfasis en:

1. **Incremento de frecuencia de verificación** (duplicada)
2. **Mayor exigencia técnica** (potencia +50%)
3. **Nuevos protocolos de seguridad** (contingencia)
4. **Requisitos de auditoría externa** (nuevo requerimiento)

**Valoración general:** Cambios de **impacto ALTO** que requieren 
planificación operativa y presupuestaria antes de implementación.

---

## Categorización de Cambios

### 🔴 Impacto CRÍTICO (Requiere acción inmediata)

#### 1. Frecuencia de verificación: 24h → 12h
- **Qué cambió:** Se duplica la frecuencia de verificaciones
- **Impacto operativo:**
  - ✗ Requiere **2x personal** en turno de verificación
  - ✗ Costo operativo incrementa ~40-50%
  - ✓ Mejora significativa en detección temprana de anomalías
- **Acción requerida:** 
  - Contratar/reasignar personal (2 semanas antes)
  - Actualizar turnos y logística
  - Presupuesto adicional estimado: $XXX

#### 2. Incremento de potencia: 1000W → 1500W
- **Qué cambió:** 50% más de consumo eléctrico
- **Impacto técnico:**
  - ⚠️ Infraestructura eléctrica actual puede ser insuficiente
  - ⚠️ Riesgo de sobrecarga en circuitos existentes
  - ⚠️ Sistema de enfriamiento puede requerir upgrade
- **Acción requerida:**
  - Auditoría eléctrica URGENTE
  - Validar UPS y respaldo energético
  - Posible upgrade infraestructura (4-6 semanas)

#### 3. Cambio de frecuencia eléctrica: 50Hz → 60Hz
- **Qué cambió:** Especificación técnica fundamental
- **Impacto:**
  - ⚠️ **INCOMPATIBILIDAD** con equipos actuales si son 50Hz
  - Puede requerir reemplazo completo de hardware
- **Acción requerida:**
  - Verificar especificaciones de equipos actuales INMEDIATAMENTE
  - Si hay incompatibilidad: plan de migración de hardware

---

### 🟡 Impacto ALTO (Importante)

#### 4. Auditor externo requerido
- **Qué cambió:** Nueva figura de supervisión
- **Impacto:**
  - Costo adicional por auditoría externa
  - Procesos de contratación/certificación
  - Coordinación adicional
- **Acción sugerida:**
  - Iniciar licitación de auditores certificados
  - Tiempo estimado: 3-4 semanas

#### 5. Protocolo de contingencia nuevo (Sección 3.5)
- **Qué cambió:** 30 líneas de nuevo protocolo
- **Impacto:**
  - Personal debe ser capacitado
  - Tiempo de respuesta máximo: 30 minutos
  - Puede requerir recursos adicionales de stand-by
- **Acción sugerida:**
  - Capacitación obligatoria a todo el equipo
  - Simulacros de protocolo de emergencia

---

### 🟢 Impacto MEDIO-BAJO (Seguimiento)

#### 6. Nueva certificación UL añadida
- Expansión de certificaciones (ISO-9001 + UL)
- Validación de cumplimiento normativo

#### 7. Factor de potencia especificado
- Nueva métrica técnica: 0.95 mínimo
- Verificación en especificaciones de compra

---

## Análisis de Riesgos

### Riesgos de NO implementar estos cambios:
1. ❌ Incumplimiento normativo si v2.0 es obligatoria
2. ❌ Sistema menos robusto (menos verificaciones)
3. ❌ Menor capacidad de detección de problemas

### Riesgos de implementar SIN preparación:
1. ⚠️ Fallas eléctricas por sobrecarga
2. ⚠️ Personal insuficiente para nuevas frecuencias
3. ⚠️ Incompatibilidad de hardware (50Hz vs 60Hz)
4. ⚠️ Costos no presupuestados

---

## Estimación de Costos (aproximada)

| Concepto | Costo Estimado |
|----------|----------------|
| Personal adicional (12 meses) | $XX,XXX |
| Upgrade infraestructura eléctrica | $XX,XXX |
| Auditoría externa | $X,XXX/mes |
| Capacitación | $X,XXX |
| Contingencias (10%) | $X,XXX |
| **TOTAL ESTIMADO** | **$XXX,XXX** |

---

## Recomendaciones Priorizadas

### Fase 1: Inmediato (Semana 1-2)
1. ⚠️ **CRÍTICO:** Auditoría eléctrica completa
2. ⚠️ **CRÍTICO:** Verificar especificación 50Hz vs 60Hz de equipos
3. 📋 Análisis de capacidad de personal actual
4. 📋 Revisión presupuestaria

### Fase 2: Preparación (Semana 3-6)
1. Upgrade infraestructura eléctrica (si requerido)
2. Contratación/reasignación de personal
3. Licitación de auditor externo
4. Desarrollo de capacitación en protocolo de contingencia

### Fase 3: Implementación (Semana 7-8)
1. Capacitación completa del personal
2. Simulacros de protocolo de emergencia
3. Pruebas piloto con nueva frecuencia de verificación
4. Integración de auditor externo

### Fase 4: Transición (Semana 9-12)
1. Implementación gradual de v2.0
2. Monitoreo intensivo
3. Ajustes operativos
4. Documentación de lecciones aprendidas

---

## Conclusión

**Nivel de preparación requerido:** ALTO

La transición de v1.0 a v2.0 del capítulo E14 **no es trivial** y requiere:
- ⏱️ **Tiempo mínimo:** 10-12 semanas
- 💰 **Inversión estimada:** $XXX,XXX
- 👥 **Recursos:** Personal técnico, eléctrico, capacitación
- 🎯 **Prioridad:** ALTA (por cambios críticos)

**NO SE RECOMIENDA** implementación inmediata sin:
1. Auditoría eléctrica completa
2. Validación de compatibilidad de hardware
3. Plan de contratación/capacitación de personal
4. Presupuesto aprobado

**Siguiente paso sugerido:** Reunión con comité técnico y financiero 
para validar viabilidad y timeline.
```

---

## 📊 Resumen de los Dos Frentes

| Aspecto | Frente 1: Uno a Uno | Frente 2: Analítico |
|---------|---------------------|---------------------|
| **Objetivo** | Mostrar QUÉ cambió exactamente | Explicar POR QUÉ importa y QUÉ HACER |
| **Nivel** | Línea por línea, palabra por palabra | Alto nivel, contexto |
| **Audiencia** | Técnicos, revisores detallados | Gerencia, tomadores de decisión |
| **Formato** | Diff estructurado | Análisis narrativo |
| **Utilidad** | Validación, precisión | Planificación, estrategia |

---

## 🚀 Plan de Implementación

### Fase 1: Limpieza e Instalación ✅ COMPLETADO
- [x] Eliminar modelos Qwen (completo)
- [x] Limpiar configuraciones antiguas
- [x] Instalar Ollama limpio
- [x] Instalar modelo Llama 3.1 70B (producción)
- [x] Instalar modelo Llama 3.1 8B (desarrollo)

### Fase 2: Setup Base ✅ COMPLETADO
- [x] Instalar Python 3.14.7 + dependencias
- [x] Configurar DocLing
- [x] Configurar LangChain
- [x] Instalar PyMuPDF, Pandas, spaCy
- [x] Probar integración con Ollama

### Fase 3: Interfaz de Usuario ✅ COMPLETADO
- [x] Instalar Open WebUI
- [x] Configurar conexión con Ollama
- [x] Configurar auto-inicio con launchd
- [x] Habilitar carga de archivos (PDF/DOCX)

### Fase 3.5: Base de Conocimientos ✅ COMPLETADO
- [x] Instalar ChromaDB para RAG (Retrieval Augmented Generation)
- [x] Sistema de vectorización de documentos
- [x] Script `knowledge_base.py` para gestión de documentos
- [x] Integración con Open WebUI (funcionalidad nativa)
- [x] Búsqueda semántica automática
- [x] Documentación completa en `GUIA-BASE-CONOCIMIENTOS.md`

### Fase 4: Desarrollo Core ✅ COMPLETADO
- [x] Sistema de extracción estructurada (DocLing)
- [x] Detector de capítulos por keyword (`chapter_detector.py`)
- [x] Sistema de comparación básica (`document_comparator.py`)
- [x] Integración con modelo IA (Llama 70B)
- [x] Sistema integrado completo (`document_analyzer.py`)
- [x] CLI completo para todas las funcionalidades
- [x] Documentación completa en `GUIA-USO-COMPLETA.md`

### Fase 5: Comparación Avanzada ✅ COMPLETADO
- [x] Comparación de tablas celda por celda (`table_comparator.py`)
- [x] Análisis numérico (diferencias absolutas y porcentuales)
- [x] Detección de filas/columnas añadidas/eliminadas
- [x] Integración con sistema principal (`document_comparator_v2.py`)
- [x] Sistema de análisis analítico mejorado (incluye tablas)
- [x] Generación de reportes completos (texto + tablas + análisis)
- [x] Documentación completa en `GUIA-COMPARACION-TABLAS.md`
- [ ] Visualización gráfica en Open WebUI (mejora futura opcional)

### Fase 6: Testing y Ajustes
- [ ] Probar con documentos reales
- [ ] Ajustar detección de capítulos
- [ ] Optimizar prompts del modelo
- [ ] Validar precisión de comparaciones

### Fase 7: Producción
- [ ] API REST para integración externa (opcional)
- [ ] Documentación completa
- [ ] Monitoreo y logging
- [ ] Configuración de seguridad
- [ ] Deploy final

---

## 💾 Requisitos de Hardware

### Mac Recomendado
```yaml
Procesador: Apple Silicon (M1/M2/M3)
RAM: 32GB (mínimo 16GB)
Almacenamiento: 100GB libres
GPU: Unified Memory (Metal)
```

### Espacio Necesario
```
Modelo IA: 40GB (Llama 3.1) o 4GB (Mistral)
DocLing + deps: ~5GB
Base de datos vectorial: ~10GB
Documentos + cache: ~20GB
Total: ~75GB (o ~40GB con Mistral)
```

---

## 🔐 Consideraciones de Seguridad

1. **Documentos sensibles**: Implementar cifrado en reposo
2. **Datos personales**: Cumplimiento GDPR si aplica
3. **Control de acceso**: Autenticación para API
4. **Logs**: No guardar contenido sensible en logs

---

## 📝 Notas Importantes

### ⚠️ Lección aprendida: Problema con modelos Qwen

**Contexto:** Usuario en China, modelos Qwen respondieron en chino mandarín

**Causa:** Modelos Qwen (Alibaba) tienen sesgo fuerte hacia chino

**Solución:** 
- NO usar modelos Qwen para este proyecto
- Usar Llama 3.1 o Mistral con prompt forzado a español
- Configurar idioma explícitamente en cada llamada

### 📍 Ubicación del Backup

**Filtro de comparación original guardado en:**
```
/workspace/backup-filtro-comparacion/compare_gold.py
```

---

## 🎯 Próximos Pasos Inmediatos

1. ✅ Verificar conexión al Mac
2. 🧹 Limpiar instalación de Ollama (en progreso)
3. 📥 Instalar stack limpio:
   - Ollama
   - Modelo Llama 3.1 o Mistral
   - DocLing
4. 🧪 Prueba con documento real del usuario

---

## 📞 Contacto y Seguimiento

**Última actualización:** 2026-09-08 06:42 UTC  
**Estado:** Plan definido, pendiente implementación  
**Ubicación:** China  

---

*Este documento será actualizado conforme avance la implementación.*
