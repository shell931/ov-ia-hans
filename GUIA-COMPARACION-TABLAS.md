# Guía de Comparación Avanzada de Tablas

**Sistema de Comparación Celda por Celda con Análisis Numérico**

---

## 🎯 ¿Qué es la Comparación Avanzada de Tablas?

El sistema ahora puede comparar tablas **celda por celda**, detectando:

- ✅ **Cambios en valores** (texto y números)
- ✅ **Cambios numéricos** (diferencia absoluta)
- ✅ **Cambios porcentuales** (ej: +50%, -20%)
- ✅ **Filas añadidas/eliminadas**
- ✅ **Columnas añadidas/eliminadas**
- ✅ **Estadísticas completas** de cambios

---

## 📊 Ejemplo de Comparación

### Tabla v1:

| Campo | Valor | Unidad |
|-------|-------|--------|
| Voltaje | 220 | V |
| Frecuencia | 50 | Hz |
| Potencia | 1000 | W |

### Tabla v2:

| Campo | Valor | Unidad |
|-------|-------|--------|
| Voltaje | 220 | V |
| Frecuencia | 60 | Hz |
| Potencia | 1500 | W |
| Factor | 0.95 | - |

---

### Resultado de Comparación:

```markdown
## 📊 Tabla 1

### Resumen de Cambios

Tabla 'Tabla 1':
  - Total celdas comparadas: 12
  - Celdas modificadas: 2 (16.7%)
  - Filas añadidas: 1
  - Columnas añadidas: 0

### Cambios Celda por Celda

| Fila | Columna | v1 | v2 | Cambio |
|------|---------|----|----|--------|
| Fila 1 | Frecuencia | 50 | 60 | +10 (+20.0%) |
| Fila 2 | Potencia | 1000 | 1500 | +500 (+50.0%) |

### ➕ Filas Añadidas

Se añadieron 1 filas nuevas.
- Fila 3: Factor = 0.95
```

---

## 🚀 Cómo Usar

### Método 1: Comparar Documentos Completos (con tablas)

```bash
cd ~/analisis-documentos-ia
source venv/bin/activate

# Comparar documento completo (incluye tablas automáticamente)
python document_analyzer.py compare-all doc_v1.pdf doc_v2.pdf > reporte_completo.md
```

**Genera:**
- Diff de texto (línea por línea)
- Comparación de tablas (celda por celda)
- Análisis analítico (impacto + recomendaciones)

---

### Método 2: Comparar Solo Tablas

```bash
# Usar el comparador de tablas directamente
python table_comparator.py doc_v1.pdf doc_v2.pdf > reporte_tablas.md
```

**Genera:**
- Solo comparación de tablas
- Celda por celda
- Estadísticas completas

---

### Método 3: Python (Programático)

```python
from document_analyzer import DocumentAnalyzer

# Inicializar
analyzer = DocumentAnalyzer()

# Comparar con tablas
report = analyzer.compare_chapters(
    "doc_v1.pdf",
    "doc_v2.pdf",
    "E14",
    use_kb=True
)

# El reporte incluye automáticamente la comparación de tablas
print(report)
```

---

### Método 4: Usar Comparador de Tablas Directo

```python
from table_comparator import TableComparator

# Inicializar
comparator = TableComparator()

# Comparar todas las tablas
comparisons = comparator.compare_all_tables("doc_v1.pdf", "doc_v2.pdf")

# Ver resultados
for comp in comparisons:
    print(comp.summary)
    
    # Cambios numéricos
    for change in comp.changes:
        if change.numeric_change is not None:
            print(f"Celda [{change.row}, {change.header}]: {change.numeric_change:+.2f}")
```

---

## 📋 Tipos de Cambios Detectados

### 1. **Cambios en Celdas**

```python
Celda [2, "Potencia"]:
  v1: 1000
  v2: 1500
  Cambio absoluto: +500
  Cambio porcentual: +50.0%
```

### 2. **Filas Añadidas**

```python
Fila 4 AÑADIDA:
  Campo: "Backup"
  Valor: "Si"
  Unidad: "-"
```

### 3. **Filas Eliminadas**

```python
Fila 3 ELIMINADA:
  Campo: "Legacy"
  Valor: "No"
```

### 4. **Columnas Añadidas**

```python
Columna "Certificación" AÑADIDA
  Nuevos valores en todas las filas
```

### 5. **Columnas Eliminadas**

```python
Columna "Deprecated" ELIMINADA
  Contenía X valores
```

---

## 🎨 Formato del Reporte

El sistema genera reportes en **markdown** con:

### Sección 1: Estadísticas Globales

```markdown
## 📊 Estadísticas Generales

### Cambios en Texto
| Métrica | Valor |
|---------|-------|
| Equal | 234 (70.3%) |
| Modified | 48 (14.4%) |
| Added | 38 (11.4%) |
| Deleted | 13 (3.9%) |

### Cambios en Tablas
Total de tablas comparadas: 3

**Tabla 1:**
- Celdas modificadas: 5
- Filas añadidas: 2

**Tabla 2:**
- Celdas modificadas: 0
```

---

### Sección 2: Cambios Detallados

```markdown
## 📝 FRENTE 1: Cambios Detallados

### Cambios en Texto (muestra)
[Diff línea por línea del texto]

### Cambios en Tablas (Celda por Celda)

#### 📊 Tabla 1

| Fila | Columna | v1 | v2 | Cambio |
|------|---------|----|----|--------|
| Fila 2 | Voltaje | 110 | 220 | +110 (+100.0%) |
| Fila 3 | Corriente | 5 | 3 | -2 (-40.0%) |
```

---

### Sección 3: Análisis Analítico

```markdown
## 📈 FRENTE 2: Análisis Analítico

### Resumen Ejecutivo

La versión 2.0 introduce cambios significativos en las 
especificaciones técnicas:

- Voltaje duplicado (110V → 220V)
- Corriente reducida en 40%
- Nueva tabla de certificaciones añadida

### Análisis de Impacto

IMPACTO ALTO:
- Cambio de voltaje requiere actualización de infraestructura
- Reducción de corriente mejora eficiencia
- Nuevas certificaciones implican validación

### Recomendaciones

1. Auditoría eléctrica antes de implementar cambios de voltaje
2. Validar certificaciones con proveedores
3. Actualizar documentación técnica
```

---

## 🔍 Detección Inteligente de Números

El sistema detecta y analiza **cambios numéricos** automáticamente:

### Formatos Soportados:

```python
"100"           → 100.0
"1,000"         → 1000.0
"$1,500.50"     → 1500.50
"+50"           → 50.0
"-20%"          → -20.0
"3.14"          → 3.14
```

### Análisis Automático:

```python
v1: "1,000 watts"
v2: "1,500 watts"

Resultado:
  Cambio absoluto: +500
  Cambio porcentual: +50.0%
```

---

## 📊 Estadísticas Disponibles

Para cada tabla comparada:

```python
{
    'equal': 45,           # Celdas sin cambios
    'modified': 5,         # Celdas modificadas
    'added_rows': 2,       # Filas añadidas
    'deleted_rows': 1,     # Filas eliminadas
    'added_cols': 1,       # Columnas añadidas
    'deleted_cols': 0      # Columnas eliminadas
}
```

---

## 🎯 Casos de Uso

### Caso 1: Comparar Especificaciones Técnicas

```bash
# Documento con tablas de specs
python document_analyzer.py compare \\
    especificaciones_v1.pdf \\
    especificaciones_v2.pdf \\
    "Requerimientos tecnología"
```

**Detecta:**
- Cambios en valores técnicos (voltaje, frecuencia, etc.)
- Nuevos requisitos añadidos
- Requisitos deprecados

---

### Caso 2: Comparar Presupuestos

```bash
# Documentos con tablas de costos
python table_comparator.py presupuesto_2025.pdf presupuesto_2026.pdf
```

**Detecta:**
- Incrementos/decrementos de costos
- Porcentajes de cambio
- Nuevas partidas presupuestarias

---

### Caso 3: Comparar Inventarios

```bash
python table_comparator.py inventario_ene.pdf inventario_feb.pdf
```

**Detecta:**
- Ítems añadidos
- Ítems eliminados
- Cambios en cantidades

---

## ⚙️ Personalización Avanzada

### Ajustar Precisión de Detección Numérica:

Editar `table_comparator.py`, método `_extract_number`:

```python
def _extract_number(self, text: str) -> Optional[float]:
    # Agregar más formatos personalizados
    # Por ejemplo, formatos con símbolos específicos
    text = text.replace('€', '').replace('£', '')
    # ... resto del código
```

### Cambiar Formato de Tabla en Reporte:

Editar `table_comparator.py`, método `format_table_report`:

```python
def format_table_report(self, comparison: TableComparison) -> str:
    # Personalizar formato markdown
    # Agregar más columnas, cambiar estilo, etc.
    pass
```

---

## 🐛 Troubleshooting

### "No se pudieron extraer tablas"

**Causa:** DocLing no detectó tablas en el documento

**Soluciones:**
1. Verificar que el PDF tenga tablas reales (no imágenes)
2. Usar un PDF con mejor formato
3. Convertir tablas de imagen a texto

---

### "Cambios numéricos no detectados"

**Causa:** Formato numérico no reconocido

**Solución:**
Editar `_extract_number` para soportar tu formato específico:

```python
# Ejemplo: soporte para formato europeo (1.000,50)
text = text.replace('.', '')  # Quitar separador de miles
text = text.replace(',', '.')  # Coma como decimal
```

---

### "Tablas desalineadas en comparación"

**Causa:** Tablas con estructuras muy diferentes

**Solución:**
El sistema compara por posición. Si las tablas tienen estructuras 
muy diferentes, considera:
1. Estandarizar formato de tablas entre versiones
2. Usar comparación de documentos completos (menos estricto)

---

## 📈 Mejoras Futuras Opcionales

Si necesitas aún más funcionalidad:

1. **Visualización gráfica** de cambios en tablas (con colores)
2. **Exportar a Excel** con cambios resaltados
3. **Comparación semántica** de tablas (no solo por posición)
4. **Detección de tablas transpuestas**

---

## ✅ Sistema Completo

Con la Fase 5 implementada, el sistema ahora ofrece:

- ✅ Base de conocimientos (ChromaDB)
- ✅ Detección inteligente de capítulos
- ✅ Comparación de texto (línea por línea)
- ✅ **Comparación de tablas (celda por celda)** ⭐ NUEVO
- ✅ Análisis analítico con IA
- ✅ Reportes completos en markdown

**¡Sistema 100% funcional y completo!** 🚀

---

*Documentación actualizada: 8 de Septiembre de 2026*
