# Base de Conocimientos - Guía de Uso

**Sistema RAG (Retrieval Augmented Generation)**  
Permite cargar documentos una vez y tenerlos disponibles para todas las consultas.

---

## 🎯 Dos Formas de Usar la Base de Conocimientos:

### **Opción 1: Open WebUI (Interfaz Visual)** 👍 Más Fácil

**Para usuarios finales:**

1. Abrir `http://localhost:3000`
2. Ir a **"Knowledge"** o **"Documents"** (menú lateral)
3. Click en **"Upload"** o **"+"**
4. Seleccionar archivos (PDF, DOCX, TXT)
5. Esperar procesamiento (~30s por documento)
6. ¡Listo! Los documentos están disponibles para todas las conversaciones

**Ventajas:**
- ✅ Interfaz visual intuitiva
- ✅ Carga múltiple de archivos
- ✅ Búsqueda automática en conversaciones
- ✅ No requiere comandos

---

### **Opción 2: Script Python (Programático)** 🔧 Más Control

**Para desarrollo y automatización:**

**Ubicación:** `~/analisis-documentos-ia/knowledge_base.py`

#### Agregar Documento:

```bash
cd ~/analisis-documentos-ia
source venv/bin/activate

# Agregar documento simple
python knowledge_base.py add /ruta/al/documento.pdf

# Agregar con keywords
python knowledge_base.py add documento.pdf "E14,kit,Preconteo"
```

#### Buscar en la Base:

```bash
# Buscar contenido
python knowledge_base.py search "E14 protocolo"

# Buscar con más resultados (default: 5)
python knowledge_base.py search "plan de comunicaciones" 10
```

#### Listar Documentos:

```bash
# Ver estadísticas
python knowledge_base.py list
```

---

## 📁 Uso Programático (Python)

### Importar y Usar:

```python
from knowledge_base import KnowledgeBase

# Crear instancia
kb = KnowledgeBase(persist_directory="./knowledge_db")

# Agregar documento
kb.agregar_documento(
    "documento.pdf",
    metadata={
        "keywords": ["E14", "kit"],
        "version": "2.0"
    }
)

# Buscar
results = kb.buscar("E14 verificación", n_results=5)

for result in results:
    print(f"Documento: {result['metadata']['filename']}")
    print(f"Contenido: {result['content'][:200]}...")
    print()

# Ver estadísticas
kb.stats()
```

---

## 🔄 Integración con Llama 70B

El sistema automáticamente usa la base de conocimientos:

```python
from langchain_community.llms import Ollama
from knowledge_base import KnowledgeBase

# Inicializar
kb = KnowledgeBase()
llm = Ollama(model="llama3.1:70b")

# Usuario pregunta
pregunta = "¿Cuál es el protocolo de E14?"

# 1. Buscar contexto relevante en base de conocimientos
contexto_docs = kb.buscar(pregunta, n_results=3)
contexto = "\\n\\n".join([r['content'] for r in contexto_docs])

# 2. Crear prompt con contexto
prompt = f"""
Basándote en la siguiente información de documentos:

{contexto}

Responde la pregunta: {pregunta}
"""

# 3. Obtener respuesta
respuesta = llm.invoke(prompt)
print(respuesta)
```

---

## 💡 Flujo Completo:

```
Usuario sube documentos
    ↓
DocLing extrae contenido + estructura
    ↓
ChromaDB vectoriza y guarda
    ↓
Usuario hace pregunta
    ↓
Sistema busca contexto relevante en ChromaDB
    ↓
Llama 70B responde usando el contexto
```

---

## 📊 Estructura de Datos:

### Cada documento se guarda como:

```json
{
  "id": "documento.pdf_chunk_0",
  "content": "Contenido del chunk...",
  "metadata": {
    "filename": "documento.pdf",
    "added_at": "2026-09-08T09:30:00",
    "chunks_total": 45,
    "chunk_index": 0,
    "keywords": ["E14", "kit"]
  },
  "vector": [0.123, 0.456, ...]  // Embedding automático
}
```

---

## 🎯 Keywords Recomendadas:

Al subir documentos, agregar estas keywords ayuda:

```python
keywords = [
    "kit",
    "Preconteo", 
    "Escrutinio",
    "E14",
    "E11",
    "Plan de comunicaciones",
    "Infraestructura tecnología",
    "Requerimientos tecnología"
]
```

---

## 🔍 Búsqueda Semántica:

ChromaDB hace **búsqueda semántica**, no solo palabras clave:

**Ejemplo:**
```python
# Buscar: "protocolo de verificación electoral"
# Encuentra documentos con:
# - "E14"
# - "procedimiento de verificación"  
# - "protocolo electoral"
# - Conceptos similares

# NO requiere coincidencia exacta de palabras
```

---

## 📦 Ventajas del Sistema:

| Característica | Sin Base de Conocimientos | Con Base de Conocimientos |
|----------------|---------------------------|---------------------------|
| Subir docs | Cada conversación | Una sola vez |
| Búsqueda | Manual | Automática |
| Contexto | Limitado (ventana) | Ilimitado (todos los docs) |
| Precisión | Depende del prompt | Basada en documentos reales |
| Keywords | No detecta | Detecta automáticamente |

---

## 🛠️ Mantenimiento:

### Ver qué hay en la base:

```bash
python knowledge_base.py list
```

### Limpiar la base (reiniciar):

```bash
cd ~/analisis-documentos-ia
rm -rf knowledge_db/
# La base se recreará vacía al siguiente uso
```

### Actualizar documento:

```bash
# 1. Eliminar versión anterior (manual en ChromaDB)
# 2. Agregar versión nueva
python knowledge_base.py add documento_v2.pdf "E14,kit"
```

---

## 🚀 Casos de Uso:

### 1. Análisis de Capítulo Específico

```
Usuario: "Analiza el capítulo E14"

Sistema:
1. Busca en base: "E14 capítulo"
2. Encuentra sección relevante
3. Llama 70B analiza ese contexto
4. Respuesta precisa basada en documento real
```

### 2. Comparación de Versiones

```
Documentos en base:
- manual_v1.pdf (keyword: "version_1")
- manual_v2.pdf (keyword: "version_2")

Usuario: "Compara E14 entre v1 y v2"

Sistema:
1. Busca "E14" + metadata:"version_1"
2. Busca "E14" + metadata:"version_2"  
3. Compara ambos contextos
4. Genera análisis de diferencias
```

### 3. Respuestas Multi-Documento

```
Usuario: "¿Qué requisitos tecnológicos hay en todos los documentos?"

Sistema:
1. Busca "requisitos tecnológicos" en TODOS los docs
2. Agrega contexto de múltiples fuentes
3. Llama 70B sintetiza información
4. Respuesta consolidada
```

---

## ⚙️ Configuración Avanzada:

### Cambiar tamaño de chunks:

```python
kb = KnowledgeBase()
# En _split_into_chunks, modificar chunk_size
# Default: 1000 caracteres
# Recomendado: 500-2000 según tipo de documento
```

### Usar modelo de embeddings diferente:

ChromaDB usa `sentence-transformers` por defecto.  
Para cambiar (avanzado):

```python
from chromadb.utils import embedding_functions

embedding_fn = embedding_functions.SentenceTransformerEmbeddingFunction(
    model_name="paraphrase-multilingual-mpnet-base-v2"  # Mejor para español
)

collection = client.create_collection(
    name="docs",
    embedding_function=embedding_fn
)
```

---

## 📝 Próximos Pasos:

### Integración Completa (Desarrollo):

El sistema de análisis usará esta base para:

1. ✅ Detectar capítulos por keywords
2. ✅ Extraer contexto relevante
3. ✅ Comparar versiones de documentos
4. ✅ Análisis analítico con contexto completo

---

*Sistema operacional y listo para cargar documentos.* 🚀
