# Guía Completa del Sistema de Análisis de Documentos

**Sistema RAG + Detección de Capítulos + Comparación Inteligente**

---

## 🎯 Capacidades del Sistema

El sistema puede:

1. ✅ **Leer documentos completos** (PDF, DOCX) incluyendo tablas
2. ✅ **Detectar capítulos** por keywords (no solo menciones)
3. ✅ **Comparar documentos** en dos frentes:
   - Detallado (línea por línea)
   - Analítico (impacto y recomendaciones)
4. ✅ **Base de conocimientos** (RAG) - subir documentos una vez
5. ✅ **Análisis con IA** usando Llama 3.1 70B

---

## 📂 Componentes del Sistema

### Ubicación: `~/analisis-documentos-ia/`

```
~/analisis-documentos-ia/
├── venv/                        # Entorno virtual Python
├── knowledge_db/                # Base de datos de documentos
├── knowledge_base.py            # Gestión de base de conocimientos
├── chapter_detector.py          # Detección de capítulos
├── document_comparator.py       # Comparación de documentos
├── document_analyzer.py         # Sistema integrado (PRINCIPAL)
└── test_sistema.py              # Tests del sistema
```

---

## 🚀 Cómo Usar el Sistema

### Método 1: Línea de Comandos (Python)

#### A. Ver ayuda:

```bash
cd ~/analisis-documentos-ia
source venv/bin/activate

python document_analyzer.py
```

#### B. Agregar documentos a la base de conocimientos:

```bash
# Agregar documento sin keywords
python document_analyzer.py add /ruta/al/documento.pdf

# Agregar con keywords
python document_analyzer.py add documento.pdf "E14,kit,Preconteo"
```

#### C. Buscar en la base de conocimientos:

```bash
python document_analyzer.py search "E14 protocolo"
```

#### D. Analizar un capítulo específico:

```bash
python document_analyzer.py analyze documento.pdf E14
```

Esto:
1. Busca en la base de conocimientos contexto sobre "E14"
2. Detecta el capítulo de E14 en el documento
3. Analiza con Llama 70B
4. Devuelve análisis detallado

#### E. Comparar un capítulo entre dos versiones:

```bash
python document_analyzer.py compare doc_v1.pdf doc_v2.pdf E14
```

Esto genera:
- **Frente 1:** Diff línea por línea (qué cambió exactamente)
- **Frente 2:** Análisis analítico (impacto, recomendaciones)

#### F. Comparar documentos completos:

```bash
python document_analyzer.py compare-all doc_v1.pdf doc_v2.pdf
```

Compara **todos los capítulos** (todas las keywords) entre ambos documentos.

#### G. Hacer una pregunta:

```bash
python document_analyzer.py ask "¿Cuál es el protocolo de E14?"
```

Busca en la base de conocimientos y responde usando el contexto.

#### H. Ver estadísticas:

```bash
python document_analyzer.py stats
```

---

### Método 2: Interfaz Web (Open WebUI)

#### Acceso:

1. Abrir navegador: **http://localhost:3000**
2. Login (primera vez crear cuenta)
3. ¡Listo para usar!

#### Funcionalidades:

##### 1. Subir Documentos a Base de Conocimientos:

- Ir a **"Knowledge"** (menú lateral)
- Click **"Upload"** o **"+"**
- Seleccionar archivos PDF/DOCX
- Esperar procesamiento
- ¡Documentos disponibles para todas las conversaciones!

##### 2. Analizar Documentos:

**Chat simple:**
```
Usuario: Sube documento.pdf
Usuario: "Analiza el capítulo de E14"
Sistema: [Analiza usando Llama 70B]
```

**Con base de conocimientos:**
```
Usuario: "Analiza el capítulo de E14"
Sistema: Busca automáticamente en KB + analiza
```

##### 3. Comparar Versiones:

```
Usuario: Sube doc_v1.pdf y doc_v2.pdf
Usuario: "Compara el capítulo de E14 entre ambas versiones"
Sistema: Genera reporte de comparación (dos frentes)
```

##### 4. Preguntas Generales:

```
Usuario: "¿Cuáles son los requisitos tecnológicos según todos los documentos?"
Sistema: Busca en KB + sintetiza información
```

---

### Método 3: Python (Programático)

Para integración en otros scripts:

```python
from document_analyzer import DocumentAnalyzer

# Inicializar sistema
analyzer = DocumentAnalyzer(llm_model="llama3.1:70b")

# Agregar documento a KB
analyzer.add_to_knowledge_base(
    "documento.pdf",
    keywords=["E14", "kit"]
)

# Buscar en KB
results = analyzer.search_knowledge_base("E14 protocolo", n_results=5)

# Analizar capítulo
analysis = analyzer.analyze_chapter("documento.pdf", "E14", use_kb=True)
print(analysis)

# Comparar capítulo
report = analyzer.compare_chapters(
    "doc_v1.pdf",
    "doc_v2.pdf",
    "E14",
    use_kb=True
)
print(report)

# Comparar documentos completos
full_report = analyzer.compare_full_documents("doc_v1.pdf", "doc_v2.pdf")
print(full_report)

# Responder pregunta
answer = analyzer.answer_question(
    "¿Cuál es el protocolo de E14?",
    use_kb=True
)
print(answer)
```

---

## 🔍 Keywords Soportadas

El sistema detecta automáticamente estos capítulos:

1. **kit**
2. **Preconteo**
3. **Escrutinio**
4. **E14**
5. **E11**
6. **Plan de comunicaciones**
7. **Infraestructura tecnología**
8. **Requerimientos tecnología**

**Nota:** Detecta el CAPÍTULO, no solo menciones de la keyword.

---

## 📊 Formato de Comparación (Dos Frentes)

### FRENTE 1: Comparación Uno a Uno

Muestra cambios exactos:

```markdown
## Párrafo 2
⚠️ MODIFICADO

v1.0 (Línea 4-6):
> El procedimiento debe realizarse cada 24 horas

v2.0 (Línea 4-6):
> El procedimiento debe realizarse cada 12 horas
                                          ^^

Cambio detectado: "24" → "12"
```

**Para quién:** Técnicos, revisores detallados

---

### FRENTE 2: Análisis Analítico

Muestra impacto y recomendaciones:

```markdown
## Resumen Ejecutivo

La versión 2.0 introduce cambios significativos:
- Duplica frecuencia de verificación
- Incremento +50% en requisitos de potencia
- Nuevos protocolos de emergencia

## Análisis de Impacto

CRÍTICO - Requiere acción inmediata:
- Personal: 2x más turnos → contratar/reasignar
- Infraestructura: validar capacidad eléctrica
- Costo: incremento estimado 40-50%

## Recomendaciones

1. Auditoría eléctrica URGENTE
2. Contratar personal (2 semanas)
3. Capacitación en nuevos protocolos
4. Presupuesto adicional requerido
```

**Para quién:** Gerencia, tomadores de decisión

---

## 🧪 Ejemplos de Uso Reales

### Ejemplo 1: Agregar Manual a Base de Conocimientos

```bash
cd ~/analisis-documentos-ia
source venv/bin/activate

# Agregar manual versión 1
python document_analyzer.py add manual_v1.pdf "E14,E11,kit"

# Agregar manual versión 2
python document_analyzer.py add manual_v2.pdf "E14,E11,kit"

# Ver estadísticas
python document_analyzer.py stats
```

Salida:
```
📚 Base de conocimientos inicializada
📊 Documentos en base: 2

📄 Documentos:
  - manual_v1.pdf (45 chunks)
  - manual_v2.pdf (52 chunks)
```

---

### Ejemplo 2: Analizar Capítulo con Contexto

```bash
python document_analyzer.py analyze manual_v2.pdf E14
```

El sistema:
1. Busca "E14" en base de conocimientos → encuentra contexto de v1 y v2
2. Detecta capítulo de E14 en manual_v2.pdf
3. Analiza con Llama 70B usando TODO el contexto
4. Genera análisis detallado

---

### Ejemplo 3: Comparar Versiones de E14

```bash
python document_analyzer.py compare manual_v1.pdf manual_v2.pdf E14 > reporte_e14.md
```

Genera `reporte_e14.md` con:
- Estadísticas de cambios
- Diff línea por línea (FRENTE 1)
- Análisis de impacto (FRENTE 2)
- Recomendaciones

---

### Ejemplo 4: Comparación Completa

```bash
python document_analyzer.py compare-all manual_v1.pdf manual_v2.pdf > reporte_completo.md
```

Compara **TODOS** los capítulos:
- E14
- E11
- kit
- Preconteo
- Escrutinio
- Plan de comunicaciones
- Infraestructura tecnología
- Requerimientos tecnología

---

### Ejemplo 5: Preguntar Sobre Múltiples Documentos

```bash
python document_analyzer.py ask "¿Cuáles son las diferencias en los requisitos tecnológicos entre todas las versiones?"
```

El sistema:
1. Busca "requisitos tecnológicos" en KB (todos los docs)
2. Recupera contexto de manual_v1.pdf, manual_v2.pdf, etc.
3. Sintetiza con Llama 70B
4. Responde con información consolidada

---

## 🔧 Personalización Avanzada

### Cambiar Modelo de IA:

```python
# En vez de Llama 70B, usar Llama 8B (más rápido)
analyzer = DocumentAnalyzer(llm_model="llama3.1:8b")
```

### Ajustar Confianza de Detección de Capítulos:

Editar `chapter_detector.py`, línea ~180:

```python
# Umbral de confianza (default: 0.3)
if best['confidence'] < 0.3:  # Cambiar a 0.5 para más estricto
    return None
```

### Cambiar Tamaño de Chunks en KB:

Editar `knowledge_base.py`, línea ~70:

```python
def _split_into_chunks(self, text: str, chunk_size: int = 1000):
    # Cambiar chunk_size de 1000 a 500 o 2000
```

---

## 🛠️ Comandos Útiles

### Ver logs de Open WebUI:

```bash
cat ~/open-webui-app/stdout.log
cat ~/open-webui-app/stderr.log
```

### Reiniciar Open WebUI:

```bash
launchctl unload ~/Library/LaunchAgents/com.openwebui.service.plist
launchctl load ~/Library/LaunchAgents/com.openwebui.service.plist
```

### Ver modelos disponibles en Ollama:

```bash
ollama list
```

### Verificar Ollama está corriendo:

```bash
curl http://localhost:11434/api/tags
```

### Limpiar base de conocimientos:

```bash
cd ~/analisis-documentos-ia
rm -rf knowledge_db/
# Se recreará vacía al siguiente uso
```

---

## 🐛 Troubleshooting

### "No se pudo conectar con Ollama"

**Solución:**
```bash
# Verificar que Ollama esté corriendo
brew services list | grep ollama

# Si no está corriendo:
brew services start ollama

# Verificar puerto
curl http://localhost:11434/api/tags
```

---

### "No se encontró capítulo 'E14'"

**Posibles causas:**
1. La keyword no existe como capítulo en el documento
2. El título usa formato diferente (ej: "E-14" vs "E14")
3. Confianza muy baja (< 0.3)

**Solución:**
```python
# Inspeccionar estructura del documento
detector = ChapterDetector()
doc_data = detector.extract_document("documento.pdf")

# Ver todos los títulos
for section in doc_data['structure']:
    print(f"{section['level']}: {section['title']}")
```

---

### "DeprecationWarning: LangChain..."

**No crítico.** Es solo una advertencia de deprecación.

**Para eliminarla (opcional):**
```bash
pip install -U langchain-ollama
# Luego editar código para usar OllamaLLM en vez de Ollama
```

---

### Open WebUI no carga

**Solución:**
```bash
# Ver logs
cat ~/open-webui-app/stderr.log

# Verificar puerto
lsof -i :3000

# Reiniciar manualmente
cd ~/open-webui-app
source venv/bin/activate
export OLLAMA_BASE_URL=http://localhost:11434
open-webui serve --port 3000
```

---

## 📈 Próximos Pasos Recomendados

### 1. Probar con Documentos Reales:

```bash
# Subir tus documentos reales
python document_analyzer.py add documento_real.pdf "E14,kit"

# Probar detección de capítulos
python document_analyzer.py analyze documento_real.pdf E14
```

### 2. Ajustar Keywords si es Necesario:

Editar `chapter_detector.py`, línea ~17:

```python
KEYWORDS = [
    "kit",
    "Preconteo",
    # ... agregar más keywords según necesites
    "Nueva keyword personalizada"
]
```

### 3. Integrar con Aplicación:

```python
# En tu aplicación
from document_analyzer import DocumentAnalyzer

analyzer = DocumentAnalyzer()
result = analyzer.compare_chapters("v1.pdf", "v2.pdf", "E14")
# Usar result en tu app
```

### 4. Automatizar Comparaciones:

```bash
#!/bin/bash
# Script para comparar todas las versiones

cd ~/analisis-documentos-ia
source venv/bin/activate

for version in v1 v2 v3; do
    python document_analyzer.py compare-all \\
        manual_${version}.pdf \\
        manual_${version}_next.pdf \\
        > reporte_${version}.md
done
```

---

## 📞 Estado del Sistema

**✅ Completado:**
- Base de conocimientos (ChromaDB + RAG)
- Detección de capítulos por keywords
- Comparación de documentos (dos frentes)
- Sistema integrado completo
- Open WebUI instalado y configurado
- Auto-inicio en boot

**🔄 Para Mejorar (Opcional):**
- Detección de tablas mejorada
- Comparación de tablas celda por celda
- Visualización gráfica de cambios
- API REST para integración externa

---

*Sistema operacional y listo para producción.* 🚀
